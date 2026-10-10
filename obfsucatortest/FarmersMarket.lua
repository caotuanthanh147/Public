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
local Support = {
    Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard = (typeof(setclipboard) == "function"),
    FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport = (typeof(queue_on_teleport) == "function" or typeof(queueonteleport) == "function"),
    Connections = (typeof(getconnections) == "function"),
    FPS = (typeof(setfpscap) == "function"),
    Proximity = (typeof(fireproximityprompt) == "function"),
    HookMeta = (typeof(hookmetamethod) == "function"),
    Firesignal = (typeof(firesignal) == "function"),
}
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
local function LoadModuleAsync(parent, name, onLoaded)
    if not Support.FileIO then return end
    task.spawn(function()
        local obj = parent:FindFirstChild(name)
        local waited = 0
        while not obj and waited < 30 do
            obj = parent:WaitForChild(name, 1)
            waited = waited + 1
            if obj then break end
        end
        if not obj or not obj:IsA("ModuleScript") then return end
        local success, result = pcall(require, obj)
        if success and type(result) == "table" then
            pcall(onLoaded, result)
        end
    end)
end
local function GetSafeRemote(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
        return obj
    end
    return nil
end
local function FireRemote(remote, ...)
    if not remote then return false end
    local args = {...}
    local ok, err = pcall(function()
        remote:FireServer(unpack(args))
    end)
    if not ok then notyuri("FireRemote error:", tostring(remote), tostring(err)) end
    return ok
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
    local function getSelection()
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
    local function refresh()
        local newValues = { "All" }
        for _, v in ipairs(baseValues) do
            table.insert(newValues, v)
        end
        if Options[id] then
            Options[id]:SetValues(newValues)
        end
    end
    return getSelection, refresh, baseValues
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
        local args = {...}
        for _, connection in ipairs(getconnections(signal)) do
            if connection.Fire then
                pcall(function() connection:Fire(unpack(args)) end)
            elseif connection.Function then
                task.spawn(connection.Function, unpack(args))
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
            currentTable[flagKey] = task.spawn(featureFunc, ...)
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
        Default = Config.DefaultToggle or false,
        Disabled = Config.Disabled,
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
local function GetNearest(list, filterFn)
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, inst in ipairs(list) do
        if not filterFn or filterFn(inst) then
            local part = inst:IsA("BasePart") and inst or (inst:IsA("Model") and inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart"))
            if part then
                local dist = (part.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = inst
                end
            end
        end
    end
    return best, bestDist
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
        firetouchinterest(part, root, true)
        task.wait()
        firetouchinterest(part, root, false)
    end)
end
local function Serverhop()
    local hopSuccess, hopErr = pcall(function()
        local baseUrl = 'https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'
        local servers = {}
        local cursor = ''
        for _ = 1, 3 do
            local url = baseUrl
            if cursor ~= '' then url = url .. '&cursor=' .. cursor end
            local pages = game:HttpGet(url)
            local data = HttpService:JSONDecode(pages)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server)
                end
            end
            cursor = data.nextPageCursor
            if not cursor or cursor == '' then break end
        end
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        if #servers == 0 then
            Library:Notify("No servers found to hop to.", 3)
            return
        end
        local best = servers[1]
        for _, server in ipairs(servers) do
            if server.playing > 0 then
                best = server
                break
            end
        end
        TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, Plr)
    end)
    if not hopSuccess then
        Library:Notify("Serverhop failed: " .. tostring(hopErr), 5)
    end
end
local function QueueOnTeleportExec(code)
    if typeof(queue_on_teleport) == "function" then
        queue_on_teleport(code)
    elseif typeof(queueonteleport) == "function" then
        queueonteleport(code)
    end
end
local Comm = RS:WaitForChild("Communication", 15)
if not Comm then
    notyuri("ERROR: ReplicatedStorage.Communication never appeared")
end
local FM_REMOTE_NAMES = {
    "PlaceCrop", "HarvestCrop", "PlotShopBuy", "SellSpotStock", "UpgradeBuy",
    "BarnUpgrade", "ExpandContribute", "BuildContribute", "ComponentContribute",
    "TruckDeposit", "PenDeposit", "PenCollect", "BuildingCollect",
    "GroupReward", "Drop", "SeekerSlap",
}
task.spawn(function()
    if not Comm then return end
    for _, remoteName in ipairs(FM_REMOTE_NAMES) do
        if Library.Unloaded then return end
        local remote = Comm:WaitForChild(remoteName, 10)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            Remotes[remoteName] = remote
        else
            notyuri("Remote missing:", remoteName)
        end
    end
end)
local DataCache = {}
local DataMiss = {}
local RemoteGet = nil
local function DataGet(key)
    if DataCache[key] ~= nil then
        return DataCache[key]
    end
    if DataMiss[key] and (os.clock() - DataMiss[key]) < 10 then
        return nil
    end
    if not RemoteGet then
        return nil
    end
    local result = SafeInvoke(RemoteGet, key)
    if result ~= nil then
        DataCache[key] = result
        DataMiss[key] = nil
    else
        DataMiss[key] = os.clock()
    end
    return result
