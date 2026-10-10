if getgenv().ayasemiyatongekissazumirisa then
    warn("yuri")
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
local Players    = Services.Players
local Plr        = Players.LocalPlayer
local Char       = Plr.Character or Plr.CharacterAdded:Wait()
local PGui       = Plr:WaitForChild("PlayerGui")
local Lighting   = game:GetService("Lighting")
local RS         = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService  = Services.HttpService
local GuiService   = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace  = Services.MarketplaceService
local UIS          = Services.UserInputService
local VirtualUser  = Services.VirtualUser
local v, Asset = pcall(function()
    return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
    assetName = Asset.Name
end
local Support = {
    Webhook          = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard        = (typeof(setclipboard) == "function"),
    FileIO           = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport  = (typeof(queue_on_teleport) == "function"),
    Connections      = (typeof(getconnections) == "function"),
    FPS              = (typeof(setfpscap) == "function"),
    Proximity        = (typeof(fireproximityprompt) == "function"),
}
local executorName        = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors    = {"xeno"}
local isLimitedExecutor   = executorDisplayName:lower():find("xeno") ~= nil
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
local function yuri()
end
local repo         = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor          = true
Library.NotifySide                = "Left"
local function AddInfo(Window)
    local InfoTab   = Window:AddTab("Info")
    local InfoLeft  = InfoTab:AddLeftGroupbox("Information")
    local statusText = isLimitedExecutor
        and "<font color='#FFA500'>Semi-Working</font>"
        or  "<font color='#00FF00'>Working</font>"
    local extraNote = isLimitedExecutor
        and "<b>NOTE:</b> May experiencing bugs for some features!"
        or  "All features should works properly!"
    InfoLeft:AddLabel(
        "<b>Executor:</b> " .. executorDisplayName ..
        "\n<b>Status:</b> " .. statusText ..
        "\n" .. extraNote,
        true
    )
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
                        Url    = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"]       = "https://discord.com",
                        },
                        Body = HttpService:JSONEncode({
                            cmd  = "INVITE_BROWSER",
                            args = { code = inviteCode },
                            nonce = HttpService:GenerateGUID(false),
                        }),
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
local Connections = {}
local Shared      = { Farm = false }
local Script_Start_Time = os.time()
local function GetSessionTime()
    local seconds = os.time() - Script_Start_Time
    local hours   = math.floor(seconds / 3600)
    local mins    = math.floor((seconds % 3600) / 60)
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
    local args   = {...}
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
local Remotes = {}
local Modules = {}
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
local Flags = {}
function Thread(featurePath, featureFunc, isEnabled, ...)
    local pathParts    = featurePath:split(".")
    local currentTable = Flags
    for i = 1, #pathParts - 1 do
        local part = pathParts[i]
        if not currentTable[part] then currentTable[part] = {} end
        currentTable = currentTable[part]
    end
    local flagKey     = pathParts[#pathParts]
    local activeThread = currentTable[flagKey]
    if isEnabled then
        if not activeThread or coroutine.status(activeThread) == "dead" then
            local newThread = task.spawn(featureFunc, ...)
            currentTable[flagKey] = newThread
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
        local success, loopErr = pcall(func)
        if not success then
            Library:Notify("Error in [" .. name .. "]: " .. tostring(loopErr), 10)
            warn("Error in [" .. name .. "]: " .. tostring(loopErr))
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
        Text    = Config.Text,
        Default = Config.DefaultToggle or false,
    })
    local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
        Text     = Config.Text,
        Default  = Config.Default,
        Min      = Config.Min,
        Max      = Config.Max,
        Rounding = Config.Rounding or 0,
        Compact  = true,
        Visible  = false,
    })
    Toggle:OnChanged(function()
        Slider:SetVisible(Toggle.Value)
    end)
    return Toggle, Slider
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
                Services.VirtualInputManager:SendKeyEvent(true,  key, false, game); task.wait(0.03)
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
        local hrp  = Char and Char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        if hrp and part and part:IsA("BasePart") then
            hrp.CFrame = part.CFrame * CFrame.new(0, 0, -3)
            task.wait(.175)
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
local Window = Library:CreateWindow({
    Title                = "Yuri",
    Center               = true,
    AutoShow             = true,
    Resizable            = true,
    ShowCustomCursor     = false,
    UnlockMouseWhileOpen = false,
    NotifySide           = "Left",
    TabPadding           = 8,
    MenuFadeTime         = 0.2,
})
AddInfo(Window)
local Tabs = {
    Main   = Window:AddTab("Main"),
    Character  = Window:AddTab("Character"),
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Autofarm = Tabs.Main:AddLeftTabbox(),
        },
        Right = {
            MiscAuto = Tabs.Main:AddRightTabbox(),
        },
    },
}
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", { Text = "Auto Show UI", Default = true })
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = false,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values   = {"Left", "Right"},
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values   = {"50%", "75%", "100%", "125%", "150%", "175%", "200%"},
    Default  = "100%",
    Text     = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        Library:SetDPIScale(tonumber(Value))
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
local client               = require(RS.Data.DataService).client
local CharactersInfo       = require(RS.Modules.Shared.CharactersInfo)
local MutationInfo         = require(RS.Modules.Shared.MutationInfo)
local UpgradesInfo         = require(RS.Modules.Shared.UpgradesInfo)
local PlacementHelper      = require(RS.Modules.Shared.PlacementHelper)
local PlacementConfig      = require(RS.Modules.Shared.PlacementConfig)
local CharacterLevelHelper = require(RS.Modules.Shared.CharacterLevelHelper)
local CharacterAdditional  = require(RS.Modules.CharacterAdditional)
local PickupCharacter = RS.Remotes.Characters.PickupCharacter
local PlaceCharacter  = RS.Remotes.Characters.PlaceCharacter
local Upgrade         = RS.Remotes.Upgrade
local TraitRequest    = RS.Remotes.Trait.Request
local SetFlexState    = RS.Remotes.Characters.SetFlexState
local Shapes          = RS.Assets.Shapes
local function getPlayerBase()
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return nil end
    for _, v in pairs(Plots:GetChildren()) do
        if v:GetAttribute("Owner") == Plr.Name then return v end
    end
