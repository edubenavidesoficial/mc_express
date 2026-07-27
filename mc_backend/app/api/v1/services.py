from decimal import Decimal

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.entities import (
    Payment,
    Professional,
    Review,
    ServiceCategory,
    ServiceRequest,
    User,
    WalletTransaction,
)
from app.schemas.common import (
    CategoryOut,
    PaymentCreate,
    ProfessionalOut,
    ReviewCreate,
    ServiceRequestCreate,
    ServiceRequestDetailOut,
    ServiceRequestOut,
    WalletOut,
    WalletPaymentCreate,
    WalletRechargeCreate,
    WalletTransactionOut,
)

router = APIRouter()


@router.get("/categories", response_model=list[CategoryOut])
def categories(db: Session = Depends(get_db)):
    return db.query(ServiceCategory).filter(ServiceCategory.is_active == True).all()


@router.get("/professionals", response_model=list[ProfessionalOut])
def professionals(category_id: int | None = None, db: Session = Depends(get_db)):
    query = (
        db.query(Professional, User, ServiceCategory)
        .join(User, Professional.user_id == User.id)
        .join(ServiceCategory, Professional.category_id == ServiceCategory.id)
        .filter(Professional.is_available == True)
    )
    if category_id:
        query = query.filter(Professional.category_id == category_id)
    return [
        ProfessionalOut(
            id=professional.id,
            category_id=category.id,
            full_name=user.full_name,
            category=category.name,
            rating=professional.rating,
            total_jobs=professional.total_jobs,
            base_price=professional.base_price,
            is_available=professional.is_available,
        )
        for professional, user, category in query.all()
    ]


@router.post("/requests", response_model=ServiceRequestOut)
def create_request(payload: ServiceRequestCreate, db: Session = Depends(get_db)):
    request = ServiceRequest(**payload.model_dump())
    db.add(request)
    db.commit()
    db.refresh(request)
    return request


def _request_detail(item: ServiceRequest, db: Session) -> ServiceRequestDetailOut:
    category = db.get(ServiceCategory, item.category_id)
    professional_name = None
    if item.professional_id:
        professional = db.get(Professional, item.professional_id)
        if professional:
            professional_user = db.get(User, professional.user_id)
            professional_name = professional_user.full_name if professional_user else None
    return ServiceRequestDetailOut(
        id=item.id,
        status=item.status,
        category_id=item.category_id,
        category=category.name if category else "Servicio",
        professional_id=item.professional_id,
        professional_name=professional_name,
        description=item.description,
        address=item.address,
        estimated_price=item.estimated_price,
        created_at=item.created_at,
    )


@router.get("/requests", response_model=list[ServiceRequestDetailOut])
def requests(client_id: int, db: Session = Depends(get_db)):
    items = (
        db.query(ServiceRequest)
        .filter(ServiceRequest.client_id == client_id)
        .order_by(ServiceRequest.created_at.desc())
        .limit(50)
        .all()
    )
    return [_request_detail(item, db) for item in items]


@router.get("/requests/{request_id}", response_model=ServiceRequestDetailOut)
def request_detail(request_id: int, db: Session = Depends(get_db)):
    item = db.get(ServiceRequest, request_id)
    if item is None:
        raise HTTPException(status_code=404, detail="Solicitud no encontrada")
    return _request_detail(item, db)


@router.post("/requests/{request_id}/status", response_model=ServiceRequestOut)
def update_request_status(
    request_id: int,
    status: str,
    db: Session = Depends(get_db),
):
    item = db.get(ServiceRequest, request_id)
    if item is None:
        raise HTTPException(status_code=404, detail="Solicitud no encontrada")
    item.status = status
    db.commit()
    db.refresh(item)
    return item


def _wallet_balance(user_id: int, db: Session):
    transactions = (
        db.query(WalletTransaction)
        .filter(WalletTransaction.user_id == user_id)
        .filter(WalletTransaction.status == "completed")
        .all()
    )
    balance = Decimal("0.00")
    for item in transactions:
        if item.type in ("recharge", "refund"):
            balance += item.amount
        if item.type == "debit":
            balance -= item.amount
    return balance


@router.get("/wallet/{user_id}", response_model=WalletOut)
def wallet(user_id: int, db: Session = Depends(get_db)):
    return WalletOut(balance=_wallet_balance(user_id, db))


@router.post("/wallet/recharge", response_model=WalletTransactionOut)
def recharge(payload: WalletRechargeCreate, db: Session = Depends(get_db)):
    transaction = WalletTransaction(
        user_id=payload.user_id,
        amount=payload.amount,
        type="recharge",
        status="completed",
        reference=payload.reference or "app_recharge",
    )
    db.add(transaction)
    db.commit()
    db.refresh(transaction)
    return transaction


@router.post("/wallet/pay", response_model=WalletOut)
def wallet_pay(payload: WalletPaymentCreate, db: Session = Depends(get_db)):
    if _wallet_balance(payload.user_id, db) < payload.amount:
        raise HTTPException(status_code=409, detail="Saldo insuficiente")
    db.add(
        WalletTransaction(
            user_id=payload.user_id,
            amount=payload.amount,
            type="debit",
            status="completed",
            reference=f"service_request:{payload.service_request_id}",
        )
    )
    db.add(
        Payment(
            service_request_id=payload.service_request_id,
            amount=payload.amount,
            method="wallet",
            status="paid",
        )
    )
    request = db.get(ServiceRequest, payload.service_request_id)
    if request:
        request.status = "completed"
    db.commit()
    return WalletOut(balance=_wallet_balance(payload.user_id, db))


@router.get("/wallet/{user_id}/transactions", response_model=list[WalletTransactionOut])
def wallet_transactions(user_id: int, db: Session = Depends(get_db)):
    return (
        db.query(WalletTransaction)
        .filter(WalletTransaction.user_id == user_id)
        .order_by(WalletTransaction.created_at.desc())
        .limit(50)
        .all()
    )


@router.post("/requests/{request_id}/payments")
def create_payment(
    request_id: int,
    payload: PaymentCreate,
    db: Session = Depends(get_db),
):
    payment = Payment(
        service_request_id=request_id,
        amount=payload.amount,
        method=payload.method,
        status=payload.status,
    )
    db.add(payment)
    request = db.get(ServiceRequest, request_id)
    if request and payload.status == "paid":
        request.status = "completed"
    db.commit()
    db.refresh(payment)
    return {"id": payment.id, "status": payment.status}


@router.post("/requests/{request_id}/reviews")
def create_review(
    request_id: int,
    payload: ReviewCreate,
    db: Session = Depends(get_db),
):
    review = Review(service_request_id=request_id, **payload.model_dump())
    db.add(review)
    db.commit()
    db.refresh(review)
    return {"id": review.id}
