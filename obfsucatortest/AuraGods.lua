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
local Packages = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 15)
local BridgeNet2 = GetSafeModule(Packages, "BridgeNet2")
local SharedFolder = RS:FindFirstChild("Shared") or RS:WaitForChild("Shared", 15)
local AuraData = SharedFolder and SharedFolder:FindFirstChild("Data") and SharedFolder:FindFirstChild("Data"):FindFirstChild("Gameplay") and GetSafeModule(SharedFolder:FindFirstChild("Data"):FindFirstChild("Gameplay"), "AuraData")
local ShopData = SharedFolder and SharedFolder:FindFirstChild("Data") and SharedFolder:FindFirstChild("Data"):FindFirstChild("Gameplay") and GetSafeModule(SharedFolder:FindFirstChild("Data"):FindFirstChild("Gameplay"), "ShopData")
local PotionData = SharedFolder and SharedFolder:FindFirstChild("Data") and SharedFolder:FindFirstChild("Data"):FindFirstChild("Gameplay") and GetSafeModule(SharedFolder:FindFirstChild("Data"):FindFirstChild("Gameplay"), "PotionData")
local UpgradeTreeConfig = SharedFolder and SharedFolder:FindFirstChild("Config") and GetSafeModule(SharedFolder:FindFirstChild("Config"), "UpgradeTreeConfig")
local ClientFolder = RS:FindFirstChild("Client") or RS:WaitForChild("Client", 15)
local Controllers = ClientFolder and ClientFolder:FindFirstChild("Controllers")
local DataController = Controllers and GetSafeModule(Controllers, "DataController")
if not BridgeNet2 then
    pcall(function()
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "ClientBridge") and rawget(v, "ServerBridge") then
                BridgeNet2 = v
                break
            end
        end
    end)
end
local _bridgeCache = {}
local function GetBridge(name)
    if _bridgeCache[name] ~= nil then return _bridgeCache[name] end
    local bridge = nil
    if BridgeNet2 then
        local ok, res = pcall(function() return BridgeNet2.ClientBridge(name) end)
        if ok then bridge = res end
    end
    _bridgeCache[name] = bridge
    return bridge
end
local function FireBridge(name, ...)
    local b = GetBridge(name)
    if not b or type(b.Fire) ~= "function" then return false end
    local args = {...}
    return pcall(function() b:Fire(unpack(args)) end)
end
local function GetData()
    if DataController and DataController.Get then
        local a = DataController.Get()
        return a
    end
    return nil
end
local function GetSession()
    if DataController and DataController.Get then
        local ok, session = pcall(function()
            local _, s = DataController.Get()
            return s
        end)
        if ok then return session end
    end
    return nil
end
local function GetPower()
    local d = GetData()
    return (d and d.Wallet and tonumber(d.Wallet.Power)) or 0
end
local function GetRebirths()
    local d = GetData()
    return (d and d.Stats and tonumber(d.Stats.Rebirth)) or 0
end
local function GetAscension()
    local d = GetData()
    return (d and d.Stats and tonumber(d.Stats.Ascension)) or 0
end
local function GetEquippedAura()
    local d = GetData()
    return (d and tonumber(d.Equipped)) or nil
end
local function GetOwnedAuras()
    local d = GetData()
    if d and d.Inventory and d.Inventory.Auras then
        return d.Inventory.Auras
    end
    return {}
end
local function GetBestAuraId()
    local owned = GetOwnedAuras()
    local bestId, bestPower = nil, -1
    if AuraData and AuraData.Auras then
        for auraId, _ in owned do
            local info = AuraData.Auras[auraId]
            if info then
                local power = tonumber(info.Power) or 0
                if power > bestPower then
                    bestPower = power
                    bestId = auraId
                end
            end
        end
    end
    return bestId
end
local function GetAllAuraIds()
    local list = {}
    if AuraData and AuraData.Auras then
        for auraId, _ in pairs(AuraData.Auras) do
            table.insert(list, auraId)
        end
        table.sort(list)
    end
    return list
