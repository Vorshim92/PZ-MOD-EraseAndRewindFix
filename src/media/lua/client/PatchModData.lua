---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 27/06/23 10:28
---

local modDataManager = require("lib/ModDataManager")

local kilMilReached = "kilMilReachedX"
local milReached = "milReachedX"

---Read kilMilReached From Hd
local function readKilMilReachedFromHd()
    return modDataManager.read(kilMilReached)
end

---Read MilReached From Hd
local function readMilReachedFromHd()
    return modDataManager.read(milReached)
end

---Write kilMilReached From Hd
---@param character IsoGameCharacter
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
local function writeKilMilReachedtFromHd(character)
    modDataManager.save(kilMilReached, character:getModData().milReached )
end

---Write milReached From Hd
---@param character IsoGameCharacter
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
local function writeMilReachedFromHd(character)
    modDataManager.save(milReached, character:getModData().kilMilReached )
end

---Create Mil_kill_Reached
------@param character IsoGameCharacter
----- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function createMil_kill_Reached(character)
    if not modDataManager.isExists(kilMilReached) then
        return nil
    end

    local kilMilReached = {}
    kilMilReached = readKilMilReachedFromHd()

    for i, v in pairs(kilMilReached) do
        character:getModData().milReached = toInt(v)
    end

    if not modDataManager.isExists(milReached) then
        return nil
    end

    local milReached = {}
    milReached = readMilReachedFromHd()

    for i, v in pairs(milReached) do
        character:getModData().kilMilReached = toInt(v)
    end
end

---Wwrite Mil_kill_Reached
---@param character IsoGameCharacter
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function writeMil_kill_Reached(character)
    removeMil_kill_Reached()

    writeKilMilReachedtFromHd(character)
    writeMilReachedFromHd(character)
end

---Remove Mil_kill_Reached moddata
function removeMil_kill_Reached()
    modDataManager.remove(kilMilReached)
    modDataManager.remove(milReached)
end