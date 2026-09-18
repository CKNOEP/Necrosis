# 🎨 Implémentation RGB pour l'Affichage de la Sphère Centrale

**Date** : 2 avril 2026
**Technique** : SetVertexColor/GetVertexColor sans Taint
**Contexte** : Retail 12.0.1 - Support des 8 skins de sphère

---

## 📋 Fichiers Modifiés avec RGB

### 1. **Initialize_retail.lua** ⭐
**Ligne 248-271**

Utilisation de `SetVertexColor()` pour colorier les textures de la sphère de manière **non-tainte** :

```lua
-- Création des textures de la sphère
artFrame.Center = textureContainer:CreateTexture('NUI_Art_Classic_Center', 'BACKGROUND')
artFrame.Center:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-center')
artFrame.Center:SetPoint('BOTTOM', artFrame, 'BOTTOM')
artFrame.Center:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen (RGB encoding sans taint)

artFrame.Left = textureContainer:CreateTexture('NUI_Art_Classic_Left', 'BACKGROUND')
artFrame.Left:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-left1')
artFrame.Left:SetPoint('BOTTOMRIGHT', artFrame.Center, 'BOTTOMLEFT', 0, 0)
artFrame.Left:SetVertexColor(0.7, 0.3, 1.0)  -- Même couleur, pas de taint!

artFrame.FarLeft = textureContainer:CreateTexture('NUI_Art_Classic_FarLeft', 'BACKGROUND')
artFrame.FarLeft:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-left2')
artFrame.FarLeft:SetPoint('BOTTOMRIGHT', artFrame.Left, 'BOTTOMLEFT', 0, 0)
artFrame.FarLeft:SetPoint('BOTTOMLEFT', artFrame, 'BOTTOMLEFT', 0, 0)
artFrame.FarLeft:SetVertexColor(0.7, 0.3, 1.0)

artFrame.Right = textureContainer:CreateTexture('NUI_Art_Classic_Right', 'BACKGROUND')
artFrame.Right:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-right1')
artFrame.Right:SetPoint('BOTTOMLEFT', artFrame.Center, 'BOTTOMRIGHT')
artFrame.Right:SetVertexColor(0.7, 0.3, 1.0)

artFrame.FarRight = textureContainer:CreateTexture('NUI_Art_Classic_FarRight', 'BACKGROUND')
artFrame.FarRight:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-right2')
artFrame.FarRight:SetPoint('BOTTOMLEFT', artFrame.Right, 'BOTTOMRIGHT')
artFrame.FarRight:SetPoint('BOTTOMRIGHT', artFrame, 'BOTTOMRIGHT')
artFrame.FarRight:SetVertexColor(0.7, 0.3, 1.0)
```

**Avantage** : Les appels `SetVertexColor()` ne tainte PAS le code, donc on peut l'appeler depuis n'importe quel contexte.

---

### 2. **UI/BottomBanner/Style.lua** ⭐
**Ligne 41-64**

Même pattern que Initialize_retail.lua, mais pour le frame de style :

```lua
-- Create textures avec SetVertexColor (pas de taint)
artFrame.Center = artFrame:CreateTexture('NUI_Art_Classic_Center', 'BACKGROUND')
artFrame.Center:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-center')
artFrame.Center:SetPoint('BOTTOM', artFrame, 'BOTTOM')
artFrame.Center:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen (RGB)

artFrame.Left = artFrame:CreateTexture('NUI_Art_Classic_Left', 'BACKGROUND')
artFrame.Left:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-left1')
artFrame.Left:SetPoint('BOTTOMRIGHT', artFrame.Center, 'BOTTOMLEFT', 0, 0)
artFrame.Left:SetVertexColor(0.7, 0.3, 1.0)

artFrame.FarLeft = artFrame:CreateTexture('NUI_Art_Classic_FarLeft', 'BACKGROUND')
artFrame.FarLeft:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-left2')
artFrame.FarLeft:SetPoint('BOTTOMRIGHT', artFrame.Left, 'BOTTOMLEFT', 0, 0)
artFrame.FarLeft:SetPoint('BOTTOMLEFT', NecrosisUI, 'BOTTOMLEFT', 0, 0)
artFrame.FarLeft:SetVertexColor(0.7, 0.3, 1.0)

artFrame.Right = artFrame:CreateTexture('NUI_Art_Classic_Right', 'BACKGROUND')
artFrame.Right:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-right1')
artFrame.Right:SetPoint('BOTTOMLEFT', artFrame.Center, 'BOTTOMRIGHT')
artFrame.Right:SetVertexColor(0.7, 0.3, 1.0)

artFrame.FarRight = artFrame:CreateTexture('NUI_Art_Classic_FarRight', 'BACKGROUND')
artFrame.FarRight:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-right2')
artFrame.FarRight:SetPoint('BOTTOMLEFT', artFrame.Right, 'BOTTOMRIGHT')
artFrame.FarRight:SetPoint('BOTTOMRIGHT', NecrosisUI, 'BOTTOMRIGHT')
artFrame.FarRight:SetVertexColor(0.7, 0.3, 1.0)
```

