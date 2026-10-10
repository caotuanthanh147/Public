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
local RemoteEventsFolder = RS:FindFirstChild("RemoteEvents") or RS:WaitForChild("RemoteEvents", 15)
local RemoteFunctionsFolder = RS:FindFirstChild("RemoteFunctions") or RS:WaitForChild("RemoteFunctions", 15)
local PlotHelperModule = GetSafeModule(RS, "PlotHelperModule")
local HelperFunctionModule = GetSafeModule(RS, "HelperFunctionModule")
local IngredientLibrary = GetSafeModule(RS, "IngredientLibrary")
local _ingredientDropdownValues = {"Any"}
do
    local _sorted = {}
    if IngredientLibrary and IngredientLibrary.ingredientList then
        for id, data in pairs(IngredientLibrary.ingredientList) do
            if data.name and data.rarity then
                table.insert(_sorted, { id = id, name = data.name, rarity = data.rarity })
            end
        end
        table.sort(_sorted, function(a, b)
            if a.rarity ~= b.rarity then return a.rarity < b.rarity end
            return a.name < b.name
        end)
    end
    for _, entry in ipairs(_sorted) do
        table.insert(_ingredientDropdownValues, entry.name .. " | " .. entry.rarity)
    end
end
local _ingredientLabelToId = {}
if IngredientLibrary and IngredientLibrary.ingredientList then
    for id, data in pairs(IngredientLibrary.ingredientList) do
        if data.name and data.rarity then
            _ingredientLabelToId[data.name .. " | " .. data.rarity] = id
        end
    end
end
local _evtCache = {}
local function GetEvent(name)
    if _evtCache[name] ~= nil then return _evtCache[name] end
    local r = RemoteEventsFolder and (RemoteEventsFolder:FindFirstChild(name) or RemoteEventsFolder:WaitForChild(name, 5))
    _evtCache[name] = r
    return r
end
local function GetFunc(name)
    if not RemoteFunctionsFolder then return nil end
    return RemoteFunctionsFolder:FindFirstChild(name) or RemoteFunctionsFolder:WaitForChild(name, 5)
end
local function FireEvent(name, ...)
    local r = GetEvent(name)
    if not r then return false end
    local args = {...}
    return pcall(function() r:FireServer(table.unpack(args)) end)
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
local function InvokeFunc(name, ...)
    local r = GetFunc(name)
    if not r then return nil end
    local args = {...}
    local ok, res = pcall(function() return r:InvokeServer(table.unpack(args)) end)
    if ok then return res end
    return nil
end
local function FindPlot()
    if PlotHelperModule and PlotHelperModule.findPlayersPlot then
        local ok, plot = pcall(function() return PlotHelperModule.findPlayersPlot(Plr) end)
        if ok and plot then return plot end
    end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local owner = plot:GetAttribute("Owner") or plot:GetAttribute("owner")
            if owner == Plr.Name or owner == Plr.UserId then return plot end
        end
    end
    return nil
end
local function FindSpawnButton()
    local plot = FindPlot()
    if not plot then return nil end
    local sb = plot:FindFirstChild("SpawnButton", true)
    if sb then return sb end
    return RS:FindFirstChild("SpawnButton")
end
local function FindSpawnLever()
    local plot = FindPlot()
    if not plot then return nil end
    return plot:FindFirstChild("SpawnLever")
end
local function FindCollectButton()
    local plot = FindPlot()
    if not plot then return nil end
    local cbs = plot:FindFirstChild("CollectButtons")
    if not cbs then return nil end
    return cbs:FindFirstChild("CollectButton1")
end
local function GetMoney()
    local ls = Plr:FindFirstChild("leaderstats")
    if ls then
        local money = ls:FindFirstChild("Money")
        if money then return tonumber(money.Value) or 0 end
    end
    return 0
