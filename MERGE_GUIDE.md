# Guide de merge - Retail 12.0 (Midnight)

## 🎯 Objectif

Ajouter le support de Retail 12.0 (Midnight) à Necrosis **sans casser** la version TBC.

## ⚠️ Risques identifiés

### 🔴 CRITIQUE - À éviter absolument

| Problème | Impact | Prévention |
|----------|--------|-----------|
| **Mélanger TBC et Retail dans un seul fichier** | Erreurs Lua, addon crash | Fichiers séparés par version |
| **Modifier les IDs de sorts génériquement** | Mauvais sorts lancés | `Spells-TBC.lua` vs `Spells-Midnight.lua` |
| **Appeler des APIs supprimées** | `attempt to call nil` | Utiliser des shims dans `Compat.lua` |
| **Charger le mauvais TOC** | Addon cassé | TOC séparés avec conditions |

### 🟡 IMPORTANT - À surveiller

- Changes dans NecrosisUI (Framework, Style, Themes)
- Modifications des fichiers BLP (images)
- Changements d'APIs principales

## 📋 Checklist de préparation

### Phase 1 : Avant de merger (TBC)

- [ ] Créer une branche `prepare-midnight` depuis `main`
- [ ] Restructurer le code TBC dans dossier `TBC/`
  - [ ] Déplacer `NecrosisUI/` vers `TBC/NecrosisUI/`
  - [ ] Copier `Spells-TBC.lua` vers `TBC/Spells.lua`
  - [ ] Copier `Initialize.lua` vers `TBC/Initialize.lua`
  - [ ] Créer `TBC/Necrosis-TBC.toc`
- [ ] Tester que TBC fonctionne toujours
- [ ] Merger `prepare-midnight` dans `main`

### Phase 2 : Créer la version Midnight

- [ ] Créer dossier `Midnight/`
- [ ] **Copier** depuis TBC et adapter :
  - [ ] `Midnight/NecrosisUI/Framework.lua` (changer les APIs)
  - [ ] `Midnight/NecrosisUI/Framework.xml` (copie identique)
  - [ ] `Midnight/NecrosisUI/Themes/Modern/Style.lua` (adapter le thème)
  - [ ] `Midnight/Spells.lua` (mettre à jour les IDs)
  - [ ] `Midnight/Initialize.lua` (adapter les APIs)
- [ ] Créer `Midnight/Compat.lua` avec shims :
  ```lua
  -- GetSpellInfo shimmed
  -- GetItemInfo shimmed
  -- UnitAura shimmed
  -- etc.
  ```
- [ ] Créer `Midnight/Necrosis-Midnight.toc`

### Phase 3 : Testing sur Retail PTR

- [ ] Installer Necrosis-Midnight.toc sur PTR
- [ ] Vérifier aucune erreur Lua au login
- [ ] Tester fonctionnalités principales
- [ ] Vérifier que NecrosisUI s'affiche
- [ ] Tester les sorts principaux
- [ ] Tester la gestion des shards

### Phase 4 : Validation TBC après merge

- [ ] Vérifier que Necrosis-TBC.toc fonctionne encore
- [ ] Tester les modifications violet (NecrosisUI)
- [ ] Vérifier pas de régression

## 🔧 Processus technique de merge

### Étape 1 : Création de la structure

```bash
# Depuis la racine Necrosis/
git checkout -b feature/midnight-support

# Créer les dossiers
mkdir -p TBC/NecrosisUI/Themes/Classic
mkdir -p Midnight/NecrosisUI/Themes/Modern

# Copier les fichiers TBC (version actuelle)
cp -r NecrosisUI/* TBC/NecrosisUI/
cp Spells-TBC.lua TBC/Spells.lua
cp Initialize.lua TBC/Initialize.lua
cp Necrosis-TBC.toc TBC/Necrosis-TBC.toc

# Préparer la version Midnight (copie de TBC à adapter)
cp -r TBC/NecrosisUI Midnight/
cp TBC/Spells.lua Midnight/Spells.lua
cp TBC/Initialize.lua Midnight/Initialize.lua
```

