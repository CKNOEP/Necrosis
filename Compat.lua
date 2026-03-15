--[[
    Necrosis - Midnight (12.0+) Compatibility Layer
    Provides backward-compatible wrappers for deprecated APIs
--]]

-- ============================================================================
-- GetSpellInfo Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.GetSpellInfo then
    function _G.GetSpellInfo(spellID)
        if not spellID then return nil end
        spellID = tonumber(spellID)
        if not spellID or spellID <= 0 then return nil end

        local spellInfo = C_Spell.GetSpellInfo(spellID)
        if not spellInfo then return nil end

        -- Return in old format: name, rank, icon, castTime, minRange, maxRange, spellId
        return spellInfo.name, nil, spellInfo.iconID, nil, nil, nil, spellID
    end
end

-- ============================================================================
-- GetSpellCooldown Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.GetSpellCooldownOriginal then
    _G.GetSpellCooldownOriginal = _G.GetSpellCooldown
    function _G.GetSpellCooldown(spellID)
        if not spellID then return 0, 0, 1 end
        spellID = tonumber(spellID)
        if not spellID or spellID <= 0 then return 0, 0, 1 end

        local cooldownInfo = C_Spell.GetSpellCooldown(spellID)
        if not cooldownInfo then return 0, 0, 1 end

        -- Return in old format: startTime, duration, isEnabled
        return cooldownInfo.startTime or 0, cooldownInfo.duration or 0, cooldownInfo.isEnabled and 1 or 0
    end
end

-- ============================================================================
-- GetItemInfo Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.GetItemInfoOriginal then
    _G.GetItemInfoOriginal = _G.GetItemInfo
    function _G.GetItemInfo(itemID)
        if not itemID then return nil end
        itemID = tonumber(itemID)
        if not itemID or itemID <= 0 then return nil end

        local itemInfo = C_Item.GetItemInfo(itemID)
        if not itemInfo then return nil end

        -- Return in old format
        return itemInfo.itemName, itemInfo.itemLink, itemInfo.quality, itemInfo.itemLevel,
               itemInfo.requiredLevel, itemInfo.itemType, itemInfo.itemSubType,
               itemInfo.stackCount, itemInfo.equipLoc, itemInfo.icon, itemInfo.sellPrice,
               itemInfo.classID, itemInfo.subClassID
    end
end

-- ============================================================================
-- IsAddOnLoaded Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.IsAddOnLoadedOriginal then
    _G.IsAddOnLoadedOriginal = _G.IsAddOnLoaded
    if C_AddOns and C_AddOns.IsAddOnLoaded then
        function _G.IsAddOnLoaded(addOnName)
            return C_AddOns.IsAddOnLoaded(addOnName)
        end
    end
end

-- ============================================================================
-- GetAddOnMetadata Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.GetAddOnMetadataOriginal then
    _G.GetAddOnMetadataOriginal = _G.GetAddOnMetadata
    if C_AddOns and C_AddOns.GetAddOnMetadata then
        function _G.GetAddOnMetadata(addOnName, field)
            return C_AddOns.GetAddOnMetadata(addOnName, field)
        end
    end
end

-- ============================================================================
-- UnitAura Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.UnitAuraOriginal then
    _G.UnitAuraOriginal = _G.UnitAura or function() return nil end
    function _G.UnitAura(unit, index, filter)
        if C_UnitAuras and C_UnitAuras.GetAuraDataByUnit then
            local auras = C_UnitAuras.GetAuraDataByUnit(unit, filter)
            if not auras or not auras[index] then return nil end

            local aura = auras[index]
            -- Return in old format: name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyCustom, isBossAura, isCastByPlayer, nameplateShowAll, timeMod, ...
            return aura.name, aura.icon, aura.applications, aura.dispelName, aura.duration,
                   aura.expirationTime, aura.sourceUnit, aura.canStealOrPurge, aura.nameplateShowPersonal,
                   aura.spellId, aura.canApplyCustom, aura.isBossAura, aura.isCastByPlayer, aura.nameplateShowAll, aura.timeMod
        else
            return _G.UnitAuraOriginal(unit, index, filter)
        end
    end
end

-- ============================================================================
-- UnitBuff Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.UnitBuff then
    function _G.UnitBuff(unit, index)
        if C_UnitAuras and C_UnitAuras.GetAuraDataByUnit then
            local auras = C_UnitAuras.GetAuraDataByUnit(unit, "HELPFUL")
            if not auras or not auras[index] then return nil end

            local aura = auras[index]
            return aura.name, aura.icon, aura.applications, aura.dispelName, aura.duration,
                   aura.expirationTime, aura.sourceUnit, aura.canStealOrPurge, aura.nameplateShowPersonal,
                   aura.spellId, aura.canApplyCustom, aura.isBossAura, aura.isCastByPlayer, aura.nameplateShowAll, aura.timeMod
        end
        return nil
    end
