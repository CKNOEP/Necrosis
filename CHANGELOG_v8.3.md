# Necrosis v8.3 Changelog

## Overview
Development session spanning February 15-23, 2026. Completed three releases with major new features and critical bugfixes.

---

## 🎉 v8.3.0 - Major Feature Release (2026-02-15)

### ✨ New Features

#### 🎟️ SummonQueue Module
- **Queue Management**: Add/remove players from summon queue with configurable chat triggers
- **Multi-Trigger Support**: Comma-separated trigger codes (e.g., "123, summon, inv, join")
- **Cross-Warlock Sync**: AceComm-3.0 based synchronization between warlocks
- **Auto-Remove**: Automatically removes players when in summon range
- **Audio Alerts**: Sound notifications (Quest Complete) when new players join
- **Draggable GUI**: Customizable queue window with ScrollFrame
- **Full Localization**: 15 strings × 8 languages (EN, FR, DE, ES, MX, RU, CN, TW)
- **Configuration Panel**: 6 options (enable, trigger, audio, auto-remove, sync, max queue size)

**Files:**
- `SummonQueue.lua` (371 lines)
- `XML/Options-SummonQueue.lua` (194 lines)

#### 🔍 VersionCheck Module
- **Automatic Checking**: Every 24 hours via GitHub releases API
- **Smart Notifications**: Chat and popup alerts when updates available
- **Manual Check**: `/necrosis version` slash command
- **Intelligent Version Parsing**: Handles major.minor.patch formats
- **8-Language Support**: Full localization

**Files:**
- `VersionCheck.lua` (350+ lines)

#### 📋 AboutPanel Module
- **In-Game Presentation**: `/necrosis about` interactive frame
- **Community Credits**: Detailed contributor acknowledgments
- **External Links**: CurseForge, GitHub, PayPal donation
- **Professional Design**: Clean, informative interface

**Files:**
- `XML/AboutPanel.lua`

#### 🌍 Full Localization
- **8 Languages**: EN, FR, DE, ES, MX, RU, CN, TW
- **50+ Localization Strings**: All UI text properly translated
- **AceLocale-3.0 Integration**: Professional localization framework

**Files Modified:**
- `Locales/Localization*.lua` (8 files)

### 📦 Integration
- Added SummonQueue as 7th config panel in `/necrosis` menu
- Icon: `Spell_Shadow_Summon`
- All 3 TOC files updated (Vanilla, Wrath, Cata)

**Commits:**
- `d105802` - feat: Add SummonQueue, VersionCheck, AboutPanel modules (v8.3.0)
- `a0b7efd` - feat: Add SummonQueue module icons and update .gitignore

---

## 🔥 v8.3.1 - Critical Hotfix Release (2026-02-23)

### 🐛 Critical Bugs Fixed

#### 1. SummonQueue Initialization Error
**Issue:** "attempt to index field 'SummonQueue' (a nil value)" on login

**Root Cause:** Module initialized at file load time before player data available via `UnitClass("player")`

**Solution:** Delayed initialization to `PLAYER_LOGIN` event

**Commit:** `e98ab42`

#### 2. Missing AceComm-3.0 Library
**Issue:** "Cannot find a library instance of 'AceComm-3.0'"

**Root Cause:** SummonQueue requires AceComm-3.0 but library was not declared in any .toc file

**Solution:** Added `libs\AceComm-3.0\AceComm-3.0.xml` to all 6 .toc files:
- Necrosis.toc
- Necrosis_Vanilla.toc
- Necrosis_Wrath.toc
- Necrosis_Cata.toc
- Necrosis-TBC.toc
- Necrosis_TBC.toc

**Commit:** `9b5e34b`

#### 3. Missing SpellActivations Overlay Textures
**Issue:** System messages: "Missing file for texture echo_of_the_elements" and "fury_of_stormrage"

**Root Cause:** Test overlay referenced non-existent texture files

**Solution:**
- Retrieved 3 missing .blp files from SpellActivationOverlay GitHub repository
- Added to `SpellActivations/textures/`:
  - `echo_of_the_elements.blp`
  - `fury_of_stormrage.blp`
  - `fury_of_stormrage_yellow.blp`

**Commit:** `a6f3631`

#### 4. Localization Nil Error
**Issue:** "attempt to index upvalue 'L' (a nil value)" at Initialize.lua:532

