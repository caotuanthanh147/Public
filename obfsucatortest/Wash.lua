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
local Remotes = {
}
local Modules = {
    GameConfig = GetSafeModule(RS:FindFirstChild("Shared"), "GameConfig"),
}
local GameConfig = Modules.GameConfig
local Flags = {}
local Shared = {}
local Tables = {
    UpgradeList = {"Distance", "Size", "Speed", "Range", "Capacity"},
    UpgradeMap = {Distance = "Distance", Size = "Size", Speed = "Speed", Range = "Range", Capacity = "Capacity"},
    AbilityList = {"Highlight", "Telekenisis", "Bathbomb", "XRay"},
    AbilityMap = {Highlight = "Highlight", Telekenisis = "Telekenisis", Bathbomb = "Bathbomb", XRay = "XRay"},
}
local function GetNet()
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local client = ps:FindFirstChild("Client")
    if not client then return nil end
    local ok, net = pcall(require, client:FindFirstChild("Net"))
    return ok and net or nil
end
local function NetFire(scope, name, ...)
    local net = GetNet()
    if not net then
        notyuri("NetFire", scope, name, "FAILED: GetNet() returned nil")
        return
    end
    if not net[scope] then
        notyuri("NetFire", scope, name, "FAILED: net[" .. tostring(scope) .. "] is nil")
        return
    end
    local args = {...}
    local ok, err = pcall(function()
        net[scope]:fire(name, unpack(args))
    end)
    if not ok then
        notyuri("NetFire", scope, name, "FAILED: fire() errored:", tostring(err))
    end
end
local function NetFetch(scope, name, ...)
    local net = GetNet()
    if not net or not net[scope] then return nil end
    local args = {...}
    local result = nil
    pcall(function()
        result = net[scope]:fetch(name, unpack(args))
    end)
    return result
end
local function GetDirtyCleanables()
    local CS = game:GetService("CollectionService")
    local parts = {}
    for _, part in ipairs(CS:GetTagged("Cleanable")) do
        if part:IsA("BasePart") and part.Parent then
            local faces = part:GetAttribute("CleanFaces")
            if faces and part:FindFirstChild("PowerWashDirt") then
                table.insert(parts, part)
            end
        end
    end
    return parts
end
if GameConfig then
    local upgrades = GameConfig.Upgrades
    if upgrades then
        Tables.UpgradeList = {}
        Tables.UpgradeMap = {}
        for id, def in pairs(upgrades) do
            if type(def) == "table" and def.name then
                local label = tostring(def.name)
                table.insert(Tables.UpgradeList, label)
                Tables.UpgradeMap[label] = id
            end
        end
        table.sort(Tables.UpgradeList)
    end
end
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
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
local function TeleportTo(root, cframe)
    if not (root and cframe) then return end
    root.CFrame = cframe * CFrame.new(0, 3, 0)
    task.wait(0.175)
end
local FaceLocalNormal = {
    Front = Vector3.new(0, 0, -1),
    Back = Vector3.new(0, 0, 1),
    Right = Vector3.new(1, 0, 0),
    Left = Vector3.new(-1, 0, 0),
    Top = Vector3.new(0, 1, 0),
    Bottom = Vector3.new(0, -1, 0),
}
local function BuildFaceSamples(part, face, hits)
    local localNormal = FaceLocalNormal[face]
    if not localNormal then return end
    local size = part.Size
    local cframe = part.CFrame
    local halfX = (size.X / 2) * (Vector3.new(1, 0, 0) - localNormal * localNormal:Dot(Vector3.new(1, 0, 0)))
    local halfY = (size.Y / 2) * (Vector3.new(0, 1, 0) - localNormal * localNormal:Dot(Vector3.new(0, 1, 0)))
    local halfZ = (size.Z / 2) * (Vector3.new(0, 0, 1) - localNormal * localNormal:Dot(Vector3.new(0, 0, 1)))
    local tangentA = halfX.Magnitude > 0.001 and halfX or halfZ
    local tangentB = halfY.Magnitude > 0.001 and halfY or halfZ
    if tangentA == tangentB then tangentB = halfZ end
    local offsets = {
        {-0.5, -0.5}, {0.5, -0.5}, {-0.5, 0.5}, {0.5, 0.5},
    }
    for _, off in ipairs(offsets) do
        local localPoint = localNormal * (size * localNormal).Magnitude / 2
            + tangentA * off[1]
            + tangentB * off[2]
        local worldPoint = cframe:PointToWorldSpace(localPoint)
        table.insert(hits, {
            p = part,
            f = face,
            pos = worldPoint,
        })
    end
end
local function DoSpray(part, face, sprayDir)
    local hits = {}
    BuildFaceSamples(part, face, hits)
    if #hits == 0 then return end
    NetFire("match", "reportSpray", hits, sprayDir)
    NetFire("match", "reportWashProgress", part, face, 1)
    NetFire("match", "reportSurfaceComplete", part, face)
