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
local QuestAcceptRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("QuestAccept")
local QuestAbandonRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("QuestAbandon")
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
local npcTypeToQuest = {}  
local NORMAL_MOBS = {}
local BOSSES      = {}
local seenPrefixes = {}
local npcIslandCache = {}  
local QUEST_TITLE_MAP = {}   
local QUEST_ORDER     = {}   
local LEVEL_QUEST_ORDER = {}
local MOB_OPTIONS,  MOB_BY_DISPLAY  = {}, {}
local BOSS_OPTIONS, BOSS_BY_DISPLAY = {}, {}
local patternCache = {}
for _, m in ipairs(NORMAL_MOBS) do table.insert(MOB_OPTIONS,  m.display); MOB_BY_DISPLAY[m.display]  = m end
for _, b in ipairs(BOSSES)      do table.insert(BOSS_OPTIONS, b.display); BOSS_BY_DISPLAY[b.display] = b end
local TeleportRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TeleportToPortal")
local NPCRegistry = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("NPCRegistry"))
local PortalConfig = require(ReplicatedStorage:WaitForChild("PortalConfig"))
local QuestConfig  = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("QuestConfig"))
local IslandToPortal = {}
for portalId, data in pairs(PortalConfig.Portals) do
    IslandToPortal[data.IslandFolder] = portalId
end
local islandPositions = {}
local TOTAL_DISTANCE = 10
local TWEEN_SPEED    = 10
local FARM_POSITION  = "Below"
local BODY_VEL_NAME  = "AutoTweenBodyVelocity"
local bodyVelocity
local noclipActive   = false
local modifiedParts  = {}
for islandFolder, _ in pairs(IslandToPortal) do
    local island = workspace:FindFirstChild(islandFolder)
    if island then
        local anchor = nil
        for _, child in ipairs(island:GetChildren()) do
            if child.Name:lower():find("spawnpoint") or child.Name:lower():find("crystal") then
                anchor = child
                break
            end
        end
        if not anchor then
            anchor = island:FindFirstChildWhichIsA("BasePart", true)
                  or island:FindFirstChildWhichIsA("Model")
        end
        if anchor then
            local ok, pos = pcall(function() return anchor:GetPivot().Position end)
            if ok then
                islandPositions[islandFolder] = pos
            else
            end
        else
            local ok, pos = pcall(function() return island:GetPivot().Position end)
            if ok then
                islandPositions[islandFolder] = pos
            else
            end
        end
    else
    end
end
local function getClosestIsland(worldPos)
    local closest, closestDist = nil, math.huge
    for islandFolder, pos in pairs(islandPositions) do
        local d = (worldPos - pos).Magnitude
        if d < closestDist then closestDist = d; closest = islandFolder end
    end
    return closest
end
local function getPlayerLevel()
    local data = player:FindFirstChild("Data")
    local lvl = data:FindFirstChild("Level")
    return lvl and lvl.Value
end
local function buildNPCIslandMap()
    local npcFolder = workspace:FindFirstChild("NPCs")
    if not npcFolder then return end
    local samples = {}  
    for _, model in ipairs(npcFolder:GetChildren()) do
        if model:IsA("Model") then
             name = model.Name
             prefix = name:match("^(.-)%d+$")
             key = prefix or name  
            if not samples[key] then
                local ok, pos = pcall(function() return model:GetPivot().Position end)
                if ok then samples[key] = pos end
            end
        end
    end
    for key, pos in pairs(samples) do
        npcIslandCache[key] = getClosestIsland(pos)
    end
