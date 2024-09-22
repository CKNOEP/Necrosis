--[[
MIT License

Copyright (c) 2022-2024 ennvina

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Credits to Blizzard Entertainment for writing original code of Spell Activation Overlay
--]]
local AddonName, SAO = ...
local Module = "main"

-- Optimize frequent calls
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown

local sizeScale = 0.8;
local longSide = 256 * sizeScale;
local shortSide = 128 * sizeScale;
local combatOverlayFactor = 2;
local useTimer = true;
local useSound = false;

function NecrosisSpellActivationOverlay_OnLoad(self)
	SAO_Frame = self;
	SAO.Frame = self;
	SAO.ShowAllOverlays = NecrosisSpellActivationOverlay_ShowAllOverlays;
	SAO.HideOverlays = NecrosisSpellActivationOverlay_HideOverlays;
	SAO.HideAllOverlays = NecrosisSpellActivationOverlay_HideAllOverlays;
	SAO.SetOverlayTimer = NecrosisSpellActivationOverlay_SetAllOverlayTimers;

	self.overlaysInUse = {};
	self.unusedOverlays = {};
	self.combatOnlyOverlays = {};

	self.offset = 0;
	self.scale = 1;
	NecrosisSpellActivationOverlay_OnChangeGeometry(self);

	self.useTimer = true;
	NecrosisSpellActivationOverlay_OnChangeTimerVisibility(self);

	self.useSound = false;
	NecrosisSpellActivationOverlay_OnChangeSoundToggle(self);

	local className, classFile, classId = UnitClass("player");
	local class = SAO.Class[classFile];
	if class then
		class.Intrinsics = { className, classFile, classId };
		SAO.CurrentClass = class;

		-- Keys of the class other than "Intrinsics", "Register" and "LoadOptions" are expected to be event names
		for key, _ in pairs(class) do
			if (key ~= "Intrinsics" and key ~= "Register" and key ~= "LoadOptions") then
				self:RegisterEvent(key);
			end
		end
	else
		local currentClass = tostring(select(1, UnitClass("player")));
		SAO:Error(Module, SAO:unsupportedClass(), currentClass);
		SAO.Shutdown:EnableCategory("UNSUPPORTED_CLASS");
	end

	if ( SAO.IsCata() ) then
		-- These events do not exist in Classic Era, Burning Crusade Classic, nor Wrath Classic
		-- They have yet to be confirmed for Cataclysm, but they could (should?) exist
		self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
		self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");
	end
--	self:RegisterUnitEvent("UNIT_AURA", "player");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("SPELLS_CHANGED");
	self:RegisterEvent("LEARNED_SPELL_IN_TAB");
	self:RegisterEvent("LOADING_SCREEN_DISABLED");
	self:RegisterEvent("PLAYER_LOGIN");
	self:RegisterEvent("ADDON_LOADED");
	for _, var in pairs(SAO.Variables) do
		if type(var.event.isRequired) == 'function' and var.event.isRequired()
		or type(var.event.isRequired) == 'boolean' and var.event.isRequired then
			for _, eventName in ipairs(var.event.names) do
				self:RegisterEvent(eventName);
			end
		end
	end
end

function NecrosisSpellActivationOverlay_OnChangeGeometry(self)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_OnChangeGeometry");

	-- Ignores self.scale because it should be used to scale alerts, not core
	local newSize = 256 * sizeScale + self.offset;
	-- Resize the parent instead of self because the parent is the one bearing the Size element
	self:GetParent():SetSize(newSize, newSize);

	-- Resize existing overlays and prepare variables for future overlays
	longSide = 256 * sizeScale * self.scale;
	shortSide = 128 * sizeScale * self.scale;
	for _, overlayList in pairs(self.overlaysInUse) do
		for i=1, #overlayList do
			local overlay = overlayList[i];
			overlay:SetGeometry(longSide, shortSide);
		end
	end

	-- Resize offsets for overlays that offset a mask when out of combat
	for _, overlay in ipairs(self.combatOnlyOverlays) do
		if overlay.combat.animOut:IsPlaying() then
			-- Calling the 'Play' custom function for animOut will setup its offset
			NecrosisSpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut);
		end
	end
end

