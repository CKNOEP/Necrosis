# Options Timers - Layout 3 Pages (2 Colonnes)

## ✅ CHANGEMENT APPLIQUÉ

La page de configuration des timers a été restructurée pour supporter **40+ spells** avec un layout efficace sur **3 pages**.

---

## 📋 STRUCTURE AVANT vs APRÈS

### AVANT (1 page avec 2 colonnes limitées)
```
PAGE 1: Settings
PAGE 2: Timers (max ~14 items en 2 colonnes x 7 lignes)
        → Insuffisant pour 40+ timers

❌ Problème: Espace insuffisant, pas de scrolling
```

### APRÈS (3 pages avec layout cohérent)
```
PAGE 1: Settings (Timer type, position, transparency)
PAGE 2: Timers 1-20 (2 colonnes x 10 lignes)
PAGE 3: Timers 21-40+ (2 colonnes x 10 lignes)

✅ Solution: Chaque page affiche 20 timers max
            2 colonnes de 10 items
            Navigation facile entre pages
```

---

## 🎨 LAYOUT DÉTAILLÉ

### PAGE 1 - Timer Settings
```
┌──────────────────────────────────┐
│                1 / 3             │
│  Timer Settings                  │
├──────────────────────────────────┤
│                                  │
│  [▼] Timer Type                  │
│                                  │
│  ☐ Show Timer Button             │
│  ☐ Show Timers on Left           │
│  ☐ Show Timers Upward           │
│                                  │
│  ─────────────────────────────   │
│  Transparency: [====●════]       │
│                  1      100      │
│                                  │
├──────────────────────────────────┤
│  [<<<]              [>>>]        │
└──────────────────────────────────┘
```

### PAGE 2 - Spells 1-20 (2 COLONNES x 10 ROWS)
```
┌──────────────────────────────────┐
│                2 / 3             │
│  Select Spell Timers (1-20)      │
├──────────────────────────────────┤
│                                  │
│  LEFT COLUMN      RIGHT COLUMN   │
│  ────────────────────────────    │
│  ☐ Soulstone      ☐ Immolate    │
│  ☐ Breath         ☐ Fear         │
│  ☐ Eye            ☐ Howl         │
│  ☐ Summoning      ☐ Soul Fire    │
│  ☐ Ward           ☐ Death Coil   │
│  ☐ Banish         ☐ Shadowburn   │
│  ☐ Enslave        ☐ Feldom.      │
│  ☐ Agony          ☐ Conflagr.    │
│  ☐ Weakness       ☐ Sacrif.      │
│  ☐ Elements       ☐ Sacrifice V. │
│                                  │
├──────────────────────────────────┤
│  [<<<]              [>>>]        │
└──────────────────────────────────┘
```

### PAGE 3 - Spells 21-40+ (2 COLONNES x 10 ROWS)
```
┌──────────────────────────────────┐
│                3 / 3             │
│  Select Spell Timers (21-40)     │
├──────────────────────────────────┤
│                                  │
│  LEFT COLUMN      RIGHT COLUMN   │
│  ────────────────────────────    │
│  ☐ Doom           ☐ Ritual Souls │
│  ☐ Tongues        ☐ Armor        │
│  ☐ Exhaustion     ☐ Fel Armor    │
│  ☐ Recklessness   ☐ Invisible    │
│  ☐ Corruption     ☐ Inferno      │
│  ☐ Unst. Aff.     ☐ Ritual Doom  │
│  ☐ Haunt          ☐ Sac. Imp     │
│  ☐ Siphon Life    ☐ Sac. Void    │
│  ☐ Drain Soul     ☐ Sac. Succ.   │
│  ☐ [Unused]       ☐ Sac. FH      │
│                                  │
├──────────────────────────────────┤
│  [<<<]              [>>>]        │
└──────────────────────────────────┘
```

---

## 🔢 DIMENSIONS & SPACING

### Position des colonnes
```
LEFT COLUMN:   X = 40  pixels (depuis BOTTOMLEFT)
RIGHT COLUMN:  X = 190 pixels (depuis BOTTOMLEFT)

STARTER Y:     Y = 395 pixels (depuis BOTTOMLEFT)

ROW HEIGHT:    25 pixels (spacing entre les checkboxes)

MAX ROWS:      10 par page
               = 20 items par page (10 left + 10 right)
```

