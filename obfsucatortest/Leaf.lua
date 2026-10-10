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
    QueueOnTeleport = (typeof(queueonteleport) == "function" or typeof(queue_on_teleport) == "function"),
    Connections = (typeof(getconnections) == "function"),
    FPS = (typeof(setfpscap) == "function"),
    Proximity = (typeof(fireproximityprompt) == "function"),
    HookMeta = (typeof(hookmetamethod) == "function" and typeof(getnamecallmethod) == "function"),
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
    local obj = parent and parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local RemotesFolder = GetObject(RS, "Remotes")
local TeamsFolder = GetObject(Services.Workspace, "Teams")
local function GetSafeRemote(name)
    if not RemotesFolder then
        notyuri("[Remotes] Remotes folder missing, cannot resolve: " .. name)
        return nil
    end
    local obj = GetObject(RemotesFolder, name)
    if not obj then
        notyuri("[Remotes] Failed to resolve remote: " .. name)
    end
    return obj
end
local Remotes = {
    EmptyBackpack = GetSafeRemote("EmptyBackpack"),
    BuyToolCash = GetSafeRemote("BuyToolCash"),
    BuyUpgrade = GetSafeRemote("BuyUpgrade"),
    BuyBagUpgrade = GetSafeRemote("BuyBagUpgrade"),
    BuyVent = GetSafeRemote("BuyVent"),
    ThrowMolotov = GetSafeRemote("ThrowMolotov"),
    ThrowSnowball = GetSafeRemote("ThrowSnowball"),
    DeployL33FBOT = GetSafeRemote("DeployL33FBOT"),
    CollectDuckBotPart = GetSafeRemote("CollectDuckBotPart"),
    BasketballPickup = GetSafeRemote("BasketballPickup"),
    BasketballRelease = GetSafeRemote("BasketballRelease"),
    BasketballGoal = GetSafeRemote("BasketballGoal"),
    TeamAction = GetSafeRemote("TeamAction"),
}
local CMFolder = GetObject(Plr.PlayerScripts, "ClientManager")
local Modules = {
    UpgradeConfig = GetSafeModule(RS, "UpgradeConfig"),
    BagConfig = GetSafeModule(RS, "BagConfig"),
    MapRegistry = GetSafeModule(RS, "MapRegistry"),
    MapList = GetSafeModule(RS, "MapList"),
    DifficultyConfig = GetSafeModule(RS, "DifficultyConfig"),
    MolotovConfig = GetSafeModule(RS, "MolotovConfig"),
    SnowballConfig = GetSafeModule(RS, "SnowballConfig"),
    L33FBOTConfig = GetSafeModule(RS, "L33FBOTConfig"),
    BotConfig = GetSafeModule(RS, "BotConfig"),
    Variables = GetSafeModule(CMFolder, "Variables"),
    LeafSim = GetSafeModule(Plr.PlayerScripts, "LeafSim"),
}
local Flags = {}
local Shared = {}
local Tables = {
    UpgradeList = {},
    UpgradeMap = {},
    BuyList = {},
    EquipList = {},
}
local function FireRemote(remote, ...)
    if not remote then
        notyuri("[FireRemote] Attempted to fire a nil remote")
        return
    end
    local args = {...}
    local ok, err = pcall(function()
        remote:FireServer(unpack(args))
    end)
    if not ok then
        notyuri("[FireRemote] FireServer failed for " .. remote.Name .. ": " .. tostring(err))
    end
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
        local args = {...}
        for _, connection in ipairs(getconnections(signal)) do
            if connection.Fire then
                pcall(function()
                    connection:Fire(unpack(args))
                end)
            elseif connection.Function then
                task.spawn(connection.Function, unpack(args))
            end
        end
    else
        notyuri("Your executor does not support firesignal or getconnections.")
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
            notyuri("Error in ["..name.."]: "..tostring(err))
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
    local ok, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local body
        if typeof(request) == "function" then
            local res = request({ Url = url, Method = "GET" })
            body = res and res.Body
        end
        if not body or body == "" then
            body = game:HttpGet(url)
        end
        return HttpService:JSONDecode(body)
    end)
    if not ok or not result or type(result.data) ~= "table" then
        Library:Notify("Serverhop failed: could not fetch server list", 5)
        return
    end
    local best, bestPlayers
    for _, server in ipairs(result.data) do
        if server.id and server.id ~= game.JobId and server.playing ~= nil then
            local maxPlayers = server.maxPlayers or 50
            if server.playing < maxPlayers and (not bestPlayers or server.playing < bestPlayers) then
                best = server
                bestPlayers = server.playing
            end
        end
    end
    if best then
        Library:Notify("Hopping to server with " .. tostring(bestPlayers) .. " players...", 3)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, Plr)
    else
        Library:Notify("Serverhop failed: no available server", 5)
    end
