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

	local plate = CreateFrame('Frame', 'Classic_ActionBarPlate', artFrame)
	plate:SetSize(1002, 139)
	plate:SetFrameStrata('BACKGROUND')
	plate:SetFrameLevel(1)
	plate:SetAllPoints(NUI_BottomAnchor)

	-- Setup the Bottom Artwork
	artFrame:SetFrameStrata('BACKGROUND')
	artFrame:SetFrameLevel(1)
	artFrame:SetAlpha(1.0)  -- 100% opaque pour bien voir la teinte violette
	artFrame:SetSize(2, 2)
	local scale = 0.78 * (NecrosisConfig.BottomBannerScale or 1.0)
	artFrame:SetScale(scale)
	artFrame:SetPoint('BOTTOM', NUI_BottomAnchor)

	artFrame.Center = artFrame:CreateTexture('NUI_Art_Classic_Center', 'BACKGROUND')
	artFrame.Center:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-center')
	artFrame.Center:SetSize(320, 139)
	artFrame.Center:SetPoint('BOTTOM', artFrame, 'BOTTOM')
	artFrame.Center:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen

	artFrame.Left = artFrame:CreateTexture('NUI_Art_Classic_Left', 'BACKGROUND')
	artFrame.Left:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-left1')
	artFrame.Left:SetSize(240, 139)
	artFrame.Left:SetPoint('BOTTOMRIGHT', artFrame.Center, 'BOTTOMLEFT', 0, 0)
	artFrame.Left:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen
	artFrame.FarLeft = artFrame:CreateTexture('NUI_Art_Classic_FarLeft', 'BACKGROUND')
	artFrame.FarLeft:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-left2')
	artFrame.FarLeft:SetSize(240, 139)
	artFrame.FarLeft:SetPoint('BOTTOMRIGHT', artFrame.Left, 'BOTTOMLEFT', 0, 0)
	artFrame.FarLeft:SetPoint('BOTTOMLEFT', NecrosisUI, 'BOTTOMLEFT', 0, 0)
	artFrame.FarLeft:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen

	artFrame.Right = artFrame:CreateTexture('NUI_Art_Classic_Right', 'BACKGROUND')
	artFrame.Right:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-right1')
	artFrame.Right:SetSize(240, 139)
	artFrame.Right:SetPoint('BOTTOMLEFT', artFrame.Center, 'BOTTOMRIGHT')
	artFrame.Right:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen
	artFrame.FarRight = artFrame:CreateTexture('NUI_Art_Classic_FarRight', 'BACKGROUND')
	artFrame.FarRight:SetTexture('Interface\\AddOns\\Necrosis\\UI\\BottomBanner\\Images\\base-right2')
	artFrame.FarRight:SetSize(240, 139)
	artFrame.FarRight:SetPoint('BOTTOMLEFT', artFrame.Right, 'BOTTOMRIGHT')
	artFrame.FarRight:SetPoint('BOTTOMRIGHT', NecrosisUI, 'BOTTOMRIGHT')
	artFrame.FarRight:SetVertexColor(0.7, 0.3, 1.0)  -- Violet moyen
end

-- Execute immediately on load
CreateArtwork()
