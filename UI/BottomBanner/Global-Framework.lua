local _G, NUI = _G, NUI

if not NUI then
	error("ERROR: NUI is nil! Cannot continue!")
	return
end

-- Only create the module if it doesn't already exist
-- Use true (silent) to prevent error if module doesn't exist yet
local module = NUI:GetModule('Style_Classic', true) or NUI:NewModule('Style_Classic')
local UnregisterStateDriver = _G.UnregisterStateDriver
----------------------------------------------------------------------------------------------------



