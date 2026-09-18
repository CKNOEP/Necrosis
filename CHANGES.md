# Necrosis - Changelog

---

## Version 8.4.3 - March 3, 2026

### 🐛 Bug Fixes

- **Fixed critical error in Necrosis-cata.lua**: Corrected `TimerManagement` reference that was causing `attempt to index field 'TimerManagement' (a nil value)` error at lines 657-658
- **Removed debug messages**: Eliminated debug print statements from creature alert system that were cluttering chat output
- **Fixed corruption refresh timer lookup**: Corrected nil reference in spell timer lookup when refreshing corruption debuffs on targets

### ✨ Improvements

- **Code consistency**: Standardized `TimerManagement` references across `Necrosis.lua` and `Necrosis-cata.lua` for better maintainability
- **Better error handling**: Improved stability of the creature alert button system (Enslave Demon/Banish Elemental)

### 🔧 Technical Details

| File | Changes |
|------|---------|
| `Necrosis.lua` | Line 647: Fixed TimerManagement reference |
| `Necrosis-cata.lua` | Lines 657-658: Fixed TimerManagement reference |
| All TOC files | Updated version to 8.4.3 |

---

## Version 8.4.1 - Previous Release

Earlier versions documented in [git history](https://github.com/CKNOEP/Necrosis/commits/main)