end
local function Func_AutoOpenSlot()
    while Toggles.AutoOpenSlot.Value do
        local plot = FindPlot()
        if plot then
            for _, pp in ipairs(plot:GetDescendants()) do
                if not Toggles.AutoOpenSlot.Value then break end
                if pp:IsA("ProximityPrompt") then
                    local actionText = pp.ActionText
                    local costStr = actionText:match("%$([%d%.]+[kKmMbB]?)")
                    if costStr then
                        local num = tonumber(costStr:match("^[%d%.]+"))
                        local suffix = costStr:match("[kKmMbB]$")
                        if num then
                            if suffix == "k" or suffix == "K" then num = num * 1000
                            elseif suffix == "m" or suffix == "M" then num = num * 1000000
                            elseif suffix == "b" or suffix == "B" then num = num * 1000000000
                            end
                            if GetMoney() >= num then
                                notyuri("AutoOpenSlot: buying via prompt", actionText, "cost", num)
                                FirePP(pp, true)
                                task.wait(1)
                            end
                        end
                    end
                end
            end
        end
        task.wait(3)
    end
end
local function TriggerCook(slot, folderName)
    slot:SetAttribute("toggle", true)
end
local function FindEmptySlot(cookType)
    local plot = FindPlot()
    if not plot then return nil, nil end
    local folderName = cookType == "toasters" and "Toasters" or "CraftTables"
    local folder = plot:FindFirstChild(folderName)
    if not folder then return nil, nil end
    for _, slot in ipairs(folder:GetChildren()) do
        if slot:IsA("Model") then
            if slot:GetAttribute("isUnlocked") == true and slot:GetAttribute("itemID") == nil then
                return slot, folderName
            end
        end
    end
    return nil, nil
end
local function Func_AutoRoll()
    while Toggles.AutoRoll.Value do
        local currentIngredient = Plr:GetAttribute("ingredientID")
        if currentIngredient == "" or currentIngredient == nil then
            local plot = FindPlot()
            if not plot then
                task.wait(1)
                continue
            end
            local spawnLever = plot:FindFirstChild("SpawnLever")
            local leverHandle = spawnLever and spawnLever:FindFirstChild("Handle")
            local basePrompt = spawnLever and spawnLever:FindFirstChild("Base") and spawnLever:FindFirstChild("Base"):FindFirstChild("ProximityPrompt")
            if not basePrompt then
                notyuri("AutoRoll: Base ProximityPrompt not found")
                task.wait(1)
                continue
            end
            if leverHandle then
                local isBusy = leverHandle:GetAttribute("isBusy")
                local rolledID = leverHandle:GetAttribute("itemID")
                if isBusy then
                    notyuri("AutoRoll: Handle busy, waiting...")
                    task.wait(0.3)
                    continue
                end
                if rolledID then
                    local selectedIngredients = Options.IngredientSelected and Options.IngredientSelected.Value
                    local anySelected = false
                    if selectedIngredients then
                        for _, v in pairs(selectedIngredients) do
                            if v then anySelected = true; break end
                        end
                    end
                    local shouldBuy = true
                    if anySelected and not selectedIngredients["Any"] then
                        local ingData = IngredientLibrary and IngredientLibrary.ingredientList and IngredientLibrary.ingredientList[rolledID]
                        if ingData then
                            local label = ingData.name .. " | " .. ingData.rarity
                            if selectedIngredients[label] == true then
                                notyuri("AutoRoll: match (", label, "), buying")
                            else
                                notyuri("AutoRoll: no match (", label, "), rerolling")
                                shouldBuy = false
                            end
                        else
                            notyuri("AutoRoll: no ingData for rolledID", rolledID)
                            shouldBuy = false
                        end
                    end
                    if shouldBuy then
                        local crateFolder = plot:FindFirstChild("CrateSpawn") and plot:FindFirstChild("CrateSpawn"):FindFirstChild("CrateFolder")
                        local _ingData = IngredientLibrary and IngredientLibrary.ingredientList and IngredientLibrary.ingredientList[rolledID]
                        local crateItem = crateFolder and crateFolder:FindFirstChild(_ingData and _ingData.name or rolledID)
                        local buyPrompt = crateItem and crateItem:FindFirstChild("Handle") and crateItem:FindFirstChild("Handle"):FindFirstChild("ProximityPrompt")
                        if buyPrompt then
                            while Toggles.AutoRoll.Value and leverHandle:GetAttribute("itemID") do
                                notyuri("AutoRoll: buying", rolledID)
                                FirePP(buyPrompt, true)
                                task.wait(1)
                            end
                        else
                            notyuri("AutoRoll: buy ProximityPrompt not found")
                            task.wait(0.3)
                        end
                        continue
                    end
                end
            end
            notyuri("AutoRoll: rolling")
            FirePP(basePrompt, true)
            task.wait(0.1)
        else
            task.wait(0.1)
        end
    end
