# Necrosis Forever Beta 1.60.1 Release

**Version**: v160001-fix  
**Release Date**: 2026-09-18  
**Compatibility**: World of Warcraft Forever Beta (Interface 160001)

## Overview

This release fixes critical compatibility issues for the Necrosis addon in World of Warcraft Forever Beta 1.60.1. All startup errors have been resolved and core functionality has been restored.

## Fixed Issues

### ✅ "Peau de Démon" (Demon Skin) not appearing in main spell dropdown

**Problem**: The spell "Peau de Démon" was not showing up in the main spell selection dropdown, despite being configured in the system.

**Root Cause**: The spell data entries for "armor" (Demon Skin) and "fel_armor" (Fel Armor) were commented out in the `Warlock_Spells` table, preventing them from being loaded.

**Solution**: 
- Uncommented spell entries in `Spells-Retail.lua` (lines 276-287, 290-292)
- Uncommented spell entries in `Spells-MOP.lua` (lines 266-277, 280-282)
- Note: `Spells-Cata.lua` already had these spells uncommented

**Status**: ✅ FIXED - "Peau de Démon" now appears correctly in the dropdown after `/reload`

---

### ✅ Pet/Buff/Curse menus not opening - Secure script errors

**Problem**: Pet, Buff, and Curse menus were not opening. Multiple "attempt to call a nil value" errors appeared in the chat when interacting with menu buttons.

**Root Cause**: The addon used a complex state management system for menus via `_onclick` and `_onattributechanged` secure scripts. This system relied on APIs that changed or are not available in Forever Beta 160001, causing the scripts to fail.

**Solution**:
1. **XML/Attributes_retail.lua** (lines 91-165):
   - Removed broken `SetAttribute("_onclick", ...)` and `SetAttribute("_onattributechanged", ...)` calls
   - Implemented a simplified OnClick toggle handler using Lua scripts instead of secure scripts
   - Menus now start hidden by default and toggle visibility on button click

2. **Necrosis_retail.lua**:
   - Removed `WrapScript()` calls for Pet menu buttons (lines 3299-3320)
   - Removed `WrapScript()` calls for Buff menu buttons (lines 3369-3388)  
   - Removed `WrapScript()` calls for Curse menu buttons (lines 3448-3469)

**Status**: ✅ FIXED - All menus open/close without errors

---

## Changes Summary

### Modified Files
- `Spells-Retail.lua`
- `Spells-MOP.lua`
- `XML/Attributes_retail.lua`
- `Necrosis_retail.lua`

### Testing Results
- ✅ No errors on addon startup
- ✅ "Peau de Démon" appears in main spell dropdown
- ✅ Pet menu opens/closes without errors
- ✅ Buff menu opens/closes without errors
- ✅ Curse menu opens/closes without errors
- ✅ All menu buttons are clickable and functional

## Known Limitations

- Menu state system has been simplified: menus no longer auto-close on combat or when leaving the menu area
- This is an acceptable trade-off for stability and compatibility with Forever Beta

## Installation

1. Place the Necrosis addon folder in your WoW Interface/AddOns directory
2. Launch WoW or `/reload` if already logged in
3. Enable the addon in your AddOns list

## Support

For issues or questions, refer to the addon's documentation or check for updates.

---

**Commit**: 0f2b72d  
**Release Tag**: v160001-fix  
**Author**: Claude Code  
