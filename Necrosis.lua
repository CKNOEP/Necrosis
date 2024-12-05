--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

-- Local variables || Variables locales
local Local = {}
local _G = getfenv(0)
local NU = Necrosis.Utils -- save typing

------------------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS || FONCTIONS LOCALES
------------------------------------------------------------------------------------------------------

-- Creating two functions, new and del || Création de deux fonctions, new et del
-- New creates a temporary array, del destroys it || new crée un tableau temporaire, del le détruit
-- These temporary tables are stored for reuse without having to recreate them. || Ces tableaux temporaires sont stockés pour être réutilisés sans être obligés de les recréer.
local new, del
do
	local cache = setmetatable({}, {__mode='k'})
	function new(populate, ...)
		local tbl
		local t = next(cache)
		if ( t ) then
			cache[t] = nil
			tbl = t
		else
			tbl = {}
		end
		if ( populate ) then
			local num = select("#", ...)
			if ( populate == "hash" ) then
				assert(math.fmod(num, 2) == 0)
				local key
				for i = 1, num do
					local v = select(i, ...)
					if not ( math.fmod(i, 2) == 0 ) then
						key = v
					else
						tbl[key] = v
						key = nil
					end
				end
			elseif ( populate == "array" ) then
				for i = 1, num do
					local v = select(i, ...)
					table.insert(tbl, i, v)
				end
			end
		end
		return tbl
	end
	function del(t)
		for k in next, t do
			t[k] = nil
		end
		cache[t] = true
	end
end

-- Define a metatable which will be applied to any table object that uses it. || Métatable permettant d'utiliser les tableaux qui l'utilisent comme des objets
-- Common functions = :insert, :remove & :sort || Je définis les opérations :insert, :remove et :sort
-- Any table declared as follows "a = setmetatable({}, metatable)" will be able to use the common functions. || Tout tableau qui aura pour déclaration a = setmetatable({}, metatable) pourra utiliser ces opérateurs
local metatable = {
	__index = {
		["insert"] = table.insert,
		["remove"] = table.remove,
		["sort"] = table.sort,
	}
}

-- Create the spell metatable. || Création de la métatable contenant les sorts de nécrosis
Necrosis.Spell = setmetatable({}, metatable)

------------------------------------------------------------------------------------------------------
-- DECLARATION OF VARIABLES || DÉCLARATION DES VARIABLES
------------------------------------------------------------------------------------------------------

-- Detection of initialisation || Détection des initialisations du mod
Local.LoggedIn = true
Local.InWorld = false -- as addon id loaded / parsed

-- Configuration defaults || Configuration par défaut
-- To be used if the configuration savedvariables is missing, or if the NecrosisConfig.Version number is changed. || Se charge en cas d'absence de configuration ou de changement de version
Local.DefaultConfig = {
	AFK = true,
	SoulshardContainer = 4,
	ShadowTranceAlert = true,
	ShowSpellTimers = true,
	AntiFearAlert = true,
	CreatureAlert = true,
	NecrosisAlphaBar = 85,
	NecrosisLockServ = true,
	NecrosisAngle = 180,
	StonePosition = {1, 2, 3, 4, 5, 6, 7, 8, 9}, -- options to show or hide
		-- 1 = Firestone
		-- 2 = Spellstone
		-- 3 = Healthstone
		-- 4 = Soulstone
		-- 5 = Buff menu
		-- 6 = Mounts
		-- 7 = Demon menu
		-- 8 = Curse menu
		-- 9 = Destroy Shard
	DemonSpellPosition = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
		-- 1 = Fel Domination || Domination corrompue
		-- 2 = Summon Imp
		-- 3 = Summon Voidwalker || Marcheur
		-- 4 = Summon Succubus
		-- 5 = Summon Felhunter
		-- 6 = Felguard || Gangregarde<<
		-- 7 = Infernal
		-- 8 = Doomguard
		-- 9 = Enslave || Asservissement
		-- 10 = Sacrifice
		-- 11 = Demonic Empowerment || Renforcement
	BuffSpellPosition = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		-- 1 = Demon Armor || Armure
		-- 2 = Fel Armor || Gangrarmure
		-- 3 = Unending Breath || Respiration
		-- 4 = Detect Invisibility || Invisibilité
		-- 5 = Eye of Kilrogg
		-- 6 = Ritual of Summoning || TP
		-- 7 = Soul Link || Lien Spirituel
		-- 8 = Shadow Ward || Protection contre l'ombre
		-- 9 = Demonic Empowerment || Renforcement démoniaque --
		-- 10 = Banish || Bannir
	NecrosisToolTip = true,

	MainSpell = "armor",

	PetMenuPos = {x=1, y=0, direction=1},
	PetMenuDecalage = {x=1, y=26},

	BuffMenuPos = {x=1, y=0, direction=1},
	BuffMenuDecalage = {x=1, y=26},

	CurseMenuPos = {x=1, y=0, direction=1},
	CurseMenuDecalage = {x=1, y=-26},

	ChatMsg = true,
	ChatType = true,
	Language = GetLocale(),
	ShowCount = true,
	CountType = 1,
	DestroyShardwithsphere = true,
	ShadowTranceScale = 100,
	NecrosisButtonScale = 90,
	NecroisButtonRadius = 1,
	NecrosisColor = "Rose",
	Sound = true,
	SpellTimerPos = 1,
	SpellTimerJust = "LEFT",
	Circle = 1,
	TimerType = 1,
	SensListe = 1,
	PetName = {},
	DemonSummon = true,
	BanishScale = 100,
	ItemSwitchCombat = {},
	DestroyCount = 32,
	FramePosition = {
		["NecrosisSpellTimerButton"] = {"CENTER", "UIParent", "CENTER", 100, 300},
		["NecrosisButton"] = {"CENTER", "UIParent", "CENTER", 0, -200},
		["NecrosisCreatureAlertButton_elemental"] = {"CENTER", "UIParent", "CENTER", -60, 0},
		["NecrosisCreatureAlertButton_demon"] = {"CENTER", "UIParent", "CENTER", -50, 0},		
		["NecrosisAntiFearButton"] = {"CENTER", "UIParent", "CENTER", -20, 0},
		["NecrosisShadowTranceButton"] = {"CENTER", "UIParent", "CENTER", 20, 0},
		["NecrosisBacklashButton"] = {"CENTER", "UIParent", "CENTER", 60, 0},
		["NecrosisFirestoneButton"] = {"CENTER", "UIParent", "CENTER", -121,-100},
		["NecrosisSpellstoneButton"] = {"CENTER", "UIParent", "CENTER", -87,-100},
		["NecrosisHealthstoneButton"] = {"CENTER", "UIParent", "CENTER", -53,-100},
		["NecrosisSoulstoneButton"] = {"CENTER", "UIParent", "CENTER", -17,-100},
		["NecrosisBuffMenuButton"] = {"CENTER", "UIParent", "CENTER", 17,-100},
		["NecrosisMountButton"] = {"CENTER", "UIParent", "CENTER", 53,-100},
		["NecrosisPetMenuButton"] = {"CENTER", "UIParent", "CENTER", 87,-100},
		["NecrosisCurseMenuButton"] = {"CENTER", "UIParent", "CENTER", 121,-100},
		["NecrosisDestroyShardsButton"] = {"CENTER", "UIParent", "CENTER", 154,-100},
	},
	
	PetShow = {true,true,true,true,true,true,true,true,true,},
	
	CurseShow = {true,true,true,true,true,true,true,true,},

	Timers = { -- Order is for options screen; overrides Warlock_Spells Timer
		[1] = {usage = "armor", show = true},
		[2] = {usage = "breath", show = true},
		[3] = {usage = "invisible", show = true},
		[4] = {usage = "eye", show = false},
		[5] = {usage = "summoning", show = true},
		[6] = {usage = "ward", show = true},
		[7] = {usage = "banish", show = true},
		[8] = {usage = "fel_armor", show = true},
		[9] = {usage = "sacrifice", show = true},
	   [10] = {usage = "enslave", show = true},	
	},
}

-- Casted spell variables (name, rank, target, target level) || Variables des sorts castés (nom, rang, cible, niveau de la cible)
Local.SpellCasted = {}

-- Timers variables || Variables des timers
Local.TimerManagement = {
	-- Spells to timer || Sorts à timer
	SpellTimer = setmetatable({}, metatable),
	-- Association of timers to Frames || Association des timers aux Frames
	TimerTable = setmetatable({}, metatable),
	-- Groups of timers by mobs || Groupes de timers par mobs
	SpellGroup = setmetatable(
		{
			{Name = "Rez", SubName = " ", Visible = 0},
			{Name = "Main", SubName = " ", Visible = 0},
			{Name = "Cooldown", SubName = " ", Visible = 0}
		},
		metatable
	),
	-- Last cast spell || Dernier sort casté
	LastSpell = {}
}

Necrosis.TimerManagement = Local.TimerManagement -- debug

-- Variables of the invocation messages || Variables des messages d'invocation
Local.SpeechManagement = {
	-- Latest messages selected || Derniers messages sélectionnés
	-- Added 'RoS = 0' by Draven (April 3rd, 2008) || Added 'RoS = 0' by Draven (April 3rd, 2008)
	LastSpeech = {Pet = 0, Steed = 0, Rez = 0, TP = 0, RoS = 0},
	-- Messages to use after the spell succeeds || Messages à utiliser après la réussite du sort
	SpellSucceed = {
		-- Added 'RoS = setmetatable ({}, metatable),' by Draven (April 3rd, 2008) || Added 'RoS = setmetatable({}, metatable),' by Draven (April 3rd, 2008)
		RoS = setmetatable({}, metatable),
		Pet = setmetatable({}, metatable),
		Steed = setmetatable({}, metatable),
		Rez = setmetatable({}, metatable),
		TP = setmetatable({}, metatable),
		Sacrifice = setmetatable({}, metatable)
	},
}
Necrosis.XXYYZZ = Local.SpeechManagement -- debug

-- Variables used for managing summoning and stone buttons || Variables utilisées pour la gestion des boutons d'invocation et d'utilisation des pierres
Local.Stone = {
	Soul = {Mode = 1, Location = {}},
	Health = {Mode = 1, Location = {}},
	Spell = {Mode = 1, Location = {}},
	Hearth = {Location = {}},
	Fire = {Mode = 1},
}
Local.SomethingOnHand = "Truc"

-- Component count variable || Variable de comptage des composants
Local.Reagent = {Infernal = 0, Demoniac = 0}

-- Variables used in demon management || Variables utilisées dans la gestion des démons
Local.Summon = {}

-- List of buttons available in each menu || Liste des boutons disponibles dans chaque menu
Local.Menu = {
	Pet = setmetatable({}, metatable),
	Buff = setmetatable({}, metatable),
	Curse = setmetatable({}, metatable)
}

-- Active Buffs Variable || Variable des Buffs Actifs
Local.BuffActif = {}

-- Variable of the state of the buttons (grayed or not) || Variable de l'état des boutons (grisés ou non)
Local.Desatured = {}

-- Last image used for the sphere || Dernière image utilisée pour la sphere
Local.LastSphereSkin = "Aucune"

-- Variables of care stone exchanges || Variables des échanges de pierres de soins
Local.Trade = {}

-- Variables used for the management of soul fragments || Variables utilisées pour la gestion des fragments d'âme
Local.Soulshard = {Count = 0, Move = 0}
Local.BagIsSoulPouch = {}

-- Variables used for warnings || Variables utilisées pour les avertissements
-- Antifear and Demonic or Elemental Target || Antifear et Cible démoniaque ou élémentaire
Local.Warning = {
	Antifear = {
		Toggle = 2,
		Icon = {"", "Immu", "Prot"}
	}
}

-- Time elapsed between two OnUpdate events || Temps écoulé entre deux event OnUpdate
Local.LastUpdate = {0, 0}

-- Use these to get buffs via OnUpdate on init
Local.buff_needed = false
Local.buff_attempts = 0

LocalZZYY = Local
------------------------------------------------------------------------------------------------------
-- NECROSIS helper routines
------------------------------------------------------------------------------------------------------
local function BagNamesKnown()
	local res = true
	for container = 0, NUM_BAG_SLOTS, 1 do
		local name, id = NU.GetBagName(container)
		if name then
			-- bag name is in cache
		else
			res = false
			break
		end
	end
	
	return res
end

-- Function to check the presence of a buff on the unit.
-- Strictly identical to UnitHasEffect, but as WoW distinguishes Buff and DeBuff, so we have to.
local function UnitHasBuff(unit, effect)
--		print(("%d=%s, %s, %.2f minutes left."):format(i,name,icon,(etime-GetTime())/60))
	local res = false
	for i=1,40 do
	  local name, icon, count, debuffType, duration, 
		expirationTime, source, isStealable, nameplateShowPersonal, spellId, 
		canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod 
		= UnitBuff(unit,i)
		if name then
			if name == effect then
				res = true
				break
			else
				-- continue
			end
		else
			break -- no more
		end
	end
	
	return res
end

-- Function to check the presence of a debuff on the unit || Fonction pour savoir si une unité subit un effet
-- F(string, string)->bool
local function UnitHasEffect(unit, effect)
	local res = false
	for i=1,40 do
		local name, icon, count, debuffType, duration, 
			expirationTime, source, isStealable, nameplateShowPersonal, spellId, 
			canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod 
			= UnitDebuff(unit,i)
		if name then
			if name == effect then
				res = true
				break
			else
				-- continue
			end
		else
			break -- no more
		end
	end
	
	return res
end

-- Display the antifear button / warning || Affiche ou cache le bouton de détection de la peur suivant la cible.
local function ShowAntiFearWarning()
	local Actif = false -- Must be False, or a number from 1 to Local.Warning.Antifear.Icon[] max element.

	-- Checking if we have a target. Any fear need a target to be casted on
	if UnitExists("target") and UnitCanAttack("player", "target") and not UnitIsDead("target") then
		-- Checking if the target has natural immunity (only NPC target)
		if not UnitIsPlayer("target") and ( UnitCreatureType("target") == Necrosis.Unit.Undead or UnitCreatureType("target") == "Mechanical" ) then
			Actif = 2 -- Immun
		end
		-- We'll start to parse the target buffs, as his class doesn't give him natural permanent immunity
		if not Actif then
			for index=1, #Necrosis.AntiFear.Buff, 1 do
				if UnitHasBuff("target",Necrosis.AntiFear.Buff[index]) then
					Actif = 3 -- Prot
					break
				end
			end

			-- No buff found, let's try the debuffs
			for index=1, #Necrosis.AntiFear.Debuff, 1 do
				if UnitHasEffect("target",Necrosis.AntiFear.Debuff[index]) then
					Actif = 3 -- Prot
					break
				end
			end
		end

		-- An immunity has been detected before, but we still don't know why => show the button anyway
		if Local.Warning.Antifear.Immune and not Actif then
			Actif = 1
		end
	end

	if Actif then
		-- Antifear button is currently not visible, we have to change that
		if not Local.Warning.Antifear.Actif then
			Local.Warning.Antifear.Actif = true
			Necrosis:Msg(Necrosis.ChatMessage.Information.FearProtect, "USER")
			NecrosisAntiFearButton:SetNormalTexture("Interface\\Addons\\Necrosis\\UI\\AntiFear"..Local.Warning.Antifear.Icon[Actif].."-02")
			if NecrosisConfig.Sound then PlaySoundFile(Necrosis.Sound.Fear) end
--			ShowUIPanel(NecrosisAntiFearButton)
			NecrosisAntiFearButton:Show()
			Local.Warning.Antifear.Blink = GetTime() + 0.6
			Local.Warning.Antifear.Toggle = 2

		-- Timer to make the button blink
		elseif GetTime() >= Local.Warning.Antifear.Blink then
			if Local.Warning.Antifear.Toggle == 1 then
				Local.Warning.Antifear.Toggle = 2
			else
				Local.Warning.Antifear.Toggle = 1
			end
			Local.Warning.Antifear.Blink = GetTime() + 0.4
			NecrosisAntiFearButton:SetNormalTexture("Interface\\Addons\\Necrosis\\UI\\AntiFear"..Local.Warning.Antifear.Icon[Actif].."-0"..Local.Warning.Antifear.Toggle)
		end

	elseif Local.Warning.Antifear.Actif then	-- No antifear on target, but the button is still visible => gonna hide it
		Local.Warning.Antifear.Actif = false
--		HideUIPanel(NecrosisAntiFearButton)
		NecrosisAntiFearButton:Hide()
	end
end

