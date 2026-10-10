if getgenv().ayasemiyatongekissazumirisa then
    warn("yuri")
    return
end
function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Service: " .. tostring(name))
		end
	end
})
local Players = Services.Players
local Plr = Players.LocalPlayer
local PGui = Plr.PlayerGui
local Lighting = Services.Lighting
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local v, Asset = pcall(function()
    return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
    assetName = Asset.Name
end
local Support = {
    Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard = (typeof(setclipboard) == "function"),
    FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
    Connections = (typeof(getconnections) == "function"),
    FPS = (typeof(setfpscap) == "function"),
    Proximity = (typeof(fireproximityprompt) == "function"),
}
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors = {"xeno", "solara",}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
local function notyuri()
end
local repo = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left"
local function AddInfo(Window)
    local InfoTab = Window:AddTab("Info")
    local InfoLeft = InfoTab:AddLeftGroupbox("Information")
    local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
    local extraNote = isLimitedExecutor
        and "<b>NOTE:</b> May experiencing bugs for some features!"
        or "All features should works properly!"
    InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
    local InfoRight = InfoTab:AddRightGroupbox("Others")
    InfoRight:AddButton({
        Text = "Join Discord Server",
        Func = function()
            local inviteCode = "q8QX76jyz"
            local inviteLink = "https://discord.gg/" .. inviteCode
            local success = false
            if request then
                success = pcall(function()
                    request({
                        Url = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"] = "https://discord.com"
                        },
                        Body = HttpService:JSONEncode({
                            cmd = "INVITE_BROWSER",
                            args = { code = inviteCode },
                            nonce = HttpService:GenerateGUID(false)
                        })
                    })
                end)
            end
            if not success and setclipboard then
                setclipboard(inviteLink)
            end
        end,
    })
end
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
    local seconds = os.time() - Script_Start_Time
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    return string.format("%dh %02dm", hours, mins)
end
local function GetObject(parent, pathString)
    local current = parent
    for _, name in ipairs(pathString:split(".")) do
        if not current then return nil end
        current = current:FindFirstChild(name)
    end
    return current
end
local function GetSafeModule(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local Flags = {}
local Shared = {
}
local Tables = {
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
    SimonAnnounce = nil,
    SimonWindowOpen = nil,
    SimonWindowClose = nil,
    SimonHideLoop = nil,
    SimonPersistLoop = nil,
    RoundStarted = nil,
    BombPassLoop = nil,
}
local SimonState = {
    Text = nil,
    IsSimon = false,
    ActiveMode = nil,
}
local RoundState = {
    Phase = nil,
}
local BombState = {
    Holding = false,
}
local function SafeConnect(key, getSignalFn, handler)
    local ok, signal = pcall(getSignalFn)
    if not ok or not signal then
        return
    end
    Connections[key] = signal:Connect(handler)
end
local function SafeInvoke(remote, ...)
    local args = {...}
    local result = nil
    task.spawn(function()
        local success, res = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)
        result = res
    end)
    local start = tick()
    repeat task.wait() until result ~= nil or (tick() - start) > 2 
    return result
end
local function fire_event(signal, ...)
    if firesignal then
        return firesignal(signal, ...)
    elseif getconnections then
        for _, connection in ipairs(getconnections(signal)) do
            if connection.Function then
                task.spawn(connection.Function, ...)
            end
        end
    else
        notyuri("Your executor does not support firesignal or getconnections.")
    end
