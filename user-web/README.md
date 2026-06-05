# Frontend - Arquitectura y Guía Organizacional (Svelte 5)

Este proyecto frontend está diseñado con una **Arquitectura Basada en Features** (Feature-Based Architecture) sobre **SvelteKit** y **Svelte 5**. Esta estructura organiza el código por dominio de negocio (característica) en lugar de tipo de archivo técnico, facilitando la escalabilidad y la localización de errores.

---

## 1. Estructura de Carpetas

```
src/
├── lib/
│   ├── components/            # Componentes de UI comunes y reutilizables globales (ej: botones, inputs)
│   │   └── test/              # Componentes temporales de prueba
│   ├── types/                 # Tipos y esquemas globales de TypeScript
│   │   └── api.generated.ts    # Tipos de DTOs y Entidades autogenerados por Swagger
│   ├── utils/                 # Funciones de ayuda generales (formateadores, validadores)
│   └── features/              # Dominios de negocio (Features)
│       ├── auth/              # Módulo de Autenticación (Login, registro, sesión)
│       │   ├── components/    # Componentes específicos de Auth (ej: LoginForm.svelte)
│       │   ├── services/      # auth-api.ts (Peticiones fetch de autenticación)
│       │   └── state/         # auth.svelte.ts (Estado global reactivo de la sesión en Svelte 5)
│       ├── dashboard/         # Módulo de Dashboards
│       │   └── components/    # Dashboards específicos por rol (AdminDashboard, etc.)
│       └── users/             # Módulo de administración de usuarios
│           ├── components/    # Componentes específicos de usuarios (ej: UserTable.svelte)
│           └── services/      # users-api.ts (Peticiones fetch de usuarios al backend)
└── routes/                    # Sistema de páginas de SvelteKit (enrutador basado en archivos)
    ├── +layout.svelte         # Layout global común
    ├── +page.svelte           # Página Principal de pruebas (sandbox interactivo)
    └── test-page/
        └── +page.svelte       # Página Secundaria de pruebas
```

---

## 2. Integración con Swagger (Tipos Compartidos)

Para no tener que redefinir DTOs y Entidades a mano en el frontend, se utiliza **Swagger/OpenAPI** generado por el backend:

1. El backend (NestJS) expone el esquema de API en formato JSON/YAML.
2. Usando la herramienta `openapi-typescript` en el frontend, se compila el esquema directamente a tipos estáticos de TypeScript en `src/lib/types/api.generated.ts`.
3. Todos los componentes y servicios del frontend importan de este archivo, logrando que cualquier cambio en la estructura de la base de datos o DTOs del backend sea inmediatamente detectado en tiempo de compilación del frontend.

---

## 3. Guía para Depuración (¿Dónde buscar errores?)

* **Errores Visuales o de Diseño**: Se localizan directamente en el archivo `.svelte` del componente correspondiente:
  * Si es común (ej: un botón general), está en `src/lib/components/`.
  * Si es específico (ej: formulario de registro), está en `src/lib/features/auth/components/`.
* **Errores de Conectividad o Datos con el Backend**: Se buscan en el servicio de la feature correspondiente:
  * Ej: Si la lista de usuarios no carga, se investiga en `src/lib/features/users/services/users-api.ts`.
* **Errores de Comportamiento o Reactividad (Runes)**: Se buscan en los archivos de estado dentro de la feature:
  * Ej: Si el usuario cierra sesión pero la pantalla no cambia, el error se busca en `src/lib/features/auth/state/auth.svelte.ts`.
* **Errores de Rutas o Redirección**: Se buscan en las carpetas de `src/routes/` asociadas a esa ruta, inspeccionando los archivos `+page.svelte` o `+layout.server.ts`.
