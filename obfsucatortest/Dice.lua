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
local NetRoot = RS:WaitForChild("Network", 15)
local function WaitForNetRemote(service, kind, name)
    if not NetRoot then return nil end
    local base = NetRoot
    if service ~= nil then
        base = NetRoot:WaitForChild(service, 5)
        if not base then
            notyuri("Network namespace missing:", tostring(service))
            return nil
        end
    end
    local kindFolder = base:WaitForChild(kind, 5)
    if not kindFolder then
        notyuri("Network kind folder missing:", tostring(service), tostring(kind))
        return nil
    end
    local remote = kindFolder:WaitForChild(name, 5)
    if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        return remote
    end
    notyuri("Network remote missing:", tostring(service), tostring(kind), tostring(name))
    return nil
end
Remotes.BuyUpgrade = WaitForNetRemote(nil, "RE", "BuyUpgrade")
Remotes.SetAutoRoll = WaitForNetRemote("RollService", "RE", "SetAutoRoll")
Remotes.RollDice = WaitForNetRemote("RollService", "RF", "RollDice")
Remotes.BuyDice = WaitForNetRemote("DiceShopService", "RE", "BuyDice")
Remotes.EquipDice = WaitForNetRemote("DiceShopService", "RE", "EquipDice")
Remotes.CollectBalance = WaitForNetRemote("PlotService", "RE", "CollectBalance")
Remotes.LevelUpSlot = WaitForNetRemote("PlotService", "RE", "LevelUpSlot")
Remotes.EquipBest = WaitForNetRemote("PlotService", "RE", "EquipBest")
Remotes.SellEquipped = WaitForNetRemote("SellService", "RF", "SellEquipped")
Remotes.SellInventory = WaitForNetRemote("SellService", "RF", "SellInventory")
Remotes.UpdateAutoSell = WaitForNetRemote("SellService", "RE", "UpdateAutoSell")
Remotes.UseBoost = WaitForNetRemote("BoostService", "RE", "Use")
Remotes.UseSpin = WaitForNetRemote("SpinService", "RE", "Use")
Remotes.Rebirth = WaitForNetRemote("RebirthService", "RE", "Rebirth")
Remotes.PlayTower = WaitForNetRemote("Towers", "RF", "PlayTower")
Remotes.CompleteTowerFloor = WaitForNetRemote("Towers", "RF", "CompleteTowerFloor")
Remotes.EquipBestTowerTeam = WaitForNetRemote("Towers", "RE", "EquipBestTowerTeam")
Remotes.ClaimGroupReward = WaitForNetRemote("GroupRewardService", "RE", "Claim")
Remotes.ClaimOfflineEarnings = WaitForNetRemote("OfflineEarningsService", "RE", "Claim")
Remotes.ClaimDailyReward = WaitForNetRemote("DailyRewardService", "RE", "Claim")
local function RequireModuleSync(root, path, storeKey)
    local obj = GetObject(root, path)
    if obj and obj:IsA("ModuleScript") then
        local ok, result = pcall(require, obj)
        if ok and result ~= nil then
            Modules[storeKey] = result
            return true
        end
        notyuri("Module require failed:", path, tostring(result))
    end
    return false
end
local function RequireModuleAsync(root, path, storeKey)
    task.spawn(function()
        local waited = 0
        while waited < 45 do
            local obj = GetObject(root, path)
            if obj and obj:IsA("ModuleScript") then
                local ok, result = pcall(require, obj)
                if ok and result ~= nil then
                    Modules[storeKey] = result
                    return
                end
                notyuri("Module async require failed:", path, tostring(result))
                return
            end
            task.wait(1)
            waited = waited + 1
        end
        notyuri("Module never appeared:", path)
    end)
end
local function RequireModule(root, path, storeKey)
    if not RequireModuleSync(root, path, storeKey) then
        RequireModuleAsync(root, path, storeKey)
    end
