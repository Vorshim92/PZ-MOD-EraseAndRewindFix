if not isClient() then return end

Events.OnServerCommand.Add(function(module, command, args)
    if module == "Diaryno" and command == "bookActionFailed" then
        local message = args and args.message or "Error"
        getPlayer():Say(message)
    end
end)