-- Function updating the buttons Necrosis and giving the state of the button of the soul stone || Fonction mettant à jour les boutons Necrosis et donnant l'état du bouton de la pierre d'âme
function UpdateIcons()

	-- Soul Stone || Pierre d'âme
	-----------------------------------------------

	-- We inquire to know if a stone of soul was used -> verification in the timers || On se renseigne pour savoir si une pierre d'âme a été utilisée --> vérification dans les timers
	local SoulstoneInUse = false
	if Local.TimerManagement.SpellTimer then
		for index = 1, #Local.TimerManagement.SpellTimer, 1 do
		--print(Local.TimerManagement.SpellTimer[index].Name)
			if  Local.TimerManagement.SpellTimer[index].Name == Necrosis.GetSpellName("soulstone") 
			and Local.TimerManagement.SpellTimer[index].TimeMax > 0 then
				SoulstoneInUse = true
				break
			end
		end
	end

	-- If the stone was not used, and there is no stone in inventory -> Mode 1 || Si la Pierre n'a pas été utilisée, et qu'il n'y a pas de pierre en inventaire -> Mode 1
	if not (Local.Stone.Soul.OnHand or SoulstoneInUse) then
		--print ("mode1")
		Local.Stone.Soul.Mode = 1
	end

	-- If the stone was not used, but there is a stone in inventory || Si la Pierre n'a pas été utilisée, mais qu'il y a une pierre en inventaire
	--[[On Hand			In Use
		1 : no				no
		2 : yes				no
		3 : no				yes
		4 : yes				yes
	--]]
	if Local.Stone.Soul.OnHand and (not SoulstoneInUse) then
		-- If the stone in inventory contains a timer, and we leave a RL -> Mode 4 || Si la pierre en inventaire contient un timer, et qu'on sort d'un RL --> Mode 4
		local start, duration = C_Container.GetContainerItemCooldown(Local.Stone.Soul.Location[1],Local.Stone.Soul.Location[2])
		if Necrosis.Debug.timers then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("UpdateIcons - soul stone found"
			.." s'"..tostring(start or "nyl").."'"
			.." d'"..tostring(duration or "nyl").."'"
			.." l1'"..tostring(Local.Stone.Soul.Location[1] or "nyl").."'"
			.." l2'"..tostring(Local.Stone.Soul.Location[2] or "nyl").."'"
			)
		end
		if start > 0 and duration > 0 then
			--[[ This situation is after a stone is used and another is created.
			The timer is on USING a soul stone, not the stone itself.  
			So use the lowest soul stone 'resurrection' spell the warlock can learn just for the timer.
			Take advantage that the various 'resurrection' spells share the same localized name AND the same cool down time. 
			From the id, WoW knows the health and mana to give if the soul stone is used.
			Note: WoW will only allow one soul stone at a time so we do not have to worry about multiple stones...
			Note: The target guid (below) must match the cool down setting in Functions.lua or two timers could be spawned.
			--]] 
			if Local.Stone.Soul.Timer == true then
			else
				local spell = Necrosis.GetSpellById(20707)
				local cast_info = {}
				cast_info = {
					usage = spell.Usage,
					spell_id  = 20707,
					guid = nil,
					}
				local target = {}
				target = {
					name = "",
					lvl  = "",
					guid = "",
					}

					
				Local.TimerManagement = Necrosis:TimerInsert(cast_info, target, Local.TimerManagement, "soul stone in inventory cool down", start, duration, spell.Cooldown)
				Local.Stone.Soul.Mode = 4
				Local.Stone.Soul.Timer = true
			end
		-- If the stone does not contain a timer, or you do not leave an RL -> Mode 2 || Si la pierre ne contient pas de timer, ou qu'on ne sort pas d'un RL --> Mode 2
		else
			Local.Stone.Soul.Mode = 2
		end
	else
		if Local.Stone.Soul.Timer == true then
			Local.Stone.Soul.Timer = false
			local spell = Necrosis.GetSpell("minor_ss_used")
			Necrosis:RetraitTimerParNom(spell.Name, Local.TimerManagement, "No soul stone...")
		end
	end

	-- If the stone was used but there is no stone in inventory -> Mode 3 || Si la Pierre a été utilisée mais qu'il n'y a pas de pierre en inventaire --> Mode 3
	if (not Local.Stone.Soul.OnHand) and SoulstoneInUse then
		Local.Stone.Soul.Mode = 3
	end

	-- If the stone was used and there is a stone in inventory || Si la Pierre a été utilisée et qu'il y a une pierre en inventaire
	if Local.Stone.Soul.OnHand and SoulstoneInUse then
			Local.Stone.Soul.Mode = 4
	end
--[[
	-- If out of combat and we can create a stone, we associate the left button to create a stone. || Si hors combat et qu'on peut créer une pierre, on associe le bouton gauche à créer une pierre.
	if Necrosis.IsSpellKnown("soulstone") 
	and NecrosisConfig.ItemSwitchCombat[4] 
	and (Local.Stone.Soul.Mode == 1 or Local.Stone.Soul.Mode == 3) 
	then
		Necrosis:SoulstoneUpdateAttribute(Local.Stone.Soul.Mode)
	end
--]]	
	local stone_exists = (Local.Stone.Soul.Mode == 1 or Local.Stone.Soul.Mode == 3) and true or false
	Necrosis:SoulstoneUpdateAttribute(stone_exists)

	-- Display of the mode icon || Affichage de l'icone liée au mode
	local f = _G[Necrosis.Warlock_Buttons.soul_stone.f]
	if f then
		f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SoulstoneButton-0"..Local.Stone.Soul.Mode)
	end

	-- Stone of life || Pierre de vie
	-----------------------------------------------

	-- Mode "I have one" (2) / "I have none" (1) || Mode "j'en ai une" (2) / "j'en ai pas" (1)
	if (Local.Stone.Health.OnHand) then
		Local.Stone.Health.Mode = 2
	else
		Local.Stone.Health.Mode = 1
		-- If out of combat and we can create a stone, we associate the left button to create a stone. || Si hors combat et qu'on peut créer une pierre, on associe le bouton gauche à créer une pierre.
		if Necrosis.IsSpellKnown("healthstone") 
		and NecrosisConfig.ItemSwitchCombat[3] then
			Necrosis:HealthstoneUpdateAttribute("NoStone")
		end
	end

	--Display of the mode icon || Affichage de l'icone liée au mode
	local f = _G[Necrosis.Warlock_Buttons.health_stone.f]
	if f then
		f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\HealthstoneButton-0"..Local.Stone.Health.Mode)
	end

	-- Stone of spell || Pierre de sort
	-----------------------------------------------

	-- Stone in the inventory ... || Pierre dans l'inventaire...
	if Local.Stone.Spell.OnHand then
		-- ... and on the weapon = mode 3, otherwise = mode 2 || ... et sur l'arme = mode 3, sinon = mode 2
		if Local.SomethingOnHand == NecrosisConfig.ItemSwitchCombat[1] then
			Local.Stone.Spell.Mode = 3
		else
			Local.Stone.Spell.Mode = 2
		end
	-- Stone nonexistent ... || Pierre inexistante...
	else
		-- ... but on the weapon = mode 4, otherwise = mode 1 || ... mais sur l'arme = mode 4, sinon = mode 1
		if Local.SomethingOnHand == NecrosisConfig.ItemSwitchCombat[1] then
			Local.Stone.Spell.Mode = 4
		else
			Local.Stone.Spell.Mode = 1
		end
		-- If out of combat and we can create a stone, we associate the left button to create a stone. || Si hors combat et qu'on peut créer une pierre, on associe le bouton gauche à créer une pierre.
		if Necrosis.IsSpellKnown("spellstone") 
		and NecrosisConfig.ItemSwitchCombat[3] then
			Necrosis:SpellstoneUpdateAttribute("NoStone")
		end
	end

	-- Display of the mode icon || Affichage de l'icone liée au mode
	local f = _G[Necrosis.Warlock_Buttons.spell_stone.f]
	if f then
		f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SpellstoneButton-0"..Local.Stone.Spell.Mode)
	end

	-- Fire stone || Pierre de feu
	-----------------------------------------------

	-- Stone in the inventory ... || Pierre dans l'inventaire...
	if Local.Stone.Fire.OnHand then
		-- ... and on the weapon = mode 3, otherwise = mode 2 || ... et sur l'arme = mode 3, sinon = mode 2
		if Local.SomethingOnHand == NecrosisConfig.ItemSwitchCombat[2] then
			Local.Stone.Fire.Mode = 3
		else
			Local.Stone.Fire.Mode = 2
		end
	-- Stone nonexistent ... || Pierre inexistante...
	else
		-- ... but on the weapon = mode 4, otherwise = mode 1 || ... mais sur l'arme = mode 4, sinon = mode 1
		if Local.SomethingOnHand == NecrosisConfig.ItemSwitchCombat[2] then
			Local.Stone.Fire.Mode = 4
		else
			Local.Stone.Fire.Mode = 1
		end
		-- If out of combat and we can create a stone, we associate the left button to create a stone. || Si hors combat et qu'on peut créer une pierre, on associe le bouton gauche à créer une pierre.
		if Necrosis.IsSpellKnown("firestone") 
		and NecrosisConfig.ItemSwitchCombat[2] then
			Necrosis:FirestoneUpdateAttribute("NoStone")
		end
	end

	-- Display of the mode icon || Affichage de l'icone liée au mode
	local f = _G[Necrosis.Warlock_Buttons.fire_stone.f]
	if f then
		f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\FirestoneButton-0"..Local.Stone.Fire.Mode)
	end
end

-- Event : UNIT_SPELLCAST_SUCCEEDED
-- Manages everything related to successful spell casts || Permet de gérer tout ce qui touche aux sorts une fois leur incantation réussie
function SpellManagement(SpellCasted)
	
	
	local SortActif = false
	local cast_spell = SpellCasted
	
	if (cast_spell.Name) then
	
		
		-- Messages Posts Cast (Démons et TP)
		Local.SpeechManagement.SpellSucceed = Necrosis:Speech_Then(cast_spell, Local.SpeechManagement)

		-- Handle any timers on cast spells
		local spell = Necrosis.GetSpellById(cast_spell.Id)
		
		
		
			
		if spell.Buff then
			-- Handled by the aura events
		elseif spell.Timer then
			local target = {}
--[[
			if cast_spell.TargetName == UnitName("player") then
				cast_spell.TargetName = ""
				cast_spell.TargetGUID = ""
				target = {
					name = "",
					lvl  = cast_spell.TargetLevel,
					guid = "",
					}
			else
--]]
				target = {
					name = cast_spell.TargetName,
					lvl  = cast_spell.TargetLevel,
					guid = cast_spell.TargetGUID,
					}
--			end

			local cast_info = {}
			local spell = Necrosis.GetSpellById(cast_spell.Id)
			cast_info = {
				usage = spell.Usage,
				spell_id  = cast_spell.Id,
				guid = cast_spell.Guid,
				}
			if Necrosis.Debug.spells_cast then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("SpellManagement"
				.." s'"..tostring(cast_spell.Name or "nyl").."'"
				.." u'"..tostring(cast_info.usage or "nyl").."'"
				.." tn'"..tostring(target.name or "nyl").."'"
				.." tl'"..tostring(target.lvl or "nyl").."'"
				.." tg'"..tostring(target.guid or "nyl").."'"
				)
			end
		--print (spell.Usage,cast_spell.Id,cast_spell.Guid)
		--print (cast_spell.TargetName,cast_spell.TargetLevel,cast_spell.TargetGUID)
		--print (cast_spell.TargetName,cast_spell.TargetLevel,cast_spell.TargetGUID)
			Local.TimerManagement = Necrosis:TimerInsert(cast_info, target, Local.TimerManagement, "spell cast")
			
			--print (spell.Usage,cast_spell.Id,cast_spell.Guid)
		end
	end

	return
end

function CheckCorruptionRefresh(target, cast_guid, spell_id)

-- On verifie si la corruption doit etre refresh , si le talent(Afflication eternelle) est appris, a la suite de SB ou hanter le timer de la corru est réinitialisé
			local guid = UnitGUID("target")
			local name = select(1, GetSpellInfo(spell_id))
			
			if not target or not guid or target == "Player" or not Necrosis.GetSpellById(spell_id)  then
			
			-- nothing to do
			return nil
			
			elseif Necrosis.Warlock_Spells[spell_id].Usage == "bolt" or Necrosis.Warlock_Spells[spell_id].Usage == "haunt" then-- Trait de l'ombre ou Hanter
			--print (guid, cast_guid, spell_id , name, Necrosis.Warlock_Spells[spell_id].Usage)
			
				for i=1,40 do 
						local NameDebuff, _, _, _, _,expirationTime = UnitAura("target", i, "PLAYER|HARMFUL")
						
						--On verifie que sur la cible on a bien corruption
						if NameDebuff == Necrosis.GetSpellName("corruption") then
									
							
								for index = 1, #Local.TimerManagement.SpellTimer, 1 do
							
									-- On recherche dans la table des Timer la corruption correspondante à la cible
									--if Local.TimerManagement.SpellTimer[index] then
									--print(Necrosis.TimerManagement.SpellTimer[index].Name,NameDebuff,Necrosis.TimerManagement.SpellTimer[index].TargetGUID,UnitGUID("target"))
										if Necrosis.TimerManagement.SpellTimer[index].Name == NameDebuff and  Necrosis.TimerManagement.SpellTimer[index].TargetGUID == UnitGUID("target") then
										
									-- On delete le timer actuel pour le remplacer
										Necrosis:RetraitTimerParIndex(index, Local.TimerManagement, "spell expired")
										--print ("spell deleted",index)
									-- On rajoute une Corruption avec un timer refresh
										SpellManagement(Local.SpellCasted[cast_guid])
																			
										Necrosis.GetSpellName("corruption")
										local spell = Necrosis.GetSpellById(Necrosis.GetSpell("corruption").ID)
										local cast_info = {}
										cast_info = {
											usage = "corruption",
											spell_id  = Necrosis.GetSpell("corruption").ID,
											guid = cast_guid,
											}
										target = {
											name = UnitName("Target"),--
											lvl  = UnitLevel("Target"),
											guid = UnitGUID("Target")
											}
										--Local.TimerManagement = Necrosis:TimerInsert(cast_info, target, Necrosis.TimerManagement, "spell cast")
										
										Local.TimerManagement = Necrosis:TimerInsert(cast_info, target, Local.TimerManagement, "spell cast")
										
										
										
										SpellManagement(Local.SpellCasted[cast_guid])
										
										
										end
						
									
									--end
						
								end
						end
				
				end	

			
		end
end
-- Events : CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS, CHAT_MSG_SPELL_AURA_GONE_SELF et CHAT_MSG_SPELL_BREAK_AURA
-- Manage the appearing and disappearing effects on the warlock || Permet de gérer les effets apparaissants et disparaissants sur le démoniste
-- Based on CombatLog || Basé sur le CombatLog
function SelfEffect(action, nom)
--print (action, nom)
	if NecrosisConfig.LeftMount then
		local NomCheval1 = GetSpellInfo(NecrosisConfig.LeftMount)
	else
		local NomCheval1 = Necrosis.Warlock_Spells[23161].Name  -- Pallefroi 100 %
	end
	if NecrosisConfig.RightMount then
		local NomCheval2 = GetSpellInfo(NecrosisConfig.RightMount)
	else
		local NomCheval2 = Necrosis.Warlock_Spells[5784].Name -- Pallefroi 60%
	end

	local f = _G[Necrosis.Warlock_Buttons.mounts.f]
	if action == "BUFF" then
	--print (nom)
		local fs = _G[Necrosis.Warlock_Buttons.trance.f]
		local fb = _G[Necrosis.Warlock_Buttons.backlash.f]
		-- Changing the mount button when the Warlock is disassembled || Changement du bouton de monture quand le Démoniste est démonté
		if nom == Necrosis.Warlock_Spells[5784].Name or  nom == Necrosis.Warlock_Spells[23161].Name or nom == "NomCheval1" or nom == "NomCheval2" then
			Local.BuffActif.Mount = true
			if f then
				f:SetNormalTexture(Necrosis.Warlock_Buttons.mounts.high)
				f:GetNormalTexture():SetDesaturated(nil)
			end
		-- Change Dominated Domination Button if Enabled + Cooldown Timer || Changement du bouton de la domination corrompue si celle-ci est activée + Timer de cooldown
		elseif Necrosis.IsSpellKnown("domination") 
			and (nom == Necrosis.GetSpellName("domination")) 
			then -- 15
			Local.BuffActif.Domination = true
			local f = _G[Necrosis.Warlock_Buttons.domination.f]
			if f then
				f:SetNormalTexture(Necrosis.Warlock_Buttons.domination.high)
				f:GetNormalTexture():SetDesaturated(nil)
			end
		-- Change the spiritual link button if it is enabled || Changement du bouton du lien spirituel si celui-ci est activé
		elseif Necrosis.IsSpellKnown("link") 
			and (nom == Necrosis.GetSpellName("link")) 
			then -- 38
			Local.BuffActif.SoulLink = true
			local f = _G[Necrosis.Warlock_Buttons.link.f]
			if f then
				f:SetNormalTexture(Necrosis.Warlock_Buttons.link.high)
				f:GetNormalTexture():SetDesaturated(nil)
			end
		-- If Backlash or MoltenCore, to display the icon and we proc the sound || si Contrecoup, pouf on affiche l'icone et on proc le son
		-- If By-effect, one-on-one icon and one proc the sound || if By-effect, pouf one posts the icon and one proc the sound
		
		elseif nom == Necrosis.Translation.Proc.Backlash  or nom == select(1, GetSpellInfo(47247)) and NecrosisConfig.ShadowTranceAlert then
			
			
			
			if nom == select(1, GetSpellInfo(47247)) then -- Motencore
				--print (select(1, GetSpellInfo(47247)))
				Necrosis:Msg(Necrosis.ProcText.MoltenCore, "USER")
				if NecrosisConfig.Sound then PlaySound(12977) end	

			else
				Necrosis:Msg(Necrosis.ProcText.Backlash, "USER")
				if NecrosisConfig.Sound then PlaySoundFile(Necrosis.Sound.Backlash) end	
			
			end
			
			
			fb:Show()
			
		-- If Twilight, to display the icon and sound || si Crépuscule, pouf on affiche l'icone et on proc le son
		-- If Twilight / Nightfall, puff one posts the icon and one proc the sound || if Twilight/Nightfall, pouf one posts the icon and one proc the sound
		elseif nom == Necrosis.Translation.Proc.ShadowTrance and NecrosisConfig.ShadowTranceAlert then
			Necrosis:Msg(Necrosis.ProcText.ShadowTrance, "USER")
			if NecrosisConfig.Sound then PlaySoundFile(Necrosis.Sound.ShadowTrance) end
			fs:Show()
		end
	else
		-- Changing the mount button when the Warlock is dismount || Changement du bouton de monture quand le Démoniste est démonté
		if nom == Necrosis.Warlock_Spells[5784].Name or  nom == Necrosis.Warlock_Spells[23161].Name or nom == "NomCheval1" or nom == "NomCheval2" then
			Local.BuffActif.Mount = false
			if f then
				f:SetNormalTexture(Necrosis.Warlock_Buttons.mounts.norm)
			end
		-- Domination button change when Warlock is no longer under control || Changement du bouton de Domination quand le Démoniste n'est plus sous son emprise
		elseif Necrosis.IsSpellKnown("domination") -- known
			and (nom == Necrosis.GetSpellName("domination")) 
			then -- 15
			Local.BuffActif.Domination = false
			local f = _G[Necrosis.Warlock_Buttons.domination.f]
			if f then
				f:SetNormalTexture(Necrosis.Warlock_Buttons.mounts.norm)
			end
		-- Changing the Spiritual Link button when the Warlock is no longer under control || Changement du bouton du Lien Spirituel quand le Démoniste n'est plus sous son emprise
		elseif Necrosis.IsSpellKnown("link") -- known
			and (nom == Necrosis.GetSpellName("link")) 
			then -- 38
			Local.BuffActif.SoulLink = false
			local f = _G[Necrosis.Warlock_Buttons.link.f]
			if f then
				f:SetNormalTexture(Necrosis.Warlock_Buttons.link.norm)
			end
		-- Hide the shadowtrance (nightfall) or backlash buttons when the state is ended
		elseif nom == Necrosis.Translation.Proc.ShadowTrance or nom == select(1, GetSpellInfo(47247)) or nom == Necrosis.Translation.Proc.Backlash then
			local fs = _G[Necrosis.Warlock_Buttons.trance.f]
			local fb = _G[Necrosis.Warlock_Buttons.backlash.f]
			fs:Hide()
			fb:Hide()
		end
	end
	Necrosis:UpdateMana()
	return
