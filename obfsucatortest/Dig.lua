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
local PGui = Plr.PlayerGui
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
local Support = {
    Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard = (typeof(setclipboard) == "function"),
    FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
    Connections = (typeof(getconnections) == "function"),
    FPS = (typeof(setfpscap) == "function"),
    Proximity = (typeof(fireproximityprompt) == "function"),
}
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
            local inviteCode = "q8QX76jyz"
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
        for _, connection in ipairs(getconnections(signal)) do
            if connection.Function then
                task.spawn(connection.Function, ...)
            end
        end
    else
        warn("Your executor does not support firesignal or getconnections.")
    end
end
local Remotes = {
    Knit = nil,
}
local Flags = {}
local Shared = {}
local Tables = {
    GearCategoryList = {"shovel", "detector", "spray"},
}
local ShovelsRaw = GetSafeModule(RS:FindFirstChild("TS") and RS.TS:FindFirstChild("constants") and RS.TS.constants:FindFirstChild("digging"), "Shovels")
local DetectorsRaw = GetSafeModule(RS:FindFirstChild("TS") and RS.TS:FindFirstChild("constants") and RS.TS.constants:FindFirstChild("digging"), "Detectors")
local SprayBottlesRaw = GetSafeModule(RS:FindFirstChild("TS") and RS.TS:FindFirstChild("constants") and RS.TS.constants:FindFirstChild("cleaning"), "SprayBottles")
local Modules = {
    Shovels = ShovelsRaw and ShovelsRaw.Shovels,
    Detectors = DetectorsRaw and DetectorsRaw.Detectors,
    SprayBottles = SprayBottlesRaw and SprayBottlesRaw.SprayBottles,
    Items = GetSafeModule(RS:FindFirstChild("TS") and RS.TS:FindFirstChild("constants") and RS.TS.constants:FindFirstChild("items"), "Items"),
}
local function GetNetworkModule(name)
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local ts = ps:FindFirstChild("TS")
    if not ts then return nil end
    local net = ts:FindFirstChild("network")
    if not net then return nil end
    return GetSafeModule(net, name)
end
local function GetNetworkFunction(moduleName, exportName)
    local mod = GetNetworkModule(moduleName)
    if not mod then return nil end
    return mod[exportName]
end
local function InvokeNet(moduleName, exportName, funcName, ...)
    local netObj = GetNetworkFunction(moduleName, exportName)
    if not netObj then
        notyuri("[InvokeNet] module/export not found:", moduleName, exportName)
        return nil
    end
    if not netObj[funcName] then
        notyuri("[InvokeNet] function not found on export:", moduleName, exportName, funcName)
        return nil
    end
    local args = {...}
    local result = nil
    local done = false
    local ok, err = pcall(function()
        local promise = netObj[funcName]:invoke(unpack(args))
        if promise and type(promise) == "table" and promise.andThen then
            promise:andThen(function(...)
                result = {...}
                done = true
            end):catch(function(e)
                notyuri("[InvokeNet] promise rejected:", moduleName, exportName, funcName, tostring(e))
                done = true
            end)
        else
            result = promise
            done = true
        end
    end)
    if not ok then
        notyuri("[InvokeNet] pcall failed:", moduleName, exportName, funcName, tostring(err))
    end
    if not done then
        local start = tick()
        repeat task.wait() until done or (tick() - start) > 5
        if not done then
            notyuri("[InvokeNet] timed out:", moduleName, exportName, funcName)
        end
    end
    return result
end
local function FireNet(moduleName, exportName, eventName, ...)
    local netObj = GetNetworkFunction(moduleName, exportName)
    if not netObj then
        notyuri("[FireNet] module/export not found:", moduleName, exportName)
        return
    end
    if not netObj[eventName] then
        notyuri("[FireNet] event not found on export:", moduleName, exportName, eventName)
        return
    end
    local args = {...}
    local ok, err = pcall(function()
        netObj[eventName]:fire(unpack(args))
    end)
    if not ok then
        notyuri("[FireNet] pcall failed:", moduleName, exportName, eventName, tostring(err))
    end
