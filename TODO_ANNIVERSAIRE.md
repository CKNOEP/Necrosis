# 📝 TODO - Migration WoW Anniversaire

## 🔴 Priorité Haute - Tests Initiaux

- [ ] **Test de chargement de l'addon**
  - Lancer WoW Anniversaire avec l'addon activé
  - Vérifier qu'il apparaît dans la liste des addons
  - Noter les erreurs Lua éventuelles
  - Activer les erreurs de script : `/console scriptErrors 1`

- [ ] **Vérification de l'Interface ID**
  - Confirmer l'Interface ID exact de WoW Anniversaire
  - Vérifier si 11507 est correct ou s'il faut ajuster
  - Mettre à jour Necrosis-Vanilla.toc si nécessaire

- [ ] **Test en jeu avec un Démoniste**
  - Créer ou se connecter avec un personnage Warlock
  - Vérifier l'affichage de la sphère Necrosis
  - Tester l'affichage du compteur de Shards
  - Vérifier les boutons d'interface

## 🟠 Priorité Moyenne - Vérification des Fonctionnalités

### Gestion des Sorts
- [ ] Vérifier tous les sorts de Démoniste Vanilla
  - [ ] Shadow Bolt
  - [ ] Corruption
  - [ ] Curse of Agony
  - [ ] Immolate
  - [ ] Searing Pain
  - [ ] Drain Soul
  - [ ] Drain Life
  - [ ] Drain Mana
  - [ ] Fear
  - [ ] Death Coil
  - [ ] Howl of Terror
  - [ ] Conflagrate (Destruction)
  - [ ] Shadowburn (Destruction)

### Gestion des Démons
- [ ] Tester l'invocation des démons
  - [ ] Imp
  - [ ] Voidwalker
  - [ ] Succubus
  - [ ] Felhunter
  - [ ] Felguard (si Démonologie)

### Pierres et Consommables
- [ ] Healthstone (Pierre de soins)
- [ ] Soulstone (Pierre d'âme)
- [ ] Spellstone (Pierre de sort)
- [ ] Firestone (Pierre de feu)

### Timers
- [ ] Timer des DoTs (Damage over Time)
  - [ ] Corruption
  - [ ] Immolate
  - [ ] Curse of Agony
  - [ ] Siphon Life (si Affliction)
- [ ] Timer des buffs
  - [ ] Demon Armor / Fel Armor
  - [ ] Soul Link (si Démonologie)

### Interface Utilisateur
- [ ] Sphère Necrosis (affichage et drag)
- [ ] Boutons de raccourci
- [ ] Menu des options (/necrosis)
- [ ] Tooltips
- [ ] Messages de chat
- [ ] Speech system (annonces automatiques)

## 🟡 Priorité Basse - Optimisations

### Performance
- [ ] Vérifier les performances en raid
- [ ] Optimiser les timers si lag
- [ ] Vérifier la consommation mémoire

### Interface
- [ ] Ajuster les positions par défaut si nécessaire
- [ ] Vérifier la compatibilité avec d'autres addons populaires
  - [ ] Questie
  - [ ] Details!
  - [ ] WeakAuras
  - [ ] DBM

### Localisations
- [ ] Tester la localisation française
- [ ] Vérifier les autres langues si possible

## 🔧 Corrections Identifiées

### ✅ Bugs Corrigés

**Bug #1** : Erreur de chargement SpellActivations ✅ CORRIGÉ
- **Fichier concerné** : Necrosis.toc
- **Ligne** : 63
- **Erreur Lua** : `Error loading Necrosis/SpellActivations/SpellActivations.lua`
- **Cause** : Le fichier SpellActivations.lua n'existe pas
- **Solution appliquée** : Remplacé par SpellActivations.xml (le bon fichier)
- **Date de correction** : 07/02/2026

### Liste des Bugs à Corriger
_(Nouveaux bugs découverts pendant les tests)_

**Format** :
```
[ ] Bug #X : Description
    - Fichier concerné :
    - Ligne :
    - Solution proposée :
```

## 📊 Statut Global

- **Initialisation** : ✅ Complète
- **Support TBC** : ✅ Ajouté (Necrosis-TBC.toc + Spells-TBC.lua)
- **Bug Fix #1** : ✅ Corrigé (SpellActivations)
- **Tests de base** : ⏳ En attente
- **Corrections** : 🔄 En cours (1 bug corrigé)
- **Tests complets** : ⏳ En attente
- **Release** : ⏳ En attente

---

## 📝 Notes de Session

### Session du 07/02/2026
- ✅ Projet initialisé
- ✅ Structure analysée
- ✅ Documentation créée
- ⏳ En attente des tests en jeu

---

## 🎯 Objectif Final

Avoir une version 100% fonctionnelle de Necrosis pour WoW Classic Anniversaire, sans erreurs Lua, avec toutes les fonctionnalités opérationnelles.

**Version cible** : 8.1.0 (Anniversaire)
