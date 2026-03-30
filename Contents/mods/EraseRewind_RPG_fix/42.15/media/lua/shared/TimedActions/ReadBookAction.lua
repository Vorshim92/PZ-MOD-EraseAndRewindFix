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

function ReadBookAction:perform()
    self.character:playSound("CloseBook")
    self.character:Say("EUREKA!!!")
    ISBaseTimedAction.perform(self)
end

function ReadBookAction:complete()
    if not isServer() then return true end

    local json = require("dkjson")
    local CharacterSerializer = require("CharacterSerializer")

    local character = self.character
    local username = character:getUsername()
    local filepath = "Backup/Diaryno/PlayerBKP_" .. username .. ".json"
    local bookType = self.bookType
    local bookTableName = self.bookTableName

    -- 1. Read existing backup file
    local backupData = {}
    local filereader = getFileReader(filepath, false)
    if filereader then
        local lines = {}
        local line = filereader:readLine()
        while line ~= nil do
            table.insert(lines, line)
            line = filereader:readLine()
        end
        filereader:close()
        local content = table.concat(lines, "\n")
        if content ~= "" then
            local decoded, _, err = json.decode(content, 1, nil)
            if not err and decoded then
                backupData = decoded
            end
        end
    end

    -- 2. Validate: backup data must exist for this book type
    if not backupData[bookType] then
        sendServerCommand(character, "Diaryno", "bookActionFailed", {
            message = getText("UI_TranscribeBook_NotTranscribed")
        })
        return false
    end

    if not backupData[bookTableName] then
        sendServerCommand(character, "Diaryno", "bookActionFailed", {
            message = getText("UI_TranscribeBook_NotTranscribed")
        })
        return false
    end

    -- 3. Apply character data
    local characterData = backupData[bookTableName]
    CharacterSerializer.apply(character, characterData)

    -- 4. Remove consumed data from backup
    backupData[bookTableName] = nil
    backupData[bookType] = nil

    -- 5. Write updated backup file
    local serialized = json.encode(backupData, { indent = true })
    local filewriter = getFileWriter(filepath, false, false)
    if filewriter then
        filewriter:write(serialized)
        filewriter:close()
    end

    -- 6. Remove book item from inventory (self.item auto-resolved by engine)
    local item = self.item
    if item then
        local container = item:getContainer() or character:getInventory()
        container:Remove(item)
        sendRemoveItemFromContainer(container, item)
    end

    print("[ReadBookAction:complete()] Restored backup for " .. username .. " / " .. bookType)
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
