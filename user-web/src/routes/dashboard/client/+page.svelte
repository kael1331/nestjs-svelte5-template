<script lang="ts">
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';
</script>

<svelte:head>
  <title>Dashboard Cliente</title>
</svelte:head>

<div style="padding: 20px; font-family: sans-serif; background: #222; color: #fff; min-height: 100vh;">
  <h1>Dashboard del Cliente</h1>
  <p>Hola, {authStore.user?.name || 'Cliente'} ({authStore.user?.email})</p>
  <p style="font-weight: bold; color: #38bdf8;">Acceso a dashboard cliente</p>
  
  <hr style="border-color: #444; margin: 20px 0;" />
  
  <button onclick={() => authStore.logout()} style="padding: 10px 15px; background: red; color: white; border: none; cursor: pointer;">
    LOG OUT
  </button>
</div>
