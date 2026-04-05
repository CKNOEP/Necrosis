# Necrosis Midnight PTR Porting Status

## Completed Steps ✓

### 1. Initial Copy (Étape 1)
- [x] Copied Necrosis addon from _anniversary_ to _xptr_ directory

### 2. TOC File Creation (Étape 2)
- [x] Created `Necrosis_Midnight.toc`
- [x] Set Interface version to 110207
- [x] Configured to load Compat.lua first
- [x] Points to Necrosis-midnight.lua and Spells-Midnight.lua

### 3. Compatibility Layer (Étape 3)
- [x] Created `Compat.lua` with API shims:
  - [x] GetSpellInfo → C_Spell.GetSpellInfo
  - [x] GetSpellCooldown → C_Spell.GetSpellCooldown
  - [x] GetItemInfo → C_Item.GetItemInfo
  - [x] IsAddOnLoaded → C_AddOns.IsAddOnLoaded
  - [x] GetAddOnMetadata → C_AddOns.GetAddOnMetadata
  - [x] UnitAura → C_UnitAuras.GetAuraDataByUnit (custom wrapper)

### 4. Necrosis-midnight.lua (Étape 4)
- [x] Created from Necrosis-cata.lua
- [x] Fixed UnitAura at line 676 → C_UnitAuras.GetAuraDataByUnit
- [x] Fixed C_Container.GetContainerItemInfo at line 2394 → table-based access

### 5. Spells-Midnight.lua (Étape 5)
- [x] Created from Spells-Cata.lua
- [x] Added NOTE about verifying spell IDs for Midnight
- [x] Spell IDs inherited from Cata (needs verification with actual Midnight spells)

### 6. Critical Fixes (Étape 6)
- [x] XML/Attributes-cata.lua line 195: Removed GetSpellSubtext (ranks don't exist in Midnight)
- [x] Compat.lua: Added UnitAura wrapper for compatibility

## Known Issues to Verify

### API Changes
1. **Spell Ranks**: GetSpellSubtext() removed - fixed in Attributes-cata.lua
2. **Unit Auras**: UnitAura (by index) removed - wrapper provided but may need refinement
3. **Container Items**: C_Container.GetContainerItemInfo returns table instead of multi-return
4. **GetSpellInfo**: Now returns different fields (no "rank" field) - shimmed

### Pending Verification
- [ ] Spell IDs in Spells-Midnight.lua (verify against actual Midnight warlock spells)
- [ ] Test addon loads without Lua errors
- [ ] Test button clicks (left/right click sphère)
- [ ] Test spell casting (Fear, Curse, Drain)
- [ ] Test spell timers
- [ ] Test DoT/buff tracking
- [ ] Test configuration panel

## Files Modified

### Core Files
- `Necrosis_Midnight.toc` - **NEW**
- `Compat.lua` - **NEW**
- `Necrosis-midnight.lua` - **NEW** (from Cata, with fixes)
- `Spells-Midnight.lua` - **NEW** (from Cata, needs spell ID verification)

### Supporting Files
- `XML/Attributes-cata.lua` - Modified (removed GetSpellSubtext)

## Next Steps

1. **Launch WoW PTR Midnight** with warlock character
2. **Check for Lua errors**: `/console scriptErrors 1`
3. **Test basic functionality**:
   - Sphère visible and clickable
   - Left/right clicks respond
   - Spells available and clickable
   - Timers displaying correctly
4. **Verify spell IDs** and update Spells-Midnight.lua if needed
5. **Test advanced features**:
   - AFK system
   - Configuration options
   - Summon queue
   - Fear/DoT tracking

## API Reference

### Key Midnight API Changes
- `C_Spell.GetSpellInfo(spellID)` returns table (not multiple values)
- `C_Spell.GetSpellCooldown(spellID)` returns table
- `C_Container.GetContainerItemInfo(bag, slot)` returns table
- `C_UnitAuras.GetAuraDataByUnit(unit, [filter])` replaces UnitAura
- `C_AddOns.IsAddOnLoaded(addonName)` and `GetAddOnMetadata()`

## Compatibility Notes

Compat.lua provides backward-compatible wrappers to maintain existing code while supporting Midnight APIs. This allows the addon to work on both Midnight and previous expansions that still use legacy APIs.
