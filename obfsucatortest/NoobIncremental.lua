if getgenv().ayasemiyatongekissazumirisa then
    warn("yuri")
    return
end
repeat task.wait() until game:IsLoaded()
print("a")
function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end
print("c")
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
local function yuri()
end
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local isLimitedExecutor = executorDisplayName:lower():find("xeno") ~= nil
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
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
            local inviteCode = "uuza7nsPq"
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
            Autofarm2 = Tabs.Main:AddRightTabbox(),
        },
    },
}
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
print("b")
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
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local CollectionService = Services.CollectionService
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
Library.ToggleKeybind = Options.MenuKeybind
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
    local seconds = os.time() - Script_Start_Time
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    return string.format("%dh %02dm", hours, mins)
end
local function GetSafeModule(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local function GetRemote(parent, pathString)
    local current = parent
    for _, name in ipairs(pathString:split(".")) do
        if not current then return nil end
        current = current:FindFirstChild(name)
    end
    return current
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
local _FS = (_DR and _DR.FireServer)
local Remotes = {
}
local Modules = {
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
local Flags = {}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
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
local function gsc(guiObject)
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
    if not fireclickdetector then return end
    if not target or not target:IsA("ClickDetector") then return end
    fireclickdetector(target)
end
local function FirePP(target, teleport)
    if not fireproximityprompt then return end
    if not target or not target:IsA("ProximityPrompt") then return end
    local prevDist = target.MaxActivationDistance
    target.MaxActivationDistance = math.huge
    if teleport then
        local hrp = Char and Char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        if hrp and part and part:IsA("BasePart") then
            hrp.CFrame = part.CFrame * CFrame.new(0, 0, -3)
            task.wait()
        end
    end
    fireproximityprompt(target)
    task.delay(0.5, function()
        if target and target.Parent then
            target.MaxActivationDistance = prevDist
        end
    end)
end
local function FireTI(target)
    if not firetouchinterest then return end
    local root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local part
    if target:IsA("BasePart") then
        part = target
    else
        part = target:FindFirstAncestorWhichIsA("BasePart")
    end
    if not part then return end
    part.CFrame = root.CFrame
    task.spawn(function()
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end)
end
local TB_Tabs = {
    Autofarm = {
        T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
        T2 = TB.Main.Left.Autofarm:AddTab("Rebirth"),
        T3 = TB.Main.Left.Autofarm:AddTab("Misc"),
        T4 = TB.Main.Left.Autofarm:AddTab("Config"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm2:AddTab("Autofarm2"),
        T2 = TB.Main.Right.Autofarm2:AddTab("Delay"),
    },
}
local config = {
    AutoNoob           = 2,
    AutoUpgrade        = 2,
    AutoSkillTree      = 2,
    AutoRebirth        = 2,
    AutoExchMinerals   = 2,
    AutoExchAnimals    = 2,
    AutoDepositWheat   = 2,
    AutoDepositOil     = 2,
    AutoBuyFactory     = 2,
    AutoMergeFactory   = 2,
    AutoBuyAnimals     = 2,
    AutoUpgradeAnimals = 2,
    AutoCooking        = 2,
    AutoOpenCapsule    = 2,
    AutoExpedition     = 2,
}
local DelayTab = TB_Tabs.Autofarm2.T2
DelayTab:AddInput("Delay_AutoNoob",           { Text = "Auto Noob Delay",            Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoUpgrade",        { Text = "Auto Upgrade Delay",          Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoSkillTree",      { Text = "Auto Skill Tree Delay",       Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoRebirth",        { Text = "Auto Rebirth/Prestige/etc",   Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoExchMinerals",   { Text = "Exchange Minerals Delay",     Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoExchAnimals",    { Text = "Exchange Animals Delay",      Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoDepositWheat",   { Text = "Deposit Wheat Delay",         Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoDepositOil",     { Text = "Deposit Oil Delay",           Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoBuyFactory",     { Text = "Buy Factory Delay",           Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoMergeFactory",   { Text = "Merge Factory Delay",         Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoBuyAnimals",     { Text = "Buy Animals Delay",           Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoUpgradeAnimals", { Text = "Upgrade Animals Delay",       Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoCooking",        { Text = "Auto Cooking Delay",          Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoOpenCapsule",    { Text = "Open Capsule Delay",          Default = "2", Numeric = true, Finished = false })
DelayTab:AddInput("Delay_AutoExpedition",     { Text = "Auto Expedition Delay",       Default = "2", Numeric = true, Finished = false })
local function getDelay(key)
    local opt = Options["Delay_" .. key]
    if opt then return tonumber(opt.Value) or config[key] end
    return config[key]
end
for key in pairs(config) do
    local k = key
    local opt = Options["Delay_" .. k]
    if opt then
        opt:OnChanged(function()
            config[k] = tonumber(opt.Value) or config[k]
        end)
    end
end
local GB = {
    Player = {
        Left = {
            General = Tabs.Player:AddLeftGroupbox("General"),
            Server = Tabs.Player:AddLeftGroupbox("Server"),
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
GB.Player.Left.General:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", { Text = "Anti AFK", Default = true, Disabled = not Support.Connections })
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
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
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
local BigNum = require(game:GetService("ReplicatedStorage").Shared.Librairies.NumbersLibs.BigNum)
local Shared = {
    Farm = false,
}
Remotes.Net        = RS:WaitForChild("__Net")
Remotes.MainRemote = Remotes.Net:WaitForChild("MainRemote")
Remotes.GetPData   = Remotes.Net:WaitForChild("GetPlayerData")
local function Fire(action, ...)
    Remotes.MainRemote:FireServer(action, ...)
end
local Mods = RS.Shared.Modules
local Feats = Mods.FEATURES
local Mine = Feats:FindFirstChild("_MINE")
local Modules = {
    Noobs = GetSafeModule(Mods, "Noobs"),
    Upgrades = GetSafeModule(Mods, "Upgrades"),
    Factories = GetSafeModule(Mods, "Factories"),
    Expeditions = GetSafeModule(Mods, "Expeditions"),
    Animals = GetSafeModule(Mods, "Animals"),
    Cooking = GetSafeModule(Mods, "Cooking"),
    CoinMilestones = GetSafeModule(Mods, "CoinMilestones"),
    Minerals = GetSafeModule(Mine, "Minerals") or nil,
    Ores = GetSafeModule(Mine, "Ores") or nil,
    Pickaxes = GetSafeModule(Mine, "Pickaxes") or nil,
    Converts = GetSafeModule(Mods, "Converts"),
    UIUpgradeTree = GetSafeModule(Mods, "UIUpgradeTree"),
    UIFootballTree = GetSafeModule(Mods, "UIFootballTree"),
    Capsules = GetSafeModule(Mods, "Capsules"),
}
local Tables = {
    NoobNames        = {},
    UpgradeTypes     = {},
    UpgradeNames     = {},
    ExpeditionSlots  = {},
    AnimalNames      = {},
    CookingNames     = {},
    MilestoneNames   = {},
    MineralNames     = {},
    OreNames         = {},
    PickaxeNames     = {},
    CapsuleNames     = {},
    FactoryTierCount = 0,
}
if Modules.Noobs then
    local nl = {}
    for name, data in pairs(Modules.Noobs.List) do
        table.insert(nl, { name = name, order = data.order or 0, special = data.special })
    end
    table.sort(nl, function(a, b)
        if (not a.special) ~= (not b.special) then return not a.special end
        return math.abs(a.order) < math.abs(b.order)
    end)
    for _, e in ipairs(nl) do
        table.insert(Tables.NoobNames, e.name)
    end
end
local UPGRADE_TYPE_ORDER = { "Oof", "Rebirth", "Blaze", "Cash", "Fire", "Bread", "Coin", "Gem", "Water", "Wood", "Ice", "Planks", "HackPoints" }
if Modules.Upgrades then
    local seenTypes = {}
    local function AddUpgradeType(typeName)
        if seenTypes[typeName] or not Modules.Upgrades.List[typeName] then return end
        seenTypes[typeName] = true
        local namesWithOrder = {}
        for upgName, data in pairs(Modules.Upgrades.List[typeName]) do
            table.insert(namesWithOrder, { name = upgName, order = type(data) == "table" and (data.order or 0) or 0 })
        end
        table.sort(namesWithOrder, function(a, b) return a.order < b.order end)
        for _, e in ipairs(namesWithOrder) do
            table.insert(Tables.UpgradeTypes, typeName .. "/" .. e.name)
        end
    end
    for _, typeName in ipairs(UPGRADE_TYPE_ORDER) do
        AddUpgradeType(typeName)
    end
    local remaining = {}
    for typeName in pairs(Modules.Upgrades.List) do
        if not seenTypes[typeName] then
            table.insert(remaining, typeName)
        end
    end
    table.sort(remaining)
    for _, typeName in ipairs(remaining) do
        AddUpgradeType(typeName)
    end
end
if Modules.Expeditions then
    local sl = {}
    for name, data in pairs(Modules.Expeditions.List) do
        table.insert(sl, { name = name, order = data.order or 0 })
    end
    table.sort(sl, function(a, b) return a.order < b.order end)
    for _, e in ipairs(sl) do
        table.insert(Tables.ExpeditionSlots, e.name)
    end
end
if Modules.Animals then
    local al = {}
    for name, data in pairs(Modules.Animals.List) do
        table.insert(al, { name = name, order = data.order or 0 })
    end
    table.sort(al, function(a, b) return a.order < b.order end)
    for _, e in ipairs(al) do
        table.insert(Tables.AnimalNames, e.name)
    end
end
if Modules.Cooking then
    local cl = {}
    for name, data in pairs(Modules.Cooking.List) do
        table.insert(cl, { name = name, order = data.order or 0 })
    end
    table.sort(cl, function(a, b) return a.order < b.order end)
    for _, e in ipairs(cl) do
        table.insert(Tables.CookingNames, e.name)
    end
end
if Modules.CoinMilestones then
    for name in pairs(Modules.CoinMilestones.List) do
        table.insert(Tables.MilestoneNames, name)
    end
end
if Modules.Minerals then
    for name in pairs(Modules.Minerals.List) do
        table.insert(Tables.MineralNames, name)
    end
end
if Modules.Ores then
    for name in pairs(Modules.Ores.List) do
        table.insert(Tables.OreNames, name)
    end
    table.sort(Tables.OreNames)
end
if Modules.Capsules then
    for name in pairs(Modules.Capsules.List) do
        table.insert(Tables.CapsuleNames, name)
    end
    table.sort(Tables.CapsuleNames)
end
if Modules.Pickaxes then
    local pl = {}
    for name, data in pairs(Modules.Pickaxes.List) do
        table.insert(pl, { name = name, order = data.order or 0 })
    end
    table.sort(pl, function(a, b) return a.order < b.order end)
    for _, e in ipairs(pl) do
        table.insert(Tables.PickaxeNames, e.name)
    end
end
if Modules.Factories then
    Tables.FactoryTierCount = #Modules.Factories.Tiers
end
local function NumInput(numStr)
    return BigNum.convert(tonumber(numStr) or 1)
end
local SuffixList = {
    { label = "None",  exp = 0   },
    { label = "k",     exp = 3   },
    { label = "M",     exp = 6   },
    { label = "B",     exp = 9   },
    { label = "T",     exp = 12  },
    { label = "Qd",    exp = 15  },
    { label = "Qn",    exp = 18  },
    { label = "Sx",    exp = 21  },
    { label = "Sp",    exp = 24  },
    { label = "Oc",    exp = 27  },
    { label = "No",    exp = 30  },
    { label = "De",    exp = 33  },
    { label = "UDe",   exp = 36  },
    { label = "DDe",   exp = 39  },
    { label = "TDe",   exp = 42  },
    { label = "QdDe",  exp = 45  },
    { label = "QnDe",  exp = 48  },
    { label = "SxDe",  exp = 51  },
    { label = "SpDe",  exp = 54  },
    { label = "OcDe",  exp = 57  },
    { label = "NoDe",  exp = 60  },
    { label = "Vt",    exp = 63  },
    { label = "UVt",   exp = 66  },
    { label = "DVt",   exp = 69  },
    { label = "TVt",   exp = 72  },
    { label = "QdVt",  exp = 75  },
    { label = "QnVt",  exp = 78  },
    { label = "SxVt",  exp = 81  },
    { label = "SpVt",  exp = 84  },
    { label = "OcVt",  exp = 87  },
    { label = "NoVt",  exp = 90  },
    { label = "Tg",    exp = 93  },
    { label = "UTg",   exp = 96  },
    { label = "DTg",   exp = 99  },
    { label = "TTg",   exp = 102 },
    { label = "QdTg",  exp = 105 },
    { label = "QnTg",  exp = 108 },
    { label = "SxTg",  exp = 111 },
    { label = "SpTg",  exp = 114 },
    { label = "OcTg",  exp = 117 },
    { label = "NoTg",  exp = 120 },
    { label = "qg",    exp = 123 },
    { label = "Uqg",   exp = 126 },
    { label = "Dqg",   exp = 129 },
    { label = "Tqg",   exp = 132 },
    { label = "Qdqg",  exp = 135 },
    { label = "Qnqg",  exp = 138 },
    { label = "Sxqg",  exp = 141 },
    { label = "Spqg",  exp = 144 },
    { label = "Ocqg",  exp = 147 },
    { label = "Noqg",  exp = 150 },
    { label = "Qg",    exp = 153 },
    { label = "UQg",   exp = 156 },
    { label = "DQg",   exp = 159 },
    { label = "TQg",   exp = 162 },
    { label = "QdQg",  exp = 165 },
    { label = "QnQg",  exp = 168 },
    { label = "SxQg",  exp = 171 },
    { label = "SpQg",  exp = 174 },
    { label = "OcQg",  exp = 177 },
    { label = "NoQg",  exp = 180 },
    { label = "sg",    exp = 183 },
    { label = "Usg",   exp = 186 },
    { label = "Dsg",   exp = 189 },
    { label = "Tsg",   exp = 192 },
    { label = "Qdsg",  exp = 195 },
    { label = "Qnsg",  exp = 198 },
    { label = "Sxsg",  exp = 201 },
    { label = "Spsg",  exp = 204 },
    { label = "Ocsg",  exp = 207 },
    { label = "Nosg",  exp = 210 },
    { label = "Sg",    exp = 213 },
    { label = "USg",   exp = 216 },
    { label = "DSg",   exp = 219 },
    { label = "TSg",   exp = 222 },
    { label = "QdSg",  exp = 225 },
    { label = "QnSg",  exp = 228 },
    { label = "SxSg",  exp = 231 },
    { label = "SpSg",  exp = 234 },
    { label = "OcSg",  exp = 237 },
    { label = "NoSg",  exp = 240 },
    { label = "Og",    exp = 243 },
    { label = "UOg",   exp = 246 },
    { label = "DOg",   exp = 249 },
    { label = "TOg",   exp = 252 },
    { label = "QdOg",  exp = 255 },
    { label = "QnOg",  exp = 258 },
    { label = "SxOg",  exp = 261 },
    { label = "SpOg",  exp = 264 },
    { label = "OcOg",  exp = 267 },
    { label = "NoOg",  exp = 270 },
    { label = "Ng",    exp = 273 },
    { label = "UNg",   exp = 276 },
    { label = "DNg",   exp = 279 },
    { label = "TNg",   exp = 282 },
    { label = "QdNg",  exp = 285 },
    { label = "QnNg",  exp = 288 },
    { label = "SxNg",  exp = 291 },
    { label = "SpNg",  exp = 294 },
    { label = "OcNg",  exp = 297 },
    { label = "NoNg",  exp = 300 },
    { label = "Ce",    exp = 303 },
}
local SuffixLabels = {}
local SuffixExpMap = {}
for _, s in ipairs(SuffixList) do
    table.insert(SuffixLabels, s.label)
    SuffixExpMap[s.label] = s.exp
end
local function GetCurrencyAmount(name)
    local cur = Plr:FindFirstChild("CURRENCIES")
    if not cur then return BigNum.convert(0) end
    cur = cur:FindFirstChild(name)
    if not cur then return BigNum.convert(0) end
    local amount = cur:FindFirstChild("Amount")
    if not amount then return BigNum.convert(0) end
    local p1 = amount:FindFirstChild("1")
    if not p1 then return BigNum.convert(0) end
    return BigNum.convert(tonumber(p1.Value) or 0)
end
local function GetCurrencyMultiplier(name)
    local cur = Plr:FindFirstChild("CURRENCIES")
    if not cur then return 1 end
    cur = cur:FindFirstChild(name)
    if not cur then return 1 end
    local tm = cur:FindFirstChild("TotalMultiplier")
    if not tm then return 1 end
    local val = tonumber(tm.Value) or 1
    yuri("[GetCurrencyMultiplier:"..name.."] value=", val)
    return val
end
local Thresholds = {
    Rebirth  = {
        value    = 1,
        currency = "Oof",
        label    = "Rebirth gain",
        getGain  = function()
            local convertsOk = Modules.Converts ~= nil
            local rebirthConvertOk = convertsOk and Modules.Converts.Rebirth ~= nil
            local reqRaw = rebirthConvertOk and Modules.Converts.Rebirth.requirement or nil
            local req = reqRaw or 10000
            local oof = GetCurrencyAmount("Oof")
            local reqBN = BigNum.convert(req)
            local reqStr = (type(reqBN) == "table") and (tostring(reqBN[1]).."e"..tostring(reqBN[2])) or tostring(reqBN)
            local divResult = BigNum.div(oof, reqBN)
            local divStr = (type(divResult) == "table") and (tostring(divResult[1]).."e"..tostring(divResult[2])) or tostring(divResult)
            local mult = GetCurrencyMultiplier("Rebirth")
            local multBN = BigNum.convert(mult)
            local multStr = (type(multBN) == "table") and (tostring(multBN[1]).."e"..tostring(multBN[2])) or tostring(multBN)
            local result = BigNum.mul(divResult, multBN)
            return result
        end,
    },
    Prestige = { value = BigNum.convert(1), currency = "Rebirth", label = "Rebirth" },
    Blaze    = {
        value    = 1,
        currency = "Fire",
        label    = "Blaze gain",
        getGain  = function()
            local req = (Modules.Converts and Modules.Converts.Blaze and Modules.Converts.Blaze.requirement) or 100000
            local fire = GetCurrencyAmount("Fire")
            local reqBN = BigNum.convert(req)
            local divResult = BigNum.div(fire, reqBN)
            local mult = GetCurrencyMultiplier("Blaze")
            local multBN = BigNum.convert(mult)
            local result = BigNum.mul(divResult, multBN)
            local fireStr = (type(fire)=="table") and (tostring(fire[1]).."e"..tostring(fire[2])) or tostring(fire)
            local reqStr = (type(reqBN)=="table") and (tostring(reqBN[1]).."e"..tostring(reqBN[2])) or tostring(reqBN)
            local divStr = (type(divResult)=="table") and (tostring(divResult[1]).."e"..tostring(divResult[2])) or tostring(divResult)
            local resStr = (type(result)=="table") and (tostring(result[1]).."e"..tostring(result[2])) or tostring(result)
            yuri("[BlazeGetGain] fire=", fireStr, "req=", req, "reqBN=", reqStr, "div=", divStr, "mult=", mult, "result=", resStr)
            return result
        end,
    },
    Awaken   = { value = BigNum.convert(1), currency = "Oof", label = "Oof" },
    Tycoon = { value = BigNum.convert(1), currency = "Cash", label = "Tycoon gain" },
}
local function GetGain(key)
    local t = Thresholds[key]
    if t.getGain then return t.getGain() end
    return GetCurrencyAmount(t.currency)
end
local function GetUpgradeLevel(typeName, upgName)
    local upgrades = Plr:FindFirstChild("UPGRADES")
    if not upgrades then return 0 end
    local t = upgrades:FindFirstChild(typeName)
    if not t then return 0 end
    local u = t:FindFirstChild(upgName)
    return u and (tonumber(u.Value) or 0) or 0
end
local function CanAffordUpgrade(typeName, upgData, level)
    if upgData.max then
        local maxOk, maxLvl = pcall(upgData.max, level)
        if maxOk and maxLvl and level >= maxLvl then
            return false
        end
    end
    local success, cost = pcall(upgData.cost, level + 1)
    if not success then
        yuri("[CanAffordUpgrade] cost() pcall failed for", typeName, "level", level, ":", tostring(cost))
        return false
    end
    local costBN = type(cost) == "table" and cost or BigNum.convert(tonumber(cost) or 0)
    return BigNum.meeq(GetCurrencyAmount(typeName), costBN)
end
local function GetNoobLevel(noobName)
    local features = Plr:FindFirstChild("FEATURES")
    if not features then return 0 end
    local noobs = features:FindFirstChild("NOOBS")
    if not noobs then return 0 end
    local noob = noobs:FindFirstChild(noobName)
    if not noob then return 0 end
    local level = noob:FindFirstChild("Level")
    return level and (tonumber(level.Value) or 0) or 0
end
local function CanAffordNoob(noobName)
    local noobData = Modules.Noobs and Modules.Noobs.List[noobName]
    if not noobData or not noobData.noobPrice then return true end
    local currency = noobData.currency or "Oof"
    local level = GetNoobLevel(noobName)
    local ok, cost = pcall(noobData.noobPrice, level + 1)
    if not ok then return true end
    local costBN = type(cost) == "table" and cost or BigNum.convert(tonumber(cost) or 0)
    return BigNum.meeq(GetCurrencyAmount(currency), costBN)
end
local function GetUITreeNodeLevel(nodeName)
    local tree = Plr:FindFirstChild("UI_UPGRADE_TREE")
    if not tree then return 0 end
    local node = tree:FindFirstChild(nodeName)
    return node and (tonumber(node.Value) or 0) or 0
end
local function CanAffordUITreeNode(nodeName)
    if not Modules.UIUpgradeTree then return false end
    local nodeData = Modules.UIUpgradeTree.Nodes[nodeName]
    if not nodeData then return false end
    local level = GetUITreeNodeLevel(nodeName)
    if level >= (nodeData.maxLevel or 1) then return false end
    if not Modules.UIUpgradeTree.IsNodeUnlocked(nodeName, GetUITreeNodeLevel) then return false end
    local costType = nodeData.cost and nodeData.cost.type or "Prism"
    local ok, cost = pcall(nodeData.getCost, level)
    if not ok then return true end
    local costBN = type(cost) == "table" and cost or BigNum.convert(tonumber(cost) or 0)
    return BigNum.meeq(GetCurrencyAmount(costType), costBN)
end
local function GetFootballTreeNodeLevel(nodeName)
    local tree = Plr:FindFirstChild("FOOTBALL_UI_UPGRADE_TREE")
        or Plr:FindFirstChild("SOCCER_UI_UPGRADE_TREE")
    if not tree then return 0 end
    local node = tree:FindFirstChild(nodeName)
    return node and (tonumber(node.Value) or 0) or 0
end
local function CanAffordFootballTreeNode(nodeName)
    if not Modules.UIFootballTree then return false end
    local nodeData = Modules.UIFootballTree.Nodes[nodeName]
    if not nodeData then return false end
    local level = GetFootballTreeNodeLevel(nodeName)
    if level >= (nodeData.maxLevel or 1) then return false end
    if not Modules.UIFootballTree.IsNodeUnlocked(nodeName, GetFootballTreeNodeLevel) then return false end
    local costType = nodeData.cost and nodeData.cost.type or "Goals"
    local ok, cost = pcall(nodeData.getCost, level)
    if not ok then return true end
    local costBN = type(cost) == "table" and cost or BigNum.convert(tonumber(cost) or 0)
    return BigNum.meeq(GetCurrencyAmount(costType), costBN)
end
local function AddRebirthUI(key, label, action)
    local currency = Thresholds[key].currency
    local displayLabel = Thresholds[key].label or currency
    local updateThr
    if Thresholds[key].getGain then
        updateThr = function()
            local base = BigNum.convert(tonumber(Options[key.."Num"].Value) or 1)
            local suffixLabel = Options[key.."Suffix"].Value
            local exp = SuffixExpMap[suffixLabel] or 0
            if exp > 0 then
                Thresholds[key].value = BigNum.new(base[1], base[2] + exp)
            else
                Thresholds[key].value = base
            end
        end
        TB_Tabs.Autofarm.T4:AddDropdown(key.."Suffix", {
            Text    = displayLabel .. " Suffix",
            Values  = SuffixLabels,
            Default = "None",
            Multi   = false,
            Callback = function() updateThr() end,
        })
        TB_Tabs.Autofarm.T4:AddInput(key.."Num", { Text = displayLabel, Default = "1" })
        Options[key.."Num"]:OnChanged(function() updateThr() end)
    end
    TB_Tabs.Autofarm.T2:AddToggle("Auto"..key, {
        Text = "Auto " .. label,
        Default = false,
        Callback = function(val)
            if val and Thresholds[key].getGain then updateThr() end
            Thread("Auto."..key, function()
                while true do
                    if Thresholds[key].getGain and updateThr then updateThr() end
                    local amount = GetGain(key)
                    local tval = Thresholds[key].value
                    local amtType = type(amount)
                    local tvalType = type(tval)
                    local amtStr = (amtType == "table") and (tostring(amount[1]).."e"..tostring(amount[2])) or tostring(amount)
                    local tvalStr = (tvalType == "table") and (tostring(tval[1]).."e"..tostring(tval[2])) or tostring(tval)
                    if key == "Rebirth" then
                        yuri("[AutoRebirth:Rebirth] willFire=", BigNum.meeq(amount, tval))
                    end
                    if key == "Blaze" then
                        local suffixVal = Options["BlazeSuffix"] and Options["BlazeSuffix"].Value or "NIL"
                        local numVal = Options["BlazeNum"] and Options["BlazeNum"].Value or "NIL"
                        local expVal = SuffixExpMap[suffixVal] or "NIL"
                        yuri("[AutoBlaze:loop] suffix=", suffixVal, "num=", numVal, "exp=", expVal, "tval=", tvalStr, "amount=", amtStr, "meeq=", BigNum.meeq(amount, tval))
                    end
                    if BigNum.meeq(amount, tval) then
                        yuri("[AutoRebirth:"..key.."] FIRING")
                        Fire(action)
                    end
                    task.wait(getDelay("AutoRebirth"))
                end
            end, val)
        end
    })
end
local EQ_TYPES = { "Necklace", "Ring", "Geode", "Special" }
TB_Tabs.Autofarm.T1:AddDropdown("NoobSelect", {
    Text    = "Select Noobs",
    Values  = Tables.NoobNames,
    Default = {},
    Multi   = true,
})
TB_Tabs.Autofarm.T1:AddToggle("NoobUseMax", { Text = "Upgrade Max", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoNoob", { Text = "Auto Noob", Default = false })
Toggles.AutoNoob:OnChanged(function(v)
    Thread("AutoNoob.Main", function()
        while true do
            for name, active in pairs(Options.NoobSelect.Value) do
                if active then
                    if CanAffordNoob(name) then
                        local action = Toggles.NoobUseMax.Value and "UpgradeNoobMax" or "UpgradeNoob"
                        Fire(action, name)
                    end
                    task.wait(getDelay("AutoNoob"))
                end
            end
            task.wait(getDelay("AutoNoob"))
        end
    end, v)
end)
TB_Tabs.Autofarm.T1:AddDropdown("UpgradeTypeSelect", {
    Text    = "Select Upgrade Types",
    Values  = Tables.UpgradeTypes,
    Default = {},
    Multi   = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
Toggles.AutoUpgrade:OnChanged(function(v)
    Thread("AutoUpgrade.Main", function()
        while true do
            for _, upgradeKey in ipairs(Tables.UpgradeTypes) do
                if Options.UpgradeTypeSelect.Value[upgradeKey] then
                    local typeName, upgName = upgradeKey:match("^(.+)/(.+)$")
                    if typeName and upgName then
                        local upgData = Modules.Upgrades and Modules.Upgrades.List[typeName] and Modules.Upgrades.List[typeName][upgName]
                        if upgData and upgData.cost then
                            local level = GetUpgradeLevel(typeName, upgName)
                            if CanAffordUpgrade(typeName, upgData, level) then
                                Fire("UpgradeUpgradeMax", typeName, upgName)
                                Fire("UpgradeUpgrade", typeName, upgName)
                                task.wait(getDelay("AutoUpgrade"))
                            end
                        else
                            Fire("UpgradeUpgradeMax", typeName, upgName)
                            Fire("UpgradeUpgrade", typeName, upgName)
                            task.wait(getDelay("AutoUpgrade"))
                        end
                    end
                end
            end
            task.wait(getDelay("AutoUpgrade"))
        end
    end, v)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoSkillTree", { Text = "Auto Unlock Skill Tree", Default = false })
Toggles.AutoSkillTree:OnChanged(function(v)
    Thread("AutoSkillTree.Main", function()
        while true do
            if Modules.UIUpgradeTree then
                for nodeName in pairs(Modules.UIUpgradeTree.Nodes) do
                    if CanAffordUITreeNode(nodeName) then
                        Fire("BuyUITreeNode", nodeName)
                        task.wait(getDelay("AutoSkillTree"))
                    end
                end
            end
            task.wait(getDelay("AutoSkillTree"))
        end
    end, v)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoFootballTree", { Text = "Auto Football Tree", Default = false })
Toggles.AutoFootballTree:OnChanged(function(v)
    Thread("AutoFootballTree.Main", function()
        while true do
            if Modules.UIFootballTree then
                for nodeName in pairs(Modules.UIFootballTree.Nodes) do
                    if CanAffordFootballTreeNode(nodeName) then
                        Fire("BuyFootballUITreeNode", nodeName)
                        task.wait(getDelay("AutoSkillTree"))
                    end
                end
            end
            task.wait(getDelay("AutoSkillTree"))
        end
    end, v)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradeTree", { Text = "Auto Upgrade Tree", Default = false })
Toggles.AutoUpgradeTree:OnChanged(function(v)
    Thread("AutoUpgradeTree.Main", function()
        while true do
            for _, node in ipairs(CollectionService:GetTagged("UpgradeTreeNodeTag")) do
                local cd = node:FindFirstChildOfClass("ClickDetector")
                if cd then
                    fireclickdetector(cd)
                    task.wait(0.05)
                end
            end
            task.wait(0.5)
        end
    end, v)
end)
AddRebirthUI("Rebirth",  "Rebirth",     "Rebirth")
AddRebirthUI("Prestige", "Prestige",    "Prestige")
AddRebirthUI("Blaze",    "Blaze",       "Blaze")
AddRebirthUI("Awaken",   "Awaken Tier", "AwakenTier")
AddRebirthUI("Tycoon",   "Tycoon",      "Tycoon")
TB_Tabs.Autofarm2.T1:AddToggle("AutoExchMinerals", { Text = "Exchange All Minerals",       Default = false })
TB_Tabs.Autofarm2.T1:AddToggle("AutoExchAnimals",  { Text = "Exchange Animal Products",    Default = false })
Toggles.AutoExchMinerals:OnChanged(function(v)
    Thread("AutoExch.Minerals", function()
        while true do
            task.wait(getDelay("AutoExchMinerals"))
            Fire("ExchangeAllMinerals")
            task.wait(getDelay("AutoExchMinerals"))
        end
    end, v)
end)
Toggles.AutoExchAnimals:OnChanged(function(v)
    Thread("AutoExch.Animals", function()
        while true do
            task.wait(getDelay("AutoExchAnimals"))
            Fire("ExchangeAllAnimalProducts")
            task.wait(getDelay("AutoExchAnimals"))
        end
    end, v)
end)
TB_Tabs.Autofarm2.T1:AddToggle("AutoUnlockField", { Text = "Auto Unlock Field", Default = false })
Toggles.AutoUnlockField:OnChanged(function(v)
    Thread("AutoUnlock.Field", function()
        while true do
            local features = Plr:FindFirstChild("FEATURES")
            local farmFeats = features and features:FindFirstChild("FARM")
            if farmFeats then
                for _, slot in ipairs(CollectionService:GetTagged("WheatSlot")) do
                    local slotKey = slot.Name
                    local slotData = farmFeats:FindFirstChild(slotKey)
                    local unlockedVal = slotData and slotData:FindFirstChild("Unlocked")
                    if unlockedVal and not unlockedVal.Value then
                        local clickDetector = slot:FindFirstChildOfClass("ClickDetector")
                        if clickDetector then
                            fireclickdetector(clickDetector)
                            task.wait(0.1)
                        end
                    end
                end
            end
            task.wait(1)
        end
    end, v)
end)
TB_Tabs.Autofarm2.T1:AddToggle("AutoDepositWheat", { Text = "Deposit Wheat", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("WheatHarvestStage", {
    Text     = "Harvest Wheat Stage",
    Default  = "5",
    Numeric  = true,
    Finished = false,
})
TB_Tabs.Autofarm2.T1:AddToggle("AutoHarvestWheat", { Text = "Auto Harvest Wheat", Default = false })
Toggles.AutoHarvestWheat:OnChanged(function(v)
    Thread("AutoHarvest.Wheat", function()
        while true do
            local wheatStage = tostring(tonumber(Options.WheatHarvestStage.Value) or 5)
            for _, slot in ipairs(CollectionService:GetTagged("WheatSlot")) do
                local clickDetector = slot:FindFirstChildOfClass("ClickDetector")
                local Stage = slot:FindFirstChild(wheatStage)
                if clickDetector and Stage then
                    fireclickdetector(clickDetector)
                    task.wait(0.05)
                end
            end
            task.wait(0.1)
        end
    end, v)
end)
Toggles.AutoDepositWheat:OnChanged(function(v)
    Thread("AutoDeposit.Wheat", function()
        while true do
            task.wait(getDelay("AutoDepositWheat"))
            Fire("DepositWheat")
            task.wait(getDelay("AutoDepositWheat"))
        end
    end, v)
end)
TB_Tabs.Autofarm2.T1:AddToggle("AutoDepositOil",   { Text = "Deposit Oil",   Default = false })
Toggles.AutoDepositOil:OnChanged(function(v)
    Thread("AutoDeposit.Oil", function()
        while true do
            task.wait(getDelay("AutoDepositOil"))
            Fire("DepositOil")
            task.wait(getDelay("AutoDepositOil"))
        end
    end, v)
end)
local RuneTypes = { "Basic", "Super", "Advanced", "Cosmic Prism", "Hacker", "Snowy", "Deepcore", "Football"}
TB_Tabs.Autofarm2.T1:AddDropdown("RuneTypeSelect", {
    Text    = "Select Runes",
    Values  = RuneTypes,
    Default = {},
    Multi   = true,
})
TB_Tabs.Autofarm2.T1:AddInput("RuneRollDelay", {
    Text        = "Rune Roll Delay",
    Default     = "0.1",
    Numeric     = true,
    Finished    = false,
})
TB_Tabs.Autofarm2.T1:AddToggle("AutoRollRunes", { Text = "Auto Roll Runes", Default = false })
Toggles.AutoRollRunes:OnChanged(function(v)
    Thread("AutoRoll.Runes", function()
        while true do
            local delay = tonumber(Options.RuneRollDelay.Value) or 0.1
            for _, runeType in ipairs(RuneTypes) do
                if Options.RuneTypeSelect.Value[runeType] then
                    Fire("RollRune", runeType)
                    task.wait(delay)
                end
            end
            task.wait(delay)
        end
    end, v)
end)
TB_Tabs.Autofarm2.T1:AddInput("TierRollDelay", {
    Text        = "Tier Roll Delay",
    Default     = "0.1",
    Numeric     = true,
    Finished    = false,
})
TB_Tabs.Autofarm2.T1:AddToggle("AutoRollTier", { Text = "Auto Roll Tier", Default = false })
Toggles.AutoRollTier:OnChanged(function(v)
    Thread("AutoRoll.Tier", function()
        while true do
            Fire("RollTier")
            task.wait(tonumber(Options.TierRollDelay.Value) or 0.1)
        end
    end, v)
end)
TB_Tabs.Autofarm2.T1:AddToggle("AutoBuyFactory",   { Text = "Auto Buy Factory",   Default = false })
TB_Tabs.Autofarm2.T1:AddToggle("AutoMergeFactory", { Text = "Auto Merge Factory", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("OreSelect", {
    Text      = "Select Ore",
    Values    = Tables.OreNames,
    Default   = {},
    Multi     = true,
})
TB_Tabs.Autofarm2.T1:AddToggle("AutoMineOre",      { Text = "Auto Mine Ore",      Default = false })
Toggles.AutoBuyFactory:OnChanged(function(v)
    Thread("AutoFactory.Buy", function()
        while true do
            task.wait(getDelay("AutoBuyFactory"))
            Fire("BuyFactory", true)
            task.wait(getDelay("AutoBuyFactory"))
        end
    end, v)
end)
Toggles.AutoMergeFactory:OnChanged(function(v)
    Thread("AutoFactory.Merge", function()
        while true do
            for k = 1, Tables.FactoryTierCount - 1 do
                Fire("MergeFactory", k - 1, true)
                task.wait(getDelay("AutoMergeFactory"))
            end
            task.wait(getDelay("AutoMergeFactory"))
        end
    end, v)
end)
local function IsOreBroken(model)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Transparency < 0.9 then
                return false
            end
        end
    end
    return true
end
Toggles.AutoMineOre:OnChanged(function(v)
    Thread("AutoMine.Ore", function()
        while true do
            local selected = Options.OreSelect.Value
            local ores = CollectionService:GetTagged("Ore")
            local foundOre = false
            for _, model in ipairs(ores) do
                if not model.Parent then continue end
                if not selected[model.Name] then continue end
                if IsOreBroken(model) then continue end
                foundOre = true
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local ok, cf = pcall(function() return model:GetPivot() end)
                    if ok and cf then
                        hrp.CFrame = cf * CFrame.new(0, 3, 0)
                    end
                end
                while model.Parent and not IsOreBroken(model) do
                    task.wait()
                end
                break
            end
            if not foundOre then
                task.wait()
            end
        end
    end, v)
end)
TB_Tabs.Autofarm.T3:AddToggle("AutoBuyAnimals",     { Text = "Auto Buy Animals",     Default = false })
TB_Tabs.Autofarm.T3:AddToggle("AutoUpgradeAnimals", { Text = "Auto Upgrade Animals", Default = false })
Toggles.AutoBuyAnimals:OnChanged(function(v)
    Thread("Animals.Buy", function()
        while true do
            for _, name in ipairs(Tables.AnimalNames) do
                Fire("BuyAnimal", name)
                task.wait(getDelay("AutoBuyAnimals"))
            end
            task.wait(getDelay("AutoBuyAnimals"))
        end
    end, v)
end)
Toggles.AutoUpgradeAnimals:OnChanged(function(v)
    Thread("Animals.Upgrade", function()
        while true do
            for _, name in ipairs(Tables.AnimalNames) do
                Fire("UpgradeAnimal", name)
                task.wait(getDelay("AutoUpgradeAnimals"))
            end
            task.wait(getDelay("AutoUpgradeAnimals"))
        end
    end, v)
end)
TB_Tabs.Autofarm.T3:AddToggle("AutoCooking", { Text = "Auto Buy Cooking", Default = false })
Toggles.AutoCooking:OnChanged(function(v)
    Thread("Cooking.Buy", function()
        while true do
            for _, name in ipairs(Tables.CookingNames) do
                Fire("BuyCooking", name)
                task.wait(getDelay("AutoCooking"))
            end
            task.wait(getDelay("AutoCooking"))
        end
    end, v)
end)
TB_Tabs.Autofarm.T3:AddDropdown("CapsuleSelect", {
    Text      = "Select Capsule",
    Values    = Tables.CapsuleNames,
    Default   = {},
    Multi     = true,
})
TB_Tabs.Autofarm.T3:AddToggle("AutoOpenCapsule", { Text = "Auto Open Capsule", Default = false })
Toggles.AutoOpenCapsule:OnChanged(function(v)
    Thread("Capsule.Open", function()
        while true do
            task.wait(getDelay("AutoOpenCapsule"))
            local selected = Options.CapsuleSelect.Value
            for name, isSelected in pairs(selected) do
                if isSelected then
                    Fire("OpenCapsule", name)
                    task.wait(getDelay("AutoOpenCapsule"))
                end
            end
        end
    end, v)
end)
TB_Tabs.Autofarm.T3:AddDivider()
local ExpNoobValues = {}
if Modules.Noobs then
    for _, noobName in ipairs(Tables.NoobNames) do
        local data = Modules.Noobs.List[noobName]
        if not data.special then
            table.insert(ExpNoobValues, noobName)
        end
    end
end
if #ExpNoobValues == 0 then
    table.insert(ExpNoobValues, "Starter")
end
for _, slotName in ipairs(Tables.ExpeditionSlots) do
    local sendId = "ExpSend_" .. slotName
    local dropId = "ExpNoob_" .. slotName
    TB_Tabs.Autofarm.T3:AddLabel(slotName .. " Expedition")
    TB_Tabs.Autofarm.T3:AddDropdown(dropId, {
        Text      = "Noob",
        Values    = ExpNoobValues,
        Default   = ExpNoobValues[1],
        AllowNull = false,
    })
    TB_Tabs.Autofarm.T3:AddToggle(sendId, { Text = "Auto Send " .. slotName, Default = false })
    Toggles[sendId]:OnChanged(function(v)
        Thread("Expedition." .. slotName, function()
            while true do
                task.wait(getDelay("AutoExpedition"))
                local noobName = Options[dropId] and Options[dropId].Value or ExpNoobValues[1]
                Fire("SendNoobExpedition", slotName, noobName)
                task.wait(getDelay("AutoExpedition"))
            end
        end, v)
    end)
end
local ZoneStore = {}
local function tryGetCFrame(inst)
    local ok, cf = pcall(function() return inst:GetPivot() end)
    if not ok then ok, cf = pcall(function() return inst.CFrame end) end
    return ok and cf or nil
end
local function addZone(label, part)
    if ZoneStore[label] then return end
    local cf = tryGetCFrame(part)
    if cf then
        ZoneStore[label] = cf
    end
end
local function ScanZones()
    table.clear(ZoneStore)
    for _, model in ipairs(CollectionService:GetTagged("NoobsTag")) do
        local part = model:FindFirstChild("_Zone_Buy_Noob")
        if part and part:IsA("BasePart") then
            addZone(model.Name, part)
        end
    end
    for _, model in ipairs(CollectionService:GetTagged("RuneZone")) do
        local part = model:FindFirstChild("_Zone_Rune_Roll")
        if part and part:IsA("BasePart") then
            addZone("Rune:" .. model.Name, part)
        end
    end
    for _, model in ipairs(CollectionService:GetTagged("Game_Zone_UI")) do
        local part = model:FindFirstChild("TouchPart")
        if part and part:IsA("BasePart") then
            addZone("UI:" .. model.Name, part)
        end
    end
    local gc = workspace:FindFirstChild("__GAME_CONTENT")
    if gc then
        for _, v in ipairs(gc:GetDescendants()) do
            if v:IsA("BasePart") and string.lower(v.Name):match("zone") then
                local label = v.Parent and (v.Parent.Name .. "/" .. v.Name) or v.Name
                addZone(label, v)
            end
        end
    end
end
ScanZones()
TB_Tabs.Autofarm.T3:AddDivider()
local ZoneGroup = TB_Tabs.Autofarm.T3
ZoneGroup:AddLabel("Zone Teleport")
ZoneGroup:AddButton({ Text = "Refresh Zones", Func = function()
    ScanZones()
    local names = {}
    for k in pairs(ZoneStore) do table.insert(names, k) end
    Options.ZoneSelect:SetValues(names)
end })
local zoneNames = {}
for k in pairs(ZoneStore) do table.insert(zoneNames, k) end
ZoneGroup:AddDropdown("ZoneSelect", {
    Text     = "Select Zone(s)",
    Values   = zoneNames,
    Default  = {},
    Multi    = true,
})
ZoneGroup:AddSlider("ZoneTeleportDelay", {
    Text     = "Teleport Delay",
    Default  = 1,
    Min      = 0,
    Max      = 10,
    Rounding = 1,
    Compact  = true,
})
ZoneGroup:AddToggle("ZoneTeleport", { Text = "Teleport to Zone", Default = false })
Toggles.ZoneTeleport:OnChanged(function(v)
    Thread("ZoneTeleport.Main", function()
        while true do
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for name, active in pairs(Options.ZoneSelect.Value) do
                    if active and ZoneStore[name] then
                        hrp.CFrame = ZoneStore[name]
                        task.wait(Options.ZoneTeleportDelay.Value)
                    end
                end
            end
            task.wait(0.1)
        end
    end, v)
end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/NoobIncremental")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
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
end