end
local function Func_AutoSpray()
    while true do
        local parts = GetDirtyCleanables()
        local char = Plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if #parts > 0 and root then
            local sprayDir = cam and cam.CFrame.UpVector or Vector3.new(0, 1, 0)
            local range = (Options.SprayRange and Options.SprayRange.Value) or 999
            local nearestPart = nil
            local nearestDist = math.huge
            for _, part in ipairs(parts) do
                local dist = (root.Position - part.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestPart = part
                end
            end
            if nearestPart and nearestDist < range then
                local facesAttr = nearestPart:GetAttribute("CleanFaces") or ""
                local faces = {}
                for f in string.gmatch(facesAttr, "[^,%s]+") do
                    table.insert(faces, f)
                end
                if #faces == 0 then
                    faces = {"Front", "Back", "Left", "Right", "Top", "Bottom"}
                end
                for _, face in ipairs(faces) do
                    DoSpray(nearestPart, face, sprayDir)
                end
            end
        end
        task.wait()
    end
end
local function GetCarryClient()
    local ps = Plr:FindFirstChild("PlayerScripts")
    local client = ps and ps:FindFirstChild("Client")
    local mod = client and client:FindFirstChild("CarryClient")
    local ok, result = pcall(require, mod)
    return ok and result or nil
end
local function NearestPlaceableSlot(slotsFolder, carried, root)
    if not (slotsFolder and root and #carried > 0) then return nil, nil end
    local bestDist, bestSlot, bestItem = math.huge, nil, nil
    for _, slot in ipairs(slotsFolder:GetChildren()) do
        if slot:IsA("BasePart") and not slot:GetAttribute("Filled") then
            local dist = (Vector3.new(slot.Position.X, 0, slot.Position.Z) - Vector3.new(root.Position.X, 0, root.Position.Z)).Magnitude
            if dist < bestDist then
                local slotKind = slot:GetAttribute("SlotKind")
                local category = slot:GetAttribute("Category")
                local pairId = slot:GetAttribute("PairId")
                for _, carriedItem in ipairs(carried) do
                    if carriedItem:GetAttribute("SortKind") == slotKind
                        and carriedItem:GetAttribute("Category") == category
                        and carriedItem:GetAttribute("PairId") == pairId then
                        bestDist, bestSlot, bestItem = dist, slot, carriedItem
                        break
                    end
                end
            end
        end
    end
    return bestSlot, bestItem
end
local function GetActiveHouse()
    for _, node in ipairs(workspace:GetChildren()) do
        if node:IsA("Model") and node:GetAttribute("CleanHouse") then
            return node
        end
    end
    return nil
end
local function PlaceCarried(root, CarryClient, slotsFolder, house)
    if not slotsFolder then return false end
    while true do
        local carried = CarryClient.get()
        if #carried == 0 then return true end
        local slot, carriedItem = NearestPlaceableSlot(slotsFolder, carried, root)
        if not (slot and carriedItem) then
            return false
        end
        TeleportTo(root, slot.CFrame)
        task.wait(0.175)
        NetFire("match", "placeCarried", slot, carriedItem)
    end
end

local function GetMaxHoldAmount()
    local level = Plr:GetAttribute("CapacityLevel") or 1
    local ok, value = pcall(function()
        return GameConfig.upgradeValue("Capacity", level)
    end)
    if not ok or not value then return 1 end
    return value
end

local function Func_AutoPickup()
    local CarryClient = nil
    while true do
        CarryClient = CarryClient or GetCarryClient()
        local char = Plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and CarryClient then
            local house = GetActiveHouse()
            if house then
                local itemsFolder = house:FindFirstChild("Items")
                local slotsFolder = house:FindFirstChild("Slots")
                if itemsFolder then
                    PlaceCarried(root, CarryClient, slotsFolder, house)
                    local candidates = itemsFolder:GetChildren()
                    local maxHold = GetMaxHoldAmount()
                    for _, item in ipairs(candidates) do
                        if item:IsA("BasePart") and item.Parent and item.Anchored and item:GetAttribute("Sorted") == nil then
                            local held = #CarryClient.get()
                            if held >= maxHold then
                                PlaceCarried(root, CarryClient, slotsFolder, house)
                            end
                            TeleportTo(root, item.CFrame)
                            NetFire("match", "pickupItem", item)
                            task.wait(0.175)
                        end
                    end
                    PlaceCarried(root, CarryClient, slotsFolder, house)
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoAbility()
    while true do
        local selected = Options.AbilitySelect.Value
        for label, active in pairs(selected) do
            if active then
                local id = Tables.AbilityMap[label]
                if id and id ~= "" then
                    NetFetch("match", "useAbility", id)
                    task.wait(0.2)
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoUpgrade()
    while true do
        local selected = Options.UpgradeSelect.Value
        for label, active in pairs(selected) do
            if active then
                local id = Tables.UpgradeMap[label]
                if id then
                    NetFetch("economy", "purchaseUpgrade", id)
                    task.wait(0.2)
                end
            end
        end
        task.wait()
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoSpray", { Text = "Auto Spray", Default = false, Callback = function(val) Thread("AutoSpray", Func_AutoSpray, val) end })
TB_Tabs.Autofarm2.T1:AddSlider("SprayRange", { Text = "Spray Range", Default = 999, Min = 10, Max = 999, Rounding = 0 })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false, Callback = function(val) Thread("AutoPickup", Func_AutoPickup, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoAbility", { Text = "Auto Ability", Default = false, Callback = function(val) Thread("AutoAbility", Func_AutoAbility, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false, Callback = function(val) Thread("AutoUpgrade", Func_AutoUpgrade, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeSelect", { Text = "Select Upgrades", Values = Tables.UpgradeList, Default = {}, Multi = true })
TB_Tabs.Autofarm2.T1:AddDropdown("AbilitySelect", { Text = "Select Abilities", Values = Tables.AbilityList, Default = {}, Multi = true })
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
SaveManager:SetFolder("Yuri/Wash")
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