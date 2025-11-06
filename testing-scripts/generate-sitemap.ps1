# AutoFemto Sitemap Generator
# Automatically generates sitemap.xml from all HTML files in the repository
# Usage: .\generate-sitemap.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== AutoFemto Sitemap Generator ===" -ForegroundColor Cyan
Write-Host ""

# Configuration
$baseUrl = "https://autofemto.com"
$rootDir = ".."  # Parent directory (autofemto root)
$outputFile = Join-Path $rootDir "sitemap.xml"
$currentDate = (Get-Date).ToString("yyyy-MM-dd")

# Priority and changefreq mappings
$pageConfig = @{
    "index.html" = @{ priority = "1.0"; changefreq = "weekly" }
    "tools.html" = @{ priority = "0.9"; changefreq = "weekly" }
    "about.html" = @{ priority = "0.8"; changefreq = "monthly" }
    "contact.html" = @{ priority = "0.8"; changefreq = "monthly" }
    "privacy.html" = @{ priority = "0.5"; changefreq = "yearly" }
    
    # Tool pages - High priority
    "tools/stopwatch.html" = @{ priority = "0.95"; changefreq = "monthly" }
    "tools/timer.html" = @{ priority = "0.95"; changefreq = "monthly" }
    "tools/json-formatter.html" = @{ priority = "0.95"; changefreq = "monthly" }
    "tools/qr-code.html" = @{ priority = "0.95"; changefreq = "monthly" }
    "tools/base64.html" = @{ priority = "0.9"; changefreq = "monthly" }
    "tools/converter.html" = @{ priority = "0.9"; changefreq = "monthly" }
    "tools/hash-generator.html" = @{ priority = "0.85"; changefreq = "monthly" }
    "tools/text-tools.html" = @{ priority = "0.85"; changefreq = "monthly" }
    "tools/color-picker.html" = @{ priority = "0.85"; changefreq = "monthly" }
    "tools/image-resizer.html" = @{ priority = "0.85"; changefreq = "monthly" }
    
    # Service pages
    "services/custom-tools.html" = @{ priority = "0.7"; changefreq = "monthly" }
    "services/web-development.html" = @{ priority = "0.7"; changefreq = "monthly" }
    "services/automation-ai.html" = @{ priority = "0.7"; changefreq = "monthly" }
}

# Files to exclude from sitemap
$excludeFiles = @(
    "convert-og-image.html",
    "google*.html"
)

Write-Host "[*] Scanning for HTML files..." -ForegroundColor Yellow

# Find all HTML files
$htmlFiles = Get-ChildItem -Path $rootDir -Filter "*.html" -Recurse | Where-Object {
    $exclude = $false
    foreach ($pattern in $excludeFiles) {
        if ($_.Name -like $pattern) {
            $exclude = $true
            break
        }
    }
    -not $exclude -and $_.FullName -notmatch "\\guides\\" -and $_.FullName -notmatch "\\copilot-scripts\\" -and $_.FullName -notmatch "\\testing-scripts\\"
}

Write-Host "[OK] Found $($htmlFiles.Count) HTML files" -ForegroundColor Green
Write-Host ""

# Start building sitemap
$sitemap = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">

"@

$urlCount = 0

# Process homepage first
$indexFile = $htmlFiles | Where-Object { $_.Name -eq "index.html" -and $_.Directory.Name -eq "autofemto" }
if ($indexFile) {
    $sitemap += @"
    <!-- Homepage -->
    <url>
        <loc>$baseUrl/</loc>
        <lastmod>$currentDate</lastmod>
        <changefreq>weekly</changefreq>
        <priority>1.0</priority>
    </url>

"@
    $urlCount++
    Write-Host "[+] Added: Homepage" -ForegroundColor Green
}

# Group files by category
$mainPages = $htmlFiles | Where-Object { $_.Directory.Name -eq "autofemto" -and $_.Name -ne "index.html" }
$toolPages = $htmlFiles | Where-Object { $_.Directory.Name -eq "tools" }
$servicePages = $htmlFiles | Where-Object { $_.Directory.Name -eq "services" }

# Add main pages
if ($mainPages.Count -gt 0) {
    $sitemap += "    <!-- Main Pages -->`n"
    foreach ($file in $mainPages | Sort-Object Name) {
        $relativePath = $file.Name
        $url = "$baseUrl/$relativePath"
        
        $config = $pageConfig[$relativePath]
        if (-not $config) {
            $config = @{ priority = "0.7"; changefreq = "monthly" }
        }
        
        $sitemap += @"
    <url>
        <loc>$url</loc>
        <lastmod>$currentDate</lastmod>
        <changefreq>$($config.changefreq)</changefreq>
        <priority>$($config.priority)</priority>
    </url>

"@
        $urlCount++
        Write-Host "[+] Added: $relativePath" -ForegroundColor Green
    }
}

# Add service pages
if ($servicePages.Count -gt 0) {
    $sitemap += "`n    <!-- Service Pages -->`n"
    foreach ($file in $servicePages | Sort-Object Name) {
        $relativePath = "services/$($file.Name)"
        $url = "$baseUrl/$relativePath"
        
        $config = $pageConfig[$relativePath]
        if (-not $config) {
            $config = @{ priority = "0.7"; changefreq = "monthly" }
        }
        
        $sitemap += @"
    <url>
        <loc>$url</loc>
        <lastmod>$currentDate</lastmod>
        <changefreq>$($config.changefreq)</changefreq>
        <priority>$($config.priority)</priority>
    </url>

"@
        $urlCount++
        Write-Host "[+] Added: $relativePath" -ForegroundColor Green
    }
}

# Add tool pages
if ($toolPages.Count -gt 0) {
    $sitemap += "`n    <!-- Tools - High Search Volume -->`n"
    foreach ($file in $toolPages | Sort-Object Name) {
        $relativePath = "tools/$($file.Name)"
        $url = "$baseUrl/$relativePath"
        
        $config = $pageConfig[$relativePath]
        if (-not $config) {
            $config = @{ priority = "0.85"; changefreq = "monthly" }
        }
        
        $sitemap += @"
    <url>
        <loc>$url</loc>
        <lastmod>$currentDate</lastmod>
        <changefreq>$($config.changefreq)</changefreq>
        <priority>$($config.priority)</priority>
    </url>

"@
        $urlCount++
        Write-Host "[+] Added: $relativePath" -ForegroundColor Green
    }
}

# Close sitemap
$sitemap += "</urlset>`n"

# Write to file
$sitemap | Out-File -FilePath $outputFile -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "[SUCCESS] Sitemap generated successfully!" -ForegroundColor Green
Write-Host "[INFO] Total URLs: $urlCount" -ForegroundColor Yellow
Write-Host "[INFO] Output: $outputFile" -ForegroundColor Yellow
Write-Host "[INFO] Last Modified: $currentDate" -ForegroundColor Yellow
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Review the sitemap.xml file" -ForegroundColor Gray
Write-Host "2. Test it at: https://www.xml-sitemaps.com/validate-xml-sitemap.html" -ForegroundColor Gray
Write-Host "3. Submit to Google Search Console" -ForegroundColor Gray
Write-Host ""
