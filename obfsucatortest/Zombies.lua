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
local function QueueOnTeleportExec(code)
    if typeof(queue_on_teleport) == "function" then
        queue_on_teleport(code)
    elseif typeof(queueonteleport) == "function" then
        queueonteleport(code)
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
    Build = Window:AddTab("Build"),
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
local A1 = Tabs.Build:AddLeftGroupbox("Build")
local A2 = Tabs.Build:AddRightGroupbox("Material")
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
local Z = {}
Z.Packets = nil
Z.PartCatalog = nil
Z.BuildUtils = nil
Z.SkillConfig = nil
Z.QuestConfig = nil
Z.TutorialConfig = nil
Z.RunConfig = nil
Z.BossConfig = nil
Z.BuildController = nil
Z.Skills = {}
Z.SkillsSynced = false
Z.Quests = nil
Z.QuestsSynced = false
Z.OfflineClaimed = false
Z.LastQueueEndsAt = nil
Z.StationList = {}
Z.BuildsFolder = "Yuri/Zombies/Builds"
Z.Session = {Rolls = 0, PartsPlaced = 0, SkillsBought = 0, QuestsClaimed = 0, Offline = 0, Battles = 0, BuildsLoaded = 0, BuildsSaved = 0}
local ZBuildGetSelection = nil
local ZBuildLabelToId = {}
local ZRollGetSelection = nil
local ZRollLabelToId = {}
local ZRollStationGetSelection = nil
local ZRollStationRefresh = nil
local ZRollStationValues = nil
local StatsCashLabel, StatsBuildLabel, StatsCarLabel, StatsBattleLabel, StatsSessionLabel = nil, nil, nil, nil, nil
local function ZModule(path)
    local obj = GetObject(RS, path)
    if obj and obj:IsA("ModuleScript") then
        local ok, result = pcall(require, obj)
        if ok and type(result) == "table" then return result end
    end
    return nil
end
local function ZLoad()
    if Z.Packets == nil then Z.Packets = ZModule("Packages.Packets") end
    if Z.PartCatalog == nil then Z.PartCatalog = ZModule("Shared.Data.PartCatalog") end
    if Z.BuildUtils == nil then Z.BuildUtils = ZModule("Shared.Utils.BuildUtils") end
    if Z.SkillConfig == nil then Z.SkillConfig = ZModule("Shared.Data.SkillConfig") end
    if Z.QuestConfig == nil then Z.QuestConfig = ZModule("Shared.Data.QuestConfig") end
    if Z.TutorialConfig == nil then Z.TutorialConfig = ZModule("Shared.Data.TutorialConfig") end
    if Z.RunConfig == nil then Z.RunConfig = ZModule("Shared.Data.RunConfig") end
    if Z.BossConfig == nil then Z.BossConfig = ZModule("Shared.Data.BossConfig") end
    if Z.BuildController == nil then Z.BuildController = ZModule("Controllers.BuildController") end
end
ZLoad()
local function ZFire(packet, ...)
    if packet == nil then return false end
    local args = {...}
    local ok, err = pcall(function()
        packet:Fire(unpack(args))
    end)
    if not ok then notyuri("ZFire error:", tostring(err)) end
    return ok
end
local function ZGetPlot()
    local Game = workspace:FindFirstChild("Game")
    local Lobby = Game and Game:FindFirstChild("Lobby")
    local Plots = Lobby and Lobby:FindFirstChild("Plots")
    if Plots == nil then return nil end
    for _, child in ipairs(Plots:GetChildren()) do
        if child:IsA("Model") and child:GetAttribute("OwnerUserId") == Plr.UserId then
            return child
        end
    end
    return nil
end
local function ZMyCar()
    local Cars = workspace:FindFirstChild("Cars")
    if Cars == nil then return nil end
    for _, child in ipairs(Cars:GetChildren()) do
        if child:IsA("Model") and child:GetAttribute("OwnerUserId") == Plr.UserId then
            return child
        end
    end
    return nil
end
local function ZStations(plot)
    local list = {}
    if plot == nil then return list end
    local Rolls = plot:FindFirstChild("Rolls")
    if Rolls == nil then return list end
    for _, folder in ipairs(Rolls:GetChildren()) do
        if folder:IsA("Folder") and folder:FindFirstChild("Roll") then
            table.insert(list, folder)
        end
    end
    table.sort(list, function(a, b) return a.Name < b.Name end)
    return list
end
local function ZStationPrompt(station)
    local rollPart = station:FindFirstChild("Roll")
    if rollPart and rollPart:IsA("BasePart") then
        local prompt = rollPart:FindFirstChildOfClass("ProximityPrompt")
        if prompt then return prompt end
    end
    return nil
end
local function ZStationBuyPrompt(station)
    local itemPlace = station:FindFirstChild("ItemPlace")
    local att = itemPlace and itemPlace:FindFirstChild("Attachment")
    local prompt = att and att:FindFirstChild("BuyPrompt")
    if prompt and prompt:IsA("ProximityPrompt") then return prompt end
    return nil
