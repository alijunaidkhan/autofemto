# Add Google Analytics to all tool pages
$GA_CODE = @'

    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-E5RNQ75Z8V"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'G-E5RNQ75Z8V');
    </script>
'@

$toolFiles = @(
    "base64.html",
    "color-picker.html", 
    "converter.html",
    "hash-generator.html",
    "image-resizer.html",
    "json-formatter.html",
    "qr-code.html",
    "text-tools.html",
    "timer.html"
)

foreach ($file in $toolFiles) {
    $filePath = "d:\autofemto\tools\$file"
    
    if (Test-Path $filePath) {
        Write-Host "Processing $file..." -ForegroundColor Cyan
        $content = Get-Content $filePath -Raw
        
        # Check if GA is already added
        if ($content -match "gtag") {
            Write-Host "  Already has Google Analytics" -ForegroundColor Yellow
        } else {
            # Add GA before the first link rel stylesheet
            if ($content -match '(\s+<link rel="stylesheet")') {
                $content = $content -replace '(\s+<link rel="stylesheet")', "$GA_CODE`n`$1"
                Set-Content -Path $filePath -Value $content -NoNewline
                Write-Host "  Added Google Analytics" -ForegroundColor Green
            } else {
                Write-Host "  Could not find insertion point" -ForegroundColor Red
            }
        }
        
        # Also update og-image PNG to SVG
        $content = Get-Content $filePath -Raw
        if ($content -match "og-image\.png") {
            $content = $content -replace 'og-image\.png', 'og-image.svg'
            Set-Content -Path $filePath -Value $content -NoNewline
            Write-Host "  Updated OG image to SVG" -ForegroundColor Green
        }
    } else {
        Write-Host "  File not found: $file" -ForegroundColor Red
    }
}

Write-Host "`nAll tool pages updated!" -ForegroundColor Green
