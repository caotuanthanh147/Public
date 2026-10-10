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
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting')
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local CoreGui = Services.CoreGui
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
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
    local seconds = os.time() - Script_Start_Time
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    return string.format("%dh %02dm", hours, mins)
end
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
local function GetRemote(parent, pathString)
    return GetObject(parent, pathString)
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
local Net = GetObject(RS, "Util.Net")
local Net = GetObject(RS, "Util.Net")
local Remotes = {
    PlayCutscene             = GetObject(Net, "RE/PlayCutscene"),
    StartHeartbeat           = GetObject(Net, "RE/StartHeartbeatMinigame"),
    CompleteHeartbeat        = GetObject(Net, "RE/HeartbeatMinigameComplete"),
    PlayerLostSanity         = GetObject(Net, "RE/PlayerLostSanity"),
    PlayAgainVote            = GetObject(Net, "RE/PlayAgainVote"),
    Stats                    = GetObject(Net, "RE/Stats"),
    Quickstart               = GetObject(Net, "RE/Quickstart"),
    SkipDialogue = GetObject(Net, "RE/SetDoctorDialogueSkipped"),
}
local DataFolder = GetObject(RS, "Data")
local Modules = {
    ShopWares         = GetSafeModule(DataFolder, "UpgradeShopWares"),
    IllnessesAndCures = GetSafeModule(DataFolder, "IllnessesAndCures"),
}
local ok, Cures = pcall(function()
    return Modules.IllnessesAndCures.GetCures()
end)
if not ok then Cures = {} end
local Flags = {}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local Shared = {
    LocalCash            = 0,
    ColorRunning  = false,
    ColorMatch    = {},
    HeartbeatConn = nil,
    RejectedNpcs         = {},
    bodyVelocity         = nil,
    bodyGyro             = nil,
    bodyLockActive       = false,
    noclipConn           = nil,
    noclipOrigins        = {},
}
local Tables = {}
local BODY_VEL_NAME     = "a"
local BODY_GYRO_NAME    = "b"
local COFFEE_READY_TEXT = "coffee: <font color='rgb(0, 200, 0)'>ready</font>"
local OintmentPP        = GetObject(workspace, "Model.Items.Ointment.PP")
local ShutterPP         = GetObject(workspace, "Misc.ShutterButton.PP")
local CheckInFolder     = GetObject(workspace, "Misc.CheckIn")
local CheckIn2Folder    = GetObject(workspace, "Misc.CheckIn2")
local NPCsFolder        = GetObject(workspace, "NPCs")
local RoomsFolder       = GetObject(workspace, "Rooms")
local ShopItemsFolder   = GetObject(workspace, "Misc.ShopItems")
local CoffeeMachine     = GetObject(workspace, "Misc.CoffeeMachine")
local CoffeeMachinePP   = CoffeeMachine and CoffeeMachine.Coffee.PP
local CoffeeMachineStatus = CoffeeMachine and CoffeeMachine.Attachment.UI.status
local AnomaliesFolder   = GetObject(RS, "NPCs.Anomalies")
local DisguiseReveals   = GetObject(RS, "AnomalyEvents.DisguiseReveals")
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
local function GenUUID()
    return HttpService:GenerateGUID(false):lower()
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
local function GetHRP()
    local char = GetCharacter()
    return char and char.HumanoidRootPart
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
local function FireCD(target)
    if not fireclickdetector then return end
    if not target or not target:IsA("ClickDetector") then return end
    fireclickdetector(target)
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
local function BodyControlOn(hrp)
    if not hrp or Shared.bodyLockActive then return end
    Shared.bodyLockActive = true
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
            inst:Destroy()
        end
    end
    hrp.Anchored = false
    Shared.bodyVelocity = Library:Create("BodyVelocity", {
        Name = BODY_VEL_NAME,
        MaxForce = Vector3.new(1e6, 1e6, 1e6),
        Velocity = Vector3.zero,
        Parent = hrp,
    })
    Shared.bodyGyro = Library:Create("BodyGyro", {
        Name = BODY_GYRO_NAME,
        MaxTorque = Vector3.new(1e6, 1e6, 1e6),
        CFrame = hrp.CFrame,
        Parent = hrp,
    })
    Shared.noclipOrigins = {}
    if Shared.noclipConn then Shared.noclipConn:Disconnect() end
    Shared.noclipConn = RunService.Stepped:Connect(function()
        local char = Plr.Character
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= BODY_VEL_NAME then
                if Shared.noclipOrigins[part] == nil then
                    Shared.noclipOrigins[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    end)
end
local function BodyControlOff(hrp)
    if not Shared.bodyLockActive then return end
    Shared.bodyLockActive = false
    if Shared.noclipConn then
        Shared.noclipConn:Disconnect()
        Shared.noclipConn = nil
    end
    local char = Plr.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and Shared.noclipOrigins[part] ~= nil then
                part.CanCollide = Shared.noclipOrigins[part]
            end
        end
    end
    Shared.noclipOrigins = {}
    if hrp then
        for _, inst in ipairs(hrp:GetChildren()) do
            if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
                inst:Destroy()
            end
        end
    end
    Shared.bodyVelocity = nil
    Shared.bodyGyro = nil
end
local function UpdateBodyLock()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if Toggles.AutoCheckIn.Value or Toggles.AutoCure.Value then
        BodyControlOn(hrp)
    else
        BodyControlOff(hrp)
    end
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
local function CreateSwitchGroup(tab, id, displayName, tableSource)
    local toggle = tab:AddToggle("Auto"..id, { Text = "Auto Switch "..displayName, Default = false })
    toggle:OnChanged(function(state)
        if not state then
            Shared.LastSwitch[id] = ""
        end
    end)
    local listToUse = (id == "Title") and CombinedTitleList or tableSource
    tab:AddDropdown(id.."_BossHP", { Text = displayName.." [Boss HP%]", Values = listToUse, AllowNull = true, Searchable = true })
    tab:AddSlider(id.."_BossHPAmt", { Text = "Change Until Boss HP%", Default = 15, Min = 0, Max = 100, Rounding = 0 })
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
    Main   = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    ESP    = Window:AddTab("ESP"),
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Autofarm = Tabs.Main:AddLeftTabbox(),
        },
    },
}
local TB_Tabs = {
    Autofarm = {
        T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
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
GB.Player.Left.General:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", { Text = "Anti AFK", Default = true, Disabled = not Support.Connections })
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused" })
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
    local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end })
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
        for i, v in pairs(GC(Players.LocalPlayer.Idled)) do
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
local ESPGroupLeft  = Tabs.ESP:AddLeftGroupbox("ESP")
local ESPGroupRight = Tabs.ESP:AddRightGroupbox("ESP")
local TargetConfig = {
    { Id = "ESPNPCs", Group = "left", Text = "NPC ESP", Tag = nil,
      Target  = function() return NPCsFolder end,
      Color   = Color3.fromRGB(255, 100, 100), Display = "NPC" },
}
local ESPFolder = Library:Create("Folder", {
    Name   = GenUUID(),
    Parent = CoreGui,
})
local ESPConnections = {}
local AllHighlights = {}
for _, cfg in ipairs(TargetConfig) do AllHighlights[cfg.Id] = {} end
local function getPartForAdornee(target)
    if target:IsA("BasePart") then
        return target
    elseif target:IsA("Model") then
        return target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end
