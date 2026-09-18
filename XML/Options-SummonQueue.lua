local _G = getfenv(0)
local AddonName, SAO = ...
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

-- ========================================
-- HELPER FUNCTIONS
-- ========================================

local function CreateCheckbox(parent, name, label, x, y, value, callback)
	local btn = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
	btn:SetWidth(24)
	btn:SetHeight(24)
	btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	btn:SetChecked(value)
	btn:SetScript("OnClick", callback)

	local labelStr = parent:CreateFontString(nil, nil, "GameFontNormalSmall")
	labelStr:SetPoint("LEFT", btn, "RIGHT", 5, 1)
	labelStr:SetText(label)
	labelStr:SetTextColor(1, 1, 1)

	return btn
end

local function CreateSlider(parent, name, minVal, maxVal, x, y, value, callback)
	local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
	slider:SetMinMaxValues(minVal, maxVal)
	slider:SetValueStep(1)
	slider:SetObeyStepOnDrag(true)
	slider:SetStepsPerPage(1)
	slider:SetWidth(150)
	slider:SetHeight(15)
	slider:SetValue(value)
	slider:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

	-- Customize slider appearance
	local track = slider:CreateTexture(nil, "BACKGROUND")
	track:SetWidth(150)
	track:SetHeight(4)
	track:SetColorTexture(0.2, 0.2, 0.2, 1)
	track:SetPoint("CENTER", slider, "CENTER", 0, 0)

	local thumb = slider:GetThumbTexture()
	if thumb then
		thumb:SetTexture("Interface\\Common\\Indicator-Yellow")
		thumb:SetColorTexture(1, 0.8, 0, 1)
		thumb:SetSize(6, 6)
	end

	slider:SetScript("OnValueChanged", callback)
	return slider
end

local function CreateSectionTitle(parent, text, y)
	local title = parent:CreateFontString(nil, nil, "GameFontNormalSmall")
	title:SetPoint("TOPLEFT", parent, "TOPLEFT", 40, y)
	title:SetText(text)
	title:SetTextColor(1, 0.8, 0)
	return title
end

local function CreateSeparator(parent, y)
	local sep = parent:CreateTexture(nil, "BACKGROUND")
	sep:SetWidth(280)
	sep:SetHeight(1)
	sep:SetColorTexture(0.4, 0.4, 0.4, 0.5)
	sep:SetPoint("TOPLEFT", parent, "TOPLEFT", 40, y)
	return sep
end

