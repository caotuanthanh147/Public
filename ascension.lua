local s, e = pcall(function()
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RelkzzRebranded/Bypassed---OBFUSCATED..../main/Adonis%20BYPASS.lua"))()
end)
end)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "EpicHub",
   Icon = 4483345998,
   LoadingTitle = "Loading EpicHub...",
   LoadingSubtitle = "Please wait while the script initializes.",
   Theme =  {
    TextColor = Color3.fromRGB(240, 240, 240),
    
    Background = Color3.fromRGB(10, 10, 15),
    Topbar = Color3.fromRGB(15, 15, 25),
    Shadow = Color3.fromRGB(0, 0, 0),
    
    NotificationBackground = Color3.fromRGB(20, 20, 30),
    NotificationActionsBackground = Color3.fromRGB(0, 255, 230),
    
    TabBackground = Color3.fromRGB(20, 20, 30),
    TabStroke = Color3.fromRGB(0, 255, 230),
    TabBackgroundSelected = Color3.fromRGB(0, 255, 230),
    TabTextColor = Color3.fromRGB(200, 200, 200),
    SelectedTabTextColor = Color3.fromRGB(0, 15, 20),
    
    ElementBackground = Color3.fromRGB(25, 25, 35),
    ElementBackgroundHover = Color3.fromRGB(30, 30, 45),
    SecondaryElementBackground = Color3.fromRGB(15, 15, 25),
    ElementStroke = Color3.fromRGB(0, 255, 230),
    SecondaryElementStroke = Color3.fromRGB(0, 200, 180),
    
    SliderBackground = Color3.fromRGB(40, 40, 50),
    SliderProgress = Color3.fromRGB(0, 255, 230),
    SliderStroke = Color3.fromRGB(0, 200, 180),
    
    ToggleBackground = Color3.fromRGB(30, 30, 40),
    ToggleEnabled = Color3.fromRGB(0, 255, 230),
    ToggleDisabled = Color3.fromRGB(80, 80, 90),
    ToggleEnabledStroke = Color3.fromRGB(0, 200, 180),
    ToggleDisabledStroke = Color3.fromRGB(60, 60, 70),
    ToggleEnabledOuterStroke = Color3.fromRGB(0, 150, 130),
    ToggleDisabledOuterStroke = Color3.fromRGB(40, 40, 50),
    
    DropdownSelected = Color3.fromRGB(0, 255, 230),
    DropdownUnselected = Color3.fromRGB(30, 30, 40),
    
    InputBackground = Color3.fromRGB(20, 20, 30),
    InputStroke = Color3.fromRGB(0, 200, 180),
    PlaceholderColor = Color3.fromRGB(100, 100, 120)
}, 
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EpicHub",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})
function notify(message, title, time)
   Rayfield:Notify({
      Title = tostring(title),
      Content = tostring(message),
      Duration = tonumber(time),
      Image = 4483345998
   })
end

local ManTab = Window:CreateTab("Main", 4483345998)
local MiscTab = Window:CreateTab("Misc", 4483345998)
local CTab = Window:CreateTab("Inventory", 4483345998)
local ExTab = Window:CreateTab("Extra", 4483345998)
local PTab = Window:CreateTab("Prompt", 4483345998)


local Players = game:GetService("Players")
local player = Players.LocalPlayer
local function findClosestTeleporter()
    if not player.Character then return nil end
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    local closestTeleporter = nil
    local closestDistance = 15
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("TouchTransmitter") and obj.Name == "TouchInterest" then
            local teleporterPart = obj.Parent
            if teleporterPart and teleporterPart:IsA("Part") then
                local distance = (rootPart.Position - teleporterPart.Position).Magnitude
                if distance <= closestDistance then
                    closestDistance = distance
                    closestTeleporter = teleporterPart
                end
            end
        end
    end
    return closestTeleporter
end
local function teleportToPad(teleporterPart)
    if not player.Character then return false end
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    local teleporterCFrame = teleporterPart.CFrame
    local positionAbove = teleporterCFrame.Position + Vector3.new(0, 5, 0) 
    pcall(function()
        rootPart.CFrame = CFrame.new(positionAbove)
    end)
    task.wait(0.135)
    return true
end
local function activateTeleporter(teleporterPart)
    if not player.Character then return end
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local teleported = teleportToPad(teleporterPart)
    if not teleported then return end
    if firetouchinterest then
        firetouchinterest(teleporterPart, rootPart, 0)
        task.wait(0.01)
        firetouchinterest(teleporterPart, rootPart, 1)
    end
    local teleporterModel = teleporterPart.Parent
    if teleporterModel then
        for _, descendant in pairs(teleporterModel:GetDescendants()) do
            if descendant:IsA("ClickDetector") and descendant.Name == "ClickDetector" then
                if fireclickdetector then
                    task.wait(0.02)
                    fireclickdetector(descendant)
                end
                break
            end
        end
    end
