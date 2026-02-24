# Necrosis v8.3.3 - Localization & Compatibility Fixes

**Release Date:** February 24, 2026

## 🐛 Critical Bug Fixes

### Localization Issues
- ✅ **Fixed French tooltips not displaying** - Tooltips now properly show localized text (e.g., "Pierre d'âme" instead of "Soulstone", "Clic droit" instead of "Right Click")
- ✅ **Fixed NECROSIS_ID loading order** - Core initialization now loads via XML to ensure addon ID is defined before locale registration
- ✅ **Added fallback localization keys** - Soul shard and demon management tooltips now have proper translations in all 8 languages

### Chat & UI
- ✅ **Fixed SummonQueue debug spam** - Removed debug print statements that were showing `[SummonQueue]` messages on every chat line
- ✅ **Fixed GetColoredName error (Classic/Wrath)** - Added fallback for function that only exists in Retail

## 🌍 Localization Improvements

### New Localized Keys (8 Languages)
- `SHARD_MOUSEWHEEL_HELP` - MouseWheel instructions for soul shard management
- `SHARD_LEFTCLICK_HELP` - Left-click instructions for shard relocation
- `SPELLSTONE_CHARGES` - Spellstone charge display
- `DEMON_COOLDOWN` - Demon invulnerability timer display

### Languages Updated
- 🇬🇧 English (enUS)
- 🇫🇷 French (frFR)
- 🇩🇪 German (deDE)
- 🇪🇸 Spanish (esES)
- 🇲🇽 Mexican Spanish (esMX)
- 🇷🇺 Russian (ruRU)
- 🇨🇳 Simplified Chinese (zhCN)
- 🇹🇼 Traditional Chinese (zhTW)

## 📋 Technical Changes

### Load Order Fix
Fixed critical addon load sequence:
1. Necrosis.xml loads (now includes Core-Init.lua script)
2. NECROSIS_ID defined globally
3. AceLocale-3.0 framework ready
4. Locale files register with addon ID
5. Initialize.lua processes with localized strings

### Compatibility
- ✅ Classic (11507)
- ✅ Wrath of the Lich King (30403)
- ✅ Cataclysm Classic (40400+)
- ✅ All retail versions

## 🔧 Files Modified

```
Core-Init.lua (new) - Core addon initialization
Necrosis.xml - Added Core-Init.lua script
Necrosis.lua - Removed debug code, localized strings
AFKS.lua - Added GetColoredName fallback
Initialize.lua - Load order & localization fixes
SummonQueue.lua - Removed debug prints
All .toc files - Updated load order
All Locales - Added 4 new translation keys × 8 languages
```

## 📝 Known Issues Being Investigated

- Tooltip localization initialization sequence (to be optimized in future releases)

## 🙏 Testing

Tested on:
- WoW Anniversary Edition (Classic)
- All locales
- All button tooltips

## ✨ What's Next

- v8.3.4: Optimization of locale loading sequence
- Future: Additional UI enhancements

---

**Download:** [CurseForge](https://www.curseforge.com/wow/addons/necrosis) | [GitHub](https://github.com/CKNOEP/Necrosis/releases)

**Report Issues:** [GitHub Issues](https://github.com/CKNOEP/Necrosis/issues)
