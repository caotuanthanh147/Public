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
local ModulesFolder = RS:FindFirstChild("Modules")
local RemotesFolder = RS:FindFirstChild("Remotes")
for _, remoteName in ipairs({
    "SellFishEvent", "BuyRodEvent", "EquipRodEvent", "MergeEvent", "BottleClickEvent",
    "BottleTierRequest", "FisherRankRequest", "UsePotionRequest", "UpgradeRequest",
    "UpgradeTreeRequest", "TokenUpgradeRequest", "SPUpgradeRequest", "PurchaseSkill",
    "UpgradeSwordRequest", "ChangeStageRequest", "FireClick", "ForgeDepositRequest",
    "AltarRoll", "DepositCore", "SacrificeRequest", "ImpactRequest", "SandRequest",
    "BalloonRequest", "PlasmaRequest", "StarRequest", "TierRequest",
    "ElementalRankRequest", "SpaceRankRequest", "ConvertEvent", "AscendEvent",
    "BuyPlanet", "BuyRarityBoost", "LaunchRocket", "ChallengeStart", "ChallengeState",
    "RollRuneEvent", "TitleRollRequest", "HudClick", "RebornRequest",
}) do
    Remotes[remoteName] = GetSafeRemote(RemotesFolder, remoteName)
end
local function LoadModule(parent, name, onLoaded)
    local mod = GetSafeModule(parent, name)
    if mod then
        Modules[name] = mod
        if onLoaded then
            task.spawn(onLoaded, mod)
        end
        return mod
    end
    LoadModuleAsync(parent, name, function(loaded)
        Modules[name] = loaded
        if onLoaded then
            pcall(onLoaded, loaded)
        end
    end)
    return nil
end
local Asc = {}
function Asc.Stat(folder, stat)
    local omega = Modules.OmegaNum
    if not omega then return nil end
    local f = Plr:FindFirstChild(folder)
    local s = f and f:FindFirstChild(stat)
    if not s then return nil end
    local v = tostring(s.Value)
    local ok, res = pcall(omega.toOmega, v)
    if ok then return res end
    return nil
end
function Asc.Num(folder, stat)
    local f = Plr:FindFirstChild(folder)
    local s = f and f:FindFirstChild(stat)
    if not s then return nil end
    return tonumber(s.Value) or 0
end
function Asc.Meets(v, amount)
    local omega = Modules.OmegaNum
    if not v or not omega then return false end
    local ok, res = pcall(function()
        return omega.meeq(v, omega.toOmega(amount))
    end)
    return ok and res == true or false
end
function Asc.Gt(v, amount)
    local omega = Modules.OmegaNum
    if not v or not omega then return false end
    local ok, res = pcall(function()
        return omega.cmp(v, omega.toOmega(amount)) > 0
    end)
    return ok and res == true or false
end
function Asc.Short(v)
    local omega = Modules.OmegaNum
    if not omega then return tostring(v) end
    local ok, res = pcall(function()
        return omega.short(omega.toOmega(v))
    end)
    if ok and type(res) == "string" then return res end
    return tostring(v)
end
function Asc.Send(name, ...)
    return FireRemote(Remotes[name], ...)
end
function Asc.Invoke(name, ...)
    local remote = Remotes[name]
    if not remote then return nil end
    local args = {...}
    local ok, res = pcall(function()
        return remote:InvokeServer(unpack(args))
    end)
    if not ok then
        notyuri("Invoke error:", name, tostring(res))
        return nil
    end
    return res
end
function Asc.RankMeets(config, rankNum)
    if not config or type(config.canRank) ~= "function" then return false end
    local ok, res = pcall(config.canRank, Plr, rankNum)
    return ok and res == true or false
end
function Asc.SortUpgradeId(a, b)
    return (tonumber(string.match(a, "%d+")) or 0) < (tonumber(string.match(b, "%d+")) or 0)
end
function Asc.Loop(name, step, delay)
    return function()
        while true do
            if Library.Unloaded then return end
            local ok, err = pcall(step)
            if not ok then
                Library:Notify("Error in [" .. name .. "]: " .. tostring(err), 10)
                warn("Error in [" .. name .. "]: " .. tostring(err))
            end
            local d = type(delay) == "function" and delay() or delay
            task.wait(d)
        end
    end
end
function Asc.StepAutoFish()
    if not Toggles.AutoFish.Value then return end
    local fishing = workspace:FindFirstChild("Fishing")
    local hb = fishing and fishing:FindFirstChild("Hitbox")
    if not hb or not hb:IsA("BasePart") then return end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local rel = hb.CFrame:PointToObjectSpace(hrp.Position)
    local inside = false
    if hb:IsA("Part") and hb.Shape == Enum.PartType.Cylinder then
        local r = math.min(hb.Size.Y, hb.Size.Z) / 2
        inside = math.abs(rel.X) <= hb.Size.X / 2 and rel.Y * rel.Y + rel.Z * rel.Z <= r * r
    else
        local h = hb.Size / 2
        inside = math.abs(rel.X) <= h.X and math.abs(rel.Y) <= h.Y and math.abs(rel.Z) <= h.Z
    end
    if not inside then
        hrp.CFrame = hb.CFrame
    end
end
function Asc.StepAutoSell()
    if not Toggles.AutoSell.Value then return end
    local fishing = workspace:FindFirstChild("Fishing")
    local sell = fishing and fishing:FindFirstChild("Sell")
    local touch = sell and sell:FindFirstChild("Touch")
    if touch and touch:IsA("BasePart") then
        TPTo(touch)
        task.wait(0.1)
    end
    Asc.Send("SellFishEvent", "all")
