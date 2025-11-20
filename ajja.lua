wait(5)
wait(5)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local PLACE_ID = 127886236032517
local TARGET_GAME_ID = 127886236032517

local teleported = false

local function tryTeleport()
	if teleported then return end
	teleported = true

	pcall(function()
		local playersCount = #Players:GetPlayers()

		if playersCount > 1 then
			pcall(function()
				TeleportService:Teleport(127886236032517, Players.LocalPlayer)
			end)
			return
		end

		if game.PlaceId == TARGET_GAME_ID then
			local jobId = game.JobId

			if playersCount <= 1 then
				Players.LocalPlayer:Kick("\nRejoining...")
				task.wait(0.5)
				TeleportService:Teleport(127886236032517, Players.LocalPlayer)
			else
				TeleportService:TeleportToPlaceInstance(127886236032517, jobId, Players.LocalPlayer)
			end
		else
			TeleportService:Teleport(PLACE_ID, Players.LocalPlayer)
		end
	end)
end

if #Players:GetPlayers() > 1 then
	tryTeleport()
end

Players.PlayerAdded:Connect(function()
	if #Players:GetPlayers() > 1 then
		tryTeleport()
	end
end)

local function onCharacter(char)
	local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.Died:Connect(tryTeleport)
	end
end

if LocalPlayer.Character then
	onCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacter)

task.spawn(function()
	while not teleported do
		local bossInterface = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("bossInterface")
		local healthFrame = bossInterface and bossInterface:FindFirstChild("HealthFrame")
		local healthLabel = healthFrame and healthFrame:FindFirstChild("HealthLabel")

		if healthLabel and healthLabel.Text then
			local number = tonumber((healthLabel.Text:gsub("%%", "")))
			if number and number <= 0 then
				task.wait(10)
				tryTeleport()
			end
		end

		task.wait(0.2)
	end
end)
if game.PlaceId == 127886236032517 then
    do
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local function efficientAutoCollect()
            local candyContainer = Workspace:FindFirstChild("CandyContainer")
            if not candyContainer then
                return
            end
            if not firetouchinterest then
                return
            end
            local collectedCandy = {}
            local function collectCandy(part)
                if collectedCandy[part] then return end 
                local touchTransmitter = part:FindFirstChildOfClass("TouchTransmitter") or part:FindFirstChild("TouchInterest")
                if touchTransmitter then
                    local player = Players.LocalPlayer
                    if not player then return end
                    local character = player.Character
                    if not character then
                        character = player.CharacterAdded:Wait()
                    end
                    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
                    if not rootPart then return end
                    firetouchinterest(rootPart, part, 1)
                    task.wait(0.1)
                    firetouchinterest(rootPart, part, 0)
                    task.wait(0.1)
                    collectedCandy[part] = true
                end
            end
            for _, child in ipairs(candyContainer:GetChildren()) do
                if child:IsA("Part") or child:IsA("MeshPart") then
                    collectCandy(child)
                end
                for _, desc in ipairs(child:GetDescendants()) do
                    if desc:IsA("Part") or desc:IsA("MeshPart") then
                        collectCandy(desc)
                    end
                end
            end
            candyContainer.ChildAdded:Connect(function(child)
                task.wait(0.5)
                if child:IsA("Part") or child:IsA("MeshPart") then
                    collectCandy(child)
                end
            end)
            candyContainer.DescendantAdded:Connect(function(desc)
                if desc:IsA("Part") or desc:IsA("MeshPart") then
                    task.wait(0.5)
                    collectCandy(desc)
                end
            end)
        end
        task.wait(0.1)
        efficientAutoCollect()
        task.wait(0.1)
    end
    do
 local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local function getBossButton()
    local pg = localPlayer and localPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local boss = pg:FindFirstChild("bossInterface")
    if not boss then return nil end
    return boss:FindFirstChild("TextButton")
