repeat task.wait() until game:IsLoaded()
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer       = Players.LocalPlayer
local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local Abilities         = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Abilities"))
local EnemyData         = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Enemies"))
local Effects           = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Effects"))
local Items             = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Items"))
local TurnDecision = Remotes:WaitForChild("TurnDecision")
local FireTurn     = Remotes:WaitForChild("FireTurn")
local GetAbilities = Remotes:WaitForChild("GetAbilities")
local AttackFlash  = Remotes:WaitForChild("AttackFlash")
local CombatEnd    = Remotes:WaitForChild("CombatEnd")
local ChangeUI     = Remotes:WaitForChild("ChangeUI")
local ReplayEvent  = Remotes:WaitForChild("ReplayEvent")
local VotingEvent  = Remotes:WaitForChild("VotingEvent")
local GetItems     = Remotes:WaitForChild("GetItems")
local UpdateTurn   = Remotes:WaitForChild("UpdateTurn")
local BOT_ENABLED            = true
local USE_ABILITIES          = true
local BLOCK_COST_THRESHOLD   = 2
local ENERGY_MARGIN          = 1
local KILL_EPSILON           = 0.01
local HP_USE_THRESHOLD       = 0.40
local BOSS_HP_MULTIPLIER     = 1
local BLOCK_DANGER_THRESHOLD = 0.15
local function isBuffEffect(effectName)
    local e = Effects[effectName]
    if not e then return false end
    if e["Type"] == "DoT" or e["Type"] == "HoT" then return false end
    if e["DamageValue"] and e["DamageValue"] > 1 then return true end
    if e["Value"]       and e["Value"] > 1       then return true end
    if e["ScalingValue"]and e["ScalingValue"] > 0 then return true end
    return false
end
local function isHoTEffect(effectName)
    local e = Effects[effectName]
    return e and e["Type"] == "HoT"
end
local function isDoTEffect(effectName)
    local e = Effects[effectName]
    return e and e["Type"] == "DoT"
end
local currentHighlight = nil   
local isSummonTurn     = false
local summonReference  = nil
local summonCooldowns  = {}
local latestSummonData = nil
local playerCooldowns  = {}
local enemyCooldowns   = {}
local latestPlayerData = nil
local combatInventory  = {}
local buffUsedThisFight = false
task.spawn(function()
    if not LocalPlayer:GetAttribute("isLoaded") then
        LocalPlayer:GetAttributeChangedSignal("isLoaded"):Wait()
    end
    task.wait(0.3)
    VotingEvent:FireServer("Start Game")
end)
ChangeUI.OnClientEvent:Connect(function(p19)
    if p19 == "GameOver" or p19 == "Win" then
        task.wait(1)
        ReplayEvent:FireServer()
        task.spawn(function()
            if not LocalPlayer:GetAttribute("isLoaded") then
                LocalPlayer:GetAttributeChangedSignal("isLoaded"):Wait()
            end
            task.wait(0.3)
            VotingEvent:FireServer("Start Game")
        end)
    end
end)
GetItems.OnClientEvent:Connect(function(p238)
    combatInventory = {}
    local inv = p238[LocalPlayer.Name] and p238[LocalPlayer.Name].Inventory
    if not inv then return end
    for _, item in pairs(inv) do
        if item.Slot == "Consumable" and (item.Amount or 0) > 0 then
            combatInventory[item.Name] = item.Amount
        end
    end
end)
CombatEnd.OnClientEvent:Connect(function()
    enemyCooldowns   = {}
    buffUsedThisFight = false
    isSummonTurn     = false
    summonReference  = nil
    currentHighlight = nil
end)
UpdateTurn.OnClientEvent:Connect(function(action, name)
    if action == "Highlight" then
        currentHighlight = name
    end
end)
FireTurn.OnClientEvent:Connect(function(_, p294, p295)
    if p295 then
        isSummonTurn    = true
        summonReference = p295.Reference
        summonCooldowns = p294 or {}
    else
        isSummonTurn    = false
        summonReference = nil
        playerCooldowns = p294 or {}
        for abilityName, turns in pairs(enemyCooldowns) do
            enemyCooldowns[abilityName] = turns - 1
            if enemyCooldowns[abilityName] <= 0 then
                enemyCooldowns[abilityName] = nil
            end
        end
    end
end)
GetAbilities.OnClientEvent:Connect(function(p236, p237)
    if p237 then
        latestSummonData = p236
    else
        latestPlayerData = p236[LocalPlayer.Name]
    end
end)
AttackFlash.OnClientEvent:Connect(function(p239)
    local data = Abilities[p239]
    if data and data.Cost and data.Cost >= BLOCK_COST_THRESHOLD then
        if data.Effects and data.Effects["Heal"] then return end
        local cooldown = data.Cooldown or 0
        if cooldown > 0 then
            enemyCooldowns[p239] = cooldown
        end
    end
end)
local function getOurSummon()
    for _, s in ipairs(workspace.Summons:GetChildren()) do
        if s:GetAttribute("isAlive") then
            if s:GetAttribute("Summoner") == LocalPlayer.Name then
                return s
            end
        end
    end
    return nil
