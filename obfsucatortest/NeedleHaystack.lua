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
local Support = {
    Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard = (typeof(setclipboard) == "function"),
    FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport = (typeof(queue_on_teleport) == "function" or typeof(queueonteleport) == "function"),
    Connections = (typeof(getconnections) == "function"),
    FPS = (typeof(setfpscap) == "function"),
    Proximity = (typeof(fireproximityprompt) == "function"),
    HookMeta = (typeof(hookmetamethod) == "function"),
    Firesignal = (typeof(firesignal) == "function"),
}
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
            local inviteCode = "6pCsSbVd3E"
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
local function LoadModuleAsync(parent, name, onLoaded)
    if not Support.FileIO then return end
    task.spawn(function()
        local obj = parent:FindFirstChild(name)
        local waited = 0
        while not obj and waited < 30 do
            obj = parent:WaitForChild(name, 1)
            waited = waited + 1
            if obj then break end
        end
        if not obj or not obj:IsA("ModuleScript") then return end
        local success, result = pcall(require, obj)
        if success and type(result) == "table" then
            pcall(onLoaded, result)
        end
    end)
end
local function GetSafeRemote(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
        return obj
    end
    return nil
end
local function FireRemote(remote, ...)
    if not remote then return false end
    local args = {...}
    local ok, err = pcall(function()
        remote:FireServer(unpack(args))
    end)
    if not ok then notyuri("FireRemote error:", tostring(remote), tostring(err)) end
    return ok
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
    local baseValues = config.Values or {}
    local values = { "All" }
    for _, v in ipairs(baseValues) do
        table.insert(values, v)
    end
    group:AddDropdown(id, {
        Text = config.Text,
        Values = values,
        Default = config.Default or {},
        Multi = true,
        Searchable = true,
        Callback = config.Callback,
    })
    local function getSelection()
        local labels = (Options[id] and Options[id].Value) or {}
        local ids = {}
        if labels["All"] then
            for _, label in ipairs(baseValues) do
                if labelId then
                    local mappedId = labelId[label]
                    if mappedId then ids[mappedId] = true end
                else
                    ids[label] = true
                end
            end
            return ids
        end
        for label, active in pairs(labels) do
            if active and label ~= "All" then
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
    local function refresh()
        local newValues = { "All" }
        for _, v in ipairs(baseValues) do
            table.insert(newValues, v)
        end
        if Options[id] then
            Options[id]:SetValues(newValues)
        end
    end
    return getSelection, refresh, baseValues
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
        local args = {...}
        for _, connection in ipairs(getconnections(signal)) do
            if connection.Fire then
                pcall(function() connection:Fire(unpack(args)) end)
            elseif connection.Function then
                task.spawn(connection.Function, unpack(args))
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
            currentTable[flagKey] = task.spawn(featureFunc, ...)
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
        Default = Config.DefaultToggle or false,
        Disabled = Config.Disabled,
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
local function GetNearest(list, filterFn)
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, inst in ipairs(list) do
        if not filterFn or filterFn(inst) then
            local part = inst:IsA("BasePart") and inst or (inst:IsA("Model") and inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart"))
            if part then
                local dist = (part.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = inst
                end
            end
        end
    end
    return best, bestDist
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
                task.wait(0.175)
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
        firetouchinterest(part, root, true)
        task.wait()
        firetouchinterest(part, root, false)
    end)
end
local function Serverhop()
    local hopSuccess, hopErr = pcall(function()
        local baseUrl = 'https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'
        local servers = {}
        local cursor = ''
        for _ = 1, 3 do
            local url = baseUrl
            if cursor ~= '' then url = url .. '&cursor=' .. cursor end
            local pages = game:HttpGet(url)
            local data = HttpService:JSONDecode(pages)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server)
                end
            end
            cursor = data.nextPageCursor
            if not cursor or cursor == '' then break end
        end
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        if #servers == 0 then
            Library:Notify("No servers found to hop to.", 3)
            return
        end
        local best = servers[1]
        for _, server in ipairs(servers) do
            if server.playing > 0 then
                best = server
                break
            end
        end
        TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, Plr)
    end)
    if not hopSuccess then
        Library:Notify("Serverhop failed: " .. tostring(hopErr), 5)
    end
