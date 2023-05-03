require "ISUI/ISInventoryPaneContextMenu"

local eraseRewindJournal = "EraseRewindJournal"
local contextER = {}

function contextER.addSaveContext(character, context, items)

    for _, v in ipairs(items) do

        local character = getPlayer()
        -- check per item annidato
		local item = v

        if not instanceof(v, "InventoryItem") then
			item = v.items[1]
		end

        -- check per item giusto
		if item:getType() == eraseRewindJournal then
            context:addOption("Salva", item, contextER.onSavePlayer, character)
        end
    end
end

---Save
---@param item InventoryItem
---@param character Literature
function contextER.onSavePlayer(item, character)
	-- qua il salvataggio moddata
    writeBook(character)
    item:setName(eraseRewindJournal .. " - " .. character:getDisplayName() )
    character:Say("Libro scritto")
    character:playSound("OpenBook")
end

Events.OnPreFillInventoryObjectContextMenu.Add(contextER.addSaveContext)