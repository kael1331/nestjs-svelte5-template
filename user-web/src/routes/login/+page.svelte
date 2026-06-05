<script lang="ts">
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';
  import { goto } from '$app/navigation';

  let email = $state('');
  let password = $state('');
  
  let regName = $state('');
  let regEmail = $state('');
  let regPassword = $state('');
  let regRole = $state('client');

  let isRegisterMode = $state(false);
  let errorMessage = $state('');
  let successMessage = $state('');

  $effect(() => {
    if (authStore.user) {
      redirectToDashboard(authStore.user.role);
    }
  });

  async function handleGoogleCredentialResponse(response: any) {
    errorMessage = '';
    successMessage = '';
    const ok = await authStore.loginWithGoogle(response.credential);
    if (ok && authStore.user) {
      redirectToDashboard(authStore.user.role);
    } else {
      errorMessage = 'Error: No se pudo iniciar sesión con Google.';
    }
  }

  $effect(() => {
    if (typeof window !== 'undefined') {
      const initGoogle = () => {
        const win = window as any;
        if (win.google && win.google.accounts) {
          win.google.accounts.id.initialize({
            client_id: '133806765476-l4vlgdm105bauerb58l1u0t8g8k020u3.apps.googleusercontent.com',
            callback: handleGoogleCredentialResponse
          });
          
          const btnContainer = document.getElementById('google-signin-btn');
          if (btnContainer) {
            win.google.accounts.id.renderButton(btnContainer, {
              theme: 'outline',
              size: 'large',
              width: 360
            });
          }
        } else {
          setTimeout(initGoogle, 200);
        }
      };
      initGoogle();
    }
  });

  function redirectToDashboard(role: string) {
    if (role === 'super_admin') {
      goto('/dashboard/super-admin');
    } else if (role === 'admin') {
      goto('/dashboard/admin');
    } else {
      goto('/dashboard/client');
    }
  }

  async function handleLogin(e: Event) {
    e.preventDefault();
    errorMessage = '';
    successMessage = '';
    const ok = await authStore.login(email, password);
    if (ok && authStore.user) {
      redirectToDashboard(authStore.user.role);
    } else {
      errorMessage = 'Error: Credenciales inválidas o error de red.';
    }
  }

  async function handleRegister(e: Event) {
    e.preventDefault();
    errorMessage = '';
    successMessage = '';
    const ok = await authStore.register(regName, regEmail, regPassword, regRole);
    if (ok) {
      successMessage = 'Usuario registrado exitosamente. Por favor inicia sesión.';
      isRegisterMode = false;
      email = regEmail;
      password = '';
    } else {
      errorMessage = 'Error: No se pudo registrar el usuario. El correo podría estar en uso.';
    }
  }
</script>

<svelte:head>
  <title>Acceso / Registro</title>
</svelte:head>

<div style="padding: 20px; font-family: sans-serif; max-width: 400px; margin: 50px auto; border: 1px solid #ccc; background: white; color: black;">
  <h2>{isRegisterMode ? 'Registro de Usuario' : 'Iniciar Sesión'}</h2>

  {#if errorMessage}
    <p style="color: red; font-weight: bold;">{errorMessage}</p>
  {/if}

  {#if successMessage}
    <p style="color: green; font-weight: bold;">{successMessage}</p>
  {/if}

  {#if !isRegisterMode}
    <form onsubmit={handleLogin}>
      <div style="margin-bottom: 15px;">
        <label style="display: block; margin-bottom: 5px; color: black;">Correo electrónico:</label>
        <input type="email" bind:value={email} required style="width: 100%; padding: 8px; box-sizing: border-box;" />
      </div>

      <div style="margin-bottom: 15px;">
        <label style="display: block; margin-bottom: 5px; color: black;">Contraseña:</label>
        <input type="password" bind:value={password} required style="width: 100%; padding: 8px; box-sizing: border-box;" />
      </div>

      <button type="submit" style="padding: 10px 15px; cursor: pointer;">Ingresar</button>
    </form>

    <p style="margin-top: 20px; color: black;">
      ¿No tienes cuenta? 
      <button onclick={() => { isRegisterMode = true; errorMessage = ''; successMessage = ''; }} style="background: none; border: none; color: blue; text-decoration: underline; cursor: pointer; padding: 0;">
        Registrarse aquí
      </button>
    </p>
  {:else}
    <form onsubmit={handleRegister}>
      <div style="margin-bottom: 15px;">
        <label style="display: block; margin-bottom: 5px; color: black;">Nombre completo:</label>
        <input type="text" bind:value={regName} required style="width: 100%; padding: 8px; box-sizing: border-box;" />
      </div>

      <div style="margin-bottom: 15px;">
        <label style="display: block; margin-bottom: 5px; color: black;">Correo electrónico:</label>
        <input type="email" bind:value={regEmail} required style="width: 100%; padding: 8px; box-sizing: border-box;" />
      </div>

      <div style="margin-bottom: 15px;">
        <label style="display: block; margin-bottom: 5px; color: black;">Contraseña:</label>
        <input type="password" bind:value={regPassword} required style="width: 100%; padding: 8px; box-sizing: border-box;" />
      </div>

      <div style="margin-bottom: 15px;">
        <label style="display: block; margin-bottom: 5px; color: black;">Rol:</label>
        <select bind:value={regRole} style="width: 100%; padding: 8px; box-sizing: border-box;">
          <option value="client">Cliente</option>
          <option value="admin">Administrador</option>
          <option value="super_admin">Súper Administrador</option>
        </select>
      </div>

      <button type="submit" style="padding: 10px 15px; cursor: pointer;">Registrar Cuenta</button>
    </form>

    <p style="margin-top: 20px; color: black;">
      ¿Ya tienes cuenta? 
      <button onclick={() => { isRegisterMode = false; errorMessage = ''; successMessage = ''; }} style="background: none; border: none; color: blue; text-decoration: underline; cursor: pointer; padding: 0;">
        Iniciar sesión aquí
      </button>
    </p>
  {/if}

  <!-- Botón de Google Sign-In -->
  <div style="margin-top: 20px; border-top: 1px dashed #ccc; padding-top: 20px; text-align: center;">
    <p style="margin-bottom: 12px; color: #666; font-size: 14px;">O accede directamente con:</p>
    <div id="google-signin-btn" style="display: flex; justify-content: center;"></div>
  </div>

  <p style="margin-top: 20px; border-top: 1px solid #ccc; padding-top: 10px; color: black;">
    <a href="/" style="color: blue;">Volver al Inicio</a>
  </p>
</div>

