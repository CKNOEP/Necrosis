local AddonName, SAO = ...
local iamNecrosis = strlower(AddonName):sub(0,8) == "necrosis"

function NecrosisSpellActivationOverlayOptionsPanel_Init(self)
    local shutdownCategory = SAO.Shutdown:GetCategory();
    if shutdownCategory then
        -- Apply shutdown settings before enything else, in case init fails precisely because of why the addon was shut down
        if shutdownCategory.Reason then
            local globalOffReason = NecrosisSpellActivationOverlayOptionsPanel.globalOff.reason;
            globalOffReason:SetText("("..shutdownCategory.Reason..")");
        end

        if shutdownCategory.Button then
            local globalOffButton = NecrosisSpellActivationOverlayOptionsPanel.globalOff.button;
            globalOffButton:SetText(shutdownCategory.Button.Text);
            local estimatedWidth = (2+strlenutf8(shutdownCategory.Button.Text))*8;
            globalOffButton:SetWidth(estimatedWidth);
            if estimatedWidth > 48 then
                globalOffButton:SetHeight(globalOffButton:GetHeight()+ceil((estimatedWidth-32)/16));
            end
            globalOffButton:SetScript("OnClick", shutdownCategory.Button.OnClick);
            globalOffButton:Show();
        end

        if shutdownCategory.DisableCondition then
            local disableCondition = SAO.Shutdown:GetCategory().DisableCondition;
            local disableConditionButton = NecrosisSpellActivationOverlayOptionsPanelDisableConditionButton;
            disableConditionButton.Text:SetText(disableCondition.Text);
            disableConditionButton.OnValueChanged = function(self, checked)
                if checked then
                    disableCondition.OnValueChanged(self, true);
                    NecrosisSpellActivationOverlayOptionsPanel.globalOff:Show();
                    local testButton = NecrosisSpellActivationOverlayOptionsPanelSpellAlertTestButton;
                    if testButton.isTesting then
                        testButton:StopTest();
                    end
                else
                    disableCondition.OnValueChanged(self, false);
                    NecrosisSpellActivationOverlayOptionsPanel.globalOff:Hide();
                end
            end
            disableConditionButton:SetChecked(SAO.Shutdown:IsAddonDisabled());
            disableConditionButton:OnValueChanged(disableConditionButton:GetChecked());
            if disableCondition.ShowIf == nil or disableCondition.ShowIf() then
                disableConditionButton:Show();
            end
        else
            -- Without disable condition, disabling is absolute
            NecrosisSpellActivationOverlayOptionsPanel.globalOff:Show();
        end
    end

    local opacitySlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertOpacitySlider;
    opacitySlider.Text:SetText(SPELL_ALERT_OPACITY);
    _G[opacitySlider:GetName().."Low"]:SetText(OFF);
    opacitySlider:SetMinMaxValues(0, 1);
    opacitySlider:SetValueStep(0.05);
    opacitySlider.initialValue = NecrosisConfig.alert.opacity;
    opacitySlider:SetValue(opacitySlider.initialValue);
    opacitySlider.ApplyValueToEngine = function(self, value)
        NecrosisConfig.alert.opacity = value;
        NecrosisConfig.alert.enabled = value > 0;
        SAO:ApplySpellAlertOpacity();
    end

    local scaleSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertScaleSlider;
    scaleSlider.Text:SetText("Spell Alert Scale");
    _G[scaleSlider:GetName().."Low"]:SetText(SMALL);
    _G[scaleSlider:GetName().."High"]:SetText(LARGE);
    scaleSlider:SetMinMaxValues(0.25, 2.5);
    scaleSlider:SetValueStep(0.05);
    scaleSlider.initialValue = NecrosisConfig.alert.scale;
    scaleSlider:SetValue(scaleSlider.initialValue);
    scaleSlider.ApplyValueToEngine = function(self, value)
        NecrosisConfig.alert.scale = value;
        SAO:ApplySpellAlertGeometry();
    end

    local offsetSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertOffsetSlider;
    offsetSlider.Text:SetText("Spell Alert Offset");
    _G[offsetSlider:GetName().."Low"]:SetText(NEAR);
    _G[offsetSlider:GetName().."High"]:SetText(FAR);
    offsetSlider:SetMinMaxValues(-200, 400);
    offsetSlider:SetValueStep(20);
    offsetSlider.initialValue = NecrosisConfig.alert.offset;
    offsetSlider:SetValue(offsetSlider.initialValue);
    offsetSlider.ApplyValueToEngine = function(self, value)
        NecrosisConfig.alert.offset = value;
        SAO:ApplySpellAlertGeometry();
    end

    local timerSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertTimerSlider;
    timerSlider.Text:SetText("Spell Alert Progressive Timer");
    _G[timerSlider:GetName().."Low"]:SetText(DISABLE);
    _G[timerSlider:GetName().."High"]:SetText(ENABLE);
    timerSlider:SetMinMaxValues(0, 1);
    timerSlider:SetValueStep(1);
    timerSlider.initialValue = NecrosisConfig.alert.timer;
    timerSlider:SetValue(timerSlider.initialValue);
    timerSlider.ApplyValueToEngine = function(self, value)
        NecrosisConfig.alert.timer = value;
        SAO:ApplySpellAlertTimer();
    end

    local soundSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertSoundSlider;
    soundSlider.Text:SetText("Spell Alert Sound Effect");
    _G[soundSlider:GetName().."Low"]:SetText(DISABLE);
    _G[soundSlider:GetName().."High"]:SetText(ENABLE);
    soundSlider:SetMinMaxValues(0, 1);
    soundSlider:SetValueStep(1);
    soundSlider.initialValue = NecrosisConfig.alert.sound;
    soundSlider:SetValue(soundSlider.initialValue);
    soundSlider.ApplyValueToEngine = function(self, value)
        NecrosisConfig.alert.sound = value;
        SAO:ApplySpellAlertSound();
    end

    local testButton = NecrosisSpellActivationOverlayOptionsPanelSpellAlertTestButton;
    testButton:SetText("Test Overlay");
    testButton.fakeSpellID = 42;
    testButton.isTesting = false;
    local testTextureLeftRight = SAO.IsEra() and "nightfall";
    local testTextureTop = SAO.IsEra() and  "backlash";
    local testPositionTop = SAO.IsCata() and "Top (CW)" or "Top";
    testButton.StartTest = function(self)
       
		if (not self.isTesting) then
            self.isTesting = true;
            SAO:ActivateOverlay(0, self.fakeSpellID, SAO.TexName[testTextureLeftRight], "Left + Right (Flipped)", 1, 255, 255, 255, false, nil, GetTime()+5, false);
            SAO:ActivateOverlay(0, self.fakeSpellID, SAO.TexName[testTextureTop], testPositionTop, 1, 255, 255, 255, false, nil, GetTime()+5, false);
            self.testTimerTicker = C_Timer.NewTicker(4.9, -- Ticker must be slightly shorter than overlay duration, to refresh it before losing it
            function()
                print("timer",self.fakeSpellID, GetTime()+5);
				SAO:RefreshOverlayTimer(self.fakeSpellID, GetTime()+5);
            end);
            -- Hack the frame to force full opacity even when out of combat
            NecrosisSpellActivationOverlayFrame_SetForceAlpha1(true);
        end
    end
    testButton.StopTest = function(self)
        if (self.isTesting) then
            self.isTesting = false;
            self.testTimerTicker:Cancel();
            SAO:DeactivateOverlay(self.fakeSpellID);
            -- Undo hack
            NecrosisSpellActivationOverlayFrame_SetForceAlpha1(false);
        end
    end
    testButton:SetEnabled(NecrosisConfig.alert.enabled);
    -- Manually mark textures used for testing
    SAO:MarkTexture(testTextureLeftRight);
    SAO:MarkTexture(testTextureTop);

    local debugButton = NecrosisSpellActivationOverlayOptionsPanelSpellAlertDebugButton;
    debugButton.Text:SetText("Write Debug to Chatbox");
    debugButton:SetChecked(NecrosisConfig.debug == true);

    local responsiveButton = NecrosisSpellActivationOverlayOptionsPanelSpellAlertResponsiveButton;
    responsiveButton.Text:SetText(SAO:responsiveMode());
    responsiveButton:SetChecked(NecrosisConfig.responsiveMode == true);

    local glowingButtonCheckbox = NecrosisSpellActivationOverlayOptionsPanelGlowingButtons;
    glowingButtonCheckbox.Text:SetText("Glowing Buttons");
    glowingButtonCheckbox.initialValue = NecrosisConfig.glow.enabled;
    glowingButtonCheckbox:SetChecked(glowingButtonCheckbox.initialValue);
    glowingButtonCheckbox.ApplyValueToEngine = function(self, checked)
        NecrosisConfig.glow.enabled = checked;
        for _, checkbox in ipairs(NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes.glow or {}) do
            -- Additional glowing checkboxes are enabled/disabled depending on the main glowing checkbox
            checkbox:ApplyParentEnabling();
        end
        SAO:ApplyGlowingButtonsToggle();
    end

    local classOptions = NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]];
    if (classOptions) then
        NecrosisSpellActivationOverlayOptionsPanel.classOptions = { initialValue = CopyTable(classOptions) };
    else
        NecrosisSpellActivationOverlayOptionsPanel.classOptions = { initialValue = {} };
    end

    NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes = {};
