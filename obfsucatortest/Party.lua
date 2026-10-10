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
            local inviteCode = "6pCsSbVd3E"
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
local EventsFolder = RS:FindFirstChild("Events") or RS:WaitForChild("Events", 15)
local function GetRE(name)
    if not EventsFolder then return nil end
    return EventsFolder:FindFirstChild(name) or EventsFolder:WaitForChild(name, 10)
end
local function GetRF(name)
    if not EventsFolder then return nil end
    return EventsFolder:FindFirstChild(name) or EventsFolder:WaitForChild(name, 10)
end
local Remotes = {
    RequestRebirth = GetRF("RequestRebirth"),
    RequestBuyUpgrade = GetRF("RequestBuyUpgrade"),
    RequestBuyWorker = GetRF("RequestBuyWorker"),
    RequestClaimDailyReward = GetRF("RequestClaimDailyReward"),
    RequestClaimPlaytimeReward = GetRF("RequestClaimPlaytimeReward"),
    RequestClaimOfflineEarnings = GetRF("RequestClaimOfflineEarnings"),
    RequestClaimGroupReward = GetRF("RequestClaimGroupReward"),
    RequestFreeReward = GetRF("RequestFreeReward"),
    RequestRedeemCode = GetRF("RequestRedeemCode"),
    RequestFinishTutorial = GetRF("RequestFinishTutorial"),
    RequestAutoSpinSettings = GetRF("RequestAutoSpinSettings"),
    RequestCleanAll = GetRE("RequestCleanAll"),
    RequestTimeSkip = GetRE("RequestTimeSkip"),
    RequestExpand = GetRE("RequestExpand"),
    RequestBoxConveyorRoll = GetRE("RequestBoxConveyorRoll"),
    RequestPlaceItem = GetRF("RequestPlaceItem"),
    RequestBuyBuildingCash = GetRF("RequestBuyBuildingCash"),
    RequestRemoveItem = GetRF("RequestRemoveItem"),
}
local Modules = {
    UpgradeConfig = GetSafeModule(RS:FindFirstChild("DataModules"), "UpgradeConfig"),
    RebirthConfig = GetSafeModule(RS:FindFirstChild("DataModules"), "RebirthConfig"),
    PlayerData = GetSafeModule(RS:FindFirstChild("Client"), "PlayerData"),
    ItemConfig = GetSafeModule(RS:FindFirstChild("DataModules"), "ItemConfig"),
    BuildingShopConfig = GetSafeModule(RS:FindFirstChild("DataModules"), "BuildingShopConfig"),
    BoxOpeningFeedbackConfig = GetSafeModule(RS:FindFirstChild("DataModules"), "BoxOpeningFeedbackConfig"),
}
local Flags = {}
local Shared = {
}
local Tables = {
    UpgradeList = { "WalkSpeed", "BookFlyTime", "RollerSize", "WorkerSpeed", "RollLuck", "RollSpeed", "ItemSlots", "Security" },
    UpgradeMap = { WalkSpeed = "WalkSpeed", BookFlyTime = "BookFlyTime", RollerSize = "RollerSize", WorkerSpeed = "WorkerSpeed", RollLuck = "RollLuck", RollSpeed = "RollSpeed", ItemSlots = "ItemSlots", Security = "Security" },
    ItemList = {},
    ItemMap = {},
    SpinItemList = {},
    SpinItemMap = {},
    PlaceItemList = {},
    PlaceItemMap = {},
    RarityList = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Rainbow" },
    BuildingList = {},
    BuildingMap = {},
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local function AddMultiDropdown(group, id, config)
    config = config or {}
    local labelId = config.label
    local baseValues = config.Values or {}
    local values = { "All" }
    for _, v in ipairs(baseValues) do
        table.insert(values, v)
    end
    group:AddDropdown(id, {
        Text = config.Text,
        Values = values,
        Default = config.Default or {},
        Multi = true,
        Searchable = true,
        Callback = config.Callback,
    })
    return function()
        local labels = (Options[id] and Options[id].Value) or {}
        local ids = {}
        if labels["All"] then
            for _, label in ipairs(baseValues) do
                if labelId then
                    local mappedId = labelId[label]
                    if mappedId then ids[mappedId] = true end
                else
                    ids[label] = true
                end
            end
            return ids
        end
        for label, active in pairs(labels) do
            if active and label ~= "All" then
                if labelId then
                    local mappedId = labelId[label]
                    if mappedId then ids[mappedId] = true end
                else
                    ids[label] = true
                end
            end
        end
        return ids
    end
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
local function ParseAbbreviatedPrice(text)
    if type(text) ~= "string" then return nil end
    local numPart, suffix = text:match("[%$]?([%d%.,]+)%s*([TBMK]?)")
    if not numPart then return nil end
    numPart = numPart:gsub(",", "")
    local num = tonumber(numPart)
    if not num then return nil end
    local mult = {T = 1e12, B = 1e9, M = 1e6, K = 1e3}
    if suffix ~= "" and mult[suffix] then
        num = num * mult[suffix]
    end
    return num
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
local function TPTo(target, offset)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local cframe
    if typeof(target) == "CFrame" then
        cframe = target
    elseif typeof(target) == "Vector3" then
        cframe = CFrame.new(target)
    elseif typeof(target) == "Instance" then
        if target:IsA("BasePart") then
            cframe = target.CFrame
        elseif target:IsA("Model") then
            cframe = target:GetPivot()
        end
    end
    if not cframe then return false end
    if offset then
        cframe = cframe * CFrame.new(offset)
    end
    hrp.CFrame = cframe
    return true
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
local function InvokeRemote(remote, ...)
    if not remote then return nil end
    local args = {...}
    local result = nil
    local done = false
    task.spawn(function()
        local ok, res = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)
        if ok then result = res end
        done = true
    end)
    local start = tick()
    repeat task.wait() until done or (tick() - start) > 3
    return result
