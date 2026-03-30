if not isServer() then return end

-- On player death: switch active bank (1->2 or 2->1)
Events.OnCharacterDeath.Add(function(character)
    if not instanceof(character, "IsoPlayer") then return end

    local backupIO = require("DiarynoBackupIO")
    local username = character:getUsername()
    local data = backupIO.readBackup(username)

    -- Switch bank
    data.activeBank = (data.activeBank == 2) and 1 or 2

    backupIO.writeBackup(username, data)
    print("[DiarynoAutoBackup] Player " .. username .. " died. Switched to bank " .. tostring(data.activeBank))
end)

-- On player login: auto-save character to active bank
Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "Diaryno" or command ~= "PlayerReady" then return end

    local backupIO = require("DiarynoBackupIO")
    local CharacterSerializer = require("CharacterSerializer")
    local username = player:getUsername()
    local data = backupIO.readBackup(username)

    local bankNum = data.activeBank or 1
    local bankKey = "BKP_" .. bankNum
    data.activeBank = bankNum
    local bankData = CharacterSerializer.collect(player)
    bankData.timestamp = os.date("%c")
    data[bankKey] = bankData

    backupIO.writeBackup(username, data)
    print("[DiarynoAutoBackup] Auto-backup for " .. username .. " saved to " .. bankKey)
end)
