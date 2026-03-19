# SummonQueue Module - Custom Texture Integration Guide

## Votre Texture 🎨

**Fichier:** `UI/generated-image.png` → Renommé en `UI/SummonQueue-Icon.png`
**Taille:** 2048x2048 pixels
**Style:** WoW Pixel Art avec démon vert, croix d'invocation, points rouges, aura violette
**Format:** PNG (2048x2048)

## Intégration Étape par Étape

### Option 1 : PNG Directe (Recommandée pour WoW moderne)

WoW Modern supporte les PNG nativement. Utilisation immédiate :

1. **Fichier source :** `UI/generated-image.png`
2. **Copier vers :** `UI/SummonQueue-Icon.png`
3. **Utiliser dans le code :**

```lua
-- Dans Panel.lua, ligne ~195 :
if i == 6 then
    frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.png")
else
    frame:SetNormalTexture("Interface\\Icons\\"..tex[i])
end
```

4. **Ou dans SummonQueue.lua (GUI window icon) :**

```lua
-- Dans CreateQueueWindow()
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
-- ...
-- Ajouter une texture icône au-dessus du titre
local icon = frame:CreateTexture(nil, "OVERLAY")
icon:SetSize(32, 32)
icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
icon:SetTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.png")
```

### Option 2 : TGA Format (Pour compatibilité maximum)

Pour les versions plus anciennes de WoW :

1. **Conversion PNG → TGA**
   - GIMP : File → Export As → Select "TGA (.tga)"
   - Photoshop : File → Export As → TGA
   - Online : CloudConvert.com

2. **Propriétés TGA recommandées :**
   - Format : Uncompressed (pas de compression)
   - 2048x2048 résolution
   - RGBA (avec canal alpha pour transparence)

3. **Utilisation identique au PNG :**

```lua
frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.tga")
```

### Option 3 : Intégrer dans la GUI SummonQueue

Afficher l'icône dans la fenêtre de queue elle-même :

```lua
-- Dans SummonQueue:CreateQueueWindow()
function SummonQueue:CreateQueueWindow()
    -- ... existing code ...

    -- Add icon decoration to window
    local iconFrame = frame:CreateTexture(nil, "BACKGROUND")
    iconFrame:SetSize(64, 64)
    iconFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -12)
    iconFrame:SetTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.png")
    iconFrame:SetAlpha(0.3)  -- Transparent background icon
end
```

## Implémentation Actuelle

**Statut :** Module SummonQueue fonctionnel avec icône par défaut ("Spell_Shadow_Summon")

**Icône du panneau :** `Spell_Shadow_Summon` (icône standard WoW)

**Votre texture peut :**
- ✅ Remplacer l'icône du 7e onglet de configuration
- ✅ Décorer la fenêtre de queue (coin supérieur droit)
- ✅ Servir de favicon pour l'addon

## Exemple d'Utilisation Complète

```lua
-- 1. Panel tab icon (Panel.lua, ~line 195)
if i == 6 then  -- Panel 7 = SummonQueue
    frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.png")
else
    frame:SetNormalTexture("Interface\\Icons\\"..tex[i])
end

-- 2. Window decoration (SummonQueue.lua, CreateQueueWindow)
function SummonQueue:CreateQueueWindow()
    -- ... existing window setup ...

    local decor = frame:CreateTexture(nil, "BACKGROUND")
    decor:SetSize(48, 48)
    decor:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -12)
    decor:SetTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.png")
    decor:SetAlpha(0.2)
    frame.decor = decor
end

-- 3. Button icon (optional, pour le bouton d'ajout de queue)
function SummonQueue:CreateQueueButton()
    local btn = CreateFrame("Button", nil, someFrame, "UIPanelButtonTemplate")
    -- ...
    btn:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.png")
end
```

## Taille et Optimisation

| Format | Taille Fichier | Compatibilité | Recommandé |
|--------|----------------|----------------|-----------|
| PNG 2048x2048 | ~428 KB | WoW Modern | ✅ OUI |
| TGA 2048x2048 | ~12-16 MB | Tous | Oui (si compat) |
| PNG Redimensionné 256x256 | ~15 KB | WoW Modern | Alternative rapide |

**Conseil :** Pour réduire la taille du téléchargement, redimensionner à 256x256 ou 512x512 si qualité acceptable.

## Prochaines Étapes

1. **Immédiat :** Copier `UI/generated-image.png` → `UI/SummonQueue-Icon.png`
2. **Optionnel :** Mettre à jour Panel.lua pour utiliser l'icône custom
3. **Optionnel :** Ajouter décoration icône à la GUI window
4. **Alternative :** Convertir en TGA pour distributions anciennes

## Fichiers Impliqués

```
Necrosis/
├── UI/
│   ├── generated-image.png        # Source original
│   ├── SummonQueue-Icon.png       # Pour utilisation dans l'addon
│   └── SummonQueue-Icon.tga       # (Optionnel) version TGA
├── XML/
│   └── Panel.lua                  # Modification ligne ~195 (optionnel)
└── SummonQueue.lua                # Modification CreateQueueWindow (optionnel)
```

## Support

Pour une intégration full de la texture :
- Éditer Panel.lua pour l'icône du 7e onglet
- Éditer SummonQueue.lua pour décorer la GUI window
- Tester en jeu avec `/necrosis` → Summon Queue tab

**Tous les fichiers Lua supportent déjà les chemins PNG/TGA - aucune modification de code requise pour utiliser l'icône !**
