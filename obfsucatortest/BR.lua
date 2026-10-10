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
    if not parent then return nil end
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local Remotes = {
    PurchaseBuild = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("ShopService") and RS.Remotes.ShopService:FindFirstChild("PurchaseBuild")),
    PurchaseMonster = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("ShopService") and RS.Remotes.ShopService:FindFirstChild("PurchaseMonster")),
    GetShopSnapshot = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("ShopService") and RS.Remotes.ShopService:FindFirstChild("GetShopSnapshot")),
    GetCash = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("EconomyService") and RS.Remotes.EconomyService:FindFirstChild("GetCash")),
    SellAll = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("SellService") and RS.Remotes.SellService:FindFirstChild("SellAll")),
    PurchaseUpgrade = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("UpgradeService") and RS.Remotes.UpgradeService:FindFirstChild("PurchaseUpgrade")),
    RequestEnter = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("MazeTestService") and RS.Remotes.MazeTestService:FindFirstChild("RequestEnter")),
    RequestExit = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("MazeTestService") and RS.Remotes.MazeTestService:FindFirstChild("RequestExit")),
    PlaceBuild = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("BuildService") and RS.Remotes.BuildService:FindFirstChild("PlaceBuild")),
    GetInventorySnapshot = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("InventoryService") and RS.Remotes.InventoryService:FindFirstChild("GetInventorySnapshot")),
    PlaceMonsterSpawn = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("MonsterService") and RS.Remotes.MonsterService:FindFirstChild("PlaceMonsterSpawn")),
    GetMonsterSnapshot = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("MonsterService") and RS.Remotes.MonsterService:FindFirstChild("GetMonsterSnapshot")),
    RemoveBuild = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("BuildService") and RS.Remotes.BuildService:FindFirstChild("RemoveBuild")),
}
local Modules = {
    BuildDefinitions = GetSafeModule(RS:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("BuildService"), "BuildDefinitions"),
    MonsterConfig = GetSafeModule(RS:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("MonsterService"), "MonsterConfig"),
    BaseConfig = GetSafeModule(RS:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("BaseService"), "BaseConfig"),
    GridMath = GetSafeModule(RS:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("BuildService"), "GridMath"),
    DirectionUtils = GetSafeModule(RS:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("MazeGraphService"), "DirectionUtils"),
    UpgradeConfig = GetSafeModule(RS:WaitForChild("Shared"):WaitForChild("Services"):WaitForChild("UpgradeService"), "UpgradeConfig"),
}
local Flags = {}
local Shared = {}
local Tables = {
    BuildList = {},
    BuildMap = {},
    MonsterList = {},
    MonsterMap = {},
    CombinedList = {},
    CombinedMap = {},
    ItemMeta = {},
}
local function InvokeRemote(remote, ...)
    if not remote then return nil end
    local args = {...}
    local result = nil
    local ok = pcall(function()
        result = remote:InvokeServer(unpack(args))
    end)
    return ok and result or nil
end
local function FireRemote(remote, ...)
    if not remote then return end
    local args = {...}
    pcall(function()
        remote:FireServer(unpack(args))
    end)
end
do
    table.insert(Tables.BuildList, "Any")
    Tables.BuildMap["Any"] = "Any"
    if Modules.BuildDefinitions and type(Modules.BuildDefinitions.GetAll) == "function" then
        local builds = Modules.BuildDefinitions.GetAll()
        if type(builds) == "table" then
            for id, def in pairs(builds) do
                if type(def) == "table" and def.Id and def.DisplayName then
                    local label = tostring(def.DisplayName)
                    table.insert(Tables.BuildList, label)
                    Tables.BuildMap[label] = def.Id
                end
            end
        end
        table.sort(Tables.BuildList)
    end
end
do
    table.insert(Tables.MonsterList, "Any")
    Tables.MonsterMap["Any"] = "Any"
    if Modules.MonsterConfig and type(Modules.MonsterConfig.GetDefinitions) == "function" then
        local monsters = Modules.MonsterConfig.GetDefinitions()
        if type(monsters) == "table" then
            for _, def in ipairs(monsters) do
                if type(def) == "table" and def.Id and def.DisplayName then
                    local label = tostring(def.DisplayName)
                    table.insert(Tables.MonsterList, label)
                    Tables.MonsterMap[label] = def.Id
                end
            end
        end
    end
