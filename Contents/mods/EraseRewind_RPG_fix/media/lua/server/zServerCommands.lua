if not isServer() then return end
local activityCalendar = require("lib/ActivityCalendar")

local json = require("dkjson")
-- UTILS
-- Function to create an incremental backup of the file
local function createIncrementalBackup(filepath)
    -- Create a backup copy of the existing backup file with a .temp extension
    local filereader = getFileReader(filepath, false)
    if filereader then
        local content = ""
        local line = filereader:readLine()
        while line ~= nil do
            content = content .. line .. "\n"
            line = filereader:readLine()
        end
        filereader:close()

        if content ~= "" then
            local backupCopyPath = filepath .. ".temp"
            local filewriter = getFileWriter(backupCopyPath, false, false)
            if filewriter then
                filewriter:write(content)
                filewriter:close()
                print("Incremental backup created: " .. backupCopyPath)
            else
                print("Unable to create incremental backup.")
            end
        else
            print("No existing backup file to copy.")
        end
    else
        print("No existing backup file to copy.")
    end
end

-- Function to update the backup file
local function updateBackupFile(filepath, newData)
    -- Create an incremental backup before modifying the file
    createIncrementalBackup(filepath)
    local bookType = newData.bookType
    local backup = newData.backup
    -- Read existing data from the file
    local content = ""
    local filereader = getFileReader(filepath, false)
    if filereader then
        local line = filereader:readLine()
        while line ~= nil do
            content = content .. line .. "\n"
            line = filereader:readLine()
        end
        filereader:close()
    else
        print("Unable to open file for reading. A new file will be created.")
    end

    -- Parse existing data from JSON
    local existingData = {}
    if content ~= "" then
        local pos, err
        existingData, pos, err = json.decode(content, 1, nil)
        if err then
            print("Error parsing JSON: " .. err)
            existingData = {}
        end
    end

    -- Update existing data with new data
    for key, value in pairs(backup) do
        existingData[key] = value
    end
    if not existingData[bookType] then
        if bookType == "TIMED_BOOK" then
            --- **Book Write Date In Seconds**
            activityCalendar.setWaitingOfDays(SandboxVars.EraseRewindRPG.SetDays)
            local bookWriteDateInSeconds = activityCalendar.getExpectedDateInSecond()
            existingData[bookType] = bookWriteDateInSeconds
            local expectedDate = activityCalendar.fromSecondToDate(bookWriteDateInSeconds)
            extra = " - " .. expectedDate
        else
        existingData[bookType] = os.date("%c")
        end
    end

    -- Serialize updated data to JSON
    local serializedData = json.encode(existingData, { indent = true })

    -- Write updated data to the file
    local filewriter = getFileWriter(filepath, false, false) -- Overwrite the file
    if filewriter then
        filewriter:write(serializedData)
        filewriter:close()
        print("Backup file updated successfully.")
    else
        print("Unable to open file for writing.")
    end
end



-- COMANDI

local Commands = {}

-- Command handler for saving the backup
function Commands.saveBackup(player, args)
    local id = player:getUsername()
    print("[Commands.saveBackup] Starting book backup for ID " .. id .. " for book type " .. args.bookType)
    local filepath = "/Backup/EraseBackup/PlayerBKP_" .. id .. ".json"
    print("[Commands.saveBackup] File path: " .. filepath)
    
    -- 'args' is the backupData received from the client
    -- Update the backup file with the new data
    updateBackupFile(filepath, args)

    print("Character data saved successfully for ID: " .. id)
end

function Commands.checkReadingBook(player, args)
    local id = player:getUsername()
    local filepath = "/Backup/EraseBackup/PlayerBKP_" .. id .. ".json"
    local bookType = args.bookType

    -- Read the JSON backup file
    local content = ""
    local filereader = getFileReader(filepath, false)
    if filereader then
        local line = filereader:readLine()
        while line ~= nil do
            content = content .. line .. "\n"
            line = filereader:readLine()
        end
        filereader:close()
    end

    -- Parse the JSON data
    local backupData = {}
    if content ~= "" then
        local success, parsedData = pcall(function()
            return json.decode(content)
        end)
        if success and parsedData then
            backupData = parsedData
        else
            backupData = {}
        end
    end

    -- Check if the book can be transcribed
    local canRead = false
    local message = nil
    if not backupData[bookType] then
        -- The player hasn't transcribed this book yet
        canRead = false
        message = "NON PUOI LEGGERE"
    else
        -- The player has already transcribed this book
        canRead = true
        message = "PUOI LEGGERE"
    end

    -- Send the response back to the client
    sendServerCommand(player, "Vorshim", "attemptReadingBookResponse", {
        success = canRead,
        message = message,
        bookType = bookType,
        bookItemType = args.bookItemType
    })

    print("[Commands.checkReadBook] Player ID: " .. id .. " - Book Type: " .. bookType .. " - Can Read: " .. tostring(canRead))

end

