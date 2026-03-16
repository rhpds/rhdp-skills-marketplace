/* RHDP Skills — sidebar search, mobile menu, active nav links */
(function () {

  // ── Active nav link ──────────────────────────────────────────
  function markActiveLink() {
    const path = window.location.pathname;
    document.querySelectorAll('.sidebar-nav a').forEach(function (a) {
      const href = a.getAttribute('href');
      if (!href) return;
      // Resolve relative href to pathname
      const linkPath = new URL(a.href, window.location.href).pathname;
      if (linkPath === path || (path.endsWith('/') && linkPath === path + 'index.html')) {
        a.classList.add('active');
      }
    });
  }

  // ── Sidebar search ───────────────────────────────────────────
  function initSearch() {
    const input = document.getElementById('search-input');
    if (!input) return;

    input.addEventListener('input', function () {
      const q = input.value.toLowerCase().trim();
      document.querySelectorAll('.sidebar-nav .nav-section').forEach(function (section) {
        let anyVisible = false;
        section.querySelectorAll('a').forEach(function (a) {
          const match = !q || a.textContent.toLowerCase().includes(q);
          a.parentElement.style.display = match ? '' : 'none';
          if (match) anyVisible = true;
        });
        // Always keep the roles block visible
        if (section.classList.contains('nav-section-roles')) {
          section.style.display = '';
          return;
        }
        section.style.display = anyVisible || !q ? '' : 'none';
      });
    });
  }

  // ── Mobile sidebar ───────────────────────────────────────────
  function initMobileMenu() {
    const hamburger = document.getElementById('hamburger');
    const sidebar   = document.getElementById('sidebar');
    const overlay   = document.getElementById('sidebar-overlay');

    if (!hamburger || !sidebar) return;

    function openSidebar() {
      sidebar.classList.add('open');
      hamburger.classList.add('open');
      if (overlay) overlay.classList.add('open');
      document.body.style.overflow = 'hidden';
    }

    function closeSidebar() {
      sidebar.classList.remove('open');
      hamburger.classList.remove('open');
      if (overlay) overlay.classList.remove('open');
      document.body.style.overflow = '';
    }

    hamburger.addEventListener('click', function () {
      sidebar.classList.contains('open') ? closeSidebar() : openSidebar();
    });

    if (overlay) {
      overlay.addEventListener('click', closeSidebar);
    }

    // Close on nav link tap (mobile)
    sidebar.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function () {
        if (window.innerWidth <= 768) closeSidebar();
      });
    });

    // Close on resize back to desktop
    window.addEventListener('resize', function () {
      if (window.innerWidth > 768) closeSidebar();
    });
  }

  // ── Smooth scroll for anchor links ───────────────────────────
  function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
      anchor.addEventListener('click', function (e) {
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
          e.preventDefault();
          target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      });
    });
  }

  // ── Init ─────────────────────────────────────────────────────
  document.addEventListener('DOMContentLoaded', function () {
    markActiveLink();
    initSearch();
    initMobileMenu();
    initSmoothScroll();
  });

})();