local function makeLabel(text, sizeY, posY, bold, textColor)
    return Library:Create("TextLabel", {
        Size                   = UDim2.new(1, 0, sizeY, 0),
        Position               = UDim2.new(0, 0, posY, 0),
        BackgroundTransparency = 1,
        Text                   = text,
        TextColor3             = textColor or Color3.new(1, 1, 1),
        TextStrokeColor3       = Color3.new(0, 0, 0),
        TextStrokeTransparency = 0.4,
        TextScaled             = true,
        Font                   = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextXAlignment         = Enum.TextXAlignment.Center,
    })
end
local function makeBillboard(target, name, textColor)
    local part = getPartForAdornee(target)
    if not part then return nil end
    local bb = Library:Create("BillboardGui", {
        Name         = GenUUID(),
        Adornee      = part,
        Size         = UDim2.new(0, 70, 0, 20),
        StudsOffset  = Vector3.new(0, 3, 0),
        AlwaysOnTop  = true,
        ResetOnSpawn = false,
        Parent       = ESPFolder,
    })
    local nameLbl = makeLabel(name, 0.55, 0, true, textColor)
    nameLbl.Name   = GenUUID()
    nameLbl.Parent = bb
    local distLbl = makeLabel("", 0.45, 0.55, false, textColor)
    local distLblName = GenUUID()
    distLbl.Name   = distLblName
    distLbl.Parent = bb
    bb:SetAttribute("DistLabel", distLblName)
    return bb
