# 🎮 Checklist de Test - Necrosis Retail 12.0.1

## Avant de Commencer
- [ ] Assurez-vous d'être sur la PTR Retail 12.0.1
- [ ] Vérifiez que Necrosis_Retail est activé (pas Necrosis_Classic)
- [ ] Fermez et relancez WoW complètement

## Phase 1: Chargement Initial

### À la Connexion
- [ ] Addon se charge sans erreurs (vérifiez `/errors`)
- [ ] Le bouton principal (shard count) s'affiche
- [ ] Message de bienvenue "Necrosis" apparaît
- [ ] Pas d'erreur rouge dans le chat

### En Cas d'Erreur
Si vous voyez une erreur, notez:
- [ ] Le texte exact de l'erreur
- [ ] Le numéro de ligne
- [ ] Le nom du fichier
- [ ] Combien de fois elle apparaît

**Erreurs acceptables**: Avertissements liés aux modifications d'interface (pas critique)

---

## Phase 2: Interface Utilisateur

### Shard Counter
- [ ] Affiche le format "X/5" (max 5 shards, pas 32)
- [ ] Le nombre augmente/diminue correctement
- [ ] Couleur: blanc normal

### Options Menu (Necrosis → Options)
- [ ] Menu s'ouvre correctement
- [ ] Pas d'erreur lors de l'ouverture

### Onglet "Timers"
**PAGE 1 (1/3) - Timer Settings**
- [ ] "Timer Type" dropdown visible
- [ ] Checkboxes pour affichage:
  - [ ] "Show Graphical Timers"
  - [ ] "Show Text Timers"
- [ ] Slider "Timer Transparency"
- [ ] Bouton [>>>] pour aller à la page suivante

**PAGE 2 (2/3) - Timers 1-20**
- [ ] Affiche "PAGE 2 (2/3)"
- [ ] 20 timers visibles (2 colonnes x 10 rows):
  - Colonne gauche: 10 timers
  - Colonne droite: 10 timers
- [ ] Chaque timer a une checkbox
- [ ] Bouton [>>>] pour aller à la page suivante
- [ ] Bouton [<<<] pour retour à page 1

**PAGE 3 (3/3) - Timers 21-40+**
- [ ] Affiche "PAGE 3 (3/3)"
- [ ] 20 timers visibles (2 colonnes x 10 rows)
- [ ] Bouton [>>>] revient à Page 1 (cycle)
- [ ] Bouton [<<<] va à Page 2

### Onglet "Misc Options"
- [ ] **IMPORTANT**: Pas d'option "Manage Soul Shards" visible
- [ ] Pas d'option "Shard Bag" visible
- [ ] Pas d'option "Destroy Shards" visible
- [ ] Options visibles:
  - [ ] AFK Module
  - [ ] Threat Meter
  - [ ] NecrosisUI Enable/Disable
  - [ ] Hidden Buttons
  - [ ] Spell Activation Test

### NecrosisUI (Bottom Banner)
- [ ] Checkbox "Enable NecrosisUI" existe dans Misc Options
- [ ] En cochant: Bottom banner s'affiche
- [ ] En décochant: Bottom banner disparaît

---

## Phase 3: Configuration des Timers

### Test de Toggle
1. Allez à Page 2
2. Trouvez un timer (ex: "Curse of Elements")
3. [ ] Cliquez la checkbox pour ACTIVÉ ✓
4. Cliquez [>>>] → Page 3 → [>>>] → Page 1 → [>>>] → Page 2
5. [ ] Vérifiez que votre modification persiste ✓

### Test de Persistance
1. Faites `/reload`
2. Ouvrez Options → Timers → Page 2
3. [ ] Vérifiez que vos toggles sont toujours dans le même état

### Test de Cycles
- [ ] Cliquez [>>>] plusieurs fois: 1→2→3→1→2→3...
- [ ] Cliquez [<<<] depuis Page 1: 1→3→2→1...
- [ ] Pas d'erreur "attempt to index nil"

---

## Phase 4: Menus (Buffs/Démons/Maldictions)

### Buff Menu Button
- [ ] Button s'affiche correctement
- [ ] Clic gauche: menu s'ouvre
- [ ] Menu affiche les buffs disponibles
- [ ] Pas d'erreur SetOfxy

### Pet Menu Button
- [ ] Button s'affiche correctement
- [ ] Clic gauche: menu s'ouvre
- [ ] Menu affiche les démons disponibles
- [ ] Pas d'erreur SetOfxy

### Curse Menu Button
- [ ] Button s'affiche correctement
- [ ] Clic gauche: menu s'ouvre
- [ ] Menu affiche les maldictions disponibles
- [ ] Pas d'erreur SetOfxy

### Repositionnement
- [ ] Draggez le menu: se repositionne correctement
- [ ] Fermer et rouvrir menu: position sauvegardée
- [ ] Pas d'erreur de type "attempt to index"

---

## Phase 5: Erreurs Attendues (RESOLVED)

Ces erreurs ne doivent **PAS** apparaître:

- [ ] ❌ "C_PetBattles_IsInBattle (a nil value)" - **FIXÉ**
- [ ] ❌ "C_TradeSkillUI_IsRecipeRepeating (a nil value)" - **FIXÉ**
- [ ] ❌ "Local.Menu.Pet[1] (a nil value)" - **FIXÉ**
- [ ] ❌ "NecrosisConfig.BuffMenuPos (a nil value)" - **FIXÉ**
- [ ] ❌ "GetSpellInfo is nil" - **FIXÉ**
- [ ] ❌ "GetSpellCooldown is nil" - **FIXÉ**
- [ ] ❌ "GetItemInfo is nil" - **FIXÉ**

---

## Phase 6: Fonctionnalités Principales

### Main Sphere Button (Shard Button)
- [ ] Clic gauche: Cast main spell (Demon Armor)
- [ ] Shift+Clic gauche: Cast 2e spell
- [ ] Clic droit: Ouvre options
- [ ] Drag: Déplace le bouton

### Tooltip du Main Sphere
- [ ] Souris sur le bouton: tooltip s'affiche
- [ ] Affiche les spells configurés
- [ ] Affiche le nombre de Soulstone/Healthstone/etc

### Timers Graphiques
- [ ] Si activés, timers s'affichent
- [ ] Pas d'erreur d'affichage

---

## Phase 7: Rapport Final

### ✅ Si TOUT fonctionne:
1. Notez: "Tout OK - Aucun problème"
2. Addon prêt pour utilisation normale

### ⚠️ Si ERREURS:
1. Notez chaque erreur avec:
   - [ ] Texte exact
   - [ ] Ligne du fichier
   - [ ] Contexte (quand ça arrive)
   - [ ] Comment reproduire

### 📝 Commandes Utiles
```
/reload                           -- Recharge l'interface
/errors                           -- Affiche la console d'erreurs
/necrosis                         -- Ouvre les options Necrosis
/console scriptErrors 1           -- Active logs avancés (optionnel)
```

---

## 🎯 Résumé - À Remplir Après Test

**Date du test**: _________
**Serveur**: PTR Retail 12.0.1
**Classe**: Warlock

### Résultat Global
- [ ] ✅ TOUT FONCTIONNE
- [ ] ⚠️ Erreurs mineures (listées ci-dessous)
- [ ] ❌ Problèmes majeurs (listés ci-dessous)

### Erreurs Mineures
```
(aucune)
```

### Problèmes Majeurs
```
(aucun)
```

### Commentaires
```
(aucun)
```

---

**Merci de tester et de signaler les problèmes! 🙏**
