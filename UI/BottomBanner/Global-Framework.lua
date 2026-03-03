local _G, NUI = _G, NUI

if not NUI then
	error("ERROR: NUI is nil! Cannot continue!")
	return
end

local module = NUI:NewModule('Style_Classic')
local UnregisterStateDriver = _G.UnregisterStateDriver
----------------------------------------------------------------------------------------------------



