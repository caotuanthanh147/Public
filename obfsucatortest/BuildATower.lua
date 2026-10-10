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
local Items = RS:WaitForChild("Items")
local function Remote(name)
    local r = RS:FindFirstChild(name) or RS:WaitForChild(name, 10)
    return r
end
local Remotes = {
    PlaceItemRemote          = Remote("PlaceItemRemote"),
    ConfigureItemRemote      = Remote("ConfigureItemRemote"),
    BuyItemEvent             = Remote("BuyItemEvent"),
    CraftItemEvent           = Remote("CraftItemEvent"),
    PurchaseUpgradeEvent     = Remote("PurchaseUpgradeEvent"),
    TeleportToPlotRemote     = Remote("TeleportToPlotRemote"),
    GetPlotBoundsAndCFrame   = Remote("GetPlotBoundsAndCFrameRemote"),
    GetItemSellPrice         = Remote("GetItemSellPrice"),
    GetPlacedItemCount       = Remote("GetPlacedItemCount"),
    GetLevelFunction         = Remote("GetLevelFunction"),
    QuestGetQuestData        = RS:FindFirstChild("QuestRemotes") and RS.QuestRemotes:FindFirstChild("GetQuestData"),
    QuestClaimQuest          = RS:FindFirstChild("QuestRemotes") and RS.QuestRemotes:FindFirstChild("ClaimQuest"),
    QuestClaimBonus          = RS:FindFirstChild("QuestRemotes") and RS.QuestRemotes:FindFirstChild("ClaimBonusReward"),
    VerifyGroupReward        = Remote("VerifyGroupReward"),
}
local function GetCash()
    local ls = Plr:FindFirstChild("leaderstats")
    local v = ls and ls:FindFirstChild("Cash")
    return v and v.Value or 0
end
local function GetLevel()
    local lvl = Plr:GetAttribute("Level")
    if lvl then return lvl end
    if Remotes.GetLevelFunction then
        local ok, res = pcall(function() return Remotes.GetLevelFunction:InvokeServer() end)
        if ok and tonumber(res) then return tonumber(res) end
    end
    return 1
end
local function GetPlotNumber()
    return Plr:GetAttribute("PlotNumber")
end
local function GetPlot()
    local pn = GetPlotNumber()
    if not pn then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    return plots:FindFirstChild("Plot" .. tostring(pn))
end
local function GetPlotCFrame()
    local plot = GetPlot()
    if not plot then return nil end
    if plot:IsA("BasePart") then return plot.CFrame end
    if plot:IsA("Model") then return plot:GetPivot() end
    return nil
end
local _cachedBounds = nil
local function GetPlotBounds()
    if _cachedBounds then return _cachedBounds end
    if not Remotes.GetPlotBoundsAndCFrame then return nil end
    local ok, result = pcall(function() return Remotes.GetPlotBoundsAndCFrame:InvokeServer() end)
    if ok and result and result.Bounds then
        _cachedBounds = result.Bounds
        return result.Bounds
    end
    return nil
end
local function GetInventory()
    local inv = Plr:FindFirstChild("Inventory")
    if not inv then return {} end
    local out = {}
    for _, v in ipairs(inv:GetChildren()) do
        if v:IsA("IntValue") then out[v.Name] = v.Value end
    end
    return out
end
local function GetItemCount(itemName)
    local inv = Plr:FindFirstChild("Inventory")
    if not inv then return 0 end
    local v = inv:FindFirstChild(itemName)
    return v and v.Value or 0
end
local function GetPlacedItems()
    local plot = GetPlot()
    if not plot then return {} end
    local items = {}
    for _, child in ipairs(plot:GetChildren()) do
        if child:IsA("Model") then
            local itemType = child:GetAttribute("ItemType")
            local itemId = child:GetAttribute("ItemId")
            if itemType and itemId then
                local pp = child:FindFirstChild("Primary") or child:FindFirstChildWhichIsA("BasePart")
                table.insert(items, { model = child, itemType = itemType, itemId = itemId, primaryPart = pp })
            end
        end
    end
    return items
end
local _sizeCache = {}
local function GetItemSize(itemName)
    if _sizeCache[itemName] ~= nil then return _sizeCache[itemName] end
    local tmpl = Items:FindFirstChild(itemName)
    if not tmpl then _sizeCache[itemName] = false return nil end
    local size = nil
    if tmpl:IsA("Model") then
        local ext = tmpl:GetExtentsSize()
        if ext and ext.Magnitude > 0 then
            size = ext
        else
            local pp = tmpl:FindFirstChild("Primary") or tmpl:FindFirstChildWhichIsA("BasePart")
            if pp then size = pp.Size end
        end
    elseif tmpl:IsA("BasePart") then
        size = tmpl.Size
    end
    _sizeCache[itemName] = size or false
    return size or nil
end
local GRID = 0.25
local function SnapGrid(n)
    return math.floor(n / GRID + 0.5) * GRID
