---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 12/02/23 10:20
--- V002

---@class ProjectZomboidLibs

require("media.lua.shared.objects.CharacterObj")

local characterTraitsTable_ = { perk, level }
local professionsTable_ = { perk, level }

---Add character Trait Table
---@param perk PerkFactory.Perk
---@param level int
local function characterTraitTable(perk, level)
    table.insert(characterTraitsTable_,{
        perk = perk,
        level = level
    })
end

---Add professions Table
---@param perk PerkFactory.Perk
---@param level int
local function professionsTable(perk, level)
    table.insert(professionsTable_,{
        perk = perk,
        level = level
    })
end

---Get Character Traits
---@return table perk, level
function getCharacterTraits(character)
    characterTraitsTable_ = { perk, level }

    local traits_PZ = getTraits_PZ(character)

    for i = 0, traits_PZ:size() - 1 do
        local traitMap = TraitFactory.getTrait(traits_PZ:get(i) ):getXPBoostMap()
        local traitKahluaTable = transformIntoKahluaTable(traitMap)

        for perk, level in pairs(traitKahluaTable) do
            characterTraitTable(perk, level)
        end
    end

    return characterTraitsTable_
end

---Get Character Profession
---@return table perk, level
function getCharacterProfession(character)
    professionsTable_ = { perk, level }

    local characterProfession_PZ = getCharacterProfession_PZ(character)
    local professionMap = ProfessionFactory.getProfession(characterProfession_PZ):getXPBoostMap()
    local professionKahluaTable = transformIntoKahluaTable(professionMap)

    for perk, level in pairs(professionKahluaTable) do
        professionsTable(perk, level)
    end

    return professionsTable_
end

--- Get Perk
---@param perk PerkFactory
---@return PerkFactory.Perk perk
--- - zombie.characters.skills.PerkFactory
function getPerk_PZ(perk)
    return PerkFactory.getPerk(perk)
end

---Add XP
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param xp float
---@param flag1 boolean default false
---@param flag2 boolean default false
---@param flag3 boolean default true
function addXP_PZ(character, perk, xp, flag1, flag2, flag3 )
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

---Get character and get current skill/trait
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@return PerkDetailsObj getPerkDetailsObj()
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
---@return CharacterObj getPerkDetails() -- table perk, level, xp
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

--- Get Perk Level
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@return int
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
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
function getCharacterTraits_PZ(character)
    if not character then
        return nil
    end

    return character:getCharacterTraits()
end

--- Get Charater profession
---@param character IsoGameCharacter
---@return String
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
--- - IsoGameCharacter.XP : zombie.characters.IsoGameCharacter.XP
function getXpPerk_PZ(character, perk)
    return trunkFloatTo2Decimal( character:getXp():getXP(perk) ) -- Perks.Maintenance
end

ENUM = {
    Zero = 0,
    One = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
    Six = 6,
    Seven = 7,
    Eight = 8,
    Nine = 9,
    Ten = 10,
}

--- Convert Level To Xp
---@param level int
---@param perk PerkFactory.Perk
---@return float Xp
function convertLevelToXp(perk, level)
    -- Perks.Sprinting:getXp1()
    if not perk or not level then
        return nil
    end

    if level == ENUM.One then
        return getPerk_PZ(perk):getXp1()
    elseif level == ENUM.Two then
        return getPerk_PZ(perk):getXp2()
    elseif level == ENUM.Three then
        return getPerk_PZ(perk):getXp3()
    elseif level == ENUM.Four then
        return getPerk_PZ(perk):getXp4()
    elseif level == ENUM.Five then
        return getPerk_PZ(perk):getXp5()
    elseif level == ENUM.Six then
        return getPerk_PZ(perk):getXp6()
    elseif level == ENUM.Seven then
        return getPerk_PZ(perk):getXp7()
    elseif level == ENUM.Eight then
        return getPerk_PZ(perk):getXp8()
    elseif level == ENUM.Nine then
        return getPerk_PZ(perk):getXp9()
    elseif level == ENUM.Ten then
        return getPerk_PZ(perk):getXp10()
    end

    return nil
end

---Set Perk Level and level
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param levelPerk int
--- - IsoGameCharacter.XP : zombie.characters.IsoGameCharacter.XP
function setPerkLevel(character, perk, levelPerk)
    if not character or not perk or not levelPerk then
        return nil
    end

    local convertLevelToXp_ = 0.0

    for level_ = 1, levelPerk do
        convertLevelToXp_ = convertLevelToXp_ + convertLevelToXp(perk, level_)
    end

    local totalXp = ( convertLevelToXp_ -
            getXpPerk_PZ( character, perk ) ) -- * 2

    if totalXp == 0 then
        return
    end

    addXP_PZ(character, perk, convertLevelToXp_,
            false, false, true )
end


--[[
    Utilizza removePerkLevel(character, Perks.Maintenance, _)
    funziona ma può dare valori negativi se si
    selezione il numero di livelli da togliere. Sistemare
]]
---Set Perk Level and level
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param levelPerk int
--- ISPlayerStatsUI.lua 635
--- - IsoGameCharacter.XP : zombie.characters.IsoGameCharacter.XP
function removePerkLevel(character, perk, levelPerk)
    if not character or not perk then
        return nil
    end

    local currentLevelPerk = getPerkLevel_PZ(character, perk)

    if levelPerk == true then
        if levelPerk > currentLevelPerk then
            levelPerk = currentLevelPerk
        end
    end

    levelPerk = levelPerk or currentLevelPerk

    for i = 0, levelPerk  do
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

-- ----------------------

-- TODO setCharacterProfession_PZ
--- Get Charater profession
---@param character IsoGameCharacter
---@param profession String
--- - SurvivorDesc : zombie.characters.SurvivorDesc
function setCharacterProfession_PZ(character, profession)
    if not character then
        return nil
    end

    --character:getDescriptor().setProfession(profession)
end

-- TODO setProfessionSkills_PZ
function setProfessionSkills_PZ()

end

-- TODO setXpLevelToZero
---Set Xp Level To Zero
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
local function setXpLevelToZero(character, perk)
    --if not character or not perk then
    --    return nil
    --end
    --
    --local totalXp = ( getXpPerk_PZ( character, perk ) ) * ENUM.Two
    --
    --addXP_PZ(character, perk, totalXp)
end

-- TODO getParent_PZ
---@param character IsoGameCharacter
function getParent_PZ(character)

end

-- char:getDescriptor():getForename();