end

-- ============================================================================
-- UnitDebuff Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.UnitDebuff then
    function _G.UnitDebuff(unit, index)
        if C_UnitAuras and C_UnitAuras.GetAuraDataByUnit then
            local auras = C_UnitAuras.GetAuraDataByUnit(unit, "HARMFUL")
            if not auras or not auras[index] then return nil end

            local aura = auras[index]
            return aura.name, aura.icon, aura.applications, aura.dispelName, aura.duration,
                   aura.expirationTime, aura.sourceUnit, aura.canStealOrPurge, aura.nameplateShowPersonal,
                   aura.spellId, aura.canApplyCustom, aura.isBossAura, aura.isCastByPlayer, aura.nameplateShowAll, aura.timeMod
        end
        return nil
    end
end

-- ============================================================================
-- GetSpellPowerCost Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.GetSpellPowerCost then
    function _G.GetSpellPowerCost(spellID)
        if not spellID then return nil end
        spellID = tonumber(spellID)
        if not spellID or spellID <= 0 then return nil end

        -- In WOW 12.0.1, use C_Spell.GetSpellInfo to get power cost
        if C_Spell and C_Spell.GetSpellInfo then
            local spellInfo = C_Spell.GetSpellInfo(spellID)
            if spellInfo and spellInfo.powerCost then
                -- Return as a table similar to old format
                return { { powerType = "MANA", cost = spellInfo.powerCost } }
            end
        end
        return nil
    end
end

-- ============================================================================
-- GetSpellSubtext Compatibility Wrapper (12.0+)
-- Spell ranks were removed in WOW 12.0.1
-- ============================================================================
if not _G.GetSpellSubtext then
    function _G.GetSpellSubtext(spellID)
        -- Spell ranks no longer exist in WOW 12.0.1
        return nil
    end
end

-- ============================================================================
-- Spell Book API Compatibility Wrappers (12.0+)
-- ============================================================================
if not _G.MAX_SKILLLINE_TABS then
    _G.MAX_SKILLLINE_TABS = 1  -- WOW 12.0.1 uses different spell system
end

if not _G.BOOKTYPE_SPELL then
    _G.BOOKTYPE_SPELL = 1
end

if not _G.GetSpellTabInfo then
    function _G.GetSpellTabInfo(tabIndex)
        -- Return empty for spell book tabs (not used in 12.0.1)
        return nil, nil, nil, nil
    end
end

if not _G.GetSpellBookItemName then
    function _G.GetSpellBookItemName(spellBookSlot, bookType)
        -- Return nil for spell book queries (not used in 12.0.1)
        return nil, nil, nil
    end
end

-- ============================================================================
-- C_Spell.GetSpellName (returns just the name, not the old GetSpellInfo format)
-- ============================================================================
if C_Spell and not C_Spell.GetSpellNameOriginal then
    C_Spell.GetSpellNameOriginal = C_Spell.GetSpellName
    -- The new API already exists, just ensure it works
end

-- ============================================================================
-- C_PetBattles.IsInBattle Compatibility Wrapper (12.0+)
-- ============================================================================
-- In Midnight 12.0.1, pet battles system was removed or changed
-- This provides a safe wrapper that returns false when the API is unavailable
if not C_PetBattles then
    C_PetBattles = {}
end

if not C_PetBattles.IsInBattle then
    function C_PetBattles.IsInBattle()
        -- Pet battles don't exist or are disabled in this version
        return false
    end
end

-- Legacy function name compatibility
if not _G.C_PetBattles_IsInBattle then
    function _G.C_PetBattles_IsInBattle()
        -- Wrapper for old-style function call syntax
        return C_PetBattles.IsInBattle()
    end
end

-- ============================================================================
-- C_Club API Compatibility Wrappers (12.0+)
-- ============================================================================
-- Discord communities/clubs may not exist or have changed in Midnight
if not C_Club then
    C_Club = {}
end

if not C_Club.GetStreamInfo then
    function C_Club.GetStreamInfo(clubId, streamId)
        -- Communities not available or streamInfo structure changed
        return nil
    end
end

if not C_Club.GetClubInfo then
    function C_Club.GetClubInfo(clubId)
        -- Communities not available
        return nil
    end
end

-- ============================================================================
-- C_Calendar API Compatibility Wrappers (12.0+)
-- ============================================================================
if not C_Calendar then
    C_Calendar = {}
end

if not C_Calendar.GetNumDayEvents then
    function C_Calendar.GetNumDayEvents(monthOffset, day)
        -- Calendar API changed or not available
        return 0
    end
end

if not C_Calendar.GetDayEvent then
    function C_Calendar.GetDayEvent(monthOffset, day, eventIndex)
        -- Calendar API changed or not available
        return nil
    end
end
