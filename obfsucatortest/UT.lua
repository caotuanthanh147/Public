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
    PlayerDamaged = GetObject(RS, "Modules.Shared.Event.Remotes.PlayerDamaged"),
    RequestComboAdvance = GetObject(RS, "Modules.Shared.Event.Remotes.RequestComboAdvance"),
    ClientToServerCallback = GetObject(RS, "Modules.Shared.Event.Remotes.ClientToServerCallback"),
    AllocatePoints = GetObject(RS, "Modules.Shared.Event.Remotes.AllocatePoints"),
    DamageEntity = GetObject(RS, "Modules.Shared.Event.Remotes.DamageEntity"),
    RequestMeleeHitbox = GetObject(RS, "Modules.Shared.Event.Remotes.RequestMeleeHitbox"),
    OpenPartyMenu = GetObject(RS, "Modules.Shared.Event.Remotes.OpenPartyMenu"),
    PartyGo = GetObject(RS, "Modules.Shared.Event.Remotes.PartyGo"),
    SetGrindMode = GetObject(RS, "Modules.Shared.Event.Remotes.SetGrindMode"),
    BuyItem = GetObject(RS, "Modules.Shared.Event.Remotes.BuyItem"),
    ClaimIndexReward = GetObject(RS, "Modules.Shared.Event.Remotes.ClaimIndexReward"),
    QuestStart = GetObject(RS, "Modules.Shared.Event.Remotes.QuestStart"),
    QuestComplete = GetObject(RS, "Modules.Shared.Event.Remotes.QuestComplete"),
    PlayerUsedSpell = GetObject(RS, "Modules.Shared.Event.Remotes.PlayerUsedSpell"),
}
local Modules = {
}
local Flags = {}
local Shared = {
    LastHit = 0,
    SelectedTargets = {},
    Casting = false,
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
local PlayerDataFolder = RS:WaitForChild("PlayerData"):WaitForChild(tostring(Plr.UserId))
local StatPoints = PlayerDataFolder:WaitForChild("Points")
local StatAttributes = PlayerDataFolder:WaitForChild("Attributes")
local PlayerItems = PlayerDataFolder:WaitForChild("Items")
local IndexUnlocks = PlayerDataFolder:WaitForChild("IndexUnlocks")
local PlayerQuests = PlayerDataFolder:WaitForChild("Quests")
local QuestsActive = PlayerQuests:WaitForChild("Active")
local QuestsCompleted = PlayerQuests:WaitForChild("Completed")
local QuestLibrary = GetSafeModule(RS.Modules.Shared, "QuestLibrary")
local getQuestProgress = GetSafeModule(RS.Modules.Shared, "getQuestProgress")
local StatMaxAllocated = {
    Strength = 80,
    Constitution = 120,
    Intelligence = 120,
    Dexterity = 190,
}
local function Func_AutoStat()
    while Toggles.AutoStat.Value do
        task.wait(1)
        local statName = Options.StatSelected.Value
        local maxAllocated = StatMaxAllocated[statName]
        local currentAttr = StatAttributes:FindFirstChild(statName)
        local spent = currentAttr and currentAttr.Value or 0
        local points = StatPoints.Value
        if statName and points > 0 and (not maxAllocated or spent < maxAllocated) then
            local amount = maxAllocated and math.min(points, maxAllocated - spent) or points
            if amount > 0 then
                Remotes.AllocatePoints:InvokeServer(statName, amount)
            end
        end
    end
end
local MonsterInfoFolder = workspace:WaitForChild("Map"):WaitForChild("MonsterInfo")
local TrueLabFolder = workspace:WaitForChild("Teleports"):WaitForChild("True Lab")
local BossLabelToConfig = {}
local function GetBoss()
    table.clear(BossLabelToConfig)
    local list = {}
    local function scan(folder)
        for _, obj in ipairs(folder:GetDescendants()) do
            if obj:IsA("ModuleScript") and obj.Name == "Config" then
                local cfg = GetSafeModule(obj.Parent, "Config")
                if cfg and cfg.Party and cfg.Name and cfg.TP and cfg.MaxPartySize then
                    local label = string.format("%s [%s]", cfg.Name, tostring(cfg.Level))
                    if not BossLabelToConfig[label] then
                        BossLabelToConfig[label] = cfg
                        table.insert(list, {Label = label, Level = cfg.Level or 0})
                    end
                end
            end
        end
    end
    scan(MonsterInfoFolder)
    scan(TrueLabFolder)
    table.sort(list, function(a, b) return a.Level < b.Level end)
    local labels = {}
    for _, entry in ipairs(list) do
        table.insert(labels, entry.Label)
    end
    return labels
end
local function Func_AutoJoinBoss()
    while Toggles.AutoJoinBoss.Value do
        pcall(function()
            local label = Options.BossSelected.Value
            local cfg = label and BossLabelToConfig[label]
            if not cfg then return end
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - cfg.TP).Magnitude < 100 then return end
            Remotes.OpenPartyMenu:FireServer(cfg.Name, cfg.MaxPartySize)
            Remotes.PartyGo:FireServer(cfg.TP)
            Remotes.SetGrindMode:FireServer(true)
        end)
        task.wait(1)
    end