end
local function makeHighlight(target, fillColor, outlineColor, labelName, textColor)
    local h = Library:Create("Highlight", {
        Adornee             = target,
        FillColor           = fillColor,
        OutlineColor        = outlineColor,
        FillTransparency    = 0.4,
        OutlineTransparency = 0,
        DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop,
        Parent              = ESPFolder,
    })
    local bb = makeBillboard(target, labelName or (target.Name ~= "" and target.Name or "?"), textColor)
    return { highlight = h, billboard = bb }
end
local function removeHighlight(tbl, key)
    if tbl[key] then
        if tbl[key].highlight then tbl[key].highlight:Destroy() end
        if tbl[key].billboard then tbl[key].billboard:Destroy() end
        tbl[key] = nil
    end
end
local function refreshESP(cfg)
    local tbl = AllHighlights[cfg.Id]
    for k in pairs(tbl) do removeHighlight(tbl, k) end
    if not Toggles[cfg.Id].Value then return end
    local fillColor    = Options[cfg.Id .. "Color"].Value
    local outlineColor = Options[cfg.Id .. "Outline"].Value
    local items
    if cfg.Tag then
        items = Services.CollectionService:GetTagged(cfg.Tag)
    elseif cfg.GetItems then
        items = cfg.GetItems()
    elseif cfg.Target then
        local folder = cfg.Target()
        items = folder and folder:GetChildren() or {}
    else
        items = {}
    end
    for _, item in ipairs(items) do
        if not cfg.filter or cfg.filter(item) then
            tbl[item] = makeHighlight(item, fillColor, outlineColor, cfg.Display, fillColor)
        end
    end
end
local ESPSubConns = {}
local function watchESP(cfg)
    local addKey = cfg.Id .. "Added"
    local remKey = cfg.Id .. "Removed"
    local subKey = cfg.Id .. "Sub"
    if ESPConnections[addKey] then ESPConnections[addKey]:Disconnect(); ESPConnections[addKey] = nil end
    if ESPConnections[remKey] then ESPConnections[remKey]:Disconnect(); ESPConnections[remKey] = nil end
    if ESPSubConns[subKey] then
        for _, conn in pairs(ESPSubConns[subKey]) do conn:Disconnect() end
        ESPSubConns[subKey] = nil
    end
    if not Toggles[cfg.Id].Value then return end
    local tbl          = AllHighlights[cfg.Id]
    local fillColor    = function() return Options[cfg.Id .. "Color"].Value end
    local outlineColor = function() return Options[cfg.Id .. "Outline"].Value end
    local function onAdded(item)
        if not Toggles[cfg.Id].Value then return end
        if cfg.filter and not cfg.filter(item) then return end
        tbl[item] = makeHighlight(item, fillColor(), outlineColor(), cfg.Display, fillColor())
    end
    local function onRemoved(item)
        removeHighlight(tbl, item)
    end
    if cfg.Tag then
        ESPConnections[addKey] = Services.CollectionService:GetInstanceAddedSignal(cfg.Tag):Connect(onAdded)
        ESPConnections[remKey] = Services.CollectionService:GetInstanceRemovedSignal(cfg.Tag):Connect(onRemoved)
    elseif cfg.GetItems then
        local root = cfg.GetRoot and cfg.GetRoot()
        if not root then return end
        local subConns = {}
        ESPSubConns[subKey] = subConns
        local function watchSubFolder(shrineFolder)
            if subConns[shrineFolder] then return end
            subConns[shrineFolder] = shrineFolder.ChildAdded:Connect(function(child)
                if child:IsA("MeshPart") then onAdded(child) end
            end)
        end
        local function onSubFolderRemoved(shrineFolder)
            if subConns[shrineFolder] then
                subConns[shrineFolder]:Disconnect()
                subConns[shrineFolder] = nil
            end
            for item in pairs(tbl) do
                if item.Parent == shrineFolder then onRemoved(item) end
            end
        end
        for _, child in ipairs(root:GetChildren()) do
            watchSubFolder(child)
        end
        ESPConnections[addKey] = root.ChildAdded:Connect(function(child)
            watchSubFolder(child)
        end)
        ESPConnections[remKey] = root.ChildRemoved:Connect(function(child)
            onSubFolderRemoved(child)
        end)
    elseif cfg.Target then
        local folder = cfg.Target()
        if not folder then return end
        ESPConnections[addKey] = folder.ChildAdded:Connect(onAdded)
        ESPConnections[remKey] = folder.ChildRemoved:Connect(onRemoved)
    end