end
function Asc.StepAutoBuyRod()
    if not Toggles.AutoBuyRod.Value then return end
    local rodsData = Modules.RodsData
    if not rodsData or not rodsData.Order then return end
    local Rods = Plr:FindFirstChild("Rods")
    local coins = Asc.Stat("StatsFolder", "Coins")
    local bestName, bestScore = nil, 0
    for _, name in ipairs(rodsData.Order) do
        local cfg = rodsData.Rods and rodsData.Rods[name]
        if cfg then
            local owned = Rods and Rods:FindFirstChild(name)
            if owned and owned.Value == true then
                local score = (cfg.LuckMult or 1) * (cfg.SpeedMult or 1) * (cfg.BulkAdd or 1)
                if score > bestScore then
                    bestScore = score
                    bestName = name
                end
            elseif type(rodsData.IsCoinBuyable) == "function" and rodsData.IsCoinBuyable(name) then
                if Asc.Meets(coins, cfg.Cost) then
                    Asc.Send("BuyRodEvent", name)
                    return
                end
            end
        end
    end
    if Rods and bestName then
        local equipped = Rods:FindFirstChild("Equiped")
        if equipped and equipped.Value ~= bestName then
            Asc.Send("EquipRodEvent", bestName)
        end
    end
end
function Asc.StepBottles()
    if Toggles.AutoBottleClick.Value then
        Asc.Send("BottleClickEvent")
    end
    if Toggles.AutoBottleTier.Value then
        local data = Modules.BottleTierData
        if data and data.Tiers then
            local tier = (Asc.Num("Resets", "BottleTier") or 0) + 1
            local nextTier = data.Tiers[tier]
            if nextTier then
                local bottles = Asc.Stat("StatsFolder", nextTier.CostStat or "Bottles")
                if Asc.Meets(bottles, nextTier.Cost) then
                    Asc.Invoke("BottleTierRequest")
                end
            end
        end
    end
end
function Asc.StepAutoMerge()
    if not Toggles.AutoMerge.Value then return end
    Asc.Send("MergeEvent")
end
function Asc.StepAutoCactus()
    if not Toggles.AutoCactus.Value then return end
    local Collect = workspace:FindFirstChild("Collect")
    if not Collect then return end
    local handled = 0
    for _, v in ipairs(Collect:GetChildren()) do
        if v.Name == "Cactus" and v:GetAttribute("Owner") == Plr.UserId then
            local main = v:FindFirstChild("MainPart")
            if main and main:IsA("BasePart") then
                TPTo(main, Vector3.new(0, 0, 3))
                task.wait(0.25)
                handled = handled + 1
                if handled >= 8 then break end
            end
        end
    end
end
function Asc.StepAutoGem()
    if not Toggles.AutoGem.Value then return end
    local MyGems = workspace:FindFirstChild("MyGems")
    if not MyGems then return end
    for _, gem in ipairs(MyGems:GetChildren()) do
        local part = gem:FindFirstChild("Gem")
        if not part then
            if gem:IsA("BasePart") then
                part = gem
            elseif gem:IsA("Model") then
                part = gem.PrimaryPart or gem:FindFirstChildWhichIsA("BasePart")
            end
        end
        if part and part:IsA("BasePart") then
            FireTI(part)
        end
    end
end
function Asc.StepAutoRune()
    if not Toggles.AutoRuneRoll.Value then return end
    local pool = Options.RunePool and Options.RunePool.Value
    if not pool or pool == "" then return end
    Asc.Send("RollRuneEvent", pool)
end
function Asc.StepAutoTitle()
    if not Toggles.AutoTitleRoll.Value then return end
    local tiersData = Modules.TitlesData
    if not tiersData or not tiersData.TierOrder then return end
    local titlesFolder = Plr:FindFirstChild("Titles")
    local keysFolder = titlesFolder and titlesFolder:FindFirstChild("Keys")
    if not keysFolder then return end
    for _, tier in ipairs(tiersData.TierOrder) do
        local keyStat = keysFolder:FindFirstChild(tier)
        local count = keyStat and tonumber(keyStat.Value) or 0
        if count >= 1 then
            Asc.Invoke("TitleRollRequest", tier)
        end
    end
end
function Asc.StepAutoHudClick()
    if not Toggles.AutoHudClick.Value then return end
    Asc.Send("HudClick")
end
function Asc.StepAutoSnow()
    if not Toggles.AutoSnow.Value then return end
    local snow = workspace:FindFirstChild("Snow")
    local button = snow and snow:FindFirstChild("SnowButton")
    local hb = button and button:FindFirstChild("Hitbox")
    if not hb or not hb:IsA("BasePart") then return end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hb.Position
    local dx = hrp.Position.X - pos.X
    local dz = hrp.Position.Z - pos.Z
    local dist = math.sqrt(dx * dx + dz * dz)
    local radius = math.max(hb.Size.X, hb.Size.Z) / 2
    if dist > radius or math.abs(hrp.Position.Y - pos.Y) > 8 then
        hrp.CFrame = hb.CFrame
    end
end
function Asc.StepAutoFireClick()
    if not Toggles.AutoFireClick.Value then return end
    local current = Asc.Num("FireClicker", "CurrentAmount") or 0
    local max = Asc.Num("FireClicker", "MaxCapacity") or 5
    if current < max then
        Asc.Send("FireClick")
    end