end

------------------------------------------------------------------------------------------------------
-- NECROSIS FUNCTIONS || FONCTIONS NECROSIS
------------------------------------------------------------------------------------------------------
local function SatList(list, val)
	for i, v in pairs(list) do
		menuVariable = _G[Necrosis.Warlock_Buttons[v.f_ptr].f]
		if menuVariable then
			menuVariable:GetNormalTexture():SetDesaturated(val)
		end
	end
end
-- Event : UNIT_PET
-- Allows the servo to be timed, as well as to prevent for servo breaks || Permet de timer les asservissements, ainsi que de prévenir pour les ruptures d'asservissement
-- Also change the name of the pet to the replacement of it || Change également le nom du pet au remplacement de celui-ci
function Necrosis:ChangeDemon()
	if Necrosis.IsSpellKnown("enslave") then -- can enslave a demon
		-- If the new demon is a slave demon, we put a 5 minute timer || Si le nouveau démon est un démon asservi, on place un timer de 5 minutes
		if UnitHasEffect("pet", Necrosis.GetSpellName("enslave")) then 
			if (not Local.Summon.DemonEnslaved) then
				Local.Summon.DemonEnslaved = true
				--Necrosis:Msg("ENSLAVE", "USER")
--[[ timer should have been put in place on spell cast...
--]]
			end
		else
			-- When the enslaved demon is lost, remove the timer and warn the warlock || Quand le démon asservi est perdu, on retire le Timer et on prévient le Démoniste
			if (Local.Summon.DemonEnslaved) then
				Local.Summon.DemonEnslaved = false
				Local.TimerManagement = Necrosis:RetraitTimerParNom(
					Necrosis.GetSpellName("enslave"), -- 10
					Local.TimerManagement, "enslaved demon lost")
				if NecrosisConfig.Sound then PlaySoundFile(Necrosis.Sound.EnslaveEnd) end
				Necrosis:Msg(Necrosis.ChatMessage.Information.EnslaveBreak, "USER")
			end
		end
	end

	-- If the demon is not enslaved we define its title, and we update its name in Necrosis || Si le démon n'est pas asservi on définit son titre, et on met à jour son nom dans Necrosis
	Local.Summon.LastDemonType = Local.Summon.DemonType
	Local.Summon.DemonType = UnitCreatureFamily("pet") or nil
	Local.Summon.DemonId = Necrosis.Utils.ParseGUID(UnitGUID("pet")) or nil
	
	local high = nil
	for i = 1, #Necrosis.Warlock_Lists.pets, 1 do -- pets + but we'll only match normal pets
		local fn = Necrosis.Warlock_Buttons[Necrosis.Warlock_Lists.pets[i].f_ptr].f
		local f = _G[fn]
		local spell = Necrosis.GetSpell(Necrosis.Warlock_Lists.pets[i].high_of)
		if f and spell.PetId then
			if tonumber(Local.Summon.DemonId) == spell.PetId then
				NecrosisConfig.PetInfo[Necrosis.Warlock_Lists.pets[i].high_of] = UnitName("pet")
				high = spell.PetId -- only expect one
				f:LockHighlight()
			else
				f:UnlockHighlight(f.norm)
			end
		end
	end
	Necrosis:UpdateMana()

--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("ChangeDemon"
.." ld'"..tostring(Local.Summon.LastDemonType).."'"
.." dt'"..tostring(Local.Summon.DemonType).."'"
.." di'"..tostring(Local.Summon.DemonId).."'"
.." hi'"..tostring(high).."'"
.." up'"..tostring(UnitName("pet")).."'"
)
--]]
	return
end

local function SetupSpells(reason)
	Necrosis:SpellSetup(reason)

	-- associate the mounts to the sphere button || Association du sort de monture correct au bouton
	if GetSpellInfo(GetSpellInfo(5784)) or GetSpellInfo(GetSpellInfo(23161)) then
		Local.Summon.SteedAvailable = true
	else
		Local.Summon.SteedAvailable = false
	end
    
	



	if not InCombatLockdown() then
		Necrosis:MainButtonAttribute()
		Necrosis:BuffSpellAttribute()
		Necrosis:PetSpellAttribute()
		Necrosis:CurseSpellAttribute()
		Necrosis:StoneAttribute(Local.Summon.SteedAvailable)
	end

	-- (re)create the icons around the main sphere
	Necrosis:CreateMenu()
	Necrosis:ButtonSetup()

	-- Check for stones - the buttons can be updated as needed
	Necrosis:BagExplore()

	--[[ Determine the pet out, if any, and mark its button.
		Really to clear the buttons in case we 'lose' the pet
		on a reload / crash / other reason.
		The event UNIT_PET is triggered at init / reload IF a pet is out
	--]]
	Necrosis:ChangeDemon() 
end

--[[ SetupBuffTimers
This routine is invoked during initialization to get warlock buffs, if any.
However, it seems buffs are not available until after Necrosis initializes on a login. 
Use variables above and OnUpdate to get them, if needed.
--]]
function SetupBuffTimers()
--		print(("%d=%s, %s, %.2f minutes left."):format(i,name,icon,(etime-GetTime())/60))
	if Necrosis.Debug.init_path then
		print("SetupBuffTimers"
			.." bn'"..tostring(Local.buff_needed).."'"
			.." ba'"..tostring(Local.buff_attempts).."'"
			)
	end
	local buffs_found = false
	local res = false
	for i=1,40 do -- hate hard coded numbers! Forums suggest the max buffs is 32 but no one is sure...
	  local name, icon, count, debuffType, duration, 
		expirationTime, source, isStealable, nameplateShowPersonal, spellId, 
		canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod 
		= UnitBuff("player", i)

		if name then
			buffs_found = true
			if Necrosis.Debug.init_path then
				print("SetupBuffTimers"
					.." '"..name.."'"
					.." "..Necrosis.Utils.TimeLeft(expirationTime-GetTime())
					)
			end

			local s_id, s_usage, s_timer, s_buff, s_cool = Necrosis.GetSpellByName(name)
			if s_timer and s_buff then
				local target = {
						name = UnitName("player"),
						lvl  = UnitLevel("player"),
						guid = UnitGUID("player"),
						}
				local cast_info = {
					usage = s_usage,
					spell_id  = s_id,
					guid = "",
					}
				Local.TimerManagement = Necrosis:TimerInsert(cast_info, target, Local.TimerManagement, "buff found", expirationTime-duration, duration, s_cool)
			else
			end
		else
			break -- no more
		end
	end

	if buffs_found or (Local.buff_attempts >= 5) then
		-- we are ok
		Local.buff_needed = false
		Local.buff_attempts = 0
	else
		-- There could be no buffs or they are not ready yet
		-- Check every second up to the max attempts above
		Local.buff_needed = true
		Local.buff_attempts = Local.buff_attempts + 1
	end
end

local function StartInit(fm)
	-- unregister, server can spam unrelated ids  !?
	fm:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	-- Initialization of the mod || Initialisation du mod
	Necrosis:Initialize(Local.DefaultConfig)
	-- Set timers if any buffs are on
	SetupBuffTimers()

	--[[ Once the localized strings are known, build the buttons.
	--]]
	Local.InWorld = true
end

-- Function started when updating the interface (main) - every 0.1 seconds || Fonction lancée à la mise à jour de l'interface (main) -- Toutes les 0,1 secondes environ
function Necrosis:OnUpdate(something, elapsed)
	
	Local.LastUpdate[1] = Local.LastUpdate[1] + elapsed
	Local.LastUpdate[2] = Local.LastUpdate[2] + elapsed

	-- If smooth scroll timers, we update them as soon as possible || Si défilement lisse des timers, on les met à jours le plus vite possible
	if NecrosisConfig.Smooth then
		NecrosisUpdateTimer(Local.TimerManagement.SpellTimer)
	end

	-- If timers texts, we update them very quickly also || Si timers textes, on les met à jour très vite également
	if NecrosisConfig.TimerType == 2 then
		Necrosis:TextTimerUpdate(Local.TimerManagement.SpellTimer, Local.TimerManagement.SpellGroup)
	end

	-- Every second || Toutes les secondes
	if Local.LastUpdate[1] > 1 then
	-- If configured, sorting fragments every second || Si configuré, tri des fragments toutes les secondes
		if NecrosisConfig.SoulshardSort and Local.Soulshard.Move > 0  then
			--Necrosis:SoulshardSwitch("MOVE")
		end

		-- Timers Table Course || Parcours du tableau des Timers
		if Local.TimerManagement.SpellTimer[1] then
			for index = 1, #Local.TimerManagement.SpellTimer, 1 do
				
				if Local.TimerManagement.SpellTimer[index] then
				
					
					-- We remove the completed timers || On enlève les timers terminés
					local TimeLocal = GetTime()
					
					if TimeLocal >= (Local.TimerManagement.SpellTimer[index].TimeMax - 0.5) then
						local StoneFade = false
						-- If the timer was that of Soul Stone, warn the Warlock || Si le timer était celui de la Pierre d'âme, on prévient le Démoniste
						local rez = Necrosis.GetSpellName("ss_rez") 
						if Local.TimerManagement.SpellTimer[index].Name == rez then
							Necrosis:Msg(Necrosis.ChatMessage.Information.SoulstoneEn, "USER")
							if NecrosisConfig.Sound then PlaySoundFile(Necrosis.Sound.SoulstoneEnd) end
							StoneFade = true
						elseif Local.TimerManagement.SpellTimer[index].Name == Necrosis.GetSpellName("banish") then --Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["banish"]].Name then -- 9
							Local.TimerManagement.Banish = false
						end
						-- Otherwise we remove the timer silently (but not in case of enslave) || Sinon on enlève le timer silencieusement (mais pas en cas d'enslave)
						local enslave = -- get name if known
							Necrosis.GetSpellName("enslave") -- 10
						--print (enslave,Local.TimerManagement.SpellTimer[index].Name)
												
						if not (Local.TimerManagement.SpellTimer[index].Name == enslave) then
							
							Local.TimerManagement = Necrosis:RetraitTimerParIndex(index, Local.TimerManagement, "spell expired")
							index = 0
							if StoneFade then
								-- We update the appearance of the button of the soul stone || On met à jour l'apparence du bouton de la pierre d'âme
								UpdateIcons()
							end
							break
						end
					end
				end
			end
		end
		
		if Local.buff_needed then
			SetupBuffTimers()
		end
		
		Local.LastUpdate[1] = 0
	-- Every half second || Toutes les demies secondes
	elseif Local.LastUpdate[2] > 0.5 then
		-- If normal graphical timers scroll, then we update every 0.5 seconds || Si défilement normal des timers graphiques, alors on met à jour toutes les 0.5 secondes
		if not NecrosisConfig.Smooth then
			NecrosisUpdateTimer(Local.TimerManagement.SpellTimer)
		end
		
		
		-- If configured, display warnings from Antifear || Si configuré, affichage des avertissements d'Antifear
		if NecrosisConfig.AntiFearAlert then
			ShowAntiFearWarning()
		end
		-- If configured, the Sphere is transfected into a Ground Chrono || Si configuré, on transfome la Sphere en Chrono de Rez
		if (NecrosisConfig.CountType == 3 or NecrosisConfig.Circle == 2)
			and (Local.Stone.Soul.Mode == 3 or Local.Stone.Soul.Mode == 4)
			then
				Local.LastSphereSkin = Necrosis:RezTimerUpdate(
					Local.TimerManagement.SpellTimer, Local.LastSphereSkin
				)
		end
		-- If soul stone button is shown and timer is active then put timer on the stone
		if _G[Necrosis.Warlock_Buttons.soul_stone.f] then
			Necrosis:RezStoneUpdate(Local.TimerManagement.SpellTimer)
		end
		Local.LastUpdate[2] = 0
	end
end

------------------------------------------------------------------------------------------------------
-- FUNCTIONS NECROSIS "ON EVENT" || FONCTIONS NECROSIS "ON EVENT"
------------------------------------------------------------------------------------------------------
local function ev_out(event, msg, init, events, spells)
	local output = false
	-- What was requested?
	if Necrosis.Debug.init_path and init then
		output = true
	end
	if Necrosis.Debug.events and events then
		output = true
	end
	if Necrosis.Debug.spells_cast and spells then
		output = true
	end

	if msg == nil or msg == "" then
		-- no additional message
	else
		msg = " '"..tostring(msg).."'"

	end
	if output then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Init ::: "..tostring(event)
			..tostring(msg)
		)
	end
end

local function SetSpellCast(spell_id, cast_guid, unit, event)
	local spell = Necrosis.GetSpellById(spell_id)

	if (target == nil or target == "")
	and spell.SelfOnly
	then
		-- Not all UNIT_SPELLCAST_SENT events specify the target (player for Demon Armor)...
		Local.SpellCasted[cast_guid].TargetName = UnitName("player")
		Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("player")
		Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("player")
	elseif target == nil or target == "" then
		if Necrosis.IsSpellDemon(Spell.Name) then
			local id, usage, timer = Necrosis.GetSpellByName(Spell.Name)
			Local.SpellCasted[cast_guid].TargetName = (NecrosisConfig.PetInfo[usage] or "")
			Local.SpellCasted[cast_guid].TargetGUID = ""
			Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("player")
		else
			Local.SpellCasted[cast_guid].TargetName = UnitName("target")
			Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("target")
			Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("target")
		end
	else
		Local.SpellCasted[cast_guid].TargetName = target
		Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("target")
		Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("target")
	end
	Local.SpellCasted[cast_guid].Name = spell.Name
	Local.SpellCasted[cast_guid].Id = spell_id
	Local.SpellCasted[cast_guid].Guid = cast_guid
	Local.SpellCasted[cast_guid].Unit = unit
	
	local sc = Local.SpellCasted[cast_guid]
	msg = " '"..tostring(cast_guid or "nyl").."'"
		.." '"..tostring(sc.Name or "nyl").."'"
		.." '"..tostring(sc.TargetName or "nyl").."'"
	ev_out(event, msg, false, false, true)
	sc = nil

	Local.SpeechManagement = Necrosis:Speech_It(Local.SpellCasted[cast_guid], Local.SpeechManagement, metatable)
