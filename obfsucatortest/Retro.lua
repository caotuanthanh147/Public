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
local ByteNetworking = GetSafeModule(RS.Teawork.Shared.Services, "ByteNetworking")
local GameStarted = false
local TowerController = GetSafeModule(RS.Teawork.Client.Services.Game, "TowerController")
local TowerSharedService = GetSafeModule(RS.Teawork.Shared.Services, "TowerSharedService")
local PlayerController = GetSafeModule(RS.Teawork.Client.Services, "PlayerController")
local DataSync = GetSafeModule(RS.Teawork.Client.Services, "DataSync")
local ItemDatabaseTowers = GetSafeModule(RS.Teawork.Shared.Services.ItemDatabase, "Towers")
local SharedConfig = GetSafeModule(RS.Teawork.Shared.Modules, "SharedConfig")
local TimescaleUpdater = GetSafeModule(RS.Teawork.Shared.Modules, "TimescaleUpdater")
local Remotes = {
    PlaceTower   = ByteNetworking.Towers.PlaceTower,
    UpgradeTower = ByteNetworking.Towers.UpgradeTower,
    SellTower    = ByteNetworking.Towers.SellTower,
    SetTargetMode = ByteNetworking.Towers.SetTargetMode,
}
local Modules = {
    ByteNetworking = ByteNetworking,
    TowerController = TowerController,
    TowerSharedService = TowerSharedService,
    DataSync = DataSync,
    Towers = ItemDatabaseTowers,
}
local Flags = {}
local Shared = {
}
local Tables = {
    TowersFolder = workspace.InGame.Towers,
}
local MDir = "Yuri/RTD/Macros"
local MState = {
    Rec          = false,
    Rep          = false,
    Cur          = nil,
    Load         = nil,
    Hooked       = false,
    Step         = 0,
    Total        = 0,
    LabelRef     = nil,
    PendingLabel = nil,
    MatchElapsed = 0,
    UIDMap       = {},
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local yuri = {
    "https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
    "https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
    "https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/233/thumbnail.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/328/thumbnail.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1339/thumbnail.jpeg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1268/thumbnail.jpeg",
    "https://dynasty-scans.com/system/releases/000/040/979/001.webp",
    "https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2026/02/01/15/33/44/140636490_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2022/08/15/23/52/23/100515820_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2025/07/22/17/09/45/132989170_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2019/12/01/21/59/30/78092730_p0_master1200.jpg",
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
local function LoadMDir()
    if not writefile then return end
    pcall(function()
        local built = ""
        for _, part in ipairs(MDir:split("/")) do
            built = (built == "") and part or (built .. "/" .. part)
            if not isfolder(built) then
                makefolder(built)
            end
        end
    end)
end
LoadMDir()
local function ListMacros()
    local names = {}
    if not listfiles then return names end
    local ok, files = pcall(listfiles, MDir)
    if not ok or type(files) ~= "table" then return names end
    for _, path in ipairs(files) do
        if type(path) == "string" and path:sub(-5):lower() == ".json" then
            local fname = path:match("([^/\\]+)%.json$")
            if fname and fname ~= "" then table.insert(names, fname) end
        end
    end
    table.sort(names)
    return names
end
local function LoadMacro(name)
    if not name or name == "" or not readfile then return nil end
    local path = MDir .. "/" .. name .. ".json"
    if not isfile(path) then return nil end
    local ok, raw = pcall(readfile, path)
    if not ok or type(raw) ~= "string" or raw == "" then return nil end
    local data
    pcall(function() data = HttpService:JSONDecode(raw) end)
    if type(data) ~= "table" then return nil end
    local entries = {}
    local i = 1
    while data[tostring(i)] do
        entries[i] = data[tostring(i)]
        i = i + 1
    end
    return { entries = entries }
end
local function SaveMacro(name, macro)
    if not name or name == "" or not writefile then return false end
    LoadMDir()
    local path = MDir .. "/" .. name .. ".json"
    local out = {}
    for i, entry in ipairs(macro.entries) do
        out[tostring(i)] = entry
    end
    local ok = pcall(function()
        writefile(path, HttpService:JSONEncode(out))
    end)
    return ok
end
local function GetTowerData(uid)
    local ok, data = pcall(function()
        return TowerController:GetTower(uid)
    end)
    return ok and data or nil
end
local function IsOwnedTower(uid)
    local data = GetTowerData(uid)
    return data ~= nil and data.PlayerId == Plr.UserId
end
local function GetTowerByUID(uid)
    if not IsOwnedTower(uid) then return nil end
    return Tables.TowersFolder:FindFirstChild(tostring(uid))
end
local function ResolveReplayUID(recordedUID)
    local mapped = MState.UIDMap[tostring(recordedUID)]
    if mapped then return mapped end
    return recordedUID
end
local function GetCredits()
    local ok, val = pcall(function()
        return PlayerController:GetLeaderstat("Cash")
    end)
    return (ok and val) or 0
end
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local AP = {
    SlotPositions   = {},  
    FailedPositions = {},  
    SpanCache       = {},  
    SpanCursor      = {},  
    PosLabelRef     = nil,
}
local MCENTERS = {
    ["Azure"]                = Vector3.new(0, 0, 0),
    ["PiratesBay"]           = Vector3.new(0, 0, 0),
    ["CoolCarnival"]         = Vector3.new(0, 0, 0),
    ["CatalogHeaven"]        = Vector3.new(0, 0, 0),
    ["TestMap"]              = Vector3.new(0, 0, 0),
    ["ThePrecinct"]          = Vector3.new(0, 0, 0),
    ["RobloxHQ"]             = Vector3.new(0, 0, 0),
    ["GlassHouses"]          = Vector3.new(0, 0, 0),
    ["WhatEven"]             = Vector3.new(0, 0, 0),
    ["BloxxersPlace"]        = Vector3.new(0, 0, 0),
    ["Baseplate"]            = Vector3.new(0, 0, 0),
    ["SantasStronghold"]     = Vector3.new(0, 0, 0),
    ["SantasWorkshop"]       = Vector3.new(0, 0, 0),
    ["RobloxMuseum"]         = Vector3.new(0, 0, 0),
    ["YoricksRestingPlace"]  = Vector3.new(0, 0, 0),
    ["HauntedMansion"]       = Vector3.new(0, 0, 0),
    ["Graveyard"]            = Vector3.new(0, 0, 0),
    ["ArchPark"]             = Vector3.new(0, 0, 0),
    ["DevastationStation"]   = Vector3.new(0, 0, 0),
    ["RavingRaceway"]        = Vector3.new(0, 0, 0),
    ["ArchParkNight"]        = Vector3.new(0, 0, 0),
    ["Crossroads"]           = Vector3.new(0, 0, 0),
    ["HappyHome"]            = Vector3.new(0, 0, 0),
    ["Sfoth"]                = Vector3.new(0, 0, 0),
    ["Doomspire"]            = Vector3.new(0, 0, 0),
    ["RocketArena"]          = Vector3.new(0, 0, 0),
    ["ChaosCanyon"]          = Vector3.new(0, 0, 0),
}
local function GetCurrentMapName()
    return RS.RoundInfo:GetAttribute("Map")
end
local PCubePool = {
    Free = {},
    Active = {},
}
local function PCubeAcq()
    local part = table.remove(PCubePool.Free)
    if not part then
        part = Instance.new("Part")
        part.Name       = "PCube"
        part.Size       = Vector3.new(0.5, 0.5, 0.5)
        part.Anchored   = true
        part.CanCollide = false
        part.CastShadow = false
        part.Material   = Enum.Material.Neon
    end
    part.Transparency = 0.55
    part.Color        = Color3.fromRGB(80, 160, 255)
    part.Parent        = workspace
    PCubePool.Active[part] = true
    return part
end
local function PCubeRelease(part)
    if not part or not PCubePool.Active[part] then return end
    PCubePool.Active[part] = nil
    part.Parent = nil
    table.insert(PCubePool.Free, part)
end
local function PCubeReleaseAll()
    for part in pairs(PCubePool.Active) do
        PCubePool.Active[part] = nil
        part.Parent = nil
        table.insert(PCubePool.Free, part)
    end
end
local function GetEquippedTowerID(slot)
    local equipped = DataSync:GetKey("EquippedTowers")
    local entry = equipped and equipped[tostring(slot)]
    return entry and entry.ID or nil
end
local function GetTowerPlacedCount(towerId)
    local ok, count = pcall(function()
        return TowerController:GetTowerPlacedCount(towerId)
    end)
    return (ok and count) or 0
end
local function GetTowerPlacementLimit(towerId)
    local ok, limit = pcall(function()
        return TowerController:GetTowerPlacementLimit(towerId)
    end)
    if not ok then return -1 end
    return limit
end
local function GetTowerPlaceLimit(slot, towerId)
    local gameLimit = GetTowerPlacementLimit(towerId)
    local cfg = tonumber(Options["PlaceLimit" .. slot] and Options["PlaceLimit" .. slot].Value) or 0
    if cfg <= 0 then return gameLimit end
    if gameLimit < 0 then return cfg end
    return math.min(cfg, gameLimit)
end
local function GetGround(pos)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local excluded = { Plr.Character, Tables.TowersFolder }
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "PCube" then table.insert(excluded, v) end
    end
    rayParams.FilterDescendantsInstances = excluded
    local result = workspace:Raycast(pos + Vector3.new(0, 5, 0), Vector3.new(0, -50, 0), rayParams)
    local finalY = result and (result.Position.Y) or (pos.Y)
    return finalY
end
local function FailKey(pos)
    return string.format("%.1f_%.1f_%.1f", pos.X, pos.Y, pos.Z)
end
local function DoSpan(cache, center, upToCount, spacing)
    spacing = spacing or 1.5
    if upToCount <= 0 then return cache end
    if #cache == 0 then
        cache[1] = CFrame.new(Vector3.new(center.X, GetGround(center), center.Z))
        cache.x, cache.z = 0, 0
        cache.dx, cache.dz = 1, 0
        cache.segLen  = 1
        cache.stepped = 0
        cache.turns   = 0
    end
    while #cache < upToCount do
        cache.x = cache.x + cache.dx
        cache.z = cache.z + cache.dz
        local px = center.X + cache.x * spacing
        local pz = center.Z + cache.z * spacing
        table.insert(cache, CFrame.new(
            px,
            GetGround(Vector3.new(px, center.Y, pz)),
            pz
        ))
        cache.stepped = cache.stepped + 1
        if cache.stepped == cache.segLen then
            cache.stepped = 0
            cache.dx, cache.dz = -cache.dz, cache.dx
            cache.turns = cache.turns + 1
            if cache.turns % 2 == 0 then
                cache.segLen = cache.segLen + 1
            end
        end
    end
    return cache
end
local function GetPlacementAreaParts(placementType)
    local parts = {}
    local ok, tagged = pcall(function()
        return CollectionService:GetTagged("PlacementArea")
    end)
    if not ok or not tagged then return parts end
    for _, inst in ipairs(tagged) do
        if inst.Name == placementType and inst:IsA("BasePart") then
            table.insert(parts, inst)
        end
    end
    return parts
end
local function IsPointInZone(part, point)
    local localPoint = part.CFrame:PointToObjectSpace(point)
    local halfSize = part.Size / 2
    return math.abs(localPoint.X) <= halfSize.X and math.abs(localPoint.Z) <= halfSize.Z
end
local function DoZoneSpan(cache, part, upToCount, spacing)
    spacing = spacing or 1.5
    if upToCount <= 0 then return cache end
    if not cache.built then
        cache.built = true
        local halfSize = part.Size / 2
        local stepsX = math.floor(halfSize.X / spacing)
        local stepsZ = math.floor(halfSize.Z / spacing)
        for gx = -stepsX, stepsX do
            for gz = -stepsZ, stepsZ do
                local worldPoint = part.CFrame:PointToWorldSpace(Vector3.new(gx * spacing, halfSize.Y, gz * spacing))
                if IsPointInZone(part, worldPoint) then
                    table.insert(cache, CFrame.new(Vector3.new(worldPoint.X, GetGround(worldPoint), worldPoint.Z)))
                end
            end
        end
    end
    return cache
end
local function GetNearestPlacementAreaParts(placementType, fromPos)
    local parts = GetPlacementAreaParts(placementType)
    if #parts == 0 then return {} end
    table.sort(parts, function(a, b)
        return (a.Position - fromPos).Magnitude < (b.Position - fromPos).Magnitude
    end)
    return parts
end
local function CollectZonePositions(placementType, fromPos, cursorPrefix, failed, need)
    local zones = GetNearestPlacementAreaParts(placementType, fromPos)
    local positions = {}
    if #zones == 0 then return positions end
    for _, zonePart in ipairs(zones) do
        if #positions >= need then break end
        local cursorKey = cursorPrefix .. ":" .. zonePart:GetFullName()
        if not AP.SpanCache[cursorKey] then AP.SpanCache[cursorKey] = {} end
        local cache = AP.SpanCache[cursorKey]
        DoZoneSpan(cache, zonePart, math.huge)
        local idx = AP.SpanCursor[cursorKey] or 0
        while idx < #cache and #positions < need do
            idx = idx + 1
            local cf = cache[idx]
            if not failed[FailKey(cf.Position)] then
                table.insert(positions, cf)
            end
        end
        AP.SpanCursor[cursorKey] = idx
    end
    return positions
end
local function UpdatePosLabels()
    if not AP.PosLabelRef then return end
    local lines = {}
    for i = 1, SharedConfig.TowerSlots do
        local count = AP.SlotPositions[i] and #AP.SlotPositions[i] or 0
        table.insert(lines, "Slot " .. i .. ": " .. (count > 0 and (count .. " pos") or "No Position"))
    end
    pcall(function() AP.PosLabelRef:SetText(table.concat(lines, "\n")) end)
end
local function HandleSlotPos(act, slot)
    if act == "reset" then
        if slot then
            AP.SlotPositions[slot] = nil
            Library:Notify("Slot " .. slot .. " positions cleared", 3)
        else
            AP.SlotPositions = {}
            Library:Notify("All slot positions cleared", 3)
        end
        UpdatePosLabels()
        return
    end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Library:Notify("Character not found", 3)
        return
    end
    local pos = hrp.Position
    local groundY = GetGround(pos)
    local cf = CFrame.new(Vector3.new(pos.X, groundY, pos.Z))
    if act == "set" then
        if not AP.SlotPositions[slot] then AP.SlotPositions[slot] = {} end
        table.insert(AP.SlotPositions[slot], cf)
        Library:Notify("Slot " .. slot .. " position " .. #AP.SlotPositions[slot] .. " saved", 3)
        notyuri("[AutoPlay] SetPos slot=" .. slot .. " count=" .. #AP.SlotPositions[slot])
    elseif act == "massset" then
        for i = 1, SharedConfig.TowerSlots do
            if not AP.SlotPositions[i] then AP.SlotPositions[i] = {} end
            table.insert(AP.SlotPositions[i], cf)
        end
        Library:Notify("All slots saved", 3)
        notyuri("[AutoPlay] MassSetPos")
    end
    UpdatePosLabels()
end
local function UpgradeCand()
    local method = Options.UpgradeMethod and Options.UpgradeMethod.Value or "Lowest Level (Spread Upgrade)"
    local towers = TowerController:GetTowers()
    local candidates = {}
    for uid, data in pairs(towers) do
        if data.PlayerId == Plr.UserId then
            local item = data.TowerEntry
            local maxLevel = item and item.Upgrades and #item.Upgrades or 0
            if data.Upgrade < maxLevel then
                local slot = nil
                for s = 1, SharedConfig.TowerSlots do
                    if GetEquippedTowerID(s) == item.ItemID then
                        slot = s
                        break
                    end
                end
                table.insert(candidates, {
                    uid = uid, slot = slot, level = data.Upgrade,
                    maxLevel = maxLevel, itemID = item.ItemID,
                })
            end
        end
    end
    if #candidates == 0 then return nil end
    if method == "Randomize" then
        return candidates[math.random(1, #candidates)]
    elseif method == "Hotbar left to right (until Max)" or method == "Customize upgrade order (Set below)" then
        table.sort(candidates, function(a, b)
            local sa, sb = a.slot or 99, b.slot or 99
            if sa ~= sb then return sa < sb end
            return a.level < b.level
        end)
        return candidates[1]
    end
    table.sort(candidates, function(a, b) return a.level < b.level end)
    return candidates[1]
end
local function DoUpgrade()
    local target = UpgradeCand()
    if not target then return false end
    local ok, result = pcall(function()
        return Remotes.UpgradeTower.invoke(target.uid)
    end)
    notyuri("[AutoPlay] UpgradeUnit uid=" .. tostring(target.uid) .. " slot=" .. tostring(target.slot) ..
        " lv=" .. target.level .. " ok=" .. tostring(ok and result and result.Success))
    task.wait(0.1)
    return ok and result and result.Success == true
end
local function PlacePhase()
    local slotOrder = {}
    for i = 1, SharedConfig.TowerSlots do table.insert(slotOrder, i) end
    table.sort(slotOrder, function(a, b)
        local oa = tonumber(Options["PlaceOrder" .. a] and Options["PlaceOrder" .. a].Value) or a
        local ob = tonumber(Options["PlaceOrder" .. b] and Options["PlaceOrder" .. b].Value) or b
        return oa < ob
    end)
    local allPlaced = true
    local waitingForCash = false
    for _, slot in ipairs(slotOrder) do
        if not Toggles.AutoPlay.Value then break end
        if waitingForCash then break end
        local placeWave = tonumber(Options["PlaceWave" .. slot] and Options["PlaceWave" .. slot].Value) or 0
        local currentWave = RS.RoundInfo:GetAttribute("Wave") or 0
        if placeWave > 0 and currentWave < placeWave then
            allPlaced = false
        else
            local towerId = GetEquippedTowerID(slot)
            if towerId then
                local limit = GetTowerPlaceLimit(slot, towerId)
                local placed = GetTowerPlacedCount(towerId)
                local need = (limit < 0) and 1 or (limit - placed)
                if need > 0 then
                    allPlaced = false
                    if not AP.FailedPositions[slot] then AP.FailedPositions[slot] = {} end
                    local failed = AP.FailedPositions[slot]
                    local positions = {}
                    local item = ItemDatabaseTowers:GetItem(towerId)
                    local placementType = item and item.PlacementType
                    if placementType and placementType ~= "Lower" then
                        if limit >= 0 then
                            local char = GetCharacter()
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            local fromPos = hrp and hrp.Position or Vector3.new(0, 0, 0)
                            local zonePositions = CollectZonePositions(placementType, fromPos, "zone:slot" .. slot, failed, need)
                            for _, cf in ipairs(zonePositions) do
                                table.insert(positions, cf)
                            end
                        end
                    else
                        local slotCfg = AP.SlotPositions[slot]
                        if slotCfg and #slotCfg > 0 then
                            for i = 1, #slotCfg do
                                if not failed[FailKey(slotCfg[i].Position)] then
                                    table.insert(positions, slotCfg[i])
                                end
                            end
                            if #positions == 0 and limit >= 0 then
                                local centerPos = slotCfg[1].Position
                                local cursorKey = "slot" .. slot
                                if not AP.SpanCache[cursorKey] then AP.SpanCache[cursorKey] = {} end
                                local cache = AP.SpanCache[cursorKey]
                                local idx = AP.SpanCursor[cursorKey] or 0
                                local collected = 0
                                while collected < need do
                                    idx = idx + 1
                                    DoSpan(cache, centerPos, idx)
                                    local cf = cache[idx]
                                    if not failed[FailKey(cf.Position)] then
                                        table.insert(positions, cf)
                                        collected = collected + 1
                                    end
                                end
                                AP.SpanCursor[cursorKey] = idx
                            end
                        elseif limit >= 0 then
                            local mapName = GetCurrentMapName()
                            local centerRaw = mapName and MCENTERS[mapName]
                            local centerPos = centerRaw and centerRaw ~= Vector3.new(0, 0, 0) and centerRaw or nil
                            if centerPos then
                                local cursorKey = "center:" .. tostring(mapName)
                                if not AP.SpanCache[cursorKey] then AP.SpanCache[cursorKey] = {} end
                                local cache = AP.SpanCache[cursorKey]
                                local idx = AP.SpanCursor[cursorKey] or 0
                                local collected = 0
                                while collected < need do
                                    idx = idx + 1
                                    DoSpan(cache, centerPos, idx)
                                    local cf = cache[idx]
                                    if not failed[FailKey(cf.Position)] then
                                        table.insert(positions, cf)
                                        collected = collected + 1
                                    end
                                end
                                AP.SpanCursor[cursorKey] = idx
                            end
                        end
                    end
                    local placedThisCall = 0
                    while true do
                        if not Toggles.AutoPlay.Value then break end
                        placedThisCall = placedThisCall + 1
                        if placedThisCall > #positions then break end
                        local cf = positions[placedThisCall]
                        local price = item and item.Upgrades and item.Upgrades[1] and item.Upgrades[1].Price
                        if price and price > 0 and GetCredits() < price then
                            waitingForCash = true
                            break
                        end
                        local ghost = PCubeAcq()
                        ghost.CFrame = cf * CFrame.new(0, 0.5, 0)
                        local ok, result = pcall(function()
                            return Remotes.PlaceTower.invoke({
                                Position = cf.Position,
                                UpVector = cf.UpVector,
                                Rotation = 0,
                                TowerID = towerId,
                            })
                        end)
                        local placedOk = ok and result and result.Success
                        if placedOk then
                            ghost.Color        = Color3.fromRGB(80, 255, 120)
                            ghost.Transparency = 0.6
                        else
                            ghost.Color        = Color3.fromRGB(255, 80, 80)
                            ghost.Transparency = 0.6
                        end
                        notyuri("[AutoPlay] PLACE slot=" .. slot .. " tower=" .. tostring(towerId) ..
                            " ok=" .. tostring(placedOk) .. (placedOk and "" or (" reason=" .. tostring(result and result.FailReason))))
                        failed[FailKey(cf.Position)] = true
                        if not placedOk then
                            break
                        else
                            if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value then
                                DoUpgrade()
                            end
                            if GetTowerPlacedCount(towerId) >= limit and limit >= 0 then
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return allPlaced
end
local function ResetAutoPlayMatchState()
    table.clear(AP.FailedPositions)
    table.clear(AP.SpanCache)
    table.clear(AP.SpanCursor)
    notyuri("[AutoPlay] match state reset (wave decreased)")
end
local function Func_AutoPlay()
    local lastWave = RS.RoundInfo:GetAttribute("Wave") or 0
    while Toggles.AutoPlay.Value do
        local currentWave = RS.RoundInfo:GetAttribute("Wave") or 0
        if currentWave < lastWave then
            ResetAutoPlayMatchState()
        end
        lastWave = currentWave
        if not workspace.InGame:FindFirstChild("Towers") then
            PCubeReleaseAll()
            task.wait(1)
        else
            local allPlaced = PlacePhase()
            if allPlaced and Toggles.AutoUpgrade and Toggles.AutoUpgrade.Value then
                local didUpgrade = DoUpgrade()
                if not didUpgrade then
                    task.wait(1)
                end
            end
            task.wait(0.2)
        end
    end
    PCubeReleaseAll()
end
local function Func_AutoSellUnit()
    local _lastSoldUnit = false
    while Toggles.AutoSellUnit.Value do
        local wave = RS.RoundInfo:GetAttribute("Wave") or 0
        local targetWave = tonumber(Options.SellUnitWave.Value) or 0
        if targetWave > 0 and wave >= targetWave then
            if not _lastSoldUnit then
                _lastSoldUnit = true
                local towers = TowerController:GetTowers()
                local sold = 0
                for uid, data in pairs(towers) do
                    if data.PlayerId == Plr.UserId then
                        pcall(function() Remotes.SellTower.invoke(uid) end)
                        sold = sold + 1
                    end
                end
                notyuri("[AutoSellUnit] Sold " .. sold .. " units at wave " .. wave)
            end
        else
            _lastSoldUnit = false
        end
        task.wait(2)
    end
end
local function Func_AutoReady()
    while Toggles.AutoReady.Value do
        if RS.RoundInfo:GetAttribute("ReadyVoteActive") == true then
            ByteNetworking.ReadyVote.Vote.send(true)
            
        end
        task.wait(1)
    end
end
local function Func_AutoSkip()
    while Toggles.AutoSkip.Value do
        ByteNetworking.SkipWave.Vote.send(true)
        task.wait(1)
    end
end
local function Func_AutoGameSpeed()
    while Toggles.AutoGameSpeed.Value do
        local desired = tonumber(Options.SpeedValue and Options.SpeedValue.Value) or 1
        local current = RS.RoundInfo:GetAttribute("Timescale") or 1
        if current ~= desired then
            ByteNetworking.Timescale.SetTimescale.send(desired)
        end
        task.wait(1)
    end
end
local function Func_AutoVoteDifficulty()
    while Toggles.AutoVoteDifficulty.Value do
        local gui = Plr.PlayerGui:FindFirstChild("GameUI")
        gui = gui and gui:FindFirstChild("DifficultyVote")
        if gui and gui.Visible then
            local desired = Options.DifficultyValue and Options.DifficultyValue.Value
            if desired then
                ByteNetworking.DifficultyVote.Vote.send(desired)
            end
        end
        task.wait(1)
    end
end
local function SendWebhook(title, description)
    if not request then return end
    local img = yuri[math.random(1, #yuri)]
    pcall(function()
        request({
            Url = Options.WebhookURL.Value,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                username = "Yuri",
                avatar_url = img,
                embeds = {
                    {
                        title = title,
                        description = description,
                        color = 0xFFB6C1,
                        thumbnail = { url = img },
                    },
                },
            }),
        })
    end)
end
local AutoRetryConn = nil
local WHMatchFinishedConn = nil
local function Func_AutoRetry(state)
    if AutoRetryConn then
        AutoRetryConn()
        AutoRetryConn = nil
    end
    if not state then return end
    AutoRetryConn = ByteNetworking.RoundResult.Show.listen(function()
        if not Toggles.AutoRetry.Value then return end
        task.wait(0.5)
        ByteNetworking.RoundResult.VoteForRestart.send(true)
        
    end)
end
local function Func_WHMatchFinished(state)
    if WHMatchFinishedConn then
        WHMatchFinishedConn()
        WHMatchFinishedConn = nil
    end
    if not state then return end
    WHMatchFinishedConn = ByteNetworking.RoundResult.Show.listen(function(payload)
        if not Toggles.WHMatchFinished or not Toggles.WHMatchFinished.Value then return end
        if type(payload) ~= "table" then return end
        local outcome = payload.IsVictory and "Victory" or "Defeat"
        local mins = math.floor(payload.TimeSurvived / 60)
        local secs = payload.TimeSurvived - mins * 60
        local rewardLines = {}
        if type(payload.Rewards) == "table" then
            for currency, amount in payload.Rewards do
                table.insert(rewardLines, string.format("+%s %s", tostring(amount), tostring(currency)))
            end
        end
        local mapName = RS.RoundInfo:GetAttribute("Map") or "Unknown"
        local desc = string.format(
            "**%s - %s**\n- Time: %d:%02d\n- Waves Survived: %s\n- Enemies Killed: %s\n- Player: ||%s||\n- Rewards:\n%s",
            mapName, outcome, mins, secs,
            tostring(payload.WavesSurvived), tostring(payload.EnemiesKilled), Plr.Name,
            #rewardLines > 0 and table.concat(rewardLines, "\n") or "None"
        )
        SendWebhook("Match Finished", desc)
        
    end)
end
local BattleTimeStart = nil
local function GetElapsedBattleTime()
    if not BattleTimeStart or not TimescaleUpdater then return MState.MatchElapsed end
    return TimescaleUpdater:GetTime() - BattleTimeStart
end
local function StopTracking()
    BattleTimeStart = nil
end
local function StartTracking(startElapsed)
    StopTracking()
    MState.MatchElapsed = startElapsed or 0
    if TimescaleUpdater then
        BattleTimeStart = TimescaleUpdater:GetTime() - (startElapsed or 0)
    end
end
ByteNetworking.Gameplay.GameStarted.listen(function()
    GameStarted = true
    StartTracking(0)
    MState.Step = 0
    MState.Rep = false
    notyuri("b")
end)
ByteNetworking.Gameplay.GameEnded.listen(function()
    GameStarted = false
    StopTracking()
    MState.Step = 0
    MState.Rep = false
    notyuri("a")
end)
local function PauseTracking()
    if BattleTimeStart and TimescaleUpdater then
        MState.MatchElapsed = TimescaleUpdater:GetTime() - BattleTimeStart
    end
    BattleTimeStart = nil
end
local function ResumeTracking()
    if TimescaleUpdater then
        BattleTimeStart = TimescaleUpdater:GetTime() - (MState.MatchElapsed or 0)
    end
end
local function UpdateLabel(suffix, elapsed)
    if MState.LabelRef and MState.LabelRef.SetText then
        local txt
        local timeStr = elapsed and string.format(" [%.2fs]", elapsed) or ""
        if MState.Rec then
            if suffix then
                txt = string.format("Recording [%d] %s%s", MState.Step, suffix, timeStr)
            else
                txt = string.format("Recording [%d]", MState.Step)
            end
        elseif MState.Rep then
            txt = string.format("Replaying [%d / %d]", MState.Step, MState.Total)
            if suffix then txt = txt .. " | " .. suffix .. timeStr end
        else
            txt = "Idle"
            if suffix then txt = txt .. " | " .. suffix end
        end
        if MState.Rec then
            MState.PendingLabel = txt
        else
            local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
            if not ok then
                notyuri("[Macro Rec] SetText FAILED:", tostring(err))
                MState.PendingLabel = txt
            end
        end
    end
end
local function LabelPump()
    while MState.Rec do
        if MState.PendingLabel then
            local txt = MState.PendingLabel
            MState.PendingLabel = nil
            local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
            if not ok then
                notyuri("[Macro Rec] LabelPump SetText FAILED:", tostring(err))
            end
        end
        task.wait()
    end
end
local function RecordAct(kind, data, capturedElapsed)
    if not MState.Rec or not MState.Cur then return end
    local elapsed = capturedElapsed
    if not elapsed then return end
    if GameStarted == false then
        elapsed = 0.0
    end
    MState.Step = MState.Step + 1
    local entry = { Type = kind, Elapsed = elapsed }
    for k, val in pairs(data or {}) do
        entry[k] = val
    end
    table.insert(MState.Cur.entries, entry)
    UpdateLabel(kind, elapsed)
    notyuri("[Macro Rec] recorded", kind, string.format("%.2f", elapsed))
end
local function InstallMacroHook()
    if MState.Hooked then return end
    local originalPlaceInvoke = Remotes.PlaceTower.invoke
    Remotes.PlaceTower.invoke = function(args)
        local capturedElapsed = GetElapsedBattleTime()
        local ret = originalPlaceInvoke(args)
        if MState.Rec and type(args) == "table" then
            if ret and ret.Success then
                task.defer(function()
                    local targetPos = args.Position
                    local bestUid, bestDist = nil, nil
                    local ok, towers = pcall(function() return TowerController:GetTowers() end)
                    if ok and towers then
                        for uid, data in pairs(towers) do
                            if data.PlayerId == Plr.UserId then
                                local model = Tables.TowersFolder:FindFirstChild(tostring(uid))
                                if model then
                                    local pos = model:GetPivot().Position
                                    local dist = (pos - targetPos).Magnitude
                                    if not bestDist or dist < bestDist then
                                        bestDist, bestUid = dist, uid
                                    end
                                end
                            end
                        end
                    end
                    if bestUid and bestDist and bestDist < 2 then
                        RecordAct("Place", {
                            TowerID   = args.TowerID,
                            Position  = { targetPos.X, targetPos.Y, targetPos.Z },
                            UpVector  = { args.UpVector.X, args.UpVector.Y, args.UpVector.Z },
                            Rotation  = args.Rotation,
                            RecordUID = tostring(bestUid),
                        }, capturedElapsed)
                    else
                        notyuri("[Macro Rec] Place GUARD FAIL: could not resolve UID for new tower", tostring(args.TowerID))
                    end
                end)
            else
                notyuri("[Macro Rec] Place GUARD FAIL: server rejected placement", tostring(ret and ret.FailReason))
            end
        end
        return ret
    end
    local originalUpgradeInvoke = Remotes.UpgradeTower.invoke
    Remotes.UpgradeTower.invoke = function(uid)
        local capturedElapsed = GetElapsedBattleTime()
        local ret = originalUpgradeInvoke(uid)
        if MState.Rec and type(uid) ~= "nil" then
            if ret and ret.Success and ret.Level then
                local model = GetTowerByUID(uid)
                if model then
                    RecordAct("Upgrade", {
                        UID = tostring(uid),
                    }, capturedElapsed)
                    notyuri("[Macro Rec] Upgrade recorded", tostring(uid))
                else
                    notyuri("[Macro Rec] Upgrade GUARD FAIL: tower", tostring(uid), "not found/owned, skipping record")
                end
            else
                notyuri("[Macro Rec] Upgrade GUARD FAIL: server rejected upgrade for tower", tostring(uid))
            end
        end
        return ret
    end
    local originalSellInvoke = Remotes.SellTower.invoke
    Remotes.SellTower.invoke = function(uid)
        local capturedElapsed = GetElapsedBattleTime()
        local existedBefore = GetTowerByUID(uid) ~= nil
        local ret = originalSellInvoke(uid)
        if MState.Rec and existedBefore then
            task.defer(function()
                if not MState.Rec then return end
                local stillThere = Tables.TowersFolder:FindFirstChild(tostring(uid)) ~= nil
                if stillThere then
                    notyuri("[Macro Rec] Sell GUARD FAIL: model still alive at", tostring(uid))
                    return
                end
                RecordAct("Sell", {
                    UID = tostring(uid),
                }, capturedElapsed)
                notyuri("[Macro Rec] Sell recorded", tostring(uid))
            end)
        end
        return ret
    end
    local originalTargetModeSend = Remotes.SetTargetMode.send
    Remotes.SetTargetMode.send = function(args)
        local capturedElapsed = GetElapsedBattleTime()
        if MState.Rec and type(args) == "table" and args.UID then
            local model = GetTowerByUID(args.UID)
            if model then
                RecordAct("TargetMode", {
                    UID        = tostring(args.UID),
                    TargetMode = args.TargetMode,
                }, capturedElapsed)
                notyuri("[Macro Rec] TargetMode recorded", tostring(args.UID), tostring(args.TargetMode))
            else
                notyuri("[Macro Rec] TargetMode GUARD FAIL: tower", tostring(args.UID), "not found/owned, skipping record")
            end
        end
        return originalTargetModeSend(args)
    end
    MState.Hooked = true
    notyuri("[Macro] invoke/send wrappers installed")
end
local function WaitForCreditsMacro(amount)
    if not amount or amount <= 0 then return true end
    if GetCredits() >= amount then return true end
    local start = tick()
    while Toggles.LoadMacro.Value and GetCredits() < amount and (tick() - start) < 60 do
        task.wait(0.25)
    end
    return Toggles.LoadMacro.Value and GetCredits() >= amount
end
local function GetMacroEntryCost(entry)
    if entry.Type == "Place" then
        local ok, stats = pcall(function()
            return TowerSharedService:GetTowerStats(entry.TowerID, 1, nil, nil)
        end)
        return ok and stats and stats.Price or nil
    elseif entry.Type == "Upgrade" then
        local uid = ResolveReplayUID(entry.UID)
        local model = GetTowerByUID(uid)
        if not model then return nil end
        local tower = GetTowerData(uid)
        if not tower then return nil end
        local ok, stats = pcall(function()
            return TowerSharedService:GetTowerStats(tower.TowerEntry.ItemID, tower.Upgrade + 1, tower.Boosts, tower.TraitID)
        end)
        return ok and stats and stats.Price or nil
    end
    return nil
end
local function DoMacroAction(entry)
    if entry.Type == "Place" then
        local pos = entry.Position
        local up = entry.UpVector
        local targetPos = Vector3.new(pos[1], pos[2], pos[3])

        local ret = Remotes.PlaceTower.invoke({
            Position = targetPos,
            UpVector = Vector3.new(up[1], up[2], up[3]),
            Rotation = entry.Rotation,
            TowerID  = entry.TowerID,
        })

        if ret and ret.Success then
            local bestUid, bestDist = nil, nil
            local start = tick()
            while (tick() - start) < 5 do
                local ok, towers = pcall(function() return TowerController:GetTowers() end)
                if ok and towers then
                    for uid, data in pairs(towers) do
                        if data.PlayerId == Plr.UserId then
                            local model = Tables.TowersFolder:FindFirstChild(tostring(uid))
                            if model then
                                local dist = (model:GetPivot().Position - targetPos).Magnitude
                                if not bestDist or dist < bestDist then
                                    bestDist, bestUid = dist, uid
                                end
                            end
                        end
                    end
                end
                if bestUid and bestDist and bestDist < 2 then break end
                bestUid, bestDist = nil, nil
                task.wait()
            end
            if bestUid and bestDist and bestDist < 2 then
                if entry.RecordUID then
                    MState.UIDMap[tostring(entry.RecordUID)] = bestUid
                    notyuri("[Macro Rep] Place UID mapped", tostring(entry.RecordUID), "->", tostring(bestUid))
                else
                    notyuri("[Macro Rep] Place UID mapping SKIPPED: entry has no RecordUID (old macro format)")
                end
            else
                notyuri("[Macro Rep] Place UID mapping FAIL: could not resolve new tower for recorded UID", tostring(entry.RecordUID))
            end
        else
            notyuri("[Macro Rep] Place SKIP: server rejected placement", tostring(ret and ret.FailReason))
        end
    elseif entry.Type == "Upgrade" then
        local uid = ResolveReplayUID(entry.UID)
        local model = GetTowerByUID(uid)
        if model then
            Remotes.UpgradeTower.invoke(uid)
        else
            notyuri("[Macro Rep] Upgrade SKIP: tower", tostring(entry.UID), "(resolved", tostring(uid) .. ")", "not found/owned")
        end
    elseif entry.Type == "Sell" then
        local uid = ResolveReplayUID(entry.UID)
        local model = GetTowerByUID(uid)
        if model then
            Remotes.SellTower.invoke(uid)
        else
            notyuri("[Macro Rep] Sell SKIP: tower", tostring(entry.UID), "(resolved", tostring(uid) .. ")", "not found/owned")
        end
    elseif entry.Type == "TargetMode" then
        local uid = ResolveReplayUID(entry.UID)
        local model = GetTowerByUID(uid)
        if model then
            Remotes.SetTargetMode.send({ UID = uid, TargetMode = entry.TargetMode })
        else
            notyuri("[Macro Rep] TargetMode SKIP: tower", tostring(entry.UID), "(resolved", tostring(uid) .. ")", "not found/owned")
        end
    end
end
local function IsPaused()
    return RS.RoundInfo:GetAttribute("Paused") == true
end
local function Func_MacroRecord(state)
    if not state then return end
    if Toggles.LoadMacro and Toggles.LoadMacro.Value then
        Toggles.LoadMacro:SetValue(false)
    end
    InstallMacroHook()
    MState.Cur = { entries = {} }
    MState.Step = 0
    UpdateLabel("Waiting")
    notyuri("[Macro Rec] waiting for match to start")
    while Toggles.MacroRecord.Value and not workspace.InGame:FindFirstChild("Towers") do
        task.wait()
    end
    if not Toggles.MacroRecord.Value then
        MState.Cur = nil
        MState.Step = 0
        UpdateLabel()
        return
    end
    StartTracking(0)
    MState.Rec = true
    UpdateLabel()
    task.spawn(LabelPump)
    notyuri("[Macro Rec] recording started")
    while Toggles.MacroRecord.Value do
        if IsPaused() then
            UpdateLabel("Paused")
            PauseTracking()
            while Toggles.MacroRecord.Value and IsPaused() do
                task.wait()
            end
            if not Toggles.MacroRecord.Value then break end
            ResumeTracking()
            UpdateLabel()
        end
        task.wait()
    end
    MState.Rec = false
    StopTracking()
    notyuri("[Macro Rec] recording stopped,", #MState.Cur.entries, "actions")
    local fname = (Options.FileName and Options.FileName.Value) or ""
    if fname == "" then fname = "Macro_" .. os.date("%Y%m%d_%H%M%S") end
    if SaveMacro(fname, MState.Cur) then
        Library:Notify("Macro saved: " .. fname, 4)
        if Options.MacroSelected then
            Options.MacroSelected:SetValues(ListMacros())
        end
    else
        Library:Notify("Failed to save macro (writefile unsupported?)", 4)
    end
    MState.Cur = nil
    MState.Step = 0
    UpdateLabel()
end
local function WaitForGameStarted()
    while Toggles.LoadMacro.Value and not GameStarted do
        task.wait(0.2)
    end
    return GameStarted
end
local function Func_MacroReplay()
    while Toggles.LoadMacro.Value do
        local macro = MState.Load
        if not macro or not macro.entries or #macro.entries == 0 then
            Toggles.LoadMacro:SetValue(false)
            Library:Notify("No macro loaded", 3)
            return
        end
        MState.Rep = true
        MState.Total = #macro.entries
        MState.Step = 0
        MState.UIDMap = {}
        UpdateLabel()
        if not GameStarted then
            UpdateLabel("Waiting")
            WaitForGameStarted()
        end
        if not Toggles.LoadMacro.Value then break end
        StartTracking(0)
        local waveResetMidPass = false
        local gameStartedAtPassStart = GameStarted
        for i, entry in ipairs(macro.entries) do
            if not Toggles.LoadMacro.Value then break end
            if GameStarted ~= gameStartedAtPassStart then
                notyuri("[Macro Rep] GameStarted changed mid-pass — aborting pass")
                waveResetMidPass = true
                break
            end
            if IsPaused() then
                UpdateLabel("Paused")
                PauseTracking()
                while Toggles.LoadMacro.Value and IsPaused() do
                    task.wait()
                end
                if not Toggles.LoadMacro.Value then break end
                ResumeTracking()
                UpdateLabel(entry.Type, entry.Elapsed)
            end
            MState.Step = i
            UpdateLabel(entry.Type, entry.Elapsed)
            local replayMode = Options.ReplayMode and Options.ReplayMode.Value or "Time"
            if replayMode == "Money" then
                if entry.Type == "Place" or entry.Type == "Upgrade" then
                    local cost = GetMacroEntryCost(entry)
                    if cost and cost > 0 then
                        if not WaitForCreditsMacro(cost) then
                            notyuri("[Macro Rep] money wait aborted (toggle off)")
                        end
                    end
                end
            else
                while Toggles.LoadMacro.Value do
                    if GameStarted ~= gameStartedAtPassStart then
                        notyuri("[Macro Rep] GameStarted changed mid-wait — aborting pass")
                        waveResetMidPass = true
                        break
                    end
                    if IsPaused() then
                        UpdateLabel("Paused")
                        PauseTracking()
                        while Toggles.LoadMacro.Value and IsPaused() do
                            task.wait()
                        end
                        if Toggles.LoadMacro.Value then
                            ResumeTracking()
                            UpdateLabel(entry.Type, entry.Elapsed)
                        end
                    end
                    local elapsed = GetElapsedBattleTime()
                    if elapsed and elapsed >= entry.Elapsed then break end
                    task.wait()
                end
                if waveResetMidPass then break end
            end
            if Toggles.LoadMacro.Value then
                local ok, err = pcall(DoMacroAction, entry)
                if not ok then
                    notyuri("[Macro Rep] action failed:", tostring(err))
                end
            end
        end
        StopTracking()
        MState.Rep = false
        MState.Step = 0
        UpdateLabel("Finished")
        if not waveResetMidPass then
            notyuri("[Macro Rep] replay pass complete")
        end
        if Toggles.LoadMacro.Value and not waveResetMidPass then
            UpdateLabel("Waiting")
            while Toggles.LoadMacro.Value and GameStarted do
                task.wait(0.2)
            end
        end
    end
    MState.Rep = false
    MState.Step = 0
    UpdateLabel()
    Toggles.LoadMacro:SetValue(false)
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
    AutoPlay = Window:AddTab("Auto Play"),
    Joiner = Window:AddTab("Joiner"),
    Webhook = Window:AddTab("Webhook"),
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
        T1 = TB.Main.Left.Autofarm:AddTab("Macro"),
        T2 = TB.Main.Left.Autofarm:AddTab("Game"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("GameConfig"),
    },
}
local AP_Left  = Tabs.AutoPlay:AddLeftGroupbox("AutoPlay")
local AP_Right = Tabs.AutoPlay:AddRightGroupbox("Limits")
AP_Left:AddToggle("AutoPlay", {
    Text    = "Auto Play",
    Default = false,
})
AP_Left:AddDivider()
AP_Left:AddDropdown("UpgradeMethod", {
    Text    = "Upgrade Method",
    Values  = {
        "Lowest Level (Spread Upgrade)",
        "Hotbar left to right (until Max)",
        "Randomize",
        "Customize upgrade order (Set below)",
    },
    Default = "Lowest Level (Spread Upgrade)",
})
AP_Left:AddDivider()
AP_Left:AddToggle("AutoUpgrade", {
    Text    = "Auto Upgrade",
    Default = false,
})
AP_Left:AddToggle("PlaceAndUpgrade", {
    Text    = "Place and Upgrade",
    Default = false,
})
AP_Left:AddDivider()
AP_Left:AddToggle("AutoSellUnit", {
    Text    = "Auto Sell Unit",
    Default = false,
})
AP_Left:AddSlider("SellUnitWave", {
    Text     = "Sell Unit Wave",
    Default  = 0,
    Min      = 0,
    Max      = 50,
    Rounding = 0,
    Compact  = true,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoReady", {
    Text    = "Auto Ready",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoSkip", {
    Text    = "Auto Skip",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoRetry", {
    Text    = "Auto Retry",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("DifficultyValue", {
    Text    = "Vote Difficulty",
    Values  = { "Casual", "Normal", "Hard", "Insane" },
    Default = "Casual",
})
TB_Tabs.Autofarm.T2:AddToggle("AutoVoteDifficulty", {
    Text    = "Auto Vote Difficulty",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("SpeedValue", {
    Text    = "Game Speed",
    Values  = { "1", "2", "3" },
    Default = "1",
})
TB_Tabs.Autofarm.T2:AddToggle("AutoGameSpeed", {
    Text    = "Auto Game Speed",
    Default = false,
})

UpdatePosLabels()
AP_Right:AddLabel("Place Order per Slot", true)
for i = 1, SharedConfig.TowerSlots do
    AP_Right:AddSlider("PlaceOrder" .. i, {
        Text     = "Slot " .. i,
        Default  = i,
        Min      = 1,
        Max      = SharedConfig.TowerSlots,
        Rounding = 0,
        Compact  = true,
    })
end
AP_Right:AddDivider()
AP_Right:AddLabel("Place Wave per Slot", true)
for i = 1, SharedConfig.TowerSlots do
    AP_Right:AddSlider("PlaceWave" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 50,
        Rounding = 0,
        Compact  = true,
    })
end
AP_Right:AddDivider()
AP_Right:AddLabel("Place Limit per Slot", true)
for i = 1, SharedConfig.TowerSlots do
    AP_Right:AddSlider("PlaceLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 10,
        Rounding = 0,
        Compact  = true,
    })
end
AP.PosLabelRef = AP_Right:AddLabel("Slot 1: No Position", true)
AP_Left:AddLabel("Stand where you want towers placed, select a slot, then Set Slot Position.", true)
AP_Left:AddDropdown("SetSlotSelect", {
    Text    = "Slot",
    Values  = (function()
        local v = {}
        for i = 1, SharedConfig.TowerSlots do table.insert(v, "Slot " .. i) end
        return v
    end)(),
    Default = "Slot 1",
})
AP_Left:AddButton({
    Text = "Set Slot Position",
    Func = function()
        local slot = tonumber((Options.SetSlotSelect.Value or "Slot 1"):match("%d+")) or 1
        HandleSlotPos("set", slot)
    end,
})
AP_Left:AddButton({
    Text = "Mass Set All Slots",
    Func = function() HandleSlotPos("massset") end,
})
AP_Left:AddButton({
    Text = "Reset Slot Position",
    Func = function()
        local slot = tonumber((Options.SetSlotSelect.Value or "Slot 1"):match("%d+")) or 1
        HandleSlotPos("reset", slot)
    end,
})
AP_Left:AddButton({
    Text = "Reset All Positions",
    Func = function() HandleSlotPos("reset") end,
})
Toggles.AutoSellUnit:OnChanged(function(state)
    Thread("AutoSellUnit", SafeLoop("Auto Sell Unit", Func_AutoSellUnit), state)
end)
Toggles.AutoPlay:OnChanged(function(state)
    Thread("AutoPlay", SafeLoop("Auto Play", Func_AutoPlay), state)
end)
Toggles.AutoReady:OnChanged(function(state)
    Thread("AutoReady", SafeLoop("Auto Ready", Func_AutoReady), state)
end)
Toggles.AutoSkip:OnChanged(function(state)
    Thread("AutoSkip", SafeLoop("Auto Skip Vote", Func_AutoSkip), state)
end)
Toggles.AutoRetry:OnChanged(function(state)
    Func_AutoRetry(state)
end)
local MapDisplayToID = {
    ["Reborn Family Abode"] = "Azure",
    ["Pirate Bay"] = "PiratesBay",
    ["c00l carnival"] = "CoolCarnival",
    ["Classic Battlegrounds"] = "CatalogHeaven",
    ["Test Map"] = "TestMap",
    ["The Precinct"] = "ThePrecinct",
    ["Roblox HQ"] = "RobloxHQ",
    ["Glass Houses"] = "GlassHouses",
    ["What the...?"] = "WhatEven",
    ["Bloxxer's Place #1"] = "BloxxersPlace",
    ["Baseplate"] = "Baseplate",
    ["Santas' Stronghold"] = "SantasStronghold",
    ["Santas' Workshop"] = "SantasWorkshop",
    ["Roblox Museum"] = "RobloxMuseum",
    ["Yorick's Resting Place"] = "YoricksRestingPlace",
    ["Haunted Mansion"] = "HauntedMansion",
    ["Graveyard"] = "Graveyard",
    ["Arch Park"] = "ArchPark",
    ["Devastation Station"] = "DevastationStation",
    ["Raving Raceway"] = "RavingRaceway",
    ["Dark Park"] = "ArchParkNight",
    ["Crossroads"] = "Crossroads",
    ["Happy Home"] = "HappyHome",
    ["SFOTH"] = "Sfoth",
    ["Doomspire"] = "Doomspire",
    ["Rocket Arena"] = "RocketArena",
    ["Chaos Canyon"] = "ChaosCanyon",
}
local ModifierDisplayToID = {
    ["No Heroes"] = "NoHeroics",
    ["Doombringer Hell"] = "DoombringerHell",
    ["Tag Team"] = "DoubleHero",
    ["Unsupportive"] = "NoSupport",
    ["Shortsighted"] = "DecreasedRange",
    ["Telescopic"] = "IncreasedRange",
    ["Hyper"] = "FastEnemies",
    ["Extremely Hyper"] = "FasterEnemies",
    ["Double Trouble"] = "DoubleEnemies",
    ["Triple Trouble"] = "TripleEnemies",
    ["Bullet Proof"] = "DoubleEnemyHealth",
    ["Cash Strapped"] = "LessIncome",
    ["Inflation"] = "MoreIncome",
    ["Fortified"] = "MoreBaseHP",
    ["Decaying"] = "HalfBaseHP",
    ["Glass House"] = "OneBaseHP",
    ["Disasterful"] = "Disasterful",
}
local function DoAutoJoin()
    if not (ByteNetworking and ByteNetworking.MatchmakingNew) then
        Library:Notify("Matchmaking remotes not found", 3)
        return
    end
    local mapLabel = Options.JoinerMap and Options.JoinerMap.Value or "Baseplate"
    local mapID = MapDisplayToID[mapLabel] or mapLabel
    local gameType = Options.JoinerGameType and Options.JoinerGameType.Value or "Standard"
    local selectedMods = (Options.JoinerModifiers and Options.JoinerModifiers.Value) or {}
    local modifiers = {}
    if gameType == "Standard" then
        for label, active in pairs(selectedMods) do
            if active and label ~= "All" then
                local id = ModifierDisplayToID[label]
                if id then table.insert(modifiers, id) end
            end
        end
    end
    local payload = {
        MapID = mapID,
        GameType = gameType,
        Modifiers = modifiers,
    }
    local ok, result = pcall(function()
        return ByteNetworking.MatchmakingNew.CreateSingleplayer.invoke(payload)
    end)
    if ok then
        notyuri("[Joiner] CreateSingleplayer fired for map " .. tostring(mapID) .. " (" .. tostring(gameType) .. ")")
    end
end
local LJ = Tabs.Joiner:AddLeftGroupbox("Lobby")
LJ:AddDropdown("JoinerMap", {
    Text = "Map",
    Values = (function()
        local names = {}
        for name in pairs(MapDisplayToID) do table.insert(names, name) end
        table.sort(names)
        return names
    end)(),
    Default = "Baseplate",
    Searchable = true,
})
LJ:AddDropdown("JoinerGameType", {
    Text = "Game Type",
    Values = { "Standard", "Endless", "Sandbox" },
    Default = "Standard",
})
LJ:AddDropdown("JoinerModifiers", {
    Text = "Modifiers",
    Values = { "All", "No Heroes", "Doombringer Hell", "Tag Team", "Unsupportive", "Shortsighted", "Telescopic", "Hyper", "Extremely Hyper", "Double Trouble", "Triple Trouble", "Bullet Proof", "Cash Strapped", "Inflation", "Fortified", "Decaying", "Glass House", "Disasterful" },
    Default = {},
    Multi = true,
    Searchable = true,
})
LJ:AddToggle("AutoJoin", {
    Text = "Auto Join",
    Default = false,
})
Toggles.AutoJoin:OnChanged(function(v)
    if not v then return end
    DoAutoJoin()
end)
local WH1 = Tabs.Webhook:AddLeftGroupbox("Webhook")
WH1:AddInput("WebhookURL", { Text = "Webhook URL", Default = "" })
WH1:AddToggle("WHMatchFinished", { Text = "Match Finished", Default = false })
Toggles.WHMatchFinished:OnChanged(function(state)
    Func_WHMatchFinished(state)
end)
Toggles.AutoGameSpeed:OnChanged(function(state)
    Thread("AutoGameSpeed", SafeLoop("Auto Game Speed", Func_AutoGameSpeed), state)
end)
Toggles.AutoVoteDifficulty:OnChanged(function(state)
    Thread("AutoVoteDifficulty", SafeLoop("Auto Vote Difficulty", Func_AutoVoteDifficulty), state)
end)
TB_Tabs.Autofarm.T1:AddDropdown("MacroSelected", {
    Text    = "Select File",
    Values  = ListMacros(),
    Default = ListMacros()[1] or "",
})
Options.MacroSelected:OnChanged(function(v)
    if v and v ~= "" then
        MState.Load = LoadMacro(v)
        if not MState.Load then
            Library:Notify("Failed to load macro: " .. v, 4)
        end
    end
end)
if Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
    MState.Load = LoadMacro(Options.MacroSelected.Value)
end
TB_Tabs.Autofarm.T1:AddInput("FileName", {
    Text        = "File Name",
    Default     = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T1:AddToggle("MacroRecord", {
    Text    = "Record Macro",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddDropdown("ReplayMode", {
    Text    = "Replay Mode",
    Values  = { "Time", "Money" },
    Default = "Time",
})
TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", {
    Text    = "Play Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
Toggles.MacroRecord:OnChanged(function(state)
    Func_MacroRecord(state)
end)
Toggles.LoadMacro:OnChanged(function(state)
    if state then
        if not MState.Load and Options.MacroSelected and Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
            MState.Load = LoadMacro(Options.MacroSelected.Value)
        end
    end
    Thread("LoadMacro", SafeLoop("Macro Replay", Func_MacroReplay), state)
end)
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
    Func_AutoRetry(false)
    Func_WHMatchFinished(false)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/RTD")
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