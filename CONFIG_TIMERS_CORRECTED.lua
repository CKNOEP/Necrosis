-- NECROSIS - Corrected Config.Timers for Midnight 12.0.1
-- This replaces the 7-item list with a complete, organized list of all 40+ timer spells

Timers = {
	-- ========================================
	-- CURSES (7 total)
	-- ========================================
	[1] = {usage = "agony", show = true},              -- Curse of Agony (24s) - Very common DoT
	[2] = {usage = "weakness", show = true},          -- Curse of Weakness (120s) - Common debuff
	[3] = {usage = "elements", show = true},          -- Curse of Elements [M12.0] (300s) - Damage amp
	[4] = {usage = "doom", show = true},              -- Curse of Doom (60s duration + cooldown)
	[5] = {usage = "tongues", show = false},          -- Curse of Tongues (30s) - Situational
	[6] = {usage = "exhaustion", show = false},       -- Curse of Exhaustion (12s) - Situational
	[7] = {usage = "recklessness", show = false},     -- Curse of Recklessness (120s) - Rare

	-- ========================================
	-- AFFLICTION DoTs (5 total)
	-- ========================================
	[8] = {usage = "corruption", show = true},        -- Corruption (12-18s) - Core DoT
	[9] = {usage = "unstable_affliction", show = true}, -- Unstable Affliction (15-18s) - Talent
	[10] = {usage = "haunt", show = true},            -- Haunt [M12.0] (18s) - Affliction signature
	[11] = {usage = "siphon_life", show = true},      -- Siphon Life [M12.0] (15s) - Talent
	[12] = {usage = "drain_soul", show = true},       -- Drain Soul [M12.0] (5s) - Cast duration

	-- ========================================
	-- DESTRUCTION DoTs & Abilities (8 total)
	-- ========================================
	[13] = {usage = "immolate", show = true},         -- Immolate (15s) - Core Destruction DoT
	[14] = {usage = "fear", show = true},             -- Fear (10-20s) - Control spell
	[15] = {usage = "howl", show = false},            -- Howl of Terror (10-15s) - Situational control
	[16] = {usage = "soul_fire", show = true},        -- Soul Fire (60s cooldown) - Execute damage
	[17] = {usage = "death_coil", show = true},       -- Death Coil (3s + 180s cooldown) - Spender
	[18] = {usage = "shadowburn", show = true},       -- Shadowburn (15s cooldown) - Execute
	[19] = {usage = "domination", show = false},      -- Fel Domination (15s cooldown, 15s duration)
	[20] = {usage = "conflagration", show = false},   -- Conflagration (?) - Unknown/rare

	-- ========================================
	-- CONTROL & DEBUFFS (2 total)
	-- ========================================
	[21] = {usage = "banish", show = true},           -- Banish (20-30s) - Demon control
	[22] = {usage = "enslave", show = true},          -- Enslave Demon (300s) - Demon control

	-- ========================================
	-- UTILITY BUFFS (3 total)
	-- ========================================
	[23] = {usage = "ward", show = true},             -- Shadow Ward [M12.0] (30s) - Protection
	[24] = {usage = "armor", show = false},           -- Demon Skin/Armor (1800s) - Long buff
	[25] = {usage = "fel_armor", show = false},       -- Fel Armor (?) - Class passive?

	-- ========================================
	-- SUMMONING & RITUALS (3 total)
	-- ========================================
	[26] = {usage = "soulstone", show = true},        -- Soulstone (15 min buff)
	[27] = {usage = "summoning", show = true},        -- Ritual of Summoning (600s ritual)
	[28] = {usage = "rit_of_doom", show = false},     -- Ritual of Doom (summon event)

	-- ========================================
	-- DETECTION & MOVEMENT (2 total)
	-- ========================================
	[29] = {usage = "eye", show = false},             -- Eye of Kilrogg (45s vision)
	[30] = {usage = "invisible", show = false},       -- Detect Invisibility (600s) - Situational
	[31] = {usage = "breath", show = false},          -- Unending Breath (600s) - Utility

	-- ========================================
	-- INFERNAL & RITUAL (1 total)
	-- ========================================
	[32] = {usage = "inferno", show = false},         -- Inferno (5s summon) - Situational

	-- ========================================
	-- DEMONIC SACRIFICE (7 total) - Rarely used anymore
	-- ========================================
	[33] = {usage = "sacrifice", show = false},       -- Demoniac Sacrifice (30s buff generator)
	[34] = {usage = "sacrifice_Void", show = false},  -- Sacrifice Voidwalker (30s protection)
	[35] = {usage = "sacrifice_demonic_Imp", show = false},       -- Sacrifice Imp (1800s buff)
	[36] = {usage = "sacrifice_demonic_Voidwalker", show = false}, -- Sacrifice Void (1800s buff)
	[37] = {usage = "sacrifice_demonic_Succubus", show = false},   -- Sacrifice Succ (1800s buff)
	[38] = {usage = "sacrifice_demonic_Felhunter", show = false},  -- Sacrifice FH (1800s buff)
	[39] = {usage = "sacrifice_demonic_Felguard", show = false},   -- Sacrifice FG (1800s buff)

	-- ========================================
	-- RITUAL OF SOULS (1 total)
	-- ========================================
	[40] = {usage = "Ritual_of_Souls", show = false}, -- Ritual of Souls (600s ritual buff)

	-- ========================================
	-- REMOVED/DEPRECATED - DO NOT USE
	-- ========================================
	-- These usages should NOT appear in timer options because:
	-- - They don't have Timer=true in Spells-Midnight.lua or are non-timer spells
	-- - They are creation spells, not duration spells
	-- - They are obsolete or unknown
	--
	-- DO NOT UNCOMMENT THESE:
	-- [X] = {usage = "life_tap", show = false},           -- Not a timer (no duration)
	-- [X] = {usage = "dark_intent", show = false},        -- Not a timer (buff status tracked elsewhere)
	-- [X] = {usage = "spellstone", show = false},         -- Not a timer (creation ability)
	-- [X] = {usage = "firestone", show = false},          -- Not a timer (creation ability)
	-- [X] = {usage = "mounts", show = false},             -- Not a timer (movement ability)
	-- [X] = {usage = "bolt", show = false},               -- Unknown/obsolete
	-- [X] = {usage = "link", show = false},               -- Unknown/obsolete
	-- [X] = {usage = "soul_swap", show = false},          -- Unknown/obsolete
	-- [X] = {usage = "imp", show = false},                -- Pet summon, not a timer
	-- [X] = {usage = "voidwalker", show = false},         -- Pet summon, not a timer
	-- [X] = {usage = "succubus", show = false},           -- Pet summon, not a timer
	-- [X] = {usage = "inccubus", show = false},           -- Pet summon, not a timer
	-- [X] = {usage = "felhunter", show = false},          -- Pet summon, not a timer
	-- [X] = {usage = "felguard", show = false},           -- Pet summon, not a timer
	-- [X] = {usage = "minor_ss_used", show = false},      -- Stone usage result (event-driven)
	-- [X] = {usage = "lesser_ss_used", show = false},     -- Stone usage result (event-driven)
	-- [X] = {usage = "ss_used", show = false},            -- Stone usage result (event-driven)
	-- [X] = {usage = "greater_ss_used", show = false},    -- Stone usage result (event-driven)
	-- [X] = {usage = "major_ss_used", show = false},      -- Stone usage result (event-driven)
	-- [X] = {usage = "master_ss_used", show = false},     -- Stone usage result (event-driven)
	-- [X] = {usage = "demonic_ss_used", show = false},    -- Stone usage result (event-driven)
	-- [X] = {usage = "minor_hs_used", show = false},      -- Stone usage result (event-driven)
	-- [X] = {usage = "lesser_hs_used", show = false},     -- Stone usage result (event-driven)
	-- [X] = {usage = "hs_used", show = false},            -- Stone usage result (event-driven)
	-- [X] = {usage = "greater_hs_used", show = false},    -- Stone usage result (event-driven)
	-- [X] = {usage = "major_hs_used", show = false},      -- Stone usage result (event-driven)
	-- [X] = {usage = "master_hs_used", show = false},     -- Stone usage result (event-driven)
	-- [X] = {usage = "demonic_hs_used", show = false},    -- Stone usage result (event-driven)
	-- [X] = {usage = "fel_hs_used", show = false},        -- Stone usage result (event-driven)
	-- [X] = {usage = "healthstone", show = false},        -- Stone creation, not a timer
	-- [X] = {usage = "shadow", show = false},             -- Curse of Shadow (removed/deprecated)
}

-- ========================================
-- MIGRATION NOTES
-- ========================================
-- Original list had only 7 items (lines 137-146)
-- This replacement adds 40 items for comprehensive timer coverage
-- Order is optimized for options screen display
-- Default show=true for most-used spells
-- Default show=false for situational/rare spells

-- Midnight 12.0 Changes:
-- - New IDs: Ward (153415), Haunt (48181), Siphon Life (63106),
--            Drain Soul (198590), Curse of Elements (44332)
-- - Removed: Many old pet-related passive abilities
-- - Preserved: All active cast/summon spells with timers

-- Total count: 40 active timer entries (up from 7)
