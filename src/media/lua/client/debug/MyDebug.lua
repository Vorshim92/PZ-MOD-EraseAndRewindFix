---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lele.
--- DateTime: 26/04/23 17:41
---

require("client/CharacterBoost")
require("lib/DbgLeleLib")
local characterPz = require("lib/CharacterPZ")


local function key16(character, key)
    if key == 16 then -- <<<< q
        print("Key = q > setPerkBoost_PZ) \n")

    end
end

---@param character IsoGameCharacter
local function key17(character, key)
    if key == 17 then
        print("Key = w > writeBoostToHd) \n")

    end
end

-- Perks.Cooking
-- Perks.Maintenance
-- Perks.Woodwork
-- Perks.Sprinting
-- Todo 		self.character:playSound("CloseBook")
---@param character IsoGameCharacter
local function key34(character, key)
    if key == 34 then -- <<<< g
        print("Key = g > writeBook \n")

    end
end

---@param character IsoGameCharacter
local function key35(character, key)
    if key == 35 then -- <<< h
        print("Key = h > readBook \n")

    end
end

---@param character IsoGameCharacter
local function key36(character, key)
    if key == 36 then
        print("Key = j > setZombieKills_PZ \n")
        characterPz.setZombieKills_PZ(character, 15)
    end
end

---@param character IsoGameCharacter
local function key37(character, key)
    if key == 37 then -- <<<< k
        print("Key = k > delete \n")
        character:die()
    end
end

-- https://theindiestone.com/forums/index.php?/topic/9799-key-code-reference/
local function onCustomUIKeyPressed(key)
    local character = getPlayer()

    if key == 34 then key34(character, key)  end -- <<<< g
    if key == 35 then key35(character, key)  end -- <<<< h
    if key == 36 then key36(character, key)  end -- <<<< j
    if key == 37 then key37(character, key)  end -- <<<< kill
    if key == 16 then key16(character, key)  end -- <<<< 1
    if key == 17 then key17(character, key)  end -- <<<< 2

end


-- ------------------------------------------------------------
-- ------------------------------------------------------------

local function OnGameStart()

end

-- Events.OnGameStart.Add(OnGameStart)
-- Events.OnCustomUIKeyPressed.Add(onCustomUIKeyPressed)

 function funcName()
    local player = getSpecificPlayer(0) -- ottieni il giocatore corrente
    local item = player:getInventory():FindAndReturn("nomeOggetto") -- cerca l'oggetto per nome
    if item then
        player:getInventory():Remove(item) -- rimuovi e distruggi l'oggetto
    end

end

 function funcName2()
     local player = getSpecificPlayer(0)
     local inv = player:getInventory()
     ---@type InventoryItem
     local item = inv:getFirstTypeRecurse("BookFarming1")

     ---@type Literature
    local book = item -- self.item -- assuming self.item is set to the "fishing rod" item
    local lvlSkillTrained = book:getLvlSkillTrained()
    local maxLevelTrained = book:getMaxLevelTrained()
    local category = book:getCategory()
    local skillTrained = book:getSkillTrained()

    print("Mininum Level - ", lvlSkillTrained)
    print("Maximum level - ", maxLevelTrained)
    print("category - ", category)
    print("skillTrained - ", skillTrained)
end

function funcName3()
    -- Farming Vol. 1
    local player = getSpecificPlayer(0)
    ---@type InventoryItem
    local inv = player:getInventory()
    ---@type Item
    local items = inv:getItems()

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local name = item:getType() -- :getName()
        local count = item:getCount()
        print(name .. " - " .. count)
    end
end

 function funcName4()
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
     ---@type InventoryItem
    local book = inv:getFirstTypeRecurse("BookFarming1")

    if book then
        ---@type InventoryItem
        local stats = book:getStats()
        --print("Boost XP: " .. stats:boostXP)
        --print("Boost skill: " .. stats.boostSkill)
    end
end
 function funcName5()
     local lista = getCell():getInventory()

     local dbg
     for i, v in pairs(lista) do
         print(lista)
     end


         -- Now you can use the literatureList table to do whatever you need with the literature items


         --for i = 0, getCell():getInventory():size() - 1 do
         --    local item = getCell():getInventory():getItems():get(i)
         --    if instanceof(item, "Literature") then
         --        table.insert(literatureList, item)
         --    end
         --end

         -- Now you can use the literatureList table to do whatever you need with the literature items


         -- Now you can use the literatureList table to do whatever you need with the literature items

 end

function funcName6()
    local itemsList = {}

    -- Get the player's inventory
    local inventory = getPlayer():getInventory()

    -- Loop through each item in the inventory
    for i = 0, inventory:getItems():size() - 1 do
        local item = inventory:getItems():get(i)
        -- Check if the item is not null
        if item then
            -- Add the item to the itemsList table
           print(item)
        end
    end

end

function funcName7()
    local literatureList = {}

    for x = 0, getWorld():getMap():getWidth() - 1 do
        for y = 0, getWorld():getMap():getHeight() - 1 do
            local square = getWorld():getCell():getGridSquare(x, y, 0)
            if square ~= nil then
                local inventory = square:getInventory()
                for i = 0, inventory:size() - 1 do
                    local item = inventory:getItems():get(i)
                    if instanceof(item, "Literature") then
                        print(item)
                    end
                end
            end
        end
    end
end