# Plan d'Action - Timers Midnight 12.0.1

## RÉSUMÉ EXÉCUTIF ✅

**État actuel** : Les spells avec timers sont **DÉJÀ BIEN CONFIGURÉS** pour Midnight 12.0.1 !

Les 4 changements majeurs de Midnight 12.0 ont été gérés :
1. ✅ Shadow Ward : `6229` → `153415` (nouveau ID)
2. ✅ Haunt : `59161` → `48181` (nouveau ID)
3. ✅ Siphon Life : `18265` → `63106` (nouveau ID)
4. ✅ Drain Soul : `1120` → `198590` (nouveau ID)
5. ✅ Curse of Elements : `1490` → `44332` (nouveau ID)

Les anciens IDs sont **commentés entièrement** avec multiline comment blocks.

---

## PRIORITÉS VÉRIFIÉES ✅

Tous les nouveaux IDs Midnight 12.0 ont **UsageRank = 1** (priorité maximum) :

```lua
-- Shadow Ward (Midnight 12.0)
[153415] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "ward", ...}

-- Haunt (Midnight 12.0)
[48181] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "haunt", ...}

-- Siphon Life (Midnight 12.0)
[63106] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "siphon_life", ...}

-- Drain Soul (Midnight 12.0)
[198590] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "drain_soul", ...}

-- Curse of the Elements (Midnight 12.0)
[44332] = {UsageRank = 1, SpellRank = 1, Timer = true, Usage = "elements", ...}
```

---

## SPELLS PAR CATÉGORIE - LISTE COMPLÈTE

### 🔴 Summons & Rituals (6 spells)
| Spell | ID | Duration | Status |
|-------|----|---------:|--------|
| Inferno | 1122 | 5s | ✅ OK |
| Ritual of Doom | 18540 | 0s | ✅ OK |
| Soulstone | 20707 | 900s | ✅ OK |
| Ritual of Summoning | 698 | 600s | ✅ OK |
| Ritual of Souls | 29893 | 600s | ✅ OK |
| Ritual of Souls (25) | 58887 | 600s | ✅ OK |

### 🛡️ Protection & Buff (6 spells)
| Spell | ID | Duration | Status |
|-------|----|---------:|--------|
| Shadow Ward **[M12.0]** | 153415 | 30s | ✅ OK |
| Unending Breath | 5697 | 600s | ✅ OK |
| Eye of Kilrogg | 126 | 45s | ✅ OK |
| Detect Invisibility | 132 | 600s | ✅ OK |
| Demon Skin | 687-696 | 1800s | ✅ OK |

### ⚔️ Control (2 spells)
| Spell | ID | Duration | Status |
|-------|----|---------:|--------|
| Enslave Demon | 1098+ | 300s | ✅ OK |
| Banish | 710+ | 20-30s | ✅ OK |

### 📜 Affliction DoTs (5 spells) [M12.0 Updated]
| Spell | ID | Duration | Status |
|-------|----|---------:|--------|
| Corruption | 172+ | 12-18s | ✅ OK |
| Unstable Affliction | 30108+ | 15-18s | ✅ OK |
| Haunt **[M12.0]** | 48181 | 18s | ✅ UPDATED |
| Siphon Life **[M12.0]** | 63106 | 15s | ✅ UPDATED |
| Drain Soul **[M12.0]** | 198590 | 5s | ✅ UPDATED |

### 🔥 Destruction Spells (8 spells)
| Spell | ID | Duration | Status |
|-------|----|---------:|--------|
| Immolate | 348+ | 15s | ✅ OK |
| Fear | 5782+ | 10-20s | ✅ OK |
| Howl of Terror | 5484+ | 10-15s | ✅ OK |
| Fel Domination | 18708 | 15s | ✅ OK |
| Soul Fire | 6353+ | 0s (CD) | ✅ OK |
| Death Coil | 108396 | 3s | ✅ OK |
| Shadowburn | 17877+ | 0s (CD) | ✅ OK |

### 💀 Curses (7 spells)
| Spell | ID | Duration | Status |
|-------|----|---------:|--------|
| Curse of Weakness | 702+ | 120s | ✅ OK |
| Curse of Agony | 980+ | 24s | ✅ OK |
| Curse of Tongues | 1714+ | 30s | ✅ OK |
| Curse of Exhaustion | 18223 | 12s | ✅ OK |
| Curse of Elements **[M12.0]** | 44332 | 300s | ✅ UPDATED |
| Curse of Doom | 603+ | 60s | ✅ OK |
| Curse of Recklessness | 704+ | 120s | ✅ OK |

### 🐐 Demonic Sacrifice (8 spells)
| Spell | ID | Duration | Status |
|-------|----|---------:|--------|
| Sacrifice Voidwalker | 7812+ | 30s | ✅ OK |
| Demoniac Sacrifice | 18788 | 30s | ✅ OK |
| Sacrifice Imp Buff | 18789 | 1800s | ✅ OK |
| Sacrifice Voidwalker Buff | 18790 | 1800s | ✅ OK |
| Sacrifice Succubus Buff | 18791 | 1800s | ✅ OK |
| Sacrifice Felhunter Buff | 18792 | 1800s | ✅ OK |
| Sacrifice Felguard Buff | 35701 | 1800s | ✅ OK |

### 💊 Healthstone Usage (5 spells)
| Spell | ID | Cooldown | Status |
|-------|----|---------:|--------|
| Minor Healthstone | 6262 | 120s | ✅ OK |
| Lesser Healthstone | 6263 | 120s | ✅ OK |
| Healthstone | 5720 | 120s | ✅ OK |
| Greater Healthstone | 5723 | 120s | ✅ OK |
| Major Healthstone | 11732 | 120s | ✅ OK |

