# 🖱️ Correction FINALE - Clics Non Fonctionnels

## 🐛 Bug #7 : Clics sur la Sphère et Boutons

**Problème Reporté** : Les clics gauche et droit ne fonctionnent ni sur la sphère ni sur le mini bouton

**Cause Racine Identifiée** :
1. Les boutons avaient `RegisterForClicks("AnyUp")` dans XML.lua ✅
2. **MAIS** la fonction `MainButtonAttribute()` qui configure les **attributs de clic** (type1, type2, spell, etc.) n'était **JAMAIS appelée** lors de l'initialisation de l'addon ❌
3. Résultat : le bouton acceptait les clics mais ne savait pas quoi faire avec!

---

## ✅ Correction Appliquée

### Problème Principal : Attributs de Clic Non Initialisés

**Ordre d'initialisation AVANT la correction** :
```
1. Initialize.lua:181 → SpellSetup("Initialize")
   ├─ Scanne les sorts disponibles
2. Initialize.lua:183 → CreateWarlockUI()
   ├─ Crée les boutons avec RegisterForClicks("AnyUp") ✅
3. Initialize.lua:266 → ButtonSetup()
   ├─ Positionne les boutons autour de la sphère
4. ❌ MainButtonAttribute() NON APPELÉ!
   ├─ Les attributs type1, type2, spell ne sont JAMAIS configurés au démarrage
```

**Conséquence** : Les attributs de clic ne sont configurés QUE lorsque l'événement `SPELLS_CHANGED` se déclenche, ce qui peut ne pas arriver au login initial!

---

### Fichiers Modifiés

#### 1. **Initialize.lua** lignes 263-280

**Ajouté** : Appel aux fonctions `*Attribute()` après `ButtonSetup()`

```lua
-- Configure button click attributes || Configuration des attributs de clics des boutons
if not InCombatLockdown() then
    -- Determine if mount spell is available
    local SteedAvailable = false
    if GetSpellInfo(GetSpellInfo(5784)) or GetSpellInfo(GetSpellInfo(23161)) then
        SteedAvailable = true
    end

    -- Configure all button attributes
    Necrosis:MainButtonAttribute()
    Necrosis:BuffSpellAttribute()
    Necrosis:PetSpellAttribute()
    Necrosis:CurseSpellAttribute()
    Necrosis:StoneAttribute(SteedAvailable)
end
```

**Ordre d'initialisation APRÈS la correction** :
```
1. SpellSetup("Initialize") → Scanne les sorts
2. CreateWarlockUI() → Crée les boutons
3. ButtonSetup() → Positionne les boutons
4. ✅ MainButtonAttribute() → Configure les attributs de clic de la sphère
5. ✅ BuffSpellAttribute() → Configure les boutons de buff
6. ✅ PetSpellAttribute() → Configure les boutons de démons
7. ✅ CurseSpellAttribute() → Configure les boutons de malédiction
8. ✅ StoneAttribute() → Configure les boutons de pierres
```

---

#### 2. **XML/XML.lua** lignes 79-89

**Retiré** : Script `OnLoad` inutile qui ne s'exécute jamais

```lua
// AVANT ❌
frame:RegisterForClicks("AnyUp")

-- Create the timer anchor
self:CreateTimerAnchor()
-- Edit the scripts associated with the button
frame:SetScript("OnLoad", function(self)
    self:RegisterForDrag("LeftButton")
    self:RegisterForClicks("RightButtonUp")  // ⚠️ Écrase le "AnyUp" si exécuté
end)
frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)

// APRÈS ✅
frame:RegisterForClicks("AnyUp")

-- Create the timer anchor
self:CreateTimerAnchor()
-- Edit the scripts associated with the button
frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
```

**Note** : Le script `OnLoad` n'est jamais appelé car le bouton est créé via `CreateFrame()` en Lua, pas via XML. Il était donc inutile et potentiellement problématique.

---

## 🖱️ Fonctionnalités des Clics Activées

### Sur la Sphère (NecrosisButton)

| Clic | Action |
|------|--------|
| **Clic Gauche** | Lance le sort principal configuré |
| **Shift + Clic Gauche** | Lance le sort secondaire configuré |
| **Clic Droit** | Supprime les Soul Shards excédentaires |
| **Ctrl + Clic** | Ouvre le menu de configuration |

### Configuration des Sorts

Les sorts lancés par clic gauche sont configurables dans :
- **Options → Sphère → Sort principal**
- **Options → Sphère → Sort secondaire (Shift)**

---

