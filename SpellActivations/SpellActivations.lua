local addonName, nsf = ...
 

local f = CreateFrame("Frame", "SpellActivations") --, UIParent)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterUnitEvent("UNIT_AURA", "player")

f:SetScript("OnEvent", function(self, event, ...)
   
	return self[event](self, event, ...)
	
end)

local UnitGUID = UnitGUID

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
local _, class = UnitClass("player")
local procCombatLog
local registeredFrames = {}
local activations = {}
local LBG

local hadShadowTrance
local hadBacklash
local hadMoltenCore
local hadDecimation
local UnitAura = UnitAura




local spellNamesByID = {
    [686] = "ShadowBolt", -- 1
    [695] = "ShadowBolt", -- 2
    [705] = "ShadowBolt", -- 3
    [1088] = "ShadowBolt", -- 4
    [1106] = "ShadowBolt", -- 5
    [7641] = "ShadowBolt", -- 6
    [11659] = "ShadowBolt", -- 7
    [11660] = "ShadowBolt", -- 8
    [11661] = "ShadowBolt", -- 9
    [25307] = "ShadowBolt", -- 10
    [27209] = "ShadowBolt", -- 11
	[47808] = "ShadowBolt", -- 12
	[47809] = "ShadowBolt", -- 13
	[29722] = "Incinerate", -- 1
	[32231] = "Incinerate", -- 2
	[47837] = "Incinerate", -- 3
	[6353]  = "Soulfire", -- 1
	[17924] = "Soulfire", -- 2	
	[27211] = "Soulfire", -- 3
	[30545] = "Soulfire", -- 4
	[47824] = "Soulfire", -- 5
	[47825] = "Soulfire", -- 6
}


function f:PLAYER_LOGIN()

    if class == "WARLOCK"  then
        self:RegisterEvent("SPELLS_CHANGED")
        self:SPELLS_CHANGED()

        local bars = {"ActionButton","MultiBarBottomLeftButton","MultiBarBottomRightButton","MultiBarLeftButton","MultiBarRightButton"}
        for _,bar in ipairs(bars) do
            for i = 1,12 do
                local btn = _G[bar..i]
                self:RegisterForActivations(btn)
            end
        end

        hooksecurefunc("ActionButton_UpdateOverlayGlow", function(self)
            nsf.UpdateOverlayGlow(self)
        end)

        local LAB = LibStub("LibActionButton-1.0", true) -- Bartender support
        if LAB then
            LBG = LibStub("LibButtonGlow-1.0", true)
            self:RegisterForActivations(LAB.eventFrame)
            LAB:RegisterCallback("OnButtonUpdate", function(event, self)
                nsf.LAB_UpdateOverlayGlow(self)
            end)
        end

        local LAB2 = LibStub("LibActionButton-1.0-ElvUI", true) -- ElvUI support
        if LAB2 then
            LBG = LibStub("LibButtonGlow-1.0", true)
            self:RegisterForActivations(LAB2.eventFrame)
            LAB2:RegisterCallback("OnButtonUpdate", function(event, self)
                nsf.LAB_UpdateOverlayGlow(self)
            end)
        end

        if IsAddOnLoaded("Dominos") then   -- Dominos support
            local dominosPrefix = "DominosActionButton"
            for i = 1, 72 do
                local btnName = dominosPrefix..i
                local btn = _G[btnName]
                if btn then
                    self:RegisterForActivations(btn)
                end
            end
        end
      
    end
    -- self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


end


local function FindAura(unit, spellID, filter)
    for i=1, 40 do
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, auraSpellID = UnitAura(unit, i, filter)
        if not name then return nil end
        if spellID == auraSpellID then
			--print (name,auraSpellID,duration)
            return name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, auraSpellID
			
		end
    end
end



function f:SPELLS_CHANGED()
   
    if class == "WARLOCK" then
        self:SetScript("OnUpdate", self.timerOnUpdate)
        local hasNightfallTalent = IsPlayerSpell(18094) or IsPlayerSpell(18095)
        local hasBacklashTalent = IsPlayerSpell(34939) or IsPlayerSpell(34938) or IsPlayerSpell(34935)
        local hasMoltenCore = IsPlayerSpell(47245) or IsPlayerSpell(47246) or IsPlayerSpell(47247)
		local hasDecimation = IsPlayerSpell(63158) or IsPlayerSpell(63156) or IsPlayerSpell(63167) or IsPlayerSpell(63165) 
		
		if hasNightfallTalent or hasBacklashTalent or hasMoltenCore or hasDecimation then
            self:RegisterUnitEvent("UNIT_AURA", "player")
            self:SetScript("OnUpdate", self.timerOnUpdate)
            self.UNIT_AURA = function(self, event, unit)
                if hasNightfallTalent then
                    local name, _, _, _, duration, expirationTime = FindAura(unit, 17941, "HELPFUL") -- Shadow Trance
                    local haveShadowTrance = name ~= nil
                    if hadShadowTrance ~= haveShadowTrance then
                        if haveShadowTrance then
                            f:Activate("ShadowBolt", duration, true)
                        else
                            f:Deactivate("ShadowBolt")
                        end
                        hadShadowTrance = haveShadowTrance
                    end
                end
                if hasBacklashTalent then
                    local name, _, _, _, duration, expirationTime = FindAura(unit, 34936, "HELPFUL") -- Backlash
                    local haveBacklash = name ~= nil
                    if hadBacklash ~= haveBacklash then
                        if haveBacklash then
                            f:Activate("ShadowBolt", duration, true)
                            f:Activate("Incinerate", duration, true)
                        else
                            f:Deactivate("ShadowBolt")
                            f:Deactivate("Incinerate")
                        end
                        hadBacklash = haveBacklash
                    end
                end
				if hasMoltenCore then
                    local name, _, _, _, duration, expirationTime = FindAura(unit, 71165, "HELPFUL") -- Moltencore r1
                    local haveMoltenCore  = name ~= nil
                    if hadMoltenCore  ~= haveMoltenCore  then
                        if haveMoltenCore  then
                        
                            f:Activate("Incinerate", duration, true)
                        else
                            
                            f:Deactivate("Incinerate")
                        end
                        hadMoltenCore = haveMoltenCore
                    end
                end
				
				if hasDecimation then
                    local name, _, _, _, duration, expirationTime = FindAura(unit, 63167, "HELPFUL") -- Décimation
                    local haveDecimation  = name ~= nil
                    if hadDecimation  ~= haveDecimation  then
                        if haveDecimation then
							--print ("Decimation", duration, true)
                            f:Activate("Soulfire", duration, true)
                        else
                            
                            f:Deactivate("Soulfire")
                        end
                        hadDecimation = haveDecimation
                    end
                end
				
				
            end
        else
            self:SetScript("OnUpdate", nil)
            self:UnregisterEvent("UNIT_AURA")
        end
    end
