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
Shared.Labels = Shared.Labels or {}
local CS = Services.CollectionService
local Periastron = {
    Me = nil,
    MeMT = nil,
    OrigFire = nil,
    Shared = nil,
    ContractConfig = nil,
    DifficultyUnlockConfig = nil,
    DifficultyFiredAt = 0,
    DifficultyWarned = nil,
    UnitUpgradeConfig = nil,
    UnitStats = nil,
    TargetPriority = nil,
    MapConfig = nil,
    CrateConfig = nil,
    Replica = nil,
    DataController = nil,
    Wave = 0,
    WaveStartedAt = 0,
    Speed = 1,
    Intermission = false,
    ReadyFiredWave = -1,
    MapKey = nil,
    Units = {},
    Deck = {},
    Cards = { Deck = {}, UsePending = {} },
    DeckLoaded = false,
    Place = {
        SlotPositions = {},
        TypeFails = {},
        PauseUntil = {},
        FailPos = {},
        InFlight = {},
    },
    Match = { Over = false, Won = false, Started = false, WebhookSent = false },
    Group = { JoinedAt = 0, LastChange = nil },
    QueueTicks = 0,
}
local MState = {
    Rec = false,
    Rep = false,
    Cur = nil,
    Load = nil,
    Step = 0,
    Total = 0,
    SelfFire = false,
    Hooked = false,
    Saved = false,
    Pend = { Place = {}, Upgrade = {}, Sell = {} },
}
local MDir = "Yuri/PeriastronTD/Macros"
local PosDir = "Yuri/PeriastronTD"
local PosPath = PosDir .. "/position.json"
local SLOT_COUNT = 6
local CARD_SLOTS = 10
local function RoundLive()
    return not Periastron.Match.Over
end
local function GetCash()
    local ls = Plr:FindFirstChild("leaderstats")
    local cash = ls and ls:FindFirstChild("Cash")
    return cash and cash.Value or 0
end
local function WaveElapsed()
    if Periastron.WaveStartedAt <= 0 then return 0 end
    return math.max(0, os.clock() - Periastron.WaveStartedAt)
end
local function BindMe()
    local shared = RS:FindFirstChild("Shared")
    if not shared then
        shared = RS:WaitForChild("Shared", 10)
    end
    if not shared then
        notyuri("[Periastron] Shared folder missing")
        return false
    end
    local ok, meMod = pcall(function()
        return require(shared:WaitForChild("Vendor", 10):WaitForChild("Me", 10))
    end)
    if ok and type(meMod) == "table" and type(meMod.new) == "function" then
        Periastron.Me = meMod.new()
    end
    if not Periastron.Me then
        notyuri("[Periastron] Me module failed")
        return false
    end
    local mt = getmetatable(Periastron.Me)
    if type(mt) == "table" and type(mt.Fire) == "function" then
        Periastron.MeMT = mt
        Periastron.OrigFire = mt.Fire
    end
    local okCfg, cfg = pcall(function()
        return require(shared:WaitForChild("Config", 10):WaitForChild("SharedConfig", 10))
    end)
    if okCfg and type(cfg) == "table" then
        Periastron.Shared = cfg
        Periastron.UnitUpgradeConfig = cfg.UnitUpgradeConfig
        Periastron.UnitStats = cfg.UnitStats
        Periastron.TargetPriority = cfg.TargetPriority
        Periastron.MapConfig = cfg.MapConfig
        Periastron.CrateConfig = cfg.CrateConfig
        Periastron.ContractConfig = cfg.ContractConfig
        Periastron.DifficultyUnlockConfig = cfg.DifficultyUnlockConfig
        Periastron.RoundCardConfig = cfg.RoundCardConfig
        Periastron.WeatherConfig = cfg.WeatherConfig
    end
    return true
end
local function FireGame(name, ...)
    local me = Periastron.Me
    if not me then return false end
    MState.SelfFire = true
    local ok, err
    if Periastron.OrigFire then
        ok, err = pcall(Periastron.OrigFire, me, name, ...)
    else
        ok, err = pcall(me.Fire, me, name, ...)
    end
    MState.SelfFire = false
    if not ok then
        notyuri("[Periastron] Fire", tostring(name), "FAILED:", tostring(err))
    end
    return ok
end
local function ListenGame(name, fn)
    local me = Periastron.Me
    if not me then return false end
    local ok, err = pcall(function()
        me:Listen(name, fn)
    end)
    if not ok then
        notyuri("[Periastron] Listen", tostring(name), "FAILED:", tostring(err))
    end
    return ok
end
local function GetReplicaData()
    local rep = Periastron.Replica
    if rep and type(rep.Data) == "table" then
        return rep.Data
    end
    return nil
end
local function BindReplica()
    local me = Periastron.Me
    if not (me and Periastron.DataController) then return end
    local dc = Periastron.DataController
    if type(dc.GetReplica) ~= "function" then return end
    local ok, rep = pcall(function()
        return dc:GetReplica()
    end)
    if ok and rep and type(rep) == "table" and type(rep.Data) == "table" then
        Periastron.Replica = rep
        notyuri("[Periastron] replica bound")
    else
        notyuri("[Periastron] replica not ready yet")
    end
end
local function FetchDataController()
    local me = Periastron.Me
    if not me then return end
    local dc
    pcall(function()
        dc = me:Get("DataController", false, false)
    end)
    if dc then
        Periastron.DataController = dc
        BindReplica()
        return
    end
    task.spawn(function()
        local deadline = os.clock() + 30
        while os.clock() < deadline and not Library.Unloaded do
            local got
            pcall(function()
                got = me:Get("DataController", false, true)
            end)
            if got then
                Periastron.DataController = got
                BindReplica()
                return
            end
            task.wait(1)
        end
        if not Periastron.DataController then
            notyuri("[Periastron] DataController never loaded (30s)")
        end
    end)
