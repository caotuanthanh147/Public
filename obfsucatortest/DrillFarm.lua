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
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');
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
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
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
local Source = RS:FindFirstChild("Source") or RS:WaitForChild("Source", 10)
local Packages = Source and (Source:FindFirstChild("Packages") or Source:WaitForChild("Packages", 10))
local Knit = nil
local function GetKnit()
    if Knit then return Knit end
    if not Packages then return nil end
    local ok, knit = pcall(require, Packages:FindFirstChild("Knit") or Packages:WaitForChild("Knit", 10))
    if ok and knit then Knit = knit return knit end
    return nil
end
local function GetService(name)
    local knit = GetKnit()
    if not knit then return nil end
    local ok, svc = pcall(function() return knit.GetService(name) end)
    if ok then return svc end
    return nil
end
local function AwaitPromise(promise)
    if not promise then return nil end
    if type(promise) ~= "table" then return promise end
    if promise.await then
        local ok, result = promise:await()
        if ok then return result end
        return nil
    end
    return promise
end
local Remotes = {}
local Modules = {
    Knit = GetKnit(),
}
local TotemsMetadataModule = nil
local function GetTotemsMetadata()
    if TotemsMetadataModule then return TotemsMetadataModule end
    local Src = RS:FindFirstChild("Source") or RS:WaitForChild("Source", 10)
    local Metadatas = Src and (Src:FindFirstChild("Metadatas") or Src:WaitForChild("Metadatas", 10))
    if not Metadatas then return nil end
    local ok, m = pcall(require, Metadatas:WaitForChild("TotemsMetadata", 10))
    if ok and m then TotemsMetadataModule = m end
    return TotemsMetadataModule
end
local DrillsMetadataModule = nil
local function GetDrillsMetadata()
    if DrillsMetadataModule then return DrillsMetadataModule end
    local Source = RS:FindFirstChild("Source") or RS:WaitForChild("Source", 10)
    local Metadatas = Source and (Source:FindFirstChild("Metadatas") or Source:WaitForChild("Metadatas", 10))
    if not Metadatas then return nil end
    local ok, m = pcall(require, Metadatas:WaitForChild("DrillsMetadata", 10))
    if ok and m then DrillsMetadataModule = m end
    return DrillsMetadataModule
end
local LeverMetadataModule = nil
local function GetLeverMetadata()
    if LeverMetadataModule then return LeverMetadataModule end
    local Src = RS:FindFirstChild("Source") or RS:WaitForChild("Source", 10)
    local Metadatas = Src and (Src:FindFirstChild("Metadatas") or Src:WaitForChild("Metadatas", 10))
    if not Metadatas then return nil end
    local ok, m = pcall(require, Metadatas:WaitForChild("LeverMetadata", 10))
    if ok and m then LeverMetadataModule = m end
    return LeverMetadataModule
end
local MinerMetadataModule = nil
local function GetMinerMetadata()
    if MinerMetadataModule then return MinerMetadataModule end
    local Src = RS:FindFirstChild("Source") or RS:WaitForChild("Source", 10)
    local Metadatas = Src and (Src:FindFirstChild("Metadatas") or Src:WaitForChild("Metadatas", 10))
    if not Metadatas then return nil end
    local ok, m = pcall(require, Metadatas:WaitForChild("MinerMetadata", 10))
    if ok and m then MinerMetadataModule = m end
    return MinerMetadataModule
end
local RARITY_ORDER = { Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Mythical = 6, Limited = 7 }
local function GetDrillDisplayList()
    local meta = GetDrillsMetadata()
    if not meta then return {} end
    local entries = {}
    for drillId, data in pairs(meta) do
        if type(data) == "table" and data.Name and data.Rarity then
            table.insert(entries, { id = drillId, name = data.Name, rarity = data.Rarity })
        end
    end
    table.sort(entries, function(a, b)
        local ra = RARITY_ORDER[a.rarity] or 99
        local rb = RARITY_ORDER[b.rarity] or 99
        if ra ~= rb then return ra < rb end
        return a.name < b.name
    end)
    local result = {}
    for _, e in ipairs(entries) do
        table.insert(result, e.name .. " | " .. e.rarity)
    end
    return result
end
local function GetDrillIdFromLabel(label)
    local meta = GetDrillsMetadata()
    if not meta then return nil end
    local targetName = label:match("^(.-)%s*|")
    if not targetName then return nil end
    targetName = targetName:match("^%s*(.-)%s*$")
    for drillId, data in pairs(meta) do
        if type(data) == "table" and data.Name == targetName then
            return drillId
        end
    end
    return nil
end
local function GetTotemDisplayList()
    local meta = GetTotemsMetadata()
    if not meta then return {} end
    local TOTEM_RARITY_ORDER = { Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5 }
    local entries = {}
    for totemId, data in pairs(meta) do
        if type(data) == "table" and data.Name and data.Rarity then
            table.insert(entries, { id = totemId, name = data.Name, rarity = data.Rarity })
        end
    end
    table.sort(entries, function(a, b)
        local ra = TOTEM_RARITY_ORDER[a.rarity] or 99
        local rb = TOTEM_RARITY_ORDER[b.rarity] or 99
        if ra ~= rb then return ra < rb end
        return a.name < b.name
    end)
    local result = {}
    for _, e in ipairs(entries) do
        table.insert(result, e.name .. " | " .. e.rarity)
    end
    return result