end
local function ZMirror()
    if Z.BuildController == nil then return nil end
    local ok, result = pcall(Z.BuildController.GetMirror)
    if ok and type(result) == "table" then return result end
    return nil
end
local function ZInventory()
    if Z.BuildController == nil then return nil end
    local ok, result = pcall(Z.BuildController.GetInventory)
    if ok and type(result) == "table" then return result end
    return nil
end
local function ZCanPlace(mirror, partId, x, y, z)
    if Z.BuildUtils == nil or mirror == nil then return false end
    local plot = ZGetPlot()
    local dims = plot and plot:GetAttribute("GridDims")
    local ok, can = pcall(Z.BuildUtils.CanPlace, mirror, partId, x, y, z, dims, Z.BuildUtils.BonusSlotsOf(Plr))
    if ok then return can == true end
    return false
end
local function ZTutorialDone()
    if Z.TutorialConfig == nil then return false end
    local raw = Plr:GetAttribute("Tutorial")
    local ok, step = pcall(Z.TutorialConfig.Resolve, raw)
    if ok and type(step) == "number" then
        return step >= Z.TutorialConfig.Complete
    end
    return false
end
local function ZCash()
    local cv = Plr:FindFirstChild("CashValue")
    if cv and cv:IsA("NumberValue") then return cv.Value end
    return 0
end
local function ZScanPlotBlocks(plot)
    local blocks = {}
    if plot == nil or Z.BuildUtils == nil then return blocks end
    local Parts = plot:FindFirstChild("Parts")
    if Parts == nil then return blocks end
    for _, child in ipairs(Parts:GetChildren()) do
        local x, y, zpos = Z.BuildUtils.ParseKey(child.Name)
        local partId = child:GetAttribute("PartId")
        if x ~= nil and type(partId) == "string" then
            local r = child:GetAttribute("R")
            table.insert(blocks, {Id = partId, X = x, Y = y, Z = zpos, R = type(r) == "number" and r or 0})
        end
    end
    return blocks
end
local function ZBlocksOfMirror()
    if Z.BuildUtils == nil then return nil end
    local mirror = ZMirror()
    if mirror == nil then return nil end
    local ok, result = pcall(Z.BuildUtils.Serialize, mirror)
    if ok and type(result) == "table" then return result end
    return nil
end
local function ZDecodeBuild(json)
    local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
    if ok and type(data) == "table" and type(data.blocks) == "table" then return data end
    return nil
end
local function ZListBuildFiles()
    local files = {}
    if not Support.FileIO or typeof(isfolder) ~= "function" then return files end
    pcall(function()
        if not isfolder(Z.BuildsFolder) then return end
        local list = listfiles(Z.BuildsFolder)
        for _, name in ipairs(list) do
            if name:sub(-5) == ".json" then
                local short = name:match("([^/\\]+)%.json$")
                if short then table.insert(files, short) end
            end
        end
    end)
    table.sort(files)
    return files
