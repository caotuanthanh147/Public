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
local RemotesRoot = GetObject(RS, "Remotes")
local Remotes = {
    OrderItem = RemotesRoot and GetObject(RemotesRoot, "Plot.OrderItem"),
    StartNextDay = RemotesRoot and GetObject(RemotesRoot, "Plot.StartNextDay"),
    SetGoodPrice = RemotesRoot and GetObject(RemotesRoot, "Goods.SetGoodPrice"),
    PlaceGoods = RemotesRoot and GetObject(RemotesRoot, "Goods.PlaceGoods"),
    PickUpBox = RemotesRoot and GetObject(RemotesRoot, "Goods.PickUpBox"),
    BeginShift = RemotesRoot and GetObject(RemotesRoot, "Checkout.BeginShift"),
    ScanCurrent = RemotesRoot and GetObject(RemotesRoot, "Checkout.ScanCurrent"),
    AcceptPayment = RemotesRoot and GetObject(RemotesRoot, "Checkout.AcceptPresentedPayment"),
    SubmitCashChange = RemotesRoot and GetObject(RemotesRoot, "Checkout.SubmitCashChange"),
    SubmitCardAmount = RemotesRoot and GetObject(RemotesRoot, "Checkout.SubmitCardAmount"),
    EndShift = RemotesRoot and GetObject(RemotesRoot, "Checkout.EndShift"),
    CleanMess = RemotesRoot and GetObject(RemotesRoot, "Mess.Clean"),
    BeginCare = RemotesRoot and GetObject(RemotesRoot, "Enclosures.BeginCare"),
    CompleteCare = RemotesRoot and GetObject(RemotesRoot, "Enclosures.CompleteCare"),
    CurbsideAccept = RemotesRoot and GetObject(RemotesRoot, "Curbside.Accept"),
    CurbsidePack = RemotesRoot and GetObject(RemotesRoot, "Curbside.Pack"),
    CurbsideDeliver = RemotesRoot and GetObject(RemotesRoot, "Curbside.Deliver"),
    BoxReport = RemotesRoot and GetObject(RemotesRoot, "Boxes.Report"),
    PurchaseGood = RemotesRoot and GetObject(RemotesRoot, "Goods.PurchaseGood"),
    OpenStore = RemotesRoot and GetObject(RemotesRoot, "Plot.OpenStore"),
    ToggleDoors = RemotesRoot and GetObject(RemotesRoot, "Plot.ToggleDoors"),
    PurchaseCrate = RemotesRoot and GetObject(RemotesRoot, "Pets.PurchaseCrate"),
    ResolveCratePet = RemotesRoot and GetObject(RemotesRoot, "Pets.ResolveCratePet"),
    CrateShowcase = RemotesRoot and GetObject(RemotesRoot, "Pets.CrateShowcase"),
    PlacePetFromBox = RemotesRoot and GetObject(RemotesRoot, "Pets.PlacePetFromBox"),
    RequestHelp = RemotesRoot and GetObject(RemotesRoot, "NPC.RequestHelp"),
    AnswerHelp = RemotesRoot and GetObject(RemotesRoot, "NPC.AnswerHelp"),
    BatGrab = RemotesRoot and GetObject(RemotesRoot, "Bat.Grab"),
    BatDrop = RemotesRoot and GetObject(RemotesRoot, "Bat.Drop"),
    BatSwing = RemotesRoot and GetObject(RemotesRoot, "Bat.Swing"),
}
local ModulesRoot = GetObject(RS, "Modules")
local ModulesUI = ModulesRoot and ModulesRoot:FindFirstChild("UI3")
local Modules = {
    ActivePlot = ModulesRoot and GetSafeModule(ModulesRoot, "ActivePlot"),
    PlayerData = ModulesRoot and GetSafeModule(ModulesRoot, "PlayerDataClient"),
    ShelfRules = ModulesRoot and GetSafeModule(ModulesRoot, "ShelfRules"),
    EnclosureRules = ModulesRoot and GetSafeModule(ModulesRoot, "EnclosureRules"),
    Maintenance = ModulesRoot and GetSafeModule(ModulesRoot, "EnclosureMaintenance"),
    CheckoutMoney = ModulesRoot and GetSafeModule(ModulesRoot, "CheckoutMoney"),
    CrateConfig = ModulesRoot and GetSafeModule(ModulesRoot, "CrateConfig"),
    GoodsCatalogue = ModulesRoot and GetSafeModule(ModulesRoot, "GoodsCatalogue"),
    PetCatalogue = ModulesRoot and GetSafeModule(ModulesRoot, "PetCatalogue"),
    StoreDayConfig = ModulesRoot and GetSafeModule(ModulesRoot, "StoreDayConfig"),
    PetPackData = ModulesUI and GetSafeModule(ModulesUI, "PetPackData"),
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
                    end
                end
            end
            task.wait()
        end
    end, true)
    return label
end
function AddSliderToggle(Config, ...)
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
local function TweenTo(speed, target, offset, arive)
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
    local goal = cframe.Position
    while true do
        local _, delta = RunService.Stepped:Wait()
        char = GetCharacter()
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local diff = goal - hrp.Position
        local dist = diff.Magnitude
        if arive and dist <= arive then
            return true
        end
        local stepDist = speed * delta
        if dist <= stepDist then
            hrp.CFrame = cframe
            return true
        end
        hrp.CFrame = CFrame.new(hrp.Position + diff.Unit * stepDist) * (hrp.CFrame - hrp.CFrame.Position)
    end
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
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
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
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function() Serverhop() end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
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
                TeleportService:Teleport(game.PlaceId, Plr)
                break
            end
        end
    end, state)
end)
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
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
Shared.BoxGens = {}
Shared.Memo = { Mess = {}, Care = {}, Box = {}, Fill = {} }
Shared.Checkout = { Seq = 0, State = nil, Active = false, Recent = {} }
Shared.StockCursor = {}
Shared.PetPlaceAt = {}
Shared.HelpAt = setmetatable({}, { __mode = "k" })
Shared.Connects = {}
local function ConnectListeners()
    local function Once(key, path, handler)
        if Shared.Connects[key] then return end
        local ev = GetObject(RS, path)
        if ev and ev.OnClientEvent then
            SafeConnect(key, function() return ev.OnClientEvent end, handler)
            Shared.Connects[key] = true
        end
    end
    Once("BoxSpawn", "Remotes.Boxes.Spawn", function(key, plotName, extra, props, cframe, gen)
        if type(key) == "string" and type(gen) == "number" then
            Shared.BoxGens[key] = gen
        end
    end)
    Once("CheckoutState", "Remotes.UI.CheckoutState", function(state)
        if type(state) == "table" and state.phase == "Idle" and state.ended == true then
            Shared.Checkout.Active = false
            Shared.Checkout.State = nil
            return
        end
        Shared.Checkout.State = state
    end)
    Once("DaySummary", "Remotes.UI.DaySummary", function()
        if Toggles.AutoNextDay and Toggles.AutoNextDay.Value then
            task.delay(1, function()
                if Toggles.AutoNextDay.Value and Remotes.StartNextDay then
                    Remotes.StartNextDay:FireServer()
                end
            end)
        end
    end)
end
ConnectListeners()
local function GetPlot()
    if Modules.ActivePlot then
        local ok, res = pcall(function() return Modules.ActivePlot.getPlot() end)
        if ok then return res end
    end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local host = Plr:GetAttribute("ActivePlotOwnerUserId")
    if type(host) ~= "number" then host = Plr.UserId end
    for _, p in ipairs(plots:GetChildren()) do
        if p:GetAttribute("OwnerUserId") == host then
            return p
        end
    end
    return nil
