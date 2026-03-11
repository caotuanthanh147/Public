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



local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local isAutoRaid = false
local autoRaidCo = nil
local CHUMBO_POS = Vector3.new(1073, 880, 213)
local NEAR_DISTANCE = 50
local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
local function teleportTo(pos)
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end
local function fireRaid()
    local dialogue = ReplicatedStorage
        :WaitForChild("requests")
        :WaitForChild("character")
        :WaitForChild("dialogue")
    local chumbo = Workspace:FindFirstChild("Npcs") and Workspace.Npcs:FindFirstChild("Chumbo")
    if not chumbo then return false end
    dialogue:FireServer(chumbo, "Raid.")
    return true
end
MiscTab:CreateToggle({
    Name = "Auto Raid",
    CurrentValue = false,
    Callback = function(value)
        isAutoRaid = value
        if game.PlaceId ~= 14890802310 then return end
        if isAutoRaid then
            if autoRaidCo and coroutine.status(autoRaidCo) ~= "dead" then return end
            autoRaidCo = coroutine.create(function()
                while isAutoRaid do
                    local hrp = getHRP()
                    if not hrp then
                        task.wait(1)
                        continue
                    end
                    local dist = (hrp.Position - CHUMBO_POS).Magnitude
                    if dist > NEAR_DISTANCE then
                        teleportTo(CHUMBO_POS)
                        task.wait(1)
                    end
                    task.wait(0.5)
                    local fired = fireRaid()
                    if not fired then
                        task.wait(2)
                        continue
                    end
                    task.wait(12)
                end
            end)
            coroutine.resume(autoRaidCo)
        else
            isAutoRaid = false
            if autoRaidCo then
                coroutine.close(autoRaidCo)
                autoRaidCo = nil
            end
        end
    end
})
local isMeditating = false
local meditateCo = nil
local NEAR_DISTANCE = 50
local STOP_POSITION = Vector3.new(1076, 13330, 30)
local STOP_DISTANCE = 100 
local function getMeditatePosition()
	local liveNPC = Workspace:FindFirstChild("Npcs")
		and Workspace.Npcs:FindFirstChild("Meditation")
	if liveNPC then
		return liveNPC:GetPivot().Position
	end
	local cache = ReplicatedStorage:FindFirstChild("assets")
		and ReplicatedStorage.assets:FindFirstChild("npc_cache")
		and ReplicatedStorage.assets.npc_cache:FindFirstChild("Meditation")
	if cache then
		return cache:GetPivot().Position
	end
	return nil
end
local function waitForNPC(npcName, timeout)
	local deadline = tick() + (timeout or 10)
	while tick() < deadline do
		local npc = Workspace:FindFirstChild("Npcs")
			and Workspace.Npcs:FindFirstChild(npcName)
		if npc then
			return npc
		end
		task.wait(0.2)
	end
	return nil
