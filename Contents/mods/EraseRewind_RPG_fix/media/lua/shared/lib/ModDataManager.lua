---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 10/05/23 15:11
---

---@class ModDataManager

local dataValidator = require("lib/DataValidator")
local debugDiagnostics = require("lib/DebugDiagnostics")
local errHandler = require("lib/ErrHandler")

local ModDataManager = {}

--- **Save ModData to Harddisk**
---@param nameFile string
---@param values table
---@return void
--- - ModData : zombie.world.moddata.ModData
function ModDataManager.save(nameFile, values)
    if not nameFile then
        errHandler.errMsg("ModDataManager.save(nameFile, values)",
                errHandler.err.IS_NULL)
        return nil
    end

    if values then
        ModData.add(nameFile, values)
    end
end

--- **Read ModData**
---@param nameFile string
---@return table
--- - ModData : zombie.world.moddata.ModData
function ModDataManager.read(nameFile)
    if not nameFile then
        errHandler.errMsg("ModDataManager.read(nameFile)", "nameFile " .. errHandler.err.IS_NULL)
        return nil
    end

    -- Acquisisce direttamente la tabella con ModData.get
    local modData = ModData.getOrCreate(nameFile)

    if not modData then
        errHandler.errMsg("ModDataManager.read(nameFile)", "modData " .. errHandler.err.IS_NULL)
        return nil
    end

    return modData  -- Restituisce direttamente la tabella
end

--- **Is modData Exists**
---@param nameFile string
---@return boolean
--- - ModData : zombie.world.moddata.ModData
function ModDataManager.isExists(nameFile)
    if not nameFile then
        errHandler.errMsg("ModDataManager.isExists(nameFile)",
                " nameFile " .. errHandler.err.IS_NULL)
        return nil
    end

    if ModData.exists(nameFile) then
        return true
    end

    return false
end

--- **Remove modData**
---@param nameFile string
---@return void
--- - ModData : zombie.world.moddata.ModData
function ModDataManager.remove(nameFile)
    if not nameFile then
        errHandler.errMsg("ModDataManager.remove(nameFile)",
                " nameFile " .. errHandler.err.IS_NULL)
        return nil
    end

    ModData.remove(nameFile)
end

--- **Display all modData**
---@return void
function ModDataManager.displayAllTable()
    ---@type List
    local tableNames = ModData.getTableNames()

    ---@type table
    local moddatas =
    dataValidator.transformArrayListToTable(tableNames)

    print("------------------------displayModDatas-----------------------")
    debugDiagnostics.printLine()
    for _, v in pairs(moddatas) do
        print("Name table - " .. v)

        ---@type table
        local reads = ModDataManager.read(v)
        for _, v2 in pairs(reads) do
            -- TODO : CharacterBoost mostra solo tabelle e non i valori
            print("Value of Moddata - " .. tostring(v2))
        end

        debugDiagnostics.printLine()
    end
    debugDiagnostics.printLine()
end

return ModDataManager