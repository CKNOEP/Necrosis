local AddonName, OVERLAY = ...

-- Apply all values from the database to the engine
function OVERLAY.ApplyAllVariables(self)
    self:ApplySpellAlertOpacity();
    self:ApplySpellAlertGeometry();
    self:ApplyGlowingButtonsToggle();
end

-- Apply spell alert opacity
function OVERLAY.ApplySpellAlertOpacity(self)
    -- Change the main frame's visibility and opacity
    SpellActivationOverlayContainerFrame:SetShown(SpellActivationOverlayDB.alert.enabled);
    SpellActivationOverlayContainerFrame:SetAlpha(SpellActivationOverlayDB.alert.opacity);
end

-- Apply spell alert geometry i.e., scale and offset
function OVERLAY.ApplySpellAlertGeometry(self)
    SpellActivationOverlayFrame.scale = SpellActivationOverlayDB.alert.scale;
    SpellActivationOverlayFrame.offset = SpellActivationOverlayDB.alert.offset;
    SpellActivationOverlay_OnChangeGeometry(SpellActivationOverlayFrame);
end

-- Apply glowing buttons on/off
function OVERLAY.ApplyGlowingButtonsToggle(self)
    -- Don't do anything
    -- Buttons will stop glowing by themselves, and will never light up again

    -- A better function would be to stop glowing / start glowing now
    -- But this would be more complex to code, and the benefit is minimal
end