end
local function FireRemote(remote, ...)
    if not remote then return end
    local args = {...}
    pcall(function()
        remote:FireServer(unpack(args))
    end)
end
local function GetData(key)
    local pd = Modules.PlayerData
    if not pd then return nil end
    local ok, val = pcall(function() return pd.get(key) end)
    return ok and val or nil
end
local function GetCash()
    return tonumber(GetData("Cash")) or 0
end
local function GetRebirths()
    return tonumber(GetData("Rebirths")) or 0
end
local function GetUpgradeLevel(key)
    local upgrades = GetData("Upgrades")
    if type(upgrades) ~= "table" then return 0 end
    return tonumber(upgrades[key]) or 0
end
local function GetLocalPlotRoot()
    local Map = workspace:FindFirstChild("Map")
    local Plots = Map and Map:FindFirstChild("Plots")
    if not Plots then return nil end
    return Plots:FindFirstChild("Plot_" .. Plr.UserId)
end
local function CanRebirth()
    local cfg = Modules.RebirthConfig
    if not cfg then return false end
    local rebirths = GetRebirths()
    if cfg.IsMax and cfg.IsMax(rebirths) then return false end
    local cost = cfg.GetCost and cfg.GetCost(rebirths) or 0
    return GetCash() >= cost
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        if CanRebirth() then
            InvokeRemote(Remotes.RequestRebirth)
            task.wait(2)
        end
        task.wait(1)
    end
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local selected = Shared.GetSelectedUpgrades and Shared.GetSelectedUpgrades() or {}
        local cfg = Modules.UpgradeConfig
        if cfg and next(selected) then
            local balances = {}
            for upgradeKey in pairs(selected) do
                local level = GetUpgradeLevel(upgradeKey)
                local maxLevel = cfg.GetMax and cfg.GetMax(upgradeKey) or 999
                if level < maxLevel then
                    local cost = cfg.GetPrice and cfg.GetPrice(upgradeKey, level) or math.huge
                    local dataKey = "Cash"
                    if cfg.GetCurrency then
                        dataKey = cfg.GetCurrency(upgradeKey)
                    end
                    if balances[dataKey] == nil then
                        balances[dataKey] = tonumber(GetData(dataKey)) or 0
                    end
                    if balances[dataKey] >= cost then
                        InvokeRemote(Remotes.RequestBuyUpgrade, upgradeKey)
                        task.wait(0.3)
                        balances[dataKey] = tonumber(GetData(dataKey)) or 0
                    end
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoBuyWorker()
    while Toggles.AutoBuyWorker.Value do
        InvokeRemote(Remotes.RequestBuyWorker)
        task.wait(1)
    end
end
local function Func_AutoClaimDaily()
    while Toggles.AutoClaimDaily.Value do
        InvokeRemote(Remotes.RequestClaimDailyReward)
        task.wait(10)
    end
end
local function Func_AutoClaimPlaytime()
    while Toggles.AutoClaimPlaytime.Value do
        InvokeRemote(Remotes.RequestClaimPlaytimeReward)
        task.wait(10)
    end
end
local function Func_AutoClaimOffline()
    while Toggles.AutoClaimOffline.Value do
        InvokeRemote(Remotes.RequestClaimOfflineEarnings)
        task.wait(10)
    end
end
local function Func_AutoClaimGroup()
    while Toggles.AutoClaimGroup.Value do
        if GetData("GroupRewardClaimed") ~= true then
            InvokeRemote(Remotes.RequestClaimGroupReward)
        end
        task.wait(15)
    end
end
local function Func_AutoClaimFree()
    while Toggles.AutoClaimFree.Value do
        InvokeRemote(Remotes.RequestFreeReward)
        task.wait(15)
    end
end
local function Func_AutoClean()
    while Toggles.AutoClean.Value do
        FireRemote(Remotes.RequestCleanAll)
        task.wait(5)
    end
