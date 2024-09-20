if not isServer() then return end

-- UTILS
-- Funzione per serializzare una tabella in formato testo con indentazione
-- Funzione per serializzare una tabella in formato testo con indentazione
-- local function serializeData(tbl, indent)
--     indent = indent or ""
--     local serialized = ""
--     for key, value in pairs(tbl) do
--         local keyStr = tostring(key)
--         if not keyStr:match("^[_%a][_%w]*$") then
--             keyStr = string.format("[%q]", keyStr)
--         end

--         if type(value) == "table" then
--             -- Serializzazione di una tabella
--             serialized = serialized .. indent .. keyStr .. " = {\n"
--             serialized = serialized .. serializeData(value, indent .. "    ")
--             serialized = serialized .. indent .. "},\n"
        
--         elseif type(value) == "userdata" then
--             -- Gestione di userdata iterabile
--             local size = value:size()
--             serialized = serialized .. indent .. keyStr .. " = {\n"
--             for i = 0, size - 1 do
--                 local element = value:get(i)
--                 -- Assicurati che ogni elemento sia una tabella o serializzabile
--                 serialized = serialized .. serializeData(element, indent .. "    ")
--             end
--             serialized = serialized .. indent .. "},\n"
        
--         else
--             -- Serializzazione di valori primitivi
--             local valueStr
--             if type(value) == "string" then
--                 valueStr = string.format("%q", value)
--             elseif type(value) == "number" or type(value) == "boolean" then
--                 valueStr = tostring(value)
--             else
--                 valueStr = '"UnsupportedType"'
--             end
--             serialized = serialized .. indent .. keyStr .. " = " .. valueStr .. ",\n"
--         end
--     end
--     return serialized
-- end

local function vorshimSerial(tbl, indent)
    indent = indent or ""
    local serialized = ""
    
    if type(tbl) ~= "table" then
        -- Se non è una tabella, serializza come stringa o altro tipo
        if type(tbl) == "string" then
            return string.format("%q", tbl)
        elseif type(tbl) == "number" or type(tbl) == "boolean" then
            return tostring(tbl)
        elseif type(tbl) == "userdata" then
            return tostring(tbl)
            else
            return '"UnsupportedType"'
        end
    end

    for key, value in pairs(tbl) do
        local keyStr = tostring(key)
        if not keyStr:match("^[_%a][_%w]*$") then
            keyStr = string.format("[%q]", keyStr)
        end
        if type(value) == "table" then
            serialized = serialized .. indent .. keyStr .. " = {\n"
            serialized = serialized .. vorshimSerial(value, indent .. "    ")
            serialized = serialized .. indent .. "},\n"
        else
            local valueStr
            if type(value) == "string" then
                valueStr = string.format("%q", value)
            elseif type(value) == "number" or type(value) == "boolean" then
                valueStr = tostring(value)
            elseif type(value) == "userdata" then
                valueStr = tostring(value)
            else
                valueStr = '"UnsupportedType"'
            end
            serialized = serialized .. indent .. keyStr .. " = " .. valueStr .. ",\n"
        end
    end
    return serialized
end



-- Funzione ricorsiva per contare gli elementi in una tabella
local function countDataSize(data)
    local size = 0
    if type(data) == "table" then
        for _, v in pairs(data) do
            size = size + countDataSize(v)
        end
    else
        size = size + 1
    end
    return size
end

-- Funzione per sostituire o aggiungere una sezione nel file di backup
local function replaceOrAddSection(content, sectionName, serializedSection)
    -- Pattern per trovare la sezione esistente
    local pattern = sectionName .. " = %b{},?\n"
    if content:match(sectionName .. " = {") then
        -- Sostituisci la sezione esistente
        local newContent, count = content:gsub(pattern, serializedSection)
        if count > 0 then
            print("Sezione " .. sectionName .. " aggiornata nel file di backup.")
            return newContent
        else
            -- Se non riesce a sostituire, aggiungi la sezione
            print("Sezione " .. sectionName .. " non trovata completamente. Aggiunta al file.")
            return content .. serializedSection
        end
    else
        -- Aggiungi la sezione se non esiste
        print("Sezione " .. sectionName .. " non esiste. Aggiunta al file.")
        return content .. serializedSection
    end