end
for _, cfg in ipairs(TargetConfig) do
    local grp = cfg.Group == "right" and ESPGroupRight or ESPGroupLeft
    grp:AddToggle(cfg.Id, { Text = cfg.Text, Default = false })
    grp:AddLabel("Fill Color"):AddColorPicker(cfg.Id .. "Color", {
        Title   = cfg.Text .. " Fill",
        Default = cfg.Color,
    })
    grp:AddLabel("Outline Color"):AddColorPicker(cfg.Id .. "Outline", {
        Title   = cfg.Text .. " Outline",
        Default = Color3.fromRGB(0, 0, 0),
    })
    Toggles[cfg.Id]:OnChanged(function()
        refreshESP(cfg)
        watchESP(cfg)
    end)
    Options[cfg.Id .. "Color"]:OnChanged(function()
        local tbl = AllHighlights[cfg.Id]
        local v   = Options[cfg.Id .. "Color"].Value
        for _, e in pairs(tbl) do
            if e.highlight then e.highlight.FillColor = v end
            if e.billboard then
                for _, lbl in ipairs(e.billboard:GetChildren()) do
                    if lbl:IsA("TextLabel") then lbl.TextColor3 = v end
                end
            end
        end
    end)
    Options[cfg.Id .. "Outline"]:OnChanged(function()
        local tbl = AllHighlights[cfg.Id]
        local v   = Options[cfg.Id .. "Outline"].Value
        for _, e in pairs(tbl) do if e.highlight then e.highlight.OutlineColor = v end end
    end)
end
Connections.espDistUpdate = RunService.Heartbeat:Connect(function()
    local hrp = GetHRP()
    if not hrp then return end
    local origin = hrp.Position
    for _, tbl in pairs(AllHighlights) do
        for _, entry in pairs(tbl) do
            if entry.billboard and entry.billboard.Adornee then
                local dist = math.floor((entry.billboard.Adornee.Position - origin).Magnitude)
                local lbl  = entry.billboard and entry.billboard:FindFirstChild(entry.billboard:GetAttribute("DistLabel"))
                if lbl then lbl.Text = dist .. " studs" end
            end
        end
    end
end)
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", { Text = "Auto Show UI", Default = true })
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
    ESPFolder:Destroy()
    Cleanup(ESPConnections)
    Cleanup(Connections)
    Cleanup(Flags)
    Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
Remotes.Stats.OnClientEvent:Connect(function(_, statsTable)
    if type(statsTable) == "table" and statsTable.LocalCash ~= nil then
        Shared.LocalCash = statsTable.LocalCash
    end
end)
local function IsAnomalyNPC(npc)
    return AnomaliesFolder:FindFirstChild(npc.Name) ~= nil
end
local function FireEnabledCheckInPP()
    local fired = false
    local checkInFolders = {CheckInFolder, GetObject(workspace, "Misc.CheckIn2")}
    for _, folder in ipairs(checkInFolders) do
        if not folder then continue end
        for _, desc in ipairs(folder:GetDescendants()) do
            if desc:IsA("ProximityPrompt") and desc.Enabled and desc.Parent.Name ~= "Photo" then
                FirePP(desc, true)
                fired = true
                break
            end
        end
    end
    return fired
end
local function RejectNPC(npc)
    local Reason = npc:GetAttribute("CameraEffect") or "Unknown"
    notyuri("[AutoCheckIn] Anomaly detected on", npc.Name, "| Effect:", Reason)
    Library:Notify("Anomaly detected: " .. Reason, 2)
    repeat
        FirePP(ShutterPP, true)
        task.wait(0.175)
    until ShutterPP.ActionText == "Open"
    local rejected = false
    local conn
    conn = Remotes.PlayCutscene.OnClientEvent:Connect(function(cutsceneName, cutsceneNpc)
        if cutsceneName == "VisitorRejected" and cutsceneNpc == npc then
            rejected = true
            conn:Disconnect()
        end
    end)
    local rejectStart = tick()
    repeat task.wait() until rejected or (tick() - rejectStart) > 30
    if not rejected then
        conn:Disconnect()
        notyuri("[AutoCheckIn] WARNING: VisitorRejected cutscene never fired for", npc.Name, "- proceeding anyway")
    end
    repeat
        FirePP(ShutterPP, true)
        task.wait(0.175)
    until ShutterPP.ActionText == "Close"
    notyuri("[AutoCheckIn] Shutter unlocked after rejecting", npc.Name)