end
local function ClampToPlotBounds(cf, itemSize, bounds)
    if not itemSize or not bounds then return cf end
    local halfX, halfY, halfZ = itemSize.X / 2, itemSize.Y / 2, itemSize.Z / 2
    local pos = cf.Position
    local clampedX = math.clamp(pos.X, bounds.minX + halfX, bounds.maxX - halfX)
    local clampedY = math.clamp(pos.Y, bounds.minY + halfY, bounds.maxY - halfY)
    local clampedZ = math.clamp(pos.Z, bounds.minZ + halfZ, bounds.maxZ - halfZ)
    local rx, ry, rz = cf:ToEulerAnglesYXZ()
    return CFrame.new(clampedX, clampedY, clampedZ) * CFrame.Angles(rx, ry, rz)
end
local function IsValidPlacement(cf, itemSize, bounds)
    if not itemSize or not bounds then return false end
    local halfX, halfY, halfZ = itemSize.X / 2, itemSize.Y / 2, itemSize.Z / 2
    for sx = -1, 1, 2 do
        for sy = -1, 1, 2 do
            for sz = -1, 1, 2 do
                local corner = (cf * CFrame.new(sx * halfX, sy * halfY, sz * halfZ)).Position
                if corner.X < bounds.minX or corner.X > bounds.maxX
                or corner.Y < bounds.minY or corner.Y > bounds.maxY
                or corner.Z < bounds.minZ or corner.Z > bounds.maxZ then
                    return false
                end
            end
        end
    end
    return true
end
local function GetItemPlaceLimit()
    local level = GetLevel()
    local hasVIP = Plr:GetAttribute("HasVIP") == true
    local limit = level * 50
    if hasVIP then limit = limit * 2 end
    return limit
end
local function GetCurrentPlacedCount()
    if not Remotes.GetPlacedItemCount then return 0 end
    local ok, result = pcall(function() return Remotes.GetPlacedItemCount:InvokeServer() end)
    return ok and tonumber(result) or 0
end
local function GetItemPlaceLimit()
    local level = GetLevel()
    local hasVIP = Plr:GetAttribute("HasVIP") == true
    local limit = level * 50
    if hasVIP then limit = limit * 2 end
    return limit
end
local function GetCurrentPlacedCount()
    if not Remotes.GetPlacedItemCount then return 0 end
    local ok, result = pcall(function() return Remotes.GetPlacedItemCount:InvokeServer() end)
    return ok and tonumber(result) or 0
end
local function DoPlace(itemName, cf)
    if not Remotes.PlaceItemRemote then return false end
    local ok = pcall(function() Remotes.PlaceItemRemote:FireServer(itemName, cf) end)
    return ok
end
local function DoSellItem(itemId)
    if not Remotes.ConfigureItemRemote then return false end
    return pcall(function() Remotes.ConfigureItemRemote:FireServer("Sell", itemId) end)
end
local function DoBuyItem(itemName)
    if not Remotes.BuyItemEvent then return false end
    return pcall(function() Remotes.BuyItemEvent:FireServer(itemName) end)
end
local function DoCraftItem(recipeName)
    if not Remotes.CraftItemEvent then return false end
    return pcall(function() Remotes.CraftItemEvent:FireServer(recipeName) end)
end
local function DoBuyUpgrade(level)
    if not Remotes.PurchaseUpgradeEvent then return false end
    return pcall(function() Remotes.PurchaseUpgradeEvent:FireServer(level) end)
end
local function GetShopCatalogFromGame()
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then notyuri("[GetShopCatalog] missing getgc/getupvalues") return nil end
    local shopScript
    pcall(function()
        shopScript = PGui:WaitForChild("HUD", 5)
            :WaitForChild("Shop-GUI", 5)
            :WaitForChild("Shop-Client", 5)
    end)
    if not shopScript then notyuri("[GetShopCatalog] Shop-Client not found") return nil end
    local ok, gc = pcall(getgc, false)
    if not ok or not gc then notyuri("[GetShopCatalog] getgc failed") return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" or not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or not env then continue end
        if rawget(env, "script") ~= shopScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or not uvs then continue end
        for _, v in pairs(uvs) do
            if type(v) ~= "table" then continue end
            local sc = rawget(v, "SmallCube")
            if type(sc) == "table" and type(rawget(sc, "Price")) == "number" and type(rawget(sc, "Rarity")) == "string" then
                local n = 0 for _ in pairs(v) do n = n + 1 end
                return v
            end
        end
    end
    notyuri("[GetShopCatalog] not found in gc")
    return nil
