-- Initialize NUI Addon
local NUI = _G.NUI
if not NUI then
	NUI = LibStub('AceAddon-3.0'):NewAddon('NecrosisUI', 'AceEvent-3.0', 'AceConsole-3.0', 'AceSerializer-3.0')
	_G.NUI = NUI
end

-- Get dynamic system offset based on actual layout counts
local function GetSystemOffset()
	-- Dynamic method: GetNumLayouts() - #custom layouts
	if C_EditMode and C_EditMode.GetNumLayouts then
		local total = C_EditMode.GetNumLayouts()
		local layouts = C_EditMode.GetLayouts()
		if layouts and layouts.layouts then
			local offset = total - #layouts.layouts
			return offset
		end
	end
	-- Fallback: TWW has 2 system layouts (Moderne + Classique)
	return 2
end


-- Listen for layout changes and specialization changes
local layoutChangeFrame = CreateFrame("Frame")
layoutChangeFrame:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
layoutChangeFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
layoutChangeFrame:SetScript("OnEvent", function(self, event)
	if event == "EDIT_MODE_LAYOUTS_UPDATED" then
		-- Layout change detected, update handled automatically
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		-- Restore NecrosisUI layout when specialization changes
		C_Timer.After(0.5, function()
			NUI:RestoreNecrosisLayout()
		end)
	end
end)

-- Create main NecrosisUI container frame
local necrosisUIFrame = CreateFrame("Frame", "NecrosisUI", UIParent)
necrosisUIFrame:SetFrameStrata("BACKGROUND")
necrosisUIFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
necrosisUIFrame:SetSize(800, 200)
necrosisUIFrame:Hide()

-- Create bottom anchor for artwork positioning
local bottomAnchor = CreateFrame("Frame", "NUI_BottomAnchor", necrosisUIFrame)
bottomAnchor:SetAllPoints(necrosisUIFrame)

-- Implement Show/Hide Methods
function NUI:Show()
	if NecrosisUI then
		NecrosisUI:Show()
		-- Import layout when showing NecrosisUI
		C_Timer.After(0.5, function()
			self:ImportLayout()
		end)
	end
end

function NUI:Hide()
	if NecrosisUI then
		NecrosisUI:Hide()
	end
end

function NUI:UpdateBottomBannerScale()
	if NUI_Art_Classic then
		local scale = 0.78 * (NecrosisConfig.BottomBannerScale or 1.0)
		NUI_Art_Classic:SetScale(scale)
	end
end

-- NecrosisUI Default Layout String (EditMode Configuration) - PTR current version
_G.NECROSISUI_LAYOUT_STRING = "2 50 0 0 0 1 1 UIParent -326.8 -942.0 -1 ##$$%/&&'%)$+#,$ 0 1 0 0 6 MainActionBar 0.0 -4.0 -1 ##$$%/&&'%(#,$ 0 2 0 0 6 UtilityCooldownViewer 0.0 -4.0 -1 ##$$%/&&'%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&&'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&&'%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&('%(#,$ 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&('%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&('%(#,$ 0 10 0 1 1 UIParent 0.0 -742.0 -1 ##$$&('% 0 11 0 4 4 UIParent -400.0 -370.0 -1 ##$$&('%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&('% 1 -1 0 1 1 UIParent 6.0 -1042.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 6 EncounterTimeline -20.0 12.0 -1 $#3# 3 1 0 7 7 UIParent 302.0 164.0 -1 %$3# 3 2 1 6 7 UIParent 520.0 265.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 -7.0 -1 '#(#)#-=.+/#1$3#5#6(7-7$8( 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-=.+/#0#1#2(5#6(7-7$8( 3 5 1 5 5 UIParent 0.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -=.+/#4$5#6(7-7$8( 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 0 1 1 UIParent 0.0 -742.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()(-$ 6 2 1 1 1 UIParent 0.0 -25.0 -1 ##$#%$&.(()(+#,-,$ 7 -1 0 4 4 UIParent -7.0 -260.0 -1 # 8 -1 0 6 6 UIParent 35.0 46.0 -1 #&$.%$&m 9 -1 0 7 7 UIParent 157.0 179.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 1 8 8 UIParent -9.0 85.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&# 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%& 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 &- 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 &- 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ## 20 0 0 4 4 UIParent 5.2 -260.0 -1 ##$.%$&&'%(-($)#+$,$-$ 20 1 0 4 4 UIParent 240.0 -420.0 -1 ##$+%$&('%(-($)#+$,$-$ 20 2 0 1 1 UIParent 317.0 -682.0 -1 ##$$%$&('((-($)#+$,$-$ 20 3 1 7 7 UIParent 420.0 430.0 -1 #$$$%#&('((-($)#*#+$,$-$.-.$ 21 -1 1 7 7 UIParent -410.0 380.0 -1 ##$# 22 0 1 8 7 UIParent -457.0 336.0 -1 #$$$%#&('((#)U*$+%,$-#.#/U0% 22 1 1 1 1 UIParent 0.0 -40.0 -1 &('()U*#+% 22 2 1 1 1 UIParent 0.0 -90.0 -1 &('()U*#+% 22 3 1 1 1 UIParent 0.0 -130.0 -1 &('()U*#+% 23 -1 1 0 0 UIParent 0.0 0.0 -1 ##$#%$&-&$'7(%)U+$,$-$.(/U"