end
local function countAliveAllies()
    local count = 0
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p:GetAttribute("isAlive") then
            count = count + 1
        end
    end
    for _, s in ipairs(workspace.Summons:GetChildren()) do
        if s:GetAttribute("isAlive") and s:GetAttribute("Summoner") == LocalPlayer.Name then
            count = count + 1
        end
    end
    return math.max(count, 1)
end
local function isSummonTurnActive()
    if currentHighlight then
        for _, s in ipairs(workspace.Summons:GetChildren()) do
            local alive    = s:GetAttribute("isAlive")
            local summoner = s:GetAttribute("Summoner")
            local expected = s.Name .. "_" .. LocalPlayer.Name
            if alive and summoner == LocalPlayer.Name then
                if currentHighlight == expected then
                    summonReference = s
                    return true
                end
            end
        end
    end
    if isSummonTurn then
        return true
    end
    return false
end
local function getActiveDamageMultiplier()
    local mult = 1.0
    for effectName, e in pairs(Effects) do
        if LocalPlayer:GetAttribute(effectName) then
            if e["DamageValue"] and e["DamageValue"] > 1 then
                mult = mult * e["DamageValue"]
            elseif e["Value"] and e["Value"] > 1 and not e["DamageValue"] then
                mult = mult * e["Value"]
            end
        end
    end
    return mult
end
local function estimateDamage(data, applyBuffs)
    local base      = data.Damage or 0
    local scaling   = data.Scaling or {}
    local multihit  = data.Multihit or 1
    local statBonus = 0
    for statName, multiplier in pairs(scaling) do
        statBonus = statBonus + ((LocalPlayer:GetAttribute(statName) or 0) * multiplier)
    end
    local raw = (base + statBonus) * multihit
    if applyBuffs then raw = raw * getActiveDamageMultiplier() end
    return raw
end
local function estimateHeal(data)
    local maxHp     = LocalPlayer:GetAttribute("MaxHP") or 1
    local effects   = data.Effects or {}
    local flat      = effects["Heal"] or 0
    local maxHealPc = effects["MaxHeal"] or 0
    local fromMaxHp = maxHp * maxHealPc
    local scaling   = data.Scaling or {}
    local statBonus = 0
    for statName, multiplier in pairs(scaling) do
        statBonus = statBonus + ((LocalPlayer:GetAttribute(statName) or 0) * multiplier)
    end
    return flat + fromMaxHp + statBonus
end
local function estimateDoTDamage(effectName)
    local e = Effects[effectName]
    if not e or e["Type"] ~= "DoT" then return 0 end
    if e["Formula"] then
        local ok, result = pcall(e["Formula"], LocalPlayer)
        if ok and type(result) == "number" then return result end
    end
    return 1  
end
local function isBossFight()
    local ourMaxHp = LocalPlayer:GetAttribute("MaxHP") or 1
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy:GetAttribute("isAlive") then
            if (enemy:GetAttribute("MaxHP") or 0) >= ourMaxHp * BOSS_HP_MULTIPLIER then
                return true
            end
        end
    end
    return false