end
local teleporterEnabled = false
local teleporterTask
MiscTab:CreateToggle({
   Name = "Teleport Pad",
   CurrentValue = false,
   Callback = function(value)
      local ok, err = pcall(function()
         teleporterEnabled = value
         if teleporterEnabled then
             if not teleporterTask or coroutine.status(teleporterTask) == "dead" then
                 teleporterTask = task.spawn(function()
                     while teleporterEnabled do
                         local tp = findClosestTeleporter()
                         if tp then
                             pcall(function() activateTeleporter(tp) end)
                         end
                         task.wait(0.01) 
                     end
                 end)
             end
         else
             teleporterEnabled = false
         end
      end)
      if not ok then
      end
   end,
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local DODGE_RANGE = 40
local DODGE_COOLDOWN = 0.01
local SAFE_MARGIN = 3
local MAX_PREDICT_TIME = 1.2
local PLAYER_CLEARANCE = 2.5
local GROUND_CHECK_DEPTH = 25
local MIN_SAFE_CLEARANCE = 1.0
local FAR_ESCAPE_DISTANCE = 40
local MOB_DETECTION_RANGE = 25
local MIN_MOB_MOVEMENT_SPEED = 2.0
local STATIONARY_TIME_THRESHOLD = 5.0  
local POSITION_TOLERANCE = 0.5  
local SAMPLE_ANGLES = 32
local BASE_SAMPLE_RADII = {3, 6, 10, 15, 22}
local HIGH_THREAT_SAMPLE_RADII = {3, 6, 10, 15, 22, 30, 33, 40}
local GRID_STEP = 3
local GRID_RADIUS = 25
local bulletDodgeConnection = nil
local lastDodgeTime = 0
local threatCache = {
    bullets = {},
    mobs = {},
    lastUpdate = 0,
    cacheLifetime = 0.1
}
local mobMovementHistory = {}
local mobLastPositions = {}
local mobStationaryStartTimes = {}  
local performanceStats = {
    lastFrameTime = 0,
    avgProcessingTime = 0,
    threatCount = 0
}
local function isMobAnimate(mob, currentPosition)
    local humanoid = mob:FindFirstChildOfClass("Humanoid")
    if humanoid then
        return true 
    end
    local now = tick()
    local lastPos = mobLastPositions[mob]
    if not mobMovementHistory[mob] then
        mobMovementHistory[mob] = {}
        mobStationaryStartTimes[mob] = nil
    end
    if not lastPos then
        mobLastPositions[mob] = currentPosition
        mobStationaryStartTimes[mob] = now 
        return false 
    end
    local movement = (currentPosition - lastPos).Magnitude
    local isMoving = movement > MIN_MOB_MOVEMENT_SPEED
    mobLastPositions[mob] = currentPosition
    if isMoving then
        mobStationaryStartTimes[mob] = nil
        return true
    else
        local positionChangedSignificantly = movement > POSITION_TOLERANCE
        if positionChangedSignificantly then
            mobStationaryStartTimes[mob] = nil
            return false
        else
            if not mobStationaryStartTimes[mob] then
                mobStationaryStartTimes[mob] = now
            end
            local stationaryTime = now - mobStationaryStartTimes[mob]
            if stationaryTime > STATIONARY_TIME_THRESHOLD then
                return false 
            else
                return true 
            end
        end
    end
end
local function calculateInterceptionTime(bulletPos, bulletVel, playerPos, playerVel)
    local relativePos = bulletPos - playerPos
    local relativeVel = bulletVel - playerVel
    local a = relativeVel:Dot(relativeVel)
    local b = 2 * relativePos:Dot(relativeVel)
    local c = relativePos:Dot(relativePos) - SAFE_MARGIN^2
    local discriminant = b^2 - 4*a*c
    if discriminant < 0 then return nil end
    local t1 = (-b - math.sqrt(discriminant)) / (2*a)
    local t2 = (-b + math.sqrt(discriminant)) / (2*a)
    local validTime = nil
    if t1 >= 0 and t1 <= MAX_PREDICT_TIME then
        validTime = t1
    elseif t2 >= 0 and t2 <= MAX_PREDICT_TIME then
        validTime = t2
    end
    return validTime
end
local function updateThreatCache(character)
    local now = tick()
    if now - threatCache.lastUpdate < threatCache.cacheLifetime then
        return
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local playerPos = hrp.Position
    table.clear(threatCache.bullets)
    table.clear(threatCache.mobs)
    local bulletsFolder = Workspace:FindFirstChild("Bullets")
    if bulletsFolder then
        for _, obj in ipairs(bulletsFolder:GetChildren()) do
            if obj:IsA("BasePart") then
                local dist = (obj.Position - playerPos).Magnitude
                if dist <= DODGE_RANGE then
                    table.insert(threatCache.bullets, {
                        object = obj,
                        position = obj.Position,
                        velocity = obj.Velocity or Vector3.new(0,0,0),
                        radius = math.max(obj.Size.X, obj.Size.Y, obj.Size.Z) * 0.5,
                        type = "bullet",
                        lastUpdate = now
                    })
                end
            end
        end
    end
    local mobFolder = Workspace:FindFirstChild("MobFolder")
    if mobFolder then
        for _, mob in ipairs(mobFolder:GetChildren()) do
            if mob:IsA("Model") then
                local rootPart = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
                if rootPart then
                    local mobPos = rootPart.Position
                    local dist = (mobPos - playerPos).Magnitude
                    if dist <= MOB_DETECTION_RANGE then
                        if isMobAnimate(mob, mobPos) then
                            local mobSize = rootPart.Size.Magnitude
                            if mob:FindFirstChildOfClass("Humanoid") then
                                mobSize = 4 
                            end
                            table.insert(threatCache.mobs, {
                                object = rootPart,
                                position = mobPos,
                                velocity = rootPart.Velocity or Vector3.new(0,0,0),
                                radius = mobSize * 0.8,
                                type = "mob",
                                lastUpdate = now
                            })
                        elseif _G.DebugDodge then
                            print("Whitelisted stationary mob:", mob.Name, "at position:", mobPos)
                        end
                    end
                end
            end
        end
    end
    threatCache.lastUpdate = now
    performanceStats.threatCount = #threatCache.bullets + #threatCache.mobs
end
local function getAllThreats(character)
    updateThreatCache(character)
    local allThreats = {}
    for _, threat in ipairs(threatCache.bullets) do
        table.insert(allThreats, threat)
    end
    for _, threat in ipairs(threatCache.mobs) do
        table.insert(allThreats, threat)
    end
    return allThreats
end
local function predictThreatPosition(threat, playerPos, playerVel)
    local pos = threat.position
    local vel = threat.velocity
    if threat.type == "bullet" then
        local t = calculateInterceptionTime(pos, vel, playerPos, playerVel or Vector3.new(0,0,0))
        if t then
            return pos + vel * t
        end
        local relative = pos - playerPos
        local velDot = vel:Dot(vel)
        if velDot > 0.001 then
            local fallbackTime = math.clamp(-vel:Dot(relative) / velDot, 0, MAX_PREDICT_TIME)
            return pos + vel * fallbackTime
        end
    elseif threat.type == "mob" then
        if vel.Magnitude > 1 then
            local toPlayer = (playerPos - pos).Unit
            local mobSpeed = math.min(vel.Magnitude, 10)
            local t = math.min((pos - playerPos).Magnitude / math.max(mobSpeed, 5), MAX_PREDICT_TIME)
            return pos + toPlayer * mobSpeed * t
        end
    end
    return pos
end
local function getOptimalSampleRadii(threatCount)
    if threatCount > 5 then
        return HIGH_THREAT_SAMPLE_RADII
    else
        return BASE_SAMPLE_RADII
    end
end
local function getOptimalSampleAngles(threatCount)
    if threatCount > 3 then
        return 48
    else
        return 32
    end
end
local function generateEscapeCandidates(character, threats)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end
    local playerPos = hrp.Position
    local candidates = {}
    local threatCount = #threats
    local sampleRadii = getOptimalSampleRadii(threatCount)
    local sampleAngles = getOptimalSampleAngles(threatCount)
    for _, radius in ipairs(sampleRadii) do
        for i = 1, sampleAngles do
            local angle = (i / sampleAngles) * math.pi * 2
            local offset = Vector3.new(
                math.cos(angle) * radius,
                PLAYER_CLEARANCE,
                math.sin(angle) * radius
            )
            table.insert(candidates, playerPos + offset)
        end
    end
    if threatCount > 0 then
        for _, threat in ipairs(threats) do
            local predictedPos = predictThreatPosition(threat, playerPos, hrp.Velocity)
            local avoidRadius = threat.radius + SAFE_MARGIN + 2
            for i = 1, 6 do
                local angle = (i / 6) * math.pi * 2
                local offset = Vector3.new(
                    math.cos(angle) * avoidRadius,
                    0,
                    math.sin(angle) * avoidRadius
                )
                table.insert(candidates, predictedPos + offset + Vector3.new(0, PLAYER_CLEARANCE, 0))
            end
        end
    end
    for i = 1, 8 do
        local angle = (i / 8) * math.pi * 2
        local offset = Vector3.new(
            math.cos(angle) * FAR_ESCAPE_DISTANCE,
            PLAYER_CLEARANCE,
            math.sin(angle) * FAR_ESCAPE_DISTANCE
        )
        table.insert(candidates, playerPos + offset)
    end
    return candidates
end
local function isPositionSafe(character, position, threats)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    for _, threat in ipairs(threats) do
        local threatPos = predictThreatPosition(threat, position, hrp.Velocity)
        local distance = (Vector3.new(position.X, threatPos.Y, position.Z) - threatPos).Magnitude
        local requiredDistance = threat.radius + SAFE_MARGIN
        if distance < requiredDistance then
            return false
        end
    end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    local direction = position - hrp.Position
    if direction.Magnitude > 0.1 then
        local hit = Workspace:Raycast(hrp.Position, direction, rayParams)
        if hit then return false end
    end
    local groundHit = Workspace:Raycast(
        position + Vector3.new(0, 2, 0),
        Vector3.new(0, -GROUND_CHECK_DEPTH, 0),
        rayParams
    )
    return groundHit ~= nil
end
local function scoreCandidate(character, position, threats)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return -999999 end
    local playerPos = hrp.Position
    local score = 0
    local minThreatDistance = 999999
    local totalThreatDistance = 0
    for _, threat in ipairs(threats) do
        local threatPos = predictThreatPosition(threat, position, hrp.Velocity)
        local distance = (position - threatPos).Magnitude - threat.radius
        if distance < minThreatDistance then
            minThreatDistance = distance
        end
        totalThreatDistance = totalThreatDistance + distance
    end
    score = score + minThreatDistance * 15
    score = score + (totalThreatDistance / math.max(#threats, 1)) * 2
    local moveDistance = (position - playerPos).Magnitude
    score = score - moveDistance * 0.3
    local centerDistance = (position - playerPos).Magnitude
    if centerDistance < 10 then
        score = score + 5
    end
    return score
end
local function findBestEscapePosition(character, threats)
    if #threats == 0 then return nil end
    local startTime = tick()
    local candidates = generateEscapeCandidates(character, threats)
    local bestScore = -999999
    local bestPosition = nil
    for _, candidate in ipairs(candidates) do
        if isPositionSafe(character, candidate, threats) then
            local score = scoreCandidate(character, candidate, threats)
            if score > bestScore then
                bestScore = score
                bestPosition = candidate
            end
        end
    end
    if not bestPosition then
        for _, candidate in ipairs(candidates) do
            local score = scoreCandidate(character, candidate, threats)
            if score > bestScore then
                bestScore = score
                bestPosition = candidate
            end
        end
    end
    local processingTime = tick() - startTime
    performanceStats.avgProcessingTime = (performanceStats.avgProcessingTime * 0.9) + (processingTime * 0.1)
    performanceStats.lastFrameTime = processingTime
    return bestPosition
end
local function executeDodge(character)
    local now = tick()
    if now - lastDodgeTime < DODGE_COOLDOWN then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local threats = getAllThreats(character)
    if #threats == 0 then return false end
    local escapePos = findBestEscapePosition(character, threats)
    if not escapePos then return false end
    hrp.CFrame = CFrame.new(escapePos, escapePos + hrp.CFrame.LookVector)
    lastDodgeTime = now
    return true
end
local function startUltimateDodge()
    if bulletDodgeConnection then
        bulletDodgeConnection:Disconnect()
    end
    bulletDodgeConnection = RunService.Heartbeat:Connect(function()
        if not _G.UltimateAutoDodge then return end
        if performanceStats.avgProcessingTime > 0.016 then
            threatCache.cacheLifetime = 0.2
        else
            threatCache.cacheLifetime = 0.1
        end
        local character = player.Character
        if not character then return end
        if not character:FindFirstChild("HumanoidRootPart") then return end
        executeDodge(character)
    end)
end
local function stopUltimateDodge()
    if bulletDodgeConnection then
        bulletDodgeConnection:Disconnect()
        bulletDodgeConnection = nil
    end
    table.clear(threatCache.bullets)
    table.clear(threatCache.mobs)
    table.clear(mobMovementHistory)
    table.clear(mobLastPositions)
    table.clear(mobStationaryStartTimes)
end
_G.GetDodgePerformanceStats = function()
    return performanceStats
end
_G.GetWhitelistedMobs = function()
    local whitelisted = {}
    local now = tick()
    for mob, stationaryTime in pairs(mobStationaryStartTimes) do
        if mob:IsDescendantOf(Workspace) then
            local stationaryDuration = now - stationaryTime
            if stationaryDuration > STATIONARY_TIME_THRESHOLD then
                table.insert(whitelisted, {
                    mob = mob,
                    name = mob.Name,
                    stationaryTime = stationaryDuration
                })
            end
        end
    end
    return whitelisted
end
ExTab:CreateToggle({
    Name = "Auto Dodge",
    CurrentValue = false,
    Callback = function(value)
        _G.UltimateAutoDodge = value
        if value then
            startUltimateDodge()
        else
            stopUltimateDodge()
        end
    end
})
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local isKillAllActive = false
local killAllCoroutine = nil
local HEALTH_DAMAGE_THRESHOLD = 100  
MiscTab:CreateToggle({
    Name = "Kill All Mobs",
    Flag = "lesbian4",
    CurrentValue = false,
    Callback = function(value)
        if isKillAllActive == value then return end
        isKillAllActive = value
        if isKillAllActive then
            
                sethiddenproperty(Players.LocalPlayer, "SimulationRadius", 1124)
                sethiddenproperty(Players.LocalPlayer, "MaxSimulationRadius", 1124)
            
            if killAllCoroutine and coroutine.status(killAllCoroutine) ~= "dead" then return end
            killAllCoroutine = coroutine.create(function()
                while isKillAllActive do
                    local mobFolder = Workspace:FindFirstChild("MobFolder")
                    if mobFolder then
                        local desc = mobFolder:GetDescendants()
                        for _, d in ipairs(desc) do
                            if d.ClassName == "Humanoid" then
                                local model = d.Parent
                                if model and not Players:GetPlayerFromCharacter(model) then
                                    local ok, cur, max = pcall(function() 
                                        return d.Health, d.MaxHealth 
                                    end)
                                    if ok and type(cur) == "number" and type(max) == "number" and max > 0 then
                                        if (max - cur) >= HEALTH_DAMAGE_THRESHOLD or cur <= HEALTH_DAMAGE_THRESHOLD then
                                            
                                                d.Health = 0
                                            
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
            coroutine.resume(killAllCoroutine)
        else
            isKillAllActive = false
            if killAllCoroutine then
                pcall(function() 
                    coroutine.close(killAllCoroutine) 
                end)
                killAllCoroutine = nil
            end
        end
    end
})
_G.CeliaActive = _G.CeliaActive or false
local CeliaThreads = {}
local CeliaHooks = {}
local function findRemotesByPattern(pattern)
    local bulletsFolder = workspace:FindFirstChild("Bullets")
    if not bulletsFolder then
        return {}
    end
    local remotes = {}  
    for _, child in pairs(bulletsFolder:GetChildren()) do  
        if child:IsA("RemoteEvent") and string.find(child.Name, pattern) then  
            table.insert(remotes, child)  
        end  
    end  
    return remotes
end
local function hookSpecificRemote(remote)
    if CeliaHooks[remote] then
        return 
    end
    local oldFire = remote.FireServer
    CeliaHooks[remote] = oldFire
    remote.FireServer = function(self, ...)
        if _G.CeliaActive and string.find(self.Name, "Qsaky23Z") then
            return 
        end
        return oldFire(self, ...)
    end
end
local function startCeliaProcesses()
    CeliaThreads = {}
    CeliaHooks = {}
    table.insert(CeliaThreads, task.spawn(function()
        while _G.CeliaActive do
            local damageRemotes = findRemotesByPattern("retyhthlo")
            for _, remote in ipairs(damageRemotes) do
                local args = {
                    "Charge",
                    CFrame.new(24647.1171875, 4862.48681640625, -40336.84375, 0.8099825382232666, -0.2534901797771454, -0.5288393497467041, -0, 0.901757538318634, -0.43224215507507324, 0.5864540934562683, 0.3501085937023163, 0.7304077744483948),
                    "Mobile"
                }
                remote:FireServer(unpack(args))
            end
            task.wait(0.1)
        end
    end))
    table.insert(CeliaThreads, task.spawn(function()
        while _G.CeliaActive do
            local damageTakenRemotes = findRemotesByPattern("Qsaky23Z")
            for _, remote in ipairs(damageTakenRemotes) do
                hookSpecificRemote(remote)
            end
            task.wait(0.5) 
        end
    end))
end
local function stopCeliaProcesses()
    for remote, oldFire in pairs(CeliaHooks) do
        if remote and oldFire then
            remote.FireServer = oldFire
        end
    end
    CeliaHooks = {}
    for _, thread in ipairs(CeliaThreads) do
        if type(thread) == "thread" then
            task.cancel(thread)
        end
    end
    CeliaThreads = {}
end
MiscTab:CreateToggle({
    Name = "Celia",
    CurrentValue = _G.CeliaActive,
    Callback = function(value)
        _G.CeliaActive = value
        if _G.CeliaActive then
            startCeliaProcesses()
        else
            stopCeliaProcesses()
        end
    end
})
local itemFilter = "chest"

local ItemInput = CTab:CreateInput({
    Name = "Item Name Filter",
    PlaceholderText = "Enter item name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        itemFilter = Text:lower()
    end,
})

CTab:CreateButton({
    Name = "Use All Matching Items",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local backpack = player.Backpack
        
        local usedCount = 0
        local success, err = pcall(function()
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and string.find(tool.Name:lower(), itemFilter) then
                    tool.Parent = character
                    tool:Activate()
                    tool.Parent = backpack
                    usedCount += 1
                    task.wait()
                end
            end
        end)

        if success then
            Rayfield:Notify({
                Title = "Success",
                Content = "Used "..usedCount.." matching items",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Operation failed: "..tostring(err),
                Duration = 5,
                Image = 4483362458,
            })
        end
    end
})
ManTab:CreateToggle({
    Name = "Kill all",
    CurrentValue = false,
    Callback = function(value)
        isKillAllActive = value
        if isKillAllActive then
            killAllCoroutine = coroutine.create(function()
                while isKillAllActive do
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 11240)
                    sethiddenproperty(game.Players.LocalPlayer, "MaxSimulationRadius", 11240)
                    local mobFolder = game.Workspace:FindFirstChild("MobFolder")
                    if mobFolder then
                        for _, mob in pairs(mobFolder:GetDescendants()) do
                            if mob.ClassName == 'Humanoid' then
                                local isPlayerCharacter = false
                                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                                    if player.Character and player.Character == mob.Parent then
                                        isPlayerCharacter = true
                                        break
                                    end
                                end
                                if not isPlayerCharacter then
                                    mob.Health = 0
                                end
                            end
                        end
                    else
                        for _, d in pairs(game.Workspace:GetDescendants()) do
                            if d.ClassName == 'Humanoid' then
                                local isPlayerCharacter = false
                                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                                    if player.Character and player.Character == d.Parent then
                                        isPlayerCharacter = true
                                        break
                                    end
                                end
                                if not isPlayerCharacter then
                                    d.Health = 0
                                end
                            end
                        end
                    end
                    wait()
                end
            end)
            coroutine.resume(killAllCoroutine)
        else
            isKillAllActive = false
            if killAllCoroutine then
                coroutine.close(killAllCoroutine)
                killAllCoroutine = nil
            end
        end
    end    
})
ManTab:CreateToggle({
    Name = "Frill",
    CurrentValue = false,
    Callback = function(value)
        isKillAllActive = value
        if isKillAllActive then
            killAllCoroutine = coroutine.create(function()
                while isKillAllActive do
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 11240)
                    sethiddenproperty(game.Players.LocalPlayer, "MaxSimulationRadius", 11240)
                    local mobFolder = game.Workspace:FindFirstChild("MobFolder")
                    if mobFolder then
                        for _, mob in pairs(mobFolder:GetDescendants()) do
                            if mob.ClassName == 'Humanoid' and mob.Parent and mob.Parent.Name == "Frill" then
                                local isPlayerCharacter = false
                                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                                    if player.Character and player.Character == mob.Parent then
                                        isPlayerCharacter = true
                                        break
                                    end
                                end
                                if not isPlayerCharacter then
                                    mob.Health = 0
                                end
                            end
                        end
                    else
                        for _, d in pairs(game.Workspace:GetDescendants()) do
                            if d.ClassName == 'Humanoid' and d.Parent and d.Parent.Name == "Frill" then
                                local isPlayerCharacter = false
                                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                                    if player.Character and player.Character == d.Parent then
                                        isPlayerCharacter = true
                                        break
                                    end
                                end
                                if not isPlayerCharacter then
                                    d.Health = 0
                                end
                            end
                        end
                    end
                    wait()
                end
            end)
            coroutine.resume(killAllCoroutine)
        else
            isKillAllActive = false
            if killAllCoroutine then
                coroutine.close(killAllCoroutine)
                killAllCoroutine = nil
            end
        end
    end    
})
local isCollecting = false
local collectingCoroutine
local MAX_DISTANCE = 2000
local FIRE_ITER = 5
local FIRE_WAIT = 0.03
ManTab:CreateToggle({
    Name = "Collect Shadow Raid Chests",
    CurrentValue = false,
    Callback = function(state)
        isCollecting = state
        if isCollecting then
            collectingCoroutine = coroutine.create(function()
                local player = game.Players.LocalPlayer
                if not player then return end
                local function waitForHRP()
                    while isCollecting do
                        if player.Character then
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and hrp:IsA("BasePart") then
                                return hrp
                            end
                        end
                        task.wait(0.01)
                    end
                    return nil
                end
                local hrp = waitForHRP()
                if not hrp then return end
                local startCFrame = hrp.CFrame
                while isCollecting do
                    if not player.Character then
                        hrp = waitForHRP()
                        if not hrp then break end
                    else
                        hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if not hrp then
                            hrp = waitForHRP()
                            if not hrp then break end
                        end
                    end
                    local origin = hrp.Position
                    local nearestEntry = nil
                    local nearestDist = math.huge
                    -- Search in all ChestSpawns folders and their descendants
                    local function searchForChests(parent)
                        for _, child in ipairs(parent:GetDescendants()) do
                            if child:IsA("ProximityPrompt") then
                                local primaryPart = child.Parent
                                if primaryPart and primaryPart:IsA("BasePart") then
                                    local dist = (origin - primaryPart.Position).Magnitude
                                    if dist <= MAX_DISTANCE and dist < nearestDist then
                                        nearestDist = dist
                                        nearestEntry = {
                                            chest = child.Parent,
                                            primaryPart = primaryPart,
                                            prompt = child
                                        }
                                    end
                                end
                            end
                        end
                    end
                    -- Check the main ChestSpawns folders
                    local shadowRaidCastle = workspace:FindFirstChild("ShadowRaidCastle")
                    if shadowRaidCastle then
                        local chestSpawns = shadowRaidCastle:FindFirstChild("ChestSpawns")
                        if chestSpawns then
                            -- Search in all subfolders of ChestSpawns
                            for _, folder in ipairs(chestSpawns:GetChildren()) do
                                if folder:IsA("Folder") then
                                    searchForChests(folder)
                                end
                            end
                            -- Also search in ChestSpawns itself
                            searchForChests(chestSpawns)
                        end
                    end
                    if nearestEntry then
                        if not isCollecting then break end
                        local ok = pcall(function()
                            hrp.CFrame = nearestEntry.primaryPart.CFrame * CFrame.new(0, 0, 0)
                        end)
                        if not ok then
                            task.wait(0.01)
                            task.wait(0.01)
                            continue
                        end
                        for i = 1, FIRE_ITER do
                            if not isCollecting then break end
                            if not nearestEntry.prompt.Parent then break end
                            pcall(fireproximityprompt, nearestEntry.prompt)
                            task.wait(FIRE_WAIT)
                        end
                        task.wait(0.08)
                    else
                        task.wait(0.01)
                    end
                end
                if startCFrame and player and player.Character then
                    local finalHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    if finalHRP then
                        pcall(function() finalHRP.CFrame = startCFrame end)
                    end
                end
            end)
            coroutine.resume(collectingCoroutine)
        else
            isCollecting = false
            if collectingCoroutine then
                pcall(function() coroutine.close(collectingCoroutine) end)
                collectingCoroutine = nil
            end
        end
    end
})
local plr = game:GetService("Players")
local rs = game:GetService("RunService")
local cgui = game:GetService("CoreGui")
local thresh = 1
local enabled = false
local connection
local function taml(state)
	enabled = state
	if not enabled then
		rs:Set3dRenderingEnabled(true)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		return
	else
		RunService:Set3dRenderingEnabled(false)
	end
	local ps = cgui:WaitForChild("RobloxGui"):WaitForChild("PerformanceStats")
	for _, b in pairs(ps:GetDescendants()) do
		if b:IsA("TextButton") and b.Name == "PS_Button" then
			local tp = b:FindFirstChild("StatsMiniTextPanelClass")
			local tl = tp and tp:FindFirstChild("TitleLabel")
			if tl and string.find(tl.Text:lower(), "mem") then
				local v = tp:FindFirstChild("ValueLabel")
				if v then
					connection = v:GetPropertyChangedSignal("Text"):Connect(function()
						if not enabled or not v or not v.Parent then return end
						local memValue = tonumber(v.Text:match("%d+%.?%d*"))
						if memValue and memValue > thresh then
							rs:Set3dRenderingEnabled(true)
							task.delay(1, function()
								rs:Set3dRenderingEnabled(false)
							end)
						end
					end)
				end
				break
			end
		end
	end
end
function clk() 
	task.spawn(function()
		local s = Instance.new("Sound") 
		s.SoundId = "rbxassetid://87152549167464"
		s.Parent = workspace
		s.Volume = 1.2 
		s.TimePosition = 0.1 
		s:Play() 
	end)
end
ExTab:CreateToggle({
	Name = "Anti Memory Leak",
	CurrentValue = false,
	Flag = "lesbian5",
	Callback = function(Value)
		taml(Value)
	end
})
ExTab:CreateButton({
   Name = "Dupe Quests(100)",
   Callback = function()
      local Players = game:GetService("Players")
      local player = Players.LocalPlayer
      local char = player.Character or player.CharacterAdded:Wait()
      local playerHRP = char:WaitForChild("HumanoidRootPart", 5) or char.PrimaryPart
      if not playerHRP then
         return
      end
      local npcsFolder = workspace:WaitForChild("NPCs")
      local remote = workspace:WaitForChild("Remote"):WaitForChild("QuestEvent")
      local RADIUS = 100
      for _, npc in pairs(npcsFolder:GetChildren()) do
          local npcPart = npc:FindFirstChild("HumanoidRootPart")
              or npc.PrimaryPart
              or npc:FindFirstChildWhichIsA("BasePart")
          if npcPart and npcPart:IsA("BasePart") then
              local dist = (playerHRP.Position - npcPart.Position).Magnitude
              if dist <= RADIUS then
                  local args = {
                      "StartQuest",
                      npc.Name
                  }
                  for i = 1, 100 do
                      local ok, err = pcall(function()
                          remote:FireServer(unpack(args))
                      end)
                      if not ok then
                          break
                      end
                      task.wait()
                  end
              end
          end
      end
   end,
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local HORIZ_DISTANCE = 6      
local VERTICAL_OFFSET = 6     
local FOLLOW_SPEED = 1000
local scanInterval = 0.1
local TOTAL_DISTANCE = 10     
local MAX_TARGET_DISTANCE = 800
_G.isAutoCollectActive = _G.isAutoCollectActive or false
local connection = nil
local currentTarget = nil
local lastScan = 0
local BODY_VEL_NAME = "AutoTweenBodyVelocity"
local BODY_GYRO_NAME = "AutoTweenBodyGyro"
local bodyVelocity = nil
local bodyGyro = nil
local noclipActive = false
local noclipThread = nil
local modifiedParts = {}
local floatName = nil
local mobFolder = workspace:FindFirstChild("MobFolder")
local function enableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
            pcall(function() inst:Destroy() end)
        end
    end
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = BODY_VEL_NAME
    bodyVelocity.MaxForce = Vector3.new(4e5, 4e5, 4e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = BODY_GYRO_NAME
    bodyGyro.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
    bodyGyro.P = 8000
    bodyGyro.D = 200
    bodyGyro.Parent = hrp
end
local function disableBodyControl()
    if bodyVelocity then pcall(function() bodyVelocity:Destroy() end) end
    if bodyGyro then pcall(function() bodyGyro:Destroy() end) end
    bodyVelocity, bodyGyro = nil, nil
end
local function startNoclip()
    if noclipActive then return end
    noclipActive = true
    noclipThread = task.spawn(function()
        while noclipActive and _G.isAutoCollectActive do
            if player and player.Character then
                for _, child in pairs(player.Character:GetDescendants()) do
                    if child:IsA("BasePart") then
                        if not floatName or child.Name ~= floatName then
                            if child.Parent then
                                modifiedParts[child] = true
                                pcall(function() child.CanCollide = false end)
                            end
                        end
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
    for part, _ in pairs(modifiedParts) do
        if part and part:IsA("BasePart") and part.Parent then
            pcall(function() part.CanCollide = true end)
        end
    end
    modifiedParts = {}
end
local function findNearestMonsterHRP()
    if not player or not player.Character then return nil, math.huge end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local myPos = hrp.Position
    local nearest = nil
    local nearestDist = math.huge
    mobFolder = mobFolder or workspace:FindFirstChild("MobFolder")
    if not mobFolder then return nil, math.huge end
    for _, mob in ipairs(mobFolder:GetChildren()) do
        if mob.Name == "DPS Dummy R15" or mob.Name == "DPS Dummy R6" then
            continue
        end
        if mob ~= player.Character then
            local targetHRP = mob:FindFirstChild("HumanoidRootPart")
            if targetHRP and targetHRP:IsA("BasePart") then
                local hum = mob:FindFirstChildWhichIsA("Humanoid")
                if hum and hum.Health and hum.Health > 0 then
                    local d = (targetHRP.Position - myPos).Magnitude
                    if d < nearestDist and d <= MAX_TARGET_DISTANCE then
                        nearest = targetHRP
                        nearestDist = d
                    end
                end
            end
        end
    end
    return nearest, nearestDist
end
local function buildTopRightWithTotalDistance(targetHRP, horizDist, verticalOffset, totalDistance)
    local base = targetHRP.CFrame
    local right = base.RightVector * horizDist
    local up = base.UpVector * verticalOffset
    local RU = right + up                  
    local L = base.LookVector              
    local b = L:Dot(RU)
    local c = RU:Dot(RU)
    local D2 = (totalDistance or 0) ^ 2
    local discriminant = b*b - (c - D2)   
    local f = 0
    if discriminant >= 0 then
        local sqrtD = math.sqrt(discriminant)
        local f1 = -b + sqrtD
        local f2 = -b - sqrtD
        f = (f1 >= 0 and f2 >= 0) and math.min(f1, f2) or
            (f1 >= 0) and f1 or
            (f2 >= 0) and f2 or
            (math.abs(f1) < math.abs(f2)) and f1 or f2
    end
    local destPos = targetHRP.Position + RU + (L * f)
    return CFrame.new(destPos, targetHRP.Position + Vector3.new(0, 1, 0))
end
ExTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "lesbian2",
    Callback = function(value)
        _G.isAutoCollectActive = value
        if connection then
            connection:Disconnect()
            connection = nil
        end
        if _G.isAutoCollectActive then
            connection = RunService.Heartbeat:Connect(function(dt)
                if not player or not player.Character or not _G.isAutoCollectActive then
                    return
                end
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                lastScan = lastScan + dt
                local needScan = not currentTarget or 
                               not currentTarget.Parent or 
                               not currentTarget.Parent:IsDescendantOf(workspace) or
                               not mobFolder or
                               not currentTarget.Parent:IsDescendantOf(mobFolder)
                if needScan and lastScan >= scanInterval then
                    lastScan = 0
                    currentTarget = findNearestMonsterHRP()
                end
                if currentTarget and currentTarget.Parent and currentTarget:IsDescendantOf(workspace) then
                    local hum = currentTarget.Parent:FindFirstChildWhichIsA("Humanoid")
                    if hum and hum.Health > 0 then
                        local currentDistance = (hrp.Position - currentTarget.Position).Magnitude
                        if currentDistance <= MAX_TARGET_DISTANCE then
                            local desired = buildTopRightWithTotalDistance(currentTarget, HORIZ_DISTANCE, VERTICAL_OFFSET, TOTAL_DISTANCE)
                            local alpha = math.clamp(dt * FOLLOW_SPEED, 0, 1)
                            hrp.CFrame = hrp.CFrame:Lerp(desired, alpha)
                        else
                            currentTarget = nil  
                        end
                    else
                        currentTarget = nil
                    end
                else
                    currentTarget = nil
                end
            end)
        else
            currentTarget = nil
        end
    end
})
ExTab:CreateInput({
   Name = "Total Distance (studs)",
   CurrentValue = tostring(TOTAL_DISTANCE),
   PlaceholderText = "Total distance from monster (e.g. 10)",
   RemoveTextAfterFocusLost = false,
   Flag = "TotalDistanceInput",
   Callback = function(Text)
       local num = tonumber(Text)
       if not num then
           warn("Total Distance: invalid number; keeping previous value:", TOTAL_DISTANCE)
           return
       end
       if num < 0 then num = 0 end
       if num > 200 then num = 200 end
       TOTAL_DISTANCE = num
       print(("Total distance set to %.2f studs"):format(TOTAL_DISTANCE))
   end,
})
local Players = game:GetService("Players")
local AntiFreeze = {}
AntiFreeze._connections = {}    
AntiFreeze._targets = {}        
AntiFreeze._running = false
AntiFreeze._scanInterval = 0.02
local function unanchorDescendants(character, floatName)
    if not character then return end
    for _, d in ipairs(character:GetDescendants()) do
        if d:IsA("BasePart") and d.Anchored and d.Name ~= floatName then
            local ok, err = pcall(function() d.Anchored = false end)
            if not ok then
            end
        end
    end
end
local function onDescendantAdded(desc, floatName)
    if desc:IsA("BasePart") and desc.Anchored and desc.Name ~= floatName then
        local ok = pcall(function() desc.Anchored = false end)
    end
end
local function connectCharacter(player, floatName)
    if not player or not player.Character then return end
    local uid = player.UserId
    if AntiFreeze._connections[uid] then
        for _, con in ipairs(AntiFreeze._connections[uid]) do
            if con and con.Disconnect then pcall(function() con:Disconnect() end) end
        end
    end
    AntiFreeze._connections[uid] = {}
    unanchorDescendants(player.Character, floatName)
    local con1 = player.Character.DescendantAdded:Connect(function(desc)
        onDescendantAdded(desc, floatName)
    end)
    table.insert(AntiFreeze._connections[uid], con1)
    local con2 = player.Character:GetPropertyChangedSignal("Parent"):Connect(function()
        if not player.Character or not player.Character.Parent then
        end
    end)
    table.insert(AntiFreeze._connections[uid], con2)
    local con3 = player.CharacterAdded:Connect(function(char)
        task.wait(0.02)
        unanchorDescendants(char, floatName)
        local subCon = char.DescendantAdded:Connect(function(desc)
            onDescendantAdded(desc, floatName)
        end)
        table.insert(AntiFreeze._connections[uid], subCon)
    end)
    table.insert(AntiFreeze._connections[uid], con3)
end
function AntiFreeze.Start(targets, floatName, scanInterval)
    if AntiFreeze._running then
        AntiFreeze.Stop()
    end
    floatName = floatName or "Float"
    AntiFreeze._scanInterval = scanInterval or AntiFreeze._scanInterval
    local t = {}
    if not targets then
        t = { Players.LocalPlayer }
    elseif typeof(targets) == "Instance" and targets:IsA("Player") then
        t = { targets }
    elseif type(targets) == "table" then
        t = targets
    else
        if type(targets) == "string" then
            local p = Players:FindFirstChild(targets)
            if p then t = { p } end
        end
    end
    for _, p in ipairs(t) do
        if p and p:IsA("Player") then
            AntiFreeze._targets[p.UserId] = p
            if p.Character then
                connectCharacter(p, floatName)
            end
            local charConn 
            charConn = p.CharacterAdded:Connect(function(char)
                task.wait(0.02)
                unanchorDescendants(char, floatName)
                local subCon = char.DescendantAdded:Connect(function(desc)
                    onDescendantAdded(desc, floatName)
                end)
                table.insert(AntiFreeze._connections[p.UserId], subCon)
            end)
            table.insert(AntiFreeze._connections[p.UserId], charConn)
        end
    end
    if not AntiFreeze._running then
        AntiFreeze._running = true
        task.spawn(function()
            while AntiFreeze._running do
                for _, p in pairs(AntiFreeze._targets) do
                    local char = p and p.Character
                    if char then
                        unanchorDescendants(char, floatName)
                    end
                end
                task.wait(AntiFreeze._scanInterval)
            end
        end)
    end
end
function AntiFreeze.Stop()
    AntiFreeze._running = false
    for uid, conlist in pairs(AntiFreeze._connections) do
        for _, c in ipairs(conlist) do
            if c and c.Disconnect then
                pcall(function() c:Disconnect() end)
            end
        end
    end
    AntiFreeze._connections = {}
    AntiFreeze._targets = {}
end
ExTab:CreateToggle({
    Name = "Anti-Freeze",
    CurrentValue = false,
    Callback = function(value)
        _G.AntiFreezeEnabled = value
        if _G.AntiFreezeEnabled then
            AntiFreeze.Start()
        else
            AntiFreeze.Stop()
        end
    end
})
_G.AutoSkillToken = _G.AutoSkillToken or 0
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local lastFire = {}
local function safeUnpack(t)
    if type(t) == "table" then
        return table.unpack(t)
    end
    return t
end
local function getTargetPosition()
    local mobFolder = workspace:FindFirstChild("MobFolder")
    if mobFolder and #mobFolder:GetChildren() > 0 then
        local firstMob = mobFolder:GetChildren()[1]
        if firstMob:FindFirstChild("HumanoidRootPart") then
            return firstMob.HumanoidRootPart.Position
        end
        local ok, pivot = pcall(function() return firstMob:GetPivot().Position end)
        if ok and pivot then return pivot end
    end
    return Vector3.new(0, 0, 0)
end
local remoteCache = {}
local function resolveRemote(tool, remotePath)
    if not tool then return nil end
    local toolName = tool.Name
    remoteCache[toolName] = remoteCache[toolName] or {}
    if remoteCache[toolName][remotePath] and remoteCache[toolName][remotePath].Parent then
        return remoteCache[toolName][remotePath]
    end
    local found = nil
    if remotePath == "LukaRemote" then
        local folder = Replicated:FindFirstChild("Luka's Additional Remotes")
        if folder then
            found = folder:FindFirstChild("InputEvent")
        end
    else
        found = tool:FindFirstChild(remotePath)
    end
    remoteCache[toolName][remotePath] = found
    return found
end
local function executeAttack(character, toolName, attackName, remotePath, argsBuilder)
    if not character then return false end
    local tool = character:FindFirstChild(toolName)
    if not tool then return false end
    local remote = resolveRemote(tool, remotePath)
    if not remote then return false end
    local key = (remote and remote:GetFullName()) or tostring(remote)
    local now = tick()
    local throttleSec = 0.05 
    if lastFire[key] and now - lastFire[key] < throttleSec then
        return false 
    end
    lastFire[key] = now
    local targetPos = nil
    local ok, args = pcall(function()
        return argsBuilder(character, tool, attackName, getTargetPosition())
    end)
    if not ok then args = {} end
    if type(args) ~= "table" then
        args = {args}
    end
    pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(safeUnpack(args))
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(safeUnpack(args))
        end
    end)
    return true
end
local function startAutoSkills(character)
    _G.AutoSkillToken = (_G.AutoSkillToken or 0) + 1
    local myToken = _G.AutoSkillToken
    local skillSequences = {
        {
            tools = {"Arvoth"},
            sequence = {
                {attack = "Slash", key = "M1", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "M1", attack = "Slash"}, {MousePos = pos}} end},
                {attack = "Triple Fury", key = "E", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "E", attack = "Triple Fury"}, {MousePos = pos}} end}
            }
        },
        {
            tools = {"The Revenant"},
            sequence = {
                {attack = "Necrostrike", key = "M1", remote = "RemoteEvent", args = function(char, tool, attack, pos) return {{key = "M1", attack = "Necrostrike"}, {MousePos = pos}} end},
                {attack = "Death Insurgence", key = "R", remote = "RemoteEvent", args = function(char, tool, attack, pos) return {{key = "R", attack = "Death Insurgence"}, {MousePos = pos}} end}
            }
        },
        {
            tools = {"Classic Wand of Triplets"},
            sequence = {
                {attack = "TripletAttack", remote = "Event", args = function(char, tool, attack, pos) return {pos} end}
            }
        }
    }
    local continuousSkills = {
        {tool = "Witch's Brew", remote = "SplashSend", args = function() return {"Activate"} end, interval = 0.00001},
        {tool = "Bloxy Cola", remote = "SplashSend", args = function() return {"Activate"} end, interval = 0.00001}
    }
    for _, sequenceData in pairs(skillSequences) do
        task.spawn(function()
            while _G.AutoSkillActive and myToken == _G.AutoSkillToken do
                if not character or not character.Parent then break end
                local hasTool = false
                for _, toolName in pairs(sequenceData.tools) do
                    if character:FindFirstChild(toolName) then
                        hasTool = true
                        break
                    end
                end
                if hasTool then
                    for _, skill in pairs(sequenceData.sequence) do
                        if not _G.AutoSkillActive or myToken ~= _G.AutoSkillToken then break end
                        for _, toolName in pairs(sequenceData.tools) do
                            task.wait(0.01)
                            executeAttack(character, toolName, skill.attack, skill.remote, skill.args)
                            task.wait(0.01)
                        end
                        task.wait(0.01)
                    end
                end
                task.wait(0.01)
            end
        end)
    end
    for _, skill in pairs(continuousSkills) do
        task.spawn(function()
            while _G.AutoSkillActive and myToken == _G.AutoSkillToken do
                if not character or not character.Parent then break end
                task.wait(0.01)
                executeAttack(character, skill.tool, nil, skill.remote, skill.args)
                task.wait(0.01)
            end
            task.wait(0.01)
        end)
    end
