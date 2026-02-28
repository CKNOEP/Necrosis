# Audit Complet - Fonctions Spells (Necrosis v8.4.0)

**Date:** 2026-02-26
**Audit Focus:** Fonctions essentielles dans les fichiers Spells*.lua
**Files:** Spells.lua (1541 L), Spells-Cata.lua (1313 L), Spells-TBC.lua (1562 L), Spells-Vanilla.lua (1541 L)

---

## 1. ISSUES CRITIQUES IDENTIFIÉES

### 1.1 🔴 Double GetSpellInfo Call (IsSpellKnown - ligne 1040)

**Localisation:** Spells.lua:1040
**Sévérité:** HAUTE - Inefficacité
**Code actuel:**
```lua
if GetSpellInfo(GetSpellInfo(Necrosis.Warlock_Spell_Use[usage])) then
```

**Problème:**
- Appel imbriqué: `GetSpellInfo(GetSpellInfo(...))`
- Le premier GetSpellInfo retourne: `name, rank, iconID, castTime, minRange, maxRange`
- Le second GetSpellInfo reçoit un **string** (le nom du sort), PAS un ID
- Le comportement est indéfini/non-intentionnel

**Impact:**
- Appels API inutiles
- Logique erratique

**Correctif recommandé:**
```lua
local spellId = Necrosis.Warlock_Spell_Use[usage]
if spellId and GetSpellInfo(spellId) then
    return true
end
```

---

### 1.2 🔴 GetSpellByName - Uninitialized Variables (ligne 1066)

**Localisation:** Spells.lua:1060-1083
**Sévérité:** MOYENNE - Bugs potentiels
**Code actuel:**
```lua
function Necrosis.GetSpellByName(name)
    local s_id = nil
    local s_usage = ""
    local s_timer = false
    for i, v in pairs(Necrosis.Warlock_Spells) do
        if Necrosis.Warlock_Spells[i].Name == name then
            s_id = Necrosis.Warlock_Spell_Use[Necrosis.Warlock_Spells[i].Usage]
            s_usage = Necrosis.Warlock_Spells[i].Usage
            s_timer = (Necrosis.Warlock_Spells[i].Timer)
            s_buff = (Necrosis.Warlock_Spells[i].Buff and true or false)  -- ❌ NOT DECLARED
            s_cool = (Necrosis.Warlock_Spells[i].Buff and true or false)  -- ❌ NOT DECLARED + WRONG LOGIC
            break
        end
    end
    return s_id, s_usage, s_timer, s_buff, s_cool  -- ❌ GLOBALS CREATED
end
```

**Problèmes:**
1. `s_buff` et `s_cool` jamais déclarés avec `local`
2. Crée des variables globales implicites
3. `s_cool` utilise `Buff` au lieu de `Cooldown`
4. Fonction retourne 5 valeurs mais les 2 dernières sont mal initialisées

**Impact:** Pollue l'espace global, logique incorrecte

**Correctif:**
```lua
function Necrosis.GetSpellByName(name)
    local s_id, s_usage, s_timer, s_buff, s_cool = nil, "", false, false, false
    for i, v in pairs(Necrosis.Warlock_Spells) do
        if v.Name == name then
            local spell = Necrosis.Warlock_Spells[i]
            s_id = Necrosis.Warlock_Spell_Use[spell.Usage]
            s_usage = spell.Usage
            s_timer = spell.Timer or false
            s_buff = spell.Buff or false
            s_cool = spell.Cooldown or 0
            break
        end
    end
    return s_id, s_usage, s_timer, s_buff, s_cool
end
```

---

### 1.3 🟡 IsSpellDemon - Repeated GetSpellName Calls (ligne 1184-1189)

**Localisation:** Spells.lua:1183-1196
**Sévérité:** MOYENNE - Performance
**Code actuel:**
```lua
function Necrosis.IsSpellDemon(name)
    if name == Necrosis.GetSpellName("imp")         -- Call 1
    or name == Necrosis.GetSpellName("voidwalker")  -- Call 2
    or name == Necrosis.GetSpellName("succubus")    -- Call 3
    or name == Necrosis.GetSpellName("inccubus")    -- Call 4
    or name == Necrosis.GetSpellName("felhunter")   -- Call 5
    or name == Necrosis.GetSpellName("felguard")    -- Call 6
    then
        return true
    else
        return false
    end
end
```

**Problème:**
- 6 appels GetSpellName() à chaque invocation
- Chaque GetSpellName traverse 2 tables (Warlock_Spell_Use + Warlock_Spells)
- Appelé potentiellement plusieurs fois par frame

**Impact:** Performance dégradée si appelé dans OnUpdate

