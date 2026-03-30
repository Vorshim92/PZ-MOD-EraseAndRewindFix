-- PATCH SKILL LIMITER
local CharacterSkillLimit = {}
local SkillLimiter = require("SkillLimiter") or {}
---@type string
local modDataManager = require("lib/ModDataManager")
-- local pageBook = require("book/PageBook")


function CharacterSkillLimit.readBook(modData_Table)
    if getPlayer():getModData().skillLimiter then
    --- **Check if ModData exists**
        --- **Remove ModData SkillLimiter per preparare il restore col libro**
        getPlayer():getModData().skillLimiter = nil 
        
        ---@type table
        -- leggo il backup del libro
        local characterMaxSkillTable = modData_Table["SKILL_LIMITER"]

        -- salvo il backup dal libro nel modData di SkillLimiter
        getPlayer():getModData().skillLimiter = characterMaxSkillTable
        -- e reinizializzo SkillLimiter con i nuovi dati
        SkillLimiter.initCharacter()
        
    else 
        local characterMaxSkillTable = modData_Table["SKILL_LIMITER"]

        -- salvo il backup dal libro nel modData di SkillLimiter
        getPlayer():getModData().skillLimiter = characterMaxSkillTable
        -- e reinizializzo SkillLimiter con i nuovi dati
        SkillLimiter.initCharacter()

    end

end


function CharacterSkillLimit.writeBook(modData_table)
    --- **Check if ModData exists**
        -- modDataManager.remove(modData_table.SKILL_LIMITER)
        -- se non esiste non faccio niente

    ---@type table
    -- acquisisco i valori dal ModData di SkillLimiter
    if modData_table then
        if getPlayer():getModData().skillLimiter then
            local characterMaxSkillTable = getPlayer():getModData().skillLimiter
            modData_table["SKILL_LIMITER"] = characterMaxSkillTable
        end
    end
end

return CharacterSkillLimit