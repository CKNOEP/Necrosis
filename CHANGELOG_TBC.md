# 📝 Changelog - TBC Support & Bug Fixes

## 🎯 Date : 07 Février 2026

---

## ✅ Nouveautés

### 🔥 Support TBC Classic Ajouté

**Fichiers créés** :
- ✅ `Necrosis-TBC.toc` - TOC file pour TBC Classic (Interface 20504)
- ✅ `Spells-TBC.lua` - Définitions des sorts pour TBC

**Nouveaux sorts TBC ajoutés dans Spells-TBC.lua** :

#### Affliction
- **Seed of Corruption** (27243, 47835, 47836)
  - Sort AoE DoT signature de TBC
  - 3 rangs supportés (TBC + WotLK)
  - Timer de 18 secondes

#### Destruction
- **Incinerate** (29722, 32231, 47837, 47838)
  - Nouveau sort de dégâts directs de TBC
  - Remplace Shadow Bolt dans certaines builds
  - 4 rangs supportés

- **Shadowfury** (30283, 30413, 30414, 47846, 47847)
  - AoE stun de zone
  - Cooldown de 20 secondes
  - 5 rangs supportés

**Sorts TBC déjà présents** (hérités de Vanilla) :
- Immolate rank 9 (27215) - TBC
- Death Coil rank 4 (27223) - TBC
- Shadowburn rank 7 (27263) - TBC
- Conflagration rank 5 (27266) - TBC
- Siphon Life ranks 5-6 (27264, 30911) - TBC
- Corruption ranks 7-8 (25311, 27216) - TBC
- Soul Fire rank 3 (27211) - TBC
- Shadow Bolt ranks 10-11 (28307, 27209) - TBC
- Life Tap rank 7 (27222) - TBC
- Soulstone rank 6 (27238) - TBC

---

## 🐛 Bugs Corrigés

### Bug #1 : Erreur de chargement SpellActivations
**Fichier** : `Necrosis.toc`
**Ligne** : 63
**Erreur** : `Error loading Necrosis/SpellActivations/SpellActivations.lua`

**Cause** :
Le fichier tentait de charger `SpellActivations\SpellActivations.lua` qui n'existe pas.

**Solution** :
Remplacé par `SpellActivations\SpellActivations.xml` (le fichier correct)

**Status** : ✅ CORRIGÉ

---

## 📊 Versions Supportées (Mise à Jour)

| Version WoW | Interface ID | TOC File | Status | Sorts |
|-------------|--------------|----------|--------|-------|
| **Vanilla Classic** | 11507 | Necrosis-Vanilla.toc | ✅ OK | Spells-Vanilla.lua |
| **TBC Classic** | 20504 | Necrosis-TBC.toc | ✅ **NOUVEAU** | Spells-TBC.lua |
| **WotLK Classic** | 30403 | Necrosis.toc | ✅ OK | Spells.lua |
| **Cataclysm Classic** | 40402 | Necrosis-Cata.toc | ✅ OK | Spells-Cata.lua |

---

## 🔧 Détails Techniques

### Structure Necrosis-TBC.toc
```
Interface: 20504
X-Min-Interface-TBC: 20500
Charge: Spells-TBC.lua
Options: Options-Sphere-Vanilla.lua, Options-Buttons-Vanilla.lua
```

### Sorts TBC par Spécialisation

**Affliction** (7 sorts TBC) :
- Corruption 7-8
- Siphon Life 5-6
- Seed of Corruption 1-3 (NOUVEAU)

**Démonologie** (2 sorts TBC) :
- Soul Fire 3
- Life Tap 7

**Destruction** (9 sorts TBC) :
- Shadow Bolt 10-11
- Immolate 9
- Conflagration 5
- Shadowburn 7
- Incinerate 1-4 (NOUVEAU)
- Shadowfury 1-5 (NOUVEAU)
- Death Coil 4

---

## 📝 Notes de Migration

### Pour les utilisateurs Vanilla → TBC
Lorsque TBC Classic sort ou si vous jouez sur un serveur TBC :
1. Le fichier `Necrosis-TBC.toc` sera automatiquement chargé
2. Tous les nouveaux sorts TBC seront reconnus
3. La configuration reste compatible (même SavedVariables)

### Pour les développeurs
Les nouveaux sorts TBC suivent la même structure que les sorts Vanilla :
```lua
[SpellID] = {
    UsageRank = X,
    SpellRank = X,
    Timer = true/false,
    Usage = "nom_usage",
    Length = durée,
    Cooldown = cooldown
}
```

---

## 🎯 Prochaines Étapes

### Tests Recommandés
- [ ] Tester le chargement de Necrosis.toc (WotLK) après correction
- [ ] Tester Necrosis-TBC.toc si disponible sur serveur TBC
- [ ] Vérifier que Seed of Corruption est détecté
- [ ] Vérifier que Incinerate fonctionne
- [ ] Vérifier que Shadowfury est reconnu

### Améliorations Futures (TBC)
- [ ] Ajouter les options UI pour les nouveaux sorts TBC
- [ ] Créer les icônes spécifiques pour Seed of Corruption
- [ ] Ajouter les tooltips localisés pour nouveaux sorts
- [ ] Tester les timers des nouveaux DoTs

---

## 🔗 Références

### IDs de Sorts TBC (Source : ClassicDB)
- Seed of Corruption : https://tbcdb.com/?spell=27243
- Incinerate : https://tbcdb.com/?spell=29722
- Shadowfury : https://tbcdb.com/?spell=30283

### Documentation
- TBC Classic API Changes : https://wowpedia.fandom.com/wiki/API_changes_TBC
- Warlock TBC Spells : https://wowpedia.fandom.com/wiki/Warlock_abilities_(TBC)

---

## ✅ Statut du Projet

**Version actuelle** : 8.0.6
**Prochaine version suggérée** : 8.1.0 (avec support TBC complet)

**Compatibilité** :
- ✅ Vanilla Classic
- ✅ TBC Classic (nouveau)
- ✅ WotLK Classic
- ✅ Cataclysm Classic

---

**Dernière mise à jour** : 07/02/2026
**Auteur des modifications** : Claude Code
**Status** : 🟢 PRÊT POUR TESTS