end
local Remotes = {
    Simon = GetObject(RS, "Remotes.Simon"),
    PlayEmote = GetObject(RS, "Customization.PlayEmote"),
    Game = GetObject(RS, "Remotes.Game"),
    Cafeteria = GetObject(RS, "Remotes.Cafeteria"),
    EatBurger = GetObject(RS, "Remotes.Cafeteria.EatBurger"),
    BombHolderChanged = GetObject(RS, "Remotes.Game.BombHolderChanged"),
}
local SimonModule = GetObject(RS, "Modules.Simon")
local Modules = {
    SimonCommandList = SimonModule and GetSafeModule(SimonModule, "CommandList") or nil,
}
local function Cleanup(tbl)
    for key, value in pairs(tbl) do
        if typeof(value) == "RBXScriptConnection" then
            value:Disconnect()
            tbl[key] = nil
        elseif typeof(value) == 'thread' then
            task.cancel(value)
            tbl[key] = nil
        elseif type(value) == 'table' then
            Cleanup(value)
        end
    end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
    local pathParts = featurePath:split(".")
    local currentTable = Flags 
    for i = 1, #pathParts - 1 do
        local part = pathParts[i]
        if not currentTable[part] then currentTable[part] = {} end
        currentTable = currentTable[part]
    end
    local flagKey = pathParts[#pathParts]
    local activeThread = currentTable[flagKey]
    if isEnabled then
        if not activeThread or coroutine.status(activeThread) == "dead" then
            local newThread = task.spawn(featureFunc, ...)
            currentTable[flagKey] = newThread
        end
    else
        if activeThread and typeof(activeThread) == 'thread' then
            task.cancel(activeThread)
            currentTable[flagKey] = nil
        end
    end
end
local function SafeLoop(name, func)
    return function()
        local success, err = pcall(func)
        if not success then
            Library:Notify("Error in ["..name.."]: "..tostring(err), 10)
            notyuri("Error in ["..name.."]: "..tostring(err))
        end
    end
end
local function CommaFormat(n)
    local s = tostring(n)
    return s:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
local function Abbreviate(n)
    local abbrev = {{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
    for _, v in ipairs(abbrev) do
        if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
    end
    return tostring(n)
end
function AddSliderToggle(Config)
    local Toggle = Config.Group:AddToggle(Config.Id, {
        Text = Config.Text,
        Default = Config.DefaultToggle or false
    })
    local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
        Text = Config.Text,
        Default = Config.Default,
        Min = Config.Min,
        Max = Config.Max,
        Rounding = Config.Rounding or 0,
        Compact = true,
        Visible = false
    })
    Toggle:OnChanged(function()
        Slider:SetVisible(Toggle.Value)
    end)
    return Toggle, Slider
end
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function FireCD(target)
    if not fireclickdetector then
        return
    end
    if not target or not target:IsA("ClickDetector") then
        return
    end
    fireclickdetector(target)
end
local function FirePP(target, teleport)
    if not fireproximityprompt then return end
    if not target or not target:IsA("ProximityPrompt") then return end
    local prevDist = target.MaxActivationDistance
    if teleport then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        local isModel = false
        if part then
            if part:IsA("Model") then
                isModel = true
            elseif not part:IsA("BasePart") then
                part = target:FindFirstAncestorWhichIsA("BasePart")
                if not part then
                    part = target:FindFirstAncestorWhichIsA("Model")
                    if part then
                        isModel = true
                    end
                end
            end
        end
        if hrp and part then
            local partPos = isModel and part:GetPivot().Position or part.Position
            local dist = (hrp.Position - partPos).Magnitude
            if dist > prevDist then
                local partCFrame = isModel and part:GetPivot() or part.CFrame
                hrp.CFrame = partCFrame * CFrame.new(0, 3, 0)
                task.wait(0.2)
            end
        end
    end
    fireproximityprompt(target)
end
local function FireTI(target)
    if not firetouchinterest then
        return
    end
    local root = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    local part
    if target:IsA("BasePart") then
        part = target
    else
        part = target:FindFirstAncestorWhichIsA("BasePart")
    end
    if not part then
        return
    end
    task.spawn(function()
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end)
end
local function FuncTPW()
    while true do
        local delta = RunService.Heartbeat:Wait()
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            if hum.MoveDirection.Magnitude > 0 then
                local speed = Options.TPWValue.Value
                char:TranslateBy(hum.MoveDirection * speed * delta * 10)
            end
        end
    end
end
local function FuncNoclip()
    while Toggles.Noclip.Value do
        RunService.Stepped:Wait()
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end
local function Func_AntiKnockback()
    if type(Connections.Knockback) == "table" then
        for _, conn in pairs(Connections.Knockback) do
            if conn then conn:Disconnect() end
        end
        table.clear(Connections.Knockback)
    else
        Connections.Knockback = {}
    end
    local function ApplyAntiKB(character)
        if not character then return end
        local root = character:WaitForChild("HumanoidRootPart", 10)
        if root then
            local conn = root.ChildAdded:Connect(function(child)
                if not Toggles.AntiKnockback.Value then return end
                if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
                    child:Destroy()
                end
            end)
            table.insert(Connections.Knockback, conn)
        end
    end
    if Plr.Character then
        ApplyAntiKB(Plr.Character)
    end
    local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
        ApplyAntiKB(newChar)
    end)
    table.insert(Connections.Knockback, charAddedConn)
    repeat task.wait(1) until not Toggles.AntiKnockback.Value
    for _, conn in pairs(Connections.Knockback) do
        if conn then conn:Disconnect() end
    end
    table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
    if Connections.Reconnect then Connections.Reconnect:Disconnect() end
    Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
        if not Toggles.AutoReconnect.Value then return end
        task.delay(2, function()
            pcall(function()
                local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if promptOverlay then
                    local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
                    if errorPrompt and errorPrompt.Visible then
                        local secondaryTimer = 5
                        task.wait(secondaryTimer)
                        TeleportService:Teleport(game.PlaceId, Plr)
                    end
                end
            end)
        end)
    end)
end
local function Func_NoGameplayPaused()
    while Toggles.NoGameplayPaused.Value do
        local success, err = pcall(function()
            local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            if pauseGui then
                pauseGui:Destroy()
            end
        end)
        task.wait(1)
    end
end
local SimonModeLabels = {
    jump = "JUMP",
    sit = "SIT DOWN",
    crouch = "CROUCH",
    still = "DON'T MOVE",
    tables = "STAND ON TABLES",
    standonline = "STAND ON THE LINE",
    hideandseek = "HIDE",
    sleep = "GO TO BED",
    dance = "DANCE",
    secondfloor = "GET ON 2ND FLOOR",
    thirdfloor = "GO TO 3RD FLOOR",
    cafeteria = "GO TO CAFETERIA",
    basement = "GO TO BASEMENT",
    goToCell = "GO TO CELL",
    returnCells = "RETURN TO CELLS",
    circle = "CIRCLE",
    celllight = "CELL LIGHTS",
    twodoors = "CHOOSE A DOOR",
    stairs = "GO UP THE STAIRS",
    gateorder = "CELL GATE",
    sprint = "SPRINT",
    firstfloor = "GET ON 1ST FLOOR",
    race = "LAST PERSON DIES",
    killer = "THE KILLER",
    chairs = "MUSICAL CHAIRS",
    climb = "CLIMB THE LADDER",
    cameras = "ARMED CAMERAS",
    bomb = "PASS THE BOMB",
}
local SimonCommandNames = {}
local SimonSeenLabels = {}
for _, modeId in ipairs({ "jump", "sit", "crouch", "still", "tables", "standonline", "hideandseek", "sleep", "dance", "secondfloor", "thirdfloor", "basement", "goToCell", "returnCells", "circle", "celllight", "twodoors", "stairs", "gateorder", "sprint", "firstfloor", "race", "killer", "chairs", "cafeteria", "climb", "cameras", "bomb" }) do
    local label = SimonModeLabels[modeId]
    if label and not SimonSeenLabels[label] then
        SimonSeenLabels[label] = true
        table.insert(SimonCommandNames, label)
    end
end
local function GetTable()
    local TablesFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Tables")
    if not TablesFolder then return nil end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, tableModel in ipairs(TablesFolder:GetChildren()) do
        local part = tableModel:FindFirstChild("Part")
        if part and part:IsA("BasePart") then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist < nearestDist then
                nearest = part
                nearestDist = dist
            end
        end
    end
    return nearest
