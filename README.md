# AutoFemto - Automation & Productivity Tools

🚀 **Website:** [autofemto.com](https://autofemto.com)

## About

AutoFemto provides automation services and productivity tools including:
- Automation Services
- Automation Tools
- Utility Tools (Stopwatch, Timer, Converters, etc.)

## Deployment Guide

### Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com) and create a new repository
   - Repository name: `autofemto` (or any name you prefer)
   - Make it **Public**
   - Don't initialize with README (we already have one)

2. Push this code to GitHub:
   ```powershell
   cd d:\autofemto
   git init
   git add .
   git commit -m "Initial commit - Coming soon page"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/autofemto.git
   git push -u origin main
   ```

### Step 2: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Under "Source", select:
   - Branch: `main`
   - Folder: `/ (root)`
4. Click **Save**
5. Wait 2-3 minutes, your site will be live at: `https://YOUR_USERNAME.github.io/autofemto/`

### Step 3: Set Up Cloudflare (Optional but Recommended)

#### Why Cloudflare?
- Free CDN (faster loading worldwide)
- Free SSL certificate
- DDoS protection
- Analytics

#### Setup:
1. Go to [Cloudflare.com](https://cloudflare.com) and create a free account
2. Click **Add a Site** → Enter `autofemto.com`
3. Select the **Free Plan**
4. Cloudflare will scan your DNS records
5. Copy the Cloudflare nameservers (they'll look like: `ns1.cloudflare.com`, `ns2.cloudflare.com`)

### Step 4: Update Namecheap DNS

#### Option A: Using Cloudflare (Recommended)
1. Log in to [Namecheap](https://namecheap.com)
2. Go to **Domain List** → Click **Manage** next to autofemto.com
3. Find **Nameservers** section
4. Change from "Namecheap BasicDNS" to **Custom DNS**
5. Enter the Cloudflare nameservers you got in Step 3
6. Click the ✓ (checkmark) to save

#### Option B: Direct to GitHub Pages (Without Cloudflare)
1. Log in to [Namecheap](https://namecheap.com)
2. Go to **Domain List** → Click **Manage** next to autofemto.com
3. Go to **Advanced DNS** tab
4. Add these records:

   | Type | Host | Value | TTL |
   |------|------|-------|-----|
   | A Record | @ | 185.199.108.153 | Automatic |
   | A Record | @ | 185.199.109.153 | Automatic |
   | A Record | @ | 185.199.110.153 | Automatic |
   | A Record | @ | 185.199.111.153 | Automatic |
   | CNAME Record | www | YOUR_USERNAME.github.io | Automatic |

5. Click **Save All Changes**

### Step 5: Configure Custom Domain on GitHub

1. Go to your GitHub repository → **Settings** → **Pages**
2. Under "Custom domain", enter: `autofemto.com`
3. Click **Save**
4. Check **Enforce HTTPS** (after DNS propagates, ~24 hours)

### Step 6: If Using Cloudflare - Add DNS Records

1. In Cloudflare dashboard, go to **DNS** → **Records**
2. Add these records:

   | Type | Name | Content | Proxy Status |
   |------|------|---------|--------------|
   | A | @ | 185.199.108.153 | Proxied (orange) |
   | A | @ | 185.199.109.153 | Proxied (orange) |
   | A | @ | 185.199.110.153 | Proxied (orange) |
   | A | @ | 185.199.111.153 | Proxied (orange) |
   | CNAME | www | YOUR_USERNAME.github.io | Proxied (orange) |

3. Go to **SSL/TLS** → Set to **Full**

## Verification

- Wait 10-30 minutes for DNS propagation
- Visit `https://autofemto.com`
- Your site should be live! 🎉

## Future Development

### Tools to Add:
- [ ] Stopwatch
- [ ] Timer/Countdown
- [ ] Unit Converter
- [ ] Color Picker
- [ ] Text Tools (case converter, word counter)
- [ ] More automation utilities

### Project Structure:
```
autofemto/
├── index.html          # Landing page
├── styles.css          # Styling
├── script.js           # JavaScript
├── tools/              # Future: individual tool pages
│   ├── stopwatch.html
│   ├── timer.html
│   └── converter.html
└── README.md          # This file
```

## Tech Stack

- **Frontend:** HTML, CSS, JavaScript (pure - no frameworks initially)
- **Hosting:** GitHub Pages (free)
- **CDN:** Cloudflare (free)
- **Domain:** Namecheap

## Notes

- Everything is currently 100% free
- Static site = fast loading
- Easy to update (just push to GitHub)
- Scalable for future tools

## Contact

For questions or suggestions, visit [autofemto.com](https://autofemto.com)

---

Made with ❤️ by AutoFemto Team
