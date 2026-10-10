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
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Shared = {}
local Tables = {
    UpgradeList = {"storagePalletStorageSize", "giantWokCookingSpeed", "giantWokQuality", "frontDeskAdvertising", "frontDeskSecondLine", "seedRollerLuckBoost", "seedRollerRollAmount", "backyardSprinklers", "backyardExpansion", "playerCarrySize", "backyardSecondFloorSprinklers"},
    UpgradeMap = {},
    CropRollLabelList = {},
    CropRollLabelToId = {},
    DroneKindList = {"farmer", "cook", "waiter"},
    ToolShopLabelList = {},
    ToolShopLabelToId = {},
    UseToolLabelList = {},
    UseToolLabelToId = {},
}
for _, id in ipairs(Tables.UpgradeList) do
    Tables.UpgradeMap[id] = id
end
local function GetNetModule(name)
    local net = RS:FindFirstChild("TS") and RS.TS:FindFirstChild("network")
    if not net then return nil end
    local mod = net:FindFirstChild(name)
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    return ok and result or nil
end
local ClientPlotState = (function()
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local ts = ps:FindFirstChild("TS")
    if not ts then return nil end
    local plots = ts:FindFirstChild("plots")
    if not plots then return nil end
    local mod = plots:FindFirstChild("client-plot-state")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    if ok and result then return result.ClientPlotState end
    return nil
end)()
local function GetPlotId()
    if not ClientPlotState then return nil end
    local ok, state = pcall(ClientPlotState.get)
    if ok and state and state.plotId then return state.plotId end
    return nil
end
local function GetLocalPlotRoot(plotId)
    if not plotId then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:GetAttribute("PlotId") == plotId or plot.Name == plotId then
            return plot
        end
    end
    return nil
end
local ClientSeedRollState = (function()
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local ts = ps:FindFirstChild("TS")
    if not ts then return nil end
    local seeds = ts:FindFirstChild("seeds")
    if not seeds then return nil end
    local mod = seeds:FindFirstChild("client-seed-roll-state")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    if ok and result then return result.ClientSeedRollState end
    return nil
end)()
local CropCatalog = (function()
    local ts = RS:FindFirstChild("TS")
    if not ts then return nil end
    local crops = ts:FindFirstChild("crops")
    if not crops or not crops:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, crops)
    if ok and result then return result.cropCatalog end
    return nil
end)()
local CropsModule = (function()
    local ts = RS:FindFirstChild("TS")
    if not ts then return nil end
    local crops = ts:FindFirstChild("crops")
    if not crops or not crops:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, crops)
    return ok and result or nil
end)()
if CropCatalog then
    local sortedCrops = {}
    for cropId, def in pairs(CropCatalog) do
        if not def.hidden then
            table.insert(sortedCrops, { cropId = cropId, def = def })
        end
    end
    table.sort(sortedCrops, function(a, b)
        return a.def.chanceOneIn < b.def.chanceOneIn
    end)
    for _, entry in ipairs(sortedCrops) do
        local label = entry.def.displayName .. " [1 in " .. tostring(entry.def.chanceOneIn) .. "]"
        table.insert(Tables.CropRollLabelList, label)
        Tables.CropRollLabelToId[label] = entry.cropId
    end
end
local ClientPlayerMoney = (function()
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local ts = ps:FindFirstChild("TS")
    if not ts then return nil end
    local playerData = ts:FindFirstChild("player-data")
    if not playerData then return nil end
    local mod = playerData:FindFirstChild("client-player-money")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    if ok and result then return result.clientPlayerMoney end
    return nil
end)()
local function GetPlayerMoney()
    if not ClientPlayerMoney then return nil end
    local ok, money = pcall(ClientPlayerMoney)
    if ok and type(money) == "number" then return money end
    return nil
end
local UpgradesModule = (function()
    local ts = RS:FindFirstChild("TS")
    if not ts then return nil end
    local mod = ts:FindFirstChild("upgrades")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    return ok and result or nil
end)()
local ClientPlayerUpgradeState = (function()
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local ts = ps:FindFirstChild("TS")
    if not ts then return nil end
    local upgrades = ts:FindFirstChild("upgrades")
    if not upgrades then return nil end
    local mod = upgrades:FindFirstChild("client-player-upgrades")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    if ok and result then return result.ClientPlayerUpgradeState end
    return nil
end)()
local CropTypesModule = (function()
    local ts = RS:FindFirstChild("TS")
    if not ts then return nil end
    local crops = ts:FindFirstChild("crops")
    if not crops then return nil end
    local mod = crops:FindFirstChild("types")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    return ok and result or nil
end)()
local SproutPositionModule = (function()
    local ts = RS:FindFirstChild("TS")
    if not ts then return nil end
    local plots = ts:FindFirstChild("plots")
    if not plots then return nil end
    local mod = plots:FindFirstChild("sprout-position-cache")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    return ok and result or nil
end)()
local GAME_CONFIG = (function()
    local ts = RS:FindFirstChild("TS")
    if not ts then return nil end
    local config = ts:FindFirstChild("config")
    if not config then return nil end
    local mod = config:FindFirstChild("game-config")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    if ok and result then return result.GAME_CONFIG end
    return nil
end)()
local ClientToolShop = (function()
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local ts = ps:FindFirstChild("TS")
    if not ts then return nil end
    local toolShop = ts:FindFirstChild("tool-shop")
    if not toolShop then return nil end
    local mod = toolShop:FindFirstChild("client-tool-shop")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    return ok and result or nil
end)()
local function GetToolShopSnapshot()
    if not ClientToolShop or not ClientToolShop.clientToolShop then
        notyuri("GetToolShopSnapshot: ClientToolShop.clientToolShop is nil")
        return nil
    end
    local ok, snapshot = pcall(ClientToolShop.clientToolShop)
    if ok and snapshot then return snapshot end
    return nil
