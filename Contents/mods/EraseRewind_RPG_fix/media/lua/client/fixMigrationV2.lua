    -- fix migration to new version
    local modDataManager = require("lib/ModDataManager")
    local pageBook = require("book/PageBook")
    -- vecchie chiavi per per i libri
    -- Vecchie chiavi per i libri

    -- Function to split a string by a separator (handles UTF-8 properly)
    local function splitString(str, sep)
        local t = {}
        local pattern = string.format("([^%s]+)", sep)
        for s in str:gmatch(pattern) do
            table.insert(t, s)
        end
        return t
    end

    -- se esiste un vecchio backup verrà spostato nel nuovo readOnceBook (per questioni pratiche meglio rispetto al timed che ha la variabile del tempo)
    local function migrateOldBackups()
        local flag = false
        
        -- faccio prima un check veloce sull'esistenza di quella chiavi vecchie
        -- se esiste una chiave vecchia allora conviene cominciare il trasferimento 
        local oldKeys = {
            BOOST = "characterBoost",
            CALORIES = "characterCalories",
            LIFE_TIME = "characterLifeTime",
            MULTIPLIER = "characterMultiplier",
            PERK_DETAILS = "characterPerkDetails",
            PROFESSION = "characterProfession",
            RECIPES = "characterRecipes",
            TRAITS = "characterTraits",
            READ_ONCE_BOOK = "readOnceBook",
            TIMED_BOOK = "timedBook",
            WEIGHT = "characterWeight",
            KILLED_ZOMBIES = "characterKilledZombies",
            SKILL_LIMITER = "characterSkillLimiter",
            kilMilReached = "kilMilReachedX",
            milReached = "milReachedX"
        }

        -- per eventuali errori nel vecchiop backup poiché veniva salvato il perk come userdata che non veniva salvata effettivamente e quindi "perk" nella tabella potrebbe non esistere, ma essendo indicizzata e avendo un ordine prestabilito per ora hardcodiamo il tutto.
        local skills = {
            "None",
            "Agilit" .. string.char(224),
            "Cucinare",
            "Melee",
            "Artigianato",
            "Forma fisica",
            "Forza",
            "Contundente",
            "Ascia",
            "Corsa",
            "Passo leggero",
            "Destrezza",
            "Furtivit" .. string.char(224),
            "Carpenteria",
            "Mira",
            "Ricarica",
            "Coltivazione",
            "Sopravvivenza",
            "Pesca",
            "Costruire Trappole",
            "Passivo",
            "Armi da fuoco",
            "Cercare Cibo",
            "Pronto Soccorso",
            "Elettrica",
            "Blacksmith",
            "Lavorazione metalli",
            "Melting",
            "Meccanica",
            "Lancia",
            "Manutenzione",
            "Lama corta",
            "Lama lunga",
            "Contundente corto",
            "Combattimento",
            "Sartoria"
        }
        
        
        -- Nuove chiavi per ReadOnceBook, nell'ordine corrispondente
        local newKeys = pageBook.ReadOnceBook

        if modDataManager.isExists(oldKeys["BOOST"]) then
            local old = modDataManager.read(oldKeys["BOOST"])
            local lines_ = {}
            if old then
                for i, v in ipairs(old) do
                    local perk = PerkFactory.getPerkFromName(v.perk) or Perks[v.perk] or PerkFactory.getPerk(Perks[v.perk]) or PerkFactory.getPerk(v.perk)
                    if not perk then
                        perk = PerkFactory.getPerk(Perks.fromIndex(i)) or PerkFactory.getPerkFromName(skills[i])
                    end
                    if perk:getParent():getName() ~= "None" then
                        local line = {
                            perk = perk:getId(),
                            xpBoost = tonumber(v.xpBoost)
                        }
                        table.insert(lines_, line)
                    end
                end
                flag = true
                newKeys["BOOST"] = lines_
            end
            modDataManager.remove(oldKeys["BOOST"])
        end

        if modDataManager.isExists(oldKeys["CALORIES"]) then
            local old = modDataManager.read(oldKeys["CALORIES"])
            if old then
                newKeys["CALORIES"] = tonumber(old[1])
                flag = true
            end
            modDataManager.remove(oldKeys["CALORIES"])
        end

        if modDataManager.isExists(oldKeys["LIFE_TIME"]) then
            local old = modDataManager.read(oldKeys["LIFE_TIME"])
            if old then
                newKeys["LIFE_TIME"] = tonumber(old[1])
                flag = true
            end
            modDataManager.remove(oldKeys["LIFE_TIME"])
        end

        if modDataManager.isExists(oldKeys["MULTIPLIER"]) then
            local old = modDataManager.read(oldKeys["MULTIPLIER"])
            local lines_ = {}
            if old then
                for i, v in ipairs(old) do
                    local perk = PerkFactory.getPerkFromName(v.perk) or Perks[v.perk] or PerkFactory.getPerk(Perks[v.perk]) or PerkFactory.getPerk(v.perk)
                    if not perk then
                        perk = PerkFactory.getPerk(Perks.fromIndex(i)) or PerkFactory.getPerkFromName(skills[i])
                    end
                    if perk:getParent():getName() ~= "None" then
                                 
                        local line = {
                            perk = perk:getId(),
                            multiplier = tonumber(v.multiplier)
                        }
                        table.insert(lines_, line)
                    end
                end
                flag = true
                newKeys["MULTIPLIER"] = lines_
            end
            modDataManager.remove(oldKeys["MULTIPLIER"])
        end

        if modDataManager.isExists(oldKeys["PERK_DETAILS"]) then
            local old = modDataManager.read(oldKeys["PERK_DETAILS"])
            local perkLines = {}
            if old then
                for _, v in pairs(old) do
                    local components = splitString(v, "-")
                    if #components == 3 then
                        local perkName = components[1]
                        local currentLevel = components[2]
                        local xp = components[3]
                    
                        local perk = PerkFactory.getPerkFromName(perkName) or Perks[perkName]
                        if perk:getParent():getName() ~= "None" then

                            perkLines[perk:getId()] = {
                                currentLevel = tonumber(currentLevel),
                                xp = tonumber(xp),
                            }
                        end
                    end
                end
                flag = true
                newKeys["PERK_DETAILS"] = perkLines
            end
            modDataManager.remove(oldKeys["PERK_DETAILS"])
        end


        if modDataManager.isExists(oldKeys["PROFESSION"]) then
            local old = modDataManager.read(oldKeys["PROFESSION"])
            if old then
                newKeys["PROFESSION"] = old[1]
                flag = true
            end
            modDataManager.remove(oldKeys["PROFESSION"])
        end


        if modDataManager.isExists(oldKeys["RECIPES"]) then
            local old = modDataManager.read(oldKeys["RECIPES"])
            if old then
                newKeys["RECIPES"] = old
                flag = true
            end
            modDataManager.remove(oldKeys["RECIPES"])
        end


        if modDataManager.isExists(oldKeys["TRAITS"]) then
            local old = modDataManager.read(oldKeys["TRAITS"])
            if old then
                newKeys["TRAITS"] = old
                flag = true
            end
            modDataManager.remove(oldKeys["TRAITS"])
        end


        if modDataManager.isExists(oldKeys["WEIGHT"]) then
            local old = modDataManager.read(oldKeys["WEIGHT"])
            if old then
                newKeys["WEIGHT"] = tonumber(old)
                flag = true
            end
            modDataManager.remove(oldKeys["WEIGHT"])
        end


        if modDataManager.isExists(oldKeys["KILLED_ZOMBIES"]) then
            local old = modDataManager.read(oldKeys["KILLED_ZOMBIES"])
            if old then
                newKeys["KILLED_ZOMBIES"] = tonumber(old)
                flag = true
            end
            modDataManager.remove(oldKeys["KILLED_ZOMBIES"])
        end


        if modDataManager.isExists(oldKeys["SKILL_LIMITER"]) then
            local old = modDataManager.read(oldKeys["SKILL_LIMITER"])
            local perkLines = {}
            if old then
                for _, v in pairs(old) do
                    local components = splitString(v, "-")
                    if #components == 4 then
                        local perkName = components[1]
                        local currentLevel = components[2]
                        local maxLevel = components[3]
                        local xp = components[4]
                    
                        local perk = PerkFactory.getPerkFromName(perkName) or Perks[perkName]
                        if perk:getParent():getName() ~= "None" then

                            perkLines[perk:getId()] = {
                                currentLevel = tonumber(currentLevel),
                                maxLevel = tonumber(maxLevel),
                                xp = tonumber(xp),
                            }
                        end
                    end
                end
                newKeys["SKILL_LIMITER"] = perkLines
                flag = true
            end
            modDataManager.remove(oldKeys["SKILL_LIMITER"])
        end

        if modDataManager.isExists(oldKeys["kilMilReached"]) then
            local old = modDataManager.read(oldKeys["kilMilReached"])
            if old then
                newKeys["kilMilReached"] = tonumber(old)
                flag = true
            end
            modDataManager.remove(oldKeys["kilMilReached"])
        end


        if modDataManager.isExists(oldKeys["milReached"]) then
            local old = modDataManager.read(oldKeys["milReached"])
            if old then
                newKeys["milReached"] = tonumber(old)
                flag = true
            end
            modDataManager.remove(oldKeys["milReached"])
        end
        
        -- si resetta il TIMED per sicurezza
        if modDataManager.isExists(pageBook.TIMED_BOOK) then
            modDataManager.remove(pageBook.TIMED_BOOK)
            print("Rimosso TIMED_BOOK")
        end
        if flag then

            -- se esiste cancelliamo il libro readOnce
            if modDataManager.isExists(pageBook.READ_ONCE_BOOK) then
                modDataManager.remove(pageBook.READ_ONCE_BOOK)
                print("Rimosso READ_ONCE_BOOK")
            end
            -- creo la flag del nuovo libro readOnce
            local backup = {}
            local bookType = "READ_ONCE_BOOK"    -- BKP_MOD_1, BKP_MOD_2, READ_ONCE_BOOK, TIMED_BOOK
            backup["ReadOnceBook"] = newKeys -- BKP_1, BKP_2, ReadOnceBook, TimedBook

            sendClientCommand(getPlayer(), "Vorshim", "saveBackup", {backup = backup, bookType = bookType})
            print("BackupMigration per ReadOnceBook inviato con successo!")
        else 
            print("Nessun vecchio backup trovato. Migrazione non necessaria.")
        end
end


local tickDelay = 100
local function CreateDelay()
    if tickDelay == 0 then
        migrateOldBackups()
    Events.OnTick.Remove(CreateDelay)
    return
    end
    tickDelay = tickDelay - 1
end

local function onMigrateOldBackups(playerIndex, player)
    Events.OnTick.Add(CreateDelay)
end

Events.OnCreatePlayer.Add(onMigrateOldBackups)