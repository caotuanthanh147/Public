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
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local executorName = executorDisplayName:lower()
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = executorName:find("xeno") ~= nil
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
local function yuri()
end
local function DoRejoin()
    local renameArgs = {
        1,
        [2] = '\128\237\191\191\0',
    }
    RS:WaitForChild("Events"):WaitForChild("RenamePassiveLoadout"):FireServer(unpack(renameArgs))
    task.wait()
    local failConn
    failConn = TeleportService.TeleportInitFailed:Connect(function(player, result, errorMessage)
        failConn:Disconnect()
        task.wait()
        game:Shutdown()
    end)
    if #Players:GetPlayers() <= 1 then
        Players.LocalPlayer:Kick("https://dynasty-scans.com/series/asumi_chan_is_interested_in_lesbian_brothels")
        wait()
        local ok = pcall(function()
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        end)
        if not ok then
            failConn:Disconnect()
            task.wait()
            game:Shutdown()
        end
    else
        local ok = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
        end)
        if not ok then
            failConn:Disconnect()
            task.wait()
            game:Shutdown()
        end
    end
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
            local inviteCode = "uuza7nsPq"
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
local function GetSafeModule(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local function GetRemote(parent, pathString)
    local current = parent
    for _, name in ipairs(pathString:split(".")) do
        if not current then return nil end
        current = current:FindFirstChild(name)
    end
    return current
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
local Flags = {}
local Connections = {}
local function SafeConnect(key, getSignalFn, handler)
    local ok, signal = pcall(getSignalFn)
    if not ok or not signal then
        return
    end
    Connections[key] = signal:Connect(handler)
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
    if not fireclickdetector then return end
    if not target or not target:IsA("ClickDetector") then return end
    fireclickdetector(target)
end
local function FirePP(target, teleport)
    if not fireproximityprompt then return end
    if not target or not target:IsA("ProximityPrompt") then return end
    local prevDist = target.MaxActivationDistance
    target.MaxActivationDistance = math.huge
    if teleport then
        local hrp = Char and Char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        if hrp and part and part:IsA("BasePart") then
            hrp.CFrame = part.CFrame * CFrame.new(0, 0, -3)
            task.wait()
        end
    end
    fireproximityprompt(target)
    task.delay(0.5, function()
        if target and target.Parent then
            target.MaxActivationDistance = prevDist
        end
    end)
end
local function FireTI(target)
    if not firetouchinterest then return end
    local root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local part
    if target:IsA("BasePart") then
        part = target
    else
        part = target:FindFirstAncestorWhichIsA("BasePart")
    end
    if not part then return end
    part.CFrame = root.CFrame
    task.spawn(function()
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end)
end
local Events = RS.Events
local Modules = {
    PlayerStats = GetSafeModule(Plr.PlayerScripts, "PlayerStats"),
    LockOnSystem = GetSafeModule(Plr.PlayerScripts, "LockOnSystem"),
    NodeInfo = GetSafeModule(RS.ClientModules, "NodeInfo"),
    RefractionModifiers = GetSafeModule(RS.ClientModules, "RefractionModifiers"),
    Places = GetSafeModule(RS.ClientModules, "Places"),
    CachedBattleUnitModels = GetSafeModule(RS.ClientModules, "CachedBattleUnitModels"),
}
local Shared = {
    StackMod = "",
    SelectedNodes = nil,
    LastNodeSelect = 0,
    LastCombatEnd = 0,
    LastEnemyDeath = 0,
    DungeonNodes = {},
    FurthestNodeRow = 0,
    RefractionConfig = {},
    LastAttack = 0,
}
local Dungeons = {
    "The Backstreets",
    "The Library",
    "Upper Library",
    "Luxcavation",
    "Detour1",
}
local NodeTypes = {"Elite", "Treasure", "Boss", "Battle", "EasyBattle", "Rest", "Event"}
local NodesMap = {}
local NodeRemoteType = "VoteForNode"
SafeConnect("DrawNodes", function()
    return Events.DrawNodesForFirstTime.OnClientEvent
end, function(p1, p2)
    NodesMap = p1
    NodeRemoteType = "NodeSelect"
    Shared.DungeonNodes = {}
    Shared.FurthestNodeRow = 0
    yuri("[Labyrinth] Node map captured (DrawNodesForFirstTime), furthest row:", p2)
end)
SafeConnect("DrawNodeInfo", function()
    return Events.DrawNodeInfo.OnClientEvent
end, function(p1)
    NodesMap = p1
    NodeRemoteType = "VoteForNode"
    Shared.DungeonNodes = {}
    Shared.FurthestNodeRow = 0
    local c = 0; for _ in pairs(p1) do c = c + 1 end
end)
SafeConnect("NodeDistIncrease", function()
    return Events.NodeDistIncrease.OnClientEvent
end, function(p1, p2)
    Shared.FurthestNodeRow = p1
    if p2 then
        Shared.DungeonNodes[p2] = true
    end
end)
SafeConnect("EndCombat", function()
    return Events.EndCombat.OnClientEvent
end, function()
    Shared.LastCombatEnd = tick()
    Shared.LastEnemyDeath = tick()
end)
local _liveHand = {}
local _liveEGOHand = {}
local _livePosture = 0
SafeConnect("SyncStats", function()
    return Events.SyncStats.OnClientEvent
end, function(player, data)
    if player ~= Plr then return end
    if type(data.Hand) == "table" then
        _liveHand = data.Hand
    end
    if type(data.EGOHand) == "table" then
        _liveEGOHand = data.EGOHand
    end
    if type(data.Posture) == "number" then
        _livePosture = data.Posture
    end
end)
local function GetLivePlayerStats()
    local ps = Modules.PlayerStats
    local hand = (ps and ps.Hand) or _liveHand
    local ego = (ps and ps.EGOHand) or _liveEGOHand
    return { Hand = hand, EGOHand = ego }
end
local function getCardCount()
    local stats = GetLivePlayerStats()
    local count = 0
    for _ in pairs(stats.Hand) do count = count + 1 end
    for _ in pairs(stats.EGOHand) do count = count + 1 end
    return count
end
local function getHandCounts()
    local stats = GetLivePlayerStats()
    local hand, ego = 0, 0
    for _ in pairs(stats.Hand) do hand = hand + 1 end
    for _ in pairs(stats.EGOHand) do ego = ego + 1 end
    return hand, ego
end
local function GetEnemy(mode)
    if mode == "Any" then
        for _, unit in pairs(Modules.CachedBattleUnitModels) do
            local model = unit.Model
            if model and (model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")) then
                return true
            end
        end
        return false
    end
    local livingFound = false
    local first = nil
    local lowest, lowestHP = nil, math.huge
    local withCards = nil
    local character = Plr.Character
    local charRoot = character and character:FindFirstChild("HumanoidRootPart")
    for _, unit in pairs(Modules.CachedBattleUnitModels) do
        local model = unit.Model
        if model then
            local enemyRoot = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
            if charRoot and enemyRoot and (enemyRoot.Position - charRoot.Position).Magnitude > 100 then
                continue
            end
            local dead = model:GetAttribute("Dead")
            local untargetable = model:GetAttribute("Untargetable")
            if not dead and not untargetable then
                livingFound = true
                if not first then
                    first = model
                end
                if unit.Health and unit.Hand and #unit.Hand == 0 and unit.Health < lowestHP then
                    lowestHP = unit.Health
                    lowest = model
                end
                if not withCards and unit.Hand and #unit.Hand > 0 then
                    withCards = model
                end
            end
        end
    end
    if mode == "Valid" then
        return livingFound
    elseif mode == "First" then
        return first
    elseif mode == "FreeHit" then
        return lowest
    elseif mode == "WithCards" then
        return withCards
    end
    return nil
end

local function TargetEnemy(enemy)
    if not enemy then return false end
    local character = Plr.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and enemy:IsA("Model") then
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
        if not enemyRoot then
            for _, part in pairs(enemy:GetChildren()) do
                if part:IsA("BasePart") then
                    enemyRoot = part
                    break
                end
            end
            if not enemyRoot then
                local offset = Vector3.new(5, 0, 5)
                humanoidRootPart.CFrame = CFrame.new(enemy:GetPivot().Position + offset)
                task.wait(0.175)
                return true
            end
        end
        if enemyRoot then
            local offset = Vector3.new(5, 0, 5)
            humanoidRootPart.CFrame = CFrame.new(enemyRoot.Position + offset)
            task.wait(0.175)
            return true
        end
    end
    return true
end
local function getCardMaxValue(attackData)
    local sum = attackData["Base Power"]
    for _, intent in ipairs(attackData["Intent List"]) do
        sum = sum + intent["Intent Bonus"]
    end
    return sum
end
local function getClashScore(attackData, enemyTarget)
    local basePower = attackData["Base Power"]
    local maxValue = getCardMaxValue(attackData)
    local result = SafeInvoke(Events.ClashPredictor, basePower, maxValue, attackData, enemyTarget)
    if type(result) ~= "table" or not result.Score then
        yuri("[TurnAction] ClashPredictor gave no score for", attackData.Name)
        return nil
    end
    if math.max(result.EnemyBaseValue, result.EnemyMaxValue) < result.PlayerBaseValue then
        return math.huge 
    end
    return result.Score
end
local function selectBestCard(enemyTarget)
    local bestId, bestData, bestScore = nil, nil, -math.huge
    for id, data in pairs(GetLivePlayerStats().Hand) do
        local score = getClashScore(data, enemyTarget)
        if score and score > bestScore then
            bestScore, bestId, bestData = score, id, data
        end
    end
    for id, data in pairs(GetLivePlayerStats().EGOHand) do
        local score = getClashScore(data, enemyTarget)
        if score and score > bestScore then
            bestScore, bestId, bestData = score, id, data
        end
    end
    yuri("[TurnAction] Best card:", bestData and bestData.Name, "| Score:", bestScore)
    return bestId, bestData
end
local function isGuardCard(attackData)
    if not attackData["Intent List"] or #attackData["Intent List"] == 0 then return false end
    for _, intent in ipairs(attackData["Intent List"]) do
        if intent["Intent Type"] ~= "Defend" then return false end
    end
    return true
end
local function selectFreeCard()
    for id, data in pairs(GetLivePlayerStats().Hand) do
        if not isGuardCard(data) then return id, data end
    end
    for id, data in pairs(GetLivePlayerStats().EGOHand) do
        if not isGuardCard(data) then return id, data end
    end
    return nil, nil
end
local function EndTurn()
    Events.EndTurn:FireServer()
    yuri("ended")
    task.wait(.5)
end
local function AutoPlay()
    while Toggles.AutoPlay.Value do
        if Plr:GetAttribute("IsYourTurn") then
            if PGui.CombatGui.ClashFrame.Visible then
                task.wait()
                continue
            end
            if not GetEnemy("Any") then
                task.wait()
                continue
            end
            if not GetEnemy("Valid") then
                EndTurn()
                task.wait()
                continue
            end
            local cardCount = getCardCount()
            local enemy = GetEnemy("First")
            yuri("[AutoPlay] cardCount=" .. cardCount .. " enemy=" .. tostring(enemy ~= nil))
            if cardCount == 0 or not enemy then
                yuri("[AutoPlay] No cards or no enemy, calling EndTurn")
                if cardCount == 0 or not enemy then
                    local handN, egoN = getHandCounts()
                    EndTurn()
                end
                task.wait(0.1)
                continue
            end
            if not TargetEnemy(enemy) then
                yuri("[AutoPlay] TargetEnemy failed")
                task.wait(0.1)
                continue
            end
            local enemyTarget = enemy
            local enemyId = enemyTarget:GetAttribute("id")
            local enemyUnit = Modules.CachedBattleUnitModels[enemyId]
            yuri("[AutoPlay] Got enemyUnit: " .. tostring(enemyUnit ~= nil) .. " for id=" .. tostring(enemyId))
            if not enemyUnit then
                yuri("[AutoPlay] No enemyUnit, retrying")
                task.wait(0.1)
                continue
            end
            local enemyHandCount = #enemyUnit.Hand
            yuri("[AutoPlay] enemyHandCount=" .. enemyHandCount)
            if enemyHandCount == 0 then
                yuri("[AutoPlay] Enemy has no cards, looking for one with cards")
                local enemyWithCards = GetEnemy("WithCards")
                if enemyWithCards and enemyWithCards ~= enemy then
                    yuri("[AutoPlay] Found enemy with cards, retargeting")
                    TargetEnemy(enemyWithCards)
                    enemyTarget = enemyWithCards
                    enemyId = enemyTarget:GetAttribute("id")
                    enemyUnit = Modules.CachedBattleUnitModels[enemyId]
                    if not enemyUnit then
                        yuri("[AutoPlay] Retargeted enemy has no unit, retrying")
                        task.wait(0.1)
                        continue
                    end
                    enemyHandCount = #enemyUnit.Hand
                end
            end
            local attackId, attackData
            local enemyIsFree = enemyHandCount == 0
            if not enemyIsFree then
                attackId, attackData = selectBestCard(enemyTarget)
            else
                local freeHitTarget = GetEnemy("FreeHit")
                if freeHitTarget and freeHitTarget ~= enemy then
                    TargetEnemy(freeHitTarget)
                    enemyTarget = freeHitTarget
                    enemyId = enemyTarget:GetAttribute("id")
                end
                yuri("[TurnAction] Enemy has no cards left")
                local postureThreshold = tonumber(Options.PostureThreshold.Value) or 0
                if _livePosture <= postureThreshold then
                    yuri("[TurnAction] Posture <=", postureThreshold, "vs free enemy -> EndTurn")
                    EndTurn()
                    task.wait(0.1)
                    continue
                end
                attackId, attackData = selectFreeCard()
                if not attackId then
                    yuri("[TurnAction] Only guard cards remain vs free enemy -> EndTurn")
                    EndTurn()
                    task.wait(0.1)
                    continue
                end
            end
            if not attackId then
                attackId, attackData = next(GetLivePlayerStats().Hand)
                if not attackId then
                    attackId, attackData = next(GetLivePlayerStats().EGOHand)
                end
            end
            if not attackId then
                local currentCount = getCardCount()
                local handN, egoN = getHandCounts()
                EndTurn()
                task.wait(0.1)
                continue
            end
            if attackData then
                do
                    local handNames = {}
                    for _, d in pairs(GetLivePlayerStats().Hand) do table.insert(handNames, d.Name or "?") end
                    local egoNames = {}
                    for _, d in pairs(GetLivePlayerStats().EGOHand) do table.insert(egoNames, d.Name or "?") end
                    yuri(("[TurnAction] Pre-play hand=[%s] ego=[%s] | Playing: %s (isEgo=%s) vs enemy=%s"):format(
                        table.concat(handNames, ", "), table.concat(egoNames, ", "),
                        attackData.Name or "?",
                        tostring(GetLivePlayerStats().EGOHand[attackId] ~= nil),
                        tostring(enemyId)
                    ))
                end
                if GetLivePlayerStats().EGOHand[attackId] then
                    Events.playEGOAttack:InvokeServer(attackData.Name, attackId, enemyId)
                else
                    Events.playAttack:InvokeServer(attackId, enemyId)
                end
                task.wait()
            end
        end
        task.wait()
    end
end
local function getAvailableNodes()
    local dungeonGui = PGui:FindFirstChild("DungeonGui")
    local nodeContainer = dungeonGui and dungeonGui:FindFirstChild("DungeonNodeContainer")
    if next(NodesMap) ~= nil then
        local dungeonNodes = Shared.DungeonNodes
        local furthestRow = Shared.FurthestNodeRow
        if not dungeonNodes or furthestRow == nil then return {} end
        local guiNodes = {}
        if nodeContainer then
            for _, child in ipairs(nodeContainer:GetChildren()) do
                if child:IsA("Frame") then guiNodes[child.Name] = true end
            end
        end
        local available = {}
        for nodeName, nodeData in pairs(NodesMap) do
            if not dungeonNodes[nodeName] then
                if nodeData.RowToUnlock == furthestRow then
                    if NodeRemoteType ~= "NodeSelect" or not (nodeData.LockedBy and dungeonNodes[nodeData.LockedBy]) then
                        if not nodeContainer or guiNodes[nodeName] then
                            table.insert(available, {name = nodeName, data = nodeData})
                        end
                    end
                end
            end
        end
        return available
    end
    local available = {}
    if nodeContainer then
        local furthestRow = Shared.FurthestNodeRow
        for _, child in ipairs(nodeContainer:GetChildren()) do
            if child:IsA("Frame") and child.Visible then
                local rowToUnlock = child:GetAttribute("Furthest")
                if rowToUnlock == furthestRow then
                    local nodeType = nil
                    for _, t in ipairs(NodeTypes) do
                        if child.Name == t then nodeType = t; break end
                    end
                    table.insert(available, {name = child.Name, data = {NodeType = nodeType}})
                end
            end
        end
    end
    yuri("[Labyrinth] getAvailableNodes: NodesMap empty, GUI fallback count=", #available)
    return available
end
local function selectBestNode()
    local available = getAvailableNodes()
    if #available == 0 then return end
    local furthestRow = Shared.FurthestNodeRow
    local availableNames = {}
    for _, node in ipairs(available) do
        table.insert(availableNames, node.name .. "(" .. (node.data.NodeType or "?") .. ")")
    end
    yuri("[Labyrinth] Row:", furthestRow, "| Available:", table.concat(availableNames, ", "))
    local priorityList = (Shared.SelectedNodes and #Shared.SelectedNodes > 0) and Shared.SelectedNodes or NodeTypes
    yuri("[Labyrinth] Priority order:", table.concat(priorityList, " > "))
    for _, targetType in ipairs(priorityList) do
        for _, node in ipairs(available) do
            if node.data.NodeType == targetType then
                yuri("[Labyrinth] Selecting node:", node.name, "(", targetType, ") | Remote:", NodeRemoteType)
                if NodeRemoteType == "NodeSelect" then
                    Events.NodeSelect:FireServer(node.data)
                else
                    Events.VoteForNode:FireServer(node.name)
                end
                Shared.LastNodeSelect = tick()
                return
            end
        end
    end
    yuri("[Labyrinth] Fallback: selecting first available node:", available[1].name, "(", available[1].data.NodeType, ") | Remote:", NodeRemoteType)
    if NodeRemoteType == "NodeSelect" then
        Events.NodeSelect:FireServer(available[1].data)
    else
        Events.VoteForNode:FireServer(available[1].name)
    end
    Shared.LastNodeSelect = tick()
end
local function VoteNode()
    while Toggles.AutoSelectNodes.Value do
        if PGui.DungeonGui.Enabled and not PGui.CombatGui.Hand.Visible and (tick() - Shared.LastCombatEnd) >= 2 and (tick() - Shared.LastNodeSelect) >= 2 then
            selectBestNode()
        end
        task.wait()
    end
end
local function ClickOpt()
    local DungeonGui = PGui:FindFirstChild("DungeonGui")
    if not DungeonGui then return false end
    local dialogueContainer = DungeonGui:FindFirstChild("DialogueContainer")
    if not dialogueContainer or not dialogueContainer.Visible then return false end
    local container = dialogueContainer:FindFirstChild("Container")
    if not container then return false end
    for i = 1, 3 do
        local opt = container:FindFirstChild("Options" .. i)
        if opt and opt.Visible then
            local optTextObj = opt:FindFirstChild("OptionText")
            if optTextObj and optTextObj.Text ~= "" then
                yuri("[Labyrinth] Clicking dialogue option", i, ":", optTextObj.Text)
                gsc(opt)
                task.wait(0.2)
                return true
            end
        end
    end
    return false
end
local function AutoEventOpt()
    while Toggles.AutoEventOption.Value do
        local DungeonGui = PGui:FindFirstChild("DungeonGui")
        if DungeonGui then
            local dialogueContainer = DungeonGui:FindFirstChild("DialogueContainer")
            if dialogueContainer and dialogueContainer.Visible then
                local container = dialogueContainer:FindFirstChild("Container")
                if container then
                    local optNames = {"Options1", "Options2", "Options3"}
                    for _, optName in ipairs(optNames) do
                        local opt = container:FindFirstChild(optName)
                        if opt and opt.Visible then
                            local optTextObj = opt:FindFirstChild("OptionText")
                            if optTextObj and optTextObj.Text ~= "" then
                                yuri("[Labyrinth] Auto Event Option: selecting", optName, "->", optTextObj.Text)
                                gsc(opt)
                                task.wait(0.5)
                                break
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local RestOptionMap = {
    ["Heal"]    = "Options1",
    ["Train"]   = "Options2",
    ["Discard"] = "Options4",
}
local function DoRest()
    if GetEnemy("First") then return false end
    local DungeonGui = PGui:FindFirstChild("DungeonGui")
    if not DungeonGui then return false end
    local restContainer = DungeonGui:FindFirstChild("RestContainer")
    if not restContainer or not restContainer.Visible then return false end
    local container = restContainer:FindFirstChild("Container")
    if not container then return false end
    local chosen = Options.RestOption and Options.RestOption.Value or "Heal"
    local btnName = RestOptionMap[chosen] or "Options1"
    local btn = container:FindFirstChild(btnName)
    if not btn or not btn.Visible then return false end
    yuri("[Labyrinth] Clicking rest option:", chosen, "->", btnName)
    gsc(btn)
    task.wait()
    return true
end
local function AutoRest()
    while Toggles.AutoRest.Value do
        DoRest()
        task.wait(0.2)
    end
end
local function VoteBoss()
    while Toggles.AutoSelectBoss.Value do
        local DungeonGui = PGui:FindFirstChild("DungeonGui")
        if DungeonGui then
            local pickBossFrame = DungeonGui:FindFirstChild("PickBossFrame")
            if pickBossFrame and pickBossFrame.Visible then
                task.wait()
                local options = {}
                for i = 1, 3 do
                    local opt = pickBossFrame:FindFirstChild("BossOption" .. i)
                    if opt then
                        local bossNameLabel = opt:FindFirstChild("BossName")
                        if bossNameLabel and bossNameLabel.Text ~= "" then
                            table.insert(options, bossNameLabel.Text)
                        end
                    end
                end
                if #options > 0 then
                    local chosen = nil
                    if Shared.SelectedBosses and #Shared.SelectedBosses > 0 then
                        for _, preferred in ipairs(Shared.SelectedBosses) do
                            for _, available in ipairs(options) do
                                if available == preferred then
                                    chosen = available
                                    break
                                end
                            end
                            if chosen then break end
                        end
                    end
                    if not chosen then
                        chosen = options[1]
                    end
                    yuri("[Labyrinth] Voting for boss:", chosen)
                    Events.PlayerVoteOnBoss:InvokeServer(chosen)
                end
                task.wait()
            end
        end
        task.wait(0.175)
    end
end
local function AutoCondense()
    while Toggles.AutoCondense.Value do
        local DungeonGui = PGui:FindFirstChild("DungeonGui")
        if DungeonGui then
            local rewardFrame = DungeonGui:FindFirstChild("RewardFrame")
            if rewardFrame and rewardFrame.Visible then
                local container = rewardFrame:FindFirstChild("Container")
                if container then
                    local rewardContainer = container:FindFirstChild("RewardContainer")
                    if rewardContainer then
                        for _, child in ipairs(rewardContainer:GetChildren()) do
                            if child:IsA("TextButton") and child.Text:find("Condense") then
                                yuri("[AutoCondense] Clicking condense reward:", child.Text)
                                gsc(child)
                                task.wait(0.2)
                            end
                        end
                    end
                    for i = 1, 3 do
                        local rewardSlot = container:FindFirstChild("Reward" .. i)
                        if rewardSlot then
                            local reward = rewardSlot:FindFirstChild("Reward")
                            if reward and reward:IsA("TextButton") then
                                yuri("[AutoCondense] Clicking Reward" .. i .. " (" .. (reward:FindFirstChild("NameLabel") and reward.NameLabel.Text or "?") .. ")")
                                gsc(reward)
                                task.wait(0.3)
                                break
                            end
                        end
                    end
                    local rewardsButton = container:FindFirstChild("RewardsButton")
                    if rewardsButton and rewardsButton.Visible then
                        yuri("[AutoCondense] Clicking RewardsButton")
                        gsc(rewardsButton)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local function StartGame()
    local payload = {
        SelectedDungeon = Options.DungeonSelect.Value,
        IsPrescriptOn = false,
        Damage_Refraction = 100,
        HP_Refraction = -100,
        EliteReinforcement_Refraction = Shared.StackMod,
    }
    for key, value in pairs(Shared.RefractionConfig) do
        payload[key] = value
    end
    Events.BeginTeleport:FireServer(payload)
end
task.spawn(function()
    local FinishGui = PGui:WaitForChild("FinishGui", 60)
    if not FinishGui then
        yuri("[Labyrinth] FinishGui not found within timeout")
        return
    end
    SafeConnect("FinishGuiEnabled", function()
        return FinishGui:GetPropertyChangedSignal("Enabled")
    end, function()
        if FinishGui.Enabled then
            NodesMap = {}
            Shared.DungeonNodes = {}
            Shared.FurthestNodeRow = 0
            if Toggles.AutoRetry.Value then
                task.wait()
                yuri("[Labyrinth] Auto Retry: firing BeginTeleport(true)")
                Events.BeginTeleport:FireServer(true)
            end
        end
    end)
end)
local GachaBanners = {"Standard"}
do
    local ok, holder = pcall(function()
        local sg = PGui:WaitForChild("ScreenGui", 3)
        local menus = sg:WaitForChild("Menus", 3)
        local store = menus:WaitForChild("Store", 3)
        local mf = store:FindFirstChild("MainFrame")
        local banners = mf and mf:FindFirstChild("Banners")
        return banners and banners:FindFirstChild("BannerHolder")
    end)
    if ok and holder then
        local found = {}
        for _, child in ipairs(holder:GetChildren()) do
            if child:IsA("ImageButton") then
                table.insert(found, child.Name)
            end
        end
        if #found > 0 then GachaBanners = found end
    end
    yuri("[Gacha] Banners found:", table.concat(GachaBanners, ", ")) 
end
local gachaRollsLeft = 0
local GachaRollsLabel = nil
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
    Gacha = Window:AddTab("Gacha"),
    Config = Window:AddTab("Config"),
}
local ConfigTB = Tabs.Main:AddRightTabbox()
local AutofarmTB = Tabs.Main:AddLeftTabbox()
local RefractionKeys = {
    "Damage_Refraction",
    "Posture_Refraction",
    "HP_Refraction",
    "Weakened_Refraction",
    "FinalPower_Refraction",
    "PostureCap_Refraction",
    "AdditionalBasicEnemy_Refraction",
    "Durable_Refraction",
    "ExtraActions_Refraction",
    "EliteReinforcement_Refraction",
    "Reflection_Refraction",
    "Hardcore_Refraction",
    "ToxicElitist_Refraction",
}
local BossList = {
    "Zwei Patrol",
    "[TETH] You Must Become Strong",
    "Dreamer of Human Wholeness",
    "Potential Man",
    "K Corp. Dept. of Food R&D Branch Manager",
    "Technology Liberation Alliance Leader",
    "[TETH] Red Sheets",
    "[ZAYIN] Cavernous Wailing",
    "[HE] Dimensional Shredder",
    "Waxen Pinion",
    "[HE] Lasso",
    "[HE] Harmony",
    "Middle Finger Toujou",
    "The Last Blade Lineage",
    "[HE] Fell Bullet",
    "[WAW] Binds",
    "[WAW] Ya \197\154\197\171nyat\196\129 Tad R\197\171pam",
    "The Tiantui Star Blade",
    "Flash Phenomenon - Projector",
}
local ConfigG = ConfigTB:AddTab("Config")
local AFG = AutofarmTB:AddTab("Autofarm")
ConfigG:AddDropdown("NodePriority", {
    Text = "Node Priority",
    Values = NodeTypes,
    AllowNull = true,
    Multi = true,
    Default = {},  
})
Options.NodePriority:OnChanged(function()
    Shared.SelectedNodes = {}
    for name, active in pairs(Options.NodePriority.Value) do
        if active then 
            table.insert(Shared.SelectedNodes, name) 
        end
    end
    yuri("Selected nodes:", table.concat(Shared.SelectedNodes, ", "))
end)
AFG:AddToggle("AutoSelectNodes", {
    Text = "Auto Select Nodes",
    Default = false,
})
Toggles.AutoSelectNodes:OnChanged(function(state)
    Thread("AutoSelectNodes", VoteNode, state)
end)
ConfigG:AddDropdown("BossPriority", {
    Text = "Boss Priority",
    Values = BossList,
    AllowNull = true,
    Multi = true,
    Default = {},
})
Options.BossPriority:OnChanged(function()
    Shared.SelectedBosses = {}
    for name, active in pairs(Options.BossPriority.Value) do
        if active then
            table.insert(Shared.SelectedBosses, name)
        end
    end
    yuri("Selected bosses:", table.concat(Shared.SelectedBosses, ", "))
end)
AFG:AddToggle("AutoSelectBoss", {
    Text = "Auto Select Boss",
    Default = false,
})
Toggles.AutoSelectBoss:OnChanged(function(state)
    Thread("AutoSelectBoss", VoteBoss, state)
end)
AFG:AddToggle("AutoEventOption", {
    Text = "Auto Event",
    Default = false,
})
Toggles.AutoEventOption:OnChanged(function(state)
    Thread("AutoEventOption", AutoEventOpt, state)
end)
ConfigG:AddDropdown("RestOption", {
    Text = "Rest Option",
    Values = {"Heal", "Train", "Discard"},
    Default = "Heal",
})
AFG:AddToggle("AutoRest", {
    Text = "Auto Rest",
    Default = false,
})
Toggles.AutoRest:OnChanged(function(state)
    Thread("AutoRest", AutoRest, state)
end)
AFG:AddToggle("AutoRetry", {
    Text = "Auto Retry",
    Default = false,
})
AFG:AddToggle("AutoCondense", {
    Text = "Auto Condense",
    Default = false,
})
Toggles.AutoCondense:OnChanged(function(state)
    Thread("AutoCondense", AutoCondense, state)
end)
local GachaOutfitValues = {}  
local GachaOutfitKeyByLabel = {}  
do
    local cantoToRarity = {[1]="C", [2]="R", [3]="SR", [4]="BP"}
    local OutfitModule = GetSafeModule(RS.ClientModules, "OutfitData")
    if OutfitModule and OutfitModule.OutfitList then
        local sorted = {}
        for key, data in pairs(OutfitModule.OutfitList) do
            local canto = data.Canto or 1
            if canto ~= 99 then  
                table.insert(sorted, {key=key, canto=canto, rarity=cantoToRarity[canto] or "C"})
            end
        end
        table.sort(sorted, function(a, b)
            if a.canto ~= b.canto then return a.canto > b.canto end
            return a.key < b.key
        end)
        for _, entry in ipairs(sorted) do
            local label = entry.key .. " (" .. entry.rarity .. ")"
            table.insert(GachaOutfitValues, label)
            GachaOutfitKeyByLabel[label] = entry.key
        end
        yuri("[Gacha] Outfit list built, count:", #GachaOutfitValues)
    end
end
local A = Tabs.Gacha:AddLeftTabbox()
local B = Tabs.Gacha:AddRightTabbox()
local A_1 = A:AddTab("Gacha")
local B_1 = B:AddTab("Misc")
A_1:AddLabel('<b><font color="#FFB6C1">Try rejoining if your data is corrupted.</font></b>', true)
A_1:AddDropdown("GachaBannerSelect", {
    Text = "Banner",
    Values = GachaBanners,
    Default = GachaBanners[1],
})
A_1:AddInput("GachaRollCount", {
    Text = "Roll Count",
    Default = "10",
    Placeholder = "Number of rolls",
    Numeric = true,
})
A_1:AddDropdown("GachaTargetOutfits", {
    Text = "Target Outfit",
    Values = GachaOutfitValues,
    Default = {},
    Multi = true,
    AllowNull = true,
})
GachaRollsLabel = A_1:AddLabel("Rolls Left: -")
A_1:AddDivider()
A_1:AddToggle("GachaAutoRejoin", {
    Text = "Rollback when out of rolls",
    Default = false,
})
A_1:AddToggle("AutoGacha", {
    Text = "Auto Gacha",
    Default = false,
})
local function AutoGachaLoop()
    local GachaFunc = RS.Events.GachaFunc
    local bannerName = Options.GachaBannerSelect.Value
    gachaRollsLeft = tonumber(Options.GachaRollCount.Value) or 0
    GachaRollsLabel:SetText("Rolls Left: " .. gachaRollsLeft)
    yuri("[Gacha] Starting | Banner:", bannerName, "| Rolls:", gachaRollsLeft)
    while Toggles.AutoGacha.Value and gachaRollsLeft > 0 do
        local pullType, pullCost
        if gachaRollsLeft >= 10 then
            pullType = "MultiPull"
            pullCost = 10
        else
            pullType = "SinglePull"
            pullCost = 1
        end
        yuri("[Gacha]", pullType, "| Banner:", bannerName, "| Remaining:", gachaRollsLeft)
        local ok, pullResults = pcall(GachaFunc.InvokeServer, GachaFunc, pullType, bannerName)
        if ok then
            gachaRollsLeft = gachaRollsLeft - pullCost
            GachaRollsLabel:SetText("Rolls Left: " .. gachaRollsLeft)
            yuri("[Gacha] Done, rolls left:", gachaRollsLeft)
            if type(pullResults) == "table" then
                local cantoToRarity = {[1]="C", [2]="R", [3]="SR", [4]="BP"}
                local OutfitModule = GetSafeModule(RS.ClientModules, "OutfitData")
                for _, pull in ipairs(pullResults) do
                    local key = pull.Outfit
                    local rarity = "C"
                    if OutfitModule and OutfitModule.OutfitList and OutfitModule.OutfitList[key] then
                        local canto = OutfitModule.OutfitList[key].Canto or 1
                        rarity = cantoToRarity[canto] or "C"
                    end
                    Library:Notify(rarity .. ":" .. key, 2)
                    yuri("[Gacha] Rolled", rarity .. ":" .. key)
                end
            end
            local targets = Options.GachaTargetOutfits.Value  
            if next(targets) ~= nil and type(pullResults) == "table" then
                for _, pull in ipairs(pullResults) do
                    local key = pull.Outfit
                    for label, selected in pairs(targets) do
                        if selected and GachaOutfitKeyByLabel[label] == key then
                            Library:Notify("Target obtained: " .. key .. "!", 3)
                            yuri("[Gacha] Target obtained:", key)
                            Toggles.AutoGacha:SetValue(false)
                            return
                        end
                    end
                end
            end
        else
            task.wait(1)
        end
        task.wait(0.5)
    end
    if Toggles.AutoGacha.Value then
        Toggles.AutoGacha:SetValue(false)
    end
    if gachaRollsLeft <= 0 then
        Library:Notify("Finished rolling.", 4)
        if Toggles.GachaAutoRejoin.Value then
            Library:Notify("No rolls left, rejoining...", 3)
            task.wait(2)
            DoRejoin()
        end
    end
end
B_1:AddButton({
    Text = "Rollback",
    Func = function()
        DoRejoin()
    end,
})
Toggles.AutoGacha:OnChanged(function(state)
    if state then
        gachaRollsLeft = tonumber(Options.GachaRollCount.Value) or 0
        GachaRollsLabel:SetText("Rolls Left: " .. gachaRollsLeft)
    else
        GachaRollsLabel:SetText("Rolls Left: " .. gachaRollsLeft)
    end
    Thread("AutoGacha", AutoGachaLoop, state)
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
AFG:AddToggle("AutoPlay", {
    Text = "Auto Play",
    Default = false,
})
Toggles.AutoPlay:OnChanged(function(state)
    Thread("AutoPlay", AutoPlay, state)
end)
ConfigG:AddInput("PostureThreshold", {
    Text = "Posture Threshold",
    Default = "0",
    Numeric = true,
})
AFG:AddToggle("AutoRejoinStuck", {
    Text = "Rejoin if Stuck",
    Default = false,
})
ConfigG:AddInput("StuckTimeout", {
    Text = "Stuck Timeout",
    Default = "300",
    Numeric = true,
})
local function StuckWatchdog()
    Shared.LastEnemyDeath = tick()
    while Toggles.AutoRejoinStuck.Value do
        local timeout = tonumber(Options.StuckTimeout.Value) or 300
        if Toggles.AutoPlay.Value and (tick() - Shared.LastEnemyDeath) >= timeout then
            yuri("[StuckWatchdog] No kill in", timeout, "seconds, firing retry")
            Shared.LastEnemyDeath = tick()
            Events.BeginTeleport:FireServer(true)
        end
        task.wait(1)
    end
end
Toggles.AutoRejoinStuck:OnChanged(function(state)
    Thread("StuckWatchdog", StuckWatchdog, state)
end)
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
    Cleanup(Connections)
    Cleanup(Flags)
    Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/PML")
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
    yuri("ERROR: " .. tostring(err))
end