end
local MobsFolder = workspace:WaitForChild("Mobs")
local CollectionService = Services.CollectionService
local function GetMob()
    local MobLibrary = GetSafeModule(RS.Modules.Shared, "MobLibrary")
    if not MobLibrary then return {} end
    local list = {}
    for name, data in pairs(MobLibrary) do
        local levelRange = data.Config and data.Config.Level
        local level = levelRange and levelRange[1]
        local label = level and string.format("%s [%s]", name, tostring(level)) or name
        table.insert(list, {Label = label, Level = level or 0})
    end
    table.sort(list, function(a, b) return a.Level < b.Level end)
    local labels = {}
    for _, entry in ipairs(list) do
        table.insert(labels, entry.Label)
    end
    return labels
end
local ComboTbl = {
    Table = nil,   
    Order = {},    
    Count = 0,
    Index = 0,     
}
local function DoCombo(Combo)
    ComboTbl.Table = Combo
    ComboTbl.Index = 0
    ComboTbl.Order = {}
    ComboTbl.Count = 0
    if not Combo then return end
    for key in Combo do
        if type(key) == "number" then
            ComboTbl.Count = ComboTbl.Count + 1
        end
    end
    if Combo.Type == "Random" then
        local order = {}
        for i = 1, ComboTbl.Count do
            order[i] = i
        end
        for j = ComboTbl.Count, 2, -1 do
            local r = math.random(1, j)
            order[j], order[r] = order[r], order[j]
        end
        ComboTbl.Order = order
    else
        for i = 1, ComboTbl.Count do
            ComboTbl.Order[i] = i
        end
    end
end
local function AdvanceCombo(Combo, tool)
    if ComboTbl.Table ~= Combo then
        DoCombo(Combo)
    end
    if ComboTbl.Count == 0 then return end
    if ComboTbl.Index == 0 then
        DoCombo(Combo)
    end
    ComboTbl.Index = ComboTbl.Index + 1
    local cycle = ComboTbl.Order[ComboTbl.Index]
    Remotes.RequestComboAdvance:FireServer(cycle)
    Remotes.ClientToServerCallback:FireServer(tool.Name, "OnCombo", {
        tool,
        {
            Cycle = cycle,
            ComboData = Combo[cycle],
            ComboConfig = Combo,
            IsLastHit = ComboTbl.Index == ComboTbl.Count,
        },
    })
    if ComboTbl.Index >= ComboTbl.Count then
        ComboTbl.Index = 0
    end
end
local function DoHit()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then return end
    local ItemConfig = tool:FindFirstChild("ItemConfig") and GetSafeModule(tool, "ItemConfig")
    local toolType = ItemConfig and (ItemConfig.ToolType or ItemConfig.WeaponType)
    local hitboxSize = ItemConfig and ItemConfig.Hitbox and ItemConfig.Hitbox.Size
    if not hitboxSize then return end
    local range = math.max(hitboxSize.X, hitboxSize.Y, hitboxSize.Z)
    local mobsInRange = {}
    for _, mob in ipairs(MobsFolder:GetChildren()) do
        if CollectionService:HasTag(mob, "Mob") then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local mobRoot = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and mobRoot then
                local dist = (mobRoot.Position - hrp.Position).Magnitude
                if dist < range then
                    table.insert(mobsInRange, {mob, hum})
                end
            end
        end
    end
    if #mobsInRange == 0 then return end
    if tool and ItemConfig and ItemConfig.Combo then
        AdvanceCombo(ItemConfig.Combo, tool)
    end
    for _, entry in ipairs(mobsInRange) do
        local mob, hum = entry[1], entry[2]
        if hum.Parent and hum.Health > 0 then
            Remotes.DamageEntity:FireServer(mob, hum.MaxHealth, toolType or "Melee")
        end
    end
