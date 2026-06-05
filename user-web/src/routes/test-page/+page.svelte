<svelte:head>
  <title>Página Secundaria de Pruebas</title>
</svelte:head>

<main class="sandbox-container">
  <div class="glass-hero">
    <div class="header">
      <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#a78bfa" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" x2="4" y1="22" y2="15"/></svg>
      <h2>Página Secundaria</h2>
    </div>
    
    <p class="description">
      ¡Éxito! Has navegado correctamente a otra página de la aplicación utilizando el enrutador de SvelteKit.
    </p>

    <div class="info-card">
      <h4>Estado del Enrutamiento</h4>
      <p>Ruta actual: <code>/test-page</code></p>
      <p>Carga de página: Servidor a Cliente (SPA transition)</p>
    </div>

    <a href="/" class="btn-back">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
      Volver a la Página Principal
    </a>
  </div>
</main>

<style>
  .sandbox-container {
    width: 100%;
    max-width: 600px;
    margin: 80px auto 40px auto;
    padding: 0 20px;
    box-sizing: border-box;
    animation: fadeIn 0.4s ease-out;
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .glass-hero {
    background: rgba(255, 255, 255, 0.03);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 24px;
    padding: 40px;
    text-align: center;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
  }

  .header {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
    margin-bottom: 16px;
  }

  .header h2 {
    font-size: 1.8rem;
    font-weight: 700;
    margin: 0;
    color: #ffffff;
    letter-spacing: -0.01em;
  }

  .description {
    color: #a1a1aa;
    font-size: 1rem;
    line-height: 1.6;
    margin-top: 0;
    margin-bottom: 24px;
  }

  .info-card {
    background: rgba(167, 139, 250, 0.05);
    border: 1px solid rgba(167, 139, 250, 0.15);
    border-radius: 12px;
    padding: 16px;
    text-align: left;
    margin-bottom: 32px;
  }

  .info-card h4 {
    margin: 0 0 8px 0;
    font-size: 0.95rem;
    color: #c084fc;
    font-weight: 600;
  }

  .info-card p {
    margin: 4px 0;
    font-size: 0.85rem;
    color: #d1d5db;
  }

  code {
    background: rgba(255, 255, 255, 0.1);
    padding: 2px 6px;
    border-radius: 4px;
    font-family: monospace;
    color: #f3f4f6;
  }

  .btn-back {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 12px 24px;
    border-radius: 12px;
    font-size: 0.95rem;
    font-weight: 500;
    cursor: pointer;
    text-decoration: none;
    background: rgba(255, 255, 255, 0.05);
    color: #e4e4e7;
    border: 1px solid rgba(255, 255, 255, 0.1);
    transition: all 0.2s ease;
  }

  .btn-back:hover {
    background: rgba(255, 255, 255, 0.1);
    border-color: rgba(255, 255, 255, 0.2);
    transform: translateX(-2px);
  }
</style>
