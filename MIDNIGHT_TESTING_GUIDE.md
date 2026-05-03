# Necrosis Midnight PTR - Guide de Test

## Configuration initiale

### 1. Charger l'addon sur PTR Midnight

1. Lancez WoW sur le PTR Midnight (serveur _xptr_)
2. Créez ou connectez-vous avec un personnage Démoniste
3. L'addon doit charger automatiquement via `Necrosis_Midnight.toc`

### 2. Vérifier les erreurs Lua

```
/console scriptErrors 1
```

Cela affichera les erreurs Lua en jeu. Notez les erreurs et consultez la console du client pour plus de détails.

## Plan de test

### Phase 1 : Fonctionnalité de base

#### ✓ Addon charge correctement
- [ ] Pas d'erreur au login
- [ ] La sphère Necrosis apparaît
- [ ] Aucun message d'erreur dans `/console scriptErrors 1`

#### ✓ Sphère interactive
- [ ] Clic gauche sur la sphère = pas d'erreur
- [ ] Clic droit sur la sphère = ouvre le panneau de configuration
- [ ] Survol de la sphère = affiche le tooltip

#### ✓ Configuration
- [ ] Panneau d'options s'ouvre et se ferme normalement
- [ ] Les onglets (Sphère, Messages, Timers, etc.) sont accessibles
- [ ] Les options se sauvegardent

### Phase 2 : Sorts et casting

#### ✓ Sorts disponibles
- [ ] Les sorts de Démoniste sont disponibles
- [ ] Les boutons de sorts répondent aux clics
- [ ] Les sorts peuvent être castés sans erreur

**Sorts à tester** :
- Corruption (DoT)
- Drain Soul / Drain Life
- Fear / Howl of Terror
- Curse spells
- Summon spells (si disponible)

#### ✓ Incantation
- [ ] Clic gauche sur un bouton sort = cast le sort
- [ ] Clic droit sur un bouton sort = exécute l'action alternative
- [ ] Les macros (si configurées) fonctionnent

### Phase 3 : Timers et suivi

#### ✓ Timers de sorts
- [ ] Les timers s'affichent pour les DoTs
- [ ] Les timers se décrémentent correctement
- [ ] Les timers disparaissent quand le sort expire
- [ ] Les timers multiples (plusieurs cibles) fonctionnent

#### ✓ Suivi des auras
- [ ] Les buffs/debuffs du joueur s'affichent
- [ ] Les debuffs sur la cible s'affichent
- [ ] Les alertes de buff (si configurées) fonctionnent

### Phase 4 : Fonctionnalités avancées

#### ✓ AFK
- [ ] AFK s'active/désactive avec la touche configurée
- [ ] Les sorts AFK castent correctement
- [ ] AFK se désactive au login suivant (si configuré)

#### ✓ File d'attente de convocation
- [ ] Summon UI s'affiche/se cache correctement
- [ ] Les convocations s'ajoutent à la file
- [ ] Les convocations se lancent dans l'ordre

#### ✓ Gestion des âmes
- [ ] Les cristaux d'âme dans le sac sont visibles
- [ ] Le compteur de cristaux met à jour correctement
- [ ] Le tri automatique fonctionne (si configuré)

### Phase 5 : Compatibilité Compat.lua

#### ✓ Wrappers API
- [ ] Aucune erreur liée aux APIs Midnight
- [ ] Les fonctions legacy retournent des valeurs valides
- [ ] Les performances sont acceptables

## Problèmes connus et solutions

### Erreur : "attempt to call method 'OpenConfigPanel' (a nil value)"
**Solution** : Le fichier Panel.lua doit être chargé avant XML.lua

### Les sorts ne castent pas
**Raison** : Les IDs de sorts de Midnight différent de Cata
**Solution** : Mettre à jour Spells-Midnight.lua avec les vrais IDs

### Timers ne s'affichent pas
**Raison** : UnitAura wrapper ne fonctionne pas complètement
**Solution** : Vérifier la fonction PlayerAura dans SpellActivations/components/util.lua

### Les options ne se sauvegardent pas
**Raison** : Problème avec SavedVariables
**Solution** : Vérifier que SavedVariablesPerCharacter est bien configuré dans le TOC

## Rapports de bugs

Quand vous découvrez un problème:

1. **Notez l'erreur exacte** :
   - Message d'erreur Lua complet
   - Ligne du code ayant échoué
   - Actions pour reproduire

2. **Vérifiez dans MIDNIGHT_PORTING_STATUS.md** :
   - Est-ce un problème connu?
   - Avez-vous un message d'erreur correspondant?

3. **Mettez à jour** :
   - MIDNIGHT_PORTING_STATUS.md avec le statut
   - Spells-Midnight.lua avec les nouveaux IDs si nécessaire

## Rollback d'urgence

Si l'addon cause des problèmes graves:

1. Supprimez ou renommez `Necrosis_Midnight.toc`
2. Chargez à la place `Necrosis_Cata.toc` (si disponible)
3. Contactez les développeurs avec les logs d'erreur

## Ressources utiles

- **Midnight API Documentation** : https://wow.gamepedia.com/API (mettre à jour pour Midnight)
- **C_Spell namespace** : Nouvelle API pour les sorts
- **C_UnitAuras namespace** : Nouvelle API pour les auras
- **C_Container namespace** : Nouvelle API pour les sacs

## Contact et support

Pour signaler des bugs ou contribuer au portage :
- GitHub : https://github.com/CKNOEP/Necrosis
- Issues : https://github.com/CKNOEP/Necrosis/issues
