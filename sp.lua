local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "EpicHub",
   Icon = 4483345998,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EpicHub",
      FileName = "Settings"
   }
})
local ManTab = Window:CreateTab("Main", 4483345998)
local SkillTab = Window:CreateTab("Skills", 4483345998)
local InvTab = Window:CreateTab("Inventory", 4483345998)
local DunTab = Window:CreateTab("Dungeon", 4483345998) 
_G.AutoEquipActive = false
_G.SelectedTools = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local function getBackpackTools()
    local tools = {}
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(tools, item.Name)
            end
        end
    end
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(tools, item.Name)
            end
        end
    end
    return tools
end
local function nameMatches(modelName, target)
    if not target then return false end
    local name = tostring(modelName):lower()
    local search = tostring(target):lower()
    search = search:gsub("([^%w])","%%%1") 
    return name:match(search) ~= nil
end
local function equipAllItems()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            if table.find(_G.SelectedTools, item.Name) then
                pcall(function()
                    item.Parent = character
                end)
            end
        end
    end
end
local function autoEquipLoop()
    while _G.AutoEquipActive do
        pcall(equipAllItems)
        task.wait(0.3)
    end
end
local toolDropdown = InvTab:CreateDropdown({
    Name = "Tools to Equip",
    Options = getBackpackTools(),
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "lesbian8_tools",
    Callback = function(selected)
        _G.SelectedTools = selected
    end
})
InvTab:CreateButton({
    Name = "Refresh List",
    Callback = function()
        local tools = getBackpackTools()
        toolDropdown:Refresh(tools, true)
        _G.SelectedTools = {}
    end
})
InvTab:CreateToggle({
    Name = "Auto Equip",
    Flag = "lesbian8",
    CurrentValue = _G.AutoEquipActive,
    Callback = function(value)
        _G.AutoEquipActive = value
        if value then
            task.spawn(autoEquipLoop)
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RequestAbility     = ReplicatedStorage:WaitForChild("AbilitySystem"):WaitForChild("Remotes"):WaitForChild("RequestAbility")
local AbilityFeedback    = ReplicatedStorage:WaitForChild("AbilitySystem"):WaitForChild("Remotes"):WaitForChild("AbilityFeedback")
local RequestHit         = ReplicatedStorage:WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit")
local HakiRemote         = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("HakiRemote")
local ObsRemote          = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ObservationHakiRemote")
local FruitPowerRemote   = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("FruitPowerRemote")
local FruitPowerResponse = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("FruitPowerResponse")
local ConquerRemote      = ReplicatedStorage.RemoteEvents:FindFirstChild("ConquerorHakiRemote")
_G.AutoAbility  = false
_G.AutoM1       = false
_G.AutoHaki     = false
_G.AutoObs      = false
_G.AutoConquer  = false
_G.AutoFruit    = false
_G.AbilitySlots = {}
local hakiOn    = false
local obsOn     = false
local conquerOn = false
local cooldownFrame = nil
task.spawn(function()
    local gui = player:WaitForChild("PlayerGui"):WaitForChild("CooldownUI", 10)
    if gui then
        cooldownFrame = gui:WaitForChild("MainFrame", 10)
    end
end)
local slotToLabelKey = {}
local fruitKeyToLabelKey = {}
AbilityFeedback.OnClientEvent:Connect(function(data)
    if type(data) == "table" and data.AbilitySlot and data.MovesetName and data.AbilityName then
        slotToLabelKey[data.AbilitySlot] = data.MovesetName .. "_" .. data.AbilityName
    end
end)
FruitPowerResponse.OnClientEvent:Connect(function(event, data)
    if event == "CooldownStarted" and type(data) == "table" and data.Key and data.PowerName and data.Ability then
        fruitKeyToLabelKey[data.Key] = data.PowerName .. "_" .. data.Ability
    end
end)
local function labelReady(labelKey)
    if not cooldownFrame then return true end
    local holder = cooldownFrame:FindFirstChild("Cooldown_" .. labelKey)
    if not holder then return true end
    local txt = holder:FindFirstChild("Txt")
    local autoSize = txt and txt:FindFirstChild("AutoSizeHolder")
    local weaponLabel = autoSize and autoSize:FindFirstChild("WeaponNameAndCooldown")
    if not weaponLabel then return true end
    local text = weaponLabel.Text
    return text:find("Ready") ~= nil or not text:find("%d+%.%d+s")
end
local function slotReady(slot)
    local key = slotToLabelKey[slot]
    if not key then return true end  
    return labelReady(key)
end
local function fruitReady(bindKey)
    local key = fruitKeyToLabelKey[bindKey]
    if not key then return true end  
    return labelReady(key)
end
local function isAlive()
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end
local function notInCutscene()
    local char = player.Character
    return not char or not char:GetAttribute("InCutscene")
end
SkillTab:CreateDropdown({
    Name            = "Ability Slots to Use",
    Options         = { "1", "2", "3", "4", "5" },
    CurrentOption   = {},
    MultipleOptions = true,
    Flag            = "ability_slots",
    Callback        = function(selected)
        _G.AbilitySlots = {}
        for _, v in ipairs(selected) do
            table.insert(_G.AbilitySlots, tonumber(v))
        end
    end,
})
SkillTab:CreateToggle({
    Name         = "Auto Ability",
    Flag         = "auto_ability",
    CurrentValue = false,
    Callback     = function(value)
        _G.AutoAbility = value
        if not value then return end
        task.spawn(function()
            while _G.AutoAbility do
                if isAlive() and notInCutscene() then
                    local slots = #_G.AbilitySlots > 0 and _G.AbilitySlots or {1, 2, 3, 4, 5}
                    for _, slot in ipairs(slots) do
                        if not _G.AutoAbility then break end
                        if slotReady(slot) then
                            pcall(function()
                                RequestAbility:FireServer(slot)
                            end)
                        end
                        task.wait(0.15)
                    end
                end
                task.wait(0.2)
            end
        end)
    end,
})
local FRUIT_KEYS = {
    { key = "Z", enum = Enum.KeyCode.Z },
    { key = "X", enum = Enum.KeyCode.X },
    { key = "C", enum = Enum.KeyCode.C },
}
SkillTab:CreateToggle({
    Name         = "Auto Fruit",
    Flag         = "auto_fruit",
    CurrentValue = false,
    Callback     = function(value)
        _G.AutoFruit = value
        if not value then return end
        task.spawn(function()
            while _G.AutoFruit do
                if isAlive() and notInCutscene() then
                    for _, bind in ipairs(FRUIT_KEYS) do
                        if not _G.AutoFruit then break end
                        if fruitReady(bind.key) then
                            pcall(function()
                                FruitPowerRemote:FireServer("UseAbility", {
                                    FruitPower = "Light",
                                    KeyCode    = bind.enum,
                                })
                            end)
                        end
                        task.wait(0.15)
                    end
                end
                task.wait(0.2)
            end
        end)
    end,
})
SkillTab:CreateToggle({
    Name         = "Auto M1",
    Flag         = "auto_m1",
    CurrentValue = false,
    Callback     = function(value)
        _G.AutoM1 = value
        if not value then return end
        task.spawn(function()
            while _G.AutoM1 do
                if isAlive() and notInCutscene() then
                    pcall(function() RequestHit:FireServer() end)
                end
                task.wait(0.1)
            end
        end)
    end,
})
local function applyHakiStates()
    task.wait(1.5)
    hakiOn    = false
    obsOn     = false
    conquerOn = false
    if _G.AutoHakiAll then
        if HakiRemote then
            pcall(function()
                HakiRemote:FireServer("Toggle")
                hakiOn = true
            end)
        end
        if ObsRemote then
            pcall(function()
                ObsRemote:FireServer("Toggle")
                obsOn = true
            end)
        end
        if ConquerRemote then
            pcall(function()
                ConquerRemote:FireServer("Toggle")
                conquerOn = true
            end)
        end
    end
end
player.CharacterAdded:Connect(applyHakiStates)
SkillTab:CreateToggle({
    Name = "Auto All Haki",
    Flag = "auto_all_haki",
    CurrentValue = false,
    Callback = function(value)
        _G.AutoHakiAll = value
        pcall(function()
            if HakiRemote then
                if value and not hakiOn then
                    HakiRemote:FireServer("Toggle")
                    hakiOn = true
                elseif not value and hakiOn then
                    HakiRemote:FireServer("Toggle")
                    hakiOn = false
                end
            end
            if ObsRemote then
                if value and not obsOn then
                    ObsRemote:FireServer("Toggle")
                    obsOn = true
                elseif not value and obsOn then
                    ObsRemote:FireServer("Toggle")
                    obsOn = false
                end
            end
            if ConquerRemote then
                if value and not conquerOn then
                    ConquerRemote:FireServer("Toggle")
                    conquerOn = true
                elseif not value and conquerOn then
                    ConquerRemote:FireServer("Toggle")
                    conquerOn = false
                end
            end
        end)
    end,
})
local TeleportRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TeleportToPortal")
local NORMAL_MOBS = {
    { display = "Thief",           prefix = "Thief",           island = "Starter",    questNPC = "QuestNPC1",  minLevel = 0     },
    { display = "Monkey",          prefix = "Monkey",          island = "Jungle",     questNPC = "QuestNPC3",  minLevel = 250   },
    { display = "Desert Bandit",   prefix = "DesertBandit",    island = "Desert",     questNPC = "QuestNPC5",  minLevel = 750   },
    { display = "Frost Rogue",     prefix = "FrostRogue",      island = "Snow",       questNPC = "QuestNPC7",  minLevel = 1500  },
    { display = "Sorcerer",        prefix = "Sorcerer",        island = "Sailor",     questNPC = "QuestNPC9",  minLevel = 3000  },
    { display = "Hollow",          prefix = "Hollow",          island = "HuecoMundo", questNPC = "QuestNPC11", minLevel = 5000  },
    { display = "Strong Sorcerer", prefix = "StrongSorcerer",  island = "Shinjuku",   questNPC = "QuestNPC12", minLevel = 6250  },
    { display = "Curse",           prefix = "Curse",           island = "Shinjuku",   questNPC = "QuestNPC13", minLevel = 7000  },
    { display = "Slime Warrior",   prefix = "SlimeWarrior",    island = "Slime",      questNPC = "QuestNPC14", minLevel = 8000  },
    { display = "Academy Teacher", prefix = "AcademyTeacher",  island = "Academy",    questNPC = "QuestNPC15", minLevel = 9000  },
    { display = "Swordsman",       prefix = "Swordsman",       island = "Judgement",  questNPC = "QuestNPC16", minLevel = 10000 },
    { display = "Quincy",          prefix = "Quincy",          island = "SoulSociety",questNPC = "QuestNPC17", minLevel = 10750 },
    { display = "Valentine",       prefix = "Valentine",       island = "Shibuya",    questNPC = nil,          minLevel = 0     },
    { display = "Training Dummy",  prefix = "TrainingDummy",   island = "Academy",    questNPC = nil,          minLevel = 0     },
}
local BOSSES = {
    { display = "Thief Boss",                name = "ThiefBoss",              island = "Starter",  questNPC = "QuestNPC2",  minLevel = 100  },
    { display = "Monkey Boss",               name = "MonkeyBoss",             island = "Jungle",   questNPC = "QuestNPC4",  minLevel = 500  },
    { display = "Desert Boss",               name = "DesertBoss",             island = "Desert",   questNPC = "QuestNPC6",  minLevel = 1000 },
    { display = "Snow Boss",                 name = "SnowBoss",               island = "Snow",     questNPC = "QuestNPC8",  minLevel = 2000 },
    { display = "Panda Mini Boss",           name = "PandaMiniBoss",          island = "Sailor",   questNPC = "QuestNPC10", minLevel = 4000 },
    { display = "Saber Boss",                name = "SaberBoss",              island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "Gojo Boss",                 name = "GojoBoss",               island = "Shibuya",     questNPC = nil,          minLevel = 0    },
    { display = "Sukuna Boss",               name = "SukunaBoss",             island = "Shibuya",     questNPC = nil,          minLevel = 0    },
    { display = "Jinwoo Boss",               name = "JinwooBoss",             island = "Sailor",     questNPC = nil,          minLevel = 0    },
    { display = "Alucard Boss",              name = "AlucardBoss",            island = "Sailor",     questNPC = nil,          minLevel = 0    },
    { display = "Ichigo Boss",               name = "IchigoBoss",             island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "Sung Boss",                 name = "SungBoss",               island = "Sailor",     questNPC = nil,          minLevel = 0    },
    { display = "Ragna Boss",                name = "RagnaBoss",              island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "Aizen Boss",                name = "AizenBoss",              island = "HuecoMundo",     questNPC = nil,          minLevel = 0    },
    { display = "Qin Shi Boss",              name = "QinShiBoss",             island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "Yuji Boss",                 name = "YujiBoss",               island = "Shibuya",     questNPC = nil,          minLevel = 0    },
    { display = "Rimuru Boss",               name = "RimuruBoss",             island = "Slime",     questNPC = nil,          minLevel = 0    },
    { display = "Madoka Boss",               name = "MadokaBoss",             island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "Gilgamesh Boss",            name = "GilgameshBoss",          island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "Blessed Maiden Boss",       name = "BlessedMaidenBoss",      island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "Anos Boss",                 name = "AnosBoss",               island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "True Aizen Boss",           name = "TrueAizenBoss",          island = "SoulSociety",     questNPC = nil,          minLevel = 0    },
    { display = "Shadow Boss",               name = "ShadowBoss",             island = "Boss",     questNPC = nil,          minLevel = 0    },
    { display = "Strongest of Today Boss",   name = "StrongestofTodayBoss",   island = "Shinjuku",     questNPC = nil,          minLevel = 0    },
    { display = "Strongest in History Boss", name = "StrongestinHistoryBoss", island = "Shinjuku",     questNPC = nil,          minLevel = 0    },
    { display = "Dungeon NPC 1",             name = "DungeonNPC1",            island = "Dungeon",  questNPC = nil,          minLevel = 0    },
    { display = "Dungeon NPC 2",             name = "DungeonNPC2",            island = "Dungeon",  questNPC = nil,          minLevel = 0    },
    { display = "Dungeon NPC 3",             name = "DungeonNPC3",            island = "Dungeon",  questNPC = nil,          minLevel = 0    },
    { display = "Dungeon NPC 4",             name = "DungeonNPC4",            island = "Dungeon",  questNPC = nil,          minLevel = 0    },
}
local MOB_OPTIONS,  MOB_BY_DISPLAY  = {}, {}
local BOSS_OPTIONS, BOSS_BY_DISPLAY = {}, {}
for _, m in ipairs(NORMAL_MOBS) do table.insert(MOB_OPTIONS,  m.display); MOB_BY_DISPLAY[m.display]  = m end
for _, b in ipairs(BOSSES)      do table.insert(BOSS_OPTIONS, b.display); BOSS_BY_DISPLAY[b.display] = b end
local TOTAL_DISTANCE = 10
local TWEEN_SPEED    = 10
local FARM_POSITION  = "Below"
local BODY_VEL_NAME  = "AutoTweenBodyVelocity"
local bodyVelocity
local noclipActive   = false
local modifiedParts  = {}
local function enableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME then pcall(function() inst:Destroy() end) end
    end
    hrp.Anchored          = false
    bodyVelocity          = Instance.new("BodyVelocity")
    bodyVelocity.Name     = BODY_VEL_NAME
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent   = hrp
end
local noclipCharConn, noclipDescConn
local function setNoclip(char, state)
    for _, child in pairs(char:GetDescendants()) do
        if child:IsA("BasePart") then
            pcall(function() child.CanCollide = not state end)
        end
    end
end
local function startNoclip()
    if noclipActive then return end
    noclipActive = true
    if player.Character then setNoclip(player.Character, true) end
    noclipCharConn = player.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 5)
        setNoclip(char, true)
        noclipDescConn = char.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") then pcall(function() d.CanCollide = false end) end
        end)
    end)
    if player.Character then
        if noclipDescConn then noclipDescConn:Disconnect() end
        noclipDescConn = player.Character.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") then pcall(function() d.CanCollide = false end) end
        end)
    end
