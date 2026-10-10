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
local Packages = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
local Modules_RS = RS:FindFirstChild("Modules") or RS:WaitForChild("Modules", 10)
local DSClient = nil
local function GetDS()
    if DSClient then return DSClient end
    if not Packages then return nil end
    local ok, ds = pcall(require, Packages:FindFirstChild("DataService") or Packages:WaitForChild("DataService", 10))
    if ok and ds and ds.client then DSClient = ds.client return ds.client end
    return nil
end
local NetworkerModule = nil
local function GetNetworkerModule()
    if NetworkerModule then return NetworkerModule end
    if not Packages then return nil end
    local dsFolder = Packages:FindFirstChild("DataService") or Packages:WaitForChild("DataService", 10)
    if not dsFolder then return nil end
    local ok, nw = pcall(require, dsFolder:FindFirstChild("Networker") or dsFolder:WaitForChild("Networker", 10))
    if ok and nw then NetworkerModule = nw return nw end
    return nil
end
local function GetData(path)
    local ds = GetDS()
    if not ds then return nil end
    local ok, val = pcall(function() return ds:get(path) end)
    if ok then return val end
    return nil
end
local function GetCurrency(name)
    local val = GetData({ "Currency", name })
    return val
end
local _networkerCache = {}
local function GetServiceNetworker(serviceName)
    if _networkerCache[serviceName] then return _networkerCache[serviceName] end
    local nw = GetNetworkerModule()
    if not nw or not nw.client then return nil end
    local ok, networker = pcall(function() return nw.client.new(serviceName) end)
    if ok and networker then _networkerCache[serviceName] = networker return networker end
    return nil
end
local function FireService(serviceName, action, ...)
    local networker = GetServiceNetworker(serviceName)
    if not networker then return false end
    local args = {...}
    return pcall(function() networker:fire(action, unpack(args)) end)
end
local PacketModule = nil
local function GetPacketModule()
    if PacketModule then return PacketModule end
    if not Packages then return nil end
    local ok, pkt = pcall(require, Packages:FindFirstChild("Packet") or Packages:WaitForChild("Packet", 10))
    if ok and pkt then PacketModule = pkt return pkt end
    return nil
end
local NetModule = nil
local function GetNetModule()
    if NetModule then return NetModule end
    if not Packages then return nil end
    local ok, net = pcall(require, Packages:FindFirstChild("Net") or Packages:WaitForChild("Net", 10))
    if ok and net then NetModule = net return net end
    return nil
end
local Remotes = {}
local Modules = {
    DataService = GetDS(),
    Networker = GetNetworkerModule(),
    Packet = GetPacketModule(),
    Net = GetNetModule(),
}
local _upgradeUtil = nil
local function GetUpgradeUtil()
    if _upgradeUtil then return _upgradeUtil end
    local sys = RS:FindFirstChild("Systems")
    if not sys then return nil end
    local upgradeSystem = sys:FindFirstChild("UpgradeSystem")
    if not upgradeSystem then return nil end
    local ok, util = pcall(require, upgradeSystem:FindFirstChild("UpgradeUtil"))
    if ok and util then _upgradeUtil = util return util end
    return nil
end
local _upgradeConfig = nil
local function GetUpgradeConfig()
    if _upgradeConfig then return _upgradeConfig end
    local sys = RS:FindFirstChild("Systems")
    if not sys then return nil end
    local upgradeSystem = sys:FindFirstChild("UpgradeSystem")
    if not upgradeSystem then return nil end
    local ok, cfg = pcall(require, upgradeSystem:FindFirstChild("UpgradeConfig"))
    if ok and cfg then _upgradeConfig = cfg return cfg end
    return nil
end
local _numberUtil = nil
local function GetNumberUtil()
    if _numberUtil then return _numberUtil end
    if not Modules_RS then return nil end
    local ok, nu = pcall(require, Modules_RS:FindFirstChild("NumberUtil"))
    if ok and nu then _numberUtil = nu return nu end
    return nil
end
local _firePacket = nil
local function GetFirePacket()
    if _firePacket then return _firePacket end
    local pkt = GetPacketModule()
    if not pkt then return nil end
    local ok, fp = pcall(function() return pkt("AncientGunFire", { Hits = pkt.NumberU16 }) end)
    if ok and fp then _firePacket = fp return fp end
    return nil
end
local function Func_AutoShoot()
    while Toggles.AutoShoot.Value do
        local fp = GetFirePacket()
        if fp then
            pcall(function() fp:Fire({ Hits = 1 }) end)
        end
        task.wait(0.05)
    end