function NecrosisSpellActivationOverlay_OnChangeTimerVisibility(self)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_OnChangeTimerVisibility");

	if useTimer == self.useTimer then
		return;
	end

	useTimer = self.useTimer;

	for _, overlayList in pairs(self.overlaysInUse) do
		for i=1, #overlayList do
			local overlay = overlayList[i];
			overlay.mask:SetShown(useTimer);
		end
	end
end

function NecrosisSpellActivationOverlay_OnChangeSoundToggle(self)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_OnChangeSoundToggle");

	if useSound == self.useSound then
		return;
	end

	useSound = self.useSound;

	if useSound then
		for _, overlayList in pairs(self.overlaysInUse) do
			if #overlayList > 0 then
				-- Play generic sound if at least one effect is displayed
				-- No need to spam players with several effects, because currently there is only one type of sound effect
				overlayList[1].soundHandle = SAO:PlaySpellAlertSound();
				-- Please note, we might play a sound for a non-pulsing alert (which should not play sounds),
				-- but that's a minor issue, and we might even argue that it's for the better,
				-- because it gives feedback that the player actually changed the sound option
				break;
			end
		end
	else
		for _, overlayList in pairs(self.overlaysInUse) do
			for i=1, #overlayList do
				local overlay = overlayList[i];
				SAO:StopSpellAlertSound(overlay.soundHandle);
				overlay.soundHandle = nil;
			end
		end
	end
end

function NecrosisSpellActivationOverlay_OnEvent(self, event, ...)
	SAO:TraceThrottled(event, Module, "NecrosisSpellActivationOverlay_OnEvent "..tostring(event));

--[[ 
	Dead code because these events do not exist in Classic Era, BC Classic, nor Wrath Classic
	Also, the "displayNecrosisSpellActivationOverlays" console variable does not exist
	-- Update with upcoming Cataclysm --
	Must look into it for Cataclysm Classic, because these events should occur once again
	But we have added a few parameters since then - must add missing parameters if needed
	For now, we simply write debug information to try to confirm these events are emitted
]]
	if ( event == "SPELL_ACTIVATION_OVERLAY_SHOW" ) then
		local spellID, texture, positions, scale, r, g, b = ...;
		SAO:Debug(Module, "Received native SPELL_ACTIVATION_OVERLAY_SHOW with spell ID "..tostring(spellID)..", texture "..tostring(texture)..", positions '"..tostring(positions).."', scale "..tostring(scale)..", (r g b) = ("..tostring(r).." "..tostring(g).." "..tostring(b)..")");
		-- if ( GetCVarBool("displayNecrosisSpellActivationOverlays") ) then 
		-- 	NecrosisSpellActivationOverlay_ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b, true)
		-- end
	elseif ( event == "SPELL_ACTIVATION_OVERLAY_HIDE" ) then
		local spellID = ...;
		if spellID then
			SAO:Debug(Module, "Received native SPELL_ACTIVATION_OVERLAY_HIDE with spell ID "..tostring(spellID));
		end
		-- if spellID then
		-- 	NecrosisSpellActivationOverlay_HideOverlays(self, spellID);
		-- else
		-- 	NecrosisSpellActivationOverlay_HideAllOverlays(self);
		-- end
	end
	if ( not self.disableDimOutOfCombat ) then
		if ( event == "PLAYER_REGEN_DISABLED" and self.inPseudoCombat ~= true ) then
			self.combatAnimOut:Stop();	--In case we're in the process of animating this out.
			self.combatAnimIn:Play();
			for _, overlay in ipairs(self.combatOnlyOverlays) do
				overlay.combat.animOut:Stop();
				NecrosisSpellActivationOverlayFrame_PlayCombatAnimIn(overlay.combat.animIn);
			end
		elseif ( event == "PLAYER_REGEN_ENABLED" and self.inPseudoCombat ~= false ) then
			self.combatAnimIn:Stop();	--In case we're in the process of animating this out.
			self.combatAnimOut:Play();
			for _, overlay in ipairs(self.combatOnlyOverlays) do
				overlay.combat.animIn:Stop();
				NecrosisSpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut);
			end
		end
	end
	if ( event ) then
		SAO:OnEvent(event, ...);
	end
end

