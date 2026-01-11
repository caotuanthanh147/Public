local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local PlayerStats = require(game:GetService("Players").LocalPlayer.PlayerScripts.PlayerStats)
local LocalPlayer = game.Players.LocalPlayer
local LockOnSystem = require(game:GetService("Players").LocalPlayer.PlayerScripts.LockOnSystem)
local autoPlayEnabled = true
local lastAttackTime = 0
local function getCardCount()
    local count = 0
    for _ in pairs(PlayerStats.Hand) do count = count + 1 end
    for _ in pairs(PlayerStats.EGOHand) do count = count + 1 end
    return count
end
local function findEnemyTarget()
    local entities = workspace.Entities
    if not entities then return nil end
    for _, potentialEnemy in ipairs(entities:GetChildren()) do
        if potentialEnemy:GetAttribute("id") and not potentialEnemy:GetAttribute("Dead") then
            return potentialEnemy
        end
    end
    return nil
end
local function teleportAndTargetEnemy(enemy)
    if not enemy then return false end
    local character = LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and enemy:IsA("Model") then
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
        if not enemyRoot then
            for _, part in pairs(enemy:GetChildren()) do
                if part:IsA("BasePart") then
                    enemyRoot = part
                    break
                end
            end
            if not enemyRoot then
                local offset = Vector3.new(5, 0, 5)
                humanoidRootPart.CFrame = CFrame.new(enemy:GetPivot().Position + offset)
                task.wait(0.5) 
                LockOnSystem.setLockOn(enemy)
                return LockOnSystem.LockOnByPlayerData == enemy
            end
        end
        if enemyRoot then
            local offset = Vector3.new(5, 0, 5)
            humanoidRootPart.CFrame = CFrame.new(enemyRoot.Position + offset)
            task.wait(0.5) 
            LockOnSystem.setLockOn(enemy)
            return LockOnSystem.LockOnByPlayerData == enemy
        end
    end
    LockOnSystem.setLockOn(enemy)
    task.wait(0.1)
    return LockOnSystem.LockOnByPlayerData == enemy
end
local function playRandomAttack()
    if not LocalPlayer:GetAttribute("IsYourTurn") then return false end
    if LocalPlayer:GetAttribute("Active") then return false end
    if tick() - lastAttackTime < 1 then return false end
    local cardCount = getCardCount()
    if cardCount <= 1 then
        Events.EndTurn:FireServer()
        return true
    end
    local enemy = findEnemyTarget()
    if not enemy then 
        if cardCount > 1 then
            return false
        else
            Events.EndTurn:FireServer()
            return true
        end
    end
    if not teleportAndTargetEnemy(enemy) then 
        return false 
    end
    local enemyTarget = LockOnSystem.LockOnByPlayerData
    if not enemyTarget then
        return false
    end
    local attackId, attackData = next(PlayerStats.Hand)
    if not attackId then
        attackId, attackData = next(PlayerStats.EGOHand)
    end
    if not attackId then 
        Events.EndTurn:FireServer()
        return true
    end
    local enemyId = enemyTarget:GetAttribute("id")
    if attackData then
        if PlayerStats.EGOHand[attackId] then
            Events.playEGOAttack:FireServer(attackData.Name, attackId, enemyId)
        else
            Events.playAttack:FireServer(attackId, enemyId)
        end
        lastAttackTime = tick()
        return true
    end
    return false
end
local function autoPlayLoop()
    while autoPlayEnabled do
        if LocalPlayer:GetAttribute("IsYourTurn") then
            local entities = workspace.Entities
            local cardCount = getCardCount()
            if cardCount <= 1 then
                Events.EndTurn:FireServer()
            elseif entities and #entities:GetChildren() > 0 then
                playRandomAttack()
            end
        end
        task.wait(0.1) 
    end
end
task.spawn(autoPlayLoop)