end
local function Func_AutoHit()
    while Toggles.AutoHit.Value do
        pcall(function()
            local char = GetCharacter()
            local tool = char and char:FindFirstChildWhichIsA("Tool")
            local ItemConfig = tool and tool:FindFirstChild("ItemConfig") and GetSafeModule(tool, "ItemConfig")
            local combo = ItemConfig and ItemConfig.Combo
            local Cooldown = (combo and combo.Cooldown) or (ItemConfig and ItemConfig.Cooldown) or 0.8
            local now = tick()
            if now - Shared.LastHit >= (Cooldown + .175) then
                Shared.LastHit = now
                DoHit()
            end
        end)
        task.wait(0.1)
    end
end
local SpellFolder = RS:WaitForChild("Items"):WaitForChild("Spell")
local Shared_SpellLastCast = {}
local function GetSpells()
    local names = {}
    for _, obj in ipairs(SpellFolder:GetChildren()) do
        if obj:IsA("Tool") then
            table.insert(names, obj.Name)
        end
    end
    table.sort(names)
    return names
end
local function GetNearestMob()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local myPos = hrp.Position
    local nearest, nearestDist = nil, math.huge
    for _, mob in ipairs(MobsFolder:GetChildren()) do
        if CollectionService:HasTag(mob, "Mob") then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local mobRoot = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and mobRoot then
                local dist = (mobRoot.Position - myPos).Magnitude
                if dist < nearestDist then
                    nearest = mob
                    nearestDist = dist
                end
            end
        end
    end
    return nearest
