<script lang="ts">
  import { onMount } from 'svelte';
  import { 
    fetchUsers, 
    createUser, 
    updateUser, 
    deleteUser, 
    type User 
  } from '../../features/users/services/users-api';

  // Estados reactivos usando Runes de Svelte 5
  let users = $state<User[]>([]);
  let loading = $state(true);
  let errorMsg = $state<string | null>(null);

  // Campos de formulario para Creación
  let name = $state('');
  let email = $state('');
  let role = $state('client');
  let submitting = $state(false);

  // Campos de formulario para Edición
  let editingUser = $state<User | null>(null);
  let editName = $state('');
  let editEmail = $state('');
  let editRole = $state('client');
  let updating = $state(false);

  // Carga inicial de datos
  onMount(async () => {
    await loadUsers();
  });

  async function loadUsers() {
    loading = true;
    errorMsg = null;
    try {
      users = await fetchUsers();
    } catch (err: any) {
      errorMsg = err.message || 'No se pudo conectar con el backend de NestJS';
    } finally {
      loading = false;
    }
  }

  // Crear usuario
  async function handleCreate(event: Event) {
    event.preventDefault();
    if (!name.trim() || !email.trim()) return;

    submitting = true;
    try {
      const created = await createUser(name, email, role);
      users = [...users, created];
      name = '';
      email = '';
      role = 'client';
    } catch (err: any) {
      alert(`Error al crear usuario: ${err.message}`);
    } finally {
      submitting = false;
    }
  }

  // Abrir panel de edición
  function startEdit(user: User) {
    editingUser = user;
    editName = user.name;
    editEmail = user.email;
    editRole = user.role || 'client';
  }

  // Cancelar edición
  function cancelEdit() {
    editingUser = null;
  }

  // Guardar cambios del usuario editado
  async function handleUpdate(event: Event) {
    event.preventDefault();
    if (!editingUser) return;

    updating = true;
    try {
      const updated = await updateUser(editingUser.id, editName, editEmail, editRole);
      // Reemplazamos en el array local reactivo
      users = users.map(u => u.id === updated.id ? updated : u);
      editingUser = null;
    } catch (err: any) {
      alert(`Error al actualizar usuario: ${err.message}`);
    } finally {
      updating = false;
    }
  }

  // Eliminar usuario
  async function handleDelete(id: number) {
    if (!confirm(`¿Estás seguro de que deseas eliminar al usuario #${id}?`)) return;

    try {
      await deleteUser(id);
      // Filtramos de la lista local reactiva
      users = users.filter(u => u.id !== id);
    } catch (err: any) {
      alert(`Error al eliminar usuario: ${err.message}`);
    }
  }

  function getRoleColor(role: string) {
    switch (role) {
      case 'super_admin': return 'role-super';
      case 'admin': return 'role-admin';
      default: return 'role-client';
    }
  }

  function getRoleLabel(role: string) {
    switch (role) {
      case 'super_admin': return 'Super Admin';
      case 'admin': return 'Administrador';
      default: return 'Cliente';
    }
  }
</script>

