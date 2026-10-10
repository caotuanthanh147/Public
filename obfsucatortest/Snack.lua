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
local CS = Services.CollectionService
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
local SelfThreads = {}
local function SafeInvoke(remote, skip, ...)
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
    if skip then return end
    local start = tick()
    while not done and (tick() - start) < 2 do
        task.wait()
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
local function TweenTo(speed, target, offset)
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
Shared.Labels = {}
Shared.PosDir = "Yuri/Snack"
Shared.MDir = Shared.PosDir .. "/Macros"
Shared.PosPath = Shared.PosDir .. "/position.json"
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
    NextKey = 0,
    RecKeys = {},
    RepMap = {},
    Saved = false,
    Pending = {},
    Adopted = {},
    SelfThreads = SelfThreads,
    SelfFire = false,
}
Shared.Memo = {
    MatchStart = 0,
    Voted = {},
    WebhookSent = "",
    MatchRewards = false,
}
Shared.Place = {
    SlotPositions = {},
    TypeFails = {},
    PauseUntil = {},
}
local SnackFuncs = {
    "PlaceTower",
    "UpgradeTower",
    "UpgradeAllTowers",
    "SellTower",
    "SetTowerTarget",
    "StarsFuseRequest",
}
local SnackEvents = {
    "ModalVote",
    "RequestGameSpeed",
    "RequestNextLevel",
    "RequestReplayLevel",
    "RequestReturnToLobby",
    "RequestRestartMatch",
    "RequestPlay",
    "RequestStartGame",
    "RequestSummon",
    "RequestTraitRoll",
    "MatchRejoinAnswer",
    "MatchRejoinOffer",
}
local function PopulateRemotes()
    local folder = RS:FindFirstChild("FrameworkEvents")
    if not folder then return end
    for _, name in ipairs(SnackFuncs) do
        local remote = folder:FindFirstChild(name)
        if remote and remote:IsA("RemoteFunction") then
            Remotes[name] = remote
        end
    end
    for _, name in ipairs(SnackEvents) do
        local remote = folder:FindFirstChild(name)
        if remote and remote:IsA("RemoteEvent") then
            Remotes[name] = remote
        end
    end
end
PopulateRemotes()
local function Invoke(name, ...)
    local remote = Remotes[name]
    if not remote then return nil end
    local args = {...}
    local thread = coroutine.running()
    if thread then Shared.MState.SelfThreads[thread] = true end
    Shared.MState.SelfFire = true
    local result = SafeInvoke(remote, nil, unpack(args))
    if thread then Shared.MState.SelfThreads[thread] = nil end
    Shared.MState.SelfFire = false
    return result
end
local function Fire(name, ...)
    local remote = Remotes[name]
    if not remote then return false end
    local args = {...}
    local ok, err = pcall(function()
        remote:FireServer(unpack(args))
    end)
    if not ok then notyuri("Fire error:", name, tostring(err)) end
    return ok
end
local function GetCash()
    return tonumber(Plr:GetAttribute("RoundCurrency")) or 0
end
local function GetWave()
    return tonumber(RS:GetAttribute("CurrentWave")) or 0
end
local function GetPhase()
    return RS:GetAttribute("RoundPhase") or ""
end
local function RoundLive()
    return RS:GetAttribute("RoundActive") == true and GetPhase() ~= "Waiting"
end
local function BoardLive()
    local phase = GetPhase()
    return phase == "Prep" or phase == "Wave" or phase == "Intermission" or phase == "TutorialHold"
end
local function LeaderValue(name)
    local stats = Plr:FindFirstChild("leaderstats")
    local value = stats and stats:FindFirstChild(name)
    return value and tonumber(value.Value) or 0
end
local function GetTowerCfg(name)
    local templates = GetObject(RS, "ReplicatedFramework.Templates")
    local towers = templates and GetSafeModule(templates, "Towers")
    if type(towers) ~= "table" or type(towers.Towers) ~= "table" then return nil end
    return towers.Towers[name]
end
local function MaxLevelOf(cfg)
    if type(cfg) ~= "table" then return 0 end
    return (type(cfg.Upgrades) == "table") and #cfg.Upgrades or 0
end
local function TowerCap(cfg)
    if type(cfg) ~= "table" then return 0 end
    if cfg.CustomMaxPerPlayer ~= nil then
        return tonumber(cfg.CustomMaxPerPlayer) or 0
    end
    local templates = GetObject(RS, "ReplicatedFramework.Templates")
    local towers = templates and GetSafeModule(templates, "Towers")
    local settings = type(towers) == "table" and towers.GlobalSettings or nil
    return settings and tonumber(settings.MaxTowerPerPlayer) or 0
end
local function BoardCap()
    local templates = GetObject(RS, "ReplicatedFramework.Templates")
    local towers = templates and GetSafeModule(templates, "Towers")
    local settings = type(towers) == "table" and towers.GlobalSettings or nil
    if type(settings) ~= "table" then return 0 end
    local base = tonumber(settings.MaxTotalTowers) or 0
    if RS:GetAttribute("EndlessMatch") ~= true then return base end
    local grown = base + math.floor(math.max(GetWave(), 0) / 5)
    return math.min(grown, math.max(base, 45))
end
local function GetPlacedFolder()
    local mapName = RS:GetAttribute("SelectedMap")
    local map = mapName and workspace:FindFirstChild(mapName)
    return (map and map:FindFirstChild("PlacedTowers")) or workspace:FindFirstChild("PlacedTowers")
end
local function GetOwnTowers()
    local folder = GetPlacedFolder()
    local list = {}
    if not folder then return list end
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("OwnerUserId") == Plr.UserId then
            table.insert(list, model)
        end
    end
    return list
end
local function GetTowerLevel(model)
    local cfg = model:FindFirstChild("TowerConfig")
    local lvl = cfg and cfg:GetAttribute("Level")
    return tonumber(lvl) or 0
end
local function GetCurrentMapName()
    local name = RS:GetAttribute("SelectedMap")
    if type(name) == "string" and name ~= "" then
        return name
    end
    return nil
end
local function CountOwnedByName(name)
    local count = 0
    for _, model in ipairs(GetOwnTowers()) do
        if model.Name == name then
            count = count + 1
        end
    end
    return count
end
local function GetPlacementMath()
    local folder = GetObject(RS, "InRoundCode")
    return folder and GetSafeModule(folder, "PlacementMath") or nil
end
local function GetPlacementArea()
    local utils = GetObject(Plr, "PlayerScripts.InRoundCode.Utilities")
    return utils and GetSafeModule(utils, "PlacementArea") or nil
end
local function FootprintRadiusFor(name)
    local folder = RS:FindFirstChild("PlayerTowers")
    local model = folder and folder:FindFirstChild(name)
    local math = GetPlacementMath()
    if model and model:IsA("Model") and math then
        local ok, size = pcall(function()
            local _, sz = model:GetBoundingBox()
            return sz
        end)
        if ok and typeof(size) == "Vector3" then
            return math.footprintRadius(size.X, size.Z)
        end
    end
    return 2
end
local function PlacedFootprints()
    local list = {}
    local math = GetPlacementMath()
    for _, model in ipairs(GetOwnTowers()) do
        local ok, pivot, size = pcall(function()
            local _, sz = model:GetBoundingBox()
            return model:GetPivot().Position, sz
        end)
        if ok and pivot then
            local radius = 2
            if typeof(size) == "Vector3" and math then
                radius = math.footprintRadius(size.X, size.Z)
            end
            table.insert(list, { position = pivot, radius = radius, model = model })
        end
    end
    return list
