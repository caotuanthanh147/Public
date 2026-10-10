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
local CollectionService = Services.CollectionService
local R = {}
local RemotesReady = false
local JsonHelper = GetSafeModule(GetObject(Plr.PlayerScripts, "UI.Helpers"), "PlayerAttributeJsonHelper")
local GradeModule = GetSafeModule(GetObject(RS, "GameData"), "WeaponGradeConfig")
local CritRollModule = GetSafeModule(GetObject(RS, "Helpers"), "CritRoll")
local KindTraitsModule = GetSafeModule(GetObject(RS, "GameData"), "BubbleSpecialKindTraits")
local SpawnConstantsModule = GetSafeModule(GetObject(RS, "GameData"), "WeaponSpawnConstants")
local UpgradeAttributeModule = GetSafeModule(GetObject(RS, "Types.Enums"), "UpgradeAttributes")
local UpgradeAmountModule = GetSafeModule(GetObject(RS, "Types.Enums"), "UpgradeRequestAmounts")
local PotionConfigModule = GetSafeModule(GetObject(RS, "GameData"), "PotionConfig")
local BuffTypesModule = GetSafeModule(GetObject(RS, "Types"), "Buffs")
local ZoneConfigModule = GetSafeModule(GetObject(RS, "GameData"), "ZoneConfig")
local TeleportDestinationsModule = GetSafeModule(GetObject(RS, "GameData"), "TeleportDestinationConfig")
local TeleportConstantsModule = GetSafeModule(GetObject(RS, "GameData"), "TeleportConstants")
local MapTagsModule = GetSafeModule(RS, "MapTags")
local SealEconomyModule = GetSafeModule(GetObject(RS, "GameData"), "SealEconomyConfig")
local ZoneUnlockCostModule = GetSafeModule(GetObject(RS, "GameData"), "ZoneUnlockCostConfig")
local PlaytimeConstantsModule = GetSafeModule(GetObject(RS, "Constants"), "DailyPlaytimeConstants")
local PetEggConfigModule = GetSafeModule(GetObject(RS, "GameData"), "PetEggConfig")
local LootboxConfigModule = GetSafeModule(GetObject(RS, "GameData"), "LootboxConfig")
local BossBubbleRendererModule = GetSafeModule(GetObject(Plr.PlayerScripts, "Bubbles"), "BossBubbleRenderer")
local BossBubbleRenderer = BossBubbleRendererModule and BossBubbleRendererModule.BossBubbleRenderer or nil
notyuri("[Pop.Config] PetEggConfigModule=", tostring(PetEggConfigModule), "LootboxConfigModule=", tostring(LootboxConfigModule))
local WeaponGradeConfig = GradeModule and GradeModule.WeaponGradeConfig or nil
local getWeaponGradeDisplayName = GradeModule and GradeModule.getWeaponGradeDisplayName or nil
local rollCritMulti = CritRollModule and CritRollModule.rollCritMulti or nil
local KindTraits = KindTraitsModule and KindTraitsModule.BUBBLE_SPECIAL_KIND_TRAITS or nil
local WeaponSpawnRange = (SpawnConstantsModule and SpawnConstantsModule.WEAPON_SPAWN_RANGE) or 100
local WeaponSpawnSpeed = (SpawnConstantsModule and SpawnConstantsModule.WEAPON_SPAWN_SPEED) or 100
local UpgradeAttribute = UpgradeAttributeModule and UpgradeAttributeModule.UpgradeAttribute or nil
local UpgradeAmount = UpgradeAmountModule and UpgradeAmountModule.UpgradeRequestAmount or nil
local PotionCatalog = PotionConfigModule and PotionConfigModule.PotionCatalog or nil
local PotionDisplayNames = PotionConfigModule and PotionConfigModule.POTION_DISPLAY_NAMES or nil
local BoostAttrs = BuffTypesModule and BuffTypesModule.TemporaryBoostAttributeName or nil
local Zones = ZoneConfigModule and ZoneConfigModule.Zones or nil
local TeleportDests = TeleportDestinationsModule and TeleportDestinationsModule.TeleportDestinations or nil
local TeleportOffsetY = (TeleportConstantsModule and TeleportConstantsModule.TELEPORT_VERTICAL_OFFSET) or 8
local MapTag = MapTagsModule and MapTagsModule.MapTag or nil
local MapAttribute = MapTagsModule and MapTagsModule.MapAttribute or nil
local ChainWindow = WeaponSpawnRange / WeaponSpawnSpeed + 1
local Pop = {}
Pop.Bubbles = {}
Pop.Pending = {}
Pop.PendingAt = {}
Pop.Drops = {cash = {}, gem = {}, essence = {}, rain = {}}
Pop.ChainLastId = nil
Pop.LastCombatPing = 0
Pop.LastThrowAt = 0
Pop.LastInputAt = 0
Pop.MissionState = nil
Pop.PlaytimeState = nil
Pop.PlaytimeReceivedAt = os.clock()
Pop.Session = {Pops = 0, Drops = 0, Rebirths = 0, StartedAt = os.clock()}
local UpgradeGetSelection = nil
local PotionGetSelection = nil
if JsonHelper == nil then
    task.spawn(function()
        local uiFolder = Plr.PlayerScripts:WaitForChild("UI", 30)
        if uiFolder == nil then return end
        local helpersFolder = uiFolder:WaitForChild("Helpers", 30)
        if helpersFolder == nil then return end
        local mod = GetSafeModule(helpersFolder, "PlayerAttributeJsonHelper")
        if mod ~= nil then
            JsonHelper = mod
        else
            LoadModuleAsync(helpersFolder, "PlayerAttributeJsonHelper", function(m)
                JsonHelper = m
            end)
        end
    end)
