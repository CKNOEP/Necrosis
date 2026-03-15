-- Test simple button
print("[TEST] test_simple_button.lua loaded!")

local function CreateTestBtn()
	print("[TEST] Creating button...")
	local btn = CreateFrame("Button", "TestBtn_Eye", UIParent, "SecureActionButtonTemplate")
	btn:SetSize(50, 50)
	btn:SetPoint("CENTER", 0, 100)
	btn:SetAttribute("type", "spell")
	btn:SetAttribute("spell", "Oeil de Kilrogg")
	btn:EnableMouse(true)
	btn:RegisterForClicks("LeftButtonUp")

	local tex = btn:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints()
	tex:SetTexture(136155)

	btn:Show()
	print("[TEST] Button created!")
end

SLASH_TEST1 = "/test"
SlashCmdList["TEST"] = function(msg)
	if msg == "create" then
		CreateTestBtn()
	end
end

print("[TEST] Ready!")