**Root Cause:** Initialize.lua used `L["TOOLTIP_*"]` keys but never loaded localization

**Solution:**
- Added localization loader at top of Initialize.lua
- Added fallback English strings table if AceLocale-3.0 not ready
- Ensures tooltips display even during early initialization

**Commits:**
- `7428dd0` - fix: Add missing localization declaration
- `77289c7` - fix: Add fallback localization table

### ✨ Feature Synchronization
**Issue:** Test Overlay button in Misc config used different textures than SpellActivations test button

**Solution:** Synchronized both buttons to use same test textures:
- Era: `echo_of_the_elements` + `fury_of_stormrage`
- Retail: `imp_empowerment` + `brain_freeze`

**Commit:** `2e29b0c`

### 📊 Commits in v8.3.1
- `2e29b0c` - feat: Synchronize Test Overlay button textures with SpellActivations
- `77289c7` - fix: Add fallback localization table in Initialize.lua
- `7428dd0` - fix: Add missing localization declaration in Initialize.lua
- `9b5e34b` - fix: Add missing AceComm-3.0 library to all TOC files
- `4c3e2d5` - Revert "fix: Replace missing texture references in SpellActivations test"
- `a6f3631` - feat: Add missing SpellActivations overlay textures
- `e98ab42` - fix: Delay SummonQueue initialization until PLAYER_LOGIN event

---

## 📦 v8.3.2 - Version Bump (2026-02-23)

### Changes
- Updated all 6 .toc files from version 8.3.1 to 8.3.2

**Commit:** `7e6eaf1` - chore: Bump version to 8.3.2

---

## 🧪 Testing & Validation

### Tested On
- ✅ WoW Anniversary Edition (_anniversary_)
- ✅ PC Portable installation
- ✅ All major features functional

### Validation Checklist
- ✅ Addon loads without errors on login
- ✅ SummonQueue module initializes correctly
- ✅ AceComm-3.0 library loads
- ✅ No texture warnings in system messages
- ✅ Localization displays properly
- ✅ Test Overlay buttons work identically
- ✅ All config panels accessible
- ✅ Cross-realm player names handled correctly

---

## 🔧 Development Setup

### Quick Start
```bash
# Clone repository
git clone https://github.com/CKNOEP/Necrosis.git
cd Necrosis/Necrosis

# Create symlink for WoW testing (one-time setup)
mklink /D "C:\Program Files (x86)\World of Warcraft\_anniversary_\Interface\AddOns\Necrosis" "C:\Path\To\Repo\Necrosis"

# Pull latest changes
git pull origin main

# Reload addon in-game
/reload
```

### Key Files Modified
**v8.3.0:**
- New: `SummonQueue.lua`, `VersionCheck.lua`, `XML/AboutPanel.lua`
- New: `XML/Options-SummonQueue.lua`
- Modified: All 3 TOC files, 8 locale files, `XML/Panel.lua`

**v8.3.1:**
- Modified: All 6 .toc files (added AceComm-3.0)
- Modified: `Initialize.lua` (localization fixes)
- Modified: `XML/Options-Misc.lua` (Test Overlay sync)
- Added: 3 SpellActivations overlay texture files

**v8.3.2:**
- Modified: All 6 .toc files (version bump)

---

## 📋 Supported WoW Versions
- **Classic/Vanilla** (Interface 11507)
- **Wrath of the Lich King** (Interface 30403)
- **Cataclysm Classic** (Interface 40402)
- **Timerunning/Anniversary** (_anniversary_)

---

## 🌍 Localization Support
- **English** (EN) - enUS
- **Français** (FR) - frFR
- **Deutsch** (DE) - deDE
- **Español** (ES) - esES
- **Español México** (MX) - esMX
- **Русский** (RU) - ruRU
- **简体中文** (CN) - zhCN
- **繁體中文** (TW) - zhTW

---

## 🔗 Links
- **GitHub Repository**: https://github.com/CKNOEP/Necrosis
- **CurseForge**: https://www.curseforge.com/wow/addons/necrosis
- **Releases**: https://github.com/CKNOEP/Necrosis/releases

---

## 👥 Credits
- **Original Authors**: Lomig, lädygaga (Sulfuron EUR)
- **Development**: 20+ years of community support
- **Localization**: Community translators (8 languages)
- **Testing**: WoW Classic/Retail community

---

**Release Date:** February 23, 2026
**Status:** ✅ Fully tested and stable