end
function Asc.StepAutoMobStage()
    if not Toggles.AutoMobStage.Value then return end
    local current = Asc.Num("MobStats", "CurrentStage") or 0
    local max = Asc.Num("MobStats", "MaxStage") or 0
    local kills = Asc.Num("MobStats", "nextlevel") or 0
    if kills >= 10 and current < max then
        Asc.Send("ChangeStageRequest", 1)
    end
end
function Asc.StepAutoAscend()
    if not Toggles.AutoAscend.Value then return end
    local mod = Modules.AscensionModule
    if not mod or type(mod.getCost) ~= "function" then return end
    local current = Asc.Num("AscensionStats", "Ascension") or 0
    local ok, cost = pcall(mod.getCost, current)
    if not ok or not cost then return end
    local points = Asc.Stat("StatsFolder", "Points")
    if points and Asc.Meets(points, cost) then
        Asc.Send("AscendEvent")
    end
end
function Asc.StepAutoReborn()
    if not Toggles.AutoReborn.Value then return end
    local cfg = Modules.RebornConfig
    if not cfg or not cfg.Cost or not cfg.CostStat then return end
    local stat = Asc.Stat("StatsFolder", cfg.CostStat)
    if stat and Asc.Meets(stat, cfg.Cost) then
        Asc.Invoke("RebornRequest")
    end
end
function Asc.StepAutoConvert()
    if not Toggles.AutoConvertVoltage.Value then return end
    local points = Asc.Stat("StatsFolder", "Points")
    local flux = Asc.Stat("StatsFolder", "Flux")
    if Asc.Meets(points, "5e12") and Asc.Meets(flux, "100000") then
        Asc.Send("ConvertEvent")
    end
end
function Asc.StepAutoImpact()
    if not Toggles.AutoImpact.Value then return end
    if (Asc.Num("Resets", "Impact") or 0) >= 1 then return end
    local voltage = Asc.Stat("StatsFolder", "Voltage")
    local points = Asc.Stat("StatsFolder", "Points")
    if Asc.Meets(voltage, "5e12") and Asc.Meets(points, "1e34") then
        Asc.Invoke("ImpactRequest")
    end
end
function Asc.StepAutoSacrifice()
    if not Toggles.AutoSacrifice.Value then return end
    if (Asc.Num("AscensionStats", "Ascension") or 0) >= 100 then
        Asc.Invoke("SacrificeRequest")
    end
end
function Asc.StepFisherRank()
    if not Toggles.AutoFisherRank.Value then return end
    local cfg = Modules.FisherRankConfig
    if not cfg or not cfg.Ranks then return end
    local nextRank = (Asc.Num("Resets", "FisherRank") or 0) + 1
    if nextRank > #cfg.Ranks then return end
    if Asc.RankMeets(cfg, nextRank) then
        Asc.Invoke("FisherRankRequest", nextRank)
    end
end
function Asc.StepElementalRank()
    if not Toggles.AutoElementalRank.Value then return end
    local cfg = Modules.ElementalRankConfig
    if not cfg or not cfg.Ranks then return end
    local nextRank = (Asc.Num("Resets", "ElementalRank") or 0) + 1
    if nextRank > #cfg.Ranks then return end
    if Asc.RankMeets(cfg, nextRank) then
        Asc.Invoke("ElementalRankRequest", nextRank)
    end
end
function Asc.StepSpaceRank()
    if not Toggles.AutoSpaceRank.Value then return end
    local cfg = Modules.SpaceRankConfig
    if not cfg or not cfg.Ranks then return end
    local nextRank = (Asc.Num("Resets", "SpaceRank") or 0) + 1
    if nextRank > #cfg.Ranks then return end
    if Asc.RankMeets(cfg, nextRank) then
        Asc.Invoke("SpaceRankRequest", nextRank)
    end
end
function Asc.StepAutoSand()
    if not Toggles.AutoSand.Value then return end
    local cactus = Asc.Stat("StatsFolder", "Cactus")
    if Asc.Meets(cactus, "1e6") then
        Asc.Invoke("SandRequest")
    end
end
function Asc.StepAutoBalloon()
    if not Toggles.AutoBalloon.Value then return end
    local click = Asc.Stat("EventStatsFolder", "Click")
    if Asc.Meets(click, "1e27") then
        Asc.Invoke("BalloonRequest")
    end
end
function Asc.StepAutoPlasma()
    if not Toggles.AutoPlasma.Value then return end
    if (Asc.Num("UpgradeTree", "Upgrade15") or 0) < 1 then return end
    local particles = Asc.Stat("StatsFolder", "Particles")
    if Asc.Meets(particles, "50000") then
        Asc.Invoke("PlasmaRequest")
    end
end
function Asc.StepAutoStar()
    if not Toggles.AutoStar.Value then return end
    local rarity = Asc.Stat("RarityStats", "Rarity")
    if Asc.Meets(rarity, "131") then
        Asc.Invoke("StarRequest")
    end
end
function Asc.StepAutoTier()
    if not Toggles.AutoTier.Value then return end
    local data = Modules.EventTierData
    if not data or not data.Tiers then return end
    local nextTier = data.Tiers[(Asc.Num("Resets", "EventTier") or 0) + 1]
    if not nextTier then return end
    local v = Asc.Stat("EventStatsFolder", nextTier.CostStat)
    if Asc.Meets(v, nextTier.Cost) then
        Asc.Invoke("TierRequest")
    end
end
function Asc.StepAutoChallenge()
    if not Toggles.AutoChallenge.Value then return end
    if Shared.ChallengeActive or (Shared.ChallengeCooldown or 0) > 0 then return end
    Asc.Invoke("ChallengeStart")
