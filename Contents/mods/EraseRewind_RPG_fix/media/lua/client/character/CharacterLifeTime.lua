---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 01/04/23 21:20
---

---@class CharacterLifeTime

local CharacterLifeTime = {}

local errHandler = require("lib/ErrHandler")
local isoPlayerPZ = require("lib/IsoPlayerPZ")
-- local pageBook = require("book/PageBook")
local modDataManager = require("lib/ModDataManager")

--- **Read Life Time From Hd**
---@return table double ( timeLife )
local function readLifeTimeFromHd(modData_name)
    return modDataManager.read(modData_name.LIFE_TIME)
end

--- **Create Life Time**
function CharacterLifeTime.readBook(modData_name)
    if not modDataManager.isExists(modData_name.LIFE_TIME) then
        errHandler.errMsg("CharacterLifeTime.readBook()",
                " mod-data " .. modData_name.LIFE_TIME .. " not exists")
        return nil
    end

    ---@type table
    ---@return table - double ( timeLife )
    local lifeTime = readLifeTimeFromHd(modData_name)

     isoPlayerPZ.setHoursSurvived_PZ(lifeTime[1])
end

--- **Write Life Time To Hd**
function CharacterLifeTime.writeBook(modData_name)
    
    local temp = modDataManager.read(modData_name)

    if temp then
            ---@type table - double ( timeLife )
        local hoursSurvived = isoPlayerPZ.getHoursSurvived_PZ()
        if hoursSurvived then
            temp["LIFE_TIME"] = hoursSurvived
            modDataManager.save(modData_name, temp)
        end
    end
end

return CharacterLifeTime