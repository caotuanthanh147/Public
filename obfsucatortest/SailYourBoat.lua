if getgenv().ayasemiyatongekissazumirisa then
    warn("yuri")
    return
end
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
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
local function yuri()
end
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
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
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
local UpgradeConfig = GetSafeModule(RS.GameInfo, "UpgradeConfig")
local FuelPlaceConfig = GetSafeModule(RS.GameInfo, "FuelPlaceConfig")
local BasePrestigeUpgradeConfig = GetSafeModule(RS.GameInfo, "BasePrestigeUpgradeConfig")
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
    if not fireproximityprompt then
        return
    end
    if not target or not target:IsA("ProximityPrompt") then
        return
    end
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
local BN_SUFFIX_LABELS = {}
local BN_SUFFIX_EXP    = {}
table.insert(BN_SUFFIX_LABELS, "1")
table.insert(BN_SUFFIX_EXP, 0)
local _bnSuffixes = {
    "K","M","B","T","Qa","Qi","Sx","Sp","Oc","No","Dc",
    "Ud","Dd","Td","Qad","Qid","Sxd","Spd","Ocd","Nod",
    "Vg","Uvg","Dvg","Tvg","Qavg","Qivg","Sxvg","Spvg","Ocvg","Novg",
    "Tg","Utg","Dtg","Ttg","Qatg","Qitg","Sxtg","Sptg","Octg","Notg",
    "Qag","Uqag","Dqag","Tqag","Qaqag","Qiqag","Sxqag","Spqag","Ocqag","Noqag",
    "Qig","Uqig","Dqig","Tqig","Qaqig","Qiqig","Sxqig","Spqig","Ocqig","Noqig",
    "Sg","Usg","Dsg","Tsg","Qasg","Qisg","Sxsg","Spsg","Ocsg","Nosg",
    "Og","Uog","Dog","Tog","Qaog","Qiog","Sxog","Spog","Ocog","Noog",
    "Ng","Ung","Dng","Tng","Qang","Qing","Sxng","Spng","Ocng","Nong",
    "Ct","Uct","Dct","Tct","Qact","Qict","Sxct","Spct","Occt","Noct","Cent",
}
for i, suffix in ipairs(_bnSuffixes) do
    table.insert(BN_SUFFIX_LABELS, suffix)
    table.insert(BN_SUFFIX_EXP, i * 3)
end
local function ParseSuffixedNumber(numStr, suffixLabel)
    local n = tonumber(numStr) or 1
    local exp = 0
    for i, lbl in ipairs(BN_SUFFIX_LABELS) do
        if lbl == suffixLabel then exp = BN_SUFFIX_EXP[i]; break end
    end
    return n * (10 ^ exp)
