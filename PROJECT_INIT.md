# 🎮 Projet Necrosis - Migration WoW Anniversaire

## 📋 Informations Générales

**Nom du Projet** : Necrosis
**Type** : Addon World of Warcraft pour Démonistes
**Objectif** : Migration et compatibilité avec WoW Classic Anniversaire
**Date d'initialisation** : 07 Février 2026
**Repository** : https://github.com/CKNOEP/Necrosis

---

## 🎯 Objectif du Projet

Rendre l'addon Necrosis entièrement compatible avec la nouvelle version **WoW Classic Anniversaire** tout en maintenant la compatibilité avec les versions existantes.

---

## 📊 État Actuel

### Versions Supportées Actuellement

| Version WoW | Interface ID | TOC File | Version Addon | Statut |
|-------------|--------------|----------|---------------|--------|
| **Vanilla Classic** | 11507 | Necrosis-Vanilla.toc | 8.0.6 | ✅ Actif |
| **Wrath (WotLK)** | 30403 | Necrosis.toc | 8.0.4 | ✅ Actif |
| **Cataclysm** | 40402 | Necrosis-Cata.toc | 8.0.6 | ✅ Actif |
| **Anniversaire** | 11505-11507 | À configurer | TBD | 🔄 En cours |

### Structure des Fichiers Principaux

```
Necrosis/
├── Core Files
│   ├── Necrosis.lua (WotLK)
│   ├── Necrosis-cata.lua (Cata)
│   ├── Initialize.lua
│   ├── Utils.lua
│   └── Functions.lua
│
├── TOC Files
│   ├── Necrosis.toc (WotLK)
│   ├── Necrosis-Vanilla.toc
│   └── Necrosis-Cata.toc
│
├── Spells Management
│   ├── Spells.lua (WotLK)
│   ├── Spells-Vanilla.lua
│   └── Spells-Cata.lua
│
├── Dialog System
│   ├── Dialog.lua (WotLK/Vanilla)
│   └── Dialog-Cata.lua
│
├── XML Options
│   ├── Options-Sphere-Vanilla.lua
│   ├── Options-Buttons-Vanilla.lua
│   ├── Options-Sphere-Cata.lua
│   └── Options-Buttons-Cata.lua
│
├── Timers/
│   ├── Functions.lua
│   ├── GraphicalTimers.lua
│   └── OtherTimers.lua
│
├── SpellActivations/
│   └── (Système d'activation de sorts)
│
├── Locales/
│   └── (8 langues supportées)
│
└── libs/
    ├── Ace3
    ├── LibStub
    ├── LibQTip-1.0
    ├── LibSharedMedia-3.0
    └── LibUIDropDownMenu
```

---

## 🔍 Analyse Technique

### Fichiers Spécifiques par Version

| Fichier | Vanilla | WotLK | Cata |
|---------|---------|-------|------|
| **Spells** | Spells-Vanilla.lua | Spells.lua | Spells-Cata.lua |
| **Dialog** | Dialog.lua | Dialog.lua | Dialog-Cata.lua |
| **Main** | Necrosis.lua | Necrosis.lua | Necrosis-cata.lua |
| **Attributes** | Attributes.lua | Attributes.lua | Attributes-cata.lua |
| **Options-Sphere** | Options-Sphere-Vanilla.lua | Options-Sphere.lua | Options-Sphere-Cata.lua |
| **Options-Buttons** | Options-Buttons-Vanilla.lua | Options-Buttons.lua | Options-Buttons-Cata.lua |

### Bibliothèques Utilisées

- ✅ **Ace3** : Framework principal
- ✅ **LibStub** : Gestion des bibliothèques
- ✅ **LibQTip-1.0** : Tooltips avancés
- ✅ **LibSharedMedia-3.0** : Ressources partagées
- ✅ **LibDataBroker-1.1** : Intégration DataBroker
- ✅ **LibUIDropDownMenu** : Menus déroulants
- ✅ **CallbackHandler** : Gestion des callbacks
- ✅ **LibButtonGlow** : Effets visuels de boutons

