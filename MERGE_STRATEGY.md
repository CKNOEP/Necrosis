# Stratégie de Fusion : Retail → Main

## Analyse Actuelle

- **Branche retail** : 164 commits en avant de main
- **Dernier commit retail** : `396e105` (Framework_retail.lua auto-layout import)
- **Base de fusion** : main est à l'ancêtre commun
- **Conflits attendus** : Aucun (retail = main + 164 commits linéaires)

## Fichiers Modifiés sur Retail

### Nouveaux fichiers système (retail-only)
- `Necrosis-Retail.toc` - TOC spécifique à Retail
- `UI/BottomBanner/Framework_retail.lua` - Gestion EditMode + auto-import layout
- `XML/Options-NecrosisUI_retail.lua` - Options UI Retail
- `Timers/Functions_retail.lua` - Timers pour Midnight 12.0
- `Compat.lua` - Wrappers API compatibilité WoW 12.0.1
- `Initialize_retail.lua` - Initialisation Retail
- `Dialog_retail.lua` - Dialogues Retail
- `Spells-Midnight.lua` - Sorts Midnight 12.0

### Fichiers multi-version (partagés mais modifiés)
- `Necrosis.toc` - Supports 120005 (PTR 12.0.5)
- `Locales/*.lua` - Traductions mises à jour (OPTIONS, SETTINGS, QUEUE)
- `XML/Options-SummonQueue.lua` - Refactor UI (2 colonnes)
- `UI/BottomBanner/Global-Framework.lua` - Fix module duplication

## Commits Clés à Considérer

### Tier 1 : Essentiels
1. Framework_retail.lua implementation (auto-layout)
2. Compat.lua (API compatibility WoW 12.0+)
3. Initialize_retail.lua (Retail initialization)
4. Necrosis-Retail.toc (TOC structure)

### Tier 2 : Fonctionnalités
- Sayaad demon support
- Spell system refactor (C_Spell API)
- SecureUnitButtonTemplate migration
- Timer expansion (40+ spells)

### Tier 3 : Bug fixes cumulatifs
- Demon spell detection
- Menu button spell casting
- UI positioning
- Health stone support

## Approche Recommandée

### Option A : Fast-Forward Merge (Recommandé)
```bash
git checkout main
git merge retail --ff-only
# Poussez vers le dépôt distant
git push origin main
```
✅ **Avantages** :
- Historique linéaire préservé
- Tous les commits retail conservés
- Facile à reverter si nécessaire
- Historique intact pour git bisect

⚠️ **Condition** : Pas de commits sur main depuis la création de retail (VÉRIFIÉE ✓)

### Option B : Squash Merge (Alternative)
```bash
git checkout main
git merge retail --squash
git commit -m "merge: Integrate retail branch (164 commits)"
```
✅ **Avantages** :
- Historique main plus propre
- Un seul commit de fusion

❌ **Inconvénients** :
- Perte de l'historique détaillé retail
- Traçabilité réduite pour bisect

## Prérequis au Merge

- [ ] Tester sur WoW Retail 12.0.5
- [ ] Vérifier que NecrosisUI se charge
- [ ] Tester l'auto-import de layout
- [ ] Vérifier compatibilité Cata/WotLK/TBC si nécessaire
- [ ] Code review des fichiers Retail-only

## Post-Merge

1. Tag version (ex: `v8.5.0`)
2. Mettre à jour CHANGELOG
3. Créer release sur GitHub

## Recommandation Finale

**Fast-Forward merge** car :
1. Historique linéaire (sans commits supplémentaires sur main)
2. Préserve tous les commits pour traçabilité
3. Facile à reverter si bug découvert après
4. Meilleur pour le debugging avec `git bisect`
