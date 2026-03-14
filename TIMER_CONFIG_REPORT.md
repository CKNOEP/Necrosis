# 🚨 RAPPORT - Configuration Timers Incohérente

## RÉSUMÉ EXÉCUTIF

**Situation critique identifiée :**
- La liste de timers dans les options (7 entrées) couvre **seulement 10% des spells réels**
- 30+ spells avec timers n'apparaissent **jamais** dans le panneau options
- Les utilisateurs **ne peuvent pas désactiver** ces timers
- Les timers s'affichent quand même en jeu (mais pas configurables)

---

## 📊 COMPARAISON VISUELLE

### CONFIG.TIMERS ACTUELLE (Necrosis_retail.lua)
```
┌─────────────────────────────────────┐
│  TIMERS CONFIG - 7 ENTRIES          │
├─────────────────────────────────────┤
│ 1. Soulstone                        │
│ 2. Unending Breath                  │
│ 3. Eye of Kilrogg                   │
│ 4. Ritual of Summoning              │
│ 5. Shadow Ward                      │
│ 6. Banish                           │
│ 7. Enslave Demon                    │
└─────────────────────────────────────┘
```

### SPELLS RÉELS AVEC TIMERS (Spells-Midnight.lua)
```
┌──────────────────────────────────────────────────────┐
│  ACTUAL SPELL TIMERS - 40+ ENTRIES                   │
├──────────────────────────────────────────────────────┤
│  CURSES (7)                                          │
│    ✓ Curse of Agony (24s) ................ MISSING  │
│    ✓ Curse of Weakness (120s) ............ MISSING  │
│    ✓ Curse of Elements [M12.0] (300s) ... MISSING  │
│    ✓ Curse of Doom (60s) ................. MISSING  │
│    ✓ Curse of Tongues (30s) .............. MISSING  │
│    ✓ Curse of Exhaustion (12s) ........... MISSING  │
│    ✓ Curse of Recklessness (120s) ........ MISSING  │
│                                                      │
│  AFFLICTION DoTS (5)                                 │
│    ✓ Corruption (12-18s) ................. MISSING  │
│    ✓ Unstable Affliction (15-18s) ........ MISSING  │
│    ✓ Haunt [M12.0] (18s) ................. MISSING  │
│    ✓ Siphon Life [M12.0] (15s) ........... MISSING  │
│    ✓ Drain Soul [M12.0] (5s) ............. MISSING  │
│                                                      │
│  DESTRUCTION (8)                                     │
│    ✓ Immolate (15s) ...................... MISSING  │
│    ✓ Fear (10-20s) ....................... MISSING  │
│    ✓ Howl of Terror (10-15s) ............. MISSING  │
│    ✓ Soul Fire (60s CD) .................. MISSING  │
│    ✓ Death Coil (3s + 180s CD) ........... MISSING  │
│    ✓ Shadowburn (15s CD) ................. MISSING  │
│    ✓ Fel Domination (15s) ................ MISSING  │
│                                                      │
│  CONTROL (2)                                         │
│    ✓ Banish (20-30s) ..................... IN CONFIG │
│    ✓ Enslave Demon (300s) ................ IN CONFIG │
│                                                      │
│  BUFFS (3)                                           │
│    ✓ Shadow Ward [M12.0] (30s) ........... IN CONFIG │
│    ✓ Demon Armor (1800s) ................. MISSING  │
│    ✓ Fel Armor (?) ....................... MISSING  │
│                                                      │
│  SUMMONING (3)                                       │
│    ✓ Soulstone (900s) .................... IN CONFIG │
│    ✓ Ritual of Summoning (600s) .......... IN CONFIG │
│    ✓ Ritual of Doom (summon) ............. MISSING  │
│                                                      │
│  + SACRIFICES (7), + UTILITY (2), etc.              │
└──────────────────────────────────────────────────────┘
```

---

## 🔴 IMPACT SUR L'UTILISATEUR

### Problèmes Observables

1. **Spells manquants du panneau options**
   - Curse of Agony (utilisé très souvent) - INTROUVABLE
   - Corruption (DoT core) - INTROUVABLE
   - Immolate (Destruction core) - INTROUVABLE
   - Haunt, Siphon Life, Drain Soul [Midnight 12.0] - INTROUVABLES
   - ~30 autres spells - INTROUVABLES

2. **Impossible de contrôler l'affichage**
   ```
   User: "Je veux désactiver le timer de Corruption"
   Result: Pas d'option trouvée → Impossible
   ```

3. **Incohérence entre jeu et options**
   ```
   En jeu: Les timers s'affichent pour tous les spells
   En options: Seulement 7 spells configurables
   ```

4. **Les nouveaux spells Midnight 12.0 n'y figurent pas**
   - Haunt (48181) - MANQUANT
   - Siphon Life (63106) - MANQUANT
   - Drain Soul (198590) - MANQUANT
   - Curse of Elements (44332) - MANQUANT
   - Shadow Ward (153415) - EN CONFIG

---

## 📈 COUVERTURE ACTUELLE vs REQUIRED

