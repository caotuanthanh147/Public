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
local Modules = RS:FindFirstChild("Modules") or RS:WaitForChild("Modules", 15)
local Network = GetSafeModule(Modules, "Network")
if not Network then
    pcall(function()
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "send") and rawget(v, "fetch") and rawget(v, "c") then
                Network = v
                break
            end
        end
    end)
end
local function NetSend(name, ...)
    if not Network or type(Network.send) ~= "function" then return false end
    local args = table.pack(...)
    return pcall(function() Network.send(name, table.unpack(args, 1, args.n)) end)
end
local function NetFetch(name, ...)
    if not Network or type(Network.fetch) ~= "function" then return nil end
    local args = table.pack(...)
    local ok, res = pcall(function() return Network.fetch(name, table.unpack(args, 1, args.n)) end)
    if ok then return res end
    return nil
end
local function GetPlayerData()
    local pd = Plr:FindFirstChild("PlayerData")
    return pd
end
local function GetStats()
    local pd = GetPlayerData()
    if not pd then return nil end
    return pd:FindFirstChild("Stats")
end
local function GetMoney()
    local stats = GetStats()
    if not stats then return 0 end
    local money = stats:FindFirstChild("Money")
    return money and (tonumber(money.Value) or 0) or 0
end
local function GetRebirths()
    local pd = GetPlayerData()
    if not pd then return 0 end
    local rebirths = pd:FindFirstChild("Rebirths")
    return rebirths and (tonumber(rebirths.Value) or 0) or 0
end
local function Func_AutoMoney()
    while Toggles.AutoMoney.Value do
        NetSend("collect_all_pet_money")
        task.wait(3)
    end
end
local function Func_AutoClaimOffline()
    while Toggles.AutoClaimOffline.Value do
        NetSend("claimOffline")
        task.wait(60)
    end
end
local function Func_AutoGroupReward()
    while Toggles.AutoGroupReward.Value do
        NetSend("claim_group_reward")
        task.wait(120)
    end
end
local function Func_AutoIndex()
    while Toggles.AutoIndex.Value do
        for i = 1, 20 do
            if not Toggles.AutoIndex.Value then break end
            NetSend("claim_index_reward", i)
            task.wait(0.3)
        end
        task.wait(60)
    end
end
local function Func_AutoPickupAll()
    while Toggles.AutoPickupAll.Value do
        NetSend("pickupall")
        task.wait(2)
    end
end
local function Func_AutoEgg()
    while Toggles.AutoEgg.Value do
        NetSend("hatchegg_complete")
        task.wait(1)
    end
end
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
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
local RARITY_ORDER = {"Common","Uncommon","Rare","Epic","Legendary","Mythical","Godly","Secret","Divine","Celestial"}
local function GetRarityRank(rarity)
    return table.find(RARITY_ORDER, rarity) or 0
end
local function ResolveRarity(category, name)
    local folder = RS:FindFirstChild(category)
    local item   = folder and folder:FindFirstChild(name)
    local rv     = item and item:FindFirstChild("Rarity")
    return rv and rv:IsA("StringValue") and rv.Value ~= "" and rv.Value or "Common"
end
local function BuildEggList()
    local Pets = RS:FindFirstChild("Pets")
    if not Pets then return {"Any"} end
    local entries = {}
    for _, child in ipairs(Pets:GetChildren()) do
        local rarity = ResolveRarity("Pets", child.Name)
        table.insert(entries, { name = child.Name, rarity = rarity, rank = GetRarityRank(rarity) })
    end
    table.sort(entries, function(a, b)
        if a.rank ~= b.rank then return a.rank < b.rank end
        return a.name < b.name
    end)
    local list = {"Any"}
    for _, e in ipairs(entries) do
        table.insert(list, e.name .. " | " .. e.rarity)
    end
    return list
