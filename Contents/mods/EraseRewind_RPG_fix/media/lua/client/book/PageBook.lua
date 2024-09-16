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
        SKILL_LIMITER = "characterSkillLimiter_ReadOnce"
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
        SKILL_LIMITER = "characterSkillLimiter_Timed"
    }
}

return ModData
