from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.core.security import create_access_token, hash_password, verify_password
from app.db.session import get_db
from app.models.entities import User

router = APIRouter()


class LoginIn(BaseModel):
    phone: str
    password: str


class RegisterIn(BaseModel):
    full_name: str
    phone: str
    email: str | None = None
    password: str


def auth_response(user: User):
    return {
        "access_token": create_access_token(str(user.id)),
        "token_type": "bearer",
        "user": {"id": user.id, "name": user.full_name, "role": user.role},
    }


@router.post("/register")
def register(payload: RegisterIn, db: Session = Depends(get_db)):
    exists = db.query(User).filter(User.phone == payload.phone).first()
    if exists:
        raise HTTPException(status_code=409, detail="El telefono ya esta registrado")
    user = User(
        full_name=payload.full_name,
        phone=payload.phone,
        email=payload.email,
        password_hash=hash_password(payload.password),
        role="client",
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return auth_response(user)


@router.post("/login")
def login(payload: LoginIn, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.phone == payload.phone).first()
    if not user or not verify_password(payload.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Credenciales invalidas")
    return auth_response(user)