end
do
    table.insert(Tables.CombinedList, "Any")
    Tables.CombinedMap["Any"] = "Any"
    for _, label in ipairs(Tables.BuildList) do
        if label ~= "Any" then
            table.insert(Tables.CombinedList, label)
            Tables.CombinedMap[label] = Tables.BuildMap[label]
            Tables.ItemMeta[label] = { kind = "Build" }
        end
    end
    for _, label in ipairs(Tables.MonsterList) do
        if label ~= "Any" then
            table.insert(Tables.CombinedList, label)
            Tables.CombinedMap[label] = Tables.MonsterMap[label]
            Tables.ItemMeta[label] = { kind = "Monster" }
        end
    end
    table.sort(Tables.CombinedList, function(a, b)
        if a == "Any" then return true end
        if b == "Any" then return false end
        return a < b
    end)
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
    Build = Window:AddTab("Build"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local A1 = Tabs.Build:AddLeftGroupbox("Build")
local A2 = Tabs.Build:AddRightGroupbox("Material")
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
local function GetCash()
    local result = InvokeRemote(Remotes.GetCash)
    if type(result) == "table" and type(result.Cash) == "number" then
        return result.Cash
    end
    return nil
end
local function GetShopItems(shopKind)
    local result = InvokeRemote(Remotes.GetShopSnapshot, shopKind)
    if type(result) == "table" and type(result.Items) == "table" then
        return result.Items
    end
    return {}
end
local function BuildShopIndex(shopKind, idKey)
    local index = {}
    for _, item in ipairs(GetShopItems(shopKind)) do
        if type(item) == "table" and item[idKey] then
            index[item[idKey]] = item
        end
    end
    return index
end
local function CanAffordShopItem(shopItem, cash)
    if type(shopItem) ~= "table" then return false end
    if shopItem.IsAvailable ~= true then return false end
    if shopItem.IsLocked == true then return false end
    if type(shopItem.Price) ~= "number" then return false end
    if not shopItem.IsInfinite and (shopItem.Stock or 0) <= 0 then return false end
    if type(cash) == "number" and cash < shopItem.Price then return false end
    return true
end
local function Func_AutoBuy()
    while true do
        local cash = GetCash()
        local buildIndex = BuildShopIndex("Builds", "ItemId")
        local monsterIndex = BuildShopIndex("Monsters", "ItemId")
        local selected = Options.BuySelected.Value
        local wantsAny = selected["Any"] == true
        if wantsAny then
            for itemId, shopItem in pairs(buildIndex) do
                if CanAffordShopItem(shopItem, cash) then
                    InvokeRemote(Remotes.PurchaseBuild, itemId)
                    task.wait(0.2)
                    cash = GetCash()
                end
            end
            for itemId, shopItem in pairs(monsterIndex) do
                if CanAffordShopItem(shopItem, cash) then
                    InvokeRemote(Remotes.PurchaseMonster, itemId)
                    task.wait(0.2)
                    cash = GetCash()
                end
            end
        else
            for label, active in pairs(selected) do
                if active and label ~= "Any" then
                    local meta = Tables.ItemMeta[label]
                    local id = Tables.CombinedMap[label]
                    if meta and id then
                        if meta.kind == "Build" then
                            local shopItem = buildIndex[id]
                            if CanAffordShopItem(shopItem, cash) then
                                InvokeRemote(Remotes.PurchaseBuild, id)
                                task.wait(0.2)
                                cash = GetCash()
                            end
                        elseif meta.kind == "Monster" then
                            local shopItem = monsterIndex[id]
                            if CanAffordShopItem(shopItem, cash) then
                                InvokeRemote(Remotes.PurchaseMonster, id)
                                task.wait(0.2)
                                cash = GetCash()
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoSell()
    while true do
        InvokeRemote(Remotes.SellAll)
        task.wait(5)
    end
end
local function Func_AutoEnterMaze()
    while true do
        FireRemote(Remotes.RequestEnter)
        task.wait(5)
    end
end
local MatLabel
local BUILD_SAVE_FOLDER = "Yuri/BYB/Build"
local function GetOwnedBase()
    local baseId = Plr:GetAttribute("BaseId")
    if typeof(baseId) ~= "number" then return nil end
    local island = workspace:FindFirstChild("Island")
    if not island then return nil end
    local bases = island:FindFirstChild("Bases")
    if not bases then return nil end
    return bases:FindFirstChild(("Base_%02d"):format(baseId))
end
local function GetPlots(base)
    local plots = {}
    if not base then return plots end
    local plotsFolder = base:FindFirstChild("Plots")
    if not plotsFolder then return plots end
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if plot.Name:match("^Plot_%d%d_%d%d$") then
            table.insert(plots, plot)
        end
    end
    return plots
end
local function GetPlacedCells(base)
    local cells = {}
    for _, plot in ipairs(GetPlots(base)) do
        local buildCells = plot:FindFirstChild("BuildCells")
        if buildCells then
            for _, cell in ipairs(buildCells:GetChildren()) do
                if cell:IsA("BasePart") and cell.Name:match("^Cell_%d+_%d+$") then
                    local buildId = cell:GetAttribute("BuildId")
                    if typeof(buildId) == "string" then
                        table.insert(cells, {
                            PlotName = plot.Name,
                            CellName = cell.Name,
                            BuildId = buildId,
                            Rotation = cell:GetAttribute("Rotation") or 0,
                            MonsterId = cell:GetAttribute("MonsterId"),
                            MazeDistanceFromEntrance = cell:GetAttribute("MazeDistanceFromEntrance"),
                        })
                    end
                end
            end
        end
    end
    return cells
end
local function CanAffordUpgrade()
    if not Modules.UpgradeConfig then return false end
    local level = Plr:GetAttribute(Modules.UpgradeConfig.LEVEL_ATTRIBUTE_NAME)
    if typeof(level) ~= "number" then return false end
    if level >= Modules.UpgradeConfig.MAX_LEVEL then return false end
    local nextDef = Modules.UpgradeConfig.GetNextDefinition(level)
    if not nextDef then return false end
    local base = GetOwnedBase()
    local ownedPlots = 0
    for _, plot in ipairs(GetPlots(base)) do
        if plot:GetAttribute("IsOpen") == true then
            ownedPlots = ownedPlots + 1
        end
    end
    if ownedPlots < nextDef.RequiredPlots then return false end
    local placedBuilds = #GetPlacedCells(base)
    if placedBuilds < nextDef.RequiredBuilds then return false end
    local cash = GetCash()
    if typeof(cash) ~= "number" or cash < nextDef.Price then return false end
    return true
end
local function Func_AutoUpgrade()
    while true do
        if CanAffordUpgrade() then
            InvokeRemote(Remotes.PurchaseUpgrade)
        end
        task.wait(2)
    end
end
local function Func_AutoExpand()
    while true do
        local base = GetOwnedBase()
        local cash = GetCash()
        if base and typeof(cash) == "number" then
            for _, plot in ipairs(GetPlots(base)) do
                if plot:GetAttribute("IsOpen") ~= true and plot:GetAttribute("IsAvailableForPurchase") == true then
                    local bounds = plot:FindFirstChild("Bounds")
                    local prompt = bounds and bounds:FindFirstChild("PlotPurchasePrompt")
                    if prompt and prompt:IsA("ProximityPrompt") and prompt:GetAttribute("IsPlotPurchasePrompt") == true then
                        local price = prompt:GetAttribute("Price")
                        if typeof(price) == "number" and cash >= price then
                            notyuri("[AutoExpand] buying", plot.Name, "price:", price, "cash:", cash)
                            FirePP(prompt, true)
                            task.wait(0.5)
                            cash = GetCash()
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end
local function GetSnapshot()
    local snapshot = InvokeRemote(Remotes.GetInventorySnapshot)
    if type(snapshot) ~= "table" then snapshot = {} end
    local buildInv = type(snapshot.BuildInventory) == "table" and snapshot.BuildInventory or {}
    local monsterInv = type(snapshot.MonsterInventory) == "table" and snapshot.MonsterInventory or {}
    return buildInv, monsterInv
end
local function GetInventory()
    local buildInv = GetSnapshot()
    return buildInv
end
local function GetMonsterInventory()
    local _, monsterInv = GetSnapshot()
    return monsterInv
end
local function GetItemCount(itemName, inv)
    inv = inv or GetInventory()
    local qty = inv[itemName]
    if type(qty) == "number" then return qty end
    return 0
end
-- Placement validation mirrors BuildController's canPlaceOnTarget/canConnectToMaze (client-side rule the server also enforces).
local function ParsePlotCoords(plotName)
    if not Modules.BaseConfig then return nil, nil end
    local a, b = string.match(plotName, Modules.BaseConfig.PLOT_NAME_PATTERN)
    if not a or not b then return nil, nil end
    return tonumber(a), tonumber(b)
end
local function ParseCellCoords(cellName)
    local a, b = string.match(cellName, "^Cell_(%d+)_(%d+)$")
    if not a or not b then return nil, nil end
    return tonumber(a), tonumber(b)
end
local function GetGlobalCellCoords(plotName, cellName)
    local plotX, plotY = ParsePlotCoords(plotName)
    local cellX, cellY = ParseCellCoords(cellName)
    if not plotX or not plotY or not cellX or not cellY then return nil, nil end
    return plotX * 2 + cellX, plotY * 2 + cellY
end
local function GetCellAtGlobal(base, gx, gz)
    if gx < 0 or gz < 0 then return nil end
    local plotX = math.floor(gx / 2)
    local plotZ = math.floor(gz / 2)
    local plotsFolder = base:FindFirstChild("Plots")
    if not plotsFolder then return nil end
    local plot = plotsFolder:FindFirstChild(("Plot_%02d_%02d"):format(plotX, plotZ))
    if not plot then return nil end
    local buildCells = plot:FindFirstChild("BuildCells")
    if not buildCells then return nil end
    local cell = buildCells:FindFirstChild(("Cell_%d_%d"):format(gx % 2, gz % 2))
    if not cell or not cell:IsA("BasePart") then return nil end
    return cell
end
local function GetCellOpenSides(cell)
    local buildId = cell:GetAttribute("BuildId")
    if type(buildId) ~= "string" then return nil end
    local def = Modules.BuildDefinitions and Modules.BuildDefinitions.Get(buildId)
    if not def then return nil end
    local rotation = cell:GetAttribute("Rotation")
    rotation = (type(rotation) == "number") and Modules.GridMath.NormalizeRotation(rotation) or 0
    return Modules.DirectionUtils.RotateSides(def.OpenSides, rotation)
end
local function CanUseEntranceCell(plotName, cellName, rotatedSides)
    if not Modules.BaseConfig then return false end
    for _, entry in ipairs(Modules.BaseConfig.NPC_ENTRANCE_CELLS) do
        if entry.PlotName == plotName and entry.CellName == cellName then
            local requiredSide = entry.RequiredOpenSide
            if not requiredSide or not Modules.DirectionUtils.IsDirection(requiredSide) then
                requiredSide = "N"
            end
            local hasSide = false
            for _, side in ipairs(rotatedSides) do
                if side == requiredSide then hasSide = true break end
            end
            return hasSide and #rotatedSides >= 2
        end
    end
    return false
end
local function CanConnectToMaze(base, plotName, cellName, rotatedSides)
    if CanUseEntranceCell(plotName, cellName, rotatedSides) then
        return true, "entrance cell"
    end
    local gx, gz = GetGlobalCellCoords(plotName, cellName)
    if not gx or not gz then
        return false, "failed to parse global coords for " .. tostring(plotName) .. "/" .. tostring(cellName)
    end
    for _, side in ipairs(rotatedSides) do
        local ox, oz = Modules.DirectionUtils.GetOffset(side)
        local neighbor = GetCellAtGlobal(base, gx + ox, gz + oz)
        if neighbor and neighbor:GetAttribute("MazeConnectedToEntrance") == true then
            local neighborSides = GetCellOpenSides(neighbor)
            if neighborSides then
                local opposite = Modules.DirectionUtils.GetOpposite(side)
                for _, neighborSide in ipairs(neighborSides) do
                    if neighborSide == opposite then
                        return true, nil
                    end
                end
            end
        end
    end
    return false, "no connected neighbor with matching open side"
end
-- Returns: canPlace(bool), reason(string), rotatedSides(table or nil)
local function CanPlaceOnTarget(base, plot, cell, buildId, rotation)
    if cell:GetAttribute("IsOccupied") == true then
        return false, "cell occupied"
    end
    if plot:GetAttribute("IsOpen") ~= true then
        return false, "plot not open (IsOpen ~= true)"
    end
    local def = Modules.BuildDefinitions and Modules.BuildDefinitions.Get(buildId)
    if not def then
        return false, "unknown BuildDefinitions entry for " .. tostring(buildId)
    end
    local normRotation = Modules.GridMath.NormalizeRotation(rotation or 0)
    if not def.CanRotate and normRotation ~= 0 then
        return false, "build cannot rotate but rotation ~= 0"
    end
    if not Modules.GridMath.IsSupportedRotation(normRotation) then
        return false, "unsupported rotation " .. tostring(normRotation)
    end
    local rotatedSides = Modules.DirectionUtils.RotateSides(def.OpenSides, normRotation)
    local canConnect, reason = CanConnectToMaze(base, plot.Name, cell.Name, rotatedSides)
    if not canConnect then
        return false, "not connected to maze: " .. tostring(reason)
    end
    return true, nil, rotatedSides
end
-- Returns: canPlace(bool), reason(string)
local function CanPlaceMonsterOnTarget(plot, cell)
    if plot:GetAttribute("IsOpen") ~= true then
        return false, "plot not open (IsOpen ~= true)"
    end
    if cell:GetAttribute("IsOccupied") ~= true then
        return false, "cell has no build (IsOccupied ~= true) - monsters can only spawn on built cells"
    end
    if cell:GetAttribute("MazeConnectedToEntrance") ~= true then
        return false, "cell not connected to maze entrance (MazeConnectedToEntrance ~= true)"
    end
    local depth = cell:GetAttribute("MazeDistanceFromEntrance")
    local safeDepth = Modules.MonsterConfig and Modules.MonsterConfig.SAFE_DEPTH_FROM_ENTRANCE or 2
    if type(depth) ~= "number" or depth < safeDepth then
        return false, "too close to entrance (MazeDistanceFromEntrance=" .. tostring(depth) .. ", need >= " .. tostring(safeDepth) .. ")"
    end
    if type(cell:GetAttribute("MonsterSpawnId")) == "string" then
        return false, "cell already has a monster (MonsterSpawnId set)"
    end
    return true, nil
end
local function DumpResult(result)
    if type(result) ~= "table" then
        return tostring(result)
    end
    local parts = {}
    for k, v in pairs(result) do
        table.insert(parts, tostring(k) .. "=" .. tostring(v))
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end
local function GetMonsterSlotInfo()
    local result = InvokeRemote(Remotes.GetMonsterSnapshot)
    if type(result) == "table" and type(result.SlotsUsed) == "number" and type(result.SlotLimit) == "number" then
        return result.SlotsUsed, result.SlotLimit
    end
    return nil, nil
end
local function Func_AutoPlace()
    while true do
        local base = GetOwnedBase()
        if not base then
            notyuri("[AutoPlace] no owned base found, skipping cycle")
            task.wait(1)
        else
            if not Modules.BaseConfig or not Modules.GridMath or not Modules.DirectionUtils then
                notyuri("[AutoPlace] missing required module(s): BaseConfig/GridMath/DirectionUtils - aborting")
                return
            end
            local plots = GetPlots(base)
            local selected = Options.PlaceSelected.Value
            local wantsAny = selected["Any"] == true
            local placedCount, skippedCount, closedPlotCount = 0, 0, 0
            local monsterSlotsUsed, monsterSlotLimit = GetMonsterSlotInfo()
            local monsterSlotsFull = monsterSlotsUsed and monsterSlotLimit and monsterSlotsUsed >= monsterSlotLimit
            for _, plot in ipairs(plots) do
                if plot:GetAttribute("IsOpen") ~= true then
                    closedPlotCount = closedPlotCount + 1
                else
                    local buildCells = plot:FindFirstChild("BuildCells")
                    if buildCells then
                        for _, cell in ipairs(buildCells:GetChildren()) do
                            if cell:IsA("BasePart") and cell.Name:match("^Cell_%d+_%d+$") then
                                if cell:GetAttribute("IsOccupied") ~= true then
                                    local buildId = nil
                                    if wantsAny then
                                        local inv = GetInventory()
                                        for itemName, qty in pairs(inv) do
                                            if type(qty) == "number" and qty > 0 then
                                                buildId = itemName
                                                break
                                            end
                                        end
                                    else
                                        for label, active in pairs(selected) do
                                            if active and label ~= "Any" then
                                                local meta = Tables.ItemMeta[label]
                                                if meta and meta.kind == "Build" then
                                                    buildId = Tables.CombinedMap[label]
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    if buildId then
                                        local rotation, canPlace, reason = nil, false, nil
                                        for _, tryRotation in ipairs({0, 90, 180, 270}) do
                                            local ok, why = CanPlaceOnTarget(base, plot, cell, buildId, tryRotation)
                                            if ok then
                                                rotation, canPlace = tryRotation, true
                                                break
                                            end
                                            reason = why
                                        end
                                        if canPlace then
                                            notyuri("[AutoPlace] placing", buildId, "at", plot.Name, cell.Name, "rot:", rotation)
                                            local result = InvokeRemote(Remotes.PlaceBuild, {
                                                BuildId = buildId,
                                                PlotName = plot.Name,
                                                CellName = cell.Name,
                                                Rotation = rotation,
                                            })
                                            if type(result) == "table" and result.Success == true then
                                                placedCount = placedCount + 1
                                            else
                                                skippedCount = skippedCount + 1
                                                notyuri("[AutoPlace] server rejected placement of", buildId, "at", plot.Name, cell.Name, "result:", DumpResult(result))
                                            end
                                        else
                                            skippedCount = skippedCount + 1
                                        end
                                    end
                                elseif cell:GetAttribute("IsOccupied") == true and not monsterSlotsFull then
                                    local monsterCanPlace, monsterReason = CanPlaceMonsterOnTarget(plot, cell)
                                    if not monsterCanPlace then
                                        skippedCount = skippedCount + 1
                                    else
                                        local monsterId = nil
                                        if wantsAny then
                                            local inv = GetMonsterInventory()
                                            for itemName, qty in pairs(inv) do
                                                if type(qty) == "number" and qty > 0 then
                                                    monsterId = itemName
                                                    break
                                                end
                                            end
                                        else
                                            for label, active in pairs(selected) do
                                                if active and label ~= "Any" then
                                                    local meta = Tables.ItemMeta[label]
                                                    if meta and meta.kind == "Monster" then
                                                        monsterId = Tables.CombinedMap[label]
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                        if monsterId then
                                            notyuri("[AutoPlace] placing monster", monsterId, "at", plot.Name, cell.Name)
                                            local result = InvokeRemote(Remotes.PlaceMonsterSpawn, {
                                                MonsterId = monsterId,
                                                PlotName = plot.Name,
                                                CellName = cell.Name,
                                            })
                                            if type(result) == "table" and result.Success == true then
                                                placedCount = placedCount + 1
                                            else
                                                skippedCount = skippedCount + 1
                                                notyuri("[AutoPlace] server rejected monster placement of", monsterId, "at", plot.Name, cell.Name, "result:", DumpResult(result))
                                            end
                                            -- Re-fetch live slot usage from the server rather than estimating locally.
                                            monsterSlotsUsed, monsterSlotLimit = GetMonsterSlotInfo()
                                            monsterSlotsFull = monsterSlotsUsed and monsterSlotLimit and monsterSlotsUsed >= monsterSlotLimit
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            notyuri("[AutoPlace] cycle done, plots:", #plots, "closed:", closedPlotCount, "placed:", placedCount, "skipped:", skippedCount, "monster slots:", tostring(monsterSlotsUsed), "/", tostring(monsterSlotLimit))
            task.wait(placedCount > 0 and 0.1 or 1)
        end
    end
end
local function Func_AutoPickup()
    while true do
        local base = GetOwnedBase()
        for _, plot in ipairs(GetPlots(base)) do
            local buildCells = plot:FindFirstChild("BuildCells")
            if buildCells then
                for _, cell in ipairs(buildCells:GetChildren()) do
                    if cell:IsA("BasePart") and cell.Name:match("^Cell_%d+_%d+$") and cell:GetAttribute("IsOccupied") == true then
                        local result = InvokeRemote(Remotes.RemoveBuild, {
                            PlotName = plot.Name,
                            CellName = cell.Name,
                        })
                        if type(result) == "table" and result.Success == true then
                            notyuri("[AutoPickup] removed", plot.Name, cell.Name)
                        else
                            notyuri("[AutoPickup] remove failed for", plot.Name, cell.Name, "result:", tostring(result))
                        end
                        task.wait()
                    end
                end
            end
        end
        task.wait()
    end
end
local function CopyBuildToJSON()
    local base = GetOwnedBase()
    if not base then return nil end
    local cells = GetPlacedCells(base)
    if #cells == 0 then return nil end
    local data = { version = 1, count = #cells, blocks = {} }
    for _, entry in ipairs(cells) do
        table.insert(data.blocks, {
            PlotName = entry.PlotName,
            CellName = entry.CellName,
            BuildId = entry.BuildId,
            Rotation = entry.Rotation,
            MonsterId = entry.MonsterId,
            MazeDistanceFromEntrance = entry.MazeDistanceFromEntrance,
        })
    end
    return HttpService:JSONEncode(data)
end
local function LoadBuildJSON(json)
    if not json or json == "" then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data) ~= "table" or type(data.blocks) ~= "table" then return nil end
    return data
end
local function ListBuildFiles()
    local files = {}
    if not Support.FileIO or not isfolder then return files end
    pcall(function()
        if not isfolder(BUILD_SAVE_FOLDER) then return end
        for _, name in ipairs(listfiles(BUILD_SAVE_FOLDER)) do
            if name:sub(-5) == ".json" then
                local short = name:match("([^/\\]+)%.json$")
                if short then table.insert(files, short) end
            end
        end
    end)
    table.sort(files)
    return files
end
local function GetBuildRequirements(data)
    local reqs = {}
    for _, entry in ipairs(data.blocks) do
        if entry.BuildId then
            reqs[entry.BuildId] = (reqs[entry.BuildId] or 0) + 1
        end
        if typeof(entry.MonsterId) == "string" then
            reqs[entry.MonsterId] = (reqs[entry.MonsterId] or 0) + 1
        end
    end
    return reqs
end
local function ComputeMissingMaterials(reqs)
    local buildInv, monsterInv = GetSnapshot()
    local missing = {}
    local parts = {}
    for itemName, need in pairs(reqs) do
        local have = (buildInv[itemName] or monsterInv[itemName]) or 0
        if have < need then
            local short = need - have
            missing[itemName] = short
            table.insert(parts, itemName .. "(x" .. short .. ")")
        end
    end
    table.sort(parts)
    local display
    if #parts == 0 then
        display = "Ready"
    else
        display = "Missing: " .. table.concat(parts, ", ")
    end
    return missing, display
end
local function GetAllBases()
    local out = {}
    local island = workspace:FindFirstChild("Island")
    local bases = island and island:FindFirstChild("Bases")
    local ourBase = GetOwnedBase()
    if not bases then return out end
    for _, base in ipairs(bases:GetChildren()) do
        local ownerName = "Unknown"
        pcall(function()
            local baseNum = base.Name:match("^Base_(%d+)$")
            if baseNum then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p:GetAttribute("BaseId") == tonumber(baseNum) then
                        ownerName = p.Name
                        break
                    end
                end
            end
        end)
        table.insert(out, { base = base, ownerName = ownerName, isOurs = (base == ourBase) })
    end
    return out
end
local _buildSourcesLookup = {}
local RefreshBuildSourcesDropdown
local function SaveBuildToFile(saveName)
    if not saveName or saveName == "" then
        Library:Notify("Enter a file name first.", 3)
        return
    end
    if not Support.FileIO then
        Library:Notify("File IO not supported.", 4)
        return
    end
    local json = CopyBuildToJSON()
    if not json then
        Library:Notify("No placed items to save.", 4)
        return
    end
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    pcall(function()
        if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
        writefile(path, json)
    end)
    Library:Notify("Build saved: " .. saveName, 5)
    if RefreshBuildSourcesDropdown then RefreshBuildSourcesDropdown() end
end
local function LoadBuildFromFile(saveName)
    if not saveName or saveName == "" then return nil end
    if not Support.FileIO then return nil end
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    if not isfile(path) then return nil end
    local ok, json = pcall(readfile, path)
    if not ok or not json then return nil end
    return LoadBuildJSON(json)
end
RefreshBuildSourcesDropdown = function()
    if not Options.BuildSourceDropdown then return end
    local bases = GetAllBases()
    local files = ListBuildFiles()
    local values = {}
    _buildSourcesLookup = {}
    for _, b in ipairs(bases) do
        local prefix = b.isOurs and "[My Base] " or "[Base] "
        local display = prefix .. b.ownerName
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "base", base = b.base, ownerName = b.ownerName }
    end
    for _, fname in ipairs(files) do
        local display = "[File] " .. fname
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "file", name = fname }
    end
    Options.BuildSourceDropdown:SetValues(values)
