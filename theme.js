// Theme Switcher Script
(function() {
    // Get saved theme or use system preference
    function getPreferredTheme() {
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            return savedTheme;
        }
        
        // Check system preference
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches) {
            return 'light';
        }
        
        return 'dark';
    }

    // Apply theme
    function applyTheme(theme) {
        if (theme === 'system') {
            document.documentElement.removeAttribute('data-theme');
        } else {
            document.documentElement.setAttribute('data-theme', theme);
        }
        localStorage.setItem('theme', theme);
        
        // Update select if it exists
        const themeSelect = document.getElementById('theme-select');
        if (themeSelect) {
            themeSelect.value = theme;
        }
    }

    // Initialize theme on page load
    const currentTheme = getPreferredTheme();
    applyTheme(currentTheme);

    // Listen for theme changes
    document.addEventListener('DOMContentLoaded', function() {
        const themeSelect = document.getElementById('theme-select');
        if (themeSelect) {
            themeSelect.value = localStorage.getItem('theme') || 'system';
            
            themeSelect.addEventListener('change', function(e) {
                applyTheme(e.target.value);
            });
        }
    });

    // Listen for system theme changes
    if (window.matchMedia) {
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
            if (localStorage.getItem('theme') === 'system' || !localStorage.getItem('theme')) {
                applyTheme('system');
            }
        });
    }
})();
