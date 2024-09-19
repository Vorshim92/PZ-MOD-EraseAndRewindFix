if not isClient() then return end

local function initGlobalModData(isNewGame)
	ModData.getOrCreate("Erase_Rewind")
	if isNewGame then print("- New Game Initialized!") else print("- Existing Game Initialized!") end
end
Events.OnInitGlobalModData.Add(initGlobalModData)