end

local function createIncrementalBackup(filepath)
    -- Crea una copia del file di backup esistente con un timestamp
    local filereader = getFileReader(filepath, false)
    if filereader then
        local content = {}
        local line = filereader:readLine()
        while line ~= nil do
            table.insert(content, line)
            line = filereader:readLine()
        end
        filereader:close()

        if content and #content > 0 then
            local backupCopyPath = filepath .. ".temp"
            local contentString = table.concat(content, "\n")

            local filewriter = getFileWriter(backupCopyPath, true, false)
            if filewriter then
                filewriter:write(contentString)
                filewriter:close()
                print("Backup incrementale creato: " .. backupCopyPath)
            else
                print("Impossibile creare il backup incrementale.")
            end
        else
            print("Nessun file di backup esistente da copiare.")
        end
    else
        print("Nessun file di backup esistente da copiare.")
    end
end




-- Funzione per aggiornare il file di backup
local function updateBackupFile(filepath, sectionName, data)
    -- Crea un backup incrementale prima di modificare il file
    createIncrementalBackup(filepath)

    -- Leggi il contenuto esistente del file
    local filereader = getFileReader(filepath, false)
    local content = {}
    
    if filereader then
        local line = filereader:readLine()
        while line ~= nil do
            table.insert(content, line)
            line = filereader:readLine()
        end
        filereader:close()
    else
        print("Impossibile aprire il file per la lettura. Verrà creato un nuovo file.")
    end

    -- Serializza i nuovi dati
    local serializedData
    if type(data) == "table" then
        serializedData = sectionName .. " = {\n" .. vorshimSerial(data) .. "},\n"
    else
        -- Supponendo che `data` sia una stringa, numero o booleano per BKP_MOD_1
        serializedData = sectionName .. " = " .. vorshimSerial(data) .. ",\n"
    end
    if content and #content > 0 then
    local contentString = table.concat(content, "\n")
    -- Sostituisci o aggiungi la sezione
    content = replaceOrAddSection(contentString, sectionName, serializedData)
    end

    -- Scrivi il contenuto aggiornato nel file
    local filewriter = getFileWriter(filepath, false, false) -- 'false' per non appendere e 'false' per non creare se non esiste
    if filewriter then
        filewriter:write(content)
        filewriter:close()
        print("File di backup aggiornato correttamente.")
    else
        print("Impossibile aprire il file per la scrittura.")
    end
end



--- **Store Backup On Server**


local Commands = {}
function Commands.saveBackup(player, args)
    local id = player:getUsername()
    print("[Commands.saveBackup] Inizio del salvataggio dei dati per ID " .. id )
    local filepath = "/Backup/EraseBackup/PlayerBKP_" .. id .. ".txt"
    print("[Commands.saveBackup] Percorso del file: " .. filepath)
    
    -- Recupera i dati dal comando
    local backupData = args -- { BKP_MOD_1 = "timestamp", BKP_1 = { ... } }
    
    for sectionName, data in pairs(backupData) do
        -- Aggiorna ogni sezione nel file di backup
        updateBackupFile(filepath, sectionName, data)
    end

    print("Dati del personaggio salvati correttamente per ID: " .. id)
end




-- function Commands.saveBackup(player, args)
--     local id = player:getUsername()
--     print("[Commands.saveBackup] Inizio del salvataggio dei dati per ID " .. id )
--     local filepath = "/Backup/EraseBackup/PlayerBKP_" .. id .. ".txt"
--     print("[Commands.saveBackup] Percorso del file: " .. filepath)
    
--     -- Recupera i dati dal comando
--     local backupTables = args.data
    