end

function f:RegisterForActivations(frame)
    registeredFrames[frame] = true
    -- registeredFrames:GetScript("OnEvent")
end
local function IsSpellOverlayed(spellID)
    local spellName = spellNamesByID[spellID]
    if not spellName then return false end
    local state = activations[spellName]
    if state then return state.active end
end

local GetActionInfo = _G.GetActionInfo
local GetMacroSpell = _G.GetMacroSpell
local ActionButton_ShowOverlayGlow = _G.ActionButton_ShowOverlayGlow
local ActionButton_HideOverlayGlow = _G.ActionButton_HideOverlayGlow

function nsf.UpdateOverlayGlow(self)
    local spellType, id, subType  = GetActionInfo(self.action);
	
    if ( spellType == "spell" and IsSpellOverlayed(id) ) then
        ActionButton_ShowOverlayGlow(self);
    elseif ( spellType == "macro" ) then
        local spellId = GetMacroSpell(id);
        if ( spellId and IsSpellOverlayed(spellId) ) then
            ActionButton_ShowOverlayGlow(self);
        else
            ActionButton_HideOverlayGlow(self);
        end
    else
        ActionButton_HideOverlayGlow(self);
    end
end

function nsf.LAB_UpdateOverlayGlow(self)
    local spellId = self:GetSpellId()
    if spellId and IsSpellOverlayed(spellId) then
        if LBG then
            LBG.ShowOverlayGlow(self)
        end
    else
        if LBG then
            LBG.HideOverlayGlow(self)
        end
    end
end

function f:FanoutEvent(event, ...)
    for frame, _ in pairs(registeredFrames) do
        local eventHandler = frame:GetScript("OnEvent")
        if eventHandler then
            --print (frame:GetName(),frame , event)
			eventHandler(frame, event, ...)
        end
    end
end

local reverseSpellRanks = {
    ShadowBolt = { 47809, 47808, 27209, 25307, 11661, 11660, 11659, 7641, 1106, 1088, 705, 695, 686 },
    Incinerate = { 47838, 47837, 32231, 29722 },
    Soulfire = {47825, 47824, 30545, 27211, 17924, 6353}
}
function nsf.findHighestRank(spellName)
    for _, spellID in ipairs(reverseSpellRanks[spellName]) do
        if IsPlayerSpell(spellID) then return spellID end
    end
end
local findHighestRank = nsf.findHighestRank

function f:Activate(spellName, duration, keepExpiration)
    --print (spellName, duration, keepExpiration)
	
	local state = activations[spellName]
    if not state then
        activations[spellName] = {}
        state = activations[spellName]
    end
    if not state.active then
        state.active = true
        state.expirationTime = duration and GetTime() + duration

        local highestRankSpellID = findHighestRank(spellName)
        --print ("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", highestRankSpellID)
		self:FanoutEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", highestRankSpellID)
    elseif not keepExpiration then
        state.expirationTime = duration and GetTime() + duration
    end
end
function f:Deactivate(spellName)
    local state = activations[spellName]
    if state and state.active == true then
        state.active = false
        state.expirationTime = nil

        local highestRankSpellID = findHighestRank(spellName)
        self:FanoutEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", highestRankSpellID)
    end
end

local _OnUpdateCounter = 0
local periodicCheck = nil
function f.timerOnUpdate(self, elapsed)
    _OnUpdateCounter = _OnUpdateCounter + elapsed
    if _OnUpdateCounter < 0.2 then return end
    _OnUpdateCounter = 0


    if periodicCheck then
        periodicCheck()
    end

    local now = GetTime()
    for spellName, state in pairs(activations) do
        if state.expirationTime and now >= state.expirationTime then
            f:Deactivate(spellName)
        end
    end
end

function f:COMBAT_LOG_EVENT_UNFILTERED(event)
    local timestamp, eventType, hideCaster,
    srcGUID, srcName, srcFlags, srcFlags2,
    dstGUID, dstName, dstFlags, dstFlags2,
    arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 = CombatLogGetCurrentEventInfo()

    local isSrcPlayer = srcGUID == UnitGUID("player") -- bit_band(srcFlags, AFFILIATION_MINE) == AFFILIATION_MINE
    local isDstPlayer = dstGUID == UnitGUID("player")

    procCombatLog(eventType, isSrcPlayer, isDstPlayer, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
end