end
local function GetTotemIdFromLabel(label)
    local meta = GetTotemsMetadata()
    if not meta then return nil end
    local targetName = label:match("^(.-)%s*|")
    if not targetName then return nil end
    targetName = targetName:match("^%s*(.-)%s*$")
    for totemId, data in pairs(meta) do
        if type(data) == "table" and data.Name == targetName then
            return totemId
        end
    end
    return nil
end
local function GetOwnPlot()
    local map = workspace:FindFirstChild("Map")
    local bases = map and map:FindFirstChild("Bases")
    if not bases then return nil end
    for _, plot in ipairs(bases:GetChildren()) do
        if plot:GetAttribute("OwnerUserId") == Plr.UserId then
            return plot
        end
    end
    return nil
end
local function GetCurrentOres()
    local repFolder = Plr:FindFirstChild("_replicationFolder")
    local tycoon = repFolder and repFolder:FindFirstChild("Tycoon")
    if tycoon then
        return tycoon:GetAttribute("CurrentOres") or 0
    end
    return 0
end
local function GetPlayerCash()
    local repFolder = Plr:FindFirstChild("_replicationFolder")
    local currencies = repFolder and repFolder:FindFirstChild("Currencies")
    if currencies then
        return currencies:GetAttribute("Cash") or 0
    end
    return 0
end
local function GetPlayerGems()
    local repFolder = Plr:FindFirstChild("_replicationFolder")
    local currencies = repFolder and repFolder:FindFirstChild("Currencies")
    if currencies then
        return currencies:GetAttribute("Gems") or 0
    end
    return 0
end
local function GetDrillToolFromBackpackOrChar()
    local char = Plr.Character
    local backpack = Plr:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, v in ipairs(backpack:GetChildren()) do
            if v:IsA("Tool") and v:GetAttribute("Kind") == "Drill" then
                return v, false
            end
        end
    end
    if char then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Tool") and v:GetAttribute("Kind") == "Drill" then
                return v, true 
            end
        end
    end
    return nil, false
end
local SpinConn = nil
local SpinCallback = nil 
local dbgGetUpvals = debug and (debug.getupvalues or debug.getupvals) or getupvalues or getupvals
local islclosureFn = islclosure or is_l_closure or function() return true end
local function IsBought(fn)
    if not (fn and dbgGetUpvals and islclosureFn(fn)) then return nil end
    local ok, uvs = pcall(dbgGetUpvals, fn)
    if not ok or type(uvs) ~= "table" then return nil end
    for k, v in pairs(uvs) do
        if type(v) == "boolean" and k == "bought" then
            return true, v
        end
    end
    for _, v in ipairs(uvs) do
        if type(v) == "boolean" then
            return true, v
        end
    end
    return nil
end
local function GetDrillFootprint(drillId)
    local meta = GetDrillsMetadata()
    if not meta or not drillId then return 1, 1 end
    local data = meta[drillId]
    if not data or not data.Size then return 1, 1 end
    return data.Size.Width or 1, data.Size.Height or 1
end
local function FindEmptyCell(tile)
    local cellNames = { "Cell1", "Cell2", "Cell3", "Cell4" }
    for _, cellName in ipairs(cellNames) do
        local cell = tile:FindFirstChild(cellName)
        if cell and cell:IsA("BasePart") then
            if cell:GetAttribute("PlacementKind") == nil then
                local attach = cell:FindFirstChild("PlacePromptAttach")
                local pp = attach and attach:FindFirstChild("PlacePrompt")
                if pp and pp:IsA("ProximityPrompt") then
                    return pp, cell
                end
            end
        end
    end
    return nil, nil