### Calcul des positions
```
Page 2:
  Item 1-10:  Left column,  Y = 395 - (25 * i)
  Item 11-20: Right column, Y = 395 - (25 * (i-10))

Page 3:
  Item 21-30: Left column,  Y = 395 - (25 * (i-20))
  Item 31-40: Right column, Y = 395 - (25 * (i-30))
```

---

## 🔄 NAVIGATION

### Boutons disponibles sur chaque page

**PAGE 1 (Settings)**
```
[<<<] Go to Page 3 (Previous/Wrap)
[>>>] Go to Page 2 (Next)
```

**PAGE 2 (Timers 1-20)**
```
[<<<] Go to Page 1 (Previous)
[>>>] Go to Page 3 (Next)
```

**PAGE 3 (Timers 21-40)**
```
[<<<] Go to Page 2 (Previous)
[>>>] Go to Page 1 (Next/Wrap)
```

### Indicateur de page
Chaque page affiche son numéro :
```
"1 / 3" → Page 1 of 3
"2 / 3" → Page 2 of 3
"3 / 3" → Page 3 of 3
```

---

## 💾 STOCKAGE & PERSISTANCE

### Configuration sauvegardée
```lua
NecrosisConfig.Timers = {
    [1] = {usage = "soulstone", show = true},
    [2] = {usage = "breath", show = true},
    ...
    [40] = {usage = "sacrifice_demonic_Felguard", show = false},
}
```

### Persistence
- Chaque toggle est sauvegardé dans `NecrosisConfig.Timers[i].show`
- Les changements persistent après reload
- Les états sont restaurés au login

---

## 🔍 SPÉCIFICATIONS TECHNIQUES

### Fichier modifié
`XML/Options-Timers_retail.lua` - Version 3-page

### Fonction principale
`Necrosis:SetTimersConfig()` - Crée toutes les frames

### Frames créées
```
NecrosisTimersConfig        (main container)
  ├─ NecrosisTimersConfig1  (Page 1 - Settings)
  ├─ NecrosisTimersConfig2  (Page 2 - Timers 1-20)
  └─ NecrosisTimersConfig3  (Page 3 - Timers 21-40)

NecrosisTimerShow1-40       (Checkbuttons for timers)
  (40 checkbuttons created dynamically)
```

### Protections Retail
- `pcall()` pour tous les appels potentiellement dangereux
- Nil checks sur tous les frames/functions
- Vérification d'existence avant utilisation

---

## 🧪 TEST CHECKLIST

- [ ] Page 1 s'ouvre sans erreur
- [ ] Navigation Page 1 → Page 2 fonctionne
- [ ] Navigation Page 2 → Page 3 fonctionne
- [ ] Navigation Page 3 → Page 1 fonctionne
- [ ] Tous les 40 timers sont visibles sur Pages 2 & 3
- [ ] Texte des spells s'affiche correctement
- [ ] Toggle on/off fonctionne pour chaque timer
- [ ] État persiste après reload
- [ ] Pas de chevauchement entre colonnes
- [ ] Texte n'est pas coupé

---

## 📊 CAPACITY

| Page | Items | Columns | Rows/Col | Total |
|------|-------|---------|----------|-------|
| 1    | 0*    | 1       | -        | Settings only |
| 2    | 20    | 2       | 10       | Items 1-20 |
| 3    | 20    | 2       | 10       | Items 21-40 |
| Total| 40    | 2       | 10       | Full coverage |

*Page 1 contains settings, not timers

---

## 🎯 AVANTAGES

1. ✅ **Espace optimal** - 40 items sur 2 pages (pas de scrolling)
2. ✅ **2 colonnes** - Utilise mieux l'espace de 350px
3. ✅ **Navigation simple** - Boutons << et >>
4. ✅ **Lisibilité** - 10 items par colonne, pas d'encombrement
5. ✅ **Scalable** - Peut supporter jusqu'à 60+ items (3 pages x 20)
6. ✅ **Cohérent** - Même layout sur chaque page

---

## 🔮 FUTURE EXTENSIBILITY

Si on dépasse 40 timers (ex: 50+), on peut simplement :
1. Ajouter une Page 4 (items 41-60)
2. Modifier les boutons de navigation pour boucler
3. Ajuster le compteur (1/4, 2/4, etc.)

Le code est déjà conçu pour être extensible !

---

## NOTES

- **Ancien fichier sauvegardé** : `XML/Options-Timers_retail_OLD.lua`
- **Nouveau fichier** : `XML/Options-Timers_retail.lua`
- **Pas de changement dans .toc** : Le fichier à charger reste le même
- **Backward compatible** : Les anciennes configs fonctionnent toujours