end
local function ParseThreshold(s)
    if not s or type(s) ~= "string" then return nil end
    s = s:gsub("%s+", "")
    if s == "" then return nil end
    local n = tonumber(s)
    if n then return n end
    local base, exp = s:match("^([%d%.]+)e([%d]+)$")
    if base and exp then
        local b = tonumber(base)
        local e = tonumber(exp)
        if b and e then return b * (10 ^ e) end
    end
    return nil
end
local function Func_AutoEquip()
    while Toggles.AutoEquip.Value do
        FireBridge("EquipBestAura")
        task.wait(5)
    end
end
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
                task.wait(0.2)
            end
        end
    end
    fireproximityprompt(target)
end
local _visualAuraIdByLabel = {}
local _buyAuraIdByLabel = {}
local _usePotionIdByLabel = {}
local function SetViz()
    local label = Options.VisualList and Options.VisualList.Value or ""
    local auraId = _visualAuraIdByLabel[label]
    if auraId then
        Plr:SetAttribute("AuraId", auraId)
    else
        Library:Notify("Select an aura first.", 3)
    end
end
local function GetRebirthGain()
    local d = GetData()
    if not d then return 0 end
    local rebirths = tonumber(d.Stats and d.Stats.Rebirth) or 0
    local power = tonumber(d.Wallet and d.Wallet.Power) or 0
    local BASE_COST = 50000
    local COST_MULTIPLIER = 1.04
    local count = 0
    while math.floor(BASE_COST * COST_MULTIPLIER ^ rebirths) <= power do
        power = power - math.floor(BASE_COST * COST_MULTIPLIER ^ rebirths)
        rebirths = rebirths + 1
        count = count + 1
    end
    return count
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        local threshold = tonumber(Options.RebirthThreshold and Options.RebirthThreshold.Value) or 0
        local gain = GetRebirthGain()
        if threshold <= 0 or gain >= threshold then
            FireBridge("MultiRebirth")
        end
        task.wait(2)
    end
end
local function Func_AutoAscend()
    while Toggles.AutoAscend.Value do
        FireBridge("Ascend")
        task.wait(5)
    end
end
local function HasPendingIndexReward(data, auraId)
    local index = data and data.Index
    if not index then return false end
    local indexedAuras = index.Auras
    local entry = indexedAuras and indexedAuras[tostring(auraId)]
    if not entry then return false end
    local hasCount = false
    for _, count in entry do
        if (tonumber(count) or 0) > 0 then hasCount = true; break end
    end
    if not hasCount then return false end
    local collected = index.CollectedBonus
    if collected and collected[tostring(auraId)] == true then return false end
    return true
end
local function Func_AutoIndex()
    while Toggles.AutoIndex.Value do
        local data = GetData()
        if not data then
            task.wait(5)
            continue
        end
        local index = data.Index
        if not index then
            task.wait(5)
            continue
        end
        if not index.Auras then
            task.wait(5)
            continue
        end
        for auraIdStr, _ in index.Auras do
            if not Toggles.AutoIndex.Value then break end
            local auraId = tonumber(auraIdStr)
            if not auraId then continue end
            local entry = index.Auras[auraIdStr]
            local hasCount = false
            for _, count in entry do
                if (tonumber(count) or 0) > 0 then hasCount = true; break end
            end
            if not hasCount then
                continue
            end
            local collected = index.CollectedBonus
            if collected and collected[auraIdStr] == true then
                continue
            end
            FireBridge("CollectIndexAura", auraId)
            task.wait(0.3)
        end
        task.wait(1)
    end
