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
local RemotesFolder = RS:FindFirstChild("Remotes") or RS:WaitForChild("Remotes", 10)
local function Remote(name)
    local r = RemotesFolder:FindFirstChild(name) or RemotesFolder:WaitForChild(name, 10)
    return r
end
local Remotes = {
    PromptInteract              = Remote("PromptInteract"),
    TreeClickerRequest          = Remote("TreeClickerRequest"),
    CrateRollPurchaseRequest    = Remote("CrateRollPurchaseRequest"),
    AutoRollRequest             = Remote("AutoRollRequest"),
    RollLuckUpgradeRequest      = Remote("RollLuckUpgradeRequest"),
    RollDropAreaUpgradeRequest  = Remote("RollDropAreaUpgradeRequest"),
    GearShopPurchaseRequest     = Remote("GearShopPurchaseRequest"),
    CosmeticShopPurchaseRequest = Remote("CosmeticShopPurchaseRequest"),
    RebirthRequest              = Remote("RebirthRequest"),
    HomeTeleportRequest         = Remote("HomeTeleportRequest"),
    InventoryDeleteRequest      = Remote("InventoryDeleteRequest"),
    PlaceFeedMachine            = Remote("PlaceFeedMachine"),
    PlaceFeedMachineResult      = Remote("PlaceFeedMachineResult"),
    ShovelDeleteRequest         = Remote("ShovelDeleteRequest"),
    FeedEditModeRequest         = Remote("FeedEditModeRequest"),
    FeedMoveRequest             = Remote("FeedMoveRequest"),
    FeedMoveResult              = Remote("FeedMoveResult"),
}
local function RequireShared(name)
    local shared = RS:FindFirstChild("Shared") or RS:WaitForChild("Shared", 10)
    if not shared then return nil end
    return GetSafeModule(shared, name)
end
local function RequireClientUI(name)
    local ps = Plr:WaitForChild("PlayerScripts", 5)
    local client = ps and ps:FindFirstChild("Client")
    if not client then return nil end
    local ui = client:FindFirstChild("ui")
    if not ui then return nil end
    return GetSafeModule(ui, name)
end
local Modules = {
    Remotes         = RequireShared("Remotes"),
    PlayerState     = RequireShared("PlayerState"),
    State           = RequireShared("State"),
    PetCatalog      = RequireShared("PetCatalog"),
    RebirthBalance  = RequireShared("RebirthBalance"),
    RollLuckBalance = RequireShared("RollLuckBalance"),
    RollDropAreaBalance = RequireShared("RollDropAreaBalance"),
    GearShopBalance     = RequireShared("GearShopBalance"),
    CosmeticShopBalance = RequireShared("CosmeticShopBalance"),
    Interactions    = RequireShared("Interactions"),
    Rarities        = RequireShared("Rarities"),
    ShopBalance     = RequireShared("ShopBalance"),
    Seeds           = RequireShared("Seeds"),
    GrowingVisuals  = RequireShared("GrowingVisuals"),
    PlayerStateStore = RequireClientUI("PlayerStateStore"),
    PlotResolver    = RequireClientUI("PlotResolver"),
    Shovel          = RequireShared("Shovel"),
}
local function GetCurrency()
    if not Modules.PlayerStateStore then return 0 end
    local f = Modules.PlayerState.Fields.Currency
    local v = Modules.PlayerStateStore.Get(f)
    return tonumber(v) or 0
end
local function GetRebirths()
    if not Modules.PlayerStateStore then return 0 end
    local v = Modules.PlayerStateStore.Get(Modules.PlayerState.Fields.Rebirths)
    return tonumber(v) or 0
end
local function GetRollLuckLevel()
    if not Modules.PlayerStateStore then return 0 end
    local v = Modules.PlayerStateStore.Get(Modules.PlayerState.Fields.RollLuckLevel)
    return tonumber(v) or 0
end
local function GetRollDropAreaLevel()
    if not Modules.PlayerStateStore then return 0 end
    local v = Modules.PlayerStateStore.Get(Modules.PlayerState.Fields.RollDropAreaLevel)
    return tonumber(v) or 0
end
local function GetPlot()
    if not Modules.PlotResolver then return nil end
    local ok, plot = pcall(Modules.PlotResolver.ResolveForPlayer, Plr)
    if ok then return plot end
    return nil
end
local ATTR = {
    FeedClass       = "FeedClass",
    FeedType        = "FeedType",
    FeedIndex       = "FeedIndex",
    PetIndex        = "PetIndex",
    PetID           = "PetID",
    XP              = "XP",
    MaxXP           = "MaxXP",
    Money           = "Money",
    MoneyRate       = "MoneyRate",
    EvolutionPaused = "PetEvolutionPaused",
    SeedID          = "SeedID",       
    SeedPhase       = "SeedPhase",    
    ToolGuid        = "ToolGuid",     
    GroundPile      = "TreeClickerGroundPile",
    GroundSlotIndex = "TreeClickerSlotIndex",
    GroundLocalVis  = "TreeClickerLocalVisual",
    FoodId          = "FoodId",       
}
local function GetPlotPets()
    local plot = GetPlot()
    if not plot then return {} end
    local pets = {}
    for _, child in ipairs(plot:GetChildren()) do
        if child:IsA("Model") and child:GetAttribute(ATTR.PetIndex) ~= nil then
            table.insert(pets, child)
        end
    end
    return pets
end
local function GetPlotTrees()
    local plot = GetPlot()
    if not plot then return {} end
    local trees = {}
    for _, child in ipairs(plot:GetChildren()) do
        if child:IsA("Model") and child:GetAttribute(ATTR.FeedClass) == "Tree" then
            table.insert(trees, child)
        end
    end
    return trees
end
local function GetPlotPatches()
    local plot = GetPlot()
    if not plot then return {} end
    local patches = {}
    for _, child in ipairs(plot:GetChildren()) do
        if child:IsA("Model") and child:GetAttribute(ATTR.FeedClass) == "Patch" then
            table.insert(patches, child)
        end
    end
    return patches
end
local function GetPlotFeedMachines()
    local plot = GetPlot()
    if not plot then return {} end
    local machines = {}
    for _, child in ipairs(plot:GetChildren()) do
        if child:IsA("Model") then
            local fc = child:GetAttribute(ATTR.FeedClass)
            if fc == "Processor" or fc == "JamBarrel" then
                table.insert(machines, child)
            end
        end
    end
    return machines
end
local function GetRollButton()
    local plot = GetPlot()
    if not plot then return nil end
    local ra = plot:FindFirstChild("RollArea")
    if not ra then return nil end
    local b1 = ra:FindFirstChild("Button")
    if not b1 then return nil end
    return b1:FindFirstChild("Button")
end
local function GetBestFoodTool()
    local bp = Plr:FindFirstChild("Backpack")
    if not bp then return nil end
    local best, bestXP = nil, -1
    for _, t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") then
            local xp = t:GetAttribute("XP")
            if xp and tonumber(xp) and tonumber(xp) > bestXP then
                best, bestXP = t, tonumber(xp)
            end
        end
    end
    return best
end
local function IsGroundPickupTarget(desc)
    if not (desc:IsA("BasePart") or desc:IsA("Model")) then return false end
    if desc:GetAttribute(ATTR.GroundPile) ~= true then return false end
    if desc:GetAttribute(ATTR.GroundLocalVis) == true then return false end
    if desc:GetAttribute(ATTR.GroundSlotIndex) == nil then return false end
    if desc:GetAttribute(ATTR.FoodId) == nil then return false end
    return desc.Parent ~= nil
end
local _reqCounter = 0
local function NextRequestId()
    _reqCounter = _reqCounter + 1
    return _reqCounter
