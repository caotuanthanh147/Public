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
    local function refresh(newBaseValues, newLabelId)
        if newBaseValues ~= nil then
            baseValues = newBaseValues
            labelId = newLabelId
        end
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
local Seed = {}
Seed.Data = nil
Seed.Ready = false
Seed.SRE = nil
Seed.GpState = nil
Seed.GpTime = nil
Seed.PlayConfig = nil
Seed.MainBusiness = nil
Seed.BigNumber = nil
Seed.ServerInstanceData = nil
Seed.TrainEntered = false
Seed.Session = {Steals = 0, Plants = 0, Takes = 0, Places = 0, Merges = 0, Waters = 0, Buys = 0, Unlocks = 0}
local STR_XITONG = "\231\179\187\231\187\159"
local STR_PLACE_UNIT = "\230\148\190\231\189\174_\229\141\149\228\189\141"
local STR_EQUIP_BEST = "\232\163\133\229\164\135\230\156\128\229\165\189_\229\141\149\228\189\141"
local STR_UNIT = "\229\141\149\228\189\141"
local STR_ITEM = "\233\129\147\229\133\183"
local STR_TRAIN = "\232\174\173\231\187\131\230\156\186\229\153\168"
local STR_TRAIN_UP = "\232\174\173\231\187\131\230\156\186\229\153\168\232\167\163\233\148\129\229\141\135\231\186\167"
local INCUBATION_SIZE = 24
local SCENE_SIZE = 12
local function SeedFire(name, ...)
    if Seed.SRE == nil then return false end
    return FireRemote(Seed.SRE, name, ...)
end
local function SeedTypeId(key)
    if Seed.PlayConfig == nil then return nil end
    return Seed.PlayConfig[key]
end
local function SeedTrapped()
    local d = Seed.Data
    local player = d and d.player
    if player == nil then return false end
    local tEnd = player:GetAttribute("UseItemTrapEndTime")
    if type(tEnd) == "number" then
        return workspace:GetServerTimeNow() < tEnd
    end
    return false
end
local function SeedCarrying()
    local d = Seed.Data
    local player = d and d.player
    if player == nil then return false end
    local gid = player:GetAttribute("TempEnemyEggGid")
    return type(gid) == "number" and gid > 0
end
local function SeedGpActive()
    return Seed.GpState ~= nil and Seed.GpState.Value == 1
end
local function SeedCard(d, gid)
    if d == nil or gid == nil or gid <= 0 then return nil end
    local card = d.playData.allCard[gid]
    if type(card) ~= "table" then return nil end
    return card
end
local function SeedFindFreeChunk(d)
    for i = 1, INCUBATION_SIZE do
        local gid = d.serverData.incubationChunk[i] or 0
        if gid == 0 then return i end
    end
    return nil
end
local function SeedFindFreeSlot(d)
    for i = 1, SCENE_SIZE do
        if d.serverData.sceneUnitChunkUnlock[i] == true then
            local gid = d.serverData.sceneUnit[i] or 0
            if gid == 0 then return i end
        end
    end
    return nil
end
local function SeedEnsureHandSelected(d, gid)
    local showSize = SeedTypeId("handShowSize") or 5
    local hand = d.serverData.hand
    local index = nil
    for i = 1, #hand do
        if hand[i] == gid then
            index = i
            break
        end
    end
    if index == nil then return false end
    if index > showSize then
        SeedFire("ChangeHandUnit", gid)
        task.wait(0.3)
        index = nil
        local handNow = d.serverData.hand
        for i = 1, #handNow do
            if handNow[i] == gid then
                index = i
                break
            end
        end
        if index == nil or index > showSize then return false end
    end
    if d.playData.nowHand.Value ~= index then
        SeedFire("SelectHandUnit", index)
        task.wait(0.25)
        if d.playData.nowHand.Value ~= index then return false end
    end
    return true
