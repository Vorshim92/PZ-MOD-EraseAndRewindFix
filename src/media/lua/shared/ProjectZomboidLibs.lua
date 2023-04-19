---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 12/02/23 10:20
--- V002

---@class ProjectZomboidLibs

require("media.lua.shared.objects.CharacterObj")

---Get Character Traits
---@param character IsoGameCharacter
---@return CharacterObj table - PerkFactory.Perk perk, int level
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function getCharacterTraits(character)
    local CharacterObj01 = CharacterObj:new(nil)

    local traits_PZ = getTraits_PZ(character)

    for i = 0, traits_PZ:size() - 1 do
        local traitMap = TraitFactory.getTrait(traits_PZ:get(i) ):getXPBoostMap()
        local traitKahluaTable = transformIntoKahluaTable(traitMap)

        for perk, level in pairs(traitKahluaTable) do
            CharacterObj01:addPerkDetails(perk, level:intValue(), nil)
        end
    end

    return CharacterObj01:getPerkDetails()
end

---Get Character Profession
---@param character IsoGameCharacter
---@return CharacterObj getPerkDetails() -- table PerkFactory.Perk perk, int level, float xp
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function getCharacterProfession(character)
    local CharacterObj01 = CharacterObj:new(nil)

    local characterProfession_PZ = getCharacterProfession_PZ(character)
    local professionMap = ProfessionFactory.getProfession(characterProfession_PZ):getXPBoostMap()
    local professionKahluaTable = transformIntoKahluaTable(professionMap)

    for perk, level in pairs(professionKahluaTable) do
        CharacterObj01:addPerkDetails(perk, level:intValue(), nil)
    end

    return CharacterObj01:getPerkDetails()
end

---Get character and get current skill/trait
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@return PerkDetailsObj getPerkDetailsObj()
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
function getCharacterCurrentSkill(character, perk)
    -- Perks.Maintenance
    -- Perks.Woodwork
    -- Perks.Sprinting
    if not character then
        return nil
    end

    local CharacterObj01 = CharacterObj:new(nil)

    local profession = getCharacterProfession_PZ(character)
    local perk_ = getPerk_PZ(perk)
    local level = getPerkLevel_PZ(character, perk_)
    local xp = getXpPerk_PZ(character, perk_)
    CharacterObj01:currentCharacter(profession, perk_, level, xp)

    return CharacterObj01:getPerkDetailsObj()
end

---Get character and get All skills/traits
---@param character IsoGameCharacter
---@return CharacterObj getPerkDetails() -- table PerkFactory.Perk perk, int level, float xp
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function getCharacterAllSkills(character)
    if not character then
        return nil
    end

    local CharacterObj01 = CharacterObj:new(nil)

    for i = 0, Perks.getMaxIndex() - 1 do
        local perk = getPerk_PZ(Perks.fromIndex(i))
        local level = getPerkLevel_PZ(character, perk)
        local xp = getXpPerk_PZ(character, perk)

        -- Add to objects
        CharacterObj01:addPerkDetails(perk, level, xp)
    end

    CharacterObj01:setProfession( getCharacterProfession_PZ(character) )

    return CharacterObj01:getPerkDetails()
end

--- Get Perk
---@param perk PerkFactory
---@return PerkFactory.Perk perk
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
function getPerk_PZ(perk)
    return PerkFactory.getPerk(perk)
end

--- Get Perk from name
---@param perk string
---@return PerkFactory.Perk perk
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
function getPerkFromName_PZ(perk)
    return PerkFactory.getPerkFromName(perk)
end

---Add XP
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param xp float
---@param flag1 boolean default false
---@param flag2 boolean default false
---@param flag3 boolean default true
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
function addXP_PZ(character, perk, xp, flag1, flag2, flag3)
    if not character or not perk then
        return nil
    end

    flag1 = flag1 or false -- is the default
    flag2 = flag2 or false -- is the default
    flag3 = flag3 or true -- is the default

    character:getXp():AddXP(perk, xp, flag1, flag2, flag3);
end

---@param value double
---@return int
function trunkFloatTo2Decimal(value)
    return tonumber(string.format("%.2f", value)) + 0.0
end

--- Get Perk Level
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@return int
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
function getPerkLevel_PZ(character, perk)
    if not character then
        return nil
    end

    return character:getPerkLevel(perk)
end

--- Get all Traits
---@param character IsoGameCharacter
---@return TraitCollection
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - TraitCollection : zombie.characters.traits.TraitCollection
function getTraits_PZ(character)
    if not character then
        return nil
    end

    return character:getTraits()
end

--- Get Character Traits
---@param character IsoGameCharacter
---@return IsoGameCharacter.CharacterTraits
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - IsoGameCharacter.CharacterTraits : zombie.characters.IsoGameCharacter.CharacterTraits
function getCharacterTraits_PZ(character)
    if not character then
        return nil
    end

    return character:getCharacterTraits()
end


--- Get Charater profession
---@param character IsoGameCharacter
---@param profession String
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - SurvivorDesc : zombie.characters.SurvivorDesc
function setCharacterProfession_PZ(character, profession)
    if not character then
        return nil
    end

    character:getDescriptor():setProfession(profession)
end

--- Get Character profession
---@param character IsoGameCharacter
---@return String
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - SurvivorDesc : zombie.characters.SurvivorDesc
function getCharacterProfession_PZ(character)
    if not character then
        return nil
    end

    return character:getDescriptor():getProfession()