end
local function GetCraftCatalogFromGame()
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then notyuri("[GetCraftCatalog] missing getgc/getupvalues") return nil end
    local craftScript
    pcall(function()
        craftScript = PGui:WaitForChild("HUD", 5)
            :WaitForChild("Crafting-GUI", 5)
            :WaitForChild("Crafting-Client", 5)
    end)
    if not craftScript then notyuri("[GetCraftCatalog] Crafting-Client not found") return nil end
    local ok, gc = pcall(getgc, false)
    if not ok or not gc then notyuri("[GetCraftCatalog] getgc failed") return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" or not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or not env then continue end
        if rawget(env, "script") ~= craftScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or not uvs then continue end
        for _, v in pairs(uvs) do
            if type(v) ~= "table" then continue end
            local tt = rawget(v, "TradingTicket")
            if type(tt) == "table" and type(rawget(tt, "Price")) == "number" and type(rawget(tt, "RequiredItems")) == "table" then
                local n = 0 for _ in pairs(v) do n = n + 1 end
                return v
            end
        end
    end
    notyuri("[GetCraftCatalog] not found in gc")
    return nil
end
local function GetUpgradePricesFromGame()
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then notyuri("[GetUpgradePrices] missing getgc/getupvalues") return nil end
    local upgradeScript
    pcall(function()
        upgradeScript = PGui:WaitForChild("HUD", 5)
            :WaitForChild("Upgrades-GUI", 5)
            :WaitForChild("Upg-Client", 5)
    end)
    if not upgradeScript then notyuri("[GetUpgradePrices] Upg-Client not found") return nil end
    local ok, gc = pcall(getgc, false)
    if not ok or not gc then notyuri("[GetUpgradePrices] getgc failed") return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" or not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or not env then continue end
        if rawget(env, "script") ~= upgradeScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or not uvs then continue end
        for _, v in pairs(uvs) do
            if type(v) == "table" and #v >= 20 and v[1] == 0 and v[2] == 10000 then
                return v
            end
        end
    end
    notyuri("[GetUpgradePrices] not found in gc")
    return nil
end
local ShopCat = GetShopCatalogFromGame()
local _craftCatalog = GetCraftCatalogFromGame()
local _upgradePrices = GetUpgradePricesFromGame()
local ShopStock = {}
local function _onShopStockUpdate(stockTable)
    if type(stockTable) ~= "table" then return end
    for itemName, count in pairs(stockTable) do
        ShopStock[itemName] = count
    end
end
RS:WaitForChild("UpdateShopUIEvent").OnClientEvent:Connect(_onShopStockUpdate)
RS:WaitForChild("ShopRestockEvent").OnClientEvent:Connect(_onShopStockUpdate)
local function GetShopPrice(itemName)
    if not ShopCat then return nil end
    local item = ShopCat[itemName]
    return item and item.Price or nil
