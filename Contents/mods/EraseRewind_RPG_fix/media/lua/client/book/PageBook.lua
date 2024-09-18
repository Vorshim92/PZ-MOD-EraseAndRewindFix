---@class ModData

local ModData = {}

--- **ModData Character**
---@return table string
ModData.Character = {
    -- Chiavi per il controllo dell'uso dei libri
    READ_ONCE_BOOK = "readOnceBook",
    TIMED_BOOK = "timedBook",

    -- Chiavi specifiche per ReadOnceBook
    ReadOnceBook = {
        BOOST = "characterBoost_ReadOnce",
        CALORIES = "characterCalories_ReadOnce",
        LIFE_TIME = "characterLifeTime_ReadOnce",
        MULTIPLIER = "characterMultiplier_ReadOnce",
        PERK_DETAILS = "characterPerkDetails_ReadOnce",
        PROFESSION = "characterProfession_ReadOnce",
        RECIPES = "characterRecipes_ReadOnce",
        TRAITS = "characterTraits_ReadOnce",
        WEIGHT = "characterWeight_ReadOnce",
        KILLED_ZOMBIES = "characterKilledZombies_ReadOnce",
    },

    -- Chiavi specifiche per TimedBook
    TimedBook = {
        BOOST = "characterBoost_Timed",
        CALORIES = "characterCalories_Timed",
        LIFE_TIME = "characterLifeTime_Timed",
        MULTIPLIER = "characterMultiplier_Timed",
        PERK_DETAILS = "characterPerkDetails_Timed",
        PROFESSION = "characterProfession_Timed",
        RECIPES = "characterRecipes_Timed",
        TRAITS = "characterTraits_Timed",
        WEIGHT = "characterWeight_Timed",
        KILLED_ZOMBIES = "characterKilledZombies_Timed",
    },

    newReadOnceBook = {
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

if getActivatedMods():contains("SkillLimiter_fix") then
    ModData.Character.ReadOnceBook.SKILL_LIMITER = "characterSkillLimiter_ReadOnce"
    ModData.Character.TimedBook.SKILL_LIMITER = "characterSkillLimiter_Timed"
end
if getActivatedMods():contains("SurvivalRewards") then
    ModData.Character.ReadOnceBook.kilMilReached = "characterKilMilReached_ReadOnce"
    ModData.Character.TimedBook.kilMilReached = "characterKilMilReached_Timed"

    ModData.Character.ReadOnceBook.milReached = "characterMilReached_ReadOnce"
    ModData.Character.TimedBook.milReached = "characterMilReached_Timed"
end

return ModData
