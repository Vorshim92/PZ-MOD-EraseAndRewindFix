require "TimedActions/ISBaseTimedAction"

ReadBookAction = ISBaseTimedAction:derive("ReadBookAction")

function ReadBookAction:isValid()
    return true
end

function ReadBookAction:waitToStart()
    return self.character:shouldBeTurning()
end

function ReadBookAction:update()
end

function ReadBookAction:start()
    self.character:playSound("OpenBook")
end

function ReadBookAction:stop()
    ISBaseTimedAction.stop(self)
end

local HALO_DURATION = 300

function ReadBookAction:perform()
    self.character:playSound("CloseBook")
    local ci = Core.getInstance():getGoodHighlitedColor()
    self.character:setHaloNote(getText("UI_ReadBook_Eureka"),
        math.floor(ci:getR() * 255), math.floor(ci:getG() * 255), math.floor(ci:getB() * 255), HALO_DURATION)
    ISBaseTimedAction.perform(self)
end

function ReadBookAction:complete()
    if not isServer() then return true end

    local backupIO = require("DiarynoBackupIO")
    local CharacterSerializer = require("CharacterSerializer")

    local character = self.character
    local username = character:getUsername()
    local bookTableName = self.bookTableName

    -- 1. Read existing backup file
    local backupData = backupIO.readBackup(username)

    -- 2. Validate: backup data must exist
    if not backupData[bookTableName] then
        sendServerCommand(character, "Diaryno", "bookActionFailed", {
            key = "UI_TranscribeBook_NotTranscribed"
        })
        return false
    end

    -- 3. Apply character data (timestamp is ignored by apply, only PG fields are used)
    CharacterSerializer.apply(character, backupData[bookTableName])

    -- 4. Remove consumed book data
    backupData[bookTableName] = nil

    -- 5. Write updated backup file
    backupIO.writeBackup(username, backupData)

    -- 6. Remove book item from inventory (self.item auto-resolved by engine)
    local item = self.item
    if item then
        local container = item:getContainer() or character:getInventory()
        container:Remove(item)
        sendRemoveItemFromContainer(container, item)
    end

    print("[ReadBookAction:complete()] Restored backup for " .. username .. " / " .. bookTableName)
    return true
end

function ReadBookAction:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end
    return 100
end

function ReadBookAction:new(character, item, bookType)
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
