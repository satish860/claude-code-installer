// Platform Detection
function detectPlatform() {
    const userAgent = window.navigator.userAgent.toLowerCase();
    const platform = window.navigator.platform.toLowerCase();

    if (platform.indexOf('mac') !== -1 || userAgent.indexOf('mac') !== -1) {
        return 'mac';
    } else if (platform.indexOf('win') !== -1 || userAgent.indexOf('win') !== -1) {
        return 'windows';
    }
    return 'windows'; // Default to Windows
}

// Highlight platform-specific download button
function highlightPlatformButton() {
    const platform = detectPlatform();
    const windowsBtn = document.getElementById('windows-btn');
    const macBtn = document.getElementById('mac-btn');

    if (platform === 'mac') {
        macBtn.classList.remove('btn-secondary');
        macBtn.classList.add('btn-primary');
        windowsBtn.classList.remove('btn-primary');
        windowsBtn.classList.add('btn-secondary');
    }
}

// Fetch Latest Release Version from GitHub API
async function fetchLatestRelease() {
    try {
        const response = await fetch('https://api.github.com/repos/satish860/claude-code-installer/releases/latest');
        const data = await response.json();

        const versionInfo = document.getElementById('version-info');
        if (data.tag_name) {
            versionInfo.textContent = `Latest version: ${data.tag_name} (${formatDate(data.published_at)})`;
        }
    } catch (error) {
        console.error('Error fetching release info:', error);
        document.getElementById('version-info').textContent = 'Latest version: v1.0.0';
    }
}

// Format date to readable format
function formatDate(dateString) {
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('en-US', options);
}

// Tab Switching for Platform Instructions
function setupTabs() {
    const tabButtons = document.querySelectorAll('.tab-btn');

    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            const platform = button.dataset.platform;

            // Update active tab button
            tabButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');

            // Show corresponding content
            document.querySelectorAll('.platform-content').forEach(content => {
                content.classList.add('hidden');
            });
            document.getElementById(`${platform}-content`).classList.remove('hidden');
        });
    });

    // Set default tab based on platform
    const platform = detectPlatform();
    const defaultTab = document.querySelector(`[data-platform="${platform}"]`);
    if (defaultTab) {
        defaultTab.click();
    }
}

// Smooth Scroll for Anchor Links
function setupSmoothScroll() {
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
}

// Add scroll animations
function setupScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    document.querySelectorAll('.problem-card, .feature-card, .faq-item').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
}

// Copy code to clipboard functionality
function setupCodeCopy() {
    document.querySelectorAll('code').forEach(codeBlock => {
        // Only add click handler to code blocks that look like commands
        if (codeBlock.textContent.trim().length > 3) {
            codeBlock.style.cursor = 'pointer';
            codeBlock.title = 'Click to copy';

            codeBlock.addEventListener('click', async () => {
                try {
                    await navigator.clipboard.writeText(codeBlock.textContent.trim());

                    // Visual feedback
                    const originalText = codeBlock.textContent;
                    codeBlock.textContent = 'Copied!';
                    setTimeout(() => {
                        codeBlock.textContent = originalText;
                    }, 1000);
                } catch (err) {
                    console.error('Failed to copy:', err);
                }
            });
        }
    });
}

// Download tracking (optional analytics)
function trackDownload(platform) {
    console.log(`Download initiated for ${platform}`);
    // Add analytics tracking here if needed
}

// Add download tracking to buttons
function setupDownloadTracking() {
    document.querySelectorAll('a[href*="ClaudeCodeInstaller"]').forEach(link => {
        link.addEventListener('click', (e) => {
            const platform = link.href.includes('.msi') ? 'Windows' : 'macOS';
            trackDownload(platform);
        });
    });
}

// Add hover effect to cards
function setupCardHoverEffects() {
    const cards = document.querySelectorAll('.problem-card, .feature-card, .requirement-card, .faq-item');

    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transition = 'transform 0.3s ease, box-shadow 0.3s ease';
        });
    });
}

// Initialize all functionality when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    highlightPlatformButton();
    fetchLatestRelease();
    setupTabs();
    setupSmoothScroll();
    setupScrollAnimations();
    setupCodeCopy();
    setupDownloadTracking();
    setupCardHoverEffects();
});

// Add parallax effect to hero section
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const hero = document.querySelector('.hero');
    if (hero && scrolled < hero.offsetHeight) {
        hero.style.transform = `translateY(${scrolled * 0.5}px)`;
    }
});

// Fallback for older browsers that don't support IntersectionObserver
if (!('IntersectionObserver' in window)) {
    document.querySelectorAll('.problem-card, .feature-card, .faq-item').forEach(el => {
        el.style.opacity = '1';
        el.style.transform = 'translateY(0)';
    });
}
