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
PlaceId, JobId = game.PlaceId, game.JobId
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
local function yuri()
end
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');
local RS = Services.ReplicatedStorage
local charm = require(RS.Packages.charm)
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
        yuri("Your executor does not support firesignal or getconnections.")
    end
end
local _FS = (_DR and _DR.FireServer)
local Remotes = {
}
local Modules = {
    Packets     = require(RS.Shared.Network.Packets),
    Items       = require(RS.Shared.Items),
    BeltBadge   = require(RS.Shared.Systems.BeltBadge),
    LevelCosts  = require(RS.Shared.Economy.LevelCosts),
    Mutations      = require(RS.Shared.Mutations),
    UpgradeDefs    = require(RS.Shared.Upgrades.UpgradeDefs),
    RebirthRewards = require(RS.Shared.Economy.RebirthRewards),
    CodeDefs       = require(RS.Shared.Economy.CodeDefs),
    ScrapUpgradeDefs = require(RS.Shared.Upgrades.ScrapUpgradeDefs),
    Gamepasses     = require(RS.Shared.Economy.Gamepasses),
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
            yuri("Error in ["..name.."]: "..tostring(err))
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
local function CreateSwitchGroup(tab, id, displayName, tableSource)
    local toggle = tab:AddToggle("Auto"..id, { Text = "Auto Switch "..displayName, Default = false })
    toggle:OnChanged(function(state)
        if not state then
            Shared.LastSwitch[id] = ""
        end
    end)
    local listToUse = (id == "Title") and CombinedTitleList or tableSource
    tab:AddDropdown(id.."_BossHP", { Text = displayName.." [Boss HP%]", Values = listToUse, AllowNull = true, Searchable = true })
    tab:AddSlider(id.."_BossHPAmt", { Text = "Change Until Boss HP%", Default = 15, Min = 0, Max = 100, Rounding = 0 })
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
    if not fireproximityprompt then
        return
    end
    if not target or not target:IsA("ProximityPrompt") then
        return
    end
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
local STARDUST_TO_REBIRTH = 0
local REBIRTH_KEEP_MAX = 1
local RARITY_RANK = {
    common = 1, uncommon = 2, rare = 3, epic = 4,
    legendary = 5, mythical = 6, limited = 5,
}
local Currency = {}
local HUD_SUFFIXES = {
    ["k"]  = 1e3,  ["M"]  = 1e6,  ["B"]  = 1e9,  ["T"]  = 1e12,
    ["qd"] = 1e15, ["Qn"] = 1e18, ["sx"] = 1e21, ["Sp"] = 1e24,
    ["O"]  = 1e27, ["N"]  = 1e30, ["de"] = 1e33, ["Ud"] = 1e36,
    ["DD"] = 1e39,
}
local function ParseHudNumber(text)
    if not text or text == "" then return 0 end
    local clean = text:gsub("^%$", ""):gsub(",", "")
    local num, suffix = clean:match("^([%d%.]+)([%a]*)")
    local n = tonumber(num) or 0
    if suffix and suffix ~= "" then
        local mult = HUD_SUFFIXES[suffix]
        if mult then n = n * mult end
    end
    return n
end
local function UpdateCurrency()
    pcall(function()
        local HudFrame = PGui:FindFirstChild("Hud")
        if not HudFrame then return end
        local Frame = HudFrame:FindFirstChild("Frame")
        if not Frame then return end
        local BL = Frame:FindFirstChild("BottomLeft")
        if not BL then return end
        local Cur = BL:FindFirstChild("Currency")
        if not Cur then return end
        local cashLabel     = Cur:FindFirstChild("Cash")     and Cur.Cash:FindFirstChild("Amount")
        local gemsLabel     = Cur:FindFirstChild("Gems")     and Cur.Gems:FindFirstChild("Amount")
        local stardustFrame = Cur:WaitForChild("Stardust", 1)
        local stardustLabel = stardustFrame and stardustFrame:WaitForChild("Amount", 1)
        Currency.Cash     = cashLabel     and ParseHudNumber(cashLabel.Text)     or 0
        Currency.Gems     = gemsLabel     and ParseHudNumber(gemsLabel.Text)     or 0
        Currency.Stardust = stardustLabel and ParseHudNumber(stardustLabel.Text) or 0
    end)
end
local mutationDisplayList = {"None"}
for _, def in ipairs(Modules.Mutations.DEFS) do
    table.insert(mutationDisplayList, def.name)
end
local function mutationIdFromName(name)
    if name == "None" then return nil end
    for _, def in ipairs(Modules.Mutations.DEFS) do
        if def.name == name then return def.id end
    end
    return nil
end
local function GetFactoryLevel()    local level = 0
    pcall(function()
        local HudFrame = PGui:FindFirstChild("Hud")
        if not HudFrame then return end
        local Frame = HudFrame:FindFirstChild("Frame")
        if not Frame then return end
        local BR = Frame:FindFirstChild("BottomRight")
        if not BR then return end
        local OLL = BR:FindFirstChild("OreLimitLevel")
        if not OLL then return end
        local lbl = OLL:FindFirstChild("Level")
        if not lbl then return end
        local n = lbl.Text:match("Factory Level (%d+)")
        if n then level = tonumber(n) or 0 end
    end)
    return level
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
	Misc = Window:AddTab("Misc"),
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Autofarm = Tabs.Main:AddLeftTabbox(),
            MiscAuto = Tabs.Main:AddLeftTabbox(),
        },
        Right = {
            MiscAuto = Tabs.Main:AddRightTabbox(),
        },
    },
}
local function GetOwnPlot()
    local Plots = workspace:FindFirstChild("Plots")
    if Plots == nil then return nil end
    for _, plot in ipairs(Plots:GetChildren()) do
        if plot:IsA("Model") and plot:GetAttribute("owner_user_id") == Plr.UserId then
            return plot
        end
    end
    return nil