end
local function PopDamage()
    local dmg = Plr:GetAttribute("Damage")
    if type(dmg) ~= "number" then dmg = 1 end
    if dmg < 1 then dmg = 1 end
    return dmg
end
local function PopGradeCrit()
    local grade = tonumber(Plr:GetAttribute("EquippedWeaponGrade")) or 0
    local critChance = 0.01
    if WeaponGradeConfig and WeaponGradeConfig[grade] and type(WeaponGradeConfig[grade].critChance) == "number" then
        critChance = WeaponGradeConfig[grade].critChance
    end
    return grade, critChance
end
local function PopRollCrit(critChance)
    if rollCritMulti then
        local ok, result = pcall(rollCritMulti, critChance)
        if ok and type(result) == "table" then
            return result
        end
    end
    return {multi = 1, isCrit = false, isSuperCrit = false}
end
local function PopKillBubble(b, damage, critChance, now)
    local roll = PopRollCrit(critChance)
    local hitDamage = math.max(1, damage * roll.multi)
    local hp = b.hp
    if type(hp) ~= "number" or hp <= 0 then hp = b.maxHp or 1 end
    if hp < 1 then hp = 1 end
    local hits = math.ceil(hp / hitDamage)
    return {
        bubbleId = b.id,
        totalDamage = hits * hitDamage,
        elapsedMs = math.max(1, math.floor((now - b.spawnAt) * 1000)),
        lastHitWasCrit = roll.isCrit == true,
        lastHitWasSuperCrit = roll.isSuperCrit == true,
    }
end
local function PopThrowWeapon(b, root)
    if R.ThrowWeapon == nil or b == nil or b.position == nil then return end
    local delta = b.position - root.Position
    if delta.Magnitude < 0.001 then return end
    local equipped = Plr:GetAttribute("EquippedWeaponId") ~= nil
    FireRemote(R.ThrowWeapon, delta.Unit, tostring(Plr.UserId) .. "_" .. tostring(tick()), equipped)
end
local function PopTryChain(bubbleId)
    if Pop.ChainLastId == bubbleId then return end
    local active = true
    if Plr:GetAttribute("AutoAttackActive") == true then
        active = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or (os.clock() - Pop.LastInputAt) <= ChainWindow
    end
    local autoTarget = Plr:GetAttribute("AutoTargetActive") == true
    if not (active or autoTarget) then return end
    Pop.ChainLastId = bubbleId
    FireRemote(R.ChainBubbleTrigger, bubbleId, active)
end
local function PopBoostActive(potionType)
    local catalog = PotionCatalog and PotionCatalog[potionType] or nil
    if catalog == nil or BoostAttrs == nil then return false end
    for _, dim in ipairs(catalog.dimensions or {}) do
        local attr = BoostAttrs[dim]
        if attr ~= nil then
            local expiresAt = Plr:GetAttribute(attr.expiresAt)
            if type(expiresAt) == "number" and os.time() < expiresAt then
                return true
            end
        end
    end
    return false
end
local function PopApplyBubble(entry)
    if type(entry) ~= "table" or entry.bubbleId == nil then return end
    if entry.despawned == true or entry.popped == true then
        Pop.Bubbles[entry.bubbleId] = nil
        Pop.Pending[entry.bubbleId] = nil
        Pop.PendingAt[entry.bubbleId] = nil
        return
    end
    Pop.Bubbles[entry.bubbleId] = {
        id = entry.bubbleId,
        position = entry.position,
        size = entry.size,
        hp = entry.currentHealth,
        maxHp = entry.maxHealth,
        specialKind = entry.specialKind or 0,
        bubbletId = entry.bubbletId,
        spawnAt = os.clock(),
        totalDamage = 0,
        lastCrit = false,
        lastSuper = false,
    }
    Pop.Pending[entry.bubbleId] = nil
    Pop.PendingAt[entry.bubbleId] = nil
end
local function PopMakeDropHandler(currency)
    return function(entries)
        if type(entries) ~= "table" then return end
        local tbl = Pop.Drops[currency]
        for _, entry in ipairs(entries) do
            if type(entry) == "table" and entry.dropId ~= nil then
                if entry.reason == "Collected" then
                    tbl[entry.dropId] = nil
                elseif entry.kind == "Merge" then
                    tbl[entry.dropId] = nil
                    if entry.targetId ~= nil then
                        tbl[entry.targetId] = tick() + (entry.lifetimeSeconds or 10)
                    end
                else
                    tbl[entry.dropId] = tick() + (entry.lifetimeSeconds or 10)
                end
            end
        end
    end