end
--[[ Function started according to the intercepted event || Fonction lancée selon l'événement intercepté
NOTE: At entering world AND a warlock, this attempts to get localized strings from WoW.
This may take calls to the server on first session login of a warlock. The init of Necrosis is delayed until those strings are done. 
This *should* happen quickly. Waiting avoids issues by ensuring localized strings are known before used.
--]]
function Necrosis:OnEvent(self, event,...)
	local arg1,arg2,arg3,arg4,arg5,arg6 = ...

	local fm = _G[Necrosis.Warlock_Buttons.main.f]
	local ev = {} -- debug
	local msg = ""

	if (event == "PLAYER_LOGIN") then
		ev_out(event, "", true, true, false)
	elseif (event == "PLAYER_LEAVING_WORLD") then
		ev_out(event, "", true, true, false)
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		local _, Class = UnitClass("player")
		msg = " '"..tostring(done).."'"
			.." '"..tostring(Local.InWorld).."'"
		ev_out(event, msg, false, true, false)
		if Class == "WARLOCK" then
			if Local.InWorld then
			else
				ev_out(event, done, true, false, false)
				-- get localized names for warlock items, this may require calls to WoW server
				fm:RegisterEvent("GET_ITEM_INFO_RECEIVED")
				BagNamesKnown() -- need the localized names...
				Necrosis.InitWarlockItems()
				if Necrosis.WarlockItemsDone() then --and BagNamesKnown() then
					StartInit(fm)
				else -- safe to start up
					-- need to wait for server - GET_ITEM_INFO_RECEIVED
				end
			end

			-- Detecting the type of demon present at the connection || Détection du Type de démon présent à la connexion
			Local.Summon.DemonType = UnitCreatureFamily("pet")
		end
	elseif event == "GET_ITEM_INFO_RECEIVED" then
		-- Process the server response: arg1 is item id; arg2 is success / fail
		Necrosis.SetItem(arg1, arg2)
		if Necrosis.WarlockItemsDone() then --and BagNamesKnown() then
			ev_out(event, Necrosis.WarlockItemsDone(), true, true, false)
			StartInit(fm)
		else -- safe to start up
			-- need to wait for server to give more localized strings
		end
	end

	-- Is the game well loaded? || Le jeu est-il bien chargé ?
	-- Allow a full initialize before other events start being processed
	if not Local.InWorld then
		return
	end

	if (event == "SPELLS_CHANGED") then
		if InCombatLockdown() then
			-- should not get these in combat but ...
		else
			-- safe to process new spells and rebuild buttons
			SetupSpells("SPELLS_CHANGED")
		end
	end

	-- If the contents of the bags have changed, we check that Soul Fragments are always in the right bag || Si le contenu des sacs a changé, on vérifie que les Fragments d'âme sont toujours dans le bon sac
	if (event == "BAG_UPDATE") then
		Necrosis:BagExplore(arg1)
		if (NecrosisConfig.SoulshardSort) then
			--Necrosis:SoulshardSwitch("CHECK")
		end
	-- If the player wins or loses mana || Si le joueur gagne ou perd de la mana
	elseif (event == "UNIT_MANA") and arg1 == "player" then
		Necrosis:UpdateMana()
	-- If the player wins or loses his life || Si le joueur gagneou perd de la vie
	elseif (event == "UNIT_HEALTH") and arg1 == "player" then
		Necrosis:UpdateHealth()
	-- If the player dies || Si le joueur meurt
	elseif (event == "PLAYER_DEAD") then
		-- It may hide the Twilight or Backlit buttons. || On cache éventuellement les boutons de Crépuscule ou Contrecoup.
		Local.Dead = true
		local fs = _G[Necrosis.Warlock_Buttons.trance.f]
		local fb = _G[Necrosis.Warlock_Buttons.backlash.f]
		fs:Hide()
		fb:Hide()
		-- We gray all the spell buttons || On grise tous les boutons de sort
		local f = _G[Necrosis.Warlock_Buttons.mounts.f]
		if f then
			f:GetNormalTexture():SetDesaturated(1)
		end
		SatList(Necrosis.Warlock_Lists.buffs, 1)
		SatList(Necrosis.Warlock_Lists.pets, 1)
		SatList(Necrosis.Warlock_Lists.curses, 1)
	-- If the player resurrects || Si le joueur ressucite
	elseif 	(event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST") then
		-- We are sobering all the spell buttons || On dégrise tous les boutons de sort
		local f = _G[Necrosis.Warlock_Buttons.mounts.f]
		if f then
			f:GetNormalTexture():SetDesaturated(nil)
		end
		SatList(Necrosis.Warlock_Lists.buffs, nil)
		SatList(Necrosis.Warlock_Lists.pets, nil)
		SatList(Necrosis.Warlock_Lists.curses, nil)
		-- We reset the gray button list || On réinitialise la liste des boutons grisés
		Local.Desatured = {}
		Local.Dead = false
	-- Successful spell casting management || Gestion de l'incantation des sorts réussie
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") and arg1 == "player" then
		-- UNIT_SPELLCAST_SUCCEEDED: "unitTarget", "castGUID", spellID || https://wow.gamepedia.com/UNIT_SPELLCAST_SUCCEEDED
		-- This can get chatty as other 'casts' are sent such as enchanting / skinning / ...
		local target, cast_guid, spell_id = arg1, arg2, arg3
		
		
		msg = " sid'"..tostring(spell_id or "nyl").."'"
			.." t'"..tostring(target or "nyl").."'"
			.." cg'"..tostring(cast_guid or "nyl").."'"
		ev_out(event, msg, false, true, true)
		
		if Local.SpellCasted[cast_guid] then -- processing this one
			local sc = Local.SpellCasted[cast_guid]

			if (target == nil or target == "")
			then -- some spells only have the target on success
				Local.SpellCasted[cast_guid].TargetName = UnitName("player")
				Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("target")
				Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("target")
			end
			msg = " a1'"..tostring(arg1).."'"
				.." a2'"..tostring(arg2).."'"
				.." a3'"..tostring(arg3).."'"
				.." '"..tostring(GetSpellInfo(arg3)).."'"
			ev_out(event, msg, false, false, true)
			msg = " "..tostring((sc.Guid == cast_guid) and "ok" or "!?")..""
				.." g'"..tostring(sc.Guid or "nyl").."'"
				.." i'"..tostring(sc.Id or "nyl").."'"
				.." n'"..tostring(sc.Name or "nyl").."'"
				.." u'"..tostring(sc.Unit or "nyl").."'"
			ev_out(event, msg, false, false, true)
			msg = " tn'"..tostring(sc.TargetName or "nyl").."'"
				.." tl'"..tostring(sc.TargetLevel or "nyl").."'"
				.." g'"..tostring(sc.Guid or "nyl").."'"
				.." tg'"..tostring(sc.TargetGUID or "nyl").."'"
			ev_out(event, msg, false, false, true)
			sc = nil

			SpellManagement(Local.SpellCasted[cast_guid])
			CheckCorruptionRefresh(target, cast_guid, spell_id)
			Local.SpellCasted[cast_guid] = {} -- processed so clear
		end
		target, cast_guid, spell_id = nil, nil, nil
		
	-- When the warlock begins to cast a spell, we get the spell name and id
	elseif (event == "UNIT_SPELLCAST_SENT") then
		-- UNIT_SPELLCAST_SENT: "unit", "target", "castGUID", spellID || https://wow.gamepedia.com/UNIT_SPELLCAST_SENT
		-- Example:   player Starving Dire Wolf Cast-3-4379-0-140-6223-0005C729D2 6223 
		-- Expect a SUCCESS or FAILED or INTERRUPTED after this
		-- Rely on castGUID to be unique. This allows the exact timer, if any, to added or removed as needed

		local unit, target, cast_guid, spell_id = arg1, arg2, arg3, arg4
			
		msg = " sid'"..tostring(spell_id or "nyl").."'"
			.." sg'"..tostring(cast_guid or "nyl").."'"
			.." u'"..tostring(unit or "nyl").."'"
			.." t'"..tostring(target or "nyl").."'"
		ev_out(event, msg, false, true, true)

		
		
		
		
		Local.SpellCasted[cast_guid] = {} -- start an entry
		if spell_id and Necrosis.GetSpellById(spell_id) then -- it is a spell to process
			local spell = Necrosis.GetSpellById(spell_id)
	
			if (target == nil or target == "")
			and spell.SelfOnly
			then
				-- Not all UNIT_SPELLCAST_SENT events specify the target (player for Demon Armor)...
				Local.SpellCasted[cast_guid].TargetName = UnitName("player")
				Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("player")
				Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("player")
			elseif target == nil or target == "" then

				Local.SpellCasted[cast_guid].TargetName = UnitName("target")
				Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("target")
				Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("target")
			else
				Local.SpellCasted[cast_guid].TargetName = target
				Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("target")
				Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("target")
			end
			Local.SpellCasted[cast_guid].Name = spell.Name
			Local.SpellCasted[cast_guid].Id = spell_id
			Local.SpellCasted[cast_guid].Guid = cast_guid
			Local.SpellCasted[cast_guid].Unit = unit
			
			local sc = Local.SpellCasted[cast_guid]
			msg = " '"..tostring(cast_guid or "nyl").."'"
				.." '"..tostring(sc.Name or "nyl").."'"
				.." '"..tostring(sc.TargetName or "nyl").."'"
			ev_out(event, msg, false, false, true)
			sc = nil
		
			Local.SpeechManagement = Necrosis:Speech_It(Local.SpellCasted[cast_guid], Local.SpeechManagement, metatable)
		end
		
		unit, target, cast_guid, spell_id = nil, nil, nil, nil
		-- Wait for a succeed or miss event. 
		-- If the spell is resisted it will likely come AFTER a success event so the timer needs to be removed.

	-- When the warlock stops his incantation, we release the name of it || Quand le démoniste stoppe son incantation, on relache le nom de celui-ci
	elseif (event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED") and arg1 == "player" then
		-- UNIT_SPELLCAST_FAILED: "unitTarget", "castGUID", spellID || https://wow.gamepedia.com/UNIT_SPELLCAST_FAILED
		-- UNIT_SPELLCAST_INTERRUPTED: "unitTarget", "castGUID", spellID || https://wow.gamepedia.com/UNIT_SPELLCAST_INTERRUPTED
		msg = " a1'"..tostring(arg1).."'"
				.." a2'"..tostring(arg2).."'"
				.." a3'"..tostring(arg3).."'"
				.." '"..tostring(GetSpellInfo(arg3)).."'"
		ev_out(event, msg, false, true, true)

		if Local.SpellCasted[arg2] then -- safety to ensure the spell was sent and we are 'tracking' it
			-- Send to delete any timer that exist...
			Local.TimerManagement = Necrosis:RetraitTimerParCast(arg2, Local.TimerManagement, "UNIT_SPELLCAST_FAILED")
		end
		Local.SpellCasted[arg2] = {}
	-- Flag if a Trade window is open, so you can automatically trade the healing stones || Flag si une fenetre de Trade est ouverte, afin de pouvoir trader automatiquement les pierres de soin
	elseif event == "TRADE_REQUEST" or event == "TRADE_SHOW" then
		Local.Trade.Request = true
	elseif event == "TRADE_REQUEST_CANCEL" or event == "TRADE_CLOSED" then
		Local.Trade.Request = false
	elseif event=="TRADE_ACCEPT_UPDATE" then
		if Local.Trade.Request and Local.Trade.Complete then
			AcceptTrade()
			Local.Trade.Request = false
			Local.Trade.Complete = false
		end
	-- AntiFear button hide on target change || AntiFear button hide on target change
	elseif event == "PLAYER_TARGET_CHANGED" then
		--print (event,UnitAffectingCombat("player") )
		--print(NecrosisConfig.AntiFearAlert , Local.Warning.Antifear.Immune)
		if NecrosisConfig.AntiFearAlert and Local.Warning.Antifear.Immune then
			Local.Warning.Antifear.Immune = false
		end
		if NecrosisConfig.CreatureAlert	and UnitCanAttack("player", "target") and not UnitIsDead("target") then
		
		usable, nomana = IsUsableSpell(Necrosis.GetSpellName("enslave"));
		--print(usable,nomana,Necrosis.Unit.Demon,Necrosis.Unit.Elemental)
		
			if UnitCreatureType("target") == Necrosis.Unit.Demon  then 	-- Button Alerte Demon	
			NecrosisCreatureAlertButton_demon:SetAlpha(1)		
			--NecrosisCreatureAlertButton_demon:EnableMouse(true)
			
			NecrosisCreatureAlertButton_elemental:SetAlpha(1) 
			--NecrosisCreatureAlertButton_elemental:EnableMouse(true)
			NecrosisCreatureAlertButton_elemental:SetMovable(true)
			
			elseif UnitCreatureType("target") == Necrosis.Unit.Elemental then-- Button Alerte Elemental
			NecrosisCreatureAlertButton_elemental:SetAlpha(1)
			--NecrosisCreatureAlertButton_elemental:EnableMouse(true)
			NecrosisCreatureAlertButton_demon:SetAlpha(0)
			--NecrosisCreatureAlertButton_demon:EnableMouse(true)
			NecrosisCreatureAlertButton_elemental:SetMovable(true)
	
			else
			NecrosisCreatureAlertButton_demon:SetAlpha(0)
			--NecrosisCreatureAlertButton_demon:EnableMouse(true)
			
			NecrosisCreatureAlertButton_elemental:SetAlpha(0) 
			--NecrosisCreatureAlertButton_elemental:EnableMouse(true)
	
			end
		else
		NecrosisCreatureAlertButton_demon:SetAlpha(0) 
		NecrosisCreatureAlertButton_elemental:SetAlpha(0) 	

		NecrosisCreatureAlertButton_demon:SetMovable(true)		
		NecrosisCreatureAlertButton_elemental:SetMovable(true)			
		--print(UnitCreatureType("target"))

			
	  end
	-- If the Warlock learns a new spell / spell, we get the new spells list || Si le Démoniste apprend un nouveau sort / rang de sort, on récupère la nouvelle liste des sorts
	-- If the Warlock learns a new buff or summon spell, the buttons are recreated || Si le Démoniste apprend un nouveau sort de buff ou d'invocation, on recrée les boutons
	elseif (event == "LEARNED_SPELL_IN_TAB") then
		SetupSpells("LEARNED_SPELL_IN_TAB")

	-- At the end of the fight, we stop reporting Twilight || A la fin du combat, on arrête de signaler le Crépuscule
	-- We remove the spell timers and the names of mobs || On enlève les timers de sorts ainsi que les noms des mobs
	elseif (event == "PLAYER_REGEN_ENABLED") then
		Local.PlayerInCombat = false
		Local.TimerManagement = Necrosis:RetraitTimerCombat(Local.TimerManagement, "PLAYER_REGEN_ENABLED")
		NecrosisCreatureAlertButton_demon:EnableMouse(true)		
		NecrosisCreatureAlertButton_elemental:EnableMouse(true)
		
		
		
		--Necrosis:Msg("regen enabled", "USER")
		-- We are redefining the attributes of spell buttons in a situational way || On redéfinit les attributs des boutons de sorts de manière situationnelle
		Necrosis:NoCombatAttribute(Local.Stone.Soul.Mode, Local.Stone.Fire.Mode, Local.Stone.Spell.Mode, Local.Menu.Pet, Local.Menu.Buff, Local.Menu.Curse)
		UpdateIcons()

	-- When the warlock changes demon || Quand le démoniste change de démon
	elseif (event == "UNIT_PET" and arg1 == "player") then
		Necrosis:ChangeDemon()

	-- ============= COMBAT_LOG_EVENT_UNFILTERED
	-- Reading the combat log || Lecture du journal de combat
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		-- The parameters differ depending on the event... || https://wow.gamepedia.com/COMBAT_LOG_EVENT
		local a1, a2, a3, a4, a5, 
			a6, a7, a8, a9, a10, 
			a11, a12, a13, a14, a15
			= CombatLogGetCurrentEventInfo()
		local timestamp = a1
		local subevent = a2 
		local sourceGUID = a4
		local sourceName = a5
		local sourceFlags = a6
		local sourceRaidFlags = a7 
		local destGUID = a8 
		local destName = a9 
		local destFlags = a10 
		local destRaidFlags = a11 
		local spellId = a12 
		local Effect = a13 
		local spellSchool = a14
		ev={CombatLogGetCurrentEventInfo()}

		-- this will output a lot of spells not processed but it can be informative
		if (UnitName("player") == sourceName) 
		or (UnitName("player") == destName) 
		then
			msg = " e'"..tostring(Effect or "nyl").."'"
					.." se'"..tostring(subevent or "nyl").."'"
					.." s'"..tostring(sourceName or "nyl").."'"
					.." d'"..tostring(destName or "nyl").."'"
					.." sid'"..tostring(spellId or "nyl").."'"
					.." sp'"..tostring(spellSchool or "nyl").."'"
					.." a15'"..tostring(a15 or "nyl").."'"
					.." #'"..tostring(#ev or "nyl").."'"
			ev_out(event, msg, false, true, false)
		end

		-- Detection of Shadow Trance and Contrecoup || Détection de la transe de l'ombre et de  Contrecoup
		if subevent == "SPELL_AURA_APPLIED" then
			-- This is received for every aura with in range so output only what we process
			if destGUID == UnitGUID("player") then
				msg = " e'"..tostring(Effect or "nyl").."'"
						.." se'"..tostring(subevent or "nyl").."'"
						.." s'"..tostring(sourceName or "nyl").."'"
						.." d'"..tostring(destName or "nyl").."'"
						.." sid'"..tostring(spellId or "nyl").."'"
						.." sp'"..tostring(spellSchool or "nyl").."'"
						.." a15'"..tostring(a15 or "nyl").."'"
						.." #'"..tostring(#ev or "nyl").."'"
				ev_out(event, msg, false, false, true)

				SelfEffect("BUFF", Effect)
				SetupBuffTimers()
			end
			
		elseif subevent == "SPELL_AURA_REFRESH" then
			if destGUID == UnitGUID("player") then
				msg = " e'"..tostring(Effect or "nyl").."'"
						.." se'"..tostring(subevent or "nyl").."'"
						.." s'"..tostring(sourceName or "nyl").."'"
						.." d'"..tostring(destName or "nyl").."'"
						.." sid'"..tostring(spellId or "nyl").."'"
						.." sp'"..tostring(spellSchool or "nyl").."'"
						.." a15'"..tostring(a15 or "nyl").."'"
						.." #'"..tostring(#ev or "nyl").."'"
				ev_out(event, msg, false, false, true)

				SelfEffect("BUFF", Effect)
				SetupBuffTimers()
			end
			
		-- Detection of the end of Shadow Trance and Contrecoup || Détection de la fin de la transe de l'ombre et de Contrecoup
		elseif subevent == "SPELL_AURA_REMOVED" then
			-- This is received for every aura with in range so output only what we process
			if destGUID == UnitGUID("player") then
				msg = " e'"..tostring(Effect or "nyl").."'"
						.." se'"..tostring(subevent or "nyl").."'"
						.." s'"..tostring(sourceName or "nyl").."'"
						.." d'"..tostring(destName or "nyl").."'"
						.." sid'"..tostring(spellId or "nyl").."'"
						.." sp'"..tostring(spellSchool or "nyl").."'"
						.." a15'"..tostring(a15 or "nyl").."'"
						.." #'"..tostring(#ev or "nyl").."'"
				ev_out(event, msg, false, false, true)

				SelfEffect("DEBUFF", Effect)
				SetupBuffTimers()
			end
			if destGUID == UnitGUID("focus") 
			and Local.TimerManagement.Banish 
			and Effect == Necrosis.GetSpellName("banish") 
			then
				msg = " e'"..tostring(Effect or "nyl").."'"
						.." se'"..tostring(subevent or "nyl").."'"
						.." s'"..tostring(sourceName or "nyl").."'"
						.." d'"..tostring(destName or "nyl").."'"
						.." sid'"..tostring(spellId or "nyl").."'"
						.." sp'"..tostring(spellSchool or "nyl").."'"
						.." a15'"..tostring(a15 or "nyl").."'"
						.." #'"..tostring(#ev or "nyl").."'"
				ev_out(event, msg, false, false, true)
				Necrosis:Msg("BAN ! BAN ! BAN !", "USER")
				Local.TimerManagement = Necrosis:RetraitTimerParNom(Necrosis.GetSpellName("banish"), Local.TimerManagement, "SPELL_AURA_REMOVED banish") -- 9
				Local.TimerManagement.Banish = false
			end
			
			-- Remove any timer with same name on the target
			-- Note: The remove timer is called way more than is needed but this will handle removing timers for mobs that are not current target or focus
			if (UnitName("player") == sourceName) then
				Local.TimerManagement = Necrosis:RemoveTimerByNameAndGuid(Effect, destGUID, Local.TimerManagement, "SPELL_AURA_REMOVED")
			end
		-- Deban Detection || Détection du Déban
		-- Resist / immune detection || Détection des résists / immunes
		elseif subevent == "SPELL_MISSED" and sourceGUID == UnitGUID("player") then
			-- The 1st 8 arguments are always timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags
			-- "SPELL_MISSED" spellId, spellName, spellSchool, missType
			-- Will cleanup timers even if not target or focus
			if NecrosisConfig.AntiFearAlert then
				if Effect == Necrosis.GetSpellName("fear") and a15 == "IMMUNE"
				then
					Local.Warning.Antifear.Immune = true
					Local.TimerManagement = Necrosis:RemoveTimerByNameAndGuid(Effect, destGUID, Local.TimerManagement, "anti fear - fear cast")
				end
				if Effect == Necrosis.GetSpellName("death_coil") and a15 == "IMMUNE"
				then
					Local.Warning.Antifear.Immune = true
					Local.TimerManagement = Necrosis:RemoveTimerByNameAndGuid(Effect, destGUID, Local.TimerManagement, "anti fear - death_coil")
				end
			end

			msg = " a1'"..tostring(a1 or "nyl").."'"
					.." a2'"..tostring(a2 or "nyl").."'"
					.." a3'"..tostring(a3 or "nyl").."'"
					.." a4'"..tostring(a4 or "nyl").."'"
					.." a5'"..tostring(a5 or "nyl").."'"
					.." a6'"..tostring(a6 or "nyl").."'"
					.." a7'"..tostring(a7 or "nyl").."'"
					.." a8'"..tostring(a8 or "nyl").."'"
					.." a9'"..tostring(a9 or "nyl").."'"
					.." a10'"..tostring(a10 or "nyl").."'"
					.." a11'"..tostring(a11 or "nyl").."'"
					.." a12'"..tostring(a12 or "nyl").."'"
					.." a13'"..tostring(a13 or "nyl").."'"
					.." a14'"..tostring(a14 or "nyl").."'"
					.." a15'"..tostring(a15 or "nyl").."'"
					.." #'"..tostring(#ev or "nyl").."'"
			ev_out(event, msg, false, false, true)

			if (UnitName("player") == sourceName) then
				Local.TimerManagement = Necrosis:RemoveTimerByNameAndGuid(Effect, destGUID, Local.TimerManagement, "spell missed")
			end
		-- Detection application of a spell / fire stone on a weapon || Détection application d'une pierre de sort/feu sur une arme
		elseif subevent == "ENCHANT_APPLIED"
			and destGUID == UnitGUID("player")
			and (arg9 == NecrosisConfig.ItemSwitchCombat[1] or NecrosisConfig.ItemSwitchCombat[2])
			then
				Local.SomethingOnHand = arg9
				UpdateIcons()
		-- End of enchantment detection || Détection fin d'enchant
		elseif subevent == "ENCHANT_REMOVE"
			and destGUID == UnitGUID("player")
			and (arg9 == NecrosisConfig.ItemSwitchCombat[1] or NecrosisConfig.ItemSwitchCombat[2])
			then
				Local.SomethingOnHand = "Rien"
				UpdateIcons()
		elseif subevent == "UNIT_DIED" 
			then
			-- Any unit death within range
			-- Will cleanup timers even if not target or focus

			msg = " e'"..tostring(Effect or "nyl").."'"
				.." se'"..tostring(subevent or "nyl").."'"
				.." s'"..tostring(sourceName or "nyl").."'"
				.." sg'"..tostring(sourceGUID or "nyl").."'"
				.." d'"..tostring(destName or "nyl").."'"
				.." dg'"..tostring(destGUID or "nyl").."'"
				.." #'"..tostring(#ev or "nyl").."'"
			ev_out(event, msg, false, true, false)

			Local.TimerManagement = Necrosis:RetraitTimerParGuid(destGUID, Local.TimerManagement, "UNIT_DIED")
		end

	-- If we change weapons, we look at whether a spell / fire enchantment is on the new || Si on change d'arme, on regarde si un enchantement de sort / feu est sur la nouvelle
	elseif event == "SKILL_LINES_CHANGED" then
		local hasMainHandEnchant = GetWeaponEnchantInfo()
		if hasMainHandEnchant then
			Local.SomethingOnHand = "Truc"
		else
			Local.SomethingOnHand = "Rien"
		end
		UpdateIcons()

	-- If we come back into combat || Si on rentre en combat
	elseif event == "PLAYER_REGEN_DISABLED" then
		Local.PlayerInCombat = true
		-- Close the options menu || On ferme le menu des options
		if _G["NecrosisGeneralFrame"] and NecrosisGeneralFrame:IsVisible() then
			NecrosisGeneralFrame:Hide()
		end
		-- Spell button attributes are negated situational || On annule les attributs des boutons de sorts de manière situationnelle
		Necrosis:InCombatAttribute(Local.Menu.Pet, Local.Menu.Buff, Local.Menu.Curse)
	end 
	return
end

------------------------------------------------------------------------------------------------------
-- INTERFACE FUNCTIONS - XML ​​LINKS || FONCTIONS DE L'INTERFACE -- LIENS XML
------------------------------------------------------------------------------------------------------

-- Function to move Necrosis elements on the screen ||Fonction permettant le déplacement d'éléments de Necrosis sur l'écran
function Necrosis:OnDragStart(button)
	button:StartMoving()
end

-- Function stopping the movement of Necrosis elements on the screen ||Fonction arrêtant le déplacement d'éléments de Necrosis sur l'écran
function Necrosis:OnDragStop(button)
	-- We stop the movement effectively ||On arrête le déplacement de manière effective
	button:StopMovingOrSizing()
	-- We save the location of the button ||On sauvegarde l'emplacement du bouton
	local NomBouton = button:GetName()
	local AncreBouton, BoutonParent, AncreParent, BoutonX, BoutonY = button:GetPoint()
	if not BoutonParent then
		BoutonParent = "UIParent"
	else
		BoutonParent = BoutonParent:GetName()
	end
	NecrosisConfig.FramePosition[NomBouton] = {AncreBouton, BoutonParent, AncreParent, BoutonX, BoutonY}
end

-- For some users, GetSpellCooldown returns nil so ensure there are no 'nil errors', may cause odd quirks elsewhere...
local function Cooldown(usage)
	local start
	local dur
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("Cooldown"
.." i'"..tostring(usage or "nyl").."'"
)
--]]
	if Necrosis.IsSpellKnown(usage) then
		start, dur = GetSpellCooldown(Necrosis.Warlock_Spell_Use[usage], BOOKTYPE_SPELL) -- grab the spell id
		if not start then start = 1 end
		if not dur then dur = 1 end
	else
		start = 1
		dur = 1
	end
	
	return start, dur
end
-- helpers to reduce maintenance
local function ManaLocalize(mana)
	if GetLocale() == "ruRU" then
		GameTooltip:AddLine(L["MANA"]..": "..mana)
	else
		GameTooltip:AddLine(mana.." "..L["MANA"])
	end
end
local function AddCastAndCost(usage)
	GameTooltip:AddLine(Necrosis.GetSpellCastName(usage)) 
	ManaLocalize(Necrosis.GetSpellMana(usage)) 
end
local function AddShard()
	if Local.Soulshard.Count == 0 then
		GameTooltip:AddLine("|c00FF4444"..Necrosis.TooltipData.Main.Soulshard..Local.Soulshard.Count.."|r")
	else
		GameTooltip:AddLine(Necrosis.TooltipData.Main.Soulshard..Local.Soulshard.Count)
	end
end
local function AddDestroyCount()


	if NecrosisConfig.DestroyCount then
		GameTooltip:AddLine("|c00FF4444"..Necrosis.TooltipData.Main.Soulshard..Local.Soulshard.Count.."|r".."/".."|c00FF4444"..NecrosisConfig.DestroyCount.."|r")
		GameTooltip:AddLine("|c00FFFFFF".."Use MouseWheel to increase or decrease the limit ..")
		GameTooltip:AddLine("|c00FFFFFF".."Use LeftClick to move shard to the specific bag ..")
	end
end

local function AddDominion(start, duration)
	if not (start > 0 and duration > 0) then
		GameTooltip:AddLine(Necrosis.TooltipData.DominationCooldown)
		GameTooltip:AddLine(Necrosis.TooltipData.DominationCooldown2)
	end
end
local function AddMenuTip(Type)
	if Local.PlayerInCombat and NecrosisConfig.AutomaticMenu then
		GameTooltip:AddLine(Necrosis.TooltipData[Type].Text2)
	else
		GameTooltip:AddLine(Necrosis.TooltipData[Type].Text)
	end
end
local function AddInfernalReagent()
	if Local.Reagent.Infernal == 0 then
		GameTooltip:AddLine("|c00FF4444"..Necrosis.TooltipData.Main.InfernalStone..Local.Reagent.Infernal.."|r")
	else
		GameTooltip:AddLine(Necrosis.TooltipData.Main.InfernalStone..Local.Reagent.Infernal)
	end
end
local function AddDemoniacReagent()
	if Local.Reagent.Demoniac == 0 then
		GameTooltip:AddLine("|c00FF4444"..Necrosis.TooltipData.Main.DemoniacStone..Local.Reagent.Demoniac.."|r")
	else
		GameTooltip:AddLine(Necrosis.TooltipData.Main.DemoniacStone..Local.Reagent.Demoniac)
	end
end

-- Function managing the help bubbles ||Fonction gérant les bulles d'aide
function Necrosis:BuildButtonTooltip(button)
	-- If the display of help bubbles is disabled, Bye bye! ||Si l'affichage des bulles d'aide est désactivé, Bye bye !
	if not NecrosisConfig.NecrosisToolTip then
		return
	end


	
	if button == "ElementalToolTip" then button = NecrosisBuffMenu09 end -- lorsque button provient du bouton spécial elem/demon
	if button == "EnslaveToolTip" then button = NecrosisPetMenu08 end
	
	local f = button:GetName()	
		
	local Type = ""
	local b = nil
	-- look up the button info
	for i, v in pairs (Necrosis.Warlock_Buttons) do
		
	
		if v.f == f then
			Type = Necrosis.Warlock_Buttons[i].tip
			b = v
			break
		else
		end
	end
	
	if b == nil or b.tip == nil then
		return -- a button we are not interested in was given
	else
	
		Type = b.tip
		
	end

	if Necrosis.Debug.tool_tips then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("BuildButtonTooltip"
		.." b'"..tostring(f).."'"
		.." T'"..tostring(Type).."'"
		.." l'"..tostring(Necrosis.TooltipData[Type].Label).."'"
		)
	end
	
	anchor = b.anchor or "ANCHOR_RIGHT" -- put to right in case not specified...

	-- If the tooltip is associated with a menu button, we change the anchoring of the tooltip according to its meaning ||Si la bulle d'aide est associée à un bouton de menu, on change l'ancrage de la tooltip suivant son sens
	if b.menu then
	
		if (b.menu == "Pet" and NecrosisConfig.PetMenuPos.direction < 0)
			or
				(b.menu == "Buff" and NecrosisConfig.BuffMenuPos.direction < 0)
			or
				(b.menu == "Curse" and NecrosisConfig.CurseMenuPos.direction < 0)
			or
				(b.menu == "Timer" and NecrosisConfig.SpellTimerJust == "RIGHT")
			then
				anchor = "ANCHOR_LEFT"
		end
	else
		-- use the anchor already grabbed
	end

	local start,  duration  = Necrosis.Utils.GetSpellCooldown("domination", "spell")
	local start2, duration2  = Necrosis.Utils.GetSpellCooldown("ward", "spell")

	-- Creating help bubbles .... ||Création des bulles d'aides....
	GameTooltip:SetOwner(button, anchor)
	GameTooltip:SetText(Necrosis.TooltipData[Type].Label)
	-- ..... for the main button ||..... pour le bouton principal
	if (Type == "Main") then
		GameTooltip:AddLine(Necrosis.TooltipData.Main.Soulshard..Local.Soulshard.Count)
		GameTooltip:AddLine("|CFF808080"..L["SPHERE_SPELL_RIGHTCLICK"])
		GameTooltip:AddLine("|CFF808080"..L["SPHERE_SPELL_RIGHTCLICK_L2"])	
		GameTooltip:AddLine(Necrosis.TooltipData.Main.InfernalStone..Local.Reagent.Infernal)
		GameTooltip:AddLine(Necrosis.TooltipData.Main.DemoniacStone..Local.Reagent.Demoniac)
		local SoulOnHand = false
		local HealthOnHand = false
		local SpellOnHand = false
		local FireOnHand = false
		if Local.Stone.Soul.OnHand then SoulOnHand = true end
		if Local.Stone.Health.OnHand then HealthOnHand = true end
		if Local.Stone.Spell.OnHand then SpellOnHand = true end
		if Local.Stone.Fire.OnHand then FireOnHand = true end
		GameTooltip:AddLine("\n")
		GameTooltip:AddLine(Necrosis.TooltipData.Main.Soulstone..Necrosis.TooltipData[Type].Stone[SoulOnHand])
		GameTooltip:AddLine(Necrosis.TooltipData.Main.Healthstone..Necrosis.TooltipData[Type].Stone[HealthOnHand])
		GameTooltip:AddLine(Necrosis.TooltipData.Main.Spellstone..Necrosis.TooltipData[Type].Stone[SpellOnHand] )
		GameTooltip:AddLine(Necrosis.TooltipData.Main.Firestone..Necrosis.TooltipData[Type].Stone[FireOnHand])
		-- View the name of the daemon, or if it is slave, or "None" if no daemon is present ||Affichage du nom du démon, ou s'il est asservi, ou "Aucun" si aucun démon n'est présent
		if (Local.Summon.DemonType) then
			GameTooltip:AddLine(Necrosis.TooltipData.Main.CurrentDemon..Local.Summon.DemonType)
		elseif Local.Summon.DemonEnslaved then
			GameTooltip:AddLine(Necrosis.TooltipData.Main.EnslavedDemon)
		else
			GameTooltip:AddLine(Necrosis.TooltipData.Main.NoCurrentDemon)
		end
	-- ..... for stone buttons ||..... pour les boutons de pierre
	elseif Type:find("stone") then
		-- Soul Stone ||Pierre d'âme
		if (Type == "Soulstone") then
			AddCastAndCost("soulstone")
			-- We display the name of the stone and the action that will produce the click on the button ||On affiche le nom de la pierre et l'action que produira le clic sur le bouton
			-- And also the cooldown ||Et aussi le Temps de recharge

			-- cool down or not
			local color = "|CFF808080"
			local str = ""
			local cool = ""
			if Local.Stone.Soul.Location[1] and Local.Stone.Soul.Location[2] then
				local startTime, duration, isEnabled = C_Container.GetContainerItemCooldown(Local.Stone.Soul.Location[1], Local.Stone.Soul.Location[2])
				if startTime == 0 then
					-- not on cool down
				else
					str = Necrosis.Translation.Misc.Cooldown
					cool = " - "..Necrosis.Utils.TimeLeft(((startTime - GetTime()) + duration))
					cool = str..cool
				end
			end
			
			-- L click - use
			str = Necrosis.TooltipData[Type].Text[2]
			if cool == "" then
			else
				str = color..str.."|r" -- must wait for cool down
			end
			GameTooltip:AddLine(str)
			
			-- R click - create
			str = Necrosis.TooltipData[Type].Text[1]
			if Local.Stone.Soul.OnHand then
				str = color..str.."|r" -- already have one
			else
			end
			GameTooltip:AddLine(str)
			
			GameTooltip:AddLine(Necrosis.TooltipData[Type].Ritual)
			
			-- show cool down
			GameTooltip:AddLine(cool)
		-- Healthstone | Stone of life ||Healthstone | Pierre de vie
		elseif (Type == "Healthstone") then
			-- Idem ||Idem
			if Local.Stone.Health.Mode == 1 then
				AddCastAndCost("healthstone")
			end
			GameTooltip:AddLine(Necrosis.TooltipData[Type].Text[Local.Stone.Health.Mode])
			if Local.Stone.Health.Mode == 2 then
				GameTooltip:AddLine(Necrosis.TooltipData[Type].Text2)
			end
			
			-- cool down or not
			if Necrosis.Debug.tool_tips then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("BuildButtonTooltip"
				.." b'"..tostring(f).."'"
				.." T'"..tostring(Type).."'"
				.." l'"..tostring(Necrosis.TooltipData[Type].Label).."'"
				)
			end
			if Local.Stone.Health.Location[1] and Local.Stone.Health.Location[2] then
				local startTime, duration, isEnabled = C_Container.GetContainerItemCooldown(Local.Stone.Health.Location[1], Local.Stone.Health.Location[2])
				if startTime == 0 then
					-- not on cool down
				else
					local cool = ""
					local color = ""
					local str = Necrosis.Translation.Misc.Cooldown
					color = "|CFF808080"
					cool = " - "..Necrosis.Utils.TimeLeft(((startTime - GetTime()) + duration))
					GameTooltip:AddLine(color..str..cool.."|r")
				end
			end
--[[
			if itemName:find(Necrosis.Translation.Misc.Cooldown) then
				GameTooltip:AddLine(itemName)
			end
--]]
			if  Local.Soulshard.Count > 0 then
				GameTooltip:AddLine(Necrosis.TooltipData[Type].Ritual)
			end
		-- Stone of spell ||Pierre de sort
		elseif (Type == "Spellstone") then
			-- Eadem ||Eadem
			if Local.Stone.Spell.Mode == 1 then
				AddCastAndCost("spellstone")
			end
			GameTooltip:AddLine(Necrosis.TooltipData[Type].Text[Local.Stone.Spell.Mode])
			GameTooltip:AddLine(GetItemCount(41196, nil, true).." Charges")
		-- Fire stone ||Pierre de feu
		elseif (Type == "Firestone") then
			-- Idem ||Idem
			if Local.Stone.Fire.Mode == 1 then
				AddCastAndCost("firestone")
			end
			GameTooltip:AddLine(Necrosis.TooltipData[Type].Text[Local.Stone.Fire.Mode])
		end
	-- ..... for the Timers button ||..... pour le bouton des Timers
	elseif (Type == "SpellTimer") then
		GameTooltip:AddLine(Necrosis.TooltipData[Type].Text)
		local cool = ""
		local color = ""
		local str = Necrosis.TooltipData[Type].Right..GetBindLocation()
		local str2 = Necrosis.TooltipData[Type].Left
		if Local.Stone.Hearth.Location[1] and Local.Stone.Hearth.Location[2] then
			local startTime, duration, isEnabled = C_Container.GetContainerItemCooldown(Local.Stone.Hearth.Location[1], Local.Stone.Hearth.Location[2])
			if startTime == 0 then
				color = "|CFFFFFFFF"
			else
				color = "|CFF808080"
				cool = " - "..Necrosis.Utils.TimeLeft(((startTime - GetTime()) + duration))
			end
		end
		GameTooltip:AddLine(color..str..cool.."|r")
		GameTooltip:AddLine(color..str2..cool.."|r")
	-- ..... for the shadow trance button ||..... pour le bouton de la Transe de l'ombre
	elseif (Type == "ShadowTrance") then
		GameTooltip:SetText(Necrosis.TooltipData[Type].Label.."          |CFF808080"..Necrosis.GetSpellCastName("bolt").."|r")
	-- ..... for other buffs and demons, the mana cost ... ||..... pour les autres buffs et démons, le coût en mana...
	elseif (Type == "Enslave") then AddCastAndCost("enslave"); AddShard()
	
	--elseif (Type == "Mount") and Necrosis.Warlock_Spells[23161].InSpellBook then
	elseif (Type == "Mount")  then
-- TTip Left MOUNT			
		if NecrosisConfig.LeftMount then
			local LeftMountName = Necrosis.Utils.GetSpellName(NecrosisConfig.LeftMount)
			
			if LeftMountName then
					local icon_texture = GetSpellTexture(NecrosisConfig.LeftMount)
					GameTooltip:AddDoubleLine(L["BUTTONS_LEFT"]," |T"..icon_texture..":0:0:0:0|t".." "..LeftMountName);
			else
			
			local LeftMountName = Necrosis.Utils.GetItemInfo(NecrosisConfig.LeftMount);
			local icon_texture = GetItemIcon(NecrosisConfig.LeftMount)
			if LeftMountName then
					local wrapText = LeftMountName	
					--print(wrapText)
					GameTooltip:AddDoubleLine(L["BUTTONS_LEFT"]," |T"..icon_texture..":0:0:0:0|t".." "..LeftMountName);	
			end
			end		
							
		else
			
			GameTooltip:AddLine(Necrosis.TooltipData[Type].Text);
		end
-- TTip RIGHT MOUNT		
		if NecrosisConfig.RightMount then
			local RightMountName = Necrosis.Utils.GetSpellName(NecrosisConfig.RightMount)
			
			--if mount is spell
			if RightMountName then 
					local icon_texture = GetSpellTexture(NecrosisConfig.RightMount)
					GameTooltip:AddDoubleLine(L["BUTTONS_RIGHT"]," |T"..icon_texture..":0:0:0:0|t".." "..RightMountName);
			else
			
			--else the the mount is item	
			local RightMountName = Necrosis.Utils.GetItemInfo(NecrosisConfig.RightMount);
			
			local icon_texture = GetItemIcon(NecrosisConfig.RightMount)
			if RightMountName then
					local wrapText = NecrosisConfig.RightMount	
					
					GameTooltip:AddDoubleLine(L["BUTTONS_RIGHT"]," |T"..icon_texture..":0:0:0:0|t".." "..RightMountName);
			end
			end		
							
		else
			
		end			

	
	--End ToolTip Mount	
	
		
	elseif (Type == "Armor") 		then AddCastAndCost("armor")
	elseif (Type == "FelArmor") 	then AddCastAndCost("fel_armor")
	elseif (Type == "Invisible")	then AddCastAndCost("invisible")
	elseif (Type == "Aqua")			then AddCastAndCost("breath")
	elseif (Type == "Kilrogg")		then AddCastAndCost("eye")
	elseif (Type == "Banish") 		then AddCastAndCost("banish")
--		if Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["banish"]].SpellRank == 2 then
		if Necrosis.GetSpellRank("banish") == 2 then
			GameTooltip:AddLine(Necrosis.TooltipData[Type].Text) -- R click rank 1
		end
	elseif (Type == "Weakness")		then AddCastAndCost("weakness")
	elseif (Type == "Agony")		then AddCastAndCost("agony")
	elseif (Type == "Tongues")		then AddCastAndCost("tongues")
	elseif (Type == "Exhaust")		then AddCastAndCost("exhaustion")
	elseif (Type == "Elements")		then AddCastAndCost("elements")
	elseif (Type == "Doom")			then AddCastAndCost("doom")
	elseif (Type == "Corruption")	then AddCastAndCost("corruption")
	elseif (Type == "Reckless")		then AddCastAndCost("recklessness")
	elseif (Type == "TP")			then AddCastAndCost("summoning"); AddShard()
	elseif (Type == "SoulLink")		then AddCastAndCost("link")
	elseif (Type == "ShadowProtection") then AddCastAndCost("ward")
		if start2 > 0 and duration2 > 0 then
			local seconde = duration2 - ( GetTime() - start2)
			local affiche
			affiche = tostring(floor(seconde)).." sec"
			GameTooltip:AddLine("Cooldown : "..affiche)
		end
	elseif (Type == "Domination") then
		if start > 0 and duration > 0 then
			local seconde = duration - ( GetTime() - start)
			local affiche, minute, time
			if seconde <= 59 then
				affiche = tostring(floor(seconde)).." sec"
			else
				minute = tostring(floor(seconde/60))
				seconde = mod(seconde, 60)
				if seconde <= 9 then
					time = "0"..tostring(floor(seconde))
				else
					time = tostring(floor(seconde))
				end
				affiche = minute..":"..time
			end
			GameTooltip:AddLine("Cooldown : "..affiche)
		end
	elseif (Type == "Imp")			then AddCastAndCost("imp"); AddDominion(start, duration)
	elseif (Type == "Voidwalker")	then AddCastAndCost("voidwalker"); AddShard(); AddDominion(start, duration)
	elseif (Type == "Succubus")		then AddCastAndCost("succubus"); AddShard(); AddDominion(start, duration)
	elseif (Type == "Inccubus")		then AddCastAndCost("inccubus"); AddShard(); AddDominion(start, duration)
	elseif (Type == "Felhunter")	then AddCastAndCost("felhunter"); AddShard(); AddDominion(start, duration)
	elseif (Type == "felguard")		then AddCastAndCost("felguard"); AddShard(); AddDominion(start, duration)	
	elseif (Type == "Infernal")		then AddCastAndCost("inferno"); AddInfernalReagent()
	elseif (Type == "Doomguard")	then AddCastAndCost("ritual_doom"); AddDemoniacReagent()
	elseif (Type == "BuffMenu")		then AddMenuTip(Type)
	elseif (Type == "CurseMenu")	then AddMenuTip(Type)
	elseif (Type == "PetMenu")		then AddMenuTip(Type)
	elseif (Type == "DestroyShards")then AddMenuTip(Type);AddDestroyCount()
	end
	-- And hop, posting! || Et hop, affichage !
	GameTooltip:Show()
end

-- Update the sphere according to life || Update de la sphere en fonction de la vie
function Necrosis:UpdateHealth()
	local health = UnitHealth("player")
	if NecrosisConfig.Circle == 4 then
		local healthMax = UnitHealthMax("player")
		local fm = _G[Necrosis.Warlock_Buttons.main.f]
		if health == healthMax then
			if not (Local.LastSphereSkin == NecrosisConfig.NecrosisColor.."\\Shard32") then
				Local.LastSphereSkin = NecrosisConfig.NecrosisColor.."\\Shard32"
				fm:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..Local.LastSphereSkin)
			end
		else
			local taux = math.floor(health / (healthMax / 16))
			if not (Local.LastSphereSkin == NecrosisConfig.NecrosisColor.."\\Shard"..taux) then
				Local.LastSphereSkin = NecrosisConfig.NecrosisColor.."\\Shard"..taux
				fm:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..Local.LastSphereSkin)
			end
		end
	end
	-- If the inside of the stone shows life || Si l'intérieur de la pierre affiche la vie
	if NecrosisConfig.CountType == 5 then
		NecrosisShardCount:SetText(health)
	end
end

local function SetTexPerMana(f, spell, mana) -- frame and warlock spell
	if f and spell and (spell.Mana and spell.Mana > 0) then
		if spell.Mana > mana then
			if not f:GetNormalTexture():IsDesaturated() then
				f:GetNormalTexture():SetDesaturated(1)
			end
		else
			if f:GetNormalTexture():IsDesaturated() then
				f:GetNormalTexture():SetDesaturated(nil)
			end
		end
	end
end
local function SetSat(f, val) -- frame and desaturate value
	if f then
		if val == 1 then
			if not f:GetNormalTexture():IsDesaturated() then
				f:GetNormalTexture():SetDesaturated(1)
			end
		else
			if f:GetNormalTexture():IsDesaturated() then
				f:GetNormalTexture():SetDesaturated(nil)
			end
		end
	end
end
-- Update buttons according to mana || Update des boutons en fonction de la mana
function Necrosis:UpdateMana()
	if Local.Dead then return end
--	if UnitIsDead("player") then return end

	local ptype,ptype_txt = UnitPowerType("player")
	local mana = UnitPower("player",ptype)
	local manaMax = UnitPowerMax("player", ptype)

	local fm = _G[Necrosis.Warlock_Buttons.main.f]
	-- If the perimeter of the stone shows the mana || Si le pourtour de la pierre affiche la mana
	if NecrosisConfig.Circle == 3 then
		if mana == manaMax then
			if not (Local.LastSphereSkin == NecrosisConfig.NecrosisColor.."\\Shard32") then
				Local.LastSphereSkin = NecrosisConfig.NecrosisColor.."\\Shard32"
				fm:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..Local.LastSphereSkin)
			end
		else
			local taux = math.floor(mana / (manaMax / 16))
			if not (Local.LastSphereSkin == NecrosisConfig.NecrosisColor.."\\Shard"..taux) then
				Local.LastSphereSkin = NecrosisConfig.NecrosisColor.."\\Shard"..taux
				fm:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..Local.LastSphereSkin)
			end
		end
	end

	-- If the inside of the stone shows mana || Si l'intérieur de la pierre affiche la mana
	if NecrosisConfig.CountType == 4 then
		NecrosisShardCount:SetText(mana)
	end

	-- Menus - mana only
	-----------------------------------------------
	if mana then
		-- curses
		for i, v in ipairs(Necrosis.Warlock_Lists.curses) do
			local f = _G[Necrosis.Warlock_Buttons[v.f_ptr].f]
			local spell = Necrosis.GetSpell(v.high_of)
			SetTexPerMana(f, spell, mana)
		end
		-- buffs
		for i, v in ipairs(Necrosis.Warlock_Lists.buffs) do
			local f = _G[Necrosis.Warlock_Buttons[v.f_ptr].f]
			local spell = Necrosis.GetSpell(v.high_of)
			SetTexPerMana(f, spell, mana)
		end
		-- pets
		for i, v in ipairs(Necrosis.Warlock_Lists.pets) do
			
			--print (Necrosis.Warlock_Buttons[v.f_ptr],i)
			local b = Necrosis.Warlock_Buttons[v.f_ptr]
			local f = _G[b.f]
			local spell = Necrosis.GetSpell(v.high_of)
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis:UpdateMana"
.." i'"..(tostring(i or "nyl"))..'"'
.." v'"..(tostring(v.f_ptr or "nyl"))..'"'
.." pi'"..(tostring(spell.PetId or "nyl"))..'"'
.." di'"..(tostring(Local.Summon.DemonId or "nyl"))..'"'
)
--]]
			if spell and f then
				SetTexPerMana(f, spell, mana)
				
				if spell.reagent then
					if Necrosis.Warlock_Lists.reagents[spell.reagent].count <= 0 then
						SetSat(f, 1)
					end
				end
				
				if spell.NeedPet and not UnitExists("pet") then
					SetSat(f, 1)
				end			
			else
			end
		end
	end


	-- Spell interactions
	-----------------------------------------------
	-- If corrupt domination cooldown is gray || Si cooldown de domination corrompue on grise
	local usage = "domination" -- 15
	if Necrosis.IsSpellKnown(usage) then
		local f = _G[Necrosis.Warlock_Buttons[usage].f]
		
		local spell = Necrosis.GetSpell(usage)
		if f and not Local.BuffActif.Domination then
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis:UpdateMana"
.." i'"..(tostring(spell.ID))..'"'
)
--]]
			local start, duration = Necrosis.Utils.GetSpellCooldown(spell.ID, "spell")
			if start and start > 0 and duration and duration > 0 then
				SetSat(f, 1)
			else
				SetSat(f, nil)
			end
		end
	end

	-- If shadow guardian cooldown we gray || Si cooldown de gardien de l'ombre on grise
	-- removing, no idea what this is!?

	-- Timers button || Bouton des Timers
	-----------------------------------------------
	if Local.Stone.Hearth.Location[1] then
		local start, duration, enable = C_Container.GetContainerItemCooldown(Local.Stone.Hearth.Location[1], Local.Stone.Hearth.Location[2])
		local ft = _G[Necrosis.Warlock_Buttons.timer.f]
		if duration > 20 and start > 0 then
			if not Local.Stone.Hearth.Cooldown then
				ft:GetNormalTexture():SetDesaturated(1)
				Local.Stone.Hearth.Cooldown = true
			end
		else
			if Local.Stone.Hearth.Cooldown then
				ft:GetNormalTexture():SetDesaturated(nil)
				Local.Stone.Hearth.Cooldown = false
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- FUNCTIONS MANAGING STONES & SHARDS || FONCTIONS DES PIERRES ET DES FRAGMENTS
------------------------------------------------------------------------------------------------------

