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
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Shared = {
}
local Tables = {
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local function AddMultiDropdown(group, id, config)
    config = config or {}
    local labelId = config.label
    group:AddDropdown(id, {
        Text = config.Text,
        Values = config.Values,
        Default = config.Default or {},
        Multi = true,
        Searchable = config.Searchable,
        Callback = config.Callback,
    })
    return function()
        local labels = (Options[id] and Options[id].Value) or {}
        local ids = {}
        for label, active in pairs(labels) do
            if active then
                if labelId then
                    local mappedId = labelId[label]
                    if mappedId then ids[mappedId] = true end
                else
                    ids[label] = true
                end
            end
        end
        return ids
    end
end
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
        warn("Your executor does not support firesignal or getconnections.")
    end
end
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
            warn("Error in ["..name.."]: "..tostring(err))
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
local function TPTo(target, offset)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local cframe
    if typeof(target) == "CFrame" then
        cframe = target
    elseif typeof(target) == "Vector3" then
        cframe = CFrame.new(target)
    elseif typeof(target) == "Instance" then
        if target:IsA("BasePart") then
            cframe = target.CFrame
        elseif target:IsA("Model") then
            cframe = target:GetPivot()
        end
    end
    if not cframe then return false end
    if offset then
        cframe = cframe * CFrame.new(offset)
    end
    hrp.CFrame = cframe
    return true
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
local function GetEndZ()
    local ok, FlowClient = pcall(require, RS.FlowClient)
    if not ok or not FlowClient or not FlowClient.DistanceToBorderClient then
        return nil
    end
    local fn = FlowClient.DistanceToBorderClient.SetEndPos_event
    if type(fn) ~= "function" then
        return nil
    end
    local endZ = debug.getupvalue(fn, 1)
    if type(endZ) == "number" then
        return endZ
    end
    return nil
end
local function GetVehicleChassis()
    local char = GetCharacter()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seatPart = hum and hum.SeatPart
    if seatPart and seatPart:IsA("VehicleSeat") then
        local model = seatPart:FindFirstAncestorOfClass("Model")
        local chassis = model and model:FindFirstChild("system") and model.system:FindFirstChild("chassis")
        if chassis and chassis:IsA("BasePart") then
            return chassis
        end
    end
    return nil
end
local function GetMainVehicle()
    local model = Services.CollectionService:GetTagged("MainVehicle")[1]
    if not model then
        return nil, nil
    end
    local chassis = model:FindFirstChild("system") and model.system:FindFirstChild("chassis")
    return model, chassis
end
local function CarPrompt(model)
    if not model then return nil end
    return GetObject(model, "system.seats.VehicleSeat.PromptLocation.EnterVehicleProximityPrompt")
end
local function GetCustomsFinalPrompt()
    return GetObject(workspace, "Map.Buildings.CustomsFinal.CustomsBuilding.FinalDoor.Command.CommandButton.Prompt.ProximityPrompt")
end
local function GetCustomsFinalTimerPart()
    return GetObject(workspace, "Map.Buildings.CustomsFinal.CustomsBuilding.FinalDoor.Timer")
end
local function GetLootRemote()
    return GetObject(RS, "FlowClient.ClientRunner.Function")
end
local function IsAttachableLoot(item)
    return item:HasTag("Draggable") and not item:HasTag("Equippable")
end
local function IsEquippableLoot(item)
    return item:HasTag("Equippable")
end
local function GetNearestLoot(filterFn)
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local lootFolder = GetObject(workspace, "Loot")
    if not root or not lootFolder then
        return nil
    end
    local minRange = tonumber(Options.AutoStealMinRange and Options.AutoStealMinRange.Value) or 0
    local maxRange = tonumber(Options.AutoStealMaxRange and Options.AutoStealMaxRange.Value) or math.huge
    local nearest, nearestDist = nil, math.huge
    for _, item in ipairs(lootFolder:GetChildren()) do
        if not filterFn or filterFn(item) then
            local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
            if part then
                local dist = (part.Position - root.Position).Magnitude
                if dist >= minRange and dist <= maxRange and dist < nearestDist then
                    nearest, nearestDist = part, dist
                end
            end
        end
    end
    return nearest
end
local function BringLoot(part, pos, isAttachable, maxAttempts)
    local ok, FlowClient = pcall(require, RS.FlowClient)
    if not ok or not FlowClient or not FlowClient.Loot then
        return false
    end
    local requestOwn = FlowClient.Loot.OwnNetworkRequestAsync
    local releaseOwn = FlowClient.Loot.OwnNetworkRequest
    local weldAttach = FlowClient.Loot.WeldAttach
    local weldDetach = FlowClient.Loot.WeldDetach
    if type(requestOwn) ~= "function" or type(releaseOwn) ~= "function" then
        return false
    end
    local dropCFrame = typeof(pos) == "CFrame" and pos or CFrame.new(pos)
    local owned = false
    if isAttachable then
        pcall(requestOwn, part, true)
        owned = true
    else
        local attempts = maxAttempts or 3
        for attempt = 1, attempts do
            if not owned then
                TPTo(part)
                task.wait(.1)
                local callOk, result = pcall(requestOwn, part, true)
                owned = callOk and result
                notyuri("[BringLoot] attempt " .. attempt .. "/" .. attempts .. " part=" .. part:GetFullName() .. " callOk=" .. tostring(callOk) .. " result=" .. tostring(result) .. " owned=" .. tostring(owned))
            end
            if owned then
                break
            end
        end
    end
    if not owned then
        return false
    end
    part.CFrame = dropCFrame
    if type(weldDetach) == "function" then
        pcall(weldDetach, part)
    end
    if type(weldAttach) == "function" then
        pcall(weldAttach, part, {}, dropCFrame)
    end
    pcall(releaseOwn, part, nil)
    return true
end
local function FuncAutoBring()
    while Toggles.AutoBring.Value do
        RunService.Heartbeat:Wait()
        local char = GetCharacter()
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local lootFolder = GetObject(workspace, "Loot")
        if not root then
            notyuri("[AutoBring] No character found.")
        elseif not lootFolder then
            notyuri("[AutoBring] Loot folder not found.")
        else
            local minRange = tonumber(Options.AutoBringMinRange and Options.AutoBringMinRange.Value) or 0
            local maxRange = tonumber(Options.AutoBringMaxRange and Options.AutoBringMaxRange.Value) or math.huge
            local dropCFrame = root.CFrame
            for _, item in ipairs(lootFolder:GetChildren()) do
                if IsAttachableLoot(item) then
                    local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
                    if part then
                        local dist = (part.Position - root.Position).Magnitude
                        if dist >= minRange and dist <= maxRange then
                            if not BringLoot(part, dropCFrame, true) then
                                notyuri("[AutoBring] Failed to own " .. item.Name)
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function GetBackpackSlotLimit(player)
    local ok, Balance = pcall(require, RS.Data.Balance)
    if not ok or not Balance then
        notyuri("[AutoSteal] Failed to require Data.Balance for slot limit.")
        return math.huge
    end
    local backpackCapacities = {
        BackpackSmall = Balance.MaxToolsSmallBackpack,
        BackpackMedium = Balance.MaxToolsMediumBackpack,
        BackpackLarge = Balance.MaxToolsLargeBackpack,
    }
    local best = Balance.MaxTools
    local function scan(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then
                local cap = backpackCapacities[child.Name]
                if cap and cap > best then
                    best = cap
                end
            end
        end
    end
    scan(player.Backpack)
    scan(player.Character)
    return best
end
local function IsInventoryFull()
    local count = #Plr.Backpack:GetChildren()
    if Plr.Character and Plr.Character:FindFirstChildOfClass("Tool") then
        count = count + 1
    end
    return count >= GetBackpackSlotLimit(Plr)
end
local function FuncAutoSteal()
    while Toggles.AutoSteal.Value do
        RunService.Heartbeat:Wait()
        if IsInventoryFull() then
            task.wait(1)
        else
            local Event = GetLootRemote()
            local part = GetNearestLoot(IsEquippableLoot)
            if Event and part then
                TPTo(part)
                task.wait(.1)
                pcall(function()
                    Event:InvokeServer("Loot", "LootEquip", part)
                end)
            end
            task.wait()
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
                task.wait(0.5)
            end
        end
    end
    fireproximityprompt(target)
end
local function FuncTeleportToCar()
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    local model, chassis = GetMainVehicle()
    if not chassis then
        return
    end
    local prompt = CarPrompt(model)
    if prompt then
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        while hum and not hum.Sit do
            FirePP(prompt, true)
            task.wait()
        end
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            repeat
                task.wait()
            until not hum.Sit
        end
        task.wait(2)
        while hum and not hum.Sit do
            FirePP(prompt, true)
            task.wait()
        end
    end
end
local function TPPawnShop()
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        notyuri("[TeleportToPawnShop] No character found.")
        return
    end
    local buildingsFolder = GetObject(workspace, "Map.Buildings")
    if not buildingsFolder then
        notyuri("[TeleportToPawnShop] Map.Buildings folder not found.")
        return
    end
    local nearest, nearestDist = nil, math.huge
    for _, model in ipairs(buildingsFolder:GetChildren()) do
        if model.Name == "PawnShop" and model:IsA("Model") then
            local ok, pivot = pcall(model.GetPivot, model)
            if ok then
                local dist = (root.Position - pivot.Position).Magnitude
                if dist < nearestDist then
                    nearest, nearestDist = pivot, dist
                end
            end
        end
    end
    if not nearest then
        notyuri("[TeleportToPawnShop] No PawnShop found.")
        return
    end
    root.CFrame = nearest * CFrame.new(0, 5, 0)
end
local function GetPlayerMoney()
    local leaderstats = Plr:FindFirstChild("leaderstats")
    local cash = leaderstats and leaderstats:FindFirstChild("Cash \240\159\146\181")
    return cash and cash.Value or nil
end
local function GetPawnShopStations()
    local buildingsFolder = GetObject(workspace, "Map.Buildings")
    if not buildingsFolder then
        notyuri("[AutoSell] Map.Buildings folder not found.")
        return {}
    end
    local endZ = GetEndZ()
    local stations = {}
    for _, model in ipairs(buildingsFolder:GetChildren()) do
        if model.Name == "PawnShop" and model:IsA("Model") then
            local ok, pivot = pcall(model.GetPivot, model)
            if ok then
                table.insert(stations, {
                    Model = model,
                    Z = pivot.Position.Z,
                })
            end
        end
    end
    if endZ then
        table.sort(stations, function(a, b)
            return math.abs(a.Z - endZ) > math.abs(b.Z - endZ)
        end)
    else
        notyuri("[AutoSell] Could not resolve end Z from server data, station order may be wrong.")
    end
    return stations
end
local function ResolveStationParts(station, timeout)
    local counter = GetObject(station.Model, "Templates.Template1.PawnCounter")
    local volume = counter and counter:FindFirstChild("Volume")
    local callBell = counter and GetObject(counter, "CallBell.Attachment.ProximityPrompt")
    local waited = 0
    local step = 0.25
    while (not volume or not callBell) and waited < (timeout or 5) do
        task.wait(step)
        waited = waited + step
        counter = GetObject(station.Model, "Templates.Template1.PawnCounter")
        volume = counter and counter:FindFirstChild("Volume")
        callBell = counter and GetObject(counter, "CallBell.Attachment.ProximityPrompt")
    end
    if not volume or not callBell then
        notyuri("[AutoSell] PawnCounter did not stream in for station " .. tostring(station.Model:GetAttribute("BuildingId")))
        return nil, nil
    end
    return volume, callBell
end
local function IsSellStopMoneyReached()
    local threshold = tonumber(Options.SellStopAt and Options.SellStopAt.Value)
    if not threshold or threshold <= 0 then
        return false
    end
    local money = GetPlayerMoney()
    return money ~= nil and money >= threshold
end
local function BringToStation(volume, batchSize)
    local dropCFrame = volume.CFrame
    local lootFolder = GetObject(workspace, "Loot")
    if not lootFolder then return 0 end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local brought = 0
    for _, item in ipairs(lootFolder:GetChildren()) do
        if not Toggles.AutoSell.Value or brought >= batchSize then break end
        local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
        if part then
            local dist = hrp and (part.Position - hrp.Position).Magnitude or 0
            local isAttachable = IsAttachableLoot(item)
            local eligible = isAttachable or (hrp and dist <= 40)
            if eligible then
                if not hrp or dist <= 2000 then
                    if BringLoot(part, dropCFrame, isAttachable) then
                        brought = brought + 1
                    else
                        notyuri("[AutoSell] Failed to own " .. item.Name)
                    end
                end
            end
        end
    end
    return brought
end
local function BringAttachableLoop(volume, callBell)
    repeat
        local brought = BringToStation(volume, 15)
        if Toggles.AutoSell.Value and brought > 0 then
            task.spawn(function()
                FirePP(callBell, true)
            end)
            task.wait(0.5)
        end
    until not Toggles.AutoSell.Value or brought == 0 or not GetObject(workspace, "Loot") or #GetObject(workspace, "Loot"):GetChildren() == 0
end
local function BringNonAttachableLoop(volume, callBell)
    local broughtAny = false
    while Toggles.AutoSell.Value do
        local part = GetNearestLoot(function(item)
            return IsEquippableLoot(item) and not IsAttachableLoot(item)
        end)
        if not part then
            break
        end
        TPTo(part)
        task.wait(.1)
        if BringLoot(part, volume.CFrame, false) then
            broughtAny = true
        else
            notyuri("[AutoSell] Failed to own " .. tostring(part.Parent and part.Parent.Name or part.Name))
        end
        task.wait()
    end
    if broughtAny and Toggles.AutoSell.Value then
        task.spawn(function()
            FirePP(callBell, true)
        end)
        task.wait(0.5)
    end
end
local function RunSellLoop(volume, callBell)
    local t1 = task.spawn(BringAttachableLoop, volume, callBell)
    local t2 = task.spawn(BringNonAttachableLoop, volume, callBell)
    while (coroutine.status(t1) ~= "dead" or coroutine.status(t2) ~= "dead") and Toggles.AutoSell.Value do
        task.wait()
    end
    if coroutine.status(t1) ~= "dead" then task.cancel(t1) end
    if coroutine.status(t2) ~= "dead" then task.cancel(t2) end
end
local AutoSellActive = true
local function FuncAutoSell()
    while Toggles.AutoSell.Value do
        if IsSellStopMoneyReached() then
            notyuri("[AutoSell] Money threshold reached, stopping.")
            AutoSellActive = false
            return
        end
        local stations = GetPawnShopStations()
        if #stations == 0 then
            notyuri("[AutoSell] No PawnShop stations found.")
            task.wait(2)
        else
            local emptyStreak = 0
            for i, station in ipairs(stations) do
                if not Toggles.AutoSell.Value or IsSellStopMoneyReached() then break end
                local isLastStation = (i == #stations)
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = station.Model:GetPivot() * CFrame.new(0, 5, 0)
                end
                local lootFolderAtStation = GetObject(workspace, "Loot")
                local hasItemAtStation = false
                if lootFolderAtStation and hrp then
                    for _, item in ipairs(lootFolderAtStation:GetChildren()) do
                        local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
                        if part and (part.Position - hrp.Position).Magnitude <= 2000 then
                            hasItemAtStation = true
                            break
                        end
                    end
                end
                if hasItemAtStation then
                    emptyStreak = 0
                else
                    emptyStreak = emptyStreak + 1
                end
                local volume, callBell = ResolveStationParts(station)
                if volume and callBell then
                    local lootFolder = GetObject(workspace, "Loot")
                    local hasItem = lootFolder and #lootFolder:GetChildren() > 0
                    local hasHeldTool = Plr.Character and Plr.Character:FindFirstChildOfClass("Tool")
                    if hasItem or hasHeldTool or isLastStation then
                        RunSellLoop(volume, callBell)
                    else
                        notyuri("[AutoSell] No item at station " .. tostring(station.Model:GetAttribute("BuildingId")) .. ", moving to next station.")
                    end
                end
                if IsSellStopMoneyReached() then
                    notyuri("[AutoSell] Money threshold reached, stopping.")
                    AutoSellActive = false
                    return
                end
                if emptyStreak > 7 then
                    notyuri("[AutoSell] Nothing left to sell after " .. emptyStreak .. " empty stations, stopping.")
                    AutoSellActive = false
                    return
                end
                if isLastStation then
                    task.wait(2)
                else
                    task.wait(.1)
                end
            end
        end
        task.wait(2)
    end
    AutoSellActive = true
end
local function GetGroundY(position, ignoreList)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList
    local origin = Vector3.new(position.X, position.Y + 1000, position.Z)
    local result = workspace:Raycast(origin, Vector3.new(0, -10000, 0), params)
    if result then
        return result.Position.Y + 50
    end
    return nil
end
local function FuncAutoDrive()
    local endFrame = GetObject(Plr, "PlayerGui.EndFrame")
    if endFrame and endFrame.Enabled then return end
    FuncTeleportToCar()
    local chassis = GetVehicleChassis()
    if not chassis then
        notyuri("[AutoDrive] Not seated in a vehicle.")
        return
    end

    local endZ = GetEndZ()
    if not endZ then
        notyuri("[AutoDrive] Could not resolve end Z from server data.")
        return
    end
    while true do
        local chassis = GetVehicleChassis()
        if not chassis then
            notyuri("[AutoDrive] Lost vehicle, stopping.")
            return
        end
        local currentZ = chassis.Position.Z
        local dir = (endZ - currentZ) >= 0 and 1 or -1
        if math.abs(endZ - currentZ) <= 490 then
            chassis.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            chassis.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            chassis.Anchored = true
            local char = GetCharacter()
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                repeat
                    task.wait()
                until not hum.Sit
            end
            return
        end
        local step = 500 * dir
        local wasAnchored = chassis.Anchored
        chassis.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        chassis.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        chassis.Anchored = true
        local newCFrame = chassis.CFrame + Vector3.new(0, 0, step)
        local pos = newCFrame.Position
        local carModel = chassis:FindFirstAncestorOfClass("Model") or chassis
        local groundY = GetGroundY(pos, {carModel})
        local finalY = groundY or pos.Y
        chassis.CFrame = newCFrame - pos + Vector3.new(pos.X, finalY, pos.Z)
        task.wait()
        chassis.Anchored = wasAnchored
        RunService.Heartbeat:Wait()
    end
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
local function FuncKillAura()
    while Toggles.KillAura.Value do
        RunService.Heartbeat:Wait()
        local char = GetCharacter()
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local npcFolder = GetObject(workspace, "NPCs")
        if root and npcFolder then
            local range = tonumber(Options.KillAuraRange and Options.KillAuraRange.Value) or math.huge
            local Event = GetObject(RS, "FlowClient.ClientRunner.Event")
            for _, model in ipairs(npcFolder:GetChildren()) do
                if model:IsA("Model") then
                    local Humanoid = model:FindFirstChildOfClass("Humanoid")
                    local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                    if Humanoid and Humanoid.Health > 0 and part and Event then
                        local dist = (part.Position - root.Position).Magnitude
                        if dist <= range then
                            pcall(function()
                                Event:FireServer("NPCs", "Damage", Humanoid, 100)
                            end)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
local function RunAutoEndStep()
    local prompt = GetCustomsFinalPrompt()
    if not prompt then return end
    local part = prompt.Parent
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if prompt.Enabled then
        FirePP(prompt, true)
    else
        if hrp and part and part:IsA("BasePart") then
            hrp.CFrame = part.CFrame * CFrame.new(-9, -1, 6)
            Toggles.Noclip:SetValue(true)
        end
    end
    local timerLabel = GetObject(workspace, "Map.Buildings.CustomsFinal.CustomsBuilding.FinalDoor.Timer.SurfaceGui.Timer.Time")
    if timerLabel and timerLabel.Text == "" then
        local timerPart = GetCustomsFinalTimerPart()
        if hrp and timerPart then
            hrp.CFrame = timerPart.CFrame * CFrame.new(0, 0, 100)
            notyuri("[AutoEnd] Timer text empty, teleporting through door.")
        end
    end
end
local function RunAutoRetryStep()
    local endFrame = GetObject(Plr, "PlayerGui.EndFrame")
    if endFrame and endFrame.Enabled then
        local Event = GetObject(RS, "FlowClient.ClientRunner.Event")
        if Event then
            pcall(function()
                Event:FireServer("GameManager", "Replay")
            end)
            notyuri("[AutoRetry] Result screen shown, firing Replay.")
        end
        return true
    end
    local bleedoutGui = GetObject(Plr, "PlayerGui.BleedoutGui")
    if bleedoutGui and bleedoutGui.Enabled then
        local ok, FlowClient = pcall(require, RS.FlowClient)
        if ok and FlowClient and FlowClient.Passout and type(FlowClient.Passout.Abandon) == "function" then
            pcall(FlowClient.Passout.Abandon)
            notyuri("[AutoRetry] Bleeding out, giving up.")
        end
        return true
    end
    return false
end
local function FuncAutoRetry()
    while Toggles.AutoRetry.Value do
        RunAutoRetryStep()
        task.wait(0.5)
    end
end
local function FuncAutoFinish()
    while Toggles.AutoFinish.Value do
        if Toggles.AutoSell.Value and AutoSellActive then
            notyuri("[AutoFinish] Waiting for AutoSell to finish.")
            task.wait(0.5)
        else
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local endZ = GetEndZ()
            if hrp and endZ then
                Toggles.Noclip:SetValue(true)
                local pos = hrp.Position
                local targetPos = Vector3.new(pos.X, pos.Y, endZ)
                local groundY = GetGroundY(targetPos, {char})
                local finalY = groundY or pos.Y
                hrp.CFrame = CFrame.new(Vector3.new(pos.X, finalY, endZ))
                notyuri("[AutoFinish] Teleported straight to end.")
            else
                notyuri("[AutoFinish] Could not resolve character or end Z.")
            end
            RunAutoEndStep()
            task.wait(0.5)
        end
    end
end
local ESPFolder = Instance.new("Folder")
ESPFolder.Parent = Services.CoreGui
local AllHighlights = {
    Loot = {},
    NPC = {},
    Vehicle = {},
}
local function getPartForAdornee(target)
    if target:IsA("BasePart") then
        return target
    elseif target:IsA("Model") then
        return target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart", true)
    end
    return nil
end
local function makeLabel(text, sizeY, posY, bold, textColor)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, sizeY, 0)
    lbl.Position = UDim2.new(0, 0, posY, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = textColor or Color3.new(1, 1, 1)
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.TextStrokeTransparency = 0.4
    lbl.TextScaled = true
    lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    return lbl
end
local ESPPool = {
    Free = {},
    Active = {},
}
local function ESPAcq(fillColor, outlineColor, labelName, textColor)
    local entry = table.remove(ESPPool.Free)
    if not entry then
        local h = Instance.new("Highlight")
        h.FillTransparency = 0.4
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 70, 0, 20)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.ResetOnSpawn = false
        local nameLbl = makeLabel("", 0.55, 0, true, Color3.new(1, 1, 1))
        nameLbl.Parent = bb
        local distLbl = makeLabel("", 0.45, 0.55, false, Color3.new(1, 1, 1))
        distLbl.Parent = bb
        entry = { highlight = h, billboard = bb, nameLbl = nameLbl, distLbl = distLbl }
    end
    entry.highlight.FillColor = fillColor
    entry.highlight.OutlineColor = outlineColor
    entry.highlight.Parent = ESPFolder
    entry.nameLbl.Text = labelName
    entry.nameLbl.TextColor3 = textColor or Color3.new(1, 1, 1)
    entry.distLbl.TextColor3 = textColor or Color3.new(1, 1, 1)
    entry.billboard.Parent = ESPFolder
    ESPPool.Active[entry] = true
    return entry
end
local function ESPRelease(entry)
    if not entry or not ESPPool.Active[entry] then return end
    ESPPool.Active[entry] = nil
    entry.highlight.Adornee = nil
    entry.highlight.Parent = nil
    entry.billboard.Adornee = nil
    entry.billboard.Parent = nil
    table.insert(ESPPool.Free, entry)
end
local function makeHighlight(target, fillColor, outlineColor, labelName, textColor)
    local part = getPartForAdornee(target)
    if not part then return nil end
    local entry = ESPAcq(fillColor, outlineColor, labelName, textColor)
    entry.highlight.Adornee = target
    entry.billboard.Adornee = part
    entry.part = part
    return entry
end
local function removeHighlight(tbl, key)
    if tbl[key] then
        ESPRelease(tbl[key])
        tbl[key] = nil
    end
end
local function GetESPLoot()
    local list = {}
    local lootFolder = GetObject(workspace, "Loot")
    if not lootFolder then return list end
    for _, item in ipairs(lootFolder:GetChildren()) do
        local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
        if part then
            list[part] = item.Name
        end
    end
    return list
end
local function GetESPNPCs()
    local list = {}
    local npcFolder = GetObject(workspace, "NPCs")
    if not npcFolder then return list end
    for _, model in ipairs(npcFolder:GetChildren()) do
        if model:IsA("Model") then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                list[model] = model.Name
            end
        end
    end
    return list
end
local function GetESPVehicles()
    local list = {}
    local vehiclesFolder = GetObject(workspace, "Vehicles")
    if vehiclesFolder then
        for _, model in ipairs(vehiclesFolder:GetChildren()) do
            if model:IsA("Model") then
                list[model] = model.Name
            end
        end
    end
    local heli = workspace:FindFirstChild("Helicopter")
    if heli and heli:IsA("Model") then
        list[heli] = heli.Name
    end
    return list
end
local function RefreshESPGroup(cfg)
    local tbl = AllHighlights[cfg.Id]
    if not Toggles[cfg.Id].Value then
        for k in pairs(tbl) do removeHighlight(tbl, k) end
        return
    end
    local fillColor = Options[cfg.Id .. "Color"].Value
    local outlineColor = Options[cfg.Id .. "Outline"].Value
    local range = tonumber(Options[cfg.Id .. "Range"] and Options[cfg.Id .. "Range"].Value) or math.huge
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local current = cfg.Get()
    if hrp and range < math.huge then
        local origin = hrp.Position
        for key in pairs(current) do
            local part = getPartForAdornee(key)
            if not part or (part.Position - origin).Magnitude > range then
                current[key] = nil
            end
        end
    end
    for key in pairs(tbl) do
        if not current[key] or not key.Parent then
            removeHighlight(tbl, key)
        end
    end
    for key, label in pairs(current) do
        if not tbl[key] then
            tbl[key] = makeHighlight(key, fillColor, outlineColor, label, fillColor)
        end
    end
end
local ESPTargetConfig = {
    { Id = "Loot", Get = GetESPLoot, Color = Color3.fromRGB(80, 200, 255) },
    { Id = "NPC", Get = GetESPNPCs, Color = Color3.fromRGB(255, 60, 60) },
    { Id = "Vehicle", Get = GetESPVehicles, Color = Color3.fromRGB(80, 255, 120) },
}
local function FuncESP()
    while true do
        RunService.Heartbeat:Wait()
        for _, cfg in ipairs(ESPTargetConfig) do
            if Toggles[cfg.Id].Value then
                RefreshESPGroup(cfg)
            end
        end
        task.wait(0.3)
    end
end
local function FuncESPDistance()
    while true do
        RunService.Heartbeat:Wait()
        local char = GetCharacter()
        local hrp = char and char.HumanoidRootPart
        if hrp then
            local origin = hrp.Position
            for entry in pairs(ESPPool.Active) do
                if entry.part then
                    local dist = math.floor((entry.part.Position - origin).Magnitude)
                    entry.distLbl.Text = dist .. " studs"
                end
            end
        end
    end
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
    ESP = Window:AddTab("ESP"),
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
local ESPGroupLeft = Tabs.ESP:AddLeftGroupbox("ESP")
local ESPGroupRight = Tabs.ESP:AddRightGroupbox("ESP2")
local ESPGroupSides = { ESPGroupLeft, ESPGroupRight }
for i, cfg in ipairs(ESPTargetConfig) do
    local grp = ESPGroupSides[((i - 1) % 2) + 1]
    grp:AddToggle(cfg.Id, { Text = cfg.Id, Default = false })
    grp:AddSlider(cfg.Id .. "Range", { Text = "Range", Default = 2000, Min = 0, Max = 5000, Rounding = 0 })
    grp:AddLabel("Fill Color"):AddColorPicker(cfg.Id .. "Color", {
        Title = cfg.Id .. " Fill",
        Default = cfg.Color,
    })
    grp:AddLabel("Outline Color"):AddColorPicker(cfg.Id .. "Outline", {
        Title = cfg.Id .. " Outline",
        Default = Color3.fromRGB(0, 0, 0),
    })
    Toggles[cfg.Id]:OnChanged(function()
        RefreshESPGroup(cfg)
    end)
end
TB_Tabs.Autofarm.T1:AddToggle("AutoFinish", { Text = "Auto Finish" })
TB_Tabs.Autofarm.T1:AddToggle("AutoRetry", { Text = "Auto Retry" })
TB_Tabs.Autofarm.T1:AddToggle("AutoSteal", { Text = "Auto Steal" })
TB_Tabs.Autofarm.T1:AddToggle("AutoBring", { Text = "Auto Bring" })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell" })
TB_Tabs.Autofarm.T1:AddToggle("KillAura", { Text = "Kill Aura" })
TB_Tabs.Autofarm2.T1:AddSlider("KillAuraRange", { Text = "Kill Range", Default = 1000, Min = 0, Max = 5000, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("AutoStealMinRange", { Text = "Steal Min Range", Default = 100, Min = 0, Max = 5000, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("AutoStealMaxRange", { Text = "Steal Max Range", Default = 1000, Min = 0, Max = 5000, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("AutoBringMinRange", { Text = "Bring Min Range", Default = 100, Min = 0, Max = 5000, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("AutoBringMaxRange", { Text = "Bring Max Range", Default = 1000, Min = 0, Max = 5000, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("SellStopAt", { Text = "Sell Stop At", Default = 0, Min = 0, Max = 1000000, Rounding = 0 })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Teleport To Car", Func = FuncTeleportToCar })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Teleport Pawn Shop", Func = TPPawnShop })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Move To End", Func = function()
    Thread("AutoDrive", FuncAutoDrive, true)
end })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 500 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 30, Rounding = 1 })
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
Toggles.AutoSteal:OnChanged(function(v)
    Thread("AutoSteal", FuncAutoSteal, v)
end)
Toggles.AutoBring:OnChanged(function(v)
    Thread("AutoBring", FuncAutoBring, v)
end)
Toggles.AutoSell:OnChanged(function(v)
    Thread("AutoSell", FuncAutoSell, v)
end)
Toggles.KillAura:OnChanged(function(v)
    Thread("KillAura", FuncKillAura, v)
end)
Toggles.AutoFinish:OnChanged(function(v)
    Thread("AutoFinish", FuncAutoFinish, v)
end)
Toggles.AutoRetry:OnChanged(function(v)
    Thread("AutoRetry", FuncAutoRetry, v)
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
task.spawn(SafeLoop("ESP", FuncESP))
task.spawn(SafeLoop("ESPDistance", FuncESPDistance))
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
    ESPFolder:Destroy()
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/RUNAWAYS")
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