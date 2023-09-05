---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 01/04/23 21:20
---

--- LAST UPDATE 05-09-2023

local modDataManager = require("lib/ModDataManager")

function removeMoData()
    modDataManager.remove(EnumModData.CHARACTER_BOOST)
    modDataManager.remove(EnumModData.CHARACTER_CALORIES)
    modDataManager.remove(EnumModData.CHARACTER_LIFE_TIME)
    modDataManager.remove(EnumModData.CHARACTER_MULTIPLIER)
    modDataManager.remove(EnumModData.CHARACTER_PERK_DETAILS)
    modDataManager.remove(EnumModData.CHARACTER_PROFESSION)
    modDataManager.remove(EnumModData.CHARACTER_TRAITS)
    modDataManager.remove(EnumModData.CHARACTER_WEIGHT)
    modDataManager.remove(EnumModData.CHARACTER_ZOMBIE_KILLS)

    removeMil_kill_Reached()
end

--- **Read Book**
---@param character IsoGameCharacter
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function readBook(character)
    createCharacterPerkDetails(character)
    createZombieKills(character)
    createLifeTime()
    createCharacterNutrition()
    createTrait(character)
    createRecipe(character)
    createBoost(character)
    createMultiplier(character)

    ------- PATCH ------------
    --- survivalRewards 2797671069
    --- https://steamcommunity.com/sharedfiles/filedetails/?id=2797671069&searchtext=2797671069
    createMil_kill_Reached(character)
    --------------------------
    removeMoData()
end

--- **Write Book**
---@param character IsoGameCharacter
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function writeBook(character)
    writeCharacterPerkDetailsToHd(character)
    writeZombieKillsToHd(character)
    writeLifeTimeToHd()
    writeCharacterNutrition()
    writeTraitToHd(character)
    writeRecipeToHd(character)
    writeBoostToHd(character)
    writeMultiplierToHd(character)

    ------- PATCH ------------
    --- survivalRewards 2797671069
    --- https://steamcommunity.com/sharedfiles/filedetails/?id=2797671069&searchtext=2797671069
    writeMil_kill_ReachedToHd(character)
    --------------------------
end

