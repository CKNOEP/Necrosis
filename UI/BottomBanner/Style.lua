if not NUI then
	error("ERROR: NUI is nil!")
	return
end

if not NecrosisUI then
	error("ERROR: NecrosisUI is nil!")
	return
end

local NUI, L = NUI, NUI.L
local artFrame = CreateFrame('Frame', 'NUI_Art_Classic', NecrosisUI)

----------------------------------------------------------------------------------------------------
local SkinnedFrames = {}

local function CreateArtwork()
	--print("[NecrosisUI] CreateArtwork() started")

	if not NUI_BottomAnchor then
		error("[NecrosisUI] ERROR: NUI_BottomAnchor is nil!")
		return
	end

	local plate = CreateFrame('Frame', 'Classic_ActionBarPlate', artFrame)
	plate:SetSize(1002, 139)
	plate:SetFrameStrata('BACKGROUND')
	plate:SetFrameLevel(1)
	plate:SetAllPoints(NUI_BottomAnchor)
	--print("[NecrosisUI] Plate frame created")

	-- Setup the Bottom Artwork
	artFrame:SetFrameStrata('BACKGROUND')
	artFrame:SetFrameLevel(1)
	artFrame:SetAlpha(1.0)  -- 100% opaque pour bien voir la teinte violette
	artFrame:SetSize(2, 2)
	-- Guard against NecrosisConfig not being loaded yet
	local scale = 0.78 * ((NecrosisConfig and NecrosisConfig.BottomBannerScale) or 1.0)
	artFrame:SetScale(scale)
	artFrame:SetPoint('BOTTOM', NUI_BottomAnchor)

	artFrame.Center = artFrame:CreateTexture('NUI_Art_Classic_Center', 'BACKGROUND')
	artFrame.Center:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-center')
	artFrame.Center:SetPoint('BOTTOM', artFrame, 'BOTTOM')
	artFrame.Center:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen

	artFrame.Left = artFrame:CreateTexture('NUI_Art_Classic_Left', 'BACKGROUND')
	artFrame.Left:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-left1')
	artFrame.Left:SetPoint('BOTTOMRIGHT', artFrame.Center, 'BOTTOMLEFT', 0, 0)
	artFrame.Left:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen
	artFrame.FarLeft = artFrame:CreateTexture('NUI_Art_Classic_FarLeft', 'BACKGROUND')
	artFrame.FarLeft:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-left2')
	artFrame.FarLeft:SetPoint('BOTTOMRIGHT', artFrame.Left, 'BOTTOMLEFT', 0, 0)
	artFrame.FarLeft:SetPoint('BOTTOMLEFT', NecrosisUI, 'BOTTOMLEFT', 0, 0)
	artFrame.FarLeft:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen

	artFrame.Right = artFrame:CreateTexture('NUI_Art_Classic_Right', 'BACKGROUND')
	artFrame.Right:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-right1')
	artFrame.Right:SetPoint('BOTTOMLEFT', artFrame.Center, 'BOTTOMRIGHT')
	artFrame.Right:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen
	artFrame.FarRight = artFrame:CreateTexture('NUI_Art_Classic_FarRight', 'BACKGROUND')
	artFrame.FarRight:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-right2')
	artFrame.FarRight:SetPoint('BOTTOMLEFT', artFrame.Right, 'BOTTOMRIGHT')
	artFrame.FarRight:SetPoint('BOTTOMRIGHT', NecrosisUI, 'BOTTOMRIGHT')
	artFrame.FarRight:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen

	--print("[NecrosisUI] CreateArtwork() completed successfully!")
	--print("[NecrosisUI] artFrame visible:", artFrame:IsVisible())
	--print("[NecrosisUI] NecrosisUI visible:", NecrosisUI:IsVisible())
end

-- Detect WoW version
local wowBuild = select(4, GetBuildInfo())
local versionName = "Unknown"
if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	versionName = "Retail (Mainline)"
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	versionName = "Classic"
elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
	versionName = "TBC Classic"
elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
	versionName = "Wrath Classic"
elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
	versionName = "Cata Classic"
elseif WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
	versionName = "MOP Classic"
end

-- Execute immediately on load
--print("[NecrosisUI] ========================================")
--print("[NecrosisUI] Style.lua loaded - WoW Version: " .. versionName .. " (Build: " .. wowBuild .. ")")
--print("[NecrosisUI] Calling CreateArtwork()...")
if CreateArtwork then
	CreateArtwork()
	--print("[NecrosisUI] CreateArtwork() executed successfully!")
else
	error("[NecrosisUI] ERROR: CreateArtwork function not found!")
end
--print("[NecrosisUI] ========================================")
