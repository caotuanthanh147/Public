repeat task.wait() until game:IsLoaded()
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer       = Players.LocalPlayer
local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local Abilities         = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Abilities"))
local EnemyData         = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Enemies"))
local TurnDecision = Remotes:WaitForChild("TurnDecision")
local GetStats     = Remotes:WaitForChild("GetStats")
local FireTurn     = Remotes:WaitForChild("FireTurn")
local GetAbilities = Remotes:WaitForChild("GetAbilities")
local AttackFlash  = Remotes:WaitForChild("AttackFlash")
local CombatEnd    = Remotes:WaitForChild("CombatEnd")
local ChangeUI     = Remotes:WaitForChild("ChangeUI")
local ReplayEvent  = Remotes:WaitForChild("ReplayEvent")
local VotingEvent  = Remotes:WaitForChild("VotingEvent")
local BOT_ENABLED          = true
local USE_ABILITIES        = true
local BLOCK_COST_THRESHOLD = 2
local ENERGY_MARGIN        = 1
local KILL_EPSILON         = 0.01
local playerCooldowns = {}
local enemyCooldowns  = {}
local latestPlayerData = nil
local gameEnded = false
local Items    = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Items"))
local GetItems = Remotes:WaitForChild("GetItems")
local HP_USE_THRESHOLD   = 0.40
local BOSS_HP_MULTIPLIER = 1
local combatInventory  = {}  
local buffUsedThisFight = false
task.spawn(function()
    if not LocalPlayer:GetAttribute("isLoaded") then
        LocalPlayer:GetAttributeChangedSignal("isLoaded"):Wait()
    end
    task.wait(0.3)
    VotingEvent:FireServer("Start Game")
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
    enemyCooldowns  = {}
    buffUsedThisFight = false
end)
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
ChangeUI.OnClientEvent:Connect(function(p19)
    if p19 == "GameOver" or p19 == "Win" then
        gameEnded = true
        task.wait(1)
        ReplayEvent:FireServer()
        gameEnded = false
    end
end)
FireTurn.OnClientEvent:Connect(function(_, p294, p295)
    if not p295 then
        playerCooldowns = p294 or {}
        for abilityName, turns in pairs(enemyCooldowns) do
            enemyCooldowns[abilityName] = turns - 1
            if enemyCooldowns[abilityName] <= 0 then
                enemyCooldowns[abilityName] = nil
            end
        end
    end
end)
AttackFlash.OnClientEvent:Connect(function(p239, _, _)
    local abilityName = p239
    local data = Abilities[abilityName]
    if data and data.Cost and data.Cost >= BLOCK_COST_THRESHOLD then
        if data.Effects and data.Effects["Heal"] then
            return
        end
        local cooldown = data.Cooldown or 0
        if cooldown > 0 then
            enemyCooldowns[abilityName] = cooldown
        end
    end
end)
CombatEnd.OnClientEvent:Connect(function()
    enemyCooldowns = {}
end)
GetAbilities.OnClientEvent:Connect(function(p236, p237)
    if not p237 then
        latestPlayerData = p236[LocalPlayer.Name]
    end
end)
local function shouldBlock()
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy:GetAttribute("isAlive") then
            local enemyName   = enemy.Name
            local enemyDef    = EnemyData[enemyName]
            local enemyEnergy = enemy:GetAttribute("Energy") or 0
            if enemyDef and enemyDef.Abilities then
                for _, abilityName in ipairs(enemyDef.Abilities) do
                    local data = Abilities[abilityName]
                    if data and data.Cost and data.Cost >= BLOCK_COST_THRESHOLD then
                        if data.Effects and data.Effects["Heal"] then
                            continue
                        end
                        if not enemyCooldowns[abilityName] then
                            if enemyEnergy >= data.Cost - ENERGY_MARGIN then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end
local function estimateDamage(data)
    local base     = data.Damage or 0
    local scaling  = data.Scaling or {}
    local multihit = data.Multihit or 1
    local statBonus = 0
    for statName, multiplier in pairs(scaling) do
        statBonus = statBonus + ((LocalPlayer:GetAttribute(statName) or 0) * multiplier)
    end
    return (base + statBonus) * multihit
end
local function getBestAbility()
    local energy     = LocalPlayer:GetAttribute("Energy") or 0
    local best       = nil
    local bestDamage = -1
    local abilities  = latestPlayerData and latestPlayerData.Abilities or {}
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data then
            local cost = data.Cost
            if cost == "X" then
                cost = energy
            end
            local onCooldown  = (playerCooldowns[abilityName] or 0) > 0
            local canAfford   = cost <= energy
            local targetType  = data.TargetType or ""
            local isOffensive = (targetType == "SingleEnemy" or targetType == "AllEnemy")
            if isOffensive and canAfford and not onCooldown then
                local dmg = estimateDamage(data)
                if dmg > bestDamage then
                    bestDamage = dmg
                    best       = abilityName
                end
            end
        end
    end
    return best
end
local function getThreatScore(enemy)
    local hp    = enemy:GetAttribute("HP") or 1
    local maxHp = enemy:GetAttribute("MaxHP") or 1
    local hpRatio = hp / maxHp
    local finishBonus = (hpRatio < 0.3) and 50 or 0
    return (1 - hpRatio) * 100 + finishBonus
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
    local enemyHp = enemy:GetAttribute("HP") or math.huge
    return estimateDamage(abilityData) >= enemyHp - KILL_EPSILON
end
local function getKillShot()
    local energy    = LocalPlayer:GetAttribute("Energy") or 0
    local abilities = latestPlayerData and latestPlayerData.Abilities or {}
    for _, abilityName in ipairs(abilities) do
        local data = Abilities[abilityName]
        if data then
            local cost = data.Cost
            if cost == "X" then
                cost = energy
            end
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
local function takeTurn()
    if not BOT_ENABLED then return end
    if not LocalPlayer:GetAttribute("Turn") then return end
    task.wait(0.1)
    if not LocalPlayer:GetAttribute("Turn") then return end
    if USE_ABILITIES then
        local killAbility, killTarget = getKillShot()
        if killAbility and killTarget then
            TurnDecision:FireServer("Ability", killTarget, killAbility, false)
            return
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
            GetStats:FireServer(false)
            return
        end
        local abilityName = getBestAbility()
        if abilityName then
            TurnDecision:FireServer("Ability", target, abilityName, false)
            return
        end
    end
    GetStats:FireServer(false)
end
local turnConnection
local function startBot()
    if turnConnection then
        turnConnection:Disconnect()
    end
    turnConnection = LocalPlayer.AttributeChanged:Connect(function(attr)
        if attr == "Turn" and LocalPlayer:GetAttribute("Turn") then
            task.spawn(takeTurn)
        end
    end)
end
local function stopBot()
    BOT_ENABLED = false
    if turnConnection then
        turnConnection:Disconnect()
        turnConnection = nil
    end
end
startBot()