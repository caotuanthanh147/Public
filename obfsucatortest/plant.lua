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
    ServerRemoteEvent = (RS:FindFirstChild("RemoteEvent") and RS.RemoteEvent:FindFirstChild("ServerRemoteEvent")),
}
local Modules = {
    FrameworkLink = (function()
        local sp = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
        if not sp then return nil end
        local biz = sp:FindFirstChild("Business")
        if not biz then return nil end
        local ok, fw = pcall(require, biz:FindFirstChild("FrameworkLink"))
        return ok and fw or nil
    end)(),
    C_Data = (function()
        local sp = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
        if not sp then return nil end
        local biz = sp:FindFirstChild("Business")
        if not biz then return nil end
        local ok, cd = pcall(require, biz:FindFirstChild("C_Data"))
        return ok and cd or nil
    end)(),
    PlayConfig = (function()
        local data = RS:FindFirstChild("Data")
        if not data then return nil end
        local ok, pc = pcall(require, data:FindFirstChild("PlayConfig"))
        return ok and pc or nil
    end)(),
    BigNumber = (function()
        local fw = RS:FindFirstChild("Framework")
        if not fw then return nil end
        local x0000 = fw:FindFirstChild("X0000")
        if not x0000 then return nil end
        local ok, bn = pcall(require, x0000:FindFirstChild("BigNumber"))
        return ok and bn or nil
    end)(),
    MainBusiness = (function()
        local biz = RS:FindFirstChild("Business")
        if not biz then return nil end
        local ok, mb = pcall(require, biz:FindFirstChild("MainBusiness"))
        return ok and mb or nil
    end)(),
}
local FrameworkLink = Modules.FrameworkLink
local C_DataModule = Modules.C_Data
local PlayConfig = Modules.PlayConfig
local BigNumber = Modules.BigNumber
local MainBusiness = Modules.MainBusiness
local function GetServerData()
    if not C_DataModule then
        notyuri("[GetServerData] C_DataModule is nil (failed to require C_Data)")
        return nil
    end
    local ok, data = pcall(C_DataModule.GetData)
    if not ok or not data then
        notyuri("[GetServerData] C_DataModule.GetData() failed:", tostring(data))
        return nil
    end
    return data
end
local Flags = {}
local Shared = {}
local Tables = {
    EggList = {"Egg 1", "Egg 2", "Egg 3", "Egg 4", "Egg 5", "Egg 6", "Egg 7", "Egg 8"},
    EggMap = {},
}
for i = 1, 8 do
    Tables.EggMap[Tables.EggList[i]] = i
end
Tables.RarityNameById = {}
Tables.UnitRollLabelList = {}
Tables.UnitRollLabelToCfgId = {}
if PlayConfig then
    if PlayConfig.allRarity then
        for _, rarityCfg in ipairs(PlayConfig.allRarity) do
            Tables.RarityNameById[rarityCfg.id] = rarityCfg.name
        end
    end
    if PlayConfig.allUnit then
        for _, unitCfg in ipairs(PlayConfig.allUnit) do
            if unitCfg.index and unitCfg.index >= 1 then
                local rarityName = Tables.RarityNameById[unitCfg.rarity] or tostring(unitCfg.rarity)
                local label = unitCfg.name .. " [" .. rarityName .. "]"
                table.insert(Tables.UnitRollLabelList, label)
                Tables.UnitRollLabelToCfgId[label] = unitCfg.id
            end
        end
    end
end
Tables.UpgradeLabelList = {}
Tables.UpgradeLabelToId = {}
if PlayConfig and PlayConfig.allStatUpgrade then
    for _, statCfg in ipairs(PlayConfig.allStatUpgrade) do
        table.insert(Tables.UpgradeLabelList, statCfg.title)
        Tables.UpgradeLabelToId[statCfg.title] = statCfg.id
    end
end
local function GetFireServer()
    if FrameworkLink then return FrameworkLink.FireServer end
    if Remotes.ServerRemoteEvent then
        return setmetatable({}, {
            __index = function(self, name)
                return function(_, ...)
                    local args = {...}
                    pcall(function()
                        Remotes.ServerRemoteEvent:FireServer(tostring(name), unpack(args))
                    end)
                end
            end
        })
    end
    return nil