end
local function FindSpotNear(fpRadius, centerX, centerZ, maxDist)
    local area = GetPlacementArea()
    local math = GetPlacementMath()
    if not (area and math) then return nil end
    local layout = area.Get()
    if not layout then
        pcall(function()
            area.Start()
        end)
        return nil
    end
    local sampleRadius = math.spotSampleRadius(fpRadius)
    local placed = PlacedFootprints()
    local best = nil
    area.ForEachCellByDistance(layout, centerX, centerZ, maxDist or 200, function(_, x, z, groundY, clearance)
        if clearance < sampleRadius then
            return false
        end
        local pos = Vector3.new(x, groundY, z)
        if not math.hasClearance(pos, fpRadius, placed, math.SPACING_PADDING + 1) then
            return false
        end
        best = { x = x, y = groundY, z = z }
        return true
    end)
    return best
end
local function FindSpot(fpRadius)
    local area = GetPlacementArea()
    if not area then return nil end
    local layout = area.Get()
    if not layout then
        pcall(function()
            area.Start()
        end)
        return nil
    end
    local cx = layout.minX + (layout.cols - 1) * layout.cell / 2
    local cz = layout.minZ + (layout.rows - 1) * layout.cell / 2
    return FindSpotNear(fpRadius, cx, cz, 400)
end
local function EquippedSlots()
    local list = {}
    local slots = Plr:FindFirstChild("TowerSlots")
    if not slots then return list end
    for i = 1, 12 do
        local slot = slots:FindFirstChild(tostring(i))
        if not slot then
            if i > 6 then break end
        else
            local tower = slot:GetAttribute("Tower")
            if type(tower) == "string" and tower ~= "" and slot:GetAttribute("Unlocked") == true then
                table.insert(list, { slot = i, tower = tower, uid = slot:GetAttribute("TowerUid") })
            end
        end
    end
    return list
end
local function GroundYAt(x, z, fallbackY)
    local mapName = RS:GetAttribute("SelectedMap")
    local map = mapName and workspace:FindFirstChild(mapName)
    if map then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Include
        params.FilterDescendantsInstances = { map }
        local result = workspace:Raycast(Vector3.new(x, (fallbackY or 0) + 60, z), Vector3.new(0, -200, 0), params)
        if result then
            local placed = GetPlacedFolder()
            if not (placed and result.Instance and result.Instance:IsDescendantOf(placed)) then
                return result.Position.Y
            end
        end
    end
    return fallbackY
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
    local data = LoadJSON(Shared.MDir .. "/" .. name .. ".json")
    if not data then return nil end
    local entries = {}
    local i = 1
    while data[tostring(i)] do
        entries[i] = data[tostring(i)]
        i = i + 1
    end
    return { entries = entries }
end
local function SaveMacro(name, macro)
    if not name or name == "" or not writefile then return false end
    LoadMDir()
    local out = {}
    for i, entry in ipairs(macro.entries) do
        out[tostring(i)] = entry
    end
    return SaveJSON(Shared.MDir .. "/" .. name .. ".json", out)
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
        for slot, spots in pairs(slots) do
            local spotOut = {}
            for i, spot in ipairs(spots) do
                spotOut[i] = { x = spot.x, y = spot.y, z = spot.z }
            end
            slotOut[tostring(slot)] = spotOut
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
            for slotStr, spots in pairs(slots) do
                local slot = tonumber(slotStr)
                if slot and type(spots) == "table" then
                    local list = {}
                    for i, spot in ipairs(spots) do
                        if type(spot) == "table" and tonumber(spot.x) and tonumber(spot.y) and tonumber(spot.z) then
                            list[i] = { x = tonumber(spot.x), y = tonumber(spot.y), z = tonumber(spot.z) }
                        end
                    end
                    loaded[mapName][slot] = list
                end
            end
        end
    end
    Shared.Place.SlotPositions = loaded
end
local function LoadoutSlotName(slot)
    for _, entry in ipairs(EquippedSlots()) do
        if entry.slot == slot then return entry.tower end
    end
    return nil
