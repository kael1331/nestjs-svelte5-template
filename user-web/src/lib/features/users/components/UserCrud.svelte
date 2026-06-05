<script lang="ts">
  import { onMount } from 'svelte';
  import { fetchUsers, createUser, updateUser, deleteUser, type User } from '../services/users-api';

  let users = $state<User[]>([]);
  let loading = $state(false);
  let errorMessage = $state('');
  let successMessage = $state('');

  let name = $state('');
  let email = $state('');
  let role = $state('client');
  let password = $state('');

  let selectedUser = $state<User | null>(null);

  async function loadUsers() {
    loading = true;
    errorMessage = '';
    try {
      users = await fetchUsers();
    } catch (err: any) {
      errorMessage = 'Error al cargar usuarios: ' + err.message;
    } finally {
      loading = false;
    }
  }

  onMount(() => {
    loadUsers();
  });

  async function handleSubmit(e: Event) {
    e.preventDefault();
    errorMessage = '';
    successMessage = '';

    try {
      if (selectedUser) {
        await updateUser(selectedUser.id, name, email, role, password || undefined);
        successMessage = 'Usuario actualizado exitosamente.';
      } else {
        if (!password) {
          errorMessage = 'La contraseña es obligatoria al crear un usuario nuevo.';
          return;
        }
        await createUser(name, email, role, password);
        successMessage = 'Usuario creado exitosamente.';
      }
      resetForm();
      await loadUsers();
    } catch (err: any) {
      errorMessage = 'Error al guardar usuario: ' + err.message;
    }
  }

  function handleEdit(user: User) {
    selectedUser = user;
    name = user.name;
    email = user.email;
    role = user.role;
    password = '';
    errorMessage = '';
    successMessage = '';
  }

  async function handleDelete(id: number) {
    if (!confirm('¿Estás seguro de que deseas eliminar este usuario?')) return;
    errorMessage = '';
    successMessage = '';

    try {
      await deleteUser(id);
      successMessage = 'Usuario eliminado correctamente.';
      await loadUsers();
      if (selectedUser?.id === id) {
        resetForm();
      }
    } catch (err: any) {
      errorMessage = 'Error al eliminar usuario: ' + err.message;
    }
  }

  function resetForm() {
    selectedUser = null;
    name = '';
    email = '';
    role = 'client';
    password = '';
  }
</script>

<div style="border: 1px solid #555; padding: 20px; background: #333; color: white; margin-top: 10px; font-family: sans-serif;">
  <h3>Gestión CRUD de Usuarios (Módulo Autónomo)</h3>

  {#if errorMessage}
    <p style="color: #ff8888; font-weight: bold;">{errorMessage}</p>
  {/if}

  {#if successMessage}
    <p style="color: #88ff88; font-weight: bold;">{successMessage}</p>
  {/if}

  <form onsubmit={handleSubmit} style="margin-bottom: 30px; border-bottom: 1px solid #555; padding-bottom: 20px;">
    <h4>{selectedUser ? 'Editar Usuario' : 'Crear Nuevo Usuario'}</h4>
    
    <div style="margin-bottom: 10px;">
      <label style="display: block; margin-bottom: 5px; color: white;">Nombre:</label>
      <input type="text" bind:value={name} required style="width: 100%; max-width: 300px; padding: 6px; color: black;" />
    </div>

    <div style="margin-bottom: 10px;">
      <label style="display: block; margin-bottom: 5px; color: white;">Email:</label>
      <input type="email" bind:value={email} required style="width: 100%; max-width: 300px; padding: 6px; color: black;" />
    </div>

    <div style="margin-bottom: 10px;">
      <label style="display: block; margin-bottom: 5px; color: white;">Rol:</label>
      <select bind:value={role} style="width: 100%; max-width: 300px; padding: 6px; color: black;">
        <option value="client">Cliente</option>
        <option value="admin">Administrador</option>
        <option value="super_admin">Súper Administrador</option>
      </select>
    </div>

    <div style="margin-bottom: 15px;">
      <label style="display: block; margin-bottom: 5px; color: white;">
        Contraseña {selectedUser ? '(dejar en blanco para no modificar)' : '(obligatorio)'}:
      </label>
      <input type="password" bind:value={password} required={!selectedUser} style="width: 100%; max-width: 300px; padding: 6px; color: black;" />
    </div>

    <button type="submit" style="padding: 8px 15px; cursor: pointer;">
      {selectedUser ? 'Actualizar Usuario' : 'Registrar Usuario'}
    </button>

    {#if selectedUser}
      <button type="button" onclick={resetForm} style="padding: 8px 15px; margin-left: 10px; cursor: pointer; background: gray; color: white; border: none;">
        Cancelar
      </button>
    {/if}
  </form>

  <h4>Listado de Usuarios</h4>
  {#if loading}
    <p>Cargando lista de usuarios...</p>
  {:else if users.length === 0}
    <p>No hay usuarios registrados.</p>
  {:else}
    <table style="width: 100%; border-collapse: collapse; text-align: left; color: white;">
      <thead>
        <tr style="border-bottom: 2px solid #555;">
          <th style="padding: 8px;">ID</th>
          <th style="padding: 8px;">Nombre</th>
          <th style="padding: 8px;">Email</th>
          <th style="padding: 8px;">Rol</th>
          <th style="padding: 8px;">Acciones</th>
        </tr>
      </thead>
      <tbody>
        {#each users as u}
          <tr style="border-bottom: 1px solid #444;">
            <td style="padding: 8px;">{u.id}</td>
            <td style="padding: 8px;">{u.name}</td>
            <td style="padding: 8px;">{u.email}</td>
            <td style="padding: 8px;">{u.role}</td>
            <td style="padding: 8px;">
              <button onclick={() => handleEdit(u)} style="margin-right: 5px; padding: 4px 8px; cursor: pointer;">
                Editar
              </button>
              <button onclick={() => handleDelete(u.id)} style="padding: 4px 8px; cursor: pointer; background: darkred; color: white; border: none;">
                Eliminar
              </button>
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  {/if}
</div>
