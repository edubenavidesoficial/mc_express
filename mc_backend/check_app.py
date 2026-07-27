import traceback
import sys


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
        "OpenAPI schema",
        lambda: len(__import__("app.main", fromlist=["app"]).app.openapi()["paths"]),
    )
    check_step(
        "Passenger WSGI",
        lambda: type(
            __import__("passenger_wsgi", fromlist=["application"]).application
        ).__name__,
    )

    def check_wsgi_response(path="/api/v1/health"):
        from io import BytesIO

        from passenger_wsgi import application

        response = {}

        def start_response(status, headers, exc_info=None):
            response["status"] = status
            response["headers"] = headers

        environ = {
            "REQUEST_METHOD": "GET",
            "SCRIPT_NAME": "",
            "PATH_INFO": path,
            "QUERY_STRING": "",
            "SERVER_NAME": "mc.ingealimite.com",
            "SERVER_PORT": "443",
            "SERVER_PROTOCOL": "HTTP/1.1",
            "wsgi.version": (1, 0),
            "wsgi.url_scheme": "https",
            "wsgi.input": BytesIO(b""),
            "wsgi.errors": sys.stderr,
            "wsgi.multithread": False,
            "wsgi.multiprocess": True,
            "wsgi.run_once": False,
        }
        body = b"".join(application(environ, start_response)).decode("utf-8")
        return f"{response.get('status')} {body}"

    check_step("WSGI health request", check_wsgi_response)
    check_step("WSGI docs request", lambda: check_wsgi_response("/docs"))

    print("\nAPP_CHECK_OK")


if __name__ == "__main__":
    main()