end
local function setupCharacter(character)
    remoteCache = {}
    if _G.AutoSkillActive then
        task.wait(0.01)
        startAutoSkills(character)
        task.wait(0.01)
    end
end
player.CharacterRemoving:Connect(function(char)
    _G.AutoSkillToken = (_G.AutoSkillToken or 0) + 1
end)
player.CharacterAdded:Connect(setupCharacter)
if player.Character then
    task.wait(0.01)
    setupCharacter(player.Character)
    task.wait(0.01)
end
ExTab:CreateToggle({
    Name = "Auto Skill Sequence",
    CurrentValue = false,
    Flag = "lesbian1",
    Callback = function(value)
        _G.AutoSkillActive = value
        if _G.AutoSkillActive then
            if player.Character then
                task.wait(0.01)
                setupCharacter(player.Character)
                task.wait(0.01)
            end
        else
            _G.AutoSkillToken = (_G.AutoSkillToken or 0) + 1
        end
    end
})
local config = {
    delayBetweenRepeats = 0.1,
    repeatCount = 1,
    fireRadius = 50,
    active = false,
    autoFire = false
}

local connections = {
    prompts = {},
    autoFire = nil
}
local function getCharacterRoot()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart
    end
    return nil
end
PTab:CreateInput({
    Name = "Repeat Count",
    CurrentValue = tostring(config.repeatCount),
    PlaceholderText = "Enter repeat count",
    Flag = "RepeatCountInput",
    Callback = function(Value)
        local number = tonumber(Value)
        if number and number > 0 then
            config.repeatCount = number
            print("Repeat count set to:", config.repeatCount)
        else
            warn("Invalid input! Enter a positive number.")
        end
    end
})

