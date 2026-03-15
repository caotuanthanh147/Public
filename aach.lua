local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer    = Players.LocalPlayer
local Remotes        = ReplicatedStorage:WaitForChild("Remotes")
local Items          = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Items"))
local PlayerInventory = Remotes:WaitForChild("PlayerInventory")
local InvestStats     = Remotes:WaitForChild("InvestStats")
local GetStats        = Remotes:WaitForChild("GetStats")
local Encounters      = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Encounters"))
local GetSceneOptions = Remotes:WaitForChild("GetSceneOptions")
local SceneEvent      = Remotes:WaitForChild("SceneEvent")
local VotingEvent     = Remotes:WaitForChild("VotingEvent")
local PLAYER_CLASS  = "Priest"
local PLAYER_WEAPON = "Tome"
local ENCOUNTER_PREFERENCES = {
    ["Druid"]  = { "Say hello", "Teach me", "Swear" },
    ["Mystic"] = { "Break", "Take some" },
}
local STAT_UPGRADE_CONFIG = {
    STR = { enabled = false,  priority = 0 },
    DEX = { enabled = false, priority = 0 },
    CON = { enabled = true,  priority = 3 },
    INT = { enabled = false, priority = 0 },
    FTH = { enabled = true, priority = 1 },
    CHA = { enabled = false, priority = 0 },
    LCK = { enabled = false, priority = 0 },
}
local EQUIPMENT_STAT_WEIGHTS = {
    FlatSTR = 0,
    FlatDEX = 0,
    FlatCON = 1.0,
    FlatINT = 1.0,
    FlatFTH = 3.0,
    FlatCHA = 3.0,
    FlatLCK = 0,
}
local UPGRADE_THRESHOLD   = 3
local SHOP_GOLD_THRESHOLD = 80
local currentStats     = {}
local currentInventory = {}
local currentEquipment = {}
local shopInventory    = {}
GetStats.OnClientEvent:Connect(function(p485, p486)
    if p486 == "Self" then currentStats = p485 end
end)
PlayerInventory.OnClientEvent:Connect(function(p489, p490)
    if p489 == "Inventory" then
        currentInventory = p490.Player.Inventory
        currentEquipment = p490.Player.Equipment
    elseif p489 == "Shop" then
        shopInventory = p490 or {}
    end
end)
local function autoInvestStats()
    local points = LocalPlayer:GetAttribute("StatPoints") or 0
    if points <= 0 then return end
    local enabled = {}
    local maxPriority = 0
    for stat, cfg in pairs(STAT_UPGRADE_CONFIG) do
        if cfg.enabled and cfg.priority > 0 then
            table.insert(enabled, { stat = stat, priority = cfg.priority })
            if cfg.priority > maxPriority then maxPriority = cfg.priority end
        end
    end
    if #enabled == 0 then return end
    for _, entry in ipairs(enabled) do
        entry.weight = (maxPriority + 1) - entry.priority
    end
    local invest = {}
    while points > 0 do
        for _, entry in ipairs(enabled) do
            for _ = 1, entry.weight do
                if points <= 0 then break end
                invest[entry.stat] = (invest[entry.stat] or 0) + 1
                points = points - 1
            end
        end
    end
    InvestStats:FireServer(invest)
end
local function scoreItemStats(itemData)
    if not itemData.Stats then return 0 end
    local score = 0
    for stat, value in pairs(itemData.Stats) do
        score = score + (value * (EQUIPMENT_STAT_WEIGHTS[stat] or 0))
    end
    return score
end
local function getEquippedScore(slot)
    local equipped = currentEquipment[slot]
    if not equipped or equipped == "None" then return 0 end
    local name = type(equipped) == "table" and equipped.Name or equipped
    local data = Items[name]
    return data and scoreItemStats(data) or 0
end
local function getItemCategory(itemData)
    local slot = itemData.Slot
    if not slot then return "Misc" end
    if slot == "Helmet"     then return "Armor" end
    if slot == "Chestpiece" then return "Armor" end
    if slot == "Leggings"   then return "Armor" end
    if slot == "Boots"      then return "Armor" end
    if slot == "Charm"      then return "Accessory" end
    if slot == "Consumable" then return "Consumable" end
    if slot == "Weapon" then
        return (itemData.WeaponType == PLAYER_WEAPON) and "MyWeapon" or "OtherWeapon"
    end
    return "Misc"
end
local function canCraftFromInventory(itemName)
    local data = Items[itemName]
    if not data or not data.Recipe then return false end
    for ingredient, required in pairs(data.Recipe) do
        local have = 0
        for _, invItem in pairs(currentInventory) do
            if invItem.Key == ingredient and not invItem.Unique then
                have = have + (invItem.Amount or 1)
            end
        end
        if have < required then return false end
    end
    return true
