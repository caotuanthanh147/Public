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
    EggList = {},
    EggMap = {},
    PotionList = {},
    PotionMap = {},
}
local Modules = {
    EggsConfig = GetSafeModule(RS:FindFirstChild("Configs"), "EggsConfig"),
    RebirthConfig = GetSafeModule(RS:FindFirstChild("Configs"), "RebirthConfig"),
    UpgradeConfig = GetSafeModule(RS:FindFirstChild("Configs"), "UpgradeConfig"),
    WorldUpgradesConfig = GetSafeModule(RS:FindFirstChild("Configs"), "WorldUpgradesConfig"),
    PotionsConfig = GetSafeModule(RS:FindFirstChild("Configs"), "PotionsConfig"),
    TrainToolConfig = GetSafeModule(RS:FindFirstChild("Configs"), "TrainToolConfig"),
    PlayerSkinConfig = GetSafeModule(RS:FindFirstChild("Configs"), "PlayerSkinConfig"),
    ContainersConfig = GetSafeModule(RS:FindFirstChild("Configs"), "ContainersConfig"),
}
local EggsConfig = Modules.EggsConfig
local RebirthConfig = Modules.RebirthConfig
local UpgradeConfig = Modules.UpgradeConfig
local WorldUpgradesConfig = Modules.WorldUpgradesConfig
local PotionsConfig = Modules.PotionsConfig
local TrainToolConfig = Modules.TrainToolConfig
local PlayerSkinConfig = Modules.PlayerSkinConfig
local ContainersConfig = Modules.ContainersConfig
local PlotUtils = require(RS.GameShared.PlotUtils)
local ContainerUtils = require(RS.GameShared.ContainerUtils)
local BrainrotUtils = require(RS.GameShared.BrainrotUtils)
local function GetKnit()
    if Remotes.Knit then return Remotes.Knit end
    local knitModule = RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("Knit")
    if not knitModule then
        notyuri("[GetKnit] Packages.Knit module not found")
        return nil
    end
    local ok, Knit = pcall(require, knitModule)
    if ok then
        Remotes.Knit = Knit
        return Knit
    end
    notyuri("[GetKnit] require(Knit) failed: " .. tostring(Knit))
    return nil
end
local function GetService(serviceName)
    local Knit = GetKnit()
    if not Knit then return nil end
    local ok, svc = pcall(Knit.GetService, serviceName)
    if not ok then
        notyuri(("[GetService] Knit.GetService(%s) failed: %s"):format(tostring(serviceName), tostring(svc)))
        return nil
    end
    return svc
end
local function GetController(controllerName)
    local Knit = GetKnit()
    if not Knit then return nil end
    local ok, ctrl = pcall(Knit.GetController, controllerName)
    if not ok then
        notyuri(("[GetController] Knit.GetController(%s) failed: %s"):format(tostring(controllerName), tostring(ctrl)))
        return nil
    end
    return ctrl
end
local function GetReplica()
    local rc = GetController("ReplicaController")
    if not rc then
        notyuri("[GetReplica] ReplicaController controller is nil")
        return nil
    end
    local ok, rep = pcall(rc.GetReplica, rc)
    if not ok then
        notyuri("[GetReplica] rc:GetReplica() failed: " .. tostring(rep))
        return nil
    end
    if not rep then
        notyuri("[GetReplica] rc:GetReplica() returned nil")
    end
    return rep
end
local function GetPlayerData()
    local rep = GetReplica()
    if not rep then return nil end
    if not rep.Data then
        notyuri("[GetPlayerData] replica exists but rep.Data is nil")
        return nil
    end
    return rep.Data
end
local function GetCash()
    local data = GetPlayerData()
    if data and data.Currencies then
        return tonumber(data.Currencies.Cash) or 0
    end
    return 0
end
local function GetGems()
    local data = GetPlayerData()
    if data and data.Currencies then
        return tonumber(data.Currencies.Gems) or 0
    end
    return 0
end
local function GetRebirths()
    local data = GetPlayerData()
    if data and data.Currencies then
        return tonumber(data.Currencies.Rebirths) or 0
    end
    return 0
