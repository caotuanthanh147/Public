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
local SelfThreads = {}
local function SafeInvoke(remote, timeout, ...)
    local args = table.pack(...)
    local callerThread = coroutine.running()
    local selfMarked = callerThread and SelfThreads[callerThread]
    local done = false
    local results = nil
    local thread = task.spawn(function()
        local innerThread = coroutine.running()
        if selfMarked then SelfThreads[innerThread] = true end
        local packed = table.pack(pcall(remote.InvokeServer, remote, table.unpack(args, 1, args.n)))
        if selfMarked then SelfThreads[innerThread] = nil end
        if packed[1] then
            results = packed
        end
        done = true
    end)
    local deadline = tick() + (timeout or 8)
    while not done and tick() < deadline do
        task.wait(0.05)
    end
    if not done then
        pcall(task.cancel, thread)
        return nil
    end
    if results then
        return table.unpack(results, 2, results.n)
    end
    return nil
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
    repeat task.wait(0.1) until not Toggles.AntiKnockback.Value
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
        task.wait(0.1)
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
                task.wait(0.1)
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
local AllianceFuncs = {"CanPlaceTower", "PlaceTower", "UpgradeTower", "SellTower", "UseTowerAbility", "ChangeTargetMode"}
local AllianceEvents = {"SetGameSpeed", "SkipWaveVote", "ReplayVote", "ContinueEndlessVote"}
local LobbyFuncs = {"SummonUnits", "GetQuestState", "ClaimQuest", "GetGlobalQuestState", "ClaimGlobalQuest", "ClaimPlaytimeGift", "Codes"}
local LobbyEvents = {"AFKRemote"}
Support.HookFunction = typeof(hookfunction) == "function"
local MDir = "Yuri/Alliance/Macros"
local PlaceTowersGetSelection = nil
local PlaceTowersRefresh = nil
local PlaceTowersValues = nil
local SellFishGetSelection = nil
local SellFishRefresh = nil
local SellFishValues = nil
local StatsLabel = nil
local MState = {
    Rec = false,
    Rep = false,
    Cur = nil,
    Load = nil,
    Hooked = false,
    Step = 0,
    Total = 0,
    LabelRef = nil,
    SelfFire = false,
    NextKey = 0,
    RecKeys = {},
    RepMap = {},
    WaveClock = tick(),
    Saved = false,
    PendingLabel = nil,
    Pending = {},
    Adopted = {},
}
local Memo = {
    SkipWave = 0,
    DifficultyAt = 0,
    ReplayAt = 0,
    ContinueAt = nil,
    ContinueAtTime = 0,
    ReturnAt = nil,
    SpeedAt = 0,
    AbilityAt = {},
    SummonFails = 0,
    AFKOn = false,
}
local PosPath = "Yuri/Alliance/positions.json"
local RefreshSlotDropdowns = nil
local Place = {
    FailPos = {},
    TypeFails = {},
    PauseUntil = {},
    GridCache = nil,
    GridKey = "",
    BoundsCache = nil,
    SlotPositions = {},
    PosLabelRef = nil,
}
local function IsGamePlace()
    return workspace:FindFirstChild("Towers") and RS:FindFirstChild("WaveState") and true or false
end
local function IsLobbyPlace()
    return workspace:FindFirstChild("Elevators") and RS:FindFirstChild("Packages") and true or false
end
local function GetWaveState()
    return RS:FindFirstChild("WaveState")
end
local function GetWave()
    local ws = GetWaveState()
    return (ws and tonumber(ws:GetAttribute("CurrentWave"))) or 0
end
local function GetWaveElapsed()
    return tick() - MState.WaveClock
end
local function GetResult()
    local ws = GetWaveState()
    return tostring((ws and ws:GetAttribute("Result")) or "")
end
local function IsMatchActive()
    local ws = GetWaveState()
    if not ws then
        return false
    end
    return ws:GetAttribute("MatchState") == "Running"
end
local function GetCash()
    local stats = Plr:FindFirstChild("leaderstats")
    local cash = stats and stats:FindFirstChild("Cash")
    return (cash and cash.Value) or 0
end
local function GetPlacedCount()
    local placed = Plr:FindFirstChild("PlacedUnits")
    return (placed and placed.Value) or 0
end
local function GetTowersFolder()
    return workspace:FindFirstChild("Towers")
end
local function GetTowerOwner(tower)
    local owner = tower:GetAttribute("Owner")
    if type(owner) == "string" and owner ~= "" then
        return owner
    end
    local config = tower:FindFirstChild("Config")
    local ownerValue = config and config:FindFirstChild("Owner")
    return (ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value) or "Unknown"
end
local function IsOwnedTower(tower)
    if typeof(tower) ~= "Instance" or not tower:IsA("Model") then return false end
    return GetTowerOwner(tower) == Plr.Name
end
local function GetOwnedTowers()
    local list = {}
    local folder = GetTowersFolder()
    if not folder then return list end
    for _, tower in ipairs(folder:GetChildren()) do
        if IsOwnedTower(tower) then
            table.insert(list, tower)
        end
    end
    return list
end
local function GetTowerUnitId(tower)
    if Modules.TowerConfig then
        local ok, id = pcall(Modules.TowerConfig.getUnitId, tower)
        if ok and type(id) == "string" then return id end
    end
    local attr = tower:GetAttribute("UnitId")
    if type(attr) == "string" and attr ~= "" then return attr end
    return tower.Name
end
local function GetTowerLevel(tower)
    if Modules.TowerConfig then
        local ok, level = pcall(Modules.TowerConfig.getLevel, tower)
        if ok and type(level) == "number" then return level end
    end
    local attr = tonumber(tower:GetAttribute("Level"))
    return math.max(1, math.floor(attr or 1))
end
local function GetTowerGroundPos(tower)
    local pos = tower:GetAttribute("PlacementGroundPosition")
    if typeof(pos) == "Vector3" then return pos end
    local root = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart") or tower:FindFirstChild("HumanoidPart")
    if root and root:IsA("BasePart") then return root.Position end
    local ok, pivot = pcall(tower.GetPivot, tower)
    if ok and typeof(pivot) == "CFrame" then return pivot.Position end
    return nil
end
local function GetTowerSourceModel(unitId)
    local towers = RS:FindFirstChild("Towers")
    if not towers then return nil end
    if Modules.TowerUpgradeConfig then
        local ok, name = pcall(Modules.TowerUpgradeConfig.getModelName, unitId, 1)
        if ok and type(name) == "string" and name ~= "" then
            local model = towers:FindFirstChild(name)
            if model then return model end
        end
    end
    return towers:FindFirstChild(unitId)
end
local function GetUnitPrice(unitId)
    if not Modules.TowerConfig then return nil end
    local ok, stats = pcall(Modules.TowerConfig.getLevelStats, unitId, 1)
    if ok and type(stats) == "table" then
        return tonumber(stats.Price)
    end
    return nil
end
local function GetSlotUnitName(slot)
    local slotsFolder = Plr:FindFirstChild("Slots")
    local child = slotsFolder and slotsFolder:FindFirstChild(tostring(slot))
    if child and child:IsA("StringValue") and type(child.Value) == "string" and child.Value ~= "" then
        return child.Value
    end
    return nil
end
local function GetSlotByUnitName()
    local map = {}
    local slotsFolder = Plr:FindFirstChild("Slots")
    if not slotsFolder then return map end
    for _, child in ipairs(slotsFolder:GetChildren()) do
        if child:IsA("StringValue") and type(child.Value) == "string" and child.Value ~= "" then
            local slot = tonumber(child.Name)
            if slot then map[child.Value] = slot end
        end
    end
    return map
end
local function GetSlotDisplayNames()
    local map = GetSlotByUnitName()
    local slots = {}
    for name, slot in pairs(map) do
        table.insert(slots, { Slot = slot, Name = name })
    end
    table.sort(slots, function(a, b) return a.Slot < b.Slot end)
    local names = {}
    for _, entry in ipairs(slots) do
        table.insert(names, "Slot " .. entry.Slot .. " (" .. entry.Name .. ")")
    end
    return names
end
local function SlotDisplayToNumber(display)
    local n = display and display:match("^Slot (%d+)")
    return n and tonumber(n) or nil
end
local function GetSlotOrder(slot)
    local opt = Options["PlaceOrder" .. slot]
    return (opt and tonumber(opt.Value)) or slot
end
local function GetSlotPlaceWave(slot)
    local opt = Options["PlaceWave" .. slot]
    return (opt and tonumber(opt.Value)) or 0
end
local function GetSlotPlaceLimit(slot)
    local opt = Options["PlaceLimit" .. slot]
    return (opt and tonumber(opt.Value)) or 0
end
local function GetSlotUpgradeLimit(slot)
    local opt = Options["UpgradeLimit" .. slot]
    return (opt and tonumber(opt.Value)) or 0
end
local function GetCurrentMapKey()
    local ws = GetWaveState()
    if not ws then return nil end
    local id = tostring(ws:GetAttribute("MapId") or "")
    if id ~= "" then return id end
    local name = tostring(ws:GetAttribute("MapDisplayName") or "")
    if name ~= "" then return name end
    return nil
end
local function EnsurePosDir()
    if not writefile then return end
    pcall(function()
        local built = ""
        for _, part in ipairs(("Yuri/Alliance"):split("/")) do
            built = (built == "") and part or (built .. "/" .. part)
            if not isfolder(built) then
                makefolder(built)
            end
        end
    end)
end
local function SavePositions()
    if not writefile then return false end
    EnsurePosDir()
    local out = {}
    for mapKey, slots in pairs(Place.SlotPositions) do
        local slotOut = {}
        for slot, cfs in pairs(slots) do
            local cfOut = {}
            for i, cf in ipairs(cfs) do
                cfOut[i] = {cf:GetComponents()}
            end
            slotOut[tostring(slot)] = cfOut
        end
        out[mapKey] = slotOut
    end
    local ok = pcall(function()
        writefile(PosPath, HttpService:JSONEncode(out))
    end)
    return ok
end
local function LoadPositions()
    if not readfile or not isfile then return end
    if not isfile(PosPath) then return end
    local ok, raw = pcall(readfile, PosPath)
    if not ok or type(raw) ~= "string" or raw == "" then return end
    local data
    pcall(function()
        data = HttpService:JSONDecode(raw)
    end)
    if type(data) ~= "table" then return end
    local loaded = {}
    for mapKey, slots in pairs(data) do
        if type(slots) == "table" then
            loaded[mapKey] = {}
            for slotStr, cfs in pairs(slots) do
                local slot = tonumber(slotStr)
                if slot and type(cfs) == "table" then
                    local cfList = {}
                    for i, comp in ipairs(cfs) do
                        if type(comp) == "table" and #comp == 12 then
                            cfList[i] = CFrame.new(unpack(comp))
                        end
                    end
                    loaded[mapKey][slot] = cfList
                end
            end
        end
    end
    Place.SlotPositions = loaded
