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
local AreaEggResetTimeUtil = require(RS.Library.Util.AreaEggResetTimeUtil)
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
    Network = (function()
        local ok, net = pcall(require, RS:FindFirstChild("Library") and RS.Library:FindFirstChild("Client") and RS.Library.Client:FindFirstChild("Network"))
        return ok and net or nil
    end)(),
    Constants = GetSafeModule(RS:FindFirstChild("Library") and RS.Library:FindFirstChild("Globals"), "Constants"),
    Save = (function()
        local ok, save = pcall(require, RS:FindFirstChild("Library") and RS.Library:FindFirstChild("Client") and RS.Library.Client:FindFirstChild("Save"))
        return ok and save or nil
    end)(),
    AssetDirectory = (function()
        local ok, mod = pcall(require, RS:FindFirstChild("Directory") and RS.Directory:FindFirstChild("Assets"))
        return ok and mod and mod.Directory or nil
    end)(),
    PlotCmds = (function()
        local ok, mod = pcall(require, RS:FindFirstChild("Library") and RS.Library:FindFirstChild("Client") and RS.Library.Client:FindFirstChild("PlotCmds"))
        return ok and mod or nil
    end)(),
}
local Network = Modules.Network
local Constants = Modules.Constants
local Save = Modules.Save
local AssetDirectory = Modules.AssetDirectory
local PlotCmds = Modules.PlotCmds
local Flags = {}
local Shared = {}
local Tables = {
}
local function NetInvoke(name, ...)
    if not Network then return nil end
    local args = {...}
    local result, message = nil, nil
    pcall(function()
        result, message = Network.Invoke(name, unpack(args))
    end)
    return result, message
end
local function NetFire(name, ...)
    if not Network then return end
    local args = {...}
    pcall(function()
        Network.Fire(name, unpack(args))
    end)
end
local function GetPlacedEggRenderFolder()
    local best = nil
    local bestCount = -1
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "PlacedEggRenders" then
            local count = #obj:GetChildren()
            if count > bestCount then
                bestCount = count
                best = obj
            end
        end
    end
    return best