end
buildNPCIslandMap()
workspace:FindFirstChild("NPCs").ChildAdded:Connect(function(model)
    if not model:IsA("Model") then return end
     name   = model.Name
     prefix = name:match("^(.-)%d+$")
     key    = prefix or name
    if not npcIslandCache[key] then
        task.defer(function()
            local ok, pos = pcall(function() return model:GetPivot().Position end)
            if ok then npcIslandCache[key] = getClosestIsland(pos) end
        end)
    end
end)
if QuestConfig and QuestConfig.RepeatableQuests then
    for npcName, questData in pairs(QuestConfig.RepeatableQuests) do
        if questData.title then
            QUEST_TITLE_MAP[npcName] = questData.title
        end
        if questData.requirements and questData.recommendedLevel then
            for _, req in ipairs(questData.requirements) do
                if req.npcType then
                    table.insert(QUEST_ORDER, {
                        minLevel = questData.recommendedLevel,
                        questNPC = npcName,
                        npcType  = req.npcType,   
                        title    = questData.title,
                    })
                end
            end
        end
    end
    table.sort(QUEST_ORDER, function(a, b) return a.minLevel < b.minLevel end)
end
for _, entry in ipairs(QUEST_ORDER) do
    npcTypeToQuest[entry.npcType] = {
        questNPC = entry.questNPC,
        minLevel = entry.minLevel,
    }
end
local extraBosses = {
            { name = "YamatoBoss", display = "Yamato Boss" },
}
for _, npcName in ipairs(NPCRegistry.Categories.Combat) do
    prefix, num = npcName:match("^(.-)(%d+)$")
    if prefix and num then
        if not seenPrefixes[prefix] then
            seenPrefixes[prefix] = true
            local q = npcTypeToQuest[prefix]
            local entry = {
                display  = prefix,
                prefix   = prefix,
                island   = npcIslandCache[prefix],  
                questNPC = q and q.questNPC or nil,
                minLevel = q and q.minLevel or 0,
            }
            table.insert(NORMAL_MOBS, entry)
            table.insert(MOB_OPTIONS, prefix)
            MOB_BY_DISPLAY[prefix] = entry
        end
    else
        local q = npcTypeToQuest[npcName]
        local entry = {
            display  = npcName,
            name     = npcName,
            island   = npcIslandCache[npcName],  
            questNPC = q and q.questNPC or nil,
            minLevel = q and q.minLevel or 0,
        }
        table.insert(BOSSES, entry)
        table.insert(BOSS_OPTIONS, npcName)
        BOSS_BY_DISPLAY[npcName] = entry
        for _, extra in ipairs(extraBosses) do
            local q = npcTypeToQuest[extra.name]
            local entry = {
                display  = extra.display,
                name     = extra.name,
                questNPC = q and q.questNPC or nil,
                minLevel = q and q.minLevel or 0,
            }
            table.insert(BOSSES, entry)
            table.insert(BOSS_OPTIONS, extra.display)
            BOSS_BY_DISPLAY[extra.display] = entry
        end
    end
end
local function findNpcDataByType(npcType)
    if MOB_BY_DISPLAY[npcType] then return MOB_BY_DISPLAY[npcType] end
    if BOSS_BY_DISPLAY[npcType] then return BOSS_BY_DISPLAY[npcType] end
    for prefix, data in pairs(MOB_BY_DISPLAY) do
        if npcType:match(prefix) or prefix:match(npcType) then
            return data
        end
    end
    for name, data in pairs(BOSS_BY_DISPLAY) do
        if npcType:match(name) or name:match(npcType) then
            return data
        end
    end
    return nil
end
for npcType, questInfo in pairs(npcTypeToQuest) do
    local npcData = findNpcDataByType(npcType)
    if npcData then
        table.insert(LEVEL_QUEST_ORDER, { minLevel = questInfo.minLevel, data = npcData })
    else
        warn("[LEVEL_QUEST_ORDER] no npcData for npcType:", npcType)
    end
end
table.sort(LEVEL_QUEST_ORDER, function(a, b) return a.minLevel < b.minLevel end)
for npcType, questInfo in pairs(npcTypeToQuest) do
    local npcData = MOB_BY_DISPLAY[npcType]  
    if not npcData then
        npcData = BOSS_BY_DISPLAY[npcType]   
    end
    if npcData then
        table.insert(LEVEL_QUEST_ORDER, {
            minLevel = questInfo.minLevel,
            data     = npcData,
        })
    end