end
local function SeedHandEggGid(d)
    local eggType = SeedTypeId("EggTypeId")
    if eggType == nil then return nil end
    local nowHand = d.playData.nowHand.Value
    if nowHand < 1 then return nil end
    local hand = d.serverData.hand
    local gid = hand[nowHand]
    local card = SeedCard(d, gid)
    if card ~= nil and card.typeId == eggType then return gid end
    local showSize = SeedTypeId("handShowSize") or 5
    for i = 1, math.min(showSize, #hand) do
        local g = hand[i]
        local c = SeedCard(d, g)
        if c ~= nil and c.typeId == eggType then return g end
    end
    return nil
end
local function SeedPlantCarried(d)
    local chunk = SeedFindFreeChunk(d)
    if chunk == nil then return false end
    local player = d.player
    local carried = player and player:GetAttribute("TempEnemyEggGid")
    if type(carried) == "number" and carried > 0 then
        pcall(function() SeedEnsureHandSelected(d, carried) end)
    else
        local eggGid = SeedHandEggGid(d)
        if eggGid ~= nil then
            pcall(function() SeedEnsureHandSelected(d, eggGid) end)
        end
    end
    local cf = d.onlyData.incubationChunk_CFrame[chunk]
    if cf ~= nil then
        TPTo(cf)
        task.wait(0.1)
    end
    if SeedFire("PlantEgg", chunk) then
        Seed.Session.Plants = Seed.Session.Plants + 1
        return true
    end
    return false
end
local function SeedUnitValue(d, card)
    if Seed.MainBusiness == nil or Seed.BigNumber == nil then return nil end
    local ok, res = pcall(function()
        return Seed.MainBusiness.Get_WinsOneTime(d.playData.bestUnitWinsOneTime.Value, card)
    end)
    if ok and res ~= nil then return res end
    return nil
end
local function SeedBestHandUnit(d)
    local unitType = SeedTypeId("UnitTypeId")
    if unitType == nil then return nil end
    local hand = d.serverData.hand
    local bestGid = nil
    local bestVal = nil
    local bestStar = -1
    local bestKg = -1
    for i = 1, #hand do
        local gid = hand[i]
        local card = SeedCard(d, gid)
        if card ~= nil and card.typeId == unitType and card.isLock ~= true then
            local val = SeedUnitValue(d, card)
            local better = false
            if bestGid == nil then
                better = true
            elseif val ~= nil and bestVal ~= nil and Seed.BigNumber ~= nil then
                if Seed.BigNumber.BigCompare(val, bestVal) then better = true end
            elseif (card.star or 0) > bestStar then
                better = true
            end
            if better then
                bestGid = gid
                bestVal = val
                bestStar = card.star or 0
                bestKg = card.kg or 0
            end
        end
    end
    return bestGid
end
local function SeedBestOwnedWater(d)
    if Seed.PlayConfig == nil then return nil end
    local best = nil
    for cfgId, item in pairs(Seed.PlayConfig.allUseItem) do
        if type(item) == "table" and item.useType == 1 and (item.addGrowthTime or 0) > 0 then
            local gid = d.serverData.allUseItemGid[cfgId] or 0
            if gid > 0 then
                local card = SeedCard(d, gid)
                if card ~= nil and (card.size or 0) > 0 then
                    if best == nil or item.addGrowthTime > best.addGrowthTime then
                        best = {cfgId = cfgId, gid = gid, addGrowthTime = item.addGrowthTime, name = item.name}
                    end
                end
            end
        end
    end
    return best
end
local function SeedEnsureUseItemSelected(d, gid)
    local itemType = SeedTypeId("UseItemTypeId")
    if itemType == nil then return false end
    local nowHand = d.playData.nowHand.Value
    local hand = d.serverData.hand
    local current = hand[nowHand]
    if current == gid and d.playData.nowHandTypeId.Value == itemType then return true end
    SeedFire("Equip_GidData_Item", STR_ITEM, gid)
    task.wait(0.25)
    local nowHand2 = d.playData.nowHand.Value
    if hand[nowHand2] == gid and d.playData.nowHandTypeId.Value == itemType then return true end
    return false
end
local AutoStealGetRaritySelection, AutoStealRefreshRarity, AutoStealRarityBase = nil, nil, nil
local function FuncSteal()
    while Toggles.AutoSteal.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil then
                task.wait()
                return
            end
            if SeedTrapped() then
                task.wait()
                return
            end
            if SeedCarrying() then
                TPTo(Vector3.new(-13, 4, 11))
                task.wait()
                return
            end
            if not SeedGpActive() then
                task.wait()
                return
            end
            local root = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if root == nil then
                task.wait()
                return
            end
            local rarityFilter = nil
            if AutoStealGetRaritySelection ~= nil then
                local sel = AutoStealGetRaritySelection()
                if next(sel) ~= nil then rarityFilter = sel end
            end
            local bestGid = nil
            local bestDist = math.huge
            local bestCf = nil
            for gid, egg in pairs(d.onlyData.enemyEggItemByGid) do
                if type(egg) == "table" and egg.isDropping ~= true and egg.cf ~= nil then
                    local passesRarity = true
                    if rarityFilter ~= nil then
                        passesRarity = false
                        local eggData = egg.data
                        if eggData ~= nil and eggData.cfgId ~= nil and Seed.PlayConfig ~= nil then
                            local rollCfg = Seed.PlayConfig.allRollEgg and Seed.PlayConfig.allRollEgg[eggData.cfgId]
                            if rollCfg ~= nil and rollCfg.rarity ~= nil and rarityFilter[rollCfg.rarity] then
                                passesRarity = true
                            end
                        end
                    end
                    if passesRarity then
                        local dist = (egg.cf.Position - root.Position).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            bestGid = gid
                            bestCf = egg.cf
                        end
                    end
                end
            end
            if bestGid == nil then
                task.wait(0.5)
                return
            end
            TPTo(bestCf)
            task.wait(0.2)
            if SeedFire("StealEnemyEgg", bestGid) then
                local waited = 0
                while waited < 1.5 and Toggles.AutoSteal.Value do
                    task.wait()
                    waited = waited + 0.1
                    if SeedCarrying() then
                        Seed.Session.Steals = Seed.Session.Steals + 1
                        break
                    end
                end
            end
            task.wait()
        end)
        if not ok then
            notyuri("Error in [Seed.Steal]: " .. tostring(err))
        end
        task.wait(0.1)
    end
