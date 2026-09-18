# Analyse - Incohérence Config Timers vs Spells Timers

## 🚨 PROBLÈME IDENTIFIÉ

**La liste Config.Timers (7 entries) est COMPLÈTEMENT INCOHÉRENTE avec les spells réels (70+ entries)**

### Stats
- **Config.Timers (Necrosis_retail.lua)** : 7 entrées
- **Spells avec Timer=true (Spells-Midnight.lua)** : 70+ usages uniques
- **Écart** : ~90% des timers manquent de la configuration !

---

## 📋 CONFIG.TIMERS ACTUELLE (Necrosis_retail.lua)

```lua
Timers = {
    [1] = {usage = "soulstone", show = true},
    [2] = {usage = "breath", show = true},
    [3] = {usage = "eye", show = false},
    [4] = {usage = "summoning", show = true},
    [5] = {usage = "ward", show = true},
    [6] = {usage = "banish", show = true},
    [7] = {usage = "enslave", show = true},
}
```

**Commentaire dans le code :** "Order is for options screen; overrides Warlock_Spells Timer"

---

## ✓ SPELLS TIMERS PRÉSENTS DANS CONFIG

1. ✅ `soulstone` - Soulstone (15 min buff)
2. ✅ `breath` - Unending Breath (600s)
3. ✅ `eye` - Eye of Kilrogg (45s)
4. ✅ `summoning` - Ritual of Summoning (600s)
5. ✅ `ward` - Shadow Ward (30s) - **Midnight 12.0 ID: 153415**
6. ✅ `banish` - Banish (20-30s)
7. ✅ `enslave` - Enslave Demon (300s)

---

## ❌ SPELLS TIMERS MANQUANTS DE LA CONFIG

### Curses (7 spells - 🔴 CRITIQUES)
| Usage | Spell | Duration | Priority |
|-------|-------|----------|----------|
| `agony` | Curse of Agony | 24s | 🔴 HIGH |
| `weakness` | Curse of Weakness | 120s | 🔴 HIGH |
| `tongues` | Curse of Tongues | 30s | 🟡 MEDIUM |
| `exhaustion` | Curse of Exhaustion | 12s | 🟡 MEDIUM |
| `elements` | Curse of Elements **[M12.0]** | 300s | 🔴 HIGH |
| `doom` | Curse of Doom | 60s (duration + CD) | 🔴 HIGH |
| `recklessness` | Curse of Recklessness | 120s | 🟡 MEDIUM |

### Affliction DoTs (5 spells - 🔴 CRITIQUES)
| Usage | Spell | Duration | Priority |
|-------|-------|----------|----------|
| `corruption` | Corruption | 12-18s | 🔴 HIGH |
| `unstable_affliction` | Unstable Affliction | 15-18s | 🔴 HIGH |
| `haunt` | Haunt **[M12.0]** | 18s | 🔴 HIGH |
| `siphon_life` | Siphon Life **[M12.0]** | 15s | 🔴 HIGH |
| `drain_soul` | Drain Soul **[M12.0]** | 5s | 🔴 HIGH |

### Destruction Abilities (8 spells - 🔴 CRITIQUES)
| Usage | Spell | Duration | Priority |
|-------|-------|----------|----------|
| `immolate` | Immolate | 15s | 🔴 HIGH |
| `fear` | Fear | 10-20s | 🔴 HIGH |
| `howl` | Howl of Terror | 10-15s | 🟡 MEDIUM |
| `soul_fire` | Soul Fire | Cooldown 60s | 🔴 HIGH |
| `death_coil` | Death Coil | 3s + CD 180s | 🔴 HIGH |
| `shadowburn` | Shadowburn | Cooldown 15s | 🟡 MEDIUM |
| `domination` | Fel Domination | 15s | 🟡 MEDIUM |
| `conflagration` | Conflagration | ??? | 🔍 UNKNOWN |

