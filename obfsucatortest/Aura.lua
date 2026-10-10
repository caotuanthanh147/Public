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
local GlobalEvents
do
    local ok, ge = pcall(function()
        return RS:WaitForChild("shared/network/GlobalEvents@GlobalEvents", 5)
    end)
    if ok and ge then GlobalEvents = ge end
end
local function GetRemote(name)
    if not GlobalEvents then return nil end
    local r = GlobalEvents:FindFirstChild(name)
    if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction") or r:IsA("UnreliableRemoteEvent")) then
        return r
    end
    return nil
end
for _, name in ipairs({
    "AuraRollRequest", "DiceRollRequest", "PlotCrystalDropRedeemRequest",
    "EquipBestCharactersRequest", "UpgradeRequest",
    "AuraRollResult", "AuraRollRejected",
    "DiceRollResult", "DiceRollRejected",
    "PlotCrystalCurrencyDrop", "PlotCrystalItemDrop",
    "CraftRequest", "CraftResult", "CraftRejected",
    "ExplorationDeployRequest", "ExplorationStartRequest", "ExplorationClaimRequest",
    "ItemUseRequest", "UseFoodOnCharacterRequest",
    "EnchantRequest", "EnchantResult", "EnchantRejected",
    "MailClaimAllRequest", "OfflineEarningClaimRequest",
    "IndexClaimAllMilestonesRequest", "QuestClaimRequest",
    "QuestDailyBonusClaimRequest", "GroupAndFavoriteRewardClaimRequest",
    "CodeRedeemRequest", "ProductPrismPurchaseRequest", "ProductPrismPurchaseRejected",
}) do
    local r = GetRemote(name)
    if r then Remotes[name] = r end
end
local ClientUser
do
    local ok, mod = pcall(function()
        return require(Plr:WaitForChild("PlayerScripts", 5):WaitForChild("TS", 5):WaitForChild("modules", 5):WaitForChild("user", 5):WaitForChild("ClientUser", 5))
    end)
    if ok and mod and mod.ClientUser then ClientUser = mod.ClientUser end
end
local function GetCurrency(name)
    if not ClientUser then return 0 end
    local ok, v = pcall(function()
        return ClientUser:getCurrency():get(name)
    end)
    return (ok and v) or 0
end
local function GetData()
    if not ClientUser then return nil end
    local ok, d = pcall(function() return ClientUser:getData() end)
    if ok and d then return d end
    return nil
end
local ObjectUtils
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("rbxts_include", 5):WaitForChild("node_modules", 5):WaitForChild("@rbxts", 5):WaitForChild("object-utils", 5))
    end)
    if ok and mod then ObjectUtils = mod end
end
local function RequireEnum(...)
    local path = { ... }
    local ok, mod = pcall(function()
        local node = RS
        for _, part in ipairs(path) do
            node = node:WaitForChild(part, 5)
        end
        return require(node)
    end)
    if not ok or not mod then
        notyuri("[EnumRequire] failed to require " .. table.concat(path, "."))
        return nil
    end
    return mod
end
local function EnumValues(enumTable)
    if not enumTable or not ObjectUtils then return {} end
    local ok, vals = pcall(function() return ObjectUtils.values(enumTable) end)
    if not ok or not vals then return {} end
    return vals
end
local function SafeCall(obj, method, ...)
    if not obj then return nil, "no obj" end
    local fn = obj[method]
    if type(fn) ~= "function" then return nil, "no method" end
    local ok, res = pcall(fn, obj, ...)
    if not ok then return nil, res end
    return res
end
local AuraRollKindMod = RequireEnum("TS", "types", "aura", "AuraRollKind")
local ROLL_KINDS = EnumValues(AuraRollKindMod and AuraRollKindMod.AuraRollKind)
local RecipeKindMod = RequireEnum("TS", "types", "recipe", "RecipeKind")
local RECIPE_KINDS = EnumValues(RecipeKindMod and RecipeKindMod.RecipeKind)
local RecipeKindConstants = RequireEnum("TS", "constants", "RecipeKindConstants")
local CodesConfigMod = RequireEnum("Configuration", "Codes")
local RecipeRegistry
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("TS", 5):WaitForChild("registry", 5):WaitForChild("RecipeRegistry", 5))
    end)
    if ok and mod and mod.RecipeRegistry then RecipeRegistry = mod.RecipeRegistry end