end
local Flags = {}
local Shared = {
}
local Tables = {
}
local MinCollectXP = 0
local MaxCollectXP = 0
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
local function Func_AutoTreeShake()
    while Toggles.AutoTreeShake.Value do
        if Remotes.TreeClickerRequest then
            for _, tree in ipairs(GetPlotTrees()) do
                if not Toggles.AutoTreeShake.Value then break end
                pcall(function() Remotes.TreeClickerRequest:FireServer(tree) end)
                task.wait()
            end
        end
        task.wait()
    end
end
local function Func_AutoCollect()
    while Toggles.AutoCollect.Value do
        if Remotes.PromptInteract then
            local plot = GetPlot()
            if plot then
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                for _, patch in ipairs(GetPlotPatches()) do
                    if not Toggles.AutoCollect.Value then break end
                    local anchor = patch:FindFirstChild("SlotAnchor", true)
                    if anchor and anchor:IsA("BasePart") then
                        if MinCollectXP > 0 or MaxCollectXP > 0 then
                            local totalXP = 0
                            for _, food in ipairs(anchor:GetDescendants()) do
                                if food.Name == "XPLabel" and food:IsA("TextLabel") then
                                    local n = tonumber(food.Text:match("(%d+)"))
                                    if n then totalXP = totalXP + n end
                                end
                            end
                            if MinCollectXP > 0 and totalXP < MinCollectXP then
                                continue
                            end
                            if MaxCollectXP > 0 and totalXP > MaxCollectXP then
                                continue
                            end
                        end
                        if hrp then
                            hrp.CFrame = anchor.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.1)
                        end
                        pcall(function() Remotes.PromptInteract:FireServer("PatchHarvest", anchor, false) end)
                        task.wait(0.2)
                    end
                end
                for _, desc in ipairs(plot:GetDescendants()) do
                    if not Toggles.AutoCollect.Value then break end
                    if IsGroundPickupTarget(desc) then
                        if hrp then
                            local part = desc:IsA("BasePart") and desc or desc:FindFirstAncestorWhichIsA("BasePart")
                            if part then
                                hrp.CFrame = part.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.1)
                            end
                        end
                        pcall(function() Remotes.PromptInteract:FireServer("TreeGroundPickup", desc, false) end)
                        task.wait(0.15)
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoPetFeed()
    while Toggles.AutoPetFeed.Value do
        if Remotes.PromptInteract then
            local food = GetBestFoodTool()
            if food then
                for _, pet in ipairs(GetPlotPets()) do
                    if not Toggles.AutoPetFeed.Value then break end
                    local paused = pet:GetAttribute(ATTR.EvolutionPaused)
                    local xp = tonumber(pet:GetAttribute(ATTR.XP)) or 0
                    local maxXP = tonumber(pet:GetAttribute(ATTR.MaxXP)) or 0
                    if paused ~= true and xp < maxXP then
                        pcall(function() Remotes.PromptInteract:FireServer("PetFeed", pet, false) end)
                        task.wait()
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoFeedMachine()
    while Toggles.AutoFeedMachine.Value do
        if Remotes.PromptInteract then
            for _, machine in ipairs(GetPlotFeedMachines()) do
                if not Toggles.AutoFeedMachine.Value then break end
                pcall(function() Remotes.PromptInteract:FireServer("FeedMachine", machine) end)
                task.wait(0.3)
            end
        end
        task.wait(2)
    end
end
local RARITY_ORDER = { Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythical = 5, Secret = 6 }
local function GetSeedEntries()
    local entries = {}
    if not Modules.Seeds then return entries end
    local ok, ids = pcall(Modules.Seeds.AllSeedIds)
    if not ok or not ids then return entries end
    for _, id in ipairs(ids) do
        local ok2, displayName = pcall(Modules.Seeds.DisplayNameFor, id)
        if not ok2 or not displayName then continue end
        local rarity = ""
        local ok3, r = pcall(Modules.Seeds.RarityFor, id)
        if ok3 and r then rarity = r end
        local label = rarity ~= "" and (displayName .. " | " .. rarity) or displayName
        table.insert(entries, { label = label, id = id, name = displayName, rarity = rarity })
    end
    table.sort(entries, function(a, b)
        local ra = RARITY_ORDER[a.rarity] or 99
        local rb = RARITY_ORDER[b.rarity] or 99
        if ra ~= rb then return ra < rb end
        return a.name < b.name
    end)
    return entries
end
local function BuildSeedNameMap()
    local map = {}
    for _, entry in ipairs(GetSeedEntries()) do
        map[entry.label] = entry.id
    end
    return map
end
local function GetSeedDisplayNames()
    local names = {}
    for _, entry in ipairs(GetSeedEntries()) do
        table.insert(names, entry.label)
    end
    return names
end
local function GetGearDisplayNames()
    local names = {}
    if not Modules.GearShopBalance then return names end
    local ok, items = pcall(Modules.GearShopBalance.All)
    if not ok or not items then return names end
    for _, item in ipairs(items) do
        if item.FeedType then
            table.insert(names, item.FeedType)
        end
    end
    return names
