from datetime import datetime
from decimal import Decimal

from sqlalchemy import DateTime, ForeignKey, Numeric, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.session import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    full_name: Mapped[str] = mapped_column(String(120))
    phone: Mapped[str] = mapped_column(String(30), unique=True, index=True)
    email: Mapped[str | None] = mapped_column(String(120), unique=True)
    password_hash: Mapped[str] = mapped_column(String(255))
    role: Mapped[str] = mapped_column(String(30), default="client")
    status: Mapped[str] = mapped_column(String(30), default="active")
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())


class ServiceCategory(Base):
    __tablename__ = "service_categories"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(80), unique=True)
    icon: Mapped[str | None] = mapped_column(String(80))
    is_active: Mapped[bool] = mapped_column(default=True)


class Professional(Base):
    __tablename__ = "professionals"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    category_id: Mapped[int] = mapped_column(ForeignKey("service_categories.id"))
    bio: Mapped[str | None] = mapped_column(Text)
    rating: Mapped[Decimal] = mapped_column(Numeric(3, 2), default=0)
    total_jobs: Mapped[int] = mapped_column(default=0)
    base_price: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=0)
    is_available: Mapped[bool] = mapped_column(default=True)

    user = relationship("User")
    category = relationship("ServiceCategory")


class ServiceRequest(Base):
    __tablename__ = "service_requests"

    id: Mapped[int] = mapped_column(primary_key=True)
    client_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    professional_id: Mapped[int | None] = mapped_column(ForeignKey("professionals.id"))
    category_id: Mapped[int] = mapped_column(ForeignKey("service_categories.id"))
    description: Mapped[str] = mapped_column(Text)
    address: Mapped[str] = mapped_column(String(255))
    latitude: Mapped[Decimal | None] = mapped_column(Numeric(10, 7))
    longitude: Mapped[Decimal | None] = mapped_column(Numeric(10, 7))
    estimated_price: Mapped[Decimal | None] = mapped_column(Numeric(10, 2))
    status: Mapped[str] = mapped_column(String(30), default="pending")
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())


class Payment(Base):
    __tablename__ = "payments"

    id: Mapped[int] = mapped_column(primary_key=True)
    service_request_id: Mapped[int] = mapped_column(ForeignKey("service_requests.id"))
    amount: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    method: Mapped[str] = mapped_column(String(40))
    status: Mapped[str] = mapped_column(String(30), default="pending")
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())


class WalletTransaction(Base):
    __tablename__ = "wallet_transactions"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    amount: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    type: Mapped[str] = mapped_column(String(30))
    status: Mapped[str] = mapped_column(String(30), default="completed")
    reference: Mapped[str | None] = mapped_column(String(120))
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())


class Review(Base):
    __tablename__ = "reviews"

    id: Mapped[int] = mapped_column(primary_key=True)
    service_request_id: Mapped[int] = mapped_column(ForeignKey("service_requests.id"))
    client_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    professional_id: Mapped[int] = mapped_column(ForeignKey("professionals.id"))
    rating: Mapped[int]
    comment: Mapped[str | None] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
