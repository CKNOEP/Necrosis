# 🎮 Necrosis - Migration WoW Classic Anniversaire

## 🎯 Bienvenue dans le Projet de Migration

Ce projet vise à rendre l'addon **Necrosis** entièrement compatible avec **WoW Classic Anniversaire** tout en maintenant la compatibilité avec les versions existantes (Vanilla, WotLK, Cataclysm).

---

## 📁 Documentation du Projet

Le projet a été initialisé avec la documentation suivante :

### 📊 Fichiers de Documentation

1. **PROJECT_INIT.md**
   - Vue d'ensemble complète du projet
   - État actuel des versions supportées
   - Architecture des fichiers
   - Plan d'action détaillé en 5 phases
   - Zones de risque identifiées

2. **TODO_ANNIVERSAIRE.md**
   - Liste de tâches par priorité (Haute/Moyenne/Basse)
   - Tests à effectuer
   - Fonctionnalités à vérifier
   - Section pour documenter les bugs trouvés
   - Tracking du statut global

3. **TECH_REFERENCE.md**
   - Référence technique complète
   - APIs WoW importantes pour Vanilla
   - IDs des sorts de Démoniste
   - Structure des fichiers Necrosis
   - Outils de debug
   - Documentation Ace3
   - Ressources externes

---

## 🚀 Démarrage Rapide

### Étape 1 : Premier Test en Jeu

```bash
1. Lancez WoW Classic Anniversaire
2. Activez les erreurs de script : /console scriptErrors 1
3. Connectez-vous avec un personnage Démoniste
4. Vérifiez que Necrosis se charge (icône dans minimap ou /necrosis)
5. Notez toutes les erreurs Lua dans un fichier texte
```

### Étape 2 : Vérification de Base

- [ ] L'addon apparaît-il dans la liste des addons ?
- [ ] La sphère Necrosis s'affiche-t-elle ?
- [ ] Le compteur de Soul Shards fonctionne-t-il ?
- [ ] Les boutons sont-ils cliquables ?
- [ ] Y a-t-il des erreurs Lua ?

### Étape 3 : Reportez les Problèmes

Ajoutez les bugs trouvés dans la section "Corrections Identifiées" de **TODO_ANNIVERSAIRE.md**

Format :
```
[ ] Bug #1 : Description du problème
    - Fichier concerné : nom_du_fichier.lua
    - Ligne : numéro de ligne
    - Erreur Lua : message d'erreur
    - Solution proposée : votre idée de fix
```

---

## 📋 Workflow de Développement

### Phase Actuelle : **Phase 1 - Diagnostic** ✅

```
Phase 1: Diagnostic ✅ (ACTUELLE)
    ↓
Phase 2: Vérification de Compatibilité
    ↓
Phase 3: Corrections et Ajustements
    ↓
Phase 4: Tests Complets
    ↓
Phase 5: Documentation et Release
```

---

## 🔧 Commandes Utiles

### En Jeu (WoW)
```lua
/necrosis              -- Ouvrir les options
/console scriptErrors 1 -- Activer les erreurs Lua
/reload                -- Recharger l'interface
/run print(GetAddOnInfo("Necrosis"))  -- Info sur l'addon
```

### Git (Versioning)
```bash
# Créer une branche pour les changements
git checkout -b feature/wow-anniversaire

# Voir les modifications
git status
git diff

# Commiter les changements
git add .
git commit -m "fix: correction pour WoW Anniversaire"

# Pousser vers le repository
git push origin feature/wow-anniversaire
```

---

## 📊 Structure du Projet

```
Necrosis/
│
├── 📄 Documentation
│   ├── PROJECT_INIT.md          ← Vue d'ensemble du projet
│   ├── TODO_ANNIVERSAIRE.md     ← Liste des tâches
│   ├── TECH_REFERENCE.md        ← Référence technique
│   └── README_MIGRATION.md      ← Ce fichier
│
├── 📄 TOC Files (Versions)
│   ├── Necrosis-Vanilla.toc     ← Pour Classic/Anniversaire
│   ├── Necrosis.toc             ← Pour WotLK
│   └── Necrosis-Cata.toc        ← Pour Cataclysm
│
├── 🎯 Core Files
│   ├── Necrosis.lua             ← Core principal
│   ├── Initialize.lua           ← Initialisation
│   ├── Utils.lua                ← Utilitaires
│   └── Functions.lua            ← Fonctions principales
│
├── 🔮 Spells
│   ├── Spells-Vanilla.lua       ← Sorts Vanilla/Anniversaire
│   ├── Spells.lua               ← Sorts WotLK
│   └── Spells-Cata.lua          ← Sorts Cataclysm
│
├── 🎨 Interface (XML/)
│   ├── Options-Sphere-Vanilla.lua
│   ├── Options-Buttons-Vanilla.lua
│   └── ... (autres fichiers d'options)
│
├── ⏱️ Timers/
│   ├── Functions.lua
│   ├── GraphicalTimers.lua
│   └── OtherTimers.lua
│
├── 🌍 Locales/
│   └── (8 langues supportées)
│
└── 📚 libs/
    ├── Ace3/
    ├── LibStub/
    ├── LibQTip-1.0/
    └── ... (autres bibliothèques)
```

