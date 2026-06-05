<script lang="ts">
  import { navStore } from './nav-store.svelte';
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';

  const isOpen = $derived(navStore.isSidebarOpen);
  const user = $derived(authStore.user);
  const menuItems = $derived(user ? navStore.getAuthorizedItems(user.role) : []);

  function getRoleTitle(role: string) {
    if (role === 'super_admin') return 'Panel de Súper Administrador';
    if (role === 'admin') return 'Panel de Administrador';
    return 'Panel de Cliente';
  }
</script>

<!-- Backdrop (Fondo oscurecido cuando el menú está abierto) -->
{#if isOpen}
  <div 
    class="sidebar-backdrop" 
    onclick={() => navStore.closeSidebar()} 
    onkeydown={(e) => e.key === 'Escape' && navStore.closeSidebar()} 
    tabindex="0" 
    role="button" 
    aria-label="Cerrar menú"
  ></div>
{/if}

<!-- Drawer del Menú Lateral -->
<aside class="sidebar-drawer" class:open={isOpen}>
  <div class="sidebar-header">
    <span class="sidebar-brand">LavaApp</span>
    <button class="close-btn" onclick={() => navStore.closeSidebar()} aria-label="Cerrar menú">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <line x1="18" y1="6" x2="6" y2="18" />
        <line x1="6" y1="6" x2="18" y2="18" />
      </svg>
    </button>
  </div>
  
  <div class="sidebar-body">
    {#if user}
      <h3 class="sidebar-title">{getRoleTitle(user.role)}</h3>
    {/if}
    
    <nav class="sidebar-nav">
      {#each menuItems as item}
        <button 
          class="nav-item-btn" 
          class:active={navStore.activeTab === item.id}
          onclick={() => { navStore.activeTab = item.id; navStore.closeSidebar(); }}
        >
          <span class="nav-indicator"></span>
          {item.label}
        </button>
      {/each}
    </nav>
  </div>
</aside>

<style>
  /* --- MENU LATERAL (SIDEBAR DRAWER) --- */
  .sidebar-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.65);
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);
    z-index: 1999;
    animation: fade-in 0.2s ease-out;
  }

  @keyframes fade-in {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  .sidebar-drawer {
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    width: 290px;
    background: rgba(15, 23, 42, 0.95);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-right: 1px solid rgba(255, 255, 255, 0.08);
    z-index: 2000;
    display: flex;
    flex-direction: column;
    transform: translateX(-100%);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 10px 0 30px rgba(0, 0, 0, 0.5);
    box-sizing: border-box;
  }

  .sidebar-drawer.open {
    transform: translateX(0);
  }

  .sidebar-header {
    height: 15vh;
    min-height: 85px;
    max-height: 120px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 24px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    box-sizing: border-box;
  }

  .sidebar-brand {
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.5px;
    background: linear-gradient(90deg, #60a5fa, #3b82f6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-family: 'Outfit', sans-serif;
  }

  .close-btn {
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
  }

  .close-btn:hover {
    color: #f1f5f9;
    background: rgba(255, 255, 255, 0.05);
  }

  .close-btn svg {
    width: 22px;
    height: 22px;
  }

  .sidebar-body {
    flex: 1;
    padding: 24px;
    display: flex;
    flex-direction: column;
    gap: 16px;
    overflow-y: auto;
    box-sizing: border-box;
  }

  .sidebar-title {
    margin: 0;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    color: #475569;
    font-weight: 700;
    font-family: 'Outfit', sans-serif;
    border-bottom: 1px solid rgba(255, 255, 255, 0.03);
    padding-bottom: 8px;
  }

  .sidebar-nav {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .nav-item-btn {
    position: relative;
    display: flex;
    align-items: center;
    width: 100%;
    padding: 12px 16px;
    background: transparent;
    border: 1px solid transparent;
    border-radius: 8px;
    color: #94a3b8;
    font-size: 14px;
    font-weight: 600;
    text-align: left;
    cursor: pointer;
    font-family: 'Inter', sans-serif;
    transition: all 0.2s ease;
    box-sizing: border-box;
  }

  .nav-item-btn:hover {
    color: #f1f5f9;
    background: rgba(255, 255, 255, 0.03);
    border-color: rgba(255, 255, 255, 0.05);
  }

  .nav-item-btn.active {
    background: rgba(59, 130, 246, 0.1);
    color: #3b82f6;
    border-color: rgba(59, 130, 246, 0.3);
  }

  .nav-indicator {
    position: absolute;
    left: 0;
    top: 25%;
    bottom: 25%;
    width: 3px;
    background-color: transparent;
    border-radius: 0 4px 4px 0;
    transition: background-color 0.2s ease;
  }

  .nav-item-btn.active .nav-indicator {
    background-color: #3b82f6;
    box-shadow: 0 0 8px #3b82f6;
  }

  @media (max-width: 768px) {
    .sidebar-drawer {
      width: 85%;
      max-width: 300px;
    }
  }
</style>
