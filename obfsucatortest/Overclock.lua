if getgenv().ayasemiyatongekissazumirisa then
    warn("lll")
    return
end
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
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
local HttpService = Services.HttpService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local TweenService = Services.TweenService
local CoreGui = Services.CoreGui
local RS = Services.ReplicatedStorage
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
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
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
local yuri = {
    "https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
    "https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
    "https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/233/thumbnail.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/328/thumbnail.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/1339/thumbnail.jpeg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/1268/thumbnail.jpeg",
    "https://dynasty-scans.com/system/releases/000/040/979/001.webp",
    "https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
}
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
local _FS = (_DR and _DR.FireServer)
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
local function GetRemote(parent, pathString)
    local current = parent
    for _, name in ipairs(pathString:split(".")) do
        if not current then return nil end
        current = current:WaitForChild(name, 5)
    end
    return current
end
local Remotes = {
    ClaimTokenDrop          = GetRemote(RS, "Remotes.ClaimTokenDrop"),
    TokenDropStarted        = GetRemote(RS, "Remotes.TokenDropStarted"),
    TokenDropResolved       = GetRemote(RS, "Remotes.TokenDropResolved"),
    RequestUpgradeNode      = GetRemote(RS, "Remotes.RequestUpgradeNode"),
    BuyGlobalUpgrade        = GetRemote(RS, "Remotes.BuyGlobalUpgrade"),
    RequestSave             = GetRemote(RS, "Remotes.RequestSave"),
    SetTutorialCompleted    = GetRemote(RS, "Remotes.SetTutorialCompleted"),
    RequestBuyProcessorCore = GetRemote(RS, "Remotes.RequestBuyProcessorCore"),
    TogglePauseNode         = GetRemote(RS, "Remotes.TogglePauseNode"),
    StateUpdate             = GetRemote(RS, "Remotes.StateUpdate"),
    CreateNode              = GetRemote(RS, "Remotes.CreateNode"),
    DeleteNode              = GetRemote(RS, "Remotes.DeleteNode"),
    ConnectPort             = GetRemote(RS, "Remotes.ConnectPort"),
    DisconnectPort          = GetRemote(RS, "Remotes.DisconnectPort"),
    RequestData             = GetRemote(RS, "Remotes.RequestData"),
    RequestLevelNodeXP      = GetRemote(RS, "Remotes.RequestLevelNodeXP"),
    EnterPrestige           = GetRemote(RS, "Remotes.EnterPrestige"),
    BuySpecialDonationUpgrade = GetRemote(RS, "Remotes.BuySpecialDonationUpgrade"),
}
local Shared = RS:WaitForChild("Shared", 10)
local Modules = {
    NodeDefinitions = GetSafeModule(Shared, "NodeDefinitions"),
    PortTypes       = GetSafeModule(Shared, "PortTypes"),
    UpgradesConfig  = GetSafeModule(Shared, "UpgradesConfig"),
    ItemMetadata    = GetSafeModule(Shared, "ItemMetadataConfig"),
    ResearchConfig  = GetSafeModule(Shared, "ResearchConfig"),
    PrestigeConfig  = GetSafeModule(Shared, "PrestigeConfig"),
    DonationConfig  = GetSafeModule(Shared, "DonationConfig"),
}
local GameState         = {}
local NodePortDefs = {}
for id, def in pairs(Modules.NodeDefinitions) do
    local entry = {
        inputs  = (def.ports and def.ports.inputs)  or {},
        outputs = (def.ports and def.ports.outputs) or {},
    }
    if def.dynamicPortGroups and def.dynamicPortGroups[1] then
        local g = def.dynamicPortGroups[1]
        entry.dynamic = {
            dir    = g.direction,
            prefix = g.prefix,
            typeId = g.portType,
            max    = g.maxDynamic,
        }
    end
    NodePortDefs[id] = entry
