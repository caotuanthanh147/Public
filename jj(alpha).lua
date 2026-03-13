repeat task.wait() until game:IsLoaded()
local plr = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
pcall(function()
    plr.PlayerGui["Main Menu"]:Destroy()
    plr.PlayerGui.Logo_Loader:Destroy()
end)
rs.requests.character.spawn:FireServer()
rs.requests.character_server_client.communicate:FireServer()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "EpicHub",
   Icon = 4483345998,
   LoadingTitle = "Loading EpicHub...",
   LoadingSubtitle = "Please wait while the script initializes.",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EpicHub",
      FileName = "Settings"
   },
})

local ManTab = Window:CreateTab("Main", 4483345998)
local MiscTab = Window:CreateTab("Misc", 4483345998)
local ExTab = Window:CreateTab("Extra", 4483345998)
local InvTab = Window:CreateTab("Inventory", 4483345998)
local SkillTab = Window:CreateTab("Skill", 4483345998)
local QTab = Window:CreateTab("Quest", 4483345998)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local autoRetryActive = false
ExTab:CreateToggle({
    Name = "Auto Retry Raid",
    Flag = "lesbian100",
    CurrentValue = false,
    Callback = function(value)
        autoRetryActive = value
        if value then
            task.spawn(function()
                while autoRetryActive do
                    local ok, enabled = pcall(function()
                        return player.PlayerGui.raidcomplete.Enabled
                    end)
                    if ok and enabled then
                        pcall(function()
                            ReplicatedStorage.requests.character.retryraid:FireServer()
                        end)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
local ftween = true
local isVoiding = false
local RunService = game:GetService("RunService")
local TOTAL_DISTANCE = 10
local BODY_VEL_NAME = "AutoTweenBodyVelocity"
local BODY_GYRO_NAME = "AutoTweenBodyGyro"
local connection, charAddedConnection, humanoidDiedConnection
local currentTargetPart
local bodyVelocity, bodyGyro
local noclipActive, noclipThread = false, nil
local modifiedParts = {}
local function enableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
            pcall(function() inst:Destroy() end)
        end
    end
    hrp.Anchored = false
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = BODY_VEL_NAME
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = hrp
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = BODY_GYRO_NAME
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 8000
    bodyGyro.D = 200
    bodyGyro.Parent = hrp
end
local function startNoclip()
    if noclipActive then return end
    noclipActive = true
    noclipThread = task.spawn(function()
        while noclipActive do
            if player.Character then
                for _, child in pairs(player.Character:GetDescendants()) do
                    if child:IsA("BasePart") then
                        modifiedParts[child] = true
                        pcall(function() child.CanCollide = false end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end
local function stopNoclip()
    noclipActive = false
    noclipThread = nil
    for part in pairs(modifiedParts) do
        if part and part.Parent then
            pcall(function() part.CanCollide = true end)
        end
    end
    modifiedParts = {}
end
local function findTarget()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local myPos = hrp.Position
    local playerChars = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then playerChars[pl.Character] = true end
    end
    local liveFolder = workspace:FindFirstChild("Live")
    if not liveFolder then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, desc in ipairs(liveFolder:GetDescendants()) do
        if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" and not playerChars[desc.Parent] and desc.Parent.Name ~= "Server" and not desc.Parent.Name:match("Hostage") then
            local hum = desc.Parent:FindFirstChildOfClass("Humanoid")
            if hum and (not ftween or hum.Health > 0) then
                local d = (desc.Position - myPos).Magnitude
                if d < nearestDist and d <= 2000 then
                    nearest, nearestDist = desc, d
                end
            end
        end
    end
    return nearest
end
local function isPlayerAlive()
    if not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead
end
local function stopAll(hrp)
    currentTargetPart = nil
    _G.isAutoTweening = false
    stopNoclip()
end
local function onCharacterAdded(character)
    if humanoidDiedConnection then humanoidDiedConnection:Disconnect() humanoidDiedConnection = nil end
    currentTargetPart = nil
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoidDiedConnection = humanoid.Died:Connect(function()
            stopAll(character:FindFirstChild("HumanoidRootPart"))
        end)
    end
end
ExTab:CreateToggle({
    Name = "Farm Monster",
    CurrentValue = false,
    Flag = "lesbian5",
    Callback = function(value)
        _G.isAutoCollectActive = value
        if value then
            if not charAddedConnection then
                charAddedConnection = player.CharacterAdded:Connect(onCharacterAdded)
            end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            enableBodyControl(hrp)
            startNoclip()
            connection = RunService.Heartbeat:Connect(function()
                if isVoiding then return end
                if not isPlayerAlive() or not _G.isAutoCollectActive then
                    local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    stopAll(h)
                    return
                end
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                currentTargetPart = findTarget()
                if not currentTargetPart then return end
                if not bodyVelocity or not bodyGyro then enableBodyControl(hrp) end
                local desiredPos = currentTargetPart.Position + Vector3.new(0, -TOTAL_DISTANCE, 0)
                local diff = desiredPos - hrp.Position
                if diff.Magnitude > 30 then
                    hrp.CFrame = CFrame.new(desiredPos, currentTargetPart.Position)
                    bodyVelocity.Velocity = diff * 10
                else
                    local lerpedXZ = Vector3.new(
                        hrp.Position.X + (desiredPos.X - hrp.Position.X) * 0.15,
                        desiredPos.Y,
                        hrp.Position.Z + (desiredPos.Z - hrp.Position.Z) * 0.15
                    )
                    hrp.CFrame = CFrame.new(lerpedXZ, currentTargetPart.Position)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    bodyVelocity.Velocity = Vector3.zero
                end
            end)
        else
            if connection then connection:Disconnect() connection = nil end
            if charAddedConnection then charAddedConnection:Disconnect() charAddedConnection = nil end
            if humanoidDiedConnection then humanoidDiedConnection:Disconnect() humanoidDiedConnection = nil end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            stopAll(hrp)
        end
    end
})
local VOID_NAMES = {"Jotaro", "Kira", "Avdol", "DIO"}
local function isVoidTarget(hrpPart)
    if not hrpPart or not hrpPart.Parent then return false end
    local name = hrpPart.Parent.Name
    for _, n in ipairs(VOID_NAMES) do
        if name:lower():match(n:lower()) then return true end
    end
    return false
end
isPhase2 = false
local savedPos = nil
local voidConnection, voidCharAddedConnection, voidHumanoidDiedConnection
local iframeConnections = {}
local iframeSeen = {}     
local healthJumped = {}   
local lastHealth = {}
local function watchIFrame(npcModel)
    local npcName = npcModel.Name
    if iframeConnections[npcName] then return end
    iframeConnections[npcName] = true
    npcModel.ChildAdded:Connect(function(child)
        if child.Name == "IFrame" then
            child.AncestryChanged:Connect(function()
                if not child.Parent then
                    if healthJumped[npcName] then
                        iframeSeen[npcName] = true
                        
                    end
                end
            end)
        end
    end)
end
ExTab:CreateToggle({
    Name = "Void Farm",
    CurrentValue = false,
    Flag = "lesbian6",
    Callback = function(value)
        if value then
            if not voidCharAddedConnection then
                voidCharAddedConnection = player.CharacterAdded:Connect(function(character)
                    if voidHumanoidDiedConnection then voidHumanoidDiedConnection:Disconnect() voidHumanoidDiedConnection = nil end
                    isVoiding = false
                    isPhase2 = false
                    savedPos = nil
                    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid then
                        voidHumanoidDiedConnection = humanoid.Died:Connect(function()
                            isVoiding = false
                            isPhase2 = false
                            savedPos = nil
                        end)
                    end
                end)
            end
            voidConnection = RunService.Heartbeat:Connect(function()
                if not isPlayerAlive() then return end
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local targetHRP = currentTargetPart
                local lastTarget = targetHRP
                if not targetHRP or not targetHRP.Parent then
                    if isVoiding and savedPos then
                        hrp.CFrame = CFrame.new(savedPos)
                    end
                    isVoiding = false
                    isPhase2 = false
                    savedPos = nil
                    if lastTarget and lastTarget.Parent then
                        local n = lastTarget.Parent.Name
                        iframeConnections[n] = nil
                        iframeSeen[n] = nil
                        healthJumped[n] = nil
                        lastHealth[n] = nil
                    end
                    return
                end
                if not isVoidTarget(targetHRP) then
                    isVoiding = false
                    return
                end
                watchIFrame(targetHRP.Parent)
                local npcName = targetHRP.Parent.Name
                local hum = targetHRP.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    local currentHP = hum.Health
                    local prevHP = lastHealth[npcName]
                    lastHealth[npcName] = currentHP
                    if prevHP then
                        if currentHP > (prevHP + 500) then
                           
                            healthJumped[npcName] = true
                        end
                    end
                end
                if iframeSeen[npcName] and healthJumped[npcName] then
                    isPhase2 = true
                end
                local npcAnchored = targetHRP.Anchored
                if npcAnchored and isPhase2 then
                    if not isVoiding then
                        savedPos = hrp.Position
                        isVoiding = true
                    end
                    
                    hrp.CFrame = CFrame.new(targetHRP.Position.X, -475, targetHRP.Position.Z)
                else
                    if isVoiding and not npcAnchored then
                        isPhase2 = false
                    end
                    isVoiding = false
                end
            end)
        else
            isVoiding = false
            isPhase2 = false
            savedPos = nil
            iframeConnections = {}
            iframeSeen = {}
            healthJumped = {}
            lastHealth = {}
            if voidConnection then voidConnection:Disconnect() voidConnection = nil end
            if voidCharAddedConnection then voidCharAddedConnection:Disconnect() voidCharAddedConnection = nil end
            if voidHumanoidDiedConnection then voidHumanoidDiedConnection:Disconnect() voidHumanoidDiedConnection = nil end
        end
    end
})
ExTab:CreateInput({
    Name = "Distance",
    CurrentValue = FOLLOW_DISTANCE,
    PlaceholderText = "Radius",
    Flag = "lesbian4",
    Callback = function(Value)
        local number = tonumber(Value)
        if number then
            TOTAL_DISTANCE = number
        end
    end
})
local workspace = game:GetService("Workspace")
local threads = {}
local skillsEnabled = {}
local function startLoop(key, fn)
    if threads[key] then return end
    local token = {}
    threads[key] = token
    task.spawn(function()
        while threads[key] == token do
            if _G.isAutoCollectActive then
                local ok, err = pcall(fn)
                if not ok then warn("AutoSkill["..key.."] error:", err) end
            end
            task.wait(0.1)
        end
    end)
end
local function stopLoop(key)
    threads[key] = nil
end
local skillCooldowns = {}
local standCooldownConnection = nil
local cachedSkillNames = {}
local function getSkillNameForKeybind(keybind)
    if cachedSkillNames[keybind] then return cachedSkillNames[keybind] end
    local char = player.Character
    if not char then return nil end
    local standName = char:GetAttribute("SummonedStand")
    if not standName then return nil end
    local ok, skillsData = pcall(function()
        return game:GetService("ReplicatedStorage").requests.miscellaneous:WaitForChild("get_data"):InvokeServer("ability")
    end)
    if not ok or not skillsData then return nil end
    for skillId, skill in pairs(skillsData) do
        if skill.AbilityType == "Stand" and string.split(skillId, ": ")[1] == standName and skill.Keybind == keybind then
            cachedSkillNames[keybind] = skill.Name
            return skill.Name
        end
    end
    return nil
end
local function isOnCooldown(keybind)
    local direct = skillCooldowns[keybind]
    if direct and tick() < direct then return true end
    local skillName = getSkillNameForKeybind(keybind)
    if skillName then
        local endTime = skillCooldowns[skillName]
        if endTime and tick() < endTime then return true end
    end
    return false
end
local function startCooldownTracking()
    if standCooldownConnection then return end
    local standCooldownRemote = game:GetService("ReplicatedStorage").requests.general:WaitForChild("StandCooldown")
    standCooldownConnection = standCooldownRemote.OnClientEvent:Connect(function(skillName, duration)
        skillCooldowns[skillName] = tick() + duration
    end)
end
local function stopCooldownTracking()
    if standCooldownConnection then
        standCooldownConnection:Disconnect()
        standCooldownConnection = nil
    end
    skillCooldowns = {}
    cachedSkillNames = {}
end
local function fireSkill(key, ...)
    local args = {...}
    local char = player.Character
    if not char then return end
    local controller = char:WaitForChild("client_character_controller", 3)
    if not controller then warn("No controller for", key) return end
    local remote = controller:WaitForChild(key, 3)
    if not remote then warn("No remote:", key) return end
    if not currentTargetPart then return end
    if currentTargetPart.Parent and currentTargetPart.Parent:FindFirstChild("IFrame") then return end
    local keybind = args[1] == "Skill" and args[2] or nil
    if keybind and isOnCooldown(keybind) then return end
    remote:FireServer(table.unpack(args))
end
local function anySkillEnabled()
    for _, v in pairs(skillsEnabled) do
        if v then return true end
    end
    return false
end
local function runSkillLoop()
    if threads["skills"] then return end
    startLoop("skills", function()
        if skillsEnabled["E"] and not isOnCooldown("E") then
            fireSkill("Skill", "E", true)
        end
        if skillsEnabled["R"] and not isOnCooldown("R") then
            fireSkill("Skill", "R", true)
        end
        if skillsEnabled["Z"] and not isOnCooldown("Z") then
            fireSkill("Skill", "Z", true)
        end
        if skillsEnabled["C"] and not isOnCooldown("C") then
            fireSkill("Skill", "C", true)
        end
        if skillsEnabled["V"] and not isOnCooldown("V") then
            fireSkill("Skill", "V", true)
        end
        if skillsEnabled["X"] and isPhase2 and not isOnCooldown("X") then
            fireSkill("Skill", "X", true)
        end
        if skillsEnabled["M2"] and not isOnCooldown("M2 CD") then
            fireSkill("M2", true, false)
        end
        if skillsEnabled["M1"] and not isOnCooldown("M1 CD") then
            fireSkill("M1", true, false)
        end
    end)
end
local function onToggleSkill(key, enabled)
    skillsEnabled[key] = enabled
    if enabled then
        startCooldownTracking()
        runSkillLoop()
    else
        if not anySkillEnabled() then
            stopLoop("skills")
            stopCooldownTracking()
        end
    end
end
local character = player.Character or player.CharacterAdded:Wait()
local autoSummon = false
SkillTab:CreateToggle({ Name = "Auto Summon Stand", CurrentValue = false, Flag = "AutoSummonStand", Callback = function(state)
    autoSummon = state
    if autoSummon then
        task.spawn(function()
            while autoSummon do
                if _G.isAutoCollectActive then
                    character = player.Character
                    if not character or not character.Parent then
                        player.CharacterAdded:Wait()
                        character = player.Character
                    end
                    local playerFolder = workspace:FindFirstChild("Live") and workspace.Live:FindFirstChild(player.Name)
                    if playerFolder then
                        local v = playerFolder:GetAttribute("SummonedStand")
                        if v == nil or v == "" or v == false then
                            local controller = character and character:FindFirstChild("client_character_controller")
                            if controller and controller:FindFirstChild("SummonStand") then
                                pcall(function() controller.SummonStand:FireServer() end)
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end })
SkillTab:CreateToggle({ Name = "Auto M1",      CurrentValue = false, Flag = "lesbian101", Callback = function(v) onToggleSkill("M1", v) end })
SkillTab:CreateToggle({ Name = "Auto M2",      CurrentValue = false, Flag = "lesbian102", Callback = function(v) onToggleSkill("M2", v) end })
SkillTab:CreateToggle({ Name = "Auto Skill E", CurrentValue = false, Flag = "lesbian103", Callback = function(v) onToggleSkill("E",  v) end })
SkillTab:CreateToggle({ Name = "Auto Skill R", CurrentValue = false, Flag = "lesbian104", Callback = function(v) onToggleSkill("R",  v) end })
SkillTab:CreateToggle({ Name = "Auto Skill Z", CurrentValue = false, Flag = "lesbian105", Callback = function(v) onToggleSkill("Z",  v) end })
SkillTab:CreateToggle({ Name = "Auto Skill C", CurrentValue = false, Flag = "lesbian106", Callback = function(v) onToggleSkill("C",  v) end })
SkillTab:CreateToggle({ Name = "Auto Skill X", CurrentValue = false, Flag = "lesbian107", Callback = function(v) onToggleSkill("X",  v) end })
SkillTab:CreateToggle({ Name = "Auto Skill V", CurrentValue = false, Flag = "lesbian108", Callback = function(v) onToggleSkill("V",  v) end })
local priorStat = { "PvEDamage" }
local HttpService       = game:GetService("HttpService")
local Players           = game:GetService("Players")
local SlotData            = Players.LocalPlayer:WaitForChild("PlayerData"):WaitForChild("SlotData")
local Inventory           = SlotData:WaitForChild("Inventory")
local r = game:GetService("ReplicatedStorage").requests.character.use_item
local EquippedAccessories = SlotData:WaitForChild("EquippedAccessories")
local equipRemote         = ReplicatedStorage.requests.character:WaitForChild("equip_accessory")
local sellRemote          = ReplicatedStorage.requests.general:WaitForChild("SellItem")
local getData             = ReplicatedStorage.requests.miscellaneous:WaitForChild("get_data")
local accessoryData       = getData:InvokeServer("accessory")
local pipBonus = {
    Health             = 2,
    HealthRegeneration = 2,
    Defense            = 0.25,
    Power              = 3,
    PowerRegeneration  = 2,
    Penetration        = 2.5,
    PvEDamage          = 5
}
local function applyPips(item, accInfo)
    local stats = {}
    for k, v in pairs(accInfo) do
        if type(v) == "number" then stats[k] = v end
    end
    if item.Pips then
        for _, pip in pairs(item.Pips) do
            if pipBonus[pip] then
                stats[pip] = (stats[pip] or 0) + pipBonus[pip]
            end
        end
    end
    return stats
end
local function deepEqual(a, b, sa, sb)
    sa, sb = sa or {}, sb or {}
    if a == b then return true end
    if type(a) ~= type(b) then return false end
    if type(a) ~= "table" then return a == b end
    if sa[a] and sb[b] then return sa[a] == b and sb[b] == a end
    sa[a] = b; sb[b] = a
    for k, v in pairs(a) do
        if b[k] == nil or not deepEqual(v, b[k], sa, sb) then return false end
    end
    for k in pairs(b) do
        if a[k] == nil then return false end
    end
    return true
end
local function scoreItem(item, accInfo)
    local stats = applyPips(item, accInfo)
    local total = 0
    local statCount = 0
    for _, val in pairs(stats) do
        if val > 0 then
            total += val
            statCount += 1
        end
    end
    local pipCount = item.Pips and #item.Pips or 0
    if priorStat and #priorStat > 0 then
        local statName = priorStat[1]
        local v = stats[statName]
        return { primary = v or 0, total = total, statCount = statCount, pipCount = pipCount }
    elseif priorStat then
        for statName, minVal in pairs(priorStat) do
            local v = stats[statName]
            if not v or v < minVal then return nil end
        end
    end
    return { primary = total, total = total, statCount = statCount, pipCount = pipCount }
end
local function isBetter(newScore, oldScore)
    if type(newScore) == "table" and type(oldScore) == "table" then
        if newScore.primary ~= oldScore.primary then return newScore.primary > oldScore.primary end
        if newScore.total ~= oldScore.total then return newScore.total > oldScore.total end
        if newScore.statCount ~= oldScore.statCount then return newScore.statCount > oldScore.statCount end
        return newScore.pipCount > oldScore.pipCount
    end
    return newScore > oldScore
end
local function getBestPerType(inventory)
    local bestPerType = {}
    for _, item in pairs(inventory) do
        if item.Locked then continue end
        local accInfo = accessoryData[item.Name]
        if not accInfo or not accInfo.AccessoryType then continue end
        local score = scoreItem(item, accInfo)
        if score == nil then continue end
        local slot = accInfo.AccessoryType
        if not bestPerType[slot] or isBetter(score, bestPerType[slot].score) then
            bestPerType[slot] = { item = item, accInfo = accInfo, score = score }
        end
    end
    return bestPerType
end
local function unequipAll()
    local equippedNow = HttpService:JSONDecode(EquippedAccessories.Value)
    for slot, item in pairs(equippedNow) do
        local accInfo = accessoryData[item.Name]
        if accInfo then
            equipRemote:FireServer({ Name = item.Name, Original = item, Data = item, New = accInfo })
            task.wait(0.35)
        end
    end
end
InvTab:CreateButton({
    Name = "Equip Best",
    Callback = function()
        unequipAll()
        local inventory = HttpService:JSONDecode(Inventory.Value)
        local bestPerType = getBestPerType(inventory)
        for slot, best in pairs(bestPerType) do
            equipRemote:FireServer({
                Name     = best.item.Name,
                Original = best.item,
                Data     = best.item,
                New      = best.accInfo
            })
            task.wait(0.35)
        end
    end
})
InvTab:CreateButton({
    Name = "Sell Items",
    Callback = function()
        local inventory = HttpService:JSONDecode(Inventory.Value)
        local equipped  = HttpService:JSONDecode(EquippedAccessories.Value)
        local bestPerType = getBestPerType(inventory)
        local toSell, seen = {}, {}
        for _, item in pairs(inventory) do
            if item.Locked then continue end
            local accInfo = accessoryData[item.Name]
            if not accInfo then continue end
            local slot = accInfo.AccessoryType
            if deepEqual(equipped[slot], item) then continue end
            if bestPerType[slot] and deepEqual(bestPerType[slot].item, item) then continue end
            if item.ID then
                table.insert(toSell, { ID = item.ID, Name = item.Name, Pips = item.Pips, duplicates = 1 })
            else
                local key = item.Name
                if seen[key] then
                    seen[key].duplicates += 1
                else
                    local entry = { Name = item.Name, Pips = item.Pips, duplicates = 1 }
                    seen[key] = entry
                    table.insert(toSell, entry)
                end
            end
        end
        if #toSell > 0 then
            sellRemote:FireServer(toSell)
        end
    end
})
InvTab:CreateButton({
    Name = "Open All Chests",
    Callback = function()
        
        for _, v in ipairs({"Rare Chest", "Legendary Chest", "Common Chest"}) do
            r:FireServer(v, { UseAll = true })
            task.wait(0.3)
        end
    end
})
local vfxRandom = ReplicatedStorage.modules.vfx.random
local targets = {
    [vfxRandom["Lucky Arrow Common"]] = {"Common", false},
    [vfxRandom["Lucky Arrow Mythical"]] = {"Mythical", true},
    [vfxRandom["Lucky Arrow Rare"]] = {"Rare", false},
}
local autoArrow = false
local vfxConnection = nil
local busyConnection = nil
local isBusy = false

local function waitUntilReady()
    while isBusy do
        task.wait()
    end
end

local function stopAuto()
    autoArrow = false
    if vfxConnection then
        vfxConnection:Disconnect()
        vfxConnection = nil
    end
    if busyConnection then
        busyConnection:Disconnect()
        busyConnection = nil
    end
    isBusy = false
end

InvTab:CreateToggle({
    Name = "Auto Lucky Arrow",
    CurrentValue = false,
    Callback = function(value)
        if value then
            autoArrow = true
            busyConnection = ReplicatedStorage.requests.character_server_client.communicate.OnClientEvent:Connect(function(data)
                if data.Player ~= Players.LocalPlayer then return end
                isBusy = data.Busy
            end)
            vfxConnection = ReplicatedStorage.requests.general.vfx.OnClientEvent:Connect(function(module, data)
                if data.Character ~= Players.LocalPlayer.Character then return end
                local info = targets[module]
                if info then
                    local rarity, shouldStop = info[1], info[2]
                    if shouldStop then
                        stopAuto()
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Lucky Arrow",
                            Text = rarity .. " obtained!",
                            Duration = 5
                        })
                    end
                end
            end)
            task.spawn(function()
                while autoArrow do
                    waitUntilReady()
                    if not autoArrow then break end
                    ReplicatedStorage:WaitForChild("requests"):WaitForChild("character"):WaitForChild("use_item"):FireServer("Lucky Arrow")
                    task.wait()
                end
            end)
        else
            stopAuto()
        end
    end
})
local lp                = Players.LocalPlayer
local notification      = ReplicatedStorage.requests.general.notification
local running = { main = false, alt = false }
local function getNearestBoard()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local boards = workspace.Map["Mission Boards"].PvP:GetChildren()
    local nearest, nearestDist = nil, math.huge
    for _, board in ipairs(boards) do
        local prompt = board:FindFirstChild("ProximityPrompt")
        if not prompt then continue end
        local boardPos
        if board:IsA("BasePart") then
            boardPos = board.Position
        elseif board:IsA("Model") and board.PrimaryPart then
            boardPos = board.PrimaryPart.Position
        else
            continue
        end
        local dist = (boardPos - root.Position).Magnitude
        if dist < nearestDist then
            nearest = board
            nearestDist = dist
        end
    end
    return nearest
end
local function joinQueue()
    local joined = false
    local debounce = false
    local leftCooldown = false
    local conn = notification.OnClientEvent:Connect(function(msg)
        if debounce then return end
        debounce = true
        if msg == "Joined PvP Mission Queue." then
            joined = true
        elseif msg == "Left PvP Mission Queue." then
            joined = false
            leftCooldown = true
            task.delay(1.5, function()
                leftCooldown = false
            end)
        end
        task.wait(0.2)
        debounce = false
    end)
    while not joined do
        if not leftCooldown then
            local board = getNearestBoard()
            if board then
                local prompt = board:FindFirstChild("ProximityPrompt")
                local boardPos
                if board:IsA("BasePart") then
                    boardPos = board.Position
                elseif board:IsA("Model") and board.PrimaryPart then
                    boardPos = board.PrimaryPart.Position
                end
                if boardPos then
                    local char = lp.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = CFrame.new(boardPos + Vector3.new(0, 3, 0))
                    end
                end
                task.wait(0.2)
                if prompt then
                    fireproximityprompt(prompt)
                end
            end
        end
        task.wait(0.5)
    end
    conn:Disconnect()
end
local function waitForNotification(...)
    local patterns = { ... }
    local found = false
    local conn = notification.OnClientEvent:Connect(function(msg)
        for _, pattern in ipairs(patterns) do
            if msg:lower():match(pattern) then
                found = true
                break
            end
        end
    end)
    repeat task.wait(0.3) until found
    conn:Disconnect()
end
local function resetCharacter()
    local char = lp.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end
local function waitForRespawn()
    local oldChar = lp.Character
    repeat task.wait(0.5) until lp.Character ~= oldChar
    repeat task.wait(0.5) until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    task.wait(0.5)
end
ManTab:CreateToggle({
    Name = "PvP Queue (Main)",
    CurrentValue = false,
    Callback = function(value)
        running.main = value
        if not value then return end
        task.spawn(function()
            while running.main do
                joinQueue()
                waitForNotification("Your opponent")    
                waitForNotification("Complete") 
            end
        end)
    end
})
ManTab:CreateToggle({
    Name = "PvP Queue (Alt)",
    CurrentValue = false,
    Callback = function(value)
        running.alt = value
        if not value then return end
        task.spawn(function()
            while running.alt do
                joinQueue()
                waitForNotification("Your opponent") 
                resetCharacter()
                waitForRespawn()
            end
        end)
    end
})
local questIndex = 1
QTab:CreateButton({
    Name = "Teleport to Quest",
    Callback = function()
        local root = game:GetService("Players").LocalPlayer.Character
            and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local markers = {}
        for _, child in ipairs(workspace.Effects.questbrick:GetChildren()) do
            local questMarker = child:FindFirstChild("Quest Marker")
            if questMarker and questMarker.Enabled then
                table.insert(markers, child)
            end
        end
        if #markers == 0 then return end
        if questIndex > #markers then questIndex = 1 end
        local marker = markers[questIndex]
        local pos = marker:IsA("BasePart") and marker.Position
            or (marker:IsA("Model") and marker.PrimaryPart and marker.PrimaryPart.Position)
        if not pos then return end
        root.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
        questIndex = questIndex % #markers + 1
    end
})
Rayfield:LoadConfiguration()