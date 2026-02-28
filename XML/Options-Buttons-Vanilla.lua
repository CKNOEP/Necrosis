--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

local NECROSIS_COMPANIONS_PER_PAGE = 12;
local NECROSIS_PAGE_NUMBER = "Page %s of %s";

------------------------------------------------------------------------------------------------------
-- CREATING THE FRAME OF THE OPTIONS || CREATION DE LA FRAME DES OPTIONS
------------------------------------------------------------------------------------------------------

--We create or display the configuration panel of the sphere ||  On crée ou on affiche le panneau de configuration de la sphere
function Necrosis:SetButtonsConfig()

	local frame = _G["NecrosisButtonsConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisButtonsConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Création de la sous-fenêtre 1
		frame = CreateFrame("Frame", "NecrosisButtonsConfig1", NecrosisButtonsConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")
		
		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 45, 80)
		FontString:SetText("1 / 2")

		FontString = frame:CreateFontString("NecrosisButtonsConfig1Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 45, 400)
		
		-- Boutons
		frame = CreateFrame("Button", nil, NecrosisButtonsConfig1, "UIPanelButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisButtonsConfig, "BOTTOMRIGHT", 120, 80)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig2:Show()
			NecrosisButtonsConfig1:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisButtonsConfig1, "UIPanelButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig, "BOTTOMLEFT", 40, 80)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig2:Show()
			NecrosisButtonsConfig1:Hide()
		end)
		
		-- Création de la sous-fenêtre 2
		frame = CreateFrame("Frame", "NecrosisButtonsConfig2", NecrosisButtonsConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Hide()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")
		
		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 45, 80)
		FontString:SetText("2 / 2")

		FontString = frame:CreateFontString("NecrosisButtonsConfig2Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 45, 400)
		
		-- Boutons
		frame = CreateFrame("Button", nil, NecrosisButtonsConfig2, "UIPanelButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisButtonsConfig, "BOTTOMRIGHT", 120, 80)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig1:Show()
			NecrosisButtonsConfig2:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisButtonsConfig2, "UIPanelButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig, "BOTTOMLEFT", 40, 80)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig1:Show()
			NecrosisButtonsConfig2:Hide()
		end)
		
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Sub Menu 1
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Attach or detach the necrosis buttons || Attache ou détache les boutons de Necrosis
		frame = CreateFrame("CheckButton", "NecrosisLockButtons", NecrosisButtonsConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig, "BOTTOMLEFT", 45, 395)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				NecrosisConfig.NecrosisLockServ = true
				Necrosis:ClearAllPoints()
				Necrosis:ButtonSetup()
				Necrosis:NoDrag()
				if not NecrosisConfig.NoDragAll then
					NecrosisButton:RegisterForDrag("LeftButton")
					NecrosisSpellTimerButton:RegisterForDrag("LeftButton")
				end
			else
				NecrosisConfig.NecrosisLockServ = false
				Necrosis:ClearAllPoints()
				local ButtonName = {
					Necrosis.Warlock_Buttons.fire_stone.f, --"NecrosisFirestoneButton",
					Necrosis.Warlock_Buttons.spell_stone.f, --"NecrosisSpellstoneButton",
					Necrosis.Warlock_Buttons.health_stone.f, --"NecrosisHealthstoneButton",
					Necrosis.Warlock_Buttons.soul_stone.f, --"NecrosisSoulstoneButton",
					Necrosis.Warlock_Buttons.buffs.f, --"NecrosisBuffMenuButton",
					Necrosis.Warlock_Buttons.mounts.f, --"NecrosisMountButton",
					Necrosis.Warlock_Buttons.pets.f, --"NecrosisPetMenuButton",
					Necrosis.Warlock_Buttons.curses.f, --"NecrosisCurseMenuButton"
					Necrosis.Warlock_Buttons.destroy_shards.f, --"NecrosisDestroyShardsButton"
				}
				local loc = {-121, -87, -53, -17, 17, 53, 87, 121, 155}
				for i in ipairs(ButtonName) do
					if _G[ButtonName[i]] then
						_G[ButtonName[i]]:SetPoint("CENTER", "UIParent", "CENTER", loc[i], -100)
						NecrosisConfig.FramePosition[ButtonName[i]] = {
							"CENTER",
							"UIParent",
							"CENTER",
							loc[i],
							-100
						}
					end
				end
				Necrosis:Drag()
				NecrosisConfig.NoDragAll = false
				NecrosisButton:RegisterForDrag("LeftButton")
				NecrosisSpellTimerButton:RegisterForDrag("LeftButton")
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

	-- Affiche ou cache les boutons autour de Necrosis


	-- Groupe 1: Boutons Pierres
	local boutons_pierres = {"Firestone", "Spellstone", "HealthStone", "Soulstone"}
	local firstCheckboxPierres = nil
	local initY_pierres = 340
	for i in ipairs(boutons_pierres) do
		frame = CreateFrame("CheckButton", "NecrosisShow"..boutons_pierres[i], NecrosisButtonsConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig, "BOTTOMLEFT", 45, initY_pierres - (25 * (i - 1)))
		if i == 1 then
			firstCheckboxPierres = frame
		end

		local globalIndex = i
		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				NecrosisConfig.StonePosition[globalIndex] = math.abs(NecrosisConfig.StonePosition[globalIndex])
			else
				NecrosisConfig.StonePosition[globalIndex] = - math.abs(NecrosisConfig.StonePosition[globalIndex])
			end
			Necrosis:ButtonSetup()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
	end

	-- Position header "Boutons Pierres" relative to first checkbox text
		local headerPierres = NecrosisButtonsConfig1:CreateFontString(nil, nil, "GameFontNormalSmall")
		headerPierres:Show()
		headerPierres:ClearAllPoints()
		headerPierres:SetPoint("LEFT", NecrosisButtonsConfig1, "BOTTOMLEFT", 74, 365)
		headerPierres:SetTextColor(1, 0.82, 0)
		headerPierres:SetText(self.Config.Buttons["Boutons Pierres"] or "Stone Buttons")


	-- Groupe 2: Boutons d'Action
	local boutons_action = {"BuffMenu", "Mount", "PetMenu", "CurseMenu", "DestroyShards"}
	local firstCheckboxAction = nil
	local initY_action = 205
	for i in ipairs(boutons_action) do
		frame = CreateFrame("CheckButton", "NecrosisShow"..boutons_action[i], NecrosisButtonsConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig, "BOTTOMLEFT", 45, initY_action - (25 * (i - 1)))
		if i == 1 then
			firstCheckboxAction = frame
		end

		local globalIndex = i + 4
		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				NecrosisConfig.StonePosition[globalIndex] = math.abs(NecrosisConfig.StonePosition[globalIndex])
			else
				NecrosisConfig.StonePosition[globalIndex] = - math.abs(NecrosisConfig.StonePosition[globalIndex])
			end

				Necrosis:ButtonSetup()
			end)

			FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
			FontString:Show()
			FontString:ClearAllPoints()
			FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
			FontString:SetTextColor(1, 1, 1)
			frame:SetFontString(FontString)
			if i == 1 then
				firstCheckboxActionText = FontString
			end
		end

	-- Position header "Boutons d'Action" relative to first checkbox text
		local headerAction = NecrosisButtonsConfig1:CreateFontString(nil, nil, "GameFontNormalSmall")
		headerAction:Show()
		headerAction:ClearAllPoints()
		headerAction:SetPoint("LEFT", NecrosisButtonsConfig1, "BOTTOMLEFT", 74, 230)
		headerAction:SetTextColor(1, 0.82, 0)
		headerAction:SetText(self.Config.Buttons["Boutons d'Action"] or "Action Buttons")

		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Sub Menu 2
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Create a slider control for rotating the buttons around the sphere || Création du slider de rotation de Necrosis
		-- lets create a hidden frame container for the mount selection buttons
		frame = CreateFrame("Frame", "NecrosisMountsSelectionFrame", NecrosisButtonsConfig2, "BackdropTemplate")
		frame:SetWidth(222);
		frame:SetHeight(75);
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisGeneralFrame, "CENTER", 0, -85)

		frame:SetBackdrop({	bgFile 		= "Interface/Tooltips/UI-Tooltip-Background",
	                      edgeFile 	= "Interface/Tooltips/UI-Tooltip-Border",
	                      tile 			= true, tileSize = 16, edgeSize = 16,
	                      insets 		= { left = 4, right = 4, top = 4, bottom = 4 }});
		frame:SetBackdropColor(0,0,0,1);

		-- create the navbar page info text
		local NecrosisCompanionPageNumber = frame:CreateFontString("NecrosisCompanionPageNumber", "OVERLAY", "GameFontNormalSmall")
		NecrosisCompanionPageNumber:Show()
		NecrosisCompanionPageNumber:ClearAllPoints()
		NecrosisCompanionPageNumber:SetPoint("TOP", NecrosisMountsSelectionFrame, "BOTTOM", 0, -10)
		NecrosisCompanionPageNumber:SetTextColor(1, 1, 1)
		NecrosisCompanionPageNumber:SetText("Page 1 of n")

		-- prev button
		frame = CreateFrame("Button", "NecrosisCompanionPrevButton", NecrosisButtonsConfig2)
		frame:SetWidth(32);
		frame:SetHeight(32);
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisCompanionPageNumber, "LEFT", -10, 0)
		frame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
		frame:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
		frame:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
		frame:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		frame:GetHighlightTexture():SetBlendMode("ADD")
		frame:SetScript("OnClick", function()
			 Necrosis:SetCompanionPage(NecrosisMountsSelectionFrame.pageMount - 1);
		end);

		-- next button
		frame = CreateFrame("Button", "NecrosisCompanionNextButton", NecrosisButtonsConfig2)
		frame:SetWidth(32);
		frame:SetHeight(32);
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisCompanionPageNumber, "RIGHT", 10, 0)
		frame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
		frame:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
		frame:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
		frame:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		frame:GetHighlightTexture():SetBlendMode("ADD")
		frame:SetScript("OnClick", function()
			 Necrosis:SetCompanionPage((NecrosisMountsSelectionFrame.pageMount or 0)+1);
		end);
		-- create 12 mount selection buttons in 2 rows of 6 buttons each
		for i=1,6 do
			frame = CreateFrame("CheckButton", "NecrosisCompanionButton"..i, NecrosisButtonsConfig2, "UICheckButtonTemplate")
			frame:SetID(i)
			frame:EnableMouse(true)
			frame:RegisterForDrag("LeftButton")
			frame:Show()
			frame:ClearAllPoints()
			frame:SetWidth(36)
			frame:SetHeight(36)
			if i == 1 then
				frame:SetPoint("TOPLEFT", NecrosisMountsSelectionFrame)
			else
				frame:SetPoint("LEFT", _G["NecrosisCompanionButton"..(i-1)], "RIGHT")
			end
			frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
			frame:SetScript("OnClick", nil)
			frame:SetScript("OnDragStart", NecrosisCompanionButton_OnDrag)
			frame:SetScript("OnReceiveDrag", nil)
		end

		for i=7,12 do
			frame = CreateFrame("CheckButton", "NecrosisCompanionButton"..i, NecrosisButtonsConfig2, "UICheckButtonTemplate")
			frame:SetID(i)
			frame:EnableMouse(true)
			frame:RegisterForDrag("LeftButton")
			frame:Show()
			frame:ClearAllPoints()
			frame:SetWidth(36)
			frame:SetHeight(36)
			if i == 7 then
				frame:SetPoint("BOTTOMLEFT", NecrosisMountsSelectionFrame)
			else
				frame:SetPoint("LEFT", _G["NecrosisCompanionButton"..(i-1)], "RIGHT")
			end
			frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
			frame:SetScript("OnClick", nil)
			frame:SetScript("OnDragStart", NecrosisCompanionButton_OnDrag)
			frame:SetScript("OnReceiveDrag", nil)
		end

		-- create the left/right mount containers which will hold the selected mounts
		frame = CreateFrame("CheckButton", "NecrosisSelectedMountLeft", NecrosisMountsSelectionFrame, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetWidth(36)
		frame:SetHeight(36)
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -60, 70)
		frame:SetScript("OnEnter", function(self) NecrosisSelectedMountButton_OnEnter(self, "left") end)
		frame:SetScript("OnClick", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)

		frame = CreateFrame("CheckButton", "NecrosisSelectedMountRight", NecrosisMountsSelectionFrame, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetWidth(36)
		frame:SetHeight(36)
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", 60, 70)
		frame:SetScript("OnEnter", function(self) NecrosisSelectedMountButton_OnEnter(self, "right") end)
		frame:SetScript("OnClick", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)

		frame = CreateFrame("CheckButton", "NecrosisSelectedMountCtrlLeft", NecrosisMountsSelectionFrame, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetWidth(36)
		frame:SetHeight(36)
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -60, 30)
		frame:SetScript("OnEnter", function(self) NecrosisSelectedMountButton_OnEnter(self, "ctrl-left") end)
		frame:SetScript("OnClick", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)

		frame = CreateFrame("CheckButton", "NecrosisSelectedMountCtrlRight", NecrosisMountsSelectionFrame, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetWidth(36)
		frame:SetHeight(36)
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", 60, 30)
		frame:SetScript("OnEnter", function(self) NecrosisSelectedMountButton_OnEnter(self, "ctrl-right") end)
		frame:SetScript("OnClick", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)

	end

	-- the frame is created, so set some defaults
	-- NecrosisMountsSelectionFrame.idMount = GetCompanionInfo("MOUNT", 1); //TODO broke ?
	--   SetCompanionInfo is a API add in game on WOTLK
	-- set to 1st page
	Necrosis:SetCompanionPage(0)

	-- make sure our mount buttons are updated
	
	
	-- the spellID's (not creatureID's) for the selected left & right mounts are stored in savedvariables
	-- if nothing is specified (empty / reset config) then use felsteed (5784) and dreadsteed (23161) as the default spellids
	
	--print("mounts ",NecrosisConfig.LeftMount,NecrosisConfig.RightMount)
	
	if (NecrosisConfig.LeftMount) then
		NecrosisInitSelectedMountButton(NecrosisSelectedMountLeft, NecrosisConfig.LeftMount);
	else
		NecrosisInitSelectedMountButton(NecrosisSelectedMountLeft, 5784);
	end
	
	if (NecrosisConfig.RightMount) then
		NecrosisInitSelectedMountButton(NecrosisSelectedMountRight, NecrosisConfig.RightMount);
	else
		NecrosisInitSelectedMountButton(NecrosisSelectedMountRight, 23161);
	end

	--Set the value save in savedvariables - Use C_MountJournal for mount icons

	-- Helper function to get mount icon by spellID
	local function GetMountIcon(spellID)
		if not spellID or spellID == nil then
			return GetItemIcon(132238)  -- Default icon
		end
		-- Try to find the mount by iterating through available mounts
		local totalMounts = C_MountJournal.GetNumDisplayedMounts()
		for i = 1, totalMounts do
			local creatureID, mountSpellID, icon = C_MountJournal.GetDisplayedMountInfo(i)
			if mountSpellID == spellID then
				return icon
			end
		end
		-- Fallback: return default icon
		return GetItemIcon(132238)
	end

	LM = GetMountIcon(NecrosisConfig.LeftMount)
	RM = GetMountIcon(NecrosisConfig.RightMount)
	CTRL_LM = GetMountIcon(NecrosisConfig.CtrlLeftMount)
	CTRL_RM = GetMountIcon(NecrosisConfig.CtrlRightMount)	
	
	Necrosis:UpdateMountButtons()
	--print(LM,RM,CTRL_LM,CTRL_RM)
	
	if LM then NecrosisSelectedMountLeft:SetNormalTexture(LM) end
	if RM then NecrosisSelectedMountRight:SetNormalTexture(RM) end
	if CTRL_LM then NecrosisSelectedMountCtrlLeft:SetNormalTexture(CTRL_LM) end
	if CTRL_RM then NecrosisSelectedMountCtrlRight:SetNormalTexture(CTRL_RM) end

	NecrosisLockButtons:SetChecked(NecrosisConfig.NecrosisLockServ)


	local boutons = {"Firestone", "Spellstone", "HealthStone", "Soulstone", "BuffMenu", "Mount", "PetMenu", "CurseMenu","DestroyShards"}
	for i in ipairs(boutons) do
		_G["NecrosisShow"..boutons[i]]:SetChecked(NecrosisConfig.StonePosition[i] > 0)
		_G["NecrosisShow"..boutons[i]]:SetText(self.Config.Buttons.Name[i])
	end

	NecrosisButtonsConfig1Text:SetText(self.Config.Buttons["Choix des boutons a afficher"])
	NecrosisButtonsConfig2Text:SetText(self.Config.Menus["Options Generales"])
	NecrosisLockButtons:SetText(self.Config.Buttons["Fixer les boutons autour de la sphere"])

	local frame = _G["NecrosisButtonsConfig"]
	frame:Show()
end

------------------------------------------------------------------------------------------------------
-- MOUNT FUNCTIONS
------------------------------------------------------------------------------------------------------
function Necrosis:SetCompanionPage(num)
	NecrosisMountsSelectionFrame.pageMount = num;
	
	num = num + 1;	--For easier usage
	-- local maxpage = ceil(GetNumCompanions("MOUNT")/NECROSIS_COMPANIONS_PER_PAGE);
	local maxpage = 1 

	NecrosisCompanionPageNumber:SetFormattedText(NECROSIS_PAGE_NUMBER, num, maxpage);
	
	if ( num <= 1 ) then
		NecrosisCompanionPrevButton:Disable();
	else
		NecrosisCompanionPrevButton:Enable();
	end
	
	if ( num >= maxpage ) then
		NecrosisCompanionNextButton:Disable();
	else
		NecrosisCompanionNextButton:Enable();
	end
	
	Necrosis:UpdateMountButtons();
	--PetPaperDollFrame_UpdateCompanionCooldowns();
end

function Necrosis:UpdateMountButtons()
	local button, iconTexture, id;
	local creatureID, creatureName, spellID, icon, active;
	local offset, selected;

	offset = (NecrosisMountsSelectionFrame.pageMount or 0)*NECROSIS_COMPANIONS_PER_PAGE;
	
	selected = FindCompanionIndex(NecrosisMountsSelectionFrame.idMount);
	
	
	if ( selected > 0 ) then
		creatureID, creatureName, spellID, icon, active = GetCompanionInfo("MOUNT", selected);

	end
end

function FindCompanionIndex(creatureID, mode)
	return 0
end


function NecrosisCompanionButton_OnDrag(self)
	local offset = (NecrosisMountsSelectionFrame.pageMount or 0) * NECROSIS_COMPANIONS_PER_PAGE;
	local dragged = self:GetID() + offset;
	PickupCompanion("MOUNT", dragged );
end

function NecrosisCompanionButton_OnEnter(self)
	if ( GetCVar("UberTooltips") == "1" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	end

	if (self.spellID) then
		if ( GameTooltip:SetHyperlink("spell:"..self.spellID) ) then
			self.UpdateTooltip = NecrosisCompanionButton_OnEnter;
		else
			self.UpdateTooltip = nil;
		end
	end
	GameTooltip:Show()
end


function isMount(self)
	
	

	if self then
	
	local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent
    = GetItemInfo(self) 
	
	
	local spellName, spellID = GetItemSpell(self)
	
	if classID == 15 then -- == Test is Mout
		if  subclassID == 5 then
			return true
		else
			return false
			
		end
		return false
	else
	return false
	end
	
	end
end


function NecrosisInitSelectedMountButton(button, id)
	if id then
		local name, spellID, icon, isActive, isUsable = C_MountJournal.GetMountInfoByID(id)
		if name then
			button.creatureID = name
			button.spellID = spellID
			button.active = isActive
			if icon then
				button:SetNormalTexture(icon)
				button:Enable()
			end
		end
	end
end

function FindCompanionIndex(creatureID)
	local offset = (NecrosisMountsSelectionFrame.pageMount or 0) * NECROSIS_COMPANIONS_PER_PAGE
	for i = 1, NECROSIS_COMPANIONS_PER_PAGE do
		local id = i + offset
		local name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID = C_MountJournal.GetDisplayedMountInfo(id)
		if name == creatureID then
			return id
		end
	end
	return 0
end

function Necrosis:SetCompanionPage(num)
	if not num or num < 0 then
		num = 0
	end

	C_MountJournal.SetAllTypeFilters(true)
	C_MountJournal.SetCollectedFilterSetting(1, true)
	C_MountJournal.SetCollectedFilterSetting(2, false)

	local maxpage = ceil(C_MountJournal.GetNumDisplayedMounts() / NECROSIS_COMPANIONS_PER_PAGE);
	if num >= maxpage then
		num = maxpage - 1
	end

	NecrosisMountsSelectionFrame.pageMount = num
	NecrosisCompanionPageNumber:SetFormattedText(NECROSIS_PAGE_NUMBER, num + 1, maxpage);

	if (num <= 0) then
		NecrosisCompanionPrevButton:Disable();
	else
		NecrosisCompanionPrevButton:Enable();
	end

	if (num >= maxpage - 1) then
		NecrosisCompanionNextButton:Disable();
	else
		NecrosisCompanionNextButton:Enable();
	end

	self:UpdateMountButtons();
end

function Necrosis:UpdateMountButtons()
	local button, id
	local name, spellID, icon, isActive, isUsable
	local offset = (NecrosisMountsSelectionFrame.pageMount or 0) * NECROSIS_COMPANIONS_PER_PAGE

	for i = 1, NECROSIS_COMPANIONS_PER_PAGE do
		button = _G["NecrosisCompanionButton"..i]
		id = i + offset
		name, spellID, icon, isActive, isUsable = C_MountJournal.GetDisplayedMountInfo(id)

		button.creatureID = name
		button.spellID = spellID

		if (name) then
			button:SetNormalTexture(icon)
			button:Enable()
			if isActive then
				button:SetChecked(true)
			else
				button:SetChecked(false)
			end
		else
			button:Disable()
			button:SetChecked(false)
		end
	end
end

function NecrosisCompanionButton_OnDrag(self)
	-- Store the mount being dragged for use in OnReceiveDrag
	NecrosisDraggedMount = {
		spellID = self.spellID,
		creatureID = self.creatureID
	}
	local offset = (NecrosisMountsSelectionFrame.pageMount or 0) * NECROSIS_COMPANIONS_PER_PAGE
	local dragged = self:GetID() + offset
	PickupCompanion("MOUNT", dragged)
end

function NecrosisCompanionButton_OnEnter(self)
	if (GetCVar("UberTooltips") == "1") then
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	end
	if (self.spellID) then
		if (GameTooltip:SetHyperlink("spell:"..self.spellID)) then
			self.UpdateTooltip = NecrosisCompanionButton_OnEnter;
		else
			self.UpdateTooltip = nil;
		end
	end
	GameTooltip:Show()
end

function NecrosisSelectedMountButton_OnEnter(self, buttonType)
	if (GetCVar("UberTooltips") == "1") then
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
	else
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR", -20, -30);
	end

	-- Display action and drag/drop instruction
	local actionText = ""
	if buttonType == "left" then
		actionText = "Clic gauche"
	elseif buttonType == "right" then
		actionText = "Clic droit"
	elseif buttonType == "ctrl-left" then
		actionText = "Ctrl + Clic gauche"
	elseif buttonType == "ctrl-right" then
		actionText = "Ctrl + Clic droit"
	end

	GameTooltip:AddLine("|cFFFFFFFFAssignation de monture|r")
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("|cFFFFC400Action:|r " .. actionText)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("|cFF00FF00Glissez-déposez une monture|r")
	GameTooltip:AddLine("|cFF00FF00depuis la grille ci-dessus|r")

	if (self.spellID) then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cFFFFFFFFMonture assignée:|r")
		if (GameTooltip:SetHyperlink("spell:"..self.spellID)) then
			self.UpdateTooltip = function(self) NecrosisSelectedMountButton_OnEnter(self, buttonType) end
		else
			self.UpdateTooltip = nil;
		end
	end

	GameTooltip:Show()
end

function NecrosisSelectedMountButton_OnReceiveDrag(self)
	local infoType, info1, info2 = GetCursorInfo();

	if (infoType == "companion") and NecrosisDraggedMount then
		local spellID = NecrosisDraggedMount.spellID
		local creatureID = NecrosisDraggedMount.creatureID

		if spellID then
			-- Get the full mount info to get the icon
			local icon = nil
			local totalMounts = C_MountJournal.GetNumDisplayedMounts()
			for i = 1, totalMounts do
				local mountCreatureID, mountSpellID, mountIcon = C_MountJournal.GetDisplayedMountInfo(i)
				if mountSpellID == spellID then
					icon = mountIcon
					break
				end
			end

			local button = self

			if (button == NecrosisSelectedMountLeft) then
				NecrosisConfig.LeftMount = spellID;
			elseif (button == NecrosisSelectedMountRight) then
				NecrosisConfig.RightMount = spellID;
			elseif (button == NecrosisSelectedMountCtrlLeft) then
				NecrosisConfig.CtrlLeftMount = spellID;
			elseif (button == NecrosisSelectedMountCtrlRight) then
				NecrosisConfig.CtrlRightMount = spellID;
			end

			button.creatureID = creatureID
			button.spellID = spellID

			if (icon) then
				button:SetNormalTexture(icon)
				button:Enable()
			else
				button:Disable()
			end

			Necrosis:StoneAttribute("Own")
		end
	end
	ClearCursor()
	NecrosisDraggedMount = nil
end