end
MiscTab:CreateToggle({
	Name = "Auto Meditate",
	CurrentValue = false,
	Callback = function(value)
		isMeditating = value
		local hrp = getHRP()
		if hrp and (hrp.Position - STOP_POSITION).Magnitude <= STOP_DISTANCE then
			return
		end
		if isMeditating then
			if meditateCo and coroutine.status(meditateCo) ~= "dead" then
				return
			end
			meditateCo = coroutine.create(function()
				while isMeditating do
					local hrp = getHRP()
					if not hrp then
						task.wait(0.1)
						continue
					end
					if (hrp.Position - STOP_POSITION).Magnitude <= STOP_DISTANCE then
						task.wait(1)
						continue
					end
					local meditatePos = getMeditatePosition()
					if not meditatePos then
						task.wait(0.1)
						continue
					end
					local dist = (hrp.Position - meditatePos).Magnitude
					if dist > NEAR_DISTANCE then
						teleportTo(meditatePos + Vector3.new(0, 3, 4))
						task.wait(0.1)
					end
					local meditationNPC = waitForNPC("Meditation", 2)
					if not meditationNPC then
						task.wait(1)
						continue
					end
					local cacheRemote = ReplicatedStorage:FindFirstChild("assets")
						and ReplicatedStorage.assets:FindFirstChild("npc_cache")
						and ReplicatedStorage.assets.npc_cache:FindFirstChild("Meditation")
					if cacheRemote then
						cacheRemote:FireServer()
						task.wait(10)
					end
					local dialogueRemote = ReplicatedStorage:FindFirstChild("requests")
						and ReplicatedStorage.requests:FindFirstChild("character")
						and ReplicatedStorage.requests.character:FindFirstChild("dialogue")
					if dialogueRemote then
						dialogueRemote:FireServer(meditationNPC, "Meditate.")
						task.wait(0.1)
						local selfNPC = Workspace.Npcs:FindFirstChild("The Self")
						if selfNPC then
							dialogueRemote:FireServer(selfNPC, "Yes.")
							task.wait(0.1)
						end
					end
					task.wait(2)
				end
			end)
			coroutine.resume(meditateCo)
		else
			isMeditating = false
			if meditateCo then
				coroutine.close(meditateCo)
				meditateCo = nil
			end
		end
	end
})
local isAutoCollectActive = false
local autoCollectConnection
MiscTab:CreateToggle({
    Name = "Auto Collect Items",
    CurrentValue = false,
    Callback = function(value)
        isAutoCollectActive = value
        if isAutoCollectActive then
            if autoCollectConnection then
                autoCollectConnection:Disconnect()
            end
            autoCollectConnection = RunService.Heartbeat:Connect(function()
                local success, errorMessage = pcall(function()
                    local player = Players.LocalPlayer
                    if not player then return end
                    local character = player.Character
                    if not character then return end
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    for _, model in ipairs(workspace:GetChildren()) do
                        if model:IsA("Model") then
                            for _, obj in ipairs(model:GetDescendants()) do
                                if obj:IsA("ProximityPrompt") then
                                    if obj.Parent:IsA("BasePart") then
                                        hrp.CFrame = obj.Parent.CFrame
                                        task.wait(1)
                                    end
                                    fireproximityprompt(obj)
                                end
                            end
                        end
                    end
                end)
                if not success then
                    warn("Error in auto collect loop: " .. errorMessage)
                end
            end)
        else
            if autoCollectConnection then
                autoCollectConnection:Disconnect()
                autoCollectConnection = nil
            end
        end
    end
})

local player = Players.LocalPlayer
local isPullAllActive = false
local pullAllCoroutine = nil
local TELEPORT_OFFSET = CFrame.new(0, 0, -4)
MiscTab:CreateToggle({
    Name = "Bring NPC",
    CurrentValue = false,
    Callback = function(value)
        isPullAllActive = value
        if isPullAllActive then
            pullAllCoroutine = coroutine.create(function()
                if not player then return end
                while isPullAllActive do
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then
                        task.wait(1)
                    else
                        sethiddenproperty(player, "SimulationRadius", 2000)
                        sethiddenproperty(player, "MaxSimulationRadius", 2000)
                        local liveFolder = workspace:FindFirstChild("Live")
                        if not liveFolder then
                            task.wait(1)
                            continue
                        end
                        local npcs = {}
                        local maxDistSq = 10 * 10
                        for _, d in pairs(liveFolder:GetDescendants()) do
                            if d.ClassName == "Humanoid" then
                                local model = d.Parent
                                if model then
                                    local isPlayerCharacter = false
                                    for _, pl in pairs(Players:GetPlayers()) do
                                        if pl.Character and pl.Character == model then
                                            isPlayerCharacter = true
                                            break
                                        end
                                    end
                                    if not isPlayerCharacter then
                                        local part = model:FindFirstChild("HumanoidRootPart")
                                                 or model.PrimaryPart
                                                 or model:FindFirstChild("Torso")
                                                 or (function()
                                                        for _, v in pairs(model:GetChildren()) do
                                                            if v:IsA("BasePart") then return v end
                                                        end
                                                        return nil
                                                    end)()
                                        if part and part:IsA("BasePart") then
                                            local diff = hrp.Position - part.Position
                                            local distSq = diff:Dot(diff)
                                            if distSq <= maxDistSq then
                                                table.insert(npcs, {hum = d, model = model, part = part})
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        local total = #npcs
                        local baseCFrame = hrp.CFrame * TELEPORT_OFFSET
                        for i, obj in ipairs(npcs) do
                            if not isPullAllActive then break end
                            local targetPart = obj.part
                            if targetPart and targetPart:IsA("BasePart") then
                                local radius = 2 + (i % 5)
                                local angle = 0
                                if total > 0 then
                                    angle = ((i-1) / math.max(total, 1)) * math.pi * 2
                                end
                                local offsetVec = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                                local targetCFrame = baseCFrame * CFrame.new(offsetVec)
                                targetPart.CFrame = targetCFrame
                            end
                        end
                        task.wait(5)
                    end
                end
            end)
            if pullAllCoroutine and coroutine.status(pullAllCoroutine) == "suspended" then
                coroutine.resume(pullAllCoroutine)
            end
        else
            isPullAllActive = false
            if pullAllCoroutine then
                coroutine.close(pullAllCoroutine)
                pullAllCoroutine = nil
            end
        end
    end
})

