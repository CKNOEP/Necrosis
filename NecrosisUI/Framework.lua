-- Initialize NUI as embedded addon (not separate TOC)
local NUI = _G.NUI
if not NUI then
	NUI = LibStub('AceAddon-3.0'):NewAddon('NecrosisUI', 'AceEvent-3.0', 'AceConsole-3.0', 'AceSerializer-3.0')
	_G.NUI = NUI
	print("|cFF00FF00[NecrosisUI Framework]|r Initialized NUI addon")
else
	print("|cFF00FF00[NecrosisUI Framework]|r NUI already exists")
end

-- NecrosisUI uses Necrosis main addon locale
local L = LibStub('AceLocale-3.0'):GetLocale(NECROSIS_ID, true)
local _G = _G
local type, pairs = type, pairs
NUI.L = L

-- NecrosisUI is embedded in Necrosis, use main addon metadata
local GetMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
NUI.Version = GetMetadata('Necrosis', 'Version') or "0"
NUI.BuildNum = GetMetadata('Necrosis', 'X-Build') or "0"

NUI.IsClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
NUI.IsBCC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
NUI.IsRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)


if NUI.IsClassic then
	wowVersion = 'Classic'
end
if NUI.IsBCC then
	wowVersion = 'BCC'
end

---------------  Add Libraries ---------------
--init StdUI Instance for the whole addon

---------------  Options Init ---------------


---------  Create NecrosisUI Container  ---------


---------------  Math and Comparison  ---------------



function NUI:round(num, pos)
	if num then
		local mult = 10 ^ (pos or 2)
		return floor(num * mult + 0.5) / mult
	-- return floor((num * 10 ^ 2) + 0.5) / (10 ^ 2)
	end
end

---------------  Misc Backend  ---------------



-- For Setting a unifid skin across all registered Skinable modules
function NUI:SetActiveStyle(skin)
	NUI:GetModule('Component_Artwork'):SetActiveStyle(skin)

	for name, submodule in NUI:IterateModules() do
		if submodule.SetActiveStyle then
			submodule:SetActiveStyle(skin)
		end
	end

	-- Ensure this is the First and last thing to occur, iincase the art style has any StyleUpdate's needed after doing the other updates
	NUI:GetModule('Component_Artwork'):SetActiveStyle(skin)
end

----------- Create Required Frames -----------

print("|cFF00FF00[NecrosisUI Framework]|r Creating frames...")

-- Create main NecrosisUI container frame
local necrosisUIFrame = CreateFrame("Frame", "NecrosisUI", UIParent)
if necrosisUIFrame then
	print("|cFF00FF00[NecrosisUI Framework]|r NecrosisUI frame created")
	necrosisUIFrame:SetFrameStrata("BACKGROUND")
	necrosisUIFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
	necrosisUIFrame:SetSize(800, 200)
	necrosisUIFrame:Hide()  -- Hidden by default
else
	print("|cFFFF0000[NecrosisUI Framework]|r ERROR: Failed to create NecrosisUI frame!")
end

-- Create bottom anchor for artwork positioning
local bottomAnchor = CreateFrame("Frame", "NUI_BottomAnchor", necrosisUIFrame)
bottomAnchor:SetAllPoints(necrosisUIFrame)
print("|cFF00FF00[NecrosisUI Framework]|r Anchor frame created")

----------- Implement Show/Hide Methods -----------

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
