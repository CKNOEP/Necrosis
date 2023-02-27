----------------------------------------------
--	The codes are based on ElvUI	    --
----------------------------------------------

local AFKS = CreateFrame("Frame")
local AFKMode = true

local wowVersion = nil

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	wowVersion = "classic"
elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
	wowVersion = "wrath"
elseif WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	wowVersion = "retail"
end

--Cache global variables
--Lua functions
local _G = _G
local tostring, pcall = tostring, pcall
local floor = floor
local format, strsub, gsub = format, strsub, gsub
local tonumber = tonumber
--WoW API / Variables
local CloseAllWindows = CloseAllWindows
local CreateFrame = CreateFrame
local GetBattlefieldStatus = GetBattlefieldStatus
local GetGuildInfo = GetGuildInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local IsShiftKeyDown = IsShiftKeyDown
local MoveViewLeftStart = MoveViewLeftStart
local MoveViewLeftStop = MoveViewLeftStop
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
local RemoveExtraSpaces = RemoveExtraSpaces
local Screenshot = Screenshot
local SetCVar = SetCVar
local UnitFactionGroup = UnitFactionGroup
local UnitIsAFK = UnitIsAFK

local GetLocale = GetLocale
local UnitClass = UnitClass
local UnitRace = UnitRace
local GetColoredName = GetColoredName
local GetScreenHeight = GetScreenHeight
local GetScreenWidth = GetScreenWidth
local GetPhysicalScreenSize = GetPhysicalScreenSize
local GetMonitorAspectRatio = GetMonitorAspectRatio
local GetExpansionDisplayInfo = GetExpansionDisplayInfo
local GetExpansionLevel = GetExpansionLevel
local C_TimerNewTimer, C_TimerNewTicker, C_TimerAfter = C_Timer.NewTimer, C_Timer.NewTicker, C_Timer.After
local GameTime_GetLocalTime = GameTime_GetLocalTime

local ChatHistory_GetAccessID = ChatHistory_GetAccessID
local Chat_GetChatCategory = Chat_GetChatCategory
local ChatFrame_GetMobileEmbeddedTexture = ChatFrame_GetMobileEmbeddedTexture

local C_PetBattles_IsInBattle
local C_DateAndTime_GetCurrentCalendarTime
local C_Calendar_GetNumDayEvents
local C_Calendar_GetDayEvent
local C_Club_GetStreamInfo
local C_Club_GetClubInfo
local C_TradeSkillUI_IsRecipeRepeating
local UnitCastingInfo

if wowVersion ~= "classic" then
	C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
end


	UnitCastingInfo = _G.UnitCastingInfo


local MovieFrame = _G.MovieFrame
local CinematicFrame = _G.CinematicFrame

local CAMERA_SPEED = 0.035
local ignoreKeys = {
	LALT = true,
	LSHIFT = true,
	RSHIFT = true,
}
local printKeys = {
	PRINTSCREEN = true,
}

if IsMacClient() then
	printKeys[_G.KEY_PRINTSCREEN_MAC] = true
end

local isCamp = false

SlashCmdList["AFKSCampToggle"] = function()
	if isCamp then
		isCamp = false
		print(AFKS_CAMPOFF)
	else
		isCamp = true
		print(AFKS_CAMPON)
	end
end
SLASH_AFKSCampToggle1 = "/AFKCAMP"

