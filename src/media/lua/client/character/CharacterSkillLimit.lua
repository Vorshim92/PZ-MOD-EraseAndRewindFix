local modDataManager = require("lib/ModDataManager")


-- PATCH SKILL LIMITER
local CharacterSkillLimit = {}
local SkillLimiter = require("SkillLimiter") or {}
---@type string
local characterMaxSkillModData = "characterMaxSkill"

function CharacterSkillLimit.readbook()
if  modDataManager.isExists(characterMaxSkillModData) then
    --- **Check if ModData exists**
        --- **Remove ModData**
        modDataManager.remove(characterMaxSkillModData)
        
        SkillLimiter.initCharacter()
        
    end
end

function CharacterSkillLimit.writeBook()
    --- **Check if ModData exists**
    if modDataManager.isExists(characterMaxSkillModData) then
        modDataManager.remove(pageBook.Character.SKILL_LIMITER)
    end
end

return CharacterSkillLimit