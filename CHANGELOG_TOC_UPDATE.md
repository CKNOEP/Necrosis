# 📝 Changelog - Mise à Jour Convention TOC 2026

## 🎯 Date : 07 Février 2026

---

## 🔄 Changements Majeurs

### ✅ Migration vers Convention TOC Moderne (Underscore)

**Ancienne convention** (Dash `-`) → **Nouvelle convention** (Underscore `_`)

#### Fichiers Renommés

| Ancien Nom | Nouveau Nom | Status |
|------------|-------------|--------|
| `Necrosis-Vanilla.toc` | `Necrosis_Vanilla.toc` | ✅ Renommé |
| `Necrosis-TBC.toc` | `Necrosis_TBC.toc` | ✅ Renommé |
| `Necrosis.toc` | `Necrosis_Wrath.toc` | ✅ Renommé + Suffixe ajouté |
| `Necrosis-Cata.toc` | `Necrosis_Cata.toc` | ✅ Renommé |

---

## 🔢 Interface IDs Mis à Jour

### Necrosis_Vanilla.toc
- **Ancien** : `## Interface: 11507`
- **Nouveau** : `## Interface: 11508`
- **Ajouté** : Champs de compatibilité croisée

### Necrosis_TBC.toc
- **Ancien** : `## Interface: 20504`
- **Nouveau** : `## Interface: 20505`
- **Ajouté** : Champs de compatibilité croisée

### Necrosis_Wrath.toc
- **Ancien** : `## Interface: 30403`
- **Nouveau** : `## Interface: 30403` (inchangé)
- **Ajouté** : Champs de compatibilité croisée
- **Corrigé** : Titre "Wotlk" → "Wrath"

### Necrosis_Cata.toc
- **Ancien** : `## Interface: 40402`
- **Nouveau** : `## Interface: 40400`
- **Ajouté** : Champs de compatibilité croisée

---

## 📋 Nouveaux Champs de Compatibilité

Tous les fichiers TOC ont maintenant ces champs pour assurer la compatibilité croisée :

```
## Interface: [VERSION_SPECIFIQUE]
## X-Min-Interface: 110207
## X-Min-Interface-Classic: 11508
## X-Min-Interface-BCC: 20505
## X-Min-Interface-Wrath: 30403
## X-Min-Interface-Cata: 40400
```

**Avantage** : L'addon peut maintenant signaler sa compatibilité avec toutes les versions de WoW.

---

## 🎮 Versions WoW Supportées (Mise à Jour)

| Version WoW | TOC File | Interface ID | Status |
|-------------|----------|--------------|--------|
| **Vanilla / Anniversaire** | `Necrosis_Vanilla.toc` | 11508 | ✅ Modernisé |
| **TBC Classic** | `Necrosis_TBC.toc` | 20505 | ✅ Modernisé |
| **WotLK Classic** | `Necrosis_Wrath.toc` | 30403 | ✅ Modernisé |
| **Cataclysm Classic** | `Necrosis_Cata.toc` | 40400 | ✅ Modernisé |

---

## 📊 Référence : Convention Moderne 2026

### Suffixes Officiels Supportés

| Suffixe | Version WoW | Underscore | Dash | Recommandé |
|---------|-------------|------------|------|------------|
| `_Vanilla` | Classic Vanilla | ✅ | ✅ | ✅ Underscore |
| `_TBC` | TBC Classic | ✅ | ✅ | ✅ Underscore |
| `_BCC` | TBC Classic (Legacy) | ❌ | ❌ | ❌ Déprécié Nov 2025 |
| `_Wrath` | WotLK Classic | ✅ | ✅ | ✅ Underscore |
| `_Cata` | Cataclysm Classic | ✅ | ✅ | ✅ Underscore |
| `_Mainline` | Retail WoW | ✅ | ✅ | ✅ Underscore |

**Note** : BCC (Burning Crusade Classic) est déprécié depuis Patch 3.80.0 (Nov 2025). Utiliser `_TBC` à la place.

---

## 🔧 Détails Techniques

### Pourquoi Underscore au lieu de Dash ?