end

-- User clicks OK to the options panel
local function okayFunc(self)
    local opacitySlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertOpacitySlider;
    opacitySlider.initialValue = opacitySlider:GetValue();

    local scaleSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertScaleSlider;
    scaleSlider.initialValue = scaleSlider:GetValue();

    local offsetSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertOffsetSlider;
    offsetSlider.initialValue = offsetSlider:GetValue();

    local timerSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertTimerSlider;
    timerSlider.initialValue = timerSlider:GetValue();

    local soundSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertSoundSlider;
    soundSlider.initialValue = soundSlider:GetValue();

    local glowingButtonCheckbox = NecrosisSpellActivationOverlayOptionsPanelGlowingButtons;
    glowingButtonCheckbox.initialValue = glowingButtonCheckbox:GetChecked();

    local classOptions = NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]];
    if (classOptions) then
        NecrosisSpellActivationOverlayOptionsPanel.classOptions.initialValue = CopyTable(classOptions);
    end
end

-- User clicked Cancel to the options panel
local function cancelFunc(self)
    local opacitySlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertOpacitySlider;
    local scaleSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertScaleSlider;
    local offsetSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertOffsetSlider;
    local timerSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertTimerSlider;
    local soundSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertSoundSlider;
    local glowingButtonCheckbox = NecrosisSpellActivationOverlayOptionsPanelGlowingButtons;
    local classOptions = NecrosisSpellActivationOverlayOptionsPanel.classOptions;

    self:applyAll(
        opacitySlider.initialValue,
        scaleSlider.initialValue,
        offsetSlider.initialValue,
        timerSlider.initialValue,
        soundSlider.initialValue,
        glowingButtonCheckbox.initialValue,
        classOptions.initialValue
    );
