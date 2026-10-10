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
local RemotesFolder = RS:WaitForChild("Events"):WaitForChild("Remotes")
local Remotes = {
    Mine                = RemotesFolder:WaitForChild("Mine"),
    ToggleWave          = RemotesFolder:WaitForChild("ToggleWave"),
    Purchase            = RemotesFolder:WaitForChild("Purchase"),
    Button              = RemotesFolder:WaitForChild("Button"),
    Shop                = RemotesFolder:WaitForChild("Shop"),
    DailyDealsChanged   = RemotesFolder:WaitForChild("DailyDealsChanged"),
    ChampionEvent       = RemotesFolder:WaitForChild("ChampionEvent"),
    SetBuildSlot        = RemotesFolder:WaitForChild("SetBuildSlot"),
    BuildOpRequest      = RemotesFolder:WaitForChild("BuildOpRequest"),
    Upgrade             = RemotesFolder:WaitForChild("Upgrade"),
    Claim               = RemotesFolder:WaitForChild("Claim"),
    GetRewardState      = RemotesFolder:WaitForChild("GetRewardState"),
    BuyProduct          = RemotesFolder:WaitForChild("BuyProduct"),
    UpgradeStore_Get    = RemotesFolder:WaitForChild("UpgradeStore_Get"),
    UpgradeStore_Buy    = RemotesFolder:WaitForChild("UpgradeStore_Buy"),
    GetMerchantSnapshot = RemotesFolder:WaitForChild("GetMerchantSnapshot"),
    MerchantPurchaseCash= RemotesFolder:WaitForChild("MerchantPurchaseCash"),
    FreeRevive          = RemotesFolder:WaitForChild("FreeRevive"),
    ClearPlot           = RemotesFolder:WaitForChild("ClearPlot"),
    GetDailyDealsSnapshot = RemotesFolder:WaitForChild("GetDailyDealsSnapshot"),
    DailyDealClaim      = RemotesFolder:WaitForChild("DailyDealClaim"),
    GetWeaponState      = RemotesFolder:WaitForChild("GetWeaponState"),
    EquipWeapon         = RemotesFolder:WaitForChild("EquipWeapon"),
    GetToolState        = RemotesFolder:WaitForChild("GetToolState"),
    PurchaseTool        = RemotesFolder:WaitForChild("PurchaseTool"),
    QuarryUpgrade_Get   = RemotesFolder:WaitForChild("QuarryUpgrade_Get"),
    QuarryUpgrade_Buy   = RemotesFolder:WaitForChild("QuarryUpgrade_Buy"),
    Place               = RemotesFolder:WaitForChild("Place"),
    Delete              = RemotesFolder:WaitForChild("Delete"),
    GetBuildContext     = RemotesFolder:WaitForChild("GetBuildContext"),
    GetBuildInventory   = RemotesFolder:WaitForChild("GetBuildInventory"),
}
local Modules = {
    Stats       = GetSafeModule(RS:WaitForChild("Modules"), "Stats"),
    SwordStats  = GetSafeModule(RS:WaitForChild("Modules"), "SwordStats"),
    ShopCatalog = GetSafeModule(RS:WaitForChild("Modules"), "ShopCatalog"),
    PlayerData  = GetSafeModule(RS:WaitForChild("Modules"), "PlayerData"),
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
local function GetCash()
    local ls = Plr:FindFirstChild("leaderstats")
    local v = ls and ls:FindFirstChild("$")
    return v and v.Value or 0
end
local function GetTokens()
    local v = Plr:FindFirstChild("Tokens")
    return v and v.Value or 0
end
local function GetWaveNumber()
    local v = Plr:FindFirstChild("WaveVal")
    return v and v.Value or 0
end
local function IsWaveRunning()
    local wv = Plr:FindFirstChild("WaveVal")
    if not wv then return false end
    local prog = wv:FindFirstChild("Progress")
    local mx = wv:FindFirstChild("Max")
    if not prog or not mx then return false end
    return prog.Value > 0 and mx.Value > 0
end
local function GetPlotBase()
    local plotOV = Plr:FindFirstChild("Plot")
    if not plotOV then return nil end
    local v = plotOV.Value
    if typeof(v) == "Instance" then return v end
    return nil
end
local function GetPlotItemHolder()
    local base = GetPlotBase()
    if not base then return nil end
    return base:FindFirstChild("ItemHolder")
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local selected = Options.AutoUpgradeMode and Options.AutoUpgradeMode.Value or {}
        local doTowers  = selected["Placed Towers"]
        local doQuarry  = selected["Quarry"]
        local doCastle  = selected["Stats"]
        if doTowers then
            local holder = GetPlotItemHolder()
            local stats = Modules.Stats
            if holder and stats then
                for _, model in ipairs(holder:GetChildren()) do
                    if not Toggles.AutoUpgrade.Value then break end
                    if model:IsA("Model") then
                        local sok, info = pcall(stats.Get, model.Name)
                        if sok and info and info.Type == "Tower" and info.Next and info.Upgrade then
                            if GetCash() >= info.Upgrade then
                                pcall(function() Remotes.Upgrade:InvokeServer(model) end)
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
        end
        if doQuarry then
            local ok, snap = pcall(function() return Remotes.QuarryUpgrade_Get:InvokeServer() end)
            if ok and snap and snap.quarry and snap.quarry.nextCost then
                local cost = snap.quarry.nextCost.amount or math.huge
                if GetCash() >= cost then
                    pcall(function() Remotes.QuarryUpgrade_Buy:InvokeServer() end)
                end
            end
        end
        if doCastle then
            local castleSelected = Options.AutoUpgradeCastleStats and Options.AutoUpgradeCastleStats.Value or {}
            local ok, snap = pcall(function() return Remotes.UpgradeStore_Get:InvokeServer() end)
            if ok and snap and snap.upgrades then
                for name, info in pairs(snap.upgrades) do
                    if not Toggles.AutoUpgrade.Value then break end
                    if not castleSelected[name] then continue end
                    if info.nextCost and info.level < info.maxLevel then
                        if GetCash() >= info.nextCost.amount then
                            pcall(function() Remotes.UpgradeStore_Buy:InvokeServer(name) end)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
        task.wait(3)
    end
end
local function Func_AutoClaimRewards()
    while Toggles.AutoClaimRewards.Value do
        local ok, state = pcall(function() return Remotes.GetRewardState:InvokeServer() end)
        if ok and state then
            local highest = state.highestWave or 0
            local claimed = state.pass or {}
            for w = 5, highest, 5 do
                if not claimed[w] then
                    pcall(function() Remotes.Claim:InvokeServer({ type = "wave", tier = "normal", wave = w }) end)
                    task.wait(0.2)
                end
            end
            if state.ownsPremiumPass then
                local pClaimed = state.premium or {}
                for w = 5, highest, 5 do
                    if not pClaimed[w] then
                        pcall(function() Remotes.Claim:InvokeServer({ type = "wave", tier = "premium", wave = w }) end)
                        task.wait(0.2)
                    end
                end
            end
            pcall(function() Remotes.Claim:InvokeServer({ type = "playtimeAll" }) end)
            task.wait(0.2)
            if state.group and state.group.isInGroup and not state.group.claimed then
                pcall(function() Remotes.Claim:InvokeServer({ type = "group" }) end)
            end
        end
        task.wait(30)
    end
end
local function Func_AutoDailyDeals()
    while Toggles.AutoDailyDeals.Value do
        local tierMode = Options.DealOption and Options.DealOption.Value or "Tier1"
        local ok, snap = pcall(function() return Remotes.GetDailyDealsSnapshot:InvokeServer() end)
        if ok and snap and snap.tiers then
            for tierKey, info in pairs(snap.tiers) do
                if not Toggles.AutoDailyDeals.Value then break end
                local alreadyBought = info.cashBought and info.cashBought > 0
                if alreadyBought then continue end
                if tierKey == "Tier1" then
                    if tierMode == "Tier1" or tierMode == "All Tiers" then
                        pcall(function() Remotes.DailyDealClaim:InvokeServer(tierKey) end)
                    end
                else
                    local buyCash = (tierMode == tierKey) or tierMode == "All Tiers"
                    if buyCash and info.cashPrice and GetCash() >= info.cashPrice then
                        pcall(function() Remotes.DailyDealClaim:InvokeServer(tierKey) end)
                    end
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoMerchant()
    while Toggles.AutoMerchant.Value do
        local ok, snap = pcall(function() return Remotes.GetMerchantSnapshot:InvokeServer() end)
        if ok and snap and snap.items then
            local selectedItems = Options.AutoMerchantItems and Options.AutoMerchantItems.Value or {}
            local buyAll = not next(selectedItems) or selectedItems["Any"]
            for _, item in ipairs(snap.items) do
                if not Toggles.AutoMerchant.Value then break end
                if not buyAll and not selectedItems[item.name] then continue end
                if not item.owned and item.cashStockRemaining and item.cashStockRemaining > 0 then
                    local affordable = false
                    if item.currency == "Tokens" then
                        affordable = GetTokens() >= (item.price or math.huge)
                    else
                        affordable = GetCash() >= (item.price or math.huge)
                    end
                    if affordable then
                        for _ = 1, item.cashStockRemaining do
                            if not Toggles.AutoMerchant.Value then break end
                            local bok, res = pcall(function() return Remotes.MerchantPurchaseCash:InvokeServer(item.name) end)
                            if not (bok and res and res.ok) then break end
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
        task.wait(45)
    end
end
local function BuyShopList(list, selectedItems, stats, swordStats)
    for _, item in ipairs(list) do
        if not selectedItems[item.DisplayName] then continue end
        local id = item.Id
        if not id then continue end
        local price = nil
        local wsok, wstats = pcall(swordStats.Get, id)
        if wsok and wstats and wstats.Price then
            price = wstats.Price
        else
            local sok, tstats = pcall(stats.Get, id)
            if sok and tstats and tstats.Price then price = tstats.Price end
        end
        if price and price > 0 and GetCash() >= price then
            local count = tonumber(Options.AutoBuyShopCount and Options.AutoBuyShopCount.Value) or 1
            pcall(function() Remotes.Purchase:FireServer(id, count) end)
            task.wait(0.15)
        end
    end
end
local function Func_AutoBuyShop()
    while Toggles.AutoBuyShop.Value do
        local catalog = Modules.ShopCatalog
        local stats = Modules.Stats
        local swordStats = Modules.SwordStats
        if catalog and stats and swordStats then
            if catalog.GetRegularList then
                BuyShopList(catalog.GetRegularList(), Options.AutoBuyShopItems.Value, stats, swordStats)
            end
            if Toggles.AutoBuyShopDecorations.Value and catalog.GetDecorationList then
                BuyShopList(catalog.GetDecorationList(), Options.AutoBuyShopDecoItems.Value, stats, swordStats)
            end
            if Toggles.AutoBuyShopWeapons.Value and catalog.GetBlacksmithList then
                BuyShopList(catalog.GetBlacksmithList(), Options.AutoBuyShopWeaponItems.Value, stats, swordStats)
            end
        end
        task.wait(5)
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
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoUpgradeMode", {
    Text = "Upgrade List",
    Values = { "Placed Towers", "Quarry", "Stats" },
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("AutoUpgradeCastleStats", {
    Text = "Stats",
    Values = { "MaxUnits", "FlagDistance", "FlagHealth", "FlagRegen" },
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoClaimRewards", { Text = "Auto Claim Rewards", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDailyDeals", { Text = "Auto Daily Deals", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("DealOption", {
    Text = "Daily Deals List",
    Values = { "Tier1", "Tier2", "Tier3", "All Tiers" },
    Default = "Tier1",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoMerchant", { Text = "Auto Merchant Buy", Default = false })
do
    local merchantItemNames = {}
    local allStats = Modules.Stats and Modules.Stats.All and Modules.Stats.All()
    if allStats then
        for key, data in pairs(allStats) do
            if data.Price then
                merchantItemNames[#merchantItemNames + 1] = key
            end
        end
        table.sort(merchantItemNames)
        table.insert(merchantItemNames, 1, "Any")
    end
    TB_Tabs.Autofarm2.T1:AddDropdown("AutoMerchantItems", {
        Text = "Merchant Items to Buy",
        Values = merchantItemNames,
        Default = {},
        Multi = true,
        Searchable = true,
    })
end
do
    local catalog = Modules.ShopCatalog
    local function getDisplayNames(listFn)
        local names = {}
        if catalog and catalog[listFn] then
            for _, item in ipairs(catalog[listFn](catalog)) do
                names[#names + 1] = item.DisplayName
            end
        end
        return names
    end
    TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShop", { Text = "Auto Buy Units", Default = false })
    TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyShopItems", {
        Text = "Units to Buy",
        Values = getDisplayNames("GetRegularList"),
        Default = {},
        Multi = true,
        Searchable = true
    })
    TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShopDecorations", { Text = "Auto Buy Decorations", Default = false })
    TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyShopDecoItems", {
        Text = "Decorations to Buy",
        Values = getDisplayNames("GetDecorationList"),
        Default = {},
        Multi = true,
        Searchable = true,
    })
    TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShopWeapons", { Text = "Auto Buy Weapons", Default = false })
    TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyShopWeaponItems", {
        Text = "Weapons to Buy",
        Values = getDisplayNames("GetBlacksmithList"),
        Default = {},
        Multi = true,
        Searchable = true,
    })
end
TB_Tabs.Autofarm2.T1:AddInput("AutoBuyShopCount", {
    Text = "Buy Count",
    Default = "1",
    Placeholder = "Amount per item",
    Callback = function(Value)
    end,
})
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
Toggles.AutoUpgrade:OnChanged(function(v)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
end)
Toggles.AutoClaimRewards:OnChanged(function(v)
    Thread("AutoClaimRewards", SafeLoop("AutoClaimRewards", Func_AutoClaimRewards), v)
end)
Toggles.AutoDailyDeals:OnChanged(function(v)
    Thread("AutoDailyDeals", SafeLoop("AutoDailyDeals", Func_AutoDailyDeals), v)
end)
Toggles.AutoMerchant:OnChanged(function(v)
    Thread("AutoMerchant", SafeLoop("AutoMerchant", Func_AutoMerchant), v)
end)
Toggles.AutoBuyShop:OnChanged(function(v)
    Thread("AutoBuyShop", SafeLoop("AutoBuyShop", Func_AutoBuyShop), v)
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
local _cachedV16 = nil
local function getPlacementHandler()
    if _cachedV16 and type(_cachedV16) == "table" and type(_cachedV16.GetAvailableItemCount) == "function" then
        return _cachedV16
    end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then return nil end
    local targetScript = Plr:FindFirstChild("PlayerGui")
        and Plr.PlayerGui:FindFirstChild("Build")
        and Plr.PlayerGui.Build:FindFirstChild("InventoryHandler")
    if not targetScript then
        notyuri("[AutoBuild] InventoryHandler script not found")
        return nil
    end
    local ok, gc = pcall(getgc, false)
    if not ok or type(gc) ~= "table" then return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" then continue end
        if not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or type(env) ~= "table" then continue end
        if rawget(env, "script") ~= targetScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or type(uvs) ~= "table" then continue end
        for _, uv in ipairs(uvs) do
            if type(uv) == "table" and type(uv.GetAvailableItemCount) == "function" then
                _cachedV16 = uv
                notyuri("[AutoBuild] PlacementHandler (v16) extracted via upvalue")
                return _cachedV16
            end
        end
    end
    notyuri("[AutoBuild] Could not find PlacementHandler upvalue, falling back to snapshot count")
    return nil
end
local function getAvailableCount(itemName, fallbackCount)
    local v16 = getPlacementHandler()
    if v16 then
        local ok, result = pcall(function() return v16:GetAvailableItemCount(itemName) end)
        if ok and tonumber(result) then
            return math.max(0, math.floor(tonumber(result)))
        end
    end
    return fallbackCount or 0
end
local function DoPlace(itemName, targetCF)
    local ok, result = pcall(function()
        return Remotes.Place:InvokeServer(itemName, targetCF)
    end)
    notyuri("[AutoBuild] Place remote result:", tostring(result), "type:", typeof(result))
    return ok and (typeof(result) == "Instance" or result == true)
end
local KNOWN_MELEE = {"legionary", "paladin", "ironrevenant", "shieldgolem"}
local function getItemRole(itemName, stat)
    if not stat then return "other" end
    local t = stat.Type or ""
    if t == "WoodStructure" or t == "StoneStructure" or t:find("Structure") then
        return "structure"
    end
    if t == "Decoration" or t == "Prop" then
        return "decoration"
    end
    if t == "Tower" or t == "Champion" then
        local lname = itemName:lower()
        for _, m in ipairs(KNOWN_MELEE) do
            if lname:find(m, 1, true) then return "melee" end
        end
        local range = tonumber(stat.Range) or 999
        if range < 80 then return "melee" end
        return "ranged"
    end
    return "other"
end
local function getScore(role, stat)
    if not stat then return 0 end
    local dmg = tonumber(stat.Damage) or 0
    local spd = tonumber(stat.Speed) or 1
    local rng = tonumber(stat.Range) or 0
    local hp  = tonumber(stat.Health) or 0
    local dps = spd > 0 and dmg / spd or 0
    if role == "structure" then return hp end
    if role == "melee"     then return dmg end
    if role == "ranged"    then return dps * rng end
    return 0
end
local _rayParams = RaycastParams.new()
_rayParams.FilterType = Enum.RaycastFilterType.Exclude
_rayParams.FilterDescendantsInstances = { Plr.Character }
local function Ground(worldX, worldZ, fallbackY)
    local origin = Vector3.new(worldX, fallbackY + 500, worldZ)
    local result = workspace:Raycast(origin, Vector3.new(0, -1000, 0), _rayParams)
    if result then
        return result.Position.Y + 3
    end
    return fallbackY
end
local function makeSlots(plotCF, plotSize, flagWorldPos, spawnWorldPos)
    local plotCenter = plotCF.Position
    local fallbackY  = plotCF.Position.Y
    local toSpawnRaw = Vector3.new(spawnWorldPos.X - flagWorldPos.X, 0, spawnWorldPos.Z - flagWorldPos.Z)
    local toSpawn    = toSpawnRaw.Unit  
    local sideways   = Vector3.new(-toSpawn.Z, 0, toSpawn.X)  
    local flagOffset = (flagWorldPos - plotCenter)
    local flagFwd    = flagOffset:Dot(toSpawn)
    local flagSide   = flagOffset:Dot(sideways)
    local hw         = tonumber(Options.AutoBuildPlaceDistance and Options.AutoBuildPlaceDistance.Value) or 20
    local hd         = math.max(15, plotSize.Z / 2 - 3)
    local facingCF   = CFrame.lookAlong(Vector3.new(), toSpawn)
    local slots      = { structure = {}, melee = {}, ranged = {}, decoration = {}, other = {} }
    local wSpc = 2
    local uSpc = 3
    local wCols = math.floor(hw * 2 / wSpc)
    local uCols = math.floor(hw * 2 / uSpc)
    local function makeSlotCF(fwdDist, sideDist)
        local worldPos = plotCenter + toSpawn * (flagFwd + fwdDist) + sideways * (flagSide + sideDist)
        local y = Ground(worldPos.X, worldPos.Z, fallbackY)
        return CFrame.new(worldPos.X, y, worldPos.Z) * facingCF
    end
    local structFwdBase = 26
    for row = 0, 1 do
        for col = 0, wCols do
            local side = -hw + col * wSpc
            local fwd  = structFwdBase + row * wSpc
            slots.structure[#slots.structure + 1] = makeSlotCF(fwd, side)
        end
    end
    local meleeFwdBase = structFwdBase + 2 * wSpc + 6
    for row = 0, 2 do
        for col = 0, uCols do
            local side = -hw + col * uSpc
            local fwd  = meleeFwdBase + row * uSpc
            slots.melee[#slots.melee + 1] = makeSlotCF(fwd, side)
        end
    end
    local rangedFwdBase = meleeFwdBase + 3 * uSpc + 4
    for row = 0, 8 do
        for col = 0, uCols do
            local side = -hw + col * uSpc
            local fwd  = rangedFwdBase + row * uSpc
            if fwd <= hd then
                slots.ranged[#slots.ranged + 1] = makeSlotCF(fwd, side)
            end
        end
    end
    notyuri("[AutoBuild] makeSlots hw:", hw, "hd:", hd, "wCols:", wCols, "uCols:", uCols, "structFwdBase:", structFwdBase)
    for i = 0, 40 do
        local side = -hw + (i % (uCols + 1)) * uSpc
        local fwd  = rangedFwdBase + (8 + 1) * uSpc + math.floor(i / (uCols + 1)) * uSpc
        if fwd <= hd then
            slots.decoration[#slots.decoration + 1] = makeSlotCF(fwd, side)
            slots.other[#slots.other + 1]            = makeSlotCF(fwd + uSpc, side + 2)
        end
    end
    return slots
end
local BUILD_SAVE_FOLDER = "Yuri/CastleDefender/Build"
local RefreshBuildSourcesDropdown
local function CFrameToTable(cf)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function TableToCFrame(t)
    if type(t) ~= "table" or #t < 12 then return CFrame.new() end
    return CFrame.new(
        t[1], t[2], t[3], t[4], t[5], t[6],
        t[7], t[8], t[9], t[10], t[11], t[12]
    )
end
local function GetPlotPivot(plotBase)
    local base = plotBase or GetPlotBase()
    if not base then return nil end
    if base:IsA("Model") then return base:GetPivot() end
    if base:IsA("BasePart") then return base.CFrame end
    return nil
end
local function GetAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return {} end
    local out = {}
    local ourBase = GetPlotBase()
    for _, base in ipairs(plots:GetChildren()) do
        if base:IsA("Model") then
            local ownerName = "Unknown"
            pcall(function()
                local board = base:FindFirstChild("Board")
                local frame = board and board:FindFirstChild("Frame")
                local sg = frame and frame:FindFirstChild("SurfaceGui")
                local occ = sg and sg:FindFirstChild("Occupied")
                if occ and occ.Visible then
                    local un = occ:FindFirstChild("Username")
                    if un and un:IsA("TextLabel") and un.Text ~= "" then
                        ownerName = un.Text
                    end
                end
            end)
            table.insert(out, { base = base, ownerName = ownerName, isOurs = (base == ourBase) })
        end
    end
    return out
end
local function GetPlacedBlocksFromPlot(plotBase)
    if not plotBase then return {} end
    local holder = plotBase:FindFirstChild("ItemHolder")
    if not holder then return {} end
    local blocks = {}
    for _, model in ipairs(holder:GetChildren()) do
        if model:IsA("Model") then
            local cf = model:GetPivot()
            if cf then
                table.insert(blocks, { name = model.Name, cf = cf })
            end
        end
    end
    return blocks
end
local function GetPlacedBlocks()
    return GetPlacedBlocksFromPlot(GetPlotBase())
end
local function SerializeBlocks(blocks, plotBase)
    local plotCF = GetPlotPivot(plotBase)
    if not plotCF then return nil end
    if #blocks == 0 then return nil end
    local relative = plotCF:Inverse()
    local data = { version = 1, count = #blocks, blocks = {} }
    for _, b in ipairs(blocks) do
        local relCF = relative * b.cf
        table.insert(data.blocks, {
            name = b.name,
            cf = CFrameToTable(relCF),
        })
    end
    return HttpService:JSONEncode(data)
end
local function CopyBuildToJSON(plotBase)
    local blocks = GetPlacedBlocksFromPlot(plotBase)
    if #blocks == 0 then
        Library:Notify("No placed blocks found to copy.", 4)
        return nil
    end
    local json = SerializeBlocks(blocks, plotBase)
    notyuri("[CopyBuild] serialized", #blocks, "blocks")
    return json
end
local function GetBuildRequirements(data)
    local reqs = {}
    if type(data) ~= "table" or type(data.blocks) ~= "table" then return reqs end
    for _, entry in ipairs(data.blocks) do
        local n = entry.name
        if n then reqs[n] = (reqs[n] or 0) + 1 end
    end
    return reqs
end
local function GetInventoryItems()
    local invOk, inv = pcall(function() return Remotes.GetBuildInventory:InvokeServer() end)
    if invOk and inv and inv.ok and type(inv.items) == "table" then
        return inv.items
    end
    return {}
end
local function ComputeMissingMaterials(reqs, invItems)
    local missing = {}
    local parts = {}
    local v16 = getPlacementHandler()
    local baseReqs = {}
    for itemName, need in pairs(reqs) do
        local base = itemName:gsub("Lv%d+$", "")
        baseReqs[base] = (baseReqs[base] or 0) + need
    end
    local baseInvCount = {}
    for k, v in pairs(invItems) do
        local base = k:gsub("Lv%d+$", "")
        baseInvCount[base] = (baseInvCount[base] or 0) + (tonumber(v) or 0)
    end
    for base, need in pairs(baseReqs) do
        local have = 0
        if v16 then
            local ok, allStats = pcall(function() return Modules.Stats.All() end)
            if ok and type(allStats) == "table" then
                for name in pairs(allStats) do
                    if name:gsub("Lv%d+$", "") == base then
                        local okA, cnt = pcall(function() return v16:GetAvailableItemCount(name) end)
                        if okA and tonumber(cnt) then have = have + tonumber(cnt) end
                    end
                end
            else
                local okA, cnt = pcall(function() return v16:GetAvailableItemCount(base) end)
                if okA and tonumber(cnt) then have = tonumber(cnt) end
            end
        else
            have = baseInvCount[base] or 0
        end
        if have < need then
            local short = need - have
            missing[base] = short
            table.insert(parts, base .. "(x" .. short .. ")")
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
local function SaveBuildToFile(saveName)
    if not saveName or saveName == "" then
        Library:Notify("Enter a file name first.", 3)
        return
    end
    if not Support.FileIO then
        Library:Notify("File IO not supported by executor.", 4)
        return
    end
    local json = CopyBuildToJSON(GetPlotBase())
    if not json then return end
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    pcall(function()
        if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
        writefile(path, json)
    end)
    local count = tonumber(json:match('"count":(%d+)')) or 0
    Library:Notify(("Build saved to %s (%d blocks)"):format(saveName, count), 5)
    notyuri("[CopyBuild] saved to", path)
    RefreshBuildSourcesDropdown()
end
local function CopyBuildToClipboard()
    local json = CopyBuildToJSON(GetPlotBase())
    if not json then return end
    if setclipboard then
        pcall(setclipboard, json)
        Library:Notify(("Build copied to clipboard (%d chars)."):format(#json), 5)
    else
        Library:Notify("Clipboard not supported by executor.", 4)
    end
end
local function LoadBuildJSON(json)
    if not json or json == "" then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data) ~= "table" or type(data.blocks) ~= "table" then
        Library:Notify("Invalid build JSON.", 4)
        return nil
    end
    return data
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
local _buildSourcesLookup = {}
RefreshBuildSourcesDropdown = function()
    if not Options.BuildSourceDropdown then return end
    local plots = GetAllPlots()
    local files = ListBuildFiles()
    local values = {}
    _buildSourcesLookup = {}
    for _, p in ipairs(plots) do
        local prefix = p.isOurs and "[My Plot] " or "[Plot] "
        local display = prefix .. p.ownerName
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "plot", base = p.base, ownerName = p.ownerName }
    end
    for _, fname in ipairs(files) do
        local display = "[File] " .. fname
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "file", name = fname }
    end
    Options.BuildSourceDropdown:SetValues(values)
    notyuri("[CopyBuild] dropdown refreshed:", #values, "sources")
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
    if entry.type == "plot" then
        local blocks = GetPlacedBlocksFromPlot(entry.base)
        if #blocks == 0 then
            Library:Notify("That plot has no placed blocks.", 4)
            return nil
        end
        local json = SerializeBlocks(blocks, entry.base)
        return LoadBuildJSON(json)
    elseif entry.type == "file" then
        return LoadBuildFromFile(entry.name)
    end
    return nil
end
local MatLabel = nil
local function UpdateMaterialLabel()
    if not MatLabel then return end
    local data = LoadSelectedBuildSource()
    if not data then
        MatLabel:SetText("No build selected.")
        return
    end
    local reqs = GetBuildRequirements(data)
    local invItems = GetInventoryItems()
    local _, display = ComputeMissingMaterials(reqs, invItems)
    MatLabel:SetText(display)
    notyuri("[CopyBuild] material:", display)
end
local function ResolveBuildItemName(itemName, v16, invItems)
    if v16 then
        local ok, cnt = pcall(function() return v16:GetAvailableItemCount(itemName) end)
        if ok and tonumber(cnt) and tonumber(cnt) > 0 then return itemName end
    else
        if (tonumber(invItems[itemName]) or 0) > 0 then return itemName end
    end
    local baseName = itemName:match("^(.-)Lv%d+$")
    if not baseName then return nil end
    local candidates = {}
    if Modules.Stats then
        local ok, allStats = pcall(function() return Modules.Stats.All() end)
        if ok and type(allStats) == "table" then
            for name in pairs(allStats) do
                if name:match("^(.-)Lv%d+$") == baseName then
                    table.insert(candidates, name)
                end
            end
        end
    end
    table.sort(candidates, function(a, b)
        local la = tonumber(a:match("Lv(%d+)$")) or 0
        local lb = tonumber(b:match("Lv(%d+)$")) or 0
        return la > lb
    end)
    for _, candidate in ipairs(candidates) do
        if v16 then
            local ok, cnt = pcall(function() return v16:GetAvailableItemCount(candidate) end)
            if ok and tonumber(cnt) and tonumber(cnt) > 0 then
                notyuri("[LoadBuild] fallback", itemName, "->", candidate)
                return candidate
            end
        else
            if (tonumber(invItems[candidate]) or 0) > 0 then
                notyuri("[LoadBuild] fallback", itemName, "->", candidate)
                return candidate
            end
        end
    end
    return nil
end
local function RunBuildFromSelectedSource()
    local data = LoadSelectedBuildSource()
    if not data then return end
    local plotCF = GetPlotPivot()
    if not plotCF then
        Library:Notify("No plot found", 4)
        return
    end
    local holder = GetPlotItemHolder()
    local ConfirmRad = 3
    local MaxPending = 5
    local Timeout = 0.5
    local MaxRetries = 2
    local pending = {}
    local placed, skipped, confirmed = 0, 0, 0
    notyuri("[LoadBuild] starting, blocks:", #data.blocks, "plotCF:", tostring(plotCF.Position))
    local conn
    if holder then
        conn = holder.ChildAdded:Connect(function(child)
            if not child:IsA("Model") then
                notyuri("[LoadBuild] ChildAdded: ignored non-Model", child.ClassName, child.Name)
                return
            end
            local pp = child:WaitForChild("Primary", 1)
            if not pp then
                pp = child:FindFirstChildWhichIsA("BasePart")
                if pp then
                    notyuri("[LoadBuild] ChildAdded: no 'Primary', using BasePart", pp.Name, "pos:", tostring(pp.Position))
                else
                    notyuri("[LoadBuild] ChildAdded: Model", child.Name, "has no Primary or BasePart, skipping")
                    return
                end
            end
            local matched = false
            for i, p in ipairs(pending) do
                local dist = (pp.Position - p.Position).Magnitude
                if dist < ConfirmRad then
                    table.remove(pending, i)
                    confirmed = confirmed + 1
                    matched = true
                    notyuri("[LoadBuild] confirmed:", child.Name, "dist:", string.format("%.2f", dist), "pending:", #pending, "total confirmed:", confirmed)
                    break
                end
            end
            if not matched then
                notyuri("[LoadBuild] ChildAdded: no pending match for", child.Name, "at", tostring(pp.Position), "pending size:", #pending)
            end
        end)
    end
    local invItems = GetInventoryItems()
    for idx, entry in ipairs(data.blocks) do
        if not Toggles.LoadBuild.Value then
            notyuri("[LoadBuild] toggle off, stopping at block", idx)
            break
        end
        local itemName = entry.name
        local relCF = TableToCFrame(entry.cf)
        local worldCF = plotCF * relCF
        local v16 = getPlacementHandler()
        local actualName = ResolveBuildItemName(itemName, v16, invItems)
        if actualName then
            notyuri("[LoadBuild] placing", actualName, "block", idx, "pos:", tostring(worldCF.Position))
            table.insert(pending, { Position = worldCF.Position, itemName = actualName, cf = worldCF, retries = 0 })
            DoPlace(actualName, worldCF)
            placed = placed + 1
            local t0 = tick()
            while #pending > MaxPending do
                if tick() - t0 > Timeout then
                    local oldest = table.remove(pending, 1)
                    if oldest.retries < MaxRetries then
                        oldest.retries = oldest.retries + 1
                        notyuri("[LoadBuild] throttle timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
                        DoPlace(oldest.itemName, oldest.cf)
                        table.insert(pending, oldest)
                    else
                        notyuri("[LoadBuild] throttle timeout, giving up on", oldest.itemName, "after", MaxRetries, "retries")
                    end
                    t0 = tick()
                end
                task.wait()
            end
        else
            notyuri("[LoadBuild] skipping", itemName, "block", idx, "- not in inventory")
            skipped = skipped + 1
        end
    end
    notyuri("[LoadBuild] main loop done. placed:", placed, "skipped:", skipped, "confirmed:", confirmed, "pending:", #pending)
    local t0 = tick()
    while #pending > 0 do
        if tick() - t0 > Timeout then
            local oldest = table.remove(pending, 1)
            if oldest.retries < MaxRetries then
                oldest.retries = oldest.retries + 1
                notyuri("[LoadBuild] drain timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
                DoPlace(oldest.itemName, oldest.cf)
                table.insert(pending, oldest)
            else
                notyuri("[LoadBuild] drain timeout, giving up on", oldest.itemName, "after", MaxRetries, "retries")
            end
            t0 = tick()
        end
        task.wait()
    end
    if #pending == 0 then
        notyuri("[LoadBuild] all confirmed ok")
    end
    pending = {}
    if conn then conn:Disconnect() end
    Toggles.LoadBuild:SetValue(false)
    Library:Notify(("Build loaded: %d placed, %d skipped."):format(placed, skipped), 5)
    UpdateMaterialLabel()
end
local function RunAutoBuild()
    local ok, ctx = pcall(function()
        return Remotes.GetBuildContext:InvokeServer("Place")
    end)
    if not ok or type(ctx) ~= "table" or ctx.ok ~= true then
        notyuri("[AutoBuild] GetBuildContext failed:", tostring(ctx))
        return
    end
    notyuri("[AutoBuild] ctx.ok:", tostring(ctx.ok), "canPlace:", tostring(ctx.canPlace), "plot:", tostring(ctx.plot))
    if ctx.canPlace ~= true then
        return
    end
    local plot = ctx.plot
    if not plot or not plot.Size then
        return
    end
    local ok2, inv = pcall(function()
        return Remotes.GetBuildInventory:InvokeServer()
    end)
    notyuri("[AutoBuild] inv.ok:", tostring(inv and inv.ok), "items type:", type(inv and inv.items))
    if not ok2 or type(inv) ~= "table" or inv.ok ~= true or type(inv.items) ~= "table" then
        notyuri("[AutoBuild] GetBuildInventory failed:", tostring(inv))
        return
    end
    local Stats = Modules.Stats
    if not Stats then
        return
    end
    local buildItemsFilter = Options.AutoBuildItems and Options.AutoBuildItems.Value or { Any = true }
    local filterAny = buildItemsFilter["Any"]
    local byRole = { structure = {}, melee = {}, ranged = {}, decoration = {}, other = {} }
    for itemName, rawCount in pairs(inv.items) do
        local cnt = tonumber(rawCount) or 0
        if cnt <= 0 then continue end
        if not filterAny and not buildItemsFilter[itemName] then continue end
        local stat = Stats.Get(itemName)
        if not stat then continue end
        local role = getItemRole(itemName, stat)
        byRole[role][#byRole[role] + 1] = {
            name  = itemName,
            count = cnt,
            score = getScore(role, stat),
        }
    end
    for _, list in pairs(byRole) do
        table.sort(list, function(a, b) return a.score > b.score end)
    end
    local plotCF   = plot:GetPivot()
    local plotSize = plot.Size
    local base = ctx.base or plot.Parent
    local flagWorldPos  = nil
    local spawnWorldPos = nil
    if base then
        local flagModel = base:FindFirstChild("Flag")
        local zoneModel = base:FindFirstChild("Zone")
        local flagPrimary = flagModel and (flagModel:FindFirstChild("Primary") or flagModel:FindFirstChildWhichIsA("BasePart"))
        local spawnPart   = zoneModel and (zoneModel:FindFirstChild("SpawnZone") or zoneModel:FindFirstChildWhichIsA("BasePart"))
        if flagPrimary then
            flagWorldPos = flagPrimary.Position
            notyuri("[AutoBuild] flagWorldPos:", tostring(flagWorldPos))
        else
            notyuri("[AutoBuild] Flag Primary not found, using plot center as flag pos")
        end
        if spawnPart then
            spawnWorldPos = spawnPart.Position
            notyuri("[AutoBuild] spawnWorldPos:", tostring(spawnWorldPos))
        else
            notyuri("[AutoBuild] SpawnZone not found, using plot center offset as spawn pos")
        end
    end
    if not flagWorldPos then
        flagWorldPos = (plotCF * CFrame.new(0, 0, plotSize.Z / 2)).Position
    end
    if not spawnWorldPos then
        spawnWorldPos = (plotCF * CFrame.new(0, 0, -plotSize.Z / 2)).Position
    end
    local slots = makeSlots(plotCF, plotSize, flagWorldPos, spawnWorldPos)
    local roleOrder = {"structure", "melee", "ranged", "decoration", "other"}
    local totalPlaced = 0
    for _, role in ipairs(roleOrder) do
        if (role == "decoration" or role == "other") then continue end
        local slotIdx = 1
        for _, item in ipairs(byRole[role]) do
            local placed = 0
            while placed < item.count do
                if not Toggles.AutoBaseBuild.Value then
                    notyuri("[AutoBuild] Stopped by toggle")
                    return
                end
                if slotIdx > #slots[role] then
                    notyuri("[AutoBuild] Out of", role, "slots after", placed, "of", item.count, item.name)
                    break
                end
                local available = getAvailableCount(item.name, item.count - placed)
                if available <= 0 then
                    notyuri("[AutoBuild] No more available:", item.name)
                    break
                end
                local cf = slots[role][slotIdx]
                slotIdx = slotIdx + 1
                notyuri("[AutoBuild] Attempting Place:", item.name, "slot", slotIdx - 1, "cf", tostring(cf))
                local success = DoPlace(item.name, cf)
                if success then
                    placed = placed + 1
                    totalPlaced = totalPlaced + 1
                else
                    notyuri("[AutoBuild] Place failed for", item.name)
                end
                task.wait()
            end
        end
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoBaseBuild", {
    Text    = "Auto Base Build",
    Default = false,
    Callback = function(state)
        if state then
            local env = getfenv(1)
            local t = task.spawn(RunAutoBuild)
            Flags.AutoBaseBuild = t
            env._autobuild_thread = t
        else
            if Flags.AutoBaseBuild and typeof(Flags.AutoBaseBuild) == "thread" then
                task.cancel(Flags.AutoBaseBuild)
                Flags.AutoBaseBuild = nil
            end
            getfenv(1)._autobuild_thread = nil
        end
    end,
})
do
    local _cat = Modules.ShopCatalog
    local _allIds = { "Any" }
    if _cat then
        for _, listFn in ipairs({ "GetRegularList" }) do
            if _cat[listFn] then
                for _, item in ipairs(_cat[listFn](_cat)) do
                    if item.Id then
                        _allIds[#_allIds + 1] = item.Id
                    end
                end
            end
        end
    end
    table.sort(_allIds, function(a, b)
        if a == "Any" then return true end
        if b == "Any" then return false end
        return a < b
    end)
    TB_Tabs.Autofarm2.T1:AddInput("AutoBuildPlaceDistance", {
        Text = "Place Distance",
        Default = "20",
        Numeric = true,
        Callback = function(Value) end,
    })
    TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuildItems", {
        Text       = "Build Items",
        Values     = _allIds,
        Default    = { "Any" },
        Multi      = true,
        Searchable = true,
    })
end
A1:AddDropdown("BuildSourceDropdown", {
    Text = "Select Buid to Load",
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
    Text = "Buy Missing Items",
    Func = function()
        local data = LoadSelectedBuildSource()
        if not data then
            Library:Notify("Select a build source first.", 3)
            return
        end
        local reqs = GetBuildRequirements(data)
        local invItems = GetInventoryItems()
        local missing, display = ComputeMissingMaterials(reqs, invItems)
        local anyMissing = false
        for _ in pairs(missing) do anyMissing = true break end
        if not anyMissing then
            Library:Notify("No missing items.", 4)
            return
        end
        local catalog = Modules.ShopCatalog
        local baseToShopId = {}
        if catalog then
            for _, listFn in ipairs({ "GetRegularList", "GetDecorationList", "GetBlacksmithList" }) do
                if catalog[listFn] then
                    for _, item in ipairs(catalog[listFn](catalog)) do
                        if item.Id then
                            baseToShopId[item.Id] = item.Id
                            local base = item.Id:match("^(.-)Lv%d+$")
                            if base then
                                baseToShopId[base] = item.Id
                            end
                        end
                    end
                end
            end
        end
        local stats = Modules.Stats
        local swordStats = Modules.SwordStats
        local bought, failed, skipped = 0, 0, 0
        for itemName, shortage in pairs(missing) do
            local shopId = baseToShopId[itemName]
            if not shopId then
                local base = itemName:match("^(.-)Lv%d+$")
                if base then shopId = baseToShopId[base] end
            end
            if not shopId then
                warn("[BuyMissing] No shop entry found for:", itemName)
                skipped = skipped + 1
            else
                local price = nil
                if swordStats then
                    local ok, ws = pcall(swordStats.Get, shopId)
                    if ok and ws and ws.Price then price = ws.Price end
                end
                if not price and stats then
                    local ok, st = pcall(stats.Get, shopId)
                    if ok and st and st.Price then price = st.Price end
                end
                if not price or price <= 0 then
                    warn("[BuyMissing] No price found for:", shopId)
                    skipped = skipped + 1
                elseif GetCash() < price then
                    warn("[BuyMissing] Not enough cash for:", shopId, "need", price, "have", GetCash())
                    skipped = skipped + 1
                else
                    local ok2 = pcall(function() Remotes.Purchase:FireServer(shopId, shortage) end)
                    if ok2 then
                        bought = bought + shortage
                        warn("[BuyMissing] bought", shortage, "x", shopId, "(for", itemName .. ")")
                    else
                        failed = failed + 1
                        warn("[BuyMissing] purchase failed for:", shopId)
                    end
                    task.wait(0.15)
                end
            end
        end
        Library:Notify(("Buy Missing: +%d items, %d skipped, %d failed"):format(bought, skipped, failed), 5)
        UpdateMaterialLabel()
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
SaveManager:SetFolder("Yuri/CastleDefender")
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