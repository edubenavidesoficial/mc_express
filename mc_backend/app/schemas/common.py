from decimal import Decimal
from datetime import datetime

from pydantic import BaseModel


class CategoryOut(BaseModel):
    id: int
    name: str
    icon: str | None = None

    model_config = {"from_attributes": True}


class ProfessionalOut(BaseModel):
    id: int
    category_id: int
    full_name: str
    category: str
    rating: Decimal
    total_jobs: int
    base_price: Decimal
    is_available: bool

    model_config = {"from_attributes": True}


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


class ServiceRequestDetailOut(BaseModel):
    id: int
    status: str
    category_id: int
    category: str
    professional_id: int | None = None
    professional_name: str | None = None
    description: str
    address: str
    estimated_price: Decimal | None = None
    created_at: datetime

    model_config = {"from_attributes": True}


class PaymentCreate(BaseModel):
    amount: Decimal
    method: str
    status: str = "paid"


class WalletRechargeCreate(BaseModel):
    user_id: int
    amount: Decimal
    reference: str | None = None


class WalletPaymentCreate(BaseModel):
    user_id: int
    service_request_id: int
    amount: Decimal


class WalletOut(BaseModel):
    balance: Decimal


class WalletTransactionOut(BaseModel):
    id: int
    amount: Decimal
    type: str
    status: str
    reference: str | None = None
    created_at: datetime

    model_config = {"from_attributes": True}


class ReviewCreate(BaseModel):
    client_id: int
    professional_id: int
    rating: int
    comment: str | None = None
