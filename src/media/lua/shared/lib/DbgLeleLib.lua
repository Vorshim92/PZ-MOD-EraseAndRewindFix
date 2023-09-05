---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 27/03/23 09:38
---

---@class DbgLeleLib

local DbgLeleLib = {}
local characterPz = require("lib/CharacterPZ")
local isoPlayerPZ = require("lib/IsoPlayerPZ")
local characterLib = require("CharacterLib")
local perkFactoryPZ = require("lib/PerkFactoryPZ")

-- -----------------------------------------------------------

local results = {
    ---@type int
    passed = 0,
    ---@type int
    notPassed = 0
}

---@type string
local test_ = "Test - "

---@type string
local fail_ = " >>>>>>>>>>>>>> FAIL"

---@type string
local ok_ = " >>>>>>>>>>>>>> PASSED"

---@type boolean
local advancedTest

--- **Show more info about test**
---@param advancedTest_ boolean
function DbgLeleLib.enableAdvancedTest(advancedTest_)
    advancedTest = advancedTest_
end

--- **PrintTestResult** if **true** test passed, if **false** not passed
---@param nameTest string
---@param flag boolean
local function printTestResult(nameTest, flag)
    if (flag) then
        print(test_ .. nameTest .. ok_)
        return
    end

    print(test_ .. nameTest .. fail_)
end

--- **Show all Result**
---@param expectedValue
---@param currentValue
---@param nameTest string
---@return boolean
function DbgLeleLib.showAllResult(expectedValue, currentValue, nameTest)
    if expectedValue == currentValue then
        printTestResult(nameTest, true)
        return true
    end

    printTestResult(nameTest, false)
    return false
end

--- **Show Only False Results**
---@param expectedValue
---@param currentValue
---@param nameTest string
---@return boolean
function DbgLeleLib.showOnlyFalseResult(expectedValue, currentValue, nameTest)
    if expectedValue ~= currentValue then
        DbgLeleLib.showAllResult(expectedValue, currentValue, nameTest)
        return false
    end

    return true
end

-- TODO: advancedTest check doesn't work
--- **Unit Lua, check methods**
---@param expectedValue
---@param currentValue
---@param nameTest string
---@return int result

function DbgLeleLib.checkTest(expectedValue, currentValue, nameTest)

    if advancedTest then
        if DbgLeleLib.showAllResult(expectedValue, currentValue, nameTest) then
            results.passed = results.passed + 1
        else
            results.notPassed = results.notPassed + 1
        end
    else
        if DbgLeleLib.showOnlyFalseResult(expectedValue, currentValue, nameTest) then
            results.passed = results.passed + 1
        else
            results.notPassed = results.notPassed + 1
        end
    end
end

function DbgLeleLib.displayTest()
    print("------------------CHECK TEST------------------")
    print("PASSED: >>>>>>>>>>>>>>> ", results.passed)
    print("NOT PASSED:  >>>>>>>>>> ", results.notPassed)

    results.passed = 0
    results.notPassed = 0
end

--- **Get Profession ENUM**
---@return string
DbgLeleLib.Profession = {
    UNEMPLOYED = "",
    BURGER_FLIPPER = "burgerflipper",
    BURGLAR = "burglar",
    CARPENTER = "carpenter",
    CHEF = "chef",
    CONSTRUCTION_WORKER = "constructionworker",
    DOCTOR = "doctor",
    ELECTRICIAN = "electrician",
    ENGINEER = "engineer",
    FARMER = "farmer",
    FISHERMAN = "fisherman",
    FIRE_OFFICER = "fireofficer",
    FITNESS_INSTRUCTOR = "fitnessInstructor",
    LUMBERJACK = "lumberjack",
    MECHANICS = "mechanics",
    METAL_WORKER = "metalworker",
    NURSE = "nurse",
    PARK_RANGER = "parkranger",
    POLICE_OFFICER = "policeofficer",
    REPAIRMAN = "repairman",
    SECURITY_GUARD = "securityguard",
    VETERAN = "veteran"
}

