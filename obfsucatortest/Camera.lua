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
local l,f={},"1log.txt";if isfile and isfile(f)then delfile(f)end;if writefile then writefile(f,"")end;function notyuri(...)local t=table.create(select("#",...))for i=1,select("#",...)do t[i]=tostring(select(i,...))end local s=("[%s] %s"):format(os.date("%H:%M:%S"),table.concat(t," "));l[#l+1]=s;if appendfile then appendfile(f,s.."\n")end end
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
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Shared = {
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
function AddMultiDropdown(group, id, config)
    if type(group) == "string" then
        local selected = {}
        local dropdown = Options[group]
        local values = dropdown and dropdown.Values or {}
        local chosen = dropdown and dropdown.Value or {}
        if chosen["All"] then
            for _, label in ipairs(values) do
                if label ~= "All" then selected[label] = true end
            end
        else
            for label, active in pairs(chosen) do
                if active and label ~= "All" then selected[label] = true end
            end
        end
        return selected
    end
    config = config or {}
    local values = { "All" }
    for _, v in ipairs(config.Values or {}) do
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
    return Options[id]
end
function SafeLabel(target, id, text)
    if type(target) == "string" then
        local entry = Shared.Labels[target]
        if entry then
            entry.Text = id
            entry.Dirty = true
        end
        return
    end
    local label = target:AddLabel(text, true)
    Shared.Labels[id] = {Label = label, Text = text, Dirty = false}
    Thread("SafeLabel", function()
        while not Library.Unloaded do
            for key, entry in pairs(Shared.Labels) do
                if entry.Dirty then
                    entry.Dirty = false
                    local ok, err = pcall(function()
                        entry.Label:SetText(entry.Text)
                    end)
                    if not ok then
                        notyuri("SetText FAILED:", tostring(key), tostring(err))
                    end
                end
            end
            task.wait()
        end
    end, true)
    return label
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
    if teleport then
        local char = GetCharacter()
        local hrp = char and GetObject(char, "HumanoidRootPart")
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
            local pos = isModel and part:GetPivot().Position or part.Position
            if (hrp.Position - pos).Magnitude > target.MaxActivationDistance then
                TPTo(part)
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
local GameNetEvents = { "TowerAdd", "TowerUpgrade", "TowerSell", "TowerTarget", "WaveSkip", "ModeVote", "OnLeave", "PlayAgain" }
local GameNetFunctions = { "ChangeSpeed" }
local LobbyNetFunctions = { "ElevatorEnter", "ElevatorStart", "SummonTowers", "ElevatorSetModifiers" }
Shared.PosDir = "Yuri/CTD"
Shared.MDir = Shared.PosDir .. "/Macros"
Shared.PosPath = Shared.PosDir .. "/position.json"
Shared.Labels = {}
Shared.TowerLimit = 15
Shared.ModeIds = { "Easy", "Normal", "Hard", "Insane" }
Shared.MacroTimings = {
    PendingExpiry = 12,
    PendingLateResolve = 0.6,
    RemoteWait = 8,
    MaxAttempts = 20,
}
Shared.MState = {
    Rec = false,
    Rep = false,
    Cur = nil,
    Load = nil,
    Hooked = false,
    Step = 0,
    Total = 0,
    SelfFire = false,
    NextKey = 0,
    RecKeys = {},
    RepMap = {},
    Saved = false,
    Pending = {},
    Adopted = {},
    Broadcasts = {},
    OwnedAdds = {},
}
Shared.Place = {
    FailPos = {},
    TypeFails = {},
    PauseUntil = {},
    GridCache = nil,
    GridKey = "",
    SpiralCenter = nil,
    SpiralCursor = 0,
    Spiral = nil,
    SpiralFailMemo = {},
    SlotPositions = {},
}
Shared.Memo = {
    VoteDone = false,
    SkipAt = 0,
    LeftForEnd = false,
    SummonPoorNotified = false,
    StartedFor = {},
    ModifiersFor = {},
}
Shared.PlaceCube = {
    PartName = "PCube",
    Pending = Color3.fromRGB(80, 160, 255),
    Success = Color3.fromRGB(80, 255, 120),
    Fail = Color3.fromRGB(255, 80, 80),
}
Shared.PCubePool = {
    Free = {},
    Active = {},
}
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
local function IsInGame()
    return workspace:FindFirstChild("Game") ~= nil
end
local function IsInLobby()
    return workspace:FindFirstChild("Elevators") ~= nil
end
local function PopulateRemotes()
    local netEventFolder = GetObject(RS, "ModuleLoader.Shared.Network.RemoteEvent")
    if netEventFolder then
        for _, name in ipairs(GameNetEvents) do
            local remote = netEventFolder:FindFirstChild(name)
            if remote and remote:IsA("RemoteEvent") then
                Remotes[name] = remote
            end
        end
    end
    local netFuncFolder = GetObject(RS, "ModuleLoader.Shared.Network.RemoteFunction")
    if netFuncFolder then
        for _, name in ipairs(LobbyNetFunctions) do
            local remote = netFuncFolder:FindFirstChild(name)
            if remote and remote:IsA("RemoteFunction") then
                Remotes[name] = remote
            end
        end
        for _, name in ipairs(GameNetFunctions) do
            local remote = netFuncFolder:FindFirstChild(name)
            if remote and remote:IsA("RemoteFunction") then
                Remotes[name] = remote
            end
        end
    end
end
PopulateRemotes()
local function WaitForNetRemote(name, timeout)
    if Remotes[name] then return Remotes[name] end
    PopulateRemotes()
    local deadline = tick() + (timeout or 8)
    while not Remotes[name] and tick() < deadline do
        task.wait(0.25)
        PopulateRemotes()
    end
    return Remotes[name]
end
local function GetSharedModule(key)
    local clientFolder = GetObject(RS, "ModuleLoader.Client")
    if not clientFolder then return nil end
    return GetSafeModule(clientFolder, key)
end
local function GetConfig()
    local configsFolder = GetObject(RS, "ModuleLoader.Configs")
    return configsFolder and GetSafeModule(configsFolder, "Config") or nil
end
local function WaitForSharedModule(key, timeout)
    local deadline = tick() + (timeout or 30)
    local mod = GetSharedModule(key)
    while not mod and tick() < deadline do
        task.wait(0.25)
        mod = GetSharedModule(key)
    end
    return mod
end
local function GetGameReplicator()
    return GetSharedModule("GameReplicator")
end
local function GetReplica()
    local rep = GetSharedModule("Replication")
    if not rep then return nil end
    local ok, result = pcall(function()
        return rep.GetCurrentReplica()
    end)
    if ok then return result end
    return nil
end
local function GetProfileData()
    local replica = GetReplica()
    if replica and type(replica.Data) == "table" then
        return replica.Data
    end
    return nil
end
local function GetMessage()
    return workspace:GetAttribute("Message")
end
local function HasEnded()
    local msg = GetMessage()
    return msg == "You Won!" or msg == "You Lost!"
end
local MatchEnd = { Latched = false, Wave = 0 }
local function UpdateMatchEnd()
    local wave = workspace:GetAttribute("Wave") or 0
    if HasEnded() then
        if not MatchEnd.Latched then
            MatchEnd.Latched = true
            MatchEnd.Wave = wave
            notyuri("match end latched at wave", wave)
        end
    elseif MatchEnd.Latched and (wave == 0 or wave < MatchEnd.Wave) then
        MatchEnd.Latched = false
        notyuri("match end unlatched, wave", wave)
    end
end
local function IsMatchLive()
    UpdateMatchEnd()
    return IsInGame() and workspace:GetAttribute("Wave") ~= nil and not HasEnded() and not MatchEnd.Latched
end
local function GetWave()
    return workspace:GetAttribute("Wave") or 0
end
local function ParseTotalTime(text)
    if type(text) ~= "string" then return 0 end
    local minStr, secStr = text:match("^(%d+):(%d+)$")
    if not minStr then return 0 end
    return (tonumber(minStr) or 0) * 60 + (tonumber(secStr) or 0)
end
local function GetTotalSeconds()
    return ParseTotalTime(workspace:GetAttribute("TotalTime"))
end
local WaveClock = { Wave = workspace:GetAttribute("Wave"), Elapsed = 0, Last = tick(), Live = false }
local function StepWaveClock()
    local now = tick()
    local wave = workspace:GetAttribute("Wave")
    local live = IsMatchLive()
    if wave ~= WaveClock.Wave or (live and not WaveClock.Live) then
        WaveClock.Wave = wave
        WaveClock.Elapsed = 0
    elseif (wave or 0) == 0 then
        WaveClock.Elapsed = 0
    else
        WaveClock.Elapsed = WaveClock.Elapsed + (now - WaveClock.Last) * (workspace:GetAttribute("GameSpeed") or 1)
    end
    WaveClock.Last = now
    WaveClock.Live = live
end
local function GetWaveElapsed()
    StepWaveClock()
    return WaveClock.Elapsed
end
local function GetMatchMoney()
    local stats = Plr:FindFirstChild("leaderstats")
    local money = stats and stats:FindFirstChild("Money")
    return (money and money.Value) or 0
end
local function GetPlacedTowers()
    local pt = Plr:FindFirstChild("PlacedTowers")
    return (pt and pt.Value) or 0
end
local function GetTowerCfg(name)
    local cfg = GetConfig()
    if type(cfg) ~= "table" or type(cfg.Towers) ~= "table" then return nil end
    return cfg.Towers[name]
end
local function GetHotbarSlots()
    local cfg = GetConfig()
    if type(cfg) == "table" and type(cfg.GameSettings) == "table" then
        return cfg.GameSettings.HotbarSlots or 5
    end
    return 5
end
local function GetSummonCrates()
    local cfg = GetConfig()
    if type(cfg) == "table" and type(cfg.GameSettings) == "table" and type(cfg.GameSettings.SummonCrates) == "table" then
        return cfg.GameSettings.SummonCrates
    end
    return {}
end
local function GetNextUpgrade(name, level)
    local cfg = GetTowerCfg(name)
    if type(cfg) ~= "table" or type(cfg.Upgrades) ~= "table" then return nil end
    return cfg.Upgrades[(level or 0) + 1]
end
local function GetPlacePrice(name)
    local cfg = GetTowerCfg(name)
    if type(cfg) ~= "table" or type(cfg.Upgrades) ~= "table" then return nil end
    local first = cfg.Upgrades[1]
    return first and first.Price or nil
end
local function GetPlacementLimit(name)
    local cfg = GetTowerCfg(name)
    if type(cfg) ~= "table" then return nil end
    return cfg.PlacementLimit
end
local function GetTowerModel(name)
    local cfg = GetTowerCfg(name)
    return cfg and cfg.Model or nil
end
local function GetTowerHitboxSize(name)
    local cfg = GetTowerCfg(name)
    if type(cfg) == "table" and cfg.HitboxSize then
        return cfg.HitboxSize
    end
    local model = GetTowerModel(name)
    if model and model:IsA("Model") then
        local ok, size = pcall(function()
            return model:GetExtentsSize()
        end)
        if ok then return size end
    end
    return Vector3.new(4, 4, 4)
end
local function GetDataTowers()
    local gr = GetGameReplicator()
    if gr and type(gr.Data) == "table" and type(gr.Data.Towers) == "table" then
        return gr.Data.Towers
    end
    return nil
end
local function GetDataTower(id)
    local towers = GetDataTowers()
    if not towers then return nil end
    local entry = towers[id]
    if type(entry) == "table" then return entry end
    local num = tonumber(id)
    if num then
        entry = towers[num]
        if type(entry) == "table" then return entry end
    end
    return nil
end
local function GetTowersFolder()
    if not IsInGame() then return nil end
    local gameFolder = workspace:FindFirstChild("Game")
    return gameFolder and gameFolder:FindFirstChild("Towers") or nil
end
local function IsOwnedTowerData(entry)
    if type(entry) ~= "table" then return false end
    if entry.OwnerUserId ~= nil then
        return entry.OwnerUserId == Plr.UserId
    end
    if entry.OwnerName ~= nil then
        return entry.OwnerName == Plr.Name
    end
    return false
end
local function GetOwnedTowers()
    local list = {}
    local towers = GetDataTowers()
    if not towers then return list end
    local folder = GetTowersFolder()
    for id, entry in pairs(towers) do
        if IsOwnedTowerData(entry) then
            table.insert(list, {
                Id = tostring(id),
                Data = entry,
                Model = folder and folder:FindFirstChild(tostring(id)) or nil,
            })
        end
    end
    return list
end
local function CountOwnedByName(name)
    local count = 0
    for _, tower in ipairs(GetOwnedTowers()) do
        if tower.Data and tower.Data.Name == name then
            count = count + 1
        end
    end
    return count
end
local function GetTowerLevel(entry)
    if type(entry) ~= "table" then return 1 end
    return entry.Level or 1
end
local function GetSlotByTowerName()
    local data = GetProfileData()
    local map = {}
    if not data or type(data.Towers) ~= "table" then return map end
    for _, v in pairs(data.Towers) do
        if type(v) == "table" and type(v.Name) == "string" and type(v.Equipped) == "number" then
            map[v.Name] = v.Equipped
        end
    end
    return map
end
local function GetTowerEntryForName(name, slot)
    local data = GetProfileData()
    if not data or type(data.Towers) ~= "table" then return nil, nil end
    if slot ~= nil then
        for k, v in pairs(data.Towers) do
            if type(v) == "table" and v.Name == name and v.Equipped == slot then
                return k, v
            end
        end
    end
    for k, v in pairs(data.Towers) do
        if type(v) == "table" and v.Name == name then
            return k, v
        end
    end
    return nil, nil
end
local function GetLoadoutSlotName(slot)
    local map = GetSlotByTowerName()
    for name, s in pairs(map) do
        if s == slot then return name end
    end
    return nil
end
local function GetSlotDisplayNames()
    local map = GetSlotByTowerName()
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
local function GetSlotOption(prefix, slot, fallback)
    local opt = Options[prefix .. slot]
    return (opt and tonumber(opt.Value)) or fallback
end
local function Fire(remote, ...)
    if not remote then return false end
    local args = {...}
    Shared.MState.SelfFire = true
    local ok = pcall(function()
        remote:FireServer(unpack(args))
    end)
    Shared.MState.SelfFire = false
    return ok
end
local function EnsureFolderPath(path)
    pcall(function()
        local built = ""
        for _, part in ipairs(path:split("/")) do
            built = (built == "") and part or (built .. "/" .. part)
            if not isfolder(built) then
                makefolder(built)
            end
        end
    end)
end
local function LoadMDir()
    if not writefile then return end
    EnsureFolderPath(Shared.MDir)
end
local function ListMacros()
    local names = {}
    if not listfiles then return names end
    local ok, files = pcall(listfiles, Shared.MDir)
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
local function SaveJSON(path, data)
    return (pcall(function()
        writefile(path, HttpService:JSONEncode(data))
    end))
end
local function LoadJSON(path)
    if not isfile then return nil end
    if not isfile(path) then return nil end
    local ok, raw = pcall(readfile, path)
    if not ok or type(raw) ~= "string" or raw == "" then return nil end
    local data
    pcall(function()
        data = HttpService:JSONDecode(raw)
    end)
    if type(data) ~= "table" then return nil end
    return data
end
local function LoadMacro(name)
    if not name or name == "" or not readfile then return nil end
    local path = Shared.MDir .. "/" .. name .. ".json"
    local data = LoadJSON(path)
    if not data then return nil end
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
    local path = Shared.MDir .. "/" .. name .. ".json"
    local out = {}
    for i, entry in ipairs(macro.entries) do
        out[tostring(i)] = entry
    end
    return SaveJSON(path, out)
end
local function EnsurePosDir()
    if not makefolder or not isfolder then return end
    EnsureFolderPath(Shared.PosDir)
end
local function SavePositions()
    if not writefile then return false end
    EnsurePosDir()
    local out = {}
    for mapName, slots in pairs(Shared.Place.SlotPositions) do
        local slotOut = {}
        for slot, cfs in pairs(slots) do
            local cfOut = {}
            for i, cf in ipairs(cfs) do
                cfOut[i] = {cf:GetComponents()}
            end
            slotOut[tostring(slot)] = cfOut
        end
        out[mapName] = slotOut
    end
    return SaveJSON(Shared.PosPath, out)
end
local function LoadPositions()
    if not readfile or not isfile then return end
    local data = LoadJSON(Shared.PosPath)
    if not data then return end
    local loaded = {}
    for mapName, slots in pairs(data) do
        if type(slots) == "table" then
            loaded[mapName] = {}
            for slotStr, cfs in pairs(slots) do
                local slot = tonumber(slotStr)
                if slot and type(cfs) == "table" then
                    local cfList = {}
                    for i, comp in ipairs(cfs) do
                        if type(comp) == "table" and #comp == 12 then
                            cfList[i] = CFrame.new(unpack(comp))
                        end
                    end
                    loaded[mapName][slot] = cfList
                end
            end
        end
    end
    Shared.Place.SlotPositions = loaded
end
local function GetCurrentMapName()
    local map = workspace:GetAttribute("Map")
    if type(map) == "string" and map ~= "" then return map end
    return "Default"
end
local function PosText(mapName)
    if not mapName or not Shared.Place.SlotPositions[mapName] then return "No positions set" end
    local lines = {}
    for slot, cfs in pairs(Shared.Place.SlotPositions[mapName]) do
        local unitName = GetLoadoutSlotName(slot)
        table.insert(lines, "Slot " .. slot .. (unitName and (" (" .. unitName .. ")") or "") .. ": " .. #cfs .. " pos")
    end
    if #lines == 0 then return "No positions set" end
    table.sort(lines)
    return table.concat(lines, "\n")
end
local function UpdatePosLabels()
    SafeLabel("Positions", PosText(GetCurrentMapName()))
end
local function HandleSlotPos(act, slot)
    local mapName = GetCurrentMapName()
    if act == "reset" then
        if slot then
            if Shared.Place.SlotPositions[mapName] then Shared.Place.SlotPositions[mapName][slot] = nil end
            notyuri("ResetPos slot=" .. slot .. " map=" .. mapName)
        else
            Shared.Place.SlotPositions[mapName] = nil
            notyuri("ResetPos all map=" .. mapName)
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
    local cf = CFrame.new(hrp.Position)
    if not Shared.Place.SlotPositions[mapName] then Shared.Place.SlotPositions[mapName] = {} end
    if act == "set" then
        if not Shared.Place.SlotPositions[mapName][slot] then Shared.Place.SlotPositions[mapName][slot] = {} end
        table.insert(Shared.Place.SlotPositions[mapName][slot], cf)
        local count = #Shared.Place.SlotPositions[mapName][slot]
        notyuri("SetPos slot=" .. slot .. " count=" .. count .. " map=" .. mapName)
    elseif act == "massset" then
        for i = 1, GetHotbarSlots() do
            if not Shared.Place.SlotPositions[mapName][i] then Shared.Place.SlotPositions[mapName][i] = {} end
            table.insert(Shared.Place.SlotPositions[mapName][i], cf)
        end
        notyuri("MassSetPos map=" .. mapName)
    end
    SavePositions()
    UpdatePosLabels()
end
local function UpdateMacroLabel(suffix, elapsed, nextEntry)
    local txt
    local timeStr = ""
    if type(elapsed) == "number" then
        timeStr = " " .. tostring(elapsed)
    elseif type(elapsed) == "string" then
        timeStr = " " .. elapsed
    end
    if Shared.MState.Rec then
        if suffix then
            txt = string.format("Recording [%d] %s%s", Shared.MState.Step, suffix, timeStr)
        else
            txt = string.format("Recording [%d]", Shared.MState.Step)
        end
    elseif Shared.MState.Rep then
        txt = string.format("Replaying [%d / %d]", Shared.MState.Step, Shared.MState.Total)
        if suffix then
            txt = txt .. " | " .. suffix
            if timeStr ~= "" then txt = txt .. " [" .. timeStr:sub(2) .. "]" end
            if nextEntry then
                txt = txt .. " => " .. tostring(nextEntry.Type) .. " [" .. tostring(nextEntry.Time or "") .. "]"
            end
        end
    else
        txt = "Idle" .. (suffix and (" | " .. suffix) or "")
    end
    notyuri("UpdateLabel", txt)
    SafeLabel("Macro", txt)
end
local function RecordAct(kind, data, wave, elapsed)
    if not Shared.MState.Cur then return end
    Shared.MState.Step = Shared.MState.Step + 1
    local entry = {Type = kind, Time = tostring(wave or 0) .. " " .. tostring(elapsed or 0)}
    for k, val in pairs(data or {}) do
        entry[k] = val
    end
    table.insert(Shared.MState.Cur.entries, entry)
    UpdateMacroLabel(kind, entry.Time)
    notyuri("", kind, "confirmed", "wave", tostring(wave), string.format("%.2fs", elapsed))
end
local function ParseMacroTime(entry)
    local wStr, eStr = (entry.Time or ""):match("^(%d+)%s+(.+)$")
    return tonumber(wStr) or 0, tonumber(eStr) or 0
end
local function SortMacroEntries(entries)
    local order = {}
    for i, entry in ipairs(entries) do
        order[entry] = i
    end
    table.sort(entries, function(a, b)
        local wa, ea = ParseMacroTime(a)
        local wb, eb = ParseMacroTime(b)
        if wa ~= wb then return wa < wb end
        if ea ~= eb then return ea < eb end
        return order[a] < order[b]
    end)
    local n = #entries
    local s = 1
    while s <= n do
        local e = s
        local ws, es = ParseMacroTime(entries[s])
        while e < n do
            local wn, en = ParseMacroTime(entries[e + 1])
            if wn ~= ws or en ~= es then break end
            e = e + 1
        end
        if e > s then
            local slots = {}
            for i = s, e do
                local entry = entries[i]
                if entry.Type == "Upgrade" and entry.Key ~= nil and type(entry.Level) == "number" then
                    slots[entry.Key] = slots[entry.Key] or {}
                    table.insert(slots[entry.Key], i)
                end
            end
            for _, positions in pairs(slots) do
                if #positions > 1 then
                    local group = {}
                    for _, p in ipairs(positions) do
                        table.insert(group, entries[p])
                    end
                    table.sort(group, function(a, b) return a.Level < b.Level end)
                    for j, p in ipairs(positions) do
                        entries[p] = group[j]
                    end
                end
            end
        end
        s = e + 1
    end
    local byKey = {}
    for i, entry in ipairs(entries) do
        if entry.Type == "Upgrade" and entry.Key ~= nil and type(entry.Level) == "number" then
            byKey[entry.Key] = byKey[entry.Key] or {}
            table.insert(byKey[entry.Key], i)
        end
    end
    for _, positions in pairs(byKey) do
        local levels = {}
        for _, p in ipairs(positions) do
            table.insert(levels, entries[p].Level)
        end
        table.sort(levels)
        for j, p in ipairs(positions) do
            entries[p].Level = levels[j]
        end
    end
end
local function TowerNearPos(tower, pos, radius)
    if not pos then return false end
    local pp = tower.Model and (tower.Model.PrimaryPart or tower.Model:FindFirstChild("HumanoidRootPart"))
    if not pp and tower.Model then
        pp = tower.Model:FindFirstChildWhichIsA("BasePart")
    end
    if not pp and type(tower.Data) == "table" and tower.Data.Pos then
        return (tower.Data.Pos - pos).Magnitude <= (radius or 4)
    end
    if not pp then return false end
    return (pp.Position - pos).Magnitude <= (radius or 4)
end
local function EnsureRecKey(id)
    if id == nil then return nil end
    local key = Shared.MState.RecKeys[id]
    if not key then
        Shared.MState.NextKey = Shared.MState.NextKey + 1
        key = Shared.MState.NextKey
        Shared.MState.RecKeys[id] = key
        Shared.MState.Adopted[key] = true
    end
    return key
end
local function FindOwnedAdd(name, pos, radius)
    local now = tick()
    local best, bestDist = nil, math.huge
    for _, add in ipairs(Shared.MState.OwnedAdds) do
        if add.Name == name and not add.Claimed and (now - add.at) < 5 then
            local dist = pos == nil and 0 or (add.Pos - pos).Magnitude
            if dist <= (radius or 6) and dist < bestDist then
                best, bestDist = add, dist
            end
        end
    end
    return best
end
local function TakeBroadcast(kind, id)
    for i, b in ipairs(Shared.MState.Broadcasts) do
        if b.Kind == kind and tostring(b.Id) == tostring(id) then
            table.remove(Shared.MState.Broadcasts, i)
            return b
        end
    end
    return nil
end
local function ConfirmPlace(pend, add)
    pend.Resolved = true
    add.Claimed = true
    local key = EnsureRecKey(add.Id)
    pend.Key = key
    RecordAct("Place", {Key = key, Name = pend.Name, UnitId = pend.UnitId, CF = pend.CF}, pend.Wave, pend.Elapsed)
    if pend.Late then
        notyuri("Place late-confirmed key=" .. tostring(key) .. " (" .. tostring(pend.Name) .. ")")
    end
end
local function EntryCF(position)
    if typeof(position) ~= "Vector3" then return nil end
    return {CFrame.new(position):GetComponents()}
end
local function ConfirmUpgrade(pend, broadcast)
    pend.Resolved = true
    local key = Shared.MState.RecKeys[pend.Id]
    key = key or EnsureRecKey(pend.Id)
    if not key then
        pend.Dropped = true
        return
    end
    pend.Key = key
    RecordAct("Upgrade", {Key = key, Level = broadcast.Level, Name = pend.Name, CF = EntryCF(pend.Position)}, pend.Wave, pend.Elapsed)
    if pend.Late then
        notyuri("Upgrade late-confirmed key=" .. tostring(key))
    end
end
local function ConfirmSell(pend)
    pend.Resolved = true
    local key = Shared.MState.RecKeys[pend.Id]
    pend.Key = key
    RecordAct("Sell", {Key = key, Name = pend.Name, CF = EntryCF(pend.Position)}, pend.Wave, pend.Elapsed)
end
local function ConfirmTarget(pend)
    pend.Resolved = true
    local key = Shared.MState.RecKeys[pend.Id]
    pend.Key = key
    RecordAct("Target", {Key = key, Name = pend.Name, CF = EntryCF(pend.Position)}, pend.Wave, pend.Elapsed)
end
local function SnapshotCall(self, nargs)
    if not (Shared.MState.Rec and Shared.MState.Cur) then return nil end
    local wave = GetWave()
    local elapsed = GetWaveElapsed()
    local pend
    if rawequal(self, Remotes.TowerAdd) then
        local payload = nargs[2]
        if type(payload) ~= "table" then return nil end
        local name = payload.Name
        local cf = payload.CFrame
        if type(name) ~= "string" or typeof(cf) ~= "CFrame" then return nil end
        pend = {
            Kind = "Place",
            Name = name,
            UnitId = payload.UnitId,
            CF = {cf:GetComponents()},
            Position = Vector3.new(cf.X, cf.Y, cf.Z),
        }
    elseif rawequal(self, Remotes.TowerUpgrade) or rawequal(self, Remotes.TowerSell) or rawequal(self, Remotes.TowerTarget) then
        local payload = nargs[2]
        if type(payload) ~= "table" or payload.Id == nil then return nil end
        local kind = "Upgrade"
        if rawequal(self, Remotes.TowerSell) then
            kind = "Sell"
        elseif rawequal(self, Remotes.TowerTarget) then
            kind = "Target"
        end
        pend = {Kind = kind, Id = tostring(payload.Id)}
        local data = GetDataTower(pend.Id)
        if data then
            pend.Name = data.Name
            pend.Position = data.Pos
        end
    else
        return nil
    end
    pend.Wave = wave
    pend.Elapsed = elapsed
    pend.At = tick()
    pend.Resolved = false
    table.insert(Shared.MState.Pending, pend)
    notyuri("", pend.Kind, "captured", tostring(pend.Name or pend.Id), "wave", tostring(wave), string.format("%.2fs", elapsed))
    return pend
end
local function ResolveCall(pend)
    if not (pend and not pend.Resolved) then return end
    if pend.Kind == "Place" then
        local add = FindOwnedAdd(pend.Name, pend.Position, 6)
        if add then
            ConfirmPlace(pend, add)
        end
    elseif pend.Kind == "Upgrade" then
        local broadcast = TakeBroadcast("TowerUpgrade", pend.Id)
        if broadcast then
            ConfirmUpgrade(pend, broadcast)
        end
    elseif pend.Kind == "Sell" then
        local broadcast = TakeBroadcast("TowerRemove", pend.Id)
        if broadcast then
            ConfirmSell(pend)
        end
    elseif pend.Kind == "Target" then
        local broadcast = TakeBroadcast("TowerTarget", pend.Id)
        if broadcast then
            ConfirmTarget(pend)
        end
    end
end
local function FindUnkeyedOwnedTower(predFn)
    for _, tower in ipairs(GetOwnedTowers()) do
        if not Shared.MState.RecKeys[tower.Id] and predFn(tower) then
            return tower
        end
    end
    return nil
end
local function ProcessPendingSweep()
    local now = tick()
    for _, pend in ipairs(Shared.MState.Pending) do
        if not pend.Resolved then
            local age = now - pend.At
            if age > Shared.MacroTimings.PendingExpiry then
                pend.Resolved = true
                pend.Dropped = true
                notyuri("", pend.Kind, "expired unresolved:", tostring(pend.Name or pend.Id))
            elseif age > Shared.MacroTimings.PendingLateResolve then
                if pend.Kind == "Place" then
                    local add = FindOwnedAdd(pend.Name, pend.Position, 6)
                    if add then
                        pend.Late = true
                        ConfirmPlace(pend, add)
                    end
                elseif pend.Kind == "Upgrade" then
                    local broadcast = TakeBroadcast("TowerUpgrade", pend.Id)
                    if broadcast then
                        pend.Late = true
                        ConfirmUpgrade(pend, broadcast)
                    else
                        local entry = GetDataTower(pend.Id)
                        if entry and type(entry.Level) == "number" and entry.Name then
                            local tower = FindUnkeyedOwnedTower(function(t)
                                return t.Id == pend.Id
                            end)
                            if tower then
                                pend.Late = true
                                pend.Key = EnsureRecKey(pend.Id)
                                RecordAct("Upgrade", {Key = pend.Key, Level = entry.Level}, pend.Wave, pend.Elapsed)
                                pend.Resolved = true
                            end
                        end
                    end
                elseif pend.Kind == "Sell" then
                    local broadcast = TakeBroadcast("TowerRemove", pend.Id)
                    if broadcast then
                        pend.Late = true
                        ConfirmSell(pend)
                    elseif GetDataTower(pend.Id) == nil then
                        pend.Late = true
                        ConfirmSell(pend)
                    end
                elseif pend.Kind == "Target" then
                    local broadcast = TakeBroadcast("TowerTarget", pend.Id)
                    if broadcast then
                        pend.Late = true
                        ConfirmTarget(pend)
                    end
                end
            end
        end
    end
    local kept = {}
    for _, pend in ipairs(Shared.MState.Pending) do
        if not pend.Resolved then
            table.insert(kept, pend)
        end
    end
    Shared.MState.Pending = kept
    local keptB = {}
    for _, b in ipairs(Shared.MState.Broadcasts) do
        if (now - b.at) < 10 then
            table.insert(keptB, b)
        end
    end
    Shared.MState.Broadcasts = keptB
end
local function MacroSweeper()
    while Shared.MState.Rec do
        local ok, err = pcall(ProcessPendingSweep)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait()
    end
    for _ = 1, 3 do
        if Shared.MState.Rec then break end
        if not Shared.MState.Cur then break end
        pcall(ProcessPendingSweep)
        task.wait()
    end
end
local function InstallGameListeners()
    if Shared.ListenersInstalled then return end
    local addRemote = WaitForNetRemote("TowerAdd", 10)
    if not addRemote then return end
    Shared.ListenersInstalled = true
    SafeConnect("TowerAddConfirm", function() return addRemote.OnClientEvent end, function(payload)
        if type(payload) ~= "table" then return end
        if not IsOwnedTowerData(payload) then return end
        local id = payload.Id
        if id == nil and payload.Index ~= nil then
            id = payload.Index
        end
        if id == nil then return end
        table.insert(Shared.MState.OwnedAdds, {
            Id = tostring(id),
            Name = payload.Name,
            Pos = payload.Pos,
            at = tick(),
        })
        if #Shared.MState.OwnedAdds > 20 then
            table.remove(Shared.MState.OwnedAdds, 1)
        end
    end)
    local upgradeRemote = Remotes.TowerUpgrade
    if upgradeRemote then
        SafeConnect("TowerUpgradeConfirm", function() return upgradeRemote.OnClientEvent end, function(payload)
            if type(payload) ~= "table" or payload.Id == nil then return end
            table.insert(Shared.MState.Broadcasts, {Kind = "TowerUpgrade", Id = tostring(payload.Id), Level = payload.Level, at = tick()})
            if #Shared.MState.Broadcasts > 200 then
                table.remove(Shared.MState.Broadcasts, 1)
            end
        end)
    end
    local removeRemote = WaitForNetRemote("TowerRemove", 10)
    if removeRemote then
        SafeConnect("TowerRemoveConfirm", function() return removeRemote.OnClientEvent end, function(payload)
            if type(payload) ~= "table" or payload.Id == nil then return end
            table.insert(Shared.MState.Broadcasts, {Kind = "TowerRemove", Id = tostring(payload.Id), at = tick()})
        end)
    end
    local targetRemote = Remotes.TowerTarget
    if targetRemote then
        SafeConnect("TowerTargetConfirm", function() return targetRemote.OnClientEvent end, function(payload)
            if type(payload) ~= "table" or payload.Id == nil then return end
            table.insert(Shared.MState.Broadcasts, {Kind = "TowerTarget", Id = tostring(payload.Id), at = tick()})
        end)
    end
    notyuri("game listeners installed")
end
local function InstallMacroHook()
    if Shared.MState.Hooked then return end
    if not Support.HookMeta then
        Library:Notify("Macro record requires hookmetamethod support", 4)
        return
    end
    WaitForNetRemote("TowerAdd", Shared.MacroTimings.RemoteWait)
    WaitForNetRemote("TowerUpgrade", 2)
    WaitForNetRemote("TowerSell", 2)
    WaitForNetRemote("TowerTarget", 2)
    Shared.MState.Hooked = true
    local cc = (typeof(newcclosure) == "function") and newcclosure or (function(f) return f end)
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", cc(function(...)
        local self = ...
        local method = getnamecallmethod()
        local ret = table.pack(originalNamecall(...))
        if method == "FireServer" and Shared.MState.Rec and not Shared.MState.SelfFire then
            local isAdd = rawequal(self, Remotes.TowerAdd)
            local isUpgrade = rawequal(self, Remotes.TowerUpgrade)
            local isSell = rawequal(self, Remotes.TowerSell)
            local isTarget = rawequal(self, Remotes.TowerTarget)
            if isAdd or isUpgrade or isSell or isTarget then
                local nargs = table.pack(...)
                local ok, snap = pcall(SnapshotCall, self, nargs)
                if ok and snap then
                    pcall(ResolveCall, snap)
                end
            end
        end
        return table.unpack(ret, 1, ret.n)
    end))
    notyuri("__namecall hook installed (captures place/upgrade/sell/target)")
end
local function Func_MacroRecord(state)
    if not state then return end
    if Toggles.LoadMacro and Toggles.LoadMacro.Value then
        Toggles.LoadMacro:SetValue(false)
    end
    InstallGameListeners()
    InstallMacroHook()
    Shared.MState.Cur = {entries = {}}
    Shared.MState.Step = 0
    Shared.MState.NextKey = 0
    Shared.MState.RecKeys = {}
    Shared.MState.Saved = false
    Shared.MState.Pending = {}
    Shared.MState.Adopted = {}
    Shared.MState.OwnedAdds = {}
    Shared.MState.Broadcasts = {}
    UpdateMacroLabel("Waiting")
    notyuri("waiting for match to start")
    while Toggles.MacroRecord.Value and not IsMatchLive() do
        task.wait()
    end
    if not Toggles.MacroRecord.Value then
        Shared.MState.Cur = nil
        Shared.MState.Step = 0
        UpdateMacroLabel()
        return
    end
    Shared.MState.Rec = true
    UpdateMacroLabel()
    task.spawn(MacroSweeper)
    notyuri("recording started")
    while Toggles.MacroRecord.Value and IsMatchLive() do
        task.wait()
    end
    Shared.MState.Rec = false
    task.wait()
    local entries = Shared.MState.Cur and #Shared.MState.Cur.entries or 0
    notyuri("recording stopped,", tostring(entries), "actions")
    if entries > 0 and not Shared.MState.Saved then
        Shared.MState.Saved = true
        SortMacroEntries(Shared.MState.Cur.entries)
        local recorded = Shared.MState.Cur
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
    Shared.MState.Cur = nil
    Shared.MState.Step = 0
    UpdateMacroLabel()
end
local function GetMacroEntryCost(entry)
    if entry.Type == "Place" then
        return GetPlacePrice(entry.Name)
    elseif entry.Type == "Upgrade" then
        if type(entry.Level) == "number" then
            local name = entry.Name
            if type(name) ~= "string" then
                local rep = entry.Key and Shared.MState.RepMap[entry.Key]
                local data = rep and rep.Id and GetDataTower(rep.Id)
                name = data and data.Name
            end
            local cfg = GetTowerCfg(name)
            if type(cfg) == "table" and type(cfg.Upgrades) == "table" then
                local up = cfg.Upgrades[entry.Level]
                if type(up) == "table" then return up.Price end
            end
        end
        return nil
    end
    return nil
end
local function WaitForCash(amount, timeout)
    if not amount or amount <= 0 then return true end
    if not IsMatchLive() then return false end
    if GetMatchMoney() >= amount then return true end
    local limit = timeout or 60
    local start = tick()
    while Toggles.LoadMacro.Value and IsMatchLive() and GetMatchMoney() < amount and (tick() - start) < limit do
        task.wait()
    end
    return Toggles.LoadMacro.Value and IsMatchLive() and GetMatchMoney() >= amount
end
local function FindTowerForEntry(entry)
    local t = entry.Key and Shared.MState.RepMap[entry.Key]
    if t and t.Id and GetDataTower(t.Id) then
        return t
    end
    local cf = entry.CF
    if type(cf) ~= "table" or #cf ~= 12 then return nil end
    local pos = Vector3.new(cf[1], cf[2], cf[3])
    local base = entry.Name
    if type(base) ~= "string" or base == "" then return nil end
    local best, bestDist = nil, 5
    for _, tower in ipairs(GetOwnedTowers()) do
        if tower.Data and tower.Data.Name == base then
            local towerPos = tower.Data.Pos or (tower.Model and tower.Model:GetPivot().Position) or nil
            if towerPos then
                local dist = (towerPos - pos).Magnitude
                if dist < bestDist then
                    best, bestDist = tower, dist
                end
            end
        end
    end
    if best then
        notyuri("position fallback resolved key", tostring(entry.Key), "->", tostring(best.Data.Name), string.format("(%.1f studs)", bestDist))
        if entry.Key then
            Shared.MState.RepMap[entry.Key] = best
        end
    end
    return best
end
local function ResolveTowerRetry(entry)
    local tower = FindTowerForEntry(entry)
    if tower and GetDataTower(tower.Id) then return tower end
    local start = tick()
    while Toggles.LoadMacro.Value and (tick() - start) < 1 do
        task.wait()
        tower = FindTowerForEntry(entry)
        if tower and GetDataTower(tower.Id) then return tower end
    end
    return nil
end
local function WaitForOwnedAdd(name, pos, timeout)
    local start = tick()
    while (tick() - start) < (timeout or 3) do
        local add = FindOwnedAdd(name, pos, 6)
        if add then return add end
        task.wait()
    end
    return nil
end
local function DoMacroAction(entry)
    if entry.Type == "Place" then
        local cf = entry.CF
        if type(cf) ~= "table" or #cf ~= 12 then return end
        local name = entry.Name
        if type(name) ~= "string" then return end
        local unitId = entry.UnitId
        if unitId == nil then
            unitId = select(1, GetTowerEntryForName(name))
        end
        if unitId == nil then
            notyuri("Place SKIP: no unit entry for", tostring(name))
            return
        end
        local result
        local placeCost = GetMacroEntryCost(entry)
        for batch = 1, 3 do
            if not Toggles.LoadMacro.Value then break end
            for attempt = 1, Shared.MacroTimings.MaxAttempts do
                if not Toggles.LoadMacro.Value then break end
                if not WaitForCash(placeCost) then break end
                Fire(Remotes.TowerAdd, {Name = name, UnitId = unitId, Pos = Vector3.new(cf[1], cf[2], cf[3]), CFrame = CFrame.new(unpack(cf))})
                result = WaitForOwnedAdd(name, Vector3.new(cf[1], cf[2], cf[3]), 1)
                if result then
                    result.Claimed = true
                    break
                end
            end
            if result then break end
            local existing = FindTowerForEntry(entry)
            if existing then
                result = existing
                notyuri("Place retry not needed: tower already at position", tostring(name))
                break
            end
            if batch < 3 then
                local cost = GetMacroEntryCost(entry)
                notyuri("Place rejected, waiting for cash, batch", batch, "of 3")
                if not WaitForCash(cost) then break end
            end
        end
        if result then
            if entry.Key then
                Shared.MState.RepMap[entry.Key] = {Id = result.Id, Data = GetDataTower(result.Id)}
                notyuri("Place mapped key", tostring(entry.Key), "-> Id", tostring(result.Id), "| GetDataTower found:", tostring(GetDataTower(result.Id) ~= nil))
            end
        else
            notyuri("Place SKIP: server rejected after retries", tostring(name))
        end
    elseif entry.Type == "Upgrade" then
        local rawEntry = entry.Key and Shared.MState.RepMap[entry.Key]
        local towerId = rawEntry and rawEntry.Id
        if not towerId then
            notyuri("Upgrade SKIP: no tower resolved for key", tostring(entry.Key), "| RepMap.Id =", "nil")
            return
        end
        local tower = {Id = towerId}
        local data = GetDataTower(towerId)
        local cost = GetMacroEntryCost(entry)
        if data then
            local cfg = GetTowerCfg(data.Name)
            local maxLevel = (cfg and cfg.Upgrades and #cfg.Upgrades) or 0
            if maxLevel > 0 and GetTowerLevel(data) >= maxLevel then
                notyuri("Upgrade skip: max level for", tostring(data.Name))
                return
            end
        end
        local confirmed
        for attempt = 1, Shared.MacroTimings.MaxAttempts do
            if not Toggles.LoadMacro.Value then break end
            Fire(Remotes.TowerUpgrade, {Id = tower.Id})
            local broadcast = nil
            local start = tick()
            while Toggles.LoadMacro.Value and (tick() - start) < 1 do
                for i, b in ipairs(Shared.MState.Broadcasts) do
                    if b.Kind == "TowerUpgrade" and tostring(b.Id) == tostring(tower.Id) then
                        broadcast = table.remove(Shared.MState.Broadcasts, i)
                        break
                    end
                end
                if broadcast then break end
                task.wait()
            end
            if broadcast then
                confirmed = broadcast
                break
            end
            if attempt < Shared.MacroTimings.MaxAttempts then
                notyuri("Upgrade rejected for key", tostring(entry.Key), "waiting for cash, attempt", attempt, "| cost", tostring(cost), "| money", tostring(GetMatchMoney()), "| entry level", tostring(entry.Level))
                if not WaitForCash(cost) then break end
            end
        end
        if not confirmed then
            notyuri("Upgrade SKIP: server rejected for key", tostring(entry.Key))
        end
    elseif entry.Type == "Sell" then
        local tower = ResolveTowerRetry(entry)
        if not tower then
            local mapped = entry.Key and Shared.MState.RepMap[entry.Key]
            local keys = {}
            for k in pairs(GetDataTowers() or {}) do
                table.insert(keys, tostring(k))
            end
            notyuri("Sell SKIP: no tower resolved for key", tostring(entry.Key))
            notyuri("Sell debug: RepMap Id =", tostring(mapped and mapped.Id), "| Data.Towers keys =", table.concat(keys, ","))
            local gr = GetGameReplicator()
            notyuri("Sell debug: shared =", type(shared), "| shared.Modules =", type(type(shared) == "table" and shared.Modules or nil), "| GameReplicator =", type(gr), "| Data =", type(gr and gr.Data), "| Data.Towers =", type(gr and gr.Data and gr.Data.Towers))
            return
        end
        Fire(Remotes.TowerSell, {Id = tower.Id})
        if entry.Key then
            Shared.MState.RepMap[entry.Key] = nil
        end
    elseif entry.Type == "Target" then
        local tower = ResolveTowerRetry(entry)
        if not tower then
            notyuri("Target SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        Fire(Remotes.TowerTarget, {Id = tower.Id})
    end
end
local function Func_MacroReplay()
    while Toggles.LoadMacro.Value do
        local macro = Shared.MState.Load
        if not macro or not macro.entries or #macro.entries == 0 then
            Toggles.LoadMacro:SetValue(false)
            Library:Notify("No macro loaded", 3)
            return
        end
        Shared.MState.Rep = true
        Shared.MState.Total = #macro.entries
        Shared.MState.Step = 0
        Shared.MState.RepMap = {}
        SortMacroEntries(macro.entries)
        UpdateMacroLabel()
        while Toggles.LoadMacro.Value and not IsMatchLive() do
            task.wait()
        end
        if not Toggles.LoadMacro.Value then break end
        for i, entry in ipairs(macro.entries) do
            if not Toggles.LoadMacro.Value then break end
            if not IsMatchLive() then
                notyuri("match ended mid-pass, aborting pass")
                break
            end
            Shared.MState.Step = i
            UpdateMacroLabel(entry.Type, entry.Time, macro.entries[i + 1])
            local replayMode = Options.ReplayMode and Options.ReplayMode.Value or "Time"
            local skipStep = false
            if replayMode == "Money" then
                local cost = GetMacroEntryCost(entry)
                if cost and cost > 0 then
                    if not WaitForCash(cost) then
                        notyuri("money wait aborted (toggle off or match ended)")
                    end
                end
            else
                local tWave, tElapsed = ParseMacroTime(entry)
                while Toggles.LoadMacro.Value and GetWave() < tWave do
                    if not IsMatchLive() then break end
                    task.wait()
                end
                if not Toggles.LoadMacro.Value then break end
                if GetWave() > tWave + 10 then
                    skipStep = true
                else
                    while Toggles.LoadMacro.Value and IsMatchLive() and GetWave() == tWave and GetWaveElapsed() < tElapsed do
                        task.wait()
                    end
                end
            end
            if not Toggles.LoadMacro.Value then break end
            if not IsMatchLive() then
                notyuri("match ended mid-pass, aborting pass")
                break
            end
            if not skipStep then
                local ok, err = pcall(DoMacroAction, entry)
                if not ok then
                    notyuri("action failed:", tostring(err))
                end
                task.wait(0)
            else
                UpdateMacroLabel("skipped")
                notyuri("skipped stale entry", entry.Type, tostring(entry.Time))
            end
        end
        Shared.MState.Rep = false
        Shared.MState.Step = 0
        UpdateMacroLabel("Finished")
        if Toggles.LoadMacro.Value then
            UpdateMacroLabel("Waiting")
            while Toggles.LoadMacro.Value and IsMatchLive() do
                task.wait()
            end
            local endWave = GetWave()
            while Toggles.LoadMacro.Value and not (IsMatchLive() and (GetWave() == 0 or GetWave() < endWave)) do
                task.wait()
            end
            notyuri("new match detected, wave", GetWave(), "prev end wave", endWave)
        end
    end
    Shared.MState.Rep = false
    UpdateMacroLabel()
end
local function GetTowerAreaParts()
    local gameFolder = workspace:FindFirstChild("Game")
    if not gameFolder then return nil end
    local folder = gameFolder:FindFirstChild("TowerArea")
    if not folder then return nil end
    local parts = {}
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("BasePart") then
            table.insert(parts, child)
        end
    end
    if #parts == 0 then return nil end
    table.sort(parts, function(a, b)
        return (a.Size.X * a.Size.Z) > (b.Size.X * b.Size.Z)
    end)
    return parts
end
local function BuildPlacementGrid(spacing)
    local parts = GetTowerAreaParts()
    if not parts then return nil end
    local s = math.clamp(spacing or 4, 3, 12)
    local grid = {}
    for _, part in ipairs(parts) do
        local halfX = part.Size.X / 2
        local halfZ = part.Size.Z / 2
        local minX = part.Position.X - halfX + (s / 2)
        local maxX = part.Position.X + halfX - (s / 2)
        local minZ = part.Position.Z - halfZ + (s / 2)
        local maxZ = part.Position.Z + halfZ - (s / 2)
        local x = minX
        while x <= maxX do
            local z = minZ
            while z <= maxZ do
                table.insert(grid, {Part = part, X = x, Z = z})
                z = z + s
            end
            x = x + s
        end
    end
    return grid
end
local function GetPlacementGrid()
    local spacing = 3
    local key = tostring(spacing)
    local alive = Shared.Place.GridCache and Shared.Place.GridCache[1] and Shared.Place.GridCache[1].Part and Shared.Place.GridCache[1].Part.Parent ~= nil
    if Shared.Place.GridKey ~= key or not alive then
        Shared.Place.GridCache = BuildPlacementGrid(spacing)
        Shared.Place.GridKey = key
    end
    return Shared.Place.GridCache
end
local function ClearExpiredFailPos()
    local now = tick()
    for pos, expiry in pairs(Shared.Place.FailPos) do
        if expiry < now then
            Shared.Place.FailPos[pos] = nil
        end
    end
end
local function GetModelPlacementOffsets(model)
    local offsetY = 0
    if model and model:IsA("Model") then
        local ok, bboxPos, bboxSize = pcall(function()
            local p, s = model:GetBoundingBox()
            return p, s
        end)
        if ok and bboxPos and bboxSize then
            local okP, pivot = pcall(function()
                return model:GetPivot()
            end)
            if okP and pivot then
                offsetY = math.max(pivot.Position.Y - (bboxPos.Y - bboxSize.Y / 2), 0)
            end
        end
    end
    return offsetY
end
local function TryCandidateSpot(part, x, z, offsetY, rot, hitboxSize)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = {part}
    local origin = Vector3.new(x, part.Position.Y + 60, z)
    local result = workspace:Raycast(origin, Vector3.new(0, -200, 0), params)
    if not result then return nil end
    local test = Instance.new("Part")
    test.Size = hitboxSize
    test.CFrame = CFrame.new(result.Position + Vector3.new(0, offsetY + hitboxSize.Y / 2, 0))
    test.Anchored = true
    test.CanCollide = false
    test.CanQuery = true
    test.CanTouch = false
    test.Transparency = 1
    test.Parent = nil
    local overlap = OverlapParams.new()
    overlap.FilterType = Enum.RaycastFilterType.Include
    local towersFolder = GetTowersFolder()
    if not towersFolder then
        test:Destroy()
        return CFrame.new(result.Position + Vector3.new(0, offsetY, 0)) * CFrame.Angles(0, math.rad(rot), 0)
    end
    overlap.FilterDescendantsInstances = {towersFolder}
    local ok, hits = pcall(function()
        local hitList = workspace:GetPartsInPart(test, overlap)
        test:Destroy()
        return hitList
    end)
    if not ok then
        pcall(function() test:Destroy() end)
        return nil
    end
    if #hits > 0 then return nil end
    return CFrame.new(result.Position + Vector3.new(0, offsetY, 0)) * CFrame.Angles(0, math.rad(rot), 0)
end
local function GetSpotForTower(name)
    local grid = GetPlacementGrid()
    if not grid then return nil, nil end
    ClearExpiredFailPos()
    local model = GetTowerModel(name)
    local offsetY = GetModelPlacementOffsets(model)
    local hitboxSize = GetTowerHitboxSize(name)
    local rot = 0
    for _, spot in ipairs(grid) do
        local posKey = string.format("%.1f,%.1f", spot.X, spot.Z)
        if not Shared.Place.FailPos[posKey] then
            local cf = TryCandidateSpot(spot.Part, spot.X, spot.Z, offsetY, rot, hitboxSize)
            if cf then
                return cf, posKey
            end
        end
    end
    return nil, nil
end
local function PCubeAcq()
    local part = table.remove(Shared.PCubePool.Free)
    if not part then
        part = Instance.new("Part")
        part.Name = Shared.PlaceCube.PartName
        part.Size = Vector3.new(0.5, 0.5, 0.5)
        part.Anchored = true
        part.CanCollide = false
        part.CastShadow = false
        part.Material = Enum.Material.Neon
    end
    part.Transparency = 0.55
    part.Color = Shared.PlaceCube.Pending
    part.Parent = workspace
    Shared.PCubePool.Active[part] = true
    return part
end
local function PCubeRelease(part)
    if part then
        if not Shared.PCubePool.Active[part] then return end
        Shared.PCubePool.Active[part] = nil
        part.Parent = nil
        table.insert(Shared.PCubePool.Free, part)
    else
        for p in pairs(Shared.PCubePool.Active) do
            Shared.PCubePool.Active[p] = nil
            p.Parent = nil
            table.insert(Shared.PCubePool.Free, p)
        end
    end
end
local function GetSpiralCenter()
    if Shared.Place.SpiralCenter then
        return Shared.Place.SpiralCenter
    end
    local parts = GetTowerAreaParts()
    if not parts or not parts[1] then return nil end
    Shared.Place.SpiralCenter = parts[1].Position
    return Shared.Place.SpiralCenter
end
local function SpiralNext(spacing)
    local center = GetSpiralCenter()
    if not center then return nil end
    local cursor = Shared.Place.SpiralCursor
    Shared.Place.SpiralCursor = cursor + 1
    if cursor == 0 then
        return Vector3.new(center.X, center.Y, center.Z)
    end
    local st = Shared.Place.Spiral
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
local function ResetSpiralCursor()
    Shared.Place.SpiralCursor = 0
    Shared.Place.SpiralCenter = nil
    Shared.Place.Spiral = {x = 0, z = 0, dx = 1, dz = 0, segLen = 1, stepped = 0, turns = 0}
    Shared.Place.SpiralFailMemo = {}
end
local function GetSpotForTowerSpiral(name)
    if not Shared.Place.Spiral then ResetSpiralCursor() end
    local offsetY = GetModelPlacementOffsets(GetTowerModel(name))
    local hitboxSize = GetTowerHitboxSize(name)
    local rot = 0
    local spacing = 3
    for _ = 1, 40 do
        local candidate = SpiralNext(spacing)
        if not candidate then return nil end
        local key = string.format("%.1f_%.1f", candidate.X, candidate.Z)
        local memo = Shared.Place.SpiralFailMemo[key]
        local blocked = memo and (tick() - memo) <= 30
        if not blocked then
            local parts = GetTowerAreaParts()
            local part = parts and parts[1]
            if not part then return nil end
            local cf = TryCandidateSpot(part, candidate.X, candidate.Z, offsetY, rot, hitboxSize)
            if cf then
                return cf
            end
            Shared.Place.SpiralFailMemo[key] = tick()
        end
    end
    return nil
end
local function GetSelectedTowerSlots()
    local map = GetSlotByTowerName()
    local list = {}
    for name, slot in pairs(map) do
        table.insert(list, {name = name, slot = slot})
    end
    table.sort(list, function(a, b)
        local sa = a.slot and GetSlotOption("PlaceOrder", a.slot, a.slot) or 99
        local sb = b.slot and GetSlotOption("PlaceOrder", b.slot, b.slot) or 99
        if sa ~= sb then return sa < sb end
        return a.name < b.name
    end)
    return list
end
local function TryPlaceTower(name, slot)
    local model = GetTowerModel(name)
    if not model then return false, nil end
    local price = GetPlacePrice(name)
    if price and GetMatchMoney() < price then return false, nil end
    local pause = Shared.Place.PauseUntil[name] or 0
    if tick() < pause then return false, nil end
    if slot then
        local placeWave = GetSlotOption("PlaceWave", slot, 0)
        if placeWave > 0 and GetWave() < placeWave then return false, nil end
        local slotLimit = GetSlotOption("PlaceLimit", slot, 0)
        if slotLimit > 0 and CountOwnedByName(name) >= slotLimit then return false, nil end
    end
    local maxCount = GetPlacementLimit(name)
    if maxCount and CountOwnedByName(name) >= maxCount then return false, nil end
    local unitId = select(1, GetTowerEntryForName(name, slot))
    if unitId == nil then return false, nil end
    local mapName = GetCurrentMapName()
    local savedList = slot and Shared.Place.SlotPositions[mapName] and Shared.Place.SlotPositions[mapName][slot]
    local cf, posKey, fromSaved
    if savedList and #savedList > 0 then
        cf = savedList[math.random(1, #savedList)]
        fromSaved = true
    else
        cf, posKey = GetSpotForTower(name)
        if not cf then
            cf = GetSpotForTowerSpiral(name)
        end
    end
    if not cf then return false, nil end
    local ghost = PCubeAcq()
    ghost.CFrame = cf
    Fire(Remotes.TowerAdd, {Name = name, UnitId = unitId, Pos = cf.Position, CFrame = cf})
    local add = WaitForOwnedAdd(name, cf.Position, 1.5)
    if add then
        ghost.Color = Shared.PlaceCube.Success
        Shared.Place.TypeFails[name] = 0
        PCubeRelease(ghost)
        local data = GetDataTower(add.Id)
        return true, {Id = add.Id, Data = data, Model = nil}
    end
    ghost.Color = Shared.PlaceCube.Fail
    PCubeRelease(ghost)
    if posKey and not fromSaved then
        Shared.Place.FailPos[posKey] = tick() + 30
    end
    Shared.Place.TypeFails[name] = (Shared.Place.TypeFails[name] or 0) + 1
    if Shared.Place.TypeFails[name] >= 3 then
        Shared.Place.PauseUntil[name] = tick() + 10
        Shared.Place.TypeFails[name] = 0
        notyuri("3 rejects for", name, "- pausing 10s")
    end
    return false, nil
end
local function TryUpgradeOnce(tower)
    local data = GetDataTower(tower.Id)
    if not data then return false, nil end
    local nextUp = GetNextUpgrade(data.Name, GetTowerLevel(data))
    if not (nextUp and nextUp.Price and GetMatchMoney() >= nextUp.Price) then
        return false
    end
    Fire(Remotes.TowerUpgrade, {Id = tower.Id})
    local start = tick()
    while (tick() - start) < 1 do
        for i, b in ipairs(Shared.MState.Broadcasts) do
            if b.Kind == "TowerUpgrade" and tostring(b.Id) == tostring(tower.Id) then
                table.remove(Shared.MState.Broadcasts, i)
                return true, {Id = tower.Id, Data = GetDataTower(tower.Id), Model = tower.Model}
            end
        end
        task.wait()
    end
    return false, nil
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local ok, err = pcall(function()
            if not (Remotes.TowerAdd and IsMatchLive()) then return end
            if GetPlacedTowers() >= Shared.TowerLimit then return end
            for _, entry in ipairs(GetSelectedTowerSlots()) do
                if not (Toggles.AutoPlace.Value and GetPlacedTowers() < Shared.TowerLimit) then return end
                local placed, tower = TryPlaceTower(entry.name, entry.slot)
                if placed then
                    notyuri("Placed", entry.name, "slot", tostring(entry.slot))
                    if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value and tower then
                        local upgLimit = entry.slot and GetSlotOption("UpgradeLimit", entry.slot, 0) or 0
                        for _ = 1, 30 do
                            if not Toggles.PlaceAndUpgrade.Value then break end
                            if upgLimit > 0 and tower.Data and GetTowerLevel(tower.Data) >= upgLimit then break end
                            if tower.Data then
                                local cfg = GetTowerCfg(tower.Data.Name)
                                local maxLevel = (cfg and cfg.Upgrades and #cfg.Upgrades) or 0
                                if maxLevel > 0 and GetTowerLevel(tower.Data) >= maxLevel then break end
                            end
                            local upgraded, newTower = TryUpgradeOnce(tower)
                            if not upgraded then break end
                            tower = newTower or tower
                            task.wait()
                        end
                    end
                end
                task.wait()
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait()
    end
end
local function GetUpgradableTowers()
    local slotByName = GetSlotByTowerName()
    local result = {}
    for _, tower in ipairs(GetOwnedTowers()) do
        local data = tower.Data
        if data and type(data.Name) == "string" then
            local slot = slotByName[data.Name]
            local upgLimit = slot and GetSlotOption("UpgradeLimit", slot, 0) or 0
            local level = GetTowerLevel(data)
            if upgLimit <= 0 or level < upgLimit then
                local cfg = GetTowerCfg(data.Name)
                local maxLevel = (cfg and cfg.Upgrades and #cfg.Upgrades) or 0
                local atMax = maxLevel > 0 and level >= maxLevel
                if not atMax then
                    local nextUp = GetNextUpgrade(data.Name, level)
                    if nextUp and nextUp.Price then
                        table.insert(result, {
                            model = tower,
                            slot = slot,
                            level = level,
                            towerName = data.Name,
                            price = nextUp.Price,
                        })
                    end
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
            local sa = a.slot and GetSlotOption("PlaceOrder", a.slot, a.slot) or 99
            local sb = b.slot and GetSlotOption("PlaceOrder", b.slot, b.slot) or 99
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
            if not (Remotes.TowerUpgrade and IsMatchLive()) then return end
            local units = GetUpgradableTowers()
            local target = UpgradeCand(units)
            if not target then return end
            if GetMatchMoney() < target.price then return end
            local tower = target.model
            local upgraded, _ = TryUpgradeOnce(tower)
            if upgraded then
                notyuri("Upgraded", target.towerName, "slot", tostring(target.slot))
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait()
    end
end
local function Func_AutoSell()
    local soldForWave = nil
    while Toggles.AutoSell.Value do
        local ok, err = pcall(function()
            if not (Remotes.TowerSell and IsMatchLive()) then return end
            local threshold = (Options.AutoSellValue and Options.AutoSellValue.Value) or 0
            local wave = GetWave()
            if threshold > 0 and wave >= threshold then
                if soldForWave ~= wave then
                    local sold = 0
                    for _, tower in ipairs(GetOwnedTowers()) do
                        if tower.Id then
                            Fire(Remotes.TowerSell, {Id = tower.Id})
                            sold = sold + 1
                            task.wait(0.1)
                        end
                    end
                    soldForWave = wave
                    notyuri("AutoSell sold", tostring(sold), "towers at wave", tostring(wave))
                end
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait(1)
    end
end
local function Func_AutoSkip()
    while Toggles.AutoSkip.Value do
        local ok, err = pcall(function()
            if not (Remotes.WaveSkip and IsMatchLive()) then return end
            if workspace:GetAttribute("CanSkip") then
                Fire(Remotes.WaveSkip)
                notyuri("skip vote sent")
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait(0.5)
    end
end

local function Func_AutoVoteMode()
    while Toggles.AutoVoteMode.Value do
        local ok, err = pcall(function()
            if not (Remotes.ModeVote and IsInGame()) then return end
            if workspace:GetAttribute("IsVoting") then
                local choice = Options.ModeVote and Options.ModeVote.Value or ""
                if choice ~= "" then
                    Fire(Remotes.ModeVote, choice)
                    notyuri("mode vote sent", choice)
                end
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait(0.5)
    end
end
local function Func_AutoLeave()
    while Toggles.AutoLeave.Value do
        local ok, err = pcall(function()
            if not (Remotes.OnLeave and IsInGame()) then return end
            if HasEnded() then
                Fire(Remotes.OnLeave)
                notyuri("left match after end")
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait(1)
    end
end
local function GetModifierNames()
    local cfg = GetConfig()
    local names = {}
    if type(cfg) == "table" and type(cfg.GameSettings) == "table" and type(cfg.GameSettings.Modifiers) == "table" then
        for name in pairs(cfg.GameSettings.Modifiers) do
            table.insert(names, name)
        end
    end
    table.sort(names)
    return names
end
local function Func_AutoPlayAgain()
    while Toggles.AutoPlayAgain.Value do
        local ok, err = pcall(function()
            if not (Remotes.PlayAgain and IsInGame()) then return end
            if HasEnded() then
                local raw = workspace:GetAttribute("PlayAgainVoters")
                local voters = raw and HttpService:JSONDecode(raw) or {}
                if table.find(voters, Plr.UserId) then return end
                Fire(Remotes.PlayAgain)
                notyuri("play again sent")
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait(1)
    end
end
local function Func_AutoSpeed()
    while Toggles.AutoSpeed.Value do
        local ok, err = pcall(function()
            if not (Remotes.ChangeSpeed and IsInGame()) then return end
            local speed = tonumber(Options.GameSpeed and Options.GameSpeed.Value)
            if not speed then return end
            if workspace:GetAttribute("GameSpeed") ~= speed then
                SafeInvoke(Remotes.ChangeSpeed, speed)
                notyuri("speed set", speed)
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait(1)
    end
end
local function GetElevators()
    local folder = workspace:FindFirstChild("Elevators")
    if not folder then return {} end
    local list = {}
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            table.insert(list, model)
        end
    end
    return list
end
local function GetElevatorZonePart(model)
    local part = model:FindFirstChild("Area")
    if part and part:IsA("BasePart") then return part end
    part = model:FindFirstChild("Hitbox")
    if part and part:IsA("BasePart") then return part end
    return model:FindFirstChildWhichIsA("BasePart")
end
local function IsInsideElevatorPart(model)
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not (hrp and model) then return false end
    local part = GetElevatorZonePart(model)
    if not part then return false end
    local localPos = part.CFrame:PointToObjectSpace(hrp.Position)
    local half = part.Size * 0.5
    return math.abs(localPos.X) <= half.X and math.abs(localPos.Y) <= half.Y and math.abs(localPos.Z) <= half.Z
end
local function PickElevator()
    local best = nil
    local selectedMap = Options.JoinMap and Options.JoinMap.Value
    for _, model in ipairs(GetElevators()) do
        local players = model:GetAttribute("Players") or 0
        local maxPlayers = model:GetAttribute("MaxPlayers") or 5
        if players < maxPlayers and model:GetAttribute("Map") == selectedMap then
            if not best or players < (best:GetAttribute("Players") or 0) then
                best = model
            end
        end
    end
    return best
end
local function ApplyElevatorModifiers(elevName)
    if not (Toggles.AutoModifiers and Toggles.AutoModifiers.Value) then return end
    if not Remotes.ElevatorSetModifiers then return end
    if Shared.Memo.ModifiersFor[elevName] then return end
    local selected = AddMultiDropdown("ModifiersSel")
    local list = {}
    for name in pairs(selected) do
        table.insert(list, name)
    end
    table.sort(list)
    if #list == 0 then return end
    local ok, err = pcall(function()
        Remotes.ElevatorSetModifiers:InvokeServer(elevName, list)
    end)
    if ok then
        Shared.Memo.ModifiersFor[elevName] = true
        notyuri("modifiers set", elevName, table.concat(list, ","))
    else
        notyuri("error:", tostring(err))
    end
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        local ok, err = pcall(function()
            if not (Remotes.ElevatorEnter and Remotes.ElevatorStart) then return end
            local inside = nil
            for _, model in ipairs(GetElevators()) do
                if IsInsideElevatorPart(model) then
                    inside = model
                    break
                end
            end
            if inside then
                if not Shared.Memo.StartedFor[inside.Name] then
                    ApplyElevatorModifiers(inside.Name)
                    local startResult = SafeInvoke(Remotes.ElevatorStart, inside.Name)
                    if startResult then
                        Shared.Memo.StartedFor[inside.Name] = true
                        notyuri("ready in elevator", inside.Name)
                    end
                end
            else
                Shared.Memo.StartedFor = {}
                Shared.Memo.ModifiersFor = {}
                local elev = PickElevator()
                if elev then
                    local part = GetElevatorZonePart(elev)
                    if part then
                        TPTo(part)
                        task.wait(0.2)
                    end
                    local entered = SafeInvoke(Remotes.ElevatorEnter, elev.Name)
                    if entered then
                        notyuri("entered elevator", elev.Name)
                        task.wait(0.3)
                        ApplyElevatorModifiers(elev.Name)
                        SafeInvoke(Remotes.ElevatorStart, elev.Name)
                        Shared.Memo.StartedFor[elev.Name] = true
                    end
                end
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait(1)
    end
end
local function GetSummonCrateByName(crateName)
    for _, crate in ipairs(GetSummonCrates()) do
        if crate.Name == crateName then
            return crate
        end
    end
    return nil
end
local function Func_AutoSummon()
    while Toggles.AutoSummon.Value do
        local ok, err = pcall(function()
            if not Remotes.SummonTowers then return end
            local crateName = Options.SummonCrate and Options.SummonCrate.Value or ""
            if crateName == "" then return end
            local crate = GetSummonCrateByName(crateName)
            if not crate then return end
            local amount = tonumber(Options.SummonAmount and Options.SummonAmount.Value) or 1
            local price = (crate.SummonPrice or 0) * amount
            local data = GetProfileData()
            local money = data and data.Money or 0
            if price > 0 and money < price then
                task.wait(2)
                return
            end
            SafeInvoke(Remotes.SummonTowers, crateName, amount)
        end)
        task.wait()
    end
end
local function SendWebhook(title, description)
    if not request then return end
    if not (Options.WebhookURL and Options.WebhookURL.Value ~= "") then return end
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
local function ReadEndScreenStats()
    local gui = Plr:FindFirstChild("PlayerGui")
    local content = gui and GetObject(gui, "GameUI.FinalUI.Content")
    if not content then return nil end
    local stats = {Result = GetMessage(), Mode = nil, Map = nil, Time = nil, Coins = nil, Waves = nil}
    local modeLabel = content:FindFirstChild("Mode")
    if modeLabel and modeLabel:IsA("TextLabel") then
        stats.Mode = modeLabel.Text:gsub("^Mode:%s*", "")
    end
    local mapLabel = content:FindFirstChild("Map")
    if mapLabel and mapLabel:IsA("TextLabel") then
        stats.Map = mapLabel.Text:gsub("^Map:%s*", "")
    end
    local timeLabel = GetObject(content, "TimeLabel.Title")
    if timeLabel and timeLabel:IsA("TextLabel") then
        stats.Time = timeLabel.Text
    end
    local coinsFrame = GetObject(content, "Stats.FrameCoins_Clone.MainShadow")
    if coinsFrame then
        for _, child in ipairs(coinsFrame:GetChildren()) do
            if child.Name == "Template" and child.Visible ~= false then
                local coinLabel = child:FindFirstChild("CoinAmount")
                if coinLabel and coinLabel:IsA("TextLabel") then
                    local value = tonumber((coinLabel.Text:gsub("[^%d]", "")))
                    if value and (not stats.Coins or value > stats.Coins) then
                        stats.Coins = value
                    end
                end
                local modeText = child:FindFirstChild("Mode")
                if modeText and modeText:IsA("TextLabel") and stats.Waves == nil then
                    local waves = modeText.Text:match("^(%d+) Waves Beaten")
                    if waves then
                        stats.Waves = tonumber(waves)
                    end
                end
            end
        end
    end
    if stats.Waves == nil then
        stats.Waves = math.max(0, GetWave() - 1)
    end
    return stats
end
local function GetMatchEndStatsSettled(timeout)
    task.wait(1)
    local start = tick()
    local last = ReadEndScreenStats()
    while tick() - start < (timeout or 2) do
        task.wait()
        local current = ReadEndScreenStats()
        local changed = false
        if not last or not current then
            changed = last ~= current
        else
            for _, key in ipairs({"Result", "Mode", "Map", "Time", "Coins", "Waves"}) do
                if last[key] ~= current[key] then
                    changed = true
                    break
                end
            end
        end
        last = current
        if not changed then return current end
    end
    return last
end
local function SendMatchEndWebhook(outcome)
    local stats = GetMatchEndStatsSettled(2) or {}
    local lines = {}
    if stats.Mode then
        table.insert(lines, "- Mode: " .. tostring(stats.Mode))
    end
    if stats.Map then
        table.insert(lines, "- Map: " .. tostring(stats.Map))
    end
    if stats.Waves then
        table.insert(lines, "- Waves Beaten: " .. tostring(stats.Waves))
    end
    if stats.Time then
        table.insert(lines, "- Time: " .. tostring(stats.Time))
    end
    if stats.Coins then
        table.insert(lines, "- Coins: +" .. tostring(stats.Coins))
    end
    local desc = string.format(
        "**%s - %s**\n- Player: ||%s||\n%s",
        "Match Finished", outcome, Plr.Name, table.concat(lines, "\n")
    )
    SendWebhook("Match Finished", desc)
    notyuri("Match finished notification sent:", outcome)
end
task.spawn(function()
    while not Library.Unloaded do
        if IsInGame() then
            if not Shared.ListenersInstalled then
                pcall(InstallGameListeners)
            end
            break
        end
        task.wait(1)
    end
end)
do
    local lastEndMsg = nil
    task.spawn(function()
        while not Library.Unloaded do
            local ok, err = pcall(function()
                if not IsInGame() then return end
                local msg = GetMessage()
                if msg == "You Won!" or msg == "You Lost!" then
                    if lastEndMsg ~= msg then
                        lastEndMsg = msg
                        if Toggles.WHMatchEnd and Toggles.WHMatchEnd.Value then
                            task.spawn(SendMatchEndWebhook, msg)
                        end
                    end
                else
                    if msg == nil or msg == "" then
                        lastEndMsg = nil
                    end
                end
            end)
            if not ok then
                notyuri("endwatch error:", tostring(err))
            end
            task.wait(1)
        end
    end)
end
LoadMDir()
LoadPositions()
UpdatePosLabels()
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
        T1 = TB.Main.Left.Autofarm:AddTab("Game"),
        T2 = TB.Main.Left.Autofarm:AddTab("Macro"),
        T3 = TB.Main.Left.Autofarm:AddTab("Lobby"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Config"),
        T2 = TB.Main.Right.Autofarm:AddTab("LobbyConfig"),
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
TB_Tabs.Autofarm.T1:AddToggle("AutoSkip", { Text = "Auto Skip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteMode", { Text = "Auto Vote Mode", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("ModeVote", {
    Text = "Mode Vote",
    Values = Shared.ModeIds,
    Default = "Easy",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoLeave", { Text = "Auto Leave", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlayAgain", { Text = "Auto Play Again", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSpeed", { Text = "Auto Speed", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("GameSpeed", {
    Text = "Game Speed",
    Values = {"1", "1.5", "2"},
    Default = "1",
})
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
    Values = {"Time", "Money"},
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
SafeLabel(TB_Tabs.Autofarm.T2, "Macro", "Idle")
TB_Tabs.Autofarm.T3:AddToggle("AutoJoin", { Text = "Auto Join" })
TB_Tabs.Autofarm.T3:AddToggle("AutoModifiers", { Text = "Auto Modifiers" })
AddMultiDropdown(TB_Tabs.Autofarm2.T2, "ModifiersSel", {
    Text = "Modifiers",
    Values = GetModifierNames(),
})
do
    local mapNames, seen = {}, {}
    for _, model in ipairs(GetElevators()) do
        local map = model:GetAttribute("Map")
        if type(map) == "string" and map ~= "" and not seen[map] then
            seen[map] = true
            table.insert(mapNames, map)
        end
    end
    table.sort(mapNames)
    TB_Tabs.Autofarm2.T2:AddDropdown("JoinMap", {
        Text = "Join Map",
        Values = mapNames,
        Default = mapNames[1] or "",
    })
end
TB_Tabs.Autofarm.T3:AddToggle("AutoSummon", { Text = "Auto Summon" })
do
    local crateNames = {}
    for _, crate in ipairs(GetSummonCrates()) do
        if type(crate.Name) == "string" then
            table.insert(crateNames, crate.Name)
        end
    end
    table.sort(crateNames)
    TB_Tabs.Autofarm2.T2:AddDropdown("SummonCrate", {
        Text = "Summon Crate",
        Values = crateNames,
        Default = crateNames[1] or "",
    })
end
TB_Tabs.Autofarm2.T2:AddDropdown("SummonAmount", {
    Text = "Summon Amount",
    Values = {"1", "10"},
    Default = "1",
})
local APLeft = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
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
local AutoSell_T, AutoSell_S = AddSliderToggle({ Group = APLeft, Id = "AutoSell", Text = "Auto Sell at Wave", Default = 10, Min = 0, Max = 100, Rounding = 0 })
APLeft:AddDivider()
SafeLabel(APLeft, "Positions", "No positions set")
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
            HandleSlotPos("set", slot)
        else
            Library:Notify("Select a slot first", 3)
        end
    end,
})
APLeft:AddButton({ Text = "Save Position for All Slots", Func = function() HandleSlotPos("massset") end })
APLeft:AddDivider()
do
    local function GetResetSlotValues()
        local names = GetSlotDisplayNames()
        table.insert(names, "All Slots")
        return names
    end
    APLeft:AddDropdown("ResetSlotSelect", {
        Text = "Reset Slot Position",
        Values = GetResetSlotValues(),
        Default = "All Slots",
    })
end
APLeft:AddButton({
    Text = "Reset Position",
    Func = function()
        local val = Options.ResetSlotSelect and Options.ResetSlotSelect.Value or "All Slots"
        if val == "All Slots" then
            HandleSlotPos("reset", nil)
        else
            HandleSlotPos("reset", SlotDisplayToNumber(val))
        end
    end,
})
local APRight = Tabs.AutoPlay:AddRightGroupbox("Limits")
APRight:AddLabel("Place Order per Slot", true)
for i = 1, GetHotbarSlots() do
    APRight:AddSlider("PlaceOrder" .. i, {
        Text = "Slot " .. i,
        Default = i,
        Min = 1,
        Max = GetHotbarSlots(),
        Rounding = 0,
        Compact = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Place Wave per Slot", true)
for i = 1, GetHotbarSlots() do
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
for i = 1, GetHotbarSlots() do
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
for i = 1, GetHotbarSlots() do
    APRight:AddSlider("UpgradeLimit" .. i, {
        Text = "Slot " .. i,
        Default = 0,
        Min = 0,
        Max = 30,
        Rounding = 0,
        Compact = true,
    })
end
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
Connections.WaveClock = RunService.Heartbeat:Connect(StepWaveClock)
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
Toggles.AutoSell:OnChanged(function(state)
    AutoSell_S:SetVisible(AutoSell_T.Value)
    Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSell), state)
end)
Toggles.AutoSkip:OnChanged(function(state)
    Thread("AutoSkip", SafeLoop("AutoSkip", Func_AutoSkip), state)
end)
Toggles.AutoVoteMode:OnChanged(function(state)
    Shared.Memo.VoteDone = false
    Thread("AutoVoteMode", SafeLoop("AutoVoteMode", Func_AutoVoteMode), state)
end)
Toggles.AutoLeave:OnChanged(function(state)
    Shared.Memo.LeftForEnd = false
    Thread("AutoLeave", SafeLoop("AutoLeave", Func_AutoLeave), state)
end)
Toggles.AutoPlayAgain:OnChanged(function(state)
    Thread("AutoPlayAgain", SafeLoop("AutoPlayAgain", Func_AutoPlayAgain), state)
end)
Toggles.AutoSpeed:OnChanged(function(state)
    Thread("AutoSpeed", SafeLoop("AutoSpeed", Func_AutoSpeed), state)
end)
Toggles.AutoModifiers:OnChanged(function(state)
    Shared.Memo.ModifiersFor = {}
end)
Toggles.AutoJoin:OnChanged(function(state)
    Shared.Memo.StartedFor = {}
    Shared.Memo.ModifiersFor = {}
    Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), state)
end)
Toggles.AutoSummon:OnChanged(function(state)
    Shared.Memo.SummonPoorNotified = false
    Thread("AutoSummon", SafeLoop("AutoSummon", Func_AutoSummon), state)
end)
Toggles.MacroRecord:OnChanged(function(state)
    Func_MacroRecord(state)
end)
Toggles.LoadMacro:OnChanged(function(state)
    if state then
        if not Shared.MState.Load and Options.MacroSelected and Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
            Shared.MState.Load = LoadMacro(Options.MacroSelected.Value)
            if not Shared.MState.Load then
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
        Shared.MState.Load = LoadMacro(v)
        if not Shared.MState.Load then
            Library:Notify("Failed to load macro: " .. tostring(v), 4)
        end
    end
end)
if Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
    Shared.MState.Load = LoadMacro(Options.MacroSelected.Value)
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
    Shared.MState.Rec = false
    Shared.MState.Rep = false
    Shared.MState.Cur = nil
    Shared.MState.Load = nil
    Shared.MState.Pending = {}
    Shared.MState.Broadcasts = {}
    pcall(PCubeRelease)
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
SaveManager:SetFolder("Yuri/CTD")
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
