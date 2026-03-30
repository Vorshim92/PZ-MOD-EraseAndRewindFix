require "ISUI/ISInventoryPaneContextMenu"
require "TimedActions/ISTimedActionQueue"

local BOOK_TYPES = {
    ReadOnceBook = "READ_ONCE_BOOK",
    TimedBook = "TIMED_BOOK",
}

local function isEraseBook(item)
    return BOOK_TYPES[item:getType()] ~= nil
end

local function onWriteBook(item, character)
    local bookType = BOOK_TYPES[item:getType()]
    ISTimedActionQueue.add(WriteBookAction:new(character, item, bookType))
end

local function onReadBook(item, character)
    local bookType = BOOK_TYPES[item:getType()]
    ISTimedActionQueue.add(ReadBookAction:new(character, item, bookType))
end

local function addBookContext(playerNum, context, items)
    local player = getSpecificPlayer(playerNum)

    for _, v in ipairs(items) do
        local item = v
        if not instanceof(v, "InventoryItem") then
            item = v.items[1]
        end

        if isEraseBook(item) then
            context:addOption(getText("ContextMenu_TranscribeBook"), item, onWriteBook, player)
            context:addOption(getText("ContextMenu_ReadBook"), item, onReadBook, player)
            break
        end
    end
end

Events.OnPreFillInventoryObjectContextMenu.Add(addBookContext)