end
local function CanBuy(auraId)
    local auraInfo = AuraData and AuraData.Auras and AuraData.Auras[auraId]
    if not auraInfo then
        notyuri("[CanBuy] no auraInfo for auraId=" .. tostring(auraId))
        return false
    end
    local cost = tonumber(auraInfo.Cost) or 0
    local power = GetPower()
    if cost > 0 and power < cost then
        notyuri("[CanBuy] auraId=" .. tostring(auraId) .. " can't afford: cost=" .. tostring(cost) .. " power=" .. tostring(power))
        return false
    end
    local tier = tonumber(auraInfo.Tier)
    if not tier or tier < 1 or tier > 4 then
        notyuri("[CanBuy] auraId=" .. tostring(auraId) .. " skipping non-F2P tier=" .. tostring(auraInfo.Tier))
        return false
    end
    local shopId = tostring(tier)
    local familyId = tostring(auraInfo.Family)
    local data = GetData()
    if not data then
        notyuri("[CanBuy] auraId=" .. tostring(auraId) .. " GetData() returned nil")
        return false
    end
    local shopUnlockKey = tier == 2 and "unlocks_shop_II" or tier == 3 and "unlocks_shop_III" or tier == 4 and "unlocks_shop_IV" or nil
    if shopUnlockKey then
        local owned = data.UpgradeTree and data.UpgradeTree.Owned and data.UpgradeTree.Owned.Shops
        if not (owned and owned[shopUnlockKey] == true) then
            notyuri("[CanBuy] auraId=" .. tostring(auraId) .. " shop tier=" .. shopId .. " is locked (missing " .. shopUnlockKey .. ")")
            return false
        end
    end
    local shopData = data.Shops and data.Shops[shopId]
    if not shopData then
        notyuri("[CanBuy] auraId=" .. tostring(auraId) .. " no shop data for shopId=" .. tostring(shopId))
        return false
    end
    local itemData = shopData.Items and shopData.Items[familyId]
    if not itemData then
        notyuri("[CanBuy] auraId=" .. tostring(auraId) .. " familyId=" .. tostring(familyId) .. " not in shop " .. tostring(shopId) .. " this rotation")
        return false
    end
    local remaining = tonumber(itemData.Remaining) or 0
    notyuri("[CanBuy] auraId=" .. tostring(auraId) .. " shopId=" .. tostring(shopId) .. " familyId=" .. tostring(familyId) .. " remaining=" .. tostring(remaining))
    if remaining <= 0 then return false end
    return true
end
local function Func_AutoBuy()
    while Toggles.AutoBuy.Value do
        if Options.BuyList then
            local buyAll = Options.BuyList.Value["Any"] == true
            if buyAll then
                for label, auraId in pairs(_buyAuraIdByLabel) do
                    if not Toggles.AutoBuy.Value then break end
                    if CanBuy(auraId) then
                        FireBridge("BuyAura", { auraId, false })
                        task.wait()
                    end
                end
            else
                for label, active in pairs(Options.BuyList.Value) do
                    if not Toggles.AutoBuy.Value then break end
                    if active then
                        local auraId = _buyAuraIdByLabel[label]
                        if auraId and CanBuy(auraId) then
                            FireBridge("BuyAura", { auraId, false })
                            task.wait()
                        end
                    end
                end
            end
        end
        task.wait(3)
    end
end
local function Func_AutoMerge()
    while Toggles.AutoMerge.Value do
        FireBridge("Fusion", { Action = "MergeAll" })
        task.wait(3)
    end
end
local function BuildUpgradeList()
    local list = {}
    if not (UpgradeTreeConfig and UpgradeTreeConfig.Trees) then
        return list
    end
    for treeId, treeData in pairs(UpgradeTreeConfig.Trees) do
        local entries = (type(treeData) == "table" and treeData.List) and treeData.List or treeData
        if type(entries) == "table" then
            for _, upgrade in ipairs(entries) do
                if upgrade.Type ~= "Nav" and upgrade.Type ~= "Back" and upgrade.Id and not upgrade.DevProductKey then
                    table.insert(list, {
                        treeId   = treeId,
                        id       = upgrade.Id,
                        cost     = upgrade.Cost or 0,
                        parent   = upgrade.Parent,
                        ascReq   = (upgrade.Requirements and upgrade.Requirements.Ascension) or 0,
                    })
                end
            end
        end
    end
    table.sort(list, function(a, b) return a.cost < b.cost end)
    return list
