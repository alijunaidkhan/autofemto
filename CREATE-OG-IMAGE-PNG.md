# 🎨 Convert SVG to PNG for OG Image

## Why?
Some social media platforms (Twitter, Facebook, LinkedIn) prefer PNG format for better compatibility.

## Quick Method 1: Using Online Converter (EASIEST)

1. Go to: https://cloudconvert.com/svg-to-png
2. Upload `og-image.svg` from your autofemto folder
3. Set dimensions to: **1200 x 630 pixels**
4. Download the converted PNG
5. Save as `og-image.png` in your autofemto root folder

## Quick Method 2: Using Browser

1. Open `og-image.svg` in Chrome or Edge
2. Right-click → "Inspect" (F12)
3. Press Ctrl+Shift+P
4. Type "screenshot" → Select "Capture full size screenshot"
5. Save as `og-image.png`

## Quick Method 3: Using Inkscape (if installed)

```powershell
inkscape og-image.svg --export-type=png --export-width=1200 --export-height=630 -o og-image.png
```

## Quick Method 4: Using ImageMagick (if installed)

```powershell
magick convert -background none -size 1200x630 og-image.svg og-image.png
```

## After Converting:

1. Place `og-image.png` in `d:\autofemto\`
2. No need to update HTML files (we already have SVG)
3. Both formats will work - browsers/platforms will choose what they support

## Note:
The SVG version works fine for now! PNG is optional but recommended for maximum compatibility.

---

**Current Status**: SVG version created and linked ✅  
**Optional**: Convert to PNG when you have time
