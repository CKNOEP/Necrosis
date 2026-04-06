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
				}
				local loc = {-121, -87, -53, -17, 17, 53, 87, 121}
				-- Initialize FramePosition table if needed
				if not NecrosisConfig.FramePosition then
					NecrosisConfig.FramePosition = {}
				end
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
	local boutons_pierres = {"HealthStone", "Soulstone"}
	local pierre_indices = {3, 4}  -- Mapping des indices pour NecrosisConfig.StonePosition
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

		local globalIndex = pierre_indices[i]
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
	local boutons_action = {"SpellMenu", "Mount", "PetMenu", "CurseMenu"}
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
		frame = CreateFrame("Slider", "NecrosisRotation", NecrosisButtonsConfig2, "OptionsSliderTemplate")
		frame:SetMinMaxValues(0, 360)
		frame:SetValueStep(5)
		frame:SetObeyStepOnDrag(true)
		frame:SetWidth(150)
		frame:SetHeight(15)

		-- Create slider visual elements with circular dot cursor
		local track = frame:CreateTexture(nil, "BACKGROUND")
		track:SetWidth(150)
		track:SetHeight(4)
		track:SetColorTexture(0.2, 0.2, 0.2, 1)
		track:SetPoint("CENTER", frame, "CENTER", 0, 0)

		local thumb = frame:GetThumbTexture()
		if thumb then
			thumb:SetTexture("Interface\Common\Indicator-Yellow")
			thumb:SetColorTexture(1, 0.8, 0, 1)
			thumb:SetSize(6, 6)
		end
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
		frame = CreateFrame("Button", "NecrosisSelectedMountLeft", NecrosisMountsSelectionFrame)
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetWidth(32)
		frame:SetHeight(32)
		frame.Tooltip="Drag and Drop your mount here";

		local texture = frame:CreateTexture("NecrosisSelectedMountLeftTexture", "BACKGROUND")
		texture:SetAllPoints()
		frame.mountTexture = texture

		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, 10)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
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
			NecrosisConfig.LeftMount = 23161
			NecrosisInitSelectedMountButton(NecrosisSelectedMountLeft, 23161)
			Necrosis:StoneAttribute("Own")
		end)		
	
		frame = CreateFrame("Button", "NecrosisSelectedMountRight", NecrosisMountsSelectionFrame)
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetWidth(32)
		frame:SetHeight(32)

		local texture = frame:CreateTexture("NecrosisSelectedMountRightTexture", "BACKGROUND")
		texture:SetAllPoints()
		frame.mountTexture = texture

		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, -25)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
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
			NecrosisConfig.RightMount = 5784
			NecrosisInitSelectedMountButton(NecrosisSelectedMountRight, 5784)
			Necrosis:StoneAttribute("Own")
		end)
			
		frame = CreateFrame("Button", "NecrosisSelectedMountCtrlLeft", NecrosisMountsSelectionFrame)
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetWidth(32)
		frame:SetHeight(32)

		local texture = frame:CreateTexture("NecrosisSelectedMountCtrlLeftTexture", "BACKGROUND")
		texture:SetAllPoints()
		frame.mountTexture = texture

		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, -60)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
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
			NecrosisConfig.CtrlLeftMount = 23161
			NecrosisInitSelectedMountButton(NecrosisSelectedMountCtrlLeft, 23161)
			Necrosis:StoneAttribute("Own")
		end)	

		
		frame = CreateFrame("Button", "NecrosisSelectedMountCtrlRight", NecrosisMountsSelectionFrame)
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetWidth(32)
		frame:SetHeight(32)

		local texture = frame:CreateTexture("NecrosisSelectedMountCtrlRightTexture", "BACKGROUND")
		texture:SetAllPoints()
		frame.mountTexture = texture

		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, -95)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
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
			NecrosisConfig.CtrlRightMount = 23161
			NecrosisInitSelectedMountButton(NecrosisSelectedMountCtrlRight, 23161)
			Necrosis:StoneAttribute("Own")
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

		-- Add button to open Collections/Mounts interface || Bouton pour ouvrir l'interface Collections/Montures
		local collectionsButton = CreateFrame("Button", "NecrosisOpenCollectionsButton", NecrosisMountsSelectionFrame, "UIPanelButtonTemplate")
		collectionsButton:SetText("Ouvrir Collections")
		collectionsButton:EnableMouse(true)
		collectionsButton:Show()
		collectionsButton:ClearAllPoints()
		collectionsButton:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "BOTTOM", 0, -100)
		collectionsButton:SetWidth(120)
		collectionsButton:SetHeight(22)
		collectionsButton:SetScript("OnClick", function()
			CollectionsJournal_LoadUI()
			ShowUIPanel(CollectionsJournalFrame)
			-- Navigate to Mounts tab (tab 2 in Collections Journal)
			local tab = _G["CollectionsJournalTab2"]
			if tab then
				PanelTemplates_SetTab(CollectionsJournalFrame, 2)
				CollectionsJournal_OnTabClicked(CollectionsJournalFrame, 2)
			end
		end)
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

	if (NecrosisConfig.CtrlLeftMount) then
		NecrosisInitSelectedMountButton(NecrosisSelectedMountCtrlLeft, NecrosisConfig.CtrlLeftMount);
	else
		NecrosisInitSelectedMountButton(NecrosisSelectedMountCtrlLeft, 23161);
	end

	if (NecrosisConfig.CtrlRightMount) then
		NecrosisInitSelectedMountButton(NecrosisSelectedMountCtrlRight, NecrosisConfig.CtrlRightMount);
	else
		NecrosisInitSelectedMountButton(NecrosisSelectedMountCtrlRight, 23161);
	end

	--Set the value save in savedvariables
	
	
	if NecrosisConfig.LeftMount ==23161 or NecrosisConfig.LeftMount ==5784  or NecrosisConfig.LeftMount == nil then
	LM = 132238
	else
	local _, _, _, _, _, _, _, _, _, _, icon = C_MountJournal.GetMountInfoExtraByID(NecrosisConfig.LeftMount)
	LM = icon or 132238
	end
	
	
	if NecrosisConfig.RightMount ==23161 or NecrosisConfig.RightMount ==5784 or NecrosisConfig.RightMount == nil then
	RM = 132238
	else
	local _, _, _, _, _, _, _, _, _, _, icon = C_MountJournal.GetMountInfoExtraByID(NecrosisConfig.RightMount)
	RM = icon or 132238
	end
	
	
	if NecrosisConfig.CtrlLeftMount ==23161 or NecrosisConfig.CtrlLeftMount ==5784 or NecrosisConfig.CtrlLeftMount == nil then
	CTRL_LM = 132238
	else
	local _, _, _, _, _, _, _, _, _, _, icon = C_MountJournal.GetMountInfoExtraByID(NecrosisConfig.CtrlLeftMount)
	CTRL_LM = icon or 132238
	end
	
	
	if NecrosisConfig.CtrlRightMount ==23161 or NecrosisConfig.CtrlRightMount ==5784 or NecrosisConfig.CtrlRightMount == nil then
	CTRL_RM = 132238
	else
	local _, _, _, _, _, _, _, _, _, _, icon = C_MountJournal.GetMountInfoExtraByID(NecrosisConfig.CtrlRightMount)
	CTRL_RM = icon or 132238
	end
	
	Necrosis:UpdateMountButtons()
	--print(LM,RM,CTRL_LM,CTRL_RM)
	
	NecrosisSelectedMountLeft.mountTexture:SetTexture(LM)
	NecrosisSelectedMountRight.mountTexture:SetTexture(RM)
	NecrosisSelectedMountCtrlLeft.mountTexture:SetTexture(CTRL_LM)
	NecrosisSelectedMountCtrlRight.mountTexture:SetTexture(CTRL_RM)
	
	NecrosisRotation:SetValue(NecrosisConfig.NecrosisAngle)
	NecrosisLockButtons:SetChecked(NecrosisConfig.NecrosisLockServ)


	local boutons = {"HealthStone", "Soulstone", "SpellMenu", "Mount", "PetMenu", "CurseMenu"}
	for i in ipairs(boutons) do
		_G["NecrosisShow"..boutons[i]]:SetChecked(NecrosisConfig.StonePosition[i] > 0)
		_G["NecrosisShow"..boutons[i]]:SetText(self.Config.Buttons.Name[i])
	end

	NecrosisButtonsConfig1Text:SetText(self.Config.Buttons["Choix des boutons a afficher"])
	NecrosisButtonsConfig2Text:SetText(self.Config.Menus["Options Generales"])
	NecrosisRotationText:SetText(self.Config.Buttons["Rotation des boutons"])
	NecrosisLockButtons:SetText(self.Config.Buttons["Fixer les boutons autour de la sphere"])

	-- Ensure we start on page 2 (mount management)
	NecrosisButtonsConfig1:Hide()
	NecrosisButtonsConfig2:Show()

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
	local dragType, mountID = GetCursorInfo()

	if dragType == "mount" then
		local mountInfo = {C_MountJournal.GetMountInfoByID(mountID)}

		if mountInfo[12] then  -- mountID valid
			local button = _G[self:GetName()]
			local mountName = mountInfo[1]
			local icon = mountInfo[3]  -- texture FileID

			-- Get extra mount info to find spellID
			local extraInfo = {C_MountJournal.GetMountInfoExtraByID(mountID)}
			local spellID = extraInfo[11]  -- spellID is at position 11 in GetMountInfoExtraByID

			-- Store spellID (not mountID) to the appropriate config slot
			if button == NecrosisSelectedMountLeft then
				NecrosisConfig.LeftMount = mountID
			elseif button == NecrosisSelectedMountRight then
				NecrosisConfig.RightMount = mountID
			elseif button == NecrosisSelectedMountCtrlLeft then
				NecrosisConfig.CtrlLeftMount = mountID
			elseif button == NecrosisSelectedMountCtrlRight then
				NecrosisConfig.CtrlRightMount = mountID
			end

			-- Update button texture
			if icon then
				button:SetNormalTexture(icon)
				button:Enable()
			else
				button:Disable()
			end

			-- Update mount button and keybindings
			Necrosis:StoneAttribute("Own")
		end
	end

	ClearCursor()