end
local BUILD_SAVE_FOLDER = "Yuri/BuildATower/Build"
local function CFrameToTable(cf)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function TableToCFrame(t)
    if type(t) ~= "table" or #t < 12 then return CFrame.new() end
    return CFrame.new(t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
end
local function CopyBuildToJSON()
    local plotCF = GetPlotCFrame()
    if not plotCF then return nil end
    local items = GetPlacedItems()
    if #items == 0 then return nil end
    local relative = plotCF:Inverse()
    local data = { version = 1, count = #items, blocks = {} }
    for _, item in ipairs(items) do
        local cf
        if item.primaryPart and item.primaryPart:IsA("BasePart") then
            cf = item.primaryPart.CFrame
        else
            cf = item.model:GetPivot()
        end
        local relCF = relative * cf
        table.insert(data.blocks, { name = item.itemType, cf = CFrameToTable(relCF) })
    end
    return HttpService:JSONEncode(data)
end
local function LoadBuildJSON(json)
    if not json or json == "" then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data) ~= "table" or type(data.blocks) ~= "table" then return nil end
    return data
end
local function ListBuildFiles()
    local files = {}
    if not Support.FileIO or not isfolder then return files end
    pcall(function()
        if not isfolder(BUILD_SAVE_FOLDER) then return end
        for _, name in ipairs(listfiles(BUILD_SAVE_FOLDER)) do
            if name:sub(-5) == ".json" then
                local short = name:match("([^/\\]+)%.json$")
                if short then table.insert(files, short) end
            end
        end
    end)
    table.sort(files)
    return files
end
local function GetBuildRequirements(data)
    local reqs = {}
    for _, entry in ipairs(data.blocks) do
        local n = entry.name
        if n then reqs[n] = (reqs[n] or 0) + 1 end
    end
    return reqs
end
local function ComputeMissingMaterials(reqs)
    local inv = GetInventory()
    local missing = {}
    local parts = {}
    for itemName, need in pairs(reqs) do
        local have = inv[itemName] or 0
        if have < need then
            local short = need - have
            missing[itemName] = short
            table.insert(parts, itemName .. "(x" .. short .. ")")
        end
    end
    table.sort(parts)
    local display
    if #parts == 0 then
        display = "Ready"
    else
        display = "Missing: " .. table.concat(parts, ", ")
    end
    return missing, display
end
local function GetAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return {} end
    local out = {}
    local ourPlot = GetPlot()
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("BasePart") or plot:IsA("Model") then
            local ownerName = "Unknown"
            pcall(function()
                local signage = plot:FindFirstChild("Signage")
                local sg = signage and signage:FindFirstChild("SurfaceGui")
                local frame = sg and sg:FindFirstChild("Frame")
                local pn = frame and frame:FindFirstChild("PlayerName")
                if pn and pn:IsA("TextLabel") and pn.Text ~= "" then
                    ownerName = pn.Text
                end
            end)
            table.insert(out, { plot = plot, ownerName = ownerName, isOurs = (plot == ourPlot) })
        end
    end
    return out
end
local function GetPlacedBlocksFromPlot(plot)
    if not plot then return {} end
    local blocks = {}
    for _, child in ipairs(plot:GetChildren()) do
        if child:IsA("Model") then
            local itemType = child:GetAttribute("ItemType")
            local itemId = child:GetAttribute("ItemId")
            if itemType and itemId then
                local pp = child:FindFirstChild("Primary") or child:FindFirstChildWhichIsA("BasePart")
                local cf
                if pp and pp:IsA("BasePart") then
                    cf = pp.CFrame
                else
                    cf = child:GetPivot()
                end
                table.insert(blocks, { name = itemType, cf = cf })
            end
        end
    end
    return blocks
end
local function SerializeBlocks(blocks, plotCF)
    if not plotCF or #blocks == 0 then return nil end
    local relative = plotCF:Inverse()
    local data = { version = 1, count = #blocks, blocks = {} }
    for _, b in ipairs(blocks) do
        local relCF = relative * b.cf
        table.insert(data.blocks, { name = b.name, cf = CFrameToTable(relCF) })
    end
    return HttpService:JSONEncode(data)
end
local function GetPlotCFrameOf(plot)
    if not plot then return nil end
    if plot:IsA("BasePart") then return plot.CFrame end
    if plot:IsA("Model") then return plot:GetPivot() end
    return nil
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
local function GeneratePlacementSlots(bounds, itemSize, maxCount)
    local slots = {}
    if not bounds or not itemSize then return slots end
    local sizeX = math.max(itemSize.X, 1)
    local sizeZ = math.max(itemSize.Z, 1)
    local halfX = sizeX / 2
    local halfZ = sizeZ / 2
    local startY = bounds.minY + (itemSize.Y / 2) + 0.5  
    local stepX = math.max(sizeX, 2)
    local stepZ = math.max(sizeZ, 2)
    local count = 0
    for y = startY, bounds.maxY - (itemSize.Y / 2), math.max(itemSize.Y, 2) do
        if count >= maxCount then break end
        for x = bounds.minX + halfX + 1, bounds.maxX - halfX - 1, stepX do
            if count >= maxCount then break end
            for z = bounds.minZ + halfZ + 1, bounds.maxZ - halfZ - 1, stepZ do
                if count >= maxCount then break end
                local sx = SnapGrid(x)
                local sy = SnapGrid(y)
                local sz = SnapGrid(z)
                table.insert(slots, CFrame.new(sx, sy, sz))
                count = count + 1
            end
        end
    end
    return slots
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local selected = Options.AutoPlaceItems and Options.AutoPlaceItems.Value or {}
        if next(selected) == nil then task.wait(2) continue end
        local bounds = GetPlotBounds()
        if not bounds then task.wait(2) continue end
        local itemsToPlace = {}
        if selected["Any"] then
            local inv = GetInventory()
            for itemName, count in pairs(inv) do
                if count > 0 then table.insert(itemsToPlace, itemName) end
            end
        else
            for label in pairs(selected) do
                local itemName = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                table.insert(itemsToPlace, itemName)
            end
        end
        local placeLimit = GetItemPlaceLimit()
        local currentPlaced = GetCurrentPlacedCount()
        if currentPlaced >= placeLimit then
            notyuri("[AutoPlace] Place limit reached (" .. currentPlaced .. "/" .. placeLimit .. "), waiting...")
            task.wait(5)
            continue
        end
        for _, itemName in ipairs(itemsToPlace) do
            if not Toggles.AutoPlace.Value then break end
            local count = GetItemCount(itemName)
            if count > 0 then
                local itemSize = GetItemSize(itemName) or Vector3.new(2, 2, 2)
                local slots = GeneratePlacementSlots(bounds, itemSize, count)
                local placed = 0
                local slotsAvailable = math.min(#slots, count, placeLimit - currentPlaced)
                for i = 1, slotsAvailable do
                    if not Toggles.AutoPlace.Value then break end
                    local cf = slots[i]
                    local clampedCF = ClampToPlotBounds(cf, itemSize, bounds)
                    if IsValidPlacement(clampedCF, itemSize, bounds) then
                        DoPlace(itemName, clampedCF)
                        placed = placed + 1
                        currentPlaced = currentPlaced + 1
                        task.wait(0.05)
                    end
                    if currentPlaced >= placeLimit then
                        notyuri("[AutoPlace] Hit place limit (" .. placeLimit .. ") mid-loop, stopping")
                        break
                    end
                end
                notyuri("[AutoPlace] placed", placed, itemName, "of", count)
            end
        end
        task.wait()
    end
end
local function Func_AutoBuyShop()
    while Toggles.AutoBuyShop.Value do
        local selected = Options.AutoBuyShopItems and Options.AutoBuyShopItems.Value or {}
        if next(selected) == nil then task.wait(3) continue end
        local cash = GetCash()
        if selected["Any"] and ShopCat then
            for itemName, data in pairs(ShopCat) do
                if not Toggles.AutoBuyShop.Value then break end
                if (ShopStock[itemName] or 0) <= 0 then continue end
                local price = data.Price
                if price and cash >= price then
                    DoBuyItem(itemName)
                    cash = cash - price
                    ShopStock[itemName] = (ShopStock[itemName] or 1) - 1
                    notyuri("[AutoBuyShop] bought", itemName, "for", price)
                    task.wait(0.3)
                end
            end
        else
            for label in pairs(selected) do
                if not Toggles.AutoBuyShop.Value then break end
                local itemName = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                if (ShopStock[itemName] or 0) <= 0 then continue end
                local price = GetShopPrice(itemName)
                if price and cash >= price then
                    DoBuyItem(itemName)
                    cash = cash - price
                    ShopStock[itemName] = (ShopStock[itemName] or 1) - 1
                    notyuri("[AutoBuyShop] bought", itemName, "for", price)
                    task.wait(0.3)
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoCraft()
    while Toggles.AutoCraft.Value do
        local selected = Options.AutoCraftRecipes and Options.AutoCraftRecipes.Value or {}
        if next(selected) == nil then task.wait(3) continue end
        local inv = GetInventory()
        local cash = GetCash()
        local catalog = _craftCatalog
        local function tryRecipe(recipeName, recipe)
            if not recipe or cash < recipe.Price then return end
            local canCraft = true
            for reqItem, reqCount in pairs(recipe.RequiredItems) do
                if (inv[reqItem] or 0) < reqCount then canCraft = false break end
            end
            if canCraft then
                DoCraftItem(recipeName)
                notyuri("[AutoCraft] crafted", recipeName)
                task.wait(0.5)
            end
        end
        if selected["Any"] and catalog then
            for recipeName, recipe in pairs(catalog) do
                if not Toggles.AutoCraft.Value then break end
                tryRecipe(recipeName, recipe)
            end
        else
            for label in pairs(selected) do
                if not Toggles.AutoCraft.Value then break end
                local recipeName = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                tryRecipe(recipeName, catalog and catalog[recipeName])
            end
        end
        task.wait(3)
    end
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local prices = _upgradePrices
        local level = GetLevel()
        if prices and level < #prices then
            local nextLevel = level + 1
            local price = prices[nextLevel] or 0
            if price > 0 and GetCash() >= price then
                DoBuyUpgrade(nextLevel)
                notyuri("[AutoUpgrade] bought level", nextLevel, "for", price)
                task.wait(1)
            end
        end
        task.wait(5)
    end
end
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        local items = GetPlacedItems()
        for _, item in ipairs(items) do
            if not Toggles.AutoSell.Value then break end
            DoSellItem(item.itemId)
            task.wait(0.1)
        end
        task.wait(3)
    end
end
local function Func_AutoPickUp()
    while Toggles.AutoPickUp.Value do
        local selected = Options.AutoPickUpItems and Options.AutoPickUpItems.Value or {}
        local pickAny = selected["Any"] or next(selected) == nil
        local items = GetPlacedItems()
        for _, item in ipairs(items) do
            if not Toggles.AutoPickUp.Value then break end
            local shouldPick = pickAny
            if not shouldPick then
                for label in pairs(selected) do
                    local itemName = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                    if itemName == item.itemType then
                        shouldPick = true
                        break
                    end
                end
            end
            if shouldPick then
                pcall(function() Remotes.ConfigureItemRemote:FireServer("PickUp", item.itemId) end)
                task.wait(0.1)
            end
        end
        task.wait()
    end
end
local function Func_AutoClaimQuests()
    while Toggles.AutoClaimQuests.Value do
        if Remotes.QuestGetQuestData and Remotes.QuestClaimQuest then
            local ok, data = pcall(function() return Remotes.QuestGetQuestData:InvokeServer() end)
            if ok and data and data.ActiveQuests and data.Progress then
                for questId, quest in pairs(data.ActiveQuests) do
                    if not Toggles.AutoClaimQuests.Value then break end
                    local prog = data.Progress[questId]
                    if prog and not prog.Claimed and (prog.Progress or 0) >= (quest.Target or 0) then
                        pcall(function() Remotes.QuestClaimQuest:FireServer(questId) end)
                        notyuri("[AutoQuests] claimed", questId)
                        task.wait(0.5)
                    end
                end
                if not data.BonusClaimed and Remotes.QuestClaimBonus then
                    local allDone = true
                    for questId in pairs(data.ActiveQuests) do
                        local prog = data.Progress[questId]
                        if not prog or not prog.Claimed then allDone = false break end
                    end
                    if allDone then
                        pcall(function() Remotes.QuestClaimBonus:FireServer() end)
                        notyuri("[AutoQuests] claimed bonus")
                    end
                end
            end
        end
        task.wait(30)
    end
end
local function TeleportToPlot()
    if not Remotes.TeleportToPlotRemote then return end
    pcall(function() Remotes.TeleportToPlotRemote:FireServer() end)
    Library:Notify("Teleported to plot.", 3)
end
local function ClaimGroupReward()
    if not Remotes.VerifyGroupReward then return end
    pcall(function() Remotes.VerifyGroupReward:FireServer() end)
    Library:Notify("Group reward claimed.", 3)
end
local _buildSourcesLookup = {}
local MatLabel = nil
local RefreshBuildSourcesDropdown
local function SaveBuildToFile(saveName)
    if not saveName or saveName == "" then
        Library:Notify("Enter a file name first.", 3)
        return
    end
    if not Support.FileIO then
        Library:Notify("File IO not supported.", 4)
        return
    end
    local json = CopyBuildToJSON()
    if not json then
        Library:Notify("No placed items to save.", 4)
        return
    end
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    pcall(function()
        if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
        writefile(path, json)
    end)
    Library:Notify("Build saved: " .. saveName, 5)
    if RefreshBuildSourcesDropdown then RefreshBuildSourcesDropdown() end
end
local function LoadBuildFromFile(saveName)
    if not saveName or saveName == "" then return nil end
    if not Support.FileIO then return nil end
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    if not isfile(path) then return nil end
    local ok, json = pcall(readfile, path)
    if not ok or not json then return nil end
    return LoadBuildJSON(json)
end
RefreshBuildSourcesDropdown = function()
    if not Options.BuildSourceDropdown then return end
    local plots = GetAllPlots()
    local files = ListBuildFiles()
    local values = {}
    _buildSourcesLookup = {}
    for _, p in ipairs(plots) do
        local prefix = p.isOurs and "[My Plot] " or "[Plot] "
        local display = prefix .. p.ownerName
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "plot", plot = p.plot, ownerName = p.ownerName }
    end
    for _, fname in ipairs(files) do
        local display = "[File] " .. fname
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "file", name = fname }
    end
    Options.BuildSourceDropdown:SetValues(values)
end
local function LoadSelectedBuildSource()
    local sel = Options.BuildSourceDropdown and Options.BuildSourceDropdown.Value
    if not sel or sel == "" then
        Library:Notify("Select a base or file first.", 3)
        return nil
    end
    local entry = _buildSourcesLookup[sel]
    if not entry then
        Library:Notify("Unknown source: " .. sel, 4)
        return nil
    end
    if entry.type == "plot" then
        local blocks = GetPlacedBlocksFromPlot(entry.plot)
        if #blocks == 0 then
            Library:Notify("That plot has no placed blocks.", 4)
            return nil
        end
        local plotCF = GetPlotCFrameOf(entry.plot)
        if not plotCF then return nil end
        local json = SerializeBlocks(blocks, plotCF)
        return LoadBuildJSON(json)
    elseif entry.type == "file" then
        return LoadBuildFromFile(entry.name)
    end
    return nil
end
local function UpdateMaterialLabel()
    if not MatLabel then return end
    local data = LoadSelectedBuildSource()
    if not data then
        MatLabel:SetText("No build selected.")
        return
    end
    local reqs = GetBuildRequirements(data)
    local _, display = ComputeMissingMaterials(reqs)
    MatLabel:SetText(display)
end
local function RunBuildFromSelectedSource()
    local data = LoadSelectedBuildSource()
    if not data then
        Library:Notify("Select a build file first.", 3)
        return
    end
    local plotCF = GetPlotCFrame()
    if not plotCF then
        Library:Notify("No plot found.", 4)
        return
    end
    local plot = GetPlot()
    if not plot then
        Library:Notify("No plot found.", 4)
        return
    end
    local bounds = GetPlotBounds()
    local ConfirmRad = 3
    local MaxPending = 5
    local Timeout = 0.5
    local MaxRetries = 2
    local pending = {}
    local placed, skipped, confirmed = 0, 0, 0
    notyuri("[LoadBuild] starting, blocks:", #data.blocks, "plotCF:", tostring(plotCF.Position), "bounds:", bounds ~= nil)
    local conn = plot.ChildAdded:Connect(function(child)
        if not child:IsA("Model") then
            notyuri("[LoadBuild] ChildAdded: ignored non-Model", child.ClassName, child.Name)
            return
        end
        local pp = child:WaitForChild("Primary", 1)
        if not pp then
            pp = child:FindFirstChildWhichIsA("BasePart")
            if pp then
                notyuri("[LoadBuild] ChildAdded: no 'Primary', using BasePart", pp.Name, "pos:", tostring(pp.Position))
            else
                notyuri("[LoadBuild] ChildAdded: Model", child.Name, "has no Primary or BasePart, skipping")
                return
            end
        end
        local matched = false
        for i, p in ipairs(pending) do
            local dist = (pp.Position - p.Position).Magnitude
            if dist < ConfirmRad then
                table.remove(pending, i)
                confirmed = confirmed + 1
                matched = true
                notyuri("[LoadBuild] confirmed:", child.Name, "dist:", string.format("%.2f", dist), "pending:", #pending, "total confirmed:", confirmed)
                break
            end
        end
        if not matched then
            notyuri("[LoadBuild] ChildAdded: no pending match for", child.Name, "at", tostring(pp.Position), "pending size:", #pending)
        end
    end)
    for idx, entry in ipairs(data.blocks) do
        if not Toggles.LoadBuild.Value then
            notyuri("[LoadBuild] toggle off, stopping at block", idx)
            break
        end
        local itemName = entry.name
        local count = GetItemCount(itemName)
        if count > 0 then
            local relCF = TableToCFrame(entry.cf)
            local worldCF = plotCF * relCF
            if bounds then
                local itemSize = GetItemSize(itemName)
                if itemSize then
                    worldCF = ClampToPlotBounds(worldCF, itemSize, bounds)
                end
            end
            notyuri("[LoadBuild] placing", itemName, "block", idx, "pos:", tostring(worldCF.Position), "inv:", count)
            table.insert(pending, { Position = worldCF.Position, itemName = itemName, cf = worldCF, retries = 0 })
            DoPlace(itemName, worldCF)
            placed = placed + 1
            local t0 = tick()
            while #pending > MaxPending do
                if tick() - t0 > Timeout then
                    local oldest = table.remove(pending, 1)
                    if oldest.retries < MaxRetries then
                        oldest.retries = oldest.retries + 1
                        notyuri("[LoadBuild] throttle timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
                        DoPlace(oldest.itemName, oldest.cf)
                        table.insert(pending, oldest)
                    else
                        notyuri("[LoadBuild] throttle timeout, giving up on", oldest.itemName, "after", MaxRetries, "retries")
                    end
                    t0 = tick()
                end
                task.wait()
            end
        else
            notyuri("[LoadBuild] skipping", itemName, "block", idx, "- no inventory")
            skipped = skipped + 1
        end
    end
    notyuri("[LoadBuild] main loop done. placed:", placed, "skipped:", skipped, "confirmed:", confirmed, "pending:", #pending)
    local t0 = tick()
    while #pending > 0 do
        if tick() - t0 > Timeout then
            local oldest = table.remove(pending, 1)
            if oldest.retries < MaxRetries then
                oldest.retries = oldest.retries + 1
                notyuri("[LoadBuild] drain timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
                DoPlace(oldest.itemName, oldest.cf)
                table.insert(pending, oldest)
            else
                notyuri("[LoadBuild] drain timeout, giving up on", oldest.itemName, "after", MaxRetries, "retries")
            end
            t0 = tick()
        end
        task.wait()
    end
    if #pending == 0 then
        notyuri("[LoadBuild] all confirmed ok")
    end
    pending = {}
    conn:Disconnect()
    Toggles.LoadBuild:SetValue(false)
    Library:Notify(("Build loaded: %d placed, %d skipped."):format(placed, skipped), 5)
    UpdateMaterialLabel()
end
local function CopyBuildToClipboard()
    local json = CopyBuildToJSON()
    if not json then
        Library:Notify("No placed items to copy.", 4)
        return
    end
    if setclipboard then
        pcall(setclipboard, json)
        Library:Notify("Build copied to clipboard.", 5)
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
    Build = Window:AddTab("Build"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local A1 = Tabs.Build:AddLeftGroupbox("Build")
local A2 = Tabs.Build:AddRightGroupbox("Material")
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
GB.Player.Left.General:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", { Text = "Anti AFK", Default = true, Disabled = not Support.Connections })
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddInput("AutoHopMins", { Text = "Minutes", Default = "30", Placeholder = "30" })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
local RARITY_ORDER = { Common=1, Uncommon=2, Rare=3, Legendary=4, Divine=5 }
local function BuildShopItemList()
    local list = {}
    if not ShopCat then return { "Any" } end
    for name, data in pairs(ShopCat) do
        local rarity = (type(data) == "table" and data.Rarity) or "?"
        table.insert(list, { label = name .. " | " .. rarity, name = name, rarity = rarity })
    end
    table.sort(list, function(a, b)
        local ra = RARITY_ORDER[a.rarity] or 0
        local rb = RARITY_ORDER[b.rarity] or 0
        if ra ~= rb then return ra < rb end
        return a.name < b.name
    end)
    local result = { "Any" }
    for _, item in ipairs(list) do table.insert(result, item.label) end
    return result
end
local function BuildCraftRecipeList()
    local list = {}
    if not _craftCatalog then return { "Any" } end
    for name in pairs(_craftCatalog) do table.insert(list, name) end
    table.sort(list)
    local result = { "Any" }
    for _, name in ipairs(list) do table.insert(result, name) end
    return result
end
local ShopList = BuildShopItemList()
local _recipeList = BuildCraftRecipeList()
TB_Tabs.Autofarm2.T1:AddDropdown("AutoPlaceItems", { Text = "Place List", Values = ShopList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyShopItems", { Text = "Shop List", Values = ShopList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoCraftRecipes", { Text = "Recipes List", Values = _recipeList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoPickUpItems", { Text = "Pick Up List", Values = ShopList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShop", { Text = "Auto Buy", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCraft", { Text = "Auto Craft", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrades", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickUp", { Text = "Auto Pick Up", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell Items", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoClaimQuests", { Text = "Auto Claim Quests", Default = false })
A1:AddDropdown("BuildSourceDropdown", {
    Text = "Select Build to Load",
    Values = {},
    Default = "",
    Multi = false,
    Searchable = true,
    Callback = function()
        UpdateMaterialLabel()
    end,
})
MatLabel = A2:AddLabel("No build selected.", true)
A1:AddButton({
    Text = "Buy Missing Items",
    Func = function()
        local data = LoadSelectedBuildSource()
        if not data then
            Library:Notify("Select a build source first.", 3)
            return
        end
        local reqs = GetBuildRequirements(data)
        local missing, display = ComputeMissingMaterials(reqs)
        local anyMissing = false
        for _ in pairs(missing) do anyMissing = true break end
        if not anyMissing then
            Library:Notify("No missing items", 4)
            return
        end
        local bought = 0
        for itemName, shortage in pairs(missing) do
            for _ = 1, shortage do
                DoBuyItem(itemName)
                bought = bought + 1
                task.wait(0.15)
            end
        end
        Library:Notify(("Buy Missing: bought %d items."):format(bought), 5)
        UpdateMaterialLabel()
    end,
})
A1:AddToggle("LoadBuild", {
    Text = "Load Build",
    Default = false,
    Callback = function(state)
        if state then
            local t = task.spawn(function()
                while Toggles.LoadBuild.Value do
                    RunBuildFromSelectedSource()
                    task.wait(5)
                end
            end)
            Flags.LoadBuild = t
        else
            if Flags.LoadBuild and typeof(Flags.LoadBuild) == "thread" then
                task.cancel(Flags.LoadBuild)
                Flags.LoadBuild = nil
            end
        end
    end,
})
A1:AddInput("BuildSaveName", {
    Text = "File Name",
    Default = "",
    Placeholder = "yuriyuri",
    Callback = function() end,
})
A1:AddButton({
    Text = "Save Build",
    Func = function()
        SaveBuildToFile(Options.BuildSaveName and Options.BuildSaveName.Value or "")
    end,
})
A1:AddButton({
    Text = "Save Selected",
    Func = function()
        local saveName = Options.BuildSaveName and Options.BuildSaveName.Value or ""
        if not saveName or saveName == "" then
            Library:Notify("Enter a file name first.", 3)
            return
        end
        if not Support.FileIO then
            Library:Notify("File IO not supported by executor.", 4)
            return
        end
        local data = LoadSelectedBuildSource()
        if not data then return end
        local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
        if not ok or not json then
            Library:Notify("Failed to encode build data.", 4)
            return
        end
        local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
        pcall(function()
            if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
            writefile(path, json)
        end)
        local count = type(data.blocks) == "table" and #data.blocks or 0
        Library:Notify(("Selected build saved to %s (%d blocks)"):format(saveName, count), 5)
        notyuri("[CopyBuild] selected saved to", path)
        RefreshBuildSourcesDropdown()
    end,
})
task.spawn(function()
    task.wait(2)
    RefreshBuildSourcesDropdown()
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
Toggles.AutoPlace:OnChanged(function(v)
    Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), v)
end)
Toggles.AutoBuyShop:OnChanged(function(v)
    Thread("AutoBuyShop", SafeLoop("AutoBuyShop", Func_AutoBuyShop), v)
end)
Toggles.AutoCraft:OnChanged(function(v)
    Thread("AutoCraft", SafeLoop("AutoCraft", Func_AutoCraft), v)
end)
Toggles.AutoUpgrade:OnChanged(function(v)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
end)
Toggles.AutoSell:OnChanged(function(v)
    Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSell), v)
end)
Toggles.AutoClaimQuests:OnChanged(function(v)
    Thread("AutoClaimQuests", SafeLoop("AutoClaimQuests", Func_AutoClaimQuests), v)
end)
Toggles.AutoPickUp:OnChanged(function(v)
    Thread("AutoPickUp", SafeLoop("AutoPickUp", Func_AutoPickUp), v)
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
SaveManager:SetFolder("Yuri/BuildATower")
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