end
local function Func_AutoPlaceDrill()
    while Toggles.AutoPlaceDrill.Value do
        local plot = GetOwnPlot()
        if not plot then
            notyuri("[AutoPlace] No plot found")
            task.wait(3)
            continue
        end
        local Grid = plot:FindFirstChild("Grid")
        local GridTiles = Grid and Grid:FindFirstChild("GridTiles")
        if not GridTiles then
            notyuri("[AutoPlace] No GridTiles found")
            task.wait(3)
            continue
        end
        local filterValue = Options.PlaceList and Options.PlaceList.Value or {}
        local anySelected = false
        local filterActive = false
        local selectedIds = {}
        for label, active in pairs(filterValue) do
            if active then
                if label == "Any" then
                    anySelected = true
                else
                    local id = GetDrillIdFromLabel(label)
                    if id then
                        selectedIds[id] = true
                        filterActive = true
                    end
                end
            end
        end
        local backpack = Plr:FindFirstChildOfClass("Backpack")
        local char = Plr.Character
        local drillTool = nil
        local alreadyEquipped = false
        local drillFootprintW = 1
        local drillFootprintH = 1
        local function findMatchingTool(container, equipped)
            if not container then return end
            for _, v in ipairs(container:GetChildren()) do
                if v:IsA("Tool") then
                    local kind = v:GetAttribute("Kind")
                    local toolId = v:GetAttribute("Id")
                    if kind == "Drill" then
                        local passes = anySelected or not filterActive or (toolId and selectedIds[toolId])
                        if passes then
                            drillTool = v
                            alreadyEquipped = equipped
                            if toolId then
                                drillFootprintW, drillFootprintH = GetDrillFootprint(toolId)
                            end
                            return
                        end
                    end
                end
            end
        end
        findMatchingTool(backpack, false)
        if not drillTool then findMatchingTool(char, true) end
        if not drillTool then
            notyuri("[AutoPlace] No matching drill tool found")
            task.wait(3)
            continue
        end
        notyuri("[AutoPlace] Using tool:", drillTool.Name, "footprint:", drillFootprintW, "x", drillFootprintH)
        local placedThisPass = {}
        for _, tile in ipairs(GridTiles:GetChildren()) do
            if not Toggles.AutoPlaceDrill.Value then break end
            if tile:GetAttribute("Locked") == true then
                continue
            end
            if placedThisPass[tile] then
                continue
            end
            local pp, cell = FindEmptyCell(tile)
            if pp then
                local didEquip = false
                if not alreadyEquipped then
                    if char then
                        pcall(function() drillTool.Parent = char end)
                        didEquip = true
                        task.wait(.1)
                    end
                end
                FirePP(pp, true)
                task.wait()
                if didEquip and drillTool and drillTool.Parent ~= nil then
                    pcall(function() drillTool.Parent = Plr.Backpack end)
                end
                placedThisPass[tile] = true
                if drillFootprintW > 1 or drillFootprintH > 1 then
                    notyuri("[AutoPlace] Placed 2x2+ drill on tile:", tile.Name)
                    local tileIdx = tonumber(tile.Name:match("%d+")) or 0
                    local nextTile = GridTiles:FindFirstChild("GridTile" .. (tileIdx + 1))
                    if nextTile then placedThisPass[nextTile] = true end
                end
                drillTool = nil
                alreadyEquipped = false
                findMatchingTool(backpack, false)
                if not drillTool then findMatchingTool(char, true) end
                if not drillTool then
                    notyuri("[AutoPlace] No more drill tools - stopping")
                    break
                end
                local newToolId = drillTool:GetAttribute("Id")
                if newToolId then
                    drillFootprintW, drillFootprintH = GetDrillFootprint(newToolId)
                end
            end
        end
        task.wait(1)
    end
end
local function GetUpgradeCost(label)
    local repFolder = Plr:FindFirstChild("_replicationFolder")
    local tycoon = repFolder and repFolder:FindFirstChild("Tycoon")
    if label == "Spin Luck" then
        local meta = GetLeverMetadata()
        if not meta or not tycoon then return nil end
        local currentLuck = tycoon:GetAttribute("LeverLuck") or 0
        return meta:GetLuckPrice(currentLuck + 1)
    elseif label == "Spin Spots" then
        local meta = GetLeverMetadata()
        local spinSvc = GetService("SpinDrillService")
        if not meta or not spinSvc then return nil end
        local activeSpots = nil
        local cfg = AwaitPromise(spinSvc:GetSpotConfig(Plr.UserId))
        if cfg and type(cfg) == "table" and cfg.ActiveSpots then
            activeSpots = cfg.ActiveSpots
        end
        if not activeSpots then return nil end
        return meta:GetSpotPrice(activeSpots + 1)
    elseif label == "Miner Luck" then
        local meta = GetMinerMetadata()
        if not meta or not tycoon then return nil end
        local currentLuck = tycoon:GetAttribute("MinerLuck") or 0
        return meta:GetMinerLuckPrice(currentLuck + 1)
    elseif label == "Ores Per Hit" then
        local meta = GetMinerMetadata()
        if not meta or not tycoon then return nil end
        local currentLevel = tycoon:GetAttribute("OresPerMinerHitLevel") or 1
        return meta:GetOresPerHitPrice(currentLevel + 1)
    end
    return nil
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local selected = Options.UpgradeList and Options.UpgradeList.Value or {}
        local spinSvc = GetService("SpinDrillService")
        local plotSvc = GetService("PlotService")
        local cash = GetPlayerCash()
        for label, enabled in pairs(selected) do
            if not enabled then continue end
            local cost = GetUpgradeCost(label)
            if cost and cash < cost then
                notyuri("[AutoUpgrade] Can't afford", label, "- need $" .. tostring(cost) .. ", have $" .. tostring(cash))
                continue
            end
            if label == "Spin Luck" and spinSvc then
                pcall(function() spinSvc:UpgradeLuck() end)
                task.wait(.1)
            elseif label == "Spin Spots" and spinSvc then
                pcall(function() spinSvc:UpgradeSpots() end)
                task.wait(.1)
            elseif label == "Miner Luck" and plotSvc then
                pcall(function() plotSvc:UpgradeMinerLuck() end)
                task.wait(.1)
            elseif label == "Ores Per Hit" and plotSvc then
                pcall(function() plotSvc:UpgradeOresPerHit() end)
                task.wait(.1)
            end
        end
        task.wait(1)
    end
end
local RemoveDrillRF = nil
local function GetRemoveDrillRF()
    if RemoveDrillRF then return RemoveDrillRF end
    local ok, rf = pcall(function()
        return RS
            :WaitForChild("Source", 10)
            :WaitForChild("Packages", 10)
            :WaitForChild("_Index", 10)
            :WaitForChild("sleitnick_knit@1.5.1", 10)
            :WaitForChild("knit", 10)
            :WaitForChild("Services", 10)
            :WaitForChild("PlacementService", 10)
            :WaitForChild("RF", 10)
            :WaitForChild("RemoveDrill", 10)
    end)
    if ok and rf then RemoveDrillRF = rf end
    return RemoveDrillRF
