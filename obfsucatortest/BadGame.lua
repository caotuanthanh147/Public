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
local Lighting = game:GetService('Lighting');
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
    local root = Char and Char:FindFirstChild("HumanoidRootPart")
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
    part.CFrame = root.CFrame
    task.spawn(function()
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end)
end
local Remotes = {
    RollEvent = GetObject(RS, "RollEvent"),
    DropBallEvent = GetObject(RS, "DropBallEvent"),
    BallLandedEvent = GetObject(RS, "BallLandedEvent"),
    UpdateSettingsEvent = GetObject(RS, "UpdateSettingsEvent"),
    PurchaseUpgradeEvent = GetObject(RS, "PurchaseUpgradeEvent"),
    RebirthEvent = GetObject(RS, "RebirthEvent"),
    BuyZoneEvent = GetObject(RS, "BuyZoneEvent"),
    EquipZoneEvent = GetObject(RS, "EquipZoneEvent"),
    EquipBallEvent = GetObject(RS, "EquipBallEvent"),
    UnequipBallEvent = GetObject(RS, "UnequipBallEvent"),
    EquipBestEvent = GetObject(RS, "EquipBestEvent"),
    AutoEquipEvent = GetObject(RS, "AutoEquipEvent"),
    UsePotionFunc = GetObject(RS, "UsePotionFunc"),
    UseJackpotFunc = GetObject(RS, "UseJackpotFunc"),
    ClaimQuestRewardFunc = GetObject(RS, "ClaimQuestRewardFunc"),
    ClaimDailyRewardFunc = GetObject(RS, "ClaimDailyRewardFunc"),
    ClaimIndexRewardFunc = GetObject(RS, "ClaimIndexRewardFunc"),
    RedeemCodeFunc = GetObject(RS, "RedeemCodeFunc"),
    ShootBallFunc = GetObject(RS, "ShootBallFunc"),
    ShootTargetFunc = GetObject(RS, "ShootTargetFunc"),
    SetLuckEvent = GetObject(RS, "SetLuckEvent"),
    GetPlayerStatsFunc = GetObject(RS, "GetPlayerStatsFunc"),
    GetUpgradeTreeFunc = GetObject(RS, "GetUpgradeTreeFunc"),
    GetQuestsDataFunc = GetObject(RS, "GetQuestsDataFunc"),
    GetIndexDataFunc = GetObject(RS, "GetIndexDataFunc"),
    GetDailyRewardStateFunc = GetObject(RS, "GetDailyRewardStateFunc"),
}
local GameData = {
    UpgradeDefs = GetSafeModule(RS, "UpgradeDefs"),
    ZoneDefs = GetSafeModule(RS, "ZoneDefs"),
    BallIndex = GetSafeModule(RS, "BallIndex"),
}
local function SafeInvoke(remote, ...)
    if not remote then return nil end
    local args = { ... }
    local result = nil
    local done = false
    task.spawn(function()
        local ok, res = pcall(function() return remote:InvokeServer(table.unpack(args)) end)
        result = ok and res or nil
        done = true
    end)
    local start = tick()
    while not done and (tick() - start) < 5 do task.wait() end
    return result
end
local function GetPlayerStats()
    return SafeInvoke(Remotes.GetPlayerStatsFunc)
end
local function GetUpgradeTree()
    return SafeInvoke(Remotes.GetUpgradeTreeFunc)
end
local function GetQuestsData()
    return SafeInvoke(Remotes.GetQuestsDataFunc)
end
local function GetIndexData()
    return SafeInvoke(Remotes.GetIndexDataFunc)
end
local PotionTypes = { "Luck", "RollSpeed", "DropSpeed" }
local function Func_AutoRoll()
    while Toggles.BG_AutoRoll.Value do
        if Remotes.RollEvent then
            pcall(function() Remotes.RollEvent:FireServer() end)
        end
        task.wait(.1)
    end