### Demon Sacrifices (7 spells - 🟡 MEDIUM)
| Usage | Spell | Duration | Priority |
|-------|-------|----------|----------|
| `sacrifice` | Demoniac Sacrifice | 30s | 🟡 MEDIUM |
| `sacrifice_Void` | Sacrifice Voidwalker | 30s | 🟡 MEDIUM |
| `sacrifice_demonic_Imp` | Sacrifice Imp Buff | 1800s | 🟡 MEDIUM |
| `sacrifice_demonic_Voidwalker` | Sacrifice Void Buff | 1800s | 🟡 MEDIUM |
| `sacrifice_demonic_Succubus` | Sacrifice Succ Buff | 1800s | 🟡 MEDIUM |
| `sacrifice_demonic_Felhunter` | Sacrifice FH Buff | 1800s | 🟡 MEDIUM |
| `sacrifice_demonic_Felguard` | Sacrifice FG Buff | 1800s | 🟡 MEDIUM |

### Rituals (2 spells - 🟡 MEDIUM)
| Usage | Spell | Duration | Priority |
|-------|-------|----------|----------|
| `rit_of_doom` | Ritual of Doom | 0s (summon) | 🟡 MEDIUM |
| `Ritual_of_Souls` | Ritual of Souls | 600s | 🟡 MEDIUM |

### Armor (2 spells - 🟡 MEDIUM)
| Usage | Spell | Duration | Priority |
|-------|-------|----------|----------|
| `armor` | Demon Skin/Armor | 1800s | 🟡 MEDIUM |
| `fel_armor` | Fel Armor | Duration? | 🟡 MEDIUM |

### Utility (3 spells - 🟡 MEDIUM)
| Usage | Spell | Duration | Priority |
|-------|-------|----------|----------|
| `invisible` | Detect Invisibility | 600s | 🟡 MEDIUM |
| `inferno` | Inferno | 5s | 🟡 MEDIUM |
| `shadow` | Curse of Shadow | 300s | ⚠️ COMMENTED |

### Stone Usage Results (Peu pertinent pour timers, 8+ spells - 🟢 LOW)
| Usage | Note |
|-------|------|
| `minor_ss_used` | Soulstone usage result - commented |
| `ss_used` | Soulstone usage result |
| `greater_ss_used` | Soulstone usage result |
| `master_ss_used` | Soulstone usage result - commented |
| `demonic_ss_used` | Soulstone usage result - commented |
| `minor_hs_used` | Healthstone usage result |
| `hs_used` | Healthstone usage result |
| `greater_hs_used` | Healthstone usage result |
| `major_hs_used` | Healthstone usage result |

### Non-Timer Spells Incorrectement Marquées (À SUPPRIMER - 🔴 ERREUR)
| Usage | Issue |
|-------|-------|
| `life_tap` | Timer=false mais présent |
| `dark_intent` | Timer=false mais présent |
| `spellstone` | Création seulement, pas timer |
| `firestone` | Création seulement, pas timer |
| `mounts` | Pas de timer associé |
| `bolt` | Inconnu/obsolète |
| `link` | Inconnu/obsolète |
| `soul_swap` | Inconnu/obsolète |
| Summons (imp, voidwalker, etc.) | Ce sont des spells, pas des timers |

---

## 🎯 CLASSEMENT PAR PRIORITÉ D'AJOUT

### 🔴 PRIORITÉ CRITIQUE (Doivent être ajoutés IMMÉDIATEMENT)
```
Curse of Agony          (24s, très utilisé)
Curse of Weakness       (120s, très utilisé)
Corruption              (12-18s, très utilisé)
Curse of Elements [M12.0] (300s, nouveau)
Curse of Doom           (60s, damage spell)
Immolate                (15s, très utilisé)
Fear                    (10-20s, très utilisé)
Haunt [M12.0]           (18s, nouveau)
Siphon Life [M12.0]     (15s, nouveau)
Drain Soul [M12.0]      (5s, nouveau)
Unstable Affliction     (15-18s, utilisé)
Soul Fire               (60s cooldown)
Death Coil              (3s + 180s cooldown)
Shadowburn              (15s cooldown)
```