end
local DeleteItemsRF = nil
local function GetDeleteItemsRF()
    if DeleteItemsRF then return DeleteItemsRF end
    local ok, rf = pcall(function()
        return RS
            :WaitForChild("Source", 10)
            :WaitForChild("Packages", 10)
            :WaitForChild("_Index", 10)
            :WaitForChild("sleitnick_knit@1.5.1", 10)
            :WaitForChild("knit", 10)
            :WaitForChild("Services", 10)
            :WaitForChild("InventoryService", 10)
            :WaitForChild("RF", 10)
            :WaitForChild("DeleteItems", 10)
    end)
    if ok and rf then DeleteItemsRF = rf end
    return DeleteItemsRF
end
local function Func_AutoRemove()
    while Toggles.AutoRemove.Value do
        local plot = GetOwnPlot()
        if not plot then
            notyuri("[AutoRemove] No plot found")
            task.wait(3)
            continue
        end
        local PlacedItems = plot:FindFirstChild("PlacedItems")
        if not PlacedItems then
            notyuri("[AutoRemove] No PlacedItems found")
            task.wait(3)
            continue
        end
        local filterValue = Options.RemoveList and Options.RemoveList.Value or {}
        local anySelected = false
        local filterActive = false
        local selectedIds = {}
        for label, active in pairs(filterValue) do
            if active then
                if label == "Any" then
                    anySelected = true
                else
                    local id = GetDrillIdFromLabel(label)
                    if id then
                        selectedIds[id] = true
                        filterActive = true
                    end
                end
            end
        end
        local rf = GetRemoveDrillRF()
        if not rf then
            notyuri("[AutoRemove] RemoveDrill RF not found")
            task.wait(3)
            continue
        end
        for _, model in ipairs(PlacedItems:GetChildren()) do
            if not Toggles.AutoRemove.Value then break end
            local drillId = model:GetAttribute("DrillId")
            if not drillId then continue end
            local passes = anySelected or not filterActive or selectedIds[drillId]
            if not passes then continue end
            notyuri("[AutoRemove] Removing drill:", model.Name, "DrillId:", drillId)
            pcall(function() rf:InvokeServer(model) end)
            task.wait(0.175)
        end
        task.wait(1)
    end