-- Import NecrosisUI Layout via C_EditMode
function NUI:ImportLayout()
	if not C_EditMode or not C_EditMode.GetLayouts or not C_EditMode.ConvertStringToLayoutInfo then
		return
	end

	local layoutString = _G.NECROSISUI_LAYOUT_STRING
	if not layoutString then
		return
	end

	local importedLayoutInfo = C_EditMode.ConvertStringToLayoutInfo(layoutString)
	if not importedLayoutInfo then
		return
	end

	-- Ensure Blizzard_EditMode is loaded
	if not C_AddOns.IsAddOnLoaded("Blizzard_EditMode") then
		UIParentLoadAddOn("Blizzard_EditMode")
	end

	-- Wait a bit for everything to initialize
	C_Timer.After(0.5, function()
		local currentLayouts = C_EditMode.GetLayouts()
		if not currentLayouts or not currentLayouts.layouts then
			return
		end

		-- Find a custom layout to copy layoutType from
		local customLayoutType = nil
		for i, layout in ipairs(currentLayouts.layouts) do
			-- Custom layouts should have a different layoutType than system ones
			if layout.layoutType and layout.layoutType ~= 1 then -- Assuming 1 is system type
				customLayoutType = layout.layoutType
				break
			end
		end

		-- If no custom layout exists, use a default layoutType
		if not customLayoutType then
			customLayoutType = 2  -- Default custom layout type
			end

		NUI:CreateNecrosisLayout(currentLayouts, importedLayoutInfo, customLayoutType)
	end)
end

-- Helper function to create or update NecrosisUI layout
function NUI:CreateNecrosisLayout(currentLayouts, importedLayoutInfo, customLayoutType)
	local necrosisLayoutName = "NecrosisUI_" .. UnitName("player")
	local necrosisLayoutIndex = nil
	local templateLayout = currentLayouts.layouts[1]

	-- Check if NecrosisUI layout already exists
	for i, layout in ipairs(currentLayouts.layouts) do
		if layout.layoutName == necrosisLayoutName then
			necrosisLayoutIndex = i
			break
		end
	end

	-- Create or update layout
	if not necrosisLayoutIndex then
		-- Create new layout based on template or imported data
		local newLayout = {}

		if templateLayout then
			-- Copy all fields from template (systems field is required by SaveLayouts)
			for k, v in pairs(templateLayout) do
				newLayout[k] = v
			end
		else
			-- No template exists, use imported layout data
			-- Copy systems from importedLayoutInfo if available
			if importedLayoutInfo.systems then
				newLayout.systems = importedLayoutInfo.systems
			else
				-- Fallback to empty systems
				newLayout.systems = {}
			end
		end

		-- Override with our custom values
		newLayout.layoutName = necrosisLayoutName
		newLayout.layoutType = customLayoutType
		if importedLayoutInfo.frames then
			newLayout.frames = importedLayoutInfo.frames
		end

		table.insert(currentLayouts.layouts, newLayout)
		necrosisLayoutIndex = #currentLayouts.layouts
	else
		-- Update existing layout
		if importedLayoutInfo.frames then
			currentLayouts.layouts[necrosisLayoutIndex].frames = importedLayoutInfo.frames
		end
	end

	-- Save layouts (keep all fields including required 'systems')
	local saveInfo = {
		layouts = currentLayouts.layouts,
		activeLayout = currentLayouts.activeLayout
	}
	C_EditMode.SaveLayouts(saveInfo)

	-- Wait for save to complete, then activate by name
	C_Timer.After(0.2, function()
		local necrosisLayoutName = "NecrosisUI_" .. UnitName("player")

		-- Method: Search by name in EditModeManagerFrame (most reliable)
		if EditModeManagerFrame and EditModeManagerFrame.layouts then
			for i, layout in ipairs(EditModeManagerFrame.layouts) do
				if layout.layoutName == necrosisLayoutName then
					-- Found layout by name - activate directly by index
					C_EditMode.SetActiveLayout(i)

					-- Give EditMode time to process and apply layout
					C_Timer.After(0.3, function()
						NUI:ApplyLayoutFrames(importedLayoutInfo)
					end)
					return
				end
			end
		end

		-- Fallback: Use C_EditMode.GetLayouts() if EditModeManagerFrame unavailable
		local updatedLayouts = C_EditMode.GetLayouts()
		if updatedLayouts and updatedLayouts.layouts then
			local offset = GetSystemOffset()

			for i, layout in ipairs(updatedLayouts.layouts) do
				if layout.layoutName == necrosisLayoutName then
					local globalLayoutIndex = offset + i
					C_EditMode.SetActiveLayout(globalLayoutIndex)

					C_Timer.After(0.3, function()
						NUI:ApplyLayoutFrames(importedLayoutInfo)
					end)
					return
				end
			end
		end

	end)
