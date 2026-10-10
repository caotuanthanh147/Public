if getgenv().yuriStart then
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
local yuri = {
    "https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
    "https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
    "https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/233/thumbnail.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/328/thumbnail.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1339/thumbnail.jpeg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1268/thumbnail.jpeg",
    "https://dynasty-scans.com/system/releases/000/040/979/001.webp",
    "https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2026/02/01/15/33/44/140636490_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2022/08/15/23/52/23/100515820_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2025/07/22/17/09/45/132989170_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2019/12/01/21/59/30/78092730_p0_master1200.jpg",
    "https://wbkwmsg.rdlriknctsha.hath.network/h/7c58877cf725169151ee98bfe289290e2976b20c-116766-800-1138-wbp/keystamp=1778143500-d7ddc8e912;fileindex=223059010;xres=800/001.webp",
    "https://iztbpmb.oppclkfsktcd.hath.network/h/edeb55ba6927f6a29a4a44fdbadb07b5b41d70b2-101318-800-1131-wbp/keystamp=1778143500-f077e9bb56;fileindex=158044327;xres=800/4_004.webp",
    "https://jjxguov.ijurokhfdith.hath.network/h/b4fd528c209a53219debf57b8b01be1072474c74-81916-583-828-wbp/keystamp=1778143800-242b613e89;fileindex=105058631;xres=800/01.webp",
    "https://nkedtzs.esrevwcpgcmt.hath.network:5475/h/4e62a3f9ea8e1081805071ed6b282097ac5b2e8e-159684-800-1159-wbp/keystamp=1778143800-80eae18d83;fileindex=158318688;xres=800/001.webp",
    "https://xdpkglu.qoakbywdoora.hath.network:60996/h/749e2fad6017fef020f4a459c12d7449726d7a3a-106344-800-1130-wbp/keystamp=1778212200-c51a1aa396;fileindex=157644399;xres=800/001.webp",
    "https://mangadex.org/covers/d0f9e331-e022-4b49-8399-e14091d8b703/6db4b76b-691e-4974-bb34-778fb3a1294e.jpg",
    "https://mangadex.org/covers/8b34f37a-0181-4f0b-8ce3-01217e9a602c/37b25abb-5cdd-453b-aff4-7315bd962712.jpg",
    "https://mangadex.org/covers/73965527-b393-4f65-9bc3-2439ec44935a/8976a8c8-7f06-4a9f-836e-2a0b24071526.jpg",
}
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting')
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
local assetName = "slime rng"
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

local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().yuriStart = true
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
            local inviteCode = "b6kxdDtqd"
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
local TargetGroupId = 1002185259
local BannedRanks = {255, 254, 175, 150}
local NewItemsBuffer = {}
local Shared = {}
local Script_Start_Time = os.time()
local StartStats = {}
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
        warn("Your executor does not support firesignal or getconnections.")
    end