--- **Get Perk ENUM**
---@return PerkFactory.Perk perk
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
DbgLeleLib.Perks = {
    AGILITY = Perks.Agility,
    AIMING = Perks.Aiming,
    AXE = Perks.Axe,
    BLACKSMITH = Perks.Blacksmith,
    COMBAT = Perks.Combat,
    COOKING = Perks.Cooking,
    CRAFTING = Perks.Crafting,
    DOCTOR = Perks.Doctor,
    ELECTRICITY = Perks.Electricity,
    FARMING = Perks.Farming,
    FIREARM = Perks.Firearm,
    FISHING = Perks.Fishing,
    FITNESS = Perks.Fitness,
    LIGHTFOOT = Perks.Lightfoot,
    LONGBLADE = Perks.LongBlade,
    LONGBLUNT = Perks.Blunt,
    MAINTENANCE = Perks.Maintenance,
    MECHANICS = Perks.Mechanics,
    MELEE = Perks.Melee,
    MELTING = Perks.Melting,
    METALWELDING = Perks.MetalWelding,
    NIMBLE = Perks.Nimble,
    NONE = Perks.None,
    PASSIV = Perks.Passiv,
    PLANTSCAVENGING = Perks.PlantScavenging,
    RELOADING = Perks.Reloading,
    SMALLBLADE = Perks.SmallBlade,
    SMALLBLUNT = Perks.SmallBlunt,
    SNEAK = Perks.Sneak,
    SPEAR = Perks.Spear,
    SPRINTING = Perks.Sprinting,
    STRENGTH = Perks.Strength,
    SURVIVALIST = Perks.Survivalist,
    TAILORING = Perks.Tailoring,
    TRAPPING = Perks.Trapping,
    WOODWORK = Perks.Woodwork,
}

--- **Create a line**
function DbgLeleLib.printLine()
    print("---------------------------------------------------------------------")
end

--- **Set Perk Level**
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param level int
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
--- - IsoGameCharacter.XP : zombie.characters.IsoGameCharacter.XP
function DbgLeleLib.setPerkLevel(character, perk, level)
    characterPz.removePerkLevel(character, perk)

    local convertLevelToXp = 0.0

    for level_ = 1, level do
        convertLevelToXp = convertLevelToXp +
                perkFactoryPZ.convertLevelToXp(perk, level_)
    end

    characterPz.addXP_PZ(character, perk, convertLevelToXp, false, false, true)
end

--- **Display**
---@param displayName
---@param i
---@param perk
---@param level
---@param xp
function DbgLeleLib.display(displayName, i, perk, level, xp)
    local dbg1 = perk
    local dbg2 = level
    local dbg3 = xp
    print(displayName .. " " ..
        tostring(i) .. " >> " .. tostring(perk) .. " - " ..
        tostring(level) .. " - " .. tostring(xp) )
    local dbg
end

--- **Display Advanced**
---@param displayName
---@param i
---@param perk
---@param level
---@param xp
function DbgLeleLib.displayAdvanced(displayName, i, perk, level, xp)
    local dbg1 = perk
    local dbg2 = level
    local dbg3 = xp

    print(displayName .. " " ..
        tostring(i) .. " >> " ..
        type(perk) .. " " .. tostring(perk) .. " - " ..
        type(level) .. " " .. tostring(level) .. " - " ..
        type(xp) .. " " .. tostring(xp) )
    local dbg
end

--- **Check Perk**
---@param displayName string
---@param perk_ PerkFactory.Perk
---@param perk PerkFactory.Perk
---@param level int
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
function DbgLeleLib.checkPerk(displayName, perk, perk_ )
    -- Perks.Maintenance
    local dbg1 = perk
    local dbg2 = perk_

    if perk == perk_ then
        DbgLeleLib.printLine()
        DbgLeleLib.display(displayName, nil, perk, perk_, nil)
        DbgLeleLib.printLine()
        local dbg
    end
end

--- **Display CharacterObj**
---@param displayName string
---@param CharacterBaseObj CharacterBaseObj
function DbgLeleLib.displayCharacterObj(displayName, CharacterBaseObj)
    DbgLeleLib.printLine()
    for i, v in pairs(CharacterBaseObj) do
        DbgLeleLib.display(displayName, i,
                v:getPerk(), v:getLevel(), v:getXp())
        --DbgLeleLib.displayAdvanced(displayName, i,
        --        v:getPerk(), v:getLevel(), v:getXp())
    end
    DbgLeleLib.printLine()
