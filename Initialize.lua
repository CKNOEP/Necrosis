--[[
    Necrosis
    Copyright (C) - copyright file included in this release
--]]

-- On définit _G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

-- ============================================================================
-- WoW Version Compatibility Wrappers (Support TBC, Wrath, Cata, MOP+)
-- ============================================================================

-- Detect WoW version
local _, _, _, tocVersion = GetBuildInfo()
local IsModernWoW = tocVersion and tocVersion >= 90000 -- WoW 9.0+ has C_Container

-- DEBUG MARKER: Confirm we're using the correct variant
-- _G["DEFAULT_CHAT_FRAME"]:AddMessage("|cFF00FF00[NECROSIS] CLASSIC VARIANT LOADED - Initialize.lua v" .. (tocVersion or "unknown") .. "|r")

-- Create compatibility wrappers for C_Container (WoW 9.0+)
if not C_Container then
    C_Container = {}
end

if not C_Container.GetContainerNumSlots then
    function C_Container.GetContainerNumSlots(container)
        return GetContainerNumSlots(container)
    end
end

if not C_Container.GetContainerItemInfo then
    function C_Container.GetContainerItemInfo(container, slot)
        return GetContainerItemInfo(container, slot)
    end
end

if not C_Container.GetContainerItemLink then
    function C_Container.GetContainerItemLink(container, slot)
        return GetContainerItemLink(container, slot)
    end
end

if not C_Container.GetContainerItemCooldown then
    function C_Container.GetContainerItemCooldown(container, slot)
        -- GetContainerItemCooldown doesn't exist in TBC, return default (no cooldown)
        if GetContainerItemCooldown then
            return GetContainerItemCooldown(container, slot)
        else
            -- TBC doesn't have this API, return no cooldown (0, 0, true)
            return 0, 0, true
        end
    end
end

-- Also create a global wrapper for direct calls
if not GetContainerItemCooldown then
    function GetContainerItemCooldown(container, slot)
        -- TBC/Vanilla don't have this API, return no cooldown
        return 0, 0, true
    end
end

if not C_Container.PickupContainerItem then
    function C_Container.PickupContainerItem(container, slot)
        return PickupContainerItem(container, slot)
    end
end

-- Create compatibility wrapper for C_Timer (WoW 9.0+)
if not C_Timer then
    C_Timer = {}
end

if not C_Timer.After then
    -- Create a fallback using AceTimer or frame-based timer
    function C_Timer.After(delay, callback)
        if Necrosis and Necrosis.TimerCount == nil then
            Necrosis.TimerCount = 0
        end
        Necrosis.TimerCount = Necrosis.TimerCount + 1
        local timerId = Necrosis.TimerCount

        -- Use frame-based OnUpdate as fallback
        local frame = CreateFrame("Frame")
        local elapsed = 0
        frame:SetScript("OnUpdate", function(self, delta)
            elapsed = elapsed + delta
            if elapsed >= delay then
                callback()
                frame:SetScript("OnUpdate", nil)
            end
        end)
    end
end

-- Load localization with fallback
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)
-- Fallback function for localization keys if they're not available yet
local function GetLocalizedString(key, default)
	if L and L[key] then
		return L[key]
	end
	return default
end

if not L then
	-- Create empty table if localization not loaded yet
	L = {}
end

-- Ensure fallback values are available if localization keys are missing
L["TOOLTIP_LEFT_CLICK"] = L["TOOLTIP_LEFT_CLICK"] or "Left Click"
L["TOOLTIP_SHIFT_LEFT_CLICK"] = L["TOOLTIP_SHIFT_LEFT_CLICK"] or "Shift+Left Click"
L["TOOLTIP_RIGHT_CLICK"] = L["TOOLTIP_RIGHT_CLICK"] or "Right Click"
L["TOOLTIP_CONFIGURATION"] = L["TOOLTIP_CONFIGURATION"] or "Configuration"
L["TOOLTIP_DRAG"] = L["TOOLTIP_DRAG"] or "Drag"
L["TOOLTIP_MOVE"] = L["TOOLTIP_MOVE"] or "Move"
L["STONE_SOULSTONE_LABEL"] = L["STONE_SOULSTONE_LABEL"] or "Soulstone: "
L["STONE_HEALTHSTONE_LABEL"] = L["STONE_HEALTHSTONE_LABEL"] or "Healthstone: "
L["STONE_SPELLSTONE_LABEL"] = L["STONE_SPELLSTONE_LABEL"] or "Spellstone: "
L["STONE_FIRESTONE_LABEL"] = L["STONE_FIRESTONE_LABEL"] or "Firestone: "
L["STONE_INFERNAL_LABEL"] = L["STONE_INFERNAL_LABEL"] or "Infernal Stone: "

-- Initialize NecrosisUI Framework
do
	local NUI = _G.NUI or {}
	if not NUI.name then
		NUI = LibStub('AceAddon-3.0'):NewAddon('NecrosisUI', 'AceEvent-3.0', 'AceConsole-3.0', 'AceSerializer-3.0')
		_G.NUI = NUI
	end

	-- Create NecrosisUI frame - this will be populated by themes
	if not _G.NecrosisUI then
		local necrosisUIFrame = CreateFrame("Frame", "NecrosisUI", UIParent)
		necrosisUIFrame:SetFrameStrata("BACKGROUND")
		necrosisUIFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
		necrosisUIFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
		necrosisUIFrame:SetHeight(256)
		necrosisUIFrame:Hide()

		-- Create bottom anchor for theme artwork positioning
		local bottomAnchor = CreateFrame("Frame", "NUI_BottomAnchor", necrosisUIFrame)
		bottomAnchor:SetAllPoints(necrosisUIFrame)
	end

	-- Implement Show/Hide methods
	function NUI:Show()
		if NecrosisUI then
			NecrosisUI:Show()
		end
	end

	function NUI:Hide()
		if NecrosisUI then
			NecrosisUI:Hide()
		end
	end

	-- Create Classic theme module
	local themeModule = NUI:NewModule('Style_Classic')