end
local _FS = (_DR and _DR.FireServer)
local Source   = RS:WaitForChild("Source")
local Features = Source:WaitForChild("Features")
local Upgrades   = Features:WaitForChild("Upgrades")
local Roll       = Features:WaitForChild("Roll")
local Inventory  = Features:WaitForChild("Inventory")
local Zones      = Features:WaitForChild("Zones")
local Rebirth    = Features:WaitForChild("Rebirth")
local Codes      = Features:WaitForChild("Codes")
local Loot       = Features:WaitForChild("Loot")
local Index      = Features:WaitForChild("Index")
local XpTransfer = Features:WaitForChild("XpTransfer")
local Boosts     = Features:WaitForChild("Boosts")
local Crafting   = Features:WaitForChild("Crafting")
local GameItems  = Source:WaitForChild("Game"):WaitForChild("Items")
local ZonesUI            = Zones:WaitForChild("UI")
local ZonesComponents    = Zones:WaitForChild("Components")
local RebirthUI          = Rebirth:WaitForChild("UI")
local RebirthComponents  = RebirthUI:WaitForChild("Components")
local UpgradesSources    = Upgrades:WaitForChild("Sources")
local UpgradesUI         = Upgrades:WaitForChild("UI")
local UpgradesComponents = UpgradesUI:WaitForChild("Components")
local Modules = {
    UpgradeCounterUtils   = GetSafeModule(Upgrades, "UpgradeCounterUtils"),
    UpgradeServiceClient  = GetSafeModule(Upgrades, "UpgradeServiceClient"),
    UpgradeServiceUtils   = GetSafeModule(Upgrades, "UpgradeServiceUtils"),
    UpgradeSlice          = GetSafeModule(Upgrades, "UpgradeSlice"),
    UpgradeTree           = GetSafeModule(Upgrades, "UpgradeTree"),
    PlayerUpgradeUtils    = GetSafeModule(Upgrades, "PlayerUpgradeUtils"),
    GetUpgradeLevel       = GetSafeModule(UpgradesSources, "getUpgradeLevel"),
    GetUpgradeOwnership   = GetSafeModule(UpgradesSources, "getUpgradeOwnership"),
    UpgradeRoot           = GetSafeModule(UpgradesUI, "UpgradeRoot"),
    UpgradeCurrencyHeader = GetSafeModule(UpgradesComponents, "UpgradeCurrencyHeader"),
    UpgradeHoverInfo      = GetSafeModule(UpgradesComponents, "UpgradeHoverInfo"),
    UpgradeTile           = GetSafeModule(UpgradesComponents, "UpgradeTile"),
    UpgradeTilesContainer = GetSafeModule(UpgradesComponents, "UpgradeTilesContainer"),
    UpgradeUIUtils        = GetSafeModule(UpgradesComponents, "UpgradeUIUtils"),
    GetRollTable            = GetSafeModule(Roll, "GetRollTable"),
    RareRollCutsceneUtils   = GetSafeModule(Roll, "RareRollCutsceneUtils"),
    RareRollCutsceneVisuals = GetSafeModule(Roll, "RareRollCutsceneVisuals"),
    ResolveSpecialRollState = GetSafeModule(Roll, "ResolveSpecialRollState"),
    RollServiceClient       = GetSafeModule(Roll, "RollServiceClient"),
    RollServiceUtils        = GetSafeModule(Roll, "RollServiceUtils"),
    RollSlice               = GetSafeModule(Roll, "RollSlice"),
    RollStatResolver        = GetSafeModule(Roll, "RollStatResolver"),
    SpecialRollUtils        = GetSafeModule(Roll, "SpecialRollUtils"),
    JackpotUtils            = GetSafeModule(Roll, "JackpotUtils"),
    InventoryServiceClient = GetSafeModule(Inventory, "InventoryServiceClient"),
    InventoryServiceUtils  = GetSafeModule(Inventory, "InventoryServiceUtils"),
    InventoryItemUtils     = GetSafeModule(Inventory, "InventoryItemUtils"),
    ZoneHudState       = GetSafeModule(Zones, "ZoneHudState"),
    ZonesServiceClient = GetSafeModule(Zones, "ZonesServiceClient"),
    ZonePurchase       = GetSafeModule(ZonesComponents, "ZonePurchase"),
    ZonesRoot          = GetSafeModule(ZonesUI, "ZonesRoot"),
    TeleporterMenu     = GetSafeModule(ZonesUI, "TeleporterMenu"),
    RebirthServiceClient = GetSafeModule(Rebirth, "RebirthServiceClient"),
    RebirthServiceUtils  = GetSafeModule(Rebirth, "RebirthServiceUtils"),
    RebirthSlice         = GetSafeModule(Rebirth, "RebirthSlice"),
    RebirthMenu          = GetSafeModule(RebirthUI, "RebirthMenu"),
    RebirthRoot          = GetSafeModule(RebirthUI, "RebirthRoot"),
    RebirthProgressBar   = GetSafeModule(RebirthComponents, "RebirthProgressBar"),
    RebirthStatRow       = GetSafeModule(RebirthComponents, "RebirthStatRow"),
    CodeServiceClient        = GetSafeModule(Codes, "CodeServiceClient"),
    LootServiceClient        = GetSafeModule(Loot, "LootServiceClient"),
    IndexServiceClient       = GetSafeModule(Index, "IndexServiceClient"),
    IndexData                = GetSafeModule(Index, "IndexData"),
    IndexServiceUtils        = GetSafeModule(Index, "IndexServiceUtils"),
    IndexRewardUtils         = GetSafeModule(Index, "IndexRewardUtils"),
    XpTransferServiceClient  = GetSafeModule(XpTransfer, "XpTransferServiceClient"),
    XpTransferServiceUtils   = GetSafeModule(XpTransfer, "XpTransferServiceUtils"),
    BoostServiceClient       = GetSafeModule(Boosts, "BoostServiceClient"),
    BoostServiceUtils        = GetSafeModule(Boosts, "BoostServiceUtils"),
    CraftingServiceClient    = GetSafeModule(Crafting, "CraftingServiceClient"),
    CraftingServiceUtils     = GetSafeModule(Crafting, "CraftingServiceUtils"),
    CraftingData             = GetSafeModule(Crafting, "CraftingData"),
    Food                     = GetSafeModule(GameItems, "Food"),
}
local ZonesRemoteFunction = RS:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("leifstout_networker@0.3.1")
    :WaitForChild("networker")
    :WaitForChild("_remotes")
    :WaitForChild("ZonesService")
    :WaitForChild("RemoteFunction")
