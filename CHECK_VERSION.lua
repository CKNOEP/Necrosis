--[[
    Script to check actual WoW version for Midnight PTR
    Run in WoW console: /run GetBuildInfo() or check in-game
]]

local major, minor, patch, build = GetBuildInfo()
print("WoW Build Info:")
print("  Major: " .. tostring(major))
print("  Minor: " .. tostring(minor))
print("  Patch: " .. tostring(patch))
print("  Build: " .. tostring(build))

-- Calculate interface version
-- Format: majorMinorPatch (e.g., 11.0.0 = 110000)
local interfaceVersion = (major * 10000) + (minor * 100) + patch
print("  Calculated Interface Version: " .. interfaceVersion)

-- Also show WoW version
print("  WoW Version: " .. major .. "." .. minor .. "." .. patch)
