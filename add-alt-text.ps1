# Add aria-label to all emoji icons for accessibility and SEO
$replacements = @{
    '<div class="icon">⏱️</div>' = '<div class="icon" role="img" aria-label="Stopwatch icon">⏱️</div>'
    '<div class="icon">⏲️</div>' = '<div class="icon" role="img" aria-label="Timer icon">⏲️</div>'
    '<div class="icon">🔄</div>' = '<div class="icon" role="img" aria-label="Converter icon">🔄</div>'
    '<div class="icon">🎨</div>' = '<div class="icon" role="img" aria-label="Color picker icon">🎨</div>'
    '<div class="icon">📝</div>' = '<div class="icon" role="img" aria-label="Text tools icon">📝</div>'
    '<div class="icon">📋</div>' = '<div class="icon" role="img" aria-label="Clipboard icon">📋</div>'
    '<div class="icon">🔐</div>' = '<div class="icon" role="img" aria-label="Encoding icon">🔐</div>'
    '<div class="icon">🔑</div>' = '<div class="icon" role="img" aria-label="Hash key icon">🔑</div>'
    '<div class="icon">📱</div>' = '<div class="icon" role="img" aria-label="QR code icon">📱</div>'
    '<div class="icon">🖼️</div>' = '<div class="icon" role="img" aria-label="Image icon">🖼️</div>'
    '<div class="icon">🛠️</div>' = '<div class="icon" role="img" aria-label="Tools icon">🛠️</div>'
    '<div class="icon">✨</div>' = '<div class="icon" role="img" aria-label="Sparkles icon">✨</div>'
    '<div class="icon">💻</div>' = '<div class="icon" role="img" aria-label="Computer icon">💻</div>'
    '<div class="icon">🤖</div>' = '<div class="icon" role="img" aria-label="Robot icon">🤖</div>'
    '<div class="icon">⚡</div>' = '<div class="icon" role="img" aria-label="Lightning bolt icon">⚡</div>'
    '<div class="icon">🔒</div>' = '<div class="icon" role="img" aria-label="Lock icon">🔒</div>'
    '<div class="icon">🆓</div>' = '<div class="icon" role="img" aria-label="Free icon">🆓</div>'
    '<div class="tool-icon">⏱️</div>' = '<div class="tool-icon" role="img" aria-label="Stopwatch">⏱️</div>'
    '<div class="tool-icon">⏲️</div>' = '<div class="tool-icon" role="img" aria-label="Timer">⏲️</div>'
    '<div class="tool-icon">🔄</div>' = '<div class="tool-icon" role="img" aria-label="Unit Converter">🔄</div>'
    '<div class="tool-icon">🎨</div>' = '<div class="tool-icon" role="img" aria-label="Color Picker">🎨</div>'
    '<div class="tool-icon">📝</div>' = '<div class="tool-icon" role="img" aria-label="Text Tools">📝</div>'
    '<div class="tool-icon">📋</div>' = '<div class="tool-icon" role="img" aria-label="JSON Formatter">📋</div>'
    '<div class="tool-icon">🔐</div>' = '<div class="tool-icon" role="img" aria-label="Base64 Encoder">🔐</div>'
    '<div class="tool-icon">🔑</div>' = '<div class="tool-icon" role="img" aria-label="Hash Generator">🔑</div>'
    '<div class="tool-icon">📱</div>' = '<div class="tool-icon" role="img" aria-label="QR Code Generator">📱</div>'
    '<div class="tool-icon">🖼️</div>' = '<div class="tool-icon" role="img" aria-label="Image Resizer">🖼️</div>'
}

$htmlFiles = Get-ChildItem d:\autofemto -Include *.html -Recurse
$updatedCount = 0

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $changed = $false
    
    foreach ($key in $replacements.Keys) {
        if ($content -match [regex]::Escape($key)) {
            $content = $content -replace [regex]::Escape($key), $replacements[$key]
            $changed = $true
        }
    }
    
    if ($changed) {
        Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
        $updatedCount++
        Write-Host "Updated: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`nTotal files updated: $updatedCount" -ForegroundColor Cyan
Write-Host "Alt text/aria-labels added for accessibility!" -ForegroundColor Green