end
local function FuncPlant()
    while Toggles.AutoPlant.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil then
                task.wait(1)
                return
            end
            local eggType = SeedTypeId("EggTypeId")
            if eggType == nil then
                task.wait(1)
                return
            end
            if SeedCarrying() then
                SeedPlantCarried(d)
                task.wait(0.5)
                return
            end
            local eggGid = SeedHandEggGid(d)
            if eggGid == nil then
                task.wait(1)
                return
            end
            local chunk = SeedFindFreeChunk(d)
            if chunk == nil then
                task.wait(2)
                return
            end
            if SeedEnsureHandSelected(d, eggGid) then
                local cf = d.onlyData.incubationChunk_CFrame[chunk]
                if cf ~= nil then
                    TPTo(cf)
                    task.wait(0.2)
                end
                if SeedFire("PlantEgg", chunk) then
                    Seed.Session.Plants = Seed.Session.Plants + 1
                end
            end
            task.wait()
        end)
        if not ok then
            notyuri("Error in [Seed.Plant]: " .. tostring(err))
        end
        task.wait(0.15)
    end
end
local function FuncTake()
    while Toggles.AutoTake.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil then
                task.wait(1)
                return
            end
            local eggType = SeedTypeId("EggTypeId")
            if eggType == nil then
                task.wait(1)
                return
            end
            local now = workspace:GetServerTimeNow()
            local ready = {}
            for i = 1, INCUBATION_SIZE do
                local gid = d.serverData.incubationChunk[i] or 0
                if gid > 0 then
                    local card = SeedCard(d, gid)
                    if card ~= nil and card.typeId == eggType then
                        local eggTime = card.eggTime
                        if type(eggTime) == "number" and eggTime > 0 and eggTime <= now then
                            table.insert(ready, i)
                        end
                    end
                end
            end
            if #ready == 0 then
                task.wait(0.5)
                return
            end
            local cf = d.onlyData.incubationChunk_CFrame[ready[1]]
            if cf ~= nil then
                TPTo(cf)
                task.wait(0.2)
            end
            for _, chunk in ipairs(ready) do
                if not Toggles.AutoTake.Value then break end
                if SeedFire("TakeIncubationUnit", chunk) then
                    Seed.Session.Takes = Seed.Session.Takes + 1
                end
                task.wait()
            end
        end)
        if not ok then
            notyuri("Error in [Seed.Take]: " .. tostring(err))
        end
        task.wait()
    end