end

-- Load Classic theme after all frames are ready
C_Timer.After(0.5, function()
	if not (NUI and NecrosisUI and NUI_BottomAnchor) then
		return
	end

	local artFrame = CreateFrame('Frame', 'NUI_Art_Classic', NecrosisUI)

	-- Setup the Bottom Artwork
	artFrame:SetFrameStrata('BACKGROUND')
	artFrame:SetFrameLevel(1)
	artFrame:SetAlpha(0.7)
	-- Make it cover entire screen width
	artFrame:SetSize(GetScreenWidth() * UIParent:GetEffectiveScale(), 256)
	artFrame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 0, 0)

	artFrame.Center = artFrame:CreateTexture('NUI_Art_Classic_Center', 'BACKGROUND')
	artFrame.Center:SetTexture('Interface\\AddOns\\Necrosis\\NecrosisUI\\Themes\\Classic\\Images\\base-center')
	artFrame.Center:SetPoint('BOTTOM', artFrame, 'BOTTOM')

	artFrame.Left = artFrame:CreateTexture('NUI_Art_Classic_Left', 'BACKGROUND')
	artFrame.Left:SetTexture('Interface\\AddOns\\Necrosis\\NecrosisUI\\Themes\\Classic\\Images\\base-left1')
	artFrame.Left:SetPoint('BOTTOMRIGHT', artFrame.Center, 'BOTTOMLEFT', 0, 0)

	artFrame.FarLeft = artFrame:CreateTexture('NUI_Art_Classic_FarLeft', 'BACKGROUND')
	artFrame.FarLeft:SetTexture('Interface\\AddOns\\Necrosis\\NecrosisUI\\Themes\\Classic\\Images\\base-left2')
	artFrame.FarLeft:SetPoint('BOTTOMRIGHT', artFrame.Left, 'BOTTOMLEFT', 0, 0)
	artFrame.FarLeft:SetPoint('BOTTOMLEFT', NecrosisUI, 'BOTTOMLEFT', 0, 0)

	artFrame.Right = artFrame:CreateTexture('NUI_Art_Classic_Right', 'BACKGROUND')
	artFrame.Right:SetTexture('Interface\\AddOns\\Necrosis\\NecrosisUI\\Themes\\Classic\\Images\\base-right1')
	artFrame.Right:SetPoint('BOTTOMLEFT', artFrame.Center, 'BOTTOMRIGHT')

	artFrame.FarRight = artFrame:CreateTexture('NUI_Art_Classic_FarRight', 'BACKGROUND')
	artFrame.FarRight:SetTexture('Interface\\AddOns\\Necrosis\\NecrosisUI\\Themes\\Classic\\Images\\base-right2')
	artFrame.FarRight:SetPoint('BOTTOMLEFT', artFrame.Right, 'BOTTOMRIGHT')
	artFrame.FarRight:SetPoint('BOTTOMRIGHT', NecrosisUI, 'BOTTOMRIGHT')

end)

-- Compatibility wrapper for GetAddOnMetadata (deprecated in modern WoW)
-- Simple version storage (from TOC file)
Necrosis.Data = {
	AppName = "Necrosis",
	Version = "8.6.0",  -- Update manually when releasing
	Enabled = false,
}

Necrosis.Speech = {}
-- Initialize creature types for alert buttons (localized)
-- Note: UnitCreatureType() returns localized strings that may vary by client locale
local locale = GetLocale()
Necrosis.Unit = {}

-- Official WoW creature type translations (from LibBabble-CreatureType-3.0)
-- Includes variants to handle accent variations that may occur across game versions
Necrosis.Unit.DemonVariants = {}
Necrosis.Unit.ElementalVariants = {}
Necrosis.Unit.UndeadVariants = {}
Necrosis.Unit.MechanicalVariants = {}

if locale == "frFR" then
	Necrosis.Unit.Demon = "Démon"
	Necrosis.Unit.DemonVariants = {"Démon", "Demon"}
	Necrosis.Unit.Elemental = "Élémentaire"
	-- Include variants to handle all accent variations in WoW client versions
	Necrosis.Unit.ElementalVariants = {"Élémentaire", "Elémentaire", "Elementaire"}
	Necrosis.Unit.Undead = "Mort-vivant"
	Necrosis.Unit.UndeadVariants = {"Mort-vivant", "Mort vivant"}
elseif locale == "deDE" then
	Necrosis.Unit.Demon = "Dämon"
	Necrosis.Unit.DemonVariants = {"Dämon", "Daemon", "Damon"}
	Necrosis.Unit.Elemental = "Elementar"
	Necrosis.Unit.ElementalVariants = {"Elementar"}
	Necrosis.Unit.Undead = "Untoter"
	Necrosis.Unit.UndeadVariants = {"Untoter"}