PTab:CreateInput({
    Name = "Delay Between Repeats",
    CurrentValue = tostring(config.delayBetweenRepeats),
    PlaceholderText = "Enter delay in seconds",
    Flag = "DelayInput",
    Callback = function(Value)
        local number = tonumber(Value)
        if number and number >= 0 then
            config.delayBetweenRepeats = number
            print("Delay set to:", config.delayBetweenRepeats)
        else
            warn("Invalid input! Enter a non-negative number.")
        end
    end
})

PTab:CreateInput({
    Name = "Activation Radius",
    CurrentValue = tostring(config.fireRadius),
    PlaceholderText = "Enter radius in studs",
    Flag = "RadiusInput",
    Callback = function(Value)
        local number = tonumber(Value)
        if number and number > 0 then
            config.fireRadius = number
            print("Radius set to:", config.fireRadius)
        else
            warn("Invalid input! Enter a positive number.")
        end
    end
})
config = config or {}
config.delayBetweenRepeats = config.delayBetweenRepeats or 0.1
config.repeatCount = math.max(1, tonumber(config.repeatCount) or 1)
config.fireRadius = config.fireRadius or 50
config.active = config.active or false
config.autoFire = config.autoFire or false
connections = connections or {}
connections.prompts = connections.prompts or {}
connections.descendantAdded = connections.descendantAdded or nil
connections.descendantRemoving = connections.descendantRemoving or nil
local promptDebounce = {}
local function cleanUpPrompt(prompt)
    if not prompt then return end
    if connections.prompts[prompt] then
        pcall(function()
            connections.prompts[prompt]:Disconnect()
        end)
        connections.prompts[prompt] = nil
    end
    promptDebounce[prompt] = nil