end
local function findConsumable(mode)
    local bestName  = nil
    local bestValue = -1
    for itemName, _ in pairs(combatInventory) do
        local data = Items[itemName]
        if data and data.Slot == "Consumable" and not data.CampConsumable then
            local effects = data.Effects or {}
            local hasHeal = effects["Heal"] ~= nil
            if mode == "heal" and hasHeal then
                local healVal = effects["Heal"] or 0
                if healVal > bestValue then
                    bestValue = healVal
                    bestName  = itemName
                end
            elseif mode == "buff" and not hasHeal then
                bestName = itemName
                break
            end
        end
    end
    return bestName
end
local function getConsumableToUse()
    local hp    = LocalPlayer:GetAttribute("HP")    or 1
    local maxHp = LocalPlayer:GetAttribute("MaxHP") or 1
    if hp / maxHp < HP_USE_THRESHOLD then
        local item = findConsumable("heal")
        if item then return item end
    end
    if not buffUsedThisFight and isBossFight() then
        local item = findConsumable("buff")
        if item then
            buffUsedThisFight = true
            return item
        end
    end
    return nil
end
local function shouldBlock()
    local ourMaxHp = LocalPlayer:GetAttribute("MaxHP") or 1
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy:GetAttribute("isAlive") then
            local enemyDef    = EnemyData[enemy.Name]
            local enemyEnergy = enemy:GetAttribute("Energy") or 0
            if enemyDef and enemyDef.Abilities then
                for _, abilityName in ipairs(enemyDef.Abilities) do
                    local data = Abilities[abilityName]
                    if data and data.Cost and data.Cost >= BLOCK_COST_THRESHOLD then
                        if data.Effects and data.Effects["Heal"] then continue end
                        if not enemyCooldowns[abilityName] then
                            if enemyEnergy >= data.Cost - ENERGY_MARGIN then
                                local threatDmg = data.Damage or 0
                                if threatDmg > ourMaxHp * BLOCK_DANGER_THRESHOLD then
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end
local function getThreatScore(enemy)
    local hp    = enemy:GetAttribute("HP")    or 1
    local maxHp = enemy:GetAttribute("MaxHP") or 1
    local hpRatio     = hp / maxHp
    local finishBonus = (hpRatio < 0.3) and 50 or 0
    local baseScore   = (1 - hpRatio) * 100 + finishBonus
    local enemyDef  = EnemyData[enemy.Name]
    local ourMaxHp  = LocalPlayer:GetAttribute("MaxHP") or 1
    local totalDmg  = 0
    local abilCount = 0
    if enemyDef and enemyDef.Abilities then
        for _, abilityName in ipairs(enemyDef.Abilities) do
            local data = Abilities[abilityName]
            if data then
                local dmg = data.Damage or 0
                if data.Effects then
                    for effectName, _ in pairs(data.Effects) do
                        dmg = dmg + estimateDoTDamage(effectName)
                    end
                end
                totalDmg  = totalDmg + dmg
                abilCount = abilCount + 1
            end
        end
    end
    if abilCount > 0 then
        local avgDmg = totalDmg / abilCount
        baseScore = baseScore + (avgDmg / ourMaxHp) * 100
    end
    return baseScore
end
local function getBestTarget()
    local best      = nil
    local bestScore = -math.huge
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy:GetAttribute("isAlive") then
            local score = getThreatScore(enemy)
            if score > bestScore then
                bestScore = score
                best      = enemy
            end
        end
    end
    return best
end
local function canKill(enemy, abilityData)
    return estimateDamage(abilityData, true) >= (enemy:GetAttribute("HP") or math.huge) - KILL_EPSILON
end
local function getKillShot()
    local energy    = LocalPlayer:GetAttribute("Energy") or 0
    local abilities = latestPlayerData and latestPlayerData.Abilities or {}
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data then
            local cost = data.Cost == "X" and energy or data.Cost
            local onCooldown  = (playerCooldowns[abilityName] or 0) > 0
            local canAfford   = cost <= energy
            local targetType  = data.TargetType or ""
            local isOffensive = (targetType == "SingleEnemy" or targetType == "AllEnemy")
            if isOffensive and canAfford and not onCooldown then
                for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                    if enemy:GetAttribute("isAlive") and canKill(enemy, data) then
                        return abilityName, enemy
                    end
                end
            end
        end
    end
    return nil, nil
