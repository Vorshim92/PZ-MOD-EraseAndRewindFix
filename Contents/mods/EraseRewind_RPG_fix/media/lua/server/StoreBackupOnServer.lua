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

local function vorshimSerial (tbl, indent)
    indent = indent or ""
    local serialized = ""
    for key, value in pairs(tbl) do
        local keyStr = tostring(key)
        if not keyStr:match("^[_%a][_%w]*$") then
            keyStr = string.format("[%q]", keyStr)
        else
            keyStr = keyStr
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

-- Funzione per aggiornare una specifica tabella nel file di backup
local function updateBackupFile(filepath, tableName, newData)
    -- Leggi il contenuto esistente del file
    local file = io.open(filepath, "r")
    local content = ""
    if file then
        content = file:read("*all")
        file:close()
    else
        print("Impossibile aprire il file per la lettura. Verrà creato un nuovo file.")
    end

    -- Serializza i nuovi dati
    local serializedData = vorshimSerial(newData)
    local tableSection = tableName .. " = {\n" .. serializedData .. "},\n"

    -- Verifica se la tabella esiste già nel file
    local pattern = tableName .. " = {%b{}}"
    if content:match(tableName .. " = {") then
        -- Trova la posizione di inizio e fine della tabella esistente
        local start_pos, end_pos = content:find(tableName .. " = {.-},\n", 1, true)
        if start_pos and end_pos then
            -- Sostituisci la sezione esistente con i nuovi dati
            content = content:sub(1, start_pos - 1) .. tableSection .. content:sub(end_pos + 1)
            print("Tabella " .. tableName .. " aggiornata nel file di backup.")
        else
            -- Se non riesce a trovare il pattern completo, aggiungi la nuova sezione
            content = content .. tableSection
            print("Tabella " .. tableName .. " aggiunta al file di backup.")
        end
    else
        -- Aggiungi la nuova sezione al contenuto
        content = content .. "Table Name: " .. tableName .. "\n" .. tableSection .. "\n"
        print("Tabella " .. tableName .. " aggiunta al file di backup.")
    end

    -- Scrivi il contenuto aggiornato nel file
    local fileWriter = io.open(filepath, "w")
    if fileWriter then
        fileWriter:write(content)
        fileWriter:close()
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
    local backupTables = args.data
    local tableName = args.name
        -- Aggiorna il file di backup con la tabella specifica
        updateBackupFile(filepath, tableName, backupTables)

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
                local serializedData = serializeData(modDataTable)
                
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