end
local ExplorationDifficultyMod = RequireEnum("TS", "types", "exploration", "ExplorationDifficulty")
local EXPLORATION_DIFFICULTIES = EnumValues(ExplorationDifficultyMod and ExplorationDifficultyMod.ExplorationDifficulty)
local ExplorationDifficultyConstants = RequireEnum("TS", "constants", "ExplorationDifficultyConstants")
local ExplorationRegistry
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("TS", 5):WaitForChild("registry", 5):WaitForChild("ExplorationRegistry", 5))
    end)
    if ok and mod and mod.ExplorationRegistry then ExplorationRegistry = mod.ExplorationRegistry end
end
local ItemKindMod = RequireEnum("TS", "types", "item", "ItemKind")
local ITEM_KINDS = EnumValues(ItemKindMod and ItemKindMod.ItemKind)
local ItemKindConstants = RequireEnum("TS", "constants", "ItemKindConstants")
local StatModifierSourceMod = RequireEnum("TS", "types", "stat", "StatModifierSource")
local StatModifierSource = StatModifierSourceMod and StatModifierSourceMod.StatModifierSource
local ItemRegistry
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("TS", 5):WaitForChild("registry", 5):WaitForChild("ItemRegistry", 5))
    end)
    if ok and mod and mod.ItemRegistry then ItemRegistry = mod.ItemRegistry end
end
local GamePassKindMod = RequireEnum("TS", "types", "gamepass", "GamePassKind")
local GAMEPASS_KINDS = EnumValues(GamePassKindMod and GamePassKindMod.GamePassKind)
local UpgradeRegistry
do
    local ok, mod = pcall(function()
        return require(RS:WaitForChild("TS", 5):WaitForChild("registry", 5):WaitForChild("UpgradeRegistry", 5))
    end)
    if ok and mod and mod.UpgradeRegistry then UpgradeRegistry = mod.UpgradeRegistry end
end
local function Display(kind, key)
    local t = ({ RecipeKind = RecipeKindConstants, ExplorationDifficulty = ExplorationDifficultyConstants, ItemKind = ItemKindConstants })[kind]
    if not t then return key end
    local dn = t.DISPLAY_NAMES
    if dn and dn[key] then return dn[key] end
    return key
end
local function RecipeLabel(recipe)
    local id = SafeCall(recipe, "getId") or "?"
    local name = SafeCall(recipe, "getName") or id
    local kind = SafeCall(recipe, "getKind") or "Potion"
    return ("[%s] %s"):format(Display("RecipeKind", kind), name), id
end
local function ExplorationLabel(exp)
    local id = SafeCall(exp, "getId") or "?"
    local name = SafeCall(exp, "getName") or id
    return name, id
end
local function BuildRecipeList(filterKind)
    local labels, labelToId, ids = {}, {}, {}
    if not RecipeRegistry then return labels, labelToId, ids end
    local ok, all = pcall(function() return RecipeRegistry:getAll() end)
    if not ok or not all then return labels, labelToId, ids end
    for _, recipe in ipairs(all) do
        local k = SafeCall(recipe, "getKind")
        if (not filterKind or filterKind == "All" or k == filterKind) and k then
            local label, id = RecipeLabel(recipe)
            if id and id ~= "?" then
                table.insert(labels, label)
                labelToId[label] = id
                ids[id] = label
            end
        end
    end
    table.sort(labels)
    return labels, labelToId, ids
end
local function BuildExplorationList()
    local labels, labelToId = {}, {}
    if not ExplorationRegistry then return labels, labelToId end
    local ok, all = pcall(function() return ExplorationRegistry:getContent() end)
    if not ok or not all then return labels, labelToId end
    for _, exp in ipairs(all) do
        local label, id = ExplorationLabel(exp)
        if id and id ~= "?" then
            table.insert(labels, label)
            labelToId[label] = id
        end
    end
    table.sort(labels)
    return labels, labelToId
end
local function BuildOwnedItemList(kind)
    local labels, labelToId = {}, {}
    if not ClientUser then return labels, labelToId end
    local storage = SafeCall(ClientUser, "getStorage")
    if not storage then return labels, labelToId end
    local ok, items = pcall(function() return storage:getSortedContentByKind(kind) end)
    if not ok or not items then return labels, labelToId end
    for _, item in ipairs(items) do
        local name = (item.content and item.content.id) or "?"
        local uid = item.uid
        if uid then
            table.insert(labels, name)
            labelToId[name] = uid
        end
    end
    return labels, labelToId