end

-- User reset settings to default values
local function defaultFunc(self)
    local defaultClassOptions = SAO.defaults.classes and SAO.CurrentClass and SAO.defaults.classes[SAO.CurrentClass.Intrinsics[2]];
    self:applyAll(
        1, -- opacity
        1, -- scale
        0, -- offset
        1, -- timer
        SAO.IsCata() and 1 or 0, -- sound
        true, -- glow
        defaultClassOptions -- class options
    );
end

local function applyAllFunc(self, opacityValue, scaleValue, offsetValue, timerValue, soundValue, isGlowEnabled, classOptions)
    local opacitySlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertOpacitySlider;
    opacitySlider:SetValue(opacityValue);
    if (NecrosisConfig.alert.opacity ~= opacityValue) then
        NecrosisConfig.alert.opacity = opacityValue;
        NecrosisConfig.alert.enabled = opacityValue > 0;
        SAO:ApplySpellAlertOpacity();
    end

    local geometryChanged = false;

    local scaleSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertScaleSlider;
    scaleSlider:SetValue(scaleValue);
    if (NecrosisConfig.alert.scale ~= scaleValue) then
        NecrosisConfig.alert.scale = scaleValue;
        geometryChanged = true;
    end

    local offsetSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertOffsetSlider;
    offsetSlider:SetValue(offsetValue);
    if (NecrosisConfig.alert.offset ~= offsetValue) then
        NecrosisConfig.alert.offset = offsetValue;
        geometryChanged = true;
    end

    if (geometryChanged) then
        SAO:ApplySpellAlertGeometry();
    end

    local timerSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertTimerSlider;
    timerSlider:SetValue(timerValue);
    if (NecrosisConfig.alert.timer ~= timerValue) then
        NecrosisConfig.alert.timer = timerValue;
        SAO:ApplySpellAlertTimer();
    end

    local soundSlider = NecrosisSpellActivationOverlayOptionsPanelSpellAlertSoundSlider;
    soundSlider:SetValue(soundValue);
    if (NecrosisConfig.alert.sound ~= soundValue) then
        NecrosisConfig.alert.sound = soundValue;
        SAO:ApplySpellAlertSound();
    end

    local testButton = NecrosisSpellActivationOverlayOptionsPanelSpellAlertTestButton;
    -- Enable/disable the test button with alert.enabled, which was set/reset a few lines above, alongside opacity
    testButton:SetEnabled(NecrosisConfig.alert.enabled);

    local glowingButtonCheckbox = NecrosisSpellActivationOverlayOptionsPanelGlowingButtons;
    glowingButtonCheckbox:SetChecked(isGlowEnabled);
    if (NecrosisConfig.glow.enabled ~= isGlowEnabled) then
        NecrosisConfig.glow.enabled = isGlowEnabled;
        glowingButtonCheckbox:ApplyValueToEngine(isGlowEnabled);
    end

    if (NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]] and classOptions) then
        NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]] = CopyTable(classOptions);
        for _, checkbox in ipairs(NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes.alert or {}) do
            checkbox:ApplyValue();
        end
        for _, checkbox in ipairs(NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes.glow or {}) do
            checkbox:ApplyValue();
        end
    end