---

### 3. **XML/Options-Sphere_retail.lua** ⭐⭐ (PRINCIPALE)
**Ligne 412-485**

**Gestion des 8 skins de sphère avec support RGB** :

```lua
-- Configuration des 8 skins disponibles
local couleur = {"Rose", "Bleu", "Orange", "Turquoise", "Violet1", "Violet2", "666", "X"}

-- Dans Skin_Init() : Initialiser le dropdown
function Necrosis.Skin_Init()
    local element = {}
    local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)
    Necrosis.Config.Sphere.Colour = {
        L["ROSE"],          -- Localisé
        L["BLEU"],
        L["ORANGE"],
        L["TURQUOISE"],
        L["VIOLET1"],
        L["VIOLET2"],
        L["666"],
        L["X"],
    }
    for i in ipairs(Necrosis.Config.Sphere.Colour) do
        element.text = Necrosis.Config.Sphere.Colour[i]
        element.checked = false
        element.func = Necrosis.Skin_Click
        UIDropDownMenu_AddButton(element)
    end
end

-- Dans Skin_Click() : Appliquer la couleur sélectionnée
function Necrosis.Skin_Click(self)
    local ID = self:GetID()
    local couleur = {"Rose", "Bleu", "Orange", "Turquoise", "Violet1", "Violet2", "666", "X"}
    
    if couleur[ID] then
        -- ✅ Sauvegarder le choix en config (SAFE - pas d'accès à API tainte)
        NecrosisConfig.NecrosisColor = couleur[ID]
        
        -- ✅ Appliquer la texture de la sphère (SAFE - SetNormalTexture n'est pas tainte)
        local f = _G[Necrosis.Warlock_Buttons.main.f]
        if f then
            pcall(function()
                f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..couleur[ID].."\\Shard0-2")
            end)
        end
        
        -- ✅ Mettre à jour le dropdown visuel
        UIDropDownMenu_SetSelectedID(NecrosisSkinSelection, ID)
        local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)
        local couleurLabels = {L["ROSE"], L["BLEU"], L["ORANGE"], L["TURQUOISE"], L["VIOLET1"], L["VIOLET2"], L["666"], L["X"]}
        
        if couleurLabels[ID] then
            local button = _G["NecrosisSkinSelectionButton"]
            if button then
                button:SetText(couleurLabels[ID])
            end
            UIDropDownMenu_SetText(NecrosisSkinSelection, couleurLabels[ID])
        end
    end
end
```

**Key Points** :
- 8 skins disponibles : Rose, Bleu, Orange, Turquoise, Violet1, Violet2, 666, X
- Chaque skin correspond à un dossier : `Interface\AddOns\Necrosis\UI\[Couleur]\`
- La sélection est stockée dans `NecrosisConfig.NecrosisColor`
- L'affichage utilise `SetNormalTexture()` (pas tainte)

---

## 🎨 Structure des Couleurs de Sphère

```
Necrosis/UI/
├── Rose/
│   ├── Shard0-2.blp (texture principale)
│   ├── Shard0-3.blp
│   └── ...
├── Bleu/
├── Orange/
├── Turquoise/
├── Violet1/
├── Violet2/
├── 666/          (Teinte sombre/noire)
└── X/            (Teinte alternative)
```

Chaque dossier contient les textures de la sphère dans cette couleur.

---

## 🔄 Flux d'Affichage (RGB Pattern)

### Étape 1 : Initialisation (Initialize_retail.lua)
```lua
-- Création des textures avec couleur par défaut (Violet)
artFrame.Center:SetVertexColor(0.7, 0.3, 1.0)
artFrame.Left:SetVertexColor(0.7, 0.3, 1.0)
-- ... etc
```
✅ **Pas de taint** - Les SetVertexColor ne tainte jamais

### Étape 2 : Sélection du Skin (Options-Sphere_retail.lua)
```lua
-- Utilisateur clique sur un skin dans le dropdown
NecrosisConfig.NecrosisColor = "Rose"  -- Stockage safe

