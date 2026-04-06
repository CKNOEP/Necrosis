--[[
    Necrosis - RETAIL VERSION
    Copyright (C) - copyright file included in this release

    Retail-specific timers options panel (Midnight 12.0+)
    UPDATED: 3-page layout for 40+ timer spells
]]--

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)
local AddonName, SAO = ...
local iamNecrosis = strlower(AddonName):sub(0,8) == "necrosis"
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OPTIONS TIMERS RETAIL (3-PAGE VERSION)
------------------------------------------------------------------------------------------------------

function Necrosis:SetTimersConfig()
	local msg = "[Necrosis] SetTimersConfig() called!"
	print(msg)
	if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(msg) end

	-- ========================================
	-- CLEAN UP OLD FRAMES (force recreation for new layout)
	-- ========================================
	local oldFrame = _G["NecrosisTimersConfig"]
	local msg2 = "[Necrosis] oldFrame exists: " .. tostring(oldFrame)
	print(msg2)
	if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(msg2) end
	if oldFrame then
		-- Check if it has the old 2-page layout (missing Page 3)
		if _G["NecrosisTimersConfig2"] and not _G["NecrosisTimersConfig3"] then
			-- Old layout detected - destroy all old frames and recreate
			pcall(function()
				oldFrame:Hide()
				oldFrame = nil
				_G["NecrosisTimersConfig"] = nil
				if _G["NecrosisTimersConfig1"] then
					_G["NecrosisTimersConfig1"]:Hide()
					_G["NecrosisTimersConfig1"] = nil
				end
				if _G["NecrosisTimersConfig2"] then
					_G["NecrosisTimersConfig2"]:Hide()
					_G["NecrosisTimersConfig2"] = nil
				end
				-- Clean up all timer checkboxes
				for i = 1, 50 do
					if _G["NecrosisTimerShow"..i] then
						_G["NecrosisTimerShow"..i]:Hide()
						_G["NecrosisTimerShow"..i] = nil
					end
				end
			end)
		elseif _G["NecrosisTimersConfig3"] then
			-- New layout already exists - clean up old checkboxes and recreate them
			pcall(function()
				for i = 1, 50 do
					if _G["NecrosisTimerShow"..i] then
						_G["NecrosisTimerShow"..i]:Hide()
						_G["NecrosisTimerShow"..i] = nil
					end
				end
			end)
			-- Continue to recreate checkboxes with current data
		end
	end

	local frame = _G["NecrosisTimersConfig"]
	if not frame then
		-- Création de la fenêtre principale
		frame = CreateFrame("Frame", "NecrosisTimersConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- ========================================
		-- PAGE 1: TIMER TYPE & DISPLAY OPTIONS
		-- ========================================
		frame = CreateFrame("Frame", "NecrosisTimersConfig1", NecrosisTimersConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Navigation indicator
		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 90, 90)
		FontString:SetText("1 / 3")

		FontString = frame:CreateFontString("NecrosisTimersConfig1Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 400)
		FontString:SetText((L and L["TIMER_SETTINGS"]) or "Timer Settings")

		-- Navigation buttons
		frame = CreateFrame("Button", nil, NecrosisTimersConfig1, "UIPanelButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisTimersConfig1, "BOTTOMRIGHT", 120, 100)
		frame:SetScript("OnClick", function()
			NecrosisTimersConfig2:Show()
			NecrosisTimersConfig1:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisTimersConfig1, "UIPanelButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisTimersConfig1, "BOTTOMLEFT", 40, 100)
		frame:SetScript("OnClick", function()
			NecrosisTimersConfig3:Show()
			NecrosisTimersConfig1:Hide()
		end)

		-- ========================================
		-- TIMER TYPE DROPDOWN
		-- ========================================
		frame = CreateFrame("Frame", "NecrosisTimerSelection", NecrosisTimersConfig1, "UIDropDownMenuTemplate")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisTimersConfig1, "BOTTOMRIGHT", 40, 400)

		FontString = frame:CreateFontString("NecrosisTimerSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", NecrosisTimersConfig1, "BOTTOMLEFT", 35, 403)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText((L and L["TIMER_TYPE"]) or "Timer Type")

		UIDropDownMenu_SetWidth(frame, 125)

		-- ========================================
		-- SHOW TIMER BUTTON
		-- ========================================
		frame = CreateFrame("CheckButton", "NecrosisShowSpellTimerButton", NecrosisTimersConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisTimersConfig1, "BOTTOMLEFT", 40, 325)

		local f = _G[Necrosis.Warlock_Buttons.timer.f]
		frame:SetScript("OnClick", function(self)
			NecrosisConfig.ShowSpellTimers = self:GetChecked()
			if f then
				if NecrosisConfig.ShowSpellTimers then
					f:Show()
				else
					f:Hide()
				end
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText((L and L["SHOW_SPELL_TIMER"]) or "Show Timer Button")
		frame:SetFontString(FontString)

		-- ========================================
		-- TIMER POSITION (LEFT/RIGHT)
		-- ========================================
		frame = CreateFrame("CheckButton", "NecrosisTimerOnLeft", NecrosisTimersConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisTimersConfig1, "BOTTOMLEFT", 40, 300)

		frame:SetScript("OnClick", function(self)
			if Necrosis.SymetrieTimer then
				Necrosis:SymetrieTimer(self:GetChecked())
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText((L and L["TIMER_ON_LEFT"]) or "Show Timers on Left")
		frame:SetFontString(FontString)

		-- ========================================
		-- TIMER DIRECTION (UP/DOWN)
		-- ========================================
		frame = CreateFrame("CheckButton", "NecrosisTimerUpward", NecrosisTimersConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisTimersConfig1, "BOTTOMLEFT", 40, 275)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				NecrosisConfig.SensListe = -1
			else
				NecrosisConfig.SensListe = 1
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText((L and L["TIMER_UPWARD"]) or "Show Timers Upward")
		frame:SetFontString(FontString)

		-- ========================================
		-- TIMER TRANSPARENCY/ALPHA
		-- ========================================
		frame = CreateFrame("Slider", "NecrosisAlphaBar", NecrosisTimersConfig1, "OptionsSliderTemplate")
		frame:SetMinMaxValues(1, 100)
		frame:SetValueStep(1)
		frame:SetObeyStepOnDrag(true)
		frame:SetStepsPerPage(1)
		frame:SetWidth(150)
		frame:SetHeight(15)

		local track = frame:CreateTexture(nil, "BACKGROUND")
		track:SetWidth(150)
		track:SetHeight(4)
		track:SetColorTexture(0.2, 0.2, 0.2, 1)
		track:SetPoint("CENTER", frame, "CENTER", 0, 0)

		local thumb = frame:GetThumbTexture()
		if thumb then
			thumb:SetTexture("Interface\\Common\\Indicator-Yellow")
			thumb:SetColorTexture(1, 0.8, 0, 1)
			thumb:SetSize(6, 6)
		end

		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisTimersConfig1, "BOTTOMLEFT", 225, 355)

		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(math.floor(self:GetValue()))
		end)

		frame:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		frame:SetScript("OnValueChanged", function(self)
			GameTooltip:SetText(math.floor(self:GetValue()))
		end)

		frame:SetScript("OnMouseUp", function(self)
			GameTooltip:SetText(self:GetValue())
			NecrosisConfig.NecrosisAlphaBar = math.floor(self:GetValue())
		end)

		FontString = frame:CreateFontString("NecrosisAlphaBarT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("CENTER", frame, "CENTER", 0, 12)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText((L and L["TIMER_ALPHA"]) or "Transparency")

		NecrosisAlphaBarLow:SetText("1")
		NecrosisAlphaBarHigh:SetText("100")

		-- ========================================
		-- PAGE 2: TIMER SPELLS (ITEMS 1-20)
		-- ========================================
		frame = CreateFrame("Frame", "NecrosisTimersConfig2", NecrosisTimersConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Hide()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Navigation indicator
		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 90, 95)
		FontString:SetText("2 / 3")

		FontString = frame:CreateFontString("NecrosisTimersConfig2Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 400)
		FontString:SetText((L and L["SELECT_TIMERS"]) or "Select Spell Timers (1-20)")

		-- Navigation buttons
		frame = CreateFrame("Button", nil, NecrosisTimersConfig2, "UIPanelButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisTimersConfig2, "BOTTOMRIGHT", 120, 100)
		frame:SetScript("OnClick", function()
			NecrosisTimersConfig3:Show()
			NecrosisTimersConfig2:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisTimersConfig2, "UIPanelButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisTimersConfig2, "BOTTOMLEFT", 40, 100)
		frame:SetScript("OnClick", function()
			NecrosisTimersConfig1:Show()
			NecrosisTimersConfig2:Hide()
		end)

		-- ========================================
		-- TIMER CHECKBOXES PAGE 2 (2 COLUMNS x 10 ROWS)
		-- ========================================
		local initY = 395
		local leftX = 40
		local rightX = 220
		-- Checkboxes will be created by UpdateTimerCheckboxes() function
		-- Hide page 2 initially (will be shown by UpdateTimerCheckboxes if needed)

		-- ========================================
		-- PAGE 3: TIMER SPELLS (ITEMS 21-40)
		-- ========================================
		frame = CreateFrame("Frame", "NecrosisTimersConfig3", NecrosisTimersConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Hide()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Navigation indicator
		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 90, 95)
		FontString:SetText("3 / 3")

		FontString = frame:CreateFontString("NecrosisTimersConfig3Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 400)
		FontString:SetText((L and L["SELECT_TIMERS"]) or "Select Spell Timers (21-40)")

		-- Navigation buttons
		frame = CreateFrame("Button", nil, NecrosisTimersConfig3, "UIPanelButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisTimersConfig3, "BOTTOMRIGHT", 120, 100)
		frame:SetScript("OnClick", function()
			NecrosisTimersConfig1:Show()
			NecrosisTimersConfig3:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisTimersConfig3, "UIPanelButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisTimersConfig3, "BOTTOMLEFT", 40, 100)
		frame:SetScript("OnClick", function()
			NecrosisTimersConfig2:Show()
			NecrosisTimersConfig3:Hide()
		end)

		-- ========================================
		-- TIMER CHECKBOXES PAGE 3 (created by UpdateTimerCheckboxes())
		-- ========================================
	end

	-- ========================================
	-- INITIALIZE DROPDOWN & SET VALUES
	-- ========================================

	pcall(function()
		UIDropDownMenu_Initialize(NecrosisTimerSelection, Necrosis.Timer_Init)
	end)

	-- Set timer type dropdown
	if NecrosisConfig.TimerType then
		UIDropDownMenu_SetSelectedID(NecrosisTimerSelection, (NecrosisConfig.TimerType + 1))
		if Necrosis.Config and Necrosis.Config.Timers and Necrosis.Config.Timers.Type then
			UIDropDownMenu_SetText(NecrosisTimerSelection, Necrosis.Config.Timers.Type[NecrosisConfig.TimerType + 1])
		end
	end

	-- Set checkbox states
	if NecrosisShowSpellTimerButton then
		NecrosisShowSpellTimerButton:SetChecked(NecrosisConfig.ShowSpellTimers)
	end
	if NecrosisTimerOnLeft then
		NecrosisTimerOnLeft:SetChecked(NecrosisConfig.SpellTimerPos == -1)
	end
	if NecrosisTimerUpward then
		NecrosisTimerUpward:SetChecked(NecrosisConfig.SensListe == -1)
	end

	-- Set alpha slider
	if NecrosisAlphaBar then
		if NecrosisConfig.NecrosisAlphaBar then
			NecrosisAlphaBar:SetValue(NecrosisConfig.NecrosisAlphaBar)
		else
			NecrosisAlphaBar:SetValue(100)
		end
	end

	-- Enable/Disable controls based on timer type
	if NecrosisConfig.TimerType == 0 then
		if NecrosisTimerUpward then NecrosisTimerUpward:Disable() end
		if NecrosisTimerOnLeft then NecrosisTimerOnLeft:Disable() end
	elseif NecrosisConfig.TimerType == 2 then
		if NecrosisTimerUpward then NecrosisTimerUpward:Disable() end
		if NecrosisTimerOnLeft then NecrosisTimerOnLeft:Enable() end
	else
		if NecrosisTimerOnLeft then NecrosisTimerOnLeft:Enable() end
		if NecrosisTimerUpward then NecrosisTimerUpward:Enable() end
	end

	local frame = _G["NecrosisTimersConfig"]
	if frame then
		frame:Show()
	end

	-- Always update timer checkboxes with current data
	Necrosis:UpdateTimerCheckboxes()
end

------------------------------------------------------------------------------------------------------
-- UPDATE TIMER CHECKBOXES (called every time config is shown)
------------------------------------------------------------------------------------------------------
function Necrosis:UpdateTimerCheckboxes()
	-- Debug: check if we're being called
	local msg = "[Necrosis] UpdateTimerCheckboxes() called"
	print(msg)
	if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(msg) end

	-- Check Necrosis.Config.Timers
	local configTimersStatus = tostring(Necrosis.Config.Timers)
	local configMsg = "[Necrosis] Necrosis.Config.Timers: " .. configTimersStatus
	print(configMsg)
	if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(configMsg) end

	if Necrosis.Config.Timers then
		local configCount = #Necrosis.Config.Timers
		local configCountMsg = "[Necrosis] Necrosis.Config.Timers count: " .. configCount
		print(configCountMsg)
		if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(configCountMsg) end

		-- Show all keys to see what's ACTUALLY in Timers
		local keyMsg = "[Necrosis] Necrosis.Config.Timers keys: "
		for key in pairs(Necrosis.Config.Timers) do
			keyMsg = keyMsg .. tostring(key) .. ", "
		end
		print(keyMsg)
		if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(keyMsg) end

		if Necrosis.Config.Timers[1] then
			local configItemMsg = "[Necrosis] Necrosis.Config.Timers[1].usage: " .. tostring(Necrosis.Config.Timers[1].usage)
			print(configItemMsg)
			if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(configItemMsg) end
		end
	end

	local timerStatus = tostring(NecrosisConfig.Timers)
	local msg2 = "[Necrosis] NecrosisConfig.Timers: " .. timerStatus
	print(msg2)
	if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(msg2) end

	if NecrosisConfig.Timers then
		local msg3 = "[Necrosis] Timers count: " .. #NecrosisConfig.Timers
		print(msg3)
		if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(msg3) end

		if NecrosisConfig.Timers[1] then
			local msg4 = "[Necrosis] Timers[1].usage: " .. tostring(NecrosisConfig.Timers[1].usage)
			print(msg4)
			if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(msg4) end
		end
	end

	local msg5 = "[Necrosis] NecrosisTimersConfig2: " .. tostring(_G["NecrosisTimersConfig2"])
	local msg6 = "[Necrosis] NecrosisTimersConfig3: " .. tostring(_G["NecrosisTimersConfig3"])
	print(msg5)
	print(msg6)
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(msg5)
		DEFAULT_CHAT_FRAME:AddMessage(msg6)
	end

	-- Clean up old checkboxes first
	for i = 1, 50 do
		if _G["NecrosisTimerShow"..i] then
			_G["NecrosisTimerShow"..i]:Hide()
			_G["NecrosisTimerShow"..i] = nil
		end
	end

	if not NecrosisConfig.Timers then
		local errMsg = "[Necrosis] ERROR: NecrosisConfig.Timers is nil!"
		print(errMsg)
		if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(errMsg) end
		return
	end

	local initY = 395
	local leftX = 40
	local rightX = 220

	-- Create Page 2 checkboxes (items 1-20)
	print("[Necrosis] Creating Page 2 checkboxes...")
	for i = 1, math.min(20, #NecrosisConfig.Timers), 1 do
		if not NecrosisConfig.Timers[i] or not NecrosisConfig.Timers[i].usage then
			print("[Necrosis] Stopping at item", i, "- data missing")
			break
		end

		print("[Necrosis] Creating checkbox", i, "for", NecrosisConfig.Timers[i].usage)
		local frame = CreateFrame("CheckButton", "NecrosisTimerShow"..i, _G["NecrosisTimersConfig2"], "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()

		if i <= 10 then
			frame:SetPoint("LEFT", _G["NecrosisTimersConfig2"], "BOTTOMLEFT", leftX, initY - (25 * i))
		else
			frame:SetPoint("LEFT", _G["NecrosisTimersConfig2"], "BOTTOMLEFT", rightX, initY - (25 * (i-10)))
		end

		frame:SetScript("OnClick", function(self)
			if Necrosis.UpdateSpellTimer then
				Necrosis.UpdateSpellTimer(i, self:GetChecked())
			end
		end)

		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		frame:SetChecked(NecrosisConfig.Timers[i].show or false)
		frame:SetText(Necrosis.GetSpellName(NecrosisConfig.Timers[i].usage) or "Unknown")
	end

	-- Create Page 3 checkboxes (items 21-40)
	print("[Necrosis] Creating Page 3 checkboxes...")
	for i = 21, #NecrosisConfig.Timers, 1 do
		if not NecrosisConfig.Timers[i] or not NecrosisConfig.Timers[i].usage then
			print("[Necrosis] Stopping at item", i, "- data missing")
			break
		end

		print("[Necrosis] Creating checkbox", i, "for", NecrosisConfig.Timers[i].usage)
		local frame = CreateFrame("CheckButton", "NecrosisTimerShow"..i, _G["NecrosisTimersConfig3"], "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()

		local pageIndex = i - 20
		if pageIndex <= 10 then
			frame:SetPoint("LEFT", _G["NecrosisTimersConfig3"], "BOTTOMLEFT", leftX, initY - (25 * pageIndex))
		else
			frame:SetPoint("LEFT", _G["NecrosisTimersConfig3"], "BOTTOMLEFT", rightX, initY - (25 * (pageIndex-10)))
		end

		frame:SetScript("OnClick", function(self)
			if Necrosis.UpdateSpellTimer then
				Necrosis.UpdateSpellTimer(i, self:GetChecked())
			end
		end)

		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		frame:SetChecked(NecrosisConfig.Timers[i].show or false)
		frame:SetText(Necrosis.GetSpellName(NecrosisConfig.Timers[i].usage) or "Unknown")
	end

	-- Show pages
	print("[Necrosis] Showing pages...")
	if _G["NecrosisTimersConfig2"] then
		print("[Necrosis] Showing NecrosisTimersConfig2")
		_G["NecrosisTimersConfig2"]:Show()
	else
		print("[Necrosis] ERROR: NecrosisTimersConfig2 doesn't exist!")
	end
	if _G["NecrosisTimersConfig3"] then
		print("[Necrosis] Showing NecrosisTimersConfig3")
		_G["NecrosisTimersConfig3"]:Show()
	else
		print("[Necrosis] ERROR: NecrosisTimersConfig3 doesn't exist!")
	end
	print("[Necrosis] UpdateTimerCheckboxes() finished")
end


------------------------------------------------------------------------------------------------------
-- DROPDOWN FUNCTIONS FOR TIMER TYPE
------------------------------------------------------------------------------------------------------

function Necrosis.Timer_Init()
	local element = {}

	if not Necrosis.Config or not Necrosis.Config.Timers or not Necrosis.Config.Timers.Type then
		return
	end

	for i in ipairs(Necrosis.Config.Timers.Type) do
		element.text = Necrosis.Config.Timers.Type[i]
		element.checked = false
		element.func = Necrosis.Timer_Click
		pcall(function()
			UIDropDownMenu_AddButton(element)
		end)
	end
end

function Necrosis.Timer_Click(self)
	local ID = self:GetID()
	if ID and NecrosisTimerSelection then
		pcall(function()
			UIDropDownMenu_SetSelectedID(NecrosisTimerSelection, ID)
		end)
	end

	NecrosisConfig.TimerType = ID - 1

	if not (ID == 1) then
		if Necrosis.CreateTimerAnchor then
			pcall(function()
				Necrosis:CreateTimerAnchor()
			end)
		end
	end

	if ID == 1 then -- Disable Timer
		if NecrosisTimerUpward then NecrosisTimerUpward:Disable() end
		if NecrosisTimerOnLeft then NecrosisTimerOnLeft:Disable() end
		if _G["NecrosisListSpells"] then
			_G["NecrosisListSpells"]:SetText("")
		end
		local index = 1
		while _G["NecrosisTimerFrame"..index] do
			_G["NecrosisTimerFrame"..index]:Hide()
			index = index + 1
		end
	elseif ID == 3 then -- Timer Texture Text
		if NecrosisTimerUpward then NecrosisTimerUpward:Disable() end
		if NecrosisTimerOnLeft then NecrosisTimerOnLeft:Enable() end
		local index = 1
		while _G["NecrosisTimerFrame"..index] do
			_G["NecrosisTimerFrame"..index]:Hide()
			index = index + 1
		end
	else -- Timer graphique
		if Necrosis.SetupBuffTimers then
			pcall(function()
				SetupBuffTimers()
			end)
		end
		if _G["NecrosisListSpells"] then
			_G["NecrosisListSpells"]:SetText("")
		end
	end
end
