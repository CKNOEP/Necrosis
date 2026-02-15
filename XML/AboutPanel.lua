--[[
    Necrosis - About Panel
    Presents addon information, links, and credits
    Copyright (C) - GPL v2
--]]

local _G = getfenv(0)
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

----------------------------------------------
-- About Panel Creation
----------------------------------------------

function Necrosis:CreateAboutPanel()
    local frame = _G["NecrosisAboutFrame"]

    if not frame then
        -- Main frame
        frame = CreateFrame("Frame", "NecrosisAboutFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
        frame:SetSize(700, 600)
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        frame:SetFrameStrata("DIALOG")
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
        end)

        -- Backdrop
        frame:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        frame:SetBackdropColor(0.06, 0.06, 0.06, 0.9)
        frame:SetBackdropBorderColor(0.31, 0.31, 0.31)

        -- Title
        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", frame, "TOP", 0, -20)
        title:SetText("|c00FFFFFF" .. L["NECROSIS_LABEL"] .. " |c0000ff00v" .. self.Data.Version .. "|r")

        -- Close button
        local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
        closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
        closeBtn:SetScript("OnClick", function() frame:Hide() end)

        -- Subtitle
        local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        subtitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -50)
        subtitle:SetWidth(660)
        subtitle:SetHeight(0)
        subtitle:SetJustifyH("LEFT")
        subtitle:SetJustifyV("TOP")
        subtitle:SetTextColor(1, 1, 0.8)
        subtitle:SetText(L["ABOUT_SUBTITLE"] or "Warlock UI & Shard Management for World of Warcraft")

        -- Description
        local desc = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        desc:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -100)
        desc:SetWidth(660)
        desc:SetHeight(0)
        desc:SetJustifyH("LEFT")
        desc:SetJustifyV("TOP")
        desc:SetText(L["ABOUT_DESCRIPTION"] or [[
Necrosis is the ultimate Warlock addon, providing comprehensive UI management for soul shards, spells, demon summoning, buffs, curses, and timers. Over 20 years of continuous development and community support.

This addon features a radial button interface, graphical shard display, extensive customization options, and now includes advanced features like Summon Queue management with raid synchronization.

Built with passion for the Warlock class community.
]])

        -- Links Section
        local linksTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        linksTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -240)
        linksTitle:SetText("|cff00ff00" .. (L["DOWNLOAD_SUPPORT"] or "Download & Support") .. "|r")

        -- CurseForge Button
        local cfBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        cfBtn:SetSize(140, 28)
        cfBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -270)
        cfBtn:SetText("CurseForge")
        cfBtn:SetScript("OnClick", function()
            print("|cff1e90ffhttps://www.curseforge.com/wow/addons/necrosis|r")
        end)

        -- GitHub Button
        local ghBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        ghBtn:SetSize(140, 28)
        ghBtn:SetPoint("LEFT", cfBtn, "RIGHT", 10, 0)
        ghBtn:SetText("GitHub")
        ghBtn:SetScript("OnClick", function()
            print("|cff1e90ffhttps://github.com/CKNOEP/Necrosis|r")
        end)

        -- PayPal Button
        local ppBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        ppBtn:SetSize(140, 28)
        ppBtn:SetPoint("LEFT", ghBtn, "RIGHT", 10, 0)
        ppBtn:SetText("|c00FFD700PayPal Donate|r")
        ppBtn:SetScript("OnClick", function()
            print("|cff1e90ffhttps://www.paypal.com/donate?hosted_button_id=NECROSIS|r")
            print("|cffffaa00Thank you for supporting Necrosis development!|r")
        end)

        -- Credits Section
        local creditsTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        creditsTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -320)
        creditsTitle:SetText("|cff00ff00" .. (L["CREDITS"] or "Development Team") .. "|r")

        -- Credits Text (Scrollable)
        local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -350)
        scrollFrame:SetSize(640, 200)

        local creditsText = scrollFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        creditsText:SetWidth(620)
        creditsText:SetHeight(0)
        creditsText:SetJustifyH("LEFT")
        creditsText:SetJustifyV("TOP")

        local credits = L["ABOUT_CREDITS"] or [[
|c00FFD700Original Author:|r Lomig, lädygaga (Sulfuron EUR)

|c00FFD700Contributors (20+ years):|r
• Tarcalion - Core development
• Community Warlocks - Feedback & Testing
• Translators - Localization support
• Bug Reporters - Quality assurance

|c00FFD700Special Thanks:|r
• WoW API Documentation
• Ace3 Framework Team
• LibStub Library Developers
• The global Warlock community

|c00FFD700License:|r GPL v2
|c00FFD700Repository:|r github.com/CKNOEP/Necrosis
]]

        creditsText:SetText(credits)
        scrollFrame:SetScrollChild(creditsText)

        -- Version Info
        local versionInfo = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        versionInfo:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 12)
        versionInfo:SetTextColor(0.7, 0.7, 0.7)
        versionInfo:SetText(format(
            "|c00888888Necrosis %s | WoW Classic, WotLK, Cataclysm|r",
            self.Data.Version or "8.3.0"
        ))

        -- Copyright
        local copyright = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        copyright:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 12)
        copyright:SetTextColor(0.7, 0.7, 0.7)
        copyright:SetText("|c00888888© 2004-2026 Licensed under GPL v2|r")
    end

    frame:Show()
end

----------------------------------------------
-- Slash Command
----------------------------------------------

SLASH_NECROSISABOUT1 = "/necrosis about"
SlashCmdList["NECROSISABOUT"] = function()
    Necrosis:CreateAboutPanel()
end