end
local function stopNoclip()
    noclipActive = false
    if noclipCharConn then noclipCharConn:Disconnect(); noclipCharConn = nil end
    if noclipDescConn then noclipDescConn:Disconnect(); noclipDescConn = nil end
    if player.Character then setNoclip(player.Character, false) end
end
local function isPlayerAlive()
    if not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead
end
local function getDesiredPosition(hrp, targetModel)
    local pivot = targetModel:GetPivot()
    local offset
    if FARM_POSITION == "Above" then
        offset = Vector3.new(0, TOTAL_DISTANCE, 0)
    elseif FARM_POSITION == "Behind" then
        offset = pivot.LookVector * TOTAL_DISTANCE
    else
        offset = Vector3.new(0, -TOTAL_DISTANCE, 0)
    end
    return pivot.Position + offset, pivot.Position
end
local lastTeleportTime = 0
local function teleportToIsland(portalId)
    TeleportRemote:FireServer(portalId)
end
local patternCache = {}
local function npcMatches(modelName, npcData)
    if npcData.name then
        return modelName == npcData.name
    elseif npcData.prefix then
        local pat = patternCache[npcData.prefix]
        if not pat then
            pat = "^" .. npcData.prefix .. "%d*$"
            patternCache[npcData.prefix] = pat
        end
        return modelName:match(pat) ~= nil
    end
    return false