end
local function GetSlotDisplayNames()
    local slots = {}
    for _, entry in ipairs(EquippedSlots()) do
        table.insert(slots, { Slot = entry.slot, Name = entry.tower })
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
local function PosText(mapName)
    if not mapName or not Shared.Place.SlotPositions[mapName] then return "No positions set" end
    local lines = {}
    for slot, spots in pairs(Shared.Place.SlotPositions[mapName]) do
        local unitName = LoadoutSlotName(slot)
        table.insert(lines, "Slot " .. slot .. (unitName and (" (" .. unitName .. ")") or "") .. ": " .. #spots .. " pos")
    end
    if #lines == 0 then return "No positions set" end
    table.sort(lines)
    return table.concat(lines, "\n")
end
local function UpdatePosLabels()
    local mapName = GetCurrentMapName()
    SafeLabel("Positions", PosText(mapName))
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
    local pos = hrp.Position
    if not Shared.Place.SlotPositions[mapName] then Shared.Place.SlotPositions[mapName] = {} end
    if act == "set" then
        if not Shared.Place.SlotPositions[mapName][slot] then Shared.Place.SlotPositions[mapName][slot] = {} end
        table.insert(Shared.Place.SlotPositions[mapName][slot], { x = pos.X, y = pos.Y, z = pos.Z })
        local count = #Shared.Place.SlotPositions[mapName][slot]
        notyuri("SetPos slot=" .. slot .. " count=" .. count .. " map=" .. mapName)
    elseif act == "massset" then
        for i = 1, 6 do
            if not Shared.Place.SlotPositions[mapName][i] then Shared.Place.SlotPositions[mapName][i] = {} end
            table.insert(Shared.Place.SlotPositions[mapName][i], { x = pos.X, y = pos.Y, z = pos.Z })
        end
        notyuri("MassSetPos map=" .. mapName)
    end
    SavePositions()
    UpdatePosLabels()
end
local function MatchElapsed()
    if Shared.Memo.MatchStart <= 0 then return 0 end
    return os.clock() - Shared.Memo.MatchStart
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
    notyuri("MacroLabel", txt)
    SafeLabel("Macro", txt)
end
local function RecordAct(kind, data, wave, elapsed)
    if not Shared.MState.Cur then return end
    Shared.MState.Step = Shared.MState.Step + 1
    local entry = { Type = kind, Time = tostring(wave or 0) .. " " .. tostring(math.floor(elapsed or 0)) }
    for k, v in pairs(data or {}) do
        entry[k] = v
    end
    table.insert(Shared.MState.Cur.entries, entry)
    UpdateMacroLabel(kind, entry.Time)
end
local function ParseMacroTime(entry)
    local wStr, eStr = (entry.Time or ""):match("^(%d+)%s+(.+)$")
    return tonumber(wStr) or 0, tonumber(eStr) or 0
end
local function SortMacroEntries(entries)
    table.sort(entries, function(a, b)
        local wa = ParseMacroTime(a)
        local wb = ParseMacroTime(b)
        if wa ~= wb then return wa < wb end
        return ParseMacroTime(a) < ParseMacroTime(b)
    end)
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
local function TowerNearPos(tower, pos, radius)
    local part = tower.PrimaryPart or tower:FindFirstChildWhichIsA("BasePart")
    if not (part and pos) then return false end
    return (part.Position - pos).Magnitude <= (radius or 5)
end
local function ConfirmPlace(pend, inst)
    pend.Resolved = true
    local key = EnsureRecKey(inst)
    if not key then
        pend.Dropped = true
        return
    end
    pend.Key = key
    RecordAct("Place", { Key = key, Name = pend.Name, Pos = pend.Pos, Rot = pend.Rot, Slot = pend.Slot }, pend.Wave, pend.Elapsed)
end
local function ConfirmUpgrade(pend)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = Shared.MState.RecKeys[pend.Tower]
    end
    key = key or EnsureRecKey(pend.Tower)
    if not key then
        pend.Dropped = true
        return
    end
    pend.Key = key
    RecordAct("Upgrade", { Key = key, Name = pend.Name, LVL = pend.LVL, Pos = pend.Pos }, pend.Wave, pend.Elapsed)
end
local function ConfirmUpgradeAll(pend, result)
    pend.Resolved = true
    RecordAct("UpgradeAll", { Spent = result.spent, Count = result.count }, pend.Wave, pend.Elapsed)
end
local function ConfirmSell(pend)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = Shared.MState.RecKeys[pend.Tower]
        Shared.MState.RecKeys[pend.Tower] = nil
    end
    pend.Key = key
    RecordAct("Sell", { Key = key, Name = pend.Name }, pend.Wave, pend.Elapsed)
end
local function ConfirmMode(pend)
    pend.Resolved = true
    local key = nil
    if typeof(pend.Tower) == "Instance" then
        key = Shared.MState.RecKeys[pend.Tower] or EnsureRecKey(pend.Tower)
    end
    pend.Key = key
    RecordAct("Mode", { Key = key, Name = pend.Name, Mode = pend.Mode }, pend.Wave, pend.Elapsed)
end
local MacroRemoteKinds = {
    PlaceTower = "Place",
    UpgradeTower = "Upgrade",
    UpgradeAllTowers = "UpgradeAll",
    SellTower = "Sell",
    SetTowerTarget = "Mode",
}
local OrigRemotes = {}
local NCSeen = {}
local function ResolveOrigRemotes()
    local ok, err = pcall(function()
        local origRS = game:GetService("ReplicatedStorage")
        local folder = origRS:FindFirstChild("FrameworkEvents")
        if not folder then return end
        for name in pairs(MacroRemoteKinds) do
            local remote = folder:FindFirstChild(name)
            if remote and not OrigRemotes[name] then
                OrigRemotes[name] = remote
            end
        end
    end)
    if not ok then
        notyuri("orig remote resolve error:", tostring(err))
    end
end
local function GetMacroRemoteKind(self)
    if OrigRemotes.PlaceTower and rawequal(self, OrigRemotes.PlaceTower) then return "Place" end
    if OrigRemotes.UpgradeTower and rawequal(self, OrigRemotes.UpgradeTower) then return "Upgrade" end
    if OrigRemotes.UpgradeAllTowers and rawequal(self, OrigRemotes.UpgradeAllTowers) then return "UpgradeAll" end
    if OrigRemotes.SellTower and rawequal(self, OrigRemotes.SellTower) then return "Sell" end
    if OrigRemotes.SetTowerTarget and rawequal(self, OrigRemotes.SetTowerTarget) then return "Mode" end
    if Remotes.PlaceTower and rawequal(self, Remotes.PlaceTower) then return "Place" end
    if Remotes.UpgradeTower and rawequal(self, Remotes.UpgradeTower) then return "Upgrade" end
    if Remotes.UpgradeAllTowers and rawequal(self, Remotes.UpgradeAllTowers) then return "UpgradeAll" end
    if Remotes.SellTower and rawequal(self, Remotes.SellTower) then return "Sell" end
    if Remotes.SetTowerTarget and rawequal(self, Remotes.SetTowerTarget) then return "Mode" end
    return nil
end
local function SnapshotCall(nargs, kind)
    if not (Shared.MState.Rec and Shared.MState.Cur) then return nil end
    local payload = nargs[2]
    local wave = GetWave()
    local elapsed = MatchElapsed()
    local pend
    if kind == "Place" then
        if type(payload) ~= "table" or type(payload.towerKey) ~= "string" then return nil end
        pend = {
            Kind = "Place",
            Name = payload.towerKey,
            Slot = payload.slotIndex,
            Pos = { payload.x, payload.y, payload.z },
            Rot = payload.rotationY or 0,
            Position = Vector3.new(payload.x or 0, payload.y or 0, payload.z or 0),
        }
    elseif kind == "Upgrade" then
        local tower = type(payload) == "table" and payload.tower
        if typeof(tower) ~= "Instance" then return nil end
        pend = { Kind = "Upgrade", Tower = tower, Name = tower.Name, LVL = GetTowerLevel(tower) }
        local part = tower.PrimaryPart or tower:FindFirstChildWhichIsA("BasePart")
        if part then
            pend.Position = part.Position
            pend.Pos = { part.Position.X, part.Position.Y, part.Position.Z }
        end
    elseif kind == "UpgradeAll" then
        pend = { Kind = "UpgradeAll" }
    elseif kind == "Sell" then
        local tower = type(payload) == "table" and payload.tower
        if typeof(tower) ~= "Instance" then return nil end
        pend = { Kind = "Sell", Tower = tower, Name = tower.Name }
        local part = tower.PrimaryPart or tower:FindFirstChildWhichIsA("BasePart")
        if part then
            pend.Position = part.Position
        end
    elseif kind == "Mode" then
        local tower = type(payload) == "table" and payload.tower
        if typeof(tower) ~= "Instance" then return nil end
        pend = { Kind = "Mode", Tower = tower, Name = tower.Name, Mode = payload.mode }
        local part = tower.PrimaryPart or tower:FindFirstChildWhichIsA("BasePart")
        if part then
            pend.Position = part.Position
        end
    else
        return nil
    end
    pend.Wave = wave
    pend.Elapsed = elapsed
    pend.At = os.clock()
    pend.Resolved = false
    table.insert(Shared.MState.Pending, pend)
    return pend
end
local function ResolveCall(pend, ret)
    if not (pend and not pend.Resolved) then return end
    local result = (ret and ret.n and ret.n > 0) and ret[1] or nil
    if type(result) ~= "table" then return end
    if result.success then
        if pend.Kind == "Place" then
            pend.AwaitInstance = true
        elseif pend.Kind == "Upgrade" then
            ConfirmUpgrade(pend)
        elseif pend.Kind == "UpgradeAll" then
            ConfirmUpgradeAll(pend, result)
        elseif pend.Kind == "Sell" then
            ConfirmSell(pend)
        elseif pend.Kind == "Mode" then
            ConfirmMode(pend)
        end
    else
        pend.Resolved = true
        pend.Dropped = true
    end
end
local function FindUnkeyedOwnedTower(predFn)
    for _, tower in ipairs(GetOwnTowers()) do
        if not Shared.MState.RecKeys[tower] and predFn(tower) then
            return tower
        end
    end
    return nil
end
local function ProcessPendingSweep()
    local now = os.clock()
    for _, pend in ipairs(Shared.MState.Pending) do
        if not pend.Resolved then
            local age = now - pend.At
            if age > Shared.MacroTimings.PendingExpiry then
                pend.Resolved = true
                pend.Dropped = true
            elseif pend.Kind == "Place" and pend.AwaitInstance then
                local inst = FindUnkeyedOwnedTower(function(t)
                    return t.Name == pend.Name and TowerNearPos(t, pend.Position, 6)
                end)
                if inst then
                    ConfirmPlace(pend, inst)
                end
            elseif age > Shared.MacroTimings.PendingLateResolve then
                if pend.Kind == "Upgrade" then
                    local inst = FindUnkeyedOwnedTower(function(t)
                        return t.Name == pend.Name and TowerNearPos(t, pend.Position, 6)
                    end)
                    if inst then
                        pend.Tower = inst
                        ConfirmUpgrade(pend)
                    end
                elseif pend.Kind == "Sell" then
                    local old = pend.Tower
                    if typeof(old) ~= "Instance" or old.Parent == nil then
                        ConfirmSell(pend)
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
            notyuri("sweep error:", tostring(err))
        end
        task.wait()
    end
    for _ = 1, 3 do
        if Shared.MState.Rec or not Shared.MState.Cur then break end
        pcall(ProcessPendingSweep)
        task.wait()
    end
end
local function InstallMacroHook()
    if Shared.MState.Hooked then return end
    if not (Support.HookMeta or Support.HookFunction) then
        Library:Notify("Macro record requires hookmetamethod/hookfunction support", 4)
        return
    end
    ResolveOrigRemotes()
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
                if not kind or not Shared.MState.Rec or Shared.MState.SelfThreads[coroutine.running() or false] then
                    return originalNamecall(...)
                end
                local thread = coroutine.running() or false
                NCSeen[thread] = true
                local args = table.pack(...)
                local ret = table.pack(originalNamecall(table.unpack(args, 1, args.n)))
                NCSeen[thread] = nil
                local ok2, snap = pcall(SnapshotCall, args, kind)
                if ok2 and snap then
                    local ok3, err2 = pcall(ResolveCall, snap, ret)
                    if not ok3 then
                        notyuri("resolve error:", tostring(err2))
                    end
                end
                return table.unpack(ret, 1, ret.n)
            end))
        end)
        if ok then
            installedNamecall = true
            notyuri("__namecall hook installed (primary; original invoked before capture)")
        else
            notyuri("__namecall hook failed:", tostring(err))
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
                if NCSeen[coroutine.running() or false] then
                    return originalInvokeServer(...)
                end
                local self = ...
                local kind = GetMacroRemoteKind(self)
                if not kind or not Shared.MState.Rec or Shared.MState.SelfThreads[coroutine.running() or false] then
                    return originalInvokeServer(...)
                end
                local args = table.pack(...)
                local ret = table.pack(originalInvokeServer(table.unpack(args, 1, args.n)))
                local ok2, snap = pcall(SnapshotCall, args, kind)
                if ok2 and snap then
                    local ok3, err2 = pcall(ResolveCall, snap, ret)
                    if not ok3 then
                        notyuri("resolve error:", tostring(err2))
                    end
                end
                return table.unpack(ret, 1, ret.n)
            end))
        end)
        if ok then
            installedHookFn = true
            notyuri("InvokeServer hookfunction installed (secondary; deduped by namecall marker)")
        else
            notyuri("hookfunction failed:", tostring(err))
        end
    end
    if not (installedNamecall or installedHookFn) then
        Library:Notify("Macro record: failed to install any hook", 4)
        return
    end
    Shared.MState.Hooked = true
    local refCount = 0
    for _ in pairs(OrigRemotes) do
        refCount = refCount + 1
    end
    notyuri("hook active; orig remote refs resolved:", tostring(refCount))