end
local function Func_AutoCrateRoll()
    local nameToId = BuildSeedNameMap()
    while Toggles.AutoCrateRoll.Value do
        if Remotes.PromptInteract then
            local btn = GetRollButton()
            if not btn or not btn:IsA("BasePart") then
                task.wait(0.5)
                continue
            end
            local selectedNames = {}
            local filterActive = false
            local anySelected = false
            if Options.CrateRollSeedFilter then
                for label, active in pairs(Options.CrateRollSeedFilter.Value) do
                    if active then
                        if label == "Any" then
                            anySelected = true
                        else
                            selectedNames[label] = true
                            filterActive = true
                        end
                    end
                end
            end
            if anySelected then filterActive = false end
            local function scanOffers()
                local wanted = nil
                for _, desc in ipairs(workspace:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") and desc.Name == "RollOfferBuyPrompt"
                        and desc:GetAttribute("RollOfferPending") ~= true then
                        if not filterActive then
                            notyuri("[AutoCrateRoll] offer found (no filter)")
                            wanted = desc
                            break
                        end
                        local seedId = nil
                        local cur = desc
                        for _ = 1, 4 do
                            if not cur then break end
                            seedId = cur:GetAttribute(ATTR.SeedID)
                            if seedId then break end
                            cur = cur.Parent
                        end
                        if seedId and Modules.Seeds then
                            local ok, displayName = pcall(Modules.Seeds.DisplayNameFor, seedId)
                            if ok and displayName then
                                local ok2, rarity = pcall(Modules.Seeds.RarityFor, seedId)
                                local label = (ok2 and rarity and rarity ~= "") and (displayName .. " | " .. rarity) or displayName
                                local isWanted = selectedNames[label] or selectedNames[displayName]
                                notyuri("[AutoCrateRoll] Got:", label .. "(" .. (isWanted and "Wanted" or "Not") .. ")")
                                if isWanted then
                                    wanted = desc
                                    break
                                end
                            end
                        end
                    end
                end
                return wanted
            end
            local unavail = btn:GetAttribute("RollButtonUnavailable")
            if unavail == true then
                notyuri("[AutoCrateRoll] button unavailable, watching for offers during reveal...")
                local offerFoundDuringWait = nil
                while Toggles.AutoCrateRoll.Value and btn:GetAttribute("RollButtonUnavailable") == true do
                    local found = scanOffers()
                    if found then
                        offerFoundDuringWait = found
                        notyuri("[AutoCrateRoll] offer appeared during unavail window, handling now")
                        break
                    end
                    task.wait(0.1)
                end
                if not Toggles.AutoCrateRoll.Value then
                    task.wait(0.1)
                    continue
                end
                if offerFoundDuringWait then
                    local wantedOffer = offerFoundDuringWait
                    local price = tonumber(wantedOffer:GetAttribute("PromptPrice")) or 0
                    notyuri("[AutoCrateRoll] buying offer (from unavail window) | price:", price, "| currency:", GetCurrency())
                    if price > 0 then
                        while Toggles.AutoCrateRoll.Value and GetCurrency() < price do
                            notyuri("[AutoCrateRoll] waiting for currency | have:", GetCurrency(), "| need:", price)
                            task.wait(1)
                        end
                        if not Toggles.AutoCrateRoll.Value then task.wait(0.1) continue end
                    end
                    while Toggles.AutoCrateRoll.Value and wantedOffer and wantedOffer.Parent ~= nil
                        and wantedOffer:GetAttribute("RollOfferPending") ~= true do
                        notyuri("[AutoCrateRoll] firing buy prompt")
                        FirePP(wantedOffer, true)
                        task.wait(0.5)
                    end
                    notyuri("[AutoCrateRoll] offer bought or expired")
                    task.wait(0.1)
                    continue
                end
            end
            notyuri("[AutoCrateRoll] scanning offers | filterActive:", filterActive, "| anySelected:", anySelected)
            local wantedOffer = scanOffers()
            if wantedOffer then
                local price = tonumber(wantedOffer:GetAttribute("PromptPrice")) or 0
                notyuri("[AutoCrateRoll] buying offer | price:", price, "| currency:", GetCurrency())
                if price > 0 then
                    while Toggles.AutoCrateRoll.Value and GetCurrency() < price do
                        notyuri("[AutoCrateRoll] waiting for currency | have:", GetCurrency(), "| need:", price)
                        task.wait(1)
                    end
                    if not Toggles.AutoCrateRoll.Value then break end
                end
                while Toggles.AutoCrateRoll.Value and wantedOffer and wantedOffer.Parent ~= nil
                    and wantedOffer:GetAttribute("RollOfferPending") ~= true do
                    notyuri("[AutoCrateRoll] firing buy prompt")
                    FirePP(wantedOffer, true)
                    task.wait(0.5)
                end
                notyuri("[AutoCrateRoll] offer bought or expired")
            else
                local blockingOffer = nil
                for _, desc in ipairs(workspace:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") and desc.Name == "RollOfferBuyPrompt"
                        and desc:GetAttribute("RollOfferPending") ~= true then
                        blockingOffer = desc
                        break
                    end
                end
                if blockingOffer then
                    local seedId = nil
                    local cur = blockingOffer
                    for _ = 1, 4 do
                        if not cur then break end
                        seedId = cur:GetAttribute(ATTR.SeedID)
                        if seedId then break end
                        cur = cur.Parent
                    end
                    local offerName = seedId and Modules.Seeds and (function()
                        local ok, n = pcall(Modules.Seeds.DisplayNameFor, seedId) return ok and n or seedId
                    end)() or "unknown"
                    notyuri("[AutoCrateRoll] non-target offer blocking roll:", offerName, "| skipping this roll cycle")
                    do local _c = GetCharacter() local _h = _c and _c:FindFirstChild("HumanoidRootPart") if _h and btn then _h.CFrame = btn.CFrame * CFrame.new(0, 3, 0) task.wait(0.15) end end
                    pcall(function() Remotes.PromptInteract:FireServer("CrateRoll", btn) end)
                    task.wait(0.5)
                else
                    notyuri("[AutoCrateRoll] no offer present, firing roll")
                    do local _c = GetCharacter() local _h = _c and _c:FindFirstChild("HumanoidRootPart") if _h and btn then _h.CFrame = btn.CFrame * CFrame.new(0, 3, 0) task.wait(0.15) end end
                    pcall(function() Remotes.PromptInteract:FireServer("CrateRoll", btn) end)
                    task.wait(0.1)
                end
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoRollUpgrade()
    while Toggles.AutoRollUpgrade.Value do
        local selected = Options.AutoRollUpgradeTypes and Options.AutoRollUpgradeTypes.Value or {}
        local selectedMap = {}
        for name, active in pairs(selected) do
            if active then selectedMap[name] = true end
        end
        if selectedMap["Roll Luck"] and Remotes.RollLuckUpgradeRequest and Modules.RollLuckBalance then
            local level = GetRollLuckLevel()
            local currency = GetCurrency()
            local ok, state = pcall(Modules.RollLuckBalance.ToState, level, currency)
            if ok and state and state.price and currency >= state.price then
                pcall(function() Remotes.RollLuckUpgradeRequest:FireServer(NextRequestId()) end)
            end
        end
        if selectedMap["Drop Area"] and Remotes.RollDropAreaUpgradeRequest and Modules.RollDropAreaBalance then
            local level = GetRollDropAreaLevel()
            local currency = GetCurrency()
            local ok, state = pcall(Modules.RollDropAreaBalance.ToState, level, currency)
            if ok and state and state.price and currency >= state.price then
                pcall(function() Remotes.RollDropAreaUpgradeRequest:FireServer(NextRequestId()) end)
            end
        end
        task.wait(.01)
    end
end
local function GetUnlockedGridParts(plot)
    local parts = {}
    if not plot then return parts end
    for _, folderName in ipairs({"StarterArea", "GridAreas"}) do
        local folder = plot:FindFirstChild(folderName)
        if folder then
            for _, part in ipairs(folder:GetChildren()) do
                if part:IsA("BasePart") and part:GetAttribute("GridUnlocked") == true then
                    table.insert(parts, part)
                end
            end
        end
    end
    return parts
end
local function GetOccupiedCells(plot, floor)
    local occupied = {}
    if not plot or not floor then return occupied end
    for _, desc in ipairs(plot:GetDescendants()) do
        local isPlaced = false
        if desc:IsA("BasePart") or desc:IsA("Model") then
            local feedType  = desc:GetAttribute(ATTR.FeedType)
            local feedIndex = desc:GetAttribute(ATTR.FeedIndex)
            local seedPhase = desc:GetAttribute(ATTR.SeedPhase)
            isPlaced = (type(feedType) == "string" and feedType ~= "" and feedIndex ~= nil)
                    or (seedPhase ~= nil)
        end
        if isPlaced then
            local worldPos
            if desc:IsA("Model") then
                local ok, piv = pcall(function() return desc:GetPivot() end)
                if ok then worldPos = piv.Position end
            elseif desc:IsA("BasePart") then
                worldPos = desc.Position
            end
            if worldPos then
                local local3 = floor.CFrame:PointToObjectSpace(worldPos)
                local lx = math.round(local3.X)
                local lz = math.round(local3.Z)
                occupied[lx .. ":" .. lz] = true
            end
        end
    end
    return occupied
end
local function GetFeedTemplateSize(feedType)
    if not Modules.GrowingVisuals then return nil end
    local ok, tmpl = pcall(Modules.GrowingVisuals.FeedTemplateFor, feedType)
    if not ok or not tmpl then return nil end
    local hitbox = tmpl:FindFirstChild("EditSelectionHitbox")
    if hitbox and hitbox:IsA("BasePart") then
        return hitbox.Size.X, hitbox.Size.Z, hitbox.Size.Y / 2
    end
    if tmpl:IsA("Model") then
        local pp = tmpl.PrimaryPart
        if pp then return pp.Size.X, pp.Size.Z, pp.Size.Y / 2 end
        local ext = tmpl:GetExtentsSize()
        return ext.X, ext.Z, ext.Y / 2
    end
    if tmpl:IsA("BasePart") then
        return tmpl.Size.X, tmpl.Size.Z, tmpl.Size.Y / 2
    end
    return nil
end
local function GetOccupied(plot, floor)
    local occupied = {}
    if not plot or not floor then return occupied end
    for _, desc in ipairs(plot:GetDescendants()) do
        local isPlaced = false
        if desc:IsA("BasePart") or desc:IsA("Model") then
            local feedType  = desc:GetAttribute(ATTR.FeedType)
            local feedIndex = desc:GetAttribute(ATTR.FeedIndex)
            local seedPhase = desc:GetAttribute(ATTR.SeedPhase)
            isPlaced = (type(feedType) == "string" and feedType ~= "" and feedIndex ~= nil)
                    or (seedPhase ~= nil)
        end
        if isPlaced then
            local worldPos
            if desc:IsA("Model") then
                local ok, piv = pcall(function() return desc:GetPivot() end)
                if ok then worldPos = piv.Position end
            elseif desc:IsA("BasePart") then
                worldPos = desc.Position
            end
            if worldPos then
                local local3 = floor.CFrame:PointToObjectSpace(worldPos)
                local hxL, hxR, hzL, hzR = 0, 0, 0, 0
                local feedType = desc:GetAttribute(ATTR.FeedType)
                if type(feedType) == "string" and feedType ~= "" and Modules.GrowingVisuals then
                    local ok2, tmpl = pcall(Modules.GrowingVisuals.FeedTemplateFor, feedType)
                    if ok2 and tmpl then
                        local hitbox = tmpl:FindFirstChild("EditSelectionHitbox")
                        local fx, fz
                        if hitbox and hitbox:IsA("BasePart") then
                            fx = math.max(1, math.round(hitbox.Size.X))
                            fz = math.max(1, math.round(hitbox.Size.Z))
                        elseif tmpl:IsA("Model") and tmpl.PrimaryPart then
                            fx = math.max(1, math.round(tmpl.PrimaryPart.Size.X))
                            fz = math.max(1, math.round(tmpl.PrimaryPart.Size.Z))
                        elseif tmpl:IsA("BasePart") then
                            fx = math.max(1, math.round(tmpl.Size.X))
                            fz = math.max(1, math.round(tmpl.Size.Z))
                        end
                        if fx then
                            hxL = math.floor(fx / 2)
                            hxR = math.floor((fx - 1) / 2)
                            hzL = math.floor(fz / 2)
                            hzR = math.floor((fz - 1) / 2)
                        end
                    end
                end
                local cx = math.round(local3.X)
                local cz = math.round(local3.Z)
                for dx = -hxL, hxR do
                    for dz = -hzL, hzR do
                        occupied[(cx + dx) .. ":" .. (cz + dz)] = true
                    end
                end
            end
        end
    end
    return occupied
end
local function GetPlantFootprintCells(model, floor)
    local cells = {}
    if not model or not floor then return cells end
    local worldPos
    if model:IsA("Model") then
        local ok, piv = pcall(function() return model:GetPivot() end)
        if ok then worldPos = piv.Position end
    elseif model:IsA("BasePart") then
        worldPos = model.Position
    end
    if not worldPos then return cells end
    local local3 = floor.CFrame:PointToObjectSpace(worldPos)
    local feedType = model:GetAttribute(ATTR.FeedType)
    local hx, hz = 0, 0
    if type(feedType) == "string" and feedType ~= "" and Modules.GrowingVisuals then
        local ok2, tmpl = pcall(Modules.GrowingVisuals.FeedTemplateFor, feedType)
        if ok2 and tmpl then
            local hitbox = tmpl:FindFirstChild("EditSelectionHitbox")
            if hitbox and hitbox:IsA("BasePart") then
                hx = math.floor(hitbox.Size.X / 2 + 0.5)
                hz = math.floor(hitbox.Size.Z / 2 + 0.5)
            elseif tmpl:IsA("Model") and tmpl.PrimaryPart then
                hx = math.floor(tmpl.PrimaryPart.Size.X / 2 + 0.5)
                hz = math.floor(tmpl.PrimaryPart.Size.Z / 2 + 0.5)
            elseif tmpl:IsA("BasePart") then
                hx = math.floor(tmpl.Size.X / 2 + 0.5)
                hz = math.floor(tmpl.Size.Z / 2 + 0.5)
            end
        end
    end
    local cx = math.round(local3.X)
    local cz = math.round(local3.Z)
    for dx = -hx, hx do
        for dz = -hz, hz do
            cells[(cx + dx) .. ":" .. (cz + dz)] = true
        end
    end
    return cells
end
local function GetPlotFeedPlacements(filterTypes)
    local plot = GetPlot()
    if not plot then return {} end
    local results = {}
    for _, child in ipairs(plot:GetChildren()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            local feedType  = child:GetAttribute(ATTR.FeedType)
            local feedIndex = child:GetAttribute(ATTR.FeedIndex)
            if type(feedType) == "string" and feedType ~= "" and feedIndex ~= nil then
                if not filterTypes or next(filterTypes) == nil or filterTypes[feedType] then
                    table.insert(results, { model = child, feedType = feedType })
                end
            end
        end
    end
    return results
end
local function Func_AutoPlaceSeed()
    local nameToId = BuildSeedNameMap()
    local resultRemote = Remotes.PlaceFeedMachineResult
    while Toggles.AutoPlaceSeed.Value do
        local selected = Options.AutoPlaceSeedTypes and Options.AutoPlaceSeedTypes.Value or {}
        local wantedIds = {}
        local anySelected = false
        for label, active in pairs(selected) do
            if active then
                if label == "Any" then
                    anySelected = true
                else
                    local id = nameToId[label]
                    if id then wantedIds[id] = true end
                end
            end
        end
        if anySelected and Modules.Seeds then
            local ok, ids = pcall(Modules.Seeds.AllSeedIds)
            if ok and ids then
                for _, id in ipairs(ids) do wantedIds[id] = true end
            end
        end
        if next(wantedIds) == nil then task.wait(3) continue end
        local plot = GetPlot()
        if not plot then task.wait(3) continue end
        local bp = Plr:FindFirstChild("Backpack")
        if not bp then task.wait(3) continue end
        local wantedTools = {}
        local function scanForTools(container)
            for _, tool in ipairs(container:GetChildren()) do
                if not tool:IsA("Tool") then continue end
                local seedId = tool:GetAttribute(ATTR.SeedID)
                local guid   = tool:GetAttribute(ATTR.ToolGuid)
                if not (seedId and wantedIds[seedId] and guid) then continue end
                local feedType = nil
                if Modules.Seeds then
                    local ok, ft = pcall(Modules.Seeds.FeedTypeFor, seedId)
                    if ok then feedType = ft end
                end
                local sizeX, sizeZ, halfH = GetFeedTemplateSize(feedType)
                table.insert(wantedTools, {
                    tool     = tool,
                    guid     = guid,
                    feedType = feedType,
                    sizeX    = sizeX or 1,
                    sizeZ    = sizeZ or 1,
                    halfH    = halfH or 0.5,
                })
            end
        end
        scanForTools(bp)
        local char = Plr.Character
        if char then scanForTools(char) end
        notyuri("[AutoPlaceSeed] wanted tools:", #wantedTools)
        if #wantedTools == 0 then task.wait(3) continue end
        local floor = plot:FindFirstChild("Floor")
        if not floor then task.wait(3) continue end
        local gridParts = GetUnlockedGridParts(plot)
        notyuri("[AutoPlaceSeed] grid parts:", #gridParts)
        if #gridParts == 0 then task.wait(3) continue end
        local halfFloorX = math.floor(floor.Size.X / 2)
        local halfFloorZ = math.floor(floor.Size.Z / 2)
        local allCells = {}
        local cellSet = {}
        for lx = -halfFloorX, halfFloorX do
            for lz = -halfFloorZ, halfFloorZ do
                local worldPos = (floor.CFrame * CFrame.new(lx, 0, lz)).Position
                for _, gp in ipairs(gridParts) do
                    local local3 = gp.CFrame:PointToObjectSpace(worldPos)
                    if math.abs(local3.X) <= gp.Size.X / 2 + 0.001 and math.abs(local3.Z) <= gp.Size.Z / 2 + 0.001 then
                        local key = lx .. ":" .. lz
                        cellSet[key] = true
                        table.insert(allCells, { lx = lx, lz = lz })
                        break
                    end
                end
            end
        end
        notyuri("[AutoPlaceSeed] total grid cells:", #allCells)
        if #allCells == 0 then task.wait(3) continue end
        local sumLX, sumLZ = 0, 0
        for _, c in ipairs(allCells) do sumLX = sumLX + c.lx sumLZ = sumLZ + c.lz end
        local gridCenterLX = #allCells > 0 and sumLX / #allCells or 0
        local gridCenterLZ = #allCells > 0 and sumLZ / #allCells or 0
        local corners = {
            { sx = -1, sz = -1 }, { sx = -1, sz =  1 },
            { sx =  1, sz = -1 }, { sx =  1, sz =  1 },
        }
        local existingPlacements = GetPlotFeedPlacements(nil)
        local plantCenters = {}
        for _, entry in ipairs(existingPlacements) do
            if entry.model and entry.model.Parent then
                local worldPos
                if entry.model:IsA("Model") then
                    local ok, piv = pcall(function() return entry.model:GetPivot() end)
                    if ok then worldPos = piv.Position end
                elseif entry.model:IsA("BasePart") then
                    worldPos = entry.model.Position
                end
                if worldPos then
                    local local3 = floor.CFrame:PointToObjectSpace(worldPos)
                    table.insert(plantCenters, { lx = local3.X, lz = local3.Z })
                end
            end
        end
        local best, bestCount = corners[1], math.huge
        for _, corner in ipairs(corners) do
            local count = 0
            for _, pc in ipairs(plantCenters) do
                if ((pc.lx - gridCenterLX) * corner.sx >= 0) and ((pc.lz - gridCenterLZ) * corner.sz >= 0) then
                    count = count + 1
                end
            end
            if count < bestCount then
                bestCount = count
                best = corner
            end
        end
        table.sort(allCells, function(a, b)
            local colA = (a.lx - gridCenterLX) * best.sx
            local colB = (b.lx - gridCenterLX) * best.sx
            if colA ~= colB then return colA < colB end
            return ((a.lz - gridCenterLZ) * best.sz) < ((b.lz - gridCenterLZ) * best.sz)
        end)
        notyuri("[AutoPlaceSeed] corner: sx=", best.sx, "sz=", best.sz, "| existing plants in that quadrant:", bestCount)
        local occupied = GetOccupied(plot, floor)
        local function CanPlace(cx, cz, footX, footZ)
            local hx = math.floor(footX / 2)
            local hz = math.floor(footZ / 2)
            for dx = -hx, hx do
                for dz = -hz, hz do
                    local key = (cx + dx) .. ":" .. (cz + dz)
                    if not cellSet[key] or occupied[key] then
                        return false
                    end
                end
            end
            return true
        end
        local function MarkOccupied(cx, cz, footX, footZ)
            local hx = math.floor(footX / 2)
            local hz = math.floor(footZ / 2)
            for dx = -hx, hx do
                for dz = -hz, hz do
                    occupied[(cx + dx) .. ":" .. (cz + dz)] = true
                end
            end
        end
        local function GetCell(footX, footZ)
            for _, c in ipairs(allCells) do
                if CanPlace(c.lx, c.lz, footX, footZ) then
                    return c
                end
            end
            return nil
        end
        local PLACE_ERRORS = {
            busy = "Please wait before placing another feed machine",
            ["no-cosmetic-tool"] = "Equip a cosmetic before placing",
            ["no-feed-tool"] = "Equip a feed machine before placing",
            ["no-profile"] = "Your save data is not ready yet",
            ["out-of-bounds"] = "Place items inside unlocked plot cells",
            overlap = "That spot is already occupied",
            ["rate-limited"] = "Please wait before placing again",
            ["save-failed"] = "Could not save that placement. Please try again",
            ["setup-failed"] = "Could not set up that feed machine",
            timeout = "Placement took too long. Please try again",
            ["too-far"] = "Move closer to place that item",
        }
        for _, entry in ipairs(wantedTools) do
            if not Toggles.AutoPlaceSeed.Value then break end
            local footX = math.max(1, math.round(entry.sizeX))
            local footZ = math.max(1, math.round(entry.sizeZ))
            local cell = GetCell(footX, footZ)
            if not cell then
                notyuri("[AutoPlaceSeed] no free cell for feedType:", tostring(entry.feedType))
                break
            end
            local placeCF = floor.CFrame * CFrame.new(cell.lx, floor.Size.Y / 2 + entry.halfH, cell.lz)
            notyuri("[AutoPlaceSeed] placing | lx:", cell.lx, "| lz:", cell.lz, "| guid:", entry.guid, "| feedType:", tostring(entry.feedType))
            local char = Plr.Character
            if char then
                pcall(function() entry.tool.Parent = char end)
                task.wait()
            end
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = floor.CFrame * CFrame.new(cell.lx, floor.Size.Y / 2 + 3, cell.lz)
                task.wait()
            end
            local done = false
            local success = false
            local errCode = nil
            local conn
            if resultRemote then
                conn = resultRemote.OnClientEvent:Connect(function(_, resSuccess, resErr)
                    success = resSuccess == true
                    errCode = resErr
                    done = true
                end)
            end
            local reqId = NextRequestId()
            pcall(function()
                Remotes.PlaceFeedMachine:FireServer(reqId, placeCF, entry.guid)
            end)
            if conn then conn:Disconnect() end
            if success then
                notyuri("[AutoPlaceSeed] result | success: true")
                MarkOccupied(cell.lx, cell.lz, footX, footZ)
            else
                local msg = errCode and (PLACE_ERRORS[errCode] or errCode) or "timeout"
                notyuri("[AutoPlaceSeed] FAILED | code:", tostring(errCode), "-", msg, "| lx:", cell.lx, "lz:", cell.lz)
                if errCode == "overlap" then
                    MarkOccupied(cell.lx, cell.lz, footX, footZ)
                end
            end
            task.wait(0.3)
        end
        task.wait(.175)
    end
end
local function GetShovelTool()
    local function isShovel(t)
        return t:IsA("Tool") and t.Name == "Shovel" and t:GetAttribute("ToolKind") == "Shovel"
    end
    local bp = Plr:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if isShovel(t) then return t end
        end
    end
    local char = Plr.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if isShovel(t) then return t end
        end
    end
    return nil
end
local function Func_AutoRemovePlants()
    while Toggles.AutoRemovePlants.Value do
        local shovel = GetShovelTool()
        if not shovel then
            Library:Notify("Auto Remove: Shovel not found in backpack/character.", 4)
            task.wait(5)
            continue
        end
        local guid = shovel:GetAttribute(ATTR.ToolGuid)
        if not guid then
            Library:Notify("Auto Remove: Shovel has no ToolGuid.", 4)
            task.wait(5)
            continue
        end
        local selected = Options.AutoRemovePlantTypes and Options.AutoRemovePlantTypes.Value or {}
        local filterTypes = {}
        local filterActive = false
        local nameToId = BuildSeedNameMap()
        for displayName, active in pairs(selected) do
            if active then
                local seedId = nameToId[displayName]
                if seedId and Modules.Seeds then
                    local ok, ft = pcall(Modules.Seeds.FeedTypeFor, seedId)
                    if ok and ft then
                        filterTypes[ft] = true
                        filterActive = true
                    end
                end
            end
        end
        local placements = GetPlotFeedPlacements(filterActive and filterTypes or nil)
        notyuri("[AutoRemovePlants] placements found:", #placements, "| guid:", guid)
        if #placements == 0 then
            task.wait(5)
            continue
        end
        local char = Plr.Character
        if char then
            pcall(function() shovel.Parent = char end)
            task.wait(0.15)
        end
        for _, entry in ipairs(placements) do
            if not Toggles.AutoRemovePlants.Value then break end
            if not entry.model.Parent then continue end
            local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = entry.model:IsA("Model") and entry.model:GetPivot().Position or entry.model.Position
                hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                task.wait(0.15)
            end
            notyuri("[AutoRemovePlants] deleting:", entry.model.Name, "feedType:", entry.feedType)
            pcall(function()
                Remotes.ShovelDeleteRequest:FireServer(NextRequestId(), entry.model, guid)
            end)
            task.wait(0.4)
        end
        task.wait(3)
    end
end
local function Func_ReorganisePlot()
    local pinnedCorner = nil
    while Toggles.AutoReorganisePlot.Value do
        local plot = GetPlot()
        if not plot then task.wait(5) continue end
        local floor = plot:FindFirstChild("Floor")
        if not floor then task.wait(5) continue end
        local placements = GetPlotFeedPlacements(nil)
        notyuri("[ReorganisePlot] placements found:", #placements)
        if #placements == 0 then task.wait(10) continue end
        local gridParts = GetUnlockedGridParts(plot)
        if #gridParts == 0 then task.wait(10) continue end
        local plotModel = plot:FindFirstChildOfClass("Model")
        local plotCenterCF = plotModel and plotModel:GetPivot()
        repeat
            local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and plotCenterCF then hrp.CFrame = plotCenterCF end
            pcall(function() Remotes.FeedEditModeRequest:FireServer(true) end)
            task.wait(0.175)
        until Plr:GetAttribute("EditMode") == true
        local halfFloorX = math.floor(floor.Size.X / 2)
        local halfFloorZ = math.floor(floor.Size.Z / 2)
        local allCells = {}
        local cellSet = {} 
        for lx = -halfFloorX, halfFloorX do
            for lz = -halfFloorZ, halfFloorZ do
                local worldPos = (floor.CFrame * CFrame.new(lx, 0, lz)).Position
                for _, gp in ipairs(gridParts) do
                    local local3 = gp.CFrame:PointToObjectSpace(worldPos)
                    if math.abs(local3.X) <= gp.Size.X / 2 + 0.001 and math.abs(local3.Z) <= gp.Size.Z / 2 + 0.001 then
                        local key = lx .. ":" .. lz
                        cellSet[key] = true
                        table.insert(allCells, { lx = lx, lz = lz })
                        break
                    end
                end
            end
        end
        local sumLX, sumLZ = 0, 0
        for _, c in ipairs(allCells) do
            sumLX = sumLX + c.lx
            sumLZ = sumLZ + c.lz
        end
        local gridCenterLX = #allCells > 0 and sumLX / #allCells or 0
        local gridCenterLZ = #allCells > 0 and sumLZ / #allCells or 0
        notyuri("[ReorganisePlot] grid center: lx=" .. math.floor(gridCenterLX) .. " lz=" .. math.floor(gridCenterLZ))
        local occupied = GetOccupied(plot, floor)
        local MOVE_ERRORS = {
            busy = "Please wait before moving another machine",
            ["invalid-target"] = "That machine cannot be moved",
            ["not-editing"] = "Enable edit mode before moving machines",
            ["out-of-bounds"] = "Keep machines inside unlocked plot cells",
            overlap = "That spot is already occupied",
            ["rate-limited"] = "Please wait before moving again",
            ["save-failed"] = "Could not save that move. Please try again",
            ["too-far"] = "Move closer to place that machine there",
        }
        local function CanPlace(cx, cz, footX, footZ, sizeX, sizeZ)
            local hxL = math.floor(footX / 2)
            local hxR = math.floor((footX - 1) / 2)
            local hzL = math.floor(footZ / 2)
            local hzR = math.floor((footZ - 1) / 2)
            for dx = -hxL, hxR do
                for dz = -hzL, hzR do
                    local key = (cx + dx) .. ":" .. (cz + dz)
                    if not cellSet[key] or occupied[key] then
                        return false
                    end
                end
            end
            if sizeX and sizeZ then
                local halfX = sizeX / 2
                local halfZ = sizeZ / 2
                local centerCF = floor.CFrame * CFrame.new(cx, 0, cz)
                for _, sx in ipairs({ -1, 1 }) do
                    for _, sz in ipairs({ -1, 1 }) do
                        local corner = centerCF:PointToWorldSpace(Vector3.new(sx * halfX, 0, sz * halfZ))
                        local inside = false
                        for _, gp in ipairs(gridParts) do
                            local lp = gp.CFrame:PointToObjectSpace(corner)
                            if math.abs(lp.X) <= gp.Size.X / 2 + 0.001 and math.abs(lp.Z) <= gp.Size.Z / 2 + 0.001 then
                                inside = true
                                break
                            end
                        end
                        if not inside then return false end
                    end
                end
            end
            return true
        end
        local function IsOccupied(cx, cz, footX, footZ)
            local hxL = math.floor(footX / 2)
            local hxR = math.floor((footX - 1) / 2)
            local hzL = math.floor(footZ / 2)
            local hzR = math.floor((footZ - 1) / 2)
            for dx = -hxL, hxR do
                for dz = -hzL, hzR do
                    occupied[(cx + dx) .. ":" .. (cz + dz)] = true
                end
            end
        end
        local function SortCells()
            local corners = {
                { sx = -1, sz = -1 },
                { sx = -1, sz =  1 },
                { sx =  1, sz = -1 },
                { sx =  1, sz =  1 },
            }
            local plantCenters = {}
            for _, entry in ipairs(placements) do
                if entry.model and entry.model.Parent then
                    local worldPos
                    if entry.model:IsA("Model") then
                        local ok, piv = pcall(function() return entry.model:GetPivot() end)
                        if ok then worldPos = piv.Position end
                    elseif entry.model:IsA("BasePart") then
                        worldPos = entry.model.Position
                    end
                    if worldPos then
                        local local3 = floor.CFrame:PointToObjectSpace(worldPos)
                        table.insert(plantCenters, { lx = local3.X, lz = local3.Z })
                    end
                end
            end
            local best, bestCount = corners[1], math.huge
            if pinnedCorner then
                best = pinnedCorner
                notyuri("[ReorganisePlot] reusing pinned corner: sx=" .. best.sx .. " sz=" .. best.sz)
            else
                for _, corner in ipairs(corners) do
                    local count = 0
                    for _, pc in ipairs(plantCenters) do
                        if ((pc.lx - gridCenterLX) * corner.sx >= 0) and ((pc.lz - gridCenterLZ) * corner.sz >= 0) then
                            count = count + 1
                        end
                    end
                    if count < bestCount then
                        bestCount = count
                        best = corner
                    end
                end
                pinnedCorner = best
                notyuri("[ReorganisePlot] pinned freest corner: sx=" .. best.sx .. " sz=" .. best.sz .. " occupied=" .. bestCount)
            end
            table.sort(allCells, function(a, b)
                local colA = (a.lx - gridCenterLX) * best.sx
                local colB = (b.lx - gridCenterLX) * best.sx
                if colA ~= colB then return colA < colB end
                return ((a.lz - gridCenterLZ) * best.sz) < ((b.lz - gridCenterLZ) * best.sz)
            end)
        end
        local function GetCell(footX, footZ, sizeX, sizeZ)
            for _, c in ipairs(allCells) do
                if CanPlace(c.lx, c.lz, footX, footZ, sizeX, sizeZ) then
                    return c
                end
            end
            return nil
        end
        local moveResultRemote = Remotes.FeedMoveResult
        local function DoMove(plantModel, targetCF, targetLX, targetLZ)
            local done = false
            local success = false
            local errCode = nil
            local conn
            local reqId = NextRequestId()
            if moveResultRemote then
                conn = moveResultRemote.OnClientEvent:Connect(function(resReqId, resSuccess, resErr)
                    if resReqId ~= reqId then return end
                    success = resSuccess == true
                    errCode = resErr
                    done = true
                end)
            end
            pcall(function()
                Remotes.FeedMoveRequest:FireServer(reqId, plantModel, targetCF)
            end)
            local t0 = tick()
            while not done and tick() - t0 < 2 do
                task.wait(0.1)
            end
            if conn then conn:Disconnect() end
            if not success then
                local msg = errCode and (MOVE_ERRORS[errCode] or errCode) or "timeout"
                notyuri("[ReorganisePlot] move FAILED:", plantModel.Name, "code:", tostring(errCode), "-", msg)
            end
            return success, errCode
        end
        local restartNeeded = false
        occupied = GetOccupied(plot, floor)
        SortCells()
        notyuri("[ReorganisePlot] Phase 2: placing plants into grid (position-centric)")
        local unplaced = {}
        for _, entry in ipairs(placements) do
            if entry.model and entry.model.Parent then
                local sizeX, sizeZ, halfH = GetFeedTemplateSize(entry.feedType)
                sizeX = sizeX or 1
                sizeZ = sizeZ or 1
                halfH = halfH or 0.5
                local footX = math.max(1, math.round(sizeX))
                local footZ = math.max(1, math.round(sizeZ))
                table.insert(unplaced, {
                    entry = entry,
                    sizeX = sizeX, sizeZ = sizeZ, halfH = halfH,
                    footX = footX, footZ = footZ,
                })
            end
        end
        notyuri("[ReorganisePlot] Phase 2: unplaced count:", #unplaced)
        local failedPlants = {}
        local ci = 1
        while ci <= #allCells do
            if not Toggles.AutoReorganisePlot.Value then break end
            if not Plr:GetAttribute("EditMode") then
                notyuri("[ReorganisePlot] EditMode lost during Phase 2, restarting")
                restartNeeded = true
                break
            end
            if #unplaced == 0 then break end
            local cell = allCells[ci]
            local matchIdx = nil
            local pi = 1
            while pi <= #unplaced do
                local p = unplaced[pi]
                if p.entry.model and p.entry.model.Parent then
                    if CanPlace(cell.lx, cell.lz, p.footX, p.footZ, p.sizeX, p.sizeZ) then
                        matchIdx = pi
                        break
                    end
                    pi = pi + 1
                else
                    table.remove(unplaced, pi)
                end
            end
            if not matchIdx then
                ci = ci + 1
                task.wait()
                continue
            end
            local p = unplaced[matchIdx]
            local entry = p.entry
            local targetLX = cell.lx
            local targetLZ = cell.lz
            local targetCF = floor.CFrame * CFrame.new(targetLX, floor.Size.Y / 2 + p.halfH, targetLZ)
            local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = targetCF * CFrame.new(0, 3, 0)
                task.wait(.175)
            end
            local oldCells = GetPlantFootprintCells(entry.model, floor)
            notyuri("[ReorganisePlot] moving:", entry.model.Name, "-> lx:", targetLX, "lz:", targetLZ, "foot:", p.footX, "x", p.footZ)
            local success, errCode = DoMove(entry.model, targetCF, targetLX, targetLZ)
            if success then
                for key in pairs(oldCells) do
                    occupied[key] = nil
                end
                IsOccupied(cell.lx, cell.lz, p.footX, p.footZ)
                notyuri("[ReorganisePlot] move confirmed:", entry.model.Name)
                table.remove(unplaced, matchIdx)
                ci = ci + 1
            elseif errCode == "overlap" then
                notyuri("[ReorganisePlot] overlap for:", entry.model.Name, "at lx:", targetLX, "lz:", targetLZ, "- marking occupied, skipping cell")
                IsOccupied(targetLX, targetLZ, p.footX, p.footZ)
                ci = ci + 1
            else
                notyuri("[ReorganisePlot] skipping:", entry.model.Name, "code:", tostring(errCode))
                table.remove(unplaced, matchIdx)
                ci = ci + 1
            end
            task.wait()
        end
        for _, p in ipairs(unplaced) do
            if p.entry.model and p.entry.model.Parent then
                notyuri("[ReorganisePlot] no valid cell found for:", p.entry.model.Name, "foot:", p.footX, "x", p.footZ)
                table.insert(failedPlants, p.entry.model.Name)
            end
        end
        if #failedPlants > 0 then
            notyuri("[ReorganisePlot] plants that could not be placed:", table.concat(failedPlants, ", "))
        end
        if restartNeeded then continue end
        occupied = GetOccupied(plot, floor)
        local remaining = GetPlotFeedPlacements(nil)
        local allPlaced = true
        local checkList = {}
        for _, entry in ipairs(remaining) do
            if not (entry.model and entry.model.Parent) then continue end
            local worldPos
            if entry.model:IsA("Model") then
                local ok2, piv = pcall(function() return entry.model:GetPivot() end)
                if ok2 then worldPos = piv.Position end
            elseif entry.model:IsA("BasePart") then
                worldPos = entry.model.Position
            end
            if not worldPos then continue end
            local local3 = floor.CFrame:PointToObjectSpace(worldPos)
            local curLX = math.round(local3.X)
            local curLZ = math.round(local3.Z)
            local sizeX, sizeZ = GetFeedTemplateSize(entry.feedType)
            sizeX = sizeX or 1
            sizeZ = sizeZ or 1
            local footX = math.max(1, math.round(sizeX))
            local footZ = math.max(1, math.round(sizeZ))
            table.insert(checkList, {
                entry = entry,
                curLX = curLX, curLZ = curLZ,
                footX = footX, footZ = footZ,
                sizeX = sizeX, sizeZ = sizeZ,
                assigned = false,
            })
        end
        local checkOccupied = GetOccupied(plot, floor)
        for _, c in ipairs(checkList) do
            local hxL = math.floor(c.footX / 2)
            local hxR = math.floor((c.footX - 1) / 2)
            local hzL = math.floor(c.footZ / 2)
            local hzR = math.floor((c.footZ - 1) / 2)
            for dx = -hxL, hxR do
                for dz = -hzL, hzR do
                    checkOccupied[(c.curLX + dx) .. ":" .. (c.curLZ + dz)] = nil
                end
            end
        end
        for _, c in ipairs(checkList) do
            local hxL = math.floor(c.footX / 2)
            local hxR = math.floor((c.footX - 1) / 2)
            local hzL = math.floor(c.footZ / 2)
            local hzR = math.floor((c.footZ - 1) / 2)
            local inValidCell = true
            for dx = -hxL, hxR do
                for dz = -hzL, hzR do
                    if not cellSet[(c.curLX + dx) .. ":" .. (c.curLZ + dz)] then
                        inValidCell = false
                        break
                    end
                end
                if not inValidCell then break end
            end
            if not inValidCell then
                allPlaced = false
                notyuri("[ReorganisePlot] still unorganised:", c.entry.model.Name, "cur:", c.curLX, c.curLZ, "(not in valid grid cell)")
            end
            for dx = -hxL, hxR do
                for dz = -hzL, hzR do
                    checkOccupied[(c.curLX + dx) .. ":" .. (c.curLZ + dz)] = true
                end
            end
        end
        if allPlaced then
            pcall(function() Remotes.FeedEditModeRequest:FireServer(false) end)
            Library:Notify("Reorganise complete.", 3)
            notyuri("[ReorganisePlot] all plants organised, done")
            Toggles.AutoReorganisePlot:SetValue(false)
        else
            notyuri("[ReorganisePlot] some plants still unorganised, retrying...")
            task.wait(1)
        end
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        if Remotes.RebirthRequest and Modules.RebirthBalance then
            local rebirths = GetRebirths()
            local ok, tierNum, tier = pcall(Modules.RebirthBalance.GetNextTier, rebirths)
            if ok and tier and tier.Price then
                if GetCurrency() >= tier.Price then
                    pcall(function() Remotes.RebirthRequest:FireServer(NextRequestId()) end)
                    notyuri("[AutoRebirth] rebirthed at tier", tierNum, "for", tier.Price)
                    task.wait()
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoGearShop()
    while Toggles.AutoGearShop.Value do
        if Remotes.GearShopPurchaseRequest and Modules.GearShopBalance then
            local selected = Options.AutoGearShopTypes and Options.AutoGearShopTypes.Value or {}
            local selectedMap = {}
            local filterActive = false
            for name, active in pairs(selected) do
                if active then
                    selectedMap[name] = true
                    filterActive = true
                end
            end
            local ok, items = pcall(Modules.GearShopBalance.All)
            if ok and items then
                for _, item in ipairs(items) do
                    if not Toggles.AutoGearShop.Value then break end
                    if filterActive and not selectedMap[item.FeedType] then continue end
                    if item.Price and GetCurrency() >= item.Price and (item.RequiredRebirths or 0) <= GetRebirths() then
                        pcall(function() Remotes.GearShopPurchaseRequest:FireServer(NextRequestId(), item.FeedType) end)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(5)
    end
end
local function Func_AutoCosmeticShop()
    while Toggles.AutoCosmeticShop.Value do
        if Remotes.CosmeticShopPurchaseRequest and Modules.CosmeticShopBalance then
            local ok, items = pcall(Modules.CosmeticShopBalance.All)
            if ok and items then
                for _, item in ipairs(items) do
                    if not Toggles.AutoCosmeticShop.Value then break end
                    if item.Price and GetCurrency() >= item.Price then
                        pcall(function() Remotes.CosmeticShopPurchaseRequest:FireServer(NextRequestId(), item.ItemID) end)
                        task.wait(0.5)
                    end
                end
            end
        end
        task.wait(5)
    end
end
local function EnableBuiltinAutoRoll()
    if not Remotes.AutoRollRequest then Library:Notify("AutoRoll remote not ready.", 3) return end
    local rebirths = GetRebirths()
    if rebirths < 1 then
        Library:Notify("AutoRoll requires >= 1 rebirth.", 4)
        return
    end
    pcall(function()
        Remotes.AutoRollRequest:FireServer({
            action = "start",
            autoPurchase = true,
            selectedRarities = {},
        })
    end)
end
local function StopBuiltinAutoRoll()
    if not Remotes.AutoRollRequest then return end
    pcall(function()
        Remotes.AutoRollRequest:FireServer({ action = "stop", autoPurchase = false, selectedRarities = {} })
    end)
    Library:Notify("Built-in AutoRoll stopped.", 3)
end
local function HomeTeleport()
    if not Remotes.HomeTeleportRequest then return end
    pcall(function() Remotes.HomeTeleportRequest:FireServer() end)
    Library:Notify("Teleported home.", 3)
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
        T1 = TB.Main.Left.Autofarm:AddTab("Farm"),
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
TB_Tabs.Autofarm.T1:AddToggle("AutoTreeShake", { Text = "Auto Shake", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPetFeed", { Text = "Auto Feed", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCrateRoll", { Text = "Auto Roll", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("CrateRollSeedFilter", {
    Text = "Roll List",
    Values = (function() local v = {"Any"} for _, n in ipairs(GetSeedDisplayNames()) do table.insert(v, n) end return v end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRollUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoRollUpgradeTypes", {
    Text = "Upgrade List",
    Values = { "Roll Luck", "Drop Area" },
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPlaceSeed", { Text = "Auto Place", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoPlaceSeedTypes", {
    Text = "Place Seed",
    Values = (function() local v = {"Any"} for _, n in ipairs(GetSeedDisplayNames()) do table.insert(v, n) end return v end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRemovePlants", { Text = "Auto Remove", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoRemovePlantTypes", {
    Text = "Remove List",
    Values = GetSeedDisplayNames(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoReorganisePlot", { Text = "Reorganise Plot", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoGearShop", { Text = "Auto Buy Gear", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoGearShopTypes", {
    Text = "Gear List",
    Values = GetGearDisplayNames(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm2.T1:AddInput("MinCollectXPInput", {
    Text = "Min XP to Collect",
    Default = "0",
    Placeholder = "Min XP",
    Callback = function(Value)
        local number = tonumber(Value)
        if number then
            MinCollectXP = number
        end
    end,
})
TB_Tabs.Autofarm2.T1:AddInput("MaxCollectXPInput", {
    Text = "Max XP to Collect",
    Default = "0",
    Callback = function(Value)
        local number = tonumber(Value)
        if number then
            MaxCollectXP = number
        end
    end,
})
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
Toggles.AutoTreeShake:OnChanged(function(v)
    Thread("AutoTreeShake", SafeLoop("AutoTreeShake", Func_AutoTreeShake), v)
end)
Toggles.AutoCollect:OnChanged(function(v)
    Thread("AutoCollect", SafeLoop("AutoCollect", Func_AutoCollect), v)
end)
Toggles.AutoPetFeed:OnChanged(function(v)
    Thread("AutoPetFeed", SafeLoop("AutoPetFeed", Func_AutoPetFeed), v)
end)
Toggles.AutoCrateRoll:OnChanged(function(v)
    Thread("AutoCrateRoll", SafeLoop("AutoCrateRoll", Func_AutoCrateRoll), v)
end)
Toggles.AutoRollUpgrade:OnChanged(function(v)
    Thread("AutoRollUpgrade", SafeLoop("AutoRollUpgrade", Func_AutoRollUpgrade), v)
end)
Toggles.AutoPlaceSeed:OnChanged(function(v)
    Thread("AutoPlaceSeed", SafeLoop("AutoPlaceSeed", Func_AutoPlaceSeed), v)
end)
Toggles.AutoRemovePlants:OnChanged(function(v)
    Thread("AutoRemovePlants", SafeLoop("AutoRemovePlants", Func_AutoRemovePlants), v)
end)
Toggles.AutoReorganisePlot:OnChanged(function(v)
    Thread("AutoReorganisePlot", SafeLoop("AutoReorganisePlot", Func_ReorganisePlot), v)
end)
Toggles.AutoRebirth:OnChanged(function(v)
    Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v)
end)
Toggles.AutoGearShop:OnChanged(function(v)
    Thread("AutoGearShop", SafeLoop("AutoGearShop", Func_AutoGearShop), v)
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
SaveManager:SetFolder("Yuri/BuildAPetFarm")
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
