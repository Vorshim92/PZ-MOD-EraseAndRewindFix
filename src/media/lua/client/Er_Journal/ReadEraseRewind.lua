require "TimedActions/ISReadABook"
local characterManagement = require("CharacterManagement")
local eraseRewindJournal = "EraseRewindJournal"
--local eraseRewindJournal = "ReadOnceBookJournal"

-- inizio azione
local EROVERWRITE_ISReadABook_start = ISReadABook.start
function ISReadABook:start()
    ---@type Literature
	local journal = self.item

    if journal:getType() ~= eraseRewindJournal then
		EROVERWRITE_ISReadABook_start(self)
	end
end

-- fine azione
local EROVERWRITE_ISReadABook_perform = ISReadABook.perform
function ISReadABook:perform()
    ---@type Literature
	local journal = self.item

    if journal:getType() ~= eraseRewindJournal then
        EROVERWRITE_ISReadABook_perform(self)
    else
        -- qua load moddata
        characterManagement.readBook(getPlayer())
    end

    ISBaseTimedAction.perform(self)
end

-- init
local EROVERWRITE_ISReadABook_new = ISReadABook.new
function ISReadABook:new(character, item, time)
	local eraseRewind = EROVERWRITE_ISReadABook_new(self, character, item, time)

    if eraseRewind and character and
            item:getType() == eraseRewindJournal then


        character:playSound("OpenBook")
        character:playSound("CloseBook")

        eraseRewind.loopedAction = false
        eraseRewind.useProgressBar = false
        eraseRewind.maxTime = 80
        eraseRewind.stopOnWalk = false
    end

	return eraseRewind
end