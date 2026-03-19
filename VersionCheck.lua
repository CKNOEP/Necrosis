--[[
    Necrosis - Version Check Module
    Checks for addon updates from GitHub releases
    Copyright (C) - GPL v2
--]]

local VersionCheck = CreateFrame("Frame")
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

-- Configuration
local CONFIG = {
    ADDON_NAME = "Necrosis",
    CURRENT_VERSION = "8.3.0",
    GITHUB_REPO = "CKNOEP/Necrosis",
    GITHUB_API_URL = "https://api.github.com/repos/CKNOEP/Necrosis/releases/latest",
    CURSEFORGE_URL = "https://www.curseforge.com/wow/addons/necrosis",
    GITHUB_URL = "https://github.com/CKNOEP/Necrosis",
    CHECK_INTERVAL = 86400, -- 24 heures en secondes
}

-- State
VersionCheck.LastCheckTime = 0
VersionCheck.RemoteVersion = nil
VersionCheck.UpdateAvailable = false
VersionCheck.Enabled = true

----------------------------------------------
-- Version Comparison
----------------------------------------------

function VersionCheck:ParseVersion(versionString)
    if not versionString then return nil end

    -- Extract version numbers from string like "v8.3.0" or "8.3.0"
    local major, minor, patch = versionString:match("v?(%d+)%.(%d+)%.(%d+)")

    if not major then
        return nil
    end

    return {
        major = tonumber(major),
        minor = tonumber(minor),
        patch = tonumber(patch),
        original = versionString,
    }
end

function VersionCheck:CompareVersions(current, remote)
    if not current or not remote then
        return false, "Invalid version format"
    end

    local cur = self:ParseVersion(current)
    local rem = self:ParseVersion(remote)

    if not cur or not rem then
        return false, "Could not parse versions"
    end

    -- Compare versions: remote > current ?
    if rem.major > cur.major then
        return true, rem.original
    elseif rem.major == cur.major then
        if rem.minor > cur.minor then
            return true, rem.original
        elseif rem.minor == cur.minor then
            if rem.patch > cur.patch then
                return true, rem.original
            end
        end
    end

    return false, nil
end

----------------------------------------------
-- HTTP Request (Fallback methods)
----------------------------------------------

function VersionCheck:FetchLatestVersion()
    -- Try LibHTTP first (if available)
    if LibStub then
        local HttpLib = LibStub:GetLibrary("LibHTTP", true)
        if HttpLib then
            return self:FetchViaLibHTTP()
        end
    end

    -- Fallback: No HTTP capability, will use local check
    return nil
end

function VersionCheck:FetchViaLibHTTP()
    -- This is a framework for LibHTTP if available
    -- In practice, WoW Lua HTTP is limited, so we use fallback methods
    return nil
end

function VersionCheck:ParseGitHubResponse(jsonString)
    if not jsonString then
        return nil
    end

    -- Simple JSON parsing for version tag
    -- Looking for: "tag_name": "v8.3.0"
    local version = jsonString:match('"tag_name"%s*:%s*"([^"]+)"')

    if version then
        return version
    end

    return nil
end

----------------------------------------------
-- Version Check Logic
----------------------------------------------

function VersionCheck:CheckForUpdate()
    if not self.Enabled then
        return
    end

    local currentTime = GetTime()

    -- Check interval: only check every 24h (or on manual request)
    if currentTime - self.LastCheckTime < CONFIG.CHECK_INTERVAL and self.RemoteVersion then
        return self.UpdateAvailable
    end

    self.LastCheckTime = currentTime

    -- Try to fetch remote version
    local remoteVersion = self:FetchLatestVersion()

    -- Fallback: If no HTTP available, notify user to check manually
    if not remoteVersion then
        self:NotifyManualCheck()
        return false
    end

    self.RemoteVersion = remoteVersion

    -- Compare versions
    local updateAvailable, newVersion = self:CompareVersions(CONFIG.CURRENT_VERSION, remoteVersion)

    self.UpdateAvailable = updateAvailable

    if updateAvailable then
        self:NotifyUpdate(newVersion)
    end

    return updateAvailable
end

----------------------------------------------
-- User Notifications
----------------------------------------------

function VersionCheck:NotifyUpdate(newVersion)
    local message = format(
        "|cff00ff00[%s]|r " .. (L["VERSION_UPDATE_AVAILABLE"] or "Update available"),
        CONFIG.ADDON_NAME
    )

    print(message)
    print(format("|cffff9900%s:|r %s → %s",
        L["CURRENT_VERSION"] or "Current Version",
        CONFIG.CURRENT_VERSION,
        newVersion
    ))

    print(format("|cff1e90ff%s:|r %s",
        L["DOWNLOAD"] or "Download",
        CONFIG.CURSEFORGE_URL
    ))

    print(format("|cff1e90ff%s:|r %s",
        L["GITHUB"] or "GitHub",
        CONFIG.GITHUB_URL .. "/releases"
    ))

    print(format("|cffaabb00%s|r /necrosis version",
        L["TYPE"] or "Type"
    ))

    -- Create popup notification (optional)
    self:CreateUpdateNotificationFrame(newVersion)
