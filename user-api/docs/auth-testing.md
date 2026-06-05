# Pruebas de Autenticación JWT y Seguridad en el Backend

Este documento detalla la arquitectura de seguridad implementada en el backend (`user-api`) para la autenticación de usuarios por medio de JSON Web Tokens (JWT) y encriptación de contraseñas con `bcryptjs`, y explica cómo utilizar el script automatizado de pruebas `test-auth.sh`.

---

## 1. Funcionamiento del Script de Pruebas (`test-auth.sh`)

El script de pruebas interactivo está diseñado para ejecutarse en la terminal (incluyendo entornos móviles como Termux) y valida de forma visual todo el ciclo de vida de la autenticación de la API.

### Cómo ejecutar el script
1. Asegúrate de tener el servidor backend encendido y escuchando en el puerto `3000`:
   ```bash
   npm run start:dev
   ```
2. En otra terminal, ejecuta el script en la raíz del proyecto backend:
   ```bash
   ./test-auth.sh
   ```

### Secuencia de Escenarios de Prueba

El script ejecuta 7 pruebas secuenciales ordenadas lógicamente:

| # | Prueba | Método HTTP / Ruta | Entrada típica | Código Esperado | Propósito |
|---|--------|---------------------|----------------|-----------------|-----------|
| **1** | Conectividad | `GET /api` | Ninguna | `200` o `404` | Validar que el servidor de NestJS esté activo y respondiendo. |
| **2** | Denegación sin Token | `GET /users` | Sin cabeceras | `401 Unauthorized` | Verificar que el endpoint de consulta esté protegido por defecto. |
| **3** | Login Fallido | `POST /auth/login` | Credenciales incorrectas | `401 Unauthorized` | Validar que no se emitan tokens a credenciales inválidas. |
| **4** | Registro de Usuario | `POST /users` | Email timestamped y contraseña plana | `201 Created` | Crear una cuenta nueva de prueba que será encriptada automáticamente. |
| **5** | Login Exitoso | `POST /auth/login` | Email y contraseña correctas | `201 Created` | Validar credenciales correctas y recibir el token JWT en formato JSON. |
| **6** | Consulta con JWT | `GET /users` | Cabecera `Authorization: Bearer <token>` | `200 OK` | Validar que el Guardián permita el acceso al enviar un JWT válido. |
| **7** | Logout en Servidor | `POST /auth/logout` | Cabecera `Authorization: Bearer <token>` | `200 OK` | Invalida el JWT de forma permanente registrándolo en la blacklist del servidor. |
| **8** | Consulta tras Logout | `GET /users` | El mismo token JWT ya invalidado | `401 Unauthorized` | Comprobar que el Guardián rechaza el acceso y lanza error "Token inválido (sesión cerrada)". |

---

## 2. Explicación Técnica de la Arquitectura de Seguridad

### Hashing y Almacenamiento Seguro de Contraseñas
Para evitar que las contraseñas se visualicen en texto claro en la base de datos o queden expuestas accidentalmente, se implementaron dos capas de protección en NestJS:

1. **Encriptación Irreversible (Hashing)**:
   Se utiliza `bcryptjs` con un factor de costo de 10 rondas en `UsersService.create()`. El texto plano jamás se guarda en la base de datos.
   ```typescript
   const hashedPassword = await bcryptjs.hash(createUserDto.password, 10);
   ```

2. **Exclusión de Consultas (`select: false`)**:
   En la entidad `User` (`src/users/entities/user.entity.ts`), definimos la columna `password` con la directiva `{ select: false }`. Esto instruye a TypeORM a **no incluir** el campo `password` en consultas select normales (como `findAll` o `findOne`), evitando fugas de hashes en las respuestas REST por defecto.
   Cuando el servicio de autenticación requiere verificar la contraseña de un usuario, debe solicitarla de forma explícita mediante opciones de selección:
   ```typescript
   await this.usersRepository.findOne({
     where: { email },
     select: ['id', 'name', 'email', 'role', 'password'],
   });
   ```

### Autenticación Stateless con JWT
El sistema utiliza JSON Web Tokens (JWT) firmados digitalmente para manejar las sesiones de manera stateless (sin almacenar estados de sesión en base de datos o en memoria RAM del servidor):

1. **Firma del Token**:
   Al iniciar sesión en `POST /auth/login`, el servidor firma los datos no sensibles del usuario (`sub` (ID), `email`, y `role`) y crea un JWT.
2. **El Guardián (`AuthGuard`)**:
   El guardián `src/auth/auth.guard.ts` intercepta la petición HTTP al endpoint protegido `GET /users`, extrae el token de la cabecera `Authorization: Bearer <JWT>`, y utiliza `JwtService` para verificar la firma. Si es válido, inyecta la información decodificada del usuario en la petición (`request['user']`) para que los controladores puedan consultarla si lo desean.

### Invalidación de Sesión (Blacklist de Tokens en el Servidor)
Aunque JWT es por definición un esquema sin estado (stateless), un requisito fundamental de seguridad es invalidar el token de forma permanente cuando el usuario hace un logout explícito. Para esto se implementó un mecanismo híbrido:

1. **Tabla de Tokens Revocados**:
   Se creó la entidad `RevokedToken` (`src/auth/entities/revoked-token.entity.ts`). Al hacer `POST /auth/logout`, el token provisto es guardado en esta tabla.
2. **Intercepción del Guardián**:
   Antes de evaluar la firma y expiración del JWT, el `AuthGuard` consulta al servicio si el token recibido existe en la tabla de revocados. Si es así, se aborta la petición de inmediato retornando un código `401` y el mensaje de error explicativo:
   ```json
   {
     "message": "Token inválido (sesión cerrada)",
     "error": "Unauthorized",
     "statusCode": 401
   }
   ```
   Esto asegura que un token comprometido o del cual se haya hecho cierre de sesión no pueda volver a ser reutilizado, resolviendo el riesgo de secuestro de tokens de sesión.

### Mitigación de Ataques y Secuestros en el Navegador
En aplicaciones web comerciales (frontend), la colocación del token JWT es crítica:
* **Secuestro (XSS/CSRF)**: Si el token se almacena en `localStorage`, un ataque Cross-Site Scripting (XSS) podría leerlo. Para prevenirlo, la recomendación de producción es devolver el token en una cookie HTTP-only con la directiva `Secure` y `SameSite=Strict`. Esto previene que scripts Javascript accedan al token en el navegador. En el backend actual, entregamos el JWT en el cuerpo JSON del login (`access_token`) para permitir flexibilidad, permitiendo que el script de pruebas lo capture fácilmente.
