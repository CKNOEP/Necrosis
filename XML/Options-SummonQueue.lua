--[[
    Necrosis
    Copyright (C) - copyright file included in this release
--]]

local _G = getfenv(0)
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OPTIONS SUMMON QUEUE
------------------------------------------------------------------------------------------------------

function Necrosis:SetSummonQueueConfig()

	local frame = _G["NecrosisSummonQueueConfig"]
	if not frame then
		local y = -35
		local y_offset = -23
		local x_offset = 30

		-- Create the main frame
		frame = CreateFrame("Frame", "NecrosisSummonQueueConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Enable/Disable Summon Queue
		frame = CreateFrame("CheckButton", "NecrosisSummonQueueEnable", NecrosisSummonQueueConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisSummonQueueConfig, "TOPLEFT", x_offset, y)
		frame:SetChecked(NecrosisConfig.SummonQueue.Enabled or true)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.Enabled = self:GetChecked()
			if self:GetChecked() then
				SummonQueue.Enabled = true
			else
				SummonQueue.Enabled = false
			end
		end)

		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(L["SUMMON_QUEUE_ENABLED"] or "Enable Summon Queue")
		frame:SetFontString(FontString)

		-- Trigger Code
		y = y + y_offset
		local triggerLabel = NecrosisSummonQueueConfig:CreateFontString(nil, nil, "GameFontNormalSmall")
		triggerLabel:Show()
		triggerLabel:ClearAllPoints()
		triggerLabel:SetPoint("LEFT", NecrosisSummonQueueConfig, "TOPLEFT", x_offset, y)
		triggerLabel:SetTextColor(1, 1, 1)
		triggerLabel:SetText(L["SUMMON_QUEUE_TRIGGER"] or "Trigger Code")

		y = y - 20
		local triggerEdit = CreateFrame("EditBox", "NecrosisSummonQueueTrigger", NecrosisSummonQueueConfig, "InputBoxTemplate")
		triggerEdit:SetWidth(200)
		triggerEdit:SetHeight(20)
		triggerEdit:Show()
		triggerEdit:ClearAllPoints()
		triggerEdit:SetPoint("LEFT", NecrosisSummonQueueConfig, "TOPLEFT", x_offset, y)
		triggerEdit:SetText(NecrosisConfig.SummonQueue.TriggerCode or "123")
		triggerEdit:SetMaxLetters(100)

		triggerEdit:SetScript("OnTextChanged", function(self)
			NecrosisConfig.SummonQueue.TriggerCode = self:GetText()
		end)

		-- Trigger Code Description
		y = y - 20
		local triggerDesc = NecrosisSummonQueueConfig:CreateFontString(nil, nil, "GameFontNormalSmall")
		triggerDesc:Show()
		triggerDesc:ClearAllPoints()
		triggerDesc:SetPoint("LEFT", NecrosisSummonQueueConfig, "TOPLEFT", x_offset*2, y)
		triggerDesc:SetTextColor(0.7, 0.7, 0.7)
		triggerDesc:SetText(L["SUMMON_QUEUE_TRIGGER_DESC"] or "Chat message to join queue")

		-- Audio Alerts
		y = y - 25
		frame = CreateFrame("CheckButton", "NecrosisSummonQueueAudio", NecrosisSummonQueueConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisSummonQueueConfig, "TOPLEFT", x_offset, y)
		frame:SetChecked(NecrosisConfig.SummonQueue.AudioAlert)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.AudioAlert = self:GetChecked()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(L["SUMMON_QUEUE_AUDIO"] or "Audio alerts")
		frame:SetFontString(FontString)

		-- Auto-Remove in Range
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisSummonQueueAutoRemove", NecrosisSummonQueueConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisSummonQueueConfig, "TOPLEFT", x_offset, y)
		frame:SetChecked(NecrosisConfig.SummonQueue.AutoRemoveInRange)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.AutoRemoveInRange = self:GetChecked()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(L["SUMMON_QUEUE_AUTO_REMOVE"] or "Auto-remove when in range")
		frame:SetFontString(FontString)

		-- Sync with Other Warlocks
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisSummonQueueSync", NecrosisSummonQueueConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisSummonQueueConfig, "TOPLEFT", x_offset, y)
		frame:SetChecked(NecrosisConfig.SummonQueue.SyncEnabled)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.SyncEnabled = self:GetChecked()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(L["SUMMON_QUEUE_SYNC"] or "Sync with other warlocks")
		frame:SetFontString(FontString)

		-- Show GUI Window
		y = y + y_offset
		frame = CreateFrame("CheckButton", "NecrosisSummonQueueShowGUI", NecrosisSummonQueueConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisSummonQueueConfig, "TOPLEFT", x_offset, y)
		frame:SetChecked(NecrosisConfig.SummonQueue.ShowGUI)

		frame:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.ShowGUI = self:GetChecked()
			if self:GetChecked() then
				if not SummonQueue.Window then
					SummonQueue:CreateQueueWindow()
				end
				SummonQueue.Window:Show()
			else
				if SummonQueue.Window then
					SummonQueue.Window:Hide()
				end
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(L["SUMMON_QUEUE_WINDOW"] or "Show queue window")
		frame:SetFontString(FontString)

	end
end