end
local function FuncPlace()
    while Toggles.AutoPlace.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil then
                task.wait(1)
                return
            end
            local slot = SeedFindFreeSlot(d)
            local unitGid = nil
            if slot ~= nil then
                unitGid = SeedBestHandUnit(d)
            else
                local unitType = SeedTypeId("UnitTypeId")
                if unitType == nil then
                    task.wait(1)
                    return
                end
                local worstSlot = nil
                local worstVal = nil
                for i = 1, SCENE_SIZE do
                    if d.serverData.sceneUnitChunkUnlock[i] == true then
                        local placedGid = d.serverData.sceneUnit[i] or 0
                        if placedGid > 0 then
                            local placedCard = SeedCard(d, placedGid)
                            if placedCard ~= nil then
                                local placedVal = SeedUnitValue(d, placedCard)
                                if placedVal ~= nil and Seed.BigNumber ~= nil then
                                    if worstSlot == nil or Seed.BigNumber.BigCompare(worstVal, placedVal) then
                                        worstSlot = i
                                        worstVal = placedVal
                                    end
                                end
                            end
                        end
                    end
                end
                if worstSlot == nil or worstVal == nil then
                    task.wait(1)
                    return
                end
                local hand = d.serverData.hand
                local showSize = SeedTypeId("handShowSize") or 5
                local bestGid = nil
                local bestVal = nil
                for i = 1, math.min(showSize, #hand) do
                    local gid = hand[i]
                    local card = SeedCard(d, gid)
                    if card ~= nil and card.typeId == unitType and card.isLock ~= true then
                        local val = SeedUnitValue(d, card)
                        if val ~= nil and Seed.BigNumber ~= nil then
                            if bestVal == nil or Seed.BigNumber.BigCompare(val, bestVal) then
                                bestGid = gid
                                bestVal = val
                            end
                        end
                    end
                end
                if bestGid ~= nil and bestVal ~= nil and Seed.BigNumber.BigCompare(bestVal, worstVal) then
                    slot = worstSlot
                    unitGid = bestGid
                end
            end
            if slot == nil or unitGid == nil then
                task.wait(2)
                return
            end
            if SeedEnsureHandSelected(d, unitGid) then
                if SeedFire("BusinessToId", STR_PLACE_UNIT, slot) then
                    Seed.Session.Places = Seed.Session.Places + 1
                end
            end
            task.wait(0.5)
        end)
        if not ok then
            notyuri("Error in [Seed.Place]: " .. tostring(err))
        end
        task.wait(0.15)
    end
end
local function FuncMerge()
    while Toggles.AutoMerge.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil then
                task.wait(1)
                return
            end
            local unitType = SeedTypeId("UnitTypeId")
            local starMax = SeedTypeId("unitStarMax")
            if unitType == nil or starMax == nil then
                task.wait(1)
                return
            end
            SeedFire("QuickFuse", STR_UNIT)
            local showSize = SeedTypeId("handShowSize") or 5
            local hand = d.serverData.hand
            for i = 1, math.min(showSize, #hand) do
                if Toggles.AutoMerge.Value ~= true then break end
                local gid = hand[i]
                local card = SeedCard(d, gid)
                if card ~= nil and card.typeId == unitType and card.isLock ~= true and (card.star or 0) < starMax then
                    for slot = 1, SCENE_SIZE do
                        if d.serverData.sceneUnitChunkUnlock[slot] == true then
                            local placedGid = d.serverData.sceneUnit[slot] or 0
                            local placed = SeedCard(d, placedGid)
                            if placed ~= nil and placed.typeId == unitType and placed.isLock ~= true
                                and placed.cfgId == card.cfgId and placed.star == card.star and placed.star < starMax then
                                if SeedEnsureHandSelected(d, gid) then
                                    local cf = d.onlyData.zone.sceneUnit_CFrame[slot]
                                    if cf ~= nil then
                                        TPTo(cf)
                                        task.wait(0.1)
                                    end
                                    if SeedFire("BusinessToId", STR_PLACE_UNIT, slot) then
                                        Seed.Session.Merges = Seed.Session.Merges + 1
                                    end
                                    task.wait(0.5)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("Error in [Seed.Merge]: " .. tostring(err))
        end
        task.wait(2)
    end
end
local function FuncWater()
    while Toggles.AutoWater.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil then
                task.wait(1)
                return
            end
            local water = SeedBestOwnedWater(d)
            if water == nil then
                task.wait(2)
                return
            end
            if not SeedEnsureUseItemSelected(d, water.gid) then
                task.wait(1)
                return
            end
            local now = workspace:GetServerTimeNow()
            local growing = {}
            for i = 1, INCUBATION_SIZE do
                local gid = d.serverData.incubationChunk[i] or 0
                if gid > 0 then
                    local card = SeedCard(d, gid)
                    if card ~= nil and type(card.eggTime) == "number" and card.eggTime > now then
                        table.insert(growing, i)
                    end
                end
            end
            if #growing == 0 then
                task.wait(1)
                return
            end
            local cf = d.onlyData.incubationChunk_CFrame[growing[1]]
            if cf ~= nil then
                TPTo(cf)
                task.wait(0.1)
            end
            for _, chunk in ipairs(growing) do
                if not Toggles.AutoWater.Value then break end
                local gid = d.serverData.incubationChunk[chunk] or 0
                if gid > 0 then
                    local card = SeedCard(d, gid)
                    if card ~= nil and type(card.eggTime) == "number" and card.eggTime > workspace:GetServerTimeNow() then
                        if SeedFire("WaterIncubationUnit", chunk) then
                            Seed.Session.Waters = Seed.Session.Waters + 1
                        end
                    end
                end
                task.wait(0.35)
            end
        end)
        if not ok then
            notyuri("Error in [Seed.Water]: " .. tostring(err))
        end
        task.wait(0.5)
    end
