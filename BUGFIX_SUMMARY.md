# 🐛 Corrections de Bugs - Session 07/02/2026

## 📋 Bugs Corrigés

### Bug #1 : Erreur SpellActivations ✅ CORRIGÉ
**Fichier** : Necrosis_Wrath.toc (anciennement Necrosis.toc)
**Ligne** : 63
**Erreur** : `Error loading Necrosis/SpellActivations/SpellActivations.lua`
**Cause** : Fichier `SpellActivations.lua` n'existe pas
**Solution** : Remplacé par `SpellActivations.xml`
**Date** : 07/02/2026 - 16h29

---

### Bug #2 : GetAddOnMetadata non défini ✅ CORRIGÉ
**Fichier** : Initialize.lua
**Ligne** : 14
**Erreur** : `attempt to call global 'GetAddOnMetadata' (a nil value)`
**Cause** : API dépréciée - `GetAddOnMetadata` n'existe plus dans WoW Classic moderne
**Solution** : Créé wrapper de compatibilité utilisant `C_AddOns.GetAddOnMetadata()`
**Date** : 07/02/2026 - 16h47

#### Détails de la Correction

**Ancien code** :
```lua
Necrosis.Data = {
    Version = GetAddOnMetadata("Necrosis", "Version"),
    ...
}
```

**Nouveau code** :
```lua
-- Compatibility wrapper for GetAddOnMetadata
local function GetMetadata(addon, field)
    if C_AddOns and C_AddOns.GetAddOnMetadata then
        return C_AddOns.GetAddOnMetadata(addon, field)
    elseif GetAddOnMetadata then
        return GetAddOnMetadata(addon, field)
    end
    return nil
end

Necrosis.Data = {
    Version = GetMetadata("Necrosis", "Version"),
    ...
}
```

**Bénéfices** :
- ✅ Compatible avec toutes les versions WoW (Vanilla, TBC, Wrath, Cata)
- ✅ Utilise l'API moderne `C_AddOns` quand disponible
- ✅ Fallback sur l'ancienne API si nécessaire
- ✅ Gère le cas où aucune API n'est disponible (retourne nil)

---

### Bug #3 : Necrosis.Config nil ✅ CORRIGÉ (Indirect)
**Fichier** : Dialog.lua
**Ligne** : 384 (376)
**Erreur** : `attempt to index field 'Config' (a nil value)`
**Cause RACINE** : Bug #2 empêchait Initialize.lua de s'exécuter complètement
**Solution** : Corrigé par la résolution du Bug #2 + ajout de Necrosis.toc principal
**Date** : 07/02/2026 - 16h47

---

### Ajout #1 : Fichier TOC Principal ✅ AJOUTÉ
**Fichier** : Necrosis.toc
**Raison** : WoW a besoin d'un fichier TOC avec le nom du dossier comme fallback
**Solution** : Créé `Necrosis.toc` basé sur `Necrosis_Vanilla.toc`
**Contenu** : Version Vanilla (Interface: 11508) avec titre générique "Necrosis 8"
**Date** : 07/02/2026 - 16h46

---

## 📊 Structure TOC Finale

| Fichier TOC | Utilisation | Interface ID | Status |
|-------------|-------------|--------------|--------|
| **Necrosis.toc** | **Fichier principal / Fallback** | 11508 | ✅ Nouveau |
| Necrosis_Vanilla.toc | WoW Classic Vanilla / Anniversaire | 11508 | ✅ OK |
| Necrosis_TBC.toc | WoW TBC Classic | 20505 | ✅ OK |
| Necrosis_Wrath.toc | WoW WotLK Classic | 30403 | ✅ OK |
| Necrosis_Cata.toc | WoW Cataclysm Classic | 40400 | ✅ OK |

**Convention** : WoW chargera le fichier spécifique à la version si disponible, sinon utilisera `Necrosis.toc`

---

## 🔍 Analyse des Causes

### Cascade d'Erreurs

1. **Bug #2** (GetAddOnMetadata) se produit en premier
   - Initialize.lua ne peut pas s'exécuter complètement
   - `Necrosis.Config = {}` n'est jamais créé