end
local function autoEquip()
    local bestPerSlot = {}
    for invKey, invItem in pairs(currentInventory) do
        local itemData = Items[invItem.Name]
        if itemData then
            local slot     = itemData.Slot
            local category = getItemCategory(itemData)
            if slot and slot ~= "Consumable" and category ~= "OtherWeapon" then
                local score        = scoreItemStats(itemData)
                local currentScore = getEquippedScore(slot)
                if score - currentScore >= UPGRADE_THRESHOLD then
                    if not bestPerSlot[slot] or score > bestPerSlot[slot].score then
                        bestPerSlot[slot] = { invKey = invKey, name = invItem.Name, score = score }
                    end
                end
            end
        end
    end
    for _, best in pairs(bestPerSlot) do
        PlayerInventory:FireServer("EquipItem", best.invKey)
        task.wait(0.2)
    end
end
local function autoCraft()
    local armorCandidates    = {}
    local fallbackCandidates = {}
    for itemName, itemData in pairs(Items) do
        local category = getItemCategory(itemData)
        if category == "OtherWeapon" then continue end
        local slot = itemData.Slot
        if not slot then
            if itemData.Recipe and canCraftFromInventory(itemName) and itemName ~= "ItemTemplate" then
                table.insert(fallbackCandidates, { name = itemName, category = "Misc" })
            end
            continue
        end
        if slot == "Consumable" then
            if itemData.Recipe and canCraftFromInventory(itemName) then
                table.insert(fallbackCandidates, { name = itemName, category = "Consumable" })
            end
            continue
        end
        if itemData.Recipe and canCraftFromInventory(itemName) then
            local score        = scoreItemStats(itemData)
            local currentScore = getEquippedScore(slot)
            if score - currentScore >= UPGRADE_THRESHOLD then
                if not armorCandidates[slot] or score > armorCandidates[slot].score then
                    armorCandidates[slot] = { name = itemName, score = score }
                end
            end
        end
    end
    local craftedAny = false
    for _, best in pairs(armorCandidates) do
        PlayerInventory:FireServer("CraftItem", best.name)
        craftedAny = true
        task.wait(0.3)
    end
    if not craftedAny then
        for _, item in ipairs(fallbackCandidates) do
            PlayerInventory:FireServer("CraftItem", item.name)
            task.wait(0.3)
        end
    end
    if craftedAny or #fallbackCandidates > 0 then
        task.wait(0.3)
        autoEquip()
    end
end
local function isMaterialWanted(materialName)
    for _, itemData in pairs(Items) do
        if itemData.Recipe and itemData.Recipe[materialName] then
            if scoreItemStats(itemData) > 0 then return true end
            local effects = itemData.Effects or {}
            if effects["Heal"] then return true end
        end
    end
    return false
end
local function shouldSellItem(invKey, invItem)
    local itemData = Items[invItem.Name]
    if not itemData then return false end
    local slot     = itemData.Slot
    local category = getItemCategory(itemData)
    if invItem.Name:lower():match("scroll") then return true end
    if slot == "Weapon" and category == "OtherWeapon" then return true end
    if slot and slot ~= "Consumable" and category ~= "OtherWeapon" then
        local score        = scoreItemStats(itemData)
        local currentScore = getEquippedScore(slot)
        if score >= currentScore - UPGRADE_THRESHOLD then return false end
        return true
    end
    if not slot then
        return not isMaterialWanted(invItem.Name)
    end
    return false
end
local function autoShop()
    local buyQueue = {}
    for itemName, cost in pairs(shopInventory) do
        local itemData = Items[itemName]
        if not itemData then continue end
        local slot     = itemData.Slot
        local category = getItemCategory(itemData)
        local score    = scoreItemStats(itemData)
        local priority = 99
        if category == "MyWeapon" then
            local currentScore = getEquippedScore("Weapon")
            if score > currentScore + UPGRADE_THRESHOLD then priority = 1 end
        elseif category == "Accessory" then
            local currentScore = getEquippedScore("Charm")
            if score > currentScore + UPGRADE_THRESHOLD then priority = 2 end
        elseif slot == "Consumable" then
            local effects = itemData.Effects or {}
            if effects["Heal"] then priority = 3 end
        elseif not slot then
            if isMaterialWanted(itemName) then priority = 4 end
        end
        if priority < 99 then
            table.insert(buyQueue, { name = itemName, cost = cost, priority = priority, score = score })
        end
    end
    table.sort(buyQueue, function(a, b)
        if a.priority ~= b.priority then return a.priority < b.priority end
        return a.score > b.score
    end)
    for invKey, invItem in pairs(currentInventory) do
        if shouldSellItem(invKey, invItem) then
            PlayerInventory:FireServer("SellItem", invKey)
            task.wait(0.2)
        end
    end
    task.wait(.1)
    for _, item in ipairs(buyQueue) do
        local gold = LocalPlayer:GetAttribute("Gold") or 0
        if gold >= item.cost then
            PlayerInventory:FireServer("BuyItem", item.name)
            task.wait(0.3)
        end
    end