end
local function GetLadder()
    local LaddersFolder = workspace:FindFirstChild("Ladders")
    if not LaddersFolder then return nil end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, ladderModel in ipairs(LaddersFolder:GetChildren()) do
        local part = ladderModel:FindFirstChild("Truss") or ladderModel:FindFirstChild("Part")
        if part and part:IsA("BasePart") then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist < nearestDist then
                nearest = part
                nearestDist = dist
            end
        end
    end
    return nearest
end
local function GetNearestTrialLadder()
    local LaddersFolder = workspace:FindFirstChild("Ladders")
    if not LaddersFolder then return nil end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, ladderModel in ipairs(LaddersFolder:GetChildren()) do
        if ladderModel.Name:match("^TrialLadder") then
            local part = ladderModel:FindFirstChild("Truss") or ladderModel:FindFirstChild("Part")
            if part and part:IsA("BasePart") then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < nearestDist then
                    nearest = part
                    nearestDist = dist
                end
            end
        end
    end
    return nearest
end
local function GetNearestTrialTable()
    local TwoDoors = workspace:FindFirstChild("TwoDoors")
    local TrialTables = TwoDoors and TwoDoors:FindFirstChild("TrialTables")
    if not TrialTables then return nil end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, tableModel in ipairs(TrialTables:GetChildren()) do
        local part = tableModel:FindFirstChild("Part")
        if part and part:IsA("BasePart") then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist < nearestDist then
                nearest = part
                nearestDist = dist
            end
        end
    end
    return nearest
end
local function GetNearestTrialSeat()
    local TwoDoors = workspace:FindFirstChild("TwoDoors")
    local TrialTables = TwoDoors and TwoDoors:FindFirstChild("TrialTables")
    if not TrialTables then return nil end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local nearest, nearestDist = nil, math.huge
    for _, tableModel in ipairs(TrialTables:GetChildren()) do
        for _, child in ipairs(tableModel:GetChildren()) do
            if child:IsA("Seat") and not child.Occupant then
                if hrp then
                    local dist = (hrp.Position - child.Position).Magnitude
                    if dist < nearestDist then
                        nearest = child
                        nearestDist = dist
                    end
                elseif not nearest then
                    nearest = child
                end
            end
        end
    end
    return nearest
end
local function GetSeekerHRP()
    local seekerName = SimonState.SeekerName
    if not seekerName then return nil end
    local seekerPlr = Players:FindFirstChild(seekerName)
    local seekerChar = seekerPlr and seekerPlr.Character
    return seekerChar and seekerChar:FindFirstChild("HumanoidRootPart")
end
local function GetHideSpots()
    local spots = {
        CFrame.new(105, 120, -101),
        CFrame.new(95, 103, -107),
        CFrame.new(126, 89, 32),
    }
    local lunchGuy = workspace:FindFirstChild("LunchGuy")
    local lunchRoot = lunchGuy and lunchGuy:FindFirstChild("HumanoidRootPart")
    if lunchRoot then
        table.insert(spots, lunchRoot.CFrame * CFrame.new(0, 0, 3))
    end
    return spots
end
local function Func_SimonHideLoop()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    SimonState.PreHideCFrame = hrp.CFrame
    Connections.SimonHideLoop = RunService.Heartbeat:Connect(function()
        local c = GetCharacter()
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local seekerHRP = GetSeekerHRP()
        if seekerHRP then
            local dist = (root.Position - seekerHRP.Position).Magnitude
            if dist < 50 then
                local spots = GetHideSpots()
                local furthest, furthestDist = nil, -1
                for _, spot in ipairs(spots) do
                    local d = (spot.Position - seekerHRP.Position).Magnitude
                    if d > furthestDist then
                        furthest = spot
                        furthestDist = d
                    end
                end
                if furthest then
                    root.CFrame = furthest
                end
            end
        end
    end)
end
local function GetMyCellNumber()
    for _, attrName in ipairs({ "AssignedCell", "CellNumber", "AssignedSpawn", "SpawnNumber", "Cell" }) do
        local v = Plr:GetAttribute(attrName)
        if type(v) == "number" then
            return v
        end
        if type(v) == "string" then
            local n = tonumber(v:match("(%d+)"))
            if n then return n end
        end
    end
    return nil
end
local function GetMyBedPrompt()
    local BedsFolder = GetObject(workspace, "Map.CellProps.Beds")
    if not BedsFolder then return nil end
    local myCell = GetMyCellNumber()
    for _, bedModel in ipairs(BedsFolder:GetChildren()) do
        if bedModel:IsA("Model") then
            local bedNum = tonumber(bedModel.Name:match("Bed_(%d+)"))
            if bedNum and (myCell == nil or bedNum == myCell) then
                local mattress = bedModel:FindFirstChild("Mattress")
                local prompt = mattress and mattress:FindFirstChild("BedSleepPrompt")
                if prompt then
                    return prompt
                end
            end
        end
    end
    return nil
end
local function GetMyToiletSeat()
    local ToiletsFolder = GetObject(workspace, "Map.CellProps.Toilets")
    if not ToiletsFolder then return nil end
    local myCell = GetMyCellNumber()
    for _, toiletPart in ipairs(ToiletsFolder:GetChildren()) do
        if toiletPart:IsA("BasePart") then
            local toiletNum = tonumber(toiletPart.Name:match("Toilet_(%d+)"))
            if toiletNum and (myCell == nil or toiletNum == myCell) then
                local seat = toiletPart:FindFirstChild("ToiletSeat")
                if seat and seat:IsA("Seat") then
                    return seat
                end
            end
        end
    end
    return nil
