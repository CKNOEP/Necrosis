# 🔧 Référence Technique - Necrosis WoW Anniversaire

## 📋 Informations de Version

### WoW Classic Anniversaire
- **Version du jeu** : 1.15.5 - 1.15.7
- **Interface ID** : 11505 - 11507
- **Type** : Classic Vanilla (patch 1.12 content)
- **Date de sortie** : Novembre 2024

### Necrosis
- **Version actuelle Vanilla** : 8.0.6
- **TOC File** : Necrosis-Vanilla.toc
- **SavedVariables** : NecrosisConfig (per character)

---

## 🎮 APIs WoW Importantes

### APIs de Sorts (Spell APIs)

#### GetSpellInfo()
```lua
-- Vanilla/Classic usage
local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellID)
```

#### UnitBuff() / UnitDebuff()
```lua
-- Classic format
local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
      nameplateShowPersonal, spellId = UnitBuff("unit", index)
```

#### CastSpellByName()
```lua
-- Vanilla method (deprecated in later versions)
CastSpellByName("Spell Name(Rank X)")
```

### APIs de Démons (Pet APIs)

```lua
-- Summon demon
CastSpellByName("Summon Imp")

-- Check if demon is active
UnitExists("pet")
UnitName("pet")

-- Demon health/mana
UnitHealth("pet")
UnitPower("pet")
```

### APIs de Sacs (Bag APIs)

```lua
-- Soul Shard detection
GetContainerNumSlots(bagID)
GetContainerItemInfo(bagID, slot)

-- Soul Shards are items with ID: 6265
```

### APIs d'Interface

```lua
-- Create frames
CreateFrame("Frame", "FrameName", UIParent, "BackdropTemplate")

-- Register events
frame:RegisterEvent("EVENT_NAME")
frame:SetScript("OnEvent", function(self, event, ...) end)

-- Show/Hide
frame:Show()
frame:Hide()
```

---

## 🎯 Sorts de Démoniste Vanilla

### IDs de Sorts Principaux

| Sort | ID | Ranks | Notes |
|------|-----|-------|-------|
| Shadow Bolt | 686 | 1-10 | Sort principal |
| Corruption | 172 | 1-6 | DoT principal |
| Curse of Agony | 980 | 1-6 | Curse DoT |
| Immolate | 348 | 1-8 | DoT Fire |
| Searing Pain | 5676 | 1-6 | Instant damage |
| Drain Soul | 1120 | 1-5 | Farming shards |
| Drain Life | 689 | 1-6 | Heal + damage |
| Fear | 5782 | 1-3 | CC |
| Death Coil | 6789 | 1-4 | Instant damage |
| Howl of Terror | 5484 | 1-2 | AoE Fear |
| Life Tap | 1454 | 1-7 | Mana conversion |
| Siphon Life | 18265 | 1-6 | Affliction DoT |
| Conflagrate | 17962 | 1-5 | Destruction |
| Shadowburn | 17877 | 1-8 | Destruction |

### Pierres (Stones)

| Pierre | Item ID | Spell ID | Cooldown |
|--------|---------|----------|----------|
| Healthstone | 5512-19007 | Multiple | 2 min |
| Soulstone | 5232-16896 | Multiple | 30 min |
| Spellstone | 5522-19013 | Multiple | - |
| Firestone | 1254-13699 | Multiple | - |

### Démons

| Démon | Spell ID | Soul Shards | Level |
|-------|----------|-------------|-------|
| Imp | 688 | 0 | 1 |
| Voidwalker | 697 | 1 | 10 |
| Succubus | 712 | 1 | 20 |
| Felhunter | 691 | 1 | 30 |
| Infernal | 1122 | 1 | 50 (ritual) |
| Doomguard | 18540 | 1 | 60 (ritual) |

---

## 📊 Événements WoW (Events)

### Événements Critiques pour Necrosis

```lua
-- Chargement
"ADDON_LOADED"
"PLAYER_LOGIN"
"PLAYER_ENTERING_WORLD"

-- Combat
"PLAYER_REGEN_DISABLED" -- Enter combat
"PLAYER_REGEN_ENABLED"  -- Leave combat
"PLAYER_TARGET_CHANGED"

-- Sorts
"UNIT_SPELLCAST_START"
"UNIT_SPELLCAST_SUCCEEDED"
"UNIT_SPELLCAST_FAILED"

-- Auras
"UNIT_AURA"
"PLAYER_AURAS_CHANGED"

-- Sacs
"BAG_UPDATE"
"BAG_UPDATE_DELAYED"

-- Pet
"UNIT_PET"
"PET_ATTACK_START"
"PET_ATTACK_STOP"
```

---

## 🔍 Structure des Fichiers Necrosis

### Fichiers Core

