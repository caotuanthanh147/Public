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
local Players        = Services.Players
local Plr            = Players.LocalPlayer
local PGui           = Plr.PlayerGui
local Lighting       = Services.Lighting
local RS             = Services.ReplicatedStorage
local RunService     = Services.RunService
local HttpService    = Services.HttpService
local GuiService     = Services.GuiService
local TeleportService= Services.TeleportService
local Marketplace    = Services.MarketplaceService
local UIS            = Services.UserInputService
local VirtualUser    = Services.VirtualUser
local v, Asset = pcall(function()
    return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then assetName = Asset.Name end
local Support = {
    Webhook      = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard    = (typeof(setclipboard) == "function"),
    FileIO       = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
    Connections  = (typeof(getconnections) == "function"),
    FPS          = (typeof(setfpscap) == "function"),
    Proximity    = (typeof(fireproximityprompt) == "function"),
}
local executorName        = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors    = {"xeno", "solara"}
local isLimitedExecutor   = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then isLimitedExecutor = true break end
end
local function notyuri()
end
local repo = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager= loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
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
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor          = true
Library.NotifySide                = "Left"
local function AddInfo(Window)
    local InfoTab  = Window:AddTab("Info")
    local InfoLeft = InfoTab:AddLeftGroupbox("Information")
    local statusText = isLimitedExecutor
        and "<font color='#FFA500'>Semi-Working</font>"
        or  "<font color='#00FF00'>Working</font>"
    local extraNote = isLimitedExecutor
        and "<b>NOTE:</b> May experiencing bugs for some features!"
        or  "All features should works properly!"
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
                        Url    = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"]       = "https://discord.com"
                        },
                        Body = HttpService:JSONEncode({
                            cmd   = "INVITE_BROWSER",
                            args  = { code = inviteCode },
                            nonce = HttpService:GenerateGUID(false),
                        }),
                    })
                end)
            end
            if not success and setclipboard then
                setclipboard(inviteLink)
                Library:Notify("Invite link copied to clipboard!", 4)
            end
        end,
    })
end
local function firesignal(signal, ...)
    if firesignal then
        firesignal(signal, ...)
    elseif getconnections then
        for _, connection in pairs(getconnections(signal)) do
            if connection.Function then
                task.spawn(connection.Function, ...)
            end
        end
    else
        warn("Your executor does not support firesignal or getconnections.")
    end
end
local function gsc(guiObject)
    if not guiObject then return false end
    local success = false
    pcall(function()
        if Services.GuiService and Services.VirtualInputManager then
            Services.GuiService.SelectedObject = guiObject
            task.wait(0.05)
            local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
            for _, key in ipairs(keys) do
                Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.2)
                Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.1)
            end
            Services.GuiService.SelectedObject = nil
            success = true
        end
    end)
    return success
end
function AddSliderToggle(Config)
    local Toggle = Config.Group:AddToggle(Config.Id, {
        Text    = Config.Text,
        Default = Config.DefaultToggle or false,
        Disabled= Config.Disabled,
    })
    local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
        Text      = Config.Text,
        Default   = Config.Default,
        Min       = Config.Min,
        Max       = Config.Max,
        Rounding  = Config.Rounding or 0,
        Compact   = true,
        Visible   = false,
    })
    Toggle:OnChanged(function()
        Slider:SetVisible(Toggle.Value)
        if Config.Callback then Config.Callback(Toggle.Value) end
    end)
    return Toggle, Slider
