-----
----- Generated by EmmyLua(https://github.com/EmmyLua)
----- Created by lele.
----- DateTime: 16/03/23 17:44
-----

---@class CharacterBaseObj

require("lib/BaseObject")
require("lib/PerkDetailsObj")
CharacterBaseObj = BaseObject:derive("CharacterBaseObj")

--- **Create a nuw CharacterBaseObj**
function CharacterBaseObj:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.profession = ""
    o.weight = ""
    o.calories = ""
    o.perkDetails_LIST = {}
    o.traits_List = {}
    o.recipes_List = {}
    return o
end

--- **Current Character**
---@param profession string
---@param perk PerkFactory.Perk
---@param level int
---@param xp float
function CharacterBaseObj:currentCharacter(profession, perk, level, xp)
    self.profession = profession

    local PerkDetailsObj01 = PerkDetailsObj:new()
    PerkDetailsObj01:addPerkDetails(perk, level, xp)
end

--- **Add Perk Details ( in to list )**
---@param perk PerkFactory.Perk
---@param level int
---@param xp double
function CharacterBaseObj:addPerkDetails(perk, level, xp)
    local PerkDetailsObj01 = PerkDetailsObj:new()
    PerkDetailsObj01:addPerkDetails(perk, level, xp)

    table.insert(self.perkDetails_LIST, PerkDetailsObj01)
end

--- **Get Perk Details**
---@return CharacterBaseObj table - PerkFactory.Perk perk, int level, float xp
function CharacterBaseObj:getPerkDetails()
    return self.perkDetails_LIST
end

--- **Add Trait**
---@param recipe string
function CharacterBaseObj:addRecipe(recipe)
    table.insert(self.recipes_List, recipe)
end

--- **Get recipes list**
---@return CharacterBaseObj table string
function CharacterBaseObj:getRecipes()
    return self.recipes_List
end

--- **Add Trait**
---@param trait String
function CharacterBaseObj:addTrait(trait)
    table.insert(self.traits_List, trait)
end

--- **Get Traits list**
---@return CharacterBaseObj table string
function CharacterBaseObj:getTraits()
    return self.traits_List
end

--- **Get object PerkDetailsObj**
---@return PerkDetailsObj
function CharacterBaseObj:getPerkDetailsObj()
    return PerkDetailsObj
end

--- **Set profession**
---@param profession string
function CharacterBaseObj:setProfession(profession)
    self.profession = profession
end

--- **Get profession**
---@return string profession
function CharacterBaseObj:getProfession()
    return self.profession
end

--- **Set calories**
---@param calories double
function CharacterBaseObj:setCalories(calories)
    self.calories = calories
end

--- **Get Calories**
---@return double
function CharacterBaseObj:getCalories()
    return self.calories
end

--- **Set Weight**
---@param weight double
function CharacterBaseObj:setWeight(weight)
    self.weight = weight
end

--- **Get Weight**
---@return double weight
function CharacterBaseObj:getWeight()
    return self.weight
end