function AFKS:OnEvent(event, ...)
--print (event)
	if event == "PLAYER_REGEN_DISABLED" or event == "LFG_PROPOSAL_SHOW" or event == "UPDATE_BATTLEFIELD_STATUS" or event == "PARTY_INVITE_REQUEST" then
		if event == "UPDATE_BATTLEFIELD_STATUS" then
			local status = GetBattlefieldStatus(...)
			if status == "confirm" then
				self:SetAFK(false)
			end
		else
			self:SetAFK(false)
		end

		if event == "PLAYER_REGEN_DISABLED" then
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
			if self.isAFK then
				self.isInterrupted = true
			end
		end
		return
	end

	if event == "VIGNETTE_MINIMAP_UPDATED" and self.isAFK then
		C_TimerAfter(0.5, function() self:SetAFK(false) end)
	end

	if event == "TALKINGHEAD_REQUESTED" and self.isAFK then
		self:SetAFK(false)
	end

	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		if self.isInterrupted then
			C_TimerAfter(0.5, function() self:SetAFK(false) end)
			self.isInterrupted = false
		end
	end
	if event == "PLAYER_CONTROL_GAINED" and UnitOnTaxi("player") then
		if ((wowVersion == "classic" or wowVersion == "wrath") and GetPVPDesired()) or (wowVersion == "retail" and UnitIsPVP("player")) then
			self:SetAFK(false)
		end
	end

	if (not AFKMode or UnitInParty("player") or UnitInRaid("player") or (wowVersion == "retail" and C_PetBattles_IsInBattle())) then return end
	if (wowVersion == "classic" or wowVersion == "wrath") and GetPVPDesired() then
		self:SetAFK(UnitIsAFK('player'))	
		
		return
	elseif UnitIsPVP("player") and not IsResting() then
	
		return
	end
	if (InCombatLockdown() or CinematicFrame:IsShown() or MovieFrame:IsShown()) then return end
	if wowVersion == "retail" then
		if C_TradeSkillUI_IsRecipeRepeating() then
			 --Don't activate afk if player is crafting stuff, check back in 30 seconds
			C_TimerAfter(30, function() self:OnEvent() end)
			return
		end
	else
		if UnitCastingInfo("player") ~= nil then
			 --Don't activate afk if player is crafting stuff, check back in 30 seconds
			C_TimerAfter(30, function() self:OnEvent() end)
			return
		end
	end
	
	if UnitIsAFK("player") and not self.isAFK then
		if wowVersion == "retail" and _G.PVEFrame and _G.PVEFrame:IsShown() or isCamp then return end
		self:SetAFK(true)
	else
		self:SetAFK(false)
	end
end