end
local Flags = {}
local Shared = {}
local Tables = {}
local Connections = {
    Player_General = nil,
    Knockback      = {},
    Reconnect      = nil,
}
local function Cleanup(tbl)
    for key, value in pairs(tbl) do
        if typeof(value) == "RBXScriptConnection" then
            value:Disconnect()
            tbl[key] = nil
        elseif typeof(value) == "thread" then
            task.cancel(value)
            tbl[key] = nil
        elseif type(value) == "table" then
            Cleanup(value)
        end
    end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
    local pathParts    = featurePath:split(".")
    local currentTable = Flags
    for i = 1, #pathParts - 1 do
        local part = pathParts[i]
        if not currentTable[part] then currentTable[part] = {} end
        currentTable = currentTable[part]
    end
    local flagKey     = pathParts[#pathParts]
    local activeThread= currentTable[flagKey]
    if isEnabled then
        if not activeThread or coroutine.status(activeThread) == "dead" then
            currentTable[flagKey] = task.spawn(featureFunc, ...)
        end
    else
        if activeThread and typeof(activeThread) == "thread" then
            task.cancel(activeThread)
            currentTable[flagKey] = nil
        end
    end
end
local function SafeLoop(name, func)
    return function()
        local success, err = pcall(func)
        if not success then notyuri("[SafeLoop:" .. name .. "] error:", err) end
    end
end
local function GetCharacter()
    return Plr.Character
end
local ModulesFolder = RS:FindFirstChild("Modules")
local function GetSafeModule(folder, name)
    local inst = folder:FindFirstChild(name)
    if not inst then return nil end
    local ok, mod = pcall(require, inst)
    return ok and mod or nil
end
local Game = {
    DataModule     = GetSafeModule(ModulesFolder, "DataModule")     or nil,
    Networking     = GetSafeModule(ModulesFolder, "Networking")     or nil,
    SharedFunctions= GetSafeModule(ModulesFolder, "SharedFunctions")or nil,
    GameDefinition = GetSafeModule(ModulesFolder, "GameDefinition") or nil,
    FormulaHandler = GetSafeModule(ModulesFolder, "FormulaHandler") or nil,
    BlockCache     = GetSafeModule(ModulesFolder, "BlockCache")     or nil,
    BlockHandler   = GetSafeModule(ModulesFolder, "BlockHandler")   or nil,
    Translator     = GetSafeModule(ModulesFolder, "Translator")     or nil,
    ClientFunctions= GetSafeModule(ModulesFolder, "ClientFunctions")or nil,
}
local function GetPlayerData()
    if Game.DataModule then
        local ok, data = pcall(function() return Game.DataModule.GetData(Plr) end)
        if ok then return data end
    end
    return nil
end
local function NetInvoke(name, ...)
    if not Game.Networking then return nil end
    local args   = { ... }
    local result = nil
    local done   = false
    task.spawn(function()
        local ok, res = pcall(function() return Game.Networking.Invoke(name, table.unpack(args)) end)
        result = ok and res or nil
        done   = true
    end)
    local start = tick()
    while not done and (tick() - start) < 8 do task.wait() end
    return result
end
local function NetFire(name, ...)
    if not Game.Networking then return end
    local args = { ... }
    pcall(function() Game.Networking.Fire(name, table.unpack(args)) end)
end
local function GetPlayerBlockPosition()
    local char = GetCharacter()
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        notyuri("[GetPos] no HRP")
        return nil
    end
    local wx, wy, wz = 0, 0, 0
    if Game.BlockHandler then
        local ok, ox, oy, oz = pcall(function()
            return Game.BlockHandler.GetWorldOffset()
        end)
        if ok then wx, wy, wz = ox or 0, oy or 0, oz or 0 end
    end
    local px = math.floor(hrp.Position.X / 6 + 0.5) - 2000 + wx
    local py = math.floor(hrp.Position.Y / 6 + 0.5) - 2000 + wy
    local pz = math.floor(hrp.Position.Z / 6 + 0.5) - 2000 + wz
    return px, py, pz
end
local function IsBackpackFull()
    local data = GetPlayerData()
    if not data or not Game.SharedFunctions or not Game.FormulaHandler then return false end
    local ok, res = pcall(function() return Game.SharedFunctions.IsBackpackFull(data) end)
    return ok and res or false
end
local function UpgradeList()
    local list = {}
    local data = GetPlayerData()
    local gd = Game.GameDefinition
    if data and data.Upgrades and gd and gd.Formulas and gd.Formulas.Upgrades then
        for _, category in ipairs(data.Upgrades:GetChildren()) do
            for _, upgrade in ipairs(category:GetChildren()) do
                local key = category.Name .. "_" .. upgrade.Name
                local def = gd.Formulas.Upgrades[key]
                local label = (def and def.Type) or key
                table.insert(list, key .. "|" .. label)
            end
        end
    end
    table.sort(list)
    return list
end
local function BuildOreOptionList()
    local gd = Game.GameDefinition
    if not gd or not gd.RarityMap then return {} end
    local items = {}
    for blockId, rarity in pairs(gd.RarityMap) do
        if rarity and rarity >= 1 then
            local displayName = tostring(blockId)
            if Game.Translator then
                local ok, name = pcall(function()
                    return Game.Translator.Get("Blocks." .. blockId)
                end)
                if ok and name and name ~= "" and not name:find("^Blocks%.") then
                    displayName = name
                end
            end
            local rarityName = "R" .. rarity
            if Game.Translator then
                local ok, rname = pcall(function()
                    return Game.Translator.Get("Rarity." .. rarity)
                end)
                if ok and rname and rname ~= "" and not rname:find("^Rarity%.") then
                    rarityName = rname
                end
            end
            table.insert(items, {
                id      = blockId,
                rarity  = rarity,
                name    = displayName,
                label   = displayName .. " (R" .. rarity .. " - " .. rarityName .. ")",
            })
        end
    end
    table.sort(items, function(a, b)
        if a.rarity ~= b.rarity then return a.rarity < b.rarity end
        return a.name < b.name
    end)
    local result = {}
    for _, item in ipairs(items) do
        table.insert(result, item.label)
    end
    table.insert(result, "Emerald (Special)")
    return result
end
local function BuildRarityList()
    local gd = Game.GameDefinition
    if not gd or not gd.RarityMap then return {} end
    local seen = {}
    for _, rarity in pairs(gd.RarityMap) do
        if rarity and rarity >= 1 then
            seen[rarity] = true
        end
    end
    local rarities = {}
    for r in pairs(seen) do table.insert(rarities, r) end
    table.sort(rarities)
    local list = {}
    for _, r in ipairs(rarities) do
        local rarityName = "R" .. r
        if Game.Translator then
            local ok, rname = pcall(function()
                return Game.Translator.Get("Rarity." .. r)
            end)
            if ok and rname and rname ~= "" and not rname:find("^Rarity%.") then
                rarityName = rname
            end
        end
        table.insert(list, rarityName)
    end
    return list
end
local function BuildRarityLabelToId()
    local gd = Game.GameDefinition
    if not gd or not gd.RarityMap then return {} end
    local seen = {}
    for _, rarity in pairs(gd.RarityMap) do
        if rarity and rarity >= 1 then seen[rarity] = true end
    end
    local map = {}
    for r in pairs(seen) do
        local rarityName = "R" .. r
        if Game.Translator then
            local ok, rname = pcall(function()
                return Game.Translator.Get("Rarity." .. r)
            end)
            if ok and rname and rname ~= "" and not rname:find("^Rarity%.") then
                rarityName = rname
            end
        end
        map[rarityName] = r
    end
    return map
end
local function BuildLabelToId()
    local gd = Game.GameDefinition
    if not gd or not gd.RarityMap then return {} end
    local map = {}
    for blockId, rarity in pairs(gd.RarityMap) do
        if rarity and rarity >= 1 then
            local displayName = tostring(blockId)
            if Game.Translator then
                local ok, name = pcall(function()
                    return Game.Translator.Get("Blocks." .. blockId)
                end)
                if ok and name and name ~= "" and not name:find("^Blocks%.") then
                    displayName = name
                end
            end
            local rarityName = "R" .. rarity
            if Game.Translator then
                local ok, rname = pcall(function()
                    return Game.Translator.Get("Rarity." .. rarity)
                end)
                if ok and rname and rname ~= "" and not rname:find("^Rarity%.") then
                    rarityName = rname
                end
            end
            local label = displayName .. " (R" .. rarity .. " - " .. rarityName .. ")"
            map[label]  = blockId
        end
    end
    map["Emerald (Special)"] = 863
    return map
end
local function BuildRecipeOptionList()
    local gd = Game.GameDefinition
    if not gd or not gd.Accessories then return {}, {} end
    local labels        = {}
    local labelToBlockIds = {}
    for accIndex, accessory in ipairs(gd.Accessories) do
        if accessory.Levels then
            for levelIndex, level in ipairs(accessory.Levels) do
                if level.Recipe and #level.Recipe > 0 then
                    local accName = tostring(accIndex)
                    if Game.Translator then
                        local ok, name = pcall(function()
                            return Game.Translator.Get("Accessories." .. accIndex .. "." .. levelIndex .. ".Name")
                        end)
                        if ok and name and name ~= "" and not name:find("^Accessories%.") then
                            accName = name
                        end
                    end
                    local label = accName
                    local blockIds = {}
                    for _, entry in ipairs(level.Recipe) do
                        blockIds[entry[1]] = true
                    end
                    table.insert(labels, label)
                    labelToBlockIds[label] = blockIds
                end
            end
        end
    end
    table.sort(labels)
    return labels, labelToBlockIds
end
local ESPFolder     = Instance.new("Folder")
ESPFolder.Parent    = Services.CoreGui
local ESPConnections= {}
local ESPHighlights = {}  
local function makeLabel(text, sizeY, posY, bold, color)
    local lbl                   = Instance.new("TextLabel")
    lbl.Size                    = UDim2.new(1, 0, sizeY, 0)
    lbl.Position                = UDim2.new(0, 0, posY,  0)
    lbl.BackgroundTransparency  = 1
    lbl.Text                    = text
    lbl.TextColor3              = color or Color3.new(1,1,1)
    lbl.TextStrokeColor3        = Color3.new(0,0,0)
    lbl.TextStrokeTransparency  = 0.4
    lbl.TextScaled              = true
    lbl.Font                    = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextXAlignment          = Enum.TextXAlignment.Center
    return lbl
end
local function makeBillboard(adornee, name, color)
    local bb             = Instance.new("BillboardGui")
    bb.Adornee           = adornee
    bb.Size              = UDim2.new(0, 80, 0, 22)
    bb.StudsOffset       = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop       = true
    bb.ResetOnSpawn      = false
    bb.Parent            = ESPFolder
    local nameLbl        = makeLabel(name, 0.55, 0,    true,  color)
    nameLbl.Parent       = bb
    local distLbl        = makeLabel("",   0.45, 0.55, false, color)
    distLbl.Parent       = bb
    return bb, nameLbl, distLbl
end
local ESPAnchorFolder = Instance.new("Folder")
ESPAnchorFolder.Parent= ESPFolder
local function makeHighlight(fillColor, outlineColor, labelText)
    local anchor              = Instance.new("Part")
    anchor.Anchored           = true
    anchor.CanCollide         = false
    anchor.Transparency       = 1
    anchor.Size               = Vector3.new(6, 6, 6)
    anchor.Parent             = ESPAnchorFolder
    local h                   = Instance.new("Highlight")
    h.Adornee                 = anchor
    h.FillColor               = fillColor
    h.OutlineColor            = outlineColor
    h.FillTransparency        = 0.4
    h.OutlineTransparency     = 0
    h.DepthMode               = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent                  = ESPFolder
    local bb, nameLbl, distLbl = makeBillboard(anchor, labelText, fillColor)
    return { hl = h, bb = bb, distLbl = distLbl, nameLbl = nameLbl, anchor = anchor }
end
local ESPPool = {}
local function acquireEntry()
    local entry = table.remove(ESPPool)
    if entry then
        entry.hl.Enabled = true
        entry.bb.Enabled = true
        return entry
    end
    return makeHighlight(Color3.new(1,1,1), Color3.new(0,0,0), "")
end
local function releaseEntry(entry)
    entry.hl.Enabled  = false
    entry.bb.Enabled  = false
    entry.anchor.Position = Vector3.new(0, -5000, 0)
    table.insert(ESPPool, entry)
end
local function removeEntry(tbl, key)
    if tbl[key] then
        releaseEntry(tbl[key])
        tbl[key] = nil
    end
end
local function clearAllESP()
    for blockId, partMap in pairs(ESPHighlights) do
        for part, _ in pairs(partMap) do
            removeEntry(partMap, part)
        end
        ESPHighlights[blockId] = nil
    end
end
local function getRarityColor(rarity)
    local gd = Game.GameDefinition
    if gd and gd.RarityColors then
        local c = gd.RarityColors[rarity]
        if c then return c end
    end
    return Color3.new(1, 1, 1)
end
local function getOreName(blockId)
    if Game.Translator then
        local ok, name = pcall(function()
            return Game.Translator.Get("Blocks." .. blockId)
        end)
        if ok and name and name ~= "" and not name:find("^Blocks%.") then
            return name
        end
    end
    return tostring(blockId)
end
local CachedLabelToId       = nil
local CachedRarityLabelToId = nil
local function GetLabelToId()
    if not CachedLabelToId then
        CachedLabelToId = BuildLabelToId()
    end
    return CachedLabelToId
end
local function GetRarityLabelToId()
    if not CachedRarityLabelToId then
        CachedRarityLabelToId = BuildRarityLabelToId()
    end
    return CachedRarityLabelToId
end
local CachedRecipeLabelToBlockIds = nil
local function GetRecipeLabelToBlockIds()
    if not CachedRecipeLabelToBlockIds then
        local _, labelToBlockIds = BuildRecipeOptionList()
        CachedRecipeLabelToBlockIds = labelToBlockIds
    end
    return CachedRecipeLabelToBlockIds
end
local function InvalidateLabelCaches()
    CachedLabelToId       = nil
    CachedRarityLabelToId = nil
    CachedRecipeLabelToBlockIds = nil
end
local GetRecipeSelection = nil
local GetExcludeOreSelection = nil
local function GetSelectedBlockIds()
    local labelToId = GetLabelToId()
    local selected  = {}
    if Options.OreSelected then
        for label, _ in pairs(Options.OreSelected.Value) do
            local id = labelToId[label]
            if id then selected[id] = true end
        end
    end
    if GetRecipeSelection then
        local recipeLabelToBlockIds = GetRecipeLabelToBlockIds()
        for recipeLabel, _ in pairs(GetRecipeSelection()) do
            local blockIds = recipeLabelToBlockIds[recipeLabel]
            if blockIds then
                for blockId, _ in pairs(blockIds) do
                    selected[blockId] = true
                end
            end
        end
    end
    if Options.RaritySelected then
        local rarityFilter = Options.RaritySelected.Value
        if rarityFilter and next(rarityFilter) then
            local rarityLabelToId = GetRarityLabelToId()
            local allowedRarities = {}
            for label, _ in pairs(rarityFilter) do
                local r = rarityLabelToId[label]
                if r then allowedRarities[r] = true end
            end
            local gd = Game.GameDefinition
            if gd and gd.RarityMap then
                for id, rarity in pairs(gd.RarityMap) do
                    if allowedRarities[rarity] then
                        selected[id] = true
                    end
                end
            end
        end
    end
    if GetExcludeOreSelection then
        for id, _ in pairs(GetExcludeOreSelection()) do
            selected[id] = nil
        end
    end
    return selected
end
local ChunkData    = nil  
local WorldOffset  = nil  
local function GetWorldOffset()
    local cf = Game.ClientFunctions
    if cf and type(cf.Position) == "table" and rawget(cf.Position, "World") ~= nil then
        return cf.Position
    end
    notyuri("[GetWorldOffset] ClientFunctions.Position not available")
    return nil
end
local function GetChunkData()
    local cf = Game.ClientFunctions
    local dbgGetUpvals = debug and (debug.getupvalues or debug.getupvals) or getupvalues or getupvals
    if cf and cf.GetBlock and dbgGetUpvals then
        local ok, uvs = pcall(dbgGetUpvals, cf.GetBlock)
        if ok and type(uvs) == "table" then
            for _, uv in pairs(uvs) do
                if type(uv) ~= "table" then continue end
                if rawget(uv, "GetVector3") or rawget(uv, "FromPosition") then continue end
                notyuri("[GetChunkData] found via GetBlock upvalues")
                return uv
            end
        end
    end
    notyuri("[GetChunkData] not found")
    return nil
end
local function BlockToWorldPos(bx, by, bz, posWorld)
    if Game.SharedFunctions then
        local ok, cf = pcall(function()
            return Game.SharedFunctions.GetCFrame(bx, by, bz, posWorld)
        end)
        if ok and cf then return cf.Position end
    end
    local wx = posWorld and posWorld.X or 0
    local wy = posWorld and posWorld.Y or 0
    local wz = posWorld and posWorld.Z or 0
    return Vector3.new(
        (bx + (2000 - wx * 10922)) * 6,
        (by + (2000 - wy * 10922)) * 6,
        (bz + (2000 - wz * 10922)) * 6
    )
end
local function SafeTeleport(targetCFrame)
    local char = GetCharacter()
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not WorldOffset then WorldOffset = GetWorldOffset() end
    local pos = targetCFrame.Position
    if Game.SharedFunctions and WorldOffset then
        local ok, newPos = pcall(function()
            local x, y, z = Game.SharedFunctions.ToPosition(WorldOffset)
            local bx = math.floor(pos.X / 6 + 0.5)
            local by = math.floor(pos.Y / 6 + 0.5)
            local bz = math.floor(pos.Z / 6 + 0.5)
            return Game.SharedFunctions.FromPosition(bx, by, bz)
        end)
        if ok and newPos then
            WorldOffset.CFrame = newPos.CFrame
            WorldOffset.World  = newPos.World
            notyuri("[SafeTeleport] Updated internal position -> World", newPos.World.X, newPos.World.Y, newPos.World.Z)
            local cf = Game.ClientFunctions
            if cf then
                local pok, abx, aby, abz = pcall(Game.SharedFunctions.ToPosition, newPos)
                if pok and abx then
                    local existingRadius = cf.ServerPosition and cf.ServerPosition[4] or 0
                    cf.ServerPosition = { abx, aby, abz, existingRadius }
                    notyuri("[SafeTeleport] Patched ServerPosition ->", abx, aby, abz, "r:", existingRadius)
                else
                    notyuri("[SafeTeleport] ToPosition failed, skipping ServerPosition patch")
                end
            end
        else
            notyuri("[SafeTeleport] FromPosition failed, moving HRP only")
        end
    else
        notyuri("[SafeTeleport] SharedFunctions/WorldOffset unavailable, moving HRP only")
    end
    hrp.CFrame = targetCFrame
end
local function DecodeBlockId(slotVal)
    if not slotVal then return 0 end
    local v1 = slotVal[1]
    if v1 == nil then return 0 end
    if type(v1) == "table" then
        return v1[1] or 0
    end
    return v1 or 0
end
local function clearESPAnchors()
    clearAllESP()
end
local ESPByKey = {}
local ESP_MAX_MARKERS = 200
local function RefreshESP()
    if not Toggles.ESPOreToggle or not Toggles.ESPOreToggle.Value then
        clearESPAnchors()
        ESPByKey = {}
        return
    end
    local selectedIds = GetSelectedBlockIds()
    if not next(selectedIds) then
        notyuri("[ESP] No ore/rarity selected, nothing to scan for")
        clearESPAnchors()
        ESPByKey = {}
        return
    end
    if not WorldOffset then WorldOffset = GetWorldOffset() end
    if not ChunkData   then ChunkData   = GetChunkData()   end
    if not ChunkData or not WorldOffset then
        notyuri("[ESP] No chunk data available for ESP scan")
        return
    end
    local posWorld = WorldOffset.World
    if not posWorld then
        notyuri("[ESP] Could not read World from ClientFunctions.Position")
        return
    end
    local gd = Game.GameDefinition
    if not gd or not gd.RarityMap then
        notyuri("[ESP] GameDefinition or RarityMap missing")
        return
    end
    local char  = GetCharacter()
    local hrp   = char and char:FindFirstChild("HumanoidRootPart")
    local origin= hrp and hrp.Position or Vector3.new(0, 0, 0)
    local espRange = Options.ESPRange and Options.ESPRange.Value or 3000
    local candidates = {}
    local chunksScanned, slotsMatched, slotsOutOfRange = 0, 0, 0
    for chunkKey, chunk in pairs(ChunkData) do
        if type(chunk) ~= "table" or chunk.Empty or chunk.Unloading or chunk.Loading then continue end
        chunksScanned = chunksScanned + 1
        local cx, cy, cz
        if typeof(chunkKey) == "Vector3" then
            cx, cy, cz = chunkKey.X, chunkKey.Y, chunkKey.Z
        else
            local ok3, x3, y3, z3 = pcall(string.unpack, "ddd", chunkKey)
            if not ok3 then continue end
            cx, cy, cz = x3, y3, z3
        end
        for slotIdx, slotVal in pairs(chunk) do
            if type(slotIdx) ~= "number" then continue end
            local blockId = DecodeBlockId(slotVal)
            if blockId == 0 or blockId == 861 then continue end
            if not selectedIds[blockId] then continue end
            local lx = slotIdx % 16
            local lz = math.floor(slotIdx / 16) % 16
            local ly = math.floor(slotIdx / 256)
            local bx = cx * 16 + lx
            local by = cy * 16 + ly
            local bz = cz * 16 + lz
            local worldPos = BlockToWorldPos(bx, by, bz, posWorld)
            local dist = (worldPos - origin).Magnitude
            if dist > espRange then
                slotsOutOfRange = slotsOutOfRange + 1
                continue
            end
            slotsMatched = slotsMatched + 1
            candidates[#candidates + 1] = {
                bx = bx, by = by, bz = bz,
                blockId = blockId,
                worldPos = worldPos,
                dist = dist,
                key = bx .. ":" .. by .. ":" .. bz,
            }
        end
    end
    table.sort(candidates, function(a, b) return a.dist < b.dist end)
    local seenKeys = {}
    local added, kept, capped = 0, 0, 0
    for i, cand in ipairs(candidates) do
        if i > ESP_MAX_MARKERS then
            capped = capped + 1
            continue
        end
        local key = cand.key
        seenKeys[key] = true
        if ESPByKey[key] then
            kept = kept + 1
        else
            local rarity = gd.RarityMap[cand.blockId] or 0
            local fillColor    = Options.ESPFillColor and Options.ESPFillColor.Value or getRarityColor(rarity)
            local outlineColor = Options.ESPOutlineColor and Options.ESPOutlineColor.Value or Color3.new(0, 0, 0)
            local label        = getOreName(cand.blockId)
            local entry = acquireEntry()
            entry.anchor.Position = cand.worldPos
            entry.hl.FillColor    = fillColor
            entry.hl.OutlineColor = outlineColor
            entry.nameLbl.Text       = label
            entry.nameLbl.TextColor3 = fillColor
            entry.distLbl.TextColor3 = fillColor
            notyuri("[ESP] new marker", key, "id", cand.blockId, "pos", tostring(cand.worldPos), "hlEnabled", entry.hl.Enabled, "hlParent", tostring(entry.hl.Parent), "anchorParent", tostring(entry.anchor.Parent))
            if not ESPHighlights[cand.blockId] then
                ESPHighlights[cand.blockId] = {}
            end
            ESPHighlights[cand.blockId][entry.anchor] = entry
            ESPByKey[key] = { blockId = cand.blockId, anchor = entry.anchor }
            added = added + 1
        end
    end
    for key, rec in pairs(ESPByKey) do
        if not seenKeys[key] then
            local partMap = ESPHighlights[rec.blockId]
            if partMap then removeEntry(partMap, rec.anchor) end
            ESPByKey[key] = nil
        end
    end
    notyuri("[ESP] chunks", chunksScanned, "matched", slotsMatched, "outOfRange", slotsOutOfRange, "cappedBeyondNearest" .. ESP_MAX_MARKERS, capped, "+" .. added, "kept " .. kept, "total " .. (added + kept))
end
local ESP_DIST_UPDATE_INTERVAL = 0.15
local ESP_DIST_MOVE_THRESHOLD  = 3
local function StartESPDistanceUpdater()
    Thread("ESPDist", function()
        local lastOrigin = nil
        while Toggles.ESPOreToggle and Toggles.ESPOreToggle.Value do
            local char = GetCharacter()
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local origin = hrp.Position
                if not lastOrigin or (origin - lastOrigin).Magnitude >= ESP_DIST_MOVE_THRESHOLD then
                    lastOrigin = origin
                    for _, partMap in pairs(ESPHighlights) do
                        for _, entry in pairs(partMap) do
                            if entry.distLbl and entry.bb and entry.bb.Adornee and entry.bb.Adornee.Parent then
                                local dist = math.floor((entry.bb.Adornee.Position - origin).Magnitude)
                                entry.distLbl.Text = dist .. " studs"
                            end
                        end
                    end
                end
            end
            task.wait(ESP_DIST_UPDATE_INTERVAL)
        end
    end, true)
end
local function StartESPScanLoop()
    Thread("ESPScan", function()
        while Toggles.ESPOreToggle and Toggles.ESPOreToggle.Value do
            if not ChunkData then
                ChunkData = GetChunkData()
            end
            RefreshESP()
            task.wait(Options.ESPRefreshInterval and Options.ESPRefreshInterval.Value or 1)
        end
        clearESPAnchors()
    end, true)
end
local function Func_AntiKnockback()
    if type(Connections.Knockback) == "table" then
        for _, conn in pairs(Connections.Knockback) do
            if conn and typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
        table.clear(Connections.Knockback)
    else
        Connections.Knockback = {}
    end
    local function applyAK(char)
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local conn = hrp:GetPropertyChangedSignal("AssemblyLinearVelocity"):Connect(function()
                if Toggles.AntiKnockback.Value then hrp.AssemblyLinearVelocity = Vector3.new(0,0,0) end
            end)
            table.insert(Connections.Knockback, conn)
        end
    end
    applyAK(Plr.Character)
    local charAddedConn = Plr.CharacterAdded:Connect(function(c)
        task.wait(0.1)
        applyAK(c)
    end)
    table.insert(Connections.Knockback, charAddedConn)
    while Toggles.AntiKnockback.Value do task.wait(1) end
    for _, conn in pairs(Connections.Knockback) do
        if conn and typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    table.clear(Connections.Knockback)
end
local function FuncNoclip()
    while Toggles.Noclip.Value do
        local char = Plr.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
        task.wait()
    end
end
local function FuncTPW()
    while Toggles.TPW.Value do
        local char = Plr.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            local mv  = Options.TPWValue.Value or 1
            local dir = hrp.CFrame.LookVector
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + moveDir * mv
            end
        end
        task.wait()
    end
end
local function Func_NoGameplayPaused()
    while Toggles.NoGameplayPaused.Value do
        local cg = game:GetService("CoreGui")
        local rg = cg:FindFirstChild("RobloxGui")
        local np = rg and rg:FindFirstChild("CoreScripts/NetworkPause")
        if np then np.Enabled = false end
        task.wait(0.5)
    end
end
local function ApplyFPSBoost(state)
    if not state then return end
    pcall(function()
        local settings = UserSettings and UserSettings():GetService("UserGameSettings")
        if settings then settings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel01 end
    end)
    pcall(function() settings("Rendering/QualityLevel", 1) end)
end
local function Func_AutoReconnect()
    if Connections.Reconnect then Connections.Reconnect:Disconnect() end
    Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
        if Toggles.AutoReconnect.Value then
            task.wait(3)
            TeleportService:Teleport(game.PlaceId, Plr)
        end
    end)
