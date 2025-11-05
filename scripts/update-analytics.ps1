# PowerShell script to add Google Analytics to all HTML files
# Run this after getting your GA_MEASUREMENT_ID from Google Analytics

$GA_CODE = @"
    
    <!-- Google Analytics - Replace YOUR_GA_MEASUREMENT_ID with your actual ID from Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=YOUR_GA_MEASUREMENT_ID"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'YOUR_GA_MEASUREMENT_ID');
    </script>
"@

# Find all HTML files that don't have Google Analytics yet
$htmlFiles = Get-ChildItem -Path "d:\autofemto" -Include *.html -Recurse | Where-Object {
    $content = Get-Content $_.FullName -Raw
    $content -notmatch "gtag" -and $content -match "<head>"
}

Write-Host "Found $($htmlFiles.Count) files to update" -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    $content = Get-Content $file.FullName -Raw
    
    # Find the position to insert (before </head> or before first <link rel="stylesheet">)
    if ($content -match '(<link rel="stylesheet")') {
        $content = $content -replace '(<link rel="stylesheet")', "$GA_CODE`n    `$1"
    } elseif ($content -match '(</head>)') {
        $content = $content -replace '(</head>)', "$GA_CODE`n`$1"
    }
    
    # Also update og-image.png to og-image.svg if exists
    $content = $content -replace 'og-image\.png', 'og-image.svg'
    
    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "  ✓ Updated $($file.Name)" -ForegroundColor Green
}

Write-Host "`n✓ All files updated!" -ForegroundColor Green
Write-Host "`nIMPORTANT: Replace YOUR_GA_MEASUREMENT_ID with your actual Google Analytics ID" -ForegroundColor Yellow
Write-Host "Get it from: https://analytics.google.com" -ForegroundColor Cyan