end
local function GetOpenChairSeat()
    local ChairRing = workspace:FindFirstChild("ChairRing")
    if not ChairRing then return nil end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local closestSeat, closestDist = nil, math.huge
    for _, chairPart in ipairs(ChairRing:GetChildren()) do
        local seat = chairPart:FindFirstChild("Seat")
        if seat and seat:IsA("Seat") and not seat.Occupant then
            if hrp then
                local dist = (seat.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestSeat = seat
                end
            elseif not closestSeat then
                closestSeat = seat
            end
        end
    end
    return closestSeat
end
local function GetMyGatePrompt()
    local GatesFolder = GetObject(workspace, "Map.Gates.GatePromptAnchors")
    if not GatesFolder then return nil end
    local myCell = GetMyCellNumber()
    for _, anchor in ipairs(GatesFolder:GetChildren()) do
        local prompt = anchor:FindFirstChild("CellGatePrompt")
        if prompt and prompt:IsA("ProximityPrompt") then
            local cellNum = prompt:GetAttribute("CellNumber")
            if myCell == nil or cellNum == myCell then
                return prompt
            end
        end
    end
    return nil
end
local function GetMyCellLight()
    local myCell = GetMyCellNumber()
    if not myCell then return nil end
    local lightModel = GetObject(workspace, "Map.Lighting.IndustrialLights.IndustrialLight_" .. string.format("%02d", myCell))
    if not lightModel then return nil end
    return GetObject(lightModel, "Light.PointLight")
end
local function Func_SimonPersist(modeId)
    if Connections.SimonPersistLoop then
        Connections.SimonPersistLoop:Disconnect()
        Connections.SimonPersistLoop = nil
    end
    local lastCrouchFire = 0
    Connections.SimonPersistLoop = RunService.Heartbeat:Connect(function()
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if modeId == "sit" then
            if not hum.Sit then
                local seat = GetMyToiletSeat()
                if seat then
                    seat:Sit(hum)
                else
                    hum.Sit = true
                end
            end
        elseif modeId == "trialsit" then
            if not hum.Sit then
                local seat = GetNearestTrialSeat()
                if seat then
                    seat:Sit(hum)
                else
                    notyuri("[SimonSays] No open trial seat found in TrialTables")
                end
            end
        elseif modeId == "crouch" then
            if tick() - lastCrouchFire >= 0.5 then
                lastCrouchFire = tick()
                Remotes.Simon.CrouchState:FireServer(true)
            end
        elseif modeId == "tables" then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local part = GetTable()
            if hrp and part then
                hrp.CFrame = part.CFrame * CFrame.new(0, 3, 0)
            end
        elseif modeId == "standonline" then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local linePart = workspace:FindFirstChild("Line")
            if hrp and linePart then
                hrp.CFrame = linePart.CFrame * CFrame.new(0, 3, 0)
            end
        elseif modeId == "circle" then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local circleModel = workspace:FindFirstChild("Circle")
            if hrp and circleModel then
                hrp.CFrame = circleModel:GetPivot() * CFrame.new(0, 3, 0)
            end
        elseif modeId == "trialtables" then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local part = GetNearestTrialTable()
            if hrp and part then
                hrp.CFrame = part.CFrame * CFrame.new(0, 3, 0)
            else
                notyuri("[SimonSays] Could not find nearest trial table")
            end
        elseif modeId == "chairs" then
            if not hum.Sit then
                local seat = GetOpenChairSeat()
                if seat then
                    seat:Sit(hum)
                else
                    notyuri("[SimonSays] No open chair seat found in ChairRing")
                end
            end
        elseif modeId == "climb" then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local ladder = GetLadder()
            if hrp and ladder then
                hrp.CFrame = ladder.CFrame
            else
                notyuri("[SimonSays] Could not find nearest ladder")
            end
        elseif modeId == "trialclimb" then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local ladder = GetNearestTrialLadder()
            if hrp and ladder then
                hrp.CFrame = ladder.CFrame
            else
                notyuri("[SimonSays] Could not find nearest trial ladder")
            end
        end
    end)
end
local CellLightColor = {
    Off = Color3.fromRGB(15, 15, 17),
    On = Color3.fromRGB(60, 255, 100),
}
local function IsCellLightOn()
    local pointLight = GetMyCellLight()
    if not pointLight then return nil end
    local c = pointLight.Color
    local onDist = (Vector3.new(c.R, c.G, c.B) - Vector3.new(CellLightColor.On.R, CellLightColor.On.G, CellLightColor.On.B)).Magnitude
    local offDist = (Vector3.new(c.R, c.G, c.B) - Vector3.new(CellLightColor.Off.R, CellLightColor.Off.G, CellLightColor.Off.B)).Magnitude
    return onDist < offDist
end
local function Func_GoToCell()
    local char = GetCharacter()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seat = GetMyToiletSeat()
    if hum and seat then
        seat:Sit(hum)
    end
end
local function Func_GoToCircle()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local circleModel = workspace:FindFirstChild("Circle")
    if hrp and circleModel then
        hrp.CFrame = circleModel:GetPivot() * CFrame.new(0, 3, 0)
    end
end
local function GetFurthestPlayerHRP(fromPos)
    local furthestHRP, furthestDist = nil, -1
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= Plr and other.Character then
            local hrp = other.Character:FindFirstChild("HumanoidRootPart")
            local hum = other.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (fromPos - hrp.Position).Magnitude
                if dist > furthestDist then
                    furthestDist = dist
                    furthestHRP = hrp
                end
            end
        end
    end
    return furthestHRP
end
local function PassBomb()
    if Connections.BombPassLoop then
        Connections.BombPassLoop:Disconnect()
        Connections.BombPassLoop = nil
    end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local savedCFrame = hrp.CFrame
    Connections.BombPassLoop = RunService.Heartbeat:Connect(function()
        if not BombState.Holding or not Toggles.AutoSS.Value then
            if Connections.BombPassLoop then
                Connections.BombPassLoop:Disconnect()
                Connections.BombPassLoop = nil
            end
            local c = GetCharacter()
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if r then
                r.CFrame = savedCFrame
            end
            return
        end
        local c = GetCharacter()
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then return end
        local targetHRP = GetFurthestPlayerHRP(r.Position)
        if targetHRP then
            r.CFrame = targetHRP.CFrame
        end
    end)
end
local function GotoCafe()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local waypoints = {
        CFrame.new(66, 136, -34),
    }
    if (hrp.Position - waypoints[#waypoints].Position).Magnitude < 5 then
        return
    end
    for _, cf in ipairs(waypoints) do
        hrp.CFrame = cf
        task.wait(.5)
    end
end
local function GetOrderItemId()
    local choice = Options.OrderSelected and Options.OrderSelected.Value
    if choice == "Coffee" then
        return "coffee"
    end
    return "burger"
end
local function Func_AutoOrder()
    local Success = false
    local OrderConn = nil
    if not OrderConn then
        SafeConnect("AutoOrderResult", function()
            return Remotes.Cafeteria.OrderResult.OnClientEvent
        end, function(success)
            if success then
                Success = true
            end
        end)
        OrderConn = true
    end
    while Toggles.AutoOrder.Value do
        task.wait()
        local foodWindow = workspace:FindFirstChild("FoodWindow")
        local orderPart = foodWindow and foodWindow:FindFirstChild("Order")
        local prompt = orderPart and orderPart:FindFirstChild("OrderPrompt")
        if prompt and prompt.Enabled then
            task.wait(math.random(4,8))
            if Success then
                repeat
                    task.wait(0.5)
                until not Toggles.AutoOrder.Value or not prompt.Enabled
                if not Toggles.AutoOrder.Value then
                    break
                end
                repeat
                    task.wait(0.5)
                until not Toggles.AutoOrder.Value or prompt.Enabled
                Success = false
            else
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and orderPart and orderPart:IsA("BasePart") then
                    GotoCafe()
                end
                if Remotes.Cafeteria and Remotes.Cafeteria.SubmitOrder then
                    Remotes.Cafeteria.SubmitOrder:FireServer(GetOrderItemId())
                end
            end
        end
    end
end
local function Func_AutoPickup()
    while Toggles.AutoPickup.Value do
        task.wait()
        for _, item in pairs(workspace:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("CanDrop") == true then
                local handle = item:FindFirstChild("Handle")
                local prompt = handle and handle:FindFirstChild("DropPickupPrompt")
                if prompt then
                    FirePP(prompt, true)
                end
            end
        end
    end
end
local function Func_AutoBurger()
    while Toggles.AutoBurger.Value do
        task.wait(0.5)
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local healthPct = hum.Health / (hum.MaxHealth > 0 and hum.MaxHealth or 100)
            local threshold = (Options.BurgerTheshold.Value or 80) / 100
            if healthPct < threshold then
                local burger = char:FindFirstChild("Cheeseburger") or Plr.Backpack:FindFirstChild("Cheeseburger")
                if burger and Remotes.EatBurger then
                    if burger.Parent ~= char then
                        hum:EquipTool(burger)
                        task.wait(0.1)
                    end
                    Remotes.EatBurger:FireServer()
                end
            end
        end
    end
end
local function Func_AutoCoffee()
    while Toggles.AutoCoffee.Value do
        task.wait(0.5)
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local stamina = (_G.GetStamina and _G.GetStamina()) or 100
            local threshold = (Options.CoffeeThreshold.Value or 50)
            if stamina < threshold then
                local coffee = char:FindFirstChild("Coffee") or Plr.Backpack:FindFirstChild("Coffee")
                if coffee and Remotes.EatBurger then
                    if coffee.Parent ~= char then
                        hum:EquipTool(coffee)
                        task.wait(0.1)
                    end
                    Remotes.EatBurger:FireServer()
                end
            end
        end
    end
end
local AutoAimHeld = false
local function GetNearestPlayerToCrosshair()
    local Camera = workspace.CurrentCamera
    if not Camera then return nil end
    local viewportSize = Camera.ViewportSize
    local crosshairPos = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local closestHRP, closestDist = nil, math.huge
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= Plr and other.Character then
            local hrp = other.Character:FindFirstChild("HumanoidRootPart")
            local hum = other.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - crosshairPos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestHRP = hrp
                    end
                end
            end
        end
    end
    return closestHRP
end
local function Func_AutoAim(deltaTime)
    if not (Toggles.AutoAim.Value and AutoAimHeld) then return end
    local Camera = workspace.CurrentCamera
    if not Camera then return end
    local targetHRP = GetNearestPlayerToCrosshair()
    if not targetHRP then return end
    local camPos = Camera.CFrame.Position
    Camera.CFrame = CFrame.lookAt(camPos, targetHRP.Position)
end
local function Func_SimonRespond(modeId)
    local label = SimonModeLabels[modeId]
    if not label then
        notyuri("[SimonSays] Unhandled mode id: " .. tostring(modeId))
        return
    end
    if not (Options.ActionSelected and Options.ActionSelected.Value and Options.ActionSelected.Value[label]) then
        return
    end
    SimonState.ActiveMode = modeId
    if modeId == "sit" or modeId == "crouch" or modeId == "tables" or modeId == "chairs" or modeId == "climb" then
        Func_SimonPersist(modeId)
    elseif modeId == "jump" then
        if not hum.Jump then
            hum.Jump = true
        end
    elseif modeId == "still" then
    elseif modeId == "standonline" then
        Func_SimonPersist(modeId)
    elseif modeId == "hideandseek" then
        Func_SimonHideLoop()
    elseif modeId == "sleep" then
        local prompt = GetMyBedPrompt()
        if prompt then
            FirePP(prompt, true)
        end
    elseif modeId == "dance" then
        if Remotes.PlayEmote then
            Remotes.PlayEmote:FireServer("emote_default")
        end
    elseif modeId == "sprint" then
        pcall(function()
            Remotes.Simon.SprintState:FireServer(true)
        end)
    elseif modeId == "secondfloor" then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(105, 120, -101)
        end
    elseif modeId == "firstfloor" then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(95, 103, -107)
        end
    elseif modeId == "thirdfloor" then
        GotoCafe()
    elseif modeId == "cafeteria" then
        GotoCafe()
    elseif modeId == "basement" then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(126, 89, 32)
        end
    elseif modeId == "cameras" then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(153, 120, -87)
        end
    elseif modeId == "race" then
        local text = (SimonState.Text or ""):upper()
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if text:find("2ND FLOOR") then
            if hrp then
                hrp.CFrame = CFrame.new(105, 120, -101)
            end
        elseif text:find("1ST FLOOR") then
            if hrp then
                hrp.CFrame = CFrame.new(95, 103, -107)
            end
        elseif text:find("BASEMENT") then
            if hrp then
                hrp.CFrame = CFrame.new(126, 89, 32)
            end
        elseif text:find("3RD FLOOR") or text:find("CAFETERIA") then
            GotoCafe()
        else
            notyuri("[SimonSays] Unhandled race destination text: " .. tostring(SimonState.Text))
        end
    elseif modeId == "bomb" then
        PassBomb()
    elseif modeId == "goToCell" then
        Func_GoToCell()
    elseif modeId == "returnCells" then
        Func_GoToCell()
    elseif modeId == "killer" then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local lunchGuy = workspace:FindFirstChild("LunchGuy")
        local lunchRoot = lunchGuy and lunchGuy:FindFirstChild("HumanoidRootPart")
        if hrp and lunchRoot then
            hrp.CFrame = lunchRoot.CFrame * CFrame.new(0, 0, 3)
        end
    elseif modeId == "circle" then
        local text = (SimonState.Text or ""):upper()
        if text:find("LEAVE") then
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local circleModel = workspace:FindFirstChild("Circle")
            if hrp and circleModel then
                local dist = (hrp.Position - circleModel:GetPivot().Position).Magnitude
                if dist < 50 then
                    Func_GoToCell()
                end
            end
        elseif text:find("STAY") or text:find("GET IN") then
            Func_SimonPersist("circle")
        end
    elseif modeId == "twodoors" then
        local text = (SimonState.Text or ""):upper()
        if SimonState.Trial then
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if text:find("JUMP") then
                if hum and not hum.Jump then
                    hum.Jump = true
                end
            elseif text:find("SIT") or text:find("SEAT") then
                Func_SimonPersist("trialsit")
            elseif text:find("CROUCH") then
                Func_SimonPersist("crouch")
            elseif text:find("DON'T MOVE") then
            elseif text:find("STAND ON THE LINE") then
                local TwoDoors = workspace:FindFirstChild("TwoDoors")
                local linePart = TwoDoors and TwoDoors:FindFirstChild("TrialLine")
                if hrp and linePart then
                    hrp.CFrame = linePart.CFrame * CFrame.new(0, 3, 0)
                else
                    notyuri("[SimonSays] Could not find TwoDoors.TrialLine")
                end
            elseif text:find("STAND ON TABLES") or text:find("STAND ON THE TABLES") then
                Func_SimonPersist("trialtables")
            elseif text:find("DANCE") then
                if Remotes.PlayEmote then
                    Remotes.PlayEmote:FireServer("emote_default")
                end
            elseif text:find("SPRINT") then
                pcall(function()
                    Remotes.Simon.SprintState:FireServer(true)
                end)
            elseif text:find("CLIMB") then
                Func_SimonPersist("trialclimb")
            else
                notyuri("[SimonSays] Unhandled twodoors trial instruction text: " .. tostring(SimonState.Text))
            end
        else
            local doorName = (Options.DoorSelected and Options.DoorSelected.Value) or "Door1"
            local TwoDoors = workspace:FindFirstChild("TwoDoors")
            local doorModel = TwoDoors and TwoDoors:FindFirstChild(doorName)
            local base = doorModel and doorModel:FindFirstChild("Base")
            local prompt = base and base:FindFirstChild("ChoosePrompt")
            if prompt then
                FirePP(prompt, true)
            else
                notyuri("[SimonSays] Could not find ChoosePrompt for " .. doorName)
            end
        end
    elseif modeId == "stairs" then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local stairTop = GetObject(workspace, "Map.Structure.Architecture.Stair.StairTop")
        if hrp and stairTop then
            hrp.CFrame = CFrame.new(stairTop.WorldPosition)
        else
            notyuri("[SimonSays] Could not find StairTop attachment")
        end
    elseif modeId == "gateorder" then
        local text = (SimonState.Text or ""):upper()
        local wantOpen = text:find("OPEN") ~= nil
        local wantClose = text:find("CLOSE") ~= nil
        local prompt = GetMyGatePrompt()
        if prompt then
            local actionText = (prompt.ActionText or ""):upper()
            local needsToggle = true
            if wantOpen and actionText:find("CLOSE") then
                needsToggle = false
            elseif wantClose and actionText:find("OPEN") then
                needsToggle = false
            end
            if needsToggle then
                FirePP(prompt, true)
            end
        else
            notyuri("[SimonSays] Could not find CellGatePrompt for my cell")
        end
    elseif modeId == "celllight" then
        local text = (SimonState.Text or ""):upper()
        local wantOn = text:find("ON") ~= nil
        local wantOff = text:find("OFF") ~= nil
        local isOn = IsCellLightOn()
        local needsToggle = true
        if isOn ~= nil then
            if wantOn and isOn then
                needsToggle = false
            elseif wantOff and not isOn then
                needsToggle = false
            end
        end
        if needsToggle then
            local myCell = GetMyCellNumber()
            local switchModel = myCell and workspace:FindFirstChild("LightSwitches") and workspace.LightSwitches:FindFirstChild("LightSwitch" .. tostring(myCell))
            local button = switchModel and switchModel:FindFirstChild("Button")
            local prompt = button and button:FindFirstChild("LightSwitchPrompt")
            if prompt then
                FirePP(prompt, true)
            end
        end
    else
        notyuri("[SimonSays] Unhandled mode id: " .. tostring(modeId))
    end
end
local function ApplyFPSBoost(state)
    if not state then return end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
        task.spawn(function()
            for i, v in pairs(workspace:GetDescendants()) do
                if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
                pcall(function()
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.SmoothPlastic
                        v.CastShadow = false
                    elseif v:IsA("Decal") or v:IsA("Texture") then
                        v:Destroy()
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                        v.Enabled = false
                    end
                end)
                if i % 500 == 0 then task.wait() end
            end
        end)
    end)
end
function gsc(guiObject)
    if not guiObject then return false end
    local success = false
    pcall(function()
        if Services.GuiService and Services.VirtualInputManager then
            Services.GuiService.SelectedObject = guiObject
            task.wait(0.05)
            local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
            for _, key in ipairs(keys) do
                Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.03)
                Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.03)
            end
            Services.GuiService.SelectedObject = nil
            success = true
        end
    end)
    return success
end
local Window = Library:CreateWindow({
	Title = "Yuri",
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = false,
	UnlockMouseWhileOpen = false,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})
AddInfo(Window)
local Tabs = {
	Main = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Autofarm = Tabs.Main:AddLeftTabbox(),
        },
        Right = {
            Autofarm = Tabs.Main:AddRightTabbox(),
        },
    },
}
local TB_Tabs = {
    Autofarm = {
        T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Config"),
    },
}
local GB = {
    Player = {
        Left = {
            General = Tabs.Player:AddLeftGroupbox("General"),
            Server  = Tabs.Player:AddLeftGroupbox("Server"),
        },
        Right = {
            Game = Tabs.Player:AddRightGroupbox("Game"),
        },
    },
}
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", {
    Text = "Anti Knockback",
    Default = false,
})
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Default = true,
    Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
    local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
