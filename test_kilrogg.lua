-- Simple test button to verify SecureActionButtonTemplate works with Eye of Kilrogg
print("[TEST BUTTON] test_kilrogg.lua loaded!")

local function CreateTestButton()
	local btn = CreateFrame("Button", "MyKilroggButton", UIParent, "SecureActionButtonTemplate")
	btn:SetSize(36, 36)
	btn:SetPoint("CENTER")  -- place le bouton au centre de l'écran

	-- Action sécurisée : lancer un sort
	btn:SetAttribute("type", "spell")
	btn:SetAttribute("spell", "Œil de Kilrogg")  -- Nom français du sort

	-- Icône du bouton
	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints()
	icon:SetTexture(136155)  -- ID de texture simple

	-- Rendez le bouton cliquable
	btn:EnableMouse(true)
	btn:RegisterForClicks("AnyUp")
	btn:Show()

	print("[TEST BUTTON] Test button created: MyKilroggButton")
	return btn
end

-- Register slash command
SLASH_TESTKILL1 = "/testkill"
SlashCmdList["TESTKILL"] = function(msg)
	if msg == "create" then
		CreateTestButton()
		print("[TEST BUTTON] Click the button in the center to cast Eye of Kilrogg!")
	elseif msg == "remove" then
		local btn = _G["MyKilroggButton"]
		if btn then
			btn:Hide()
			btn = nil
			print("[TEST BUTTON] Test button removed")
		end
	else
		print("/testkill create - Create test button")
		print("/testkill remove - Remove test button")
	end
end

print("[TEST BUTTON] Commands ready: /testkill create")