end
local function applyMultiplier(prompt)
    if not prompt then return end
    if connections.prompts[prompt] or not config.active then return end
    connections.prompts[prompt] = prompt.Triggered:Connect(function()
        if not config.active then return end
        if promptDebounce[prompt] then
            return
        end
        promptDebounce[prompt] = true
        task.spawn(function()
            local total = math.max(1, tonumber(config.repeatCount) or 1)
            local extras = math.max(0, total - 1)
            for i = 1, extras do
                if not config.active or not prompt:IsDescendantOf(workspace) then
                    break
                end
                pcall(function()
                    fireproximityprompt(prompt)
                end)
                if config.delayBetweenRepeats and config.delayBetweenRepeats > 0 then
                    task.wait(config.delayBetweenRepeats)
                else
                    task.wait() 
                end
            end
            task.wait(0.05)
            promptDebounce[prompt] = nil
        end)
    end)
end
local function scanForPrompts()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            applyMultiplier(descendant)
        end
    end
end
PTab:CreateToggle({
    Name = "Proximity Multiplier",
    CurrentValue = config.active,
    Flag = "MultiplierToggle",
    Callback = function(Value)
        config.active = Value
        if Value then
            scanForPrompts()
            connections.descendantAdded = workspace.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("ProximityPrompt") and config.active then
                    applyMultiplier(descendant)
                end
            end)
            connections.descendantRemoving = workspace.DescendantRemoving:Connect(function(descendant)
                if descendant:IsA("ProximityPrompt") then
                    cleanUpPrompt(descendant)
                end
            end)
        else
            for prompt, _ in pairs(connections.prompts) do
                cleanUpPrompt(prompt)
            end
            if connections.descendantAdded then
                pcall(function() connections.descendantAdded:Disconnect() end)
                connections.descendantAdded = nil
            end
            if connections.descendantRemoving then
                pcall(function() connections.descendantRemoving:Disconnect() end)
                connections.descendantRemoving = nil
            end
            promptDebounce = {}
        end
    end
})
PTab:CreateToggle({
    Name = "Auto Fire Nearby Prompts",
    CurrentValue = false,
    Flag = "AutoFireToggle",
    Callback = function(Value)
        config.autoFire = Value
        if Value then
            connections.autoFire = game:GetService("RunService").Heartbeat:Connect(function()
                local rootPart = getCharacterRoot()
                if not rootPart then return end

                for _, prompt in ipairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        local parent = prompt.Parent
                        local position = parent:IsA("Model") and parent.PrimaryPart 
                            and parent.PrimaryPart.Position or parent:IsA("BasePart") 
                            and parent.Position

                        if position and (position - rootPart.Position).Magnitude <= config.fireRadius then
                            for i = 1, config.repeatCount do
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end
            end)
        else
            if connections.autoFire then
                connections.autoFire:Disconnect()
                connections.autoFire = nil
            end
        end
    end
})
local function findNearestPrompt()
    local rootPart = getCharacterRoot()
    if not rootPart then return nil end

    local closestPrompt = nil
    local minDistance = math.huge

    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local parent = prompt.Parent
            local position
            if parent:IsA("Model") and parent.PrimaryPart then
                position = parent.PrimaryPart.Position
            elseif parent:IsA("BasePart") then
                position = parent.Position
            else
                position = nil
            end
            if position then
                local distance = (position - rootPart.Position).Magnitude
                if distance <= config.fireRadius and distance < minDistance then
                    closestPrompt = prompt
                    minDistance = distance
                end
            end
        end
    end

    return closestPrompt