end
local function FuncBuyWater()
    while Toggles.AutoBuyWater.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil or Seed.PlayConfig == nil or Seed.BigNumber == nil then
                task.wait(2)
                return
            end
            local owned = 0
            for cfgId, item in pairs(Seed.PlayConfig.allUseItem) do
                if type(item) == "table" and item.useType == 1 then
                    local gid = d.serverData.allUseItemGid[cfgId] or 0
                    if gid > 0 then
                        local card = SeedCard(d, gid)
                        if card ~= nil and (card.size or 0) > 0 then
                            owned = owned + card.size
                        end
                    end
                end
            end
            if owned > 0 then
                task.wait(2)
                return
            end
            local best = nil
            for cfgId, item in pairs(Seed.PlayConfig.allUseItem) do
                if type(item) == "table" and item.useType == 1 and (item.addGrowthTime or 0) > 0 then
                    local stock = d.playData.allUseItemStoreSize[cfgId] or 0
                    if stock > 0 and type(item.cost) == "table" and item.cost.value ~= nil then
                        if Seed.BigNumber.BigCompare(d.playData.Wins.Value, item.cost.value) then
                            if best == nil or item.addGrowthTime > best.addGrowthTime then
                                best = item
                            end
                        end
                    end
                end
            end
            if best ~= nil then
                if SeedFire("Buy_Backpack_Item", STR_ITEM, best.id) then
                    Seed.Session.Buys = Seed.Session.Buys + 1
                end
            end
        end)
        if not ok then
            notyuri("Error in [Seed.BuyWater]: " .. tostring(err))
        end
        task.wait(5)
    end
end
local function FuncTrain()
    while Toggles.AutoTrain.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil then
                task.wait(1)
                return
            end
            if d.playData.isTrainer.Value ~= true then
                if SeedFire("Business", STR_TRAIN) then
                    Seed.TrainEntered = true
                end
                task.wait(1.5)
            else
                Seed.TrainEntered = true
                task.wait(3)
            end
        end)
        if not ok then
            notyuri("Error in [Seed.Train]: " .. tostring(err))
        end
        task.wait(1)
    end
end
local function FuncTrainUp()
    while Toggles.AutoTrainUp.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil or Seed.PlayConfig == nil then
                task.wait(2)
                return
            end
            local nextLevel = Seed.PlayConfig.allTrainMachine[d.playData.nowTrainerLevel.Value + 1]
            if nextLevel == nil then
                task.wait(10)
                return
            end
            if type(nextLevel.cost) == "table" and nextLevel.cost.value ~= nil and Seed.BigNumber ~= nil then
                if not Seed.BigNumber.BigCompare(d.playData.Wins.Value, nextLevel.cost.value) then
                    task.wait(5)
                    return
                end
            end
            SeedFire("Business", STR_TRAIN_UP)
            task.wait(3)
        end)
        if not ok then
            notyuri("Error in [Seed.TrainUp]: " .. tostring(err))
        end
        task.wait(1)
    end
