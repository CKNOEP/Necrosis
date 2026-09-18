--[[
    Necrosis - RETAIL VERSION
    Copyright (C) - copyright file included in this release

    NecrosisUI Interface Builder configuration options (Midnight 12.0+)
    Permet de personnaliser et repositionner les éléments de l'interface
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)
local AddonName, SAO = ...
local iamNecrosis = strlower(AddonName):sub(0,8) == "necrosis"
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)


------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OPTIONS
------------------------------------------------------------------------------------------------------

-- On crée ou on affiche le panneau de configuration de NecrosisUI
function Necrosis:SetNecrosisUIConfig()

	local frame = _G["NecrosisUIConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisUIConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		--------------------------------------
		-- MODE EDITION
		--------------------------------------

		-- Title
		local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", 20, -20)
		title:SetText("Mode Edition")
		title:SetTextColor(1, 0.8, 0)

		-- Radio buttons
		local radioOnButton = CreateFrame("CheckButton", "NecrosisUIEditModeOn", frame, "UIRadioButtonTemplate")
		radioOnButton:SetWidth(24)
		radioOnButton:SetHeight(24)
		radioOnButton:SetPoint("LEFT", frame, "TOPLEFT", 20, -50)
		radioOnButton:Show()

		local radioOnLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		radioOnLabel:SetPoint("LEFT", radioOnButton, "RIGHT", 5, 1)
		radioOnLabel:SetText("Activé (déplacer les éléments)")
		radioOnLabel:SetTextColor(1, 1, 1)

		local radioOffButton = CreateFrame("CheckButton", "NecrosisUIEditModeOff", frame, "UIRadioButtonTemplate")
		radioOffButton:SetWidth(24)
		radioOffButton:SetHeight(24)
		radioOffButton:SetPoint("LEFT", radioOnButton, "LEFT", 0, -25)
		radioOffButton:Show()

		local radioOffLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		radioOffLabel:SetPoint("LEFT", radioOffButton, "RIGHT", 5, 1)
		radioOffLabel:SetText("Désactivé (mode normal)")
		radioOffLabel:SetTextColor(1, 1, 1)

		-- Radio button logic
		radioOnButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				radioOffButton:SetChecked(false)
				NecrosisConfig.NecrosisUIEditMode = true
				if Necrosis.UnlockAllButtons then
					Necrosis:UnlockAllButtons()
				end
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("|cFFFFFF00Mode édition ACTIVÉ - Faites glisser les boutons!|r")
			end
		end)

		radioOffButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				radioOnButton:SetChecked(false)
				NecrosisConfig.NecrosisUIEditMode = false
				if Necrosis.LockAllButtons then
					Necrosis:LockAllButtons()
				end
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("|cFFFFFF00Mode édition DÉSACTIVÉ|r")
			end
		end)

		--------------------------------------
		-- SPHERE
		--------------------------------------

		local sphereTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		sphereTitle:SetPoint("TOPLEFT", 20, -110)
		sphereTitle:SetText("──── Sphère ────")
		sphereTitle:SetTextColor(0.7, 0.7, 0.9)

		local sphereCheckButton = CreateFrame("CheckButton", "NecrosisUISphereCheckButton", frame, "UICheckButtonTemplate")
		sphereCheckButton:SetWidth(24)
		sphereCheckButton:SetHeight(24)
		sphereCheckButton:SetPoint("LEFT", frame, "TOPLEFT", 35, -135)
		sphereCheckButton:Show()

		local sphereLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		sphereLabel:SetPoint("LEFT", sphereCheckButton, "RIGHT", 5, 1)
		sphereLabel:SetText("Afficher la sphère principale")
		sphereLabel:SetTextColor(1, 1, 1)

		sphereCheckButton:SetScript("OnClick", function(self)
			local mainSphere = _G["NecrosisMainSphere"]
			if mainSphere then
				if self:GetChecked() then
					mainSphere:Show()
					NecrosisConfig.NecrosisUIShowSphere = true
				else
					mainSphere:Hide()
					NecrosisConfig.NecrosisUIShowSphere = false
				end
			end
		end)

		--------------------------------------
		-- BOUTONS DE PIERRE
		--------------------------------------

		local stoneTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		stoneTitle:SetPoint("TOPLEFT", 20, -165)
		stoneTitle:SetText("──── Boutons de Pierre ────")
		stoneTitle:SetTextColor(0.7, 0.7, 0.9)

		-- Healthstone
		local healthstoneCheckButton = CreateFrame("CheckButton", "NecrosisUIHealthstoneCheckButton", frame, "UICheckButtonTemplate")
		healthstoneCheckButton:SetWidth(24)
		healthstoneCheckButton:SetHeight(24)
		healthstoneCheckButton:SetPoint("LEFT", frame, "TOPLEFT", 35, -190)
		healthstoneCheckButton:Show()

		local healthstoneLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		healthstoneLabel:SetPoint("LEFT", healthstoneCheckButton, "RIGHT", 5, 1)
		healthstoneLabel:SetText("Healthstone")
		healthstoneLabel:SetTextColor(1, 1, 1)

		healthstoneCheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NecrosisConfig.StonePosition[3] = 3
			else
				NecrosisConfig.StonePosition[3] = -3
			end
			Necrosis:UpdateIcons()
		end)

		-- Soulstone
		local soulstoneCheckButton = CreateFrame("CheckButton", "NecrosisUISoulstoneCheckButton", frame, "UICheckButtonTemplate")
		soulstoneCheckButton:SetWidth(24)
		soulstoneCheckButton:SetHeight(24)
		soulstoneCheckButton:SetPoint("RIGHT", frame, "TOPRIGHT", -35, -190)
		soulstoneCheckButton:Show()

		local soulstoneLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		soulstoneLabel:SetPoint("RIGHT", soulstoneCheckButton, "LEFT", -5, 1)
		soulstoneLabel:SetText("Soulstone")
		soulstoneLabel:SetTextColor(1, 1, 1)

		soulstoneCheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NecrosisConfig.StonePosition[4] = 4
			else
				NecrosisConfig.StonePosition[4] = -4
			end
			Necrosis:UpdateIcons()
		end)

		-- Spellstone
		local spellstoneCheckButton = CreateFrame("CheckButton", "NecrosisUISpellstoneCheckButton", frame, "UICheckButtonTemplate")
		spellstoneCheckButton:SetWidth(24)
		spellstoneCheckButton:SetHeight(24)
		spellstoneCheckButton:SetPoint("LEFT", frame, "TOPLEFT", 35, -215)
		spellstoneCheckButton:Show()

		local spellstoneLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		spellstoneLabel:SetPoint("LEFT", spellstoneCheckButton, "RIGHT", 5, 1)
		spellstoneLabel:SetText("Spellstone")
		spellstoneLabel:SetTextColor(1, 1, 1)

		spellstoneCheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NecrosisConfig.StonePosition[2] = 2
			else
				NecrosisConfig.StonePosition[2] = -2
			end
			Necrosis:UpdateIcons()
		end)

		-- Firestone
		local firestoneCheckButton = CreateFrame("CheckButton", "NecrosisUIFirestoneCheckButton", frame, "UICheckButtonTemplate")
		firestoneCheckButton:SetWidth(24)
		firestoneCheckButton:SetHeight(24)
		firestoneCheckButton:SetPoint("RIGHT", frame, "TOPRIGHT", -35, -215)
		firestoneCheckButton:Show()

		local firestoneLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		firestoneLabel:SetPoint("RIGHT", firestoneCheckButton, "LEFT", -5, 1)
		firestoneLabel:SetText("Firestone")
		firestoneLabel:SetTextColor(1, 1, 1)

		firestoneCheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NecrosisConfig.StonePosition[1] = 1
			else
				NecrosisConfig.StonePosition[1] = -1
			end
			Necrosis:UpdateIcons()
		end)

		--------------------------------------
		-- BOUTONS D'ACTION
		--------------------------------------

		local actionTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		actionTitle:SetPoint("TOPLEFT", 20, -250)
		actionTitle:SetText("──── Boutons d'Action ────")
		actionTitle:SetTextColor(0.7, 0.7, 0.9)

		-- Buff Menu
		local buffMenuCheckButton = CreateFrame("CheckButton", "NecrosisUIBuffMenuCheckButton", frame, "UICheckButtonTemplate")
		buffMenuCheckButton:SetWidth(24)
		buffMenuCheckButton:SetHeight(24)
		buffMenuCheckButton:SetPoint("LEFT", frame, "TOPLEFT", 35, -275)
		buffMenuCheckButton:Show()

		local buffMenuLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		buffMenuLabel:SetPoint("LEFT", buffMenuCheckButton, "RIGHT", 5, 1)
		buffMenuLabel:SetText("Buff Menu")
		buffMenuLabel:SetTextColor(1, 1, 1)

		buffMenuCheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NecrosisConfig.StonePosition[5] = 5
			else
				NecrosisConfig.StonePosition[5] = -5
			end
			Necrosis:UpdateIcons()
		end)

		-- Mount
		local mountCheckButton = CreateFrame("CheckButton", "NecrosisUIMountCheckButton", frame, "UICheckButtonTemplate")
		mountCheckButton:SetWidth(24)
		mountCheckButton:SetHeight(24)
		mountCheckButton:SetPoint("RIGHT", frame, "TOPRIGHT", -35, -275)
		mountCheckButton:Show()

		local mountLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		mountLabel:SetPoint("RIGHT", mountCheckButton, "LEFT", -5, 1)
		mountLabel:SetText("Monture")
		mountLabel:SetTextColor(1, 1, 1)

		mountCheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NecrosisConfig.StonePosition[6] = 6
			else
				NecrosisConfig.StonePosition[6] = -6
			end
			Necrosis:UpdateIcons()
		end)

		-- Pet Menu
		local petMenuCheckButton = CreateFrame("CheckButton", "NecrosisUIPetMenuCheckButton", frame, "UICheckButtonTemplate")
		petMenuCheckButton:SetWidth(24)
		petMenuCheckButton:SetHeight(24)
		petMenuCheckButton:SetPoint("LEFT", frame, "TOPLEFT", 35, -300)
		petMenuCheckButton:Show()

		local petMenuLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		petMenuLabel:SetPoint("LEFT", petMenuCheckButton, "RIGHT", 5, 1)
		petMenuLabel:SetText("Pet Menu")
		petMenuLabel:SetTextColor(1, 1, 1)

		petMenuCheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NecrosisConfig.StonePosition[7] = 7
			else
				NecrosisConfig.StonePosition[7] = -7
			end
			Necrosis:UpdateIcons()
		end)

		-- Curse Menu
		local curseMenuCheckButton = CreateFrame("CheckButton", "NecrosisUICurseMenuCheckButton", frame, "UICheckButtonTemplate")
		curseMenuCheckButton:SetWidth(24)
		curseMenuCheckButton:SetHeight(24)
		curseMenuCheckButton:SetPoint("RIGHT", frame, "TOPRIGHT", -35, -300)
		curseMenuCheckButton:Show()

		local curseMenuLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		curseMenuLabel:SetPoint("RIGHT", curseMenuCheckButton, "LEFT", -5, 1)
		curseMenuLabel:SetText("Curse Menu")
		curseMenuLabel:SetTextColor(1, 1, 1)

		curseMenuCheckButton:SetScript("OnClick", function(self)
			if self:GetChecked() then
				NecrosisConfig.StonePosition[8] = 8
			else
				NecrosisConfig.StonePosition[8] = -8
			end
			Necrosis:UpdateIcons()
		end)

		--------------------------------------
		-- BUTTONS ACTION
		--------------------------------------

		-- Save Positions Button
		local saveButton = CreateFrame("Button", "NecrosisUISaveButton", frame, "UIPanelButtonTemplate")
		saveButton:SetWidth(150)
		saveButton:SetHeight(24)
		saveButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 15)
		saveButton:SetText("Sauvegarder positions")
		saveButton:Show()

		saveButton:SetScript("OnClick", function(self)
			if Necrosis.SaveAllUIPositions then
				Necrosis:SaveAllUIPositions()
			else
				-- Fallback if not loaded yet
				for _, buttonInfo in pairs(Necrosis.Warlock_Buttons) do
					local f = _G[buttonInfo.f]
					if f then
						local anchor, parent, relPoint, x, y = f:GetPoint()
						local parentName = parent and parent:GetName() or "UIParent"
						NecrosisConfig.FramePosition[f:GetName()] = {anchor, parentName, relPoint, x, y, f:GetScale()}
					end
				end
			end
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("|cFF00FF00Positions sauvegardées!|r")
		end)

		-- Reset Button
		local resetButton = CreateFrame("Button", "NecrosisUIResetButton", frame, "UIPanelButtonTemplate")
		resetButton:SetWidth(150)
		resetButton:SetHeight(24)
		resetButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 15)
		resetButton:SetText("Réinitialiser")
		resetButton:Show()

		resetButton:SetScript("OnClick", function(self)
			StaticPopup_Show("NECROSIS_UI_RESET_CONFIRM")
		end)

	end

	-- Update radio buttons state
	local editModeOn = _G["NecrosisUIEditModeOn"]
	local editModeOff = _G["NecrosisUIEditModeOff"]
	if editModeOn and editModeOff then
		if NecrosisConfig.NecrosisUIEditMode then
			editModeOn:SetChecked(true)
			editModeOff:SetChecked(false)
		else
			editModeOn:SetChecked(false)
			editModeOff:SetChecked(true)
		end
	end

	-- Update checkboxes state for stones
	local healthstoneCheck = _G["NecrosisUIHealthstoneCheckButton"]
	if healthstoneCheck then
		healthstoneCheck:SetChecked(NecrosisConfig.StonePosition[3] > 0)
	end

	local soulstoneCheck = _G["NecrosisUISoulstoneCheckButton"]
	if soulstoneCheck then
		soulstoneCheck:SetChecked(NecrosisConfig.StonePosition[4] > 0)
	end

	local spellstoneCheck = _G["NecrosisUISpellstoneCheckButton"]
	if spellstoneCheck then
		spellstoneCheck:SetChecked(NecrosisConfig.StonePosition[2] > 0)
	end

	local firestoneCheck = _G["NecrosisUIFirestoneCheckButton"]
	if firestoneCheck then
		firestoneCheck:SetChecked(NecrosisConfig.StonePosition[1] > 0)
	end

	-- Update checkboxes for action buttons
	local buffMenuCheck = _G["NecrosisUIBuffMenuCheckButton"]
	if buffMenuCheck then
		buffMenuCheck:SetChecked(NecrosisConfig.StonePosition[5] > 0)
	end

	local mountCheck = _G["NecrosisUIMountCheckButton"]
	if mountCheck then
		mountCheck:SetChecked(NecrosisConfig.StonePosition[6] > 0)
	end

	local petMenuCheck = _G["NecrosisUIPetMenuCheckButton"]
	if petMenuCheck then
		petMenuCheck:SetChecked(NecrosisConfig.StonePosition[7] > 0)
	end

	local curseMenuCheck = _G["NecrosisUICurseMenuCheckButton"]
	if curseMenuCheck then
		curseMenuCheck:SetChecked(NecrosisConfig.StonePosition[8] > 0)
	end

	-- Update sphere checkbox
	local sphereCheck = _G["NecrosisUISphereCheckButton"]
	if sphereCheck then
		local mainSphere = _G["NecrosisMainSphere"]
		if mainSphere then
			sphereCheck:SetChecked(mainSphere:IsVisible())
		end
	end

end