elseif locale == "esES" or locale == "esMX" then
	Necrosis.Unit.Demon = "Demonio"
	Necrosis.Unit.DemonVariants = {"Demonio"}
	Necrosis.Unit.Elemental = "Elemental"
	Necrosis.Unit.ElementalVariants = {"Elemental"}
	Necrosis.Unit.Undead = "No-muerto"
	Necrosis.Unit.UndeadVariants = {"No-muerto", "No muerto"}
elseif locale == "itIT" then
	Necrosis.Unit.Demon = "Demone"
	Necrosis.Unit.DemonVariants = {"Demone"}
	Necrosis.Unit.Elemental = "Elementale"
	Necrosis.Unit.ElementalVariants = {"Elementale"}
	Necrosis.Unit.Undead = "Non Morto"
	Necrosis.Unit.UndeadVariants = {"Non Morto"}
elseif locale == "ptBR" then
	Necrosis.Unit.Demon = "Demônio"
	Necrosis.Unit.DemonVariants = {"Demônio", "Demonio"}
	Necrosis.Unit.Elemental = "Elemental"
	Necrosis.Unit.ElementalVariants = {"Elemental"}
	Necrosis.Unit.Undead = "Renegado"
	Necrosis.Unit.UndeadVariants = {"Renegado"}
elseif locale == "ruRU" then
	Necrosis.Unit.Demon = "Демон"
	Necrosis.Unit.DemonVariants = {"Демон"}
	Necrosis.Unit.Elemental = "Элементаль"
	Necrosis.Unit.ElementalVariants = {"Элементаль"}
	Necrosis.Unit.Undead = "Нежить"
	Necrosis.Unit.UndeadVariants = {"Нежить"}
elseif locale == "koKR" then
	Necrosis.Unit.Demon = "악마"
	Necrosis.Unit.DemonVariants = {"악마"}
	Necrosis.Unit.Elemental = "정령"
	Necrosis.Unit.ElementalVariants = {"정령"}
	Necrosis.Unit.Undead = "언데드"
	Necrosis.Unit.UndeadVariants = {"언데드"}
elseif locale == "zhCN" then
	Necrosis.Unit.Demon = "恶魔"
	Necrosis.Unit.DemonVariants = {"恶魔"}
	Necrosis.Unit.Elemental = "元素生物"
	Necrosis.Unit.ElementalVariants = {"元素生物"}
	Necrosis.Unit.Undead = "亡灵"
	Necrosis.Unit.UndeadVariants = {"亡灵"}
elseif locale == "zhTW" then
	Necrosis.Unit.Demon = "惡魔"
	Necrosis.Unit.DemonVariants = {"惡魔"}
	Necrosis.Unit.Elemental = "元素生物"
	Necrosis.Unit.ElementalVariants = {"元素生物"}
	Necrosis.Unit.Undead = "不死族"
	Necrosis.Unit.UndeadVariants = {"不死族"}
else -- enUS, enGB, etc.
	Necrosis.Unit.Demon = "Demon"
	Necrosis.Unit.DemonVariants = {"Demon"}
	Necrosis.Unit.Elemental = "Elemental"
	Necrosis.Unit.ElementalVariants = {"Elemental"}
	Necrosis.Unit.Undead = "Undead"
	Necrosis.Unit.UndeadVariants = {"Undead"}
end

-- Helper function to check if a creature type matches (handles variants)
function Necrosis.Unit:IsCreatureType(creatureType, variants)
	if not creatureType or not variants then return false end
	for _, variant in ipairs(variants) do
		if creatureType == variant then
			return true
		end
	end
	return false
end
-- Don't overwrite Translation - it's already initialized in Constants.lua
-- Necrosis.Translation = {} -- REMOVED: Preserves Constants.lua initialization

-- Don't overwrite Config - it's already initialized in Constants.lua
-- Necrosis.Config = {} -- REMOVED: Preserves Constants.lua initialization

-- IMPORTANT: Only initialize NecrosisConfig if it doesn't exist (WoW loads SavedVariables before this)
-- If we always reset it here, we lose the loaded SavedVariables!
if not NecrosisConfig then
	NecrosisConfig = {}
end


-- Any of these could generate a lot of output
Necrosis.Debug = {
	init_path 		= false, -- notable points as Necrosis starts
	events 			= false, -- various events tracked, chatty but informative; overlap with spells_cast
	spells_init 	= false, -- setting spell data and highest and helper tables
	spells_cast 	= false, -- spells as they are cast and some resulting actions and auras; overlap with events
	timers 			= false	, -- track as they are created and removed
	buttons 		= false , -- buttons and menus as they are created and updated
	bags			= false, -- what is found in bags and shard management - could be very chatty on large, full bags
	tool_tips		= false, -- spell info that goes into tool tips
	speech			= false, -- steps to produce the 'speech' when summoning
	}

--local ntooltip = CreateFrame("Frame", "NecrosisTooltip", UIParent, BackdropTemplateMixin and "GameTooltipTemplate");
-- CRITICAL FIX: Create NecrosisButton immediately with unique name!
-- The point in the name was causing click issues!
local nbutton = CreateFrame("Button", "NecrosisMainSphere_Placeholder", UIParent, "SecureUnitButtonTemplate")
-- Keep invisible - will be replaced by final button after 5s delay
nbutton:Hide()
-- Register it as NecrosisButton for the rest of the code
_G["NecrosisButton"] = nbutton
	_G["NecrosisMainSphere"] = nbutton  -- Placeholder, will be replaced later