---

## 🎯 Objectifs du Projet

### Court Terme (1-2 semaines)
- ✅ Initialisation du projet et documentation
- ⏳ Identification de tous les bugs
- ⏳ Correction des problèmes critiques
- ⏳ Tests des fonctionnalités principales

### Moyen Terme (2-4 semaines)
- ⏳ Correction de tous les bugs identifiés
- ⏳ Tests complets de toutes les fonctionnalités
- ⏳ Optimisation des performances
- ⏳ Tests multilingues

### Long Terme (1-2 mois)
- ⏳ Release stable pour WoW Anniversaire
- ⏳ Documentation utilisateur complète
- ⏳ Intégration avec CurseForge/WoWInterface
- ⏳ Support communautaire

---

## ⚠️ Points d'Attention

### APIs à Surveiller
- ✅ `GetSpellInfo()` - Peut avoir changé
- ⚠️ `UnitBuff()` / `UnitDebuff()` - Signature différente possible
- ⚠️ Backdrop system - Vérifier la compatibilité
- ⚠️ Timer system - Pas de C_Timer en Vanilla

### Fonctionnalités Critiques
1. **Compteur de Soul Shards** - Cœur de l'addon
2. **Timers de DoTs** - Essentiel pour le DPS
3. **Invocation de démons** - Boutons d'accès rapide
4. **Healthstone/Soulstone** - Tracking des pierres
5. **Interface Options** - Configuration de l'addon

---

## 🆘 Besoin d'Aide ?

### Ressources
- **GitHub Repository** : https://github.com/CKNOEP/Necrosis
- **WoWpedia Classic API** : https://wowpedia.fandom.com/wiki/Classic_API
- **Ace3 Documentation** : https://www.wowace.com/projects/ace3

### Outils Recommandés
- **BugSack + BugGrabber** : Capture des erreurs Lua en jeu
- **WoWLua** : Éditeur Lua en jeu pour tests rapides
- **Visual Studio Code** : Éditeur de code avec extension Lua

### Debug en Jeu
Installez **BugSack** et **BugGrabber** pour capturer automatiquement toutes les erreurs Lua. C'est beaucoup plus pratique que `/console scriptErrors 1`.

```
/bugsack show  -- Affiche les erreurs capturées
```

---

## 📝 Notes de Version

### Version Actuelle
- **Vanilla** : 8.0.6
- **Interface ID** : 11507
- **TOC** : Necrosis-Vanilla.toc

### Prochaine Version (Objectif)
- **Anniversaire** : 8.1.0
- **Interface ID** : 11505-11507 (à confirmer)
- **Nouvelles fonctionnalités** : TBD après tests

---

## ✅ Checklist du Développeur

### Avant de Coder
- [x] Lire PROJECT_INIT.md
- [x] Lire TECH_REFERENCE.md
- [ ] Tester l'addon en jeu
- [ ] Noter les erreurs Lua
- [ ] Identifier les fichiers à modifier

### Pendant le Développement
- [ ] Travailler sur une branche Git séparée
- [ ] Tester chaque modification en jeu
- [ ] Documenter les changements importants
- [ ] Mettre à jour TODO_ANNIVERSAIRE.md

### Avant de Release
- [ ] Tous les bugs critiques corrigés
- [ ] Tests complets effectués
- [ ] Documentation mise à jour
- [ ] Changelog créé
- [ ] Version bump dans TOC files

---

## 🎮 Contributeurs

- **Original Author** : Lomig, lädygaga
- **Maintenance** : CKNOEP (GitHub)
- **Migration Anniversaire** : [Votre nom]

---

## 📜 Licence

GPL v2 (voir _GPL_V2.txt)

---

## 🚀 C'est Parti !

Le projet est maintenant **initialisé et prêt** pour la phase de tests.

**Prochaine étape** : Lancez WoW Anniversaire et testez l'addon ! 🎯

---

**Status du Projet** : 🟢 **READY FOR TESTING**

**Dernière mise à jour** : 07 Février 2026
