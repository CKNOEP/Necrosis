print("|cFFFFFF00[GLOBAL-FRAMEWORK]|r Loading Global-Framework.lua!")
print("|cFFFFFF00[GLOBAL-FRAMEWORK]|r NUI exists: " .. tostring(NUI ~= nil))

local _G, NUI = _G, NUI

if not NUI then
	print("|cFFFF0000[GLOBAL-FRAMEWORK]|r ERROR: NUI is nil! Cannot continue!")
	return
end

print("|cFFFFFF00[GLOBAL-FRAMEWORK]|r Creating Style_Classic module...")
local module = NUI:NewModule('Style_Classic')
print("|cFFFFFF00[GLOBAL-FRAMEWORK]|r Module created successfully!")
local UnregisterStateDriver = _G.UnregisterStateDriver
----------------------------------------------------------------------------------------------------