---

## 🎯 Plan d'Action pour WoW Anniversaire

### Phase 1 : Diagnostic ✅
- [x] Explorer la structure du projet
- [x] Identifier les fichiers TOC existants
- [x] Analyser l'architecture des fichiers
- [ ] Tester le chargement actuel dans WoW Anniversaire
- [ ] Identifier les erreurs Lua éventuelles

### Phase 2 : Vérification de Compatibilité
- [ ] Vérifier l'Interface ID pour WoW Anniversaire (actuellement 11507)
- [ ] Tester tous les sorts de Démoniste Vanilla
- [ ] Vérifier les APIs WoW utilisées
- [ ] Identifier les APIs dépréciées ou modifiées
- [ ] Tester le système de timers
- [ ] Vérifier SpellActivations

### Phase 3 : Corrections et Ajustements
- [ ] Corriger les problèmes d'API
- [ ] Ajuster les IDs de sorts si nécessaire
- [ ] Mettre à jour les textures/icônes
- [ ] Tester les dialogues et Speech
- [ ] Vérifier les options UI

### Phase 4 : Tests
- [ ] Test complet en jeu
- [ ] Test de toutes les fonctionnalités principales
- [ ] Test multilingue
- [ ] Test des périphériques (boutons, sphère, timers)
- [ ] Tests de performance

### Phase 5 : Documentation et Release
- [ ] Mettre à jour le changelog
- [ ] Documenter les changements spécifiques à Anniversaire
- [ ] Préparer les notes de version
- [ ] Créer un tag Git pour la release

---

## 🔧 Zones de Risque Potentielles

### APIs à Vérifier
- ✅ `GetSpellInfo()` - API changée dans certaines versions
- ⚠️ `UnitBuff()` / `UnitDebuff()` - Signature modifiée
- ⚠️ Interface Options - Possibles changements dans le système d'options
- ⚠️ Backdrop system - Modifié dans certaines versions

### Fonctionnalités Critiques
1. **Gestion des Shards** - Cœur de l'addon
2. **Timers de DoTs** - Essentiel pour le gameplay
3. **Boutons d'invocation** - Gestion des démons
4. **Pierre de soins/mana** - Tracking des consommables
5. **Speech system** - Messages automatiques

---

## 📝 Notes de Développement

### Conventions de Code
- Fichiers séparés par version WoW
- Utilisation de LibStub pour les bibliothèques
- SavedVariablesPerCharacter : `NecrosisConfig`
- Localisation via Ace3

### Commits Récents
```
adb2534 - fix fel armor
a77f69f - Update Necrosis-Vanilla.toc
7b74aad - Update Necrosis-Cata.toc
4f0d60e - toc
7d69b94 - Update Options-Misc.lua
```

---

## 📚 Ressources

- **Repository Git** : https://github.com/CKNOEP/Necrosis
- **WoW Classic Anniversaire Info** : Version 1.15.5-1.15.7
- **Documentation Ace3** : https://www.wowace.com/projects/ace3
- **WoW API Documentation** : https://wowpedia.fandom.com/

---

## 🚀 Prochaines Étapes Immédiates

1. **Tester l'addon** dans WoW Anniversaire pour identifier les erreurs
2. **Vérifier les logs Lua** (`/console scriptErrors 1`)
3. **Comparer les IDs de sorts** Vanilla vs Anniversaire
4. **Examiner les fichiers de configuration** pour détecter des incompatibilités
5. **Créer une branche Git** dédiée à la version Anniversaire si nécessaire

---

## ✅ Projet Initialisé

Le projet est maintenant prêt pour la phase de diagnostic et de tests. La structure est claire, les fichiers sont identifiés, et le plan d'action est établi.

**Status** : 🟢 READY FOR TESTING