end
function Asc.StepAutoRocket()
    if not Toggles.AutoLaunchRocket.Value then return end
    local fuel = Asc.Stat("StatsFolder", "RocketFuel")
    if Asc.Gt(fuel, 0) then
        Asc.Send("LaunchRocket")
    end
end
function Asc.StepAutoAltar()
    if not Toggles.AutoAltarRoll.Value then return end
    Asc.Invoke("AltarRoll")
end
function Asc.StepWinterCore()
    if not (Toggles.AutoWinterCoreStats.Value or Toggles.AutoWinterCoreRunes.Value) then return end
    local xp = Asc.Stat("Altar", "CurrentXp")
    if not Asc.Gt(xp, 0) then return end
    if Toggles.AutoWinterCoreStats.Value then
        Asc.Invoke("DepositCore", "Stats")
    end
    if Toggles.AutoWinterCoreRunes.Value then
        Asc.Invoke("DepositCore", "Runes")
    end
end
function Asc.StepAutoForge()
    if not Toggles.AutoForge.Value then return end
    local fire = Asc.Stat("StatsFolder", "Fire")
    if Asc.Meets(fire, "1e18") then
        local omega = Modules.OmegaNum
        if omega and fire then
            local ok, str = pcall(function()
                return omega.toString(fire)
            end)
            if ok and str then
                Asc.Invoke("ForgeDepositRequest", str)
            end
        end
    end
end
function Asc.StepAutoPlanet()
    if not Toggles.AutoBuyPlanet.Value then return end
    local data = Modules.PlanetsData
    if not data or not data.Order then return end
    local selection = Asc.PlanetSelection and Asc.PlanetSelection() or {}
    if not next(selection) then return end
    local rarity = Asc.Stat("RarityStats", "Rarity")
    local Planets = Plr:FindFirstChild("Planets")
    for name in pairs(selection) do
        local cfg = data.Planets and data.Planets[name]
        if cfg then
            local ownedInst = Planets and Planets:FindFirstChild(name)
            local owned = ownedInst and tonumber(ownedInst.Value) or 0
            if type(data.GetCost) == "function" then
                local ok, cost = pcall(data.GetCost, name, owned)
                if ok and cost and Asc.Meets(rarity, cost) then
                    Asc.Send("BuyPlanet", name)
                end
            end
        end
    end
end
function Asc.StepAutoRarityBoost()
    if not Toggles.AutoRarityBoost.Value then return end
    local data = Modules.RarityBoostsConfig
    if not data or not data.Order then return end
    local selection = Asc.BoostSelection and Asc.BoostSelection() or {}
    if not next(selection) then return end
    local tickets = Asc.Num("Shop", "Tickets") or 0
    for key in pairs(selection) do
        local level = Asc.Num("RarityBoosts", key) or 0
        local maxL = 0
        if type(data.getMaxLevel) == "function" then
            local okM, res = pcall(data.getMaxLevel, key)
            if okM then maxL = res or 0 end
        end
        if level < maxL and type(data.getCost) == "function" then
            local okC, cost = pcall(data.getCost, key, level)
            if okC and cost and tickets >= cost then
                Asc.Send("BuyRarityBoost", key)
            end
        end
    end
end
function Asc.StepAutoUpgrade()
    if not Toggles.AutoUpgrade.Value then return end
    local cfg = Modules.UpgradeConfig
    if not cfg or not cfg.Upgrades then return end
    local asc = Asc.Num("AscensionStats", "Ascension") or 0
    local levels = Plr:FindFirstChild("Upgrades")
    for id, info in pairs(cfg.Upgrades) do
        local lvlInst = levels and levels:FindFirstChild(id)
        local lvl = lvlInst and tonumber(lvlInst.Value) or 0
        local ok, maxL = pcall(cfg.GetMaxLevel, id, asc)
        if ok and maxL and lvl < maxL then
            local ok2, price = pcall(cfg.GetPriceAtLevel, id, lvl)
            if ok2 and price then
                local stat = Asc.Stat(info.CostFolder, info.CostStat)
                if Asc.Meets(stat, price) then
                    Asc.Invoke("UpgradeRequest", id, true)
                end
            end
        end
    end
end
function Asc.StepAutoUpgradeTree()
    if not Toggles.AutoUpgradeTree.Value then return end
    local cfg = Modules.UpgradeTreeConfig
    if not cfg or not cfg.Upgrades then return end
    local tree = Plr:FindFirstChild("UpgradeTree")
    for id, info in pairs(cfg.Upgrades) do
        local okU, unlocked = pcall(cfg.IsUnlocked, id, tree, Plr)
        if okU and unlocked then
            local lvlInst = tree and tree:FindFirstChild(id)
            local lvl = lvlInst and tonumber(lvlInst.Value) or 0
            if lvl < (info.MaxLevel or 1) then
                local ok2, price = pcall(cfg.GetPriceAtLevel, id, lvl)
                if ok2 and price then
                    local stat = Asc.Stat(info.CostFolder, info.CostStat)
                    if Asc.Meets(stat, price) then
                        Asc.Invoke("UpgradeTreeRequest", id, false)
                    end
                end
            end
        end
    end