end
local function QueueOnTeleportExec(code)
    if typeof(queue_on_teleport) == "function" then
        queue_on_teleport(code)
    elseif typeof(queueonteleport) == "function" then
        queueonteleport(code)
    end
end
local BridgeRemotes = nil
do
    local Packages = RS:WaitForChild("Packages", 15)
    local BridgeFolder = Packages and Packages:WaitForChild("Bridge", 10)
    BridgeRemotes = BridgeFolder and BridgeFolder:WaitForChild("Remotes", 15)
    if not BridgeRemotes then
        notyuri("ERROR: ReplicatedStorage.Packages.Bridge.Remotes never appeared")
    end
end
local NHS_REMOTE_NAMES = {
    "HayBridge", "UpgradeBridge", "BombBridge", "FlameBridge", "ProgressBridge", "QueueBridge",
}
Shared.ProgressState = {
    Diamonds = 0,
    Bombs = {},
    Unlocks = {},
}
local function ConnectBridgeEvents()
    SafeConnect("ProgressState", function()
        return Remotes.ProgressBridge and Remotes.ProgressBridge.OnClientEvent
    end, function(action, payload)
        if action ~= "state" or type(payload) ~= "table" then return end
        Shared.ProgressState = payload
        Shared.ProgressState.Bombs = payload.Bombs or {}
        Shared.ProgressState.Unlocks = payload.Unlocks or {}
    end)
    SafeConnect("HayRound", function()
        return Remotes.HayBridge and Remotes.HayBridge.OnClientEvent
    end, function(action)
        if action == "found" then
            
        end
    end)
end
task.spawn(function()
    if not BridgeRemotes then return end
    for _, remoteName in ipairs(NHS_REMOTE_NAMES) do
        if Library.Unloaded then return end
        local folder = BridgeRemotes:WaitForChild(remoteName, 1)
        local remote = folder and folder:WaitForChild("RemoteEvent", 1)
        if remote and remote:IsA("RemoteEvent") then
            Remotes[remoteName] = remote
        else
            notyuri("Remote missing:", remoteName)
        end
    end
    ConnectBridgeEvents()
    if Remotes.ProgressBridge then
        task.wait(1)
        FireRemote(Remotes.ProgressBridge, "sync")
    end
end)
local SettingsFolder = RS:FindFirstChild("GameSettings")
local DataFolder = SettingsFolder and SettingsFolder:FindFirstChild("Data")
if DataFolder then
    Modules.HayConfig = GetSafeModule(DataFolder, "HayConfig")
    Modules.UpgradeData = GetSafeModule(DataFolder, "UpgradeData")
    Modules.DifficultyData = GetSafeModule(DataFolder, "DifficultyData")
    Modules.BombData = GetSafeModule(DataFolder, "BombData")
    Modules.BuffData = GetSafeModule(DataFolder, "BuffData")
else
    notyuri("ERROR: ReplicatedStorage.GameSettings.Data never appeared")
end
local SharedRoot = RS:FindFirstChild("Shared")
if SharedRoot then
    Modules.HayField = GetSafeModule(SharedRoot, "HayField")
    if not Modules.HayField then
        LoadModuleAsync(SharedRoot, "HayField", function(module)
            if type(module) == "table" then Modules.HayField = module end
        end)
    end
else
    notyuri("ERROR: ReplicatedStorage.Shared never appeared")
end
local ServicesFolder = RS:FindFirstChild("ClientServices")
if ServicesFolder then
    Modules.HayClient = GetSafeModule(ServicesFolder, "HayClient")
    if not Modules.HayClient then
        LoadModuleAsync(ServicesFolder, "HayClient", function(module)
            if type(module) == "table" then Modules.HayClient = module end
        end)
    end
else
    notyuri("ERROR: ReplicatedStorage.ClientServices never appeared")
end
if SettingsFolder then
    Modules.GameSettings = GetSafeModule(RS, "GameSettings")
    if not Modules.GameSettings then
        LoadModuleAsync(RS, "GameSettings", function(module)
            if type(module) == "table" then Modules.GameSettings = module end
        end)
    end
end
local function GetHayState()
    local hc = Modules.HayClient
    if type(hc) == "table" then
        return hc.Field, hc.Taken
    end
    return nil, nil
