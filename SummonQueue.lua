----------------------------------------------
-- Summon Queue Module for Necrosis
-- Warlock summoning queue management with cross-addon synchronization
----------------------------------------------

SummonQueue = CreateFrame("Frame")
_G.SummonQueue = SummonQueue
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

-- Cache global variables
local _G = _G
local tostring, pcall = tostring, pcall
local format = format
local table = table

-- WoW API / Variables
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitName = UnitName
local GetTime = GetTime
local PlaySound = PlaySound
local SendAddonMessage = SendAddonMessage
local CheckInteractDistance = CheckInteractDistance

local AceComm = LibStub("AceComm-3.0")

-- Module state
SummonQueue.Queue = {}
SummonQueue.Enabled = true
SummonQueue.Window = nil
SummonQueue.LastBroadcastTime = 0
SummonQueue.LastRangeCheckTime = 0
SummonQueue.ActionButtonCounter = 0

----------------------------------------------
-- Initialization
----------------------------------------------

function SummonQueue:Init()
	-- Register addon communication
	AceComm:RegisterComm("NecSummon", function(prefix, message, channel, sender)
		self:ReceiveSyncMessage(message, sender)
	end)

	-- Initialize configuration defaults
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

	-- Create the queue window if enabled
	if NecrosisConfig.SummonQueue.ShowGUI then
		self:CreateQueueWindow()
	end

	-- Register events
	self:RegisterEvent("CHAT_MSG_SAY")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("CHAT_MSG_RAID")
	self:RegisterEvent("CHAT_MSG_RAID_LEADER")
	self:RegisterEvent("CHAT_MSG_YELL")
	self:RegisterEvent("CHAT_MSG_WHISPER")

	-- Set up event handler
	self:SetScript("OnEvent", function(frame, event, ...)
		frame:OnEvent(event, ...)
	end)

	-- Set up OnUpdate for range checking
	self:SetScript("OnUpdate", function(frame, elapsed)
		frame:OnUpdate(elapsed)
	end)

	self.Enabled = NecrosisConfig.SummonQueue.Enabled or true
end

----------------------------------------------
-- Event Handling
----------------------------------------------

function SummonQueue:OnEvent(event, ...)
	if not self.Enabled then
		return
	end

	if event:match("^CHAT_MSG_") then
		local message, sender = ...
		self:ProcessChatMessage(message, sender)
	end
end

function SummonQueue:OnUpdate(elapsed)
	if not self.Enabled or not NecrosisConfig or not NecrosisConfig.SummonQueue or not NecrosisConfig.SummonQueue.AutoRemoveInRange then
		return
	end

	-- Check range every N seconds
	self.LastRangeCheckTime = self.LastRangeCheckTime + elapsed
	local checkInterval = NecrosisConfig.SummonQueue.RangeCheckInterval or 2

	if self.LastRangeCheckTime >= checkInterval then
		self.LastRangeCheckTime = 0
		self:CheckQueuedPlayersInRange()
	end
end

function SummonQueue:ProcessChatMessage(message, sender)
	local triggerCodes = NecrosisConfig.SummonQueue.TriggerCode or "123"

	-- Clean up message (trim whitespace)
	local cleanMessage = message:match("^%s*(.-)%s*$")
	if not cleanMessage or cleanMessage == "" then
		return
	end

	-- Split trigger codes by comma and check each one
	for code in triggerCodes:gmatch("[^,]+") do
		-- Trim whitespace from each code
		code = code:match("^%s*(.-)%s*$")
		-- Match exact trigger code (case-insensitive)
		if code ~= "" and cleanMessage:lower() == code:lower() then
			self:AddToQueue(sender)
			return
		end
	end
end

----------------------------------------------
-- Queue Management
----------------------------------------------