end
local FW = RS:FindFirstChild("Framework")
local PackagesFolder = RS:FindFirstChild("Packages")
if FW then
    RequireModule(FW, "Features.Rolling.Dice", "Dice")
    RequireModule(FW, "Features.Upgrades.Upgrades", "Upgrades")
    RequireModule(FW, "Features.Upgrades.TreeStructure", "TreeStructure")
    RequireModule(FW, "Features.Rebirth.Rebirths", "Rebirths")
    RequireModule(FW, "Features.Towers.Towers", "Towers")
    RequireModule(FW, "Features.Towers.TowerRefs", "TowerRefs")
    RequireModule(FW, "Features.Plot.PlotConfig", "PlotConfig")
    RequireModule(FW, "Features.Inventory.EntryRegistry", "EntryRegistry")
    RequireModule(FW, "Features.Inventory.Kinds.Boost.BoostConfig", "BoostConfig")
    RequireModule(FW, "Features.Inventory.Kinds.Spin.SpinConfig", "SpinConfig")
    RequireModule(FW, "Features.Rewards.DailyRewardConfig", "DailyRewardConfig")
    RequireModuleAsync(FW, "Features.Data.DataController", "DataController")
    RequireModuleAsync(FW, "Features.Inventory.Kinds.Unit.UnitUtil", "UnitUtil")
else
    notyuri("ERROR: ReplicatedStorage.Framework never appeared")
end
if PackagesFolder then
    RequireModule(PackagesFolder, "NumberFormatter", "NumberFormatter")
else
    notyuri("ERROR: ReplicatedStorage.Packages never appeared")
end
local function ReadData(reader)
    local data = Modules.DataController
    if not data then return nil end
    local ok, result = pcall(reader, data)
    if ok then return result end
    return nil
end
local function GetMoney()
    return tonumber(ReadData(function(d) return d.Money() end)) or 0
end
local function GetRebirthLevel()
    return tonumber(ReadData(function(d) return d.Rebirth() end)) or 0
end
local function GetSlotEntry(index)
    local slots = ReadData(function(d) return d.Slots() end)
    local entry = type(slots) == "table" and slots[tostring(index)] or nil
    if entry == nil then
        local data = Modules.DataController
        if data then
            local ok, res = pcall(function()
                return data.Slots[tostring(index)]()
            end)
            if ok then entry = res end
        end
    end
    if type(entry) == "table" then return entry end
    return nil
end
local function GetMaxSlots()
    local plotConfig = Modules.PlotConfig
    if not (plotConfig and plotConfig.GetMaxSlots) then return 0 end
    return tonumber(plotConfig.GetMaxSlots()) or 0
end
local function IsSlotUnlocked(index)
    local plotConfig = Modules.PlotConfig
    if not (plotConfig and plotConfig.GetSlotRebirthRequirement) then return false end
    local requirement = tonumber(plotConfig.GetSlotRebirthRequirement(index)) or 0
    return GetRebirthLevel() >= requirement
end
local function InvokeGameRemote(remote, ...)
    if not remote then return nil end
    local args = {...}
    local ok, result = pcall(function()
        return remote:InvokeServer(unpack(args))
    end)
    if not ok then
        notyuri("Invoke error:", tostring(remote), tostring(result))
        return nil
    end
    return result
end
local function Func_AutoDice()
    while Toggles.AutoDice.Value do
        local ok, loopErr = pcall(function()
            local diceModule = Modules.Dice
            local data = Modules.DataController
            if not (diceModule and diceModule.GetAll and data) then return end
            local money = GetMoney()
            local equipped = ReadData(function(d) return d.Dice() end)
            local all = diceModule.GetAll()
            local best, bestLuck = nil, -1
            for diceName, diceConfig in pairs(all) do
                if type(diceConfig) == "table" and diceConfig.price ~= nil then
                    local luck = tonumber(diceConfig.luck) or 0
                    local price = tonumber(diceConfig.price) or math.huge
                    local owned = ReadData(function(d) return d.OwnedDice[diceName]() end) == true
                    if (owned or money >= price) and luck > bestLuck then
                        best, bestLuck = diceName, luck
                    end
                end
            end
            if not best then return end
            local owned = ReadData(function(d) return d.OwnedDice[best]() end) == true
            if owned and equipped == best then return end
            FireRemote(owned and Remotes.EquipDice or Remotes.BuyDice, best)
        end)
        if not ok then
            notyuri("AutoDice error:", tostring(loopErr))
        end
        task.wait(1)
    end
