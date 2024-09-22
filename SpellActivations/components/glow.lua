local AddonName, SAO = ...
local Module = "glow"

-- Optimize frequent calls
local ActionButton_HideOverlayGlow = ActionButton_HideOverlayGlow
local ActionButton_ShowOverlayGlow = ActionButton_ShowOverlayGlow
local GetNumShapeshiftForms = GetNumShapeshiftForms
local GetSpellInfo = GetSpellInfo
local HasAction = HasAction

-- List of known ActionButton instances that currently match one of the spell IDs to track
-- This does not mean that buttons are glowing right now, but they could glow at any time
-- key = glowID (= spellID of action), value = list of ActionButton objects for this spell
-- (side note: the sublist of buttons is a table of key = button and a dummy value = true)
-- The list will change each time an action button changes, which may happen very often
-- For example, any macro with [mod:shift] updates the list every time Shift is pressed
SAO.ActionButtons = {}

-- Action buttons that are not tracked but could be tracked in the future
-- This re-track may happen if e.g. a new spell is learned or during delayed loading
SAO.DormantActionButtons = {}

-- List of spell IDs that should be currently glowing
-- key = glowID (= spellID of action), value = spellID of aura which triggered it recently
-- The list will change each time an overlay is triggered with a glowing effect
SAO.GlowingSpells = {}

-- List of spell IDs that should be tracked to glow action buttons
-- The spell ID may differ from the spell ID for the corresponding aura
-- key = glowID (= spell ID/name of the glowing spell), value = true
-- The lists should be setup at start, based on the player class
SAO.RegisteredGlowSpellIDs = {}

-- List of spell names that should be tracked to glow action buttons
-- This helps fill or re-fill RegisteredGlowSpellIDs when e.g. a new spell rank is learned
SAO.RegisteredGlowSpellNames = {}

-- Register a glow ID
-- Each ID is either a numeric value (spellID) or a string (spellName)
function SAO.RegisterGlowID(self, glowID)
    if (type(glowID) == "number") then
        self.RegisteredGlowSpellIDs[glowID] = true;
        self:AwakeButtonsBySpellID(glowID);
    elseif (type(glowID) == "string") then
        if (not SAO.RegisteredGlowSpellNames[glowID]) then
            SAO.RegisteredGlowSpellNames[glowID] = true;
            local glowSpellIDs = self:GetSpellIDsByName(glowID);
            for _, glowSpellID in ipairs(glowSpellIDs) do
                self.RegisteredGlowSpellIDs[glowSpellID] = true;
                self:AwakeButtonsBySpellID(glowSpellID);
            end
        end
    end
end

-- Register a list of glow ID
-- Each ID is either a numeric value (spellID) or a string (spellName)
function SAO.RegisterGlowIDs(self, glowIDs)
    for _, glowID in ipairs(glowIDs or {}) do
        self:RegisterGlowID(glowID);
    end
end

local function EnableGlow(frame, glowID, reason)
    if SAO.Shutdown:IsAddonDisabled() then
        return;
    end
    if frame:IsShown() then -- Invisible frames might cause issues; worse case scenario they will be visible soon and the player will have to wait for next proc
        SAO:Debug(Module, "Enabling Glow for button "..tostring(frame.GetName and frame:GetName() or "").." with glow id "..tostring(glowID).." due to "..reason);
        frame:EnableGlow();
    end
end

local function DisableGlow(frame, glowID, reason)
    SAO:Debug(Module, "Disabling Glow for button "..tostring(frame.GetName and frame:GetName() or "").." with glow id "..tostring(glowID).." due to "..reason);
    frame:DisableGlow();
end