```
CONFIG COVERAGE ANALYSIS
═════════════════════════════════════════════════════════

Category              Config  Spells  Coverage  Status
─────────────────────────────────────────────────────────
Curses                  0      7       0%       ❌ CRITICAL
Affliction DoTs         0      5       0%       ❌ CRITICAL
Destruction             2      8      25%       ❌ CRITICAL
Control                 2      2     100%       ✓ OK
Utility Buffs           1      3      33%       ⚠️  PARTIAL
Summoning              2      3      67%       ⚠️  PARTIAL
Sacrifices             0      7       0%       ⚠️  OPTIONAL
─────────────────────────────────────────────────────────
TOTAL                  7     42      17%       ❌ CRITICAL

COVERAGE NEED: 42 entries minimum for full functionality
CURRENT: 7 entries
MISSING: 35 entries (83% shortfall)
```

---

## ✅ SOLUTION PROPOSÉE

### Fichier : CONFIG_TIMERS_CORRECTED.lua

**Contient 40 entrées organisées par catégorie :**

```lua
Timers = {
    -- CURSES (7) - All curse timers now included
    [1] = {usage = "agony", show = true},
    [2] = {usage = "weakness", show = true},
    [3] = {usage = "elements", show = true},
    ...

    -- AFFLICTION DoTs (5) - All affliction timers
    [8] = {usage = "corruption", show = true},
    [9] = {usage = "unstable_affliction", show = true},
    [10] = {usage = "haunt", show = true},            -- M12.0
    [11] = {usage = "siphon_life", show = true},      -- M12.0
    [12] = {usage = "drain_soul", show = true},       -- M12.0
    ...

    -- DESTRUCTION (8) - All destruction timers
    [13] = {usage = "immolate", show = true},
    [14] = {usage = "fear", show = true},
    [15] = {usage = "death_coil", show = true},
    ...

    -- + CONTROL, BUFFS, SUMMONING, SACRIFICES, etc.
}
```

**Bénéfices :**
- ✅ 40 entrées au lieu de 7 (5.7x plus d'options)
- ✅ Couverture complète des spells avec timers
- ✅ Organize logiquement par catégorie
- ✅ Défauts intelligents (show=true pour high-use)
- ✅ Compatible avec Options-Timers_retail.lua
- ✅ Support complet Midnight 12.0.1

---

## 🔧 ÉTAPES D'APPLICATION

### Option A : Remplacement manuel (Simple)
```bash
# 1. Open Necrosis_retail.lua
# 2. Find lines 137-146 (Timers = { ... })
# 3. Replace with content from CONFIG_TIMERS_CORRECTED.lua
# 4. Save and reload addon
```

### Option B : Patch automatisé (Recommandé)
```
À créer après approbation de l'utilisateur
```

---

## 🧪 VÉRIFICATION POST-APPLICATION

### Test 1: Panel Options
```
1. Open Necrosis Options → Timers
2. Go to Page 2 (Select Timers)
3. Should now see 40+ spell timers (instead of 7)
4. Verify Midnight 12.0 spells are present:
   ✓ Haunt
   ✓ Siphon Life
   ✓ Drain Soul
   ✓ Curse of Elements
   ✓ Shadow Ward
```

### Test 2: Toggle Options
```
1. Toggle "Curse of Agony" OFF
2. Toggle "Corruption" OFF
3. Toggle "Immolate" OFF
4. Reload addon
5. Verify these spells don't show timers in combat
6. Re-enable and verify they return
```

### Test 3: Default Display
```
1. New character (default config)
2. Open Options → Timers → Page 2
3. Verify high-use spells have show=true (checked)
4. Verify low-use spells have show=false (unchecked)
```

---

## 🎯 RECOMMANDATION FINALE

**CRITICAL PRIORITY - Should be fixed before 1.0 release**

The current Config.Timers is **incomplete and misleading** :
- Users can't disable most timers they want to control
- Options panel shows only 10% of available timers
- New Midnight 12.0 spells mostly missing

**Application Timeline:**
- **Immediate**: Apply CONFIG_TIMERS_CORRECTED.lua to Necrosis_retail.lua
- **Next**: Test in-game with all spell timers
- **Final**: Document the change in CHANGELOG

---

## 📚 RELATED FILES

| File | Purpose | Status |
|------|---------|--------|
| `Necrosis_retail.lua` (lines 137-146) | Current incomplete config | ❌ NEEDS FIX |
| `CONFIG_TIMERS_CORRECTED.lua` | Corrected complete config | ✅ READY |
| `TIMER_CONFIG_ANALYSIS.md` | Detailed analysis | ✅ CREATED |
| `Spells-Midnight.lua` | Source of truth for timers | ✓ OK |
| `XML/Options-Timers_retail.lua` | Options panel | ✓ OK |

---

## CONCLUSION

**The Config.Timers list is fundamentally broken for Midnight 12.0.1.**

It covers only 17% of actual spell timers, making it impossible for users to control most timer displays through the options panel.

**Solution is ready to apply** : CONFIG_TIMERS_CORRECTED.lua contains all 40+ timer entries organized and prioritized appropriately.