end
local function GetUpgraderNames()
    local names = {}
    local plot = GetOwnPlot()
    if plot == nil then return names end
    local PlacedItems = plot:FindFirstChild("PlacedItems")
    if PlacedItems == nil then return names end
    for _, item in ipairs(PlacedItems:GetChildren()) do
        if item:FindFirstChild("UpgradePart") then
            table.insert(names, item.Name)
        end
    end
    return names
end
local function GetUpgradePart(upgraderName)
    local plot = GetOwnPlot()
    if plot == nil then return nil end
    local PlacedItems = plot:FindFirstChild("PlacedItems")
    if PlacedItems == nil then return nil end
    local upgrader = PlacedItems:FindFirstChild(upgraderName)
    if upgrader == nil then return nil end
    return upgrader:FindFirstChild("UpgradePart")
end
local function GetOres()
    local plot = GetOwnPlot()
    if plot == nil then return {} end
    local OresFolder = plot:FindFirstChild("Ores")
    if OresFolder == nil then return {} end
    return OresFolder:GetChildren()
end
local function GetAllOres()
    local ores = {}
    local Plots = workspace:FindFirstChild("Plots")
    if Plots == nil then return ores end
    for _, plot in ipairs(Plots:GetChildren()) do
        if not plot:IsA("Model") then continue end
        local OresFolder = plot:FindFirstChild("Ores")
        if OresFolder then
            for _, ore in ipairs(OresFolder:GetChildren()) do
                table.insert(ores, ore)
            end
        end
    end
    return ores
end
local function GetFurnaceMouth()
    local plot = GetOwnPlot()
    if plot == nil then return nil end
    local PlacedItems = plot:FindFirstChild("PlacedItems")
    if PlacedItems == nil then return nil end
    for _, item in ipairs(PlacedItems:GetChildren()) do
        local mouth = item:FindFirstChild("Mouth")
        if mouth then
            return mouth
        end
    end
    return nil
end
local function GetAllUpgradeParts()
    local parts = {}
    local Plots = workspace:FindFirstChild("Plots")
    if Plots == nil then return parts end
    for _, plot in ipairs(Plots:GetChildren()) do
        if not plot:IsA("Model") then continue end
        local PlacedItems = plot:FindFirstChild("PlacedItems")
        if PlacedItems then
            for _, item in ipairs(PlacedItems:GetChildren()) do
                local up = item:FindFirstChild("UpgradePart")
                if up then
                    table.insert(parts, up)
                end
            end
        end
    end
    return parts
end
local function GetPlacedItemNames()
    local names = {}
    local seen = {}
    local plot = GetOwnPlot()
    if plot then
        local PlacedItems = plot:FindFirstChild("PlacedItems")
        if PlacedItems then
            for _, item in ipairs(PlacedItems:GetChildren()) do
                local iid = item:GetAttribute("instance_id")
                if typeof(iid) == "string"
                    and item:GetAttribute("is_belt_item") ~= true
                    and item:GetAttribute("is_reserve_slot") ~= true
                    and not seen[item.Name] then
                    seen[item.Name] = true
                    table.insert(names, item.Name)
                end
            end
        end
    end
    local invPanel = PGui:FindFirstChild("InventoryPanel")
    local grid = invPanel
        and invPanel:FindFirstChild("Frame")
        and invPanel.Frame:FindFirstChild("Panel")
        and invPanel.Frame.Panel:FindFirstChild("Drawer")
        and invPanel.Frame.Panel.Drawer:FindFirstChild("Grid")
    if grid then
        for _, child in ipairs(grid:GetChildren()) do
            local itemName = child.Name:split("|")[1]
            if itemName and itemName ~= "" and not seen[itemName] then
                seen[itemName] = true
                table.insert(names, itemName)
            end
        end
    end
    return names
end
local function GetInstanceIdsForName(itemName)
    local ids = {}
    local plot = GetOwnPlot()
    if plot == nil then return ids end
    local PlacedItems = plot:FindFirstChild("PlacedItems")
    if PlacedItems then
        for _, item in ipairs(PlacedItems:GetChildren()) do
            if item:GetAttribute("item_type") == itemName then
                local iid = item:GetAttribute("instance_id")
                if typeof(iid) == "string"
                    and item:GetAttribute("is_belt_item") ~= true
                    and item:GetAttribute("is_reserve_slot") ~= true then
                    table.insert(ids, iid)
                end
            end
        end
    end
    return ids
