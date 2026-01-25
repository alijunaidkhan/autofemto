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
    const isBlog = path.includes('/blog/');
    
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
                <div class="nav-dropdown">
                    <button type="button" class="nav-btn dropdown-trigger ${isTools ? 'active' : ''}">
                        <span class="nav-icon">🛠️</span> Tools <span class="dropdown-arrow">▼</span>
                    </button>
                    <div class="dropdown-content">
                        <a href="${currentPage}tools/stopwatch.html">⏱️ Stopwatch</a>
                        <a href="${currentPage}tools/timer.html">⏲️ Timer</a>
                        <a href="${currentPage}tools/converter.html">🔄 Unit Converter</a>
                        <a href="${currentPage}tools/compound-calculator.html">💰 Compound Calculator</a>
                        <a href="${currentPage}index.html">📋 JSON Formatter</a>
                        <a href="${currentPage}tools/csv-json.html">📊 CSV to JSON</a>
                        <a href="${currentPage}tools/color-picker.html">🎨 Color Picker</a>
                        <a href="${currentPage}tools/qr-code.html">📱 QR Code</a>
                        <a href="${currentPage}tools.html" class="view-all">View All Tools →</a>
                    </div>
                </div>
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
        // Apply theme IMMEDIATELY, don't wait for DOM
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

// Initialize theme manager IMMEDIATELY (before DOM loads)
window.themeManager = new ThemeManager();

// Initialize navigation and animations on page load
document.addEventListener('DOMContentLoaded', () => {
    // Determine prefix based on current page location
    const path = window.location.pathname;
    let prefix = '';
    
    if (path.includes('/tools/')) {
        prefix = '../';
    } else if (path.includes('/services/')) {
        prefix = '../';
    } else if (path.includes('/blog/')) {
        prefix = '../';
    }
    
    // Insert navigation
    insertNavigation(prefix);
    
    // Setup dropdown toggle for mobile/click support
    setupDropdownToggle();
    
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

// Setup dropdown toggle functionality
function setupDropdownToggle() {
    const dropdown = document.querySelector('.nav-dropdown');
    const trigger = document.querySelector('.dropdown-trigger');
    const dropdownContent = document.querySelector('.dropdown-content');
    
    if (!dropdown || !trigger) return;
    
    // Toggle dropdown on click
    trigger.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        dropdown.classList.toggle('open');
    });
    
    // Keep dropdown open when hovering over content
    dropdownContent.addEventListener('mouseenter', () => {
        dropdown.classList.add('open');
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!dropdown.contains(e.target)) {
            dropdown.classList.remove('open');
        }
    });
    
    // Close dropdown when pressing Escape
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            dropdown.classList.remove('open');
        }
    });
    
    // Close dropdown when a link inside is clicked
    dropdownContent.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', () => {
            dropdown.classList.remove('open');
        });
    });
}
