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

ManTab:CreateToggle({
    Name = "Shadow Castle",
    CurrentValue = false,
    Flag = "lesbian2",
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
                            if mob.ClassName == 'Humanoid' and mob.Health > 0 then
                                local isPlayerCharacter = false
                                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                                    if player.Character and player.Character == mob.Parent then
                                        isPlayerCharacter = true
                                        break
                                    end
                                end
                                if not isPlayerCharacter then
                                    local mobName = mob.Parent and mob.Parent.Name:lower() or ""
                                    local isExcluded = mobName:find("shadow") or mobName:find("shade") or mobName:find("nyx") or mobName:find("nightmaric") or mobName:find("poltergeist")
                                    if not isExcluded then
                                        if mobName:find("master") then
                                            if mob.MaxHealth - mob.Health >= 100 or mob.Health <= 100 then
                                                mob.Health = 0
                                            end
                                        else
                                            mob.Health = 0
                                        end
                                    end
                                end
                            end
                        end
                    wait(0.1)
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
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local function findClosestTeleporter()
    if not player.Character then return nil end
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    local closestTeleporter = nil
    local closestDistance = 25
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
    local positionAbove = teleporterCFrame.Position + Vector3.new(0, 1, 0) 
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
local isAutoQuestActive = false
local questCheckCoroutine = nil
local function repeatFinishedQuests()
    local questsFolder = game:GetService("Players").LocalPlayer.PlayerGui.MainMenus.MainGui.QuestsMenu.Quests
    if not questsFolder then return end
    local repeatedCount = 0
    for _, npcQuest in pairs(questsFolder:GetChildren()) do
        if npcQuest:IsA("Frame") then
            local objectivesHolder = npcQuest:FindFirstChild("ObjectivesHolder")
            if objectivesHolder then
                local objectivesScrolling = objectivesHolder:FindFirstChild("Objectives")
                if objectivesScrolling and objectivesScrolling:IsA("ScrollingFrame") then
                    local hasDoneObjective = false
                    for _, objective in pairs(objectivesScrolling:GetChildren()) do
                        if objective:IsA("Frame") and objective.Name ~= "UIGridLayout" and objective.Name ~= "UIPadding" then
                            local progress = objective:FindFirstChild("Progress")
                            if progress then
                                local additionalLabel = progress:FindFirstChild("AdditionalLabel")
                                if additionalLabel and additionalLabel:IsA("TextLabel") and string.upper(additionalLabel.Text) == "DONE" then
                                    hasDoneObjective = true
                                    break
                                end
                            end
                        end
                    end
                    if hasDoneObjective then
                        local args = {npcQuest.Name, true}
                        workspace:WaitForChild("Remote"):WaitForChild("QuestRepeat"):FireServer(unpack(args))
                        
                        repeatedCount = repeatedCount + 1
                        task.wait(0.5) 
                    end
                end
            end
        end
    end
end
local function startAutoQuest()
    while isAutoQuestActive do
        repeatFinishedQuests()
        task.wait(5) 
    end
end
MiscTab:CreateToggle({
    Name = "Auto Repeat Quests",
    CurrentValue = false,
    Flag = "lesbian1",
    Callback = function(value)
        isAutoQuestActive = value
        if isAutoQuestActive then
            questCheckCoroutine = coroutine.create(function()
                startAutoQuest()
            end)
            coroutine.resume(questCheckCoroutine)
            
        else
            if questCheckCoroutine then
                coroutine.close(questCheckCoroutine)
                questCheckCoroutine = nil
            end
            
        end
    end
})
local isAutoRejoinActive = false
local skipToFinalBoss = false 
local rejoinCheckCoroutine = nil
local lastMobCheckTime = 0
local lastFarMobCheckTime = 0
local nyxFound = false
local nyxDefeated = false
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId
local JobId = game.JobId
local player = Players.LocalPlayer
local function isInShadowRaid()
    return Workspace:FindFirstChild("IsShadowRaid") or 
           Workspace:FindFirstChild("ShadowRaidBool")
end
local function areChestsRemaining()
    local shadowRaidCastle = Workspace:FindFirstChild("ShadowRaidCastle")
    if not shadowRaidCastle then return false end
    local chestSpawns = shadowRaidCastle:FindFirstChild("ChestSpawns")
    if not chestSpawns then return false end
    for _, child in ipairs(chestSpawns:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            return true
        end
    end
    return false
end
local function hopToRandomServer()
    local teleporting = false
    local teleportStateConnection = nil
    local teleportSuccess = false
    local function cleanup()
        if teleportStateConnection then
            teleportStateConnection:Disconnect()
            teleportStateConnection = nil
        end
        teleporting = false
    end
    local function attemptTeleport()
        local function getAllServers()
            local url = string.format(
                "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
                PlaceId
            )
            local success, res = pcall(function()
                return game:HttpGet(url)
            end)
            if not success or not res then return {} end
            local decoded = HttpService:JSONDecode(res)
            return decoded and decoded.data or {}
        end
        while not teleportSuccess and not teleporting do
            local servers = getAllServers()
            local bestServer = nil
            local lowestPlayerCount = math.huge
            for _, server in ipairs(servers) do
                if server.id ~= JobId and server.playing < server.maxPlayers then
                    if server.playing < lowestPlayerCount then
                        lowestPlayerCount = server.playing
                        bestServer = server
                    end
                end
            end
            if bestServer then
                print("Best server found - Players: ".. bestServer.playing .."/".. bestServer.maxPlayers)
                teleporting = true
                teleportStateConnection = TeleportService.TeleportInitFailed:Connect(function()
                    print("Teleport failed, retrying...")
                    teleporting = false
                    teleportSuccess = false
                    cleanup()
                    task.wait(0.5)
                end)
                local ok, err = pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceId, bestServer.id, player)
                end)
                if not ok then
                    print("Teleport error: " .. tostring(err))
                    teleporting = false
                    teleportSuccess = false
                    cleanup()
                else
                    print("Teleport initiated successfully")
                    task.wait(0.5)
                    if not teleportSuccess then
                        print("Teleport seems stuck, retrying...")
                        teleporting = false
                        cleanup()
                    end
                end
            else
                print("No suitable server found, retrying in 2 seconds...")
                task.wait(0.5)
            end
        end
    end
    spawn(attemptTeleport)
end
local function areMobsPresent(character)
    if not character then return false, false end  
    local characterPosition = character:GetPivot().Position
    local mobFolder = Workspace:FindFirstChild("MobFolder")
    if not mobFolder then return false, false end
    local hasAnyMobs = false
    local hasNearbyMobs = false
    if skipToFinalBoss then
        local nyx = mobFolder:FindFirstChild("Nyx, Coalescence of Terror")
        if nyx then
            local humanoid = nyx:FindFirstChildWhichIsA("Humanoid")
            if humanoid and humanoid.Health > 0 then
                nyxFound = true
                nyxDefeated = false
                local nyxPosition = nyx:GetPivot().Position
                local distance = (nyxPosition - characterPosition).Magnitude
                return true, distance <= 1000 
            elseif humanoid and humanoid.Health <= 0 then
                nyxFound = true
                nyxDefeated = true
                return true, false 
            end
        end
    end
    for _, mob in ipairs(mobFolder:GetChildren()) do
        if not Players:GetPlayerFromCharacter(mob) then
            local humanoid = mob:FindFirstChildWhichIsA("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local mobPosition = mob:GetPivot().Position
                local distance = (mobPosition - characterPosition).Magnitude
                hasAnyMobs = true  
                if distance <= 1000 then
                    hasNearbyMobs = true  
                    break
                end
            end
        end
    end
    return hasAnyMobs, hasNearbyMobs
end
local function killCharacter()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
            print("Character killed - mobs are too far away")
        end
    end
end
local function startAutoRejoinCheck()
    local deathCount = 0
    local lastDeathTime = 0
    while isAutoRejoinActive do
        if isInShadowRaid() then
            local playerCount = #Players:GetPlayers()
            if playerCount > 1 then
            hopToRandomServer()
            end
            local character = player.Character
            local hasAnyMobs, hasNearbyMobs = areMobsPresent(character)
            if skipToFinalBoss then
                local mobFolder = Workspace:FindFirstChild("MobFolder")
                if mobFolder then
                    local nyx = mobFolder:FindFirstChild("Nyx, Coalescence of Terror")
                    if nyx and not nyxFound then
                        nyxFound = true
                        nyxDefeated = false
                        print("Nyx boss found, monitoring for defeat...")
                    end
                    if nyxFound and nyx then
                        local humanoid = nyx:FindFirstChildWhichIsA("Humanoid")
                        if humanoid and humanoid.Health <= 0 then
                            nyxDefeated = true
                            print("Nyx defeated, checking for chests...")
                        end
                    elseif nyxFound and not nyx then
                        nyxDefeated = true
                        print("Nyx disappeared (defeated), checking for chests...")
                    end
                    if nyxDefeated then
                        task.wait(10)
                        if not areChestsRemaining() then
                            print("Chests collected or none remaining, rejoining...")
                            hopToRandomServer()
                            break
                        else
                            print("Chests still remaining, waiting...")
                        end
                    end
                end
            end
            if not (skipToFinalBoss and nyxFound and nyxDefeated) then
                if hasAnyMobs and not hasNearbyMobs then
                    if lastFarMobCheckTime == 0 then
                        lastFarMobCheckTime = tick()
                    else
                        local timeSinceFarMobs = tick() - lastFarMobCheckTime
                        if timeSinceFarMobs >= 10 then  
                            killCharacter()
                            lastFarMobCheckTime = 0  
                        end
                    end
                else
                    lastFarMobCheckTime = 0  
                end
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        local currentTime = tick()
                        if currentTime - lastDeathTime > 2 then 
                            deathCount = deathCount + 1
                            lastDeathTime = currentTime
                            print("Player died. Death count: " .. deathCount)
                            if deathCount >= 3 then
                                hopToRandomServer()
                            end
                        end
                    end
                end
                if not hasAnyMobs then
                    if lastMobCheckTime == 0 then
                        lastMobCheckTime = tick()
                    else
                        local timeSinceNoMobs = tick() - lastMobCheckTime
                        if timeSinceNoMobs >= 90 then
                            print("Conditions met: No mobs for 90+ seconds or multiple players. Rejoining...")
                            hopToRandomServer()
                        end
                    end
                else
                    lastMobCheckTime = 0
                end
            end
            if tick() % 5 < 0.1 then 
                local nyxStatus = "Not Found"
                if nyxFound then
                    nyxStatus = nyxDefeated and "Defeated" or "Alive"
                end
                print(string.format("AutoRejoin: AnyMobs=%s, NearbyMobs=%s, Players=%d, TimeNoMobs=%.1fs, TimeFarMobs=%.1fs, Deaths=%d, Nyx=%s", 
                    tostring(hasAnyMobs), tostring(hasNearbyMobs), playerCount, 
                    lastMobCheckTime > 0 and (tick() - lastMobCheckTime) or 0,
                    lastFarMobCheckTime > 0 and (tick() - lastFarMobCheckTime) or 0, 
                    deathCount, nyxStatus))
            end
        else
            lastMobCheckTime = 0 
            lastFarMobCheckTime = 0
            nyxFound = false
            nyxDefeated = false
        end
        task.wait(1) 
    end
end
MiscTab:CreateToggle({
    Name = "Rejoin Shadow Castle",
    CurrentValue = false,
    Flag = "lesbian3",
    Callback = function(value)
        isAutoRejoinActive = value
        lastMobCheckTime = 0
        lastFarMobCheckTime = 0
        if not value then
            nyxFound = false
            nyxDefeated = false
        end
        if isAutoRejoinActive then
            rejoinCheckCoroutine = coroutine.create(startAutoRejoinCheck)
            coroutine.resume(rejoinCheckCoroutine)
        else
            if rejoinCheckCoroutine then
                coroutine.close(rejoinCheckCoroutine)
                rejoinCheckCoroutine = nil
            end
        end
    end
})
local yOffsetDp = 30
local xOffsetDp = 5
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local function getNyxSkipButton()
    local pg = localPlayer and localPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local nyxCutscene = pg:FindFirstChild("NyxCutscene")
    if not nyxCutscene then return nil end
    return nyxCutscene:FindFirstChild("SkipCutsceneButton")
end
local function clickGuiButton(button)
    if not button or not button:IsA("GuiButton") then return false end
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(360, 640)
    local dpScale = (viewport.X ~= 0) and (viewport.X / 360) or 1
    local xOffsetPx = math.floor(xOffsetDp * dpScale + 0.5)  
    local yOffsetPx = math.floor(yOffsetDp * dpScale + 0.5)
    local x = math.floor(button.AbsolutePosition.X + button.AbsoluteSize.X/2 + xOffsetPx)
    local y = math.floor(button.AbsolutePosition.Y + button.AbsoluteSize.Y/2 + yOffsetPx)
    local success, err = pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)
    if not success then
        warn("Click failed:", err)
    end
    return success
end
local function continuousClickButton(button)
    spawn(function()
        while button and button.Parent and button:IsA("GuiButton") and button.Visible do
            clickGuiButton(button)
            wait(0.1)  
        end
    end)
end
local nyxSkipCoroutine = nil
local nyxSkipConnections = {}
local nyxClickThreads = {}  
local function autoSkipNyxCutsceneV2(state)
    if state then
        local function checkAndClickNyxButton()
            local button = getNyxSkipButton()
            if button and button:IsA("GuiButton") and button.Visible then
                wait(0.05)
                continuousClickButton(button)
            end
        end
        checkAndClickNyxButton()
        local playerGui = localPlayer:WaitForChild("PlayerGui")
        nyxSkipConnections["nyxAdded"] = playerGui.ChildAdded:Connect(function(child)
            if child.Name == "NyxCutscene" then
                wait(0.1) 
                local button = child:FindFirstChild("SkipCutsceneButton")
                if button and button:IsA("GuiButton") and button.Visible then
                    continuousClickButton(button)
                end
                nyxSkipConnections["buttonAdded"] = child.ChildAdded:Connect(function(buttonChild)
                    if buttonChild.Name == "SkipCutsceneButton" and buttonChild:IsA("GuiButton") then
                        wait(0.05)
                        if buttonChild.Visible then
                            continuousClickButton(buttonChild)
                        end
                    end
                end)
            end
        end)
        local function monitorExistingButton()
            local nyxCutscene = playerGui:FindFirstChild("NyxCutscene")
            if nyxCutscene then
                local button = nyxCutscene:FindFirstChild("SkipCutsceneButton")
                if button and button:IsA("GuiButton") then
                    if button.Visible then
                        continuousClickButton(button)
                    end
                    nyxSkipConnections["buttonVisible"] = button:GetPropertyChangedSignal("Visible"):Connect(function()
                        if button.Visible then
                            wait(0.05)
                            continuousClickButton(button)
                        end
                    end)
                end
            end
        end
        monitorExistingButton()
        nyxSkipCoroutine = coroutine.create(function()
            while true do
                wait(1)  
                local button = getNyxSkipButton()
                if button and button:IsA("GuiButton") and button.Visible then
                    continuousClickButton(button)
                end
            end
        end)
        coroutine.resume(nyxSkipCoroutine)
    else
        for name, connection in pairs(nyxSkipConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        nyxSkipConnections = {}
        if nyxSkipCoroutine then
            coroutine.close(nyxSkipCoroutine)
            nyxSkipCoroutine = nil
        end
        for _, thread in pairs(nyxClickThreads) do
            if thread then
                coroutine.close(thread)
            end
        end
        nyxClickThreads = {}
    end
end
ExTab:CreateToggle({
    Name = "Auto Skip Nyx Cutscene",
    CurrentValue = false,
    Flag = "lesbian9",
    Callback = function(Value)
        autoSkipNyxCutsceneV2(Value)
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
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local isAutoRaidActive = false
local raidCoroutine = nil
local skipToFinalBoss = false
local isCollectingChests = true
local chestCollectCoroutine = nil
local keyCollectCoroutine = nil
local PlaceId = game.PlaceId
local JobId = game.JobId
local firedPrompts = {}
local allKeysCollected = false
local MAX_DISTANCE = 2000
local FIRE_ITER = 5
local FIRE_WAIT = 0.03
local function isInShadowRaid()
    return Workspace:FindFirstChild("IsShadowRaid") or 
           Workspace:FindFirstChild("ShadowRaidBool")
end

local function useTool(toolName, amount, delayTime)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character.Parent then
        character = player.CharacterAdded:Wait()
    end
    local hrp = character:WaitForChild("HumanoidRootPart", 10)
    if not hrp then
        warn("HumanoidRootPart not found!")
        return false
    end
    local backpack = player:WaitForChild("Backpack", 10)
    if not backpack then
        warn("Backpack not found!")
        return false
    end
    local tool = backpack:FindFirstChild(toolName)
    if not tool then
        warn("Tool not found: " .. toolName)
        return false
    end
    tool.Parent = character
    task.spawn(function()
        for i = 1, amount do
            if tool and tool.Parent == character then
                tool:Activate()
                task.wait(delayTime > 0 and delayTime or 0.1)
            end
        end
        if tool then
            tool.Parent = backpack
        end
    end)
    return true
end
local function teleportTo(position)
    local character = player.Character
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    pcall(function()
        hrp.CFrame = CFrame.new(position)
    end)
    task.wait(0.5)
    return true
end
local function isNearPosition(targetPos, radius)
    local character = player.Character
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    return (hrp.Position - targetPos).Magnitude <= radius
end
local function checkProximityAvailable(promptName)
    local proximityParts = Workspace:FindFirstChild("ShadowRaidCastle")
    if proximityParts then
        proximityParts = proximityParts:FindFirstChild("ProximityParts")
        if proximityParts then
            local promptPart = proximityParts:FindFirstChild(promptName)
            if promptPart then
                local prompt = promptPart:FindFirstChild("ProximityPrompt")
                if prompt then
                    return prompt.Enabled
                end
            end
        end
    end
    return false
end
local function findAndFireProximityPrompt(promptName)
    if firedPrompts[promptName] then
        return true
    end
    local proximityParts = Workspace:FindFirstChild("ShadowRaidCastle")
    if proximityParts then
        proximityParts = proximityParts:FindFirstChild("ProximityParts")
        if proximityParts then
            local promptPart = proximityParts:FindFirstChild(promptName)
            if promptPart then
                local prompt = promptPart:FindFirstChild("ProximityPrompt")
                if prompt and prompt.Enabled then
                    local character = player.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            pcall(function()
                                hrp.CFrame = promptPart.CFrame
                            end)
                            task.wait(0.5)
                            do
                                if prompt and prompt.Parent and prompt.Enabled then
                                    fireproximityprompt(prompt)
                                    task.wait(0.05)
                                end
                            end
                            firedPrompts[promptName] = true
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end
local function areMobsPresent()
    local mobFolder = Workspace:FindFirstChild("MobFolder")
    if not mobFolder then return false end
    for _, mob in ipairs(mobFolder:GetChildren()) do
        if not Players:GetPlayerFromCharacter(mob) then
            local humanoid = mob:FindFirstChildWhichIsA("Humanoid")
            if humanoid and humanoid.Health > 0 then
                return true  
            end
        end
    end
    return false
end
local function waitForMobsClear(timeout)
    timeout = timeout or 10  
    local startTime = tick()
    while tick() - startTime < timeout do
        if not areMobsPresent() then
            return true
        end
        task.wait(1)
    end
    return false
end
local function startChestCollection()
    while isCollectingChests and isAutoRaidActive do
        local character = player.Character
        if not character then
            task.wait(1)
            continue
        end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            task.wait(1)
            continue
        end
        local origin = hrp.Position
        local nearestEntry = nil
        local nearestDist = math.huge
        local function searchForChests(parent)
            for _, child in ipairs(parent:GetDescendants()) do
                if child:IsA("ProximityPrompt") and child.Enabled then
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
        local shadowRaidCastle = Workspace:FindFirstChild("ShadowRaidCastle")
        if shadowRaidCastle then
            local chestSpawns = shadowRaidCastle:FindFirstChild("ChestSpawns")
            if chestSpawns then
                for _, folder in ipairs(chestSpawns:GetChildren()) do
                    if folder:IsA("Folder") then
                        searchForChests(folder)
                    end
                end
                searchForChests(chestSpawns)
            end
        end
        if nearestEntry then
            pcall(function()
                hrp.CFrame = nearestEntry.primaryPart.CFrame * CFrame.new(0, 0, 0)
            end)
            for i = 1, FIRE_ITER do
                if not isCollectingChests or not isAutoRaidActive then break end
                if not nearestEntry.prompt.Parent then break end
                pcall(fireproximityprompt, nearestEntry.prompt)
                task.wait(FIRE_WAIT)
            end
            task.wait(0.08)
        else
            task.wait(0.1)
        end
    end
end
local function waitForKeyToDisappear(keyName)
    while isAutoRaidActive do
        local key = Workspace:FindFirstChild(keyName)
        if not key then
            print(keyName .. " collected or despawned.")
            break
        end
        pcall(function()
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = CFrame.new(key:GetPivot().Position)
        end)
        task.wait(0.2)
    end
end

local function startKeyCollection()
    if skipToFinalBoss then
        return
    end
    while isAutoRaidActive and not allKeysCollected do
        local character = player.Character
        if not character then
            task.wait(1)
            continue
        end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            task.wait(1)
            continue
        end
        local keyWavePositions = {
            {name = "ShadowRaidKey1", spawnPos = Vector3.new(-8474, 1070, 3859)},
            {name = "ShadowRaidKey2", spawnPos = Vector3.new(-7717, 1070, 3808)},
            {name = "ShadowRaidKey3", spawnPos = Vector3.new(-9093, 1070, 3808)}
        }
        local key1 = Workspace.ShadowRaidCastle:FindFirstChild("ShadowRaidKey1")
        if key1 then
            local prompt1 = key1:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt1 then
                if prompt1.Enabled then
                    print("Collecting ShadowRaidKey1")
                    pcall(function()
                        hrp.CFrame = key1.CFrame
                    end)
                    task.wait(0.5)
                    for i = 1, 5 do
                        if prompt1 and prompt1.Parent and prompt1.Enabled then
                            fireproximityprompt(prompt1)
                            task.wait(0.05)
                        end
                    end
                    print("ShadowRaidKey1 collected!")
                    task.wait(1)
                else
                    print("Triggering wave for ShadowRaidKey1")
                    pcall(function()
                        hrp.CFrame = CFrame.new(keyWavePositions[1].spawnPos)
                    end)
                    task.wait(1)
                    if areMobsPresent() then
                        print("Waiting for mobs to clear at Key1")
                        waitForMobsClear(20)
                    end
                end
            end
        else
            for i = 2, 3 do
                local keyName = "ShadowRaidKey" .. i
                local key = Workspace.ShadowRaidCastle:FindFirstChild(keyName)
                if key then
                    local prompt = key:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        if prompt.Enabled then
                            print("Collecting " .. keyName)
                            pcall(function()
                                hrp.CFrame = key.CFrame
                            end)
                            task.wait(0.5)
                            for j = 1, 5 do
                                if prompt and prompt.Parent and prompt.Enabled then
                                    fireproximityprompt(prompt)
                                    task.wait(0.05)
                                end
                            end
                            print(keyName .. " collected!")
                            task.wait(1)
                        else
                            print("Triggering wave for " .. keyName)
                            pcall(function()
                                hrp.CFrame = CFrame.new(keyWavePositions[i].spawnPos)
                            end)
                            task.wait(1)
                            if areMobsPresent() then
                                print("Waiting for mobs to clear at " .. keyName)
                                waitForMobsClear(20)
                            end
                        end
                        break 
                    end
                end
            end
        end
        local foundKey = false
        for _, descendant in pairs(Workspace.ShadowRaidCastle:GetDescendants()) do
            if descendant.Name:lower():find("shadowraidkey") then
                foundKey = true
                break
            end
        end
        if not foundKey then
            allKeysCollected = true
            print("All keys collected - no keys found in ShadowRaidCastle!")
            break
        else
            allKeysCollected = false
            print("Keys still present, continuing collection...")
        end
        task.wait(1) 
    end
end
local function areChestsRemaining()
    if not isCollectingChests then
        return false
    end
    local shadowRaidCastle = Workspace:FindFirstChild("ShadowRaidCastle")
    if not shadowRaidCastle then return false end
    local chestSpawns = shadowRaidCastle:FindFirstChild("ChestSpawns")
    if not chestSpawns then return false end
    for _, child in ipairs(chestSpawns:GetDescendants()) do
        if child:IsA("ProximityPrompt") and child.Enabled then
            return true
        end
    end
    return false
end
local function areKeysRemaining()
    local shadowRaidCastle = Workspace:FindFirstChild("ShadowRaidCastle")
    if not shadowRaidCastle then return false end
    local key1 = shadowRaidCastle:FindFirstChild("ShadowRaidKey1")
    local key2 = shadowRaidCastle:FindFirstChild("ShadowRaidKey2")
    local key3 = shadowRaidCastle:FindFirstChild("ShadowRaidKey3")
    return (key1 ~= nil) or (key2 ~= nil) or (key3 ~= nil)
end
local function checkKeyDoorAvailable()
    local keyDoor = Workspace.ShadowRaidCastle:FindFirstChild("KeyDoor")
    if keyDoor then
        local keyProximityPart = keyDoor:FindFirstChild("KeyProximity")
        if keyProximityPart then
            local prompt = keyProximityPart:FindFirstChild("ProximityPrompt")
            if prompt then
                return prompt.Enabled
            end
        end
    end
    return false
end
local function findAndFireKeyDoorProximity()
    if firedPrompts["KeyDoor"] then
        return true
    end
    local keyDoor = Workspace.ShadowRaidCastle:FindFirstChild("KeyDoor")
    if keyDoor then
        local keyProximityPart = keyDoor:FindFirstChild("KeyProximity")
        if keyProximityPart then
            local prompt = keyProximityPart:FindFirstChild("ProximityPrompt")
            if prompt and prompt.Enabled then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function()
                            hrp.CFrame = keyProximityPart.CFrame
                        end)
                        task.wait(0.135)
                        for i = 1, 10 do
                            if prompt and prompt.Parent and prompt.Enabled then
                                fireproximityprompt(prompt)
                                task.wait(0.05)
                            end
                        end
                        firedPrompts["KeyDoor"] = true
                        return true
                    end
                end
            end
        end
    end
    return false
end
local function checkFloorGateAvailable()
    local floorGate = Workspace.ShadowRaidCastle:FindFirstChild("FloorGate")
    if floorGate then
        local hrp = floorGate:FindFirstChild("HumanoidRootPart")
        if hrp then
            local prompt = hrp:FindFirstChild("GateOpenProximity")
            if prompt then
                return prompt.Enabled
            end
        end
    end
    return false
end
local function findAndFireFloorGateProximity()
    if firedPrompts["FloorGate"] then
        return true
    end
    local floorGate = Workspace.ShadowRaidCastle:FindFirstChild("FloorGate")
    if floorGate then
        local hrp = floorGate:FindFirstChild("HumanoidRootPart")
        if hrp then
            local prompt = hrp:FindFirstChild("GateOpenProximity")
            if prompt and prompt.Enabled then
                local character = player.Character
                if character then
                    local playerHrp = character:FindFirstChild("HumanoidRootPart")
                    if playerHrp then
                        pcall(function()
                            playerHrp.CFrame = hrp.CFrame
                        end)
                        task.wait(0.5)
                        for i = 1, 5 do
                            if prompt and prompt.Parent and prompt.Enabled then
                                fireproximityprompt(prompt)
                                task.wait(0.05)
                            end
                        end
                        firedPrompts["FloorGate"] = true
                        return true
                    end
                end
            end
        end
    end
    return false
end
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId
local JobId = game.JobId
local player = Players.LocalPlayer
local function hopToRandomServer()
    local teleporting = false
    local teleportStateConnection = nil
    local teleportSuccess = false
    local function cleanup()
        if teleportStateConnection then
            teleportStateConnection:Disconnect()
            teleportStateConnection = nil
        end
        teleporting = false
    end
    local function attemptTeleport()
        local function getAllServers()
            local url = string.format(
                "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
                PlaceId
            )
            local success, res = pcall(function()
                return game:HttpGet(url)
            end)
            if not success or not res then return {} end
            local decoded = HttpService:JSONDecode(res)
            return decoded and decoded.data or {}
        end
        while not teleportSuccess and not teleporting do
            local servers = getAllServers()
            local bestServer = nil
            local lowestPlayerCount = math.huge
            for _, server in ipairs(servers) do
                if server.id ~= JobId and server.playing < server.maxPlayers then
                    if server.playing < lowestPlayerCount then
                        lowestPlayerCount = server.playing
                        bestServer = server
                    end
                end
            end
            if bestServer then
                print("Best server found - Players: ".. bestServer.playing .."/".. bestServer.maxPlayers)
                teleporting = true
                teleportStateConnection = TeleportService.TeleportInitFailed:Connect(function()
                    print("Teleport failed, retrying...")
                    teleporting = false
                    teleportSuccess = false
                    cleanup()
                    task.wait(0.5)
                end)
                local ok, err = pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceId, bestServer.id, player)
                end)
                if not ok then
                    print("Teleport error: " .. tostring(err))
                    teleporting = false
                    teleportSuccess = false
                    cleanup()
                else
                    print("Teleport initiated successfully")
                    task.wait(0.5)
                    if not teleportSuccess then
                        print("Teleport seems stuck, retrying...")
                        teleporting = false
                        cleanup()
                    end
                end
            else
                print("No suitable server found, retrying in 2 seconds...")
                task.wait(0.5)
            end
        end
    end
    spawn(attemptTeleport)
end
local rejoinCoroutine = nil
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local function startAutoRejoin()
    while isAutoRaidActive do
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local currentPos = hrp.Position
                local targetPos = Vector3.new(-7490, 3987, 5382)
                local distance = (currentPos - targetPos).Magnitude
                if distance <= 500 then
                    if skipToFinalBoss then
                        print("Near final boss position, firing Proximity5...")
                        task.wait(1)
                        findAndFireProximityPrompt("Proximity5")
                    else
                        while areChestsRemaining() do
                        task.wait(2)
                        end
                        print("Near final boss position, auto-rejoining...")
                        hopToRandomServer()
                    end
                    break
                end
            end
        end
        task.wait(1)
    end
end
local hasProcessedProximity2 = false

local function startAutoRaid()
    firedPrompts = {}
    if not rejoinCoroutine then
        rejoinCoroutine = coroutine.create(startAutoRejoin)
        coroutine.resume(rejoinCoroutine)
    end
    allKeysCollected = false
    
    if not isInShadowRaid() then
        task.spawn(function()
            while true do
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
                if isInShadowRaid() then
                    break
                end
                task.wait(0.01)
                useTool("Shadow Invitation" ,5 ,0.1)
                task.wait(0.1)
            end
        end)
    end
    
    if isCollectingChests and not chestCollectCoroutine then
        chestCollectCoroutine = coroutine.create(startChestCollection)
        coroutine.resume(chestCollectCoroutine)
    end
    if not hasProcessedProximity2 then
        local Players = game:GetService("Players")
        local playerCount = #Players:GetPlayers()
        if playerCount > 1 then
        return
        end
        print("Step 1: Entering the castle...")
        local character = player.Character
        if character then
            task.wait(1)
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                task.wait(1)
                local promptPart = workspace.ShadowRaidCastle.ProximityParts.Proximity2
                local prompt = promptPart.ProximityPrompt
                pcall(function() hrp.CFrame = promptPart.CFrame end)
                task.wait(0.5)
                for i = 1, 1 do
                    if prompt and prompt.Parent and prompt.Enabled then
                        task.wait(0.135)
                        fireproximityprompt(prompt)
                        task.wait(0.05)
                    end
                end
                if skipToFinalBoss then
                    task.wait(1)
                    useTool("Gatekeeper Key", 5, 0.1)
                    task.wait(0.1)
                    pcall(function() hrp.CFrame = hrp.CFrame * CFrame.new(20, 0, 20) end)
                    task.wait(0.2)
                    pcall(function() hrp.CFrame = promptPart.CFrame end)
                    task.wait(0.5)
                    for i = 1, 1 do
                        if prompt and prompt.Parent and prompt.Enabled then
                            task.wait(0.135)
                            fireproximityprompt(prompt)
                            task.wait(0.05)
                        end
                    end
                else
                    task.wait(2)
                    pcall(function() hrp.CFrame = hrp.CFrame * CFrame.new(20, 0, 20) end)
                    task.wait(0.2)
                    pcall(function() hrp.CFrame = promptPart.CFrame end)
                    task.wait(0.5)
                    for i = 1, 1 do
                        if prompt and prompt.Parent and prompt.Enabled then
                            task.wait(0.135)
                            fireproximityprompt(prompt)
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
        hasProcessedProximity2 = true
    end
    if isNearPosition(Vector3.new(-8474, 1065, 3538), 1000) then
    print("Step 3: Inside castle, starting collection...")
    waitForKeyToDisappear("ShadowRaidKey1")
    waitForKeyToDisappear("ShadowRaidKey2")
    waitForKeyToDisappear("ShadowRaidKey3")
    if not keyCollectCoroutine then
        task.wait(5)
        keyCollectCoroutine = coroutine.create(startKeyCollection)
        coroutine.resume(keyCollectCoroutine)
    end
    while isAutoRaidActive and (not allKeysCollected or areChestsRemaining()) do
        task.wait(0.5)
    end
        if allKeysCollected and not areChestsRemaining() then
            print("Step 4: All keys and chests collected, progressing...")
            while isAutoRaidActive and not checkKeyDoorAvailable() do
                task.wait(0.5)
            end
            if not keyCollectRunning then
            keyCollectRunning = true
            task.spawn(function()
            task.wait(5)
                startKeyCollection()
            keyCollectRunning = false
                end)
            end
            while areChestsRemaining() do
            task.wait(1.3)
            end
            while areKeysRemaining() do
            task.wait(1.3)
            end
            findAndFireKeyDoorProximity()
            task.wait(0.135)
            findAndFireKeyDoorProximity()
            waitForMobsClear(10)
            while isAutoRaidActive and (not checkProximityAvailable("Proximity3") or areChestsRemaining()) do
                task.wait(1.3)
            end
            waitForMobsClear(10)
            while areChestsRemaining() do
            task.wait(1.3)
            end            
            findAndFireProximityPrompt("Proximity3")
            task.wait(0.135)
            findAndFireProximityPrompt("Proximity3")
            task.wait(0.05)
        end
    end
    if isNearPosition(Vector3.new(-5611, 2729, 4465), 1000) then
        waitForMobsClear(10)
        while isAutoRaidActive and (not checkFloorGateAvailable() or areChestsRemaining()) do
            task.wait(1.3)
        end
        while areChestsRemaining() do
        task.wait(1.3)
        end
        findAndFireFloorGateProximity()
        task.wait(0.135)
        while isAutoRaidActive and (not checkProximityAvailable("Proximity4") or areChestsRemaining()) do
            task.wait(1.3)
        end
        findAndFireProximityPrompt("Proximity4")
        task.wait(0.135)
        findAndFireProximityPrompt("Proximity4")
        task.wait(0.05)
    end
    if isNearPosition(Vector3.new(-7490, 3987, 5382), 500) and skipToFinalBoss then
    task.wait(1)
    findAndFireProximityPrompt("Proximity5")
    end
end
ManTab:CreateToggle({
    Name = "Auto Shadow Raid",
    CurrentValue = false,
    Flag = "lesbian4",
    Callback = function(value)
        isAutoRaidActive = value
        hasProcessedProximity2 = false
        if isAutoRaidActive then
            raidCoroutine = task.spawn(function()
                local player = game.Players.LocalPlayer
                while isAutoRaidActive do
                    local character = player.Character or player.CharacterAdded:Wait()
                    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
                    local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
                    local ok, err = pcall(startAutoRaid)
                    if not ok then
                        warn("[AutoShadowRaid] startAutoRaid error:", err)
                    end
                    task.wait(1)
                end
            end)
        else
            isAutoRaidActive = false
            raidCoroutine = nil
            if keyCollectCoroutine then
                keyCollectCoroutine = nil
            end
            if chestCollectCoroutine then
                chestCollectCoroutine = nil
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
                    local shadowRaidCastle = workspace:FindFirstChild("ShadowRaidCastle")
                    if shadowRaidCastle then
                        local chestSpawns = shadowRaidCastle:FindFirstChild("ChestSpawns")
                        if chestSpawns then
                            for _, folder in ipairs(chestSpawns:GetChildren()) do
                                if folder:IsA("Folder") then
                                    searchForChests(folder)
                                end
                            end
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
    end
    rs:Set3dRenderingEnabled(false)
end
ExTab:CreateToggle({
    Name = "Toggle Anti Memory Leak",
    CurrentValue = false,
    Flag = "lesbian13",
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
local NORMAL_DISTANCE = 20
local FLEE_DISTANCE = 1000
local TOTAL_DISTANCE = NORMAL_DISTANCE
local MAX_TARGET_DISTANCE = 8000
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
local function checkHealthAndAdjustDistance()
    if not player or not player.Character then
        return
    end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end
    local healthPercent = (humanoid.Health / humanoid.MaxHealth) * 100
    if healthPercent < 30 then
        TOTAL_DISTANCE = FLEE_DISTANCE
    elseif healthPercent >= 80 then
        TOTAL_DISTANCE = NORMAL_DISTANCE
    end
end
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
    Flag = "lesbian6",
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
                checkHealthAndAdjustDistance()
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
                        local TOTAL_DISTANCEToTarget = (hrp.Position - currentTarget.Position).Magnitude
                        if TOTAL_DISTANCEToTarget <= MAX_TARGET_DISTANCE then
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
            TOTAL_DISTANCE = NORMAL_DISTANCE 
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
    tools = {"Terrorsteel Edges"},
    sequence = {
        {
            attack = "Slash",
            key = "M1",
            remote = "AttackEvent",
            args = function(char, tool, attack, pos)
                return {
                    {key = "M1", attack = "Slash"},
                    {MouseBehavior = "Default", MousePos = pos}
                }
            end
        },
        {
            attack = "Shadow Spin",
            key = "Q",
            remote = "AttackEvent",
            args = function(char, tool, attack, pos)
                return {
                    {key = "Q", attack = "Shadow Spin"},
                    {MouseBehavior = "Default", MousePos = pos}
                }
            end
        },
        {
            attack = "Shadow Slam",
            key = "E",
            remote = "AttackEvent",
            args = function(char, tool, attack, pos)
                return {
                    {key = "E", attack = "Shadow Slam"},
                    {MouseBehavior = "Default", MousePos = pos}
                }
            end
        },
        {
            attack = "Shadow Slashes",
            key = "F",
            remote = "AttackEvent",
            args = function(char, tool, attack, pos)
                return {
                    {key = "F", attack = "Shadow Slashes"},
                    {MouseBehavior = "Default", MousePos = pos}
                }
            end
        }
    }
},
        {
            tools = {"Cataclysm"},
            sequence = {
                {attack = "Slash", key = "M1", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "M1", attack = "Slash"}, {MousePos = pos}} end},
                {attack = "Cyclone", key = "Q", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "Q", attack = "Cyclone"}, {MousePos = pos}} end},
                {attack = "Crow Pillars", key = "F", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "F", attack = "Crow Pillars"}, {MousePos = pos}} end},                
                {attack = "Teleport Slam", key = "E", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "E", attack = "Teleport Slam"}, {MousePos = pos}} end}
            }
        },
        {
            tools = {"Astral Convergence"},
            sequence = {
                {attack = "Slash", key = "M1", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "M1", attack = "Slash"}, {MousePos = pos}} end},
                {attack = "Astral Lunge", key = "Q", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "Q", attack = "Astral Lunge"}, {MousePos = pos}} end},  
                {attack = "Link/Sever", key = "E", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "E", attack = "Link/Sever"}, {MousePos = pos}} end}
            }
        },
        {
            tools = {"Tyrannical Greatsword"},
            sequence = {
                {attack = "Slash", key = "M1", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "M1", attack = "Slash"}, {MousePos = pos}} end},
                {attack = "Vicious Thrusts", key = "Q", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "Q", attack = "Vicious Thrusts"}, {MousePos = pos}} end},
                {attack = "All Dark", key = "F", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "F", attack = "All Dark"}, {MousePos = pos}} end},                
                {attack = "Void Saw", key = "E", remote = "AttackEvent", args = function(char, tool, attack, pos) return {{key = "E", attack = "Void Saw"}, {MousePos = pos}} end}
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
                task.wait(0.00001)
                executeAttack(character, skill.tool, nil, skill.remote, skill.args)
                task.wait(0.00001)
            end
            task.wait(0.00001)
        end)
    end