end
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
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
            local newThread = task.spawn(featureFunc, ...)
            currentTable[flagKey] = newThread
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
        Default = Config.DefaultToggle or false
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
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end)
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
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
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
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
    local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
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
    if not v then
        setfpscap(999)
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
local function RunAntiAFK()
    local GC = getconnections or get_signal_cons
    if GC then
        for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    else
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end
Toggles.AntiAFK:OnChanged(function(state)
    if state then RunAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local function Func_AutoDig()
    local flameworkModule = GetObject(RS, "rbxts_include.node_modules.@flamework.core.out.flamework")
    if not flameworkModule then
        return
    end
    local ok, flameworkExports = pcall(require, flameworkModule)
    if not ok or not flameworkExports or not flameworkExports.Flamework then
        return
    end
    local resolveOk, digController = pcall(flameworkExports.Flamework.resolveDependency, "client/controllers/world/DigController@DigController")
    if not resolveOk or not digController then
        return
    end
    local DIG_WIN_THRESHOLD = 0.985
    local wasDigging = false
    while Toggles.AutoDig.Value do
        local session = digController.session
        if session and session.phase == "minigame" then
            if not wasDigging then
                wasDigging = true
            end
            pcall(function()
                digController:onDigInput()
            end)
            if session.progress and session.progress >= DIG_WIN_THRESHOLD then
                pcall(function()
                    digController:finish(true)
                end)
                wasDigging = false
            end
        else
            wasDigging = false
        end
        task.wait()
    end
end
local function Func_AutoClean()
    while true do
        local Character = Plr.Character
        local inventoryId = nil
        if Character then
            for _, tool in ipairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local id = tool:GetAttribute("inventoryId")
                    if id ~= nil and tool:GetAttribute("dirty") ~= false then
                        inventoryId = id
                        break
                    end
                end
            end
        end
        if not inventoryId then
            local Backpack = Plr:FindFirstChild("Backpack")
            if Backpack then
                for _, tool in ipairs(Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        local id = tool:GetAttribute("inventoryId")
                        if id ~= nil and tool:GetAttribute("dirty") ~= false then
                            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                            inventoryId = id
                            break
                        end
                    end
                end
            end
        end
        if inventoryId then
            FireNet("ItemsNetwork", "ItemsEvents", "finishCleaning", inventoryId)
        end
        task.wait()
    end
end
local function GetOwnPlot()
    local Plots = Workspace:FindFirstChild("Plots")
    if not Plots then return nil end
    for _, plot in ipairs(Plots:GetChildren()) do
        if plot:GetAttribute("OwnerUserId") == Plr.UserId then
            return plot
        end
    end
    return nil
end
local function GetPedestals()
    local plot = GetOwnPlot()
    if not plot then return nil end
    local plotFolder = plot:FindFirstChild("Plot")
    if not plotFolder then return nil end
    local pedestals = plotFolder:FindFirstChild("Pedestals")
    if not pedestals then return nil end
    local result = {}
    for _, pedestal in ipairs(pedestals:GetChildren()) do
        local slot = pedestal:GetAttribute("Slot")
        if slot ~= nil then
            local itemUid = pedestal:GetAttribute("ItemUid")
            local entry = { slot = slot, occupied = itemUid ~= nil and itemUid ~= "" }
            if entry.occupied then
                local itemId = pedestal:GetAttribute("ItemId")
                if itemId ~= nil and Modules.Items then
                    local kg = pedestal:GetAttribute("Kg")
                    local condition = pedestal:GetAttribute("Condition")
                    if condition ~= nil then
                        entry.value = Modules.Items.itemValueFor(itemId, condition, kg)
                    else
                        entry.value = Modules.Items.dirtyItemValueFor(itemId, kg)
                    end
                end
            end
            table.insert(result, entry)
        end
    end
    return result
end
local function GetSortedInventoryByValue()
    if not Modules.Items then return nil end
    local data = InvokeNet("DataNetwork", "DataFunctions", "requestDataUpdate")
    local playerData = data and (data[1] or data)
    if not playerData or not playerData.Inventory then return nil end
    local sorted = {}
    for _, item in pairs(playerData.Inventory) do
        if item.uid and item.pedestalSlot == nil then
            local value
            if item.dirty or item.condition == nil then
                value = Modules.Items.dirtyItemValueFor(item.id, item.kg)
            else
                value = Modules.Items.itemValueFor(item.id, item.condition, item.kg)
            end
            if value then
                table.insert(sorted, { uid = item.uid, value = value })
            end
        end
    end
    table.sort(sorted, function(a, b) return a.value > b.value end)
    return sorted
end
local function Func_AutoPlace()
    while true do
        local pedestals = GetPedestals()
        if pedestals then
            table.sort(pedestals, function(a, b)
                if a.occupied ~= b.occupied then
                    return not a.occupied
                end
                if not a.occupied then
                    return false
                end
                return (a.value or 0) < (b.value or 0)
            end)
            local inventory = GetSortedInventoryByValue()
            if inventory then
                local used = {}
                for _, pedestal in ipairs(pedestals) do
                    local bestItem
                    for _, item in ipairs(inventory) do
                        if not used[item.uid] then
                            bestItem = item
                            break
                        end
                    end
                    if bestItem then
                        if not pedestal.occupied then
                            InvokeNet("PedestalNetwork", "PedestalFunctions", "placeItem", pedestal.slot, bestItem.uid)
                            used[bestItem.uid] = true
                        elseif pedestal.value ~= nil and bestItem.value > pedestal.value then
                            InvokeNet("PedestalNetwork", "PedestalFunctions", "placeItem", pedestal.slot, bestItem.uid)
                            used[bestItem.uid] = true
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local SurfacedItemsCache = {}
local SurfacedItemsCacheReady = false
local function InitSurfacedItemsCache()
    local events = GetNetworkFunction("ShovelNetwork", "ShovelEvents")
    if not events then
        notyuri("[AutoTeleportDig] ShovelEvents not found")
        return
    end
    notyuri("[AutoTeleportDig] ShovelEvents type:", typeof(events), "has SurfacedItemSpawned:", tostring(events.SurfacedItemSpawned ~= nil))
    if events.SurfacedItemSpawned then
        local ok, err = pcall(function()
            events.SurfacedItemSpawned:connect(function(...)
                local item = ...
                notyuri("[AutoTeleportDig] RAW SurfacedItemSpawned fired, argType:", typeof(item))
                if item and item.id then
                    SurfacedItemsCache[item.id] = item
                    notyuri("[AutoTeleportDig] surfaced spawned", item.id, item.itemId)
                end
            end)
        end)
        notyuri("[AutoTeleportDig] connect SurfacedItemSpawned ok:", tostring(ok), err and tostring(err) or "")
    end
    if events.SurfacedItemReleased then
        events.SurfacedItemReleased:connect(function(item)
            if item and item.id then
                SurfacedItemsCache[item.id] = item
                notyuri("[AutoTeleportDig] surfaced released", item.id, item.itemId)
            end
        end)
    end
    if events.SurfacedItemClaimed then
        events.SurfacedItemClaimed:connect(function(id, userId)
            if id then
                SurfacedItemsCache[id] = nil
                notyuri("[AutoTeleportDig] surfaced claimed", id, "by", tostring(userId))
            end
        end)
    end
    if events.SurfacedItemRemoved then
        events.SurfacedItemRemoved:connect(function(id)
            if id then
                SurfacedItemsCache[id] = nil
                notyuri("[AutoTeleportDig] surfaced removed", id)
            end
        end)
    end
    local result = InvokeNet("ShovelNetwork", "ShovelFunctions", "GetSurfacedItems")
    local items = result and (result[1] or result)
    if type(items) == "table" then
        for _, item in ipairs(items) do
            if item.id then
                SurfacedItemsCache[item.id] = item
            end
        end
        notyuri("[AutoTeleportDig] seeded surfaced cache with", #items, "items")
    end
    SurfacedItemsCacheReady = true
end
local BuriedNodesCache = {}
local BuriedNodesCacheReady = false
local function InitBuriedNodesCache()
    local events = GetNetworkFunction("DetectorNetwork", "DetectorEvents")
    if not events then
        notyuri("[AutoTeleportDig] DetectorEvents not found")
        return
    end
    notyuri("[AutoTeleportDig] DetectorEvents type:", typeof(events), "has BuriedNodes:", tostring(events.BuriedNodes ~= nil))
    if events.BuriedNodes then
        local ok, err = pcall(function()
            events.BuriedNodes:connect(function(added, removed)
                notyuri("[AutoTeleportDig] RAW BuriedNodes fired, addedType:", typeof(added), "removedType:", typeof(removed))
                if type(added) == "table" then
                    for _, node in ipairs(added) do
                        if node.id then
                            BuriedNodesCache[node.id] = node
                            notyuri("[AutoTeleportDig] buried node added", node.id, node.rarity)
                        end
                    end
                end
                if type(removed) == "table" then
                    for _, id in ipairs(removed) do
                        BuriedNodesCache[id] = nil
                        notyuri("[AutoTeleportDig] buried node removed", id)
                    end
                end
            end)
        end)
        notyuri("[AutoTeleportDig] connect BuriedNodes ok:", tostring(ok), err and tostring(err) or "")
    end
    BuriedNodesCacheReady = true
end
local function GetBestSurfacedSpot()
    if not Modules.Items then return nil end
    if not SurfacedItemsCacheReady then
        InitSurfacedItemsCache()
    end
    if not BuriedNodesCacheReady then
        InitBuriedNodesCache()
    end
    local selected = Shared.selectedDigRarities
    if not selected or not next(selected) then
        return nil
    end
    local itemDefs = Modules.Items.Items
    local rarityOrder = Modules.Items.RARITY_ORDER
    local bestSpot, bestRank = nil, -1
    for _, spot in pairs(SurfacedItemsCache) do
        local def = itemDefs and itemDefs[spot.itemId]
        local rarity = def and def.rarity
        if rarity and selected[rarity] then
            local rank = rarityOrder and table.find(rarityOrder, rarity) or 0
            if rank and rank > bestRank then
                bestRank = rank
                bestSpot = spot
            end
        end
    end
    for _, node in pairs(BuriedNodesCache) do
        local rarity = node.rarity
        if rarity and selected[rarity] then
            local rank = rarityOrder and table.find(rarityOrder, rarity) or 0
            if rank and rank > bestRank then
                bestRank = rank
                bestSpot = node
            end
        end
    end
    local surfacedCount, buriedCount = 0, 0
    for _ in pairs(SurfacedItemsCache) do surfacedCount = surfacedCount + 1 end
    for _ in pairs(BuriedNodesCache) do buriedCount = buriedCount + 1 end
    notyuri("[AutoTeleportDig] surfaced:", surfacedCount, "buried:", buriedCount, "best spot:", bestSpot and bestSpot.id or "none")
    return bestSpot
end
local function Func_AutoTeleportDig()
    FireNet("DetectorNetwork", "DetectorEvents", "SetDetectorHeld", true)
    notyuri("[AutoTeleportDig] sent SetDetectorHeld(true)")
    while true do
        local character = GetCharacter()
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            notyuri("[AutoTeleportDig] no character/HRP")
        else
            local spot = GetBestSurfacedSpot()
            if spot and spot.position then
                notyuri("[AutoTeleportDig] teleporting to", spot.id, tostring(spot.position))
                hrp.CFrame = CFrame.new(spot.position + Vector3.new(0, 3, 0))
                task.wait(0.5)
                local digResult = InvokeNet("ShovelNetwork", "ShovelFunctions", "BeginDig", spot.id)
                notyuri("[AutoTeleportDig] BeginDig result:", typeof(digResult))
            end
        end
        task.wait(1)
    end
end
local function Func_AutoFreeSkip()
    while true do
        FireNet("ItemsNetwork", "ItemsEvents", "useFreeSkip")
        task.wait(1)
    end
end
local function Func_AutoSellInventory()
    while true do
        InvokeNet("SellNetwork", "SellFunctions", "sellInventory")
        task.wait(3)
    end
end
local function GetPlayerGearData()
    local data = InvokeNet("DataNetwork", "DataFunctions", "requestDataUpdate")
    return data and (data[1] or data)
end
local function PickBestAffordable(defs, gold, owned)
    local ownedSet = {}
    if owned then
        for _, id in ipairs(owned) do
            ownedSet[id] = true
        end
    end
    local bestOwnedId, bestOwnedCost = nil, -1
    local bestBuyId, bestBuyCost = nil, -1
    for id, def in pairs(defs) do
        if type(def) == "table" and type(def.cost) == "number" then
            if ownedSet[id] then
                if def.cost > bestOwnedCost then
                    bestOwnedCost = def.cost
                    bestOwnedId = id
                end
            elseif gold and def.cost <= gold and def.cost > bestBuyCost then
                bestBuyCost = def.cost
                bestBuyId = id
            end
        end
    end
    if bestBuyId and bestBuyCost > bestOwnedCost then
        return bestBuyId, true
    end
    return bestOwnedId, false
end
local function Func_AutoGearShovel()
    while true do
        if Modules.Shovels then
            local data = GetPlayerGearData()
            if data then
                local id, needsBuy = PickBestAffordable(Modules.Shovels, data.Gold, data.OwnedShovels)
                if id then
                    if needsBuy then
                        InvokeNet("ShopNetwork", "ShopFunctions", "buyGear", "shovel", id)
                    end
                    if data.EquippedShovel ~= id then
                        InvokeNet("ShopNetwork", "ShopFunctions", "equipGear", "shovel", id)
                    end
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoGearDetector()
    while true do
        if Modules.Detectors then
            local data = GetPlayerGearData()
            if data then
                local id, needsBuy = PickBestAffordable(Modules.Detectors, data.Gold, data.OwnedDetectors)
                if id then
                    if needsBuy then
                        InvokeNet("ShopNetwork", "ShopFunctions", "buyGear", "detector", id)
                    end
                    if data.EquippedDetector ~= id then
                        InvokeNet("ShopNetwork", "ShopFunctions", "equipGear", "detector", id)
                    end
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoGearSpray()
    while true do
        if Modules.SprayBottles then
            local data = GetPlayerGearData()
            if data then
                local id, needsBuy = PickBestAffordable(Modules.SprayBottles, data.Gold, data.OwnedSprays)
                if id then
                    if needsBuy then
                        InvokeNet("ShopNetwork", "ShopFunctions", "buyGear", "spray", id)
                    end
                    if data.EquippedSpray ~= id then
                        InvokeNet("ShopNetwork", "ShopFunctions", "equipGear", "spray", id)
                    end
                end
            end
        end
        task.wait(2)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoDig", { Text = "Auto Dig", Default = false, Callback = function(val) Thread("AutoDig", SafeLoop("Auto Dig", Func_AutoDig), val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoClean", { Text = "Auto Clean", Default = false, Callback = function(val) Thread("AutoClean", Func_AutoClean, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false, Callback = function(val) Thread("AutoPlace", Func_AutoPlace, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoGearShovel", { Text = "Auto Shovel", Default = false, Callback = function(val) Thread("AutoGearShovel", Func_AutoGearShovel, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoGearDetector", { Text = "Auto Detector", Default = false, Callback = function(val) Thread("AutoGearDetector", Func_AutoGearDetector, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoGearSpray", { Text = "Auto Spray", Default = false, Callback = function(val) Thread("AutoGearSpray", Func_AutoGearSpray, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoSellInventory", { Text = "Auto Sell Inventory", Default = false, Callback = function(val) Thread("AutoSellInventory", SafeLoop("Auto Sell Inventory", Func_AutoSellInventory), val) end })
TB_Tabs.Autofarm.T1:AddButton({ Text = "TP Shipwreck", Func = function()
    local character = GetCharacter()
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(1363, 19, 14)
    end
end })
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
    Cleanup(Connections)
    Cleanup(Flags)
        Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/DAC")
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