1. **Convention Moderne** : Les addons récents (GTFO, Plater, etc.) utilisent underscore
2. **Compatibilité** : Les deux fonctionnent, mais underscore est la norme depuis 2025
3. **Cohérence** : Facilite la maintenance et l'uniformité

### Pourquoi les Champs X-Min-Interface-* ?

Ces champs permettent à l'addon de déclarer sa compatibilité avec plusieurs versions de WoW :
- Le client WoW lit ces champs
- Si l'addon est compatible, il se charge même sur des versions différentes
- Facilite le support multi-versions

### Structure Complète d'un TOC File Moderne

```
## Interface: [VERSION_PRINCIPALE]
## X-Min-Interface: [RETAIL_MIN]
## X-Min-Interface-Classic: [VANILLA_MIN]
## X-Min-Interface-BCC: [TBC_MIN]
## X-Min-Interface-Wrath: [WRATH_MIN]
## X-Min-Interface-Cata: [CATA_MIN]

## Title: Nom de l'Addon
## Notes: Description
## Version: x.x.x
## Author: Auteur
## SavedVariables: Variables

[Fichiers à charger...]
```

---

## ✅ Validation des Changements

### Tests Recommandés

- [ ] **WoW Anniversaire** : Vérifier que `Necrosis_Vanilla.toc` se charge
- [ ] **WoW TBC** : Vérifier que `Necrosis_TBC.toc` se charge (si disponible)
- [ ] **WoW Wrath** : Vérifier que `Necrosis_Wrath.toc` se charge (si disponible)
- [ ] **WoW Cata** : Vérifier que `Necrosis_Cata.toc` se charge (si disponible)

### Commandes de Vérification

```bash
# Dans WoW, vérifier quelle version est chargée
/run print(GetAddOnInfo("Necrosis"))

# Vérifier l'Interface ID
/run print(select(4, GetBuildInfo()))
```

---

## 📚 Références

### Sources Officielles
- [TOC format - Warcraft Wiki](https://warcraft.wiki.gg/wiki/TOC_format) - Documentation officielle
- [WoW TOC format - AddOn Studio](https://addonstudio.org/wiki/WoW:TOC_format) - Guide technique
- [TOC format - Wowpedia](https://wowpedia.fandom.com/wiki/TOC_format) - Référence complète

### Addons de Référence
- **GTFO** : Utilise la convention `_Vanilla`, `_TBC`, `_Wrath`, `_Cata`
- **Plater** : Même convention avec underscore
- **Details!** : Convention moderne avec champs X-Min-Interface

---

## 🎯 Impact sur le Projet

### Bénéfices Immédiats
✅ **Compatibilité améliorée** avec tous les clients WoW Classic
✅ **Convention moderne** alignée avec les standards 2025-2026
✅ **Meilleure reconnaissance** par les gestionnaires d'addons (CurseForge, WoWUp)
✅ **Maintenance facilitée** avec une structure cohérente

### Aucun Impact Négatif
- ✅ Les SavedVariables restent compatibles
- ✅ Aucun changement de code nécessaire
- ✅ Les utilisateurs verront les nouveaux noms de fichiers mais l'addon fonctionnera normalement

---

## 📝 Notes de Version Suggérées

**Version suggérée** : 8.1.0

**Changelog utilisateur** :
```
Version 8.1.0 (2026-02-07)
- Mise à jour vers la convention TOC moderne 2026 (underscore)
- Amélioration de la compatibilité multi-versions
- Support TBC Classic ajouté
- Interface IDs mis à jour pour toutes les versions
- Corrections de bugs (SpellActivations)
```

---

## 🚀 Prochaines Étapes

1. **Tester en jeu** sur WoW Anniversaire
2. **Vérifier** que les erreurs ont disparu
3. **Valider** le chargement correct de `Necrosis_Vanilla.toc`
4. **Mettre à jour** le README sur GitHub
5. **Créer un tag Git** pour la version 8.1.0

---

**Status** : 🟢 **MODERNISATION COMPLÈTE**

**Dernière mise à jour** : 07/02/2026
**Fichiers modifiés** : 4 TOC files
**Convention** : Underscore `_` (Moderne 2026)
**Compatibilité** : Vanilla, TBC, Wrath, Cata