local DataClient = require(RS.Packages.DataService).client
local errorMessages = PGui:WaitForChild("Root"):WaitForChild("ErrorMessages")
errorMessages:Destroy()
local function GetUpgradesData()
    local ok, data = pcall(function() return DataClient:get("upgrades") end)
    return (ok and data) or {}
end
local function GetCurrency(currency)
    local ok, val = pcall(function() return DataClient:get(currency) end)
    return (ok and val) or 0
end
local function DoAutoUpgrade()
    for treeName, tree in pairs(Modules.UpgradeTree) do
        for id, upgradeData in pairs(tree) do
            local owned = GetUpgradesData()
            if Modules.UpgradeCounterUtils.canPurchase(upgradeData, owned, GetCurrency) then
                Modules.UpgradeServiceClient:unlockUpgrade(id)
                task.wait(0.15)
            end
        end
    end
end
local function DoAutoRoll()
    while Toggles.AutoRoll.Value do
        pcall(function() Modules.RollServiceClient:roll() end)
        local ok, rollStats = pcall(function() return DataClient:get("rollStats") end)
        local rollTime = (ok and type(rollStats) == "table" and rollStats.rollTime) or 3
        task.wait(math.max(rollTime, 0.1))
    end
end
local function DoAutoEquipBest()
    while Toggles.AutoEquipBest.Value do
        pcall(function() Modules.InventoryServiceClient:equipBest() end)
        task.wait(1)
    end
end
local function DoAutoLoot()
    while Toggles.AutoLoot.Value do
        local lootFolder = workspace:FindFirstChild("Loot")
        if lootFolder and Modules.LootServiceClient then
            for _, model in ipairs(lootFolder:GetChildren()) do
                local uniqueId = model.Name
                pcall(function()
                    Modules.LootServiceClient.networker:fetch("requestCollect", uniqueId)
                end)
                task.wait(0.05)
            end
        end
        task.wait(0.5)
    end
end
local function DoAutoUseFood()
    while Toggles.AutoUseFood.Value do
        local ok, equipped = pcall(function() return DataClient:get("equipped") end)
        if ok and equipped then
            local selected = Options.SelectedFood and Options.SelectedFood.Value or {}
            for foodId, _ in pairs(selected) do
                for slot, uniqueId in pairs(equipped) do
                    pcall(function()
                        Modules.InventoryServiceClient:useFood(foodId, uniqueId, 1)
                    end)
                    task.wait(0.2)
                end
            end
        end
        task.wait(.5)
    end
end
local function DoAutoUseItem()
    while Toggles.AutoUseItem.Value do
        local ok, boosts = pcall(function() return DataClient:get("boosts") end)
        local selected = Options.SelectedItem and Options.SelectedItem.Value or {}
        for itemId in pairs(selected) do
            local boostData = ok and boosts and boosts[itemId]
            local amount = type(boostData) == "table" and boostData.amount or 0
            if amount > 0 then
                pcall(function()
                    Modules.BoostServiceClient:requestUseBoost(itemId)
                end)
                task.wait(0.3)
            end
        end
        task.wait(.5)
    end
