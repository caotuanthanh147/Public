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
local RemoteEvents = RS:FindFirstChild("Events") and RS.Events:FindFirstChild("RemoteEvents") or nil
local function GetRE(name)
    if not RemoteEvents then return nil end
    return RemoteEvents:FindFirstChild(name) or RemoteEvents:WaitForChild(name, 10)
end
local MapEvents = RS:FindFirstChild("Events") and RS.Events:FindFirstChild("Map") or nil
local function GetMapRE(name)
    if not MapEvents then return nil end
    return MapEvents:FindFirstChild(name) or MapEvents:WaitForChild(name, 10)
end
local Remotes = {
    HitDestructible = GetRE("HitDestructible"),
    HammerCharge = GetRE("HammerCharge"),
    CollectRubbleCash = GetRE("CollectRubbleCash"),
    PurchaseUpgrade = GetRE("PurchaseUpgrade"),
    Stage95AutoDemolitionRequest = GetRE("Stage95AutoDemolitionRequest"),
    SetSprinting = GetRE("SetSprinting"),
    LobbyRequest = GetRE("LobbyRequest"),
    Stage7Action = GetMapRE("Stage7Action"),
}
local Modules = {
    UpgradeConfig = GetSafeModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Shared"), "UpgradeConfig"),
    DestructibleUtility = GetSafeModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Shared"), "DestructibleUtility"),
    HammerConfig = GetSafeModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Client") and RS.Modules.Client:FindFirstChild("Viewmodel"), "HammerConfig"),
    LobbyConfig = GetSafeModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Shared"), "LobbyConfig"),
}
local Flags = {}
local Shared = {
}
local Tables = {
    UpgradeList = {},
    UpgradeMap = {},
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
        Searchable = true,
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
        notyuri("Your executor does not support firesignal or getconnections.")
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
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end)
end
local function FireRemote(remote, ...)
    if not remote then return end
    local args = {...}
    pcall(function()
        remote:FireServer(unpack(args))
    end)
end
local function GetActiveMap()
    return workspace:FindFirstChild("ActiveMap")
end
local function GetOpenLobbyPad()
    local padsFolder = workspace:FindFirstChild("LobbyPads")
    if not padsFolder then return nil end
    for _, padModel in ipairs(padsFolder:GetChildren()) do
        if padModel:IsA("Model") then
            local status = padModel:GetAttribute("LobbyStatus")
            local memberCount = tonumber(padModel:GetAttribute("LobbyMemberCount")) or 0
            if status == "Open" or (status == nil and memberCount == 0) then
                local padPart = padModel:FindFirstChild("Pad")
                if padPart and padPart:IsA("BasePart") then
                    return padPart
                end
            end
        end
    end
    return nil
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local padPart = GetOpenLobbyPad()
            if padPart then
                hrp.CFrame = padPart.CFrame * CFrame.new(0, 3, 0)
                task.wait(0.2)
                FireRemote(Remotes.LobbyRequest, "SetMap", Options.MapSelected.Value)
                task.wait(0.2)
                FireRemote(Remotes.LobbyRequest, "SetMaxPlayers", 1)
                task.wait(0.2)
                FireRemote(Remotes.LobbyRequest, "CreateLobby")
                break
            end
        end
        task.wait(1)
    end
end
local function GetLiveDestructibleParts()
    local util = Modules.DestructibleUtility
    if not util then return {} end
    local map = GetActiveMap()
    if not map then return {} end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end
    local roots = util.CollectRoots(map)
    local list = {}
    for _, root in ipairs(roots) do
        for _, part in ipairs(util.GetParts(root)) do
            if part.CanQuery then
                local dist = (part.Position - hrp.Position).Magnitude
                table.insert(list, { root = root, part = part, dist = dist })
            end
        end
    end
    table.sort(list, function(a, b) return a.dist < b.dist end)
    return list
end
local function GetRubblePresses()
    local map = GetActiveMap()
    if not map then return {} end
    local list = {}
    for _, v in ipairs(map:GetDescendants()) do
        if v:IsA("Model") and v.Name == "RubblePress" then
            table.insert(list, v)
        end
    end
    return list
