-- TEST: SIMPLEST POSSIBLE SecureActionButton

local testFrame = CreateFrame("Frame", "NecrosisTestFrame")
testFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
testFrame:SetScript("OnEvent", function()
	-- TEST BUTTON 1 - Simple (should work)
	local btn = CreateFrame("Button", "NecrosisTestButton", UIParent, "SecureUnitButtonTemplate")
	btn:SetPoint("CENTER", UIParent, "CENTER", -150, -100)
	btn:SetWidth(100)
	btn:SetHeight(40)
	btn:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:SetPoint("CENTER")
	text:SetText("SIMPLE")

	btn:SetAttribute("unit", "player")
	btn:SetAttribute("helpbutton1", "heal1")
	btn:SetAttribute("type-heal1", "spell")
	btn:SetAttribute("spell-heal1", "Peau de démon")
	btn:RegisterForClicks("AnyUp")
	btn:Show()

	-- TEST BUTTON 1B - With SetMovable/EnableMouse like NecrosisButton
	local btn1b = CreateFrame("Button", "NecrosisTestButton1B", UIParent, "SecureUnitButtonTemplate")
	btn1b:SetPoint("CENTER", UIParent, "CENTER", -150, -150)
	btn1b:SetWidth(100)
	btn1b:SetHeight(40)
	btn1b:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	local text1b = btn1b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text1b:SetPoint("CENTER")
	text1b:SetText("MOVABLE")

	-- Add properties like NecrosisButton
	btn1b:SetMovable(true)
	btn1b:EnableMouse(true)
	btn1b:SetFrameLevel(1)

	btn1b:SetAttribute("unit", "player")
	btn1b:SetAttribute("helpbutton1", "heal1b")
	btn1b:SetAttribute("type-heal1b", "spell")
	btn1b:SetAttribute("spell-heal1b", "Peau de démon")
	btn1b:RegisterForClicks("AnyUp")
	btn1b:Show()

	print("TEST 1: Simple button")
	print("TEST 1B: With SetMovable/EnableMouse")

	-- TEST BUTTON 2 - Like Necrosis sphere (delayed attribute config)
	local btn2 = CreateFrame("Button", "NecrosisTestButton2", UIParent, "SecureUnitButtonTemplate")
	btn2:SetPoint("CENTER", UIParent, "CENTER", 150, -100)
	btn2:SetWidth(100)
	btn2:SetHeight(40)
	btn2:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	local text2 = btn2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text2:SetPoint("CENTER")
	text2:SetText("TEST 2")

	-- Configure like Necrosis does (with all the extra stuff)
	btn2:SetMovable(true)
	btn2:EnableMouse(true)
	btn2:RegisterForClicks("AnyUp")
	btn2:Show()

	-- Configure attributes LATER (like MainButtonAttribute does)
	C_Timer.After(0.5, function()
		if not InCombatLockdown() then
			btn2:SetAttribute("unit", "player")
			btn2:SetAttribute("helpbutton1", "mainspell")
			btn2:SetAttribute("type-mainspell", "spell")
			btn2:SetAttribute("spell-mainspell", "Peau de démon")
			print("TEST 2: Attributes configured after delay")
		end
	end)

	print("=== TWO TEST BUTTONS ===")
	print("Left: TEST 1 (immediate config)")
	print("Right: TEST 2 (delayed config like Necrosis)")
	print("Click both and see which works!")

	-- TEST BUTTON 3 - Sphere texture at fixed position
	local btn3 = CreateFrame("Button", "NecrosisTestButton3", UIParent, "SecureUnitButtonTemplate")
	btn3:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
	btn3:SetWidth(58)
	btn3:SetHeight(58)
	btn3:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Shard")

	local text3 = btn3:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text3:SetPoint("CENTER", 0, -40)
	text3:SetText("SPHERE TEST")

	btn3:SetAttribute("unit", "player")
	btn3:SetAttribute("helpbutton1", "test3")
	btn3:SetAttribute("type-test3", "spell")
	btn3:SetAttribute("spell-test3", "Peau de démon")
	btn3:RegisterForClicks("AnyUp")
	btn3:Show()

	print("TEST 3: Sphere texture - if THIS works, NecrosisButton config has a problem!")

	-- TEST BUTTON 4 - Same position as NecrosisButton to test if location is blocked
	C_Timer.After(1, function()
		local necro = _G["NecrosisButton"]
		if necro then
			local point, relativeTo, relativePoint, x, y = necro:GetPoint()
			local btn4 = CreateFrame("Button", "NecrosisTestButton4", UIParent, "SecureUnitButtonTemplate")
			btn4:SetPoint(point or "CENTER", relativeTo or UIParent, relativePoint or "CENTER", (x or 0) + 100, y or 0)
			btn4:SetWidth(58)
			btn4:SetHeight(58)
			btn4:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Shard")

			local text4 = btn4:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
			text4:SetPoint("CENTER")
			text4:SetText("4")

			btn4:SetFrameStrata("TOOLTIP")  -- Even higher!
			btn4:SetFrameLevel(200)
			btn4:SetAttribute("unit", "player")
			btn4:SetAttribute("helpbutton1", "test4")
			btn4:SetAttribute("type-test4", "spell")
			btn4:SetAttribute("spell-test4", "Peau de démon")
			btn4:RegisterForClicks("AnyUp")
			btn4:Show()

			print("TEST 4: Created next to NecrosisButton - if THIS works but sphere doesn't, something blocks ONLY NecrosisButton!")
		end

		-- TEST BUTTON 5 - EXACT copy of NecrosisMainSphere creation code
		local btn5 = CreateFrame("Button", "NecrosisTestSphere", UIParent, "SecureUnitButtonTemplate")
		btn5:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Shard")
		btn5:SetWidth(58)
		btn5:SetHeight(58)
		btn5:SetFrameStrata("TOOLTIP")
		btn5:SetFrameLevel(200)
		btn5:SetMovable(true)
		btn5:EnableMouse(true)

		btn5:SetAttribute("unit", "player")
		btn5:SetAttribute("helpbutton1", "necro1")
		btn5:SetAttribute("type-necro1", "spell")
		btn5:SetAttribute("spell-necro1", "Peau de démon")

		btn5:RegisterForClicks("AnyUp")

		btn5:SetScript("PostClick", function(self, button)
			print("TEST 5 POSTCLICK! Button: " .. tostring(button))
		end)

		btn5:SetPoint("CENTER", UIParent, "CENTER", 150, 0)
		btn5:Show()

		_G["TestNecrosisButton"] = btn5

		print("TEST 5: Exact copy of NecrosisMainSphere code - if THIS works, timing/location is the issue!")
	end)
end)
