local _G, NUI = _G, NUI

if not NUI then
	error("ERROR: NUI is nil! Cannot continue!")
	return
end

-- Create module only if it doesn't already exist (file loaded in multiple .toc files)
local module = NUI:GetModule('Style_Classic') or NUI:NewModule('Style_Classic')
local UnregisterStateDriver = _G.UnregisterStateDriver
----------------------------------------------------------------------------------------------------



