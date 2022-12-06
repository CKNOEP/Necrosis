local AddonName, OVERLAY = ...

--regroup
-- AURA 		(Line 20-98)
-- OVERLAY		(Line 100-132)
-- COUNTER		(Line 20)		
-- EVENTS		(Line 20)
-- GLOW			(Line 20)

-- SPELL		(Line 20)
-- UTIL			(Line 20)
----
----		

---------------
--- AURA ------
---------------
--[[
    Lists of auras that must be tracked
    
	
]]
OVERLAY.RegisteredAurasByName = {}
OVERLAY.RegisteredAurasBySpellID = {}

-- Register a new aura
-- If texture is nil, no Spell Activation Overlay (SAO) is triggered; subsequent params are ignored until glowIDs
-- If texture is a function, it will be evaluated at runtime when the SAO is triggered
-- If glowIDs is nil or empty, no Glowing Action Button (GAB) is triggered
-- All SAO arguments (between spellID and b, included) mimic Retail's SPELL_ACTIVATION_OVERLAY_SHOW event arguments
function OVERLAY.RegisterAura(self, name, stacks, spellID, texture, positions, scale, r, g, b, autoPulse, glowIDs)
    if (type(texture) == 'string') then
        texture = self.TexName[texture];
    end
    local aura = { name, stacks, spellID, texture, positions, scale, r, g, b, autoPulse, glowIDs }

    -- Register aura in the spell list, sorted by spell ID and by stack count
    self.RegisteredAurasByName[name] = aura;
    if self.RegisteredAurasBySpellID[spellID] then
        if self.RegisteredAurasBySpellID[spellID][stacks] then
            table.insert(self.RegisteredAurasBySpellID[spellID][stacks], aura)
        else
            self.RegisteredAurasBySpellID[spellID][stacks] = { aura };
        end
    else
        self.RegisteredAurasBySpellID[spellID] = { [stacks] = { aura } }
    end

    -- Register the glow IDs
    -- The same glow ID may be registered by different auras, but it's okay
    self:RegisterGlowIDs(glowIDs);

    -- Apply aura immediately, if found
    local exists, _, count = self:FindPlayerAuraByID(spellID);
    if (exists and (stacks == 0 or stacks == count)) then
        self:ActivateOverlay(count, select(3,unpack(aura)));
        self:AddGlow(spellID, select(11,unpack(aura)));
    end
end
-- List of currently active overlays
-- key = spellID, value = aura config
-- This list will change each time an overlay is triggered or un-triggered
OVERLAY.ActiveOverlays = {}

-- Check if overlay is active
function OVERLAY.GetActiveOverlay(self, spellID)
    return self.ActiveOverlays[spellID] ~= nil;
end

-- Search in overlay options if the specified auraID should be discarded
-- By default, do *not* discard
-- This happens e.g., if there is no option for this auraID
local function discardedByOverlayOption(self, auraID, stacks)
    if (not SpellActivationOverlayDB) then
        return false; -- By default, do not discard
    end

    if (SpellActivationOverlayDB.alert and not SpellActivationOverlayDB.alert.enabled) then
        return true;
    end

    local overlayOptions = self:GetOverlayOptions(auraID);

    if (not overlayOptions) then
        return false; -- By default, do not discard
    end

    -- Look for option in the exact stack count
    if (type(overlayOptions[stacks]) ~= "nil") then
        return not overlayOptions[stacks];
    end

    -- Look for a default option as if stacks == 0
    if (stacks and stacks > 0 and type(overlayOptions[0]) ~= "nil") then
        return not overlayOptions[0];
    end

    return false; -- By default, do not discard
end

-- Add or refresh an overlay
function OVERLAY.ActivateOverlay(self, stacks, spellID, texture, positions, scale, r, g, b, autoPulse, forcePulsePlay)
    if (texture) then
        -- Tell the overlay is active, even though the overlay may be discarded below
        -- This "active state" tells the aura is in place, which is used by e.g. the glowing button system
        self.ActiveOverlays[spellID] = stacks;

        -- Discard the overlay if options are not favorable
        if (discardedByOverlayOption(self, spellID, stacks)) then
            return;
        end

        -- Hack to avoid glowIDs to be treated as forcePulsePlay
        if (type(forcePulsePlay) == 'table') then
            forcePulsePlay = false;
        end

        -- Fetch texture from functor if needed
        if (type(texture) == 'function') then
            texture = texture(self);
        end

        -- Actually show the overlay(s)
        self.ShowAllOverlays(self.Frame, spellID, texture, positions, scale, r, g, b, autoPulse, forcePulsePlay);
    end
end

-- Remove an overlay
function OVERLAY.DeactivateOverlay(self, spellID)
    self.ActiveOverlays[spellID] = nil;
    self.HideOverlays(self.Frame, spellID);
end