### Étape 2 : Adapter Midnight pour Retail

Dans `Midnight/Compat.lua` :
```lua
-- Shims pour Retail 12.0
local function GetSpellInfo(spellID)
    -- Shimmed version
end
```

Dans `Midnight/NecrosisUI/Framework.lua` :
```lua
-- Utiliser C_Spell, C_Item, C_UnitAuras au lieu des versions natives
```

### Étape 3 : TOC files

**Necrosis-TBC.toc** - Inchangé, charge depuis dossier racine (rétro-compatibilité)

**Necrosis-Midnight.toc** (nouveau) :
```
## Interface: 120001
## Title: Necrosis 8 Midnight
...
Midnight/NecrosisUI/Framework.xml
Midnight/Compat.lua
Midnight/NecrosisUI/Framework.lua
Midnight/Spells.lua
Midnight/Initialize.lua
...
```

### Étape 4 : Commit et merge

```bash
# Commit préparation
git add .
git commit -m "feat: Restructure for multi-version support - TBC in dedicated folder

- Move TBC code to TBC/ folder structure
- Prepare for Midnight support
- Both versions use separate TOC files

Necrosis-TBC.toc still works, Necrosis-Midnight.toc ready for Midnight PTR

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>"

# Commit Midnight
git commit -m "feat: Add Retail 12.0 (Midnight) support

Create Necrosis-Midnight.toc with:
- Midnight/NecrosisUI/ (adapted Framework, Themes)
- Midnight/Compat.lua (API shims)
- Midnight/Spells.lua (Retail IDs)
- Midnight/Initialize.lua (Retail adaptations)

TBC version remains fully functional.

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>"

# Merger dans main
git checkout main
git merge feature/midnight-support
```

## ✅ Validation post-merge

### Sur TBC
```
[] Necrosis-TBC.toc charge sans erreur
[] NecrosisUI affiche le cadre violet
[] Menu principal fonctionne
[] Sorts s'affichent correctement
[] Aucune erreur Lua
```

### Sur Retail PTR
```
[] Necrosis-Midnight.toc charge sans erreur
[] Compat.lua charges les shims
[] NecrosisUI s'affiche
[] Menu principal fonctionne
[] Sorts affichent (même si IDs changés)
[] Aucune erreur Lua
```

## 🔗 Fichiers clés à surveiller

| Fichier | TBC | Midnight | Action |
|---------|-----|----------|--------|
| `Framework.lua` | ✅ | Adapter | Utiliser shims |
| `Initialize.lua` | ✅ | Adapter | Vérifier APIs |
| `Spells.lua` | ✅ | ❌ | Mettre à jour IDs |
| `NecrosisUI/Themes/*/Style.lua` | ✅ | Adapter | Nouveau thème |
| `*.blp` textures | ✅ | ❓ | Même ou différentes |

## 📞 Support en cas de problème

### Si erreur "attempt to call nil"
→ Vérifier que l'API existe sur cette version
→ Créer un shim dans `Compat.lua`

### Si sorts ne s'affichent pas
→ Vérifier les IDs dans `Spells.lua`
→ Utiliser Wowhead ou in-game pour obtenir les bons IDs

### Si NecrosisUI n'affiche rien
→ Vérifier que Framework.lua charge
→ Vérifier que Style.lua référence les bons fichiers
→ Chercher les erreurs Lua dans le chat

## 🎯 Objectif final

✅ Deux versions de Necrosis dans un seul repo
✅ TBC fonctionne parfaitement
✅ Midnight fonctionne sans casser TBC
✅ Code facilement maintenable
✅ Facile d'ajouter d'autres versions à l'avenir

## 📌 À vérifier avant release

- [ ] Pas de fichiers TBC chargés par Midnight
- [ ] Pas de fichiers Midnight chargés par TBC
- [ ] TOC séparation fonctionne
- [ ] Pas de régression TBC
- [ ] Retail fonctionne sur PTR
- [ ] Tous les tests passent