end
task.spawn(function()
    if not Comm then return end
    local dsFolder = Comm:WaitForChild("DataStore", 10)
    if not dsFolder then
        notyuri("DataStore remote folder missing")
        return
    end
    local getRemote = dsFolder:WaitForChild("Get", 10)
    if getRemote and getRemote:IsA("RemoteFunction") then
        RemoteGet = getRemote
    else
        notyuri("DataStore.Get remote missing")
    end
    local updateRemote = dsFolder:WaitForChild("Update", 10)
    if updateRemote and updateRemote:IsA("RemoteEvent") then
        Connections.DataStoreUpdate = updateRemote.OnClientEvent:Connect(function(key)
            if type(key) == "string" then
                DataCache[key] = nil
                DataMiss[key] = nil
            end
        end)
    end
    task.spawn(function()
        for _, warmKey in ipairs({ "Cash", "Inventory", "BarnLevel", "Upgrades", "PreSpawnedBuilt", "PlacedObjects", "PlacedCrops" }) do
            if Library.Unloaded then return end
            DataGet(warmKey)
        end
    end)
end)
local SharedRoot = RS:FindFirstChild("Shared")
local GSFolder = SharedRoot and SharedRoot:FindFirstChild("GS")
if GSFolder then
    Modules.CropConfig = GetSafeModule(GSFolder, "CropConfig")
    if not Modules.CropConfig then
        LoadModuleAsync(GSFolder, "CropConfig", function(module)
            if type(module) == "table" then Modules.CropConfig = module end
        end)
    end
else
    notyuri("ERROR: ReplicatedStorage.Shared.GS never appeared")
end
if SharedRoot then
    Modules.ItemData = GetSafeModule(SharedRoot, "ItemData")
    if not Modules.ItemData then
        LoadModuleAsync(SharedRoot, "ItemData", function(module)
            if type(module) == "table" then Modules.ItemData = module end
        end)
    end
    Modules.Format = GetSafeModule(SharedRoot, "Format")
    if not Modules.Format then
        LoadModuleAsync(SharedRoot, "Format", function(module)
            if type(module) == "table" then Modules.Format = module end
        end)
    end
else
    notyuri("ERROR: ReplicatedStorage.Shared never appeared")
end
Shared.HarvestMemo = {}
Shared.ExpandFinal = {}
Shared.RepairFinal = {}
Shared.ComponentFinal = {}
local function FormatNum(n)
    n = tonumber(n) or 0
    if Modules.Format and type(Modules.Format.ConvertNumber) == "function" then
        local ok, res = pcall(Modules.Format.ConvertNumber, n)
        if ok and type(res) == "string" then
            return res
        end
    end
    return Abbreviate(n)
end
local function GetPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    return plots:FindFirstChild(Plr.Name)
end
local function GetGeneric()
    local inventory = DataGet("Inventory")
    if type(inventory) == "table" and type(inventory.Generic) == "table" then
        return inventory.Generic
    end
    return {}
end
local function GetMetas()
    local inventory = DataGet("Inventory")
    if type(inventory) == "table" and type(inventory.Metas) == "table" then
        return inventory.Metas
    end
    return nil
end
local function SeedRank(seedName)
    local cfg = Modules.CropConfig
    if not cfg then return nil end
    local def = cfg.Crops and cfg.Crops[seedName]
    if not def then return nil end
    local produce = cfg.Produce and cfg.Produce[def.Produce]
    if produce and tonumber(produce.SellPrice) then
        return tonumber(produce.SellPrice)
    end
    return tonumber(def.SellPrice) or 0
end
local function PickBestMeta(rankFn)
    local metas = GetMetas()
    if not metas then return nil, nil end
    local bestHash, bestName, bestRank = nil, nil, nil
    for metaHash, meta in pairs(metas) do
        if type(meta) == "table" and type(meta[1]) == "string" then
            local rank = rankFn(meta[1])
            if rank ~= nil and (bestRank == nil or rank > bestRank) then
                bestHash, bestName, bestRank = tostring(metaHash), meta[1], rank
            end
        end
    end
    return bestHash, bestName
end
local function OwnedCountOf(itemName)
    local count = 0
    local placed = DataGet("PlacedObjects")
    if type(placed) == "table" then
        for _, entry in pairs(placed) do
            if type(entry) == "table" and entry.Item == itemName then
                count = count + 1
            end
        end
    end
    local metas = GetMetas()
    if metas then
        for _, meta in pairs(metas) do
            if type(meta) == "table" and meta[1] == itemName then
                count = count + 1
            end
        end
    end
    return count
end
local function BuildOccupancy(plot)
    local occ = {}
    local function markArea(section, x, z, w, d)
        for dx = 0, w - 1 do
            for dz = 0, d - 1 do
                occ[section .. ":" .. (x + dx) .. ":" .. (z + dz)] = true
            end
        end
    end
    local crops = plot:FindFirstChild("Crops")
    if crops then
        for _, crop in ipairs(crops:GetChildren()) do
            local x = tonumber(crop:GetAttribute("CellX"))
            local z = tonumber(crop:GetAttribute("CellZ"))
            if x and z then
                markArea(crop:GetAttribute("Section") or "S1", x, z, 1, 1)
            end
        end
    end
    for _, folderName in ipairs({ "Objects", "PreSpawned" }) do
        local folder = plot:FindFirstChild(folderName)
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                local section = obj:GetAttribute("Section")
                local x = tonumber(obj:GetAttribute("CellX"))
                local z = tonumber(obj:GetAttribute("CellZ"))
                if section and x and z then
                    markArea(section, x, z, tonumber(obj:GetAttribute("W")) or 1, tonumber(obj:GetAttribute("D")) or 1)
                end
            end
        end
    end
    return occ
