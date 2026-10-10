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
local Backpack = Plr:WaitForChild("Backpack")
local Lighting = Services.Lighting
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
local Remotes = {
    RequestInteraction = (RS:FindFirstChild("ASMRRewardRemotes") and RS.ASMRRewardRemotes:FindFirstChild("RequestInteraction")),
    RequestUpgrade = (RS:FindFirstChild("ASMRRewardRemotes") and RS.ASMRRewardRemotes:FindFirstChild("RequestUpgrade")),
    RequestPlaceCrate = (RS:FindFirstChild("CratePlacementRemotes") and RS.CratePlacementRemotes:FindFirstChild("RequestPlaceCrate")),
    RequestPlaceASMR = (RS:FindFirstChild("ASMRPlacementRemotes") and RS.ASMRPlacementRemotes:FindFirstChild("RequestPlaceASMR")),
    RequestPickupASMR = (RS:FindFirstChild("ASMRPlacementRemotes") and RS.ASMRPlacementRemotes:FindFirstChild("RequestPickupASMR")),
    ChangeConveyorRequest = (RS:FindFirstChild("PlotSystemRemotes") and RS.PlotSystemRemotes:FindFirstChild("ChangeConveyorRequest")),
    ConveyorButtonPress = (RS:FindFirstChild("PlotSystemRemotes") and RS.PlotSystemRemotes:FindFirstChild("ConveyorButtonPress")),
    SetSpeedBoost = (RS:FindFirstChild("MonetizationRemotes") and RS.MonetizationRemotes:FindFirstChild("SetSpeedBoost")),
    BuyWorker = (RS:FindFirstChild("WorkerRemotes") and RS.WorkerRemotes:FindFirstChild("BuyWorker")),
    AssignWorker = (RS:FindFirstChild("WorkerRemotes") and RS.WorkerRemotes:FindFirstChild("AssignWorker")),
    RequestRebirth = (RS:FindFirstChild("RebirthRemotes") and RS.RebirthRemotes:FindFirstChild("RequestRebirth")),
    RequestSkipRebirth = (RS:FindFirstChild("RebirthRemotes") and RS.RebirthRemotes:FindFirstChild("RequestSkipRebirth")),
    GetRebirthState = (RS:FindFirstChild("RebirthRemotes") and RS.RebirthRemotes:FindFirstChild("GetRebirthState")),
    ClaimDailyReward = (RS:FindFirstChild("DailyRewardRemotes") and RS.DailyRewardRemotes:FindFirstChild("ClaimDailyReward")),
    SellASMRRequest = (RS:FindFirstChild("ASMRSellRemotes") and RS.ASMRSellRemotes:FindFirstChild("SellASMRRequest")),
    RequestTip = (RS:FindFirstChild("SystemMessageRemotes") and RS.SystemMessageRemotes:FindFirstChild("RequestTip")),
    RequestTeleport = (RS:FindFirstChild("TeleportRemotes") and RS.TeleportRemotes:FindFirstChild("RequestTeleport")),
    SetPerformanceMode = (RS:FindFirstChild("SettingsRemotes") and RS.SettingsRemotes:FindFirstChild("SetPerformanceMode")),
}
local Flags = {}
local Shared = {}
local Tables = {
    CrateList = {},
    CrateMap = {},
    ASMRList = {},
    ASMRMap = {},
    PlaceList = {},
    PlaceMap = {},
    InteractionList = {"Press", "Slime", "PopIt", "Squishy", "Keyboard", "PopItSmall", "PopItMedium", "PopItBig", "FoamTick1", "FoamTick2"},
}
local Modules = {
    CrateConfig = GetSafeModule(RS, "CrateConfig"),
    ASMRConfig = GetSafeModule(RS, "ASMRConfig"),
    ProductCatalogConfig = GetSafeModule(RS, "ProductCatalogConfig"),
    RebirthConfig = GetSafeModule(RS, "RebirthConfig"),
    WorkerConfig = GetSafeModule(RS, "WorkerConfig"),
    EconomyConfig = GetSafeModule(RS, "EconomyConfig"),
}
local CrateConfig = Modules.CrateConfig
local ASMRConfig = Modules.ASMRConfig
local ProductCatalogConfig = Modules.ProductCatalogConfig
local RebirthConfig = Modules.RebirthConfig
local WorkerConfig = Modules.WorkerConfig
local EconomyConfig = Modules.EconomyConfig
local function FireRemote(remote, ...)
    if not remote then return end
    local args = {...}
    pcall(function()
        remote:FireServer(unpack(args))
    end)
end
local function InvokeRemote(remote, ...)
    if not remote then return nil end
    local args = {...}
    local result = nil
    local ok = pcall(function()
        result = remote:InvokeServer(unpack(args))
    end)
    return ok and result or nil