function SummonQueue:AddToQueue(player)
	if not self:IsInQueue(player) then
		-- Check max queue size
		if #self.Queue >= (NecrosisConfig.SummonQueue.MaxQueueSize or 20) then
			print("|cFFFF0000" .. L["SQ_QUEUE_FULL"] .. "|r")
			return
		end

		table.insert(self.Queue, player)
		print("|cFF00FF00" .. format(L["SQ_ADDED_TO_QUEUE"], player) .. "|r")

		-- Play audio alert
		if NecrosisConfig.SummonQueue.AudioAlert then
			PlaySound(8959) -- Quest Complete sound
		end

		-- Broadcast sync message
		if NecrosisConfig.SummonQueue.SyncEnabled then
			self:BroadcastQueue("add", player)
		end

		-- Open queue window if not already open
		if not self.Window then
			self:CreateQueueWindow()
		end
		if self.Window and not self.Window:IsVisible() then
			self.Window:Show()
		end

		-- Update display
		if self.Window then
			self:UpdateQueueDisplay()
		end
	end
end

function SummonQueue:RemoveFromQueue(player)
	for i, p in ipairs(self.Queue) do
		if p == player then
			table.remove(self.Queue, i)

			-- Broadcast sync message
			if NecrosisConfig.SummonQueue.SyncEnabled then
				self:BroadcastQueue("remove", player)
			end

			-- Update display
			if self.Window then
				self:UpdateQueueDisplay()
			end
			return
		end
	end
end

function SummonQueue:IsInQueue(player)
	for _, p in ipairs(self.Queue) do
		if p == player then
			return true
		end
	end
	return false
end

function SummonQueue:ClearQueue()
	self.Queue = {}
	if self.Window then
		self:UpdateQueueDisplay()
	end
end

----------------------------------------------
-- Synchronization via AceComm
----------------------------------------------

function SummonQueue:BroadcastQueue(action, player)
	-- Throttle broadcasts to avoid spam
	local currentTime = GetTime()
	if currentTime - self.LastBroadcastTime < 0.1 then
		return
	end
	self.LastBroadcastTime = currentTime

	local message = format("%s|%s", action, player)
	AceComm:SendCommMessage("NecSummon", message, "RAID")
end

function SummonQueue:ReceiveSyncMessage(message, sender)
	if not message or message == "" then
		return
	end

	-- Parse message format: "action|player"
	local action, player = message:match("^([^|]+)|(.+)$")
	if not action or not player then
		return
	end

	if action == "add" then
		self:AddToQueue(player)
	elseif action == "remove" then
		self:RemoveFromQueue(player)
	end
end

----------------------------------------------
-- GUI Window
----------------------------------------------

function SummonQueue:CreateQueueWindow()
	if self.Window then
		return
	end

	-- Main window frame
	local frame = CreateFrame("Frame", "SummonQueueFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	frame:SetSize(250, 400)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		-- Save position
		if NecrosisConfig and NecrosisConfig.SummonQueue then
			NecrosisConfig.SummonQueue.Position = {
				self:GetPoint(1)
			}
		end
	end)

	-- Set initial position
	local pos = NecrosisConfig.SummonQueue.Position or {"CENTER", "UIParent", "CENTER", 0, 100}
	frame:SetPoint(pos[1], pos[2], pos[3], pos[4], pos[5])

	-- Set backdrop
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	frame:SetBackdropColor(0.06, 0.06, 0.06, 0.8)
	frame:SetBackdropBorderColor(0.31, 0.31, 0.31)

	-- Title bar
	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
	title:SetText(L["SUMMON_QUEUE_LABEL"] or "Summon Queue")

	-- Close button
	local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
	closeBtn:SetScript("OnClick", function()
		frame:Hide()
	end)

	-- Scroll area (placeholder for now)
	local scrollArea = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -26, 36)

	-- Content frame for scroll
	local content = CreateFrame("Frame", nil, scrollArea)
	scrollArea:SetScrollChild(content)
	content:SetSize(scrollArea:GetWidth(), 1)

	frame.scrollArea = scrollArea
	frame.content = content
	frame.title = title

	-- Clear button
	local clearBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	clearBtn:SetWidth(100)
	clearBtn:SetHeight(22)
	clearBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 8)
	clearBtn:SetText(L["SUMMON_QUEUE_CLEAR"] or "Clear")
	clearBtn:SetScript("OnClick", function()
		SummonQueue:ClearQueue()
	end)

	self.Window = frame
	self:UpdateQueueDisplay()
