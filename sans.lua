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
local ADTab = Window:CreateTab("Delete", 4483345998)
local ExTab = Window:CreateTab("Extra", 4483345998)
local PTab = Window:CreateTab("Prompt", 4483345998)
local ConfigTab = Window:CreateTab("Configuration", 4483345998)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
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
                    
                    local playerCharacter = player.Character
                    if not playerCharacter then return end
                    
                    local playerRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")
                    if not playerRootPart then return end

                    for _, child in ipairs(workspace:GetChildren()) do
                        if child:IsA("Model") and child:FindFirstChild("Handle") then
                            local handle = child.Handle
                            if handle:IsA("BasePart") and handle:FindFirstChild("TouchInterest") then
                                handle.CFrame = playerRootPart.CFrame
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
local isNoCollisionActive = false
local noCollisionConnection = nil
ManTab:CreateToggle({
    Name = "No Collision",
    CurrentValue = false,
    Flag = "lesbian1",
    Callback = function(value)
        isNoCollisionActive = value
        if isNoCollisionActive then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA('BasePart') or obj:IsA('Part') then
                    obj.CanTouch = false
                end
            end
            noCollisionConnection = workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA('BasePart') or obj:IsA('Part') then
                    obj.CanTouch = false
                end
            end)
        else
            if noCollisionConnection then
                noCollisionConnection:Disconnect()
                noCollisionConnection = nil
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA('BasePart') or obj:IsA('Part') then
                    obj.CanTouch = true
                end
            end
        end
    end
})
local player = game:GetService("Players").LocalPlayer
local TOOL_NAME = "Ilia Topuria Gloves"
local REMOTE_EVENT_NAME = "RemoteEvent"
local isAutoFireActive = false
local autoFireConnections = {}
local autoFireCoroutines = {}
local function monitorTool(tool)
    if not tool or not isAutoFireActive then return end
    local remote = tool:FindFirstChild(REMOTE_EVENT_NAME)
    if not remote then
        remote = tool:WaitForChild(REMOTE_EVENT_NAME, 2)
    end
    if remote then
        while isAutoFireActive and tool and tool.Parent and player.Character and player.Character.Parent do
            pcall(function()
                remote:FireServer()
            end)
            task.wait(0.1)
        end
    end
end
local function setupAutoFire()
    for _, conn in ipairs(autoFireConnections) do
        conn:Disconnect()
    end
    autoFireConnections = {}
    for _, co in ipairs(autoFireCoroutines) do
        if coroutine.status(co) ~= "dead" then
            coroutine.close(co)
        end
    end
    autoFireCoroutines = {}
    if player.Character then
        local tool = player.Character:FindFirstChild(TOOL_NAME)
        if tool then
            local co = coroutine.create(monitorTool)
            table.insert(autoFireCoroutines, co)
            coroutine.resume(co, tool)
        end
        local charAddedConn = player.Character.ChildAdded:Connect(function(child)
            if child.Name == TOOL_NAME and isAutoFireActive then
                local co = coroutine.create(monitorTool)
                table.insert(autoFireCoroutines, co)
                coroutine.resume(co, child)
            end
        end)
        table.insert(autoFireConnections, charAddedConn)
    end
    local characterAddedConn = player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid", 5)
        local tool = character:WaitForChild(TOOL_NAME, 5)
        if tool and isAutoFireActive then
            local co = coroutine.create(monitorTool)
            table.insert(autoFireCoroutines, co)
            coroutine.resume(co, tool)
        end
        local childAddedConn = character.ChildAdded:Connect(function(child)
            if child.Name == TOOL_NAME and isAutoFireActive then
                local co = coroutine.create(monitorTool)
                table.insert(autoFireCoroutines, co)
                coroutine.resume(co, child)
            end
        end)
        table.insert(autoFireConnections, childAddedConn)
    end)
    table.insert(autoFireConnections, characterAddedConn)