end
local function BuildCrateList()
    local ok, Chances = pcall(require, RS:WaitForChild("Chances"))
    if not ok then return {"Any"} end
    local entries = {}
    for _, pool in ipairs({ {Chances.Blocks, "Blocks"}, {Chances.Defenses, "Defenses"} }) do
        local tbl, cat = pool[1], pool[2]
        if type(tbl) == "table" then
            for _, v in ipairs(tbl) do
                if v.Name then
                    local rarity = ResolveRarity(cat, v.Name)
                    table.insert(entries, { name = v.Name, rarity = rarity, rank = GetRarityRank(rarity) })
                end
            end
        end
    end
    table.sort(entries, function(a, b)
        if a.rank ~= b.rank then return a.rank < b.rank end
        return a.name < b.name
    end)
    local list = {"Any"}
    for _, e in ipairs(entries) do
        table.insert(list, e.name .. " | " .. e.rarity)
    end
    return list
end
local function GetMyPlot()
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return nil end
    for _, plot in ipairs(Plots:GetChildren()) do
        if plot:IsA("Model") and plot:GetAttribute("OwnerUserId") == Plr.UserId then
            return plot
        end
    end
    return nil
end
local function GetRollPad(stationModelName)
    local plot = GetMyPlot()
    if not plot then return nil end
    local station = plot:FindFirstChild(stationModelName)
    if not station then return nil end
    local carpet = station:FindFirstChild("EggCarpet")
    if not carpet then return nil end
    local button = carpet:FindFirstChild("Button")
    if not button then return nil end
    return button:FindFirstChild("Pad")