end
local function GetPlayerAttr(name)
    local value = Plr:GetAttribute(name)
    if value ~= nil then return value end
    local ls = Plr:FindFirstChild("leaderstats")
    local stat = ls and ls:FindFirstChild(name)
    if stat and (stat:IsA("IntValue") or stat:IsA("NumberValue")) then
        return stat.Value
    end
    return nil
end
local function GetMoney()
    local ls = Plr:FindFirstChild("leaderstats")
    local money = ls and ls:FindFirstChild("Money")
    return tonumber(money and money.Value) or 0
end
local function GetDiamonds()
    return tonumber(GetPlayerAttr("Diamonds")) or (tonumber(Shared.ProgressState.Diamonds) or 0)
end
local function GetBuffLevel(name)
    local buffs = Shared.ProgressState.Buffs or {}
    return tonumber(buffs[name]) or 0
end
local function IsBagFull()
    if Plr:GetAttribute("HayInfinite") == true then return false end
    local carried = tonumber(Plr:GetAttribute("HayCarried")) or 0
    local capacity = tonumber(Plr:GetAttribute("HayCapacity")) or 0
    return capacity > 0 and carried >= capacity
end
local function GetMain()
    return workspace:FindFirstChild("Main")
end
local function FindNeedlePart()
    local main = GetMain()
    local needle = main and main:FindFirstChild("Needle")
    if needle and needle:IsA("BasePart") then
        return needle
    end
    return nil
end
local function GetUpgradeLevel(name)
    local gs = Modules.GameSettings
    local profile = gs and gs.ProfileTemplate
    local typed = profile and profile.TemplateTyped
    local client = typed and typed.client
    if not client then return nil end
    local upgrades = client.Upgrades
    if type(upgrades) ~= "table" then return nil end
    local value = upgrades[name]
    if type(value) ~= "table" then return nil end
    local ok, level = pcall(function() return value() end)
    if ok and type(level) == "number" then
        return math.floor(level)
    end
    return nil
end
local function GetSellThreshold()
    local pct = (Options.SellThreshold and Options.SellThreshold.Value) or 95
    if Plr:GetAttribute("HayInfinite") == true then
        return math.max(250, 250 * pct / 100)
    end
    local capacity = tonumber(Plr:GetAttribute("HayCapacity")) or 0
    return capacity * pct / 100
