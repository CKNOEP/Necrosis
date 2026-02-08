local AddonName,SAO=...
local iamNecrosis=strlower(AddonName):sub(0,8)=="necrosis"
local GetAddOnMetadata=C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
function NecrosisSpellActivationOverlayOptionsPanel_Init(self)
local shutdownCategory=SAO.Shutdown:GetCategory()
if shutdownCategory then
if shutdownCategory.Reason then
local globalOffReason=NecrosisSpellActivationOverlayOptionsPanel.globalOff.reason
globalOffReason:SetText("("..shutdownCategory.Reason..")")
end
if shutdownCategory.Button then
local globalOffButton=NecrosisSpellActivationOverlayOptionsPanel.globalOff.button
globalOffButton:SetText(shutdownCategory.Button.Text)
local estimatedWidth=(2+strlenutf8(shutdownCategory.Button.Text))*8
globalOffButton:SetWidth(estimatedWidth)
if estimatedWidth > 48 then
globalOffButton:SetHeight(globalOffButton:GetHeight()+ceil((estimatedWidth-32)/16))
end
globalOffButton:SetScript("OnClick",shutdownCategory.Button.OnClick)
globalOffButton:Show()
end
if shutdownCategory.DisableCondition then
local disableCondition=SAO.Shutdown:GetCategory().DisableCondition
local disableConditionButton=NecrosisSpellActivationOverlayOptionsPanelDisableConditionButton
disableConditionButton.Text:SetText(disableCondition.Text)
disableConditionButton.OnValueChanged=function(self,checked)
if checked then
disableCondition.OnValueChanged(self,true)
NecrosisSpellActivationOverlayOptionsPanel.globalOff:Show()
local testButton=NecrosisSpellActivationOverlayOptionsPanelSpellAlertTestButton
if testButton.isTesting then
testButton:StopTest()
end
else
disableCondition.OnValueChanged(self,false)
NecrosisSpellActivationOverlayOptionsPanel.globalOff:Hide()
end
end
disableConditionButton:SetChecked(SAO.Shutdown:IsAddonDisabled())
disableConditionButton:OnValueChanged(disableConditionButton:GetChecked())
if disableCondition.ShowIf==nil or disableCondition.ShowIf()then
disableConditionButton:Show()
end
else
NecrosisSpellActivationOverlayOptionsPanel.globalOff:Show()
end
end
local mustDisableGlowForEveryone=false
if not shutdownCategory and mustDisableGlowForEveryone then
NecrosisSpellActivationOverlayOptionsPanel.glowOff:Show()
else
NecrosisSpellActivationOverlayOptionsPanel.glowOff:Hide()
end
local buildInfoLabel=NecrosisSpellActivationOverlayOptionsPanelBuildInfo
local xSaoBuild=GetAddOnMetadata(AddonName, "X-SAO-Build")
if type(xSaoBuild)=='string' and #xSaoBuild > 0 then
local titleText=GetAddOnMetadata(AddonName, "Title")
if xSaoBuild=="universal" then
local universalText=SAO:gradientText(
SAO:universalBuild(),
{
{r=0.1,g=1,b=0.3},
{r=1,g=1,b=0.5},
{r=0.9,g=0.1,b=0},
{r=0.7,g=0,b=0.8},
{r=0,g=0.3,b=1},
}
)
buildInfoLabel:SetText(titleText.."\n"..universalText)
elseif xSaoBuild=="dev" then
local buildForDevs=SAO:gradientText(
"Build for Developers",
{
{r=0,g=0.3,b=1},
{r=1,g=1,b=1},
{r=0,g=0.3,b=1},
}
)
buildInfoLabel:SetText(titleText.."\n"..buildForDevs)
else
local addonBuild=SAO.GetFullProjectName(xSaoBuild)
local expectedBuild=SAO.GetFullProjectName(SAO.GetExpectedBuildID())
if addonBuild~=expectedBuild then
titleText=WrapTextInColorCode(titleText, "ffff0000")
addonBuild=WrapTextInColorCode(addonBuild, "ffff0000")
expectedBuild=WrapTextInColorCode(expectedBuild, "ffff0000")
buildInfoLabel:SetFontObject(GameFontNormalLarge)
SAO:Info("",SAO:compatibilityWarning(addonBuild,expectedBuild))
end
local optimizedForText
if xSaoBuild=="vanilla" then
if addonBuild==expectedBuild then
optimizedForText=SAO:optimizedFor(BNET_FRIEND_TOOLTIP_WOW_CLASSIC)
else
optimizedForText=SAO:optimizedFor(WrapTextInColorCode(BNET_FRIEND_TOOLTIP_WOW_CLASSIC, "ffff0000"))
end
else
optimizedForText=SAO:optimizedFor(string.format(BNET_FRIEND_ZONE_WOW_CLASSIC,addonBuild))
end
local subProjectName=SAO.GetSubProjectName(xSaoBuild)
if subProjectName then
optimizedForText=optimizedForText .. " (" .. subProjectName .. ")"
end
buildInfoLabel:SetText(titleText.."\n"..optimizedForText)
end
end
local classInfoLabel=NecrosisSpellActivationOverlayOptionsPanelClassInfo
if SAO.CurrentClass then
local className,classFile,classId=SAO.CurrentClass.Intrinsics[1],SAO.CurrentClass.Intrinsics[2],SAO.CurrentClass.Intrinsics[3]
local gradientColors
if classFile=="PRIEST" then
gradientColors={
{r=0.8,g=0.8,b=0.8},
RAID_CLASS_COLORS[classFile],
{r=0.9,g=0.9,b=0.9},
{r=0.7,g=0.7,b=0.7},
}
else
local function mixColors(color1,color2,t)
return {
r=color1.r * (1 - t) + color2.r * t,
g=color1.g * (1 - t) + color2.g * t,
b=color1.b * (1 - t) + color2.b * t,
}
end
local classColor=RAID_CLASS_COLORS[classFile]
gradientColors={
classColor,
mixColors(classColor,{r=1,g=1,b=1},0.25),
classColor,
mixColors(classColor,{r=0,g=0,b=0},0.15),
}
end
local classIcons={
["DEATHKNIGHT"]="Interface/Icons/Spell_Deathknight_ClassIcon",
["DRUID"]="Interface/Icons/ClassIcon_Druid",
["HUNTER"]="Interface/Icons/ClassIcon_Hunter",
["MAGE"]="Interface/Icons/ClassIcon_Mage",
["MONK"]="Interface/Icons/ClassIcon_Monk",
["PALADIN"]="Interface/Icons/ClassIcon_Paladin",
["PRIEST"]="Interface/Icons/ClassIcon_Priest",
["ROGUE"]="Interface/Icons/ClassIcon_Rogue",
["SHAMAN"]="Interface/Icons/ClassIcon_Shaman",
["WARLOCK"]="Interface/Icons/ClassIcon_Warlock",
["WARRIOR"]="Interface/Icons/ClassIcon_Warrior",
}
local classIcon=classIcons[classFile] or "Interface/Icons/INV_Misc_QuestionMark"
local classText=SAO:gradientText(className,gradientColors)
classInfoLabel:SetText(string.format("|T%s:16:16:0:0:512:512:32:480:32:480|t %s",classIcon,classText))
else
classInfoLabel:SetText("")
end
local opacitySlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertOpacitySlider
opacitySlider.Text:SetText(SPELL_ALERT_OPACITY)
_G[opacitySlider:GetName().."Low"]:SetText(OFF)
opacitySlider:SetMinMaxValues(0,1)
opacitySlider:SetValueStep(0.05)
opacitySlider.initialValue=NecrosisConfig.alert.opacity
opacitySlider:SetValue(opacitySlider.initialValue)
opacitySlider.ApplyValueToEngine=function(self,value)
NecrosisConfig.alert.opacity=value
NecrosisConfig.alert.enabled=value > 0
SAO:ApplySpellAlertOpacity()
end
local scaleSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertScaleSlider
scaleSlider.Text:SetText("Spell Alert Scale")
_G[scaleSlider:GetName().."Low"]:SetText(SMALL)
_G[scaleSlider:GetName().."High"]:SetText(LARGE)
scaleSlider:SetMinMaxValues(0.25,2.5)
scaleSlider:SetValueStep(0.05)
scaleSlider.initialValue=NecrosisConfig.alert.scale
scaleSlider:SetValue(scaleSlider.initialValue)
scaleSlider.ApplyValueToEngine=function(self,value)
NecrosisConfig.alert.scale=value
SAO:ApplySpellAlertGeometry()
end
local offsetSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertOffsetSlider
offsetSlider.Text:SetText("Spell Alert Offset")
_G[offsetSlider:GetName().."Low"]:SetText(NEAR)
_G[offsetSlider:GetName().."High"]:SetText(FAR)
offsetSlider:SetMinMaxValues(-200,400)
offsetSlider:SetValueStep(20)
offsetSlider.initialValue=NecrosisConfig.alert.offset
offsetSlider:SetValue(offsetSlider.initialValue)
offsetSlider.ApplyValueToEngine=function(self,value)
NecrosisConfig.alert.offset=value
SAO:ApplySpellAlertGeometry()
end
local timerSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertTimerSlider
timerSlider.Text:SetText("Spell Alert Progressive Timer")
_G[timerSlider:GetName().."Low"]:SetText(DISABLE)
_G[timerSlider:GetName().."High"]:SetText(ENABLE)
timerSlider:SetMinMaxValues(0,1)
timerSlider:SetValueStep(1)
timerSlider.initialValue=NecrosisConfig.alert.timer
timerSlider:SetValue(timerSlider.initialValue)
timerSlider.ApplyValueToEngine=function(self,value)
NecrosisConfig.alert.timer=value
SAO:ApplySpellAlertTimer()
end
local soundSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertSoundSlider
soundSlider.Text:SetText("Spell Alert Sound Effect")
_G[soundSlider:GetName().."Low"]:SetText(DISABLE)
_G[soundSlider:GetName().."High"]:SetText(ENABLE)
soundSlider:SetMinMaxValues(0,1)
soundSlider:SetValueStep(1)
soundSlider.initialValue=NecrosisConfig.alert.sound
soundSlider:SetValue(soundSlider.initialValue)
soundSlider.ApplyValueToEngine=function(self,value)
NecrosisConfig.alert.sound=value
SAO:ApplySpellAlertSound()
end
local testButton=NecrosisSpellActivationOverlayOptionsPanelSpellAlertTestButton
testButton:SetText("Toggle Test")
testButton.fakeSpellID=42
testButton.isTesting=false
local testTextureLeftRight=SAO.IsEra() and "echo_of_the_elements" or "imp_empowerment"
local testTextureTop=SAO.IsEra() and "fury_of_stormrage" or "brain_freeze"
local testPositionTop=SAO.IsCata() and "Top (CW)" or "Top"
testButton.StartTest=function(self)
if (not self.isTesting)then
self.isTesting=true
SAO:ActivateOverlay(0,self.fakeSpellID,SAO.TexName[testTextureLeftRight], "Left + Right (Flipped)",1,255,255,255,false,nil,GetTime()+5,false,{strata="DIALOG",level=9999})
SAO:ActivateOverlay(0,self.fakeSpellID,SAO.TexName[testTextureTop] ,testPositionTop ,1,255,255,255,false,nil,GetTime()+5,false,{strata="DIALOG",level=9999})
self.testTimerTicker=C_Timer.NewTicker(4.9,
function()
SAO:RefreshOverlayTimer(self.fakeSpellID,GetTime()+5)
end)
NecrosisSpellActivationOverlayFrame_SetForceAlpha1(true)
end
end
testButton.StopTest=function(self)
if (self.isTesting)then
self.isTesting=false
self.testTimerTicker:Cancel()
SAO:DeactivateOverlay(self.fakeSpellID)
NecrosisSpellActivationOverlayFrame_SetForceAlpha1(false)
end
end
testButton:SetEnabled(NecrosisConfig.alert.enabled)
SAO:MarkTexture(testTextureLeftRight)
SAO:MarkTexture(testTextureTop)
local debugButton=NecrosisSpellActivationOverlayOptionsPanelSpellAlertDebugButton
debugButton.Text:SetText(SAO:optionDebugToChatbox())
debugButton:SetChecked(NecrosisConfig.debug==true)
local reportButton=NecrosisSpellActivationOverlayOptionsPanelSpellAlertReportButton
if SAO:CanReport()then
reportButton.Text:SetText(SAO:reportUnsupportedOverlays())
reportButton:SetChecked(NecrosisConfig.report~=false)
else
reportButton:Hide()
end
local responsiveButton=NecrosisSpellActivationOverlayOptionsPanelSpellAlertResponsiveButton
responsiveButton.Text:SetText(SAO:responsiveMode())
responsiveButton:SetChecked(NecrosisConfig.responsiveMode==true)
local askDisableGameAlertButton=NecrosisSpellActivationOverlayOptionsPanelSpellAlertAskDisableGameAlertButton
if SAO:IsQuestionPossible(SAO.QUESTIONS.DISABLE_GAME_ALERT)then
askDisableGameAlertButton:Show()
askDisableGameAlertButton.Text:SetText(SAO:askToDisableGameAlerts())
askDisableGameAlertButton:SetChecked(not NecrosisConfig.questions or NecrosisConfig.questions.disableGameAlert~="no")
askDisableGameAlertButton.OnValueChanged=function(self,checked)
NecrosisConfig.questions=NecrosisConfig.questions or {}
if checked then
NecrosisConfig.questions.disableGameAlert=nil
SAO:AskQuestion(SAO.QUESTIONS.DISABLE_GAME_ALERT)
else
NecrosisConfig.questions.disableGameAlert="no"
SAO:CancelQuestion(SAO.QUESTIONS.DISABLE_GAME_ALERT)
end
end
else
askDisableGameAlertButton:Hide()
local anchorBuildInfo={NecrosisSpellActivationOverlayOptionsPanelBuildInfo:GetPoint(1)}
NecrosisSpellActivationOverlayOptionsPanelBuildInfo:SetPoint(anchorBuildInfo[1],anchorBuildInfo[2],anchorBuildInfo[3],anchorBuildInfo[4],anchorBuildInfo[5] - 24)
end
local glowingButtonCheckbox=NecrosisSpellActivationOverlayOptionsPanelGlowingButtons
glowingButtonCheckbox.Text:SetText("Glowing Buttons")
glowingButtonCheckbox.initialValue=NecrosisConfig.glow.enabled
glowingButtonCheckbox:SetChecked(glowingButtonCheckbox.initialValue)
glowingButtonCheckbox.ApplyValueToEngine=function(self,checked)
NecrosisConfig.glow.enabled=checked
for _,checkbox in ipairs(NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes.glow or {})do
checkbox:ApplyParentEnabling()
end
SAO:ApplyGlowingButtonsToggle()
end
local classOptions=NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]]
if (classOptions)then
NecrosisSpellActivationOverlayOptionsPanel.classOptions={initialValue=CopyTable(classOptions)}
else
NecrosisSpellActivationOverlayOptionsPanel.classOptions={initialValue={}}
end
NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes={}
end
local function okayFunc(self)
local opacitySlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertOpacitySlider
opacitySlider.initialValue=opacitySlider:GetValue()
local scaleSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertScaleSlider
scaleSlider.initialValue=scaleSlider:GetValue()
local offsetSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertOffsetSlider
offsetSlider.initialValue=offsetSlider:GetValue()
local timerSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertTimerSlider
timerSlider.initialValue=timerSlider:GetValue()
local soundSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertSoundSlider
soundSlider.initialValue=soundSlider:GetValue()
local glowingButtonCheckbox=NecrosisSpellActivationOverlayOptionsPanelGlowingButtons
glowingButtonCheckbox.initialValue=glowingButtonCheckbox:GetChecked()
local classOptions=NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]]
if (classOptions)then
NecrosisSpellActivationOverlayOptionsPanel.classOptions.initialValue=CopyTable(classOptions)
end
end
local function cancelFunc(self)
local opacitySlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertOpacitySlider
local scaleSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertScaleSlider
local offsetSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertOffsetSlider
local timerSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertTimerSlider
local soundSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertSoundSlider
local glowingButtonCheckbox=NecrosisSpellActivationOverlayOptionsPanelGlowingButtons
local classOptions=NecrosisSpellActivationOverlayOptionsPanel.classOptions
self:applyAll(
opacitySlider.initialValue,
scaleSlider.initialValue,
offsetSlider.initialValue,
timerSlider.initialValue,
soundSlider.initialValue,
glowingButtonCheckbox.initialValue,
classOptions.initialValue
)
end
local function defaultFunc(self)
local defaultClassOptions=SAO.defaults.classes and SAO.CurrentClass and SAO.defaults.classes[SAO.CurrentClass.Intrinsics[2]]
self:applyAll(
1,
1,
0,
1,
SAO.IsCata() and 1 or 0,
true,
defaultClassOptions
)
end
local function applyAllFunc(self,opacityValue,scaleValue,offsetValue,timerValue,soundValue,isGlowEnabled,classOptions)
local opacitySlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertOpacitySlider
opacitySlider:SetValue(opacityValue)
if (NecrosisConfig.alert.opacity~=opacityValue)then
NecrosisConfig.alert.opacity=opacityValue
NecrosisConfig.alert.enabled=opacityValue > 0
SAO:ApplySpellAlertOpacity()
end
local geometryChanged=false
local scaleSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertScaleSlider
scaleSlider:SetValue(scaleValue)
if (NecrosisConfig.alert.scale~=scaleValue)then
NecrosisConfig.alert.scale=scaleValue
geometryChanged=true
end
local offsetSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertOffsetSlider
offsetSlider:SetValue(offsetValue)
if (NecrosisConfig.alert.offset~=offsetValue)then
NecrosisConfig.alert.offset=offsetValue
geometryChanged=true
end
if (geometryChanged)then
SAO:ApplySpellAlertGeometry()
end
local timerSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertTimerSlider
timerSlider:SetValue(timerValue)
if (NecrosisConfig.alert.timer~=timerValue)then
NecrosisConfig.alert.timer=timerValue
SAO:ApplySpellAlertTimer()
end
local soundSlider=NecrosisSpellActivationOverlayOptionsPanelSpellAlertSoundSlider
soundSlider:SetValue(soundValue)
if (NecrosisConfig.alert.sound~=soundValue)then
NecrosisConfig.alert.sound=soundValue
SAO:ApplySpellAlertSound()
end
local testButton=NecrosisSpellActivationOverlayOptionsPanelSpellAlertTestButton
testButton:SetEnabled(NecrosisConfig.alert.enabled)
local glowingButtonCheckbox=NecrosisSpellActivationOverlayOptionsPanelGlowingButtons
glowingButtonCheckbox:SetChecked(isGlowEnabled)
if (NecrosisConfig.glow.enabled~=isGlowEnabled)then
NecrosisConfig.glow.enabled=isGlowEnabled
glowingButtonCheckbox:ApplyValueToEngine(isGlowEnabled)
end
if (NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]] and classOptions)then
NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]]=CopyTable(classOptions)
for _,checkbox in ipairs(NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes.alert or {})do
checkbox:ApplyValue()
end
for _,checkbox in ipairs(NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes.glow or {})do
checkbox:ApplyValue()
end
end
end
local InterfaceOptions_AddCategory=InterfaceOptions_AddCategory
local InterfaceOptionsFrame_OpenToCategory=InterfaceOptionsFrame_OpenToCategory
if Settings and Settings.RegisterCanvasLayoutCategory then
InterfaceOptions_AddCategory=function(frame,addOn,position)
frame.OnCommit=frame.okay
frame.OnDefault=frame.default
frame.OnRefresh=frame.refresh
if frame.parent then
local category=Settings.GetCategory(frame.parent)
local subcategory,layout=Settings.RegisterCanvasLayoutSubcategory(category,frame,frame.name,frame.name)
subcategory.ID=frame.name
return subcategory,category
else
local category,layout=Settings.RegisterCanvasLayoutCategory(frame,frame.name,frame.name)
category.ID=frame.name
Settings.RegisterAddOnCategory(category)
return category
end
end
InterfaceOptionsFrame_OpenToCategory=function(categoryIDOrFrame)
if type(categoryIDOrFrame)=="table" then
local categoryID=categoryIDOrFrame.name
return Settings.OpenToCategory(categoryID)
else
return Settings.OpenToCategory(categoryIDOrFrame)
end
end
end
function NecrosisSpellActivationOverlayOptionsPanel_OnLoad(self)
self.name=AddonName
self.okay=okayFunc
self.cancel=cancelFunc
self.default=defaultFunc
self.applyAll=applyAllFunc
InterfaceOptions_AddCategory(self)
SAO.OptionsPanel=self
end
local optionsLoaded=false
function NecrosisSpellActivationOverlayOptionsPanel_OnShow(self)
if optionsLoaded then
return
end
for _,classDef in ipairs({SAO.CurrentClass,SAO.SharedClass})do
if classDef and type(classDef.LoadOptions)=='function' then
classDef.LoadOptions(SAO)
end
end
SAO:AddEffectOptions()
for _,optionType in ipairs({"alert", "glow"})do
if (type(NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes[optionType])=="nil")then
local className=SAO.CurrentClass and SAO.CurrentClass.Intrinsics[1] or select(1,UnitClass("player"))
local classFile=SAO.CurrentClass and SAO.CurrentClass.Intrinsics[2] or select(2,UnitClass("player"))
local dimFactor=0.7
local dimmedTextColor=CreateColor(dimFactor,dimFactor,dimFactor)
local dimmedClassColor=CreateColor(dimFactor*RAID_CLASS_COLORS[classFile].r,dimFactor*RAID_CLASS_COLORS[classFile].g,dimFactor*RAID_CLASS_COLORS[classFile].b)
local text=WrapTextInColor(string.format("%s (%s)",NONE,WrapTextInColor(className,dimmedClassColor)),dimmedTextColor)
NecrosisSpellActivationOverlayOptionsPanel[optionType.."None"]:SetText(text)
end
end
optionsLoaded=true
end
if not iamNecrosis then
SLASH_SAO1="/sao"
SLASH_SAO2="/spellactivationoverlay"
SlashCmdList.SAO=function(msg,editBox)
InterfaceOptionsFrame_OpenToCategory(SAO.OptionsPanel)
InterfaceOptionsFrame_OpenToCategory(SAO.OptionsPanel)
end
end
