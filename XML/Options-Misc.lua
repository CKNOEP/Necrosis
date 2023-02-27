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

	frame:Show()
end