end
local function isCharacterTool(name)
    for _, chars in pairs(CharactersInfo.Characters) do
        if chars[name] then return true end
    end
    return false
end
local function getOccupiedMap(base, gridMap)
    local occupied = {}
    for _, container in ipairs({
        base:FindFirstChild("Characters"),
        base:FindFirstChild("Fighters"),
        base:FindFirstChild("Builds"),
    }) do
        if container then
            for _, model in ipairs(container:GetChildren()) do
                if not model:IsA("Model") then continue end
                local Shape = model:FindFirstChild("Shape")
                if Shape then
                    for _, part in ipairs(PlacementHelper.GetShapeParts(Shape)) do
                        local cell = PlacementHelper.GetContainingCellForPart(part, gridMap)
                        if cell then occupied[cell.Name] = model end
                    end
                end
                local cellsAttr = model:GetAttribute("Cells")
                if cellsAttr and cellsAttr ~= "" then
                    for cn in cellsAttr:gmatch("[^,]+") do
                        occupied[cn] = model
                    end
                end
            end
        end
    end
    return occupied
end
local function snapAndGetCells(shapeTemplate, targetCell, gridMap)
    local clone = shapeTemplate:Clone()
    clone.Parent = workspace
    local ok = PlacementHelper.SnapShapeToCell(clone, targetCell, PlacementConfig.YOffset)
    if not ok then
        clone:Destroy()
        return nil, nil
    end
    local shapeCFrame = clone:GetPivot()
    local cells = {}
    local valid = true
    for _, part in ipairs(PlacementHelper.GetShapeParts(clone)) do
        local cell = PlacementHelper.GetContainingCellForPart(part, gridMap)
        if not cell then valid = false; break end
        cells[cell.Name] = cell
    end
    clone:Destroy()
    if not valid then return nil, nil end
    return shapeCFrame, cells
end
local function buildPosMap(gridMap)
    local posMap = {}
    for cn, cell in pairs(gridMap) do
        local key = string.format("%.2f_%.2f", cell.Position.X, cell.Position.Z)
        posMap[key] = cn
    end
    return posMap
end
local function scorePlacement(shapeCells, occupied, gridMap, posMap)
    local cellSize = 3
    for _, c in pairs(gridMap) do
        cellSize = math.max(c.Size.X, c.Size.Z)
        break
    end
    local score = 0
    local offsets = {
        Vector3.new(cellSize, 0, 0),
        Vector3.new(-cellSize, 0, 0),
        Vector3.new(0, 0, cellSize),
        Vector3.new(0, 0, -cellSize),
    }
    for cn, cell in pairs(shapeCells) do
        for _, offset in ipairs(offsets) do
            local nPos   = cell.Position + offset
            local nKey   = string.format("%.2f_%.2f", nPos.X, nPos.Z)
            local nCellName = posMap[nKey]
            if not nCellName then
                score = score + 1       
            elseif not shapeCells[nCellName] then
                if occupied[nCellName] then
                    score = score + 2   
                end
            end
        end
    end
    return score
end
local charList = {}
for _, chars in pairs(CharactersInfo.Characters) do
    for name in pairs(chars) do
        table.insert(charList, name)
    end
end
table.sort(charList)
table.insert(charList, 1, "Any")
local mutationList = {"None"}
for name in pairs(MutationInfo.Mutations) do
    table.insert(mutationList, name)
end
table.sort(mutationList)
table.insert(mutationList, 1, "Any")
local rarityList = {}
for rarity in pairs(CharactersInfo.Characters) do
    table.insert(rarityList, rarity)
end
table.sort(rarityList)
local AutofarmTab   = TB.Main.Left.Autofarm:AddTab("Autofarm")
local ConfigTab   = TB.Main.Left.Autofarm:AddTab("Config")
AutofarmTab:AddToggle("AutoBuild", { Text = "Auto Build", Default = false })
local function getBaseDamage(name)
    for _, chars in pairs(CharactersInfo.Characters) do
        local info = chars[name]
        if info then
            local dmg      = tonumber(info.Damage) or 0
            local cooldown = math.max(tonumber(info.Cooldown) or 1, 0.01)
            local aType    = info.AttackType
            if aType == "Barrage" or aType == "Continuous" then
                local duration = tonumber(info.Duration) or 1
                local tickRate = math.max(tonumber(info.TickRate) or 1, 0.001)
                dmg = dmg * (duration / tickRate)
            end
            return dmg / cooldown
        end
    end
    return 0