end
local function Fire(name, ...)
    local fs = GetFireServer()
    if not fs then
        notyuri("[Fire] GetFireServer() returned nil, cannot fire", name)
        return
    end
    if not fs[name] then
        notyuri("[Fire] fs[" .. tostring(name) .. "] does not exist, cannot fire")
        return
    end
    local args = {...}
    local ok, err = pcall(function()
        fs[name](fs, unpack(args))
    end)
    if not ok then
        notyuri("[Fire] pcall failed for", name, ":", tostring(err))
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
local function GetSelectedRollTargets()
    local unitLabels = (Options.UnitSelected and Options.UnitSelected.Value) or {}
    local cfgIds = {}
    for label, active in pairs(unitLabels) do
        if active then
            local cfgId = Tables.UnitRollLabelToCfgId[label]
            if cfgId then cfgIds[cfgId] = true end
        end
    end
    return cfgIds
end
local function GetRollSlotCfgId(cData, slotIndex)
    local pool = cData.serverData.rollUnitPool
    return pool and pool[slotIndex] or nil
end
local function UnitMatchesTargets(unitCfg, cfgIds)
    if not unitCfg then return false end
    return cfgIds[unitCfg.id] == true
end
local function WaitUntilAffordable(unitCfg)
    if not BigNumber then
        return
    end
    while Toggles.AutoRoll.Value do
        local cData = GetServerData()
        if not cData then
            return
        end
        if BigNumber.BigCompare(cData.serverData.wins, unitCfg.cost.value) then
            return
        end
        task.wait(0.5)
    end
end

local function Func_AutoRoll()
    while true do
        local cfgIds = GetSelectedRollTargets()
        if next(cfgIds) == nil then
            Fire("Business", "RNG_\xe5\x8d\x95\xe4\xbd\x8d")
            task.wait(0.2)
        else
            Fire("Business", "RNG_\xe5\x8d\x95\xe4\xbd\x8d")
            task.wait(0.2)
            local cData = GetServerData()
            if cData and PlayConfig then
                for slotIndex = 1, 3 do
                    local cfgId = GetRollSlotCfgId(cData, slotIndex)
                    local unitCfg = cfgId and cfgId > 0 and PlayConfig.allUnit[cfgId] or nil
                    if UnitMatchesTargets(unitCfg, cfgIds) then
                        WaitUntilAffordable(unitCfg)
                        local buyAttempts = 0
                        while Toggles.AutoRoll.Value and GetRollSlotCfgId(GetServerData() or cData, slotIndex) == cfgId do
                            buyAttempts = buyAttempts + 1
                            Fire("Buy_Backpack_Item", "RNG_\xe5\x8d\x95\xe4\xbd\x8d", slotIndex)
                            task.wait(0.1)
                        end
                    end
                end
            end
            task.wait()
        end
    end
end
local function Func_AutoEquip()
    while true do
        Fire("Business", "\xe8\xa3\x85\xe5\xa4\x87\xe6\x9c\x80\xe5\xa5\xbd_\xe5\x8d\x95\xe4\xbd\x8d")
        task.wait(5)
    end
end
local function GetPlacementSlots(cData)
    local sceneUnit = cData.serverData.sceneUnit
    local sceneUnitChunkUnlock = cData.serverData.sceneUnitChunkUnlock
    if not sceneUnit or not sceneUnitChunkUnlock then return nil end
    local slots = {}
    for slotIndex = 1, 14 do
        if sceneUnitChunkUnlock[slotIndex] == true then
            local gid = sceneUnit[slotIndex]
            local entry = { slot = slotIndex, occupied = (gid ~= nil and gid ~= 0) }
            if entry.occupied then
                entry.gid = gid
                local unitCard = cData.playData.allCard[gid]
                if unitCard and unitCard.typeId == 1 and MainBusiness and MainBusiness.Get_UnitDps then
                    entry.value = MainBusiness.Get_UnitDps(cData.playData.bestUnitAtk.Value, unitCard, cData.playData.AtkRep.Value, cData.playData.atkSpeedRep.Value)
                end
            end
            table.insert(slots, entry)
        end
    end
    return slots
end
local function GetSortedHandByDps(cData)
    if not MainBusiness or not MainBusiness.Get_UnitDps or not BigNumber then return nil end
    local sorted = {}
    for _, gid in ipairs(cData.serverData.hand) do
        if gid and gid > 0 then
            local unitCard = cData.playData.allCard[gid]
            if unitCard and unitCard.typeId == 1 then
                local value = MainBusiness.Get_UnitDps(cData.playData.bestUnitAtk.Value, unitCard, cData.playData.AtkRep.Value, cData.playData.atkSpeedRep.Value)
                table.insert(sorted, { gid = gid, value = value })
            end
        end
    end
    table.sort(sorted, function(a, b) return BigNumber.BigCompareNoEqual(a.value, b.value) end)
    return sorted