end
local function GetBeltDroppers()
    local result = {}
    local plot = GetOwnPlot()
    if plot == nil then return result end
    local Belt = plot:FindFirstChild("Belt")
    if Belt == nil then return result end
    local ActiveItems = Belt:FindFirstChild("ActiveItems")
    if ActiveItems == nil then return result end
    for _, model in ipairs(ActiveItems:GetChildren()) do
        if model:IsA("Model") then
            local item_type = model:GetAttribute("item_type")
            if item_type then
                local ok, entry = pcall(Modules.Items.get, item_type)
                if ok and entry and entry.category == "dropper" then
                    table.insert(result, {model = model, entry = entry, item_type = item_type})
                end
            end
        end
    end
    return result
end
local function GetAllBeltItems()
    local result = {}
    local Plots = workspace:FindFirstChild("Plots")
    if Plots == nil then return result end
    for _, plot in ipairs(Plots:GetChildren()) do
        if not plot:IsA("Model") then continue end
        local Belt = plot:FindFirstChild("Belt")
        if Belt == nil then continue end
        local ActiveItems = Belt:FindFirstChild("ActiveItems")
        if ActiveItems == nil then continue end
        for _, model in ipairs(ActiveItems:GetChildren()) do
            if model:IsA("Model") then
                local item_type = model:GetAttribute("item_type")
                if item_type then
                    local ok, entry = pcall(Modules.Items.get, item_type)
                    if ok and entry then
                        table.insert(result, {model = model, entry = entry, item_type = item_type})
                    end
                end
            end
        end
    end
    return result
end
local function GetPlotScreenPrompt(tag)
    local plot = GetOwnPlot()
    if plot == nil then return nil end
    local TaggedParts = plot:FindFirstChild("TaggedParts")
    if TaggedParts == nil then return nil end
    local part = TaggedParts:FindFirstChild(tag)
    if part == nil then return nil end
    return part:FindFirstChild("ScreenPrompt")
end
local UpgradeTab = TB.Main.Left.Autofarm:AddTab("Upgrade")
UpgradeTab:AddToggle("InstantFurnace", {
    Text    = "Instant Furnace",
    Default = false,
})
Toggles.InstantFurnace:OnChanged(function()
    Thread("InstantFurnace", function()
        while Toggles.InstantFurnace.Value do
            task.wait()
            local Mouth = GetFurnaceMouth()
            if Mouth == nil then
                yuri("[InstantFurnace] Furnace Mouth not found on own plot.")
                task.wait(1)
            else
                local upgraderParts = GetAllUpgradeParts()
                for _, ore in ipairs(GetOres()) do
                    task.spawn(function()
                        pcall(function()
                            for _, up in ipairs(upgraderParts) do
                                firetouchinterest(ore, up, 0)
                                task.wait()
                                firetouchinterest(ore, up, 1)
                            end
                            firetouchinterest(ore, Mouth, 0)
                            task.wait()
                            firetouchinterest(ore, Mouth, 1)
                        end)
                    end)
                end
            end
        end
    end, Toggles.InstantFurnace.Value)
end)
local FactoryTab = TB.Main.Left.Autofarm:AddTab("Factory")
FactoryTab:AddToggle("AutoLevelUp", {
    Text    = "Auto Level Up Factory",
    Default = false,
})
Toggles.AutoLevelUp:OnChanged(function()
    Thread("AutoLevelUp", function()
        while Toggles.AutoLevelUp.Value do
            task.wait()
            pcall(function()
                local level = GetFactoryLevel()
                local cost = Modules.LevelCosts.getCost(level + 1)
                if cost == nil then return end
                UpdateCurrency()
                if Currency.Cash >= cost then
                    Modules.Packets.level_up:Fire()
                end
            end)
        end
    end, Toggles.AutoLevelUp.Value)
end)
FactoryTab:AddToggle("AutoBuild", {
    Text    = "Auto Build",
    Default = false,
})
local _autoBuildCooldown = false
local _cachedInvAtomFn = nil
local _autoBuildUnsub = nil
local function RunAutoBuildCheck()
    if _autoBuildCooldown then return end
    _autoBuildCooldown = true
    pcall(function()
        Modules.Packets.auto_build_factory:Fire()
    end)
    task.delay(1, function()
        _autoBuildCooldown = false
    end)
end
local _getupvalues = debug and debug.getupvalues or getupvalues or getupvals
local _cachedPlacedFn = nil
local function GetPlacedAtoms()
    if _cachedPlacedFn then
        local ok, uvs = pcall(_getupvalues, _cachedPlacedFn)
        if ok and uvs and type(uvs[3]) == "table" then
            return uvs[3]
        end
        _cachedPlacedFn = nil
        yuri("[PlacedAtom] Cache invalid, rescanning")
    end
    if not _getupvalues then
        yuri("[PlacedAtom] getupvalues not available on this executor")
        return nil
    end
    local ok, gcObjects = pcall(getgc, false)
    if not ok or not gcObjects then
        yuri("[PlacedAtom] getgc failed")
        return nil
    end
    for _, fn in ipairs(gcObjects) do
        if type(fn) ~= "function" then continue end
        local okU, uvs = pcall(_getupvalues, fn)
        if not okU or type(uvs) ~= "table" then continue end
        local candidate = uvs[3]  
        if type(candidate) ~= "table" then continue end
        local first = next(candidate)
        if first == nil then continue end
        local entry = candidate[first]
        if type(entry) ~= "table" then continue end
        if type(entry.item_type) ~= "string" then continue end
        local store = uvs[1]
        if type(store) ~= "table" then continue end
        if rawget(store, "listeners") == nil and rawget(store, "capturing") == nil then continue end
        _cachedPlacedFn = fn
        yuri("[PlacedAtom] placed atom found via upvalue scan, entries:", (function()
            local n = 0; for _ in pairs(candidate) do n = n + 1 end; return n
        end)())
        return candidate
    end
    yuri("[PlacedAtom] placed atom not found in GC")
    return nil