end

function VersionCheck:NotifyManualCheck()
    -- No HTTP available - suggest manual check
    local message = format(
        "|cff00ff00[%s]|r " .. (L["VERSION_CHECK_MANUAL"] or "Check for updates manually"),
        CONFIG.ADDON_NAME
    )

    print(message)
    print(format("|cff1e90ff%s|r: %s",
        L["CURSEFORGE"] or "CurseForge",
        CONFIG.CURSEFORGE_URL
    ))
    print(format("|cff1e90ff%s|r: %s",
        L["GITHUB"] or "GitHub",
        CONFIG.GITHUB_URL
    ))
end

function VersionCheck:NotifyCurrentVersion()
    print(format(
        "|cff00ff00[%s]|r " .. (L["CURRENT_VERSION"] or "Version") .. ": |cffffffff%s|r",
        CONFIG.ADDON_NAME,
        CONFIG.CURRENT_VERSION
    ))

    if self.RemoteVersion then
        local updateAvailable = self:CompareVersions(CONFIG.CURRENT_VERSION, self.RemoteVersion)
        if updateAvailable then
            print(format("|cffff0000%s|r: %s",
                L["UPDATE_AVAILABLE"] or "Update Available",
                self.RemoteVersion
            ))
        else
            print(format("|cff00ff00%s|r",
                L["UP_TO_DATE"] or "You are up to date!"
            ))
        end
    end
end

----------------------------------------------
-- Update Notification Frame
----------------------------------------------

function VersionCheck:CreateUpdateNotificationFrame(newVersion)
    -- Create a simple notification frame (optional, can be disabled)
    if _G["NecrosisUpdateNotification"] then
        _G["NecrosisUpdateNotification"]:Hide()
    end

    local frame = CreateFrame("Frame", "NecrosisUpdateNotification", UIParent)
    frame:SetSize(400, 120)
    frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20, -80)
    frame:SetFrameStrata("DIALOG")

    -- Backdrop
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0.1, 0.1, 0.15, 0.9)
    frame:SetBackdropBorderColor(0.31, 0.31, 0.31)

    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -12)
    title:SetText("|cff00ff00" .. CONFIG.ADDON_NAME .. "|r " .. (L["UPDATE_AVAILABLE"] or "Update Available"))

    -- Version info
    local versionText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    versionText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    versionText:SetText(format("|cffffaa00%s:|r %s → %s",
        L["VERSION"] or "Version",
        CONFIG.CURRENT_VERSION,
        newVersion
    ))

    -- Action button
    local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    btn:SetSize(80, 24)
    btn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -12, 12)
    btn:SetText(L["UPDATE"] or "Update")
    btn:SetScript("OnClick", function()
        if IsAddOnLoaded("Curse") or IsAddOnLoaded("Overwolf") then
            -- Open CurseForge client addon search
            SlashCmdList["ADDONUPDATE"](CONFIG.ADDON_NAME)
        else
            -- Open browser
            print("|cff1e90ff" .. CONFIG.CURSEFORGE_URL .. "|r")
        end
        frame:Hide()
    end)

    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)

    -- Auto-hide after 10 seconds
    C_Timer.After(10, function()
        if frame and frame:IsVisible() then
            frame:Hide()
        end
    end)

    frame:Show()
end

----------------------------------------------
-- Initialization
----------------------------------------------

function VersionCheck:Init()
    self.Enabled = NecrosisConfig.VersionCheck and NecrosisConfig.VersionCheck.Enabled ~= false

    if not self.Enabled then
        return
    end

    -- Check for updates on addon load (with slight delay)
    C_Timer.After(5, function()
        self:CheckForUpdate()
    end)

    -- Register slash command for manual check
    SLASH_NECROSISVERSION1 = "/necrosis version"
    SlashCmdList["NECROSISVERSION"] = function()
        VersionCheck:NotifyCurrentVersion()
        VersionCheck:CheckForUpdate()
    end
end

----------------------------------------------
-- Class Gate - Initialize for Warlocks
----------------------------------------------

do
    local _, playerClass = UnitClass("player")
    if playerClass == "WARLOCK" then
        -- Initialize with slight delay to ensure NecrosisConfig is loaded
        C_Timer.After(1, function()
            VersionCheck:Init()
        end)
    end
end
