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
local Lighting = Services.Lighting
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local CollectionService = Services.CollectionService
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
local function WaitForModule(parent, name, timeout)
    timeout = timeout or 15
    if not parent then return nil end
    local obj = parent:WaitForChild(name, timeout)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local NetModule = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Packages"), "Net", 15)
local function GetRE(name)
    if not NetModule then return nil end
    local ok, re = pcall(function() return NetModule:RemoteEvent(name) end)
    return ok and re or nil
end
local function GetRF(name)
    if not NetModule then return nil end
    local ok, rf = pcall(function() return NetModule:RemoteFunction(name) end)
    return ok and rf or nil
end
local Remotes = {
    EggPurchaseRequest = GetRE("EggPurchaseRequest"),
    RollRequest = GetRF("RollRequest"),
    EggPlaceRequest = GetRE("EggPlaceRequest"),
    AnimalPickUpRequest = GetRE("AnimalPickUpRequest"),
    SlotExpansionRequest = GetRE("SlotExpansionRequest"),
    InitializeHatch = GetRF("InitializeHatch"),
    CompleteHatch = GetRE("CompleteHatch"),
    FeedRequest = GetRE("FeedRequest"),
    FruitPickupRequest = GetRE("FruitPickupRequest"),
    PickUpCratesRequest = GetRE("PickUpCratesRequest"),
    SellCratesRequest = GetRE("SellCratesRequest"),
    SellAllRequest = GetRE("SellAllRequest"),
    AscendRequest = GetRE("AscendRequest"),
    UpgradePurchaseRequest = GetRE("UpgradePurchaseRequest"),
    CraftRequest = GetRE("CraftRequest"),
    BuyMerchandiseRequest = GetRE("BuyMerchandiseRequest"),
}
local Modules = {
    UpgradeTreeConfigs = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Data"), "UpgradeTreeConfigs"),
    CraftConfigs = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Data"), "CraftConfigs"),
    AnimalConfigs = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Data"), "AnimalConfigs"),
    SlotConfigs = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Data"), "SlotConfigs"),
    ExpansionConfigs = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Data"), "ExpansionConfigs"),
    RarityConfigs = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Data"), "RarityConfigs"),
    SpecialEggConfigs = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Data"), "SpecialEggConfigs"),
    MerchantConfigs = WaitForModule(RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Data"), "MerchantConfigs"),
    AscensionUtil = WaitForModule(RS:FindFirstChild("Modules"), "AscensionUtil"),
    AnimalUtil = WaitForModule(RS:FindFirstChild("Modules"), "AnimalUtil"),
    PlotUtil = WaitForModule(RS:FindFirstChild("Modules"), "PlotUtil"),
    MerchantUtil = WaitForModule(RS:FindFirstChild("Modules"), "MerchantUtil"),
    ReplicaHandler = WaitForModule(Plr:FindFirstChild("PlayerScripts") and Plr.PlayerScripts:FindFirstChild("Start"), "ReplicaHandler"),
}
local Flags = {}
local Shared = {
}
local Tables = {
    CraftList = { "Raptor", "Pinata Llama", "Cloudback Turtle", "Kraken" },
    CraftMap = { Raptor = "Raptor", ["Pinata Llama"] = "Pinata Llama", ["Cloudback Turtle"] = "Cloudback Turtle", Kraken = "Kraken" },
    EggList = {},
    EggMap = {},
    MerchantItemList = {},
    MerchantItemMap = {},
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local function AddMultiDropdown(group, id, config)
    config = config or {}
    local labelId = config.label
    group:AddDropdown(id, {
        Text = config.Text,
        Values = config.Values,
        Default = config.Default or {},
        Multi = true,
        Searchable = config.Searchable,
        Callback = config.Callback,
    })
    return function()
        local labels = (Options[id] and Options[id].Value) or {}
        local ids = {}
        for label, active in pairs(labels) do
            if active then
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
local function FireRemote(remote, ...)
    if not remote then return end
    local args = {...}
    pcall(function()
        remote:FireServer(unpack(args))
    end)
end
local function SafeInvoke(remote, ...)
    if not remote then return nil end
    local args = {...}
    local result = nil
    task.spawn(function()
        pcall(function()
            result = remote:InvokeServer(unpack(args))
        end)
    end)
    local start = tick()
    repeat task.wait() until result ~= nil or (tick() - start) > 2
    return result
end
local function GetData()
    local rh = Modules.ReplicaHandler
    if not rh then return nil end
    local ok, data = pcall(function() return rh.GetData() end)
    return ok and data or nil
end
local function CanAscend()
    local data = GetData()
    local util = Modules.AscensionUtil
    if not data or not util then return false end
    local ok, res = pcall(util.CanAscend, data)
    return ok and res or false
end
local function GetOwnedAnimalTools()
    local list = {}
    local containers = { Plr:FindFirstChildOfClass("Backpack"), GetCharacter() }
    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and Modules.AnimalUtil then
                    local ok, isAnimal = pcall(Modules.AnimalUtil.IsAnimal, item.Name)
                    if ok and isAnimal then
                        table.insert(list, item)
                    end
                end
            end
        end
    end
    return list
end
local function GetOwnedEggTools()
    local list = {}
    local containers = { Plr:FindFirstChildOfClass("Backpack"), GetCharacter() }
    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and Modules.AnimalUtil then
                    local ok, isEgg = pcall(Modules.AnimalUtil.IsEgg, item.Name)
                    if ok and isEgg then
                        table.insert(list, item)
                    end
                end
            end
        end
    end
    return list
end
local function EquipTool(tool)
    local char = GetCharacter()
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local ok = pcall(function()
        hum:UnequipTools()
        hum:EquipTool(tool)
    end)
    return ok
end
local function GetCraftToolsFor(craftName)
    local cfg = Modules.CraftConfigs
    if not cfg or not cfg[craftName] then return nil end
    local required = cfg[craftName].AnimalsRequired
    if not required then return nil end
    local owned = GetOwnedAnimalTools()
    local used = {}
    local picked = {}
    for _, reqName in ipairs(required) do
        local found = nil
        for _, tool in ipairs(owned) do
            if tool.Name == reqName and not used[tool] then
                found = tool
                break
            end
        end
        if not found then return nil end
        used[found] = true
        table.insert(picked, found)
    end
    return picked
end
local function WaitUntilAffordable(cost)
    while Toggles.AutoRoll.Value do
        local data = GetData()
        if not data or data.Coins == nil then return false end
        if data.Coins >= cost then return true end
        task.wait(0.5)
    end
    return false
end
local function NotifyRollResult(data)
    if not data or not data.CurrentEggs then return end
    local parts = {}
    for slotIdx, egg in pairs(data.CurrentEggs) do
        if egg then
            local mutation = (egg.Mutation and egg.Mutation ~= "Regular") and (" (" .. tostring(egg.Mutation) .. ")") or ""
            table.insert(parts, tostring(slotIdx) .. ": " .. tostring(egg.AnimalType) .. mutation)
        end
    end
    if #parts > 0 then
        table.sort(parts)
        Library:Notify("Rolled: " .. table.concat(parts, ", "), 4)
    end
end
local function Func_AutoRoll()
    while Toggles.AutoRoll.Value do
        local wanted = Shared.GetSelectedEggs and Shared.GetSelectedEggs() or {}
        SafeInvoke(Remotes.RollRequest)
        task.wait(0.3)
        local data = GetData()
        NotifyRollResult(data)
        if next(wanted) ~= nil then
            local cfg = Modules.AnimalConfigs
            if data and data.CurrentEggs and cfg then
                for slotIdx, egg in pairs(data.CurrentEggs) do
                    if egg and wanted[egg.AnimalType] and Toggles.AutoRoll.Value then
                        local animalCfg = cfg[egg.AnimalType]
                        local cost = animalCfg and animalCfg.Cost
                        if cost ~= nil then
                            if WaitUntilAffordable(cost) then
                                local currentData = GetData()
                                if currentData and currentData.CurrentEggs and currentData.CurrentEggs[slotIdx]
                                    and currentData.CurrentEggs[slotIdx].AnimalType == egg.AnimalType then
                                    FireRemote(Remotes.EggPurchaseRequest, slotIdx)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoHatch()
    while Toggles.AutoHatch.Value do
        local data = GetData()
        if data and data.Slots then
            for slotName, slot in pairs(data.Slots) do
                if slot and slot.Egg and (not slot.TimeLeft or slot.TimeLeft <= 0) then
                    SafeInvoke(Remotes.InitializeHatch, slotName)
                    FireRemote(Remotes.CompleteHatch, slotName)
                    task.wait(0.3)
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoSellAll()
    while Toggles.AutoSellAll.Value do
        FireRemote(Remotes.SellAllRequest)
        task.wait(2)
    end
end
local function GetAllSlotNames()
    local names = {}
    local expCfg = Modules.ExpansionConfigs
    if expCfg then
        for _, expansionCfg in pairs(expCfg) do
            for _, slotName in ipairs(expansionCfg.Slots or {}) do
                table.insert(names, slotName)
            end
        end
    end
    return names
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local wanted = Shared.GetSelectedPlaceEggs and Shared.GetSelectedPlaceEggs() or {}
        if next(wanted) ~= nil and Modules.AnimalUtil then
            local data = GetData()
            if data and data.UnlockedSlots and data.Slots then
                local eggTools = GetOwnedEggTools()
                for _, slotName in ipairs(GetAllSlotNames()) do
                    if data.UnlockedSlots[slotName] and not data.Slots[slotName] and Toggles.AutoPlace.Value then
                        local placed = false
                        for _, tool in ipairs(eggTools) do
                            local ok, animalType = pcall(Modules.AnimalUtil.GetEggType, tool.Name)
                            if ok and animalType and wanted[animalType] and not placed then
                                local currentData = GetData()
                                if currentData and currentData.UnlockedSlots[slotName] and not currentData.Slots[slotName] then
                                    if EquipTool(tool) then
                                        task.wait(0.2)
                                        FireRemote(Remotes.EggPlaceRequest, slotName)
                                        task.wait(0.2)
                                        placed = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoPickup()
    while Toggles.AutoPickup.Value do
        local wanted = Shared.GetSelectedPickupAnimals and Shared.GetSelectedPickupAnimals() or {}
        if next(wanted) ~= nil then
            local data = GetData()
            if data and data.Slots then
                for slotName, slot in pairs(data.Slots) do
                    if slot and not slot.Egg and slot.Animal and wanted[slot.Animal.AnimalType] and Toggles.AutoPickup.Value then
                        FireRemote(Remotes.AnimalPickUpRequest, slotName)
                        task.wait(0.2)
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoExpand()
    while Toggles.AutoExpand.Value do
        local data = GetData()
        local expCfg = Modules.ExpansionConfigs
        local slotCfg = Modules.SlotConfigs
        if data and data.UnlockedExpansions and data.UnlockedSlots and expCfg and slotCfg then
            for expansionName, expansionCfg in pairs(expCfg) do
                if data.UnlockedExpansions[expansionName] then
                    for _, slotName in ipairs(expansionCfg.Slots or {}) do
                        if not data.UnlockedSlots[slotName] and Toggles.AutoExpand.Value then
                            local cost = slotCfg[slotName] and slotCfg[slotName].Cost
                            if cost ~= nil then
                                local currentData = GetData()
                                if currentData and currentData.Coins ~= nil and currentData.Coins >= cost then
                                    FireRemote(Remotes.SlotExpansionRequest, slotName)
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoAscend()
    while Toggles.AutoAscend.Value do
        if CanAscend() then
            FireRemote(Remotes.AscendRequest)
            task.wait(2)
        end
        task.wait(1)
    end
end
local function Func_AutoCrate()
    while Toggles.AutoCrate.Value do
        local data = GetData()
        if data and data.CrateValue and data.CrateValue > 0 and not Plr:GetAttribute("CrateValue") then
            FireRemote(Remotes.PickUpCratesRequest)
            task.wait(1)
        end
        if Plr:GetAttribute("CrateValue") then
            FireRemote(Remotes.SellCratesRequest)
            task.wait(1)
        end
        task.wait(0.5)
    end
end
local function Func_AutoPickupFruit()
    while Toggles.AutoPickupFruit.Value do
        local ok, tagged = pcall(function()
            return game:GetService("CollectionService"):GetTagged("Fruit")
        end)
        if ok and tagged then
            for _, fruit in ipairs(tagged) do
                if fruit and fruit.Parent then
                    FireRemote(Remotes.FruitPickupRequest, fruit.Name)
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoCollectYen()
    while Toggles.AutoCollectYen.Value do
        local ok, tagged = pcall(function()
            return CollectionService:GetTagged("Yen")
        end)
        if ok and tagged then
            for _, yen in ipairs(tagged) do
                if yen and yen.Parent and Toggles.AutoCollectYen.Value then
                    TPTo(yen, Vector3.new(0, 3, 0))
                    task.wait(0.2)
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local data = GetData()
        local cfg = Modules.UpgradeTreeConfigs
        if data and cfg and cfg.Nodes and data.UpgradeTree then
            for nodeKey, node in pairs(cfg.Nodes) do
                if Toggles.AutoUpgrade.Value then
                    local owned = data.UpgradeTree[nodeKey]
                    local dependencyOwned = (not node.Dependency) or data.UpgradeTree[node.Dependency] ~= nil
                    if owned == nil and dependencyOwned and node.Cost and (data.Coins or 0) >= (node.Cost.Amount or 0) then
                        local currentData = GetData()
                        if currentData and currentData.UpgradeTree and currentData.UpgradeTree[nodeKey] == nil then
                            FireRemote(Remotes.UpgradePurchaseRequest, nodeKey)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoCraft()
    while Toggles.AutoCraft.Value do
        local selected = Shared.GetSelectedCrafts and Shared.GetSelectedCrafts() or {}
        if next(selected) then
            for craftName in pairs(selected) do
                local tools = GetCraftToolsFor(craftName)
                if tools then
                    FireRemote(Remotes.CraftRequest, craftName, tools)
                    task.wait(0.5)
                end
            end
        end
        task.wait(3)
    end
end
local function Func_AutoMerchant()
    while Toggles.AutoMerchant.Value do
        local selected = Shared.GetSelectedMerchantItems and Shared.GetSelectedMerchantItems() or {}
        local data = GetData()
        local cfg = Modules.MerchantConfigs
        local util = Modules.MerchantUtil
        if next(selected) and data and cfg and util and data.MerchantStock and data.MerchantStock.Levels then
            local playerLevel = util.GetLevel(data.MerchantXp or 0)
            for level = 1, #cfg do
                if not Toggles.AutoMerchant.Value then break end
                if playerLevel >= level then
                    local stockEntry = data.MerchantStock.Levels[level]
                    local levelCfg = cfg[level]
                    if stockEntry and levelCfg and levelCfg.Items and stockEntry.Stock and stockEntry.Stock > 0 then
                        local itemCfg = levelCfg.Items[stockEntry.ItemIndex]
                        if itemCfg and selected[itemCfg.ItemName] and (data.Coins or 0) >= (itemCfg.Cost or math.huge) then
                            FireRemote(Remotes.BuyMerchandiseRequest, level, stockEntry.ItemIndex)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
        task.wait(3)
    end
end
do
    local cfg = Modules.AnimalConfigs
    local specialCfg = Modules.SpecialEggConfigs
    local rarityCfg = Modules.RarityConfigs
    if cfg then
        local entries = {}
        for animalType, animalCfg in pairs(cfg) do
            local rarity = animalCfg.Rarity or "?"
            local order = (rarityCfg and rarityCfg[rarity] and rarityCfg[rarity].Order) or math.huge
            local label = tostring(animalType) .. " [" .. tostring(rarity) .. "]"
            table.insert(entries, { label = label, animalType = animalType, order = order })
        end
        if specialCfg then
            for eggType, eggCfg in pairs(specialCfg) do
                local rarity = eggCfg.Rarity or "?"
                local order = (rarityCfg and rarityCfg[rarity] and rarityCfg[rarity].Order) or math.huge
                local label = tostring(eggType) .. " [" .. tostring(rarity) .. "]"
                table.insert(entries, { label = label, animalType = eggType, order = order })
            end
        end
        table.sort(entries, function(a, b)
            if a.order ~= b.order then return a.order < b.order end
            return a.label < b.label
        end)
        for _, entry in ipairs(entries) do
            table.insert(Tables.EggList, entry.label)
            Tables.EggMap[entry.label] = entry.animalType
        end
    end
end
do
    local cfg = Modules.MerchantConfigs
    if cfg then
        local seen = {}
        for _, level in ipairs(cfg) do
            if level.Items then
                for _, item in ipairs(level.Items) do
                    local name = item.ItemName
                    if name and not seen[name] then
                        seen[name] = true
                        local label = tostring(name) .. " [" .. tostring(item.ItemType) .. "]"
                        table.insert(Tables.MerchantItemList, label)
                        Tables.MerchantItemMap[label] = name
                    end
                end
            end
        end
        table.sort(Tables.MerchantItemList)
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
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll" })
Shared.GetSelectedEggs = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "EggSelect", {
    Text = "Egg Select",
    Values = Tables.EggList,
    Default = {},
    Searchable = true,
    label = Tables.EggMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoHatch", { Text = "Auto Hatch" })
TB_Tabs.Autofarm.T1:AddToggle("AutoAscend", { Text = "Auto Ascend" })
TB_Tabs.Autofarm.T1:AddToggle("AutoCrate", { Text = "Auto Crate" })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickupFruit", { Text = "Auto Pickup Fruit" })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectYen", { Text = "Auto Collect Yen" })
TB_Tabs.Autofarm.T1:AddToggle("AutoExpand", { Text = "Auto Expand" })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place" })
Shared.GetSelectedPlaceEggs = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PlaceSelect", {
    Text = "Place Select",
    Values = Tables.EggList,
    Default = {},
    Searchable = true,
    label = Tables.EggMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup" })
Shared.GetSelectedPickupAnimals = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PickupSelect", {
    Text = "Pickup Select",
    Values = Tables.EggList,
    Default = {},
    Searchable = true,
    label = Tables.EggMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade" })
Shared.GetSelectedCrafts = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "CraftSelect", {
    Text = "Craft Select",
    Values = Tables.CraftList,
    Default = {},
    Searchable = false,
    label = Tables.CraftMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoCraft", { Text = "Auto Craft" })
TB_Tabs.Autofarm.T1:AddToggle("AutoMerchant", { Text = "Auto Merchant" })
Shared.GetSelectedMerchantItems = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "MerchantSelect", {
    Text = "Merchant Select",
    Values = Tables.MerchantItemList,
    Default = {},
    Searchable = true,
    label = Tables.MerchantItemMap,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoSellAll", { Text = "Auto Sell All" })
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
Toggles.AutoRoll:OnChanged(function(state) Thread("AutoRoll", SafeLoop("AutoRoll", Func_AutoRoll), state) end)
Toggles.AutoHatch:OnChanged(function(state) Thread("AutoHatch", SafeLoop("AutoHatch", Func_AutoHatch), state) end)
Toggles.AutoSellAll:OnChanged(function(state) Thread("AutoSellAll", SafeLoop("AutoSellAll", Func_AutoSellAll), state) end)
Toggles.AutoAscend:OnChanged(function(state) Thread("AutoAscend", SafeLoop("AutoAscend", Func_AutoAscend), state) end)
Toggles.AutoCrate:OnChanged(function(state) Thread("AutoCrate", SafeLoop("AutoCrate", Func_AutoCrate), state) end)
Toggles.AutoPickupFruit:OnChanged(function(state) Thread("AutoPickupFruit", SafeLoop("AutoPickupFruit", Func_AutoPickupFruit), state) end)
Toggles.AutoCollectYen:OnChanged(function(state) Thread("AutoCollectYen", SafeLoop("AutoCollectYen", Func_AutoCollectYen), state) end)
Toggles.AutoExpand:OnChanged(function(state) Thread("AutoExpand", SafeLoop("AutoExpand", Func_AutoExpand), state) end)
Toggles.AutoPlace:OnChanged(function(state) Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), state) end)
Toggles.AutoPickup:OnChanged(function(state) Thread("AutoPickup", SafeLoop("AutoPickup", Func_AutoPickup), state) end)
Toggles.AutoUpgrade:OnChanged(function(state) Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state) end)
Toggles.AutoCraft:OnChanged(function(state) Thread("AutoCraft", SafeLoop("AutoCraft", Func_AutoCraft), state) end)
Toggles.AutoMerchant:OnChanged(function(state) Thread("AutoMerchant", SafeLoop("AutoMerchant", Func_AutoMerchant), state) end)
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
SaveManager:SetFolder("Yuri/MAF")
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