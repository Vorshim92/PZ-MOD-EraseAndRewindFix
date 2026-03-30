if not isClient() then return end
-- quando la mod sarà ultimata lato server allora questa initModData dovrà avvenire solo in single player e non in Client Mode

local function initGlobalModData(isNewGame)
	ModData.getOrCreate("Erase_Rewind")
	if isNewGame then print("- New Game Initialized!") else print("- Existing Game Initialized!") end
end
Events.OnInitGlobalModData.Add(initGlobalModData)