-- An action button has been updated
-- Check its old/new action and old/new spell ID, and put it in appropriate lists
-- If forceRefresh is true, refresh even if old spell ID and new spell ID are identical
-- Set forceRefresh if the spell ID of the button may switch from untracked to tracked (or vice versa) in light of recent events
function SAO.UpdateActionButton(self, button, forceRefresh)
    local oldGlowID = button.lastGlowID; -- Set by us, a few lines below
    local newGlowID = button:GetGlowID();
    button.lastGlowID = newGlowID; -- Write button.lastGlowID here, but use oldGlowID/newGlowID for the rest of the function

    if (oldGlowID == newGlowID and not forceRefresh) then
        -- Skip any processing if the glow ID hasn't changed
        return;
    end

    -- Register/unregister button as 'dormant' i.e., not tracked but could be tracked in the future
    if (oldGlowID and not self.RegisteredGlowSpellIDs[oldGlowID] and type(self.DormantActionButtons[oldGlowID]) == 'table') then
        if (self.DormantActionButtons[oldGlowID][button] == button) then
            self.DormantActionButtons[oldGlowID][button] = nil;
        end
    end
    if (newGlowID and not self.RegisteredGlowSpellIDs[newGlowID]) then
        if (type(self.DormantActionButtons[newGlowID]) == 'table') then
            if (self.DormantActionButtons[newGlowID][button] ~= button) then
                self.DormantActionButtons[newGlowID][button] = button;
            end
        else
            self.DormantActionButtons[newGlowID] = { [button] = button };
        end
    end

    if (not self.RegisteredGlowSpellIDs[oldGlowID] and not self.RegisteredGlowSpellIDs[newGlowID]) then
        -- Ignore action if it does not (nor did not) correspond to a tracked glowID
        return;
    end

    -- Untrack previous action button and track the new one
    if (oldGlowID and self.RegisteredGlowSpellIDs[oldGlowID] and type(self.ActionButtons[oldGlowID]) == 'table') then
        -- Detach action button from the former glow ID
        if (self.ActionButtons[oldGlowID][button] == button) then
            self.ActionButtons[oldGlowID][button] = nil;
        end
    end
    if (newGlowID and self.RegisteredGlowSpellIDs[newGlowID]) then
        if (type(self.ActionButtons[newGlowID]) == 'table') then
            -- Attach action button to the current glow ID
            if (self.ActionButtons[newGlowID][button] ~= button) then
                self.ActionButtons[newGlowID][button] = button;
            end
        else
            -- This glow ID has no Action Buttons yet: be the first
            self.ActionButtons[newGlowID] = { [button] = button };
        end
        -- Remove from the 'dormant' table, if it was dormant
        if (type(self.DormantActionButtons[newGlowID]) == 'table' and self.DormantActionButtons[newGlowID][button] == button) then
            self.DormantActionButtons[newGlowID][button] = nil;
        end
    end

    -- Glow or un-glow, if needed
    local wasGlowing = oldGlowID and (self.GlowingSpells[oldGlowID] ~= nil);
    local mustGlow = newGlowID and (self.GlowingSpells[newGlowID] ~= nil);

    if (not wasGlowing and mustGlow) then
        if (not NecrosisConfig or not NecrosisConfig.glow or NecrosisConfig.glow.enabled) then
            EnableGlow(button, newGlowID, "action button update");
        end
    elseif (wasGlowing and not mustGlow) then
        DisableGlow(button, newGlowID, "action button update");
    end
end

-- Grab all action button activity that allows us to know which button has which spell
local LBG = LibStub("LibButtonGlow-1.0", false);
function HookActionButton_Update(button)
    if (button:GetParent() == OverrideActionBar) then
        -- Act on all buttons but the ones from OverrideActionBar

        if not button.saoAnalyzed then
            button.saoAnalyzed = true;
            -- Set the "statehidden" attribute upon init, to avoid game client issues with conflicting action slots
            local useOverrideActionBar = ((HasVehicleActionBar() and UnitVehicleSkin("player") and UnitVehicleSkin("player") ~= "")
                or (HasOverrideActionBar() and GetOverrideBarSkin() and GetOverrideBarSkin() ~= 0)); -- Test copied from ActionBarController.lua:99
            if not useOverrideActionBar then
                -- Set "statehidden" to true
                -- Don't worry, it should be reset to false next time the player enters a vehicle
                button:SetAttribute("statehidden", true);
            end
        end

        return;
    end

    if (not button.GetGlowID) then
        button.GetGlowID = function(button)
            if (button.action and HasAction(button.action)) then
                return SAO:GetSpellIDByActionSlot(button.action);
            end
        end
    end
    if (not button.EnableGlow) then
        button.EnableGlow = function(button)
            LBG.ShowOverlayGlow(button);
            -- ActionButton_ShowOverlayGlow(button); -- native API taints buttons
        end
    end
    if (not button.DisableGlow) then
        button.DisableGlow = function(button)
            LBG.HideOverlayGlow(button);
            -- ActionButton_HideOverlayGlow(button); -- native API taints buttons
        end
    end
    SAO:UpdateActionButton(button);