end
local function getEffectiveDamage(nameOrModel, levelObj)
    local name = type(nameOrModel) == "string" and nameOrModel or (nameOrModel:GetAttribute("CharacterName") or nameOrModel.Name)
    local base = getBaseDamage(name)
    local level = CharacterLevelHelper.GetLevel(levelObj or nameOrModel)
    return CharacterLevelHelper.GetDamage(base, level)
end
local function getCharRarity(name)
    for rarity, chars in pairs(CharactersInfo.Characters) do
        if chars[name] then return rarity end
    end
    return nil
end
local function equipTool(tool)
    local humanoid = Char and Char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:EquipTool(tool) end
    task.wait(0.1)
end
Toggles.AutoBuild:OnChanged(function(v)
    Thread("AutoBuild", SafeLoop("AutoBuild", function()
        while true do
            local base = getPlayerBase()
            if not base then
                yuri("[AutoBuild] No player base found")
                task.wait(1)
                continue
            end
            if base:GetAttribute("WaveStarted") == true then
                yuri("[AutoBuild] Wave is active, waiting...")
                task.wait(1)
                continue
            end
            local gridLevel = client:get("GridLevel")
            yuri("[AutoBuild] GridLevel =", tostring(gridLevel))
            local Grid = base:FindFirstChild("Grid")
            if not Grid then yuri("[AutoBuild] Grid not found in base") task.wait(1) continue end
            local levelGrid = Grid:FindFirstChild("Level" .. tostring(gridLevel))
            if not levelGrid then
                yuri("[AutoBuild] levelGrid 'Level" .. tostring(gridLevel) .. "' not found")
                task.wait(1)
                continue
            end
            local gridMap  = PlacementHelper.BuildGridMap(levelGrid)
            local occupied = getOccupiedMap(base, gridMap)
            local gridCount, occupiedCount = 0, 0
            for _ in pairs(gridMap) do gridCount = gridCount + 1 end
            for _ in pairs(occupied) do occupiedCount = occupiedCount + 1 end
            yuri("[AutoBuild] gridMap cells:", gridCount, "| occupied:", occupiedCount)
            local charTools = {}
            for _, tool in ipairs(Plr.Backpack:GetChildren()) do
                if tool:IsA("Tool") and isCharacterTool(tool.Name) then
                    table.insert(charTools, tool)
                end
            end
            local equippedTool = Char and Char:FindFirstChildOfClass("Tool")
            if equippedTool and isCharacterTool(equippedTool.Name) then
                table.insert(charTools, equippedTool)
            end
            table.sort(charTools, function(a, b)
                return getEffectiveDamage(a.Name, a) > getEffectiveDamage(b.Name, b)
            end)
            yuri("[AutoBuild] Char tools in backpack:", #charTools)
            if #charTools == 0 then
                yuri("[AutoBuild] No matching char tools — idling")
                task.wait(2)
                continue
            end
            local currentGridDmg = 0
            local Characters = base:FindFirstChild("Fighters")
            if Characters then
                for _, model in ipairs(Characters:GetChildren()) do
                    if model:IsA("Model") then
                        local placedName = model:GetAttribute("CharacterName") or model.Name
                        currentGridDmg = currentGridDmg + getEffectiveDamage(placedName, model)
                    end
                end
            end
            yuri("[AutoBuild] Current grid damage:", currentGridDmg)
            if occupiedCount < gridCount then
                local didPlace = false
                local posMap   = buildPosMap(gridMap)
                for i, tool in ipairs(charTools) do
                    if not tool or not tool.Parent then continue end
                    local toolName  = tool.Name
                    local shapeName = PlacementHelper.GetShapeName(Shapes, toolName)
                    yuri("[AutoBuild] (merge pass) [" .. i .. "/" .. #charTools .. "]", toolName, "| shapeName =", tostring(shapeName))
                    if not shapeName then continue end
                    local shapeTemplate = Shapes:FindFirstChild(shapeName)
                    if not shapeTemplate then continue end
                    for cellName, occModel in pairs(occupied) do
                        if not CharacterLevelHelper.CanMerge(occModel, tool) then continue end
                        yuri("[AutoBuild] Merge candidate:", cellName, occModel.Name)
                        local cell = gridMap[cellName]
                        if not cell then continue end
                        local shapeCFrame, cells = snapAndGetCells(shapeTemplate, cell, gridMap)
                        if not shapeCFrame then continue end
                        local allSame = true
                        for cn in pairs(cells) do
                            if occupied[cn] ~= occModel then allSame = false; break end
                        end
                        if allSame then
                            yuri("[AutoBuild] Merging at", cellName, "- equipping", toolName)
                            equipTool(tool)
                            PlaceCharacter:FireServer({
                                CharacterName   = toolName,
                                ShapeName       = shapeName,
                                HoveredCellName = cellName,
                                ShapeCFrame     = shapeCFrame,
                            })
                            didPlace = true
                            break
                        end
                    end
                    if didPlace then break end
                end
                if not didPlace then
                    for i, tool in ipairs(charTools) do
                        if not tool or not tool.Parent then continue end
                        local toolName  = tool.Name
                        local shapeName = PlacementHelper.GetShapeName(Shapes, toolName)
                        yuri("[AutoBuild] (place pass) [" .. i .. "/" .. #charTools .. "]", toolName, "| shapeName =", tostring(shapeName))
                        if not shapeName then continue end
                        local shapeTemplate = Shapes:FindFirstChild(shapeName)
                        yuri("[AutoBuild] shapeTemplate found:", tostring(shapeTemplate ~= nil))
                        if not shapeTemplate then continue end
                        local bestCellName, bestCFrame, bestScore = nil, nil, -1
                        for cellName, cell in pairs(gridMap) do
                            local shapeCFrame, cells = snapAndGetCells(shapeTemplate, cell, gridMap)
                            if not shapeCFrame then continue end
                            local allFree = true
                            for cn in pairs(cells) do
                                if occupied[cn] then allFree = false; break end
                            end
                            if not allFree then continue end
                            local s = scorePlacement(cells, occupied, gridMap, posMap)
                            if s > bestScore then
                                bestScore    = s
                                bestCellName = cellName
                                bestCFrame   = shapeCFrame
                            end
                        end
                        if bestCellName then
                            yuri("[AutoBuild] Placing (score:", bestScore, ") at", bestCellName, "- equipping", toolName)
                            equipTool(tool)
                            PlaceCharacter:FireServer({
                                CharacterName   = toolName,
                                ShapeName       = shapeName,
                                HoveredCellName = bestCellName,
                                ShapeCFrame     = bestCFrame,
                            })
                            didPlace = true
                            break
                        end
                        yuri("[AutoBuild] No valid cell found for", toolName)
                    end
                end
                if not didPlace then
                    yuri("[AutoBuild] Nothing to do — idling")
                    task.wait(2)
                end
                task.wait(0.5)
                continue
            end
            yuri("[AutoBuild] Grid full, nothing to place — idling")
            task.wait(2)
        end
    end), v)
end)
AutofarmTab:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
AutofarmTab:AddDropdown("UpgradeType", {
    Text    = "Upgrade Type",
    Values  = {"Luck", "Cash", "Grid"},
    Default = {},
    Multi   = true,
})
Toggles.AutoUpgrade:OnChanged(function(v)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", function()
        while true do
            for upgradeType, active in pairs(Options.UpgradeType.Value) do
                if not active then continue end
                local level     = client:get({"Upgrades", upgradeType}) or 1
                local maxStored = UpgradesInfo.Upgrades.MaxUpgrades[upgradeType]
                local maxLevel  = (upgradeType == "Grid") and (maxStored + 1) or maxStored
                local isMax     = maxLevel and (maxLevel <= level)
                if not isMax then
                    local price = UpgradesInfo.GetPrice(upgradeType, level)
                    local cash  = client:get("Cash") or 0
                    if cash >= price then
                        Upgrade:FireServer("Cash", upgradeType)
                    end
                end
            end
            task.wait(0.5)
        end
    end), v)
end)
AutofarmTab:AddToggle("AutoBuy", { Text = "Auto Roll", Default = false })
ConfigTab:AddDropdown("AutoBuyChar", {
    Text       = "Character to buy",
    Values     = charList,
    Default    = {},
    Multi      = true,
    Searchable = true,
})
ConfigTab:AddDropdown("AutoBuyMutation", {
    Text    = "Mutation to buy",
    Values  = mutationList,
    Default = {},
    Multi   = true,
})
AutofarmTab:AddToggle("AutoBuyIndex", { Text = "Buy Unindexed", Default = false })
AutofarmTab:AddToggle("AutoBuyRarity", { Text = "Buy Rarity", Default = false })
AutofarmTab:AddDropdown("AutoBuyRarity", {
    Text    = "Stop Rarity",
    Values  = rarityList,
    Default = {},
    Multi   = true,
})
Toggles.AutoBuy:OnChanged(function(v)
    Thread("AutoBuy", SafeLoop("AutoBuy", function()
        while true do
            local base = getPlayerBase()
            if not base then
                yuri("[AutoBuy] No player base found")
                task.wait(1)
                continue
            end
            local CharFil  = Options.AutoBuyChar.Value     
            local MutFil   = Options.AutoBuyMutation.Value  
            local RarityFil = Options.AutoBuyRarity.Value
            local BuyIndex   = Toggles.AutoBuyIndex.Value
            local BuyRarity  = Toggles.AutoBuyRarity.Value
            local anyCharSel = false
            for _, v in pairs(CharFil) do if v then anyCharSel = true; break end end
            local anyMutSel = false
            for _, v in pairs(MutFil) do if v then anyMutSel = true; break end end
            local anyRaritySel = false
            for _, v in pairs(RarityFil) do if v then anyRaritySel = true; break end end
            yuri("[AutoBuy] Char filter selected:", tostring(anyCharSel), "| Mut filter selected:", tostring(anyMutSel), "| StopForUnindexed:", tostring(BuyIndex), "| BuyRarity:", tostring(BuyRarity))
            local Characters = base:FindFirstChild("Characters")
            local hasValidTarget   = false
            local hasCantAfford    = false
            if not Characters then
                yuri("[AutoBuy] No Characters container in base")
            else
                local modelCount = #Characters:GetChildren()
                yuri("[AutoBuy] Characters in base:", modelCount)
                for _, model in ipairs(Characters:GetChildren()) do
                    if not model:IsA("Model") then continue end
                    local hrp    = model:FindFirstChild("HumanoidRootPart")
                    local prompt = hrp and hrp:FindFirstChild("ProximityPrompt")
                    if not prompt then
                        yuri("[AutoBuy] No prompt on", model.Name)
                        continue
                    end
                    local mutation = model:GetAttribute("Mutation")
                    local mutKey = (mutation == nil or mutation == "") and "None" or mutation
                    local anyFilterActive = anyCharSel or anyMutSel or (BuyRarity and anyRaritySel) or BuyIndex
                    local matchesFilter = not anyFilterActive
                    if not matchesFilter then
                        local charMatch = not anyCharSel or CharFil["Any"] or CharFil[model.Name]
                        local mutMatch  = not anyMutSel  or MutFil["Any"]  or MutFil[mutKey]
                        if charMatch and mutMatch and (anyCharSel or anyMutSel) then matchesFilter = true end
                    end
                    if not matchesFilter and BuyRarity and anyRaritySel then
                        local charRarity = getCharRarity(model.Name)
                        if charRarity and RarityFil[charRarity] then matchesFilter = true end
                    end
                    local alreadyIndexed = false
                    if BuyIndex then
                        local indexData   = client:get("Index") or {}
                        local indexMutKey = (mutation == nil or mutation == "" or mutation == "None") and "Normal" or mutation
                        alreadyIndexed    = table.find(indexData[model.Name] or {}, indexMutKey) ~= nil
                        if not matchesFilter and not alreadyIndexed then matchesFilter = true end
                        yuri("[AutoBuy]", model.Name, "(mut:", tostring(mutation), ") | matchesFilter:", tostring(matchesFilter), "| alreadyIndexed:", tostring(alreadyIndexed), "| indexMutKey:", indexMutKey)
                    else
                        yuri("[AutoBuy]", model.Name, "(mut:", tostring(mutation), ") | matchesFilter:", tostring(matchesFilter))
                    end
                    if not matchesFilter then
                        yuri("[AutoBuy] Skipping", model.Name, "- does not qualify")
                        continue
                    end
                    local basePrice = 0
                    for _, chars in pairs(CharactersInfo.Characters) do
                        local info = chars[model.Name]
                        if info then basePrice = info.Price or 0; break end
                    end
                    local mutInfo    = mutation and mutation ~= "" and MutationInfo.Mutations and MutationInfo.Mutations[mutation]
                    local priceHike  = mutInfo and tonumber(mutInfo.PriceHike) or 1
                    local finalPrice = math.floor(basePrice * priceHike)
                    local cash       = client:get("Cash") or 0
                    yuri("[AutoBuy] Price:", finalPrice, "| Cash:", cash)
                    if cash < finalPrice then
                        yuri("[AutoBuy] Not enough cash for", model.Name)
                        hasValidTarget = true
                        hasCantAfford  = true
                        continue
                    end
                    hasValidTarget = true
                    yuri("[AutoBuy] Buying", model.Name)
                    while model and model.Parent do
                        local curCash = client:get("Cash") or 0
                        if curCash < finalPrice then
                            yuri("[AutoBuy] Can't afford mid-retry, stopping retry for", model.Name)
                            hasCantAfford = true
                            break
                        end
                        FirePP(prompt)
                        task.wait(0.5)
                    end
                    yuri("[AutoBuy] Done retrying", model.Name)
                end
            end
            if hasValidTarget and hasCantAfford then
                yuri("[AutoBuy] Valid target exists but can't afford — waiting")
                task.wait(1)
                continue
            end
            local Roll       = base:FindFirstChild("Roll")
            local RollButton = Roll and Roll:FindFirstChild("RollButton")
            local Button     = RollButton and RollButton:FindFirstChild("Button")
            local rollPrompt = Button and Button:FindFirstChild("RollPrompt")
            if rollPrompt then
                yuri("[AutoBuy] Rolling")
                FirePP(rollPrompt)
            else
                yuri("[AutoBuy] Roll prompt not found (Roll:", tostring(Roll ~= nil), "RollButton:", tostring(RollButton ~= nil), "Button:", tostring(Button ~= nil), ")")
            end
            task.wait()
        end
    end), v)
end)
local MiscTab   = TB.Main.Right.MiscAuto:AddTab("Misc")
MiscTab:AddButton("Sell All", function()
    local prompt = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Shop") and workspace.Map.Shop:FindFirstChild("Sell") and workspace.Map.Shop.Sell:FindFirstChild("speedWagon") and workspace.Map.Shop.Sell.speedWagon:FindFirstChild("Head") and workspace.Map.Shop.Sell.speedWagon.Head:FindFirstChild("ProximityPrompt")
    if prompt then
        FirePP(prompt, true)
    end
    local TalkSell = RS:WaitForChild("Remotes"):WaitForChild("NPCEvents"):WaitForChild("TalkSell")
    TalkSell:FireServer("SellAll")
end)
MiscTab:AddButton("Redeem All Codes", function()
    local Redeem_2 = RS:WaitForChild("Remotes"):WaitForChild("Codes"):WaitForChild("Redeem")
    local codes = {
        "BLEACHPART2!",
        "CRAFTNERF!",
        "SRYFORSHUTDOWN!",
    }
    for _, code in ipairs(codes) do
        local ok, result, msg = pcall(function()
            return Redeem_2:InvokeServer(code)
        end)
        if ok then
            yuri("Redeem " .. code .. ": " .. tostring(result) .. " / " .. tostring(msg))
        else
            yuri("Redeem " .. code .. " error: " .. tostring(result))
        end
        task.wait(0.5)
    end
end)
MiscTab:AddButton("Visual", function()
    local attrs = {
        Cash2x           = true,
        Mutation2x       = true,
        Luck2x           = true,
        _3xFlex_2xLocked = true,
        Speed3x          = true,
        _2xFlex          = true,
        FastRoll         = true,
        Luck10x          = true,
        Drop2x           = true,
        _3xFlex          = true,
        VIP              = true,
    }
    for k, val in pairs(attrs) do
        Plr:SetAttribute(k, val)
    end
end)
MiscTab:AddDivider()
MiscTab:AddToggle("AutoTraitRoll", { Text = "Auto Trait Roll", Default = false })
local InvChar = {}
local ChaList = {}
local function buildTraitRollCharList()
    for k in pairs(InvChar) do InvChar[k] = nil end
    for i in ipairs(ChaList) do ChaList[i] = nil end
    local inv = client:get("Inventory") or {}
    for _, entry in ipairs(inv) do
        local name = tostring(entry.Name or "")
        local id   = tostring(entry.CharacterId or "")
        if name ~= "" and id ~= "" then
            local label = name .. " (" .. id .. ")"
            if not InvChar[label] then
                table.insert(ChaList, label)
                InvChar[label] = id
            end
        end
    end
    table.sort(ChaList)
end
buildTraitRollCharList()
MiscTab:AddDropdown("TraitRollCharId", {
    Text       = "Character",
    Values     = ChaList,
    Default    = ChaList[1] or "",
    Searchable = true,
})
local _invChangedSignal = client:getChangedSignal("Inventory")
local _invRefreshConn = _invChangedSignal:Connect(function()
    yuri("[AutoTraitRoll] Inventory changed, rebuilding character list...")
    buildTraitRollCharList()
    yuri("[AutoTraitRoll] Built " .. #ChaList .. " entries")
    Options.TraitRollCharId:SetValues(ChaList)
end)
MiscTab:AddDropdown("TraitRollRarities", {
    Text    = "Target Rarities",
    Values  = {"Common", "Rare", "Epic", "Legendary", "Mythic", "God", "Secret", "Limited"},
    Default = {},
    Multi   = true,
})
local TraitConn = nil
local traitBusy = false
Toggles.AutoTraitRoll:OnChanged(function(v)
    if TraitConn then
        TraitConn:Disconnect()
        TraitConn = nil
    end
    traitBusy = false
    if not v then return end
    local label  = Options.TraitRollCharId.Value
    local charId = InvChar[label]
    if not charId or charId == "" then
        Toggles.AutoTraitRoll:SetValue(false)
        return
    end
    local localConn
    localConn = TraitRequest.OnClientEvent:Connect(function(p1, p2)
        if localConn ~= TraitConn or not Toggles.AutoTraitRoll.Value then
            localConn:Disconnect()
            if TraitConn == localConn then TraitConn = nil end
            return
        end
        if traitBusy then return end
        if p1 == "Failed" then
            yuri("[AutoTraitRoll] Roll failed — retrying")
            traitBusy = true
            task.wait()
            TraitRequest:FireServer("ConfirmedRoll", { CharacterId = charId })
            traitBusy = false
            return
        end
        if p1 ~= "Rolled" then
            yuri("[AutoTraitRoll] Skipping event p1=", tostring(p1))
            return
        end
        if not p2 or not p2.Rarity then
            yuri("[AutoTraitRoll] p2 invalid, p2=", tostring(p2))
            return
        end
        local targetRarities = Options.TraitRollRarities.Value
        yuri("[AutoTraitRoll] Got:", tostring(p2.Trait), "| Rarity:", tostring(p2.Rarity))
        local rarityLookup = targetRarities[p2.Rarity]
        yuri("[AutoTraitRoll] targetRarities[" .. tostring(p2.Rarity) .. "] =", tostring(rarityLookup), "| type =", type(rarityLookup))
        local allKeys = {}
        for k, val in pairs(targetRarities) do
            table.insert(allKeys, tostring(k) .. "=" .. tostring(val))
        end
        yuri("[AutoTraitRoll] Full targetRarities: {", table.concat(allKeys, ", "), "}")
        if rarityLookup == true then
            yuri("[AutoTraitRoll] MATCH — confirming and stopping")
            localConn:Disconnect()
            TraitConn = nil
            traitBusy = false
            Toggles.AutoTraitRoll:SetValue(false)
        else
            yuri("[AutoTraitRoll] No match — rerolling")
            traitBusy = true
            TraitRequest:FireServer("ConfirmedRoll", { CharacterId = charId })
            traitBusy = false
        end
    end)
    TraitConn = localConn
    TraitRequest:FireServer("ConfirmedRoll", { CharacterId = charId })
end)
MiscTab:AddDivider()
MiscTab:AddToggle("AutoFoodNPC", { Text = "Auto Buhara", Default = false })
local BuharaEventRemote = RS:WaitForChild("Remotes"):WaitForChild("BuharaEvent")
local function findFoodPromptInWorkspace(foodName)
    local MutationStuffs = workspace:FindFirstChild("MutationStuffs")
    if not MutationStuffs then return nil end
    for _, obj in ipairs(MutationStuffs:GetChildren()) do
        if obj.Name == "FoodPickupItem" and obj:GetAttribute("FoodName") == foodName then
            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt")
                or obj:FindFirstChild("ProximityPrompt")
            if prompt then
                return prompt
            end
        end
    end
    return nil
end
local function findBuharaNPCPrompt()
    local MutationStuffs = workspace:FindFirstChild("MutationStuffs")
    if not MutationStuffs then return nil end
    local buharaModel = MutationStuffs:FindFirstChild("Buhara")
    if not buharaModel then return nil end
    local buharaMesh = buharaModel:FindFirstChild("Buhara")
    if not buharaMesh then return nil end
    local attachment = buharaMesh:FindFirstChild("Attachment")
    if not attachment then return nil end
    return attachment:FindFirstChild("ProximityPrompt")
end
Toggles.AutoFoodNPC:OnChanged(function(v)
    Thread("AutoFoodNPC", SafeLoop("AutoFoodNPC", function()
        while true do
            local char = Plr.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum or hum.Health <= 0 then
                task.wait(1)
                continue
            end
            local eventData = BuharaEventRemote.BuharaEventGetData:InvokeServer()
            if not eventData or not eventData.FoodNeeded then
                yuri("[AutoFoodNPC] No active Buhara event or no FoodNeeded data")
                task.wait(3)
                continue
            end
            local carryingFood = char:GetAttribute("CarryingFood")
            if carryingFood then
                yuri("[AutoFoodNPC] Carrying food — delivering to Buhara NPC")
                local buharaPrompt = findBuharaNPCPrompt()
                if buharaPrompt then
                    FirePP(buharaPrompt, true)
                    task.wait(1)
                else
                    yuri("[AutoFoodNPC] Buhara NPC prompt not found in workspace")
                    task.wait(2)
                end
            else
                local targetFood = nil
                for foodName, delivered in pairs(eventData.FoodNeeded) do
                    if not delivered then
                        targetFood = foodName
                        break
                    end
                end
                if not targetFood then
                    yuri("[AutoFoodNPC] All food delivered — event complete")
                    task.wait(3)
                    continue
                end
                yuri("[AutoFoodNPC] Looking for food:", targetFood)
                local foodPrompt = findFoodPromptInWorkspace(targetFood)
                if foodPrompt then
                    yuri("[AutoFoodNPC] Found food prompt, picking up:", targetFood)
                    FirePP(foodPrompt, true)
                    task.wait(1)
                else
                    yuri("[AutoFoodNPC] Food item not found in workspace:", targetFood)
                    task.wait(2)
                end
            end
            task.wait(0.5)
        end
    end), v)
end)
local ServerGroup  = Tabs.Character:AddLeftGroupbox("Server")
local PlayerGroup = Tabs.Character:AddRightGroupbox("Player")
AddSliderToggle({ Group = PlayerGroup, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = PlayerGroup, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = PlayerGroup, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = PlayerGroup, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
PlayerGroup:AddToggle("Noclip2", { Text = "Noclip" })
PlayerGroup:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
PlayerGroup:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = PlayerGroup, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = PlayerGroup, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = PlayerGroup, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = PlayerGroup, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
AddSliderToggle({ Group = PlayerGroup, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
PlayerGroup:AddToggle("Fullbright2", { Text = "Fullbright" })
PlayerGroup:AddToggle("NoFog2", { Text = "No Fog" })
PlayerGroup:AddToggle("InstantPP2", { Text = "Instant Prompt" })
ServerGroup:AddToggle("FPSBoost", { Text = "FPS Boost" })
ServerGroup:AddToggle("AntiAFK2", { Text = "Anti AFK", Default = true })
ServerGroup:AddToggle("AntiKick2", { Text = "Anti Kick (Client)" })
ServerGroup:AddToggle("AutoReconnect2", { Text = "Auto Reconnect" })
ServerGroup:AddToggle("NoGameplayPaused2", { Text = "No Gameplay Paused" })
ServerGroup:AddButton({ Text = "Serverhop", Func = function()
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if not ok or not res or not res.data then
        return
    end
    local currentId = game.JobId
    for _, server in ipairs(res.data) do
        if server.id ~= currentId and server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
            return
        end
    end
end })
ServerGroup:AddButton({ Text = "Rejoin", Func = function()
    local PlaceId = game.PlaceId
    local JobId   = game.JobId
    if #Players:GetPlayers() <= 1 then
        Plr:Kick("\nRejoining...")
        task.wait()
        TeleportService:Teleport(PlaceId, Plr)
    else
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Plr)
    end
end })
ServerGroup:AddToggle("AutoServerhop2", { Text = "Auto Serverhop" })
ServerGroup:AddSlider("AutoHopMins2", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
RunService.Stepped:Connect(function()
    local hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if Toggles.WS.Value then hum.WalkSpeed = Options.WSValue.Value end
        if Toggles.JP.Value then hum.JumpPower = Options.JPValue.Value; hum.UseJumpPower = true end
        if Toggles.HH.Value then hum.HipHeight = Options.HHValue.Value end
    end
    Workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 196
    if Toggles.FOV.Value then Workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
    if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
local function FuncTPW()
    while Toggles.TPW.Value do
        local delta = RunService.Heartbeat:Wait()
        local char = Plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 and hum.MoveDirection.Magnitude > 0 then
            char:TranslateBy(hum.MoveDirection * Options.TPWValue.Value * delta * 10)
        end
    end
end
Toggles.TPW:OnChanged(function(v)
    if v then task.spawn(FuncTPW) end
end)
Toggles.Noclip2:OnChanged(function(v)
    if not v then return end
    task.spawn(function()
        while Toggles.Noclip2.Value do
            RunService.Stepped:Wait()
            local char = Plr.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)
local _knockbackConns = {}
local function ApplyAntiKB(char)
    if not char then return end
    local root = char:WaitForChild("HumanoidRootPart", 10)
    if root then
        local conn = root.ChildAdded:Connect(function(child)
            if not Toggles.AntiKnockback.Value then return end
            if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
                child:Destroy()
            end
        end)
        table.insert(_knockbackConns, conn)
    end
end
Toggles.AntiKnockback:OnChanged(function(state)
    for _, c in ipairs(_knockbackConns) do if c then c:Disconnect() end end
    table.clear(_knockbackConns)
    if not state then return end
    if Plr.Character then ApplyAntiKB(Plr.Character) end
    local charConn = Plr.CharacterAdded:Connect(function(c) ApplyAntiKB(c) end)
    table.insert(_knockbackConns, charConn)
end)
task.spawn(function()
    while true do
        task.wait()
        if Toggles.Fullbright2.Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        elseif Toggles.OverrideTime.Value then
            Lighting.ClockTime = Options.OverrideTimeValue.Value
        end
        if Toggles.NoFog2.Value then Lighting.FogEnd = 9e9 end
        if Library.Unloaded then break end
    end
end)
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
        pcall(function()
            local PlayerScripts = Plr:WaitForChild("PlayerScripts", 5)
            if not PlayerScripts then return end
            local Player = PlayerScripts:FindFirstChild("Player")
            if not Player then return end
            local lagScripts = {
                {"Characters", "Animator"},
                {"Characters", "CashBilboard"},
                {"Characters", "EnemyMotionClient"},
                {"Characters", "CharacterAttack"},
                {"Characters", "KillCharactersClient"},
                {"Misc", "UIGradientPlayer"},
                {"Misc", "ProximityHighlight"},
            }
            for _, path in ipairs(lagScripts) do
                local folder = Player:FindFirstChild(path[1])
                if folder then
                    local ls = folder:FindFirstChild(path[2])
                    if ls then ls.Disabled = true end
                end
            end
        end)
        pcall(function()
            local Debris = workspace:FindFirstChild("Debris")
            if Debris then Debris:Destroy() end
        end)
        pcall(function()
            local Plots = workspace:FindFirstChild("Plots")
            if Plots then
                for _, plot in ipairs(Plots:GetChildren()) do
                    if plot:GetAttribute("Owner") ~= Plr.Name then
                        plot:Destroy()
                    end
                end
            end
        end)
        task.spawn(function()
            for i, v in pairs(workspace:GetDescendants()) do
                if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
                local isFood = v.Name == "FoodPickupItem" or (v.Parent and v.Parent.Name == "FoodPickupItem")
                if not isFood then
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
                end
                if i % 500 == 0 then task.wait() end
            end
        end)
    end)
end
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
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP2 and Toggles.InstantPP2.Value then
        prompt.HoldDuration = 0
    end
end)
Toggles.AntiAFK2:OnChanged(function(state)
    if not state then return end
    local GC = getconnections or get_signal_cons
    if GC then
        for i, v in pairs(GC(Plr.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    else
        Plr.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)
if Toggles.AntiAFK2.Value then Toggles.AntiAFK2:OnChanged(true) end
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not Toggles.AntiKick2.Value then return oldNamecall(self, ...) end
        if getnamecallmethod() == "Kick" and self == Plr then
            return
        end
        return oldNamecall(self, ...)
    end)
end)
local function Func_AutoReconnect2()
    if _G._autoReconnectConn then _G._autoReconnectConn:Disconnect() end
    _G._autoReconnectConn = game:GetService("GuiService").ErrorMessageChanged:Connect(function()
        if not Toggles.AutoReconnect2.Value then return end
        task.delay(2, function()
            pcall(function()
                local overlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if overlay then
                    local errPrompt = overlay.promptOverlay:FindFirstChild("ErrorPrompt")
                    if errPrompt and errPrompt.Visible then
                        task.wait(5)
                        TeleportService:Teleport(game.PlaceId, Plr)
                    end
                end
            end)
        end)
    end)
end
Toggles.AutoReconnect2:OnChanged(function(state)
    if state then Func_AutoReconnect2() end
end)
Toggles.NoGameplayPaused2:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.NoGameplayPaused2.Value do
            pcall(function()
                local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
                if pauseGui then pauseGui:Destroy() end
            end)
            task.wait(1)
        end
    end)
end)
task.spawn(function()
    while true do
        task.wait(60)
        if Toggles.AutoServerhop2 and Toggles.AutoServerhop2.Value then
            local mins = Options.AutoHopMins2.Value
            if mins > 0 then
                task.wait((mins - 1) * 60)
            end
            if Toggles.AutoServerhop2.Value then
                local ok, res = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(
                        "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                    ))
                end)
                if ok and res and res.data then
                    local currentId = game.JobId
                    for _, server in ipairs(res.data) do
                        if server.id ~= currentId and server.playing < server.maxPlayers then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
                            return
                        end
                    end
                end
            end
        end
    end
end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/DefendAnime")
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
end