end
function Asc.StepAutoSkillTree()
    if not Toggles.AutoSkillTree.Value then return end
    local data = Modules.SkillTreeData
    if not data or not data.Nodes then return end
    local levels = Plr:FindFirstChild("SkillTree")
    for _, node in ipairs(data.Nodes) do
        local lvlInst = levels and levels:FindFirstChild(node.id)
        local lvl = lvlInst and tonumber(lvlInst.Value) or 0
        local prereqOk = true
        if node.prerequisite then
            local pInst = levels and levels:FindFirstChild(node.prerequisite)
            prereqOk = pInst and (tonumber(pInst.Value) or 0) >= 1 or false
        end
        if lvl < (node.maxLevel or 10) and prereqOk then
            Asc.Send("PurchaseSkill", node.id)
        end
    end
end
function Asc.StepAutoToken()
    if not Toggles.AutoTokenUpgrade.Value then return end
    local cfg = Modules.TokenUpgradeConfig
    if not cfg or not cfg.Upgrades then return end
    if (Asc.Num("UpgradeTree", "Upgrade42") or 0) < 1 then return end
    local selection = Asc.TokenSelection and Asc.TokenSelection() or {}
    if not next(selection) then return end
    local tokens = Asc.Stat("StatsFolder", "Tokens")
    for id in pairs(selection) do
        local info = cfg.Upgrades[id]
        if info then
            local lvl = Asc.Num("UpgradesToken", id) or 0
            if lvl < (info.MaxLevel or 0) then
                local ok, price = pcall(cfg.GetPriceAtLevel, id, lvl)
                if ok and price and Asc.Meets(tokens, price) then
                    Asc.Invoke("TokenUpgradeRequest", id)
                    break
                end
            end
        end
    end
end
function Asc.StepAutoSP()
    if not Toggles.AutoSPUpgrade.Value then return end
    local cfg = Modules.SPUpgradeConfig
    if not cfg or not cfg.Upgrades then return end
    local selection = Asc.SPSelection and Asc.SPSelection() or {}
    if not next(selection) then return end
    local sp = Asc.Stat("StatsFolder", "SP")
    for id in pairs(selection) do
        local info = cfg.Upgrades[id]
        if info then
            local lvl = Asc.Num("UpgradesSP", id) or 0
            local okM, maxL = pcall(cfg.GetMaxLevel, id)
            if okM and maxL and lvl < maxL then
                local ok, price = pcall(cfg.GetPriceAtLevel, id, lvl)
                if ok and price and Asc.Meets(sp, price) then
                    Asc.Invoke("SPUpgradeRequest", id)
                    break
                end
            end
        end
    end
end
function Asc.StepAutoSword()
    if not Toggles.AutoSword.Value then return end
    local cfg = Modules.SwordConfig
    if not cfg or not cfg.Swords then return end
    local nextSword = cfg.Swords[(Asc.Num("MobStats", "Sword") or 0) + 1]
    if not nextSword then return end
    local reqOk = true
    if nextSword.RequiredUpgrade then
        local tree = Plr:FindFirstChild("UpgradeTree")
        local node = tree and tree:FindFirstChild(nextSword.RequiredUpgrade)
        reqOk = node and (tonumber(node.Value) or 0) >= 1 or false
    end
    if not reqOk then return end
    local shards = Asc.Stat("StatsFolder", nextSword.CostStat or "Shards")
    if Asc.Meets(shards, nextSword.Cost) then
        Asc.Send("UpgradeSwordRequest")
    end
end
function Asc.StepAutoPotion()
    if not Toggles.AutoPotion.Value then return end
    local selection = Asc.PotionSelection and Asc.PotionSelection() or {}
    if not next(selection) then return end
    for key in pairs(selection) do
        local count = Asc.Num("Shop", key) or 0
        if count >= 1 then
            Asc.Invoke("UsePotionRequest", key)
        end
    end