end
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        if IsBackpackFull() then
            notyuri("[AutoSell] full -> TeleportSell")
            NetFire("TeleportSell")
            task.wait(.1)
        else
            local threshold = Options.SellThresholdValue and Options.SellThresholdValue.Value or 100
            local data = GetPlayerData()
            if data and Game.FormulaHandler then
                local ok, cap = pcall(function() return Game.FormulaHandler.GetInfo(data, "Backpack") end)
                if ok and cap and cap > 0 then
                    local cur = data.NumberValues.Blocks.Value + data.NumberValues.PendingBlocks.Value
                    local pct = (cur / cap) * 100
                    notyuri("[AutoSell] BP", math.floor(pct) .. "%", "threshold", threshold .. "%")
                    if pct >= threshold then
                        NetFire("TeleportSell")
                        task.wait(.1)
                    end
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local data = GetPlayerData()
        local gd = Game.GameDefinition
        if data and Game.FormulaHandler and Game.SharedFunctions and gd and gd.Formulas and gd.Formulas.Upgrades then
            local selected = Options.SelectedUpgrade and Options.SelectedUpgrade.Value or {}
            for entry, _ in pairs(selected) do
                local id = entry:match("^([^|]+)")
                if id and id ~= "" then
                    local def = gd.Formulas.Upgrades[id]
                    local ok, cost = pcall(function()
                        return Game.FormulaHandler.GetCost(data, id)
                    end)
                    local currency = def and def.Currency
                    if type(currency) == "function" then
                        local okc, result = pcall(currency, cost, data)
                        currency = okc and result or nil
                    end
                    local okv, currencyInst = pcall(function()
                        return Game.SharedFunctions.GetValue(data, currency)
                    end)
                    local currencyVal = okv and currencyInst and currencyInst.Value
                    if ok and cost and currencyVal and currencyVal >= cost then
                        notyuri("[AutoUpgrade] buy", id)
                        NetFire("BuyUpgrade", id)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoBuy()
    while Toggles.AutoBuy.Value do
        local data = GetPlayerData()
        if data and Game.FormulaHandler then
            local selected = Options.AutoBuyItems and Options.AutoBuyItems.Value or {}
            for cat, _ in pairs(selected) do
                local unl = data.Equipables.Unlocked[cat]
                if not unl then task.wait(0.1) continue end
                local ok, cost = pcall(function()
                    return Game.FormulaHandler.GetEquipableCost(data, cat)
                end)
                local gd = Game.GameDefinition
                local currency = gd and gd.Formulas and gd.Formulas.Equipables[cat] and gd.Formulas.Equipables[cat].Currency
                local currencyInst = currency and data.NumberValues:FindFirstChild(currency)
                local currencyVal = currencyInst and currencyInst.Value
                if ok and cost and currencyVal and currencyVal >= cost then
                    NetFire("Equip", cat, unl.Value + 1)
                    task.wait()
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoExplode()
    while Toggles.AutoExplode.Value do
        local data  = GetPlayerData()
        local expId = 0
        if data and data.Others and data.Others.Explosive then
            expId = data.Others.Explosive.Value or 0
        end
        if expId ~= 0 then
            local px, py, pz = GetPlayerBlockPosition()
            if not px then task.wait(0.1) continue end
            local ok = ExplodeAt(px, py-1, pz, expId)
            if ok == nil then notyuri("[AutoExplode] no response") end
        end
        task.wait(.1)
    end
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local sel = Options.PlaceBlock and Options.PlaceBlock.Value or nil
        if sel and sel ~= "" then
            local idStr  = sel:match("^([^|]+)")
            local blockId= tonumber(idStr)
            if blockId then
                local px, py, pz = GetPlayerBlockPosition()
                if not px then task.wait(0.1) continue end
                local char = GetCharacter()
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                local look = hrp and hrp.CFrame.LookVector or Vector3.new(0, 0, -1)
                local dx, dz = 0, 0
                if math.abs(look.X) > math.abs(look.Z) then
                    dx = look.X > 0 and 1 or -1
                else
                    dz = look.Z > 0 and 1 or -1
                end
                PlaceBlockAt(px+dx, py, pz+dz, blockId)
            end
        end
        task.wait(.1)
    end