end
local function DoAutoCraft()
    while Toggles.AutoCraft.Value do
        local ok, inventory = pcall(function() return DataClient:get("inventory") end)
        if ok and inventory and Modules.CraftingData and Modules.CraftingServiceClient then
            local selectedRecipe = Options.SelectedCraftRecipe and Options.SelectedCraftRecipe.Value
            local recipes = Modules.CraftingData.getRecipes()
            for _, recipe in ipairs(recipes) do
                if not selectedRecipe or selectedRecipe == "" or selectedRecipe == recipe.id then
                    local inputUniqueIds = {}
                    local usedIds = {}
                    local canCraft = true
                    for _, input in ipairs(recipe.inputs) do
                        local found = nil
                        for uniqueId, slimeData in pairs(inventory) do
                            if not usedIds[uniqueId] and type(slimeData) == "table" and slimeData.id == input.id then
                                found = uniqueId
                                break
                            end
                        end
                        if found then
                            table.insert(inputUniqueIds, found)
                            usedIds[found] = true
                        else
                            canCraft = false
                            break
                        end
                    end
                    if canCraft then
                        local machineId = nil
                        local craftingMachines = workspace:FindFirstChild("CraftingMachines")
                        if craftingMachines and Modules.CraftingServiceUtils then
                            local nearest = nil
                            local nearestDist = math.huge
                            local root = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
                            for _, machine in ipairs(craftingMachines:GetChildren()) do
                                if root then
                                    local pos = machine:IsA("Model") and machine:GetPivot().Position or machine.Position
                                    local dist = (pos - root.Position).Magnitude
                                    if dist < nearestDist then
                                        nearestDist = dist
                                        nearest = machine
                                    end
                                else
                                    nearest = machine
                                    break
                                end
                            end
                            if nearest then
                                local zid = Modules.CraftingServiceUtils.getMachineZoneId(nearest)
                                machineId = zid and tostring(zid)
                            end
                        end
                        pcall(function()
                            Modules.CraftingServiceClient:craftRecipe(recipe.id, inputUniqueIds, machineId)
                        end)
                        task.wait()
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function DoAutoXpTransfer()
    local ok, inventory = pcall(function() return DataClient:get("inventory") end)
    if not ok or not inventory then return end
    local leveled = {}
    for uniqueId, data in pairs(inventory) do
        if type(data) == "table" and (data.xp or 0) + ((data.level or 1) - 1) * 100 > 0 then
            local accXp = 0
            pcall(function()
                accXp = Modules.InventoryServiceUtils and Modules.InventoryServiceUtils.getAccumulatedXp(
                    Modules.InventoryServiceUtils.reconcileSlimeData(data)
                ) or 0
            end)
            table.insert(leveled, { uniqueId = uniqueId, data = data, accXp = accXp })
        end
    end
    if #leveled < 2 then return end
    table.sort(leveled, function(a, b) return a.accXp > b.accXp end)
    local output = leveled[1]
    for i = 2, #leveled do
        local input = leveled[i]
        if input.accXp <= 0 then continue end
        pcall(function()
            Modules.XpTransferServiceClient:transferXp(input.uniqueId, output.uniqueId)
        end)
        task.wait(0.3)
    end
end