end
local function GetEggUIDs()
    local uids = {}
    local folder = GetPlacedEggRenderFolder()
    if not folder then return uids end
    local ownerPrefix = tostring(Plr.UserId) .. "_"
    for _, model in ipairs(folder:GetChildren()) do
        local name = model.Name
        if name:sub(1, #ownerPrefix) == ownerPrefix then
            local uid = name:sub(#ownerPrefix + 1)
            if uid ~= "" then
                table.insert(uids, uid)
            end
        end
    end
    return uids
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
local NET_MAP = Constants and Constants.NETWORK_MAP or nil
local function Func_AutoHatch()
    while true do
        local uids = GetEggUIDs()
        for _, uid in ipairs(uids) do
            local result = NetInvoke(NET_MAP.Eggs.REQUEST_HATCH_EGG, uid)
            if result then
                task.wait(0.1)
                NetInvoke(NET_MAP.Eggs.REQUEST_COMPLETE_HATCH_EGG, uid)
            end
            task.wait(0.2)
        end
        task.wait(1)
    end
end
local function Func_AutoEquip()
    while true do
        NetInvoke(NET_MAP.Backpack.EQUIP_BEST)
        task.wait(5)
    end
end
local function Func_AutoRebirth()
    while true do
        NetFire(NET_MAP.Rebirth.REQUEST_REBIRTH)
        task.wait(2)
        NetInvoke(NET_MAP.Rebirth.REQUEST_REBIRTH_COMMIT)
        task.wait(2)
    end
end
local function Func_AutoBase()
    while true do
        NetFire(NET_MAP.Plots.REQUEST_BASE_UPGRADE)
        task.wait(2)
    end
end
local EggCmds = (function()
    local ok, mod = pcall(require, RS:FindFirstChild("Library") and RS.Library:FindFirstChild("Client") and RS.Library.Client:FindFirstChild("EggCmds"))
    return ok and mod or nil
end)()
local IsCarryingEgg = false
if EggCmds then
    EggCmds.AreaEggCarryStateChanged:Connect(function(state)
        IsCarryingEgg = state and state.IsCarrying or false
    end)
end
local function GetSafeZoneTarget()
    return Vector3.new(531, 71, -363)
end
local function TeleportCharacterTo(targetPos)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(targetPos, targetPos + hrp.CFrame.LookVector)
end
local TELEPORT_STEP_DIST = 10
local TELEPORT_ARRIVE_DIST = 3
local WALL_CHECK_MARGIN = 1.5
local WALL_CHECK_EXCLUDE_PATHS = {
    workspace:FindFirstChild("Plots"),
    workspace:FindFirstChild("__DEBRIS"),
    workspace:FindFirstChild("__ClientTreadmillRenders"),
    workspace:FindFirstChild("Stands"),
}
local WALL_CHECK_MAX_ITERATIONS = 10
local function GetClampedStepPos(hrp, char, stepPos)
    local origin = hrp.Position
    local dir = stepPos - origin
    local dist = dir.Magnitude
    if dist <= 0 then return stepPos end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filterList = {char}
    for _, inst in ipairs(WALL_CHECK_EXCLUDE_PATHS) do
        if inst then
            table.insert(filterList, inst)
        end
    end
    params.FilterDescendantsInstances = filterList
    for _ = 1, WALL_CHECK_MAX_ITERATIONS do
        local result = workspace:Raycast(origin, dir, params)
        if not result then
            return stepPos
        end
        if result.Instance.Name == "Part" then
            local safeDist = math.max(result.Distance - WALL_CHECK_MARGIN, 0)
            return origin + dir.Unit * safeDist
        end
        table.insert(filterList, result.Instance)
        params.FilterDescendantsInstances = filterList
    end
    return stepPos
end
local function MoveTo(targetPos)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local delta = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z) - hrp.Position
    local dist = delta.Magnitude
    if dist <= TELEPORT_ARRIVE_DIST then
        if not hrp.Anchored then hrp.Anchored = true end
        return false
    end
    local stepDist = math.min(TELEPORT_STEP_DIST, dist)
    local stepPos = hrp.Position + delta.Unit * stepDist
    local clampedPos = GetClampedStepPos(hrp, char, stepPos)
    local blocked = (clampedPos - stepPos).Magnitude > 0.01
    if hrp.Anchored then hrp.Anchored = false end
    TeleportCharacterTo(clampedPos)
    return blocked
end
local function GetUnplacedEggUids()
    local uids = {}
    if not Save or not Save.Get then
        return uids
    end
    local ok, data = pcall(Save.Get)
    if not ok then
        return uids
    end
    if not data then
        return uids
    end
    if not data.EggInventory then
        return uids
    end
    for uid, record in pairs(data.EggInventory) do
        if type(record) == "table" and record.Placement == nil then
            table.insert(uids, uid)
        end
    end
    return uids
end
local function Func_AutoPlaceEgg()
    local SPACING = 9
    while true do
        local uids = GetUnplacedEggUids()
        local gridIndex = 0
        for _, uid in ipairs(uids) do
            local plotData = PlotCmds and PlotCmds.GetPlotData and PlotCmds.GetPlotData()
            if plotData and plotData.CenterPoint and plotData.PetArea then
                local col = gridIndex % 3
                local row = math.floor(gridIndex / 3)
                gridIndex = gridIndex + 1
                local centerCFrame = plotData.CenterPoint.CFrame
                local offsetLocal = Vector3.new(col * SPACING, 0, row * SPACING)
                local worldPos = (centerCFrame * CFrame.new(offsetLocal)).Position
                TeleportCharacterTo(worldPos + Vector3.new(0, 7, 0))
                local localCFrame = centerCFrame:ToObjectSpace(CFrame.new(worldPos))
                NetInvoke(NET_MAP.Eggs.REQUEST_PLACE_EGG, {
                    Uid = uid,
                    LocalCFrame = localCFrame
                })
            end
            task.wait(0.2)
        end
        task.wait(1)
    end
end
local function BuildRarityDropdownValues()
    local seen = {}
    local entries = {}
    if AssetDirectory then
        for _, config in pairs(AssetDirectory) do
            local rarity = config.Rarity
            if rarity and rarity.DisplayName and not seen[rarity.DisplayName] then
                seen[rarity.DisplayName] = true
                table.insert(entries, {Name = rarity.DisplayName, Number = rarity.RarityNumber or 0})
            end
        end
    end
    table.sort(entries, function(a, b)
        return a.Number > b.Number
    end)
    local values = {}
    for _, entry in ipairs(entries) do
        table.insert(values, entry.Name)
    end
    return values
end
local RarityDropdownValues = BuildRarityDropdownValues()
local SelectedStealRarities = {}
local function GetAreaEggRecords()
    if not EggCmds then return {} end
    local ok, snapshot = pcall(EggCmds.GetAreaEggSnapshot)
    if not ok or type(snapshot) ~= "table" or type(snapshot.Records) ~= "table" then
        return {}
    end
    return snapshot.Records
end
local function GetRarityDisplayNameForCategory(category)
    if not AssetDirectory or type(category) ~= "string" then return nil end
    local config = AssetDirectory[category]
    if not config or not config.Rarity then return nil end
    return config.Rarity.DisplayName
end
local function GetAreaEggModel(uid)
    local folder = workspace:FindFirstChild("AreaEggSlotsClient")
    if not folder then return nil end
    return folder:FindFirstChild(uid)
end
local function FindCarryPromptForModel(model)
    local pivotPos = model:GetPivot().Position
    local best, bestDist = nil, nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Name == "CarryAreaEgg" then
            local part = obj.Parent
            if part and part:IsA("BasePart") then
                local dist = (part.Position - pivotPos).Magnitude
                if not bestDist or dist < bestDist then
                    bestDist = dist
                    best = obj
                end
            end
        end
    end
    return best, bestDist
end
local function FindStealTarget(selectedRarities)
    local records = GetAreaEggRecords()
    for _, rarityName in ipairs(RarityDropdownValues) do
        if selectedRarities[rarityName] then
            for _, record in ipairs(records) do
                if type(record) == "table" and record.Uid then
                    local recordRarity = GetRarityDisplayNameForCategory(record.AssetCategory)
                    if recordRarity == rarityName then
                        local model = GetAreaEggModel(record.Uid)
                        if model then
                            return record, model
                        end
                    end
                end
            end
        end
    end
    return nil, nil
end
local function DeliverCarriedEgg()
    while IsCarryingEgg and Toggles.AutoStealEgg and Toggles.AutoStealEgg.Value do
        local safeTarget = GetSafeZoneTarget()
        if not safeTarget then break end
        local curChar = GetCharacter()
        local curHrp = curChar and curChar:FindFirstChild("HumanoidRootPart")
        if not curHrp then break end
        local dist = (curHrp.Position - safeTarget).Magnitude
        if dist <= 2 then break end
        MoveTo(safeTarget)
        RunService.Heartbeat:Wait()
    end
    repeat task.wait(0.1) until not IsCarryingEgg or not (Toggles.AutoStealEgg and Toggles.AutoStealEgg.Value)
end
local function MoveToSafeZone()
    local safeTarget = GetSafeZoneTarget()
    local sChar = GetCharacter()
    local sHrp = sChar and sChar:FindFirstChild("HumanoidRootPart")
    while sHrp and (Vector3.new(safeTarget.X, sHrp.Position.Y, safeTarget.Z) - sHrp.Position).Magnitude > TELEPORT_ARRIVE_DIST and Toggles.AutoStealEgg and Toggles.AutoStealEgg.Value do
        MoveTo(safeTarget)
        RunService.Heartbeat:Wait()
        sChar = GetCharacter()
        sHrp = sChar and sChar:FindFirstChild("HumanoidRootPart")
    end
end
local function Func_AutoStealEgg()
    MoveToSafeZone()
    while Toggles.AutoStealEgg and Toggles.AutoStealEgg.Value do
        if AreaEggResetTimeUtil.IsNight(workspace:GetServerTimeNow()) then
            task.wait(0.5)
        elseif IsCarryingEgg then
            DeliverCarriedEgg()
        else
            if not next(SelectedStealRarities) then
                MoveToSafeZone()
                task.wait(0.5)
            else
                local record, model = FindStealTarget(SelectedStealRarities)
                if not record or not model then
                    MoveToSafeZone()
                    task.wait(0.5)
                else
                    local prompt, promptDist = FindCarryPromptForModel(model)
                    if not prompt or not promptDist or promptDist > 25 then
                        MoveToSafeZone()
                        task.wait(0.5)
                    else
                        local promptPos = prompt.Parent.Position
                        local pChar = GetCharacter()
                        local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
                        while pHrp and (Vector3.new(promptPos.X, pHrp.Position.Y, promptPos.Z) - pHrp.Position).Magnitude > TELEPORT_ARRIVE_DIST and Toggles.AutoStealEgg and Toggles.AutoStealEgg.Value do
                            local blocked = MoveTo(promptPos)
                            if blocked then
                                MoveToSafeZone()
                            end
                            RunService.Heartbeat:Wait()
                            pChar = GetCharacter()
                            pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
                        end
                        if prompt.Parent and prompt.Enabled then
                            fireproximityprompt(prompt)
                        end
                        local waited = 0
                        while not IsCarryingEgg and waited < 0.5 and Toggles.AutoStealEgg and Toggles.AutoStealEgg.Value do
                            task.wait(0.1)
                            waited = waited + 0.1
                        end
                        if IsCarryingEgg then
                            DeliverCarriedEgg()
                        end
                    end
                end
            end
        end
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoHatch", {
    Text = "Auto Hatch Eggs",
    Default = false,
    Callback = function(val)
        Thread("AutoHatch", Func_AutoHatch, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPlaceEgg", {
    Text = "Auto Place Eggs",
    Default = false,
    Callback = function(val)
        Thread("AutoPlaceEgg", Func_AutoPlaceEgg, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", {
    Text = "Auto Equip",
    Default = false,
    Callback = function(val)
        Thread("AutoEquip", Func_AutoEquip, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", {
    Text = "Auto Rebirth",
    Default = false,
    Callback = function(val)
        Thread("AutoRebirth", Func_AutoRebirth, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBase", {
    Text = "Auto Base",
    Default = false,
    Callback = function(val)
        Thread("AutoBase", Func_AutoBase, val)
    end
})
TB_Tabs.Autofarm2.T1:AddDropdown("StealRarity", {
    Text = "Steal Rarity",
    Values = RarityDropdownValues,
    Default = {},
    Multi = true,
})
Options.StealRarity:OnChanged(function()
    SelectedStealRarities = {}
    for name, active in pairs(Options.StealRarity.Value) do
        if active then
            SelectedStealRarities[name] = true
        end
    end
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoStealEgg", {
    Text = "Auto Steal Egg",
    Default = false,
    Callback = function(val)
        Thread("AutoStealEgg", Func_AutoStealEgg, val)
    end
})
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
SaveManager:SetFolder("Yuri/SAE")
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