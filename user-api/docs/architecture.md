# Arquitectura de Software - Backend (NestJS)

Este proyecto está construido siguiendo los estándares oficiales de la arquitectura de **NestJS**, dividiendo la aplicación en módulos cohesivos y estructurando el acceso a datos mediante el **Patrón Repositorio**.

---

## 1. Módulos y Organización

La estructura del código está organizada de forma modular:

* **AppModule (`src/app.module.ts`)**: Módulo raíz que centraliza la configuración de la base de datos a nivel global y registra los módulos de negocio.
* **UsersModule (`src/users/users.module.ts`)**: Encapsula el dominio de usuarios. Define los controladores, servicios e importa el repositorio de base de datos específico para la entidad `User`.

---

## 2. Flujo de Datos y Capas

El flujo de peticiones sigue una arquitectura de capas bien delimitada:

```
 Petición HTTP  ──> [ Controller ] ──> [ Service ] ──> [ Repository ] ──> Base de Datos
                      (Rutas)          (Negocio)       (Abstracción)
```

1. **Controlador (`users.controller.ts`)**:
   * Responsable de recibir las peticiones HTTP (GET, POST, PATCH, DELETE).
   * Valida la entrada mediante DTOs.
   * Delega el trabajo al servicio y retorna las respuestas en formato JSON.
2. **Servicio (`users.service.ts`)**:
   * Implementa la lógica de negocio y las reglas del dominio.
   * Es completamente asíncrono (`async/await`) y agnóstico de la base de datos final.
3. **Repositorio (`Repository<User>` inyectado)**:
   * Proporcionado por **TypeORM**.
   * Encapsula los accesos directos de lectura/escritura (SQL) en métodos sencillos de TypeScript (`find()`, `save()`, `remove()`).
4. **Entidad (`entities/user.entity.ts`)**:
   * Mapea la estructura de la tabla de la base de datos usando decoradores de TypeORM (`@Entity()`, `@Column()`).

---

## 3. Beneficios de esta Arquitectura

* **Independencia del Motor de Base de Datos**: Gracias al patrón Repositorio y TypeORM, el código de negocio no escribe código SQL específico. Si mañana decidimos cambiar el motor de base de datos, la lógica del servicio permanece 100% inalterada.
* **Facilidad para Depurar**:
  * Errores de API/Rutas/Validación $\rightarrow$ Se buscan en `users.controller.ts`.
  * Errores de reglas de negocio $\rightarrow$ Se buscan en `users.service.ts`.
  * Errores de columnas de tabla o índices $\rightarrow$ Se buscan en `user.entity.ts`.