end
local function Func_AutoCollectCash()
    while Toggles.AutoCollectCash.Value do
        local plotRoot = GetLocalPlotRoot()
        local placedItems = plotRoot and plotRoot:FindFirstChild("PlacedItems")
        if placedItems then
            for _, item in ipairs(placedItems:GetChildren()) do
                if item:IsA("Model") and (tonumber(item:GetAttribute("CashToCollect")) or 0) > 0 then
                    local hitbox = item:FindFirstChild("CashCollectHitbox")
                    if hitbox and hitbox:IsA("BasePart") then
                        FireTI(hitbox)
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function GetConveyorBox()
    local plotRoot = GetLocalPlotRoot()
    if not plotRoot then return nil end
    local conveyorBoxes = plotRoot:FindFirstChild("ConveyorBoxes")
    if not conveyorBoxes then return nil end
    for _, inst in ipairs(conveyorBoxes:GetChildren()) do
        if inst:IsA("Model") and inst.Name:match("^ConveyorBox_") then
            return inst
        end
    end
    return nil
end
local function Func_AutoRoll()
    while Toggles.AutoRoll.Value do
        local selectedIds = Shared.GetSelectedRollItems and Shared.GetSelectedRollItems() or {}
        local hasTargets = next(selectedIds) ~= nil
        local conveyorBox = GetConveyorBox()
        if conveyorBox then
            local itemId = conveyorBox:GetAttribute("ItemId")
            if not hasTargets or (type(itemId) == "string" and selectedIds[itemId]) then
                local isFree = conveyorBox:GetAttribute("FirstRollFree") == true
                local cost = isFree and 0 or (tonumber(conveyorBox:GetAttribute("ConveyorPurchasePrice")) or 0)
                local cash = GetCash()
                if cash >= cost then
                    local handle = conveyorBox:FindFirstChild("Handle")
                    local prompt = handle and handle:FindFirstChild("BoxPurchasePrompt")
                    if prompt and prompt:IsA("ProximityPrompt") then
                        FirePP(prompt, true)
                        task.wait(0.2)
                    end
                else
                    notyuri("Func_AutoRoll: waiting for enough money to buy " .. tostring(conveyorBox:GetAttribute("name")))
                end
            else
                FireRemote(Remotes.RequestBoxConveyorRoll)
            end
        else
            FireRemote(Remotes.RequestBoxConveyorRoll)
        end
        task.wait(1)
    end
end
local function GetExpandPanels()
    local plotRoot = GetLocalPlotRoot()
    if not plotRoot then return {} end
    local items = plotRoot:FindFirstChild("Items")
    if not items then return {} end
    local panels = {}
    for _, buyButton in ipairs(items:GetDescendants()) do
        if buyButton:IsA("GuiButton") and buyButton.Name == "BuyButton" then
            local panel = buyButton.Parent
            while panel do
                if panel:GetAttribute("ExpandTarget") ~= nil or panel.Name == "ExpandPart" then
                    break
                end
                local parentOfParent = panel.Parent
                if parentOfParent and parentOfParent:IsA("Model") and parentOfParent.Parent and parentOfParent.Parent.Name == "Items" then
                    panel = parentOfParent
                    break
                end
                panel = panel.Parent
            end
            if panel then
                local textLabel = buyButton:FindFirstChild("TextLabel")
                table.insert(panels, { panel = panel, buyButton = buyButton, textLabel = textLabel })
            end
        end
    end
    return panels
end
local function Func_AutoExpand()
    while Toggles.AutoExpand.Value do
        for _, entry in ipairs(GetExpandPanels()) do
            local priceText = entry.textLabel and entry.textLabel.Text
            local cost = ParseAbbreviatedPrice(priceText)
            if cost then
                local cash = GetCash()
                if cash >= cost then
                    Remotes.RequestExpand:FireServer(entry.panel)
                    task.wait(0.3)
                else
                    notyuri("Func_AutoExpand: waiting for enough money (" .. tostring(priceText) .. ")")
                end
            else
                notyuri("Func_AutoExpand: could not parse price text from BuyButton")
            end
        end
        task.wait(1)
    end
