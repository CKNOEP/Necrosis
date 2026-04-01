# Analyse Comparative : XML/Options-Sphere.lua

## Fichiers Analysés
- **Anniversary** : `_anniversary_/XML/Options-Sphere.lua`
- **Retail** : `_retail_/XML/Options-Sphere_retail.lua`

---

## 🔴 Features Manquantes dans Retail

### 1. **Gestion Avancée des Shards (IMPORTANT)**
**Anniversary** (lignes 295-314):
```lua
-- Checkbox pour supprimer shards via shift+clic sur la sphère
frame = CreateFrame("CheckButton", "NecrosisDeleteShardsOutCount", ...)
frame:SetScript("OnClick", function(self)
    NecrosisConfig.DestroyShardwithsphere = self:GetChecked()
    Necrosis:BagExplore()
end)
```
- Permet au joueur de configurer la suppression auto de shards
- Affiche le seuil de suppression : `"Shards > "..tostring(NecrosisConfig.DestroyCount)`

**Retail** : ❌ Complètement absent
- Il y a une checkbox "ShowCount" mais ce n'est pas la même chose
- Pas de contrôle sur la destruction des shards

**Impact** : Cette feature était importante en TBC/Cata pour la gestion des shards. Bien qu'en Retail il n'y ait plus de limite de shards, il serait utile pour les nostalgiques ou pour du RP.

---

### 2. **Repositionnement Intelligent lors du Scaling**
**Anniversary** (lignes 119-156):
```lua
NBx = NBx * (NecrosisConfig.NecrosisButtonScale / 100)
NBy = NBy * (NecrosisConfig.NecrosisButtonScale / 100)

frame:SetScript("OnValueChanged", function(self)
    -- Recalcule position X/Y pour éviter que la sphère bouge
    NecrosisConfig.FramePosition["NecrosisButton"][4] = NBx / (NecrosisConfig.NecrosisButtonScale / 100)
    NecrosisConfig.FramePosition["NecrosisButton"][5] = NBy / (NecrosisConfig.NecrosisButtonScale / 100)

    f:SetPoint(NecrosisConfig.FramePosition["NecrosisButton"][1],
        NecrosisConfig.FramePosition["NecrosisButton"][2],
        NecrosisConfig.FramePosition["NecrosisButton"][3],
        NBx / (NecrosisConfig.NecrosisButtonScale / 100),
        NBy / (NecrosisConfig.NecrosisButtonScale / 100))
end)
```

**Retail** (lignes 132-145):
```lua
frame:SetScript("OnValueChanged", function(self)
    if not (self:GetValue() == NecrosisConfig.NecrosisButtonScale) then
        NecrosisConfig.NecrosisButtonScale = self:GetValue()
        f:SetScale(NecrosisConfig.NecrosisButtonScale / 100)
        Necrosis:ButtonSetup()
    end
end)
```

**Différence** :
- **Anniversary** : Recalcule les positions pour que le bouton reste au même endroit à l'écran
- **Retail** : Just change le scale, la position bouge relativement

**Impact** : Moyen - Retail délègue au `ButtonSetup()` qui peut gérer ça différemment

---

### 3. **Palette de Skins Plus Riche**
**Anniversary** (lignes 357-404):
```lua
local couleur = {"Rose", "Bleu", "Orange", "Turquoise", "Violet1", "Violet2", "666", "X"}
-- 8 skins différents disponibles
```

**Retail** (lignes 412-419):
```lua
local couleur = {"Cata"}  -- Seulement 1 skin !
-- Mais aussi "Purple" dans la config
```

**Impact** : Les anciennes textures ne sont probablement plus disponibles en Retail

---

## 🟢 Features Excédentaires dans Retail

### 1. **Contrôle d'Espacement des Boutons** ⭐
**Retail** (lignes 151-196):
```lua
frame = CreateFrame("Slider", "NecrosisButtonSpacing", ...)
frame:SetMinMaxValues(0.5, 2.0)
frame:SetValueStep(0.1)
```
- Permet de contrôler la distance entre les boutons de la sphère
- Range : 0.5x à 2.0x
- Très utile pour adapter à différentes résolutions

**Anniversary** : ❌ N'existe pas

---

### 2. **Contrôle du Rayon des Boutons** ⭐
**Retail** (lignes 242-287):
```lua
frame = CreateFrame("Slider", "NecrosisButtonRadius", ...)
frame:SetMinMaxValues(0.8, 1.2)
frame:SetValueStep(0.05)
```
- Ajuste la distance de la sphère par rapport au centre
- Range : 0.8x à 1.2x
- Excellent pour l'ergonomie

**Anniversary** : ❌ N'existe pas

---

### 3. **Intégration AceLocale Meilleure**
**Retail** (lignes 444-454):
```lua
function Necrosis.Skin_Init()
    local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)
    Necrosis.Config.Sphere.Colour = {
        L["CATA"],
        L["PURPLE"],
    }
end
```

**Anniversary** (lignes 387-395):
```lua
function Necrosis.Skin_Init()
    local element = {}
    for i in ipairs(Necrosis.Config.Sphere.Colour) do
        element.text = Necrosis.Config.Sphere.Colour[i]
        element.checked = false
        element.func = Necrosis.Skin_Click
        UIDropDownMenu_AddButton(element)
    end
end
```

**Impact** : Retail utilise mieux la localisation via AceLocale

---

## 📋 Recommandations d'Intégration

### Priority 1 : À Intégrer
- [ ] **Contrôle Espacement** (Retail → Anniversary concept) ✅ DÉJÀ DANS RETAIL
- [ ] **Contrôle Rayon** (Retail → Anniversary concept) ✅ DÉJÀ DANS RETAIL

### Priority 2 : Optionnel
- [ ] **Gestion des Shards** si on veut garder la nostalgie TBC/Cata
  - Ajouter checkbox `NecrosisDeleteShardsOutCount`
  - Ajouter affichage du seuil

### Priority 3 : À Évaluer
- [ ] **Repositionnement Intelligent**
  - Vérifier si `ButtonSetup()` le gère déjà
  - Tester le comportement actuel avant de modifier

---

## Conclusion

**Le Retail est MEILLEUR que Anniversary** pour les options de la sphère car :
- ✅ Deux nouveaux sliders (Spacing & Radius) excellents et pratiques
- ✅ Meilleure intégration AceLocale
- ✅ Code plus propre et moderne

**Seule chose à considérer** : Si vous voulez supporter les anciennes versions, vous pourriez ajouter le contrôle de suppression des shards, mais c'est une feature de nostalgie plutôt qu'une amélioration.

### Les Shards en Retail ?
En Retail 12.0, les shards ne sont plus limités (il n'y a pas de limite comme avant). Donc :
- La gestion de destruction automatique n'est **pas nécessaire**
- Conserver c'est du RP / nostalgie

**Verdict** : Keep Retail as-is, ne rien rétroporter d'Anniversary sauf si demande explicite.