-- ========================================
-- MAIN CONFIGURATION FUNCTION
-- ========================================

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
		-- ========================================
		-- MAIN FRAME
		-- ========================================
		frame = CreateFrame("Frame", "NecrosisSummonQueueConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(380)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Title
		local title = frame:CreateFontString(nil, nil, "GameFontNormalLarge")
		title:SetPoint("TOP", frame, "TOP", 50, 5)
		title:SetText(L["SUMMON_QUEUE_LABEL"] or "Summon Queue")
		title:SetTextColor(1, 0.8, 0)

		-- ========================================
		-- SECTION 1: GENERAL SETTINGS
		-- ========================================
		CreateSectionTitle(frame, L["ENABLED"] or "General", -25)

		CreateCheckbox(frame, "NecrosisSQEnabled", L["ENABLED"] or "Enabled", 40, -45,
			NecrosisConfig.SummonQueue.Enabled, function(self)
				NecrosisConfig.SummonQueue.Enabled = self:GetChecked()
				SummonQueue.Enabled = self:GetChecked()
			end)

		-- ========================================
		-- SECTION 2: TRIGGER CODE
		-- ========================================
		CreateSeparator(frame, -70)
		CreateSectionTitle(frame, L["SUMMON_QUEUE_TRIGGER"] or "Trigger", -90)

		local triggerLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		triggerLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -110)
		triggerLabel:SetText(L["SUMMON_QUEUE_TRIGGER"] or "Trigger Code (comma separated):")
		triggerLabel:SetTextColor(0.9, 0.9, 0.9)

		-- Input box background
		local triggerBg = CreateFrame("Frame", "NecrosisSQTriggerBg", frame, "BackdropTemplate")
		triggerBg:SetSize(250, 24)
		triggerBg:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -135)
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

		-- Info text
		local triggerInfo = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		triggerInfo:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -160)
		triggerInfo:SetWidth(280)
		triggerInfo:SetJustifyH("LEFT")
		triggerInfo:SetWordWrap(true)
		triggerInfo:SetText(L["SUMMON_QUEUE_TRIGGER_DESC"] or "Separate codes with commas:\n123, inv, summon")
		triggerInfo:SetTextColor(0.8, 0.8, 0.8)

		-- ========================================
		-- SECTION 3 & 4: OPTIONS & SETTINGS (2 COLUMNS)
		-- ========================================
		CreateSeparator(frame, -190)

		-- LEFT COLUMN: OPTIONS (CHECKBOXES)
		CreateSectionTitle(frame, L["OPTIONS"] or "Options", -210)

		CreateCheckbox(frame, "NecrosisSQAutoRemove", L["SUMMON_QUEUE_AUTO_REMOVE"] or "Auto-remove in range",
			40, -230, NecrosisConfig.SummonQueue.AutoRemoveInRange, function(self)
				NecrosisConfig.SummonQueue.AutoRemoveInRange = self:GetChecked()
			end)

		CreateCheckbox(frame, "NecrosisSQAudio", L["SUMMON_QUEUE_AUDIO"] or "Audio alert on new summon",
			40, -260, NecrosisConfig.SummonQueue.AudioAlert, function(self)
				NecrosisConfig.SummonQueue.AudioAlert = self:GetChecked()
			end)

		CreateCheckbox(frame, "NecrosisSQSync", L["SUMMON_QUEUE_SYNC"] or "Sync with raid",
			40, -290, NecrosisConfig.SummonQueue.SyncEnabled, function(self)
				NecrosisConfig.SummonQueue.SyncEnabled = self:GetChecked()
			end)

		-- RIGHT COLUMN: SETTINGS (SLIDERS)
		local settingsTitle = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		settingsTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 250, -210)
		settingsTitle:SetText(L["SETTINGS"] or "Settings")
		settingsTitle:SetTextColor(1, 0.8, 0)

		local maxLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		maxLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 250, -230)
		maxLabel:SetText(L["SUMMON_QUEUE_MAX_SIZE"] or "Max queue size:")
		maxLabel:SetTextColor(1, 1, 1)

		CreateSlider(frame, "NecrosisSQMaxSize", 5, 50, 250, -240,
			NecrosisConfig.SummonQueue.MaxQueueSize or 20, function(self, value)
				NecrosisConfig.SummonQueue.MaxQueueSize = value
			end)

		local rangeLabel = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		rangeLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 250, -270)
		rangeLabel:SetText(L["SUMMON_QUEUE_RANGE_CHECK"] or "Range check interval (s):")
		rangeLabel:SetTextColor(1, 1, 1)

		CreateSlider(frame, "NecrosisSQRange", 1, 10, 250, -280,
			NecrosisConfig.SummonQueue.RangeCheckInterval or 2, function(self, value)
				NecrosisConfig.SummonQueue.RangeCheckInterval = value
			end)

		-- ========================================
		-- SECTION 5: ACTION BUTTONS (on same line as Enabled)
		-- ========================================
		local showBtn = CreateFrame("Button", "NecrosisSQShow", frame, "UIPanelButtonTemplate")
		showBtn:SetWidth(90)
		showBtn:SetHeight(22)
		showBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 150, -45)
		showBtn:SetText(L["SUMMON_QUEUE_SHOW"] or "Show Queue")
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

		local clearBtn = CreateFrame("Button", "NecrosisSQClear", frame, "UIPanelButtonTemplate")
		clearBtn:SetWidth(90)
		clearBtn:SetHeight(22)
		clearBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 250, -45)
		clearBtn:SetText(L["SUMMON_QUEUE_CLEAR"] or "Clear")
		clearBtn:SetScript("OnClick", function()
			SummonQueue:ClearQueue()
			print("|cFF00FF00" .. L["SQ_QUEUE_CLEARED"] .. "|r")
		end)
	end
	NecrosisSummonQueueConfig:Show()
end
