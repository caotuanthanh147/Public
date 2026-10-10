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
local l,f={},string.format("1log.txt");if isfile and isfile(f)then delfile(f)end;if writefile then writefile(f,"")end;function notyuri(...)local t=table.create(select("#",...))for i=1,select("#",...)do t[i]=tostring(select(i,...))end local s=("[%s] %s"):format(os.date("%H:%M:%S"),table.concat(t," "));l[#l+1]=s;if appendfile then appendfile(f,s.."\n")end end
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
local Flags = {}
local Shared = {
}
local Tables = {
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
    UpdateHeld = nil,
    Completion = nil,
    AbilityCooldown = nil,
    InstantPP = nil,
}
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
local function SafeConnect(key, getSignalFn, handler)
    local ok, signal = pcall(getSignalFn)
    if not ok or not signal then
        return
    end
    Connections[key] = signal:Connect(handler)
end
local function GetObject(parent, pathString)
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
        notyuri("Your executor does not support firesignal or getconnections.")
    end
end
local RemotesFolder = RS:WaitForChild("Remotes")
local Remotes = {
    PickupItem            = GetObject(RemotesFolder, "PickupItem"),
    DropItem              = GetObject(RemotesFolder, "DropItem"),
    PlaceItem             = GetObject(RemotesFolder, "PlaceItem"),
    DragItem              = GetObject(RemotesFolder, "DragItem"),
    DragRelease           = GetObject(RemotesFolder, "DragRelease"),
    UpdateHeld            = GetObject(RemotesFolder, "UpdateHeld"),
    CompletionUpdate      = GetObject(RemotesFolder, "CompletionUpdate"),
    RequestCompletion     = GetObject(RemotesFolder, "RequestCompletion"),
    RequestGhost          = GetObject(RemotesFolder, "RequestGhost"),
    ProgressionUpdate     = GetObject(RemotesFolder, "ProgressionUpdate"),
    BuyUpgrade            = GetObject(RemotesFolder, "BuyUpgrade"),
    RequestUpgradeState   = GetObject(RemotesFolder, "RequestUpgradeState"),
    UseAbility            = GetObject(RemotesFolder, "UseAbility"),
    BuyPoints             = GetObject(RemotesFolder, "BuyPoints"),
    AbilityCooldown       = GetObject(RemotesFolder, "AbilityCooldown"),
    GameReset             = GetObject(RemotesFolder, "GameReset"),
    RequestPrices         = GetObject(RemotesFolder, "RequestPrices"),
    CleanupComplete       = GetObject(RemotesFolder, "CleanupComplete"),
    ShelfComplete         = GetObject(RemotesFolder, "ShelfComplete"),
    Notify                = GetObject(RemotesFolder, "Notify"),
    PlaceRejected         = GetObject(RemotesFolder, "PlaceRejected"),
    LocalCorrectPlacement = GetObject(RemotesFolder, "LocalCorrectPlacement"),
}
local SharedFolder = RS:WaitForChild("Shared")
local GameData = {
    GameConfig        = GetSafeModule(SharedFolder, "GameConfig"),
    ShelfIndex        = GetSafeModule(SharedFolder, "ShelfIndex"),
    ItemUtil          = GetSafeModule(SharedFolder, "ItemUtil"),
    ProgressionConfig = GetSafeModule(SharedFolder, "ProgressionConfig"),
    UpgradeConfig     = GetSafeModule(SharedFolder, "UpgradeConfig"),
    ProductMap        = GetSafeModule(SharedFolder, "ProductMap"),
}
local HeldItems = {}
local AbilityCooldowns = {}
local LastCompletion = nil
local function Cleanup(tbl)
    for key, value in pairs(tbl) do
        if typeof(value) == "RBXScriptConnection" then
            value:Disconnect()
        elseif typeof(value) == 'thread' then
            task.cancel(value)
        elseif type(value) == "table" then
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
local function GetHRP()
    local c = GetCharacter()
    return c and c:FindFirstChild("HumanoidRootPart") or nil
end
local function TeleportTo(cframe)
    local hrp = GetHRP()
    if hrp and cframe then
        pcall(function() hrp.CFrame = cframe end)
    end
    task.wait()
end
local function GetPickupRange()
    return Plr:GetAttribute("PickupRange") or (GameData.GameConfig and GameData.GameConfig.PickupRange) or 18
end
local function NeedsTeleport(targetCFrame)
    local hrp = GetHRP()
    if not hrp or not targetCFrame then return true end
    return (hrp.Position - targetCFrame.Position).Magnitude > GetPickupRange()
end
local function GetCartCapacity()
    return Plr:GetAttribute("CartCapacity") or (GameData.GameConfig and GameData.GameConfig.MaxHeld) or 4
end
local function GetStoreMap()
    local sm = workspace:FindFirstChild("StoreMaps")
    return sm and sm:FindFirstChild("MediumStore") or nil
end
local function GetFloorItemsFolder()
    return workspace:FindFirstChild("FloorItems")
end
local function GetShelfZonesFolder()
    return workspace:FindFirstChild("ShelfZones")
end
local function GetItemName(item)
    if not item then return nil end
    return item:GetAttribute("ItemName") or item.Name
end
local function GetItemDisplayName(item)
    if not item then return "?" end
    return item:GetAttribute("DisplayName") or GetItemName(item) or "?"
end
local function IsFloorItem(item)
    if not item then return false end
    return CollectionService:HasTag(item, "FloorItem")
end
local function FindFloorItems(maxDist)
    local fi = GetFloorItemsFolder()
    if not fi then return {} end
    local hrp = GetHRP()
    local list = {}
    for _, child in ipairs(fi:GetChildren()) do
        if IsFloorItem(child) then
            local part = child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart")
            if part then
                if not maxDist or not hrp then
                    table.insert(list, { item = child, part = part, pos = part.Position })
                else
                    local dist = (part.Position - hrp.Position).Magnitude
                    if dist <= maxDist then
                        table.insert(list, { item = child, part = part, pos = part.Position, dist = dist })
                    end
                end
            end
        end
    end
    if hrp then
        table.sort(list, function(a, b) return (a.dist or 0) < (b.dist or 0) end)
    end
    return list
end
local ShelfZoneCache = nil
local function BuildShelfZoneCache()
    local szFolder = GetShelfZonesFolder()
    if not szFolder then return nil end
    local cache = {}
    for _, part in ipairs(szFolder:GetChildren()) do
        local a = part:GetAttribute("AisleNumber")
        local s = part:GetAttribute("Section")
        local sh = part:GetAttribute("ShelfNumber")
        if a and s and sh then
            cache[a] = cache[a] or {}
            cache[a][s] = cache[a][s] or {}
            cache[a][s][sh] = part
        end
    end
    return cache
end
local function GetShelfZonePart(aisle, section, shelf)
    if not ShelfZoneCache then
        ShelfZoneCache = BuildShelfZoneCache()
    end
    if not ShelfZoneCache then return nil end
    local a = ShelfZoneCache[aisle]
    local s = a and a[section]
    return s and s[shelf] or nil
end
local function IsShelfFull(itemName, loc)
    local si = GameData.ShelfIndex
    local storeMap = GetStoreMap()
    if not si or not storeMap then return false end
    local slots = si.slotsAt(storeMap, loc.aisle, loc.section, loc.shelf)
    if not slots or #slots == 0 then return false end
    for _, slot in ipairs(slots) do
        local occupied = false
        for _, child in ipairs(slot:GetChildren()) do
            if child:GetAttribute("StockKey") then
                occupied = true
                break
            end
        end
        if not occupied then return false end
    end
    return true
end
local function FindShelfZoneForItem(itemName)
    local pm = GameData.ProductMap
    if not pm or not pm.locations then return nil end
    local locs = pm.locations[itemName]
    if not locs then return nil end
    for _, loc in ipairs(locs) do
        if not IsShelfFull(itemName, loc) then
            local szPart = GetShelfZonePart(loc.aisle, loc.section, loc.shelf)
            if szPart then
                return szPart
            end
        end
    end
    return nil
end
local function GetItemLocations(itemName)
    local pm = GameData.ProductMap
    if not pm or not pm.locations then return {} end
    return pm.locations[itemName] or {}
end
local function GetUpgradeList()
    local list = {}
    local uc = GameData.UpgradeConfig
    if uc and uc.Upgrades then
        for _, upg in ipairs(uc.Upgrades) do
            table.insert(list, upg.id)
        end
    end
    return list
end
local function GetAbilityList()
    local list = {}
    local uc = GameData.UpgradeConfig
    if uc and uc.Upgrades then
        for _, upg in ipairs(uc.Upgrades) do
            if upg.ability then
                table.insert(list, upg.id)
            end
        end
    end
    return list
end
local function IsAbilityOwned(abilityId)
    return Plr:GetAttribute("Has_" .. abilityId) == true
end
local function IsAbilityReady(abilityId)
    local cd = AbilityCooldowns[abilityId]
    if not cd then return true end
    return os.clock() >= cd
end
local function GetCompletion()
    local map = GetStoreMap()
    if not map then return 0, 0, 0 end
    local placed = map:GetAttribute("PlacedCorrect") or 0
    local total = map:GetAttribute("TotalFloorItems") or 0
    local pct = total > 0 and math.floor((placed / total) * 100) or 0
    return placed, total, pct
end
local function GetItemAisle(itemName)
    local pm = GameData.ProductMap
    if not pm or not pm.locations then return nil end
    local locs = pm.locations[itemName]
    if not locs or not locs[1] then return nil end
    return locs[1].aisle
end
local function Func_AutoStock()
    while Toggles.AutoStock.Value do
        local ok, err = pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            local capacity = GetCartCapacity()
            if #HeldItems > 0 then
                local held = HeldItems[#HeldItems]
                if held and held.name then
                    local zone = FindShelfZoneForItem(held.name)
                    if zone then
                        local targetCFrame = zone.CFrame
                        if NeedsTeleport(targetCFrame) then
                            TeleportTo(targetCFrame)
                            task.wait(0.1)
                        end
                        pcall(function() Remotes.PlaceItem:FireServer(zone, zone.Position) end)
                        notyuri("[AutoStock] placed", held.name)
                        task.wait()
                    else
                        notyuri("[AutoStock] no shelf zone for", held.name)
                        pcall(function() Remotes.DropItem:FireServer() end)
                        task.wait(0.2)
                    end
                end
                return
            end
            local items = FindFloorItems(9999)
            if #items == 0 then return end
            local targetAisle = nil
            for _, entry in ipairs(items) do
                local itemName = GetItemName(entry.item)
                if FindShelfZoneForItem(itemName) then
                    targetAisle = GetItemAisle(itemName)
                    break
                end
            end
            if not targetAisle then return end
            notyuri("[AutoStock] filling backpack with aisle", targetAisle, "items")
            for _, entry in ipairs(items) do
                if not Toggles.AutoStock.Value then break end
                if #HeldItems >= capacity then break end
                local itemName = GetItemName(entry.item)
                if GetItemAisle(itemName) == targetAisle and FindShelfZoneForItem(itemName) then
                    TeleportTo(entry.part.CFrame)
                    pcall(function() Remotes.PickupItem:FireServer(entry.item) end)
                    notyuri("[AutoStock] picked up", itemName or "?")
                    task.wait()
                end
            end
        end)
        if not ok then
            notyuri("[AutoStock] error:", tostring(err))
        end
        task.wait(0.1)
    end
end
local function Func_AutoPickup()
    while Toggles.AutoPickup.Value do
        local ok, err = pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            local capacity = GetCartCapacity()
            if #HeldItems >= capacity then
                task.wait(1)
                return
            end
            local items = FindFloorItems(GetPickupRange())
            if #items > 0 then
                local entry = items[1]
                TeleportTo(entry.part.CFrame * CFrame.new(0, 0, 4))
                pcall(function() Remotes.PickupItem:FireServer(entry.item) end)
                notyuri("[AutoPickup] picked up", GetItemName(entry.item) or "?")
            end
        end)
        if not ok then notyuri("[AutoPickup] error:", tostring(err)) end
        task.wait()
    end
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local ok, err = pcall(function()
            if #HeldItems == 0 then
                task.wait(1)
                return
            end
            local held = HeldItems[#HeldItems]
            if held and held.name then
                local zone = FindShelfZoneForItem(held.name)
                if zone then
                    local targetCFrame = zone.CFrame * CFrame.new(0, 0, 4)
                    if NeedsTeleport(targetCFrame) then
                        TeleportTo(targetCFrame)
                        task.wait(0.1)
                    end
                    pcall(function() Remotes.PlaceItem:FireServer(zone, zone.Position) end)
                    notyuri("[AutoPlace] placed", held.name)
                    task.wait()
                else
                    notyuri("[AutoPlace] no shelf zone for", held.name)
                    pcall(function() Remotes.DropItem:FireServer() end)
                    task.wait(0.2)
                end
            end
        end)
        if not ok then notyuri("[AutoPlace] error:", tostring(err)) end
        task.wait(0.2)
    end
end
local function Func_AutoDrop()
    while Toggles.AutoDrop.Value do
        if #HeldItems > 0 then
            pcall(function() Remotes.DropItem:FireServer() end)
            notyuri("[AutoDrop] dropped", #HeldItems, "items")
        end
        task.wait()
    end
end
local function Func_AutoAbilities()
    while Toggles.AutoAbilities.Value do
        local ok, err = pcall(function()
            for ab, active in pairs(Options.AbilitySelect.Value) do
                if not Toggles.AutoAbilities.Value then break end
                if active and IsAbilityOwned(ab) and IsAbilityReady(ab) then
                    pcall(function() Remotes.UseAbility:FireServer(ab) end)
                    notyuri("[AutoAbilities] used", ab)
                    AbilityCooldowns[ab] = os.clock() + 1
                    task.wait(0.5)
                end
            end
        end)
        if not ok then notyuri("[AutoAbilities] error:", tostring(err)) end
        task.wait(0.5)
    end
end
local function Func_AutoBuyUpgrades()
    while Toggles.AutoBuyUpgrades.Value do
        local ok, err = pcall(function()
            if not (Options.AutoBuyUpgradesList and Options.AutoBuyUpgradesList.Value) then return end
            local state = Remotes.RequestUpgradeState:InvokeServer()
            if not (state and state.upgrades) then return end
            for upgId, enabled in pairs(Options.AutoBuyUpgradesList.Value) do
                if not Toggles.AutoBuyUpgrades.Value then break end
                if enabled then
                    local upg = state.upgrades[upgId]
                    if not upg then continue end
                    if upg.level >= upg.maxLevel then continue end
                    if not (state.infinite or state.points >= upg.cost) then continue end
                    pcall(function() Remotes.BuyUpgrade:FireServer(upgId) end)
                    task.wait(0.3)
                end
            end
        end)
        if not ok then notyuri("[AutoBuyUpgrades] error:", tostring(err)) end
        task.wait(.3)
    end
end
local function Func_BringItems()
    local hrp = GetHRP()
    if not hrp then return end
    local fi = GetFloorItemsFolder()
    if not fi then return end
    local count = 0
    local pos = hrp.Position
    for _, child in ipairs(fi:GetChildren()) do
        if IsFloorItem(child) then
            local part = child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart")
            if part then
                pcall(function()
                    if child:IsA("BasePart") then
                        child.CFrame = CFrame.new(pos + Vector3.new(math.random(-3,3), 1, math.random(-3,3)))
                    else
                        child:PivotTo(CFrame.new(pos + Vector3.new(math.random(-3,3), 1, math.random(-3,3))))
                    end
                end)
                count = count + 1
            end
        end
        if count % 50 == 0 then task.wait() end
    end
    Library:Notify("Brought " .. count .. " items to you", 3)
    notyuri("[BringItems] brought", count, "items")
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
SafeConnect("UpdateHeld", function() return Remotes.UpdateHeld.OnClientEvent end, function(heldList)
    HeldItems = heldList or {}
end)
SafeConnect("PlaceRejected", function() return Remotes.PlaceRejected.OnClientEvent end, function()
    notyuri("[PlaceRejected] server rejected PlaceItem")
end)
SafeConnect("AbilityCooldown", function() return Remotes.AbilityCooldown.OnClientEvent end, function(abilityId, duration)
    AbilityCooldowns[abilityId] = os.clock() + (duration or 0)
    notyuri("[AbilityCooldown]", abilityId, "ready in", duration, "s")
end)
task.spawn(function()
    while true do
        pcall(function()
            local placed, total, pct = GetCompletion()
            LastCompletion = { placed = placed, total = total, pct = pct }
        end)
        if Library.Unloaded then break end
        task.wait(2)
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
    Main = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
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
TB_Tabs.Autofarm.T1:AddToggle("AutoStock", {
    Text = "Auto Stock",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoAbilities", {
    Text = "Auto Use Abilities",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyUpgrades", {
    Text = "Auto Buy Upgrades",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("AbilitySelect", {
    Text = "Abilities",
    Values = GetAbilityList(),
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddToggle("AutoAbilities", {
    Text = "Auto Use Abilities",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyUpgradesList", {
    Text = "Upgrades",
    Values = GetUpgradeList(),
    Default = {},
    Multi = true,
})
Toggles.AutoStock:OnChanged(function(v) Thread("AutoStock", Func_AutoStock, v) end)
Toggles.AutoAbilities:OnChanged(function(v) Thread("AutoAbilities", Func_AutoAbilities, v) end)
Toggles.AutoBuyUpgrades:OnChanged(function(v) Thread("AutoBuyUpgrades", Func_AutoBuyUpgrades, v) end)
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
task.spawn(function()
    while task.wait(1) do
        if LastCompletion and CompletionLabel then
            local placed, total, pct = GetCompletion()
            CompletionLabel:SetText("Placed: " .. placed .. " / " .. total .. " (" .. pct .. "%)")
        end
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
SaveManager:SetFolder("Yuri/CleanTheSupermarket")
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
