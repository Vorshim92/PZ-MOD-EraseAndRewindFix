if not isClient() then return end

local HALO_DURATION = 300

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "Diaryno" then return end

    local player = getPlayer()
    if not player then return end

    if command == "bookActionFailed" then
        local message = getText(args.key or "UI_TranscribeBook_NotTranscribed") .. (args.extra or "")
        local ci = Core.getInstance():getBadHighlitedColor()
        player:setHaloNote(message,
            math.floor(ci:getR() * 255), math.floor(ci:getG() * 255), math.floor(ci:getB() * 255), HALO_DURATION)
    elseif command == "syncRecipes" and args.recipes then
        player:forgetRecipes()
        for _, recipeName in pairs(args.recipes) do
            player:learnRecipe(recipeName)
        end
    end
end)
