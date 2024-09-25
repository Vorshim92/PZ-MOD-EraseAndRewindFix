if not isClient() then return end
local characterManagement = require("character/CharacterManagement")
local Commands = {}

-- Command handler for restoring backup data
function Commands.restoreBackup(module, command, args)
    local tableName = args.tableName
    local data = args.data

    if tableName and data then
        print("Received backup data for table: " .. tableName)
        -- local temp = ModData.getOrCreate("Erase_Rewind")
        -- temp[tableName] = data
        -- ModData.add("Erase_Rewind", temp)
        print("Backup data restored for table: " .. tableName)
        characterManagement.readBook(getPlayer(), data)
    else
        print("Invalid data received from server.")
    end
end

-- Command handler for handling errors
function Commands.restoreBackupError(module, command, args)
    local message = args.message or "Unknown error."
    print("Error restoring backup data: " .. message)
    -- Handle the error (e.g., display a message to the player)
end


-- Event handler for server commands
Events.OnServerCommand.Add(function(module, command, args)
    if module == 'Vorshim' and Commands[command] then
        args = args or {}
        Commands[command](module, command, args)
    end
end)
