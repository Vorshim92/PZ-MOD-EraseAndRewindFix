    -- fix migration to new version
    modDataManager = require("lib/ModDataManager")
    pageBook = require("book/PageBook")
    -- vecchie chiavi per per i libri
    -- Vecchie chiavi per i libri
local oldKeys = {
    "characterBoost",
    "characterCalories",
    "characterLifeTime",
    "characterMultiplier",
    "characterPerkDetails",
    "characterProfession",
    "characterRecipes",
    "characterTraits",
    "characterWeight",
    "characterKilledZombies",
    "characterSkillLimiter"
}

-- Nuove chiavi per ReadOnceBook, nell'ordine corrispondente
local newKeys = {
    "characterBoost_ReadOnce",
    "characterCalories_ReadOnce",
    "characterLifeTime_ReadOnce",
    "characterMultiplier_ReadOnce",
    "characterPerkDetails_ReadOnce",
    "characterProfession_ReadOnce",
    "characterRecipes_ReadOnce",
    "characterTraits_ReadOnce",
    "characterWeight_ReadOnce",
    "characterKilledZombies_ReadOnce",
    "characterSkillLimiter_ReadOnce"
}


    -- se esiste un vecchio backup verrà spostato nel nuovo readOnceBook (per questioni pratiche meglio rispetto al timed che ha la variabile del tempo)
    local function migrateOldBackups(oldKeys)
        local flag = false
        -- faccio prima un check veloce sull'esistenza di quella chiavi vecchie
        -- se esiste una chiave vecchia allora conviene cominciare il trasferimento 
        for _, oldKey in pairs(oldKeys) do
            if modDataManager.isExists(oldKey) then
                flag = true
                break
            end
        end
        if not flag then
            print("Nessun vecchio backup trovato. Migrazione non necessaria.")
            return
        end
        -- si resetta il TIMED per sicurezza
        if modDataManager.isExists(pageBook.Character.TIMED_BOOK) then
            modDataManager.remove(pageBook.Character.TIMED_BOOK)
            print("Rimosso TIMED_BOOK")
        end

        -- se esiste cancelliamo il libro readOnce
        if modDataManager.isExists(pageBook.Character.READ_ONCE_BOOK) then
            modDataManager.remove(pageBook.Character.READ_ONCE_BOOK)
            print("Rimosso READ_ONCE_BOOK")

            -- se esiste anche il libro readOnceBook controllo per sicurezza e se esiste lo rimuovo
            -- if modDataManager.isExists(pageBook.Character.ReadOnceBook) then
            --     for _, key in pairs(pageBook.Character.ReadOnceBook) do
            --         modDataManager.remove(key)
            --     end
            -- end
        end
        -- creo la flag del nuovo libro readOnce
        modDataManager.save(pageBook.Character.READ_ONCE_BOOK)
        print("Creato nuovo READ_ONCE_BOOK")


        -- Itera sulle vecchie chiavi per migrare i dati
    for index, oldKey in ipairs(oldKeys) do
        local newKey = newKeys[index]

        if modDataManager.isExists(oldKey) then
            -- Leggi i dati dalla vecchia chiave
            local lines = modDataManager.read(oldKey)

            if lines then
                -- Aggiungi i dati alla nuova chiave
                modDataManager.add(newKey, lines)
                print("Migrato " .. oldKey .. " a " .. newKey)
            else
                print("Nessun dato trovato per la chiave " .. oldKey)
            end

            -- Rimuovi la vecchia chiave dopo la migrazione
            modDataManager.remove(oldKey)
            print("Rimosso vecchio backup " .. oldKey)
        end
    end
end

Events.OnCreatePlayer.Add(migrateOldBackups)