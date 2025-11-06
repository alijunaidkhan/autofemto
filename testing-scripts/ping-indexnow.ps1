# AutoFemto IndexNow Ping
# Pings IndexNow API to notify search engines of updated content
# Usage: .\ping-indexnow.ps1 [-urls @("url1", "url2")] [-all]

param(
    [string[]]$urls = @(),
    [switch]$all = $false,
    [string]$apiKey = ""  # You'll need to generate an API key
)

$ErrorActionPreference = "Stop"

Write-Host "=== AutoFemto IndexNow Ping ===" -ForegroundColor Cyan
Write-Host ""

# Configuration
$rootDir = ".."  # Parent directory (autofemto root)
$host_url = "autofemto.com"
$keyLocation = "https://autofemto.com/indexnow-key.txt"
$indexNowEndpoint = "https://api.indexnow.org/indexnow"

# Check if API key is provided or exists
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    # Try to read from indexnow-key.txt if it exists
    $keyFile = Join-Path $rootDir "indexnow-key.txt"
    if (Test-Path $keyFile) {
        $apiKey = (Get-Content $keyFile).Trim()
        Write-Host "[OK] Using API key from $keyFile" -ForegroundColor Green
    }
    else {
        Write-Host "[ERROR] No API key provided!" -ForegroundColor Red
        Write-Host ""
        Write-Host "To use IndexNow, you need to:" -ForegroundColor Yellow
        Write-Host "1. Generate a UUID key: https://www.uuidgenerator.net/" -ForegroundColor Gray
        Write-Host "2. Create 'indexnow-key.txt' in root with just the key" -ForegroundColor Gray
        Write-Host "3. Upload the file to your website root" -ForegroundColor Gray
        Write-Host "4. Run this script again" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Example key format: 12345678-abcd-1234-efgh-123456789012" -ForegroundColor Gray
        Write-Host ""
        exit 1
    }
}

# If -all flag is set, ping all pages from sitemap
if ($all) {
    Write-Host "[*] Reading sitemap.xml..." -ForegroundColor Yellow
    
    $sitemapFile = Join-Path $rootDir "sitemap.xml"
    if (-not (Test-Path $sitemapFile)) {
        Write-Host "[ERROR] sitemap.xml not found!" -ForegroundColor Red
        Write-Host "Run .\generate-sitemap.ps1 first" -ForegroundColor Yellow
        exit 1
    }
    
    [xml]$sitemap = Get-Content $sitemapFile
    $urls = $sitemap.urlset.url.loc
    Write-Host "[OK] Found $($urls.Count) URLs in sitemap" -ForegroundColor Green
}
elseif ($urls.Count -eq 0) {
    # Default: ping homepage
    $urls = @("https://autofemto.com/")
    Write-Host "[INFO] No URLs specified, pinging homepage only" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "[*] Preparing to ping $($urls.Count) URL(s)..." -ForegroundColor Yellow
Write-Host ""

# Prepare JSON payload
$payload = @{
    host = $host_url
    key = $apiKey
    keyLocation = $keyLocation
    urlList = $urls
} | ConvertTo-Json -Depth 10

Write-Host "[PAYLOAD] Payload:" -ForegroundColor Cyan
Write-Host $payload -ForegroundColor Gray
Write-Host ""

# Send request to IndexNow
try {
    Write-Host "[*] Sending ping to IndexNow..." -ForegroundColor Yellow
    
    $response = Invoke-RestMethod -Uri $indexNowEndpoint `
        -Method Post `
        -ContentType "application/json; charset=utf-8" `
        -Body $payload `
        -ErrorAction Stop
    
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "[SUCCESS] IndexNow ping successful!" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Summary:" -ForegroundColor White
    Write-Host "  - URLs submitted: $($urls.Count)" -ForegroundColor Gray
    Write-Host "  - Search engines notified: Bing, Yandex, and partners" -ForegroundColor Gray
    Write-Host "  - Expected indexing: Within 24-48 hours" -ForegroundColor Gray
    Write-Host ""
    
    # Save ping log
    $logEntry = @{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        URLCount = $urls.Count
        Status = "Success"
    } | ConvertTo-Json
    
    Add-Content -Path (Join-Path $rootDir "indexnow-ping.log") -Value $logEntry
    
    Write-Host "[OK] Log saved to indexnow-ping.log" -ForegroundColor Green
    Write-Host ""
}
catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "[FAIL] IndexNow ping failed!" -ForegroundColor Red
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    
    if ($statusCode) {
        Write-Host "Status Code: $statusCode" -ForegroundColor Red
        
        switch ($statusCode) {
            200 { Write-Host "[OK] Success (but check response)" -ForegroundColor Yellow }
            202 { Write-Host "[OK] Accepted for processing" -ForegroundColor Green }
            400 { Write-Host "[ERROR] Bad Request - Check your URL format or API key" -ForegroundColor Red }
            403 { Write-Host "[ERROR] Forbidden - Invalid API key or key location" -ForegroundColor Red }
            422 { Write-Host "[ERROR] Unprocessable - URL format invalid" -ForegroundColor Red }
            429 { Write-Host "[ERROR] Too Many Requests - Rate limit exceeded" -ForegroundColor Red }
            default { Write-Host "[ERROR] Unexpected error" -ForegroundColor Red }
        }
    }
    
    Write-Host ""
    Write-Host "Error details:" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Verify your API key is correct" -ForegroundColor Gray
    Write-Host "2. Ensure indexnow-key.txt is uploaded to website root" -ForegroundColor Gray
    Write-Host "3. Check URLs are properly formatted (https://...)" -ForegroundColor Gray
    Write-Host "4. Verify your website is accessible" -ForegroundColor Gray
    Write-Host ""
    
    exit 1
}

# Also ping sitemap to major search engines (Google, Bing)
Write-Host "[*] Pinging sitemap to search engines..." -ForegroundColor Yellow
Write-Host ""

$sitemapUrl = "https://autofemto.com/sitemap.xml"

# Ping Google
try {
    $googlePingUrl = "https://www.google.com/ping?sitemap=$sitemapUrl"
    Write-Host "  [*] Pinging Google..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $googlePingUrl -Method Get -UseBasicParsing -TimeoutSec 10 | Out-Null
    Write-Host "  [OK] Google pinged successfully" -ForegroundColor Green
}
catch {
    Write-Host "  [WARN] Google ping failed (this is normal, Google may have received it)" -ForegroundColor Yellow
}

# Ping Bing
try {
    $bingPingUrl = "https://www.bing.com/ping?sitemap=$sitemapUrl"
    Write-Host "  [*] Pinging Bing..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $bingPingUrl -Method Get -UseBasicParsing -TimeoutSec 10 | Out-Null
    Write-Host "  [OK] Bing pinged successfully" -ForegroundColor Green
}
catch {
    Write-Host "  [WARN] Bing ping failed (this is normal, Bing may have received it)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[SUCCESS] All done! Your site has been submitted for indexing." -ForegroundColor Green
Write-Host ""