local complexLocationTable = {
	["RIGHT (FLIPPED)"] = {
		RIGHT = {	hFlip = true },
	},
	["BOTTOM (FLIPPED)"] = {
		BOTTOM = { vFlip = true },
	},
	["LEFT + RIGHT (FLIPPED)"] = {
		LEFT = {},
		RIGHT = { hFlip = true },
	},
	["TOP + BOTTOM (FLIPPED)"] = {
		TOP = {},
		BOTTOM = { vFlip = true },
	},
	["LEFT (CW)"] = {
		LEFT = { cw = 1 },
	},
	["LEFT (CCW)"] = {
		LEFT = { cw = -1 },
	},
	["LEFT (180)"] = {
		LEFT = { hFlip = true, vFlip = true },
	},
	["LEFT (VFLIPPED)"] = {
		LEFT = { vFlip = true },
	},
	["RIGHT (CW)"] = {
		RIGHT = { cw = 1 },
	},
	["RIGHT (CCW)"] = {
		RIGHT = { cw = -1 },
	},
	["RIGHT (180)"] = {
		RIGHT = { hFlip = true, vFlip = true },
	},
	["RIGHT (VFLIPPED)"] = {
		RIGHT = { vFlip = true },
	},
	["TOP (CW)"] = {
		TOP = { cw = 1 },
	},
	["TOP (CCW)"] = {
		TOP = { cw = -1 },
	},
	["TOP (180)"] = {
		TOP = { hFlip = true, vFlip = true },
	},
	["TOP (HFLIPPED)"] = {
		TOP = { hFlip = true },
	},
	["BOTTOM (CW)"] = {
		BOTTOM = { cw = 1 },
	},
	["BOTTOM (CCW)"] = {
		BOTTOM = { cw = -1 },
	},
	["BOTTOM (180)"] = {
		BOTTOM = { hFlip = true, vFlip = true },
	},
	["BOTTOM (HFLIPPED)"] = {
		BOTTOM = { hFlip = true },
	},
}

function NecrosisSpellActivationOverlay_ShowAllOverlays(self, spellID, texturePath, positions, scale, r, g, b, autoPulse, forcePulsePlay, endTime, combatOnly)
	if SAO.Shutdown:IsAddonDisabled() then
		return;
	end
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_ShowAllOverlays "..tostring(spellID));
	positions = strupper(positions);
	if ( complexLocationTable[positions] ) then
		for location, info in pairs(complexLocationTable[positions]) do
			NecrosisSpellActivationOverlay_ShowOverlay(self, spellID, texturePath, location, scale, r, g, b, info.vFlip, info.hFlip, info.cw, autoPulse, forcePulsePlay, endTime, combatOnly);
		end
	else
		NecrosisSpellActivationOverlay_ShowOverlay(self, spellID, texturePath, positions, scale, r, g, b, false, false, 0, autoPulse, forcePulsePlay, endTime, combatOnly);
	end
end

function NecrosisSpellActivationOverlay_ShowOverlay(self, spellID, texturePath, position, scale, r, g, b, vFlip, hFlip, cw, autoPulse, forcePulsePlay, endTime, combatOnly)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_ShowOverlay "..tostring(spellID).." "..position);
	SAO:Debug(Module, "Starting Overlay at location "..position.." for spell ID "..spellID.." "..(GetSpellInfo(spellID) or "")..(endTime and (" for "..math.floor((type(endTime) == 'number' and endTime or endTime.endTime)-GetTime()+0.5).." secs") or ""));

	if (NecrosisConfig and NecrosisConfig.alert and not NecrosisConfig.alert.enabled) then
		-- Last chance to quit displaying the overlay, if the main overlay flag is disabled
		return;
	end

	local overlay = NecrosisSpellActivationOverlay_GetOverlay(self, spellID, position);
	SAO_LastShownOverlay = overlay; -- Global variable for debugging purposes
	overlay.spellID = spellID;
	overlay.position = position;
	
	local texLeft, texRight, texTop, texBottom = 0, 1, 0, 1;
	if ( vFlip ) then
		texTop, texBottom = 1, 0;
	end
	if ( hFlip ) then
		texLeft, texRight = 1, 0;
	end
	if ( not cw or cw == 0 ) then
		overlay.texture:SetTexCoord(texLeft, texRight, texTop, texBottom);