## 🧪 Tests Recommandés

### Test 1 : Reload et Clic Gauche
1. **Faire `/reload`** pour recharger l'addon avec les nouveaux changements
2. Ouvrir `/necrosis`
3. Aller dans **Sphère**
4. Sélectionner un sort principal (ex: Shadow Bolt)
5. Fermer les options
6. **Cliquer gauche** sur la sphère
7. ✅ Le sort devrait être lancé **dès le premier clic**

### Test 2 : Clic Droit
1. Avoir plusieurs Soul Shards dans les sacs
2. **Cliquer droit** sur la sphère
3. ✅ Les shards excédentaires devraient être supprimées

### Test 3 : Ctrl + Clic
1. **Ctrl + Clic gauche** sur la sphère
2. ✅ Le menu de configuration devrait s'ouvrir

### Test 4 : Shift + Clic
1. Configurer un sort secondaire dans les options
2. **Shift + Clic gauche** sur la sphère
3. ✅ Le sort secondaire devrait être lancé

---

## 🔧 Détails Techniques

### SecureActionButton et Attributs

Le bouton principal est un `SecureActionButtonTemplate`, ce qui nécessite **deux étapes** :

1. **RegisterForClicks("AnyUp")** : Active la réception des clics
   - Fait dans `XML.lua` lors de la création du bouton ✅

2. **SetAttribute("type1", "spell")** + **SetAttribute("spell", "Sort")** : Configure l'action à effectuer
   - Fait dans `MainButtonAttribute()` qui DOIT être appelé pendant l'initialisation ✅
   - Sans cela, le bouton reçoit les clics mais ne fait rien!

### Pourquoi ça ne marchait pas avant ?

**Ordre d'exécution problématique** :
```
PLAYER_ENTERING_WORLD (login)
  └─ Initialize.lua → CreateWarlockUI()
      └─ Bouton créé avec RegisterForClicks ✅
  └─ ❌ MainButtonAttribute() non appelé

SPELLS_CHANGED (apprendre un sort)
  └─ SetupSpells() → MainButtonAttribute() ✅
      └─ Attributs configurés SEULEMENT maintenant!
```

Si le joueur n'apprend pas de nouveau sort après le login, les attributs ne sont JAMAIS configurés!

### Bouton Timer

Le bouton timer (`NecrosisSpellTimerButton`) :
- ✅ Peut être survolé pour afficher le tooltip
- ✅ Peut être déplacé (drag & drop)
- ⚠️ N'a PAS de fonction OnClick → Le clic ne fait rien (comportement normal)
- Le bouton sert d'ancre pour afficher les timers de sorts

---

## 📊 Bugs Corrigés - Session Totale

| # | Bug | Fichier(s) | Status |
|---|-----|-----------|--------|
| 1 | SpellActivations | Necrosis_Wrath.toc | ✅ |
| 2 | GetAddOnMetadata | Initialize.lua | ✅ |
| 3 | Necrosis.Config nil | Dialog.lua | ✅ |
| 4 | LEARNED_SPELL_IN_TAB | Initialize.lua | ✅ |
| 5 | GetSpellName nil | Spells-*.lua (x4) | ✅ |
| 6 | testTimerTicker nil | Options-Misc.lua | ✅ |
| 7 | Clics non fonctionnels | **Initialize.lua + XML.lua** | ✅ |
| 8 | Combat StartMoving | Necrosis*.lua (x2) | ✅ |

**Total** : **8 bugs corrigés** 🎉

---

## 🎮 TESTEZ MAINTENANT !

1. **Relancez WoW** ou faites `/reload` ⚠️ **OBLIGATOIRE**
2. **Les clics devraient fonctionner IMMÉDIATEMENT** sans configuration
3. **Configurez un sort principal si besoin** :
   - `/necrosis` → Sphère → Sélectionner un sort
4. **Testez les clics** :
   - Clic gauche pour lancer le sort
   - Clic droit pour supprimer des shards
   - Ctrl+clic pour ouvrir les options

---

## 🎯 Status

**Les clics devraient maintenant fonctionner parfaitement dès le login !** 🖱️✨

Le problème n'était PAS un manque de `RegisterForClicks()`, mais un manque d'appel à `MainButtonAttribute()` pendant l'initialisation. Les attributs de SecureActionButton doivent être configurés APRÈS la création du bouton pour que les clics fassent quelque chose.

---

**Dernière mise à jour** : 07/02/2026
**Bug #7** : ✅ **VRAIMENT CORRIGÉ CETTE FOIS**
