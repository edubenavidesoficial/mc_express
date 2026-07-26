# MC Express Backend

Backend base en FastAPI para `mc.ingealimite.com`.

## Local

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload
```

Crear datos iniciales:

```bash
python seed.py
```

Admin inicial:

- Teléfono: `0999999999`
- Clave: `Cambiar123!`

## cPanel

1. Sube la carpeta `backend` al hosting.
2. Crea una Python App apuntando a `backend/passenger_wsgi.py`.
3. Instala `requirements.txt`.
4. Configura `.env` con los datos MySQL reales.
5. Ejecuta `python seed.py` una vez desde la terminal de cPanel.
6. El API quedará bajo `/api/v1`.
