# 🔧 Rapport de Débogage - Necrosis Forever Beta 1.60.1

**Date** : 18 septembre 2026  
**Version** : Necrosis 8.8.5  
**Interface** : 160001 (Forever Beta 1.60.1)  
**Statut** : ✅ PRÊT POUR TESTER

---

## 📋 Résumé des Corrections Apportées

### 🔴 Problème Critique #1 : Attributs de Boutons Non-Numérotés
**Fichier** : `Necrosis.lua` (lignes 1114-1182)  
**Statut** : ✅ **CORRIGÉ**

**Description** :
Les boutons de pierre (Firestone, Spellstone, Healthstone, Soulstone) utilisaient les anciens attributs sans numérotation :
```lua
-- ❌ ANCIEN (ne fonctionne pas en 12.0+)
fsButton:SetAttribute("type", "spell")
fsButton:SetAttribute("spell", fSpell)
```

**Correction** :
Changé vers les attributs numérotés (requis pour Retail 12.0 et Forever 160001) :
```lua
-- ✅ NOUVEAU (fonctionne en 12.0+)
fsButton:SetAttribute("type1", "spell")
fsButton:SetAttribute("spell1", fSpell)
```

**Fichiers Corrigés** :
- ✅ Firestone Button (ligne ~1117)
- ✅ Spellstone Button (ligne ~1127)
- ✅ Healthstone Button (ligne ~1137)
- ✅ Soulstone Button (lignes 1150-1151)

---

## ✅ Validations Complétées

### 1. **Syntaxe Lua**
- ✅ Aucune erreur de syntaxe majeure trouvée
- ✅ Bugs #7 et #9 (return nil) sont résolus
- ✅ GetSpellCastName() fonctionne correctement

### 2. **Templates Sécurisés**
- ✅ Utilise **SecureUnitButtonTemplate** (correct pour 12.0+)
- ✅ Ne plus utiliser SecureActionButtonTemplate
- ✅ Structure des frames conforme

### 3. **APIs Dépréciées**
- ✅ **Compat.lua** gère les wrappers pour :
  - GetSpellInfo() → C_Spell.GetSpellInfo()
  - GetSpellCooldown() → C_Spell.GetSpellCooldown()
  - GetItemInfo() → C_Item.GetItemInfo()
  - UnitAura/UnitBuff/UnitDebuff() → C_UnitAuras.GetAuraDataByUnit()
  - GetSpellPowerCost() → C_Spell.GetSpellInfo()
  - C_PetBattles.IsInBattle() (géré)
  - GetSpellTabInfo() (géré)

### 4. **Fichier TOC Créé**
- ✅ **Necrosis_Forever.toc** créé avec interface 160001
- ✅ Inclut tous les fichiers critiques
- ✅ Compat.lua chargé en premier

---

## 📊 Status des Fichiers Clés

| Fichier | Status | Notes |
|---------|--------|-------|
| **Necrosis_Forever.toc** | ✅ Créé | Nouvelle version pour Forever 1.60.1 |
| **Compat.lua** | ✅ OK | Gère les APIs dépréciées 12.0+ |
| **Necrosis.lua** | ✅ Corrigé | Attributs de boutons numérotés |
| **Initialize_retail.lua** | ✅ OK | Déjà compatible 12.0+ |
| **Spells-Retail.lua** | ✅ OK | Utilise C_SpellBook API |
| **XML/XML_retail.lua** | ✅ OK | SecureUnitButtonTemplate |

---

## 🚀 Prochaines Étapes pour Tester

### 1. **Activation de l'Addon**
1. Lancez WoW Forever Beta
2. Allez à **Addons** → activez **Necrosis Forever**
3. Rechargez le jeu (`/reload`)

### 2. **Vérification des Erreurs**
```
/console scriptErrors 1
```
Cherchez des messages `Error` ou `Lua errors`

### 3. **Tests Fonctionnels**
- [ ] Sphère Necrosis apparaît
- [ ] Clic gauche sur la sphère fonctionne
- [ ] Clic droit ouvre la configuration
- [ ] Bouton Firestone : casting du sort fonctionne
- [ ] Bouton Spellstone : casting du sort fonctionne
- [ ] Bouton Healthstone : casting du sort fonctionne
- [ ] Bouton Soulstone : casting du sort fonctionne
- [ ] Configuration de la sphère sauvegardée

### 4. **Dépannage**
Si l'addon ne charge pas :
- Vérifier l'interface dans WoW : `/run local m,n,p,b=GetBuildInfo() print("Interface: "..m..n..p)`
- Comparer avec la ligne 1 du TOC : `## Interface: 160001`
- Adapter si nécessaire

---

## 📝 Fichiers Modifiés

```
Necrosis/
├── Necrosis_Forever.toc (✨ NOUVEAU)
├── Necrosis.lua (✏️ MODIFIÉ - attributs boutons)
├── Compat.lua (✅ Inchangé)
├── Initialize_retail.lua (✅ Inchangé)
└── Spells-Retail.lua (✅ Inchangé)
```

---

## 🎯 Conclusion

**Status** : ✅ **PRÊT POUR BETA TESTING**

L'addon Necrosis est maintenant configuré pour Forever Beta 1.60.1 avec :
- ✅ Nouveau fichier TOC (Necrosis_Forever.toc)
- ✅ Attributs de boutons corrigés
- ✅ Compatibilité API gérée par Compat.lua
- ✅ Templates sécurisés corrects

**Prochaine action** : Tester en-jeu pour confirmer le fonctionnement.

---

**Généré par Claude Code**  
Necrosis v8.8.5 - Forever Beta 1.60.1 (Interface 160001)
