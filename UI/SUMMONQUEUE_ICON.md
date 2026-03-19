# SummonQueue Module - Icon Integration

## Icon File
**Filename:** `SummonQueue-Icon.png` (or `.tga` after conversion)
**Location:** `UI/SummonQueue-Icon.png`
**Size:** 2048x2048 pixels
**Format:** PNG (or TGA for WoW optimization)

## Design
- **Style:** WoW Pixel Art (matches addon aesthetic)
- **Color Scheme:**
  - Green demon/flame outline
  - White summon cross (center)
  - Red mana/power points
  - Purple/black bordered circle
  - Dark background
- **Theme:** Warlock summoning magic with demonic elements

## Integration

### Option 1: Use PNG Directly (Easiest)
WoW supports PNG textures in modern versions. The icon can be used as-is:
```
Interface/AddOns/Necrosis/UI/SummonQueue-Icon.png
```

### Option 2: Convert to TGA (Recommended)
For maximum compatibility and file size optimization:
1. Open `SummonQueue-Icon.png` in GIMP, Photoshop, or online converter
2. Export as TGA (Targa) format
3. Save as `SummonQueue-Icon.tga`
4. Use path: `Interface/AddOns/Necrosis/UI/SummonQueue-Icon.tga`

**Online Converters:**
- Online-Convert.com
- CloudConvert.com
- GIMP (free): File → Export As → Select TGA format

### Option 3: Use WoW Default Icon
Current implementation uses `Spell_Shadow_Summon` from WoW spell icons.
To keep using this, no changes needed.

## Usage in Panel.lua

Current icon reference (line 194 of Panel.lua):
```lua
frame:SetNormalTexture("Interface\\Icons\\"..tex[i])
```

To use custom SummonQueue icon for the 7th tab, modify Panel.lua:
```lua
-- For panel tab 7 (SummonQueue), use custom icon:
if i == 6 then  -- 6th element in tex array = panel 7
    frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.png")
else
    frame:SetNormalTexture("Interface\\Icons\\"..tex[i])
end
```

## Alternative: Use for Queue Window

Could also use this icon in the SummonQueue window itself:
- As window header icon
- As button decorations
- As queue notification badge

## File Size
Original PNG: ~428 KB
Estimated TGA: ~12-16 MB (uncompressed)

**Recommendation:** Keep PNG format for addon distribution (smaller download size, modern WoW versions support it).