end
local LastPrestige = 0
local function Func_AutoPrestige()
    while Toggles.AutoPrestige.Value do
        local data = GetPlayerData()
        if data and Game.FormulaHandler then
            local ok, cost = pcall(function()
                return Game.FormulaHandler.GetInfo(data, "PrestigeCost")
            end)
            local cashThisPrestige = data.NumberValues and data.NumberValues.CashThisPrestige and data.NumberValues.CashThisPrestige.Value
            if ok and cost and cashThisPrestige and cashThisPrestige >= cost then
                notyuri("[AutoPrestige] -> Prestige")
                NetFire("Prestige")
            end
        end
        task.wait(1)
    end
end
local LastSacrifice = 0
local function Func_AutoSacrifice()
    while Toggles.AutoSacrifice.Value do
        local now = tick()
        if now - LastSacrifice > 30 then
            local data = GetPlayerData()
            if data and Game.FormulaHandler then
                local ok, tokens = pcall(function()
                    return Game.FormulaHandler.GetInfo(data, "PrestigeTokens")
                end)
                if ok and tokens and tokens > 0 then
                    LastSacrifice = now
                    notyuri("[AutoSacrifice] -> Sacrifice")
                    NetFire("Sacrifice")
                end
            end
        end
        task.wait(5)
    end