end

--- **displayListPerks**
---@param displayName string
---@param perks_list
function DbgLeleLib.displayListPerks(displayName, perks_list)
    DbgLeleLib.printLine()
    for i, v in pairs(perks_list) do
        DbgLeleLib.display(displayName, i, v.perk, v.level, nil)
        -- DbgLeleLib.displayAdvanced(displayName, i, v.perk, v.level, nil)
        -- DBG_GetCheckPerk("DBG_GetCheckPerk", v.perk_, v.perk, _ )
    end
    DbgLeleLib.printLine()
end

--- **Times Count**
---@param count int
---@param count2 int
function DbgLeleLib.timesCount(count, count2)
    if count == count2 then
        return true
    end

    return false
end

--- **Delete Character**
function DbgLeleLib.deleteCharacter()
    local character = getPlayer()
    local zero = 0.0
    local CharacterDeleteObj = CharacterBaseObj:new()

    -- remove all Perk Boosts
    CharacterDeleteObj = characterLib.getAllPerks(character)

    for _, v in pairs(CharacterDeleteObj:getPerkDetails()) do
        characterPz.removePerkBoost(character, v:getPerk())
    end

    -- remove Zombie Kills
    characterPz.setZombieKills_PZ(character, characterPz.EnumNumbers.ZERO)

    -- remove Hours Survived
    isoPlayerPZ.setHoursSurvived_PZ(zero)

    -- remove Multiplier
    for _, v in pairs(CharacterDeleteObj:getPerkDetails()) do
        characterPz.removeMultiplier(character, v:getPerk())
    end

    -- remove Calories
    isoPlayerPZ.setCalories_PZ(zero)

    -- remove Weight
    isoPlayerPZ.setWeight_PZ(zero)

    -- remove Perk Level
    for _, v in pairs(CharacterDeleteObj:getPerkDetails()) do
        characterPz.removePerkLevel(character, v:getPerk())
    end

    -- remove Profession
    characterPz.removeProfession(character)

    -- remove Know Recipe
    CharacterDeleteObj = characterLib.getKnownRecipes(character)

    for _, v in pairs(CharacterDeleteObj:getRecipes()) do
        characterPz.removeKnowRecipe_PZ(character, v)
    end

    -- remove All Traits
    characterPz.removeAllTraits_PZ(character)

    character = getPlayer()
end

--- **Create Character**
function DbgLeleLib.createCharacter()
    local character = getPlayer()

    -- set profession
    characterPz.setProfession_PZ(character, DbgLeleLib.Profession.CARPENTER)

    -- set level
    characterPz.setPerkLevelFromXp(character, Perks.Fitness, 37500)
    characterPz.setPerkLevelFromXp(character, Perks.Strength, 37500)
    characterPz.setPerkLevelFromXp(character, Perks.Woodwork, 1275)
    characterPz.setPerkLevelFromXp(character, Perks.Maintenance, 75)
    characterPz.setPerkLevelFromXp(character, Perks.SmallBlunt, 75)

    -- set boost
    characterPz.setPerkBoost_PZ(character, Perks.Fitness, 3)
    characterPz.setPerkBoost_PZ(character, Perks.Strength, 3)
    characterPz.setPerkBoost_PZ(character, Perks.Woodwork, 3)

    -- set trait
    characterPz.setTraitsPerk_PZ(character,"HardOfHearing" )
    characterPz.setTraitsPerk_PZ(character,"SlowReader" )
    characterPz.setTraitsPerk_PZ(character,"Handy" )

    -- set zombie kills
    characterPz.setZombieKills_PZ(character, 15)

    -- set multiplier
    characterPz.addXpMultiplier_PZ(character, Perks.Cooking, 1.0,
            characterPz.EnumNumbers.ONE, characterPz.EnumNumbers.ONE)

    -- set recipe
    local recipe = "Make Pizza"
    characterPz.addKnownRecipe(character, recipe)

    -- set Hours Survived
    isoPlayerPZ.setHoursSurvived_PZ(10)

    -- set Calories
    isoPlayerPZ.setCalories_PZ(1500)

    -- set Weight
    isoPlayerPZ.setWeight_PZ(92)

    character = getPlayer()
end

return DbgLeleLib