end
if GAME_CONFIG and GAME_CONFIG.tools and GAME_CONFIG.tools.definitions then
    for _, def in ipairs(GAME_CONFIG.tools.definitions) do
        local label = def.displayName
        table.insert(Tables.ToolShopLabelList, label)
        Tables.ToolShopLabelToId[label] = def.id
        table.insert(Tables.UseToolLabelList, label)
        Tables.UseToolLabelToId[label] = def.id
    end
    local mutationShop = GAME_CONFIG.tools.mutationFertilizer and GAME_CONFIG.tools.mutationFertilizer.shop
    if mutationShop and mutationShop.cashCosts then
        for mutationId in pairs(mutationShop.cashCosts) do
            local toolId = ("mutation_fertilizer_%s"):format(mutationId)
            local label = mutationId .. " " .. (GAME_CONFIG.tools.mutationFertilizer.displayNameSuffix or "Fertilizer")
            table.insert(Tables.ToolShopLabelList, label)
            Tables.ToolShopLabelToId[label] = toolId
            table.insert(Tables.UseToolLabelList, label)
            Tables.UseToolLabelToId[label] = toolId
        end
    end
end
local DronesTypesModule = (function()
    local ts = RS:FindFirstChild("TS")
    if not ts then return nil end
    local drones = ts:FindFirstChild("drones")
    if not drones then return nil end
    local mod = drones:FindFirstChild("types")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    return ok and result or nil
end)()
local ClientDroneOwnershipState = (function()
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local ts = ps:FindFirstChild("TS")
    if not ts then return nil end
    local drone = ts:FindFirstChild("drone")
    if not drone then return nil end
    local mod = drone:FindFirstChild("client-drone-ownership")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    if ok and result then return result.ClientDroneOwnershipState end
    return nil
end)()
local ModdingModule = (function()
    local include = RS:FindFirstChild("rbxts_include")
    if not include then return nil end
    local nodeModules = include:FindFirstChild("node_modules")
    if not nodeModules then return nil end
    local flamework = nodeModules:FindFirstChild("@flamework")
    if not flamework then return nil end
    local core = flamework:FindFirstChild("core")
    if not core then return nil end
    local out = core:FindFirstChild("out")
    if not out then return nil end
    local mod = out:FindFirstChild("modding")
    if not mod or not mod:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, mod)
    if ok and result then return result.Modding end
    return nil
end)()
local function ResolveFlameworkController(pathParts, exportKey)
    if not ModdingModule then
        notyuri("ResolveFlameworkController[" .. exportKey .. "]: ModdingModule is nil")
        return nil
    end
    local ps = Plr:FindFirstChild("PlayerScripts")
    if not ps then
        notyuri("ResolveFlameworkController[" .. exportKey .. "]: no PlayerScripts")
        return nil
    end
    local current = ps
    for _, part in ipairs(pathParts) do
        current = current:FindFirstChild(part)
        if not current then
            notyuri("ResolveFlameworkController[" .. exportKey .. "]: missing path part '" .. part .. "'")
            return nil
        end
    end
    if not current:IsA("ModuleScript") then
        notyuri("ResolveFlameworkController[" .. exportKey .. "]: resolved path is not a ModuleScript")
        return nil
    end
    local ok, result = pcall(require, current)
    if not ok then
        notyuri("ResolveFlameworkController[" .. exportKey .. "]: require failed: " .. tostring(result))
        return nil
    end
    if not result or not result[exportKey] then
        notyuri("ResolveFlameworkController[" .. exportKey .. "]: exportKey missing from module result")
        return nil
    end
    local ok2, instance = pcall(ModdingModule.resolveSingleton, result[exportKey])
    if not ok2 then
        notyuri("ResolveFlameworkController[" .. exportKey .. "]: resolveSingleton failed: " .. tostring(instance))
        return nil
    end
    if instance == nil then
        notyuri("ResolveFlameworkController[" .. exportKey .. "]: resolveSingleton returned nil")
    end
    return instance
end
local WildCropControllerInstance = ResolveFlameworkController({"TS", "wild-crops", "wild-crop-controller"}, "WildCropController")
local CropDroppedPhysicsControllerInstance = ResolveFlameworkController({"TS", "scythe", "crop-dropped-physics-controller"}, "CropDroppedPhysicsController")
local CropCarryArcControllerInstance = ResolveFlameworkController({"TS", "scythe", "crop-carry-arc-controller"}, "CropCarryArcController")
local PlotFloorIndicatorControllerInstance = ResolveFlameworkController({"TS", "plots", "plot-floor-indicator-controller"}, "PlotFloorIndicatorController")
local WorldStackControllerInstance = ResolveFlameworkController({"TS", "world-stack", "world-stack-controller"}, "WorldStackController")
local function GetCarryCount()
    if not CropCarryArcControllerInstance or not CropCarryArcControllerInstance.weldedCarryItems then
        notyuri("GetCarryCount: CropCarryArcControllerInstance.weldedCarryItems is nil")
        return 0
    end
    return #CropCarryArcControllerInstance.weldedCarryItems
end
local function GetMaxCarryItems()
    local ok, value = pcall(function()
        return Plr:GetAttribute("MaxCarryStackItems")
    end)
    if ok and type(value) == "number" then
        return math.clamp(math.floor(value), 10, 50)
    end
    return 10
