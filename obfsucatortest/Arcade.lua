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
    SummonGacha = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("SummonGacha")),
    RollTrait = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("RollTrait")),
    ToggleTraitAutoRoll = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("ToggleTraitAutoRoll")),
    SetAutoRollTarget = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("SetAutoRollTarget")),
    BuyUpgrade = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("BuyUpgrade")),
    PurchaseDice = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("PurchaseDice")),
    EquipDice = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("EquipDice")),
    EquipBest = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("EquipBest")),
    RebirthRemote = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("RebirthRemote")),
    ClaimIndex = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("ClaimIndex")),
    ClaimDaily = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("ClaimDaily")),
    ClaimPlaytimeReward = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("ClaimPlaytimeReward")),
    GrantOfflineCash = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("GrantOfflineCash")),
    UsePotion = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("UsePotion")),
    RedeemCode = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("RedeemCode")),
    LikeBase = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("LikeBase")),
    DeleteTools = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("DeleteTools")),
    PlaceModel = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("PlaceModel")),
    RepairSlot = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("RepairSlot")),
    PlacePodium = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("PlacePodium")),
    Teleport = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("Teleport")),
    PurchaseDailyItem = (RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("PurchaseDailyItem")),
}
local Flags = {}
local Shared = {}
local Tables = {
    UpgradeList = {},
    UpgradeMap = {},
    DiceList = {},
    DiceMap = {},
    PotionList = {},
    PotionMap = {},
    BannerList = {"Special", "Summer"},
    BannerMap = {Special = "Special", Summer = "Summer"},
    TraitList = {},
    TraitMap = {},
    DailyItemList = {},
}
local Modules = {
    UpgradeData = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Services") and RS.Scripts.Services:FindFirstChild("UpgradeService"), "UpgradeData"),
    DiceData = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Services") and RS.Scripts.Services:FindFirstChild("LuckService"), "DiceData"),
    ItemData = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Services") and RS.Scripts.Services:FindFirstChild("ItemService"), "ItemData"),
    ModelData = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Services") and RS.Scripts.Services:FindFirstChild("ModelService"), "ModelData"),
    BoardData = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Services") and RS.Scripts.Services:FindFirstChild("GachaService"), "BoardData"),
    Requirements = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Services") and RS.Scripts.Services:FindFirstChild("RebirthServices"), "Requirements"),
    TraitsData = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Services") and RS.Scripts.Services:FindFirstChild("ModelService"), "TraitsData"),
    ReplicaUtils = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Packages"), "ReplicaUtils"),
    DailyShopData = GetSafeModule(RS:FindFirstChild("Scripts") and RS.Scripts:FindFirstChild("Services") and RS.Scripts.Services:FindFirstChild("DailyService"), "DailyShopData"),
}
local UpgradeData = Modules.UpgradeData
local DiceData = Modules.DiceData
local ItemData = Modules.ItemData
local ModelData = Modules.ModelData
local BoardData = Modules.BoardData
local Requirements = Modules.Requirements
local TraitsData = Modules.TraitsData
local ReplicaUtils = Modules.ReplicaUtils
local DailyShopData = Modules.DailyShopData
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
local function GetReplica()
    if not ReplicaUtils then return nil end
    local ok, rep = pcall(ReplicaUtils.GetReplica)
    return ok and rep or nil
end
local function GetData(path)
    local rep = GetReplica()
    if not rep or not rep.Data then return nil end
    local current = rep.Data
    for _, key in ipairs(path) do
        if type(current) ~= "table" then return nil end
        current = current[key]
        if current == nil then return nil end
    end
    return current
end
local function GetStars()
    return tonumber(GetData({"leaderstats", "Stars"}) or 0) or 0
end
local function GetClovers()
    return tonumber(GetData({"leaderstats", "Clovers"}) or 0) or 0
end
local function GetMoney()
    return tonumber(GetData({"leaderstats", "Money"}) or 0) or 0
end
local function GetRebirths()
    return tonumber(GetData({"leaderstats", "Rebirths"}) or 0) or 0
end
local function CanRebirth()
    local clovers = GetClovers()
    local rebirths = GetRebirths()
    if Requirements and Requirements.GetRequirements then
        local ok, req = pcall(Requirements.GetRequirements, rebirths + 1)
        if ok and req then
            return clovers >= (req.Cost or 0)
        end
    end
    if Requirements and Requirements.Tiers then
        local tier = Requirements.Tiers[rebirths + 1]
        if tier then
            return clovers >= (tier.Cost or 0)
        end
    end
    return false