end
local function Func_AutoBuyBuilding()
    while Toggles.AutoBuyBuilding.Value do
        local selected = Shared.GetSelectedBuildings and Shared.GetSelectedBuildings() or {}
        local cfg = Modules.BuildingShopConfig
        if cfg and next(selected) then
            local rebirths = math.max(0, math.floor(tonumber(GetData("Rebirths")) or 0))
            local cash = GetCash()
            for key in pairs(selected) do
                local category, name = key:match("^(.-)|(.*)$")
                if category and name and cfg.IsCategory(category) then
                    local rebirthRequired = cfg.GetRebirthRequired(category, name)
                    if rebirths >= rebirthRequired then
                        local cost = cfg.GetNumber(category, name, "price", 0)
                        if cash >= cost then
                            InvokeRemote(Remotes.RequestBuyBuildingCash, category, name)
                            task.wait(0.3)
                            cash = GetCash()
                        end
                    else
                        notyuri("Func_AutoBuyBuilding: " .. name .. " requires rebirth " .. tostring(rebirthRequired))
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function GetUpgradeConveyorButton()
    local plotRoot = GetLocalPlotRoot()
    if not plotRoot then return nil, nil end
    local rollArea = plotRoot:FindFirstChild("RollArea")
    local upgradeConveyor = rollArea and rollArea:FindFirstChild("UpgradeConveyor")
    if not upgradeConveyor then return nil, nil end
    local button = upgradeConveyor:FindFirstChild("Button")
    local priceLabel = upgradeConveyor:FindFirstChild("Billboard")
    priceLabel = priceLabel and priceLabel:FindFirstChild("BillboardGui")
    priceLabel = priceLabel and priceLabel:FindFirstChild("Price")
    return button, priceLabel
end
local function Func_AutoUpgradeConveyor()
    while Toggles.AutoUpgradeConveyor.Value do
        local button, priceLabel = GetUpgradeConveyorButton()
        if button and button:IsA("BasePart") then
            local priceText = priceLabel and priceLabel.Text
            local cost = ParseAbbreviatedPrice(priceText)
            if cost then
                local cash = GetCash()
                if cash >= cost then
                    FireTI(button)
                    task.wait(0.3)
                else
                    notyuri("Func_AutoUpgradeConveyor: waiting for enough money (" .. tostring(priceText) .. ")")
                end
            else
                notyuri("Func_AutoUpgradeConveyor: could not parse price text from Billboard")
            end
        end
        task.wait(1)
    end
end
local function Func_AutoOpenLuckyBox()
    while Toggles.AutoOpenLuckyBox.Value do
        local cfg = Modules.BoxOpeningFeedbackConfig
        local openActionText = cfg and cfg.GetPrompt and cfg.GetPrompt().openActionText
        if openActionText then
            local plotRoot = GetLocalPlotRoot()
            local placedItems = plotRoot and plotRoot:FindFirstChild("PlacedItems")
            if placedItems then
                for _, item in ipairs(placedItems:GetChildren()) do
                    if item:IsA("Model") then
                        local handle = item:FindFirstChild("Handle")
                        local prompt = handle and handle:FindFirstChild("BoxOpenPrompt")
                        if prompt and prompt:IsA("ProximityPrompt") and prompt.ActionText == openActionText then
                            FirePP(prompt, true)
                            task.wait(0.2)
                        end
                    end
                end
            end
        else
            notyuri("Func_AutoOpenLuckyBox: could not resolve openActionText from BoxOpeningFeedbackConfig")
        end
        task.wait(1)
    end
end
local function Func_AutoFinishTutorial()
    while Toggles.AutoFinishTutorial.Value do
        InvokeRemote(Remotes.RequestFinishTutorial)
        task.wait(5)
    end
end
local function GetSpinLeverPrompt()
    local plotRoot = GetLocalPlotRoot()
    if not plotRoot then return nil end
    local spinArea = plotRoot:FindFirstChild("SpinArea")
    local rollKeycapsMain = spinArea and spinArea:FindFirstChild("RollKeycapsMain")
    local rollkeyBase = rollKeycapsMain and rollKeycapsMain:FindFirstChild("RollkeyBase")
    if not rollkeyBase then return nil end
    return rollkeyBase:FindFirstChild("ProximityPrompt", true)
end
local function GetOwnedSpinRewards()
    local plotRoot = GetLocalPlotRoot()
    if not plotRoot then return {} end
    local spinRewards = plotRoot:FindFirstChild("SpinRewards")
    if not spinRewards then return {} end
    local rewards = {}
    for _, inst in ipairs(spinRewards:GetChildren()) do
        if inst:IsA("Model") and inst.Name:match("^SpinReward_") then
            table.insert(rewards, inst)
        end
    end
    return rewards
end
local function Func_AutoSpin()
    InvokeRemote(Remotes.RequestAutoSpinSettings, "SetActive", nil, true)
    while Toggles.AutoEnableAutoSpin.Value do
        local selectedItems = Shared.GetSelectedSpinItems and Shared.GetSelectedSpinItems() or {}
        local waitingOnTarget = false
        if next(selectedItems) then
            for _, reward in ipairs(GetOwnedSpinRewards()) do
                local itemId = reward:GetAttribute("ItemId")
                if type(itemId) == "string" and selectedItems[itemId] then
                    local cost = tonumber(reward:GetAttribute("price")) or 0
                    local cash = GetCash()
                    if cash >= cost then
                        local handle = reward:FindFirstChild("Handle")
                        local prompt = handle and handle:FindFirstChild("SpinPickupPrompt")
                        if prompt and prompt:IsA("ProximityPrompt") then
                            FirePP(prompt, true)
                            task.wait(0.2)
                        end
                    else
                        waitingOnTarget = true
                        notyuri("Func_AutoSpin: waiting for enough money to buy " .. tostring(reward:GetAttribute("name")))
                    end
                end
            end
        end
        if not waitingOnTarget then
            local lever = GetSpinLeverPrompt()
            if lever then
                FirePP(lever, true)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoEnableQuickSpin()
    while Toggles.AutoEnableQuickSpin.Value do
        InvokeRemote(Remotes.RequestAutoSpinSettings, "SetQuickSpin", nil, true)
        task.wait(10)
    end
