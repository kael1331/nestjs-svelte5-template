# Compartición de Tipos y Configuración de Swagger (OpenAPI)

Este proyecto utiliza **Swagger (OpenAPI)** como puente de comunicación para compartir contratos de datos (DTOs y Entidades) entre la API backend (`user-api`) y la interfaz frontend (`user-web`), a pesar de encontrarse en carpetas aisladas y sin utilizar un esquema de monorepo.

---

## 1. Concepto y Funcionamiento

En lugar de copiar clases TypeScript de una carpeta a otra, lo que rompería la compilación del frontend por culpa de los decoradores propios de NestJS/TypeORM, se utiliza la especificación **OpenAPI**:

```
 ┌───────────────────────┐
 │   user-api (NestJS)   │
 │                       │
 │  - Define DTOs        │
 │  - Define Entidades   │
 └───────────┬───────────┘
             │
             ▼ (Genera especificación OpenAPI)
   [ http://localhost:3000/api-json ]
             │
             ▼ (Compila especificación a interfaces TS puras)
 ┌───────────┴───────────┐
 │   user-web (Svelte)   │
 │                       │
 │  - api.generated.ts   │
 └───────────────────────┘
```

---

## 2. Configuración en el Backend (`user-api`)

### Dependencias Utilizadas
* `@nestjs/swagger`: Generador integrado de NestJS.
* `swagger-ui-express`: Interfaz HTML interactiva para explorar la API.

### Inicialización (`src/main.ts`)
Swagger se configura al iniciar NestJS en [main.ts](file:///data/data/com.termux/files/home/user-api/src/main.ts):
```typescript
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

const config = new DocumentBuilder()
  .setTitle('User API')
  .setDescription('API de Gestión de Usuarios y Roles')
  .setVersion('1.0')
  .build();
const document = SwaggerModule.createDocument(app, config);
SwaggerModule.setup('api', app, document);
```
* **Endpoints expuestos**:
  * **`http://localhost:3000/api`**: Interfaz interactiva de pruebas.
  * **`http://localhost:3000/api-json`**: Contrato en formato JSON puro.

---

## 3. Mapeo de Esquemas mediante Decoradores

Para que NestJS exporte las propiedades del modelo hacia el JSON, decoramos nuestras clases con los elementos oficiales de `@nestjs/swagger`:

### Decoración de Propiedades (`@ApiProperty`)
Añadido en DTOs y Entidades para declarar el tipo y descripción de cada campo:
```typescript
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ description: 'Nombre completo del usuario' })
  name: string;
}
```

### Decoración de Controladores (`@ApiTags`, `@ApiOkResponse`, `@ApiCreatedResponse`)
Añadido en `users.controller.ts` para indicarle a Swagger qué entidad devuelve cada endpoint:
```typescript
@ApiTags('users')
@Controller('users')
export class UsersController {
  @Post()
  @ApiCreatedResponse({ type: User })
  create(...) { ... }
}
```

---

## 4. Consumo en el Frontend (`user-web`)

El frontend descarga el JSON de Swagger y lo traduce a TypeScript de la siguiente forma:

1. **Instalación**: Se utiliza el compilador de desarrollo `openapi-typescript`.
2. **Script de Generación (`package.json`)**:
   ```json
   "generate-types": "openapi-typescript http://localhost:3000/api-json -o src/lib/types/api.generated.ts"
   ```
3. **Resultado**: El comando genera el archivo [api.generated.ts](file:///data/data/com.termux/files/home/user-web/src/lib/types/api.generated.ts) que contiene interfaces limpias, listas para ser usadas en el frontend:
   ```typescript
   import type { components } from '$lib/types/api.generated';
   
   export type User = components['schemas']['User'];
   export type CreateUserDto = components['schemas']['CreateUserDto'];
   ```
