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
local Knit
do
    local ok, k = pcall(function()
        return require(RS:WaitForChild("Packages"):WaitForChild("Knit"))
    end)
    if ok and k then Knit = k end
end

local SVC = {}
local function GetSvc(name)
    if SVC[name] then return SVC[name] end
    if not Knit then return nil end
    local ok, svc = pcall(function() return Knit.GetService(name) end)
    if ok and svc then
        SVC[name] = svc
        return svc
    end
    return nil
end

local UpgradeTree
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("GameData"):WaitForChild("UpgradeTree"))
    end)
    if ok and mod then UpgradeTree = mod else notyuri("[AutoUpgrade] failed to require UpgradeTree:", mod) end
end

local ForestLevels
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("GameData"):WaitForChild("ForestLevels"))
    end)
    if ok and mod then ForestLevels = mod else notyuri("[AutoUpgrade] failed to require ForestLevels:", mod) end
end

local PlotLevels
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("GameData"):WaitForChild("PlotLevels"))
    end)
    if ok and mod then PlotLevels = mod else notyuri("[AutoUpgrade] failed to require PlotLevels:", mod) end
end

local UserDataStore
do
    local ok, mod = pcall(function()
        return require(Plr:WaitForChild("PlayerScripts"):WaitForChild("Client"):WaitForChild("UserDataStore"))
    end)
    if ok and mod then UserDataStore = mod else notyuri("[AutoUpgrade] failed to require UserDataStore:", mod) end
end

local Workers
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("GameData"):WaitForChild("Workers"))
    end)
    if ok and mod then Workers = mod else notyuri("[AutoSpin] failed to require Workers:", mod) end
end

local Mutations
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("GameData"):WaitForChild("Mutations"))
    end)
    if ok and mod then Mutations = mod else notyuri("[AutoSpin] failed to require Mutations:", mod) end
end

local SlotCosts
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("GameData"):WaitForChild("SlotCosts"))
    end)
    if ok and mod then SlotCosts = mod else notyuri("[AutoUnlockSlot] failed to require SlotCosts:", mod) end
end

local WorkerProgressionUtils
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("Utility"):WaitForChild("WorkerProgressionUtils"))
    end)
    if ok and mod then WorkerProgressionUtils = mod else notyuri("[AutoUpgradeWorker] failed to require WorkerProgressionUtils:", mod) end
end

local UserDataController
do
    local ok, mod = pcall(function()
        return require(Plr:WaitForChild("PlayerScripts"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("UserDataController"))
    end)
    if ok and mod then UserDataController = mod else notyuri("[AutoUpgradeWorker] failed to require UserDataController:", mod) end
end

local POWERUP_LIST = {
    "X2_CASH", "X4_CASH", "X6_CASH",
    "X2_MONEY", "X4_MONEY", "X6_MONEY",
    "X2_SERVER", "X4_SERVER", "LUCKY"
}

local function prettifyUpgradeKey(key)
    local s = key:gsub("Level$", "")
    s = s:gsub("(%l)(%u)", "%1 %2")
    return s
end

local UPGRADE_LIST = {
    { key = "Forest", label = "Forest", treeKey = "Forest" },
    { key = "Plot",   label = "Plot",   treeKey = "Plot" },
}
if UpgradeTree and UpgradeTree.Nodes then
    local seen = {}
    for _, node in pairs(UpgradeTree.Nodes) do
        local upgradeKey = node.Upgrade
        if type(upgradeKey) == "string" and upgradeKey ~= "Start" and not seen[upgradeKey] then
            seen[upgradeKey] = true
            table.insert(UPGRADE_LIST, {
                key = upgradeKey,
                label = prettifyUpgradeKey(upgradeKey),
                treeKey = upgradeKey,
            })
        end
    end
else
    notyuri("[AutoUpgrade] UpgradeTree.Nodes unavailable, only Forest/Plot will be tracked")
end



local RARITY_ORDER = { Common = 1, Rare = 2, Epic = 3, Legendary = 4, Cosmic = 5, Secret = 6, God = 7 }

local SPIN_TARGET_LIST = {}
local SPIN_TARGET_LABEL_TO_NAME = {}
local SPIN_TARGET_LABEL_TO_RARITY = {}
if Workers then
    for rarity, bucket in pairs(Workers) do
        if type(bucket) == "table" then
            for name, cfg in pairs(bucket) do
                if type(cfg) == "table" and cfg.name then
                    local label = ("%s [%s]"):format(cfg.displayName or cfg.name, cfg.rarity or rarity)
                    table.insert(SPIN_TARGET_LIST, label)
                    SPIN_TARGET_LABEL_TO_NAME[label] = cfg.name
                    SPIN_TARGET_LABEL_TO_RARITY[label] = cfg.rarity or rarity
                end
            end
        end
    end
    table.sort(SPIN_TARGET_LIST, function(a, b)
        local ra = RARITY_ORDER[SPIN_TARGET_LABEL_TO_RARITY[a]] or math.huge
        local rb = RARITY_ORDER[SPIN_TARGET_LABEL_TO_RARITY[b]] or math.huge
        if ra ~= rb then return ra < rb end
        return a < b
    end)
end

local SPIN_MUTATION_LIST = {}
local SPIN_MUTATION_LABEL_TO_KEY = {}
if Mutations then
    for _, key in ipairs(Mutations.getMutationsOrder()) do
        local label = Mutations.getDisplayName(key)
        if label == "" then label = key end
        table.insert(SPIN_MUTATION_LIST, label)
        SPIN_MUTATION_LABEL_TO_KEY[label] = key
    end
end

local GetSpinTargetIds = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "SpinTargetSelected", {
    Text = "Spin Target",
    Values = SPIN_TARGET_LIST,
    Default = { ["All"] = true },
    label = SPIN_TARGET_LABEL_TO_NAME,
})
local GetSpinMutationIds = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "SpinMutationSelected", {
    Text = "Spin Mutation",
    Values = SPIN_MUTATION_LIST,
    Default = { ["All"] = true },
    label = SPIN_MUTATION_LABEL_TO_KEY,
})