**Correctif:**
```lua
function Necrosis.IsSpellDemon(name)
    -- Demon usage keys
    local demonUsages = {"imp", "voidwalker", "succubus", "inccubus", "felhunter", "felguard"}
    for _, usage in ipairs(demonUsages) do
        if name == Necrosis.GetSpellName(usage) then
            return true
        end
    end
    return false
end
```

Ou meilleure approche (cache):
```lua
-- Cache built at SpellSetup
local demonNames = {}
for _, usage in ipairs({"imp", "voidwalker", "succubus", "inccubus", "felhunter", "felguard"}) do
    table.insert(demonNames, Necrosis.GetSpellName(usage))
end

function Necrosis.IsSpellDemon(name)
    for _, dName in ipairs(demonNames) do
        if name == dName then return true end
    end
    return false
end
```

---

### 1.4 🟡 IsSpellRez - Excessive Ternary Operators (ligne 1198-1214)

**Localisation:** Spells.lua:1198-1214
**Sévérité:** MOYENNE - Lisibilité + Performance
**Code actuel:**
```lua
function Necrosis.IsSpellRez(name)
    if name == (Necrosis.Warlock_Spell_Use["minor_ss_used"]
        and Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["minor_ss_used"]].Name or "")
    or name == (Necrosis.Warlock_Spell_Use["lesser_ss_used"]
        and Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["lesser_ss_used"]].Name or "")
    or name == (Necrosis.Warlock_Spell_Use["ss_used"]
        and Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use["ss_used"]].Name or "")
    -- ... 3 more similar lines
    then
        return true
    else
        return false
    end
end
```

**Problèmes:**
1. Répétition massive: 7 lignes quasi-identiques
2. Imbrication d'accès aux tables à chaque vérification
3. Effectue 14 accès table dans le pire cas
4. Difficile à maintenir si un nouveau rank de soulstone est ajouté

**Impact:** Performance + Maintenabilité

**Correctif:**
```lua
function Necrosis.IsSpellRez(name)
    local rezUsages = {
        "minor_ss_used", "lesser_ss_used", "ss_used",
        "greater_ss_used", "major_ss_used", "master_ss_used", "demonic_ss_used"
    }

    for _, usage in ipairs(rezUsages) do
        local spellId = Necrosis.Warlock_Spell_Use[usage]
        if spellId and name == Necrosis.Warlock_Spells[spellId].Name then
            return true
        end
    end
    return false
end
```

---

### 1.5 🟡 IsHealthStone/IsSoulStone/IsFireStone/IsSpellStone - Duplicate Code

**Localisation:** Spells.lua:1259-1314
**Sévérité:** MOYENNE - DRY Principle Violation

**Code:**
```lua
function Necrosis.IsHealthStone(id)
    local res = false
    for i, v in pairs (Necrosis.Warlock_Lists.health_stones) do
        if id == v.id then
            res = true
            break
        end
    end
    return res
end

function Necrosis.IsSoulStone(id)
    local res = false
    for i, v in pairs (Necrosis.Warlock_Lists.soul_stones) do
        if id == v.id then
            res = true
            break
        end
    end
    return res
end
-- ... 2 more identical functions
```

**Problème:** 4 fonctions quasi-identiques (56 lignes total), une seule logique

**Correctif - Unified Function:**
```lua
-- Helper function
local function IsItemInList(id, listName)
    local list = Necrosis.Warlock_Lists[listName]
    if not list then return false end
    for _, v in pairs(list) do
        if id == v.id then return true end
    end
    return false
end

-- Wrappers for compatibility
function Necrosis.IsHealthStone(id) return IsItemInList(id, "health_stones") end
function Necrosis.IsSoulStone(id) return IsItemInList(id, "soul_stones") end
function Necrosis.IsFireStone(id) return IsItemInList(id, "fire_stones") end
function Necrosis.IsSpellStone(id) return IsItemInList(id, "spell_stones") end
```

**Impact:** 40+ lignes de code mort, maintenance

---

## 2. ISSUES MODÉRÉES IDENTIFIÉES

### 2.1 🟡 IsSpellMount - Hard-coded Spell IDs (ligne 1216-1224)

**Localisation:** Spells.lua:1216
**Code:**
```lua
function Necrosis.IsSpellMount(name)
    if name == Necrosis.Warlock_Spells[5784].Name      -- 5784 = Felsteed
    or name == Necrosis.Warlock_Spells[23161].Name     -- 23161 = Dreadsteed
    then
        return true
    else
        return false
    end
end
```

**Problème:** Hard-coded spell IDs (5784, 23161) contrairement au pattern Usage utilisé ailleurs

**Correctif:**
```lua
function Necrosis.IsSpellMount(name)
    local mountNames = {}
    for _, usage in ipairs({"mounts"}) do
        local mountId = Necrosis.Warlock_Spell_Use[usage]
        if mountId then
            table.insert(mountNames, Necrosis.Warlock_Spells[mountId].Name)
        end
    end

    for _, mName in ipairs(mountNames) do
        if name == mName then return true end
    end
    return false
end
```