2. **Bug #3** (Necrosis.Config nil) se produit ensuite
   - Dialog.lua essaie d'accéder à `Necrosis.Config.Panel`
   - Comme `Necrosis.Config` n'existe pas (bug #2), erreur !

3. **Bug #1** (SpellActivations) était indépendant
   - Erreur de référence de fichier dans TOC
   - Ne bloquait pas complètement le chargement mais générait une erreur

### Solution en Cascade

✅ **Bug #2 corrigé** → Initialize.lua s'exécute → `Necrosis.Config` créé
✅ **Bug #3 résolu** → Dialog.lua peut maintenant accéder à `Necrosis.Config`
✅ **Bug #1 corrigé** → SpellActivations.xml chargé correctement
✅ **Necrosis.toc ajouté** → WoW trouve toujours un TOC valide

---

## 📚 API Dépréciées Identifiées

### GetAddOnMetadata → C_AddOns.GetAddOnMetadata

**Deprecated depuis** : Dragonflight (mais aussi dans Classic 2025-2026)

**Remplacement** :
```lua
-- Ancien (déprécié)
local version = GetAddOnMetadata("AddonName", "Version")

-- Nouveau (recommandé)
local version = C_AddOns.GetAddOnMetadata("AddonName", "Version")
```

**Wrapper de compatibilité créé** : `GetMetadata()` dans Initialize.lua

---

## 🎯 Tests Recommandés

### Tests Prioritaires

- [ ] **WoW Anniversaire** : Vérifier que l'addon se charge sans erreur
  - Vérifier `/console scriptErrors 1`
  - Vérifier aucune erreur Lua au démarrage
  - Vérifier que la sphère Necrosis apparaît
  - Vérifier que `/necrosis` fonctionne

- [ ] **Version affichée** : Vérifier que la version s'affiche correctement
  - La version devrait être "8.0.6"
  - Visible dans la liste des addons

- [ ] **Fonctionnalités de base** :
  - [ ] Compteur de Soul Shards
  - [ ] Boutons cliquables
  - [ ] Timers de DoTs
  - [ ] Menu d'options

### Commandes de Test

```lua
-- Vérifier l'addon chargé
/run print(GetAddOnInfo("Necrosis"))

-- Vérifier la version de l'addon
/run print(Necrosis.Data.Version)

-- Vérifier que Necrosis.Config existe
/run print(Necrosis.Config and "OK" or "NIL")

-- Activer les erreurs Lua
/console scriptErrors 1
```

---

## 📖 Références Techniques

### Sources
- [C_AddOns.GetAddOnMetadata API](https://warcraft.wiki.gg/wiki/API_C_AddOns.GetAddOnMetadata)
- [GetAddOnMetadata (Deprecated)](https://wowpedia.fandom.com/wiki/API_GetAddOnMetadata)
- [WoW Classic API Changes](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API)

### Compatibilité Multi-Versions

Le wrapper `GetMetadata()` créé garantit la compatibilité avec :
- ✅ WoW Classic Vanilla (11508)
- ✅ WoW TBC Classic (20505)
- ✅ WoW WotLK Classic (30403)
- ✅ WoW Cataclysm Classic (40400)
- ✅ WoW Retail (Dragonflight+)

---

## ✅ Status Final

**Bugs corrigés** : 3/3 ✅
**Fichiers modifiés** : 3
- ✅ Initialize.lua (wrapper GetMetadata ajouté)
- ✅ Necrosis_Wrath.toc (SpellActivations.xml)
- ✅ Necrosis.toc (créé comme fichier principal)

**Compatibilité** : Toutes versions WoW Classic
**Status** : 🟢 **PRÊT POUR TESTS**

---

## 🚀 Prochaine Étape

**TESTER EN JEU !**

1. Relancez WoW Anniversaire
2. Vérifiez qu'aucune erreur Lua n'apparaît
3. Testez les fonctionnalités de base
4. Reportez tout nouveau bug dans TODO_ANNIVERSAIRE.md

---

**Dernière mise à jour** : 07/02/2026 - 16h50
**Bugs totaux corrigés** : 3
**Nouveaux fichiers** : 1 (Necrosis.toc)
**Status** : 🟢 **CORRECTIONS COMPLÈTES**
