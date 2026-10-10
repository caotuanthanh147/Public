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
    HookFunction = (typeof(hookfunction) == "function"),
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
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2022/08/15/23/52/23/100515820_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2025/07/22/17/09/45/132989170_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2019/12/01/21/59/30/78092730_p0_master1200.jpg",
}
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
    local done, result = false, nil
    local thread = task.spawn(function()
        local innerThread = coroutine.running()
        if selfMarked then SelfThreads[innerThread] = true end
        local ok, res = pcall(remote.InvokeServer, remote, table.unpack(args, 1, args.n))
        if selfMarked then SelfThreads[innerThread] = nil end
        if ok then result = res end
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
local Functions = {"SpawnTower", "SellTower", "ChangeTowerMode", "GetData", "VoteSkip", "VoteChangeSpeed"}
local Events = {"ActivateAbility", "VoteEvent", "RequestSpeedVote", "ReplayVote", "AbilityStateUpdate", "ShowSkipEvent", "VoteForMap", "VoteForModifier", "StartTimerVote"}
local MDir = "Yuri/DD/Macros"
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
    Saved = false,
    PendingLabel = nil,
    Pending = {},
    Adopted = {},
    SelfThreads = SelfThreads,
}
local Place = {
    Cursor = 0,
    Center = nil,
    Spiral = {x = 0, z = 0, dx = 1, dz = 0, segLen = 1, stepped = 0, turns = 0},
    FailMemo = {},
    DataCache = nil,
    DataStamp = "",
    TypeFails = 0,
    SlotPause = {},
    SlotPositions = {},
    FailedPositions = {},
    SpanCache = {},
    SpanCursor = {},
    MapLabelRef = nil,
    PosLabelRef = nil,
}
local Ability = {
    State = {},
    Timers = {},
    NukeWave = nil,
    LastAbility = 0,
    TowerCD = {},
}
local AbilityTimerLast = tick()
local function GetInfo()
    return workspace:FindFirstChild("Info")
end
local function IsGamePaused()
    local info = GetInfo()
    if not info then return false end
    local paused = info:FindFirstChild("PausedByVote")
    if info.GameSpeed.Value ~= 0 then return false end
    return paused ~= nil and paused.Value == true
end
local function IsMatchActive()
    local info = GetInfo()
    if not info then return false end
    local running = info:FindFirstChild("GameRunning")
    return running and running.Value == true or false
end
local function GetWave()
    local info = GetInfo()
    if not info then return 0 end
    local wave = info:FindFirstChild("Wave")
    return wave and wave.Value or 0
end
local function GetRemainingTime()
    local info = GetInfo()
    if not info then return nil end
    local sec = info:FindFirstChild("Seconds")
    local min = info:FindFirstChild("Minutes")
    if not (sec and min) then return nil end
    return min.Value * 60 + sec.Value
end
local function GetCash()
    local cash = Plr:FindFirstChild("Cash")
    return cash and cash.Value or 0
end
local function GetGold()
    local gold = Plr:FindFirstChild("Gold")
    if not gold then
        local stats = Plr:FindFirstChild("leaderstats")
        gold = stats and stats:FindFirstChild("Gold")
    end
    return gold and gold.Value or 0
end
local function EndStat(statName)
    local gui = Plr:FindFirstChild("PlayerGui")
    local label = gui and GetObject(gui, "GameGui.EndScreen.StatsContent.Stats." .. statName)
    if not label or not label:IsA("TextLabel") then return nil end
    local digits = label.Text:gsub("[^%d]", "")
    return tonumber(digits)
end
local function GetPlacedTowers()
    local stats = Plr:FindFirstChild("leaderstats")
    local placed = stats and stats:FindFirstChild("PlacedTowers")
    return placed and placed.Value or 0
end
local function GetTowerLimit()
    local playerStats = workspace:FindFirstChild("PlayerStats")
    local limitSave = Plr:FindFirstChild("LimitMaxSave")
    if limitSave and playerStats and playerStats:FindFirstChild(Plr.Name) and playerStats[Plr.Name]:FindFirstChild("InGame") then
        limitSave = playerStats[Plr.Name]:FindFirstChild("LimitMaxSave") or limitSave
    end
    local info = GetInfo()
    if not (limitSave and info and info:FindFirstChild("TotalPlayers")) then return 50 end
    local v = limitSave.Value
    if v == 1 then return 50 end
    if v == 2 then return 40 end
    if v == 3 then return 30 end
    return 20
end
local function GetTowersFolder()
    return workspace:FindFirstChild("Towers")
end
local function IsOwnedTower(tower)
    if typeof(tower) ~= "Instance" then return false end
    local config = tower:FindFirstChild("Config")
    local owner = config and config:FindFirstChild("Owner")
    return owner ~= nil and owner.Value == Plr.Name
end
local function GetOwnedTowers()
    local folder = GetTowersFolder()
    local list = {}
    if not folder then return list end
    for _, tower in ipairs(folder:GetChildren()) do
        if IsOwnedTower(tower) then
            table.insert(list, tower)
        end
    end
    return list
end
local function GetTowerModel(name)
    local model = RS.Towers:FindFirstChild(name)
    if not model then
        local skins = RS.Towers:FindFirstChild("Skins")
        model = skins and skins:FindFirstChild(name)
    end
    return model
end
local function GetMapFolder()
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end
    return map:FindFirstChildOfClass("Folder")
end
local function GetTowerAreaFolder()
    local folder = GetMapFolder()
    return folder and folder:FindFirstChild("TowerArea")
end
local function GetData()
    if not Remotes.GetData then return nil end
    local info = GetInfo()
    local stamp = "0_0"
    if info then
        local running = info:FindFirstChild("GameRunning")
        local wave = info:FindFirstChild("Wave")
        stamp = tostring(running and running.Value or 0) .. "_" .. tostring(wave and wave.Value or 0)
    end
    if Place.DataCache and Place.DataStamp == stamp then
        return Place.DataCache
    end
    local result = SafeInvoke(Remotes.GetData)
    if type(result) == "table" then
        Place.DataCache = result
        Place.DataStamp = stamp
        return result
    end
    return nil
end
local function GetSelectedTowers()
    local data = GetData()
    if not data then return {} end
    local towers = data.SelectedTowers
    if type(towers) ~= "table" then return {} end
    local list = {}
    for _, name in pairs(towers) do
        if type(name) == "string" and GetTowerModel(name) then
            table.insert(list, name)
        end
    end
    table.sort(list)
    return list
end
local function GetLoadoutSlot(slot)
    local data = GetData()
    if not data or type(data.SelectedTowers) ~= "table" then return nil end
    local name = data.SelectedTowers[slot]
    if type(name) ~= "string" or name == "" then return nil end
    return name
end
local function Invoke(remote, ...)
    local args = {...}
    local thread = coroutine.running()
    if thread then SelfThreads[thread] = true end
    MState.SelfFire = true
    local result = SafeInvoke(remote, 12, unpack(args))
    if thread then SelfThreads[thread] = nil end
    MState.SelfFire = false
    return result
end
local function Fire(remote, ...)
    local args = {...}
    MState.SelfFire = true
    local ok = FireRemote(remote, unpack(args))
    MState.SelfFire = false
    return ok
end
local function GetAbilityShop()
    return GetSafeModule(RS, "AbilityShop")
end
local function GetAbilityData(name)
    local shop = GetAbilityShop()
    if type(shop) ~= "table" then return nil end
    for _, ability in ipairs(shop) do
        if ability.Name == name then
            return ability
        end
    end
    return nil
end
local function GetEquippedAbilities()
    local data = GetData()
    if not data then return {} end
    local equipped = data.EquippedAbilities
    if type(equipped) ~= "table" then return {} end
    return equipped
end
local function GetEffectiveGoldPrice(name)
    local wave = GetWave()
    local tier = 1
    if wave >= 30 then
        tier = 5
    elseif wave >= 25 then
        tier = 4
    elseif wave >= 20 then
        tier = 3
    elseif wave >= 15 then
        tier = 2
    end
    local supply = {25, 40, 55, 70, 85}
    local reinforce = {30, 45, 60, 80, 100}
    if name == "Supply Drop" then
        return supply[tier]
    end
    if name == "Reinforcement Unit" then
        return reinforce[tier]
    end
    local data = GetAbilityData(name)
    if not data then return 0 end
    return data.goldprice or 0
end
local function AbilityState(name)
    local data = GetAbilityData(name)
    if not data then return "unknown" end
    local modes = RS:FindFirstChild("Modes")
    local sandbox = modes and modes:FindFirstChild("SandboxMode")
    if not (sandbox and sandbox.Value == true) and GetWave() < data.wave then
        return "wave_lock"
    end
    local state = Ability.State[name]
    if state and state.amountLeft ~= nil and state.amountLeft <= 0 then
        return "depleted"
    end
    local timer = Ability.Timers[name]
    if timer ~= nil and timer < (data.time or 0) then
        return "active"
    end
    if GetEffectiveGoldPrice(name) > GetGold() then
        return "no_gold"
    end
    return "ready"
