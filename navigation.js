// Shared Navigation Component
function createNavigation(currentPage = '') {
    const nav = document.createElement('nav');
    nav.className = 'top-nav';
    
    const navContent = `
        <div class="nav-container">
            <div class="nav-left">
                <a href="${currentPage}index.html" class="nav-logo">AutoFemto</a>
            </div>
            <div class="nav-right">
                <a href="${currentPage}index.html" class="nav-btn ${currentPage === '' ? 'active' : ''}">
                    <span class="nav-icon">🏠</span> Home
                </a>
                <a href="${currentPage}about.html" class="nav-btn ${currentPage.includes('about') ? 'active' : ''}">
                    <span class="nav-icon">ℹ️</span> About
                </a>
                <a href="${currentPage}contact.html" class="nav-btn ${currentPage.includes('contact') ? 'active' : ''}">
                    <span class="nav-icon">✉️</span> Contact
                </a>
                <button id="theme-toggle" class="theme-toggle" aria-label="Toggle theme">
                    <span class="theme-icon">🌙</span>
                </button>
            </div>
        </div>
    `;
    
    nav.innerHTML = navContent;
    return nav;
}

// Insert navigation at the top of body
function insertNavigation(prefix = '') {
    const nav = createNavigation(prefix);
    document.body.insertBefore(nav, document.body.firstChild);
}

// Theme Management
class ThemeManager {
    constructor() {
        this.theme = localStorage.getItem('theme') || this.getSystemTheme();
        this.init();
    }
    
    getSystemTheme() {
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches) {
            return 'light';
        }
        return 'dark';
    }
    
    init() {
        this.applyTheme(this.theme);
        
        // Listen for system theme changes
        if (window.matchMedia) {
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
                if (!localStorage.getItem('theme')) {
                    this.applyTheme(e.matches ? 'dark' : 'light');
                }
            });
        }
        
        // Setup toggle button after DOM is loaded
        setTimeout(() => {
            const toggleBtn = document.getElementById('theme-toggle');
            if (toggleBtn) {
                toggleBtn.addEventListener('click', () => this.toggleTheme());
                this.updateToggleButton();
            }
        }, 100);
    }
    
    applyTheme(theme) {
        this.theme = theme;
        document.documentElement.setAttribute('data-theme', theme);
        this.updateToggleButton();
    }
    
    toggleTheme() {
        const newTheme = this.theme === 'dark' ? 'light' : 'dark';
        this.applyTheme(newTheme);
        localStorage.setItem('theme', newTheme);
    }
    
    updateToggleButton() {
        const toggleBtn = document.getElementById('theme-toggle');
        if (!toggleBtn) return;
        
        const icon = toggleBtn.querySelector('.theme-icon');
        if (icon) {
            icon.textContent = this.theme === 'dark' ? '☀️' : '🌙';
        }
        toggleBtn.setAttribute('aria-label', `Switch to ${this.theme === 'dark' ? 'light' : 'dark'} mode`);
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    // Determine prefix based on current page location
    const path = window.location.pathname;
    let prefix = '';
    
    if (path.includes('/tools/')) {
        prefix = '../';
    } else if (path.includes('/services/')) {
        prefix = '../';
    }
    
    // Insert navigation
    insertNavigation(prefix);
    
    // Initialize theme manager
    window.themeManager = new ThemeManager();
});