end
hooksecurefunc("ActionButton_Update", HookActionButton_Update);

-- Grab buttons in the stance bar
function HookStanceBar_UpdateState()
    local numForms = GetNumShapeshiftForms();
    for i=1, numForms do
        if i > NUM_STANCE_SLOTS then
            break;
        end
        local button = StanceBarFrame.StanceButtons[i];
        button.stanceForm = i;
        if (not button.GetGlowID) then
            button.GetGlowID = function(button)
                return select(4, GetShapeshiftFormInfo(button.stanceForm));
            end
        end
        if (not button.EnableGlow) then
            button.EnableGlow = function(button)
                ActionButton_ShowOverlayGlow(button);
            end
        end
        if (not button.DisableGlow) then
            button.DisableGlow = function(button)
                ActionButton_HideOverlayGlow(button);
            end
        end
        SAO:UpdateActionButton(button);
    end
end
hooksecurefunc("StanceBar_UpdateState", HookStanceBar_UpdateState);

-- Awake dormant buttons associated to a spellID
function SAO.AwakeButtonsBySpellID(self, spellID)
    local dormantButtons = {};
    for _, button in pairs(self.DormantActionButtons[spellID] or {}) do
        table.insert(dormantButtons, button);
    end
    for _, button in ipairs(dormantButtons) do
        self:UpdateActionButton(button, true);
    end
end

-- Add a glow effect for action buttons matching the given glow ID
-- @param glowID spell identifier of the glow; must be a number
function SAO.AddGlowNumber(self, spellID, glowID)
    local actionButtons = self.ActionButtons[glowID];
    if (self.GlowingSpells[glowID]) then
        self.GlowingSpells[glowID][spellID] = true;
    else
        self.GlowingSpells[glowID] = { [spellID] = true };
        for _, frame in pairs(actionButtons or {}) do
            if (not NecrosisConfig or not NecrosisConfig.glow or NecrosisConfig.glow.enabled) then
                EnableGlow(frame, frame.GetGlowID and frame:GetGlowID(), "direct activation");
            end
        end
    end
end

-- Find a glowing option in the options table
-- First try to find from optionIndex, otherwise fallback to legacy options
local function isGlowingOptionEnabled(glowingOptions, glowID, hashData)
    if not glowingOptions then
        return true; -- Enabled by default, in case there is not an option for it
    end

    local optionIndex = hashData and hashData.optionIndex;
    local legacyAllowed = hashData == nil or hashData.legacyGlowingOption;

    if type(glowID) == "number" then
        if optionIndex and type(glowingOptions[optionIndex]) == 'table' and type(glowingOptions[optionIndex][glowID]) == 'boolean' then
            return glowingOptions[optionIndex][glowID];
        elseif legacyAllowed and type(glowingOptions[glowID]) == "boolean" then
            return glowingOptions[glowID];
        end
    else
        local glowSpellName = (type(glowID) == "number") and GetSpellInfo(glowID) or glowID;

        if optionIndex and type(glowingOptions[optionIndex]) == 'table' then
            for optionSpellID, optionEnabled in pairs(glowingOptions[optionIndex]) do
                if (GetSpellInfo(optionSpellID) == glowSpellName) then
                    return optionEnabled;
                end
            end
        end

        if legacyAllowed then
            for optionSpellID, optionEnabled in pairs(glowingOptions) do
                if (type(optionSpellID) == 'number' and GetSpellInfo(optionSpellID) == glowSpellName) then
                    return optionEnabled;
                end
            end
        end
    end

    return true; -- Enabled by default, in case there is not an option for it