end

local InterfaceOptions_AddCategory = InterfaceOptions_AddCategory
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory

if Settings and Settings.RegisterCanvasLayoutCategory then
    --[[ Deprecated. 
    See Blizzard_ImplementationReadme.lua for recommended setup.
    ]]
    InterfaceOptions_AddCategory = function(frame, addOn, position)
        -- cancel is no longer a default option. May add menu extension for this.
        frame.OnCommit = frame.okay;
        frame.OnDefault = frame.default;
        frame.OnRefresh = frame.refresh;

        if frame.parent then
            local category = Settings.GetCategory(frame.parent);
            local subcategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, frame.name, frame.name);
            subcategory.ID = frame.name;
            return subcategory, category;
        else
            local category, layout = Settings.RegisterCanvasLayoutCategory(frame, frame.name, frame.name);
            category.ID = frame.name;
            Settings.RegisterAddOnCategory(category);
            return category;
        end
    end

    -- Deprecated. Use Settings.OpenToCategory().
    InterfaceOptionsFrame_OpenToCategory = function(categoryIDOrFrame)
        if type(categoryIDOrFrame) == "table" then
            local categoryID = categoryIDOrFrame.name;
            return Settings.OpenToCategory(categoryID);
        else
            return Settings.OpenToCategory(categoryIDOrFrame);
        end
    end
end

function NecrosisSpellActivationOverlayOptionsPanel_OnLoad(self)
    self.name = AddonName;
    self.okay = okayFunc;
    self.cancel = cancelFunc;
    self.default = defaultFunc;
    self.applyAll = applyAllFunc; -- not a callback used by Blizzard's InterfaceOptions_AddCategory, but used by us

    InterfaceOptions_AddCategory(self);

    SAO.OptionsPanel = self;
end

local optionsLoaded = false; -- Make sure we do not load the options panel twice
function NecrosisSpellActivationOverlayOptionsPanel_OnShow(self)
    if optionsLoaded then
        return;
    end

    if SAO.CurrentClass and type(SAO.CurrentClass.LoadOptions) == 'function' then
        SAO.CurrentClass.LoadOptions(SAO);
    end

    SAO:AddEffectOptions();

    for _, optionType in ipairs({ "alert", "glow" }) do
        if (type(NecrosisSpellActivationOverlayOptionsPanel.additionalCheckboxes[optionType]) == "nil") then
            local className = SAO.CurrentClass and SAO.CurrentClass.Intrinsics[1] or select(1, UnitClass("player"));
            local classFile = SAO.CurrentClass and SAO.CurrentClass.Intrinsics[2] or select(2, UnitClass("player"));
            local dimFactor = 0.7;
            local dimmedTextColor = CreateColor(dimFactor, dimFactor, dimFactor);
            local dimmedClassColor = CreateColor(dimFactor*RAID_CLASS_COLORS[classFile].r, dimFactor*RAID_CLASS_COLORS[classFile].g, dimFactor*RAID_CLASS_COLORS[classFile].b);
            local text = WrapTextInColor(string.format("%s (%s)", NONE, WrapTextInColor(className, dimmedClassColor)), dimmedTextColor);
            NecrosisSpellActivationOverlayOptionsPanel[optionType.."None"]:SetText(text);
        end
    end

    optionsLoaded = true;
end

if not iamNecrosis then
    SLASH_SAO1 = "/sao"
    SLASH_SAO2 = "/spellactivationoverlay"
    SlashCmdList.SAO = function(msg, editBox)
        -- https://github.com/Stanzilla/WoWUIBugs/issues/89
        InterfaceOptionsFrame_OpenToCategory(SAO.OptionsPanel);
        InterfaceOptionsFrame_OpenToCategory(SAO.OptionsPanel);
    end
end
