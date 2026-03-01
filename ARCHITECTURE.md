# Architecture Necrosis - NecrosisUI Versioning

## 📋 Vue d'ensemble

Ce document décrit l'architecture de Necrosis et comment les différentes versions (TBC, Retail, etc.) sont organisées.

## 🏗️ Structure actuelle (TBC Anniversary)

```
Necrosis/
├── NecrosisUI/
│   ├── Framework.lua              ← Core NecrosisUI (TBC-spécifique)
│   ├── Framework.xml              ← Définitions de frames
│   ├── Themes/
│   │   └── Classic/
│   │       ├── Style.lua          ← Style TBC Classic (violet)
│   │       └── Images/
│   │           ├── base-center.blp
│   │           ├── base-left1.blp
│   │           ├── base-left2.blp
│   │           ├── base-right1.blp
│   │           └── base-right2.blp
│   ├── libs/StdUi/                ← Libraire UI
│   ├── Modules/Artwork/           ← Modules (actuellement vides)
│   └── Skin-Options.lua           ← Options de skin
├── Necrosis-TBC.toc               ← TOC pour TBC Anniversary
├── Spells-TBC.lua                 ← IDs de sorts TBC
├── Initialize.lua                 ← Initialisation core
└── ... (autres fichiers core)
```

## ⚠️ Problèmes identifiés

### 1. **NecrosisUI est complètement TBC-spécifique**
- Framework.lua utilise des APIs TBC
- Style.lua est hardcodé pour le thème Classic
- Les textures sont modifiées en violet pour TBC
- Aucune séparation de code par version

### 2. **IDs de sorts changent par version**
- TBC: `Spells-TBC.lua` avec IDs spécifiques
- Retail 12.0: Aurait besoin de `Spells-Midnight.lua`
- Impossible d'avoir les deux dans la même addon sans conflit

### 3. **APIs WoW différentes par version**
- TBC: Utilise `GetSpellInfo()`, `GetItemInfo()`, `UnitAura()` par index
- Retail 12.0: Utilise `C_Spell.GetSpellInfo()`, `C_Item.GetItemInfo()`, `C_UnitAuras.GetAuraDataByUnit()`
- Le code actuel n'est pas préparé pour abstraire ces différences

## 🎯 Architecture proposée

### Structure recommandée pour multi-version

```
Necrosis/
├── Core/                          ← Code partagé (si applicable)
│   ├── Locales/
│   └── Utils.lua
│
├── TBC/                           ← Branche TBC Anniversary
│   ├── NecrosisUI/
│   │   ├── Framework.lua
│   │   ├── Framework.xml
│   │   └── Themes/
│   │       └── Classic/
│   │           ├── Style.lua
│   │           └── Images/ (violet)
│   ├── Spells.lua
│   ├── Initialize.lua
│   └── ... (code TBC)
│
├── Midnight/                      ← Branche Retail 12.0 (future)
│   ├── NecrosisUI/
│   │   ├── Framework.lua
│   │   ├── Framework.xml
│   │   └── Themes/
│   │       └── Modern/
│   │           ├── Style.lua
│   │           └── Images/
│   ├── Compat.lua                 ← Shims API (C_Spell, C_Item, etc.)
│   ├── Spells.lua
│   ├── Initialize.lua
│   └── ... (code Retail)
│
├── Necrosis-TBC.toc              ← TOC pour TBC
├── Necrosis-Midnight.toc         ← TOC pour Retail 12.0
└── VERSIONING_STRATEGY.md        ← Ce document
```

## 🔄 Stratégie alternative : Chargement conditionnel

Si les versions doivent rester fusionnées dans le même répertoire :

```lua
-- Framework.lua - Au début
local WOW_VERSION = WOW_PROJECT_ID
local IS_TBC = WOW_VERSION == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
local IS_RETAIL = WOW_VERSION == WOW_PROJECT_MAINLINE

-- Charger le bon Style basé sur la version
local STYLE_PATH
if IS_TBC then
    STYLE_PATH = 'Interface\\AddOns\\Necrosis\\NecrosisUI\\Themes\\Classic\\Style.lua'
elseif IS_RETAIL then
    STYLE_PATH = 'Interface\\AddOns\\Necrosis\\NecrosisUI\\Themes\\Modern\\Style.lua'
end
```

## 📊 Comparaison des approches

| Critère | Dossiers séparés | Chargement conditionnel |
|---------|------------------|------------------------|
| **Clarté** | ✅ Très clair | ⚠️ Code complexe |
| **Maintenance** | ✅ Facile | ⚠️ Difficile |
| **Taille addon** | ✅ Plus petite (1 version par install) | ❌ Double taille |
| **Merge** | ✅ Pas de conflit | ⚠️ Nombreux conflits |
| **Branches git** | ✅ Séparées proprement | ❌ Tout dans main |

## ✅ Recommandation finale

**Utiliser des dossiers séparés par version** avec :
- Dossier `TBC/` pour la version actuelle
- Dossier `Midnight/` pour Retail 12.0
- Fichiers de configuration (`Necrosis-TBC.toc` vs `Necrosis-Midnight.toc`)
- Chacun sa branche git ou tags pour releases

## 🔗 Voir aussi

- `VERSIONING_STRATEGY.md` - Détails de gestion des versions
- `MERGE_GUIDE.md` - Checklist pour le merge Retail
