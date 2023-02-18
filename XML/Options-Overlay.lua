--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)
local AddonName, Overlay = ...

-- Texture
local texName =
{

    [1] 	= "Backlash Green",
    [2] 	= "Backlash",
    [3] 	= "Imp Empowerment Green",
    [4] 	= "Molten Core Green",
    [5] 	= "Molten Core",
    [6] 	= "impact",	
 }

Overlay.TextureName = {}

-- Check if overlay is active
function Overlay.GetActiveOverlay(self, spellID)
    return self.ActiveOverlays[spellID] ~= nil;
end


for index, classicTexture in pairs(texName) do
  -- For now, all textures are copied locally in the addon's texture folder
  local fullTextureName = "Interface\\Addons\\Necrosis\\SpellActivations\\textures\\"..classicTexture:gsub(" ", "_"):gsub("'", "");
  Overlay.TextureName[strlower(classicTexture)] = fullTextureName;
 -- print (fullTextureName)
  Overlay.TextureName[strlower(classicTexture):gsub(" ", "_"):gsub("'", "")] = fullTextureName;
end


------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OVERLAY
------------------------------------------------------------------------------------------------------

function Necrosis:SetOverlayConfig()

	local frame = _G["NecrosisOverlayConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisOverlayConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")
		
	
		
	
		--------------------------------------------
				-- Affichage des boutons cachés
		-------------------------------------------		
		frame = CreateFrame("CheckButton", "NecrosisHiddenButtons", NecrosisOverlayConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisOverlayConfig, "BOTTOMLEFT", 40, 90)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				ShowUIPanel(NecrosisShadowTranceButton)
				ShowUIPanel(NecrosisBacklashButton)
				ShowUIPanel(NecrosisAntiFearButton)
				NecrosisCreatureAlertButton_elemental:SetAlpha(1)
				NecrosisCreatureAlertButton_elemental:SetMovable(true)
				
				NecrosisCreatureAlertButton_demon:SetMovable(true)				
				NecrosisCreatureAlertButton_demon:SetAlpha(1)
				
				NecrosisShadowTranceButton:RegisterForDrag("LeftButton")
				NecrosisBacklashButton:RegisterForDrag("LeftButton")
				NecrosisAntiFearButton:RegisterForDrag("LeftButton")
				NecrosisCreatureAlertButton_demon:RegisterForDrag("LeftButton")
				NecrosisCreatureAlertButton_elemental:RegisterForDrag("LeftButton")				
			else
				HideUIPanel(NecrosisShadowTranceButton)
				HideUIPanel(NecrosisBacklashButton)
				HideUIPanel(NecrosisAntiFearButton)
				NecrosisCreatureAlertButton_elemental:SetAlpha(0)
				NecrosisCreatureAlertButton_demon:SetAlpha(0)
				
				NecrosisCreatureAlertButton_elemental:SetMovable(false)
				NecrosisCreatureAlertButton_demon:SetMovable(false)

			    NecrosisCreatureAlertButton_elemental:RegisterForDrag("")		
				NecrosisCreatureAlertButton_demon:RegisterForDrag("")		
				NecrosisShadowTranceButton:RegisterForDrag("")
				NecrosisBacklashButton:RegisterForDrag("")
				NecrosisAntiFearButton:RegisterForDrag("")

			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
		
		
		
		
		
		-- Tailles boutons cachés
		frame = CreateFrame("Slider", "NecrosisHiddenSize", NecrosisOverlayConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(50, 200)
		frame:SetValueStep(5)
		frame:SetObeyStepOnDrag(true)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisOverlayConfig, "BOTTOMLEFT", 225, 60)

		local STx, STy, BLx, BLy, AFx, AFy, CAx, CAy
		frame:SetScript("OnEnter", function(self)
			STx, STy = NecrosisShadowTranceButton:GetCenter()
			STx = STx * (NecrosisConfig.ShadowTranceScale / 100)
			STy = STy * (NecrosisConfig.ShadowTranceScale / 100)

			BLx, BLy = NecrosisBacklashButton:GetCenter()
			BLx = BLx * (NecrosisConfig.ShadowTranceScale / 100)
			BLy = BLy * (NecrosisConfig.ShadowTranceScale / 100)

			AFx, AFy = NecrosisAntiFearButton:GetCenter()
			AFx = AFx * (NecrosisConfig.ShadowTranceScale / 100)
			AFy = AFy * (NecrosisConfig.ShadowTranceScale / 100)

			CAx, CAy = NecrosisCreatureAlertButton_elemental:GetCenter()
			CAx = CAx * (NecrosisConfig.ShadowTranceScale / 100)
			CAy = CAy * (NecrosisConfig.ShadowTranceScale / 100)
			
			CDx, CDy = NecrosisCreatureAlertButton_demon:GetCenter()
			CDx = CDx * (NecrosisConfig.ShadowTranceScale / 100)
			CDy = CDy * (NecrosisConfig.ShadowTranceScale / 100)

			ShowUIPanel(NecrosisShadowTranceButton)
			ShowUIPanel(NecrosisShadowTranceButton)			
			ShowUIPanel(NecrosisBacklashButton)
			ShowUIPanel(NecrosisAntiFearButton)
			NecrosisCreatureAlertButton_elemental:SetAlpha(1)
			NecrosisCreatureAlertButton_demon:SetAlpha(1)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self:GetValue().."%")
		end)
		frame:SetScript("OnLeave", function()
			if not NecrosisHiddenButtons:GetChecked() then
				HideUIPanel(NecrosisShadowTranceButton)
				HideUIPanel(NecrosisBacklashButton)
				HideUIPanel(NecrosisAntiFearButton)
				NecrosisCreatureAlertButton_elemental:SetAlpha(0)
				NecrosisCreatureAlertButton_demon:SetAlpha(0)				
			end
			GameTooltip:Hide()
		end)
		frame:SetScript("OnValueChanged", function(self)
			if not (self:GetValue() == NecrosisConfig.ShadowTranceScale) then
				GameTooltip:SetText(self:GetValue().."%")
				NecrosisConfig.ShadowTranceScale = self:GetValue()

				NecrosisShadowTranceButton:ClearAllPoints()
				NecrosisShadowTranceButton:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", STx / (NecrosisConfig.ShadowTranceScale / 100), STy / (NecrosisConfig.ShadowTranceScale / 100))
				NecrosisShadowTranceButton:SetScale(NecrosisConfig.ShadowTranceScale / 100)

				NecrosisBacklashButton:ClearAllPoints()
				NecrosisBacklashButton:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", BLx / (NecrosisConfig.ShadowTranceScale / 100), BLy / (NecrosisConfig.ShadowTranceScale / 100))
				NecrosisBacklashButton:SetScale(NecrosisConfig.ShadowTranceScale / 100)

				NecrosisCreatureAlertButton_elemental:ClearAllPoints()
				NecrosisCreatureAlertButton_elemental:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", CAx / (NecrosisConfig.ShadowTranceScale / 100), CAy / (NecrosisConfig.ShadowTranceScale / 100))
				NecrosisCreatureAlertButton_elemental:SetScale(NecrosisConfig.ShadowTranceScale / 100)

				NecrosisCreatureAlertButton_demon:ClearAllPoints()
				NecrosisCreatureAlertButton_demon:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", CDx / (NecrosisConfig.ShadowTranceScale / 100), CDy / (NecrosisConfig.ShadowTranceScale / 100))
				NecrosisCreatureAlertButton_demon:SetScale(NecrosisConfig.ShadowTranceScale / 100)



				NecrosisAntiFearButton:ClearAllPoints()
				NecrosisAntiFearButton:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", AFx / (NecrosisConfig.ShadowTranceScale / 100), AFy / (NecrosisConfig.ShadowTranceScale / 100))
				NecrosisAntiFearButton:SetScale(NecrosisConfig.ShadowTranceScale / 100)
			end
		end)

		NecrosisHiddenSizeLow:SetText("50 %")
		NecrosisHiddenSizeHigh:SetText("200 %")
	end

	

	

	NecrosisHiddenButtons:SetText(self.Config.Misc["Afficher les boutons caches"])
	NecrosisHiddenSizeText:SetText(self.Config.Misc["Taille des boutons caches"])
	NecrosisHiddenSize:SetValue(NecrosisConfig.ShadowTranceScale)

	frame:Show()
	
	
	----
	--OVERLAY
	--
	--test button,
	testButton = CreateFrame("button", "SpellAlertTestButton", NecrosisOverlayConfig , "OptionsButtonTemplate")
	testButton:Show()
	testButton:ClearAllPoints()
	testButton:SetPoint("CENTER", NecrosisOverlayConfig, "BOTTOMLEFT", 133, 410)
	testButton:SetText("Toggle Test");
    testButton.fakeSpellID = 42;
    testButton.isTesting = false;
	testButton.StartTest = function(self)
        if (not self.isTesting) then
            self.isTesting = true;
            ActivateOverlay(0, self.fakeSpellID, Overlay.TextureName["imp_empowerment"], "Left + Right (Flipped)", 1, 255, 255, 255, false);
            ActivateOverlay(0, self.fakeSpellID, Overlay.TextureName["brain_freeze"], "Top", 1, 255, 255, 255, false);
            -- Hack the frame to force full opacity even when out of combat
            SpellActivationOverlayFrame_SetForceAlpha1(true);
        end
    end
    testButton.StopTest = function(self)
        if (self.isTesting) then
            self.isTesting = false;
            DeactivateOverlay(self.fakeSpellID);
            -- Undo hack
            SpellActivationOverlayFrame_SetForceAlpha1(false);
        end
    end
	
	testButton:SetScript("OnClick", function(self)
		
			if (not self.isTesting) then
            self.isTesting = true;
			Overlay:ActivateOverlay(0, self.fakeSpellID, Overlay.TextureName["imp_empowerment"], "Left + Right (Flipped)", 1, 255, 255, 255, false);
            Overlay:ActivateOverlay(0, self.fakeSpellID, Overlay.TextureName["backlash"], "Top", 1, 255, 255, 255, false);
            -- Hack the frame to force full opacity even when out of combat
            SpellActivationOverlayFrame_SetForceAlpha1(true);
			else
			
			end
		
	end)
	testButton:SetScript("OnHide", function(self) 
	    if self and (self.isTesting) then
            self.isTesting = false;
            --OVERLAY:DeactivateOverlay(self.fakeSpellID);
            -- Undo hack
            SpellActivationOverlayFrame_SetForceAlpha1(false);
        end
   	end)
	testButton:SetEnabled(NecrosisConfig.ShowOlverlayAlert);
	
	--- OPACITY
	opacitySlider = CreateFrame("Slider", "SpellAlertOpacitySlider", NecrosisOverlayConfig, "OptionsSliderTemplate")
		opacitySlider:Show()
		opacitySlider:ClearAllPoints()
		opacitySlider:SetPoint("CENTER", NecrosisOverlayConfig, "BOTTOMLEFT", 133, 360)
		opacitySlider.Text:SetText(SPELL_ALERT_OPACITY);
		_G[opacitySlider:GetName().."Low"]:SetText(OFF);
		opacitySlider:SetMinMaxValues(0, 1);
    	opacitySlider:SetValueStep(0.05);
		opacitySlider:SetScript("OnValueChanged", function(self)
		 value = math.floor(self:GetValue() * 100 + 0.5) / 100;
            if (value ~= 0) then
              value = math.max(0.5, value);
            end
            self.value = value;
            self:SetValue(value);

            if (self.ApplyValueToEngine) then
              self:ApplyValueToEngine(value);
            end
			
            --_G[self:GetParent():GetName().."SpellAlertTestButton"]:SetEnabled(value > 0);
            
			--for _, checkbox in ipairs(_G[self:GetParent():GetName()].additionalCheckboxes and _G[self:GetParent():GetName()].additionalCheckboxes.alert or {}) do
             -- checkbox:SetEnabled(value > 0);
             -- checkbox:ApplyParentEnabling();
            --end
		end)
	--SCALE
	scaleSlider = CreateFrame("Slider", "SpellAlertScaleSlider", NecrosisOverlayConfig, "OptionsSliderTemplate")
		scaleSlider:Show()
		scaleSlider:ClearAllPoints()
		scaleSlider:SetPoint("CENTER", NecrosisOverlayConfig, "BOTTOMLEFT", 133, 300)
		scaleSlider:SetScript("OnValueChanged", function(self)
		 value = self:GetValue() 

            if (self.ApplyValueToEngine) then
              self:ApplyValueToEngine(value);
            end
		end)	
	--Offset
	
	offsetSlider = CreateFrame("Slider", "SpellAlertOffsetSlider", NecrosisOverlayConfig, "OptionsSliderTemplate")
		offsetSlider:Show()
		offsetSlider:ClearAllPoints()
		offsetSlider:SetPoint("CENTER", NecrosisOverlayConfig, "BOTTOMLEFT", 133, 240)
		offsetSlider:SetScript("OnValueChanged", function(self)
		 value = self:GetValue() 

            if (self.ApplyValueToEngine) then
              self:ApplyValueToEngine(value);
            end
		end)
		
	local opacitySlider = SpellAlertOpacitySlider;
    
	
	opacitySlider.Text:SetText(SPELL_ALERT_OPACITY);
    _G[opacitySlider:GetName().."Low"]:SetText(OFF);
    opacitySlider:SetMinMaxValues(0, 1);
    opacitySlider:SetValueStep(0.05);
    opacitySlider.initialValue = NecrosisConfig.Alert.Opacity;
    opacitySlider:SetValue(opacitySlider.initialValue);
    opacitySlider.ApplyValueToEngine = function(self, value)
        NecrosisConfig.Alert.Opacity = value;
        NecrosisConfig.Alert.Enabled = value > 0;
        print (self,value)
		--OVERLAY:ApplySpellAlertOpacity();
    end

    local scaleSlider = SpellAlertScaleSlider;
    scaleSlider.Text:SetText("Spell Alert Scale");
    _G[scaleSlider:GetName().."Low"]:SetText(SMALL);
    _G[scaleSlider:GetName().."High"]:SetText(LARGE);
    scaleSlider:SetMinMaxValues(0.25, 2.5);
    scaleSlider:SetValueStep(0.05);
    scaleSlider.initialValue = NecrosisConfig.Alert.Scale;
    scaleSlider:SetValue(scaleSlider.initialValue);
    scaleSlider.ApplyValueToEngine = function(self, value)
        SpellActivationOverlayDB.alert.scale = value;
         print (self,value)
		--OVERLAY:ApplySpellAlertGeometry();
    end

    local offsetSlider = SpellAlertOffsetSlider;
    offsetSlider.Text:SetText("Spell Alert Offset");
    _G[offsetSlider:GetName().."Low"]:SetText(NEAR);
    _G[offsetSlider:GetName().."High"]:SetText(FAR);
    offsetSlider:SetMinMaxValues(-200, 400);
    offsetSlider:SetValueStep(20);
    offsetSlider.initialValue = NecrosisConfig.Alert.Offset;
    offsetSlider:SetValue(offsetSlider.initialValue);
    offsetSlider.ApplyValueToEngine = function(self, value)
        SpellActivationOverlayDB.alert.offset = value;
         print (self,value)
		--OVERLAY:ApplySpellAlertGeometry();
    end

    local testButton = SpellAlertTestButton;

    
    testButton:SetEnabled(NecrosisConfig.Alert.Enabled);

   	-- Alertes transes
		
		local x_offset = 40
		
		
		frame = CreateFrame("CheckButton", "NecrosisTrance", NecrosisOverlayConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisOverlayConfig, "BOTTOMLEFT", x_offset, 130)

		frame:SetScript("OnClick", function(self) NecrosisConfig.ShadowTranceAlert = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		local Glow = NecrosisOverlayConfig:CreateFontString(nil, nil, "GameFontNormalSmall")
		Glow:Show()
		Glow:ClearAllPoints()
		Glow:SetPoint("LEFT", NecrosisOverlayConfig, "BOTTOMLEFT", x_offset+30 ,  130 )
		Glow:SetTextColor(1, 0.5, 0)
		Glow:SetText("Glow button, support Default Action Bars,Dominos,ElvUI,Bartender")
		
	   	-- Overlay
		
		local x_offset = 40
		
		
		frame = CreateFrame("CheckButton", "NecrosisOverlay", NecrosisOverlayConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisOverlayConfig, "BOTTOMLEFT", x_offset+230, 410)

		frame:SetScript("OnClick", function(self) NecrosisConfig.ShowOlverlayAlert = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		local Glow = NecrosisOverlayConfig:CreateFontString(nil, nil, "GameFontNormalSmall")
		Glow:Show()
		Glow:ClearAllPoints()
		Glow:SetPoint("LEFT", NecrosisOverlayConfig, "BOTTOMLEFT", x_offset + 260 ,  410 )
		Glow:SetTextColor(1, 0.5, 0)
		Glow:SetText("Show Spell Alert Overlay")

  -- local classOptions = "WARLOCK" and "warlock" and SpellActivationOverlayDB.classes[SAO.CurrentClass.Intrinsics[2]];

	
end


-- List of currently active overlays
-- key = spellID, value = aura config
-- This list will change each time an overlay is triggered or un-triggered
Overlay.ActiveOverlays = {}

-- Check if overlay is active
function GetActiveOverlay(self, spellID)
    return self.ActiveOverlays[spellID] ~= nil;
end

-- Search in overlay options if the specified auraID should be discarded
-- By default, do *not* discard
-- This happens e.g., if there is no option for this auraID
local function discardedByOverlayOption(self, auraID, stacks)
    if (not SpellActivationOverlayDB) then
        return false; -- By default, do not discard
    end

    if (SpellActivationOverlayDB.alert and not SpellActivationOverlayDB.alert.enabled) then
        return true;
    end

    local overlayOptions = self:GetOverlayOptions(auraID);

    if (not overlayOptions) then
        return false; -- By default, do not discard
    end

    -- Look for option in the exact stack count
    if (type(overlayOptions[stacks]) ~= "nil") then
        return not overlayOptions[stacks];
    end

    -- Look for a default option as if stacks == 0
    if (stacks and stacks > 0 and type(overlayOptions[0]) ~= "nil") then
        return not overlayOptions[0];
    end

    return false; -- By default, do not discard
end

-- Add or refresh an overlay
function Overlay:ActivateOverlay(self, stacks, spellID, texture, positions, scale, r, g, b, autoPulse, forcePulsePlay)
    if (texture) then
        -- Tell the overlay is active, even though the overlay may be discarded below
        -- This "active state" tells the aura is in place, which is used by e.g. the glowing button system
        self.ActiveOverlays[spellID] = stacks;

        -- Discard the overlay if options are not favorable
        if (discardedByOverlayOption(Overlay, spellID, stacks)) then
            return;
        end

        -- Hack to avoid glowIDs to be treated as forcePulsePlay
        if (type(forcePulsePlay) == 'table') then
            forcePulsePlay = false;
        end

        -- Fetch texture from functor if needed
        if (type(texture) == 'function') then
            texture = texture(Overlay);
        end

        -- Actually show the overlay(s)
        self.ShowAllOverlays(Overlay.Frame, spellID, texture, positions, scale, r, g, b, autoPulse, forcePulsePlay);
    end
end

-- Remove an overlay
function Overlay:DeactivateOverlay(Overlay, spellID)
    self.ActiveOverlays[spellID] = nil;
    self.HideOverlays(Overlay.Frame, spellID);
end
