<footer class="dashboard-footer">
  <div class="footer-content">
    <div class="footer-left">
      <span class="copyright">© 2026 <strong>LavaApp</strong>. Todos los derechos reservados.</span>
    </div>
    
    <div class="footer-right">
      <span class="status-indicator">
        <span class="pulse-dot"></span>
        Servidor Seguro Activo
      </span>
      <span class="divider">|</span>
      <a href="https://github.com/kael1331/Nestjs-svelte5-lavapp" target="_blank" rel="noopener noreferrer" class="footer-link">
        GitHub
      </a>
    </div>
  </div>
</footer>

<style>
  .dashboard-footer {
    height: 10vh;
    min-height: 60px;
    max-height: 80px;
    display: flex;
    align-items: center;
    background: rgba(15, 23, 42, 0.45);
    backdrop-filter: blur(16px) saturate(160%);
    -webkit-backdrop-filter: blur(16px) saturate(160%);
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    padding: 0 24px;
    box-sizing: border-box;
  }

  .footer-content {
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 13px;
    color: #64748b;
    font-family: 'Inter', sans-serif;
  }

  .copyright strong {
    color: #94a3b8;
  }

  .footer-right {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .status-indicator {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #10b981;
    font-weight: 500;
  }

  .pulse-dot {
    width: 8px;
    height: 8px;
    background-color: #10b981;
    border-radius: 50%;
    box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7);
    animation: pulse 1.6s infinite;
  }

  @keyframes pulse {
    0% {
      transform: scale(0.95);
      box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7);
    }
    70% {
      transform: scale(1);
      box-shadow: 0 0 0 6px rgba(16, 185, 129, 0);
    }
    100% {
      transform: scale(0.95);
      box-shadow: 0 0 0 0 rgba(16, 185, 129, 0);
    }
  }

  .divider {
    color: rgba(255, 255, 255, 0.1);
  }

  .footer-link {
    color: #64748b;
    text-decoration: none;
    transition: color 0.2s ease;
  }

  .footer-link:hover {
    color: #3b82f6;
  }

  @media (max-width: 600px) {
    .footer-content {
      flex-direction: column;
      gap: 8px;
      text-align: center;
    }
    .footer-right {
      justify-content: center;
    }
  }
</style>
