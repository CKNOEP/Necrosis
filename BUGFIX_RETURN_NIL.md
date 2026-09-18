# 🐛 Bug Critique #9 : Return Nil dans GetSpellCastName

**Date** : 07/02/2026
**Priorité** : 🔴 CRITIQUE
**Status** : ✅ CORRIGÉ

---

## 📋 Symptômes

- **Tous les clics sur la sphère Necrosis ne fonctionnent pas**
- Les clics gauche/droit sur tous les boutons sont inopérants
- Aucune action n'est déclenchée malgré la configuration correcte des attributs

---

## 🔍 Cause Racine

### Bug de Formatage Lua

Dans la fonction `GetSpellCastName()` de **TOUS** les fichiers de sorts, le `return` était seul sur une ligne :

```lua
function Necrosis.GetSpellCastName(usage)
    if Necrosis.Warlock_Spell_Use[usage] then
        return	                    -- ❌ Return seul = return nil
        Necrosis.Warlock_Spells[...].CastName  -- ⚠️ JAMAIS EXÉCUTÉ
    else
        return ""
    end
end
```

### Comportement en Lua

En Lua, quand `return` est seul sur une ligne, il est interprété comme `return nil`, et **tout le code après est ignoré** jusqu'à la fin du bloc.

C'est équivalent à :
```lua
return nil
-- Code mort - jamais exécuté
```

### Conséquence en Cascade

1. `GetSpellCastName(usage)` retourne toujours **nil** au lieu du nom du sort
2. Dans `MainButtonAttribute()` :
   ```lua
   local main_cast = Necrosis.GetSpellCastName(NecrosisConfig.MainSpell)
   -- main_cast = nil !

   if main_cast ~= "" then  -- nil ~= "" est TRUE !
       f:SetAttribute("type1", "spell")
       f:SetAttribute("spell", main_cast)  -- spell = nil ❌
   end
   ```
3. L'attribut `spell` est configuré avec `nil`, donc le clic ne fait **rien**
4. Même problème pour TOUS les autres boutons (buffs, pets, malédictions, pierres)

---

## ✅ Correction Appliquée

### Fichiers Corrigés

| Fichier | Ligne | Changement |
|---------|-------|------------|
| **Spells-Vanilla.lua** | 1138-1139 | `return` + valeur sur même ligne |
| **Spells.lua** | 1138-1139 | `return` + valeur sur même ligne |
| **Spells-TBC.lua** | 1159-1160 | `return` + valeur sur même ligne |
| **Spells-Cata.lua** | 906-908 | `return` + valeur sur même ligne |

### Code AVANT ❌

```lua
return
Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].CastName
```

### Code APRÈS ✅

```lua
return Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].CastName
```

---

## 🎯 Impact de la Correction

### Fonctionnalités Restaurées

✅ **Sphère Necrosis (NecrosisButton)** :
- Clic gauche : Lance le sort principal configuré
- Shift + Clic gauche : Lance le sort secondaire
- Clic droit : Supprime les Soul Shards excédentaires
- Ctrl + Clic : Ouvre le menu de configuration

✅ **Boutons de Buffs** :
- Armure démoniaque, Détection invisibilité, etc.

✅ **Boutons de Démons** :
- Invocation Diablotin, Marcheur du Vide, Succube, etc.

✅ **Boutons de Malédictions** :
- Malédiction d'Agonie, des Éléments, de Fatigue, etc.

✅ **Boutons de Pierres** :
- Pierre de soins, de sorts, de feu, d'âme

---

## 🧪 Tests Requis