end
local function PopAttachListeners()
    SafeConnect("Pop.SpawnBatch", function() return R.BubbleSpawnBatch and R.BubbleSpawnBatch.OnClientEvent end, function(entries)
        if type(entries) ~= "table" then return end
        table.clear(Pop.Bubbles)
        table.clear(Pop.Pending)
        table.clear(Pop.PendingAt)
        Pop.ChainLastId = nil
        for _, entry in ipairs(entries) do
            PopApplyBubble(entry)
        end
    end)
    SafeConnect("Pop.BubbleUpdate", function() return R.BubbleUpdate and R.BubbleUpdate.OnClientEvent end, function(entries)
        if type(entries) ~= "table" then return end
        for _, entry in ipairs(entries) do
            PopApplyBubble(entry)
        end
    end)
    SafeConnect("Pop.PopBatch", function() return R.BubblePopBatch and R.BubblePopBatch.OnClientEvent end, function(entries)
        if type(entries) ~= "table" then return end
        for _, entry in ipairs(entries) do
            if type(entry) == "table" and entry.bubbleId ~= nil then
                Pop.Bubbles[entry.bubbleId] = nil
                Pop.Pending[entry.bubbleId] = nil
                Pop.PendingAt[entry.bubbleId] = nil
            end
        end
    end)
    SafeConnect("Pop.DespawnAll", function() return R.BubbleDespawnAll and R.BubbleDespawnAll.OnClientEvent end, function()
        table.clear(Pop.Bubbles)
        table.clear(Pop.Pending)
        table.clear(Pop.PendingAt)
        Pop.ChainLastId = nil
    end)
    SafeConnect("Pop.CashDrops", function() return R.CashDropEvent and R.CashDropEvent.OnClientEvent end, PopMakeDropHandler("cash"))
    SafeConnect("Pop.GemDrops", function() return R.GemDropEvent and R.GemDropEvent.OnClientEvent end, PopMakeDropHandler("gem"))
    SafeConnect("Pop.EssenceDrops", function() return R.EssenceDropEvent and R.EssenceDropEvent.OnClientEvent end, PopMakeDropHandler("essence"))
    SafeConnect("Pop.RainDrops", function() return R.RainDropEvent and R.RainDropEvent.OnClientEvent end, PopMakeDropHandler("rain"))
    SafeConnect("Pop.Missions", function() return R.DailyMissionEvent and R.DailyMissionEvent.OnClientEvent end, function(state)
        Pop.MissionState = state
    end)
    SafeConnect("Pop.Playtime", function() return R.DailyPlaytimeRewardState and R.DailyPlaytimeRewardState.OnClientEvent end, function(state)
        Pop.PlaytimeState = state
        Pop.PlaytimeReceivedAt = os.clock()
    end)
    SafeConnect("Pop.Input", function() return UIS.InputBegan end, function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Pop.LastInputAt = os.clock()
        end
    end)
end
task.spawn(function()
    local folder = RS:WaitForChild("Remotes", 30)
    if folder == nil then
        Library:Notify("Remotes folder not found", 5)
        return
    end
    local names = {
        "BubbleSpawnBatch", "BubbleUpdate", "BubblePopBatch", "BubbleDespawnAll",
        "BubblePopRequest", "FrenzyCombatPing", "ChainBubbleTrigger", "GemBubbleHitBatch",
        "ThrowWeapon", "TeleportIntent", "SpinWheelFlushRewards",
        "CashDropEvent", "CashDropCollect", "GemDropEvent", "GemDropCollect",
        "EssenceDropEvent", "EssenceDropCollect", "RainDropEvent", "RainDropCollect",
        "RebirthRequest", "UpgradeRequest", "BubbletEquipBestRequest",
        "ClaimDailyReward", "GetDailyRewardStatus", "DailyMissionClaim", "DailyMissionCompleteAllClaim",
        "DailyPlaytimeRewardClaim", "DailyMissionEvent", "DailyPlaytimeRewardState",
        "GetOfflineEarningsPending", "ClaimOfflineEarnings", "SpinWheelSpin", "PotionDrinkRequest",
        "PetHatchRequest", "LootboxRoll",
        "PetEquipBestRequest", "BubbletSlotUnlockRequest", "BubbletLevelUpRequest",
        "BossOptInRequest",
    }
    for _, name in ipairs(names) do
        R[name] = GetSafeRemote(folder, name)
    end
    RemotesReady = true
    local ok, err = pcall(PopAttachListeners)
    if not ok then
        notyuri("PopAttachListeners error: " .. tostring(err))
    end
end)
local function FuncAutoPop()
    while Toggles.AutoPop.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.BubblePopRequest == nil then return end
            local char = GetCharacter()
            if char == nil then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root == nil then return end
            local now = os.clock()
            local damage = PopDamage()
            local _, critChance = PopGradeCrit()
            local turbo = true
            for bubbleId, queuedAt in pairs(Pop.PendingAt) do
                if now - queuedAt > 0.3 then
                    Pop.Pending[bubbleId] = nil
                    Pop.PendingAt[bubbleId] = nil
                end
            end
            local entries = {}
            local gemBatches = {}
            local anyHit = false
            local nearest = nil
            local nearestDist = math.huge
            for bubbleId, b in pairs(Pop.Bubbles) do
                if b.position ~= nil then
                    local d = (b.position - root.Position).Magnitude
                    if d < nearestDist and (b.specialKind or 0) ~= 1 then
                        nearest = b
                        nearestDist = d
                    end
                end
                local kind = b.specialKind or 0
                local traits = KindTraits and KindTraits[kind] or nil
                if kind == 1 then
                    PopTryChain(bubbleId)
                elseif kind == 3 or (traits and traits.reportsHitCount) then
                    if Pop.Pending[bubbleId] == nil then
                        table.insert(gemBatches, {bubbleId = bubbleId, hits = 1})
                        anyHit = true
                    end
                elseif traits == nil or traits.damageable then
                    if turbo and Pop.Pending[bubbleId] == nil then
                        table.insert(entries, PopKillBubble(b, damage, critChance, now))
                        Pop.Pending[bubbleId] = true
                        Pop.PendingAt[bubbleId] = now
                        anyHit = true
                    end
                end
            end
            local fireRate = tonumber(Plr:GetAttribute("WeaponFireRate")) or 1
            if fireRate < 0.05 then fireRate = 0.05 end
            if now - Pop.LastThrowAt >= 1 / fireRate and nearest ~= nil then
                Pop.LastThrowAt = now
                if not turbo then
                    local b = nearest
                    if b.hp == nil then b.hp = b.maxHp or 1 end
                    if b.hp > 0 then
                        local roll = PopRollCrit(critChance)
                        local hitDamage = math.max(1, damage * roll.multi)
                        b.hp = b.hp - hitDamage
                        b.totalDamage = (b.totalDamage or 0) + hitDamage
                        b.lastCrit = roll.isCrit == true
                        b.lastSuper = roll.isSuperCrit == true
                        anyHit = true
                        if b.hp <= 0 then
                            table.insert(entries, {
                                bubbleId = b.id,
                                totalDamage = b.totalDamage,
                                elapsedMs = math.max(1, math.floor((now - b.spawnAt) * 1000)),
                                lastHitWasCrit = b.lastCrit,
                                lastHitWasSuperCrit = b.lastSuper,
                            })
                            Pop.Pending[b.id] = true
                            Pop.PendingAt[b.id] = now
                        end
                    end
                end
            end
            if #entries > 0 then
                if FireRemote(R.BubblePopRequest, {entries = entries, source = "player"}) then
                    Pop.Session.Pops = Pop.Session.Pops + #entries
                end
            end
            if #gemBatches > 0 and R.GemBubbleHitBatch ~= nil then
                for _, batch in ipairs(gemBatches) do
                    FireRemote(R.GemBubbleHitBatch, batch)
                end
            end
            if anyHit and R.FrenzyCombatPing ~= nil and now - Pop.LastCombatPing >= 1 then
                Pop.LastCombatPing = now
                FireRemote(R.FrenzyCombatPing)
            end
        end)
        if not ok then
            Library:Notify("Error in [Pop.AutoPop]: " .. tostring(err), 10)
            notyuri("Error in [Pop.AutoPop]: " .. tostring(err))
        end
        task.wait(0.05)
    end