end

-- Add a glow effect for action buttons matching one of the given glow IDs
-- Each glow ID may be a spell identifier (number) or spell name (string)
function SAO.AddGlow(self, spellID, glowIDs, hashData)
    if (glowIDs == nil) then
        return;
    end

    local glowingOptions = self:GetGlowingOptions(spellID);

    for _, glowID in ipairs(glowIDs) do

        -- Find if the glow option is enabled
        local glowEnabled = isGlowingOptionEnabled(glowingOptions, glowID, hashData);

        -- Let it glow
        if (glowEnabled) then
            if (type(glowID) == "number") then
                -- glowID is a direct spell identifier
                self:AddGlowNumber(spellID, glowID);
            elseif (type(glowID) == "string") then
                -- glowID is a spell name: find spell identifiers and then parse them
                local glowSpellIDs = self:GetSpellIDsByName(glowID);
                for _, glowSpellID in ipairs(glowSpellIDs) do
                    self:AddGlowNumber(spellID, glowSpellID);
                end
            end
        end
    end
end

-- Remove the glow effect for action buttons matching any of the given spell IDs
function SAO.RemoveGlow(self, spellID)
    local consumedGlowSpellIDs = {};

    -- First, gather each glowSpellID attached to spellID
    for glowSpellID, triggerSpellIDs in pairs(self.GlowingSpells) do
        if (triggerSpellIDs[spellID]) then
            -- spellID is attached to this glowSpellID
            -- Gather how many triggers are attached to the same glowSpellID (spellID included)
            local count = 0;
            for _, _  in pairs(triggerSpellIDs) do
                count = count+1;
            end
            consumedGlowSpellIDs[glowSpellID] = count;
        end
    end

    -- Then detach the spellID <-> glowSpellID link
    -- And remove the glow if and only if the trigger was the last one asking to glow
    for glowSpellID, count in pairs(consumedGlowSpellIDs) do
        if (count > 1) then
            -- Only detach
            self.GlowingSpells[glowSpellID][spellID] = nil;
        else
            -- Detach and un-glow
            self.GlowingSpells[glowSpellID] = nil;
            local actionButtons = self.ActionButtons[glowSpellID];
            for _, frame in pairs(actionButtons or {}) do
                DisableGlow(frame, frame.GetGlowID and frame:GetGlowID(), "direct deactivation");
            end
        end
    end
end

local warnedOutdatedLBG = false
local function warnOutdatedLBG()
    -- Warn players that their configuration has an issue with glowing buttons
    -- There is one case where this warning is misleading: if LibActionButton for ElvUI and for non-ElvUI are loaded at the same time
    -- But this should not happen in practice, because ElvUI usually replaces pretty much anything UI-related in the game
    if warnedOutdatedLBG then return end

    local text = "[|cffa2f3ff"..AddonName.."|r] One of your addons uses an old version of LibButtonGlow. "
               .."|cffff0000Please consider updating your addons|r. "
               .."Glowing buttons have been |cffff8040temporarily disabled|r to prevent issues. "
               .."(note: the Glowing Buttons option can still be enabled, but it will have no effect until the faulty addon is up-to-date)";
    print(text);

    warnedOutdatedLBG = true
end