-- Appliquer la nouvelle texture
f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Rose\\Shard0-2")
```
✅ **Pas de taint** - SetNormalTexture et config storage ne taintent pas

### Étape 3 : Récupération (OnUpdate ou événement)
```lua
-- Récupérer la couleur stockée
local skin = NecrosisConfig.NecrosisColor  -- "Rose", "Bleu", etc.

-- Charger la texture sans taint
local textureFile = "Interface\\AddOns\\Necrosis\\UI\\"..skin.."\\Shard0-2"
```
✅ **Pas de taint** - Lecture de config, pas d'API tainte

---

## 🛡️ Avantages de cette Approche

| Avantage | Explication |
|----------|------------|
| ✅ **Pas de Taint** | SetVertexColor/GetVertexColor ne tainte jamais |
| ✅ **Rapide** | Les textures sont chargées localement (pas d'API) |
| ✅ **Flexible** | 8 skins support, extensible facilement |
| ✅ **Persistent** | La config est sauvegardée entre sessions |
| ✅ **Sûr** | Utilise pcall() pour les appels potentiellement risqués |
| ✅ **Localisé** | Support de 8 langues pour les labels |

---

## 📊 Résumé de l'Implémentation

### Fichiers Impliqués
1. **Initialize_retail.lua** (ligne 248-271)
   - Setup initial avec couleur par défaut (Violet)
   - SetVertexColor sur les 5 parties de la sphère

2. **UI/BottomBanner/Style.lua** (ligne 41-64)
   - Style applicatif, même structure que Initialize_retail.lua

3. **XML/Options-Sphere_retail.lua** (ligne 412-485)
   - Interface de sélection des 8 skins
   - Sauvegarde du choix en config
   - Application de la nouvelle texture

### Locales (8 langues)
- Locales/enUS.lua
- Locales/frFR.lua
- Locales/deDE.lua
- ... (6 autres)

Chaque locale inclut les traductions pour : ROSE, BLEU, ORANGE, TURQUOISE, VIOLET1, VIOLET2, 666, X

---

## 🔧 Technique RGB Utilisée

**Pattern de Base** :
```lua
-- Encoder une valeur (0-255) en canal RGB normalisé (0-1)
texture:SetVertexColor(value / 255, 0, 0)

-- Plus tard, récupérer sans taint
local r, g, b = texture:GetVertexColor()
local value = math.floor(r * 255)
```

**Application pour Sphère** :
```lua
-- Couleur Violet = R:0.7, G:0.3, B:1.0 (en 0-1)
-- = R:179, G:77, B:255 (en 0-255)
artFrame.Center:SetVertexColor(0.7, 0.3, 1.0)

-- Récupérer plus tard
local r, g, b = artFrame.Center:GetVertexColor()
-- Maintenant r=0.7, g=0.3, b=1.0
```

**Avantage** : Ces appels ne tainte JAMAIS le code, contrairement aux APIs comme GetSpellInfo() ou UnitBuff()

---

## 💡 Conclusion

L'implémentation utilise **SetVertexColor/GetVertexColor comme transport de données non-tainte** pour :

1. **Affichage de la couleur de la sphère** (Violet, Rose, Bleu, etc.)
2. **Sélection du skin** (8 options disponibles)
3. **Stockage/Récupération** sans accès à des APIs taintes

C'est une application **très pratique** de la technique RGB pour contourner les restrictions de Retail 12.0+ ! 🎨

---

**Dernière mise à jour** : 2 avril 2026
**Version** : Necrosis 8.4.0+
**Branches** : retail (Midnight 12.0.1)