end
local function GetChunkOrder(field, position)
    local now = os.clock()
    local order = Shared.ChunkOrder
    if order and Shared.ChunkOrderPos and Shared.ChunkOrderTime
        and (Shared.ChunkOrderPos - position).Magnitude < 12
        and (now - Shared.ChunkOrderTime) < 4 then
        return order
    end
    local centers = {}
    local total = field.TotalChunks or 0
    for chunkId = 1, total do
        local ok, center = pcall(field.ChunkCenter, field, chunkId)
        if ok and center then
            centers[#centers + 1] = { chunkId, center }
        end
    end
    table.sort(centers, function(a, b)
        return (a[2] - position).Magnitude < (b[2] - position).Magnitude
    end)
    order = table.create(#centers)
    for i, entry in ipairs(centers) do
        order[i] = entry[1]
    end
    Shared.ChunkOrder = order
    Shared.ChunkOrderPos = position
    Shared.ChunkOrderTime = now
    return order
end
local function ChunkHasUntaken(field, taken, chunkId)
    local hf = Modules.HayField
    if not hf then return false end
    local base = field.ChunkBases and field.ChunkBases[chunkId]
    local count = field.ChunkCounts and field.ChunkCounts[chunkId]
    if not base or not count or count <= 0 then return false end
    for i = 0, count - 1 do
        if not hf.BitGet(taken, base + i) then
            return true
        end
    end
    return false
end
local function GetOpenChunkCenter(field, taken, position)
    local order = GetChunkOrder(field, position)
    local scanLimit = math.min(#order, 80)
    for i = 1, scanLimit do
        local chunkId = order[i]
        if ChunkHasUntaken(field, taken, chunkId) then
            local ok, center = pcall(field.ChunkCenter, field, chunkId)
            if ok and center then
                return center, chunkId
            end
        end
    end
    local center = field.Center
    if center then return center, nil end
    return nil, nil
end
local function GetBestBombTarget()
    local field, taken = GetHayState()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not (field and taken and hrp) then
        if field and field.Center then
            return field.Center + Vector3.new(0, field.Height or 10, 0)
        end
        return nil
    end
    local center = GetOpenChunkCenter(field, taken, hrp.Position)
    if center then
        return center + Vector3.new(0, 2, 0)
    end
    return field.Center + Vector3.new(0, field.Height or 10, 0)
end
local function Func_AutoDig()
    while true do
        if Remotes.HayBridge then
            local field, taken = GetHayState()
            if not (field and taken) then
            else
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hf = Modules.HayField
                if not hrp then
                elseif IsBagFull() then
                elseif not hf then
                else
                    local cfg = Modules.HayConfig or {}
                    local burst = tonumber(cfg.DigBurst) or 3
                    local maxReach = tonumber(cfg.MaxReach) or 45
                    local order = GetChunkOrder(field, hrp.Position)
                    local fired = 0
                    local openChunk = nil
                    local chunkLimit = math.min(#order, 25)
                    for i = 1, chunkLimit do
                        if fired >= burst then break end
                        local chunkId = order[i]
                        local base = field.ChunkBases and field.ChunkBases[chunkId]
                        local count = field.ChunkCounts and field.ChunkCounts[chunkId]
                        if base and count and count > 0 then
                            local hadOpen = false
                            local cursor = (Shared.DigCursor and Shared.DigCursor[chunkId] or 0) % count
                            for n = 0, count - 1 do
                                local offset = (cursor + n) % count
                                local pieceIndex = base + offset
                                if not hf.BitGet(taken, pieceIndex) then
                                    hadOpen = true
                                    local ok, cf = pcall(field.GetPieceCFrame, field, pieceIndex)
                                    if ok and cf and (cf.Position - hrp.Position).Magnitude <= maxReach then
                                        FireRemote(Remotes.HayBridge, pieceIndex)
                                        fired = fired + 1
                                        if not Shared.DigCursor then Shared.DigCursor = {} end
                                        Shared.DigCursor[chunkId] = offset + 1
                                        if fired >= burst then break end
                                    end
                                end
                            end
                            if hadOpen and not openChunk then
                                openChunk = chunkId
                            end
                        end
                    end
                    if fired == 0 then
                        local tpDig = Toggles.DigTP and Toggles.DigTP.Value
                        if tpDig and openChunk then
                            local ok, center = pcall(field.ChunkCenter, field, openChunk)
                            if ok and center then
                                hrp.CFrame = CFrame.new(center + Vector3.new(0, 6, 0))
                            end
                        elseif tpDig then
                            local center = GetOpenChunkCenter(field, taken, hrp.Position)
                            if center then
                                hrp.CFrame = CFrame.new(center + Vector3.new(0, 6, 0))
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoSell()
    while true do
        local carried = tonumber(Plr:GetAttribute("HayCarried")) or 0
        local threshold = GetSellThreshold()
        if carried >= math.max(1, threshold) and Remotes.HayBridge then
            local main = GetMain()
            local stand = main and main:FindFirstChild("SellStand")
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not stand then
            elseif not hrp then
            else
                FireRemote(Remotes.HayBridge, "sell")
            end
        end
        task.wait()
    end
end
local function Func_AutoUpgrades()
    while true do
        if Remotes.UpgradeBridge then
            local upgradeData = Modules.UpgradeData
            local diffData = Modules.DifficultyData
            if not (upgradeData and diffData and type(upgradeData.Order) == "table") then
            else
                local maxLevel = tonumber(upgradeData.MaxLevel) or 0
                local costMult = 1
                if type(diffData.CostMultiplier) == "function" then
                    local ok, res = pcall(diffData.CostMultiplier, workspace:GetAttribute("HayDifficulty"))
                    if ok and type(res) == "number" then costMult = res end
                end
                local money = GetMoney()
                local bought = false
                local missingLevel = false
                for _, upgradeName in ipairs(upgradeData.Order) do
                    if bought then break end
                    local level = GetUpgradeLevel(upgradeName)
                    if level == nil then
                        missingLevel = true
                        break
                    end
                    if level < maxLevel then
                        local price = nil
                        if type(upgradeData.GetPrice) == "function" then
                            local ok, res = pcall(upgradeData.GetPrice, upgradeName, level, costMult)
                            if ok then price = res end
                        end
                        if price and money >= price then
                            FireRemote(Remotes.UpgradeBridge, upgradeName)
                            bought = true
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoBuyBomb()
    while true do
        if Remotes.BombBridge then
            local bombData = Modules.BombData
            local target = (Options.BombTarget and Options.BombTarget.Value) or 2
            if not (bombData and type(bombData.ShopOrder) == "table" and type(bombData.List) == "table") then
            elseif target <= 0 then
            else
                local owned = Shared.ProgressState.Bombs or {}
                local diamonds = GetDiamonds()
                for _, bombId in ipairs(bombData.ShopOrder) do
                    local info = bombData.List[bombId]
                    if info and info.Currency == "Diamonds" then
                        local price = tonumber(info.Price) or 0
                        local have = tonumber(owned[bombId]) or 0
                        if have < target and price > 0 and diamonds >= price then
                            FireRemote(Remotes.BombBridge, "buy", bombId)
                            break
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoBomb()
    while true do
        local bombData = Modules.BombData
        local fuse = (bombData and tonumber(bombData.Fuse)) or 2
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (char and hum) then
        else
            local held = nil
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Tool") and child:GetAttribute("BombId") then
                    held = child
                    break
                end
            end
            if held then
                if Remotes.BombBridge then
                    local target = GetBestBombTarget()
                    if target then
                        FireRemote(Remotes.BombBridge, "aim", target)
                        task.wait(0.05)
                    end
                    pcall(function() held:Activate() end)
                end
                task.wait(fuse + 1)
            else
                local backpack = Plr:FindFirstChildOfClass("Backpack")
                local bombTool = nil
                for _, tool in ipairs((backpack and backpack:GetChildren()) or {}) do
                    if tool:IsA("Tool") and tool:GetAttribute("BombId") then
                        bombTool = tool
                        break
                    end
                end
                if bombTool then
                    pcall(function() hum:EquipTool(bombTool) end)
                end
            end
        end
        task.wait()
    end
end
local function FindFlamethrowerTool()
    local char = GetCharacter()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (char and hum) then return nil, nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("Flamethrower") then
            return child, hum
        end
    end
    local backpack = Plr:FindFirstChildOfClass("Backpack")
    for _, tool in ipairs((backpack and backpack:GetChildren()) or {}) do
        if tool:IsA("Tool") and tool:GetAttribute("Flamethrower") then
            return tool, hum
        end
    end
    return nil, hum
end
local function Func_AutoFlamethrower()
    local activated = false
    while true do
        local char = GetCharacter()
        if Remotes.FlameBridge then
            local tool, hum = FindFlamethrowerTool()
            if not tool then
                activated = false
            elseif not char or tool.Parent ~= char then
                pcall(function() hum:EquipTool(tool) end)
                task.wait(0.3)
            else
                if not activated then
                    pcall(function() tool:Activate() end)
                    activated = true
                end
                local field, taken = GetHayState()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local aim = nil
                if field and taken and hrp then
                    local ok, center = pcall(GetOpenChunkCenter, field, taken, hrp.Position)
                    if ok and center then
                        aim = center + Vector3.new(0, 2, 0)
                    end
                end
                if not aim and field and field.Center then
                    aim = field.Center + Vector3.new(0, (field.Height or 10) * 0.5, 0)
                end
                if not aim and hrp then
                    aim = hrp.Position + hrp.CFrame.LookVector * 10
                end
                if aim then
                    FireRemote(Remotes.FlameBridge, aim)
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoRewardPlate()
    while true do
        local field = GetHayState()
        local roundKey = (field and field.Seed) or 0
        if Shared.RewardPlateRound ~= roundKey then
            local main = GetMain()
            local plate = main and main:FindFirstChild("RewardPlate")
            local touched = false
            if plate then
                for _, descendant in ipairs(plate:GetDescendants()) do
                    if descendant:IsA("BasePart") and descendant:FindFirstChild("TouchInterest") then
                        FireTI(descendant)
                        touched = true
                        break
                    end
                end
            end
            if touched or not plate then
                Shared.RewardPlateRound = roundKey
            end
        end
        task.wait()
    end
end
local function Func_AutoNeedle()
    while true do
        local needle = FindNeedlePart()
        local fired = false
        if needle then
            local prompt = needle:FindFirstChild("NeedlePrompt") or needle:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt and prompt:IsA("ProximityPrompt") then
                if prompt.Enabled then
                    FirePP(prompt, true)
                    fired = true
                end
            else
                local detector = needle:FindFirstChildOfClass("ClickDetector")
                if detector then
                    FireCD(detector)
                    fired = true
                end
            end
        end
        task.wait(fired and 1 or 0.5)
    end
end
local function Func_NeedleESP()
    while true do
        local needle = FindNeedlePart()
        local highlight = Shared.NeedleHighlight
        if needle and not (highlight and highlight.Parent) then
            highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 48, 48)
            highlight.FillTransparency = 0.35
            highlight.OutlineColor = Color3.fromRGB(255, 90, 90)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = needle
            highlight.Parent = Plr:WaitForChild("PlayerGui")
            Shared.NeedleHighlight = highlight
        elseif highlight and highlight.Parent then
            highlight.Adornee = needle
        elseif highlight and not highlight.Parent then
            Shared.NeedleHighlight = nil
        end
        task.wait(0.5)
    end
end
local GetBuffSelection = nil
local function Func_AutoBuyBuff()
    while true do
        if Remotes.ProgressBridge then
            local buffData = Modules.BuffData
            if not (buffData and type(buffData.Order) == "table") then
            else
                local selection = GetBuffSelection and GetBuffSelection() or {}
                local diamonds = GetDiamonds()
                for _, buffName in ipairs(buffData.Order) do
                    if selection[buffName] then
                        local level = GetBuffLevel(buffName)
                        local price = buffData.GetPrice(buffName, level)
                        if price and diamonds >= price then
                            FireRemote(Remotes.ProgressBridge, "buyBuff", buffName)
                            break
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function FindEmptyLobbyPad()
    local lobby = workspace:FindFirstChild("Lobby")
    local pads = lobby and lobby:FindFirstChild("Pads")
    if not pads then return nil end
    for _, pad in ipairs(pads:GetChildren()) do
        local slots = pad:FindFirstChild("Fill") and pad.Fill:FindFirstChild("PadLabel") and pad.Fill.PadLabel:FindFirstChild("Slots")
        if slots and slots:IsA("TextLabel") and slots.Text:match("^0/") then
            return pad
        end
    end
    return nil
end
local function Func_AutoJoin()
    while true do
        if Remotes.QueueBridge then
            local difficulty = (Options.AutoJoinDifficulty and Options.AutoJoinDifficulty.Value) or "Easy"
            local pad = FindEmptyLobbyPad()
            if pad then
                TPTo(pad)
                task.wait(.2)
                FireRemote(Remotes.QueueBridge, "size", 1, difficulty)
                task.wait()
                FireRemote(Remotes.QueueBridge, "start")
            end
        end
        task.wait(1)
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
        T2 = TB.Main.Left.Autofarm:AddTab("Lobby"),
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
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 1000 })
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
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function() Serverhop() end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
TB_Tabs.Autofarm.T1:AddToggle("AutoDig", { Text = "Auto Dig Hay", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell Hay", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrades", { Text = "Auto Buy Upgrades", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyBomb", { Text = "Auto Buy Bomb", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBomb", { Text = "Auto Throw Bombs", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoFlamethrower", { Text = "Auto Flamethrower", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRewardPlate", { Text = "Auto Claim Reward Plate", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoNeedle", { Text = "Auto Take Needle", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("NeedleESP", { Text = "Needle ESP", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoBuyBuff", { Text = "Auto Buy Buff", Default = false })
GetBuffSelection = AddMultiDropdown(TB_Tabs.Autofarm.T2, "AutoBuyBuffList", {
    Text = "Buffs To Buy",
    Values = (Modules.BuffData and Modules.BuffData.Order) or { "Speed", "Coin", "Diamond" },
})
TB_Tabs.Autofarm.T2:AddToggle("AutoJoin", { Text = "Auto Join", Default = false })
TB_Tabs.Autofarm.T2:AddDropdown("AutoJoinDifficulty", {
    Text = "Difficulty",
    Values = (Modules.DifficultyData and Modules.DifficultyData.Order) or { "Easy", "Normal", "Hard" },
    Default = "Easy",
    Multi = false,
})
TB_Tabs.Autofarm2.T1:AddToggle("DigTP", { Text = "Dig TP", Default = true })
TB_Tabs.Autofarm2.T1:AddSlider("SellThreshold", {
    Text = "Sell Threshold",
    Default = 95,
    Min = 50,
    Max = 100,
    Compact = true,
    Rounding = 0,
})
TB_Tabs.Autofarm2.T1:AddSlider("BombTarget", {
    Text = "Bomb Target",
    Default = 2,
    Min = 0,
    Max = 10,
    Compact = true,
    Rounding = 0,
})
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
Toggles.AutoServerhop:OnChanged(function(state)
    Thread("AutoServerhop", function()
        local lastHop = tick()
        while Toggles.AutoServerhop.Value do
            task.wait(5)
            if not Toggles.AutoServerhop.Value then break end
            if (tick() - lastHop) >= (Options.AutoHopMins.Value * 60) then
                Serverhop()
                break
            end
        end
    end, state)
end)
Toggles.AutoDig:OnChanged(function(state)
    Thread("NeedleHaystack.AutoDig", Func_AutoDig, state)
end)
Toggles.AutoSell:OnChanged(function(state)
    Thread("NeedleHaystack.AutoSell", Func_AutoSell, state)
end)
Toggles.AutoUpgrades:OnChanged(function(state)
    Thread("NeedleHaystack.AutoUpgrades", Func_AutoUpgrades, state)
end)
Toggles.AutoBuyBomb:OnChanged(function(state)
    Thread("NeedleHaystack.AutoBuyBomb", Func_AutoBuyBomb, state)
end)
Toggles.AutoBuyBuff:OnChanged(function(state)
    Thread("NeedleHaystack.AutoBuyBuff", Func_AutoBuyBuff, state)
end)
Toggles.AutoJoin:OnChanged(function(state)
    Thread("NeedleHaystack.AutoJoin", Func_AutoJoin, state)
end)
Toggles.AutoBomb:OnChanged(function(state)
    Thread("NeedleHaystack.AutoBomb", Func_AutoBomb, state)
end)
Toggles.AutoFlamethrower:OnChanged(function(state)
    Thread("NeedleHaystack.AutoFlamethrower", Func_AutoFlamethrower, state)
    if not state then
        local char = GetCharacter()
        if char then
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Tool") and child:GetAttribute("Flamethrower") then
                    pcall(function() child:Deactivate() end)
                end
            end
        end
    end
end)
Toggles.AutoRewardPlate:OnChanged(function(state)
    Thread("NeedleHaystack.AutoRewardPlate", Func_AutoRewardPlate, state)
end)
Toggles.AutoNeedle:OnChanged(function(state)
    Thread("NeedleHaystack.AutoNeedle", Func_AutoNeedle, state)
end)
Toggles.NeedleESP:OnChanged(function(state)
    Thread("NeedleHaystack.NeedleESP", Func_NeedleESP, state)
    if not state and Shared.NeedleHighlight then
        pcall(function() Shared.NeedleHighlight:Destroy() end)
        Shared.NeedleHighlight = nil
    end
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
    if not v and Support.FPS then
        setfpscap(2000)
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
local antiAFKConn = nil
local function RunAntiAFK()
    if antiAFKConn then antiAFKConn:Enable() return end
    local GC = getconnections or get_signal_cons
    if GC then
        local conns = GC(Players.LocalPlayer.Idled)
        local target = conns and conns[1]
        if target and target.Disable then
            target:Disable()
            antiAFKConn = target
            return
        end
        for _, c in pairs(conns or {}) do
            if c.Disable then
                c:Disable()
                antiAFKConn = c
                return
            elseif c.Disconnect then
                c:Disconnect()
                return
            end
        end
    end
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
Toggles.AntiAFK:OnChanged(function(state)
    if state then
        RunAntiAFK()
    elseif antiAFKConn and antiAFKConn.Enable then
        antiAFKConn:Enable()
    end
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
    if Shared.NeedleHighlight then
        pcall(function() Shared.NeedleHighlight:Destroy() end)
        Shared.NeedleHighlight = nil
    end
    if antiAFKConn and antiAFKConn.Enable then pcall(function() antiAFKConn:Enable() end) end
    if Support.FPS then pcall(function() setfpscap(2000) end) end
    Cleanup(Connections)
    Cleanup(Flags)
        Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/NeedleHaystack")
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