end
local function IsItemPermanent(iid)
    local placed = GetPlacedAtoms()
    if not placed then return nil end  
    local entry = placed[iid]
    if not entry then return nil end   
    return entry.is_permanent == true
end
local function FindInventoryAtomFn()
    if _cachedInvAtomFn then
        local ok, uvs = pcall(_getupvalues, _cachedInvAtomFn)
        if ok and uvs and type(uvs[3]) == "table" then
            return _cachedInvAtomFn
        end
        _cachedInvAtomFn = nil
        yuri("[InvAtom] cache invalid, rescanning")
    end
    if not _getupvalues then
        yuri("[InvAtom] getupvalues not available on this executor")
        return nil
    end
    local ok, gcObjects = pcall(getgc, false)
    if not ok or not gcObjects then
        yuri("[InvAtom] getgc failed")
        return nil
    end
    for _, fn in ipairs(gcObjects) do
        if type(fn) ~= "function" then continue end
        local okU, uvs = pcall(_getupvalues, fn)
        if not okU or type(uvs) ~= "table" then continue end
        local candidate = uvs[3]
        if type(candidate) ~= "table" then continue end
        local first = next(candidate)
        if first == nil then continue end
        local entry = candidate[first]
        if type(entry) ~= "table" then continue end
        if type(entry.item_type) ~= "string" then continue end
        if entry.acquired_at == nil then continue end  
        local store = uvs[1]
        if type(store) ~= "table" then continue end
        if rawget(store, "listeners") == nil and rawget(store, "capturing") == nil then continue end
        _cachedInvAtomFn = fn
        yuri("[InvAtom] inventory atom found, entries:", (function()
            local n = 0; for _ in pairs(candidate) do n = n + 1 end; return n
        end)())
        return fn
    end
    yuri("[InvAtom] inventory atom not found in GC")
    return nil
end
local function GetInventoryAtoms()
    local fn = FindInventoryAtomFn()
    if not fn then return nil end
    local ok, uvs = pcall(_getupvalues, fn)
    if not ok or type(uvs) ~= "table" then return nil end
    return uvs[3]
end
local function SetupAutoBuildConnections()
    if _autoBuildUnsub then _autoBuildUnsub(); _autoBuildUnsub = nil end
    if not Toggles.AutoBuild.Value then return end
    task.spawn(function()
        local invFn = nil
        for _ = 1, 20 do
            invFn = FindInventoryAtomFn()
            if invFn then break end
            task.wait(0.5)
        end
        if not invFn then
            yuri("[AutoBuild] inventory atom not found, AutoBuild inactive")
            return
        end
        _autoBuildUnsub = charm.subscribe(invFn, function()
            if not Toggles.AutoBuild.Value then return end
            RunAutoBuildCheck()
        end)
        yuri("[AutoBuild] subscribed to inventory atom")
    end)
