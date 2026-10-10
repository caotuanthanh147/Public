repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
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
local Plr = setmetatable({}, {
    __index = function(_, key)
        local lp = Players.LocalPlayer
        if not lp then return nil end
        local val = lp[key]
        if type(val) == "function" then
            return function(_, ...)
                return val(lp, ...)
            end
        end
        return val
    end,
    __newindex = function(_, key, value)
        local lp = Players.LocalPlayer
        if not lp then return end
        lp[key] = value
    end,
})
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
    SelfThreads = {},
    SlopFuncs = {"RequestTower", "SpawnTower", "UpgradeTower", "SellTower", "ChangeTowerMode", "VoteSkip", "ChangeSpeed", "AutoSkip", "GetPlayerPlacement", "GetAbilityCooldown"},
    SlopEvents = {"ActivateAbility", "EndDecision", "ExitGame", "SkipButton", "AbilityCooldownUpdate", "VoteForMap", "VoteForComplication", "VoteForSpecial", "RogueCard", "SlopMutator"},
    LobbyEvents = {"EnterElevator", "LeaveElevator", "ElevatorEntered", "StartElevator", "CreateParty", "ElevatorLeft", "OnTeleported"},
    PosDir = "yuri/STD",
    Labels = {},
    MacroTimings = {
        PendingExpiry = 12,
        PendingLateResolve = 0.6,
        RemoteWait = 8,
        MaxAttempts = 20,
    },
    MState = {
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
    },
    ElevState = {Current = nil, Teleported = false, Started = 0, Setup = false},
    LobbyQuest = {Cache = nil},
    RogueState = {Offer = nil, Handled = nil},
    MutatorState = {Ids = {"None", "BossRush", "Gigantism", "Regeneration", "ArmoredSlop", "Speedrun", "Blackout", "Brainrot", "TinySlop", "GlassBase", "Bankrupt"}},
    Place = {
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
        MapLabelRef = nil,
    },
    Memo = {
        SpeedDone = 0,
        AbilityAt = {},
        SummonFails = 0,
    },
    PlaceCube = {
        PartName = "PCube",
        Pending = Color3.fromRGB(80, 160, 255),
        Success = Color3.fromRGB(80, 255, 120),
        Fail = Color3.fromRGB(255, 80, 80),
    },
    PCubePool = {
        Free = {},
        Active = {},
    },
    MapVoteExcludedKeys = { Quests = true, Rewards = true, Drops = true },
    MapMacroIds = {},
    RaidMaps = { "Raid[Forest]", "Raid 2[Graveyard]", "Raid 3[Hell]", "Raid 4[House]" },
    AbbrevSuffixes = { "k", "M", "B", "T", "Qd", "Qt", "Sx", "Sp", "Oc", "No", "Dc", "UDc", "DDc" },
}
Shared.MDir = Shared.PosDir .. "/Macros"
Shared.PosPath = Shared.PosDir .. "/position.json"
Shared.AbbrevMultiplier = {}
for i, suf in ipairs(Shared.AbbrevSuffixes) do
    Shared.AbbrevMultiplier[suf] = 1000 ^ i
end
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local function AddMultiDropdown(group, id, config)
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
local function SafeLabel(target, id, text)
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
                        notyuri("SafeLabel SetText FAILED:", tostring(key), tostring(err))
                    end
                end
            end
            task.wait()
        end
    end, true)
    return label
end
function AddSliderToggle(Config, ...)
    if type(Config) == "string" then
        return Toggles[Config], Options[Config .. "Value"]
    end
    local Handlers = {...}
    local Toggle, Slider
    Toggle = Config.Group:AddToggle(Config.Id, {
        Text = Config.Text,
        Default = Config.DefaultToggle or false,
        Disabled = Config.Disabled,
        Callback = function(state)
            if Slider then Slider:SetVisible(state) end
            for _, Handler in ipairs(Handlers) do
                Handler(state, Toggle, Slider)
            end
        end,
    })
    Slider = Config.Group:AddSlider(Config.Id .. "Value", {
        Text = Config.Text,
        Default = Config.Default,
        Min = Config.Min,
        Max = Config.Max,
        Rounding = Config.Rounding or 0,
        Compact = true,
        Visible = false
    })
    return Toggles[Config.Id], Options[Config.Id .. "Value"]
end
function MultiToggle(Config)
    local Parent
    local Children = {}
    Parent = Config.Group:AddToggle(Config.Id, {
        Text = Config.Text,
        Default = Config.Default or false,
        Disabled = Config.Disabled,
        Callback = function(Value)
            for _, Child in ipairs(Children) do
                Child.TextLabel.Parent.Visible = Value
                Child:SetVisible(Value)
            end
        end,
    })
    for _, ChildConfig in ipairs(Config.Children) do
        table.insert(Children, Config.Group:AddToggle(ChildConfig.Id, {
            Text = ChildConfig.Text,
            Default = ChildConfig.Default or false,
            Disabled = ChildConfig.Disabled,
            Visible = Parent.Value,
        }))
    end
    return Parent, Children
end
local function SafeConnect(key, getSignalFn, handler)
    local ok, signal = pcall(getSignalFn)
    if not ok or not signal then
        return
    end
    Connections[key] = signal:Connect(handler)
end
local function SafeInvoke(remote, skip, ...)
    local args = {...}
    local result = nil
    task.spawn(function()
        local success, res = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)
        result = res
    end)
    if skip then return end
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
            local ok, err = pcall(function()
                local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if promptOverlay then
                    local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
                    if errorPrompt and errorPrompt.Visible then
                        local secondaryTimer = 5
                        task.wait(secondaryTimer)
                        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                    end
                end
            end)
            if not ok then
                notyuri("AutoReconnect error:", tostring(err))
            end
        end)
    end)
end
local function Func_NoGameplayPaused()
    while Toggles.NoGameplayPaused.Value do
        local ok, err = pcall(function()
            local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            if pauseGui then
                pauseGui:Destroy()
            end
        end)
        if not ok then
            notyuri("NoGameplayPaused error:", tostring(err))
        end
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
        TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, Players.LocalPlayer)
    end)
    if not hopSuccess then
        Library:Notify("Serverhop failed: " .. tostring(hopErr), 5)
    end
end
Support.HookFunction = typeof(hookfunction) == "function"
local function GetInfo()
    return workspace:FindFirstChild("Info")
end
local function IsMatchActive()
    local info = GetInfo()
    if not info then return false end
    local running = info:FindFirstChild("GameRunning")
    return (running and running.Value == true) or false
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
    local min = info:FindFirstChild("Min")
    local sec = info:FindFirstChild("Sec")
    if not (min and sec) then return nil end
    return min.Value * 60 + sec.Value
end
local function GetCash()
    local cash = Plr:FindFirstChild("Cash")
    return cash and cash.Value or 0
end
local function GetTowerLimit()
    local mt = RS:FindFirstChild("maxTowers")
    return (mt and mt.Value) or 10
end
local function GetPlacedCount()
    local pt = Plr:FindFirstChild("PlacedTowers")
    return (pt and pt.Value) or 0
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
local function GetTowerLevel(tower)
    if typeof(tower) ~= "Instance" then return nil end
    local config = tower:FindFirstChild("Config")
    local lvl = config and config:FindFirstChild("LVL")
    return lvl and lvl.Value or 0
end
local function GetTowerID(tower)
    if typeof(tower) ~= "Instance" then return nil end
    local ok, id = pcall(tower.GetAttribute, tower, "ID")
    if ok then return id end
    return nil
end
local function GetTowerModel(name)
    if type(name) ~= "string" then return nil end
    local towers = RS:FindFirstChild("Towers")
    return towers and towers:FindFirstChild(name) or nil
end
local function GetNextUpgrade(name, level)
    if type(name) ~= "string" then return nil end
    local lvls = GetSafeModule(RS, "LVLs")
    if type(lvls) ~= "table" then return nil end
    local chain = lvls[name]
    if type(chain) ~= "table" then return nil end
    return chain[(level or 0) + 1]
end
local function GetPlacementMax(name)
    local modules = RS:FindFirstChild("Modules")
    if not modules then return nil end
    local mod = GetSafeModule(modules, "TowersPlacementsMax")
    if type(mod) ~= "table" then return nil end
    return mod[name]
end
local function GetTowerPrice(name)
    local model = GetTowerModel(name)
    if not model then return nil end
    local config = model:FindFirstChild("Config")
    local price = config and config:FindFirstChild("Price")
    return price and price.Value or nil
end
local function CountOwnedByName(name)
    local count = 0
    for _, tower in ipairs(GetOwnedTowers()) do
        if tower.Name == name then
            count = count + 1
        end
    end
    return count
end
local function GetPlayerDataRaw()
    local remotes = RS:FindFirstChild("Remotes")
    local pd = remotes and remotes:FindFirstChild("PlayerData")
    local getter = pd and pd:FindFirstChild("GetData")
    if not (getter and getter:IsA("RemoteFunction")) then return nil end
    local data = SafeInvoke(getter, false)
    if type(data) == "table" then return data end
    return nil
end
local function GetTowerEntryForName(name, slot)
    local data = GetPlayerDataRaw()
    if not data then return nil, nil end
    local towers = data.Towers
    if type(towers) ~= "table" then return nil, nil end
    if slot ~= nil then
        for k, v in pairs(towers) do
            if type(v) == "table" and v.Name == name and v.Equipped == slot then
                return k, v
            end
        end
    end
    for k, v in pairs(towers) do
        if type(v) == "table" and v.Name == name then
            return k, v
        end
    end
    return nil, nil
end
local function FireBindable(remote, ...)
    if not remote then return false end
    local args = {...}
    local ok, err = pcall(function()
        remote:Fire(unpack(args))
    end)
    if not ok then notyuri("FireBindable error:", tostring(remote), tostring(err)) end
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
    EnsureFolderPath(Shared.MDir)
    local path = Shared.MDir .. "/" .. name .. ".json"
    local out = {}
    for i, entry in ipairs(macro.entries) do
        out[tostring(i)] = entry
    end
    return SaveJSON(path, out)
end
local function SavePositions()
    if not writefile then return false end
    EnsureFolderPath(Shared.PosDir)
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
    table.sort(entries, function(a, b)
        local wa, ea = ParseMacroTime(a)
        local wb, eb = ParseMacroTime(b)
        if wa ~= wb then return wa < wb end
        return ea > eb
    end)
end
local function TowerNearPos(tower, pos, radius)
    local pp = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart")
    if not (pp and pos) then return false end
    return (pp.Position - pos).Magnitude <= (radius or 4)
end
local function EnsureRecKey(inst)
    if typeof(inst) ~= "Instance" then return nil end
    local key = Shared.MState.RecKeys[inst]
    if not key then
        Shared.MState.NextKey = Shared.MState.NextKey + 1
        key = Shared.MState.NextKey
        Shared.MState.RecKeys[inst] = key
        Shared.MState.Adopted[key] = true
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
    RecordAct("Place", {Key = key, Name = pend.Name, CF = pend.CF, ID = pend.ID, Mods = pend.Mods}, pend.Wave, pend.Elapsed)
    if pend.Late then
        notyuri("Place late-confirmed key=" .. tostring(key) .. " (" .. tostring(pend.Name) .. ")")
    end
