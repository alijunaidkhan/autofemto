# Add aria-label to all emoji icons for accessibility
$patterns = @(
    @{regex='<div class="(icon|tool-icon)">([^<]+)</div>'; template='<div class="$1" role="img" aria-label="Icon">$2</div>'}
)

$htmlFiles = Get-ChildItem d:\autofemto -Include *.html -Recurse
$updatedCount = 0

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Replace icon divs that don't already have role/aria-label
    $content = $content -replace '<div class="(icon|tool-icon)">([^<]+)</div>', '<div class="$1" role="img" aria-label="Icon">$2</div>'
    
    # But don't double-add to ones that already have it
    $content = $content -replace '<div class="(icon|tool-icon)" role="img" aria-label="Icon" role="img" aria-label="Icon">', '<div class="$1" role="img" aria-label="Icon">'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
        $updatedCount++
        Write-Host "Updated: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`nTotal files updated: $updatedCount" -ForegroundColor Cyan

# Count total aria-labels added
$totalLabels = (Get-ChildItem d:\autofemto -Include *.html -Recurse | Select-String 'aria-label').Count
Write-Host "Total aria-labels found: $totalLabels" -ForegroundColor Green