end
local function Func_AutoPlace()
    while true do
        local cData = GetServerData()
        if not cData or not cData.serverData or not cData.playData then
            notyuri("[AutoPlace] cData missing serverData/playData")
        else
            local slots = GetPlacementSlots(cData)
            local hand = GetSortedHandByDps(cData)
            if not slots then
                notyuri("[AutoPlace] GetPlacementSlots returned nil")
            elseif not hand then
                notyuri("[AutoPlace] GetSortedHandByDps returned nil")
            else
                notyuri("[AutoPlace] slots:", #slots, "hand:", #hand)
                local handIndex = 1
                for _, slot in ipairs(slots) do
                    local bestUnit = hand[handIndex]
                    if bestUnit then
                        if not slot.occupied then
                            local candidateInt = bestUnit.value and BigNumber and BigNumber.GetInt(bestUnit.value) or nil
                            notyuri("[AutoPlace] slot", slot.slot, "empty -> placing gid", bestUnit.gid, "dps", tostring(candidateInt))
                            Fire("BusinessToId", "\xe6\x94\xbe\xe7\xbd\xae_\xe5\x8d\x95\xe4\xbd\x8d", slot.slot)
                            handIndex = handIndex + 1
                        elseif slot.occupied then
                            local placedInt = slot.value and BigNumber and BigNumber.GetInt(slot.value) or nil
                            local candidateInt = bestUnit.value and BigNumber and BigNumber.GetInt(bestUnit.value) or nil
                            notyuri("[AutoPlace] slot", slot.slot, "compare -> placed gid", tostring(slot.gid), "dps", tostring(placedInt), "| candidate gid", bestUnit.gid, "dps", tostring(candidateInt))
                            if slot.value ~= nil and BigNumber and BigNumber.BigCompareNoEqual(bestUnit.value, slot.value) then
                                notyuri("[AutoPlace] slot", slot.slot, "-> replacing, candidate dps higher")
                                Fire("BusinessToId", "\xe6\x94\xbe\xe7\xbd\xae_\xe5\x8d\x95\xe4\xbd\x8d", slot.slot)
                                handIndex = handIndex + 1
                            else
                                notyuri("[AutoPlace] slot", slot.slot, "-> skipping, candidate not higher")
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoMerge()
    while true do
        Fire("Business", "\xe5\x90\x88\xe6\x88\x90\xe5\x8d\x95\xe4\xbd\x8d_\xe6\x98\x9f\xe6\x98\x9f\xe7\xad\x89\xe7\xba\xa7")
        task.wait(2)
    end
end
local function Func_AutoRebirth()
    while true do
        Fire("Business", "\xe9\x87\x8d\xe7\x94\x9f")
        task.wait(2)
    end
end
local function Func_AutoUpgrade()
    while true do
        local statIds = {}
        local selected = (Options.UpgradeSelected and Options.UpgradeSelected.Value) or {}
        for label, active in pairs(selected) do
            if active then
                local statId = Tables.UpgradeLabelToId[label]
                if statId then table.insert(statIds, statId) end
            end
        end
        for _, statId in ipairs(statIds) do
            Fire("Buy_Backpack_Item", "\xe4\xba\xba\xe7\x89\xa9\xe5\xb1\x9e\xe6\x80\xa7\xe5\x8d\x87\xe7\xba\xa7", statId)
            task.wait(0.3)
        end
        task.wait(1)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", {
    Text = "Auto Roll",
    Default = false,
    Callback = function(val)
        Thread("AutoRoll", Func_AutoRoll, val)
    end
})
TB_Tabs.Autofarm2.T1:AddDropdown("UnitSelected", {
    Values = Tables.UnitRollLabelList,
    Default = {},
    Multi = true,
    Searchable = true,
    Text = "Units Selected",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", {
    Text = "Auto Upgrade",
    Default = false,
    Callback = function(val)
        Thread("AutoUpgrade", Func_AutoUpgrade, val)
    end
})
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeSelected", {
    Values = Tables.UpgradeLabelList,
    Default = {},
    Multi = true,
    Searchable = true,
    Text = "Upgrades List",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", {
    Text = "Auto Equip",
    Default = false,
    Callback = function(val)
        Thread("AutoEquip", Func_AutoEquip, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", {
    Text = "Auto Place",
    Default = false,
    Callback = function(val)
        Thread("AutoPlace", Func_AutoPlace, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoMerge", {
    Text = "Auto Merge",
    Default = false,
    Callback = function(val)
        Thread("AutoMerge", Func_AutoMerge, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", {
    Text = "Auto Rebirth",
    Default = false,
    Callback = function(val)
        Thread("AutoRebirth", Func_AutoRebirth, val)
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
SaveManager:SetFolder("Yuri/MutantPlants")
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