---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 07/05/23 14:59
---

---@class IsoPlayerPZ

local IsoPlayerPZ = {}

--- **Set Username**
---@param username string
function IsoPlayerPZ.setUserName(username)
    IsoPlayer.getInstance():setUsername(username)
end

--- **Get Username**
---@return string username
function IsoPlayerPZ.getUserName()
    return IsoPlayer.getInstance():getUsername()
end

--- **Set Life Time in hours**
---@param lifeTime double
--- - IsoPlayer : zombie.characters.IsoPlayer
function IsoPlayerPZ.setHoursSurvived_PZ(lifeTime)
    if not lifeTime then
        return nil
    end

    IsoPlayer.getInstance():setHoursSurvived(lifeTime)
end

--- **Get Life Time in hours**
---@return double
--- - IsoPlayer : zombie.characters.IsoPlayer
function IsoPlayerPZ.getHoursSurvived_PZ()
    return IsoPlayer.getInstance():getHoursSurvived()
end

--- **Set Weight**
---@param value double
--- - IsoPlayer : zombie.characters.BodyDamage.Nutrition
function IsoPlayerPZ.setWeight_PZ(value)
    if not value then
        return nil
    end

    IsoPlayer.getInstance():getNutrition():setWeight(value)
end

--- **Get Weight**
---@return double Weight
--- - IsoPlayer : zombie.characters.BodyDamage.Nutrition
function IsoPlayerPZ.getWeight_PZ()
    return IsoPlayer.getInstance():getNutrition():getWeight()
end

--- **Set Calories**
---@param value float
--- - IsoPlayer : zombie.characters.BodyDamage.Nutrition
function IsoPlayerPZ.setCalories_PZ(value)
    if not value then
        return nil
    end

    IsoPlayer.getInstance():getNutrition():setCalories(value)
end

--- **Get Calories**
---@return float Calories
--- - IsoPlayer : zombie.characters.BodyDamage.Nutrition
function IsoPlayerPZ.getCalories_PZ()
    return IsoPlayer.getInstance():getNutrition():getCalories()
end

return IsoPlayerPZ