-- ondeplace un shard et on relance une recherche.
function Necrosis:MoveShard(nshard)
	
	
	  
		  for n in pairs(Necrosis.ShardToMove) do 

		  C_Container.PickupContainerItem(Necrosis.ShardToMove[n].FromContainer, Necrosis.ShardToMove[n].FromSlot)
	      C_Container.PickupContainerItem(Necrosis.EmptySlot[n].ToContainer, Necrosis.EmptySlot[n].ToSlot)
		  --endS
		  
		  end
		  --print("N",getN)
		--Necrosis:SoulshardSwitch()


end

-- Allows you to find / arrange shards in bags || Fonction qui permet de trouver / ranger les fragments dans les sacs
function Necrosis:SoulshardSwitch(nshard)
	
	Necrosis.ShardToMove = {}
	Necrosis.EmptySlot = {}
	ShardToMoveCount = 0
	ShardOrMoveCount = 0
	
	for container = 0, NUM_BAG_SLOTS, 1 do
		if Local.BagIsSoulPouch[container] then 
		
		end
	
		--if not (container == NecrosisConfig.SoulshardContainer) then
			for slot = 1, C_Container.GetContainerNumSlots(container), 1 do
				local itemLink = C_Container.GetContainerItemLink(container, slot)
				if (itemLink) then
					
					local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(itemLink)
					
					
					if (itemID == Necrosis.Warlock_Lists.reagents.soul_shard.id) then --Search the Shard in the bags before to search a place for each one 
						ShardOrMoveCount = ShardOrMoveCount + 1
						Necrosis.ShardToMove[ShardOrMoveCount] = {FromContainer = container, FromSlot = slot}
											
					end
				end	
			end
		--else	
		--Search slot empty, 
			for i=1,C_Container.GetContainerNumSlots(NecrosisConfig.SoulshardContainer) do
						icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = C_Container.GetContainerItemInfo(NecrosisConfig.SoulshardContainer, i)
						
							
							-- If destination bag is soulbag or not
							if not itemCount or itemID ~= 6265 then -- Search empty Slot empty to put the shard
							ShardToMoveCount = ShardToMoveCount + 1 
							Necrosis.EmptySlot[ShardToMoveCount] = {ToContainer = NecrosisConfig.SoulshardContainer, ToSlot = i}
							
							end
												
			end	
					if Necrosis.Debug.bags then
										_G["DEFAULT_CHAT_FRAME"]:AddMessage("SoulshardSwitch shard found"
										.." t'"..(Type or "nyl")..'"'
										.." m'"..(Local.Soulshard.Move or "nyl")..'"'
										)
					end
			--end
		end

	 
	 Necrosis:MoveShard()