end
local LastRejoin = 0
local TP_RANGE = 30
local function Func_AutoTP()
    while Toggles.AutoTP.Value do
        local char = GetCharacter()
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local origin  = hrp.Position
            local bestPos = nil
            local bestDist= math.huge
            for _, partMap in pairs(ESPHighlights) do
                for anchor, _ in pairs(partMap) do
                    if anchor and anchor.Parent then
                        local d = (anchor.Position - origin).Magnitude
                        if d < bestDist then
                            bestDist = d
                            bestPos  = anchor.Position
                        end
                    end
                end
            end
            if bestPos and bestDist > TP_RANGE then
                SafeTeleport(CFrame.new(bestPos + Vector3.new(0, 4, 0)))
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoAim()
    local Camera = workspace.CurrentCamera
    while Toggles.AutoAim.Value do
        local char = GetCharacter()
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and Camera then
            local origin  = hrp.Position
            local bestPos = nil
            local bestDist= math.huge
            for _, partMap in pairs(ESPHighlights) do
                for anchor, _ in pairs(partMap) do
                    if anchor and anchor.Parent then
                        local d = (anchor.Position - origin).Magnitude
                        if d < bestDist then
                            bestDist = d
                            bestPos  = anchor.Position
                        end
                    end
                end
            end
            if bestPos then
                local camPos = Camera.CFrame.Position
                Camera.CFrame = CFrame.lookAt(camPos, bestPos)
            end
        end
        task.wait()
    end
