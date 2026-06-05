# Seguridad de Contraseñas y Gestión de Sesiones (Autenticación)

Este documento detalla los estándares y mecanismos de seguridad aplicados en la arquitectura del sistema para la protección de contraseñas y la prevención de secuestro de sesiones en el frontend y backend.

---

## 1. Seguridad de Contraseñas (Password Hashing)

### El problema del Texto Plano
Guardar contraseñas en texto plano es una vulnerabilidad crítica. Si la base de datos se ve comprometida, todas las contraseñas quedarían expuestas. 

### La Solución: Bcryptjs y Salting
Utilizaremos la librería **`bcryptjs`** para encriptar las contraseñas.
* **Salting (Salado)**: Bcrypt asocia un valor aleatorio único (la "sal") a la contraseña antes de aplicarle el algoritmo de hash. Esto evita ataques de diccionario y el uso de "Rainbow Tables" (tablas precomputadas de hashes).
* **Función de Hash Lenta (Key Stretching)**: Bcrypt es computacionalmente costoso por diseño. Retarda los intentos de fuerza bruta, haciendo que sea extremadamente lento para un atacante intentar millones de contraseñas por segundo.
* **Verificación segura**: Durante el login, el servidor toma la contraseña en texto plano, recupera la sal y el hash almacenados de la base de datos, aplica la función, y compara los resultados de manera segura (evitando ataques de sincronización/timing attacks).

---

## 2. Protección en Base de Datos y Memoria (RAM)

### Ocultamiento en Base de Datos (TypeORM `{ select: false }`)
En la entidad de base de datos `User`, la propiedad `password` se define de la siguiente manera:
```typescript
@Column({ select: false })
password: string;
```
* **Qué hace**: Esta configuración le indica a TypeORM que, por defecto, **excluya** la columna `password` de todas las consultas SQL (`find()`, `findOneBy()`, etc.).
* **Por qué es necesario**: Evita que al hacer consultas generales o al devolver objetos de usuarios (por ejemplo, en `GET /users` o al actualizar datos), el hash de la contraseña viaje en la respuesta HTTP hacia el cliente.
* **Acceso explícito**: Solo cuando el servicio de autenticación necesite validar la contraseña, se solicitará explícitamente la columna usando el método query builder o la propiedad `select` de TypeORM:
  ```typescript
  this.usersRepository.findOne({
    where: { email },
    select: ['id', 'email', 'password', 'role'] // Se pide explícitamente
  });
  ```

### Limpieza en RAM
Las cadenas en JavaScript son inmutables. Sin embargo, para evitar que queden flotando en memoria RAM más tiempo del necesario:
1. Las variables que contienen contraseñas en texto plano se limitan estrictamente al ámbito local de las funciones de controlador y servicio.
2. Al no tener referencias de larga duración (como variables globales o propiedades de clases persistentes), el recolector de basura (Garbage Collector) de Node.js las elimina rápidamente de la memoria física.
3. Se prohíbe terminantemente registrar la propiedad `password` en cualquier archivo de logs de consola o auditoría.

---

## 3. Prevención de Secuestro de Tokens de Sesión (JWT)

Una vez autenticado el usuario, el servidor genera un token JWT. Almacenar este token de manera insegura en el navegador permite que sea robado.

### El Peligro de localStorage (Ataques XSS)
Si el JWT se almacena en `localStorage` o `sessionStorage`, es accesible mediante código JavaScript (`window.localStorage.getItem(...)`). Si un atacante logra inyectar un script malicioso en nuestra web (ataque **Cross-Site Scripting - XSS**), podría robar instantáneamente el token de todos los usuarios activos y secuestrar sus sesiones.

### La Solución: HttpOnly Cookies
Para blindar el token, el servidor de NestJS (o en su defecto, el servidor intermedio de SvelteKit) guarda el JWT en una **Cookie segura** con los siguientes atributos:

1. **`HttpOnly`**: Este flag prohíbe estrictamente al motor de JavaScript del navegador acceder a la cookie. Ningún script puede leerla, eliminando por completo el riesgo de robo de token a través de ataques XSS.
2. **`Secure`**: La cookie solo se transmite a través de conexiones cifradas HTTPS, previniendo que sea interceptada en tránsito (ataques Man-in-the-Middle).
3. **`SameSite=Strict`**: La cookie solo se enviará en las solicitudes HTTP que se originen desde el mismo dominio de nuestro sitio web. Esto bloquea ataques de tipo **CSRF (Cross-Site Request Forgery)**, impidiendo que sitios web de terceros envíen peticiones maliciosas en nombre del usuario autenticado.

---

## 4. Flujo de Autenticación en SvelteKit

SvelteKit actúa como un servidor intermedio (Back-for-Front) que maneja las sesiones en dos capas:

1. **Capa Servidor (`+page.server.ts` / `hooks.server.ts`)**:
   * El cliente envía sus credenciales al servidor de SvelteKit.
   * SvelteKit las reenvía a la API de NestJS.
   * Si la API responde con éxito, SvelteKit establece la cookie `HttpOnly` en el navegador del cliente.
   * En peticiones subsecuentes, el middleware de SvelteKit (`hooks.server.ts`) extrae la cookie, valida el JWT y puebla el estado de sesión para el renderizado inicial en el servidor.
2. **Capa Cliente (`auth.svelte.ts`)**:
   * Mediante **Runes de Svelte 5**, mantenemos una sesión reactiva en el navegador basada en los datos devueltos por el servidor. Esto permite cambiar los botones de la interfaz ("Login" / "Logout") de forma instantánea y reactiva.
