from pathlib import Path
import sys

from a2wsgi import ASGIMiddleware

BASE_DIR = Path(__file__).resolve().parent
if str(BASE_DIR) not in sys.path:
    sys.path.insert(0, str(BASE_DIR))

from app.main import app

application = ASGIMiddleware(app)
