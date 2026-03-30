local function onPlayerReady(playerIndex, player)
    local tickCount = 0
    local function delayedSend()
        tickCount = tickCount + 1
        if tickCount >= 200 then
            sendClientCommand(player, "Diaryno", "PlayerReady", {})
            Events.OnTick.Remove(delayedSend)
        end
    end
    Events.OnTick.Add(delayedSend)
end

Events.OnCreatePlayer.Add(onPlayerReady)
