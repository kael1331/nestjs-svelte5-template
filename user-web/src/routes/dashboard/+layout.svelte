<script lang="ts">
  import { page } from '$app/stores';
  import { goto } from '$app/navigation';
  import { authStore } from '$lib/features/auth/services/auth-store.svelte';

  let { children } = $props();

  $effect(() => {
    if (authStore.loading) return;

    const user = authStore.user;
    const path = $page.url.pathname;

    if (!user) {
      goto('/login');
      return;
    }

    if (path.startsWith('/dashboard/super-admin') && user.role !== 'super_admin') {
      redirectToCorrectDashboard(user.role);
    } else if (path.startsWith('/dashboard/admin') && user.role !== 'admin') {
      redirectToCorrectDashboard(user.role);
    } else if (path.startsWith('/dashboard/client') && user.role !== 'client') {
      redirectToCorrectDashboard(user.role);
    }
  });

  function redirectToCorrectDashboard(role: string) {
    if (role === 'super_admin') {
      goto('/dashboard/super-admin');
    } else if (role === 'admin') {
      goto('/dashboard/admin');
    } else {
      goto('/dashboard/client');
    }
  }
</script>

{#if authStore.loading}
  <div style="padding: 50px; text-align: center; font-family: sans-serif; color: white;">
    <h3>Verificando sesión...</h3>
  </div>
{:else if authStore.user}
  {@render children()}
{/if}