end
local function GoodInfo(key)
    local root = GetObject(RS, "Goods")
    if not root then return nil end
    for _, cat in ipairs(root:GetChildren()) do
        if cat:IsA("Folder") then
            for _, sub in ipairs(cat:GetChildren()) do
                if sub:IsA("Folder") then
                    local it = sub:FindFirstChild(key)
                    if it and (it:IsA("Model") or it:IsA("BasePart")) then
                        local qty = it:GetAttribute("BoxQuantity")
                        local price = it:GetAttribute("BoxPrice")
                        return {
                            key = key,
                            category = cat.Name,
                            subCategory = sub.Name,
                            qty = type(qty) == "number" and math.floor(qty) or 1,
                            price = type(price) == "number" and price or 0,
                            item = it,
                        }
                    end
                end
            end
        end
    end
    return nil
end
local function GoodsBySize()
    local out = { Small = {}, Medium = {}, Large = {} }
    local root = GetObject(RS, "Goods")
    if not root then return out end
    for _, cat in ipairs(root:GetChildren()) do
        if cat:IsA("Folder") then
            for _, sub in ipairs(cat:GetChildren()) do
                if sub:IsA("Folder") and (sub.Name == "Small" or sub.Name == "Medium" or sub.Name == "Large") then
                    for _, item in ipairs(sub:GetChildren()) do
                        if item:IsA("Model") or item:IsA("BasePart") then
                            local qty = item:GetAttribute("BoxQuantity")
                            table.insert(out[sub.Name], {
                                key = item.Name,
                                category = cat.Name,
                                subCategory = sub.Name,
                                qty = type(qty) == "number" and math.floor(qty) or 1,
                                item = item,
                            })
                        end
                    end
                end
            end
        end
    end
    return out
end
local function GreedyCounts(cents)
    local counts = {}
    if not Modules.CheckoutMoney or type(Modules.CheckoutMoney.Denominations) ~= "table" then
        return counts
    end
    local list = {}
    for _, d in ipairs(Modules.CheckoutMoney.Denominations) do
        table.insert(list, d)
    end
    table.sort(list, function(a, b) return a.cents > b.cents end)
    local rest = cents
    for _, d in ipairs(list) do
        local n = math.floor(rest / d.cents)
        if n > 0 then
            counts[d.id] = n
            rest = rest - n * d.cents
        end
    end
    return counts
end
local function ReportBox(boxKey, cframe)
    local gen = Shared.BoxGens[boxKey]
    if not gen or not Remotes.BoxReport then return end
    pcall(function()
        Remotes.BoxReport:FireServer({ { k = boxKey, c = cframe, g = gen } })
    end)
end
local function FindTill(plot)
    for _, inst in ipairs(plot:GetDescendants()) do
        if inst:IsA("Model") and inst.Name == "Checkout" then
            local f = inst:FindFirstChild("Foundation")
            if f and f:IsA("BasePart") then
                return inst
            end
        end
    end
    return nil
end
local StockLogAt = {}
local function StockLog(key, ...)
    local now = os.clock()
    if StockLogAt[key] and now - StockLogAt[key] < 5 then return end
    StockLogAt[key] = now
    notyuri("[Stock]", key, ...)
