--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)
local AddonName, SAO = ...
local iamNecrosis = strlower(AddonName):sub(0,8) == "necrosis"

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
		
		--------------------------------------
		-- Déplacement des fragments
		--------------------------------------
			
		frame = CreateFrame("CheckButton", "NecrosisMoveShard", NecrosisMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 40, 360)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.SoulshardSort = self:GetChecked()
			
			if NecrosisConfig.SoulshardSort then
				--NecrosisMoveShard:SetChecked("true")
			else
				--NecrosisMoveShard:SetChecked("false")
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- MESSSAGE INFORMATION--
		local Glow = NecrosisMiscConfig:CreateFontString(nil, nil, "GameFontHighlightSmall")
		Glow:SetWidth(365)
		Glow:SetJustifyH('LEFT')
		Glow:SetJustifyV('TOP')
		Glow:SetNonSpaceWrap("  ")
		Glow:SetMaxLines(4)
		Glow:SetWordWrap(true)
		Glow:Show()
		Glow:ClearAllPoints()
		Glow:SetPoint("LEFT", frame, "TOPLEFT" , 40, 25 )
		Glow:SetTextColor(1, 0.5, 0)
		Glow:SetText("Unfortunately with TBC, Blizzard has decided to remove    the ability for addons to automatically delete shards.    "..
		"auto-sorting after combat is no longer supported.  "..
		"Now use shard button to manage Shards")
	
		
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

		----------------------------------------------------------------------
		-- Choose the bag for storing soul shards || Choix du sac à fragments
		----------------------------------------------------------------------
		frame = CreateFrame("Slider", "NecrosisShardBag", NecrosisMiscConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(0, 4)
		frame:SetValueStep(1)
		frame:SetObeyStepOnDrag(true)
		frame:SetStepsPerPage(1)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisMiscConfig, "BOTTOMLEFT", 225, 320)

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
			--Count the Shard to move a loop 
			
			for i=1, GetItemCount(Necrosis.Warlock_Lists.reagents.soul_shard.id) do
			--print ("Move Shard ",i," to ", GetItemCount(Necrosis.Warlock_Lists.reagents.soul_shard.id))
			Necrosis:SoulshardSwitch("MOVE")
			end
		
		end)
		
		frame:SetScript("OnValueChanged", function(self) 
		local bagName = C_Container.GetBagName(5-math.floor(self:GetValue())-1);  
		if bagName then GameTooltip:SetText(bagName) end
		
		
		end)

		NecrosisShardBagLow:SetText("Bag#5")
		NecrosisShardBagHigh:SetText("Bag#1")

		-- Boutons oVERLAY
			frame = CreateFrame("Button", nil, NecrosisMiscConfig, "UIPanelButtonTemplate")
			frame:SetText("Open Options SpellOverlay")
			frame:SetSize(200 ,22) -- width, height
			frame:EnableMouse(true)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 40, 200)