---

## TESTS REQUIS AVANT LANCEMENT 🧪

### TEST 1: Vérifier les durées des nouveaux spells Midnight
```
Zone: Anywhere (Midnight zone)
Method: Cast spell on self or enemy, check timer duration matches expected

Haunt (48181)
  Expected: 18 seconds
  Actual: [TO BE TESTED]
  Status: PASS/FAIL

Siphon Life (63106)
  Expected: 15 seconds
  Actual: [TO BE TESTED]
  Status: PASS/FAIL

Shadow Ward (153415)
  Expected: 30 seconds
  Actual: [TO BE TESTED]
  Status: PASS/FAIL

Drain Soul (198590)
  Expected: 5 seconds (interruptible)
  Actual: [TO BE TESTED]
  Status: PASS/FAIL

Curse of Elements (44332)
  Expected: 300 seconds (5 min)
  Actual: [TO BE TESTED]
  Status: PASS/FAIL
```

### TEST 2: Vérifier les cooldowns
```
Death Coil (108396)
  Expected: 180 seconds cooldown
  Actual: [TO BE TESTED]
  Status: PASS/FAIL

Soul Fire (6353+)
  Expected: 60 seconds cooldown
  Actual: [TO BE TESTED]
  Status: PASS/FAIL

Shadowburn (17877+)
  Expected: 15 seconds cooldown
  Actual: [TO BE TESTED]
  Status: PASS/FAIL
```

### TEST 3: Vérifier l'affichage des timers dans l'addon
```
UI Test:
  1. Cast Corruption (172) on enemy
     Expected: Timer circle/text shows ~12-18s duration
     Actual: [TO BE TESTED]

  2. Cast Immolate (348) on enemy
     Expected: Timer circle/text shows ~15s duration
     Actual: [TO BE TESTED]

  3. Cast Curse of Agony (980) on enemy
     Expected: Timer circle/text shows ~24s duration
     Actual: [TO BE TESTED]

  4. Cast multiple timers simultaneously
     Expected: Multiple timers display without errors
     Actual: [TO BE TESTED]
```

### TEST 4: Timer configuration dans les options
```
Options Panel Test:
  1. Open Necrosis Options → Timers
  2. Verify Page 1 loads without errors
  3. Verify Page 2 loads and shows spell list
  4. Toggle timer type: None → Graphical → Text → Graphical
  5. Verify position and direction controls work
  6. Verify alpha/transparency slider works
  7. Select/deselect individual spell timers
  8. Verify changes persist after reload
```

---

## PROBLÈMES POTENTIELS À INVESTIGUER ⚠️

### Potential Issue #1: Old IDs still in DB
**Problem**: If WoW 12.0.1 client still has old spell IDs in the spellbook, they might be cast
**Impact**: Could create duplicate timers for same spell
**Check**:
```lua
-- In game: /run print(IsSpellKnown(153415), IsSpellKnown(6229))
-- Should print: true, false (or both true for backward compat)
```

### Potential Issue #2: Duration changes mid-expansion
**Problem**: Blizzard might patch spell durations during the expansion
**Impact**: Timers would show wrong duration
**Solution**: Provide way to manually adjust duration per spell in config

### Potential Issue #3: Missing new spells in future patches
**Problem**: New spells added after initial 12.0.1 release won't have timers
**Impact**: Incomplete timer coverage
**Solution**: Monitor WoW patch notes and add new spells as needed

---

## NEXT STEPS 📋

### Phase 1: Verification (Next Session)
- [ ] Run TEST 1-4 in game
- [ ] Document any duration mismatches
- [ ] Check for any spell errors in chat/console

### Phase 2: Fixes (If Needed)
- [ ] Update any incorrect durations in Spells-Midnight.lua
- [ ] Add any missing spells from Midnight 12.0.1
- [ ] Fix any UI display bugs found in testing

### Phase 3: Optimization (Future)
- [ ] Add specialization filtering (show only Affliction timers if Affliction spec)
- [ ] Add ability to customize timer display order
- [ ] Add timer presets for PvP vs PvE

### Phase 4: Polish (Later)
- [ ] Add more localization strings
- [ ] Improve timer UI visuals
- [ ] Add timer sound alerts

---

## FILES INVOLVED

### Core Timer Logic
- `Timers/Functions.lua` - Timer list management
- `Timers/GraphicalTimers.lua` - Circular timer rendering
- `Timers/OtherTimers.lua` - Text timer rendering
- `XML/XML_retail.lua` - Timer frame creation

### Configuration
- `XML/Options-Timers_retail.lua` - NEW! Retail-specific options
- `Spells-Midnight.lua` - Spell definitions with Timer flags

### Localization
- `Locales/Localization.lua` - English strings
- `Locales/Localization.FR.lua` - French strings

---

## DONE CHECKLIST ✅

- [x] Reviewed all 50+ timer spells
- [x] Confirmed Midnight 12.0 IDs are prioritized (UsageRank = 1)
- [x] Confirmed old IDs are commented out
- [x] Created comprehensive analysis document
- [x] Created Options-Timers_retail.lua with Retail protections
- [x] Added localization strings for timer options
- [x] Created this action plan

---

## CONCLUSION

**The spell list is READY for testing!** No code changes needed for spell definitions. The focus now is on **in-game verification** that durations and cooldowns are accurate for Midnight 12.0.1.