end
local function GetHeldPlaceableTools()
    local tools = {}
    local backpack = Plr:FindFirstChildOfClass("Backpack")
    local char = Plr.Character
    for _, container in ipairs({ backpack, char }) do
        if container then
            for _, inst in ipairs(container:GetChildren()) do
                if inst:IsA("Tool") and type(inst:GetAttribute("ItemId")) == "string" then
                    table.insert(tools, inst)
                end
            end
        end
    end
    return tools
end
local function GetOwnedUnlockedPlaceZones()
    local zones = {}
    local ItemConfigMod = Modules.ItemConfig
    if not ItemConfigMod then return zones end
    for _, inst in ipairs(CollectionService:GetTagged("PlaceZone")) do
        if inst:IsA("BasePart") then
            local ownerId = nil
            local walk = inst
            while walk and walk ~= workspace do
                local oid = tonumber(walk:GetAttribute("OwnerUserId"))
                if oid then ownerId = oid break end
                walk = walk.Parent
            end
            if ownerId == Plr.UserId then
                local zoneUnlocked = true
                local zwalk = inst
                while zwalk and zwalk.Parent do
                    if zwalk.Parent.Name == "Items" and zwalk:IsA("Model") then
                        zoneUnlocked = zwalk:GetAttribute("Unlocked") ~= false
                        break
                    end
                    zwalk = zwalk.Parent
                end
                if zoneUnlocked then
                    table.insert(zones, inst)
                end
            end
        end
    end
    return zones
end
local function GetZoneIdOf(zonePart)
    local walk = zonePart
    while walk and walk.Parent do
        if walk.Parent.Name == "Items" and walk:IsA("Model") and tonumber(walk.Name) then
            return walk.Name
        end
        walk = walk.Parent
    end
    return nil
end
local function BoxesOverlap(handleA, handleB)
    local extentsA = Vector3.new(math.max(0.025, (handleA.Size.X - 0.1) * 0.5), math.max(0.025, (handleA.Size.Y - 0.1) * 0.5), math.max(0.025, (handleA.Size.Z - 0.1) * 0.5))
    local extentsB = handleB.Size * 0.5
    local axesA = { handleA.CFrame.RightVector, handleA.CFrame.UpVector, handleA.CFrame.LookVector }
    local axesB = { handleB.CFrame.RightVector, handleB.CFrame.UpVector, handleB.CFrame.LookVector }
    local offset = handleB.Position - handleA.Position
    local function isSeparatingAxis(axis)
        local mag = axis.Magnitude
        if mag < 1e-6 then return false end
        local norm = axis / mag
        local rA = math.abs(norm:Dot(axesA[1])) * extentsA.X + math.abs(norm:Dot(axesA[2])) * extentsA.Y + math.abs(norm:Dot(axesA[3])) * extentsA.Z
        local rB = math.abs(norm:Dot(axesB[1])) * extentsB.X + math.abs(norm:Dot(axesB[2])) * extentsB.Y + math.abs(norm:Dot(axesB[3])) * extentsB.Z
        return rA + rB <= math.abs(offset:Dot(norm))
    end
    for _, axis in ipairs(axesA) do
        if isSeparatingAxis(axis) then return false end
    end
    for _, axis in ipairs(axesB) do
        if isSeparatingAxis(axis) then return false end
    end
    for _, a in ipairs(axesA) do
        for _, b in ipairs(axesB) do
            if isSeparatingAxis(a:Cross(b)) then return false end
        end
    end
    return true
end
local function PreviewOverlapsPlacedItem(previewHandle, plotRoot)
    local placedItems = plotRoot:FindFirstChild("PlacedItems")
    if not placedItems then return false end
    for _, inst in ipairs(placedItems:GetChildren()) do
        if inst:IsA("Model") then
            local otherHandle = inst:FindFirstChild("Handle") or inst.PrimaryPart
            if otherHandle and otherHandle:IsA("BasePart") and not CollectionService:HasTag(otherHandle, "IgnorePlacement") then
                if BoxesOverlap(previewHandle, otherHandle) then
                    return true
                end
            end
        end
    end
    return false