---

### 2.2 🟡 SpellSetup - Complex UsageRank Logic (ligne 1369+)

**Localisation:** Spells.lua:1369-1468
**Sévérité:** MOYENNE - Complexité

**Problèmes observés:**
1. **Double assignment logic** (lignes 1442-1450 vs 1397-1405)
   - Initialise avec lowest rank (ligne 1442)
   - Puis met à jour si known (ligne 1397)
   - Logique contraire dans deux endroits

2. **Nested Update function** avec accès à variables externes
   - `self` vs paramètres
   - Difficult à tester unitairement

3. **Debug spam:** Logging volumineux si `Debug.spells_init = true`

**Correctif:**
```lua
function Necrosis:SpellSetup(reason)
    Necrosis.Warlock_Spell_Use = {}

    -- Step 1: Initialize all spells with lowest rank
    for id, v in pairs(Necrosis.Warlock_Spells) do
        local spell_name = GetSpellInfo(id)
        if spell_name then
            v.Name = spell_name
            v.ID = id
            v.Mana = getManaCost(id) or 0
            v.InSpellBook = false

            -- Initialize usage with this spell (may be overwritten by higher rank)
            if not Necrosis.Warlock_Spell_Use[v.Usage] then
                Necrosis.Warlock_Spell_Use[v.Usage] = id
            end
        end
    end

    -- Step 2: Find known spells and update to highest rank
    for tabIndex = 1, 12 do
        local tabName, tabTexture, offset, numSpells = GetSpellTabInfo(tabIndex)
        if not tabName then break end

        for i = 1, numSpells do
            local spellId = FindSpellBookItemByName(tabName, BOOKTYPE_SPELL)
            if spellId and Necrosis.Warlock_Spells[spellId] then
                -- Update if this is higher rank
                local usage = Necrosis.Warlock_Spells[spellId].Usage
                local currentId = Necrosis.Warlock_Spell_Use[usage]
                if Necrosis.Warlock_Spells[spellId].UsageRank
                   > Necrosis.Warlock_Spells[currentId].UsageRank then
                    Necrosis.Warlock_Spell_Use[usage] = spellId
                    Necrosis.Warlock_Spells[spellId].InSpellBook = true
                end
            end
        end
    end
end
```

---

### 2.3 🟡 IsSoulPouch - Linear Search (ligne 1238-1257)

**Localisation:** Spells.lua:1238
**Code:**
```lua
function Necrosis.IsSoulPouch(name)
    local res = false
    for i, v in pairs (Necrosis.Warlock_Lists.soul_bags) do
        if name == v.name then
            res = true
            break
        end
    end
    return res
end
```

**Problème:** Linear search O(n), appelé potentiellement plusieurs fois en rapide succession lors du scan des sacs

**Correctif - Cache at SpellSetup:**
```lua
-- In SpellSetup(), build lookup table:
Necrosis.Warlock_Lists.soul_bags_lookup = {}
for i, v in pairs(Necrosis.Warlock_Lists.soul_bags) do
    Necrosis.Warlock_Lists.soul_bags_lookup[v.name] = true
end

-- Fast O(1) lookup:
function Necrosis.IsSoulPouch(name)
    return Necrosis.Warlock_Lists.soul_bags_lookup[name] or false
end
```

---

### 2.4 🟡 GetSpellMana/GetSpellRank/GetSpellName - Repeated Pattern (ligne 1085-1113)

**Code:**
```lua
function Necrosis.GetSpellMana(usage)
    if Necrosis.Warlock_Spell_Use[usage] then
        return Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].Mana
    else
        return ""
    end
end

function Necrosis.GetSpellRank(usage)
    if Necrosis.Warlock_Spell_Use[usage] then
        return Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]].SpellRank
    else
        return ""
    end
end

function Necrosis.GetSpellName(usage)
    if Necrosis.Warlock_Spell_Use[usage] then
        local spell = Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]]
        if spell and spell.Name then
            return spell.Name
        end
    end
    return ""
end
```

**Problème:** Motif répété 3x, manque consistance (GetSpellName a guards supplémentaires)

**Correctif:**
```lua
local function GetSpellField(usage, field, default)
    if not Necrosis.Warlock_Spell_Use[usage] then
        return default or ""
    end
    local spell = Necrosis.Warlock_Spells[Necrosis.Warlock_Spell_Use[usage]]
    return (spell and spell[field]) or default or ""
end

function Necrosis.GetSpellMana(usage) return GetSpellField(usage, "Mana", 0) end
function Necrosis.GetSpellRank(usage) return GetSpellField(usage, "SpellRank", 0) end
function Necrosis.GetSpellName(usage) return GetSpellField(usage, "Name", "") end
```

---

## 3. OPPORTUNITÉS D'OPTIMISATION

