# Configuración y Migración de Base de Datos (TypeORM)

Este backend utiliza **TypeORM** como ORM para mapear entidades TypeScript con tablas relacionales.

---

## 1. Configuración Actual: SQLite (sql.js)

Para facilitar el desarrollo local sin necesidad de instalar o configurar servidores externos en Termux, el proyecto utiliza por defecto **`sql.js`** (una implementación de SQLite basada en WebAssembly y puro JavaScript):

* **Tipo**: `sqljs`
* **Persistencia**: Se almacena en el archivo local `db.sqlite` en la raíz del proyecto backend.
* **Auto-guardado**: Sincroniza automáticamente los datos de memoria al archivo tras cada operación (`autoSave: true`).
* **Sincronización**: Auto-crea y altera las tablas de base de datos según nuestras entidades de TypeScript en desarrollo (`synchronize: true`).

---

## 2. Instrucciones para cambiar a PostgreSQL

Para cambiar el motor de base de datos a **PostgreSQL** en producción o desarrollo local, seguí estos sencillos pasos:

### Paso 1: Instalar PostgreSQL (si no lo tenés instalado)
En Termux/Linux:
```bash
pkg install postgresql
# Inicializar base de datos (solo la primera vez)
initdb $PREFIX/var/lib/postgresql
# Iniciar servidor local
pg_ctl -D $PREFIX/var/lib/postgresql start
# Crear base de datos de la app
createdb user_db
```

### Paso 2: Cambiar la configuración en `src/app.module.ts`
Abrí [app.module.ts](file:///data/data/com.termux/files/home/user-api/src/app.module.ts) y reemplazá la inicialización de TypeORM:

#### Configuración Anterior (SQLite):
```typescript
TypeOrmModule.forRoot({
  type: 'sqljs',
  location: 'db.sqlite',
  autoSave: true,
  entities: [User],
  synchronize: true,
})
```

#### Nueva Configuración (PostgreSQL):
```typescript
TypeOrmModule.forRoot({
  type: 'postgres',
  host: 'localhost',      // Dirección del servidor
  port: 5432,             // Puerto por defecto
  username: 'postgres',   // Tu usuario de postgres
  password: 'tu_password',// Tu contraseña
  database: 'user_db',    // Nombre de la base de datos creada
  entities: [User],
  synchronize: true,      // true en desarrollo, false en producción (usar migraciones)
})
```

### Paso 3: Reiniciar el Servidor
Una vez cambiada la configuración en `app.module.ts`, reiniciá el servidor NestJS:
```bash
npm run start
```
TypeORM se conectará al servidor de PostgreSQL y creará la tabla `user` automáticamente en base a tu entidad.
No es necesario tocar ninguna línea de código en tus controladores ni en tus servicios gracias al **Patrón Repositorio**.