end
local function PreviewOverlapsObstacle(previewHandle, excludeModel)
    for _, inst in ipairs(CollectionService:GetTagged("Obstacle")) do
        if inst:IsDescendantOf(workspace) and not inst:IsDescendantOf(excludeModel) then
            if inst:IsA("BasePart") then
                if BoxesOverlap(previewHandle, inst) then return true end
            else
                for _, part in ipairs(inst:GetDescendants()) do
                    if part:IsA("BasePart") and not part:IsDescendantOf(excludeModel) then
                        if BoxesOverlap(previewHandle, part) then return true end
                    end
                end
            end
        end
    end
    return false
end
local function TryFindPlacement(itemId)
    local ItemConfigMod = Modules.ItemConfig
    if not ItemConfigMod then return nil end
    if ItemConfigMod.GetMaxItemPlaced then
        local maxPlaced = ItemConfigMod.GetMaxItemPlaced(itemId)
        if maxPlaced > 0 then
            local plotRoot = GetLocalPlotRoot()
            local placedItemsFolder = plotRoot and plotRoot:FindFirstChild("PlacedItems")
            if placedItemsFolder then
                local placedCount = 0
                for _, inst in ipairs(placedItemsFolder:GetChildren()) do
                    if inst:IsA("Model") and inst:GetAttribute("ItemId") == itemId then
                        placedCount = placedCount + 1
                    end
                end
                if placedCount >= maxPlaced then return nil end
            end
        end
    end
    local placedTemplate = ItemConfigMod.GetPlacedTemplate and ItemConfigMod.GetPlacedTemplate(itemId)
    local usingFallback = false
    if not placedTemplate then
        local toolTemplate = ItemConfigMod.GetTemplate and ItemConfigMod.GetTemplate(itemId)
        if not toolTemplate then return nil end
        placedTemplate = toolTemplate
        usingFallback = true
    end
    for _, zonePart in ipairs(GetOwnedUnlockedPlaceZones()) do
        local zoneId = GetZoneIdOf(zonePart)
        local canPlace = ItemConfigMod.CanPlaceInZone and ItemConfigMod.CanPlaceInZone(itemId, zoneId)
        if canPlace then
            local plotRoot = GetLocalPlotRoot()
            if plotRoot then
                local preview
                if usingFallback then
                    preview = Instance.new("Model")
                    preview.Name = "ItemPlacePreview"
                    local clone = placedTemplate:Clone()
                    for _, child in ipairs(clone:GetChildren()) do
                        if child:IsA("BaseScript") or child:IsA("ModuleScript") then
                            child:Destroy()
                        else
                            child.Parent = preview
                        end
                    end
                    clone:Destroy()
                    if ItemConfigMod.ApplyAttributes then
                        ItemConfigMod.ApplyAttributes(preview, itemId)
                    end
                    for _, desc in ipairs(preview:GetDescendants()) do
                        if desc:IsA("BasePart") then
                            desc.Anchored = true
                            desc.CanCollide = false
                            desc.CanQuery = false
                            desc.CanTouch = false
                            desc.Massless = true
                        end
                    end
                else
                    preview = placedTemplate:Clone()
                end
                local hitbox = nil
                for _, desc in ipairs(preview:GetDescendants()) do
                    if desc:IsA("BasePart") and string.lower(desc.Name) == "hitbox" then
                        hitbox = desc
                        break
                    end
                end
                if not hitbox then
                    hitbox = preview:FindFirstChild("Handle", true)
                end
                if hitbox and hitbox:IsA("BasePart") then
                    preview.PrimaryPart = hitbox
                end
                local primary = preview.PrimaryPart or preview:FindFirstChild("Handle")
                if primary then
                    local half = zonePart.Size / 2
                    local step = 2
                    local offsets = {}
                    for x = -half.X, half.X, step do
                        for z = -half.Z, half.Z, step do
                            table.insert(offsets, { x = x, z = z, dist = x * x + z * z })
                        end
                    end
                    table.sort(offsets, function(a, b) return a.dist < b.dist end)
                    for _, offset in ipairs(offsets) do
                        local worldPos = zonePart.CFrame:PointToWorldSpace(Vector3.new(offset.x, half.Y, offset.z))
                        preview:PivotTo(CFrame.new())
                        local pp = preview.PrimaryPart
                        local yOffset
                        if pp then
                            yOffset = pp.Position.Y - pp.Size.Y / 2
                        else
                            local _, boundsSize = preview:GetBoundingBox()
                            yOffset = -boundsSize.Y / 2
                        end
                        preview:PivotTo(CFrame.new(worldPos) * CFrame.new(0, -yOffset, 0))
                        preview.Parent = workspace
                        local handle = preview:FindFirstChild("Handle") or preview.PrimaryPart
                        if handle and handle:IsA("BasePart") then
                            if not PreviewOverlapsPlacedItem(handle, plotRoot) and not PreviewOverlapsObstacle(handle, preview) then
                                preview:Destroy()
                                return zonePart, worldPos
                            end
                        end
                    end
                end
                preview:Destroy()
            end
        end
    end
    return nil