end
local function FindFreeCell(plot, occ, w, d)
    local cfg = Modules.CropConfig
    if not cfg then return nil end
    local grid = tonumber(cfg.GridCells) or 5
    local land = plot:FindFirstChild("Land")
    if not land then return nil end
    for _, section in ipairs(land:GetChildren()) do
        if section:GetAttribute("Owned") then
            local sectionName = section.Name
            for x = 1, grid - w + 1 do
                for z = 1, grid - d + 1 do
                    local free = true
                    for dx = 0, w - 1 do
                        for dz = 0, d - 1 do
                            if occ[sectionName .. ":" .. (x + dx) .. ":" .. (z + dz)] then
                                free = false
                                break
                            end
                        end
                        if not free then break end
                    end
                    if free then
                        return sectionName, x, z
                    end
                end
            end
        end
    end
    return nil
end
local function EquipCoreTool(toolName)
    local character = Plr.Character
    if not character then return false end
    local current = character:FindFirstChildOfClass("Tool")
    if current and current:GetAttribute("CoreTool") == toolName then
        return true
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local sources = { Plr:FindFirstChild("Backpack"), character }
    for _, source in ipairs(sources) do
        if source then
            for _, tool in ipairs(source:GetChildren()) do
                if tool:IsA("Tool") and tool:GetAttribute("CoreTool") == toolName then
                    if humanoid then
                        local ok = pcall(function() humanoid:EquipTool(tool) end)
                        if ok then return true end
                    end
                    pcall(function() tool.Parent = character end)
                    return true
                end
            end
        end
    end
    return false
end
local function FootprintOf(itemName)
    local cfg = Modules.CropConfig
    if not cfg or type(cfg.FootprintFor) ~= "function" then
        return 1, 1
    end
    local ok, w, d = pcall(cfg.FootprintFor, itemName)
    if ok and tonumber(w) and tonumber(d) then
        return math.max(1, math.floor(tonumber(w))), math.max(1, math.floor(tonumber(d)))
    end
    return 1, 1
end
local function ContributeBatchOf(cost)
    local cfg = Modules.CropConfig
    if cfg and type(cfg.ContributeBatch) == "function" then
        local ok, res = pcall(cfg.ContributeBatch, cost)
        if ok and tonumber(res) then
            return tonumber(res)
        end
    end
    return 1
end
local function CheckAfford(costValue, given, stock, batch)
    local cost = tonumber(costValue) or 0
    local have = tonumber(given) or 0
    local left = cost - have
    stock = tonumber(stock) or 0
    batch = tonumber(batch) or 1
    if left ~= left then
        if stock <= 0 then
            return false, left, 0
        end
        return true, left, math.max(1, math.min(batch, stock))
    end
    if left <= 0 or stock <= 0 then
        return false, left, 0
    end
    return true, left, math.min(batch, left, stock)
end
local function FireContribute(kind, target, item, amount)
    if kind == "Expand" then
        return FireRemote(Remotes.ExpandContribute, target, item, amount)
    elseif kind == "Repair" then
        return FireRemote(Remotes.BuildContribute, target, item, amount)
    elseif kind == "Component" then
        return FireRemote(Remotes.ComponentContribute, target, item, amount)
    end
    return false
end
local function ContributeNext(padPart, kind, target, costs, contributed, finalizeMemo, memoKey)
    if type(costs) ~= "table" then return false end
    local generic = GetGeneric()
    local cash = tonumber(DataGet("Cash")) or 0
    local anyFired = false
    local anyLeft = false
    for costKey, costValue in pairs(costs) do
        local given = (type(contributed) == "table" and contributed[costKey]) or 0
        local stock = costKey == "Cash" and cash or (tonumber(generic[costKey]) or 0)
        local want = tonumber(costValue) or 0
        local left = want - (tonumber(given) or 0)
        if left ~= left or stock ~= stock then
            if want > 0 then
                FireContribute(kind, target, costKey, want)
                anyFired = true
            else
                FireContribute(kind, target, costKey, 10)
                anyFired = true
            end
        elseif left > 0 then
            anyLeft = true
            if stock > 0 then
                FireContribute(kind, target, costKey, math.min(stock, left))
                anyFired = true
            end
        end
    end
    if anyFired then
        return true
    end
    if not anyLeft then
        local now = os.clock()
        if finalizeMemo[memoKey] and (now - finalizeMemo[memoKey]) < 5 then
            return false
        end
        local firstKey = next(costs) or "Cash"
        finalizeMemo[memoKey] = now
        return FireContribute(kind, target, firstKey, 0)
    end
    return false
end
local function ExpandCosts(section)
    local cfg = Modules.CropConfig
    local land = cfg and cfg.Land and cfg.Land[section]
    if not land then return nil end
    local mult = 1
    if section ~= "S3" and section ~= "S5" then
        mult = tonumber(Plr:GetAttribute("ABX_ExpansionCostMult")) or 1
    end
    local costs = {}
    if land.Cash and land.Cash > 0 then
        costs.Cash = math.max(1, math.floor(land.Cash * mult + 0.5))
    end
    for item, amt in pairs(land.Items or {}) do
        costs[item] = math.max(1, math.floor((tonumber(amt) or 1) * mult + 0.5))
    end
    return costs