end
local function GetOwnedTree(data, treeId)
    return data and data.UpgradeTree and data.UpgradeTree.Owned and data.UpgradeTree.Owned[treeId]
end
local function IsUpgradeOwned(data, treeId, upgradeId)
    local tree = GetOwnedTree(data, treeId)
    return tree and tree[upgradeId] == true
end
local function IsUpgradeLocked(data, treeId, upgrade)
    if not upgrade.parent then return false end
    return not IsUpgradeOwned(data, treeId, upgrade.parent)
end
local function Func_AutoUpgrade()
    local upgradeList = BuildUpgradeList()
    if #upgradeList == 0 then
        return
    end
    while Toggles.AutoUpgrade.Value do
        local data = GetData()
        if not data then
            task.wait(3)
            continue
        end
        local power = GetPower()
        local ascension = GetAscension()
        for _, upgrade in ipairs(upgradeList) do
            if not Toggles.AutoUpgrade.Value then break end
            if IsUpgradeOwned(data, upgrade.treeId, upgrade.id) then
                continue
            end
            if ascension < upgrade.ascReq then
                continue
            end
            if IsUpgradeLocked(data, upgrade.treeId, upgrade) then
                continue
            end
            if power < upgrade.cost then
                continue
            end
            FireBridge("PurchaseUpgrade", { TreeId = upgrade.treeId, UpgradeId = upgrade.id })
            task.wait(0.1)
            data = GetData() or data
            power = GetPower()
        end
        task.wait(.1)
    end
end

