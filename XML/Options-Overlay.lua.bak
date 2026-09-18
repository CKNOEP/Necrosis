--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)
local AddonName, SAO = ...




------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OVERLAY
------------------------------------------------------------------------------------------------------

function Necrosis:SetOverlayConfig()

	local frame = _G["NecrosisOverlayConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisOverlayConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")
		
	
	end	
	

	frame:Show()
	
	
	
end