end
local function FuncCollect()
    while Toggles.AutoCollect.Value do
        local ok, err = pcall(function()
            if not RemotesReady then return end
            local now = tick()
            local collectNames = {cash = "CashDropCollect", gem = "GemDropCollect", essence = "EssenceDropCollect", rain = "RainDropCollect"}
            for currency, tbl in pairs(Pop.Drops) do
                local remote = R[collectNames[currency]]
                if remote ~= nil then
                    local ids = {}
                    for dropId, expiresAt in pairs(tbl) do
                        if expiresAt > now then
                            table.insert(ids, dropId)
                        else
                            tbl[dropId] = nil
                        end
                    end
                    if #ids > 0 then
                        if FireRemote(remote, ids) then
                            Pop.Session.Drops = Pop.Session.Drops + #ids
                        end
                    end
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [Pop.Collect]: " .. tostring(err), 10)
            notyuri("Error in [Pop.Collect]: " .. tostring(err))
        end
        task.wait(0.25)
    end
end
local function FuncRebirth()
    while Toggles.AutoRebirth.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.RebirthRequest == nil then return end
            local level = tonumber(Plr:GetAttribute("RebirthLevel")) or 0
            local essence = tonumber(Plr:GetAttribute("Essence")) or 0
            local required = nil
            if SealEconomyModule and SealEconomyModule.getSealRequiredEssenceForRebirthLevel then
                local okR, res = pcall(SealEconomyModule.getSealRequiredEssenceForRebirthLevel, level + 1)
                if okR and type(res) == "number" then required = res end
            end
            local zones = {}
            if JsonHelper and JsonHelper.decodeUnlockedZones then
                local okZ, res = pcall(JsonHelper.decodeUnlockedZones, Plr)
                if okZ and type(res) == "table" then zones = res end
            end
            local zoneOk = false
            if ZoneUnlockCostModule and ZoneUnlockCostModule.isRebirthZoneGateMet then
                local okG, res = pcall(ZoneUnlockCostModule.isRebirthZoneGateMet, zones, level)
                if okG and res == true then zoneOk = true end
            end
            if required ~= nil and required <= essence and zoneOk then
                local res = SafeInvoke(R.RebirthRequest)
                if type(res) == "table" and res.success then
                    Pop.Session.Rebirths = Pop.Session.Rebirths + 1
                    Library:Notify("Rebirth complete!", 4)
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [Pop.Rebirth]: " .. tostring(err), 10)
            notyuri("Error in [Pop.Rebirth]: " .. tostring(err))
        end
        task.wait(5)
    end
end
local function FuncUpgrade()
    while Toggles.AutoUpgrade.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.UpgradeRequest == nil then return end
            if UpgradeGetSelection == nil then return end
            local selected = UpgradeGetSelection()
            if next(selected) == nil then return end
            local amount = (UpgradeAmount and UpgradeAmount.Max) or -1
            for attr in pairs(selected) do
                SafeInvoke(R.UpgradeRequest, attr, amount)
                task.wait()
            end
        end)
        if not ok then
            Library:Notify("Error in [Pop.Upgrade]: " .. tostring(err), 10)
            notyuri("Error in [Pop.Upgrade]: " .. tostring(err))
        end
        task.wait(1)
    end