end
local targetCache = {}      
local TARGET_TTL  = 0.1   
local function findTargetByData(npcData)
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local cacheKey = npcData.name or npcData.prefix or ""
    local cached   = targetCache[cacheKey]
    if cached and (tick() - cached.time) < TARGET_TTL then
        return cached.model, cached.dist
    end
    local npcFolder = workspace:FindFirstChild("NPCs")
    if not npcFolder then return nil, math.huge end
    local closestModel, closestDist = nil, math.huge
    local myPos = hrp.Position
    for _, model in ipairs(npcFolder:GetChildren()) do
        if model:IsA("Model") and npcMatches(model.Name, npcData) then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (model:GetPivot().Position - myPos).Magnitude
                if dist < closestDist then
                    closestDist  = dist
                    closestModel = model
                end
            end
        end
    end
    targetCache[cacheKey] = { model = closestModel, dist = closestDist, time = tick() }
    return closestModel, closestDist
end
local activeConnections    = {}
local charAddedConnections = {}
local diedConnections      = {}
local isTeleporting        = {}
_G.AutoNearestActive = false
local FARM_PRIORITY = { boss = 3, enemy = 2, nearest = 1, level = 1 }
local function disableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME then
            pcall(function() inst:Destroy() end)
        end
    end
    bodyVelocity = nil
