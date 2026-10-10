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
local CollectionService = Services.CollectionService
local Workspace = Services.Workspace
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
                    local errorPrompt = promptOverlay:FindFirstChild("promptOverlay"):FindFirstChild("ErrorPrompt")
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
    Farm = Window:AddTab("Farm"),
    Golems = Window:AddTab("Golems"),
    Rewards = Window:AddTab("Rewards"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local TB = {
    Farm = {
        Left = {
            Autofarm = Tabs.Farm:AddLeftTabbox(),
        },
        Right = {
            Autofarm = Tabs.Farm:AddRightTabbox(),
        },
    },
}
local TB_Tabs = {
    Autofarm = {
        T1 = TB.Farm.Left.Autofarm:AddTab("Autofarm"),
    },
    Autofarm2 = {
        T1 = TB.Farm.Right.Autofarm:AddTab("Config"),
    },
}
local GB = {
    Golems = {
        Left = { Golem = Tabs.Golems:AddLeftGroupbox("Golem"), Event = Tabs.Golems:AddLeftGroupbox("Event")},
        Right = { Gear = Tabs.Golems:AddRightGroupbox("Gear"), ShopAirship = Tabs.Golems:AddRightGroupbox("Airship") },
    },
    Rewards = {
        Left = { Claims = Tabs.Rewards:AddLeftGroupbox("Auto Claim"), Packs = Tabs.Rewards:AddLeftGroupbox("Packs") },
        Right = { Codes = Tabs.Rewards:AddRightGroupbox("Codes"), Social = Tabs.Rewards:AddRightGroupbox("Extra") },
    },
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
local Get, Send, Func
local GetUpgradeSelection, GetGearSelection, GetBuyPartsSelection, GetApplyGearSelection, GetAssemblePartsSelection
local GetPlaceGolemSelection, GetPickupGolemSelection
local UpgradeLabels, UpgradeLabelToDef = {}, {}
local GearLabels, GearLabelToDef = {}, {}
local PartLabels, PartLabelToId = {}, {}
local GolemLabels = {}
local M = {}
local function RequirePath(parent, ...)
    local cur = parent
    for i = 1, select("#", ...) do
        local name = (select(i, ...))
        cur = cur and cur:WaitForChild(name, 10) or nil
        if not cur then return nil end
    end
    if not cur or not cur:IsA("ModuleScript") then return nil end
    local ok, mod = pcall(require, cur)
    if ok then return mod end
    return nil
end
M.Components = RequirePath(RS, "TS", "components")
M.RemotesMod = RequirePath(RS, "TS", "remotes")
M.Jecs = RequirePath(RS, "rbxts_include", "node_modules", "@rbxts", "jecs", "src", "jecs")
M.UseQuery = RequirePath(RS, "rbxts_include", "node_modules", "@rbxts", "jecs-vide", "src", "use_query")
M.Local = RequirePath(Plr:WaitForChild("PlayerScripts", 10), "TS", "controllers", "local")
M.Zones = RequirePath(RS, "TS", "controllers", "zones")
M.Slots = RequirePath(RS, "TS", "constants", "slots")
M.Upgrades = RequirePath(RS, "TS", "constants", "plot-upgrades")
M.OreZones = RequirePath(RS, "TS", "constants", "ore-zones")
M.Islands = RequirePath(RS, "TS", "constants", "islands")
M.Crystals = RequirePath(RS, "TS", "constants", "crystals")
M.Chargers = RequirePath(RS, "TS", "constants", "chargers")
M.Codes = RequirePath(RS, "TS", "constants", "codes")
M.Playtime = RequirePath(RS, "TS", "constants", "playtime-rewards")
M.Airship = RequirePath(RS, "TS", "constants", "airship")
M.Rarity = RequirePath(RS, "TS", "structs", "rarity")
M.PartReg = RequirePath(RS, "TS", "registries", "part")
M.GolemParts = RequirePath(RS, "TS", "controllers", "golem-parts")
M.GearReg = RequirePath(RS, "TS", "registries", "gear")
M.GearBuffs = RequirePath(RS, "TS", "controllers", "gear-buffs")
M.Time = RequirePath(RS, "TS", "utilities", "time")
Get = {
    World = function()
        if M.UseQuery and M.UseQuery.world then return M.UseQuery.world end
        return nil
    end,
    Replicator = function()
        if Shared.Replicator then return Shared.Replicator end
        local world = Get.World()
        if not world or type(getgc) ~= "function" then return nil end
        local ok, found = pcall(function()
            for _, obj in ipairs(getgc(true)) do
                if type(obj) == "table" then
                    local ci = rawget(obj, "client_ids")
                    local si = rawget(obj, "server_ids")
                    if type(ci) == "table" and type(si) == "table" and rawget(obj, "world") == world then
                        return obj
                    end
                end
            end
            return nil
        end)
        if ok and found then
            Shared.Replicator = found
        end
        return Shared.Replicator
    end,
    ServerId = function(entity)
        local rep = Get.Replicator()
        if not rep or entity == nil then return nil end
        local ids = rep.client_ids
        if type(ids) ~= "table" then return nil end
        return ids[entity]
    end,
    Requests = function()
        if Shared.Requests then return Shared.Requests end
        if M.RemotesMod and M.RemotesMod.remotes and M.RemotesMod.remotes.requests then
            Shared.Requests = M.RemotesMod.remotes.requests
        end
        return Shared.Requests
    end,
    ct = function()
        if M.Components and M.Components.ct then return M.Components.ct end
        return nil
    end,
    Pair = function(a, b)
        if M.Jecs and M.Jecs.pair then return M.Jecs.pair(a, b) end
        return nil
    end,
    Ctx = function()
        local world = Get.World()
        if not world then return nil end
        if not Shared.Ctx then Shared.Ctx = { world = world } end
        return Shared.Ctx
    end,
    Player = function()
        local ctx, mod = Get.Ctx(), M.Local
        if not ctx or not mod or not mod.Local then return nil end
        local ok, ent = pcall(mod.Local.player, ctx)
        if ok then return ent end
        return nil
    end,
    Plot = function()
        local ctx, mod = Get.Ctx(), M.Local
        if not ctx or not mod or not mod.Local then return nil end
        local ok, ent = pcall(mod.Local.plot, ctx)
        if ok then return ent end
        return nil
    end,
    Island = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return nil end
        local p = Get.Pair(ct.owner_link, player)
        if not p then return nil end
        local ok, ent = pcall(function()
            for e in world:query():with(ct.island, p):iter() do return e end
        end)
        if ok then return ent end
        return nil
    end,
    Money = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return 0 end
        local ok, m = pcall(function() return world:get(player, ct.money) end)
        if ok and m then return m end
        return 0
    end,
    OwnedContainers = function()
        local containers = {}
        local plot = Get.Plot()
        if plot then containers[#containers + 1] = plot end
        local island = Get.Island()
        if island then containers[#containers + 1] = island end
        return containers
    end,
    IsOwnedContainer = function(container)
        if container == nil then return false end
        local player = Get.Player()
        local world, ct = Get.World(), Get.ct()
        if not player or not world or not ct then return false end
        local ok, owner = pcall(function()
            return world:target(container, ct.owner_link)
        end)
        return ok and owner == player
    end,
    Machines = function()
        local world, ct, plot = Get.World(), Get.ct(), Get.Plot()
        if not world or not ct or not plot then return {} end
        local p = Get.Pair(ct.container_link, plot)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.roll_machine):with(p):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    Piles = function()
        local world, ct, plot = Get.World(), Get.ct(), Get.Plot()
        if not world or not ct or not plot then return {} end
        local p = Get.Pair(ct.container_link, plot)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.model):with(ct.pile, p):without(ct.carried):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    Crafters = function()
        local world, ct, plot = Get.World(), Get.ct(), Get.Plot()
        if not world or not ct or not plot then return {} end
        local p = Get.Pair(ct.container_link, plot)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query():with(ct.instance, ct.crafter, p):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    PartTools = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return {} end
        local p = Get.Pair(ct.owner_link, player)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query():with(ct.part_type, ct.tool, p):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    GolemTools = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return {} end
        local p = Get.Pair(ct.owner_link, player)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.tool):with(ct.golem_tool, p):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    GearTools = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return {} end
        local p = Get.Pair(ct.owner_link, player)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.gear_tool):with(p):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    PlacedGolems = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return {} end
        local p = Get.Pair(ct.owner_link, player)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.model):with(ct.golem, p):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    CrafterInstanceBusy = function(crafter)
        local world, ct = Get.World(), Get.ct()
        if not world or not ct or crafter == nil then return false end
        local ok, inst = pcall(function() return world:get(crafter, ct.crafter_instance) end)
        if not ok or not inst then return false end
        local okCenter, center = pcall(function() return inst.interactive.crafter.interactive.center end)
        if not okCenter or not center then return false end
        local okChildren, children = pcall(function() return center:GetChildren() end)
        return okChildren and children and #children > 0
    end,
    PartsInCrafter = function(crafter)
        local world, ct = Get.World(), Get.ct()
        if not world or not ct or crafter == nil then return {} end
        local p = Get.Pair(ct.owner_link, crafter)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.part_type):with(p):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    PackTools = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return {} end
        local p = Get.Pair(ct.owner_link, player)
        if not p then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.tool):with(ct.pack_tool, p):iter() do out[#out + 1] = e end
            return out
        end)
        return (ok and list) or {}
    end,
    BlasterEquipped = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return false end
        local p = Get.Pair(ct.owner_link, player)
        if not p then return false end
        local ok, found = pcall(function()
            for e in world:query(ct.tool):with(ct.blaster_tool, p):iter() do
                if world:has(e, ct.equipped) then return true end
            end
            return false
        end)
        return (ok and found) or false
    end,
    HasEquippedGolem = function()
        local world, ct, player = Get.World(), Get.ct(), Get.Player()
        if not world or not ct or not player then return false end
        local p = Get.Pair(ct.owner_link, player)
        if not p then return false end
        local ok, found = pcall(function()
            for e in world:query():with(ct.golem_tool, ct.equipped, p):iter() do
                return true
            end
            return false
        end)
        return (ok and found) or false
    end,
    LockedZones = function()
        local world, ct = Get.World(), Get.ct()
        if not world or not ct then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.ore_zone_instance):without(ct.foreign, ct.unlocked):iter() do out[#out + 1] = e end
            return out
        end)
        if not ok then return {} end
        local owned = {}
        for _, e in ipairs(list) do
            local container
            pcall(function() container = world:target(e, ct.container_link) end)
            if Get.IsOwnedContainer(container) then
                owned[#owned + 1] = e
            end
        end
        return owned
    end,
    OwnedZones = function()
        local world, ct = Get.World(), Get.ct()
        if not world or not ct then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query():with(ct.ore_zone):iter() do out[#out + 1] = e end
            return out
        end)
        if not ok then return {} end
        local owned = {}
        for _, e in ipairs(list) do
            local container
            pcall(function() container = world:target(e, ct.container_link) end)
            if Get.IsOwnedContainer(container) then
                owned[#owned + 1] = e
            end
        end
        return owned
    end,
    Chargers = function()
        local world, ct = Get.World(), Get.ct()
        if not world or not ct then return {} end
        local ok, list = pcall(function()
            local out = {}
            for e in world:query(ct.movable, ct.charger_tier):with(ct.charger):iter() do out[#out + 1] = e end
            return out
        end)
        if not ok then return {} end
        local owned = {}
        for _, e in ipairs(list) do
            local container
            pcall(function() container = world:target(e, ct.container_link) end)
            if Get.IsOwnedContainer(container) then
                owned[#owned + 1] = e
            end
        end
        return owned
    end,
    PartDef = function(partId)
        if not M.PartReg or not M.PartReg.part_registry or not partId then return nil end
        local ok, def = pcall(function() return M.PartReg.part_registry.find(partId) end)
        if ok then return def end
        return nil
    end,
    PartList = function()
        if not M.PartReg or not M.PartReg.part_registry then return {} end
        local ok, list = pcall(function() return M.PartReg.part_registry.list() end)
        if ok and list then return list end
        return {}
    end,
    GolemName = function(entity)
        if not M.GolemParts or not M.GolemParts.GolemParts or not entity then return "Golem" end
        local world = Get.World()
        if not world then return "Golem" end
        local ok, partIds = pcall(function() return M.GolemParts.GolemParts.part_ids(world, entity) end)
        if not ok or not partIds or #partIds == 0 then return "Golem" end
        local firstDef = Get.PartDef(partIds[1])
        if not firstDef or not firstDef.golem or not firstDef.name then return "Golem" end
        local golemSet = firstDef.golem
        for i = 2, #partIds do
            local def = Get.PartDef(partIds[i])
            if not def or def.golem ~= golemSet then return "Golem" end
        end
        local firstWord = string.split(firstDef.name, " ")[1]
        if not firstWord then return "Golem" end
        return firstWord .. " Golem"
    end,
    RarityIndex = function(rarity)
        if not M.Rarity or not M.Rarity.rarities or not rarity then return nil end
        return table.find(M.Rarity.rarities, rarity)
    end,
    NowSeconds = function()
        if M.Time and M.Time.now_seconds then
            local ok, n = pcall(M.Time.now_seconds)
            if ok and n then return n end
        end
        return math.round(Workspace:GetServerTimeNow())
    end,
    SnowmanTarget = function()
        local snowmen = Workspace:FindFirstChild("snowmen")
        if not snowmen then return nil end
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local best, bestDist
        for _, m in ipairs(snowmen:GetChildren()) do
            if m:IsA("Model") then
                local pp = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                if pp then
                    local d = (pp.Position - hrp.Position).Magnitude
                    if not best or d < bestDist then
                        best = pp.Position
                        bestDist = d
                    end
                end
            end
        end
        return best
    end,
}
Send = {
    Roll = function(machineId)
        local r = Get.Requests()
        if r and machineId then pcall(function() r.roll:fire(machineId) end) end
    end,
    Purchase = function(machineId, slot)
        local r = Get.Requests()
        if r and machineId and slot then pcall(function() r.purchase:fire(machineId, slot) end) end
    end,
    Insert = function(crafterId)
        local r = Get.Requests()
        if r and crafterId then pcall(function() r.insert:fire(crafterId) end) end
    end,
    Recall = function(golemServerId)
        local r = Get.Requests()
        if r and golemServerId then pcall(function() r.recall:fire(golemServerId) end) end
    end,
    Grab = function(pileId)
        local r = Get.Requests()
        if r and pileId then pcall(function() r.grab:fire(pileId) end) end
    end,
    Sell = function()
        local r = Get.Requests()
        if r then pcall(function() r.sell:fire() end) end
    end,
    Place = function()
        local r = Get.Requests()
        if r then pcall(function() r.place:fire() end) end
    end,
    Unlock = function(zoneId)
        local r = Get.Requests()
        if r and zoneId then pcall(function() r.unlock:fire(zoneId) end) end
    end,
    BuyIsland = function(purchaseId)
        local r = Get.Requests()
        if r and purchaseId then pcall(function() r.buy_island:fire(purchaseId) end) end
    end,
    Upgrade = function(containerId, component)
        local r = Get.Requests()
        if r and containerId and component then pcall(function() r.upgrade:fire(containerId, component) end) end
    end,
    UpgradeCrystal = function(zoneId)
        local r = Get.Requests()
        if r and zoneId then pcall(function() r.upgrade_crystal:fire(zoneId) end) end
    end,
    UpgradeCharger = function(chargerId)
        local r = Get.Requests()
        if r and chargerId then pcall(function() r.upgrade_charger:fire(chargerId) end) end
    end,
    ClaimReward = function(indices)
        local r = Get.Requests()
        if r and indices and #indices > 0 then pcall(function() r.claim_reward:fire(indices) end) end
    end,
    ClaimDaily = function()
        local r = Get.Requests()
        if r then pcall(function() r.claim_daily:fire() end) end
    end,
    ClaimOffline = function()
        local r = Get.Requests()
        if r then pcall(function() r.claim_offline:fire() end) end
    end,
    ClaimGroup = function()
        local r = Get.Requests()
        if r then pcall(function() r.claim_group_reward:fire() end) end
    end,
    RedeemCode = function(code)
        local r = Get.Requests()
        if r and code then pcall(function() r.redeem_code(code) end) end
    end,
    OpenPack = function(packId)
        local r = Get.Requests()
        if r and packId then pcall(function() r.open_pack:fire(packId) end) end
    end,
    BuyGear = function(gearId, amount)
        local r = Get.Requests()
        if r and gearId then pcall(function() r.buy_gear:fire(gearId, amount or 1) end) end
    end,
    ApplyGear = function(golemServerId)
        local r = Get.Requests()
        if r and golemServerId then pcall(function() r.apply_gear:fire(golemServerId) end) end
    end,
    BuyAirship = function(window, offerIndex)
        local r = Get.Requests()
        if r and window and offerIndex then pcall(function() r.buy_airship(window, offerIndex) end) end
    end,
    RespondGift = function(accept)
        local r = Get.Requests()
        if r then pcall(function() r.respond_gift:fire(accept) end) end
    end,
    Throw = function(muzzle, target)
        local r = Get.Requests()
        if r and muzzle and target then pcall(function() r.throw:fire(muzzle, target) end) end
    end,
}
local function UpgradeLabel(def)
    local ct = Get.ct()
    if not ct or not def or not def.component then return "Upgrade" end
    if def.component == ct.tile_yield then return "Tile Yield" end
    if def.component == ct.ore_regen then return "Ore Regen" end
    if def.component == ct.large_ore_luck then return "Large Ore Luck" end
    if def.component == ct.golem_slots then return "Golem Slots" end
    if def.component == ct.roll_luck then return "Roll Luck" end
    if def.component == ct.roll_cells then return "Roll Cells" end
    return "Upgrade"
end
Func = {
    AutoSell = function()
        while Toggles.AutoSell and Toggles.AutoSell.Value do
            local world, ct, player = Get.World(), Get.ct(), Get.Player()
            if world and ct then
                for _, e in ipairs(Get.Piles()) do
                    local sid = Get.ServerId(e)
                    if sid then
                        Send.Grab(sid)
                        task.wait(0.15)
                    end
                end
            end
            if world and ct and player then
                local ok, carrying = pcall(function() return world:has(player, ct.carrying) end)
                if ok and carrying then
                    Send.Sell()
                end
            end
            task.wait(.3)
        end
    end,
    AutoRoll = function()
        while Toggles.AutoRoll and Toggles.AutoRoll.Value do
            local world, ct = Get.World(), Get.ct()
            for _, e in ipairs(Get.Machines()) do
                local sid = Get.ServerId(e)
                if sid then
                    Send.Roll(sid)
                    task.wait(0.3)
                end
            end
            if world and ct and M.Slots and M.Slots.slots then
                local sel = (Options.BuyPartsRarity and Options.BuyPartsRarity.Value) or "Any"
                local minIdx
                if sel ~= "Any" then minIdx = Get.RarityIndex(sel) end
                local partIds = GetBuyPartsSelection and GetBuyPartsSelection() or {}
                for _, machine in ipairs(Get.Machines()) do
                    local sid = Get.ServerId(machine)
                    if sid then
                        for i, slotComp in ipairs(M.Slots.slots) do
                            local ok, res = pcall(function()
                                return world:get(machine, Get.Pair(ct.roll_result, slotComp))
                            end)
                            if ok and res and res.part_id and partIds[res.part_id] then
                                local def = Get.PartDef(res.part_id)
                                if def and def.price then
                                    local rIdx = Get.RarityIndex(def.rarity)
                                    if (not minIdx) or (rIdx and rIdx >= minIdx) then
                                        while Toggles.AutoRoll and Toggles.AutoRoll.Value and Get.Money() < def.price do
                                            local stillOk, stillRes = pcall(function()
                                                return world:get(machine, Get.Pair(ct.roll_result, slotComp))
                                            end)
                                            if not (stillOk and stillRes and stillRes.part_id == res.part_id) then
                                                break
                                            end
                                            task.wait(0.5)
                                        end
                                        if Toggles.AutoRoll and Toggles.AutoRoll.Value and Get.Money() >= def.price then
                                            Send.Purchase(sid, i)
                                            task.wait(0.2)
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
    end,
    AutoAssemble = function()
        while Toggles.AutoAssemble and Toggles.AutoAssemble.Value do
            local world, ct, player = Get.World(), Get.ct(), Get.Player()
            if world and ct and player then
                local okCarry, carrying = pcall(function() return world:has(player, ct.carrying) end)
                if not (okCarry and carrying) then
                    for _, crafter in ipairs(Get.Crafters()) do
                        local busy
                        pcall(function()
                            busy = world:has(crafter, Get.Pair(ct.unix, ct.crafting))
                                or world:has(crafter, Get.Pair(ct.unix, ct.disassembling))
                                or world:has(crafter, Get.Pair(ct.unix, ct.cooldown))
                        end)
                        if not busy then
                            busy = Get.CrafterInstanceBusy(crafter)
                        end
                        if not busy then
                            local slotsIn = {}
                            local setIn
                            for _, pe in ipairs(Get.PartsInCrafter(crafter)) do
                                local okP, pt = pcall(function() return world:get(pe, ct.part_type) end)
                                if okP and pt and pt.part_id then
                                    local def = Get.PartDef(pt.part_id)
                                    if def and def.slot then
                                        slotsIn[def.slot] = true
                                        if def.golem then setIn = def.golem end
                                    end
                                end
                            end
                            local setOnly = Toggles.SetOnly and Toggles.SetOnly.Value
                            local assemblePartIds = GetAssemblePartsSelection and GetAssemblePartsSelection() or {}
                            local restrictParts = next(assemblePartIds) ~= nil
                            local best, bestScore
                            local eligible = {}
                            for _, te in ipairs(Get.PartTools()) do
                                local okT, pt = pcall(function() return world:get(te, ct.part_type) end)
                                if okT and pt and pt.part_id then
                                    local def = Get.PartDef(pt.part_id)
                                    if def and def.slot and not slotsIn[def.slot] then
                                        if (not restrictParts) or assemblePartIds[pt.part_id] then
                                            if (not setOnly) or (not setIn) or def.golem == setIn then
                                                eligible[#eligible + 1] = te
                                                local okEqAlready, equippedAlready = pcall(function() return world:has(te, ct.equipped) end)
                                                if okEqAlready and equippedAlready and not best then
                                                    best = te
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if not best then
                                for _, te in ipairs(eligible) do
                                    local okT, pt = pcall(function() return world:get(te, ct.part_type) end)
                                    if okT and pt and pt.part_id then
                                        local def = Get.PartDef(pt.part_id)
                                        local rIdx = Get.RarityIndex(def.rarity) or 1
                                        local score = rIdx * 1e15 + (def.price or 0)
                                        if not best or score > bestScore then
                                            best, bestScore = te, score
                                        end
                                    end
                                end
                            end
                            local filledCount = 0
                            for _ in pairs(slotsIn) do filledCount = filledCount + 1 end
                            if best then
                                local okEq, equipped = pcall(function() return world:has(best, ct.equipped) end)
                                if okEq and equipped then
                                    local sid = Get.ServerId(crafter)
                                    if sid then
                                        Send.Insert(sid)
                                        if filledCount >= 4 then
                                            task.wait(5)
                                        end
                                    end
                                else
                                    pcall(function()
                                        local hum = world:get(player, ct.humanoid)
                                        local toolInst = world:get(best, ct.tool)
                                        if hum and toolInst then
                                            hum:EquipTool(toolInst)
                                        end
                                    end)
                                end
                            end
                            break
                        end
                    end
                end
            end
            task.wait()
        end
    end,
    AutoPlace = function()
        local lastPlace = 0
        while Toggles.AutoPlace and Toggles.AutoPlace.Value do
            local world, ct, player = Get.World(), Get.ct(), Get.Player()
            if Get.HasEquippedGolem() then
                if (tick() - lastPlace) > 1 then
                    Send.Place()
                    lastPlace = tick()
                end
            elseif world and ct and player then
                local selection = GetPlaceGolemSelection and GetPlaceGolemSelection() or nil
                for _, e in ipairs(Get.GolemTools()) do
                    local matches = (not selection) or selection[Get.GolemName(e)]
                    if matches then
                        local okEq, equipped = pcall(function() return world:has(e, ct.equipped) end)
                        if not (okEq and equipped) then
                            pcall(function()
                                local hum = world:get(player, ct.humanoid)
                                local toolInst = world:get(e, ct.tool)
                                if hum and toolInst then
                                    hum:EquipTool(toolInst)
                                end
                            end)
                            break
                        end
                    end
                end
            end
            task.wait(.3)
        end
    end,
    AutoBlaster = function()
        while Toggles.AutoBlaster and Toggles.AutoBlaster.Value do
            if Get.BlasterEquipped() then
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local target = hrp and Get.SnowmanTarget()
                if hrp and target then
                    local muzzle = (hrp.CFrame * CFrame.new(1.5, 0.5, -4)).Position
                    Send.Throw(muzzle, target)
                end
            end
            task.wait(.5)
        end
    end,
    AutoUnlockZones = function()
        while Toggles.AutoUnlockZones and Toggles.AutoUnlockZones.Value do
            local world, ct = Get.World(), Get.ct()
            if world and ct then
                local money = Get.Money()
                for _, zone in ipairs(Get.LockedZones()) do
                    local okZ, container = pcall(function() return world:target(zone, ct.container_link) end)
                    if okZ and container then
                        local price
                        if M.Zones and M.Zones.Zones and M.Zones.Zones.unlock_price then
                            pcall(function() price = M.Zones.Zones.unlock_price(world, container) end)
                        end
                        if price and price <= money then
                            local sid = Get.ServerId(zone)
                            if sid then
                                Send.Unlock(sid)
                                money = money - price
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
            task.wait(3)
        end
    end,
    AutoBuyIsland = function()
        while Toggles.AutoBuyIsland and Toggles.AutoBuyIsland.Value do
            local world, ct, plot = Get.World(), Get.ct(), Get.Plot()
            if world and ct and plot then
                local allUnlocked
                if M.OreZones and M.OreZones.ore_zone_tags and M.Zones and M.Zones.Zones and M.Zones.Zones.unlocked_count then
                    pcall(function()
                        allUnlocked = #M.OreZones.ore_zone_tags <= M.Zones.Zones.unlocked_count(world, plot)
                    end)
                end
                local price = M.Islands and M.Islands.island_price
                if allUnlocked and price and Get.Money() >= price then
                    local p = Get.Pair(ct.container_link, plot)
                    if p then
                        local ok, list = pcall(function()
                            local out = {}
                            for e in world:query(ct.movable):with(ct.island_purchase, p):iter() do out[#out + 1] = e end
                            return out
                        end)
                        if ok and list then
                            for _, e in ipairs(list) do
                                local sid = Get.ServerId(e)
                                if sid then
                                    Send.BuyIsland(sid)
                                    task.wait(2)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(10)
        end
    end,
    AutoUpgrades = function()
        while Toggles.AutoUpgrades and Toggles.AutoUpgrades.Value do
            local world = Get.World()
            if world and M.Upgrades and M.Upgrades.all_upgrade_list and M.Upgrades.upgrade_price and M.Upgrades.is_upgrade_maxed then
                local money = Get.Money()
                local selection = GetUpgradeSelection and GetUpgradeSelection() or {}
                for label, active in pairs(selection) do
                    if active then
                        local def = UpgradeLabelToDef[label]
                        if def and def.component then
                            for _, container in ipairs(Get.OwnedContainers()) do
                                local okL, level = pcall(function() return world:get(container, def.component) end)
                                local lvl = (okL and level) or 0
                                local maxed, price
                                pcall(function()
                                    maxed = M.Upgrades.is_upgrade_maxed(def, lvl)
                                    price = M.Upgrades.upgrade_price(def, lvl)
                                end)
                                if not maxed and price and price <= money then
                                    local sid = Get.ServerId(container)
                                    if sid then
                                        Send.Upgrade(sid, def.component)
                                        money = money - price
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(1)
        end
    end,
    AutoCrystalUpgrade = function()
        while Toggles.AutoCrystalUpgrade and Toggles.AutoCrystalUpgrade.Value do
            local world, ct = Get.World(), Get.ct()
            if world and ct and M.Crystals and M.Crystals.crystal_upgrade_prices then
                local money = Get.Money()
                for _, zone in ipairs(Get.OwnedZones()) do
                    local okL, level = pcall(function() return world:get(zone, ct.crystal_level) end)
                    local lvl = (okL and level) or 0
                    local price = M.Crystals.crystal_upgrade_prices[lvl + 1]
                    if price and price <= money then
                        local sid = Get.ServerId(zone)
                        if sid then
                            Send.UpgradeCrystal(sid)
                            money = money - price
                            task.wait(0.5)
                        end
                    end
                end
            end
            task.wait(10)
        end
    end,
    AutoChargerUpgrade = function()
        while Toggles.AutoChargerUpgrade and Toggles.AutoChargerUpgrade.Value do
            local world, ct = Get.World(), Get.ct()
            if world and ct and M.Chargers and M.Chargers.charger_upgrade_price then
                local money = Get.Money()
                for _, charger in ipairs(Get.Chargers()) do
                    local okT, tier = pcall(function() return world:get(charger, ct.charger_tier) end)
                    if okT and tier then
                        local price
                        pcall(function() price = M.Chargers.charger_upgrade_price(tier) end)
                        if price and price <= money then
                            local sid = Get.ServerId(charger)
                            if sid then
                                Send.UpgradeCharger(sid)
                                money = money - price
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
            task.wait(10)
        end
    end,
    AutoClaimSweep = function()
        while Toggles.AutoClaimSweep and Toggles.AutoClaimSweep.Value do
            local world, ct, player = Get.World(), Get.ct(), Get.Player()
            if world and ct and player then
                if M.Playtime and M.Playtime.reward_state and M.Playtime.PLAYTIME_REWARDS then
                    local okS, sessionStart = pcall(function() return world:get(player, ct.session_start) end)
                    local okC, claimed = pcall(function() return world:get(player, ct.claimed_rewards) end)
                    if okS and sessionStart then
                        local playtime = math.max(0, Get.NowSeconds() - sessionStart)
                        local claimedList = (okC and claimed) or {}
                        local indices = {}
                        pcall(function()
                            for i = 0, #M.Playtime.PLAYTIME_REWARDS - 1 do
                                if M.Playtime.reward_state(i, playtime, claimedList) == "claim" then
                                    indices[#indices + 1] = i
                                end
                            end
                        end)
                        if #indices > 0 then
                            Send.ClaimReward(indices)
                        end
                    end
                end
                Send.ClaimDaily()
                task.wait(1)
                Send.ClaimOffline()
                task.wait(1)
                Send.ClaimGroup()
            end
            task.wait((Options.ClaimInterval and Options.ClaimInterval.Value) or 60)
        end
    end,
    AutoRedeemCodes = function()
        local redeemed = {}
        while Toggles.AutoRedeemCodes and Toggles.AutoRedeemCodes.Value do
            if M.Codes and M.Codes.CODES then
                for code in pairs(M.Codes.CODES) do
                    if not redeemed[code] then
                        Send.RedeemCode(code)
                        redeemed[code] = true
                        task.wait(1)
                    end
                end
            end
            task.wait(300)
        end
    end,
    AutoOpenPacks = function()
        while Toggles.AutoOpenPacks and Toggles.AutoOpenPacks.Value do
            local packs = Get.PackTools()
            if #packs > 0 then
                for _, e in ipairs(packs) do
                    local sid = Get.ServerId(e)
                    if sid then
                        Send.OpenPack(sid)
                        task.wait(1)
                    end
                end
            else
                task.wait(5)
            end
        end
    end,
    AutoApplyGear = function()
        while Toggles.AutoApplyGear and Toggles.AutoApplyGear.Value do
            local world, ct, player = Get.World(), Get.ct(), Get.Player()
            local GearBuffsMod = M.GearBuffs and M.GearBuffs.GearBuffs
            local GearReg = M.GearReg and M.GearReg.gear_registry
            if world and ct and player and GearBuffsMod and GearReg then
                local selection = GetApplyGearSelection and GetApplyGearSelection() or {}
                local selectedIds = {}
                for label, active in pairs(selection) do
                    if active then
                        local def = GearLabelToDef[label]
                        if def and def.id then selectedIds[def.id] = true end
                    end
                end
                if next(selectedIds) then
                    for _, toolEnt in ipairs(Get.GearTools()) do
                        if not (Toggles.AutoApplyGear and Toggles.AutoApplyGear.Value) then break end
                        local okId, itemId = pcall(function() return world:get(toolEnt, ct.gear_tool) end)
                        if okId and itemId and selectedIds[itemId] then
                            local okDef, def = pcall(function() return GearReg.find(itemId) end)
                            if okDef and def then
                                local eligibleGolems = {}
                                for _, golemEnt in ipairs(Get.PlacedGolems()) do
                                    local okCan, canApply = pcall(function()
                                        return GearBuffsMod.can_apply(world, golemEnt, def)
                                    end)
                                    if okCan and canApply then
                                        eligibleGolems[#eligibleGolems + 1] = golemEnt
                                    end
                                end
                                if #eligibleGolems > 0 then
                                    local okEq, alreadyEquipped = pcall(function() return world:has(toolEnt, ct.equipped) end)
                                    if not (okEq and alreadyEquipped) then
                                        pcall(function()
                                            local hum = world:get(player, ct.humanoid)
                                            local toolInst = world:get(toolEnt, ct.tool)
                                            if hum and toolInst then hum:EquipTool(toolInst) end
                                        end)
                                        task.wait(0.3)
                                    end
                                    for _, golemEnt in ipairs(eligibleGolems) do
                                        local sid = Get.ServerId(golemEnt)
                                        if sid then
                                            Send.ApplyGear(sid)
                                            task.wait(0.2)
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end
            end
            task.wait(1)
        end
    end,
    AutoPickup = function()
        while Toggles.AutoPickup and Toggles.AutoPickup.Value do
            local selection = GetPickupGolemSelection and GetPickupGolemSelection() or nil
            for _, golemEnt in ipairs(Get.PlacedGolems()) do
                if not (Toggles.AutoPickup and Toggles.AutoPickup.Value) then break end
                local matches = (not selection) or selection[Get.GolemName(golemEnt)]
                if matches then
                    local sid = Get.ServerId(golemEnt)
                    if sid then
                        Send.Recall(sid)
                        task.wait(0.2)
                    end
                end
            end
            task.wait(.5)
        end
    end,
    AutoBuyGear = function()
        while Toggles.AutoBuyGear and Toggles.AutoBuyGear.Value do
            local money = Get.Money()
            local selection = GetGearSelection and GetGearSelection() or {}
            for label, active in pairs(selection) do
                if active then
                    local def = GearLabelToDef[label]
                    if def and def.id and def.price and def.price <= money then
                        Send.BuyGear(def.id, 1)
                        money = money - def.price
                        task.wait(0.5)
                    end
                end
            end
            task.wait(1)
        end
    end,
    AutoAirship = function()
        while Toggles.AutoAirship and Toggles.AutoAirship.Value do
            local world, ct, player = Get.World(), Get.ct(), Get.Player()
            if world and ct and player and M.Airship and M.Airship.visit_window and M.Airship.roll_offers and M.Airship.offer_price_at then
                local okO, offset = pcall(function() return world:get(ct.airship_offset, ct.airship_offset) end)
                offset = (okO and offset) or 0
                local now = Get.NowSeconds()
                local phase
                pcall(function() phase = M.Airship.visit_phase(now, offset) end)
                if phase == "open" then
                    local window = M.Airship.visit_window(now, offset)
                    local openAt
                    pcall(function() openAt = M.Airship.visit_open_at(window, offset) end)
                    local okOffers, offers = pcall(function() return M.Airship.roll_offers(window, offset) end)
                    if okOffers and offers and openAt then
                        local money = Get.Money()
                        local maxPct = ((Options.AirshipMaxPrice and Options.AirshipMaxPrice.Value) or 55) / 100
                        local okS, stock = pcall(function() return world:get(ct.airship_stock, ct.airship_stock) end)
                        local okP, purchases = pcall(function() return world:get(player, ct.airship_purchases) end)
                        for i, offer in ipairs(offers) do
                            if type(offer) == "table" then
                                local price, startP
                                pcall(function()
                                    price = M.Airship.offer_price_at(offer, openAt, now)
                                    startP = offer.start_price
                                end)
                                if price and startP and money >= price and price <= startP * maxPct then
                                    local remaining = offer.quantity
                                    if okS and stock and stock.window == window then
                                        remaining = stock.remaining and (stock.remaining[i] or offer.quantity) or offer.quantity
                                    end
                                    local bought = 0
                                    if okP and purchases and purchases.window == window then
                                        bought = purchases.counts and (purchases.counts[i] or 0) or 0
                                    end
                                    local cap = 1
                                    if M.Airship.purchase_cap_for then
                                        pcall(function() cap = M.Airship.purchase_cap_for(offer.quantity) or 1 end)
                                    end
                                    if remaining and remaining > 0 and bought < cap then
                                        Send.BuyAirship(window, i - 1)
                                        money = money - price
                                        task.wait(1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(5)
        end
    end,
    AutoAcceptGifts = function()
        local lastFire = 0
        while Toggles.AutoAcceptGifts and Toggles.AutoAcceptGifts.Value do
            local world, ct, player = Get.World(), Get.ct(), Get.Player()
            if world and ct and player then
                local ok, offer = pcall(function() return world:get(player, ct.gift_offer) end)
                if ok and offer ~= nil and (tick() - lastFire) > 5 then
                    Send.RespondGift(true)
                    lastFire = tick()
                end
            end
            task.wait(0.5)
        end
    end,
}
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false })
GetBuyPartsSelection = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "BuyPartsSelection", { Text = "Parts To Buy", Values = PartLabels, label = PartLabelToId })
TB_Tabs.Autofarm2.T1:AddDropdown("BuyPartsRarity", {
    Text = "Min Rarity",
    Values = { "Any" },
    Default = "Any",
})
GetAssemblePartsSelection = AddMultiDropdown(GB.Golems.Left.Golem, "AssemblePartsSelection", { Text = "Parts To Assemble", Values = PartLabels, label = PartLabelToId })
GB.Golems.Left.Golem:AddToggle("SetOnly", { Text = "Set Only", Default = false })
GB.Golems.Left.Golem:AddToggle("AutoAssemble", { Text = "Auto Assemble", Default = false })
GetPlaceGolemSelection = AddMultiDropdown(GB.Golems.Left.Golem, "PlaceGolemSelection", { Text = "Golems To Place", Values = GolemLabels })
GB.Golems.Left.Golem:AddToggle("AutoPlace", { Text = "Auto Place", Default = false })
GetPickupGolemSelection = AddMultiDropdown(GB.Golems.Left.Golem, "PickupGolemSelection", { Text = "Golems To Pickup", Values = GolemLabels })
GB.Golems.Left.Golem:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false })
GB.Golems.Left.Event:AddToggle("AutoBlaster", { Text = "Auto Blaster", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUnlockZones", { Text = "Auto Unlock Ore Zones", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyIsland", { Text = "Auto Buy Island", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrades", { Text = "Auto Upgrades", Default = false })
GetUpgradeSelection = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "UpgradeSelection", { Text = "Upgrades", Values = UpgradeLabels })
TB_Tabs.Autofarm.T1:AddToggle("AutoCrystalUpgrade", { Text = "Auto Crystal Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoChargerUpgrade", { Text = "Auto Charger Upgrade", Default = false })
GB.Rewards.Left.Claims:AddToggle("AutoClaimSweep", { Text = "Auto Claim Rewards", Default = false })
GB.Rewards.Left.Claims:AddSlider("ClaimInterval", { Text = "Claim Interval", Default = 60, Min = 10, Max = 1800, Rounding = 0, Compact = true })
GB.Rewards.Left.Packs:AddToggle("AutoOpenPacks", { Text = "Auto Open Packs", Default = false })
GB.Rewards.Right.Codes:AddToggle("AutoRedeemCodes", { Text = "Auto Redeem Codes", Default = false })
GetApplyGearSelection = AddMultiDropdown(GB.Golems.Right.Gear, "ApplyGearSelection", { Text = "Gear To Apply", Values = GearLabels })
GB.Golems.Right.Gear:AddToggle("AutoApplyGear", { Text = "Auto Apply Gear", Default = false })
GetGearSelection = AddMultiDropdown(GB.Golems.Right.Gear, "GearSelection", { Text = "Gear To Buy", Values = GearLabels })
GB.Golems.Right.Gear:AddToggle("AutoBuyGear", { Text = "Auto Buy Gear", Default = false })
GB.Golems.Right.ShopAirship:AddToggle("AutoAirship", { Text = "Auto Buy Airship Offers", Default = false })
GB.Golems.Right.ShopAirship:AddSlider("AirshipMaxPrice", { Text = "Airship Max Price ", Default = 55, Min = 50, Max = 100, Rounding = 0, Compact = true })
GB.Rewards.Right.Social:AddToggle("AutoAcceptGifts", { Text = "Auto Accept Gifts", Default = false })
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
local function PopulateDropdowns()
    if M.Rarity and M.Rarity.rarities and Options.BuyPartsRarity then
        local vals = { "Any" }
        for _, r in ipairs(M.Rarity.rarities) do vals[#vals + 1] = r end
        Options.BuyPartsRarity:SetValues(vals)
    end
    if M.Upgrades and M.Upgrades.all_upgrade_list and Options.UpgradeSelection then
        table.clear(UpgradeLabels)
        table.clear(UpgradeLabelToDef)
        for _, def in ipairs(M.Upgrades.all_upgrade_list) do
            local label = UpgradeLabel(def)
            if not UpgradeLabelToDef[label] then
                UpgradeLabels[#UpgradeLabels + 1] = label
                UpgradeLabelToDef[label] = def
            end
        end
        local values = { "All" }
        for _, lab in ipairs(UpgradeLabels) do values[#values + 1] = lab end
        Options.UpgradeSelection:SetValues(values)
    end
    if M.PartReg and M.PartReg.part_registry and Options.BuyPartsSelection then
        table.clear(PartLabels)
        table.clear(PartLabelToId)
        local entries = {}
        for _, pair in ipairs(Get.PartList()) do
            local partId, def = pair[1], pair[2]
            if partId and def and def.name then
                local rIdx = Get.RarityIndex(def.rarity) or math.huge
                entries[#entries + 1] = { partId = partId, name = def.name, rarity = def.rarity, rIdx = rIdx }
            end
        end
        table.sort(entries, function(a, b)
            if a.rIdx ~= b.rIdx then return a.rIdx < b.rIdx end
            return a.name < b.name
        end)
        for _, e in ipairs(entries) do
            local label = e.rarity and ("%s[%s]"):format(e.name, e.rarity) or e.name
            if not PartLabelToId[label] then
                PartLabels[#PartLabels + 1] = label
                PartLabelToId[label] = e.partId
            end
        end
        local values = { "All" }
        for _, lab in ipairs(PartLabels) do values[#values + 1] = lab end
        Options.BuyPartsSelection:SetValues(values)
        if Options.AssemblePartsSelection then
            Options.AssemblePartsSelection:SetValues(values)
        end
    end
    if M.PartReg and M.PartReg.part_registry and (Options.PickupGolemSelection or Options.PlaceGolemSelection) then
        table.clear(GolemLabels)
        local seen = {}
        for _, pair in ipairs(Get.PartList()) do
            local partId, def = pair[1], pair[2]
            if partId and def and def.golem and def.name then
                local firstWord = string.split(def.name, " ")[1]
                if firstWord then
                    local setName = firstWord .. " Golem"
                    if not seen[setName] then
                        seen[setName] = true
                        GolemLabels[#GolemLabels + 1] = setName
                    end
                end
            end
        end
        if not seen["Golem"] then
            GolemLabels[#GolemLabels + 1] = "Golem"
        end
        table.sort(GolemLabels)
        local values = { "All" }
        for _, lab in ipairs(GolemLabels) do values[#values + 1] = lab end
        if Options.PickupGolemSelection then Options.PickupGolemSelection:SetValues(values) end
        if Options.PlaceGolemSelection then Options.PlaceGolemSelection:SetValues(values) end
    end
    if M.GearReg and M.GearReg.gear_list and M.GearReg.gear_display_name and Options.GearSelection then
        local ok, list = pcall(function() return M.GearReg.gear_list() end)
        if ok and list then
            table.clear(GearLabels)
            table.clear(GearLabelToDef)
            for _, def in ipairs(list) do
                if def and def.id and def.price then
                    local okL, label = pcall(function() return M.GearReg.gear_display_name(def) end)
                    if okL and label and not GearLabelToDef[label] then
                        GearLabels[#GearLabels + 1] = label
                        GearLabelToDef[label] = def
                    end
                end
            end
            local values = { "All" }
            for _, lab in ipairs(GearLabels) do values[#values + 1] = lab end
            Options.GearSelection:SetValues(values)
        end
    end
end
task.spawn(function()
    task.wait(2)
    PopulateDropdowns()
end)
task.spawn(function()
    while not Library.Unloaded do
        task.wait(30)
        if (Options.GearSelection and #GearLabels == 0) or (Options.UpgradeSelection and #UpgradeLabels == 0) or (Options.BuyPartsSelection and #PartLabels == 0) or (Options.AssemblePartsSelection and #PartLabels == 0) or ((Options.PickupGolemSelection or Options.PlaceGolemSelection) and #GolemLabels == 0) then
            PopulateDropdowns()
        end
    end
end)
Toggles.AutoSell:OnChanged(function(state)
    Thread("AutoSell", SafeLoop("AutoSell", Func.AutoSell), state)
end)
Toggles.AutoRoll:OnChanged(function(state)
    Thread("AutoRoll", SafeLoop("AutoRoll", Func.AutoRoll), state)
end)
Toggles.AutoAssemble:OnChanged(function(state)
    Thread("AutoAssemble", SafeLoop("AutoAssemble", Func.AutoAssemble), state)
end)
Toggles.AutoPlace:OnChanged(function(state)
    Thread("AutoPlace", SafeLoop("AutoPlace", Func.AutoPlace), state)
end)
Toggles.AutoBlaster:OnChanged(function(state)
    Thread("AutoBlaster", SafeLoop("AutoBlaster", Func.AutoBlaster), state)
end)
Toggles.AutoUnlockZones:OnChanged(function(state)
    Thread("AutoUnlockZones", SafeLoop("AutoUnlockZones", Func.AutoUnlockZones), state)
end)
Toggles.AutoBuyIsland:OnChanged(function(state)
    Thread("AutoBuyIsland", SafeLoop("AutoBuyIsland", Func.AutoBuyIsland), state)
end)
Toggles.AutoUpgrades:OnChanged(function(state)
    Thread("AutoUpgrades", SafeLoop("AutoUpgrades", Func.AutoUpgrades), state)
end)
Toggles.AutoCrystalUpgrade:OnChanged(function(state)
    Thread("AutoCrystalUpgrade", SafeLoop("AutoCrystalUpgrade", Func.AutoCrystalUpgrade), state)
end)
Toggles.AutoChargerUpgrade:OnChanged(function(state)
    Thread("AutoChargerUpgrade", SafeLoop("AutoChargerUpgrade", Func.AutoChargerUpgrade), state)
end)
Toggles.AutoClaimSweep:OnChanged(function(state)
    Thread("AutoClaimSweep", SafeLoop("AutoClaimSweep", Func.AutoClaimSweep), state)
end)
Toggles.AutoRedeemCodes:OnChanged(function(state)
    Thread("AutoRedeemCodes", SafeLoop("AutoRedeemCodes", Func.AutoRedeemCodes), state)
end)
Toggles.AutoOpenPacks:OnChanged(function(state)
    Thread("AutoOpenPacks", SafeLoop("AutoOpenPacks", Func.AutoOpenPacks), state)
end)
Toggles.AutoBuyGear:OnChanged(function(state)
    Thread("AutoBuyGear", SafeLoop("AutoBuyGear", Func.AutoBuyGear), state)
end)
Toggles.AutoApplyGear:OnChanged(function(state)
    Thread("AutoApplyGear", SafeLoop("AutoApplyGear", Func.AutoApplyGear), state)
end)
Toggles.AutoPickup:OnChanged(function(state)
    Thread("AutoPickup", SafeLoop("AutoPickup", Func.AutoPickup), state)
end)
Toggles.AutoAirship:OnChanged(function(state)
    Thread("AutoAirship", SafeLoop("AutoAirship", Func.AutoAirship), state)
end)
Toggles.AutoAcceptGifts:OnChanged(function(state)
    Thread("AutoAcceptGifts", SafeLoop("AutoAcceptGifts", Func.AutoAcceptGifts), state)
end)
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
    Thread("NoGameplayPaused", SafeLoop("NoGameplayPaused", Func_NoGameplayPaused), state)
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
SaveManager:SetFolder("Yuri/BAG")
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
