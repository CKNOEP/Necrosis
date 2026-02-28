# 🎉 Necrosis v8.3.0 Release

## ✨ New Features

### 🎟️ Summon Queue Module
- **Queue Management**: Add/remove players from summon queue with chat triggers
- **Multi-Trigger Support**: Configure custom trigger codes (e.g., "123", "summon", "inv")
- **Cross-Warlock Sync**: Synchronize queues between warlocks via AceComm-3.0
- **Auto-Remove**: Automatically removes players when in summon range
- **Audio Alerts**: Sound notifications when new players join queue
- **Draggable GUI**: Customizable queue window with ScrollFrame
- **8-Language Support**: Full localization (EN, FR, DE, ES, MX, RU, CN, TW)

### 🔍 Version Check Module
- **Automatic Updates**: Checks GitHub releases every 24 hours
- **Smart Notifications**: Chat and popup alerts when updates available
- **Manual Check**: `/necrosis version` slash command
- **Full Localization**: All 8 languages supported

### 📋 About Panel
- **In-Game Presentation**: `/necrosis about` frame with addon description
- **Credits & Links**: Community credits, CurseForge, GitHub, PayPal donation links
- **Professional Design**: Clean, informative interface

## 🐛 Bug Fixes & Improvements

### Localization Fixes
- **Fixed**: All hardcoded French text in tooltips and stone labels replaced with localized keys
- **Tooltips**: Left Click, Right Click, Configuration, Drag/Move labels now in all 8 languages
- **Stone Labels**: Soulstone, Healthstone, Spellstone, Firestone, Infernal Stone all localized
- **Result**: Proper language support across all WoW versions

### Configuration & UI
- **Panel Integration**: SummonQueue config added as 7th tab in `/necrosis` menu
- **Icon Support**: SummonQueue module includes custom icon (JPG, BLP, PNG)
- **Button Positioning**: Improved alignment and consistency across config pages
- **Panel.lua**: Restored complete configuration panel functionality

## 🌍 Supported Languages
- English (EN)
- Français (FR)
- Deutsch (DE)
- Español (ES)
- Español México (MX)
- Русский (RU)
- 简体中文 (CN)
- 繁體中文 (TW)

## 🎮 Supported WoW Versions
- **Classic/Vanilla** (11507)
- **Wrath of the Lich King** (30403)
- **Cataclysm Classic** (40402)

## 📦 Installation
1. Download from [CurseForge](https://www.curseforge.com/wow/addons/necrosis) or [GitHub](https://github.com/CKNOEP/Necrosis)
2. Extract to `World of Warcraft/_<version>_/Interface/AddOns/Necrosis/`
3. Reload UI or restart WoW
4. Type `/necrosis` to configure

## 🙏 Credits
- **Original Authors**: Lomig, lädygaga
- **Contributors**: 20+ years of community development
- **Translators**: Localization team (8 languages)
- **Testers**: WoW community feedback

## 📝 Full Changelog

**New Modules:**
- `SummonQueue.lua` (371 lines) - Queue management with AceComm sync
- `VersionCheck.lua` (350+ lines) - Automatic version checking
- `AboutPanel.lua` - In-game presentation frame

**Modified Files:**
- `Initialize.lua` - Localization fixes for tooltips and stone labels
- All 8 locale files - New localization keys (15 strings × 8 languages)
- All 3 TOC files - Version bump to 8.3.0
- `Panel.lua` - Added SummonQueue config panel (7th tab)

**Commits:**
- d2674cb - fix: Localize all tooltip and stone labels in main sphere
- 71ff907 - Fix: Update all .toc versions to 8.3.0
- 58647e9 - chore: Update version numbers and restore Panel.lua
- 17f3305 - feat: Localize all SummonQueue messages
- a0b7efd - feat: Add SummonQueue module icons and update .gitignore
- d105802 - feat: Add SummonQueue, VersionCheck, AboutPanel modules (v8.3.0)

## 🔗 Links
- **CurseForge**: https://www.curseforge.com/wow/addons/necrosis
- **GitHub**: https://github.com/CKNOEP/Necrosis
- **Issues/Bugs**: https://github.com/CKNOEP/Necrosis/issues
- **Donate**: Support development via PayPal

---

**Release Date**: February 23, 2026
**Made with ❤️ for the Warlock Community**