end
local function FuncEquipBest()
    while Toggles.AutoEquipBubbles.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.BubbletEquipBestRequest == nil then return end
            SafeInvoke(R.BubbletEquipBestRequest)
        end)
        if not ok then
            notyuri("Error in [Pop.EquipBest]: " .. tostring(err))
        end
        task.wait(2)
    end
end
local function FuncEquipPet()
    while Toggles.AutoEquipPet.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.PetEquipBestRequest == nil then return end
            SafeInvoke(R.PetEquipBestRequest)
        end)
        if not ok then
            notyuri("Error in [Pop.EquipPet]: " .. tostring(err))
        end
        task.wait(2)
    end
end
local function FuncUnlockBubbleSlot()
    while Toggles.AutoSlot.Value do
        local result
        local ok, err = pcall(function()
            if not RemotesReady or R.BubbletSlotUnlockRequest == nil then return end
            result = SafeInvoke(R.BubbletSlotUnlockRequest)
        end)
        if not ok then
            notyuri("Error in [Pop.UnlockBubbleSlot]: " .. tostring(err))
        end
        task.wait(2)
    end
end
local function FuncUpgradeBubblets()
    while Toggles.AutoUpgradeBubblets.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.BubbletLevelUpRequest == nil then return end
            local raw = Plr:GetAttribute("EquippedBubblets")
            if type(raw) ~= "string" then return end
            local okDecode, equipped = pcall(HttpService.JSONDecode, HttpService, raw)
            if not okDecode or type(equipped) ~= "table" then return end
            for i, entry in ipairs(equipped) do
                if type(entry) == "table" and type(entry.bubbletId) == "number" and entry.bubbletId >= 0 then
                    local slotIndex = i - 1
                    SafeInvoke(R.BubbletLevelUpRequest, {mode = "max", target = {kind = "equipped", slotIndex = slotIndex}})
                    task.wait()
                end
            end
        end)
        if not ok then
            notyuri("Error in [Pop.UpgradeBubblets]: " .. tostring(err))
        end
        task.wait(1)
    end
end
local function FuncPotion()
    while Toggles.AutoPotion.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.PotionDrinkRequest == nil then return end
            if JsonHelper == nil or JsonHelper.decodePotionStacks == nil then return end
            if PotionGetSelection == nil then return end
            local okS, stacks = pcall(JsonHelper.decodePotionStacks)
            if not okS or type(stacks) ~= "table" then return end
            local selected = PotionGetSelection()
            local best = {}
            for _, entry in ipairs(stacks) do
                if type(entry) == "table" and entry.potionType ~= nil and entry.tier ~= nil and (entry.count or 0) >= 1 then
                    if selected[entry.potionType] then
                        local cur = best[entry.potionType]
                        if cur == nil or entry.tier > cur.tier then
                            best[entry.potionType] = entry
                        end
                    end
                end
            end
            for potionType, entry in pairs(best) do
                if not PopBoostActive(potionType) then
                    SafeInvoke(R.PotionDrinkRequest, {potionType = potionType, tier = entry.tier})
                    task.wait(0.5)
                end
            end
        end)
        if not ok then
            notyuri("Error in [Pop.Potion]: " .. tostring(err))
        end
        task.wait(1)
    end
end
local PopEggValues, PopEggLabels
local PopLuckyBlockValues, PopLuckyBlockLabels
local function FuncEgg()
    while Toggles.AutoEgg.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.PetHatchRequest == nil then
                notyuri("[Pop.Egg] abort: RemotesReady=", tostring(RemotesReady), "R.PetHatchRequest=", tostring(R.PetHatchRequest))
                return
            end
            local label = Options.PopEggDropdown and Options.PopEggDropdown.Value
            notyuri("[Pop.Egg] label=", tostring(label))
            local eggId = label and PopEggLabels and PopEggLabels[label]
            if eggId == nil then
                notyuri("[Pop.Egg] abort: eggId is nil, PopEggLabels=", tostring(PopEggLabels), "label=", tostring(label))
                return
            end
            notyuri("[Pop.Egg] invoking PetHatchRequest eggId=", tostring(eggId))
            local result = SafeInvoke(R.PetHatchRequest, {eggId = eggId})
            notyuri("[Pop.Egg] result=", tostring(result))
        end)
        if not ok then
            notyuri("Error in [Pop.Egg]: " .. tostring(err))
        end
        task.wait()
    end
end
local function FuncLuckyBlock()
    while Toggles.AutoLuckyBlock.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.LootboxRoll == nil then
                notyuri("[Pop.LuckyBlock] abort: RemotesReady=", tostring(RemotesReady), "R.LootboxRoll=", tostring(R.LootboxRoll))
                return
            end
            local label = Options.PopLuckyBlockDropdown and Options.PopLuckyBlockDropdown.Value
            notyuri("[Pop.LuckyBlock] label=", tostring(label))
            local lootboxId = label and PopLuckyBlockLabels and PopLuckyBlockLabels[label]
            if lootboxId == nil then
                notyuri("[Pop.LuckyBlock] abort: lootboxId is nil, PopLuckyBlockLabels=", tostring(PopLuckyBlockLabels), "label=", tostring(label))
                return
            end
            notyuri("[Pop.LuckyBlock] invoking LootboxRoll lootboxId=", tostring(lootboxId))
            local result = SafeInvoke(R.LootboxRoll, tonumber(lootboxId))
            notyuri("[Pop.LuckyBlock] result=", tostring(result))
        end)
        if not ok then
            notyuri("Error in [Pop.LuckyBlock]: " .. tostring(err))
        end
        task.wait()
    end
