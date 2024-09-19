---@class ModData

local ModData = {}

--- **ModData Character**
---@return table<string, table<string, any>>
    -- Chiavi per il controllo dell'uso dei libri
    ModData.READ_ONCE_BOOK = "readOnceBook"
    ModData.TIMED_BOOK = "timedBook"

    -- Chiavi specifiche per ReadOnceBook
    ModData.ReadOnceBook = {
        ["BOOST"] = {},
        ["CALORIES"] = {},
        ["LIFE_TIME"] = {},
        ["MULTIPLIER"] = {},
        ["PERK_DETAILS"] = {},
        ["PROFESSION"] = {},
        ["RECIPES"] = {},
        ["TRAITS"] = {},
        ["WEIGHT"] = {},
        ["KILLED_ZOMBIES"] = {}
    }

    -- Chiavi specifiche per TimedBook
    ModData.TimedBook = {
        ["BOOST"] = {},
        ["CALORIES"] = {},
        ["LIFE_TIME"] = {},
        ["MULTIPLIER"] = {},
        ["PERK_DETAILS"] = {},
        ["PROFESSION"] = {},
        ["RECIPES"] = {},
        ["TRAITS"] = {},
        ["WEIGHT"] = {},
        ["KILLED_ZOMBIES"] = {}
    }


-- Aggiungi chiavi aggiuntive solo se le mod sono attive
if getActivatedMods():contains("SkillLimiter_fix") then
    ModData.ReadOnceBook["SKILL_LIMITER"] = {}
    ModData.TimedBook["SKILL_LIMITER"] = {}
    print("[ModData] SKILL_LIMITER aggiunto a ReadOnceBook e TimedBook")
end

if getActivatedMods():contains("SurvivalRewards") then
    ModData.ReadOnceBook["kilMilReached"] = {}
    ModData.TimedBook["kilMilReached"] = {}
    ModData.ReadOnceBook["milReached"] = {}
    ModData.TimedBook["milReached"] = {}
    print("[ModData] kilMilReached e milReached aggiunti a ReadOnceBook e TimedBook")
end

return ModData
