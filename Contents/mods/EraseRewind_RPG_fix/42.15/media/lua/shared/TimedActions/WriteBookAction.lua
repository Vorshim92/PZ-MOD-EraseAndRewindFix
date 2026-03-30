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

function WriteBookAction:complete()
    if not isServer() then return true end

    local backupIO = require("DiarynoBackupIO")
    local activityCalendar = require("lib/ActivityCalendar")
    local CharacterSerializer = require("CharacterSerializer")

    local character = self.character
    local username = character:getUsername()
    local bookType = self.bookType
    local bookTableName = self.bookTableName

    -- 1. Read existing backup file
    local backupData = backupIO.readBackup(username)

    -- 2. Validate write permission
    if bookType == "READ_ONCE_BOOK" and backupData[bookType] then
        local extra = ": " .. tostring(backupData[bookType])
        sendServerCommand(character, "Diaryno", "bookActionFailed", {
            key = "ContextMenu_AlreadyTranscribed", extra = extra
        })
        return false
    end

    if bookType == "TIMED_BOOK" and backupData[bookType] then
        local bookWriteDateInSeconds = backupData[bookType]
        activityCalendar.setExpectedDateInSecond(bookWriteDateInSeconds)
        if not activityCalendar.isExpectedDate() then
            local expectedDate = activityCalendar.fromSecondToDate(bookWriteDateInSeconds)
            sendServerCommand(character, "Diaryno", "bookActionFailed", {
                key = "ContextMenu_ToEarly", extra = ": " .. tostring(expectedDate)
            })
            return false
        end
    end

    -- 3. Collect character data
    local characterData = CharacterSerializer.collect(character)

    -- 4. Update backup data
    backupData[bookTableName] = characterData

    if bookType == "TIMED_BOOK" then
        activityCalendar.setWaitingOfDays(SandboxVars.Diaryno.SetDays)
        backupData[bookType] = activityCalendar.getExpectedDateInSecond()
    else
        backupData[bookType] = os.date("%c")
    end

    -- 5. Write JSON (with incremental .temp backup)
    backupIO.writeBackup(username, backupData)

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
