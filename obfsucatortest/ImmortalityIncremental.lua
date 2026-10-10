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
local function GetRemote(parent, pathString)
    local current = parent
    for _, name in ipairs(pathString:split(".")) do
        if not current then return nil end
        current = current:FindFirstChild(name)
        if not current then return nil end
    end
    return current
end
local RemoteEvents = RS:FindFirstChild("RemoteEvents")
local Mods = RS:FindFirstChild("Modules")
do
    local pollStart = tick()
    while (not RemoteEvents or not Mods) and (tick() - pollStart) < 10 do
        task.wait()
        RemoteEvents = RemoteEvents or RS:FindFirstChild("RemoteEvents")
        Mods = Mods or RS:FindFirstChild("Modules")
    end
end
local Remotes = {
    GainQi = GetRemote(RemoteEvents, "GainQi"),
    GainMiasma = GetRemote(RemoteEvents, "GainMiasma"),
    PurchaseUpgrade = GetRemote(RemoteEvents, "PurchaseUpgrade"),
    PurchaseInsight = GetRemote(RemoteEvents, "PurchaseInsight"),
    PurchaseSoulfire = GetRemote(RemoteEvents, "PurchaseSoulfire"),
    PurchaseNebula = GetRemote(RemoteEvents, "PurchaseNebula"),
    PurchaseAsh = GetRemote(RemoteEvents, "PurchaseAsh"),
    PurchaseLaws = GetRemote(RemoteEvents, "PurchaseLaws"),
    ClaimRefinement = GetRemote(RemoteEvents, "ClaimRefinement"),
    UpdatePlayerOption = GetRemote(RemoteEvents, "UpdatePlayerOptionSetting"),
    RollBloodline = GetRemote(RemoteEvents, "RollBloodline"),
    UpgradeBloodline = GetRemote(RemoteEvents, "UpgradeBloodline"),
    SetActiveBloodline = GetRemote(RemoteEvents, "SetActiveBloodline"),
    RollSpiritRoot = GetRemote(RemoteEvents, "RollSpiritRoot"),
    UpgradeSpiritRoot = GetRemote(RemoteEvents, "UpgradeSpiritRoot"),
    SetActiveSpiritRoot = GetRemote(RemoteEvents, "SetActiveSpiritRoot"),
    ConvertSpiritRootCores = GetRemote(RemoteEvents, "ConvertSpiritRootCores"),
    ConvertCitizensToFaith = GetRemote(RemoteEvents, "ConvertCitizensToFaith"),
    SetBeastStage = GetRemote(RemoteEvents, "SetBeastStage"),
    ToggleQuasarCultivation = GetRemote(RemoteEvents, "ToggleQuasarCultivation"),
    DaoClick = GetRemote(RemoteEvents, "DaoClick"),
    ToggleDaoCultivation = GetRemote(RemoteEvents, "ToggleDaoCultivation"),
    SetSoulFocus = GetRemote(RemoteEvents, "SetSoulFocus"),
    UsePotion = GetRemote(RemoteEvents, "UsePotion"),
    PurchaseAnima = GetRemote(RemoteEvents, "PurchaseAnima"),
    PurchaseVitalityGenerator = GetRemote(RemoteEvents, "PurchaseVitalityGenerator"),
    PurchaseDungeonUpgrade = GetRemote(RemoteEvents, "PurchaseDungeonUpgrade"),
    RequestReincarnation = GetRemote(RemoteEvents, "RequestReincarnation"),
    TierUpWorld = GetRemote(RemoteEvents, "TierUpWorld"),
    ConvertSoulsToAngels = GetRemote(RemoteEvents, "convert_souls_to_angels"),
    ToggleRaidAFK = GetRemote(RemoteEvents, "toggle_raid_afk"),
    SpendSectUpgradePoint = GetRemote(RemoteEvents, "SpendSectUpgradePoint"),
}
local BigNumber = GetSafeModule(Mods, "BigNumber")
local BloodlineConfig = GetSafeModule(Mods, "BloodlineConfig")
local SpiritRootConfig = GetSafeModule(Mods, "SpiritRootConfig")
local function _BN_getBigNumberAttr(plr, prefix)
    local m = plr:GetAttribute(prefix.."Mantissa")
    local e = plr:GetAttribute(prefix.."Exponent")
    if type(m)=="number" and type(e)=="number" then return BigNumber.fromParts(m,e) end
    return BigNumber.zero()
