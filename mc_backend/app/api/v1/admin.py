from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.entities import Payment, Professional, ServiceRequest, User

router = APIRouter()


@router.get("/dashboard")
def dashboard(db: Session = Depends(get_db)):
    return {
        "users": db.query(User).count(),
        "professionals": db.query(Professional).count(),
        "requests": db.query(ServiceRequest).count(),
        "payments": db.query(Payment).count(),
    }


@router.get("/requests")
def requests(db: Session = Depends(get_db)):
    return [
        {
            "id": item.id,
            "status": item.status,
            "address": item.address,
            "estimated_price": str(item.estimated_price or "0.00"),
            "created_at": item.created_at,
        }
        for item in db.query(ServiceRequest)
        .order_by(ServiceRequest.created_at.desc())
        .limit(50)
        .all()
    ]