end
do
    local function AddUpgrade(id, name)
        local label = tostring(name)
        table.insert(Tables.UpgradeList, label)
        Tables.UpgradeMap[label] = id
    end
    if UpgradeData and UpgradeData.Upgrades then
        for id, def in pairs(UpgradeData.Upgrades) do
            if type(def) == "table" then
                AddUpgrade(id, id)
            end
        end
        table.sort(Tables.UpgradeList)
    end
    if #Tables.UpgradeList == 0 then
        local fallback = {
            "Luck I", "Friend Luck", "Offline Time", "Max Inventory", "Clover %",
            "Luck II", "Income Rate", "Roll Speed", "Extra Stars",
            "Buy Loadout 3", "Buy Loadout 4", "Buy Loadout 5",
            "Mutation Luck Potion I", "Summon Luck Potion I", "Summon Luck Potion II",
            "Purchase Daily", "2x Offline Cash", "MORE Luck", "MORE Yen", "Faster Rolls",
        }
        for _, id in ipairs(fallback) do AddUpgrade(id, id) end
    end
end
do
    local function AddDice(id, name)
        local label = tostring(name)
        table.insert(Tables.DiceList, label)
        Tables.DiceMap[label] = id
    end
    if DiceData and DiceData.GetAllTiers then
        local ok, tiers = pcall(DiceData.GetAllTiers)
        if ok and type(tiers) == "table" then
            for id, def in pairs(tiers) do
                if type(def) == "table" and def.Name then
                    AddDice(id, def.Name)
                end
            end
        end
    end
    if #Tables.DiceList == 0 then
        local fallback = {
            {"SilverDice", "Silver Dice"},
            {"GoldDice", "Gold Dice"},
            {"NatureDice", "Nature Dice"},
            {"VolcanicDice", "Volcanic Dice"},
            {"ArcaneDice", "Arcane Dice"},
            {"StormDice", "Storm Dice"},
            {"DragonDice", "Dragon Dice"},
            {"TechDice", "Tech Dice"},
            {"NebulaDice", "Nebula Dice"},
            {"DevilDice", "Devil Dice"},
            {"ShadowDice", "Shadow Dice"},
            {"InkDice", "Ink Dice"},
            {"YinyangDice", "Yinyang Dice"},
            {"CursedDice", "Cursed Dice"},
            {"SealedDice", "Sealed Dice"},
            {"BloodmoonDice", "Bloodmoon Dice"},
        }
        for _, d in ipairs(fallback) do AddDice(d[1], d[2]) end
    end
    table.sort(Tables.DiceList)
end
do
    local function AddPotion(id, name)
        local label = tostring(name)
        table.insert(Tables.PotionList, label)
        Tables.PotionMap[label] = id
    end
    if ItemData and ItemData.GetAll then
        local ok, items = pcall(ItemData.GetAll)
        if ok and type(items) == "table" then
            for id, def in pairs(items) do
                if type(def) == "table" and def.Type == "Potion" then
                    AddPotion(id, id)
                end
            end
        end
    end
    if #Tables.PotionList == 0 then
        local fallback = {
            "Mutation Luck Potion I", "Mutation Luck Potion II",
            "Summon Luck Potion I", "Summon Luck Potion II",
            "Luck Potion I", "Luck Potion II", "Luck Potion III",
            "Clover Potion I", "Clover Potion II", "Clover Potion III",
            "Yen Potion I", "Yen Potion II", "Yen Potion III",
        }
        for _, id in ipairs(fallback) do AddPotion(id, id) end
    end
    table.sort(Tables.PotionList)
end
do
    if DailyShopData and DailyShopData.Items then
        for name in pairs(DailyShopData.Items) do
            table.insert(Tables.DailyItemList, tostring(name))
        end
        table.sort(Tables.DailyItemList)
    end