end
local function GetRebirthCost()
    local rebirths = GetRebirths()
    if RebirthConfig and RebirthConfig.REBIRTH then
        local tier = RebirthConfig.REBIRTH[rebirths + 1]
        if tier and tier.Cost then
            return tonumber(tier.Cost.Cash) or 0
        end
    end
    return 0
end
local function CanRebirth()
    if not RebirthConfig or not RebirthConfig.REBIRTH then return false end
    local rebirths = GetRebirths()
    if rebirths >= #RebirthConfig.REBIRTH then return false end
    return GetCash() >= GetRebirthCost()
end
local function GetContainerUnlockIndex()
    local data = GetPlayerData()
    return data and tonumber(data.ContainerUnlockIndex) or 0
end
local function GetContainerCost()
    if not ContainersConfig or not ContainersConfig.containers then return nil end
    local index = GetContainerUnlockIndex()
    local tier = ContainersConfig.containers[index + 1]
    if tier then
        return tonumber(tier.price) or 0
    end
    return nil
end
local function CanUpgradeBase()
    local cost = GetContainerCost()
    if not cost then return false end
    return GetCash() >= cost
end
do
    if EggsConfig then
        for id, def in pairs(EggsConfig) do
            local label = tostring(id)
            table.insert(Tables.EggList, label)
            Tables.EggMap[label] = id
        end
        table.sort(Tables.EggList)
    end
    if #Tables.EggList == 0 then
        local fallback = {"Basic Egg", "Cactus Egg", "Ice Egg", "Monster Egg", "Golem Egg"}
        for _, id in ipairs(fallback) do
            table.insert(Tables.EggList, id)
            Tables.EggMap[id] = id
        end
    end