end
local function FuncUnlockChunk()
    while Toggles.AutoUnlockChunk.Value do
        local ok, err = pcall(function()
            local d = Seed.Data
            if d == nil or Seed.SRE == nil or Seed.PlayConfig == nil then
                task.wait(1)
                return
            end
            for i = 1, SCENE_SIZE do
                if d.serverData.sceneUnitChunkUnlock[i] ~= true then
                    local cfg = nil
                    for _, entry in pairs(Seed.PlayConfig.allSceneUnitChunkUnlock) do
                        if type(entry) == "table" and entry.value == i then
                            cfg = entry
                            break
                        end
                    end
                    if cfg ~= nil then
                        local affordable = true
                        if type(cfg.cost) == "table" and cfg.cost.value ~= nil and Seed.BigNumber ~= nil then
                            affordable = Seed.BigNumber.BigCompare(d.playData.Wins.Value, cfg.cost.value)
                        end
                        if affordable then
                            if SeedFire("UnlockSceneUnitChunk", cfg.id) then
                                Seed.Session.Unlocks = Seed.Session.Unlocks + 1
                            end
                            task.wait(0.6)
                        end
                    end
                    break
                end
            end
        end)
        if not ok then
            notyuri("Error in [Seed.UnlockChunk]: " .. tostring(err))
        end
        task.wait(1)
    end
end
local function SeedBigStr(v)
    if Seed.BigNumber == nil or v == nil then return "-" end
    local ok, res = pcall(function() return Seed.BigNumber.GetStr(v) end)
    if ok and type(res) == "string" then return res end
    return "-"
end
local function SeedTpHome()
    local d = Seed.Data
    if d == nil or d.onlyData.zone == nil or d.onlyData.zone.tpPart == nil then return end
    TPTo(d.onlyData.zone.tpPart)
end
local function SeedTpIncubation()
    local d = Seed.Data
    if d == nil or d.onlyData.incubationChunk_CFrame == nil then return end
    TPTo(d.onlyData.incubationChunk_CFrame[1])
end
local function SeedTpSteal()
    if Seed.ServerInstanceData == nil or Seed.ServerInstanceData.enemySource_CFrame == nil then return end
    local cf = Seed.ServerInstanceData.enemySource_CFrame[1]
    if cf ~= nil then
        TPTo(cf)
    end
end
local function SeedTpTrain()
    local d = Seed.Data
    if d == nil or d.onlyData.zone == nil then return end
    local root = d.onlyData.zone.All0DUI_Root
    if root == nil then return end
    local machine = root:FindFirstChild(STR_TRAIN .. "0D")
    if machine ~= nil then
        TPTo(machine.CFrame * CFrame.new(0, 4, 0))
    end
end
local function SeedDropEgg()
    if SeedCarrying() then
        SeedFire("DropTempEnemyEgg")
    end