end
local function ConfirmUpgrade(actType, pend, inst)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = Shared.MState.RecKeys[pend.Tower]
    end
    key = key or EnsureRecKey(inst)
    if not key then
        pend.Dropped = true
        return
    end
    Shared.MState.RecKeys[inst] = key
    if typeof(pend.Tower) == "Instance" then
        Shared.MState.RecKeys[pend.Tower] = key
    end
    pend.Key = key
    local data = {Key = key, Name = pend.Name, CF = pend.CF}
    if actType == "Upgrade" then
        data.LVL = GetTowerLevel(inst)
    else
        data.ID = pend.ID
        data.Mods = pend.Mods
    end
    RecordAct(actType, data, pend.Wave, pend.Elapsed)
    if pend.Late then
        notyuri(actType .. " late-confirmed key=" .. tostring(key) .. " (" .. tostring(pend.Name) .. ")")
    end
end
local function ConfirmSell(pend, late)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = Shared.MState.RecKeys[pend.Tower]
        Shared.MState.RecKeys[pend.Tower] = nil
    end
    if not key and typeof(pend.Tower) == "Instance" then
        key = EnsureRecKey(pend.Tower)
        Shared.MState.RecKeys[pend.Tower] = nil
    end
    pend.Key = key
    local data = {Key = key, Name = pend.Name}
    if pend.CF then data.CF = pend.CF end
    RecordAct("Sell", data, pend.Wave, pend.Elapsed)
    if late then
        notyuri("Sell late-confirmed key=" .. tostring(key))
    end
end
local function ConfirmMode(pend)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = Shared.MState.RecKeys[pend.Tower] or EnsureRecKey(pend.Tower)
        Shared.MState.RecKeys[pend.Tower] = key
    end
    pend.Key = key
    RecordAct("Mode", {Key = key, Name = pend.Name, CF = pend.CF}, pend.Wave, pend.Elapsed)
end
local function RecordMode(tower)
    if not (Shared.MState.Rec and Shared.MState.Cur) then return end
    if typeof(tower) ~= "Instance" then return end
    local pend = {Tower = tower, Name = tower.Name}
    local pp = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart")
    if pp then
        pend.CF = {pp.CFrame:GetComponents()}
    end
    pend.Wave = GetWave()
    pend.Elapsed = GetRemainingTime()
    ConfirmMode(pend)
end
local function SnapshotCall(self, nargs)
    if not (Shared.MState.Rec and Shared.MState.Cur) then return nil end
    local wave = GetWave()
    local elapsed = GetRemainingTime()
    local pend
    if rawequal(self, Remotes.SpawnTower) then
        local name = nargs[2]
        local cf = nargs[3]
        local third = nargs[4]
        if type(name) ~= "string" or typeof(cf) ~= "CFrame" then return nil end
        local comps = {cf:GetComponents()}
        pend = {
            Kind = (typeof(third) == "Instance") and "SpawnUpgrade" or "Place",
            Name = name,
            ID = nargs[5],
            Mods = (type(nargs[6]) == "table") and nargs[6] or {},
            Tower = (typeof(third) == "Instance") and third or nil,
            CF = comps,
            Position = Vector3.new(comps[1], comps[2], comps[3]),
        }
    elseif rawequal(self, Remotes.UpgradeTower) then
        local tower = nargs[2]
        if typeof(tower) ~= "Instance" then return nil end
        pend = {Kind = "Upgrade", Tower = tower, Name = tower.Name, ID = nargs[3]}
        local pp = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart")
        if pp then
            pend.Position = pp.Position
            local comps = {pp.CFrame:GetComponents()}
            pend.CF = comps
        end
    elseif rawequal(self, Remotes.SellTower) or rawequal(self, Remotes.ChangeTowerMode) then
        local tower = nargs[2]
        if typeof(tower) ~= "Instance" then return nil end
        pend = {
            Kind = rawequal(self, Remotes.SellTower) and "Sell" or "Mode",
            Tower = tower,
            Name = tower.Name,
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
    table.insert(Shared.MState.Pending, pend)
    notyuri("", pend.Kind, "captured", tostring(pend.Name), "wave", tostring(wave), string.format("%.2fs", elapsed))
    return pend
end
local function ResolveCall(pend, ret)
    if not (pend and not pend.Resolved) then return end
    local result = (ret and ret.n and ret.n > 0) and ret[1] or nil
    if pend.Kind == "Place" then
        if typeof(result) == "Instance" then
            ConfirmPlace(pend, result)
        end
    elseif pend.Kind == "SpawnUpgrade" then
        if typeof(result) == "Instance" then
            ConfirmUpgrade("SpawnUpgrade", pend, result)
        end
    elseif pend.Kind == "Upgrade" then
        if typeof(result) == "Instance" then
            ConfirmUpgrade("Upgrade", pend, result)
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
        if not Shared.MState.RecKeys[tower] and predFn(tower) then
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
                notyuri("", pend.Kind, "expired unresolved:", tostring(pend.Name))
            elseif age > Shared.MacroTimings.PendingLateResolve then
                if pend.Kind == "Place" then
                    local inst = FindUnkeyedOwnedTower(function(t)
                        return t.Name == pend.Name and TowerNearPos(t, pend.Position, 4)
                    end)
                    if inst then
                        pend.Late = true
                        ConfirmPlace(pend, inst)
                    end
                elseif pend.Kind == "SpawnUpgrade" or pend.Kind == "Upgrade" then
                    local inst = FindUnkeyedOwnedTower(function(t)
                        return t.Name == pend.Name and TowerNearPos(t, pend.Position, 4)
                    end)
                    if inst then
                        pend.Late = true
                        if pend.Kind == "Upgrade" then
                            ConfirmUpgrade("Upgrade", pend, inst)
                        else
                            ConfirmUpgrade("SpawnUpgrade", pend, inst)
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
    for _, pend in ipairs(Shared.MState.Pending) do
        if not pend.Resolved then
            table.insert(kept, pend)
        end
    end
    Shared.MState.Pending = kept
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
local function InstallMacroHook()
    if Shared.MState.Hooked then return end
    if not Support.HookMeta then
        Library:Notify("Macro record requires hookmetamethod support", 4)
        return
    end
    Shared.MState.Hooked = true
    local cc = (typeof(newcclosure) == "function") and newcclosure or (function(f) return f end)
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", cc(function(...)
        local self = ...
        local method = getnamecallmethod()
        local ret = table.pack(originalNamecall(...))
        if method == "InvokeServer" and Shared.MState.Rec and not Shared.SelfThreads[coroutine.running() or false] then
            local isSpawn = rawequal(self, Remotes.SpawnTower)
            local isUpgrade = rawequal(self, Remotes.UpgradeTower)
            local isSell = rawequal(self, Remotes.SellTower)
            local isMode = rawequal(self, Remotes.ChangeTowerMode)
            if isSpawn or isUpgrade or isSell or isMode then
                local nargs = table.pack(...)
                local ok, snap = pcall(SnapshotCall, self, nargs)
                if ok and snap then
                    local ok2, err = pcall(ResolveCall, snap, ret)
                    if not ok2 then
                        notyuri("resolve error:", tostring(err))
                    end
                end
            end
        end
        return table.unpack(ret, 1, ret.n)
    end))
    notyuri("__namecall hook installed (captures place/upgrade/sell/mode via dot-call InvokeServer)")
end
local function Func_MacroRecord(state)
    if not state then return end
    if Toggles.LoadMacro and Toggles.LoadMacro.Value then
        Toggles.LoadMacro:SetValue(false)
    end
    if Toggles.PlayRaidMacro and Toggles.PlayRaidMacro.Value then
        Toggles.PlayRaidMacro:SetValue(false)
    end
    InstallMacroHook()
    Shared.MState.Cur = {entries = {}}
    Shared.MState.Step = 0
    Shared.MState.NextKey = 0
    Shared.MState.RecKeys = {}
    Shared.MState.Saved = false
    Shared.MState.Pending = {}
    Shared.MState.Adopted = {}
    UpdateMacroLabel("Waiting")
    notyuri("waiting for match to start")
    while Toggles.MacroRecord.Value and not IsMatchActive() do
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
    while Toggles.MacroRecord.Value and IsMatchActive() do
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
                for _, id in ipairs(Shared.MapMacroIds) do
                    if Options[id] then
                        Options[id]:SetValues(ListMacros())
                    end
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
        return GetTowerPrice(entry.Name)
    elseif entry.Type == "Upgrade" then
        local lvls = GetSafeModule(RS, "LVLs")
        if type(lvls) == "table" and type(lvls[entry.Name]) == "table" and type(entry.LVL) == "number" then
            local cfg = lvls[entry.Name][entry.LVL]
            if type(cfg) == "table" then return cfg.Price end
        end
        return nil
    end
    return nil
end
local function GetCurrentMapName()
    local mapRoot = workspace:FindFirstChild("Map")
    local folder = mapRoot and mapRoot:FindFirstChildOfClass("Folder")
    return folder and folder.Name or nil
end
local function WaitForCash(amount, timeout)
    if not amount or amount <= 0 then return true end
    if GetCash() >= amount then return true end
    local start = tick()
    local startMap = GetCurrentMapName()
    while (Toggles.LoadMacro.Value or Toggles.PlayRaidMacro.Value) and GetCash() < amount do
        if timeout and (tick() - start) >= timeout then
            break
        end
        if GetCurrentMapName() ~= startMap then
            break
        end
        task.wait()
    end
    return (Toggles.LoadMacro.Value or Toggles.PlayRaidMacro.Value) and GetCash() >= amount
end
local function FindTowerForEntry(entry)
    local t = entry.Key and Shared.MState.RepMap[entry.Key]
    if t and t.Parent and (t.PrimaryPart or t:FindFirstChild("HumanoidRootPart")) then
        return t
    end
    local cf = entry.CF
    if type(cf) ~= "table" or #cf ~= 12 then return nil end
    local pos = Vector3.new(cf[1], cf[2], cf[3])
    local base = entry.Name
    if type(base) ~= "string" or base == "" then return nil end
    local best, bestDist = nil, 5
    for _, tower in ipairs(GetOwnedTowers()) do
        local pp = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart")
        if pp and tower.Name == base then
            local dist = (pp.Position - pos).Magnitude
            if dist < bestDist then
                best, bestDist = tower, dist
            end
        end
    end
    if best then
        notyuri("position fallback resolved key", tostring(entry.Key), "->", tostring(best.Name), string.format("(%.1f studs)", bestDist))
        if entry.Key then
            Shared.MState.RepMap[entry.Key] = best
        end
    end
    return best
end
local function ResolveTowerRetry(entry)
    local tower = FindTowerForEntry(entry)
    if tower and tower.Parent then return tower end
    local start = tick()
    while (Toggles.LoadMacro.Value or Toggles.PlayRaidMacro.Value) and (tick() - start) < 1 do
        task.wait()
        tower = FindTowerForEntry(entry)
        if tower and tower.Parent then return tower end
    end
    return nil
