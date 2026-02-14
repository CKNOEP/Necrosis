-- Ultra-simple test to see if Framework.lua loads at all
print("|cFF00FF00[FRAMEWORK_LUA]|r THIS FILE IS LOADING!!!")

-- If you see the above message, Framework.lua is being loaded
-- If you don't see it, there's a TOC path issue

-- Now try initializing NUI
print("|cFF00FF00[FRAMEWORK_LUA]|r Checking for NUI...")
local NUI = _G.NUI
if not NUI then
	print("|cFF00FF00[FRAMEWORK_LUA]|r NUI doesn't exist yet, creating it...")
	NUI = LibStub('AceAddon-3.0'):NewAddon('NecrosisUI', 'AceEvent-3.0', 'AceConsole-3.0', 'AceSerializer-3.0')
	_G.NUI = NUI
	print("|cFF00FF00[FRAMEWORK_LUA]|r NUI created successfully!")
else
	print("|cFF00FF00[FRAMEWORK_LUA]|r NUI already exists")
end

print("|cFF00FF00[FRAMEWORK_LUA]|r Creating NecrosisUI frame...")
-- Create main NecrosisUI container frame
local necrosisUIFrame = CreateFrame("Frame", "NecrosisUI", UIParent)
necrosisUIFrame:SetFrameStrata("BACKGROUND")
necrosisUIFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
necrosisUIFrame:SetSize(800, 200)
necrosisUIFrame:Hide()
print("|cFF00FF00[FRAMEWORK_LUA]|r NecrosisUI frame created!")

-- Create bottom anchor for artwork positioning
local bottomAnchor = CreateFrame("Frame", "NUI_BottomAnchor", necrosisUIFrame)
bottomAnchor:SetAllPoints(necrosisUIFrame)
print("|cFF00FF00[FRAMEWORK_LUA]|r Anchor frame created!")

-- Implement Show/Hide Methods
function NUI:Show()
	print("|cFF00FF00[FRAMEWORK_LUA]|r NUI:Show() called!")
	if NecrosisUI then
		NecrosisUI:Show()
	end
end

function NUI:Hide()
	print("|cFF00FF00[FRAMEWORK_LUA]|r NUI:Hide() called!")
	if NecrosisUI then
		NecrosisUI:Hide()
	end
end

print("|cFF00FF00[FRAMEWORK_LUA]|r Show/Hide methods created!")
print("|cFF00FF00[FRAMEWORK_LUA]|r Framework.lua COMPLETE!")