end
local function StartBossDodgeLoop()
    if Connections.BossDodge then return end
    Connections.BossDodge = RunService.Heartbeat:Connect(function()
        local ok, err = pcall(function()
            if not Toggles.AutoBoss.Value then return end
            if BossBubbleRenderer == nil then return end
            local instance = BossBubbleRenderer.getInstance and BossBubbleRenderer.getInstance(BossBubbleRenderer)
            if instance == nil then
                notyuri("[Pop.Boss] abort: BossBubbleRenderer instance is nil")
                return
            end
            local bossPos = instance.getBossBubblePosition and instance:getBossBubblePosition()
            if bossPos == nil then return end
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp == nil then return end
            hrp.CFrame = CFrame.new(bossPos + Vector3.new(0, 10, 0))
        end)
        if not ok then
            notyuri("Error in [Pop.BossDodge]: " .. tostring(err))
        end
    end)
end
local function StopBossDodgeLoop()
    if Connections.BossDodge then
        Connections.BossDodge:Disconnect()
        Connections.BossDodge = nil
    end
end
local function FuncBoss()
    while Toggles.AutoBoss.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.BossOptInRequest == nil then
                notyuri("[Pop.Boss] abort: RemotesReady=", tostring(RemotesReady), "R.BossOptInRequest=", tostring(R.BossOptInRequest))
                return
            end
            if Plr:GetAttribute("BossOptedIn") == true then
                StartBossDodgeLoop()
                return
            end
            notyuri("[Pop.Boss] invoking BossOptInRequest OptIn")
            local result = SafeInvoke(R.BossOptInRequest, "OptIn")
            notyuri("[Pop.Boss] result=", tostring(result))
        end)
        if not ok then
            notyuri("Error in [Pop.Boss]: " .. tostring(err))
        end
        task.wait(1)
    end
    StopBossDodgeLoop()
    if RemotesReady and R.BossOptInRequest ~= nil and Plr:GetAttribute("BossOptedIn") == true then
        pcall(function() SafeInvoke(R.BossOptInRequest, "OptOut") end)
    end
end
local function FuncSpinWheel()
    while Toggles.AutoSpinWheel.Value do
        local ok, err = pcall(function()
            if not RemotesReady or R.SpinWheelSpin == nil then
                notyuri("[Pop.SpinWheel] abort: RemotesReady=", tostring(RemotesReady), "R.SpinWheelSpin=", tostring(R.SpinWheelSpin))
                return
            end
            local tickets = Plr:GetAttribute("SpinWheelTickets")
            if type(tickets) ~= "number" or tickets <= 0 then
                return
            end
            notyuri("[Pop.SpinWheel] invoking SpinWheelSpin, tickets=", tostring(tickets))
            local result = SafeInvoke(R.SpinWheelSpin)
            notyuri("[Pop.SpinWheel] result=", tostring(result))
        end)
        if not ok then
            notyuri("Error in [Pop.SpinWheel]: " .. tostring(err))
        end
        task.wait(1)
    end