end
local function GetCash()
    local ls = Plr:FindFirstChild("leaderstats")
    if ls then
        local cash = ls:FindFirstChild("Cash")
        if cash then return tonumber(cash.Value) or 0 end
    end
    return tonumber(Plr:GetAttribute("Cash")) or 0
end
local function GetRebirthCount()
    return tonumber(Plr:GetAttribute("RebirthCount")) or 0
end
local function CanRebirth()
    local state = InvokeRemote(Remotes.GetRebirthState)
    if type(state) == "table" then
        return state.CanRebirth == true and state.IsMaxed ~= true
    end
    return false
end
do
    local RarityOrder = { Common = 60, Uncommon = 40, Rare = 24, Epic = 12, Legendary = 6, Mythic = 3, Divine = 1, Exotic = 0.01, Godly = 0.001 }
    local crateEntries = {}
    local function AddCrate(id, name, rarity)
        local label = rarity and (tostring(name) .. " | " .. tostring(rarity)) or tostring(name)
        table.insert(crateEntries, { id = id, label = label, weight = rarity and RarityOrder[rarity] or 0 })
    end
    if ProductCatalogConfig and ProductCatalogConfig.Products then
        for _, p in ipairs(ProductCatalogConfig.Products) do
            if p.CrateTemplateName and p.LobbyCrateName then
                AddCrate(p.CrateTemplateName, p.LobbyCrateTitle or p.LobbyCrateName or p.DisplayName, p.Rarity)
            end
        end
    end
    if #crateEntries == 0 then
        local fallback = {
            {"CANDY_KEY_CRATE", "Candy Key Crate"},
            {"NEEDOH_CRATE", "Needoh Crate"},
            {"CHOCOLATE_KEY_CRATE", "Chocolate Key Crate"},
            {"WAX_NEEDOH_CRATE", "Wax Needoh Crate"},
            {"FOAM_BALL_CRATE", "Foam Ball Crate"},
            {"POP_IT_CRATE", "Pop-it Crate"},
            {"CHEESE_SQUISHY_CRATE", "Cheese Squishy Crate"},
            {"WOOD_KEY_CRATE", "Wood Key Crate"},
            {"SLIME_CRATE", "Slime Crate"},
            {"STONE_KEY_CRATE", "Stone Key Crate"},
            {"TABA_PAW_CRATE", "Taba Paw Crate"},
            {"TYPEWRITER_CRATE", "Typewriter Crate"},
            {"RAINBOW_KEY_CRATE", "Rainbow Key Crate"},
            {"BUTTER_SQUISHY_CRATE", "Butter Squishy Crate"},
            {"HONEY_KEY_CRATE", "Honey Key Crate"},
            {"RGB_KEY_CRATE", "RGB Key Crate"},
        }
        for _, c in ipairs(fallback) do AddCrate(c[1], c[2], nil) end
    end
    table.sort(crateEntries, function(a, b) return a.weight > b.weight end)
    for _, entry in ipairs(crateEntries) do
        table.insert(Tables.CrateList, entry.label)
        Tables.CrateMap[entry.label] = entry.id
    end
end
do
    local function AddASMR(id, name)
        local label = tostring(name)
        table.insert(Tables.ASMRList, label)
        Tables.ASMRMap[label] = id
    end
    if ProductCatalogConfig and ProductCatalogConfig.Products then
        for _, p in ipairs(ProductCatalogConfig.Products) do
            if p.ASMRTemplateName and p.ASMRDisplayName then
                AddASMR(p.ASMRTemplateName, p.ASMRDisplayName)
            end
        end
    end
    if #Tables.ASMRList == 0 then
        local fallback = {
            {"CANDY_KEY_ASMR", "Candy Keyboard"},
            {"NEEDOH_ASMR", "Needoh"},
            {"CHOCOLATE_KEY_ASMR", "Chocolate Keyboard"},
            {"WAX_NEEDOH_ASMR", "Wax Needoh"},
            {"FOAM_BALL_ASMR", "Foam Balls"},
            {"POP_IT_ASMR", "Pop-it"},
            {"CHEESE_SQUISHY_ASMR", "Cheese Squishy"},
            {"WOOD_KEY_ASMR", "Wood Keyboard"},
            {"SLIME_ASMR", "Slime"},
            {"STONE_KEY_ASMR", "Stone Keyboard"},
            {"TABA_PAW_ASMR", "Taba Paw"},
            {"TYPEWRITER_ASMR", "Typewriter Keyboard"},
            {"RAINBOW_KEY_ASMR", "Rainbow Keyboard"},
            {"BUTTER_SQUISHY_ASMR", "Butter Squishy"},
            {"HONEY_KEY_ASMR", "Honey Keyboard"},
            {"RGB_KEY_ASMR", "RGB Keyboard"},
        }
        for _, a in ipairs(fallback) do AddASMR(a[1], a[2]) end
    end
