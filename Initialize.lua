--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit _G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

Necrosis = {}
SAO ={}
NECROSIS_ID = "Necrosis"

-- Compatibility wrapper for GetAddOnMetadata (deprecated in modern WoW)
local function GetMetadata(addon, field)
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		return C_AddOns.GetAddOnMetadata(addon, field)
	elseif GetAddOnMetadata then
		return GetAddOnMetadata(addon, field)
	end
	return nil
end

Necrosis.Data = {
	Version = GetMetadata("Necrosis", "Version"),
	AppName = "Necrosis",
	LastConfig = "8.0.6",
	Enabled = false,
}

Necrosis.Data.Label = Necrosis.Data.AppName.." "..Necrosis.Data.Version

Necrosis.Speech = {}
Necrosis.Unit = {}
Necrosis.Translation = {}

Necrosis.Config = {}

NecrosisConfig = {}


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
local nbutton = CreateFrame("Button", "NecrosisMainSphere", UIParent, "SecureUnitButtonTemplate")
-- Register it as NecrosisButton for the rest of the code
_G["NecrosisButton"] = nbutton

-- Create text overlay frame IMMEDIATELY with HIGH FrameStrata so it's above the button
-- This prevents XML.lua from creating it on UIParent (which would be behind the button)
local textOverlay = CreateFrame("Frame", "NecrosisShardCountFrame", nbutton)  -- PARENT = nbutton!
textOverlay:SetFrameStrata("HIGH")  -- Above MEDIUM (button strata)
textOverlay:SetFrameLevel(100)
textOverlay:SetAllPoints(nbutton)  -- Cover the entire button
-- Create the FontString on this high-strata frame
local shardCount = textOverlay:CreateFontString("NecrosisShardCount", "OVERLAY", "GameFontNormal")
shardCount:SetPoint("CENTER")  -- Center in parent
shardCount:SetTextColor(1, 1, 1, 1)

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
	-- On charge (ou on crée la configuration pour le joueur et on l'affiche sur la console
	if not Necrosis.Data.LastConfig or  Necrosis.Data.LastConfig > Necrosis.Data.Version or NecrosisConfig.Version == nil then
		
		print(Necrosis.Data.LastConfig,Necrosis.Data.Version, NecrosisConfig.Version,NecrosisConfig.Language)
		
		NecrosisConfig = {}
		NecrosisConfig = Config
		NecrosisConfig.Version = Necrosis.Data.LastConfig
		self:Msg(self.ChatMessage.Interface.DefaultConfig, "USER")
	else
		self:Msg(self.ChatMessage.Interface.UserConfig, "USER")
		print("Necrosis", Necrosis.Data.LastConfig,Necrosis.Data.Version, NecrosisConfig.Version,NecrosisConfig.Language)
	end
	
	if NecrosisConfig.PetInfo then -- just in case... pet config info was redone for speech
	else	
		NecrosisConfig.PetInfo = {}
	end
	
	if NecrosisConfig.Timers then -- just in case... was added in 7.2
	else	
		NecrosisConfig.Timers = Config.Timers
		
	end
	--  Add new parameter between 2 version
	if NecrosisConfig.NecrosisAlphaBar then
	else
	NecrosisConfig.NecrosisAlphaBar = 85 -- just in case... was added in 7.6
	end
	
	Necrosis.UpdateSpellTimers(NecrosisConfig.Timers)-- init timers
	
	-- Création de la liste des sorts disponibles
	self:SpellSetup("Initialize")
	-- Dessine les UI et button Popoup
	self:CreateWarlockUI()
	self:CreateWarlockPopup()
	-----------------------------------------------------------
	-- Exécution des fonctions de démarrage
	-----------------------------------------------------------
	-- Affichage d'un message sur la console
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
		-- print("DEBUG: Checking main button...")
		-- The real button will be created after delay

		Necrosis:BuffSpellAttribute()
		Necrosis:PetSpellAttribute()
		Necrosis:CurseSpellAttribute()
		Necrosis:StoneAttribute(SteedAvailable)

		-- CRITICAL: CREATE BRAND NEW BUTTON with delay (like test 5 that WORKS!)
		-- Increased delay to 5 seconds to ensure proper initialization on first login
		C_Timer.After(5, function()
			if not InCombatLockdown() then
				-- DESTROY old button completely
				local oldBtn = _G["NecrosisButton"]
				if oldBtn then
					oldBtn:Hide()
					oldBtn:SetParent(nil)
					oldBtn = nil
				end

				-- Create BRAND NEW button
				local btn = CreateFrame("Button", "NecrosisMainSphere", UIParent, "SecureUnitButtonTemplate")
				btn:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Shard")
				btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
				btn:GetHighlightTexture():SetBlendMode("ADD")
				btn:SetWidth(58)
				btn:SetHeight(58)

				-- Apply configured scale
				local scale = (NecrosisConfig.NecrosisButtonScale or 100) / 100
				btn:SetScale(scale)

				btn:SetFrameStrata("MEDIUM")
				btn:SetFrameLevel(1)

				-- FontString already created at file load time with HIGH FrameStrata
				-- Reparent the overlay frame to the new button so it follows automatically
				local textOverlay = _G["NecrosisShardCountFrame"]
				if textOverlay then
					textOverlay:SetParent(btn)  -- Make it child of the new button
					textOverlay:ClearAllPoints()
					textOverlay:SetAllPoints(btn)  -- Cover the entire button
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

				btn:RegisterForClicks("AnyUp")

				-- Configure scripts
				btn:SetScript("OnUpdate", function(self, arg1) Necrosis:OnUpdate(self, arg1) end)
				btn:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetText("Necrosis", 0.5, 0, 0.9)
					GameTooltip:AddLine(" ")
					if mainSpell then
						GameTooltip:AddDoubleLine("Clic gauche:", mainSpell, 1, 1, 1, 1, 1, 1)
					end
					if secondSpell and secondSpell ~= "" then
						GameTooltip:AddDoubleLine("Shift+Clic gauche:", secondSpell, 1, 1, 1, 1, 1, 1)
					end
					GameTooltip:AddDoubleLine("Clic droit:", "Configuration", 1, 1, 1, 1, 1, 1)
					GameTooltip:AddDoubleLine("Drag:", "Déplacer", 1, 1, 1, 1, 1, 1)

					-- Add stone counts
					GameTooltip:AddLine(" ")

					-- Soulstone
					if Necrosis.Warlock_Lists and Necrosis.Warlock_Lists.soul_stones then
						local soulCount = 0
						for i, v in pairs(Necrosis.Warlock_Lists.soul_stones) do
							soulCount = soulCount + GetItemCount(v.id)
						end
						local soulColor = soulCount > 0 and "|cFFFFFFFF" or "|cFFFF0000"
						local soulText = "Pierre d'âme: "..soulColor..soulCount.."|r"

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
						local healthText = "Pierre de soin: "..healthColor..healthCount.."|r"

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
						GameTooltip:AddLine("Pierre de sort: "..spellColor..spellCount.."|r")
					end

					if Necrosis.Warlock_Lists and Necrosis.Warlock_Lists.fire_stones then
						local fireCount = 0
						for i, v in pairs(Necrosis.Warlock_Lists.fire_stones) do
							fireCount = fireCount + GetItemCount(v.id)
						end
						local fireColor = fireCount > 0 and "|cFFFFFFFF" or "|cFFFF0000"
						GameTooltip:AddLine("Pierre de feu: "..fireColor..fireCount.."|r")
					end

					-- Infernal Stone (reagent)
					if Necrosis.Warlock_Lists and Necrosis.Warlock_Lists.reagents and Necrosis.Warlock_Lists.reagents.infernal_stone then
						local infernalCount = GetItemCount(Necrosis.Warlock_Lists.reagents.infernal_stone.id)
						local infernalColor = infernalCount > 0 and "|cFFFFFFFF" or "|cFFFF0000"
						GameTooltip:AddLine("Pierre infernale: "..infernalColor..infernalCount.."|r")
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
				if NecrosisConfig.FramePosition and NecrosisConfig.FramePosition["NecrosisButton"] then
					btn:SetPoint(
						NecrosisConfig.FramePosition["NecrosisButton"][1],
						NecrosisConfig.FramePosition["NecrosisButton"][2],
						NecrosisConfig.FramePosition["NecrosisButton"][3],
						NecrosisConfig.FramePosition["NecrosisButton"][4],
						NecrosisConfig.FramePosition["NecrosisButton"][5]
					)
				else
					btn:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
				end

				btn:Show()
				_G["NecrosisButton"] = btn

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