local Timber = {
    pendingCutTime = 0,
    cutStartAt = 0,
    isCutting = false,
    session = {
        treesCut = 0,
        woodSold = 0,
        slotsCollected = 0,
        spinsDone = 0,
        eggsOpened = 0,
        powerupsUsed = 0,
        rewardsClaimed = 0,
        workersSold = 0,
        upgradesBought = 0,
        lastCutAt = 0,
        lastSellAt = 0,
        lastCollectAt = 0,
        lastSpinAt = 0,
        lastEggAt = 0,
        lastPowerupAt = 0,
        lastRewardAt = 0,
        lastWorkerSellAt = 0,
        lastUpgradeAt = 0,
    },
}

local Get, Send, Func

-- Shared FIFO queue for matched roulette buys, so multiple matches from the
-- same (or overlapping) spin batches are bought one at a time against the
-- same cash pool instead of racing each other in independent loops.
local SpinBuyQueue = {}
local SpinBuyQueueRunning = false

local function ProcessSpinBuyQueue()
    if SpinBuyQueueRunning then return end
    SpinBuyQueueRunning = true
    task.spawn(function()
        while #SpinBuyQueue > 0 do
            if not Toggles.AutoSpin.Value or Library.Unloaded then
                table.clear(SpinBuyQueue)
                break
            end
            local job = table.remove(SpinBuyQueue, 1)
            local roulette = job.roulette
            local price = job.price
            local workerName = job.workerName
            local mutation = job.mutation
            local myLockAttr = tostring(Plr.UserId) .. "_locked"

            while Toggles.AutoSpin.Value and not Library.Unloaded do
                local promptPart = roulette:FindFirstChild("PromptPart")
                local prompt = promptPart and promptPart:FindFirstChild("BuyPrompt")
                if not (prompt and prompt:IsA("ProximityPrompt")) then
                    notyuri("[AutoSpin] BuyPrompt gone for", tostring(workerName), tostring(mutation), "-> bought or expired")
                    break
                end
                if prompt:GetAttribute(myLockAttr) == true then
                    notyuri("[AutoSpin] BuyPrompt locked for us on", tostring(workerName), tostring(mutation), "-> stopping")
                    break
                end

                local data = UserDataStore and UserDataStore.Get and UserDataStore.Get()
                local cash = (data and data.cash) or 0
                if cash < price then
                    task.wait(0.5)
                else
                    notyuri("[AutoSpin] buying", tostring(workerName), tostring(mutation), "price:", price)
                    FirePP(prompt, true)
                    task.wait(0.3)
                end
            end
        end
        SpinBuyQueueRunning = false
    end)
end