end
function Asc.StepAutoPulse()
    if not Toggles.AutoPulse.Value then return end
    local Pulse = workspace:FindFirstChild("Pulse")
    if not Pulse then return end
    Asc.PulseIndex = (Asc.PulseIndex or 0) + 1
    if Asc.PulseIndex > 5 then
        Asc.PulseIndex = 1
    end
    local btn = Pulse:FindFirstChild("PulseButton" .. Asc.PulseIndex)
    if btn and btn:IsA("BasePart") then
        TPTo(btn)
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
TB_Tabs.Autofarm.T1:AddToggle("AutoFish", { Text = "Auto Fish", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell Fish", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyRod", { Text = "Auto Buy Rod", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBottleClick", { Text = "Auto Bottle Click", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBottleTier", { Text = "Auto Bottle Tier", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMerge", { Text = "Auto Merge", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCactus", { Text = "Auto Collect Cactus", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoGem", { Text = "Auto Collect Gems", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSnow", { Text = "Auto Snow", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRuneRoll", { Text = "Auto Rune Roll", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTitleRoll", { Text = "Auto Title Roll", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoHudClick", { Text = "Auto HUD Click", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoFireClick", { Text = "Auto Fire Click", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMobStage", { Text = "Auto Mob Stage Up", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoForge", { Text = "Auto Forge Deposit", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAscend", { Text = "Auto Ascend", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReborn", { Text = "Auto Reborn", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoConvertVoltage", { Text = "Auto Convert Voltage", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoImpact", { Text = "Auto Impact", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSacrifice", { Text = "Auto Sacrifice", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoFisherRank", { Text = "Auto Fisher Rank", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoElementalRank", { Text = "Auto Elemental Rank", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSpaceRank", { Text = "Auto Space Rank", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSand", { Text = "Auto Sand", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBalloon", { Text = "Auto Balloon", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlasma", { Text = "Auto Plasma", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoStar", { Text = "Auto Star", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTier", { Text = "Auto Event Tier", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoChallenge", { Text = "Auto Challenge", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoLaunchRocket", { Text = "Auto Launch Rocket", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAltarRoll", { Text = "Auto Altar Roll", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoWinterCoreStats", { Text = "Auto Winter Core", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoWinterCoreRunes", { Text = "Auto Winter Core", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyPlanet", { Text = "Auto Buy Planets", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRarityBoost", { Text = "Auto Rarity Boosts", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrades", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradeTree", { Text = "Auto Upgrade Tree", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSkillTree", { Text = "Auto Skill Tree", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTokenUpgrade", { Text = "Auto Token Upgrades", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSPUpgrade", { Text = "Auto SP Upgrades", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPotion", { Text = "Auto Use Potions", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSword", { Text = "Auto Sword Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPulse", { Text = "Auto Pulse", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("RunePool", { Text = "Rune Pool", Values = {}, Default = "" })
TB_Tabs.Autofarm2.T1:AddInput("SellEvery", { Text = "Sell Every", Default = "30" })
local boostLabelMap = {}
local tokenLabelMap = {}
local getPlanetSelection, refreshPlanets, planetValues = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PlanetList", { Text = "Planets", Values = {} })
local getBoostSelection, refreshBoosts, boostValues = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "BoostList", { Text = "Rarity Boosts", Values = {}, label = boostLabelMap })
local getTokenSelection, refreshTokens, tokenValues = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "TokenList", { Text = "Token Upgrades", Values = {}, label = tokenLabelMap })
local getSPSelection, refreshSP, spValues = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "SPList", { Text = "SP Upgrades", Values = {} })
local getPotionSelection, refreshPotions, potionValues = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PotionList", { Text = "Potions", Values = {} })
Asc.PlanetSelection = getPlanetSelection
Asc.BoostSelection = getBoostSelection
Asc.TokenSelection = getTokenSelection
Asc.SPSelection = getSPSelection
Asc.PotionSelection = getPotionSelection
LoadModule(ModulesFolder, "OmegaNum")
LoadModule(ModulesFolder, "UpgradeConfig")
LoadModule(ModulesFolder, "UpgradeTreeConfig")
LoadModule(ModulesFolder, "TokenUpgradeConfig", function()
    local cfg = Modules.TokenUpgradeConfig
    if cfg and cfg.Upgrades then
        for id, info in pairs(cfg.Upgrades) do
            local label = info.DisplayName or id
            table.insert(tokenValues, label)
            tokenLabelMap[label] = id
        end
        table.sort(tokenValues)
        refreshTokens()
    end
end)
LoadModule(ModulesFolder, "SPUpgradeConfig", function()
    local cfg = Modules.SPUpgradeConfig
    if cfg and cfg.Upgrades then
        for id in pairs(cfg.Upgrades) do
            table.insert(spValues, id)
        end
        table.sort(spValues, Asc.SortUpgradeId)
        refreshSP()
    end
end)
LoadModule(RS, "SkillTreeData")
LoadModule(ModulesFolder, "TitlesData")
LoadModule(ModulesFolder, "RodsData")
LoadModule(ModulesFolder, "BottleTierData")
LoadModule(ModulesFolder, "FisherRankConfig")
LoadModule(ModulesFolder, "ElementalRankConfig")
LoadModule(ModulesFolder, "SpaceRankConfig")
LoadModule(ModulesFolder, "EventTierData")
LoadModule(ModulesFolder, "AscensionModule")
LoadModule(ModulesFolder, "RebornConfig")
LoadModule(ModulesFolder, "SwordConfig")
LoadModule(ModulesFolder, "PlanetsData", function()
    local data = Modules.PlanetsData
    if data and data.Order then
        for _, name in ipairs(data.Order) do
            table.insert(planetValues, name)
        end
        refreshPlanets()
    end
end)
LoadModule(ModulesFolder, "RarityBoostsConfig", function()
    local data = Modules.RarityBoostsConfig
    if data and data.Order then
        for _, key in ipairs(data.Order) do
            local info = data.Boosts and data.Boosts[key]
            table.insert(boostValues, (info and info.DisplayName) or key)
            boostLabelMap[(info and info.DisplayName) or key] = key
        end
        refreshBoosts()
    end
end)
if Remotes.ChallengeState then
    Connections.ChallengeState = Remotes.ChallengeState.OnClientEvent:Connect(function(state)
        if type(state) == "table" then
            Shared.ChallengeActive = state.active == true
            Shared.ChallengeCooldown = state.cooldown or 0
        end
    end)
end
task.spawn(function()
    local waited = 0
    while waited < 30 and not Library.Unloaded do
        local Runes = workspace:FindFirstChild("Runes")
        if Runes then
            local list = {}
            for _, v in ipairs(Runes:GetChildren()) do
                if v:FindFirstChild("Hitbox") then
                    table.insert(list, v.Name)
                end
            end
            if #list > 0 and Options.RunePool then
                Options.RunePool:SetValues(list)
                if not Options.RunePool.Value or Options.RunePool.Value == "" then
                    Options.RunePool:SetValue(list[1])
                end
            end
            break
        end
        waited = waited + 1
        task.wait(1)
    end
end)
task.spawn(function()
    local waited = 0
    while waited < 30 and not Library.Unloaded do
        local Shop = Plr:FindFirstChild("Shop")
        if Shop then
            local found = false
            for _, child in ipairs(Shop:GetChildren()) do
                if string.sub(child.Name, -6) == "Potion" then
                    table.insert(potionValues, child.Name)
                    found = true
                end
            end
            if found then
                refreshPotions()
            end
            break
        end
        waited = waited + 1
        task.wait(1)
    end
end)
task.spawn(function()
    while not Library.Unloaded do
        pcall(function()
            local coins = Asc.Short(Asc.Stat("StatsFolder", "Coins") or 0)
            local bottles = Asc.Short(Asc.Stat("StatsFolder", "Bottles") or 0)
            local fishbones = Asc.Short(Asc.Stat("StatsFolder", "Fishbones") or 0)
            local caught = Asc.Short(Asc.Stat("FishingStats", "Caught") or 0)
            local asc = tostring(Asc.Num("AscensionStats", "Ascension") or 0)
            local fisherRank = tostring(Asc.Num("Resets", "FisherRank") or 0)
            local eventTier = tostring(Asc.Num("Resets", "EventTier") or 0)
            local Rods = Plr:FindFirstChild("Rods")
            local equipped = Rods and Rods:FindFirstChild("Equiped")
            local rod = equipped and equipped.Value or "-"
            if Library.Labels.StatCoins then Library.Labels.StatCoins:SetText("Coins: " .. coins) end
            if Library.Labels.StatBottles then Library.Labels.StatBottles:SetText("Bottles: " .. bottles) end
            if Library.Labels.StatFishbones then Library.Labels.StatFishbones:SetText("Fishbones: " .. fishbones) end
            if Library.Labels.StatCaught then Library.Labels.StatCaught:SetText("Fish Caught: " .. caught) end
            if Library.Labels.StatAscension then Library.Labels.StatAscension:SetText("Ascension: " .. asc) end
            if Library.Labels.StatFisherRank then Library.Labels.StatFisherRank:SetText("Fisher Rank: " .. fisherRank) end
            if Library.Labels.StatEventTier then Library.Labels.StatEventTier:SetText("Event Tier: " .. eventTier) end
            if Library.Labels.StatRod then Library.Labels.StatRod:SetText("Rod: " .. tostring(rod)) end
        end)
        task.wait(1)
    end
end)
Toggles.AutoFish:OnChanged(function(state)
    Thread("Farm.AutoFish", Asc.Loop("AutoFish", Asc.StepAutoFish, 0.5), state)
end)
Toggles.AutoSell:OnChanged(function(state)
    Thread("Farm.AutoSell", Asc.Loop("AutoSell", Asc.StepAutoSell, function()
        return math.max(5, Options.SellEvery and Options.SellEvery.Value or 30)
    end), state)
end)
Toggles.AutoBuyRod:OnChanged(function(state)
    Thread("Farm.AutoBuyRod", Asc.Loop("AutoBuyRod", Asc.StepAutoBuyRod, 2), state)
end)
local function ThreadBottles()
    Thread("Farm.Bottles", Asc.Loop("Bottles", Asc.StepBottles, 0.5),
        Toggles.AutoBottleClick.Value or Toggles.AutoBottleTier.Value)
end
Toggles.AutoBottleClick:OnChanged(ThreadBottles)
Toggles.AutoBottleTier:OnChanged(ThreadBottles)
Toggles.AutoMerge:OnChanged(function(state)
    Thread("Farm.AutoMerge", Asc.Loop("AutoMerge", Asc.StepAutoMerge, 2), state)
end)
Toggles.AutoCactus:OnChanged(function(state)
    Thread("Farm.AutoCactus", Asc.Loop("AutoCactus", Asc.StepAutoCactus, 1), state)
end)
Toggles.AutoGem:OnChanged(function(state)
    Thread("Farm.AutoGem", Asc.Loop("AutoGem", Asc.StepAutoGem, 1), state)
end)
Toggles.AutoSnow:OnChanged(function(state)
    Thread("Farm.AutoSnow", Asc.Loop("AutoSnow", Asc.StepAutoSnow, 0.5), state)
end)
Toggles.AutoRuneRoll:OnChanged(function(state)
    Thread("Farm.AutoRuneRoll", Asc.Loop("AutoRuneRoll", Asc.StepAutoRune, 1), state)
end)
Toggles.AutoTitleRoll:OnChanged(function(state)
    Thread("Farm.AutoTitleRoll", Asc.Loop("AutoTitleRoll", Asc.StepAutoTitle, 1), state)
end)
Toggles.AutoHudClick:OnChanged(function(state)
    Thread("Farm.AutoHudClick", Asc.Loop("AutoHudClick", Asc.StepAutoHudClick, 0.01), state)
end)
Toggles.AutoFireClick:OnChanged(function(state)
    Thread("Farm.AutoFireClick", Asc.Loop("AutoFireClick", Asc.StepAutoFireClick, 0.25), state)
end)
Toggles.AutoMobStage:OnChanged(function(state)
    Thread("Farm.AutoMobStage", Asc.Loop("AutoMobStage", Asc.StepAutoMobStage, 2), state)
end)
Toggles.AutoForge:OnChanged(function(state)
    Thread("Farm.AutoForge", Asc.Loop("AutoForge", Asc.StepAutoForge, 10), state)
end)
Toggles.AutoAscend:OnChanged(function(state)
    Thread("Prestige.AutoAscend", Asc.Loop("AutoAscend", Asc.StepAutoAscend, 1), state)
end)
Toggles.AutoReborn:OnChanged(function(state)
    Thread("Prestige.AutoReborn", Asc.Loop("AutoReborn", Asc.StepAutoReborn, 1), state)
end)
Toggles.AutoConvertVoltage:OnChanged(function(state)
    Thread("Prestige.AutoConvertVoltage", Asc.Loop("AutoConvertVoltage", Asc.StepAutoConvert, 5), state)
end)
Toggles.AutoImpact:OnChanged(function(state)
    Thread("Prestige.AutoImpact", Asc.Loop("AutoImpact", Asc.StepAutoImpact, 10), state)
end)
Toggles.AutoSacrifice:OnChanged(function(state)
    Thread("Prestige.AutoSacrifice", Asc.Loop("AutoSacrifice", Asc.StepAutoSacrifice, 10), state)
end)
Toggles.AutoFisherRank:OnChanged(function(state)
    Thread("Prestige.AutoFisherRank", Asc.Loop("AutoFisherRank", Asc.StepFisherRank, 2), state)
end)
Toggles.AutoElementalRank:OnChanged(function(state)
    Thread("Prestige.AutoElementalRank", Asc.Loop("AutoElementalRank", Asc.StepElementalRank, 2), state)
end)
Toggles.AutoSpaceRank:OnChanged(function(state)
    Thread("Prestige.AutoSpaceRank", Asc.Loop("AutoSpaceRank", Asc.StepSpaceRank, 2), state)
end)
Toggles.AutoSand:OnChanged(function(state)
    Thread("Converters.AutoSand", Asc.Loop("AutoSand", Asc.StepAutoSand, 10), state)
end)
Toggles.AutoBalloon:OnChanged(function(state)
    Thread("Converters.AutoBalloon", Asc.Loop("AutoBalloon", Asc.StepAutoBalloon, 10), state)
end)
Toggles.AutoPlasma:OnChanged(function(state)
    Thread("Converters.AutoPlasma", Asc.Loop("AutoPlasma", Asc.StepAutoPlasma, 5), state)
end)
Toggles.AutoStar:OnChanged(function(state)
    Thread("Converters.AutoStar", Asc.Loop("AutoStar", Asc.StepAutoStar, 10), state)
end)
Toggles.AutoTier:OnChanged(function(state)
    Thread("Converters.AutoTier", Asc.Loop("AutoTier", Asc.StepAutoTier, 10), state)
end)
Toggles.AutoChallenge:OnChanged(function(state)
    Thread("Converters.AutoChallenge", Asc.Loop("AutoChallenge", Asc.StepAutoChallenge, 15), state)
end)
Toggles.AutoLaunchRocket:OnChanged(function(state)
    Thread("Converters.AutoLaunchRocket", Asc.Loop("AutoLaunchRocket", Asc.StepAutoRocket, 30), state)
end)
Toggles.AutoAltarRoll:OnChanged(function(state)
    Thread("Converters.AutoAltarRoll", Asc.Loop("AutoAltarRoll", Asc.StepAutoAltar, 3), state)
end)
local function ThreadWinterCore()
    Thread("Converters.WinterCore", Asc.Loop("WinterCore", Asc.StepWinterCore, 10),
        Toggles.AutoWinterCoreStats.Value or Toggles.AutoWinterCoreRunes.Value)
end
Toggles.AutoWinterCoreStats:OnChanged(ThreadWinterCore)
Toggles.AutoWinterCoreRunes:OnChanged(ThreadWinterCore)
Toggles.AutoBuyPlanet:OnChanged(function(state)
    Thread("Space.AutoBuyPlanet", Asc.Loop("AutoBuyPlanet", Asc.StepAutoPlanet, 1), state)
end)
Toggles.AutoRarityBoost:OnChanged(function(state)
    Thread("Space.AutoRarityBoost", Asc.Loop("AutoRarityBoost", Asc.StepAutoRarityBoost, 1), state)
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("Ups.AutoUpgrade", Asc.Loop("AutoUpgrade", Asc.StepAutoUpgrade, 1), state)
end)
Toggles.AutoUpgradeTree:OnChanged(function(state)
    Thread("Ups.AutoUpgradeTree", Asc.Loop("AutoUpgradeTree", Asc.StepAutoUpgradeTree, 1), state)
end)
Toggles.AutoSkillTree:OnChanged(function(state)
    Thread("Ups.AutoSkillTree", Asc.Loop("AutoSkillTree", Asc.StepAutoSkillTree, 1), state)
end)
Toggles.AutoTokenUpgrade:OnChanged(function(state)
    Thread("Ups.AutoTokenUpgrade", Asc.Loop("AutoTokenUpgrade", Asc.StepAutoToken, 1), state)
end)
Toggles.AutoSPUpgrade:OnChanged(function(state)
    Thread("Ups.AutoSPUpgrade", Asc.Loop("AutoSPUpgrade", Asc.StepAutoSP, 1), state)
end)
Toggles.AutoPotion:OnChanged(function(state)
    Thread("Ups.AutoPotion", Asc.Loop("AutoPotion", Asc.StepAutoPotion, 1), state)
end)
Toggles.AutoSword:OnChanged(function(state)
    Thread("Misc.AutoSword", Asc.Loop("AutoSword", Asc.StepAutoSword, 1), state)
end)
Toggles.AutoPulse:OnChanged(function(state)
    Thread("Misc.AutoPulse", Asc.Loop("AutoPulse", Asc.StepAutoPulse, 1), state)
end)
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
local antiKickHooked = false
local function RunAntiKick()
    if antiKickHooked or not Support.HookMeta then return end
    antiKickHooked = true
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == Players.LocalPlayer and Toggles.AntiKick.Value then
            return
        end
        return oldNamecall(self, ...)
    end))
end
RunAntiKick()
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
SaveManager:SetFolder("Yuri/AI2")
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