end
local InsightResetBoardModel = GetSafeModule(Mods, "InsightResetBoardModel")
local SoulResetBoardModel = GetSafeModule(Mods, "SoulResetBoardModel")
local NebulaResetBoardModel = GetSafeModule(Mods, "NebulaResetBoardModel")
local RefinementResetBoardModel = GetSafeModule(Mods, "RefinementResetBoardModel")
local AshResetBoardModel = GetSafeModule(Mods, "AshResetBoardModel")
local LawsResetBoardModel = GetSafeModule(Mods, "LawsResetBoardModel")
local AnimaResetBoardModel = GetSafeModule(Mods, "AnimaResetBoardModel")
local ReincarnationBoardModel = GetSafeModule(Mods, "ReincarnationBoardModel")
local FaithConvertBoardModel = GetSafeModule(Mods, "FaithConvertBoardModel")
local Modules = {
    BigNumber                = BigNumber,
    BloodlineConfig          = BloodlineConfig,
    SpiritRootConfig         = SpiritRootConfig,
    InsightResetBoardModel   = InsightResetBoardModel,
    SoulResetBoardModel      = SoulResetBoardModel,
    NebulaResetBoardModel    = NebulaResetBoardModel,
    RefinementResetBoardModel= RefinementResetBoardModel,
    AshResetBoardModel       = AshResetBoardModel,
    LawsResetBoardModel      = LawsResetBoardModel,
    FaithConvertBoardModel   = FaithConvertBoardModel,
    AnimaResetBoardModel     = AnimaResetBoardModel,
    ReincarnationBoardModel  = ReincarnationBoardModel,
    SoulsConfig              = GetSafeModule(Mods, "souls_config"),
    AngelsConfig             = GetSafeModule(Mods, "angels_config"),
    InnerWorldConfig         = GetSafeModule(Mods, "InnerWorldConfig"),
    HydraBossConfig          = GetSafeModule(Mods, "hydra_boss_config"),
    HydraUpgradeConfig       = GetSafeModule(Mods, "hydra_upgrade_config"),
    HydraMasteryConfig       = GetSafeModule(Mods, "hydra_mastery_config"),
    RaidDungeonConfig        = GetSafeModule(Mods, "raid_dungeon_config"),
    SectConfig               = GetSafeModule(Mods, "SectConfig"),
}
local Flags = {}
local Shared = {
}
local Tables = {
    QiBoardUpgrades = {},
    AllUpgradeIds = {},
    DropdownValues = {},
    BoardGroupLabels = {},
    BoardGroupIdMap = {},
    DropdownIdMap = {},
    UpgradeAffordMap = {},
    TouchButtonList = {},
    TouchButtonMap = {},
    PotionLabelToId = {},
    PotionDropdownValues = {},
    BloodlineTables = { DropdownIdMap = {} },
    BloodlineTablesDropdownValues = {},
    SpiritRootTables = { DropdownIdMap = {} },
    SpiritRootTablesDropdownValues = {},
    VitalityGeneratorList = {},
    VitalityGeneratorMap = {},
    VitalityGeneratorDropdownValues = {},
    SectUpgradeIdMap = {},
    SectUpgradeDropdownValues = {},
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
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
do
    local order = (Modules.SectConfig and Modules.SectConfig.UPGRADE_ORDER) or {}
    local defs = (Modules.SectConfig and Modules.SectConfig.UPGRADE_DEFS) or {}
    for _, id in ipairs(order) do
        local def = defs[id]
        local name = (def and def.name) or id
        local label = name .. " [" .. id .. "]"
        table.insert(Tables.SectUpgradeDropdownValues, label)
        Tables.SectUpgradeIdMap[label] = id
    end
end
local ExtraButtons = {
    { display = "Bear", pos = Vector3.new(172, 15, -35) },
}
local starsFolder = workspace:FindFirstChild("StarForgingLocalVisuals")
local function getStars()
    local stars = {}
    for _, obj in pairs(starsFolder and starsFolder:GetChildren() or {}) do
        if string.match(obj.Name, "^Star_%d+$") then
            local starTemplate = obj:FindFirstChild("StarTemplate")
            if starTemplate then
                table.insert(stars, starTemplate)
            end
        end
    end
    return stars
end
local function getStarPosition(starTemplate)
    if starTemplate:IsA("Model") then
        local primary = starTemplate.PrimaryPart or starTemplate:FindFirstChildWhichIsA("BasePart")
        if primary then return primary.Position end
    elseif starTemplate:IsA("BasePart") then
        return starTemplate.Position
    end
    return nil
end
local function ScanWorkspaceButtons()
    Tables.TouchButtonList = {}
    Tables.TouchButtonMap  = {}
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name:lower():find("button") then
            for _, desc in ipairs(child:GetDescendants()) do
                if desc:IsA("TouchTransmitter") then
                    local part = desc:FindFirstAncestorWhichIsA("BasePart")
                    if part then
                        local label = child.Name
                        if not Tables.TouchButtonMap[label] then
                            table.insert(Tables.TouchButtonList, label)
                            Tables.TouchButtonMap[label] = part
                        end
                    end
                    break
                end
            end
        end
    end
end
ScanWorkspaceButtons()
for _, entry in ipairs(ExtraButtons) do
    if not Tables.TouchButtonMap[entry.display] then
        table.insert(Tables.TouchButtonList, entry.display)
        Tables.TouchButtonMap[entry.display] = { Position = entry.pos, Parent = true }
    end
end
do
    table.insert(Tables.QiBoardUpgrades, "QiMultiplier")
    table.insert(Tables.QiBoardUpgrades, "BreakthroughLuck")
    table.insert(Tables.QiBoardUpgrades, "MarkBulk")
end
local PotionDefs = {
    { id = "MarkBulkPotion",         label = "Mark Bulk Potion" },
    { id = "MarkSpeedPotion",        label = "Mark Speed Potion" },
    { id = "MarkLuckPotion",         label = "Mark Luck Potion" },
    { id = "BreakthroughLuckPotion", label = "Breakthrough Luck Potion" },
}
for _, bl in ipairs(Modules.BloodlineConfig.Bloodlines) do
    if bl.id and bl.name then
        local label = tostring(bl.name) .. " [" .. tostring(bl.id) .. "]"
        table.insert(Tables.BloodlineTablesDropdownValues, label)
        Tables.BloodlineTables.DropdownIdMap[label] = bl.id
    end
end
for _, sr in ipairs(Modules.SpiritRootConfig.SpiritRoots) do
    if sr.id and sr.name then
        local label = tostring(sr.name) .. " [" .. tostring(sr.id) .. "]"
        table.insert(Tables.SpiritRootTablesDropdownValues, label)
        Tables.SpiritRootTables.DropdownIdMap[label] = sr.id
    end
end
for _, def in ipairs(PotionDefs) do
    table.insert(Tables.PotionDropdownValues, def.label)
    Tables.PotionLabelToId[def.label] = def.id
end
local _VitalityGens = {
    {id="Sapling",   label="Emerald Sapling"},
    {id="Root",      label="Ancient Root"},
    {id="Vine",      label="Wild Vine"},
    {id="Grove",     label="Mossy Grove"},
    {id="Canopy",    label="Sunlit Canopy"},
    {id="Heartwood", label="Heartwood Elder"},
}
for _, g in ipairs(_VitalityGens) do
    local lbl = g.label .. " [" .. g.id .. "]"
    table.insert(Tables.VitalityGeneratorList, lbl)
    Tables.VitalityGeneratorMap[lbl] = g.id
    table.insert(Tables.VitalityGeneratorDropdownValues, lbl)
end
local UpgradeGroupSources = {
    { label = "Qi Board",        module = "UpgradeBoardModel",    currency = "Qi" },
    { label = "Essence",         module = "EssenceUpgradeConfig", currency = "Essence" },
    { label = "Insight",         module = "InsightUpgradeBoardModel", currency = "Insight" },
    { label = "Soul / Soulfire", module = "SoulUpgradeConfig",    currency = "Soulfire" },
    { label = "Beast Remnants",  module = "BeastUpgradeConfig",   currency = "BeastRemnants" },
    { label = "Jade",            module = "JadeUpgradeConfig",    currency = "Jade" },
    { label = "Star Forging",    module = "StarForgingConfig",    currency = "Stars" },
    { label = "Stars",           module = "StarUpgradeConfig",    currency = "Stars" },
    { label = "Nebula",          module = "NebulaUpgradeConfig",  currency = "Nebula" },
    { label = "Quasar",          module = "QuasarUpgradeConfig",  currency = "Quasar" },
    { label = "Miasma",          module = "MiasmaUpgradeConfig",  currency = "Miasma" },
    { label = "Ash",             module = "AshConfig",            currency = "Ash" },
    { label = "Laws",            module = "LawsUpgradeConfig",    currency = "Laws" },
    { label = "Faith",           module = "FaithUpgradeConfig",   currency = "Faith" },
    { label = "Divinity",        module = "DivinityUpgradeConfig",currency = "Divinity" },
    { label = "Flora",           module = "FloraUpgradeConfig",   currency = "Flora" },
    { label = "Dungeon",         module = "DungeonUpgradeConfig", currency = "DungeonSpiritstones" },
    { label = "Hydra",           module = "hydra_upgrade_config", currency = "Tian" },
    { label = "Hydra Mastery",   module = "hydra_mastery_config",  currency = "Tian" },
    { label = "Dao",             module = "DaoUpgradeBoardModel",  currency = "Dao" },
    { label = "Raid",            module = "raid_upgrade_config",  currency = "DungeonSpiritstones" },
    { label = "Souls",           module = "souls_config",         currency = "Souls" },
}
local _CurrencyAttrOverrides = {
    BeastRemnants = "BeastRemnants",
    DungeonSpiritstones = "DungeonSpiritstones",
}
local function GetCurrencyAttrPrefix(currency)
    return _CurrencyAttrOverrides[currency] or currency
end
local _CustomPurchaseRemote = {
    DungeonUpgradeConfig = "PurchaseDungeonUpgrade",
    hydra_upgrade_config = { name = "purchase_remote_name", invoke = true },
    hydra_mastery_config = { name = "purchase_remote_name", invoke = true },
    raid_upgrade_config  = { name = "purchase_remote_name", invoke = false },
    souls_config          = { name = "purchase_remote_name", invoke = false },
}
local _CustomLevelPrefix = {
    hydra_upgrade_config = "HydraUpgrade_",
    hydra_mastery_config = "HydraMastery_",
    raid_upgrade_config  = "RaidUpgrade_",
    souls_config          = "SoulsUpgrade_",
}
local _CostFuncName = {
    hydra_upgrade_config = "get_cost",
    hydra_mastery_config = "get_cost",
    raid_upgrade_config  = "get_cost",
    souls_config          = "get_cost",
}
local _ClampFuncName = {
    hydra_upgrade_config = false,
    hydra_mastery_config = false,
    raid_upgrade_config  = "clamp_level",
    souls_config          = "clamp_level",
}
local function GetModuleCostFuncName(moduleName)
    return _CostFuncName[moduleName] or "GetCost"
end
local function GetModuleClampFuncName(moduleName)
    if _ClampFuncName[moduleName] == false then return nil end
    return _ClampFuncName[moduleName] or "ClampLevel"
end
local _SnapshotDrivenModules = {
    UpgradeBoardModel = true,
    InsightUpgradeBoardModel = true,
    DaoUpgradeBoardModel = true,
}
local function GetUpgradeListFromSnapshot(mod, player)
    if type(mod) ~= "table" or type(mod.GetSnapshot) ~= "function" then return {} end
    local ok, snapshot = pcall(mod.GetSnapshot, player)
    if not ok or type(snapshot) ~= "table" or type(snapshot.upgrades) ~= "table" then return {} end
    return snapshot.upgrades
end
local function GetUpgradeListFromModule(mod)
    if type(mod) ~= "table" then return {} end
    if type(mod.Upgrades) == "table" then return mod.Upgrades end
    if type(mod.upgrades) == "table" then return mod.upgrades end
    if type(mod.board_one_upgrades) == "table" and type(mod.board_two_upgrades) == "table" then
        local combined = {}
        for _, v in ipairs(mod.board_one_upgrades) do table.insert(combined, v) end
        for _, v in ipairs(mod.board_two_upgrades) do table.insert(combined, v) end
        return combined
    end
    if type(mod.board_one_upgrades) == "table" then return mod.board_one_upgrades end
    if type(mod.categories) == "table" then return mod.categories end
    return {}
end
local UpgradeGroups = {}
Tables.IsDungeonUpgrade = {}
Tables.UpgradeModuleById = {}
for _, source in ipairs(UpgradeGroupSources) do
    local mod = GetSafeModule(Mods, source.module)
    local isSnapshotDriven = _SnapshotDrivenModules[source.module] == true
    local list = isSnapshotDriven
        and GetUpgradeListFromSnapshot(mod, Plr)
        or  GetUpgradeListFromModule(mod)
    local ids = {}
    local remoteInfo = _CustomPurchaseRemote[source.module]
    local remoteName = "PurchaseUpgrade"
    local remoteInvoke = false
    if type(remoteInfo) == "string" then
        remoteName = remoteInfo
    elseif type(remoteInfo) == "table" then
        remoteName = (mod and type(mod[remoteInfo.name]) == "string" and mod[remoteInfo.name]) or source.label
        remoteInvoke = remoteInfo.invoke == true
    end
    for _, def in ipairs(list) do
        if type(def) == "table" and def.id then
            table.insert(ids, def.id)
            if isSnapshotDriven then
                Tables.UpgradeModuleById[def.id] = {
                    name = def.name or def.id,
                    snapshotDriven = true,
                    snapshotModule = source.module,
                    purchaseRemoteName = remoteName,
                    purchaseInvoke = remoteInvoke,
                }
            else
                Tables.UpgradeModuleById[def.id] = {
                    name = def.name or def.id,
                    maxLevel = def.maxLevel or def.max_level,
                    costModule = source.module,
                    costFuncName = GetModuleCostFuncName(source.module),
                    clampFuncName = GetModuleClampFuncName(source.module),
                    costMult = def.costMult,
                    baseCost = def.baseCost,
                    mantissaAttr = GetCurrencyAttrPrefix(source.currency) .. "Mantissa",
                    exponentAttr = GetCurrencyAttrPrefix(source.currency) .. "Exponent",
                    levelAttrPrefix = _CustomLevelPrefix[source.module] or "Upgrade_",
                    purchaseRemoteName = remoteName,
                    purchaseInvoke = remoteInvoke,
                }
            end
            if source.module == "DungeonUpgradeConfig" then
                Tables.IsDungeonUpgrade[def.id] = true
            end
        end
    end
    table.insert(UpgradeGroups, { label = source.label, ids = ids })
end
local function AddRebirthUI(box, key, prefix, label, purchaseFunc)
    box:AddInput(prefix .. "Num", { Text = label .. " gain", Default = "1", ClearTextOnFocus = false,})
    box:AddToggle("AutoPurchase" .. prefix, {
        Text = label .. " Rebirth",
        Default = false,
        Callback = function(val)
            Thread("AutoPurchase" .. prefix, purchaseFunc, val)
        end
    })
end
for _, group in ipairs(UpgradeGroups) do
    for _, id in ipairs(group.ids) do
        table.insert(Tables.AllUpgradeIds, id)
    end
end
for _, group in ipairs(UpgradeGroups) do
    for _, id in ipairs(group.ids) do
        local info = Tables.UpgradeModuleById[id]
        local friendlyName = (info and info.name) or id
        friendlyName = tostring(friendlyName):gsub("<[^>]+>", "")
        local label = group.label .. " | " .. friendlyName .. " [" .. id .. "]"
        table.insert(Tables.DropdownValues, label)
        Tables.DropdownIdMap[label] = id
    end
end
for _, group in ipairs(UpgradeGroups) do
    table.insert(Tables.BoardGroupLabels, group.label)
    Tables.BoardGroupIdMap[group.label] = group.ids
end
local function CalcUpgradeCost(costMult, level, baseCost)
    local powered = type(costMult) == "table"
        and Modules.BigNumber.pow(costMult, level)
        or  Modules.BigNumber.powNumber(costMult, level)
    local cost = type(baseCost) == "table"
        and Modules.BigNumber.mul(powered, baseCost)
        or  Modules.BigNumber.mulNumber(powered, baseCost)
    return Modules.BigNumber.round(cost)
end
for id, info in pairs(Tables.UpgradeModuleById) do
    Tables.UpgradeAffordMap[id] = {
        maxLevel     = info.maxLevel,
        costModule   = info.costModule,
        costFuncName = info.costFuncName,
        clampFuncName = info.clampFuncName,
        costMult = info.costMult,
        baseCost = info.baseCost,
        mantissaAttr = info.mantissaAttr,
        exponentAttr = info.exponentAttr,
        levelAttrPrefix = info.levelAttrPrefix,
        purchaseRemoteName = info.purchaseRemoteName,
        purchaseInvoke = info.purchaseInvoke,
        snapshotDriven = info.snapshotDriven,
        snapshotModule = info.snapshotModule,
    }
end
local function GainQi()
    while true do
        local ok, e = pcall(function()
            Remotes.GainQi:FireServer()
        end)
        if not ok then end
        task.wait()
    end
end
local function GainMiasma()
    while true do
        local ok, e = pcall(function()
            Remotes.GainMiasma:FireServer()
        end)
        if not ok then end
        task.wait()
    end
end
local function GainDao()
    while true do
        local ok, e = pcall(function()
            Remotes.DaoClick:FireServer()
        end)
        if not ok then end
        task.wait()
    end
end
local function PurchaseInsight()
    while true do
        local snap = Modules.InsightResetBoardModel.GetSnapshot(Plr)
        if snap and snap.gain and Modules.BigNumber.compare(snap.gain, Modules.BigNumber.fromNumber(tonumber(Options.InsightNum.Value) or 1)) >= 0 then
            local ok, e = pcall(function()
                Remotes.PurchaseInsight:FireServer()
            end)
            if not ok then end
        end
        task.wait()
    end
end
local function PurchaseSoulfire()
    while true do
        local snap = Modules.SoulResetBoardModel.GetSnapshot(Plr)
        if snap and snap.gain and Modules.BigNumber.compare(snap.gain, Modules.BigNumber.fromNumber(tonumber(Options.SoulfireNum.Value) or 1)) >= 0 then
            local ok, e = pcall(function()
                Remotes.PurchaseSoulfire:FireServer()
            end)
            if not ok then end
        end
        task.wait()
    end
end
local function PurchaseNebula()
    while true do
        local snap = Modules.NebulaResetBoardModel.GetSnapshot(Plr)
        if snap and snap.gain and Modules.BigNumber.compare(snap.gain, Modules.BigNumber.fromNumber(tonumber(Options.NebulaNum.Value) or 1)) >= 0 then
            local ok, e = pcall(function()
                Remotes.PurchaseNebula:FireServer()
            end)
            if not ok then end
        end
        task.wait()
    end
end
local function PurchaseAsh()
    while true do
        local snap = Modules.AshResetBoardModel.GetSnapshot(Plr)
        if snap and not snap.belowThreshold and snap.nextGain and Modules.BigNumber.compare(snap.nextGain, Modules.BigNumber.fromNumber(tonumber(Options.AshNum.Value) or 1)) >= 0 then
            local ok, e = pcall(function()
                Remotes.PurchaseAsh:FireServer()
            end)
            if not ok then end
        end
        task.wait()
    end
end
local function PurchaseLaws()
    while true do
        local snap = Modules.LawsResetBoardModel.GetSnapshot(Plr)
        if snap and not snap.belowThreshold and snap.gain and Modules.BigNumber.compare(snap.gain, Modules.BigNumber.fromNumber(tonumber(Options.LawsNum.Value) or 1)) >= 0 then
            local ok, e = pcall(function()
                Remotes.PurchaseLaws:FireServer()
            end)
            if not ok then end
        end
        task.wait()
    end
end
local function ClaimRefinement()
    while true do
        local ok, e = pcall(function()
            Remotes.ClaimRefinement:FireServer()
        end)
        if not ok then end
        task.wait()
    end
end
local function EnableServerAutoClick(enabled)
    if not Remotes.UpdatePlayerOption then
        return
    end
    local ok, e = pcall(function()
        Remotes.UpdatePlayerOption:InvokeServer("AutoClickEnabled", enabled)
    end)
    if not ok then end
end
local function AutoRollBloodline()
    while true do
        local ok, e = pcall(function()
            Remotes.RollBloodline:InvokeServer()
        end)
        if not ok then end
        task.wait(0.1)
    end
end
local function AutoUpgradeBloodline()
    while true do
        local label = Options.BloodlineUpgradeSelect.Value
        local selectedId = label and Tables.BloodlineTables.DropdownIdMap[label]
        if selectedId and selectedId ~= "" then
            local level = math.max(
                Modules.BloodlineConfig.ClampLevel(Plr:GetAttribute("BeastBloodlineLevel_" .. selectedId)) or 0,
                0
            )
            if level < Modules.BloodlineConfig.MAX_LEVEL then
                local ok, e = pcall(function()
                    Remotes.UpgradeBloodline:InvokeServer(selectedId)
                end)
                if not ok then end
            end
        end
        task.wait(0.5)
    end
end
local function AutoRollSpiritRoot()
    while true do
        local ok, e = pcall(function()
            Remotes.RollSpiritRoot:InvokeServer()
        end)
        if not ok then end
        task.wait(0.1)
    end
end
local function AutoUpgradeSpiritRoot()
    while true do
        local label = Options.SpiritRootUpgradeSelect.Value
        local selectedId = label and Tables.SpiritRootTables.DropdownIdMap[label]
        if selectedId and selectedId ~= "" then
            local level = math.max(
                Modules.SpiritRootConfig.ClampLevel(Plr:GetAttribute("SpiritRootLevel_" .. selectedId)) or 0,
                0
            )
            if level < Modules.SpiritRootConfig.MAX_LEVEL then
                local ok, e = pcall(function()
                    Remotes.UpgradeSpiritRoot:InvokeServer(selectedId)
                end)
                if not ok then end
            end
        end
        task.wait(0.5)
    end
end
local function AutoConvertSpiritRootCores()
    while true do
        local ok, e = pcall(function()
            Remotes.ConvertSpiritRootCores:InvokeServer("all")
        end)
        if not ok then end
        task.wait(1)
    end
end
local function AutoConvertCitizensToFaith()
    while true do
        if Modules.FaithConvertBoardModel then
            local snap = Modules.FaithConvertBoardModel.GetSnapshot(Plr)
            if snap and snap.canConvert == true then
                local ok, e = pcall(function()
                    Remotes.ConvertCitizensToFaith:FireServer()
                end)
                if not ok then end
            end
        end
        task.wait(1)
    end
end
local function AutoBeastStageMax()
    while true do
        local current = math.max(1, math.floor(tonumber(Plr:GetAttribute("BeastCurrentStage")) or 1))
        local highest = math.max(1, math.floor(tonumber(Plr:GetAttribute("BeastHighestStage")) or 1))
        if current < highest then
            local remote = Remotes.SetBeastStage
            if not (remote and remote.Parent) then
                remote = RemoteEvents:FindFirstChild("SetBeastStage")
            end
            if remote then
                local ok, e = pcall(function()
                    remote:FireServer(highest)
                end)
                if not ok then end
            end
        end
        task.wait(1)
    end
end
local function AutoQuasar()
    while true do
        if Plr:GetAttribute("QuasarCultivating") ~= true then
            local ok, e = pcall(function()
                Remotes.ToggleQuasarCultivation:FireServer()
            end)
            if not ok then end
        end
        task.wait(1)
    end
end
local function AutoDaoCultivation()
    while true do
        if Plr:GetAttribute("DaoCultivating") ~= true then
            local ok, e = pcall(function()
                Remotes.ToggleDaoCultivation:FireServer()
            end)
            if not ok then end
        end
        task.wait(1)
    end
end
local function AutoSoulsAngels()
    while true do
        local cfg = Modules.AngelsConfig
        local souls = _BN_getBigNumberAttr(Plr, "Souls")
        local minSouls = (cfg and cfg.minimum_conversion_souls) or Modules.BigNumber.fromNumber(1000)
        if Modules.BigNumber.compare(souls, minSouls) >= 0 then
            local remote = Remotes.ConvertSoulsToAngels or (RemoteEvents and RemoteEvents:FindFirstChild("convert_souls_to_angels"))
            if remote then
                pcall(function()
                    if remote:IsA("RemoteFunction") then
                        remote:InvokeServer()
                    else
                        remote:FireServer()
                    end
                end)
            end
        end
        task.wait(2)
    end
end
local function AutoHydra()
    while true do
        local cfg = Modules.HydraBossConfig
        if cfg and cfg.unlock_attribute and Plr:GetAttribute(cfg.unlock_attribute) ~= true then
            local remote = RemoteEvents and RemoteEvents:FindFirstChild(cfg.unlock_remote_name or "UnlockHydraVersion")
            if remote then
                pcall(function()
                    remote:InvokeServer()
                end)
            end
        end
        task.wait(2)
    end
end
local function AutoSect()
    while true do
        local cfg = Modules.SectConfig
        local order = (cfg and cfg.UPGRADE_ORDER) or { "MemberCapacity", "MoreStats", "MarkSpeed", "MarkBulk" }
        local label = Options.SectUpgradeSelect and Options.SectUpgradeSelect.Value
        local id = (Tables.SectUpgradeIdMap and label and Tables.SectUpgradeIdMap[label]) or order[1]
        if id then
            local remote = Remotes.SpendSectUpgradePoint or (RemoteEvents and RemoteEvents:FindFirstChild("SpendSectUpgradePoint"))
            if remote then
                pcall(function()
                    remote:InvokeServer(id)
                end)
            end
        end
        task.wait(5)
    end
end
local function TeleportToButton(part)
    local char = Plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not part or not part.Parent then return end
    if (root.Position - part.Position).Magnitude > 10 then
        root.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
    end
end
local function AutoPurchaseAnima()
    while true do
        if Modules.AnimaResetBoardModel then
            local snap = Modules.AnimaResetBoardModel.GetSnapshot(Plr)
            if snap and snap.unlocked and not snap.belowThreshold then
                local gain = snap.gain or BigNumber.zero()
                if Modules.BigNumber.compare(gain, Modules.BigNumber.fromNumber(tonumber(Options.AnimaNum.Value) or 1)) >= 0 then
                    local ok, e = pcall(function()
                        Remotes.PurchaseAnima:FireServer()
                    end)
                    if not ok then end
                end
            end
        end
        task.wait(1)
    end
end
local function AutoReincarnation()
    while true do
        if Modules.ReincarnationBoardModel then
            local snap = Modules.ReincarnationBoardModel.GetSnapshot(Plr)
            if snap and snap.canReincarnate == true then
                local ok, e = pcall(function()
                    return Remotes.RequestReincarnation:InvokeServer()
                end)
                if not ok then end
            end
        end
        task.wait(2)
    end
end
local function AutoTierUp()
    while true do
        if Plr:GetAttribute("DivinityUnlocked") == true then
            local ok, e = pcall(function()
                Remotes.TierUpWorld:FireServer()
            end)
            if not ok then end
        end
        task.wait(1)
    end
end
local ResolveGenSelected
local function AutoBuyGen()
    while true do
        if Plr:GetAttribute("VitalityUnlocked") == true then
            local selected = ResolveGenSelected()
            for gid, active in pairs(selected) do
                if active then
                    if gid then
                        local ok, e = pcall(function()
                            Remotes.PurchaseVitalityGenerator:FireServer(gid, true)
                        end)
                        if not ok then end
                    end
                end
            end
        end
        task.wait(0.5)
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
        T2 = TB.Main.Left.Autofarm:AddTab("Rebirth"),
        T3 = TB.Main.Left.Autofarm:AddTab("Misc"),
        T4 = TB.Main.Left.Autofarm:AddTab("Misc69"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Button"),
        T2 = TB.Main.Right.Autofarm:AddTab("Upgrades"),
    },
}
TB_Tabs.Autofarm.T1:AddToggle("AutoClick", {
    Text = "Auto Click",
    Default = false,
    Callback = function(val)
        Thread("AutoClick", GainQi, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoClickMiasma", {
    Text = "Auto Click Miasma",
    Default = false,
    Callback = function(val)
        Thread("AutoClickMiasma", GainMiasma, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoClickDao", {
    Text = "Auto Click Dao",
    Default = false,
    Callback = function(val)
        Thread("AutoClickDao", GainDao, val)
    end
})
AddRebirthUI(TB_Tabs.Autofarm.T2, "Insight",  "Insight",  "Insight",  PurchaseInsight)
AddRebirthUI(TB_Tabs.Autofarm.T2, "Soulfire", "Soulfire", "Soulfire", PurchaseSoulfire)
AddRebirthUI(TB_Tabs.Autofarm.T2, "Nebula",   "Nebula",   "Nebula",   PurchaseNebula)
AddRebirthUI(TB_Tabs.Autofarm.T2, "Ash",      "Ash",      "Ash",      PurchaseAsh)
AddRebirthUI(TB_Tabs.Autofarm.T2, "Laws",     "Laws",     "Laws",     PurchaseLaws)
AddRebirthUI(TB_Tabs.Autofarm.T2, "Anima",   "Anima",   "Anima",   AutoPurchaseAnima)
TB_Tabs.Autofarm.T1:AddToggle("UpgradeBody", {
    Text = "Auto Body Tempering",
    Default = false,
    Callback = function(val)
        Thread("UpgradeBody", ClaimRefinement, val)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectStar", {
    Text = "Collect Star",
    Default = false,
    Callback = function(val)
        Thread("AutoCollectStar", function()
            while true do
                local char = Plr.Character or Plr.CharacterAdded:Wait()
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then task.wait() continue end
                for _, star in pairs(getStars()) do
                    if not Toggles.AutoCollectStar.Value then break end
                    local pos = getStarPosition(star)
                    if pos then
                        root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                        task.wait(0.175)
                    end
                end
                task.wait()
            end
        end, val)
    end
})
TB_Tabs.Autofarm.T3:AddToggle("AutoQuasar", {
    Text = "Auto Quasar",
    Default = false,
    Callback = function(val)
        Thread("AutoQuasar", AutoQuasar, val)
    end
})
TB_Tabs.Autofarm.T3:AddToggle("AutoHydra", {
    Text = "Auto Hydra",
    Default = false,
    Callback = function(val)
        Thread("AutoHydra", AutoHydra, val)
    end
})
TB_Tabs.Autofarm.T3:AddToggle("AutoDaoCultivation", {
    Text = "Auto Dao Cultivation",
    Default = false,
    Callback = function(val)
        Thread("AutoDaoCultivation", AutoDaoCultivation, val)
    end
})
TB_Tabs.Autofarm.T3:AddToggle("AutoSoulsAngels", {
    Text = "Auto Souls to Angels",
    Default = false,
    Callback = function(val)
        Thread("AutoSoulsAngels", AutoSoulsAngels, val)
    end
})
TB_Tabs.Autofarm.T3:AddDropdown("SectUpgradeSelect", {
    Text = "Sect Upgrade",
    Values = Tables.SectUpgradeDropdownValues,
    Default = Tables.SectUpgradeDropdownValues[1] or "",
    Multi = false,
    Searchable = true,
})
TB_Tabs.Autofarm.T3:AddToggle("AutoSect", {
    Text = "Auto Sect",
    Default = false,
    Callback = function(val)
        Thread("AutoSect", AutoSect, val)
    end
})
local ResolvePotionSelect = AddMultiDropdown(TB_Tabs.Autofarm.T3, "PotionSelect", {
    Text = "Potions List",
    Values = Tables.PotionDropdownValues,
    Default = {},
    label = Tables.PotionLabelToId,
})
TB_Tabs.Autofarm.T3:AddToggle("AutoUsePotion", {
    Text = "Auto Potions",
    Default = false,
    Callback = function(val)
        Thread("AutoUsePotion", function()
            while true do
                local selected = ResolvePotionSelect()
                for potionId, active in pairs(selected) do
                    if active then
                        if potionId then
                            local ownedMantissa = tonumber(Plr:GetAttribute("PotionOwned_" .. potionId .. "Mantissa")) or 0
                            local ownedExponent = tonumber(Plr:GetAttribute("PotionOwned_" .. potionId .. "Exponent")) or 0
                            local owned = Modules.BigNumber.compare(
                                Modules.BigNumber.fromParts(ownedMantissa, ownedExponent),
                                Modules.BigNumber.fromNumber(0)
                            ) > 0
                            local remaining = math.max(0, math.floor(tonumber(Plr:GetAttribute("PotionActive_" .. potionId .. "RemainingSeconds")) or 0))
                            if owned and remaining <= 0 then
                                local ok, e = pcall(function()
                                    Remotes.UsePotion:InvokeServer(potionId)
                                end)
                                if not ok then end
                            end
                        end
                    end
                end
                task.wait(5)
            end
        end, val)
    end
})
TB_Tabs.Autofarm.T4:AddToggle("AutoRollBloodline", {
    Text = "Auto Roll Bloodline",
    Default = false,
    Callback = function(val)
        Thread("AutoRollBloodline", AutoRollBloodline, val)
    end
})
TB_Tabs.Autofarm.T4:AddDropdown("BloodlineUpgradeSelect", {
    Text = "Bloodline List",
    Values = Tables.BloodlineTablesDropdownValues,
    Default = Tables.BloodlineTablesDropdownValues[1] or "",
    Multi = false,
    Searchable = true,
    Callback = function(label)
        local id = Tables.BloodlineTables.DropdownIdMap[label]
        if id then
            Options.BloodlineUpgradeSelect:SetValue(label)
        end
    end
})
TB_Tabs.Autofarm.T4:AddToggle("AutoUpgradeBloodline", {
    Text = "Auto Upgrade Bloodline",
    Default = false,
    Callback = function(val)
        Thread("AutoUpgradeBloodline", AutoUpgradeBloodline, val)
    end
})
TB_Tabs.Autofarm.T4:AddToggle("AutoRollSpiritRoot", {
    Text = "Auto Spirit Root",
    Default = false,
    Callback = function(val)
        Thread("AutoRollSpiritRoot", AutoRollSpiritRoot, val)
    end
})
TB_Tabs.Autofarm.T4:AddDropdown("SpiritRootUpgradeSelect", {
    Text = "Spirit Root List",
    Values = Tables.SpiritRootTablesDropdownValues,
    Default = Tables.SpiritRootTablesDropdownValues[1] or "",
    Multi = false,
    Searchable = true,
    Callback = function(label)
        local id = Tables.SpiritRootTables.DropdownIdMap[label]
        if id then
            Options.SpiritRootUpgradeSelect:SetValue(label)
        end
    end
})
TB_Tabs.Autofarm.T4:AddToggle("AutoUpgradeSpiritRoot", {
    Text = "Auto Upgrade Spirit Root",
    Default = false,
    Callback = function(val)
        Thread("AutoUpgradeSpiritRoot", AutoUpgradeSpiritRoot, val)
    end
})
TB_Tabs.Autofarm.T4:AddToggle("AutoConvertSpiritRootCores", {
    Text = "Auto Convert Spirit Root",
    Default = false,
    Callback = function(val)
        Thread("AutoConvertSpiritRootCores", AutoConvertSpiritRootCores, val)
    end
})
TB_Tabs.Autofarm.T4:AddToggle("AutoConvertCitizensToFaith", {
    Text = "Auto Convert Citizens",
    Default = false,
    Callback = function(val)
        Thread("AutoConvertCitizensToFaith", AutoConvertCitizensToFaith, val)
    end
})
TB_Tabs.Autofarm.T4:AddToggle("AutoReincarnation", {
    Text = "Auto Reincarnation",
    Default = false,
    Callback = function(val)
        Thread("AutoReincarnation", AutoReincarnation, val)
    end
})
TB_Tabs.Autofarm.T4:AddToggle("AutoTierUp", {
    Text = "Auto Tier Up",
    Default = false,
    Callback = function(val)
        Thread("AutoTierUp", AutoTierUp, val)
    end
})
ResolveGenSelected = AddMultiDropdown(TB_Tabs.Autofarm.T4, "GenSelected", {
    Text = "Vitality List",
    Values = Tables.VitalityGeneratorDropdownValues,
    Default = {},
    label = Tables.VitalityGeneratorMap,
})
TB_Tabs.Autofarm.T4:AddToggle("AutoBuyGen", {
    Text = "Auto Vitality",
    Default = false,
    Callback = function(val)
        Thread("AutoBuyGen", AutoBuyGen, val)
    end
})
local ResolveTouchButtonSelect = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "TouchButtonSelect", {
    Text = "Select Buttons",
    Values = Tables.TouchButtonList,
    Default = {},
})
TB_Tabs.Autofarm2.T1:AddSlider("TouchButtonDelay", {
    Text = "Switch Delay (s)",
    Default = 0.5,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Compact = true,
})
TB_Tabs.Autofarm2.T1:AddToggle("AutoTouchButtons", {
    Text = "Teleport to buttons",
    Default = false,
    Callback = function(val)
        Thread("AutoTouchButtons", function()
            while true do
                local selected = ResolveTouchButtonSelect()
                local delay = Options.TouchButtonDelay.Value
                for label, active in pairs(selected) do
                    if active then
                        local part = Tables.TouchButtonMap[label]
                        if part and part.Parent then
                            TeleportToButton(part)
                            task.wait(delay)
                        end
                    end
                end
                task.wait()
            end
        end, val)
    end
})
local ResolveUpgradeSelect = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "UpgradeSelect", {
    Text = "Select Upgrades",
    Values = Tables.DropdownValues,
    Default = {},
    label = Tables.DropdownIdMap,
})
TB_Tabs.Autofarm2.T2:AddToggle("AutoUpgrade", {
    Text = "Auto Upgrade",
    Default = false,
    Callback = function(val)
        Thread("AutoUpgrade", function()
            while true do
                local selected = ResolveUpgradeSelect()
                for id, active in pairs(selected) do
                    if active then
                        if id then
                            local info = Tables.UpgradeAffordMap[id]
                            local canAfford = true
                            local levelPrefix = (info and info.levelAttrPrefix) or "Upgrade_"
                            if info and info.snapshotDriven then
                                local mod = GetSafeModule(Mods, info.snapshotModule)
                                local snapshotEntry = nil
                                if mod and type(mod.GetSnapshot) == "function" then
                                    local ok, snapshot = pcall(mod.GetSnapshot, Plr)
                                    if ok and type(snapshot) == "table" and type(snapshot.upgrades) == "table" then
                                        for _, entry in ipairs(snapshot.upgrades) do
                                            if entry.id == id then
                                                snapshotEntry = entry
                                                break
                                            end
                                        end
                                    end
                                end
                                canAfford = snapshotEntry ~= nil and snapshotEntry.canAfford == true
                            elseif info and info.costModule and info.costFuncName then
                                local mod = GetSafeModule(Mods, info.costModule)
                                local rawLevel = math.max(0, math.floor(tonumber(Plr:GetAttribute(levelPrefix .. id)) or 0))
                                local level = rawLevel
                                if mod and info.clampFuncName and type(mod[info.clampFuncName]) == "function" then
                                    local okClamp, clamped = pcall(mod[info.clampFuncName], id, rawLevel)
                                    if okClamp and type(clamped) == "number" then
                                        level = clamped
                                    end
                                elseif info.maxLevel then
                                    level = math.max(0, math.min(rawLevel, info.maxLevel))
                                end
                                local cost = nil
                                if mod and type(mod[info.costFuncName]) == "function" then
                                    local okCost, result = pcall(mod[info.costFuncName], id, level)
                                    if okCost then cost = result end
                                elseif info.costMult ~= nil and info.baseCost ~= nil then
                                    cost = CalcUpgradeCost(info.costMult, level, info.baseCost)
                                end
                                if cost ~= nil then
                                    local currency = Modules.BigNumber.fromParts(
                                        Plr:GetAttribute(info.mantissaAttr),
                                        Plr:GetAttribute(info.exponentAttr)
                                    )
                                    canAfford = Modules.BigNumber.compare(currency, Modules.BigNumber.fromValue(cost)) >= 0
                                else
                                    canAfford = false
                                    notyuri("[AutoUpgrade] cost resolution failed for id=" .. tostring(id) .. " costModule=" .. tostring(info.costModule) .. " costFuncName=" .. tostring(info.costFuncName) .. " (mod=" .. tostring(mod ~= nil) .. ")")
                                end
                            end
                            if canAfford then
                                local remoteName = (info and info.purchaseRemoteName) or "PurchaseUpgrade"
                                local remote = RemoteEvents and RemoteEvents:FindFirstChild(remoteName)
                                pcall(function()
                                    if not remote then return end
                                    if info and info.purchaseInvoke then
                                        remote:InvokeServer(id, true)
                                    else
                                        remote:FireServer(id, true)
                                    end
                                end)
                                task.wait()
                            end
                        end
                    end
                end
                task.wait()
            end
        end, val)
    end
})
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
AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip2", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
GB.Player.Left.General:AddToggle("Fullbright2", { Text = "Fullbright" })
GB.Player.Left.General:AddToggle("NoFog2", { Text = "No Fog" })
GB.Player.Left.General:AddToggle("InstantPP2", { Text = "Instant Prompt" })
GB.Player.Left.Server:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK2", { Text = "Anti AFK", Default = true })
GB.Player.Left.Server:AddToggle("AntiKick2", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect2", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused2", { Text = "No Gameplay Paused" })
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if not ok or not res or not res.data then return end
    local currentId = game.JobId
    for _, server in ipairs(res.data) do
        if server.id ~= currentId and server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
            return
        end
    end
end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function()
    TeleportService:Teleport(game.PlaceId, Plr)
end })
GB.Player.Left.Server:AddToggle("AutoServerhop2", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins2", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
RunService.Stepped:Connect(function()
    local hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if Toggles.WS.Value then hum.WalkSpeed = Options.WSValue.Value end
        if Toggles.JP.Value then hum.JumpPower = Options.JPValue.Value; hum.UseJumpPower = true end
        if Toggles.HH.Value then hum.HipHeight = Options.HHValue.Value end
    end
    workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 196
    if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
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
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        local pollStart = tick()
        while not root and char.Parent and (tick() - pollStart) < 10 do
            task.wait()
            root = char:FindFirstChild("HumanoidRootPart")
        end
    end
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
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(0.2)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
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
SaveManager:SetFolder("Yuri/ImmortalityIncremental")
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