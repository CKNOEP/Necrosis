local AddonName, OVERLAY = ...

-- List of classes
-- Each class defines its own stuff in their <classname>.lua
OVERLAY.Class = {}

-- Event receiver
function OVERLAY.InvokeClassEvent(self, event, ...)
    if (self.CurrentClass and self.CurrentClass[event]) then
        self.CurrentClass[event](self, ...);
    end
end
