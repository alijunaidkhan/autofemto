# AutoFemto Link Checker
# Checks all HTML files for broken internal and external links
# Usage: .\check-broken-links.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== AutoFemto Link Checker ===" -ForegroundColor Cyan
Write-Host ""

# Configuration
$rootDir = ".."  # Parent directory (autofemto root)
$checkExternalLinks = $true  # Set to $false to skip external link checking
$timeout = 10  # Timeout in seconds for external links
$baseUrl = "https://autofemto.com"

# Counters
$totalLinks = 0
$brokenLinks = 0
$warningLinks = 0
$successLinks = 0

# Results arrays
$brokenLinksList = @()
$warningLinksList = @()

Write-Host "[*] Scanning HTML files..." -ForegroundColor Yellow

# Find all HTML files
$htmlFiles = Get-ChildItem -Path $rootDir -Filter "*.html" -Recurse | Where-Object {
    $_.FullName -notmatch "\\guides\\" -and 
    $_.FullName -notmatch "\\copilot-scripts\\" -and 
    $_.FullName -notmatch "\\testing-scripts\\" -and
    $_.Name -notlike "google*.html"
}

Write-Host "[OK] Found $($htmlFiles.Count) HTML files to check" -ForegroundColor Green
Write-Host ""

# Function to check if a file exists
function Test-LocalLink {
    param($link, $currentFile)
    
    $currentDir = $currentFile.DirectoryName
    
    # Remove anchor/hash
    $linkWithoutAnchor = $link -replace '#.*$', ''
    
    if ([string]::IsNullOrWhiteSpace($linkWithoutAnchor)) {
        return $true  # Anchor-only links are valid
    }
    
    # Resolve relative path
    $fullPath = Join-Path $currentDir $linkWithoutAnchor
    $fullPath = [System.IO.Path]::GetFullPath($fullPath)
    
    return Test-Path $fullPath
}

# Function to check external link
function Test-ExternalLink {
    param($url)
    
    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec $timeout -UseBasicParsing -ErrorAction Stop
        return @{
            Status = $response.StatusCode
            Success = $true
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode) {
            return @{
                Status = $statusCode
                Success = $false
                Error = $_.Exception.Message
            }
        }
        return @{
            Status = "Error"
            Success = $false
            Error = $_.Exception.Message
        }
    }
}

# Process each HTML file
foreach ($file in $htmlFiles) {
    $relativePath = $file.FullName -replace [regex]::Escape($PSScriptRoot + "\.."), "." -replace "\\", "/"
    Write-Host "[CHECK] Checking: $relativePath" -ForegroundColor Cyan
    
    $content = Get-Content $file.FullName -Raw
    
    # Extract all links (href and src attributes)
    $linkPattern = '(?:href|src)=["' + "'" + ']([^"' + "'" + ']+)["' + "'" + ']'
    $matches = [regex]::Matches($content, $linkPattern)
    
    foreach ($match in $matches) {
        $link = $match.Groups[1].Value
        $totalLinks++
        
        # Skip certain links
        if ($link -match '^(mailto:|tel:|javascript:|#$|data:)') {
            continue
        }
        
        # Check internal links
        if (-not ($link -match '^https?://')) {
            if (-not (Test-LocalLink $link $file)) {
                $brokenLinks++
                $brokenLinksList += [PSCustomObject]@{
                    File = $relativePath
                    Link = $link
                    Type = "Internal"
                    Issue = "File not found"
                }
                Write-Host "  [ERROR] Broken internal link: $link" -ForegroundColor Red
            }
            else {
                $successLinks++
            }
        }
        # Check external links
        elseif ($checkExternalLinks) {
            # Skip very common CDN/external links to speed up
            if ($link -match '(googleapis\.com|cloudflare\.com|cdnjs\.com|jsdelivr\.net)') {
                $successLinks++
                continue
            }
            
            Write-Host "  [EXT] Checking external: $link" -ForegroundColor Gray
            $result = Test-ExternalLink $link
            
            if ($result.Success) {
                $successLinks++
                Write-Host "  [OK] Status ($($result.Status))" -ForegroundColor Green
            }
            elseif ($result.Status -ge 400) {
                $brokenLinks++
                $brokenLinksList += [PSCustomObject]@{
                    File = $relativePath
                    Link = $link
                    Type = "External"
                    Issue = "Status $($result.Status)"
                }
                Write-Host "  [ERROR] Broken ($($result.Status)): $link" -ForegroundColor Red
            }
            else {
                $warningLinks++
                $warningLinksList += [PSCustomObject]@{
                    File = $relativePath
                    Link = $link
                    Type = "External"
                    Issue = $result.Error
                }
                Write-Host "  [WARN] Warning: $($result.Error)" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host ""
}

# Summary Report
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Link Check Summary" -ForegroundColor White
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Total links checked: $totalLinks" -ForegroundColor White
Write-Host "[OK] Working links: $successLinks" -ForegroundColor Green
Write-Host "[WARN] Warnings: $warningLinks" -ForegroundColor Yellow
Write-Host "[ERROR] Broken links: $brokenLinks" -ForegroundColor Red
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Detailed broken links report
if ($brokenLinksList.Count -gt 0) {
    Write-Host "[ERROR] BROKEN LINKS DETAILS:" -ForegroundColor Red
    Write-Host ""
    $brokenLinksList | Format-Table -AutoSize
    Write-Host ""
}

# Warnings report
if ($warningLinksList.Count -gt 0) {
    Write-Host "[WARN] WARNINGS:" -ForegroundColor Yellow
    Write-Host ""
    $warningLinksList | Format-Table -AutoSize
    Write-Host ""
}

# Exit with error code if broken links found
if ($brokenLinks -gt 0) {
    Write-Host "[FAIL] BUILD FAILED: $brokenLinks broken link(s) found!" -ForegroundColor Red
    exit 1
}
else {
    Write-Host "[SUCCESS] All links are working!" -ForegroundColor Green
    exit 0
}
