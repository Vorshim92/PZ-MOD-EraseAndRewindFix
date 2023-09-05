---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 15/04/23 18:54
---
local characterPz = require("lib/CharacterPZ")
local modDataManager = require("lib/ModDataManager")
local characterLib = require("CharacterLib")
require("lib/CharacterBaseObj")

local lines_ = { perk, boostLevel }

local function lines(perk, boostLevel)
    table.insert(lines_, {
        perk = perk,
        boostLevel = boostLevel
    })
end

--- **Read Boost From Hd**
---@return table
local function readBoostFromHd()
    return modDataManager.read(EnumModData.CHARACTER_BOOST)
end

--- **Delete Boost**
---@param character IsoGameCharacter
--- - zombie.characters.IsoGameCharacter
local function deleteBoost(character)
    local CharacterAllPerksObJ = CharacterBaseObj:new()
    CharacterAllPerksObJ = characterLib.getAllPerks(character)

    for _, v in pairs(CharacterAllPerksObJ:getPerkDetails()) do
        characterPz.removePerkBoost(character, v:getPerk())
    end

end

--- **Create Boost**
---@param character IsoGameCharacter
--- - zombie.characters.IsoGameCharacter
function createBoost(character)
    if not modDataManager.isExists(EnumModData.CHARACTER_BOOST) then
        return nil
    end

    local boost = {}
    boost = readBoostFromHd()

    if not boost then
        return nil
    end

    deleteBoost(character)

    for _, v in pairs(boost) do
        characterPz.setPerkBoost_PZ(character, v.perk, v.boostLevel)
    end
end

--- **Write Trait To Hd**
---@param character IsoGameCharacter
--- - zombie.characters.IsoGameCharacter
function writeBoostToHd(character)
    modDataManager.remove(EnumModData.CHARACTER_BOOST)

    local CharacterPerksBoostObj = CharacterBaseObj:new()
    CharacterPerksBoostObj = characterLib.getPerksBoost(character)

    for _, v in pairs(CharacterPerksBoostObj:getPerkDetails()) do
        lines(v:getPerk(), v:getBoostLevel())
    end

    modDataManager.save(EnumModData.CHARACTER_BOOST, lines_)

    lines_ = {}
end