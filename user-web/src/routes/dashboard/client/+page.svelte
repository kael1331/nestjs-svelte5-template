<script lang="ts">
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';
</script>

<svelte:head>
  <title>Dashboard Cliente - LavaApp</title>
</svelte:head>

<div class="dashboard-card">
  <h2 class="dashboard-title">Panel de Control: Cliente</h2>
  <div class="dashboard-content">
    <p class="welcome-text">¡Bienvenido de nuevo a LavaApp!</p>
    <div class="user-info-box">
      <div class="info-row">
        <span class="info-label">Nombre:</span>
        <span class="info-value">{authStore.user?.name || 'Cliente'}</span>
      </div>
      <div class="info-row">
        <span class="info-label">Email:</span>
        <span class="info-value">{authStore.user?.email || 'N/A'}</span>
      </div>
      <div class="info-row">
        <span class="info-label">Rol:</span>
        <span class="info-value highlight">Cliente</span>
      </div>
    </div>
    <div class="client-actions-placeholder">
      <p>Aquí tendrás acceso a tus servicios contratados, historial de lavados y seguimiento de pedidos en próximas fases.</p>
    </div>
  </div>
</div>

<style>
  .dashboard-card {
    background: rgba(30, 41, 59, 0.4);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 28px;
    box-sizing: border-box;
    font-family: 'Inter', sans-serif;
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

  .welcome-text {
    font-size: 16px;
    color: #e2e8f0;
    margin-bottom: 24px;
  }

  .user-info-box {
    background: rgba(15, 23, 42, 0.3);
    border-radius: 8px;
    padding: 16px 20px;
    margin-bottom: 24px;
    display: flex;
    flex-direction: column;
    gap: 12px;
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
    color: #3b82f6;
    font-weight: 600;
  }

  .client-actions-placeholder {
    font-size: 14px;
    color: #94a3b8;
    line-height: 1.6;
    border-left: 3px solid #3b82f6;
    padding-left: 16px;
  }
</style>