end
Toggles.AutoBuild:OnChanged(function(state)
    if state then
        SetupAutoBuildConnections()
    else
        if _autoBuildUnsub then _autoBuildUnsub(); _autoBuildUnsub = nil end
    end
end)
FactoryTab:AddToggle("AutoCollect", {
    Text    = "Auto Collect Money",
    Default = false,
})
Toggles.AutoCollect:OnChanged(function()
    Thread("AutoCollect", function()
        while Toggles.AutoCollect.Value do
            task.wait()
            if not fireproximityprompt then
                task.wait(1)
            else
                pcall(function()
                    local plot = GetOwnPlot()
                    if not plot then return end
                    local PlacedItems = plot:FindFirstChild("PlacedItems")
                    if not PlacedItems then return end
                    for _, item in ipairs(PlacedItems:GetChildren()) do
                        local hitbox = item:FindFirstChild("Hitbox")
                        if hitbox then
                            local prompt = hitbox:FindFirstChild("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end)
            end
        end
    end, Toggles.AutoCollect.Value)
end)
FactoryTab:AddDivider()
FactoryTab:AddInput("StardustToRebirth", {
    Text        = "Stardust To Rebirth",
    Default     = tostring(STARDUST_TO_REBIRTH),
    Placeholder = "Amount",
    Callback    = function(Value)
        local number = tonumber(Value)
        if number then
            STARDUST_TO_REBIRTH = number
        end
    end,
})
FactoryTab:AddToggle("AutoRebirth", {
    Text    = "Auto Rebirth",
    Default = false,
})
Toggles.AutoRebirth:OnChanged(function()
    Thread("AutoRebirth", function()
        while Toggles.AutoRebirth.Value do
            task.wait(0.5)
            local ok, err = pcall(function()
                UpdateCurrency()
                local predictedStardust = Modules.RebirthRewards.previewPayout(Currency.Cash)
                if predictedStardust < STARDUST_TO_REBIRTH then
                    return
                end
                local keepList = {}
                local wantKeep = (Toggles.KeepNonPerm and Toggles.KeepNonPerm.Value)
                    or (Toggles.KeepHighestRarity and Toggles.KeepHighestRarity.Value)
                if wantKeep then
                    local inv = GetInventoryAtoms()
                    if inv then
                        if next(inv) == nil then
                            yuri("[AutoRebirth] inventory atom empty, waiting for state to settle")
                            return
                        end
                        for iid, entry in pairs(inv) do
                            if entry.is_permanent ~= true then
                                table.insert(keepList, iid)
                            end
                        end
                        if Toggles.KeepHighestRarity and Toggles.KeepHighestRarity.Value then
                            table.sort(keepList, function(a, b)
                                local rankA, rankB = 0, 0
                                pcall(function() rankA = RARITY_RANK[Modules.Items.get(inv[a].item_type).data.rarity] or 0 end)
                                pcall(function() rankB = RARITY_RANK[Modules.Items.get(inv[b].item_type).data.rarity] or 0 end)
                                return rankA > rankB
                            end)
                        end
                        local keepMax = math.floor(tonumber(Options.RebirthKeepMax.Value) or REBIRTH_KEEP_MAX)
                        if keepMax > 0 and #keepList > keepMax then
                            while #keepList > keepMax do
                                table.remove(keepList)
                            end
                        end
                        yuri("[AutoRebirth] Keeping", #keepList, "non-permanent items | cap:", keepMax == 0 and "server" or keepMax)
                    else
                        yuri("[AutoRebirth] WARNING: inventory atom not found, rebirthing with empty list")
                    end
                end
                yuri("[AutoRebirth] Firing rebirth | stardust:", predictedStardust, "| keepList:", #keepList)
                Modules.Packets.rebirth:Fire(keepList)
                task.wait(3)
            end)
            if not ok then
                yuri("[AutoRebirth] pcall ERROR:", tostring(err))
            end
        end
    end, Toggles.AutoRebirth.Value)
end)
FactoryTab:AddToggle("KeepNonPerm", {
    Text    = "Keep Non-Permanent Items",
    Default = false,
})
FactoryTab:AddToggle("KeepHighestRarity", {
    Text    = "Keep Highest Rarity",
    Default = false,
})
FactoryTab:AddInput("RebirthKeepMax", {
    Text        = "Keep Amount",
    Default     = "1",
    Placeholder = "Max items to keep",
    Callback    = function(Value)
        local n = tonumber(Value)
        if n then REBIRTH_KEEP_MAX = math.floor(n) end
    end,
})
local BeltTab = TB.Main.Left.Autofarm:AddTab("Belt")
local function GetBeltItemIds()
    local ids = {}
    for id, _ in pairs(Modules.Items.all()) do
        table.insert(ids, id)
    end
    table.sort(ids)
    return ids
end
BeltTab:AddDropdown("BeltItemSelect", {
    Text       = "Items To Buy",
    Values     = GetBeltItemIds(),
    Default    = {},
    Multi      = true,
    Searchable = true,
})
BeltTab:AddDropdown("BeltMutationSelect", {
    Text       = "Required Mutation",
    Values     = mutationDisplayList,
    Default    = {},
    Multi      = true,
    Searchable = true,
})
BeltTab:AddToggle("AutoBuyBeltSelected", {
    Text    = "Auto Buy Selected",
    Default = false,
})
Toggles.AutoBuyBeltSelected:OnChanged(function()
    Thread("AutoBuyBeltSelected", function()
        while Toggles.AutoBuyBeltSelected.Value do
            task.wait()
            pcall(function()
                local selectedItems = Options.BeltItemSelect.Value
                local selectedMuts  = Options.BeltMutationSelect.Value
                if type(selectedItems) ~= "table" then
                    return
                end
                local hasMutFilter = false
                if type(selectedMuts) == "table" then
                    for _, active in pairs(selectedMuts) do
                        if active then hasMutFilter = true; break end
                    end
                end
                local allItems = GetAllBeltItems()
                for _, d in ipairs(allItems) do
                    if selectedItems[d.item_type] then
                        local mutAttr = d.model:GetAttribute("mutation")
                        local mutPass = true
                        if hasMutFilter then
                            local mutName = mutAttr and Modules.Mutations.NAMES[mutAttr]
                            mutPass = mutName ~= nil and selectedMuts[mutName] == true
                        end
                        if mutPass then
                            pcall(function()
                                Modules.Packets.purchase_belt_item:Fire(d.model)
                            end)
                            task.wait()
                        end
                    end
                end
            end)
        end
    end, Toggles.AutoBuyBeltSelected.Value)
end)
BeltTab:AddToggle("AutoBuyBest", {
    Text    = "Auto Buy Best",
    Default = false,
})
Toggles.AutoBuyBest:OnChanged(function()
    Thread("AutoBuyBest", function()
        while Toggles.AutoBuyBest.Value do
            task.wait()
            pcall(function()
                local plot = GetOwnPlot()
                if not plot then return end
                local PlacedItems = plot:FindFirstChild("PlacedItems")
                if not PlacedItems then return end
                local inventory_table = {}
                for _, item in ipairs(PlacedItems:GetChildren()) do
                    local iid = item:GetAttribute("instance_id")
                    if typeof(iid) == "string"
                        and item:GetAttribute("is_belt_item") ~= true
                        and item:GetAttribute("is_reserve_slot") ~= true then
                        table.insert(inventory_table, {
                            item_type = item:GetAttribute("item_type"),
                            mutation  = item:GetAttribute("mutation"),
                            is_gold   = item:GetAttribute("is_gold") == true,
                        })
                    end
                end
                local catalog = Modules.Items.all()
                for _, d in ipairs(GetAllBeltItems()) do
                    local entry = Modules.Items.get(d.item_type)
                    if entry then
                        local result = Modules.BeltBadge.state(
                            inventory_table,
                            d.item_type,
                            d.model:GetAttribute("is_gold") == true,
                            d.model:GetAttribute("mutation"),
                            entry.category,
                            catalog
                        )
                        if result == "upgrade" then
                            Modules.Packets.purchase_belt_item:Fire(d.model)
                        end
                    end
                end
            end)
        end
    end, Toggles.AutoBuyBest.Value)
end)
local GemTab = TB.Main.Right.MiscAuto:AddTab("Gems")
local gemShopIds = {}
for id, def in pairs(Modules.UpgradeDefs.DEFS) do
    if def.currency == "primary_gem" then
        table.insert(gemShopIds, id)
    end
end
GemTab:AddDropdown("GemShopItems", {
    Text       = "Items To Buy",
    Values     = gemShopIds,
    Default    = {},
    Multi      = true,
    Searchable = true,
})
GemTab:AddToggle("AutoBuyGem", {
    Text    = "Auto Buy Selected",
    Default = false,
})
Toggles.AutoBuyGem:OnChanged(function()
    Thread("AutoBuyGem", function()
        while Toggles.AutoBuyGem.Value do
            task.wait()
            pcall(function()
                local selected = Options.GemShopItems.Value
                if type(selected) ~= "table" then return end
                for id, active in pairs(selected) do
                    if active then
                        pcall(function()
                            Modules.Packets.buy_upgrade:Fire(id)
                        end)
                        task.wait()
                    end
                end
            end)
        end
    end, Toggles.AutoBuyGem.Value)
end)
local StardustTab = TB.Main.Right.MiscAuto:AddTab("Stardust")
local stardustShopIds = {}
for id, def in pairs(Modules.UpgradeDefs.DEFS) do
    if def.currency == "stardust" then
        table.insert(stardustShopIds, id)
    end
end
StardustTab:AddDropdown("StardustShopItems", {
    Text       = "Items To Buy",
    Values     = stardustShopIds,
    Default    = {},
    Multi      = true,
    Searchable = true,
})
StardustTab:AddToggle("AutoBuyStardust", {
    Text    = "Auto Buy Selected",
    Default = false,
})
Toggles.AutoBuyStardust:OnChanged(function()
    Thread("AutoBuyStardust", function()
        while Toggles.AutoBuyStardust.Value do
            task.wait()
            pcall(function()
                local selected = Options.StardustShopItems.Value
                if type(selected) ~= "table" then return end
                local count = 0
                for id, active in pairs(selected) do
                    if active then count = count + 1 end
                end
                for id, active in pairs(selected) do
                    if active then
                        pcall(function()
                            Modules.Packets.buy_upgrade:Fire(id)
                        end)
                        task.wait()
                    end
                end
            end)
        end
    end, Toggles.AutoBuyStardust.Value)
end)
local _SH_isHopping = false
local _SH_TRIED_FILE = "Yuri/TEF/Servers.txt"
local _SH_MAX_TRIED = 30
local function _SH_readFile(p)
    if not Support.FileIO then return "" end
    local ok, c = pcall(readfile, p)
    return (ok and c) or ""
end
local function _SH_writeFile(p, c)
    if not Support.FileIO then return end
    pcall(function()
        if not isfolder("Yuri") then makefolder("Yuri") end
        if not isfolder("Yuri/TEF") then makefolder("Yuri/TEF") end
        writefile(p, c)
    end)
end
local function _SH_appendFile(p, line)
    local existing = _SH_readFile(p)
    _SH_writeFile(p, existing ~= "" and (existing .. line .. "\n") or (line .. "\n"))
end
local function _SH_getTriedSet()
    local set = {}
    for id in _SH_readFile(_SH_TRIED_FILE):gmatch("([^\n]+)") do
        if id ~= "" then set[id] = true end
    end
    return set
end
local function _SH_getTriedCount()
    local count = 0
    for _ in _SH_readFile(_SH_TRIED_FILE):gmatch("([^\n]+)") do count = count + 1 end
    return count
end
local function _SH_clearTried()
    _SH_writeFile(_SH_TRIED_FILE, "")
    yuri("Server hop: cleared tried servers list")
end
local function _SH_shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
end
local _SH_MIN_FREE_SLOTS = 3
local function _SH_GetOpenServers()
    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
        game.PlaceId
    )
    local servers = {}
    local tried = _SH_getTriedSet()
    local currentId = tostring(game.JobId)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok or not res then return servers end
    local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not ok2 or not data or not data.data then return servers end
    local toWrite = {}
    for _, srv in ipairs(data.data) do
        local serverId = tostring(srv.id)
        local playing = tonumber(srv.playing) or 0
        local maxPlayers = tonumber(srv.maxPlayers) or 0
        if not tried[serverId] then
            table.insert(toWrite, serverId)
            tried[serverId] = true
        end
        if serverId ~= currentId
            and (maxPlayers - playing) >= _SH_MIN_FREE_SLOTS
        then
            table.insert(servers, {
                id = serverId,
                playing = playing,
                maxPlayers = maxPlayers,
            })
        end
    end
    if #toWrite > 0 then
        local existing = _SH_readFile(_SH_TRIED_FILE)
        local joined = table.concat(toWrite, "\n") .. "\n"
        _SH_writeFile(_SH_TRIED_FILE, existing ~= "" and (existing .. joined) or joined)
    end
    table.sort(servers, function(a, b)
        return a.playing < b.playing
    end)
    return servers
end
local function _SH_startServerHop()
    if _SH_isHopping then return end
    if _SH_getTriedCount() >= _SH_MAX_TRIED then _SH_clearTried() end
    _SH_isHopping = true
    _SH_appendFile(_SH_TRIED_FILE, tostring(game.JobId))
    yuri("Server hop: starting")
    task.spawn(function()
        while _SH_isHopping do
            if not (Toggles.AutoServerhop2 and Toggles.AutoServerhop2.Value) then
                _SH_isHopping = false
                yuri("Server hop: cancelled (toggle off)")
                break
            end
            local servers = _SH_GetOpenServers()
            if #servers > 0 then
                yuri("Server hop: found " .. #servers .. " servers")
                for _, server in ipairs(servers) do
                    if not _SH_isHopping then break end
                    yuri("Server hop: trying " .. server.id .. " (" .. server.playing .. "/" .. server.maxPlayers .. ")")
                    _SH_appendFile(_SH_TRIED_FILE, server.id)
                    local ok, err = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
                    end)
                    if ok then
                        yuri("Server hop: teleporting...")
                        task.wait()
                        break
                    else
                        yuri("Server hop: teleport failed - " .. tostring(err))
                        task.wait()
                    end
                end
                if _SH_getTriedCount() >= _SH_MAX_TRIED then _SH_clearTried() end
                task.wait()
            else
                yuri("Server hop: no servers found, retrying...")
                task.wait(.5)
            end
        end
    end)
end
local ServerGroup  = Tabs.Misc:AddLeftGroupbox("Server")
local PlayerGroup = Tabs.Misc:AddRightGroupbox("Player")
AddSliderToggle({ Group = PlayerGroup, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = PlayerGroup, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = PlayerGroup, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = PlayerGroup, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
PlayerGroup:AddToggle("Noclip2", { Text = "Noclip" })
PlayerGroup:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
AddSliderToggle({ Group = PlayerGroup, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = PlayerGroup, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = PlayerGroup, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
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
        if server.id ~= currentId and server.playing - 2 < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
            return
        end
    end
end })
ServerGroup:AddButton({ Text = "Rejoin", Func = function()
    TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
end })
ServerGroup:AddToggle("AutoServerhop2", { Text = "Auto Serverhop" })
ServerGroup:AddSlider("AutoHopMins2", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
ServerGroup:AddDivider()
ServerGroup:AddButton({ Text = "Redeem All Codes", Func = function()
    local codes = Modules.CodeDefs.CODES
    local rateLimit = Modules.CodeDefs.RATE_LIMIT_SEC or 2
    local redeemed = 0
    local skipped = 0
    task.spawn(function()
        for code, def in pairs(codes) do
            if def.disabled then
                yuri("[AutoRedeem] Skipping disabled code:", code)
                skipped = skipped + 1
            else
                yuri("[AutoRedeem] Redeeming code:", code)
                pcall(function()
                    Modules.Packets.redeem_code:Fire(code)
                end)
                redeemed = redeemed + 1
                task.wait(rateLimit + 0.1)
            end
        end
        Library:Notify(("Codes: redeemed %d, skipped %d disabled"):format(redeemed, skipped), 5)
        yuri("[AutoRedeem] Done. Redeemed:", redeemed, "| Skipped (disabled):", skipped)
    end)
end })
ServerGroup:AddDivider()
ServerGroup:AddInput("LeechMinValue", {
    Text        = "Leech Best Ore",
    Default     = "1M",
})
ServerGroup:AddToggle("LeechServerhop", { Text = "Leech Serverhop", Default = false })
Toggles.LeechServerhop:OnChanged(function(state)
    Thread("LeechServerhop", function()
        while Toggles.LeechServerhop.Value do
            local minVal = ParseHudNumber("$" .. (Options.LeechMinValue.Value or "1M"))
            yuri("[LeechHop] Looking for server with Best Ore >=", minVal)
            local foundInCurrent = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p == Plr then continue end
                local ls = p:FindFirstChild("leaderstats")
                local stat = ls and ls:FindFirstChild("Best Ore")
                if stat then
                    local val = ParseHudNumber(stat.Value)
                    yuri("[LeechHop] Player", p.Name, "Best Ore:", stat.Value, "->", val)
                    if val >= minVal then
                        yuri("[LeechHop] Found qualifying player in current server:", p.Name)
                        foundInCurrent = true
                        break
                    end
                end
            end
            if foundInCurrent then
                task.wait(3)
            else
                yuri("[LeechHop] No qualifying player here, fetching server list...")
                local ok, res = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(
                        "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
                    ))
                end)
                if not ok or not res or not res.data then
                    yuri("[LeechHop] Failed to fetch server list, retrying in 10s...")
                    task.wait(1)
                else
                    local currentId = game.JobId
                    local hopped = false
                    local toWrite = {}
                    for _, server in ipairs(res.data) do
                        if not Toggles.LeechServerhop.Value then break end
                        local sId = tostring(server.id)
                        if sId == currentId then continue end
                        local maxPlayers = tonumber(server.maxPlayers) or 0
                        local playing = tonumber(server.playing) or 0
                        table.insert(toWrite, sId)
                        if playing < 1 then continue end
                        if (maxPlayers - playing) < 1 then continue end
                        yuri("[LeechHop] Hopping to server:", sId, "players:", playing)
                        _SH_appendFile(_SH_TRIED_FILE, sId)
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, sId, Plr)
                        hopped = true
                        break
                    end
                    if #toWrite > 0 then
                        local existing = _SH_readFile(_SH_TRIED_FILE)
                        local joined = table.concat(toWrite, "\n") .. "\n"
                        _SH_writeFile(_SH_TRIED_FILE, existing ~= "" and (existing .. joined) or joined)
                    end
                    if not hopped then
                        yuri("[LeechHop] No suitable server found, retrying in 15s...")
                        task.wait(1)
                    else
                        task.wait(1)
                    end
                end
            end
        end
    end, Toggles.LeechServerhop.Value)
end)
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
Toggles.FPSBoost:OnChanged(function(state)
    ApplyFPSBoost(state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP2 and Toggles.InstantPP2.Value then
        prompt.HoldDuration = 0
    end
end)
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
            if mins > 1 then
                task.wait((mins - 1) * 60)
            end
            if Toggles.AutoServerhop2.Value then
                _SH_startServerHop()
            end
        end
    end
end)
task.spawn(function()
    local lastSeen = {}
    local function handleItem(item)
        local iid = item:GetAttribute("instance_id")
        local item_type = item:GetAttribute("item_type")
        if not (typeof(iid) == "string" and item_type) then return end
        if item:GetAttribute("is_belt_item") == true then return end
        if item:GetAttribute("is_reserve_slot") == true then return end
        if lastSeen[iid] then return end
        lastSeen[iid] = true
        local placed = GetPlacedAtoms()
        local isPerm = placed and placed[iid] and placed[iid].is_permanent
        local permStr
        if isPerm == true then
            permStr = "PERMANENT"
        elseif isPerm == false then
            permStr = "not permanent"
        else
            permStr = "unknown"
        end
        yuri("NEW ITEM:", item_type, "| ID:", iid, "|", permStr)
    end
    local plot = nil
    while not plot do
        plot = GetOwnPlot()
        if not plot then task.wait(1) end
    end
    local PlacedItems = plot:WaitForChild("PlacedItems", 30)
    if not PlacedItems then
        yuri("WARN: PlacedItems not found in plot after 30s")
        return
    end
    for _, item in ipairs(PlacedItems:GetChildren()) do
        handleItem(item)
    end
    PlacedItems.ChildAdded:Connect(handleItem)
end)
task.spawn(function()
    local lastSeen = {}
    local function handleInvChange(newInv)
        if type(newInv) ~= "table" then return end
        for guid, item in pairs(newInv) do
            if not lastSeen[guid] then
                lastSeen[guid] = true
                yuri("NEW INV ITEM:", item.item_type, "| ID:", guid, "| perm:", tostring(item.is_permanent), "| acquired_at:", item.acquired_at)
            end
        end
    end
    local invFn = nil
    for _ = 1, 20 do
        invFn = FindInventoryAtomFn()
        if invFn then break end
        task.wait(0.5)
    end
    if not invFn then
        yuri("[InvAtom] inventory atom not found, debug logger inactive")
        return
    end
    local inv = GetInventoryAtoms()
    if inv then
        local count = 0
        for _ in pairs(inv) do count = count + 1 end
        yuri("[InvAtom] initial scan:", count, "items")
        for guid, item in pairs(inv) do
            lastSeen[guid] = true
            yuri("INV ITEM:", item.item_type, "| ID:", guid, "| perm:", tostring(item.is_permanent), "| acquired_at:", item.acquired_at)
        end
    end
    charm.subscribe(invFn, handleInvChange)
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
SaveManager:SetFolder("Yuri/TEF")
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
