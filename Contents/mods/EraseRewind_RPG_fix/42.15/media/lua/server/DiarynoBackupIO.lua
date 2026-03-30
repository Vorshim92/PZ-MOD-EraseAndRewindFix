local json = require("dkjson")

local DiarynoBackupIO = {}

local BACKUP_DIR = "Backup/Diaryno/PlayerBKP_"

function DiarynoBackupIO.getFilepath(username)
    return BACKUP_DIR .. username .. ".json"
end

--- Read backup JSON for a player. Returns empty table if file doesn't exist or is corrupt.
---@param username string
---@return table
function DiarynoBackupIO.readBackup(username)
    local filepath = DiarynoBackupIO.getFilepath(username)
    local filereader = getFileReader(filepath, false)
    if not filereader then
        return {}
    end

    local lines = {}
    local line = filereader:readLine()
    while line ~= nil do
        table.insert(lines, line)
        line = filereader:readLine()
    end
    filereader:close()

    local content = table.concat(lines, "\n")
    if content == "" then
        return {}
    end

    local decoded, _, err = json.decode(content, 1, nil)
    if err or not decoded then
        print("[DiarynoBackupIO] Error parsing JSON for " .. username .. ": " .. tostring(err))
        return {}
    end

    return decoded
end

--- Write backup JSON for a player. Creates incremental .temp backup first.
---@param username string
---@param data table
function DiarynoBackupIO.writeBackup(username, data)
    local filepath = DiarynoBackupIO.getFilepath(username)

    -- Incremental backup (.temp)
    local existingReader = getFileReader(filepath, false)
    if existingReader then
        local existingLines = {}
        local eline = existingReader:readLine()
        while eline ~= nil do
            table.insert(existingLines, eline)
            eline = existingReader:readLine()
        end
        existingReader:close()
        local existingContent = table.concat(existingLines, "\n")
        if existingContent ~= "" then
            local tempWriter = getFileWriter(filepath .. ".temp", false, false)
            if tempWriter then
                tempWriter:write(existingContent)
                tempWriter:close()
            end
        end
    end

    -- Write new data
    local serialized = json.encode(data, { indent = true })
    local filewriter = getFileWriter(filepath, false, false)
    if filewriter then
        filewriter:write(serialized)
        filewriter:close()
    else
        print("[DiarynoBackupIO] Unable to write backup file for " .. username)
    end
end

return DiarynoBackupIO