--     -- Apri il file 
--     local filewriter = getFileWriter(filepath, true, false)
--     if filewriter then
--         for tableName, data in pairs(backupTables) do
--             -- Scrivi il nome della tabella
--             filewriter:write("Table Name: " .. tableName .. "\n")
            
--             if data then
--                 print("Dati ottenuti per la tabella: " .. tableName)
--                 local serializedData = vorshimSerial(data)
                
--                 filewriter:write(serializedData)
--                 filewriter:write("\n\n")
--             else
--                 print("Nessun dato trovato per la tabella: " .. tableName)
--             end
--         end
        
--         filewriter:close()
--         print("Dati del personaggio salvati correttamente per ID: " .. id)
--     else
--         print("Impossibile aprire il file per la scrittura.")
--     end
-- end



-- function Commands.saveBackup(player, args)
--     local id = player:getUsername()
--     local filepathName = ""
--     if args.name == "readOneBook" then
--         filepathName = "ROB"
--     elseif args.name == "timedBook" then
--         filepathName = "TB"
--     elseif args.name == "BKP_MOD_1" then
--         filepathName = "BKP1"
--     elseif args.name == "BKP_MOD_2" then
--         filepathName = "BKP2"
--     end
--     print("[Commands.saveBackup] Inizio del salvataggio dei dati per ID " .. id .. " - " .. filepathName)
--     local filepath = "/Backup/EraseBackup/PlayerBKP_" .. id .. "_" .. filepathName .. ".txt"
--     print("[Commands.saveBackup] Percorso del file: " .. filepath)
--     -- Recupera i dati dal comando
--     local tableName = args.name
--     local modDataTable = args.data

--     -- Apri il file in modalità append
--     local filewriter = getFileWriter(filepath, true, true)
--     if not filewriter then
--         print("[Commands.saveBackup] Impossibile aprire il file per la scrittura.")
--         return
--     end

--     -- Scrivi il nome della tabella
--     if tableName then
--         print("[Commands.saveBackup] Elaborazione della tabella: " .. tableName)
--         filewriter:write("Table Name: " .. tableName .. "\n")
--     else
--         print("[Commands.saveBackup] Nome della tabella mancante.")
--     end

--     -- Serializza e scrivi i dati
--     if modDataTable then
--         print("[Commands.saveBackup] Dati ottenuti per la tabella: " .. tableName)
--         local serializedData = serializeData(modDataTable)
--         filewriter:write(serializedData)
--         filewriter:write("\n\n")
--     else
--         print("[Commands.saveBackup] Nessun dato trovato per la tabella: " .. tableName)
--     end

--     filewriter:close()
--     print("[Commands.saveBackup] Dati del personaggio salvati correttamente per ID: " .. id)
-- end



local function ServerGlobalModData()
    
    print("Inizio del salvataggio dei dati per il Server Mod Data ")
    local filepath = "/Backup/EraseBackup/ServerGlobalModData.txt"
    print("Percorso del file: " .. filepath)

    local tableNames = ModData.getTableNames()
    local size = tableNames:size()
    

    local filewriter = getFileWriter(filepath, true, false)
    if filewriter then
        for i = 0, size - 1 do

      local tableName = tableNames:get(i)
            print("Elaborazione della tabella: " .. tableName)
            filewriter:write("Table Name: " .. tableName .. "\n")
            local modDataTable = ModData.get(tableName)
            
            if modDataTable then
                print("Dati ottenuti per la tabella: " .. tableName)
                local serializedData = vorshimSerial(modDataTable)
                
                filewriter:write(serializedData)
                filewriter:write("\n\n")
            else
                print("Nessun dato trovato per la tabella: " .. tableName)
            end
        end
        
        filewriter:close()
        print("Dati del Server Global Mod Data  salvati correttamente")
    else
        print("Impossibile aprire il file per la scrittura.")
    end
end



Events.OnClientCommand.Add(function(module, command, player, args)
	if module == 'Vorshim' and Commands[command] then
		args = args or {}
		Commands[command](player, args)
	end
end)

Events.OnServerStarted.Add(ServerGlobalModData)