end
local function BuildCatalogItemList(kind)
    local labels, labelToId = {}, {}
    if not ItemRegistry then return labels, labelToId end
    local ok, items = pcall(function() return ItemRegistry:getContentByKind(kind) end)
    if not ok or not items then return labels, labelToId end
    for _, item in ipairs(items) do
        local id = SafeCall(item, "getId")
        local name = SafeCall(item, "getName") or id
        if id then
            table.insert(labels, name)
            labelToId[name] = id
        end
    end
    table.sort(labels)
    return labels, labelToId
end
local Aura = {
    isRolling = false,
    isDiceRolling = false,
    isCrafting = false,
    isEnchanting = false,
    session = {
        aurasRolled = 0,
        aurasMinted = 0,
        diceRolled = 0,
        crystalsRedeemed = 0,
        upgradesBought = 0,
        recipesCrafted = 0,
        explorationsClaimed = 0,
        potionsUsed = 0,
        charsFed = 0,
        enchantsCast = 0,
        codesRedeemed = 0,
        prismBuys = 0,
        claimsSwept = 0,
        lastRollAt = 0,
        lastDiceAt = 0,
        lastRedeemAt = 0,
        lastUpgradeAt = 0,
        lastCraftAt = 0,
        lastExploreAt = 0,
        lastPotionAt = 0,
        lastFeedAt = 0,
        lastEnchantAt = 0,
        lastClaimSweepAt = 0,
    },
}
local Get, Send, Func
local GetCraftSelection, GetExploreSelection, GetPotionSelection
local CraftLabelToId, CraftLabelBase = {}, {}
local ExploreLabelToId, ExploreLabelBase = {}, {}
local PotionLabelToId, PotionLabelBase = {}, {}
local EnchantLabelToId = {}
Get = {
    AuraRollTicket = function() return GetCurrency("AuraRollTicket") end,
    AuraLuckyRollTicket = function() return GetCurrency("AuraLuckyRollTicket") end,
    Prism = function() return GetCurrency("Prism") end,
    OwnedPlot = function()
        for _, m in ipairs(CollectionService:GetTagged("Plot")) do
            if m:IsA("Model") and m:GetAttribute("OwnerUserId") == Plr.UserId then
                return m
            end
        end
        return nil
    end,
    CrystalRedeemBase = function()
        local p = Get.OwnedPlot()
        if not p then return nil end
        return p:GetAttribute("CrystalRedeemBase")
    end,
    CraftCooldown = function(recipeId)
        if not ClientUser then return 0 end
        local crafting = SafeCall(ClientUser, "getCrafting")
        if not crafting then return 0 end
        local ok, v = pcall(crafting.getCooldownRemaining, crafting, recipeId)
        return (ok and v) or 0
    end,
    EquippedCharUids = function()
        if not ClientUser then return {} end
        local plot = SafeCall(ClientUser, "getPlot")
        if not plot then return {} end
        local ok, uids = pcall(function() return plot:getEquippedUidsInSlotOrder() end)
        if not ok or not uids then return {} end
        return uids
    end,
    BestUnequippedCharUids = function(count)
        if not ClientUser then return {} end
        local storage = SafeCall(ClientUser, "getStorage")
        if not storage then return {} end
        local ok, items = pcall(function() return storage:getSortedContentByKind("Character") end)
        if not ok or not items then return {} end
        local equipped = {}
        for _, uid in ipairs(Get.EquippedCharUids()) do equipped[uid] = true end
        local out = {}
        for _, item in ipairs(items) do
            local uid = item.uid
            if uid and not equipped[uid] then
                table.insert(out, uid)
                if count and #out >= count then break end
            end
        end
        return out
    end,
    Sessions = function()
        if not ClientUser then return {} end
        local ex = SafeCall(ClientUser, "getExploration")
        if not ex then return {} end
        local ok, s = pcall(function() return ex:getRawSessions() end)
        return (ok and s) or {}
    end,
    PartySizeCap = function()
        if not ClientUser then return 99 end
        local ex = SafeCall(ClientUser, "getExploration")
        if not ex then return 99 end
        local ok, n = pcall(function() return ex:getPartySizeCapacity() end)
        return (ok and type(n) == "number" and n) or 99
    end,
    ClaimableQuestIds = function()
        local out = {}
        if not ClientUser then return out end
        local q = SafeCall(ClientUser, "getQuest")
        if not q then return out end
        local ok, all = pcall(function() return q:getAll() end)
        if not ok or not all then return out end
        for _, inst in ipairs(all) do
            local okC, claimable = pcall(function() return inst:isClaimable() end)
            if okC and claimable then
                local id = (inst.quest and inst.quest.uid) or inst.uid
                if id then table.insert(out, id) end
            end
        end
        return out
    end,
    OwnedUidByContentId = function(kind, contentId)
        if not ClientUser or not contentId then return nil end
        local storage = SafeCall(ClientUser, "getStorage")
        if not storage then return nil end
        local ok, items = pcall(function() return storage:getSortedContentByKind(kind) end)
        if not ok or not items then return nil end
        for _, item in ipairs(items) do
            if item.content and item.content.id == contentId and item.uid then
                return item.uid
            end
        end
        return nil
    end,
    PotionActive = function(contentId)
        if not ClientUser or not contentId or not StatModifierSource then return false end
        local stats = SafeCall(ClientUser, "getStats")
        if not stats then return false end
        local ok, active = pcall(function()
            return stats:isSourceActive(StatModifierSource.Potion, contentId)
        end)
        return ok and active or false
    end,
    BestFoodForChar = function(charUid)
        if not ClientUser or not charUid or not StatModifierSource then return nil end
        local storage = SafeCall(ClientUser, "getStorage")
        if not storage then return nil end
        local ok, items = pcall(function() return storage:getSortedContentByKind("Food") end)
        if not ok or not items then return nil end
        local charStats = SafeCall(ClientUser, "getCharacterStats")
        if not charStats then return nil end
        for _, item in ipairs(items) do
            local uid = item.uid
            local contentId = item.content and item.content.id
            if uid and contentId then
                local ok2, active = pcall(function()
                    return charStats:isSourceActive(charUid, StatModifierSource.Food, contentId)
                end)
                if ok2 and not active then
                    return uid
                end
            end
        end
        return nil
    end,
}
Send = {
    RollAura = function(kind)
        local r = Remotes.AuraRollRequest
        if r then pcall(function() r:FireServer(kind or "Standard") end) end
    end,
    RollDice = function()
        local r = Remotes.DiceRollRequest
        if r then pcall(function() r:FireServer() end) end
    end,
    RedeemCrystal = function(code)
        local r = Remotes.PlotCrystalDropRedeemRequest
        if r then pcall(function() r:FireServer(code) end) end
    end,
    EquipBest = function()
        local r = Remotes.EquipBestCharactersRequest
        if r then pcall(function() r:FireServer() end) end
    end,
    BuyUpgrade = function(key)
        local r = Remotes.UpgradeRequest
        if r then pcall(function() r:FireServer(key) end) end
    end,
    Craft = function(recipeId, multiplier)
        local r = Remotes.CraftRequest
        if not r then notyuri("[Send.Craft] CraftRequest remote missing") return end
        local ok, err = pcall(function() r:FireServer(recipeId, {}, multiplier or 1) end)
        if not ok then notyuri("[Send.Craft] FireServer error:", err) end
    end,
    ExploreDeploy = function(expId, party)
        local r = Remotes.ExplorationDeployRequest
        if not r then notyuri("[Send.ExploreDeploy] ExplorationDeployRequest remote missing") return end
        local ok, err = pcall(function() r:FireServer(expId, party or {}) end)
        if not ok then notyuri("[Send.ExploreDeploy] FireServer error:", err) end
    end,
    ExploreStart = function(expId, difficulty)
        local r = Remotes.ExplorationStartRequest
        if not r then notyuri("[Send.ExploreStart] ExplorationStartRequest remote missing") return end
        local ok, err = pcall(function() r:FireServer(expId, difficulty or "Easy", true) end)
        if not ok then notyuri("[Send.ExploreStart] FireServer error:", err) end
    end,
    ExploreClaim = function(expId)
        local r = Remotes.ExplorationClaimRequest
        if not r then notyuri("[Send.ExploreClaim] ExplorationClaimRequest remote missing") return end
        local ok, err = pcall(function() r:FireServer(expId) end)
        if not ok then notyuri("[Send.ExploreClaim] FireServer error:", err) end
    end,
    UseItem = function(uid, amount)
        local r = Remotes.ItemUseRequest
        if r then pcall(function() r:FireServer(uid, amount or 1) end) end
    end,
    FeedChar = function(foodUid, charUid, amount)
        local r = Remotes.UseFoodOnCharacterRequest
        if r then pcall(function() r:FireServer(foodUid, charUid, amount or 1) end) end
    end,
    Enchant = function(charUid)
        local r = Remotes.EnchantRequest
        if r then pcall(function() r:FireServer(charUid) end) end
    end,
    ClaimMailAll = function()
        local r = Remotes.MailClaimAllRequest
        if r then pcall(function() r:FireServer() end) end
    end,
    ClaimOffline = function()
        local r = Remotes.OfflineEarningClaimRequest
        if r then pcall(function() r:FireServer() end) end
    end,
    ClaimIndexMilestones = function()
        local r = Remotes.IndexClaimAllMilestonesRequest
        if r then pcall(function() r:FireServer() end) end
    end,
    ClaimQuest = function(questId)
        local r = Remotes.QuestClaimRequest
        if r then pcall(function() r:FireServer(questId) end) end
    end,
    ClaimQuestDailyBonus = function()
        local r = Remotes.QuestDailyBonusClaimRequest
        if r then pcall(function() r:FireServer() end) end
    end,
    ClaimGroupFavorite = function()
        local r = Remotes.GroupAndFavoriteRewardClaimRequest
        if r then pcall(function() r:FireServer() end) end
    end,
    RedeemCode = function(code)
        local r = Remotes.CodeRedeemRequest
        if r then pcall(function() r:FireServer(code) end) end
    end,
    BuyPrism = function(productKind, kind)
        local r = Remotes.ProductPrismPurchaseRequest
        if r then
            local payload = { productKind = productKind }
            if productKind == "GamePass" then payload.gamePassKind = kind
            else payload.developerProductKind = kind end
            pcall(function() r:FireServer(payload) end)
        end
    end,
}
Func = {
    AutoRollAura = function()
        local lastFire = 0
        while Toggles.AutoRollAura and Toggles.AutoRollAura.Value do
            if Aura.isRolling then
                if os.clock() - lastFire > 5 then Aura.isRolling = false end
                task.wait(0.1)
            else
                local tickets = Get.AuraRollTicket()
                if tickets <= 0 and ClientUser then
                    task.wait(1)
                else
                    Aura.isRolling = true
                    lastFire = os.clock()
                    Send.RollAura("Standard")
                    Aura.session.aurasRolled = Aura.session.aurasRolled + 1
                    Aura.session.lastRollAt = lastFire
                    task.wait(.1)
                end
            end
        end
    end,
    AutoRollDice = function()
        local lastFire = 0
        while Toggles.AutoRollDice and Toggles.AutoRollDice.Value do
            if Aura.isDiceRolling then
                if os.clock() - lastFire > 5 then Aura.isDiceRolling = false end
                task.wait(0.1)
            else
                Aura.isDiceRolling = true
                lastFire = os.clock()
                Send.RollDice()
                Aura.session.diceRolled = Aura.session.diceRolled + 1
                Aura.session.lastDiceAt = lastFire
                task.wait(1)
            end
        end
    end,
    AutoEquip = function()
        while Toggles.AutoEquip and Toggles.AutoEquip.Value do
            Send.EquipBest()
            task.wait(2)
        end
    end,
    AutoUpgrade = function()
        while Toggles.AutoUpgrade and Toggles.AutoUpgrade.Value do
            if UpgradeRegistry and ClientUser then
                local ok, userUpgrades = pcall(function() return ClientUser:getUpgrades() end)
                if ok and userUpgrades then
                    local picked, pickedCost = nil, nil
                    local ok2, nodes = pcall(function() return UpgradeRegistry:getEnabled() end)
                    if ok2 and nodes then
                        for _, node in ipairs(nodes) do
                            local okCan, canResult = pcall(function() return userUpgrades:canUpgrade(node:getKind()) end)
                            if okCan and canResult and canResult.success then
                                local okCost, cost = pcall(function()
                                    return userUpgrades:getCostAtLevel(node, userUpgrades:getLevel(node:getKind()))
                                end)
                                local costAmount = (okCost and cost) or 0
                                if pickedCost == nil or costAmount < pickedCost then
                                    picked = node:getKind()
                                    pickedCost = costAmount
                                end
                            end
                        end
                    end
                    if picked then
                        Send.BuyUpgrade(picked)
                        Aura.session.upgradesBought = Aura.session.upgradesBought + 1
                        Aura.session.lastUpgradeAt = os.clock()
                    end
                end
            end
            task.wait()
        end
    end,
    AutoCraft = function()
        while Toggles.AutoCraft and Toggles.AutoCraft.Value do
            local ids = GetCraftSelection and GetCraftSelection() or {}
            local rawMult = (Options.CraftMultiplier and Options.CraftMultiplier.Value) or 1
            local mult = tonumber(rawMult) or 1
            local count = 0
            for _ in pairs(ids) do count = count + 1 end
            notyuri("[AutoCraft] selection count:", count, "rawMult:", rawMult, "mult:", mult)
            local any = false
            for recipeId, _ in pairs(ids) do
                if recipeId ~= "All" then
                    local cd = Get.CraftCooldown(recipeId)
                    notyuri("[AutoCraft] recipeId:", recipeId, "cooldown:", cd)
                    if cd <= 0 then
                        notyuri("[AutoCraft] firing Craft", recipeId, mult)
                        Send.Craft(recipeId, mult)
                        Aura.session.recipesCrafted = Aura.session.recipesCrafted + (mult or 1)
                        Aura.session.lastCraftAt = os.clock()
                        any = true
                        task.wait(.2)
                    else
                        any = true
                    end
                end
            end
            task.wait(.1)
        end
    end,
    AutoExplore = function()
        while Toggles.AutoExplore and Toggles.AutoExplore.Value do
            local diff = (Options.ExploreDifficulty and Options.ExploreDifficulty.Value) or "Easy"
            local ids = GetExploreSelection and GetExploreSelection() or {}
            local cap = Get.PartySizeCap()
            local party = Get.BestUnequippedCharUids(cap and cap > 0 and cap or nil)
            local sessions = Get.Sessions()
            local selCount = 0
            for _ in pairs(ids) do selCount = selCount + 1 end
            notyuri("[AutoExplore] selection count:", selCount, "diff:", diff, "cap:", cap, "party size:", #party)
            local any = false
            for expId, _ in pairs(ids) do
                if expId ~= "All" then
                    local sess = sessions[expId]
                    if not sess then
                        notyuri("[AutoExplore] expId:", expId, "no session, party:", #party)
                        if #party > 0 then
                            notyuri("[AutoExplore] firing ExploreDeploy+ExploreStart", expId, diff)
                            Send.ExploreDeploy(expId, party)
                            task.wait(0.3)
                            Send.ExploreStart(expId, diff)
                            Aura.session.lastExploreAt = os.clock()
                        end
                        any = true
                    elseif sess.result ~= nil then
                        notyuri("[AutoExplore] firing ExploreClaim", expId)
                        Send.ExploreClaim(expId)
                        Aura.session.explorationsClaimed = Aura.session.explorationsClaimed + 1
                        Aura.session.lastExploreAt = os.clock()
                        any = true
                        task.wait(0.3)
                    elseif sess.startedAt == nil then
                        notyuri("[AutoExplore] firing ExploreStart (deployed, not started)", expId, diff)
                        Send.ExploreStart(expId, diff)
                        Aura.session.lastExploreAt = os.clock()
                        any = true
                    else
                        notyuri("[AutoExplore] expId:", expId, "already running, endsAt:", sess.endsAt)
                        any = true
                    end
                end
            end
            task.wait(any and 2 or 5)
        end
    end,
    AutoPotion = function()
        while Toggles.AutoPotion and Toggles.AutoPotion.Value do
            local ids = GetPotionSelection and GetPotionSelection() or {}
            for contentId, _ in pairs(ids) do
                if not Get.PotionActive(contentId) then
                    local uid = Get.OwnedUidByContentId("Potion", contentId)
                    if uid then
                        Send.UseItem(uid, 1)
                        Aura.session.potionsUsed = Aura.session.potionsUsed + 1
                        Aura.session.lastPotionAt = os.clock()
                        task.wait(0.15)
                    end
                end
            end
            task.wait(2)
        end
    end,
    AutoFeed = function()
        while Toggles.AutoFeed and Toggles.AutoFeed.Value do
            local chars = Get.EquippedCharUids()
            for _, charUid in ipairs(chars) do
                local foodUid = Get.BestFoodForChar(charUid)
                if foodUid then
                    Send.FeedChar(foodUid, charUid, 1)
                    Aura.session.charsFed = Aura.session.charsFed + 1
                    task.wait(0.12)
                end
            end
            Aura.session.lastFeedAt = os.clock()
            task.wait(1)
        end
    end,
    AutoEnchant = function()
        while Toggles.AutoEnchant and Toggles.AutoEnchant.Value do
            local eSel = (Options.EnchantTarget and Options.EnchantTarget.Value) or ""
            local charUid = EnchantLabelToId[eSel]
            if charUid and charUid ~= "" then
                Aura.isEnchanting = true
                Send.Enchant(charUid)
                Aura.session.enchantsCast = Aura.session.enchantsCast + 1
                Aura.session.lastEnchantAt = os.clock()
            end
            task.wait(.5)
        end
    end,
    AutoClaimAll = function()
        while Toggles.AutoClaimAll and Toggles.AutoClaimAll.Value do
            pcall(Send.ClaimMailAll)
            task.wait(0.2)
            pcall(Send.ClaimOffline)
            task.wait(0.2)
            pcall(Send.ClaimIndexMilestones)
            task.wait(0.2)
            pcall(Send.ClaimQuestDailyBonus)
            task.wait(0.2)
            pcall(Send.ClaimGroupFavorite)
            task.wait(0.2)
            for _, qid in ipairs(Get.ClaimableQuestIds()) do
                pcall(Send.ClaimQuest, qid)
                task.wait(0.15)
            end
            Aura.session.claimsSwept = Aura.session.claimsSwept + 1
            Aura.session.lastClaimSweepAt = os.clock()
            task.wait(math.max(10, (Options.ClaimDelay and Options.ClaimDelay.Value) or 60))
        end
    end,
    AutoRedeemCodes = function()
        while Toggles.AutoRedeemCodes and Toggles.AutoRedeemCodes.Value do
            local raw = (Options.CodesInput and Options.CodesInput.Value) or ""
            local codes = {}
            for code in raw:gmatch("[^,%s\n\r]+") do
                table.insert(codes, code)
            end
            for _, code in ipairs(codes) do
                if code ~= "" then
                    Send.RedeemCode(code)
                    Aura.session.codesRedeemed = Aura.session.codesRedeemed + 1
                    task.wait(0.4)
                end
            end
            task.wait(5)
        end
    end,
    RedeemAllCodes = function()
        if not CodesConfigMod or not CodesConfigMod.Codes or not CodesConfigMod.Codes.Content then
            notyuri("[RedeemAllCodes] Configuration.Codes module unavailable")
            return
        end
        for _, entry in ipairs(CodesConfigMod.Codes.Content) do
            local code = entry.Code
            if code and code ~= "" then
                Send.RedeemCode(code)
                Aura.session.codesRedeemed = Aura.session.codesRedeemed + 1
                task.wait(0.4)
            end
        end
    end,
    AutoBuyPrism = function()
        while Toggles.AutoBuyPrism and Toggles.AutoBuyPrism.Value do
            local kind = (Options.PrismProduct and Options.PrismProduct.Value) or ""
            if kind ~= "" then
                local threshold = (Options.PrismThreshold and Options.PrismThreshold.Value) or 0
                local prism = Get.Prism()
                if prism >= threshold and threshold > 0 then
                    Send.BuyPrism("GamePass", kind)
                    Aura.session.prismBuys = Aura.session.prismBuys + 1
                    task.wait(2)
                end
            end
            task.wait(5)
        end
    end,
}
TB_Tabs.Autofarm.T1:AddToggle("AutoRollAura", { Text = "Auto Roll Aura", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRollDice", { Text = "Auto Roll Dice", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCraft", { Text = "Auto Craft", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoExplore", { Text = "Auto Explore", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPotion", { Text = "Auto Potion", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoFeed", { Text = "Auto Feed", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoClaimAll", { Text = "Auto Claim All", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEnchant", { Text = "Auto Enchant", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("EnchantTarget", { Text = "Enchant Target", Values = {}, Default = "" })
GetCraftSelection = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "CraftRecipes", { Text = "Recipes", label = CraftLabelToId, Values = CraftLabelBase })
TB_Tabs.Autofarm2.T1:AddDropdown("ExploreDifficulty", { Text = "Explore Difficulty", Values = EXPLORATION_DIFFICULTIES, Default = "Easy" })
GetExploreSelection = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "ExploreTargets", { Text = "Expeditions", label = ExploreLabelToId, Values = ExploreLabelBase })
GetPotionSelection = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PotionSelect", { Text = "Potions", label = PotionLabelToId, Values = PotionLabelBase })
TB_Tabs.Autofarm2.T1:AddInput("CraftMultiplier", { Text = "Craft Multiplier", Default = "1" })
TB_Tabs.Autofarm2.T1:AddInput("ClaimDelay", { Text = "Claim Delay", Default = "60" })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Redeem All Codes", Func = function() Func.RedeemAllCodes() end })
local function PopulateCraftRecipes()
    if not (Options.CraftRecipes) then return end
    local labels, labelToId = BuildRecipeList("All")
    table.clear(CraftLabelToId)
    for k, v in pairs(labelToId) do CraftLabelToId[k] = v end
    table.clear(CraftLabelBase)
    for _, lab in ipairs(labels) do table.insert(CraftLabelBase, lab) end
    local values = { "All" }
    for _, lab in ipairs(labels) do table.insert(values, lab) end
    Options.CraftRecipes:SetValues(values)
end
local function PopulateExplorations()
    if not (Options.ExploreTargets) then return end
    local labels, labelToId = BuildExplorationList()
    table.clear(ExploreLabelToId)
    for k, v in pairs(labelToId) do ExploreLabelToId[k] = v end
    table.clear(ExploreLabelBase)
    for _, lab in ipairs(labels) do table.insert(ExploreLabelBase, lab) end
    local values = { "All" }
    for _, lab in ipairs(labels) do table.insert(values, lab) end
    Options.ExploreTargets:SetValues(values)
end
local function PopulateOwnedItems()
    if Options.EnchantTarget then
        local labels, labelToId = BuildOwnedItemList("Character")
        table.clear(EnchantLabelToId)
        for k, v in pairs(labelToId) do EnchantLabelToId[k] = v end
        Options.EnchantTarget:SetValues(labels)
    end
end
local function PopulateCatalogPotions()
    if not (Options.PotionSelect) then return end
    local labels, labelToId = BuildCatalogItemList("Potion")
    table.clear(PotionLabelToId)
    for k, v in pairs(labelToId) do PotionLabelToId[k] = v end
    table.clear(PotionLabelBase)
    for _, lab in ipairs(labels) do table.insert(PotionLabelBase, lab) end
    local values = { "All" }
    for _, lab in ipairs(labels) do table.insert(values, lab) end
    Options.PotionSelect:SetValues(values)
end
task.spawn(function()
    task.wait(2)
    PopulateCraftRecipes()
    PopulateExplorations()
    PopulateCatalogPotions()
    PopulateOwnedItems()
end)
task.spawn(function()
    while not Library.Unloaded do
        task.wait(15)
        PopulateOwnedItems()
    end
end)
Toggles.AutoRollAura:OnChanged(function()
    Thread("AutoRollAura", SafeLoop("AutoRollAura", Func.AutoRollAura), Toggles.AutoRollAura.Value)
end)
Toggles.AutoRollDice:OnChanged(function()
    Thread("AutoRollDice", SafeLoop("AutoRollDice", Func.AutoRollDice), Toggles.AutoRollDice.Value)
end)
Toggles.AutoEquip:OnChanged(function()
    Thread("AutoEquip", SafeLoop("AutoEquip", Func.AutoEquip), Toggles.AutoEquip.Value)
end)
Toggles.AutoUpgrade:OnChanged(function()
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func.AutoUpgrade), Toggles.AutoUpgrade.Value)
end)
Toggles.AutoCraft:OnChanged(function()
    Thread("AutoCraft", SafeLoop("AutoCraft", Func.AutoCraft), Toggles.AutoCraft.Value)
end)
Toggles.AutoExplore:OnChanged(function()
    Thread("AutoExplore", SafeLoop("AutoExplore", Func.AutoExplore), Toggles.AutoExplore.Value)
end)
Toggles.AutoPotion:OnChanged(function()
    Thread("AutoPotion", SafeLoop("AutoPotion", Func.AutoPotion), Toggles.AutoPotion.Value)
end)
Toggles.AutoFeed:OnChanged(function()
    Thread("AutoFeed", SafeLoop("AutoFeed", Func.AutoFeed), Toggles.AutoFeed.Value)
end)
Toggles.AutoEnchant:OnChanged(function()
    Thread("AutoEnchant", SafeLoop("AutoEnchant", Func.AutoEnchant), Toggles.AutoEnchant.Value)
end)
Toggles.AutoClaimAll:OnChanged(function()
    Thread("AutoClaimAll", SafeLoop("AutoClaimAll", Func.AutoClaimAll), Toggles.AutoClaimAll.Value)
end)
SafeConnect("CraftResult", function()
    return Remotes.CraftResult and Remotes.CraftResult.OnClientEvent
end, function()
    Aura.isCrafting = false
end)
SafeConnect("CraftRejected", function()
    return Remotes.CraftRejected and Remotes.CraftRejected.OnClientEvent
end, function()
    Aura.isCrafting = false
end)
SafeConnect("EnchantResult", function()
    return Remotes.EnchantResult and Remotes.EnchantResult.OnClientEvent
end, function()
    Aura.isEnchanting = false
end)
SafeConnect("EnchantRejected", function()
    return Remotes.EnchantRejected and Remotes.EnchantRejected.OnClientEvent
end, function()
    Aura.isEnchanting = false
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
SaveManager:SetFolder("Yuri/PA")
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