end
config = config or {}
config.fireRadius = config.fireRadius or 20
config.repeatCount = config.repeatCount or 1    
connections = connections or {}
PTab:CreateToggle({
    Name = "Auto Fire Nearby ClickDetectors",
    CurrentValue = false,
    Flag = "AutoFireClickToggle",
    Callback = function(Value)
        config.autoFireClick = Value
        if Value then
            connections.autoFireClick = game:GetService("RunService").Heartbeat:Connect(function()
                local rootPart = getCharacterRoot()
                if not rootPart then return end
                local rootPos = rootPart.Position
                for _, descendant in ipairs(workspace:GetDescendants()) do
                    if descendant:IsA("ClickDetector") then
                        local parent = descendant.Parent
                        local position
                        if parent then
                            if parent:IsA("Model") and parent.PrimaryPart then
                                position = parent.PrimaryPart.Position
                            elseif parent:IsA("BasePart") then
                                position = parent.Position
                            end
                        end
                        if position and (position - rootPos).Magnitude <= config.fireRadius then
                            for i = 1, config.repeatCount do
                                pcall(fireclickdetector, descendant)
                            end
                        end
                    end
                end
            end)
        else
            if connections.autoFireClick then
                connections.autoFireClick:Disconnect()
                connections.autoFireClick = nil
            end
        end
    end
})
PTab:CreateButton({
    Name = "Fire Nearest Prompt",
    Callback = function()
        local prompt = findNearestPrompt()
        if prompt then
            for i = 1, config.repeatCount do
                if prompt:IsDescendantOf(workspace) then
                    fireproximityprompt(prompt)
                else
                    break
                end
            end
        else
            print("No nearby prompts found within activation radius!")
        end
    end
})
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local player = Players.LocalPlayer
local TARGET_FOLDERS = { "MobFolder", "NPCs" }
local HUMANOID_ESP_MAX = 1000 
local humanoidESPEnabled = false
local trackedHRPs = {}   
local espTags = {}       
local heartbeatConn
local folderAddedConns = {}
local folderRemovingConns = {}
local playerHRP = nil
local charAddedConn = nil
if player.Character then
    playerHRP = player.Character:FindFirstChild("HumanoidRootPart") or player.Character.PrimaryPart