end
local function FuncDaily()
    while Toggles.AutoDaily.Value do
        local ok, err = pcall(function()
            if not RemotesReady then return end
            if R.GetDailyRewardStatus ~= nil then
                local status = SafeInvoke(R.GetDailyRewardStatus)
                if type(status) == "table" and status.claimable == true and R.ClaimDailyReward ~= nil then
                    local res = SafeInvoke(R.ClaimDailyReward)
                    if type(res) == "table" and res.success then
                        Library:Notify("Daily reward claimed (Day " .. tostring(res.day) .. ")", 5)
                    end
                end
            end
            if type(Pop.MissionState) == "table" and R.DailyMissionClaim ~= nil then
                for _, mission in ipairs(Pop.MissionState.missions or {}) do
                    if type(mission) == "table" and mission.claimed ~= true then
                        local progress = mission.progress or 0
                        local target = mission.target or 1
                        if progress >= target then
                            SafeInvoke(R.DailyMissionClaim, mission.id)
                            task.wait(0.3)
                        end
                    end
                end
                local completeAll = Pop.MissionState.completeAll
                if type(completeAll) == "table" and completeAll.readyApplied == true and completeAll.completeAllClaimed ~= true and R.DailyMissionCompleteAllClaim ~= nil then
                    SafeInvoke(R.DailyMissionCompleteAllClaim)
                    task.wait(0.5)
                end
            end
            if type(Pop.PlaytimeState) == "table" and R.DailyPlaytimeRewardClaim ~= nil then
                local claimed = {}
                for _, slot in ipairs(Pop.PlaytimeState.claimedSlots or {}) do
                    claimed[slot] = true
                end
                local elapsed = (Pop.PlaytimeState.dailyPlaytimeSeconds or 0) + (os.clock() - Pop.PlaytimeReceivedAt)
                for _, reward in ipairs(Pop.PlaytimeState.rewards or {}) do
                    if type(reward) == "table" and reward.slotIndex ~= nil and not claimed[reward.slotIndex] then
                        local threshold = nil
                        if PlaytimeConstantsModule and PlaytimeConstantsModule.getDailyPlaytimeSlotThresholdSeconds then
                            local okT, res = pcall(PlaytimeConstantsModule.getDailyPlaytimeSlotThresholdSeconds, reward.slotIndex)
                            if okT and type(res) == "number" then threshold = res end
                        end
                        if threshold ~= nil and threshold <= elapsed then
                            SafeInvoke(R.DailyPlaytimeRewardClaim, reward.slotIndex)
                            task.wait(0.3)
                        end
                    end
                end
            end
            if R.GetOfflineEarningsPending ~= nil then
                local pending = SafeInvoke(R.GetOfflineEarningsPending)
                if type(pending) == "table" and pending.hasPending == true and R.ClaimOfflineEarnings ~= nil then
                    SafeInvoke(R.ClaimOfflineEarnings)
                    Library:Notify("Offline earnings claimed", 4)
                end
            end
            local tickets = tonumber(Plr:GetAttribute("SpinWheelTickets")) or 0
            if tickets > 0 and R.SpinWheelSpin ~= nil then
                local spin = SafeInvoke(R.SpinWheelSpin)
                if type(spin) == "table" and spin.success and R.SpinWheelFlushRewards ~= nil then
                    task.wait(3)
                    FireRemote(R.SpinWheelFlushRewards)
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [Pop.Daily]: " .. tostring(err), 10)
            notyuri("Error in [Pop.Daily]: " .. tostring(err))
        end
        task.wait(60)
    end
end
local function PopBuildZoneList()
    local list = {}
    if TeleportDests ~= nil then
        local order = {"Hub", "Base", "Fusion"}
        for _, key in ipairs(order) do
            if TeleportDests[key] ~= nil then table.insert(list, key) end
        end
        if Zones ~= nil then
            for _, zone in ipairs(Zones) do
                if TeleportDests[zone.name] ~= nil and table.find(list, zone.name) == nil then
                    table.insert(list, zone.name)
                end
            end
        end
        for key in pairs(TeleportDests) do
            if table.find(list, key) == nil then table.insert(list, key) end
        end
    end
    return list
end
local PopEggNames = {E1 = "Common", E2 = "Uncommon", E3 = "Rare", E4 = "Epic", E5 = "Legendary", E6 = "Mythic"}
local function PopBuildEggList()
    local values, labels = {}, {}
    notyuri("[Pop.BuildEggList] PetEggConfigModule=", tostring(PetEggConfigModule), "EGGS type=", PetEggConfigModule and tostring(type(PetEggConfigModule.EGGS)) or "n/a")
    if PetEggConfigModule ~= nil and type(PetEggConfigModule.EGGS) == "table" then
        for _, eggId in ipairs(PetEggConfigModule.EGGS) do
            local label = PopEggNames[eggId] and (PopEggNames[eggId] .. " Egg (" .. eggId .. ")") or eggId
            table.insert(values, label)
            labels[label] = eggId
        end
    end
    notyuri("[Pop.BuildEggList] #values=", tostring(#values), "labels is nil=", tostring(labels == nil))
    return values, labels
end
local function PopBuildLuckyBlockList()
    local values, labels = {}, {}
    notyuri("[Pop.BuildLuckyBlockList] LootboxConfigModule=", tostring(LootboxConfigModule), "LootboxData type=", LootboxConfigModule and tostring(type(LootboxConfigModule.LootboxData)) or "n/a")
    if LootboxConfigModule ~= nil and type(LootboxConfigModule.LootboxData) == "table" then
        local ids = {}
        for id in pairs(LootboxConfigModule.LootboxData) do
            table.insert(ids, id)
        end
        table.sort(ids)
        for _, id in ipairs(ids) do
            local def = LootboxConfigModule.LootboxData[id]
            local label = (def and def.name) or tostring(id)
            table.insert(values, label)
            labels[label] = tostring(id)
        end
    end
    notyuri("[Pop.BuildLuckyBlockList] #values=", tostring(#values), "labels is nil=", tostring(labels == nil))
    return values, labels
end
PopEggValues, PopEggLabels = PopBuildEggList()
PopLuckyBlockValues, PopLuckyBlockLabels = PopBuildLuckyBlockList()
notyuri("[Pop.Init] after build: PopEggLabels is nil=", tostring(PopEggLabels == nil), "PopLuckyBlockLabels is nil=", tostring(PopLuckyBlockLabels == nil))
local function PopBuildUpgradeList()
    local list = {}
    if UpgradeAttribute ~= nil then
        local order = {"BubbleValue", "MaxBubbles", "BubbleSpawnRate", "MultiPopChance", "Luck", "BubbletChance"}
        for _, name in ipairs(order) do
            if UpgradeAttribute[name] ~= nil then table.insert(list, name) end
        end
        for name in pairs(UpgradeAttribute) do
            if table.find(list, name) == nil then table.insert(list, name) end
        end
    end
    return list
end
local function PopBuildPotionList()
    local values = {}
    local labelMap = {}
    if PotionCatalog ~= nil then
        local order = {"cash", "gem", "luck", "bubbleMayhem", "bubbletChance", "fireRate", "damage"}
        local seen = {}
        for _, key in ipairs(order) do
            if PotionCatalog[key] ~= nil then
                local label = (PotionDisplayNames and PotionDisplayNames[key]) or key
                table.insert(values, label)
                labelMap[label] = key
                seen[key] = true
            end
        end
        for key in pairs(PotionCatalog) do
            if not seen[key] then
                local label = (PotionDisplayNames and PotionDisplayNames[key]) or key
                table.insert(values, label)
                labelMap[label] = key
            end
        end
    end
    return values, labelMap
end
local function PopTeleportNow()
    if not RemotesReady or R.TeleportIntent == nil then return end
    local key = Options.PopZoneDropdown and Options.PopZoneDropdown.Value
    if type(key) ~= "string" or key == "" then return end
    FireRemote(R.TeleportIntent, key)
    local dest = TeleportDests and TeleportDests[key] or nil
    if dest == nil then return end
    local attachName = dest.attachmentName or key
    if key == "Base" then
        local baseAttr = (MapAttribute and MapAttribute.BaseSpawnAnchorCFrame) or "BaseSpawnAnchorCFrame"
        local anchorCf = Plr:GetAttribute(baseAttr)
        if typeof(anchorCf) == "CFrame" then
            TPTo(anchorCf)
            Library:Notify("Teleported to " .. key, 3)
            return
        end
        attachName = "Hub"
    end
    local teleportTag = (MapTag and MapTag.TeleportPoint) or "TeleportPoint"
    local zoneAttr = (MapAttribute and MapAttribute.ZoneName) or "ZoneName"
    local point = nil
    for _, inst in ipairs(CollectionService:GetTagged(teleportTag)) do
        if inst:GetAttribute(zoneAttr) == attachName then
            point = inst
            break
        end
    end
    if point == nil then
        Library:Notify("Teleport point not found for " .. key, 4)
        return
    end
    local cf = nil
    if point:IsA("Attachment") then
        cf = point.WorldCFrame
    elseif point:IsA("BasePart") then
        cf = point.CFrame
    end
    if cf ~= nil then
        TPTo(cf * CFrame.new(0, TeleportOffsetY, 0))
        Library:Notify("Teleported to " .. key, 3)
    end
end
local PopZoneList = PopBuildZoneList()
local PopUpgradeList = PopBuildUpgradeList()
local PopPotionValues, PopPotionLabels = PopBuildPotionList()
TB_Tabs.Autofarm.T1:AddToggle("AutoPop", { Text = "Auto Pop", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect", Default = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquipBubbles", { Text = "Auto Equip Bubblets", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradeBubblets", { Text = "Auto Upgrade Bubblets", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSlot", { Text = "Auto Unlock Slot", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquipPet", { Text = "Auto Equip Best Pet", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPotion", { Text = "Auto Potions", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEgg", { Text = "Auto Open Egg", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoLuckyBlock", { Text = "Auto Open Lucky Block", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBoss", { Text = "Auto Boss", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSpinWheel", { Text = "Auto Spin Wheel", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("PopEggDropdown", { Text = "Egg", Values = PopEggValues, Default = PopEggValues[1] })
TB_Tabs.Autofarm2.T1:AddDropdown("PopLuckyBlockDropdown", { Text = "Lucky Block", Values = PopLuckyBlockValues, Default = PopLuckyBlockValues[1] })
UpgradeGetSelection = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "UpgradeList", { Text = "Upgrade List", Values = PopUpgradeList, Default = {} })
PotionGetSelection = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PotionList", { Text = "Potion List", Values = PopPotionValues, label = PopPotionLabels, Default = {} })
Toggles.AutoPop:OnChanged(function() Thread("Pop.AutoPop", FuncAutoPop, Toggles.AutoPop.Value) end)
Toggles.AutoCollect:OnChanged(function() Thread("Pop.Collect", FuncCollect, Toggles.AutoCollect.Value) end)
Toggles.AutoRebirth:OnChanged(function() Thread("Pop.Rebirth", FuncRebirth, Toggles.AutoRebirth.Value) end)
Toggles.AutoUpgrade:OnChanged(function() Thread("Pop.Upgrade", FuncUpgrade, Toggles.AutoUpgrade.Value) end)
Toggles.AutoEquipBubbles:OnChanged(function() Thread("Pop.EquipBest", FuncEquipBest, Toggles.AutoEquipBubbles.Value) end)
Toggles.AutoUpgradeBubblets:OnChanged(function() Thread("Pop.UpgradeBubblets", FuncUpgradeBubblets, Toggles.AutoUpgradeBubblets.Value) end)
Toggles.AutoSlot:OnChanged(function() Thread("Pop.UnlockBubbleSlot", FuncUnlockBubbleSlot, Toggles.AutoSlot.Value) end)
Toggles.AutoEquipPet:OnChanged(function() Thread("Pop.EquipPet", FuncEquipPet, Toggles.AutoEquipPet.Value) end)
Toggles.AutoPotion:OnChanged(function() Thread("Pop.Potion", FuncPotion, Toggles.AutoPotion.Value) end)
Toggles.AutoEgg:OnChanged(function() Thread("Pop.Egg", FuncEgg, Toggles.AutoEgg.Value) end)
Toggles.AutoLuckyBlock:OnChanged(function() Thread("Pop.LuckyBlock", FuncLuckyBlock, Toggles.AutoLuckyBlock.Value) end)
Toggles.AutoBoss:OnChanged(function() Thread("Pop.Boss", FuncBoss, Toggles.AutoBoss.Value) end)
Toggles.AutoSpinWheel:OnChanged(function() Thread("Pop.SpinWheel", FuncSpinWheel, Toggles.AutoSpinWheel.Value) end)
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
SaveManager:SetFolder("Yuri/PopBubbles")
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
