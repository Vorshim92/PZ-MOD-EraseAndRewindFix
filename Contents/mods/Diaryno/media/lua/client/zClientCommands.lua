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
        print("Received backup data for: " .. tableName)
        characterManagement.readBook(getPlayer(), data)
        print("Backup data restored for table: " .. tableName)
        getPlayer():Say("Backup data restored for: " .. tableName)
        -- Play closing sound
        getPlayer():playSound("CloseBook")
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
    local item = args.item
    local player = getPlayer()
    local extra = args.extra or ""

    if success then
        -- Proceed with writing the book locally
        if bookType == "READ_ONCE_BOOK" then
            characterManagement.writeBook(player, pageBook.ReadOnceBook, "ReadOnceBook")
        elseif bookType == "TIMED_BOOK" then
            characterManagement.writeBook(player, pageBook.TimedBook, "TimedBook")
        end
        player:Say(message or getText("ContextMenu_WrittenBook"))
        if item then
            --- extract name of the book "ReadOnceBook" or "TimedBook"
            local type = item:getName():match("^[^ -]* - [^ -]*")
            type:sub(1, type:find(" ") - 1)
            --- **Set name of the book**
            local itemInventory = player:getInventory():getFirstTypeRecurse(item:getType())
            itemInventory:setName(type .. " - " .. player:getFullName() .. extra)
        end
    else
        -- Inform the player that they cannot transcribe
        player:Say(message or getText("ContextMenu_AlreadyWrite"))
    end

    -- Play closing sound
    player:playSound("CloseBook")
end


function Commands.attemptReadingBookResponse(module, command, args)
    local success = args.success
    local message = args.message
    local bookType = args.bookType
    local itemType = args.bookItemType
    print(itemType)
    local player = getPlayer()
    if success then
        player:playSound("OpenBook")
        -- Proceed with writing the book locally
        if bookType == "READ_ONCE_BOOK" then
            -- sendClientCommand(player,"Vorshim", "requestData", { tableName = "ReadOnceBook" })
            characterManagement.requestBackupData("ReadOnceBook")
        elseif bookType == "TIMED_BOOK" then
            -- sendClientCommand(player,"Vorshim", "requestData", { tableName = "TimedBook" })

            characterManagement.requestBackupData("TimedBook")
        end
        player:Say("EUREKA!!!")
        player:getInventory():RemoveOneOf(itemType)
    else
        -- Inform the player that they cannot transcribe
        player:Say(message or getText("ContextMenu_CannotReadBook"))
    end

    

end


-- Event handler for server commands
Events.OnServerCommand.Add(function(module, command, args)
    if module == 'Vorshim' and Commands[command] then
        args = args or {}
        Commands[command](module, command, args)
    end
end)