end
do
    for _, label in ipairs(Tables.CrateList) do
        local placeLabel = "[Crate] " .. label
        table.insert(Tables.PlaceList, placeLabel)
        Tables.PlaceMap[placeLabel] = Tables.CrateMap[label]
    end
    for _, label in ipairs(Tables.ASMRList) do
        local placeLabel = "[Item] " .. label
        table.insert(Tables.PlaceList, placeLabel)
        Tables.PlaceMap[placeLabel] = Tables.ASMRMap[label]
    end
end
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
        pcall(function()
            local PlayerScripts = Plr:WaitForChild("PlayerScripts", 5)
            if not PlayerScripts then return end
            local lagScripts = {
                "RippleCrateGradientAnimator",
                "PrismwaveCrateIdleRipple",
                "RGBKeyCrateAnimator",
                "ChromaKeyCrateAnimator",
                "ConveyorRGBKeyCrateAnimator",
                "ConveyorChromaKeyCrateAnimator",
                "UpgradeConveyorRarityShineClient",
                "UIShineAndSunburstEffects",
                "UIOverlayAnimatorClient",
                "PlotVisualInterestClient",
                "CrateConveyorVisualClient",
                "CrateUnboxVisualClient",
                "FloatingRocksZeroGravityClient",
                "WorkspaceASMRTestClient",
                "ClickEffect",
                "ASMRCashPopupClient",
                "HoneyEventController",
                "HoneyAndRebirthASMRClient",
                "KeyboardShowcaseClient",
                "PrismwaveClient",
                "ConveyorCrateSmoothingClient",
                "PlotExpansionOutlineClient",
                "ClientASMRToolVisuals",
                "ClientCrateToolVisuals",
                "RemoteHeldToolVisuals",
                "BubbleWrapClient",
                "NeonPopitDropletsIceClient",
                "CollectionCellCrushClient",
                "LargeSlimeClient",
                "FoamBallsClient",
                "ChocolateBarClient",
                "CrunchyPuddingClient",
                "OrbeezClient",
                "LateGameASMRClient",
                "GenericASMRInteractionClient",
            }
            for _, name in ipairs(lagScripts) do
                local ls = PlayerScripts:FindFirstChild(name)
                if ls then
                    ls.Disabled = true
                    warn("[FPSBoost] Disabled: " .. name)
                end
            end
        end)
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
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Autofarm = Tabs.Main:AddLeftTabbox(),
            Autofarm2 = Tabs.Main:AddLeftTabbox(),
        },
        Right = {
            Autofarm = Tabs.Main:AddRightTabbox(),
            Autofarm2 = Tabs.Main:AddRightTabbox(),
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
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if Toggles.AntiKick and Toggles.AntiKick.Value and getnamecallmethod() == "Kick" and self == Plr then
            return
        end
        return oldNamecall(self, ...)
    end)