end

function SummonQueue:UpdateQueueDisplay()
	if not self.Window then return end

	local scrollArea = self.Window.scrollArea

	-- Destroy old content frame
	if self.Window.content then
		self.Window.content:Hide()
		self.Window.content = nil
	end

	-- Create new content frame
	local content = CreateFrame("Frame", nil, scrollArea)
	scrollArea:SetScrollChild(content)
	content:SetSize(scrollArea:GetWidth(), 1)
	self.Window.content = content

	-- Display empty message
	if #self.Queue == 0 then
		local emptyText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		emptyText:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -4)
		emptyText:SetText(L["SUMMON_QUEUE_EMPTY"] or "Queue is empty")
		emptyText:SetTextColor(0.7, 0.7, 0.7)
		return
	end

	-- Display queue items
	local yOffset = -4
	for i, player in ipairs(self.Queue) do
		-- Extract character name (without server name after hyphen)
		local charName = player:match("^([^-]+)")
		if not charName then
			charName = player
		end

		local itemHeight = 20
		local item = CreateFrame("Frame", nil, content)
		item:SetSize(content:GetWidth() - 8, itemHeight)
		item:SetPoint("TOPLEFT", content, "TOPLEFT", 4, yOffset)

		local text = item:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		text:SetPoint("LEFT", item, "LEFT", 5, 0)
		text:SetText(format("%d. %s", i, player))
		text:SetTextColor(1, 1, 1)

		-- Summon button on the right (small icon button)
		local summonBtn = CreateFrame("Button", nil, item, "SecureUnitButtonTemplate")
		summonBtn:SetSize(16, 16)
		summonBtn:SetPoint("RIGHT", item, "RIGHT", -5, 0)
		summonBtn:EnableMouse(true)
		summonBtn:RegisterForClicks("AnyUp")

		-- Add custom SummonQueue icon (fill entire button)
		local iconTexture = summonBtn:CreateTexture(nil, "BORDER")
		iconTexture:SetTexture("Interface\\AddOns\\Necrosis\\UI\\SummonQueue-Icon.png")
		iconTexture:SetAllPoints(summonBtn)

		-- Get the spell name for Ritual of Summoning
		local spellName = GetSpellInfo(698) -- Ritual of Summoning (localized)

		-- Configure LEFT CLICK = target only
		summonBtn:SetAttribute("type1", "macro")
		summonBtn:SetAttribute("macrotext1", "/target " .. charName)

		-- Configure RIGHT CLICK = target + cast ritual
		if spellName then
			summonBtn:SetAttribute("type2", "macro")
			summonBtn:SetAttribute("macrotext2", "/target " .. charName .. "\n/cast " .. spellName)
		end

		-- Tooltip
		summonBtn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetText(charName, 1, 1, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cFFFFFF00" .. format(L["SQ_LEFT_CLICK"], charName) .. "|r", 1, 1, 1)
			if spellName then
				GameTooltip:AddLine("|cFFFFFF00" .. format(L["SQ_RIGHT_CLICK"], spellName) .. "|r", 1, 1, 1)
			end
			GameTooltip:Show()
		end)
		summonBtn:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		yOffset = yOffset - itemHeight

		-- Update content height
		content:SetHeight(-yOffset)
	end
end

----------------------------------------------
-- Range Check and Auto-Remove
----------------------------------------------

function SummonQueue:IsInSummonRange(unit)
	return UnitExists(unit) and CheckInteractDistance(unit, 4)
end

