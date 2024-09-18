-- PATCH SKILL LIMITER
local CharacterSkillLimit = {}
local SkillLimiter = require("SkillLimiter") or {}
---@type string
local characterMaxSkillModData = "characterMaxSkill"
local modDataManager = require("lib/ModDataManager")
-- local pageBook = require("book/PageBook")


function CharacterSkillLimit.readBook(modData_name)
    if  modDataManager.isExists(characterMaxSkillModData) then
    --- **Check if ModData exists**
        --- **Remove ModData SkillLimiter per preparare il restore col libro**
        modDataManager.remove(characterMaxSkillModData)
        
        ---@type table
        -- leggo il backup del libro
        local characterMaxSkillTable = modDataManager.read(modData_name.SKILL_LIMITER)

        -- salvo il backup dal libro nel modData di SkillLimiter
        modDataManager.save(characterMaxSkillModData, characterMaxSkillTable)
        -- e reinizializzo SkillLimiter con i nuovi dati
        SkillLimiter.initCharacter()
        
    else 
        local characterMaxSkillTable = modDataManager.read(modData_name.SKILL_LIMITER)

        -- salvo il backup dal libro nel modData di SkillLimiter
        modDataManager.save(characterMaxSkillModData, characterMaxSkillTable)
        -- e reinizializzo SkillLimiter con i nuovi dati
        SkillLimiter.initCharacter()

    end

end


function CharacterSkillLimit.writeBook(modData_name)
    --- **Check if ModData exists**
        modDataManager.remove(modData_name.SKILL_LIMITER)
        -- se non esiste non faccio niente

    ---@type table
    -- acquisisco i valori dal ModData di SkillLimiter
    local characterMaxSkillTable = modDataManager.read(characterMaxSkillModData)


    --- **Write ModData**
    --- li salvo nel backup del Libro
    modDataManager.save(modData_name.SKILL_LIMITER, characterMaxSkillTable)
    -- save backup on server
    -- local args = {
    --     name = modData_name.SKILL_LIMITER,
    --     data = characterMaxSkillTable
    -- }
    -- sendClientCommand(character, "Vorshim", "saveBackup", args)
    -- -- end backup on server
end

return CharacterSkillLimit