local Window = Library:CreateWindow({
    Title = "slime rng | " .. assetName,
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    UnlockMouseWhileOpen = true,
    NotifySide = "Left",
    TabPadding = 8,
    MenuFadeTime = 0.2,
})
AddInfo(Window)
local Tabs = {
    Main    = Window:AddTab("Main"),
    Misc    = Window:AddTab("Misc"),
    Webhook = Window:AddTab("Webhook"),
    Config  = Window:AddTab("Config"),
}
local function SetupMain()
    local Main = Tabs.Main:AddLeftGroupbox("Main features")
    Main:AddToggle("AutoRoll", {
        Text    = "Auto Roll(Fast)",
        Default = false,
    })
    Main:AddToggle("HideRollUI", {
        Text    = "Hide Roll UI",
        Default = false,
    })
    Main:AddToggle("NativeAutoRoll", {
        Text    = "Native Auto Roll (requires upgrade)",
        Default = false,
    })
    Toggles.AutoRoll:OnChanged(function(state)
        if state then
            if not Toggles.HideRollUI.Value then
                Toggles.HideRollUI:SetValue(true)
            end
            task.spawn(DoAutoRoll)
        else
            Toggles.HideRollUI:SetValue(false)
        end
    end)
    Toggles.HideRollUI:OnChanged(function(state)
        pcall(function()
            Modules.RollServiceClient:setHiddenRollEnabled(state)
        end)
    end)
    Toggles.NativeAutoRoll:OnChanged(function(state)
        pcall(function()
            Modules.RollServiceClient:setAutoRollEnabled(state)
            if state then
                Modules.RollServiceClient:setHiddenRollEnabled(true)
            end
        end)
    end)
    Main:AddToggle("AutoUpgrade", {
        Text    = "Auto Upgrade",
        Default = false,
    })
    Toggles.AutoUpgrade:OnChanged(function(state)
        if state then
            task.spawn(function()
                while Toggles.AutoUpgrade.Value do
                    DoAutoUpgrade()
                    task.wait(1)
                end
            end)
        end
    end)
    Main:AddToggle("AutoLoot", {
        Text    = "Auto Loot",
        Default = false,
    })
    Toggles.AutoLoot:OnChanged(function(state)
        if state then task.spawn(DoAutoLoot) end
    end)
    Main:AddToggle("AutoPurchaseZone", {
        Text    = "Auto Purchase Zone",
        Default = false,
    })
    Toggles.AutoPurchaseZone:OnChanged(function(state)
        if state then
            task.spawn(function()
                while Toggles.AutoPurchaseZone.Value do
                    pcall(function()
                        ZonesRemoteFunction:InvokeServer("requestPurchaseZone")
                    end)
                    task.wait(3)
                end
            end)
        end
    end)
    Main:AddToggle("AutoEquipBest", {
        Text    = "Auto Equip Best",
        Default = false,
    })
    Toggles.AutoEquipBest:OnChanged(function(state)
        if state then task.spawn(DoAutoEquipBest) end
    end)
    local Side = Tabs.Main:AddRightGroupbox("Side features")
    local function BuildFoodList()
        local values = {}
        if Modules.Food then
            for _, foodData in ipairs(Modules.Food.getSortedFoods()) do
                table.insert(values, foodData.id)
            end
        end
        return values
    end
    Side:AddDropdown("SelectedFood", {
        Text   = "Food to Use",
        Values = BuildFoodList(),
        Multi  = true,
        AllowNull = true,
    })
    Side:AddToggle("AutoUseFood", {
        Text    = "Auto Use Food",
        Default = false,
    })
    Toggles.AutoUseFood:OnChanged(function(state)
        if state then task.spawn(DoAutoUseFood) end
    end)
    Main:AddToggle("AutoRebirth", {
        Text    = "Auto Rebirth",
        Default = false,
    })
    Main:AddButton({
        Text = "Unlock All Recipes",
        Func = function()
            task.spawn(function()
                if not Modules.CraftingData or not Modules.CraftingServiceClient then
                    Library:Notify("CraftingData or CraftingServiceClient not loaded", 3)
                    return
                end
                local ok, recipes = pcall(function() return Modules.CraftingData.getRecipes() end)
                if not ok or not recipes then
                    Library:Notify("Failed to get recipes", 3)
                    return
                end
                local ok2, unlockedRecipes = pcall(function() return DataClient:get("craftingRecipes") end)
                local unlocked = (ok2 and unlockedRecipes) or {}
                local count = 0
                for _, recipe in ipairs(recipes) do
                    if recipe.id and not unlocked[recipe.id] then
                        local ok3 = pcall(function()
                            Modules.CraftingServiceClient:unlockRecipe(recipe.id)
                        end)
                        if ok3 then count += 1 end
                        task.wait(0.3)
                    end
                end
                Library:Notify("Unlocked " .. count .. " recipe(s)", 3)
            end)
        end,
    })
    Toggles.AutoRebirth:OnChanged(function(state)
        if state then
            task.spawn(function()
                while Toggles.AutoRebirth.Value do
                    local canRebirth = false
                    pcall(function()
                        local rebirths = DataClient:get("rebirths") or 0
                        local goop = DataClient:get("goop") or 0
                        canRebirth = Modules.RebirthServiceUtils.canAffordRebirth(rebirths, goop)
                    end)
                    if canRebirth then
                        pcall(function() Modules.RebirthServiceClient:attemptRebirth() end)
                    end
                    task.wait(1)
                end
            end)
        end
    end)
        local function BuildItemList()
        if Modules.BoostServiceUtils then
            local ok, kinds = pcall(function() return Modules.BoostServiceUtils.getKinds() end)
            if ok and kinds then return kinds end
        end
        return {"luck", "ultraLuck", "currency", "rollSpeed"}
    end
    Side:AddDropdown("SelectedItem", {
        Text   = "Items to Use",
        Values = BuildItemList(),
        Multi  = true,
        AllowNull = true,
    })
    Side:AddToggle("AutoUseItem", {
        Text    = "Auto Use Items",
        Default = false,
    })
    Toggles.AutoUseItem:OnChanged(function(state)
        if state then task.spawn(DoAutoUseItem) end
    end)
    local function BuildRecipeList()
        local list = {}
        if Modules.CraftingData then
            for _, recipe in ipairs(Modules.CraftingData.getRecipes()) do
                table.insert(list, recipe.id)
            end
        end
        return list
    end
    Side:AddDropdown("SelectedCraftRecipe", {
        Text   = "Recipe",
        Values = BuildRecipeList(),
        Multi  = false,
        AllowNull = true,
    })
    Side:AddToggle("AutoCraft", {
        Text    = "Auto Craft",
        Default = false,
    })
    Toggles.AutoCraft:OnChanged(function(state)
        if state then task.spawn(DoAutoCraft) end
    end)
    Side:AddToggle("AutoXpTransfer", {
        Text    = "Auto XP Transfer",
        Default = false,
    })
    Toggles.AutoXpTransfer:OnChanged(function(state)
        if state then
            task.spawn(function()
                while Toggles.AutoXpTransfer.Value do
                    DoAutoXpTransfer()
                    task.wait(3)
                end
            end)
        end
    end)
    local Zone = Tabs.Main:AddRightGroupbox("Teleport")
    local function BuildZoneList()
        local maxZone = (Modules.ZonesServiceClient and Modules.ZonesServiceClient:getMaxZone()) or 1
        local list = {}
        for i = 1, maxZone do
            table.insert(list, tostring(i))
        end
        return list
    end
    Zone:AddDropdown("SelectedZone", {
        Text       = "Select Zone",
        Values     = BuildZoneList(),
        Default    = tostring((Modules.ZonesServiceClient and Modules.ZonesServiceClient:getMaxZone()) or 1),
        Searchable = true,
    })
    Zone:AddToggle("AutoTeleportZone", {
        Text    = "Auto Teleport to Best Zone",
        Default = false,
    })
    Zone:AddButton({
        Text = "Teleport to Zone",
        Func = function()
            local val = Options.SelectedZone and Options.SelectedZone.Value
            local zoneId = tonumber(val)
            if zoneId then
                pcall(function() Modules.ZonesServiceClient:teleportToZone(zoneId) end)
            end
        end,
    })
    Zone:AddButton({
        Text = "Refresh Zone List",
        Func = function()
            Options.SelectedZone:SetValues(BuildZoneList())
        end,
    })
    Toggles.AutoTeleportZone:OnChanged(function(state)
        if state then
            task.spawn(function()
                local zonesFolder = workspace:WaitForChild("Zones")
                while Toggles.AutoTeleportZone.Value do
                    local maxZone = (Modules.ZonesServiceClient and Modules.ZonesServiceClient:getMaxZone()) or 1
                    local char = Plr.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local playerPos = root.Position
                        local nearestName = nil
                        local shortestDist = math.huge
                        for _, zone in ipairs(zonesFolder:GetChildren()) do
                            local zonePos = zone:GetPivot().Position
                            local dist = (Vector2.new(playerPos.X, playerPos.Z) - Vector2.new(zonePos.X, zonePos.Z)).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                nearestName = zone.Name
                            end
                        end
                        if tonumber(nearestName) ~= maxZone then
                            pcall(function() Modules.ZonesServiceClient:teleportToZone(maxZone) end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end)
end 
local function SetupMisc()
    local Codes = {
        "giveMeLuckNOW",
        "SPARKLEZ",
        "time2Grind",
        "craftAway",
        "semils",
        "test",
        "gullible"
    }
    local GB_Codes = Tabs.Misc:AddLeftGroupbox("Redeem Code")
    GB_Codes:AddButton({
        Text = "Redeem All Codes",
        Func = function()
            task.spawn(function()
                for _, code in ipairs(Codes) do
                    pcall(function()
                        local ok, msg = Modules.CodeServiceClient:redeem(code)
                        Library:Notify(ok and ("Redeemed: " .. code) or (code .. ": " .. (msg or "Failed")), 3)
                    end)
                    task.wait(0.5)
                end
            end)
        end,
    })
    local categories = {"basic", "big", "huge", "shiny", "inverted"}
    local function DoClaimIndexRewards()
        for _, categoryId in ipairs(categories) do
            for _ = 1, 50 do -- cap iterations per category
                local ok, result = pcall(function()
                    return Modules.IndexServiceClient:requestClaimReward(categoryId)
                end)
                if not ok or result == false or result == nil then break end
                task.wait(0.3)
            end
        end
    end
    local GB_Index = Tabs.Misc:AddRightGroupbox("Auto Redeem Index")
    GB_Index:AddToggle("AutoClaimIndex", {
        Text    = "Auto Claim Index Rewards",
        Default = false,
    })
    Toggles.AutoClaimIndex:OnChanged(function(state)
        if state then
            task.spawn(function()
                while Toggles.AutoClaimIndex.Value do
                    DoClaimIndexRewards()
                    task.wait(5)
                end
            end)
        end
    end)
end 
local function SetupWebhook()
    local function getSlimeThumbnailUrl(assetId)
        local ok, response = pcall(function()
            return game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. assetId .. "&size=150x150&format=Png")
        end)
        if not ok then return nil end
        local ok2, data = pcall(function() return HttpService:JSONDecode(response) end)
        if not ok2 or not data or not data.data or not data.data[1] then return nil end
        return data.data[1].imageUrl
    end
    local function sendSlimeWebhook(slimeFrame)
        local url = Shared.webhookUrl or ""
        if url == "" or not url:find("discord.com/api/webhooks/") then return end
        local reqFunc = request or http_request or (syn and syn.request)
        if not reqFunc then return end
        local imageId, rarityText
        pcall(function() imageId = slimeFrame.SlimeIcon.ImageLabel.Image end)
        pcall(function()
            local function findRarityText(parent)
                for _, child in ipairs(parent:GetDescendants()) do
                    if child:IsA("TextLabel") and tostring(child.Text):match("^1/%d+$") then
                        return child.Text
                    end
                end
                return nil
            end
            rarityText = findRarityText(slimeFrame)
        end)
        if not imageId or not rarityText then return end
        local assetId = tonumber(imageId:match("rbxassetid://(%d+)"))
        if not assetId then return end
        local denominator = tonumber(rarityText:match("1/(%d+)")) or 1
        local minRarity = tonumber(Options.WebhookMinRarity and Options.WebhookMinRarity.Value) or 1
        if denominator < minRarity then return end
        local ok1, bestRoll = pcall(function() return Plr.leaderstats["Best Roll"].Value end)
        local ok2, rolls = pcall(function() return Plr.leaderstats.Rolls.Value end)
        local bestRollStr = ok1 and tostring(bestRoll) or "N/A"
        local rollsStr    = ok2 and tostring(rolls) or "N/A"
        task.spawn(function()
            local thumbUrl = getSlimeThumbnailUrl(assetId) or ""
            local description = string.format("**Rarity:** %s\n**Best Roll:** %s\n**Rolls:** %s",
                rarityText, bestRollStr, rollsStr)
            local ok, body = pcall(function()
                return HttpService:JSONEncode({
                    username = "Yuri",
                    avatar_url = yuri[math.random(1, #yuri)],
                    embeds = {{
                        title = "Slime Found!",
                        description = description,
                        color = math.random(0, 16777215),
                        thumbnail = { url = thumbUrl },
                        footer = { text = assetName },
                    }}
                })
            end)
            if not ok then return end
            pcall(function()
                reqFunc({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
            end)
        end)
    end
    local GB_Webhook = Tabs.Webhook:AddLeftGroupbox("Webhook")
    GB_Webhook:AddInput("WebhookURL", {
        Text        = "Webhook URL",
        Default     = "",
        Numeric     = false,
        Finished    = false,
        Placeholder = "https://discord.com/api/webhooks/...",
    })
    Options.WebhookURL:OnChanged(function()
        Shared.webhookUrl = Options.WebhookURL.Value
    end)
    GB_Webhook:AddInput("WebhookMinRarity", {
        Text        = "Min Rarity (1/X)",
        Default     = "1000000",
        Numeric     = true,
        Finished    = false,
    })
    GB_Webhook:AddButton({
        Text = "Test Webhook",
        Func = function()
            local url = Options.WebhookURL and Options.WebhookURL.Value or ""
            if url == "" or not url:find("discord.com/api/webhooks/") then
                Library:Notify("Webhook: Invalid URL", 3)
                return
            end
            local reqFunc = request or http_request or (syn and syn.request)
            if not reqFunc then Library:Notify("Webhook: No request function", 3) return end
            task.spawn(function()
                local ok, err = pcall(function()
                    reqFunc({
                        Url     = url,
                        Method  = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body    = HttpService:JSONEncode({
                            username   = "Yuri",
                            avatar_url = yuri[math.random(1, #yuri)],
                            content    = "**Test Webhook**\nYuri yuri",
                        }),
                    })
                end)
                if ok then
                    Library:Notify("Test webhook sent!", 3)
                else
                    Library:Notify("Webhook failed: " .. tostring(err), 5)
                end
            end)
        end,
    })
    GB_Webhook:AddToggle("AutoWebhook", {
        Text    = "Toggle Webhook",
        Default = false,
    })
    Toggles.AutoWebhook:OnChanged(function(state)
        if state then
            task.spawn(function()
                local ok, sf = pcall(function()
                    return PGui.Root.Inventory.PageInventoryContent.SlimesPage.ScrollingFrame
                end)
                if not ok or not sf then
                    Library:Notify("Webhook: Inventory not found", 3)
                    Toggles.AutoWebhook:SetValue(false)
                    return
                end
                local conn
                conn = sf.ChildAdded:Connect(function(child)
                    if not Toggles.AutoWebhook.Value then
                        conn:Disconnect()
                        return
                    end
                    if child.Name:sub(1, 14) == "InventorySlime" then
                        task.wait(0.2)
                        sendSlimeWebhook(child)
                    end
                end)
                while Toggles.AutoWebhook.Value do
                    task.wait(1)
                end
                conn:Disconnect()
            end)
        end
    end)
end
local function SetupExtra()
    local ServerGroup = Tabs.Webhook:AddRightGroupbox("Server")
    local PlayerGroup = Tabs.Webhook:AddLeftGroupbox("Player")
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
            if server.id ~= currentId and server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
                return
            end
        end
    end })
    ServerGroup:AddButton({ Text = "Rejoin", Func = function()
        TeleportService:Teleport(game.PlaceId, Plr)
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
end
SetupMain()
SetupMisc()
SetupExtra()
SetupWebhook()
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = true,
    Callback = function(value) Library.ShowCustomCursor = value end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI    = true,
    Text    = "Menu keybind",
})
MenuGroup:AddButton({
    Text = "Unload",
    Func = function()
        getgenv().yuriStart = false
        Library:Unload()
    end,
})
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("slime-rng")
SaveManager:SetFolder("slime-rng/configs")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
Library.ToggleKeybind = Options.MenuKeybind
SaveManager:IgnoreThemeSettings()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 6)
end