end
local function WaitForBuyWinnerPrompt(plotName, stationType, timeout)
    local revealName = "HATCH_REVEAL_" .. plotName .. "|" .. stationType
    local t0 = tick()
    while tick() - t0 < timeout do
        local reveal = workspace:FindFirstChild(revealName)
        if reveal then
            for _, desc in ipairs(reveal:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and desc.Name == "BuyWinnerPrompt" then
                    return desc
                end
            end
        end
        task.wait(0.1)
    end
    return nil
end
local function MatchesFilter(filterValue, itemName)
    if filterValue["Any"] then return true end
    for label, active in pairs(filterValue) do
        if active then
            local labelName = label:match("^(.+) | ") or label
            if labelName == itemName then return true end
        end
    end
    return false
end
local function Func_AutoRollEgg()
    while Toggles.AutoRollEgg.Value do
        local plot = GetMyPlot()
        if not plot then
            notyuri("[AutoRollEgg] No plot found")
            task.wait(1)
        else
            local pad = GetRollPad("EggModel")
            if not pad then
                notyuri("[AutoRollEgg] EggModel Pad not found")
                task.wait(1)
            else
                local rollPrompt = pad:FindFirstChildOfClass("ProximityPrompt")
                if not rollPrompt then
                    notyuri("[AutoRollEgg] Roll ProximityPrompt not found on Pad")
                    task.wait(1)
                else
                    notyuri("[AutoRollEgg] Firing roll")
                    FirePP(rollPrompt, true)
                    local claimPrompt = WaitForBuyWinnerPrompt(plot.Name, "Egg", 8)
                    if claimPrompt then
                        local itemName = claimPrompt.ObjectText
                        local filter   = Options.EggSelected.Value
                        local anySelected = next(filter) ~= nil
                        if not anySelected or MatchesFilter(filter, itemName) then
                            notyuri("[AutoRollEgg] Claiming:", itemName)
                            FirePP(claimPrompt, true)
                        else
                            notyuri("[AutoRollEgg] Skipping:", itemName)
                        end
                        task.wait(0.5)
                    else
                        notyuri("[AutoRollEgg] Claim prompt timeout")
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end
local function Func_AutoRollCrate()
    while Toggles.AutoRollCrate.Value do
        local plot = GetMyPlot()
        if not plot then
            notyuri("[AutoRollCrate] No plot found")
            task.wait(1)
        else
            local pad = GetRollPad("CrateModel")
            if not pad then
                notyuri("[AutoRollCrate] CrateModel Pad not found")
                task.wait(1)
            else
                local rollPrompt = pad:FindFirstChildOfClass("ProximityPrompt")
                if not rollPrompt then
                    notyuri("[AutoRollCrate] Roll ProximityPrompt not found on Pad")
                    task.wait(1)
                else
                    notyuri("[AutoRollCrate] Firing roll")
                    FirePP(rollPrompt, true)
                    local claimPrompt = WaitForBuyWinnerPrompt(plot.Name, "Crate", 8)
                    if claimPrompt then
                        local itemName = claimPrompt.ObjectText
                        local filter   = Options.BlockSelected.Value
                        local anySelected = next(filter) ~= nil
                        if not anySelected or MatchesFilter(filter, itemName) then
                            notyuri("[AutoRollCrate] Claiming:", itemName)
                            FirePP(claimPrompt, true)
                        else
                            notyuri("[AutoRollCrate] Skipping:", itemName)
                        end
                        task.wait(0.5)
                    else
                        notyuri("[AutoRollCrate] Claim prompt timeout")
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end
local function Func_AutoSwing()
    while Toggles.AutoSwing.Value do
        NetSend("gear_swing")
        task.wait(1)
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
local function Func_AutoLock()
    while Toggles.AutoLock.Value do
        local plot = GetMyPlot()
        if not plot then
            notyuri("[AutoLock] No plot found")
            task.wait(5)
        else
            local lockModel = plot:FindFirstChild("Lock")
            local pad = lockModel and lockModel:FindFirstChild("Pad")
            local ti = pad and pad:FindFirstChild("TouchInterest")
            if not ti then
                notyuri("[AutoLock] Lock.Pad.TouchInterest not found")
                task.wait(5)
            else
                local state = lockModel:GetAttribute("LockState")
                if state == "Locked" or state == "Cooldown" then
                    notyuri("[AutoLock] already", state, "- waiting")
                    task.wait(3)
                else
                    notyuri("[AutoLock] firing lock")
                    FireTI(ti)
                    task.wait(2)
                end
            end
        end
    end
end
local function Func_AutoSteal()
    while Toggles.AutoSteal.Value do
        NetSend("steal_grab", nil)
        task.wait(0.5)
        NetSend("steal_hold_begin", nil)
        task.wait(1)
        NetSend("steal_hold_end", nil)
        task.wait(2)
    end
end
local function Func_AutoLuckRequest()
    while Toggles.AutoLuckRequest.Value do
        NetSend("server_luck_request")
        task.wait(30)
    end
end
local function Func_AutoLimitedStock()
    while Toggles.AutoLimitedStock.Value do
        NetSend("limited_stock_state_request")
        task.wait(30)
    end
end
local BOOSTS_CONFIG = {
    CashMultiplier = { upgrade = { basePrice = 50,  priceStep = 100,  priceAccel = 500  } },
    PetLuck        = { upgrade = { basePrice = 250, priceStep = 250,  priceAccel = 500  } },
    BlockLuck      = { upgrade = { basePrice = 250, priceStep = 250,  priceAccel = 1000 } },
}
local REBIRTH_COSTS = {
    50000, 190000, 2000000, 7000000, 25000000,
    95000000, 360000000, 1300000000, 4700000000, 17500000000, 65000000000
}
local function GetBoostLevel(boostName)
    local pd = GetPlayerData()
    local boosts = pd and pd:FindFirstChild("Boosts")
    local val = boosts and boosts:FindFirstChild(boostName)
    return (val and val:IsA("NumberValue")) and val.Value or 0
end
local function GetBoostUpgradeCost(boostName, currentLevel)
    local cfg = BOOSTS_CONFIG[boostName]
    if not cfg or not cfg.upgrade then return math.huge end
    local u = cfg.upgrade
    local lv = math.max(0, currentLevel)
    return math.floor(u.basePrice + u.priceStep * lv + u.priceAccel * lv * lv)
end
local REBIRTH_MAX = 11
local function GetRebirthCost(currentRebirths)
    local nextRebirth = currentRebirths + 1
    if nextRebirth > REBIRTH_MAX then return math.huge end
    return REBIRTH_COSTS[nextRebirth] or math.huge
end
local function Func_AutoUpgradeBoosts()
    while Toggles.AutoUpgradeBoosts.Value do
        local filter = Options.BoostSelected.Value
        local anySelected = next(filter) ~= nil
        local upgradedAny = false
        local money = GetMoney()
        for boostName, _ in pairs(BOOSTS_CONFIG) do
            if not Toggles.AutoUpgradeBoosts.Value then break end
            local label = boostName
            if not anySelected or filter[label] then
                local level = GetBoostLevel(boostName)
                local cost = GetBoostUpgradeCost(boostName, level)
                money = GetMoney()
                if cost ~= math.huge and money >= cost then
                    notyuri("[AutoUpgradeBoosts] Upgrading", boostName, "lvl", level, "cost", cost, "money", money)
                    NetSend("buy_boost_upgrade", boostName)
                    upgradedAny = true
                    task.wait(0.3)
                else
                    notyuri("[AutoUpgradeBoosts] Can't afford", boostName, "cost", cost, "money", money)
                end
            end
        end
        if not upgradedAny then
            task.wait(3)
        else
            task.wait(0.5)
        end
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        local rebirths = GetRebirths()
        if rebirths >= REBIRTH_MAX then
            notyuri("[AutoRebirth] Max rebirths reached")
            task.wait(10)
        else
            local cost = GetRebirthCost(rebirths)
            local money = GetMoney()
            if money >= cost then
                notyuri("[AutoRebirth] Rebirthing at rebirths", rebirths, "cost", cost, "money", money)
                NetSend("perform_rebirth")
                task.wait(1)
            else
                notyuri("[AutoRebirth] Can't afford rebirth cost", cost, "money", money)
                task.wait(2)
            end
        end
    end
end
local function GetPetBaseMPS(species)
    local Pets = RS:FindFirstChild("Pets")
    local petFolder = Pets and Pets:FindFirstChild(species)
    local mpsVal = petFolder and petFolder:FindFirstChild("MPS")
    if mpsVal and mpsVal:IsA("NumberValue") then
        return mpsVal.Value
    end
    return 0
end
local function GetUpgradeCost(species, level)
    local baseMPS = GetPetBaseMPS(species)
    if baseMPS <= 0 then return math.huge end
    return math.floor(baseMPS * 7.5 * 3 ^ (math.max(1, level) - 1))
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local pd = GetPlayerData()
        local petsFolder = pd and pd:FindFirstChild("Pets")
        local equipped = petsFolder and petsFolder:FindFirstChild("Equipped")
        if not equipped then
            notyuri("[AutoUpgrade] No Equipped folder found")
            task.wait(3)
        else
            local money = GetMoney()
            local upgradedAny = false
            for _, slot in ipairs(equipped:GetChildren()) do
                if not Toggles.AutoUpgrade.Value then break end
                local nameVal = slot:FindFirstChild("Name")
                local levelVal = slot:FindFirstChild("Level")
                if nameVal then
                    local species = nameVal.Value
                    local level = levelVal and (tonumber(levelVal.Value) or 1) or 1
                    local cost = GetUpgradeCost(species, level)
                    money = GetMoney()
                    if money >= cost then
                        notyuri("[AutoUpgrade] Upgrading", species, "lvl", level, "cost", cost, "money", money)
                        NetSend("upgrade_pet", slot.Name)
                        upgradedAny = true
                        task.wait(0.3)
                    else
                        notyuri("[AutoUpgrade] Can't afford", species, "lvl", level, "cost", cost, "money", money)
                    end
                end
            end
            if not upgradedAny then
                task.wait(3)
            else
                task.wait(0.5)
            end
        end
    end
end
local function DoRebirth()
    NetSend("perform_rebirth")
    Library:Notify("Rebirth fired.", 3)
end
local function DoCollectPetMoney()
    NetSend("collect_all_pet_money")
    Library:Notify("Collected all pet money.", 3)
end
local function DoClaimOffline()
    NetSend("claimOffline")
    Library:Notify("Offline earnings claimed.", 3)
end
local function DoClaimGroupReward()
    NetSend("claim_group_reward")
    Library:Notify("Group reward claimed.", 3)
end
local function DoPickupAll()
    NetSend("pickupall")
    Library:Notify("Picked up all blocks.", 3)
end
local function DoHatchEgg()
    NetSend("hatchegg_complete")
    Library:Notify("Egg hatch fired.", 3)
end
local function DoServerLuck()
    local res = NetFetch("server_luck_request")
    Library:Notify("Server luck requested.", 3)
end
local function DoLimitedStockRequest()
    NetSend("limited_stock_state_request")
    Library:Notify("Limited stock state requested.", 3)
end
local function DoClaimAllIndex()
    for i = 1, 20 do
        NetSend("claim_index_reward", i)
        task.wait(0.2)
    end
    Library:Notify("Claimed all index rewards.", 4)
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
local GRID_SIZE = 4
local BUILD_SAVE_FOLDER = "Yuri/BuildABaseAndSteal/Build"
local function CFrameToTable(cf)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function TableToCFrame(t)
    if type(t) ~= "table" or #t < 12 then return CFrame.new() end
    return CFrame.new(t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
end
local function GetPlotCFrameOf(plot)
    if not plot then return nil end
    local base = plot:FindFirstChild("Base")
    if base then return base.CFrame end
    if plot:IsA("Model") then return plot:GetPivot() end
    return nil
end
local function GetMyPlotCFrame()
    return GetPlotCFrameOf(GetMyPlot())
end
local function GetMyInventory()
    local pd = Plr:FindFirstChild("PlayerData")
    if not pd then return {} end
    local inv = pd:FindFirstChild("Inventory")
    if not inv then return {} end
    local out = {}
    for _, v in ipairs(inv:GetChildren()) do
        if v:IsA("NumberValue") then out[v.Name] = v.Value end
    end
    return out
end
local function GetMyItemCount(itemName)
    local pd = Plr:FindFirstChild("PlayerData")
    if not pd then return 0 end
    local inv = pd:FindFirstChild("Inventory")
    if not inv then return 0 end
    local v = inv:FindFirstChild(itemName)
    return v and v.Value or 0
end
local function GetAllPlots()
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return {} end
    local out = {}
    local myPlot = GetMyPlot()
    for _, plot in ipairs(Plots:GetChildren()) do
        if plot:IsA("Model") then
            local ownerUserId = plot:GetAttribute("OwnerUserId")
            if ownerUserId then
                local ownerName = "Unknown"
                pcall(function()
                    local player = game:GetService("Players"):GetPlayerByUserId(ownerUserId)
                    if player then ownerName = player.Name end
                end)
                table.insert(out, { plot = plot, ownerName = ownerName, isOurs = (plot == myPlot) })
            end
        end
    end
    return out
end
local function GetPlacedBlocksFromPlot(plot)
    if not plot then return {} end
    local builds = plot:FindFirstChild("Builds")
    if not builds then return {} end
    local blocks = {}
    for _, child in ipairs(builds:GetChildren()) do
        if child:IsA("Model") then
            local itemType = child:GetAttribute("ItemType") or child.Name
            local pp = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
            local cf = pp and pp.CFrame or child:GetPivot()
            local rot = child:GetAttribute("Rotation") or 0
            table.insert(blocks, { name = itemType, cf = cf, rotation = rot })
        end
    end
    return blocks
end
local function SerializeBlocks(blocks, plotCF)
    if not plotCF or #blocks == 0 then return nil end
    local relative = plotCF:Inverse()
    local data = { version = 1, count = #blocks, blocks = {} }
    for _, b in ipairs(blocks) do
        local relCF = relative * b.cf
        table.insert(data.blocks, { name = b.name, cf = CFrameToTable(relCF), rotation = b.rotation or 0 })
    end
    return HttpService:JSONEncode(data)
end
local function DoPlace(itemName, targetCF, rotation)
    rotation = rotation or 0
    NetSend("placeblock", itemName, targetCF, { rotation = rotation, flipped = 0, shape = "Block" })
end
local function CopyBuildToJSON()
    local plot = GetMyPlot()
    local plotCF = GetPlotCFrameOf(plot)
    if not plotCF then return nil end
    local blocks = GetPlacedBlocksFromPlot(plot)
    if #blocks == 0 then return nil end
    return SerializeBlocks(blocks, plotCF)
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
        local n = entry.name
        if n then reqs[n] = (reqs[n] or 0) + 1 end
    end
    return reqs
end
local function ComputeMissingMaterials(reqs)
    local inv = GetMyInventory()
    local missing = {}
    local parts = {}
    for itemName, need in pairs(reqs) do
        local have = inv[itemName] or 0
        if have < need then
            local short = need - have
            missing[itemName] = short
            table.insert(parts, itemName .. "(x" .. short .. ")")
        end
    end
    table.sort(parts)
    local display = #parts == 0 and "Ready" or ("Missing: " .. table.concat(parts, ", "))
    return missing, display
end
local MatLabel = nil
local RefreshMat
local _buildSourcesLookup = {}
local LoadSource
local function UpdateMaterialLabel()
    if not MatLabel then return end
    local data = LoadSource and LoadSource()
    if not data then
        MatLabel:SetText("No build selected.")
        return
    end
    local reqs = GetBuildRequirements(data)
    local _, display = ComputeMissingMaterials(reqs)
    MatLabel:SetText(display)
end
LoadSource = function()
    local sel = Options.SourceDD and Options.SourceDD.Value
    if not sel or sel == "" then
        Library:Notify("Select a plot or file first.", 3)
        return nil
    end
    local entry = _buildSourcesLookup[sel]
    if not entry then
        Library:Notify("Unknown source: " .. sel, 4)
        return nil
    end
    if entry.type == "plot" then
        local blocks = GetPlacedBlocksFromPlot(entry.plot)
        if #blocks == 0 then
            Library:Notify("That plot has no placed blocks.", 4)
            return nil
        end
        local plotCF = GetPlotCFrameOf(entry.plot)
        if not plotCF then return nil end
        local json = SerializeBlocks(blocks, plotCF)
        return LoadBuildJSON(json)
    elseif entry.type == "file" then
        local path = BUILD_SAVE_FOLDER .. "/" .. entry.name .. ".json"
        if not isfile or not isfile(path) then return nil end
        local ok, fileContent = pcall(readfile, path)
        if not ok then return nil end
        return LoadBuildJSON(fileContent)
    end
    return nil
end
local function SaveBuild(saveName)
    if not saveName or saveName == "" then
        Library:Notify("Enter a file name first.", 3)
        return
    end
    if not Support.FileIO then
        Library:Notify("File IO not supported by executor.", 4)
        return
    end
    local json = CopyBuildToJSON()
    if not json then
        Library:Notify("No placed items found to save.", 4)
        return
    end
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    pcall(function()
        if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
        writefile(path, json)
    end)
    Library:Notify("Build saved: " .. saveName, 5)
    if RefreshMat then RefreshMat() end
end
local function LoadBuildFromFile(saveName)
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    if not isfile or not isfile(path) then return nil end
    local ok, content = pcall(readfile, path)
    if not ok then return nil end
    return LoadBuildJSON(content)
end
RefreshMat = function()
    if not Options.SourceDD then return end
    local plots = GetAllPlots()
    local files = ListBuildFiles()
    local values = {}
    _buildSourcesLookup = {}
    for _, p in ipairs(plots) do
        local prefix = p.isOurs and "[My Plot] " or "[Plot] "
        local display = prefix .. p.ownerName
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "plot", plot = p.plot }
    end
    for _, fname in ipairs(files) do
        local display = "[File] " .. fname
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "file", name = fname }
    end
    Options.SourceDD:SetValues(values)
end
local function LoadBuild()
    local data = LoadSource()
    if not data then
        Library:Notify("Select a build file first.", 3)
        return
    end
    local targetPlot = GetMyPlot()
    local plotCF = GetPlotCFrameOf(targetPlot)
    if not plotCF then
        Library:Notify("No plot found.", 4)
        return
    end
    local plot = targetPlot
    if not plot then
        Library:Notify("No plot found.", 4)
        return
    end
    local ConfirmRad = 0.5
    local MaxPending = 5
    local Timeout = 0.5
    local MaxRetries = 2
    local pending = {}
    local placed, skipped, confirmed = 0, 0, 0
    notyuri("[LoadBuild] starting, blocks:", #data.blocks, "plotCF:", tostring(plotCF.Position))
    local builds = plot:FindFirstChild("Builds")
    local conn = builds and builds.ChildAdded:Connect(function(child)
        if not child:IsA("Model") then return end
        local pivotPos = child:GetPivot().Position
        for i, p in ipairs(pending) do
            if child.Name == p.itemName and (pivotPos - p.Position).Magnitude < ConfirmRad then
                local dist = (pivotPos - p.Position).Magnitude
                table.remove(pending, i)
                confirmed = confirmed + 1
                notyuri("[LoadBuild] confirmed:", child.Name, "dist:", string.format("%.2f", dist), "pending:", #pending)
                break
            end
        end
    end)
    for idx, entry in ipairs(data.blocks) do
        if not Toggles.LoadBuild.Value then
            notyuri("[LoadBuild] toggle off, stopping at block", idx)
            break
        end
        local itemName = entry.name
        local count = GetMyItemCount(itemName)
        if count > 0 then
            local relCF = TableToCFrame(entry.cf)
            local worldCF = plotCF * relCF
            local rotation = entry.rotation or 0
            notyuri("[LoadBuild] placing", itemName, "block", idx, "pos:", tostring(worldCF.Position), "inv:", count)
            table.insert(pending, { Position = worldCF.Position, itemName = itemName, cf = worldCF, rotation = rotation, retries = 0 })
            DoPlace(itemName, worldCF, rotation)
            placed = placed + 1
            local t0 = tick()
            while #pending > MaxPending do
                if tick() - t0 > Timeout then
                    local oldest = table.remove(pending, 1)
                    if oldest.retries < MaxRetries then
                        oldest.retries = oldest.retries + 1
                        notyuri("[LoadBuild] throttle timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
                        DoPlace(oldest.itemName, oldest.cf, oldest.rotation)
                        table.insert(pending, oldest)
                    else
                        notyuri("[LoadBuild] throttle timeout, giving up on", oldest.itemName)
                    end
                    t0 = tick()
                end
                task.wait()
            end
        else
            notyuri("[LoadBuild] skipping", itemName, "block", idx, "- no inventory")
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
                notyuri("[LoadBuild] drain timeout, retrying", oldest.itemName)
                DoPlace(oldest.itemName, oldest.cf, oldest.rotation)
                table.insert(pending, oldest)
            else
                notyuri("[LoadBuild] drain timeout, giving up on", oldest.itemName)
            end
            t0 = tick()
        end
        task.wait()
    end
    if conn then conn:Disconnect() end
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
        setclipboard(json)
        Library:Notify("Build copied to clipboard.", 5)
    else
        Library:Notify("Clipboard not supported.", 4)
    end
end
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
A1:AddDropdown("SourceDD", {
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
do
    local function WatchInventory()
        local pd = Plr:FindFirstChild("PlayerData")
        if not pd then return end
        local inv = pd:FindFirstChild("Inventory")
        if not inv then return end
        for _, v in ipairs(inv:GetChildren()) do
            if v:IsA("NumberValue") then
                v.Changed:Connect(UpdateMaterialLabel)
            end
        end
        inv.ChildAdded:Connect(function(v)
            if v:IsA("NumberValue") then
                v.Changed:Connect(UpdateMaterialLabel)
            end
        end)
    end
    local pd = Plr:FindFirstChild("PlayerData")
    if pd then
        WatchInventory()
    else
        Plr.ChildAdded:Connect(function(child)
            if child.Name == "PlayerData" then
                task.wait()
                WatchInventory()
            end
        end)
    end
end
A1:AddButton({
    Text = "Buy Missing Items",
    Func = function()
        local data = LoadSource()
        if not data then Library:Notify("Select a build source first.", 3) return end
        local reqs = GetBuildRequirements(data)
        local missing, display = ComputeMissingMaterials(reqs)
        local anyMissing = false
        for _ in pairs(missing) do anyMissing = true break end
        if not anyMissing then Library:Notify("No missing items.", 4) return end
        local bought = 0
        for itemName, shortage in pairs(missing) do
            for _ = 1, shortage do
                NetSend("buy_block", itemName)
                bought = bought + 1
                task.wait(0.15)
            end
        end
        Library:Notify(("Buy Missing: bought %d items."):format(bought), 5)
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
                    LoadBuild()
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
        SaveBuild(Options.BuildSaveName and Options.BuildSaveName.Value or "")
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
        local data = LoadSource()
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
        notyuri("[SaveSelected] saved to", path)
        if RefreshMat then RefreshMat() end
    end,
})
RefreshMat()
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
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMoney", { Text = "Auto Money", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoIndex", { Text = "Auto Index", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRollEgg", { Text = "Auto Roll Egg", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRollCrate", { Text = "Auto Roll Blocks", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSwing", { Text = "Auto Swing", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradeBoosts", { Text = "Auto Upgrade Boosts", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoLock", { Text = "Auto Lock", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("BoostSelected", {
    Text       = "Boosts to Upgrade",
    Values     = { "PetLuck", "BlockLuck", "CashMultiplier" },
    Default    = { PetLuck = true, BlockLuck = true },
    Multi      = true,
    Searchable = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("EggSelected", {
    Text       = "Egg List",
    Values     = BuildEggList(),
    Default    = {},
    Multi      = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("BlockSelected", {
    Text       = "Block List",
    Values     = BuildCrateList(),
    Default    = {},
    Multi      = true,
    Searchable = true,
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
Toggles.AutoRebirth:OnChanged(function(v) Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v) end)
Toggles.AutoMoney:OnChanged(function(v) Thread("AutoMoney", SafeLoop("AutoMoney", Func_AutoMoney), v) end)
Toggles.AutoIndex:OnChanged(function(v) Thread("AutoIndex", SafeLoop("AutoIndex", Func_AutoIndex), v) end)
Toggles.AutoRollEgg:OnChanged(function(v) Thread("AutoRollEgg", SafeLoop("AutoRollEgg", Func_AutoRollEgg), v) end)
Toggles.AutoRollCrate:OnChanged(function(v) Thread("AutoRollCrate", SafeLoop("AutoRollCrate", Func_AutoRollCrate), v) end)
Toggles.AutoSwing:OnChanged(function(v) Thread("AutoSwing", SafeLoop("AutoSwing", Func_AutoSwing), v) end)
Toggles.AutoUpgrade:OnChanged(function(v) Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v) end)
Toggles.AutoUpgradeBoosts:OnChanged(function(v) Thread("AutoUpgradeBoosts", SafeLoop("AutoUpgradeBoosts", Func_AutoUpgradeBoosts), v) end)
Toggles.AutoRebirth:OnChanged(function(v) Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v) end)
Toggles.AutoLock:OnChanged(function(v) Thread("AutoLock", SafeLoop("AutoLock", Func_AutoLock), v) end)
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
SaveManager:SetFolder("Yuri/BuildABaseAndSteal")
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