end
local function RefreshDeck()
    local data = GetReplicaData()
    if not data then return false end
    local equipped = data.EquippedUnits
    if type(equipped) ~= "table" then return false end
    local limit = SLOT_COUNT
    if type(data.CardLimit) == "number" then
        limit = math.min(SLOT_COUNT, math.max(1, math.floor(data.CardLimit)))
    end
    local deck = {}
    for i, name in ipairs(equipped) do
        if type(name) == "string" and i <= limit then
            deck[#deck + 1] = name
        end
    end
    if #deck == 0 then return false end
    local changed = not Periastron.DeckLoaded
    for i = 1, SLOT_COUNT do
        local nv = deck[i]
        if Periastron.Deck[i] ~= nv then
            Periastron.Deck[i] = nv
            changed = true
        end
    end
    Periastron.DeckLoaded = true
    return changed
end
local function GetSlotDisplayNames()
    local names = {}
    for i = 1, SLOT_COUNT do
        local name = Periastron.Deck[i]
        table.insert(names, "Slot " .. i .. " (" .. (name or "empty") .. ")")
    end
    return names
end
local function SlotDisplayToNumber(display)
    local n = tonumber(tostring(display):match("^Slot (%d+)"))
    return n
end
local function GetSlotOption(prefix, slot, fallback)
    local opt = Options[prefix .. slot]
    return (opt and tonumber(opt.Value)) or fallback
end
local function SlotByTowerName()
    local map = {}
    for slot, name in ipairs(Periastron.Deck) do
        if name ~= nil and map[name] == nil then
            map[name] = slot
        end
    end
    return map
end
local function GetSelectedTowerSlots()
    local list = {}
    local slotByName = SlotByTowerName()
    for name, slot in pairs(slotByName) do
        table.insert(list, { name = name, slot = slot })
    end
    table.sort(list, function(a, b)
        local sa = GetSlotOption("PlaceOrder", a.slot, a.slot)
        local sb = GetSlotOption("PlaceOrder", b.slot, b.slot)
        if sa ~= sb then
            return sa < sb end
        return a.name < b.name
    end)
    return list
end
local function GetPlaceCost(name)
    local cfg = Periastron.UnitUpgradeConfig
    if cfg and type(cfg.GetPlaceCost) == "function" then
        local ok, cost = pcall(cfg.GetPlaceCost, cfg, name, nil)
        if ok and type(cost) == "number" then
            return cost
        end
    end
    return 0
end
local function GetUpgradeCost(name, level)
    local cfg = Periastron.UnitUpgradeConfig
    if cfg and type(cfg.GetCost) == "function" then
        local ok, cost = pcall(cfg.GetCost, cfg, name, level or 0)
        if ok and type(cost) == "number" then
            return cost
        end
    end
    return 0
end
local function IsMaxedLevel(name, level)
    local cfg = Periastron.UnitUpgradeConfig
    if cfg and type(cfg.IsMaxed) == "function" then
        local ok, res = pcall(cfg.IsMaxed, cfg, name, level or 0)
        if ok then
            return res == true
        end
    end
    return (level or 0) >= 5
end
local function RegisterUnit(name, cframe, ownerUserId, unitId, upgrades)
    if type(unitId) ~= "string" then return end
    Periastron.Units[unitId] = {
        name = tostring(name),
        unitId = unitId,
        own = ownerUserId == Plr.UserId,
        upgrades = tonumber(upgrades) or 0,
        pos = (cframe and cframe.Position) or nil,
        model = nil,
    }
    task.spawn(function()
        for _ = 1, 12 do
            if Library.Unloaded then return end
            for _, m in ipairs(workspace:GetChildren()) do
                if m:IsA("Model") and m:GetAttribute("UnitID") == unitId then
                    local rec = Periastron.Units[unitId]
                    if rec then
                        rec.model = m
                        rec.pos = m:GetPivot().Position
                    end
                    return
                end
            end
            task.wait(0.25)
        end
    end)
end
local function CountOwnedByName(name)
    local n = 0
    for _, u in pairs(Periastron.Units) do
        if u.own and u.name == name then
            n = n + 1
        end
    end
    return n
end
local function GetOwnUnits()
    local list = {}
    for _, u in pairs(Periastron.Units) do
        if u.own then
            table.insert(list, u)
        end
    end
    return list
end
local function MatchTowerAt(name, pos, radius)
    local best, bestDist = nil, radius or 7
    for _, u in pairs(Periastron.Units) do
        if u.own and u.name == name and u.pos then
            local dist = (u.pos - pos).Magnitude
            if dist < bestDist then
                best, bestDist = u, dist
            end
        end
    end
    return best
end
local function GetCurrentMapName()
    local key = Periastron.MapKey
    if not key or key == "" then return nil end
    local cfg = Periastron.MapConfig
    if cfg and type(cfg.resolveMap) == "function" then
        local ok, resolved = pcall(cfg.resolveMap, cfg, key)
        if ok and type(resolved) == "string" and resolved ~= "" then
            return resolved
        end
    end
    return key
end
local function EnsureFolderPath(path)
    if not (makefolder and isfolder) then return end
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
local function SaveJSON(path, data)
    if not writefile then return false end
    return pcall(function()
        writefile(path, HttpService:JSONEncode(data))
    end)
end
local function LoadJSON(path)
    if not (readfile and isfile) then return nil end
    local ok, raw = pcall(function()
        if isfile(path) then
            return readfile(path)
        end
        return nil
    end)
    if not ok or type(raw) ~= "string" or raw == "" then return nil end
    local data = nil
    pcall(function()
        data = HttpService:JSONDecode(raw)
    end)
    if type(data) ~= "table" then return nil end
    return data
end
local function ListMacros()
    local names = {}
    local listf = listfiles or listfolder
    if not listf then return names end
    local ok, files = pcall(listf, MDir)
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
    local data = LoadJSON(MDir .. "/" .. name .. ".json")
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
    EnsureFolderPath(MDir)
    local out = {}
    for i, entry in ipairs(macro.entries) do
        out[tostring(i)] = entry
    end
    return SaveJSON(MDir .. "/" .. name .. ".json", out)
end
local function SavePositions()
    if not writefile then return false end
    EnsureFolderPath(PosDir)
    local out = {}
    for mapName, slots in pairs(Periastron.Place.SlotPositions) do
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
    return SaveJSON(PosPath, out)
end
local function LoadPositions()
    if not (readfile and isfile) then return end
    local data = LoadJSON(PosPath)
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
    Periastron.Place.SlotPositions = loaded
end
local function PosText(mapName)
    if not mapName or not Periastron.Place.SlotPositions[mapName] then return "No positions set" end
    local lines = {}
    for slot, spots in pairs(Periastron.Place.SlotPositions[mapName]) do
        local unitName = Periastron.Deck[slot]
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
            if Periastron.Place.SlotPositions[mapName] then Periastron.Place.SlotPositions[mapName][slot] = nil end
            notyuri("ResetPos slot=" .. slot .. " map=" .. mapName)
        else
            Periastron.Place.SlotPositions[mapName] = nil
            notyuri("ResetPos all map=" .. mapName)
        end
        SavePositions()
        UpdatePosLabels()
        return
    end
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end
    local pos = hrp.Position
    if not Periastron.Place.SlotPositions[mapName] then Periastron.Place.SlotPositions[mapName] = {} end
    if act == "set" then
        if not Periastron.Place.SlotPositions[mapName][slot] then Periastron.Place.SlotPositions[mapName][slot] = {} end
        table.insert(Periastron.Place.SlotPositions[mapName][slot], { x = pos.X, y = pos.Y, z = pos.Z })
        local count = #Periastron.Place.SlotPositions[mapName][slot]
        notyuri("SetPos slot=" .. slot .. " count=" .. count .. " map=" .. mapName)
    elseif act == "massset" then
        for i = 1, SLOT_COUNT do
            if not Periastron.Place.SlotPositions[mapName][i] then Periastron.Place.SlotPositions[mapName][i] = {} end
            table.insert(Periastron.Place.SlotPositions[mapName][i], { x = pos.X, y = pos.Y, z = pos.Z })
        end
        notyuri("MassSetPos map=" .. mapName)
    end
    SavePositions()
    UpdatePosLabels()
end
local function PosKey(pos)
    return string.format("%.1f_%.1f_%.1f", pos.X, pos.Y, pos.Z)
end
local function FailPosBlocked(pos)
    local deadline = Periastron.Place.FailPos[PosKey(pos)]
    return type(deadline) == "number" and tick() < deadline
end
local function MarkFailPos(pos)
    Periastron.Place.FailPos[PosKey(pos)] = tick() + 30
end
local function ClearExpiredFailPos()
    local now = tick()
    for k, deadline in pairs(Periastron.Place.FailPos) do
        if type(deadline) ~= "number" or now > deadline then
            Periastron.Place.FailPos[k] = nil
        end
    end
end
local function IsSpotValid(pos)
    if not (pos and pos.X and pos.Y and pos.Z) then return false end
    local char = GetCharacter()
    local exclude = {}
    if char then
        table.insert(exclude, char)
    end
    local gridParts = {}
    pcall(function()
        for _, p in ipairs(CS:GetTagged("Grid")) do
            table.insert(gridParts, p)
        end
    end)
    local probeCF = CFrame.new(pos)
    local probeSize = Vector3.new(2.5, 5, 2.5)
    if #gridParts > 0 then
        local pathParams = OverlapParams.new()
        pathParams.FilterType = Enum.RaycastFilterType.Include
        pathParams.FilterDescendantsInstances = gridParts
        local hits = workspace:GetPartBoundsInBox(probeCF, probeSize, pathParams)
        if #hits > 0 then
            return false
        end
        for _, p in ipairs(gridParts) do
            table.insert(exclude, p)
        end
    end
    local obsParams = OverlapParams.new()
    obsParams.FilterType = Enum.RaycastFilterType.Exclude
    obsParams.FilterDescendantsInstances = exclude
    local obsHits = workspace:GetPartBoundsInBox(probeCF, probeSize, obsParams)
    if #obsHits > 0 then
        return false
    end
    return true
end
local function GetPathNodePositions()
    local nodes = {}
    local folder = workspace:FindFirstChild("PathScriptable")
    folder = folder and folder:FindFirstChild("Nodes")
    if folder then
        for _, n in ipairs(folder:GetChildren()) do
            local p = nil
            pcall(function()
                if n:IsA("BasePart") then
                    p = n.Position
                elseif n:IsA("Model") then
                    p = n:GetPivot().Position
                elseif n:IsA("Attachment") then
                    p = n.WorldPosition
                end
            end)
            if p then
                table.insert(nodes, p)
            end
        end
    end
    return nodes
end
local function FindSpotNear(center)
    if not FailPosBlocked(center) and IsSpotValid(center) then
        return center
    end
    local offsets = {
        Vector3.new(6, 0, 0), Vector3.new(-6, 0, 0), Vector3.new(0, 0, 6), Vector3.new(0, 0, -6),
        Vector3.new(6, 0, 6), Vector3.new(-6, 0, 6), Vector3.new(6, 0, -6), Vector3.new(-6, 0, -8),
        Vector3.new(12, 0, 0), Vector3.new(-12, 0, 0), Vector3.new(0, 0, 12), Vector3.new(0, 0, -12),
        Vector3.new(9, 0, 9), Vector3.new(-9, 0, -9), Vector3.new(9, 0, -9), Vector3.new(-9, 0, 9),
        Vector3.new(16, 0, 0), Vector3.new(-16, 0, 0), Vector3.new(0, 0, 16), Vector3.new(0, 0, -16),
        Vector3.new(12, 0, 12), Vector3.new(-12, 0, -12), Vector3.new(12, 0, -12), Vector3.new(-12, 0, 12),
    }
    for _, off in ipairs(offsets) do
        local cand = center + off
        if not FailPosBlocked(cand) and IsSpotValid(cand) then
            return cand
        end
    end
    return nil
end
local function AutoSpotForSlot(slot, name)
    local range = 10
    local stats = Periastron.UnitStats
    if type(stats) == "table" and type(stats[name]) == "table" and type(stats[name].Range) == "number" then
        range = stats[name].Range
    end
    local dist = math.clamp(range * 0.7, 5, 12)
    local nodes = GetPathNodePositions()
    if #nodes == 0 then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            return FindSpotNear(hrp.Position)
        end
        return nil
    end
    local step = math.max(1, math.floor(#nodes / 8))
    local i = (slot * 3) % #nodes + 1
    for _ = 1, #nodes do
        local node = nodes[i]
        local perp = Vector3.new(1, 0, 1)
        local cands = {
            node + perp * dist,
            node - perp * dist,
            node + Vector3.new(dist, 0, 0),
            node - Vector3.new(dist, 0, 0),
            node + Vector3.new(0, 0, dist),
            node - Vector3.new(0, 0, dist),
        }
        for _, cand in ipairs(cands) do
            if not FailPosBlocked(cand) and IsSpotValid(cand) then
                return cand
            end
        end
        i = ((i + step - 1) % #nodes) + 1
    end
    return nil
end
local function PickSavedSpot(slot)
    local mapName = GetCurrentMapName()
    local saved = mapName and Periastron.Place.SlotPositions[mapName] and Periastron.Place.SlotPositions[mapName][slot]
    if not (saved and #saved > 0) then
        return nil
    end
    for _ = 1, #saved do
        local pick = saved[math.random(1, #saved)]
        local pos = Vector3.new(pick.x, pick.y, pick.z)
        if not FailPosBlocked(pos) then
            return pos
        end
    end
    return nil
end
local function TryPlaceTower(name, slot)
    if not RoundLive() then return false, nil end
    local price = GetPlaceCost(name)
    if price > 0 and GetCash() < price then return false, nil end
    local pause = Periastron.Place.PauseUntil[name] or 0
    if tick() < pause then return false, nil end
    local inflight = Periastron.Place.InFlight[name]
    if type(inflight) == "number" and tick() < inflight then return false, nil end
    if slot then
        local placeWave = GetSlotOption("PlaceWave", slot, 0)
        if placeWave > 0 and Periastron.Wave < placeWave then return false, nil end
        local slotLimit = GetSlotOption("PlaceLimit", slot, 0)
        if slotLimit > 0 and CountOwnedByName(name) >= slotLimit then return false, nil end
    end
    local spot = PickSavedSpot(slot)
    if not spot then
        spot = AutoSpotForSlot(slot, name)
    end
    if not spot then return false, nil end
    if FireGame("PlaceUnit", name, CFrame.new(spot)) then
        Periastron.Place.TypeFails[name] = 0
        Periastron.Place.InFlight[name] = tick() + 1
        return true, spot
    end
    MarkFailPos(spot)
    Periastron.Place.TypeFails[name] = (Periastron.Place.TypeFails[name] or 0) + 1
    if Periastron.Place.TypeFails[name] >= 3 then
        Periastron.Place.PauseUntil[name] = tick() + 10
        Periastron.Place.TypeFails[name] = 0
        notyuri("3 rejects for", name, "- pausing 10s")
    end
    return false, nil
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        if RoundLive() then
            RefreshDeck()
            ClearExpiredFailPos()
            for _, entry in ipairs(GetSelectedTowerSlots()) do
                if not (Toggles.AutoPlace.Value and RoundLive()) then break end
                local placed, spot = TryPlaceTower(entry.name, entry.slot)
                if placed then
                    notyuri("Placed", entry.name, "slot", tostring(entry.slot))
                    if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value then
                        local unit = nil
                        local deadline = os.clock() + 1.5
                        while os.clock() < deadline and not unit do
                            unit = MatchTowerAt(entry.name, spot, 9)
                            if not unit then
                                task.wait(0.125)
                            end
                        end
                        if unit then
                            local upgLimit = entry.slot and GetSlotOption("UpgradeLimit", entry.slot, 0) or 0
                            for _ = 1, 20 do
                                if not Toggles.PlaceAndUpgrade.Value then break end
                                if upgLimit > 0 and unit.upgrades >= upgLimit then break end
                                if not (unit.own and not IsMaxedLevel(unit.name, unit.upgrades) and GetCash() >= GetUpgradeCost(unit.name, unit.upgrades) and FireGame("UpgradeUnit", unit.unitId)) then
                                    break
                                end
                                task.wait()
                            end
                        end
                    end
                end
                task.wait()
            end
        end
        task.wait()
    end
end
local function GetUpgradableTowers()
    local slotByName = SlotByTowerName()
    local result = {}
    for _, unit in ipairs(GetOwnUnits()) do
        local slot = slotByName[unit.name]
        local upgLimit = slot and GetSlotOption("UpgradeLimit", slot, 0) or 0
        local level = unit.upgrades or 0
        if upgLimit <= 0 or level < upgLimit then
            if not IsMaxedLevel(unit.name, level) then
                local price = GetUpgradeCost(unit.name, level)
                table.insert(result, {
                    unit = unit,
                    slot = slot,
                    level = level,
                    towerName = unit.name,
                    price = price,
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
        local reserve = (Options.UpgradeReserve and Options.UpgradeReserve.Value) or 0
        local units = GetUpgradableTowers()
        local target = UpgradeTarget(units)
        if target and RoundLive() and (GetCash() - reserve) >= target.price then
            if FireGame("UpgradeUnit", target.unit.unitId) then
                notyuri("Upgraded", target.towerName, "slot", tostring(target.slot))
            end
        end
        task.wait()
    end
end
local function Func_AutoAtWave(toggle, thresholdOption, action)
    while toggle.Value do
        local threshold = tonumber(thresholdOption and thresholdOption.Value) or 0
        local wave = Periastron.Wave
        if wave >= threshold and RoundLive() then
            if action == "sell" then
                for _, unit in ipairs(GetOwnUnits()) do
                    FireGame("SellUnit", unit.unitId)
                end
            elseif action == "leave" then
                FireGame("RequestLobbyTeleport")
                notyuri("AutoLeave", "leave sent", "wave", tostring(wave))
            end
        end
        task.wait(1)
    end
end
local function GetCardSlots()
    local list = {}
    for i = 1, CARD_SLOTS do
        local id = Options["CardSelect" .. i].Value
        if id and id ~= "" then
            list[#list + 1] = { id = id, slot = i }
        end
    end
    return list
end
local function GetCardUseArgs(entry)
    local rcc = Periastron.RoundCardConfig
    if entry.id == "WeatherReport" then
        local weather = Periastron.Weather
        if weather and AddMultiDropdown("CardWeather" .. entry.slot)[weather] then
            return true, nil
        end
        return false
    end
    local use = rcc.GetUse(entry.id)
    if use == rcc.Use.Instant then
        return true, nil
    end
    if use == rcc.Use.Unit then
        local names = AddMultiDropdown("CardUnits" .. entry.slot)
        for _, unit in ipairs(GetOwnUnits()) do
            if names[unit.name] then
                return true, { UnitId = unit.unitId }
            end
        end
    end
    return false
end
local function Func_AutoBuyCard()
    local rcc = Periastron.RoundCardConfig
    while Toggles.AutoBuyCard.Value do
        local offer = Periastron.Cards.Offer
        if offer and RoundLive() and Periastron.Wave >= (tonumber(Options.AutoBuyCardValue.Value) or 0) then
            local offered = {}
            for _, id in ipairs(offer.cards) do
                offered[id] = true
            end
            for _, entry in ipairs(GetCardSlots()) do
                local card = rcc.Get(entry.id)
                if offered[entry.id] and card and GetCash() >= (card.Price or 0) then
                    FireGame("BuyRoundCard", offer.token, entry.id)
                    Periastron.Cards.Offer = nil
                    break
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoUseCard()
    while Toggles.AutoUseCard.Value do
        if RoundLive() then
            local cards = Periastron.Cards
            for _, entry in ipairs(GetCardSlots()) do
                local uid
                for u, id in pairs(cards.Deck) do
                    local sent = cards.UsePending[u]
                    if id == entry.id and not (sent and os.clock() - sent < 3) then
                        uid = u
                        break
                    end
                end
                if uid and Periastron.Wave >= (tonumber(Options["CardWave" .. entry.slot].Value) or 0) then
                    local ok, payload = GetCardUseArgs(entry)
                    if ok then
                        cards.UsePending[uid] = os.clock()
                        FireGame("UseRoundCard", uid, payload)
                        break
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoSpeed()
    while Toggles.AutoSpeed.Value do
        if Toggles.AutoSpeed.Value then
            local n = tonumber(Options.SpeedTarget and Options.SpeedTarget.Value) or 2
            if Periastron.Speed < n then
                local ok, err = pcall(function()
                    FireGame("SetGameSpeed", n)
                end)
                if not ok then
                    notyuri("AutoSpeed error:", tostring(err))
                end
            end
        end
        task.wait(2)
    end
end
local function UpdateMacroLabel(suffix, elapsed, nextEntry)
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
    if not MState.Cur then return end
    MState.Step = MState.Step + 1
    local entry = { Type = kind, Time = tostring(wave or 0) .. " " .. tostring(math.floor((elapsed or 0))) }
    for k, v in pairs(data or {}) do
        entry[k] = v
    end
    table.insert(MState.Cur.entries, entry)
    UpdateMacroLabel(kind, entry.Time)
end
local function ParseMacroTime(entry)
    local wStr, eStr = (entry.Time or ""):match("^(%d+)%s+(.+)$")
    return tonumber(wStr) or 0, (tonumber(eStr) or 0)
end
local function SortMacroEntries(entries)
    local order = {}
    for i, e in ipairs(entries) do order[e] = i end
    table.sort(entries, function(a, b)
        local wa, ea = ParseMacroTime(a)
        local wb, eb = ParseMacroTime(b)
        if wa ~= wb then return wa < wb end
        if ea ~= eb then return ea < eb end
        return order[a] < order[b]
    end)
end
local function TakePending(list, match)
    local now = os.clock()
    for i = #list, 1, -1 do
        if now - list[i].t > 3 then table.remove(list, i) end
    end
    for i, p in ipairs(list) do
        if match(p) then return table.remove(list, i) end
    end
end
local function ConfirmPlace(name, cframe, ownerUserId)
    if not MState.Rec or ownerUserId ~= Plr.UserId then return end
    local at = cframe and cframe.Position
    local p = TakePending(MState.Pend.Place, function(p)
        return p.Name == name and (not at or (at - Vector3.new(p.Pos[1], p.Pos[2], p.Pos[3])).Magnitude <= 7)
    end)
    if p then RecordAct("Place", { Name = p.Name, Pos = p.Pos }, p.Wave, p.Elapsed) end
end
local function ConfirmUpgrade(unitId, u)
    if not MState.Rec or not u.own then return end
    local list = MState.Pend.Upgrade[unitId]
    if not list then return end
    if TakePending(list, function() return true end) then
        local pos = u.pos
        RecordAct("Upgrade", { Name = u.name, LVL = u.upgrades, Key = unitId, Pos = pos and { pos.X, pos.Y, pos.Z } }, Periastron.Wave, WaveElapsed())
    end
end
local function ConfirmSell(unitId)
    if not MState.Rec then return end
    local list = MState.Pend.Sell[unitId]
    if not list then return end
    local p = TakePending(list, function() return true end)
    if p then RecordAct("Sell", { Name = p.Name, Key = p.Key, Pos = p.Pos }, p.Wave, p.Elapsed) end
end
local function InstallMacroHook()
    if MState.Hooked then return end
    local mt = Periastron.MeMT
    if type(mt) ~= "table" or type(mt.Fire) ~= "function" then
        notyuri("[Periastron] macro hook unavailable: no Me metatable")
        return
    end
    local orig = Periastron.OrigFire
    mt.Fire = function(self, name, ...)
        local rec = MState.Rec and not MState.SelfFire
        if rec and name == "PlaceUnit" then
            local a, b = ...
            if type(a) == "string" and b and b.Position and b.X then
                table.insert(MState.Pend.Place, { Name = a, Pos = { b.X, b.Y, b.Z }, Wave = Periastron.Wave, Elapsed = WaveElapsed(), t = os.clock() })
            end
        elseif rec and name == "UpgradeUnit" then
            local a = ...
            if type(a) == "string" then
                MState.Pend.Upgrade[a] = MState.Pend.Upgrade[a] or {}
                table.insert(MState.Pend.Upgrade[a], { t = os.clock() })
            end
        elseif rec and name == "SellUnit" then
            local a = ...
            if type(a) == "string" then
                local u = Periastron.Units[a]
                local p = u and u.pos
                MState.Pend.Sell[a] = MState.Pend.Sell[a] or {}
                table.insert(MState.Pend.Sell[a], { Name = u and u.name or "?", Key = a, Pos = p and { p.X, p.Y, p.Z }, Wave = Periastron.Wave, Elapsed = WaveElapsed(), t = os.clock() })
            end
        end
        return orig(self, name, ...)
    end
    MState.Hooked = true
    notyuri("[Periastron] macro hook installed on Me.Fire")
end
local function Func_MacroRecord(state)
    if not state then return end
    if Toggles.LoadMacro and Toggles.LoadMacro.Value then
        Toggles.LoadMacro:SetValue(false)
    end
    InstallMacroHook()
    MState.Cur = { entries = {} }
    MState.Pend = { Place = {}, Upgrade = {}, Sell = {} }
    MState.Step = 0
    MState.Saved = false
    UpdateMacroLabel("Waiting")
    while Toggles.MacroRecord.Value and not RoundLive() do
        task.wait()
    end
    if not Toggles.MacroRecord.Value then
        MState.Cur = nil
        MState.Step = 0
        UpdateMacroLabel()
        return
    end
    MState.Rec = true
    UpdateMacroLabel()
    notyuri("recording started")
    while Toggles.MacroRecord.Value and RoundLive() do
        task.wait()
    end
    MState.Rec = false
    task.wait(0.1)
    local entries = MState.Cur and #MState.Cur.entries or 0
    notyuri("recording stopped,", tostring(entries), "actions")
    if entries > 0 and not MState.Saved then
        MState.Saved = true
        SortMacroEntries(MState.Cur.entries)
        local recorded = MState.Cur
        local fname = (Options.FileName and Options.FileName.Value) or ""
        if fname == "" then
            fname = "Macro_" .. os.date("%Y%m%d_%H%M%S")
        end
        task.spawn(function()
            if SaveMacro(fname, recorded) then
                Library:Notify("Macro saved: " .. fname, 4)
                if Options.MacroSelected then
                    Options.MacroSelected:SetValues(ListMacros())
                    Options.MacroSelected:SetValue(fname)
                end
            else
                Library:Notify("Failed to save macro (writefile unsupported?)", 4)
            end
        end)
    end
    MState.Cur = nil
    MState.Step = 0
    UpdateMacroLabel("Stopped (" .. tostring(entries) .. ")")
end
local function MacroEntryCost(entry)
    if entry.Type == "Place" then
        return GetPlaceCost(entry.Name)
    elseif entry.Type == "Upgrade" then
        return GetUpgradeCost(entry.Name, entry.LVL or 0)
    end
    return nil
end
local function WaitForCash(amount, timeout)
    if not amount or amount <= 0 then return true end
    if GetCash() >= amount then return true end
    local limit = timeout or 60
    local start = os.clock()
    while Toggles.LoadMacro.Value and GetCash() < amount and (os.clock() - start) < limit do
        if Library.Unloaded then return false end
        task.wait()
    end
    return Toggles.LoadMacro.Value and GetCash() >= amount
end
local function FindTowerForEntry(entry)
    if entry.Key and Periastron.Units[entry.Key] and Periastron.Units[entry.Key].own then
        return Periastron.Units[entry.Key]
    end
    if type(entry.Pos) ~= "table" or #entry.Pos ~= 3 then return nil end
    local pos = Vector3.new(entry.Pos[1], entry.Pos[2], entry.Pos[3])
    local best = MatchTowerAt(entry.Name, pos, 7)
    if best and entry.Key then
        entry.Key = best.unitId
    end
    return best
end
local function ResolveTowerRetry(entry)
    local unit = FindTowerForEntry(entry)
    if unit and unit.own then return unit end
    local start = os.clock()
    while Toggles.LoadMacro.Value and (os.clock() - start) < 1 do
        task.wait()
        unit = FindTowerForEntry(entry)
        if unit and unit.own then return unit end
    end
    return nil
end
local function DoMacroAction(entry)
    if entry.Type == "Place" then
        local pos = entry.Pos
        if type(pos) ~= "table" or #pos ~= 3 then return end
        local origin = Vector3.new(pos[1], pos[2], pos[3])
        local existing = MatchTowerAt(entry.Name, origin, 2)
        if existing then
            entry.Key = existing.unitId
            return
        end
        local known = {}
        for id in pairs(Periastron.Units) do
            known[id] = true
        end
        local tried = {}
        local function FindNewUnit()
            for id, u in pairs(Periastron.Units) do
                if not known[id] and u.own and u.name == entry.Name and u.pos then
                    for _, s in ipairs(tried) do
                        if (u.pos - s).Magnitude <= 7 then
                            return u
                        end
                    end
                end
            end
            return nil
        end
        for attempt = 1, 5 do
            if not Toggles.LoadMacro.Value then return end
            local spot = origin
            if attempt > 1 then
                notyuri("Place retry:", entry.Name, tostring(entry.Time), "attempt", attempt, "cash", tostring(GetCash()))
            end
            table.insert(tried, spot)
            if FireGame("PlaceUnit", entry.Name, CFrame.new(spot)) then
                local start = os.clock()
                local unit = FindNewUnit()
                while not unit and Toggles.LoadMacro.Value and os.clock() - start < 2 do
                    task.wait()
                    unit = FindNewUnit()
                end
                if unit then
                    entry.Key = unit.unitId
                    return
                end
            end
            if not Toggles.LoadMacro.Value then return end
            WaitForCash(MacroEntryCost(entry), 10)
            local late = FindNewUnit()
            if late then
                entry.Key = late.unitId
                return
            end
        end
        notyuri("Place FAILED:", entry.Name, tostring(entry.Time))
    elseif entry.Type == "Upgrade" then
        local unit = ResolveTowerRetry(entry)
        if not (unit and unit.own) then
            notyuri("Upgrade SKIP: no unit for key", tostring(entry.Key))
            return
        end
        if type(entry.LVL) == "number" and unit.upgrades > entry.LVL then
            return
        end
        for attempt = 1, 3 do
            if not Toggles.LoadMacro.Value then return end
            local before = unit.upgrades
            if FireGame("UpgradeUnit", unit.unitId) then
                local start = os.clock()
                while Toggles.LoadMacro.Value and unit.upgrades <= before and (os.clock() - start) < 2 do
                    task.wait()
                end
                if unit.upgrades > before then return end
            end
            local cost = MacroEntryCost(entry)
            notyuri("Upgrade no effect:", unit.name, "macroLVL", tostring(entry.LVL), "unitLVL", tostring(unit.upgrades), "cost", tostring(cost), "cash", tostring(GetCash()), "attempt", attempt)
            if not WaitForCash(cost) then
                notyuri("Upgrade cash wait aborted:", unit.name, tostring(entry.Time))
                return
            end
        end
        notyuri("Upgrade FAILED:", unit.name, "macroLVL", tostring(entry.LVL), "unitLVL", tostring(unit.upgrades), tostring(entry.Time))
    elseif entry.Type == "Sell" then
        local unit = ResolveTowerRetry(entry)
        if not (unit and unit.own) then
            notyuri("Sell SKIP: no unit for key", tostring(entry.Key))
            return
        end
        FireGame("SellUnit", unit.unitId)
    end
end
local function Func_MacroReplay()
    while Toggles.LoadMacro.Value do
        local macro = MState.Load
        if not (macro and macro.entries and #macro.entries > 0) then
            Toggles.LoadMacro:SetValue(false)
            Library:Notify("No macro loaded", 3)
            return
        end
        MState.Rep = true
        MState.Total = #macro.entries
        MState.Step = 0
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
            MState.Step = i
            UpdateMacroLabel(entry.Type, entry.Time, macro.entries[i + 1])
            local replayMode = Options.ReplayMode and Options.ReplayMode.Value or "Time"
            local skipStep = false
            if replayMode == "Money" then
                local cost = MacroEntryCost(entry)
                if cost and cost > 0 and not WaitForCash(cost) then
                    notyuri("money wait aborted (toggle off)")
                end
            else
                local tWave = ParseMacroTime(entry)
                while Toggles.LoadMacro.Value and Periastron.Wave < tWave do
                    if not RoundLive() then break end
                    task.wait()
                end
                if Periastron.Wave > tWave + 100 then
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
        MState.Rep = false
        MState.Step = 0
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
    MState.Rep = false
    UpdateMacroLabel()
end
local function GetPortal()
    local map = workspace:FindFirstChild("Map")
    local portals = map and map:FindFirstChild("Portals")
    if not portals then return nil end
    for _, p in ipairs(portals:GetChildren()) do
        local id = p:GetAttribute("PortalId")
        if type(id) == "number" then
            return p
        end
    end
    return nil
end
local function GetPortalEnterCFrame(portal)
    local enter = portal:FindFirstChild("PortalEnterCFrame", true)
    if enter then
        if enter:IsA("BasePart") then
            return enter.CFrame
        elseif enter:IsA("Attachment") then
            return enter.WorldCFrame
        elseif enter:IsA("Model") then
            return enter:GetPivot()
        end
    end
    return portal:GetPivot()
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        local portal = GetPortal()
        if portal then
            local portalId = portal:GetAttribute("PortalId")
            if type(portalId) == "number" then
                if not (Periastron.Group.JoinedAt > 0) then
                    local enterCF = GetPortalEnterCFrame(portal)
                    local char = GetCharacter()
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and (hrp.Position - enterCF.Position).Magnitude > 7 then
                        TPTo(enterCF * CFrame.new(0, 0, 3))
                    end
                    local map = (Options.QueueMap and Options.QueueMap.Value) or "Join Existing"
                    if map ~= "Join Existing" then
                        FireGame("RequestCreateGroup", portalId, map, 1)
                    else
                        FireGame("RequestJoinGroup", portalId)
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function GetCrateCount(rarity)
    local data = GetReplicaData()
    if not data then return 0 end
    local inv = data.Inventory
    local crates = inv and inv.Crates
    if type(crates) == "table" then
        local c = crates[rarity]
        if type(c) == "number" then
            return c
        end
        if type(c) == "table" and type(c.Count) == "number" then
            return c.Count
        end
    end
    return 0
end
local function Func_AutoCrate()
    while Toggles.AutoCrate.Value do
        local rarity = (Options.CrateRarity and Options.CrateRarity.Value) or "Common"
        local amount = tonumber((Options.CrateAmount and Options.CrateAmount.Value) or "1") or 1
        local have = GetCrateCount(rarity)
        local opened = 0
        while opened < amount and have - opened > 0 do
            if FireGame("RequestOpenCrate", rarity) then
                opened = opened + 1
            end
            task.wait(0.6)
        end
        if opened > 0 then
            notyuri("[AutoCrate] opened", tostring(opened), rarity)
        end
        task.wait(2)
    end
end
local function Func_AutoClaimContracts()
    while Toggles.AutoClaimContracts.Value do
        local data = GetReplicaData()
        if data then
            local contracts = data.Contracts
            if type(contracts) == "table" then
                local cfg = Periastron.ContractConfig
                if cfg and type(cfg.get) == "function" and type(cfg.isComplete) == "function" then
                    for _, kind in ipairs({"Hourly", "Daily", "Weekly"}) do
                        local section = contracts[kind]
                        if type(section) == "table" and type(section.Slots) == "table" then
                            for idx, slot in ipairs(section.Slots) do
                                if type(slot) == "table" and not slot.Claimed then
                                    local ok, c = pcall(cfg.get, cfg, slot.Id)
                                    if ok and c then
                                        local okC, done = pcall(cfg.isComplete, cfg, c, slot)
                                        if okC and done then
                                            if FireGame("ClaimContract", kind, idx) then
                                                notyuri("[Contracts] claimed", kind, tostring(idx))
                                            end
                                            task.wait(0.4)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(5)
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
local function SendMatchWebhook()
    local match = Periastron.Match
    if match.WebhookSent or not match.Result or not match.Reward then return end
    match.WebhookSent = true
    if not (Toggles.WHMatchEnd and Toggles.WHMatchEnd.Value) then return end
    local result = match.Result
    local rewards = type(match.Reward.rewards) == "table" and match.Reward.rewards or {}
    local mapName = GetCurrentMapName()
    local mapList = Periastron.MapConfig and Periastron.MapConfig.MAPS
    local mapEntry = mapList and mapName and mapList[mapName]
    local lines = {
        "- Player: ||" .. Plr.Name .. "||",
        "- Map: " .. tostring(mapEntry and mapEntry.DisplayName or mapName or "Unknown"),
        "- Wave Reached: " .. tostring(result.Wave),
    }
    if result.Elapsed then
        local secs = math.floor(result.Elapsed)
        table.insert(lines, string.format("- Time: %02d:%02d", math.floor(secs / 60), secs % 60))
    end
    table.insert(lines, "- Rewards:")
    for _, entry in ipairs({ { "coins", "Coins" }, { "shards", "Shards" }, { "xp", "XP" } }) do
        local amount = tonumber(rewards[entry[1]])
        if amount and amount > 0 then
            table.insert(lines, string.format("+%s %s", CommaFormat(amount), entry[2]))
        end
    end
    SendWebhook(result.Won and "Match Finished - Victory" or "Match Finished - Defeat", table.concat(lines, "\n"))
end
local function OnMatchEnd(won)
    Periastron.Match.Over = true
    Periastron.Match.Won = won
    local label = won and "Victory" or "Defeat"
    local startedAt = Periastron.Match.StartedAt
    Periastron.Match.Result = {
        Won = won,
        Wave = Periastron.Wave,
        Elapsed = startedAt and (os.clock() - startedAt) or nil,
    }
    SendMatchWebhook()
    Library:Notify("Match " .. label .. " (wave " .. Periastron.Wave .. ")", 5)
    if Toggles.AutoReplay and Toggles.AutoReplay.Value then
        task.delay(0.5, function()
            FireGame("VotePlayAgain")
        end)
    end
end
local function OnRoundRestarted()
    Periastron.Units = {}
    Periastron.Place.TypeFails = {}
    Periastron.Place.PauseUntil = {}
    Periastron.Place.FailPos = {}
    Periastron.Place.InFlight = {}
    Periastron.Match.Over = false
    Periastron.Match.Started = true
    Periastron.Match.WebhookSent = false
    Periastron.Match.Result = nil
    Periastron.Match.Reward = nil
    Periastron.Match.StartedAt = nil
    Periastron.ReadyFiredWave = -1
    Periastron.WaveStartedAt = os.clock()
    if Toggles.LoadMacro and Toggles.LoadMacro.Value and not MState.Rep then
        Thread("LoadMacro", SafeLoop("Macro Replay", Func_MacroReplay), true)
    end
end
local function InstallGameStateListeners()
    ListenGame("SetWave", function(wave)
        local w = tonumber(wave)
        if w then
            Periastron.Wave = w
            Periastron.WaveStartedAt = os.clock()
            Periastron.Intermission = false
            if w > 0 and not Periastron.Match.StartedAt then
                Periastron.Match.StartedAt = os.clock()
            end
        end
    end)
    ListenGame("WaveIntermission", function(data)
        Periastron.Intermission = true
        if Toggles.AutoReady and Toggles.AutoReady.Value then
            if Periastron.ReadyFiredWave ~= Periastron.Wave then
                Periastron.ReadyFiredWave = Periastron.Wave
                task.delay(0.5, function()
                    FireGame("ReadyWave")
                end)
            end
        end
    end)
    ListenGame("SkipState", function(state)
        if Toggles.AutoVoteSkip and Toggles.AutoVoteSkip.Value then
            if type(state) ~= "table" or state.active ~= false then
                FireGame("VoteSkip", true)
            end
        end
    end)
    ListenGame("DifficultySelection", function(data)
        if not (Toggles.AutoDifficulty and Toggles.AutoDifficulty.Value) then return end
        if type(data) ~= "table" or data.active ~= true or data.locked ~= nil then return end
        local target = Options.DifficultyChoice and Options.DifficultyChoice.Value
        if type(target) ~= "string" or target == "" then return end
        if data.selected == target then return end
        if type(data.options) == "table" and not table.find(data.options, target) then return end
        notyuri("[Periastron] auto difficulty ->", target)
        FireGame("SelectDifficulty", target)
    end)
    ListenGame("GameSpeedChanged", function(step)
        local s = tonumber(step)
        if s then
            Periastron.Speed = s
        end
    end)
    ListenGame("PlayMapMusic", function(music)
        if type(music) == "string" and music ~= "" then
            Periastron.MapKey = music
            notyuri("[Periastron] map key =", music)
        end
    end)
    ListenGame("ReplicateUnit", function(name, cframe, ownerUserId, unitId, upgrades)
        RegisterUnit(name, cframe, ownerUserId, unitId, upgrades)
        ConfirmPlace(name, cframe, ownerUserId)
        if ownerUserId == Plr.UserId then
            Periastron.Place.InFlight[name] = nil
        end
    end)
    ListenGame("RemoveUnit", function(unitId)
        ConfirmSell(unitId)
        Periastron.Units[unitId] = nil
    end)
    ListenGame("UnitUpgraded", function(unitId, level)
        local u = Periastron.Units[unitId]
        if u then
            ConfirmUpgrade(unitId, u)
            u.upgrades = tonumber(level) or u.upgrades
        end
    end)
    ListenGame("RoundRestarted", function()
        OnRoundRestarted()
    end)
    ListenGame("RoundReward", function(data)
        Periastron.Match.Reward = type(data) == "table" and data or {}
        SendMatchWebhook()
    end)
    ListenGame("Win", function()
        OnMatchEnd(true)
        Periastron.Wave = 0
        Periastron.WaveStartedAt = os.clock()
        Periastron.Intermission = true
    end)
    ListenGame("GameOver", function()
        OnMatchEnd(false)
        Periastron.Wave = 0
        Periastron.WaveStartedAt = os.clock()
        Periastron.Intermission = true
    end)
    ListenGame("UpdateCardCounts", function() end)
    ListenGame("RoundCardState", function(state)
        if type(state) ~= "table" then return end
        local deck = {}
        for _, card in pairs(state.owned or {}) do
            if type(card) == "table" and type(card.Uid) == "string" then
                deck[card.Uid] = card.Id
            end
        end
        Periastron.Cards.Deck = deck
        if state.token and state.cards then
            Periastron.Cards.Offer = { token = state.token, cards = state.cards }
        else
            Periastron.Cards.Offer = nil
        end
    end)
    ListenGame("RoundCardBought", function(data)
        if type(data) ~= "table" then return end
        Periastron.Cards.Offer = nil
        Periastron.Cards.Deck[data.uid] = data.id
    end)
    ListenGame("RoundCardUsed", function(data)
        if type(data) ~= "table" then return end
        Periastron.Cards.Deck[data.uid] = nil
        Periastron.Cards.UsePending[data.uid] = nil
    end)
    ListenGame("WeatherChanged", function(weather)
        Periastron.Weather = type(weather) == "string" and weather or nil
    end)
    FireGame("RequestRoundCardState")
    FireGame("RequestWeather")
    FireGame("RequestCash")
end
local function InstallLobbyStateListeners()
    ListenGame("PortalGroupChanged", function(a, b)
        Periastron.Group.LastChange = {a = a, b = b, t = tick()}
        if type(a) == "number" and a ~= 0 then
            Periastron.Group.JoinedAt = tick()
        end
    end)
end
EnsureFolderPath(MDir)
LoadPositions()
local GB_Webhook = {
    Left = {
        Webhook = Tabs.Webhook:AddLeftGroupbox("Webhook"),
    },
}
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
for i = 1, SLOT_COUNT do
    APRight:AddSlider("PlaceOrder" .. i, {
        Text = "Slot " .. i,
        Default = i,
        Min = 1,
        Max = SLOT_COUNT,
        Rounding = 0,
        Compact = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Place Wave per Slot", true)
for i = 1, SLOT_COUNT do
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
for i = 1, SLOT_COUNT do
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
for i = 1, SLOT_COUNT do
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
        local val = (Options.SetSlotSelect and Options.SetSlotSelect.Value) or ""
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
        local val = (Options.ResetSlotSelect and Options.ResetSlotSelect.Value) or "All Slots"
        if val == "All Slots" then
            HandleSlotPos("reset", nil)
        else
            HandleSlotPos("reset", SlotDisplayToNumber(val))
        end
    end,
})
UpdatePosLabels()
local ACLeft = Tabs.Main:AddLeftGroupbox("Auto Card")
AddSliderToggle({ Group = ACLeft, Id = "AutoBuyCard", Text = "Auto Buy Card", Default = 0, Min = 0, Max = 100, Rounding = 0 })
ACLeft:AddToggle("AutoUseCard", { Text = "Auto Use Card" })
for i = 1, CARD_SLOTS do
    ACLeft:AddDropdown("CardSelect" .. i, {
        Text = "Card " .. i,
        Values = {},
        Default = "",
        Searchable = true,
        Visible = i == 1,
    })
    ACLeft:AddSlider("CardWave" .. i, {
        Text = "Use at Wave",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Compact = true,
        Visible = false,
    })
    AddMultiDropdown(ACLeft, "CardUnits" .. i, { Text = "Use On Units", Values = {} })
    AddMultiDropdown(ACLeft, "CardWeather" .. i, { Text = "Use On Weather", Values = {} })
end
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteSkip", { Text = "Auto Skip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReady", { Text = "Auto Ready", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDifficulty", { Text = "Auto Choose Difficulty", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSpeed", { Text = "Auto Game Speed", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReplay", { Text = "Auto Replay", Default = false })
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
TB_Tabs.Autofarm.T3:AddToggle("AutoCrate", { Text = "Auto Open Crates" })
TB_Tabs.Autofarm.T3:AddToggle("AutoClaimContracts", { Text = "Auto Claim Contracts" })
TB_Tabs.Autofarm2.T1:AddSlider("AutoLeaveValue", {
    Text = "Leave at Wave",
    Default = 30,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("DifficultyChoice", {
    Text = "Difficulty",
    Values = {"Easy", "Medium", "Hard", "Impossible", "Nightmare"},
    Default = "Easy",
})
TB_Tabs.Autofarm2.T1:AddDropdown("SpeedTarget", {
    Text = "Speed Target",
    Values = {"1", "2", "3", "4"},
    Default = "2",
})
local mapValues = {"Join Existing"}
if Periastron.MapConfig and type(Periastron.MapConfig.MAPS) == "table" then
    local mapNames = {}
    for mapName in pairs(Periastron.MapConfig.MAPS) do
        table.insert(mapNames, mapName)
    end
    table.sort(mapNames)
    for _, m in ipairs(mapNames) do
        table.insert(mapValues, m)
    end
end
TB_Tabs.Autofarm2.T2:AddDropdown("QueueMap", {
    Text = "Map",
    Values = mapValues,
    Default = "Join Existing",
    Searchable = true,
})
TB_Tabs.Autofarm2.T2:AddDivider()
TB_Tabs.Autofarm2.T2:AddDropdown("CrateRarity", {
    Text = "Crate Rarity",
    Values = {"Common", "Rare", "Epic", "Legendary"},
    Default = "Common",
})
TB_Tabs.Autofarm2.T2:AddDropdown("CrateAmount", {
    Text = "Open Amount",
    Values = {"1", "5", "10"},
    Default = "1",
})
GB_Webhook.Left.Webhook:AddInput("WebhookURL", {
    Text = "Webhook URL",
    Default = "",
})
GB_Webhook.Left.Webhook:AddToggle("WHMatchEnd", {
    Text = "Match Finished",
    Default = false,
})
Toggles.AutoPlace:OnChanged(function(state)
    Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), state)
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state)
end)
Toggles.AutoSell:OnChanged(function(state)
    Thread("AutoSell", SafeLoop("AutoSell", function() Func_AutoAtWave(AutoSell_T, Options.AutoSellValue, "sell") end), state)
end)
Toggles.AutoLeave:OnChanged(function(state)
    Thread("AutoLeave", SafeLoop("AutoLeave", function() Func_AutoAtWave(Toggles.AutoLeave, Options.AutoLeaveValue, "leave") end), state)
end)
Toggles.AutoSpeed:OnChanged(function(state)
    Thread("AutoSpeed", SafeLoop("AutoSpeed", Func_AutoSpeed), state)
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
Toggles.AutoBuyCard:OnChanged(function(state)
    Thread("AutoBuyCard", SafeLoop("AutoBuyCard", Func_AutoBuyCard), state)
end)
Toggles.AutoUseCard:OnChanged(function(state)
    Thread("AutoUseCard", SafeLoop("AutoUseCard", Func_AutoUseCard), state)
end)
local function RefreshCardUI()
    local rcc = Periastron.RoundCardConfig
    local prevFilled = true
    for i = 1, CARD_SLOTS do
        local id = Options["CardSelect" .. i].Value
        local filled = id ~= nil and id ~= ""
        Options["CardSelect" .. i]:SetVisible(prevFilled or filled)
        Options["CardWave" .. i]:SetVisible(filled)
        Options["CardUnits" .. i]:SetVisible(filled and rcc ~= nil and rcc.GetUse(id) == rcc.Use.Unit)
        Options["CardWeather" .. i]:SetVisible(filled and id == "WeatherReport")
        prevFilled = filled
    end
end
for i = 1, CARD_SLOTS do
    Options["CardSelect" .. i]:OnChanged(RefreshCardUI)
end
RefreshCardUI()
local function SortedKeys(tbl, first)
    local keys = {}
    for k in pairs(tbl) do
        table.insert(keys, k)
    end
    table.sort(keys)
    if first then
        table.insert(keys, 1, first)
    end
    return keys
end
local function RefreshCardDropdowns()
    local rcc = Periastron.RoundCardConfig
    local cardValues = {}
    if rcc then
        for _, card in ipairs(rcc.Cards) do
            local use = rcc.GetUse(card.Id)
            if use == rcc.Use.Instant or use == rcc.Use.Unit then
                table.insert(cardValues, card.Id)
            end
        end
    end
    local unitValues = Periastron.UnitStats and SortedKeys(Periastron.UnitStats, "All") or { "All" }
    local weatherCfg = Periastron.WeatherConfig
    local weatherValues = weatherCfg and SortedKeys(weatherCfg.Effects, "All") or { "All" }
    for i = 1, CARD_SLOTS do
        Options["CardSelect" .. i]:SetValues(cardValues)
        Options["CardUnits" .. i]:SetValues(unitValues)
        Options["CardWeather" .. i]:SetValues(weatherValues)
    end
    RefreshCardUI()
end
Toggles.AutoJoin:OnChanged(function(state)
    Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), state)
end)
Toggles.AutoCrate:OnChanged(function(state)
    Thread("AutoCrate", SafeLoop("AutoCrate", Func_AutoCrate), state)
end)
Toggles.AutoClaimContracts:OnChanged(function(state)
    Thread("AutoClaimContracts", SafeLoop("AutoClaimContracts", Func_AutoClaimContracts), state)
end)
if Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
    MState.Load = LoadMacro(Options.MacroSelected.Value)
end
local function RefreshQueueMapDropdown()
    local values = {"Join Existing"}
    if Periastron.MapConfig and type(Periastron.MapConfig.MAPS) == "table" then
        local mapNames = {}
        for mapName in pairs(Periastron.MapConfig.MAPS) do
            table.insert(mapNames, mapName)
        end
        table.sort(mapNames)
        for _, m in ipairs(mapNames) do
            table.insert(values, m)
        end
    end
    if Options.QueueMap then
        Options.QueueMap:SetValues(values)
    end
end
task.spawn(function()
    BindMe()
    RefreshQueueMapDropdown()
    RefreshCardDropdowns()
    InstallGameStateListeners()
    InstallLobbyStateListeners()
    FetchDataController()
    RefreshDeck()
    RefreshSlotDropdowns()
    UpdatePosLabels()
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
SaveManager:SetFolder("Yuri/PeriastronTD")
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
