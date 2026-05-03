--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OPTIONS
------------------------------------------------------------------------------------------------------

function Necrosis:SetMiscConfig()

	local frame = _G["NecrosisMiscConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisMiscConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")
		
		--[[
		FontString = frame:CreateFontString(nil, nil, "ChatFontNormal")
		FontString:SetFont("Fonts\\ARIALN.TTF", 12)
		FontString:SetTextColor(1, 1, 1)
		--]]	
		
		-- Set AFK Module
		frame = CreateFrame("CheckButton", "NecrosisAFK", NecrosisMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 40, 420)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.AFK = self:GetChecked()
			--print (self:GetChecked(),NecrosisConfig.AFK)
		end)		
		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
		
		
		
	
	
    	NecrosisAFK:SetText("AFK Screen")


	-- Boutons oVERLAY
	frame = CreateFrame("Button", nil, NecrosisMiscConfig, "UIPanelButtonTemplate")
	frame:SetText("Open Options SpellOverlay")
	frame:SetSize(200 ,22) -- width, height
	frame:EnableMouse(true)
	frame:Show()
	frame:ClearAllPoints()
	frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 40, 250)

	local configpanel = CreateFrame("FRAME", "AddonConfigFrameName");
	configpanel.name = "Necrosis"
	
	local category, layout = Settings.RegisterCanvasLayoutCategory(configpanel, configpanel.name, configpanel.name);
	category.ID = configpanel.name
	
	frame:SetScript("OnClick", function()
		Settings.OpenToCategory(category.ID);
		Settings.OpenToCategory(category.ID);

	end)


		--------------------------------------------
				-- Affichage des boutons cachés
		-------------------------------------------		
		frame = CreateFrame("CheckButton", "NecrosisHiddenButtons", NecrosisMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 40, 90)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				ShowUIPanel(NecrosisShadowTranceButton)
				ShowUIPanel(NecrosisBacklashButton)
				ShowUIPanel(NecrosisAntiFearButton)
				ShowUIPanel(NecrosisCreatureAlertButton_elemental)
				
				NecrosisCreatureAlertButton_elemental:SetAlpha(1)
				NecrosisCreatureAlertButton_demon:SetAlpha(1)
				NecrosisCreatureAlertButton_elemental:SetMovable(true)
				NecrosisCreatureAlertButton_demon:SetMovable(true)				

				
				NecrosisShadowTranceButton:RegisterForDrag("LeftButton")
				NecrosisBacklashButton:RegisterForDrag("LeftButton")
				NecrosisAntiFearButton:RegisterForDrag("LeftButton")
				NecrosisCreatureAlertButton_demon:RegisterForDrag("LeftButton")
				NecrosisCreatureAlertButton_elemental:RegisterForDrag("LeftButton")				
			
			else
				HideUIPanel(NecrosisShadowTranceButton)
				HideUIPanel(NecrosisBacklashButton)
				HideUIPanel(NecrosisAntiFearButton)
				HideUIPanel(NecrosisCreatureAlertButton_elemental)
				
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
		frame = CreateFrame("Slider", "NecrosisHiddenSize", NecrosisMiscConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(50, 200)
		frame:SetValueStep(5)
		frame:SetObeyStepOnDrag(true)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisMiscConfig, "BOTTOMLEFT", 225, 60)

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

end