end
local function Func_AutoCook()
    while Toggles.AutoCook.Value do
        local plot = FindPlot()
        if plot then
            local heldID = Plr:GetAttribute("ingredientID")
            if heldID then
                local ingData = IngredientLibrary and IngredientLibrary.ingredientList and IngredientLibrary.ingredientList[heldID]
                local cookType = ingData and ingData.cookType
                local folderName = cookType == "toasters" and "Toasters" or "CraftTables"
                local folder = plot:FindFirstChild(folderName)
                if folder then
                    for _, slot in ipairs(folder:GetChildren()) do
                        if slot:IsA("Model")
                            and slot:GetAttribute("isUnlocked") == true
                            and slot:GetAttribute("itemID") == nil
                            and not slot:GetAttribute("isBusy")
                        then
                            local holder = slot:FindFirstChild("Holder")
                            local pp = holder and holder:FindFirstChildWhichIsA("ProximityPrompt")
                            if pp then
                                notyuri("AutoCook: placing", heldID, "into", slot.Name)
                                FirePP(pp, true)
                                task.wait(0.5)
                            end
                            break
                        end
                    end
                end
            end
            for _, folderName in ipairs({"CraftTables", "Toasters"}) do
                local folder = plot:FindFirstChild(folderName)
                if folder then
                    for _, slot in ipairs(folder:GetChildren()) do
                        if not Toggles.AutoCook.Value then break end
                        if slot:IsA("Model")
                            and slot:GetAttribute("isUnlocked") == true
                            and slot:GetAttribute("itemID") ~= nil
                            and not slot:GetAttribute("isCooking")
                            and slot:GetAttribute("StartTime") == nil
                        then
                            notyuri("AutoCook: triggering cook on", slot.Name, "in", folderName)
                            TriggerCook(slot, folderName)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoCollect()
    while Toggles.AutoCollect.Value do
        local cb = FindCollectButton()
        if cb then
            local hitbox = cb:FindFirstChild("Hitbox")
            if hitbox then
                FireTI(hitbox)
            end
        end
        task.wait(1)
    end
end
local function Func_Dupe()
    while Toggles.Dupe.Value do
        local plot = FindPlot()
        if plot then
            local StartCookTimer = RemoteEventsFolder:FindFirstChild("StartCookTimer")
            if StartCookTimer then
                local toasters = plot:FindFirstChild("Toasters")
                if toasters then
                    for _, toaster in ipairs(toasters:GetChildren()) do
                        StartCookTimer:FireServer(toaster, "toasters")
                    end
                end
                local craftTables = plot:FindFirstChild("CraftTables")
                if craftTables then
                    for _, tbl in ipairs(craftTables:GetChildren()) do
                        StartCookTimer:FireServer(tbl, "craftTables")
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoStartCraft()
    while Toggles.AutoStartCraft.Value do
        FireEvent("startCraft", Plr)
        task.wait(3)
    end
end
local function Func_AutoClearCraft()
    while Toggles.AutoClearCraft.Value do
        FireEvent("clearCraft")
        task.wait(5)
    end
end
local function Func_AutoGroupReward()
    while Toggles.AutoGroupReward.Value do
        FireEvent("CheckGroupReward")
        task.wait(120)
    end
end
local function Func_AutoClickPage()
    while Toggles.AutoClickPage.Value do
        local plot = FindPlot()
        if plot then
            local binder = plot:FindFirstChild("Binder")
            if binder then
                local page1 = binder:FindFirstChild("Page1")
                if page1 then
                    local rightBtn = page1:FindFirstChild("RightButton", true)
                    if rightBtn then
                        FireEvent("ClickPageButton", rightBtn)
                    end
                end
            end
        end
        task.wait(2)
    end
end

local function DoSpawnOnce()
    local lever = FindSpawnLever()
    if lever then
        local base = lever:FindFirstChild("Base")
        local pp = base and base:FindFirstChildWhichIsA("ProximityPrompt")
        if pp then
            FirePP(pp, true)
        end
        Library:Notify("Spawned once.", 3)
    else
        Library:Notify("SpawnLever not found.", 3)
    end
