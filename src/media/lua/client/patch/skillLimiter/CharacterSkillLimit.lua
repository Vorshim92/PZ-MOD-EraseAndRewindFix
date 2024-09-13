-- PATCH SKILL LIMITER
local CharacterSkillLimit = {}
local SkillLimiter = require("SkillLimiter") or {}
---@type string
local characterMaxSkillModData = "characterMaxSkill"
local modDataManager = require("lib/ModDataManager")

function CharacterSkillLimit.readbook()
    if  modDataManager.isExists(characterMaxSkillModData) then
    --- **Check if ModData exists**
        --- **Remove ModData SkillLimiter per preparare il restore col libro**
        modDataManager.remove(characterMaxSkillModData)
        
        ---@type table
        -- leggo il backup del libro
        local characterMaxSkillTable = modDataManager.read(pageBook.Character.SKILL_LIMITER)

        -- salvo il backup dal libro nel modData di SkillLimiter
        modDataManager.save(characterMaxSkillModData, characterMaxSkillTable)
        -- e reinizializzo SkillLimiter con i nuovi dati
        SkillLimiter.initCharacter()
        
    end
end


function CharacterSkillLimit.writeBook()
    --- **Check if ModData exists**
    if modDataManager.isExists(characterMaxSkillModData) then
        modDataManager.remove(pageBook.Character.SKILL_LIMITER)
        -- se non esiste non faccio niente
    else return end

    ---@type table
    -- acquisisco i valori dal ModData di SkillLimiter
    local characterMaxSkillTable = modDataManager.read(characterMaxSkillModData)


    --- **Write ModData**
    --- li salvo nel backup del Libro
    modDataManager.save(pageBook.Character.SKILL_LIMITER, characterMaxSkillTable)
end

return CharacterSkillLimit