-- Track PLAYER_LOGIN which happens immediately after all ADDON_LOADED events
-- Which means, at this point we know which addons are installed and loaded
local binder = CreateFrame("Frame", "NecrosisSpellActivationOverlayLABBinder");
binder:RegisterEvent("PLAYER_LOGIN");
binder:SetScript("OnEvent", function()
    if (not LibStub) then
        -- LibStub is a must-have to load libraries required by this binder
        return
    end

    local LAB = LibStub("LibActionButton-1.0", true);
    local LAB_ElvUI = LibStub("LibActionButton-1.0-ElvUI", true);
    local LAB_GE = LibStub("LibActionButton-1.0-GE", true);
    local LBG, LBGversion = LibStub("LibButtonGlow-1.0", true);
    local LCG = LibStub("LibCustomGlow-1.0", true);

    local buttonUpdateFunc = function(libGlow, event, self)
        if (self._state_type ~= "action") then
            -- If button is not an "action", then GetSpellId is unusable
            -- This happens for instance with vehicle buttons
            -- They are probably not meant to glow, so it's simpler to just ignore them
            return;
        end
        if (not self.GetGlowID) then
            self.GetGlowID = self.GetSpellId;
        end
        if (not self.EnableGlow) then
            self.EnableGlow = function(button)
                libGlow.ShowOverlayGlow(button);
            end
        end
        if (not self.DisableGlow) then
            self.DisableGlow = function(button)
                libGlow.HideOverlayGlow(button);
            end
        end
        SAO:UpdateActionButton(self);
    end

    local LBGButtonUpdateFunc = function(event, self)
        buttonUpdateFunc(LBG, event, self);
    end

    local LCGButtonUpdateFunc = function(event, self)
        buttonUpdateFunc(LCG, event, self);
    end

    local LAB_GEButtonUpdateFunc = function(event, self)
        buttonUpdateFunc(LAB_GE, event, self);
    end

    -- Support for LibActionButton used by e.g., Bartender
    if (LAB and LBG and LBGversion >= 8) then -- Prioritize LibButtonGlow, if available
        LAB:RegisterCallback("OnButtonUpdate", LBGButtonUpdateFunc);
    elseif (LAB and LCG) then -- Otherwise fall back to LibCustomGlow
        LAB:RegisterCallback("OnButtonUpdate", LCGButtonUpdateFunc);
    elseif (LAB and LBG) then
        warnOutdatedLBG();
    end

    -- Support for ElvUI's LibActionButton
    if (LAB_ElvUI) then
        -- For some time, ElvUI favored LibCustomGlow by default
        -- On ElvUI 13.01 and higher, LibButtonGlow is the official lib for ElvUI
        -- This is probably due to a bug of LibCustomGlow under ElvUI 13
        -- Although we're not sure if the bug existed in 13.00, we favor LBG for all 13.xx versions
        local hasElvUI13OrHigher = false
        if (ElvUI and ElvUI[1] and type(ElvUI[1].version) == 'number') then
            hasElvUI13OrHigher = ElvUI[1].version >= 13
        end
        -- However, there is a bug with ProjectAzilroka which hasn't been updated since Ulduar patch
        -- So we switch back to the old priority if an old Azilroka is found
        local hasAzilroka186OrLower = false
        if (ProjectAzilroka and type(ProjectAzilroka.Version) == 'string') then
            local _, _, azilMajor, azilMinor = strfind(ProjectAzilroka.Version, "(%d+)%.(%d+)")
            azilMajor = tonumber(azilMajor)
            azilMinor = tonumber(azilMinor)
            if (type(azilMajor) == 'number' and type(azilMinor) == 'number') then
                hasAzilroka186OrLower = azilMajor < 1 or azilMajor == 1 and azilMinor <= 86
            end
        end
        if (hasElvUI13OrHigher and not hasAzilroka186OrLower) then
            if (LBG and LBGversion >= 8) then
                LAB_ElvUI:RegisterCallback("OnButtonUpdate", LBGButtonUpdateFunc);
            elseif (LCG) then
                LAB_ElvUI:RegisterCallback("OnButtonUpdate", LCGButtonUpdateFunc);
            elseif (LBG) then
                warnOutdatedLBG();
            end
        else
            if (LCG) then -- Prioritize LibCustomGlow, if available
                LAB_ElvUI:RegisterCallback("OnButtonUpdate", LCGButtonUpdateFunc);
            elseif (LBG and LBGversion >= 8) then -- Otherwise fall back to LibButtonGlow
                LAB_ElvUI:RegisterCallback("OnButtonUpdate", LBGButtonUpdateFunc);
            elseif (LBG) then
                warnOutdatedLBG();
            end
        end
    end

    -- Support for AzeriteUI5's LibActionButton
    if (LAB_GE) then
        LAB_GE:RegisterCallback("OnButtonUpdate", LAB_GEButtonUpdateFunc)
    end

    binder:UnregisterEvent("PLAYER_LOGIN");
end);