end
local function Func_AutoCollect()
    while Toggles.AutoCollect.Value do
        local ok, loopErr = pcall(function()
            local data = Modules.DataController
            if not (data and Modules.PlotConfig) then return end
            local maxSlots = GetMaxSlots()
            for index = 1, maxSlots do
                if not Toggles.AutoCollect.Value then break end
                if IsSlotUnlocked(index) then
                    local entry = GetSlotEntry(index)
                    if entry then
                        local balance = tonumber(entry.balance) or 0
                        if balance > 0 then
                            FireRemote(Remotes.CollectBalance, index)
                            task.wait(0.1)
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoCollect error:", tostring(loopErr))
        end
        task.wait(1)
    end
end
local function DoAutoSell()
    local inventory = ReadData(function(d) return d.Inventory() end)
    if type(inventory) ~= "table" then
        return
    end
    local entryRegistry = Modules.EntryRegistry
    if not (entryRegistry and entryRegistry.getEntryConfig) then
        return
    end
    local raw = Options.SellThreshold and Options.SellThreshold.Value
    local threshold = tonumber(raw)
    if not threshold or threshold < 0 or threshold > 1e18 then
        return
    end
    local keys = {}
    for inventoryKey, entry in pairs(inventory) do
        if type(entry) == "table" and type(entry.name) == "string" then
            if threshold <= 0 then
                table.insert(keys, inventoryKey)
            else
                local config = entryRegistry.getEntryConfig(entry.name)
                if config and config.kind == "Unit" and type(config.chance) == "function" then
                    local okChance, chance = pcall(config.chance, { mutation = entry.attributes and entry.attributes.mutation })
                    if okChance and type(chance) == "number" and chance < threshold then
                        table.insert(keys, inventoryKey)
                    end
                end
            end
        end
    end
    if #keys == 0 then
        return
    end
    InvokeGameRemote(Remotes.SellInventory, keys)
end
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        local ok, loopErr = pcall(DoAutoSell)
        if not ok then
            notyuri("AutoSell error:", tostring(loopErr))
        end
        task.wait(2)
    end
end
local function Func_AutoLevelUp()
    while Toggles.AutoLevelUp.Value do
        local ok, loopErr = pcall(function()
            local data = Modules.DataController
            local unitUtil = Modules.UnitUtil
            if not (data and unitUtil and unitUtil.GetLevelPrice and Modules.PlotConfig) then return end
            local money = GetMoney()
            local maxSlots = GetMaxSlots()
            for index = 1, maxSlots do
                if not Toggles.AutoLevelUp.Value then break end
                if IsSlotUnlocked(index) then
                    local entry = GetSlotEntry(index)
                    local unitId = entry and entry.unitId or nil
                    if unitId then
                        local unit = ReadData(function(d) return d.Inventory[unitId]() end)
                        if type(unit) == "table" and type(unit.name) == "string" and type(unit.attributes) == "table" then
                            local currentLevel = tonumber(unit.attributes.level) or 1
                            local maxLevel = tonumber(Options.MaxLevel and Options.MaxLevel.Value) or math.huge
                            if currentLevel < maxLevel then
                                local okPrice, price = pcall(unitUtil.GetLevelPrice, unit.name, unit.attributes)
                                if okPrice and money >= (tonumber(price) or math.huge) then
                                    FireRemote(Remotes.LevelUpSlot, index)
                                    task.wait()
                                end
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoLevelUp error:", tostring(loopErr))
        end
        task.wait()
    end
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local ok, loopErr = pcall(function()
            local data = Modules.DataController
            local upgrades = Modules.Upgrades
            if not (data and upgrades) then return end
            local money = GetMoney()
            local tree = Modules.TreeStructure
            for upgradeKey, upgradeConfig in pairs(upgrades) do
                if not Toggles.AutoUpgrade.Value then break end
                if type(upgradeConfig) == "table" and upgradeConfig.price ~= nil then
                    local owned = ReadData(function(d) return d.Upgrades[upgradeKey]() end) == true
                    if not owned then
                        local price = tonumber(upgradeConfig.price) or 0
                        local parentOwned = true
                        if tree and tree.GetParent then
                            local parent = tree.GetParent(upgradeKey)
                            if parent and parent ~= "Start" then
                                parentOwned = ReadData(function(d) return d.Upgrades[parent]() end) == true
                            end
                        end
                        if parentOwned and money >= price then
                            FireRemote(Remotes.BuyUpgrade, upgradeKey)
                            money = money - price
                            task.wait(0.3)
                        end
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoUpgrade error:", tostring(loopErr))
        end
        task.wait(.2)
    end
end
local function Func_AutoEquip()
    while Toggles.AutoEquip.Value do
        local ok, loopErr = pcall(function()
            FireRemote(Remotes.EquipBest)
        end)
        if not ok then
            notyuri("AutoEquip error:", tostring(loopErr))
        end
        task.wait(5)
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        local ok, loopErr = pcall(function()
            local data = Modules.DataController
            local rebirths = Modules.Rebirths
            if not (data and rebirths and rebirths.GetNext) then return end
            local level = GetRebirthLevel()
            local nextInfo = rebirths.GetNext(level)
            if type(nextInfo) ~= "table" then return end
            local cost = tonumber(nextInfo.cost) or math.huge
            if GetMoney() >= cost then
                FireRemote(Remotes.Rebirth)
            end
        end)
        if not ok then
            notyuri("AutoRebirth error:", tostring(loopErr))
        end
        task.wait(1)
    end
end
local function Func_AutoClaims()
    while Toggles.AutoClaims.Value do
        local ok, loopErr = pcall(function()
            local data = Modules.DataController
            if not data then return end
            local claimedGroup = ReadData(function(d) return d.ClaimedGroupReward() end)
            if claimedGroup ~= true then
                FireRemote(Remotes.ClaimGroupReward)
                task.wait(0.5)
            end
            local pendingOffline = tonumber(ReadData(function(d) return d.PendingOfflineEarnings() end)) or 0
            if pendingOffline > 0 then
                FireRemote(Remotes.ClaimOfflineEarnings)
                task.wait(0.5)
            end
            local lastDaily = tonumber(ReadData(function(d) return d.LastDailyRewardClaim() end)) or 0
            local dailyConfig = Modules.DailyRewardConfig
            if lastDaily == 0 or (dailyConfig and dailyConfig.Cooldown and (os.time() - lastDaily) >= (tonumber(dailyConfig.Cooldown) or math.huge)) then
                FireRemote(Remotes.ClaimDailyReward)
                task.wait(0.5)
            end
        end)
        if not ok then
            notyuri("AutoClaims error:", tostring(loopErr))
        end
        task.wait(30)
    end
end
local function Func_AutoUseEntries(toggleId, configKey, remote)
    return function()
        while Toggles[toggleId].Value do
            local ok, loopErr = pcall(function()
                local data = Modules.DataController
                local configModule = Modules[configKey]
                if not (data and configModule and type(configModule.entries) == "table") then return end
                local inventory = ReadData(function(d) return d.Inventory() end)
                if type(inventory) ~= "table" then return end
                for inventoryKey, entry in pairs(inventory) do
                    if not Toggles[toggleId].Value then break end
                    if type(entry) == "table" and configModule.entries[entry.name] then
                        local amount = tonumber(entry.amount) or 1
                        if amount > 0 then
                            FireRemote(remote, inventoryKey)
                            task.wait(0.25)
                        end
                    end
                end
            end)
            if not ok then
                notyuri(toggleId .. " error:", tostring(loopErr))
            end
            task.wait(2)
        end
    end
end
local Func_AutoSpins = Func_AutoUseEntries("AutoSpins", "SpinConfig", Remotes.UseSpin)
local BoostSelection_GetSelection
local function Func_AutoBoosts()
    while Toggles.AutoBoosts.Value do
        local ok, loopErr = pcall(function()
            local data = Modules.DataController
            local configModule = Modules.BoostConfig
            if not (data and configModule and type(configModule.entries) == "table") then return end
            local inventory = ReadData(function(d) return d.Inventory() end)
            if type(inventory) ~= "table" then return end
            local selected = BoostSelection_GetSelection and BoostSelection_GetSelection() or {}
            for inventoryKey, entry in pairs(inventory) do
                if not Toggles.AutoBoosts.Value then break end
                if type(entry) == "table" and configModule.entries[entry.name] and selected[entry.name] then
                    local amount = tonumber(entry.amount) or 1
                    if amount > 0 then
                        FireRemote(Remotes.UseBoost, inventoryKey)
                        task.wait(0.25)
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoBoosts error:", tostring(loopErr))
        end
        task.wait(2)
    end
end
local function Func_AutoTower()
    while Toggles.AutoTower.Value do
        local ok, loopErr = pcall(function()
            local refs = Modules.TowerRefs
            if not (refs and type(refs.Actions) == "table" and type(refs.ActionWaitTime) == "table") then return end
            local towerName = Options.TowerSelection and Options.TowerSelection.Value
            if type(towerName) ~= "string" or towerName == "" then return end
            FireRemote(Remotes.EquipBestTowerTeam)
            task.wait(1.25)
            local started = InvokeGameRemote(Remotes.PlayTower, towerName)
            if started ~= true then
                task.wait(2)
                return
            end
            local idleRetries = 0
            while Toggles.AutoTower.Value do
                local actions = InvokeGameRemote(Remotes.CompleteTowerFloor)
                if type(actions) ~= "table" or #actions == 0 then
                    idleRetries = idleRetries + 1
                    if idleRetries > 30 then break end
                    task.wait(0.3)
                    continue
                end
                idleRetries = 0
                local ended = false
                for _, actionEntry in ipairs(actions) do
                    if type(actionEntry) == "table" then
                        local actionName = actionEntry.action
                        if actionName == refs.Actions.ended then
                            ended = true
                        else
                            task.wait(tonumber(refs.ActionWaitTime[actionName]) or 0.1)
                        end
                    end
                end
                if ended then break end
            end
            task.wait(3.25)
        end)
        if not ok then
            notyuri("AutoTower error:", tostring(loopErr))
        end
        task.wait(0.5)
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
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)", Disabled = not Support.HookMeta })
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
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDice", { Text = "Auto Buy Dice", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("SellThreshold", {
    Text = "Sell Threshold",
    Numeric = false,
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoLevelUp", { Text = "Auto Level Up", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("MaxLevel", { Text = "Max Level Up", Numeric = false, ClearTextOnFocus = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoClaims", { Text = "Auto Claim", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBoosts", { Text = "Auto Use Boosts", Default = false })
do
    local boostNames = {}
    if Modules.BoostConfig and type(Modules.BoostConfig.entries) == "table" then
        for name in pairs(Modules.BoostConfig.entries) do
            table.insert(boostNames, name)
        end
        table.sort(boostNames)
    end
    BoostSelection_GetSelection = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "AutoBoostsSelection", {
        Text = "Potions To Use",
        Values = boostNames,
        Default = { ["All"] = true },
    })
end
TB_Tabs.Autofarm.T1:AddToggle("AutoSpins", { Text = "Auto Use Spins", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTower", { Text = "Auto Tower", Default = false })
local function BuildTowerDropdown()
    if Options.TowerSelection then return end
    local towersModule = Modules.Towers
    if not (towersModule and towersModule.GetAll) then return end
    local list = {}
    for towerName, towerConfig in pairs(towersModule.GetAll()) do
        if type(towerConfig) == "table" then
            table.insert(list, { name = towerName, order = tonumber(towerConfig.order) or 0 })
        end
    end
    table.sort(list, function(a, b)
        if a.order == b.order then return a.name < b.name end
        return a.order < b.order
    end)
    local towerNames = {}
    for _, entry in ipairs(list) do
        table.insert(towerNames, entry.name)
    end
    if #towerNames == 0 then return end
    TB_Tabs.Autofarm2.T1:AddDropdown("TowerSelection", {
        Text = "Tower",
        Values = towerNames,
        Default = towerNames[1],
    })
end
BuildTowerDropdown()
if not Options.TowerSelection then
    task.spawn(function()
        for _ = 1, 90 do
            if Options.TowerSelection then return end
            task.wait(0.5)
            BuildTowerDropdown()
            if Options.TowerSelection then return end
        end
    end)
end
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
Toggles.AutoServerhop:OnChanged(function(state)
    Thread("AutoServerhop", function()
        local lastHop = tick()
        while Toggles.AutoServerhop.Value do
            task.wait(5)
            if not Toggles.AutoServerhop.Value then break end
            if (tick() - lastHop) >= (Options.AutoHopMins.Value * 60) then
                Serverhop()
                break
            end
        end
    end, state)
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
local function Func_AutoRoll()
    while Toggles.AutoRoll.Value do
        local ok, loopErr = pcall(function()
            Remotes.RollDice:InvokeServer()
        end)
        if not ok then
            notyuri("AutoRoll error:", tostring(loopErr))
        end
        task.wait()
    end
end
Toggles.AutoRoll:OnChanged(function(state)
    Thread("AnimeDice.AutoRoll", Func_AutoRoll, state)
end)
Toggles.AutoDice:OnChanged(function(state)
    Thread("AnimeDice.AutoDice", Func_AutoDice, state)
end)
Toggles.AutoCollect:OnChanged(function(state)
    Thread("AnimeDice.AutoCollect", Func_AutoCollect, state)
end)
Toggles.AutoSell:OnChanged(function(state)
    Thread("AnimeDice.AutoSell", Func_AutoSell, state)
end)
Toggles.AutoLevelUp:OnChanged(function(state)
    Thread("AnimeDice.AutoLevelUp", Func_AutoLevelUp, state)
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AnimeDice.AutoUpgrade", Func_AutoUpgrade, state)
end)
Toggles.AutoEquip:OnChanged(function(state)
    Thread("AnimeDice.AutoEquip", Func_AutoEquip, state)
end)
Toggles.AutoRebirth:OnChanged(function(state)
    Thread("AnimeDice.AutoRebirth", Func_AutoRebirth, state)
end)
Toggles.AutoClaims:OnChanged(function(state)
    Thread("AnimeDice.AutoClaims", Func_AutoClaims, state)
end)
Toggles.AutoBoosts:OnChanged(function(state)
    Thread("AnimeDice.AutoBoosts", Func_AutoBoosts, state)
end)
Toggles.AutoSpins:OnChanged(function(state)
    Thread("AnimeDice.AutoSpins", Func_AutoSpins, state)
end)
Toggles.AutoTower:OnChanged(function(state)
    Thread("AnimeDice.AutoTower", Func_AutoTower, state)
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
SaveManager:SetFolder("Yuri/AnimeDice")
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
