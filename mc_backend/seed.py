from app.core.security import hash_password
from app.db.session import Base, SessionLocal, engine
from app.models.entities import Professional, ServiceCategory, User


def run():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        categories = ["Albañiles", "Jardineros", "Plomeros", "Electricistas", "Pintores", "Más"]
        for name in categories:
            exists = db.query(ServiceCategory).filter(ServiceCategory.name == name).first()
            if not exists:
                db.add(ServiceCategory(name=name, icon=name.lower()))
        db.commit()

        admin = db.query(User).filter(User.phone == "0999999999").first()
        if not admin:
            admin = User(
                full_name="Administrador MC",
                phone="0999999999",
                email="admin@mc.ingealimite.com",
                password_hash=hash_password("Cambiar123!"),
                role="admin",
            )
            db.add(admin)
            db.commit()

        plumber_category = (
            db.query(ServiceCategory).filter(ServiceCategory.name == "Plomeros").first()
        )
        professional_user = db.query(User).filter(User.phone == "0988888888").first()
        if not professional_user:
            professional_user = User(
                full_name="Carlos M.",
                phone="0988888888",
                email="carlos@mc.ingealimite.com",
                password_hash=hash_password("Cambiar123!"),
                role="professional",
            )
            db.add(professional_user)
            db.commit()
            db.refresh(professional_user)

        professional = (
            db.query(Professional)
            .filter(Professional.user_id == professional_user.id)
            .first()
        )
        if not professional and plumber_category:
            db.add(
                Professional(
                    user_id=professional_user.id,
                    category_id=plumber_category.id,
                    bio="Plomero certificado disponible para emergencias.",
                    rating=4.9,
                    total_jobs=312,
                    base_price=28,
                    is_available=True,
                )
            )
            db.commit()
    finally:
        db.close()


if __name__ == "__main__":
    run()