--		overlay.texture:SetTexCoord(texLeft,texTop, texLeft,texBottom, texRight,texTop, texRight,texBottom); -- Written for reference
	elseif ( cw > 0 ) then
		overlay.texture:SetTexCoord(texLeft,texBottom, texRight,texBottom, texLeft,texTop, texRight,texTop);
	else
		overlay.texture:SetTexCoord(texRight,texTop, texLeft,texTop, texRight,texBottom, texLeft,texBottom);
	end

	overlay.SetGeometry = function(self, longSide, shortSide)
		local parent = self:GetParent();

		self:ClearAllPoints();

		local width, height;
		if ( position == "CENTER" ) then
			width, height = longSide, longSide;
			self:SetPoint("CENTER", parent, "CENTER", 0, 0);
		elseif ( position == "LEFT" ) then
			width, height = shortSide, longSide;
			self:SetPoint("RIGHT", parent, "LEFT", 0, 0);
		elseif ( position == "RIGHT" ) then
			width, height = shortSide, longSide;
			self:SetPoint("LEFT", parent, "RIGHT", 0, 0);
		elseif ( position == "TOP" ) then
			width, height = longSide, shortSide;
			self:SetPoint("BOTTOM", parent, "TOP");
		elseif ( position == "BOTTOM" ) then
			width, height = longSide, shortSide;
			self:SetPoint("TOP", parent, "BOTTOM");
		elseif ( position == "TOPRIGHT" ) then
			width, height = shortSide, shortSide;
			self:SetPoint("BOTTOMLEFT", parent, "TOPRIGHT", 0, 0);
		elseif ( position == "TOPLEFT" ) then
			width, height = shortSide, shortSide;
			self:SetPoint("BOTTOMRIGHT", parent, "TOPLEFT", 0, 0);
		elseif ( position == "BOTTOMRIGHT" ) then
			width, height = shortSide, shortSide;
			self:SetPoint("TOPLEFT", parent, "BOTTOMRIGHT", 0, 0);
		elseif ( position == "BOTTOMLEFT" ) then
			width, height = shortSide, shortSide;
			self:SetPoint("TOPRIGHT", parent, "BOTTOMLEFT", 0, 0);
		else
			--GMError("Unknown NecrosisSpellActivationOverlay position: "..tostring(position));
			return;
		end

		self:SetSize(width * scale, height * scale);
		self.mask:SetSize(longSide * scale, longSide * scale);
		self.combat:SetSize(longSide * scale * combatOverlayFactor, longSide * scale * combatOverlayFactor);
		-- Combat mask texture is bigger, to get an 'eye of the storm' effect at start
	end
	overlay:SetGeometry(longSide, shortSide);
	
	overlay.texture:SetTexture(texturePath);
	overlay.texture:SetVertexColor(r / 255, g / 255, b / 255);
	
	overlay.animOut:Stop();	--In case we're in the process of animating this out.
	if useSound and (autoPulse or forcePulsePlay) then
		overlay.soundHandle = SAO:PlaySpellAlertSound();
	end
	-- Circumvent a bug with pulse animations
	-- First, hide the overlay temporarily
	-- Then, very quickly (but not too quickly) start the pulse animation sooner, which kind of fixes the animation issue
	-- If we do not do this, we might see a weird flash for a brief moment at the very beginning of overlay:Show()
	if ( combatOnly ) then
		overlay.animIn.alpha1:SetToAlpha(0.01);
		overlay.animIn.alpha2:SetFromAlpha(0.01);
	else
		overlay.animIn.alpha1:SetToAlpha(0.5);
		overlay.animIn.alpha2:SetFromAlpha(0.5);
	end
	overlay:Show();
	if ( forcePulsePlay and not overlay.pulse:IsPlaying() ) then
		overlay.pulse:Play();
	end
	overlay.pulse.autoPlay = autoPulse;

	overlay.mask:SetShown(useTimer);

	NecrosisSpellActivationOverlay_SetOverlayTimer(self, overlay, endTime);

	overlay.combatOnly = combatOnly;
	if ( combatOnly ) then
		tDeleteItem(self.combatOnlyOverlays, overlay); -- In case it was already in the list
		tinsert(self.combatOnlyOverlays, overlay);
		if ( InCombatLockdown() ) then
			overlay.combat.animOut:Stop();
			-- NecrosisSpellActivationOverlayFrame_PlayCombatAnimIn(overlay.combat.animIn); -- Do not play combat.animIn if already in combat
		elseif ( self.disableDimOutOfCombat ) then -- Do not start animOut, because animIn will be started about 10 lines below
			overlay.combat.animIn:Stop();
			NecrosisSpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut);
		end
	else
		tDeleteItem(self.combatOnlyOverlays, overlay);
	end

	if ( not self.disableDimOutOfCombat and not InCombatLockdown() ) then
		-- Simulate a short, fake in-combat mode, to make the spell alert more visible
		self.combatAnimOut:Stop();
		self.combatAnimIn:Play();
		if ( combatOnly ) then
			-- Playing combat.animIn to add a smoother fade-in animation when not in combat
			-- Because the player is not in combat, the 'very quick' popup is overkill
			overlay.combat.animOut:Stop();
			NecrosisSpellActivationOverlayFrame_PlayCombatAnimIn(overlay.combat.animIn);
		end
	end
