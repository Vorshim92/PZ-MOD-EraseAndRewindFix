if not isClient() then return end
local pageBook = require("book/PageBook")

local function initGlobalModData(isNewGame)
	ModData.getOrCreate("Erase_Rewind")
	if isNewGame then print("- New Game Initialized!") else print("- Existing Game Initialized!") end
	-- triggerEvent("Erase_Rewind") 
end
Events.OnInitGlobalModData.Add(initGlobalModData)