end
charAddedConn = player.CharacterAdded:Connect(function(char)
    playerHRP = char:WaitForChild("HumanoidRootPart", 10) or char.PrimaryPart
end)
local function getTargetFolderInstances()
    local out = {}
    for _, name in ipairs(TARGET_FOLDERS) do
        local f = workspace:FindFirstChild(name)
        if f and f:IsA("Instance") then
            table.insert(out, f)
        end
    end
    return out
end
local function destroyESPForHRP(hrp)
    local data = espTags[hrp]
    if not data then return end
    if data.highlight and data.highlight.Parent then
        data.highlight:Destroy()
    end
    if data.billboard and data.billboard.Parent then
        data.billboard:Destroy()
    end
    espTags[hrp] = nil
end
local function updateHumanoidESP(targetHRP)
    if not humanoidESPEnabled then return end
    if not targetHRP or not targetHRP.Parent or not playerHRP then
        return
    end
    local model = targetHRP.Parent
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        destroyESPForHRP(targetHRP)
        return
    end
    local okPos, dist = pcall(function()
        return (playerHRP.Position - targetHRP.Position).Magnitude
    end)
    if not okPos or not dist then
        destroyESPForHRP(targetHRP)
        trackedHRPs[targetHRP] = nil
        return
    end
    if dist > HUMANOID_ESP_MAX then
        destroyESPForHRP(targetHRP)
        return
    end
    local data = espTags[targetHRP]
    if not data then
        local highlight = Instance.new("Highlight")
        highlight.Name = "HumanoidESPHighlight"
        highlight.Adornee = model
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = model
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "HumanoidESPLabel"
        billboard.Adornee = targetHRP
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Size = UDim2.new(0, 160, 0, 40)
        billboard.AlwaysOnTop = true
        billboard.Parent = model
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = model.Name
        nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.Arial
        nameLabel.Parent = billboard
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
        infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Color3.fromRGB(200,200,200)
        infoLabel.TextStrokeTransparency = 0.7
        infoLabel.TextScaled = true
        infoLabel.Font = Enum.Font.Arial
        infoLabel.Parent = billboard
        data = {
            highlight = highlight,
            billboard = billboard,
            nameLabel = nameLabel,
            infoLabel = infoLabel,
            humanoid  = humanoid,
        }
        espTags[targetHRP] = data
    end
    local hpText = ""
    if data.humanoid and data.humanoid.Health ~= nil then
        local maxH = data.humanoid.MaxHealth or 100
        hpText = string.format(" · HP: %.0f/%.0f", math.max(0, data.humanoid.Health), maxH)
    end
    data.nameLabel.Text = model.Name
    data.infoLabel.Text = string.format("%.0f studs%s", dist, hpText)