### 🟡 PRIORITÉ MOYENNE (À ajouter dans un 2e temps)
```
Curse of Tongues        (30s)
Curse of Exhaustion     (12s)
Curse of Recklessness   (120s)
Howl of Terror          (10-15s)
Fel Domination          (15s)
Demonic Sacrifice       (30s + 1800s buffs)
Ritual of Doom          (summon)
Ritual of Souls         (600s)
Demon Skin/Armor        (1800s)
Detect Invisibility     (600s)
Inferno                 (5s)
```

### 🟢 PRIORITÉ BASSE (Optionnel)
```
Stone usage results     (Probablement mieux géré par événements)
Pel Armor              (Duration à confirmer)
```

---

## 🗑️ À SUPPRIMER / NETTOYER

Les usages suivants ne doivent PAS être dans Config.Timers (ne sont pas des timers de debuff/buff) :
```
- life_tap (Timer=false)
- dark_intent (Timer=false)
- spellstone (création, pas timer)
- firestone (création, pas timer)
- mounts (summon, pas timer)
- bolt (inconnu)
- link (inconnu)
- soul_swap (inconnu)
- imp, voidwalker, succubus, etc. (pet summons, pas timers)
```

---

## 📊 RÉSUMÉ DES ACTIONS

| Action | Nombre | Impact |
|--------|--------|--------|
| Ajouter à Config.Timers | **30+** | 🔴 CRITIQUE |
| Nettoyer/supprimer | **10+** | 🟡 IMPORTANT |
| Vérifier priorités | **All** | 🟡 IMPORTANT |

---

## 🔧 SOLUTION REQUISE

### Étape 1 : Reconstruire Config.Timers avec ALL timers réels
Remplacer les 7 entrées par une liste complète et organisée, classée par catégorie/utilisation.

### Étape 2 : Ordre d'affichage logique
- **Curses** (les plus utilisées)
- **DoTs** (Corruption, Haunt, etc.)
- **Control** (Banish, Fear, Enslave)
- **Buffs** (Ward, Armor, Breath)
- **Rituals** (Summoning, RoS)
- **Cooldown-based** (Soul Fire, Shadowburn, etc.)
- **Pet abilities** (Sacrifice)
- **Utility** (Eye, Inferno, etc.)

### Étape 3 : Affichage par défaut cohérent
Chaque spell devrait avoir `show = true` ou `show = false` basé sur :
- Les plus utilisés → `show = true`
- Les moins utilisés / situationnels → `show = false`

### Étape 4 : Supprimer les entrées non-timer
Tous les usages sans `Timer = true` dans Spells-Midnight.lua doivent être supprimés.

---

## 📝 NOTES

**Pourquoi c'est comme ça ?**
- Config.Timers a probablement été créée pour une ancienne version de WoW
- Chaque fois que des spells ont été ajoutés, la liste Config n'a pas été mise à jour
- Le commentaire "Order is for options screen; overrides Warlock_Spells Timer" suggère que c'était intentionnel, mais incomplet

**Impact sur l'addon:**
- Les timers "manquants" de Config.Timers s'affichent quand même en jeu (grâce à "overrides")
- Mais l'**option pour les activer/désactiver n'existe pas**
- Les utilisateurs ne voient pas ces spells dans le panneau des options

---

## FICHIERS À MODIFIER

1. **Necrosis_retail.lua** - Config.Timers (lignes 137-146)
   - Remplacer la liste complètement
   - Ajouter 30+ entrées manquantes
   - Organiser logiquement

2. **Optionnel** : Nettoyer Spells-Midnight.lua
   - Supprimer Timer=true des non-timers
   - Ou ajouter commentaire d'explication