end
local function Func_MacroRecord(state)
    if not state then return end
    if Toggles.LoadMacro and Toggles.LoadMacro.Value then
        Toggles.LoadMacro:SetValue(false)
    end
    InstallMacroHook()
    Shared.MState.Cur = { entries = {} }
    Shared.MState.Step = 0
    Shared.MState.NextKey = 0
    Shared.MState.RecKeys = {}
    Shared.MState.Saved = false
    Shared.MState.Pending = {}
    Shared.MState.Adopted = {}
    UpdateMacroLabel("Waiting")
    while Toggles.MacroRecord.Value and not RoundLive() do
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
    while Toggles.MacroRecord.Value and RoundLive() do
        task.wait()
    end
    Shared.MState.Rec = false
    task.wait(0.1)
    pcall(ProcessPendingSweep)
    local entries = Shared.MState.Cur and #Shared.MState.Cur.entries or 0
    if entries > 0 and not Shared.MState.Saved then
        Shared.MState.Saved = true
        SortMacroEntries(Shared.MState.Cur.entries)
        local recorded = Shared.MState.Cur
        local fname = (Options.FileName and Options.FileName.Value) or ""
        if fname == "" then
            fname = "Macro_" .. os.date("%Y%m%d_%H%M%S")
        end
        task.spawn(function()
            if SaveMacro(fname, recorded) then
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
    UpdateMacroLabel("Stopped (" .. tostring(entries) .. ")")
end
local function MatchTowerAt(name, pos, radius)
    local best, bestDist = nil, radius or 6
    for _, tower in ipairs(GetOwnTowers()) do
        local part = tower.PrimaryPart or tower:FindFirstChildWhichIsA("BasePart")
        if part and tower.Name == name then
            local dist = (part.Position - pos).Magnitude
            if dist < bestDist then
                best, bestDist = tower, dist
            end
        end
    end
    return best
end
local function FindTowerForEntry(entry)
    local t = entry.Key and Shared.MState.RepMap[entry.Key]
    if t and t.Parent then
        return t
    end
    local pos = entry.Pos
    if type(pos) ~= "table" or #pos ~= 3 then return nil end
    local target = Vector3.new(pos[1], pos[2], pos[3])
    if type(entry.Name) ~= "string" or entry.Name == "" then return nil end
    local best = MatchTowerAt(entry.Name, target, 7)
    if best and entry.Key then
        Shared.MState.RepMap[entry.Key] = best
    end
    return best
end
local function ResolveTowerRetry(entry)
    local tower = FindTowerForEntry(entry)
    if tower and tower.Parent then return tower end
    local start = os.clock()
    while os.clock() - start < 1 do
        task.wait()
        tower = FindTowerForEntry(entry)
        if tower and tower.Parent then return tower end
    end
    return nil
end
local function MacroEntryCost(entry)
    if entry.Type == "UpgradeAll" then
        return tonumber(entry.Spent) or nil
    end
    local cfg = GetTowerCfg(entry.Name)
    if not cfg then return nil end
    if entry.Type == "Place" then
        return tonumber(cfg.Cost) or nil
    elseif entry.Type == "Upgrade" then
        if type(entry.LVL) == "number" and type(cfg.Upgrades) == "table" then
            local tier = cfg.Upgrades[entry.LVL]
            if type(tier) == "table" then
                return tonumber(tier.Cost) or nil
            end
        end
    end
    return nil
end
local function SlotForTower(name)
    for _, entry in ipairs(EquippedSlots()) do
        if entry.tower == name then
            return entry.slot
        end
    end
    return nil
end
local function WaitForCash(amount, timeout)
    if not amount or amount <= 0 then return true end
    if GetCash() >= amount then return true end
    local start = tick()
    local hasTimeout = timeout and timeout > 0
    while Toggles.LoadMacro.Value and GetCash() < amount do
        if hasTimeout and (tick() - start) >= timeout then
            break
        end
        task.wait()
    end
    return Toggles.LoadMacro.Value and GetCash() >= amount
end
local function InvokePlace(name, slotIndex, spot, rotationY)
    local result = Invoke("PlaceTower", {
        towerKey = name,
        slotIndex = slotIndex,
        x = spot.x,
        y = spot.y,
        z = spot.z,
        rotationY = rotationY or 0,
    })
    if type(result) == "table" and result.success then
        return true, result
    end
    return false, result
end
local function InvokeUpgrade(model)
    local result = Invoke("UpgradeTower", { tower = model })
    if type(result) == "table" and result.success then
        return true, result
    end
    return false, result
end
local function InvokeUpgradeAll()
    local result = Invoke("UpgradeAllTowers", {})
    if type(result) == "table" and result.success then
        return true, result
    end
    return false, result
end
local function InvokeSell(model)
    local result = Invoke("SellTower", { tower = model })
    if type(result) == "table" and result.success then
        return true, result
    end
    return false, result
end
local function InvokeSetTarget(model, mode)
    local result = Invoke("SetTowerTarget", { tower = model, mode = mode })
    if type(result) == "table" and result.success then
        return true, result
    end
    return false, result
end
local function DoMacroAction(entry)
    if entry.Type == "Place" then
        local pos = entry.Pos
        if type(pos) ~= "table" or #pos ~= 3 then return end
        local slot = SlotForTower(entry.Name)
        if not slot then
            notyuri("Place SKIP: not equipped:", tostring(entry.Name))
            return
        end
        local placed = false
        for attempt = 1, Shared.MacroTimings.MaxAttempts do
            if not Toggles.LoadMacro.Value then return end
            local spot = { x = pos[1], y = pos[2], z = pos[3] }
            if attempt > 1 then
                local alt = FindSpotNear(FootprintRadiusFor(entry.Name), pos[1], pos[3], 30)
                if alt then
                    spot = alt
                end
            end
            local ok = InvokePlace(entry.Name, slot, spot, entry.Rot or 0)
            if ok then
                placed = true
                break
            end
            local cost = MacroEntryCost(entry)
            if not WaitForCash(cost, 5) then break end
        end
        if placed and entry.Key then
            local start = os.clock()
            local target = Vector3.new(pos[1], pos[2], pos[3])
            while os.clock() - start < 1.5 do
                local inst = MatchTowerAt(entry.Name, target, 7)
                if inst then
                    Shared.MState.RepMap[entry.Key] = inst
                    break
                end
                task.wait()
            end
        end
    elseif entry.Type == "Upgrade" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then
            notyuri("Upgrade SKIP: no tower for key", tostring(entry.Key))
            return
        end
        if type(entry.LVL) == "number" and GetTowerLevel(tower) >= entry.LVL then
            return
        end
        for _ = 1, Shared.MacroTimings.MaxAttempts do
            if not Toggles.LoadMacro.Value then return end
            if InvokeUpgrade(tower) then return end
            local cost = MacroEntryCost(entry)
            if not WaitForCash(cost, 5) then return end
        end
    elseif entry.Type == "UpgradeAll" then
        for _ = 1, Shared.MacroTimings.MaxAttempts do
            if not Toggles.LoadMacro.Value then return end
            local ok, result = InvokeUpgradeAll()
            if ok then return end
            if type(result) ~= "table" or result.reason ~= "NotEnoughCoins" then return end
            if not WaitForCash(GetCash() + (tonumber(result.needed) or 0), 5) then return end
        end
    elseif entry.Type == "Sell" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then
            notyuri("Sell SKIP: no tower for key", tostring(entry.Key))
            return
        end
        if InvokeSell(tower) and entry.Key then
            Shared.MState.RepMap[entry.Key] = nil
        end
    elseif entry.Type == "Mode" then
        local tower = ResolveTowerRetry(entry)
        if not (tower and tower.Parent) then return end
        InvokeSetTarget(tower, entry.Mode or "First")
    end
end
local function Func_MacroReplay()
    while Toggles.LoadMacro.Value do
        local macro = Shared.MState.Load
        if not (macro and macro.entries and #macro.entries > 0) then
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
        while Toggles.LoadMacro.Value and not RoundLive() do
            task.wait()
        end
        if not Toggles.LoadMacro.Value then break end
        for i, entry in ipairs(macro.entries) do
            if not Toggles.LoadMacro.Value then break end
            if not RoundLive() then
                notyuri("match ended mid-pass")
                break
            end
            Shared.MState.Step = i
            UpdateMacroLabel(entry.Type, entry.Time, macro.entries[i + 1])
            local replayMode = Options.ReplayMode and Options.ReplayMode.Value or "Money"
            local skipStep = false
            if replayMode == "Money" then
                local cost = MacroEntryCost(entry)
                if cost and cost > 0 and not WaitForCash(cost) then
                    notyuri("money wait aborted (toggle off)")
                end
            else
                local tWave = ParseMacroTime(entry)
                while Toggles.LoadMacro.Value and GetWave() < tWave do
                    if not RoundLive() then break end
                    task.wait()
                end
                if GetWave() > tWave + 10 then
                    skipStep = true
                end
            end
            if not Toggles.LoadMacro.Value then break end
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
            while Toggles.LoadMacro.Value and RoundLive() do
                task.wait()
            end
            while Toggles.LoadMacro.Value and not RoundLive() do
                task.wait()
            end
        end
    end
    Shared.MState.Rep = false
    UpdateMacroLabel()
end
local function GetSelectedTowerSlots()
    local list = {}
    for _, entry in ipairs(EquippedSlots()) do
        table.insert(list, { name = entry.tower, slot = entry.slot })
    end
    table.sort(list, function(a, b)
        local sa = GetSlotOption("PlaceOrder", a.slot, a.slot) or 99
        local sb = GetSlotOption("PlaceOrder", b.slot, b.slot) or 99
        if sa ~= sb then
            return sa < sb
        end
        return a.name < b.name
    end)
    return list
end
local function PickSavedSpot(slot)
    local mapName = GetCurrentMapName()
    local saved = mapName and Shared.Place.SlotPositions[mapName] and Shared.Place.SlotPositions[mapName][slot]
    if not (saved and #saved > 0) then
        return nil
    end
    local pick = saved[math.random(1, #saved)]
    return { x = pick.x, y = GroundYAt(pick.x, pick.z, pick.y), z = pick.z, rot = 0 }
end
local function TryPlaceTower(name, slot)
    local cfg = GetTowerCfg(name)
    if type(cfg) ~= "table" then return false, nil end
    local price = tonumber(cfg.Cost) or 0
    if price > 0 and GetCash() < price then return false, nil end
    local pause = Shared.Place.PauseUntil[name] or 0
    if os.clock() < pause then return false, nil end
    if slot then
        local placeWave = GetSlotOption("PlaceWave", slot, 0)
        if placeWave > 0 and GetWave() < placeWave then return false, nil end
        local slotLimit = GetSlotOption("PlaceLimit", slot, 0)
        if slotLimit > 0 and CountOwnedByName(name) >= slotLimit then return false, nil end
    end
    local typeCap = TowerCap(cfg)
    if typeCap > 0 and CountOwnedByName(name) >= typeCap then return false, nil end
    local cap = BoardCap()
    if cap > 0 and #GetOwnTowers() >= cap then return false, nil end
    local spot = PickSavedSpot(slot) or FindSpot(FootprintRadiusFor(name))
    if not spot then return false, nil end
    if InvokePlace(name, slot, spot, spot.rot or 0) then
        Shared.Place.TypeFails[name] = 0
        return true, spot
    end
    Shared.Place.TypeFails[name] = (Shared.Place.TypeFails[name] or 0) + 1
    if Shared.Place.TypeFails[name] >= 3 then
        Shared.Place.PauseUntil[name] = os.clock() + 10
        Shared.Place.TypeFails[name] = 0
        notyuri("3 rejects for", name, "- pausing 10s")
    end
    return false, nil
end
local function TryUpgradeOnce(tower)
    local cfg = GetTowerCfg(tower.Name)
    if type(cfg) ~= "table" then return false end
    local level = GetTowerLevel(tower)
    if level >= MaxLevelOf(cfg) then return false end
    local tier = type(cfg.Upgrades) == "table" and cfg.Upgrades[level + 1] or nil
    local price = tier and tonumber(tier.Cost) or nil
    if not (price and GetCash() >= price) then return false end
    return InvokeUpgrade(tower)
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local ok, err = pcall(function()
            if not (Remotes.PlaceTower and BoardLive()) then return end
            local cap = BoardCap()
            if cap > 0 and #GetOwnTowers() >= cap then return end
            for _, entry in ipairs(GetSelectedTowerSlots()) do
                if not (Toggles.AutoPlace.Value and not (cap > 0 and #GetOwnTowers() >= cap)) then return end
                local placed, spot = TryPlaceTower(entry.name, entry.slot)
                if placed then
                    notyuri("Placed", entry.name, "slot", tostring(entry.slot))
                    if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value and spot then
                        local tower = MatchTowerAt(entry.name, Vector3.new(spot.x, spot.y, spot.z), 9)
                        if tower then
                            local upgLimit = entry.slot and GetSlotOption("UpgradeLimit", entry.slot, 0) or 0
                            for _ = 1, 20 do
                                if not Toggles.PlaceAndUpgrade.Value then break end
                                if upgLimit > 0 and GetTowerLevel(tower) >= upgLimit then break end
                                if not TryUpgradeOnce(tower) then break end
                                task.wait()
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
        if not ok then
            notyuri("AutoPlace error:", tostring(err))
        end
        task.wait()
    end
end
local function SlotByTowerName()
    local map = {}
    for _, entry in ipairs(EquippedSlots()) do
        if map[entry.tower] == nil then
            map[entry.tower] = entry.slot
        end
    end
    return map
end
local function GetUpgradableTowers()
    local slotByName = SlotByTowerName()
    local result = {}
    for _, model in ipairs(GetOwnTowers()) do
        local slot = slotByName[model.Name]
        local upgLimit = slot and GetSlotOption("UpgradeLimit", slot, 0) or 0
        local level = GetTowerLevel(model)
        if upgLimit <= 0 or level < upgLimit then
            local cfg = GetTowerCfg(model.Name)
            if type(cfg) == "table" and type(cfg.Upgrades) == "table" and level < MaxLevelOf(cfg) then
                local tier = cfg.Upgrades[level + 1]
                local price = tier and tonumber(tier.Cost) or nil
                if price then
                    table.insert(result, { model = model, slot = slot, level = level, towerName = model.Name, price = price })
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
            if not (Remotes.UpgradeTower and BoardLive()) then return end
            local units = GetUpgradableTowers()
            local target = UpgradeCand(units)
            if not target then return end
            if GetCash() < target.price then return end
            if InvokeUpgrade(target.model) then
                notyuri("Upgraded", target.towerName, "slot", tostring(target.slot))
            end
        end)
        if not ok then
            notyuri("AutoUpgrade error:", tostring(err))
        end
        task.wait()
    end
end
local function Func_AutoAtWave(toggle, thresholdOption, action)
    local firedForWave = nil
    while toggle.Value do
        local threshold = tonumber(thresholdOption and thresholdOption.Value) or 0
        local wave = GetWave()
        if wave >= threshold then
            if action == "sell" then
                for _, tower in ipairs(GetOwnTowers()) do
                    if tower and tower.Parent then
                        InvokeSell(tower)
                    end
                end
            elseif action == "leave" then
                if firedForWave ~= wave and Remotes.RequestReturnToLobby then
                    firedForWave = wave
                    Fire("RequestReturnToLobby")
                    notyuri("AutoLeave", "leave sent", "wave", tostring(wave))
                end
            end
        end
        task.wait(1)
    end
end
local function ApplyGameSpeed()
    if not (Remotes.RequestGameSpeed and RoundLive()) then return end
    local n = tonumber(Options.SpeedTarget and Options.SpeedTarget.Value) or 2
    Fire("RequestGameSpeed", n)
end
local function Func_AutoSpeed()
    while Toggles.AutoSpeed.Value do
        local ok, err = pcall(ApplyGameSpeed)
        if not ok then
            notyuri("AutoSpeed error:", tostring(err))
        end
        task.wait(2)
    end
end
local function SyncAutoSkip(want)
    local settings = Plr:FindFirstChild("PlayerSettings")
    if not settings or (settings:GetAttribute("AutoSkip") == true) == want then return end
    local easyEvents = GetSafeModule(GetObject(RS, "ReplicatedFramework.Utilities"), "EasyEvents")
    if easyEvents then
        easyEvents:InvokeServer("TogglePlayerSetting", "AutoSkip")
    end
end
local function Func_AutoSkip()
    while Toggles.AutoSkip.Value do
        local ok, err = pcall(SyncAutoSkip, true)
        if not ok then
            notyuri("AutoSkip error:", tostring(err))
        end
        task.wait(1)
    end
end
local function Func_AutoStart()
    while Toggles.AutoStart.Value do
        local ok, err = pcall(function()
            local voteId = tonumber(RS:GetAttribute("ModalVoteId")) or 0
            if voteId <= 0 then return end
            if Shared.Memo.Voted[voteId] then return end
            Shared.Memo.Voted[voteId] = true
            Fire("ModalVote", voteId, true)
        end)
        if not ok then
            notyuri("AutoStart error:", tostring(err))
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
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2022/08/15/23/52/23/100515820_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2025/07/22/17/09/45/132989170_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2019/12/01/21/59/30/78092730_p0_master1200.jpg",
}
local function SendWebhook(title, description)
    if not Support.Webhook then return end
    local url = Options.WebhookURL and Options.WebhookURL.Value or ""
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
local function WaitForMatchRewards(timeout)
    local start = tick()
    while not Shared.Memo.MatchRewards and (tick() - start) < timeout do
        task.wait(0.1)
    end
    return Shared.Memo.MatchRewards or {}
end
do
    task.spawn(function()
        SafeConnect("WHRewards", function()
            local easyEvents = GetSafeModule(GetObject(RS, "ReplicatedFramework.Utilities"), "EasyEvents")
            return easyEvents:GetEvent("MatchRewardsGranted").OnClientEvent
        end, function(rewards)
            if type(rewards) == "table" then
                Shared.Memo.MatchRewards = rewards
            end
        end)
    end)
    SafeConnect("AutoEnd", function()
        return RS:GetAttributeChangedSignal("RoundPhase")
    end, function()
        if not (Toggles.AutoEnd and Toggles.AutoEnd.Value) then return end
        local mode = Options.OnEnd and Options.OnEnd.Value or "Replay Level"
        task.wait(.1)
        if mode == "Return to Lobby" then
            Fire("RequestReturnToLobby")
        elseif mode == "Restart Match" then
            Fire("RequestRestartMatch")
        elseif mode == "Next Level" then
            Fire("RequestNextLevel")
        else
            Fire("RequestReplayLevel")
        end
    end)
    SafeConnect("RoundActive", function()
        return RS:GetAttributeChangedSignal("RoundActive")
    end, function()
        if RS:GetAttribute("RoundActive") == true then
            Shared.Memo.MatchStart = os.clock()
            Shared.Memo.Voted = {}
            Shared.Memo.WebhookSent = ""
            Shared.Memo.MatchRewards = false
        end
    end)
    SafeConnect("MatchIdReset", function()
        return RS:GetAttributeChangedSignal("MatchId")
    end, function()
        Shared.Memo.MatchStart = os.clock()
    end)
    SafeConnect("WHMatchEnd", function()
        return RS:GetAttributeChangedSignal("RoundPhase")
    end, function()
        local phase = GetPhase()
        if phase ~= "Complete" and phase ~= "Defeat" then return end
        if not (Toggles.WHMatchEnd and Toggles.WHMatchEnd.Value) then return end
        local matchId = RS:GetAttribute("MatchId") or ""
        if Shared.Memo.WebhookSent == matchId and matchId ~= "" then return end
        Shared.Memo.WebhookSent = matchId
        local result = (phase == "Complete" and "Victory") or "Defeat"
        local endless = RS:GetAttribute("EndlessMatch") == true
        local totalWaves = tonumber(RS:GetAttribute("TotalWaves")) or 0
        local waves = tonumber(RS:GetAttribute("WavesCleared")) or 0
        local hp = tonumber(RS:GetAttribute("BaseHealth")) or 0
        local hpMax = tonumber(RS:GetAttribute("BaseHealthMax")) or 0
        local map = RS:GetAttribute("SelectedMap") or "?"
        local level = tonumber(RS:GetAttribute("SelectedLevel")) or 0
        local duration = tonumber(RS:GetAttribute("MatchDuration")) or 0
        local rewards = WaitForMatchRewards(3)
        local itemsDictionary = GetSafeModule(GetObject(RS, "ReplicatedFramework.Templates"), "ItemsDictionary")
        local lines = {
            string.format("**Match Finished - %s**", result),
            "- Map: " .. map .. (endless and " (Endless)" or (" - Level " .. tostring(level))),
            "- Waves: " .. tostring(waves) .. "/" .. (endless and "-" or tostring(totalWaves)),
            "- Base: " .. tostring(math.floor(hp)) .. "/" .. tostring(math.floor(hpMax)),
            string.format("- Time: %d:%02d", math.floor(duration / 60), math.floor(duration % 60)),
            "- Player: ||" .. Plr.Name .. "||",
            "- Rewards:",
        }
        for _, reward in ipairs(rewards) do
            if type(reward) == "table" and reward.ItemName then
                local item = itemsDictionary and itemsDictionary[reward.ItemName]
                local displayName = item and item.DisplayName or tostring(reward.ItemName)
                table.insert(lines, string.format("+%d %s", math.round(tonumber(reward.Quantity) or 1), displayName))
            end
        end
        SendWebhook("Match Finished", table.concat(lines, "\n"))
    end)
end
local function GetMaps()
    local list = {}
    local maps = GetObject(RS, "ReplicatedFramework.Templates.Maps")
    if not maps then return list end
    local skip = { LevelCurve = true, Geometry = true, RosterTuning = true }
    for _, child in ipairs(maps:GetChildren()) do
        if child:IsA("ModuleScript") and not skip[child.Name] then
            table.insert(list, child.Name)
        end
    end
    table.sort(list)
    return list
end
local function LevelCountFor(mapName)
    local maps = GetObject(RS, "ReplicatedFramework.Templates.Maps")
    local curve = maps and GetSafeModule(maps, "LevelCurve")
    if type(curve) == "table" and type(curve.Curve) == "table" and type(curve.Curve.MaxWaves) == "table" then
        return #curve.Curve.MaxWaves
    end
    return 6
end
local function HighestUnlockedLevel(mapName)
    local stats = Plr:FindFirstChild("PlayerMapStats")
    local mapStats = stats and stats:FindFirstChild(mapName)
    local levelCount = LevelCountFor(mapName)
    local best = 1
    for i = 1, levelCount do
        local entry = mapStats and mapStats:FindFirstChild("Level_" .. tostring(i))
        if entry and entry:GetAttribute("Beaten") == true then
            best = math.min(i + 1, levelCount)
        end
    end
    return best
end
local function GetGemsBanners()
    local list = {}
    local templates = GetObject(RS, "ReplicatedFramework.Templates")
    local dict = templates and GetSafeModule(templates, "SummonDictionary")
    if type(dict) ~= "table" then return list end
    for key, banner in pairs(dict) do
        if type(banner) == "table" and type(banner.Cost) == "table" then
            for _, cost in ipairs(banner.Cost) do
                if type(cost) == "table" and cost.Currency == "Gems" and cost.CanBuy ~= false then
                    table.insert(list, { key = key, cost = tonumber(cost.Amount) or 0, amounts = cost.AvailableAmounts or { 1 } })
                    break
                end
            end
        end
    end
    table.sort(list, function(a, b)
        return a.cost < b.cost
    end)
    return list
end
local function DiceCount()
    local items = Plr:FindFirstChild("PlayerItems")
    local dice = items and items:FindFirstChild("TraitDice")
    if dice and dice:IsA("NumberValue") then
        return math.floor(dice.Value)
    end
    return 0
end
local function OwnedTowerFolders()
    local list = {}
    local folder = Plr:FindFirstChild("PlayerTowers")
    if not folder then return list end
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Folder") then
            table.insert(list, child)
        end
    end
    return list
end
local function TowerUidEntryMap()
    local map = {}
    for _, child in ipairs(OwnedTowerFolders()) do
        map[child.Name] = child
    end
    return map
end
local function EquippedUids()
    local map = {}
    for _, entry in ipairs(EquippedSlots()) do
        if type(entry.uid) == "string" and entry.uid ~= "" then
            map[entry.uid] = entry.tower
        end
    end
    return map
end
local function TraitTierOf(uidEntry)
    local templates = GetObject(RS, "ReplicatedFramework.Templates")
    local traits = templates and GetSafeModule(templates, "TowerTraits")
    if type(traits) ~= "table" or type(traits.Get) ~= "function" then return 0 end
    local trait = uidEntry and uidEntry:GetAttribute("Trait")
    if type(trait) ~= "string" or trait == "" then return 0 end
    local ok, data = pcall(function()
        return traits:Get(trait)
    end)
    if ok and type(data) == "table" then
        return tonumber(data.Tier) or 0
    end
    return 0
end
local function OpenPadWalls()
    local walls = {}
    for _, pad in ipairs(CS:GetTagged("GameJoinPad")) do
        local roundType = pad:GetAttribute("RoundType")
        if pad:IsDescendantOf(workspace) and (roundType == nil or roundType == "Normal") and pad:GetAttribute("HostUserId") == 0 then
            local wallModel = pad:FindFirstChild("Walls")
            if wallModel then
                for _, part in ipairs(wallModel:GetChildren()) do
                    if part:IsA("BasePart") then
                        table.insert(walls, part)
                    end
                end
            end
        end
    end
    return walls
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        local ok, err = pcall(function()
            if not Remotes.RequestPlay then return end
            local padId = Plr:GetAttribute("PartyPadId")
            local isHost = Plr:GetAttribute("IsPartyHost") == true
            if not (type(padId) == "string" and padId ~= "" and isHost) then
                local wall = GetNearest(OpenPadWalls())
                if not wall then
                    notyuri("no open game join pads found")
                    return
                end
                TPTo(wall)
                return
            end
            local map = Options.QueueMap and Options.QueueMap.Value or ""
            if map == "" then return end
            local levelPick = Options.QueueLevel and Options.QueueLevel.Value or "Highest Unlocked"
            local level
            if levelPick == "Highest Unlocked" then
                level = HighestUnlockedLevel(map)
            else
                level = tonumber(levelPick) or 1
            end
            notyuri("queue:", map, "level", tostring(level))
            Fire("RequestPlay", map, level)
            task.wait(.1)
            Fire("RequestStartGame")
        end)
        if not ok then
            notyuri("AutoJoin error:", tostring(err))
        end
        task.wait(.1)
    end
end
local function Func_AutoSummon()
    while Toggles.AutoSummon.Value do
        local ok, err = pcall(function()
            local bannerKey = Options.SummonBanner and Options.SummonBanner.Value or ""
            local key = bannerKey:match("^(%S+) %(") or bannerKey
            if key == "" then return end
            local banner = nil
            for _, entry in ipairs(GetGemsBanners()) do
                if entry.key == key then
                    banner = entry
                    break
                end
            end
            if not banner then return end
            local amount = tonumber(Options.SummonAmount and Options.SummonAmount.Value) or 1
            if not table.find(banner.amounts, amount) then
                amount = banner.amounts[1] or 1
            end
            local reserve = Options.SummonReserve and Options.SummonReserve.Value or 0
            if LeaderValue("Gems") - reserve < banner.cost * amount then return end
            Fire("RequestSummon", key, amount)
            task.wait()
        end)
        if not ok then
            notyuri("AutoSummon error:", tostring(err))
        end
        task.wait(0.1)
    end
end
local function Func_AutoFuse()
    while Toggles.AutoFuse.Value do
        local ok, err = pcall(function()
            local templates = GetObject(RS, "ReplicatedFramework.Templates")
            local stars = templates and GetSafeModule(templates, "TowerStars")
            if type(stars) ~= "table" then return end
            local uidMap = TowerUidEntryMap()
            local equipped = EquippedUids()
            local groups = {}
            for _, entry in ipairs(OwnedTowerFolders()) do
                local towerName = entry:GetAttribute("Tower")
                if type(towerName) == "string" and towerName ~= "" then
                    groups[towerName] = groups[towerName] or {}
                    table.insert(groups[towerName], entry)
                end
            end
            local maxStars = tonumber(stars.MaxStars) or 5
            for towerName, copies in pairs(groups) do
                local cfg = GetTowerCfg(towerName)
                if cfg then
                    local needed = 5
                    if type(stars.copiesFor) == "function" then
                        local ok, n = pcall(stars.copiesFor, stars, cfg)
                        needed = ok and tonumber(n) or 5
                    end
                    local best = nil
                    for _, copy in ipairs(copies) do
                        if not best then
                            best = copy
                        else
                            local bs = tonumber(best:GetAttribute("Stars")) or 0
                            local cs = tonumber(copy:GetAttribute("Stars")) or 0
                            local bl = tonumber(best:GetAttribute("Level")) or 0
                            local cl = tonumber(copy:GetAttribute("Level")) or 0
                            if cs > bs or (cs == bs and cl > bl) then
                                best = copy
                            end
                        end
                    end
                    local bestStars = best and (tonumber(best:GetAttribute("Stars")) or 0) or 0
                    if best and bestStars < maxStars then
                        local fodder = {}
                        for _, copy in ipairs(copies) do
                            if #fodder >= needed then break end
                            if copy ~= best then
                                local isEquipped = false
                                for uid, _ in pairs(equipped) do
                                    if uidMap[uid] == copy then
                                        isEquipped = true
                                        break
                                    end
                                end
                                if (tonumber(copy:GetAttribute("Stars")) or 0) == 0
                                    and copy:GetAttribute("Shiny") ~= true
                                    and copy:GetAttribute("Locked") ~= true
                                    and not isEquipped then
                                    table.insert(fodder, copy.Name)
                                end
                            end
                        end
                        if #fodder >= needed then
                            local result = Invoke("StarsFuseRequest", best.Name, fodder)
                            if type(result) == "table" and result.ok then
                                Library:Notify("Fused " .. towerName .. " +1 star", 4)
                            end
                            return
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoFuse error:", tostring(err))
        end
        task.wait()
    end
end
local function GetEquippedTowerNames()
    local names = {}
    for _, entry in ipairs(EquippedSlots()) do
        if not table.find(names, entry.tower) then
            table.insert(names, entry.tower)
        end
    end
    table.sort(names)
    return names
end
local mapKeys = GetMaps()
local levelValues = { "Highest Unlocked" }
local maxLevelCount = 1
for _, mapName in ipairs(mapKeys) do
    local count = LevelCountFor(mapName)
    if count > maxLevelCount then
        maxLevelCount = count
    end
end
for i = 1, maxLevelCount do
    table.insert(levelValues, tostring(i))
end
local banners = GetGemsBanners()
local bannerLabels = {}
for _, banner in ipairs(banners) do
    table.insert(bannerLabels, banner.key .. " (" .. tostring(banner.cost) .. " gems)")
end
local amountLabels = {}
for _, amount in ipairs((banners[1] and banners[1].amounts) or { 1 }) do
    table.insert(amountLabels, tostring(amount))
end
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
TB_Tabs.Autofarm.T1:AddToggle("AutoStart", { Text = "Auto Start", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEnd", { Text = "Auto End", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSpeed", { Text = "Auto Speed", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSkip", { Text = "Auto Skip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoLeave", { Text = "Auto Leave", Default = false })
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
SafeLabel(TB_Tabs.Autofarm.T2, "Macro", "Idle")
TB_Tabs.Autofarm.T3:AddToggle("AutoJoin", { Text = "Auto Join" })
TB_Tabs.Autofarm.T3:AddToggle("AutoSummon", { Text = "Auto Summon" })
TB_Tabs.Autofarm.T3:AddToggle("AutoFuse", { Text = "Auto Fuse" })
TB_Tabs.Autofarm2.T1:AddSlider("AutoLeaveValue", {
    Text = "Leave at Wave",
    Default = 10,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("SpeedTarget", {
    Text = "Speed Target",
    Values = { "1", "2", "3", "10" },
    Default = "2",
})
TB_Tabs.Autofarm2.T1:AddDropdown("OnEnd", {
    Text = "On End",
    Values = { "Replay Level", "Return to Lobby", "Restart Match", "Next Level" },
    Default = "Replay Level",
})
TB_Tabs.Autofarm2.T2:AddDropdown("QueueMap", {
    Text = "Map",
    Values = mapKeys,
    Default = mapKeys[1] or "",
    Searchable = true,
})
TB_Tabs.Autofarm2.T2:AddDropdown("QueueLevel", {
    Text = "Level",
    Values = levelValues,
    Default = "Highest Unlocked",
})
TB_Tabs.Autofarm2.T2:AddDivider()
TB_Tabs.Autofarm2.T2:AddDropdown("SummonBanner", {
    Text = "Banner",
    Values = bannerLabels,
    Default = bannerLabels[1] or "",
})
TB_Tabs.Autofarm2.T2:AddDropdown("SummonAmount", {
    Text = "Summon Amount",
    Values = amountLabels,
    Default = amountLabels[1] or "1",
})
TB_Tabs.Autofarm2.T2:AddSlider("SummonReserve", {
    Text = "Keep Gems Above",
    Default = 0,
    Min = 0,
    Max = 10000,
    Rounding = 0,
    Compact = true,
})
local function OnSummonBannerChanged()
    local label = Options.SummonBanner and Options.SummonBanner.Value or ""
    local key = label:match("^(%S+) %(")
    local banner = nil
    for _, entry in ipairs(GetGemsBanners()) do
        if entry.key == key then
            banner = entry
            break
        end
    end
    local labels = {}
    if banner then
        for _, amount in ipairs(banner.amounts) do
            table.insert(labels, tostring(amount))
        end
    end
    if #labels == 0 then
        table.insert(labels, "1")
    end
    if Options.SummonAmount then
        Options.SummonAmount:SetValues(labels)
        Options.SummonAmount:SetValue(labels[1])
    end
end
Options.SummonBanner:OnChanged(OnSummonBannerChanged)
LoadMDir()
LoadPositions()
Toggles.AutoPlace:OnChanged(function(state)
    Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), state)
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state)
end)
Toggles.AutoSell:OnChanged(function(state)
    AutoSell_S:SetVisible(AutoSell_T.Value)
    Thread("AutoSell", SafeLoop("AutoSell", function() Func_AutoAtWave(AutoSell_T, Options.AutoSellValue, "sell") end), state)
end)
Toggles.AutoLeave:OnChanged(function(state)
    Thread("AutoLeave", SafeLoop("AutoLeave", function() Func_AutoAtWave(Toggles.AutoLeave, Options.AutoLeaveValue, "leave") end), state)
end)
Toggles.AutoStart:OnChanged(function(state)
    if state then
        Shared.Memo.Voted = {}
    end
    Thread("AutoStart", SafeLoop("AutoStart", Func_AutoStart), state)
end)
Toggles.AutoSpeed:OnChanged(function(state)
    Thread("AutoSpeed", SafeLoop("AutoSpeed", Func_AutoSpeed), state)
end)
Toggles.AutoSkip:OnChanged(function(state)
    if not state then pcall(SyncAutoSkip, false) end
    Thread("AutoSkip", SafeLoop("AutoSkip", Func_AutoSkip), state)
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
Toggles.AutoJoin:OnChanged(function(state)
    Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), state)
end)
Toggles.AutoSummon:OnChanged(function(state)
    Thread("AutoSummon", SafeLoop("AutoSummon", Func_AutoSummon), state)
end)
Toggles.AutoFuse:OnChanged(function(state)
    Thread("AutoFuse", SafeLoop("AutoFuse", Func_AutoFuse), state)
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
task.spawn(function()
    while not Library.Unloaded do
        task.wait(10)
        fire_event(UIS.InputBegan)
    end
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
SaveManager:SetFolder("Yuri/SnackTD")
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
