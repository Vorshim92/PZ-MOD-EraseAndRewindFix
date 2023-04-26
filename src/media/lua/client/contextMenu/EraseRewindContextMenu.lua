require "ISUI/ISInventoryPaneContextMenu"

local eraseRewindJournal = "EraseRewindJournal"
local contextER = {}

function contextER.addSaveContext(character, context, items)
    for _, v in ipairs(items) do

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

---@param journal InventoryItem|Literature
function contextER.onSavePlayer(journal, character)
	-- qua il salvataggio moddata
    writeBook(getPlayer())
end

Events.OnPreFillInventoryObjectContextMenu.Add(contextER.addSaveContext)