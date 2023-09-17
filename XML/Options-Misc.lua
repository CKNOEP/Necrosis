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

		-- Déplacement des fragments
		frame = CreateFrame("CheckButton", "NecrosisMoveShard", NecrosisMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 25, 400)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.SoulshardSort = self:GetChecked()
			if NecrosisConfig.SoulshardSort then
				NecrosisMoveShardShardBag:Enable()
			else
				NecrosisMoveShardShardBag:Disable()
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Destruction des fragments quand le sac est plein
		--frame = CreateFrame("CheckButton", "NecrosisDestroyShardBag", NecrosisMiscConfig, "UICheckButtonTemplate")
		--frame:EnableMouse(true)
		--frame:SetWidth(24)
		--frame:SetHeight(24)
		--frame:Show()
		--frame:ClearAllPoints()
		--frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 50, 380)

		--frame:SetScript("OnClick", function(self) NecrosisConfig.SoulshardDestroy = self:GetChecked() end)

		--FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		--FontString:Show()
		--FontString:ClearAllPoints()
		--FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		--FontString:SetTextColor(1, 1, 1)
		--frame:SetFontString(FontString)
		--frame:SetDisabledTextColor(0.75, 0.75, 0.75)

		-- Choose the bag for storing soul shards || Choix du sac à fragments
		frame = CreateFrame("Slider", "NecrosisShardBag", NecrosisMiscConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(0, 4)
		frame:SetValueStep(1)
		frame:SetObeyStepOnDrag(true)
		frame:SetStepsPerPage(1)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisMiscConfig, "BOTTOMLEFT", 225, 340)

		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			local bagName = C_Container.GetBagName(5-math.floor(self:GetValue())-1);  
			if bagName then GameTooltip:SetText(bagName) end
		
		
		end)
		
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		
		frame:SetScript("OnMouseUp", function(self)
			local bagName = C_Container.GetBagName(5-math.floor(self:GetValue())-1);  
			GameTooltip:SetText(bagName)
			
			NecrosisConfig.SoulshardContainer = 4 - math.floor(self:GetValue())
			
			-- print(NecrosisConfig.SoulshardContainer)
			Necrosis:SoulshardSwitch("MOVE")
		end)
		
		frame:SetScript("OnValueChanged", function(self) 
		local bagName = C_Container.GetBagName(5-math.floor(self:GetValue())-1);  
		--GameTooltip:SetText(bagName)
		if bagName then GameTooltip:SetText(bagName) end
		
		end)

		NecrosisShardBagLow:SetText("Bag#5")
		NecrosisShardBagHigh:SetText("Bag#1")



		-- Set the number of shards to keep || Destruction des fragments après X
		frame = CreateFrame("CheckButton", "NecrosisDestroyShard", NecrosisMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 25, 280)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.DestroyShard = self:GetChecked()
			Necrosis:BagExplore()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		frame = CreateFrame("Slider", "NecrosisDestroyCount", NecrosisMiscConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(1, 32)
		frame:SetValueStep(1)
		frame:SetObeyStepOnDrag(true)
		frame:SetStepsPerPage(1)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisMiscConfig, "BOTTOMLEFT", 225, 255)

		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self:GetValue())
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnValueChanged", function(self) GameTooltip:SetText(math.floor(self:GetValue())) end)
		frame:SetScript("OnMouseUp", function(self)
			GameTooltip:SetText(self:GetValue())
			NecrosisConfig.DestroyCount = math.floor(self:GetValue())
			NecrosisDestroyShard:SetChecked(true)
			NecrosisConfig.DestroyShard = true
		end)

		NecrosisDestroyCountLow:SetText("1")
		NecrosisDestroyCountHigh:SetText("32")
--[[
		FontString = frame:CreateFontString(nil, nil, "ChatFontNormal")
		FontString:SetFont("Fonts\\ARIALN.TTF", 12)
		FontString:SetTextColor(1, 1, 1)
--]]
		-- Verrouillage de Necrosis
		frame = CreateFrame("CheckButton", "NecrosisLock", NecrosisMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 25, 225)

		frame:SetScript("OnClick", function(self)
			local ft = _G[Necrosis.Warlock_Buttons.trance.f]
			local fb = _G[Necrosis.Warlock_Buttons.backlash.f]
			local fa = _G[Necrosis.Warlock_Buttons.anti_fear.f]
			local fe = _G[Necrosis.Warlock_Buttons.elemental.f]
			local fd = _G[Necrosis.Warlock_Buttons.demon.f]	
			
			if (self:GetChecked()) then
				Necrosis:NoDrag()
				NecrosisButton:RegisterForDrag("")
				NecrosisSpellTimerButton:RegisterForDrag("")
				ft:RegisterForDrag("")
				fb:RegisterForDrag("")
				fa:RegisterForDrag("")
				fe:RegisterForDrag("")
				fd:RegisterForDrag("")			
				NecrosisConfig.NoDragAll = true
			else
				if not NecrosisConfig.NecrosisLockServ then
					Necrosis:Drag()
				end
				NecrosisButton:RegisterForDrag("LeftButton")
				NecrosisSpellTimerButton:RegisterForDrag("LeftButton")
				ft:RegisterForDrag("LeftButton")
				fb:RegisterForDrag("LeftButton")
				fa:RegisterForDrag("LeftButton")
				fe:RegisterForDrag("LeftButton")
				fd:RegisterForDrag("LeftButton")				
				NecrosisConfig.NoDragAll = false
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Affichage des boutons cachés
		frame = CreateFrame("CheckButton", "NecrosisHiddenButtons", NecrosisMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 25, 200)

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
		frame = CreateFrame("Slider", "NecrosisHiddenSize", NecrosisMiscConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(50, 200)
		frame:SetValueStep(5)
		frame:SetObeyStepOnDrag(true)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisMiscConfig, "BOTTOMLEFT", 225, 150)

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

	NecrosisMoveShard:SetChecked(NecrosisConfig.SoulshardSort)
	--NecrosisDestroyShardBag:SetChecked(NecrosisConfig.SoulshardDestroy)
	NecrosisShardBag:SetValue(4 - NecrosisConfig.SoulshardContainer)
	NecrosisDestroyShard:SetChecked(NecrosisConfig.DestroyShard)

	if NecrosisConfig.DestroyCount then
		NecrosisDestroyCount:SetValue(NecrosisConfig.DestroyCount)
	else
		NecrosisDestroyCount:SetValue(32)
	end

	NecrosisLock:SetChecked(NecrosisConfig.NoDragAll)
	NecrosisHiddenSize:SetValue(NecrosisConfig.ShadowTranceScale)

	NecrosisMoveShard:SetText(self.Config.Misc["Deplace les fragments"])
	--NecrosisDestroyShardBag:SetText(self.Config.Misc["Detruit les fragments si le sac plein"])
	NecrosisShardBagText:SetText(self.Config.Misc["Choix du sac contenant les fragments"])
	NecrosisDestroyShard:SetText(self.Config.Misc["Nombre maximum de fragments a conserver"])
	NecrosisLock:SetText(self.Config.Misc["Verrouiller Necrosis sur l'interface"])
	NecrosisHiddenButtons:SetText(self.Config.Misc["Afficher les boutons caches"])
	NecrosisHiddenSizeText:SetText(self.Config.Misc["Taille des boutons caches"])

	if NecrosisConfig.SoulshardSort then
		--NecrosisDestroyShardBag:Enable()
	else
		--NecrosisDestroyShardBag:Disable()
	end

	frame:Show()
end