end
local farmHasTarget = {}
local function stopFarm(key)
    if activeConnections[key] then
        activeConnections[key]:Disconnect()
        activeConnections[key] = nil
    end
    farmHasTarget[key] = false
end
local function onCharacterAdded_farm(character, key)
    if diedConnections[key] then diedConnections[key]:Disconnect() end
    local hum = character:FindFirstChildWhichIsA("Humanoid")
    if hum then
        diedConnections[key] = hum.Died:Connect(function()
            stopFarm(key)
            stopNoclip()
            disableBodyControl(hrp)
            isTeleporting[key] = false
        end)
    end
end
local function startFarmLoop(key, npcDataList, isActiveFunc)
    if type(npcDataList) == "table" and (npcDataList.prefix or npcDataList.name) then
        npcDataList = { npcDataList }
    end
    stopFarm(key)
    isTeleporting[key] = false
    if charAddedConnections[key] then charAddedConnections[key]:Disconnect() end
    charAddedConnections[key] = player.CharacterAdded:Connect(function(char)
        onCharacterAdded_farm(char, key)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then enableBodyControl(hrp) end
        startNoclip()
    end)
    if player.Character then
        onCharacterAdded_farm(player.Character, key)
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        enableBodyControl(hrp)
        startNoclip()
    end
    activeConnections[key] = RunService.Heartbeat:Connect(function()
        if not isActiveFunc() or not isPlayerAlive() then
            stopFarm(key)
            stopNoclip()
            farmHasTarget[key] = false
            return
        end
        local myPriority = FARM_PRIORITY[key] or 0
        for otherKey, otherPriority in pairs(FARM_PRIORITY) do
            if otherKey ~= key
            and otherPriority > myPriority
            and activeConnections[otherKey]
            and farmHasTarget[otherKey] then
                return
            end
        end
        if isTeleporting[key] then return end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local bestModel, bestDist, bestData = nil, math.huge, nil
        for _, npcData in ipairs(npcDataList) do
            local model, dist = findTargetByData(npcData)
            if model and dist < bestDist then
                bestModel = model
                bestDist  = dist
                bestData  = npcData
            end
        end
        farmHasTarget[key] = bestModel ~= nil
        if not bestModel then return end
        if bestDist > 500 and bestData.island then
            isTeleporting[key] = true
            task.spawn(function()
                teleportToIsland(bestData.island)
                isTeleporting[key] = false
            end)
            return
        end
        if not bodyVelocity or not bodyVelocity.Parent then
            enableBodyControl(hrp)
        end
        local desiredPos, targetPos = getDesiredPosition(hrp, bestModel)
        local lerpedXZ = Vector3.new(
            hrp.Position.X + (desiredPos.X - hrp.Position.X) * 0.15,
            desiredPos.Y,
            hrp.Position.Z + (desiredPos.Z - hrp.Position.Z) * 0.15
        )
        hrp.CFrame                 = CFrame.new(lerpedXZ, targetPos)
        hrp.AssemblyLinearVelocity = Vector3.zero
        if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end
    end)
