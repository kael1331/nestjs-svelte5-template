<script lang="ts">
  import { onMount } from 'svelte';
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';
  import { navStore } from '$lib/components/layout/nav-store.svelte';

  onMount(() => {
    navStore.reset('home');
  });
</script>

<svelte:head>
  <title>Dashboard Administrador - LavaApp</title>
</svelte:head>

<div class="dashboard-card">
  <div class="tab-content">
    {#if navStore.activeTab === 'home'}
      <div class="content-panel">
        <h3 class="panel-subtitle">Panel de Control: Administrador</h3>
        <p class="welcome-text">Gestión y control de operaciones.</p>
        
        <div class="user-info-box">
          <div class="info-row">
            <span class="info-label">Nombre:</span>
            <span class="info-value">{authStore.user?.name || 'Administrador'}</span>
          </div>
          <div class="info-row">
            <span class="info-label">Email:</span>
            <span class="info-value">{authStore.user?.email || 'N/A'}</span>
          </div>
          <div class="info-row">
            <span class="info-label">Rol:</span>
            <span class="info-value highlight">Administrador</span>
          </div>
        </div>
      </div>
    {:else if navStore.activeTab === 'operations'}
      <div class="content-panel">
        <h3 class="panel-subtitle">Operaciones Activas</h3>
        <div class="admin-actions-placeholder">
          <p>Supervisión y asignación de pedidos de lavandería, asignación de tareas de delivery y control de insumos en próximas fases.</p>
        </div>
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

  .welcome-text {
    font-size: 16px;
    color: #e2e8f0;
    margin-bottom: 24px;
  }

  .user-info-box {
    background: rgba(15, 23, 42, 0.25);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 8px;
    padding: 16px 20px;
    margin-bottom: 24px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    max-width: 400px;
  }

  .info-row {
    display: flex;
    justify-content: space-between;
    font-size: 14px;
  }

  .info-label {
    color: #94a3b8;
  }

  .info-value {
    color: #f1f5f9;
    font-weight: 500;
  }

  .info-value.highlight {
    color: #a855f7;
    font-weight: 600;
  }

  .admin-actions-placeholder {
    font-size: 14px;
    color: #94a3b8;
    line-height: 1.6;
    border-left: 3px solid #a855f7;
    padding-left: 16px;
  }
</style>


