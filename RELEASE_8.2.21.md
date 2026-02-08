# Necrosis 8.2.21 - UI Configuration & New Features

## 🎉 Release Highlights

### ✨ What's New

#### 🖼️ UI Improvements
- **Button Configuration Page**: Completely reorganized layout
  - Repositioned all options 153px to the right for better visibility
  - Moved page indicators (1/2, 2/2) to bottom with navigation buttons at Y=60
  - Adjusted stone frame to Y=310 with 135px height
  - Adjusted menus frame to Y=160 with 135px height
  - Right navigation button now properly aligned at -125px from right edge

#### ⚙️ Sphere Configuration Enhancements
- **Slider Optimization**: Improved spacing with 15px gaps between sliders
  - Position: X=35, 125, 215 for optimal layout
  - Shortened labels: "Taille" (Size), "Rotation", "Distance"
- **New Event Option**: Added "% de menace" (Threat %) to sphere events dropdown
  - Fully localized in 8 languages (EN, FR, DE, ES, RU, CN, TW, MX)
  - Allows monitoring threat percentage on character sphere

#### 📝 Dialog Layout Improvements
- Repositioned main title "Choix des boutons à afficher" to Y=-20 (centered, top)
- Optimized "Right click on sphere" option at Y=225
- Better checkbox alignment at Y=200 and Y=225
- Improved visual hierarchy across configuration panels

### 🌍 Localization
Complete translations for new threat option:
- **English**: "Threat %"
- **Français**: "% de menace"
- **Deutsch**: "Bedrohung %"
- **Español**: "% de Amenaza"
- **Русский**: "% угрозы"
- **中文 (Simplified)**: "威胁 %"
- **中文 (Traditional)**: "威脅 %"
- **Mexicano**: "% de Amenaza"

### 🔧 Technical Changes
- Excluded `.claude` directory from git tracking
- Updated all version files to 8.2.21
- Maintained compatibility across all WoW versions
- Improved button visibility on first login with placeholder display

### 📦 Supported Versions
- ✅ WoW Classic Vanilla (11508)
- ✅ WoW TBC Classic (20505)
- ✅ WoW WotLK Classic (30403)
- ✅ WoW Cataclysm Classic (40400)
- ✅ WoW Anniversary Edition

## 📝 Notes for Testers

1. **First Login**: The addon UI now displays immediately on first login instead of after a 3-second delay
2. **Configuration Panel**: All UI elements are now properly aligned and spaced
3. **Threat Monitoring**: New threat percentage option is available in sphere configuration
4. **Language Support**: All new features are fully translated

## 🐛 Bug Fixes
- Fixed UI visibility on first login
- Improved frame positioning consistency
- Enhanced text label alignment across all configuration pages

## 📥 Installation
1. Download the latest release
2. Extract to your `Interface/AddOns/` directory
3. Restart WoW or type `/reload`
4. Configure in-game via right-click on the sphere

## 🔗 Links
- **Repository**: https://github.com/CKNOEP/Necrosis
- **Issues**: https://github.com/CKNOEP/Necrosis/issues
- **Previous Versions**: https://github.com/CKNOEP/Necrosis/releases

---

**Version**: 8.2.21
**Release Date**: February 8, 2026
**Supported Interface**: 11508, 20505, 30403, 40400