end
local function stopFarmFull(key)
    stopFarm(key)
    isTeleporting[key] = false
    if charAddedConnections[key] then
        charAddedConnections[key]:Disconnect()
        charAddedConnections[key] = nil
    end
    if diedConnections[key] then
        diedConnections[key]:Disconnect()
        diedConnections[key] = nil
    end
    stopNoclip()
end
local function getPlayerLevel()
    local data = player:FindFirstChild("Data")
    local lvl = data:FindFirstChild("Level")
    return lvl and lvl.Value
end
local QuestConfig       = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("QuestConfig"))
local QuestAcceptRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("QuestAccept")
local QUEST_TITLE_MAP = {}
if QuestConfig and QuestConfig.RepeatableQuests then
    for npcName, questData in pairs(QuestConfig.RepeatableQuests) do
        if questData.title then
            QUEST_TITLE_MAP[npcName] = questData.title
        end
    end
else
end
local function getActiveQuestTitle()
    local ok, result = pcall(function()
        return player.PlayerGui
            :WaitForChild("QuestUI", 2)
            :WaitForChild("Quest", 2)
            :WaitForChild("Quest", 2)
            :WaitForChild("Holder", 2)
            :WaitForChild("Content", 2)
            :WaitForChild("QuestInfo", 2)
            :WaitForChild("QuestTitle", 2)
            :WaitForChild("QuestTitle", 2).Text
    end)
    if ok and result and result ~= "" then
        return result
    end
    if not ok then
    else
    end
    return nil
end
local function questMatchesTarget(questNPCName)
    local expected = QUEST_TITLE_MAP[questNPCName]
    local active   = getActiveQuestTitle()
    if not expected then return true end
    if not active   then return false end
    return active:lower() == expected:lower()
end
local function hasActiveQuest()
    local ok, result = pcall(function()
        return player.PlayerGui
            :WaitForChild("QuestUI", 2)
            :WaitForChild("Quest", 2)
            :WaitForChild("Quest", 2)
            :WaitForChild("Holder", 2)
            :WaitForChild("Content", 2)
            :WaitForChild("QuestInfo", 2)
            :WaitForChild("QuestTitle", 2)
            :WaitForChild("QuestTitle", 2).Text
    end)
    if ok and result and result ~= "" and result ~= "Quest Name Here" then
        return result
    end
    if not ok then
    end
    return nil
end
local QuestAbandonRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("QuestAbandon")
local function acceptQuest(questNPCName)
    local expected = QUEST_TITLE_MAP[questNPCName]
    local active   = hasActiveQuest()
    if active and expected and active:lower() ~= expected:lower() then
        pcall(function()
            QuestAbandonRemote:FireServer("repeatable")
        end)
        task.wait(1)
    end
    if hasActiveQuest() and expected and hasActiveQuest():lower() == expected:lower() then
        return
    end
    pcall(function()
        QuestAcceptRemote:FireServer(questNPCName)
    end)
    task.wait(1)
    local after = hasActiveQuest()
    if not after or (expected and after:lower() ~= expected:lower()) then
        pcall(function()
            QuestAcceptRemote:FireServer(questNPCName)
        end)
    end