end
do
    if TraitsData and TraitsData.Order then
        for trait, order in pairs(TraitsData.Order) do
            local label = tostring(trait)
            table.insert(Tables.TraitList, label)
            Tables.TraitMap[label] = trait
        end
        table.sort(Tables.TraitList)
    end
    if #Tables.TraitList == 0 then
        local fallback = {
            "Haste 1", "Lucky 1", "Banker 1", "Haste 2", "Lucky 2", "Banker 2",
            "Haste 3", "Lucky 3", "Banker 3", "Leprechaun", "Blitz", "Fortune",
            "Gambler", "Honored", "Starlit", "Fate's Choice", "Sovereign",
        }
        for _, trait in ipairs(fallback) do
            table.insert(Tables.TraitList, trait)
            Tables.TraitMap[trait] = trait
        end
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
local function Func_AutoSummon()
    while true do
        local banner = Options.SummonBannerSelect.Value
        local count = Options.SummonCountValue.Value or 1
        if banner and banner ~= "" then
            local cost = 0
            if ModelData and ModelData.GachaStarCosts then
                cost = (ModelData.GachaStarCosts[banner] or 0) * count
            end
            if cost == 0 or GetStars() >= cost then
                FireRemote(Remotes.SummonGacha, banner, count)
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoRollTrait()
    while true do
        local selected = Options.TraitSelect.Value
        if selected then
            for label, active in pairs(selected) do
                if active then
                    local trait = Tables.TraitMap[label]
                    if trait then
                        FireRemote(Remotes.RollTrait, nil, trait)
                    end
                end
            end
        end
        task.wait(0.3)
    end
end
local function Func_AutoToggleTraitAutoRoll()
    while true do
        FireRemote(Remotes.ToggleTraitAutoRoll)
        task.wait(1)
    end
end
local function Func_AutoUpgrade()
    while true do
        local selected = Options.UpgradeSelect.Value
        for label, active in pairs(selected) do
            if active then
                local id = Tables.UpgradeMap[label]
                if id then
                    FireRemote(Remotes.BuyUpgrade, id)
                    task.wait(0.1)
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoBuyDice()
    while true do
        local label = Options.DiceSelect.Value
        local diceId = label and Tables.DiceMap[label]
        if diceId then
            FireRemote(Remotes.PurchaseDice, diceId, nil, true)
        end
        task.wait(1)
    end
end
local function Func_AutoEquipDice()
    while true do
        local label = Options.EquipDiceSelect.Value
        local diceId = label and Tables.DiceMap[label]
        if diceId and diceId ~= "" then
            FireRemote(Remotes.EquipDice, diceId)
        end
        task.wait(2)
    end
end
local function Func_AutoEquip()
    while true do
        FireRemote(Remotes.EquipBest)
        task.wait(10)
    end
end
local function Func_AutoRebirth()
    while true do
        if CanRebirth() then
            FireRemote(Remotes.RebirthRemote)
            task.wait(2)
        end
        task.wait(1)
    end
end
local function Func_AutoClaimIndex()
    while true do
        FireRemote(Remotes.ClaimIndex, "Basic Gacha")
        task.wait(5)
    end
end
local function Func_AutoClaimDaily()
    while true do
        FireRemote(Remotes.ClaimDaily, 1)
        task.wait(60)
    end
end
local function Func_AutoClaimPlaytime()
    while true do
        FireRemote(Remotes.ClaimPlaytimeReward, 1)
        task.wait(60)
    end
end
local function Func_AutoGrantOffline()
    while true do
        FireRemote(Remotes.GrantOfflineCash)
        task.wait(5)
    end
end
local function Func_AutoUsePotion()
    while true do
        local label = Options.PotionSelect.Value
        local potionId = label and Tables.PotionMap[label]
        if potionId then
            FireRemote(Remotes.UsePotion, potionId)
        end
        task.wait(5)
    end
end
local function Func_DailyItem()
    local label = Options.DailySelected.Value
    local qty = tonumber(Options.ItemQty.Value) or 100
    if label then
        FireRemote(Remotes.PurchaseDailyItem, label, -qty)
        FireRemote(Remotes.PurchaseDailyItem, label, qty)
    end
end
local function Func_InfDailyPoints()
    local label = Options.DailySelected.Value
    local qty = tonumber(Options.ItemQty.Value) or 100
    if label then
        FireRemote(Remotes.PurchaseDailyItem, label, -qty)
    end
end
local function Func_DupeDice()
    local label = Options.DiceSelect.Value
    local diceId = label and Tables.DiceMap[label]
    local qty = tonumber(Options.DupeDiceQty.Value) or 100
    if diceId then
        FireRemote(Remotes.PurchaseDice, diceId, -qty)
        FireRemote(Remotes.PurchaseDice, diceId, qty)
    end