end
local function GetNearestRubblePress()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, press in ipairs(GetRubblePresses()) do
        local pos = press:GetPivot().Position
        local dist = (pos - hrp.Position).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearest = press
        end
    end
    return nearest
end
local function GetPendingCash()
    return math.max(math.floor(tonumber(Plr:GetAttribute("PendingCash")) or 0), 0)
end
local function GetCash()
    return math.max(math.floor(tonumber(Plr:GetAttribute("Cash")) or 0), 0)
end
local function GetRubble()
    return math.max(math.floor(tonumber(Plr:GetAttribute("Rubble")) or 0), 0)
end
local function GetRubbleCapacity()
    return math.max(math.floor(tonumber(Plr:GetAttribute("RubbleCapacity")) or 0), 0)
end
local InputPromptNames = { "InputPromptPart", "PromptPart", "InputTray", "RubbleInput", "DepositPart", "DepositPromptPart" }
local function GetPressSellPrompt(press)
    if not press then return nil end
    for _, name in ipairs(InputPromptNames) do
        local part = press:FindFirstChild(name, true)
        if part then
            local prompt = part:IsA("ProximityPrompt") and part or part:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then return prompt end
        end
    end
    local deposit = press:FindFirstChild("DepositPrompt", true)
    if deposit and deposit:IsA("ProximityPrompt") then return deposit end
    return nil
end
local function GetPressCollectPrompt(press)
    if not press then return nil end
    local outputPart = press:FindFirstChild("OutputPromptPart", true)
    if not outputPart then return nil end
    local attachment = outputPart:FindFirstChild("OutputPromptAttachment")
    if not attachment then return nil end
    local prompt = attachment:FindFirstChild("LocalCollectPrompt")
    if prompt and prompt:IsA("ProximityPrompt") then return prompt end
    return nil
end
local function GetUpgradeLevel(upgradeId)
    local cfg = Modules.UpgradeConfig
    if not cfg then return 0 end
    local node = cfg.Nodes and cfg.Nodes[upgradeId]
    if not node or not node.LevelAttribute then return 0 end
    return math.clamp(math.floor(tonumber(Plr:GetAttribute(node.LevelAttribute)) or 0), 0, cfg.GetMaxLevel and cfg.GetMaxLevel(upgradeId) or 999)
end
local function GetUpgradeCost(upgradeId, tier)
    local cfg = Modules.UpgradeConfig
    if not cfg then return nil end
    local node = cfg.Nodes and cfg.Nodes[upgradeId]
    if not node or not node.Costs then return nil end
    return node.Costs[tier + 1]
end
local AutoDestroyCache = { entries = nil, lastScan = 0 }
local AUTO_HIT_RESCAN_INTERVAL = 3
local function Func_AutoDestroy()
    while Toggles.AutoDestroy.Value do
        local capacity = GetRubbleCapacity()
        if capacity <= 0 or GetRubble() < capacity then
            local now = os.clock()
            if not AutoDestroyCache.entries or (now - AutoDestroyCache.lastScan) >= AUTO_HIT_RESCAN_INTERVAL then
                AutoDestroyCache.entries = GetLiveDestructibleParts()
                AutoDestroyCache.lastScan = now
            else
                for i = #AutoDestroyCache.entries, 1, -1 do
                    local part = AutoDestroyCache.entries[i].part
                    if not part or not part.Parent or not part.CanQuery then
                        table.remove(AutoDestroyCache.entries, i)
                    end
                end
            end
            local entries = AutoDestroyCache.entries
            local hitDistance = (Modules.HammerConfig and Modules.HammerConfig.HIT_DISTANCE) or 12
            if entries[1] then
                local entry = entries[1]
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - entry.part.Position).Magnitude
                    if dist > hitDistance then
                        hrp.CFrame = entry.part.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.175)
                    end
                end
                FireRemote(Remotes.HitDestructible, entry.part, entry.part.Position, Vector3.new(0, 1, 0), "Heavy")
            end
        end
        task.wait()
    end
