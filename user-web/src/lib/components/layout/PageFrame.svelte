<script lang="ts">
  import Header from './Header.svelte';
  import Footer from './Footer.svelte';

  let { children } = $props();
</script>

<div class="page-outer-container">
  <div class="page-frame">
    <!-- Header dentro del recuadro -->
    <Header />
    
    <!-- Contenido principal con padding -->
    <main class="page-content">
      {@render children()}
    </main>
    
    <!-- Footer dentro del recuadro -->
    <Footer />
  </div>
</div>

<style>
  .page-outer-container {
    min-height: 100vh;
    width: 100%;
    /* Fondo espacial oscuro moderno */
    background: radial-gradient(circle at top right, #1e1b4b 0%, #0f172a 60%, #020617 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    padding: 0;
  }

  .page-frame {
    width: 96%;
    max-width: 1440px;
    /* Centrado con 2% a cada costado */
    margin: 0 auto;
    min-height: 100vh;
    
    /* Efecto Glassmorphism Premium */
    background: rgba(15, 23, 42, 0.3);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border-left: 1px solid rgba(255, 255, 255, 0.08);
    border-right: 1px solid rgba(255, 255, 255, 0.08);
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 0;
    box-shadow: 
      0 4px 30px rgba(0, 0, 0, 0.4),
      inset 0 0 1px rgba(255, 255, 255, 0.1);
    
    display: flex;
    flex-direction: column;
    overflow: hidden;
    box-sizing: border-box;
  }

  .page-content {
    flex: 1;
    padding: 32px 24px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    background: rgba(30, 41, 59, 0.1);
    color: #f1f5f9;
    font-family: 'Inter', sans-serif;
  }

  @media (max-width: 768px) {
    .page-outer-container {
      padding: 0;
    }
    
    .page-frame {
      width: 100%;
      min-height: 100vh;
      border-radius: 0;
      border: none;
    }
    
    .page-content {
      padding: 20px 16px;
    }
  }
</style>
