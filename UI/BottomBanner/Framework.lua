-- Initialize NUI Addon
local NUI = _G.NUI
if not NUI then
	NUI = LibStub('AceAddon-3.0'):NewAddon('NecrosisUI', 'AceEvent-3.0', 'AceConsole-3.0', 'AceSerializer-3.0')
	_G.NUI = NUI
end

-- Create main NecrosisUI container frame
local necrosisUIFrame = CreateFrame("Frame", "NecrosisUI", UIParent)
necrosisUIFrame:SetFrameStrata("BACKGROUND")
necrosisUIFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
necrosisUIFrame:SetSize(800, 200)
necrosisUIFrame:Hide()

-- Create bottom anchor for artwork positioning
local bottomAnchor = CreateFrame("Frame", "NUI_BottomAnchor", necrosisUIFrame)
bottomAnchor:SetAllPoints(necrosisUIFrame)

-- Implement Show/Hide Methods
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

function NUI:UpdateBottomBannerScale()
	if NUI_Art_Classic then
		local scale = 0.78 * (NecrosisConfig.BottomBannerScale or 1.0)
		NUI_Art_Classic:SetScale(scale)
	end
end