end)
task.spawn(function()
    while true do
        task.wait(60)
        if Toggles.AutoServerhop and Toggles.AutoServerhop.Value then
            local mins = Options.AutoHopMins.Value
            if mins > 0 then
                task.wait((mins - 1) * 60)
            end
            if Toggles.AutoServerhop.Value then
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
local function GetPlayerPlot()
    local plotNumber = Plr:GetAttribute("PlotNumber")
    if typeof(plotNumber) ~= "number" then return nil end
    local Plots = workspace:FindFirstChild("Plots")
    local ActivePlots = Plots and Plots:FindFirstChild("ActivePlots")
    if not ActivePlots then return nil end
    local plot = ActivePlots:FindFirstChild(string.format("Plot%d", plotNumber))
    return (plot and plot:IsA("Model")) and plot or nil
end
local function FindOwnedASMRModels()
    local models = {}
    local plot = GetPlayerPlot()
    local ASMR = plot and plot:FindFirstChild("ASMR")
    if not ASMR then return models end
    for _, desc in ipairs(ASMR:GetChildren()) do
        if desc:IsA("Model") and desc:GetAttribute("OwnerUserId") == Plr.UserId then
            local template = desc:GetAttribute("ASMRTemplateName") or desc:GetAttribute("TemplateName")
            if template then
                table.insert(models, desc)
            end
        end
    end
    return models
end
local function FindOwnedCrates()
    local models = {}
    local plot = GetPlayerPlot()
    local PlacedCrates = plot and plot:FindFirstChild("PlacedCrates")
    if not PlacedCrates then return models end
    for _, desc in ipairs(PlacedCrates:GetChildren()) do
        if desc:IsA("Model") and desc:GetAttribute("OwnerUserId") == Plr.UserId then
            table.insert(models, desc)
        end
    end
    return models
end
local function IsSpotOccupied(plot, part)
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Include
    local filterInstances = {}
    local PlacedCrates = plot:FindFirstChild("PlacedCrates")
    local ASMR = plot:FindFirstChild("ASMR")
    if PlacedCrates then table.insert(filterInstances, PlacedCrates) end
    if ASMR then table.insert(filterInstances, ASMR) end
    if #filterInstances == 0 then return false end
    overlapParams.FilterDescendantsInstances = filterInstances
    overlapParams.RespectCanCollide = false
    local size = Vector3.new(part.Size.X * 0.9, 4, part.Size.Z * 0.9)
    local cframe = part.CFrame * CFrame.new(0, part.Size.Y / 2 + size.Y / 2, 0)
    local hits = workspace:GetPartBoundsInBox(cframe, size, overlapParams)
    for _, hit in ipairs(hits) do
        if hit:IsA("BasePart") then
            return true
        end
    end
    return false
end
local function FindOpenPlacementSpots(plot)
    local spots = {}
    local Placement = plot:FindFirstChild("Placement")
    local Unlocked = Placement and Placement:FindFirstChild("Unlocked")
    if not Unlocked then return spots end
    for _, part in ipairs(Unlocked:GetChildren()) do
        if part:IsA("BasePart") and part:GetAttribute("Placeable") == true then
            if not IsSpotOccupied(plot, part) then
                table.insert(spots, part)
            end
        end
    end
    return spots
end
local function FindOwnedCrateTools()
    local tools = {}
    for _, item in ipairs(Backpack:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("IsCrateTool") == true then
            table.insert(tools, item)
        end
    end
    local char = Plr.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("IsCrateTool") == true then
                table.insert(tools, item)
            end
        end
    end
    return tools
end
local function FindOwnedASMRTools()
    local tools = {}
    for _, item in ipairs(Backpack:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("IsASMRTool") == true then
            table.insert(tools, item)
        end
    end
    local char = Plr.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("IsASMRTool") == true then
                table.insert(tools, item)
            end
        end
    end
    return tools
end
local function FindPlacedCrateModels(plot)
    local models = {}
    local PlacedCrates = plot:FindFirstChild("PlacedCrates")
    if not PlacedCrates then return models end
    for _, model in ipairs(PlacedCrates:GetChildren()) do
        if model:IsA("Model") then
            table.insert(models, model)
        end
    end
    return models
end
local function FindExpansionPrompts(plot)
    local prompts = {}
    local Placement = plot:FindFirstChild("Placement")
    local Locked = Placement and Placement:FindFirstChild("Locked")
    if not Locked then return prompts end
    for _, part in ipairs(Locked:GetChildren()) do
        if part:IsA("BasePart") then
            local prompt = part:FindFirstChild("ExpansionPurchasePrompt")
            if prompt and prompt:IsA("ProximityPrompt") then
                table.insert(prompts, prompt)
            end
        end
    end
    return prompts
end
local function FindConveyorCrates()
    local crates = {}
    local plot = GetPlayerPlot()
    if not plot then return crates end
    local Conveyor = plot:FindFirstChild("Conveyor")
    local ActiveCrates = Conveyor and Conveyor:FindFirstChild("ActiveCrates")
    if not ActiveCrates then return crates end
    for _, model in ipairs(ActiveCrates:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("OwnerUserId") == Plr.UserId then
            table.insert(crates, model)
        end
    end
    return crates
end
local KeyboardConfigs = {
    ["Candy Keyboard"] = { keyName = "Key" },
    ["67 Keyboard"] = { keyName = "Key" },
    ["Chocolate Keyboard"] = { keyName = "Key" },
    ["Stone Keyboard"] = { keyName = "Key" },
    ["Wood Keyboard"] = { keyName = "Key" },
    ["Rainbow Keyboard"] = { keyName = "Key", effect = "rainbow" },
    ["Prismwave Keyboard"] = { keyName = "Key", effect = "ripple" },
    ["RGB Keyboard"] = { keyName = "Key", effect = "rgb" },
    ["Lightning Keyboard"] = { keyName = "Key", effect = "lightning" },
    ["Chroma Keyboard"] = { keyName = "Key", effect = "lightup" },
    ["Honey Keyboard"] = { keyName = "Key", effect = "honey" },
    ["Slime Keyboard"] = { keyName = "Key", effect = "slime" },
    ["Water Keyboard"] = { keyName = "Key", effect = "water" },
    ["Typewriter Keyboard"] = { keyName = "Key", effect = "typewriter" },
    ["Dumpling Keyboard"] = { keyName = "DumplingKey", effect = "dumpling" },
    ["Wax Keyboard"] = { keyName = "WaxKey", effect = "wax" },
}
KeyboardConfigs["Squishy Dumpling Keyboard"] = KeyboardConfigs["Dumpling Keyboard"]
local CollectionCellCrushKinds = {
    ["wax paw taba"] = "WaxPaw",
    ["wax taba paw"] = "WaxPaw",
    ["chocolate popsicle"] = "Popsicle",
    ["strawberry popsicle"] = "StrawberryPopsicle",
}
local function GetASMRDisplayKey(model)
    local name = model:GetAttribute("ASMRDisplayName") or model:GetAttribute("ASMRTemplateName") or model.Name:gsub("^Placed_", "")
    return tostring(name):lower()
end
local function FindKeyboardKeyPart(model, config)
    if config.effect == "wax" then
        local NormalKeys = model:FindFirstChild("NormalKeys")
        if NormalKeys then
            for _, v in ipairs(NormalKeys:GetChildren()) do
                if v:IsA("BasePart") then return v end
            end
        end
        return nil
    elseif config.effect == "typewriter" then
        for _, v in ipairs(model:GetDescendants()) do
            if v:IsA("Model") and v.Name == "Key" then
                local best, bestArea = nil, 0
                for _, part in ipairs(v:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local area = part.Size.X * part.Size.Z
                        if area > bestArea then bestArea, best = area, part end
                    end
                end
                if best then return best end
            end
        end
        return nil
    else
        for _, v in ipairs(model:GetDescendants()) do
            if v:IsA("MeshPart") and v.Name == config.keyName then
                return v
            end
        end
        return nil
    end
end
local function FindSlimeMeshPart(model)
    local slime = model:FindFirstChild("Slime") or model:FindFirstChild("slime")
    local mesh = slime and (slime:FindFirstChild("Cylinder.001") or slime:FindFirstChild("Cube.001"))
    if not (mesh and mesh:IsA("MeshPart")) then
        mesh = model:FindFirstChild("Cylinder.001", true) or model:FindFirstChild("Cube.001", true)
        if not (mesh and mesh:IsA("MeshPart")) then mesh = nil end
    end
    return mesh
end
local function FindLargestFootprintMeshPart(model)
    local best, bestArea = nil, -1
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("MeshPart") then
            local area = v.Size.X * v.Size.Z
            if area > bestArea then bestArea, best = area, v end
        end
    end
    return best
end
local function FindFoamSpherePart(model)
    for _, v in ipairs(model:GetChildren()) do
        if v:IsA("BasePart") and v.Name == "Sphere" then
            return v
        end
    end
    for _, v in ipairs(model:GetChildren()) do
        if v:IsA("Model") then
            local sphere = v:FindFirstChild("Sphere")
            if sphere and sphere:IsA("BasePart") then return sphere end
        end
    end
    return nil
end
local function FindBubbleWrapPart(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("MeshPart") then
            if v.Name == "Bubble" then return v, "PopItSmall"
            elseif v.Name == "MediumBubble" then return v, "PopItMedium"
            elseif v.Name == "Big Bubble" then return v, "PopItBig" end
        end
    end
    return nil, nil
end
local function FindNeonPopitPart(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:match("^Sphere") then
            return v
        end
    end
    return nil
end
local function FindWaterDropletPart(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "WaterDroplet" then
            return v
        end
    end
    return nil
end
local function FindIceCubePart(model)
    local IceCubes = model:FindFirstChild("IceCubes", true)
    if not IceCubes then return nil end
    for _, v in ipairs(IceCubes:GetDescendants()) do
        if v:IsA("BasePart") then return v end
    end
    return nil
end
local function FindChocolateBarPlainPart(model)
    local best, bestVol = nil, -1
    local pieces = {}
    for _, v in ipairs(model:GetChildren()) do
        if v:IsA("MeshPart") then
            table.insert(pieces, v)
            local vol = v.Size.X * v.Size.Y * v.Size.Z
            if vol > bestVol then bestVol, best = vol, v end
        end
    end
    for _, v in ipairs(pieces) do
        if v ~= best then return v end
    end
    return nil
end
local function FindChocolateBarWaxPart(model)
    local Chocolates = model:FindFirstChild("Chocolates")
    if not Chocolates then return nil end
    for _, v in ipairs(Chocolates:GetDescendants()) do
        if v:IsA("BasePart") then return v end
    end
    return nil
end
local function FindOrbeezPart(model)
    local container = model:FindFirstChild("GeneratedGlassOrbees", true) or model
    for _, v in ipairs(container:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "GlassOrbee" then
            return v
        end
    end
    return nil
end
local function FindCollectionCellCrushPart(model, kind)
    if kind == "Popsicle" or kind == "StrawberryPopsicle" then
        return model:FindFirstChild("Hitbox", true) or model:FindFirstChild("PreBody", true)
    elseif kind == "WaxPaw" then
        local hitbox = model:FindFirstChild("Hitbox", true)
        if hitbox then return hitbox end
        for _, v in ipairs(model:GetDescendants()) do
            if v:IsA("MeshPart") and v.Name:lower():find("taba_paw_lp", 1, true) then
                return v
            end
        end
    end
    return nil
end
local function FindLateGameHitbox(model)
    return model:FindFirstChild("Hitbox")
end
local function ResolveASMRInteractionTarget(model)
    local key = GetASMRDisplayKey(model)
    local template = tostring(model:GetAttribute("ASMRTemplateName") or ""):upper()
    local displayName = model:GetAttribute("ASMRDisplayName") or model.Name
    local keyboardConfig = KeyboardConfigs[displayName]
    if keyboardConfig then
        local part = FindKeyboardKeyPart(model, keyboardConfig)
        if part then return part, "Keyboard" end
    end
    if key == "crunchy pudding" or key == "crunchy_pudding_asmr" then
        local part = FindLargestFootprintMeshPart(model)
        if part then return part, "Squishy" end
    end
    if key == "foam balls" or key == "wax foam balls" then
        local part = FindFoamSpherePart(model)
        if part then return part, "FoamTick1" end
    end
    if key == "bubble wrap" or template == "BUBBLE_WRAP_ASMR" then
        local part, itype = FindBubbleWrapPart(model)
        if part then return part, itype end
    end
    if key == "neon pop-it" then
        local part = FindNeonPopitPart(model)
        if part then return part, "PopIt" end
    elseif key == "water droplets" then
        local part = FindWaterDropletPart(model)
        if part then return part, "Press" end
    elseif key == "icetray" or key == "ice tray" then
        local part = FindIceCubePart(model)
        if part then return part, "Press" end
    end
    if key == "chocolate bar" then
        local part = FindChocolateBarPlainPart(model)
        if part then return part, "Press" end
    elseif key == "wax chocolate bar" then
        local part = FindChocolateBarWaxPart(model)
        if part then return part, "Press" end
    end
    if key == "orbeez" or template == "ORBEEZ_ASMR" then
        local part = FindOrbeezPart(model)
        if part then return part, "Press" end
    end
    local crushKind = CollectionCellCrushKinds[key]
    if crushKind then
        local part = FindCollectionCellCrushPart(model, crushKind)
        if part then
            local itype = model:GetAttribute("ASMRInteractionType") or "Press"
            return part, itype
        end
    end
    if template == "CRUNCHY_PEANUT_ASMR" then
        local part = FindLateGameHitbox(model)
        if part then return part, model:GetAttribute("ASMRInteractionType") or "Slime" end
    elseif template == "WAX_SOAP_ASMR" then
        local part = FindLateGameHitbox(model)
        if part then return part, model:GetAttribute("ASMRInteractionType") or "Press" end
    end
    if template:match("SLIME") then
        local part = FindSlimeMeshPart(model)
        if part then return part, "Slime" end
    end
    local interactionType = model:GetAttribute("ASMRInteractionType")
    if interactionType == "Press" or interactionType == "PopIt" or not interactionType then
        local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if part then return part, interactionType or "Press" end
    end
    return nil, nil
end
local function Func_AutoInteract()
    while true do
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        for _, model in ipairs(FindOwnedASMRModels()) do
            if not Toggles.AutoInteract or not Toggles.AutoInteract.Value then return end
            local targetPart, interactionType = ResolveASMRInteractionTarget(model)
            if targetPart and interactionType then
                local inRange = not hrp or (hrp.Position - targetPart.Position).Magnitude < 20
                if inRange then
                    FireRemote(Remotes.RequestInteraction, model, targetPart, interactionType, targetPart.Position)
                end
            end
        end
        task.wait(0.3)
    end
end
local function Func_AutoUpgrade()
    while true do
        for _, model in ipairs(FindOwnedASMRModels()) do
            if not Toggles.AutoUpgrade or not Toggles.AutoUpgrade.Value then return end
            FireRemote(Remotes.RequestUpgrade, model)
            task.wait(0.1)
        end
        task.wait()
    end
end
local function Func_AutoPickup()
    while true do
        local tool = Plr.Character and Plr.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, model in ipairs(FindOwnedASMRModels()) do
                if not Toggles.AutoPickup or not Toggles.AutoPickup.Value then return end
                FireRemote(Remotes.RequestPickupASMR, model)
                task.wait(0.4)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoRebirth()
    while true do
        if CanRebirth() then
            local result = InvokeRemote(Remotes.RequestRebirth)
            if result then task.wait(2) end
        end
        task.wait(1)
    end
end
local function Func_AutoSkipRebirth()
    while true do
        InvokeRemote(Remotes.RequestSkipRebirth)
        task.wait(1)
    end
end
local function Func_AutoBuyWorker()
    while true do
        FireRemote(Remotes.BuyWorker)
        task.wait(2)
    end
end
local function FindWorkerTool()
    local char = GetCharacter()
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("IsWorkerTool") == true then
                return item, char
            end
        end
    end
    for _, item in ipairs(Backpack:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("IsWorkerTool") == true then
            return item, char
        end
    end
    return nil, char
end
local function IsWorkerAssignTarget(model)
    return model:GetAttribute("OwnerUserId") == Plr.UserId
        and typeof(model:GetAttribute("PlacedASMRId")) == "string"
        and model:GetAttribute("WorkerAssigned") ~= true
end
local function Func_AutoAssignWorker()
    while true do
        if not Toggles.AutoAssignWorker or not Toggles.AutoAssignWorker.Value then return end
        local tool, char = FindWorkerTool()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if tool and hum then
            if tool.Parent ~= char then
                hum:EquipTool(tool)
                task.wait(0.2)
            end
            for _, model in ipairs(FindOwnedASMRModels()) do
                if not Toggles.AutoAssignWorker or not Toggles.AutoAssignWorker.Value then return end
                if IsWorkerAssignTarget(model) then
                    FireRemote(Remotes.AssignWorker, model, tool)
                    task.wait(0.2)
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoChangeConveyor()
    while true do
        local level = Options.ConveyorLevelValue.Value or 1
        FireRemote(Remotes.ChangeConveyorRequest, level)
        task.wait(1)
    end
end
local function Func_AutoRollCrate()
    while true do
        if not Toggles.AutoRollCrate or not Toggles.AutoRollCrate.Value then return end
        local selected = Options.CrateSelected.Value
        local anySelected = false
        for _, v in pairs(selected) do
            if v then anySelected = true break end
        end
        local crates = FindConveyorCrates()
        if #crates == 0 then
            FireRemote(Remotes.ConveyorButtonPress)
            task.wait(0.5)
        else
            local handledAny = false
            local hasWanted = false
            for _, model in ipairs(crates) do
                local template = model:GetAttribute("TemplateName")
                local label = nil
                for lbl, id in pairs(Tables.CrateMap) do
                    if id == template then label = lbl break end
                end
                if not anySelected or (label and selected[label]) then
                    hasWanted = true
                    local prompt = model:FindFirstChild("Main") and model.Main:FindFirstChild("CrateBuyPrompt")
                    if prompt then
                        FirePP(prompt, true)
                        handledAny = true
                        task.wait(0.3)
                    end
                end
            end
            if not hasWanted and anySelected then
                FireRemote(Remotes.ConveyorButtonPress)
                task.wait(0.5)
            elseif not handledAny then
                task.wait(0.5)
            end
        end
    end
end
local function Func_AutoPlace()
    while true do
        if not Toggles.AutoPlace or not Toggles.AutoPlace.Value then return end
        local plot = GetPlayerPlot()
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if plot and hum then
            local selected = Options.PlaceSelected.Value
            local anySelected = false
            for _, v in pairs(selected) do
                if v then anySelected = true break end
            end
            local tools = FindOwnedCrateTools()
            for _, t in ipairs(FindOwnedASMRTools()) do
                table.insert(tools, t)
            end
            local placedAny = false
            local outOfSpots = false
            for _, tool in ipairs(tools) do
                if not Toggles.AutoPlace or not Toggles.AutoPlace.Value then return end
                if outOfSpots then break end
                local template = tool:GetAttribute("CrateTemplateName") or tool:GetAttribute("ASMRTemplateName")
                local label = nil
                for lbl, id in pairs(Tables.PlaceMap) do
                    if id == template then label = lbl break end
                end
                if not anySelected or (label and selected[label]) then
                    local spots = FindOpenPlacementSpots(plot)
                    if #spots == 0 then
                        outOfSpots = true
                    else
                        local spot = spots[1]
                        hum:EquipTool(tool)
                        task.wait(0.2)
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local spotPos = spot.Position
                            local dist = (hrp.Position - spotPos).Magnitude
                            if dist > (spot.Size.Magnitude / 2 + 6) then
                                hrp.CFrame = spot.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.175)
                            end
                        end
                        if tool:GetAttribute("IsCrateTool") == true then
                            FireRemote(Remotes.RequestPlaceCrate, spot.CFrame)
                        elseif tool:GetAttribute("IsASMRTool") == true then
                            FireRemote(Remotes.RequestPlaceASMR, spot.CFrame)
                        end
                        placedAny = true
                        task.wait(0.4)
                    end
                end
            end
            if not placedAny then
                task.wait(1)
            end
        else
            task.wait(1)
        end
    end
end
local function Func_AutoOpenCrate()
    while true do
        if not Toggles.AutoOpenCrate or not Toggles.AutoOpenCrate.Value then return end
        local plot = GetPlayerPlot()
        if plot then
            local models = FindPlacedCrateModels(plot)
            local handledAny = false
            for _, model in ipairs(models) do
                if not Toggles.AutoOpenCrate or not Toggles.AutoOpenCrate.Value then return end
                if model:GetAttribute("OwnerUserId") == Plr.UserId then
                    local main = model:FindFirstChild("Main")
                    local prompt = main and main:FindFirstChild("OpenCratePrompt")
                    if prompt and (prompt:IsA("ProximityPrompt") and (prompt.Enabled and prompt.ActionText == "Open")) then
                        FirePP(prompt, true)
                        handledAny = true
                        task.wait(0.3)
                    end
                end
            end
            if not handledAny then
                task.wait(1)
            end
        else
            task.wait(1)
        end
    end
end
local function Func_AutoExpand()
    while true do
        if not Toggles.AutoExpand or not Toggles.AutoExpand.Value then return end
        local plot = GetPlayerPlot()
        if plot then
            local prompts = FindExpansionPrompts(plot)
            table.sort(prompts, function(a, b)
                return (a:GetAttribute("ExpansionPrice") or math.huge) < (b:GetAttribute("ExpansionPrice") or math.huge)
            end)
            local handledAny = false
            for _, prompt in ipairs(prompts) do
                local price = tonumber(prompt:GetAttribute("ExpansionPrice"))
                if price and GetCash() >= price then
                    FirePP(prompt, true)
                    handledAny = true
                    task.wait(0.5)
                    break
                end
            end
            if not handledAny then
                task.wait(1)
            end
        else
            task.wait(1)
        end
    end
end
local function Func_AutoSell()
    while true do
        InvokeRemote(Remotes.SellASMRRequest, "All")
        task.wait(5)
    end
end
local function Func_AutoClaimDaily()
    while true do
        FireRemote(Remotes.ClaimDailyReward)
        task.wait(60)
    end
end
local function Func_AutoTip()
    while true do
        FireRemote(Remotes.RequestTip)
        task.wait(30)
    end
end
local function Func_AutoSpeedBoost()
    while true do
        if Plr:GetAttribute("WalkSpeedBoostEnabled") ~= true then
            FireRemote(Remotes.SetSpeedBoost, true)
        end
        task.wait(5)
    end
end
TB_Tabs.Autofarm2.T1:AddDropdown("CrateSelected", {
    Values = Tables.CrateList,
    Default = {},
    Multi = true,
    Searchable = true,
    Text = "Crate List",
})
TB_Tabs.Autofarm2.T1:AddDropdown("PlaceSelected", {
    Values = Tables.PlaceList,
    Default = {},
    Multi = true,
    Searchable = true,
    Text = "Place Item/Crate",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRollCrate", { Text = "Auto Roll", Default = false, Callback = function(val) Thread("AutoRollCrate", Func_AutoRollCrate, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false, Callback = function(val) Thread("AutoUpgrade", Func_AutoUpgrade, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoInteract", { Text = "Auto Interact", Default = false, Callback = function(val) Thread("AutoInteract", Func_AutoInteract, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false, Callback = function(val) Thread("AutoPickup", Func_AutoPickup, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false, Callback = function(val) Thread("AutoSell", Func_AutoSell, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyWorker", { Text = "Auto Buy Worker", Default = false, Callback = function(val) Thread("AutoBuyWorker", Func_AutoBuyWorker, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoAssignWorker", { Text = "Auto Assign Workers", Default = false, Callback = function(val) Thread("AutoAssignWorker", Func_AutoAssignWorker, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false, Callback = function(val) Thread("AutoRebirth", Func_AutoRebirth, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false, Callback = function(val) Thread("AutoPlace", Func_AutoPlace, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoOpenCrate", { Text = "Auto Open Crate", Default = false, Callback = function(val) Thread("AutoOpenCrate", Func_AutoOpenCrate, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoExpand", { Text = "Auto Expand", Default = false, Callback = function(val) Thread("AutoExpand", Func_AutoExpand, val) end })
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
SaveManager:SetFolder("Yuri/UnboxASMR")
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
    notyuri("ERROR: " .. tostring(err))
end