Toggles.AntiKnockback:OnChanged(function(state)
    Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
    TPW_S:SetVisible(TPW_T.Value)
    Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
    Thread("Noclip", FuncNoclip, v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
    local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if Hum then
        if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
        if Toggles.JP.Value then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
        if Toggles.HH.Value then Hum.HipHeight = Options.HHValue.Value end
    end
    workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
    if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
    if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoSS", { Text = "Auto SS", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoOrder", { Text = "Auto Order", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBurger", { Text = "Auto Burger", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCoffee", { Text = "Auto Coffee", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAim", { Text = "Auto Aim", Default = false, Tooltip = "Hold left ctrl"})
TB_Tabs.Autofarm2.T1:AddDropdown("OrderSelected", { Text = "Select Order", Values = { "Cheeseburger", "Coffee" }, Default = "Cheeseburger", Multi = false })
TB_Tabs.Autofarm2.T1:AddDropdown("ActionSelected", { Text = "Action List", Values = SimonCommandNames, Default = SimonCommandNames, Multi = true, Searchable = true, })
TB_Tabs.Autofarm2.T1:AddDropdown("DoorSelected", { Text = "Select Door", Values = { "Door1", "Door2" }, Default = "Door1", Multi = false })
TB_Tabs.Autofarm2.T1:AddSlider("BurgerTheshold", { Text = "Burger Threshold", Default = 80, Min = 1, Max = 100, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("CoffeeThreshold", { Text = "Coffee Threshold", Default = 50, Min = 1, Max = 100, Rounding = 0 })
Toggles.AutoOrder:OnChanged(function(state)
    Thread("AutoOrder", SafeLoop("AutoOrder", Func_AutoOrder), state)
end)
Toggles.AutoPickup:OnChanged(function(state)
    Thread("AutoPickup", SafeLoop("AutoPickup", Func_AutoPickup), state)
end)
Toggles.AutoBurger:OnChanged(function(state)
    Thread("AutoBurger", SafeLoop("AutoBurger", Func_AutoBurger), state)
end)
Toggles.AutoCoffee:OnChanged(function(state)
    Thread("AutoCoffee", SafeLoop("AutoCoffee", Func_AutoCoffee), state)
end)
local AssetDir = "yuri/Assets"
local AssetBase = "https://raw.githubusercontent.com/iLove-yuri/debug/main/NewUI/"
local function MkFldr(P)
    if Support.FileIO and typeof(isfolder) == "function" and typeof(makefolder) == "function" then
        if not isfolder(P) then makefolder(P) end
    end
end
local function GetAsset(N)
    if not (Support.FileIO and typeof(request) == "function" and typeof(getcustomasset) == "function") then
        return ""
    end
    local P = AssetDir .. "/" .. N
    if not isfile(P) then
        local Ok, Rs = pcall(request, { Url = AssetBase .. N, Method = "GET" })
        if Ok and Rs and Rs.Body and #Rs.Body > 0 then
            writefile(P, Rs.Body)
        end
    end
    if not isfile(P) then
        return ""
    end
    local Ok, Res = pcall(getcustomasset, P)
    if Ok and Res then
        return Res
    end
    return ""
end
MkFldr("yuri")
MkFldr(AssetDir)
local MBtn = nil
local function CreateBtn()
    if MBtn then return end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = ""
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 100
    ScreenGui.Parent = PGui
    local Button = Instance.new("ImageButton")
    Button.Name = ""
    Button.Size = UDim2.new(0, 60, 0, 60)
    Button.Position = UDim2.new(1, -190, 1, -260)
    Button.AnchorPoint = Vector2.new(0.5, 0.5)
    Button.BackgroundTransparency = 1
    Button.BorderSizePixel = 0
    Button.Image = GetAsset("Homu.png")
    Button.ScaleType = Enum.ScaleType.Fit
    Button.AutoButtonColor = false
    Button.Parent = ScreenGui
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            AutoAimHeld = true
        end
    end)
    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            AutoAimHeld = false
        end
    end)
    MBtn = ScreenGui
end
local function DestroyBtn()
    if MBtn then
        MBtn:Destroy()
        MBtn = nil
    end
end
Toggles.AutoAim:OnChanged(function(state)
    if state then
        if UIS.TouchEnabled and not UIS.KeyboardEnabled then
            CreateBtn()
        end
    else
        AutoAimHeld = false
        DestroyBtn()
    end
end)
SafeConnect("AutoAimInputBegan", function() return UIS.InputBegan end, function(input, gameProcessed)
    if gameProcessed then return end
    if Toggles.AutoAim.Value and input.KeyCode == Enum.KeyCode.LeftControl then
        AutoAimHeld = true
    end
end)
SafeConnect("AutoAimInputEnded", function() return UIS.InputEnded end, function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        AutoAimHeld = false
    end
end)
Connections.AutoAimLoop = RunService.Heartbeat:Connect(function(deltaTime)
    Func_AutoAim(deltaTime)
end)
SafeConnect("RoundStarted", function() return Remotes.Game.RoundStarted.OnClientEvent end, function(phase, ...)
    RoundState.Phase = phase
end)
SafeConnect("SimonAnnounce", function() return Remotes.Simon.WardenAnnounce.OnClientEvent end, function(text, isSimon)
    SimonState.Text = text
    SimonState.IsSimon = isSimon
    local seekerName = text and text:match("^SIMON HAS SELECTED (.-) AS THE SEEKER%.$")
    if seekerName then
        SimonState.SeekerName = seekerName
    end
    local UT = (text or ""):upper()
    if UT:find("CONCLUDES THE TRIAL") then
        SimonState.Trial = false
    end
    if text:find("BEGINNING THE TRIAL") then
        SimonState.Trial = true
    end
    if not Toggles.AutoSS.Value then return end
    if not isSimon then return end
    if UT:find("RETURN TO YOUR CELLS") or UT:find("GO TO ANY CELL") then
        if not (Options.ActionSelected and Options.ActionSelected.Value and Options.ActionSelected.Value[SimonModeLabels.returnCells]) then
            return
        end
        SimonState.ActiveMode = "returnCells"
        Func_GoToCell()
    end
end)
SafeConnect("BombHolderChanged", function() return Remotes.BombHolderChanged.OnClientEvent end, function(isHolding)
    BombState.Holding = isHolding and true or false
    if not BombState.Holding then return end
    if not Toggles.AutoSS.Value then return end
    if not (Options.ActionSelected and Options.ActionSelected.Value and Options.ActionSelected.Value[SimonModeLabels.bomb]) then
        return
    end
    Func_SimonRespond("bomb")
end)
SafeConnect("SimonWindowOpen", function() return Remotes.Simon.WindowOpen.OnClientEvent end, function(modeId, duration)
    if not Toggles.AutoSS.Value then return end
    if not SimonState.IsSimon then return end
    local char = GetCharacter()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Sit then
        repeat
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait()
        until not hum.Sit
    end
    Func_SimonRespond(modeId)
end)
SafeConnect("SimonWindowClose", function() return Remotes.Simon.WindowClose.OnClientEvent end, function()
    if Connections.SimonHideLoop then
        Connections.SimonHideLoop:Disconnect()
        Connections.SimonHideLoop = nil
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and SimonState.PreHideCFrame then
            hrp.CFrame = SimonState.PreHideCFrame
        end
        SimonState.PreHideCFrame = nil
    end
    if Connections.SimonPersistLoop then
        Connections.SimonPersistLoop:Disconnect()
        Connections.SimonPersistLoop = nil
    end
    if SimonState.ActiveMode == "crouch" then
        Remotes.Simon.CrouchState:FireServer(false)
    elseif SimonState.ActiveMode == "sprint" then
        pcall(function()
            Remotes.Simon.SprintState:FireServer(false)
        end)
    end
    SimonState.ActiveMode = nil
end)
task.spawn(function()
    while task.wait() do
        if Toggles.Fullbright.Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        elseif Toggles.OverrideTime.Value then
            Lighting.ClockTime = Options.OverrideTimeValue.Value
        end
        if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
        if Library.Unloaded then break end
    end
end)
Options.LimitFPSValue:OnChanged(function()
    if FPS_T.Value then
        setfpscap(FPS_S.Value)
    end
end)
Toggles.LimitFPS:OnChanged(function(v)
    FPS_S:SetVisible(FPS_T.Value)
    if not v then
        setfpscap(999)
    end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state)
    ApplyFPSBoost(state)
end)
Toggles.AutoReconnect:OnChanged(function(state)
    if state then Func_AutoReconnect() end
end)
Toggles.NoGameplayPaused:OnChanged(function(state)
    Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP and Toggles.InstantPP.Value then
        prompt.HoldDuration = 0
    end
end)
local function RunAntiAFK()
    local GC = getconnections or get_signal_cons
    if GC then
        for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    else
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end
Toggles.AntiAFK:OnChanged(function(state)
    if state then RunAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", {
    Text = "Auto Show UI",
    Default = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = false,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",
	Text = "Notification Side",
	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",
	Text = "DPI Scale",
	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)
		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
    getgenv().ayasemiyatongekissazumirisa = false
    Shared.Farm = false
    Cleanup(Connections)
    Cleanup(Flags)
    DestroyBtn()
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/DOG")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
task.defer(function()
    SaveManager:LoadAutoloadConfig()
end)
SaveManager:SetLoadingOrder(true, {"Dropdown", "Slider", "ColorPicker", "KeyPicker", "Input", "Toggle"})
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
    notyuri("ERROR: " .. tostring(err))
end