-- Command handler for requesting backup data
function Commands.requestData(player, args)
    local id = player:getUsername()
    local filepath = "/Backup/EraseBackup/PlayerBKP_" .. id .. ".json"
    print("[Commands.requestData] Player ID: " .. id)
    print("[Commands.requestData] File path: " .. filepath)

    -- Read the JSON backup file
    local content = ""
    local filereader = getFileReader(filepath, false)
    if filereader then
        local line = filereader:readLine()
        while line ~= nil do
            content = content .. line .. "\n"
            line = filereader:readLine()
        end
        filereader:close()
    else
        print("Unable to open file for reading.")
        -- Send an error back to the client
        sendServerCommand(player, "Vorshim", "restoreBackupError", { message = "Backup file not found." })
        return
    end

    -- Parse the JSON data
    local backupData = {}
    if content ~= "" then
        local success, parsedData = pcall(function()
            return json.decode(content)
        end)
        if success and parsedData then
            backupData = parsedData
        else
            print("Error parsing JSON.")
            -- Send an error back to the client
            sendServerCommand(player, "Vorshim", "restoreBackupError", { message = "Error parsing backup data." })
            return
        end
    end

    -- Extract the requested table
    local requestedTableName = args.tableName
    if not requestedTableName then
        print("No table name specified.")
        -- Send an error back to the client
        sendServerCommand(player, "Vorshim", "restoreBackupError", { message = "No table name specified." })
        return
    end

    local requestedData = backupData[requestedTableName]
    if not requestedData then
        print("Requested table '" .. requestedTableName .. "' not found in backup data.")
        -- Send an error back to the client
        sendServerCommand(player, "Vorshim", "restoreBackupError", { message = "Requested table not found." })
        return
    end

    -- Send the requested data back to the client
    sendServerCommand(player, "Vorshim", "restoreBackup", { tableName = requestedTableName, data = requestedData })
    print("Requested data for table '" .. requestedTableName .. "' sent to client.")
    backupData[requestedTableName] = nil
    if requestedTableName == "TimedBook" then
        backupData["TIMED_BOOK"] = nil
    elseif requestedTableName == "ReadOnceBook" then
        backupData["READ_ONCE_BOOK"] = nil
    end

    -- Save the updated data
    local serializedData = json.encode(backupData, { indent = true })
    local filewriter = getFileWriter(filepath, false, false)
    if filewriter then
        filewriter:write(serializedData)
        filewriter:close()
    end
    print("Requested data for table '" .. requestedTableName .. "' eliminated from backup after restore.")
    -- maybe the client can send another request only after the restore from client is give success. just to avoid delete before the restoreEnd
end


function Commands.checkWriteBook(player, args)
    local id = player:getUsername()
    local filepath = "/Backup/EraseBackup/PlayerBKP_" .. id .. ".json"
    local bookType = args.bookType

    -- Read the JSON backup file
    local content = ""
    local filereader = getFileReader(filepath, false)
    if filereader then
        local line = filereader:readLine()
        while line ~= nil do
            content = content .. line .. "\n"
            line = filereader:readLine()
        end
        filereader:close()
    end

    -- Parse the JSON data
    local backupData = {}
    if content ~= "" then
        local success, parsedData = pcall(function()
            return json.decode(content)
        end)
        if success and parsedData then
            backupData = parsedData
        else
            backupData = {}
        end
    end

    -- Check if the book can be transcribed
    local canTranscribe = false
    local message = nil
    local extra = nil

    
    if not backupData[bookType] then
        -- The player hasn't transcribed this book yet
        canTranscribe = true
        -- Update the backup data
        backupData[bookType] = os.date("%c") -- Store the current date/time

        if bookType == "TIMED_BOOK" then
             --- **Book Write Date In Seconds**
             activityCalendar.setWaitingOfDays(SandboxVars.EraseRewindRPG.SetDays)
             local bookWriteDateInSeconds = activityCalendar.getExpectedDateInSecond()
             backupData[bookType] = bookWriteDateInSeconds
             local expectedDate = activityCalendar.fromSecondToDate(bookWriteDateInSeconds)
             extra = " - " .. expectedDate
        end

        -- Save the updated data
        
    elseif bookType == "TIMED_BOOK" and backupData[bookType] then
        ---@type boolean
        canTranscribe = false

        --- **Book Write Date In Seconds**
        ---@type int
        local bookWriteDateInSeconds = 0
        --- **Retrieve the date when it is possible to write a book**
        ---@type table - double

        bookWriteDateInSeconds = backupData[bookType]

        -- **Set scheduled writeBook**
        activityCalendar.setExpectedDateInSecond(bookWriteDateInSeconds)

        --- **Check if date is expected**
        if activityCalendar.isExpectedDate() then
            --- **Remove all mod data**
            backupData[bookType] = nil

            --- **Book Write Date In Seconds**
            activityCalendar.setWaitingOfDays(SandboxVars.EraseRewindRPG.SetDays)
            bookWriteDateInSeconds = activityCalendar.getExpectedDateInSecond()
            backupData[bookType] = bookWriteDateInSeconds
            canTranscribe = true
            local expectedDate = activityCalendar.fromSecondToDate(bookWriteDateInSeconds)
            extra = " - " .. tostring(expectedDate)
        else
            --logica per restituire la data in cui sarà possibile ritrascriverlo
            --- **You can't transcribe this book yet**
            local expectedDate = activityCalendar.fromSecondToDate(bookWriteDateInSeconds)
            extra = " - " .. tostring(expectedDate)
            local translation = (getText( "ContextMenu_ToEarly") .. extra)
            canTranscribe = false
            message = translation
        end
    end
    if canTranscribe then
        -- Save the updated data
        local serializedData = json.encode(backupData, { indent = true })
        local filewriter = getFileWriter(filepath, false, false)
        if filewriter then
            filewriter:write(serializedData)
            filewriter:close()
        end
    else
        -- The player has already transcribed this book
        message = message or getText("ContextMenu_AlreadyWrite")
    end
 

    -- Send the response back to the client
    sendServerCommand(player, "Vorshim", "attemptTranscribeBookResponse", {
        success = canTranscribe,
        message = message,
        bookType = bookType,
        item = args.item,
        extra = extra
    })
end




Events.OnClientCommand.Add(function(module, command, player, args)
	if module == 'Vorshim' and Commands[command] then
		args = args or {}
		Commands[command](player, args)
	end
end)