end
SceneEvent.OnClientEvent:Connect(function(p31, p32, p33)
    if p31 ~= "OpenSceneUI" then return end
    task.spawn(function()
        task.wait(0.3)
        local sceneData = Encounters[p32] and Encounters[p32][p33]
        if not sceneData then return end
        if not sceneData.Options then return end
        local options = GetSceneOptions:InvokeServer(sceneData)
        if not options then return end
        local keys = {}
        for k, _ in pairs(options) do
            table.insert(keys, k)
        end
        if #keys == 0 then return end
        if #keys == 1 then
            local pick = keys[1]
            if sceneData.Client then
                VotingEvent:FireServer("SceneClient", pick)
            else
                VotingEvent:FireServer("Scene", pick)
            end
            return
        end
        local prefs = nil
        for prefKey, prefOptions in pairs(ENCOUNTER_PREFERENCES) do
            if p32:lower():find(prefKey:lower(), 1, true) then
                print("[Scene] Matched pref key:", prefKey, "for scene:", p32)
                prefs = prefOptions
                break
            end
        end
        if prefs then
            for _, preferred in ipairs(prefs) do
            print("[Scene] Raw option keys for", p32, "step:", p33)
                for _, k in ipairs(keys) do
                print("  option key:", k)
                    if k:lower():find(preferred:lower(), 1, true) then
                        print("[Scene] Voting preferred option:", k, "matched:", preferred)
                        if sceneData.Client then
                            VotingEvent:FireServer("SceneClient", k)
                        else
                            VotingEvent:FireServer("Scene", k)
                        end
                        return
                    end
                end
            end
            print("[Scene] No pref option matched, falling back to random")
        else
            print("[Scene] No prefs found for scene:", p32)
        end
        table.sort(keys)
        local pick = keys[math.random(1, math.min(3, #keys))]
        if sceneData.Client then
            VotingEvent:FireServer("SceneClient", pick)
        else
            VotingEvent:FireServer("Scene", pick)
        end
    end)
end)
SceneEvent.OnClientEvent:Connect(function(p31, p32)
    if p31 ~= "OpenEncounterUI" then return end
    task.spawn(function()
        task.wait(0.3)
        local gold = LocalPlayer:GetAttribute("Gold") or 0
        if gold >= SHOP_GOLD_THRESHOLD then
            for optName, optData in pairs(p32) do
                if optName ~= "ShortRest" and optName ~= "Scavenge" then
                    local nameMatch = optName:lower():match("shop")
                    local descMatch = type(optData) == "table" and optData.Description and
                        optData.Description:lower():match("shop")
                    if nameMatch or descMatch then
                        VotingEvent:FireServer("Encounter", optName)
                        return
                    end
                end
            end
        end
        for optName, _ in pairs(p32) do
            for prefName, _ in pairs(ENCOUNTER_PREFERENCES) do
                if optName:lower():find(prefName:lower()) then
                    print("[Encounter] Voting preferred encounter:", optName, "matched pref:", prefName)
                    VotingEvent:FireServer("Encounter", optName)
                    return
                end
            end
        end
        if p32["Scavenge"] then
            VotingEvent:FireServer("Encounter", "Scavenge")
            return
        end
        local options = {}
        for optName, optData in pairs(p32) do
            if optName ~= "ShortRest" then
                table.insert(options, { name = optName, danger = optData.Danger or 0 })
            end
        end
        if #options == 0 then return end
        if #options == 1 then
            VotingEvent:FireServer("Encounter", options[1].name)
            return
        end
        table.sort(options, function(a, b) return a.danger < b.danger end)
        VotingEvent:FireServer("Encounter", options[1].name)
    end)
end)
local RestFrame  = LocalPlayer.PlayerGui.RestGUI.RestFrame
local ShopButton = RestFrame.Frame1.Shop
task.spawn(function()
    local lastVisible = false
    while true do
        local visible = RestFrame.Visible
        if visible and not lastVisible then
            lastVisible = true
            task.spawn(function()
                if ShopButton.Visible then
                    autoShop()
                    task.wait(0.3)
                end
                autoInvestStats()
                task.wait(0.1)
                autoEquip()
                task.wait(0.1)
                autoCraft()
                task.wait(0.2)
                VotingEvent:FireServer("Rest")
            end)
        elseif not visible then
            lastVisible = false
        end
        task.wait(0.1)
    end
end)
