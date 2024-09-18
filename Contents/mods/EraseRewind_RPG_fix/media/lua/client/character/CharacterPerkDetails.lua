---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 15/04/23 13:52
---

---@class CharacterPerkDetails

local CharacterPerkDetails = {}

require("lib/CharacterBaseObj")

local characterLib = require("CharacterLib")
local characterPz = require("lib/CharacterPZ")
local errHandler = require("lib/ErrHandler")
-- local pageBook = require("book/PageBook")
local modDataManager = require("lib/ModDataManager")
local perkFactoryPZ = require("lib/PerkFactoryPZ")


--- **Read Character Perk Details From Hd**
---@return CharacterBaseObj PerkFactory.Perk perk, int level, float xp, boolean flag
local function readCharacterPerkDetailsFromHd(modData_name)

    ---@type table
    ---@return table perk, level ( int ), xp ( float )
    local characterPerkDetails =
        modDataManager.read(modData_name.PERK_DETAILS)

    -- @type CharacterBaseObj
    local CharacterObj01 = CharacterBaseObj:new()

    ---@type table
    local lines_ = {}

    for _, v in pairs(characterPerkDetails) do
        -- Format value1-value2-value3
        for s in v:gmatch("[^\r-]+") do
            table.insert(lines_, s)
        end

        -- @param perk PerkFactory.Perk
        -- @param level int
        -- @param xp float
        CharacterObj01:addPerkDetails(perkFactoryPZ.getPerkByName_PZ(lines_[1]),
                tonumber(lines_[2]),
                tonumber(lines_[3]) + 0.0)

        lines_ = {}
    end

    return CharacterObj01
end

--- **Delete  all skills Character**
---@param character IsoGameCharacter
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
local function deleteCharacter(character)

    -- @type CharacterBaseObj
    local characterAllSkills = characterLib.getAllPerks(character)

    -- @param character IsoGameCharacter
    -- @param perk PerkFactory.Perk
    --- - PerkFactory.Perk : zombie.characters.skills.PerkFactory
    for _, v in pairs(characterAllSkills:getPerkDetails()) do
        characterPz.setDesiredPerkLevel(character, v:getPerk(), 0)
    end

    characterPz.removeProfession(character)
end

--- **Copy Character Skill**
---@param character IsoGameCharacter
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function CharacterPerkDetails.readBook(character, modData_name)
    --- **check if mod-data perkDetails and profession are exits**
    if not character then
        errHandler.errMsg("CharacterPerkDetails.readBook(character)",
                errHandler.err.IS_NULL_CHARACTERS)
        return nil
        --- **check if mod-data profession are exits**
    elseif not modDataManager.isExists(modData_name.PROFESSION) then
        errHandler.errMsg("CharacterPerkDetails.readBook(character)",
                " mod-data " .. modData_name.PROFESSION .. " is not exists")
        return nil
        --- **check if mod-data perkDetails are exits**
    elseif not modDataManager.isExists(modData_name.PERK_DETAILS) then
        errHandler.errMsg("CharacterPerkDetails.readBook(character)",
                " mod-data " .. modData_name.PERK_DETAILS .. " is not exists")
        return nil
    end

    -- @type CharacterBaseObj
    ---@return CharacterBaseObj PerkFactory.Perk perk, int level, float xp, boolean flag
    local characterSkills = readCharacterPerkDetailsFromHd(modData_name)

    deleteCharacter(character)

    -- @param character IsoGameCharacter
    -- @param perk PerkFactory.Perk
    -- @param xp float
    for _, v in pairs(characterSkills:getPerkDetails()) do
        
        characterPz.setDesiredPerkLevel(character, v:getPerk(), v:getCurrentLevel())

        local totalXp = v:getXp()
        print("XP TOTALI: " .. totalXp) --25
        local prevLvlTotalXp = ISSkillProgressBar.getPreviousXpLvl(v:getPerk(), v:getCurrentLevel()) --75
        local diffXp = totalXp - prevLvlTotalXp -- (-50)
        --se negativa la differenza o uguale a 0 lasciamo così com'è.
        --già setDesiredPerkLevel ci pensa sincronizzare gli XP al lvl impostato
        if diffXp > 0 then
            --se ci sono degli xp extra farmati del lvl corrente li aggiungiamo
            diffXp = round(diffXp,2)
            characterPz.addXP_PZ(character, v:getPerk(), diffXp, false, false, false)    
        end
    end

    ---@type table
    ---@return table string ( profession )
    local profession = modDataManager.read(modData_name.PROFESSION)

    characterPz.setProfession_PZ(character,
            profession[1])
end

--- **Write Character Perk Details To Hd**
---@param character IsoGameCharacter
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function CharacterPerkDetails.writeBook(character, modData_name)
    --- **Remove perkDetails and profession from mod-data**
    modDataManager.remove(modData_name.PERK_DETAILS)
    modDataManager.remove(modData_name.PROFESSION)

    ---@type table
    local lines = {}

    -- @type CharacterBaseObj
    local characterAllSkills = characterLib.getAllPerks(character)

    -- Format value1-value2-value3
    -- @param perk PerkFactory.Perk
    -- @param level int
    -- @param xp float
    for _, v in pairs(characterAllSkills:getPerkDetails()) do
        local value = ( v.perk:getName() .. "-" ..
                tostring(v:getCurrentLevel())  .. "-" ..
                tostring(v:getXp()) )

        table.insert(lines, value)
    end

    --- **Save Character Perk Details to mod-data**
    modDataManager.save(modData_name.PERK_DETAILS, lines)
    -- save backup on server
    -- local args = {
    --     name = modData_name.PERK_DETAILS,
    --     data = lines
    -- }
    -- sendClientCommand(character, "Vorshim", "saveBackup", args)
    -- -- end backup on server
    lines = {}
    -- args = {}
    table.insert(lines, characterAllSkills:getProfession())

    --- **Save Character Profession to mod-data**
    modDataManager.save(modData_name.PROFESSION,
            lines )

    -- save backup on server
    -- args = {
    --     name = modData_name.PROFESSION,
    --     data = lines
    -- }
    -- sendClientCommand(character, "Vorshim", "saveBackup", args)
    -- -- end backup on server

    lines = {}
end

return CharacterPerkDetails