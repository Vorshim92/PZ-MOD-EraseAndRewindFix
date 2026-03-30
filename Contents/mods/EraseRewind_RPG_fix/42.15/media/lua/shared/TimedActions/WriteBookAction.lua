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

function WriteBookAction:perform()
    self.character:playSound("CloseBook")
    self.character:Say(getText("ContextMenu_WrittenBook"))
    ISBaseTimedAction.perform(self)
end

function WriteBookAction:complete()
    if not isServer() then return true end

    local json = require("dkjson")
    local activityCalendar = require("lib/ActivityCalendar")
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

    -- 2. Validate write permission
    if bookType == "READ_ONCE_BOOK" and backupData[bookType] then
        local extra = ": " .. tostring(backupData[bookType])
        sendServerCommand(character, "Diaryno", "bookActionFailed", {
            message = getText("ContextMenu_AlreadyTranscribed") .. extra
        })
        return false
    end

    if bookType == "TIMED_BOOK" and backupData[bookType] then
        local bookWriteDateInSeconds = backupData[bookType]
        activityCalendar.setExpectedDateInSecond(bookWriteDateInSeconds)
        if not activityCalendar.isExpectedDate() then
            local expectedDate = activityCalendar.fromSecondToDate(bookWriteDateInSeconds)
            sendServerCommand(character, "Diaryno", "bookActionFailed", {
                message = getText("ContextMenu_ToEarly") .. ": " .. tostring(expectedDate)
            })
            return false
        end
    end

    -- 3. Collect character data
    local characterData = CharacterSerializer.collect(character)

    -- 4. Create incremental backup (.temp)
    local existingReader = getFileReader(filepath, false)
    if existingReader then
        local existingLines = {}
        local eline = existingReader:readLine()
        while eline ~= nil do
            table.insert(existingLines, eline)
            eline = existingReader:readLine()
        end
        existingReader:close()
        local existingContent = table.concat(existingLines, "\n")
        if existingContent ~= "" then
            local tempWriter = getFileWriter(filepath .. ".temp", false, false)
            if tempWriter then
                tempWriter:write(existingContent)
                tempWriter:close()
            end
        end
    end

    -- 5. Update backup data
    backupData[bookTableName] = characterData

    if bookType == "TIMED_BOOK" then
        activityCalendar.setWaitingOfDays(SandboxVars.Diaryno.SetDays)
        backupData[bookType] = activityCalendar.getExpectedDateInSecond()
    else
        backupData[bookType] = os.date("%c")
    end

    -- 6. Write JSON
    local serialized = json.encode(backupData, { indent = true })
    local filewriter = getFileWriter(filepath, false, false)
    if filewriter then
        filewriter:write(serialized)
        filewriter:close()
    else
        print("[WriteBookAction:complete()] Unable to write backup file for " .. username)
        return false
    end

    -- 7. Rename book item (self.item auto-resolved by engine)
    local item = self.item
    if item then
        local extra = ""
        if bookType == "TIMED_BOOK" then
            local expectedDate = activityCalendar.fromSecondToDate(backupData[bookType])
            extra = " - " .. tostring(expectedDate)
        elseif bookType == "READ_ONCE_BOOK" then
            extra = " - " .. tostring(backupData[bookType])
        end
        item:setName(bookTableName .. " - " .. character:getFullName() .. extra)
    end

    print("[WriteBookAction:complete()] Saved backup for " .. username .. " / " .. bookType)
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