local CollectActive = false
local function Func_AutoCollectPotion()
    if not Support.Proximity then
        Library:Notify("fireproximityprompt not supported.", 5)
        return
    end
    while Toggles.AutoCollectPotion.Value do
        local SpawnedPotions = workspace:FindFirstChild("SpawnedPotions")
        if SpawnedPotions and #SpawnedPotions:GetChildren() > 0 then
            CollectActive = true
            for _, potion in ipairs(SpawnedPotions:GetChildren()) do
                if not Toggles.AutoCollectPotion.Value then break end
                local pp = nil
                for _, desc in ipairs(potion:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") then
                        pp = desc
                        break
                    end
                end
                if pp then
                    FirePP(pp, true)
                    task.wait(0.1)
                end
            end
            CollectActive = false
        end
        task.wait(1)
    end
    CollectActive = false
end
local function Func_TPTraining()
    while Toggles.TPTraining.Value do
        if CollectActive then
            task.wait(0.1)
            continue
        end
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local trainPart = workspace:FindFirstChild("TrainingArea") and workspace.TrainingArea:FindFirstChild("Part")
        if hrp and trainPart then
            local dest = trainPart.CFrame * CFrame.new(0, 3, 0)
            local dist = (hrp.Position - trainPart.Position).Magnitude
            if dist > 50 then
                hrp.CFrame = dest
                notyuri("[TPTraining] Teleported to TrainingArea")
            end
        end
        task.wait(1)
    end
end
local function Func_AutoUsePotion()
    while Toggles.AutoUsePotion.Value do
        if Options.UsePotionList then
            local data = GetData()
            local inv = data and data.Inventory and data.Inventory.Potions
            local useAny = Options.UsePotionList.Value["Any"] == true
            for label, active in pairs(Options.UsePotionList.Value) do
                if not Toggles.AutoUsePotion.Value then break end
                if not active then continue end
                if label == "Any" then continue end
                local potionId = _usePotionIdByLabel[label]
                if not potionId then continue end
                if useAny or active then
                    local owned = inv and (inv[tostring(potionId)] or inv[potionId])
                    local count = math.max(tonumber(owned) or 0, 0)
                    if count > 0 then
                        notyuri("[AutoUsePotion] Using potionId=" .. tostring(potionId) .. " label=" .. label)
                        FireBridge("UsePotion", potionId)
                        task.wait(0.3)
                    end
                end
            end
        end
        task.wait(5)
    end
end
local function Func_AutoPotionMachine()
    while Toggles.AutoPotionMachine.Value do
        for machineId = 1, 4 do
            if not Toggles.AutoPotionMachine.Value then break end
            FireBridge("BuyPotionMachine", { BuyAll = true, Machine = machineId })
            notyuri("[AutoPotionMachine] Fired BuyAll for machine=" .. machineId)
            task.wait(0.5)
        end
        task.wait(5)
    end
end
local function Func_AutoMergePotion()
    while Toggles.AutoMergePotion.Value do
        FireBridge("Fusion", { Action = "MergePotionAll" })
        notyuri("[AutoMergePotion] Fired MergePotionAll")
        task.wait(3)
    end
end
local function Func_AutoRoll()
    while Toggles.AutoRoll.Value do
        FireBridge("Roll")
        task.wait(0.1)
    end
end
local function Func_AutoCollectOffline()
    while Toggles.AutoCollectOffline.Value do
        FireBridge("CollectOfflinePower")
        task.wait(60)
    end
end
local function DoEquipBest()
    FireBridge("EquipBestAura")
    Library:Notify("Equipped best aura.", 3)
end
local function DoEquipAura()
    local label = Options.VisualList and Options.VisualList.Value or ""
    local auraId = _visualAuraIdByLabel[label]
    if auraId then
        FireBridge("EquipAura", tonumber(auraId))
        Library:Notify("Equipped: " .. tostring(label), 3)
    else
        Library:Notify("Select an aura first.", 3)
    end
end
local function DoUnequipAura()
    FireBridge("EquipAura", nil)
    Library:Notify("Unequipped aura.", 3)
end
local function DoRebirth()
    FireBridge("MultiRebirth")
    Library:Notify("Rebirth fired.", 3)
end
local function DoAscend()
    FireBridge("Ascend")
    Library:Notify("Ascend fired.", 3)
end
local function DoMergeAll()
    FireBridge("Fusion", { Action = "MergeAll" })
    Library:Notify("Merge all fired.", 3)
end
local function DoRoll()
    FireBridge("Roll")
    Library:Notify("Roll fired.", 3)
end
local function DoCollectOffline()
    FireBridge("CollectOfflinePower")
    Library:Notify("Collected offline power.", 3)
end
local function DoClaimAllIndex()
    local owned = GetOwnedAuras()
    local count = 0
    for auraId, _ in owned do
        FireBridge("CollectIndexAura", auraId)
        count = count + 1
        task.wait(0.2)
    end
    Library:Notify("Claimed index rewards for " .. count .. " auras.", 4)
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
            notyuri("Error in ["..name.."]: "..tostring(err))
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
        T2 = TB.Main.Left.Autofarm:AddTab("Aura"),
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
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("RebirthThreshold", {
    Text = "Rebirth Threshold",
    Default = "0",
    Numeric = true,
    Finished = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoAscend", { Text = "Auto Ascend", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMerge", { Text = "Auto Merge", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoIndex", { Text = "Auto Index", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy", { Text = "Auto Buy Aura", Default = false })
TB_Tabs.Autofarm.T2:AddButton({ Text = "Set Aura", Func = SetViz })
local UsePotionLabel = {}
if PotionData and PotionData.Potions and PotionData.ClassesNames and PotionData.TiersNames then
    local sorted = {}
    for potionId, info in pairs(PotionData.Potions) do
        local className = PotionData.ClassesNames[info.Class] or tostring(info.Class)
        local tierName = PotionData.TiersNames[info.Tier] or tostring(info.Tier)
        local label = className .. " " .. tierName
        table.insert(sorted, { id = potionId, label = label })
    end
    table.sort(sorted, function(a, b) return a.label < b.label end)
    for _, entry in ipairs(sorted) do
        table.insert(UsePotionLabel, entry.label)
        _usePotionIdByLabel[entry.label] = entry.id
    end
    table.insert(UsePotionLabel, 1, "Any")
end
local VizLabel = {}
local BuyLabel = {}
if AuraData and AuraData.Auras and AuraData.FamiliesNames then
    local sorted = {}
    for auraId, info in pairs(AuraData.Auras) do
        local familyName = AuraData.FamiliesNames[info.Family] or tostring(info.Family)
        local label = familyName .. " " .. tostring(info.Tier)
        table.insert(sorted, { id = auraId, label = label })
    end
    table.sort(sorted, function(a, b) return a.label < b.label end)
    for _, entry in ipairs(sorted) do
        table.insert(VizLabel, entry.label)
        _visualAuraIdByLabel[entry.label] = entry.id
        table.insert(BuyLabel, entry.label)
        _buyAuraIdByLabel[entry.label] = entry.id
    end
    table.insert(BuyLabel, 1, "Any")
end
TB_Tabs.Autofarm2.T1:AddDropdown("VisualList", {
    Text = "Visual",
    Values = VizLabel,
    Default = VizLabel[1] or "",
})
TB_Tabs.Autofarm2.T1:AddDropdown("BuyList", {
    Text = "Buy List",
    Values = BuyLabel,
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectPotion", { Text = "Auto Collect Potion", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("TPTraining", { Text = "TP Training", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUsePotion", { Text = "Auto Use Potion", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPotionMachine", { Text = "Auto Potion Machine", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMergePotion", { Text = "Auto Merge Potion", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("UsePotionList", {
    Text = " Use Potion List",
    Values = UsePotionLabel,
    Default = {},
    Multi = true,
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
Toggles.AutoRoll:OnChanged(function(v) Thread("AutoRoll", SafeLoop("AutoRoll", Func_AutoRoll), v) end)
Toggles.AutoRebirth:OnChanged(function(v) Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v) end)
Toggles.AutoAscend:OnChanged(function(v) Thread("AutoAscend", SafeLoop("AutoAscend", Func_AutoAscend), v) end)
Toggles.AutoMerge:OnChanged(function(v) Thread("AutoMerge", SafeLoop("AutoMerge", Func_AutoMerge), v) end)
Toggles.AutoUpgrade:OnChanged(function(v) Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v) end)
Toggles.AutoEquip:OnChanged(function(v) Thread("AutoEquip", SafeLoop("AutoEquip", Func_AutoEquip), v) end)
Toggles.AutoIndex:OnChanged(function(v) Thread("AutoIndex", SafeLoop("AutoIndex", Func_AutoIndex), v) end)
Toggles.AutoBuy:OnChanged(function(v) Thread("AutoBuy", SafeLoop("AutoBuy", Func_AutoBuy), v) end)
Toggles.AutoCollectPotion:OnChanged(function(v) Thread("AutoCollectPotion", SafeLoop("AutoCollectPotion", Func_AutoCollectPotion), v) end)
Toggles.TPTraining:OnChanged(function(v) Thread("TPTraining", SafeLoop("TPTraining", Func_TPTraining), v) end)
Toggles.AutoUsePotion:OnChanged(function(v) Thread("AutoUsePotion", SafeLoop("AutoUsePotion", Func_AutoUsePotion), v) end)
Toggles.AutoPotionMachine:OnChanged(function(v) Thread("AutoPotionMachine", SafeLoop("AutoPotionMachine", Func_AutoPotionMachine), v) end)
Toggles.AutoMergePotion:OnChanged(function(v) Thread("AutoMergePotion", SafeLoop("AutoMergePotion", Func_AutoMergePotion), v) end)
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
SaveManager:SetFolder("Yuri/AuraGods")
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
