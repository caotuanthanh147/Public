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
local Flags = {}
local A = {
    PendingPrestige = false
}
local Tables = {
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
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
local EventsFolder = RS:FindFirstChild("Events") or RS:WaitForChild("Events", 10)
local function E(name)
    return EventsFolder:FindFirstChild(name) or EventsFolder:WaitForChild(name, 10)
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
local Remotes = {
    RollDice         = E("RollDice"),
    RollTraits       = E("RollTraits"),
    RollTraits2       = E("RollTraits2"),
    SetTraitAutoRoll = E("SetTraitAutoRoll"),
    BuyUpgrade       = E("BuyUpgrade"),
    Rebirth          = E("Rebirth"),
    BuyTreeNode      = E("BuyTreeNode"),
    BuyWorldUnlock   = E("BuyWorldUnlock"),
    TeleportToWorld  = E("TeleportToWorld"),
    EquipTitle       = E("EquipTitle"),
    EquipDice        = E("EquipDice"),
    EquipRelic       = E("EquipRelic"),
    EquipAura        = E("EquipAura"),
    BuyDice          = E("BuyDice"),
    RollAura         = E("RollAura"),
    RollRune         = E("RollRune"),
    RollRune2        = E("RollRune2"),
    RollRuneStarter  = E("RollRuneStarter"),
    RollRune3        = E("RollRune3"),
    RollRune4        = E("RollRune4"),
    Mine             = E("Mine"),
    Dig              = E("Dig"),
    SpawnPile        = E("SpawnPile"),
    Craft            = E("Craft"),
    PlinkoDrop       = E("PlinkoDrop"),
    CollectIce       = E("CollectIce"),
    CollectIron      = E("CollectIron"),
    ClaimAutoRoll    = E("ClaimAutoRoll"),
    RedeemCode       = E("RedeemCode"),
    UpdateSetting    = E("UpdateSetting"),
    AfkPing          = E("AfkPing"),
}
local Modules = {
    DataService = GetSafeModule(RS:FindFirstChild("Packages") or RS:WaitForChild("Packages"), "DataService"),
}
local DSClient = nil
local function GetDS()
    if DSClient then return DSClient end
    local ds = Modules.DataService
    if not ds then
        notyuri("[GetDS] Modules.DataService is nil - DataService module failed to load")
        return nil
    end
    if not ds.client then
        notyuri("[GetDS] DataService has no .client field")
        return nil
    end
    DSClient = ds.client
    return ds.client
end
local function GetData(path)
    local ds = GetDS()
    if not ds then return nil end
    local ok, val = pcall(function() return ds:get(path) end)
    if ok then return val end
    return nil
end
local function GetCash()
    return tonumber(GetData({ "cash" })) or 0
end
local function GetRebirths()
    return tonumber(GetData({ "rebirths" })) or 0
end
local function GetPrestige()
    return tonumber(GetData({ "prestige" })) or 0
end
local function GetCurrency(name)
    return tonumber(GetData({ name })) or 0
end
local function Func_AutoRollDice()
    while Toggles.AutoRollDice.Value do
        if Remotes.RollDice then
            pcall(function() Remotes.RollDice:FireServer() end)
        end
        task.wait()
    end
end
local function Func_AutoRollTraits()
    while Toggles.AutoRollTraits.Value do
        if Remotes.RollTraits2 then
            pcall(function() Remotes.RollTraits2:FireServer() end)
        end
        if Remotes.RollTraits then
            pcall(function() Remotes.RollTraits:FireServer() end)
        end
        task.wait()
    end
end
local function Func_AutoRollAura()
    while Toggles.AutoRollAura.Value do
        local minEnergy = tonumber(Options.AutoRollAuraMinEnergy and Options.AutoRollAuraMinEnergy.Value) or 0
        local currentEnergy = tonumber(GetData({ "energy" })) or 0
        if currentEnergy >= minEnergy then
            if Remotes.RollAura then
                pcall(function() Remotes.RollAura:FireServer() end)
            end
        end
        task.wait()
    end
end
local function Func_AutoCollectIron()
    while Toggles.AutoCollectIron.Value do
        if Remotes.CollectIron then
            pcall(function() Remotes.CollectIron:FireServer() end)
        end
        task.wait(1)
    end
end
local function Func_AutoCollectIce()
    while Toggles.AutoCollectIce.Value do
        local iceFolderFound = false
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name:sub(1, 9) == "IceCubes_" then
                iceFolderFound = true
                for _, cube in ipairs(child:GetChildren()) do
                    local iceOuter = cube:FindFirstChild("IceOuter")
                    if iceOuter then
                        FireTI(iceOuter)
                    end
                end
                break
            end
        end
        if not iceFolderFound then
            notyuri("[AutoCollectIce] IceCubes_ folder not found in workspace")
        end
        task.wait(.175)
    end
end
local function Func_AutoDig()
    while Toggles.AutoDig.Value do
        if Remotes.SpawnPile then
            pcall(function() Remotes.SpawnPile:FireServer() end)
            task.wait(0.5)
        end
        if Remotes.Dig then
            pcall(function() Remotes.Dig:FireServer(1) end)
        end
        task.wait(0.5)
    end
end
local function Func_AutoEquipTrait()
    local RSShared = RS:WaitForChild("Shared", 10)
    if not RSShared then
        notyuri("[AutoEquipTrait] RS.Shared not found")
        return
    end
    local TraitDataModule = RSShared:FindFirstChild("TraitData")
    if not TraitDataModule then
        notyuri("[AutoEquipTrait] TraitData module not found")
        return
    end
    local ok, TraitData = pcall(require, TraitDataModule)
    if not ok or not TraitData then
        notyuri("[AutoEquipTrait] Failed to require TraitData:", tostring(TraitData))
        return
    end
    while Toggles.AutoEquipTrait.Value do
        local ownedTitles = GetData({ "titles" })
        if type(ownedTitles) == "table" then
            local bestName = nil
            local bestDenom = 0
            for name, _ in pairs(ownedTitles) do
                local data = TraitData.get(name)
                if data and data.denom and data.denom > bestDenom then
                    bestDenom = data.denom
                    bestName = name
                end
            end
            if bestName then
                local current = GetData({ "equippedTitle" }) or ""
                if current ~= bestName then
                    notyuri("[AutoEquipTrait] Equipping:", bestName, "(1/" .. tostring(bestDenom) .. ")")
                    pcall(function() Remotes.EquipTitle:FireServer(bestName) end)
                end
            end
        end
        task.wait(5)
    end
end
local function Func_AutoCraftRelic()
    local RSShared = RS:WaitForChild("Shared", 10)
    if not RSShared then
        notyuri("[AutoCraftRelic] RS.Shared not found")
        return
    end
    local RelicDataModule = RSShared:FindFirstChild("RelicData")
    if not RelicDataModule then
        notyuri("[AutoCraftRelic] RelicData module not found")
        return
    end
    local ok, RelicData = pcall(require, RelicDataModule)
    if not ok or not RelicData then
        notyuri("[AutoCraftRelic] Failed to require RelicData:", tostring(RelicData))
        return
    end
    while Toggles.AutoCraftRelic.Value do
        local ores = GetData({ "ores" }) or {}
        for _, relic in ipairs(RelicData.relics) do
            local owned = GetData({ "relics", relic.name })
            if not owned or owned == 0 then
                local canCraft = true
                for oreName, required in pairs(relic.recipe) do
                    if (ores[oreName] or 0) < required then
                        canCraft = false
                        break
                    end
                end
                if canCraft then
                    notyuri("[AutoCraftRelic] Crafting:", relic.name)
                    pcall(function() Remotes.Craft:FireServer(relic.name) end)
                    task.wait(0.5)
                    ores = GetData({ "ores" }) or {}
                end
            end
        end
        task.wait(2)
    end
end
local function Func_AutoEquipRelic()
    local RSShared = RS:WaitForChild("Shared", 10)
    if not RSShared then
        notyuri("[AutoEquipRelic] RS.Shared not found")
        return
    end
    local RelicDataModule = RSShared:FindFirstChild("RelicData")
    if not RelicDataModule then
        notyuri("[AutoEquipRelic] RelicData module not found")
        return
    end
    local ok, RelicData = pcall(require, RelicDataModule)
    if not ok or not RelicData then
        notyuri("[AutoEquipRelic] Failed to require RelicData:", tostring(RelicData))
        return
    end
    while Toggles.AutoEquipRelic.Value do
        local owned = GetData({ "relics" }) or {}
        local equipped = GetData({ "equippedRelic" }) or ""
        local bestName = nil
        local bestTier = -1
        for _, relic in ipairs(RelicData.relics) do
            if (owned[relic.name] or 0) > 0 and relic.tier > bestTier then
                bestTier = relic.tier
                bestName = relic.name
            end
        end
        if bestName and bestName ~= equipped then
            notyuri("[AutoEquipRelic] Equipping:", bestName, "Tier:", bestTier)
            pcall(function() Remotes.EquipRelic:FireServer(bestName) end)
        end
        task.wait(5)
    end
end
local function Func_AutoEquipAura()
    local RSShared = RS:WaitForChild("Shared", 10)
    if not RSShared then
        notyuri("[AutoEquipAura] RS.Shared not found")
        return
    end
    local AuraDataModule = RSShared:FindFirstChild("AuraData")
    if not AuraDataModule then
        notyuri("[AutoEquipAura] AuraData module not found")
        return
    end
    local ok, AuraData = pcall(require, AuraDataModule)
    if not ok or not AuraData then
        notyuri("[AutoEquipAura] Failed to require AuraData:", tostring(AuraData))
        return
    end
    while Toggles.AutoEquipAura.Value do
        local owned = GetData({ "auras" }) or {}
        local equipped = GetData({ "equippedAura" }) or ""
        local bestId = nil
        local bestDenom = math.huge
        local bestTier = -1
        for _, aura in pairs(AuraData.Auras) do
            if owned[aura.id] == true then
                if aura.denom < bestDenom or (aura.denom == bestDenom and aura.tier > bestTier) then
                    bestDenom = aura.denom
                    bestTier = aura.tier
                    bestId = aura.id
                end
            end
        end
        if bestId and bestId ~= equipped then
            notyuri("[AutoEquipAura] Equipping:", bestId, "Denom:", bestDenom, "Tier:", bestTier)
            pcall(function() Remotes.EquipAura:FireServer(bestId) end)
        end
        task.wait(5)
    end
end
local function Func_AutoClaimAutoRoll()
    while Toggles.AutoClaimAutoRoll.Value do
        if Remotes.ClaimAutoRoll then
            pcall(function() Remotes.ClaimAutoRoll:InvokeServer() end)
        end
        task.wait(60)
    end
end
local function Func_AutoRebirth()
    local RSShared = RS:WaitForChild("Shared", 10)
    if not RSShared then
        notyuri("[AutoRebirth] RS.Shared not found")
        return
    end
    local UpgradeDataModule = RSShared:FindFirstChild("UpgradeData")
    if not UpgradeDataModule then
        notyuri("[AutoRebirth] UpgradeData not found")
        return
    end
    local ok, UpgradeData = pcall(require, UpgradeDataModule)
    if not ok or not UpgradeData then
        notyuri("[AutoRebirth] require failed:", tostring(UpgradeData))
        return
    end
    while Toggles.AutoRebirth.Value do
        local rebirths = tonumber(GetData({ "rebirths" })) or 0
        local prestige = GetPrestige()
        local cost = UpgradeData.rebirthCost(rebirths)
        if prestige >= cost then
            pcall(function() Remotes.Rebirth:FireServer() end)
            task.wait(1)
        else
            task.wait(5)
        end
    end
end
local function Func_AutoPrestige()
    local RSShared = RS:WaitForChild("Shared", 10)
    if not RSShared then
        notyuri("[AutoPrestige] RS.Shared not found")
        return
    end
    local UpgradeDataModule = RSShared:FindFirstChild("UpgradeData")
    if not UpgradeDataModule then
        notyuri("[AutoPrestige] UpgradeData not found")
        return
    end
    local ok, UpgradeData = pcall(require, UpgradeDataModule)
    if not ok or not UpgradeData then
        notyuri("[AutoPrestige] require failed:", tostring(UpgradeData))
        return
    end
    while Toggles.AutoPrestige.Value do
        local rebirths = tonumber(GetData({ "rebirths" })) or 0
        local cash = GetCash()
        local threshold = UpgradeData.prestigeThreshold(rebirths)
        if cash >= threshold then
            local prestigeMultiLevel = tonumber(GetData({ "upgrades", UpgradeData.upgradeKey("UpgradeBoard2", 2) })) or 0
            local fishPrestigeLevel  = tonumber(GetData({ "upgrades", UpgradeData.upgradeKey("UpgradeBoard4", 4) })) or 0
            local icePrestigeLevel   = tonumber(GetData({ "upgrades", UpgradeData.upgradeKey("UpgradeBoard5", 4) })) or 0
            local goldPrestigeLevel  = tonumber(GetData({ "upgrades", UpgradeData.upgradeKey("UpgradeBoard7", 4) })) or 0
            local coinPrestigeLevel  = tonumber(GetData({ "upgrades", UpgradeData.upgradeKey("UpgradeBoard10", 6) })) or 0
            local ironPrestigeLevel  = tonumber(GetData({ "upgrades", UpgradeData.upgradeKey("UpgradeBoard9", 6) })) or 0
            local gain = UpgradeData.prestigeGain({
                cash               = cash,
                threshold          = threshold,
                prestigeMultiLevel = prestigeMultiLevel,
                fishPrestigeLevel  = fishPrestigeLevel,
                icePrestigeLevel   = icePrestigeLevel,
                goldPrestigeLevel  = goldPrestigeLevel,
                coinPrestigeLevel  = coinPrestigeLevel,
                ironPrestigeLevel  = ironPrestigeLevel,
                treePrestigeNodes  = 0,
                productMult        = 1,
                titleMult          = 1,
                runeMult           = 1,
                relicMult          = 1,
                diceMult           = 1,
                auraMult           = 1,
            })
            local minGain = (Options.AutoPrestigeMinGain and tonumber(Options.AutoPrestigeMinGain.Value)) or 1
            if gain >= minGain then
                notyuri("[AutoPrestige] gain=" .. tostring(gain) .. " minGain=" .. tostring(minGain) .. " cash=" .. tostring(cash) .. " threshold=" .. tostring(threshold))
                if Toggles.AutoUpgrade.Value then
                    A.PendingPrestige = true
                else
                    pcall(function() Remotes.BuyUpgrade:FireServer("UpgradeBoard2", 3, false) end)
                end
                task.wait(0.5)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoUpgrade()
    local Shared = RS:FindFirstChild("Shared")
    if not Shared then
        notyuri("[AutoUpgrade] RS.Shared folder not found")
        return
    end
    local UpgradeDataModule = Shared:FindFirstChild("UpgradeData")
    if not UpgradeDataModule then
        notyuri("[AutoUpgrade] UpgradeData ModuleScript not found inside RS.Shared")
        return
    end
    local ok, UpgradeData = pcall(require, UpgradeDataModule)
    if not ok or not UpgradeData then
        notyuri("[AutoUpgrade] require(UpgradeData) failed:", UpgradeData)
        return
    end
    if not UpgradeData.boards then
        notyuri("[AutoUpgrade] UpgradeData.boards is nil")
        return
    end
    while Toggles.AutoUpgrade.Value do
        if A.PendingPrestige then
            A.PendingPrestige = false
            pcall(function() Remotes.BuyUpgrade:FireServer("UpgradeBoard2", 3, false) end)
            task.wait(0.1)
        end
        for boardName, slots in pairs(UpgradeData.boards) do
            for slotIdx, slotData in ipairs(slots) do
                if slotData.isPrestige then continue end
                local key = UpgradeData.upgradeKey(boardName, slotIdx)
                local currentLevel = tonumber(GetData({ "upgrades", key })) or 0
                if currentLevel < slotData.maxLevel then
                    local nextCost = UpgradeData.costAt(slotData, currentLevel + 1)
                    if nextCost then
                        local balance = GetCurrency(slotData.currency)
                        if balance >= nextCost then
                            local fireOk, fireErr = pcall(function()
                                Remotes.BuyUpgrade:FireServer(boardName, slotIdx, true)
                            end)
                            if not fireOk then
                                notyuri("[AutoUpgrade] FireServer failed:", fireErr)
                            end
                            task.wait(.175)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoTreeNode()
    local Shared = RS:FindFirstChild("Shared")
    if not Shared then
        notyuri("[AutoTreeNode] RS.Shared folder not found")
        return
    end
    local TreeDataModule = Shared:FindFirstChild("TreeData")
    if not TreeDataModule then
        notyuri("[AutoTreeNode] TreeData ModuleScript not found inside RS.Shared")
        return
    end
    local ok, TreeData = pcall(require, TreeDataModule)
    if not ok or not TreeData then
        notyuri("[AutoTreeNode] require(TreeData) failed:", TreeData)
        return
    end
    if not TreeData.nodes then
        notyuri("[AutoTreeNode] TreeData.nodes is nil")
        return
    end
    while Toggles.AutoTreeNode.Value do
        local treeNodes = GetData({ "treeNodes" }) or {}
        local cash = GetCash()
        for _, node in ipairs(TreeData.nodes) do
            if treeNodes[node.id] ~= true then
                local available = true
                for _, prereqId in ipairs(node.prereqs) do
                    if treeNodes[prereqId] ~= true then
                        available = false
                        break
                    end
                end
                if available and cash >= node.cost then
                    local fireOk, fireErr = pcall(function()
                        Remotes.BuyTreeNode:FireServer(node.id)
                    end)
                    if not fireOk then
                        notyuri("[AutoTreeNode] FireServer failed:", fireErr)
                    end
                    task.wait(0.1)
                    treeNodes = GetData({ "treeNodes" }) or {}
                    cash = GetCash()
                end
            end
        end
        task.wait()
    end
end
local function ToggleDiceAutoRoll()
    if not Remotes.UpdateSetting then return end
    local current = GetData({ "settings", "diceAutoRoll" })
    pcall(function() Remotes.UpdateSetting:FireServer("diceAutoRoll", not current) end)
    Library:Notify("Toggled dice auto-roll: " .. tostring(not current), 3)
end
local function ToggleTraitAutoRoll()
    if not Remotes.SetTraitAutoRoll then return end
    local current = GetData({ "settings", "traitAutoRollStation" }) or false
    pcall(function() Remotes.SetTraitAutoRoll:FireServer("1", not current) end)
    Library:Notify("Toggled trait auto-roll: " .. tostring(not current), 3)
end
local LuckCapKeys = {
    ["Trait Luck"] = "traitLuckCap",
    ["Ore Luck"]   = "oreLuckCap",
    ["Rune Luck"]  = "runeLuckCap",
}
local function SetSelectedLuck(value)
    if not Remotes.UpdateSetting then return end
    local selected = Options.LuckSelect and Options.LuckSelect.Value or {}
    for name, active in pairs(selected) do
        if active then
            local key = LuckCapKeys[name]
            if key then
                pcall(function() Remotes.UpdateSetting:FireServer(key, value) end)
            end
        end
    end
end
local function RedeemCodeBtn()
    local code = Options.RedeemCodeInput and Options.RedeemCodeInput.Value or ""
    if code == "" then
        Library:Notify("Enter a code first.", 3)
        return
    end
    if Remotes.RedeemCode then
        pcall(function() Remotes.RedeemCode:FireServer(code) end)
        Library:Notify("Redeeming code: " .. code, 3)
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
    local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
TB_Tabs.Autofarm.T1:AddToggle("AutoRollDice", { Text = "Auto Roll Dice", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTreeNode", { Text = "Auto Tree Node", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRollTraits", { Text = "Auto Roll Traits", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquipTrait", { Text = "Auto Equip Best Trait", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPrestige", { Text = "Auto Prestige", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCraftRelic", { Text = "Auto Craft Relic", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquipRelic", { Text = "Auto Equip Best Relic", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRollAura", { Text = "Auto Roll Aura", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquipAura", { Text = "Auto Equip Best Aura", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("RuneSelect", {
    Text = "Rune List",
    Values = { "Starter Rune", "Ice Rune", "Gold Rune", "Iron Rune", "Bone Rune" },
    Default = "Starter Rune",
})
TB_Tabs.Autofarm2.T1:AddButton({ Text = "Teleport to Rune", Func = function()
    local runeMap = {
        ["Starter Rune"] = "RuneStater",
        ["Ice Rune"]     = "Rune",
        ["Gold Rune"]    = "Rune2",
        ["Iron Rune"]    = "Rune3",
        ["Bone Rune"]    = "Rune4",
    }
    local selected = Options.RuneSelect.Value
    local modelName = runeMap[selected]
    local iceSystem = workspace:FindFirstChild("IceSystem")
    if not iceSystem then
        notyuri("[TeleportToRune] IceSystem not found in workspace")
        return
    end
    local runeModel = iceSystem:FindFirstChild(modelName)
    if not runeModel then
        notyuri("[TeleportToRune] Rune model not found:", modelName)
        return
    end
    local touchPart = runeModel:FindFirstChild("TouchPart")
    if not touchPart then
        notyuri("[TeleportToRune] TouchPart not found in:", modelName)
        return
    end
    local root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not root then
        notyuri("[TeleportToRune] HumanoidRootPart not found")
        return
    end
    root.CFrame = touchPart.CFrame + Vector3.new(0, 3, 0)
end })
TB_Tabs.Autofarm.T1:AddToggle("AutoDig", { Text = "Auto Dig", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("AutoPrestigeMinGain", { Text = ">= Prestige Gain", Default = "1e0", ClearTextOnFocus = false, })
TB_Tabs.Autofarm2.T1:AddInput("AutoRollAuraMinEnergy", { Text = "Aura Min Energy", Default = "0", ClearTextOnFocus = false, })
TB_Tabs.Autofarm2.T1:AddDropdown("LuckSelect", {
    Text = "Luck List",
    Values = { "All", "Trait Luck", "Ore Luck", "Rune Luck" },
    Default = { "All" },
    Multi = true,
})
Options.LuckSelect:OnChanged(function()
    local selected = Options.LuckSelect.Value
    if selected["All"] then
        for name, _ in pairs(LuckCapKeys) do
            Options.LuckSelect:SetValue(name, true)
        end
        Options.LuckSelect:SetValue("All", false)
    end
end)
TB_Tabs.Autofarm2.T1:AddButton({ Text = "Set Luck MAX", Func = function() SetSelectedLuck(0) end })
TB_Tabs.Autofarm2.T1:AddButton({ Text = "Set Luck MIN", Func = function() SetSelectedLuck(1) end })
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
Toggles.AutoRollDice:OnChanged(function(v)
    Thread("AutoRollDice", SafeLoop("AutoRollDice", Func_AutoRollDice), v)
end)
Toggles.AutoRollTraits:OnChanged(function(v)
    Thread("AutoRollTraits", SafeLoop("AutoRollTraits", Func_AutoRollTraits), v)
end)
Toggles.AutoRollAura:OnChanged(function(v)
    Thread("AutoRollAura", SafeLoop("AutoRollAura", Func_AutoRollAura), v)
end)
Toggles.AutoCraftRelic:OnChanged(function(v)
    Thread("AutoCraftRelic", SafeLoop("AutoCraftRelic", Func_AutoCraftRelic), v)
end)
Toggles.AutoEquipRelic:OnChanged(function(v)
    Thread("AutoEquipRelic", SafeLoop("AutoEquipRelic", Func_AutoEquipRelic), v)
end)
Toggles.AutoEquipAura:OnChanged(function(v)
    Thread("AutoEquipAura", SafeLoop("AutoEquipAura", Func_AutoEquipAura), v)
end)
Toggles.AutoDig:OnChanged(function(v)
    Thread("AutoDig", SafeLoop("AutoDig", Func_AutoDig), v)
end)
Toggles.AutoRebirth:OnChanged(function(v)
    Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v)
end)
Toggles.AutoPrestige:OnChanged(function(v)
    Thread("AutoPrestige", SafeLoop("AutoPrestige", Func_AutoPrestige), v)
end)
Toggles.AutoUpgrade:OnChanged(function(v)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
end)
Toggles.AutoTreeNode:OnChanged(function(v)
    Thread("AutoTreeNode", SafeLoop("AutoTreeNode", Func_AutoTreeNode), v)
end)
Toggles.AutoEquipTrait:OnChanged(function(v)
    Thread("AutoEquipTrait", SafeLoop("AutoEquipTrait", Func_AutoEquipTrait), v)
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
SaveManager:SetFolder("Yuri/LuckIncremental")
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