end
local function RepairCosts(building)
    local cfg = Modules.CropConfig
    local def = cfg and cfg.Buildings and cfg.Buildings[building]
    if not def or type(def.Repair) ~= "table" then return nil end
    local costs = {}
    if def.Repair.Cash and def.Repair.Cash > 0 then
        costs.Cash = def.Repair.Cash
    end
    for item, amt in pairs(def.Repair.Items or {}) do
        costs[item] = amt
    end
    return costs
end
local function ComponentCosts(component)
    local cfg = Modules.CropConfig
    local def = cfg and cfg.Components and cfg.Components[component]
    if not def then return nil end
    local costs = {}
    if def.Cash and def.Cash > 0 then
        costs.Cash = def.Cash
    end
    for item, amt in pairs(def.Items or {}) do
        costs[item] = amt
    end
    return costs
end
local function Func_AutoPlant()
    while Toggles.AutoPlant.Value do
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg or not cfg.Crops then return end
            local metaHash = PickBestMeta(function(name)
                if cfg.Crops[name] then
                    return SeedRank(name)
                end
                return nil
            end)
            if not metaHash then return end
            local plot = GetPlot()
            if not plot then return end
            local occ = BuildOccupancy(plot)
            local section, x, z = FindFreeCell(plot, occ, 1, 1)
            if section then
                EquipCoreTool("Build")
                FireRemote(Remotes.PlaceCrop, metaHash, section, x, z, 0)
            end
        end)
        if not ok then
            notyuri("AutoPlant error:", tostring(loopErr))
        end
        task.wait(0.25)
    end
end
local function Func_AutoPlaceBuildables()
    while Toggles.AutoPlaceBuildables.Value do
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg or type(cfg.BuildableDef) ~= "function" then
                notyuri("AutoPlaceBuildables: CropConfig or BuildableDef missing")
                return
            end
            local metaHash, metaName = PickBestMeta(function(name)
                local okDef, def = pcall(cfg.BuildableDef, name)
                if okDef and type(def) == "table" then
                    return tonumber(def.Cost) or 0
                end
                return nil
            end)
            if not metaHash or not metaName then
                notyuri("AutoPlaceBuildables: no owned buildable meta found")
                return
            end
            local plot = GetPlot()
            if not plot then
                notyuri("AutoPlaceBuildables: no plot found")
                return
            end
            local w, d = FootprintOf(metaName)
            local occ = BuildOccupancy(plot)
            local section, x, z = FindFreeCell(plot, occ, w, d)
            if section then
                EquipCoreTool("Build")
                FireRemote(Remotes.PlaceCrop, metaHash, section, x, z, 0)
            else
                notyuri("AutoPlaceBuildables: no free cell found for", metaName, w, d)
            end
        end)
        if not ok then
            notyuri("AutoPlaceBuildables error:", tostring(loopErr))
        end
        task.wait(0.4)
    end
end
local function Func_AutoHarvest()
    while Toggles.AutoHarvest.Value do
        local fired = 0
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg or not cfg.Crops then return end
            local plot = GetPlot()
            if not plot then return end
            local crops = plot:FindFirstChild("Crops")
            if not crops then return end
            local now = os.clock()
            for memoKey, stamp in pairs(Shared.HarvestMemo) do
                if (now - stamp) > 3 then
                    Shared.HarvestMemo[memoKey] = nil
                end
            end
            for _, crop in ipairs(crops:GetChildren()) do
                local cropName = crop:GetAttribute("Crop")
                local stage = tonumber(crop:GetAttribute("Stage")) or 0
                if cropName and cfg.Crops[cropName] then
                    local stageCount = 1
                    if type(cfg.GetStageCount) == "function" then
                        local okCount, count = pcall(cfg.GetStageCount, cropName)
                        if okCount and tonumber(count) then
                            stageCount = tonumber(count)
                        end
                    end
                    if stage >= stageCount and not Shared.HarvestMemo[crop.Name] then
                        Shared.HarvestMemo[crop.Name] = os.clock()
                        FireRemote(Remotes.HarvestCrop, crop.Name)
                        fired = fired + 1
                        if fired >= 3 then
                            return
                        end
                        task.wait(0.08)
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoHarvest error:", tostring(loopErr))
        end
        task.wait(fired > 0 and 0.25 or 0.5)
    end
end
local function Func_AutoBuySeeds()
    while Toggles.AutoBuySeeds.Value do
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg or not cfg.Crops then return end
            local cash = tonumber(DataGet("Cash")) or 0
            local bestName, bestRank = nil, nil
            for name, def in pairs(cfg.Crops) do
                local cost = tonumber(def.Cost) or math.huge
                if cost <= cash then
                    local rank = SeedRank(name) or 0
                    if bestRank == nil or rank > bestRank then
                        bestName, bestRank = name, rank
                    end
                end
            end
            if not bestName then return end
            local owned = 0
            local metas = GetMetas()
            if metas then
                for _, meta in pairs(metas) do
                    if type(meta) == "table" and meta[1] == bestName then
                        owned = owned + 1
                    end
                end
            end
            local keep = tonumber(Options.SeedStock and Options.SeedStock.Value) or 10
            if owned < keep then
                FireRemote(Remotes.PlotShopBuy, bestName)
            end
        end)
        if not ok then
            notyuri("AutoBuySeeds error:", tostring(loopErr))
        end
        task.wait(0.5)
    end