Get = {
    Money = function()
        local ls = Plr:FindFirstChild("leaderstats")
        if not ls then return "0" end
        local c = ls:FindFirstChild("Cash")
        return (c and c.Value) or "0"
    end,
    MoneyPerMin = function()
        local svc = GetSvc("UserDataService")
        if not svc then return 0 end
        local ok, v = pcall(function()
            local prop = svc["Money/Min"]
            if not prop then return 0 end
            if prop.Get then return prop:Get() or 0 end
            return 0
        end)
        return (ok and tonumber(v)) or 0
    end,
    OnlineFriends = function()
        local svc = GetSvc("UserDataService")
        if not svc then return 0 end
        local ok, v = pcall(function()
            local prop = svc.OnlineFriends
            if not prop then return 0 end
            if prop.Get then return prop:Get() or 0 end
            return 0
        end)
        return (ok and tonumber(v)) or 0
    end,
    SellMultiplier = function()
        local svc = GetSvc("VisualsService")
        if not svc then return 1 end
        local ok, v = pcall(function()
            local prop = svc.WoodSellMultiplier
            if not prop then return 1 end
            if prop.Get then return prop:Get() or 1 end
            return 1
        end)
        return (ok and tonumber(v)) or 1
    end,
    Plot = function()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local name = ("user_%s_plot"):format(tostring(Plr.UserId))
        return plots:FindFirstChild(name)
    end,
    CuttableTrees = function()
        local plot = Get.Plot()
        local out = {}
        if not plot then return out end
        for _, m in ipairs(plot:GetDescendants()) do
            if m:IsA("Model") and typeof(m:GetAttribute("TreeOwnerUserId")) == "number"
                and m:GetAttribute("TreeOwnerUserId") == Plr.UserId
                and m:GetAttribute("PlayerCutAvailable") == true then
                out[#out + 1] = m
            end
        end
        return out
    end,
    NearestCuttableTree = function()
        local trees = Get.CuttableTrees()
        if #trees == 0 then return nil end
        local char = Plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return trees[1] end
        local best, bestDist = nil, math.huge
        for _, t in ipairs(trees) do
            local ok, pos = pcall(function() return t:GetPivot().Position end)
            if ok and pos then
                local d = (hrp.Position - pos).Magnitude
                if d < bestDist then best, bestDist = t, d end
            end
        end
        return best or trees[1]
    end,
    UnlockedSlots = function()
        local plot = Get.Plot()
        local out = {}
        if not plot then return out end
        for _, inst in ipairs(plot:GetDescendants()) do
            if inst:IsA("Model") and inst:GetAttribute("SlotIndex") ~= nil and inst:GetAttribute("IsUnlocked") == true then
                local fi = tonumber(inst:GetAttribute("FloorIndex"))
                local mi = tonumber(inst:GetAttribute("FarmIndex"))
                local si = tonumber(inst:GetAttribute("SlotIndex"))
                if fi and mi and si then
                    out[#out + 1] = {
                        floor = fi,
                        farm = mi,
                        slot = si,
                        model = inst,
                        logs = tonumber(inst:GetAttribute("LogsAmount")) or 0,
                        maxLogs = tonumber(inst:GetAttribute("MaxLogs")),
                    }
                end
            end
        end
        return out
    end,
    LockedSlots = function()
        local plot = Get.Plot()
        local out = {}
        if not plot then return out end
        for _, inst in ipairs(plot:GetDescendants()) do
            if inst:IsA("Model") and inst:GetAttribute("SlotIndex") ~= nil and inst:GetAttribute("IsUnlocked") == false then
                local fi = tonumber(inst:GetAttribute("FloorIndex"))
                local mi = tonumber(inst:GetAttribute("FarmIndex"))
                local si = tonumber(inst:GetAttribute("SlotIndex"))
                if fi and mi and si then
                    out[#out + 1] = {
                        floor = fi,
                        farm = mi,
                        slot = si,
                        model = inst,
                    }
                end
            end
        end
        return out
    end,
    WorkersWorth = function()
        local svc = GetSvc("WorkerActionsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestAllWorkersWorth():await()
        end)
        if ok and v1 then return v2 end
        return nil
    end,
    AutoRollState = function()
        local svc = GetSvc("AutoRollService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:GetAutoRollState():await()
        end)
        if ok and v1 and type(v2) == "table" then return v2 end
        return nil
    end,
    LastTreeCutPos = function()
        local tree = Get.NearestCuttableTree()
        if not tree then return nil end
        local ok, pos = pcall(function() return tree:GetPivot().Position end)
        return ok and pos or nil
    end,
}

Send = {
    CutTree = function(tree)
        if not tree then return false, nil end
        local svc = GetSvc("TreeCuttingService")
        if not svc then return false, nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestCutTree(tree):await()
        end)
        if not ok then return false, nil end
        if v1 and v2 and v2.accepted == true then
            return true, v2.cuttingTime
        end
        return false, nil
    end,
    SellWood = function()
        local svc = GetSvc("SellWoodService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestSellWood():await()
        end)
        return ok and v1 or nil, v2
    end,
    CollectSlotCash = function(fi, mi, si)
        local svc = GetSvc("WorkerActionsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestCollectSlotCash(fi, mi, si):await()
        end)
        return ok and v1 or nil, v2
    end,
    EquipBest = function()
        local svc = GetSvc("WorkerActionsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestEquipBest():await()
        end)
        return ok and v1 or nil, v2
    end,
    SellAllWorkers = function()
        local svc = GetSvc("WorkerActionsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestSellAllWorkers():await()
        end)
        return ok and v1 or nil, v2
    end,
    Spin = function()
        local svc = GetSvc("PlotSpinService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestSpin():await()
        end)
        return ok and v1 or nil, v2
    end,
    OpenLuckyEgg = function(fastOpen)
        local svc = GetSvc("TimedLuckyEggService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestOpenLuckyEgg(fastOpen == true):await()
        end)
        return ok and v1 or nil, v2
    end,
    ActivatePowerup = function(id)
        if not id then return nil end
        local svc = GetSvc("PowerupService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestActivatePowerup(id):await()
        end)
        return ok and v1 or nil, v2
    end,
    StartAutoRoll = function(rarity, mutation)
        if not rarity or rarity == "" then return nil end
        local svc = GetSvc("AutoRollService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:StartAutoRoll(rarity, mutation):await()
        end)
        return ok and v1 or nil, v2
    end,
    StopAutoRoll = function()
        local svc = GetSvc("AutoRollService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:StopAutoRoll():await()
        end)
        return ok and v1 or nil, v2
    end,
    ClaimDailyReward = function(idx)
        local svc = GetSvc("RewardsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestClaimDailyReward(idx):await()
        end)
        return ok and v1 or nil, v2
    end,
    ClaimFreeReward = function(idx)
        local svc = GetSvc("RewardsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestClaimFreeReward(idx):await()
        end)
        return ok and v1 or nil, v2
    end,
    ClaimPlaytimeReward = function(idx)
        local svc = GetSvc("RewardsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestClaimPlaytimeReward(idx):await()
        end)
        return ok and v1 or nil, v2
    end,
    ClaimFreeMoney = function()
        local svc = GetSvc("RewardsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestClaimFreeMoney():await()
        end)
        return ok and v1 or nil, v2
    end,
    ClaimQuitGameReward = function()
        local svc = GetSvc("RewardsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestClaimQuitGameReward():await()
        end)
        return ok and v1 or nil, v2
    end,
    KeepOfflineStock = function()
        local svc = GetSvc("OfflineEarningsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestKeepOfflineStock():await()
        end)
        return ok and v1 or nil, v2
    end,
    TeleportToBase = function()
        local svc = GetSvc("GeneralUserService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestTeleportToBase():await()
        end)
        return ok and v1 or nil, v2
    end,
    TeleportToFloor = function(floorIdx, plotIdx)
        local svc = GetSvc("GeneralUserService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestTeleportToFloor(floorIdx, plotIdx):await()
        end)
        return ok and v1 or nil, v2
    end,
    UpgradeForest = function()
        local svc = GetSvc("UpgradesService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestUpgradeForest():await()
        end)
        return ok and v1 or nil, v2
    end,
    UpgradePlot = function()
        local svc = GetSvc("UpgradesService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestUpgradePlot():await()
        end)
        return ok and v1 or nil, v2
    end,
    UpgradeNode = function(nodeId)
        if not nodeId then return nil end
        local svc = GetSvc("UpgradesService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestUpgrade(nodeId):await()
        end)
        return ok and v1 or nil, v2
    end,
    SellWorkerByUUID = function(uuid)
        if not uuid then return nil end
        local svc = GetSvc("WorkerActionsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestSellWorkerByUUID(uuid):await()
        end)
        return ok and v1 or nil, v2
    end,
    RemoveWorkerFromSlot = function(fi, mi, si)
        local svc = GetSvc("WorkerActionsService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:RequestRemoveWorkerFromSlot(fi, mi, si):await()
        end)
        return ok and v1 or nil, v2
    end,
    ToggleSetting = function(key, value)
        local svc = GetSvc("UserDataService")
        if not svc then return nil end
        local ok, v1, v2 = pcall(function()
            return svc:ToggleSetting(key, value):await()
        end)
        return ok and v1 or nil, v2
    end,
}

