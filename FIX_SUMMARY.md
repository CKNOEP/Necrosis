# Necrosis Retail (WOW 12.0.1) - Résumé des Correctifs

## Résumé Général
L'addon Necrosis a été adapté pour WOW 12.0.1 Retail (Midnight) avec des corrections majeures pour la compatibilité API et l'interface utilisateur.

## ✅ Corrections Appliquées

### 1. Couche de Compatibilité API (Compat.lua)
**Statut**: ✅ Complète
- ✅ GetSpellInfo - Retourne le format ancien (name, rank, icon, castTime, minRange, maxRange, spellId)
- ✅ GetSpellCooldown - Wrapper pour C_Spell.GetSpellCooldown
- ✅ GetItemInfo - Wrapper avec conversion tonumber() pour les paramètres
- ✅ IsAddOnLoaded - Wrapper pour C_AddOns.IsAddOnLoaded
- ✅ GetAddOnMetadata - Wrapper pour C_AddOns.GetAddOnMetadata
- ✅ UnitAura, UnitBuff, UnitDebuff - Wrappers utilisant C_UnitAuras.GetAuraDataByUnit
- ✅ GetSpellPowerCost - Retourne les coûts de puissance au format ancien
- ✅ GetSpellSubtext - Retourne nil (les rangs n'existent plus en 12.0.1)
- ✅ Spell Book APIs - Stubs pour GetSpellTabInfo, GetSpellBookItemName
- ✅ C_PetBattles.IsInBattle - Retourne false (pet battles sont désactivés)
- ✅ C_Club APIs - Stubs pour GetStreamInfo, GetClubInfo
- ✅ C_Calendar APIs - Stubs pour GetNumDayEvents, GetDayEvent

### 2. Initialisation des Fonctions API (AFKS.lua)
**Statut**: ✅ Complète
- ✅ C_PetBattles_IsInBattle - Initialisée avec fallback
- ✅ C_DateAndTime_GetCurrentCalendarTime - Initialisée
- ✅ C_Calendar_GetNumDayEvents - Initialisée
- ✅ C_Calendar_GetDayEvent - Initialisée
- ✅ C_Club_GetStreamInfo - Initialisée
- ✅ C_Club_GetClubInfo - Initialisée
- ✅ C_TradeSkillUI_IsRecipeRepeating - Initialisée avec fallback

### 3. Configuration des Shards
**Statut**: ✅ Complète
- ✅ Max de shards réduit de 32 à 5 (Necrosis_Retail.toc: DestroyCount = 5)
- ✅ Tous les boutons de gestion des shards supprimés des options (Options-Misc_retail.lua)
  - Supprimé: NecrosisMoveShard
  - Supprimé: NecrosisShardBag
  - Supprimé: NecrosisDestroyShard
  - Supprimé: NecrosisDestroyCount

### 4. Interface des Timers
**Statut**: ✅ Complète
- ✅ Layout 3-pages pour 40+ timers
  - Page 1: Timer Settings (type, affichage, transparence)
  - Page 2: Timers 1-20 (2 colonnes x 10 rows)
  - Page 3: Timers 21-40+ (2 colonnes x 10 rows)
- ✅ Auto-détection et cleanup de l'ancien layout 2-pages
- ✅ Configuration pour 40+ sorts de tirage/protection

### 5. Vérifications NIL Défensives
**Statut**: ✅ Complète

#### SetOfxy (Necrosis_retail.lua:3130)
- ✅ Vérification de Local.Menu.Buff/Pet/Curse[1]
- ✅ Vérification de NecrosisConfig.BuffMenuPos/PetMenuPos/CurseMenuPos
- ✅ Vérification de NecrosisConfig.BuffMenuDecalage/PetMenuDecalage/CurseMenuDecalage

#### Options Menus (Options-Buttons_retail.lua)
- ✅ Vérification des button frames avant accès
- ✅ Protection des appels SetPoint avec existence checks

### 6. Autres Corrections
**Statut**: ✅ Complète
- ✅ OpenSettingsPanel protégé avec pcall() (format category object)
- ✅ UpdatePower protégé avec existence check
- ✅ GetSpellSubtext concat protégé avec fallback
- ✅ NUI Frame/BottomBanner créés et gérés correctement

## 📋 Points de Test Recommandés

1. **Chargement de l'addon**
   - Vérifier aucune erreur dans /errors
   - Vérifier que le bouton principal s'affiche

2. **Configuration des Timers**
   - Ouvrir Options → Timers
   - Vérifier Page 1 (1/3) s'affiche
   - Cliquer [>>>] → Page 2 (2/3)
   - Cliquer [>>>] → Page 3 (3/3)
   - Cliquer [>>>] → Retour à Page 1
   - Vérifier que le toggle ON/OFF fonctionne
   - Faire `/reload` et vérifier la persistance

3. **Affichage des Shards**
   - Vérifier format "X/5" (max 5 shards)
   - Vérifier pas d'UI de gestion des shards

4. **Options Générales**
   - Vérifier que NecrosisUI checkbox fonctionne
   - Vérifier que BottomBanner s'affiche quand activé
   - Vérifier les autres options ne causent pas d'erreurs

5. **Menu des Buffs/Démons/Maldictions**
   - Vérifier l'affichage correct
   - Vérifier pas d'erreurs SetOfxy
   - Vérifier le repositionnement fonctionne

## 🐛 Erreurs Corrigées

| Erreur | Cause | Solution |
|--------|-------|----------|
| C_PetBattles_IsInBattle nil (29x) | Fonction non initialisée | Compat.lua + AFKS.lua init |
| C_TradeSkillUI_IsRecipeRepeating nil (11x) | Fonction non initialisée | AFKS.lua init avec fallback |
| Local.Menu.Pet[1] nil (4x) | Index sans vérification | Vérification de Local.Menu[1] |
| NecrosisConfig.BuffMenuPos nil | Config pas initialisée | Vérification NecrosisConfig tables |
| GetSpellInfo nil | API supprimée en 12.0.1 | Compat.lua wrapper |
| GetSpellCooldown nil | API supprimée en 12.0.1 | Compat.lua wrapper |
| GetItemInfo nil | API supprimée en 12.0.1 | Compat.lua wrapper |
| UnitBuff/UnitDebuff nil | APIs supprimées en 12.0.1 | Compat.lua wrappers |

## 📦 Fichiers Modifiés/Créés

**Créés:**
- ✅ Compat.lua - Couche de compatibilité API
- ✅ XML/Options-Timers_retail.lua - Interface timers 3-pages

**Modifiés (retail-specific):**
- ✅ Necrosis_Retail.toc - DestroyCount=5, Compat.lua ajouté
- ✅ Necrosis_retail.lua - SetOfxy nil checks
- ✅ AFKS.lua - API function initialization
- ✅ XML/Options-Misc_retail.lua - Suppression UI shards
- ✅ Initialize_retail.lua - Gestion NecrosisUI
- ✅ XML/Attributes_retail.lua - Protections nil checks
- ✅ XML/Options-Buttons_retail.lua - Protections button access
- ✅ XML/Options-Sphere_retail.lua - UpdatePower protection
- ✅ XML/Panel_retail.lua - OpenSettingsPanel protection

## 🎯 Status: PRÊT POUR TEST EN JEU

Tous les problèmes connus ont été corrigés. Le prochain test doit être effectué:
1. En jeu avec `/reload`
2. Ouverture des Options → Timers
3. Vérification de la configuration
4. Test des fonctionnalités principales

**Branche**: `retail` (WOW 12.0.1 Retail réel)
**Commits**: 36+ en attente de push
**Cible**: Version Retail réelle (pas PTR)