end
local function GetCarryPercent()
    local max = GetMaxCarryItems()
    if max <= 0 then return 0 end
    return (GetCarryCount() / max) * 100
end
local function GetCarriedDishCount()
    if not CropCarryArcControllerInstance or not CropCarryArcControllerInstance.weldedCarryItems then
        notyuri("GetCarriedDishCount: CropCarryArcControllerInstance.weldedCarryItems is nil")
        return 0
    end
    local count = 0
    for _, item in ipairs(CropCarryArcControllerInstance.weldedCarryItems) do
        if item.kind == "dish" then
            count = count + 1
        end
    end
    return count
end
local function GetWorldStackCount(stackKind)
    if not PlotFloorIndicatorControllerInstance or not PlotFloorIndicatorControllerInstance.worldStackState then
        notyuri("GetWorldStackCount: PlotFloorIndicatorControllerInstance.worldStackState is nil")
        return 0
    end
    local ok, current = pcall(function()
        return PlotFloorIndicatorControllerInstance.worldStackState.current
    end)
    if not ok or not current or not current[stackKind] then
        notyuri("GetWorldStackCount: current[" .. tostring(stackKind) .. "] is nil")
        return 0
    end
    local count = 0
    for _ in pairs(current[stackKind]) do
        count = count + 1
    end
    return count
end
local function GetPendingCashAmount()
    if not WorldStackControllerInstance or not WorldStackControllerInstance.customerCashStackValues then
        notyuri("GetPendingCashAmount: WorldStackControllerInstance.customerCashStackValues is nil")
        return 0
    end
    local plotId = GetPlotId()
    if not plotId then
        notyuri("GetPendingCashAmount: GetPlotId returned nil")
        return 0
    end
    local slots = WorldStackControllerInstance.customerCashStackValues[plotId]
    if not slots then
        return 0
    end
    local sum = 0
    for _, entry in pairs(slots) do
        if type(entry.value) == "number" then
            sum = sum + entry.value
        end
    end
    return sum