end
local function Func_AutoBuyBuildables()
    while Toggles.AutoBuyBuildables.Value do
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg then return end
            local cash = tonumber(DataGet("Cash")) or 0
            local barnLevel = tonumber(DataGet("BarnLevel")) or 1
            local built = DataGet("PreSpawnedBuilt")
            if type(built) ~= "table" then built = {} end
            local list = {}
            local groups = {}
            if type(cfg.Animals) == "table" then table.insert(groups, cfg.Animals) end
            if type(cfg.Machines) == "table" then table.insert(groups, cfg.Machines) end
            for _, group in ipairs(groups) do
                for name, def in pairs(group) do
                    table.insert(list, { Name = name, Def = def })
                end
            end
            table.sort(list, function(a, b)
                return (tonumber(a.Def and a.Def.Cost) or 0) > (tonumber(b.Def and b.Def.Cost) or 0)
            end)
            for _, entry in ipairs(list) do
                local name, def = entry.Name, entry.Def
                local locked = cfg.Buildings and cfg.Buildings[name] and built[name] ~= true
                if not locked then
                    local owned = OwnedCountOf(name)
                    local cap = 1
                    if type(cfg.CopyCap) == "function" then
                        local okCap, resCap = pcall(cfg.CopyCap, name, barnLevel)
                        if okCap and tonumber(resCap) then
                            cap = tonumber(resCap)
                        end
                    end
                    if owned < cap then
                        local cost = tonumber(def.Cost) or math.huge
                        if type(cfg.CopyCost) == "function" then
                            local okCost, resCost = pcall(cfg.CopyCost, def, owned)
                            if okCost and tonumber(resCost) then
                                cost = tonumber(resCost)
                            end
                        end
                        if cash >= cost then
                            FireRemote(Remotes.PlotShopBuy, name)
                            return
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoBuyBuildables error:", tostring(loopErr))
        end
        task.wait(0.6)
    end
end
local function Func_AutoStockSpots()
    while Toggles.AutoStockSpots.Value do
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg or not cfg.Produce then return end
            local plot = GetPlot()
            if not plot then return end
            local storefront = plot:FindFirstChild("StoreFront")
            local spots = storefront and storefront:FindFirstChild("SellSpots")
            if not spots then return end
            local generic = GetGeneric()
            local bestItem, bestCount, bestPrice = nil, 0, nil
            for item, count in pairs(generic) do
                local numCount = tonumber(count)
                if numCount and (numCount > 0 or numCount ~= numCount) then
                    local produce = cfg.Produce[item]
                    local price = produce and tonumber(produce.SellPrice)
                    if price and (bestPrice == nil or price > bestPrice) then
                        bestItem, bestPrice = item, price
                        bestCount = (numCount == numCount) and numCount or 1e10
                    end
                end
            end
            if not bestItem then return end
            for _, spot in ipairs(spots:GetChildren()) do
                local attachment = spot:FindFirstChild("Attachment")
                local prompt = attachment and attachment:FindFirstChild("SellPrompt")
                if prompt and prompt:IsA("ProximityPrompt") and prompt.ActionText == "Stock" then
                    FireRemote(Remotes.SellSpotStock, spot.Name, bestItem, bestCount)
                    return
                end
            end
        end)
        if not ok then
            notyuri("AutoStockSpots error:", tostring(loopErr))
        end
        task.wait(0.4)
    end
end
local function Func_InfMoney(itemName)
    if not itemName then return end
    local plot = GetPlot()
    if not plot then return end
    local storefront = plot:FindFirstChild("StoreFront")
    local spots = storefront and storefront:FindFirstChild("SellSpots")
    if not spots then return end
    local targetSpot = nil
    for _, spot in ipairs(spots:GetChildren()) do
        local attachment = spot:FindFirstChild("Attachment")
        local prompt = attachment and attachment:FindFirstChild("SellPrompt")
        if prompt and prompt:IsA("ProximityPrompt") and prompt.ActionText == "Stock" then
            targetSpot = spot
            break
        end
    end
    if not targetSpot then return end
    FireRemote(Remotes.SellSpotStock, targetSpot.Name, itemName, 0/0)
    task.wait(0.15)
    local attachment = targetSpot:FindFirstChild("Attachment")
    local prompt = attachment and attachment:FindFirstChild("SellPrompt")
    if prompt and prompt:IsA("ProximityPrompt") then
        FirePP(prompt, true)
    end