### 3.1 Cache Stone Item IDs at Startup

**Actuel:** IsHealthStone/IsSoulStone/etc. font Linear search chaque fois

**Proposé:** Build hash lookup tables lors de SpellSetup():
```lua
-- At SpellSetup:
Necrosis.StoneIdLookup = {
    health = {},
    soul = {},
    spell = {},
    fire = {},
}

for i, v in pairs(Necrosis.Warlock_Lists.health_stones) do
    Necrosis.StoneIdLookup.health[v.id] = true
end
-- ... similar for other stone types

-- Usage:
function Necrosis.IsHealthStone(id)
    return Necrosis.StoneIdLookup.health[id] or false
end
```

**Gain:** O(n) → O(1), especially important in bag scanning

---

### 3.2 Pre-compute Demon Names at Startup

**Actuel:** IsSpellDemon calls GetSpellName 6x every invocation

**Proposé:**
```lua
-- At SpellSetup:
Necrosis.DemonSpellNames = {}
for _, usage in ipairs({"imp", "voidwalker", "succubus", "inccubus", "felhunter", "felguard"}) do
    local name = Necrosis.GetSpellName(usage)
    if name ~= "" then
        Necrosis.DemonSpellNames[name] = true
    end
end

-- Usage:
function Necrosis.IsSpellDemon(name)
    return Necrosis.DemonSpellNames[name] or false
end
```

**Gain:** 6 function calls → 1 table lookup

---

### 3.3 Unify Stone Checking Functions

**Actuel:** 4 functions with identical logic (56 lines)

**Proposé:** Single parametric function (6 lines)

**Gain:** -50 lines, easier maintenance

---

### 3.4 Consolidate UsageRank Logic in SpellSetup

**Actuel:** Conflicting logic in 2 places (init vs. update)

**Proposé:** Single pass: Initialize all → Update known → Sort by rank

**Gain:** Simpler, more testable, less error-prone

---

## 4. CODE QUALITY ISSUES

| Issue | Count | Severity | Effort |
|-------|-------|----------|--------|
| Uninitialized locals → globals | 2 | HIGH | 15min |
| Double function calls | 2 | MEDIUM | 20min |
| Duplicate code (4 functions) | 4 | MEDIUM | 30min |
| Repeated patterns | 3 | LOW | 25min |
| Linear searches | 2 | LOW | 20min |
| Hard-coded IDs | 1 | LOW | 10min |
| Logic inconsistencies | 2 | MEDIUM | 20min |

**Total Technical Debt:** ~2 hours refactoring effort

---

## 5. RECOMMENDED FIXES PRIORITY

### 🔴 IMMEDIATE (v8.4.1 Hotfix)
1. Fix GetSpellByName global variable leak (creates s_buff, s_cool globals)
2. Fix IsSpellKnown double GetSpellInfo call

### 🟡 SHORT-TERM (v8.5.0)
1. Consolidate stone checking functions
2. Cache stone item IDs in lookup tables
3. Pre-compute demon spell names
4. Fix IsSpellRez excessive ternary operators

### 🟢 MEDIUM-TERM (v9.0.0 refactor)
1. Refactor SpellSetup UsageRank logic
2. Unify GetSpell* getter functions
3. Add comprehensive unit tests
4. Profile impact of spell lookups in OnUpdate

---

## 6. TESTING RECOMMENDATIONS

### Unit Tests Needed
- `IsSpellKnown()` with known/unknown spells
- `GetSpellByName()` return value consistency
- `IsSpellDemon()` all 6 demon types
- `IsSpellRez()` all 7 soulstone types
- Stone checking functions with various item IDs

### Integration Tests
- SpellSetup on fresh load
- SpellSetup after spell learn event
- Spell lookups in OnUpdate context

---

## 7. CODE COVERAGE ANALYSIS

| Function | Callsites | Frequency |
|----------|-----------|-----------|
| GetSpellName | 8+ | HIGH (OnUpdate, menus) |
| GetSpellByName | 2 | MEDIUM |
| IsSpellKnown | 3 | LOW |
| IsSpellDemon | 4 | MEDIUM |
| IsSpellRez | 2 | LOW |
| Stone checks | 5+ | HIGH (bag scanning) |
| SpellSetup | 2 | LOW (load + event) |

**High-frequency functions need optimization focus**

---

## SUMMARY

- **24 Public Functions** across spell files
- **7 Critical/Moderate Issues** identified
- **4 Quick Wins** for optimization (cache, unify)
- **~2 hours** refactoring effort to resolve all issues
- **Potential Gains:**
  - Remove global variable leaks
  - O(n) → O(1) stone lookups
  - 60% fewer GetSpellName calls
  - Improved code maintainability

**Next Steps:** User to test v8.4.0 weekend, then schedule spells refactoring for v8.5.0