--
			local configpanel = CreateFrame("FRAME", "AddonConfigFrameName");
			configpanel.name = "Necrosis"
			
			local category, layout = Settings.RegisterCanvasLayoutCategory(configpanel, configpanel.name, configpanel.name);
			category.ID = configpanel.name
			
			frame:SetScript("OnClick", function()
				Settings.OpenToCategory(category.ID);
				Settings.OpenToCategory(category.ID);
			end)

		-- Set the number of shards to keep || Destruction des fragments après X
		frame = CreateFrame("CheckButton", "NecrosisDestroyShard", NecrosisMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 40, 280)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.DestroyShard = self:GetChecked()

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
			
			Necrosis:BagExplore()
		end)

		NecrosisDestroyCountLow:SetText("1")
		NecrosisDestroyCountHigh:SetText("32")
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
		frame:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 40, 220)

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
		

		
	

	NecrosisMoveShard:SetChecked(NecrosisConfig.SoulshardSort)
	--NecrosisDestroyShardBag:SetChecked(NecrosisConfig.SoulshardDestroy)
	NecrosisShardBag:SetValue(4 - NecrosisConfig.SoulshardContainer)
	NecrosisDestroyShard:SetChecked(NecrosisConfig.DestroyShard)
	NecrosisAFK:SetChecked(NecrosisConfig.AFK)
	
	if NecrosisConfig.DestroyCount then
		NecrosisDestroyCount:SetValue(NecrosisConfig.DestroyCount)
		
	else
		NecrosisDestroyCount:SetValue(32)
	end

	
	
	NecrosisMoveShard:SetText(self.Config.Misc["Deplace les fragments"])
	--NecrosisDestroyShardBag:SetText(self.Config.Misc["Detruit les fragments si le sac plein"])--deprecated
	NecrosisShardBagText:SetText(self.Config.Misc["Choix du sac contenant les fragments"])
	NecrosisDestroyShard:SetText(self.Config.Misc["Nombre maximum de fragments a conserver"])
	NecrosisAFK:SetText("AFK Screen")


	if NecrosisConfig.SoulshardSort then --See Necrosis:SoulshardSwitch("MOVE")
		--NecrosisDestroyShardBag:Enable()
	else
		--NecrosisDestroyShardBag:Disable()
	end

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
	


	
	-- Test Button SAO
	
	
	-- Boutons test oVERLAY
	testButton = CreateFrame("Button", nil, NecrosisMiscConfig, "UIPanelButtonTemplate")
	testButton:SetText("Test Overlay")
	testButton:SetSize(120 ,22) -- width, height
	testButton:EnableMouse(true)
	testButton:Show()
	testButton:ClearAllPoints()
	testButton:SetPoint("LEFT", NecrosisMiscConfig, "BOTTOMLEFT", 250, 200)
	--
	
    testButton.fakeSpellID = 42;
    testButton.isTesting = false;
    local testTextureLeftRight = SAO.IsEra() and "nightfall";
    local testTextureTop = SAO.IsEra() and  "backlash";
    local testPositionTop = SAO.IsCata() and "Top (CW)" or "Top";
	local testButtonStatus = NecrosisSpellActivationOverlayOptionsPanelSpellAlertTestButton;
	
	testButton:SetScript("OnMouseUp", function(self)

		--print ("test",self,self.isTesting)
		
		if  self.isTesting == false then
            self.isTesting = true;
            SAO:ActivateOverlay(0, self.fakeSpellID, SAO.TexName[testTextureLeftRight], "Left + Right (Flipped)", 1, 255, 255, 255, false, nil, GetTime()+5, false);
            SAO:ActivateOverlay(0, self.fakeSpellID, SAO.TexName[testTextureTop], testPositionTop, 1, 255, 255, 255, false, nil, GetTime()+5, false);
            self.testTimerTicker = C_Timer.NewTicker(4.9, -- Ticker must be slightly shorter than overlay duration, to refresh it before losing it
            function()
               -- print("timer",self.fakeSpellID, GetTime()+5);
				SAO:RefreshOverlayTimer(self.fakeSpellID, GetTime()+5);
            end);
            -- Hack the frame to force full opacity even when out of combat
            NecrosisSpellActivationOverlayFrame_SetForceAlpha1(true);
		else
            self.isTesting = false;
            self.testTimerTicker:Cancel();
            SAO:DeactivateOverlay(self.fakeSpellID);
            -- Undo hack
            NecrosisSpellActivationOverlayFrame_SetForceAlpha1(false);
        end
     
 
	
	end)	
	
	testButton:SetScript("OnLeave", function(self)
			self.isTesting = false;
            self.testTimerTicker:Cancel();
            SAO:DeactivateOverlay(self.fakeSpellID);
            -- Undo hack
            NecrosisSpellActivationOverlayFrame_SetForceAlpha1(false);
 	
	end)
	
	end
	
	NecrosisHiddenButtons:SetText(self.Config.Misc["Afficher les boutons caches"])
	NecrosisHiddenSizeText:SetText(self.Config.Misc["Taille des boutons caches"])
	NecrosisHiddenSize:SetValue(NecrosisConfig.ShadowTranceScale)
	
	
	frame:Show()
end