end
local LEVEL_QUEST_ORDER = {
    { minLevel = 0,     data = MOB_BY_DISPLAY["Thief"]            },
    { minLevel = 100,   data = BOSS_BY_DISPLAY["Thief Boss"]      },
    { minLevel = 250,   data = MOB_BY_DISPLAY["Monkey"]           },
    { minLevel = 500,   data = BOSS_BY_DISPLAY["Monkey Boss"]     },
    { minLevel = 750,   data = MOB_BY_DISPLAY["Desert Bandit"]    },
    { minLevel = 1000,  data = BOSS_BY_DISPLAY["Desert Boss"]     },
    { minLevel = 1500,  data = MOB_BY_DISPLAY["Frost Rogue"]      },
    { minLevel = 2000,  data = BOSS_BY_DISPLAY["Snow Boss"]       },
    { minLevel = 3000,  data = MOB_BY_DISPLAY["Sorcerer"]         },
    { minLevel = 4000,  data = BOSS_BY_DISPLAY["Panda Mini Boss"] },
    { minLevel = 5000,  data = MOB_BY_DISPLAY["Hollow"]           },
    { minLevel = 6250,  data = MOB_BY_DISPLAY["Strong Sorcerer"]  },
    { minLevel = 7000,  data = MOB_BY_DISPLAY["Curse"]            },
    { minLevel = 8000,  data = MOB_BY_DISPLAY["Slime Warrior"]    },
    { minLevel = 9000,  data = MOB_BY_DISPLAY["Academy Teacher"]  },
    { minLevel = 10000, data = MOB_BY_DISPLAY["Swordsman"]        },
    { minLevel = 10750, data = MOB_BY_DISPLAY["Quincy"]           },
}
local function getBestTargetForLevel(level)
    local best = nil
    for _, entry in ipairs(LEVEL_QUEST_ORDER) do
        if level >= entry.minLevel and entry.data then
            best = entry.data
        end
    end
    return best or NORMAL_MOBS[1]