end
local function Func_AutoDrop()
    while Toggles.BG_AutoDrop.Value do
        if Remotes.DropBallEvent then
             Remotes.BallLandedEvent:FireServer(999999999999999999999)
        end
        task.wait()
    end
end
local function Func_AutoRebirth()
    while Toggles.BG_AutoRebirth.Value do
        if Remotes.RebirthEvent then
            local ok, res = pcall(function() return Remotes.RebirthEvent:InvokeServer() end)
            if ok and res then
                notyuri("[AutoRebirth] rebirthed successfully")
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoBuyUpgrades()
    while Toggles.BG_AutoBuyUpgrades.Value do
        local tree = GetUpgradeTree()
        local ud = GameData.UpgradeDefs
        if tree and ud and ud.Upgrades and Remotes.PurchaseUpgradeEvent then
            for _, upg in ipairs(ud.Upgrades) do
                if not Toggles.BG_AutoBuyUpgrades.Value then break end
                if upg.id and upg.id ~= "start" and not tree[upg.id] then
                    local canBuy = true
                    if upg.requires and not tree[upg.requires] then
                        canBuy = false
                    end
                    if canBuy then
                        pcall(function() Remotes.PurchaseUpgradeEvent:FireServer(upg.id) end)
                        notyuri("[AutoBuyUpgrades] bought", upg.id)
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoEquipBest()
    while Toggles.BG_AutoEquipBest.Value do
        if Remotes.EquipBestEvent then
            pcall(function() Remotes.EquipBestEvent:FireServer() end)
        end
        task.wait(.1)
    end
end
local function Func_AutoBuyZones()
    while Toggles.BG_AutoBuyZones.Value do
        local stats = GetPlayerStats()
        local zd = GameData.ZoneDefs
        if stats and zd and zd.Zones and Remotes.BuyZoneEvent then
            local unlocked = stats.UnlockedZones or {}
            for _, zone in ipairs(zd.Zones) do
                if not Toggles.BG_AutoBuyZones.Value then break end
                local isUnlocked = unlocked[tostring(zone.Id)] or unlocked[zone.Id]
                if not isUnlocked then
                    local ok, res = pcall(function() return Remotes.BuyZoneEvent:InvokeServer(zone.Id) end)
                    if ok and res then
                        notyuri("[AutoBuyZones] bought zone", zone.Name)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoUsePotion()
    while Toggles.BG_AutoUsePotion.Value do
        local potionType = Options.BG_PotionType and Options.BG_PotionType.Value or "Luck"
        if Remotes.UsePotionFunc then
            local ok, res = pcall(function() return Remotes.UsePotionFunc:InvokeServer(potionType) end)
            if ok and res and res.success then
                notyuri("[AutoUsePotion] used", potionType, "remaining:", res.remaining or 0)
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoUseJackpot()
    while Toggles.BG_AutoUseJackpot.Value do
        if Remotes.UseJackpotFunc then
            local ok, res = pcall(function() return Remotes.UseJackpotFunc:InvokeServer() end)
            if ok and res then
                notyuri("[AutoUseJackpot] jackpot used")
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoClaimQuests()
    while Toggles.BG_AutoClaimQuests.Value do
        local quests = GetQuestsData()
        if quests and Remotes.ClaimQuestRewardFunc then
            for _, cat in ipairs({ "Rolls", "Rarity" }) do
                if quests[cat] then
                    for i, q in ipairs(quests[cat]) do
                        if not Toggles.BG_AutoClaimQuests.Value then break end
                        if q and not q.claimed and q.progress and q.required and q.progress >= q.required then
                            pcall(function() Remotes.ClaimQuestRewardFunc:InvokeServer(cat, i) end)
                            notyuri("[AutoClaimQuests] claimed", cat, i)
                            task.wait(0.5)
                        end
                    end
                end
            end
            if quests.DailyClaimed == false then
                pcall(function() Remotes.ClaimQuestRewardFunc:InvokeServer("Daily", 1) end)
                notyuri("[AutoClaimQuests] claimed daily")
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoClaimDaily()
    while Toggles.BG_AutoClaimDaily.Value do
        if Remotes.ClaimDailyRewardFunc then
            local ok, res = pcall(function() return Remotes.ClaimDailyRewardFunc:InvokeServer() end)
            if ok and res then
                notyuri("[AutoClaimDaily] claimed daily reward")
            end
        end
        task.wait()
    end