end
local function getBestAbility()
    local energy     = LocalPlayer:GetAttribute("Energy") or 0
    local best       = nil
    local bestDamage = -1
    local abilities  = latestPlayerData and latestPlayerData.Abilities or {}
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data then
            local cost = data.Cost == "X" and energy or data.Cost
            local onCooldown  = (playerCooldowns[abilityName] or 0) > 0
            local canAfford   = cost <= energy
            local targetType  = data.TargetType or ""
            local isOffensive = (targetType == "SingleEnemy" or targetType == "AllEnemy")
            if isOffensive and canAfford and not onCooldown then
                local dmg = estimateDamage(data, true)
                if dmg > bestDamage then
                    bestDamage = dmg
                    best       = abilityName
                end
            end
        end
    end
    return best
end
local function getBestBuffAbility()
    local energy    = LocalPlayer:GetAttribute("Energy") or 0
    local abilities = latestPlayerData and latestPlayerData.Abilities or {}
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data and (data.TargetType == "Self" or data.TargetType == "SingleAlly") then
            local cost = data.Cost == "X" and energy or (data.Cost or 0)
            if cost <= energy and (playerCooldowns[abilityName] or 0) == 0 then
                local effects = data.Effects or {}
                if effects["Heal"] then continue end  
                for effectName, _ in pairs(effects) do
                    if isBuffEffect(effectName) or isHoTEffect(effectName) then
                        if not LocalPlayer:GetAttribute(effectName) then
                            return abilityName
                        end
                    end
                end
            end
        end
    end
    return nil
end
local function getSummonAbility()
    local energy    = LocalPlayer:GetAttribute("Energy") or 0
    local abilities = latestPlayerData and latestPlayerData.Abilities or {}
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data and data.TargetType == "Summon" then
            local cost = data.Cost == "X" and energy or (data.Cost or 0)
            if cost <= energy and (playerCooldowns[abilityName] or 0) == 0 then
                return abilityName
            end
        end
    end
    return nil
end
local function getHealAbility()
    local hp    = LocalPlayer:GetAttribute("HP")    or 1
    local maxHp = LocalPlayer:GetAttribute("MaxHP") or 1
    if hp >= maxHp then return nil end
    local missing   = maxHp - hp
    local energy    = LocalPlayer:GetAttribute("Energy") or 0
    local abilities = latestPlayerData and latestPlayerData.Abilities or {}
    local bestAbility = nil
    local bestScore   = -1
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data then
            local targetType = data.TargetType or ""
            local isHealTarget = (targetType == "Self" or targetType == "SingleAlly" or targetType == "AllAlly")
            local effects  = data.Effects or {}
            local hasHeal  = effects["Heal"] ~= nil
            local hasBuff  = false
            for effectName in pairs(effects) do
                if isBuffEffect(effectName) then hasBuff = true break end
            end
            if isHealTarget and hasHeal and not hasBuff then
                local cost = data.Cost == "X" and energy or (data.Cost or 0)
                if cost <= energy and (playerCooldowns[abilityName] or 0) == 0 then
                    local healVal = estimateHeal(data)
                    local totalHeal = (targetType == "AllAlly") and (healVal * countAliveAllies()) or healVal
                    if totalHeal > 0 and missing > 0 and (hp + healVal) <= maxHp - 1 then
                        if totalHeal > bestScore then
                            bestScore   = totalHeal
                            bestAbility = abilityName
                        end
                    end
                end
            end
        end
    end
    return bestAbility
