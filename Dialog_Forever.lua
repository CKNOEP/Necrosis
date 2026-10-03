--[[
    Necrosis
    Forever (Camelot) overrides.

    Forever runs the Retail code base (Initialize_retail, Spells-Retail, Options-*_retail...)
    but has the classic demon roster: no Sayaad, Darkglare, Vilefiend nor Tyrant.

    This file MUST be loaded after Spells-Retail.lua: it replaces Warlock_Lists.pets,
    which is defined there, and keeps NameDemon / DemonName in the same order.
--]]

local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

-- Order shared by DemonName, NameDemon and Warlock_Lists.pets (index = NecrosisConfig.PetShow index)
Necrosis.Translation.DemonName = {
	[1] = L["IMP"],
	[2] = L["VOIDWALKER"],
	[3] = L["SUCCUBUS"],
	[4] = L["FELHUNTER"],
	[5] = L["FELGUARD"],
	[6] = L["INFERNAL"],
	[7] = L["DOOMGUARD"],
}

-- Keys of Warlock_Spell_Use (lowercase), not display names
Necrosis.NameDemon = {
	[1] = "imp",
	[2] = "voidwalker",
	[3] = "succubus",
	[4] = "felhunter",
	[5] = "felguard",
	[6] = "inferno",
	[7] = "doomguard",
}

Necrosis.Warlock_Lists.pets = {
	[1] = {f_ptr = "imp", high_of = "imp", s_type = "summon", },
	[2] = {f_ptr = "voidwalker", high_of = "voidwalker", },
	[3] = {f_ptr = "succubus", high_of = "succubus", },
	[4] = {f_ptr = "felhunter", high_of = "felhunter", },
	[5] = {f_ptr = "felguard", high_of = "felguard", },
	[6] = {f_ptr = "inferno", high_of = "inferno", s_type = "summon", },
	[7] = {f_ptr = "doomguard", high_of = "doomguard", },
	-- Utility spells (not in menu options)
	[8] = {f_ptr = "rit_of_doom", high_of = "rit_of_doom", },
	[9] = {f_ptr = "domination", high_of = "domination", },
}
