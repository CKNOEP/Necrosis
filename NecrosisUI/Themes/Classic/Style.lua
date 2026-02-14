local NUI, L = NUI, NUI.L
local Artwork_Core = NUI:GetModule('Component_Artwork')
local module = NUI:GetModule('Style_Classic')
local artFrame = CreateFrame('Frame', 'NUI_Art_Classic', NecrosisUI)

----------------------------------------------------------------------------------------------------
local SkinnedFrames = {}

local function CreateArtwork()
	local plate = CreateFrame('Frame', 'Classic_ActionBarPlate', artFrame)
	plate:SetSize(1002, 139)
	plate:SetFrameStrata('BACKGROUND')
	plate:SetFrameLevel(1)
	plate:SetAllPoints(NUI_BottomAnchor)

	-- Create actionbar BG's
	local BarBGSettings = {
		name = 'Classic',
		height = 37,
		TexturePath = 'Interface\\AddOns\\NecrosisUI\\Themes\\Classic\\Images\\bar-backdrop1',
		TexCoord = {0.107421875, 0.896484375, 0.25, 0.765625}
	}





	local PopupMask = {
		name = 'Classic',
		height = 34,
		point = 'BOTTOMRIGHT',
		--TexturePath = 'Interface\\AddOns\\NecrosisUI\\Themes\\Classic\\Images\\bar-popup1'
		-- TexCoord = {0.23828125, 0.76171875, 0.09375, 0.8828125}
	}
	


	

	
	--Setup the Bottom Artwork
	artFrame:SetFrameStrata('BACKGROUND')
	artFrame:SetFrameLevel(1)
	artFrame:SetAlpha(0.5)
	artFrame:SetSize(2, 2)
	artFrame:SetScale(0.78);
	artFrame:SetPoint('BOTTOM', NUI_BottomAnchor)

	artFrame.Center = artFrame:CreateTexture('NUI_Art_Classic_Center', 'BACKGROUND')
	artFrame.Center:SetTexture('Interface\\AddOns\\NecrosisUI\\Themes\\Classic\\Images\\base-center')
	artFrame.Center:SetPoint('BOTTOM', artFrame, 'BOTTOM')

	artFrame.Left = artFrame:CreateTexture('NUI_Art_Classic_Left', 'BACKGROUND')
	artFrame.Left:SetTexture('Interface\\AddOns\\NecrosisUI\\Themes\\Classic\\Images\\base-left1')
	artFrame.Left:SetPoint('BOTTOMRIGHT', artFrame.Center, 'BOTTOMLEFT', 0, 0)
	artFrame.FarLeft = artFrame:CreateTexture('NUI_Art_Classic_FarLeft', 'BACKGROUND')
	artFrame.FarLeft:SetTexture('Interface\\AddOns\\NecrosisUI\\Themes\\Classic\\Images\\base-left2')
	artFrame.FarLeft:SetPoint('BOTTOMRIGHT', artFrame.Left, 'BOTTOMLEFT', 0, 0)
	artFrame.FarLeft:SetPoint('BOTTOMLEFT', NecrosisUI, 'BOTTOMLEFT', 0, 0)


	artFrame.Right = artFrame:CreateTexture('NUI_Art_Classic_Right', 'BACKGROUND')
	artFrame.Right:SetTexture('Interface\\AddOns\\NecrosisUI\\Themes\\Classic\\Images\\base-right1')
	artFrame.Right:SetPoint('BOTTOMLEFT', artFrame.Center, 'BOTTOMRIGHT')
	artFrame.FarRight = artFrame:CreateTexture('NUI_Art_Classic_FarRight', 'BACKGROUND')
	artFrame.FarRight:SetTexture('Interface\\AddOns\\NecrosisUI\\Themes\\Classic\\Images\\base-right2')
	artFrame.FarRight:SetPoint('BOTTOMLEFT', artFrame.Right, 'BOTTOMRIGHT')
	artFrame.FarRight:SetPoint('BOTTOMRIGHT', NecrosisUI, 'BOTTOMRIGHT')


	
end



function module:OnInitialize()
	
	CreateArtwork()
	
end