end

--- Get XP perk
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@return float xp
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
--- - IsoGameCharacter.XP : zombie.characters.IsoGameCharacter.XP
function getXpPerk_PZ(character, perk)
    return trunkFloatTo2Decimal( character:getXp():getXP(perk) ) -- Perks.Maintenance
end

EnumNumbers = {
    ZERO = 0,
    ONE = 1,
    TWO = 2,
    THREE = 3,
    FOUR = 4,
    FIVE = 5,
    SIX = 6,
    SEVEN = 7,
    EIGHT = 8,
    NINE = 9,
    TEN = 10,
}

--- Convert Level To Xp
---@param level int
---@param perk PerkFactory.Perk
---@return float Xp
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
function convertLevelToXp(perk, level)
    -- Perks.Sprinting:getXp1()
    local result = nil

    if not perk or not level then
        return nil
    end

    if level == EnumNumbers.ONE then
        result = getPerk_PZ(perk):getXp1()
    elseif level == EnumNumbers.TWO then
        result = getPerk_PZ(perk):getXp2()
    elseif level == EnumNumbers.THREE then
        result = getPerk_PZ(perk):getXp3()
    elseif level == EnumNumbers.FOUR then
        result = getPerk_PZ(perk):getXp4()
    elseif level == EnumNumbers.FIVE then
        result = getPerk_PZ(perk):getXp5()
    elseif level == EnumNumbers.SIX then
        result = getPerk_PZ(perk):getXp6()
    elseif level == EnumNumbers.SEVEN then
        result = getPerk_PZ(perk):getXp7()
    elseif level == EnumNumbers.EIGHT then
        result = getPerk_PZ(perk):getXp8()
    elseif level == EnumNumbers.NINE then
        result = getPerk_PZ(perk):getXp9()
    elseif level == EnumNumbers.TEN then
        result = getPerk_PZ(perk):getXp10()
    end

    return result
end

---Set Perk Level and level
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param xp float
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
--- - IsoGameCharacter.XP : zombie.characters.IsoGameCharacter.XP
function setPerkLevel(character, perk, xp)
    if not character or not perk then
        return nil
    end

    if xp == 0 then
        return
    end

    addXP_PZ(character, perk, xp,
            false, false, true )

end

---Set Perk Level and level
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
--- ISPlayerStatsUI.lua 635
--- - IsoGameCharacter : zombie.characters.IsoGameCharact
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
--- - IsoGameCharacter.XP : zombie.characters.IsoGameCharacter.XP
function removePerkLevel(character, perk)
    if not character or not perk then
        return nil
    end

    local currentLevelPerk = getPerkLevel_PZ(character, perk)

    for i = 0, currentLevelPerk  do
        character:LoseLevel(perk)
    end

    local xpPerk = getXpPerk_PZ(character, perk)
    xpPerk = -xpPerk

    if xpPerk == 0 then
        return
    end

    addXP_PZ(character, perk, xpPerk,
            false, false, true )

end

---Get Parent_PZ
---@param perk PerkFactory.Perk
---@return PerkFactory.Perk
--- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
function getParent_PZ(perk)
    return perk:getParent():getName()
end

--- --------------------------------------------------------------------------------------------------------------


---Set Zombies Killed
---@param character IsoGameCharacter
---@param killZombies int
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function setZombieKills_PZ(character, killZombies)
    character:setZombieKills(killZombies)
end

---Get Zombies Killed
---@param character IsoGameCharacter
---return int
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function getZombieKills_PZ(character)
    return character:getZombieKills()
end

---Set Life Time
---@param lifeTime double
--- - IsoPlayer : zombie.characters.IsoPlayer
function setHoursSurvived_PZ(lifeTime)
    IsoPlayer.getInstance():setHoursSurvived(lifeTime)
end

---Get Life Time
---@return double
--- - IsoPlayer : zombie.characters.IsoPlayer
function getHoursSurvived_PZ()
    return IsoPlayer.getInstance():getHoursSurvived()
end

---Set Weight
---@param value double
--- - IsoPlayer : zombie.characters.BodyDamage.Nutrition
function setWeight_PZ(value)
    IsoPlayer.getInstance():getNutrition():setWeight(value)
end

---Get Weight
---@return double Weight
--- - IsoPlayer : zombie.characters.BodyDamage.Nutrition
function getWeight_PZ()
    return IsoPlayer.getInstance():getNutrition():getWeight()
end

---Set Calories
---@param value float
--- - IsoPlayer : zombie.characters.BodyDamage.Nutrition
function setCalories_PZ(value)
    IsoPlayer.getInstance():getNutrition():setCalories(value)
end

---Get Calories
---@return float Calories
--- - IsoPlayer : zombie.characters.BodyDamage.Nutrition
function getCalories_PZ()
    return IsoPlayer.getInstance():getNutrition():getCalories()
end

---Insert Single Value Into Mod Data
---@param EnumModData
---@param value
function insertSingleValueIntoModData(modData, value)
    ModData.remove(modData)

    local lines = {}
    table.insert(lines, value)

    ModData.add(modData, lines)
end

---Read Single Value Into Mod Data
---@param EnumModData
function readSingleValueIntoModData(modData)
    local lines = {}

    lines = ModData.get(modData )
    return lines[1]
end

--- --------------------------------------------------------------------------------------------------------------