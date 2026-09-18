--[[
    Necrosis - Pre-Localization Setup
    This file runs BEFORE locale files are loaded to handle ForceEnglish option
]]--

-- Only override GetLocale if ForceEnglish is explicitly enabled
-- This minimizes impact on other addons
if NecrosisConfig and NecrosisConfig.ForceEnglish then
    -- Store the original GetLocale function
    local OriginalGetLocale = _G.GetLocale

    -- Create a wrapper that respects the ForceEnglish setting
    _G.GetLocale = function()
        if NecrosisConfig and NecrosisConfig.ForceEnglish then
            return "enUS"
        end
        -- Otherwise use the real locale
        return OriginalGetLocale()
    end
end