end
local selectedMobs = { NORMAL_MOBS[1] }
local selectedBosses = { BOSSES[1] }
_G.AutoEnemyActive   = false
_G.AutoBossActive    = false
_G.AutoBossAllActive = false
_G.AutoLevelActive   = false
ManTab:CreateDropdown({
    Name = "Farm Position", Options = {"Above","Below","Behind"},
    CurrentOption = {"Below"}, Flag = "lesbian6",
    Callback = function(s) FARM_POSITION = s[1] or "Below" end
})
ManTab:CreateInput({
    Name = "Distance", CurrentValue = tostring(TOTAL_DISTANCE),
    PlaceholderText = "Distance", Flag = "lesbian4",
    Callback = function(v) local n = tonumber(v) if n then TOTAL_DISTANCE = n end end
})
ManTab:CreateInput({
    Name = "Tween Speed", CurrentValue = tostring(TWEEN_SPEED),
    PlaceholderText = "Speed", Flag = "lesbian7",
    Callback = function(v) local n = tonumber(v) if n then TWEEN_SPEED = n end end
})
ManTab:CreateDropdown({
    Name = "Choose Enemy", Options = MOB_OPTIONS,
    CurrentOption = { MOB_OPTIONS[1] }, Flag = "enemy_select",
    MultipleOptions = true,
    Callback = function(selected)
        selectedMobs = {}
        for _, name in ipairs(selected) do
            local m = MOB_BY_DISPLAY[name]
            if m then table.insert(selectedMobs, m) end
        end
        if #selectedMobs == 0 then selectedMobs = { NORMAL_MOBS[1] } end
        if _G.AutoEnemyActive then
            startFarmLoop("enemy", selectedMobs, function() return _G.AutoEnemyActive end)
        end
    end
})
ManTab:CreateToggle({
    Name = "Auto Enemy", CurrentValue = false, Flag = "auto_enemy",
    Callback = function(value)
        _G.AutoEnemyActive = value
        if value then
            startFarmLoop("enemy", selectedMobs, function() return _G.AutoEnemyActive end)
        else
            stopFarmFull("enemy")
        end
    end
})
ManTab:CreateDropdown({
    Name = "Choose Boss", Options = BOSS_OPTIONS,
    CurrentOption = { BOSS_OPTIONS[1] }, Flag = "boss_select", MultipleOptions = true,
    Callback = function(selected)
        selectedBosses = {}
        for _, name in ipairs(selected) do
            local b = BOSS_BY_DISPLAY[name]
            if b then table.insert(selectedBosses, b) end
        end
        if #selectedBosses == 0 then selectedBosses = { BOSSES[1] } end
        if _G.AutoBossActive then
            startFarmLoop("boss", selectedBosses, function() return _G.AutoBossActive end)
        end
    end
})
ManTab:CreateToggle({
    Name = "Auto Boss", CurrentValue = false, Flag = "auto_boss",
    Callback = function(value)
        _G.AutoBossActive = value
        if value then
            startFarmLoop("boss", selectedBosses, function() return _G.AutoBossActive end)
        else
            stopFarmFull("boss")
        end
    end
})
ManTab:CreateToggle({
    Name = "Auto Leveling", CurrentValue = false, Flag = "auto_level",
    Callback = function(value)
        _G.AutoLevelActive = value
        if not value then
            stopFarmFull("level")
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            disableBodyControl(hrp)
            return
        end
        task.spawn(function()
            local lastTarget = nil
            while _G.AutoLevelActive do
                if isPlayerAlive() then
                    local level      = getPlayerLevel()
                    local bestTarget = getBestTargetForLevel(level)
                    if bestTarget and bestTarget.questNPC then
                        local active   = hasActiveQuest()
                        local expected = QUEST_TITLE_MAP[bestTarget.questNPC]
                        local needsAccept = not active
                            or (expected and active:lower() ~= expected:lower())
                        if needsAccept then
                            stopFarm("level")  
                            local _, dist = findTargetByData(bestTarget)
                            if dist > 500 and bestTarget.island then
                                teleportToIsland(bestTarget.island)
                            end
                            acceptQuest(bestTarget.questNPC)
                            lastTarget = nil
                        end
                    end
                    if bestTarget ~= lastTarget then
                        lastTarget = bestTarget
                        startFarmLoop("level", bestTarget, function() return _G.AutoLevelActive end)
                    end
                else
                    stopFarm("level")
                    disableBodyControl(player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
                    lastTarget = nil
                    task.wait(3)
                end
                task.wait(1)
            end
        end)
    end
})
local function findNearestAny()
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local npcFolder = workspace:FindFirstChild("NPCs")
    if not npcFolder then return nil, math.huge end
    local cached = targetCache["__nearest"]
    if cached and (tick() - cached.time) < TARGET_TTL then
        return cached.model, cached.dist
    end
    local closestModel, closestDist = nil, math.huge
    local myPos = hrp.Position
    for _, model in ipairs(npcFolder:GetChildren()) do
        if model:IsA("Model") then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (model:GetPivot().Position - myPos).Magnitude
                if dist < closestDist then
                    closestDist  = dist
                    closestModel = model
                end
            end
        end
    end
    targetCache["__nearest"] = { model = closestModel, dist = closestDist, time = tick() }
    return closestModel, closestDist
end
ManTab:CreateToggle({
    Name = "Auto Farm Nearest", CurrentValue = false, Flag = "auto_nearest",
    Callback = function(value)
        _G.AutoNearestActive = value
        if not value then stopFarmFull("nearest") return end
        stopFarm("nearest")
        isTeleporting["nearest"] = false
        if charAddedConnections["nearest"] then charAddedConnections["nearest"]:Disconnect() end
        charAddedConnections["nearest"] = player.CharacterAdded:Connect(function(char)
            onCharacterAdded_farm(char, "nearest")
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then enableBodyControl(hrp) end
            startNoclip()
        end)
        if player.Character then
            onCharacterAdded_farm(player.Character, "nearest")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            enableBodyControl(hrp)
            startNoclip()
        end
        activeConnections["nearest"] = RunService.Heartbeat:Connect(function()
            if not _G.AutoNearestActive or not isPlayerAlive() then
                stopFarm("nearest")
                stopNoclip()
                farmHasTarget["nearest"] = false
                return
            end
            local myPriority = FARM_PRIORITY["nearest"] or 0
            for otherKey, otherPriority in pairs(FARM_PRIORITY) do
                if otherKey ~= "nearest"
                and otherPriority > myPriority
                and activeConnections[otherKey]
                and farmHasTarget[otherKey] then
                    return
                end
            end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local bestModel, bestDist = findNearestAny()
            farmHasTarget["nearest"] = bestModel ~= nil
            if not bestModel then return end
            if not bodyVelocity or not bodyVelocity.Parent then
                enableBodyControl(hrp)
            end
            local desiredPos, targetPos = getDesiredPosition(hrp, bestModel)
            local lerpedXZ = Vector3.new(
                hrp.Position.X + (desiredPos.X - hrp.Position.X) * 0.15,
                desiredPos.Y,
                hrp.Position.Z + (desiredPos.Z - hrp.Position.Z) * 0.15
            )
            hrp.CFrame                 = CFrame.new(lerpedXZ, targetPos)
            hrp.AssemblyLinearVelocity = Vector3.zero
            if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end
        end)
    end
})
local MerchantConfig     = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MerchantConfig"))
local MerchantRemotes    = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("MerchantRemotes")
local GetMerchantStock   = MerchantRemotes:WaitForChild("GetMerchantStock")
local PurchaseMerchant   = MerchantRemotes:WaitForChild("PurchaseMerchantItem")
local MerchantStockUpdate = MerchantRemotes:WaitForChild("MerchantStockUpdate")
local MERCHANT_ITEMS = {}
for itemName in pairs(MerchantConfig.ITEMS) do
    table.insert(MERCHANT_ITEMS, itemName)
end
table.sort(MERCHANT_ITEMS)
local merchantStock = {}
MerchantStockUpdate.OnClientEvent:Connect(function(itemName, newStock)
    if merchantStock[itemName] then
        merchantStock[itemName].stock = newStock
    end
end)
_G.AutoBuyActive   = false
_G.AutoBuySelected = {}
local function fetchStock()
    local ok, result = pcall(function() return GetMerchantStock:InvokeServer() end)
    if ok and result and result.success then
        merchantStock = result.stock
        return true
    end
    return false
end
local function buyItem(itemName)
    local data = merchantStock[itemName]
    if not data or data.stock <= 0 then return end
    local qty = data.stock
    local ok, result = pcall(function() return PurchaseMerchant:InvokeServer(itemName, qty) end)
    if ok and result and result.success then
        merchantStock[itemName].stock = result.newStock or 0
    end
end
InvTab:CreateDropdown({
    Name = "Items to Buy", Options = MERCHANT_ITEMS,
    CurrentOption = {}, MultipleOptions = true, Flag = "merchant_items",
    Callback = function(selected) _G.AutoBuySelected = selected end
})
InvTab:CreateToggle({
    Name = "Auto Buy Merchant", Flag = "auto_buy", CurrentValue = false,
    Callback = function(value)
        _G.AutoBuyActive = value
        if not value then return end
        task.spawn(function()
            while _G.AutoBuyActive do
                if #_G.AutoBuySelected > 0 and fetchStock() then
                    for _, itemName in ipairs(_G.AutoBuySelected) do
                        if not _G.AutoBuyActive then break end
                        buyItem(itemName)
                        task.wait(0.3)
                    end
                end
                task.wait(5)
            end
        end)
    end
})
local DungeonConfig = require(
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DungeonConfig")
)
local RequestDungeonPortal =
ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestDungeonPortal")
local dungeonOptions = {}
local dungeonMap = {}
for id,data in pairs(DungeonConfig.Dungeons) do
    table.insert(dungeonOptions,data.DisplayName)
    dungeonMap[data.DisplayName] = id
end
local SelectedDungeon = dungeonOptions[1]
DunTab:CreateDropdown({
    Name = "Dungeon",
    Options = dungeonOptions,
    CurrentOption = dungeonOptions[1],
    Flag = "DungeonSelect",
    Callback = function(option)
        if typeof(option) == "table" then
            option = option[1]
        end
        SelectedDungeon = option
    end
})
local sdun = game:GetService("Players").LocalPlayer.PlayerGui.DungeonPortalJoinUI.LeaveButton.Visible
DunTab:CreateToggle({
    Name = "Auto Join Dungeon",
    CurrentValue = false,
    Flag = "AutoJoinDungeon",
    Callback = function(v)
        _G.AutoJoinDungeon = v
        if game.PlaceId == 99684056491472 then return end
        if v then
            task.spawn(function()
                while _G.AutoJoinDungeon do
                if sdun then break end
                    local dungeonId = dungeonMap[SelectedDungeon]
                    if dungeonId then
                        RequestDungeonPortal:FireServer(dungeonId)
                    else
                    end
                    task.wait(4)
                end
            end)
        end
    end
})
local VoteRemote   = ReplicatedStorage.Remotes:WaitForChild("DungeonWaveVote")
local ReplayRemote = ReplicatedStorage.Remotes:WaitForChild("DungeonWaveReplayVote")
local DungeonSync  = ReplicatedStorage.RemoteEvents:WaitForChild("DungeonWaveSync")
local SelectedDifficulty = "Hard"
local lastDifficulty     = nil   
local hasVoted           = false 
local hasReplayed        = false 
local lastSyncPhase      = nil
_G.AutoVoteDungeon  = false
_G.AutoReplayDungeon = false
DungeonSync.OnClientEvent:Connect(function(data)
    local phase = data.phase
    if phase == "active" and data.difficulty then
        lastDifficulty = data.difficulty
    end
    if phase == "voting" and lastSyncPhase ~= "voting" then
        hasVoted = false
    end
    if phase == "cleared" and lastSyncPhase ~= "cleared" then
        hasReplayed = false
    end
    if phase == "cleared" and not hasReplayed and not data.replaySponsor then
        if _G.AutoReplayDungeon then
            task.delay(2, function()
                if not hasReplayed and _G.AutoReplayDungeon
                and not (data.replaySponsor) then
                    hasReplayed = true
                    pcall(function() ReplayRemote:FireServer("sponsor") end)
                end
            end)
        end
    end
    lastSyncPhase = phase
end)
DunTab:CreateDropdown({
    Name = "Dungeon Difficulty",
    Options = {"Easy","Medium","Hard","Extreme"},
    CurrentOption = {"Hard"},
    Flag = "DungeonDifficulty",
    Callback = function(option)
        if typeof(option) == "table" then
            option = option[1]
        end
        SelectedDifficulty = option
    end
})
DunTab:CreateToggle({
    Name = "Auto Vote Difficulty",
    CurrentValue = false,
    Flag = "AutoVoteDungeon",
    Callback = function(v)
        _G.AutoVoteDungeon = v
        if v then
            task.spawn(function()
                local actions =
                player.PlayerGui:WaitForChild("DungeonUI")
                .ContentFrame.Actions
                while _G.AutoVoteDungeon do
                    if actions.EasyDifficultyFrame.Visible then
                        VoteRemote:FireServer(SelectedDifficulty)
                        task.wait(2) 
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})
DunTab:CreateToggle({
    Name = "Auto Replay Dungeon",
    CurrentValue = false,
    Flag = "AutoReplayDungeon",
    Callback = function(v)
        _G.AutoReplayDungeon = v
        if v and lastSyncPhase == "cleared" and not hasReplayed then
            hasReplayed = true
            pcall(function() ReplayRemote:FireServer("sponsor") end)
        end
    end
})
Rayfield:LoadConfiguration()