end
local function Func_AutoClaimIndex()
    while Toggles.BG_AutoClaimIndex.Value do
        local idxData = GetIndexData()
        if idxData and Remotes.ClaimIndexRewardFunc then
            for i = 1, 100 do
                if not Toggles.BG_AutoClaimIndex.Value then break end
                local ok, res = pcall(function() return Remotes.ClaimIndexRewardFunc:InvokeServer(i) end)
                if not ok or not res then break end
                notyuri("[AutoClaimIndex] claimed index", i)
                task.wait(0.1)
            end
        end
        task.wait()
    end
end
local function Func_AutoShoot()
    while Toggles.BG_AutoShoot.Value do
        if Remotes.ShootBallFunc then
            pcall(function() Remotes.ShootBallFunc:InvokeServer("1", true) end)
        end
        task.wait(.1)
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
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoRoll", {
    Text = "Auto Roll",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoDrop", {
    Text = "Auto Drop",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoRebirth", {
    Text = "Auto Rebirth",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoUsePotion", {
    Text = "Auto Use Potion",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoUseJackpot", {
    Text = "Auto Use Jackpot",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoClaimQuests", {
    Text = "Auto Claim Quests",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoClaimDaily", {
    Text = "Auto Claim Daily",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoClaimIndex", {
    Text = "Auto Claim Index",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoBuyUpgrades", {
    Text = "Auto Upgrades",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoEquipBest", {
    Text = "Auto Equip Ball",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoBuyZones", {
    Text = "Auto Zones",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoShoot", {
    Text = "Auto Shoot Balls",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("BG_PotionType", {
    Text = "Potion Type",
    Values = PotionTypes,
    Default = "Luck",
})
Toggles.BG_AutoRoll:OnChanged(function(v) Thread("BG_AutoRoll", Func_AutoRoll, v) end)
Toggles.BG_AutoDrop:OnChanged(function(v) Thread("BG_AutoDrop", Func_AutoDrop, v) end)
Toggles.BG_AutoRebirth:OnChanged(function(v) Thread("BG_AutoRebirth", Func_AutoRebirth, v) end)
Toggles.BG_AutoBuyUpgrades:OnChanged(function(v) Thread("BG_AutoBuyUpgrades", Func_AutoBuyUpgrades, v) end)
Toggles.BG_AutoEquipBest:OnChanged(function(v) Thread("BG_AutoEquipBest", Func_AutoEquipBest, v) end)
Toggles.BG_AutoBuyZones:OnChanged(function(v) Thread("BG_AutoBuyZones", Func_AutoBuyZones, v) end)
Toggles.BG_AutoUsePotion:OnChanged(function(v) Thread("BG_AutoUsePotion", Func_AutoUsePotion, v) end)
Toggles.BG_AutoUseJackpot:OnChanged(function(v) Thread("BG_AutoUseJackpot", Func_AutoUseJackpot, v) end)
Toggles.BG_AutoClaimQuests:OnChanged(function(v) Thread("BG_AutoClaimQuests", Func_AutoClaimQuests, v) end)
Toggles.BG_AutoClaimDaily:OnChanged(function(v) Thread("BG_AutoClaimDaily", Func_AutoClaimDaily, v) end)
Toggles.BG_AutoClaimIndex:OnChanged(function(v) Thread("BG_AutoClaimIndex", Func_AutoClaimIndex, v) end)
Toggles.BG_AutoShoot:OnChanged(function(v) Thread("BG_AutoShoot", Func_AutoShoot, v) end)
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
    Cleanup(Connections)
    Cleanup(Flags)
        Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/BallGame")
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
    notyuri("ERROR: " .. tostring(err))
end