end
local function setupCharacter(character)
    remoteCache = {}
    if _G.AutoSkillActive then
        task.wait(0.00001)
        startAutoSkills(character)
        task.wait(0.00001)
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
    Flag = "lesbian7",
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
local function isInShadowRaid()
    return Workspace:FindFirstChild("IsShadowRaid") or 
           Workspace:FindFirstChild("ShadowRaidBool")
end
local function equipAllItems()
    if not player or not player.Character then return end
    if not isInShadowRaid() then return end 
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    for _, item in pairs(backpack:GetChildren()) do
        if (item:IsA("Tool") or item:IsA("HopperBin")) and 
           item.Name ~= "Gatekeeper Key" and 
           item.Name ~= "Shadow Invitation" then
            pcall(function()
                item.Parent = player.Character
            end)
        end
    end
end
local function unequipAllItems()
    if not player or not player.Character then return end
    for _, item in pairs(player.Character:GetChildren()) do
        if (item:IsA("Tool") or item:IsA("HopperBin")) and 
           item.Name ~= "Gatekeeper Key" and 
           item.Name ~= "Shadow Invitation" then
            pcall(function()
                local backpack = player:FindFirstChildOfClass("Backpack")
                if backpack then
                    item.Parent = backpack
                end
            end)
        end
    end