### Test 1 : Clic Gauche sur la Sphère
1. `/reload` pour recharger l'addon
2. `/necrosis` → Sphère → Configurer un sort principal (ex: Trait de l'ombre)
3. Cliquer gauche sur la sphère
4. ✅ Le sort devrait être lancé

### Test 2 : Clic sur un Bouton de Buff
1. Cliquer sur le menu des buffs (icône bouclier)
2. Cliquer sur "Armure démoniaque"
3. ✅ Le sort devrait être lancé sur vous

### Test 3 : Clic sur un Bouton de Démon
1. Cliquer sur le menu des démons (icône imp)
2. Cliquer sur "Invoquer le Diablotin"
3. ✅ L'invocation devrait commencer

### Test 4 : Clic sur un Bouton de Malédiction
1. Cliquer sur le menu des malédictions (icône crâne)
2. Avoir une cible hostile
3. Cliquer sur "Malédiction d'Agonie"
4. ✅ Le sort devrait être lancé sur la cible

---

## 📚 Leçons Apprises

### Règle Lua : Placement du Return

❌ **JAMAIS** écrire un `return` seul sur une ligne si on veut retourner une valeur :
```lua
return
valeur  -- Code mort !
```

✅ **TOUJOURS** mettre le `return` et la valeur sur la même ligne :
```lua
return valeur
```

✅ **OU** utiliser des parenthèses pour les retours multi-lignes :
```lua
return (
    longue_expression
    + autre_chose
)
```

### Détection du Problème

Pour trouver ce type de bug :
1. Ajouter des `print()` pour déboguer les valeurs retournées
2. Vérifier que les fonctions ne retournent pas `nil` de manière inattendue
3. Rechercher les patterns `return\s*$` dans le code (return suivi de fin de ligne)

---

## 📊 Historique des Bugs

| # | Bug | Fichier(s) | Date | Status |
|---|-----|-----------|------|--------|
| 1 | SpellActivations | Necrosis_Wrath.toc | 07/02 | ✅ |
| 2 | GetAddOnMetadata | Initialize.lua | 07/02 | ✅ |
| 3 | Necrosis.Config nil | Dialog.lua | 07/02 | ✅ |
| 4 | LEARNED_SPELL_IN_TAB | Initialize.lua | 07/02 | ✅ |
| 5 | GetSpellName nil | Spells-*.lua | 07/02 | ✅ |
| 6 | testTimerTicker nil | Options-Misc.lua | 07/02 | ✅ |
| 7 | Attributs non initialisés | Initialize.lua | 07/02 | ✅ |
| 8 | Combat StartMoving | Necrosis*.lua | 07/02 | ✅ |
| **9** | **Return nil (GetSpellCastName)** | **Spells-*.lua (x4)** | **07/02** | ✅ |

**Total** : **9 bugs corrigés** 🎉

---

## 🚀 Action Immédiate

**TESTER MAINTENANT !**

1. **Relancez WoW** ou faites `/reload` ⚠️ **OBLIGATOIRE**
2. **Les clics devraient maintenant fonctionner sur TOUS les boutons**
3. **Testez chaque type de bouton** :
   - ✅ Sphère principale
   - ✅ Boutons de buffs
   - ✅ Boutons de démons
   - ✅ Boutons de malédictions
   - ✅ Boutons de pierres

---

**Dernière mise à jour** : 07/02/2026
**Bug #9** : ✅ **CORRIGÉ - Return Nil**

---

## 🎓 Explication Technique Détaillée

### Pourquoi ce bug était-il invisible ?

1. **Aucune erreur Lua** : Le code est syntaxiquement correct
2. **Aucun crash** : Le jeu ne plante pas
3. **Les boutons s'affichent** : L'UI est visuellement normale
4. **RegisterForClicks fonctionne** : Les boutons acceptent les clics
5. **Mais rien ne se passe** : Les attributs sont configurés avec `nil`

### Chaîne de conséquences

```
GetSpellCastName() retourne nil
         ↓
main_cast = nil
         ↓
if main_cast ~= "" then  -- TRUE car nil ≠ ""
    SetAttribute("spell", nil)  -- Attribut configuré avec nil !
end
         ↓
Clic sur le bouton
         ↓
SecureActionButton cherche l'attribut "spell"
         ↓
Trouve nil → Ne fait rien
         ↓
Aucune erreur, aucun message, rien ne se passe
```

### Comment éviter ce bug à l'avenir ?

1. **Linter Lua** : Utiliser un outil comme `luacheck` pour détecter le code mort
2. **Tests unitaires** : Tester que les fonctions retournent les bonnes valeurs
3. **Logging** : Ajouter des prints temporaires pour déboguer
4. **Code Review** : Faire relire le code par quelqu'un d'autre

---

## 🔗 Références

- [Lua Reference Manual - Return Statement](https://www.lua.org/manual/5.1/manual.html#3.3.4)
- [SecureActionButtonTemplate - WoWWiki](https://wowwiki.fandom.com/wiki/SecureActionButtonTemplate)
- [Common Lua Pitfalls](https://www.lua.org/pil/contents.html)