end
local _bubbleDomeRemote = nil
local function GetBubbleDomeRemote()
    if _bubbleDomeRemote then return _bubbleDomeRemote end
    local ok, remote = pcall(function()
        return RS
            :WaitForChild("Packages", 10)
            :WaitForChild("DataService", 10)
            :WaitForChild("Networker", 10)
            :WaitForChild("_remotes", 10)
            :WaitForChild("BubbleDome", 10)
            :WaitForChild("RemoteEvent", 10)
    end)
    if ok and remote then
        _bubbleDomeRemote = remote
        return remote
    end
    warn("[AutoBubble] Failed to find BubbleDome RemoteEvent")
    return nil
end
local function Func_AutoBubble()
    local remote = GetBubbleDomeRemote()
    if not remote then return end
    while Toggles.AutoBubble.Value do
        local amount = tonumber((Options.BubbleAmountInput and Options.BubbleAmountInput.Value) or "0") or 0
        pcall(function()
            remote:FireServer("CollectBubbles", {
                GoldBubble = 0/0,
                SilverBubble = 0/0,
                Bubble = 0/0,
            })
        end)
        task.wait(0.1)
        if amount and amount > 1 then
            pcall(function()
                remote:FireServer("CollectBubbles", {
                    GoldBubble = amount,
                    SilverBubble = amount,
                    Bubble = amount,
                })
            end)
            task.wait(0.1)
        end
        task.wait()
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        FireService("RebirthService", "RequestRebirth", "Rebirth")
        task.wait(1)
    end
end
local function Func_AutoReincarnate()
    while Toggles.AutoReincarnate.Value do
        FireService("ReincarnationService", "RequestReincarnation")
        task.wait(1)
    end
end
local function Func_AutoReborn()
    while Toggles.AutoReborn.Value do
        FireService("ReincarnationService", "Reborn")
        task.wait(1)
    end
end
local function Func_AutoTier()
    while Toggles.AutoTier.Value do
        FireService("TierResetService", "RequestTierReset", "World2_Tier")
        task.wait(1)
    end
end
local _upgradeRemote = nil
local function GetUpgradeRemote()
    if _upgradeRemote then return _upgradeRemote end
    local ok, remote = pcall(function()
        return RS
            :WaitForChild("Packages", 10)
            :WaitForChild("DataService", 10)
            :WaitForChild("Networker", 10)
            :WaitForChild("_remotes", 10)
            :WaitForChild("UpgradeService", 10)
            :WaitForChild("RemoteEvent", 10)
    end)
    if ok and remote then
        _upgradeRemote = remote
        return remote
    end
    warn("[AutoUpgrade] Failed to find UpgradeService RemoteEvent")
    return nil
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local remote = GetUpgradeRemote()
        local config = GetUpgradeConfig()
        local util = GetUpgradeUtil()
        local ds = GetDS()
        local nu = GetNumberUtil()
        if remote and config and util and ds and nu then
            for category, upgrades in pairs(config) do
                for statId, upgradeData in pairs(upgrades) do
                    if not Toggles.AutoUpgrade.Value then break end
                    pcall(function()
                        local level = ds:get({ "Upgrades", category, statId }) or 0
                        if util.IsMaxed(category, statId, level) then return end
                        local currency = upgradeData.Currency
                        local rawBalance = currency == "Token"
                            and tostring(ds:get("Token") or 0)
                            or (ds:get({ "Currency", currency }) or "0")
                        local balance = nu.FromString(rawBalance):round()
                        local affordable = util.CalculateMaxAffordable(category, statId, level, balance, nil)
                        if affordable and affordable > 0 then
                            remote:FireServer("PurchaseUpgrade", category, statId, "Max")
                        end
                    end)
                    task.wait(0.1)
                end
            end
        end
        task.wait(.1)
    end
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
    task.spawn(function()
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end)
end
local _upgradeTreeRemote = nil
local function GetUpgradeTreeRemote()
    if _upgradeTreeRemote then return _upgradeTreeRemote end
    local ok, remote = pcall(function()
        return RS
            :WaitForChild("Packages", 10)
            :WaitForChild("DataService", 10)
            :WaitForChild("Networker", 10)
            :WaitForChild("_remotes", 10)
            :WaitForChild("UpgradeTreeService", 10)
            :WaitForChild("RemoteEvent", 10)
    end)
    if ok and remote then
        _upgradeTreeRemote = remote
        return remote
    end
    warn("[AutoTreeNode] Failed to find UpgradeTreeService RemoteEvent")
    return nil