-- Create text overlay frame IMMEDIATELY with HIGH FrameStrata so it's above the button
-- This prevents XML.lua from creating it on UIParent (which would be behind the button)
local textOverlay = CreateFrame("Frame", "NecrosisShardCountFrame_Placeholder", nbutton)  -- PARENT = nbutton!
textOverlay:SetFrameStrata("HIGH")  -- Above MEDIUM (button strata)
textOverlay:SetFrameLevel(100)
textOverlay:SetAllPoints(nbutton)  -- Cover the entire button
-- Create the FontString on this high-strata frame
local shardCount = textOverlay:CreateFontString("NecrosisShardCount", "OVERLAY", "GameFontNormal")
shardCount:SetPoint("CENTER")  -- Center in parent
shardCount:SetTextColor(1, 1, 1, 1)

-- Hide all peripheral buttons at startup - will be shown after position restoration
-- Wait 1 second to ensure all buttons are created by XML.lua first
C_Timer.After(1, function()
	local buttonNames = {
		"NecrosisFirestoneButton",
		"NecrosisSpellstoneButton",
		"NecrosisHealthstoneButton",
		"NecrosisSoulstoneButton",
		"NecrosisBuffMenuButton",
		"NecrosisMountButton",
		"NecrosisPetMenuButton",
		"NecrosisCurseMenuButton",
		"NecrosisDestroyShardsButton",
		"NecrosisShadowTranceButton",
		"NecrosisBacklashButton",
		"NecrosisAntiFearButton",
		"NecrosisCreatureAlertButton_demon",
		"NecrosisCreatureAlertButton_elemental",
	}
	for _, name in ipairs(buttonNames) do
		local btn = _G[name]
		if btn then
			btn:Hide()
		end
	end
end)

-- Create separate frame for event handling (NOT the button itself!)
-- This is the KEY: Events are handled by eventFrame, clicks by NecrosisButton!
local eventFrame = CreateFrame("Frame", "NecrosisEventFrame")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	-- OnEvent receives events, but we pass NecrosisButton as the frame reference
	Necrosis:OnEvent(NecrosisButton, event, ...)
end)

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")


-- Events utilised by Necrosis || Events utilisés dans Necrosis
local Events = {
	"BAG_UPDATE",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_DEAD",
	"PLAYER_ALIVE",
	"PLAYER_UNGHOST",
	"UNIT_PET",
	"UNIT_SPELLCAST_FAILED",
	"UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_SPELLCAST_SENT",
	"UNIT_MANA",
	"UNIT_HEALTH",
	"UNIT_POWER_UPDATE",
	-- "LEARNED_SPELL_IN_TAB", -- Removed: deprecated in WoW Classic 2026, use SPELLS_CHANGED instead
	"PLAYER_TARGET_CHANGED",
	"TRADE_REQUEST",
	"TRADE_REQUEST_CANCEL",
	"TRADE_ACCEPT_UPDATE",
	"TRADE_SHOW",
	"TRADE_CLOSED",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"SKILL_LINES_CHANGED",
	"PLAYER_LEAVING_WORLD",
	"SPELLS_CHANGED",
}

------------------------------------------------------------------------------------------------------
-- FONCTION D'INITIALISATION
------------------------------------------------------------------------------------------------------

function Necrosis:Initialize_Speech()
	self.Localization_Dialog()
	
	-- Speech could not be done using Ace...
	self.Speech.TP = {}
	local lang = ""
	lang = GetLocale()
	Necrosis.Data.Lang = lang
	if lang == "frFR" then
		self:Localization_Speech_Fr()
	elseif lang == "deDE" then
		self:Localization_Speech_De()
	elseif lang == "zhTW" then
		self:Localization_Speech_Tw()
	elseif lang == "zhCN" then
		self:Localization_Speech_Cn()
	elseif lang == "esES" or lang == "esMX" then
		self:Localization_Speech_Es()
	elseif lang == "ruRU" then
		self:Localization_Speech_Ru()
	else
		Necrosis:Localization_Speech_En()
	end
end