end
do
    if PotionsConfig then
        for id, def in pairs(PotionsConfig) do
            local label = tostring(def.name or id)
            table.insert(Tables.PotionList, label)
            Tables.PotionMap[label] = id
        end
        table.sort(Tables.PotionList)
    end
    if #Tables.PotionList == 0 then
        local fallback = {{"Cash", "Cash Potion"}, {"Train", "Train Potion"}, {"Luck", "Luck Potion"}}
        for _, p in ipairs(fallback) do
            local label = p[2] .. " [" .. p[1] .. "]"
            table.insert(Tables.PotionList, label)
            Tables.PotionMap[label] = p[1]
        end
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
            Autofarm2 = Tabs.Main:AddLeftTabbox(),
        },
        Right = {
            Autofarm = Tabs.Main:AddRightTabbox(),
            Autofarm2 = Tabs.Main:AddRightTabbox(),
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
local function Func_AutoEgg()
    while true do
        local label = Options.EggSelect.Value
        local eggId = label and Tables.EggMap[label]
        local amount = Options.EggAmountValue.Value or 1
        if eggId then
            local svc = GetService("EggService")
            if svc then
                pcall(function()
                    svc:OpenEgg(eggId, amount)
                end)
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoRebirth()
    while true do
        if CanRebirth() then
            local svc = GetService("RebirthService")
            if svc then
                pcall(function() svc:Rebirth() end)
                task.wait(2)
                pcall(function() svc:InitSkip() end)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoUpgradeBase()
    while true do
        if CanUpgradeBase() then
            local svc = GetService("ContainerService")
            if svc then
                pcall(function() svc:BuyContainer() end)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoSellAllBrainrots()
    while true do
        local svc = GetService("InventoryService")
        if svc then
            pcall(function() svc:SellAllBrainrots() end)
        end
        task.wait(5)
    end
end
local function Func_AutoEquip()
    while true do
        local svc = GetService("CombatService")
        if svc then
            pcall(function() svc:EquipBestSword() end)
        end
        task.wait(10)
    end
end
local function lookAt(target, part)
    if part and target then
        part.CFrame = CFrame.lookAt(part.Position, target.Position)
    end
end
local function FarmPos(primary)
    local distance = tonumber(Options.FarmDistance.Value) or 10
    if Options.FarmPosition.Value == "Above" then
        return Vector3.new(0, -distance, 0)
    elseif Options.FarmPosition.Value == "Behind" then
        return primary.CFrame.LookVector * -distance
    else 
        return Vector3.new(0, distance, 0)
    end
end
local function Func_AutoFight()
    Shared.FightRounds = Shared.FightRounds or 0
    if Shared.FightConnection then
        Shared.FightConnection:Disconnect()
        Shared.FightConnection = nil
    end
    while true do
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local targetX, targetY = viewportSize.X / 2, viewportSize.Y / 2
        local maxRounds = tonumber(Options.EndRound.Value) or 0
        if maxRounds > 0 and Shared.FightRounds >= maxRounds then
            notyuri(("[AutoFight] round threshold reached (%d/%d), resetting and restarting"):format(Shared.FightRounds, maxRounds))
            local svc = GetController("CombatController")
            if svc then
                local finishOk, finishErr = pcall(function() return svc:Finish() end)
                if not finishOk then
                    notyuri("[AutoFight] CombatController:Finish() failed: " .. tostring(finishErr))
                end
            end
            Shared.FightRounds = 0
            task.wait(1)
        end
        local svc = GetController("CombatController")
        if not svc then
            notyuri("[AutoFight] GetController(\"CombatController\") returned nil, skipping")
            task.wait(1)
        else
            local ok = true
            if Plr:GetAttribute("AutoRun") == false then
                ok = pcall(function()
                    local autorunSvc = GetController("AutorunController")
                    autorunSvc:Start()
                end)
                if not ok then
                    notyuri("[AutoFight] AutorunController:Start() failed")
                end
            else
                notyuri("[AutoFight] AutoRun already true, skipping AutorunController:Start()")
            end
            if not ok then
                notyuri("[AutoFight] AutorunController:Start() invoke failed")
                task.wait(1)
            else
                if not Shared.CombatAttackHooked then
                    local ok, err = pcall(function()
                        local combatSvc = GetService("CombatService")
                        local rawAttack = combatSvc.Attack
                        combatSvc.Attack = function(self, ...)
                            local result = rawAttack(self, ...)
                            Shared.LastCombatAttackResult = result
                            return result
                        end
                    end)
                    if ok then
                        Shared.CombatAttackHooked = true
                    else
                        notyuri("[AutoFight] failed to hook CombatService:Attack(): " .. tostring(err))
                    end
                end
                local finished = false
                local lastAttack = 0
                local lastBoss = nil
                Shared.FightConnection = RunService.Heartbeat:Connect(function()
                    if not Toggles.AutoFight.Value or finished then return end
                    local inCombat = Plr:GetAttribute("InCombat")
                    if inCombat == nil or inCombat == false then
                        notyuri("[AutoFight] InCombat is false/nil, retreating and restarting")
                        finished = true
                        return
                    end
                    local boss = workspace.Bosses:GetChildren()[1]
                    local char = Plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local primary = char and char.PrimaryPart
                    if not hrp then return end
                    if not boss or not primary then
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        return
                    end
                    if boss ~= lastBoss then
                        lastBoss = boss
                        Shared.FightRounds = Shared.FightRounds + 1
                        notyuri(("[AutoFight] new boss met (%d total): %s"):format(Shared.FightRounds, boss:GetFullName()))
                        local maxRounds = tonumber(Options.EndRound.Value) or 0
                        if maxRounds > 0 and Shared.FightRounds >= maxRounds then
                            notyuri(("[AutoFight] round threshold reached (%d/%d), ending fight to restart"):format(Shared.FightRounds, maxRounds))
                            finished = true
                            return
                        end
                    end
                    local bossPivot = boss:GetPivot()
                    hrp.CFrame = CFrame.new(bossPivot.Position - FarmPos(primary))
                    lookAt(bossPivot, hrp)
                    local now = os.clock()
                    if now - lastAttack < 0.25 then return end
                    lastAttack = now
                    Shared.LastCombatAttackResult = nil
                    local attackOk, attackErr = pcall(function()
                        Services.VirtualInputManager:SendMouseButtonEvent(targetX, targetY, 0, true, game, 1)
                        wait(0.01)
                        Services.VirtualInputManager:SendMouseButtonEvent(targetX, targetY, 0, false, game, 1)
                    end)
                    if not attackOk then
                        notyuri("[AutoFight] simulated click (VirtualInputManager) failed: " .. tostring(attackErr))
                        return
                    end
                    local result = Shared.LastCombatAttackResult
                    if result then
                        if result.transition then
                            if result.state == "BIOME_FINISH" or not result.nextBoss then
                                finished = true
                                notyuri("[AutoFight] biome finished")
                            else
                                notyuri("[AutoFight] transitioned to next boss")
                            end
                        end
                    end
                end)
                while Toggles.AutoFight.Value and not finished do
                    task.wait(0.1)
                end
                if Shared.FightConnection then
                    Shared.FightConnection:Disconnect()
                    Shared.FightConnection = nil
                end
                if not Toggles.AutoFight.Value then
                    break
                end
            end
        end
        if not Toggles.AutoFight.Value then
            break
        end
        task.wait(0.5)
    end
end
local function Func_AutoTraining()
    local svc = GetService("TrainingService")
    if not svc then
        return
    end
    local pendingBonus = nil
    local conn = nil
    local ok, connErr = pcall(function()
        conn = svc.SpawnBonus:Connect(function(bonus)
            pendingBonus = bonus
        end)
    end)
    if not ok then
        return
    end
    while true do
        if pendingBonus ~= nil then
            local bonus = pendingBonus
            pendingBonus = nil
            pcall(function() svc:ClaimBonus(bonus) end)
        end
        task.wait(0.1)
    end
end
local function Func_AutoDummy()
    while true do
        if TrainToolConfig and TrainToolConfig.TRAIN_TOOLS then
            local data = GetPlayerData()
            if data then
                local owned = data.OwnedTrainTools or {}
                local equipped = data.EquippedTrainTool
                local cash = GetCash()
                local bestOwnedId, bestOwnedOrder = nil, -math.huge
                for id, def in pairs(TrainToolConfig.TRAIN_TOOLS) do
                    if owned[id] then
                        local order = def.layoutOrder or 0
                        if order > bestOwnedOrder then
                            bestOwnedOrder = order
                            bestOwnedId = id
                        end
                    end
                end
                if bestOwnedId and bestOwnedId ~= equipped then
                    local svc = GetService("TrainingService")
                    if svc then
                        pcall(function() svc:EquipTrainTool(bestOwnedId) end)
                    end
                else
                    local bestId, bestOrder = nil, -math.huge
                    for id, def in pairs(TrainToolConfig.TRAIN_TOOLS) do
                        if def.cost and not owned[id] and def.cost <= cash then
                            local order = def.layoutOrder or 0
                            if order > bestOrder then
                                bestOrder = order
                                bestId = id
                            end
                        end
                    end
                    if bestId then
                        local svc = GetService("TrainingService")
                        if svc then
                            pcall(function() svc:BuyTrainTool(bestId) end)
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoAura()
    while true do
        if PlayerSkinConfig then
            local data = GetPlayerData()
            if data then
                local owned = data.OwnedSkins or {}
                local equipped = data.EquippedPlayerSkin
                local cash = GetCash()
                local bestOwnedId, bestOwnedOrder = nil, -math.huge
                for id, def in pairs(PlayerSkinConfig) do
                    if owned[id] then
                        local order = def.layoutOrder or 0
                        if order > bestOwnedOrder then
                            bestOwnedOrder = order
                            bestOwnedId = id
                        end
                    end
                end
                if bestOwnedId and bestOwnedId ~= equipped then
                    local svc = GetService("SkinService")
                    if svc then
                        pcall(function() svc:EquipSkin(bestOwnedId) end)
                    end
                else
                    local bestId, bestOrder = nil, -math.huge
                    for id, def in pairs(PlayerSkinConfig) do
                        if def.cost and not owned[id] and def.cost <= cash then
                            local order = def.layoutOrder or 0
                            if order > bestOrder then
                                bestOrder = order
                                bestId = id
                            end
                        end
                    end
                    if bestId then
                        local svc = GetService("SkinService")
                        if svc then
                            pcall(function() svc:BuySkin(bestId) end)
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoClaimDaily()
    while true do
        local svc = GetService("DailyRewardService")
        if svc then
            for i = 1, 7 do
                pcall(function() svc:ClaimReward(i) end)
                task.wait(0.2)
            end
        end
        task.wait(60)
    end
end
local function Func_AutoClaimDisc()
    while true do
        local svc = GetService("DiscService")
        if svc then
            pcall(function() svc:GetReward() end)
        end
        task.wait(5)
    end
end
local function Func_AutoClaimFreeShop()
    while true do
        local svc = GetService("FreeShopService")
        if svc then
            pcall(function() svc:Claim() end)
        end
        task.wait(60)
    end
end
local function Func_AutoPotion()
    while true do
        local label = Options.PotionSelect.Value
        local potionId = label and Tables.PotionMap[label]
        if potionId then
            local svc = GetService("PotionService")
            if svc then
                pcall(function() svc:UsePotion(potionId) end)
            end
        end
        task.wait(5)
    end
end
local function Func_AutoSpinWheel()
    while true do
        local svc = GetService("SpinWheelService")
        if svc then
            pcall(function() svc:SpinWheel(true) end)
        end
        task.wait(2)
    end
end
local function Func_AutoWorldUpgrade()
    while true do
        if WorldUpgradesConfig then
            local data = GetPlayerData()
            local owned = data and data.WorldUpgrades
            local gems = GetGems()
            local svc = GetService("WorldUpgradesService")
            if svc then
                for id, def in pairs(WorldUpgradesConfig) do
                    local alreadyOwned = owned and table.find(owned, id)
                    if not alreadyOwned and def.Cost and def.Cost.Name == "Gems" then
                        local cost = tonumber(def.Cost.Amount) or math.huge
                        if gems >= cost then
                            pcall(function() svc:BuyUpgrade(id) end)
                            gems = gems - cost
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoClaimSeasonPass()
    while true do
        local svc = GetService("SeasonPassService")
        if svc then
            pcall(function() svc:ClaimPassReward(1, 1) end)
        end
        task.wait(10)
    end
end
local function Func_AutoCollect()
    while true do
        local containers = PlotUtils.GetContainers(Plr)
        if containers then
            for _, container in ipairs(containers) do
                local collectionPad = container:FindFirstChild("Collection") and container.Collection:FindFirstChild("CollectionPad")
                if collectionPad then
                    FireTI(collectionPad)
                end
            end
        end
        task.wait(1)
    end
end
local BrainrotEntity = require(RS.Entities.BrainrotEntity)
local function GetCPS(container)
    local innerModel = ContainerUtils.GetInnerModel(container)
    if not innerModel then
        return nil
    end
    local brainrotType = innerModel:GetAttribute("BrainrotType")
    if not brainrotType then
        return nil
    end
    local mutation = innerModel:GetAttribute("Mutation")
    local level = innerModel:GetAttribute("BrainrotLevel")
    local rawTraits = innerModel:GetAttribute("BrainrotTraits")
    local traits = rawTraits and HttpService:JSONDecode(rawTraits) or nil
    local placedEntity = BrainrotEntity.new(brainrotType, mutation, traits, level)
    return BrainrotUtils.GetCashPerSecondBase(placedEntity)
end
local function SortValue()
    local containers = PlotUtils.GetContainers(Plr)
    if not containers then return nil end
    local result = {}
    for _, container in ipairs(containers) do
        local occupied = ContainerUtils.ContainerHasModel(container)
        local entry = { container = container, occupied = occupied }
        if occupied then
            entry.value = GetCPS(container)
        end
        table.insert(result, entry)
    end
    table.sort(result, function(a, b)
        if a.occupied ~= b.occupied then
            return not a.occupied
        end
        if not a.occupied then
            return false
        end
        return (a.value or 0) < (b.value or 0)
    end)
    return result
end
local function SortInv()
    local data = GetPlayerData()
    local inventory = data and data.Inventory
    if not inventory then return nil end
    local sorted = {}
    for id, item in pairs(inventory) do
        if item.itemType == "Brainrot" and item.innerEntity then
            local cashPerSec = BrainrotUtils.GetCashPerSecondBase(item.innerEntity)
            table.insert(sorted, { id = id, value = cashPerSec })
        end
    end
    table.sort(sorted, function(a, b) return (a.value or 0) > (b.value or 0) end)
    return sorted
end
local function Func_AutoPlace()
    while true do
        local containers = SortValue()
        if containers then
            local inventory = SortInv()
            if inventory then
                local used = {}
                local svc = GetService("ContainerService")
                for _, entry in ipairs(containers) do
                    local bestItem
                    for _, item in ipairs(inventory) do
                        if not used[item.id] then
                            bestItem = item
                            break
                        end
                    end
                    if bestItem and svc then
                        if not entry.occupied then
                            pcall(function() svc:Place(bestItem.id, entry.container.Name) end)
                            used[bestItem.id] = true
                        elseif entry.value ~= nil and bestItem.value > entry.value then
                            pcall(function() svc:SwapBrainrot(bestItem.id, entry.container.Name) end)
                            used[bestItem.id] = true
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoUpgrade()
    while true do
        local containers = PlotUtils.GetContainers(Plr)
        if containers then
            local svc = GetService("ContainerService")
            if svc then
                local maxLevel = tonumber(Options.UpgradeLevel.Value)
                for _, container in ipairs(containers) do
                    if ContainerUtils.ContainerHasModel(container) then
                        local innerModel = ContainerUtils.GetInnerModel(container)
                        local level = innerModel and innerModel:GetAttribute("BrainrotLevel")
                        if level and (not maxLevel or level < maxLevel) then
                            pcall(function() svc:UpgradeBrainrot(container.Name) end)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false, Callback = function(val) Thread("AutoRebirth", Func_AutoRebirth, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradeBase", { Text = "Auto Upgrade Base", Default = false, Callback = function(val) Thread("AutoUpgradeBase", Func_AutoUpgradeBase, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoEgg", { Text = "Auto Egg", Default = false, Callback = function(val) Thread("AutoEgg", Func_AutoEgg, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip Sword", Default = false, Callback = function(val) Thread("AutoEquip", Func_AutoEquip, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoFight", { Text = "Auto Fight", Default = false, Callback = function(val) Thread("AutoFight", Func_AutoFight, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false, Callback = function(val) Thread("AutoUpgrade", Func_AutoUpgrade, val) end })
TB_Tabs.Autofarm2.T1:AddInput("UpgradeLevel", {
    AllowNull = true,
    Finished    = false,
    Text        = "Upgrade Level",
})
TB_Tabs.Autofarm2.T1:AddInput("FarmDistance", {
    AllowNull = true,
    Finished    = false,
    Text        = "Range",
    Default     = "12",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoTraining", { Text = "Auto Training", Default = false, Callback = function(val) Thread("AutoTraining", Func_AutoTraining, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoDummy", { Text = "Auto Dummy", Default = false, Callback = function(val) Thread("AutoDummy", Func_AutoDummy, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoAura", { Text = "Auto Aura", Default = false, Callback = function(val) Thread("AutoAura", Func_AutoAura, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPotion", { Text = "Auto Potion", Default = false, Callback = function(val) Thread("AutoPotion", Func_AutoPotion, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoWorldUpgrade", { Text = "Auto World Upgrades", Default = false, Callback = function(val) Thread("AutoWorldUpgrade", Func_AutoWorldUpgrade, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect", Default = false, Callback = function(val) Thread("AutoCollect", Func_AutoCollect, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false, Callback = function(val) Thread("AutoPlace", Func_AutoPlace, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("FarmPosition", { Text = "Fight Position", Values = {"Below", "Above", "Behind"}, Default = "Below" })
TB_Tabs.Autofarm2.T1:AddInput("EndRound", { Text = "Rounds to End", Default = "0" })
TB_Tabs.Autofarm2.T1:AddDropdown("EggSelect", { Text = "Select Egg", Values = Tables.EggList, Default = Tables.EggList[1] or "" })
TB_Tabs.Autofarm2.T1:AddInput("EggAmount", { Text = "Hatch Amount", Default = "1" })
TB_Tabs.Autofarm2.T1:AddDropdown("PotionSelect", { Text = "Select Potion", Values = Tables.PotionList, Default = Tables.PotionList[1] or "" })
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
SaveManager:SetFolder("Yuri/Dumpling")
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