end
local function ParseXpText(text)
    if not text or text == "" then return 0 end
    local left = text:match("^([^/]+)") or text
    left = left:match("^%s*(.-)%s*$")
    left = left:gsub(",", "") 
    local numPart, suffixPart = left:match("^([%d%.]+)%s*([A-Za-z]*)")
    if not numPart then return 0 end
    local n = tonumber(numPart) or 0
    if suffixPart and suffixPart ~= "" then
        for i, lbl in ipairs(BN_SUFFIX_LABELS) do
            if suffixPart:sub(1, #lbl):lower() == lbl:lower() and lbl ~= "1" then
                return n * (10 ^ BN_SUFFIX_EXP[i])
            end
        end
    end
    return n
end
local minFuelXpThreshold = 0
local Knit = require(RS.Packages.Knit)
local FuelService    = nil
local BoatService    = nil
local BaseService    = nil
local UpgradeService = nil
local BasePrestigeUpgradeService = nil
local FuelPlaceService = nil
local DataController  = nil
local function InitServices()
    local ok, err = pcall(function()
        FuelService    = Knit.GetService("FuelService")
        BoatService    = Knit.GetService("BoatService")
        BaseService    = Knit.GetService("BaseService")
        UpgradeService = Knit.GetService("UpgradeService")
        BasePrestigeUpgradeService = Knit.GetService("BasePrestigeUpgradeService")
        FuelPlaceService = Knit.GetService("FuelPlaceService")
        DataController = Knit.GetController("DataController")
    end)
    if not ok then
        yuri("[SYB] InitServices error: " .. tostring(err))
    end
end
local isLaunching = false
task.delay(3, InitServices)
task.delay(3.5, function()
    if BoatService then
        if BoatService.LaunchStarted then
            BoatService.LaunchStarted:Connect(function()
                isLaunching = true
            end)
        end
        if BoatService.LaunchEnded then
            BoatService.LaunchEnded:Connect(function()
                isLaunching = false
            end)
        end
    end
end)
local function GetReplica()
    if not DataController then return nil end
    local ok, replica = pcall(function()
        return DataController:GetReplica()
    end)
    if ok then return replica end
    return nil
end
local function GetDropperXp(fuelInst)
    local fuelPlace = fuelInst.Parent
    while fuelPlace and not CollectionService:HasTag(fuelPlace, "FuelPlace") do
        fuelPlace = fuelPlace.Parent
    end
    if not fuelPlace then
        yuri("[AutoFuel][XP] Could not find FuelPlace ancestor for: " .. fuelInst:GetFullName())
        return nil
    end
    local FuelGUI = fuelPlace:FindFirstChild("FuelGUI", true)
    if not FuelGUI then
        yuri("[AutoFuel][XP] No FuelGUI found under: " .. fuelPlace:GetFullName())
        return nil
    end
    local Progress = FuelGUI:FindFirstChild("Progress")
    local TextLabel = Progress and Progress:FindFirstChild("TextLabel")
    if not TextLabel then
        yuri("[AutoFuel][XP] No Progress.TextLabel under FuelGUI at: " .. FuelGUI:GetFullName())
        return nil
    end
    local raw = TextLabel.Text
    local xp = ParseXpText(raw)
    yuri("[AutoFuel][XP] fuelPlace=" .. fuelPlace.Name
        .. " raw='" .. tostring(raw) .. "'"
        .. " parsed=" .. tostring(xp)
        .. " threshold=" .. tostring(minFuelXpThreshold))
    return xp
end
local function AutoFuelLoop()
    while true do
        task.wait(0.5)
        if not FuelService or not BoatService then task.wait(1) continue end
        if not _fuelHierarchyLogged then
            _fuelHierarchyLogged = true
            local fuels = CollectionService:GetTagged("Fuel")
            if fuels[1] then
                yuri("[AutoFuel][DEBUG] First Fuel path: " .. fuels[1]:GetFullName())
            else
                yuri("[AutoFuel][DEBUG] No Fuel instances found yet")
            end
        end
        for _, fuelInst in ipairs(CollectionService:GetTagged("Fuel")) do
            if not (fuelInst and fuelInst.Parent) then continue end
            local ownerUserId = fuelInst:GetAttribute("OwnerUserId")
            if ownerUserId ~= nil and ownerUserId ~= Plr.UserId then continue end
            if minFuelXpThreshold > 0 then
                local xp = GetDropperXp(fuelInst)
                if xp == nil or xp < minFuelXpThreshold then
                    task.wait(0.05)
                    continue
                end
            end
            local ok, err = pcall(function()
                FuelService:CollectFuel(fuelInst)
            end)
            if not ok then
                yuri("[AutoFuel] CollectFuel error: " .. tostring(err))
            end
            for _, boatInst in ipairs(CollectionService:GetTagged("Boat")) do
                if boatInst and boatInst.Parent then
                    local ok2, err2 = pcall(function()
                        BoatService:AddFuel(boatInst)
                    end)
                    if not ok2 then
                        yuri("[AutoFuel] AddFuel error: " .. tostring(err2))
                    end
                end
            end
            task.wait(0.05)
        end
    end
end
local function AutoLaunchLoop()
    while true do
        if not BoatService then task.wait(1) end
        if isLaunching then
            task.wait(0.5)
            continue
        end
        for _, launcher in ipairs(CollectionService:GetTagged("BoatLauncher")) do
            if launcher and launcher.Parent then
                if isLaunching then break end  
                local ok, err = pcall(function()
                    BoatService:Launch(launcher)
                end)
                if not ok then
                    yuri("[AutoLaunch] Launch error: " .. tostring(err))
                end
                task.wait()
            end
        end
    end
end
local function AutoUpgradeLoop()
    while true do
        if not UpgradeService or not BasePrestigeUpgradeService or not FuelPlaceService then
            task.wait(2)
            continue
        end
        local replica = GetReplica()
        local data = replica and replica.Data
        local prestigeUpgradesFolder = workspace:FindFirstChild("UnderwaterWorld")
            and workspace.UnderwaterWorld:FindFirstChild("PrestigeUpgrades")
        if prestigeUpgradesFolder and UpgradeConfig then
            local upgrades = data and data.Upgrades or {}
            for _, upgradeInst in ipairs(prestigeUpgradesFolder:GetChildren()) do
                if upgradeInst and upgradeInst.Parent then
                    local upgradeId = upgradeInst.Name
                    local cfg = UpgradeConfig.Upgrades and UpgradeConfig.Upgrades[upgradeId]
                    local maxLevel = cfg and cfg.MaxLevel or math.huge
                    local currentLevel = upgrades[upgradeId] or 0
                    if currentLevel >= maxLevel then
                        continue  
                    end
                    local ok, err = pcall(function()
                        UpgradeService:PurchaseUpgrade(upgradeInst)
                    end)
                    if not ok then
                        yuri("[AutoUpgrade] PurchaseUpgrade error: " .. tostring(err))
                    end
                    task.wait()
                end
            end
        elseif prestigeUpgradesFolder then
            for _, upgradeInst in ipairs(prestigeUpgradesFolder:GetChildren()) do
                if upgradeInst and upgradeInst.Parent then
                    local ok, err = pcall(function()
                        UpgradeService:PurchaseUpgrade(upgradeInst)
                    end)
                    if not ok then
                        yuri("[AutoUpgrade] PurchaseUpgrade error: " .. tostring(err))
                    end
                    task.wait()
                end
            end
        end
        local bpMaxLevel = (BasePrestigeUpgradeConfig and BasePrestigeUpgradeConfig.MAX_LEVEL) or 50
        local bpLevels = data and data.BasePrestigeUpgrades or {}
        for _, upgradeId in ipairs({"Money", "Fuel", "Speed"}) do
            local currentLevel = bpLevels[upgradeId] or 0
            if currentLevel >= bpMaxLevel then
                continue  
            end
            local ok, err = pcall(function()
                BasePrestigeUpgradeService:PurchaseUpgrade(upgradeId)
            end)
            if not ok then
                yuri("[AutoUpgrade] BasePrestigeUpgrade error (" .. upgradeId .. "): " .. tostring(err))
            end
            task.wait()
        end
        local cash = (data and data.Currencies and data.Currencies.Cash) or 0
        local fpMaxLevel = (FuelPlaceConfig and FuelPlaceConfig.MaxLevel) or math.huge
        for _, fuelPlace in ipairs(CollectionService:GetTagged("FuelPlace")) do
            if fuelPlace and fuelPlace.Parent then
                local fpLevel = fuelPlace:GetAttribute("FPLevel") or 1
                if fpLevel >= fpMaxLevel then
                    continue  
                end
                local configName = fuelPlace:GetAttribute("Config") or "FuelPlace1"
                local placeConfig = FuelPlaceConfig and FuelPlaceConfig[configName]
                local amount = 1
                if FuelPlaceConfig and placeConfig then
                    local maxAffordable = FuelPlaceConfig.GetMaxAffordable(fpLevel, placeConfig.Cost, cash)
                    if type(maxAffordable) == "number" then
                        amount = math.max(1, math.min(maxAffordable, fpMaxLevel - fpLevel))
                    end
                    if amount <= 0 then
                        continue  
                    end
                end
                local ok, err = pcall(function()
                    FuelPlaceService:LevelUp(fuelPlace, amount)
                end)
                if not ok then
                    yuri("[AutoUpgrade] FuelPlace LevelUp error: " .. tostring(err))
                end
                task.wait()
                local placeConfigForUpgrades = FuelPlaceConfig and FuelPlaceConfig[configName]
                local upgradeList = placeConfigForUpgrades and placeConfigForUpgrades.Upgrades
                if upgradeList then
                    for i = 1, #upgradeList do
                        local upgradeEntry = upgradeList[i]
                        local requiredLevel = upgradeEntry and upgradeEntry.RequiredLevel or 0
                        local currentFpLevel = fuelPlace:GetAttribute("FPLevel") or 1
                        if currentFpLevel >= requiredLevel then
                            local ok2, err2 = pcall(function()
                                FuelPlaceService:BuyUpgrade(fuelPlace, i)
                            end)
                            if not ok2 then
                                yuri("[AutoUpgrade] BuyUpgrade error (index " .. i .. "): " .. tostring(err2))
                            end
                            task.wait()
                        end
                    end
                end
            end
        end
    end
end
local function getPrestigeCost(prestigeLevel)
    return 1500000 * (prestigeLevel + 1) * (prestigeLevel + 1)
end
local function AutoRebirthLoop()
    while true do
        if not BaseService then task.wait(2) end
        local replica = GetReplica()
        if replica and replica.Data then
            local cash = (replica.Data.Currencies and replica.Data.Currencies.Cash) or 0
            local prestigeLevel = replica.Data.PrestigeLevel or 0
            local cost = getPrestigeCost(prestigeLevel)
            if cash >= cost then
                yuri("[AutoRebirth] Prestiging! Cash: " .. tostring(cash) .. " / Cost: " .. tostring(cost))
                local ok, err = pcall(function()
                    BaseService:Prestige()
                end)
                if not ok then
                    yuri("[AutoRebirth] Prestige error: " .. tostring(err))
                end
                task.wait(1)
            end
        end
    end
end
local function AutoBuyLoop()
    while true do
        if not BaseService then task.wait(2) continue end
        for _, buySign in ipairs(CollectionService:GetTagged("BuySign")) do
            if buySign and buySign.Parent then
                local ok, err = pcall(function()
                    BaseService:Buy(buySign)
                end)
                if not ok then
                    yuri("[AutoBuy] Buy error: " .. tostring(err))
                end
                task.wait()
            end
        end
    end
end
local function TryBuyFuelPlaceLevelUp()
    if not BaseService then
        Library:Notify("FuelPlaceService or BaseService not ready", 3)
        return
    end
    local ok1, baseName = BaseService:GetBaseName():await()
    if not ok1 or not baseName then
        yuri("[TryBuy] GetBaseName failed: " .. tostring(baseName))
        return
    end
    local Bases = workspace:FindFirstChild("Bases")
    local base = Bases and Bases:FindFirstChild(baseName)
    if not base then
        yuri("[TryBuy] Base not found: " .. tostring(baseName))
        return
    end
    local fuelPlace = base:FindFirstChild("FuelPlaces") and base.FuelPlaces:FindFirstChild("FuelPlace1")
    if not fuelPlace then
        yuri("[TryBuy] FuelPlace1 not found under base: " .. tostring(baseName))
        return
    end
    local ok, err = pcall(function()
        FuelPlaceService:LevelUp(fuelPlace, 0/0)
    end)
    if not ok then
        yuri("[TryBuy] LevelUp error: " .. tostring(err))
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
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Farm = Tabs.Main:AddLeftGroupbox("Autofarm"),
        },
        Right = {
            Misc = Tabs.Main:AddRightGroupbox("Misc"),
        },
    },
}
TB.Main.Left.Farm:AddToggle("AutoFuel", {
    Text = "Auto Add Fuel",
    Default = false,
    Callback = function(state)
        Thread("AutoFuel", SafeLoop("AutoFuel", AutoFuelLoop), state)
    end,
})
TB.Main.Left.Farm:AddInput("MinFuelXpNum", {
    Text = "Min Fuel XP",
    Default = "0",
    Placeholder = "e.g. 100",
    Callback = function(Value)
        local suffixVal = Options.MinFuelXpSuffix and Options.MinFuelXpSuffix.Value or "1"
        minFuelXpThreshold = ParseSuffixedNumber(Value, suffixVal)
    end,
})
TB.Main.Left.Farm:AddDropdown("MinFuelXpSuffix", {
    Text = "Scale",
    Values = BN_SUFFIX_LABELS,
    Default = "1",
    Multi = false,
    Callback = function(Value)
        local numVal = Options.MinFuelXpNum and Options.MinFuelXpNum.Value or "0"
        minFuelXpThreshold = ParseSuffixedNumber(numVal, Value)
    end,
})
TB.Main.Left.Farm:AddToggle("AutoLaunch", {
    Text = "Auto Launch Boat",
    Default = false,
    Callback = function(state)
        Thread("AutoLaunch", SafeLoop("AutoLaunch", AutoLaunchLoop), state)
    end,
})
TB.Main.Left.Farm:AddToggle("AutoUpgrade", {
    Text = "Auto Upgrade Everything",
    Default = false,
    Callback = function(state)
        Thread("AutoUpgrade", SafeLoop("AutoUpgrade", AutoUpgradeLoop), state)
    end,
})
TB.Main.Left.Farm:AddToggle("AutoRebirth", {
    Text = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        Thread("AutoRebirth", SafeLoop("AutoRebirth", AutoRebirthLoop), state)
    end,
})
TB.Main.Left.Farm:AddToggle("AutoBuy", {
    Text = "Auto Buy All",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy", SafeLoop("AutoBuy", AutoBuyLoop), state)
    end,
})
TB.Main.Right.Misc:AddButton({
    Text = "Inf Money",
    Func = function()
        TryBuyFuelPlaceLevelUp()
    end,
})
TB.Main.Right.Misc:AddLabel("Rebirth to get infinite mines or if your boat disappears.", true)
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
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/SailYourBoat")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
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
