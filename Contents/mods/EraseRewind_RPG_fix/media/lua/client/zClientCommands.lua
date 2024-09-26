if not isClient() then return end
local characterManagement = require("character/CharacterManagement")
local pageBook = require("book/PageBook")
local modDataManager = require("lib/ModDataManager")
local activityCalendar = require("lib/ActivityCalendar")

local Commands = {}

-- Command handler for restoring backup data
function Commands.restoreBackup(module, command, args)
    local tableName = args.tableName
    local data = args.data

    if tableName and data then
        print("Received backup data for table: " .. tableName)
        characterManagement.readBook(getPlayer(), data)
        print("Backup data restored for table: " .. tableName)
        getPlayer():Say("Backup data restored for table: " .. tableName)
    else
        print("Invalid data received from server.")
    end
end

-- Command handler for handling errors
function Commands.restoreBackupError(module, command, args)
    local message = args.message or "Unknown error."
    print("Error restoring backup data: " .. message)
    getPlayer():Say("Error restoring backup data: " .. message)
    -- Handle the error (e.g., display a message to the player)
end

function Commands.attemptTranscribeBookResponse(module, command, args)
    local success = args.success
    local message = args.message
    local bookType = args.bookType
    local player = getPlayer()

    if success then
        -- Proceed with writing the book locally
        if bookType == "READ_ONCE_BOOK" then
            characterManagement.writeBook(player, pageBook.ReadOnceBook, "ReadOnceBook")
        elseif bookType == "TIMED_BOOK" then
            characterManagement.writeBook(player, pageBook.TimedBook, "TimedBook")
        end
        player:Say(getText("ContextMenu_WrittenBook"))
    else
        -- Inform the player that they cannot transcribe
        player:Say(message or getText("ContextMenu_AlreadyWrite"))
    end

    -- Play closing sound
    player:playSound("CloseBook")
end


-- Event handler for server commands
Events.OnServerCommand.Add(function(module, command, args)
    if module == 'Vorshim' and Commands[command] then
        args = args or {}
        Commands[command](module, command, args)
    end
end)