end
ManTab:CreateToggle({
    Name = "Auto Fire Gloves",
    CurrentValue = false,
    Flag = "lesbian2",
    Callback = function(value)
        isAutoFireActive = value
        if isAutoFireActive then
            setupAutoFire()
        else
            for _, conn in ipairs(autoFireConnections) do
                conn:Disconnect()
            end
            autoFireConnections = {}
            for _, co in ipairs(autoFireCoroutines) do
                if coroutine.status(co) ~= "dead" then
                    coroutine.close(co)
                end
            end
            autoFireCoroutines = {}
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
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MAX_DISTANCE = 2000
local FIRE_ITER = 5
local FIRE_WAIT = 0.03
local UNDER_MAP_OFFSET = 11 
local function getCharacter()
    return LocalPlayer and LocalPlayer.Character
end
local function getRoot()
    local char = getCharacter()
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
end
local _bv, _bg, _noclipConn, _bodyActive = nil, nil, nil, false
local Clip = false
local floatName = nil 
local function startBodyControl()
    if _bodyActive then return end
    local root = getRoot()
    if not root then return end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "_collectBV"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = root
    _bv = bv
    local bg = Instance.new("BodyGyro")
    bg.Name = "_collectBG"
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 1000
    bg.CFrame = root.CFrame
    bg.Parent = root
    _bg = bg
    _noclipConn = RunService.Stepped:Connect(function()
        if Clip == false and getCharacter() then
            for _, child in ipairs(getCharacter():GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
                    child.CanCollide = false
                end
            end
        end
    end)
    _bodyActive = true
end
local function stopBodyControl()
    if not _bodyActive then return end
    if _noclipConn then
        _noclipConn:Disconnect()
        _noclipConn = nil
    end
    local char = getCharacter()
    if char then
        for _, child in ipairs(char:GetDescendants()) do
            if child:IsA("BasePart") and child.Name ~= floatName then
                child.CanCollide = true
            end
        end
    end
    if _bv then
        _bv:Destroy()
        _bv = nil
    end
    if _bg then
        _bg:Destroy()
        _bg = nil
    end
    _bodyActive = false
end
local isCollectingItems = false
local collectingItemsCoroutine
local itemsToCollect = {
    "Workspace.Egg",
    "Workspace.Chest",
}
local folderToCollectAll = "Workspace.Maps.ItemsFolder"
local function findByPath(path)
    local current = game
    for _, part in ipairs(path:split(".")) do
        if string.lower(part) == "workspace" then
            current = workspace
        elseif string.lower(part) == "players" then
            current = game:GetService("Players")
        else
            current = current:FindFirstChild(part)
        end
        if not current then return nil end
    end
    return current
end
local function findPrompt(inst)
    for _, d in ipairs(inst:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            return d
        end
    end
    return nil
end
local function findTargetPart(item)
    if item:IsA("BasePart") then
        return item
    end
    if item:IsA("Model") then
        if item.PrimaryPart and item.PrimaryPart:IsA("BasePart") then
            return item.PrimaryPart
        end
        for _, d in ipairs(item:GetDescendants()) do
            if d:IsA("BasePart") then
                return d
            end
        end
    end
    return nil
end
local function collectItem(item, isCollectingFlag)
    local hrp = getRoot()
    if not hrp then return false end
    local part = findTargetPart(item)
    if not part then return false end
    if (hrp.Position - part.Position).Magnitude > MAX_DISTANCE then
        return false
    end
    local prompt = findPrompt(item)
    if not prompt then return false end
    hrp.CFrame = part.CFrame * CFrame.new(0, -UNDER_MAP_OFFSET, 0)
    for i = 1, FIRE_ITER do
        if not isCollectingFlag() then break end
        if not prompt.Parent then break end
        fireproximityprompt(prompt)
        task.wait(FIRE_WAIT)
    end
    return true
end
ManTab:CreateToggle({
    Name = "Collect Items",
    CurrentValue = false,
    Callback = function(state)
        isCollectingItems = state
        if isCollectingItems then
            startBodyControl()
            collectingItemsCoroutine = coroutine.create(function()
                while isCollectingItems do
                    for _, path in ipairs(itemsToCollect) do
                        if not isCollectingItems then break end
                        local item = findByPath(path)
                        if item then
                            collectItem(item, function() return isCollectingItems end)
                        end
                    end
                    local folder = findByPath(folderToCollectAll)
                    if folder then
                        for _, child in ipairs(folder:GetChildren()) do
                            if not isCollectingItems then break end
                            collectItem(child, function() return isCollectingItems end)
                        end
                    end
                    task.wait(0.1)
                end
            end)
            coroutine.resume(collectingItemsCoroutine)
        else
            isCollectingItems = false
            if collectingItemsCoroutine then
                if coroutine.close then
                    coroutine.close(collectingItemsCoroutine)
                end
                collectingItemsCoroutine = nil
            end
            stopBodyControl()
        end
    end
})
local isCollecting = false
local collectingCoroutine
local MAX_DISTANCE = 2000
local FIRE_ITER = 5
local FIRE_WAIT = 0.03
ManTab:CreateToggle({
    Name = "Collect Chests",
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
                    local chestFolder = workspace:FindFirstChild("chests")
                    local nearestEntry = nil
                    local nearestDist = math.huge
                    if chestFolder then
                        for _, chest in ipairs(chestFolder:GetChildren()) do
                            local primaryPart = chest:FindFirstChild("Handle") or chest
                            if primaryPart and primaryPart:IsA("BasePart") then
                                local dist = (origin - primaryPart.Position).Magnitude
                                if dist <= MAX_DISTANCE then
                                    local prompt = primaryPart:FindFirstChild("ProximityPrompt") or chest:FindFirstChild("ProximityPrompt")
                                    if prompt and dist < nearestDist then
                                        nearestDist = dist
                                        nearestEntry = {
                                            chest = chest,
                                            primaryPart = primaryPart,
                                            prompt = prompt
                                        }
                                    end
                                end
                            end
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
ExTab:CreateToggle({
	Name = "Toggle Anti Memory Leak",
	CurrentValue = false,
	Flag = "AntiMemoryToggle",
	Callback = function(Value)
		taml(Value)
	end
})
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
ExTab:CreateButton({
    Name = "Hitboxes",
    Callback = function()
        if localPlayer then
            sethiddenproperty(localPlayer, "SimulationRadius", 1124)
            sethiddenproperty(localPlayer, "MaxSimulationRadius", 1124)
        end
        
        local function isPlayerCharacterModel(model)
            if not model then return false end
            for _, pl in pairs(Players:GetPlayers()) do
                if pl.Character and pl.Character == model then
                    return true
                end
            end
            return false
        end
        
        local EXPAND_SIZE = Vector3.new(60, 60, 60)
        local expandedCount = 0
        
        for _, desc in pairs(workspace:GetDescendants()) do
            if desc.ClassName == "Humanoid" then
                local model = desc.Parent
                if model and not isPlayerCharacterModel(model) then
                    local rootPart = model:FindFirstChild("HumanoidRootPart")
                    local head = model:FindFirstChild("Head")
                    if rootPart then
                        desc.JumpPower = 0
                        desc.WalkSpeed = 0
                        rootPart.Size = EXPAND_SIZE
                        rootPart.Transparency = 1
                        rootPart.CanCollide = false
                        if head then
                            head.CanCollide = false
                        end
                        if desc:FindFirstChild("Animator") then
                            desc.Animator:Destroy()
                        end
                        desc:ChangeState(11)
                        desc:ChangeState(14)
                        expandedCount = expandedCount + 1
                    end
                end
            end
        end
        if localPlayer then
            sethiddenproperty(localPlayer, "SimulationRadius", math.huge)
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local FOLLOW_DISTANCE = 0.1
local FOLLOW_SPEED = 1000
local scanInterval = 0.25
local clickInterval = 0.0001
_G.isAutoTweenActive = _G.isAutoTweenActive or false
local connection = nil
local currentTarget = nil
local lastScan = 0
local lastClick = 0
local function findTarget()
    if not player or not player.Character then 
        return nil, math.huge 
    end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local myPos = hrp and hrp.Position or Vector3.new(0,0,0)
    local highestRarity = -math.huge
    local bestEntity = nil
    local nearestDist = math.huge
    local searchCollection = workspace:FindFirstChild("Entities") or workspace
    for _, entity in ipairs(searchCollection:GetChildren()) do
        local rarityValue = entity:FindFirstChild("Rarity")
        if rarityValue then
            local rarity = rarityValue.Value
            local entityHRP = entity:FindFirstChild("HumanoidRootPart")
            local humanoid = entity:FindFirstChildWhichIsA("Humanoid")
            if entityHRP and humanoid and humanoid.Health < humanoid.MaxHealth then
                local d = (entityHRP.Position - myPos).Magnitude
                if rarity > highestRarity then
                    highestRarity = rarity
                    bestEntity = entityHRP
                    nearestDist = d
                elseif rarity == highestRarity and d < nearestDist then
                    bestEntity = entityHRP
                    nearestDist = d
                end
            end
        end
    end
    return bestEntity, nearestDist
end
local function getPos(targetHRP)
    local base = targetHRP.CFrame
    local forward = base.LookVector * -FOLLOW_DISTANCE
    local frontPos = targetHRP.Position + forward
    return CFrame.new(frontPos, targetHRP.Position)
end
local function click(targetModel)
    if not targetModel then return end
    local clickDetector = targetModel:FindFirstChild("ClickDetector")
    if not clickDetector then
        for _, descendant in ipairs(targetModel:GetDescendants()) do
            if descendant:IsA("ClickDetector") then
                clickDetector = descendant
                break
            end
        end
    end
    if clickDetector then
        fireclickdetector(clickDetector)
        return true
    end
    return false
end
ExTab:CreateToggle({
    Name = "Auto Tween",
    CurrentValue = false,
    Flag = "lesbian3",
    Callback = function(value)
        _G.isAutoTweenActive = value
        if connection then
            connection:Disconnect()
            connection = nil
        end
        currentTarget = nil
        if _G.isAutoTweenActive then
            connection = RunService.Heartbeat:Connect(function(dt)
                if not player or not player.Character or not _G.isAutoTweenActive then
                    return
                end
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                lastScan = lastScan + dt
                lastClick = lastClick + dt
                local needScan = (not currentTarget) or 
                               (not currentTarget.Parent) or 
                               (not currentTarget.Parent:FindFirstChildWhichIsA("Humanoid"))
                if currentTarget and currentTarget.Parent then
                    local hum = currentTarget.Parent:FindFirstChildWhichIsA("Humanoid")
                    if hum and hum.Health >= hum.MaxHealth then
                        needScan = true
                        currentTarget = nil
                    end
                end
                if needScan and lastScan >= scanInterval then
                    lastScan = 0
                    currentTarget = findTarget()
                end
                if currentTarget and currentTarget.Parent then
                    local hum = currentTarget.Parent:FindFirstChildWhichIsA("Humanoid")
                    if not hum or hum.Health >= hum.MaxHealth then
                        currentTarget = nil
                        return
                    end
                    if not currentTarget:IsDescendantOf(workspace) then
                        currentTarget = nil
                        return
                    end
                    local desired = getPos(currentTarget)
                    local alpha = math.clamp(dt * FOLLOW_SPEED, 0, 1)
                    hrp.CFrame = hrp.CFrame:Lerp(desired, alpha)
                    local distance = (currentTarget.Position - hrp.Position).Magnitude
                    if distance <= 15 and lastClick >= clickInterval then
                        lastClick = 0
                        click(currentTarget.Parent)
                    end
                end
            end)
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

                for _, prompt in ipairs(workspace.MapLayer2:GetDescendants()) do
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
local places = {}
local placeids = {}
local function loadPlaces()
    places = {}
    placeids = {}
    pcall(function()
        local AssetService = game:GetService("AssetService")
        local pp = AssetService:GetGamePlacesAsync()
        while true do
            for _, place in pp:GetCurrentPage() do
                table.insert(places, place.Name)
                table.insert(placeids, place.PlaceId)
            end
            if pp.IsFinished then
                break
            end
            pp:AdvanceToNextPageAsync()
        end
    end)
    return places, placeids
end
local subplaceDropdown = ManTab:CreateDropdown({
   Name = "Subplace/Hidden Games",
   Options = loadPlaces(), 
   CurrentOption = "",
   MultipleOptions = false,
   Callback = function(SelectedOption)
      local Selected = type(SelectedOption) == "table" and SelectedOption[1] or SelectedOption
      local index = table.find(places, Selected)
      if index and placeids[index] then
          local placeId = placeids[index]
          local TeleportService = game:GetService("TeleportService")
          local Players = game:GetService("Players")
          TeleportService:Teleport(placeId, Players.LocalPlayer)
      else
          warn("Could not find place or placeId for selection:", Selected)
      end
   end
})
local ESPEnabled = false
local activeHighlights = {}

local function createESP(item)
    if not ESPEnabled then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ItemESPHighlight"
    highlight.Adornee = item
    highlight.Parent = item
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemESPLabel"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = item
    billboard.Parent = item
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = item.Name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.Parent = billboard
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local fadeTween = TweenService:Create(
        label,
        tweenInfo,
        {TextTransparency = 1}
    )
    
    task.delay(15, function()
        fadeTween:Play()
        task.wait(1)
        highlight:Destroy()
        billboard:Destroy()
    end)
end
local ESPItemsList = {
    { Name = "PresentBox", Parent = workspace },
    { Name = "InvTarget", Parent = workspace },
    { Name = "Library", Parent = workspace }
}
ManTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(value)
        ESPEnabled = value
        if not value then
            for _, item in pairs(activeHighlights) do
                item:Destroy()
            end
            activeHighlights = {}
        end
    end,
})

spawn(function()
    while true do
        if ESPEnabled then
            for _, entity in pairs(ESPItemsList) do
                for _, item in pairs(entity.Parent:GetChildren()) do
                    if item.Name == entity.Name and not activeHighlights[item] then
                        createESP(item)
                        activeHighlights[item] = true
                    end
                end
            end
        end
        task.wait(2)
    end
end)

Workspace.ChildAdded:Connect(function(child)
    if ESPEnabled then
        for _, entity in pairs(ESPItemsList) do
            if child.Name == entity.Name and child.Parent == entity.Parent then
                createESP(child)
                activeHighlights[child] = true
            end
        end
    end
end)
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

local espEnabled       = false
local ESP_DISTANCE_MAX = 500


local trackedPrompts = {}  
local espTags        = {}  


local function getDistance(posA, posB)
    return (posA - posB).Magnitude
end


for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        trackedPrompts[obj] = true
    end
end


workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("ProximityPrompt") then
        trackedPrompts[desc] = true
    end
end)
workspace.DescendantRemoving:Connect(function(desc)
    if desc:IsA("ProximityPrompt") then
        
        if espTags[desc] then
            espTags[desc].highlight:Destroy()
            espTags[desc].billboard:Destroy()
            espTags[desc] = nil
        end
        trackedPrompts[desc] = nil
    end
end)


local function updatePromptESP(prompt)
    if not espEnabled or not prompt.Parent or not hrp then return end

    
    local part = prompt.Parent
    local pos
    if part:IsA("BasePart") then
        pos = part.Position
    elseif part:IsA("Model") and part.PrimaryPart then
        pos = part.PrimaryPart.Position
    else
        return
    end

    local dist = getDistance(hrp.Position, pos)
    if dist > ESP_DISTANCE_MAX then
        
        local data = espTags[prompt]
        if data then
            data.highlight:Destroy()
            data.billboard:Destroy()
            espTags[prompt] = nil
        end
        return
    end

    
    local data = espTags[prompt]
    if not data then
        
        local highlight = Instance.new("Highlight")
        highlight.Name           = "ProximityESPHighlight"
        highlight.Adornee        = part
        highlight.FillColor      = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor     = Color3.fromRGB(255, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.DepthMode      = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent         = part

        
        local billboard = Instance.new("BillboardGui")
        billboard.Name        = "ProximityESPLabel"
        billboard.Adornee     = part
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Size        = UDim2.new(0, 120, 0, 40)
        billboard.AlwaysOnTop= true
        billboard.Parent      = part

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size               = UDim2.new(1,0,0.5,0)
        nameLabel.Position           = UDim2.new(0,0,0,0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text               = part.Name
        nameLabel.TextColor3         = Color3.fromRGB(255,255,255)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextScaled         = true
        nameLabel.Font               = Enum.Font.Arial
        nameLabel.Parent             = billboard

        local distLabel = Instance.new("TextLabel")
        distLabel.Size               = UDim2.new(1,0,0.5,0)
        distLabel.Position           = UDim2.new(0,0,0.5,0)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3         = Color3.fromRGB(200,200,200)
        distLabel.TextStrokeTransparency = 0.7
        distLabel.TextScaled         = true
        distLabel.Font               = Enum.Font.Arial
        distLabel.Parent             = billboard

        data = {
            highlight = highlight,
            billboard = billboard,
            nameLabel = nameLabel,
            distLabel = distLabel,
        }
        espTags[prompt] = data
    end

    
    data.distLabel.Text = string.format("%.0f studs", dist)
end


local heartbeatConn
local function onHeartbeat()
    for prompt in pairs(trackedPrompts) do
        updatePromptESP(prompt)
    end
end


local function enableESP()
    if not heartbeatConn then
        heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
    end
end

local function disableESP()
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    
    for prompt, data in pairs(espTags) do
        data.highlight:Destroy()
        data.billboard:Destroy()
        espTags[prompt] = nil
    end
end
ManTab:CreateToggle({
    Name         = "Proximity ESP",
    CurrentValue = espEnabled,
    Flag         = "ProximityESPEnabled",
    Callback     = function(enabled)
        espEnabled = enabled
        if espEnabled then
            enableESP()
        else
            disableESP()
        end
    end,
})
ManTab:CreateInput({
    Name = "Player Speed",
    PlaceholderText = "Enter speed value",
    RemoveTextAfterFocusLost = false,
    CurrentValue = 1,
    Callback = function(Value)
        local number = tonumber(Value)
        if number and number > 0 then
            Humanoid = getHumanoid()
            if Humanoid then
                Humanoid.WalkSpeed = number
                Rayfield:Notify({
                    Title = "Speed Changed",
                    Content = "Player speed set to: " .. tostring(number),
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Humanoid not found!",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "Invalid Input",
                Content = "Please enter a positive number!",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

ManTab:CreateInput({
    Name = "Player JumpPower",
    PlaceholderText = "Enter jump power value",
    RemoveTextAfterFocusLost = false,
    CurrentValue = 1,
    Callback = function(Value)
        local number = tonumber(Value)
        if number and number > 0 then
            Humanoid = getHumanoid()
            if Humanoid then
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = number
                Rayfield:Notify({
                    Title = "JumpPower Changed",
                    Content = "Player jump power set to: " .. tostring(number),
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Humanoid not found!",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "Invalid Input",
                Content = "Please enter a positive number!",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
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
                        print("[DEBUG] Closed empty inventory notification")
                    end
                }}
            })
        end

        print(string.format("[DEBUG] Scan completed in %.2f seconds", os.clock() - startTime))
    end
})


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local LocalPlayer       = Players.LocalPlayer
local autodels    = {}       
local knownItems  = {}       
local toggleRefs  = {}       
local ListLabel   = ADTab:CreateLabel("Auto-Delete List: None")
local function UpdateListDisplay()
    local items = {}
    for itemName, isOn in pairs(autodels) do
        if isOn then
            table.insert(items, itemName)
        end
    end
    ListLabel:Set("Auto-Delete List: " .. (#items>0 and table.concat(items, ", ") or "None"))
end



function CreateAutoDeleteToggle(itemName)
    
    if not knownItems[itemName] then
        knownItems[itemName] = true
        autodels[itemName] = autodels[itemName] or false

        
        toggleRefs[itemName] = ADTab:CreateToggle({
            Name = itemName,
            CurrentValue = autodels[itemName],
            Flag = "AutoDel_" .. itemName,    
            Callback = function(val)
                autodels[itemName] = val
                UpdateListDisplay()
            end,
        })

        
        UpdateListDisplay()
    end

    return toggleRefs[itemName]
end
ADTab:CreateInput({
    Name = "Custom Item Name",
    PlaceholderText = "Enter item name…",
    RemoveTextAfterFocusLost = true,
    Callback = function(txt)
        if txt ~= "" then
            CreateAutoDeleteToggle(txt)
        end
    end,
})


ADTab:CreateButton({
    Name = "Add All Items in Inventory",
    Callback = function()
        if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
        for _, containerName in ipairs({"Backpack","Character","StarterGear"}) do
            local c = LocalPlayer:FindFirstChild(containerName)
            if c then
                for _, item in ipairs(c:GetChildren()) do
                    CreateAutoDeleteToggle(item.Name)
                end
            end
        end
        Rayfield:Notify({Title="Auto-Delete",Content="Inventory items added!",Duration=2})
    end,
})


local autoRunning = false
ADTab:CreateToggle({
    Name = "Enable Auto-Delete",
    CurrentValue = false,
    Flag = "AutoDel_Enable",
    Callback = function(val)
        autoRunning = val
        if val then
            coroutine.wrap(function()
                while autoRunning do
                    if LocalPlayer and LocalPlayer.Backpack then
                        for _, itm in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            if autodels[itm.Name] then itm:Destroy() end
                        end
                    end
                    if LocalPlayer and LocalPlayer.Character then
                        for _, itm in ipairs(LocalPlayer.Character:GetChildren()) do
                            if autodels[itm.Name] then itm:Destroy() end
                        end
                    end
                    task.wait(0.5)
                end
            end)()
        end
    end,
})


ADTab:CreateButton({
    Name = "Clear List",
    Callback = function()
        for itemName, _ in pairs(autodels) do
            autodels[itemName] = false
            toggleRefs[itemName]:Set(false)
        end
        UpdateListDisplay()
        Rayfield:Notify({Title="Auto-Delete",Content="List cleared.",Duration=2})
    end,
})


ADTab:CreateButton({
    Name = "Force Delete",
    Callback = function()
        local count = 0
        for _, container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
            if container then
                for _, itm in ipairs(container:GetChildren()) do
                    if autodels[itm.Name] then
                        itm:Destroy()
                        count += 1
                    end
                end
            end
        end
        Rayfield:Notify({
            Title="Auto-Delete",
            Content = count.." items deleted!",
            Duration = 2
        })
    end,
})


CreateAutoDeleteToggle("Oil Cup")
autodels["Oil Cup"] = true
UpdateListDisplay()
local configFolder = "AutoDeleteConfigs"
if not isfolder(configFolder) then makefolder(configFolder) end
local function getConfigList()
    local out = {}
    for _, path in ipairs(listfiles(configFolder)) do
        if path:sub(-4):lower() == ".txt" then
            local name = path:match("([^/\\]+)%.txt$")
            if name then table.insert(out, name) end
        end
    end
    return out
end


local currentSaveName = ""
ConfigTab:CreateInput({
    Name = "Save As…",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Flag = "Cfg_SaveName",
    Callback = function(txt)
        currentSaveName = txt
    end,
})


local savedConfigs = getConfigList()
local selectedConfig = savedConfigs[1] or ""
local cfgDropdown = ConfigTab:CreateDropdown({
    Name = "Load Config",
    Options = savedConfigs,
    CurrentOption = selectedConfig ~= "" and {selectedConfig} or {},
    MultipleOptions = false,
    Flag = "Cfg_Dropdown",
    Callback = function(opt)
        if type(opt)=="table" then selectedConfig = opt[1]
        else selectedConfig = opt end
    end,
})


ConfigTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        if currentSaveName == "" then
            Rayfield:Notify({Title="Error",Content="Enter a name first!",Duration=3})
            return
        end
        
        local list = {}
        for itemName, on in pairs(autodels) do
            if on then table.insert(list, itemName) end
        end
        
        local ok, data = pcall(function()
            return HttpService:JSONEncode(list)
        end)
        if not ok then
            Rayfield:Notify({Title="Error",Content="Failed to encode data.",Duration=3})
            return
        end
        writefile(configFolder.."/"..currentSaveName..".txt", data)
        Rayfield:Notify({Title="Saved",Content=currentSaveName,Duration=2})
        
        local newList = getConfigList()
        cfgDropdown:Refresh(newList)
        cfgDropdown:Set({currentSaveName})
        selectedConfig = currentSaveName
    end,
})

ConfigTab:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        if selectedConfig == "" then
            Rayfield:Notify({Title="Error",Content="Select a config first!",Duration=3})
            return
        end

        local path = configFolder.."/"..selectedConfig..".txt"
        if not isfile(path) then
            Rayfield:Notify({Title="Error",Content="File not found.",Duration=3})
            return
        end

        local raw = readfile(path)
        local ok, saved = pcall(function()
            return HttpService:JSONDecode(raw)
        end)
        if not ok or type(saved) ~= "table" then
            Rayfield:Notify({Title="Error",Content="Invalid config file.",Duration=3})
            return
        end

        
        for itemName, tog in pairs(toggleRefs) do
            tog:Set(false)
            autodels[itemName] = false
        end

        
        for _, itemName in ipairs(saved) do
            if not toggleRefs[itemName] then
                
                CreateAutoDeleteToggle(itemName)
            end
            toggleRefs[itemName]:Set(true)
            autodels[itemName] = true
        end

        UpdateListDisplay()
        Rayfield:Notify({Title="Loaded",Content=selectedConfig,Duration=2})
    end,
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
local keywordInput = CTab:CreateInput({
    Name = "Item Name Filter",
    PlaceholderText = "Enter item name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
    end,
})


local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local connection


local monitorToggle = CTab:CreateToggle({
    Name = "Monitor Backpack Items",
    CurrentValue = false,
    Flag = "BackpackMonitor",
    Callback = function(isEnabled)
        if isEnabled then
            
            if connection then
                connection:Disconnect()
                connection = nil
            end
            
            connection = backpack.ChildAdded:Connect(function(item)
                
                local success, err = pcall(function()
                    
                    local keyword = keywordInput.CurrentValue
                    if keyword and keyword ~= "" then
                        local itemName = item.Name or ""
                        if string.find(string.lower(itemName), string.lower(keyword), 1, true) then
                            
                            Rayfield:Notify({
                                Title = "New Item Detected",
                                Content = "Backpack Item: " .. itemName,
                                Duration = 5
                            })
                        end
                    end
                end)
                if not success then
                    warn("Error in Backpack monitor:", err)
                end
            end)
        else
            
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})


Rayfield:LoadConfiguration()