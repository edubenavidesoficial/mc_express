from decimal import Decimal

from pydantic import BaseModel


class CategoryOut(BaseModel):
    id: int
    name: str
    icon: str | None = None

    model_config = {"from_attributes": True}


class ProfessionalOut(BaseModel):
    id: int
    full_name: str
    category: str
    rating: Decimal
    total_jobs: int
    base_price: Decimal
    is_available: bool


class ServiceRequestCreate(BaseModel):
    client_id: int
    category_id: int
    professional_id: int | None = None
    description: str
    address: str
    latitude: Decimal | None = None
    longitude: Decimal | None = None
    estimated_price: Decimal | None = None


class ServiceRequestOut(BaseModel):
    id: int
    status: str

    model_config = {"from_attributes": True}