end
local function Func_AutoSpell()
    while Toggles.AutoSpell.Value do
        pcall(function()
            local selected = Options.SpellSelected.Value or {}
            local char = GetCharacter()
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            for spellName, active in pairs(selected) do
                if active then
                    local spellContainer = SpellFolder:FindFirstChild(spellName)
                    local ItemConfig = spellContainer and GetSafeModule(spellContainer, "ItemConfig")
                    local Cooldown = (ItemConfig and ItemConfig.Cooldown) or 1
                    local now = tick()
                    if now - (Shared_SpellLastCast[spellName] or 0) >= Cooldown then
                        local spellTool = Plr.Backpack:FindFirstChild(spellName) or char:FindFirstChild(spellName)
                        if spellTool then
                            local target = GetNearestMob()
                            if target then
                                local mobRoot = target:FindFirstChild("HumanoidRootPart")
                                if mobRoot then
                                    Shared_SpellLastCast[spellName] = now
                                    Shared.Casting = true
                                    local ok = pcall(function()
                                        hum:EquipTool(spellTool)
                                        task.wait(0.1)
                                        Remotes.PlayerUsedSpell:FireServer(spellTool, mobRoot.Position)
                                    end)
                                    Shared.Casting = false
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end
local function Func_KillAura()
    while Toggles.KillAura.Value do
        pcall(function()
            sethiddenproperty(Plr, "SimulationRadius", 11240)
            sethiddenproperty(Plr, "MaxSimulationRadius", 11240)
            local threshold = (Options.KillThreshold.Value or 75) / 100
            for _, mob in ipairs(MobsFolder:GetChildren()) do
                if CollectionService:HasTag(mob, "Mob") then
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 and hum.MaxHealth > 0 then
                        if hum.Health / hum.MaxHealth <= threshold then
                            hum.Health = 0
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end
local function GetWeapon()
    local names = {}
    local char = GetCharacter()
    local containers = {Plr.Backpack}
    if char then table.insert(containers, char) end
    for _, container in ipairs(containers) do
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and not table.find(names, tool.Name) then
                local cfg = GetSafeModule(tool, "ItemConfig")
                if cfg and cfg.WeaponType == "Melee" then
                    table.insert(names, tool.Name)
                end
            end
        end
    end
    return names
end
local function GetShopItems()
    local names = {}
    local ContentLibrary = GetSafeModule(RS.Modules.Shared, "ContentLibrary")
    if not ContentLibrary then return names end
    for itemType, items in pairs(ContentLibrary) do
        for itemName in pairs(items) do
            table.insert(names, itemName .. " [" .. itemType .. "]")
        end
    end
    table.sort(names)
    return names
end
local function BuyItemOnce()
    pcall(function()
        local selected = Options.ItemSelected.Value
        if not selected or selected == "" then return end
        local itemName, itemType = selected:match("^(.-) %[(.-)%]$")
        if not itemType or not itemName then return end
        local amount = tonumber(Options.BuyAmount.Value)
        if not amount or amount < 1 then return end
        Remotes.BuyItem:InvokeServer(itemType, itemName, amount)
    end)
end
local function Func_AutoBuy()
    while Toggles.AutoBuy.Value do
        task.wait(0.5)
        BuyItemOnce()
    end
end
local function Func_AutoIndex()
    while Toggles.AutoIndex.Value do
        task.wait(0.5)
        pcall(function()
            local ContentLibrary = GetSafeModule(RS.Modules.Shared, "ContentLibrary")
            local ItemUtils = GetSafeModule(RS.Modules.Shared, "ItemUtils")
            if not ContentLibrary or not ItemUtils then return end
            for itemType, items in pairs(ContentLibrary) do
                local ownedFolder = PlayerItems:FindFirstChild(itemType)
                for itemName, itemData in pairs(items) do
                    local cfg = itemData.Config
                    local rewards = cfg and cfg.Index and cfg.Index.Rewards
                    if rewards and #rewards > 0 then
                        local owned = ownedFolder and ItemUtils.FindItem(ownedFolder, itemName)
                        local claimed = IndexUnlocks:FindFirstChild(itemType .. "/" .. itemName) ~= nil
                        if owned and not claimed then
                            Remotes.ClaimIndexReward:InvokeServer(itemType, itemName)
                        end
                    end
                end
            end
        end)
    end
end
local QuestLabelToKey = {}
local function GetQuestList()
    table.clear(QuestLabelToKey)
    if not QuestLibrary then return {} end
    local seen = {}
    local list = {}
    for key, quest in pairs(QuestLibrary) do
        local id = quest.Id or quest.Name
        if quest.Name and id and not seen[id] then
            seen[id] = true
            local label = string.format("%s [Lv.%s]", quest.Name, tostring(quest.Level or "?"))
            QuestLabelToKey[label] = id
            table.insert(list, {Label = label, Level = quest.Level or 0})
        end
    end
    table.sort(list, function(a, b) return a.Level < b.Level end)
    local labels = {}
    for _, entry in ipairs(list) do
        table.insert(labels, entry.Label)
    end
    return labels
end
local function Func_AutoQuest()
    while Toggles.AutoQuest.Value do
        task.wait(1)
        pcall(function()
            if not QuestLibrary or not getQuestProgress then return end
            for label, active in pairs(Options.QuestSelected.Value) do
                if active then
                    local id = QuestLabelToKey[label]
                    local quest = id and QuestLibrary[id]
                    if quest then
                        local key = quest.Id or quest.Name
                        local alreadyCompleted = QuestsCompleted:FindFirstChild(key) ~= nil
                        local activeInstance = QuestsActive:FindFirstChild(key) or QuestsActive:FindFirstChild(quest.Name)
                        if activeInstance then
                            local progress = getQuestProgress(quest.Name)
                            if progress >= 1 then
                                Remotes.QuestComplete:InvokeServer(activeInstance.Name)
                            end
                        elseif not alreadyCompleted or quest.Repeatable then
                            Remotes.QuestStart:InvokeServer(quest.Id or quest.Name)
                        end
                    end
                end
            end
        end)
    end
end
local function Func_AutoEquip()
    while Toggles.AutoEquip.Value do
        pcall(function()
            if Shared.Casting then return end
            local selected = Options.WeaponSelected.Value
            if not selected or selected == "" then return end
            local char = GetCharacter()
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if char:FindFirstChild(selected) then return end
            local tool = Plr.Backpack:FindFirstChild(selected)
            if tool then
                hum:EquipTool(tool)
            end
        end)
        task.wait(0.5)
    end
end
local function Func_Autofarm()
    local heartbeatConn
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not Toggles.Autofarm.Value then
            heartbeatConn:Disconnect()
            return
        end
        pcall(function()
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local tool = char:FindFirstChildWhichIsA("Tool")
            if not tool then return end
            local ItemConfig = tool:FindFirstChild("ItemConfig") and GetSafeModule(tool, "ItemConfig")
            local hitboxSize = ItemConfig and ItemConfig.Hitbox and ItemConfig.Hitbox.Size
            if not hitboxSize then return end
            local meleeRange = math.max(hitboxSize.X, hitboxSize.Y, hitboxSize.Z)
            local searchRange = tonumber(Options.FarmRange.Value) or 200
            local hasTargets = next(Shared.SelectedTargets) ~= nil
            local nearestMob, nearestRoot, nearestDist = nil, nil, searchRange
            for _, mob in ipairs(MobsFolder:GetChildren()) do
                if CollectionService:HasTag(mob, "Mob") then
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and mobRoot then
                        local matchesTarget = true
                        if hasTargets then
                            local mobConfig = GetSafeModule(mob, "MobConfig")
                            local mobName = mobConfig and (mobConfig.Name or mob.Name) or mob.Name
                            matchesTarget = Shared.SelectedTargets[mobName] == true
                        end
                        if matchesTarget then
                            local dist = (mobRoot.Position - hrp.Position).Magnitude
                            if dist <= nearestDist then
                                nearestMob, nearestRoot, nearestDist = mob, mobRoot, dist
                            end
                        end
                    end
                end
            end
            if not nearestMob then return end
            local farmPos = Options.FarmPosition and Options.FarmPosition.Value or "Behind"
            local targetPos = nearestRoot.Position
            local destination
            if farmPos == "Above" then
                destination = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            elseif farmPos == "Below" then
                destination = CFrame.new(targetPos + Vector3.new(0, -3, 0))
            else
                destination = nearestRoot.CFrame * CFrame.new(0, 0, 3)
            end
            hrp.CFrame = destination
            local combo = ItemConfig and ItemConfig.Combo
            local Cooldown = (combo and combo.Cooldown) or (ItemConfig and ItemConfig.Cooldown) or 0.8
            local now = tick()
            if now - Shared.LastHit >= (Cooldown + .175) then
                Shared.LastHit = now
                local hum = nearestMob:FindFirstChildOfClass("Humanoid")
                if hum and hum.Parent and hum.Health > 0 then
                    local toolType = ItemConfig and (ItemConfig.ToolType or ItemConfig.WeaponType)
                    if ItemConfig and ItemConfig.Combo then
                        AdvanceCombo(ItemConfig.Combo, tool)
                    end
                    Remotes.DamageEntity:FireServer(nearestMob, 1, toolType or "Melee")
                end
            end
        end)
    end)
    while Toggles.Autofarm.Value do
        task.wait(1)
    end
    if heartbeatConn then
        heartbeatConn:Disconnect()
    end
end
local LocalHumanoid = nil
local function UpdateLocalHumanoidCache(char)
    char = char or Plr.Character
    LocalHumanoid = char and char:FindFirstChildOfClass("Humanoid") or nil
end
UpdateLocalHumanoidCache()
Plr.CharacterAdded:Connect(UpdateLocalHumanoidCache)
if hookmetamethod then
    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" then
            if self == Remotes.PlayerDamaged and Toggles.Invincible and Toggles.Invincible.Value then
                return
            end
        elseif method == "TakeDamage" then
            if self == LocalHumanoid and Toggles.Invincible and Toggles.Invincible.Value then
                return
            end
        end
        return OldNamecall(self, ...)
    end))
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
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip" })
TB_Tabs.Autofarm2.T1:AddDropdown("WeaponSelected", {
    Text = "Select Weapon",
    Values = GetWeapon(),
    Default = "",
    Multi = false,
    Searchable = true,
})
Plr.Backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        Options.WeaponSelected:SetValues(GetWeapon())
    end