end
local function Func_AutoRejoin()
    while Toggles.AutoRejoin.Value do
        local now = tick()
        if now - LastRejoin > 60 then
            LastRejoin = now
            notyuri("[AutoRejoin] -> Rejoin")
            NetFire("Rejoin")
        end
        task.wait(10)
    end
end
local Window = Library:CreateWindow({
    Title               = "Yuri",
    Center              = true,
    AutoShow            = true,
    Resizable           = true,
    ShowCustomCursor    = false,
    UnlockMouseWhileOpen= false,
    NotifySide          = "Left",
    TabPadding          = 8,
    MenuFadeTime        = 0.2,
})
AddInfo(Window)
local Tabs = {
    Main   = Window:AddTab("Main"),
    ESP    = Window:AddTab("ESP"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left  = { Autofarm = Tabs.Main:AddLeftTabbox()  },
        Right = { Autofarm = Tabs.Main:AddRightTabbox() },
    },
}
local TB_Tabs = {
    Autofarm  = { T1 = TB.Main.Left.Autofarm:AddTab("Autofarm")  },
    Autofarm2 = { T1 = TB.Main.Right.Autofarm:AddTab("Config")    },
}
local GB = {
    Player = {
        Left  = {
            General = Tabs.Player:AddLeftGroupbox("General"),
            Server  = Tabs.Player:AddLeftGroupbox("Server"),
        },
        Right = {
            Game = Tabs.Player:AddRightGroupbox("Game"),
        },
    },
    ESP = {
        Left  = Tabs.ESP:AddLeftGroupbox("Ore ESP"),
        Right = Tabs.ESP:AddRightGroupbox("Ore Select"),
    },
}
local oreOptionList  = BuildOreOptionList()
local rarityList     = BuildRarityList()
local recipeOptionList = BuildRecipeOptionList()
GB.ESP.Left:AddToggle("ESPOreToggle", { Text = "Ore ESP", Default = false })
GB.ESP.Left:AddSlider("ESPFillTransparency", {
    Text     = "Fill Transparency",
    Default  = 40,
    Min      = 0,
    Max      = 100,
    Rounding = 0,
    Compact  = true,
})
GB.ESP.Left:AddSlider("ESPRange", {
    Text     = "ESP Range (studs)",
    Default  = 3000,
    Min      = 100,
    Max      = 5000,
    Rounding = 0,
    Compact  = true,
})
GB.ESP.Left:AddSlider("ESPRefreshInterval", {
    Text     = "Refresh Interval (s)",
    Default  = 1,
    Min      = 0.1,
    Max      = 10,
    Rounding = 1,
    Compact  = true,
})
GB.ESP.Left:AddLabel("Fill Color"):AddColorPicker("ESPFillColor", {
    Title   = "ESP Fill Color",
    Default = Color3.new(1, 1, 1),
})
GB.ESP.Left:AddLabel("Outline Color"):AddColorPicker("ESPOutlineColor", {
    Title   = "ESP Outline Color",
    Default = Color3.new(0, 0, 0),
})
GB.ESP.Left:AddButton({
    Text = "Teleport to Nearest Ore",
    Func = function()
        local char = GetCharacter()
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local origin  = hrp.Position
        local bestPos = nil
        local bestDist= math.huge
        for _, partMap in pairs(ESPHighlights) do
            for anchor, _ in pairs(partMap) do
                if anchor and anchor.Parent then
                    local d = (anchor.Position - origin).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestPos  = anchor.Position
                    end
                end
            end
        end
        if bestPos then
            SafeTeleport(CFrame.new(bestPos + Vector3.new(0, 4, 0)))
            notyuri("[ESP] Teleported to nearest ore at", tostring(bestPos))
        else
            Library:Notify("No targets visible.", 3)
        end
    end,
})
GB.ESP.Left:AddToggle("AutoTP", { Text = "Auto Teleport", Default = false })
Toggles.AutoTP:OnChanged(function(v) Thread("AutoTP", Func_AutoTP, v) end)
GB.ESP.Left:AddToggle("AutoAim", { Text = "Auto Aim", Default = false })
Toggles.AutoAim:OnChanged(function(v) Thread("AutoAim", Func_AutoAim, v) end)
GB.ESP.Right:AddInput("TPRange", {
    Text = "TP Range",
    Default = tostring(TP_RANGE),
    Placeholder = "Radius",
    Callback = function(Value)
        local number = tonumber(Value)
        if number then
            TP_RANGE = number
        end
    end
})
GB.ESP.Left:AddButton({
    Text = "Ascend Layer",
    Func = function()
        local char = GetCharacter()
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local pos = hrp.Position
        SafeTeleport(CFrame.new(pos.X, pos.Y + 1000, pos.Z))
        notyuri("[TP] Teleported up 1000 studs from", tostring(pos))
    end,
})
GB.ESP.Left:AddButton({
    Text = "Descend Layer",
    Func = function()
        local char = GetCharacter()
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local pos = hrp.Position
        SafeTeleport(CFrame.new(pos.X, pos.Y - 1000, pos.Z))
        notyuri("[TP] Teleported down 1000 studs from", tostring(pos))
    end,
})
GB.ESP.Right:AddDropdown("RaritySelected", {
    Text       = "Rarities List",
    Values     = rarityList,
    Default    = {},
    Multi      = true,
    Searchable = false,
})
GB.ESP.Right:AddDropdown("OreSelected", {
    Text       = "Ores List",
    Values     = oreOptionList,
    Default    = {},
    Multi      = true,
    Searchable = true,
})
GetRecipeSelection = AddMultiDropdown(GB.ESP.Right, "RecipeSelected", {
    Text   = "Crafting Recipes",
    Values = recipeOptionList,
})
GetExcludeOreSelection = AddMultiDropdown(GB.ESP.Right, "ExcludeOreSelected", {
    Text   = "Exclude Ores",
    Values = oreOptionList,
    label  = GetLabelToId(),
})
Toggles.ESPOreToggle:OnChanged(function(v)
    if v then
        StartESPScanLoop()
        StartESPDistanceUpdater()
    else
        Thread("ESPScan", nil, false)
        Thread("ESPDist", nil, false)
        clearESPAnchors()
        ChunkData   = nil
        WorldOffset = nil
    end
end)
Options.OreSelected:OnChanged(function()
    if Toggles.ESPOreToggle.Value then
        if not ChunkData then
            ChunkData = GetChunkData()
        end
        RefreshESP()
    end
end)
Options.RaritySelected:OnChanged(function()
    if Toggles.ESPOreToggle.Value then
        if not ChunkData then
            ChunkData = GetChunkData()
        end
        RefreshESP()
    end
end)
Options.RecipeSelected:OnChanged(function()
    if Toggles.ESPOreToggle.Value then
        if not ChunkData then
            ChunkData = GetChunkData()
        end
        RefreshESP()
    end
end)
Options.ExcludeOreSelected:OnChanged(function()
    if Toggles.ESPOreToggle.Value then
        if not ChunkData then
            ChunkData = GetChunkData()
        end
        RefreshESP()
    end
end)
Options.ESPFillTransparency:OnChanged(function()
    local t = (Options.ESPFillTransparency.Value or 40) / 100
    for _, partMap in pairs(ESPHighlights) do
        for _, entry in pairs(partMap) do
            if entry.hl then entry.hl.FillTransparency = t end
        end
    end
end)
Options.ESPRange:OnChanged(function()
    if Toggles.ESPOreToggle and Toggles.ESPOreToggle.Value then
        if not ChunkData then
            ChunkData = GetChunkData()
        end
        RefreshESP()
    end
end)
Options.ESPFillColor:OnChanged(function()
    local c = Options.ESPFillColor.Value
    for _, partMap in pairs(ESPHighlights) do
        for _, entry in pairs(partMap) do
            if entry.hl then entry.hl.FillColor = c end
            if entry.nameLbl then entry.nameLbl.TextColor3 = c end
            if entry.distLbl then entry.distLbl.TextColor3 = c end
        end
    end
end)
Options.ESPOutlineColor:OnChanged(function()
    local c = Options.ESPOutlineColor.Value
    for _, partMap in pairs(ESPHighlights) do
        for _, entry in pairs(partMap) do
            if entry.hl then entry.hl.OutlineColor = c end
        end
    end
end)
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS",  Text = "WalkSpeed", Default = 16,  Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP",  Text = "JumpPower", Default = 50,  Min = 0,  Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH",  Text = "HipHeight", Default = 2,   Min = 0,  Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip",        { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
GB.Player.Left.General:AddToggle("Disable3DRender",{ Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV",  Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", { Text = "Anti AFK", Default = true, Disabled = not Support.Connections })
GB.Player.Left.Server:AddToggle("AntiKick",         { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect",    { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused" })
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
    local ok, raw = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    if not ok then return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or not data or not data.data then return end
    for _, server in ipairs(data.data) do
        if server.id ~= game.JobId and server.playing and server.maxPlayers and server.playing < server.maxPlayers then
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr) end)
            return
        end
    end