end

function NecrosisInitSelectedMountButton(button, id)
	if id then
		local mountInfo = {C_MountJournal.GetMountInfoByID(id)}

		if mountInfo[12] then  -- Valid mountID
			local icon = mountInfo[3]  -- texture FileID

			if icon then
				-- Use SetNormalTexture with FileID format
				button:SetNormalTexture(icon)
				button:Enable()
			else
				button:Disable()
			end
		end
	end
end

local function SafeSummon(mountID)
	if mountID and mountID > 0 then
		local _, _, _, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)
		if isUsable then
			C_MountJournal.SummonByID(mountID)
		else
			-- Fallback to random mount if not usable
			C_MountJournal.SummonByID(0)
		end
	else
		-- Fallback to random mount if no ID
		C_MountJournal.SummonByID(0)
	end
end

function NecrosisMountButton_OnEnter(self)
	if not GameTooltip:IsOwned(self) then
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
	end

	GameTooltip:ClearLines()
	GameTooltip:AddLine(Necrosis.Config.Buttons["Montures"] or "Mounts", 1, 1, 1)
	GameTooltip:AddLine(" ")

	-- Get current mounts
	local leftMountInfo = NecrosisConfig.LeftMount and {C_MountJournal.GetMountInfoByID(NecrosisConfig.LeftMount)}
	local rightMountInfo = NecrosisConfig.RightMount and {C_MountJournal.GetMountInfoByID(NecrosisConfig.RightMount)}
	local ctrlLeftMountInfo = NecrosisConfig.CtrlLeftMount and {C_MountJournal.GetMountInfoByID(NecrosisConfig.CtrlLeftMount)}
	local ctrlRightMountInfo = NecrosisConfig.CtrlRightMount and {C_MountJournal.GetMountInfoByID(NecrosisConfig.CtrlRightMount)}

	local leftMount = leftMountInfo and leftMountInfo[1]
	local leftIcon = leftMountInfo and leftMountInfo[3]
	local rightMount = rightMountInfo and rightMountInfo[1]
	local rightIcon = rightMountInfo and rightMountInfo[3]
	local ctrlLeftMount = ctrlLeftMountInfo and ctrlLeftMountInfo[1]
	local ctrlLeftIcon = ctrlLeftMountInfo and ctrlLeftMountInfo[3]
	local ctrlRightMount = ctrlRightMountInfo and ctrlRightMountInfo[1]
	local ctrlRightIcon = ctrlRightMountInfo and ctrlRightMountInfo[3]

	-- Left click
	if leftIcon then
		local leftText = CreateTextureMarkup(leftIcon, 16, 16, 16, 16, 0, 1, 0, 1) .. " |cff00ff00Clic gauche:|r " .. (leftMount or "Défaut")
		GameTooltip:AddLine(leftText, 1, 1, 1)
	else
		GameTooltip:AddLine("|cff00ff00Clic gauche:|r " .. (leftMount or "Défaut"), 1, 1, 1)
	end

	-- Right click
	if rightIcon then
		local rightText = CreateTextureMarkup(rightIcon, 16, 16, 16, 16, 0, 1, 0, 1) .. " |cff00ff00Clic droit:|r " .. (rightMount or "Défaut")
		GameTooltip:AddLine(rightText, 1, 1, 1)
	else
		GameTooltip:AddLine("|cff00ff00Clic droit:|r " .. (rightMount or "Défaut"), 1, 1, 1)
	end

	-- Ctrl+Left click
	if ctrlLeftIcon then
		local ctrlLeftText = CreateTextureMarkup(ctrlLeftIcon, 16, 16, 16, 16, 0, 1, 0, 1) .. " |cff00ff00Ctrl+Gauche:|r " .. (ctrlLeftMount or "Défaut")
		GameTooltip:AddLine(ctrlLeftText, 1, 1, 1)
	else
		GameTooltip:AddLine("|cff00ff00Ctrl+Gauche:|r " .. (ctrlLeftMount or "Défaut"), 1, 1, 1)
	end

	-- Ctrl+Right click
	if ctrlRightIcon then
		local ctrlRightText = CreateTextureMarkup(ctrlRightIcon, 16, 16, 16, 16, 0, 1, 0, 1) .. " |cff00ff00Ctrl+Droit:|r " .. (ctrlRightMount or "Défaut")
		GameTooltip:AddLine(ctrlRightText, 1, 1, 1)
	else
		GameTooltip:AddLine("|cff00ff00Ctrl+Droit:|r " .. (ctrlRightMount or "Défaut"), 1, 1, 1)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("|cffffaa00Clic central:|r Config + Collection", 1, 1, 1)

	GameTooltip:Show()
end

function NecrosisMountButton_OnLeave(self)
	GameTooltip:Hide()
end

function NecrosisMountButton_OnClick(self, button)
	if button == "MiddleButton" then
		-- Middle-click: Open mount configuration and collection
		Necrosis:OpenConfigPanel()
		Necrosis:SetPanel(3)
		ToggleCollectionsJournal(1)
		return
	end

	local mountID

	if IsControlKeyDown() then
		-- Ctrl+click
		if button == "LeftButton" then
			mountID = NecrosisConfig.CtrlLeftMount
		else  -- RightButton
			mountID = NecrosisConfig.CtrlRightMount
		end
	else
		-- Normal click
		if button == "LeftButton" then
			mountID = NecrosisConfig.LeftMount
		else  -- RightButton
			mountID = NecrosisConfig.RightMount
		end
	end

	SafeSummon(mountID)
end