local Workspace = game:GetService("Workspace")
local inKill = false
local inKillCo = nil
ManTab:CreateToggle({
    Name = "Kill all",
    CurrentValue = false,
    Callback = function(value)
        if inKill == value then
            return
        end
        inKill = value
        if inKill then
            sethiddenproperty(Players.LocalPlayer, "SimulationRadius", 1124)
            sethiddenproperty(Players.LocalPlayer, "MaxSimulationRadius", 1124)
            if inKillCo and coroutine.status(inKillCo) ~= "dead" then
                return
            end
            inKillCo = coroutine.create(function()
                while inKill do
                    local liveFolder = Workspace:FindFirstChild("Live")
                    if liveFolder then
                        local playerChars = {}
                        for _, pl in ipairs(Players:GetPlayers()) do
                            if pl.Character then
                                playerChars[pl.Character] = true
                            end
                        end
                        for _, d in ipairs(liveFolder:GetDescendants()) do
                            if d:IsA("Humanoid") then
                                local model = d.Parent
                                if not playerChars[model] then
                                    d.Health = 0
                        
                                    for _, part in ipairs(model:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.Anchored = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
            coroutine.resume(inKillCo)
        else
            inKill = false
            if inKillCo then
                coroutine.close(inKillCo)
                inKillCo = nil
            end
        end
    end
})
local isKillAllActive = false
local killAllCoroutine = nil
local KILL_HEALTH_THRESHOLD = 0.99
MiscTab:CreateToggle({
    Name = "Kill all(?)",
    CurrentValue = false,
    Callback = function(value)
        if isKillAllActive == value then
            return
        end
        isKillAllActive = value
        if isKillAllActive then
            sethiddenproperty(Players.LocalPlayer, "SimulationRadius", 1124)
            sethiddenproperty(Players.LocalPlayer, "MaxSimulationRadius", 1124)
            if killAllCoroutine and coroutine.status(killAllCoroutine) ~= "dead" then
                return
            end
            killAllCoroutine = coroutine.create(function()
                while isKillAllActive do
                    local liveFolder = Workspace:FindFirstChild("Live")
                    if liveFolder then
                        local playerChars = {}
                        for _, pl in ipairs(Players:GetPlayers()) do
                            if pl.Character then
                                playerChars[pl.Character] = true
                            end
                        end
                        for _, d in ipairs(liveFolder:GetDescendants()) do
                            if d.ClassName == "Humanoid" then
                                local model = d.Parent
                                if not playerChars[model] then
                                    local cur = d.Health
                                    local max = d.MaxHealth
                                    if type(cur) == "number" and type(max) == "number" and max > 0 then
                                        if cur / max <= KILL_HEALTH_THRESHOLD then
                                            d.Health = 0
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait()
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
local ftween = true
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
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
local function disableBodyControl(hrp)
    if bodyVelocity then pcall(function() bodyVelocity:Destroy() end) bodyVelocity = nil end
    if bodyGyro then pcall(function() bodyGyro:Destroy() end) bodyGyro = nil end
    if hrp then
        for _, inst in ipairs(hrp:GetChildren()) do
            if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
                pcall(function() inst:Destroy() end)
            end
        end
    end
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
                if d < nearestDist and d <= 900 then
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
    disableBodyControl(hrp)
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
                
                if diff.Magnitude > 200 then
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

local player = game:GetService("Players").LocalPlayer

local workspace = game:GetService("Workspace")

local function getController()
    local char = player.Character
    if not char then return nil end
    local controller = char:FindFirstChild("client_character_controller")
    return controller
end

local intervals = {
    M1 = 0.1, M2 = 0.1,
    E = 1, R = 1, Z = 1, C = 1, X = 1, V = 1,
}
local threads = {}

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
            task.wait(intervals[key])
        end
    end)
end

local function stopLoop(key)
    threads[key] = nil
end

local function fireSkill(key, ...)
    local args = {...}
    local char = player.Character
    if not char then return end
    local controller = char:WaitForChild("client_character_controller", 3)
    if not controller then warn("No controller for", key) return end
    local remote = controller:WaitForChild(key, 3)
    if not remote then warn("No remote:", key) return end
    remote:FireServer(table.unpack(args))
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

SkillTab:CreateToggle({ Name = "Auto M1", CurrentValue = false, Flag = "lesbian101", Callback = function(v)
    if v then startLoop("M1", function() fireSkill("M1", true, false) end)
    else stopLoop("M1") end
end })
SkillTab:CreateToggle({ Name = "Auto M2", CurrentValue = false, Flag = "lesbian102", Callback = function(v)
    if v then startLoop("M2", function() fireSkill("M2", true, false) end)
    else stopLoop("M2") end
end })
SkillTab:CreateToggle({ Name = "Auto Skill E", CurrentValue = false, Flag = "lesbian103", Callback = function(v)
    if v then startLoop("E", function() fireSkill("Skill", "E", true) end)
    else stopLoop("E") end
end })
SkillTab:CreateToggle({ Name = "Auto Skill R", CurrentValue = false, Flag = "lesbian104", Callback = function(v)
    if v then startLoop("R", function() fireSkill("Skill", "R", true) end)
    else stopLoop("R") end
end })
SkillTab:CreateToggle({ Name = "Auto Skill Z", CurrentValue = false, Flag = "lesbian105", Callback = function(v)
    if v then startLoop("Z", function() fireSkill("Skill", "Z", true) end)
    else stopLoop("Z") end
end })
SkillTab:CreateToggle({ Name = "Auto Skill C", CurrentValue = false, Flag = "lesbian106", Callback = function(v)
    if v then startLoop("C", function() fireSkill("Skill", "C", true) end)
    else stopLoop("C") end
end })
SkillTab:CreateToggle({ Name = "Auto Skill X", CurrentValue = false, Flag = "lesbian107", Callback = function(v)
    if v then startLoop("X", function() fireSkill("Skill", "X", true) end)
    else stopLoop("X") end
end })
SkillTab:CreateToggle({ Name = "Auto Skill V", CurrentValue = false, Flag = "lesbian108", Callback = function(v)
    if v then startLoop("V", function() fireSkill("Skill", "V", true) end)
    else stopLoop("V") end
end })
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local player     = Players.LocalPlayer
local humanoidESPEnabled = false
local HUMANOID_ESP_MAX   = 1000
local trackedHRPs = {}   
local espTags      = {}  
local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
player.CharacterAdded:Connect(function(char)
    playerHRP = char:WaitForChild("HumanoidRootPart")
end)
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj.Name == "HumanoidRootPart" and obj.Parent and obj.Parent:FindFirstChildOfClass("Humanoid") then
        trackedHRPs[obj] = true
    end
end
workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" and desc.Parent and desc.Parent:FindFirstChildOfClass("Humanoid") then
        trackedHRPs[desc] = true
    end
end)
workspace.DescendantRemoving:Connect(function(desc)
    if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" then
        if espTags[desc] then
            if espTags[desc].highlight and espTags[desc].highlight.Parent then espTags[desc].highlight:Destroy() end
            if espTags[desc].billboard and espTags[desc].billboard.Parent then espTags[desc].billboard:Destroy() end
            espTags[desc] = nil
        end
        trackedHRPs[desc] = nil
    end
end)
local function updateHumanoidESP(targetHRP)
    if not humanoidESPEnabled or not targetHRP or not targetHRP.Parent or not playerHRP then return end
    local model = targetHRP.Parent
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local dist = (playerHRP.Position - targetHRP.Position).Magnitude
    if dist > HUMANOID_ESP_MAX then
        local data = espTags[targetHRP]
        if data then
            if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
            if data.billboard and data.billboard.Parent then data.billboard:Destroy() end
            espTags[targetHRP] = nil
        end
        return
    end
    local data = espTags[targetHRP]
    if not data then
        local highlight = Instance.new("Highlight")
        highlight.Name           = "HumanoidESPHighlight"
        highlight.Adornee        = model
        highlight.FillColor      = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor     = Color3.fromRGB(255, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.DepthMode      = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent         = model
        local billboard = Instance.new("BillboardGui")
        billboard.Name        = "HumanoidESPLabel"
        billboard.Adornee     = targetHRP
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Size        = UDim2.new(0, 140, 0, 40)
        billboard.AlwaysOnTop = true
        billboard.Parent      = model
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size               = UDim2.new(1,0,0.5,0)
        nameLabel.Position           = UDim2.new(0,0,0,0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text               = model.Name
        nameLabel.TextColor3         = Color3.fromRGB(255,255,255)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextScaled         = true
        nameLabel.Font               = Enum.Font.Arial
        nameLabel.Parent             = billboard
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size               = UDim2.new(1,0,0.5,0)
        infoLabel.Position           = UDim2.new(0,0,0.5,0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3         = Color3.fromRGB(200,200,200)
        infoLabel.TextStrokeTransparency = 0.7
        infoLabel.TextScaled         = true
        infoLabel.Font               = Enum.Font.Arial
        infoLabel.Parent             = billboard
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
local heartbeatConn
local function onHeartbeat()
    for hrp in pairs(trackedHRPs) do
        local ok, err = pcall(function() updateHumanoidESP(hrp) end)
        if not ok then
            if espTags[hrp] then
                if espTags[hrp].highlight and espTags[hrp].highlight.Parent then espTags[hrp].highlight:Destroy() end
                if espTags[hrp].billboard and espTags[hrp].billboard.Parent then espTags[hrp].billboard:Destroy() end
                espTags[hrp] = nil
            end
            trackedHRPs[hrp] = nil
        end
    end
end
local function enableHumanoidESP()
    if not heartbeatConn then
        heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
    end
end
local function disableHumanoidESP()
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    for hrp, data in pairs(espTags) do
        if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
        if data.billboard and data.billboard.Parent then data.billboard:Destroy() end
        espTags[hrp] = nil
    end
    trackedHRPs = {}
end
ManTab:CreateToggle({
    Name         = "HumanoidRootPart ESP",
    CurrentValue = humanoidESPEnabled,
    Flag         = "HumanoidRootESPEnabled",
    Callback     = function(enabled)
        humanoidESPEnabled = enabled
        if humanoidESPEnabled then
            enableHumanoidESP()
        else
            disableHumanoidESP()
        end
    end,
})
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
            if msg:match(pattern) then
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
                waitForNotification("Earned") 
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