require "TimedActions/ISBaseTimedAction"

WriteBookAction = ISBaseTimedAction:derive("WriteBookAction")

function WriteBookAction:isValid()
    return true
end

function WriteBookAction:waitToStart()
    return self.character:shouldBeTurning()
end

function WriteBookAction:update()
end

function WriteBookAction:start()
    self.character:playSound("OpenBook")
end

function WriteBookAction:stop()
    ISBaseTimedAction.stop(self)
end

local HALO_DURATION = 300

function WriteBookAction:perform()
    self.character:playSound("CloseBook")
    local ci = Core.getInstance():getGoodHighlitedColor()
    self.character:setHaloNote(getText("ContextMenu_WrittenBook"),
        math.floor(ci:getR() * 255), math.floor(ci:getG() * 255), math.floor(ci:getB() * 255), HALO_DURATION)
    ISBaseTimedAction.perform(self)
end

--- Convert game-hours to a readable "Day X, HH:MM" string
local function hoursToDisplay(gameHours)
    local totalMinutes = math.floor(gameHours * 60)
    local days = math.floor(gameHours / 24)
    local hours = math.floor(gameHours % 24)
    local minutes = totalMinutes % 60
    return string.format("Day %d, %02d:%02d", days, hours, minutes)
end

function WriteBookAction:complete()
    if not isServer() then return true end

    local backupIO = require("DiarynoBackupIO")
    local CharacterSerializer = require("CharacterSerializer")

    local character = self.character
    local username = character:getUsername()
    local bookType = self.bookType
    local bookTableName = self.bookTableName
    local nowHours = getGameTime():getWorldAgeHours()

    -- 1. Read existing backup file
    local backupData = backupIO.readBackup(username)
    local existing = backupData[bookTableName]

    -- 2. Validate write permission
    if bookType == "READ_ONCE_BOOK" and existing then
        sendServerCommand(character, "Diaryno", "bookActionFailed", {
            key = "ContextMenu_AlreadyTranscribed",
            extra = ": " .. hoursToDisplay(existing.timestamp or 0)
        })
        return false
    end

    if bookType == "TIMED_BOOK" and existing and existing.timestamp then
        if nowHours < existing.timestamp then
            sendServerCommand(character, "Diaryno", "bookActionFailed", {
                key = "ContextMenu_ToEarly",
                extra = ": " .. hoursToDisplay(existing.timestamp)
            })
            return false
        end
    end

    -- 3. Collect character data + timestamp
    local characterData = CharacterSerializer.collect(character)

    if bookType == "TIMED_BOOK" then
        characterData.timestamp = nowHours + (SandboxVars.Diaryno.SetDays * 24)
    else
        characterData.timestamp = nowHours
    end

    -- 4. Save under single key
    backupData[bookTableName] = characterData

    -- 5. Write JSON
    backupIO.writeBackup(username, backupData)

    -- 6. Rename book item + sync to client
    local item = self.item
    if item then
        local extra = ""
        if bookType == "TIMED_BOOK" then
            extra = " - " .. hoursToDisplay(characterData.timestamp)
        elseif bookType == "READ_ONCE_BOOK" then
            extra = " - " .. hoursToDisplay(characterData.timestamp)
        end
        item:setName(bookTableName .. " - " .. character:getFullName() .. extra)
        item:setCustomName(true)
        syncItemFields(character, item)
    end

    print("[WriteBookAction:complete()] Saved backup for " .. username .. " / " .. bookTableName)
    return true
end

function WriteBookAction:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end
    return 50
end

function WriteBookAction:new(character, item, bookType)
    local o = ISBaseTimedAction.new(self, character)
    o.item = item -- auto-resolved by B42 engine on server via NetTimedAction
    o.bookType = bookType or ""
    o.bookTableName = ""
    if bookType == "READ_ONCE_BOOK" then
        o.bookTableName = "ReadOnceBook"
    elseif bookType == "TIMED_BOOK" then
        o.bookTableName = "TimedBook"
    end
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = o:getDuration()
    return o
end