function AFKS:Toggle()
	if(AFKMode) then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED", "OnEvent")
		self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
		self:RegisterEvent("PLAYER_CONTROL_GAINED", "OnEvent")
		self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", "OnEvent")
		if wowVersion == "retail" then
			self:RegisterEvent("LFG_PROPOSAL_SHOW", "OnEvent")
			self:RegisterEvent("PARTY_INVITE_REQUEST", "OnEvent")
			self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED", "OnEvent")
			self:RegisterEvent("TALKINGHEAD_REQUESTED", "OnEvent")
		end
		self:SetScript("OnEvent", function(event, ...)
			self:OnEvent(...)
		end)
		SetCVar("autoClearAFK", "1")
	else
		self:UnregisterEvent("PLAYER_FLAGS_CHANGED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("PLAYER_CONTROL_GAINED")
		self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
		if wowVersion == "retail" then
			self:UnregisterEvent("LFG_PROPOSAL_SHOW")
			self:UnregisterEvent("PARTY_INVITE_REQUEST")
			self:UnregisterEvent("VIGNETTE_MINIMAP_UPDATED")
			self:UnregisterEvent("TALKINGHEAD_REQUESTED")
		end
	end
end

local function OnKeyDown(self, key)
	if(ignoreKeys[key]) then return end
	if printKeys[key] then
		Screenshot()
	else
		if InCombatLockdown() then return end
		AFKS:SetAFK(false)
		C_TimerAfter(60, function() AFKS:OnEvent() end)
	end
end

local function Chat_OnMouseWheel(self, delta)
	if delta == 1 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			self:ScrollUp()
		end
	elseif delta == -1 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			self:ScrollDown()
		end
	end
end

local function TruncateToMaxLength(text, maxLength)
	local length = strlenutf8(text)
	if ( length > maxLength ) then
		return text:sub(1, maxLength - 2).."..."
	end
	return text
end

local function ResolvePrefixChannelName(communityChannel)
	local communityName = ""
	local prefix, channelCode = communityChannel:match("(%d+. )(.*)")
	local clubId, streamId = channelCode:match("(%d+)%:(%d+)")
	clubId = tonumber(clubId)
	streamId = tonumber(streamId)

	local streamInfo = C_Club_GetStreamInfo(clubId, streamId)
	if streamInfo and streamInfo.streamType == 0 then
		local clubInfo = C_Club_GetClubInfo(clubId)
		communityName = clubInfo and TruncateToMaxLength(clubInfo.shortName or clubInfo.name, 12) or ""
	end
	
	return prefix..communityName
end

--[[
local function GetBNFriendColor(name, id, useBTag)
	local _, _, battleTag, _, _, bnetIDGameAccount = BNGetFriendInfoByID(id)
	local TAG = useBTag and battleTag and strmatch(battleTag,'([^#]+)')
	local Class

	if not bnetIDGameAccount then --dont know how this is possible
		local firstToonClass = getFirstToonClassColor(id)
		if firstToonClass then
			Class = firstToonClass
		else
			return TAG or name
		end
	end

	if not Class then
		_, _, _, _, _, _, _, Class = BNGetGameAccountInfo(bnetIDGameAccount)
	end

	if Class and Class ~= '' then --other non-english locales require this
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if Class == v then Class = k;break end end
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if Class == v then Class = k;break end end
	end

	local CLASS = Class and Class ~= '' and gsub(strupper(Class),'%s','')
	local COLOR = CLASS and classcolors[CLASS]

	return (COLOR and format('|c%s%s|r', COLOR.colorStr, TAG or name)) or TAG or name
end
]]

local function Chat_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
	local coloredName = GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
	local type = strsub(event, 10)
	local info = _G.ChatTypeInfo[type]
--[[
	if(event == "CHAT_MSG_BN_WHISPER") then
		coloredName = GetBNFriendColor(arg2, arg13)
	end
]]
	arg1 = RemoveExtraSpaces(arg1)

	local chatGroup = Chat_GetChatCategory(type)
	local chatTarget, body
	if ( chatGroup == "BN_CONVERSATION" ) then
		chatTarget = tostring(arg8)
	elseif ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
		if(not(strsub(arg2, 1, 2) == "|K")) then
			chatTarget = arg2:upper()
		else
			chatTarget = arg2
		end
	end

	local playerLink
	if ( type ~= "BN_WHISPER" and type ~= "BN_CONVERSATION" ) then
		playerLink = "|Hplayer:"..arg2..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h"
	else
		playerLink = "|HBNplayer:"..arg2..":"..arg13..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h"
	end

	local message = arg1
	if ( arg14 ) then	--isMobile
		message = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)..message
	end
	
	--Escape any % characters, as it may otherwise cause an "invalid option in format" error in the next step
	message = gsub(message, "%%", "%%%%")

	local success
	success, body = pcall(format, _G["CHAT_"..type.."_GET"]..message, playerLink.."["..coloredName.."]".."|h")
	if not success then
		print("Error:", type, message, _G["CHAT_"..type.."_GET"])
	end
	if event == "CHAT_MSG_COMMUNITIES_CHANNEL" then
		body = "[" .. ResolvePrefixChannelName(arg4) .. "] " .. body
	end

	if event == "CHAT_MSG_CHANNEL" then
		if arg7 == 1 or arg7 == 2 or arg7 == 22 or arg7 == 42 then
			return
		end
		if arg7 == 26 then -- private channel filter
			return
		end
		body = "[" .. arg4 .. "] " .. body
	end

	local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget)
	local typeID = ChatHistory_GetAccessID(type, chatTarget, arg12 == "" and arg13 or arg12)

	self:AddMessage(body, info.r, info.g, info.b, info.id, false, accessID, typeID)
end

local function LoopAnimations()
	if(AFKSPlayerModel.curAnimation == "wave") then
		AFKSPlayerModel:SetAnimation(69)
		AFKSPlayerModel.curAnimation = "dance"
		AFKSPlayerModel.startTime = GetTime()
		AFKSPlayerModel.duration = 300
		AFKSPlayerModel.isIdle = false
		AFKSPlayerModel.idleDuration = 120
	end
end

