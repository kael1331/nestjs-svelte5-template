<script lang="ts">
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';
  import UserCrud from '$lib/features/users/components/UserCrud.svelte';

  let activeTab = $state('home');
</script>

<svelte:head>
  <title>Dashboard Súper Administrador</title>
</svelte:head>

<div style="padding: 20px; font-family: sans-serif; background: #222; color: #fff; min-height: 100vh;">
  <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #444; padding-bottom: 15px; margin-bottom: 20px;">
    <div>
      <h1 style="margin: 0;">Dashboard del Súper Administrador</h1>
      <span style="font-size: 0.9rem; color: #aaa;">Hola, {authStore.user?.name} ({authStore.user?.role})</span>
    </div>
    <button onclick={() => authStore.logout()} style="padding: 8px 15px; background: red; color: white; border: none; cursor: pointer; font-weight: bold;">
      LOG OUT
    </button>
  </div>

  <div style="display: flex; gap: 10px; margin-bottom: 25px;">
    <button onclick={() => activeTab = 'home'} style="padding: 10px 15px; cursor: pointer; background: {activeTab === 'home' ? '#555' : '#333'}; color: white; border: 1px solid #444;">
      Resumen
    </button>
    <button onclick={() => activeTab = 'users'} style="padding: 10px 15px; cursor: pointer; background: {activeTab === 'users' ? '#555' : '#333'}; color: white; border: 1px solid #444;">
      Gestión de Usuarios
    </button>
    <button onclick={() => activeTab = 'config'} style="padding: 10px 15px; cursor: pointer; background: {activeTab === 'config' ? '#555' : '#333'}; color: white; border: 1px solid #444;">
      Configuración
    </button>
  </div>

  {#if activeTab === 'home'}
    <div style="padding: 15px; border: 1px solid #444; background: #333;">
      <h3>Resumen del Sistema</h3>
      <p style="font-weight: bold; color: #f472b6;">Acceso a dashboard súper administrador</p>
      <p>Este es el panel principal de control técnico. Selecciona una de las pestañas superiores para navegar.</p>
    </div>
  {:else if activeTab === 'users'}
    <UserCrud />
  {:else}
    <div style="padding: 15px; border: 1px solid #444; background: #333;">
      <h3>Configuración del Sistema</h3>
      <p><em>[Marcador de posición]</em> Ajustes técnicos, backups de SQLite y configuración de expiración de JWT.</p>
    </div>
  {/if}

  <p style="margin-top: 30px; border-top: 1px solid #444; padding-top: 10px;">
    <a href="/" style="color: #a78bfa;">Volver al Inicio Público</a>
  </p>
</div>
