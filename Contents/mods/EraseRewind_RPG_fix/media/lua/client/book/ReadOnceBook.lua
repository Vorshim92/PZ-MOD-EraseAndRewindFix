---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 07/10/23 12:25
---

---@class ReadOnceBook

local ReadOnceBook = {}

local characterManagement = require("character/CharacterManagement")
local errHandler = require("lib/ErrHandler")
local modDataManager = require("lib/ModDataManager")
local pageBook = require("book/PageBook")
local activityCalendar = require("lib/ActivityCalendar")
--- **Read Book**
---@param character IsoGameCharacter
---@return void
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function ReadOnceBook.readBook(character)
    --- **Check if character is null**
    if not character then
        errHandler.errMsg("OneTimeBookRead.readBook(character)",
                errHandler.err.IS_NULL_CHARACTERS)
        return nil
    end

    characterManagement.readBook(character, pageBook.ReadOnceBook)
end

--- **Write Book**
---@param character IsoGameCharacter
---@return boolean
--- - IsoGameCharacter : zombie.characters.IsoGameCharacter
function ReadOnceBook.writeBook(character)
    --- **Check if character is null**
    if not character then
        errHandler.errMsg("OneTimeBookRead.writeBook(character)",
                errHandler.err.IS_NULL_CHARACTERS)
        return nil
    end
    local flag = false
    local temp = ModData.getOrCreate("ERASE_REWIND")
    if temp.READ_ONCE_BOOK == nil then
        flag = true
    end

    if flag then 
        local time = activityCalendar.getStarTime()
        time = activityCalendar.fromSecondToDate(time)
        local lines = {}
        table.insert(lines, time)
        temp.READ_ONCE_BOOK = lines
        modDataManager.save("ERASE_REWIND", temp)
        characterManagement.writeBook(character, pageBook.ReadOnceBook)
    end

return flag
end

return ReadOnceBook