end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP",  { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog",      { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell",      { Text = "Auto Sell",          Default = false })
TB_Tabs.Autofarm2.T1:AddSlider("SellThresholdValue", { Text = "Sell Threshold", Default = 100, Min = 1, Max = 100, Rounding = 0 })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy",{ Text = "Auto Buy",           Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPrestige",  { Text = "Auto Prestige",      Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSacrifice", { Text = "Auto Sacrifice",     Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade",{ Text = "Auto Upgrade",   Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyItems", { Text = "Auto Buy Items", Values = { "Pickaxe", "Backpack", "Explosives", "Luck", "Speed", "Jump" }, Default = {}, Multi = true })
TB_Tabs.Autofarm2.T1:AddDropdown("SelectedUpgrade", { Text = "Upgrade List",            Values = UpgradeList(),   Default = {},  Multi = true })
Toggles.AntiKnockback:OnChanged(function(state) Thread("AntiKnockback", Func_AntiKnockback, state) end)
Toggles.TPW:OnChanged(function(v)
    TPW_S:SetVisible(TPW_T.Value)
    Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v) Thread("Noclip", FuncNoclip, v) end)
Connections.Player_General = RunService.Stepped:Connect(function()
    local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if Hum then
        if Toggles.WS.Value  then Hum.WalkSpeed = Options.WSValue.Value end
        if Toggles.JP.Value  then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
        if Toggles.HH.Value  then Hum.HipHeight = Options.HHValue.Value end
    end
    workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
    if Toggles.FOV.Value  then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
    if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
Toggles.AutoBuy:OnChanged(function(v)         Thread("AutoBuy",        Func_AutoBuy,        v) end)
Toggles.AutoSell:OnChanged(function(v)        Thread("AutoSell",       Func_AutoSell,       v) end)
Toggles.AutoUpgrade:OnChanged(function(v)  Thread("AutoUpgrade", Func_AutoUpgrade, v) end)
Toggles.AutoPrestige:OnChanged(function(v)    Thread("AutoPrestige",   Func_AutoPrestige,   v) end)
Toggles.AutoSacrifice:OnChanged(function(v)   Thread("AutoSacrifice",  Func_AutoSacrifice,  v) end)
task.spawn(function()
    while task.wait() do
        if Toggles.Fullbright.Value then
            Lighting.Brightness    = 2
            Lighting.ClockTime     = 14
            Lighting.GlobalShadows = false
        elseif Toggles.OverrideTime.Value then
            Lighting.ClockTime = Options.OverrideTimeValue.Value
        end
        if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
        if Library.Unloaded then break end
    end
end)
Options.LimitFPSValue:OnChanged(function()
    if FPS_T.Value then setfpscap(FPS_S.Value) end
end)
Toggles.LimitFPS:OnChanged(function(v)
    FPS_S:SetVisible(FPS_T.Value)
    if not v then setfpscap(999) end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state) ApplyFPSBoost(state) end)
Toggles.AutoReconnect:OnChanged(function(state) if state then Func_AutoReconnect() end end)
Toggles.NoGameplayPaused:OnChanged(function(state)
    Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP and Toggles.InstantPP.Value then prompt.HoldDuration = 0 end
end)
local function RunAntiAFK()
    local GC = getconnections or get_signal_cons
    if GC then
        for _, v in pairs(GC(Players.LocalPlayer.Idled)) do
            if v["Disable"]    then v["Disable"](v)
            elseif v["Disconnect"] then v["Disconnect"](v) end
        end
    else
        local VU = cloneref(game:GetService("VirtualUser"))
        Players.LocalPlayer.Idled:Connect(function()
            VU:CaptureController()
            VU:ClickButton2(Vector2.new())
        end)
    end
end
Toggles.AntiAFK:OnChanged(function(state) if state then RunAntiAFK() end end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", { Text = "Auto Show UI", Default = true })
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = false,
    Callback = function(Value) Library.ShowCustomCursor = Value end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(Value) Library:SetNotifySide(Value) end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values   = { "50%","75%","100%","125%","150%","175%","200%" },
    Default  = "100%",
    Text     = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%","")
        Library:SetDPIScale(tonumber(Value))
    end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
    getgenv().ayasemiyatongekissazumirisa = false
    Shared.Farm = false
    Thread("AutoAim", nil, false)
    Thread("ESPScan", nil, false)
    Thread("ESPDist", nil, false)
    clearESPAnchors()
    pcall(function() ESPFolder:Destroy() end)
    Cleanup(Connections)
    Cleanup(Flags)
    Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/MinersWorld")
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