<div class="crud-container">
  <div class="card-header">
    <h3>Consola de CRUD Completo (API Real)</h3>
    <button onclick={loadUsers} class="btn-refresh" disabled={loading}>
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/><path d="M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16"/><path d="M16 16h5v5"/></svg>
      Actualizar
    </button>
  </div>

  <div class="crud-grid">
    <!-- Panel Izquierdo: Formularios (Crear / Editar) -->
    <div class="forms-panel">
      {#if editingUser}
        <!-- Formulario de Edición -->
        <form onsubmit={handleUpdate} class="interactive-form edit-mode">
          <h4>Editar Usuario #{editingUser.id}</h4>
          <div class="form-group">
            <label for="edit-name">Nombre</label>
            <input id="edit-name" type="text" bind:value={editName} required disabled={updating} />
          </div>
          <div class="form-group">
            <label for="edit-email">Email</label>
            <input id="edit-email" type="email" bind:value={editEmail} required disabled={updating} />
          </div>
          <div class="form-group">
            <label for="edit-role">Rol de Usuario</label>
            <select id="edit-role" bind:value={editRole} disabled={updating}>
              <option value="client">Cliente</option>
              <option value="admin">Administrador</option>
              <option value="super_admin">Super Administrador</option>
            </select>
          </div>
          <div class="actions-row">
            <button type="submit" class="btn-action btn-save" disabled={updating}>
              {updating ? 'Guardando...' : 'Guardar Cambios'}
            </button>
            <button type="button" onclick={cancelEdit} class="btn-action btn-cancel" disabled={updating}>
              Cancelar
            </button>
          </div>
        </form>
      {:else}
        <!-- Formulario de Creación -->
        <form onsubmit={handleCreate} class="interactive-form create-mode">
          <h4>Crear Nuevo Usuario</h4>
          <div class="form-group">
            <label for="create-name">Nombre</label>
            <input id="create-name" type="text" placeholder="Nombre completo" bind:value={name} required disabled={submitting} />
          </div>
          <div class="form-group">
            <label for="create-email">Email</label>
            <input id="create-email" type="email" placeholder="correo@ejemplo.com" bind:value={email} required disabled={submitting} />
          </div>
          <div class="form-group">
            <label for="create-role">Rol de Usuario</label>
            <select id="create-role" bind:value={role} disabled={submitting}>
              <option value="client">Cliente</option>
              <option value="admin">Administrador</option>
              <option value="super_admin">Super Administrador</option>
            </select>
          </div>
          <button type="submit" class="btn-action btn-submit" disabled={submitting}>
            {submitting ? 'Creando...' : 'Crear Usuario'}
          </button>
        </form>
      {/if}
    </div>

    <!-- Panel Derecho: Tabla de Listado y Acciones -->
    <div class="list-panel">
      <div class="table-container">
        {#if loading}
          <div class="status-msg">
            <span class="spinner"></span>
            Cargando base de datos NestJS...
          </div>
        {:else if errorMsg}
          <div class="status-msg error-msg">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>
            <span>{errorMsg}</span>
          </div>
        {:else if users.length === 0}
          <div class="status-msg empty-msg">
            No hay usuarios registrados en la base de datos sqlite. ¡Crea uno a la izquierda!
          </div>
        {:else}
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Email</th>
                <th>Rol</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              {#each users as user (user.id)}
                <tr class="user-row">
                  <td class="user-id">#{user.id}</td>
                  <td class="user-name">{user.name}</td>
                  <td class="user-email">{user.email}</td>
                  <td>
                    <span class="role-badge {getRoleColor(user.role || 'client')}">
                      {getRoleLabel(user.role || 'client')}
                    </span>
                  </td>
                  <td class="actions-td">
                    <button onclick={() => startEdit(user)} class="btn-table btn-edit" title="Editar">
                      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg>
                    </button>
                    <button onclick={() => handleDelete(user.id)} class="btn-table btn-delete" title="Eliminar">
                      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/><line x1="10" x2="10" y1="11" y2="17"/><line x1="14" x2="14" y1="11" y2="17"/></svg>
                    </button>
                  </td>
                </tr>
              {/each}
            </tbody>
          </table>
        {/if}
      </div>
    </div>
  </div>
</div>

<style>
  .crud-container {
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border: 1px solid rgba(255, 255, 255, 0.15);
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3);
    color: #f3f4f6;
    margin-top: 20px;
    animation: fadeIn 0.4s ease-out;
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    padding-bottom: 12px;
  }

  .card-header h3 {
    margin: 0;
    font-size: 1.25rem;
    font-weight: 600;
    background: linear-gradient(135deg, #a78bfa, #c084fc);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  .btn-refresh {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: #f3f4f6;
    padding: 6px 12px;
    border-radius: 8px;
    font-size: 0.8rem;
    cursor: pointer;
    transition: all 0.2s;
  }

  .btn-refresh:hover:not(:disabled) {
    background: rgba(255, 255, 255, 0.12);
    border-color: rgba(255, 255, 255, 0.2);
  }

  .crud-grid {
    display: grid;
    grid-template-columns: 280px 1fr;
    gap: 24px;
  }

  @media (max-width: 768px) {
    .crud-grid {
      grid-template-columns: 1fr;
    }
  }

  /* Formulario */
  .interactive-form {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .edit-mode {
    border-color: rgba(192, 132, 252, 0.3);
    background: rgba(192, 132, 252, 0.02);
  }

  .interactive-form h4 {
    margin: 0 0 4px 0;
    font-size: 1rem;
    color: #ffffff;
    font-weight: 600;
  }

  .form-group {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .form-group label {
    font-size: 0.8rem;
    color: #a1a1aa;
    font-weight: 500;
  }

  .interactive-form input, .interactive-form select {
    background: rgba(0, 0, 0, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    padding: 10px 12px;
    color: #ffffff;
    font-size: 0.9rem;
    transition: all 0.2s;
  }

  .interactive-form input:focus, .interactive-form select:focus {
    outline: none;
    border-color: #a78bfa;
    box-shadow: 0 0 0 2px rgba(167, 139, 250, 0.15);
  }

  .interactive-form select option {
    background: #18181b;
    color: #ffffff;
  }

  .btn-action {
    width: 100%;
    padding: 12px;
    border: none;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
  }

  .btn-submit {
    background: #7c3aed;
    color: #ffffff;
  }

  .btn-submit:hover:not(:disabled) {
    background: #8b5cf6;
  }

  .btn-save {
    background: #c084fc;
    color: #180828;
    font-weight: 600;
  }

  .btn-save:hover:not(:disabled) {
    background: #d8b4fe;
  }

  .btn-cancel {
    background: rgba(255, 255, 255, 0.05);
    color: #f3f4f6;
    border: 1px solid rgba(255, 255, 255, 0.1);
  }

  .btn-cancel:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .actions-row {
    display: flex;
    gap: 8px;
  }

  /* Listado */
  .table-container {
    overflow-x: auto;
    min-height: 200px;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
  }

  th {
    padding: 12px 16px;
    font-size: 0.85rem;
    text-transform: uppercase;
    color: #9ca3af;
    font-weight: 600;
    letter-spacing: 0.05em;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }

  td {
    padding: 14px 16px;
    font-size: 0.9rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  }

  .user-row {
    transition: background-color 0.2s ease;
  }

  .user-row:hover {
    background: rgba(255, 255, 255, 0.02);
  }

  .user-id {
    font-family: monospace;
    color: #a1a1aa;
  }

  .user-name {
    font-weight: 500;
    color: #ffffff;
  }

  .user-email {
    color: #d1d5db;
  }

  .role-badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 6px;
    font-size: 0.72rem;
    font-weight: 600;
    text-align: center;
  }

  .role-super {
    background: rgba(239, 68, 68, 0.12);
    border: 1px solid rgba(239, 68, 68, 0.25);
    color: #f87171;
  }

  .role-admin {
    background: rgba(245, 158, 11, 0.12);
    border: 1px solid rgba(245, 158, 11, 0.25);
    color: #fbbf24;
  }

  .role-client {
    background: rgba(59, 130, 246, 0.12);
    border: 1px solid rgba(59, 130, 246, 0.25);
    color: #60a5fa;
  }

  .actions-td {
    display: flex;
    gap: 8px;
  }

  .btn-table {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.08);
    color: #d1d5db;
    padding: 6px;
    border-radius: 6px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
  }

  .btn-edit:hover {
    background: rgba(192, 132, 252, 0.15);
    border-color: rgba(192, 132, 252, 0.3);
    color: #d8b4fe;
  }

  .btn-delete:hover {
    background: rgba(239, 68, 68, 0.15);
    border-color: rgba(239, 68, 68, 0.3);
    color: #f87171;
  }

  /* Estados */
  .status-msg {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 12px;
    padding: 60px 20px;
    color: #a1a1aa;
    text-align: center;
    font-size: 0.95rem;
  }

  .error-msg {
    color: #f87171;
  }

  .spinner {
    width: 24px;
    height: 24px;
    border: 3px solid rgba(167, 139, 250, 0.1);
    border-top-color: #a78bfa;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }
</style>