end
local function DoCollectOnce()
    local cb = FindCollectButton()
    if cb then
        local hitbox = cb:FindFirstChild("Hitbox")
        if hitbox then
            FireTI(hitbox)
        end
        Library:Notify("Collected money.", 3)
    else
        Library:Notify("CollectButton not found.", 3)
    end
end
local function DoStartCraft()
    FireEvent("startCraft", Plr)
    Library:Notify("Craft started.", 3)
end
local function DoClearCraft()
    FireEvent("clearCraft")
    Library:Notify("Craft cleared.", 3)
end
local function DoTeleportHome()
    FireEvent("TeleportHome")
    Library:Notify("Teleporting home.", 3)
end
local function DoCheckGroupReward()
    FireEvent("CheckGroupReward")
    Library:Notify("Group reward check sent.", 3)
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
local function Func_AntiKick()
    if not getconnections then return end
    local function DisableKick(player)
        pcall(function()
            for _, conn in pairs(getconnections(player.OnTeleport)) do
                if conn.Enabled then conn:Disable() end
            end
        end)
        pcall(function()
            local KickEvent = player:FindFirstChild("KickEvent") or player:FindFirstChild("Kick")
            if KickEvent then
                for _, conn in pairs(getconnections(KickEvent.Event or KickEvent.OnClientEvent)) do
                    if conn.Enabled then conn:Disable() end
                end
            end
        end)
    end
    DisableKick(Plr)
end
local _hopThread = nil
local function Func_AutoServerhop()
    while Toggles.AutoServerhop.Value do
        local mins = Options.AutoHopMins.Value
        task.wait(mins * 60)
        if not Toggles.AutoServerhop.Value then break end
        local ok, result = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        end)
        if ok and result then
            local parsed = pcall(function()
                local data = Services.HttpService:JSONDecode(result)
                if data and data.data then
                    for _, server in ipairs(data.data) do
                        if server.id and server.playing < server.maxPlayers then
                            Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
                            return
                        end
                    end
                end
            end)
            if not parsed then
                Services.TeleportService:Teleport(game.PlaceId, Plr)
            end
        else
            Services.TeleportService:Teleport(game.PlaceId, Plr)
        end
    end
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
    local ok, result = pcall(function()
        return game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
    end)
    if ok and result then
        pcall(function()
            local data = Services.HttpService:JSONDecode(result)
            if data and data.data then
                for _, server in ipairs(data.data) do
                    if server.id and server.playing < server.maxPlayers then
                        Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
                        return
                    end
                end
            end
            Services.TeleportService:Teleport(game.PlaceId, Plr)
        end)
    else
        Services.TeleportService:Teleport(game.PlaceId, Plr)
    end
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCook", { Text = "Auto Cook", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("IngredientSelected", {
    Text = "Roll List",
    Values = _ingredientDropdownValues,
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect Money", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoOpenSlot", { Text = "Auto Open Slot", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("Dupe", { Text = "Dupe", Default = false })
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
Toggles.AutoRoll:OnChanged(function(v) Thread("AutoRoll", SafeLoop("AutoRoll", Func_AutoRoll), v) end)
Toggles.AutoCook:OnChanged(function(v) Thread("AutoCook", SafeLoop("AutoCook", Func_AutoCook), v) end)
Toggles.AutoCollect:OnChanged(function(v) Thread("AutoCollect", SafeLoop("AutoCollect", Func_AutoCollect), v) end)
Toggles.AutoOpenSlot:OnChanged(function(v) Thread("AutoOpenSlot", SafeLoop("AutoOpenSlot", Func_AutoOpenSlot), v) end)
Toggles.Dupe:OnChanged(function(v) Thread("Dupe", SafeLoop("Dupe", Func_Dupe), v) end)
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
Toggles.AntiKick:OnChanged(function(state)
    if state then Func_AntiKick() end
end)
if Toggles.AntiKick.Value then Func_AntiKick() end
Toggles.AutoServerhop:OnChanged(function(state)
    Thread("AutoServerhop", Func_AutoServerhop, state)
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
SaveManager:SetFolder("Yuri/MyGiantSandwich")
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