local function FontTemplate(fs, fontSize, outline)
	fs.font = _G.STANDARD_TEXT_FONT
	fs.fontSize = fontSize

	fontSize = fontSize or 12

	if not outline then
		outline = ""
	end
	fs:SetFont(_G.STANDARD_TEXT_FONT, fontSize, outline)
	fs:SetShadowColor(0, 0, 0, 1)
	fs:SetShadowOffset(1, -1)
end

local function SetTemplate(Frame)
	local blank = "Interface/BUTTONS/WHITE8X8"

	Frame:SetBackdrop({
		bgFile = blank,
		edgeFile = blank,
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = -1, right = -1, top = -1, bottom = -1},
	})

	if not Frame.isInsetDone then
		Frame.InsetTop = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetTop:SetPoint("TOPLEFT", Frame, "TOPLEFT", -1, 1)
		Frame.InsetTop:SetPoint("TOPRIGHT", Frame, "TOPRIGHT", 1, -1)
		Frame.InsetTop:SetHeight(1)
		Frame.InsetTop:SetColorTexture(0,0,0)
		Frame.InsetTop:SetDrawLayer("BORDER", -7)

		Frame.InsetBottom = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetBottom:SetPoint("BOTTOMLEFT", Frame, "BOTTOMLEFT", -1, -1)
		Frame.InsetBottom:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", 1, -1)
		Frame.InsetBottom:SetHeight(1)
		Frame.InsetBottom:SetColorTexture(0,0,0)
		Frame.InsetBottom:SetDrawLayer("BORDER", -7)

		Frame.InsetLeft = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetLeft:SetPoint("TOPLEFT", Frame, "TOPLEFT", -1, 1)
		Frame.InsetLeft:SetPoint("BOTTOMLEFT", Frame, "BOTTOMLEFT", 1, -1)
		Frame.InsetLeft:SetWidth(1)
		Frame.InsetLeft:SetColorTexture(0,0,0)
		Frame.InsetLeft:SetDrawLayer("BORDER", -7)

		Frame.InsetRight = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetRight:SetPoint("TOPRIGHT", Frame, "TOPRIGHT", 1, 1)
		Frame.InsetRight:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", -1, -1)
		Frame.InsetRight:SetWidth(1)
		Frame.InsetRight:SetColorTexture(0,0,0)
		Frame.InsetRight:SetDrawLayer("BORDER", -7)

		Frame.InsetInsideTop = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetInsideTop:SetPoint("TOPLEFT", Frame, "TOPLEFT", 1, -1)
		Frame.InsetInsideTop:SetPoint("TOPRIGHT", Frame, "TOPRIGHT", -1, 1)
		Frame.InsetInsideTop:SetHeight(1)
		Frame.InsetInsideTop:SetColorTexture(0,0,0)
		Frame.InsetInsideTop:SetDrawLayer("BORDER", -7)

		Frame.InsetInsideBottom = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetInsideBottom:SetPoint("BOTTOMLEFT", Frame, "BOTTOMLEFT", 1, 1)
		Frame.InsetInsideBottom:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", -1, 1)
		Frame.InsetInsideBottom:SetHeight(1)
		Frame.InsetInsideBottom:SetColorTexture(0,0,0)
		Frame.InsetInsideBottom:SetDrawLayer("BORDER", -7)

		Frame.InsetInsideLeft = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetInsideLeft:SetPoint("TOPLEFT", Frame, "TOPLEFT", 1, -1)
		Frame.InsetInsideLeft:SetPoint("BOTTOMLEFT", Frame, "BOTTOMLEFT", -1, 1)
		Frame.InsetInsideLeft:SetWidth(1)
		Frame.InsetInsideLeft:SetColorTexture(0,0,0)
		Frame.InsetInsideLeft:SetDrawLayer("BORDER", -7)

		Frame.InsetInsideRight = Frame:CreateTexture(nil, "BORDER")
		Frame.InsetInsideRight:SetPoint("TOPRIGHT", Frame, "TOPRIGHT", -1, -1)
		Frame.InsetInsideRight:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", 1, 1)
		Frame.InsetInsideRight:SetWidth(1)
		Frame.InsetInsideRight:SetColorTexture(0,0,0)
		Frame.InsetInsideRight:SetDrawLayer("BORDER", -7)

		Frame.isInsetDone = true
	end

	Frame:SetBackdropBorderColor(.31, .31, .31)
	if wowVersion == "retail" then
		Frame:SetBackdropColor(.06, .06, .06, 0)
	else
		Frame:SetBackdropColor(.06, .06, .06, .8)
	end
