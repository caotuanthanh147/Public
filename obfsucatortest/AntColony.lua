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
local SharedFolder = RS:FindFirstChild("Shared") or RS:WaitForChild("Shared", 15)
local RemotesFolder = SharedFolder and (SharedFolder:FindFirstChild("Remotes") or SharedFolder:WaitForChild("Remotes", 15)) or nil
local function GetRF(name)
    if not RemotesFolder then return nil end
    return RemotesFolder:FindFirstChild(name) or RemotesFolder:WaitForChild(name, 10)
end
local function GetRE(name)
    if not RemotesFolder then return nil end
    return RemotesFolder:FindFirstChild(name) or RemotesFolder:WaitForChild(name, 10)
end
local Remotes = {
    SELL_CRUMBS = GetRF("SELL_CRUMBS"),
    UPGRADE_SERVICE_PURCHASE = GetRF("UPGRADE_SERVICE_PURCHASE"),
    REBIRTH_CONTROLLER_REQUEST_REBIRTH = GetRF("REBIRTH_CONTROLLER_REQUEST_REBIRTH"),
    DAILY_REWARD_SERVICE_GET_STATE = GetRF("DAILY_REWARD_SERVICE_GET_STATE"),
    DAILY_REWARD_SERVICE_CLAIM = GetRF("DAILY_REWARD_SERVICE_CLAIM"),
    PLAYTIME_CHEST_SERVICE_GET_STATE = GetRF("PLAYTIME_CHEST_SERVICE_GET_STATE"),
    PLAYTIME_CHEST_SERVICE_CLAIM = GetRF("PLAYTIME_CHEST_SERVICE_CLAIM"),
    QUEST_SERVICE_GET_STATE = GetRF("QUEST_SERVICE_GET_STATE"),
    QUEST_SERVICE_CLAIM = GetRF("QUEST_SERVICE_CLAIM"),
    ANT_INDEX_CLAIM = GetRF("ANT_INDEX_CLAIM"),
    COLLECTION_INDEX_CLAIM = GetRF("COLLECTION_INDEX_CLAIM"),
    CODE_REDEEM = GetRF("CODE_REDEEM"),
    ANT_COLONY_SET_AUTO_COLLECT = GetRF("ANT_COLONY_SET_AUTO_COLLECT"),
    EXPANSION_BUY = GetRF("EXPANSION_BUY"),
    MOUND_UNLOCK = GetRF("MOUND_UNLOCK"),
    EGG_PLACEMENT_OPEN = GetRF("EGG_PLACEMENT_OPEN"),
    EGG_PLACE = GetRF("EGG_PLACE"),
    PurchaseItem = GetRF("PurchaseItem"),
    GetStoreItems = GetRF("GetStoreItems"),
    USE_GROWTH_ITEM = GetRF("USE_GROWTH_ITEM"),
    FUSE_ACTIVATE = GetRF("FUSE_ACTIVATE"),
    FUSE_CLAIM = GetRF("FUSE_CLAIM"),
    FUSE_PLACE = GetRF("FUSE_PLACE"),
    MUTATE_ACTIVATE = GetRF("MUTATE_ACTIVATE"),
    MUTATE_CLAIM = GetRF("MUTATE_CLAIM"),
    MUTATE_PLACE = GetRF("MUTATE_PLACE"),
    ANT_COLONY_CLAIM_NEST = GetRF("ANT_COLONY_CLAIM_NEST"),
    ANT_COLONY_UPGRADE_NEST = GetRF("ANT_COLONY_UPGRADE_NEST"),
    BLACKHOLE_DISCARD = GetRF("BLACKHOLE_DISCARD"),
    ROULETTE_CONTROLLER_USE_ROULETTE = GetRF("ROULETTE_CONTROLLER_USE_ROULETTE"),
    NEST_PLACE = GetRF("NEST_PLACE"),
    NEST_PICKUP = GetRF("NEST_PICKUP"),
}
local ClientModulesFolder = Plr:FindFirstChild("PlayerScripts") and Plr.PlayerScripts:FindFirstChild("Client") and Plr.PlayerScripts.Client:FindFirstChild("Modules")
local Modules = {
    UpgradeMath = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules"), "UpgradeMath"),
    Upgrades = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules") and SharedFolder.Modules:FindFirstChild("Data"), "Upgrades"),
    Mounds = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules") and SharedFolder.Modules:FindFirstChild("Data"), "Mounds"),
    Expansions = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules") and SharedFolder.Modules:FindFirstChild("Data"), "Expansions"),
    Eggs = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules") and SharedFolder.Modules:FindFirstChild("Data"), "Eggs"),
    PlotHatch = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules"), "PlotHatch"),
    SellPad = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules"), "SellPad"),
    Configs = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules"), "Configs"),
    ServerClock = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules"), "ServerClock"),
    MoundPlacement = GetSafeModule(ClientModulesFolder, "MoundPlacement"),
    PlacementPreview = GetSafeModule(ClientModulesFolder and ClientModulesFolder:FindFirstChild("Classes"), "PlacementPreview"),
    PlayerController = GetSafeModule(Plr:FindFirstChild("PlayerScripts") and Plr.PlayerScripts:FindFirstChild("Client") and Plr.PlayerScripts.Client:FindFirstChild("Controllers"), "PlayerController"),
    PlotMounds = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules"), "PlotMounds"),
    EggController = GetSafeModule(Plr:FindFirstChild("PlayerScripts") and Plr.PlayerScripts:FindFirstChild("Client") and Plr.PlayerScripts.Client:FindFirstChild("Controllers"), "EggController"),
    Rarities = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules") and SharedFolder.Modules:FindFirstChild("Data"), "Rarities"),
    Ants = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules") and SharedFolder.Modules:FindFirstChild("Data"), "Ants"),
    AntUpgrade = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules"), "AntUpgrade"),
    Fusion = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules"), "Fusion"),
    GrowthItems = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules") and SharedFolder.Modules:FindFirstChild("Data"), "GrowthItems"),
    Variants = GetSafeModule(SharedFolder and SharedFolder:FindFirstChild("Modules") and SharedFolder.Modules:FindFirstChild("Data"), "Variants"),
}
local Flags = {}
local Shared = {
}
local Tables = {
    UpgradeList = { "Speed", "Workers", "EatSize" },
    UpgradeMap = { Speed = "Speed", Workers = "Workers", EatSize = "EatSize" },
    MoundList = { "AntMound7", "AntMound8", "AntMound9", "AntMound10", "AntMound11", "AntMound12" },
    MoundMap = { AntMound7 = "AntMound7", AntMound8 = "AntMound8", AntMound9 = "AntMound9", AntMound10 = "AntMound10", AntMound11 = "AntMound11", AntMound12 = "AntMound12" },
    ExpansionList = { "Expansion1", "Expansion2" },
    ExpansionMap = { Expansion1 = "Expansion1", Expansion2 = "Expansion2" },
    EggList = {},
    EggMap = {},
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
local function GetPlayerData()
    local pc = Modules.PlayerController
    if not pc then return nil end
    local replica = pc.Replica
    if not replica then return nil end
    return replica.Data
end
local function GetCrumbs()
    local data = GetPlayerData()
    return tonumber(data and data.Crumbs) or 0
end
local function GetSugar()
    local data = GetPlayerData()
    return tonumber(data and data.Sugar) or 0
end
local function GetUpgradeLevel(worldId, upgradeId)
    local data = GetPlayerData()
    if not data or not data.Worlds or not data.Worlds[worldId] then return 0 end
    local upgrades = data.Worlds[worldId].Upgrades
    if not upgrades then return 0 end
    return tonumber(upgrades[upgradeId]) or 0
end
local function GetPlacedEggs()
    local placedEggs = workspace:FindFirstChild("PlacedEggs")
    if not placedEggs then return {} end
    local list = {}
    for _, model in ipairs(placedEggs:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("OwnerUserId") == Plr.UserId then
            local eggId = model:GetAttribute("PlacedEggId")
            if typeof(eggId) == "string" then
                table.insert(list, eggId)
            end
        end
    end
    return list
end
local function GetAntTools()
    local list = {}
    local containers = { Plr:FindFirstChildOfClass("Backpack"), GetCharacter() }
    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and item:GetAttribute("SlotId") then
                    table.insert(list, item)
                end
            end
        end
    end
    return list
end
local function GetEggTools()
    local list = {}
    local containers = { Plr:FindFirstChildOfClass("Backpack"), GetCharacter() }
    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and item:GetAttribute("IsEggTool") and item:GetAttribute("EggId") then
                    table.insert(list, item)
                end
            end
        end
    end
    return list
end
local function GetGrowthItemTools()
    local list = {}
    local containers = { Plr:FindFirstChildOfClass("Backpack"), GetCharacter() }
    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and item:GetAttribute("IsGrowthItemTool") and item:GetAttribute("ItemId") then
                    table.insert(list, item)
                end
            end
        end
    end
    return list
end
local function GetOwnedPlot()
    local moundPlacement = Modules.MoundPlacement
    if moundPlacement and moundPlacement.GetPlot then
        return moundPlacement.GetPlot()
    end
    return nil
end
local function GetPlacedEggPositions()
    local placedEggs = workspace:FindFirstChild("PlacedEggs")
    if not placedEggs then return {} end
    local list = {}
    for _, model in ipairs(placedEggs:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("OwnerUserId") == Plr.UserId then
            table.insert(list, model:GetPivot().Position)
        end
    end
    return list
end
local function FindEggPlacementSpot(plot)
    local plotHatch = Modules.PlotHatch
    if not (plotHatch and plot) then return nil end
    local hitboxes = plotHatch.GetHitboxes(plot)
    if #hitboxes == 0 then return nil end
    local existing = GetPlacedEggPositions()
    for _ = 1, 20 do
        local hitbox = hitboxes[math.random(1, #hitboxes)]
        local size = hitbox.Size / 2
        local localPoint = Vector3.new(
            (math.random() * 2 - 1) * size.X,
            0,
            (math.random() * 2 - 1) * size.Z
        )
        local worldPoint = hitbox.CFrame:PointToWorldSpace(localPoint)
        local farEnough = true
        for _, pos in ipairs(existing) do
            if (pos - worldPoint).Magnitude < 3 then
                farEnough = false
                break
            end
        end
        if farEnough and plotHatch.HitboxContaining(plot, worldPoint) then
            return worldPoint
        end
    end
    return nil
end
local function FindLivePlacementPreview()
    local previewModule = Modules.PlacementPreview
    if not previewModule then return nil end
    local objects = getgc(true)
    for _, obj in ipairs(objects) do
        if type(obj) == "table" and getmetatable(obj) == previewModule then
            local ghost = rawget(obj, "_ghost")
            local confirmed = rawget(obj, "_confirmed")
            local config = rawget(obj, "_config")
            if confirmed == false and config ~= nil and typeof(ghost) == "Instance" and ghost.Parent ~= nil then
                return obj
            end
        end
    end
    return nil
end
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        local threshold = tonumber(Options.SellAtCrumbs and Options.SellAtCrumbs.Value) or 0
        if GetCrumbs() >= threshold and threshold > 0 then
            local sellPad = Modules.SellPad
            local plot = GetOwnedPlot()
            local pad = sellPad and plot and sellPad.Find(plot)
            if pad then
                TPTo(pad, Vector3.new(0, 3, 0))
            end
            task.wait(1)
        else
            task.wait(0.5)
        end
    end
end
local function Func_AutoPlaceEgg()
    while Toggles.AutoPlaceEgg.Value do
        local selected = Shared.GetSelectedEggsToPlace and Shared.GetSelectedEggsToPlace() or {}
        if next(selected) then
            local plot = GetOwnedPlot()
            local char = GetCharacter()
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if plot and humanoid then
                for _, tool in ipairs(GetEggTools()) do
                    local eggId = tool:GetAttribute("EggId")
                    if selected[eggId] and Toggles.AutoPlaceEgg.Value then
                        local spot = FindEggPlacementSpot(plot)
                        if spot then
                            humanoid:EquipTool(tool)
                            task.wait(0.1)
                            local preview = FindLivePlacementPreview()
                            local config = preview and rawget(preview, "_config")
                            if config then
                                config.CursorPosition = function()
                                    return spot
                                end
                                preview:Confirm()
                            end
                            task.wait(0.2)
                            humanoid:UnequipTools()
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoBuyEgg()
    while Toggles.AutoBuyEgg.Value do
        local selected = Shared.GetSelectedEggsToBuy and Shared.GetSelectedEggsToBuy() or {}
        if not next(selected) then
            notyuri("[AutoBuyEgg] no eggs selected in EggBuySelect dropdown, skipping")
        else
            if not Remotes.GetStoreItems then
                notyuri("[AutoBuyEgg] ERROR: Remotes.GetStoreItems is nil, remote not found")
            end
            local result = InvokeRemote(Remotes.GetStoreItems)
            notyuri("[AutoBuyEgg] GetStoreItems result type:", type(result))
            local items = type(result) == "table" and result.Items
            if not items then
                notyuri("[AutoBuyEgg] result.Items missing or not a table")
            else
                local itemCount = 0
                for _ in pairs(items) do itemCount = itemCount + 1 end
                notyuri("[AutoBuyEgg] items count:", itemCount)
                for _, item in pairs(items) do
                    if type(item) == "table" then
                        notyuri("[AutoBuyEgg] store item id:", tostring(item.Id), "category:", tostring(item.Category), "selected match:", tostring(selected[item.Id] ~= nil))
                    end
                end
                for _, item in pairs(items) do
                    if type(item) == "table" and selected[item.Id] then
                        local stock = tonumber(item.Stock) or 0
                        local price = tonumber(item.Price)
                        local currency = item.Currency
                        local data = GetPlayerData()
                        local balance = currency and data and tonumber(data[currency]) or nil
                        notyuri(string.format(
                            "[AutoBuyEgg] check %s: stock=%s price=%s currency=%s balance=%s",
                            tostring(item.Id), tostring(stock), tostring(price), tostring(currency), tostring(balance)
                        ))
                        if not data then
                            notyuri("[AutoBuyEgg] GetPlayerData() returned nil, PlayerController.Replica not ready")
                        end
                        if stock > 0 and price and balance and balance >= price then
                            notyuri("[AutoBuyEgg] firing PurchaseItem for", item.Id)
                            if not Remotes.PurchaseItem then
                                notyuri("[AutoBuyEgg] ERROR: Remotes.PurchaseItem is nil, remote not found")
                            end
                            local purchaseResult = InvokeRemote(Remotes.PurchaseItem, item.Id)
                            notyuri("[AutoBuyEgg] PurchaseItem result:", type(purchaseResult) == "table" and tostring(purchaseResult.Success) or tostring(purchaseResult))
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoBuyItem()
    while Toggles.AutoBuyItem.Value do
        local selected = Shared.GetSelectedItemsToBuy and Shared.GetSelectedItemsToBuy() or {}
        if not next(selected) then
            task.wait(1)
        else
            local result = InvokeRemote(Remotes.GetStoreItems)
            local items = type(result) == "table" and result.Items
            if items then
                for _, item in pairs(items) do
                    if type(item) == "table" and item.Category == "Item" and selected[item.Id] then
                        local maxStock = tonumber(item.MaxStock)
                        local stock = tonumber(item.Stock) or 0
                        local price = tonumber(item.Price)
                        local currency = item.Currency
                        local data = GetPlayerData()
                        local balance = currency and data and tonumber(data[currency]) or nil
                        local inStock = (maxStock == -1) or stock > 0
                        if inStock and price and balance and balance >= price then
                            InvokeRemote(Remotes.PurchaseItem, item.Id)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoPlaceItem()
    while Toggles.AutoPlaceItem.Value do
        local selected = Shared.GetSelectedItemsToPlace and Shared.GetSelectedItemsToPlace() or {}
        local growthItemsMod = Modules.GrowthItems
        local plot = GetOwnedPlot()
        local char = GetCharacter()
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if next(selected) and growthItemsMod and plot and humanoid then
            for _, tool in ipairs(GetGrowthItemTools()) do
                local itemId = tool:GetAttribute("ItemId")
                if type(itemId) == "string" and selected[itemId] and Toggles.AutoPlaceItem.Value then
                    local def = growthItemsMod.Get and growthItemsMod.Get(itemId)
                    if def and not (def.Boost and def.Boost.InstantFinish) then
                        local spot = FindEggPlacementSpot(plot)
                        if spot then
                            humanoid:EquipTool(tool)
                            task.wait(0.1)
                            local preview = FindLivePlacementPreview()
                            local config = preview and rawget(preview, "_config")
                            if config then
                                config.CursorPosition = function()
                                    return spot
                                end
                                preview:Confirm()
                            end
                            task.wait(0.2)
                            humanoid:UnequipTools()
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local selected = Shared.GetSelectedUpgrades and Shared.GetSelectedUpgrades() or {}
        local upgradeMath = Modules.UpgradeMath
        if upgradeMath and next(selected) then
            local sugar = GetSugar()
            for upgradeId in pairs(selected) do
                local level = GetUpgradeLevel("World_0", upgradeId)
                if not upgradeMath.IsMaxed(upgradeId, level) then
                    local cost = upgradeMath.GetCost(upgradeId, level)
                    if cost and sugar >= cost then
                        InvokeRemote(Remotes.UPGRADE_SERVICE_PURCHASE, "World_0", upgradeId)
                        task.wait(0.3)
                        sugar = GetSugar()
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        InvokeRemote(Remotes.REBIRTH_CONTROLLER_REQUEST_REBIRTH)
        task.wait(2)
    end
end
local function Func_AutoClaimDaily()
    while Toggles.AutoClaimDaily.Value do
        local state = InvokeRemote(Remotes.DAILY_REWARD_SERVICE_GET_STATE)
        if type(state) == "table" and state.Success and not state.ClaimedToday then
            InvokeRemote(Remotes.DAILY_REWARD_SERVICE_CLAIM)
        end
        task.wait(30)
    end
end
local function Func_AutoClaimPlaytime()
    while Toggles.AutoClaimPlaytime.Value do
        local state = InvokeRemote(Remotes.PLAYTIME_CHEST_SERVICE_GET_STATE)
        if type(state) == "table" and state.Success and state.Chests then
            for _, chest in ipairs(state.Chests) do
                if chest and chest.Claimable then
                    InvokeRemote(Remotes.PLAYTIME_CHEST_SERVICE_CLAIM, chest.Id)
                    task.wait(0.3)
                end
            end
        end
        task.wait(30)
    end
end
local function Func_AutoClaimQuests()
    while Toggles.AutoClaimQuests.Value do
        local state = InvokeRemote(Remotes.QUEST_SERVICE_GET_STATE)
        if type(state) == "table" and state.Success then
            if state.Daily then
                for _, quest in ipairs(state.Daily) do
                    if quest and not quest.Claimed and quest.Progress >= quest.Target then
                        InvokeRemote(Remotes.QUEST_SERVICE_CLAIM, quest.Id)
                        task.wait(0.3)
                    end
                end
            end
            if state.Milestones then
                for _, quest in ipairs(state.Milestones) do
                    if quest and not quest.Claimed and quest.Progress >= quest.Target then
                        InvokeRemote(Remotes.QUEST_SERVICE_CLAIM, quest.Id)
                        task.wait(0.3)
                    end
                end
            end
        end
        task.wait(30)
    end
end
local function Func_AutoClaimAntIndex()
    while Toggles.AutoClaimAntIndex.Value do
        InvokeRemote(Remotes.ANT_INDEX_CLAIM)
        task.wait(10)
    end
end
local function Func_AutoClaimCollectionIndex()
    while Toggles.AutoClaimCollectionIndex.Value do
        InvokeRemote(Remotes.COLLECTION_INDEX_CLAIM)
        task.wait(10)
    end
end
local function Func_AutoEnableAutoCollect()
    while Toggles.AutoEnableAutoCollect.Value do
        local data = GetPlayerData()
        if data and data.AutoCollectEnabled == false then
            InvokeRemote(Remotes.ANT_COLONY_SET_AUTO_COLLECT, true)
        end
        task.wait(5)
    end
end
local function Func_AutoHatch()
    while Toggles.AutoHatch.Value do
        local placedEggs = workspace:FindFirstChild("PlacedEggs")
        local serverClock = Modules.ServerClock
        local now = serverClock and serverClock.Now() or os.time()
        if placedEggs then
            for _, model in ipairs(placedEggs:GetChildren()) do
                if model:IsA("Model") and model:GetAttribute("OwnerUserId") == Plr.UserId then
                    local eggId = model:GetAttribute("PlacedEggId")
                    if typeof(eggId) == "string" then
                        local readyAt = model:GetAttribute("ReadyAt")
                        if typeof(readyAt) == "number" and readyAt <= now then
                            InvokeRemote(Remotes.EGG_PLACEMENT_OPEN, eggId)
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoFuse()
    while Toggles.AutoFuse.Value do
        local data = GetPlayerData()
        if not data then task.wait(1) else
            if type(data.FusePending) == "table" then
                InvokeRemote(Remotes.FUSE_CLAIM)
                task.wait(1)
            elseif (data.FuseCompleteAt or 0) > 0 then
                task.wait(1)
            else
                local fusion = Modules.Fusion
                local slotCount = (fusion and fusion.FUSE_SLOT_COUNT) or 3
                local minSlots = (fusion and fusion.FUSE_MIN_SLOTS) or 2
                local slots = data.FuseSlots or {}
                local filled = 0
                for _ in pairs(slots) do filled = filled + 1 end
                if filled < slotCount then
                    local selectedRarities = Shared.GetSelectedFuseRarities and Shared.GetSelectedFuseRarities() or {}
                    if next(selectedRarities) then
                        local antTools = GetAntTools()
                        for _, tool in ipairs(antTools) do
                            if filled >= slotCount then break end
                            local rarity = tool:GetAttribute("Rarity")
                            if type(rarity) == "string" and selectedRarities[rarity] then
                                local slotId = tool:GetAttribute("SlotId")
                                if slotId then
                                    local fuseSlotIndex = nil
                                    for i = 1, slotCount do
                                        if not slots[tostring(i)] then
                                            fuseSlotIndex = i
                                            break
                                        end
                                    end
                                    if fuseSlotIndex then
                                        InvokeRemote(Remotes.FUSE_PLACE, fuseSlotIndex, slotId)
                                        task.wait(0.5)
                                        slots[tostring(fuseSlotIndex)] = true
                                        filled = filled + 1
                                    end
                                end
                            end
                        end
                    end
                elseif filled >= minSlots then
                    local result = InvokeRemote(Remotes.FUSE_ACTIVATE)
                    if type(result) == "table" and result.Success then
                        task.wait(1)
                    else
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoMutate()
    while Toggles.AutoMutate.Value do
        local data = GetPlayerData()
        if not data then task.wait(1) else
            if type(data.MutatePending) == "table" then
                local targetVariants = Shared.GetSelectedMutateTargets and Shared.GetSelectedMutateTargets() or {}
                local pendingVariant = tostring(data.MutatePending.Variant or "Normal")
                InvokeRemote(Remotes.MUTATE_CLAIM)
                task.wait(1)
                if next(targetVariants) and targetVariants[pendingVariant] then
                    Toggles.AutoMutate.Value = false
                end
            elseif (data.MutateCompleteAt or 0) > 0 then
                task.wait(1)
            elseif not data.MutateSlot then
                local selectedLabel = Options.MutateAnt and Options.MutateAnt.Value
                local selectedAntId = type(selectedLabel) == "string" and Tables.AntMap and Tables.AntMap[selectedLabel]
                if selectedAntId then
                    local antTools = GetAntTools()
                    local chosenTool = nil
                    for _, tool in ipairs(antTools) do
                        if tool:GetAttribute("AntId") == selectedAntId then
                            chosenTool = tool
                            break
                        end
                    end
                    if chosenTool then
                        local slotId = chosenTool:GetAttribute("SlotId")
                        if slotId then
                            InvokeRemote(Remotes.MUTATE_PLACE, slotId)
                            task.wait(0.3)
                        end
                    end
                end
            else
                InvokeRemote(Remotes.MUTATE_ACTIVATE)
                task.wait(1)
            end
        end
        task.wait(1)
    end
end
local function GetTotalNestIncome()
    local data = GetPlayerData()
    local total = 0
    if data and type(data.Nests) == "table" and type(data.NestIncome) == "table" then
        for nestIndex in pairs(data.Nests) do
            total = total + (tonumber(data.NestIncome[nestIndex]) or 0)
        end
    end
    return total
end
local function Func_AutoClaim()
    while Toggles.AutoClaim.Value do
        local threshold = tonumber(Options.ClaimAtIncome and Options.ClaimAtIncome.Value) or 0
        local total = GetTotalNestIncome()
        if threshold > 0 and total >= threshold then
            local plot = GetOwnedPlot()
            local plotMounds = Modules.PlotMounds
            local anchor = plotMounds and plotMounds.GetElevatorAnchor and plot and plotMounds.GetElevatorAnchor(plot)
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if anchor and hrp then
                local distance = (hrp.Position - anchor.Position).Magnitude
                if distance > 7 then
                    notyuri("[AutoClaim] total income", total, "reached threshold", threshold, "- teleporting to Elevator, distance was", distance)
                    TPTo(anchor)
                    task.wait(0.3)
                end
                local data = GetPlayerData()
                if data and type(data.Nests) == "table" then
                    local nestIncome = data.NestIncome
                    for nestIndex, nestData in pairs(data.Nests) do
                        local income = tonumber(nestIncome and nestIncome[nestIndex]) or 0
                        if type(nestData) == "table" and income > 0 then
                            notyuri("[AutoClaim] claiming nest", tostring(nestIndex), "income:", income)
                            InvokeRemote(Remotes.ANT_COLONY_CLAIM_NEST, nestIndex)
                            task.wait(0.3)
                        end
                    end
                end
            elseif not anchor then
                notyuri("[AutoClaim] could not resolve Elevator anchor (plot/PlotMounds not ready)")
            end
        end
        task.wait(1)
    end
end
local function Func_AutoNest()
    while Toggles.AutoNest.Value do
        local data = GetPlayerData()
        local antUpgrade = Modules.AntUpgrade
        local ants = Modules.Ants
        if data and type(data.Nests) == "table" and antUpgrade and antUpgrade.IsMaxed and antUpgrade.GetCost then
            local sugar = tonumber(data.Sugar) or 0
            for nestIndex, nestData in pairs(data.Nests) do
                if type(nestData) == "table" then
                    local level = tonumber(nestData.Level) or 0
                    if not antUpgrade.IsMaxed(level) then
                        local rarity = nil
                        if ants and ants.Get and type(nestData.AntId) == "string" then
                            local def = ants.Get(nestData.AntId)
                            rarity = def and def.Rarity
                        end
                        local cost = antUpgrade.GetCost(level, rarity)
                        if cost and sugar >= cost then
                            InvokeRemote(Remotes.ANT_COLONY_UPGRADE_NEST, nestIndex)
                            task.wait(0.1)
                            sugar = tonumber(GetSugar()) or 0
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoMound()
    while Toggles.AutoMound.Value do
        local data = GetPlayerData()
        local unlocked = (data and data.UnlockedMounds) or {}
        local mounds = Modules.Mounds
        local sugar = GetSugar()
        if mounds and mounds.Definitions then
            local candidates = {}
            for moundId, def in pairs(mounds.Definitions) do
                local startUnlocked = mounds.StartUnlocked and mounds.StartUnlocked[moundId]
                if not startUnlocked and not unlocked[moundId] then
                    table.insert(candidates, { Id = moundId, Cost = def.Cost or 0, Order = def.Order or 0 })
                end
            end
            table.sort(candidates, function(a, b) return a.Order < b.Order end)
            for _, candidate in ipairs(candidates) do
                if sugar >= candidate.Cost then
                    InvokeRemote(Remotes.MOUND_UNLOCK, candidate.Id)
                    task.wait(0.5)
                    sugar = GetSugar()
                end
            end
        end
        task.wait(5)
    end
end
local function Func_AutoExpand()
    while Toggles.AutoExpand.Value do
        local plot = GetOwnedPlot()
        local expansions = Modules.Expansions
        local interactables = plot and plot:FindFirstChild("Interactables")
        local expansionsFolder = interactables and interactables:FindFirstChild("Expansions")
        if expansions and expansionsFolder then
            local data = GetPlayerData()
            local owned = data and data.Expansions or {}
            local sugar = GetSugar()
            for _, model in ipairs(expansionsFolder:GetChildren()) do
                if model:IsA("Model") and model.Name ~= "Building" then
                    local state = owned[model.Name]
                    local status = state and state.State or "Unbought"
                    if status == "Unbought" then
                        local def = expansions.Get and expansions.Get(model.Name)
                        if def and sugar >= (def.Price or 0) then
                            InvokeRemote(Remotes.EXPANSION_BUY, model.Name)
                            task.wait(0.5)
                            sugar = GetSugar()
                        end
                    end
                end
            end
        end
        task.wait(5)
    end
end
local function Func_AutoBlackhole()
    while Toggles.AutoBlackhole.Value do
        local selected = Shared.GetSelectedBlackholeRarities and Shared.GetSelectedBlackholeRarities() or {}
        if not next(selected) then
            task.wait(1)
        else
            local antTools = GetAntTools()
            for _, tool in ipairs(antTools) do
                local slotId = tool:GetAttribute("SlotId")
                local rarity = tool:GetAttribute("Rarity")
                if slotId and rarity and selected[rarity] then
                    InvokeRemote(Remotes.BLACKHOLE_DISCARD, slotId)
                    task.wait(0.1)
                end
            end
            task.wait(2)
        end
    end
end
local function Func_AutoRoulette()
    while Toggles.AutoRoulette.Value do
        InvokeRemote(Remotes.ROULETTE_CONTROLLER_USE_ROULETTE)
        task.wait(5)
    end
end
local function GetToolOrderWeight(tool)
    local ants = Modules.Ants
    local antId = tool:GetAttribute("AntId")
    local order = 0
    if type(antId) == "string" and ants and ants.Get then
        local def = ants.Get(antId)
        order = (def and def.Order) or 0
    end
    local weight = tonumber(tool:GetAttribute("Weight")) or 0
    return order, weight
end
local function GetBestAntTool()
    local antTools = GetAntTools()
    local best, bestOrder, bestWeight = nil, -1, -1
    for _, tool in ipairs(antTools) do
        local order, weight = GetToolOrderWeight(tool)
        if order > bestOrder or (order == bestOrder and weight > bestWeight) then
            best, bestOrder, bestWeight = tool, order, weight
        end
    end
    return best
end
local function GetNestOrderWeight(nest)
    local ants = Modules.Ants
    local order = 0
    if ants and ants.Get and type(nest.AntId) == "string" then
        local def = ants.Get(nest.AntId)
        order = (def and def.Order) or 0
    end
    local weight = tonumber(nest.Weight) or 0
    return order, weight
end
local function GetNestsByMoundId()
    local data = GetPlayerData()
    local nests = data and data.Nests
    local byMoundId = {}
    if nests then
        for index, nest in nests do
            if nest.MoundId then
                byMoundId[nest.MoundId] = { Index = index, AntId = nest.AntId, Weight = nest.Weight }
            end
        end
    end
    return byMoundId
end
local function GetPlacementTarget()
    local plot = GetOwnedPlot()
    local plotMounds = Modules.PlotMounds
    local eggController = Modules.EggController
    if not (plot and plotMounds and plotMounds.ListMoundIds and eggController and eggController.GetOccupiedMoundIds) then
        return nil
    end
    local occupied = eggController.GetOccupiedMoundIds()
    local moundIds = plotMounds.ListMoundIds(plot)
    for _, moundId in ipairs(moundIds) do
        if not occupied[moundId] then
            return { MoundId = moundId }
        end
    end
    local nestsByMoundId = GetNestsByMoundId()
    local worstMoundId, worstNest, worstOrder, worstWeight = nil, nil, math.huge, math.huge
    for _, moundId in ipairs(moundIds) do
        local nest = nestsByMoundId[moundId]
        if nest then
            local order, weight = GetNestOrderWeight(nest)
            notyuri("[AutoPlaceAnt] GetPlacementTarget: mound", moundId, "occupant antId:", tostring(nest.AntId), "order:", order, "weight:", weight)
            if order < worstOrder or (order == worstOrder and weight < worstWeight) then
                worstMoundId, worstNest, worstOrder, worstWeight = moundId, nest, order, weight
            end
        else
            notyuri("[AutoPlaceAnt] GetPlacementTarget: mound", moundId, "has no matching nest entry (occupied flag set but no nest data found)")
        end
    end
    if not worstMoundId then
        notyuri("[AutoPlaceAnt] GetPlacementTarget: no occupied mound had a resolvable nest entry")
        return nil
    end
    notyuri("[AutoPlaceAnt] GetPlacementTarget: worst occupant is mound", worstMoundId, "antId:", tostring(worstNest.AntId), "order:", worstOrder, "weight:", worstWeight)
    return { MoundId = worstMoundId, Nest = worstNest }
end
local function Func_AutoPlaceAnt()
    while Toggles.AutoPlaceAnt.Value do
        local tool = GetBestAntTool()
        if not tool then
            notyuri("[AutoPlaceAnt] no ant tools in backpack/character")
        else
            local slotId = tool:GetAttribute("SlotId")
            if type(slotId) ~= "string" then
                notyuri("[AutoPlaceAnt] best ant tool has no SlotId attribute")
            else
                local target = GetPlacementTarget()
                if not target then
                    notyuri("[AutoPlaceAnt] no mound available (plot/PlotMounds/EggController not ready)")
                elseif target.Nest then
                    local toolOrder, toolWeight = GetToolOrderWeight(tool)
                    local nestOrder, nestWeight = GetNestOrderWeight(target.Nest)
                    notyuri("[AutoPlaceAnt] comparing tool", tostring(tool:GetAttribute("Rarity")), "(order", toolOrder, "weight", toolWeight, ") vs occupant", tostring(target.Nest.AntId), "(order", nestOrder, "weight", nestWeight, ")")
                    if toolOrder > nestOrder or (toolOrder == nestOrder and toolWeight > nestWeight) then
                        if not Remotes.NEST_PICKUP then
                            notyuri("[AutoPlaceAnt] ERROR: Remotes.NEST_PICKUP is nil, remote not found")
                        end
                        notyuri("[AutoPlaceAnt] picking up", tostring(target.Nest.AntId), "(order", nestOrder, "weight", nestWeight, ") from mound", target.MoundId, "to replace with", tostring(tool:GetAttribute("Rarity")), "(order", toolOrder, "weight", toolWeight, ")")
                        InvokeRemote(Remotes.NEST_PICKUP, target.Nest.Index)
                        task.wait()
                        if not Remotes.NEST_PLACE then
                            notyuri("[AutoPlaceAnt] ERROR: Remotes.NEST_PLACE is nil, remote not found")
                        end
                        notyuri("[AutoPlaceAnt] placing", tostring(tool:GetAttribute("Rarity")), "ant slot", slotId, "into", target.MoundId)
                        InvokeRemote(Remotes.NEST_PLACE, slotId, target.MoundId)
                        task.wait()
                    else
                        notyuri("[AutoPlaceAnt] tool is not better than occupant, skipping replace")
                    end
                else
                    if not Remotes.NEST_PLACE then
                        notyuri("[AutoPlaceAnt] ERROR: Remotes.NEST_PLACE is nil, remote not found")
                    end
                    notyuri("[AutoPlaceAnt] placing", tostring(tool:GetAttribute("Rarity")), "ant slot", slotId, "into", target.MoundId)
                    InvokeRemote(Remotes.NEST_PLACE, slotId, target.MoundId)
                    task.wait()
                end
            end
        end
        task.wait()
    end
end
do
    local upgrades = Modules.Upgrades
    if upgrades and upgrades.Definitions then
        Tables.UpgradeList = {}
        Tables.UpgradeMap = {}
        for key, _ in pairs(upgrades.Definitions) do
            table.insert(Tables.UpgradeList, key)
            Tables.UpgradeMap[key] = key
        end
        table.sort(Tables.UpgradeList)
    end
    local mounds = Modules.Mounds
    if mounds and mounds.Definitions then
        Tables.MoundList = {}
        Tables.MoundMap = {}
        for key, _ in pairs(mounds.Definitions) do
            if not (mounds.StartUnlocked and mounds.StartUnlocked[key]) then
                table.insert(Tables.MoundList, key)
                Tables.MoundMap[key] = key
            end
        end
        table.sort(Tables.MoundList)
    end
    local eggs = Modules.Eggs
    if eggs and eggs.Definitions then
        Tables.EggList = {}
        Tables.EggMap = {}
        for key, def in pairs(eggs.Definitions) do
            local label = (def and def.DisplayName) or key
            table.insert(Tables.EggList, label)
            Tables.EggMap[label] = key
        end
        table.sort(Tables.EggList)
    end
    local ants = Modules.Ants
    if ants and ants.Definitions then
        Tables.AntList = {}
        Tables.AntMap = {}
        for key, def in pairs(ants.Definitions) do
            local label = (def and def.DisplayName) or key
            table.insert(Tables.AntList, label)
            Tables.AntMap[label] = key
        end
        table.sort(Tables.AntList)
    end
    local rarities = Modules.Rarities
    if rarities and rarities.Definitions then
        Tables.RarityList = {}
        Tables.RarityMap = {}
        for key, def in pairs(rarities.Definitions) do
            local label = (def and def.DisplayName) or key
            table.insert(Tables.RarityList, label)
            Tables.RarityMap[label] = key
        end
        table.sort(Tables.RarityList)
    end
    local variants = Modules.Variants
    if type(variants) == "table" then
        local entries = {}
        for key, def in pairs(variants) do
            table.insert(entries, { key = key, order = (def and def.Order) or 0 })
        end
        table.sort(entries, function(a, b) return a.order < b.order end)
        Tables.MutationVariantList = {}
        for _, entry in ipairs(entries) do
            table.insert(Tables.MutationVariantList, entry.key)
        end
    else
        Tables.MutationVariantList = {}
    end
    local growthItems = Modules.GrowthItems
    if growthItems and growthItems.Definitions then
        Tables.ItemList = {}
        Tables.ItemMap = {}
        for key, def in pairs(growthItems.Definitions) do
            local label = (def and def.DisplayName) or key
            table.insert(Tables.ItemList, label)
            Tables.ItemMap[label] = key
        end
        table.sort(Tables.ItemList)
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
        T2 = TB.Main.Left.Autofarm:AddTab("Shop"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Config"),
        T2 = TB.Main.Right.Autofarm:AddTab("ShopConfig"),
    },
}
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("SellAtCrumbs", { Text = "Sell at Crumbs", Default = "1", ClearTextOnFocus = false})
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoClaim", { Text = "Auto Claim", Default = false, ClearTextOnFocus = fals })
TB_Tabs.Autofarm2.T1:AddInput("ClaimAtIncome", { Text = "Claim at Income", Default = "1" })
TB_Tabs.Autofarm.T1:AddToggle("AutoRoulette", { Text = "Auto Roulette", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoHatch", { Text = "Auto Hatch", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoBuyEgg", { Text = "Auto Buy Egg", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoPlaceEgg", { Text = "Auto Place Egg", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoBuyItem", { Text = "Auto Buy Item", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoPlaceItem", { Text = "Auto Place Item", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoFuse", { Text = "Auto Fuse", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoMutate", { Text = "Auto Mutate", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoNest", { Text = "Auto Nests", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBlackhole", { Text = "Auto Blackhole", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlaceAnt", { Text = "Auto Place Ant", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoUpgrade", { Text = "Auto Upgrades", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoMound", { Text = "Auto Mounds", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoExpand", { Text = "Auto Expansions", Default = false })
Shared.GetSelectedUpgrades = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "UpgradeSelect", {
    Text = "Upgrade Select",
    Values = Tables.UpgradeList,
    Default = {},
    label = Tables.UpgradeMap,
})
Shared.GetSelectedEggsToPlace = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "EggPlaceSelect", {
    Text = "Egg Place Select",
    Values = Tables.EggList,
    Default = {},
    label = Tables.EggMap,
})
Shared.GetSelectedEggsToBuy = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "EggBuySelect", {
    Text = "Egg Buy Select",
    Values = Tables.EggList,
    Default = {},
    label = Tables.EggMap,
})
Shared.GetSelectedItemsToBuy = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "ItemBuySelect", {
    Text = "Item Buy Select",
    Values = Tables.ItemList,
    Default = {},
    label = Tables.ItemMap,
})
Shared.GetSelectedItemsToPlace = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "ItemPlaceSelect", {
    Text = "Item Place Select",
    Values = Tables.ItemList,
    Default = {},
    label = Tables.ItemMap,
})
Shared.GetSelectedFuseRarities = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "FuseRaritySelect", {
    Text = "Fuse Rarity Select",
    Values = Tables.RarityList,
    Default = {},
    label = Tables.RarityMap,
})
Shared.GetSelectedBlackholeRarities = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "BlackholeRaritySelect", {
    Text = "Blackhole Rarity Select",
    Values = Tables.RarityList,
    Default = {},
    label = Tables.RarityMap,
})
TB_Tabs.Autofarm2.T2:AddDropdown("MutateAnt", {
    Text = "Mutate Ant",
    Values = Tables.AntList,
    Searchable = true,
    Default = (Tables.AntList and Tables.AntList[1]) or "",
})
Shared.GetSelectedMutateTargets = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "MutateTarget", {
    Text = "Mutate Target",
    Values = Tables.MutationVariantList,
    Default = {},
})
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
Toggles.AutoSell:OnChanged(function(state) Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSell), state) end)
Toggles.AutoUpgrade:OnChanged(function(state) Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state) end)
Toggles.AutoRebirth:OnChanged(function(state) Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), state) end)
Toggles.AutoHatch:OnChanged(function(state) Thread("AutoHatch", SafeLoop("AutoHatch", Func_AutoHatch), state) end)
Toggles.AutoPlaceEgg:OnChanged(function(state) Thread("AutoPlaceEgg", SafeLoop("AutoPlaceEgg", Func_AutoPlaceEgg), state) end)
Toggles.AutoBuyEgg:OnChanged(function(state) Thread("AutoBuyEgg", SafeLoop("AutoBuyEgg", Func_AutoBuyEgg), state) end)
Toggles.AutoBuyItem:OnChanged(function(state) Thread("AutoBuyItem", SafeLoop("AutoBuyItem", Func_AutoBuyItem), state) end)
Toggles.AutoPlaceItem:OnChanged(function(state) Thread("AutoPlaceItem", SafeLoop("AutoPlaceItem", Func_AutoPlaceItem), state) end)
Toggles.AutoFuse:OnChanged(function(state) Thread("AutoFuse", SafeLoop("AutoFuse", Func_AutoFuse), state) end)
Toggles.AutoMutate:OnChanged(function(state) Thread("AutoMutate", SafeLoop("AutoMutate", Func_AutoMutate), state) end)
Toggles.AutoClaim:OnChanged(function(state) Thread("AutoClaim", SafeLoop("AutoClaim", Func_AutoClaim), state) end)
Toggles.AutoNest:OnChanged(function(state) Thread("AutoNest", SafeLoop("AutoNest", Func_AutoNest), state) end)
Toggles.AutoMound:OnChanged(function(state) Thread("AutoMound", SafeLoop("AutoMound", Func_AutoMound), state) end)
Toggles.AutoExpand:OnChanged(function(state) Thread("AutoExpand", SafeLoop("AutoExpand", Func_AutoExpand), state) end)
Toggles.AutoBlackhole:OnChanged(function(state) Thread("AutoBlackhole", SafeLoop("AutoBlackhole", Func_AutoBlackhole), state) end)
Toggles.AutoRoulette:OnChanged(function(state) Thread("AutoRoulette", SafeLoop("AutoRoulette", Func_AutoRoulette), state) end)
Toggles.AutoPlaceAnt:OnChanged(function(state) Thread("AutoPlaceAnt", SafeLoop("AutoPlaceAnt", Func_AutoPlaceAnt), state) end)
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
SaveManager:SetFolder("Yuri/MAC")
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