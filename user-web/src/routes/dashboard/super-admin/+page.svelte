<script lang="ts">
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';
  import UserCrud from '$lib/features/users/components/UserCrud.svelte';

  let activeTab = $state('home');
</script>

<svelte:head>
  <title>Dashboard Súper Administrador - LavaApp</title>
</svelte:head>

<div class="dashboard-card">
  <h2 class="dashboard-title">Panel de Control: Súper Administrador</h2>

  <!-- Barra de Navegación de Pestañas -->
  <div class="tab-bar">
    <button 
      onclick={() => activeTab = 'home'} 
      class="tab-btn" 
      class:active={activeTab === 'home'}
    >
      Resumen
    </button>
    <button 
      onclick={() => activeTab = 'users'} 
      class="tab-btn" 
      class:active={activeTab === 'users'}
    >
      Gestión de Usuarios
    </button>
    <button 
      onclick={() => activeTab = 'config'} 
      class="tab-btn" 
      class:active={activeTab === 'config'}
    >
      Configuración
    </button>
  </div>

  <!-- Contenido de las pestañas -->
  <div class="tab-content">
    {#if activeTab === 'home'}
      <div class="content-panel">
        <h3 class="panel-subtitle">Resumen del Sistema</h3>
        <p class="role-notice">Acceso concedido a la consola de súper administración.</p>
        <p>Este es el panel principal de control técnico de LavaApp. Selecciona una de las pestañas superiores para navegar y gestionar los recursos del servidor.</p>
      </div>
    {:else if activeTab === 'users'}
      <div class="crud-wrapper">
        <UserCrud />
      </div>
    {:else}
      <div class="content-panel">
        <h3 class="panel-subtitle">Configuración del Sistema</h3>
        <p class="placeholder-text">Ajustes técnicos, copias de seguridad de SQLite, y expiración de tokens JWT.</p>
      </div>
    {/if}
  </div>

  <p class="back-link-container">
    <a href="/" class="back-link">Volver al Inicio Público</a>
  </p>
</div>

<style>
  .dashboard-card {
    box-sizing: border-box;
    font-family: 'Inter', sans-serif;
    padding: 0;
  }

  .dashboard-title {
    margin: 0 0 20px 0;
    font-size: 26px;
    font-weight: 700;
    color: #f8fafc;
    font-family: 'Outfit', sans-serif;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    padding-bottom: 12px;
  }

  .tab-bar {
    display: flex;
    gap: 12px;
    margin-bottom: 24px;
    flex-wrap: wrap;
  }

  .tab-btn {
    padding: 10px 20px;
    cursor: pointer;
    background: rgba(15, 23, 42, 0.3);
    color: #94a3b8;
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 8px;
    font-weight: 600;
    font-size: 14px;
    font-family: 'Inter', sans-serif;
    transition: all 0.2s ease;
  }

  .tab-btn:hover {
    color: #f1f5f9;
    border-color: rgba(255, 255, 255, 0.2);
    background: rgba(15, 23, 42, 0.5);
  }

  .tab-btn.active {
    background: rgba(236, 72, 153, 0.15);
    color: #f472b6;
    border-color: #ec4899;
    box-shadow: 0 0 12px rgba(236, 72, 153, 0.2);
  }

  .content-panel {
    padding: 16px 0;
    line-height: 1.6;
    color: #cbd5e1;
  }

  .panel-subtitle {
    margin: 0 0 12px 0;
    font-size: 18px;
    color: #f1f5f9;
    font-family: 'Outfit', sans-serif;
  }

  .role-notice {
    font-weight: bold;
    color: #f472b6;
    margin-bottom: 16px;
  }

  .back-link-container {
    margin-top: 30px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    padding-top: 16px;
  }

  .back-link {
    color: #f472b6;
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
    transition: opacity 0.2s ease;
  }

  .back-link:hover {
    opacity: 0.8;
    text-decoration: underline;
  }

  .crud-wrapper {
    background: transparent;
  }

  .placeholder-text {
    font-style: italic;
    color: #64748b;
  }
</style>