end
local function LoadSelectedBuildSource()
    local sel = Options.BuildSourceDropdown and Options.BuildSourceDropdown.Value
    if not sel or sel == "" then
        Library:Notify("Select a base or file first.", 3)
        return nil
    end
    local entry = _buildSourcesLookup[sel]
    if not entry then
        Library:Notify("Unknown source: " .. sel, 4)
        return nil
    end
    if entry.type == "base" then
        local cells = GetPlacedCells(entry.base)
        if #cells == 0 then
            Library:Notify("That base has no placed builds.", 4)
            return nil
        end
        local data = { version = 1, count = #cells, blocks = {} }
        for _, c in ipairs(cells) do
            table.insert(data.blocks, { PlotName = c.PlotName, CellName = c.CellName, BuildId = c.BuildId, Rotation = c.Rotation, MonsterId = c.MonsterId, MazeDistanceFromEntrance = c.MazeDistanceFromEntrance })
        end
        return data
    elseif entry.type == "file" then
        return LoadBuildFromFile(entry.name)
    end
    return nil
end
local function UpdateMaterialLabel()
    if not MatLabel then return end
    local data = LoadSelectedBuildSource()
    if not data then
        MatLabel:SetText("No build selected.")
        return
    end
    local reqs = GetBuildRequirements(data)
    local _, display = ComputeMissingMaterials(reqs)
    MatLabel:SetText(display)
end
local function BuyMissingMaterials()
    local data = LoadSelectedBuildSource()
    if not data then return end
    local reqs = GetBuildRequirements(data)
    local missing = ComputeMissingMaterials(reqs)
    local anyMissing = false
    for _ in pairs(missing) do anyMissing = true break end
    if not anyMissing then
        Library:Notify("No missing items.", 4)
        return
    end
    local buildIndex = BuildShopIndex("Builds", "ItemId")
    local monsterIndex = BuildShopIndex("Monsters", "ItemId")
    local cash = GetCash()
    local bought, skipped = 0, 0
    for itemName, shortage in pairs(missing) do
        local shopItem = buildIndex[itemName] or monsterIndex[itemName]
        local remote = buildIndex[itemName] and Remotes.PurchaseBuild or Remotes.PurchaseMonster
        if not shopItem then
            notyuri("[BuyMissing] no shop entry found for", itemName)
            skipped = skipped + shortage
        else
            local purchasedForItem = 0
            for _ = 1, shortage do
                if not CanAffordShopItem(shopItem, cash) then
                    notyuri("[BuyMissing] cannot afford", itemName, "price:", shopItem.Price, "cash:", cash)
                    break
                end
                InvokeRemote(remote, itemName)
                task.wait(0.2)
                cash = GetCash()
                purchasedForItem = purchasedForItem + 1
            end
            bought = bought + purchasedForItem
            skipped = skipped + (shortage - purchasedForItem)
        end
    end
    notyuri("[BuyMissing] bought:", bought, "skipped:", skipped)
    Library:Notify(("Buy Missing: +%d bought, %d skipped."):format(bought, skipped), 5)
    UpdateMaterialLabel()
end
local function RunBuildFromSelectedSource()
    local data = LoadSelectedBuildSource()
    if not data then
        Library:Notify("Select a build file first.", 3)
        return
    end
    local pending = {}
    for idx, entry in ipairs(data.blocks) do
        table.insert(pending, { entry = entry, originalIndex = idx })
    end
    table.sort(pending, function(a, b)
        local da = typeof(a.entry.MazeDistanceFromEntrance) == "number" and a.entry.MazeDistanceFromEntrance or math.huge
        local db = typeof(b.entry.MazeDistanceFromEntrance) == "number" and b.entry.MazeDistanceFromEntrance or math.huge
        if da ~= db then return da < db end
        return a.originalIndex < b.originalIndex
    end)
    notyuri("[LoadBuild] starting, blocks:", #data.blocks, "(ordered by MazeDistanceFromEntrance, multi-pass)")
    local ourBase = GetOwnedBase()
    local plotsFolder = ourBase and ourBase:FindFirstChild("Plots")
    local buildInv, monsterInv = GetSnapshot()
    local placed, skipped = 0, 0
    local NotRetryable = {
        CellOccupied = true,
        PlotLocked = true,
        MissingInventoryItem = true,
        MissingMonsterInventory = true,
    }
    local function isPlotOpen(plotName)
        local plot = plotsFolder and plotsFolder:FindFirstChild(plotName)
        return plot ~= nil and plot:GetAttribute("IsOpen") == true
    end
    -- Returns: placedOk(bool), shouldRetry(bool)
    local function placeItem(kind, itemId, remote, args, inv)
        if not isPlotOpen(args.PlotName) then
            return false, true -- plot may open later (e.g. AutoExpand running), keep retrying
        end
        local count = itemId and (inv[itemId] or 0) or 0
        if count <= 0 then
            notyuri("[LoadBuild] skipping", kind, itemId, "- no inventory")
            return false, false
        end
        local result = InvokeRemote(remote, args)
        if type(result) == "table" and result.Success == true then
            notyuri("[LoadBuild] placed", kind, itemId, "plot:", args.PlotName, "cell:", args.CellName, "inv:", count)
            task.wait(0.2)
            return true, false
        end
        local errCode = type(result) == "table" and result.Error or nil
        local retry = not NotRetryable[errCode]
        notyuri("[LoadBuild]", kind, "place failed for", itemId, "at", args.PlotName, args.CellName, "result:", DumpResult(result), "retry:", retry)
        task.wait(0.2)
        return false, retry
    end
    local passNum = 0
    while #pending > 0 do
        if not Toggles.LoadBuild.Value then
            notyuri("[LoadBuild] toggle off, stopping with", #pending, "block(s) remaining")
            break
        end
        passNum = passNum + 1
        local nextPending = {}
        local progressThisPass = false
        for _, ordered in ipairs(pending) do
            if not Toggles.LoadBuild.Value then
                table.insert(nextPending, ordered)
            else
                local entry = ordered.entry
                local buildOk, buildRetry = placeItem("build", entry.BuildId, Remotes.PlaceBuild, {
                    BuildId = entry.BuildId,
                    PlotName = entry.PlotName,
                    CellName = entry.CellName,
                    Rotation = entry.Rotation,
                }, buildInv)
                if buildOk then
                    placed = placed + 1
                    progressThisPass = true
                    if typeof(entry.MonsterId) == "string" then
                        local monsterOk = placeItem("monster", entry.MonsterId, Remotes.PlaceMonsterSpawn, {
                            MonsterId = entry.MonsterId,
                            PlotName = entry.PlotName,
                            CellName = entry.CellName,
                        }, monsterInv)
                        if monsterOk then placed = placed + 1 end
                        -- monster placement is never retried standalone: the build slot is filled either way
                    end
                elseif buildRetry then
                    table.insert(nextPending, ordered)
                else
                    skipped = skipped + 1
                end
            end
        end
        notyuri("[LoadBuild] pass", passNum, "done. placed so far:", placed, "remaining:", #nextPending)
        pending = nextPending
        if not progressThisPass then
            notyuri("[LoadBuild] no progress this pass, giving up on remaining", #pending, "block(s)")
            skipped = skipped + #pending
            break
        end
    end
    notyuri("[LoadBuild] done. placed:", placed, "skipped:", skipped)
    Toggles.LoadBuild:SetValue(false)
    Library:Notify(("Build loaded: %d placed, %d skipped."):format(placed, skipped), 5)
    UpdateMaterialLabel()
end
local function CopyBuildToClipboard()
    local json = CopyBuildToJSON()
    if not json then
        Library:Notify("No placed items to copy.", 4)
        return
    end
    if setclipboard then
        pcall(setclipboard, json)
        Library:Notify("Build copied to clipboard.", 5)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy", { Text = "Auto Buy", Default = false, Callback = function(val) Thread("AutoBuy", Func_AutoBuy, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false, Callback = function(val) Thread("AutoSell", Func_AutoSell, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false, Callback = function(val) Thread("AutoUpgrade", Func_AutoUpgrade, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoExpand", { Text = "Auto Expand", Default = false, Callback = function(val) Thread("AutoExpand", Func_AutoExpand, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false, Callback = function(val) Thread("AutoPlace", Func_AutoPlace, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false, Callback = function(val) Thread("AutoPickup", Func_AutoPickup, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("BuySelected", { Text = "Select Buy", Values = Tables.CombinedList, Default = {}, Multi = true, Searchable = true,})
TB_Tabs.Autofarm2.T1:AddDropdown("PlaceSelected", { Text = "Select Place", Values = Tables.CombinedList, Default = {}, Multi = true, Searchable = true, })
A1:AddDropdown("BuildSourceDropdown", {
    Text = "Select Build to Load",
    Values = {},
    Default = "",
    Multi = false,
    Searchable = true,
    Callback = function()
        UpdateMaterialLabel()
    end,
})
MatLabel = A2:AddLabel("No build selected.", true)
A1:AddButton({
    Text = "Buy Missing Material",
    Func = function()
        BuyMissingMaterials()
    end,
})
A1:AddToggle("LoadBuild", {
    Text = "Load Build",
    Default = false,
    Callback = function(state)
        if state then
            local t = task.spawn(function()
                while Toggles.LoadBuild.Value do
                    RunBuildFromSelectedSource()
                    task.wait(5)
                end
            end)
            Flags.LoadBuild = t
        else
            if Flags.LoadBuild and typeof(Flags.LoadBuild) == "thread" then
                task.cancel(Flags.LoadBuild)
                Flags.LoadBuild = nil
            end
        end
    end,
})
A1:AddInput("BuildSaveName", {
    Text = "File Name",
    Default = "",
    Placeholder = "yuriyuri",
    Callback = function() end,
})
A1:AddButton({
    Text = "Save Build",
    Func = function()
        SaveBuildToFile(Options.BuildSaveName and Options.BuildSaveName.Value or "")
    end,
})
A1:AddButton({
    Text = "Save Selected",
    Func = function()
        local saveName = Options.BuildSaveName and Options.BuildSaveName.Value or ""
        if not saveName or saveName == "" then
            Library:Notify("Enter a file name first.", 3)
            return
        end
        if not Support.FileIO then
            Library:Notify("File IO not supported by executor.", 4)
            return
        end
        local data = LoadSelectedBuildSource()
        if not data then return end
        local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
        if not ok or not json then
            Library:Notify("Failed to encode build data.", 4)
            return
        end
        local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
        pcall(function()
            if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
            writefile(path, json)
        end)
        local count = type(data.blocks) == "table" and #data.blocks or 0
        Library:Notify(("Selected build saved to %s (%d blocks)"):format(saveName, count), 5)
        notyuri("[CopyBuild] selected saved to", path)
        RefreshBuildSourcesDropdown()
    end,
})
task.spawn(function()
    task.wait(2)
    RefreshBuildSourcesDropdown()
end)
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
SaveManager:SetFolder("Yuri/BYB")
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