Func = {
    AutoCut = function()
        while Toggles.AutoCut.Value and not Library.Unloaded do
            local ok, err = pcall(function()
                if Timber.isCutting then
                    if tick() - Timber.cutStartAt >= Timber.pendingCutTime then
                        Timber.isCutting = false
                        Timber.pendingCutTime = 0
                    else
                        task.wait(0.2)
                        return
                    end
                end
                local char = GetCharacter()
                local hasTool = char and char:FindFirstChildOfClass("Tool")
                if not hasTool then
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    local backpack = Plr:FindFirstChild("Backpack")
                    local axe = nil
                    if backpack then
                        for _, item in ipairs(backpack:GetChildren()) do
                            if item:IsA("Tool") and item:GetAttribute("itemType") == "axeItem" then
                                axe = item
                                break
                            end
                        end
                    end
                    if humanoid and axe then
                        notyuri("[AutoCut] no tool equipped, equipping", axe.Name)
                        humanoid:EquipTool(axe)
                        task.wait(0.3)
                    else
                        task.wait(0.3)
                    end
                    return
                end
                local pos = Get.LastTreeCutPos()
                if pos then
                    TPTo(pos + Vector3.new(0, 3, 0))
                    task.wait(0.15)
                end
                local tree = Get.NearestCuttableTree()
                if not tree then
                    task.wait(0.5)
                    return
                end
                local accepted, cutTime = Send.CutTree(tree)
                if accepted then
                    Timber.session.treesCut = Timber.session.treesCut + 1
                    Timber.session.lastCutAt = tick()
                    Timber.isCutting = true
                    Timber.pendingCutTime = (tonumber(cutTime) or 1) + 0.3
                    Timber.cutStartAt = tick()
                    task.wait(Timber.pendingCutTime)
                    Timber.isCutting = false
                    Timber.pendingCutTime = 0
                else
                    task.wait(0.4)
                end
            end)
            if not ok then
                task.wait(0.5)
            end
            task.wait(0.05)
        end
    end,
    AutoSell = function()
        while Toggles.AutoSell.Value and not Library.Unloaded do
            local requireMult = Toggles.SellAtMult and Toggles.SellAtMult.Value
            local targetMult = requireMult and tonumber(Options.SellAtMultValue.Value) or nil
            if requireMult and (not targetMult or Get.SellMultiplier() < targetMult) then
                task.wait(0.2)
            else
                local ok = pcall(function()
                    Send.SellWood()
                    Timber.session.woodSold = Timber.session.woodSold + 1
                    Timber.session.lastSellAt = tick()
                end)
                task.wait(1)
            end
        end
    end,
    AutoCollect = function()
        while Toggles.AutoCollect.Value and not Library.Unloaded do
            local ok = pcall(function()
                local thresholdPct = tonumber(Options.CollectThreshold and Options.CollectThreshold.Value) or 100
                local slots = Get.UnlockedSlots()
                for _, s in ipairs(slots) do
                    if not Toggles.AutoCollect.Value then return end
                    if Library.Unloaded then return end
                    local shouldCollect
                    if s.maxLogs and s.maxLogs > 0 then
                        shouldCollect = (s.logs / s.maxLogs) * 100 >= thresholdPct
                    else
                        shouldCollect = s.logs > 0
                    end
                    if shouldCollect then
                        local collectPart = s.model:FindFirstChild("CollectMoneyPart")
                        if collectPart and collectPart:IsA("BasePart") then
                            local char = GetCharacter()
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            local inRange = false
                            if hrp then
                                local dist = (hrp.Position - collectPart.Position).Magnitude
                                inRange = dist <= 30
                            end
                            if not inRange then
                                TPTo(collectPart)
                                task.wait(0.05)
                            end
                        end
                        Send.CollectSlotCash(s.floor, s.farm, s.slot)
                        Timber.session.slotsCollected = Timber.session.slotsCollected + 1
                        Timber.session.lastCollectAt = tick()
                        task.wait(0.08)
                    end
                end
            end)
            task.wait(0.5)
        end
    end,
    AutoUnlockSlot = function()
        while Toggles.AutoUnlockSlot.Value and not Library.Unloaded do
            local ok, err = pcall(function()
                local slots = Get.LockedSlots()
                local myLockAttr = tostring(Plr.UserId) .. "_locked"
                for _, s in ipairs(slots) do
                    if not Toggles.AutoUnlockSlot.Value then return end
                    if Library.Unloaded then return end
                    local promptPart = s.model:FindFirstChild("UnlockPromptPart")
                    local prompt = promptPart and promptPart:FindFirstChild("UnlockPrompt")
                    if prompt and prompt:IsA("ProximityPrompt") and prompt:GetAttribute(myLockAttr) ~= true then
                        local cost = nil
                        if SlotCosts then
                            local byFloor = SlotCosts[s.floor]
                            local byFarm = byFloor and byFloor[s.farm]
                            cost = byFarm and byFarm[s.slot]
                        end
                        if type(cost) == "number" then
                            while Toggles.AutoUnlockSlot.Value and not Library.Unloaded do
                                local data = UserDataStore and UserDataStore.Get and UserDataStore.Get()
                                local cash = (data and data.cash) or 0
                                if cash < cost then
                                    task.wait(0.5)
                                else
                                    break
                                end
                            end
                            if not (Toggles.AutoUnlockSlot.Value and not Library.Unloaded) then return end
                        else
                            notyuri("[AutoUnlockSlot] no cost found for slot", s.floor, s.farm, s.slot, "-> firing without cash check")
                        end
                        notyuri("[AutoUnlockSlot] firing UnlockPrompt for slot", s.floor, s.farm, s.slot)
                        FirePP(prompt, true)
                        task.wait(0.3)
                    end
                end
            end)
            if not ok then notyuri("[AutoUnlockSlot] pcall error:", err) end
            task.wait(1)
        end
    end,
    AutoUpgradeWorker = function()
        while Toggles.AutoUpgradeWorker.Value and not Library.Unloaded do
            local ok, err = pcall(function()
                if not (WorkerProgressionUtils and UserDataController and Workers) then
                    notyuri("[AutoUpgradeWorker] required modules unavailable, skipping")
                    return
                end
                local svc = GetSvc("WorkerActionsService")
                if not svc then
                    notyuri("[AutoUpgradeWorker] WorkerActionsService unavailable, skipping")
                    return
                end
                local ok2, workers = pcall(function() return UserDataController:GetPlotWorkers() end)
                if not ok2 or type(workers) ~= "table" then
                    notyuri("[AutoUpgradeWorker] GetPlotWorkers failed:", workers)
                    return
                end
                local maxLevel = WorkerProgressionUtils.getMaxLevel()
                for _, entry in pairs(workers) do
                    if not Toggles.AutoUpgradeWorker.Value then return end
                    if Library.Unloaded then return end
                    local wd = entry.workerExportData
                    if type(wd) == "table" then
                        local cfg = Workers.getConfig(wd.rarity, wd.name)
                        if cfg and not cfg.isPercentageWorker and (wd.level or 0) < maxLevel then
                            local price = WorkerProgressionUtils.getUpgradePrice(cfg.firstUpgradeCost or 0, wd.level)
                            while Toggles.AutoUpgradeWorker.Value and not Library.Unloaded do
                                local data = UserDataStore and UserDataStore.Get and UserDataStore.Get()
                                local cash = (data and data.cash) or 0
                                if cash < price then
                                    task.wait()
                                else
                                    break
                                end
                            end
                            if not (Toggles.AutoUpgradeWorker.Value and not Library.Unloaded) then return end
                            notyuri("[AutoUpgradeWorker] upgrading", tostring(wd.name), tostring(wd.rarity), "level", tostring(wd.level), "price:", price)
                            local ok3, err3 = pcall(function()
                                return svc:RequestUpgradeWorker(entry.floorIndx, entry.farmIndx, entry.slotIndx):await()
                            end)
                            if not ok3 then notyuri("[AutoUpgradeWorker] InvokeServer error:", err3) end
                            task.wait()
                        end
                    end
                end
            end)
            if not ok then notyuri("[AutoUpgradeWorker] pcall error:", err) end
            task.wait()
        end
    end,
    HandleSpinResult = function(entry)
        if not Toggles.AutoSpin.Value then return end
        if type(entry) ~= "table" then return end
        local winner = entry[2]
        local roulette = entry[4]
        if type(winner) ~= "table" then return end
        if winner.ownerUserId ~= Plr.UserId then return end
        if typeof(roulette) ~= "Instance" or not roulette:IsA("Model") then return end

        local promptPart = roulette:FindFirstChild("PromptPart")
        local prompt = promptPart and promptPart:FindFirstChild("BuyPrompt")
        if not (prompt and prompt:IsA("ProximityPrompt")) then
            notyuri("[AutoSpin] result for", tostring(winner.name), "-> no BuyPrompt found on roulette")
            return
        end

        local targetIds = GetSpinTargetIds()
        local mutationIds = GetSpinMutationIds()
        local workerName = winner.name
        local mutation = winner.mutation

        local targetOk = workerName ~= nil and targetIds[workerName] == true
        local mutationOk = mutation ~= nil and mutationIds[mutation] == true

        if not (targetOk and mutationOk) then
            notyuri("[AutoSpin] no match for", tostring(workerName), tostring(mutation), "-> skipping")
            return
        end

        if not Workers then
            notyuri("[AutoSpin] Workers module unavailable, cannot verify price -> skipping buy")
            return
        end
        local cfg = Workers.getConfig(winner.rarity, workerName)
        local price = cfg and cfg.price
        if type(price) ~= "number" then
            notyuri("[AutoSpin] no price found for", tostring(workerName), tostring(winner.rarity), "-> skipping buy")
            return
        end

        notyuri("[AutoSpin] matched", tostring(workerName), tostring(mutation), "price:", price, "-> queued for buy")

        table.insert(SpinBuyQueue, {
            roulette = roulette,
            price = price,
            workerName = workerName,
            mutation = mutation,
        })
        ProcessSpinBuyQueue()
    end,
    AutoSpin = function()
        while Toggles.AutoSpin.Value and not Library.Unloaded do
            if #SpinBuyQueue > 0 then
                notyuri("[AutoSpin] queue has", #SpinBuyQueue, "pending -> pausing spin")
                repeat
                    task.wait(0.5)
                until #SpinBuyQueue == 0 or not Toggles.AutoSpin.Value or Library.Unloaded
            end
            if not (Toggles.AutoSpin.Value and not Library.Unloaded) then break end
            local ok, err = pcall(function()
                local plot = Get.Plot()
                local spinWorkerModel = plot and plot:FindFirstChild("spinWorkerModel", true)
                local rouletteButton = spinWorkerModel and spinWorkerModel:FindFirstChild("RouletteButton")
                local button = rouletteButton and rouletteButton:FindFirstChild("Button")
                local prompt = button and button:FindFirstChild("RouletteButtonPrompt")
                if not (prompt and prompt:IsA("ProximityPrompt")) then
                    notyuri("[AutoSpin] RouletteButtonPrompt not found, skipping")
                    return
                end
                FirePP(prompt, true)
                Timber.session.spinsDone = Timber.session.spinsDone + 1
                Timber.session.lastSpinAt = tick()
            end)
            if not ok then notyuri("[AutoSpin] pcall error:", err) end
            task.wait(2.5)
        end
    end,
    AutoOpenEgg = function()
        while Toggles.AutoOpenEgg.Value and not Library.Unloaded do
            local ok = pcall(function()
                local v1, v2 = Send.OpenLuckyEgg(true)
                if v1 then
                    Timber.session.eggsOpened = Timber.session.eggsOpened + 1
                    Timber.session.lastEggAt = tick()
                    task.wait(15)
                else
                    task.wait(5)
                end
            end)
            if not ok then task.wait(5) end
        end
    end,
    AutoEquip = function()
        while Toggles.AutoEquip.Value and not Library.Unloaded do
            local ok = pcall(function()
                Send.EquipBest()
            end)
            task.wait(5)
        end
    end,
    AutoSellAllWorkers = function()
        while Toggles.AutoSellAllWorkers.Value and not Library.Unloaded do
            local ok = pcall(function()
                Send.SellAllWorkers()
                Timber.session.workersSold = Timber.session.workersSold + 1
                Timber.session.lastWorkerSellAt = tick()
            end)
            task.wait(10)
        end
    end,
    AutoClaimDailyReward = function()
        while Toggles.AutoClaimDailyReward.Value and not Library.Unloaded do
            local ok = pcall(function()
                local idx = tonumber(Options.DailyIndexValue.Value) or 1
                Send.ClaimDailyReward(idx)
                Timber.session.rewardsClaimed = Timber.session.rewardsClaimed + 1
                Timber.session.lastRewardAt = tick()
            end)
            task.wait(30)
        end
    end,
    AutoClaimFreeReward = function()
        while Toggles.AutoClaimFreeReward.Value and not Library.Unloaded do
            local ok = pcall(function()
                local idx = tonumber(Options.FreeIndexValue.Value) or 1
                Send.ClaimFreeReward(idx)
                Timber.session.rewardsClaimed = Timber.session.rewardsClaimed + 1
                Timber.session.lastRewardAt = tick()
            end)
            task.wait(30)
        end
    end,
    AutoClaimPlaytimeReward = function()
        while Toggles.AutoClaimPlaytimeReward.Value and not Library.Unloaded do
            local ok = pcall(function()
                local idx = tonumber(Options.PlaytimeIndexValue.Value) or 1
                Send.ClaimPlaytimeReward(idx)
                Timber.session.rewardsClaimed = Timber.session.rewardsClaimed + 1
                Timber.session.lastRewardAt = tick()
            end)
            task.wait(30)
        end
    end,
    AutoClaimFreeMoney = function()
        while Toggles.AutoClaimFreeMoney.Value and not Library.Unloaded do
            local ok = pcall(function()
                Send.ClaimFreeMoney()
                Timber.session.rewardsClaimed = Timber.session.rewardsClaimed + 1
                Timber.session.lastRewardAt = tick()
            end)
            task.wait(120)
        end
    end,
    AutoClaimQuitGameReward = function()
        while Toggles.AutoClaimQuitGameReward.Value and not Library.Unloaded do
            local ok = pcall(function()
                Send.ClaimQuitGameReward()
                Timber.session.rewardsClaimed = Timber.session.rewardsClaimed + 1
                Timber.session.lastRewardAt = tick()
            end)
            task.wait(60)
        end
    end,
    AutoActivatePowerup = function()
        while Toggles.AutoActivatePowerup.Value and not Library.Unloaded do
            local ok = pcall(function()
                local pid = Options.PowerupDropdown.Value
                if pid and pid ~= "" then
                    Send.ActivatePowerup(pid)
                    Timber.session.powerupsUsed = Timber.session.powerupsUsed + 1
                    Timber.session.lastPowerupAt = tick()
                end
            end)
            task.wait(60)
        end
    end,
    AutoKeepOfflineStock = function()
        while Toggles.AutoKeepOfflineStock.Value and not Library.Unloaded do
            local ok = pcall(function()
                Send.KeepOfflineStock()
            end)
            task.wait(30)
        end
    end,
    CanAffordUpgrade = function(u)
        if not UserDataStore then
            notyuri("[AutoUpgrade]", u.key, "-> UserDataStore missing, allowing by default")
            return true
        end
        local playerData = UserDataStore.Get()
        if not playerData then
            notyuri("[AutoUpgrade]", u.key, "-> UserDataStore.Get() returned nil, allowing by default")
            return true
        end
        local cash = playerData.cash or 0

        if u.key == "Forest" then
            if not ForestLevels then
                notyuri("[AutoUpgrade] Forest -> ForestLevels missing, allowing by default")
                return true
            end
            local nextLevel = ForestLevels[(playerData.forestLevel or 1) + 1]
            if not nextLevel then
                notyuri("[AutoUpgrade] Forest -> no next level (maxed), skipping")
                return false
            end
            local can = (nextLevel.upgradeCost or 0) <= cash
            notyuri("[AutoUpgrade] Forest -> cost", nextLevel.upgradeCost, "cash", cash, "canAfford", can)
            return can
        end

        if u.key == "Plot" then
            if not PlotLevels then
                notyuri("[AutoUpgrade] Plot -> PlotLevels missing, allowing by default")
                return true
            end
            local nextLevel = PlotLevels[(playerData.plotLevel or 0) + 1]
            if not nextLevel then
                notyuri("[AutoUpgrade] Plot -> no next level (maxed), skipping")
                return false
            end
            local can = (nextLevel.upgradeCost or 0) <= cash
            notyuri("[AutoUpgrade] Plot -> cost", nextLevel.upgradeCost, "cash", cash, "canAfford", can)
            return can
        end

        if not UpgradeTree then
            notyuri("[AutoUpgrade]", u.key, "-> UpgradeTree missing, allowing by default")
            return true
        end
        local owned = playerData.Upgrades or {}
        local candidateFound = false
        for nodeId, node in pairs(UpgradeTree.Nodes) do
            if node.Upgrade == u.treeKey and owned[nodeId] ~= true then
                candidateFound = true
                local metRequirements = true
                for _, reqId in ipairs(node.Requirements or {}) do
                    if owned[reqId] ~= true then
                        metRequirements = false
                        break
                    end
                end
                if metRequirements then
                    local cost = node.Cost and node.Cost.Amount or 0
                    if cost <= cash then
                        notyuri("[AutoUpgrade]", u.key, "-> buyable node", nodeId, "cost", cost, "cash", cash)
                        return nodeId
                    end
                end
            end
        end
        if not candidateFound then
            notyuri("[AutoUpgrade]", u.key, "-> no unowned node found for treeKey", u.treeKey)
        else
            notyuri("[AutoUpgrade]", u.key, "-> unowned node(s) exist but none buyable (locked or too expensive)")
        end
        return false
    end,
    AutoUpgrade = function()
        while Toggles.AutoUpgrade.Value and not Library.Unloaded do
            local ok, err = pcall(function()
                notyuri("[AutoUpgrade] tick")
                for _, u in ipairs(UPGRADE_LIST) do
                    if not Toggles.AutoUpgrade.Value then return end
                    if Library.Unloaded then return end
                    local result = Func.CanAffordUpgrade(u)
                    if result then
                        if u.key == "Forest" then Send.UpgradeForest()
                        elseif u.key == "Plot" then Send.UpgradePlot()
                        else Send.UpgradeNode(result) end
                        Timber.session.upgradesBought = Timber.session.upgradesBought + 1
                        Timber.session.lastUpgradeAt = tick()
                        task.wait(0.2)
                    end
                end
            end)
            if not ok then
                notyuri("[AutoUpgrade] pcall error:", err)
            end
            task.wait(1)
        end
    end,
    AutoStartAutoRoll = function()
        while Toggles.AutoStartAutoRoll.Value and not Library.Unloaded do
            local ok = pcall(function()
                local rarity = Options.AutoRollRarity.Value or "Common"
                local mutation = Options.AutoRollMutation.Value or ""
                Send.StartAutoRoll(rarity, mutation)
            end)
            task.wait(15)
        end
    end,
}
TB_Tabs.Autofarm.T1:AddToggle("AutoCut", { Text = "Auto Cut Tree", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false })
AddSliderToggle({ Group = TB_Tabs.Autofarm.T1, Id = "SellAtMult", Text = "Sell At Multiplier", Default = 1.5, Min = 0.5, Max = 5, Rounding = 1 })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect", Default = false })
TB_Tabs.Autofarm2.T1:AddSlider("CollectThreshold", { Text = "Collect Threshold", Default = 100, Min = 1, Max = 100, Rounding = 0, Compact = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoUnlockSlot", { Text = "Auto Unlock Slot", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradeWorker", { Text = "Auto Upgrade Worker", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSpin", { Text = "Auto Spin", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoOpenEgg", { Text = "Auto Open Egg", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
SafeConnect("CurrencyEarned",
    function() local svc = GetSvc("UserDataService"); return svc and svc.CurrencyEarned end,
    function(amount, currency, reason)
    end)
SafeConnect("ItemsWon",
    function() local svc = GetSvc("RewardsService"); return svc and svc.OnItemsWon end,
    function(items)
        if type(items) ~= "table" then return end
    end)
SafeConnect("SpinResult",
    function() local svc = GetSvc("PlotSpinService"); return svc and svc.SpinResult end,
    function(res)
        if type(res) ~= "table" then return end
        for _, entry in pairs(res) do
            if type(entry) == "table" then
                Func.HandleSpinResult(entry)
            end
        end
    end)
SafeConnect("WorkerUpdated",
    function() local svc = GetSvc("WorkerActionsService"); return svc and svc.WorkerUpdated end,
    function(worker)
    end)
SafeConnect("ServerMessage",
    function() local svc = GetSvc("NotificationService"); return svc and svc.OnServerMessage end,
    function(msg)
    end)
SafeConnect("ChatTip",
    function() local svc = GetSvc("NotificationService"); return svc and svc.OnChatTip end,
    function(tip)
    end)
SafeConnect("CutCancelled",
    function() local svc = GetSvc("TreeCuttingService"); return svc and svc.CutCancelled end,
    function()
        Timber.isCutting = false
        Timber.pendingCutTime = 0
    end)
Toggles.AutoCut:OnChanged(function(state) Thread("AutoCut", Func.AutoCut, state) end)
Toggles.AutoSell:OnChanged(function(state) Thread("AutoSell", Func.AutoSell, state) end)
Toggles.AutoCollect:OnChanged(function(state) Thread("AutoCollect", Func.AutoCollect, state) end)
Toggles.AutoUnlockSlot:OnChanged(function(state) Thread("AutoUnlockSlot", Func.AutoUnlockSlot, state) end)
Toggles.AutoUpgradeWorker:OnChanged(function(state) Thread("AutoUpgradeWorker", Func.AutoUpgradeWorker, state) end)
Toggles.AutoSpin:OnChanged(function(state) Thread("AutoSpin", Func.AutoSpin, state) end)
Toggles.AutoOpenEgg:OnChanged(function(state) Thread("AutoOpenEgg", Func.AutoOpenEgg, state) end)
Toggles.AutoEquip:OnChanged(function(state) Thread("AutoEquip", Func.AutoEquip, state) end)
Toggles.AutoUpgrade:OnChanged(function(state) Thread("AutoUpgrade", Func.AutoUpgrade, state) end)

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
SaveManager:SetFolder("Yuri/MTB")
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
