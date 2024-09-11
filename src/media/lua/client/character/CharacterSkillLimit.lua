local modDataManager = require("lib/ModDataManager")


-- PATCH SKILL LIMITER
local CharacterSkillLimit = {}
local SkillLimiter = {}
if getActivatedMods():contains("SkillLimiter_BETA") then
    SkillLimiter = require("SkillLimiter")
end
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

return CharacterSkillLimit