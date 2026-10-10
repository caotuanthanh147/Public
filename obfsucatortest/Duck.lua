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
local CollectionService = Services.CollectionService
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
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Shared = {
}
local Tables = {
    DogList = {"Dogs_Jeff", "Dogs_Duckle", "Dogs_Teddy", "Dogs_Cookie", "Dogs_Rex", "Dogs_Ace", "Dogs_Chief", "Dogs_Winston"},
    DogMap = {Dogs_Jeff = "Dogs_Jeff", Dogs_Duckle = "Dogs_Duckle", Dogs_Teddy = "Dogs_Teddy", Dogs_Cookie = "Dogs_Cookie", Dogs_Rex = "Dogs_Rex", Dogs_Ace = "Dogs_Ace", Dogs_Chief = "Dogs_Chief", Dogs_Winston = "Dogs_Winston"},
    WeaponList = {"Basic_Rifle", "Hunting_Rifle", "Shotgun", "Military_Shotgun", "M4", "SCAR_H", "Minigun", "Plasma_Rifle"},
    WeaponMap = {Basic_Rifle = "Basic_Rifle", Hunting_Rifle = "Hunting_Rifle", Shotgun = "Shotgun", Military_Shotgun = "Military_Shotgun", M4 = "M4", SCAR_H = "SCAR_H", Minigun = "Minigun", Plasma_Rifle = "Plasma_Rifle"},
}
local function GetFramework()
    local up = RS:FindFirstChild("UmePointer")
    if not up or not up.Value then return nil end
    local ok, fw = pcall(require, up.Value)
    return ok and fw or nil
end
local function NetInvoke(name, ...)
    local fw = GetFramework()
    if not fw or not fw.Network then return nil end
    local args = {...}
    local result = nil
    pcall(function()
        result = fw.Network.Invoke(name, unpack(args))
    end)
    return result
end
local function NetFire(name, ...)
    local fw = GetFramework()
    if not fw or not fw.Network then return end
    local args = {...}
    pcall(function()
        fw.Network.Fire(name, unpack(args))
    end)
end
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
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
local ConfirmedDefeated = {}
local function GetTargetKey(model)
    local name = model.Name or ""
    local prefix, id = name:match("^(DuckController_Client_)(%d+)$")
    if prefix then return "Duck:"..id end
    prefix, id = name:match("^(BossController_Client_)(%d+)$")
    if prefix then return "Boss:"..id end
    return nil
end
do
    local fw = GetFramework()
    notyuri("[AutoShoot] GetFramework() -> "..tostring(fw))
    if fw and fw.Network and fw.Network.Fired then
        notyuri("[AutoShoot] Hooking WeaponController_HitConfirm via fw.Network.Fired")
        local hookOk, hookErr = pcall(function()
            fw.Network.Fired("WeaponController_HitConfirm", function(hitType, hitId, defeated)
                notyuri("[AutoShoot] HitConfirm received type="..tostring(hitType)..", id="..tostring(hitId)..", defeated="..tostring(defeated))
                if defeated == true and (hitType == "Duck" or hitType == "Boss") then
                    ConfirmedDefeated[hitType..":"..tostring(hitId)] = true
                    notyuri("[AutoShoot] Marked "..hitType..":"..tostring(hitId).." as defeated")
                end
            end)
        end)
        if not hookOk then
            notyuri("[AutoShoot] Failed to hook HitConfirm: "..tostring(hookErr))
        end
    else
        notyuri("[AutoShoot] fw.Network.Fired unavailable, HitConfirm hook skipped")
    end
end
local function IsTargetDead(model)
    local key = GetTargetKey(model)
    if key and ConfirmedDefeated[key] then
        return true
    end
    return false