function Necrosis:Initialize(Config)

	local f = Necrosis.Warlock_Buttons.main.f
	if Necrosis.Debug.init_path then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- Initialize"
		.." f:'"..(tostring(f) or "nyl").."'"
		)
	end

	f = _G[f]
	-- Configure scripts for the placeholder (will be replaced by real button)
	-- These will be set on the real button after it's created
	-- OnUpdate, OnEnter, OnLeave, OnDragStart, OnDragStop will be added to the new button

	-- Register the events used || Enregistrement des events utilisés
	-- CRITICAL: Register events on eventFrame, NOT on the button!
	local eventFrame = _G["NecrosisEventFrame"]
	if eventFrame then
		for i in ipairs(Events) do
			eventFrame:RegisterEvent(Events[i])
		end
	end

	Necrosis:Initialize_Speech()
	-- Initialize configuration with defaults (merge existing settings with new defaults)
	-- Preserve user settings across version updates - ONLY reset if version is significantly older
	if not NecrosisConfig then
		NecrosisConfig = {}
		-- Copy all defaults
		for k, v in pairs(Config) do
			if type(v) == "table" then
				NecrosisConfig[k] = {}
				for k2, v2 in pairs(v) do
					NecrosisConfig[k][k2] = v2
				end
			else
				NecrosisConfig[k] = v
			end
		end
		self:Msg(self.ChatMessage.Interface.DefaultConfig, "USER")
	else
		-- Existing config found - preserve user settings and add missing defaults
		-- NOTE: User settings are ALWAYS preserved during version updates (no reset on minor version changes)
		for k, v in pairs(Config) do
			if NecrosisConfig[k] == nil then
				-- Add missing config keys from defaults
				if type(v) == "table" then
					NecrosisConfig[k] = {}
					for k2, v2 in pairs(v) do
						NecrosisConfig[k][k2] = v2
					end
				else
					NecrosisConfig[k] = v
				end
			elseif type(v) == "table" and type(NecrosisConfig[k]) == "table" then
				-- For table values, add missing keys but preserve existing ones
				for k2, v2 in pairs(v) do
					if NecrosisConfig[k][k2] == nil then
						NecrosisConfig[k][k2] = v2
					end
				end
			end
		end
		self:Msg(self.ChatMessage.Interface.UserConfig, "USER")
	end

	-- Set version to current (tracks last successful load)
	NecrosisConfig.Version = Necrosis.Data.Version

	if NecrosisConfig.PetInfo then -- just in case... pet config info was redone for speech
	else
		NecrosisConfig.PetInfo = {}
	end

	if NecrosisConfig.Timers then -- just in case... was added in 7.2
	else
		NecrosisConfig.Timers = Config.Timers

	end

	-- Add missing timer types from new versions (migration)
	for i = 1, #Config.Timers do
		if not NecrosisConfig.Timers[i] then
			NecrosisConfig.Timers[i] = Config.Timers[i]
		end
	end

	--  Add new parameter between 2 version
	if NecrosisConfig.NecrosisAlphaBar then
	else
	NecrosisConfig.NecrosisAlphaBar = 85 -- just in case... was added in 7.6
	end

	-- Initialize threat meter settings
	if NecrosisConfig.ThreatMeterEnabled == nil then
		NecrosisConfig.ThreatMeterEnabled = true -- Enable threat meter by default
	end
	if NecrosisConfig.ThreatRingThickness == nil then
		NecrosisConfig.ThreatRingThickness = 8 -- Ring thickness (8px)
	end

	-- Initialize Bottom Banner Scale
	if NecrosisConfig.BottomBannerScale == nil then
		NecrosisConfig.BottomBannerScale = 1.0 -- Default scale for bottom banner images
	end
	-- Apply the scale to the banner (in case it was created before config was initialized)
	if NUI and NUI.UpdateBottomBannerScale then
		NUI:UpdateBottomBannerScale()
	end

	-- Initialize Version Check settings
	Necrosis.UpdateSpellTimers(NecrosisConfig.Timers)-- init timers
	
	-- Création de la liste des sorts disponibles
	self:SpellSetup("Initialize")
	-- Dessine les UI et button Popoup
	self:CreateWarlockUI()
	self:CreateWarlockPopup()
	-----------------------------------------------------------
	-- Exécution des fonctions de démarrage
	-----------------------------------------------------------
	-- Display welcome message on console
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("|n|cffcc6600" .. string.rep("=", 60) .. "|r")
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("|cffff6600N|cffff9900e|cffffcc00c|cff99cc00r|cff33cc00o|cff00cc99s|cff0099ccis|r |cffffffff(v" .. Necrosis.Data.Version .. ")|r")
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("|cffcc6600" .. string.rep("=", 60) .. "|r")
	self:Msg(self.ChatMessage.Interface.Welcome, "USER")

    -- Enregistrement de la commande console
	SlashCmdList["NecrosisCommand"] = Necrosis.SlashHandler
	SLASH_NecrosisCommand1 = "/necrosis"

	-- On règle la taille de la pierre et des boutons suivant les réglages du SavedVariables
	local val = NecrosisConfig.ShadowTranceScale/100