end
local function Func_AutoFeedPens()
    while Toggles.AutoFeedPens.Value do
        local ok, loopErr = pcall(function()
            local itemData = Modules.ItemData
            if not itemData or not itemData.Items then return end
            local plot = GetPlot()
            if not plot then return end
            local objects = plot:FindFirstChild("Objects")
            if not objects then return end
            local generic = GetGeneric()
            for _, holder in ipairs(objects:GetChildren()) do
                local itemName = holder:GetAttribute("Item")
                local def = itemName and itemData.Items[itemName]
                local pen = def and def.Pen
                local deposit = holder:FindFirstChild("Deposit")
                if pen and deposit and type(pen.Inputs) == "table" then
                    for i, input in ipairs(pen.Inputs) do
                        local filled = tonumber(holder:GetAttribute("Input" .. i))
                        local maxAmount = tonumber(input.Max) or 0
                        local stock = tonumber(generic[input.Item]) or 0
                        local left = maxAmount - (filled or 0)
                        notyuri("AutoFeedPens debug:", holder.Name, input.Item, "filled=", filled, "maxAmount=", maxAmount, "stock=", stock, "left=", left)
                        if left ~= left or stock ~= stock then
                            if maxAmount > 0 then
                                FireRemote(Remotes.PenDeposit, holder.Name, input.Item, maxAmount)
                            else
                                FireRemote(Remotes.PenDeposit, holder.Name, input.Item, 10)
                            end
                        elseif left > 0 and stock > 0 then
                            FireRemote(Remotes.PenDeposit, holder.Name, input.Item, math.min(stock, left))
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoFeedPens error:", tostring(loopErr))
        end
        task.wait(0.4)
    end
end
local function Func_AutoCollectOutput()
    while Toggles.AutoCollectOutput.Value do
        local ok, loopErr = pcall(function()
            local itemData = Modules.ItemData
            local cfg = Modules.CropConfig
            if not itemData or not itemData.Items or not cfg then return end
            local plot = GetPlot()
            if not plot then return end
            local objects = plot:FindFirstChild("Objects")
            if not objects then return end
            for _, holder in ipairs(objects:GetChildren()) do
                local output = tonumber(holder:GetAttribute("Output")) or 0
                if output > 0 then
                    local itemName = holder:GetAttribute("Item")
                    local def = itemName and itemData.Items[itemName]
                    local collect = holder:FindFirstChild("Collect")
                    if def and collect then
                        local maxOut, kind = nil, nil
                        if def.Pen then
                            maxOut = tonumber(def.Pen.OutputMax) or 0
                            kind = "Pen"
                        elseif def.Building then
                            maxOut = tonumber(def.Building.StorageMax) or 0
                            kind = "Building"
                        end
                        if maxOut and maxOut > 0 then
                            local batch = ContributeBatchOf(maxOut)
                            local amount = math.max(batch, output)
                            if kind == "Pen" then
                                FireRemote(Remotes.PenCollect, holder.Name, amount)
                            else
                                FireRemote(Remotes.BuildingCollect, holder.Name, amount)
                            end
                            return
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoCollectOutput error:", tostring(loopErr))
        end
        task.wait(0.5)
    end
end
local function Func_AutoTruck()
    while Toggles.AutoTruck.Value do
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg then return end
            local plot = GetPlot()
            if not plot then return end
            local components = plot:FindFirstChild("PlotComponents")
            local bay = components and components:FindFirstChild("TruckBay")
            if not bay then return end
            local deposit = bay:FindFirstChild("Deposit")
            local orderJSON = bay:GetAttribute("OrderJSON")
            if not deposit or type(orderJSON) ~= "string" then return end
            local okDecode, order = pcall(HttpService.JSONDecode, HttpService, orderJSON)
            if not okDecode or type(order) ~= "table" or type(order.Items) ~= "table" then return end
            local generic = GetGeneric()
            local cash = tonumber(DataGet("Cash")) or 0
            for item, info in pairs(order.Items) do
                if type(info) == "table" then
                    local stock = item == "Cash" and cash or (tonumber(generic[item]) or 0)
                    local need = tonumber(info.Need) or 0
                    local have = tonumber(info.Have) or 0
                    local left = need - have
                    if left ~= left or stock ~= stock then
                        if need > 0 then
                            FireRemote(Remotes.TruckDeposit, item, need)
                        else
                            FireRemote(Remotes.TruckDeposit, item, 10)
                        end
                    elseif left > 0 and stock > 0 then
                        FireRemote(Remotes.TruckDeposit, item, math.min(stock, left))
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoTruck error:", tostring(loopErr))
        end
        task.wait(0.5)
    end
end
local function Func_AutoExpand()
    while Toggles.AutoExpand.Value do
        local ok, loopErr = pcall(function()
            local plot = GetPlot()
            if not plot then return end
            local expand = plot:FindFirstChild("Expand")
            if not expand then return end
            local contributions = DataGet("ExpandContributions")
            for _, pad in ipairs(expand:GetChildren()) do
                if pad:IsA("BasePart") then
                    local section = pad.Name
                    local costs = ExpandCosts(section)
                    if costs then
                        local mine = (type(contributions) == "table" and contributions[section]) or {}
                        if ContributeNext(pad, "Expand", section, costs, mine, Shared.ExpandFinal, section) then
                            return
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoExpand error:", tostring(loopErr))
        end
        task.wait(0.5)
    end
end
local function Func_AutoRepair()
    while Toggles.AutoRepair.Value do
        local ok, loopErr = pcall(function()
            local plot = GetPlot()
            if not plot then return end
            local prespawned = plot:FindFirstChild("PreSpawned")
            if not prespawned then return end
            local built = DataGet("PreSpawnedBuilt")
            local contributions = DataGet("BuildContributions")
            for _, holder in ipairs(prespawned:GetChildren()) do
                local repairPad = holder:FindFirstChild("Repair")
                if repairPad and repairPad:IsA("BasePart") then
                    local building = holder.Name
                    if type(built) ~= "table" or built[building] ~= true then
                        local costs = RepairCosts(building)
                        if costs then
                            local mine = (type(contributions) == "table" and contributions[building]) or {}
                            if ContributeNext(repairPad, "Repair", building, costs, mine, Shared.RepairFinal, building) then
                                return
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoRepair error:", tostring(loopErr))
        end
        task.wait(0.5)
    end
end
local function Func_AutoComponents()
    while Toggles.AutoComponents.Value do
        local ok, loopErr = pcall(function()
            local plot = GetPlot()
            if not plot then return end
            local components = plot:FindFirstChild("PlotComponents")
            if not components then return end
            local contributions = DataGet("ComponentContributions")
            for _, part in ipairs(components:GetChildren()) do
                if part:IsA("BasePart") then
                    local component = string.match(part.Name, "^(.+)_Pad$")
                    if component then
                        local costs = ComponentCosts(component)
                        if costs then
                            local mine = (type(contributions) == "table" and contributions[component]) or {}
                            if ContributeNext(part, "Component", component, costs, mine, Shared.ComponentFinal, component) then
                                return
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoComponents error:", tostring(loopErr))
        end
        task.wait(0.5)
    end
end
local function Func_AutoUpgrades()
    while Toggles.AutoUpgrades.Value do
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg or not cfg.Upgrades then return end
            local upgrades = DataGet("Upgrades") or {}
            local cash = tonumber(DataGet("Cash")) or 0
            local list = {}
            for name, def in pairs(cfg.Upgrades) do
                table.insert(list, { Name = name, Def = def })
            end
            table.sort(list, function(a, b)
                return (tonumber(a.Def.Order) or 0) < (tonumber(b.Def.Order) or 0)
            end)
            for _, entry in ipairs(list) do
                local level = 0
                if type(cfg.UpgradeLevel) == "function" then
                    local okLevel, resLevel = pcall(cfg.UpgradeLevel, upgrades, entry.Name)
                    if okLevel and tonumber(resLevel) then
                        level = tonumber(resLevel)
                    end
                end
                local maxLevel = tonumber(entry.Def.MaxLevel) or 0
                if level < maxLevel then
                    local cost = math.huge
                    if type(cfg.UpgradeCost) == "function" then
                        local okCost, resCost = pcall(cfg.UpgradeCost, entry.Name, level)
                        if okCost and tonumber(resCost) then
                            cost = tonumber(resCost)
                        end
                    end
                    if cash >= cost then
                        FireRemote(Remotes.UpgradeBuy, entry.Name)
                        return
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoUpgrades error:", tostring(loopErr))
        end
        task.wait(0.5)
    end
end
local function Func_AutoBarn()
    while Toggles.AutoBarn.Value do
        local ok, loopErr = pcall(function()
            local cfg = Modules.CropConfig
            if not cfg or not cfg.BarnLevels then return end
            local level = tonumber(DataGet("BarnLevel")) or 1
            local nextCost = cfg.BarnLevels[level + 1]
            if not nextCost then return end
            local cash = tonumber(DataGet("Cash")) or 0
            local generic = GetGeneric()
            local can = (tonumber(nextCost.Cash) or 0) <= cash
            if can then
                for item, amt in pairs(nextCost.Items or {}) do
                    local numStock = tonumber(generic[item])
                    if numStock and numStock == numStock and numStock < (tonumber(amt) or 0) then
                        can = false
                        break
                    end
                end
            end
            if can then
                FireRemote(Remotes.BarnUpgrade)
            end
        end)
        if not ok then
            notyuri("AutoBarn error:", tostring(loopErr))
        end
        task.wait(1)
    end
end
local function Func_AutoGroupReward()
    while Toggles.AutoGroupReward.Value do
        local ok, loopErr = pcall(function()
            if DataGet("ClaimedGroupReward") ~= true then
                FireRemote(Remotes.GroupReward)
            end
        end)
        if not ok then
            notyuri("AutoGroupReward error:", tostring(loopErr))
        end
        task.wait(10)
    end
end
local function Func_AutoDrops()
    while Toggles.AutoDrops.Value do
        local ok, loopErr = pcall(function()
            local drops = workspace:FindFirstChild("Drops")
            if not drops then return end
            local fired = 0
            for _, part in ipairs(drops:GetChildren()) do
                if part:IsA("BasePart") then
                    local hash = tonumber(part.Name)
                    if hash then
                        FireRemote(Remotes.Drop, hash)
                        fired = fired + 1
                        if fired >= 25 then
                            break
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoDrops error:", tostring(loopErr))
        end
        task.wait(0.5)
    end
end
local function Func_AutoSlap()
    while Toggles.AutoSlap.Value do
        local ok, loopErr = pcall(function()
            if Plr:GetAttribute("Role") == "Seeker" then
                local humanoid = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    FireRemote(Remotes.SeekerSlap)
                end
            end
        end)
        if not ok then
            notyuri("AutoSlap error:", tostring(loopErr))
        end
        task.wait(1.05)
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
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function() Serverhop() end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlant", { Text = "Auto Plant Seeds", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoHarvest", { Text = "Auto Harvest Crops", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuySeeds", { Text = "Auto Buy Best Seeds", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyBuildables", { Text = "Auto Buy Buildables", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlaceBuildables", { Text = "Auto Place Buildables", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoStockSpots", { Text = "Auto Stock Sell Spots", Default = false })
do
    local produceCfg = Modules.CropConfig
    local itemValues = {}
    if produceCfg and produceCfg.Produce then
        for itemName in pairs(produceCfg.Produce) do
            table.insert(itemValues, itemName)
        end
        table.sort(itemValues)
    end
    TB_Tabs.Autofarm2.T1:AddDropdown("SelectItem", {
        Values = itemValues,
        Default = "Wheat",
        Text = "Select Item",
    })
    
    TB_Tabs.Autofarm2.T1:AddButton({
        Text = "Inf Item",
        Func = function()
            local selected = Options.SelectItem and Options.SelectItem.Value
            Func_InfMoney(selected)
        end,
    })
    TB_Tabs.Autofarm2.T1:AddLabel("<font color='#FF0000'>Irreversible</font>", true)
end
TB_Tabs.Autofarm.T1:AddToggle("AutoFeedPens", { Text = "Auto Feed Pens", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectOutput", { Text = "Auto Collect", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTruck", { Text = "Auto Fill Truck Orders", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrades", { Text = "Auto Buy Upgrades", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBarn", { Text = "Auto Upgrade Barn", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoExpand", { Text = "Auto Expand Land", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRepair", { Text = "Auto Repair Buildings", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoComponents", { Text = "Auto Build Components", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDrops", { Text = "Auto Collect Drops", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoGroupReward", { Text = "Auto Claim Group Reward", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSlap", { Text = "Auto Slap", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("SeedStock", { Text = "Seed Stock Target", Default = "10" })
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
        
    end
end)
Options.LimitFPSValue:OnChanged(function()
    if FPS_T.Value then
        setfpscap(FPS_S.Value)
    end
end)
Toggles.LimitFPS:OnChanged(function(v)
    FPS_S:SetVisible(FPS_T.Value)
    if not v and Support.FPS then
        setfpscap(2000)
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
local antiAFKConn = nil
local function RunAntiAFK()
    if antiAFKConn then antiAFKConn:Enable() return end
    local GC = getconnections or get_signal_cons
    if GC then
        local conns = GC(Players.LocalPlayer.Idled)
        local target = conns and conns[1]
        if target and target.Disable then
            target:Disable()
            antiAFKConn = target
            return
        end
        for _, c in pairs(conns or {}) do
            if c.Disable then
                c:Disable()
                antiAFKConn = c
                return
            elseif c.Disconnect then
                c:Disconnect()
                return
            end
        end
    end
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
Toggles.AntiAFK:OnChanged(function(state)
    if state then
        RunAntiAFK()
    elseif antiAFKConn and antiAFKConn.Enable then
        antiAFKConn:Enable()
    end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
Toggles.AutoPlant:OnChanged(function(state)
    Thread("FarmersMarket.AutoPlant", Func_AutoPlant, state)
end)
Toggles.AutoPlaceBuildables:OnChanged(function(state)
    Thread("FarmersMarket.AutoPlaceBuildables", Func_AutoPlaceBuildables, state)
end)
Toggles.AutoHarvest:OnChanged(function(state)
    Thread("FarmersMarket.AutoHarvest", Func_AutoHarvest, state)
end)
Toggles.AutoBuySeeds:OnChanged(function(state)
    Thread("FarmersMarket.AutoBuySeeds", Func_AutoBuySeeds, state)
end)
Toggles.AutoBuyBuildables:OnChanged(function(state)
    Thread("FarmersMarket.AutoBuyBuildables", Func_AutoBuyBuildables, state)
end)
Toggles.AutoStockSpots:OnChanged(function(state)
    Thread("FarmersMarket.AutoStockSpots", Func_AutoStockSpots, state)
end)
Toggles.AutoFeedPens:OnChanged(function(state)
    Thread("FarmersMarket.AutoFeedPens", Func_AutoFeedPens, state)
end)
Toggles.AutoCollectOutput:OnChanged(function(state)
    Thread("FarmersMarket.AutoCollectOutput", Func_AutoCollectOutput, state)
end)
Toggles.AutoTruck:OnChanged(function(state)
    Thread("FarmersMarket.AutoTruck", Func_AutoTruck, state)
end)
Toggles.AutoExpand:OnChanged(function(state)
    Thread("FarmersMarket.AutoExpand", Func_AutoExpand, state)
end)
Toggles.AutoRepair:OnChanged(function(state)
    Thread("FarmersMarket.AutoRepair", Func_AutoRepair, state)
end)
Toggles.AutoComponents:OnChanged(function(state)
    Thread("FarmersMarket.AutoComponents", Func_AutoComponents, state)
end)
Toggles.AutoUpgrades:OnChanged(function(state)
    Thread("FarmersMarket.AutoUpgrades", Func_AutoUpgrades, state)
end)
Toggles.AutoBarn:OnChanged(function(state)
    Thread("FarmersMarket.AutoBarn", Func_AutoBarn, state)
end)
Toggles.AutoGroupReward:OnChanged(function(state)
    Thread("FarmersMarket.AutoGroupReward", Func_AutoGroupReward, state)
end)
Toggles.AutoDrops:OnChanged(function(state)
    Thread("FarmersMarket.AutoDrops", Func_AutoDrops, state)
end)
Toggles.AutoSlap:OnChanged(function(state)
    Thread("FarmersMarket.AutoSlap", Func_AutoSlap, state)
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
    if antiAFKConn and antiAFKConn.Enable then pcall(function() antiAFKConn:Enable() end) end
    if Support.FPS then pcall(function() setfpscap(2000) end) end
    Cleanup(Connections)
    Cleanup(Flags)
        Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/FarmerMarkets")
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
