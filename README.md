# 🧙‍♂️ Necrosis - World of Warcraft Warlock Addon

**Version:** 8.2.21+ (Development)
**Maintainer:** CKNOEP
**GitHub:** https://github.com/CKNOEP/Necrosis

---

## ⚠️ IMPORTANT - ACTIVE DEVELOPMENT

**This addon is under active development.** Modifications and bug fixes are committed regularly.

### If you're downloading from CurseForge:
- ✅ Use **CurseForge Client** for automatic updates (recommended)
- ✅ Use **WowUp** or similar addon manager
- ❌ Do **NOT** manually modify files if you want to use automatic updates

### If you're using the GitHub version:
- 📥 Clone from: `https://github.com/CKNOEP/Necrosis.git`
- 🔧 You can safely modify files locally
- 🚀 Pull latest changes with `git pull`

---

## 🛠️ Development Setup (For Contributors)

### To avoid CurseForge conflicts:

**Option 1: Separate Development Folder (Recommended)**
```
Addons/
  ├── Necrosis/          ← Keep original (CurseForge managed)
  └── Necrosis-Dev/      ← Your development copy
```

**Option 2: GitHub Clone**
```bash
git clone https://github.com/CKNOEP/Necrosis.git Necrosis-Dev
cd Necrosis-Dev
git checkout -b dev origin/main
```

---

## 📝 Recent Fixes (Session 14/02/2026)

### Bug #21 - First Startup Click Issue ✅
- **Problem:** Clicks on spells/demons didn't work on first game startup
- **Fixed:**
  - Removed double GetSpellInfo() calls
  - Added menu button creation before attribute configuration
  - Re-scan spell data after 3-second delay

**Commit:** `88a3a57` - https://github.com/CKNOEP/Necrosis/commit/88a3a57

---

## 🤝 Contributing

If you want to contribute:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature`
3. **Commit** your changes with clear messages
4. **Push** to your fork
5. **Create** a Pull Request to `main`

---

## 📋 License

See `_GPL_V2.txt` and `_Copyright.txt` for details.

---

**Developed for WoW Classic (Vanilla, TBC, Wrath, Cata)**
