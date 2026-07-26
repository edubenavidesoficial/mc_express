# MC Express - MySQL en cPanel

1. En cPanel crea la base de datos, por ejemplo `usuario_mc_express`.
2. Crea un usuario MySQL y asígnalo con todos los permisos.
3. En phpMyAdmin importa `database/schema.sql`.
4. Si cPanel agrega prefijo al nombre de la base, actualiza `backend/.env`.
5. Cambia la clave inicial del admin después del primer ingreso.

Ejemplo de `DATABASE_URL`:

```env
DATABASE_URL=mysql+pymysql://usuario_db:password@localhost/usuario_mc_express?charset=utf8mb4
```