end
local function ResolvePlaceID(entry)
    if entry.ID ~= nil then
        return entry.ID, (type(entry.Mods) == "table" and entry.Mods) or {}
    end
    local k, entryData = GetTowerEntryForName(entry.Name)
    if k ~= nil then
        return k, (entryData and type(entryData.Modifiers) == "table" and entryData.Modifiers) or {}
    end
    return nil, {}
end
local function ApplyUpgradedTower(entry, result)
    if entry.Key then
        Shared.MState.RepMap[entry.Key] = result
    end
    task.wait()
    FireBindable(Remotes.toggleClient, result)
end
local function DoMacroAction(entry)
    if entry.Type == "Place" then
        local cf = entry.CF
        if type(cf) ~= "table" or #cf ~= 12 then return end
        local id, mods = ResolvePlaceID(entry)
        if id == nil then
            notyuri("Place SKIP: no tower entry for", tostring(entry.Name))
            return
        end
        local result
        for batch = 1, 3 do
            if not (Toggles.LoadMacro.Value or Toggles.PlayRaidMacro.Value) then break end
            for attempt = 1, Shared.MacroTimings.MaxAttempts do
                if not (Toggles.LoadMacro.Value or Toggles.PlayRaidMacro.Value) then break end
                result = SafeInvoke(Remotes.SpawnTower, false, entry.Name, CFrame.new(unpack(cf)), false, id, mods)
                if typeof(result) == "Instance" then break end
            end
            if typeof(result) == "Instance" then break end
            local existing = FindTowerForEntry(entry)
            if existing then
                result = existing
                notyuri("Place retry not needed: tower already at position", tostring(entry.Name))
                break
            end
            if batch < 3 then
                local cost = GetMacroEntryCost(entry)
                notyuri("Place rejected, waiting for cash, batch", batch, "of 3")
                if not WaitForCash(cost, 5) then break end
            end
        end
        if typeof(result) == "Instance" then
            if entry.Key then
                Shared.MState.RepMap[entry.Key] = result
            end
        elseif not (entry.Key and Shared.MState.RepMap[entry.Key]) then
            notyuri("Place SKIP: server rejected after 20 attempts", tostring(entry.Name))
        end
    elseif entry.Type == "Upgrade" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then
            notyuri("Upgrade SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        if type(entry.LVL) == "number" then
            local curLvl = GetTowerLevel(tower)
            if curLvl and curLvl >= entry.LVL then
                notyuri("Upgrade skip: already at level", tostring(curLvl))
                return
            end
        end
        local cost = GetMacroEntryCost(entry)
        local result
        for attempt = 1, Shared.MacroTimings.MaxAttempts do
            if not (Toggles.LoadMacro.Value or Toggles.PlayRaidMacro.Value) then break end
            result = SafeInvoke(Remotes.UpgradeTower, false, tower, GetTowerID(tower))
            if typeof(result) == "Instance" then break end
            if attempt < Shared.MacroTimings.MaxAttempts then
                notyuri("Upgrade rejected for key", tostring(entry.Key), "waiting for cash, attempt", attempt, "of 20")
                if not WaitForCash(cost, 5) then break end
            end
        end
        if typeof(result) == "Instance" then
            ApplyUpgradedTower(entry, result)
        else
            notyuri("Upgrade SKIP: server rejected for key after 20 attempts", tostring(entry.Key))
        end
    elseif entry.Type == "SpawnUpgrade" then
        local tower = ResolveTowerRetry(entry)
        local cf = entry.CF
        if type(cf) ~= "table" or #cf ~= 12 then return end
        if not (tower and tower.Parent) then
            notyuri("SpawnUpgrade SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        local id, mods = ResolvePlaceID(entry)
        local result = SafeInvoke(Remotes.SpawnTower, false, entry.Name, CFrame.new(unpack(cf)), tower, id, mods)
        if typeof(result) == "Instance" then
            ApplyUpgradedTower(entry, result)
        else
            notyuri("SpawnUpgrade SKIP: server rejected for key", tostring(entry.Key))
        end
    elseif entry.Type == "Sell" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then
            notyuri("Sell SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        local ok = SafeInvoke(Remotes.SellTower, false, tower)
        if ok then
            if entry.Key then
                Shared.MState.RepMap[entry.Key] = nil
            end
            FireBindable(Remotes.toggleClient)
        end
    elseif entry.Type == "Mode" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then
            notyuri("Mode SKIP: no tower resolved for key", tostring(entry.Key))
            return
        end
        SafeInvoke(Remotes.ChangeTowerMode, true, tower)
    end
end
local function Func_MacroReplay(raid)
    local toggle = raid and Toggles.PlayRaidMacro or Toggles.LoadMacro
    while toggle.Value do
        local macro = Shared.MState.Load
        if not raid and (not macro or not macro.entries or #macro.entries == 0) then
            toggle:SetValue(false)
            Library:Notify("No macro loaded", 3)
            return
        end
        Shared.MState.Rep = true
        Shared.MState.Step = 0
        Shared.MState.RepMap = {}
        if not raid then
            Shared.MState.Total = #macro.entries
            SortMacroEntries(macro.entries)
        end
        UpdateMacroLabel()
        while toggle.Value and not IsMatchActive() do
            task.wait()
        end
        if not toggle.Value then break end
        local startMap = GetCurrentMapName()
        if raid then
            local opt = Options["MacroMap_" .. tostring(GetCurrentMapName())]
            local name = opt and opt.Value
            macro = (type(name) == "string" and name ~= "") and LoadMacro(name) or {entries = {}}
            Shared.MState.Total = #macro.entries
            SortMacroEntries(macro.entries)
            UpdateMacroLabel()
        end
        for i, entry in ipairs(macro.entries) do
            if not toggle.Value then break end
            if not IsMatchActive() then
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
                        notyuri("money wait aborted (toggle off or map changed)")
                    end
                end
                if toggle.Value and GetCurrentMapName() ~= startMap then
                    notyuri("map changed during money wait, aborting pass")
                    break
                end
            else
                local tWave, tElapsed = ParseMacroTime(entry)
                while toggle.Value and GetWave() < tWave do
                    if not IsMatchActive() then break end
                    task.wait()
                end
                if not toggle.Value then break end
                if GetWave() > tWave + 100 then
                    skipStep = true
                else
                    local diff = GetRemainingTime() - tElapsed
                    if diff > 0 then
                        while toggle.Value and IsMatchActive() and GetRemainingTime() > tElapsed do
                            task.wait()
                        end
                    end
                end
            end
            if not toggle.Value then break end
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
        if toggle.Value then
            UpdateMacroLabel("Waiting")
            while toggle.Value and IsMatchActive() and GetCurrentMapName() == startMap do
                task.wait()
            end
            while toggle.Value and not IsMatchActive() do
                task.wait()
            end
        end
    end
    Shared.MState.Rep = false
    UpdateMacroLabel()
end
local function GetTowerAreaParts()
    local folder = GetObject(workspace, "Map.Base.TowerArea")
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
local function GetModelPlacementOffsets(model)
    local hip = 0
    local legY = 2
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid then hip = humanoid.HipHeight end
    local hrp = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
    if hrp then legY = hrp.Size.Y / 2 end
    return hip, legY
end
local function TryCandidateSpot(part, x, z, towersFolder, hip, legY, rot)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = {part}
    local origin = Vector3.new(x, part.Position.Y + 60, z)
    local result = workspace:Raycast(origin, Vector3.new(0, -200, 0), params)
    if not result then return nil end
    if towersFolder then
        for _, tower in ipairs(towersFolder:GetChildren()) do
            local pp = tower.PrimaryPart or tower:FindFirstChild("HumanoidRootPart")
            if pp then
                local dx = pp.Position.X - x
                local dz = pp.Position.Z - z
                if (dx * dx + dz * dz) < 9 then
                    return nil
                end
            end
        end
    end
    local y = result.Position.Y + hip + legY
    return CFrame.new(x, y, z) * CFrame.Angles(0, math.rad(rot), 0)
end
local function GetSpotForTower(model)
    local spacing = 1.5
    local key = tostring(spacing)
    local cache = Shared.Place.GridCache
    local alive = cache and cache[1] and cache[1].Part and cache[1].Part.Parent ~= nil
    if Shared.Place.GridKey ~= key or not alive then
        local parts = GetTowerAreaParts()
        if not parts then return nil end
        local s = math.clamp(spacing, 3, 12)
        local grid = {}
        for _, part in ipairs(parts) do
            local halfX, halfZ = part.Size.X / 2, part.Size.Z / 2
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
        Shared.Place.GridCache = grid
        Shared.Place.GridKey = key
        cache = grid
    end
    if not cache then return nil end
    local now = tick()
    for pos, expiry in pairs(Shared.Place.FailPos) do
        if expiry < now then
            Shared.Place.FailPos[pos] = nil
        end
    end
    local hip, legY = GetModelPlacementOffsets(model)
    local rot = (Options.PlaceRotation and Options.PlaceRotation.Value) or 0
    local towersFolder = GetTowersFolder()
    for _, spot in ipairs(cache) do
        local posKey = string.format("%.1f,%.1f", spot.X, spot.Z)
        if not Shared.Place.FailPos[posKey] then
            local cf = TryCandidateSpot(spot.Part, spot.X, spot.Z, towersFolder, hip, legY, rot)
            if cf then
                return cf, posKey
            end
        end
    end
    return nil
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
local function SpiralNext(spacing)
    local center = Shared.Place.SpiralCenter
    if not center then
        local parts = GetTowerAreaParts()
        if not parts or not parts[1] then return nil end
        center = parts[1].Position
        Shared.Place.SpiralCenter = center
    end
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
local function GetSpotForTowerSpiral(model)
    if not Shared.Place.Spiral then
        Shared.Place.SpiralCursor = 0
        Shared.Place.SpiralCenter = nil
        Shared.Place.Spiral = {x = 0, z = 0, dx = 1, dz = 0, segLen = 1, stepped = 0, turns = 0}
        Shared.Place.SpiralFailMemo = {}
    end
    local towersFolder = GetTowersFolder()
    local hip, legY = GetModelPlacementOffsets(model)
    local rot = (Options.PlaceRotation and Options.PlaceRotation.Value) or 0
    local spacing = 1.5
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
            local cf = TryCandidateSpot(part, candidate.X, candidate.Z, towersFolder, hip, legY, rot)
            if cf then
                return cf
            end
            Shared.Place.SpiralFailMemo[key] = tick()
        end
    end
    return nil
end
local function GetSlotByTowerName()
    local data = GetPlayerDataRaw()
    local map = {}
    if not data or type(data.Towers) ~= "table" then return map end
    for _, v in pairs(data.Towers) do
        if type(v) == "table" and type(v.Name) == "string" and type(v.Equipped) == "number" then
            map[v.Name] = v.Equipped
        end
    end
    return map
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
local function UpdatePosLabels()
    local mapName = GetCurrentMapName()
    local text = "No positions set"
    if mapName and Shared.Place.SlotPositions[mapName] then
        local slotMap = GetSlotByTowerName()
        local lines = {}
        for slot, cfs in pairs(Shared.Place.SlotPositions[mapName]) do
            local unitName
            for name, s in pairs(slotMap) do
                if s == slot then unitName = name break end
            end
            table.insert(lines, "Slot " .. slot .. (unitName and (" (" .. unitName .. ")") or "") .. ": " .. #cfs .. " pos")
        end
        if #lines > 0 then
            table.sort(lines)
            text = table.concat(lines, "\n")
        end
    end
    SafeLabel("Positions", text)
end
local function HandleSlotPos(act, slot)
    local mapName = GetCurrentMapName()
    if not mapName then
        return
    end
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
        for i = 1, 6 do
            if not Shared.Place.SlotPositions[mapName][i] then Shared.Place.SlotPositions[mapName][i] = {} end
            table.insert(Shared.Place.SlotPositions[mapName][i], cf)
        end
        notyuri("MassSetPos map=" .. mapName)
    end
    SavePositions()
    UpdatePosLabels()
end
local function GetSelectedTowerSlots()
    local slotByName = GetSlotByTowerName()
    local list = {}
    for name, slot in pairs(slotByName) do
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
    local price = GetTowerPrice(name)
    if price and GetCash() < price then return false, nil end
    local pause = Shared.Place.PauseUntil[name] or 0
    if tick() < pause then return false, nil end
    if slot then
        local placeWave = GetSlotOption("PlaceWave", slot, 0)
        if placeWave > 0 and GetWave() < placeWave then return false, nil end
        local slotLimit = GetSlotOption("PlaceLimit", slot, 0)
        if slotLimit > 0 and CountOwnedByName(name) >= slotLimit then return false, nil end
    end
    local maxCount = GetPlacementMax(name)
    if maxCount and CountOwnedByName(name) >= maxCount then return false, nil end
    local id, entryData = GetTowerEntryForName(name, slot)
    if id == nil then return false, nil end
    local mapName = GetCurrentMapName()
    local savedList = slot and mapName and Shared.Place.SlotPositions[mapName] and Shared.Place.SlotPositions[mapName][slot]
    local cf, posKey, fromSaved
    if savedList and #savedList > 0 then
        cf = savedList[math.random(1, #savedList)]
        fromSaved = true
    else
        cf, posKey = GetSpotForTower(model)
        if not cf then
            cf = GetSpotForTowerSpiral(model)
        end
    end
    if not cf then return false, nil end
    local ghost = PCubeAcq()
    ghost.CFrame = cf
    local mods = (entryData and type(entryData.Modifiers) == "table" and entryData.Modifiers) or {}
    local result = SafeInvoke(Remotes.SpawnTower, false, name, cf, false, id, mods)
    if typeof(result) == "Instance" then
        ghost.Color = Shared.PlaceCube.Success
        Shared.Place.TypeFails[name] = 0
        PCubeRelease(ghost)
        return true, result
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
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local ok, err = pcall(function()
            if not (Remotes.SpawnTower and IsMatchActive()) then return end
            if GetPlacedCount() >= GetTowerLimit() then return end
            for _, entry in ipairs(GetSelectedTowerSlots()) do
                if not (Toggles.AutoPlace.Value and GetPlacedCount() < GetTowerLimit()) then return end
                local placed, tower = TryPlaceTower(entry.name, entry.slot)
                if placed then
                    notyuri("Placed", entry.name, "slot", tostring(entry.slot))
                    if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value and tower then
                        local upgLimit = entry.slot and GetSlotOption("UpgradeLimit", entry.slot, 0) or 0
                        for _ = 1, 20 do
                            if not Toggles.PlaceAndUpgrade.Value then break end
                            if upgLimit > 0 and (GetTowerLevel(tower) or 0) >= upgLimit then break end
                            local reserve = (Options.UpgradeReserve and Options.UpgradeReserve.Value) or 0
                            local nextUp = GetNextUpgrade(tower.Name, GetTowerLevel(tower) or 0)
                            if not (nextUp and nextUp.Price and (GetCash() - reserve) >= nextUp.Price) then break end
                            local result = SafeInvoke(Remotes.UpgradeTower, false, tower, GetTowerID(tower))
                            if typeof(result) == "Instance" then
                                task.wait()
                                FireBindable(Remotes.toggleClient, result)
                                tower = result
                            else
                                break
                            end
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
        local slot = slotByName[tower.Name]
        local upgLimit = slot and GetSlotOption("UpgradeLimit", slot, 0) or 0
        local level = GetTowerLevel(tower) or 0
        if upgLimit <= 0 or level < upgLimit then
            local nextUp = GetNextUpgrade(tower.Name, level)
            if nextUp and nextUp.Price then
                table.insert(result, {
                    model = tower,
                    slot = slot,
                    level = level,
                    towerName = tower.Name,
                    price = nextUp.Price,
                })
            end
        end
    end
    return result
end
local function UpgradeTarget(units)
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
            if not (Remotes.UpgradeTower and IsMatchActive()) then return end
            local reserve = (Options.UpgradeReserve and Options.UpgradeReserve.Value) or 0
            local units = GetUpgradableTowers()
            local target = UpgradeTarget(units)
            if not target then return end
            if (GetCash() - reserve) < target.price then return end
            local tower = target.model
            local result = SafeInvoke(Remotes.UpgradeTower, false, tower, GetTowerID(tower))
            if typeof(result) == "Instance" then
                task.wait()
                FireBindable(Remotes.toggleClient, result)
                notyuri("Upgraded", target.towerName, "slot", tostring(target.slot))
            end
        end)
        if not ok then
            notyuri("error:", tostring(err))
        end
        task.wait()
    end
end
local function Func_AutoAbility()
    while Toggles.AutoAbility.Value do
        if Remotes.ActivateAbility and IsMatchActive() then
            for _, tower in ipairs(GetOwnedTowers()) do
                if Toggles.AutoAbility.Value then
                    local config = tower:FindFirstChild("Config")
                    local ability = config and config:FindFirstChild("Ability")
                    if ability and ability.Value ~= "" then
                        local last = Shared.Memo.AbilityAt[tower] or 0
                        if tick() - last > 3 then
                            local r1 = SafeInvoke(Remotes.GetAbilityCooldown, false, tower)
                            if r1 == nil or r1 == true then
                                FireRemote(Remotes.ActivateAbility, tower)
                                Shared.Memo.AbilityAt[tower] = tick()
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function IsModifierVotingVisible()
    local gui = Plr:FindFirstChild("PlayerGui")
    local gameGui = gui and gui:FindFirstChild("GameGui")
    local voting = gameGui and gameGui:FindFirstChild("Voting")
    local modifier = voting and voting:FindFirstChild("ModifierVoting")
    return modifier ~= nil and modifier.Visible == true
end
local function OnSkipVoteEvent(p1, p2)
    if not (Toggles.AutoSkip and Toggles.AutoSkip.Value) then return end
    if not p1 or p2 then return end
    if IsModifierVotingVisible() then return end
    if not Remotes.VoteSkip then return end
    SafeInvoke(Remotes.VoteSkip, true)
    notyuri("vote fired")
end
local function Func_AutoSpeed()
    while Toggles.AutoSpeed.Value do
        local ok, err = pcall(function()
            if not Remotes.ChangeSpeed then return end
            local n = tonumber(Options.SpeedTarget and Options.SpeedTarget.Value) or 2
            local info = GetInfo()
            local cur = info and info:FindFirstChild("SpeedGame")
            if cur and cur.Value >= n then return end
            SafeInvoke(Remotes.ChangeSpeed, false, n)
        end)
        if not ok then
            notyuri("AutoSpeed error:", tostring(err))
        end
        task.wait(2)
    end
end
local function Func_AutoVote(toggle, votingFlagName, remote, option, errLabel)
    while toggle.Value do
        local ok, err = pcall(function()
            local info = GetInfo()
            if not info then return end
            local voting = info:FindFirstChild(votingFlagName)
            local votingOpen = voting and voting.Value == true
            if votingOpen and remote and option and option.Value ~= "" then
                FireRemote(remote, option.Value)
            end
        end)
        if not ok then
            notyuri(errLabel .. " error:", tostring(err))
        end
        task.wait(0.5)
    end
end
local function Func_AutoVoteMutator()
    local Rejoined = false
    local lastCards = {}
    local lastSig = nil
    while Toggles.AutoVoteMutator.Value do
        local ok, err = pcall(function()
            local gui = Plr:FindFirstChild("PlayerGui")
            local voting = gui and GetObject(gui, "SlopMutatorGui.MutatorVoting")
            if voting and voting.Visible and Remotes.SlopMutator then
                local available = {}
                local names = {}
                local currentCards = {}
                local newVote = false
                for _, card in ipairs(voting:GetChildren()) do
                    if card:IsA("GuiButton") then
                        available[card.Name] = true
                        table.insert(names, card.Name)
                        currentCards[card] = true
                        if not lastCards[card] then newVote = true end
                    end
                end
                lastCards = currentCards
                if newVote then Rejoined = false end
                table.sort(names)
                local tiers = {}
                for i = 1, 3 do
                    tiers[i] = AddMultiDropdown("MutatorPriority" .. i)
                end
                local wanted = nil
                local Rejoin = false
                local RejoinTier = nil
                for i, tier in ipairs(tiers) do
                    local anySelected = false
                    for _, id in ipairs(Shared.MutatorState.Ids) do
                        if tier[id] then
                            anySelected = true
                            if available[id] then
                                wanted = id
                                break
                            end
                        end
                    end
                    if wanted then break end
                    if anySelected and Toggles["AutoRejoinMutator" .. i].Value then
                        Rejoin = true
                        RejoinTier = i
                        break
                    end
                end
                local sig = table.concat(names, ",") .. "|" .. tostring(wanted) .. "|" .. tostring(RejoinTier) .. "|" .. tostring(Remotes.LeaveVote ~= nil)
                if sig ~= lastSig then
                    lastSig = sig
                    notyuri("AutoVoteMutator", "cards", table.concat(names, ","), "wanted", tostring(wanted), "rejoinTier", tostring(RejoinTier), "hasLeaveVote", tostring(Remotes.LeaveVote ~= nil), "toggles", tostring(Toggles.AutoRejoinMutator1.Value), tostring(Toggles.AutoRejoinMutator2.Value), tostring(Toggles.AutoRejoinMutator3.Value))
                end
                if Rejoin and Remotes.LeaveVote then
                    if not Rejoined then
                        Rejoined = true
                        Remotes.LeaveVote:FireServer()
                        notyuri("AutoVoteMutator", "no match for priority", RejoinTier, "Rejoin sent")
                    end
                    return
                end
                if not wanted and available["None"] then
                    wanted = "None"
                end
                if wanted then
                    FireRemote(Remotes.SlopMutator, "Vote", wanted)
                end
            else
                Rejoined = false
            end
        end)
        if not ok then
            notyuri("AutoVoteMutator error:", tostring(err))
        end
        task.wait(0.5)
    end
end
local function Func_AutoPickCards()
    while Toggles.AutoPickCards.Value do
        local ok, err = pcall(function()
            local offer = Shared.RogueState.Offer
            if not offer or Shared.RogueState.Handled == offer or not Remotes.RogueCard then return end
            local modules = RS:FindFirstChild("Modules")
            local rogueConfig = modules and GetSafeModule(modules, "RogueConfig")
            if not rogueConfig or type(offer.Cards) ~= "table" then return end
            local specialsConfig = modules and GetSafeModule(modules, "SpecialsConfig")
            local wantedIndex = nil
            for i = 1, 3 do
                local tier = AddMultiDropdown("RogueCardPriority" .. i)
                for index, card in ipairs(offer.Cards) do
                    for label in pairs(tier) do
                        local id = label:match("^%[%a+%]%s*(.+)$") or label
                        local data = rogueConfig.BY_ID[id] or (specialsConfig and specialsConfig.PACT_BY_ID[id])
                        if data and data.Title == card.Title then
                            wantedIndex = index
                            break
                        end
                    end
                    if wantedIndex then break end
                end
                if wantedIndex then break end
            end
            Shared.RogueState.Handled = offer
            if wantedIndex then
                FireRemote(Remotes.RogueCard, "Pick", offer.Id, wantedIndex)
                notyuri("AutoPickCards", "picked", tostring(offer.Cards[wantedIndex].Title))
            elseif (offer.Rerolls or 0) > 0 then
                FireRemote(Remotes.RogueCard, "Reroll", offer.Id)
                notyuri("AutoPickCards", "Reroll", tostring(offer.Rerolls))
            end
        end)
        if not ok then
            notyuri("AutoPickCards error:", tostring(err))
        end
        task.wait()
    end
end
local function Func_EndScreenVote(toggle, votePayload, logMsg)
    while toggle.Value do
        local gui = Plr:FindFirstChild("PlayerGui")
        local endScreen = gui and GetObject(gui, "GameGui.EndScreen")
        if endScreen and endScreen.Visible and Remotes.EndDecision then
            FireRemote(Remotes.EndDecision, votePayload)
            notyuri(logMsg)
        end
        task.wait()
    end
end
local function PickElevator(wantRaid)
    local folder = workspace:FindFirstChild("Elevators")
    if not folder then return nil end
    for _, elev in ipairs(folder:GetChildren()) do
        local players = elev:GetAttribute("Players")
        local raid = elev:GetAttribute("IsRaid")
        if wantRaid then
            if players == 0 and raid ~= nil then
                return elev
            end
        else
            if players == 0 and raid == nil then
                return elev
            end
        end
    end
    return nil
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        local folder = workspace:FindFirstChild("Elevators")
        if folder then
            local elev = PickElevator(false)
            if elev then
                TPTo(elev)
                local name = elev.Name
                if Remotes.EnterElevator then
                    FireRemote(Remotes.EnterElevator, name)
                end
                if Remotes.CreateParty then
                    FireRemote(Remotes.CreateParty, name, 1, false)
                end
                if Remotes.StartElevator then
                    FireRemote(Remotes.StartElevator, name)
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoReady()
    while Toggles.AutoReady.Value do
        local info = GetInfo()
        local active = info and info:FindFirstChild("RaidReadyActive")
        if active and active.Value and Remotes.RaidReadyEvent then
            local delay = Options.AutoReadyValue.Value
            local start = tick()
            while Toggles.AutoReady.Value and (tick() - start) < delay do
                task.wait()
            end
            if Toggles.AutoReady.Value and active.Value then
                FireRemote(Remotes.RaidReadyEvent)
                notyuri("AutoReady", "ready sent", "delay", tostring(delay))
            end
        end
        task.wait()
    end
end
local function IsFarmTower(tower)
    if typeof(tower) ~= "Instance" then return false end
    local modules = RS:FindFirstChild("Modules")
    local towersConfig = modules and GetSafeModule(modules, "TowersConfig")
    if type(towersConfig) ~= "table" then return false end
    local cfg = towersConfig[tower.Name]
    local typeStr = type(cfg) == "table" and cfg.Type
    return type(typeStr) == "string" and string.find(typeStr, "Farm") ~= nil
end
local function Func_AutoAtWave(toggle, thresholdOption, action, farmOnly)
    while toggle.Value do
        local threshold = tonumber(thresholdOption and thresholdOption.Value) or 0
        local wave = GetWave()
        if wave >= threshold then
            if action == "sell" then
                for _, tower in ipairs(GetOwnedTowers()) do
                    if tower and tower.Parent and (not farmOnly or IsFarmTower(tower)) then
                        SafeInvoke(Remotes.SellTower, true, tower)
                    end
                end
            elseif action == "leave" then
                if Remotes.LeaveVote then
                    Remotes.LeaveVote:FireServer()
                    notyuri("AutoLeave", "leave vote sent", "wave", tostring(wave))
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoSummon()
    while Toggles.AutoSummon.Value do
        local remote = nil
        if (Options.SummonType and Options.SummonType.Value) == "Premium" then
            remote = Remotes.SummonPremium
        else
            remote = Remotes.SummonMain
        end
        if remote then
            local amt = tonumber(Options.SummonAmount and Options.SummonAmount.Value) or 1
            SafeInvoke(remote, Toggles.FastSummon.Value, amt)
        end
        task.wait()
    end
end
local function Func_AutoBuyBoxes()
    while Toggles.AutoBuyBoxes.Value do
        local wantedBoxes = AddMultiDropdown("SelectBoxesToBuy")
        if next(wantedBoxes) then
            local modules = RS:FindFirstChild("Modules")
            local cfg = modules and GetSafeModule(modules, "MainConfig")
            local data = GetPlayerDataRaw()
            if cfg and type(cfg.Crates) == "table" and type(data) == "table" then
                local remotesFolder = RS:FindFirstChild("Remotes")
                local inventoryFolder = remotesFolder and remotesFolder:FindFirstChild("Inventory")
                local buyCrateRemote = inventoryFolder and GetSafeRemote(inventoryFolder, "BuyCrate")
                if buyCrateRemote then
                    for crateName in pairs(wantedBoxes) do
                        local crateInfo = cfg.Crates[crateName]
                        if crateInfo and crateInfo.Enabled and type(crateInfo.Price) == "table" then
                            local currencyName = crateInfo.Price.Currency
                            local amountStr = Options.BuyAmount and Options.BuyAmount.Value or "1"
                            local amount = tonumber(amountStr) or 1
                            local price = (tonumber(crateInfo.Price.Amount) or 0) * amount
                            local balance = tonumber(data[currencyName]) or 0
                            if price > 0 and price <= balance then
                                FireRemote(buyCrateRemote, crateName, amount)
                                notyuri("bought crate", crateName, "x", amount, "for", price, tostring(currencyName))
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoBuyRaidMerchant()
    while Toggles.AutoBuyRaidMerchant.Value do
        local wantedItems = AddMultiDropdown("SelectRaidMerchantItems")
        local stock = Shared.RaidMerchantStock
        if next(wantedItems) and type(stock) == "table" and Remotes.RaidMerchantBuy then
            local modules = RS:FindFirstChild("Modules")
            local cfg = modules and GetSafeModule(modules, "RaidMerchant")
            local data = GetPlayerDataRaw()
            if type(cfg) == "table" and type(data) == "table" then
                for index, entry in ipairs(stock) do
                    local itemName = type(entry) == "table" and entry.Name
                    if itemName and wantedItems[itemName] then
                        local itemInfo = cfg[itemName]
                        local price = itemInfo and tonumber(itemInfo.Price)
                        local balance = tonumber(data.Crystals) or 0
                        if price and price <= balance then
                            local ok, result = pcall(function()
                                return Remotes.RaidMerchantBuy:InvokeServer(index)
                            end)
                            if ok and result == true then
                                notyuri("bought raid merchant item", itemName, "for", price, "Crystals")
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoBuyMerchant()
    while Toggles.AutoBuyMerchant.Value do
        local wantedItems = AddMultiDropdown("SelectMerchantItems")
        local stock = Shared.MerchantStock
        if next(wantedItems) and type(stock) == "table" and Remotes.MerchantBuy then
            local modules = RS:FindFirstChild("Modules")
            local cfg = modules and GetSafeModule(modules, "Merchant")
            local data = GetPlayerDataRaw()
            if type(cfg) == "table" and type(data) == "table" then
                for index, entry in ipairs(stock) do
                    local itemName = type(entry) == "table" and entry.Name
                    if itemName and wantedItems[itemName] then
                        local itemInfo = cfg[itemName]
                        local price = itemInfo and tonumber(itemInfo.Price)
                        if price then
                            if entry.Modifier == "Silver" then
                                price = price * 2
                            elseif entry.Modifier == "Gold" then
                                price = price * 4
                            elseif entry.Modifier == "Rainbow" then
                                price = price * 8
                            end
                            local balance = tonumber(data.Gems) or 0
                            if price <= balance then
                                local ok, result = pcall(function()
                                    return Remotes.MerchantBuy:InvokeServer(index)
                                end)
                                if ok then
                                    notyuri("merchant buy", itemName, entry.Modifier or "", "for", price, "Gems", "result:", tostring(result))
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoCraft()
    while Toggles.AutoCraft.Value do
        local wantedUnits = AddMultiDropdown("SelectCraftUnits")
        if next(wantedUnits) then
            local modules = RS:FindFirstChild("Modules")
            local cfg = modules and GetSafeModule(modules, "CraftManager")
            local remotesFolder = RS:FindFirstChild("Remotes")
            local inventoryFolder = remotesFolder and remotesFolder:FindFirstChild("Inventory")
            local craftRemote = inventoryFolder and GetSafeRemote(inventoryFolder, "CraftItem")
            if type(cfg) == "table" and type(cfg.Config) == "table" and craftRemote then
                for craftId, craftInfo in pairs(cfg.Config) do
                    if type(craftInfo) == "table" and wantedUnits[craftInfo.Reward] then
                        local data = GetPlayerDataRaw()
                        if type(data) == "table" and type(data.Towers) == "table" and type(data.Items) == "table" then
                            local canCraft = true
                            for _, material in pairs(craftInfo.Materials) do
                                local source = material.materialType == "Tower" and data.Towers or data.Items
                                local owned = source[material.name]
                                if type(owned) ~= "table" or (tonumber(owned.Stacks) or 0) < material.amount then
                                    canCraft = false
                                    break
                                end
                            end
                            if canCraft then
                                local ok, result = pcall(function()
                                    return craftRemote:InvokeServer(craftId)
                                end)
                                if ok and type(result) == "table" then
                                    if result.success then
                                        notyuri("crafted", result.reward, result.modifier or "")
                                    else
                                        notyuri("craft failed", craftInfo.Reward, result.reason, result.missing)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoOpenBoxes()
    while Toggles.AutoOpenBoxes.Value do
        local BoxesToOpen = AddMultiDropdown("SelectBoxes")
        local amountStr = Options.OpenAmount and Options.OpenAmount.Value or "1"
        local amountCap = tonumber(amountStr) or 1
        if next(BoxesToOpen) then
            local data = GetPlayerDataRaw()
            if type(data) == "table" and type(data.Items) == "table" then
                for crateName in pairs(BoxesToOpen) do
                    if crateName and type(data.Items[crateName]) == "table" then
                        local owned = data.Items[crateName].Stacks or 0
                        local toOpen = math.min(owned, amountCap)
                        if toOpen > 0 then
                            local openRemote = RS:FindFirstChild("Remotes")
                            openRemote = openRemote and openRemote:FindFirstChild("Inventory")
                            openRemote = openRemote and openRemote:FindFirstChild("OpenCrate")
                            if openRemote and openRemote:IsA("RemoteFunction") then
                                local result = SafeInvoke(openRemote, Toggles.FastOpen.Value, crateName, toOpen)
                                if type(result) == "table" then
                                    notyuri("opened", toOpen, "x", tostring(crateName))
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function ClaimPassTiers(remote, claimed, current, exp, required, maxTier)
    claimed = claimed or {}
    current = current or 0
    for tier = 1, maxTier or 0 do
        local isClaimed = claimed[tier] == true or claimed[tostring(tier)] == true
        local reachable = tier <= current or (tier == current + 1 and (required or math.huge) <= (exp or 0))
        if not isClaimed and reachable then
            local result = SafeInvoke(remote, false, tier)
            notyuri("pass tier claim", tier, tostring(result))
        end
    end
end
local function Func_AutoCollectPass()
    if not (Remotes.GetPassState and Remotes.ClaimTier) then return end
    while Toggles.AutoCollectPass.Value do
        local state = SafeInvoke(Remotes.GetPassState, false)
        if type(state) == "table" then
            ClaimPassTiers(Remotes.ClaimTier, state.ClaimedTiers, state.CurrentTier, state.EXP, state.RequiredEXP, state.MaxTier)
            if state.PremiumPass == true and Remotes.PremiumClaimTier then
                ClaimPassTiers(Remotes.PremiumClaimTier, state.PremClaimedTiers, state.PremCurrentTier, state.PremEXP, state.PremRequiredEXP, state.MaxTier)
            end
            if Toggles.ResetPass.Value and state.CanReset and Remotes.ResetPass then
                notyuri("pass reset", tostring(SafeInvoke(Remotes.ResetPass, false)))
            end
        end
        task.wait()
    end
end
local function ClaimQuestRows(container, claimFn)
    if not container then return end
    for _, row in ipairs(container:GetChildren()) do
        local button = row:FindFirstChild("Progress") and row.Progress:FindFirstChild("ClaimButton")
        if button and button.Visible then
            claimFn(row.Name)
            notyuri("quest claim", row.Name)
        end
    end
end
local function Func_AutoCollectQuests()
    local main = Plr.PlayerGui:FindFirstChild("Main")
    local allQuests = GetObject(main, "QuestsFrame.QuestMainFrame.MainFrame.AllQuests")
    local passList = GetObject(main, "BattlepassFrame.QuestsPage.List")
    local giftFolder = RS:FindFirstChild("GiftFolder")
    local giftData = giftFolder and GetSafeModule(giftFolder, "SharedGiftData")
    local giftBase, giftFetched = 0, 0
    while Toggles.AutoCollectQuests.Value do
        if giftData and Remotes.GiftGetData and Remotes.ClaimGift then
            if tick() - giftFetched > 30 then
                giftBase = tonumber(SafeInvoke(Remotes.GiftGetData, false)) or 0
                giftFetched = tick()
            end
            local claimed = Plr:FindFirstChild("ClaimedGifts")
            local session = Plr:FindFirstChild("CurrentSession")
            if claimed and session then
                for _, gift in pairs(giftData) do
                    if gift.Time <= giftBase + session.Value and not claimed:FindFirstChild(tostring(gift.GiftNumber)) then
                        local result = SafeInvoke(Remotes.ClaimGift, false, gift.GiftNumber)
                        notyuri("playtime gift claim", gift.GiftNumber, tostring(result))
                    end
                end
            end
        end
        if Remotes.CollectQuest and allQuests then
            for _, questType in ipairs({"Daily", "Weekly"}) do
                ClaimQuestRows(allQuests:FindFirstChild(questType), function(id)
                    FireRemote(Remotes.CollectQuest, id, questType)
                end)
            end
        end
        if Remotes.PassQuests then
            ClaimQuestRows(passList, function(id)
                SafeInvoke(Remotes.PassQuests, false, "Claim", id)
            end)
        end
        task.wait()
    end
end
local function PopulateRemotes()
    local functionsFolder = RS:FindFirstChild("Functions")
    if functionsFolder then
        for _, name in ipairs(Shared.SlopFuncs) do
            local remote = GetSafeRemote(functionsFolder, name)
            if remote then Remotes[name] = remote end
        end
    end
    local eventsFolder = RS:FindFirstChild("Events")
    if eventsFolder then
        for _, name in ipairs(Shared.SlopEvents) do
            local remote = GetSafeRemote(eventsFolder, name)
            if remote then Remotes[name] = remote end
        end
        for _, name in ipairs(Shared.LobbyEvents) do
            local remote = GetSafeRemote(eventsFolder, name)
            if remote then Remotes[name] = remote end
        end
        local toggleClient = eventsFolder:FindFirstChild("toggleClient")
        if toggleClient and toggleClient:IsA("BindableEvent") then
            Remotes.toggleClient = toggleClient
        end
    end
    local giftFolder = RS:FindFirstChild("GiftFolder")
    if giftFolder then
        local getData = GetSafeRemote(giftFolder, "GetData")
        if getData then Remotes.GiftGetData = getData end
        local claimGift = GetSafeRemote(giftFolder, "ClaimGift")
        if claimGift then Remotes.ClaimGift = claimGift end
    end
    local network = RS:FindFirstChild("Network")
    local remoteEvents = network and network:FindFirstChild("RemoteEvents")
    if remoteEvents then
        for _, name in ipairs({"SendQuestData", "CollectQuest", "CheckAndChoose"}) do
            local remote = GetSafeRemote(remoteEvents, name)
            if remote then Remotes[name] = remote end
        end
    end
    local remotesFolder = RS:FindFirstChild("Remotes")
    local gameRemotes = remotesFolder and remotesFolder:FindFirstChild("GameRemotes")
    if gameRemotes then
        for _, name in ipairs({"GetPassState", "ClaimTier", "PremiumClaimTier", "PassQuests", "ResetPass"}) do
            local remote = GetSafeRemote(gameRemotes, name)
            if remote then Remotes[name] = remote end
        end
    end
    local summon = remotesFolder and remotesFolder:FindFirstChild("Summon")
    if summon then
        local main = GetSafeRemote(summon, "Summon")
        if main then Remotes.SummonMain = main end
        local premium = GetSafeRemote(summon, "SummonPremium")
        if premium then Remotes.SummonPremium = premium end
    end
end
PopulateRemotes()
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
local function GetMatchStats(timeout)
    task.wait(.5)
    local function snapshot()
        local gui = Plr:FindFirstChild("PlayerGui")
        local statsFolder = gui and GetObject(gui, "GameGui.EndScreen.Stats")
        if not statsFolder then return {} end
        local results = {}
        for _, child in ipairs(statsFolder:GetChildren()) do
            local total = child:FindFirstChild("Total")
            if total and total:IsA("TextLabel") and (child.Visible ~= false) then
                local stripped = total.Text:gsub("^x", "")
                local numPart, suffix = stripped:match("^(%d+%.?%d*)(%a*)$")
                local base = numPart and tonumber(numPart)
                local mult = base and (suffix == "" and 1 or Shared.AbbrevMultiplier[suffix])
                if mult then
                    table.insert(results, { Name = child.Name, Value = base * mult })
                end
            end
        end
        return results
    end
    local start = tick()
    local last = snapshot()
    while tick() - start < (timeout or 2) do
        task.wait()
        local current = snapshot()
        local changed = #current ~= #last
        if not changed then
            for i, stat in ipairs(current) do
                if not last[i] or last[i].Name ~= stat.Name or last[i].Value ~= stat.Value then
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
    local info = GetInfo()
    local minsObj = info and info:FindFirstChild("Min")
    local secsObj = info and info:FindFirstChild("Sec")
    local mins = minsObj and minsObj.Value or 0
    local secs = secsObj and secsObj.Value or 0
    local stats = GetMatchStats(2)
    local lines = {}
    for _, stat in ipairs(stats) do
        table.insert(lines, string.format("+%d %s", math.round(stat.Value), stat.Name))
    end
    local rewards = table.concat(lines, "\n")
    local desc = string.format(
        "**%s - %s**\n- Time: %d:%02d\n- Player: ||%s||\n- Rewards:\n%s",
        "Match Finished", outcome, mins, secs, Plr.Name, rewards
    )
    SendWebhook("Match Finished", desc)
    notyuri("Match finished notification sent:", outcome)
end
do
    local info = GetInfo()
    if info then
        local message = info:WaitForChild("Message", 5)
        if message then
            SafeConnect("MatchEndWebhook", function() return message.Changed end, function(msg)
                if not (Toggles.WHMatchEnd and Toggles.WHMatchEnd.Value) then return end
                if msg ~= "Victory" and msg ~= "Defeat" then return end
                SendMatchEndWebhook(msg)
            end)
        end
    end
    local eventsFolder = RS:FindFirstChild("Events")
    local skipButton = eventsFolder and eventsFolder:FindFirstChild("SkipButton")
    if skipButton and skipButton:IsA("RemoteEvent") then
        SafeConnect("SkipButton", function() return skipButton.OnClientEvent end, OnSkipVoteEvent)
    end
    local rogueCard = eventsFolder and eventsFolder:FindFirstChild("RogueCard")
    if rogueCard and rogueCard:IsA("RemoteEvent") then
        SafeConnect("RogueCard", function() return rogueCard.OnClientEvent end, function(kind, payload)
            if kind == "Offer" and type(payload) == "table" then
                Shared.RogueState.Offer = payload
            elseif kind == "Closed" then
                local offer = Shared.RogueState.Offer
                if offer and offer.Id == payload then
                    Shared.RogueState.Offer = nil
                end
            end
        end)
    end
    if eventsFolder then
        local entered = eventsFolder:FindFirstChild("ElevatorEntered")
        if entered and entered:IsA("RemoteEvent") then
            SafeConnect("ElevatorEntered", function() return entered.OnClientEvent end, function(name, isHost, setup)
                if type(name) == "string" then
                    Shared.ElevState.Current = name
                    Shared.ElevState.Setup = setup and true or false
                    Shared.ElevState.Teleported = false
                    Shared.ElevState.Started = tick()
                    notyuri("entered", name)
                end
            end)
        end
        local left = eventsFolder:FindFirstChild("ElevatorLeft")
        if left and left:IsA("RemoteEvent") then
            SafeConnect("ElevatorLeft", function() return left.OnClientEvent end, function()
                Shared.ElevState.Current = nil
                notyuri("left")
            end)
        end
        local teleported = eventsFolder:FindFirstChild("OnTeleported")
        if teleported and teleported:IsA("RemoteEvent") then
            SafeConnect("OnTeleported", function() return teleported.OnClientEvent end, function()
                Shared.ElevState.Teleported = true
                Shared.ElevState.Current = nil
                notyuri("teleporting to game place")
            end)
        end
    end
    local network = RS:FindFirstChild("Network")
    local remoteEvents = network and network:FindFirstChild("RemoteEvents")
    local sendQuest = remoteEvents and remoteEvents:FindFirstChild("SendQuestData")
    if sendQuest and sendQuest:IsA("RemoteEvent") then
        SafeConnect("SendQuestData", function() return sendQuest.OnClientEvent end, function(payload)
            Shared.LobbyQuest.Cache = payload
            PushQuestClaims(payload)
        end)
    end
    local events = RS:FindFirstChild("Events")
    local antiMacro = events and events:FindFirstChild("AntiMacro")
    if antiMacro then
        local checkEvent = antiMacro:FindFirstChild("Check")
        local respondRemote = antiMacro:FindFirstChild("Respond")
        if checkEvent and checkEvent:IsA("RemoteEvent") and respondRemote and respondRemote:IsA("RemoteEvent") then
            SafeConnect("AntiMacro", function() return checkEvent.OnClientEvent end, function(id)
                respondRemote:FireServer(id)
            end)
        end
    end
    local leaveVote = events and events:FindFirstChild("LeaveVote")
    if leaveVote and leaveVote:IsA("RemoteEvent") then
        Remotes.LeaveVote = leaveVote
    end
    local raidReady = events and events:FindFirstChild("RaidReadyEvent")
    if raidReady and raidReady:IsA("RemoteEvent") then
        Remotes.RaidReadyEvent = raidReady
    end
    local remotesFolder = RS:FindFirstChild("Remotes")
    local raidMerchant = remotesFolder and remotesFolder:FindFirstChild("RaidMerchant")
    if raidMerchant then
        local buyRemote = raidMerchant:FindFirstChild("Buy")
        if buyRemote and buyRemote:IsA("RemoteFunction") then
            Remotes.RaidMerchantBuy = buyRemote
        end
        local getCurrent = raidMerchant:FindFirstChild("GetCurrentMerchant")
        if getCurrent and getCurrent:IsA("RemoteFunction") then
            local ok, result = pcall(function() return getCurrent:InvokeServer() end)
            if ok and type(result) == "table" then
                Shared.RaidMerchantStock = result
            end
        end
        local updateAll = raidMerchant:FindFirstChild("UpdateAllPlayersMerchant")
        if updateAll and updateAll:IsA("RemoteEvent") then
            SafeConnect("UpdateAllPlayersMerchant", function() return updateAll.OnClientEvent end, function(stock)
                if type(stock) == "table" then
                    Shared.RaidMerchantStock = stock
                end
            end)
        end
    end
    local merchant = remotesFolder and remotesFolder:FindFirstChild("Merchant")
    if merchant then
        local buyRemote = merchant:FindFirstChild("Buy")
        if buyRemote and buyRemote:IsA("RemoteFunction") then
            Remotes.MerchantBuy = buyRemote
        end
        local getCurrent = merchant:FindFirstChild("GetCurrentMerchant")
        if getCurrent and getCurrent:IsA("RemoteFunction") then
            local ok, result = pcall(function() return getCurrent:InvokeServer() end)
            if ok and type(result) == "table" then
                Shared.MerchantStock = result
            end
        end
        local updateAll = merchant:FindFirstChild("UpdateAllPlayersMerchant")
        if updateAll and updateAll:IsA("RemoteEvent") then
            SafeConnect("UpdateAllPlayersMerchant_Normal", function() return updateAll.OnClientEvent end, function(stock)
                if type(stock) == "table" then
                    Shared.MerchantStock = stock
                end
            end)
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
        T4 = TB.Main.Left.Autofarm:AddTab("Raid"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Config"),
        T2 = TB.Main.Right.Autofarm:AddTab("LobbyConfig"),
        T3 = TB.Main.Right.Autofarm:AddTab("Priority"),
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
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 1000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 30, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", {
    Text = "Anti Knockback",
    Default = false,
})
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Default = true,
    Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AutoJump", { Text = "Auto Jump" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused" })
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function() Serverhop() end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Players.LocalPlayer) end })
AddSliderToggle({ Group = GB.Player.Left.Server, Id = "AutoServerhop", Text = "Auto Serverhop (Minutes)", Default = 30, Min = 0, Max = 300 }, function(state)
    Thread("AutoServerhop", function()
        local lastHop = tick()
        while Toggles.AutoServerhop.Value do
            task.wait(5)
            if not Toggles.AutoServerhop.Value then break end
            if (tick() - lastHop) >= (Options.AutoServerhopValue.Value * 60) then
                Serverhop()
                break
            end
        end
    end, state)
end)
AddSliderToggle({ Group = GB.Player.Left.Server, Id = "AutoRejoin", Text = "Auto Rejoin (Minutes)", Default = 30, Min = 0, Max = 300 }, function(state)
    Thread("AutoRejoin", function()
        local lastRejoin = tick()
        while Toggles.AutoRejoin.Value do
            task.wait(5)
            if not Toggles.AutoRejoin.Value then break end
            if (tick() - lastRejoin) >= (Options.AutoRejoinValue.Value * 60) then
                TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                break
            end
        end
    end, state)
end)
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
local function GetBoxes()
    local crateNames = {}
    local modules = RS:FindFirstChild("Modules")
    if modules then
        local cfg = GetSafeModule(modules, "MainConfig")
        if cfg and type(cfg.Crates) == "table" then
            for crateName, data in pairs(cfg.Crates) do
                if type(crateName) == "string" then
                    table.insert(crateNames, crateName)
                end
            end
        end
        if cfg and type(cfg.Chest) == "table" then
            for chestName, data in pairs(cfg.Chest) do
                if type(chestName) == "string" then
                    table.insert(crateNames, chestName)
                end
            end
        end
    end
    table.sort(crateNames)
    return #crateNames > 0 and crateNames or { "Loading..." }
end
local function GetRaidMerchantItems()
    local names = {}
    local modules = RS:FindFirstChild("Modules")
    local cfg = modules and GetSafeModule(modules, "RaidMerchant")
    if type(cfg) == "table" then
        for itemName in pairs(cfg) do
            if type(itemName) == "string" then
                table.insert(names, itemName)
            end
        end
    end
    table.sort(names)
    return #names > 0 and names or { "Loading..." }
end
local function GetMerchantItems()
    local names = {}
    local modules = RS:FindFirstChild("Modules")
    local cfg = modules and GetSafeModule(modules, "Merchant")
    if type(cfg) == "table" then
        for itemName in pairs(cfg) do
            if type(itemName) == "string" then
                table.insert(names, itemName)
            end
        end
    end
    table.sort(names)
    return #names > 0 and names or { "Loading..." }
end
local function GetCraftUnits()
    local names = {}
    local modules = RS:FindFirstChild("Modules")
    local cfg = modules and GetSafeModule(modules, "CraftManager")
    if type(cfg) == "table" and type(cfg.Config) == "table" then
        for _, craftInfo in pairs(cfg.Config) do
            if type(craftInfo) == "table" and type(craftInfo.Reward) == "string" then
                table.insert(names, craftInfo.Reward)
            end
        end
    end
    table.sort(names)
    return #names > 0 and names or { "Loading..." }
end
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
AddSliderToggle({ Group = APLeft, Id = "AutoSell", Text = "Auto Sell at Wave", Default = 10, Min = 0, Max = 100, Rounding = 0 })
AddSliderToggle({ Group = APLeft, Id = "AutoSellFarm", Text = "Auto Sell Farm at Wave", Default = 10, Min = 0, Max = 100, Rounding = 0 })
APLeft:AddDivider()
local APRight = Tabs.AutoPlay:AddRightGroupbox("Limits")
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
APRight:AddLabel("Place Wave per Slot", true)
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
APRight:AddLabel("Place Limit per Slot", true)
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
APRight:AddLabel("Upgrade Limit per Slot", true)
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
UpdatePosLabels()
TB_Tabs.Autofarm.T1:AddToggle("AutoAbility", { Text = "Auto Tower Ability", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSkip", { Text = "Auto Skip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSpeed", { Text = "Auto Game Speed", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReplay", { Text = "Auto Replay", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoNewMap", { Text = "Auto New Map", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoLeave", { Text = "Auto Leave", Default = false })
TB_Tabs.Autofarm2.T1:AddSlider("AutoLeaveValue", {
    Text = "Leave at Wave",
    Default = 10,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("SpeedTarget", { Text = "Speed Target", Values = { "1", "2", "3", "4", "5", "6" }, Default = "2" })
local function GetMapVoteValues()
    local values = {}
    local modules = RS:FindFirstChild("Modules")
    local modesConfig = modules and GetSafeModule(modules, "ModesConfig")
    if type(modesConfig) == "table" then
        for name in pairs(modesConfig) do
            if not Shared.MapVoteExcludedKeys[name] then
                table.insert(values, name)
            end
        end
    end
    return values
end
TB_Tabs.Autofarm2.T1:AddDropdown("MapVote", {
    Text = "Map Vote",
    Values = GetMapVoteValues(),
    Searchable = true,
    Default = "",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteMap", { Text = "Auto Vote Map", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("DifficultyVote", {
    Text = "Difficulty Vote",
    Values = { "Normal", "Hard", "Nightmare", "Chaos" },
    Default = "",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteDifficulty", { Text = "Auto Vote Difficulty", Default = false })
local function GetSpecialVoteValues()
    local values = {}
    local modules = RS:FindFirstChild("Modules")
    local specialsConfig = modules and GetSafeModule(modules, "SpecialsConfig")
    if type(specialsConfig) == "table" then
        for _, name in ipairs(specialsConfig.ORDER or {}) do
            table.insert(values, name)
        end
        for _, name in ipairs(specialsConfig.ULTRA_ORDER or {}) do
            table.insert(values, name)
        end
    end
    return values
end
TB_Tabs.Autofarm2.T1:AddDropdown("SpecialVote", {
    Text = "Special Vote",
    Values = GetSpecialVoteValues(),
    Default = "",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteSpecial", { Text = "Auto Vote Special", Default = false })
for i = 1, 3 do
    AddMultiDropdown(TB_Tabs.Autofarm2.T3, "MutatorPriority" .. i, {
        Text = "Mutator Priority " .. i,
        Values = Shared.MutatorState.Ids,
        Default = {},
    })
    TB_Tabs.Autofarm2.T3:AddToggle("AutoRejoinMutator" .. i, { Text = "Rejoin If No Match " .. i, Default = false })
end
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteMutator", { Text = "Auto Vote Mutator", Default = false })
local function GetRogueCardIds()
    local values = {}
    local modules = RS:FindFirstChild("Modules")
    local rogueConfig = modules and GetSafeModule(modules, "RogueConfig")
    if type(rogueConfig) == "table" and type(rogueConfig.CARDS) == "table" then
        for _, card in ipairs(rogueConfig.CARDS) do
            table.insert(values, "[Rogue] " .. card.Id)
        end
    end
    local specialsConfig = modules and GetSafeModule(modules, "SpecialsConfig")
    if type(specialsConfig) == "table" and type(specialsConfig.PACTS) == "table" then
        for _, pact in ipairs(specialsConfig.PACTS) do
            table.insert(values, "[Pact] " .. pact.Id)
        end
    end
    return values
end
for i = 1, 3 do
    AddMultiDropdown(TB_Tabs.Autofarm2.T3, "RogueCardPriority" .. i, {
        Text = "Card Priority " .. i,
        Values = GetRogueCardIds(),
        Default = {},
    })
end
TB_Tabs.Autofarm.T1:AddToggle("AutoPickCards", { Text = "Auto Pick Cards", Default = false })
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
do
    AddSliderToggle({ Group = TB_Tabs.Autofarm.T4, Id = "AutoReady", Text = "Auto Ready", Default = 2, Min = 0, Max = 30, Rounding = 1 })
    TB_Tabs.Autofarm.T4:AddToggle("PlayRaidMacro", {
        Text = "Play Raid Macro",
        Default = false,
    })
    for _, label in ipairs(Shared.RaidMaps) do
        local mapName = label:match("^([^%[]-)%s*%[") or label
        local id = "MacroMap_" .. mapName
        TB_Tabs.Autofarm.T4:AddDropdown(id, {
            Text = label,
            Values = ListMacros(),
            Default = "",
        })
        table.insert(Shared.MapMacroIds, id)
    end
end
TB_Tabs.Autofarm.T3:AddToggle("AutoJoin", { Text = "Auto Join" })
MultiToggle({
    Group = TB_Tabs.Autofarm.T3,
    Id = "AutoSummon",
    Text = "Auto Summon",
    Children = { { Id = "FastSummon", Text = "Fast Summon" } },
})
TB_Tabs.Autofarm2.T2:AddDropdown("SummonType", { Text = "Summon Type", Values = {"Basic", "Premium"}, Default = "Basic" })
TB_Tabs.Autofarm2.T2:AddDropdown("SummonAmount", { Text = "Summon Amount", Values = {"1", "10", "50", "1000"}, Default = "1" })
MultiToggle({
    Group = TB_Tabs.Autofarm.T3,
    Id = "AutoOpenBoxes",
    Text = "Auto Open Boxes",
    Children = { { Id = "FastOpen", Text = "Fast Open" } },
})
AddMultiDropdown(TB_Tabs.Autofarm2.T2, "SelectBoxes", {
    Text = "Select Open Boxes",
    Values = GetBoxes(),
    Default = {},
})
TB_Tabs.Autofarm2.T2:AddDropdown("OpenAmount", {
    Text = "Open Amount",
    Values = { "1", "10", "25", "50" },
    Default = "1",
})
TB_Tabs.Autofarm.T3:AddToggle("AutoBuyBoxes", { Text = "Auto Buy Boxes" })
MultiToggle({
    Group = TB_Tabs.Autofarm.T3,
    Id = "AutoCollectPass",
    Text = "Auto Collect Pass",
    Children = { { Id = "ResetPass", Text = "Reset Pass" } },
})
TB_Tabs.Autofarm.T3:AddToggle("AutoCollectQuests", { Text = "Auto Collect Quests" })
AddMultiDropdown(TB_Tabs.Autofarm2.T2, "SelectBoxesToBuy", {
    Text = "Boxes To Buy",
    Values = GetBoxes(),
    Default = {},
})
TB_Tabs.Autofarm2.T2:AddDropdown("BuyAmount", {
    Text = "Buy Amount",
    Values = { "1", "10", "25", "50" },
    Default = "1",
})
TB_Tabs.Autofarm.T3:AddToggle("AutoBuyRaidMerchant", { Text = "Auto Buy Raid" })
AddMultiDropdown(TB_Tabs.Autofarm2.T2, "SelectRaidMerchantItems", {
    Text = "Raid Items To Buy",
    Values = GetRaidMerchantItems(),
    Default = {},
})
TB_Tabs.Autofarm.T3:AddToggle("AutoBuyMerchant", { Text = "Auto Buy Merchant" })
AddMultiDropdown(TB_Tabs.Autofarm2.T2, "SelectMerchantItems", {
    Text = "Merchant Items To Buy",
    Values = GetMerchantItems(),
    Default = {},
})
TB_Tabs.Autofarm.T3:AddToggle("AutoCraft", { Text = "Auto Craft Units" })
AddMultiDropdown(TB_Tabs.Autofarm2.T2, "SelectCraftUnits", {
    Text = "Units To Craft",
    Values = GetCraftUnits(),
    Default = {},
})
EnsureFolderPath(Shared.MDir)
LoadPositions()
Toggles.AntiKnockback:OnChanged(function(state)
    Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
    Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
    Thread("Noclip", FuncNoclip, v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
    local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if Hum then
        if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
        if Toggles.JP.Value then
            Hum.JumpPower = Options.JPValue.Value
            Hum.UseJumpPower = true
        end
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
    if Toggles.LimitFPS.Value then
        setfpscap(Options.LimitFPSValue.Value)
    end
end)
Toggles.LimitFPS:OnChanged(function(v)
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
Toggles.AutoJump:OnChanged(function(state)
    Thread("AutoJump", function()
        while Toggles.AutoJump.Value do
            local hum = Plr.Character and Plr.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            Services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(0.3)
            Services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            task.wait(5)
        end
    end, state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP and Toggles.InstantPP.Value then
        prompt.HoldDuration = 0
    end
end)
local function RunAntiAFK()
    if Shared.antiAFKConn then Shared.antiAFKConn:Enable() return end
    local GC = getconnections or get_signal_cons
    if GC then
        local conns = GC(Players.LocalPlayer.Idled)
        local target = conns and conns[1]
        if target and target.Disable then
            target:Disable()
            Shared.antiAFKConn = target
            return
        end
        for _, c in pairs(conns or {}) do
            if c.Disable then
                c:Disable()
                Shared.antiAFKConn = c
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
    elseif Shared.antiAFKConn and Shared.antiAFKConn.Enable then
        Shared.antiAFKConn:Enable()
    end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
task.spawn(function()
    while task.wait(1) do
        local gui = Plr:FindFirstChild("PlayerGui")
        local checkGui = gui and gui:FindFirstChild("AntiMacroCheck")
        local frame = checkGui and checkGui:FindFirstChild("Frame")
        local button = frame and frame:FindFirstChild("TextButton")
        if button then
            if fire_event(button.Activated) then
                notyuri("clicked")
            end
            task.wait(1)
        end
    end
end)
Toggles.AutoPlace:OnChanged(function(state)
    Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), state)
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state)
end)
Toggles.AutoAbility:OnChanged(function(state)
    Thread("AutoAbility", SafeLoop("AutoAbility", Func_AutoAbility), state)
end)
Toggles.AutoOpenBoxes:OnChanged(function(state)
    Thread("AutoOpenBoxes", SafeLoop("AutoOpenBoxes", Func_AutoOpenBoxes), state)
end)
Toggles.AutoBuyBoxes:OnChanged(function(state)
    Thread("AutoBuyBoxes", SafeLoop("AutoBuyBoxes", Func_AutoBuyBoxes), state)
end)
Toggles.AutoCollectQuests:OnChanged(function(state)
    Thread("AutoCollectQuests", SafeLoop("AutoCollectQuests", Func_AutoCollectQuests), state)
end)
Toggles.AutoCollectPass:OnChanged(function(state)
    Thread("AutoCollectPass", SafeLoop("AutoCollectPass", Func_AutoCollectPass), state)
end)
Toggles.AutoBuyRaidMerchant:OnChanged(function(state)
    Thread("AutoBuyRaidMerchant", SafeLoop("AutoBuyRaidMerchant", Func_AutoBuyRaidMerchant), state)
end)
Toggles.AutoBuyMerchant:OnChanged(function(state)
    Thread("AutoBuyMerchant", SafeLoop("AutoBuyMerchant", Func_AutoBuyMerchant), state)
end)
Toggles.AutoCraft:OnChanged(function(state)
    Thread("AutoCraft", SafeLoop("AutoCraft", Func_AutoCraft), state)
end)
Toggles.AutoSpeed:OnChanged(function(state)
    Thread("AutoSpeed", SafeLoop("AutoSpeed", Func_AutoSpeed), state)
end)
Toggles.AutoVoteMap:OnChanged(function(state)
    Thread("AutoVoteMap", SafeLoop("AutoVoteMap", function() Func_AutoVote(Toggles.AutoVoteMap, "Voting", Remotes.VoteForMap, Options.MapVote, "AutoVoteMap") end), state)
end)
Toggles.AutoVoteDifficulty:OnChanged(function(state)
    Thread("AutoVoteDifficulty", SafeLoop("AutoVoteDifficulty", function() Func_AutoVote(Toggles.AutoVoteDifficulty, "ComplicationVoting", Remotes.VoteForComplication, Options.DifficultyVote, "AutoVoteDifficulty") end), state)
end)
Toggles.AutoVoteSpecial:OnChanged(function(state)
    Thread("AutoVoteSpecial", SafeLoop("AutoVoteSpecial", function() Func_AutoVote(Toggles.AutoVoteSpecial, "SpecialVoting", Remotes.VoteForSpecial, Options.SpecialVote, "AutoVoteSpecial") end), state)
end)
Toggles.AutoVoteMutator:OnChanged(function(state)
    Thread("AutoVoteMutator", SafeLoop("AutoVoteMutator", Func_AutoVoteMutator), state)
end)
Toggles.AutoPickCards:OnChanged(function(state)
    Thread("AutoPickCards", SafeLoop("AutoPickCards", Func_AutoPickCards), state)
end)
Toggles.AutoReplay:OnChanged(function(state)
    Thread("AutoReplay", SafeLoop("AutoReplay", function() Func_EndScreenVote(Toggles.AutoReplay, true, "replay vote sent") end), state)
end)
Toggles.AutoNewMap:OnChanged(function(state)
    Thread("AutoNewMap", SafeLoop("AutoNewMap", function() Func_EndScreenVote(Toggles.AutoNewMap, "new", "new map vote sent") end), state)
end)
Toggles.AutoJoin:OnChanged(function(state)
    Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), state)
end)
Toggles.AutoReady:OnChanged(function(state)
    Thread("AutoReady", SafeLoop("AutoReady", Func_AutoReady), state)
end)
Toggles.AutoSell:OnChanged(function(state)
    Thread("AutoSell", SafeLoop("AutoSell", function() Func_AutoAtWave(Toggles.AutoSell, Options.AutoSellValue, "sell", false) end), state)
end)
Toggles.AutoSellFarm:OnChanged(function(state)
    Thread("AutoSellFarm", SafeLoop("AutoSellFarm", function() Func_AutoAtWave(Toggles.AutoSellFarm, Options.AutoSellFarmValue, "sell", true) end), state)
end)
Toggles.AutoLeave:OnChanged(function(state)
    Thread("AutoLeave", SafeLoop("AutoLeave", function() Func_AutoAtWave(Toggles.AutoLeave, Options.AutoLeaveValue, "leave") end), state)
end)
Toggles.AutoSummon:OnChanged(function(state)
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
Toggles.PlayRaidMacro:OnChanged(function(state)
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
    Thread("LoadRaidMacro", SafeLoop("Raid Macro Replay", function() Func_MacroReplay(true) end), state)
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
    Shared.Farm = false
    Shared.MState.Rec = false
    Shared.MState.Rep = false
    Shared.MState.Cur = nil
    Shared.MState.Load = nil
    Shared.MState.Pending = {}
    if Shared.antiAFKConn and Shared.antiAFKConn.Enable then pcall(function() Shared.antiAFKConn:Enable() end) end
    if Support.FPS then pcall(function() setfpscap(2000) end) end
    Cleanup(Connections)
    Cleanup(Flags)
        Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("yuri")
SaveManager:SetFolder("yuri/STD")
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