end
local function InvokeRemoteMulti(remote, ...)
    if not remote then return nil end
    local args = {...}
    local results = nil
    local done = false
    task.spawn(function()
        local packed = table.pack(pcall(function()
            return remote:InvokeServer(unpack(args))
        end))
        if packed[1] then
            results = table.pack(select(2, unpack(packed, 1, packed.n)))
        end
        done = true
    end)
    local start = tick()
    repeat task.wait() until done or (tick() - start) > 3
    return results
end
local function EquipTool(tool)
    if not tool or not tool:IsA("Tool") then return end
    local hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum:EquipTool(tool)
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local selectedIds = Shared.GetSelectedPlaceItems and Shared.GetSelectedPlaceItems() or {}
        if next(selectedIds) then
            for _, tool in ipairs(GetHeldPlaceableTools()) do
                local itemId = tool:GetAttribute("ItemId")
                if type(itemId) == "string" and selectedIds[itemId] then
                    local zonePart, worldPos = TryFindPlacement(itemId)
                    if zonePart and worldPos then
                        EquipTool(tool)
                        task.wait(0.1)
                        local results = InvokeRemoteMulti(Remotes.RequestPlaceItem, zonePart, worldPos, 0)
                        local ok = results and results[1]
                        local err = results and results[2]
                        if not ok and err then
                            notyuri("Func_AutoPlace: " .. tostring(err))
                        end
                        task.wait(0.3)
                    else
                        notyuri("Func_AutoPlace: no free spot found for " .. tostring(itemId))
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoPickup()
    while Toggles.AutoPickup.Value do
        local selectedIds = Shared.GetSelectedPickupItems and Shared.GetSelectedPickupItems() or {}
        if next(selectedIds) then
            local plotRoot = GetLocalPlotRoot()
            local placedItemsFolder = plotRoot and plotRoot:FindFirstChild("PlacedItems")
            if placedItemsFolder then
                for _, model in ipairs(placedItemsFolder:GetChildren()) do
                    if model:IsA("Model") then
                        local itemId = model:GetAttribute("ItemId")
                        if type(itemId) == "string" and selectedIds[itemId] then
                            local results = InvokeRemoteMulti(Remotes.RequestRemoveItem, model)
                            local ok = results and results[1]
                            local err = results and results[2]
                            if not ok and err then
                                notyuri("Func_AutoPickup: " .. tostring(err))
                            end
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
do
    local cfg = Modules.UpgradeConfig
    if cfg and cfg.Items then
        Tables.UpgradeList = {}
        Tables.UpgradeMap = {}
        for key, _ in pairs(cfg.Items) do
            table.insert(Tables.UpgradeList, key)
            Tables.UpgradeMap[key] = key
        end
        table.sort(Tables.UpgradeList)
    end
end
do
    local cfg = Modules.BuildingShopConfig
    if cfg then
        Tables.BuildingList = {}
        Tables.BuildingMap = {}
        for _, category in ipairs({ "Walls", "Floors" }) do
            for _, itemCfg in ipairs(cfg.GetAll(category)) do
                local name = itemCfg.Name
                local displayName = cfg.GetString(category, name, "displayName", name)
                local label = category .. " - " .. displayName
                table.insert(Tables.BuildingList, label)
                Tables.BuildingMap[label] = category .. "|" .. name
            end
        end
    end
