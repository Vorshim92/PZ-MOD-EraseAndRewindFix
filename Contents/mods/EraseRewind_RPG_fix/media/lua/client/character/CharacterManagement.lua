---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 30/09/23 19:22
---

--- LAST UPDATE 05-09-2023

-- PATCH SKILL LIMITER
local isSkillLimiter = false
local characterSkillLimit = {}
if getActivatedMods():contains("SkillLimiter_fix") then
    isSkillLimiter = true
    characterSkillLimit = require("patch/skillLimiter/CharacterSkillLimit")
end
local isEraseBKP = false
local playerBKP = {}
if getActivatedMods():contains("Erase&Rewind_BKP") then
    playerBKP = require("CharacterPlayer")
    isEraseBKP = true
end


---@class CharacterManagement

local CharacterManagement = {}

local characterBoost = require("character/CharacterBoost")
local characterKilledZombies = require("character/CharacterKilledZombies")
local characterLifeTime = require("character/CharacterLifeTime")
local characterMultiplier = require("character/CharacterMultiplier")
local characterNutrition = require("character/CharacterNutrition")
local characterPerkDetails = require("character/CharacterPerkDetails")
local characterRecipe = require("character/CharacterRecipe")
local characterTrait = require("character/CharacterTrait")
local errHandler = require("lib/ErrHandler")
local pageBook = require("book/PageBook")
local modDataManager = require("lib/ModDataManager")
local patchSurvivalRewards = require("patch/survivalRewards/PatchSurvivalRewards")

--- **Remove all Mod Data**
---@return void
function CharacterManagement.removeAllModData(modData_table)
    print("modData_table: ", modData_table)
    --- **Remove ModData**
    -- Rimuovi tutti i dati associati alle chiavi specifiche del libro
    for _, key in pairs(modData_table) do
        modDataManager.remove(key)
    end
    if modData_table == pageBook.Character.TimedBook then
        modDataManager.remove(pageBook.Character.TIMED_BOOK)
    elseif modData_table == pageBook.Character.ReadOnceBook then
        modDataManager.remove(pageBook.Character.READ_ONCE_BOOK)
    end

    ------- PATCH ------------
    --- survivalRewards 2797671069
    --- https://steamcommunity.com/sharedfiles/filedetails/?id=2797671069&searchtext=2797671069
    if patchSurvivalRewards.isModActive() then
        patchSurvivalRewards.removeMil_kill_Reached(modData_table)
    end
    --------------------------
end

--- **Read Book**
---@param character IsoGameCharacter
---@return void
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function CharacterManagement.readBook(character, modData_table)
    --- **Check if character is null**
    if not character then
        errHandler.errMsg("CharacterManagement.readBook(character)",
                errHandler.err.IS_NULL_CHARACTERS)
        return nil
    end

    --- **Check if modData_table is exists**
    if not modData_table then
        errHandler.errMsg("CharacterManagement.readBook(character)",
                " modData_table is not exists")
        return nil
    end

    characterTrait.readBook(character, modData_table)
    -- PATCH SKILL LIMITER
    if isSkillLimiter then
        characterSkillLimit.readBook(modData_table)
    end
    characterPerkDetails.readBook(character, modData_table)
    characterKilledZombies.readBook(character, modData_table)
    characterLifeTime.readBook(modData_table)
    characterNutrition.readBook(modData_table)
    characterRecipe.readBook(character, modData_table)
    characterBoost.readBook(character, modData_table)
    characterMultiplier.readBook(character, modData_table)

    ------- PATCH ------------
    --- survivalRewards 2797671069
    --- https://steamcommunity.com/sharedfiles/filedetails/?id=2797671069&searchtext=2797671069

    if patchSurvivalRewards.isModActive() then
        patchSurvivalRewards.createMil_kill_Reached(character, modData_table)
    end
    --------------------------

    CharacterManagement.removeAllModData(modData_table)
end

local function prepareBkpServer(modData_table)
    local backup = {}
    for _, key in pairs(modData_table) do
        if modDataManager.isExists(key) then
            local temp = modDataManager.read(key)
            backup[key] = temp  -- Associa il nome della tabella ai suoi dati
        end
    end
    return backup
end

--- **Write Book**
---@param character IsoGameCharacter
---@return void
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function CharacterManagement.writeBook(character, modData_table)
    --- **Check if character is null**
    if not character then
        errHandler.errMsg("CharacterManagement.writeBook(character)",
                errHandler.err.IS_NULL_CHARACTERS)
        return nil
    end

    --- **Check if modData_name is exists**
    if not modData_table then
        errHandler.errMsg("CharacterManagement.writeBook(character)",
                " modData_table is not exists")
        return nil
    end
    characterPerkDetails.writeBook(character, modData_table)
    characterKilledZombies.writeBook(character, modData_table)
    characterLifeTime.writeBook(modData_table)
    characterNutrition.writeBook(modData_table)
    characterTrait.writeBook(character, modData_table)

    -- PATCH SKILL LIMITER
    if isSkillLimiter then
        characterSkillLimit.writeBook(modData_table)
    end
    characterRecipe.writeBook(character, modData_table)
    characterBoost.writeBook(character, modData_table)
    characterMultiplier.writeBook(character, modData_table)

    ------- PATCH ------------
    --- survivalRewards 2797671069
    --- https://steamcommunity.com/sharedfiles/filedetails/?id=2797671069&searchtext=2797671069

    if patchSurvivalRewards.isModActive() then
        patchSurvivalRewards.writeMil_kill_ReachedToHd(character, modData_table)
    end

    ---------------------------
    ---SEND BACKUP TO SERVER---
    
    -- local backup = prepareBkpServer(modData_table)
    local backup = false
    if backup then
        print("[Commands.saveBackup] Preparazione backup da inviare al server")
        local name = ""
        if modData_table == pageBook.Character.TimedBook then
            name = "Timed"
        elseif modData_table == pageBook.Character.ReadOnceBook then
            name = "ReadOnce"
        elseif isEraseBKP then
            if modData_table == playerBKP.Character.BKP_1 then
                name = "BKP1"
            elseif modData_table == playerBKP.Character.BKP_2 then
                name = "BKP2"
            end
        end
        local args = {
            name = name,
            data = backup
        }
        print("[Commands.saveBackup] Inizio del salvataggio dei dati per PlayerBKP_" .. character:getUsername() .. "_" .. name .. ".txt")
        sendClientCommand(character, "Vorshim", "saveBackup", args)
    else 
        print("[Commands.saveBackup] Nessun backup da inviare al server")
    end


end




return CharacterManagement