| Fichier | Rôle | Priorité |
|---------|------|----------|
| Initialize.lua | Initialisation addon | ⭐⭐⭐ |
| Necrosis.lua | Core principal | ⭐⭐⭐ |
| Utils.lua | Fonctions utilitaires | ⭐⭐⭐ |
| Functions.lua | Fonctions principales | ⭐⭐⭐ |
| Spells-Vanilla.lua | Gestion sorts Vanilla | ⭐⭐⭐ |

### Fichiers Interface

| Fichier | Rôle | Priorité |
|---------|------|----------|
| XML/Options-Sphere-Vanilla.lua | Config sphère | ⭐⭐ |
| XML/Options-Buttons-Vanilla.lua | Config boutons | ⭐⭐ |
| XML/Options-Misc.lua | Config diverses | ⭐⭐ |
| XML/Panel.lua | Panel options | ⭐⭐ |

### Fichiers Timers

| Fichier | Rôle | Priorité |
|---------|------|----------|
| Timers/Functions.lua | Core timers | ⭐⭐⭐ |
| Timers/GraphicalTimers.lua | Affichage graphique | ⭐⭐ |
| Timers/OtherTimers.lua | Autres timers | ⭐⭐ |

---

## 🛠️ Outils de Debug

### Commandes Slash Necrosis

```lua
/necrosis          -- Ouvre le menu d'options
/necrosis reset    -- Reset la configuration
/necrosis sphere   -- Toggle sphère
```

### Commandes WoW Utiles

```lua
/console scriptErrors 1    -- Active les erreurs Lua
/reload                    -- Recharge l'UI
/run print(GetAddOnInfo("Necrosis"))  -- Info addon
/framestack                -- Debug frames
/etrace                    -- Event trace
```

### Debug Lua

```lua
-- Print dans la console
print("Debug:", variable)

-- DevTools
if DevTools_Dump then
    DevTools_Dump(table)
end

-- Lua error catching
local success, result = pcall(function()
    -- code risqué
end)
```

---

## 📚 Bibliothèques Ace3

### AceAddon-3.0
```lua
-- Création addon
local MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon")

function MyAddon:OnInitialize()
    -- Init code
end

function MyAddon:OnEnable()
    -- Enable code
end
```

### AceConfig-3.0
```lua
-- Configuration UI
local options = {
    type = "group",
    args = {
        myOption = {
            type = "toggle",
            name = "My Option",
            get = function() return db.myOption end,
            set = function(info, value) db.myOption = value end,
        },
    },
}
```

### AceDB-3.0
```lua
-- Database
self.db = LibStub("AceDB-3.0"):New("MyAddonDB", defaults)
```

---

## ⚠️ Problèmes Connus (Vanilla Classic)

### APIs Dépréciées
- `UnitCastingInfo()` - N'existe pas en Vanilla
- `GetSpellCooldown()` - Format différent
- `C_Timer` - N'existe pas, utiliser `CreateFrame` + `OnUpdate`

### Limitations Vanilla
- Pas de spell IDs directs pour tous les sorts
- Certains sorts nécessitent le nom + rank
- Système de backdrop différent (pas de BackdropTemplate en 1.12)

### Workarounds Communs
```lua
-- Alternative à C_Timer
local frame = CreateFrame("Frame")
frame:SetScript("OnUpdate", function(self, elapsed)
    self.timer = (self.timer or 0) + elapsed
    if self.timer >= delay then
        callback()
        self:SetScript("OnUpdate", nil)
    end
end)

-- Trouver un sort par nom
local spellName = GetSpellInfo(spellID)
```

---

## 🔗 Ressources Externes

### Documentation
- **WoWpedia Classic** : https://wowpedia.fandom.com/wiki/Classic_API
- **WoW Programming** : https://wowwiki-archive.fandom.com/wiki/World_of_Warcraft_API
- **Ace3 Tutorial** : https://www.wowace.com/projects/ace3

### Outils
- **BugSack** : Addon pour capturer les erreurs Lua
- **BugGrabber** : Capture les erreurs
- **WoWLua** : Éditeur Lua en jeu
- **FrameXML Browser** : Voir le code source Blizzard

### Communauté
- **WoWInterface** : https://www.wowinterface.com/
- **CurseForge** : https://www.curseforge.com/wow/addons
- **GitHub** : https://github.com/topics/wow-addon

---

## 📝 Notes de Développement

### Bonnes Pratiques
1. Toujours tester avec `/console scriptErrors 1`
2. Utiliser LibStub pour les bibliothèques
3. Sauvegarder les configs dans SavedVariables
4. Préfixer les frames globaux pour éviter les conflits
5. Nettoyer les événements dans `:OnDisable()`

### Conventions Necrosis
- Préfixe global : `Necrosis`
- SavedVariable : `NecrosisConfig`
- Événements : Registrés dans Initialize.lua
- Locales : Via AceLocale-3.0

---

**Dernière mise à jour** : 07/02/2026