end
local function getBuffHealAbility()
    local hp    = LocalPlayer:GetAttribute("HP")    or 1
    local maxHp = LocalPlayer:GetAttribute("MaxHP") or 1
    if hp >= maxHp then return nil end
    local energy    = LocalPlayer:GetAttribute("Energy") or 0
    local abilities = latestPlayerData and latestPlayerData.Abilities or {}
    local bestAbility = nil
    local bestScore   = -1
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data then
            local targetType = data.TargetType or ""
            local isHealTarget = (targetType == "Self" or targetType == "SingleAlly" or targetType == "AllAlly")
            local effects  = data.Effects or {}
            local hasHeal  = effects["Heal"] ~= nil
            local hasHoT   = false
            local hasBuff  = false
            for effectName in pairs(effects) do
                if isHoTEffect(effectName) then hasHoT = true end
                if isBuffEffect(effectName) then hasBuff = true end
            end
            if isHealTarget and (hasHeal or hasHoT) and hasBuff then
                local cost = data.Cost == "X" and energy or (data.Cost or 0)
                if cost <= energy and (playerCooldowns[abilityName] or 0) == 0 then
                    if hasHeal then
                        local healVal   = estimateHeal(data)
                        local totalHeal = (targetType == "AllAlly") and (healVal * countAliveAllies()) or healVal
                        if totalHeal > 0 and (hp + healVal) <= maxHp - 1 then
                            if totalHeal > bestScore then
                                bestScore   = totalHeal
                                bestAbility = abilityName
                            end
                        end
                    else
                        if 1 > bestScore then
                            bestScore   = 1
                            bestAbility = abilityName
                        end
                    end
                end
            end
        end
    end
    return bestAbility
end
local function isWaitingForEnergy(checkerFn)
    local energy    = LocalPlayer:GetAttribute("Energy") or 0
    local abilities = latestPlayerData and latestPlayerData.Abilities or {}
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data then
            local cost       = data.Cost == "X" and energy or (data.Cost or 0)
            local onCooldown = (playerCooldowns[abilityName] or 0) > 0
            if not onCooldown and cost > energy then
                if checkerFn(abilityName, data) then return true end
            end
        end
    end
    return false
end
local function isSummonAbility(_, data)
    return data.TargetType == "Summon"
end
local function isHealAbilityCheck(_, data)
    local hp    = LocalPlayer:GetAttribute("HP") or 1
    local maxHp = LocalPlayer:GetAttribute("MaxHP") or 1
    if hp >= maxHp then return false end
    local effects    = data.Effects or {}
    local hasHeal    = effects["Heal"] ~= nil
    local hasBuff    = false
    for effectName in pairs(effects) do
        if isBuffEffect(effectName) then hasBuff = true break end
    end
    local targetType = data.TargetType or ""
    return (targetType == "Self" or targetType == "SingleAlly") and hasHeal and not hasBuff
end
local function isBuffHealAbilityCheck(_, data)
    local hp    = LocalPlayer:GetAttribute("HP") or 1
    local maxHp = LocalPlayer:GetAttribute("MaxHP") or 1
    if hp >= maxHp then return false end
    local effects = data.Effects or {}
    local hasHeal = effects["Heal"] ~= nil
    local hasHoT  = false
    local hasBuff = false
    for effectName in pairs(effects) do
        if isHoTEffect(effectName) then hasHoT = true end
        if isBuffEffect(effectName) then hasBuff = true end
    end
    local targetType = data.TargetType or ""
    return (targetType == "Self" or targetType == "SingleAlly") and (hasHeal or hasHoT) and hasBuff
end
local function isBuffAbilityCheck(_, data)
    if data.TargetType ~= "Self" and data.TargetType ~= "SingleAlly" then return false end
    local effects = data.Effects or {}
    if effects["Heal"] then return false end
    for effectName in pairs(effects) do
        if (isBuffEffect(effectName) or isHoTEffect(effectName)) and not LocalPlayer:GetAttribute(effectName) then
            return true
        end
    end
    return false
