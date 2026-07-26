import traceback


def check_step(label, callback):
    print(f"\n== {label} ==")
    try:
        result = callback()
        if result is not None:
            print(result)
        print("OK")
    except Exception:
        traceback.print_exc()
        raise


def main():
    check_step(
        "Settings",
        lambda: __import__("app.core.config", fromlist=["settings"]).settings.app_name,
    )

    def check_db():
        from sqlalchemy import text

        from app.db.session import engine

        with engine.connect() as connection:
            return connection.execute(text("SELECT 1")).scalar()

    check_step("Database", check_db)
    check_step("FastAPI app", lambda: __import__("app.main", fromlist=["app"]).app.title)
    check_step(
        "Passenger WSGI",
        lambda: type(
            __import__("passenger_wsgi", fromlist=["application"]).application
        ).__name__,
    )

    print("\nAPP_CHECK_OK")


if __name__ == "__main__":
    main()