end
local function Func_AutoDelete()
    while Toggles.AutoDelete.Value do
        local filterValue = Options.RemoveList and Options.RemoveList.Value or {}
        local anySelected = false
        local filterActive = false
        local selectedIds = {}
        for label, active in pairs(filterValue) do
            if active then
                if label == "Any" then
                    anySelected = true
                else
                    local id = GetDrillIdFromLabel(label)
                    if id then
                        selectedIds[id] = true
                        filterActive = true
                    end
                end
            end
        end
        local delRF = GetDeleteItemsRF()
        if delRF then
            local backpack = Plr:FindFirstChildOfClass("Backpack")
            local char = Plr.Character
            local uidsToDelete = {}
            local function scanContainer(container)
                if not container then return end
                for _, v in ipairs(container:GetChildren()) do
                    if v:IsA("Tool") and v:GetAttribute("Kind") == "Drill" then
                        local toolId = v:GetAttribute("Id")
                        local passes = anySelected or not filterActive or (toolId and selectedIds[toolId])
                        if passes then
                            local uid = v:GetAttribute("Uid") or v:GetAttribute("UID") or v:GetAttribute("Guid")
                            if uid then
                                table.insert(uidsToDelete, uid)
                            end
                        end
                    end
                end
            end
            scanContainer(backpack)
            scanContainer(char)
            if #uidsToDelete > 0 then
                notyuri("[AutoDelete] Deleting", #uidsToDelete, "drill tools from inventory")
                pcall(function() delRF:InvokeServer(uidsToDelete) end)
            end
        end
        task.wait(1)
    end
end
local MinOresThreshold = 0
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        local plot = GetOwnPlot()
        if plot then
            local currentOres = GetCurrentOres()
            local threshold = MinOresThreshold
            notyuri("[AutoSell] currentOres:", currentOres, "threshold:", threshold)
            if threshold <= 0 or currentOres >= threshold then
                local Minecart = plot:FindFirstChild("Minecart")
                if Minecart then
                    local collectAttach = Minecart:FindFirstChild("CollectPromptAttach", true)
                    local collectPP = collectAttach and collectAttach:FindFirstChild("CollectOresPrompt")
                    if collectPP and collectPP:IsA("ProximityPrompt") then
                        notyuri("[AutoSell] firing CollectOresPrompt")
                        FirePP(collectPP, true)
                        task.wait()
                    end
                end
                local Miner = plot:FindFirstChild("Miner")
                if Miner then
                    local Zone = Miner:FindFirstChild("Zone")
                    local Attachment = Zone and Zone:FindFirstChild("Attachment")
                    local depositPP = Attachment and Attachment:FindFirstChild("DepositOresPrompt")
                    if depositPP and depositPP:IsA("ProximityPrompt") then
                        notyuri("[AutoSell] firing DepositOresPrompt")
                        FirePP(depositPP, true)
                        task.wait()
                    end
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoBuyTotem()
    while Toggles.AutoBuyTotem.Value do
        local svc = GetService("TotemShopService")
        if not svc then
            notyuri("[AutoBuyTotem] TotemShopService not found")
            task.wait(3)
            continue
        end
        local filterValue = Options.BuyTotemList and Options.BuyTotemList.Value or {}
        local anySelected = false
        local filterActive = false
        local selectedIds = {}
        for label, active in pairs(filterValue) do
            if active then
                if label == "Any" then
                    anySelected = true
                else
                    local id = GetTotemIdFromLabel(label)
                    if id then
                        selectedIds[id] = true
                        filterActive = true
                    end
                end
            end
        end
        local meta = GetTotemsMetadata()
        if not meta then
            notyuri("[AutoBuyTotem] TotemsMetadata not found")
            task.wait(3)
            continue
        end
        for totemId, data in pairs(meta) do
            if not Toggles.AutoBuyTotem.Value then break end
            if type(data) ~= "table" then continue end
            local passes = anySelected or not filterActive or selectedIds[totemId]
            if not passes then continue end
            local cash = GetPlayerCash()
            local price = data.Price or 0
            if price > 0 and cash < price then
                notyuri("[AutoBuyTotem] Can't afford", totemId, "- need", price, "have", cash)
                continue
            end
            notyuri("[AutoBuyTotem] Buying:", totemId)
            pcall(function() svc:BuyWithCash(totemId) end)
            task.wait(0.2)
        end
        task.wait(1)
    end
end
local function Func_AutoPlaceTotem()
    while Toggles.AutoPlaceTotem.Value do
        local plot = GetOwnPlot()
        if not plot then
            notyuri("[AutoPlaceTotem] No plot found")
            task.wait(3)
            continue
        end
        local PlacementAnchors = plot:FindFirstChild("PlacementAnchors")
        if not PlacementAnchors then
            notyuri("[AutoPlaceTotem] No PlacementAnchors found")
            task.wait(3)
            continue
        end
        local filterValue = Options.PlaceTotemList and Options.PlaceTotemList.Value or {}
        local anySelected = false
        local filterActive = false
        local selectedIds = {}
        for label, active in pairs(filterValue) do
            if active then
                if label == "Any" then
                    anySelected = true
                else
                    local id = GetTotemIdFromLabel(label)
                    if id then
                        selectedIds[id] = true
                        filterActive = true
                    end
                end
            end
        end
        local backpack = Plr:FindFirstChildOfClass("Backpack")
        local char = Plr.Character
        local totemTool = nil
        local alreadyEquipped = false
        local function findMatchingTotem(container, equipped)
            if not container then return end
            for _, v in ipairs(container:GetChildren()) do
                if v:IsA("Tool") then
                    local kind = v:GetAttribute("Kind")
                    local toolId = v:GetAttribute("Id")
                    if kind == "Totem" then
                        local passes = anySelected or not filterActive or (toolId and selectedIds[toolId])
                        if passes then
                            totemTool = v
                            alreadyEquipped = equipped
                            return
                        end
                    end
                end
            end
        end
        findMatchingTotem(backpack, false)
        if not totemTool then findMatchingTotem(char, true) end
        if not totemTool then
            notyuri("[AutoPlaceTotem] No matching totem tool found")
            task.wait(3)
            continue
        end
        notyuri("[AutoPlaceTotem] Using tool:", totemTool.Name)
        for _, anchorPart in ipairs(PlacementAnchors:GetChildren()) do
            if not Toggles.AutoPlaceTotem.Value then break end
            if not anchorPart:IsA("BasePart") then continue end
            if anchorPart:GetAttribute("Placeable") == false then continue end
            local AnchorPromptAttach = anchorPart:FindFirstChild("AnchorPromptAttach")
            local AnchorPrompt = AnchorPromptAttach and AnchorPromptAttach:FindFirstChild("AnchorPrompt")
            if not (AnchorPrompt and AnchorPrompt:IsA("ProximityPrompt")) then continue end
            local didEquip = false
            if not alreadyEquipped then
                if char then
                    pcall(function() totemTool.Parent = char end)
                    didEquip = true
                    task.wait(0.1)
                end
            end
            notyuri("[AutoPlaceTotem] Firing AnchorPrompt on:", anchorPart.Name)
            FirePP(AnchorPrompt, true)
            task.wait(0.2)
            if didEquip and totemTool and totemTool.Parent ~= nil then
                pcall(function() totemTool.Parent = Plr.Backpack end)
            end
            totemTool = nil
            alreadyEquipped = false
            findMatchingTotem(backpack, false)
            if not totemTool then findMatchingTotem(char, true) end
            if not totemTool then
                notyuri("[AutoPlaceTotem] No more totem tools - stopping")
                break
            end
        end
        task.wait(1)
    end
end
local BlackmarketItemsGemPrices = {
    NormalTimeMachine  = 250,
    MediumTimeMachine  = 800,
    LargeTimeMachine   = 1600,
    InstantTimeMachine = 3100,
    NormalSpeedBooster = 100,
    MediumSpeedBooster = 400,
    StrongSpeedBooster = 900,
}
local function Func_AutoBlackMarket()
    while Toggles.AutoBlackMarket.Value do
        local svc = GetService("BlackmarketService")
        if not svc then
            notyuri("[AutoBlackMarket] BlackmarketService not found")
            task.wait(3)
            continue
        end
        local filterValue = Options.BlackMarketList and Options.BlackMarketList.Value or {}
        local anySelected = false
        local filterActive = false
        local selectedIds = {}
        for label, active in pairs(filterValue) do
            if active then
                if label == "Any" then
                    anySelected = true
                else
                    selectedIds[label] = true
                    filterActive = true
                end
            end
        end
        local BlackmarketItems = {
            "NormalTimeMachine", "MediumTimeMachine", "LargeTimeMachine", "InstantTimeMachine",
            "NormalSpeedBooster", "MediumSpeedBooster", "StrongSpeedBooster"
        }
        for _, itemId in ipairs(BlackmarketItems) do
            if not Toggles.AutoBlackMarket.Value then break end
            local passes = anySelected or not filterActive or selectedIds[itemId]
            if not passes then continue end
            local gems = GetPlayerGems()
            local price = BlackmarketItemsGemPrices[itemId] or 0
            if price > 0 and gems < price then
                notyuri("[AutoBlackMarket] Can't afford", itemId, "- need", price, "gems, have", gems)
                continue
            end
            notyuri("[AutoBlackMarket] Buying:", itemId)
            pcall(function() svc:BuyItem(itemId) end)
            task.wait(0.2)
        end
        task.wait(1)
    end
end
local QuestsMetadataModule = nil
local function GetQuestsMetadata()
    if QuestsMetadataModule then return QuestsMetadataModule end
    local Src = RS:FindFirstChild("Source") or RS:WaitForChild("Source", 10)
    local Metadatas = Src and (Src:FindFirstChild("Metadatas") or Src:WaitForChild("Metadatas", 10))
    if not Metadatas then return nil end
    local ok, m = pcall(require, Metadatas:WaitForChild("QuestsMetadata", 10))
    if ok and m then QuestsMetadataModule = m end
    return QuestsMetadataModule
end
local function Func_AutoClaimQuest()
    while Toggles.AutoClaimQuest.Value do
        local svc = GetService("QuestService")
        if not svc then
            notyuri("[AutoClaimQuest] QuestService not found")
            task.wait(3)
            continue
        end
        local meta = GetQuestsMetadata()
        if not meta then
            notyuri("[AutoClaimQuest] QuestsMetadata not found")
            task.wait(3)
            continue
        end
        local repFolder = Plr:FindFirstChild("_replicationFolder")
        local questsFolder = repFolder and repFolder:FindFirstChild("Quests")
        if not questsFolder then
            notyuri("[AutoClaimQuest] Quests replication folder not found")
            task.wait(3)
            continue
        end
        for _, questDef in ipairs(meta.Quests) do
            if not Toggles.AutoClaimQuest.Value then break end
            local categoryFolder = questsFolder:FindFirstChild(questDef.Category)
            local questObj = categoryFolder and categoryFolder:FindFirstChild(questDef.Id)
            if not questObj then continue end
            local claimed = questObj:GetAttribute("Claimed")
            if claimed == true then continue end
            local progress = questObj:GetAttribute("Progress") or 0
            local goal
            if questDef.Dynamic then
                goal = questObj:GetAttribute("Goal") or math.ceil((meta.OreGoalMinimumRate or 3) * (questDef.GoalSeconds or 0))
            else
                goal = questDef.Goal or 0
            end
            if goal <= 0 or progress < goal then
                notyuri("[AutoClaimQuest] Not complete:", questDef.Id, progress, "/", goal)
                continue
            end
            notyuri("[AutoClaimQuest] Claiming:", questDef.Id, "(", progress, "/", goal, ")")
            pcall(function() svc:ClaimQuest(questDef.Id) end)
            task.wait(0.2)
        end
        task.wait(5)
    end
end
local function Func_AutoClaimOffline()
    while Toggles.AutoClaimOffline.Value do
        local svc = GetService("OfflineRewardService")
        if svc then
            pcall(function() svc:ClaimReward() end)
        end
        task.wait(60)
    end
end
local function Func_AutoClaimDaily()
    while Toggles.AutoClaimDaily.Value do
        local svc = GetService("DailyRewardService")
        if svc then
            pcall(function() svc:Claim() end)
        end
        task.wait(60)
    end
end
local function Func_AutoClaimGroup()
    while Toggles.AutoClaimGroup.Value do
        local svc = GetService("GroupRewardService")
        if svc then
            pcall(function() svc:ClaimGroupReward() end)
        end
        task.wait(60)
    end
end
local function Func_AutoRollWheel()
    while Toggles.AutoRollWheel.Value do
        local svc = GetService("WheelService")
        if svc then
            pcall(function() svc:Spin() end)
        end
        task.wait(5)
    end
end
local function Func_AutoGoldenMachine()
    while Toggles.AutoGoldenMachine.Value do
        local svc = GetService("GoldenMachineService")
        if svc then
            pcall(function() svc:FeedAndSpin() end)
        end
        task.wait(5)
    end
end
local function ReturnToBase()
    local svc = GetService("PlotService")
    if svc then
        pcall(function() svc:ReturnToBase() end)
        Library:Notify("Returning to base.", 3)
    end
end
local function Func_AutoSkipBuild()
    while Toggles.AutoSkipBuild.Value do
        local svc = GetService("PlacementService")
        if svc then
            local plots = workspace:FindFirstChild("Plots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    if not Toggles.AutoSkipBuild.Value then break end
                    for _, drill in ipairs(plot:GetDescendants()) do
                        if drill:IsA("Model") and drill:GetAttribute("BuildCompleteServerTime") then
                            pcall(function() svc:RequestSkipBuild(drill) end)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
        task.wait(5)
    end
end
local function ParsePriceString(s)
    if not s or type(s) ~= "string" then return nil end
    local num, suffix = s:match("%$?([%d%.]+)%s*([KMBTQaQiSxSpOcNoDc]?)")
    if not num then return nil end
    local n = tonumber(num)
    if not n then return nil end
    local mult = 1
    if suffix then
        local suffMap = { K=1e3, M=1e6, B=1e9, T=1e12, Qa=1e15, Qi=1e18, Sx=1e21, Sp=1e24, Oc=1e27, No=1e30, Dc=1e33 }
        mult = suffMap[suffix] or 1
    end
    return n * mult
end
local function Func_AutoUnlockTile()
    while Toggles.AutoUnlockTile.Value do
        local plot = GetOwnPlot()
        if not plot then
            task.wait(5)
            continue
        end
        local Grid = plot:FindFirstChild("Grid")
        local GridTiles = Grid and Grid:FindFirstChild("GridTiles")
        if not GridTiles then
            task.wait(5)
            continue
        end
        local cash = GetPlayerCash()
        for _, tile in ipairs(GridTiles:GetChildren()) do
            if not Toggles.AutoUnlockTile.Value then break end
            if tile:GetAttribute("Locked") == true then
                local unlockPP = nil
                local attach = tile:FindFirstChild("UnlockPromptAttach", true)
                if attach then
                    unlockPP = attach:FindFirstChild("UnlockPrompt")
                end
                if not unlockPP or not unlockPP:IsA("ProximityPrompt") then
                    local lockVisual = tile:FindFirstChild("LockVisual")
                    if lockVisual then
                        local lvAttach = lockVisual:FindFirstChild("UnlockPromptAttach", true)
                        if lvAttach then
                            unlockPP = lvAttach:FindFirstChild("UnlockPrompt")
                        end
                    end
                end
                if unlockPP and unlockPP:IsA("ProximityPrompt") then
                    local price = ParsePriceString(unlockPP.ObjectText)
                    if price and cash >= price then
                        notyuri("[AutoUnlockTile] Unlocking tile:", tile.Name, "price:", unlockPP.ObjectText, "cash:", cash)
                        FirePP(unlockPP, true)
                        cash = cash - price
                        task.wait(0.5)
                    else
                        notyuri("[AutoUnlockTile] Can't afford tile:", tile.Name, "price:", unlockPP.ObjectText, "cash:", cash)
                    end
                end
            end
        end
        task.wait(1)
    end
end
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
local function FireTI(target)
    if not firetouchinterest then
        return
    end
    local root = Char and Char:FindFirstChild("HumanoidRootPart")
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
    part.CFrame = root.CFrame
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
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("RollList", {
    Text = "Roll List",
    Values = (function() local v = {"Any"} for _, n in ipairs(GetDrillDisplayList()) do table.insert(v, n) end return v end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyTotem", { Text = "Auto Buy Totem", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("BuyTotemList", {
    Text = "Buy Totem List",
    Values = (function() local v = {"Any"} for _, n in ipairs(GetTotemDisplayList()) do table.insert(v, n) end return v end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPlaceTotem", { Text = "Auto Place Totem", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("PlaceTotemList", {
    Text = "Place Totem List",
    Values = (function() local v = {"Any"} for _, n in ipairs(GetTotemDisplayList()) do table.insert(v, n) end return v end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBlackMarket", { Text = "Auto Black Market", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("BlackMarketList", {
    Text = "Black Market List",
    Values = {
        "Any",
        "NormalTimeMachine", "MediumTimeMachine", "LargeTimeMachine", "InstantTimeMachine",
        "NormalSpeedBooster", "MediumSpeedBooster", "StrongSpeedBooster",
    },
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoClaimQuest", { Text = "Auto Claim Quest", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlaceDrill", { Text = "Auto Place", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("PlaceList", {
    Text = "Place List",
    Values = (function() local v = {"Any"} for _, n in ipairs(GetDrillDisplayList()) do table.insert(v, n) end return v end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeList", {
    Text = "Upgrade List",
    Values = { "Spin Luck", "Spin Spots", "Miner Luck", "Ores Per Hit" },
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("RemoveList", {
    Text = "Remove List",
    Values = (function() local v = {"Any"} for _, n in ipairs(GetDrillDisplayList()) do table.insert(v, n) end return v end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell Ores", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("MinOresInput", {
    Text = "Min Ores to Collect",
    Default = "0",
    Callback = function(Value)
        local n = tonumber(Value)
        if n then MinOresThreshold = n end
    end,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRemove", { Text = "Auto Remove", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDelete", { Text = "Auto Delete", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUnlockTile", { Text = "Auto Unlock Grid", Default = false })
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
Toggles.AutoRoll:OnChanged(function(v)
    Thread("AutoRoll", SafeLoop("AutoRoll", function()
        while true do
            local ownPlot = GetOwnPlot()
            if not ownPlot then
                notyuri("[AutoRoll] No own plot found")
                task.wait(1)
                continue
            end
            local filterValue = Options.RollList and Options.RollList.Value or {}
            local anySelected = false
            local filterActive = false
            local selectedIds = {}
            for label, active in pairs(filterValue) do
                if active then
                    if label == "Any" then
                        anySelected = true
                    else
                        local id = GetDrillIdFromLabel(label)
                        if id then
                            selectedIds[id] = true
                            filterActive = true
                        end
                    end
                end
            end
            notyuri("[AutoRoll] anySelected=", anySelected, "filterActive=", filterActive)
            local spinSvc = GetService("SpinDrillService")
            if not spinSvc then
                notyuri("[AutoRoll] SpinDrillService not found")
                task.wait(1)
                continue
            end
            local found, bought = IsBought(SpinCallback)
            if found and bought then
                notyuri("[AutoRoll] bought upvalue is true, waiting for next spin")
                task.wait(1)
                continue
            end
            local ok, signal = pcall(function() return spinSvc.OnSpinStartedSignal end)
            if not (ok and signal) then
                notyuri("[AutoRoll] OnSpinStartedSignal not available")
                task.wait(1)
                continue
            end
            pcall(function() spinSvc:RequestSpin() end)
            local baseModel, spots, spinIdsByIndex
            local fired = false
            local conn = signal:Connect(function(bm, sp, sibi)
                if bm ~= ownPlot then return end
                baseModel = bm
                spots = sp
                spinIdsByIndex = sibi
                fired = true
            end)
            local t = 0
            while not fired and t < 5 do
                task.wait(0.1)
                t = t + 0.1
            end
            pcall(function() conn:Disconnect() end)
            if not fired then
                notyuri("[AutoRoll] OnSpinStarted did not fire")
                task.wait(1)
                continue
            end
            notyuri("[AutoRoll] OnSpinStarted fired, processing spots")
            for spotIndex, spotDrillId in ipairs(spots) do
                local spinId = spinIdsByIndex and spinIdsByIndex[spotIndex]
                notyuri("[AutoRoll] Spot", spotIndex, "| spinId=", tostring(spinId), "spotDrillId=", tostring(spotDrillId))
                if not spinId then continue end
                local shouldBuy = anySelected or not filterActive
                local matchReason = shouldBuy and (anySelected and "anySelected" or "no filter active") or nil
                if not shouldBuy and spotDrillId then
                    shouldBuy = selectedIds[spotDrillId] == true
                    if shouldBuy then matchReason = "drillId match" end
                end
                notyuri("[AutoRoll] Spot", spotIndex, "-> shouldBuy=", tostring(shouldBuy), "reason=", tostring(matchReason))
                if shouldBuy then
                    notyuri("[AutoRoll] Spot", spotIndex, "-> attempting BuyResult for spinId=", tostring(spinId))
                    while Toggles.AutoRoll.Value do
                        local bok, success, msg = spinSvc:BuyResult(spinId):await()
                        notyuri("[AutoRoll] Spot", spotIndex, "-> BuyResult ok=", tostring(bok), "success=", tostring(success), "msg=", tostring(msg))
                        if bok and success then
                            break
                        elseif msg == "You don't have enough cash for this." then
                            notyuri("[AutoRoll] Spot", spotIndex, "-> not enough cash")
                            task.wait(1)
                        end
                    end
                    task.wait(0.1)
                end
            end
            task.wait()
        end
    end), v)
end)
Toggles.AutoBuyTotem:OnChanged(function(v)
    Thread("AutoBuyTotem", SafeLoop("AutoBuyTotem", Func_AutoBuyTotem), v)
end)
Toggles.AutoPlaceTotem:OnChanged(function(v)
    Thread("AutoPlaceTotem", SafeLoop("AutoPlaceTotem", Func_AutoPlaceTotem), v)
end)
Toggles.AutoBlackMarket:OnChanged(function(v)
    Thread("AutoBlackMarket", SafeLoop("AutoBlackMarket", Func_AutoBlackMarket), v)
end)
Toggles.AutoClaimQuest:OnChanged(function(v)
    Thread("AutoClaimQuest", SafeLoop("AutoClaimQuest", Func_AutoClaimQuest), v)
end)
Toggles.AutoPlaceDrill:OnChanged(function(v)
    Thread("AutoPlaceDrill", SafeLoop("AutoPlaceDrill", Func_AutoPlaceDrill), v)
end)
Toggles.AutoUpgrade:OnChanged(function(v)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
end)
Toggles.AutoSell:OnChanged(function(v)
    Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSell), v)
end)
Toggles.AutoRemove:OnChanged(function(v)
    Thread("AutoRemove", SafeLoop("AutoRemove", Func_AutoRemove), v)
end)
Toggles.AutoDelete:OnChanged(function(v)
    Thread("AutoDelete", SafeLoop("AutoDelete", Func_AutoDelete), v)
end)
Toggles.AutoUnlockTile:OnChanged(function(v)
    Thread("AutoUnlockTile", SafeLoop("AutoUnlockTile", Func_AutoUnlockTile), v)
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
SaveManager:SetFolder("Yuri/MakeADrillFarm")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
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