end
local function ZSaveBuildFile(name, blocks)
    if not name or name == "" then
        Library:Notify("Enter a file name first.", 3)
        return false
    end
    if not Support.FileIO then
        Library:Notify("File IO not supported by executor.", 4)
        return false
    end
    if blocks == nil or #blocks == 0 then
        Library:Notify("No placed parts to save.", 4)
        return false
    end
    local json = HttpService:JSONEncode({version = 1, count = #blocks, blocks = blocks})
    local path = Z.BuildsFolder .. "/" .. name .. ".json"
    pcall(function()
        if makefolder then pcall(makefolder, Z.BuildsFolder) end
        writefile(path, json)
    end)
    Library:Notify("Build saved: " .. name, 4)
    Z.Session.BuildsSaved = Z.Session.BuildsSaved + 1
    return true
end
local function ZReadBuildFile(name)
    if not Support.FileIO or not name or name == "" then return nil end
    local path = Z.BuildsFolder .. "/" .. name .. ".json"
    if not isfile(path) then return nil end
    local ok, json = pcall(readfile, path)
    if not ok or type(json) ~= "string" then return nil end
    return ZDecodeBuild(json)
end
local function ZAllPlots()
    local out = {}
    local Game = workspace:FindFirstChild("Game")
    local Lobby = Game and Game:FindFirstChild("Lobby")
    local Plots = Lobby and Lobby:FindFirstChild("Plots")
    if Plots == nil then return out end
    local myPlot = ZGetPlot()
    for _, plot in ipairs(Plots:GetChildren()) do
        if plot:IsA("Model") then
            local ownerId = plot:GetAttribute("OwnerUserId")
            local ownerName = "Empty"
            if type(ownerId) == "number" then
                local p = Players:GetPlayerByUserId(ownerId)
                if p then ownerName = p.Name end
            end
            table.insert(out, {plot = plot, ownerName = ownerName, isMine = plot == myPlot})
        end
    end
    table.sort(out, function(a, b) return a.ownerName < b.ownerName end)
    return out
end
local ZSourceLookup = {}
local function ZRefreshSources()
    if Options.BuildSource == nil then return end
    local values = {}
    ZSourceLookup = {}
    for _, entry in ipairs(ZAllPlots()) do
        local label = (entry.isMine and "[My Plot] " or "[Plot] ") .. entry.ownerName
        table.insert(values, label)
        ZSourceLookup[label] = {kind = "Plot", plot = entry.plot}
    end
    for _, fname in ipairs(ZListBuildFiles()) do
        local label = "[File] " .. fname
        table.insert(values, label)
        ZSourceLookup[label] = {kind = "File", name = fname}
    end
    Options.BuildSource:SetValues(values)
end
local function ZLoadSelectedSource()
    local sel = Options.BuildSource and Options.BuildSource.Value
    if not sel or sel == "" then return nil end
    local entry = ZSourceLookup[sel]
    if entry == nil then return nil end
    if entry.kind == "Plot" then
        local blocks = ZScanPlotBlocks(entry.plot)
        if #blocks == 0 then return nil end
        return {version = 1, count = #blocks, blocks = blocks}
    elseif entry.kind == "File" then
        return ZReadBuildFile(entry.name)
    end
    return nil
end
local function ZMaterialDisplay(data)
    if data == nil or type(data.blocks) ~= "table" then return "No build selected." end
    local reqs = {}
    for i = 1, #data.blocks do
        local b = data.blocks[i]
        if b.Id then reqs[b.Id] = (reqs[b.Id] or 0) + 1 end
    end
    local owned = {}
    local inv = ZInventory()
    if inv ~= nil then
        for partId, count in pairs(inv) do
            owned[partId] = (owned[partId] or 0) + count
        end
    end
    local mirror = ZMirror()
    if mirror ~= nil then
        for _, entry in pairs(mirror) do
            owned[entry.Id] = (owned[entry.Id] or 0) + 1
        end
    end
    local parts = {}
    for partId, need in pairs(reqs) do
        local have = owned[partId] or 0
        if have < need then
            local def = Z.PartCatalog and Z.PartCatalog.Parts[partId]
            local name = (def and def.Name) or partId
            table.insert(parts, name .. " (x" .. (need - have) .. ")")
        end
    end
    table.sort(parts)
    if #parts == 0 then return "Ready (" .. #data.blocks .. " parts)" end
    return "Missing: " .. table.concat(parts, ", ")
end
local ZAutoRollWorkers = {}
local function ZAutoRollStationWorker(stationName)
    while Toggles.AutoRoll.Value do
        local selected = ZRollStationGetSelection and ZRollStationGetSelection()
        if selected == nil or not selected[stationName] then
            break
        end
        ZLoad()
        if ZTutorialDone() then
            local plot = ZGetPlot()
            local station = nil
            if plot ~= nil then
                for _, st in ipairs(ZStations(plot)) do
                    if st.Name == stationName then
                        station = st
                    end
                end
            end
            local prompt = station and ZStationPrompt(station)
            local buyPrompt = station and ZStationBuyPrompt(station)
            if prompt ~= nil and buyPrompt ~= nil then
                local preRollText = buyPrompt.ObjectText
                FirePP(prompt, true)
                local waited = 0
                local gotResult = false
                while waited < 3 and Toggles.AutoRoll.Value do
                    if buyPrompt.ObjectText ~= preRollText and buyPrompt.ObjectText ~= "???" then
                        gotResult = true
                        break
                    end
                    task.wait(0.1)
                    waited = waited + 0.1
                end
                if not gotResult then
                    notyuri("AutoRoll: no ObjectText result for station", stationName, "within timeout")
                end
                local targets = ZRollGetSelection and ZRollGetSelection()
                local rolledId = nil
                if gotResult and Z.PartCatalog ~= nil then
                    for partId in pairs(Z.PartCatalog.Parts) do
                        if Z.PartCatalog.DisplayName(partId) == buyPrompt.ObjectText then
                            rolledId = partId
                            break
                        end
                    end
                end
                if gotResult and rolledId ~= nil then
                    Z.Session.Rolls = Z.Session.Rolls + 1
                end
                if gotResult and targets ~= nil and rolledId ~= nil and targets[rolledId] then
                    local def = Z.PartCatalog and Z.PartCatalog.Parts[rolledId]
                    local price = (def and def.Cost) or 0
                    while Toggles.AutoRoll.Value do
                        local cash = ZCash()
                        if cash < price then
                            task.wait(0.5)
                        else
                            FirePP(buyPrompt, true)
                            task.wait(0.3)
                            break
                        end
                    end
                end
                task.wait(3)
            end
        end
        task.wait(1)
    end
    ZAutoRollWorkers[stationName] = nil
end
local function Func_AutoRoll()
    while Toggles.AutoRoll.Value do
        local selected = ZRollStationGetSelection and ZRollStationGetSelection()
        if selected ~= nil then
            for stationName in pairs(selected) do
                if ZAutoRollWorkers[stationName] == nil then
                    ZAutoRollWorkers[stationName] = true
                    task.spawn(ZAutoRollStationWorker, stationName)
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoSkill()
    while Toggles.AutoSkill.Value do
        ZLoad()
        if Z.Packets ~= nil and Z.SkillConfig ~= nil and Z.SkillsSynced then
            local cash = ZCash()
            local nodes = Z.SkillConfig.Nodes
            for i = 1, #nodes do
                local node = nodes[i]
                if type(node.Cost) == "number" and node.Cost > 0 and cash >= node.Cost then
                    local ok, can = pcall(Z.SkillConfig.CanBuy, Z.Skills, node.Id)
                    if ok and can == true then
                        ZFire(Z.Packets.BuySkill, node.Id)
                        Z.Session.SkillsBought = Z.Session.SkillsBought + 1
                        task.wait(1)
                        break
                    end
                end
            end
        end
        task.wait(.5)
    end
end
local function Func_AutoQuest()
    while Toggles.AutoQuest.Value do
        ZLoad()
        if Z.Packets ~= nil and Z.QuestConfig ~= nil and Z.QuestsSynced and type(Z.Quests) == "table" then
            local quests = Z.QuestConfig.Quests
            for i = 1, #quests do
                local def = quests[i]
                local progress = (Z.Quests.Progress and Z.Quests.Progress[def.Id]) or 0
                local claimed = Z.Quests.Claimed and Z.Quests.Claimed[def.Id] == true
                if not claimed and progress >= def.Goal then
                    ZFire(Z.Packets.ClaimQuest, def.Id)
                    Z.Session.QuestsClaimed = Z.Session.QuestsClaimed + 1
                    task.wait(0.5)
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoOffline()
    while Toggles.AutoOffline.Value do
        if not Z.OfflineClaimed and Z.Packets ~= nil then
            local ok, json = pcall(function() return Z.Packets.OfflineData:Fire() end)
            if ok and type(json) == "string" and json ~= "" then
                local dok, data = pcall(HttpService.JSONDecode, HttpService, json)
                if dok and type(data) == "table" then
                    if data.ItemsClaimed == true then
                        Z.OfflineClaimed = true
                    else
                        ZFire(Z.Packets.ClaimOffline)
                        Z.OfflineClaimed = true
                        Z.Session.Offline = Z.Session.Offline + 1
                    end
                end
            end
        end
        task.wait(30)
    end
end
local function Func_AutoJoinBattle()
    while Toggles.AutoJoinBattle.Value do
        ZLoad()
        if Z.Packets ~= nil and Z.BossConfig ~= nil then
            local phaseAttr = Z.BossConfig.Attributes.Phase
            local queueAttr = Z.BossConfig.Attributes.QueueEndsAt
            local phase = workspace:GetAttribute(phaseAttr)
            local queueEnds = workspace:GetAttribute(queueAttr)
            if phase == "Queue" and type(queueEnds) == "number" and queueEnds ~= Z.LastQueueEndsAt
                and not (Plr:GetAttribute(Z.BossConfig.Attributes.InBattle) == true) and ZTutorialDone() then
                Z.LastQueueEndsAt = queueEnds
                ZFire(Z.Packets.JoinBattle)
                Z.Session.Battles = Z.Session.Battles + 1
            end
        end
        task.wait(2)
    end
end
local function Func_AutoSit()
    while Toggles.AutoSit.Value do
        local car = ZMyCar()
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if car and hum and hum.SeatPart == nil and hum.Health > 0 then
            local seat = car:FindFirstChildWhichIsA("Seat", true)
            if seat then FireTI(seat) end
        end
        task.wait(0.5)
    end
end
local function ZBuildDriveRaycastParams(car)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {}
    if car then table.insert(filter, car) end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then table.insert(filter, plr.Character) end
    end
    for _, inst in ipairs(Services.CollectionService:GetTagged("CarRayIgnore")) do
        table.insert(filter, inst)
    end
    params.FilterDescendantsInstances = filter
    return params
end
local ZDriveRunOrigin = nil
local ZDriveRunAxis = nil
local ZDriveRunCar = nil
local function Func_AutoDrive()
    while Toggles.AutoDrive.Value do
        ZLoad()
        local car = ZMyCar()
        if car == nil and Z.Packets ~= nil then
            local char = GetCharacter()
            if char ~= nil then
                task.wait(1)
                ZFire(Z.Packets.SpawnCar)
            else
                task.wait(0.5)
            end
        end
        local root = car and car.PrimaryPart
        if root ~= nil then
            local speed = tonumber(Options.DriveSpeed and Options.DriveSpeed.Value or 50) or 50
            local mode = Options.DriveDirection and Options.DriveDirection.Value or "Track Axis"
            local dir = nil
            if mode == "Car Forward" then
                local look = root.CFrame.LookVector
                dir = Vector3.new(look.X, 0, look.Z)
            else
                local axis = Z.RunConfig and Z.RunConfig.DistanceAxis or Vector3.new(1, 0, 0)
                dir = Vector3.new(axis.X, 0, axis.Z)
            end
            if dir.Magnitude < 0.001 then dir = Vector3.new(1, 0, 0) end
            dir = dir.Unit
            if ZDriveRunCar ~= car then
                ZDriveRunCar = car
                local runOrigin = car:GetAttribute("RunOrigin")
                ZDriveRunOrigin = if typeof(runOrigin) == "Vector3" then runOrigin else root.Position
                local runAxis = car:GetAttribute("RunAxis")
                ZDriveRunAxis = if typeof(runAxis) == "Vector3" and runAxis.Magnitude > 0 then runAxis.Unit else dir
            end
            local stopDistance = tonumber(Options.DriveStopDistance and Options.DriveStopDistance.Value or "") or 0
            if stopDistance > 0 then
                local delta = root.Position - ZDriveRunOrigin
                local traveled = Vector3.new(delta.X, 0, delta.Z):Dot(Vector3.new(ZDriveRunAxis.X, 0, ZDriveRunAxis.Z))
                if traveled >= stopDistance then
                    if Z.Packets ~= nil then ZFire(Z.Packets.DespawnCar) end
                    ZDriveRunCar = nil
                    task.wait(0.1)
                    continue
                end
            end
            local rayParams = ZBuildDriveRaycastParams(car)
            local origin = root.Position
            local groundHit = workspace:Raycast(origin, Vector3.new(0, -50, 0), rayParams)
            if groundHit then
                local height = tonumber(Options.DriveHeight and Options.DriveHeight.Value or 200) or 200
                local desiredY = groundHit.Position.Y + height
                local diff = desiredY - root.Position.Y
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, diff * 10, root.AssemblyLinearVelocity.Z)
            end
            local forwardHit = workspace:Raycast(origin, dir * 12, rayParams)
            if forwardHit then
                local look = root.CFrame.LookVector
                local right = root.CFrame.RightVector
                local flatLook = Vector3.new(look.X, 0, look.Z)
                local flatRight = Vector3.new(right.X, 0, right.Z)
                if flatLook.Magnitude > 0.01 and flatRight.Magnitude > 0.01 then
                    dir = flatRight.Unit
                end
            end
            local v = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(dir.X * speed, v.Y, dir.Z * speed)
            task.wait(0.03)
        else
            task.wait(0.5)
        end
    end
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        ZLoad()
        if Z.Packets ~= nil and Z.PartCatalog ~= nil and Z.BuildUtils ~= nil and ZTutorialDone() then
            local plot = ZGetPlot()
            local mirror = ZMirror()
            local inv = ZInventory()
            if plot ~= nil and mirror ~= nil and inv ~= nil then
                local dims = plot:GetAttribute("GridDims") or Z.BuildUtils.PLOT_DIMS
                local selection = ZBuildGetSelection()
                local ids = {}
                for partId, active in pairs(selection) do
                    if active and inv[partId] and inv[partId] > 0 then table.insert(ids, partId) end
                end
                table.sort(ids)
                local rotation = Options.PlaceRotation and math.floor(Options.PlaceRotation.Value + 0.5) or 0
                local attempted = {}
                for _, partId in ipairs(ids) do
                    if not Toggles.AutoPlace.Value then break end
                    local remaining = inv[partId] or 0
                    for y = 0, math.floor(dims.Y) - 1 do
                        if remaining <= 0 or not Toggles.AutoPlace.Value then break end
                        for x = 0, math.floor(dims.X) - 1 do
                            if remaining <= 0 or not Toggles.AutoPlace.Value then break end
                            for zpos = 0, math.floor(dims.Z) - 1 do
                                if remaining <= 0 or not Toggles.AutoPlace.Value then break end
                                local key = Z.BuildUtils.Key(x, y, zpos)
                                if mirror[key] == nil and attempted[key] == nil then
                                    if ZCanPlace(mirror, partId, x, y, zpos) then
                                        ZFire(Z.Packets.PlacePart, partId, x, y, zpos, rotation, 0)
                                        local t0 = os.clock()
                                        local confirmed = false
                                        while os.clock() - t0 < 0.4 and Toggles.AutoPlace.Value do
                                            if mirror[key] ~= nil then
                                                confirmed = true
                                                break
                                            end
                                            task.wait(0.05)
                                        end
                                        if confirmed then
                                            remaining = remaining - 1
                                            Z.Session.PartsPlaced = Z.Session.PartsPlaced + 1
                                            task.wait(0.15)
                                        else
                                            attempted[key] = true
                                        end
                                    else
                                        attempted[key] = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_LoadBuild()
    while Toggles.LoadBuild.Value do
        ZLoad()
        local data = ZLoadSelectedSource()
        if data == nil then
            notyuri("[LoadBuild] no data from ZLoadSelectedSource, source:", Options.BuildSource and Options.BuildSource.Value)
            Library:Notify("Select a build source first.", 3)
            task.wait()
        else
            local plot = ZGetPlot()
            local mirror = ZMirror()
            local inv = ZInventory()
            notyuri("[LoadBuild] plot:", plot ~= nil, "mirror:", mirror ~= nil, "inv:", inv ~= nil, "BuildUtils:", Z.BuildUtils ~= nil, "PartCatalog:", Z.PartCatalog ~= nil)
            notyuri("[LoadBuild] Z.Packets identity:", tostring(Z.Packets), "PlacePart identity:", tostring(Z.Packets and Z.Packets.PlacePart))
            if plot == nil or mirror == nil or inv == nil or Z.BuildUtils == nil or Z.PartCatalog == nil then
                notyuri("[LoadBuild] missing prerequisite, retrying")
                task.wait()
            else
                local invCount = 0
                for _ in pairs(inv) do invCount = invCount + 1 end
                if invCount == 0 then
                    notyuri("[LoadBuild] inventory is empty (BuildController may not have synced yet), retrying")
                    task.wait()
                else
                    Z.Session.BuildsLoaded = Z.Session.BuildsLoaded + 1
                    local blocks = {}
                    for i = 1, #data.blocks do
                        local b = data.blocks[i]
                        if Z.PartCatalog.Parts[b.Id] then
                            table.insert(blocks, {Id = b.Id, X = b.X, Y = b.Y, Z = b.Z, R = b.R or 0})
                        else
                            notyuri("[LoadBuild] skipping unknown PartId in source data:", tostring(b.Id))
                        end
                    end
                    table.sort(blocks, function(a, b) return a.Y < b.Y end)
                    local ownedNow = {}
                    for partId, count in pairs(inv) do
                        ownedNow[partId] = (ownedNow[partId] or 0) + count
                    end
                    notyuri("[LoadBuild] starting, blocks:", #blocks, "inventory entries:", invCount)
                    local placedCount = 0
                    local skipped = 0
                    for i = 1, #blocks do
                        if not Toggles.LoadBuild.Value then
                            notyuri("[LoadBuild] toggle off, stopping at block", i)
                            break
                        end
                        local b = blocks[i]
                        local owned = ownedNow[b.Id] or 0
                        if owned <= 0 then
                            notyuri("[LoadBuild] skipping", b.Id, "block", i, "- not owned")
                            skipped = skipped + 1
                        else
                            local key = Z.BuildUtils.Key(b.X, b.Y, b.Z)
                            if mirror[key] ~= nil then
                                notyuri("[LoadBuild] skipping", b.Id, "block", i, "- cell occupied", key)
                                skipped = skipped + 1
                            elseif not ZCanPlace(mirror, b.Id, b.X, b.Y, b.Z) then
                                notyuri("[LoadBuild] skipping", b.Id, "block", i, "- CanPlace rejected", key)
                                skipped = skipped + 1
                            else
                                notyuri("[LoadBuild] firing PlacePart", b.Id, b.X, b.Y, b.Z, b.R, "owned:", owned)
                                notyuri("[LoadBuild] PlacePart packet:", tostring(Z.Packets.PlacePart), "Writes:", tostring(Z.Packets.PlacePart and Z.Packets.PlacePart.Writes), "#Writes:", Z.Packets.PlacePart and Z.Packets.PlacePart.Writes and #Z.Packets.PlacePart.Writes)
                                local fired = ZFire(Z.Packets.PlacePart, b.Id, b.X, b.Y, b.Z, b.R, 0)
                                if not fired then
                                    notyuri("[LoadBuild] ZFire returned false for", b.Id, "block", i)
                                    skipped = skipped + 1
                                else
                                    local t0 = os.clock()
                                    local confirmed = false
                                    while os.clock() - t0 < 0.5 and Toggles.LoadBuild.Value do
                                        if mirror[key] ~= nil then
                                            confirmed = true
                                            break
                                        end
                                        task.wait()
                                    end
                                    if confirmed then
                                        ownedNow[b.Id] = ownedNow[b.Id] - 1
                                        placedCount = placedCount + 1
                                        Z.Session.PartsPlaced = Z.Session.PartsPlaced + 1
                                        task.wait()
                                    else
                                        notyuri("[LoadBuild] placement not confirmed within timeout for", b.Id, key)
                                        skipped = skipped + 1
                                    end
                                end
                            end
                        end
                    end
                    notyuri("[LoadBuild] done. placed:", placedCount, "skipped:", skipped)
                    Toggles.LoadBuild:SetValue(false)
                    Library:Notify(("Done: %d placed, %d skipped."):format(placedCount, skipped), 5)
                end
            end
        end
        task.wait()
    end
end
local function ZRefreshStations()
    local plot = ZGetPlot()
    local stations = ZStations(plot)
    Z.StationList = stations
    local names = {}
    for _, st in ipairs(stations) do table.insert(names, st.Name) end
    if ZRollStationValues ~= nil then
        table.clear(ZRollStationValues)
        for _, n in ipairs(names) do
            table.insert(ZRollStationValues, n)
        end
        if ZRollStationRefresh then ZRollStationRefresh() end
    end
    local tp = {"My Plot"}
    for _, n in ipairs(names) do table.insert(tp, "Roll: " .. n) end
    table.insert(tp, "My Car")
    if Options.TeleportTarget then
        Options.TeleportTarget:SetValues(tp)
        local cur = Options.TeleportTarget.Value
        if cur == nil or cur == "" or table.find(tp, cur) == nil then
            Options.TeleportTarget:SetValue(tp[1])
        end
    end
end
local function ZDoTeleport()
    local sel = Options.TeleportTarget and Options.TeleportTarget.Value
    if not sel or sel == "" then return end
    if sel == "My Plot" then
        local plot = ZGetPlot()
        if plot then
            TPTo(plot)
        else
            
        end
    elseif sel == "My Car" then
        local car = ZMyCar()
        if car then
            TPTo(car)
        else
            
        end
    elseif sel:sub(1, 5) == "Roll:" then
        local stationName = sel:sub(7)
        local plot = ZGetPlot()
        local stations = ZStations(plot)
        for _, st in ipairs(stations) do
            if st.Name == stationName then
                local rollPart = st:FindFirstChild("Roll")
                if rollPart then TPTo(rollPart) end
                return
            end
        end
        
    end
end
local MatLabel = nil
local ZRebuildBuildLabels = nil
local ZRebuildRollLabels = nil
local ZUpdateMaterialLabel = nil
local ZBuildRefresh = nil
local ZBuildValues = nil
local ZRollRefresh = nil
local ZRollValues = nil
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSkill", { Text = "Auto Skill", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoQuest", { Text = "Auto Quests", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoJoinBattle", { Text = "Auto Join Battle", Default = false })
TB_Tabs.Autofarm.T1:AddDivider()
TB_Tabs.Autofarm.T1:AddToggle("AutoDrive", { Text = "Auto Drive", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place Parts", Default = false })
TB_Tabs.Autofarm.T1:AddDivider()
ZBuildGetSelection, ZBuildRefresh, ZBuildValues = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "BuildList", { Text = "Parts To Place", Values = {}, label = ZBuildLabelToId, Default = {} })
TB_Tabs.Autofarm2.T1:AddInput("PlaceRotation", { Text = "Place Rotation", Default = "0" })
A1:AddDropdown("BuildSource", {
    Text = "Build Source",
    Values = {},
    Default = "",
    Multi = false,
    Searchable = true,
})
A1:AddToggle("LoadBuild", {Text = "Load Build", Default = false})
A1:AddInput("BuildSaveName", {
    Text = "File Name",
    Default = "",
    Placeholder = "yuriyuri",
})
A1:AddButton({
    Text = "Save Build",
    Func = function()
        local blocks = ZBlocksOfMirror()
        if blocks == nil then
            Library:Notify("No placed parts to save.", 4)
            return
        end
        local name = Options.BuildSaveName and Options.BuildSaveName.Value or ""
        if ZSaveBuildFile(name, blocks) then
            ZRefreshSources()
        end
    end,
})
A1:AddButton({
    Text = "Save Selected",
    Func = function()
        local name = Options.BuildSaveName and Options.BuildSaveName.Value or ""
        local data = ZLoadSelectedSource()
        if data == nil then
            Library:Notify("Select a build source first.", 3)
            return
        end
        if ZSaveBuildFile(name, data.blocks) then
            ZRefreshSources()
        end
    end,
})
MatLabel = A2:AddLabel("No build selected.", true)
ZRollStationGetSelection, ZRollStationRefresh, ZRollStationValues = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "RollStation", {
    Text = "Roll Station",
    Values = {},
    Default = {["All"] = true},
})
ZRollGetSelection, ZRollRefresh, ZRollValues = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "RollTargetSelected", {
    Text = "Roll Target",
    Values = {},
    label = ZRollLabelToId,
    Default = {["All"] = true},
})
TB_Tabs.Autofarm2.T1:AddInput("DriveSpeed", { Text = "Drive Speed", Default = "100" })
TB_Tabs.Autofarm2.T1:AddDropdown("DriveDirection", { Text = "Drive Direction", Values = { "Track Axis", "Car Forward" }, Default = "Track Axis" })
TB_Tabs.Autofarm2.T1:AddInput("DriveHeight", { Text = "Drive Height", Default = "1" })
TB_Tabs.Autofarm2.T1:AddInput("DriveStopDistance", { Text = "Stop Distance", Default = "2000" })
ZRebuildBuildLabels = function()
    ZLoad()
    if Z.PartCatalog == nil then return end
    local list = {}
    for partId in pairs(Z.PartCatalog.Parts) do
        table.insert(list, partId)
    end
    local rarityIndex = {}
    for i, r in ipairs(Z.PartCatalog.Rarities) do rarityIndex[r] = i end
    table.sort(list, function(a, b)
        local da = Z.PartCatalog.Parts[a]
        local db = Z.PartCatalog.Parts[b]
        local ra = rarityIndex[da.Rarity] or 99
        local rb = rarityIndex[db.Rarity] or 99
        if ra ~= rb then return ra < rb end
        return da.Name < db.Name
    end)
    table.clear(ZBuildValues)
    table.clear(ZBuildLabelToId)
    for _, partId in ipairs(list) do
        local def = Z.PartCatalog.Parts[partId]
        local label = def.Name .. " | " .. def.Rarity
        table.insert(ZBuildValues, label)
        ZBuildLabelToId[label] = partId
    end
    if ZBuildRefresh then ZBuildRefresh() end
end
ZRebuildRollLabels = function()
    ZLoad()
    if Z.PartCatalog == nil then return end
    local list = {}
    for partId in pairs(Z.PartCatalog.Parts) do
        table.insert(list, partId)
    end
    local rarityIndex = {}
    for i, r in ipairs(Z.PartCatalog.Rarities) do rarityIndex[r] = i end
    table.sort(list, function(a, b)
        local da = Z.PartCatalog.Parts[a]
        local db = Z.PartCatalog.Parts[b]
        local ra = rarityIndex[da.Rarity] or 99
        local rb = rarityIndex[db.Rarity] or 99
        if ra ~= rb then return ra < rb end
        return da.Name < db.Name
    end)
    table.clear(ZRollValues)
    table.clear(ZRollLabelToId)
    for _, partId in ipairs(list) do
        local def = Z.PartCatalog.Parts[partId]
        local label = def.Name .. " | " .. def.Rarity
        table.insert(ZRollValues, label)
        ZRollLabelToId[label] = partId
    end
    if ZRollRefresh then ZRollRefresh() end
end
ZUpdateMaterialLabel = function()
    if MatLabel == nil then return end
    local data = ZLoadSelectedSource()
    MatLabel:SetText(ZMaterialDisplay(data))
end
Toggles.AutoRoll:OnChanged(function(state)
    Thread("Z.AutoRoll", SafeLoop("AutoRoll", Func_AutoRoll), state)
end)
Toggles.AutoSkill:OnChanged(function(state)
    Thread("Z.AutoSkill", SafeLoop("AutoSkill", Func_AutoSkill), state)
end)
Toggles.AutoQuest:OnChanged(function(state)
    Thread("Z.AutoQuest", SafeLoop("AutoQuest", Func_AutoQuest), state)
end)
Toggles.AutoJoinBattle:OnChanged(function(state)
    Thread("Z.AutoJoinBattle", SafeLoop("AutoJoinBattle", Func_AutoJoinBattle), state)
end)
Toggles.AutoDrive:OnChanged(function(state)
    Thread("Z.AutoDrive", SafeLoop("AutoDrive", Func_AutoDrive), state)
end)
Toggles.AutoPlace:OnChanged(function(state)
    Thread("Z.AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), state)
end)
Toggles.LoadBuild:OnChanged(function(state)
    Thread("Z.LoadBuild", SafeLoop("LoadBuild", Func_LoadBuild), state)
end)
if Options.BuildSource then
    Options.BuildSource:OnChanged(function()
        ZUpdateMaterialLabel()
    end)
end
task.spawn(function()
    local waited = 0
    while waited < 60 and not Library.Unloaded do
        if workspace:GetAttribute("ServerLoaded") then break end
        task.wait(1)
        waited = waited + 1
    end
    ZLoad()
    if Z.Packets ~= nil then
        pcall(function()
            Connections["Z.Skills"] = Z.Packets.SkillsChanged.OnClientEvent:Connect(function(payload)
                local ok, result = pcall(HttpService.JSONDecode, HttpService, payload)
                if ok and type(result) == "table" then
                    Z.Skills = {}
                    Z.SkillsSynced = true
                    for _, id in ipairs(result) do Z.Skills[id] = true end
                end
            end)
        end)
        pcall(function()
            Connections["Z.Quests"] = Z.Packets.QuestsChanged.OnClientEvent:Connect(function(payload)
                local ok, result = pcall(HttpService.JSONDecode, HttpService, payload)
                if ok and type(result) == "table" then
                    Z.Quests = result
                    Z.QuestsSynced = true
                end
            end)
        end)
        for i = 1, 5 do
            ZFire(Z.Packets.RequestInventory)
            task.wait(2)
            local inv = ZInventory()
            if inv ~= nil and next(inv) ~= nil then break end
        end
        ZFire(Z.Packets.RequestSkills)
        ZFire(Z.Packets.RequestQuests)
    end
    ZRefreshStations()
    ZRefreshSources()
    ZRebuildBuildLabels()
    ZRebuildRollLabels()
    ZUpdateMaterialLabel()
    task.spawn(function()
        while not Library.Unloaded do
            task.wait(10)
            ZRefreshStations()
        end
    end)
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
    Shared.Farm = false
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
SaveManager:SetFolder("Yuri/BAKZ")
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
