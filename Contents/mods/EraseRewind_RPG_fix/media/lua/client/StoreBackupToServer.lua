function VorshimSendData(character, modData_table)
        local name
        if modData_table == pageBook.Character.TimedBook then
            name = pageBook.Character.TIMED_BOOK
        elseif modData_table == pageBook.Character.ReadOnceBook then
            name = pageBook.Character.READ_ONCE_BOOK
        elseif modDataManager.isExists("isDeath_Bkp") then 
            name = "BKP_MOD_2"
        else 
            name = "BKP_MOD_1"
        end
        -- local data = {}
        -- for _, key in pairs(modData_table) do
        --     modDataManager.read(key)
        --     table.insert(data, key)
        -- end
        -- se data è maggiore di 0 inviamo  
        -- if #data > 0 then
           local args = {name = name , data = modData_table}
    
            sendClientCommand(character, "Vorshim", "saveBackup", args)
        -- end
    end
    