end

-- Restore NecrosisUI layout by name (called after specialization change or when enabling the option)
function NUI:RestoreNecrosisLayout()
	if not C_EditMode then
		return
	end

	-- Wait a bit for EditMode to be ready
	C_Timer.After(0.3, function()
		local necrosisLayoutName = "NecrosisUI_" .. UnitName("player")

		-- Method: Search by name in EditModeManagerFrame (most reliable, same as CreateNecrosisLayout)
		if EditModeManagerFrame and EditModeManagerFrame.layouts then
			for i, layout in ipairs(EditModeManagerFrame.layouts) do
				if layout.layoutName == necrosisLayoutName then
					-- Found layout by name - activate directly by index (no offset!)
					C_EditMode.SetActiveLayout(i)
					return
				end
			end
		end

		-- Fallback: Use C_EditMode.GetLayouts() if EditModeManagerFrame unavailable
		local updatedLayouts = C_EditMode.GetLayouts()
		if updatedLayouts and updatedLayouts.layouts then
			local offset = GetSystemOffset()

			for i, layout in ipairs(updatedLayouts.layouts) do
				if layout.layoutName == necrosisLayoutName then
					local globalLayoutIndex = offset + i
					C_EditMode.SetActiveLayout(globalLayoutIndex)

					-- Apply the layout frames after activation
					C_Timer.After(0.3, function()
						if layout.frames then
							NUI:ApplyLayoutFrames(layout)
						end
					end)
					return
				end
			end
		end

		-- Layout not found, create it via ImportLayout()
		if type(NUI.ImportLayout) == "function" then
			NUI:ImportLayout()
		end
	end)
end

-- Apply layout frames to actual game frames
function NUI:ApplyLayoutFrames(layoutInfo)
	if not layoutInfo or not layoutInfo.frames then
		return
	end

	for _, frameData in ipairs(layoutInfo.frames) do
		if frameData and frameData.frameName then
			local frame = _G[frameData.frameName]
			if frame then
				-- Extract position data
				local anchor = frameData.anchor or frameData.point or "BOTTOM"
				local relativeTo = frameData.relativeTo or "UIParent"
				local relativePoint = frameData.relativePoint or anchor
				local x = frameData.x or 0
				local y = frameData.y or 0
				local scale = frameData.scale or 1.0

				-- Apply position
				frame:ClearAllPoints()
				local relativeFrame = relativeTo == "UIParent" and UIParent or _G[relativeTo]
				if relativeFrame then
					frame:SetPoint(anchor, relativeFrame, relativePoint, x, y)
				end

				-- Apply scale
				if scale and scale ~= 1.0 then
					frame:SetScale(scale)
				end
			end
		end
	end
end

-- List all layouts
function NUI:ListLayouts()
	UIParentLoadAddOn("Blizzard_EditMode")
	C_Timer.After(0.5, function()
		local l = C_EditMode.GetLayouts()
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("=== Layout Index Mapping ===")
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("activeLayout global: " .. l.activeLayout)
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("custom count: " .. #l.layouts)

		-- Calculate dynamic offset
		local offset = GetSystemOffset()
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Offset (système layouts): " .. offset)

		-- Map custom layouts to global indices
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("--- Custom Layouts ---")
		for i, layout in ipairs(l.layouts) do
			local globalIdx = offset + i
			local marker = (globalIdx == l.activeLayout) and " [ACTIVE]" or ""
			_G["DEFAULT_CHAT_FRAME"]:AddMessage(string.format("  custom[%d] → global[%d] = '%s'%s",
				i, globalIdx, tostring(layout.layoutName), marker))
		end

		-- Try to access system layouts via GetLayoutInfo
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("--- System Layouts ---")
		for globalIdx = 1, offset do
			if C_EditMode.GetLayoutInfo then
				local info = C_EditMode.GetLayoutInfo(globalIdx)
				if info then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage(string.format("  system[%d] = '%s'",
						globalIdx, tostring(info.layoutName)))
				end
			end
		end
	end)
end

-- Debug command with dynamic offset
SLASH_NUIDEBUG1 = "/nuidebug"
SlashCmdList["NUIDEBUG"] = function()
	NUI:ListLayouts()
end