end
table.sort(LEVEL_QUEST_ORDER, function(a, b) return a.minLevel < b.minLevel end)
local function getBestTargetForLevel(level)
    local best = nil
    for _, entry in ipairs(LEVEL_QUEST_ORDER) do
        if level >= entry.minLevel and entry.data then
            best = entry.data
        end
    end
    return best or NORMAL_MOBS[1]
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
local function resolveIsland(npcDataOrInstance)
    if not npcDataOrInstance then return nil end
    if typeof(npcDataOrInstance) == "Instance" then
        local mName  = npcDataOrInstance.Name or ""
        local prefix = mName:match("^(.-)%d+$")
        local key    = prefix or mName
        return npcIslandCache[key]
    end
    if type(npcDataOrInstance) == "table" then
        local key = npcDataOrInstance.prefix or npcDataOrInstance.name or ""
        return npcIslandCache[key]
    end
    return nil
end
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
local function disableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME then
            pcall(function() inst:Destroy() end)
        end
    end
    bodyVelocity = nil
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
    if noclipLoop then noclipLoop:Disconnect() end
    noclipLoop = game:GetService("RunService").Stepped:Connect(function()
        if not noclipActive then return end
        local char = player.Character
        if not char then return end    
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
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
local function teleportToIsland(portalId)
    local data = PortalConfig.Portals[portalId]
    if not data then
        TeleportRemote:FireServer(portalId)
        return
    end
    local islandFolder = data.IslandFolder
    local island = workspace:FindFirstChild(islandFolder)
    if not island then
        TeleportRemote:FireServer(portalId)
        return
    end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local islandPos = islandPositions[islandFolder]
    if islandPos then
        local dist = (hrp.Position - islandPos).Magnitude
        if dist < 300 then
            return 
        end
    end
    TeleportRemote:FireServer(portalId)
end
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
local FARM_PRIORITY = { summonBoss = 4, boss = 3, bossAll = 3, enemy = 2, nearest = 1, level = 2 }
local farmHasTarget    = {}
local activeConnections    = {}
local charAddedConnections = {}
local diedConnections      = {}
local isTeleporting        = {}
local function stopFarm(key)
    if activeConnections[key] then
        activeConnections[key]:Disconnect()
        activeConnections[key] = nil
    end
    farmHasTarget[key] = false
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
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    disableBodyControl(hrp)
    local anyActive = false
    if not anyActive then stopNoclip() end
end
local function onCharacterAdded_farm(character, key)
    if diedConnections[key] then diedConnections[key]:Disconnect() end
    local hum = character:FindFirstChildWhichIsA("Humanoid")
    if hum then
        diedConnections[key] = hum.Died:Connect(function()
            stopFarm(key)
            local deadHRP = character:FindFirstChild("HumanoidRootPart")
            disableBodyControl(deadHRP)
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
        enableBodyControl(player.Character:FindFirstChild("HumanoidRootPart"))
        startNoclip()
    end
    activeConnections[key] = RunService.Heartbeat:Connect(function()
        if not isActiveFunc() or not isPlayerAlive() then
            stopFarm(key)
            stopNoclip()
            return
        end
        local myPriority = FARM_PRIORITY[key] or 0
        for otherKey, otherPriority in pairs(FARM_PRIORITY) do
            if otherKey ~= key
            and otherPriority > myPriority
            and activeConnections[otherKey]
            and farmHasTarget[otherKey] then
                farmHasTarget[key] = false
                return
            end
        end
        if isTeleporting[key] then return end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local list = npcDataList
        local bestModel, bestDist, bestData = nil, math.huge, nil
        for _, npcData in ipairs(list) do
            local model, dist = findTargetByData(npcData)
            if model and dist < bestDist then
                bestModel = model
                bestDist  = dist
                bestData  = npcData
            end
        end
        farmHasTarget[key] = bestModel ~= nil
        if not bestModel then return end
        if bestDist > 600 then
            local islandFolder = resolveIsland(bestData)
            if islandFolder then
                local portalId = IslandToPortal[islandFolder]
                if portalId then
                    isTeleporting[key] = true
                    task.spawn(function()
                        teleportToIsland(portalId)
                        task.wait(1)
                        isTeleporting[key] = false
                    end)
                end
            end
            return
        end
        if not bodyVelocity or not bodyVelocity.Parent then
            enableBodyControl(hrp)
        end
        local desiredPos, targetPos = getDesiredPosition(hrp, bestModel)
        local lerpedXZ = Vector3.new(
            hrp.Position.X + (desiredPos.X - hrp.Position.X) * (TWEEN_SPEED * 0.015),
            desiredPos.Y,
            hrp.Position.Z + (desiredPos.Z - hrp.Position.Z) * (TWEEN_SPEED * 0.015)
        )
        hrp.CFrame                 = CFrame.new(lerpedXZ, targetPos)
        hrp.AssemblyLinearVelocity = Vector3.zero
        if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end
    end)
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
    Name = "Auto Leveling",
    CurrentValue = false,
    Flag = "auto_level",
    Callback = function(value)
        _G.AutoLevelActive = value
        if not value then
            stopFarmFull("level")
            return
        end
        task.spawn(function()
            local lastTarget = nil
            while _G.AutoLevelActive do
                if isPlayerAlive() then
                    local level      = getPlayerLevel()
                    local bestTarget = getBestTargetForLevel(level)
                    if bestTarget and bestTarget.questNPC then
                        local active      = hasActiveQuest()
                        local expected    = QUEST_TITLE_MAP[bestTarget.questNPC]
                        local needsAccept = not active
                            or (expected and active:lower() ~= expected:lower())
                        if needsAccept then
                            local wasRunning = lastTarget == bestTarget
                            stopFarm("level")
                            local targetModel, dist = findTargetByData(bestTarget)
                            if dist > 600 then
                                local islandFolder = resolveIsland(bestTarget)
                                if islandFolder then
                                    local portalId = IslandToPortal[islandFolder]
                                    if portalId then
                                        teleportToIsland(portalId)
                                        task.wait(1)
                                    end
                                end
                            end
                            acceptQuest(bestTarget.questNPC)
                            if wasRunning then
                                startFarmLoop("level", bestTarget, function() return _G.AutoLevelActive end)
                            else
                                lastTarget = nil  
                            end
                        end
                    end
                    if bestTarget ~= lastTarget then
                        lastTarget = bestTarget
                        startFarmLoop("level", bestTarget, function() return _G.AutoLevelActive end)
                    end
                    task.wait(5)
                else
                    stopFarm("level")
                    disableBodyControl(player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
                    lastTarget = nil
                    task.wait(3)
                end
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
    return closestModel, closestDist
end
ManTab:CreateToggle({
    Name = "Auto Farm Nearest", CurrentValue = false, Flag = "auto_nearest",
    Callback = function(value)
        _G.AutoNearestActive = value
        if not value then
            stopFarmFull("nearest")
            return
        end
        stopFarm("nearest")
        isTeleporting["nearest"] = false
        if charAddedConnections["nearest"] then
            charAddedConnections["nearest"]:Disconnect()
        end
        charAddedConnections["nearest"] = player.CharacterAdded:Connect(function(char)
            onCharacterAdded_farm(char, "nearest")
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then enableBodyControl(hrp) end
            startNoclip()
        end)
        if player.Character then
            onCharacterAdded_farm(player.Character, "nearest")
            enableBodyControl(player.Character:FindFirstChild("HumanoidRootPart"))
            startNoclip()
        end
        activeConnections["nearest"] = RunService.Heartbeat:Connect(function()
            if not _G.AutoNearestActive or not isPlayerAlive() then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                stopFarm("nearest")
                disableBodyControl(hrp)
                stopNoclip()
                return
            end
            local myPriority = FARM_PRIORITY["nearest"] or 0
            for otherKey, otherPriority in pairs(FARM_PRIORITY) do
                if otherKey ~= "nearest"
                and otherPriority > myPriority
                and activeConnections[otherKey]
                and farmHasTarget[otherKey] then
                    farmHasTarget["nearest"] = false
                    return
                end
            end
            if isTeleporting["nearest"] then return end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local model, dist = findNearestAny()
            farmHasTarget["nearest"] = model ~= nil
            if not model then return end
            if dist > 300 then
                local ok, npcPos = pcall(function() return model:GetPivot().Position end)
                if ok then
                    local islandFolder = getClosestIsland(npcPos)
                    if islandFolder then
                        local portalId = IslandToPortal[islandFolder]
                        if portalId then
                            isTeleporting["nearest"] = true
                            task.spawn(function()
                                teleportToIsland(portalId)
                                local deadline = tick() + 6
                                repeat
                                    task.wait(0.3)
                                    local _, d = findNearestAny()
                                    if d and d <= 300 then break end
                                until tick() > deadline
                                isTeleporting["nearest"] = false
                            end)
                        end
                        return
                    end
                end
                return
            end
            if not bodyVelocity or not bodyVelocity.Parent then
                enableBodyControl(hrp)
            end
            local desiredPos, targetPos = getDesiredPosition(hrp, model)
            local lerpedXZ = Vector3.new(
                hrp.Position.X + (desiredPos.X - hrp.Position.X) * (TWEEN_SPEED * 0.015),
                desiredPos.Y,
                hrp.Position.Z + (desiredPos.Z - hrp.Position.Z) * (TWEEN_SPEED * 0.015)
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
        merchantStock[itemName].stock = result.newStock
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
local LeaveButton = game:GetService("Players").LocalPlayer
    .PlayerGui:WaitForChild("DungeonPortalJoinUI"):WaitForChild("LeaveButton")
local function isInDungeon()
    return LeaveButton.Visible
end
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
                    if isInDungeon() then
                        task.wait(1)
                        continue
                    end
                    local dungeonId = dungeonMap[SelectedDungeon]
                    if dungeonId then
                        RequestDungeonPortal:FireServer(dungeonId)
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
local SummonBossConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("SummonableBossConfig"))
local RequestSummonBoss = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestSummonBoss")
local SummonBossResult  = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SummonBossResult")
local BossUIShow        = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BossUIShow")
local _cachedPity    = 0
local _cachedMaxPity = 25
BossUIShow.OnClientEvent:Connect(function(data)
    if not data then return end
    if data.pity    then _cachedPity    = data.pity    end
    if data.maxPity then _cachedMaxPity = data.maxPity end
end)
local function getPityValues()
    return _cachedPity, _cachedMaxPity
end
local function isSummonBossAlive()
    local npcFolder = workspace:FindFirstChild("NPCs")
    if not npcFolder then return false end
    for bossId in pairs(SummonBossConfig:GetAllBosses()) do
        local model = npcFolder:FindFirstChild(bossId)
        if model then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                return true
            end
        end
    end
    return false
end
local function summonAndFarm(bossId, difficulty)
    local bossData = SummonBossConfig:GetBoss(bossId)
    if not bossData then return end
    if bossData.hasDifficulty then
        pcall(function()
            RequestSummonBoss:FireServer(bossId, difficulty or "Normal")
        end)
    else
        pcall(function()
            RequestSummonBoss:FireServer(bossId)
        end)
    end
    local tempData = { name = bossId, island = "Boss" }
    startFarmLoop("summonBoss", { tempData }, function()
        return _G.AutoSummonBossActive
    end)
end
local SUMMON_BOSS_OPTIONS = {}
local SUMMON_BOSS_IDS     = {}
for bossId, bossData in pairs(SummonBossConfig:GetAllBosses()) do
    table.insert(SUMMON_BOSS_OPTIONS, bossData.displayName or bossId)
    SUMMON_BOSS_IDS[bossData.displayName or bossId] = bossId
end
table.sort(SUMMON_BOSS_OPTIONS)
_G.AutoSummonBossActive = false
_G.PityProtection       = false
local DEFAULT_BOSS = "Saber"
local selectedSummonBoss = SUMMON_BOSS_IDS[DEFAULT_BOSS] or SUMMON_BOSS_IDS[SUMMON_BOSS_OPTIONS[1]]
local selectedSummonDifficulty = "Normal"
ManTab:CreateDropdown({
    Name = "Summon Boss", Options = SUMMON_BOSS_OPTIONS,
    CurrentOption = { DEFAULT_BOSS }, Flag = "summon_boss_select",
    Callback = function(s)
        selectedSummonBoss = SUMMON_BOSS_IDS[s[1]] or selectedSummonBoss  
    end
})
ManTab:CreateDropdown({
    Name = "Summon Difficulty", Options = {"Normal","Medium","Hard","Extreme"},
    CurrentOption = {"Normal"}, Flag = "summon_diff_select",
    Callback = function(s)
        selectedSummonDifficulty = s[1] or "Normal"
    end
})
ManTab:CreateToggle({
    Name = "Pity Protection",
    CurrentValue = false, Flag = "pity_protection",
    Callback = function(v) _G.PityProtection = v end
})
ManTab:CreateToggle({
    Name = "Auto Summon Boss Farm",
    CurrentValue = false, Flag = "auto_summon_boss",
    Callback = function(value)
        _G.AutoSummonBossActive = value
        if not value then stopFarmFull("summonBoss") return end
        task.spawn(function()
            while _G.AutoSummonBossActive do
                if isPlayerAlive() then
                    if _G.PityProtection then
                        local cur, max = getPityValues()
                        if cur >= max - 1 then
                            repeat
                                task.wait(0.5)
                                cur = getPityValues()
                            until cur < max - 1 or not _G.PityProtection or not _G.AutoSummonBossActive
                            if not _G.AutoSummonBossActive then break end
                        end
                    end
                    if isSummonBossAlive() then
                        task.wait(1)
                        continue
                    end
                    summonAndFarm(selectedSummonBoss, selectedSummonDifficulty)
                end
                task.wait(1)
            end
        end)
    end
})
local CodesConfig   = require(ReplicatedStorage:WaitForChild("CodesConfig"))
local CodeRedeem    = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("CodeRedeem")
InvTab:CreateButton({
    Name = "Redeem All Codes",
    Callback = function()
        local codes = CodesConfig.Codes
        if not codes then
            return
        end
        task.spawn(function()
            for code in pairs(codes) do
                local ok, result = pcall(function()
                    return CodeRedeem:InvokeServer(code)
                end)
                if ok then
                else
                    warn("[Codes] Failed:", code, result)
                end
                task.wait(0.5) 
            end
        end)
    end
})
local function tweenToNPC(npcNameOrModel, onArrival)
    local target
    if typeof(npcNameOrModel) == "Instance" then
        target = npcNameOrModel
    else
        local serviceNPCs = workspace:FindFirstChild("ServiceNPCs")
        if serviceNPCs then
            for _, npc in ipairs(serviceNPCs:GetChildren()) do
                if npc.Name == npcNameOrModel and npc:IsA("Model") then
                    target = npc
                    break
                end
            end
        end
    end
    if not target then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local timeout = tick() + 15
    local STEP_DIST = TWEEN_SPEED * 0.05 * 40
    while tick() < timeout do
        local npcPos = target:GetPivot().Position
        local diff   = npcPos - hrp.Position
        local dist   = diff.Magnitude
        if dist <= 6 then break end
        local desiredPos = npcPos - diff.Unit * 5
        local toTarget   = desiredPos - hrp.Position
        local moveDist   = math.min(STEP_DIST, toTarget.Magnitude) 
        local nextPos    = hrp.Position + toTarget.Unit * moveDist
        enableBodyControl(hrp)
        startNoclip()
        hrp.CFrame = CFrame.new(Vector3.new(nextPos.X, desiredPos.Y, nextPos.Z))
        if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end
        task.wait(0.05)
    end
    disableBodyControl(hrp)
    stopNoclip()
    if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end
    task.wait(0.2)
    if onArrival then
        onArrival()
    end
end
local RS = game:GetService("ReplicatedStorage")
local TeleportRemote = RS:WaitForChild("Remotes"):WaitForChild("TeleportToPortal")
local serviceNPCs = workspace:WaitForChild("ServiceNPCs")
local NPCIslandMap = {}
do
    local islandAnchors = {}
    for _, island in ipairs(workspace:GetChildren()) do
        if island:IsA("Model") then
            local anchor = nil
            for _, child in ipairs(island:GetChildren()) do
                local name = child.Name:lower()
                if name:find("spawnpoint") then
                    anchor = child
                    break
                end
            end
            if anchor then
                local ok, pos = pcall(function()
                    return anchor:GetPivot().Position
                end)
                if ok then
                    table.insert(islandAnchors, {
                        name = island.Name,
                        position = pos
                    })
                end
            end
        end
    end
    for _, npc in ipairs(serviceNPCs:GetChildren()) do
        if npc:IsA("Model") then
            local npcPos = npc:GetPivot().Position
            local closestIsland
            local shortest = math.huge
            for _, islandData in ipairs(islandAnchors) do
                local dist = (npcPos - islandData.position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closestIsland = islandData.name
                end
            end
            NPCIslandMap[npc.Name] = closestIsland
        end
    end
end
for _, npc in ipairs(serviceNPCs:GetChildren()) do
    if npc:IsA("Model") then
        local ok, pos = pcall(function() return npc:GetPivot().Position end)
        if ok then
            local islandFolder = getClosestIsland(pos)        
            local portalId     = islandFolder and IslandToPortal[islandFolder]
            if portalId then
                NPCIslandMap[npc.Name] = { island = islandFolder, portal = portalId }
            end
        end
    end
end
local function smartTweenToNPC(npcName)
    local npc = serviceNPCs:FindFirstChild(npcName)
    if not npc then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (npc:GetPivot().Position - hrp.Position).Magnitude
    if dist >= 300 then
        local entry = NPCIslandMap[npcName]
        if entry then
            teleportToIsland(entry.portal)
            task.wait(1.5)
            tweenToNPC(npc)
        end    
    end
end
local SERVICE_NPC_OPTIONS = {}
for _, npc in ipairs(serviceNPCs:GetChildren()) do
    if npc:IsA("Model") then
        table.insert(SERVICE_NPC_OPTIONS, npc.Name)
    end
end
table.sort(SERVICE_NPC_OPTIONS)
local selectedServiceNPC = SERVICE_NPC_OPTIONS[1]
InvTab:CreateDropdown({
    Name = "Select NPC",
    Options = SERVICE_NPC_OPTIONS,
    CurrentOption = { SERVICE_NPC_OPTIONS[1] or "" },
    Flag = "tween_npc_select",
    Callback = function(s)
        selectedServiceNPC = s[1]
    end
})
InvTab:CreateButton({
    Name = "Tween to NPC",
    Callback = function()
        if not selectedServiceNPC then return end
        task.spawn(function()
            smartTweenToNPC(selectedServiceNPC)
        end)
    end
})
Rayfield:LoadConfiguration()