end
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local isLimitedExecutor = executorDisplayName:lower():find("xeno") ~= nil
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
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
            local inviteCode = "b6kxdDtqd"
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
local AllNodeIds = (function()
    local ids = {}
    for id in pairs(Modules.NodeDefinitions) do
        table.insert(ids, id)
    end
    table.sort(ids)
    return ids
end)()
local GlobalUpgradeIds = (function()
    local ids = {}
    local all = Modules.UpgradesConfig.getAll()
    for id in pairs(all) do
        table.insert(ids, id)
    end
    return ids
end)()
local ResearchUpgradeIds = (function()
    local ids = {}
    if Modules.ResearchConfig then
        local all = Modules.ResearchConfig.getAll()
        for id in pairs(all) do
            table.insert(ids, id)
        end
    end
    return ids
end)()
local TokenUpgradeIds = (function()
    local ids = {}
    if Modules.DonationConfig then
        local all = Modules.DonationConfig.getAllUpgrades()
        for id in pairs(all) do
            table.insert(ids, id)
        end
    end
    return ids
end)()
local function ArePortsCompatible(outTypeId, inTypeId)
    if outTypeId == inTypeId then return true end
    local outPT = Modules.PortTypes[outTypeId]
    local inPT  = Modules.PortTypes[inTypeId]
    if not outPT or not inPT then
        return false
    end
    if outPT.shape ~= inPT.shape then return false end
    local function isWhite(c)
        if typeof(c) ~= "Color3" then return false end
        return c.R > 0.99 and c.G > 0.99 and c.B > 0.99
    end
    if isWhite(outPT.color) or isWhite(inPT.color) then return true end
    return outPT.color == inPT.color
end
local function GetNodeInputPorts(nodeData)
    local def = NodePortDefs[nodeData.definitionId]
    if not def then return {} end
    local ports = {}
    for portName, typeId in pairs(def.inputs) do
        ports[portName] = typeId
    end
    if def.dynamic and def.dynamic.dir == "input" and nodeData.dynamicPorts then
        local list = nodeData.dynamicPorts[def.dynamic.prefix]
        if list then
            for _, portName in ipairs(list) do
                ports[portName] = def.dynamic.typeId
            end
        end
    end
    return ports
end
local function GetNodeOutputPorts(nodeData)
    local def = NodePortDefs[nodeData.definitionId]
    if not def then return {} end
    local ports = {}
    for portName, typeId in pairs(def.outputs) do
        ports[portName] = typeId
    end
    if def.dynamic and def.dynamic.dir == "output" and nodeData.dynamicPorts then
        local list = nodeData.dynamicPorts[def.dynamic.prefix]
        if list then
            for _, portName in ipairs(list) do
                ports[portName] = def.dynamic.typeId
            end
        end
    end
    return ports
end
local function GetAllIncomingConnections()
    local incoming = {}
    if not GameState.nodes then return incoming end
    for _, nodeData in pairs(GameState.nodes) do
        if nodeData.outputConnections then
            for _, targets in pairs(nodeData.outputConnections) do
                for _, target in ipairs(targets) do
                    incoming[target] = true
                end
            end
        end
    end
    return incoming
end
local function CreateNodeAndWait(definitionId, position)
    local before = {}
    if GameState.nodes then
        for k in pairs(GameState.nodes) do before[k] = true end
    end
    Remotes.CreateNode:FireServer(definitionId, position)
    local start = tick()
    while tick() - start < 4 do
        task.wait(0.1)
        if GameState.nodes then
            for nodeId, nodeData in pairs(GameState.nodes) do
                if not before[nodeId] and nodeData.definitionId == definitionId then
                    return nodeId
                end
            end
        end
    end
    return nil
end
local function SnapPos(x, y)
    local function snap(v) return math.clamp(math.round(v / 40) * 40, -1900, 1900) end
    return UDim2.fromOffset(snap(x), snap(y))
