<script lang="ts">
  import { onMount } from 'svelte';
  import { navStore } from '$lib/components/layout/nav-store.svelte';
  import UserCrud from '$lib/features/users/components/UserCrud.svelte';

  onMount(() => {
    navStore.reset('home');
  });
</script>

<svelte:head>
  <title>Dashboard Súper Administrador - LavaApp</title>
</svelte:head>

<div class="dashboard-card">
  <!-- Contenido de las pestañas leído desde el almacén global -->
  <div class="tab-content">
    {#if navStore.activeTab === 'home'}
      <div class="content-panel">
        <h3 class="panel-subtitle">Resumen del Sistema</h3>
        <p class="role-notice">Acceso concedido a la consola de súper administración.</p>
        <p>Este es el panel principal de control técnico de LavaApp. Abre el menú lateral izquierdo (botón ☰) para navegar entre las opciones de administración y configuraciones.</p>
      </div>
    {:else if navStore.activeTab === 'users'}
      <div class="crud-wrapper">
        <UserCrud />
      </div>
    {:else if navStore.activeTab === 'config'}
      <div class="content-panel">
        <h3 class="panel-subtitle">Configuración del Sistema</h3>
        <p class="placeholder-text">Ajustes técnicos, copias de seguridad de SQLite y expiración de tokens JWT en próximas fases.</p>
      </div>
    {/if}
  </div>
</div>

<style>
  .dashboard-card {
    box-sizing: border-box;
    font-family: 'Inter', sans-serif;
    padding: 0;
  }

  .content-panel {
    padding: 16px 0;
    line-height: 1.6;
    color: #cbd5e1;
  }

  .panel-subtitle {
    margin: 0 0 12px 0;
    font-size: 22px;
    color: #f1f5f9;
    font-family: 'Outfit', sans-serif;
  }

  .role-notice {
    font-weight: bold;
    color: #ec4899;
    margin-bottom: 16px;
  }

  .crud-wrapper {
    background: transparent;
  }

  .placeholder-text {
    font-style: italic;
    color: #64748b;
  }
</style>