end
local yOffsetDp = 35
local function clickGuiButton(button)
    if not button or not button:IsA("GuiButton") then return false end
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(360, 640)
    local dpScale = (viewport.X ~= 0) and (viewport.X / 360) or 1
    local yOffsetPx = math.floor(yOffsetDp * dpScale + 0.5)
    local x = math.floor(button.AbsolutePosition.X + button.AbsoluteSize.X/2)
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
local initialDelay = math.random(60 ,110)
local spamInterval  = 1
task.spawn(function()
    task.wait(initialDelay)
    while true do
        local button = getBossButton()
        if button and button.Visible then
            clickGuiButton(button)
        end
        task.wait(spamInterval)
    end
end)
end
    do
        local RunService = game:GetService("RunService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local BOSS_PATH = "HalloweenBoss"
        local STOP_SECONDS = 2.9
        local TOLERANCE = 0.1
        local FIRE_EVERY_TIME = true
        local boss = workspace:WaitForChild(BOSS_PATH, 10)
        local rollEvent = ReplicatedStorage:WaitForChild("RollEvent", 10)
        if not boss then
            return
        end
        if not rollEvent then
            return
        end
        local function getBossPosition()
            if typeof(boss) == "Instance" then
                if boss:IsA("Model") then
                    if boss.PrimaryPart then
                        return boss.PrimaryPart.Position
                    end
                    local fallbackNames = {"HumanoidRootPart", "HumanoidRoot", "Torso", "UpperTorso", "LowerTorso"}
                    for _, name in ipairs(fallbackNames) do
                        local p = boss:FindFirstChild(name)
                        if p and p:IsA("BasePart") then
                            return p.Position
                        end
                    end
                    if boss.GetModelCFrame then
                        local ok, c = pcall(function() return boss:GetModelCFrame() end)
                        if ok and c then
                            return c.Position or c.p
                        end
                    end
                elseif boss:IsA("BasePart") then
                    return boss.Position
                end
            end
            return nil
        end
        local lastPos = getBossPosition() or Vector3.new(0, 0, 0)
        local stillTimer = 0
        local fired = false
        RunService.Heartbeat:Connect(function(dt)
            if not boss or not boss.Parent then
                local found = workspace:FindFirstChild(BOSS_PATH)
                if found then
                    boss = found
                    lastPos = getBossPosition() or lastPos
                    stillTimer = 0
                    fired = false
                else
                    return
                end
            end
            local pos = getBossPosition()
            if not pos then
                return
            end
            if (pos - lastPos).Magnitude <= TOLERANCE then
                stillTimer = stillTimer + dt
                if stillTimer >= STOP_SECONDS and (not fired or FIRE_EVERY_TIME) then
                    local success = pcall(function()
                        rollEvent:FireServer()
                    end)
                    if success then
                        fired = true
                    end
                end
            else
                stillTimer = 0
                lastPos = pos
                fired = false
            end
        end)
    end
    do
        local TweenService = game:GetService("TweenService")
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local localPlayer = Players.LocalPlayer
        local circleCenter = Vector3.new(29, 150, 364)
        local circleRadius = 20
        local circleSpeed = 3
        local currentAngle = 0
        local isDoingCircleTween = false
        local function getRoot(character)
            return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        end
        local function calculateCirclePosition(angle)
            local x = circleCenter.X + circleRadius * math.cos(angle)
            local z = circleCenter.Z + circleRadius * math.sin(angle)
            return Vector3.new(x, circleCenter.Y, z)
        end
        local function startCircleTween()
            if isDoingCircleTween then return end
            local character = localPlayer.Character
            if not character then return end
            local root = getRoot(character)
            if not root then return end
            isDoingCircleTween = true
            local function updateCircle()
                if not isDoingCircleTween or not character or not root then 
                    isDoingCircleTween = false
                    return 
                end
                currentAngle = currentAngle + (2 * math.pi) / (circleSpeed * 60) 
                if currentAngle >= 2 * math.pi then
                    currentAngle = 0
                end
                local targetPosition = calculateCirclePosition(currentAngle)
                local tweenInfo = TweenInfo.new(1/60, Enum.EasingStyle.Linear) 
                local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                tween:Play()
            end
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if not isDoingCircleTween then
                    connection:Disconnect()
                    return
                end
                local char = localPlayer.Character
                if not char or not getRoot(char) then
                    isDoingCircleTween = false
                    connection:Disconnect()
                    return
                end
                updateCircle()
            end)
        end
        local function stopCircleTween()
            isDoingCircleTween = false
        end
        localPlayer.CharacterAdded:Connect(function(character)
            character:WaitForChild("HumanoidRootPart")
            wait(0.5)
            startCircleTween()
        end)
        if localPlayer.Character and getRoot(localPlayer.Character) then
            startCircleTween()
        end
    end
end