end
local function Func_AutoTreeNode()
    local Worlds = workspace:FindFirstChild("Worlds")
    while Toggles.AutoTreeNode.Value do
        local remote = GetUpgradeTreeRemote()
        if remote and Worlds then
            for _, worldFolder in ipairs(Worlds:GetChildren()) do
                local treesFolder = worldFolder:FindFirstChild("UpgradeTrees")
                if treesFolder then
                    for _, treeGroup in ipairs(treesFolder:GetChildren()) do
                        local treeName = treeGroup.Name
                        for _, node in ipairs(treeGroup:GetChildren()) do
                            if not Toggles.AutoTreeNode.Value then break end
                            pcall(function()
                                remote:FireServer("PurchaseTreeNode", treeName, node.Name)
                            end)
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local _pearlRemote = nil
local function GetPearlRemote()
    if _pearlRemote then return _pearlRemote end
    local ok, remote = pcall(function()
        return RS
            :WaitForChild("Packages", 10)
            :WaitForChild("DataService", 10)
            :WaitForChild("Networker", 10)
            :WaitForChild("_remotes", 10)
            :WaitForChild("PearlEarningService", 10)
            :WaitForChild("RemoteEvent", 10)
    end)
    if ok and remote then
        _pearlRemote = remote
        return remote
    end
    warn("[AutoPearl] Failed to find PearlEarningService RemoteEvent")
    return nil
end
local function Func_AutoPearl()
    while Toggles.AutoPearl.Value do
        local remote = GetPearlRemote()
        if remote then
            pcall(function()
                remote:FireServer("HoverPearlCollected", "MainPearl")
            end)
        end
        task.wait(0.1)
    end
end
local function Func_AutoDepositGem()
    while Toggles.AutoDepositGem.Value do
        FireService("BenefitService", "DepositGemForge", nil, "Max")
        task.wait(2)
    end
end
local function Func_AutoPearlConversion()
    while Toggles.AutoPearlConversion.Value do
        FireService("PearlConversionService", "DepositPearlConversion", "Convert")
        task.wait(2)
    end
end
local function Func_AutoQuest()
    while Toggles.AutoQuest.Value do
        FireService("SparkleQuestService", "StartQuest")
        task.wait(1)
        FireService("SparkleQuestService", "SubmitQuest")
        task.wait(5)
    end
end
local function Func_AutoRefundQuest()
    while Toggles.AutoRefundQuest.Value do
        FireService("QuestPointRefundService", "RefundQuestPoint")
        task.wait(5)
    end
end
local function Func_SetShootingZone()
    while Toggles.AutoShootingZone.Value do
        local net = GetNetModule()
        if net then
            pcall(function() net:RemoteEvent("SetInShootingZone"):FireServer(true) end)
        end
        task.wait(5)
    end
end
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
TB_Tabs.Autofarm.T1:AddToggle("AutoBubble", { Text = "Auto Bubble", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("BubbleAmountInput", {
    Default = "1",
    Text = "Bubble Amount",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTreeNode", { Text = "Auto Tree Node", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPearl", { Text = "Auto Pearl", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDepositGem", { Text = "Auto Deposit Gem", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPearlConversion", { Text = "Auto Pearl Conversion", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoQuest", { Text = "Auto Quest", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReincarnate", { Text = "Auto Reincarnate", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReborn", { Text = "Auto Reborn", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTier", { Text = "Auto Tier Reset", Default = false })
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
Toggles.AutoBubble:OnChanged(function(v)
    Thread("AutoBubble", SafeLoop("AutoBubble", Func_AutoBubble), v)
end)
Toggles.AutoUpgrade:OnChanged(function(v)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
end)
Toggles.AutoTreeNode:OnChanged(function(v)
    Thread("AutoTreeNode", SafeLoop("AutoTreeNode", Func_AutoTreeNode), v)
end)
Toggles.AutoPearl:OnChanged(function(v)
    Thread("AutoPearl", SafeLoop("AutoPearl", Func_AutoPearl), v)
end)
Toggles.AutoDepositGem:OnChanged(function(v)
    Thread("AutoDepositGem", SafeLoop("AutoDepositGem", Func_AutoDepositGem), v)
end)
Toggles.AutoPearlConversion:OnChanged(function(v)
    Thread("AutoPearlConversion", SafeLoop("AutoPearlConversion", Func_AutoPearlConversion), v)
end)
Toggles.AutoQuest:OnChanged(function(v)
    Thread("AutoQuest", SafeLoop("AutoQuest", Func_AutoQuest), v)
end)
Toggles.AutoRebirth:OnChanged(function(v)
    Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v)
end)
Toggles.AutoReincarnate:OnChanged(function(v)
    Thread("AutoReincarnate", SafeLoop("AutoReincarnate", Func_AutoReincarnate), v)
end)
Toggles.AutoReborn:OnChanged(function(v)
    Thread("AutoReborn", SafeLoop("AutoReborn", Func_AutoReborn), v)
end)
Toggles.AutoTier:OnChanged(function(v)
    Thread("AutoTier", SafeLoop("AutoTier", Func_AutoTier), v)
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
SaveManager:SetFolder("Yuri/BubbleShooting")
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