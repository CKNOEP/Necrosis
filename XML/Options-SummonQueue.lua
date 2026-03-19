local _G = getfenv(0)
local AddonName, SAO = ...
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

function Necrosis:SetSummonQueueConfig()
	-- Ensure SummonQueue config exists
	if not NecrosisConfig.SummonQueue then
		NecrosisConfig.SummonQueue = {
			Enabled = true,
			TriggerCode = "123, summon, inv, +1",
			AutoRemoveInRange = true,
			AudioAlert = true,
			ShowGUI = false,
			MaxQueueSize = 50,
			SyncEnabled = true,
			RangeCheckInterval = 2,
			Position = {"CENTER", "UIParent", "CENTER", 0, 100},
		}
	end

	local frame = _G["NecrosisSummonQueueConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisSummonQueueConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Titre
		local title = frame:CreateFontString(nil, nil, "GameFontNormalLarge")
		title:SetPoint("TOP", frame, "TOP", 50, -25)
		title:SetText(L["SUMMON_QUEUE_LABEL"] or "Summon Queue")
		title:SetTextColor(1, 0.8, 0)

		-- Enabled checkbox
		local enableBtn = CreateFrame("CheckButton", "NecrosisSQEnabled", frame, "UICheckButtonTemplate")
		enableBtn:SetWidth(24)
		enableBtn:SetHeight(24)
		enableBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -50)
		enableBtn:SetChecked(NecrosisConfig.SummonQueue.Enabled)
		enableBtn:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.Enabled = self:GetChecked()
			if self:GetChecked() then
				SummonQueue.Enabled = true
			else
				SummonQueue.Enabled = false
			end
		end)

		local enableLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		enableLabel:SetPoint("LEFT", enableBtn, "RIGHT", 5, 1)
		enableLabel:SetText(L["ENABLED"] or "Enabled")
		enableLabel:SetTextColor(1, 1, 1)

		-- Trigger Code input
		local triggerLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		triggerLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -80)
		triggerLabel:SetText(L["SUMMON_QUEUE_TRIGGER"] or "Trigger Code (comma separated):")
		triggerLabel:SetTextColor(1, 1, 1)

		-- Backdrop for input box
		local triggerBg = CreateFrame("Frame", "NecrosisSQTriggerBg", frame, "BackdropTemplate")
		triggerBg:SetSize(250, 24)
		triggerBg:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -105)
		triggerBg:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 2, right = 2, top = 2, bottom = 2 }
		})
		triggerBg:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
		triggerBg:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)

		local triggerInput = CreateFrame("EditBox", "NecrosisSQTrigger", triggerBg)
		triggerInput:SetAutoFocus(false)
		triggerInput:SetPoint("TOPLEFT", triggerBg, "TOPLEFT", 4, -4)
		triggerInput:SetPoint("BOTTOMRIGHT", triggerBg, "BOTTOMRIGHT", -4, 4)
		triggerInput:SetFont("Fonts/FRIZQT__.TTF", 11, "")
		triggerInput:SetTextColor(1, 1, 1)
		triggerInput:SetText(NecrosisConfig.SummonQueue.TriggerCode or "123, summon, inv, +1")
		triggerInput:SetScript("OnEnterPressed", function(self)
			NecrosisConfig.SummonQueue.TriggerCode = self:GetText()
			self:ClearFocus()
		end)
		triggerInput:SetScript("OnEscapePressed", function(self)
			self:SetText(NecrosisConfig.SummonQueue.TriggerCode or "123, summon, inv, +1")
			self:ClearFocus()
		end)

		-- Info text for trigger codes
		local triggerInfo = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		triggerInfo:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -130)
		triggerInfo:SetWidth(280)
		triggerInfo:SetJustifyH("LEFT")
		triggerInfo:SetWordWrap(true)
		triggerInfo:SetText(L["SUMMON_QUEUE_TRIGGER_DESC"] or "Separate codes with commas:\n123, inv, summon")
		triggerInfo:SetTextColor(0.8, 0.8, 0.8)

		-- Auto Remove In Range checkbox
		local autoRemoveBtn = CreateFrame("CheckButton", "NecrosisSQAutoRemove", frame, "UICheckButtonTemplate")
		autoRemoveBtn:SetWidth(24)
		autoRemoveBtn:SetHeight(24)
		autoRemoveBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -170)
		autoRemoveBtn:SetChecked(NecrosisConfig.SummonQueue.AutoRemoveInRange)
		autoRemoveBtn:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.AutoRemoveInRange = self:GetChecked()
		end)

		local autoRemoveLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		autoRemoveLabel:SetPoint("LEFT", autoRemoveBtn, "RIGHT", 5, 1)
		autoRemoveLabel:SetText(L["SUMMON_QUEUE_AUTO_REMOVE"] or "Auto-remove in range")
		autoRemoveLabel:SetTextColor(1, 1, 1)

		-- Audio Alert checkbox
		local audioBtn = CreateFrame("CheckButton", "NecrosisSQAudio", frame, "UICheckButtonTemplate")
		audioBtn:SetWidth(24)
		audioBtn:SetHeight(24)
		audioBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -200)
		audioBtn:SetChecked(NecrosisConfig.SummonQueue.AudioAlert)
		audioBtn:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.AudioAlert = self:GetChecked()
		end)

		local audioLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		audioLabel:SetPoint("LEFT", audioBtn, "RIGHT", 5, 1)
		audioLabel:SetText(L["SUMMON_QUEUE_AUDIO"] or "Audio alert on new summon")
		audioLabel:SetTextColor(1, 1, 1)

		-- Sync Enabled checkbox
		local syncBtn = CreateFrame("CheckButton", "NecrosisSQSync", frame, "UICheckButtonTemplate")
		syncBtn:SetWidth(24)
		syncBtn:SetHeight(24)
		syncBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -230)
		syncBtn:SetChecked(NecrosisConfig.SummonQueue.SyncEnabled)
		syncBtn:SetScript("OnClick", function(self)
			NecrosisConfig.SummonQueue.SyncEnabled = self:GetChecked()
		end)

		local syncLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		syncLabel:SetPoint("LEFT", syncBtn, "RIGHT", 5, 1)
		syncLabel:SetText(L["SUMMON_QUEUE_SYNC"] or "Sync with raid")
		syncLabel:SetTextColor(1, 1, 1)

		-- Max Queue Size slider
		local maxSizeLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		maxSizeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -270)
		maxSizeLabel:SetText(L["SUMMON_QUEUE_MAX_SIZE"] or "Max queue size:")
		maxSizeLabel:SetTextColor(1, 1, 1)

		local maxSizeSlider = CreateFrame("Slider", "NecrosisSQMaxSize", frame, "OptionsSliderTemplate")
		maxSizeSlider:SetMinMaxValues(5, 50)
		maxSizeSlider:SetValueStep(1)
		maxSizeSlider:SetObeyStepOnDrag(true)
		maxSizeSlider:SetStepsPerPage(1)
		maxSizeSlider:SetWidth(150)
		maxSizeSlider:SetHeight(15)
		maxSizeSlider:SetValue(NecrosisConfig.SummonQueue.MaxQueueSize or 20)
		maxSizeSlider:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -295)

		-- Create slider visual elements for MaxSize
		local maxTrack = maxSizeSlider:CreateTexture(nil, "BACKGROUND")
		maxTrack:SetWidth(150)
		maxTrack:SetHeight(4)
		maxTrack:SetColorTexture(0.2, 0.2, 0.2, 1)
		maxTrack:SetPoint("CENTER", maxSizeSlider, "CENTER", 0, 0)

		-- Style the thumb/cursor
		local maxThumb = maxSizeSlider:GetThumbTexture()
		if maxThumb then
			maxThumb:SetTexture("Interface\\Common\\Indicator-Yellow")
			maxThumb:SetColorTexture(1, 0.8, 0, 1)
			maxThumb:SetSize(6, 6)
		end

		maxSizeSlider:SetScript("OnValueChanged", function(self, value)
			NecrosisConfig.SummonQueue.MaxQueueSize = value
		end)

		-- Range Check Interval slider
		local rangeLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		rangeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -340)
		rangeLabel:SetText(L["SUMMON_QUEUE_RANGE_CHECK"] or "Range check interval (seconds):")
		rangeLabel:SetTextColor(1, 1, 1)

		local rangeSlider = CreateFrame("Slider", "NecrosisSQRange", frame, "OptionsSliderTemplate")
		rangeSlider:SetMinMaxValues(1, 10)
		rangeSlider:SetValueStep(1)
		rangeSlider:SetObeyStepOnDrag(true)
		rangeSlider:SetStepsPerPage(1)
		rangeSlider:SetWidth(150)
		rangeSlider:SetHeight(15)
		rangeSlider:SetValue(NecrosisConfig.SummonQueue.RangeCheckInterval or 2)
		rangeSlider:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -365)

		-- Create slider visual elements for Range
		local rangeTrack = rangeSlider:CreateTexture(nil, "BACKGROUND")
		rangeTrack:SetWidth(150)
		rangeTrack:SetHeight(4)
		rangeTrack:SetColorTexture(0.2, 0.2, 0.2, 1)
		rangeTrack:SetPoint("CENTER", rangeSlider, "CENTER", 0, 0)

		-- Style the thumb/cursor
		local rangeThumb = rangeSlider:GetThumbTexture()
		if rangeThumb then
			rangeThumb:SetTexture("Interface\\Common\\Indicator-Yellow")
			rangeThumb:SetColorTexture(1, 0.8, 0, 1)
			rangeThumb:SetSize(6, 6)
		end

		rangeSlider:SetScript("OnValueChanged", function(self, value)
			NecrosisConfig.SummonQueue.RangeCheckInterval = value
		end)

		-- Show Queue Window button (toggle)
		local showBtn = CreateFrame("Button", "NecrosisSQShow", frame, "UIPanelButtonTemplate")
		showBtn:SetWidth(100)
		showBtn:SetHeight(22)
		showBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 40, 20)
		showBtn:SetText(L["SUMMON_QUEUE_SHOW"] or "Show Window")
		showBtn:SetScript("OnClick", function()
			if not SummonQueue.Window then
				SummonQueue:CreateQueueWindow()
				SummonQueue.Window:Show()
			elseif SummonQueue.Window:IsVisible() then
				SummonQueue.Window:Hide()
			else
				SummonQueue.Window:Show()
			end
		end)

		-- Clear Queue button
		local clearBtn = CreateFrame("Button", "NecrosisSQClear", frame, "UIPanelButtonTemplate")
		clearBtn:SetWidth(100)
		clearBtn:SetHeight(22)
		clearBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 150, 20)
		clearBtn:SetText(L["SUMMON_QUEUE_CLEAR"] or "Clear")
		clearBtn:SetScript("OnClick", function()
			SummonQueue:ClearQueue()
			print("|cFF00FF00" .. L["SQ_QUEUE_CLEARED"] .. "|r")
		end)
	end
	NecrosisSummonQueueConfig:Show()
end
