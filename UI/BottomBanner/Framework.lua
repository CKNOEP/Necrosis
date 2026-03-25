-- Initialize NUI Addon (Classic/Simplified Version - No C_EditMode)
-- DEBUG MARKER: Confirm Classic variant is loaded
print("|cFF00FF00[NecrosisUI] CLASSIC VARIANT LOADED - No C_EditMode integration|r")
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

-- Apply layout frames to actual game frames (simplified version without EditMode)
function NUI:ApplyLayoutFrames(layoutInfo)
	if not layoutInfo or not layoutInfo.frames then
		return
	end

	for _, frameData in ipairs(layoutInfo.frames) do
		if frameData and frameData.frameName then
			local frame = _G[frameData.frameName]
			if frame then
				-- Extract position data
				local anchor = frameData.anchor or frameData.point or "BOTTOM"
				local relativeTo = frameData.relativeTo or "UIParent"
				local relativePoint = frameData.relativePoint or anchor
				local x = frameData.x or 0
				local y = frameData.y or 0
				local scale = frameData.scale or 1.0

				-- Apply position
				frame:ClearAllPoints()
				local relativeFrame = relativeTo == "UIParent" and UIParent or _G[relativeTo]
				if relativeFrame then
					frame:SetPoint(anchor, relativeFrame, relativePoint, x, y)
				end

				-- Apply scale
				if scale and scale ~= 1.0 then
					frame:SetScale(scale)
				end
			end
		end
	end
end

-- No-op ImportLayout for Classic (C_EditMode not available)
function NUI:ImportLayout()
	-- EditMode is Retail-only (Dragonflight+)
	-- This function does nothing in Classic versions
	return
end
