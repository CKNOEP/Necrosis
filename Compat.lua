--[[
    Necrosis - Midnight (12.0+) Compatibility Layer
    Provides backward-compatible wrappers for deprecated APIs
--]]

-- ============================================================================
-- GetSpellInfo Compatibility Wrapper (12.0+)
-- ============================================================================
if not _G.GetSpellInfo then
    function _G.GetSpellInfo(spellID)
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
    _G.UnitAuraOriginal = _G.UnitAura
    function _G.UnitAura(unit, index, filter)
        if not C_UnitAuras or not C_UnitAuras.GetAuraDataByUnit then
            return _G.UnitAuraOriginal(unit, index, filter)
        end

        local auras = C_UnitAuras.GetAuraDataByUnit(unit, filter)
        if not auras or not auras[index] then return nil end

        local aura = auras[index]
        -- Return in old format: name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyCustom, isBossAura, isCastByPlayer, nameplateShowAll, timeMod, ...
        return aura.name, aura.icon, aura.applications, aura.dispelName, aura.duration,
               aura.expirationTime, aura.sourceUnit, aura.canStealOrPurge, aura.nameplateShowPersonal,
               aura.spellId, aura.canApplyCustom, aura.isBossAura, aura.isCastByPlayer, aura.nameplateShowAll, aura.timeMod
    end
end

-- ============================================================================
-- C_Spell.GetSpellName (returns just the name, not the old GetSpellInfo format)
-- ============================================================================
if C_Spell and not C_Spell.GetSpellNameOriginal then
    C_Spell.GetSpellNameOriginal = C_Spell.GetSpellName
    -- The new API already exists, just ensure it works
end
