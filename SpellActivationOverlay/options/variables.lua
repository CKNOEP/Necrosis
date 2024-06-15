local AddonName, SAO = ...

-- Apply all values from the database to the engine
function SAO.ApplyAllVariables(self)
    self:ApplySpellAlertOpacity();
    self:ApplySpellAlertGeometry();
    self:ApplySpellAlertTimer();
    self:ApplySpellAlertSound();
    self:ApplyGlowingButtonsToggle();
end

-- Apply spell alert opacity
function SAO.ApplySpellAlertOpacity(self)
    -- Change the main frame's visibility and opacity
    NecrosisSpellActivationOverlayContainerFrame:SetShown(NecrosisConfig.alert.enabled);
    NecrosisSpellActivationOverlayContainerFrame:SetAlpha(NecrosisConfig.alert.opacity);
end

-- Apply spell alert geometry i.e., scale and offset
function SAO.ApplySpellAlertGeometry(self)
    NecrosisSpellActivationOverlayFrame.scale = NecrosisConfig.alert.scale;
    NecrosisSpellActivationOverlayFrame.offset = NecrosisConfig.alert.offset;
    NecrosisSpellActivationOverlay_OnChangeGeometry(NecrosisSpellActivationOverlayFrame);
end

-- Apply spell alert progressive timer effect
function SAO.ApplySpellAlertTimer(self)
    NecrosisSpellActivationOverlayFrame.useTimer = NecrosisConfig.alert.timer ~= 0;
    NecrosisSpellActivationOverlay_OnChangeTimerVisibility(NecrosisSpellActivationOverlayFrame);
end

-- Apply spell alert sound effects toggle
function SAO.ApplySpellAlertSound(self)
    NecrosisSpellActivationOverlayFrame.useSound = NecrosisConfig.alert.sound ~= 0;
    NecrosisSpellActivationOverlay_OnChangeSoundToggle(NecrosisSpellActivationOverlayFrame);
end

-- Apply glowing buttons on/off
function SAO.ApplyGlowingButtonsToggle(self)
    -- @todo Find a way to only refresh spell alert when checking spell alert, or glowing button when clicking glowing button
    for _, bucket in pairs(self.RegisteredBucketsBySpellID) do
        bucket:reset(); -- Reset hash to force re-display if needed
        bucket.trigger:manualCheckAll();
    end
end
