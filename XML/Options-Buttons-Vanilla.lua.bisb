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
		frame:SetAllPoints(NecrosisButtonsConfig)
		
		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 130)
		FontString:SetText("1 / 2")

		FontString = frame:CreateFontString("NecrosisButtonsConfig1Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 420)
		
		-- Boutons
		frame = CreateFrame("Button", nil, NecrosisButtonsConfig1, "UIPanelButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisButtonsConfig1, "BOTTOMRIGHT", 40, 135)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig2:Show()
			NecrosisButtonsConfig1:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisButtonsConfig1, "UIPanelButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig1, "BOTTOMLEFT", 40, 135)

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
		frame:SetAllPoints(NecrosisButtonsConfig)
		
		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 130)
		FontString:SetText("2 / 2")

		FontString = frame:CreateFontString("NecrosisButtonsConfig2Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 420)
		
		-- Boutons
		frame = CreateFrame("Button", nil, NecrosisButtonsConfig2, "UIPanelButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisButtonsConfig2, "BOTTOMRIGHT", 40, 135)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig1:Show()
			NecrosisButtonsConfig2:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisButtonsConfig2, "UIPanelButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig2, "BOTTOMLEFT", 40, 135)

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
		frame:SetPoint("LEFT", NecrosisButtonsConfig1, "BOTTOMLEFT", 25, 395)

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
		local boutons = {"Firestone", "Spellstone", "HealthStone", "Soulstone", "BuffMenu", "Mount", "PetMenu", "CurseMenu","DestroyShards"}
		local initY = 380
		for i in ipairs(boutons) do
			frame = CreateFrame("CheckButton", "NecrosisShow"..boutons[i], NecrosisButtonsConfig1, "UICheckButtonTemplate")
			frame:EnableMouse(true)
			frame:SetWidth(24)
			frame:SetHeight(24)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", NecrosisButtonsConfig1, "BOTTOMLEFT", 25, initY - (25 * i))

			frame:SetScript("OnClick", function(self)
				if (self:GetChecked()) then
					NecrosisConfig.StonePosition[i] = math.abs(NecrosisConfig.StonePosition[i])
				else
					NecrosisConfig.StonePosition[i] = - math.abs(NecrosisConfig.StonePosition[i])
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

		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Sub Menu 2
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Create a slider control for rotating the buttons around the sphere || Création du slider de rotation de Necrosis
		frame = CreateFrame("Slider", "NecrosisRotation", NecrosisButtonsConfig2, "OptionsSliderTemplate")
		frame:SetMinMaxValues(0, 360)
		frame:SetValueStep(5)
		frame:SetObeyStepOnDrag(true)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisButtonsConfig2, "BOTTOMLEFT", 225, 380)

		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self:GetValue())
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnValueChanged", function(self)
			NecrosisConfig.NecrosisAngle = self:GetValue()
			GameTooltip:SetText(self:GetValue())
			Necrosis:ButtonSetup()
		end)

		NecrosisRotationLow:SetText("0")
		NecrosisRotationHigh:SetText("360")

		-- lets create a hidden frame container for the mount selection buttons
		frame = CreateFrame("Frame", "NecrosisMountsSelectionFrame", NecrosisButtonsConfig2, BackdropTemplateMixin and "BackdropTemplate")
		frame:SetWidth(200);
		frame:SetHeight(75);
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisGeneralFrame, "CENTER", 0, -25)

		--frame:SetBackdrop({	bgFile 		= "Interface/Tooltips/UI-Tooltip-Background", 
	    --                  edgeFile 	= "Interface/Tooltips/UI-Tooltip-Border", 
	    --                  tile 			= true, tileSize = 16, edgeSize = 16, 
	    --                  insets 		= { left = 4, right = 4, top = 4, bottom = 4 }});
		frame:SetBackdropColor(0,0,0,1);

		-- create the navbar page info text


		
		-- create the left/right mount containers which will hold the selected mounts
		frame = CreateFrame("Button", "NecrosisSelectedMountLeft", NecrosisMountsSelectionFrame, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame.Tooltip="Drag and Drop your mount here";
		
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, 10)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
		frame:SetScript("OnClick", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)
		-- Boutons reset
		button = CreateFrame("Button", "ResetMountLeft", NecrosisMountsSelectionFrame,"UIPanelButtonTemplate")
		button:SetText("Reset")
		button:EnableMouse(true)
		button:Show()
		button:ClearAllPoints()
		button:SetPoint("RIGHT", NecrosisSelectedMountLeft, "RIGHT", 70, 0)
		button:SetWidth(70)
        button:SetHeight(17)
		button:SetScript("OnClick", function()
			NecrosisSelectedMountLeft:SetNormalTexture(132238)
			NecrosisInitSelectedMountButton(NecrosisSelectedMountLeft, 23161);
			NecrosisConfig.LeftMount = 23161;
			Necrosis:StoneAttribute(true)
		end)		
	
		frame = CreateFrame("Button", "NecrosisSelectedMountRight", NecrosisMountsSelectionFrame, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, -25)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
		frame:SetScript("OnClick", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)
		-- Boutons reset
		button = CreateFrame("Button", "ResetMountRight", NecrosisMountsSelectionFrame,"UIPanelButtonTemplate")
		button:SetText("Reset")
		button:EnableMouse(true)
		button:Show()
		button:ClearAllPoints()
		button:SetPoint("RIGHT", NecrosisSelectedMountRight, "RIGHT", 70, 0)
		button:SetWidth(70)
        button:SetHeight(17)
		button:SetScript("OnClick", function()
			NecrosisSelectedMountRight:SetNormalTexture(132238)
			NecrosisInitSelectedMountButton(NecrosisSelectedMountRight, 5784);
			NecrosisConfig.RightMount = 5784;
			Necrosis:StoneAttribute(true)
		end)
			
		frame = CreateFrame("Button", "NecrosisSelectedMountCtrlLeft", NecrosisMountsSelectionFrame, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, -60)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
		frame:SetScript("OnClick", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)
	-- Boutons reset
		button = CreateFrame("Button", "ResetMountCtrlLeft", NecrosisMountsSelectionFrame,"UIPanelButtonTemplate")
		button:SetText("Reset")
		button:EnableMouse(true)
		button:Show()
		button:ClearAllPoints()
		button:SetPoint("RIGHT", NecrosisSelectedMountCtrlLeft, "RIGHT", 70, 0)
		button:SetWidth(70)
        button:SetHeight(17)
		button:SetScript("OnClick", function()
			NecrosisSelectedMountCtrlLeft:SetNormalTexture(132238)
			NecrosisInitSelectedMountButton(NecrosisSelectedMountCtrlLeft, 23161);
			NecrosisConfig.CtrlLeftMount = 23161;
			Necrosis:StoneAttribute(true)
		end)	

		
		frame = CreateFrame("Button", "NecrosisSelectedMountCtrlRight", NecrosisMountsSelectionFrame, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, -95)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
		frame:SetScript("OnClick", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)
		-- Boutons reset
		button = CreateFrame("Button", "ResetMountCtrlRight", NecrosisMountsSelectionFrame,"UIPanelButtonTemplate")
		button:SetText("Reset")
		button:EnableMouse(true)
		button:Show()
		button:ClearAllPoints()
		button:SetPoint("RIGHT", NecrosisSelectedMountCtrlRight, "RIGHT", 70, 0)
		button:SetWidth(70)
        button:SetHeight(17)
		button:SetScript("OnClick", function()
			NecrosisSelectedMountCtrlRight:SetNormalTexture(132238)
			NecrosisInitSelectedMountButton(NecrosisSelectedMountCtrlRight, 23161);
			NecrosisConfig.CtrlRightMount = 23161;
			Necrosis:StoneAttribute(true)
		end)
		
		--Text Frame/button Mount
		local FontString = frame:CreateFontString("NecrosisChooseMountsText", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", 0, 50)
		FontString:SetTextColor(1, 1, 1)
		--TODO: translate this
		FontString:SetText("Select your mounts: drag and drop the Mout \r into the frame to bind it");
		
		local FontString = frame:CreateFontString("NecrosisLeftMountText", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("RIGHT", NecrosisSelectedMountLeft, "LEFT", -10, 0)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(self.Config.Buttons["Monture - Clic gauche"])

		local FontString = frame:CreateFontString("NecrosisRightMountText", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("RIGHT", NecrosisSelectedMountRight, "LEFT", -10, 0)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(self.Config.Buttons["Monture - Clic droit"])
		
		local FontString = frame:CreateFontString("NecrosisCtrlLeftMountText", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("RIGHT", NecrosisSelectedMountCtrlLeft, "LEFT", -10, 0)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(self.Config.Buttons["Monture - Ctrl+Clic gauche"])

		local FontString = frame:CreateFontString("NecrosisCtrlRightMountText", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("RIGHT", NecrosisSelectedMountCtrlRight, "LEFT", -10, 0)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(self.Config.Buttons["Monture - Ctrl+Clic droit"])		
	end
	
	-- the frame is created, so set some defaults
	-- NecrosisMountsSelectionFrame.idMount = GetCompanionInfo("MOUNT", 1); //TODO broke ? 
	--   SetCompanionInfo is a API add in game on WOTLK
	-- set to 1st page
	--Necrosis:SetCompanionPage(0)

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

	--Set the value save in savedvariables
	
	
	if NecrosisConfig.LeftMount ==23161 or NecrosisConfig.LeftMount ==5784  or NecrosisConfig.LeftMount == nil then 
	LM = 132238 
	else
	name, _, _, _, _, _, _, _, _,LM = GetItemInfo(NecrosisConfig.LeftMount)
	end
	
	
	if NecrosisConfig.RightMount ==23161 or NecrosisConfig.RightMount ==5784 or NecrosisConfig.RightMount == nil then 
	RM = 132238
	else
	name, _, _, _, _, _, _, _, _,RM = GetItemInfo(NecrosisConfig.RightMount)
	end
	
	
	if NecrosisConfig.CtrlRightMount ==23161 or NecrosisConfig.CtrlRightMount ==5784 or NecrosisConfig.CtrlRightMount == nil then 
	CTRL_LM = 132238
	else
	name, _, _, _, _, _, _, _, _,CTRL_LM = GetItemInfo(NecrosisConfig.CtrlLeftMount)
	--print(NecrosisConfig.CtrlLeftMount,CTRL_LM)
	end
	
	
	if NecrosisConfig.CtrlRightMount ==23161 or NecrosisConfig.CtrlRightMount ==5784 or NecrosisConfig.CtrlRightMount == nil then
	CTRL_RM = 132238
	else
	name, _, _, _, _, _, _, _, _,CTRL_RM = GetItemInfo(NecrosisConfig.CtrlRightMount)
	end	
	
	Necrosis:UpdateMountButtons()
	--print(LM,RM,CTRL_LM,CTRL_RM)
	
	NecrosisSelectedMountLeft:SetNormalTexture(LM);
	NecrosisSelectedMountRight:SetNormalTexture(RM);
	NecrosisSelectedMountCtrlLeft:SetNormalTexture(CTRL_LM);
	NecrosisSelectedMountCtrlRight:SetNormalTexture(CTRL_RM);
	
	NecrosisRotation:SetValue(NecrosisConfig.NecrosisAngle)
	NecrosisLockButtons:SetChecked(NecrosisConfig.NecrosisLockServ)


	local boutons = {"Firestone", "Spellstone", "HealthStone", "Soulstone", "BuffMenu", "Mount", "PetMenu", "CurseMenu","DestroyShards"}
	for i in ipairs(boutons) do
		_G["NecrosisShow"..boutons[i]]:SetChecked(NecrosisConfig.StonePosition[i] > 0)
		_G["NecrosisShow"..boutons[i]]:SetText(self.Config.Buttons.Name[i])
	end

	NecrosisButtonsConfig1Text:SetText(self.Config.Buttons["Choix des boutons a afficher"])
	NecrosisButtonsConfig2Text:SetText(self.Config.Menus["Options Generales"])
	NecrosisRotationText:SetText(self.Config.Buttons["Rotation des boutons"])
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

function NecrosisSelectedMountButton_OnReceiveDrag(self)
	
	
	
	
	local infoType, info1, info2 = GetCursorInfo();
	local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent
   = GetItemInfo(info1) 
	
	local spellName, spellID = GetItemSpell(info2)
	
	if classID == 15 then -- == Test is Mout
		if  subclassID == 5 then
			
			infoType = "companion"
		end

	end
	
	
	if (infoType == "companion") then
		-- info1 contains the mount index 
		-- info2 contains the companion type, e.g. "MOUNT" or "CRITTER"
	  --local creatureID, creatureName, spellID, icon, active = GetCompanionInfo("MOUNT", info1);
		local creatureID=info2 
		local creatureName=itemName 
		local spellID=spellID
		local icon=itemTexture
		local active=true
		
		local button = _G[self:GetName()];
		
		-- a mount was dragged to the left/right selected mount button boxes, so save the spellID to savedvariables
		-- note: 
		--   using spellID because the API GetSpellInfo() will always return the correctly localised creature name.
		--   The creatureID cannot be used because the API GetCompanionInfo() does not always return the correctly localised creature name.
		if (button == NecrosisSelectedMountLeft) then
			NecrosisConfig.LeftMount = creatureID;
		end
		if (button == NecrosisSelectedMountRight) then
			NecrosisConfig.RightMount = creatureID;
		end
		if (button == NecrosisSelectedMountCtrlLeft) then
			NecrosisConfig.CtrlLeftMount = creatureID;
		end
		if (button == NecrosisSelectedMountCtrlRight) then
			NecrosisConfig.CtrlRightMount = creatureID;
		end		
		
		
		
		
		button.creatureID = creatureID;
		button.creatureName = creatureName;
		button.spellID = spellID;
		button.active = active;
		
		if ( creatureID ) then
			button:SetNormalTexture(icon);
			button:Enable();
		else
			button:Disable();
		end
		
		if ( active ) then
			--_G[self:GetName().."ActiveTexture"]:Show();
		else
			--_G[self:GetName().."ActiveTexture"]:Hide();
		end
		
		--update mount button (on the sphere) and also the keybindings
		Necrosis:StoneAttribute("Own");
		--Necrosis:BindName();
		
	end
	ClearCursor();
end

function NecrosisInitSelectedMountButton(button, id)
	
end