end
local function Describe(v)
    if type(v) ~= "table" then return tostring(v) end
    local parts = {}
    for k, val in pairs(v) do
        parts[#parts + 1] = tostring(k) .. "=" .. tostring(val)
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end
local function CanAfford(price, what)
    if type(price) ~= "number" or not Modules.PlayerData or not Modules.PlayerData.getCash then return true end
    local cash = Modules.PlayerData.getCash()
    if cash >= price then return true end
    StockLog("cant-afford:" .. tostring(what), "cash", cash, "price", price)
    return false
end
local function CratePriceOf(petType)
    local folder = Modules.PetCatalogue and Modules.PetCatalogue.typeFolder and Modules.PetCatalogue.typeFolder(petType) or nil
    local price = folder and folder:GetAttribute("CratePrice")
    if type(price) == "number" then return price end
    return Modules.PetPackData and Modules.PetPackData.DEFAULT_PRICE or nil
end
local function ParseGoodKey(key)
    if type(key) ~= "string" or key == "" then return nil, nil end
    if Modules.GoodsCatalogue and Modules.GoodsCatalogue.fromKey then
        return Modules.GoodsCatalogue.fromKey(key)
    end
    return nil, nil
end
local function FindGoodsBox(plot, category, goodName)
    local boxes = plot:FindFirstChild("Boxes")
    if not boxes then return nil, nil end
    for _, b in ipairs(boxes:GetChildren()) do
        local k = b:GetAttribute("BoxKey")
        if type(k) == "string" and b:GetAttribute("Kind") == "Goods" and b:GetAttribute("GoodName") == goodName and b:GetAttribute("Category") == category then
            local carrier = b:GetAttribute("Carrier")
            if carrier == nil or carrier == Plr.UserId then
                return b, k
            end
        end
    end
    return nil, nil
end
local function CountFreeBoxes(plot, kind, attr, value)
    local n = 0
    local boxes = plot:FindFirstChild("Boxes")
    if not boxes then return 0 end
    for _, b in ipairs(boxes:GetChildren()) do
        if b:GetAttribute("Kind") == kind and b:GetAttribute(attr) == value then
            local carrier = b:GetAttribute("Carrier")
            if carrier == nil or carrier == Plr.UserId then
                n = n + 1
            end
        end
    end
    return n
end
local function SyncBoxGens()
    local sync = GetObject(RS, "Remotes.Boxes.Sync")
    if not sync then
        StockLog("sync-missing")
        return
    end
    local ok, res = pcall(function() return sync:InvokeServer() end)
    if not ok or type(res) ~= "table" then
        StockLog("sync-failed", tostring(res))
        return
    end
    local n = 0
    for _, v in pairs(res) do
        if type(v) == "table" and type(v.key) == "string" and type(v.gen) == "number" then
            Shared.BoxGens[v.key] = v.gen
            n = n + 1
        end
    end
    notyuri("[Stock] Boxes.Sync gens loaded:", n)
end
local function CollectShelfNeeds(plot, selected)
    local needs, unassigned = {}, {}
    local goodsData = Modules.PlayerData and Modules.PlayerData.getGoods() or nil
    local shelvesData = type(goodsData) == "table" and type(goodsData.Shelves) == "table" and goodsData.Shelves or nil
    if not shelvesData or not Modules.ShelfRules then return needs, unassigned end
    for _, shelf in ipairs(plot:GetDescendants()) do
        if shelf:IsA("Model") and Modules.ShelfRules.isShelf(shelf) then
            local shelfKey = shelf:GetAttribute("ItemId")
            local size = Modules.ShelfRules.slotSizeOf(shelf)
            if type(shelfKey) == "string" and size then
                for _, slot in ipairs(Modules.ShelfRules.slotModels(shelf)) do
                    local idx = slot:GetAttribute(Modules.ShelfRules.SLOT_INDEX_ATTR)
                    if type(idx) == "number" then
                        local data = shelvesData[shelfKey] and shelvesData[shelfKey][tostring(idx)] or nil
                        local good = type(data) == "table" and data.Good or nil
                        local qty = type(data) == "table" and tonumber(data.Qty) or 0
                        if type(good) == "string" and good ~= "" then
                            local _, name = ParseGoodKey(good)
                            local info = name and GoodInfo(name) or nil
                            if info and qty < info.qty then
                                if selected and qty <= 0 and not selected[name] then
                                    unassigned[size] = (unassigned[size] or 0) + 1
                                else
                                    needs[name] = (needs[name] or 0) + 1
                                end
                            end
                        else
                            unassigned[size] = (unassigned[size] or 0) + 1
                        end
                    end
                end
            end
        end
    end
    return needs, unassigned
end
local function EnclosureMissing(plot, petType)
    local free = 0
    if not Modules.EnclosureRules or not Modules.PlayerData then return 0, 0, 0 end
    local pets = Modules.PlayerData.getPets()
    for _, enc in ipairs(plot:GetDescendants()) do
        if enc:IsA("Model") and Modules.EnclosureRules.isEnclosure(enc) and enc:GetAttribute("AcceptsType") == petType then
            local itemKey = enc:GetAttribute("ItemId")
            if type(itemKey) == "string" then
                local used = 0
                for _, pet in pairs(pets) do
                    if type(pet) == "table" and pet.Enclosure == itemKey then
                        used = used + 1
                    end
                end
                free = free + math.max(0, Modules.EnclosureRules.capacityOf(enc) - used)
            end
        end
    end
    local waiting = CountFreeBoxes(plot, "Pet", "PetType", petType)
    return free - waiting, free, waiting
end
local function StockSlot(plot, pick, shelf, shelfKey, slot, idx)
    local tag = tostring(shelfKey) .. "." .. tostring(idx)
    if not Remotes.PickUpBox or not Remotes.PlaceGoods then
        StockLog("remotes-missing", "PickUpBox", tostring(Remotes.PickUpBox ~= nil), "PlaceGoods", tostring(Remotes.PlaceGoods ~= nil))
        return
    end
    local box, boxKey = FindGoodsBox(plot, pick.category, pick.key)
    if not box then
        if not Remotes.PurchaseGood then
            StockLog("purchase-remote-missing")
            return
        end
        local price = Modules.ShelfRules and pick.item and Modules.ShelfRules.boxPriceOf(pick.item) or nil
        if not CanAfford(price, pick.key) then return false end
        local bought = SafeInvoke(Remotes.PurchaseGood, nil, pick.category, pick.key)
        notyuri("[Stock] purchase", tag, pick.category, pick.key, "->", Describe(bought))
        if bought ~= true then return end
        local waitUntil = os.clock() + 3
        repeat
            box, boxKey = FindGoodsBox(plot, pick.category, pick.key)
            if not box then task.wait(0.1) end
        until box or os.clock() >= waitUntil
        if not box then
            notyuri("[Stock] bought box never appeared", tag, pick.key)
            return
        end
    end
    notyuri("[Stock] using box", tag, boxKey, "carrier", tostring(box:GetAttribute("Carrier")))
    if box:GetAttribute("Carrier") ~= Plr.UserId then
        Remotes.PickUpBox:FireServer(boxKey)
        task.wait(0.2)
        notyuri("[Stock] picked up", boxKey, "carrier now", tostring(box:GetAttribute("Carrier")))
    end
    if not Shared.BoxGens[boxKey] then
        notyuri("[Stock] no gen for", boxKey, "- syncing")
        SyncBoxGens()
    end
    local gp = Modules.ShelfRules and Modules.ShelfRules.goodsPartOf(slot) or nil
    if gp then
        if Shared.BoxGens[boxKey] then
            ReportBox(boxKey, gp.CFrame)
        else
            notyuri("[Stock] still no gen for", boxKey, "- BoxReport skipped")
        end
    else
        notyuri("[Stock] no Goods part on slot", tag)
    end
    local res = SafeInvoke(Remotes.PlaceGoods, nil, boxKey, shelfKey, idx)
    notyuri("[Stock] PlaceGoods", tag, boxKey, "->", typeof(res), Describe(res))
end
local function FindPetEnclosure(plot, petType, petModel)
    local items = plot:FindFirstChild("Items")
    if not items then return nil, nil end
    local pets = Modules.PlayerData.getPets()
    for _, enc in ipairs(items:GetChildren()) do
        if enc:IsA("Model") and Modules.EnclosureRules.isEnclosure(enc) then
            local itemKey = enc:GetAttribute("ItemId")
            if type(itemKey) == "string" and Modules.EnclosureRules.accepts(enc, petType, petModel) then
                local used = 0
                for _, pet in pairs(pets) do
                    if type(pet) == "table" and pet.Enclosure == itemKey then
                        used = used + 1
                    end
                end
                if Modules.EnclosureRules.capacityUsed(enc, used) < Modules.EnclosureRules.capacityOf(enc) then
                    return enc, itemKey
                end
            end
        end
    end
    return nil, nil
end
local function PlaceWaitingPet(plot)
    if not Remotes.PickUpBox or not Remotes.PlacePetFromBox then
        StockLog("pet-remotes-missing", "PickUpBox", tostring(Remotes.PickUpBox ~= nil), "PlacePetFromBox", tostring(Remotes.PlacePetFromBox ~= nil))
        return false
    end
    if not Modules.PetCatalogue or not Modules.EnclosureRules or not Modules.PlayerData then
        StockLog("pet-modules-missing", "PetCatalogue", tostring(Modules.PetCatalogue ~= nil), "EnclosureRules", tostring(Modules.EnclosureRules ~= nil), "PlayerData", tostring(Modules.PlayerData ~= nil))
        return false
    end
    local boxes = plot:FindFirstChild("Boxes")
    if not boxes then return false end
    for _, box in ipairs(boxes:GetChildren()) do
        local boxKey = box:GetAttribute("BoxKey")
        if type(boxKey) == "string" and box:GetAttribute("Kind") == "Pet" then
            local carrier = box:GetAttribute("Carrier")
            local at = Shared.PetPlaceAt[boxKey]
            if (carrier == nil or carrier == Plr.UserId) and not (at and os.clock() - at < 3) then
                local petType = tostring(box:GetAttribute("PetType"))
                local petName = tostring(box:GetAttribute("PetName"))
                local petModel = Modules.PetCatalogue.find(petType, petName)
                if not petModel then
                    StockLog("pet-unresolved:" .. boxKey, "type", petType, "name", petName)
                else
                    local enc, encKey = FindPetEnclosure(plot, petType, petModel)
                    if not enc then
                        StockLog("pet-no-enclosure:" .. petType, "name", petName)
                    else
                        Shared.PetPlaceAt[boxKey] = os.clock()
                        notyuri("[Stock] pet box", boxKey, petType, petName, "->", encKey, "carrier", tostring(carrier))
                        if carrier ~= Plr.UserId then
                            Remotes.PickUpBox:FireServer(boxKey)
                            task.wait(0.2)
                            notyuri("[Stock] picked up pet", boxKey, "carrier now", tostring(box:GetAttribute("Carrier")))
                        end
                        Remotes.PlacePetFromBox:FireServer({ boxKey = boxKey, enclosureKey = encKey })
                        notyuri("[Stock] PlacePetFromBox", boxKey, "->", encKey)
                        local waitUntil = os.clock() + 3
                        repeat
                            task.wait(0.1)
                        until not box.Parent or box:GetAttribute("BoxKey") ~= boxKey or os.clock() >= waitUntil
                        return true
                    end
                end
            end
        end
    end
    return false
end
local function BuyPackIfMissing(plot, petType, minRank)
    local missing, free, waiting = EnclosureMissing(plot, petType)
    if missing > 0 then
        if not CanAfford(CratePriceOf(petType), "pack:" .. petType) then return false end
        local res = SafeInvoke(Remotes.PurchaseCrate, nil, petType)
        notyuri("[BuyPack]", petType, "free", free, "waiting boxes", waiting, "->", Describe(res))
        if type(res) == "table" and type(res.rolls) == "table" and #res.rolls > 0 then
            if Remotes.CrateShowcase then
                Remotes.CrateShowcase:FireServer(res.crateId)
            end
            for _, roll in ipairs(res.rolls) do
                local action = (Modules.CrateConfig.RANK[roll.Rarity] or 0) >= minRank and "keep" or "discard"
                notyuri("[BuyPack] resolve", tostring(roll.Rarity), action)
                Remotes.ResolveCratePet:FireServer(res.crateId, roll.Roll, action)
            end
        end
        task.wait(0.5)
        return true
    end
    StockLog("pack-skip:" .. petType, "free", free, "waiting boxes", waiting)
    return false
end
local function Func_AutoStock()
    while Toggles.AutoStock.Value do
        local ok, err = pcall(function()
            if not Modules.ShelfRules or not Modules.ActivePlot then
                StockLog("modules-missing", "ShelfRules", tostring(Modules.ShelfRules ~= nil), "ActivePlot", tostring(Modules.ActivePlot ~= nil))
                return
            end
            local plot = GetPlot()
            if not plot then
                StockLog("no-plot")
                return
            end
            if PlaceWaitingPet(plot) then return end
            if Modules.CrateConfig and Remotes.PurchaseCrate and Remotes.ResolveCratePet then
                local minRank = Modules.CrateConfig.RANK[Options.PackMinRarity.Value] or 0
                for petType in pairs(AddMultiDropdown("AutoBuyPackTypes")) do
                    if not Toggles.AutoStock.Value then return end
                    if BuyPackIfMissing(plot, petType, minRank) then return end
                end
            else
                StockLog("pack-missing", "CrateConfig", tostring(Modules.CrateConfig ~= nil), "PurchaseCrate", tostring(Remotes.PurchaseCrate ~= nil), "ResolveCratePet", tostring(Remotes.ResolveCratePet ~= nil))
            end
            local selectedGoods = AddMultiDropdown("AutoStockGoods")
            local goodsData = Modules.PlayerData and Modules.PlayerData.getGoods() or nil
            local shelvesData = type(goodsData) == "table" and type(goodsData.Shelves) == "table" and goodsData.Shelves or nil
            if not shelvesData then
                StockLog("no-shelves-data", "PlayerData", tostring(Modules.PlayerData ~= nil), "goods", typeof(goodsData))
                return
            end
            local bySize = GoodsBySize()
            local scanned, needing = 0, 0
            for _, shelf in ipairs(plot:GetDescendants()) do
                if shelf:IsA("Model") and Modules.ShelfRules.isShelf(shelf) then
                    local shelfKey = shelf:GetAttribute("ItemId")
                    local size = Modules.ShelfRules.slotSizeOf(shelf)
                    if type(shelfKey) == "string" and size then
                        local slots = Modules.ShelfRules.slotModels(shelf)
                        local used = {}
                        for _, slot in ipairs(slots) do
                            local idx = slot:GetAttribute(Modules.ShelfRules.SLOT_INDEX_ATTR)
                            if type(idx) == "number" then
                                local data = shelvesData[shelfKey] and shelvesData[shelfKey][tostring(idx)] or nil
                                if type(data) == "table" and type(data.Good) == "string" then
                                    local _, usedName = ParseGoodKey(data.Good)
                                    if usedName then used[usedName] = true end
                                end
                            end
                        end
                        for _, slot in ipairs(slots) do
                            local idx = slot:GetAttribute(Modules.ShelfRules.SLOT_INDEX_ATTR)
                            if type(idx) == "number" then
                                scanned = scanned + 1
                                local data = shelvesData[shelfKey] and shelvesData[shelfKey][tostring(idx)] or nil
                                local good = type(data) == "table" and data.Good or nil
                                if good == "" then good = nil end
                                local qty = type(data) == "table" and tonumber(data.Qty) or 0
                                local pick = nil
                                local reassign = false
                                if good then
                                    local gcat, gname = ParseGoodKey(good)
                                    local info = gname and GoodInfo(gname) or nil
                                    if not info then
                                        StockLog("unresolved-good:" .. shelfKey .. "." .. idx, "slot good", tostring(good), "parsed", tostring(gcat), tostring(gname))
                                    elseif qty < info.qty and selectedGoods[gname] then
                                        pick = info
                                    elseif qty <= 0 and not selectedGoods[gname] then
                                        reassign = true
                                    end
                                end
                                if not good or reassign then
                                    local picks = {}
                                    for _, cand in ipairs(bySize[size] or {}) do
                                        if selectedGoods[cand.key] then
                                            table.insert(picks, cand)
                                        end
                                    end
                                    if #picks > 0 then
                                        Shared.StockCursor[shelfKey] = (Shared.StockCursor[shelfKey] or 0) + 1
                                        local cursor = Shared.StockCursor[shelfKey]
                                        for i = 1, #picks do
                                            local cand = picks[((cursor - 1 + i - 1) % #picks) + 1]
                                            if not used[cand.key] then
                                                pick = cand
                                                break
                                            end
                                        end
                                        pick = pick or picks[((cursor - 1) % #picks) + 1]
                                    elseif not good then
                                        StockLog("no-goods-for-size:" .. size, "size", size)
                                    end
                                end
                                if pick then
                                    needing = needing + 1
                                    notyuri("[Stock] slot needs stock", shelfKey .. "." .. idx, "good", tostring(good), "qty", qty, "->", pick.category .. "/" .. pick.key)
                                    if StockSlot(plot, pick, shelf, shelfKey, slot, idx) ~= false then
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
            StockLog("idle", "slots scanned", scanned, "needing", needing)
        end)
        if not ok then notyuri("AutoStock err:", tostring(err)) end
        task.wait(.1)
    end
end
local function Func_AutoCheckout()
    while Toggles.AutoCheckout.Value do
        local ok, err = pcall(function()
            if not Modules.ActivePlot then return end
            local plot = GetPlot()
            if not plot then return end
            if not Remotes.BeginShift then return end
            local till = plot:FindFirstChild("Checkout")
            if not till then return end
            local npcs = plot:FindFirstChild("NPCs")
            local waiting = false
            if npcs then
                for _, npc in ipairs(npcs:GetChildren()) do
                    local status = npc:GetAttribute("Status")
                    if status == "In line" or status == "Waiting to pay" or status == "Paying" then
                        waiting = true
                        break
                    end
                end
            end
            if waiting then
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local tillPos = till:GetPivot().Position
                if hrp and (hrp.Position - tillPos).Magnitude > 12 then
                    TPTo(tillPos + Vector3.new(0, 5, 0))
                end
            end
            local st = Shared.Checkout.State
            if type(st) ~= "table" or st.transactionId == nil or type(st.phase) ~= "string" then
                if not Shared.Checkout.Active then
                    local res = SafeInvoke(Remotes.BeginShift, nil, till)
                    if type(res) == "table" and res.ok then
                        Shared.Checkout.Active = true
                        if type(res.state) == "table" then
                            Shared.Checkout.State = res.state
                        end
                    else
                        StockLog("checkout-begin-failed", typeof(res), type(res) == "table" and tostring(res.reason) or "")
                    end
                end
                return
            end
            if st.phase == "Scanning" then
                local scanned = {}
                for _, line in ipairs(st.itemLines or {}) do
                    if line.scanned then
                        scanned[line.sourceIndex] = true
                    end
                end
                for _, child in ipairs(till:GetChildren()) do
                    local idx = child:GetAttribute("CheckoutItemIndex")
                    if type(idx) == "number" and child:GetAttribute("CheckoutTransactionId") == st.transactionId and not scanned[idx] then
                        Shared.Checkout.Seq = Shared.Checkout.Seq + 1
                        if Remotes.ScanCurrent then
                            Remotes.ScanCurrent:FireServer(child, st.transactionId, Shared.Checkout.Seq)
                        end
                        return
                    end
                end
            elseif st.phase == "AwaitingPayment" then
                if Remotes.AcceptPayment then
                    Remotes.AcceptPayment:FireServer(true)
                end
            elseif st.phase == "CashChange" then
                local due = tonumber(st.changeDueCents) or 0
                if due > 0 and Remotes.SubmitCashChange then
                    local counts = GreedyCounts(due)
                    if next(counts) then
                        Remotes.SubmitCashChange:FireServer(counts)
                    end
                end
            elseif st.phase == "CardEntry" then
                local total = tonumber(st.totalCents) or 0
                if total > 0 and Remotes.SubmitCardAmount then
                    Remotes.SubmitCardAmount:FireServer(total)
                end
            end
        end)
        if not ok then notyuri("AutoCheckout err:", tostring(err)) end
        task.wait(.2)
    end
end
local function Func_AutoClean()
    while Toggles.AutoClean.Value do
        local ok, err = pcall(function()
            if not Modules.ActivePlot then return end
            local plot = GetPlot()
            if not plot then return end
            for _, inst in ipairs(plot:GetDescendants()) do
                local id = inst:GetAttribute("MessId")
                if type(id) == "string" then
                    if Remotes.CleanMess then
                        Remotes.CleanMess:FireServer({ messId = id })
                    end
                    return
                end
            end
        end)
        if not ok then notyuri("AutoClean err:", tostring(err)) end
        task.wait(1)
    end
end
local function Func_AutoPrice()
    while Toggles.AutoPrice.Value do
        local ok, err = pcall(function()
            if not Modules.ShelfRules or not Modules.ActivePlot then return end
            local plot = GetPlot()
            if not plot then return end
            local goodsData = Modules.PlayerData and Modules.PlayerData.getGoods() or nil
            local shelvesData = type(goodsData) == "table" and type(goodsData.Shelves) == "table" and goodsData.Shelves or nil
            if not shelvesData then return end
            local priced = {}
            for _, shelf in ipairs(plot:GetDescendants()) do
                if shelf:IsA("Model") and Modules.ShelfRules.isShelf(shelf) then
                    local shelfKey = shelf:GetAttribute("ItemId")
                    if type(shelfKey) == "string" then
                        for _, slot in ipairs(Modules.ShelfRules.slotModels(shelf)) do
                            local idx = slot:GetAttribute(Modules.ShelfRules.SLOT_INDEX_ATTR)
                            if type(idx) == "number" then
                                local data = shelvesData[shelfKey] and shelvesData[shelfKey][tostring(idx)] or nil
                                local good = type(data) == "table" and data.Good or nil
                                local gp = Modules.ShelfRules.goodsPartOf(slot)
                                if type(good) == "string" and gp and not priced[good] then
                                    local current = gp:GetAttribute(Modules.ShelfRules.PRICE_ATTR)
                                    if type(current) == "number" then
                                        local info = GoodInfo(good)
                                        if info and info.item then
                                            local optimal = Modules.ShelfRules.optimalPriceOf(info.item)
                                            if type(optimal) == "number" and math.abs(optimal - current) > 0.05 then
                                                if Remotes.SetGoodPrice then
                                                    Remotes.SetGoodPrice:FireServer(good, optimal)
                                                    priced[good] = true
                                                    return
                                                end
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
        if not ok then notyuri("AutoPrice err:", tostring(err)) end
        task.wait()
    end
end
local function Care(enc, itemKey, feature, petKey)
    if not Remotes.BeginCare or not Remotes.CompleteCare then
        StockLog("care-remotes-missing", "BeginCare", tostring(Remotes.BeginCare ~= nil), "CompleteCare", tostring(Remotes.CompleteCare ~= nil))
        return
    end
    local payload = { itemKey = itemKey, feature = feature, petKey = petKey }
    local res = SafeInvoke(Remotes.BeginCare, nil, payload)
    notyuri("[Care] BeginCare", itemKey, feature, "pet", tostring(petKey), "->", typeof(res), Describe(res))
    if type(res) == "table" and res.ok and type(res.token) == "string" then
        payload.token = res.token
        payload.quiet = true
        local done = SafeInvoke(Remotes.CompleteCare, nil, payload)
        notyuri("[Care] CompleteCare", itemKey, feature, "->", typeof(done), Describe(done))
        if type(done) == "table" and done.retryAfter then
            task.wait(done.retryAfter + 0.05)
            done = SafeInvoke(Remotes.CompleteCare, nil, payload)
            notyuri("[Care] CompleteCare retry", itemKey, feature, "->", typeof(done), Describe(done))
        end
    end
end
local function Func_AutoPetCare()
    while Toggles.AutoPetCare.Value do
        local ok, err = pcall(function()
            if not Modules.Maintenance or not Modules.EnclosureRules or not Modules.ActivePlot then
                StockLog("care-modules-missing", "Maintenance", tostring(Modules.Maintenance ~= nil), "EnclosureRules", tostring(Modules.EnclosureRules ~= nil), "ActivePlot", tostring(Modules.ActivePlot ~= nil))
                return
            end
            local plot = GetPlot()
            if not plot then
                StockLog("care-no-plot")
                return
            end
            local scanned = 0
            for _, enc in ipairs(plot:GetDescendants()) do
                if enc:IsA("Model") and Modules.EnclosureRules.isEnclosure(enc) then
                    local itemKey = enc:GetAttribute("ItemId")
                    if type(itemKey) == "string" then
                        scanned = scanned + 1
                        for _, feature in ipairs(Modules.Maintenance.featuresOf(enc)) do
                            local def = Modules.Maintenance.get and Modules.Maintenance.get(feature) or nil
                            if not def and type(Modules.Maintenance.Features) == "table" then
                                def = Modules.Maintenance.Features[feature]
                            end
                            if def then
                                if def.scope == "animal" then
                                    local keys = Modules.Maintenance.needyPetKeysOf(enc, feature)
                                    local pets = enc:FindFirstChild("Pets")
                                    local pickKey, pickModel
                                    for _, key in ipairs(keys) do
                                        local m = pets and pets:FindFirstChild(key) or nil
                                        local need = m and m:GetAttribute(Modules.Maintenance.NEED_ATTRIBUTE_PREFIX .. feature)
                                        if type(need) == "number" and need < Options.AutoPetCareValue.Value then
                                            pickKey, pickModel = key, m
                                            break
                                        end
                                    end
                                    if pickKey then
                                        local pm = pickModel
                                        local pk = pm and pm:GetAttribute("PetKey") or pickKey
                                        notyuri("[Care] due", itemKey, feature, "pets needing", #keys, "-> pet", tostring(pk))
                                        TPTo(enc:GetPivot().Position + Vector3.new(0, 5, 0))
                                        Care(enc, itemKey, feature, pk)
                                        return
                                    end
                                else
                                    local cond = enc:GetAttribute(Modules.Maintenance.CONDITION_ATTRIBUTE_PREFIX .. feature)
                                    if Modules.Maintenance.isDue(enc, feature) and type(cond) == "number" and cond < Options.AutoPetCareValue.Value then
                                        notyuri("[Care] due", itemKey, feature, "condition", tostring(enc:GetAttribute("MaintenanceCondition_" .. feature)))
                                        TPTo(enc:GetPivot().Position + Vector3.new(0, 5, 0))
                                        Care(enc, itemKey, feature, nil)
                                        return
                                    end
                                end
                            else
                                StockLog("care-unknown-feature:" .. feature, "enclosure", itemKey)
                            end
                        end
                    end
                end
            end
            StockLog("care-idle", "enclosures scanned", scanned)
        end)
        if not ok then notyuri("AutoPetCare err:", tostring(err)) end
        task.wait(2)
    end
end
local function Func_AutoBuyStock()
    while Toggles.AutoBuyStock.Value do
        local ok, err = pcall(function()
            if not Remotes.PurchaseGood then
                StockLog("buy-remote-missing")
                return
            end
            local plot = GetPlot()
            if not plot then
                StockLog("buy-no-plot")
                return
            end
            local goods = AddMultiDropdown("AutoBuyStockGoods")
            local needs, unassigned = CollectShelfNeeds(plot, goods)
            local infos, keysBySize = {}, {}
            for key in pairs(goods) do
                local info = GoodInfo(key)
                if info then
                    infos[key] = info
                    keysBySize[info.subCategory] = keysBySize[info.subCategory] or {}
                    table.insert(keysBySize[info.subCategory], key)
                end
            end
            local extraNeed = {}
            for size, keys in pairs(keysBySize) do
                table.sort(keys)
                for i = 1, unassigned[size] or 0 do
                    local k = keys[((i - 1) % #keys) + 1]
                    extraNeed[k] = (extraNeed[k] or 0) + 1
                end
            end
            for key in pairs(goods) do
                if not Toggles.AutoBuyStock.Value then return end
                local info = infos[key]
                if info then
                    local need = (needs[info.key] or 0) + (extraNeed[key] or 0)
                    local have = CountFreeBoxes(plot, "Goods", "GoodName", info.key)
                    if have < need then
                        if CanAfford(info.price, key) then
                            local bought = SafeInvoke(Remotes.PurchaseGood, nil, info.category, info.key)
                            notyuri("[BuyStock] bought", info.category, info.key, "need", need, "have", have, "->", Describe(bought))
                            task.wait(0.5)
                        end
                    else
                        StockLog("buy-skip:" .. key, "need", need, "have", have)
                    end
                else
                    StockLog("buy-unknown-good:" .. key)
                end
            end
        end)
        if not ok then notyuri("AutoBuyStock err:", tostring(err)) end
        task.wait(1)
    end
end
local function Func_AutoBuyPack()
    while Toggles.AutoBuyPack.Value do
        local ok, err = pcall(function()
            if not Modules.CrateConfig or not Remotes.PurchaseCrate or not Remotes.ResolveCratePet then
                StockLog("pack-missing", "CrateConfig", tostring(Modules.CrateConfig ~= nil), "PurchaseCrate", tostring(Remotes.PurchaseCrate ~= nil), "ResolveCratePet", tostring(Remotes.ResolveCratePet ~= nil))
                return
            end
            local plot = GetPlot()
            if not plot then
                StockLog("pack-no-plot")
                return
            end
            local types = AddMultiDropdown("AutoBuyPackTypes")
            local minRank = Modules.CrateConfig.RANK[Options.PackMinRarity.Value] or 0
            for petType in pairs(types) do
                if not Toggles.AutoBuyPack.Value then return end
                BuyPackIfMissing(plot, petType, minRank)
            end
        end)
        if not ok then notyuri("AutoBuyPack err:", tostring(err)) end
        task.wait(1)
    end
end
local function Func_AutoCloseStore()
    while Toggles.AutoNextDay.Value do
        local ok, err = pcall(function()
            if not Modules.StoreDayConfig or not Remotes.ToggleDoors then
                StockLog("close-missing", "StoreDayConfig", tostring(Modules.StoreDayConfig ~= nil), "ToggleDoors", tostring(Remotes.ToggleDoors ~= nil))
                return
            end
            local plot = GetPlot()
            if not plot then return end
            if plot:GetAttribute("StoreOpen") ~= true or plot:GetAttribute("DoorsLocked") == true then return end
            if not Modules.StoreDayConfig.isRunning(plot) or Modules.StoreDayConfig.customersAllowed(plot) then return end
            local sign = plot:FindFirstChild("OpenSign")
            local signPart = sign and sign:FindFirstChild("OpenSignBack")
            if not signPart or not signPart:IsA("BasePart") then
                StockLog("close-no-sign", "OpenSign", tostring(sign ~= nil))
                return
            end
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            notyuri("[CloseStore] cutoff reached, hour", tostring(Modules.StoreDayConfig.hourOfPlot(plot)))
            Remotes.ToggleDoors:FireServer()
            task.wait(0.5)
            notyuri("[CloseStore] StoreOpen now", tostring(plot:GetAttribute("StoreOpen")))
            task.wait(1)
        end)
        if not ok then notyuri("AutoCloseStore err:", tostring(err)) end
        task.wait(1)
    end
end

local function Func_AutoOpenStore()
    while Toggles.AutoOpenStore.Value do
        local ok, err = pcall(function()
            if not Remotes.OpenStore then
                StockLog("open-remote-missing")
                return
            end
            local plot = GetPlot()
            if not plot then
                StockLog("open-no-plot")
                return
            end
            if plot:GetAttribute("StoreOpen") == true then return end
            if plot:GetAttribute("DoorsLocked") == true then
                StockLog("open-doors-locked")
                return
            end
            local sign = plot:FindFirstChild("OpenSign")
            local signPart = sign and sign:FindFirstChild("OpenSignBack")
            if not signPart or not signPart:IsA("BasePart") then
                StockLog("open-no-sign", "OpenSign", tostring(sign ~= nil))
                return
            end
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            notyuri("[OpenStore] firing OpenStore, StoreDay", tostring(plot:GetAttribute("StoreDay")))
            Remotes.OpenStore:FireServer()
            task.wait(0.5)
            notyuri("[OpenStore] StoreOpen now", tostring(plot:GetAttribute("StoreOpen")))
            task.wait(1)
        end)
        if not ok then notyuri("AutoOpenStore err:", tostring(err)) end
        task.wait(1)
    end
end
local function SlotHasGoods(shelf, slot)
    local goods = shelf:FindFirstChild("Goods")
    local idx = Modules.ShelfRules and Modules.ShelfRules.slotIndexOf(slot) or nil
    if not goods or not idx then return false end
    local prefix = "Slot" .. tostring(idx) .. "_"
    for _, child in ipairs(goods:GetChildren()) do
        if child.Name:sub(1, #prefix) == prefix then
            return true
        end
    end
    return false
end
local function CurbsideGoodsOf(car)
    local raw = car:GetAttribute("CurbsideGoods")
    if typeof(raw) ~= "string" or raw == "" then return {} end
    local ok, res = pcall(HttpService.JSONDecode, HttpService, raw)
    if ok and type(res) == "table" then return res end
    return {}
end
local function FindMyCurbsideCar(host)
    for _, car in ipairs(Services.CollectionService:GetTagged("CurbsideCar")) do
        if car:IsA("Model") and car:GetAttribute("OwnerUserId") == host and car:GetAttribute("CurbsideAcceptedBy") == Plr.UserId then
            local st = car:GetAttribute("CurbsideState")
            if st == "Accepted" or st == "Complete" then
                return car, st
            end
        end
    end
    return nil, nil
end
local CurbsideDelivered = setmetatable({}, { __mode = "k" })
local function IsNear(part, range)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    return hrp ~= nil and part ~= nil and (hrp.Position - part.Position).Magnitude <= range
end
local function TPToCar(car, range)
    local part = car.PrimaryPart or car:FindFirstChild("Main") or car:FindFirstChildWhichIsA("BasePart")
    if not part or IsNear(part, range) then return end
    TPTo(part.Position + Vector3.new(0, 5, 0))
end
local function Func_AutoCurbside()
    while Toggles.AutoCurbside.Value do
        local ok, err = pcall(function()
            if not Modules.ActivePlot or not Remotes.CurbsideAccept then return end
            local host = Plr.UserId
            if Modules.ActivePlot.getHostUserId then
                host = Modules.ActivePlot.getHostUserId()
            end
            local mine, state = FindMyCurbsideCar(host)
            if mine then
                if state == "Complete" then
                    if not Remotes.CurbsideDeliver then
                        StockLog("curbside-deliver-missing")
                        return
                    end
                    local deliveredAt = CurbsideDelivered[mine]
                    if deliveredAt and os.clock() - deliveredAt < 5 then return end
                    TPToCar(mine, 12)
                    Remotes.CurbsideDeliver:FireServer(mine)
                    CurbsideDelivered[mine] = os.clock()
                    notyuri("[Curbside] deliver", mine:GetFullName())
                    task.wait(1)
                    return
                end
                if not Remotes.CurbsidePack or not Modules.ShelfRules then
                    StockLog("curbside-pack-missing", "CurbsidePack", tostring(Remotes.CurbsidePack ~= nil), "ShelfRules", tostring(Modules.ShelfRules ~= nil))
                    return
                end
                local plot = GetPlot()
                if not plot then
                    StockLog("curbside-no-plot")
                    return
                end
                for _, g in pairs(CurbsideGoodsOf(mine)) do
                    local remaining = (tonumber(g.units) or 0) - (tonumber(g.packed) or 0)
                    if remaining > 0 and type(g.goodKey) == "string" then
                        local _, gname = ParseGoodKey(g.goodKey)
                        local packSlot, packPart, packShelf = nil, nil, nil
                        local emptyShelf, emptySlot = nil, nil
                        for _, shelf in ipairs(plot:GetDescendants()) do
                            if shelf:IsA("Model") and Modules.ShelfRules.isShelf(shelf) then
                                for _, slot in ipairs(Modules.ShelfRules.slotModels(shelf)) do
                                    local gp = Modules.ShelfRules.goodsPartOf(slot)
                                    if gp and gp:GetAttribute(Modules.ShelfRules.ASSIGNED_ATTR) == g.goodKey then
                                        if SlotHasGoods(shelf, slot) then
                                            packSlot, packPart, packShelf = slot, gp, shelf
                                            break
                                        elseif not emptySlot then
                                            emptyShelf, emptySlot = shelf, slot
                                        end
                                    end
                                end
                            end
                            if packSlot then break end
                        end
                        if packSlot then
                            if not IsNear(packPart, 12) then
                                TPTo(packShelf)
                            end
                            Remotes.CurbsidePack:FireServer(mine, packSlot)
                            notyuri("[Curbside] pack", g.goodKey, "remaining", remaining)
                            task.wait(0.3)
                            return
                        elseif emptySlot then
                            local info = gname and GoodInfo(gname) or nil
                            local shelfKey = emptyShelf:GetAttribute("ItemId")
                            local idx = emptySlot:GetAttribute(Modules.ShelfRules.SLOT_INDEX_ATTR)
                            if info and type(shelfKey) == "string" and type(idx) == "number" then
                                notyuri("[Curbside] slot empty, stocking", g.goodKey, shelfKey .. "." .. idx)
                                StockSlot(plot, info, emptyShelf, shelfKey, emptySlot, idx)
                                task.wait(0.5)
                            else
                                StockLog("curbside-unresolved:" .. g.goodKey, "info", tostring(info ~= nil), "shelfKey", tostring(shelfKey), "idx", tostring(idx))
                            end
                            return
                        else
                            StockLog("curbside-no-slot:" .. g.goodKey, "no shelf slot assigned to", g.goodKey)
                        end
                    end
                end
                return
            end
            for _, car in ipairs(Services.CollectionService:GetTagged("CurbsideCar")) do
                if car:IsA("Model") and car:GetAttribute("OwnerUserId") == host then
                    local accepted = car:GetAttribute("CurbsideAcceptedBy")
                    if (accepted == nil or accepted == 0) and car:GetAttribute("CurbsideWindow") ~= nil and car:GetAttribute("CurbsideState") == "Waiting" then
                        TPToCar(car, 30)
                        Remotes.CurbsideAccept:FireServer(car)
                        notyuri("[Curbside] accept", car:GetFullName())
                        return
                    end
                end
            end
        end)
        if not ok then notyuri("AutoCurbside err:", tostring(err)) end
        task.wait()
    end
end
local function Func_AutoHelpCustomer()
    while Toggles.AutoHelpCustomer.Value do
        local ok, err = pcall(function()
            if not Remotes.RequestHelp or not Remotes.AnswerHelp then
                StockLog("help-remotes-missing", "RequestHelp", tostring(Remotes.RequestHelp ~= nil), "AnswerHelp", tostring(Remotes.AnswerHelp ~= nil))
                return
            end
            local plot = GetPlot()
            if not plot then
                StockLog("help-no-plot")
                return
            end
            for _, npc in ipairs(Services.CollectionService:GetTagged("CustomerNPC")) do
                if npc:IsDescendantOf(plot) and npc:GetAttribute("StaffRole") == nil and npc:GetAttribute("NeedsHelp") == true then
                    local res = SafeInvoke(Remotes.RequestHelp, nil, npc)
                    if type(res) == "table" and type(res.options) == "table" then
                        local bestId, bestLabel, bestPrice = nil, nil, nil
                        for _, o in ipairs(res.options) do
                            local price = tonumber((tostring(o.sublabel):gsub("[%$,]", "")))
                            if price and (not bestPrice or price > bestPrice) then
                                bestId, bestLabel, bestPrice = o.id, o.label, price
                            end
                        end
                        if bestId ~= nil then
                            notyuri("[Help]", npc:GetFullName(), tostring(res.kind), tostring(res.prompt), "->", tostring(bestId), tostring(bestLabel), tostring(bestPrice))
                            Remotes.AnswerHelp:FireServer(npc, bestId)
                            task.wait(0.5)
                            return
                        end
                        StockLog("help-no-price:" .. tostring(res.kind), "prompt", tostring(res.prompt), "options", #res.options)
                    else
                        StockLog("help-no-result", npc:GetFullName(), typeof(res))
                    end
                end
            end
        end)
        if not ok then notyuri("AutoHelpCustomer err:", tostring(err)) end
        task.wait(1)
    end
end
local function Func_AutoCatchThief()
    while Toggles.AutoCatchThief.Value do
        local ok, err = pcall(function()
            if not Remotes.BatGrab or not Remotes.BatSwing then
                StockLog("thief-remotes-missing", "BatGrab", tostring(Remotes.BatGrab ~= nil), "BatSwing", tostring(Remotes.BatSwing ~= nil))
                return
            end
            local plot = GetPlot()
            local npcs = plot and plot:FindFirstChild("NPCs")
            if not npcs then
                StockLog("thief-no-npcs")
                return
            end
            local thief = nil
            for _, npc in ipairs(npcs:GetChildren()) do
                if npc:IsA("Model") and npc:GetAttribute("Shoplifter") == true then
                    thief = npc
                    break
                end
            end
            local holding = Plr:GetAttribute("HoldingBat") == true
            if not thief then
                if holding and Remotes.BatDrop then
                    Remotes.BatDrop:FireServer()
                    notyuri("[Thief] no thief, bat dropped")
                end
                return
            end
            if not holding then
                local bat = plot:FindFirstChild("Bat")
                if not bat or not bat:IsA("BasePart") or bat:GetAttribute("HeldBy") ~= nil then
                    StockLog("thief-bat-unavailable")
                    return
                end
                TPTo(bat.Position + Vector3.new(0, 3, 0))
                task.wait(0.1)
                Remotes.BatGrab:FireServer()
                notyuri("[Thief] grab bat")
                local waited = 0
                while Plr:GetAttribute("HoldingBat") ~= true and waited < 2 do
                    task.wait(0.1)
                    waited = waited + 0.1
                end
                if Plr:GetAttribute("HoldingBat") ~= true then
                    StockLog("thief-grab-failed")
                    return
                end
            end
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local thiefRoot = thief:FindFirstChild("HumanoidRootPart")
            if not hrp or not thiefRoot then return end
            local target = thiefRoot.Position
            hrp.CFrame = CFrame.lookAt(target + Vector3.new(0, 0, 3), Vector3.new(target.X, target.Y, target.Z))
            task.wait(0.05)
            Remotes.BatSwing:FireServer(1)
            notyuri("[Thief] swing", thief:GetFullName())
            task.wait(0.8)
        end)
        if not ok then notyuri("AutoCatchThief err:", tostring(err)) end
        task.wait(0.1)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoStock", { Text = "Auto Stock" })
TB_Tabs.Autofarm.T1:AddToggle("AutoCheckout", { Text = "Auto Checkout" })
TB_Tabs.Autofarm.T1:AddToggle("AutoClean", { Text = "Auto Clean" })
TB_Tabs.Autofarm.T1:AddDivider()
TB_Tabs.Autofarm.T1:AddToggle("AutoPrice", { Text = "Auto Price" })
AddSliderToggle({ Group = TB_Tabs.Autofarm.T1, Id = "AutoPetCare", Text = "Auto Pet Care", Default = 90, Min = 0, Max = 100 })
TB_Tabs.Autofarm.T1:AddToggle("AutoCurbside", { Text = "Auto Curbside" })
TB_Tabs.Autofarm.T1:AddToggle("AutoHelpCustomer", { Text = "Auto Help Customer" })
TB_Tabs.Autofarm.T1:AddToggle("AutoCatchThief", { Text = "Auto Catch Thief" })
TB_Tabs.Autofarm.T1:AddToggle("AutoNextDay", { Text = "Auto Next Day" })
TB_Tabs.Autofarm.T1:AddToggle("AutoOpenStore", { Text = "Auto Open Store" })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyPack", { Text = "Auto Buy Pack" })
local packTypes = {}
if Modules.PetCatalogue then
    for _, folder in ipairs(Modules.PetCatalogue.typeFolders()) do
        table.insert(packTypes, folder.Name)
    end
    table.sort(packTypes)
end
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyStock", { Text = "Auto Buy Stock" })
local stockGoods = {}
if Modules.GoodsCatalogue then
    for _, cat in ipairs(Modules.GoodsCatalogue.categoryFolders()) do
        for _, item in ipairs(Modules.GoodsCatalogue.allOf(cat.Name)) do
            table.insert(stockGoods, item.Name)
        end
    end
    table.sort(stockGoods)
end
AddMultiDropdown(TB_Tabs.Autofarm2.T1, "AutoStockGoods", { Text = "Auto Stock Goods", Values = stockGoods })
AddMultiDropdown(TB_Tabs.Autofarm2.T1, "AutoBuyStockGoods", { Text = "Stock Goods", Values = stockGoods })
AddMultiDropdown(TB_Tabs.Autofarm2.T1, "AutoBuyPackTypes", { Text = "Pack Types", Values = packTypes })
TB_Tabs.Autofarm2.T1:AddDropdown("PackMinRarity", {
    Text = "Keep Pets Rarity",
    Values = Modules.CrateConfig and Modules.CrateConfig.TIERS or {},
    Default = "Rare",
})
Toggles.AutoStock:OnChanged(function(state)
    Thread("AutoStock", SafeLoop("AutoStock", Func_AutoStock), state)
end)
Toggles.AutoCheckout:OnChanged(function(state)
    Thread("AutoCheckout", SafeLoop("AutoCheckout", Func_AutoCheckout), state)
    if not state and Shared.Checkout.Active then
        Shared.Checkout.Active = false
        Shared.Checkout.State = nil
        if Remotes.EndShift then
            pcall(function() Remotes.EndShift:FireServer() end)
        end
    end
end)
Toggles.AutoClean:OnChanged(function(state)
    Thread("AutoClean", SafeLoop("AutoClean", Func_AutoClean), state)
end)
Toggles.AutoPrice:OnChanged(function(state)
    Thread("AutoPrice", SafeLoop("AutoPrice", Func_AutoPrice), state)
end)
Toggles.AutoPetCare:OnChanged(function(state)
    Thread("AutoPetCare", SafeLoop("AutoPetCare", Func_AutoPetCare), state)
end)
Toggles.AutoNextDay:OnChanged(function(state)
    Thread("AutoCloseStore", SafeLoop("AutoCloseStore", Func_AutoCloseStore), state)
end)
Toggles.AutoOpenStore:OnChanged(function(state)
    Thread("AutoOpenStore", SafeLoop("AutoOpenStore", Func_AutoOpenStore), state)
end)
Toggles.AutoBuyStock:OnChanged(function(state)
    Thread("AutoBuyStock", SafeLoop("AutoBuyStock", Func_AutoBuyStock), state)
end)
Toggles.AutoBuyPack:OnChanged(function(state)
    Thread("AutoBuyPack", SafeLoop("AutoBuyPack", Func_AutoBuyPack), state)
end)
Toggles.AutoCurbside:OnChanged(function(state)
    Thread("AutoCurbside", SafeLoop("AutoCurbside", Func_AutoCurbside), state)
end)
Toggles.AutoHelpCustomer:OnChanged(function(state)
    Thread("AutoHelpCustomer", SafeLoop("AutoHelpCustomer", Func_AutoHelpCustomer), state)
end)
Toggles.AutoCatchThief:OnChanged(function(state)
    Thread("AutoCatchThief", SafeLoop("AutoCatchThief", Func_AutoCatchThief), state)
end)
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
SaveManager:SetFolder("Yuri/PetStoreTycoon")
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