end
local function Func_AutoCollectCash()
    while Toggles.AutoCollect.Value do
        if GetPendingCash() > 0 then
            local press = GetNearestRubblePress()
            local prompt = press and GetPressCollectPrompt(press)
            if prompt then
                FirePP(prompt, true)
                task.wait(0.5)
            else
                notyuri("[AutoCollect] Could not find collect prompt on nearest press")
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoSellRubble()
    while Toggles.AutoSell.Value do
        local capacity = GetRubbleCapacity()
        local threshold = (Options.SellThreshold and Options.SellThreshold.Value or 100) / 100
        if capacity > 0 and GetRubble() >= capacity * threshold then
            local press = GetNearestRubblePress()
            local prompt = press and GetPressSellPrompt(press)
            if prompt then
                FirePP(prompt, true)
                task.wait(0.5)
            else
                notyuri("[AutoSell] Could not find sell/deposit prompt on nearest press")
            end
        end
        task.wait(.1)
    end
end
local function GetMissingUpgradeRequirements(upgradeId)
    local cfg = Modules.UpgradeConfig
    local missing = {}
    local node = cfg and cfg.Nodes and cfg.Nodes[upgradeId]
    if not node then return missing end
    for reqId, reqLevel in pairs(node.Prerequisites or {}) do
        if GetUpgradeLevel(reqId) < reqLevel then
            table.insert(missing, { UpgradeId = reqId, RequiredLevel = reqLevel })
        end
    end
    return missing
end
local function Func_AutoBuyUpgrades()
    while Toggles.AutoUpgrades.Value do
        local cfg = Modules.UpgradeConfig
        if cfg and cfg.Nodes then
            local cash = GetCash()
            for upgradeId in pairs(cfg.Nodes) do
                if #GetMissingUpgradeRequirements(upgradeId) == 0 then
                    local level = GetUpgradeLevel(upgradeId)
                    local cost = GetUpgradeCost(upgradeId, level)
                    if cost and cash >= cost then
                        FireRemote(Remotes.PurchaseUpgrade, upgradeId)
                        task.wait(0.3)
                        cash = GetCash()
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoSprint()
    while Toggles.AutoSprint.Value do
        FireRemote(Remotes.SetSprinting, true)
        task.wait(1)
    end
end
local function Func_AutoReturnToLobby()
    while Toggles.AutoReturnToLobby.Value do
        if PGui:FindFirstChild("STW_Stage7Results") and Remotes.Stage7Action then
            notyuri("[AutoReturnToLobby] Results screen detected, returning to lobby")
            Remotes.Stage7Action:FireServer("ReturnToLobby")
            task.wait(5)
        end
        task.wait(0.5)
    end
end
local function GetMapList()
    if Modules.LobbyConfig and Modules.LobbyConfig.CONTRACT_ORDER then
        return Modules.LobbyConfig.CONTRACT_ORDER
    end
    return { "Classic" }
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
TB_Tabs.Autofarm.T1:AddToggle("AutoDestroy", { Text = "Auto Destroy" })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect" })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell" })
TB_Tabs.Autofarm2.T1:AddSlider("SellThreshold", { Text = "Sell Threshold", Default = 100, Min = 1, Max = 100, Rounding = 0, Compact = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrades", { Text = "Auto Upgrades" })
TB_Tabs.Autofarm.T1:AddToggle("AutoJoin", { Text = "Auto Join" })
TB_Tabs.Autofarm.T1:AddToggle("AutoReturnToLobby", { Text = "Auto Return To Lobby" })
TB_Tabs.Autofarm2.T1:AddDropdown("MapSelected", {
    Text = "Map",
    Values = GetMapList(),
    Default = 1,
})
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
Toggles.AutoDestroy:OnChanged(function(state) Thread("AutoDestroy", SafeLoop("AutoDestroy", Func_AutoDestroy), state) end)
Toggles.AutoCollect:OnChanged(function(state) Thread("AutoCollect", SafeLoop("AutoCollect", Func_AutoCollectCash), state) end)
Toggles.AutoSell:OnChanged(function(state) Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSellRubble), state) end)
Toggles.AutoUpgrades:OnChanged(function(state) Thread("AutoUpgrades", SafeLoop("AutoUpgrades", Func_AutoBuyUpgrades), state) end)
Toggles.AutoJoin:OnChanged(function(state) Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), state) end)
Toggles.AutoReturnToLobby:OnChanged(function(state) Thread("AutoReturnToLobby", SafeLoop("AutoReturnToLobby", Func_AutoReturnToLobby), state) end)
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
        Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/ClassicContract")
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