function SummonQueue:CheckQueuedPlayersInRange()
	local toRemove = {}

	for i, player in ipairs(self.Queue) do
		if UnitExists(player) and self:IsInSummonRange(player) then
			table.insert(toRemove, player)
		end
	end

	for _, player in ipairs(toRemove) do
		self:RemoveFromQueue(player)
	end
end

----------------------------------------------
-- Class Gate - Only load for Warlocks
----------------------------------------------

-- Helper function to invoke a player with Ritual of Summoning
function SummonQueue:InvokeSummon(playerName)
	if not playerName or playerName == "" then
		return
	end

	-- Extract just the character name (before the server name separated by -)
	local charName = playerName:match("^([^-]+)")
	if not charName then
		charName = playerName
	end

	print("|cFF00FF00" .. format(L["SQ_INVOKING"], playerName) .. "|r")

	-- Get the localized spell name using spell ID 698 (Ritual of Summoning / Rituel d'invocation)
	local spellName = GetSpellInfo(698)

	if not spellName then
		print("|cFFFF0000" .. L["SQ_SPELL_NOT_FOUND"] .. "|r")
		return
	end

	-- Create a macro in the spellbook to target and cast
	local macroName = "_SQ_" .. charName:upper()
	local macroBody = "/target " .. charName .. "\n/cast " .. spellName

	-- Delete old macro if it exists
	for i = 1, GetNumMacros() do
		local name = GetMacroInfo(i)
		if name == macroName then
			DeleteMacro(i)
			break
		end
	end

	-- Create new macro
	local macroIndex = CreateMacro(macroName, 1, macroBody, false)
	if macroIndex then
		print("|cFF00FF00" .. format(L["SQ_MACRO_CREATED"], macroName) .. "|r")
		print("|cFFFFFF00" .. format(L["SQ_MACRO_INFO"], charName, spellName) .. "|r")
		-- The user needs to click the macro or we can try to trigger it via a button
		-- For now, just inform the user
		print("|cFFFFFF00" .. format(L["SQ_MACRO_CLICK"], macroName) .. "|r")
	else
		print("|cFFFF0000" .. L["SQ_MACRO_FULL"] .. "|r")
	end
end

----------------------------------------------
-- Test Function - Fill queue with 10 test players
----------------------------------------------

function SummonQueue:FillTestQueue()
	self:ClearQueue()

	local testPlayers = {
		"Player1", "Player2", "Player3", "Player4", "Player5",
		"Player6", "Player7", "Player8", "Player9", "Player10",
		"Player11", "Player12", "Player13", "Player14", "Player15",
		"Player16", "Player17", "Player18", "Player19", "Player20",
		"Player21", "Player22", "Player23", "Player24", "Player25",
		"Player26", "Player27", "Player28", "Player29", "Player30",
	}

	for _, playerName in ipairs(testPlayers) do
		self:AddToQueue(playerName)
	end

	print("|cFF00FF00" .. L["SQ_TEST_FILLED"] .. "|r")
end

-- Slash command for testing
SLASH_SUMMONQUEUETEST1 = "/sqtest"
SlashCmdList["SUMMONQUEUETEST"] = function(msg)
	if msg == "fill" then
		SummonQueue:FillTestQueue()
	elseif msg == "clear" then
		SummonQueue:ClearQueue()
		print("|cFF00FF00" .. L["SQ_QUEUE_CLEARED"] .. "|r")
	else
		print("|cFFFFFF00" .. L["SQ_COMMANDS_HEADER"] .. "|r")
		print("|cFF00FF00  /sqtest fill|r - " .. L["SQ_COMMAND_FILL"])
		print("|cFF00FF00  /sqtest clear|r - " .. L["SQ_COMMAND_CLEAR"])
	end
end

-- Delay initialization until player data is available
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function()
	initFrame:UnregisterEvent("PLAYER_LOGIN")
	local _, playerClass = UnitClass("player")
	if playerClass == "WARLOCK" then
		SummonQueue:Init()
	end
end)