end




function AFKS:Init()
	
	local class = select(2, UnitClass("player"))
	
	self.AFKMode = CreateFrame("Frame", "AFKSFrame")
	self.AFKMode:SetFrameLevel(1)
	self.AFKMode:SetScale(_G.UIParent:GetScale())
	self.AFKMode:SetAllPoints(_G.UIParent)
	self.AFKMode:Hide()
	self.AFKMode:EnableKeyboard(true)
	self.AFKMode:SetScript("OnKeyDown", OnKeyDown)

	self.AFKMode.chat = CreateFrame("ScrollingMessageFrame", nil, self.AFKMode)
	self.AFKMode.chat:SetSize(500, 300)
	self.AFKMode.chat:SetPoint("BOTTOMLEFT", self.AFKMode, "BOTTOMLEFT", 4, 120)
	FontTemplate(self.AFKMode.chat, 18)
	self.AFKMode.chat:SetJustifyH("LEFT")
	self.AFKMode.chat:SetMaxLines(500)
	self.AFKMode.chat:EnableMouseWheel(true)
	self.AFKMode.chat:SetFading(false)
	self.AFKMode.chat:SetMovable(true)
	self.AFKMode.chat:EnableMouse(true)
	self.AFKMode.chat:RegisterForDrag("LeftButton")
	self.AFKMode.chat:SetScript("OnDragStart", self.AFKMode.chat.StartMoving)
	self.AFKMode.chat:SetScript("OnDragStop", self.AFKMode.chat.StopMovingOrSizing)
	self.AFKMode.chat:SetScript("OnMouseWheel", Chat_OnMouseWheel)
	self.AFKMode.chat:SetScript("OnEvent", Chat_OnEvent)

	self.AFKMode.bottom = CreateFrame("Frame", nil, self.AFKMode, BackdropTemplateMixin and "BackdropTemplate")
	self.AFKMode.bottom:SetFrameLevel(0)
	SetTemplate(self.AFKMode.bottom)
	self.AFKMode.bottom:SetPoint("BOTTOM", self.AFKMode, "BOTTOM", 0, -2)
	self.AFKMode.bottom:SetWidth(GetScreenWidth() + 4)
	self.AFKMode.bottom:SetHeight(GetScreenHeight() * (1 / 10))

	self.AFKMode.bottom.logo = self.AFKMode:CreateTexture(nil, 'OVERLAY')
	self.AFKMode.bottom.logo:SetSize(474, 474)
	self.AFKMode.bottom.logo:SetPoint("CENTER", self.AFKMode.bottom, "CENTER", 0, -10)
	self.AFKMode.bottom.logo:SetTexture("Interface\\AddOns\\Necrosis\\XML\\Interface\\logo.blp")


	self.AFKMode.bottom.specpanel = self.AFKMode.bottom:CreateTexture(nil, 'BACKGROUND')
	self.AFKMode.bottom.specpanel:SetSize(GetScreenWidth(), GetScreenHeight() * (1 / 10))
	self.AFKMode.bottom.specpanel:SetPoint("BOTTOM", self.AFKMode, "BOTTOM", 0, -2 )
	self.AFKMode.bottom.specpanel:SetTexture("interface/artifacts/artifactuiwarlock")
	local info = C_Texture.GetAtlasInfo("Artifacts-Warlock-BG")
	self.AFKMode.bottom.specpanel:SetTexCoord(info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord)

	local factionGroup = UnitFactionGroup("player")
	local size, offsetX, offsetY = 140, -20, -16
	local nameOffsetX, nameOffsetY = -10, -28
	local ratio = tonumber(strsub(GetMonitorAspectRatio(), 0, 3))
	
	if ratio == 1.6 then
		nameOffsetY = -45 -- 16:10 monitor ratio fix
	end
	
	self.AFKMode.bottom.faction = self.AFKMode.bottom:CreateTexture(nil, 'OVERLAY')
	self.AFKMode.bottom.faction:SetPoint("BOTTOMLEFT", self.AFKMode.bottom, "BOTTOMLEFT", offsetX, offsetY)
	self.AFKMode.bottom.faction:SetTexture("Interface\\Timer\\"..factionGroup.."-Logo")
	self.AFKMode.bottom.faction:SetSize(size, size)

	self.AFKMode.bottom.name = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	FontTemplate(self.AFKMode.bottom.name, 20, "OUTLINE")
	self.AFKMode.bottom.name:SetText(format("%s-%s", UnitName("player"), GetRealmName()))
	self.AFKMode.bottom.name:SetPoint("TOPLEFT", self.AFKMode.bottom.faction, "TOPRIGHT", nameOffsetX, nameOffsetY)
	self.AFKMode.bottom.name:SetTextColor(_G.RAID_CLASS_COLORS[class].r, _G.RAID_CLASS_COLORS[class].g, _G.RAID_CLASS_COLORS[class].b)

	self.AFKMode.bottom.guild = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	FontTemplate(self.AFKMode.bottom.guild, 20, "OUTLINE")
	self.AFKMode.bottom.guild:SetText(AFKS_NOGUILD)
	self.AFKMode.bottom.guild:SetPoint("TOPLEFT", self.AFKMode.bottom.name, "BOTTOMLEFT", 0, -6)
	self.AFKMode.bottom.guild:SetTextColor(0.7, 0.7, 0.7)

	self.AFKMode.bottom.time = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	FontTemplate(self.AFKMode.bottom.time, 20, "OUTLINE")
	self.AFKMode.bottom.time:SetText("00:00")
	self.AFKMode.bottom.time:SetPoint("TOPLEFT", self.AFKMode.bottom.guild, "BOTTOMLEFT", 0, -6)
	self.AFKMode.bottom.time:SetTextColor(0.7, 0.7, 0.7)

	self.AFKMode.bottom.date = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	FontTemplate(self.AFKMode.bottom.date, 20, "OUTLINE")
	self.AFKMode.bottom.date:SetPoint("RIGHT", self.AFKMode.bottom, "RIGHT", -10, 6)
	self.AFKMode.bottom.date:SetTextColor(0.7, 0.7, 0.7)

	--Use this frame to control position of the model
	self.AFKMode.bottom.modelHolder = CreateFrame("Frame", nil, self.AFKMode.bottom)
	self.AFKMode.bottom.modelHolder:SetSize(150, 150)

	self.AFKMode.bottom.modelHolder:SetPoint("BOTTOMRIGHT", self.AFKMode.bottom, "BOTTOMRIGHT", -220, 220)



	self.AFKMode.bottom.model = CreateFrame("PlayerModel", "AFKSPlayerModel", self.AFKMode.bottom.modelHolder)
	self.AFKMode.bottom.model:SetPoint("CENTER", self.AFKMode.bottom.modelHolder, "CENTER")
	self.AFKMode.bottom.model:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2)
	self.AFKMode.bottom.model:SetCamDistanceScale(4.5) --Since the model frame is huge, we need to zoom out quite a bit.
	self.AFKMode.bottom.model:SetFacing(6)
	self.AFKMode.bottom.model:SetScript("OnUpdate", function(self)
		local timePassed = GetTime() - self.startTime
		if(timePassed > self.duration) and self.isIdle ~= true then
			self:SetAnimation(0)
			self.isIdle = true
			AFKS.animTimer = C_TimerNewTimer(self.idleDuration, LoopAnimations)
		end
	end)

	self.isInterrupted = false
	self:Toggle()
