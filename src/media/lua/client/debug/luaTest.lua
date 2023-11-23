-- SR & ER Ok
-- ROB letture e scrittura ok


--local nome = "ReadOnce Book - qualcosa - qualcosaltro"
--
--local nome_cognome = nome:match("^[^ -]* - [^ -]*")
--
--nome_cognome:sub(1, nome_cognome:find(" ") - 1)

--function contextER.addSaveContext(character, context, items)
--
--    for _, v in ipairs(items) do
--
--        local character = getPlayer()
--        -- check per item annidato
--        local item = v
--
--        if not instanceof(v, "InventoryItem") then
--            item = v.items[1]
--        end
--
--        -- check per item giusto
--        if item:getType() == eraseRewindJournal then
--            context:addOption("Trascrivi", item, contextER.onSavePlayer, character)
--        end
--    end
--end