end




-- Explore bags for stones & shards || Fonction qui fait l'inventaire des éléments utilisés en démonologie : Pierres, Fragments, Composants d'invocation
function Necrosis:BagExplore(arg)
	--[[
	This routine will not do well without bag names.
	The bag update event seems to happen a couple times during login / reload so if names are not known they
	should be before the player UI is fully ready.
	--]]
	if BagNamesKnown() then
		-- proceed
	else
		return -- 
	end

	for container = 0, NUM_BAG_SLOTS, 1 do
		local name, id = NU.GetBagName(container)
		if Necrosis.IsSoulPouch(name) then
			Local.BagIsSoulPouch[container] = true
			if Necrosis.Debug.bags then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("BagExplore soul bag found"
				.." n'"..(name or "nyl")..'"'
				.." c'"..(container or "nyl")..'"'
				)
			end
		else
			Local.BagIsSoulPouch[container] = false
		end
	end
	local AncienCompte = Local.Soulshard.Count

	local bag_start = 0
	local bag_end = 0
	
	if arg then -- look at this bag only
		if Local.Stone.Soul.OnHand == arg then Local.Stone.Soul.OnHand = nil end
		if Local.Stone.Health.OnHand == arg then Local.Stone.Health.OnHand = nil end
		if Local.Stone.Fire.OnHand == arg then Local.Stone.Fire.OnHand = nil end
		if Local.Stone.Spell.OnHand == arg then Local.Stone.Spell.OnHand = nil end
		if Local.Stone.Hearth.OnHand == arg then Local.Stone.Hearth.OnHand = nil end
		
		bag_start = arg
		bag_end = arg
	else
		Local.Stone.Soul.OnHand = nil
		Local.Stone.Health.OnHand = nil
		Local.Stone.Fire.OnHand = nil
		Local.Stone.Spell.OnHand = nil
		Local.Stone.Hearth.OnHand = nil

		bag_start = 0
		bag_end = NUM_BAG_SLOTS
	end

	-- search bag(s)
	for container = bag_start, bag_end, 1 do
		if Local.BagIsSoulPouch[container] then 
			-- Exit if its a known soul bag (which can only store shards) || Parcours des emplacements des sacs
			break 
		end

		for slot=1, C_Container.GetContainerNumSlots(container), 1 do
			local item_link = C_Container.GetContainerItemLink(container, slot)
			local item_id = Necrosis.Utils.ParseItemLink(item_link) --GetContainerItemLink(container, slot))
			
			item_id = tonumber(item_id)
			local itemName = itemString
						
			--print (item_id)