end

function NecrosisSpellActivationOverlay_DumpCombatOnlyOverlays()
	SAO:Info(Module, "Listing combat-only overlays ("..#SAO.Frame.combatOnlyOverlays.." item"..(#SAO.Frame.combatOnlyOverlays == 1 and "" or "s")..")");
	for i, overlay in pairs(SAO.Frame.combatOnlyOverlays) do
		SAO:Info(Module, "combat-only-overlay["..i.."] location == "..overlay.position..", spell ID = "..overlay.spellID.." "..(GetSpellInfo(overlay.spellID) or ""));
	end
end

function NecrosisSpellActivationOverlay_GetOverlay(self, spellID, position)
	local overlayList = self.overlaysInUse[spellID];
	local overlay;
	if ( overlayList ) then
		for i=1, #overlayList do
			if ( overlayList[i].position == position ) then
				overlay = overlayList[i];
			end
		end
	end
	
	if ( not overlay ) then
		overlay = NecrosisSpellActivationOverlay_GetUnusedOverlay(self);
		if ( overlayList ) then
			tinsert(overlayList, overlay);
		else
			self.overlaysInUse[spellID] = { overlay };
		end
	end
	
	return overlay;
end

function NecrosisSpellActivationOverlay_HideOverlays(self, spellID)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_HideOverlays "..tostring(spellID));
	local overlayList = self.overlaysInUse[spellID];
	if ( overlayList ) then
		for i=1, #overlayList do
			local overlay = overlayList[i];
			SAO:Debug(Module, "Hiding Overlay at location "..overlay.position.." for spell ID "..overlay.spellID.." "..(GetSpellInfo(overlay.spellID) or ""));
			overlay.pulse:Pause();
			overlay.animOut:Play();
		end
	end
end

function NecrosisSpellActivationOverlay_HideAllOverlays(self)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_HideAllOverlays");
	for spellID, overlayList in pairs(self.overlaysInUse) do
		NecrosisSpellActivationOverlay_HideOverlays(self, spellID);
	end
end

function NecrosisSpellActivationOverlay_SetAllOverlayTimers(self, spellID, endTime)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_SetAllOverlayTimers "..tostring(spellID).." "..tostring(endTime));

	if ( not endTime ) then
		return
	end

	local overlayList = self.overlaysInUse[spellID];
	if ( overlayList ) then
		for i=1, #overlayList do
			local overlay = overlayList[i];
			NecrosisSpellActivationOverlay_SetOverlayTimer(self, overlay, endTime);
		end
	end
end

function NecrosisSpellActivationOverlay_SetOverlayTimer(self, overlay, endTime)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_SetOverlayTimer "..tostring(overlay).." "..tostring(endTime));

	local startTime = type(endTime) == 'table' and endTime.startTime or nil;
	endTime = type(endTime) == 'table' and endTime.endTime or endTime;
	if ( not endTime or endTime <= GetTime() ) then
		return; -- endTime not set or "too soon"
	end

	local maxLag = 0.25; -- Estimated maximum lag, used to compare existing endTime with new endTime
	if ( type(overlay.endTime) == 'number' and SAO:IsTimeAlmostEqual(endTime, overlay.endTime, maxLag) ) then
		return; -- Overlay already has similar endTime: assume this is the same timer
	end
	overlay.endTime = endTime;

	SAO:Debug(Module, "Setting Overlay Timer at location "..overlay.position.." for spell ID "..overlay.spellID.." "..(GetSpellInfo(overlay.spellID) or "")..(endTime and (" for "..math.floor(endTime-GetTime()+0.5).." secs") or " without time"));

	local offset = startTime and (GetTime() - startTime) or 0;
	local duration = endTime - GetTime() + offset - 0.1; -- Subtract 0.1 to account for final shrink
	local position = overlay.position;
	local isHorizontal = position:sub(1, 3) == "TOP" or position:sub(1, 6) == "BOTTOM";
	local isVertical = position:sub(#position-3) == "LEFT" or position:sub(#position-4) == "RIGHT";
	if ( isHorizontal and isVertical ) then
		-- Corner
		overlay.mask.timeoutXY.scaleXY:SetDuration(duration);
		overlay.mask.timeoutXY:Stop();
		overlay.mask.timeoutXY:Play(false, offset);
	elseif ( isHorizontal ) then
		-- Top/Bottom
		overlay.mask.timeoutX.scaleX:SetDuration(duration);
		overlay.mask.timeoutX:Stop();
		overlay.mask.timeoutX:Play(false, offset);
	elseif ( isVertical ) then
		-- Left/Right
		overlay.mask.timeoutY.scaleY:SetDuration(duration);
		overlay.mask.timeoutY:Stop();
		overlay.mask.timeoutY:Play(false, offset);
	end
end

function NecrosisSpellActivationOverlay_GetUnusedOverlay(self)
	local overlay = tremove(self.unusedOverlays, #self.unusedOverlays);
	if ( not overlay ) then
		overlay = NecrosisSpellActivationOverlay_CreateOverlay(self);
	end
	return overlay;
end

function NecrosisSpellActivationOverlay_CreateOverlay(self)
	SAO:Trace(Module, "NecrosisSpellActivationOverlay_CreateOverlay");
	return CreateFrame("Frame", nil, self, "NecrosisSpellActivationOverlayTemplate");
end

function NecrosisSpellActivationOverlayTexture_OnShow(self)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_OnShow");
	self.animIn:Play();
end

function NecrosisSpellActivationOverlayTexture_TerminateOverlay(overlay)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_TerminateOverlay "..tostring(overlay));
	SAO:Debug(Module, "Terminating Overlay at location "..overlay.position.." for spell ID "..overlay.spellID.." "..(GetSpellInfo(overlay.spellID) or ""));

	local overlayParent = overlay:GetParent();

	-- No longer need to pulse
	overlay.pulse:Stop();

	-- Stop animations that may re-trigger terminate when they finish
	overlay.animOut:Stop();
	overlay.mask.timeoutXY:Stop();
	overlay.mask.timeoutX:Stop();
	overlay.mask.timeoutY:Stop();
	overlay.combat.animIn:Stop();
	overlay.combat.animOut:Stop();

	-- Stop playing sound
	SAO:StopSpellAlertSound(overlay.soundHandle, 1000);
	overlay.soundHandle = nil;

	-- Hide the overlay and make it available again in the pool for future use
	overlay.mask:SetAlpha(0); -- Set alpha to zero, because next time we want to start unnoticed
	overlay.mask:SetScale(1); -- Reset scale, in case a previous animation shrank it to 0.01
	overlay.endTime = nil; -- Reset endTime, to avoid excessive optimizations when re-using this overlay
	overlay:Hide();
	tDeleteItem(overlayParent.overlaysInUse[overlay.spellID], overlay);
	tinsert(overlayParent.unusedOverlays, overlay);
	tDeleteItem(overlayParent.combatOnlyOverlays, overlay);
end

function NecrosisSpellActivationOverlayFrame_OnTimeoutFinished(anim)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayFrame_OnTimeoutFinished "..tostring(anim));
	local mask = anim:GetParent();
	local overlay = mask:GetParent();
	mask:SetScale(0.01); -- Shrink mask scale to 0.01 to avoid glitches with final animation below
	-- Start the fade-out animation, which will eventually terminate the overlay
	overlay.animOut:Play();
end

function NecrosisSpellActivationOverlayFrame_GetCombatAnimOffsetFarAway(anim)
	local combat = anim:GetParent();
	local overlay = combat:GetParent();
	local frame = overlay:GetParent();
	local position = overlay.position;

	local baseLongSide = 256;
	local baseShortSide = 128;
	local farAway = ((baseLongSide-baseShortSide) / 2 + baseShortSide) * sizeScale * frame.scale * combatOverlayFactor;

	if ( position == "CENTER" ) then
		return 0, 0;
	elseif ( position == "LEFT" ) then
		return farAway, 0;
	elseif ( position == "RIGHT" ) then
		return -farAway, 0;
	elseif ( position == "TOP" ) then
		return 0, -farAway;
	elseif ( position == "BOTTOM" ) then
		return 0, farAway;
	elseif ( position == "TOPRIGHT" ) then
		return -farAway, -farAway;
	elseif ( position == "TOPLEFT" ) then
		return farAway, -farAway;
	elseif ( position == "BOTTOMRIGHT" ) then
		return -farAway, farAway;
	elseif ( position == "BOTTOMLEFT" ) then
		return farAway, farAway;
	else
		--GMError("Unknown NecrosisSpellActivationOverlay position: "..tostring(position));
		return;
	end
end

function NecrosisSpellActivationOverlayFrame_PlayCombatAnimIn(animIn)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayFrame_PlayCombatAnimIn "..tostring(animIn));

	local offsetX, offsetY = NecrosisSpellActivationOverlayFrame_GetCombatAnimOffsetFarAway(animIn);
	offsetX, offsetY = 0.7 * offsetX, 0.7 * offsetY -- Attenuate distance to make it visible sooner
	animIn.point1:SetOffset(offsetX, offsetY);
	animIn.point2:SetOffset(-offsetX, -offsetY);

	animIn:Play();
end

function NecrosisSpellActivationOverlayFrame_PlayCombatAnimOut(animOut)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayFrame_PlayCombatAnimOut "..tostring(animOut));

	local offsetX, offsetY = NecrosisSpellActivationOverlayFrame_GetCombatAnimOffsetFarAway(animOut);
	animOut.point1:SetOffset(offsetX, offsetY);

	animOut:Play();
end

function NecrosisSpellActivationOverlayTexture_ShowCombatMask(anim)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_ShowCombatMask "..tostring(anim));

	local combat = anim:GetParent():GetParent();
	combat:SetTexture("Interface/AddOns/Necrosis/SpellActivations/textures/maskzero");

	local overlay = combat:GetParent();
	SAO:Debug(Module, "Showing combat mask for Overlay at location "..overlay.position.." for spell ID "..overlay.spellID.." "..(GetSpellInfo(overlay.spellID) or ""));
end

function NecrosisSpellActivationOverlayTexture_HideCombatMask(anim)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_HideCombatMask "..tostring(anim));

	local combat = anim:GetParent():GetParent();
	combat:SetTexture("");

	local overlay = combat:GetParent();
	SAO:Debug(Module, "Hiding combat mask for Overlay at location "..overlay.position.." for spell ID "..overlay.spellID.." "..(GetSpellInfo(overlay.spellID) or ""));
end

function NecrosisSpellActivationOverlayTexture_OnCombatAnimInPlay(animIn)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_OnCombatAnimInPlay "..tostring(animIn));
	NecrosisSpellActivationOverlayTexture_HideCombatMask(animIn);
end

function NecrosisSpellActivationOverlayTexture_OnCombatAnimInFinished(animIn)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_OnCombatAnimInFinished "..tostring(animIn));
	NecrosisSpellActivationOverlayTexture_ShowCombatMask(animIn);
end

function NecrosisSpellActivationOverlayTexture_OnCombatAnimInStop(animIn)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_OnCombatAnimInStop "..tostring(animIn));
	NecrosisSpellActivationOverlayTexture_ShowCombatMask(animIn);
end

function NecrosisSpellActivationOverlayTexture_OnCombatAnimOutPlay(animOut)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_OnCombatAnimOutPlay "..tostring(animOut));
	NecrosisSpellActivationOverlayTexture_ShowCombatMask(animOut);
end

function NecrosisSpellActivationOverlayTexture_OnFadeInPlay(animGroup)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_OnFadeInPlay "..tostring(animGroup));
	local overlay = animGroup:GetParent();
	overlay:SetAlpha(0);
end

function NecrosisSpellActivationOverlayTexture_OnFadeInFinished(animGroup)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_OnFadeInFinished "..tostring(animGroup));
	local overlay = animGroup:GetParent();
	overlay:SetAlpha(1);
	if ( overlay.pulse.autoPlay and not overlay.pulse:IsPlaying() ) then
		overlay.pulse:Play();
	end
end

function NecrosisSpellActivationOverlayTexture_PreStartPulse(anim)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_PreStartPulse "..tostring(anim));
	local overlay = anim:GetParent():GetParent();
	if ( overlay.combatOnly and overlay.pulse.autoPlay and not overlay.pulse:IsPlaying() ) then
		overlay.pulse:Play();
	end
end

function NecrosisSpellActivationOverlayTexture_OnFadeOutFinished(anim)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayTexture_OnFadeOutFinished "..tostring(anim));
	local overlay = anim:GetRegionParent();
	NecrosisSpellActivationOverlayTexture_TerminateOverlay(overlay);
end

function NecrosisSpellActivationOverlayFrame_OnFadeInFinished(anim)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayFrame_OnFadeInFinished "..tostring(anim));

	if ( not InCombatLockdown() ) then
		-- Fade-out immediately if not in combat
		-- Although it may look counter-intuitive to be out-of-combat during an in-combat animation,
		-- This may actually happen if the in-combat mode was forced to showcase out-of-combat procs e.g., healing-based procs
		local frame = anim:GetParent();
		if ( not frame.disableDimOutOfCombat ) then
			frame.combatAnimOut:Play();
			for _, overlay in ipairs(frame.combatOnlyOverlays) do
				NecrosisSpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut);
			end
		end
	end
end

function NecrosisSpellActivationOverlayFrame_OnEnterCombat(anim)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayFrame_OnEnterCombat "..tostring(anim));
	-- Combat has started, or pseudo-started
	-- A pseudo-start happens when a proc was just triggered and the effect is visible shortly
	-- In this case, the player may or may not be in combat, but overlays will be visible as if in combat
	local frame = anim:GetParent();
	frame.inPseudoCombat = true;
end

function NecrosisSpellActivationOverlayFrame_OnLeaveCombat(anim)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayFrame_OnLeaveCombat "..tostring(anim));
	-- Combat has finished, or pseudo-finished (see NecrosisSpellActivationOverlayFrame_OnEnterCombat)
	local frame = anim:GetParent();
	frame.inPseudoCombat = false;
end

function NecrosisSpellActivationOverlayFrame_SetForceAlpha1(enabled)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayFrame_SetForceAlpha1 "..tostring(enabled));

	local self = NecrosisSpellActivationOverlayFrame;
	if (enabled) then
		if (not self.disableDimOutOfCombat) then
			self.disableDimOutOfCombat = 1;
			self.combatAnimOut:Stop();	--In case we're in the process of animating this out.
			self:SetAlpha(1);
			for _, overlay in ipairs(self.combatOnlyOverlays) do
				overlay.combat.animOut:Stop();
				overlay.texture:SetAlpha(1);
			end
		else
			-- Set last digit
			self.disableDimOutOfCombat = self.disableDimOutOfCombat-self.disableDimOutOfCombat%10+1;
		end
	else
		if (self.disableDimOutOfCombat) then
			-- Reset last digit
			self.disableDimOutOfCombat = self.disableDimOutOfCombat-self.disableDimOutOfCombat%10;

			if (self.disableDimOutOfCombat == 0) then
				self.disableDimOutOfCombat = nil;
				if (not InCombatLockdown()) then
					self.combatAnimOut:Play();
					for _, overlay in ipairs(self.combatOnlyOverlays) do
						NecrosisSpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut);
					end
				end
			end
		end
	end
end

function NecrosisSpellActivationOverlayFrame_SetForceAlpha2(enabled)
	SAO:Trace(Module, "NecrosisSpellActivationOverlayFrame_SetForceAlpha2 "..tostring(enabled));

	local self = NecrosisSpellActivationOverlayFrame;
	if (enabled) then
		if (not self.disableDimOutOfCombat) then
			self.disableDimOutOfCombat = 10;
			self.combatAnimOut:Stop();	--In case we're in the process of animating this out.
			self:SetAlpha(1);
			for _, overlay in ipairs(self.combatOnlyOverlays) do
				overlay.combat.animOut:Stop();
				overlay.texture:SetAlpha(1);
			end
		else
			-- Set second-to-last digit
			self.disableDimOutOfCombat = self.disableDimOutOfCombat%10+10;
		end
	else
		if (self.disableDimOutOfCombat) then
			-- Reset second-to-last digit
			self.disableDimOutOfCombat = self.disableDimOutOfCombat%10;

			if (self.disableDimOutOfCombat == 0) then
				self.disableDimOutOfCombat = nil;
				if (not InCombatLockdown()) then
					self.combatAnimOut:Play();
					for _, overlay in ipairs(self.combatOnlyOverlays) do
						NecrosisSpellActivationOverlayFrame_PlayCombatAnimOut(overlay.combat.animOut);
					end
				end
			end
		end
	end
end