end
local function FindNearestTarget()
    local ume = workspace:FindFirstChild("Ume")
    if not ume then
        notyuri("[AutoShoot] workspace.Ume not found")
        return nil
    end
    local char = Plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        notyuri("[AutoShoot] No HumanoidRootPart, cannot find target")
        return nil
    end
    local closest = nil
    local closestDist = math.huge
    local scanned = 0
    local matched = 0
    local skippedDead = 0
    local noHitbox = 0
    for _, model in ipairs(ume:GetChildren()) do
        if model:IsA("Model") then
            local name = model.Name or ""
            if name:match("^DuckController_Client_") or name:match("^BossController_Client_") then
                matched = matched + 1
                if not IsTargetDead(model) then
                    local hitbox = model:FindFirstChild("Hitbox", true)
                    if hitbox and hitbox:IsA("BasePart") then
                        local dist = (root.Position - hitbox.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = hitbox
                        end
                    else
                        noHitbox = noHitbox + 1
                    end
                else
                    skippedDead = skippedDead + 1
                end
            end
        end
        scanned = scanned + 1
    end
    notyuri("[AutoShoot] FindNearestTarget: scanned="..scanned..", matchedNamePattern="..matched..", skippedDead="..skippedDead..", noHitbox="..noHitbox..", found="..tostring(closest ~= nil))
    return closest
end
local function Func_AutoShoot()
    local shootId = 0
    local reloadId = 0
    notyuri("[AutoShoot] Func_AutoShoot started")
    while true do
        local target = FindNearestTarget()
        local cam = workspace.CurrentCamera
        if target and cam then
            local origin = cam.CFrame.Position
            local direction = (target.Position - origin).Unit
            local state = NetInvoke("WeaponController_GetState")
            notyuri("[AutoShoot] WeaponController_GetState result: "..tostring(state)..(state and (", Ammo="..tostring(state.Ammo)) or ""))
            if not state then
                notyuri("[AutoShoot] No state returned, skipping shot")
                task.wait()
            elseif state.Ammo and state.Ammo > 0 then
                shootId = shootId + 1
                notyuri("[AutoShoot] Firing WeaponController_Shoot shootId="..shootId)
                NetFire("WeaponController_Shoot", origin, direction, shootId, workspace:GetServerTimeNow())
                task.wait()
            elseif state.Ammo and state.Ammo <= 0 then
                reloadId = reloadId + 1
                notyuri("[AutoShoot] Reloading, reloadId="..reloadId)
                NetFire("WeaponController_Reload", reloadId)
                task.wait(2)
            else
                notyuri("[AutoShoot] state.Ammo missing/unexpected: "..tostring(state and state.Ammo))
                task.wait()
            end
        else
            notyuri("[AutoShoot] No target/cam this tick: target="..tostring(target ~= nil)..", cam="..tostring(cam ~= nil))
            task.wait()
        end
    end
end
local function FindLandedDucks()
    local ume = workspace:FindFirstChild("Ume")
    if not ume then return {} end
    local folder = ume:FindFirstChild("DuckController_LandedDucks")
    if not folder then return {} end
    local ducks = {}
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("Ducks_LandedDuck") == true then
            table.insert(ducks, model)
        end
    end
    return ducks
end
local function GetOwnFreezerInteractPart()
    local ume = workspace:FindFirstChild("Ume")
    local freezers = ume and ume:FindFirstChild("DuckController_Freezers")
    if not freezers then
        notyuri("[AutoPickup] DuckController_Freezers folder not found")
        return nil
    end
    for _, freezer in ipairs(freezers:GetChildren()) do
        if freezer:IsA("Model") and freezer:GetAttribute("DuckController_FreezerOwnerUserId") == Plr.UserId then
            local interactPart = freezer:FindFirstChild("InteractPart", true)
            if interactPart and interactPart:IsA("BasePart") and interactPart:GetAttribute("Freezer_InteractPart") == true then
                return interactPart
            end
            notyuri("[AutoPickup] Own freezer found but InteractPart missing/invalid")
            return nil
        end
    end
    notyuri("[AutoPickup] Own freezer not found for UserId="..tostring(Plr.UserId))
    return nil
end
local function GetHeldDuckId()
    local state = NetInvoke("DuckController_GetInteractionState")
    return state and type(state.HeldDuckId) == "string" and state.HeldDuckId or nil
end
local function DepositHeldDuck(char, root)
    local interactPart = GetOwnFreezerInteractPart()
    if interactPart then
        char = Plr.Character
        root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            notyuri("[AutoPickup] Teleporting to freezer "..interactPart:GetFullName())
            root.CFrame = CFrame.new(interactPart.Position + Vector3.new(0, 3, 0))
            task.wait(0.2)
            local depositResult = NetInvoke("DuckController_Deposit", interactPart)
            notyuri("[AutoPickup] DuckController_Deposit result: "..tostring(depositResult))
            task.wait(0.2)
        end
    end
end
local PickupFailCounts = setmetatable({}, {__mode = "k"})
local PICKUP_FAIL_LIMIT = 3
local function Func_AutoPickup()
    while true do
        local char = Plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local alreadyHeldDuckId = GetHeldDuckId()
            if alreadyHeldDuckId then
                notyuri("[AutoPickup] Already holding duck "..alreadyHeldDuckId..", depositing before pickup")
                DepositHeldDuck(char, root)
            end
            for _, model in ipairs(FindLandedDucks()) do
                local failCount = PickupFailCounts[model] or 0
                if failCount >= PICKUP_FAIL_LIMIT then
                    notyuri("[AutoPickup] Skipping blacklisted duck "..model:GetFullName().." (failed "..failCount.." times)")
                else
                    local rootPart = model.PrimaryPart or model:FindFirstChild("RootPart", true)
                    if rootPart then
                        notyuri("[AutoPickup] Teleporting to duck "..model:GetFullName())
                        root.CFrame = CFrame.new(rootPart.Position)
                        task.wait(0.2)
                        local pickupResult = NetInvoke("DuckController_Pickup", model)
                        notyuri("[AutoPickup] DuckController_Pickup result: "..tostring(pickupResult))
                        local heldDuckId = GetHeldDuckId()
                        if not heldDuckId then
                            PickupFailCounts[model] = failCount + 1
                            notyuri("[AutoPickup] No HeldDuckId after pickup, skipping deposit (fail count "..PickupFailCounts[model].." for "..model:GetFullName()..")")
                            if PickupFailCounts[model] >= PICKUP_FAIL_LIMIT then
                                notyuri("[AutoPickup] Blacklisting duck "..model:GetFullName().." after "..PickupFailCounts[model].." failed attempts")
                            end
                        else
                            notyuri("[AutoPickup] Holding duck "..heldDuckId)
                            PickupFailCounts[model] = nil
                            DepositHeldDuck(char, root)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local function GetEquippedDogUUID()
    local dogsState = NetInvoke("Dogs_GetState")
    local equipped = dogsState and dogsState.Equipped and dogsState.Equipped[1]
    return equipped and equipped.UUID or nil
end
local function GetUpgradeState(dogUUID)
    return NetInvoke("Upgrades_GetState", dogUUID)
end
local function GetUpgradeEntry(state, arg1)
    if not state then return nil end
    if arg1 == "SpawnRate" then
        return state.Duck
    end
    if arg1 == "Luck" then
        return state.Duck and state.Duck.Luck
    end
    if state.Dog and state.Dog.Stats and state.Dog.Stats[arg1] then
        return state.Dog.Stats[arg1]
    end
    return state.Weapon and state.Weapon.Stats and state.Weapon.Stats[arg1]
end
local function Func_AutoUpgrade()
    while true do
        local dogUUID = GetEquippedDogUUID()
        local state = GetUpgradeState(dogUUID)
        if not state then
            notyuri("[AutoUpgrade] Upgrades_GetState returned nil")
            task.wait(1)
        else
            local purchasedAny = false
            for _, btn in ipairs(CollectionService:GetTagged("Interact_Button")) do
                local moduleName = btn:GetAttribute("Interact_ModuleName")
                local fnName = btn:GetAttribute("Interact_Function")
                local arg1 = btn:GetAttribute("Interact_Arg1")
                if moduleName == "Upgrades" and arg1 and (fnName == "PurchaseDuckUpgrade" or fnName == "PurchaseWeaponUpgrade" or fnName == "PurchaseDogUpgrade") then
                    local entry = GetUpgradeEntry(state, arg1)
                    if entry and entry.Next ~= nil and entry.Price ~= nil then
                        local fw = GetFramework()
                        local affordable = fw and fw.Currency and fw.Currency.HasEnough("Cash", tostring(entry.Price))
                        if affordable then
                            notyuri("[AutoUpgrade] Purchasing "..fnName.." arg1="..tostring(arg1).." price="..tostring(entry.Price))
                            local result
                            if fnName == "PurchaseWeaponUpgrade" then
                                result = NetInvoke("Upgrades_Purchase", "Weapon", arg1)
                            elseif fnName == "PurchaseDogUpgrade" then
                                result = NetInvoke("Upgrades_Purchase", "Dog", arg1, dogUUID)
                            else
                                result = NetInvoke("Upgrades_Purchase", "Duck", arg1)
                            end
                            notyuri("[AutoUpgrade] Purchase result: "..tostring(result))
                            purchasedAny = true
                            task.wait(0.3)
                        end
                    end
                end
            end
            task.wait(purchasedAny and 0.5 or 2)
        end
    end
end
local function Func_AutoSell()
    while true do
        local state = NetInvoke("DuckController_GetInteractionState")
        local storageCount = state and tonumber(state.StorageCount) or 0
        if storageCount > 0 then
            notyuri("[AutoSell] Selling ducks, StorageCount="..tostring(storageCount))
            local result = NetInvoke("DuckController_Sell")
            notyuri("[AutoSell] DuckController_Sell result: "..tostring(result))
        end
        task.wait(1)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoShoot", {
    Text = "Auto Shoot",
    Default = false,
    Callback = function(val)
        Thread("AutoShoot", Func_AutoShoot, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", {
    Text = "Auto Pickup",
    Default = false,
    Callback = function(val)
        Thread("AutoPickup", Func_AutoPickup, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", {
    Text = "Auto Upgrade",
    Default = false,
    Callback = function(val)
        Thread("AutoUpgrade", Func_AutoUpgrade, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", {
    Text = "Auto Sell",
    Default = false,
    Callback = function(val)
        Thread("AutoSell", Func_AutoSell, val)
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
SaveManager:SetFolder("Yuri/Duck")
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