end
Remotes.PlayCutscene.OnClientEvent:Connect(function(cutsceneName, cutsceneNpc)
    if cutsceneName == "VisitorRejected" and cutsceneNpc then
        if not Shared.RejectedNpcs[cutsceneNpc] then
            Shared.RejectedNpcs[cutsceneNpc] = true
        end
    end
end)
local function FindItem(itemName, room)
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") and child.Name == "Model" then
            local items = child:FindFirstChild("Items")
            if items then
                local item = items:FindFirstChild(itemName)
                if item then
                    local pp = item:FindFirstChildOfClass("ProximityPrompt")
                    if pp then return pp end
                end
            end
        end
    end
    if room then
        for _, desc in ipairs(room:GetDescendants()) do
            if desc.Name == itemName then
                local pp = desc:FindFirstChild("PP")
                if pp and pp:IsA("ProximityPrompt") then
                    return pp
                end
            end
        end
    end
    return nil
end
local function Func_AutoCheckIn()
    while Toggles.AutoCheckIn.Value do
        task.wait()
        FireEnabledCheckInPP()
        for _, npc in ipairs(NPCsFolder:GetChildren()) do
        task.wait()
            if not Toggles.AutoCheckIn.Value then break end
            local npcPP = npc:FindFirstChild("PP")
            if npc:IsA("Model") and npc:GetAttribute("CompletedCheckIn") == nil and not Shared.RejectedNpcs[npc] and not IsAnomalyNPC(npc) then
                if npc:GetAttribute("Skinwalker") then
                    task.wait()
                    RejectNPC(npc)
                    Shared.RejectedNpcs[npc] = true
                elseif npc:GetAttribute("CoffeeArcDay") ~= nil and npcPP and npcPP.Enabled then
                    if CoffeeMachineStatus.Text == COFFEE_READY_TEXT then
                        FirePP(CoffeeMachinePP, true)
                        FirePP(npcPP, true)
                        task.wait()
                    end
                elseif npcPP and npcPP.Enabled then
                    FirePP(npcPP, true)
                    task.wait()
                end
            end
            local faintedPP = npc:FindFirstChild("FaintedPP", true)
            if faintedPP and faintedPP.Enabled then
                task.wait()
                FirePP(faintedPP, true)
                notyuri("[AutoCheckIn]", npc.Name, "fainted - fired FaintedPP")
            end
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            local counter = hrp and hrp:FindFirstChild("Counter")
            if counter and counter:GetAttribute("Description") ~= nil and counter:GetAttribute("TimeLeft") ~= nil then
                for _, desc in ipairs(npc:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") and desc.Enabled then
                        FirePP(desc, true)
                        notyuri("[AutoCheckIn]", npc.Name, "Counter active - fired", desc:GetFullName())
                        break
                    end
                end
            end
            local firePP = npc:FindFirstChild("FirePP", true)
            if firePP and firePP.Enabled then
                task.wait()
                local ointmentPP = FindItem("Ointment", nil)
                if ointmentPP then
                    FirePP(ointmentPP, true)
                end
                FirePP(firePP, true)
                notyuri("[AutoCheckIn]", npc.Name, "on fire - fired FirePP")
            end
        end
        task.wait(0.5)
    end
end
if game.PlaceId == 78515283254292 then
    local function Func_AutoJoin()
        local Rooms = workspace:FindFirstChild("Rooms")
        if not Rooms then
            notyuri("[AutoJoin]", "Rooms folder not found")
            return
        end
        while Toggles.AutoJoin.Value do
            local joined = false
            for _, room in ipairs(Rooms:GetChildren()) do
                local touch = room:FindFirstChild("Touch")
                local sign  = room:FindFirstChild("Sign")
                local label = sign
                    and sign:FindFirstChild("PlayerCount")
                    and sign.PlayerCount:FindFirstChild("UI")
                    and sign.PlayerCount.UI:FindFirstChild("Label")
                if touch and label then
                    local countStr = label.Text:match("^(%d+)/")
                    local count = countStr and tonumber(countStr) or nil
                    if count and count == 0 then
                        notyuri("[AutoJoin]", "Joining", room.Name)
                        FireTI(touch)
                        task.wait()
                        if Remotes.Quickstart then
                            Remotes.SkipDialogue:FireServer(true)
                            task.wait()
                            Remotes.Quickstart:FireServer()
                            notyuri("[AutoJoin]", "Quickstart fired for", room.Name)
                        else
                            notyuri("[AutoJoin]", "Quickstart remote not found")
                        end
                        joined = true
                        break
                    end
                end
            end
            if not joined then
                notyuri("[AutoJoin]", "No empty rooms found, retrying...")
            end
            task.wait(.5)
        end
    end
    TB_Tabs.Autofarm.T1:AddToggle("AutoJoin", { Text = "Auto Join Room", Default = false })
    Toggles.AutoJoin:OnChanged(function(state)
        Thread("AutoJoin", Func_AutoJoin, state)
    end)
end
TB_Tabs.Autofarm.T1:AddToggle("AutoCheckIn", { Text = "Auto Check In", Default = false })
Toggles.AutoCheckIn:OnChanged(function(state)
    Thread("AutoCheckIn", Func_AutoCheckIn, state)
    UpdateBodyLock()
end)
local TrashPP = GetObject(workspace, "Trash.PP")
local function IsInProcess(room)
    local minigame = room:FindFirstChild("Minigame")
    if not minigame then return false end
    local inv = minigame:FindFirstChild("inv", true)
    if not inv then return false end
    local hasChecked = false
    local hasUnchecked = false
    for _, frame in ipairs(inv:GetChildren()) do
        if frame:IsA("Frame") then
            local check = frame:FindFirstChild("check")
            if check and check.Visible then
                hasChecked = true
            else
                hasUnchecked = true
            end
        end
    end
    return hasChecked and hasUnchecked
end
local function ProcessMedicalRoom(room)
    local minigame = room:FindFirstChild("Minigame")
    if not minigame then return end
    local inv = minigame:FindFirstChild("inv", true)
    if inv then
        for _, frame in ipairs(inv:GetChildren()) do
            if not frame:IsA("Frame") then continue end
            local check = frame:FindFirstChild("check")
            if check and check.Visible then continue end
            local itemName = frame.Name
            local char = Plr.Character
            local inChar = char and char:FindFirstChild(itemName)
            local inBackpack = Plr.Backpack:FindFirstChild(itemName)
            if inBackpack and not inChar then
                inBackpack.Parent = char
            elseif not inChar then
                local totalItems = 0
                for _, t in ipairs(char:GetChildren()) do
                    if t:IsA("Tool") or t:IsA("HopperBin") then totalItems += 1 end
                end
                for _, t in ipairs(Plr.Backpack:GetChildren()) do
                    if t:IsA("Tool") or t:IsA("HopperBin") then totalItems += 1 end
                end
                if totalItems >= 3 then continue end
                local itemPP = FindItem(itemName, room)
                if itemPP then
                    FirePP(itemPP, true)
                end
            end
        end
    end
    for _, desc in ipairs(minigame:GetDescendants()) do
        if not (desc:IsA("ProximityPrompt") and desc.Enabled) then continue end
        if desc.Name == "PP" and desc.Parent.Name == "Monitor" then continue end
        local parentName = desc.Parent and desc.Parent.Name
        if parentName and Cures[parentName] then continue end
        FirePP(desc, true)
        task.wait()
    end
    for _, npc in ipairs(NPCsFolder:GetChildren()) do
        if npc:IsA("Model") and npc:GetAttribute("DesignatedRoom") == room.Name then
            local pp = npc:FindFirstChild("PP")
            if pp and pp:IsA("ProximityPrompt") and pp.Enabled then
                FirePP(pp, true)
                task.wait()
            end
        end
    end
end
local function Func_MaxSanity()
    while Toggles.MaxSanity.Value do
        task.wait()
        local current = Plr:GetAttribute("Sanity") or 100
        if current < 100 then
            local n = 100 - current
            Remotes.PlayerLostSanity:FireServer(-n)
        end
    end
end
TB_Tabs.Autofarm.T1:AddToggle("MaxSanity", { Text = "Always Max Sanity", Default = false })
Toggles.MaxSanity:OnChanged(function(state)
    Thread("MaxSanity", Func_MaxSanity, state)
end)
local function DoColorsMinigame(enable)
    if not enable then
        Cleanup(Shared.ColorMatch)
        Shared.ColorRunning = false
        return
    end
    if Shared.ColorRunning then return end
    Shared.ColorRunning = true
    local function cleanup()
        Cleanup(Shared.ColorMatch)
        Shared.ColorRunning = false
    end
    local emergencyFolder = RoomsFolder:FindFirstChild("Emergency")
    local room6 = emergencyFolder and emergencyFolder:FindFirstChild("Room6")
    local room6Minigame = room6 and room6:FindFirstChild("Minigame")
    if not room6Minigame then cleanup() return end
    local ok, notice = pcall(function()
        return room6Minigame.xrayMonitor.Screen.UI.Action.notice
    end)
    if not ok or not notice then cleanup() return end
    local colorsFolder = room6Minigame:FindFirstChild("Colors")
    if not colorsFolder then cleanup() return end
    local buttons = {}
    for _, desc in ipairs(colorsFolder:GetDescendants()) do
        if desc:IsA("BasePart") and desc.Name == "Button" then
            buttons[#buttons + 1] = desc
        end
    end
    local ColorSeq = {}
    local ColorRep = false
    local lastChangeTime = tick()
    local function ButtLab(btn)
        local ui = btn:FindFirstChild("ui")
        if ui then
            local tl = ui:FindFirstChild("TextLabel")
            if tl then return tl.Text end
        end
        return "?"
    end
    local function DoReplay()
        if ColorRep or #ColorSeq == 0 then return end
        ColorRep = true
        local seq = ColorSeq
        ColorSeq = {}
        notyuri("[AutoColor] replaying", #seq, "buttons")
        task.spawn(function()
            for i, b in ipairs(seq) do
                if not Shared.ColorRunning then break end
                local cd = b:FindFirstChild("ClickDetector")
                if not cd then
                    notyuri("[AutoColor] no ClickDetector on button", i, "=", ButtLab(b))
                else
                    FireCD(cd)
                    notyuri("[AutoColor] fired", i, "=", ButtLab(b))
                    task.wait(0.5)
                end
            end
            notyuri("[AutoColor] replay done")
            ColorRep = false
        end)
    end
    for _, btn in ipairs(buttons) do
        local defaultColor = btn.Color
        local conn = btn:GetPropertyChangedSignal("Color"):Connect(function()
            if ColorRep then return end
            if btn.Color == defaultColor then
                return
            end
            lastChangeTime = tick()
            ColorSeq[#ColorSeq + 1] = btn
            notyuri("[AutoColor] recorded", #ColorSeq, "=", ButtLab(btn))
        end)
        Shared.ColorMatch[#Shared.ColorMatch + 1] = conn
    end
    while Shared.ColorRunning and notice and notice.Parent do
        task.wait(0.1)
        if not ColorRep and #ColorSeq > 0 and (tick() - lastChangeTime) >= 2 then
            DoReplay()
        end
    end
    cleanup()
end
local function DoHeartbeatMinigame(enable)
    if enable then
        Shared.HeartbeatConn = Remotes.StartHeartbeat.OnClientEvent:Connect(function(sessionId)
            task.wait(0.1)
            Remotes.CompleteHeartbeat:FireServer(sessionId, true)
        end)
    else
        if Shared.HeartbeatConn then
            Shared.HeartbeatConn:Disconnect()
            Shared.HeartbeatConn = nil
        end
    end
end
local function Func_AutoCure()
    DoHeartbeatMinigame(true)
    task.spawn(DoColorsMinigame, true)
    while Toggles.AutoCure.Value do
        task.wait(.1)
        for _, npc in ipairs(NPCsFolder:GetChildren()) do
            task.wait()
            if not Toggles.AutoCure.Value then break end
            if npc:IsA("Model") and npc:GetAttribute("TreatedBy") == nil then
                local npcPP = npc:FindFirstChild("PP")
                if npcPP and npcPP.Enabled and npc:GetAttribute("InBed") then
                    FirePP(npcPP, true)
                end
                local firePP = npc:FindFirstChild("FirePP")
                if firePP and firePP.Enabled then
                    FirePP(OintmentPP, true)
                    task.wait(0.1)
                    FirePP(firePP, true)
                    notyuri("[AutoCure]", npc.Name, "on fire - grabbed ointment and treated burns")
                end
            end
        end
        local ItemsNeeded = {}
        for _, roomFolder in ipairs(RoomsFolder:GetChildren()) do
            for _, room in ipairs(roomFolder:GetChildren()) do
                local minigame = room:FindFirstChild("Minigame")
                local inv = minigame and minigame:FindFirstChild("inv", true)
                if inv then
                    for _, frame in ipairs(inv:GetChildren()) do
                        if frame:IsA("Frame") then
                            local check = frame:FindFirstChild("check")
                            if not (check and check.Visible) then
                                if not ItemsNeeded[frame.Name] then
                                    ItemsNeeded[frame.Name] = {}
                                end
                                table.insert(ItemsNeeded[frame.Name], room.Name)
                            end
                        end
                    end
                end
            end
        end
        if TrashPP then
            local char = Plr.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if (tool:IsA("Tool") or tool:IsA("HopperBin")) and not ItemsNeeded[tool.Name] then
                        FirePP(TrashPP, true)
                    end
                end
            end
            for _, tool in ipairs(Plr.Backpack:GetChildren()) do
                if (tool:IsA("Tool") or tool:IsA("HopperBin")) and not ItemsNeeded[tool.Name] then
                    local char2 = Plr.Character
                    if char2 then
                        tool.Parent = char2
                        task.wait(0.05)
                        FirePP(TrashPP, true)
                    end
                end
            end
        end
        for _, roomFolder in ipairs(RoomsFolder:GetChildren()) do
        task.wait()
            for _, room in ipairs(roomFolder:GetChildren()) do
                if not Toggles.AutoCure.Value then break end
                if IsInProcess(room) then
                    ProcessMedicalRoom(room)
                end
            end
        end
        for _, roomFolder in ipairs(RoomsFolder:GetChildren()) do
        task.wait()
            for _, room in ipairs(roomFolder:GetChildren()) do
                if not Toggles.AutoCure.Value then break end
                if not IsInProcess(room) then
                    ProcessMedicalRoom(room)
                end
            end
        end
        if not Shared.ColorRunning then
            task.spawn(DoColorsMinigame, true)
        end
    end
    DoHeartbeatMinigame(false)
    DoColorsMinigame(false)
end
TB_Tabs.Autofarm.T1:AddToggle("AutoCure", { Text = "Auto Cure", Default = false })
Toggles.AutoCure:OnChanged(function(state)
    Thread("AutoCure", Func_AutoCure, state)
    UpdateBodyLock()
end)
local function Func_AutoRetry()
    while Toggles.AutoRetry.Value do
        task.wait(0.5)
        if game.Players:HasTag("GameOver") or Plr:HasTag("DeadPlayer") then
            Remotes.PlayAgainVote:FireServer()
        end
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoRetry", { Text = "Auto Retry", Default = false })
Toggles.AutoRetry:OnChanged(function(state)
    Thread("AutoRetry", Func_AutoRetry, state)
end)
TB_Tabs.Autofarm.T1:AddButton({
    Text = "Lesbian",
    Func = function()
        Remotes.PlayerLostSanity:FireServer(0/0)
    end,
})
local ShopItems = {}
local ShopLabel = {}
if Modules.ShopWares and Modules.ShopWares.Items then
    for _, item in ipairs(Modules.ShopWares.Items) do
        local label = item.Name .. " | " .. tostring(item.Cost)
        table.insert(ShopItems, label)
        ShopLabel[item.Description] = label
    end
end
TB_Tabs.Autofarm.T1:AddDropdown("SelectedItems", {
    Text = "Select Item(s)",
    Values = ShopItems,
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShopItem", { Text = "Auto Buy Item", Default = false })
local function Func_AutoBuyShopItem()
    while Toggles.AutoBuyShopItem.Value do
        task.wait(0.5)
        local selected = Options.SelectedItems.Value
        if not selected then continue end
        for _, slot in ipairs(ShopItemsFolder:GetChildren()) do
            if not Toggles.AutoBuyShopItem.Value then break end
            local descLabel = slot:FindFirstChild("ItemInfo")
                and slot.ItemInfo:FindFirstChild("UI")
                and slot.ItemInfo.UI:FindFirstChild("Description")
            if not descLabel then continue end
            local matchedLabel = ShopLabel[descLabel.Text]
            if matchedLabel and selected[matchedLabel] then
                local cost = tonumber(matchedLabel:match("|%s*(%d+)$"))
                if cost and Shared.LocalCash < cost then
                    continue
                end
                local pp = slot:FindFirstChild("ShopItemPP")
                if pp and pp:IsA("ProximityPrompt") then
                    notyuri("[AutoBuyShop] matched", matchedLabel, "on slot", slot.Name, "- firing PP")
                    FirePP(pp, true)
                    task.wait(0.5)
                end
            end
        end
    end
end
Toggles.AutoBuyShopItem:OnChanged(function(state)
    Thread("AutoBuyShopItem", Func_AutoBuyShopItem, state)
end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/AnimalHospital")
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