end
local function Func_AntiKick()
    if Connections.AntiKickHooked then return end
    if not Support.HookMeta then
        Library:Notify("Anti Kick is not supported on this executor", 5)
        Toggles.AntiKick:SetValue(false)
        return
    end
    local wrap = newcclosure or function(f) return f end
    local ok = pcall(function()
        local old
        old = hookmetamethod(game, "__namecall", wrap(function(self, ...)
            if Toggles.AntiKick and Toggles.AntiKick.Value and getnamecallmethod() == "Kick" and self == Plr then
                return nil
            end
            return old(self, ...)
        end))
    end)
    if ok then
        Connections.AntiKickHooked = true
    else
        Library:Notify("Anti Kick hook failed", 5)
        Toggles.AntiKick:SetValue(false)
    end
end
local function Func_AutoServerhop()
    while true do
        local mins = (Options.AutoHopMins and Options.AutoHopMins.Value) or 30
        task.wait(math.max(mins, 1) * 60)
        if Toggles.AutoServerhop.Value then
            Serverhop()
        end
    end
end
local Get = {}
local Send = {}
function Get.Root()
    local char = Plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
function Get.Leaves()
    local leaves = {}
    local sim = Modules.LeafSim
    local folder = sim and sim.folder
    if not folder then return leaves end
    for _, part in ipairs(folder:GetChildren()) do
        if part:IsA("BasePart") and part.CanQuery ~= false then
            leaves[#leaves + 1] = part
        end
    end
    return leaves
end
function Get.MapRoot()
    if Shared.MapRoot then return Shared.MapRoot end
    local reg = Modules.MapRegistry
    if reg then
        local ok, folder = pcall(function()
            return reg.folder()
        end)
        if ok and folder then
            Shared.MapRoot = folder
            return folder
        end
    end
    return nil
end
function Get.MapFolder(name)
    local cacheKey = "Folder_" .. name
    if Shared[cacheKey] then return Shared[cacheKey] end
    local reg = Modules.MapRegistry
    if reg then
        local ok, folder = pcall(function()
            return reg.get(name, 5)
        end)
        if ok and folder then
            Shared[cacheKey] = folder
            return folder
        end
    end
    return nil
end
function Get.Vents(unlocked)
    local result = {}
    local folder = Get.MapFolder("Vents")
    if not folder then return result end
    for _, part in ipairs(folder:GetChildren()) do
        if part:IsA("BasePart") and part:GetAttribute("Cost") ~= nil then
            if (part:GetAttribute("Unlocked") == true) == unlocked then
                result[#result + 1] = part
            end
        end
    end
    return result
end
function Get.NearestDumpster(root, allowedZones)
    local dumpsters = Get.MapFolder("Dumpsters")
    if not dumpsters or not root then return nil end
    local nearest, nearestDist = nil, nil
    for _, model in ipairs(dumpsters:GetChildren()) do
        if model:IsA("Model") then
            local zone = model:GetAttribute("ZoneRequired") or "None"
            if not allowedZones or allowedZones[zone] then
                local dist = (model:GetPivot().Position - root.Position).Magnitude
                if not nearestDist or dist < nearestDist then
                    nearestDist = dist
                    nearest = model
                end
            end
        end
    end
    return nearest
end
function Get.DumpsterPos(model)
    local leavesPart = model:FindFirstChild("Leaves")
    if leavesPart and leavesPart:IsA("BasePart") then
        return leavesPart.Position
    end
    return model:GetPivot().Position
end
function Get.Owns(toolKey)
    return Plr:GetAttribute("Owns" .. toolKey) == true
end
function Get.UpgradeDiscount(toolKey)
    local key = toolKey:lower()
    if string.find(key, "rake", 1, true) then
        return 1 - (Plr:GetAttribute("LobbyRakeDiscount") or 0)
    elseif string.find(key, "blower", 1, true) or string.find(key, "vacuum", 1, true) then
        return 1 - (Plr:GetAttribute("LobbyBlowerDiscount") or 0)
    end
    return 1
end
function Get.GroundPos(target)
    local params = RaycastParams.new()
    local exclude = {}
    local char = Plr.Character
    if char then exclude[#exclude + 1] = char end
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = exclude
    local result = workspace:Raycast(target + Vector3.new(0, 60, 0), Vector3.new(0, -200, 0), params)
    if result then return result.Position end
    return target
end
function Send.Empty()
    FireRemote(Remotes.EmptyBackpack)
end
function Send.BuyTool(key)
    FireRemote(Remotes.BuyToolCash, key)
end
function Send.BuyUpgrade(toolKey, upgName)
    FireRemote(Remotes.BuyUpgrade, toolKey, upgName)
end
function Send.BuyBag()
    FireRemote(Remotes.BuyBagUpgrade)
end
function Send.BuyVent(vent)
    FireRemote(Remotes.BuyVent, vent)
end
function Send.Equip(toolKey)
    Plr:SetAttribute("SelectedTool", toolKey)
end
function Send.Molotov(pos)
    FireRemote(Remotes.ThrowMolotov, pos)
end
function Send.Snowball(pos)
    FireRemote(Remotes.ThrowSnowball, pos)
end
function Send.DeployBot()
    FireRemote(Remotes.DeployL33FBOT)
end
function Send.CollectPart(part)
    FireRemote(Remotes.CollectDuckBotPart, part)
end
function Send.BBPickup()
    FireRemote(Remotes.BasketballPickup)
end
function Send.BBRelease()
    FireRemote(Remotes.BasketballRelease)
end
function Send.BBGoal(clean)
    FireRemote(Remotes.BasketballGoal, clean)
end
local function Func_AutoCollect()
    local sim = Modules.LeafSim
    if not sim then
        Library:Notify("LeafSim module not available yet, retrying...", 5)
    end
    while true do
        local simNow = Modules.LeafSim or sim
        if not simNow then
            task.wait(2)
        else
            local held = Plr:GetAttribute("Leaves") or 0
            local capacity = Plr:GetAttribute("LeafCapacity") or 25
            local infinite = Plr:GetAttribute("InfiniteBag") == true
            if not infinite and held >= capacity then
                task.wait(0.3)
            else
                local root = Get.Root()
                if root then
                    local radius = (Options.CollectRadius and Options.CollectRadius.Value) or 50
                    local leaves = Get.Leaves()
                    local nearby = {}
                    for _, leaf in ipairs(leaves) do
                        local dist = (root.Position - leaf.Position).Magnitude
                        if dist <= radius then
                            local value = 1
                            pcall(function()
                                if simNow.leafValueOfPart then
                                    value = simNow.leafValueOfPart(leaf) or 1
                                end
                            end)
                            nearby[#nearby + 1] = {part = leaf, dist = dist, value = value}
                        end
                    end
                    if #nearby > 0 then
                        table.sort(nearby, function(a, b)
                            if a.value ~= b.value then return a.value > b.value end
                            return a.dist < b.dist
                        end)
                        local first = nearby[1]
                        if first.dist > 12 then
                            root.CFrame = first.part.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.175)
                        end
                        local batch = {}
                        local collectAmount = (Options.CollectAmount and Options.CollectAmount.Value) or 50
                        local max = math.min(#nearby, collectAmount)
                        for i = 1, max do
                            batch[i] = nearby[i].part
                        end
                        pcall(function()
                            simNow.collectMany(batch)
                        end)
                    else
                        local nearest, nearestDist = nil, nil
                        for _, leaf in ipairs(leaves) do
                            local dist = (root.Position - leaf.Position).Magnitude
                            if not nearestDist or dist < nearestDist then
                                nearest, nearestDist = leaf, dist
                            end
                        end
                        if nearest then
                            root.CFrame = nearest.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.175)
                        end
                    end
                end
                task.wait(0.25)
            end
        end
    end
end
local function Func_AutoSell()
    while true do
        local held = Plr:GetAttribute("Leaves") or 0
        local capacity = Plr:GetAttribute("LeafCapacity") or 25
        local thresholdPct = (Options.SellThreshold and Options.SellThreshold.Value) or 100
        local needed = capacity * (thresholdPct / 100)
        if held >= needed and held > 0 then
            local root = Get.Root()
            local selected = (Options.SellAreaSelect and Options.SellAreaSelect.Value) or {}
            local allowedZones = nil
            if not selected["All"] then
                allowedZones = {}
                local any = false
                for zone, active in pairs(selected) do
                    if active then
                        allowedZones[zone] = true
                        any = true
                    end
                end
                if not any then allowedZones = nil end
            end
            local dumpster = Get.NearestDumpster(root, allowedZones)
            if root and dumpster then
                local targetPos = Get.DumpsterPos(dumpster)
                local dist = (root.Position - targetPos).Magnitude
                if dist > 20 then
                    root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                    task.wait(0.175)
                end
                Send.Empty()
            end
        end
        task.wait()
    end
end
local function Func_AutoVentBuy()
    while true do
        local root = Get.Root()
        local locked = Get.Vents(false)
        if root and #locked > 0 then
            table.sort(locked, function(a, b)
                return (root.Position - a.Position).Magnitude < (root.Position - b.Position).Magnitude
            end)
            local vent = locked[1]
            local cost = vent:GetAttribute("Cost") or 0
            if (Plr:GetAttribute("Cash") or 0) >= cost then
                local dist = (root.Position - vent.Position).Magnitude
                if dist > 10 then
                    root.CFrame = vent.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.175)
                end
                Send.BuyVent(vent)
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoVentFarm()
    while true do
        local sim = Modules.LeafSim
        if not sim then
            task.wait(2)
        else
            local root = Get.Root()
            local vents = Get.Vents(true)
            if root and #vents > 0 then
                local vent, ventDist = nil, nil
                for _, candidate in ipairs(vents) do
                    local dist = (candidate.Position - root.Position).Magnitude
                    if not ventDist or dist < ventDist then
                        vent, ventDist = candidate, dist
                    end
                end
                if vent then
                    local ventPos = vent.Position
                    local leaves = Get.Leaves()
                    local bestLeaf, bestDist = nil, nil
                    for _, leaf in ipairs(leaves) do
                        local dist = (leaf.Position - ventPos).Magnitude
                        if not bestDist or dist < bestDist then
                            bestLeaf, bestDist = leaf, dist
                        end
                    end
                    if bestLeaf then
                        if Get.Owns("LeafBlower") or Get.Owns("RainbowBlower") then
                            local rainbow = Get.Owns("RainbowBlower")
                            local dir = ventPos - bestLeaf.Position
                            if dir.Magnitude > 0.01 then
                                dir = dir.Unit
                            else
                                dir = Vector3.new(0, 0, -1)
                            end
                            root.CFrame = CFrame.new(bestLeaf.Position - dir * 2.5 + Vector3.new(0, 4, 0))
                            task.wait(0.175)
                            local burstUntil = os.clock() + 2
                            while os.clock() < burstUntil do
                                pcall(function()
                                    sim.blowAim(ventPos, rainbow)
                                end)
                                task.wait(0.08)
                            end
                        elseif Get.Owns("Rake") then
                            root.CFrame = CFrame.new(ventPos + Vector3.new(2, 4, 0))
                            task.wait(0.175)
                            pcall(function()
                                sim.rake(ventPos)
                            end)
                            task.wait(0.8)
                        else
                            Library:Notify("Vent Farm needs a Rake or a Leaf Blower", 5)
                            Toggles.AutoVentFarm:SetValue(false)
                            return
                        end
                    else
                        task.wait(1)
                    end
                end
            else
                task.wait(1)
            end
        end
        task.wait(0.15)
    end
end
local function Func_AutoUpgrade()
    while true do
        local cfg = Modules.UpgradeConfig
        if cfg then
            local selected = (Options.UpgradeSelect and Options.UpgradeSelect.Value) or {}
            for label, active in pairs(selected) do
                if active then
                    local info = Tables.UpgradeMap[label]
                    if info then
                        local toolDef = cfg.tools and cfg.tools[info.toolKey]
                        local upg = toolDef and toolDef.upgrades and toolDef.upgrades[info.upgName]
                        if upg then
                            local ownsAttr = toolDef.ownsAttr
                            if ownsAttr == nil or Plr:GetAttribute(ownsAttr) == true then
                                local level = Plr:GetAttribute("Upg_" .. info.toolKey .. "_" .. info.upgName) or 0
                                if level < (upg.max or 0) then
                                    local price = upg.prices and upg.prices[level + 1]
                                    if price then
                                        price = price * Get.UpgradeDiscount(info.toolKey)
                                        if (Plr:GetAttribute("Cash") or 0) >= price then
                                            Send.BuyUpgrade(info.toolKey, info.upgName)
                                            task.wait(0.2)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoBuyTool()
    while true do
        local cfg = Modules.UpgradeConfig
        if cfg then
            local selected = (Options.BuyToolSelect and Options.BuyToolSelect.Value) or {}
            for key, active in pairs(selected) do
                if active then
                    local def = cfg.shop and cfg.shop[key]
                    if def and def.cash and not def.robuxOnly then
                        if not Get.Owns(key) and (Plr:GetAttribute("Cash") or 0) >= def.cash then
                            Send.BuyTool(key)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoEquipTool()
    while true do
        local label = Options.EquipToolSelect.Value
        if label and label ~= "" then
            local current = Plr:GetAttribute("SelectedTool") or "Hand"
            if current ~= label then
                Send.Equip(label)
            end
        end
        task.wait(2)
    end
end
local function Func_AutoBagUpgrade()
    while true do
        local bag = Modules.BagConfig
        if bag and bag.caps and Plr:GetAttribute("InfiniteBag") ~= true then
            local level = Plr:GetAttribute("BagLevel") or 0
            if level < #bag.caps - 1 then
                local price = bag.prices and bag.prices[level + 1]
                if price and (Plr:GetAttribute("Cash") or 0) >= price then
                    Send.BuyBag()
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoL33FBOT()
    local owned = false
    local vars = Modules.Variables
    if vars and vars.data and type(vars.data.Gamepasses) == "table" and vars.data.Gamepasses.L33FBOT then
        owned = true
    end
    if Plr:GetAttribute("Owns_L33FBOT") == true then
        owned = true
    end
    if not owned then
        Library:Notify("L33FBOT gamepass not owned", 5)
        Toggles.AutoL33FBOT:SetValue(false)
        return
    end
    while true do
        if Plr:GetAttribute("L33FBOTActive") ~= true and Plr:GetAttribute("L33FBOTCooldown") ~= true then
            Send.DeployBot()
        end
        task.wait(2)
    end
end
local function Func_AutoDuckParts()
    while true do
        local prefix = (Modules.BotConfig and Modules.BotConfig.PART_PREFIX) or "DuckBotPart"
        local mapRoot = Get.MapRoot()
        local root = Get.Root()
        if mapRoot and root then
            for _, part in ipairs(mapRoot:GetChildren()) do
                if part:IsA("BasePart") and part.Name:sub(1, #prefix) == prefix then
                    root.CFrame = CFrame.new(part.Position + Vector3.new(0, 4, 0))
                    task.wait(0.2)
                    Send.CollectPart(part)
                    task.wait(0.3)
                end
            end
        end
        task.wait(5)
    end
end
local function Func_AutoMolotov()
    while true do
        if not Get.Owns("Molotov") then
            Library:Notify("You do not own the Molotov", 5)
            Toggles.AutoMolotov:SetValue(false)
            return
        end
        local root = Get.Root()
        local cooldown = Plr:GetAttribute("MolotovCooldown")
        if root and not cooldown then
            if (Plr:GetAttribute("SelectedTool") or "Hand") ~= "Molotov" then
                Send.Equip("Molotov")
                task.wait(0.3)
            end
            local range = (Modules.MolotovConfig and Modules.MolotovConfig.MAX_RANGE) or 35
            local leaves = Get.Leaves()
            local nearest, nearestDist = nil, nil
            for _, leaf in ipairs(leaves) do
                local dist = (leaf.Position - root.Position).Magnitude
                if dist <= range and (not nearestDist or dist < nearestDist) then
                    nearest, nearestDist = leaf, dist
                end
            end
            if nearest then
                local aim = nearest.Position
                local flat = Vector3.new(aim.X - root.Position.X, 0, aim.Z - root.Position.Z)
                if flat.Magnitude > range then
                    aim = root.Position + flat.Unit * range
                end
                local ground = Get.GroundPos(aim)
                Send.Molotov(ground)
                local cd = (Modules.MolotovConfig and Modules.MolotovConfig.COOLDOWN) or 20
                task.wait(cd)
            else
                task.wait(2)
            end
        else
            task.wait(1)
        end
    end
end
local function Func_AutoSnowball()
    while true do
        if not Get.Owns("Snowball") then
            Library:Notify("You do not own the Snowball", 5)
            Toggles.AutoSnowball:SetValue(false)
            return
        end
        local root = Get.Root()
        local cooldown = Plr:GetAttribute("SnowballCooldown")
        if root and not cooldown then
            if (Plr:GetAttribute("SelectedTool") or "Hand") ~= "Snowball" then
                Send.Equip("Snowball")
                task.wait(0.3)
            end
            local cfg = Modules.SnowballConfig
            local range = (cfg and cfg.MAX_RANGE) or 35
            local leaves = Get.Leaves()
            local nearest, nearestDist = nil, nil
            for _, leaf in ipairs(leaves) do
                local dist = (leaf.Position - root.Position).Magnitude
                if dist <= range and (not nearestDist or dist < nearestDist) then
                    nearest, nearestDist = leaf, dist
                end
            end
            if nearest then
                local aim = nearest.Position
                local flat = Vector3.new(aim.X - root.Position.X, 0, aim.Z - root.Position.Z)
                if flat.Magnitude > range then
                    aim = root.Position + flat.Unit * range
                end
                local ground = Get.GroundPos(aim)
                Send.Snowball(ground)
                task.wait(1)
                local radius = (cfg and cfg.FREEZE_RADIUS) or 10
                local sweep = Get.Leaves()
                for _, leaf in ipairs(sweep) do
                    if (leaf.Position - ground).Magnitude <= radius then
                        root.CFrame = CFrame.new(leaf.Position + Vector3.new(0, 3.2, 0))
                        task.wait(0.16)
                    end
                end
                local cd = (cfg and cfg.COOLDOWN) or 25
                task.wait(cd)
            else
                task.wait(2)
            end
        else
            task.wait(1)
        end
    end
end
local function Func_AutoBasketball()
    while true do
        local bb = Get.MapFolder("Basketball")
        local root = Get.Root()
        local mapRoot = Get.MapRoot()
        local net = mapRoot and mapRoot:FindFirstChild("BasketballNet")
        if bb and root and net then
            local ball = bb:FindFirstChild("BasketBall")
            local collider = bb:FindFirstChild("Collider")
            if ball and collider then
                local holder = ball:GetAttribute("HeldBy") or 0
                if holder ~= Plr.UserId then
                    if holder == 0 then
                        root.CFrame = CFrame.new(ball.Position + Vector3.new(0, 3, 0))
                        task.wait(0.175)
                        Send.BBPickup()
                        task.wait(0.5)
                    else
                        task.wait(1)
                    end
                else
                    local netPos = net.Position
                    pcall(function()
                        collider.CFrame = CFrame.new(netPos + Vector3.new(0, 8, 0))
                    end)
                    local vel = Vector3.new(0, -24, 0)
                    pcall(function()
                        collider.AssemblyLinearVelocity = vel
                    end)
                    pcall(function()
                        collider.Velocity = vel
                    end)
                    Send.BBRelease()
                    local deadline = os.clock() + 3
                    while os.clock() < deadline do
                        local ok, pos = pcall(function()
                            return collider.Position
                        end)
                        if ok and pos then
                            local flatDist = (Vector2.new(pos.X, pos.Z) - Vector2.new(netPos.X, netPos.Z)).Magnitude
                            if flatDist <= 3 and pos.Y < netPos.Y then
                                Send.BBGoal(true)
                                break
                            end
                        end
                        task.wait(0.05)
                    end
                    task.wait(1)
                end
            else
                task.wait(2)
            end
        else
            task.wait(2)
        end
        task.wait(0.2)
    end
end
local function RefreshTableValues()
    local cfg = Modules.UpgradeConfig
    if cfg then
        Tables.UpgradeList = {}
        Tables.UpgradeMap = {}
        for toolKey, toolDef in pairs(cfg.tools or {}) do
            for upgName in pairs(toolDef.upgrades or {}) do
                local label = toolKey .. " / " .. upgName
                table.insert(Tables.UpgradeList, label)
                Tables.UpgradeMap[label] = {toolKey = toolKey, upgName = upgName}
            end
        end
        table.sort(Tables.UpgradeList)
        Tables.BuyList = {}
        for key, def in pairs(cfg.shop or {}) do
            if def.cash and not def.robuxOnly then
                table.insert(Tables.BuyList, key)
            end
        end
        table.sort(Tables.BuyList)
        Tables.EquipList = {}
        local seen = {}
        local function AddKey(key)
            if key and not seen[key] then
                seen[key] = true
                table.insert(Tables.EquipList, key)
            end
        end
        for toolKey in pairs(cfg.tools or {}) do
            AddKey(toolKey)
        end
        for key in pairs(cfg.shop or {}) do
            if key ~= "InfiniteBag" then
                AddKey(key)
            end
        end
        if Modules.L33FBOTConfig and Modules.L33FBOTConfig.TOOL_KEY then
            AddKey(Modules.L33FBOTConfig.TOOL_KEY)
        end
        table.sort(Tables.EquipList)
    end
    Tables.SellAreaList = {}
    local dumpsters = Get.MapFolder("Dumpsters")
    if dumpsters then
        local seenZones = {}
        for _, model in ipairs(dumpsters:GetChildren()) do
            if model:IsA("Model") then
                local zone = model:GetAttribute("ZoneRequired") or "None"
                if not seenZones[zone] then
                    seenZones[zone] = true
                    table.insert(Tables.SellAreaList, zone)
                end
            end
        end
        table.sort(Tables.SellAreaList)
    end
    if Options.SellAreaSelect then
        pcall(function()
            local values = { "All" }
            for _, v in ipairs(Tables.SellAreaList) do table.insert(values, v) end
            Options.SellAreaSelect:SetValues(values)
        end)
    end
    if Options.UpgradeSelect then
        pcall(function()
            local values = { "All" }
            for _, v in ipairs(Tables.UpgradeList) do table.insert(values, v) end
            Options.UpgradeSelect:SetValues(values)
        end)
    end
    if Options.BuyToolSelect then
        pcall(function()
            local values = { "All" }
            for _, v in ipairs(Tables.BuyList) do table.insert(values, v) end
            Options.BuyToolSelect:SetValues(values)
        end)
    end
    if Options.EquipToolSelect then
        pcall(function()
            Options.EquipToolSelect:SetValues(Tables.EquipList)
        end)
    end
end
RefreshTableValues()
local function ResolveModuleAsync(parent, name)
    task.spawn(function()
        local ok, result = pcall(function()
            local obj = parent:WaitForChild(name, 30)
            if obj and obj:IsA("ModuleScript") then return require(obj) end
            return nil
        end)
        if ok and result ~= nil and Modules[name] == nil then
            Modules[name] = result
            pcall(RefreshTableValues)
        end
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
        T1 = TB.Main.Left.Autofarm:AddTab("Farm"),
        T2 = TB.Main.Left.Autofarm:AddTab("Progress"),
        T3 = TB.Main.Left.Autofarm:AddTab("Joiner"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Config"),
        T2 = TB.Main.Right.Autofarm:AddTab("Extras"),
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
    Serverhop()
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
Toggles.AntiKick:OnChanged(function(state)
    if state then Func_AntiKick() end
end)
Toggles.AutoServerhop:OnChanged(function(state)
    Thread("AutoServerhop", Func_AutoServerhop, state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP and Toggles.InstantPP.Value then
        prompt.HoldDuration = 0
    end
end)
local IdledConnection
local function RunAntiAFK()
    if IdledConnection or Connections.AntiAFK then return end
    local hooked = false
    if typeof(getconnection) == "function" or getconnections then
        pcall(function()
            local conn = nil
            if typeof(getconnection) == "function" then
                conn = getconnection(Plr.Idled, 1)
            end
            if not conn and getconnections then
                conn = getconnections(Plr.Idled)[1]
            end
            if conn and conn.Disable then
                conn:Disable()
                IdledConnection = conn
                hooked = true
            end
        end)
    end
    if not hooked then
        Connections.AntiAFK = Plr.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end
local function StopAntiAFK()
    if IdledConnection then
        pcall(function()
            IdledConnection:Enable()
        end)
        IdledConnection = nil
    end
    if Connections.AntiAFK then
        Connections.AntiAFK:Disconnect()
        Connections.AntiAFK = nil
    end
end
Toggles.AntiAFK:OnChanged(function(state)
    if state then RunAntiAFK() else StopAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect", Default = false, Callback = function(val) Thread("AutoCollect", Func_AutoCollect, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false, Callback = function(val) Thread("AutoSell", Func_AutoSell, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoVentFarm", { Text = "Auto Vent Farm", Default = false, Callback = function(val) Thread("AutoVentFarm", Func_AutoVentFarm, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoVentBuy", { Text = "Auto Buy Vents", Default = false, Callback = function(val) Thread("AutoVentBuy", Func_AutoVentBuy, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoBagUpgrade", { Text = "Auto Bag Upgrade", Default = false, Callback = function(val) Thread("AutoBagUpgrade", Func_AutoBagUpgrade, val) end })
TB_Tabs.Autofarm.T2:AddToggle("AutoUpgrade", { Text = "Auto Upgrades", Default = false, Callback = function(val) Thread("AutoUpgrade", Func_AutoUpgrade, val) end })
TB_Tabs.Autofarm.T2:AddToggle("AutoBuyTool", { Text = "Auto Buy Tools", Default = false, Callback = function(val) Thread("AutoBuyTool", Func_AutoBuyTool, val) end })
TB_Tabs.Autofarm.T2:AddToggle("AutoEquipTool", { Text = "Auto Equip Tool", Default = false, Callback = function(val) Thread("AutoEquipTool", Func_AutoEquipTool, val) end })
TB_Tabs.Autofarm.T2:AddToggle("AutoL33FBOT", { Text = "Auto Deploy Bot", Default = false, Callback = function(val) Thread("AutoL33FBOT", Func_AutoL33FBOT, val) end })
TB_Tabs.Autofarm.T2:AddToggle("AutoDuckParts", { Text = "Auto DuckBot Parts", Default = false, Callback = function(val) Thread("AutoDuckParts", Func_AutoDuckParts, val) end })
Tables.MapList = {}
Tables.MapKeyByLabel = {}
if Modules.MapList then
    for _, v in ipairs(Modules.MapList) do
        local label = v.name or v.key
        table.insert(Tables.MapList, label)
        Tables.MapKeyByLabel[label] = v.key
    end
else
    notyuri("[Joiner] MapList module unavailable")
end
Tables.DifficultyList = {}
if Modules.DifficultyConfig and Modules.DifficultyConfig.list then
    for i, v in ipairs(Modules.DifficultyConfig.list) do
        Tables.DifficultyList[i] = v.label
    end
else
    notyuri("[Joiner] DifficultyConfig module unavailable")
end
TB_Tabs.Autofarm.T3:AddDropdown("JoinerMap", {
    Text = "Map",
    Values = Tables.MapList,
    Default = Tables.MapList[1] or "",
})
TB_Tabs.Autofarm.T3:AddDropdown("JoinerDifficulty", {
    Text = "Difficulty",
    Values = Tables.DifficultyList,
    Default = Tables.DifficultyList[1] or "",
})
local function Func_AutoJoin()
    while true do
        if Plr:GetAttribute("InTeam") == true then
            task.wait(1)
        else
            local mapKey = Tables.MapKeyByLabel[Options.JoinerMap.Value]
            local diffIndex
            for i, label in ipairs(Tables.DifficultyList) do
                if label == Options.JoinerDifficulty.Value then
                    diffIndex = i
                    break
                end
            end
            if not mapKey then
                notyuri("[Joiner] No map selected")
                task.wait(1)
            elseif not diffIndex then
                notyuri("[Joiner] No difficulty selected")
                task.wait(1)
            elseif not TeamsFolder then
                notyuri("[Joiner] Teams folder missing")
                task.wait(1)
            else
                local targetSquare
                for _, square in ipairs(TeamsFolder:GetChildren()) do
                    if square:IsA("Model") and (square:GetAttribute("State") or "Open") == "Open" then
                        targetSquare = square
                        break
                    end
                end
                if not targetSquare then
                    task.wait(1)
                else
                    local wall = targetSquare:FindFirstChild("Wall")
                    local touchInterest = wall and wall:FindFirstChild("TouchInterest")
                    if not (wall and touchInterest) then
                        notyuri("[Joiner] No Wall/TouchInterest found on " .. targetSquare.Name)
                        task.wait(1)
                    else
                        FireTI(wall)
                        task.wait(0.2)
                        FireRemote(Remotes.TeamAction, "setMax", 1)
                        FireRemote(Remotes.TeamAction, "setMap", mapKey)
                        FireRemote(Remotes.TeamAction, "setDifficulty", diffIndex)
                        FireRemote(Remotes.TeamAction, "confirm")
                        task.wait(1)
                    end
                end
            end
        end
    end
end
TB_Tabs.Autofarm.T3:AddToggle("AutoJoin", {
    Text = "Auto Join",
    Default = false,
    Callback = function(val) Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), val) end,
})
TB_Tabs.Autofarm2.T2:AddToggle("AutoMolotov", { Text = "Auto Molotov", Default = false, Callback = function(val) Thread("AutoMolotov", Func_AutoMolotov, val) end })
TB_Tabs.Autofarm2.T2:AddToggle("AutoSnowball", { Text = "Auto Snowball", Default = false, Callback = function(val) Thread("AutoSnowball", Func_AutoSnowball, val) end })
TB_Tabs.Autofarm2.T1:AddSlider("CollectRadius", { Text = "Collect Radius", Default = 50, Min = 10, Max = 200, Compact = true, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("CollectAmount", { Text = "Collect Amount", Default = 50, Min = 1, Max = 1000, Compact = true, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("SellThreshold", { Text = "Sell Threshold", Default = 100, Min = 1, Max = 100, Compact = true, Rounding = 0 })
AddMultiDropdown(TB_Tabs.Autofarm2.T1, "SellAreaSelect", { Text = "Sell Area", Values = Tables.SellAreaList, Default = {} })
AddMultiDropdown(TB_Tabs.Autofarm2.T1, "UpgradeSelect", { Text = "Select Upgrades", Values = Tables.UpgradeList, Default = {} })
AddMultiDropdown(TB_Tabs.Autofarm2.T1, "BuyToolSelect", { Text = "Tools to Buy", Values = Tables.BuyList, Default = {} })
TB_Tabs.Autofarm2.T1:AddDropdown("EquipToolSelect", { Text = "Tool to Equip", Values = Tables.EquipList, Default = Tables.EquipList[1] or "" })
for _, name in ipairs({"UpgradeConfig", "BagConfig", "MapRegistry", "MolotovConfig", "SnowballConfig", "L33FBOTConfig", "BotConfig"}) do
    if not Modules[name] then
        ResolveModuleAsync(RS, name)
    end
end
if not Modules.LeafSim then
    ResolveModuleAsync(Plr.PlayerScripts, "LeafSim")
end
if not Modules.Variables then
    if CMFolder then
        ResolveModuleAsync(CMFolder, "Variables")
    else
        task.spawn(function()
            local ok, folder = pcall(function()
                return Plr.PlayerScripts:WaitForChild("ClientManager", 15)
            end)
            if ok and folder and not Modules.Variables then
                ResolveModuleAsync(folder, "Variables")
            end
        end)
    end
end
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
SaveManager:SetFolder("Yuri/CATL")
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