end
local function PosText(mapKey)
    if not mapKey or not Place.SlotPositions[mapKey] then return "No positions set" end
    local lines = {}
    for slot, cfs in pairs(Place.SlotPositions[mapKey]) do
        local unitName = GetSlotUnitName(slot)
        table.insert(lines, "Slot " .. slot .. (unitName and (" (" .. unitName .. ")") or "") .. ": " .. #cfs .. " pos")
    end
    if #lines == 0 then return "No positions set" end
    table.sort(lines)
    return table.concat(lines, "\n")
end
local function UpdatePosLabels()
    if Place.PosLabelRef then
        pcall(function()
            Place.PosLabelRef:SetText(PosText(GetCurrentMapKey()))
        end)
    end
end
local function HandleSlotPos(act, slot)
    local mapKey = GetCurrentMapKey()
    if not mapKey then
        return
    end
    if act == "reset" then
        if slot then
            if Place.SlotPositions[mapKey] then Place.SlotPositions[mapKey][slot] = nil end
            notyuri("[Positions] reset slot=" .. slot .. " map=" .. mapKey)
        else
            Place.SlotPositions[mapKey] = nil
            notyuri("[Positions] reset all map=" .. mapKey)
        end
        SavePositions()
        UpdatePosLabels()
        return
    end
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Library:Notify("Character not found", 3)
        return
    end
    local pos = hrp.CFrame.Position
    local cf = CFrame.new(pos.X, pos.Y, pos.Z)
    if not Place.SlotPositions[mapKey] then Place.SlotPositions[mapKey] = {} end
    if act == "set" then
        if not Place.SlotPositions[mapKey][slot] then Place.SlotPositions[mapKey][slot] = {} end
        table.insert(Place.SlotPositions[mapKey][slot], cf)
        local count = #Place.SlotPositions[mapKey][slot]
        notyuri("[Positions] set slot=" .. slot .. " count=" .. count .. " map=" .. mapKey)
    elseif act == "massset" then
        for i = 1, 5 do
            if not Place.SlotPositions[mapKey][i] then Place.SlotPositions[mapKey][i] = {} end
            table.insert(Place.SlotPositions[mapKey][i], cf)
        end
        notyuri("[Positions] massset map=" .. mapKey)
    end
    SavePositions()
    UpdatePosLabels()
end
local function SetPos(slot) HandleSlotPos("set", slot) end
local function ResetPos(slot) HandleSlotPos("reset", slot) end
local function GetAbilityCooldownRemaining(tower)
    local remaining = tonumber(tower:GetAttribute("AbilityCooldownRemaining"))
    local updatedAt = tonumber(tower:GetAttribute("AbilityCooldownUpdatedAt"))
    local speed = tonumber(tower:GetAttribute("AbilityCooldownSpeed"))
    local now = workspace:GetServerTimeNow()
    if type(remaining) == "number" and type(updatedAt) == "number" and type(speed) == "number" then
        return math.max(0, remaining - math.max(0, now - updatedAt) * speed)
    end
    local ws = GetWaveState()
    local gameSpeed = tonumber(ws and ws:GetAttribute("GameSpeed")) or 1
    local endsAt = tonumber(tower:GetAttribute("AbilityCooldownEndsAt")) or 0
    return math.max(0, endsAt - now) * math.max(gameSpeed, 0.01)
end
local function Invoke(remote, ...)
    if not remote then return nil end
    local args = {...}
    local thread = coroutine.running()
    if thread then SelfThreads[thread] = true end
    MState.SelfFire = true
    local results = table.pack(SafeInvoke(remote, 12, unpack(args)))
    if thread then SelfThreads[thread] = nil end
    MState.SelfFire = false
    return table.unpack(results, 1, results.n)
end
local function Fire(remote, ...)
    if not remote then return false end
    local args = {...}
    MState.SelfFire = true
    local ok = FireRemote(remote, unpack(args))
    MState.SelfFire = false
    return ok
end
do
    local modulesFolder = RS:FindFirstChild("Modules")
    local sharedFolder = RS:FindFirstChild("Shared")
    if modulesFolder then
        local towerConfig = GetSafeModule(modulesFolder, "TowerConfig")
        if towerConfig then Modules.TowerConfig = towerConfig end
        local abilityConfig = GetSafeModule(modulesFolder, "TowerAbilityConfig")
        if abilityConfig then Modules.TowerAbilityConfig = abilityConfig end
        local upgradeConfig = GetSafeModule(modulesFolder, "TowerUpgradeConfig")
        if upgradeConfig then Modules.TowerUpgradeConfig = upgradeConfig end
    end
    if sharedFolder then
        local placement = GetSafeModule(sharedFolder, "PlacementConfig")
        if placement then Modules.PlacementConfig = placement end
        local gifts = GetSafeModule(sharedFolder, "PlaytimeGiftsConfig")
        if gifts then Modules.PlaytimeGiftsConfig = gifts end
        local mapConfig = GetSafeModule(sharedFolder, "MapConfig")
        if mapConfig then Modules.MapConfig = mapConfig end
        local modeVoteConfig = GetSafeModule(sharedFolder, "ModeVoteConfig")
        if modeVoteConfig then Modules.ModeVoteConfig = modeVoteConfig end
    end
end
local function LoadMDir()
    if not writefile then return end
    pcall(function()
        local built = ""
        for _, part in ipairs(MDir:split("/")) do
            built = (built == "") and part or (built .. "/" .. part)
            if not isfolder(built) then
                makefolder(built)
            end
        end
    end)
end
local function ListMacros()
    local names = {}
    if not listfiles then return names end
    local ok, files = pcall(listfiles, MDir)
    if not ok or type(files) ~= "table" then return names end
    for _, path in ipairs(files) do
        if type(path) == "string" and path:sub(-5):lower() == ".json" then
            local fname = path:match("([^/\\]+)%.json$")
            if fname and fname ~= "" then
                table.insert(names, fname)
            end
        end
    end
    table.sort(names)
    return names
end
local function LoadMacro(name)
    if not name or name == "" or not readfile then return nil end
    local path = MDir .. "/" .. name .. ".json"
    if not isfile(path) then return nil end
    local ok, raw = pcall(readfile, path)
    if not ok or type(raw) ~= "string" or raw == "" then return nil end
    local data
    pcall(function()
        data = HttpService:JSONDecode(raw)
    end)
    if type(data) ~= "table" then return nil end
    local entries = {}
    local i = 1
    while data[tostring(i)] do
        entries[i] = data[tostring(i)]
        i = i + 1
    end
    return {entries = entries}
end
local function SaveMacro(name, macro)
    if not name or name == "" or not writefile then return false end
    LoadMDir()
    local path = MDir .. "/" .. name .. ".json"
    local out = {}
    for i, entry in ipairs(macro.entries) do
        out[tostring(i)] = entry
    end
    local ok = pcall(function()
        writefile(path, HttpService:JSONEncode(out))
    end)
    return ok
end
local function UpdateMacroLabel(suffix, elapsed)
    if not (MState.LabelRef and MState.LabelRef.SetText) then return end
    local txt
    local timeStr = elapsed and (" " .. elapsed) or ""
    if MState.Rec then
        if suffix then
            txt = string.format("Recording [%d] %s%s", MState.Step, suffix, timeStr)
        else
            txt = string.format("Recording [%d]", MState.Step)
        end
    elseif MState.Rep then
        txt = string.format("Replaying [%d / %d]", MState.Step, MState.Total)
        if suffix then txt = txt .. " | " .. suffix .. timeStr end
    else
        txt = "Idle" .. (suffix and (" | " .. suffix) or "")
    end
    if MState.Rec then
        MState.PendingLabel = txt
    else
        local ok, err = pcall(function()
            MState.LabelRef:SetText(txt)
        end)
        if not ok then
            notyuri("[Macro Rec] SetText FAILED:", tostring(err))
            MState.PendingLabel = txt
        end
    end
end
local function LabelPump()
    while MState.Rec do
        if MState.PendingLabel then
            local txt = MState.PendingLabel
            MState.PendingLabel = nil
            local ok, err = pcall(function()
                MState.LabelRef:SetText(txt)
            end)
            if not ok then
                notyuri("[Macro Rec] LabelPump SetText FAILED:", tostring(err))
            end
        end
        task.wait()
    end
end
local function RecordAct(kind, data, wave, elapsed)
    if not MState.Cur then return end
    MState.Step = MState.Step + 1
    local entry = {Type = kind, Time = tostring(wave or 0) .. " " .. tostring(elapsed or 0)}
    for k, val in pairs(data or {}) do
        entry[k] = val
    end
    table.insert(MState.Cur.entries, entry)
    UpdateMacroLabel(kind, entry.Time)
    notyuri("[Macro Rec]", kind, "confirmed", "wave", tostring(wave), string.format("%.2fs", elapsed))
end
local function ParseMacroTime(entry)
    local wStr, eStr = (entry.Time or ""):match("^(%d+)%s+(.+)$")
    return tonumber(wStr) or 0, tonumber(eStr) or 0
end
local function SortMacroEntries(entries)
    table.sort(entries, function(a, b)
        local wa, ea = ParseMacroTime(a)
        local wb, eb = ParseMacroTime(b)
        if wa ~= wb then return wa < wb end
        return ea < eb
    end)
end
local function EnsureRecKey(inst)
    if typeof(inst) ~= "Instance" then return nil end
    local key = MState.RecKeys[inst]
    if not key then
        MState.NextKey = MState.NextKey + 1
        key = MState.NextKey
        MState.RecKeys[inst] = key
        MState.Adopted[key] = true
    end
    return key
end
local ConfirmKindData = {
    Place = function(pend, key) return {Key = key, UnitId = pend.UnitId, CF = pend.CF} end,
    Upgrade = function(pend, key) return {Key = key, UnitId = pend.UnitId, Level = pend.Level, Price = pend.Price, Pos = pend.Pos} end,
    Sell = function(pend, key) return {Key = key, UnitId = pend.UnitId, Pos = pend.Pos} end,
    Mode = function(pend, key) return {Key = key, UnitId = pend.UnitId, Pos = pend.Pos} end,
    Ability = function(pend, key) return {Key = key, UnitId = pend.UnitId, Level = pend.Level, Pos = pend.Pos} end,
}
local function ConfirmAct(kind, pend, inst, late)
    pend.Resolved = true
    local key = nil
    if kind == "Place" then
        key = EnsureRecKey(inst)
    elseif kind == "Upgrade" then
        if typeof(pend.Tower) == "Instance" then
            key = MState.RecKeys[pend.Tower]
        end
        key = key or EnsureRecKey(inst)
        MState.RecKeys[inst] = key
        if typeof(pend.Tower) == "Instance" then
            MState.RecKeys[pend.Tower] = key
        end
    elseif kind == "Sell" then
        if typeof(pend.Tower) == "Instance" then
            key = MState.RecKeys[pend.Tower] or EnsureRecKey(pend.Tower)
            MState.RecKeys[pend.Tower] = nil
        end
    else
        if typeof(pend.Tower) == "Instance" then
            key = MState.RecKeys[pend.Tower] or EnsureRecKey(pend.Tower)
            MState.RecKeys[pend.Tower] = key
        end
    end
    if (kind == "Place" or kind == "Upgrade") and not key then
        pend.Dropped = true
        return
    end
    pend.Key = key
    RecordAct(kind, ConfirmKindData[kind](pend, key), pend.Wave, pend.Elapsed)
    if late then
        notyuri("[Macro Rec] " .. kind .. " late-confirmed key=" .. tostring(key) .. " (" .. tostring(pend.UnitId) .. ")")
    end
end
local MacroRemoteKinds = {
    PlaceTower = "Place",
    UpgradeTower = "Upgrade",
    SellTower = "Sell",
    ChangeTargetMode = "Mode",
    UseTowerAbility = "Ability",
}
local OrigRemotes = {}
local NCSeen = {}
local function ResolveOrigRemotes()
    local ok, err = pcall(function()
        local origRS = game:GetService("ReplicatedStorage")
        local folder = origRS:FindFirstChild("RemoteFunctions")
        if not folder then return end
        for name in pairs(MacroRemoteKinds) do
            local remote = folder:FindFirstChild(name)
            if remote and not OrigRemotes[name] then
                OrigRemotes[name] = remote
            end
        end
    end)
    if not ok then
        notyuri("[Macro] orig remote resolve error:", tostring(err))
    end
end
local function GetMacroRemoteKind(self)
    if OrigRemotes.PlaceTower and rawequal(self, OrigRemotes.PlaceTower) then return "Place" end
    if OrigRemotes.UpgradeTower and rawequal(self, OrigRemotes.UpgradeTower) then return "Upgrade" end
    if OrigRemotes.SellTower and rawequal(self, OrigRemotes.SellTower) then return "Sell" end
    if OrigRemotes.ChangeTargetMode and rawequal(self, OrigRemotes.ChangeTargetMode) then return "Mode" end
    if OrigRemotes.UseTowerAbility and rawequal(self, OrigRemotes.UseTowerAbility) then return "Ability" end
    if Remotes.PlaceTower and rawequal(self, Remotes.PlaceTower) then return "Place" end
    if Remotes.UpgradeTower and rawequal(self, Remotes.UpgradeTower) then return "Upgrade" end
    if Remotes.SellTower and rawequal(self, Remotes.SellTower) then return "Sell" end
    if Remotes.ChangeTargetMode and rawequal(self, Remotes.ChangeTargetMode) then return "Mode" end
    if Remotes.UseTowerAbility and rawequal(self, Remotes.UseTowerAbility) then return "Ability" end
    return nil
end
local function IsMatchPending()
    local ws = GetWaveState()
    if not ws then return false end
    return ws:GetAttribute("MatchState") == "Intermission"
end
local function SnapshotCall(self, nargs, kind)
    if not (MState.Rec and MState.Cur) then return nil end
    if type(kind) ~= "string" then return nil end
    local wave, elapsed
    if IsMatchActive() then
        wave = GetWave()
        elapsed = GetWaveElapsed()
    else
        wave = 0
        elapsed = 0
    end
    local pend
    if kind == "Place" then
        local unitId = nargs[2]
        local cf = nargs[3]
        if type(unitId) ~= "string" or typeof(cf) ~= "CFrame" then return nil end
        pend = {Kind = "Place", UnitId = unitId, CF = {cf:GetComponents()}}
    elseif kind == "Upgrade" then
        local tower = nargs[2]
        if typeof(tower) ~= "Instance" then return nil end
        pend = {Kind = "Upgrade", Tower = tower, UnitId = GetTowerUnitId(tower), Level = GetTowerLevel(tower), Price = tonumber(tower:GetAttribute("UpgradePrice"))}
        local gpos = GetTowerGroundPos(tower)
        if gpos then pend.Pos = {gpos.X, gpos.Y, gpos.Z} end
    elseif kind == "Sell" then
        local tower = nargs[2]
        if typeof(tower) ~= "Instance" then return nil end
        pend = {Kind = "Sell", Tower = tower, UnitId = GetTowerUnitId(tower)}
        local gpos = GetTowerGroundPos(tower)
        if gpos then pend.Pos = {gpos.X, gpos.Y, gpos.Z} end
    elseif kind == "Mode" then
        local tower = nargs[2]
        if typeof(tower) ~= "Instance" then return nil end
        pend = {Kind = "Mode", Tower = tower, UnitId = GetTowerUnitId(tower)}
        local gpos = GetTowerGroundPos(tower)
        if gpos then pend.Pos = {gpos.X, gpos.Y, gpos.Z} end
    elseif kind == "Ability" then
        local tower = nargs[2]
        if typeof(tower) ~= "Instance" then return nil end
        pend = {Kind = "Ability", Tower = tower, UnitId = GetTowerUnitId(tower), Level = GetTowerLevel(tower)}
        local gpos = GetTowerGroundPos(tower)
        if gpos then pend.Pos = {gpos.X, gpos.Y, gpos.Z} end
    else
        return nil
    end
    pend.Wave = wave
    pend.Elapsed = elapsed
    pend.At = tick()
    pend.Resolved = false
    table.insert(MState.Pending, pend)
    notyuri("[Macro Rec]", pend.Kind, "captured", tostring(pend.UnitId), "wave", tostring(wave), string.format("%.2fs", elapsed))
    return pend
end
local function ResolveCall(pend, ret)
    if not (pend and not pend.Resolved) then return end
    local r1 = (ret and ret.n and ret.n > 0) and ret[1] or nil
    local r2 = (ret and ret.n and ret.n > 1) and ret[2] or nil
    if pend.Kind == "Place" then
        if typeof(r1) == "Instance" and r1:IsA("Model") then
            ConfirmAct("Place", pend, r1, false)
        end
    elseif pend.Kind == "Upgrade" then
        if r1 and typeof(r2) == "Instance" and r2:IsA("Model") then
            ConfirmAct("Upgrade", pend, r2, false)
        end
    elseif pend.Kind == "Sell" then
        if r1 then
            ConfirmAct("Sell", pend, nil, false)
        end
    elseif pend.Kind == "Mode" then
        if r1 and type(r2) == "string" then
            ConfirmAct("Mode", pend, nil, false)
        else
            pend.Resolved = true
            pend.Dropped = true
        end
    elseif pend.Kind == "Ability" then
        if r1 and type(r2) == "number" then
            ConfirmAct("Ability", pend, nil, false)
        else
            pend.Resolved = true
            pend.Dropped = true
        end
    end
end
local function FindUnkeyedOwnedTower(predFn)
    for _, tower in ipairs(GetOwnedTowers()) do
        if not MState.RecKeys[tower] and predFn(tower) then
            return tower
        end
    end
    return nil
end
local function TowerNearPos(tower, pos, radius)
    local tpos = GetTowerGroundPos(tower)
    if not (tpos and pos) then return false end
    return (tpos - pos).Magnitude <= (radius or 4)
end
local function ProcessPendingSweep()
    local now = tick()
    for _, pend in ipairs(MState.Pending) do
        if not pend.Resolved then
            local age = now - pend.At
            if age > 12 then
                pend.Resolved = true
                pend.Dropped = true
                notyuri("[Macro Rec]", pend.Kind, "expired unresolved:", tostring(pend.UnitId))
            elseif age > 0.6 then
                if pend.Kind == "Place" then
                    local pos = Vector3.new(pend.CF[1], pend.CF[2], pend.CF[3])
                    local inst = FindUnkeyedOwnedTower(function(t)
                        return GetTowerUnitId(t) == pend.UnitId and TowerNearPos(t, pos, 5)
                    end)
                    if inst then
                        pend.Late = true
                        ConfirmAct("Place", pend, inst, true)
                    end
                elseif pend.Kind == "Upgrade" then
                    local pos = pend.Pos and Vector3.new(pend.Pos[1], pend.Pos[2], pend.Pos[3]) or nil
                    if pos then
                        local inst = FindUnkeyedOwnedTower(function(t)
                            return GetTowerUnitId(t) == pend.UnitId and TowerNearPos(t, pos, 5)
                        end)
                        if inst then
                            pend.Late = true
                            ConfirmAct("Upgrade", pend, inst, true)
                        end
                    end
                elseif pend.Kind == "Sell" then
                    local old = pend.Tower
                    if typeof(old) ~= "Instance" or old.Parent == nil then
                        pend.Late = true
                        ConfirmAct("Sell", pend, nil, true)
                    end
                else
                    pend.Resolved = true
                    pend.Dropped = true
                end
            end
        end
    end
    local kept = {}
    for _, pend in ipairs(MState.Pending) do
        if not pend.Resolved then
            table.insert(kept, pend)
        end
    end
    MState.Pending = kept
end
local function MacroSweeper()
    while MState.Rec do
        local ok, err = pcall(ProcessPendingSweep)
        if not ok then
            notyuri("[Macro SW] error:", tostring(err))
        end
        task.wait(0.1)
    end
    for _ = 1, 3 do
        if MState.Rec then break end
        if not MState.Cur then break end
        pcall(ProcessPendingSweep)
        task.wait(0.1)
    end
end
local function WaitForMacroRemotes()
    local deadline = tick() + 8
    local folder = RS:FindFirstChild("RemoteFunctions")
    while not folder and tick() < deadline do
        task.wait(0.25)
        folder = RS:FindFirstChild("RemoteFunctions")
    end
    if not folder then return end
    for _, name in ipairs({"PlaceTower", "UpgradeTower", "SellTower", "ChangeTargetMode", "UseTowerAbility"}) do
        if not Remotes[name] then
            local remote = folder:FindFirstChild(name)
            if not remote then
                remote = folder:WaitForChild(name, math.max(0, deadline - tick()))
            end
            if remote and (remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent")) then
                Remotes[name] = remote
            end
        end
    end
end
local function InstallMacroHook()
    WaitForMacroRemotes()
    ResolveOrigRemotes()
    if MState.Hooked then
        return
    end
    if not (Support.HookMeta or Support.HookFunction) then
        Library:Notify("Macro record requires hookmetamethod/hookfunction support", 4)
        return
    end
    local cc = (typeof(newcclosure) == "function") and newcclosure or (function(f) return f end)
    local installedNamecall = false
    local installedHookFn = false
    if Support.HookMeta then
        local ok, err = pcall(function()
            local originalNamecall
            originalNamecall = hookmetamethod(game, "__namecall", cc(function(...)
                local method = getnamecallmethod()
                if method ~= "InvokeServer" then
                    return originalNamecall(...)
                end
                local self = ...
                local kind = GetMacroRemoteKind(self)
                if not kind or not MState.Rec or MState.SelfFire or SelfThreads[coroutine.running() or false] then
                    return originalNamecall(...)
                end
                local thread = coroutine.running() or false
                NCSeen[thread] = true
                local args = table.pack(...)
                local ret = table.pack(originalNamecall(table.unpack(args, 1, args.n)))
                NCSeen[thread] = nil
                local ok2, snap = pcall(SnapshotCall, self, args, kind)
                if ok2 and snap then
                    local ok3, err2 = pcall(ResolveCall, snap, ret)
                    if not ok3 then
                        notyuri("[Macro Rec] resolve error:", tostring(err2))
                    end
                end
                return table.unpack(ret, 1, ret.n)
            end))
        end)
        if ok then
            installedNamecall = true
            notyuri("[Macro] __namecall hook installed (primary; original invoked before capture)")
        else
            notyuri("[Macro] __namecall hook failed:", tostring(err))
        end
    end
    if Support.HookFunction then
        local ok, err = pcall(function()
            local hookTarget = (OrigRemotes.PlaceTower and OrigRemotes.PlaceTower.InvokeServer)
                or (Remotes.PlaceTower and Remotes.PlaceTower.InvokeServer)
                or nil
            if not hookTarget then
                local probe = Instance.new("RemoteFunction")
                hookTarget = probe.InvokeServer
                probe:Destroy()
            end
            local originalInvokeServer
            originalInvokeServer = hookfunction(hookTarget, cc(function(...)
                local self = ...
                if NCSeen[coroutine.running() or false] then
                    return originalInvokeServer(...)
                end
                local kind = GetMacroRemoteKind(self)
                if not kind or not MState.Rec or MState.SelfFire or SelfThreads[coroutine.running() or false] then
                    return originalInvokeServer(...)
                end
                local args = table.pack(...)
                local ret = table.pack(originalInvokeServer(table.unpack(args, 1, args.n)))
                local ok2, snap = pcall(SnapshotCall, self, args, kind)
                if ok2 and snap then
                    local ok3, err2 = pcall(ResolveCall, snap, ret)
                    if not ok3 then
                        notyuri("[Macro Rec] resolve error:", tostring(err2))
                    end
                end
                return table.unpack(ret, 1, ret.n)
            end))
        end)
        if ok then
            installedHookFn = true
            notyuri("[Macro] InvokeServer hookfunction installed (secondary; deduped by namecall marker)")
        else
            notyuri("[Macro] hookfunction failed:", tostring(err))
        end
    end
    if not (installedNamecall or installedHookFn) then
        MState.Hooked = false
        Library:Notify("Macro record: failed to install any hook", 4)
        return
    end
    MState.Hooked = true
    local refCount = 0
    for _ in pairs(OrigRemotes) do
        refCount = refCount + 1
    end
    notyuri("[Macro] hook active; orig remote refs resolved:", tostring(refCount))
end
local function Func_MacroRecord(state)
    if not state then return end
    if not IsGamePlace() then
        Library:Notify("Macro record is only available in the game place", 4)
        Toggles.MacroRecord:SetValue(false)
        return
    end
    if Toggles.LoadMacro and Toggles.LoadMacro.Value then
        Toggles.LoadMacro:SetValue(false)
    end
    InstallMacroHook()
    MState.Gen = (MState.Gen or 0) + 1
    local gen = MState.Gen
    MState.Cur = {entries = {}}
    MState.Step = 0
    MState.NextKey = 0
    MState.RecKeys = {}
    MState.Saved = false
    MState.Pending = {}
    MState.Adopted = {}
    UpdateMacroLabel()
    MState.WaveClock = tick()
    MState.Rec = true
    UpdateMacroLabel()
    task.spawn(LabelPump)
    task.spawn(MacroSweeper)
    local sawActive = IsMatchActive()
    notyuri("[Macro Rec] recording started" .. (sawActive and "" or " (pre-match: intermission actions logged at 0:00)"))
    while Toggles.MacroRecord.Value do
        if MState.Gen ~= gen then
            notyuri("[Macro Rec] stale recorder thread aborted mid-recording (superseded)")
            return
        end
        if IsMatchActive() then
            sawActive = true
        elseif sawActive then
            break
        end
        task.wait()
    end
    MState.Rec = false
    task.wait()
    if MState.Gen ~= gen then return end
    local entries = MState.Cur and #MState.Cur.entries or 0
    notyuri("[Macro Rec] recording stopped,", tostring(entries), "actions")
    if entries > 0 and not MState.Saved then
        MState.Saved = true
        SortMacroEntries(MState.Cur.entries)
        local recorded = MState.Cur
        local fname = (Options.FileName and Options.FileName.Value) or ""
        if fname == "" then
            fname = "Macro_" .. os.date("%Y%m%d_%H%M%S")
        end
        task.spawn(function()
            local ok = SaveMacro(fname, recorded)
            if ok then
                Library:Notify("Macro saved: " .. fname, 4)
                if Options.MacroSelected then
                    Options.MacroSelected:SetValues(ListMacros())
                end
            else
                Library:Notify("Failed to save macro (writefile unsupported?)", 4)
            end
        end)
    end
    MState.Cur = nil
    MState.Step = 0
    UpdateMacroLabel()
end
local function GetMacroEntryCost(entry)
    if entry.Type == "Place" then
        return GetUnitPrice(entry.UnitId)
    elseif entry.Type == "Upgrade" then
        return tonumber(entry.Price)
    elseif entry.Type == "Ability" then
        if Modules.TowerAbilityConfig then
            local ok, def = pcall(Modules.TowerAbilityConfig.get, entry.UnitId, entry.Level or 1)
            if ok and type(def) == "table" then
                return tonumber(def.Price)
            end
        end
        return nil
    end
    return nil
end
local function WaitForCash(amount, timeout)
    if not amount or amount <= 0 then return true end
    if GetCash() >= amount then return true end
    local startedAt = timeout and tick()
    while Toggles.LoadMacro.Value and GetCash() < amount do
        if timeout and (tick() - startedAt) >= timeout then break end
        task.wait()
    end
    return Toggles.LoadMacro.Value and GetCash() >= amount
end
local function FindTowerForEntry(entry)
    local t = entry.Key and MState.RepMap[entry.Key]
    if t and t.Parent and (t.PrimaryPart or t:FindFirstChild("HumanoidRootPart") or t:FindFirstChild("HumanoidPart")) then
        return t
    end
    local gpos = entry.Pos
    if type(gpos) ~= "table" or #gpos ~= 3 then return nil end
    local pos = Vector3.new(gpos[1], gpos[2], gpos[3])
    local unitId = entry.UnitId
    if type(unitId) ~= "string" or unitId == "" then return nil end
    local best, bestDist = nil, 5
    for _, tower in ipairs(GetOwnedTowers()) do
        if GetTowerUnitId(tower) == unitId then
            local tpos = GetTowerGroundPos(tower)
            if tpos then
                local dist = (tpos - pos).Magnitude
                if dist < bestDist then
                    best, bestDist = tower, dist
                end
            end
        end
    end
    if best then
        notyuri("[Macro Rep] position fallback resolved key", tostring(entry.Key), "->", tostring(best.Name), string.format("(%.1f studs)", bestDist))
        if entry.Key then
            MState.RepMap[entry.Key] = best
        end
    end
    return best
end
local function DoMacroAction(entry)
    if entry.Type == "Place" then
        local cf = entry.CF
        if type(cf) ~= "table" or #cf ~= 12 then return end
        if not (Remotes.CanPlaceTower and Remotes.PlaceTower) then return end
        local allowed = Invoke(Remotes.CanPlaceTower, entry.UnitId)
        if not allowed then
            notyuri("[Macro Rep] Place SKIP: CanPlaceTower rejected", tostring(entry.UnitId))
            return
        end
        local result = Invoke(Remotes.PlaceTower, entry.UnitId, CFrame.new(unpack(cf)))
        if typeof(result) == "Instance" and result:IsA("Model") then
            if entry.Key then
                MState.RepMap[entry.Key] = result
            end
        else
            notyuri("[Macro Rep] Place SKIP: server rejected", tostring(entry.UnitId))
        end
    elseif entry.Type == "Upgrade" then
        local tower = FindTowerForEntry(entry)
        if not (tower and tower.Parent) then
            notyuri("[Macro Rep] Upgrade SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        if not Remotes.UpgradeTower then return end
        local price = tonumber(tower:GetAttribute("UpgradePrice"))
        WaitForCash(price, 5)
        local ok, newTower = Invoke(Remotes.UpgradeTower, tower)
        if ok and typeof(newTower) == "Instance" and newTower:IsA("Model") then
            if entry.Key then
                MState.RepMap[entry.Key] = newTower
            end
        else
            notyuri("[Macro Rep] Upgrade SKIP: server rejected for key", tostring(entry.Key))
        end
    elseif entry.Type == "Sell" then
        local tower = FindTowerForEntry(entry)
        if not (tower and tower.Parent) then
            notyuri("[Macro Rep] Sell SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        if not Remotes.SellTower then return end
        local ok = Invoke(Remotes.SellTower, tower)
        if ok and entry.Key then
            MState.RepMap[entry.Key] = nil
        end
    elseif entry.Type == "Mode" then
        local tower = FindTowerForEntry(entry)
        if not (tower and tower.Parent) then
            notyuri("[Macro Rep] Mode SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        if Remotes.ChangeTargetMode then
            Invoke(Remotes.ChangeTargetMode, tower)
        end
    elseif entry.Type == "Ability" then
        local tower = FindTowerForEntry(entry)
        if not (tower and tower.Parent) then
            notyuri("[Macro Rep] Ability SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        if Remotes.UseTowerAbility then
            Invoke(Remotes.UseTowerAbility, tower)
        end
    end
end
local function Func_MacroReplay()
    while Toggles.LoadMacro.Value do
        local macro = MState.Load
        if not macro or not macro.entries or #macro.entries == 0 then
            Toggles.LoadMacro:SetValue(false)
            Library:Notify("No macro loaded", 3)
            return
        end
        MState.Rep = true
        MState.Total = #macro.entries
        MState.Step = 0
        MState.RepMap = {}
        SortMacroEntries(macro.entries)
        UpdateMacroLabel()
        MState.WaveClock = tick()
        local repWave = GetWave()
        local waveStart = tick()
        local inMatch = IsMatchActive()
        for i, entry in ipairs(macro.entries) do
            if not Toggles.LoadMacro.Value then break end
            local entryWave = select(1, ParseMacroTime(entry))
            if entryWave > 0 then
                if not IsMatchActive() then
                    if inMatch then
                        notyuri("[Macro Rep] match ended mid-pass, aborting pass")
                        break
                    end
                    while Toggles.LoadMacro.Value and not IsMatchActive() do
                        task.wait()
                    end
                    if not Toggles.LoadMacro.Value then break end
                    if not IsMatchActive() then break end
                end
                if not inMatch then
                    inMatch = true
                    repWave = GetWave()
                    waveStart = tick()
                end
            end
            MState.Step = i
            local nextEntry = macro.entries[i + 1]
            local labelSuffix = entry.Type
            if nextEntry then
                labelSuffix = labelSuffix .. " -> " .. nextEntry.Type
            end
            UpdateMacroLabel(labelSuffix, entry.Time)
            local replayMode = Options.ReplayMode and Options.ReplayMode.Value or "Time"
            local skipStep = false
            if replayMode == "Money" then
                local cost = GetMacroEntryCost(entry)
                if cost and cost > 0 then
                    if not WaitForCash(cost) then
                        notyuri("[Macro Rep] money wait aborted (toggle off)")
                    end
                end
            else
                local tWave, tElapsed = ParseMacroTime(entry)
                if tWave == 0 then
                    notyuri("[Macro Rep] intermission entry firing immediately")
                else
                    while Toggles.LoadMacro.Value and GetWave() < tWave do
                        if not IsMatchActive() then break end
                        task.wait()
                        local w = GetWave()
                        if w ~= repWave then
                            repWave = w
                            waveStart = tick()
                        end
                    end
                    if not Toggles.LoadMacro.Value then break end
                    if GetWave() > tWave + 1 then
                        skipStep = true
                    else
                        local elapsed = tick() - waveStart
                        local diff = tElapsed - elapsed
                        if diff > 0 then
                            while Toggles.LoadMacro.Value do
                                if not IsMatchActive() then break end
                                local w = GetWave()
                                if w ~= repWave then
                                    repWave = w
                                    waveStart = tick()
                                end
                                elapsed = tick() - waveStart
                                if elapsed >= tElapsed then break end
                                task.wait()
                            end
                        end
                    end
                end
            end
            if not Toggles.LoadMacro.Value then break end
            if entryWave > 0 and not IsMatchActive() then
                notyuri("[Macro Rep] match ended before entry fired, aborting pass")
                break
            end
            if not skipStep then
                local ok, err = pcall(DoMacroAction, entry)
                if not ok then
                    notyuri("[Macro Rep] action failed:", tostring(err))
                end
                task.wait()
            else
                UpdateMacroLabel("skipped")
                notyuri("[Macro Rep] skipped stale entry", entry.Type, tostring(entry.Time))
            end
        end
        MState.Rep = false
        MState.Step = 0
        UpdateMacroLabel("Finished")
        if Toggles.LoadMacro.Value then
            UpdateMacroLabel("Waiting")
            while Toggles.LoadMacro.Value and IsMatchActive() do
                task.wait()
            end
            while Toggles.LoadMacro.Value and not (IsMatchActive() or IsMatchPending()) do
                task.wait()
            end
        end
    end
    MState.Rep = false
    UpdateMacroLabel()
end
local function GetPlacementBounds()
    if Place.BoundsCache then
        return Place.BoundsCache.MinX, Place.BoundsCache.MaxX, Place.BoundsCache.MinZ, Place.BoundsCache.MaxZ, Place.BoundsCache.TopY
    end
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end
    local target = nil
    local decor = map:FindFirstChild("Decor")
    if decor then
        for _, child in ipairs(decor:GetChildren()) do
            if child:IsA("Model") then
                target = child
                break
            end
        end
    end
    if target then
        local okC, _, size = pcall(target.GetBoundingBox, target)
        local okP, pivot = pcall(target.GetPivot, target)
        if okC and okP and typeof(size) == "Vector3" and typeof(pivot) == "CFrame" then
            Place.BoundsCache = {
                MinX = pivot.Position.X - size.X / 2,
                MaxX = pivot.Position.X + size.X / 2,
                MinZ = pivot.Position.Z - size.Z / 2,
                MaxZ = pivot.Position.Z + size.Z / 2,
                TopY = pivot.Position.Y + size.Y / 2,
            }
            return Place.BoundsCache.MinX, Place.BoundsCache.MaxX, Place.BoundsCache.MinZ, Place.BoundsCache.MaxZ, Place.BoundsCache.TopY
        end
    end
    local minX, maxX, minZ, maxZ, topY = nil, nil, nil, nil, nil
    local count = 0
    for _, part in ipairs(map:GetDescendants()) do
        if part:IsA("BasePart") then
            count = count + 1
            if count <= 5000 then
                local pos = part.Position
                local size = part.Size
                local x1, x2 = pos.X - size.X / 2, pos.X + size.X / 2
                local z1, z2 = pos.Z - size.Z / 2, pos.Z + size.Z / 2
                if minX == nil or x1 < minX then minX = x1 end
                if maxX == nil or x2 > maxX then maxX = x2 end
                if minZ == nil or z1 < minZ then minZ = z1 end
                if maxZ == nil or z2 > maxZ then maxZ = z2 end
                if topY == nil or pos.Y + size.Y / 2 > topY then topY = pos.Y + size.Y / 2 end
            end
        end
    end
    if minX == nil then return nil end
    Place.BoundsCache = {MinX = minX, MaxX = maxX, MinZ = minZ, MaxZ = maxZ, TopY = topY}
    return minX, maxX, minZ, maxZ, topY
end
local function BuildPlacementGrid(spacing)
    local minX, maxX, minZ, maxZ, topY = GetPlacementBounds()
    if not minX then return nil end
    local map = workspace:FindFirstChild("Map")
    local terrain = workspace:FindFirstChild("Terrain")
    if not (map or terrain) then return nil end
    local s = math.clamp(spacing or 4, 3, 12)
    local grid = {}
    local include = {}
    if map then table.insert(include, map) end
    if terrain then table.insert(include, terrain) end
    local done = false
    local batch = 0
    local x = minX + s / 2
    while x <= (maxX - s / 2 + 0.01) and not done do
        local z = minZ + s / 2
        while z <= (maxZ - s / 2 + 0.01) do
            local ok, result = pcall(function()
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Include
                params.FilterDescendantsInstances = include
                return workspace:Raycast(Vector3.new(x, topY + 60, z), Vector3.new(0, -400, 0), params)
            end)
            if ok and result then
                table.insert(grid, {Key = string.format("%.1f,%.1f", x, z), Position = result.Position})
            end
            batch = batch + 1
            if batch >= 100 then
                batch = 0
                task.wait()
            end
            if #grid >= 4000 then
                done = true
                break
            end
            z = z + s
        end
        if done then break end
        x = x + s
    end
    return grid
end
local function GetPlacementGrid()
    local spacing = .5
    local key = tostring(spacing)
    local alive = Place.GridCache and Place.GridCache[1] and Place.GridCache[1].Key ~= nil
    if Place.GridKey ~= key or not alive then
        Place.GridCache = BuildPlacementGrid(spacing)
        Place.GridKey = key
    end
    return Place.GridCache
end
local function ClearExpiredFailPos()
    local now = tick()
    for pos, expiry in pairs(Place.FailPos) do
        if expiry < now then
            Place.FailPos[pos] = nil
        end
    end
end
local function GetSourceOffset(model)
    if typeof(model) ~= "Instance" or not model:IsA("Model") then return nil end
    local okB, bboxCF, bboxSize = pcall(model.GetBoundingBox, model)
    local okP, pivot = pcall(model.GetPivot, model)
    if okB and okP and typeof(bboxCF) == "CFrame" and typeof(bboxSize) == "Vector3" and typeof(pivot) == "CFrame" then
        local off = pivot.Position.Y - (pivot.Position.Y - bboxSize.Y / 2)
        if off == off and off ~= math.huge and off > 0 then
            return off
        end
    end
    local root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("HumanoidPart")
    if root and root:IsA("BasePart") then
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            return root.Size.Y / 2 + humanoid.HipHeight
        end
        local okB2, _, size2 = pcall(model.GetBoundingBox, model)
        if okB2 and typeof(size2) == "Vector3" then
            return size2.Y / 2
        end
    end
    return nil
end
local PCubePool = {
    Free = {},
    Active = {},
}
local function PCubeAcq()
    local part = table.remove(PCubePool.Free)
    if not part then
        part = Instance.new("Part")
        part.Name = "PCube"
        part.Size = Vector3.new(0.5, 0.5, 0.5)
        part.Anchored = true
        part.CanCollide = false
        part.CastShadow = false
        part.Material = Enum.Material.Neon
    end
    part.Transparency = 0.55
    part.Color = Color3.fromRGB(80, 160, 255)
    part.Parent = workspace
    PCubePool.Active[part] = true
    return part
end
local function PCubeRelease(part)
    if not part or not PCubePool.Active[part] then return end
    PCubePool.Active[part] = nil
    part.Parent = nil
    table.insert(PCubePool.Free, part)
end
local function PCubeReleaseAll()
    for part in pairs(PCubePool.Active) do
        PCubePool.Active[part] = nil
        part.Parent = nil
        table.insert(PCubePool.Free, part)
    end
end
local function SavedPosToCF(saved, sourceModel)
    if typeof(saved) ~= "CFrame" then return nil end
    local offset = GetSourceOffset(sourceModel) or 0
    local rot = 0
    local map = workspace:FindFirstChild("Map")
    local terrain = workspace:FindFirstChild("Terrain")
    local include = {}
    if map then table.insert(include, map) end
    if terrain then table.insert(include, terrain) end
    if #include > 0 then
        local _, _, _, _, topY = GetPlacementBounds()
        local originY = (type(topY) == "number" and topY or saved.Position.Y) + 60
        local ok, result = pcall(function()
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Include
            params.FilterDescendantsInstances = include
            return workspace:Raycast(Vector3.new(saved.Position.X, originY, saved.Position.Z), Vector3.new(0, -400, 0), params)
        end)
        if ok and result then
            return CFrame.new(result.Position.X, result.Position.Y + offset, result.Position.Z) * CFrame.Angles(0, math.rad(rot), 0)
        end
    end
    return CFrame.new(saved.Position.X, saved.Position.Y + offset, saved.Position.Z) * CFrame.Angles(0, math.rad(rot), 0)
end
local function GetSpotForTower(unitId)
    local grid = GetPlacementGrid()
    if not grid then return nil, nil end
    ClearExpiredFailPos()
    local towersFolder = GetTowersFolder()
    local towers = towersFolder and towersFolder:GetChildren() or {}
    local placement = Modules.PlacementConfig
    local radius = 0
    if placement then
        local ok, r = pcall(placement.GetRadius, unitId)
        if ok and type(r) == "number" then
            radius = r
        end
    end
    for _, spot in ipairs(grid) do
        if not Place.FailPos[spot.Key] then
            local blocked = false
            if placement then
                local ok, res = pcall(placement.IsBlocked, spot.Position, radius, towers, nil)
                blocked = ok and res == true
            end
            if not blocked then
                return spot
            end
        end
    end
    return nil, nil
end
local CountOwnedByUnitId
local function TryPlaceTower(unitId, slot)
    if type(unitId) ~= "string" or unitId == "" then return false, nil end
    if not (Remotes.CanPlaceTower and Remotes.PlaceTower) then return false, nil end
    local price = GetUnitPrice(unitId)
    if price and GetCash() < price then return false, nil end
    local pause = Place.PauseUntil[unitId] or 0
    if tick() < pause then return false, nil end
    if slot then
        local placeWave = GetSlotPlaceWave(slot)
        if placeWave > 0 and GetWave() < placeWave then return false, nil end
        local slotLimit = GetSlotPlaceLimit(slot)
        if slotLimit > 0 and CountOwnedByUnitId(unitId) >= slotLimit then return false, nil end
    end
    local maxPlaced = tonumber(Plr:GetAttribute("MaxPlacedUnits"))
    if maxPlaced and GetPlacedCount() >= maxPlaced then return false, nil end
    local sourceModel = GetTowerSourceModel(unitId)
    if not sourceModel then return false, nil end
    local allowed = Invoke(Remotes.CanPlaceTower, unitId)
    if not allowed then return false, nil end
    local mapKey = GetCurrentMapKey()
    local savedList = slot and mapKey and Place.SlotPositions[mapKey] and Place.SlotPositions[mapKey][slot]
    local spot, posKey, fromSaved
    local cf
    if savedList and #savedList > 0 then
        cf = SavedPosToCF(savedList[math.random(1, #savedList)], sourceModel)
        fromSaved = true
    else
        spot = GetSpotForTower(unitId)
        if spot then
            posKey = spot.Key
            local offset = GetSourceOffset(sourceModel) or 0
            local rot = 0
            cf = CFrame.new(spot.Position.X, spot.Position.Y + offset, spot.Position.Z) * CFrame.Angles(0, math.rad(rot), 0)
        end
    end
    if not cf then return false, nil end
    local ghost = PCubeAcq()
    ghost.CFrame = cf
    local result = Invoke(Remotes.PlaceTower, unitId, cf)
    if typeof(result) == "Instance" and result:IsA("Model") then
        ghost.Color = Color3.fromRGB(80, 255, 120)
        PCubeRelease(ghost)
        Place.TypeFails[unitId] = 0
        return true, result
    end
    ghost.Color = Color3.fromRGB(255, 80, 80)
    PCubeRelease(ghost)
    if posKey and not fromSaved then
        Place.FailPos[posKey] = tick() + 30
    end
    Place.TypeFails[unitId] = (Place.TypeFails[unitId] or 0) + 1
    if Place.TypeFails[unitId] >= 3 then
        Place.PauseUntil[unitId] = tick() + 10
        Place.TypeFails[unitId] = 0
        notyuri("[AutoPlace] 3 rejects for", unitId, "- pausing 10s")
    end
    return false, nil
end
CountOwnedByUnitId = function(unitId)
    local count = 0
    for _, tower in ipairs(GetOwnedTowers()) do
        if GetTowerUnitId(tower) == unitId then count = count + 1 end
    end
    return count
end
local function GetSelectedTowerSlots()
    local selected = {}
    local hasAny = false
    if PlaceTowersGetSelection then
        selected = PlaceTowersGetSelection()
        for _ in pairs(selected) do hasAny = true break end
    end
    local slotByUnit = GetSlotByUnitName()
    local list = {}
    for unitId, slot in pairs(slotByUnit) do
        if not hasAny or selected[unitId] then
            table.insert(list, {unitId = unitId, slot = slot})
        end
    end
    table.sort(list, function(a, b)
        local sa = a.slot and GetSlotOrder(a.slot) or 99
        local sb = b.slot and GetSlotOrder(b.slot) or 99
        if sa ~= sb then return sa < sb end
        return a.unitId < b.unitId
    end)
    return list
end
local function TryUpgradeOnce(tower)
    local reserve = 0
    local price = tonumber(tower:GetAttribute("UpgradePrice"))
    if not price then return false, nil end
    if (GetCash() - reserve) < price then return false, nil end
    local ok, newTower = Invoke(Remotes.UpgradeTower, tower)
    if ok and typeof(newTower) == "Instance" then
        return true, newTower
    end
    return false, nil
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local ok, err = pcall(function()
            if not (IsGamePlace() and Remotes.PlaceTower and Remotes.CanPlaceTower and IsMatchActive()) then return end
            local maxPlaced = tonumber(Plr:GetAttribute("MaxPlacedUnits"))
            if maxPlaced and GetPlacedCount() >= maxPlaced then return end
            for _, entry in ipairs(GetSelectedTowerSlots()) do
                if not (Toggles.AutoPlace.Value and IsMatchActive()) then return end
                if maxPlaced and GetPlacedCount() >= maxPlaced then return end
                local placed, tower = TryPlaceTower(entry.unitId, entry.slot)
                if placed then
                    notyuri("[AutoPlace] placed", entry.unitId, "slot", tostring(entry.slot))
                    if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value and tower then
                        local upgLimit = entry.slot and GetSlotUpgradeLimit(entry.slot) or 0
                        for _ = 1, 20 do
                            if not (Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value) then break end
                            if upgLimit > 0 and (GetTowerLevel(tower) or 0) >= upgLimit then break end
                            local upgraded, newTower = TryUpgradeOnce(tower)
                            if not upgraded then break end
                            tower = newTower or tower
                            task.wait()
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
        if not ok then
            notyuri("[AutoPlace] error:", tostring(err))
        end
        task.wait(1)
    end
end
local function GetUpgradableTowers()
    local slotByUnit = GetSlotByUnitName()
    local result = {}
    for _, tower in ipairs(GetOwnedTowers()) do
        local unitId = GetTowerUnitId(tower)
        local slot = slotByUnit[unitId]
        local upgLimit = slot and GetSlotUpgradeLimit(slot) or 0
        local level = GetTowerLevel(tower) or 0
        if upgLimit <= 0 or level < upgLimit then
            local price = tonumber(tower:GetAttribute("UpgradePrice"))
            if price then
                table.insert(result, { model = tower, slot = slot, level = level, unitId = unitId, price = price })
            end
        end
    end
    return result
end
local function UpgradeCand(units)
    local method = Options.UpgradeMethod and Options.UpgradeMethod.Value or "Lowest Level (Spread Upgrade)"
    if #units == 0 then return nil end
    if method == "Randomize" then
        return units[math.random(1, #units)]
    elseif method == "Hotbar left to right (until Max)" or method == "Customize upgrade order (Set below)" then
        table.sort(units, function(a, b)
            local sa = a.slot and GetSlotOrder(a.slot) or 99
            local sb = b.slot and GetSlotOrder(b.slot) or 99
            if sa ~= sb then return sa < sb end
            return a.level < b.level
        end)
        return units[1]
    end
    table.sort(units, function(a, b) return a.level < b.level end)
    return units[1]
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local ok, err = pcall(function()
            if not (IsGamePlace() and Remotes.UpgradeTower and IsMatchActive()) then return end
            local reserve = 0
            local units = GetUpgradableTowers()
            local target = UpgradeCand(units)
            if not target then return end
            if (GetCash() - reserve) < target.price then return end
            local okUp, newTower = Invoke(Remotes.UpgradeTower, target.model)
            if okUp and typeof(newTower) == "Instance" then
                notyuri("[AutoUpgrade] upgraded", target.unitId, "slot", tostring(target.slot))
            end
        end)
        if not ok then
            notyuri("[AutoUpgrade] error:", tostring(err))
        end
        task.wait()
    end
end
local function Func_AutoAbility()
    while Toggles.AutoAbility.Value do
        if IsGamePlace() and Remotes.UseTowerAbility and IsMatchActive() and Modules.TowerAbilityConfig then
            for _, tower in ipairs(GetOwnedTowers()) do
                if Toggles.AutoAbility.Value and tower.Parent and IsMatchActive() then
                    local unitId = GetTowerUnitId(tower)
                    local level = GetTowerLevel(tower)
                    local okDef, def = pcall(Modules.TowerAbilityConfig.get, unitId, level)
                    if okDef and type(def) == "table" then
                        local price = tonumber(def.Price) or 0
                        if GetCash() >= price then
                            local last = Memo.AbilityAt[tower] or 0
                            if tick() - last > 3 and GetAbilityCooldownRemaining(tower) <= 0 then
                                local ok, endsAt = Invoke(Remotes.UseTowerAbility, tower)
                                if ok then
                                    Memo.AbilityAt[tower] = tick()
                                    if type(endsAt) == "number" then
                                        tower:SetAttribute("AbilityCooldownEndsAt", endsAt)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoSkip()
    while Toggles.AutoSkip.Value do
        if IsGamePlace() and Remotes.SkipWaveVote then
            local ws = GetWaveState()
            if ws then
                local wave = tonumber(ws:GetAttribute("CurrentWave"))
                local result = tostring(ws:GetAttribute("Result") or "")
                local canSkip = ws:GetAttribute("CanSkipWave") == true
                if canSkip and type(wave) == "number" and result ~= "Win" and result ~= "Lose" then
                    if Plr:GetAttribute("SkipVoteWave") ~= wave and Memo.SkipWave ~= wave then
                        Memo.SkipWave = wave
                        Fire(Remotes.SkipWaveVote, wave)
                        notyuri("[AutoSkip] vote fired for wave", tostring(wave))
                    end
                end
            end
        end
        task.wait()
    end
end
local DifficultyLabelToId = {}
local DifficultyDropdownLabels = {}
if Modules.ModeVoteConfig then
    for _, mode in ipairs(Modules.ModeVoteConfig.Modes) do
        table.insert(DifficultyDropdownLabels, mode.DisplayName)
        DifficultyLabelToId[mode.DisplayName] = mode.Id
    end
end
local function Func_AutoVoteDifficulty()
    while Toggles.AutoVoteDifficulty.Value do
        local cfg = Modules.ModeVoteConfig
        local folder = cfg and RS:FindFirstChild(cfg.FolderName)
        local remote = folder and folder:FindFirstChild(cfg.RemoteName)
        local votes = folder and folder:FindFirstChild(cfg.VotesFolderName)
        local label = Options.VoteDifficulty and Options.VoteDifficulty.Value
        local modeId = label and DifficultyLabelToId[label]
        if remote and votes and modeId and folder:GetAttribute("Active") == true then
            local myVote = votes:FindFirstChild(tostring(Plr.UserId))
            local voted = myVote and myVote:IsA("StringValue") and myVote.Value == modeId
            if not voted and tick() - Memo.DifficultyAt > 1 then
                Memo.DifficultyAt = tick()
                Fire(remote, modeId)
                notyuri("[AutoVoteDifficulty] vote fired", tostring(modeId))
            end
        end
        task.wait(0.25)
    end
end
local function ApplyGameSpeed()
    if not Remotes.SetGameSpeed then return false end
    local target = tonumber(Options.SpeedTarget and Options.SpeedTarget.Value)
    if not target then return false end
    local ws = GetWaveState()
    local current = tonumber(ws and ws:GetAttribute("GameSpeed"))
    if current and current >= target - 0.001 then return true end
    if tick() - Memo.SpeedAt < 1 then return false end
    Memo.SpeedAt = tick()
    Fire(Remotes.SetGameSpeed, target)
    return true
end
local function Func_AutoSpeed()
    while Toggles.AutoSpeed.Value do
        if IsGamePlace() then
            pcall(ApplyGameSpeed)
        end
        task.wait(0.5)
    end
end
local yuri = {
    "https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
    "https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
    "https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/233/thumbnail.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/328/thumbnail.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1339/thumbnail.jpeg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1268/thumbnail.jpeg",
    "https://dynasty-scans.com/system/releases/000/040/979/001.webp",
    "https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2026/02/01/15/33/44/140636490_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2019/12/01/21/59/30/78092730_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2022/08/15/23/52/23/100515820_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2025/07/22/17/09/45/132989170_p0_master1200.jpg",
}
local function SendWebhook(title, description)
    if not request then return end
    local url = (Options.WebhookURL and Options.WebhookURL.Value) or ""
    if url == "" then return end
    local img = yuri[math.random(1, #yuri)]
    pcall(function()
        request({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                username = "Yuri",
                avatar_url = img,
                embeds = {
                    {
                        title = title,
                        description = description,
                        color = 0xFFB6C1,
                        thumbnail = { url = img },
                    },
                },
            }),
        })
    end)
end
local function BuildMatchContext()
    local ws = GetWaveState()
    local result = tostring((ws and ws:GetAttribute("Result")) or "")
    local function playerNum(name)
        return tonumber(Plr:GetAttribute(name))
    end
    local function isNum(v)
        return type(v) == "number" and v == v
    end
    local function sumAttrs(base, extra)
        local v = playerNum(base)
        local n = isNum(v) and v or 0
        local e = playerNum(extra)
        n = n + (isNum(e) and e or 0)
        return n
    end
    local ctx = {
        Result = result,
        IsWin = result == "Win",
        IsEndless = (ws and ws:GetAttribute("IsEndless")) == true,
        MapId = tostring((ws and ws:GetAttribute("MapId")) or ""),
        MapName = tostring((ws and ws:GetAttribute("MapDisplayName")) or ""),
        Mode = tostring((ws and ws:GetAttribute("MapMode")) or ""),
        Wave = GetWave(),
    }
    local bonus = ctx.IsEndless and (playerNum("MatchBonusCoins") or 0) or 0
    ctx.Coins = (playerNum("MatchRewardCoins") or 0) + bonus
    ctx.Xp = sumAttrs("MatchRewardXp", "EndlessRewardXp")
    ctx.Tickets = sumAttrs("MatchRewardTickets", "EndlessRewardTickets")
    ctx.Crates = sumAttrs("MatchRewardFreeCrates", "EndlessRewardFreeCrates")
    ctx.SummonDiscount = playerNum("EndlessRewardSummonDiscount") or 0
    ctx.Confetti = sumAttrs("MatchRewardConfetti", "EndlessRewardConfetti")
    ctx.LimitedUnit = tostring(Plr:GetAttribute("MatchRewardLimitedUnit") or "")
    local coinMult = playerNum("MatchRewardCoinMultiplier")
    if coinMult == nil then
        coinMult = playerNum("MatchCoinMultiplier") or 0
    end
    ctx.CoinMultiplier = math.max(1, coinMult)
    local streak = playerNum("MatchWinStreak")
    if streak == nil then
        streak = playerNum("WinStreak") or 0
    end
    ctx.WinStreak = math.max(0, math.floor(streak))
    local elapsed = tonumber(ws and ws:GetAttribute("ElapsedSeconds"))
    ctx.ElapsedSeconds = isNum(elapsed) and elapsed or 0
    return ctx
end
local function ContextSignature(ctx)
    return table.concat({ctx.Coins, ctx.Xp, ctx.Tickets, ctx.Crates, ctx.SummonDiscount, ctx.Confetti, ctx.WinStreak, ctx.LimitedUnit, ctx.ElapsedSeconds}, "|")
end
local function SendMatchEndWebhook(outcome)
    task.wait(0.5)
    local startT = tick()
    local last = BuildMatchContext()
    while tick() - startT < 2 do
        task.wait()
        local current = BuildMatchContext()
        if ContextSignature(current) == ContextSignature(last) then
            last = current
            break
        end
        last = current
    end
    local ctx = last
    local rows = {}
    if ctx.IsWin and ctx.LimitedUnit ~= "" then
        table.insert(rows, "+LIMITED! " .. ctx.LimitedUnit)
    end
    if ctx.Coins > 0 then
        table.insert(rows, string.format("+%d Coins", math.floor(ctx.Coins + 0.5)))
    end
    if ctx.Xp > 0 then
        table.insert(rows, string.format("+%d XP", math.floor(ctx.Xp + 0.5)))
    end
    if ctx.IsWin and ctx.Tickets > 0 then
        table.insert(rows, string.format("+%d Tickets", math.floor(ctx.Tickets + 0.5)))
    end
    if ctx.IsWin and ctx.Crates > 0 then
        table.insert(rows, string.format("+%d Crates", math.floor(ctx.Crates + 0.5)))
    end
    table.insert(rows, string.format("+%d Summon Discount", math.floor(ctx.SummonDiscount + 0.5)))
    if ctx.IsWin and ctx.Confetti > 0 then
        table.insert(rows, string.format("+%d Confetti", math.floor(ctx.Confetti + 0.5)))
    end
    local mapLabel = ctx.MapName ~= "" and ctx.MapName or (ctx.MapId ~= "" and ctx.MapId or "???")
    local modeLabel = ctx.Mode ~= "" and ctx.Mode or "?"
    local mins = math.floor(ctx.ElapsedSeconds / 60)
    local secs = math.floor(ctx.ElapsedSeconds % 60)
    local desc = string.format(
        "**Match Finished - %s**\n- Map: %s (%s)\n- Wave: %d\n- Time: %d:%02d\n- Player: ||%s||\n- Win Streak: %d\n- Coin Multiplier: x%s\n- Rewards:\n%s",
        outcome, mapLabel, modeLabel, ctx.Wave, mins, secs, Plr.Name, ctx.WinStreak, tostring(ctx.CoinMultiplier), table.concat(rows, "\n")
    )
    SendWebhook("Match Finished", desc)
    notyuri("[Webhook] match finished notification sent:", outcome)
end
local function OnEndState()
    local ws = GetWaveState()
    if not ws then return end
    local result = tostring(ws:GetAttribute("Result") or "")
    if result ~= "Win" and result ~= "Lose" then return end
    if Toggles.WHMatchEnd and Toggles.WHMatchEnd.Value then
        local matchKey = tostring(ws:GetAttribute("StartedAt")) .. "|" .. result
        if Memo.WHKey ~= matchKey then
            Memo.WHKey = matchKey
            local outcome = result == "Win" and "Victory" or "Defeat"
            task.spawn(SendMatchEndWebhook, outcome)
        end
    end
    if Toggles.AutoReplay and Toggles.AutoReplay.Value and Remotes.ReplayVote then
        local round = tonumber(ws:GetAttribute("ReplayVoteRound"))
        local playerRound = tonumber(Plr:GetAttribute("ReplayVoteRound"))
        local votes = tonumber(ws:GetAttribute("ReplayVotes")) or 0
        local required = tonumber(ws:GetAttribute("ReplayVotesRequired")) or 1
        local voted = (type(round) == "number" and round > 0 and playerRound == round)
        if not voted and votes < required and tick() - Memo.ReplayAt > 2 then
            Memo.ReplayAt = tick()
            Fire(Remotes.ReplayVote)
            notyuri("[AutoReplay] replay vote sent")
        end
    end
    if Toggles.AutoReturnLobby and Toggles.AutoReturnLobby.Value and Remotes.ReturnToLobby then
        if not (Toggles.AutoReplay and Toggles.AutoReplay.Value) then
            local matchKey = tostring(ws:GetAttribute("StartedAt"))
            if Memo.ReturnAt ~= matchKey then
                Memo.ReturnAt = matchKey
                task.delay(1, function()
                    if Toggles.AutoReturnLobby and Toggles.AutoReturnLobby.Value and Remotes.ReturnToLobby then
                        Fire(Remotes.ReturnToLobby)
                        notyuri("[AutoReturnLobby] return fired")
                    end
                end)
            end
        end
    end
end
local function OnContinueVote()
    if not (Toggles.AutoContinue and Toggles.AutoContinue.Value) then return end
    if not Remotes.ContinueEndlessVote then return end
    local ws = GetWaveState()
    if not ws then return end
    if tostring(ws:GetAttribute("MatchState") or "") ~= "ContinueVote" then return end
    local endsAt = tonumber(ws:GetAttribute("ContinueVoteEndsAt")) or 0
    if Memo.ContinueAt == endsAt and tick() - Memo.ContinueAtTime < 5 then return end
    Memo.ContinueAt = endsAt
    Memo.ContinueAtTime = tick()
    Fire(Remotes.ContinueEndlessVote, true)
    notyuri("[AutoContinue] continue vote sent")
end
local function Func_EndStates()
    while (Toggles.AutoReplay and Toggles.AutoReplay.Value)
        or (Toggles.AutoContinue and Toggles.AutoContinue.Value)
        or (Toggles.AutoReturn and Toggles.AutoReturn.Value) do
        if IsGamePlace() then
            pcall(OnEndState)
            pcall(OnContinueVote)
        end
        task.wait(0.5)
    end
end
local JoinQueueRemote = nil
local function GetJoinQueueRemote()
    if JoinQueueRemote then return JoinQueueRemote end
    local ok, remote = pcall(function()
        return game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.MatchmakingService.RF.JoinQueue
    end)
    if ok and remote then
        JoinQueueRemote = remote
    end
    return JoinQueueRemote
end
local MapLabelToId = {}
local MapDropdownLabels = {}
if Modules.MapConfig then
    for _, map in ipairs(Modules.MapConfig.GetAll()) do
        table.insert(MapDropdownLabels, map.DisplayName)
        MapLabelToId[map.DisplayName] = map.Id
    end
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        if IsLobbyPlace() then
            local remote = GetJoinQueueRemote()
            local label = Options.SelectedMap and Options.SelectedMap.Value
            local mapId = (label and MapLabelToId[label]) or "City"
            if remote then
                Invoke(remote, mapId, 1)
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoSummon()
    while Toggles.AutoSummon.Value do
        if IsLobbyPlace() and Remotes.SummonUnits then
            local amount = tonumber(Options.SummonAmount and Options.SummonAmount.Value) or 1
            local result = Invoke(Remotes.SummonUnits, amount)
        end
        task.wait(.1)
    end
end
local Fish = {
    State = "Idle",
    Luck = nil,
    Minigame = nil,
    LastEventAt = 0,
    CastAt = 0,
    HoldAt = 0,
    CatchAt = 0,
    ZoneTpAt = 0,
    NoWaterAt = 0,
    ErrAt = 0,
    Session = 0,
    LastCatch = nil,
    LastLuck = nil,
    LabelRef = nil,
    Conn = nil,
    SellOne = {},
    Selling = false,
    BodyPos = nil,
    LockedHRP = nil,
}
local LuckFillTargets = {
    ["Perfect (x2)"] = 1.0,
    ["High (x1.63)"] = 0.75,
    ["Middle (x1.25)"] = 0.5,
    ["Instant"] = 0,
}
local function GetFishingConfigModule()
    if Modules.FishingConfig ~= nil then return Modules.FishingConfig end
    local folder = RS:FindFirstChild("Fishing")
    if not folder then return nil end
    local config = GetSafeModule(folder, "FishingConfig")
    if type(config) == "table" then
        Modules.FishingConfig = config
        return config
    end
    return nil
end
local function GetBoatTeleportRemote()
    if Remotes.BoatTeleportRemote then return Remotes.BoatTeleportRemote end
    local remote = GetSafeRemote(RS, "BoatTeleportRemote")
    if remote then Remotes.BoatTeleportRemote = remote end
    return Remotes.BoatTeleportRemote
end
local function ConnectFishingEvents()
    if Fish.Conn then return end
    if not IsLobbyPlace() then return end
    local folder = RS:FindFirstChild("Fishing")
    if not folder then
        folder = RS:WaitForChild("Fishing", 10)
    end
    if not folder then return end
    local remotesFolder = folder:FindFirstChild("Remotes")
    if not remotesFolder then
        remotesFolder = folder:WaitForChild("Remotes", 5)
    end
    if not remotesFolder then return end
    local fe = GetSafeRemote(remotesFolder, "FishingEvent")
    local ff = GetSafeRemote(remotesFolder, "FishingFunction")
    if fe then Remotes.FishingEvent = fe end
    if ff then Remotes.FishingFunction = ff end
    GetBoatTeleportRemote()
    GetFishingConfigModule()
    if Remotes.FishingEvent and not Fish.Conn then
        Fish.Conn = Remotes.FishingEvent.OnClientEvent:Connect(function(action, data)
            local ok, err = pcall(function()
                data = data or {}
                Fish.LastEventAt = tick()
                if action == "CastStarted" then
                    Fish.State = "Luck"
                    Fish.Luck = data.Luck
                    Fish.Minigame = nil
                elseif action == "LuckHeld" then
                    if type(Fish.Luck) == "table" then
                        if data.HoldStart then Fish.Luck.HoldStart = data.HoldStart end
                        if data.Speed then Fish.Luck.Speed = data.Speed end
                    end
                elseif action == "LuckLocked" then
                    Fish.State = "Waiting"
                    Fish.Luck = nil
                    Fish.LastLuck = tonumber(data.Luck)
                elseif action == "Target" then
                    Fish.State = "Minigame"
                    Fish.Minigame = data
                elseif action == "StageHit" then
                    Fish.State = "Transition"
                    Fish.Minigame = nil
                elseif action == "Catch" then
                    Fish.State = "Catching"
                    Fish.CatchAt = tick()
                    Fish.Minigame = nil
                    Fish.Session = Fish.Session + 1
                    if data.Nothing then
                        Fish.LastCatch = "Nothing"
                    elseif data.Crate then
                        Fish.LastCatch = tostring(data.Crate) .. " crate"
                    elseif data.Fish then
                        Fish.LastCatch = tostring(data.Fish)
                    end
                elseif action == "Reset" then
                    Fish.State = "Idle"
                    Fish.Minigame = nil
                    Fish.Luck = nil
                end
            end)
            if not ok then
                warn("[Fishing] event error: " .. tostring(err))
            end
        end)
    end
end
local function FindWaterPosition()
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local cfg = Modules.FishingConfig
    local af = (type(cfg) == "table" and type(cfg.AutoFish) == "table") and cfg.AutoFish or {}
    local distances = af.CastDistances or { 25, 35, 45, 18, 55 }
    local angles = af.CastAngles or { 0, 25, -25, 50, -50, 80, -80, 120, -120, 180 }
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = { workspace.Terrain }
    params.IgnoreWater = false
    local look = hrp.CFrame.LookVector
    local flat = Vector3.new(look.X, 0, look.Z)
    if flat.Magnitude < 0.01 then
        flat = Vector3.new(0, 0, -1)
    end
    flat = flat.Unit
    for _, angle in ipairs(angles) do
        local dir = CFrame.Angles(0, math.rad(angle), 0):VectorToWorldSpace(flat)
        for _, dist in ipairs(distances) do
            local origin = hrp.Position + dir * dist + Vector3.new(0, 60, 0)
            local result = workspace:Raycast(origin, Vector3.new(0, -120, 0), params)
            if result and result.Material == Enum.Material.Water then
                return result.Position
            end
        end
    end
    return nil
end
local function GetLuckTargetFill()
    return LuckFillTargets["Perfect (x2)"]
end
local function FishStepLuckRelease()
    local luck = Fish.Luck
    if not (type(luck) == "table" and luck.HoldStart and luck.Speed) then
        if tick() - (Fish.HoldAt or 0) > 3 then
            Fire(Remotes.FishingEvent, "Cancel", {})
            Fish.State = "Idle"
        end
        return
    end
    local target = GetLuckTargetFill()
    if target <= 0 then
        Fire(Remotes.FishingEvent, "LuckRelease", { ClickTime = workspace:GetServerTimeNow() })
        Fish.State = "LuckLocking"
        return
    end
    local speed = math.max(luck.Speed, 0.0001)
    local now = workspace:GetServerTimeNow()
    local elapsed = math.max(0, now - luck.HoldStart)
    local currentCycle = math.floor(elapsed * speed / 2)
    local candidate = (target + currentCycle * 2) / speed
    if candidate <= elapsed then
        candidate = (target + (currentCycle + 1) * 2) / speed
    end
    local waitTime = candidate - elapsed
    if waitTime > 0 then
        task.wait(waitTime)
    end
    if Fish.State ~= "LuckHeld" or luck ~= Fish.Luck then
        return
    end
    Fire(Remotes.FishingEvent, "LuckRelease", { ClickTime = workspace:GetServerTimeNow() })
    Fish.State = "LuckLocking"
end
local function GetActiveSecretFishZone()
    local stream = workspace:FindFirstChild("SecretFishZoneStream")
    local part = stream and stream:FindFirstChild("SecretFishZone")
    if not part or not part:IsA("BasePart") then return nil end
    if part:GetAttribute("Active") ~= true then return nil end
    local endsAt = tonumber(part:GetAttribute("EndsAt")) or 0
    if workspace:GetServerTimeNow() >= endsAt then return nil end
    return part
end
local function BodyLock(hrp, bool)
    if not bool then
        if Fish.BodyPos then
            pcall(function() Fish.BodyPos:Destroy() end)
            Fish.BodyPos = nil
        end
        Fish.LockedHRP = nil
        return
    end
    if not hrp then return end
    if Fish.BodyPos and Fish.LockedHRP == hrp and Fish.BodyPos.Parent == hrp then
        Fish.BodyPos.Position = hrp.Position
        return
    end
    BodyLock(nil, false)
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bp.P = 1e4
    bp.D = 500
    bp.Position = hrp.Position
    bp.Parent = hrp
    Fish.BodyPos = bp
    Fish.LockedHRP = hrp
end
local function FishStep()
    if not IsLobbyPlace() then return end
    if Fish.Selling then
        return
    end
    if not Remotes.FishingEvent then
        ConnectFishingEvents()
        if not Remotes.FishingEvent then return end
    end
    local data = Plr:WaitForChild("PlayerGui"):FindFirstChild("FishingData")
    if not data then return end
    local bossZone = GetActiveSecretFishZone()
    local spot = bossZone and (bossZone.Position + Vector3.new(0, 5, 0)) or Vector3.new(-6828, 31, 1039)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local dist = hrp and (hrp.Position - spot).Magnitude
    local inZone = hrp and dist <= 30
    if not inZone then
        BodyLock(nil, false)
        if bossZone or (Toggles.FishAutoZone and Toggles.FishAutoZone.Value) then
            if tick() - (Fish.ZoneTpAt or 0) > 2 then
                local remote = GetBoatTeleportRemote()
                if remote then
                    notyuri(bossZone and "[BossZone] Boss fish active, teleporting" or "[FishAutoZone] Not in zone, dist=", tostring(dist), "teleporting")
                    Fish.ZoneTpAt = tick()
                    TPTo(spot)
                end
            end
        end
        return
    end
    BodyLock(hrp, true)
    local state = Fish.State
    if state == "Catching" and tick() - (Fish.CatchAt or 0) > .2 then
        Fish.State = "Idle"
        state = "Idle"
    elseif state == "Waiting" and tick() - (Fish.LastEventAt or 0) > 6 then
        Fire(Remotes.FishingEvent, "Cancel", {})
        Fish.State = "Idle"
        state = "Idle"
    elseif state == "CastSent" and tick() - (Fish.CastAt or 0) > 2 then
        Fish.State = "Idle"
        state = "Idle"
    elseif (state == "Hitting" or state == "Transition" or state == "LuckLocking") and tick() - (Fish.LastEventAt or 0) > 3 then
        Fish.State = "Idle"
        state = "Idle"
    end
    if state == "Idle" then
        local pos = FindWaterPosition()
        if pos then
            Fire(Remotes.FishingEvent, "Cast", { Position = pos })
            Fish.State = "CastSent"
            Fish.CastAt = tick()
        else
            if tick() - (Fish.NoWaterAt or 0) > 5 then
                Fish.NoWaterAt = tick()
                Library:Notify("no water found nearby", 5)
            end
            return
        end
    elseif state == "Luck" then
        local luck = Fish.Luck
        if type(luck) == "table" and luck.StartTime then
            if workspace:GetServerTimeNow() >= luck.StartTime then
                Fire(Remotes.FishingEvent, "LuckHold", { ClickTime = workspace:GetServerTimeNow() })
                Fish.State = "LuckHeld"
                Fish.HoldAt = tick()
            end
        elseif tick() - (Fish.CastAt or 0) > 3 then
            Fire(Remotes.FishingEvent, "Cancel", {})
            Fish.State = "Idle"
        end
    elseif state == "LuckHeld" then
        return FishStepLuckRelease()
    elseif state == "Minigame" then
        local mg = Fish.Minigame
        if mg and mg.Index then
            local startAt = tonumber(mg.StartTime) or 0
            if workspace:GetServerTimeNow() >= startAt then
                Fire(Remotes.FishingEvent, "Hit", { Index = mg.Index })
                Fish.Minigame = nil
                Fish.State = "Hitting"
            end
        else
            Fish.State = "Hitting"
        end
    end
end
local function Func_AutoFish()
    while Toggles.AutoFish and Toggles.AutoFish.Value do
        local ok, err = pcall(FishStep)
        if not ok then
            if tick() - (Fish.ErrAt or 0) > 5 then
                Fish.ErrAt = tick()
                Library:Notify("Error in" .. tostring(err), 8)
            end
        end
        task.wait()
    end
    BodyLock(nil, false)
end
local function IsInsideCylinder(part, pos, verticalTolerance)
    if not part or not part:IsA("BasePart") or typeof(pos) ~= "Vector3" then return false end
    local rel = part.CFrame:PointToObjectSpace(pos)
    local radial = (rel.Y / math.max(part.Size.Y * 0.5, 0.001)) ^ 2 + (rel.Z / math.max(part.Size.Z * 0.5, 0.001)) ^ 2
    if math.abs(rel.X) > verticalTolerance then return false end
    return radial <= 1
end
local function GetFishShopAuraPart()
    local cfg = Modules.FishingConfig
    local shopCfg = type(cfg) == "table" and cfg.Shop or nil
    local auraPath = type(shopCfg) == "table" and shopCfg.AuraPath or nil
    if not auraPath then return nil, nil end
    local fishingFolder = workspace:FindFirstChild("Fishing")
    if not fishingFolder then return nil, shopCfg end
    local part = fishingFolder
    for _, name in ipairs(auraPath) do
        part = part and part:FindFirstChild(name)
    end
    return part, shopCfg
end
local function EnsureAtFishShop()
    local part, shopCfg = GetFishShopAuraPart()
    if not part or not shopCfg then return false end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local tolerance = tonumber(shopCfg.AuraVerticalTolerance) or 6
    if IsInsideCylinder(part, hrp.Position, tolerance) then return true end
    notyuri("Out of range of fish shop, teleporting")
    return TPTo(part)
end
local function Func_AutoSellFish()
    while Toggles.AutoSellFish and Toggles.AutoSellFish.Value do
        local ok, err = pcall(function()
            if not IsLobbyPlace() then return end
            if not Remotes.FishingFunction then
                ConnectFishingEvents()
                if not Remotes.FishingFunction then return end
            end
            local data = Plr:WaitForChild("PlayerGui"):FindFirstChild("FishingData")
            local fishFolder = data and data:FindFirstChild("Fish")
            if not fishFolder then return end
            local sellFish = SellFishGetSelection and SellFishGetSelection() or {}
            local threshold = tonumber(Options.SellFishThreshold and Options.SellFishThreshold.Value) or 0
            local toSell = {}
            local totalSellable = 0
            for _, fv in ipairs(fishFolder:GetChildren()) do
                if fv:IsA("IntValue") then
                    local name = fv.Name
                    if (fv.Value or 0) > 0 and sellFish[name] then
                        local sellable = fv.Value or 0
                        if sellable > 0 then
                            toSell[name] = sellable
                            totalSellable = totalSellable + sellable
                        end
                    end
                end
            end
            if totalSellable > 0 and totalSellable >= threshold then
                Fish.Selling = true
                if not EnsureAtFishShop() then
                    notyuri("Could not reach fish shop, skipping sell")
                    Fish.Selling = false
                    return
                end
                for name, amount in pairs(toSell) do
                    Invoke(Remotes.FishingFunction, "SellFish", { Fish = name, Amount = amount })
                end
                Fish.Selling = false
            end
        end)
        if not ok then
            Fish.Selling = false
            Library:Notify("Error in: " .. tostring(err), 8)
        end
        task.wait()
    end
end
local function Func_AutoCraft()
    while Toggles.AutoCraft and Toggles.AutoCraft.Value do
        local ok, err = pcall(function()
            if not IsLobbyPlace() then return end
            if not Remotes.FishingFunction then
                ConnectFishingEvents()
                if not Remotes.FishingFunction then return end
            end
            if not Remotes.FishingFunction or type(Modules.FishingConfig) ~= "table" then return end
            local cfg = Modules.FishingConfig
            local data = Plr:WaitForChild("PlayerGui"):FindFirstChild("FishingData")
            local fishFolder = data and data:FindFirstChild("Fish")
            if not fishFolder then return end
            local coinsObj = data:FindFirstChild("FishingCoins")
            local coinsValue = (coinsObj and coinsObj.Value) or 0
            for recipeIndex, recipe in ipairs(cfg.Crafts or {}) do
                if type(recipe) == "table" and recipe.Cost and coinsValue >= recipe.Cost then
                    local canCraft = true
                    for _, input in ipairs(recipe.Inputs or {}) do
                        local fv = fishFolder:FindFirstChild(input.Fish or "")
                        if not fv or ((fv.Value or 0) < (tonumber(input.Amount) or 0)) then
                            canCraft = false
                            break
                        end
                    end
                    if canCraft then
                        local result = Invoke(Remotes.FishingFunction, "Craft", { Recipe = recipeIndex })
                        if result == false and recipe.Name then
                            result = Invoke(Remotes.FishingFunction, "Craft", { Recipe = recipe.Name })
                        end
                        if result ~= false then
                            Library:Notify("crafted " .. tostring(recipe.Name or recipeIndex), 5)
                        end
                        task.wait(0.3)
                        local freshCoins = data:FindFirstChild("FishingCoins")
                        coinsValue = (freshCoins and freshCoins.Value) or coinsValue
                    end
                end
            end
        end)
        if not ok then
            Library:Notify("Error in: " .. tostring(err), 8)
            task.wait(1)
        end
        task.wait(2)
    end
end
local function EnsureAtBoatShop()
    local cfg = Modules.FishingConfig
    local boatCfg = type(cfg) == "table" and cfg.Boat or nil
    local merchantPath = type(boatCfg) == "table" and boatCfg.MerchantPath or nil
    if not merchantPath then
        notyuri("FishingConfig.Boat.MerchantPath missing")
        return false
    end
    local fishingFolder = workspace:FindFirstChild("Fishing")
    local part = fishingFolder
    for _, name in ipairs(merchantPath) do
        part = part and part:FindFirstChild(name)
    end
    if not part then
        notyuri("Merchant part not found in workspace.Fishing")
        return false
    end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local dist = (hrp.Position - part.Position).Magnitude
    local shopDistance = tonumber(boatCfg.ShopDistance) or 18
    if dist <= shopDistance then return true end
    notyuri("Too far from boat shop (" .. tostring(math.floor(dist)) .. " studs), teleporting")
    return TPTo(part)
end
local function Func_BuyRod()
    while Toggles.BuyRod and Toggles.BuyRod.Value do
        local ok, err = pcall(function()
            if not (IsLobbyPlace() and Remotes.FishingFunction) then
                ConnectFishingEvents()
            end
            if not (IsLobbyPlace() and Remotes.FishingFunction) then
                notyuri("Shop remote not found, IsLobbyPlace=", tostring(IsLobbyPlace()))
                return
            end
            local cfg = GetFishingConfigModule()
            if not (type(cfg) == "table" and type(cfg.RodOrder) == "table") then
                notyuri("FishingConfig or RodOrder missing")
                return
            end
            local data = Plr:WaitForChild("PlayerGui"):FindFirstChild("FishingData")
            if not data then
                notyuri("No FishingData found on player")
                return
            end
            local level = data:FindFirstChild("Level")
            local levelValue = (level and level.Value) or 0
            local coins = data:FindFirstChild("FishingCoins")
            local coinsValue = (coins and coins.Value) or 0
            local owned = data:FindFirstChild("OwnedRods")
            local equipped = data:FindFirstChild("EquippedRod")
            local equippedValue = equipped and equipped.Value
            notyuri("level=", tostring(levelValue), "coins=", tostring(coinsValue), "equipped=", tostring(equippedValue))
            local best = nil
            for i = #cfg.RodOrder, 1, -1 do
                local rodName = cfg.RodOrder[i]
                local rod = (cfg.Rods and cfg.Rods[rodName]) or {}
                local need = tonumber(rod.LevelToBuyNeed) or 0
                local price = tonumber(rod.Price) or 0
                local has = owned and owned:FindFirstChild(rodName)
                local isOwned = has and has.Value == true
                if levelValue >= need and (isOwned or coinsValue >= price) then
                    best = rodName
                    break
                end
            end
            if not best then
                notyuri("No affordable/eligible rod found")
                return
            end
            if best == equippedValue then
                notyuri("Best rod already equipped:", best)
                return
            end
            if not EnsureAtFishShop() then return end
            notyuri("Firing BuyOrEquipRod for", best)
            local result = Invoke(Remotes.FishingFunction, "BuyOrEquipRod", { Rod = best })
            notyuri("BuyOrEquipRod result:", tostring(result))
        end)
        if not ok then
            notyuri("pcall error:", tostring(err))
        end
        task.wait(1)
    end
end
local function Func_BuyBoat()
    while Toggles.BuyBoat and Toggles.BuyBoat.Value do
        local ok, err = pcall(function()
            if not (IsLobbyPlace() and Remotes.FishingFunction) then
                ConnectFishingEvents()
            end
            if not (IsLobbyPlace() and Remotes.FishingFunction) then
                notyuri("Shop remote not found, IsLobbyPlace=", tostring(IsLobbyPlace()))
                return
            end
            local cfg = GetFishingConfigModule()
            if not (type(cfg) == "table" and type(cfg.BoatOrder) == "table") then
                notyuri("FishingConfig or BoatOrder missing")
                return
            end
            local data = Plr:WaitForChild("PlayerGui"):FindFirstChild("FishingData")
            if not data then
                notyuri("No FishingData found on player")
                return
            end
            local owned = data:FindFirstChild("OwnedBoats")
            local coins = data:FindFirstChild("FishingCoins")
            local coinsValue = (coins and coins.Value) or 0
            notyuri("coins=", tostring(coinsValue))
            local target = nil
            for i = #cfg.BoatOrder, 1, -1 do
                local name = cfg.BoatOrder[i]
                local has = owned and owned:FindFirstChild(name)
                if has and has.Value == true then
                    target = name
                    break
                end
            end
            if not target then
                for i = #cfg.BoatOrder, 1, -1 do
                    local name = cfg.BoatOrder[i]
                    local entry = (cfg.Boats and cfg.Boats[name]) or {}
                    local price = tonumber(entry.Price) or math.huge
                    if coinsValue >= price then
                        target = name
                        break
                    end
                end
            end
            if not target then
                notyuri("Not enough Fish Coins for any boat")
                return
            end
            if not EnsureAtBoatShop() then return end
            notyuri("Firing BuyOrSpawnBoat for", target)
            local result = Invoke(Remotes.FishingFunction, "BuyOrSpawnBoat", { Boat = target })
            notyuri("BuyOrSpawnBoat result:", tostring(result))
        end)
        if not ok then
            notyuri("pcall error:", tostring(err))
        end
        task.wait(1)
    end
end
local function GetLoadoutUnits()
    local list = {}
    local config = Modules.TowerConfig
    local seen = {}
    for i = 1, 5 do
        local name = GetSlotUnitName(i)
        if name and not seen[name] and (not config or config.Units == nil or config.Units[name] ~= nil) then
            seen[name] = true
            table.insert(list, name)
        end
    end
    return list
end
local function PopulateRemotes()
    local funcs = RS:FindFirstChild("RemoteFunctions")
    local events = RS:FindFirstChild("RemoteEvents")
    if IsGamePlace() then
        if funcs then
            for _, name in ipairs(AllianceFuncs) do
                local remote = GetSafeRemote(funcs, name)
                if remote then Remotes[name] = remote end
            end
        end
        if events then
            for _, name in ipairs(AllianceEvents) do
                local remote = GetSafeRemote(events, name)
                if remote then Remotes[name] = remote end
            end
        end
        local returnLobby = GetSafeRemote(RS, "ReturnToLobby")
        if returnLobby then Remotes.ReturnToLobby = returnLobby end
    else
        if funcs then
            for _, name in ipairs(LobbyFuncs) do
                local remote = GetSafeRemote(funcs, name)
                if remote then Remotes[name] = remote end
            end
        end
        if events then
            for _, name in ipairs(LobbyEvents) do
                local remote = GetSafeRemote(events, name)
                if remote then Remotes[name] = remote end
            end
        end
    end
end
local function RedeemAllCodes()
    if not Remotes.Codes then
        PopulateRemotes()
    end
    if not Remotes.Codes then
        Library:Notify("Codes remote not found", 5)
        return
    end
    local playerGui = Plr:FindFirstChild("PlayerGui")
    local updateLog = playerGui and playerGui:FindFirstChild("UpdateLOG")
    local logsModule = updateLog and updateLog:FindFirstChild("UpdateLogs")
    if not logsModule or not logsModule:IsA("ModuleScript") then
        Library:Notify("UpdateLogs module not found", 5)
        return
    end
    local ok, logs = pcall(require, logsModule)
    if not ok or type(logs) ~= "table" then
        Library:Notify("Failed to load UpdateLogs", 5)
        return
    end
    local codes = {}
    local seen = {}
    for _, entry in pairs(logs) do
        if type(entry) == "table" and type(entry.Codes) == "table" then
            for _, code in ipairs(entry.Codes) do
                if type(code) == "string" and not seen[code] then
                    seen[code] = true
                    table.insert(codes, code)
                end
            end
        end
    end
    if #codes == 0 then
        Library:Notify("No codes found", 5)
        return
    end
    local redeemed = 0
    for _, code in ipairs(codes) do
        local result = Invoke(Remotes.Codes, code)
        if result then redeemed = redeemed + 1 end
        task.wait()
    end
    Library:Notify("Redeemed " .. redeemed .. "/" .. #codes .. " codes", 5)
end
local function ConnectGameEvents()
    if not IsGamePlace() then return end
    local ws = RS:FindFirstChild("WaveState")
    if not ws then return end
    SafeConnect("CurrentWave", function() return ws:GetAttributeChangedSignal("CurrentWave") end, function()
        MState.WaveClock = tick()
        Memo.SkipWave = 0
    end)
    SafeConnect("Result", function() return ws:GetAttributeChangedSignal("Result") end, function()
        task.defer(OnEndState)
    end)
    SafeConnect("MatchState", function() return ws:GetAttributeChangedSignal("MatchState") end, function()
        task.defer(OnContinueVote)
    end)
    SafeConnect("ReplayVotes", function() return ws:GetAttributeChangedSignal("ReplayVotes") end, function()
        task.defer(OnEndState)
    end)
    SafeConnect("ReplayVoteRound", function() return ws:GetAttributeChangedSignal("ReplayVoteRound") end, function()
        task.defer(OnEndState)
    end)
end
PopulateRemotes()
task.spawn(ConnectGameEvents)
task.spawn(ConnectFishingEvents)
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
    AutoPlay = Window:AddTab("Auto Play"),
    Webhook = Window:AddTab("Webhook"),
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
        T2 = TB.Main.Left.Autofarm:AddTab("Macro"),
        T1 = TB.Main.Left.Autofarm:AddTab("Game"),
        T3 = TB.Main.Left.Autofarm:AddTab("Lobby"),
        T4 = TB.Main.Left.Autofarm:AddTab("Fishing"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Config"),
        T2 = TB.Main.Right.Autofarm:AddTab("LobbyConfig"),
        T3 = TB.Main.Right.Autofarm:AddTab("FishConfig"),
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
    Webhook = {
        Left = {
            Webhook = Tabs.Webhook:AddLeftGroupbox("Webhook"),
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
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)", Disabled = not Support.HookMeta })
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
GB.Webhook.Left.Webhook:AddInput("WebhookURL", {
    Text = "Webhook URL",
    Default = "",
})
GB.Webhook.Left.Webhook:AddToggle("WHMatchEnd", {
    Text = "Match Finished",
    Default = false,
})
if not Support.Webhook then
    GB.Webhook.Left.Webhook:AddLabel("<font color='#FFA500'>Executor does not support HTTP requests.</font>", true)
end
local APLeft = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
do
    local initUnits = GetLoadoutUnits()
    PlaceTowersGetSelection, PlaceTowersRefresh, PlaceTowersValues = AddMultiDropdown(APLeft, "PlaceTowers", {
        Values = initUnits,
        Text = "Place Towers",
    })
    if #initUnits == 0 then
        task.spawn(function()
            task.wait(3)
            local units = GetLoadoutUnits()
            if #units > 0 then
                for _, name in ipairs(units) do
                    table.insert(PlaceTowersValues, name)
                end
                PlaceTowersRefresh()
            end
        end)
    end
end
APLeft:AddToggle("AutoPlace", { Text = "Auto Place" })
APLeft:AddToggle("AutoUpgrade", { Text = "Auto Upgrade" })
APLeft:AddDropdown("UpgradeMethod", {
    Text = "Upgrade Method",
    Values = {
        "Lowest Level (Spread Upgrade)",
        "Hotbar left to right (until Max)",
        "Randomize",
        "Customize upgrade order (Set below)",
    },
    Default = "Lowest Level (Spread Upgrade)",
})
APLeft:AddToggle("PlaceAndUpgrade", { Text = "Place and Upgrade" })
APLeft:AddDivider()
Place.PosLabelRef = APLeft:AddLabel("No positions set", true)
APLeft:AddDropdown("SetSlotSelect", {
    Text = "Set Slot Position",
    Values = GetSlotDisplayNames(),
    Default = GetSlotDisplayNames()[1] or "",
})
APLeft:AddButton({
    Text = "Set Slot Position",
    Func = function()
        local val = Options.SetSlotSelect and Options.SetSlotSelect.Value or ""
        local slot = SlotDisplayToNumber(val)
        if slot then
            SetPos(slot)
        else
            Library:Notify("Select a slot first", 3)
        end
    end,
})
APLeft:AddButton({ Text = "Save Position for All Slots", Func = function() HandleSlotPos("massset") end })
APLeft:AddDivider()
APLeft:AddDropdown("ResetSlotSelect", {
    Text = "Reset Slot Position",
    Values = (function() local v = GetSlotDisplayNames() table.insert(v, "All Slots") return v end)(),
    Default = "All Slots",
})
APLeft:AddButton({
    Text = "Reset Position",
    Func = function()
        local val = Options.ResetSlotSelect and Options.ResetSlotSelect.Value or "All Slots"
        if val == "All Slots" then
            ResetPos(nil)
        else
            ResetPos(SlotDisplayToNumber(val))
        end
    end,
})
local APRight = Tabs.AutoPlay:AddRightGroupbox("Limits")
APRight:AddLabel("Place Order per Slot", true)
for i = 1, 5 do
    APRight:AddSlider("PlaceOrder" .. i, {
        Text = "Slot " .. i,
        Default = i,
        Min = 1,
        Max = 5,
        Rounding = 0,
        Compact = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Place Wave per Slot", true)
for i = 1, 5 do
    APRight:AddSlider("PlaceWave" .. i, {
        Text = "Slot " .. i,
        Default = 0,
        Min = 0,
        Max = 50,
        Rounding = 0,
        Compact = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Place Limit per Slot", true)
for i = 1, 5 do
    APRight:AddSlider("PlaceLimit" .. i, {
        Text = "Slot " .. i,
        Default = 0,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Compact = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Upgrade Limit per Slot", true)
for i = 1, 5 do
    APRight:AddSlider("UpgradeLimit" .. i, {
        Text = "Slot " .. i,
        Default = 0,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Compact = true,
    })
end
RefreshSlotDropdowns = function()
    local names = GetSlotDisplayNames()
    if #names == 0 then return end
    if Options.SetSlotSelect then
        pcall(function()
            Options.SetSlotSelect:SetValues(names)
        end)
    end
    if Options.ResetSlotSelect then
        local resetNames = {}
        for _, n in ipairs(names) do
            table.insert(resetNames, n)
        end
        table.insert(resetNames, "All Slots")
        pcall(function()
            Options.ResetSlotSelect:SetValues(resetNames)
        end)
    end
end
UpdatePosLabels()
TB_Tabs.Autofarm.T1:AddToggle("AutoSkip", { Text = "Auto Skip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteDifficulty", { Text = "Auto Vote Difficulty", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSpeed", { Text = "Auto Speed", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReplay", { Text = "Auto Replay", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoContinue", { Text = "Auto Continue", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReturn", { Text = "Auto Return", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAbility", { Text = "Auto Ability", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("SpeedTarget", { Text = "Speed Target", Values = { "1", "1.5", "2" }, Default = "2" })
TB_Tabs.Autofarm2.T1:AddDropdown("VoteDifficulty", { Text = "Vote Difficulty", Values = DifficultyDropdownLabels, Default = DifficultyDropdownLabels[1] })
TB_Tabs.Autofarm.T2:AddDropdown("MacroSelected", {
    Text = "Select File",
    Values = ListMacros(),
    Default = ListMacros()[1] or "",
})
TB_Tabs.Autofarm.T2:AddInput("FileName", {
    Text = "File Name",
    Default = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T2:AddDropdown("ReplayMode", {
    Text = "Replay Mode",
    Values = { "Time", "Money" },
    Default = "Time",
})
TB_Tabs.Autofarm.T2:AddToggle("MacroRecord", {
    Text = "Record Macro",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("LoadMacro", {
    Text = "Play Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.T2:AddLabel("Idle", true)
TB_Tabs.Autofarm.T3:AddToggle("AutoJoin", { Text = "Auto Join" })
TB_Tabs.Autofarm.T3:AddButton({
    Text = "Redeem All Codes",
    Func = function()
        RedeemAllCodes()
    end,
})
TB_Tabs.Autofarm2.T2:AddDropdown("SelectedMap", { Text = "Map", Values = MapDropdownLabels, Default = MapDropdownLabels[1] })
TB_Tabs.Autofarm.T3:AddToggle("AutoSummon", { Text = "Auto Summon" })
TB_Tabs.Autofarm2.T2:AddDropdown("SummonAmount", { Text = "Summon Amount", Values = { "1", "10" }, Default = "1" })
TB_Tabs.Autofarm.T4:AddToggle("AutoFish", { Text = "Auto Fish" })
TB_Tabs.Autofarm.T4:AddToggle("AutoSellFish", { Text = "Auto Sell Fish" })
TB_Tabs.Autofarm.T4:AddToggle("AutoCraft", { Text = "Auto Craft" })
TB_Tabs.Autofarm.T4:AddDivider()
TB_Tabs.Autofarm.T4:AddToggle("BuyRod", { Text = "Buy Rod" })
TB_Tabs.Autofarm.T4:AddToggle("BuyBoat", { Text = "Buy Boat" })
TB_Tabs.Autofarm2.T3:AddToggle("FishAutoZone", { Text = "Auto Teleport to Fishing", Default = true })
do
    local function GetFishNames()
        local cfg = GetFishingConfigModule()
        local names = {}
        if type(cfg) == "table" and type(cfg.Fish) == "table" then
            for name, _ in pairs(cfg.Fish) do
                table.insert(names, name)
            end
            table.sort(names)
        end
        return names
    end
    local initFish = GetFishNames()
    SellFishGetSelection, SellFishRefresh, SellFishValues = AddMultiDropdown(TB_Tabs.Autofarm2.T3, "SellFish", {
        Values = initFish,
        Text = "Fish to Sell",
    })
    if #initFish == 0 then
        task.spawn(function()
            task.wait(3)
            local names = GetFishNames()
            if #names > 0 then
                for _, name in ipairs(names) do
                    table.insert(SellFishValues, name)
                end
                SellFishRefresh()
            end
        end)
    end
end
TB_Tabs.Autofarm2.T3:AddSlider("SellFishThreshold", { Text = "Sell Threshold", Default = 0, Min = 0, Max = 500, Compact = true, Rounding = 0 })
LoadMDir()
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
            task.wait(0.5)
            if not Toggles.AutoServerhop.Value then break end
            if (tick() - lastHop) >= (Options.AutoHopMins.Value * 60) then
                Serverhop()
                break
            end
        end
    end, state)
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
Toggles.AutoPlace:OnChanged(function(state)
    Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), state)
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state)
end)
Toggles.AutoAbility:OnChanged(function(state)
    Thread("AutoAbility", SafeLoop("AutoAbility", Func_AutoAbility), state)
end)
Toggles.AutoSkip:OnChanged(function(state)
    Thread("AutoSkip", SafeLoop("AutoSkip", Func_AutoSkip), state)
end)
Toggles.AutoSpeed:OnChanged(function(state)
    Thread("AutoSpeed", SafeLoop("AutoSpeed", Func_AutoSpeed), state)
end)
Toggles.AutoVoteDifficulty:OnChanged(function(state)
    Thread("AutoVoteDifficulty", SafeLoop("AutoVoteDifficulty", Func_AutoVoteDifficulty), state)
end)
local function EnsureEndStates()
    local wanted = (Toggles.AutoReplay and Toggles.AutoReplay.Value)
        or (Toggles.AutoContinue and Toggles.AutoContinue.Value)
        or (Toggles.AutoReturn and Toggles.AutoReturn.Value)
    Thread("EndStates", SafeLoop("EndStates", Func_EndStates), wanted == true)
end
Toggles.AutoReplay:OnChanged(function(state)
    EnsureEndStates()
end)
Toggles.AutoContinue:OnChanged(function(state)
    EnsureEndStates()
end)
Toggles.AutoReturn:OnChanged(function(state)
    EnsureEndStates()
end)
Toggles.AutoJoin:OnChanged(function(state)
    Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), state)
end)
Toggles.AutoSummon:OnChanged(function(state)
    Thread("AutoSummon", SafeLoop("AutoSummon", Func_AutoSummon), state)
end)
Toggles.AutoFish:OnChanged(function(state)
    Thread("AutoFish", SafeLoop("AutoFish", Func_AutoFish), state)
    if not state then BodyLock(nil, false) end
end)
Toggles.AutoSellFish:OnChanged(function(state)
    Thread("AutoSellFish", SafeLoop("AutoSellFish", Func_AutoSellFish), state)
end)
Toggles.AutoCraft:OnChanged(function(state)
    Thread("AutoCraft", SafeLoop("AutoCraft", Func_AutoCraft), state)
end)
Toggles.BuyRod:OnChanged(function(state)
    Thread("BuyRod", SafeLoop("BuyRod", Func_BuyRod), state)
end)
Toggles.BuyBoat:OnChanged(function(state)
    Thread("BuyBoat", SafeLoop("BuyBoat", Func_BuyBoat), state)
end)
Toggles.MacroRecord:OnChanged(function(state)
    Func_MacroRecord(state)
end)
Toggles.LoadMacro:OnChanged(function(state)
    if state then
        if not MState.Load and Options.MacroSelected and Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
            MState.Load = LoadMacro(Options.MacroSelected.Value)
            if not MState.Load then
                Library:Notify("Failed to load macro: " .. tostring(Options.MacroSelected.Value), 4)
            end
        end
        if Toggles.MacroRecord and Toggles.MacroRecord.Value then
            Toggles.MacroRecord:SetValue(false)
        end
    end
    Thread("LoadMacro", SafeLoop("Macro Replay", Func_MacroReplay), state)
end)
Options.MacroSelected:OnChanged(function(v)
    if v and v ~= "" then
        MState.Load = LoadMacro(v)
        if not MState.Load then
            Library:Notify("Failed to load macro: " .. tostring(v), 4)
        end
    end
end)
if Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
    MState.Load = LoadMacro(Options.MacroSelected.Value)
end
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
    MState.Rec = false
    MState.Rep = false
    MState.Cur = nil
    MState.Load = nil
    MState.Pending = {}
    BodyLock(nil, false)
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
SaveManager:SetFolder("Yuri/Alliance")
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