--[[
			if Necrosis.Debug.bags then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis:BagExplore"
				.." a'"..(tostring(arg) or "nyl").."'"
				.." bs'"..(tostring(bag_start) or "nyl").."'"
				.." be'"..(tostring(bag_end) or "nyl").."'"
				)
			end
--]]
		
			-- If there is an item located in that bag slot || Dans le cas d'un emplacement non vide
			if item_id then
				--print (item_id,item_link)
				-- Check if its a soulstone || Si c'est une pierre d'âme, on note son existence et son emplacement
				if Necrosis.IsSoulStone(item_id) then
					if Necrosis.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "nyl").."'"
						.." c'"..(tostring(container) or "nyl").."'"
						.." s'"..(tostring(slot) or "nyl").."'"
						.." name'"..(tostring(itemName) or "nyl").."'"
						)
					end
					Local.Stone.Soul.OnHand = container
					Local.Stone.Soul.Location = {container,slot}
					NecrosisConfig.ItemSwitchCombat[4] = itemName
					
					-- Update its button attributes on the sphere || On attache des actions au bouton de la pierre
					
					Necrosis:SoulstoneUpdateAttribute() -- done in UpdateIcons
				-- Check if its a healthstone || Même chose pour une pierre de soin
				elseif Necrosis.IsHealthStone(item_id) then
					if Necrosis.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "nyl").."'"
						.." c'"..(tostring(container) or "nyl").."'"
						.." s'"..(tostring(slot) or "nyl").."'"
						.." n'"..(tostring(itemName) or "nyl").."'"
						)
					end
					Local.Stone.Health.OnHand = container
					Local.Stone.Health.Location = {container,slot}
					NecrosisConfig.ItemSwitchCombat[3] = itemName
					-- Update its button attributes on the sphere || On attache des actions au bouton de la pierre
					Necrosis:HealthstoneUpdateAttribute()
				-- Check if its a spellstone || Et encore pour la pierre de sort
				elseif Necrosis.IsSpellStone(item_id) then
					if Necrosis.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "nyl").."'"
						.." c'"..(tostring(container) or "nyl").."'"
						.." s'"..(tostring(slot) or "nyl").."'"
						.." n'"..(tostring(itemName) or "nyl").."'"
						)
					end
					Local.Stone.Spell.OnHand = container
					Local.Stone.Spell.Location = {container,slot}
					NecrosisConfig.ItemSwitchCombat[1] = itemName
					-- Update its button attributes on the sphere || On attache des actions au bouton de la pierre
					Necrosis:SpellstoneUpdateAttribute()
				-- Check if its a firestone || La pierre de feu maintenant
				elseif Necrosis.IsFireStone(item_id) then
					if Necrosis.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "nyl").."'"
						.." c'"..(tostring(container) or "nyl").."'"
						.." s'"..(tostring(slot) or "nyl").."'"
						.." n'"..(tostring(itemName) or "nyl").."'"
						)
					end
					Local.Stone.Fire.OnHand = container
					NecrosisConfig.ItemSwitchCombat[2] = itemName
					-- Update its button attributes on the sphere || On attache des actions au bouton de la pierre
					Necrosis:FirestoneUpdateAttribute()
				-- Check if its a hearthstone || et enfin la pierre de foyer
				elseif Necrosis.IsHearthStone(item_id) then
					if Necrosis.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "nyl").."'"
						.." c'"..(tostring(container) or "nyl").."'"
						.." s'"..(tostring(slot) or "nyl").."'"
						.." n'"..(tostring(itemName) or "nyl").."'"
						)
					end
					Local.Stone.Hearth.OnHand = container
					Local.Stone.Hearth.Location = {container,slot}
				end
			end
		end
	end

	-- Update stone / reagent counters
	
	
	--if version est cata then
	if select(4, GetBuildInfo()) < 40400 then
		Local.Soulshard.Count = GetItemCount(Necrosis.Warlock_Lists.reagents.soul_shard.id)
	--sinon
	else	
	Local.Soulshard.Count = UnitPower("player", Enum.PowerType.SoulShards)
	
	--fin
	end
	
	Necrosis.Warlock_Lists.reagents.soul_shard.count = GetItemCount(Necrosis.Warlock_Lists.reagents.soul_shard.id)
	


				Local.Reagent.Infernal = GetItemCount(Necrosis.Warlock_Lists.reagents.infernal_stone.id)
				Necrosis.Warlock_Lists.reagents.infernal_stone.count = GetItemCount(Necrosis.Warlock_Lists.reagents.infernal_stone.id)
	Local.Reagent.Demoniac = GetItemCount(Necrosis.Warlock_Lists.reagents.demonic_figurine.id)
				Necrosis.Warlock_Lists.reagents.demonic_figurine.count = GetItemCount(Necrosis.Warlock_Lists.reagents.demonic_figurine.id)
	-- Destroy extra shards (if enabled) || Si il y a un nombre maximum de fragments à conserver, on enlève les supplémentaires

	local f = _G[Necrosis.Warlock_Buttons.main.f]
	-- Update the main (sphere) button display || Affichage du bouton principal de Necrosis
	if NecrosisConfig.Circle == 1 then
		if (Local.Soulshard.Count <= 32) then
			if not (Local.LastSphereSkin == NecrosisConfig.NecrosisColor.."\\Shard"..Local.Soulshard.Count) then
				Local.LastSphereSkin = NecrosisConfig.NecrosisColor.."\\Shard"..Local.Soulshard.Count
				f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..Local.LastSphereSkin)
			end
		elseif not (Local.LastSphereSkin == NecrosisConfig.NecrosisColor.."\\Shard32") then
			Local.LastSphereSkin = NecrosisConfig.NecrosisColor.."\\Shard32"
			f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..Local.LastSphereSkin)
		end
	elseif NecrosisConfig.Circle == 2 and (Local.Stone.Soul.Mode == 1 or Local.Stone.Soul.Mode == 2) then
		if (Local.Soulshard.Count <= 32) then
			if not (Local.LastSphereSkin == NecrosisConfig.NecrosisColor:gsub("Turquoise", "Bleu"):gsub("Rose", "Bleu"):gsub("Orange", "Bleu").."\\Shard"..Local.Soulshard.Count) then
				Local.LastSphereSkin = NecrosisConfig.NecrosisColor:gsub("Turquoise", "Bleu"):gsub("Rose", "Bleu"):gsub("Orange", "Bleu").."\\Shard"..Local.Soulshard.Count
				f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..Local.LastSphereSkin)
			end
		elseif not (Local.LastSphereSkin == NecrosisConfig.NecrosisColor:gsub("Turquoise", "Bleu"):gsub("Rose", "Bleu"):gsub("Orange", "Bleu").."\\Shard32") then
			Local.LastSphereSkin = NecrosisConfig.NecrosisColor:gsub("Turquoise", "Bleu"):gsub("Rose", "Bleu"):gsub("Orange", "Bleu").."\\Shard32"
			f:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\"..Local.LastSphereSkin)
		end
	end
	if NecrosisConfig.ShowCount then
		if NecrosisConfig.CountType == 2 then
			NecrosisShardCount:SetText(Local.Reagent.Infernal.." / "..Local.Reagent.Demoniac)
		elseif NecrosisConfig.CountType == 1 then
			if Local.Soulshard.Count < 10 then
				--NecrosisShardCount:SetText("0"..Local.Soulshard.Count)
				NecrosisShardCount:SetText(Local.Soulshard.Count.."/"..NecrosisConfig.DestroyCount)
			else
				NecrosisShardCount:SetText(Local.Soulshard.Count.."/"..NecrosisConfig.DestroyCount)
			end
		end
	else
		NecrosisShardCount:SetText("")
	end
	-- Update icons and we're done || Et on met le tout à jour !
	UpdateIcons()

	-- If bags are full (or if we have reached the limit) then display a notification message || S'il y a plus de fragment que d'emplacements dans le sac défini, on affiche un message d'avertissement
	if NecrosisConfig.SoulshardSort then
		local CompteMax = C_Container.GetContainerNumSlots(NecrosisConfig.SoulshardContainer)
		if Necrosis.Debug.bags then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("BagExplore shard sort"
			.." c'"..(NecrosisConfig.SoulshardContainer or "nyl")..'"'
			.." #'"..(CompteMax or "nyl")..'"'
			)
		end
		if Local.Soulshard.Count > AncienCompte and Local.Soulshard.Count == CompteMax then
			if (NecrosisConfig.SoulshardDestroy) then
				Necrosis:Msg(Necrosis.ChatMessage.Bag.FullPrefix
					..NU.GetBagName(NecrosisConfig.SoulshardContainer)
					..Necrosis.ChatMessage.Bag.FullDestroySuffix
					, "USER")
			else
				Necrosis:Msg(Necrosis.ChatMessage.Bag.FullPrefix
					..NU.GetBagName(NecrosisConfig.SoulshardContainer)
					..Necrosis.ChatMessage.Bag.FullSuffix
					, "USER")
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- VARIOUS FUNCTIONS || FONCTIONS DES SORTS
------------------------------------------------------------------------------------------------------

-- Display or Hide buttons depending on spell availability || Affiche ou masque les boutons de sort à chaque nouveau sort appris
function Necrosis:ButtonSetup()
	local NBRScale, rayondebase ,rayon , dist
	
-- (Min)50 to 100 
if  NecrosisConfig.NecrosisButtonScale <= 100 then

		NBRScale = 1.1
		dist = 40 * NBRScale
end	
--  100 to 150
if NecrosisConfig.NecrosisButtonScale < 150 and NecrosisConfig.NecrosisButtonScale > 100 then
		 NBRScale = (100 + (NecrosisConfig.NecrosisButtonScale - 85)) / 100
		 rayondebase = 8
		 rayon = rayondebase * (NecrosisConfig.NecrosisButtonScale/100)
		 dist = 35 * NBRScale * 0.85
		dist = dist - ((rayon-rayondebase)) 
end

-- 160 to 200 (max)		
if NecrosisConfig.NecrosisButtonScale >= 150 then
		 NBRScale = (100 + (NecrosisConfig.NecrosisButtonScale - 85)) / 100
		 rayondebase = 13
		 rayon = rayondebase * (NecrosisConfig.NecrosisButtonScale/100)
		 dist = 35 * NBRScale * 0.85
		dist = dist - ((rayon-rayondebase))
end
	


		
	
	--print (dist,NBRScale,NecrosisConfig.NecrosisButtonScale)