end
local autoEquipConnection = nil
local characterAddedConnection = nil
local humanoidDiedConnection = nil
ManTab:CreateToggle({
    Name = "Auto Equip All Items",
    Flag = "lesbian8",
    CurrentValue = _G.AutoEquipActive,
    Callback = function(value)
        local Players = game:GetService("Players")
        local playerCount = #Players:GetPlayers()
        if playerCount > 1 then
        return
        end
        _G.AutoEquipActive = value
        if autoEquipConnection then
            autoEquipConnection:Disconnect()
            autoEquipConnection = nil
        end
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
        if humanoidDiedConnection then
            humanoidDiedConnection:Disconnect()
            humanoidDiedConnection = nil
        end
        if _G.AutoEquipActive then
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 and isInShadowRaid() then 
                    task.wait(1) 
                    equipAllItems()
                end
            end
            characterAddedConnection = player.CharacterAdded:Connect(function(character)
                task.wait(1)
                humanoidDiedConnection = character:WaitForChild("Humanoid").Died:Connect(function()
                    unequipAllItems()
                end)
                if isInShadowRaid() then 
                    equipAllItems()
                end
            end)
            autoEquipConnection = player.ChildAdded:Connect(function(child)
                if child:IsA("Backpack") then
                    task.wait(1)
                    if player.Character and isInShadowRaid() then 
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            task.wait(0.5)
                            equipAllItems()
                        end
                    end
                end
            end)
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoidDiedConnection = humanoid.Died:Connect(function()
                        unequipAllItems()
                    end)
                end
            end
        else
            unequipAllItems()
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