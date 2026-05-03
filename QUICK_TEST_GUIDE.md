# Necrosis Midnight PTR - Guide de Test Rapide

## ✅ Avant de lancer WoW

1. **Addon corrigé**: TOC order now correct (Necrosis-midnight.lua before Panel.lua)
2. **Compat.lua**: API shimps en place
3. **Prêt à tester**

---

## 🎮 Étapes de Test en Jeu

### Phase 1 : Vérifier le chargement (5 min)

1. **Lancez WoW PTR Midnight** (`_xptr_`)
2. **Loggez avec un Démoniste**
3. **Vérifiez les erreurs Lua** :
   ```
   /console scriptErrors 1
   ```
   - ✅ Aucune erreur rouge au login
   - ✅ La sphère Necrosis apparaît
   - ✅ Aucun message d'erreur dans le chat

### Phase 2 : Interaction basique (5 min)

4. **Testez la sphère** :
   - **Clic gauche** → Doit afficher quelque chose ou ne rien faire (normal)
   - **Clic droit** → Doit ouvrir le panneau de configuration
   - **Survol** → Doit afficher un tooltip avec infos

5. **Vérifiez le panneau de config** :
   - S'ouvre sans erreur ?
   - Les onglets visibles ?
   - Se ferme sans erreur ?

### Phase 3 : Sorts (5 min)

6. **Lancez un sort** :
   - Corruption ou Drain Soul
   - Clic normal doit caster le sort sans erreur Lua
   - Timer doit s'afficher (si configuré)

7. **Vérifiez les messages Lua** :
   ```
   /console scriptErrors 1
   ```
   - Aucune nouvelle erreur ?

---

## 🐛 Si vous voyez des erreurs

**Notez exactement** :
- Message d'erreur complet
- Numéro de ligne du fichier
- Ce que vous faisiez quand ça s'est produit

**Exemples** :
```
Error: attempt to call method 'OpenConfigPanel' (a nil value)
Error: UnitAura: not a valid function
Error: GetSpellInfo returns nil
```

---

## ✨ Succès = Addon charge sans erreurs Lua

**Raportez dans ce format** :
```
[✅ SUCCÈS] ou [❌ ERREUR]

Observations:
- Sphère visible: OUI/NON
- Clic droit ouvre config: OUI/NON
- Erreurs Lua: (listez-les)
- Sorts castent: OUI/NON/NON TESTÉ
```

---

## 📝 Si tout fonctionne

Passez aux tests avancés dans `MIDNIGHT_TESTING_GUIDE.md`

