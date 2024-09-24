if not isServer() then return end

local json = require("dkjson")

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
    for key, value in pairs(newData) do
        existingData[key] = value
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



local Commands = {}

-- Command handler for saving the backup
function Commands.saveBackup(player, args)
    local id = player:getUsername()
    print("[Commands.saveBackup] Starting data save for ID " .. id)
    local filepath = "/Backup/EraseBackup/PlayerBKP_" .. id .. ".json"
    print("[Commands.saveBackup] File path: " .. filepath)
    
    -- 'args' is the backupData received from the client
    -- Update the backup file with the new data
    updateBackupFile(filepath, args)

    print("Character data saved successfully for ID: " .. id)
end
Events.OnClientCommand.Add(function(module, command, player, args)
	if module == 'Vorshim' and Commands[command] then
		args = args or {}
		Commands[command](player, args)
	end
end)