// Simple search functionality for sidebar
(function() {
  const searchInput = document.getElementById('search-input');
  if (!searchInput) return;

  searchInput.addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const navSections = document.querySelectorAll('.nav-section');

    navSections.forEach(section => {
      const links = section.querySelectorAll('a');
      let hasVisibleLink = false;

      links.forEach(link => {
        const text = link.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
          link.parentElement.style.display = '';
          hasVisibleLink = true;
        } else {
          link.parentElement.style.display = 'none';
        }
      });

      // Show/hide section based on matches
      if (hasVisibleLink || searchTerm === '') {
        section.style.display = '';
      } else {
        section.style.display = 'none';
      }
    });
  });

  // Smooth scroll for anchor links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
})();