end
local function RefreshGameState()
    local ok, data = pcall(function()
        return Remotes.RequestData:InvokeServer()
    end)
    if ok and data then
        GameState = data
    else
    end
end
RefreshGameState()
local Connections = {}
local function HydrateNodeDelta(existing, delta)
    local merged = existing and table.clone(existing) or {}
    for k2, v2 in pairs(delta) do
        merged[k2] = v2
    end
    if merged.c ~= nil and (merged.outputConnections == nil or delta.c ~= nil) then
        merged.outputConnections = merged.c
    end
    if merged.dp ~= nil and (merged.dynamicPorts == nil or delta.dp ~= nil) then
        merged.dynamicPorts = merged.dp
    end
    if merged.d ~= nil and (merged.definitionId == nil or delta.d ~= nil) then
        merged.definitionId = merged.d
    end
    return merged
end
Connections.StateUpdateConn = Remotes.StateUpdate.OnClientEvent:Connect(function(delta)
    if not delta then return end
    if delta._isSnapshot then
        if delta.cash ~= nil then GameState.cash = delta.cash end
        if delta.researchPoints ~= nil then GameState.researchPoints = delta.researchPoints end
        if delta.tokens ~= nil then GameState.tokens = delta.tokens end
        if delta.prestigeRun ~= nil then GameState.prestigeRun = delta.prestigeRun end
        if delta.prestigePoints ~= nil then GameState.prestigePoints = delta.prestigePoints end
        if delta.nodes ~= nil then
            GameState.nodes = table.clone(GameState.nodes or {})
            for k, v in pairs(delta.nodes) do
                GameState.nodes[k] = HydrateNodeDelta(GameState.nodes[k], v)
            end
        end
        if delta.upgrades ~= nil then
            GameState.upgrades = delta.upgrades
        end
    elseif delta._isDelta then
        if delta.cash ~= nil then GameState.cash = delta.cash end
        if delta.researchPoints ~= nil then GameState.researchPoints = delta.researchPoints end
        if delta.tokens ~= nil then GameState.tokens = delta.tokens end
        if delta.prestigeRun ~= nil then GameState.prestigeRun = delta.prestigeRun end
        if delta.prestigePoints ~= nil then GameState.prestigePoints = delta.prestigePoints end
        if delta.upgrades ~= nil then
            GameState.upgrades = delta.upgrades
        end
        if delta.nodes then
            GameState.nodes = table.clone(GameState.nodes or {})
            for k, v in pairs(delta.nodes) do
                GameState.nodes[k] = HydrateNodeDelta(GameState.nodes[k], v)
            end
        end
    elseif delta._isAction then
        local action = delta.action
        GameState.nodes = table.clone(GameState.nodes or {})
        if action == "connect" or action == "disconnect" then
            if delta.updatedNodes then
                for k, v in pairs(delta.updatedNodes) do
                    GameState.nodes[k] = HydrateNodeDelta(GameState.nodes[k], v)
                end
                    local n = 0; for _ in pairs(delta.updatedNodes) do n += 1 end; return n
            end
        elseif action == "createNode" then
            if delta.nodeId and delta.node then
                GameState.nodes[delta.nodeId] = HydrateNodeDelta(nil, delta.node)
            end
            if delta.upgrades then GameState.upgrades = delta.upgrades end
        elseif action == "deleteNode" then
            if delta.nodeId then
                GameState.nodes[delta.nodeId] = nil
            end
        elseif action == "upgrade" then
            if delta.nodeId and GameState.nodes[delta.nodeId] then
                local n = table.clone(GameState.nodes[delta.nodeId])
                n.level = delta.level
                GameState.nodes[delta.nodeId] = n
            end
            if delta.cash ~= nil then GameState.cash = delta.cash end
        end
    end
end)
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
    Build = Window:AddTab("Build"),
    Upgrades = Window:AddTab("Upgrades"),
    Config = Window:AddTab("Config"),
}
Connections.TokenDropConn = Remotes.TokenDropStarted.OnClientEvent:Connect(function(dropId, expiresAt)
    if not Toggles.AutoClaimTokenDrop or not Toggles.AutoClaimTokenDrop.Value then return end
    if typeof(dropId) == "string" then
        task.wait(0.1)
        Remotes.ClaimTokenDrop:FireServer(dropId)
    end
end)
local BLeft  = Tabs.Build:AddLeftGroupbox("Auto Place")
local BRight = Tabs.Build:AddRightGroupbox("Auto Connect")
local BuildStatusLabel = BLeft:AddLabel("Status: Idle")
BLeft:AddDropdown("ExcludeNodeDropdown", {
    Text = "Exclude node(s)",
    Values = AllNodeIds,
    Default = {},
    Multi = true,
    AllowNull = true,
    Searchable = true,
})
BLeft:AddButton("Delete Excluded Nodes", function()
    local sel = Options.ExcludeNodeDropdown and Options.ExcludeNodeDropdown.Value
    local excludeSet = {}
    if type(sel) == "table" then
        for defId, active in pairs(sel) do
            if active then excludeSet[defId] = true end
        end
    end
    if not next(excludeSet) then
        Library:Notify("No nodes selected in exclude dropdown.", 3)
        return
    end
    if not GameState.nodes then
        return
    end
    local toDelete = {}
    for nodeId, nodeData in pairs(GameState.nodes) do
        if excludeSet[nodeData.definitionId] then
            table.insert(toDelete, nodeId)
        end
    end
    BuildStatusLabel:SetText("Deleting " .. #toDelete .. " node(s)...")
    for _, nodeId in ipairs(toDelete) do
        Remotes.DeleteNode:FireServer(nodeId)
        task.wait(0.05)
    end
    BuildStatusLabel:SetText("Status: Deleted " .. #toDelete .. " node(s)")
    Library:Notify("Deleted " .. #toDelete .. " node(s).", 4)
end)
local function FindNodeByDef(definitionId)
    if not GameState.nodes then return nil end
    for nodeId, nodeData in pairs(GameState.nodes) do
        if nodeData.definitionId == definitionId then
            return nodeId, nodeData
        end
    end
    return nil
end
local function FindAllNodesByDef(definitionId)
    local results = {}
    if not GameState.nodes then return results end
    for nodeId, nodeData in pairs(GameState.nodes) do
        if nodeData.definitionId == definitionId then
            results[nodeId] = nodeData
        end
    end
    return results
end
local function TryConnect(srcNodeId, dstNodeId, srcPort, dstPort)
    local srcNode = GameState.nodes and GameState.nodes[srcNodeId]
    if not srcNode then
        return false
    end
    local conns = srcNode.outputConnections and srcNode.outputConnections[srcPort]
    local target = dstNodeId .. ":" .. dstPort
    if conns then
        for _, v in ipairs(conns) do
            if v == target then
                return false
            end
        end
    end
    Remotes.ConnectPort:FireServer(srcNodeId, dstNodeId, srcPort, dstPort)
    local updatedNode = table.clone(srcNode)
    updatedNode.outputConnections = table.clone(updatedNode.outputConnections or {})
    local updatedConns = table.clone(updatedNode.outputConnections[srcPort] or {})
    if not table.find(updatedConns, target) then
        table.insert(updatedConns, target)
    end
    updatedNode.outputConnections[srcPort] = updatedConns
    GameState.nodes[srcNodeId] = updatedNode
    task.wait(0.15)
    return true
end
local function GetNextFreeDynamicInput(nodeId, nodeData, portTypeId)
    local incoming = GetAllIncomingConnections()
    local def = NodePortDefs[nodeData.definitionId]
    if not def or not def.dynamic or def.dynamic.dir ~= "input" then return nil end
    if nodeData.dynamicPorts then
        local list = nodeData.dynamicPorts[def.dynamic.prefix]
        if list then
            for _, portName in ipairs(list) do
                if not incoming[nodeId .. ":" .. portName] then
                    return portName
                end
            end
            local nextIdx = #list + 1
            if nextIdx <= def.dynamic.max then
                return def.dynamic.prefix .. "_" .. nextIdx
            end
        end
    end
    return def.dynamic.prefix .. "_1"
end
local AutoPlaceDefs = (function()
    local list = {}
    for id, def in pairs(Modules.NodeDefinitions) do
        table.insert(list, {
            id       = id,
            unlock   = def.unlockUpgradeId,
            maxCount = def.maxCount or 1,
            _cat     = def.category or "z",
            _order   = def.sortOrder or 99,
        })
    end
    table.sort(list, function(a, b)
        if a._cat ~= b._cat then return a._cat < b._cat end
        return a._order < b._order
    end)
    local COLS, COL_W, ROW_H = 5, 320, 360
    for i, entry in ipairs(list) do
        local col = (i - 1) % COLS
        local row = math.floor((i - 1) / COLS)
        entry.baseX = col * COL_W
        entry.baseY = row * ROW_H
        entry._cat  = nil  
        entry._order = nil
    end
    return list
end)()
local function PlaceEverythingAvailable()
    local upgrades = GameState.upgrades or {}
    local placed = 0
    local skipped = 0
    local excludeSet = {}
    if Options.ExcludeNodeDropdown then
        local sel = Options.ExcludeNodeDropdown.Value
        if type(sel) == "table" then
            for defId, active in pairs(sel) do
                if active then excludeSet[defId] = true end
            end
        end
    end
    for _, def in ipairs(AutoPlaceDefs) do
        if excludeSet[def.id] then
            skipped += 1
        elseif def.unlock and (upgrades[def.unlock] or 0) < 1 then
            skipped += 1
        else
            local existing = FindAllNodesByDef(def.id)
            local count = 0
            for _ in pairs(existing) do count += 1 end
            if count < def.maxCount then
                local x = math.clamp(def.baseX + count * 300, -1900, 1900)
                local y = math.clamp(def.baseY, -1900, 1900)
                BuildStatusLabel:SetText("Placing: " .. def.id .. " (" .. count+1 .. "/" .. def.maxCount .. ")")
                local newId = CreateNodeAndWait(def.id, SnapPos(x, y))
                if newId then
                    placed += 1
                    task.wait(0.2)
                else
                end
            end
        end
    end
    if placed > 0 then
        BuildStatusLabel:SetText("Status: Placed " .. placed .. " node(s)")
        Library:Notify("Auto Place: placed " .. placed .. " node(s)!", 4)
    else
        BuildStatusLabel:SetText("Status: Idle")
    end
end
BLeft:AddToggle("AutoPlaceAll", {
    Text = "Auto Place",
    Default = false,
    Callback = function(value)
        Thread("AutoPlaceAll", SafeLoop("AutoPlaceAll", function()
            while Toggles.AutoPlaceAll.Value do
                task.spawn(SafeLoop("AutoPlaceAll", PlaceEverythingAvailable))
                task.wait(1)
            end
        end), value)
    end
})
local ConnectStatusLabel = BRight:AddLabel("Status: Idle")
local specificOutPorts = {
    VirusScanner  = { OutInfected = true },
    FileValidator = { OutCorrupted = true },
}
local specificRules = {
    { srcDef = "VirusScanner",  srcPort = "OutInfected",  dstDef = "VirusCleaner", dstPort = "In" },
    { srcDef = "FileValidator", srcPort = "OutCorrupted", dstDef = "FileFixer",    dstPort = "In" },
}
local function RunAutoConnect()
    if not GameState.nodes then
        ConnectStatusLabel:SetText("Status: No nodes")
        return
    end
    local incoming = GetAllIncomingConnections()
    local connected = 0
    for _, rule in ipairs(specificRules) do
        local srcs = FindAllNodesByDef(rule.srcDef)
        local dsts = FindAllNodesByDef(rule.dstDef)
        for srcId in pairs(srcs) do
            local srcNode = GameState.nodes[srcId]
            local existingConns = srcNode and srcNode.outputConnections and srcNode.outputConnections[rule.srcPort]
            if not existingConns or #existingConns == 0 then
                for dstId in pairs(dsts) do
                    local inKey = dstId .. ":" .. rule.dstPort
                    if not incoming[inKey] then
                        if TryConnect(srcId, dstId, rule.srcPort, rule.dstPort) then
                            incoming[inKey] = true
                            connected = connected + 1
                            break
                        end
                    end
                end
            end
        end
    end
    for srcId, srcData in pairs(GameState.nodes) do
        local outPorts = GetNodeOutputPorts(srcData)
        for outPortName, outTypeId in pairs(outPorts) do
            local ruleBlock = specificOutPorts[srcData.definitionId]
            if ruleBlock and ruleBlock[outPortName] then continue end
            for dstId, dstData in pairs(GameState.nodes) do
                if dstId == srcId then continue end
                local def = NodePortDefs[dstData.definitionId]
                if def and def.dynamic and def.dynamic.dir == "input" then
                    if ArePortsCompatible(outTypeId, def.dynamic.typeId) then
                        local freePort = GetNextFreeDynamicInput(dstId, dstData, def.dynamic.typeId)
                        if freePort and not incoming[dstId .. ":" .. freePort] then
                            TryConnect(srcId, dstId, outPortName, freePort)
                            incoming = GetAllIncomingConnections()
                            connected = connected + 1
                        end
                    end
                else
                    local inPorts = GetNodeInputPorts(dstData)
                    for inPortName, inTypeId in pairs(inPorts) do
                        local inKey = dstId .. ":" .. inPortName
                        if not incoming[inKey] and ArePortsCompatible(outTypeId, inTypeId) then
                            TryConnect(srcId, dstId, outPortName, inPortName)
                            incoming = GetAllIncomingConnections()
                            connected = connected + 1
                            break
                        end
                    end
                end
            end
        end
    end
    if connected > 0 then
        ConnectStatusLabel:SetText("Status: Connected " .. connected .. " port(s)")
        Library:Notify("Auto-connect: wired " .. connected .. " port(s).", 4)
    else
        ConnectStatusLabel:SetText("Status: Idle")
    end
end
local function AutoConnectLoopFunc()
    while Toggles.AutoConnect.Value do
        task.spawn(SafeLoop("AutoConnect", RunAutoConnect))
        task.wait(1)
    end
end
BRight:AddToggle("AutoConnect", {
    Text = "Auto Connect",
    Default = false,
    Callback = function(value)
        Thread("AutoConnect", SafeLoop("AutoConnect", AutoConnectLoopFunc), value)
    end
})
local ULeft = Tabs.Upgrades:AddLeftGroupbox("Upgrades")
local URight = Tabs.Upgrades:AddRightGroupbox("Misc")
ULeft:AddDropdown("ExcludeGlobalUpgradesDropdown", {
    Text = "Exclude upgrade(s)",
    Values = GlobalUpgradeIds,
    Default = {},
    Multi = true,
    AllowNull = true,
    Searchable = true,
})
local function AutoBuyUpgradesFunc()
    while Toggles.AutoBuyUpgrades.Value do
        local upgrades = GameState.upgrades or {}
        local excludeSel = Options.ExcludeGlobalUpgradesDropdown and Options.ExcludeGlobalUpgradesDropdown.Value or {}
        for _, upgradeId in ipairs(GlobalUpgradeIds) do
            if Toggles.AutoBuyUpgrades.Value then
                local excluded = type(excludeSel) == "table" and excludeSel[upgradeId]
                if not excluded then
                    Remotes.BuyGlobalUpgrade:FireServer(upgradeId)
                    task.wait(0.1)
                end
            end
        end
        task.wait(1)
    end
end
ULeft:AddToggle("AutoBuyUpgrades", {
    Text = "Auto Buy Global Upgrades",
    Default = false,
    Callback = function(value)
        Thread("AutoBuyUpgrades", SafeLoop("AutoBuyUpgrades", AutoBuyUpgradesFunc), value)
    end
})
ULeft:AddDropdown("ExcludeResearchUpgradesDropdown", {
    Text = "Exclude research upgrade(s)",
    Values = ResearchUpgradeIds,
    Default = {},
    Multi = true,
    AllowNull = true,
    Searchable = true,
})
local function AutoBuyResearchUpgradesFunc()
    while Toggles.AutoBuyResearchUpgrades.Value do
        local excludeSel = Options.ExcludeResearchUpgradesDropdown and Options.ExcludeResearchUpgradesDropdown.Value or {}
        for _, upgradeId in ipairs(ResearchUpgradeIds) do
            if Toggles.AutoBuyResearchUpgrades.Value then
                local excluded = type(excludeSel) == "table" and excludeSel[upgradeId]
                if not excluded then
                    Remotes.BuyGlobalUpgrade:FireServer(upgradeId)
                    task.wait(0.1)
                end
            end
        end
        task.wait(1)
    end
end
ULeft:AddToggle("AutoBuyResearchUpgrades", {
    Text = "Auto Buy Research Upgrades",
    Default = false,
    Callback = function(value)
        Thread("AutoBuyResearchUpgrades", SafeLoop("AutoBuyResearchUpgrades", AutoBuyResearchUpgradesFunc), value)
    end
})
ULeft:AddDropdown("ExcludeTokenUpgradesDropdown", {
    Text = "Exclude token upgrade(s)",
    Values = TokenUpgradeIds,
    Default = {},
    Multi = true,
    AllowNull = true,
    Searchable = true,
})
local function AutoBuyTokenUpgradesFunc()
    while Toggles.AutoBuyTokenUpgrades.Value do
        local excludeSel = Options.ExcludeTokenUpgradesDropdown and Options.ExcludeTokenUpgradesDropdown.Value or {}
        for _, upgradeId in ipairs(TokenUpgradeIds) do
            if Toggles.AutoBuyTokenUpgrades.Value then
                local excluded = type(excludeSel) == "table" and excludeSel[upgradeId]
                if not excluded then
                    Remotes.BuySpecialDonationUpgrade:FireServer(upgradeId)
                    task.wait(0.1)
                end
            end
        end
        task.wait(1)
    end
end
ULeft:AddToggle("AutoBuyTokenUpgrades", {
    Text = "Auto Buy Token Upgrades",
    Default = false,
    Callback = function(value)
        Thread("AutoBuyTokenUpgrades", SafeLoop("AutoBuyTokenUpgrades", AutoBuyTokenUpgradesFunc), value)
    end
})
local function AutoMasteryClickFunc()
    while Toggles.AutoMasteryClick.Value do
        if GameState.nodes then
            for nodeId, nodeData in pairs(GameState.nodes) do
                if nodeData.definitionId == "MasteryConsole" then
                    Remotes.RequestLevelNodeXP:FireServer(nodeId)
                    task.wait(0.05)
                end
            end
        end
        task.wait(0.1)
    end
end
URight:AddToggle("AutoMasteryClick", {
    Text = "Auto Mastery Click",
    Default = true,
    Callback = function(value)
        Thread("AutoMasteryClick", SafeLoop("AutoMasteryClick", AutoMasteryClickFunc), value)
    end
})
ULeft:AddDropdown("SelectUpgradeNodesDropdown", {
    Text = "Nodes To Upgrade",
    Values = AllNodeIds,
    Default = {},
    Multi = true,
    AllowNull = true,
    Searchable = true,
})
local function AutoUpgradeNodesFunc()
    while Toggles.AutoUpgradeNodes.Value do
        if GameState.nodes then
            local sel = Options.SelectUpgradeNodesDropdown and Options.SelectUpgradeNodesDropdown.Value or {}
            local hasSelection = false
            if type(sel) == "table" then
                for _, active in pairs(sel) do
                    if active then hasSelection = true; break end
                end
            end
            for nodeId, nodeData in pairs(GameState.nodes) do
                if Toggles.AutoUpgradeNodes.Value then
                    local shouldUpgrade = true
                    if hasSelection then
                        shouldUpgrade = type(sel) == "table" and sel[nodeData.definitionId] == true
                    end
                    if shouldUpgrade then
                        Remotes.RequestUpgradeNode:FireServer(nodeId, 1)
                        task.wait(0.05)
                    end
                end
            end
        end
        task.wait(1)
    end
end
ULeft:AddToggle("AutoUpgradeNodes", {
    Text = "Auto Upgrade Nodes",
    Default = false,
    Callback = function(value)
        Thread("AutoUpgradeNodes", SafeLoop("AutoUpgradeNodes", AutoUpgradeNodesFunc), value)
    end
})
local function AutoBuyProcessorCoresFunc()
    while Toggles.AutoBuyProcessorCores.Value do
        Remotes.RequestBuyProcessorCore:FireServer(1)
        task.wait(1)
    end
end
ULeft:AddToggle("AutoBuyProcessorCores", {
    Text = "Auto Buy Processor Cores",
    Default = false,
    Callback = function(value)
        Thread("AutoBuyProcessorCores", SafeLoop("AutoBuyProcessorCores", AutoBuyProcessorCoresFunc), value)
    end
})
URight:AddToggle("AutoClaimTokenDrop", {
    Text = "Auto Claim Token",
    Default = true,
})
URight:AddToggle("AutoPrestige", {
    Text = "Auto Prestige",
    Default = false,
})
URight:AddInput("AutoPrestigeThreshold", {
    Default = "10",
    Numeric = true,
    Finished = false,
    ClearTextOnFocus = false,
    Text = "Prestige Pot Threshold",
})
local function AutoPrestigeFunc()
    while Toggles.AutoPrestige.Value do
        local threshold = tonumber(Options.AutoPrestigeThreshold and Options.AutoPrestigeThreshold.Value) or 10
        local portalResearch = GameState.prestigeRun and GameState.prestigeRun.portalResearch or 0
        local potentialPoints = 0
        if Modules.PrestigeConfig and Modules.PrestigeConfig.calculatePotentialPoints then
            local ok, pts = pcall(Modules.PrestigeConfig.calculatePotentialPoints, portalResearch, GameState.upgrades)
            if ok then potentialPoints = pts end
        end
        if potentialPoints >= threshold then
            Remotes.EnterPrestige:FireServer()
            task.wait(5) 
        end
        task.wait(2)
    end
end
Toggles.AutoPrestige:OnChanged(function()
    Thread("AutoPrestige", SafeLoop("AutoPrestige", AutoPrestigeFunc), Toggles.AutoPrestige.Value)
end)
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AntiAFK2", { Text = "Anti AFK", Default = true })
local function DisableIdled2()
    pcall(function()
        local cons = getconnections or get_signal_cons
        if cons then
            for _, v in ipairs(cons(Plr.Idled)) do
                if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end
            end
        end
    end)
end
task.spawn(function()
    DisableIdled2()
    while true do
        task.wait(60)
        if Toggles.AntiAFK2 and Toggles.AntiAFK2.Value then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                task.wait(0.2)
                VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)
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
    Cleanup(Connections)
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/Overclock")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
Flags.InfoLoop = task.spawn(function()
    while true do
        pcall(UpdateInfoLabels)
        task.wait(1)
    end
end)
Library:Notify("Yuri!", 3)
Library:Notify("Game loaded", 3)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
end