end
local function Func_Inf()
    while true do
        local label = Options.DiceSelect.Value
        local diceId = label and Tables.DiceMap[label]
        if diceId then
            FireRemote(Remotes.PurchaseDice, "SilverDice", -1e7)
        end
        task.wait()
    end
end
local function Func_Nan()
    local label = Options.DiceSelect.Value
    local diceId = label and Tables.DiceMap[label]
    if diceId then
        FireRemote(Remotes.PurchaseDice, "SilverDice", 0/0)
    end
end
local function Func_AutoLikeBases()
    while true do
        local Plots = workspace:FindFirstChild("Plots")
        if Plots then
            for _, plot in ipairs(Plots:GetChildren()) do
                if plot:IsA("Model") or plot:IsA("Folder") then
                    local ownerId = plot:GetAttribute("OwnerId")
                    if ownerId and ownerId ~= 0 and ownerId ~= Plr.UserId then
                        FireRemote(Remotes.LikeBase, ownerId)
                    end
                end
            end
        end
        task.wait(10)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoSummon", { Text = "Auto Summon", Default = false, Callback = function(val) Thread("AutoSummon", Func_AutoSummon, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrades", Default = false, Callback = function(val) Thread("AutoUpgrade", Func_AutoUpgrade, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false, Callback = function(val) Thread("AutoRebirth", Func_AutoRebirth, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyDice", { Text = "Auto Buy Dice", Default = false, Callback = function(val) Thread("AutoBuyDice", Func_AutoBuyDice, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquipDice", { Text = "Auto Equip Dice", Default = false, Callback = function(val) Thread("AutoEquipDice", Func_AutoEquipDice, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip", Default = false, Callback = function(val) Thread("AutoEquip", Func_AutoEquip, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoUsePotion", { Text = "Auto Use Potion", Default = false, Callback = function(val) Thread("AutoUsePotion", Func_AutoUsePotion, val) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoClaimIndex", { Text = "Auto Claim Index", Default = false, Callback = function(val) Thread("AutoClaimIndex", Func_AutoClaimIndex, val) end })
TB_Tabs.Autofarm2.T1:AddDropdown("DailySelected", { Text = "Daily Item", Values = Tables.DailyItemList, Default = Tables.DailyItemList[1] or "" })
TB_Tabs.Autofarm2.T1:AddInput("ItemQty", {
    Text = "Dupe Amount",
    Default = "1e1",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm2.T1:AddButton({ Text = "Dupe Item", Func = function() Func_DailyItem() end })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Inf Daily Points", Func = function() Func_InfDailyPoints() end })
TB_Tabs.Autofarm.T1:AddInput("DupeDiceQty", {
    Text = "Dupe Dice Quantity",
    Default = "100",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T1:AddButton({ Text = "Dupe Dice", Func = function() Func_DupeDice() end })
TB_Tabs.Autofarm.T1:AddToggle("InfMoney", { Text = "Inf Money", Default = false, Callback = function(val) Thread("InfMoney", Func_Inf, val) end })
TB_Tabs.Autofarm.T1:AddButton({ Text = "NaN Money", Func = function() Func_Nan() end })
TB_Tabs.Autofarm2.T1:AddDropdown("SummonBannerSelect", { Text = "Banner", Values = Tables.BannerList, Default = Tables.BannerList[1] or "" })
TB_Tabs.Autofarm2.T1:AddInput("SummonCount", { Text = "Summon Count", Default = "1" })
TB_Tabs.Autofarm2.T1:AddDropdown("TraitSelect", { Text = "Traits to Roll", Values = Tables.TraitList, Default = {}, Multi = true })
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeSelect", { Text = "Upgrades", Values = Tables.UpgradeList, Default = {}, Multi = true })
TB_Tabs.Autofarm2.T1:AddDropdown("DiceSelect", { Text = "Dice to Buy", Values = Tables.DiceList, Default = Tables.DiceList[1] or "" })
TB_Tabs.Autofarm2.T1:AddDropdown("EquipDiceSelect", { Text = "Dice to Equip", Values = Tables.DiceList, Default = Tables.DiceList[1] or "" })
TB_Tabs.Autofarm2.T1:AddDropdown("PotionSelect", { Text = "Potion", Values = Tables.PotionList, Default = Tables.PotionList[1] or "" })
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
SaveManager:SetFolder("Yuri/BAAA")
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