-- Outil de diagnostic : /necspells
-- Verifie chaque ID de Necrosis.Warlock_Spells (Spells-Forever.lua) aupres du client.
-- Affiche les IDs inexistants sur ce client, regroupes par usage. Aucun effet en jeu.
SLASH_NECSPELLS1 = "/necspells"
-- IDs Classic presents dans Spells-Vanilla.lua mais absents de Spells-Forever.lua
local VanillaMissing = {
	58887,18647,17925,17926,27223,1120,8288,8289,11675,27217,1490,11721,11722,27228,
	28176,28189,6366,17951,17952,17953,27250,5723,20764,5720,6263,20762,19028,20765,
	6262,18220,18937,18938,27265,7812,19438,19440,19441,19442,19443,27273,18265,18879,
	18880,18881,27264,27238,2362,17727,17728,28172,20763,18708,
}

SlashCmdList["NECSPELLS"] = function(msg)
	local get = (C_Spell and C_Spell.GetSpellInfo) or GetSpellInfo
	if msg and msg:lower():find("vanilla") then
		print("|cffff8800Necrosis /necspells vanilla|r : IDs existants sur ce client")
		for _, id in ipairs(VanillaMissing) do
			local info = get(id)
			if info then print(id .. " " .. (info.name or tostring(info))) end
		end
		return
	end
	local bad, nbad, total = {}, 0, 0
	for id, v in pairs(Necrosis.Warlock_Spells or {}) do
		if type(id) == "number" then
			total = total + 1
			local info = get(id)
			if not info then
				local u = (type(v) == "table" and v.Usage) or "?"
				bad[u] = bad[u] or {}
				table.insert(bad[u], id)
				nbad = nbad + 1
			end
		end
	end
	print(string.format("|cffff8800Necrosis /necspells|r : %d IDs testes, %d inexistants", total, nbad))
	local keys = {}
	for u in pairs(bad) do table.insert(keys, u) end
	table.sort(keys)
	for _, u in ipairs(keys) do
		table.sort(bad[u])
		print(u .. " : " .. table.concat(bad[u], ", "))
	end
end
