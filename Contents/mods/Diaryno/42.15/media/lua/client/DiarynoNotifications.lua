if not isClient() then return end

local HALO_DURATION = 300

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "Diaryno" or command ~= "bookActionFailed" then return end

    local player = getPlayer()
    if not player then return end

    local message = getText(args.key or "UI_TranscribeBook_NotTranscribed") .. (args.extra or "")
    local ci = Core.getInstance():getBadHighlitedColor()
    player:setHaloNote(message,
        math.floor(ci:getR() * 255), math.floor(ci:getG() * 255), math.floor(ci:getB() * 255), HALO_DURATION)
end)
