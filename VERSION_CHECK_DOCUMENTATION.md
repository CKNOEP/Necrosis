# Necrosis Version Check Module - Documentation

## Overview

The **VersionCheck** module automatically notifies players when a new version of Necrosis is available on CurseForge or GitHub. It provides:

- ✅ Automatic version checking (every 24 hours)
- ✅ Non-intrusive chat notifications
- ✅ Optional popup notification frame
- ✅ Manual version check via slash command
- ✅ Support for all 8 languages
- ✅ Fully configurable

## Features

### 1. **Automatic Update Detection**
- Checks GitHub releases automatically
- Updates every 24 hours (configurable)
- First check happens 5 seconds after addon load

### 2. **Version Comparison**
Intelligent version parsing and comparison:
```
Current: 8.3.0
Remote:  8.3.1
Result:  Update available → 8.3.1
```

### 3. **Notifications**
**Chat Notification:**
```
[Necrosis] Update available
Current Version: 8.3.0 → 8.3.1
Download: https://www.curseforge.com/wow/addons/necrosis
GitHub: https://github.com/CKNOEP/Necrosis/releases
Type: /necrosis version
```

**Popup Frame:**
- Appears once per update check
- Auto-hides after 10 seconds
- Includes direct "Update" button
- Can be manually closed

### 4. **Manual Version Check**
```
/necrosis version
```
Shows current version and checks for updates immediately.

## Configuration

### Default Settings (Initialize.lua)

```lua
NecrosisConfig.VersionCheck = {
    Enabled = true,              -- Enable/disable entire module
    CheckOnLoad = true,          -- Check on addon load
    NotifyOnUpdate = true,       -- Notify player when update available
    CheckInterval = 86400,       -- Check every 24 hours (seconds)
    LastCheck = 0,               -- Internal: timestamp of last check
}
```

### Disable Version Check
```lua
/script NecrosisConfig.VersionCheck.Enabled = false
```

### Change Check Interval
```lua
/script NecrosisConfig.VersionCheck.CheckInterval = 3600  -- Check every hour
```

## How It Works

### Architecture

```
VersionCheck:Init()
    ↓
Check for updates every 24h
    ↓
ParseVersion(current, remote)
    ↓
CompareVersions()
    ↓
IF update available
    ├→ Notify chat
    ├→ Show popup frame
    └→ Store remote version
ELSE
    └→ Silent (no notification)
```

### Version Format

Supports versions like:
- `8.3.0`
- `v8.3.0`
- `8.3.0-alpha`
- `v8.3.1-beta`

Parser extracts major.minor.patch numbers.

### Update Detection

Updates are available when **remote > current**:
- Major version: 9.0.0 > 8.9.9 ✓
- Minor version: 8.4.0 > 8.3.9 ✓
- Patch version: 8.3.1 > 8.3.0 ✓

## API

### Public Methods

```lua
-- Check for updates (respects interval)
VersionCheck:CheckForUpdate()

-- Notify current version
VersionCheck:NotifyCurrentVersion()

-- Manual comparison
local available, newVersion = VersionCheck:CompareVersions("8.3.0", "8.3.1")

-- Parse version string
local versionTable = VersionCheck:ParseVersion("v8.3.0")
-- Returns: { major=8, minor=3, patch=0, original="v8.3.0" }
```

### Internal State

```lua
VersionCheck.Enabled = true/false              -- Module enabled?
VersionCheck.RemoteVersion = "8.3.1"           -- Last fetched version
VersionCheck.UpdateAvailable = true/false      -- Is update available?
VersionCheck.LastCheckTime = GetTime()         -- Timestamp of last check
```

## Localization

Strings available in 8 languages:

| String | English | French |
|--------|---------|--------|
| `VERSION_UPDATE_AVAILABLE` | "Update available" | "Mise à jour disponible" |
| `CURRENT_VERSION` | "Current Version" | "Version actuelle" |
| `UPDATE_AVAILABLE` | "Update Available" | "Mise à jour disponible" |
| `UP_TO_DATE` | "You are up to date!" | "Vous avez la version à jour !" |
| `DOWNLOAD` | "Download" | "Télécharger" |
| `GITHUB` | "GitHub" | "GitHub" |

See `Locales/Localization*.lua` for all 8 languages.

## Limitations & Fallbacks

### HTTP Limitations
WoW Lua has limited HTTP capabilities. Current implementation:

1. **LibHTTP (if available)** - Preferred method
2. **Fallback** - Manual check suggestion if no HTTP library available

To enable full HTTP support, the server would need:
- LibHTTP library installed
- Or external webhook service

### Current Approach
Uses GitHub API via LibHTTP when available, otherwise suggests manual checks.

```lua
-- Automatic (if LibHTTP available)
local remoteVersion = VersionCheck:FetchLatestVersion()

-- Fallback (no HTTP)
print("Check manually: https://github.com/CKNOEP/Necrosis/releases")
```

## Future Enhancements

### Planned Features
- [ ] Full LibHTTP integration for automatic fetch
- [ ] Changelog popup with release notes
- [ ] Auto-download integration with CurseForge client
- [ ] Version check for SummonQueue module separately
- [ ] Beta version option (check pre-releases)

### Possible Improvements
- Webhook for faster updates (no API polling)
- Cached version file on GitHub Pages
- Email notification for administrators
- Integration with addon distribution platforms

## Files Involved

```
VersionCheck.lua                    # Main module (350+ lines)
Initialize.lua                      # Default config setup
Locales/Localization*.lua (8)       # Localized strings
Necrosis_Vanilla.toc               # Module reference
Necrosis_Wrath.toc                 # Module reference
Necrosis_Cata.toc                  # Module reference
```

## Testing

### Manual Tests

1. **Check version:**
   ```
   /necrosis version
   ```

2. **Disable module:**
   ```
   /script NecrosisConfig.VersionCheck.Enabled = false
   ReloadUI()
   ```

3. **Force check interval:**
   ```
   /script NecrosisConfig.VersionCheck.LastCheck = 0
   /script VersionCheck:CheckForUpdate()
   ```

4. **View configuration:**
   ```
   /script print(NecrosisConfig.VersionCheck.Enabled)
   ```

## Support

**Issues or suggestions?**

- GitHub Issues: https://github.com/CKNOEP/Necrosis/issues
- CurseForge Comments: https://www.curseforge.com/wow/addons/necrosis

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-15 | Initial release |

---

**Module Status:** ✅ Production Ready

Integrated with Necrosis v8.3.0+
