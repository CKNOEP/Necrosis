--[[
    Necrosis
    Copyright (C) - copyright file included in this release
--]]

-- Global constants that need to be available early for localization initialization
NECROSIS_ID = "Necrosis"

-- Initialize the main addon table early so Dialog.lua can use it
Necrosis = {
	Config = {},
	Translation = {
		Item = {
			Soulshard = "Soulshard",
			Soulstone = "Soulstone",
			Healthstone = "Healthstone",
			Spellstone = "Spellstone",
			Firestone = "Firestone",
			InfernalStone = "Infernal Stone",
			DemoniacStone = "Demoniac Stone",
			Hearthstone = "Hearthstone",
		},
	},
	Data = {},
	Debug = {},
	Utils = {
		-- Temporary stub that will be overridden by Utils.lua
		GetSpellName = function(spellId)
			return tostring(spellId) -- Fallback to spell ID as string
		end
	},
}
SAO = {}
