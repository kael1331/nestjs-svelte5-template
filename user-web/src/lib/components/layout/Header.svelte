<script lang="ts">
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';
  import { navStore } from './nav-store.svelte';

  const user = $derived(authStore.user);

  function getRoleLabel(role: string) {
    if (role === 'super_admin') return 'Súper Admin';
    if (role === 'admin') return 'Administrador';
    return 'Cliente';
  }

  function getRoleColor(role: string) {
    if (role === 'super_admin') return '#ec4899'; // Rosa
    if (role === 'admin') return '#a855f7'; // Violeta
    return '#3b82f6'; // Azul
  }
</script>

<header class="dashboard-header">
  <div class="brand-section">
    <!-- Botón de menú hamburguesa -->
    <button class="hamburger-btn" onclick={() => navStore.toggleSidebar()} aria-label="Abrir menú">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <line x1="4" y1="12" x2="20" y2="12" />
        <line x1="4" y1="6" x2="20" y2="6" />
        <line x1="4" y1="18" x2="20" y2="18" />
      </svg>
    </button>

    <!-- SVG Animado de burbuja/remolino para "LavaApp" -->
    <svg class="brand-logo" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
      <circle cx="50" cy="50" r="40" stroke="url(#gradient-accent)" stroke-width="6" stroke-dasharray="20 10" class="spinner" />
      <path d="M50 30 C40 30 35 40 35 50 C35 60 45 65 50 70 C55 65 65 60 65 50 C65 40 60 30 50 30 Z" fill="url(#gradient-fill)" />
      <circle cx="50" cy="48" r="4" fill="white" />
      <circle cx="42" cy="55" r="2.5" fill="rgba(255,255,255,0.7)" />
      <circle cx="58" cy="58" r="3.5" fill="rgba(255,255,255,0.8)" />
      <defs>
        <linearGradient id="gradient-accent" x1="0" y1="0" x2="100" y2="100">
          <stop offset="0%" stop-color="#60a5fa" />
          <stop offset="100%" stop-color="#3b82f6" />
        </linearGradient>
        <linearGradient id="gradient-fill" x1="0" y1="0" x2="100" y2="100">
          <stop offset="0%" stop-color="#3b82f6" />
          <stop offset="100%" stop-color="#1d4ed8" />
        </linearGradient>
      </defs>
    </svg>
    <h1 class="brand-name">LavaApp</h1>
  </div>

  {#if user}
    <div class="user-controls">
      <div class="user-badge-container">
        <span class="user-greeting">Hola, <strong style="color: #f8fafc;">{user.name}</strong></span>
        <span class="role-badge" style="background-color: {getRoleColor(user.role)}22; border: 1px solid {getRoleColor(user.role)}44; color: {getRoleColor(user.role)};">
          {getRoleLabel(user.role)}
        </span>
      </div>
      
      <button class="logout-btn" onclick={() => authStore.logout()}>
        <svg class="logout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
          <polyline points="16 17 21 12 16 7" />
          <line x1="21" y1="12" x2="9" y2="12" />
        </svg>
        Salir
      </button>
    </div>
  {/if}
</header>

<style>
  .dashboard-header {
    height: 15vh;
    min-height: 85px;
    max-height: 120px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 24px;
    background: rgba(15, 23, 42, 0.45);
    backdrop-filter: blur(16px) saturate(160%);
    -webkit-backdrop-filter: blur(16px) saturate(160%);
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    box-sizing: border-box;
  }

  .brand-section {
    display: flex;
    align-items: center;
    gap: 14px;
  }

  .hamburger-btn {
    background: transparent;
    border: none;
    color: #94a3b8;
    cursor: pointer;
    padding: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    transition: all 0.2s ease;
    margin-right: -4px;
  }

  .hamburger-btn:hover {
    color: #3b82f6;
    background: rgba(255, 255, 255, 0.05);
    box-shadow: 0 0 8px rgba(59, 130, 246, 0.2);
  }

  .hamburger-btn svg {
    width: 24px;
    height: 24px;
  }

  .brand-logo {
    width: 44px;
    height: 44px;
  }

  /* Rotación lenta del aro del logo */
  .spinner {
    transform-origin: center;
    animation: rotate-vortex 12s linear infinite;
  }

  @keyframes rotate-vortex {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  .brand-name {
    margin: 0;
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.5px;
    background: linear-gradient(90deg, #60a5fa, #3b82f6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-family: 'Outfit', sans-serif;
  }

  .user-controls {
    display: flex;
    align-items: center;
    gap: 20px;
  }

  .user-badge-container {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: 4px;
  }

  .user-greeting {
    font-size: 14px;
    color: #94a3b8;
    font-family: 'Inter', sans-serif;
  }

  .role-badge {
    font-size: 11px;
    font-weight: 600;
    padding: 2px 8px;
    border-radius: 9999px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    font-family: 'Inter', sans-serif;
  }

  .logout-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    background: rgba(239, 68, 68, 0.1);
    color: #ef4444;
    border: 1px solid rgba(239, 68, 68, 0.25);
    padding: 8px 16px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    font-family: 'Inter', sans-serif;
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .logout-btn:hover {
    background: #ef4444;
    color: white;
    border-color: #ef4444;
    box-shadow: 0 0 12px rgba(239, 68, 68, 0.4);
    transform: translateY(-1px);
  }

  .logout-btn:active {
    transform: translateY(0);
  }

  .logout-icon {
    width: 16px;
    height: 16px;
    transition: transform 0.2s ease;
  }

  .logout-btn:hover .logout-icon {
    transform: translateX(2px);
  }

  @media (max-width: 600px) {
    .user-greeting {
      display: none;
    }
  }
</style>