end


do
	AFKS:Init()

	if wowVersion == "retail" then
		hooksecurefunc ("LFGListInviteDialog_Show", function()
			if not InCombatLockdown() then
				AFKS:SetAFK(false)
			end
		end)
	end
end

function AFKS:UpdateTimer()
	local curtime = GetTime() - self.startTime
	if wowVersion == "classic" then
		self.AFKMode.bottom.date:SetText(format("%s", GameTime_GetLocalTime(true)))
	else
		local today = C_DateAndTime_GetCurrentCalendarTime()
		local _, _, month, day, year = today.hour, today.minute, today.month, today.monthDay, today.year
		local weekday = _G.CALENDAR_WEEKDAY_NAMES[today.weekday]

		if today.weekday == 7 then
			weekday = "|cFF2b59FF"..weekday.."|r"
		elseif today.weekday == 1 then
			weekday = "|cFFFF2b2b"..weekday.."|r"
		end

		if GetLocale() == "koKR" or GetLocale() == "zhCN" or GetLocale() == "zhTW" then -- East Asia date format check
			self.AFKMode.bottom.date:SetText(format(AFKS_DATEFORMAT, year, month, day, weekday, GameTime_GetLocalTime(true)))
		elseif GetLocale() == "frFR" then
		    self.AFKMode.bottom.date:SetText(format(AFKS_DATEFORMAT, day, month, year, weekday, GameTime_GetLocalTime(true)))
		else
			self.AFKMode.bottom.date:SetText(format(AFKS_DATEFORMAT, month, day, year, weekday, GameTime_GetLocalTime(true)))
		end
	end
	self.AFKMode.bottom.time:SetText(format("%02d:%02d", floor(curtime/60), curtime % 60))