---[==[
	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("ButtonSetup === Begin"
		)
	end
	
	local fm = Necrosis.Warlock_Buttons.main.f
	local indexScale = - 36
	
	for index=1, #Necrosis.Warlock_Lists.on_sphere, 1 do
		local v = Necrosis.Warlock_Lists.on_sphere[index]
		local fr = Necrosis.Warlock_Buttons[v.f_ptr].f
		
		
		if Necrosis.Debug.buttons then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("ButtonSetup"
			.." '"..tostring(fr)
			)
		end
		local f = _G[fr]
		local sp = NecrosisConfig.StonePosition[index]

		--if (GetSpellInfo(GetSpellInfo(v.high_of))
		
		if (Necrosis.IsSpellKnown(v.high_of) 	-- in spell book
			or v.menu                           	-- or on menu of spells
			or v.item)                           	-- or item to use
			and (sp and sp > 0) 					-- and requested
		then
		
			if not f then
				f = Necrosis:CreateSphereButtons(Necrosis.Warlock_Buttons[v.f_ptr])

				Necrosis:StoneAttribute(Local.Summon.SteedAvailable)
			end
					
			f:ClearAllPoints()
---[[
			if NecrosisConfig.NecrosisLockServ then
				f:SetPoint(
					"CENTER", fm, "CENTER",
					((dist) * cos(NecrosisConfig.NecrosisAngle - indexScale)),-- Offset X
					((dist) * sin(NecrosisConfig.NecrosisAngle - indexScale)) -- Offset Y
				)
				indexScale = indexScale + 36
			else
--]]
				f:SetPoint(
					NecrosisConfig.FramePosition[fr][1],
					NecrosisConfig.FramePosition[fr][2],
					NecrosisConfig.FramePosition[fr][3],
					NecrosisConfig.FramePosition[fr][4],
					NecrosisConfig.FramePosition[fr][5]
				)
			end
			f:Show()
			f:SetScale(NBRScale)
		else
			if f then
				f:Hide()
			end
		end
	end
	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("ButtonSetup === Done"
		)
	end
--]==]
end

------------------------------------------------------------------------------------------------------
-- MISCELLANEOUS FUNCTIONS || FONCTIONS DIVERSES
------------------------------------------------------------------------------------------------------

-- Trade healthstone (out of combat) || Fonction pour gérer l'échange de pierre (hors combat)
function Necrosis:TradeStone()
		-- If a friendly target is selected then trade the stone || Dans ce cas si un pj allié est sélectionné, on lui donne la pierre
		-- Else use it || Sinon, on l'utilise
		if Local.Trade.Request and Local.Stone.Health.OnHand and not Local.Trade.Complete then
			C_Container.PickupContainerItem(Local.Stone.Health.Location[1], Local.Stone.Health.Location[2])
			ClickTradeButton(1)
			Local.Trade.Complete = true
			return
		elseif UnitExists("target") and UnitIsPlayer("target")
		and not (UnitCanAttack("player", "target") or UnitName("target") == UnitName("player")) then
				C_Container.PickupContainerItem(Local.Stone.Health.Location[1], Local.Stone.Health.Location[2])
				if CursorHasItem() then
					DropItemOnUnit("target")
					Local.Trade.Complete = true
				end
				return
		end
end

local function ClearAll(f)
	if f then f:ClearAllPoints() end
end
-- Function (XML) to restore the default attachment points of the buttons || Fonction (XML) pour rétablir les points d'attache par défaut des boutons
function Necrosis:ClearAllPoints()
	ClearAll(_G[Necrosis.Warlock_Buttons.fire_stone.f])
	ClearAll(_G[Necrosis.Warlock_Buttons.spell_stone.f])
	ClearAll(_G[Necrosis.Warlock_Buttons.health_stone.f])
	ClearAll(_G[Necrosis.Warlock_Buttons.soul_stone.f])
	ClearAll(_G[Necrosis.Warlock_Buttons.mounts.f])
	ClearAll(_G[Necrosis.Warlock_Buttons.pets.f])
	ClearAll(_G[Necrosis.Warlock_Buttons.buffs.f])
	ClearAll(_G[Necrosis.Warlock_Buttons.curses.f])
end

local function SetDrag(f, val)
	if f then f:RegisterForDrag(val) end
end
-- Disable drag functionality || Fonction (XML) pour étendre la propriété NoDrag() du bouton principal de Necrosis sur tout ses boutons
function Necrosis:NoDrag()
	local val = ""

	SetDrag(_G[Necrosis.Warlock_Buttons.fire_stone.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.spell_stone.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.health_stone.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.soul_stone.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.mounts.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.pets.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.buffs.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.curses.f], val)
end

-- Enable drag functionality || Fonction (XML) inverse de celle du dessus
function Necrosis:Drag()
	local val = "LeftButton"

	SetDrag(_G[Necrosis.Warlock_Buttons.fire_stone.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.spell_stone.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.health_stone.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.soul_stone.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.mounts.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.pets.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.buffs.f], val)
	SetDrag(_G[Necrosis.Warlock_Buttons.curses.f], val)
end

local function SetState(f, state)
	if f then f:SetAttribute("state", state) end
end
local function HideList(list, parent)
	for i, v in pairs(list) do
		menuVariable = _G[Necrosis.Warlock_Buttons[v.f_ptr].f]
		if menuVariable then
			menuVariable:Hide()
			menuVariable:ClearAllPoints()
			menuVariable:SetPoint("CENTER", parent, "CENTER", 3000, 3000)
		end
	end
end
-- Rebuild the menus at mod startup or when the spellbook changes || A chaque changement du livre des sorts, au démarrage du mod, ainsi qu'au changement de sens du menu on reconstruit les menus des sorts
function Necrosis:CreateMenu()
	Local.Menu.Pet = setmetatable({}, metatable)
	Local.Menu.Curse = setmetatable({}, metatable)
	Local.Menu.Buff = setmetatable({}, metatable)
	local menuVariable = nil
	local PetButtonPosition = "Button"
	local BuffButtonPosition = "Button"
	local CurseButtonPosition = "Button"

	local f = Necrosis.Warlock_Buttons.main.f
	HideList(Necrosis.Warlock_Lists.pets, f) -- Hide all the pet demon buttons || On cache toutes les icones des démons
	HideList(Necrosis.Warlock_Lists.buffs, f) -- Hide the general buff spell buttons || On cache toutes les icones des sorts
	HideList(Necrosis.Warlock_Lists.curses, f) -- Hide the curse buttons || On cache toutes les icones des curses

	if NecrosisConfig.StonePosition[7] > 0 then -- pets
		-- Setup the buttons available on the pets menu 
		local prior_button = Necrosis.Warlock_Buttons.pets.f -- menu button on sphere
		-- Create on demand 
		if not _G[prior_button] then
			_ = Necrosis:CreateSphereButtons(Necrosis.Warlock_Buttons.pets)
		end

		for index = 1, #Necrosis.Warlock_Lists.pets, 1 do
		
			if NecrosisConfig.PetShow[index] == true 		then
				show = NecrosisConfig.PetShow[index]
			elseif NecrosisConfig.PetShow[index] == false 	then
				show = NecrosisConfig.PetShow[index]
			elseif not NecrosisConfig.PetShow[index] 			then
				show = true
			else 
			
			end
		--print (show,NecrosisConfig.PetShow[index],#Necrosis.Warlock_Lists.pets)
		if  show  == true then
		
			local v = Necrosis.Warlock_Lists.pets[index]
			local f = Necrosis.Warlock_Buttons[v.f_ptr].f
			--print (v,f)					
			if Necrosis.IsSpellKnown(v.high_of) or v.f_ptr == "sacrifice"  -- in spell book or sacrifice
--			

			--and NecrosisConfig.DemonSpellPosition[index] > 0 -- and requested
			
			then
			
				if Necrosis.Debug.buttons then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenu pets"
					.." f'"..(v.f_ptr or "nyl")..'"'
--					.." p'"..(NecrosisConfig.DemonSpellPosition[index] or "nyl")..'"'
					.." pr'"..(prior_button or "nyl")..'"'
					)
				end
				menuVariable = Necrosis:CreateMenuItem(v) -- Necrosis:CreateMenuPet(v.f_ptr)
				menuVariable:ClearAllPoints()
				menuVariable:SetPoint(
					"CENTER", prior_button, "CENTER",
					NecrosisConfig.PetMenuPos.direction * NecrosisConfig.PetMenuPos.x * 32,
					NecrosisConfig.PetMenuPos.y * 32
				)
				prior_button = f -- anchor the next button
				Local.Menu.Pet:insert(menuVariable)
			end
		end
		end
		-- Display the pets menu button || Maintenant que tous les boutons de pet sont placés les uns à côté des autres, on affiche les disponibles
		if Local.Menu.Pet[1] then
			local f = _G[Necrosis.Warlock_Buttons.pets.f]
			local fs = Necrosis.Warlock_Buttons.pets.f
			Local.Menu.Pet[1]:ClearAllPoints()
			Local.Menu.Pet[1]:SetPoint(
				"CENTER", f, "CENTER",
				NecrosisConfig.PetMenuPos.direction * NecrosisConfig.PetMenuPos.x * 32 + NecrosisConfig.PetMenuDecalage.x,
				NecrosisConfig.PetMenuPos.y * 32 + NecrosisConfig.PetMenuDecalage.y
			)
			-- Secure the menu || Maintenant on sécurise le menu, et on y associe nos nouveaux boutons
			for i = 1, #Local.Menu.Pet, 1 do
				Local.Menu.Pet[i]:SetParent(f)
				-- Close the menu when a child button is clicked || Si le menu se ferme à l'appui d'un bouton, alors il se ferme à l'appui d'un bouton !
				f:WrapScript(Local.Menu.Pet[i], "OnClick", [[
					if self:GetParent():GetAttribute("state") == "Ouvert" then
						self:GetParent():SetAttribute("state", "Ferme")
					end
				]])
				f:WrapScript(Local.Menu.Pet[i], "OnEnter", [[
					self:GetParent():SetAttribute("mousehere", true)
				]])
				f:WrapScript(Local.Menu.Pet[i], "OnLeave", [[
					self:GetParent():SetAttribute("mousehere", false)
					local stateMenu = self:GetParent():GetAttribute("state")
					if not (stateMenu == "Bloque" or stateMenu == "Combat" or stateMenu == "ClicDroit") then
						self:GetParent():SetAttribute("state", "Refresh")
					end
				]])
				if NecrosisConfig.BlockedMenu or not NecrosisConfig.ClosingMenu then
					f:UnwrapScript(Local.Menu.Pet[i], "OnClick")
				end
--				Necrosis:SetPetSpellAttribute(Local.Menu.Pet[i])
			end
			Necrosis:MenuAttribute(fs)
			Necrosis:PetSpellAttribute()
		end
	end

	if NecrosisConfig.StonePosition[5] > 0 then -- buffs
		-- Setup the buttons available on the buffs menu || On ordonne et on affiche les boutons dans le menu des buffs
		local prior_button = Necrosis.Warlock_Buttons.buffs.f -- menu button on sphere
		-- Create on demand || Création à la demande du bouton du menu des Buffs
		if not _G[prior_button] then
			_ = Necrosis:CreateSphereButtons(Necrosis.Warlock_Buttons.buffs)
		end

		for index = 1, #Necrosis.Warlock_Lists.buffs, 1 do
			local v = Necrosis.Warlock_Lists.buffs[index]
			local f = Necrosis.Warlock_Buttons[v.f_ptr].f
			if Necrosis.IsSpellKnown(v.high_of) -- in spell book
--			and NecrosisConfig.BuffSpellPosition[index] > 0 -- and requested
			then
				menuVariable = Necrosis:CreateMenuItem(v) -- Necrosis:CreateMenuBuff(v.f_ptr)
				menuVariable:ClearAllPoints()
				menuVariable:SetPoint(
					"CENTER", prior_button, "CENTER",
					NecrosisConfig.BuffMenuPos.direction * NecrosisConfig.BuffMenuPos.x * 32,
					NecrosisConfig.BuffMenuPos.y * 32
				)
				prior_button = f -- anchor the next button
				Local.Menu.Buff:insert(menuVariable)
			end
		end

		-- Display the buffs menu button on the sphere || Maintenant que tous les boutons de buff sont placés les uns à côté des autres, on affiche les disponibles
		if Local.Menu.Buff[1] then
			local fs = Necrosis.Warlock_Buttons.buffs.f
			local f = _G[fs]
			Local.Menu.Buff[1]:ClearAllPoints()
			Local.Menu.Buff[1]:SetPoint(
				"CENTER", f, "CENTER",
				NecrosisConfig.BuffMenuPos.direction * NecrosisConfig.BuffMenuPos.x * 32 + NecrosisConfig.BuffMenuDecalage.x,
				NecrosisConfig.BuffMenuPos.y * 32 + NecrosisConfig.BuffMenuDecalage.y
			)
			-- Secure the menu || Maintenant on sécurise le menu, et on y associe nos nouveaux boutons
			for i = 1, #Local.Menu.Buff, 1 do
				Local.Menu.Buff[i]:SetParent(f)
				-- Close the menu upon button Click || Si le menu se ferme à l'appui d'un bouton, alors il se ferme à l'appui d'un bouton !
				f:WrapScript(Local.Menu.Buff[i], "OnClick", [[
					if self:GetParent():GetAttribute("state") == "Ouvert" then
						self:GetParent():SetAttribute("state", "Ferme")
					end
				]])
				f:WrapScript(Local.Menu.Buff[i], "OnEnter", [[
					self:GetParent():SetAttribute("mousehere", true)
				]])
				f:WrapScript(Local.Menu.Buff[i], "OnLeave", [[
					self:GetParent():SetAttribute("mousehere", false)
					local stateMenu = self:GetParent():GetAttribute("state")
					if not (stateMenu == "Bloque" or stateMenu == "Combat" or stateMenu == "ClicDroit") then
						self:GetParent():SetAttribute("state", "Refresh")
					end
				]])
				if NecrosisConfig.BlockedMenu or not NecrosisConfig.ClosingMenu then
					f:UnwrapScript(Local.Menu.Buff[i], "OnClick")
				end
			end
			Necrosis:MenuAttribute(fs)
			Necrosis:BuffSpellAttribute()
		end
	end

	if NecrosisConfig.StonePosition[8] > 0 then -- curses
		-- Setup the buttons available on the curses menu 
		local prior_button = Necrosis.Warlock_Buttons.curses.f -- menu button on sphere
		-- Create on demand 
		if not _G[prior_button] then
			_ = Necrosis:CreateSphereButtons(Necrosis.Warlock_Buttons.curses)
		end

		for index = 1, #Necrosis.Warlock_Lists.curses, 1 do
			
			if NecrosisConfig.CurseShow[index] and NecrosisConfig.CurseShow[index] == true 		then
				show = NecrosisConfig.CurseShow[index]
			elseif NecrosisConfig.CurseShow[index] == false 	then
				show = NecrosisConfig.CurseShow[index]
			elseif not NecrosisConfig.CurseShow[index] 			then
				show = true
			else 
			
			end
			
			
			if  show  == true then
			local v = Necrosis.Warlock_Lists.curses[index]
			local f = Necrosis.Warlock_Buttons[v.f_ptr].f
			if Necrosis.IsSpellKnown(v.high_of) -- in spell book
--			and NecrosisConfig.DemonSpellPosition[index] > 0 -- and requested
			then
				menuVariable = Necrosis:CreateMenuItem(v)   -- Necrosis:CreateMenuCurse(v.f_ptr)
				menuVariable:ClearAllPoints()
				menuVariable:SetPoint(
					"CENTER", prior_button, "CENTER",
					NecrosisConfig.CurseMenuPos.direction * NecrosisConfig.CurseMenuPos.x * 32,
					NecrosisConfig.CurseMenuPos.y * 32
				)
--				menuVariable.high_of = v.high_of
				prior_button = f -- anchor the next button
				Local.Menu.Curse:insert(menuVariable)
			end
			end
		end
		-- Display the curse menu button on the sphere || Maintenant que tous les boutons de curse sont placés les uns à côté des autres, on affiche les disponibles
		if Local.Menu.Curse[1] then
			local f = _G[Necrosis.Warlock_Buttons.curses.f]
			local fs = Necrosis.Warlock_Buttons.curses.f
			Local.Menu.Curse[1]:ClearAllPoints()
			Local.Menu.Curse[1]:SetPoint(
				"CENTER", f, "CENTER",
				NecrosisConfig.CurseMenuPos.direction * NecrosisConfig.CurseMenuPos.x * 32 + NecrosisConfig.CurseMenuDecalage.x,
				NecrosisConfig.CurseMenuPos.y * 32 + NecrosisConfig.CurseMenuDecalage.y
			)
			-- Secure the menu || Maintenant on sécurise le menu, et on y associe nos nouveaux boutons
			for i = 1, #Local.Menu.Curse, 1 do
				Local.Menu.Curse[i]:SetParent(f)
				-- Respond to clicks || Si le menu se ferme à l'appui d'un bouton, alors il se ferme à l'appui d'un bouton !
				f:WrapScript(Local.Menu.Curse[i], "OnClick", [[
					if self:GetParent():GetAttribute("state") == "Ouvert" then
						self:GetParent():SetAttribute("state","Ferme")
					end
				]])
				f:WrapScript(Local.Menu.Curse[i], "OnEnter", [[
					self:GetParent():SetAttribute("mousehere", true)
				]])
				f:WrapScript(Local.Menu.Curse[i], "OnLeave", [[
					self:GetParent():SetAttribute("mousehere", false)
					local stateMenu = self:GetParent():GetAttribute("state")
					if not (stateMenu == "Bloque" or stateMenu == "Combat" or stateMenu == "ClicDroit") then
						self:GetParent():SetAttribute("state", "Refresh")
					end
				]])
				if NecrosisConfig.BlockedMenu or not NecrosisConfig.ClosingMenu then
					f:UnwrapScript(Local.Menu.Curse[i], "OnClick")
				end
			end
			Necrosis:MenuAttribute(fs)
			Necrosis:CurseSpellAttribute()
		end
	end

	-- Always keep menus Open (if enabled) || On bloque le menu en position ouverte si configuré
	if NecrosisConfig.BlockedMenu then
		local s = "Bloque"
		SetState(_G[Necrosis.Warlock_Buttons.buffs.f], s)
		SetState(_G[Necrosis.Warlock_Buttons.pets.f], s)
		SetState(_G[Necrosis.Warlock_Buttons.curses.f], s)
	end
end

-- Reset Necrosis to default position || Fonction pour ramener tout au centre de l'écran
function Necrosis:Recall()
	for i,v in pairs(Necrosis.Warlock_Lists.recall) do
		local f = _G[Necrosis.Warlock_Buttons[v.f_ptr].f]
		f:ClearAllPoints()
		f:SetPoint("CENTER", "UIParent", "CENTER", v.x, v.y)
		if v.show then
			f:Show()
		else
			f:Hide()
		end
		Necrosis:OnDragStop(f)
	end
end
function Necrosis:Redraw()
	for i,v in pairs(Necrosis.Warlock_Lists.recall) do
		local f = _G[Necrosis.Warlock_Buttons[v.f_ptr].f]
		
		if v.show then
			f:Show()
		else
			f:Hide()
		end
		Necrosis:OnDragStop(f)
	end
end


function Necrosis:SetOfxy(menu)
	local fb = _G[Necrosis.Warlock_Buttons.buffs.f]
	local fp = _G[Necrosis.Warlock_Buttons.pets.f]
	local fc = _G[Necrosis.Warlock_Buttons.curses.f]
	if menu == "Buff" and Local.Menu.Buff[1] and fb then
		Local.Menu.Buff[1]:ClearAllPoints()
		Local.Menu.Buff[1]:SetPoint(
			"CENTER", fb, "CENTER",
			NecrosisConfig.BuffMenuPos.direction * NecrosisConfig.BuffMenuPos.x * 32 + NecrosisConfig.BuffMenuDecalage.x,
			NecrosisConfig.BuffMenuPos.y * 32 + NecrosisConfig.BuffMenuDecalage.y
		)
	elseif menu == "Pet" and fp then
		Local.Menu.Pet[1]:ClearAllPoints()
		Local.Menu.Pet[1]:SetPoint(
			"CENTER", fp, "CENTER",
			NecrosisConfig.PetMenuPos.direction * NecrosisConfig.PetMenuPos.x * 32 + NecrosisConfig.PetMenuDecalage.x,
			NecrosisConfig.PetMenuPos.y * 32 + NecrosisConfig.PetMenuDecalage.y
		)
	elseif menu == "Curse" and Local.Menu.Curse[1] and fc then
		Local.Menu.Curse[1]:ClearAllPoints()
		Local.Menu.Curse[1]:SetPoint(
			"CENTER", fc, "CENTER",
			NecrosisConfig.CurseMenuPos.direction * NecrosisConfig.CurseMenuPos.x * 32 + NecrosisConfig.CurseMenuDecalage.x,
			NecrosisConfig.CurseMenuPos.y * 32 + NecrosisConfig.CurseMenuDecalage.y
		)
	end
end

-- This function fixes a problem with the Blizzard API "GetCompanionInfo", which will return a different name for some mounts in the game.
-- Example: the bronze drake (spell 59569)
--      -> GetCompanionInfo will return this as "Bronze Drake Mount" (wrong)
--      -> GetSpellInfo will return this as "Bronze Drake" (correct)
function Necrosis:GetCompanionInfo(type, id)
	local creatureID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo(type, id)

	if creatureSpellID then
		-- Get the correct (localised) name
		creatureName = GetSpellInfo(creatureSpellID)
	end

	--print (creatureID, creatureName, creatureSpellID, icon, issummoned)
	return creatureID, creatureName, creatureSpellID, icon, issummoned
end

-- Display the timers on the left or right || Fonction permettant le renversement des timers sur la gauche / la droite
function Necrosis:SymetrieTimer(bool)
	local num
	if bool then
		NecrosisConfig.SpellTimerPos = -1
		NecrosisConfig.SpellTimerJust = "RIGHT"
		num = 1
		while _G["NecrosisTimerFrame"..num.."OutText"] do
			_G["NecrosisTimerFrame"..num.."OutText"]:ClearAllPoints()
			_G["NecrosisTimerFrame"..num.."OutText"]:SetPoint(
				"RIGHT",
				_G["NecrosisTimerFrame"..num],
				"LEFT",
				-5, 1
			)
			_G["NecrosisTimerFrame"..num.."OutText"]:SetJustifyH("RIGHT")
			num = num + 1
		end
	else
		NecrosisConfig.SpellTimerPos = 1
		NecrosisConfig.SpellTimerJust = "LEFT"
		num = 1
		while _G["NecrosisTimerFrame"..num.."OutText"] do
			_G["NecrosisTimerFrame"..num.."OutText"]:ClearAllPoints()
			_G["NecrosisTimerFrame"..num.."OutText"]:SetPoint(
				"LEFT",
				_G["NecrosisTimerFrame"..num],
				"RIGHT",
				5, 1
			)
			_G["NecrosisTimerFrame"..num.."OutText"]:SetJustifyH("LEFT")
			num = num + 1
		end
	end

	local ft = _G[Necrosis.Warlock_Buttons.timer.f]
	if _G["NecrosisTimerFrame0"] then
		NecrosisTimerFrame0:ClearAllPoints()
		NecrosisTimerFrame0:SetPoint(
			NecrosisConfig.SpellTimerJust,
			ft,
			"CENTER",
			NecrosisConfig.SpellTimerPos * 20, 0
		)
	end
	if _G["NecrosisListSpells"] then
		NecrosisListSpells:ClearAllPoints()
		NecrosisListSpells:SetJustifyH(NecrosisConfig.SpellTimerJust)
		NecrosisListSpells:SetPoint(
			"TOP"..NecrosisConfig.SpellTimerJust,
			ft,
			"CENTER",
			NecrosisConfig.SpellTimerPos * 23, 10
		)
	end
end
--TBC Add : Delete shards out of stock
function Necrosis:DeleteShards()
    ev_out(event, "DeleteShards() called", false, true, false)
    	
	if NecrosisConfig.DestroyShard then
        Local.Soulshard.Count = GetItemCount(Necrosis.Warlock_Lists.reagents.soul_shard.id)
        local RemainingShardsToDelete = Local.Soulshard.Count - NecrosisConfig.DestroyCount
        for container = 0, NUM_BAG_SLOTS, 1 do
            if Local.BagIsSoulPouch[container] then break end
            for slot=1, C_Container.GetContainerNumSlots(container), 1 do
                if math.floor(NecrosisConfig.DestroyCount) >= Local.Soulshard.Count then break end
                local itemLink = C_Container.GetContainerItemLink(container, slot)
                if (itemLink) then
                    local itemID, itemName = Necrosis.Utils.ParseItemLink(itemLink) --GetContainerItemLink(container, slot))
                    itemID = tonumber(itemID)
                    if (itemID == Necrosis.Warlock_Lists.reagents.soul_shard.id) then
                        if (RemainingShardsToDelete > 0) then
                            C_Container.PickupContainerItem(container, slot)
                            local infoType, info1, info2 = GetCursorInfo()
                            if (CursorHasItem() and infoType == "item" and tonumber(info1) == Necrosis.Warlock_Lists.reagents.soul_shard.id) then
                                DeleteCursorItem()
                                Local.Soulshard.Count = GetItemCount(Necrosis.Warlock_Lists.reagents.soul_shard.id)
                                ClearCursor()
                                RemainingShardsToDelete = RemainingShardsToDelete - 1
                            end
                        end
                    end
                end
            end
        end
    end
end
