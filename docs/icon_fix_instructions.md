# App Icon Fix Instructions

## Root cause of the grey background + cropping

Android "adaptive icons" (API 26+) consist of TWO layers:

1. **Background layer** — fills a 108×108dp canvas (solid color or image)
2. **Foreground layer** — your artwork, also on a 108×108dp canvas

The launcher masks BOTH layers with a shape (circle, squircle, rounded-square, etc.).
The shape mask clips to the inner **72×72dp "safe zone"** — i.e. the outer **18dp on all four sides** is always cropped.

### What was wrong

`flutter_launcher_icons.yaml` had:

```yaml
adaptive_icon_background: "#e0f0e0"   # grey-green solid color (visible!)
adaptive_icon_foreground: "assets/simplynet.png"  # artwork fills 108dp → cropped 18dp each side
```

This caused:
- **Grey background** — the solid color `#e0f0e0` is visible where the artwork is transparent
- **~20% cropping** — artwork filled the full 108dp canvas so the outer 18dp (≈17% per side) was clipped

### Fix

Two steps:

**Step 1 — Create padded foreground PNG**

Open `assets/simplynet.png` in any image editor (GIMP, Photoshop, Affinity Photo).
- Canvas must be **1024×1024** (or any square)
- Resize the artwork DOWN to **66% of canvas** (≈680px in a 1024 canvas)
- Center it, leave 17% transparent padding on all four sides
- Save as `assets/simplynet_fg.png` (PNG with transparency)

**Step 2 — Create transparent background PNG**

Create a 1024×1024 fully transparent PNG and save as `assets/icon_bg.png`.
(Or use your brand color — just make sure the artwork edges don't bleed over it.)

**Step 3 — Regenerate icons**

```bash
flutter pub run flutter_launcher_icons:main
```

### Note on tree-shaking

The build output `"MaterialIcons-Regular.otf" was tree-shaken…` refers to the
Material Icons *font* (used for `Icons.wifi`, etc. in the app UI). This is
completely separate from app/launcher icons which are bitmap PNGs in
`android/app/src/main/res/mipmap-*/`. Tree-shaking cannot affect PNG files.