end

function AFKS:SetAFK(status)

	if NecrosisConfig.AFK == false then 
	return 
	end
	
	if(status) then
		MoveViewLeftStart(CAMERA_SPEED)
		self.AFKMode:Show()
		CloseAllWindows()
		_G.UIParent:Hide()

		if(IsInGuild()) then
			local guildName, guildRankName = GetGuildInfo("player")
			self.AFKMode.bottom.guild:SetText(format("%s-%s", guildName, guildRankName))
		else
			self.AFKMode.bottom.guild:SetText(AFKS_NOGUILD)
		end



		self.AFKMode.bottom.model.curAnimation = "wave"
		self.AFKMode.bottom.model.startTime = GetTime()
		self.AFKMode.bottom.model.duration = 2.3
		self.AFKMode.bottom.model:SetUnit("player")
		self.AFKMode.bottom.model.isIdle = nil
		self.AFKMode.bottom.model:SetAnimation(67)
		self.AFKMode.bottom.model.idleDuration = 40
		self.startTime = GetTime()
		self.timer = C_TimerNewTicker(1, function() self:UpdateTimer() end)

		self.AFKMode.chat:RegisterEvent("CHAT_MSG_WHISPER")
		self.AFKMode.chat:RegisterEvent("CHAT_MSG_BN_WHISPER")
		self.AFKMode.chat:RegisterEvent("CHAT_MSG_GUILD")
		self.AFKMode.chat:RegisterEvent("CHAT_MSG_PARTY")
		self.AFKMode.chat:RegisterEvent("CHAT_MSG_PARTY_LEADER")
		self.AFKMode.chat:RegisterEvent("CHAT_MSG_RAID")
		self.AFKMode.chat:RegisterEvent("CHAT_MSG_RAID_LEADER")
		self.AFKMode.chat:RegisterEvent("CHAT_MSG_CHANNEL")
		if wowVersion == "retail" then
			self.AFKMode.chat:RegisterEvent("CHAT_MSG_COMMUNITIES_CHANNEL")
		end

		self.isAFK = true
	elseif(self.isAFK) then
		_G.UIParent:Show()
		self.AFKMode:Hide()
		MoveViewLeftStop();

		self.timer:Cancel()
		if self.animTimer then
			self.animTimer:Cancel()
		end
		self.AFKMode.bottom.time:SetText("00:00")

		self.AFKMode.chat:UnregisterAllEvents()
		self.AFKMode.chat:Clear()
		if wowVersion == "retail" and _G.PVEFrame:IsShown() then --odd bug, frame is blank
			PVEFrame_ToggleFrame()
			PVEFrame_ToggleFrame()
		end

		self.isAFK = false
	end
end