end
local function takeTurn()
    if not BOT_ENABLED then return end
    if not LocalPlayer:GetAttribute("Turn") then return end
    task.wait(0.1)
    if not LocalPlayer:GetAttribute("Turn") then return end
    local saveEnergy = false
    if USE_ABILITIES then
        local killAbility, killTarget = getKillShot()
        if killAbility and killTarget then
            TurnDecision:FireServer("Ability", killTarget, killAbility, false)
            return
        end
        local summonAbility = getSummonAbility()
        if summonAbility then
            TurnDecision:FireServer("Ability", LocalPlayer, summonAbility, false)
            return
        end
        if isWaitingForEnergy(isSummonAbility) then saveEnergy = true end
        if not saveEnergy then
            local buffHealAbility = getBuffHealAbility()
            if buffHealAbility then
                TurnDecision:FireServer("Ability", LocalPlayer, buffHealAbility, false)
                return
            end
            if isWaitingForEnergy(isBuffHealAbilityCheck) then saveEnergy = true end
        end
        if not saveEnergy then
            local healAbility = getHealAbility()
            if healAbility then
                TurnDecision:FireServer("Ability", LocalPlayer, healAbility, false)
                return
            end
            if isWaitingForEnergy(isHealAbilityCheck) then saveEnergy = true end
        end
        if not saveEnergy then
            local buffAbility = getBestBuffAbility()
            if buffAbility then
                TurnDecision:FireServer("Ability", LocalPlayer, buffAbility, false)
                return
            end
            if isWaitingForEnergy(isBuffAbilityCheck) then saveEnergy = true end
        end
    end
    local consumable = getConsumableToUse()
    if consumable then
        TurnDecision:FireServer("Item", LocalPlayer, consumable, false)
        return
    end
    if shouldBlock() then
        TurnDecision:FireServer("Ability", LocalPlayer, "Guard", false)
        return
    end
    if USE_ABILITIES then
        local target = getBestTarget()
        if not target then
            return
        end
        local abilityName = getBestAbility()
        if abilityName then
            local data = Abilities[abilityName]
            local cost = data and (data.Cost == "X" and (LocalPlayer:GetAttribute("Energy") or 0) or (data.Cost or 0)) or 0
            if cost == 0 or not saveEnergy then
                TurnDecision:FireServer("Ability", target, abilityName, false)
                return
            end
        end
    end
end
local function takeSummonTurn()
    if not BOT_ENABLED then return end
    if not LocalPlayer:GetAttribute("Turn") then return end
    task.wait(0.1)
    if not LocalPlayer:GetAttribute("Turn") then return end
    local summon = summonReference or getOurSummon()
    if not summon then
        return
    end
    local energy    = summon:GetAttribute("Energy") or 0
    local abilities = latestSummonData and latestSummonData.Abilities or {}
    for _, a in ipairs(abilities) do
        local data = Abilities[a]
        if data then
            local cost = data.Cost == "X" and energy or (data.Cost or 0)
        end
    end
    local bestAbility = nil
    local bestDamage  = -1
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data then
            local cost = data.Cost == "X" and energy or (data.Cost or 0)
            local onCooldown  = (summonCooldowns[abilityName] or 0) > 0
            local canAfford   = cost <= energy
            local targetType  = data.TargetType or ""
            local isOffensive = (targetType == "SingleEnemy" or targetType == "AllEnemy")
            if isOffensive and canAfford and not onCooldown then
                local dmg = estimateDamage(data, false)
                if dmg > bestDamage then
                    bestDamage  = dmg
                    bestAbility = abilityName
                end
            end
        end
    end
    local target = getBestTarget()
    if bestAbility and target then
        TurnDecision:FireServer("Ability", target, bestAbility, summon)
        return
    end
end
local turnConnection
local function startBot()
    if turnConnection then turnConnection:Disconnect() end
    turnConnection = LocalPlayer.AttributeChanged:Connect(function(attr)
        if attr == "Turn" and LocalPlayer:GetAttribute("Turn") then
            task.spawn(function()
                task.wait(0.2)
                if not LocalPlayer:GetAttribute("Turn") then
                    return
                end
                local summonActive = isSummonTurnActive()
                if summonActive then
                    if not summonReference then summonReference = getOurSummon() end
                    takeSummonTurn()
                else
                    takeTurn()
                end
            end)
        end
    end)
    if LocalPlayer:GetAttribute("Turn") then
        task.spawn(function()
            task.wait(0.2)
            if not LocalPlayer:GetAttribute("Turn") then return end
            local summonActive = isSummonTurnActive()
            if summonActive then
                if not summonReference then summonReference = getOurSummon() end
                takeSummonTurn()
            else
                takeTurn()
            end
        end)
    end
end
local function stopBot()
    BOT_ENABLED = false
    if turnConnection then
        turnConnection:Disconnect()
        turnConnection = nil
    end
end
startBot()
