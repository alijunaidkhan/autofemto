// Shared Navigation Component
function createNavigation(currentPage = '') {
    const nav = document.createElement('nav');
    nav.className = 'top-nav';
    
    // Detect current page from URL
    const path = window.location.pathname;
    const fileName = path.substring(path.lastIndexOf('/') + 1);
    
    // Determine active states
    const isHome = fileName === '' || fileName === 'index.html';
    const isAbout = fileName === 'about.html';
    const isContact = fileName === 'contact.html';
    const isTools = fileName === 'tools.html';
    
    const navContent = `
        <div class="nav-container">
            <div class="nav-left">
                <a href="${currentPage}index.html" class="nav-logo">
                    AutoFemto
                    <span class="nav-tagline" id="tagline"></span>
                </a>
            </div>
            <div class="nav-right">
                <a href="${currentPage}index.html" class="nav-btn ${isHome ? 'active' : ''}">
                    <span class="nav-icon">🏠</span> Home
                </a>
                <a href="${currentPage}tools.html" class="nav-btn ${isTools ? 'active' : ''}">
                    <span class="nav-icon">🛠️</span> Tools
                </a>
                <a href="${currentPage}about.html" class="nav-btn ${isAbout ? 'active' : ''}">
                    <span class="nav-icon">ℹ️</span> About
                </a>
                <a href="${currentPage}contact.html" class="nav-btn ${isContact ? 'active' : ''}">
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
    
    // Typing animation for tagline
    const text = "Automation at Quantum Speed!";
    const taglineElement = document.getElementById('tagline');
    let index = 0;
    let isTyping = true;
    
    function typeWriter() {
        if (taglineElement) {
            if (isTyping) {
                if (index < text.length) {
                    taglineElement.textContent = text.substring(0, index + 1);
                    index++;
                    setTimeout(typeWriter, 100);
                } else {
                    setTimeout(() => {
                        isTyping = false;
                        typeWriter();
                    }, 2000);
                }
            } else {
                if (index > 0) {
                    taglineElement.textContent = text.substring(0, index - 1);
                    index--;
                    setTimeout(typeWriter, 50);
                } else {
                    setTimeout(() => {
                        isTyping = true;
                        typeWriter();
                    }, 500);
                }
            }
        }
    }
    
    setTimeout(typeWriter, 500);
});
