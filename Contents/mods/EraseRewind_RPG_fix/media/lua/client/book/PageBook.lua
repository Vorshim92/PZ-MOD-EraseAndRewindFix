---@class ModData

local ModData = {}

--- **ModData Character**
---@return table<string, table<string, any>>
ModData.Character = {
    -- Chiavi per il controllo dell'uso dei libri
    READ_ONCE_BOOK = "readOnceBook",
    TIMED_BOOK = "timedBook",

    -- Chiavi specifiche per ReadOnceBook
    ReadOnceBook = {
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
    },

    -- Chiavi specifiche per TimedBook
    TimedBook = {
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
}

-- Aggiungi chiavi aggiuntive solo se le mod sono attive
if getActivatedMods():contains("SkillLimiter_fix") then
    ModData.Character.ReadOnceBook["SKILL_LIMITER"] = {}
    ModData.Character.TimedBook["SKILL_LIMITER"] = {}
    print("[ModData] SKILL_LIMITER aggiunto a ReadOnceBook e TimedBook")
end

if getActivatedMods():contains("SurvivalRewards") then
    ModData.Character.ReadOnceBook["kilMilReached"] = {}
    ModData.Character.TimedBook["kilMilReached"] = {}
    ModData.Character.ReadOnceBook["milReached"] = {}
    ModData.Character.TimedBook["milReached"] = {}
    print("[ModData] kilMilReached e milReached aggiunti a ReadOnceBook e TimedBook")
end

return ModData