end
local function GetNearestMobPos()
    local mobs = workspace:FindFirstChild("Mobs")
    if not mobs then return nil end
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local best, bestDist = nil, math.huge
    for _, mob in ipairs(mobs:GetChildren()) do
        if mob:IsA("Model") then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local part = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
            if hum and part and hum.Health > 0 then
                if root then
                    local dist = (part.Position - root.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = mob
                    end
                elseif best == nil then
                    best = mob
                end
            end
        end
    end
    if not best then return nil end
    local part = best:FindFirstChild("HumanoidRootPart") or best.PrimaryPart
    return part and part.Position or nil
end
local function RaycastGround(pos)
    local ok, result = pcall(function()
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Include
        local include = {}
        local mapFolder = GetMapFolder()
        if mapFolder then table.insert(include, mapFolder) end
        table.insert(include, workspace.Terrain)
        params.FilterDescendantsInstances = include
        return workspace:Raycast(Vector3.new(pos.X, pos.Y + 100, pos.Z), Vector3.new(0, -300, 0), params)
    end)
    if ok and result and result.Instance then
        return result
    end
    return nil
end
local function GetValidGroundPos(pos)
    local hit = RaycastGround(pos)
    if not hit then return nil end
    local inst = hit.Instance
    if inst == workspace.Terrain then
        return hit.Position
    end
    if inst.Parent and inst.Parent.Name == "TowerArea" then
        return hit.Position
    end
    return nil
end
local function GetTowerRadius(model)
    local config = model:FindFirstChild("Config") or model:FindFirstChild("Config0")
    local hitbox = config and config:FindFirstChild("Hitbox")
    local size = hitbox and hitbox:FindFirstChild("Size")
    if size and size.Value and size.Value > 0 then
        return size.Value / 2
    end
    return 2
end
local function ComputePlaceCF(model, hitPos)
    local legY = 0
    local leg = model:FindFirstChild("Left Leg")
    if leg and leg:IsA("BasePart") then
        legY = leg.Size.Y
    end
    local primY = 0
    if model.PrimaryPart then
        primY = model.PrimaryPart.Size.Y / 2
    end
    local offsetY = 0
    local config = model:FindFirstChild("Config0") or model:FindFirstChild("Config")
    local offsetVal = config and config:FindFirstChild("PlaceholderOffsetY")
    if offsetVal then
        offsetY = offsetVal.Value
    end
    return CFrame.new(hitPos.X, hitPos.Y + legY + primY + offsetY, hitPos.Z)
end
local function IsSpotFree(model, groundPos)
    local folder = GetTowersFolder()
    if not folder then return true end
    local myRadius = GetTowerRadius(model)
    for _, tower in ipairs(folder:GetChildren()) do
        if tower:IsA("Model") and tower.PrimaryPart then
            local otherPos = tower.PrimaryPart.Position
            local dx = otherPos.X - groundPos.X
            local dz = otherPos.Z - groundPos.Z
            local distSq = dx * dx + dz * dz
            local otherRadius = GetTowerRadius(tower)
            local need = myRadius + otherRadius
            if distSq < need * need then
                return false
            end
        end
    end
    return true
end
local function GetSpiralCenter()
    if Place.Center then
        return Place.Center
    end
    local area = GetTowerAreaFolder()
    if not area then return nil end
    local best, bestSize = nil, 0
    for _, part in ipairs(area:GetChildren()) do
        if part:IsA("BasePart") then
            local size = part.Size.X * part.Size.Z
            if size > bestSize then
                bestSize = size
                best = part
            end
        end
    end
    if not best then return nil end
    Place.Center = best.Position
    return Place.Center
end
local function SpiralNext(spacing)
    local center = GetSpiralCenter()
    if not center then return nil end
    local cursor = Place.Cursor
    Place.Cursor = cursor + 1
    if cursor == 0 then
        return Vector3.new(center.X, center.Y, center.Z)
    end
    local st = Place.Spiral
    st.x = st.x + st.dx
    st.z = st.z + st.dz
    local result = Vector3.new(center.X + st.x * spacing, center.Y, center.Z + st.z * spacing)
    st.stepped = st.stepped + 1
    if st.stepped >= st.segLen then
        st.stepped = 0
        st.dx, st.dz = -st.dz, st.dx
        st.turns = st.turns + 1
        if st.turns % 2 == 0 then
            st.segLen = st.segLen + 1
        end
    end
    return result
end
local function NextPlaceSpot(model)
    local radius = GetTowerRadius(model)
    local spacing = math.max(4, radius * 2 + 0.5)
    for _ = 1, 40 do
        local candidate = SpiralNext(spacing)
        if not candidate then return nil end
        local key = string.format("%.1f_%.1f", candidate.X, candidate.Z)
        local memo = Place.FailMemo[key]
        local blocked = memo and (tick() - memo) <= 30
        if not blocked then
            local ground = GetValidGroundPos(candidate)
            if ground and IsSpotFree(model, ground) then
                return ground
            else
                Place.FailMemo[key] = tick()
            end
        end
    end
    return nil
end
local function ResetPlaceCursor()
    Place.Cursor = 0
    Place.Center = nil
    Place.Spiral = {x = 0, z = 0, dx = 1, dz = 0, segLen = 1, stepped = 0, turns = 0}
    Place.FailMemo = {}
end
local PCubePool = {
    Free = {},
    Active = {},
}
local function PCubeAcq()
    local part = table.remove(PCubePool.Free)
    if not part then
        part = Instance.new("Part")
        part.Name         = "PCube"
        part.Size         = Vector3.new(0.5, 0.5, 0.5)
        part.Anchored     = true
        part.CanCollide   = false
        part.CastShadow   = false
        part.Material     = Enum.Material.Neon
    end
    part.Transparency = 0.55
    part.Color        = Color3.fromRGB(80, 160, 255)
    part.Parent        = workspace
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
local function GetCurrentMapName()
    local folder = GetMapFolder()
    return folder and folder.Name or nil
end
local function FailKey(pos)
    return string.format("%.1f_%.1f_%.1f", pos.X, pos.Y, pos.Z)
end
local function DoSpan(cache, center, upToCount, spacing)
    cache = cache or {}
    spacing = spacing or 1.5
    if upToCount <= 0 then return cache end
    if #cache == 0 then
        local groundPos = GetValidGroundPos(center) or center
        cache[1] = CFrame.new(groundPos)
        cache.x, cache.z = 0, 0
        cache.dx, cache.dz = 1, 0
        cache.segLen  = 1
        cache.stepped = 0
        cache.turns   = 0
    end
    while #cache < upToCount do
        cache.x = cache.x + cache.dx
        cache.z = cache.z + cache.dz
        local px = center.X + cache.x * spacing
        local pz = center.Z + cache.z * spacing
        local candidate = Vector3.new(px, center.Y, pz)
        local groundPos = GetValidGroundPos(candidate) or candidate
        table.insert(cache, CFrame.new(groundPos))
        cache.stepped = cache.stepped + 1
        if cache.stepped == cache.segLen then
            cache.stepped = 0
            cache.dx, cache.dz = -cache.dz, cache.dx
            cache.turns = cache.turns + 1
            if cache.turns % 2 == 0 then
                cache.segLen = cache.segLen + 1
            end
        end
    end
    return cache
end
local function PosText(mapName)
    if not mapName or not Place.SlotPositions[mapName] then return "No positions set" end
    local lines = {}
    for slot, cfs in pairs(Place.SlotPositions[mapName]) do
        local unitName = GetLoadoutSlot(slot)
        table.insert(lines, "Slot " .. slot .. (unitName and (" (" .. unitName .. ")") or "") .. ": " .. #cfs .. " pos")
    end
    if #lines == 0 then return "No positions set" end
    table.sort(lines)
    return table.concat(lines, "\n")
end
local function UpdatePosLabels()
    local mapName = GetCurrentMapName()
    if Place.MapLabelRef then
        pcall(function()
            Place.MapLabelRef:SetText("Current Map: " .. (mapName or "Not in game"))
        end)
    end
    if Place.PosLabelRef then
        pcall(function()
            Place.PosLabelRef:SetText(PosText(mapName))
        end)
    end
end
local function HandleSlotPos(act, slot)
    local mapName = GetCurrentMapName()
    if not mapName then
        Library:Notify("Not in a game — map not detected", 3)
        return
    end
    if act == "reset" then
        if slot then
            if Place.SlotPositions[mapName] then Place.SlotPositions[mapName][slot] = nil end
            Library:Notify("Slot " .. slot .. " positions cleared (" .. mapName .. ")", 3)
            notyuri("[AutoPlay] ResetPos slot=" .. slot .. " map=" .. mapName)
        else
            Place.SlotPositions[mapName] = nil
            Library:Notify("All positions cleared (" .. mapName .. ")", 3)
            notyuri("[AutoPlay] ResetPos all map=" .. mapName)
        end
        PCubeReleaseAll()
        UpdatePosLabels()
        return
    end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Library:Notify("Character not found", 3)
        return
    end
    local pos = hrp.Position
    local groundPos = GetValidGroundPos(pos) or pos
    local cf = CFrame.new(groundPos)
    if not Place.SlotPositions[mapName] then Place.SlotPositions[mapName] = {} end
    if act == "set" then
        if not Place.SlotPositions[mapName][slot] then Place.SlotPositions[mapName][slot] = {} end
        table.insert(Place.SlotPositions[mapName][slot], cf)
        local count = #Place.SlotPositions[mapName][slot]
        Library:Notify("Slot " .. slot .. " position " .. count .. " saved (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] SetPos slot=" .. slot .. " count=" .. count .. " map=" .. mapName)
    elseif act == "massset" then
        for i = 1, 6 do
            if not Place.SlotPositions[mapName][i] then Place.SlotPositions[mapName][i] = {} end
            table.insert(Place.SlotPositions[mapName][i], cf)
        end
        Library:Notify("All slots saved (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] MassSetPos map=" .. mapName)
    end
    UpdatePosLabels()
end
local function SetPos(slot) HandleSlotPos("set", slot) end
local function MassSetPos() HandleSlotPos("massset") end
local function ResetPos(slot) HandleSlotPos("reset", slot) end
local function WalkUpgradeChain(tower, cash)
    local model = tower
    local total = 0
    local lastNext = nil
    for _ = 1, 20 do
        local config = model:FindFirstChild("Config")
        local upgrade = config and config:FindFirstChild("Upgrade")
        if not (upgrade and upgrade.Value and upgrade.Value:FindFirstChild("Config")) then break end
        local nextModel = upgrade.Value
        local nextConfig = nextModel:FindFirstChild("Config")
        local priceVal = nextConfig and nextConfig:FindFirstChild("Price")
        local price = priceVal and priceVal.Value or math.huge
        if not (price <= cash) then break end
        cash = cash - price
        total = total + price
        model = nextModel
        lastNext = nextModel
    end
    return lastNext, total
end
local function IsTowerStunned(tower)
    local config = tower:FindFirstChild("Config")
    local debuff = config and config:FindFirstChild("Debuff")
    if not debuff then return false end
    for _, child in ipairs(debuff:GetChildren()) do
        if child:IsA("NumberValue") or child:IsA("IntValue") then
            return true
        end
    end
    return false
end
local function GetTowerAbilityShape(tower)
    if not (tower and tower:FindFirstChild("AbilityFolder")) then return nil end
    if tower:FindFirstChild("MKI Titan Dummy") then
        return "MKI"
    elseif tower:FindFirstChild("Titan Scale") then
        return "TitanScale"
    elseif tower:FindFirstChild("Officer Dummy") then
        return "Officer"
    end
    return nil
end
local function UpdateMacroLabel(suffix, elapsed)
    if not (MState.LabelRef and MState.LabelRef.SetText) then return end
    local txt
    local timeStr = ""
    if type(elapsed) == "number" then
        timeStr = " " .. tostring(elapsed)
    elseif type(elapsed) == "string" then
        timeStr = " " .. elapsed
    end
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
    notyuri("[Macro] UpdateLabel", txt)
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
        return ea > eb
    end)
end
local function ParseUpgradeName(name)
    if type(name) ~= "string" then return nil, nil end
    local base, lvl = name:match("^(.*%S)%s+(%d+)%.?%d*$")
    if base then
        return base, tonumber(lvl)
    end
    return name, nil
end
local function GetTowerBaseName(tower)
    if typeof(tower) ~= "Instance" then return nil end
    local config = tower:FindFirstChild("Config")
    local tn = config and config:FindFirstChild("TowerName")
    if tn and type(tn.Value) == "string" and tn.Value ~= "" then return tn.Value end
    return tower.Name
end
local function GetTowerLevel(tower)
    if typeof(tower) ~= "Instance" then return nil end
    local config = tower:FindFirstChild("Config")
    local lvl = config and config:FindFirstChild("Level")
    return lvl and lvl.Value or nil
end
local function TowerNearPos(tower, pos, radius)
    local pp = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart")
    if not (pp and pos) then return false end
    return (pp.Position - pos).Magnitude <= (radius or 4)
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
local function ConfirmPlace(pend, inst)
    pend.Resolved = true
    local key = EnsureRecKey(inst)
    if not key then
        pend.Dropped = true
        return
    end
    pend.Key = key
    RecordAct("Place", {Key = key, Name = pend.Name, CF = pend.CF}, pend.Wave, pend.Elapsed)
    if pend.Late then
        notyuri("[Macro Rec] Place late-confirmed key=" .. tostring(key) .. " (" .. tostring(pend.Name) .. ")")
    end
end
local function ConfirmUpgrade(pend, inst)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = MState.RecKeys[pend.Tower]
    end
    key = key or EnsureRecKey(inst)
    if not key then
        pend.Dropped = true
        return
    end
    MState.RecKeys[inst] = key
    if typeof(pend.Tower) == "Instance" then
        MState.RecKeys[pend.Tower] = key
    end
    pend.Key = key
    RecordAct("Upgrade", {Key = key, Name = pend.Name, CF = pend.CF, Cost = pend.Cost}, pend.Wave, pend.Elapsed)
    if pend.Late then
        notyuri("[Macro Rec] Upgrade late-confirmed key=" .. tostring(key) .. " (" .. tostring(pend.Name) .. ")")
    end
end
local function ConfirmSell(pend, late)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = MState.RecKeys[pend.Tower]
        MState.RecKeys[pend.Tower] = nil
    end
    if not key and typeof(pend.Tower) == "Instance" then
        key = EnsureRecKey(pend.Tower)
        MState.RecKeys[pend.Tower] = nil
    end
    pend.Key = key
    local data = {Key = key, Name = pend.Name}
    if pend.CF then data.CF = pend.CF end
    RecordAct("Sell", data, pend.Wave, pend.Elapsed)
    if late then
        notyuri("[Macro Rec] Sell late-confirmed key=" .. tostring(key))
    end
end
local function ConfirmMode(pend)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = MState.RecKeys[pend.Tower] or EnsureRecKey(pend.Tower)
        MState.RecKeys[pend.Tower] = key
    end
    pend.Key = key
    RecordAct("Mode", {Key = key, Name = pend.Name, CF = pend.CF}, pend.Wave, pend.Elapsed)
end
local function RecordMode(tower)
    if not (MState.Rec and MState.Cur) then return end
    if typeof(tower) ~= "Instance" then return end
    local key = MState.RecKeys[tower]
    if not key then
        notyuri("[Macro Rec] Mode GUARD FAIL: tower has no recorded key")
        return
    end
    local wave = GetWave()
    local elapsed = GetRemainingTime()
    RecordAct("Mode", {Key = key, Name = GetTowerBaseName(tower)}, wave, elapsed)
end
local function SnapshotCall(self, nargs)
    if not (MState.Rec and MState.Cur) then return nil end
    local wave = GetWave()
    local elapsed = GetRemainingTime()
    local pend
    if rawequal(self, Remotes.SpawnTower) then
        local name = nargs[2]
        local cf = nargs[3]
        local third = nargs[4]
        if type(name) ~= "string" or typeof(cf) ~= "CFrame" then return nil end
        local isUpgrade = typeof(third) == "Instance"
        pend = {
            Kind = isUpgrade and "Upgrade" or "Place",
            Name = name,
            Tower = isUpgrade and third or nil,
            Cost = (isUpgrade and type(nargs[6]) == "number") and nargs[6] or nil,
        }
        local comps = {cf:GetComponents()}
        pend.CF = comps
        pend.Position = Vector3.new(comps[1], comps[2], comps[3])
    elseif rawequal(self, Remotes.SellTower) or rawequal(self, Remotes.ChangeTowerMode) then
        local tower = nargs[2]
        if typeof(tower) ~= "Instance" then return nil end
        pend = {
            Kind = rawequal(self, Remotes.SellTower) and "Sell" or "Mode",
            Tower = tower,
            Name = GetTowerBaseName(tower),
        }
        local pp = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart")
        if pp then
            pend.Position = pp.Position
            local comps = {pp.CFrame:GetComponents()}
            pend.CF = comps
        end
    else
        return nil
    end
    pend.Wave = wave
    pend.Elapsed = elapsed
    pend.At = tick()
    pend.Resolved = false
    table.insert(MState.Pending, pend)
    notyuri("[Macro Rec]", pend.Kind, "captured", tostring(pend.Name), "wave", tostring(wave), string.format("%.2fs", elapsed))
    return pend
end
local function ResolveCall(pend, ret)
    if not (pend and not pend.Resolved) then return end
    local result = (ret and ret.n and ret.n > 0) and ret[1] or nil
    if pend.Kind == "Place" then
        if typeof(result) == "Instance" then
            ConfirmPlace(pend, result)
        end
    elseif pend.Kind == "Upgrade" then
        if typeof(result) == "Instance" then
            ConfirmUpgrade(pend, result)
        end
    elseif pend.Kind == "Sell" then
        if result then
            ConfirmSell(pend, false)
        end
    elseif pend.Kind == "Mode" then
        if result then
            ConfirmMode(pend)
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
local function ProcessPendingSweep()
    local now = tick()
    for _, pend in ipairs(MState.Pending) do
        if not pend.Resolved then
            local age = now - pend.At
            if age > 12 then
                pend.Resolved = true
                pend.Dropped = true
                notyuri("[Macro Rec]", pend.Kind, "expired unresolved:", tostring(pend.Name))
            elseif age > 0.6 then
                if pend.Kind == "Place" then
                    local inst = FindUnkeyedOwnedTower(function(t)
                        local tn = GetTowerBaseName(t)
                        return (tn == pend.Name or t.Name == pend.Name) and TowerNearPos(t, pend.Position, 4)
                    end)
                    if inst then
                        pend.Late = true
                        ConfirmPlace(pend, inst)
                    end
                elseif pend.Kind == "Upgrade" then
                    local base, targetLvl = ParseUpgradeName(pend.Name)
                    local old = pend.Tower
                    local oldAlive = typeof(old) == "Instance" and old.Parent ~= nil
                    local oldLevel = oldAlive and GetTowerLevel(old) or nil
                    local applied = false
                    if not oldAlive then
                        applied = true
                    elseif targetLvl and oldLevel and oldLevel >= targetLvl then
                        applied = true
                    end
                    if applied then
                        local inst = nil
                        if oldAlive and oldLevel and targetLvl and oldLevel >= targetLvl then
                            inst = old
                        else
                            inst = FindUnkeyedOwnedTower(function(t)
                                local tn = GetTowerBaseName(t)
                                local lvl = GetTowerLevel(t)
                                local nameOk = (tn == base or tn == pend.Name or t.Name == pend.Name)
                                local lvlOk = (not targetLvl) or (not lvl) or lvl == targetLvl
                                return nameOk and lvlOk and TowerNearPos(t, pend.Position, 4)
                            end)
                        end
                        if inst then
                            pend.Late = true
                            ConfirmUpgrade(pend, inst)
                        end
                    end
                elseif pend.Kind == "Sell" then
                    local old = pend.Tower
                    if typeof(old) ~= "Instance" or old.Parent == nil then
                        pend.Late = true
                        ConfirmSell(pend, true)
                    end
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
        task.wait(0.5)
    end
    for _ = 1, 3 do
        if MState.Rec then break end
        if not MState.Cur then break end
        pcall(ProcessPendingSweep)
        task.wait(0.6)
    end
end
local function WaitForMacroRemotes()
    local deadline = tick() + 8
    for _, name in ipairs({"SpawnTower", "SellTower", "ChangeTowerMode"}) do
        if not Remotes[name] then
            local folder = RS:FindFirstChild("Functions")
            local remote = folder and folder:FindFirstChild(name)
            if not remote then
                remote = folder and folder:WaitForChild(name, math.max(0, deadline - tick()))
            end
            if remote and (remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent")) then
                Remotes[name] = remote
            end
        end
    end
end
local function InstallMacroHook()
    if MState.Hooked then return end
    if not (Support.HookMeta or Support.HookFunction) then
        Library:Notify("Macro record requires hookmetamethod/hookfunction support", 4)
        return
    end
    WaitForMacroRemotes()
    MState.Hooked = true
    local cc = (typeof(newcclosure) == "function") and newcclosure or (function(f) return f end)
    if Support.HookFunction then
        local probe = Instance.new("RemoteFunction")
        local invokeServerFn = probe.InvokeServer
        probe:Destroy()
        local originalInvokeServer
        originalInvokeServer = hookfunction(invokeServerFn, cc(function(...)
            local self = ...
            local isSpawn = rawequal(self, Remotes.SpawnTower)
            local isSell = rawequal(self, Remotes.SellTower)
            local isMode = rawequal(self, Remotes.ChangeTowerMode)
            if not (isSpawn or isSell or isMode) then
                return originalInvokeServer(...)
            end
            if isMode then
                local tower = select(2, ...)
                local shouldRecord = MState.Rec and not SelfThreads[coroutine.running() or false]
                local ret = table.pack(originalInvokeServer(...))
                if shouldRecord then
                    local ok, err = pcall(RecordMode, tower)
                    if not ok then
                        notyuri("[Macro Rec] resolve error:", tostring(err))
                    end
                end
                return table.unpack(ret, 1, ret.n)
            end
            local nargs = table.pack(...)
            local pend = nil
            if MState.Rec and not SelfThreads[coroutine.running() or false] then
                local ok, snap = pcall(SnapshotCall, self, nargs)
                if ok and snap then pend = snap end
            end
            local ret = table.pack(originalInvokeServer(...))
            if pend then
                local ok, err = pcall(ResolveCall, pend, ret)
                if not ok then
                    notyuri("[Macro Rec] resolve error:", tostring(err))
                end
            end
            return table.unpack(ret, 1, ret.n)
        end))
        notyuri("[Macro] InvokeServer hookfunction installed (captures stored-reference InvokeServer calls; covers place/upgrade/sell)")
        if Support.HookMeta then
            local originalNamecallDot
            originalNamecallDot = hookmetamethod(game, "__namecall", cc(function(...)
                local self = ...
                local method = getnamecallmethod()
                if method == "InvokeServer" then
                    local isSpawn = rawequal(self, Remotes.SpawnTower)
                    local isSell = rawequal(self, Remotes.SellTower)
                    local isMode = rawequal(self, Remotes.ChangeTowerMode)
                    if isMode and MState.Rec and not SelfThreads[coroutine.running() or false] then
                        local args = table.pack(...)
                        local tower = args[2]
                        local retOk, ret = pcall(function()
                            return table.pack(originalNamecallDot(table.unpack(args, 1, args.n)))
                        end)
                        if not retOk then
                            notyuri("[Macro Rec] namecall passthrough error:", tostring(ret))
                            error(ret, 0)
                        end
                        local ok2, err = pcall(RecordMode, tower)
                        if not ok2 then
                            notyuri("[Macro Rec] resolve error:", tostring(err))
                        end
                        return table.unpack(ret, 1, ret.n)
                    end
                    if (isSpawn or isSell) and MState.Rec and not SelfThreads[coroutine.running() or false] then
                        local args = table.pack(...)
                        local pend = nil
                        local ok, snap = pcall(SnapshotCall, self, args)
                        if ok and snap then pend = snap end
                        local retOk, ret = pcall(function()
                            return table.pack(originalNamecallDot(table.unpack(args, 1, args.n)))
                        end)
                        if not retOk then
                            notyuri("[Macro Rec] namecall passthrough error:", tostring(ret))
                            error(ret, 0)
                        end
                        if pend then
                            task.delay(3, function()
                                local ok2, err = pcall(ResolveCall, pend, ret)
                                if not ok2 then
                                    notyuri("[Macro Rec] resolve error:", tostring(err))
                                end
                            end)
                        end
                        return table.unpack(ret, 1, ret.n)
                    end
                end
                return originalNamecallDot(...)
            end))
            notyuri("[Macro] __namecall dot-call hook installed alongside hookfunction (captures ChangeTowerMode dot-call convention)")
        end
    else
        local originalNamecall
        originalNamecall = hookmetamethod(game, "__namecall", cc(function(...)
            local self = ...
            local method = getnamecallmethod()
            if method == "InvokeServer" then
                local isSpawn = rawequal(self, Remotes.SpawnTower)
                local isSell = rawequal(self, Remotes.SellTower)
                local isMode = rawequal(self, Remotes.ChangeTowerMode)
                if isMode and MState.Rec and not SelfThreads[coroutine.running() or false] then
                    local tower = select(2, ...)
                    local ret = table.pack(originalNamecall(...))
                    local ok2, err = pcall(RecordMode, tower)
                    if not ok2 then
                        notyuri("[Macro Rec] resolve error:", tostring(err))
                    end
                    return table.unpack(ret, 1, ret.n)
                end
                if (isSpawn or isSell) and MState.Rec and not SelfThreads[coroutine.running() or false] then
                    local nargs = table.pack(...)
                    local pend = nil
                    local ok, snap = pcall(SnapshotCall, self, nargs)
                    if ok and snap then pend = snap end
                    local ret = table.pack(originalNamecall(...))
                    if pend then
                        local ok2, err = pcall(ResolveCall, pend, ret)
                        if not ok2 then
                            notyuri("[Macro Rec] resolve error:", tostring(err))
                        end
                    end
                    return table.unpack(ret, 1, ret.n)
                end
            end
            return originalNamecall(...)
        end))
        notyuri("[Macro] __namecall fallback hook installed (hookfunction unsupported; ClientGuard dot-calls may be missed)")
    end
end
local function Func_MacroRecord(state)
    if not state then return end
    if Toggles.LoadMacro and Toggles.LoadMacro.Value then
        Toggles.LoadMacro:SetValue(false)
    end
    InstallMacroHook()
    MState.Cur = {entries = {}}
    MState.Step = 0
    MState.NextKey = 0
    MState.RecKeys = {}
    MState.Saved = false
    MState.Pending = {}
    MState.Adopted = {}
    UpdateMacroLabel("Waiting")
    notyuri("[Macro Rec] waiting for match to start")
    while Toggles.MacroRecord.Value and not IsMatchActive() do
        task.wait(0.25)
    end
    if not Toggles.MacroRecord.Value then
        MState.Cur = nil
        MState.Step = 0
        UpdateMacroLabel()
        return
    end
    MState.Rec = true
    UpdateMacroLabel()
    task.spawn(LabelPump)
    task.spawn(MacroSweeper)
    notyuri("[Macro Rec] recording started")
    while Toggles.MacroRecord.Value and IsMatchActive() do
        task.wait(0.25)
    end
    MState.Rec = false
    task.wait(1.5)
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
        local model = entry.Name and GetTowerModel(entry.Name)
        local config = model and model:FindFirstChild("Config")
        local price = config and config:FindFirstChild("Price")
        return price and price.Value or nil
    elseif entry.Type == "Upgrade" then
        return entry.Cost
    end
    return nil
end
local function IsTowerDebuffed(tower)
    local config = tower and tower:FindFirstChild("Config")
    local debuff = config and config:FindFirstChild("Debuff")
    if not debuff then return false end
    for _, v in pairs(debuff:GetChildren()) do
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            return true
        end
    end
    return false
end
local function WaitForCash(amount, timeout, tower)
    local needCash = amount and amount > 0
    if needCash and GetCash() >= amount and not (tower and IsTowerDebuffed(tower)) then return true end
    local start = timeout and tick()
    while Toggles.LoadMacro.Value and ((needCash and GetCash() < amount) or (tower and IsTowerDebuffed(tower))) do
        if timeout and (tick() - start) >= timeout then break end
        task.wait()
    end
    return Toggles.LoadMacro.Value and (not needCash or GetCash() >= amount) and not (tower and IsTowerDebuffed(tower))
end
local function FindTowerForEntry(entry)
    local t = entry.Key and MState.RepMap[entry.Key]
    if t and t.Parent and t.PrimaryPart then
        return t
    end
    local cf = entry.CF
    if type(cf) ~= "table" or #cf ~= 12 then return nil end
    local pos = Vector3.new(cf[1], cf[2], cf[3])
    local base = entry.Name
    if entry.Type == "Upgrade" then
        base = ParseUpgradeName(entry.Name) or entry.Name
    end
    if type(base) ~= "string" or base == "" then return nil end
    local best, bestDist = nil, 5
    for _, tower in ipairs(GetOwnedTowers()) do
        local pp = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart")
        if pp then
            local tn = GetTowerBaseName(tower)
            if tn == base or tower.Name == base or tower.Name == entry.Name then
                local dist = (pp.Position - pos).Magnitude
                if dist < bestDist then
                    best, bestDist = tower, dist
                end
            end
        end
    end
    if best then
        notyuri("[Macro Rep] position fallback resolved key", tostring(entry.Key), "->", GetTowerBaseName(best), string.format("(%.1f studs)", bestDist))
        if entry.Key then
            MState.RepMap[entry.Key] = best
        end
    end
    return best
end
local function ResolveTowerRetry(entry)
    local tower = FindTowerForEntry(entry)
    if tower and tower.Parent then return tower end
    local start = tick()
    while Toggles.LoadMacro.Value and (tick() - start) < 1 do
        task.wait()
        tower = FindTowerForEntry(entry)
        if tower and tower.Parent then return tower end
    end
    return nil
end
local function AnchorTowerHRP(model)
    if typeof(model) ~= "Instance" then return end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function()
            hrp.Anchored = true
        end)
    end
end
local function DoMacroAction(entry)
    if entry.Type == "Place" then
        local cf = entry.CF
        if type(cf) ~= "table" or #cf ~= 12 then return end
        local result
        for attempt = 1, 3 do
            if not Toggles.LoadMacro.Value then break end
            result = Invoke(Remotes.SpawnTower, entry.Name, CFrame.new(unpack(cf)))
            if typeof(result) == "Instance" then break end
            local existing = FindTowerForEntry(entry)
            if existing then
                result = existing
                notyuri("[Macro Rep] Place retry not needed: tower already at position", tostring(entry.Name))
                break
            end
            if attempt < 3 then
                local cost = GetMacroEntryCost(entry)
                notyuri("[Macro Rep] Place rejected, waiting for cash, attempt", attempt, "of 3")
                if not WaitForCash(cost, 5) then break end
            end
        end
        if typeof(result) == "Instance" then
            if entry.Key then
                MState.RepMap[entry.Key] = result
            end
            AnchorTowerHRP(result)
            Fire(Remotes.UpdateTowerBeamColor)
        elseif not (entry.Key and MState.RepMap[entry.Key]) then
            notyuri("[Macro Rep] Place SKIP: server rejected after 3 attempts", tostring(entry.Name))
        end
    elseif entry.Type == "Upgrade" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then
            notyuri("[Macro Rep] Upgrade SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        local cf = entry.CF
        if type(cf) ~= "table" or #cf ~= 12 then return end
        local _, targetLvl = ParseUpgradeName(entry.Name)
        local curLvl = GetTowerLevel(tower)
        if targetLvl and curLvl and curLvl >= targetLvl then
            notyuri("[Macro Rep] Upgrade skip: already at level", tostring(curLvl))
            return
        end
        local upCF = (tower.PrimaryPart and tower.PrimaryPart.CFrame) or CFrame.new(unpack(cf))
        local result
        for attempt = 1, 3 do
            if not Toggles.LoadMacro.Value then break end
            result = Invoke(Remotes.SpawnTower, entry.Name, upCF, tower, nil, entry.Cost)
            if typeof(result) == "Instance" then break end
            if attempt < 3 then
                notyuri("[Macro Rep] Upgrade rejected for key", tostring(entry.Key), "waiting for cash, attempt", attempt, "of 3")
                if not WaitForCash(entry.Cost, 5, tower) then break end
            end
        end
        if typeof(result) == "Instance" then
            if entry.Key then
                MState.RepMap[entry.Key] = result
            end
            AnchorTowerHRP(result)
            Fire(Remotes.UpdateTowerBeamColor)
        else
            notyuri("[Macro Rep] Upgrade SKIP: server rejected for key after 3 attempts", tostring(entry.Key))
        end
    elseif entry.Type == "Sell" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then
            notyuri("[Macro Rep] Sell SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        local ok = Invoke(Remotes.SellTower, tower)
        if ok then
            MState.RepMap[entry.Key] = nil
        end
    elseif entry.Type == "Mode" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then
            notyuri("[Macro Rep] Mode SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        Invoke(Remotes.ChangeTowerMode, tower)
    end
end
local function WaveElapsedSince(anchorTick, anchorRemaining)
    local remaining = GetRemainingTime()
    if remaining and anchorRemaining then
        return anchorRemaining - remaining
    end
    return tick() - anchorTick
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
        while Toggles.LoadMacro.Value and not IsMatchActive() do
            task.wait()
        end
        if not Toggles.LoadMacro.Value then break end
        for i, entry in ipairs(macro.entries) do
            if not Toggles.LoadMacro.Value then break end
            if not IsMatchActive() then
                notyuri("[Macro Rep] match ended mid-pass, aborting pass")
                break
            end
            MState.Step = i
            UpdateMacroLabel(entry.Type, entry.Time)
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
                while Toggles.LoadMacro.Value and GetWave() < tWave do
                    if not IsMatchActive() then break end
                    task.wait()
                end
                if not Toggles.LoadMacro.Value then break end
                if GetWave() > tWave + 1 then
                    skipStep = true
                else
                    local diff = GetRemainingTime() - tElapsed
                    if diff > 0 then
                        while Toggles.LoadMacro.Value and IsMatchActive() and GetRemainingTime() > tElapsed do
                            task.wait()
                        end
                    end
                end
            end
            if not Toggles.LoadMacro.Value then break end
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
            while Toggles.LoadMacro.Value and not IsMatchActive() do
                task.wait()
            end
        end
    end
    MState.Rep = false
    MState.Step = 0
    UpdateMacroLabel()
end
local LobbyState = {
    Remotes = nil,
    PartyRemotes = nil,
    Connected = false,
    Searching = false,
    LastQueue = 0,
    QueueCount = 0,
    LastCancel = 0,
    StatusText = "Idle",
    StatusRef = nil,
    Conns = {},
}
local function IsLobbyPlace()
    return RS:FindFirstChild("MatchmakingRemotes") ~= nil
end
local function GetMatchmakingRemotes()
    if LobbyState.Remotes ~= nil then return LobbyState.Remotes end
    local ok, mm = pcall(function()
        return RS:WaitForChild("MatchmakingRemotes", 3)
    end)
    if ok and mm then
        LobbyState.Remotes = mm
    end
    return LobbyState.Remotes
end
local function GetPartyRemotes()
    if LobbyState.PartyRemotes ~= nil then return LobbyState.PartyRemotes end
    local ok, pr = pcall(function()
        return RS:WaitForChild("PartyRemotes", 3)
    end)
    if ok and pr then
        LobbyState.PartyRemotes = pr
    end
    return LobbyState.PartyRemotes
end
local function UpdateLobbyStatus(suffix)
    if not (LobbyState.StatusRef and LobbyState.StatusRef.SetText) then return end
    local place = IsLobbyPlace() and "Lobby" or "In-game"
    local txt = string.format("%s | %s | queued %dx%s", place, LobbyState.StatusText, LobbyState.QueueCount, suffix and (" | " .. suffix) or "")
    pcall(function()
        LobbyState.StatusRef:SetText(txt)
    end)
end
local function BuildLobbyRequest()
    local mode = (Options.LobbyMode and Options.LobbyMode.Value) or "Any Mode"
    local map = (Options.LobbyMap and Options.LobbyMap.Value) or "Any Map"
    local amount = 0
    if Options.LobbyPlayers then
        local v = tonumber(Options.LobbyPlayers.Value)
        if v then amount = v end
    end
    return {
        Mode = mode,
        Map = map,
        Amount = amount,
        MinLevel = 1,
        MaxLevel = 9999,
    }
end
local function ConnectLobbyEvents()
    if LobbyState.Connected then return end
    local mm = GetMatchmakingRemotes()
    if not mm then return end
    LobbyState.Connected = true
    local function hookEvent(name, handler)
        local ok, ev = pcall(function()
            return mm:WaitForChild(name, 5)
        end)
        if ok and ev and ev:IsA("RemoteEvent") then
            table.insert(LobbyState.Conns, ev.OnClientEvent:Connect(handler))
            return true
        end
        return false
    end
    hookEvent("SearchStarted", function()
        LobbyState.Searching = true
        LobbyState.StatusText = "Searching"
        UpdateLobbyStatus()
    end)
    hookEvent("SearchCancelled", function(reason)
        LobbyState.Searching = false
        LobbyState.LastCancel = tick()
        LobbyState.StatusText = "Cancelled"
        notyuri("[Lobby] search cancelled:", tostring(reason))
        UpdateLobbyStatus("re-queueing")
    end)
    hookEvent("UpdateStatus", function(text)
        if type(text) == "string" then
            LobbyState.StatusText = text
            UpdateLobbyStatus()
        end
    end)
    hookEvent("MatchFound", function()
        LobbyState.Searching = false
        LobbyState.StatusText = "Match found"
        notyuri("[Lobby] match found, teleporting")
        UpdateLobbyStatus("teleporting")
    end)
    hookEvent("QueueStats", function(stats)
        if type(stats) == "table" and type(stats.total) == "number" then
            UpdateLobbyStatus(stats.total .. " in queue")
        end
    end)
    local pr = GetPartyRemotes()
    if pr then
        local ok, inviteEv = pcall(function()
            return pr:WaitForChild("InviteReceived", 5)
        end)
        if ok and inviteEv and inviteEv:IsA("RemoteEvent") then
            local ok2, respond = pcall(function()
                return pr:WaitForChild("RespondInvite", 5)
            end)
            if ok2 and respond then
                table.insert(LobbyState.Conns, inviteEv.OnClientEvent:Connect(function(payload)
                    if type(payload) ~= "table" or type(payload.fromUserId) ~= "number" then return end
                    if not (Toggles.AutoAcceptInvite and Toggles.AutoAcceptInvite.Value) then return end
                    pcall(function()
                        respond:FireServer(payload.fromUserId, true)
                    end)
                    notyuri("[Lobby] auto-accepted party invite from userId", tostring(payload.fromUserId))
                end))
            end
        end
    end
    notyuri("[Lobby] events connected")
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        local ok, err = pcall(function()
            if not IsLobbyPlace() then return end
            ConnectLobbyEvents()
            local mm = GetMatchmakingRemotes()
            if not mm then return end
            local startRemote = mm:FindFirstChild("StartMatchmaking")
            if not (startRemote and startRemote:IsA("RemoteEvent")) then return end
            if LobbyState.Searching then
                if (tick() - LobbyState.LastQueue) > 120 then
                    LobbyState.Searching = false
                    LobbyState.StatusText = "Queue timeout"
                    notyuri("[Lobby] queue timeout, re-queueing")
                end
                return
            end
            local sinceQueue = tick() - LobbyState.LastQueue
            local sinceCancel = tick() - LobbyState.LastCancel
            if sinceQueue < 3 or sinceCancel < 2 then return end
            local request = BuildLobbyRequest()
            pcall(function()
                startRemote:FireServer(request)
            end)
            LobbyState.Searching = true
            LobbyState.LastQueue = tick()
            LobbyState.QueueCount = LobbyState.QueueCount + 1
            LobbyState.StatusText = "Searching"
            notyuri("[Lobby] queued match:", request.Mode, "/", request.Map, "/", tostring(request.Amount) .. " players")
            UpdateLobbyStatus()
        end)
        if not ok then
            notyuri("[Lobby] error:", tostring(err))
        end
        task.wait(1)
    end
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
local function CountPlacedForBaseName(baseName)
    local count = 0
    for _, tower in ipairs(GetOwnedTowers()) do
        local config = tower:FindFirstChild("Config")
        local towerName = config and config:FindFirstChild("TowerName")
        if towerName and towerName.Value == baseName then
            count = count + 1
        end
    end
    return count
end
local function GetSlotPlaceOrder()
    local slots = {1, 2, 3, 4, 5, 6}
    table.sort(slots, function(a, b)
        return GetSlotOrder(a) < GetSlotOrder(b)
    end)
    return slots
end
local function Func_AutoPlace()
    local lastFail = {}
    local failCounts = {}
    while Toggles.AutoPlace.Value do
        local ok, err = pcall(function()
            if not IsMatchActive() or IsGamePaused() then return end
            if GetPlacedTowers() >= GetTowerLimit() then return end
            local cash = GetCash()
            if cash < 100 then return end
            local wave = GetWave()
            for _, slot in ipairs(GetSlotPlaceOrder()) do
                if not Toggles.AutoPlace.Value then return end
                local name = GetLoadoutSlot(slot)
                if name then
                    local placeWave = GetSlotPlaceWave(slot)
                    if placeWave <= 0 or wave >= placeWave then
                        local limit = GetSlotPlaceLimit(slot)
                        if limit > 0 then
                            local placed = CountPlacedForBaseName(name)
                            if placed < limit then
                                local memo = lastFail[name]
                                local paused = memo and (tick() - memo) < 10
                                if not paused then
                                    local model = GetTowerModel(name)
                                    if model and model.PrimaryPart then
                                        local config = model:FindFirstChild("Config")
                                        local price = config and config:FindFirstChild("Price")
                                        local tooPoor = price and price.Value > cash
                                        if not tooPoor then
                                            local spot = NextPlaceSpot(model)
                                            if spot then
                                                local cf = ComputePlaceCF(model, spot)
                                                local ghost = PCubeAcq()
                                                ghost.CFrame = cf
                                                local result = Invoke(Remotes.SpawnTower, name, cf)
                                                if typeof(result) == "Instance" then
                                                    ghost.Color = Color3.fromRGB(80, 255, 120)
                                                    if result:FindFirstChild("HumanoidRootPart") then
                                                        pcall(function()
                                                            result.HumanoidRootPart.Anchored = true
                                                        end)
                                                    end
                                                    Fire(Remotes.UpdateTowerBeamColor)
                                                    cash = GetCash()
                                                    failCounts[name] = 0
                                                    notyuri("[AutoPlay] Placed slot=" .. slot .. " tower=" .. name)
                                                    if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value then
                                                        local upgLimit = GetSlotUpgradeLimit(slot)
                                                        local nextModel, total = WalkUpgradeChain(result, GetCash())
                                                        if nextModel and total > 0 then
                                                            local afterLevelConfig = nextModel:FindFirstChild("Config")
                                                            local afterLevel = afterLevelConfig and afterLevelConfig:FindFirstChild("Level")
                                                            local levelOk = (upgLimit <= 0) or not afterLevel or afterLevel.Value <= upgLimit
                                                            if levelOk then
                                                                local upResult = Invoke(Remotes.SpawnTower, nextModel.Name, result.PrimaryPart.CFrame, result, nil, total)
                                                                if typeof(upResult) == "Instance" then
                                                                    Fire(Remotes.UpdateTowerBeamColor)
                                                                    notyuri("[AutoPlay] Place+Upgrade slot=" .. slot .. " tower=" .. name)
                                                                end
                                                            end
                                                        end
                                                    end
                                                    task.wait(0.3)
                                                else
                                                    ghost.Color = Color3.fromRGB(255, 80, 80)
                                                    failCounts[name] = (failCounts[name] or 0) + 1
                                                    if failCounts[name] >= 3 then
                                                        failCounts[name] = 0
                                                        lastFail[name] = tick()
                                                        notyuri("[AutoPlay] server rejected", name, "pausing slot " .. slot .. " for 10s")
                                                    end
                                                    task.wait(0.1)
                                                end
                                            else
                                                lastFail[name] = tick()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoPlay (place) error:", tostring(err))
        end
        task.wait(0.5)
    end
end
local function GetBaseNameToSlot()
    local map = {}
    for slot = 1, 6 do
        local name = GetLoadoutSlot(slot)
        if name then
            map[name] = slot
        end
    end
    return map
end
local function GetUpgradableTowers()
    local baseNameToSlot = GetBaseNameToSlot()
    local result = {}
    for _, tower in ipairs(GetOwnedTowers()) do
        if tower.Parent and tower.PrimaryPart then
            local stunned = IsTowerStunned(tower)
            local config = tower:FindFirstChild("Config")
            local sentry = config and config:FindFirstChild("SentryType")
            if not (stunned or sentry) then
                local towerNameVal = config and config:FindFirstChild("TowerName")
                local slot = towerNameVal and baseNameToSlot[towerNameVal.Value]
                local upgLimit = slot and GetSlotUpgradeLimit(slot) or 0
                local currentLevel = config and config:FindFirstChild("Level")
                local maxLevelVal = config and config:FindFirstChild("MaxLevel")
                local maxLevel = maxLevelVal and maxLevelVal.Value or 5
                local effectiveMax = (upgLimit > 0) and math.min(upgLimit, maxLevel) or maxLevel
                local level = currentLevel and currentLevel.Value or 0
                if level < effectiveMax then
                    table.insert(result, {
                        model = tower,
                        slot = slot,
                        level = level,
                        towerName = towerNameVal and towerNameVal.Value,
                    })
                end
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
            local sa, sb = a.slot or 99, b.slot or 99
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
            if not IsMatchActive() or IsGamePaused() then return end
            local units = GetUpgradableTowers()
            local target = UpgradeCand(units)
            if not target then return end
            local tower = target.model
            local nextModel, total = WalkUpgradeChain(tower, GetCash())
            if nextModel and total > 0 then
                local result = Invoke(Remotes.SpawnTower, nextModel.Name, tower.PrimaryPart.CFrame, tower, nil, total)
                if typeof(result) == "Instance" then
                    if result:FindFirstChild("HumanoidRootPart") then
                        pcall(function()
                            result.HumanoidRootPart.Anchored = true
                        end)
                    end
                    Fire(Remotes.UpdateTowerBeamColor)
                    notyuri("[AutoPlay] Upgraded tower=" .. tostring(target.towerName) .. " -> " .. nextModel.Name)
                end
                task.wait(0.3)
            end
        end)
        if not ok then
            notyuri("AutoPlay (upgrade) error:", tostring(err))
        end
        task.wait(0.75)
    end
end
local function SendWebhook(title, description)
    if not request then return end
    local img = yuri[math.random(1, #yuri)]
    pcall(function()
        request({
            Url = Options.WebhookURL.Value,
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
local function EndScreen(statName, timeout)
    local start = tick()
    while tick() - start < (timeout or 2) do
        local value = EndStat(statName)
        if value and value > 0 then return value end
        task.wait(0.1)
    end
    return EndStat(statName)
end
local function SendMatchEndWebhook(outcome)
    local info = GetInfo()
    local mins = info and GetObject(info, "TotalTime.Minutes")
    local secs = info and GetObject(info, "TotalTime.Seconds")
    mins = mins and mins.Value or 0
    secs = secs and secs.Value or 0
    local bricksEarned = EndScreen("Bricks", 2) or 0
    local expEarned = EndScreen("Exp", 2) or 0
    local rewards = string.format("+%d Bricks\n+%d Exp", bricksEarned, expEarned)
    local desc = string.format(
        "**%s - %s**\n- Time: %d:%02d\n- Player: ||%s||\n- Rewards:\n%s",
        "Match Finished", outcome, mins, secs, Plr.Name, rewards
    )
    SendWebhook("Match Finished", desc)
    notyuri("[Webhook] Match finished notification sent:", outcome, "bricks:", bricksEarned, "exp:", expEarned)
end
local function Func_AutoStart()
    while Toggles.AutoStart.Value do
        local ok, err = pcall(function()
            local info = GetInfo()
            if not info then return end
            local running = info:FindFirstChild("GameRunning")
            if running and running.Value == true then return end 
            if Remotes.StartTimerVote then
                Fire(Remotes.StartTimerVote)
            end
        end)
        task.wait(0.5)
    end
end
local function Func_AutoVoteDifficulty()
    while Toggles.AutoVoteDifficulty.Value do
        local ok, err = pcall(function()
            local info = GetInfo()
            if not info then return end
            local voting = info:FindFirstChild("GamemodeVoting")
            local votingOpen = voting and voting.Value == true
            if votingOpen then
                if Remotes.VoteForMap and Options.DifficultyVote then
                    Fire(Remotes.VoteForMap, Options.DifficultyVote.Value)
                end
            end
        end)
        task.wait(0.5)
    end
end
local function Func_AutoVoteMap()
    while Toggles.AutoVoteMap.Value do
        local ok, err = pcall(function()
            local info = GetInfo()
            if not info then return end
            local voting = info:FindFirstChild("Voting")
            local votingOpen = voting and voting.Value == true
            if votingOpen then
                if Remotes.VoteForMap and Options.MapVote then
                    Fire(Remotes.VoteForMap, Options.MapVote.Value)
                end
            end
        end)
        task.wait(0.5)
    end
end
local function Func_AutoVoteModifiers()
    while Toggles.AutoVoteModifiers.Value do
        local ok, err = pcall(function()
            local info = GetInfo()
            if not info then return end
            local gamemodeVoting = info:FindFirstChild("GamemodeVoting")
            local gamemodeOpen = gamemodeVoting and gamemodeVoting.Value == true
            if gamemodeOpen then
                if Remotes.VoteForModifier and Options.ModifierVotes then
                    local selected = Options.ModifierVotes.Value or {}
                    local count = 0
                    for name, active in pairs(selected) do
                        if active then
                            count = count + 1
                            if count > 5 then break end
                            Fire(Remotes.VoteForModifier, name)
                        end
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end
local function Func_AutoTowerAbility()
    while Toggles.AutoAbility.Value do
        local ok, err = pcall(function()
            if not IsMatchActive() or IsGamePaused() then return end
            local towers = GetOwnedTowers()
            for _, tower in ipairs(towers) do
                if not Toggles.AutoAbility.Value then return end
                if tower.Parent then
                    local shape = GetTowerAbilityShape(tower)
                    if shape then
                        local abilityFolder = tower:FindFirstChild("AbilityFolder")
                        local cdVal = abilityFolder and abilityFolder:FindFirstChild("MaxCooldown")
                        local cooldown = cdVal and cdVal.Value or 30
                        local last = Ability.TowerCD[tower]
                        local ready = last == nil or (tick() - last) >= cooldown
                        if ready and not IsTowerStunned(tower) then
                            local lengthVal = abilityFolder and abilityFolder:FindFirstChild("Length")
                            local length = lengthVal and lengthVal.Value or 0
                            local fired = false
                            if shape == "MKI" then
                                local sub = tower:FindFirstChild("MKI Titan Dummy")
                                if sub then
                                    Fire(Remotes.Rage, tower, length, sub)
                                    fired = true
                                end
                            elseif shape == "TitanScale" then
                                local sub = tower:FindFirstChild("Titan Scale")
                                local costUse = abilityFolder and abilityFolder:FindFirstChild("CostUse")
                                if sub then
                                    if costUse and GetCash() >= costUse.Value then
                                        Fire(Remotes.Rage, tower, length, sub, costUse.Value, Plr)
                                        fired = true
                                    end
                                end
                            elseif shape == "Officer" then
                                local sub = tower:FindFirstChild("Officer Dummy")
                                if sub then
                                    Fire(Remotes.Rage, tower, length, sub)
                                    local abilityFolder2 = tower:FindFirstChild("AbilityFolder2")
                                    if abilityFolder2 then
                                        local length2Val = abilityFolder2:FindFirstChild("Length")
                                        local length2 = length2Val and length2Val.Value or 0
                                        Fire(Remotes.Rage2, tower, length2, sub)
                                    end
                                    fired = true
                                end
                            end
                            if fired then
                                Ability.TowerCD[tower] = tick()
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoAbility error:", tostring(err))
        end
        task.wait(1)
    end
end
local function Func_AutoAbility()
    while Toggles.AutoAbility.Value do
        local ok, err = pcall(function()
            if not IsMatchActive() or IsGamePaused() then return end
            local equipped = GetEquippedAbilities()
            if type(equipped) ~= "table" then return end
            for _, name in ipairs(equipped) do
                if not Toggles.AutoAbility.Value then return end
                if type(name) == "string" then
                    local data = GetAbilityData(name)
                    if data then
                        local state = AbilityState(name)
                        if state == "ready" then
                            local abilityType = data.AbilityType
                            if abilityType == "ArtilleryBarrage" then
                                local gold = GetGold()
                                local want = Options.ArtilleryGold and Options.ArtilleryGold.Value or 25
                                local bombs = math.ceil(want / 5)
                                local spend = bombs * 5
                                if gold < spend then
                                    bombs = math.floor(gold / 5)
                                    spend = bombs * 5
                                end
                                if spend >= 5 then
                                    local mobPos = GetNearestMobPos()
                                    local ground = mobPos and GetValidGroundPos(mobPos)
                                    if ground then
                                        Fire(Remotes.ActivateAbility, name, ground, spend)
                                    end
                                end
                            elseif abilityType == "AirStrike" or abilityType == "NapalmStrike" or abilityType == "HealZone" or abilityType == "Paratrooper" then
                                local mobPos = GetNearestMobPos()
                                local ground = mobPos and GetValidGroundPos(mobPos)
                                if ground then
                                    Fire(Remotes.ActivateAbility, name, ground)
                                end
                            elseif abilityType == "WallBuilding" or abilityType == "Watchtower" then
                            else
                                Fire(Remotes.ActivateAbility, name)
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoAbility error:", tostring(err))
        end
        task.wait(0.5)
    end
end
local function Func_AutoNuke()
    while Toggles.AutoNuke.Value do
        local ok, err = pcall(function()
            if not IsMatchActive() then return end
            local wave = GetWave()
            if Ability.NukeWave == wave then return end
            local pg = Plr:FindFirstChild("PlayerGui")
            local gui = pg and pg:FindFirstChild("GameGui")
            local abilities = gui and gui:FindFirstChild("Abilities")
            local scrolling = abilities and abilities:FindFirstChild("ScrollingFrame")
            local nuke = scrolling and scrolling:FindFirstChild("Nuke")
            if nuke and nuke.Active == true then
                Fire(Remotes.Nuke)
                Ability.NukeWave = wave
                notyuri("[AutoNuke] fired nuke on wave", tostring(wave))
            end
        end)
        if not ok then
            notyuri("AutoNuke error:", tostring(err))
        end
        task.wait(1)
    end
end
local function Func_AutoSkipWave()
    while Toggles.AutoSkipWave.Value do
        local ok, err = pcall(function()
            local canSkip = RS:FindFirstChild("CanSkipWave")
            if not (canSkip and canSkip.Value == true) then return end
            Invoke(Remotes.VoteSkip)
        end)
        task.wait(0.5)
    end
end
local function Func_AutoSkipCutscene()
    while Toggles.AutoSkipCutscene.Value do
        local ok, err = pcall(function()
            local pg = Plr:FindFirstChild("PlayerGui")
            local gui = pg and pg:FindFirstChild("GameGui")
            if not gui then return end
            local cutscene = gui:FindFirstChild("WaveSkipGuiCutsence")
            if cutscene and cutscene.Visible then
                Fire(Remotes.RequestSkipVote)
            end
        end)
        if not ok then
            notyuri("AutoSkipCutscene error:", tostring(err))
        end
        task.wait(0.5)
    end
end
local function Func_AutoGameSpeed()
    while Toggles.AutoGameSpeed.Value do
        local ok, err = pcall(function()
            if not IsMatchActive() then return end
            local info = GetInfo()
            if not info then return end
            local waveVal = info:FindFirstChild("Wave")
            if not waveVal or waveVal.Value > 1 then return end
            local speed = tonumber(Options.GameSpeedValue and Options.GameSpeedValue.Value or 2) or 2
            local speedGame = info:FindFirstChild("SpeedGame")
            local currentSpeed = speedGame and speedGame.Value
            if currentSpeed ~= speed then
                Fire(Remotes.RequestSpeedVote, speed)
                task.wait(0.5)
                Invoke(Remotes.VoteChangeSpeed, speed)
            end
        end)
        task.wait(1)
    end
end
local function Func_AutoReplay()
    while Toggles.AutoReplay.Value do
        local ok, err = pcall(function()
            local pg = Plr:FindFirstChild("PlayerGui")
            local gui = pg and pg:FindFirstChild("GameGui")
            local endScreen = gui and gui:FindFirstChild("EndScreen")
            if endScreen and endScreen.Visible then
                Fire(Remotes.ReplayVote)
            end
        end)
        if not ok then
            notyuri("AutoReplay error:", tostring(err))
        end
        task.wait(1)
    end
end
local function ConnectGameEvents()
    SafeConnect("AbilityTimer", function()
        return RunService.Heartbeat
    end, function()
        local now = tick()
        local info = GetInfo()
        local speed = info and info:FindFirstChild("GameSpeed")
        local mult = speed and speed.Value or 1
        local dt = (now - AbilityTimerLast) * mult
        AbilityTimerLast = now
        for name, t in pairs(Ability.Timers) do
            Ability.Timers[name] = t + dt
        end
    end)
    SafeConnect("AbilityState", function()
        return Remotes.AbilityStateUpdate and Remotes.AbilityStateUpdate.OnClientEvent
    end, function(payload)
        if type(payload) ~= "table" then return end
        for name, state in pairs(payload) do
            local prev = Ability.State[name]
            if type(state) == "table" then
                if state.active and not (prev and prev.active) then
                    Ability.Timers[name] = 0
                elseif not state.active and prev and prev.active then
                    Ability.Timers[name] = nil
                end
                Ability.State[name] = state
            end
        end
    end)
    SafeConnect("ShowSkip", function()
        return Remotes.ShowSkipEvent and Remotes.ShowSkipEvent.OnClientEvent
    end, function(show)
        if show ~= true then return end
        if not (Toggles.AutoSkipCutscene and Toggles.AutoSkipCutscene.Value) then return end
        Fire(Remotes.VoteEvent, "Skip")
    end)
    SafeConnect("MatchEndWebhook", function()
        local info = GetInfo()
        return info and info:FindFirstChild("Message") and info.Message.Changed
    end, function(value)
        if not (Toggles.WHMatchEnd and Toggles.WHMatchEnd.Value) then return end
        if value ~= "VICTORY" and value ~= "GAME OVER" then return end
        SendMatchEndWebhook(value)
    end)
end
task.spawn(function()
    local functionsFolder = RS:WaitForChild("Functions", 2)
    local eventsFolder = RS:WaitForChild("Events", 2)
    if functionsFolder then
        for _, name in ipairs(Functions) do
            local remote = functionsFolder:WaitForChild(name, 2)
            if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
                Remotes[name] = remote
            else
                notyuri("Remote missing:", name)
            end
        end
    end
    if eventsFolder then
        for _, name in ipairs(Events) do
            local remote = eventsFolder:WaitForChild(name, 2)
            if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
                Remotes[name] = remote
            else
                notyuri("Remote missing:", name)
            end
        end
        local nukeRemote = eventsFolder:WaitForChild("Nuke!", 2)
        if nukeRemote and nukeRemote:IsA("RemoteEvent") then
            Remotes.Nuke = nukeRemote
        else
            notyuri("Remote missing: Nuke!")
        end
        local beamRemote = eventsFolder:WaitForChild("UpdateTowerBeamColor", 2)
        if beamRemote and beamRemote:IsA("RemoteEvent") then
            Remotes.UpdateTowerBeamColor = beamRemote
        end
        for _, name in ipairs({"Rage", "Rage2"}) do
            local remote = eventsFolder:WaitForChild(name, 2)
            if remote and remote:IsA("RemoteEvent") then
                Remotes[name] = remote
            else
                notyuri("Remote missing:", name)
            end
        end
        local cutsceneFolder = eventsFolder:WaitForChild("Cutscene", 2)
        local skipVoteRemote = cutsceneFolder and cutsceneFolder:WaitForChild("RequestSkipVote", 2)
        if skipVoteRemote and skipVoteRemote:IsA("RemoteEvent") then
            Remotes.RequestSkipVote = skipVoteRemote
        else
            notyuri("Remote missing: Cutscene.RequestSkipVote")
        end
    end
    ConnectGameEvents()
    notyuri("[Dummy] remotes resolved")
end)
SafeConnect("WaveClock", function()
    local info = GetInfo()
    return info and info:FindFirstChild("Wave") and info.Wave.Changed
end, function()
    ResetPlaceCursor()
end)
SafeConnect("MatchReset", function()
    local info = GetInfo()
    return info and info:FindFirstChild("GameRunning") and info.GameRunning.Changed
end, function()
    Place.DataCache = nil
    Place.DataStamp = ""
    ResetPlaceCursor()
    Ability.TowerCD = {}
    Ability.NukeWave = nil
    Ability.State = {}
    Ability.Timers = {}
end)
LoadMDir()
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
    AutoPlay = Window:AddTab("Auto Play"),
    Player = Window:AddTab("Player"),
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
TB_Tabs.Macro = { T1 = TB.Main.Left.Autofarm:AddTab("Macro") }
TB_Tabs.Lobby = { T1 = TB.Main.Right.Autofarm:AddTab("Lobby") }
TB_Tabs.Lobby.T1:AddToggle("AutoJoin", {
    Text = "Auto Join Match",
    Default = false,
})
TB_Tabs.Lobby.T1:AddDropdown("LobbyMode", {
    Text = "Mode",
    Values = {"Any Mode", "TeamNoob", "TeamGuest", "OperationBlackout", "ControllerMode", "NoobBattalion", "ExperimentMode", "EndlessMode", "SandboxMode"},
    Default = "Any Mode",
})
TB_Tabs.Lobby.T1:AddDropdown("LobbyMap", {
    Text = "Map",
    Values = {"Any Map", "Noobland", "Noob City", "Base Forest", "Baseplate island", "Battlefield Base", "Beach Map", "Guest Base", "Lost island", "Noob Base", "Scale Base", "Frosthold Base", "Crossroads Map", "Harbor Base"},
    Default = "Any Map",
})
TB_Tabs.Lobby.T1:AddDropdown("LobbyPlayers", {
    Text = "Player Count",
    Values = {"1", "2", "3", "4", "Any"},
    Default = "1",
})
TB_Tabs.Lobby.T1:AddToggle("AutoAcceptInvite", {
    Text = "Auto Accept Party Invite",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoAbility", { Text = "Auto Abilities", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTowerAbility", { Text = "Auto Tower Abilities", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoNuke", { Text = "Auto Nuke", Default = false })
TB_Tabs.Autofarm.T1:AddDivider()
TB_Tabs.Autofarm.T1:AddToggle("AutoSkipWave", { Text = "Auto Skip Waves", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSkipCutscene", { Text = "Auto Skip Cutscene", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoGameSpeed", { Text = "Auto Game Speed", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReplay", { Text = "Auto Replay Match", Default = false })
local APLeft = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
local APRight = Tabs.AutoPlay:AddRightGroupbox("Limits")
APLeft:AddToggle("AutoPlace", { Text = "Auto Place", Default = false })
APLeft:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
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
APLeft:AddToggle("PlaceAndUpgrade", { Text = "Place and Upgrade", Default = false })
APLeft:AddDivider()
APRight:AddLabel("Place Order per Slot", true)
for i = 1, 6 do
    APRight:AddSlider("PlaceOrder" .. i, {
        Text = "Slot " .. i,
        Default = i,
        Min = 1,
        Max = 6,
        Rounding = 0,
        Compact = true,
    })
end
APRight:AddDivider()
for i = 1, 6 do
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
for i = 1, 6 do
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
for i = 1, 6 do
    APRight:AddSlider("UpgradeLimit" .. i, {
        Text = "Slot " .. i,
        Default = 0,
        Min = 0,
        Max = 30,
        Rounding = 0,
        Compact = true,
    })
end
local function GetSlotDisplayNames()
    local names = {}
    for slot = 1, 6 do
        local name = GetLoadoutSlot(slot)
        table.insert(names, "Slot " .. slot .. (name and (" (" .. name .. ")") or ""))
    end
    return names
end
local function SlotDisplayToNumber(display)
    local n = display and display:match("^Slot (%d+)")
    return n and tonumber(n) or nil
end
local APPosA = Tabs.AutoPlay:AddLeftGroupbox("Set Position")
local APPosB = Tabs.AutoPlay:AddRightGroupbox("Position Manage")
APPosA:AddLabel("Stand where you want units placed, select a slot, then press Set Slot Position.", true)
Place.MapLabelRef = APPosA:AddLabel("Current Map: ...", true)
APPosA:AddDropdown("SetSlotSelect", {
    Text = "Set Slot Position",
    Values = GetSlotDisplayNames(),
    Default = GetSlotDisplayNames()[1] or "",
})
APPosA:AddButton({
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
APPosA:AddButton({
    Text = "Mass Set All 6 Slots",
    Func = function()
        MassSetPos()
    end,
})
APPosB:AddLabel("Positions recorded for current map:", true)
Place.PosLabelRef = APPosB:AddLabel("Not in a game", true)
APPosB:AddDivider()
APPosB:AddDropdown("ResetSlotSelect", {
    Text = "Reset Slot Position",
    Values = (function() local v = GetSlotDisplayNames() table.insert(v, "All Slots") return v end)(),
    Default = "All Slots",
})
APPosB:AddButton({
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
task.spawn(function()
    while true do
        UpdatePosLabels()
        task.wait(2)
        if Library.Unloaded then break end
    end
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoStart", { Text = "Auto Start", Default = false })
TB_Tabs.Autofarm.T1:AddDivider()
TB_Tabs.Autofarm2.T1:AddDropdown("DifficultyVote", {
    Text = "Difficulty",
    Values = {"Any Mode", "TeamNoob", "TeamGuest", "OperationBlackout", "ControllerMode", "NoobBattalion", "ExperimentMode", "EndlessMode", "SandboxMode"},
    Default = "Any Mode",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteDifficulty", {
    Text = "Auto Vote Difficulty",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("MapVote", {
    Text = "Map",
    Values = {"Noobland", "Noob City", "Base Forest", "Baseplate island", "Battlefield Base", "Beach Map", "Guest Base", "Lost island", "Noob Base", "Scale Base", "Frosthold Base", "Crossroads Map", "Harbor Base"},
    Default = "Noobland",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteMap", {
    Text = "Auto Vote Map",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("ModifierVotes", {
    Text = "Modifiers",
    Values = {"HPMultiplier", "ShieldMultiplier", "ShadowHidden", "ShadowAntiBurn", "RangeAttack", "FogIsComing", "ImmortalTower", "MoreRewardWave", "LowerTowerRange", "LessMoneyHit", "DisableWaveEvent", "EnemyFastSpeed", "BaseHP1", "MoreCost"},
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteModifiers", {
    Text = "Auto Vote Modifiers",
    Default = false,
})
TB_Tabs.Macro.T1:AddDropdown("MacroSelected", {
    Text = "Select File",
    Values = ListMacros(),
    Default = ListMacros()[1] or "",
})
TB_Tabs.Macro.T1:AddInput("FileName", {
    Text = "File Name",
    Default = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Macro.T1:AddDropdown("ReplayMode", {
    Text = "Replay Mode",
    Values = {"Time", "Money"},
    Default = "Time",
})
TB_Tabs.Macro.T1:AddToggle("MacroRecord", {
    Text = "Record Macro",
    Default = false,
})
TB_Tabs.Macro.T1:AddToggle("LoadMacro", {
    Text = "Play Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Macro.T1:AddLabel("Idle", true)
TB_Tabs.Autofarm2.T1:AddSlider("ArtilleryGold", {
    Text = "Artillery Gold",
    Default = 25,
    Min = 5,
    Max = 500,
    Rounding = 0,
    Compact = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("GameSpeedValue", {
    Text = "Game Speed Target",
    Values = {"1", "1.5", "2"},
    Default = "2",
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
Toggles.AutoPlace:OnChanged(function(state)
    Thread("Dummy.AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), state)
    if not state then
        PCubeReleaseAll()
    end
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("Dummy.AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state)
end)
Toggles.AutoStart:OnChanged(function(state)
    Thread("Dummy.AutoStart", SafeLoop("AutoStart", Func_AutoStart), state)
end)
Toggles.AutoVoteDifficulty:OnChanged(function(state)
    Thread("Dummy.AutoVoteDifficulty", SafeLoop("AutoVoteDifficulty", Func_AutoVoteDifficulty), state)
end)
Toggles.AutoVoteMap:OnChanged(function(state)
    Thread("Dummy.AutoVoteMap", SafeLoop("AutoVoteMap", Func_AutoVoteMap), state)
end)
Toggles.AutoVoteModifiers:OnChanged(function(state)
    Thread("Dummy.AutoVoteModifiers", SafeLoop("AutoVoteModifiers", Func_AutoVoteModifiers), state)
end)
Toggles.AutoAbility:OnChanged(function(state)
    Thread("Dummy.AutoAbility", SafeLoop("AutoAbility", Func_AutoAbility), state)
end)
Toggles.AutoTowerAbility:OnChanged(function(state)
    Thread("Dummy.AutoTowerAbility", SafeLoop("AutoTowerAbility", Func_AutoTowerAbility), state)
end)
Toggles.AutoJoin:OnChanged(function(state)
    Thread("Dummy.AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), state)
    if state then
        task.spawn(function()
            ConnectLobbyEvents()
        end)
    end
end)
Toggles.AutoNuke:OnChanged(function(state)
    Thread("Dummy.AutoNuke", SafeLoop("AutoNuke", Func_AutoNuke), state)
end)
Toggles.AutoSkipWave:OnChanged(function(state)
    Thread("Dummy.AutoSkipWave", SafeLoop("AutoSkipWave", Func_AutoSkipWave), state)
end)
Toggles.AutoSkipCutscene:OnChanged(function(state)
    Thread("Dummy.AutoSkipCutscene", SafeLoop("AutoSkipCutscene", Func_AutoSkipCutscene), state)
end)
Toggles.AutoGameSpeed:OnChanged(function(state)
    Thread("Dummy.AutoGameSpeed", SafeLoop("AutoGameSpeed", Func_AutoGameSpeed), state)
end)
Toggles.AutoReplay:OnChanged(function(state)
    Thread("Dummy.AutoReplay", SafeLoop("AutoReplay", Func_AutoReplay), state)
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
    Thread("Dummy.LoadMacro", SafeLoop("Macro Replay", Func_MacroReplay), state)
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
local WHGroup = Tabs.Webhook:AddLeftGroupbox("Webhook")
WHGroup:AddInput("WebhookURL", {
    Text = "Webhook URL",
    Default = "",
    Placeholder = "https://discord.com/api/webhooks/...",
})
WHGroup:AddToggle("WHMatchEnd", {
    Text = "Match Finished",
    Default = false,
})
if not Support.Webhook then
    WHGroup:AddLabel("<font color='#FFA500'>Executor does not support HTTP requests.</font>", true)
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
    for _, conn in ipairs(LobbyState.Conns) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(LobbyState.Conns)
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
SaveManager:SetFolder("Yuri/DD")
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
