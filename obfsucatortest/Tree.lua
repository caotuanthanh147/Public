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
local Remotes = {
    UpgradeInvoke = RS:WaitForChild("Remotes"):WaitForChild("Upgrades"):WaitForChild("Upgrade"),
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
local _RunClick = nil
local function GetRunClick()
    if _RunClick then return _RunClick end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then
        notyuri("[GetRunClick] getgc or getupvalues not available")
        return nil
    end
    local clientScript
    pcall(function()
        clientScript = Plr:WaitForChild("PlayerScripts", 3)
            :WaitForChild("Progression", 3):WaitForChild("ClientUpgradeHandler", 3)
    end)
    if not clientScript then
        notyuri("[GetRunClick] ClientUpgradeHandler not found")
        return nil
    end
    local ok, gc = pcall(getgc, false)
    if not ok or not gc then return nil end
    local UpgradesRemote = RS.Remotes.Upgrades
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" then continue end
        if not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or not env then continue end
        if rawget(env, "script") ~= clientScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or not uvs then continue end
        for _, uv in pairs(uvs) do
            if type(uv) == "function" and islclosureFn(uv) then
                local ok4, iuvs = pcall(dbgGetUpvals, uv)
                if not ok4 or not iuvs then continue end
                for _, iuv in pairs(iuvs) do
                    if typeof(iuv) == "Instance" and iuv == UpgradesRemote then
                        _RunClick = uv
                        return _RunClick
                    end
                end
            end
        end
    end
    notyuri("[GetRunClick] RunClick not found in GC")
    return nil
end
local ResetUpgrades = { ["RESET_RSC"] = true, ["RESET_PRS"] = true, ["1β"] = true }
local function MakeAutoResetFunc(toggleId, upgradeName, gainKey, thresholdId, label)
    return function()
        local EternityNum = require(RS.Libraries.EternityNum)
        local CurrencyGains = RS:WaitForChild("Temp"):WaitForChild("CurrencyGains")
        local Focused = RS:WaitForChild("Focused")
        local UpgradesFolder = workspace:WaitForChild("GameObjects"):WaitForChild("Upgrades")
        local LockedUpgrades = RS:WaitForChild("LockedUpgrades")
        while Toggles[toggleId].Value do
            local thresholdRaw = Options[thresholdId] and Options[thresholdId].Value or ""
            if thresholdRaw ~= "" then
                local ok, threshold = pcall(function() return EternityNum.convert(thresholdRaw) end)
                if ok and threshold then
                    local gainVal = CurrencyGains:FindFirstChild(gainKey)
                    if gainVal then
                        local ok2, gainNum = pcall(function() return EternityNum.fromString(gainVal.Value) end)
                        if ok2 and gainNum and EternityNum.meeq(gainNum, threshold) then
                            local rc = GetRunClick()
                            if rc then
                                local upgradeModel = UpgradesFolder:FindFirstChild(upgradeName)
                                    or LockedUpgrades:FindFirstChild(upgradeName)
                                if upgradeModel then
                                    notyuri("[" .. label .. "] threshold met, firing reset")
                                    Focused.Value = upgradeModel
                                    pcall(rc, "Upgrade", upgradeModel)
                                else
                                    notyuri("[" .. label .. "] model not found:", upgradeName)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(1)
        end
    end
end
local Func_AutoResetRSC = MakeAutoResetFunc("AutoResetRSC", "RESET_RSC", "data",    "ResetThresholdRSC", "AutoResetRSC")
local Func_AutoResetPRS = MakeAutoResetFunc("AutoResetPRS", "RESET_PRS", "prestige", "ResetThresholdPRS", "AutoResetPRS")
local Func_AutoResetBeta = MakeAutoResetFunc("AutoResetBeta", "1β",       "beta",    "ResetThresholdBeta", "AutoResetBeta")
local CubeRemote = RS.Remotes.Cube.ServerClick
local function Func_AutoCube()
    while Toggles.AutoCube.Value do
        pcall(function() CubeRemote:FireServer() end)
        task.wait(.01)
    end
end
local function Func_AutoWavelength()
    local Core = require(RS.Libraries.GameData.Progression.Core)
    local EternityNum = require(RS.Libraries.EternityNum)
    local ToggleWavelength = RS.Remotes.Core.ToggleWavelength
    local StatsWavelengths = RS:WaitForChild("Stats"):WaitForChild("Wavelengths")
    local energy = RS:WaitForChild("Stats"):WaitForChild("Currencies"):WaitForChild("energy")
    local FocusedWavelengths = RS:WaitForChild("Stats"):WaitForChild("FocusedWavelengths")
    while Toggles.AutoWavelength.Value do
        local switched = false
        for name, data in Core.Wavelengths do
            if not Toggles.AutoWavelength.Value then break end
            local waveVal = StatsWavelengths:FindFirstChild(name)
            if not waveVal then continue end
            if table.find(FocusedWavelengths.Value:split("/"), name) then continue end
            if EternityNum.le(energy.Value, data.EnergyRequirement) then continue end
            local allObtained = true
            for _, boost in ipairs(data.Boosts) do
                if EternityNum.le(waveVal.Value, boost.EnergyRequirement) then
                    allObtained = false
                    break
                end
            end
            if allObtained then continue end
            ToggleWavelength:FireServer(name)
            switched = true
            task.wait(1)
            break
        end
        if not switched then
            task.wait(1)
        end
    end
end
local function Func_AutoSwitchLayer()
    local GameState = RS:WaitForChild("GameState")
    GameState:WaitForChild("UpgLoaded")
    GameState:WaitForChild("DataLoaded")
    local Zone = RS:WaitForChild("Zone")
    local UpgradesStats = RS:WaitForChild("Stats"):WaitForChild("Upgrades")
    local UpgradesFolder = workspace:WaitForChild("GameObjects"):WaitForChild("Upgrades")
    local ModuleCache = {}
    while Toggles.AutoSwitchLayer.Value do
        local zoneName = Zone.Value
        if zoneName ~= "" then
            local zonePart = workspace.Zones:FindFirstChild(zoneName)
            if zonePart then
                local currentLayer = zonePart:GetAttribute("Layer") or 1
                local maxLayer = zonePart:GetAttribute("MaxLayer") or 1
                if currentLayer < maxLayer then
                    local allMaxed = true
                    for _, statVal in ipairs(UpgradesStats:GetChildren()) do
                        local name = statVal.Name
                        local upgradeModel = UpgradesFolder:FindFirstChild(name)
                        if not upgradeModel then continue end
                        local cfg = ModuleCache[name]
                        if cfg == nil then
                            local ok, m = pcall(require, upgradeModel:FindFirstChild("UpgradeConfig"))
                            cfg = (ok and m) or false
                            ModuleCache[name] = cfg
                        end
                        if not cfg then continue end
                        if not cfg.Area then continue end
                        if cfg.Area.name ~= zoneName or cfg.Area.layer ~= currentLayer then continue end
                        if Options.UpgradeBlacklist.Value[name] then continue end
                        local currentLevel = statVal.Value
                        local maximum = typeof(cfg.Maximum) == "function" and cfg.Maximum(currentLevel) or cfg.Maximum
                        if currentLevel < maximum then
                            allMaxed = false
                            break
                        end
                    end
                    if allMaxed then
                        zonePart:SetAttribute("Layer", currentLayer + 1)
                    end
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoBuyCore()
    local Core = require(RS.Libraries.GameData.Progression.Core)
    local EternityNum = require(RS.Libraries.EternityNum)
    local BuyRemote = RS.Remotes.Core.Buy
    local CoreUpgradesStats = RS:WaitForChild("Stats"):WaitForChild("CoreUpgrades")
    local energy = RS:WaitForChild("Stats"):WaitForChild("Currencies"):WaitForChild("energy")
    while Toggles.AutoBuyCore.Value do
        for name, data in Core.Upgrades do
            if not Toggles.AutoBuyCore.Value then break end
            local statVal = CoreUpgradesStats:FindFirstChild(name)
            if not statVal then continue end
            local currentLevel = statVal.Value
            local maximum = data.Maximum(currentLevel)
            if currentLevel >= maximum then continue end
            local cost = Core.Functions:Cost(currentLevel, data.BaseCost, data.ExpoCost)
            if cost > EternityNum.fromString(energy.Value) then continue end
            BuyRemote:FireServer(name, true)
            task.wait(0.1)
        end
        task.wait(0.5)
    end
end
local function CanBuyUpgrade(name, upgradesFolder, statsUpgrades, ModuleCache)
    local upgradeModel = upgradesFolder:FindFirstChild(name)
    if not upgradeModel then return false end
    local levelVal = statsUpgrades:FindFirstChild(name)
    if not levelVal then return false end
    local cfg = ModuleCache[name]
    if cfg == nil then
        local ok, m = pcall(require, upgradeModel:FindFirstChild("UpgradeConfig"))
        cfg = (ok and m) or false
        ModuleCache[name] = cfg
    end
    if not cfg then return false end
    local currentLevel = levelVal.Value
    local maximum = typeof(cfg.Maximum) == "function" and cfg.Maximum(currentLevel) or cfg.Maximum
    if currentLevel >= maximum then return false end
    return cfg.PrerequisiteCheck(currentLevel, maximum, Plr)
end
local function Func_AutoChallenge()
    local Pyramid = require(RS.Libraries.GameData.Progression.Pyramid)
    local StartChallenge = RS.Remotes.Pyramid.StartChallenge
    local ActiveChallenges = RS:WaitForChild("Stats"):WaitForChild("ActiveChallenges")
    while Toggles.AutoChallenge.Value do
        local sel = Options.ChallengeSelect.Value
        if sel and sel ~= "" then
            local active = ActiveChallenges.Value:split("/")
            if not table.find(active, sel) then
                local cfg = Pyramid.Challenges[sel]
                local isMaxed = cfg and Pyramid.Functions:GetChallengeLevel(sel, true) >= cfg.Max
                if not isMaxed then
                    StartChallenge:FireServer(sel)
                    notyuri(("[AutoChallenge] Started: %s"):format(sel))
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoRNG()
    local RollRemote = RS.Remotes.RNGMachine.Roll
    local RNGMachine = require(RS.Libraries.GameData.Progression.RNGMachine)
    while Toggles.AutoRNG.Value do
        local ok, auraKey, _, rarityNum = pcall(function()
            return RollRemote:InvokeServer()
        end)
        if ok and auraKey then
            local auraData = RNGMachine.Auras[auraKey]
            local auraName = auraData and auraData.Name or tostring(auraKey)
            local EternityNum = require(RS.Libraries.EternityNum)
            local rarityStr = rarityNum and ("1 in %s"):format(EternityNum.short(rarityNum)) or "?"
            if Toggles.EnableNotify.Value then
                Library:Notify(("%s — %s"):format(auraName, rarityStr), 4)
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoFish()
    local FishRemote = RS.Remotes.Fishing.Fish
    local CollectionService = game:GetService("CollectionService")
    local Fishing = require(RS.Libraries.GameData.Progression.Fishing)
    while Toggles.AutoFish.Value do
        local spawnPart = nil
        for _, part in ipairs(CollectionService:GetTagged("FishSpawn")) do
            if part:GetAttribute("Active") == 2 then
                spawnPart = part
                break
            end
        end
        if not spawnPart then
            notyuri("[AutoFish] No active FishSpawn found, waiting...")
            task.wait(1)
            continue
        end
        local rodTool = nil
        local char = Plr.Character
        local FishingTools = RS.Stats.FishingTools
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") and tool:GetAttribute("Tool") and FishingTools:FindFirstChild(tool.Name) then
                    rodTool = tool
                    break
                end
            end
        end
        if not rodTool then
            task.wait(1)
            continue
        end
        local spawnName = tostring(spawnPart:GetAttribute("SpawnName") or spawnPart.Name)
        local ok, fishEvent = pcall(function()
            return FishRemote:InvokeServer(rodTool, spawnPart)
        end)
        if not ok then
            notyuri(("[AutoFish] Fish:InvokeServer error: %s"):format(tostring(fishEvent)))
            task.wait(1)
            continue
        end
        if not fishEvent then
            notyuri("[AutoFish] Fish:InvokeServer returned nil (server rejected)")
            task.wait(1)
            continue
        end
        local done = false
        local reeling = false
        local v4 = nil  
        local v3seed = nil  
        local reelConn
        reelConn = fishEvent.OnClientEvent:Connect(function(eventName, ...)
            local args = table.pack(...)
            if eventName == "Done" or eventName == "Cancel" then
                if eventName == "Done" then
                    local itemKey = args[1]
                    local fishItem = itemKey and Fishing.Items[itemKey]
                    local rarityData = fishItem and Fishing.Rarities[fishItem.Rarity]
                    if fishItem then
                        local msg = ("Caught: %s [%s]"):format(
                            fishItem.DisplayName,
                            rarityData and rarityData.Name or "?"
                        )
                        notyuri("[AutoFish] " .. msg)
                        if Toggles.EnableNotify.Value then
                            Library:Notify(msg)
                        end
                    end
                end
                done = true
                reelConn:Disconnect()
            elseif eventName == "Reel" then
                if not reeling then
                    reeling = true
                    v3seed = args[3]
                    v4 = workspace:GetServerTimeNow()
                    local itemKey = args[4]
                    local fishItem = itemKey and Fishing.Items[itemKey]
                end
            elseif eventName == "ReelUpdate" then
                if args[4] and v3seed then
                    v3seed = math.max(v3seed, args[4])
                end
            end
        end)
        local waitStart = tick()
        while not reeling and not done and tick() - waitStart < 5 do
            task.wait(0.05)
        end
        if reeling then
            local timeout = tick() + 60
            while not done and tick() < timeout and Toggles.AutoFish.Value do
                local v2 = workspace:GetServerTimeNow() - v4 + 0.5
                pcall(function()
                    fishEvent:FireServer("ReelIn", v2)
                end)
                if v3seed then v3seed = v3seed + 1 end
                task.wait(0.05)
            end
        end
        if reelConn then
            pcall(function() reelConn:Disconnect() end)
        end
        task.wait(0.5)
    end
end
local function Func_AutoSellFish()
    local SellRemote = RS.Remotes.Fishing.Sell
    while Toggles.AutoSellFish.Value do
        local ok, success, msg = pcall(function()
            return SellRemote:InvokeServer("All", 1)
        end)
        if not ok then
            notyuri(("[AutoSellFish] Error: "..tostring(success)))
        elseif success then
            notyuri(("[AutoSellFish] "..tostring(msg)))
        end
        task.wait(5)
    end
end
local function Func_AutoUpgrade()
    local GameState = RS:WaitForChild("GameState")
    GameState:WaitForChild("UpgLoaded")
    GameState:WaitForChild("DataLoaded")
    Plr:WaitForChild("Loaded")
    notyuri("[AutoUpgrade] Game state ready, starting loop")
    local UpgradesStats = RS:WaitForChild("Stats"):WaitForChild("Upgrades")
    local Focused = RS:WaitForChild("Focused")
    local UpgradesFolder = workspace:WaitForChild("GameObjects"):WaitForChild("Upgrades")
    local ModuleCache = {}
    local rc
    repeat
        rc = GetRunClick()
        if not rc then
            notyuri("[AutoUpgrade] waiting for RunClick...")
            task.wait(1)
        end
    until rc or not Toggles.AutoUpgrade.Value
    if not rc then return end
    while Toggles.AutoUpgrade.Value do
        local statVals = UpgradesStats:GetChildren()
        for _, statVal in ipairs(statVals) do
            if not Toggles.AutoUpgrade.Value then break end
            local name = statVal.Name
            if ResetUpgrades[name] then continue end
            if Options.UpgradeBlacklist.Value[name] then continue end
            local upgradeModel = UpgradesFolder:FindFirstChild(name)
            if not upgradeModel then continue end
            if not CanBuyUpgrade(name, UpgradesFolder, UpgradesStats, ModuleCache) then continue end
            Focused.Value = upgradeModel
            pcall(rc, "Upgrade", upgradeModel)
            task.wait(.1)
        end
        task.wait(.1)
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
local function GetUpgradeNameList()
    local names = {}
    local statsUpgrades = RS:FindFirstChild("Stats") and RS.Stats:FindFirstChild("Upgrades")
    if statsUpgrades then
        for _, child in ipairs(statsUpgrades:GetChildren()) do
            table.insert(names, child.Name)
        end
        table.sort(names)
    end
    return names
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
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCube", { Text = "Auto Cube", Default = false })
Toggles.AutoCube:OnChanged(function(state)
    Thread("AutoCube", Func_AutoCube, state)
end)
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeBlacklist", {
    Text = "Upgrade Blacklist",
    Values = GetUpgradeNameList(),
    Multi = true,
    Searchable = true,
    Default = {},
})
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", Func_AutoUpgrade, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoWavelength", { Text = "Auto Wavelength", Default = false })
Toggles.AutoWavelength:OnChanged(function(state)
    Thread("AutoWavelength", Func_AutoWavelength, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoSwitchLayer", { Text = "Auto Switch Layer", Default = false })
Toggles.AutoSwitchLayer:OnChanged(function(state)
    Thread("AutoSwitchLayer", Func_AutoSwitchLayer, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyCore", { Text = "Auto Buy Core", Default = false })
Toggles.AutoBuyCore:OnChanged(function(state)
    Thread("AutoBuyCore", Func_AutoBuyCore, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoRNG", { Text = "Auto RNG", Default = false })
Toggles.AutoRNG:OnChanged(function(state)
    Thread("AutoRNG", Func_AutoRNG, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoFish", { Text = "Auto Fish", Default = false })
Toggles.AutoFish:OnChanged(function(state)
    Thread("AutoFish", Func_AutoFish, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoSellFish", { Text = "Auto Sell Fish", Default = false })
Toggles.AutoSellFish:OnChanged(function(state)
    Thread("AutoSellFish", Func_AutoSellFish, state)
end)
TB_Tabs.Autofarm2.T1:AddDropdown("ChallengeSelect", {
    Text = "Challenge",
    Values = { "credit_deduction", "environmentalism", "homefinder" },
    Default = "credit_deduction",
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoChallenge", { Text = "Auto Start Challenge", Default = false })
Toggles.AutoChallenge:OnChanged(function(state)
    Thread("AutoChallenge", Func_AutoChallenge, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoResetRSC", { Text = "Auto Research Reset", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("ResetThresholdRSC", { Text = "Research Reset Threshold", Default = "", ClearTextOnFocus = false })
Toggles.AutoResetRSC:OnChanged(function(state)
    Thread("AutoResetRSC", Func_AutoResetRSC, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoResetPRS", { Text = "Auto Prestige Reset", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("ResetThresholdPRS", { Text = "Prestige Reset Threshold", Default = "", ClearTextOnFocus = false })
Toggles.AutoResetPRS:OnChanged(function(state)
    Thread("AutoResetPRS", Func_AutoResetPRS, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoResetBeta", { Text = "Auto Beta Reset", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("ResetThresholdBeta", { Text = "Beta Reset Threshold", Default = "", ClearTextOnFocus = false })
Toggles.AutoResetBeta:OnChanged(function(state)
    Thread("AutoResetBeta", Func_AutoResetBeta, state)
end)
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
MenuGroup:AddToggle("EnableNotify", {
    Text = "Enable Notifications",
    Default = true,
})
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
SaveManager:SetFolder("Yuri/gamesname")
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