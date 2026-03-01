# Stratégie de versioning - Necrosis multi-version

## 📌 Contexte

Necrosis doit supporter plusieurs versions de World of Warcraft :
- ✅ **TBC Anniversary** (BCC) - Actuellement actif
- 🔜 **Retail 12.0 (Midnight)** - À venir
- Potentiellement : Vanilla, Wrath, Cata (dans le futur)

Chaque version a des spécificités qui rendent le partage de code difficile.

## 🔍 Problèmes de compatibilité multi-version

### 1. APIs Lua différentes

| API | TBC | Retail 12.0 |
|-----|-----|-----------|
| `GetSpellInfo(spellID)` | ✅ Fonctionne | ❌ Supprimée → `C_Spell.GetSpellInfo()` |
| `GetItemInfo(itemID)` | ✅ Fonctionne | ❌ Supprimée → `C_Item.GetItemInfo()` |
| `UnitAura(unit, index)` | ✅ Par index | ❌ Par index → `C_UnitAuras.GetAuraDataByUnit()` |
| `GetSpellCooldown()` | ✅ Fonctionne | ❌ Supprimée → `C_Spell.GetSpellCooldown()` |

**Solution** : Créer des **shims d'API** (voir `Compat.lua`)

### 2. IDs de sorts différents

| Sort | TBC Classic | Retail 12.0 |
|------|------------|-----------|
| Demonic Sacrifice | 18788 | Probablement ≠ |
| Soul Stone | 6898 (Rank 1) | Système de ranks supprimé |
| Spellstone | 5522 (Rank 1) | Probablement ≠ |

**Solution** : Fichiers `Spells-[VERSION].lua` séparés

### 3. UI et Thèmes différents

- **TBC** : Thème "Classic" (violet actuellement)
- **Retail** : Thème "Modern" ou différent
- Les fichiers BLP peuvent être différents
- Le layout peut changer

**Solution** : Dossiers `Themes/Classic/` et `Themes/Modern/`

### 4. Fonctionnalités obsolètes/nouvelles

| Fonctionnalité | TBC | Retail 12.0 |
|---|---|---|
| Ranks de sorts | ✅ Existe | ❌ Supprimé |
| Conjuring de pierres | ✅ Important | ⚠️ Changé |
| Démons | ✅ Similaire | ⚠️ Refondu |

## 🗂️ Plan de réorganisation

### Phase 1 : Préparation (ACTUEL)
- ✅ Documenter l'architecture
- ✅ Identifier les dépendances
- ⏳ Créer la structure de dossiers

### Phase 2 : Séparation du code TBC
```
Necrosis/TBC/
├── NecrosisUI/
│   ├── Framework.lua         ← TBC-spécifique
│   └── Themes/Classic/Style.lua
├── Spells.lua               ← IDs TBC
├── Initialize.lua           ← Init TBC
└── Necrosis-TBC.toc        ← TOC TBC
```

### Phase 3 : Création de la version Retail
```
Necrosis/Midnight/
├── NecrosisUI/
│   ├── Framework.lua         ← Retail-spécifique
│   └── Themes/Modern/Style.lua
├── Compat.lua               ← Shims API (C_Spell, C_Item, etc.)
├── Spells.lua               ← IDs Retail
├── Initialize.lua           ← Init Retail
└── Necrosis-Midnight.toc   ← TOC Retail
```

### Phase 4 : Extraction du code partagé (optionnel)
```
Necrosis/Core/
├── Locales/                 ← Traductions partagées
├── Utils.lua                ← Utilitaires génériques
└── Message.lua              ← Messages partagés
```

## 🔧 Implémentation des Shims API

Créer `Midnight/Compat.lua` :

```lua
-- Midnight/Compat.lua - Shims for Retail 12.0 API changes

local function GetSpellInfo(spellID)
    local spellInfo = C_Spell.GetSpellInfo(spellID)
    if spellInfo then
        return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime,
               spellInfo.minRange, spellInfo.maxRange, spellInfo.spellID
    end
end

local function GetItemInfo(itemID)
    local itemInfo = C_Item.GetItemInfo(itemID)
    if itemInfo then
        return itemInfo.itemName, nil, itemInfo.itemQuality, itemInfo.itemLevel,
               nil, nil, nil, nil, itemInfo.itemTexture
    end
end

local function UnitAura(unit, index)
    local auraData = C_UnitAuras.GetAuraDataByUnit(unit)
    if auraData and auraData[index] then
        local aura = auraData[index]
        return aura.name, aura.icon, aura.count, aura.dispelType,
               aura.duration, aura.expirationTime, aura.caster
    end
end

_G.GetSpellInfo = GetSpellInfo
_G.GetItemInfo = GetItemInfo
_G.UnitAura = UnitAura
```

## 📋 Checklist par version

### TBC Anniversary (✅ ACTUEL)
- ✅ NecrosisUI chargé
- ✅ Thème Classic violet
- ✅ Sorts TBC OK
- ✅ APIs natives TBC

### Retail 12.0 (🔜 À faire)
- ⏳ Créer dossier `Midnight/`
- ⏳ Adapter `Framework.lua`
- ⏳ Créer `Compat.lua`
- ⏳ Mettre à jour `Spells.lua`
- ⏳ Adapter `Themes/Modern/`
- ⏳ Créer `Necrosis-Midnight.toc`
- ⏳ Tester sur PTR Midnight

## 🔗 Ressources

- `ARCHITECTURE.md` - Structure des dossiers
- `MERGE_GUIDE.md` - Checklist pour merger sans casser

## 📌 Notes importantes

⚠️ **NE PAS MÉLANGER** TBC et Retail dans le même code sans shims
⚠️ **TOUJOURS** tester sur la bonne version avant de merger
⚠️ **DOCUMENTER** les changements API dans les commentaires de code

## 🚀 Prochaines étapes

1. Approuver cette stratégie
2. Créer la structure de dossiers
3. Commencer le portage Retail 12.0