end
local function onHeartbeat()
    for hrp, _ in pairs(trackedHRPs) do
        pcall(function() updateHumanoidESP(hrp) end)
    end
end
local function scanWorkspaceForHRPs()
    trackedHRPs = {}
    local folders = getTargetFolderInstances()
    for _, folder in ipairs(folders) do
        for _, obj in ipairs(folder:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "HumanoidRootPart" and obj.Parent and obj.Parent:FindFirstChildOfClass("Humanoid") then
                trackedHRPs[obj] = true
            end
        end
    end
end
local function enableHumanoidESP()
    if heartbeatConn then return end
    humanoidESPEnabled = true
    scanWorkspaceForHRPs()
    for _, c in pairs(folderAddedConns) do if c and c.Connected then c:Disconnect() end end
    for _, c in pairs(folderRemovingConns) do if c and c.Connected then c:Disconnect() end end
    folderAddedConns = {}
    folderRemovingConns = {}
    local folders = getTargetFolderInstances()
    for _, folder in ipairs(folders) do
        local addedConn = folder.DescendantAdded:Connect(function(desc)
            if not humanoidESPEnabled then return end
            if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" and desc.Parent and desc.Parent:FindFirstChildOfClass("Humanoid") then
                trackedHRPs[desc] = true
            end
        end)
        local removingConn = folder.DescendantRemoving:Connect(function(desc)
            if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" then
                if espTags[desc] then
                    destroyESPForHRP(desc)
                end
                trackedHRPs[desc] = nil
            end
        end)
        table.insert(folderAddedConns, addedConn)
        table.insert(folderRemovingConns, removingConn)
    end
    heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
end
local function disableHumanoidESP()
    humanoidESPEnabled = false
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    for _, c in ipairs(folderAddedConns) do
        if c and c.Connected then c:Disconnect() end
    end
    for _, c in ipairs(folderRemovingConns) do
        if c and c.Connected then c:Disconnect() end
    end
    folderAddedConns = {}
    folderRemovingConns = {}
    for hrp, _ in pairs(espTags) do
        destroyESPForHRP(hrp)
    end
    trackedHRPs = {}
end
    ManTab:CreateToggle({
        Name = "HumanoidRootPart ESP",
        CurrentValue = humanoidESPEnabled,
        Flag = "HumanoidRootESPEnabled",
        Callback = function(enabled)
            pcall(function()
                if enabled then
                    enableHumanoidESP()
                else
                    disableHumanoidESP()
                end
            end)
        end,
    })
_G.AutoEquipActive = _G.AutoEquipActive or false
local function equipAllItems()
    if not player or not player.Character then return end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") or item:IsA("HopperBin") then
            pcall(function()
                item.Parent = player.Character
            end)
        end
    end
end
local autoEquipConnection = nil
ManTab:CreateToggle({
    Name = "Auto Equip All Items",
    Flag = "lesbian3",
    CurrentValue = _G.AutoEquipActive,
    Callback = function(value)
        _G.AutoEquipActive = value
        if autoEquipConnection then
            autoEquipConnection:Disconnect()
            autoEquipConnection = nil
        end
        if _G.AutoEquipActive then
            equipAllItems()
            autoEquipConnection = player.ChildAdded:Connect(function(child)
                if child:IsA("Backpack") then
                    task.wait(1)
                    equipAllItems()
                end
            end)
        end
    end
})
CTab:CreateButton({
    Name = "List Inventory Items",
    Callback = function()
        print("[DEBUG] Initializing inventory scan...")
        local startTime = os.clock()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local inventoryContainers = {"Backpack", "Character", "StarterGear"}
        
        if not LocalPlayer.Character then
            print("[DEBUG] Waiting for character...")
            LocalPlayer.CharacterAdded:Wait()
        end
        
        local itemCounts = {}
        local totalItems = 0
        
        for _, containerName in ipairs(inventoryContainers) do
            local container = LocalPlayer:FindFirstChild(containerName)
            if container then
                print("[DEBUG] Scanning container:", container:GetFullName())
                
                local function scanRecursive(parent)
                    for _, item in ipairs(parent:GetChildren()) do
                        if item:IsA("Tool") then
                            itemCounts[item.Name] = (itemCounts[item.Name] or 0) + 1
                            totalItems += 1
                            print("[DEBUG] Found tool:", item.Name)
                        end
                        scanRecursive(item)
                    end
                end
                
                scanRecursive(container)
            end
        end
        
        if totalItems > 0 then
            for itemName, count in pairs(itemCounts) do
                Rayfield:Notify({
                    Title = "🎒 Inventory Item",
                    Content = string.format("%s ×%d", itemName, count),
                    Duration = 4,
                    Image = 4483345998,
                    Actions = {{
                        Name = "Close",
                        Callback = function()
                            print("[DEBUG] Closed notification for:", itemName)
                        end
                    }}
                })
                task.wait(0.75)
            end
        else
            Rayfield:Notify({
                Title = "🎒 Inventory",
                Content = "Inventory is empty in all containers!",
                Duration = 4,
                Image = 4483345998,
                Actions = {{
                    Name = "Close",
                    Callback = function()
                        print(lo"[DEBUG] Closed empty inventory notification")
                    end
                }}
            })
        end

      
    end
})


CTab:CreateButton({
    Name = "Use all items in inventory.",
    Callback = function()
        local p = game:GetService("Players")
        local player = p.LocalPlayer
        local c = player.Character or player.CharacterAdded:Wait()
        
        for _, v in ipairs(player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = c
                v:Activate()
                task.wait()
                v.Parent = player.Backpack
            end
        end
    end
})

Rayfield:LoadConfiguration()