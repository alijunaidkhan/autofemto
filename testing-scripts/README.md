# AutoFemto Testing Scripts

Automation scripts for sitemap generation, link checking, and search engine indexing.

---

## 📜 Scripts

### 1. **generate-sitemap.ps1**
Automatically generates `sitemap.xml` from all HTML files in the repository.

**Usage:**
```powershell
.\generate-sitemap.ps1
```

**Features:**
- Scans all HTML files automatically
- Maintains proper priorities and change frequencies
- Excludes utility files (google verification, etc.)
- Updates lastmod date to current date
- Organizes by category (homepage, main pages, services, tools)

**Output:** `sitemap.xml` in root directory

---

### 2. **check-broken-links.ps1**
Checks all HTML files for broken internal and external links.

**Usage:**
```powershell
# Check all links (including external)
.\check-broken-links.ps1

# Check internal links only (faster)
# Edit $checkExternalLinks = $false in the script
```

**Features:**
- Checks internal file links
- Validates external URLs (optional)
- Provides detailed error reports
- Exits with error code if broken links found (CI/CD ready)
- Skips common CDN links for speed

**Exit Codes:**
- `0` - All links working
- `1` - Broken links found

---

### 3. **ping-indexnow.ps1**
Pings IndexNow API to notify search engines of updated content.

**Setup (First Time):**

1. **Generate an API Key:**
   - Visit: https://www.uuidgenerator.net/
   - Copy the generated UUID (e.g., `12345678-abcd-1234-efgh-123456789012`)

2. **Create Key File:**
   ```powershell
   # In repository root
   echo "YOUR-UUID-KEY" > indexnow-key.txt
   ```

3. **Upload Key File:**
   - Upload `indexnow-key.txt` to your website root: `https://autofemto.com/indexnow-key.txt`
   - File should contain only the UUID key

**Usage:**
```powershell
# Ping homepage only
.\ping-indexnow.ps1

# Ping specific URLs
.\ping-indexnow.ps1 -urls @("https://autofemto.com/", "https://autofemto.com/tools.html")

# Ping all URLs from sitemap
.\ping-indexnow.ps1 -all

# Use custom API key
.\ping-indexnow.ps1 -all -apiKey "your-key-here"
```

**Features:**
- Notifies Bing, Yandex, and IndexNow partners
- Also pings Google and Bing sitemaps
- Logs all pings to `indexnow-ping.log`
- Supports batch URL submission

**When to Use:**
- After deploying new pages
- After significant content updates
- After fixing SEO issues
- Weekly/monthly for fresh crawling

---

## 🚀 Recommended Workflow

### Daily/Weekly Maintenance:
```powershell
# 1. Generate fresh sitemap
.\generate-sitemap.ps1

# 2. Check for broken links
.\check-broken-links.ps1

# 3. If all good, commit changes
git add sitemap.xml
git commit -m "Update sitemap"
git push
```

### After Deployment:
```powershell
# 1. Generate sitemap
.\generate-sitemap.ps1

# 2. Verify no broken links
.\check-broken-links.ps1

# 3. Notify search engines
.\ping-indexnow.ps1 -all
```

### Before Adding New Tool:
```powershell
# 1. Add your new HTML file
# 2. Regenerate sitemap
.\generate-sitemap.ps1

# 3. Verify links work
.\check-broken-links.ps1

# 4. Deploy and ping
# (after deployment)
.\ping-indexnow.ps1 -urls @("https://autofemto.com/tools/your-new-tool.html")
```

---

## 🔧 Configuration

### Sitemap Priorities
Edit `$pageConfig` in `generate-sitemap.ps1`:
- `1.0` - Homepage (highest)
- `0.95` - High-value tools
- `0.9` - Tools page, medium-value tools
- `0.85` - Other tools
- `0.8` - About, Contact
- `0.7` - Services
- `0.5` - Privacy, Legal

### Link Checker Timeout
Edit in `check-broken-links.ps1`:
```powershell
$timeout = 10  # seconds
$checkExternalLinks = $true  # Set to $false to skip external checks
```

---

## 📝 Logs

- **indexnow-ping.log** - Records all IndexNow API calls
- Script output can be redirected to files for logging

Example:
```powershell
.\generate-sitemap.ps1 > logs\sitemap-$(Get-Date -Format 'yyyy-MM-dd').log
```

---

## ⚡ Quick Tips

1. **Run all scripts before git push:**
   ```powershell
   .\generate-sitemap.ps1 && .\check-broken-links.ps1
   ```

2. **Check only specific tool:**
   ```powershell
   # Edit check-broken-links.ps1 to filter specific files
   ```

3. **Schedule automatic runs:**
   - Use Windows Task Scheduler
   - Or set up GitHub Actions (see Phase 2)

---

## 🐛 Troubleshooting

### "IndexNow ping failed"
- Verify `indexnow-key.txt` exists and is uploaded to website root
- Check URL format (must be https://)
- Wait 5-10 minutes between pings (rate limiting)

### "Broken links found" but they work
- External links may be temporarily down
- CDN links might block HEAD requests
- Check if link is actually accessible in browser

### "Sitemap not updating"
- Ensure script is run from repository root
- Check file permissions
- Verify HTML files are in expected locations

---

## 📊 Next Steps (Phase 2)

These scripts will be integrated into GitHub Actions for:
- Automatic sitemap generation on push
- Broken link checks in PR reviews
- Auto-pinging after successful deployment

---

**Created:** November 6, 2025  
**Status:** Phase 1 Complete ✅