end)
TB_Tabs.Autofarm2.T1:AddDropdown("BossSelected", {
    Text = "Select Boss",
    Values = GetBoss(),
    Default = "",
    Multi = false,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoJoinBoss", { Text = "Auto Join Boss" })
TB_Tabs.Autofarm.T1:AddToggle("AutoHit", { Text = "Auto Hit" })
TB_Tabs.Autofarm2.T1:AddDropdown("SpellSelected", {
    Text = "Select Spell",
    Values = GetSpells(),
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoSpell", { Text = "Auto Spell" })
TB_Tabs.Autofarm.T1:AddToggle("KillAura", { Text = "Kill Aura" })
TB_Tabs.Autofarm2.T1:AddSlider("KillThreshold", { Text = "Kill Threshold", Default = 75, Min = 0, Max = 100, Rounding = 0 })
TB_Tabs.Autofarm.T1:AddToggle("Autofarm", { Text = "Autofarm" })
TB_Tabs.Autofarm2.T1:AddSlider("FarmRange", { Text = "Farm Range", Default = 200, Min = 0, Max = 2000, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddDropdown("FarmPosition", {
    Text = "Farm Position",
    Values = { "Above", "Below", "Behind" },
    Default = "Behind",
    Multi = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("FarmTarget", {
    Text = "Farm Target",
    Values = GetMob(),
    Default = {},
    Multi = true,
    Searchable = true,
})
Options.FarmTarget:OnChanged(function()
    table.clear(Shared.SelectedTargets)
    for label, active in pairs(Options.FarmTarget.Value) do
        if active then
            local name = label:match("^(.-) %[.-%]$") or label
            Shared.SelectedTargets[name] = true
        end
    end
end)
TB_Tabs.Autofarm.T1:AddToggle("Invincible", { Text = "Invincible", Disabled = typeof(hookmetamethod) ~= "function" })
TB_Tabs.Autofarm2.T1:AddDropdown("StatSelected", {
    Values = { "Strength", "Constitution", "Intelligence", "Dexterity" },
    Default = "Strength",
    Text = "Stat To Allocate",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoStat", { Text = "Auto Stat" })
TB_Tabs.Autofarm2.T1:AddDropdown("ItemSelected", {
    Text = "Select Item",
    Values = GetShopItems(),
    Default = "",
    Multi = false,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddInput("BuyAmount", {
    Default = "1",
    Text = "Buy Amount",
    Callback = function(val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy", { Text = "Auto Buy" })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Buy Item", Func = BuyItemOnce })
TB_Tabs.Autofarm.T1:AddToggle("AutoIndex", { Text = "Auto Index" })
TB_Tabs.Autofarm2.T1:AddDropdown("QuestSelected", {
    Text = "Select Quest",
    Values = GetQuestList(),
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoQuest", { Text = "Auto Quest" })
Toggles.AutoEquip:OnChanged(function(state)
    Thread("AutoEquip", Func_AutoEquip, state)
end)
Toggles.AutoStat:OnChanged(function(state)
    Thread("AutoStat", Func_AutoStat, state)
end)
Toggles.AutoBuy:OnChanged(function(state)
    Thread("AutoBuy", Func_AutoBuy, state)
end)
Toggles.AutoIndex:OnChanged(function(state)
    Thread("AutoIndex", Func_AutoIndex, state)
end)
Toggles.AutoQuest:OnChanged(function(state)
    Thread("AutoQuest", Func_AutoQuest, state)
end)
Toggles.AutoJoinBoss:OnChanged(function(state)
    Thread("AutoJoinBoss", Func_AutoJoinBoss, state)
end)
Toggles.AutoHit:OnChanged(function(state)
    Thread("AutoHit", Func_AutoHit, state)
end)
Toggles.AutoSpell:OnChanged(function(state)
    if not state then Shared.Casting = false end
    Thread("AutoSpell", Func_AutoSpell, state)
end)
Toggles.KillAura:OnChanged(function(state)
    Thread("KillAura", Func_KillAura, state)
end)
Toggles.Autofarm:OnChanged(function(state)
    Thread("Autofarm", Func_Autofarm, state)
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
SaveManager:SetFolder("Yuri/SCX")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
task.defer(function()
    SaveManager:LoadAutoloadConfig()
end)
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