end
task.spawn(function()
    local remoteRoot = GetObject(RS, "RemoteEvent")
    local waited = 0
    while Seed.SRE == nil and waited < 30 do
        Seed.SRE = GetSafeRemote(remoteRoot, "ServerRemoteEvent")
        if Seed.SRE == nil then
            task.wait(0.5)
            waited = waited + 0.5
        end
    end
    if Seed.SRE ~= nil then
        notyuri("Seed ServerRemoteEvent resolved")
    else
    end
end)
task.spawn(function()
    Seed.PlayConfig = GetSafeModule(GetObject(RS, "Data"), "PlayConfig")
    Seed.MainBusiness = GetSafeModule(GetObject(RS, "Business"), "MainBusiness")
    Seed.BigNumber = GetSafeModule(GetObject(RS, "Framework.X0000"), "BigNumber")
    Seed.ServerInstanceData = GetSafeModule(GetObject(RS, "Data.X1100"), "ServerInstanceData")
    local spsBusiness = GetObject(game, "StarterPlayer.StarterPlayerScripts.Business")
    local cDataMod = nil
    if spsBusiness ~= nil then
        local waited = 0
        while waited < 30 and cDataMod == nil do
            cDataMod = GetSafeModule(spsBusiness, "C_Data")
            if cDataMod == nil then
                task.wait(1)
                waited = waited + 1
            end
        end
    end
    if Seed.PlayConfig ~= nil then
        if AutoStealRefreshRarity ~= nil and Seed.PlayConfig.allRarity ~= nil then
            local rarityLabels = {}
            local labelToId = {}
            for rarityId, rarityCfg in pairs(Seed.PlayConfig.allRarity) do
                if rarityCfg ~= nil and rarityCfg.name ~= nil then
                    table.insert(rarityLabels, rarityCfg.name)
                    labelToId[rarityCfg.name] = rarityId
                end
            end
            AutoStealRefreshRarity(rarityLabels, labelToId)
        end
        local sys = workspace:FindFirstChild(STR_XITONG)
        if sys ~= nil then
            local serverInfo = sys:FindFirstChild("ServerInfo")
            if serverInfo ~= nil then
                Seed.GpState = serverInfo:FindFirstChild("Gp_State")
                Seed.GpTime = serverInfo:FindFirstChild("Gp_Time")
            end
        end
    end
    if cDataMod == nil then
        notyuri("Seed C_Data module missing")
        return
    end
    local waited = 0
    while waited < 120 and not Library.Unloaded do
        local ok, data = pcall(function()
            return cDataMod.GetData()
        end)
        if ok and type(data) == "table" then
            Seed.Data = data
            break
        end
        task.wait(1)
        waited = waited + 1
    end
    if Seed.Data ~= nil then
        Seed.Ready = true
        notyuri("Seed data ready")
    else
        notyuri("Seed data wait timed out")
    end
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoSteal", { Text = "Auto Steal", Default = false })
do
    local rarityLabels = {}
    local labelToId = {}
    if Seed.Data ~= nil and Seed.PlayConfig ~= nil and Seed.PlayConfig.allRarity ~= nil then
        for rarityId, rarityCfg in pairs(Seed.PlayConfig.allRarity) do
            if rarityCfg ~= nil and rarityCfg.name ~= nil then
                table.insert(rarityLabels, rarityCfg.name)
                labelToId[rarityCfg.name] = rarityId
            end
        end
    end
    AutoStealGetRaritySelection, AutoStealRefreshRarity, AutoStealRarityBase = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "AutoStealRarity", {
        Text = "Steal Rarity",
        Values = rarityLabels,
        Default = {},
        label = labelToId,
    })
end
TB_Tabs.Autofarm.T1:AddToggle("AutoPlant", { Text = "Auto Plant", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTake", { Text = "Auto Take", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false })
TB_Tabs.Autofarm.T1:AddDivider()
TB_Tabs.Autofarm.T1:AddToggle("AutoMerge", { Text = "Auto Merge", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoWater", { Text = "Auto Water", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyWater", { Text = "Auto Buy Water", Default = false })
TB_Tabs.Autofarm.T1:AddDivider()
TB_Tabs.Autofarm.T1:AddToggle("AutoTrain", { Text = "Auto Train", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTrainUp", { Text = "Auto Upgrade Machine", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUnlockChunk", { Text = "Auto Unlock Slots", Default = false })
Toggles.AutoSteal:OnChanged(function(state)
    Thread("Seed.Steal", FuncSteal, state)
end)
Toggles.AutoPlant:OnChanged(function(state)
    Thread("Seed.Plant", FuncPlant, state)
end)
Toggles.AutoTake:OnChanged(function(state)
    Thread("Seed.Take", FuncTake, state)
end)
Toggles.AutoPlace:OnChanged(function(state)
    Thread("Seed.Place", FuncPlace, state)
end)
Toggles.AutoMerge:OnChanged(function(state)
    Thread("Seed.Merge", FuncMerge, state)
end)
Toggles.AutoWater:OnChanged(function(state)
    Thread("Seed.Water", FuncWater, state)
end)
Toggles.AutoBuyWater:OnChanged(function(state)
    Thread("Seed.BuyWater", FuncBuyWater, state)
end)
Toggles.AutoTrain:OnChanged(function(state)
    if not state then
        task.spawn(function()
            pcall(function()
                local d = Seed.Data
                if d ~= nil and Seed.TrainEntered and d.playData.isTrainer.Value == true then
                    SeedFire("Business", STR_TRAIN)
                end
                Seed.TrainEntered = false
            end)
        end)
    end
    Thread("Seed.Train", FuncTrain, state)
end)
Toggles.AutoTrainUp:OnChanged(function(state)
    Thread("Seed.TrainUp", FuncTrainUp, state)
end)
Toggles.AutoUnlockChunk:OnChanged(function(state)
    Thread("Seed.UnlockChunk", FuncUnlockChunk, state)
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
SaveManager:SetFolder("Yuri/SAS")
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