--	f:SetScale(val)

	local ft = _G[Necrosis.Warlock_Buttons.trance.f]; ft:SetScale(val)
	local fb = _G[Necrosis.Warlock_Buttons.backlash.f]; fb:SetScale(val)
	local fa = _G[Necrosis.Warlock_Buttons.anti_fear.f]; fa:SetScale(val)
	local fe = _G[Necrosis.Warlock_Buttons.elemental.f]; fe:SetScale(val)

	local ftb = _G[Necrosis.Warlock_Buttons.timer.f]

	-- On définit l'affichage des Timers Graphiques à gauche ou à droite du bouton
	if _G["NecrosisTimerFrame0"] then
		NecrosisTimerFrame0:ClearAllPoints()
		NecrosisTimerFrame0:SetPoint(
			NecrosisConfig.SpellTimerJust,
			ftb,
			"CENTER",
			NecrosisConfig.SpellTimerPos * 20,
			0
		)
	end
	-- On définit l'affichage des Timers Textes à gauche ou à droite du bouton
	if _G["NecrosisListSpells"] then
		NecrosisListSpells:ClearAllPoints()
		NecrosisListSpells:SetJustifyH(NecrosisConfig.SpellTimerJust)
		NecrosisListSpells:SetPoint(
			"TOP"..NecrosisConfig.SpellTimerJust,
			ftb,
			"CENTER",
			NecrosisConfig.SpellTimerPos * 23,
			5
		)
	end

	--On affiche ou on cache le bouton, d'ailleurs !
	if not NecrosisConfig.ShowSpellTimers then ftb:Hide() end
	-- Le Shard est-il verrouillé sur l'interface ?
	if NecrosisConfig.NoDragAll then
		self:NoDrag()
		f:RegisterForDrag("")
		ftb:RegisterForDrag("")
		ft:RegisterForDrag("")
		fb:RegisterForDrag("")
		fa:RegisterForDrag("")
		fe:RegisterForDrag("")
	else
		self:Drag()
		-- CRITICAL TEST: Disable drag on main sphere to see if clicks work
		-- RegisterForDrag("LeftButton") blocks SecureActionButton clicks!
		f:RegisterForDrag("")  -- TEST: No drag at all
		ftb:RegisterForDrag("LeftButton")
		ft:RegisterForDrag("LeftButton")
		fb:RegisterForDrag("LeftButton")
		fa:RegisterForDrag("LeftButton")
		fe:RegisterForDrag("LeftButton")
	end

	-- Initialize just case the player has updated from an older version
	if NecrosisConfig.PlayerSummons == nil then
		NecrosisConfig.PlayerSummons = NecrosisConfig.ChatMsg
		NecrosisConfig.PlayerSummonsSM = false
		NecrosisConfig.PlayerSS = NecrosisConfig.ChatMsg
		NecrosisConfig.PlayerSSSM = false
	else
	end

	-- Initialize NecrosisUI option (default: disabled)
	if NecrosisConfig.NecrosisUIEnabled == nil then
		NecrosisConfig.NecrosisUIEnabled = false
	end

	-- Apply NecrosisUI state on startup with delay to ensure SavedVariables are loaded
	C_Timer.After(1, function()
	if NecrosisConfig.NecrosisUIEnabled and NUI then
		pcall(function() NUI:Show() end)
		elseif NUI then
		pcall(function() NUI:Hide() end)
		end
	end)

	-- Request the localized strings - this may need events and time...
	Necrosis.UpdatePouches()

	-- If the sphere must indicate life or mana, we go there || Si la sphere doit indiquer la vie ou la mana, on y va
	Necrosis:UpdateHealth()
	Necrosis:UpdateMana()
	Necrosis:ButtonSetup()

	-- Configure button click attributes || Configuration des attributs de clics des boutons
	if not InCombatLockdown() then
		-- Determine if mount spell is available
		local SteedAvailable = false
		if GetSpellInfo(5784) or GetSpellInfo(23161) then
			SteedAvailable = true
		end

		-- Configure all button attributes
		-- TEMP: Disable MainButtonAttribute to test if it breaks clicks!
		-- Necrosis:MainButtonAttribute()

		-- CRITICAL: Re-enable clicks on main sphere AFTER all SetScript calls!
		-- DISABLED: Old config code - button is now created with delay below
		-- DEBUG: Checking main button...")
		-- The real button will be created after delay

		Necrosis:BuffSpellAttribute()
		Necrosis:PetSpellAttribute()
		Necrosis:CurseSpellAttribute()
		Necrosis:StoneAttribute(SteedAvailable)

		-- CRITICAL: CREATE BRAND NEW BUTTON with delay (like test 5 that WORKS!)
		-- Increased delay to 5 seconds to ensure proper initialization on first login
		C_Timer.After(5, function()
			if not InCombatLockdown() then
				-- DESTROY old button completely (including placeholder)
			local oldBtn = _G["NecrosisButton"]
			if oldBtn then
				oldBtn:Hide()
				oldBtn:SetParent(nil)
				oldBtn = nil
			end
			-- Also destroy the placeholder overlay frame
			local oldOverlay = _G["NecrosisShardCountFrame_Placeholder"]
			if oldOverlay then
				oldOverlay:Hide()
				oldOverlay:SetParent(nil)
				oldOverlay = nil
			end

				-- Create BRAND NEW button
				local btn = CreateFrame("Button", "NecrosisMainSphere", UIParent, "SecureUnitButtonTemplate")

				-- Apply initial skin based on configuration
				local initialSkin = "Shard"
				if NecrosisConfig.Circle == 4 then
					-- Health indicator: use full sphere if at max health
					local health = UnitHealth("player")
					local healthMax = UnitHealthMax("player")
					if health == healthMax then
						initialSkin = NecrosisConfig.NecrosisColor.."\\Shard32"
					else
						local taux = math.floor(health / (healthMax / 16))
						initialSkin = NecrosisConfig.NecrosisColor.."\\Shard"..taux
					end
				elseif NecrosisConfig.Circle == 3 then
					-- Mana indicator: use full sphere if at max mana
					local ptype, ptype_txt = UnitPowerType("player")
					local mana = UnitPower("player", ptype)
					local manaMax = UnitPowerMax("player", ptype)
					if mana == manaMax then
						initialSkin = NecrosisConfig.NecrosisColor.."\\Shard32"
					else
						local taux = math.floor(mana / (manaMax / 16))
						initialSkin = NecrosisConfig.NecrosisColor.."\\Shard"..taux
					end
				else
					-- No indicator: use full sphere with configured color
					initialSkin = NecrosisConfig.NecrosisColor.."\\Shard32"
				end
				btn:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..initialSkin)
				btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
				btn:GetHighlightTexture():SetBlendMode("ADD")
				btn:SetWidth(58)
				btn:SetHeight(58)

				-- Apply configured scale
				local scale = (NecrosisConfig.NecrosisButtonScale or 100) / 100
				btn:SetScale(scale)

				btn:SetFrameStrata("MEDIUM")
				btn:SetFrameLevel(1)

				-- Keep invisible until position is restored
				btn:Hide()

				-- FontString already created at file load time with HIGH FrameStrata
				-- Reparent the overlay frame to the new button so it follows automatically
				local textOverlay = _G["NecrosisShardCountFrame_Placeholder"] or _G["NecrosisShardCountFrame"]
				if textOverlay then
					textOverlay:SetParent(btn)  -- Make it child of the new button
					textOverlay:ClearAllPoints()
					textOverlay:SetAllPoints(btn)  -- Cover the entire button
					textOverlay:Show()  -- Make the overlay visible
					-- Register in _G for future references
					_G["NecrosisShardCountFrame"] = textOverlay
				end

				btn:SetMovable(true)
				btn:EnableMouse(true)

				-- Get configured spells
				local mainSpell = Necrosis.GetSpellCastName(NecrosisConfig.MainSpell)
				local secondSpell = Necrosis.GetSpellCastName(NecrosisConfig.MainSpell2)

				-- Configure attributes - Left click main spell
				if mainSpell then
					btn:SetAttribute("type1", "spell")
					btn:SetAttribute("spell1", mainSpell)
				end

				-- Shift+Left click second spell
				if secondSpell and secondSpell ~= "" then
					btn:SetAttribute("shift-type1", "spell")
					btn:SetAttribute("shift-spell1", secondSpell)
				end

				-- Right click opens config menu
				btn:SetAttribute("type2", "macro")
				btn:SetAttribute("macrotext2", "/necrosis")

			-- Middle click opens bags
			btn:SetAttribute("type3", "macro")
			btn:SetAttribute("macrotext3", "/run OpenAllBags()")

				btn:RegisterForClicks("AnyUp")

				-- Configure scripts
				btn:SetScript("OnUpdate", function(self, arg1) Necrosis:OnUpdate(self, arg1) end)
				btn:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetText("Necrosis", 0.5, 0, 0.9)
					GameTooltip:AddLine(" ")
					if mainSpell then
						GameTooltip:AddDoubleLine(L["TOOLTIP_LEFT_CLICK"]..":", mainSpell, 1, 1, 1, 1, 1, 1)
					end
					if secondSpell and secondSpell ~= "" then
						GameTooltip:AddDoubleLine(L["TOOLTIP_SHIFT_LEFT_CLICK"]..":", secondSpell, 1, 1, 1, 1, 1, 1)
					end
					GameTooltip:AddDoubleLine(L["TOOLTIP_RIGHT_CLICK"]..":", L["TOOLTIP_CONFIGURATION"], 1, 1, 1, 1, 1, 1)
					GameTooltip:AddDoubleLine(L["TOOLTIP_MIDDLE_CLICK"]..":", L["TOOLTIP_OPEN_BAGS"], 1, 1, 1, 1, 1, 1)
					GameTooltip:AddDoubleLine(L["TOOLTIP_DRAG"]..":", L["TOOLTIP_MOVE"], 1, 1, 1, 1, 1, 1)

					-- Add stone counts
					GameTooltip:AddLine(" ")

					-- Soulstone
					if Necrosis.Warlock_Lists and Necrosis.Warlock_Lists.soul_stones then
						local soulCount = 0
						for i, v in pairs(Necrosis.Warlock_Lists.soul_stones) do
							soulCount = soulCount + GetItemCount(v.id)
						end
						local soulColor = soulCount > 0 and "|cFFFFFFFF" or "|cFFFF0000"
						local soulText = L["STONE_SOULSTONE_LABEL"]..soulColor..soulCount.."|r"

						-- Check cooldown for soulstone item (not the spell)
						local startTime, duration, isEnabled = Necrosis:GetSoulstoneItemCooldown()
						if startTime and startTime > 0 and duration and duration > 0 then
							local timeLeft = math.ceil((startTime + duration) - GetTime())
							if timeLeft > 0 then
								local minutes = math.floor(timeLeft / 60)
								local seconds = timeLeft % 60
								soulText = soulText .. " |cFFFF9999("..minutes..":"..string.format("%02d", seconds)..")|r"
							end
						end
						GameTooltip:AddLine(soulText)
					end

					-- Healthstone
					if Necrosis.Warlock_Lists and Necrosis.Warlock_Lists.health_stones then
						local healthCount = 0
						for i, v in pairs(Necrosis.Warlock_Lists.health_stones) do
							healthCount = healthCount + GetItemCount(v.id)
						end
						local healthColor = healthCount > 0 and "|cFFFFFFFF" or "|cFFFF0000"
						local healthText = L["STONE_HEALTHSTONE_LABEL"]..healthColor..healthCount.."|r"

						-- Check cooldown for healthstone item
						local startTime, duration, isEnabled = Necrosis:GetHealthstoneItemCooldown()
						if startTime and startTime > 0 and duration and duration > 0 then
							local timeLeft = math.ceil((startTime + duration) - GetTime())
							if timeLeft > 0 then
								local minutes = math.floor(timeLeft / 60)
								local seconds = timeLeft % 60
								healthText = healthText .. " |cFFFF9999("..minutes..":"..string.format("%02d", seconds)..")|r"
							end
						end
						GameTooltip:AddLine(healthText)
					end

					if Necrosis.Warlock_Lists and Necrosis.Warlock_Lists.spell_stones then
						local spellCount = 0
						for i, v in pairs(Necrosis.Warlock_Lists.spell_stones) do
							spellCount = spellCount + GetItemCount(v.id)
						end
						local spellColor = spellCount > 0 and "|cFFFFFFFF" or "|cFFFF0000"
						GameTooltip:AddLine(L["STONE_SPELLSTONE_LABEL"]..spellColor..spellCount.."|r")
					end

					if Necrosis.Warlock_Lists and Necrosis.Warlock_Lists.fire_stones then
						local fireCount = 0
						for i, v in pairs(Necrosis.Warlock_Lists.fire_stones) do
							fireCount = fireCount + GetItemCount(v.id)
						end
						local fireColor = fireCount > 0 and "|cFFFFFFFF" or "|cFFFF0000"
						GameTooltip:AddLine(L["STONE_FIRESTONE_LABEL"]..fireColor..fireCount.."|r")
					end

					-- Infernal Stone (reagent)
					if Necrosis.Warlock_Lists and Necrosis.Warlock_Lists.reagents and Necrosis.Warlock_Lists.reagents.infernal_stone then
						local infernalCount = GetItemCount(Necrosis.Warlock_Lists.reagents.infernal_stone.id)
						local infernalColor = infernalCount > 0 and "|cFFFFFFFF" or "|cFFFF0000"
						GameTooltip:AddLine(L["STONE_INFERNAL_LABEL"]..infernalColor..infernalCount.."|r")
					end

					GameTooltip:Show()
				end)
				btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
				btn:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
				btn:SetScript("OnDragStop", function(self)
					Necrosis:OnDragStop(self)
					-- Make text overlay cover the button again after drag
					local overlay = _G["NecrosisShardCountFrame"]
					if overlay then
						overlay:ClearAllPoints()
						overlay:SetAllPoints(self)
					end
				end)

				-- Enable drag if not locked
				if not NecrosisConfig.NoDragAll then
					btn:RegisterForDrag("LeftButton")
				end

				-- Position
				-- Try to restore from NecrosisMainSphere (current name) first, then NecrosisButton (legacy)
				if NecrosisConfig.FramePosition and NecrosisConfig.FramePosition["NecrosisMainSphere"] then
					local pos = NecrosisConfig.FramePosition["NecrosisMainSphere"]
					btn:SetPoint(pos[1], pos[2], pos[3], pos[4], pos[5])
					-- Restore scale if it exists (6th element), otherwise use default 1
					if pos[6] then
						btn:SetScale(pos[6])
					end
				elseif NecrosisConfig.FramePosition and NecrosisConfig.FramePosition["NecrosisButton"] then
					local pos = NecrosisConfig.FramePosition["NecrosisButton"]
					btn:SetPoint(pos[1], pos[2], pos[3], pos[4], pos[5])
					-- Restore scale if it exists (6th element)
					if pos[6] then
						btn:SetScale(pos[6])
					end
				else
					btn:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
				end

				btn:Show()
				_G["NecrosisButton"] = btn
				_G["NecrosisMainSphere"] = btn

				-- Show all peripheral buttons now that main button is positioned
				-- NOTE: ShadowTrance, Backlash, AntiFear, CreatureAlert buttons stay hidden
				-- They only show in specific conditions (combat, rare mobs, etc.)
				local buttonNames = {
					"NecrosisFirestoneButton",
					"NecrosisSpellstoneButton",
					"NecrosisHealthstoneButton",
					"NecrosisSoulstoneButton",
					"NecrosisBuffMenuButton",
					"NecrosisMountButton",
					"NecrosisPetMenuButton",
					"NecrosisCurseMenuButton",
					"NecrosisDestroyShardsButton",
				}
				for _, name in ipairs(buttonNames) do
					local b = _G[name]
					if b then
						b:Show()
					end
				end

				-- Set tooltip type for the main button
				btn.tip = "Main"

				-- Reposition peripheral buttons around the sphere
				Necrosis:ButtonSetup()

				-- Re-scan spells after 3 seconds to get current data from WoW
				Necrosis:SpellSetup("TimerCallback")

				-- Create menu buttons BEFORE configuring their attributes
				Necrosis:CreateMenu()

				-- Configure button click attributes
				local SteedAvailable = false
				if GetSpellInfo(5784) or GetSpellInfo(23161) then
					SteedAvailable = true
				end

				Necrosis:MainButtonAttribute()
				Necrosis:BuffSpellAttribute()
				Necrosis:PetSpellAttribute()
				Necrosis:CurseSpellAttribute()
				Necrosis:StoneAttribute(SteedAvailable)

				-- Create threat meter ring (circular indicator around main sphere)
				Necrosis:CreateThreatRing()

				-- Scan bags for soul shards
				Necrosis:BagExplore()

				-- Shard count will be automatically updated by Necrosis:OnUpdate()
				-- No need to force update here - let the normal system handle it
			end
		end)
	end

	-- We check that the fragments are in the bag defined by the Warlock || On vérifie que les fragments sont dans le sac défini par le Démoniste
	if NecrosisConfig.SoulshardSort then
		--self:SoulshardSwitch("CHECK")
	end
end

------------------------------------------------------------------------------------------------------
-- FONCTION GERANT LA COMMANDE CONSOLE /NECRO
------------------------------------------------------------------------------------------------------

function Necrosis.SlashHandler(arg1)
	if arg1:lower():find("recall") then
		Necrosis:Recall()
		
	elseif arg1:lower():find("reset") and not InCombatLockdown() then
		NecrosisConfig = {}
		ReloadUI()
	elseif arg1:lower():find("glasofruix") then
		NecrosisConfig.Smooth = not NecrosisConfig.Smooth
		Necrosis:Msg("SpellTimer smoothing  : <lightBlue>Toggled", "USER")
		self:CreateWarlockUI()
		
	else
		Necrosis:OpenConfigPanel()
	end
end

--_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- init")