end
local function Emit(moduleName, emitterName, messageId, data)
    local mod = GetNetModule(moduleName)
    if not mod then return end
    local emitter = mod[emitterName]
    local base = emitterName:gsub("Messages$", "")
    local enumKey = base:gsub("^%l", string.upper) .. "Message"
    local msgEnum = mod[enumKey]
    if not emitter or not emitter.server or not emitter.server.emit then return end
    if not msgEnum then return end
    local msgId = msgEnum[messageId]
    if not msgId then return end
    pcall(function()
        emitter.server:emit(msgId, data)
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
local function GetPlotSpawnCFrame(plotRoot)
    if not plotRoot then return nil end
    local spawnNames = {"PlotSpawn", "PlotSpawnPoint", "PlotSpawnLocation", "Spawn", "SpawnLocation", "PlayerSpawn"}
    local spawnPoints = plotRoot:FindFirstChild("PlotSpawnPoints")
    if spawnPoints then
        for _, name in ipairs(spawnNames) do
            local part = spawnPoints:FindFirstChild(name)
            if part and (part:IsA("BasePart") or part:IsA("Model")) then
                return part:IsA("Model") and part:GetPivot() or part.CFrame
            end
        end
        local firstChild = spawnPoints:FindFirstChildWhichIsA("BasePart") or spawnPoints:FindFirstChildWhichIsA("Model")
        if firstChild then
            return firstChild:IsA("Model") and firstChild:GetPivot() or firstChild.CFrame
        end
    end
    for _, name in ipairs(spawnNames) do
        local part = plotRoot:FindFirstChild(name, true)
        if part and (part:IsA("BasePart") or part:IsA("Model")) then
            return part:IsA("Model") and part:GetPivot() or part.CFrame
        end
    end
    return plotRoot:GetPivot()
end
local function TeleportToCFrame(targetCFrame, holdTime)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetCFrame then
        notyuri("TeleportToCFrame: missing HumanoidRootPart or targetCFrame")
        return false
    end
    hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
    task.wait(holdTime or 0.2)
    return true
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
GB.Player.Left.General:AddButton({ Text = "Teleport to Base", Func = function()
    local plotId = GetPlotId()
    local plotRoot = GetLocalPlotRoot(plotId)
    if not plotRoot then
        notyuri("Teleport to Base: could not resolve local plot root")
        return
    end
    local spawnCFrame = GetPlotSpawnCFrame(plotRoot)
    if not spawnCFrame then
        notyuri("Teleport to Base: could not resolve a spawn CFrame")
        return
    end
    TeleportToCFrame(spawnCFrame, 0.2)
end })
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
local function Func_AutoUpgrade()
    while true do
        local plotId = GetPlotId()
        if plotId and UpgradesModule and ClientPlayerUpgradeState then
            local state = ClientPlayerUpgradeState.get()
            local selected = Options.UpgradeSelected.Value
            for label, active in pairs(selected) do
                if active then
                    local id = Tables.UpgradeMap[label]
                    if id and state then
                        local level = UpgradesModule.getPlayerUpgradeLevel(state, id)
                        local maxLevel = UpgradesModule.getPlayerUpgradeMaxLevel(id)
                        if maxLevel == nil or level < maxLevel then
                            local cost = UpgradesModule.getPlayerUpgradeCost(id, level)
                            local money = GetPlayerMoney()
                            if cost ~= nil and money ~= nil and money >= cost then
                                Emit("player-upgrades", "playerUpgradeMessages", "PurchaseRequested", {
                                    plotId = plotId,
                                    upgradeId = id,
                                })
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoUnlockPlot()
    while true do
        local plotId = GetPlotId()
        if plotId and ClientPlotState and CropTypesModule then
            local state = ClientPlotState.get()
            if state and state.backyardCellsById and state.ownedBackyardCellIds then
                for cellId, cellDescriptor in pairs(state.backyardCellsById) do
                    if cellDescriptor.expanded and not state.ownedBackyardCellIds[cellId] then
                        local ownedCount = 0
                        for _ in pairs(state.ownedBackyardCellIds) do
                            ownedCount = ownedCount + 1
                        end
                        local cost = CropTypesModule.getBackyardCellPurchaseCost(ownedCount, cellDescriptor)
                        local money = GetPlayerMoney()
                        if cost ~= nil and cost > 0 and money ~= nil and money >= cost then
                            Emit("backyard-cells", "backyardCellMessages", "BackyardCellPurchaseRequested", {
                                plotId = plotId,
                                cellId = cellId,
                            })
                            task.wait(0.3)
                            state = ClientPlotState.get()
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function GetOwnedSeedPacketTools()
    local tools = {}
    local backpack = Plr:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("SeedPacket") == true then
                table.insert(tools, tool)
            end
        end
    end
    local character = Plr.Character
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("SeedPacket") == true then
                table.insert(tools, tool)
            end
        end
    end
    return tools
end
local function GetSelectedPlantCropIds()
    local labels = (Options.PlantSelected and Options.PlantSelected.Value) or {}
    local cropIds = {}
    for label, active in pairs(labels) do
        if active then
            local cropId = Tables.CropRollLabelToId[label]
            if cropId then cropIds[cropId] = true end
        end
    end
    return cropIds
end
local function Func_AutoPlant()
    while true do
        local cropIds = GetSelectedPlantCropIds()
        local plotId = GetPlotId()
        if plotId and next(cropIds) ~= nil and ClientPlotState then
            local state = ClientPlotState.get()
            if state and state.backyardCellsById and state.ownedBackyardCellIds and state.plantedBackyardCellsById then
                local seedTools = GetOwnedSeedPacketTools()
                for _, tool in ipairs(seedTools) do
                    local cropId = tool:GetAttribute("SeedCropId")
                    local inventoryItemUid = tool:GetAttribute("InventoryItemUid")
                    if cropIds[cropId] and type(inventoryItemUid) == "string" then
                        local plantedTool = false
                        for cellId, cellDescriptor in pairs(state.backyardCellsById) do
                            if cellDescriptor.expanded and state.ownedBackyardCellIds[cellId] and not state.plantedBackyardCellsById[cellId] then
                                local character = Plr.Character
                                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                                if humanoid and tool.Parent ~= character then
                                    humanoid:EquipTool(tool)
                                    task.wait(0.1)
                                end
                                Emit("seed-rolls", "seedRollMessages", "SeedPacketPlantRequested", {
                                    plotId = plotId,
                                    cellId = cellId,
                                    inventoryItemUid = inventoryItemUid,
                                })
                                task.wait(0.2)
                                state = ClientPlotState.get()
                                plantedTool = true
                                break
                            end
                        end
                        if not plantedTool then break end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoUpgradePlant()
    while true do
        local plotId = GetPlotId()
        if plotId and ClientPlotState and UpgradesModule then
            local state = ClientPlotState.get()
            if state and state.backyardCellsById and state.ownedBackyardCellIds then
                for cellId, cellDescriptor in pairs(state.backyardCellsById) do
                    if cellDescriptor.expanded and state.ownedBackyardCellIds[cellId] then
                        local level = cellDescriptor.level or 0
                        local maxLevel = UpgradesModule.getBackyardCellMaxLevel()
                        if maxLevel == nil or level < maxLevel then
                            local cost = UpgradesModule.getBackyardCellUpgradeCost(level, cellDescriptor.floor)
                            local money = GetPlayerMoney()
                            if cost ~= nil and money ~= nil and money >= cost then
                                Emit("backyard-cells", "backyardCellMessages", "BackyardCellUpgradeRequested", {
                                    plotId = plotId,
                                    cellId = cellId,
                                })
                                task.wait(0.2)
                                state = ClientPlotState.get()
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function GetSelectedDroneKinds()
    local labels = (Options.DroneSelected and Options.DroneSelected.Value) or {}
    local kinds = {}
    for label, active in pairs(labels) do
        if active then kinds[label] = true end
    end
    return kinds
end
local function Func_AutoBuyDrone()
    while true do
        local kinds = GetSelectedDroneKinds()
        local plotId = GetPlotId()
        if plotId and next(kinds) ~= nil and DronesTypesModule and ClientDroneOwnershipState then
            local ownership = ClientDroneOwnershipState.get()
            local money = GetPlayerMoney()
            if ownership and money then
                for kind in pairs(kinds) do
                    local kindState = ownership[kind]
                    local kindConfig = DronesTypesModule.getDroneKindConfig(kind)
                    if kindState and kindConfig then
                        if not kindState.stationUnlocked then
                            if money >= kindConfig.stationCost then
                                Emit("drone", "droneMessages", "PurchaseRequested", {
                                    purchaseKind = "station",
                                    plotId = plotId,
                                    kind = kind,
                                })
                                task.wait(0.3)
                                ownership = ClientDroneOwnershipState.get()
                                money = GetPlayerMoney()
                            end
                        elseif kindConfig.maxDroneCount == nil or kindState.ownedCount < kindConfig.maxDroneCount then
                            local extraCost = DronesTypesModule.getExtraDroneCost(kindState.ownedCount, kind)
                            if extraCost ~= nil and money >= extraCost then
                                Emit("drone", "droneMessages", "PurchaseRequested", {
                                    purchaseKind = "extraDrone",
                                    plotId = plotId,
                                    kind = kind,
                                })
                                task.wait(0.3)
                                ownership = ClientDroneOwnershipState.get()
                                money = GetPlayerMoney()
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function GetSelectedRollCropIds()
    local labels = (Options.RollSelected and Options.RollSelected.Value) or {}
    local cropIds = {}
    for label, active in pairs(labels) do
        if active then
            local cropId = Tables.CropRollLabelToId[label]
            if cropId then cropIds[cropId] = true end
        end
    end
    return cropIds
end
local function Func_AutoRoll()
    while true do
        local cropIds = GetSelectedRollCropIds()
        if next(cropIds) ~= nil then
            local roll = ClientSeedRollState and ClientSeedRollState.getRoll()
            if not roll or not roll.offers then
                local plotId = GetPlotId()
                local plotRoot = GetLocalPlotRoot(plotId)
                local prompt = plotRoot and GetObject(plotRoot, "RollerCase.Lever.SeedRollPrompt")
                if prompt then
                    FirePP(prompt, true)
                    task.wait(0.3)
                end
            else
                local matchedAny = false
                for _, offer in ipairs(roll.offers) do
                    if cropIds[offer.cropId] then
                        matchedAny = true
                        local rollId, offerId, cost = roll.rollId, offer.offerId, offer.cost
                        while Toggles.AutoRoll.Value do
                            local money = GetPlayerMoney()
                            if money == nil then break end
                            if money >= cost then
                                Emit("seed-rolls", "seedRollMessages", "SeedOfferPurchaseRequested", {
                                    plotId = roll.plotId,
                                    rollId = rollId,
                                    offerId = offerId,
                                })
                                task.wait(0.15)
                                break
                            end
                            notyuri("Func_AutoRoll: waiting for enough money to buy offer " .. tostring(offerId))
                            task.wait(1)
                            local currentRoll = ClientSeedRollState and ClientSeedRollState.getRoll()
                            if not currentRoll or currentRoll.rollId ~= rollId then break end
                            local stillOffered = false
                            for _, o in ipairs(currentRoll.offers or {}) do
                                if o.offerId == offerId then stillOffered = true break end
                            end
                            if not stillOffered then break end
                        end
                    end
                end
                if not matchedAny then
                    notyuri("Func_AutoRoll: current roll has no matching offer")
                    local plotId = GetPlotId()
                    local plotRoot = GetLocalPlotRoot(plotId)
                    local prompt = plotRoot and GetObject(plotRoot, "RollerCase.Lever.SeedRollPrompt")
                    if prompt then
                        FirePP(prompt, true)
                        task.wait(0.3)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local HarvestActive = false
local function Func_AutoHarvest()
    while true do
        if GetCarryCount() >= GetMaxCarryItems() then
            notyuri("Func_AutoHarvest: carry inventory full, skipping")
        elseif not WildCropControllerInstance then
            notyuri("Func_AutoHarvest: WildCropControllerInstance is nil")
        elseif not WildCropControllerInstance.active then
            notyuri("Func_AutoHarvest: WildCropControllerInstance.active is nil")
        else
            local now = workspace:GetServerTimeNow()
            local activeSnapshot = {}
            for cropInstanceId, entry in pairs(WildCropControllerInstance.active) do
                table.insert(activeSnapshot, { id = cropInstanceId, entry = entry })
            end
            for _, snapshotEntry in ipairs(activeSnapshot) do
                local cropInstanceId = snapshotEntry.id
                local entry = snapshotEntry.entry
                local d = entry.descriptor
                if d and d.position and not entry.harvestPending and not entry.removing and now >= d.readyAt and now < d.expiresAt then
                    HarvestActive = true
                    local teleported = TeleportToCFrame(CFrame.new(d.position), 0.3)
                    if teleported then
                        local ok, err = pcall(function()
                            WildCropControllerInstance:requestHarvest(cropInstanceId)
                        end)
                        if not ok then
                            notyuri("Func_AutoHarvest: requestHarvest failed: " .. tostring(err))
                        else
                            local waited = 0
                            while Toggles.AutoHarvest.Value and waited < 2 do
                                local stillActive = WildCropControllerInstance.active[cropInstanceId] ~= nil
                                local dropsPending = CropDroppedPhysicsControllerInstance
                                    and CropDroppedPhysicsControllerInstance.activeDrops
                                    and next(CropDroppedPhysicsControllerInstance.activeDrops) ~= nil
                                if not stillActive and not dropsPending then
                                    break
                                end
                                task.wait(0.2)
                                waited = waited + 0.2
                            end
                            if waited >= 2 then
                                notyuri("Func_AutoHarvest: timed out waiting for crop/drop to clear for " .. tostring(cropInstanceId))
                            end
                        end
                    end
                end
            end
        end
        HarvestActive = false
        task.wait(1)
    end
end
local function DecodeBudGrowthStartedAtUnix(str)
    if str == "" then return nil end
    local t = {}
    for _, part in ipairs(str:split(",")) do
        local n = tonumber(part)
        if n == nil or n < 0 then return nil end
        table.insert(t, n)
    end
    return t
end
local function ReadCellGrowthFertilizerState(cellModel)
    local multiplier = cellModel:GetAttribute("growthFertilizerMultiplier")
    multiplier = (type(multiplier) == "number") and multiplier or 0
    local appliedAt = cellModel:GetAttribute("growthFertilizerAppliedAtUnix")
    appliedAt = (type(appliedAt) == "number") and appliedAt or 0
    local expiresAt = cellModel:GetAttribute("growthFertilizerExpiresAtUnix")
    expiresAt = (type(expiresAt) == "number") and expiresAt or 0
    if multiplier <= 1 or expiresAt <= appliedAt then return nil end
    local toolId = cellModel:GetAttribute("growthFertilizerToolId")
    return {
        multiplier = math.max(1, math.floor(multiplier)),
        appliedAtUnix = math.max(0, appliedAt),
        expiresAtUnix = math.max(0, expiresAt),
        toolId = (type(toolId) == "string") and toolId or "",
    }
end
local function GetNearestHarvestableSproutTarget()
    if not CropsModule or not SproutPositionModule then return nil end
    local plotId = GetPlotId()
    local plotRoot = GetLocalPlotRoot(plotId)
    if not plotRoot then return nil end
    local backyardCells = plotRoot:FindFirstChild("BackyardCells")
    if not backyardCells then return nil end
    local now = CropsModule.getSproutGrowthNow and CropsModule.getSproutGrowthNow()
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local myPos = hrp and hrp.Position
    local best, bestDistSq = nil, nil
    for _, cellModel in ipairs(backyardCells:GetChildren()) do
        local cropId = cellModel:GetAttribute("cropId")
        local owned = cellModel:GetAttribute("owned")
        local sproutsFolder = cellModel:FindFirstChild("Sprouts")
        if cropId and owned and sproutsFolder then
            local cropDefinition = CropsModule.cropRegistry and CropsModule.cropRegistry:get(cropId)
            if cropDefinition then
                local growthFertilizer = ReadCellGrowthFertilizerState(cellModel)
                for _, sproutFolder in ipairs(sproutsFolder:GetChildren()) do
                    local position = sproutFolder:GetAttribute("position")
                    local growthStartedAtUnix = sproutFolder:GetAttribute("growthStartedAtUnix")
                    local hostEstablished = sproutFolder:GetAttribute("hostEstablished")
                    local budGrowthStartedAtUnixRaw = sproutFolder:GetAttribute("budGrowthStartedAtUnix")
                    if type(position) == "number" and type(growthStartedAtUnix) == "number" then
                        local sprout = {
                            position = position,
                            growthStartedAtUnix = growthStartedAtUnix,
                            hostEstablished = (type(hostEstablished) == "boolean") and hostEstablished or false,
                            budGrowthStartedAtUnix = DecodeBudGrowthStartedAtUnix(type(budGrowthStartedAtUnixRaw) == "string" and budGrowthStartedAtUnixRaw or ""),
                        }
                        local ok, harvestable = pcall(CropsModule.isSproutHarvestable, sprout, cropDefinition, now, nil, growthFertilizer)
                        if not ok then
                            notyuri("GetNearestHarvestableSproutTarget: isSproutHarvestable pcall failed:", harvestable)
                        end
                        if ok and harvestable then
                            local ok2, localCFrame = pcall(SproutPositionModule.getSproutPositionLocalCFrameFromCell, cellModel, position)
                            if not ok2 then
                                notyuri("GetNearestHarvestableSproutTarget: getSproutPositionLocalCFrameFromCell pcall failed:", localCFrame)
                            end
                            if ok2 and localCFrame then
                                local cellCFrame = cellModel:IsA("Model") and cellModel:GetPivot() or cellModel.CFrame
                                local worldPos = (cellCFrame * localCFrame).Position
                                if myPos then
                                    local distSq = (worldPos - myPos).Magnitude
                                    if not bestDistSq or distSq < bestDistSq then
                                        bestDistSq = distSq
                                        best = worldPos
                                    end
                                elseif not best then
                                    best = worldPos
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end
local function Func_AutoCollect()
    while true do
        if HarvestActive then
            task.wait(0.1)
        elseif GetCarryCount() >= GetMaxCarryItems() then
            notyuri("Func_AutoCollect: carry inventory full, skipping")
        else
            local sproutTarget = GetNearestHarvestableSproutTarget()
            if sproutTarget then
                notyuri("Func_AutoCollect: teleporting to harvestable sprout")
                TeleportToCFrame(CFrame.new(sproutTarget), 0.15)
            else
                notyuri("Func_AutoCollect: no harvestable sprouts")
            end
        end
        task.wait(0.5)
    end
end
local function GetSelectedPickupCropIds()
    local labels = (Options.PickupSelected and Options.PickupSelected.Value) or {}
    local cropIds = {}
    for label, active in pairs(labels) do
        if active then
            local cropId = Tables.CropRollLabelToId[label]
            if cropId then cropIds[cropId] = true end
        end
    end
    return cropIds
end
local function Func_AutoPickup()
    while true do
        local cropIds = GetSelectedPickupCropIds()
        local plotId = GetPlotId()
        if next(cropIds) == nil then
            notyuri("Func_AutoPickup: no plants selected")
        elseif not plotId then
            notyuri("Func_AutoPickup: GetPlotId returned nil")
        else
            local plotRoot = GetLocalPlotRoot(plotId)
            if not plotRoot then
                notyuri("Func_AutoPickup: GetLocalPlotRoot returned nil")
            else
                local backyardCells = plotRoot:FindFirstChild("BackyardCells")
                if not backyardCells then
                    notyuri("Func_AutoPickup: BackyardCells not found")
                else
                    for _, cellModel in ipairs(backyardCells:GetChildren()) do
                        local cropId = cellModel:GetAttribute("cropId")
                        local owned = cellModel:GetAttribute("owned")
                        if owned and cropId and cropIds[cropId] then
                            Emit("backyard-cells", "backyardCellMessages", "BackyardCellRemoveRequested", {
                                plotId = plotId,
                                cellId = cellModel.Name,
                            })
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoCook()
    while true do
        local plotId = GetPlotId()
        if not plotId then
            notyuri("Func_AutoCook: GetPlotId returned nil")
        elseif not ClientPlotState then
            notyuri("Func_AutoCook: ClientPlotState is nil")
        else
            local threshold = Options.AutoCookThreshold and Options.AutoCookThreshold.Value or 100
            local percent = GetCarryPercent()
            if percent >= threshold and GetCarryCount() > 0 then
                local state = ClientPlotState.get()
                local hotPot = state and state.hotPot
                if hotPot and hotPot.interactCFrame then
                    TeleportToCFrame(hotPot.interactCFrame, 0.3)
                else
                    notyuri("Func_AutoCook: state.hotPot.interactCFrame is nil")
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoServe()
    while true do
        local plotId = GetPlotId()
        if not plotId then
            notyuri("Func_AutoServe: GetPlotId returned nil")
        elseif not ClientPlotState then
            notyuri("Func_AutoServe: ClientPlotState is nil")
        else
            local state = ClientPlotState.get()
            local hotPot = state and state.hotPot
            local customer = state and state.customer
            if GetWorldStackCount("hotPotOutput") > 0 then
                if hotPot and hotPot.dishPickupCFrame then
                    TeleportToCFrame(hotPot.dishPickupCFrame, 0.3)
                else
                    notyuri("Func_AutoServe: state.hotPot.dishPickupCFrame is nil")
                end
            end
            if GetCarriedDishCount() > 0 then
                if customer and customer.registerCFrame then
                    TeleportToCFrame(customer.registerCFrame, 0.3)
                else
                    notyuri("Func_AutoServe: state.customer.registerCFrame is nil")
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoCollectDrone()
    while true do
        local plotId = GetPlotId()
        if GetCarryCount() >= GetMaxCarryItems() then
            notyuri("Func_AutoCollectDrone: carry inventory full, skipping")
        elseif not plotId then
            notyuri("Func_AutoCollectDrone: GetPlotId returned nil")
        elseif not ClientPlotState then
            notyuri("Func_AutoCollectDrone: ClientPlotState is nil")
        else
            local threshold = tonumber(Options.AutoCollectDroneThreshold and Options.AutoCollectDroneThreshold.Value) or 1
            if GetWorldStackCount("droneDropOff") >= threshold then
                local state = ClientPlotState.get()
                local farmer = state and state.drones and state.drones.farmer
                if farmer and farmer.pickUpCFrame then
                    TeleportToCFrame(farmer.pickUpCFrame, 0.3)
                else
                    notyuri("Func_AutoCollectDrone: state.drones.farmer.pickUpCFrame is nil")
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoCollectMoney()
    while true do
        local plotId = GetPlotId()
        if not plotId then
            notyuri("Func_AutoCollectMoney: GetPlotId returned nil")
        elseif not ClientPlotState then
            notyuri("Func_AutoCollectMoney: ClientPlotState is nil")
        else
            local threshold = tonumber(Options.AutoCollectMoneyThreshold and Options.AutoCollectMoneyThreshold.Value) or 1
            if GetPendingCashAmount() >= threshold then
                local state = ClientPlotState.get()
                local customer = state and state.customer
                if customer and customer.withdrawalCFrame then
                    TeleportToCFrame(customer.withdrawalCFrame, 0.3)
                else
                    notyuri("Func_AutoCollectMoney: state.customer.withdrawalCFrame is nil")
                end
            end
        end
        task.wait(1)
    end
end
local function GetSelectedToolShopIds()
    local labels = (Options.ToolShopSelected and Options.ToolShopSelected.Value) or {}
    local toolIds = {}
    for label, active in pairs(labels) do
        if active then
            local toolId = Tables.ToolShopLabelToId[label]
            if toolId then toolIds[toolId] = true end
        end
    end
    return toolIds
end
local function Func_AutoBuyTool()
    while true do
        local toolIds = GetSelectedToolShopIds()
        if next(toolIds) == nil then
            notyuri("Func_AutoBuyTool: no tools selected")
        else
            local snapshot = GetToolShopSnapshot()
            if not snapshot or not snapshot.restockId or not snapshot.lines then
                notyuri("Func_AutoBuyTool: no tool shop snapshot available")
            else
                local money = GetPlayerMoney()
                for _, line in ipairs(snapshot.lines) do
                    if toolIds[line.toolId] and line.stock and line.stock > 0 then
                        if money and line.cashCost and money >= line.cashCost then
                            Emit("tool-shop", "toolShopMessages", "CashPurchaseRequested", {
                                restockId = snapshot.restockId,
                                lineId = line.lineId,
                            })
                            task.wait(0.2)
                            money = GetPlayerMoney()
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function GetSelectedUseToolIds()
    local labels = (Options.UseToolSelected and Options.UseToolSelected.Value) or {}
    local toolIds = {}
    for label, active in pairs(labels) do
        if active then
            local toolId = Tables.UseToolLabelToId[label]
            if toolId then toolIds[toolId] = true end
        end
    end
    return toolIds
end
local function GetOwnedGardenTools()
    local tools = {}
    local backpack = Plr:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("GardenTool") == true then
                table.insert(tools, tool)
            end
        end
    end
    local character = Plr.Character
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("GardenTool") == true then
                table.insert(tools, tool)
            end
        end
    end
    return tools
end
local function GetGrowthFertilizerTargetCell(plotId)
    local plotRoot = GetLocalPlotRoot(plotId)
    if not plotRoot then return nil end
    local backyardCells = plotRoot:FindFirstChild("BackyardCells")
    if not backyardCells then return nil end
    for _, cellModel in ipairs(backyardCells:GetChildren()) do
        local cropId = cellModel:GetAttribute("cropId")
        local owned = cellModel:GetAttribute("owned")
        if cropId and owned then
            local existingFertilizer = ReadCellGrowthFertilizerState(cellModel)
            if not existingFertilizer then
                return cellModel.Name
            end
        end
    end
    return nil
end
local function Func_AutoUseTool()
    while true do
        local toolIds = GetSelectedUseToolIds()
        local plotId = GetPlotId()
        if next(toolIds) == nil then
            notyuri("Func_AutoUseTool: no tools selected")
        elseif not plotId then
            notyuri("Func_AutoUseTool: GetPlotId returned nil")
        else
            local gardenTools = GetOwnedGardenTools()
            for _, tool in ipairs(gardenTools) do
                local toolId = tool:GetAttribute("GardenToolId")
                local toolKind = tool:GetAttribute("GardenToolKind")
                local inventoryItemUid = tool:GetAttribute("InventoryItemUid")
                if toolIds[toolId] and type(inventoryItemUid) == "string" then
                    local cellId = nil
                    if toolKind == "growthFertilizer" then
                        cellId = GetGrowthFertilizerTargetCell(plotId)
                        if not cellId then
                            notyuri("Func_AutoUseTool: no eligible planter found for " .. tostring(toolId))
                        end
                    else
                        notyuri("Func_AutoUseTool: no target-selection logic for tool kind " .. tostring(toolKind) .. ", skipping " .. tostring(toolId))
                    end
                    if cellId then
                        local character = Plr.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        if humanoid and tool.Parent ~= character then
                            humanoid:EquipTool(tool)
                            task.wait(0.1)
                        end
                        Emit("garden-tools", "gardenToolMessages", "GardenToolUseRequested", {
                            plotId = plotId,
                            cellId = cellId,
                            inventoryItemUid = inventoryItemUid,
                        })
                        task.wait(0.2)
                    end
                end
            end
        end
        task.wait(1)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoHarvest", { Text = "Auto Harvest", Default = false, Callback = function(val) Thread("AutoHarvest", Func_AutoHarvest, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect", Default = false, Callback = function(val) Thread("AutoCollect", Func_AutoCollect, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false, Callback = function(val) Thread("AutoPickup", Func_AutoPickup, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("PickupSelected", { Text = "Select Pickup", Values = Tables.CropRollLabelList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoCook", { Text = "Auto Cook", Default = false, Callback = function(val) Thread("AutoCook", Func_AutoCook, val) end })
TB_Tabs.Autofarm2.T1:AddSlider("AutoCookThreshold", {
    Text = "Backpack to Cook",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoServe", { Text = "Auto Serve", Default = false, Callback = function(val) Thread("AutoServe", Func_AutoServe, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectMoney", { Text = "Auto Collect Money", Default = false, Callback = function(val) Thread("AutoCollectMoney", Func_AutoCollectMoney, val) end })
TB_Tabs.Autofarm2.T1:AddInput("AutoCollectMoneyThreshold", {
    Text = "Money to Collect",
    Default = "1",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectDrone", { Text = "Auto Collect Drone", Default = false, Callback = function(val) Thread("AutoCollectDrone", Func_AutoCollectDrone, val) end })
TB_Tabs.Autofarm2.T1:AddInput("AutoCollectDroneThreshold", {
    Text = "Harvested to Collect",
    Default = "1",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrades", Default = false, Callback = function(val) Thread("AutoUpgrade", Func_AutoUpgrade, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeSelected", { Text = "Upgrades List", Values = Tables.UpgradeList, Default = {}, Multi = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoUnlockPlot", { Text = "Auto Unlock Plot", Default = false, Callback = function(val) Thread("AutoUnlockPlot", Func_AutoUnlockPlot, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false, Callback = function(val) Thread("AutoRoll", Func_AutoRoll, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlant", { Text = "Auto Plant", Default = false, Callback = function(val) Thread("AutoPlant", Func_AutoPlant, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("PlantSelected", { Text = "Select Plant", Values = Tables.CropRollLabelList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradePlant", { Text = "Auto Upgrade Plant", Default = false, Callback = function(val) Thread("AutoUpgradePlant", Func_AutoUpgradePlant, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyDrone", { Text = "Auto Buy Drone", Default = false, Callback = function(val) Thread("AutoBuyDrone", Func_AutoBuyDrone, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("DroneSelected", { Text = "Select Drone", Values = Tables.DroneKindList, Default = {}, Multi = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyTool", { Text = "Auto Buy Tool", Default = false, Callback = function(val) Thread("AutoBuyTool", Func_AutoBuyTool, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("ToolShopSelected", { Text = "Select Tool to Buy", Values = Tables.ToolShopLabelList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoUseTool", { Text = "Auto Use Tool", Default = false, Callback = function(val) Thread("AutoUseTool", Func_AutoUseTool, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("UseToolSelected", { Text = "Select Tool to Use", Values = Tables.UseToolLabelList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("RollSelected", { Text = "Select Roll", Values = Tables.CropRollLabelList, Default = {}, Multi = true, Searchable = true })
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
SaveManager:SetFolder("Yuri/AAR")
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