end
do
    local Data = RS:FindFirstChild("Data")
    local Items = Data and Data:FindFirstChild("Items")
    if Items then
        Tables.ItemList = {}
        Tables.ItemMap = {}
        Tables.SpinItemList = {}
        Tables.SpinItemMap = {}
        Tables.PlaceItemList = {}
        Tables.PlaceItemMap = {}
        local rarityRank = {}
        for i, rarity in ipairs(Tables.RarityList) do
            rarityRank[rarity] = i
        end
        local itemEntries = {}
        local rollEntries = {}
        local placeEntries = {}
        for _, cfgInst in ipairs(Items:GetDescendants()) do
            if cfgInst:IsA("Configuration") then
                local itemId = cfgInst.Name
                local displayName = cfgInst:GetAttribute("name")
                local itemRarity = cfgInst:GetAttribute("rarity")
                local itemType = cfgInst:GetAttribute("type")
                local baseLabel = type(displayName) == "string" and displayName or itemId
                local label = type(itemRarity) == "string" and (baseLabel .. "[" .. itemRarity .. "]") or baseLabel
                local rank = (type(itemRarity) == "string" and rarityRank[itemRarity]) or math.huge
                local entry = { label = label, itemId = itemId, rank = rank }
                table.insert(itemEntries, entry)
                if itemType == "Box" then
                    table.insert(rollEntries, entry)
                end
                table.insert(placeEntries, entry)
            end
        end
        local function byRarityThenName(a, b)
            if a.rank ~= b.rank then return a.rank < b.rank end
            return a.label < b.label
        end
        table.sort(itemEntries, byRarityThenName)
        table.sort(rollEntries, byRarityThenName)
        table.sort(placeEntries, byRarityThenName)
        for _, entry in ipairs(rollEntries) do
            table.insert(Tables.ItemList, entry.label)
            Tables.ItemMap[entry.label] = entry.itemId
        end
        for _, entry in ipairs(itemEntries) do
            table.insert(Tables.SpinItemList, entry.label)
            Tables.SpinItemMap[entry.label] = entry.itemId
        end
        for _, entry in ipairs(placeEntries) do
            table.insert(Tables.PlaceItemList, entry.label)
            Tables.PlaceItemMap[entry.label] = entry.itemId
        end
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
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyWorker", { Text = "Auto Buy Worker", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoClean", { Text = "Auto Clean", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectCash", { Text = "Auto Collect Cash", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false })
Shared.GetSelectedRollItems = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "RollItemSelect", {
    Text = "Roll Item Select",
    Values = Tables.ItemList,
    Default = {},
    Searchable = true,
    label = Tables.ItemMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoEnableAutoSpin", { Text = "Auto Spin", Default = false })
Shared.GetSelectedSpinItems = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "SpinItemSelect", {
    Text = "Spin Item Select",
    Values = Tables.SpinItemList,
    Default = {},
    Searchable = true,
    label = Tables.SpinItemMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false })
Shared.GetSelectedPlaceItems = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PlaceItemSelect", {
    Text = "Place Item Select",
    Values = Tables.PlaceItemList,
    Default = {},
    Searchable = true,
    label = Tables.PlaceItemMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false })
Shared.GetSelectedPickupItems = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PickupItemSelect", {
    Text = "Pickup Item Select",
    Values = Tables.PlaceItemList,
    Default = {},
    Searchable = true,
    label = Tables.PlaceItemMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrades", Default = false })
Shared.GetSelectedUpgrades = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "UpgradeSelect", {
    Text = "Upgrade Select",
    Values = Tables.UpgradeList,
    Default = {},
    Searchable = true,
    label = Tables.UpgradeMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoExpand", { Text = "Auto Expand", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyBuilding", { Text = "Auto Buy Building", Default = false })
Shared.GetSelectedBuildings = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "BuildingSelect", {
    Text = "Building Select",
    Values = Tables.BuildingList,
    Default = {},
    Searchable = true,
    label = Tables.BuildingMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradeConveyor", { Text = "Auto Upgrade Conveyor", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoOpenLuckyBox", { Text = "Auto Open Lucky Box", Default = false })
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
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 1000 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 30, Rounding = 1 })
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
Toggles.AutoRebirth:OnChanged(function(state) Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), state) end)
Toggles.AutoUpgrade:OnChanged(function(state) Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state) end)
Toggles.AutoBuyWorker:OnChanged(function(state) Thread("AutoBuyWorker", SafeLoop("AutoBuyWorker", Func_AutoBuyWorker), state) end)
Toggles.AutoClean:OnChanged(function(state) Thread("AutoClean", SafeLoop("AutoClean", Func_AutoClean), state) end)
Toggles.AutoCollectCash:OnChanged(function(state) Thread("AutoCollectCash", SafeLoop("AutoCollectCash", Func_AutoCollectCash), state) end)
Toggles.AutoRoll:OnChanged(function(state) Thread("AutoRoll", SafeLoop("AutoRoll", Func_AutoRoll), state) end)
Toggles.AutoEnableAutoSpin:OnChanged(function(state) Thread("AutoEnableAutoSpin", SafeLoop("AutoEnableAutoSpin", Func_AutoSpin), state) end)
Toggles.AutoPlace:OnChanged(function(state) Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), state) end)
Toggles.AutoPickup:OnChanged(function(state) Thread("AutoPickup", SafeLoop("AutoPickup", Func_AutoPickup), state) end)
Toggles.AutoExpand:OnChanged(function(state) Thread("AutoExpand", SafeLoop("AutoExpand", Func_AutoExpand), state) end)
Toggles.AutoBuyBuilding:OnChanged(function(state) Thread("AutoBuyBuilding", SafeLoop("AutoBuyBuilding", Func_AutoBuyBuilding), state) end)
Toggles.AutoUpgradeConveyor:OnChanged(function(state) Thread("AutoUpgradeConveyor", SafeLoop("AutoUpgradeConveyor", Func_AutoUpgradeConveyor), state) end)
Toggles.AutoOpenLuckyBox:OnChanged(function(state) Thread("AutoOpenLuckyBox", SafeLoop("AutoOpenLuckyBox", Func_AutoOpenLuckyBox), state) end)
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
SaveManager:SetFolder("Yuri/MAP")
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