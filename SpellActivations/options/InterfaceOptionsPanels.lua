local AddonName, SAO = ...

function SpellActivationOverlayOptionsPanel_Init(self)
    local opacitySlider = SpellActivationOverlayOptionsPanelSpellAlertOpacitySlider;
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

    local scaleSlider = SpellActivationOverlayOptionsPanelSpellAlertScaleSlider;
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

    local offsetSlider = SpellActivationOverlayOptionsPanelSpellAlertOffsetSlider;
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

    local timerSlider = SpellActivationOverlayOptionsPanelSpellAlertTimerSlider;
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

    local soundSlider = SpellActivationOverlayOptionsPanelSpellAlertSoundSlider;
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

    local testButton = SpellActivationOverlayOptionsPanelSpellAlertTestButton;
    testButton:SetText("Toggle Test");
    testButton.fakeSpellID = 42;
    testButton.isTesting = false;
    local testTextureLeftRight = SAO.IsEra() and "echo_of_the_elements" or "imp_empowerment";
    local testTextureTop = SAO.IsEra() and "fury_of_stormrage" or "brain_freeze";
    testButton.StartTest = function(self)
        if (not self.isTesting) then
            self.isTesting = true;
            SAO:ActivateOverlay(0, self.fakeSpellID, SAO.TexName[testTextureLeftRight], "Left + Right (Flipped)", 1, 255, 255, 255, false, nil, GetTime()+5, false);
            SAO:ActivateOverlay(0, self.fakeSpellID, SAO.TexName[testTextureTop], "Top", 1, 255, 255, 255, false, nil, GetTime()+5, false);
            self.testTimerTicker = C_Timer.NewTicker(4.9, -- Ticker must be slightly shorter than overlay duration, to refresh it before losing it
            function()
                SAO:RefreshOverlayTimer(self.fakeSpellID, GetTime()+5);
            end);
            -- Hack the frame to force full opacity even when out of combat
            SpellActivationOverlayFrame_SetForceAlpha1(true);
        end
    end
    testButton.StopTest = function(self)
        if (self.isTesting) then
            self.isTesting = false;
            self.testTimerTicker:Cancel();
            SAO:DeactivateOverlay(self.fakeSpellID);
            -- Undo hack
            SpellActivationOverlayFrame_SetForceAlpha1(false);
        end
    end
    testButton:SetEnabled(NecrosisConfig.alert.enabled);
    -- Manually mark textures used for testing
    SAO:MarkTexture(testTextureLeftRight);
    SAO:MarkTexture(testTextureTop);

    local debugButton = SpellActivationOverlayOptionsPanelSpellAlertDebugButton;
    debugButton.Text:SetText("Write Debug to Chatbox");
    debugButton:SetChecked(NecrosisConfig.debug == true);

    local glowingButtonCheckbox = SpellActivationOverlayOptionsPanelGlowingButtons;
    glowingButtonCheckbox.Text:SetText("Glowing Buttons");
    glowingButtonCheckbox.initialValue = NecrosisConfig.glow.enabled;
    glowingButtonCheckbox:SetChecked(glowingButtonCheckbox.initialValue);
    glowingButtonCheckbox.ApplyValueToEngine = function(self, checked)
        NecrosisConfig.glow.enabled = checked;
        for _, checkbox in ipairs(SpellActivationOverlayOptionsPanel.additionalCheckboxes.glow or {}) do
            -- Additional glowing checkboxes are enabled/disabled depending on the main glowing checkbox
            checkbox:ApplyParentEnabling();
        end
        SAO:ApplyGlowingButtonsToggle();
    end

    local classOptions = NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]];
    if (classOptions) then
        SpellActivationOverlayOptionsPanel.classOptions = { initialValue = CopyTable(classOptions) };
    else
        SpellActivationOverlayOptionsPanel.classOptions = { initialValue = {} };
    end

    SpellActivationOverlayOptionsPanel.additionalCheckboxes = {};
end

-- User clicks OK to the options panel
local function okayFunc(self)
    local opacitySlider = SpellActivationOverlayOptionsPanelSpellAlertOpacitySlider;
    opacitySlider.initialValue = opacitySlider:GetValue();

    local scaleSlider = SpellActivationOverlayOptionsPanelSpellAlertScaleSlider;
    scaleSlider.initialValue = scaleSlider:GetValue();

    local offsetSlider = SpellActivationOverlayOptionsPanelSpellAlertOffsetSlider;
    offsetSlider.initialValue = offsetSlider:GetValue();

    local timerSlider = SpellActivationOverlayOptionsPanelSpellAlertTimerSlider;
    timerSlider.initialValue = timerSlider:GetValue();

    local soundSlider = SpellActivationOverlayOptionsPanelSpellAlertSoundSlider;
    soundSlider.initialValue = soundSlider:GetValue();

    local glowingButtonCheckbox = SpellActivationOverlayOptionsPanelGlowingButtons;
    glowingButtonCheckbox.initialValue = glowingButtonCheckbox:GetChecked();

    local classOptions = NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]];
    if (classOptions) then
        SpellActivationOverlayOptionsPanel.classOptions.initialValue = CopyTable(classOptions);
    end
