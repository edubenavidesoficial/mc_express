from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.entities import Professional, ServiceCategory, ServiceRequest, User
from app.schemas.common import (
    CategoryOut,
    ProfessionalOut,
    ServiceRequestCreate,
    ServiceRequestOut,
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
