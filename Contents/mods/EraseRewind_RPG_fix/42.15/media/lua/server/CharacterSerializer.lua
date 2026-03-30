local CharacterSerializer = {}

--- Collect MVP character data into a plain table for JSON serialization.
--- Runs server-side in complete().
---@param character IsoPlayer
---@return table
function CharacterSerializer.collect(character)
    local data = {}

    -- TRAITS (B42: CharacterTrait objects via getCharacterTraits())
    local traitsList = {}
    local knownTraits = character:getCharacterTraits():getKnownTraits()
    for i = 0, knownTraits:size() - 1 do
        local trait = knownTraits:get(i)
        table.insert(traitsList, trait:toString()) -- "base:brave", "base:strong", etc.
    end
    data["TRAITS"] = traitsList

    -- PERK_DETAILS + PROFESSION
    local perkLines = {}
    for i = 0, Perks.getMaxIndex() - 1 do
        local perk = PerkFactory.getPerk(Perks.fromIndex(i))
        if perk and perk:getParent() and perk:getParent():getName() ~= "None" then
            local level = character:getPerkLevel(Perks.fromIndex(i))
            local xp = character:getXp():getXP(Perks.fromIndex(i))
            xp = tonumber(string.format("%.2f", xp)) or 0.0
            perkLines[perk:getId()] = {
                currentLevel = level,
                xp = xp,
            }
        end
    end
    data["PERK_DETAILS"] = perkLines
    -- B42: CharacterProfession object, serialize as "base:burglar" etc.
    data["PROFESSION"] = character:getDescriptor():getCharacterProfession():toString()

    -- MULTIPLIER
    local multiplierList = {}
    for i = 0, Perks.getMaxIndex() - 1 do
        local perk = PerkFactory.getPerk(Perks.fromIndex(i))
        if perk and perk:getParent() and perk:getParent():getName() ~= "None" then
            local mult = character:getXp():getMultiplier(Perks.fromIndex(i))
            mult = tonumber(string.format("%.2f", mult)) or 0.0
            if mult >= 0.0 then
                table.insert(multiplierList, {
                    perk = perk:getId(),
                    multiplier = mult,
                })
            end
        end
    end
    data["MULTIPLIER"] = multiplierList

    -- KILLED_ZOMBIES
    data["KILLED_ZOMBIES"] = character:getZombieKills()

    -- LIFE_TIME
    data["LIFE_TIME"] = character:getHoursSurvived()

    -- WEIGHT
    data["WEIGHT"] = character:getNutrition():getWeight()

    -- CALORIES
    data["CALORIES"] = character:getNutrition():getCalories()

    -- TODO: RECIPES - character:getKnownRecipes() / learnRecipe() - verify B42 API

    return data
end

--- Apply MVP character data onto the player.
--- Runs server-side in complete().
---@param character IsoPlayer
---@param data table
function CharacterSerializer.apply(character, data)
    -- 1. TRAITS (B42: CharacterTrait objects)
    if data["TRAITS"] then
        -- Remove all existing traits
        local currentTraits = character:getCharacterTraits():getKnownTraits()
        for i = currentTraits:size() - 1, 0, -1 do
            character:getCharacterTraits():remove(currentTraits:get(i))
        end
        -- Add traits from backup
        for _, traitString in pairs(data["TRAITS"]) do
            local trait = CharacterTrait.get(ResourceLocation.of(traitString))
            if trait then
                character:getCharacterTraits():add(trait)
            end
        end
    end

    -- 2. PERK_DETAILS - reset all perks to 0 first
    if data["PERK_DETAILS"] then
        -- Remove profession before resetting perks (B42: CharacterProfession object)
        character:getDescriptor():setCharacterProfession(CharacterProfession.UNEMPLOYED)

        -- Reset all perks to level 0
        for i = 0, Perks.getMaxIndex() - 1 do
            local perk = PerkFactory.getPerk(Perks.fromIndex(i))
            if perk and perk:getParent() and perk:getParent():getName() ~= "None" then
                local currentLevel = character:getPerkLevel(Perks.fromIndex(i))
                for _ = 1, currentLevel do
                    character:LoseLevel(Perks.fromIndex(i))
                end
                character:getXp():setXPToLevel(Perks.fromIndex(i), 0)
            end
        end

        -- Set desired levels from backup
        for perkId, perkDetail in pairs(data["PERK_DETAILS"]) do
            local perk = Perks[perkId]
            if perk then
                local desiredLevel = perkDetail.currentLevel or 0
                -- Level up to desired
                for _ = 1, desiredLevel do
                    character:LevelPerk(perk, false)
                end
                character:getXp():setXPToLevel(perk, desiredLevel)

                -- Add extra XP beyond level threshold
                local currentXp = character:getXp():getXP(perk)
                local totalXp = perkDetail.xp or 0
                local diffXp = totalXp - currentXp
                if diffXp > 0 then
                    character:getXp():AddXP(perk, diffXp, false, false, false)
                end
            end
        end

        -- B42: no explicit SyncXp needed, engine syncs automatically when XP is modified server-side
    end

    -- 3. PROFESSION (B42: CharacterProfession object from string)
    if data["PROFESSION"] then
        local prof = CharacterProfession.get(ResourceLocation.of(data["PROFESSION"]))
        if prof then
            character:getDescriptor():setCharacterProfession(prof)
        end
    end

    -- 4. MULTIPLIER
    if data["MULTIPLIER"] then
        -- Reset all multipliers
        for i = 0, Perks.getMaxIndex() - 1 do
            local perk = PerkFactory.getPerk(Perks.fromIndex(i))
            if perk and perk:getParent() and perk:getParent():getName() ~= "None" then
                character:getXp():addXpMultiplier(Perks.fromIndex(i), 0, 1, 1)
            end
        end
        -- Set from backup
        for _, v in pairs(data["MULTIPLIER"]) do
            local perk = Perks[v.perk]
            if perk then
                character:getXp():addXpMultiplier(perk, v.multiplier, 1, 1)
            end
        end
    end

    -- 5. KILLED_ZOMBIES
    if data["KILLED_ZOMBIES"] then
        character:setZombieKills(data["KILLED_ZOMBIES"])
    end

    -- 6. LIFE_TIME
    if data["LIFE_TIME"] then
        character:setHoursSurvived(data["LIFE_TIME"])
    end

    -- 7. WEIGHT
    if data["WEIGHT"] then
        character:getNutrition():setWeight(data["WEIGHT"])
    end

    -- 8. CALORIES
    if data["CALORIES"] then
        character:getNutrition():setCalories(data["CALORIES"])
    end

    -- TODO: RECIPES - restore known recipes from backup
end

return CharacterSerializer