end

-- User clicked Cancel to the options panel
local function cancelFunc(self)
    local opacitySlider = SpellActivationOverlayOptionsPanelSpellAlertOpacitySlider;
    local scaleSlider = SpellActivationOverlayOptionsPanelSpellAlertScaleSlider;
    local offsetSlider = SpellActivationOverlayOptionsPanelSpellAlertOffsetSlider;
    local timerSlider = SpellActivationOverlayOptionsPanelSpellAlertTimerSlider;
    local soundSlider = SpellActivationOverlayOptionsPanelSpellAlertSoundSlider;
    local glowingButtonCheckbox = SpellActivationOverlayOptionsPanelGlowingButtons;
    local classOptions = SpellActivationOverlayOptionsPanel.classOptions;

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
    local opacitySlider = SpellActivationOverlayOptionsPanelSpellAlertOpacitySlider;
    opacitySlider:SetValue(opacityValue);
    if (NecrosisConfig.alert.opacity ~= opacityValue) then
        NecrosisConfig.alert.opacity = opacityValue;
        NecrosisConfig.alert.enabled = opacityValue > 0;
        SAO:ApplySpellAlertOpacity();
    end

    local geometryChanged = false;

    local scaleSlider = SpellActivationOverlayOptionsPanelSpellAlertScaleSlider;
    scaleSlider:SetValue(scaleValue);
    if (NecrosisConfig.alert.scale ~= scaleValue) then
        NecrosisConfig.alert.scale = scaleValue;
        geometryChanged = true;
    end

    local offsetSlider = SpellActivationOverlayOptionsPanelSpellAlertOffsetSlider;
    offsetSlider:SetValue(offsetValue);
    if (NecrosisConfig.alert.offset ~= offsetValue) then
        NecrosisConfig.alert.offset = offsetValue;
        geometryChanged = true;
    end

    if (geometryChanged) then
        SAO:ApplySpellAlertGeometry();
    end

    local timerSlider = SpellActivationOverlayOptionsPanelSpellAlertTimerSlider;
    timerSlider:SetValue(timerValue);
    if (NecrosisConfig.alert.timer ~= timerValue) then
        NecrosisConfig.alert.timer = timerValue;
        SAO:ApplySpellAlertTimer();
    end

    local soundSlider = SpellActivationOverlayOptionsPanelSpellAlertSoundSlider;
    soundSlider:SetValue(soundValue);
    if (NecrosisConfig.alert.sound ~= soundValue) then
        NecrosisConfig.alert.sound = soundValue;
        SAO:ApplySpellAlertSound();
    end

    local testButton = SpellActivationOverlayOptionsPanelSpellAlertTestButton;
    -- Enable/disable the test button with alert.enabled, which was set/reset a few lines above, alongside opacity
    testButton:SetEnabled(NecrosisConfig.alert.enabled);

    local glowingButtonCheckbox = SpellActivationOverlayOptionsPanelGlowingButtons;
    glowingButtonCheckbox:SetChecked(isGlowEnabled);
    if (NecrosisConfig.glow.enabled ~= isGlowEnabled) then
        NecrosisConfig.glow.enabled = isGlowEnabled;
        glowingButtonCheckbox:ApplyValueToEngine(isGlowEnabled);
    end

    if (NecrosisConfig.classes and SAO.CurrentClass and NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]] and classOptions) then
        NecrosisConfig.classes[SAO.CurrentClass.Intrinsics[2]] = CopyTable(classOptions);
        for _, checkbox in ipairs(SpellActivationOverlayOptionsPanel.additionalCheckboxes.alert or {}) do
            checkbox:ApplyValue();
        end
        for _, checkbox in ipairs(SpellActivationOverlayOptionsPanel.additionalCheckboxes.glow or {}) do
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

function SpellActivationOverlayOptionsPanel_OnLoad(self)
    self.name = AddonName;
    self.okay = okayFunc;
    self.cancel = cancelFunc;
    self.default = defaultFunc;
    self.applyAll = applyAllFunc; -- not a callback used by Blizzard's InterfaceOptions_AddCategory, but used by us

    InterfaceOptions_AddCategory(self);

    SAO.OptionsPanel = self;
end

local optionsLoaded = false; -- Make sure we do not load the options panel twice
function SpellActivationOverlayOptionsPanel_OnShow(self)
    if optionsLoaded then
        return;
    end

    SAO:AddEffectOptions();

    if SAO.CurrentClass and type(SAO.CurrentClass.LoadOptions) == 'function' then
        SAO.CurrentClass.LoadOptions(SAO);
    end

    optionsLoaded = true;
end

SLASH_SAO1 = "/sao"
SLASH_SAO2 = "/spellactivationoverlay"

SlashCmdList.SAO = function(msg, editBox)
    -- https://github.com/Stanzilla/WoWUIBugs/issues/89
    InterfaceOptionsFrame_OpenToCategory(SAO.OptionsPanel);
    InterfaceOptionsFrame_OpenToCategory(SAO.OptionsPanel);
end
