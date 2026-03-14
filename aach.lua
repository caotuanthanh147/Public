local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer    = Players.LocalPlayer
local Remotes        = ReplicatedStorage:WaitForChild("Remotes")
local Items          = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Items"))
local PlayerInventory = Remotes:WaitForChild("PlayerInventory")
local InvestStats     = Remotes:WaitForChild("InvestStats")
local GetStats        = Remotes:WaitForChild("GetStats")
local Encounters     = require(ReplicatedStorage:WaitForChild("Dictionaries"):WaitForChild("Encounters"))
local GetSceneOptions = Remotes:WaitForChild("GetSceneOptions")
local SceneEvent      = Remotes:WaitForChild("SceneEvent")
local VotingEvent     = Remotes:WaitForChild("VotingEvent")
local STAT_UPGRADE_CONFIG = {
    STR = { enabled = true,  priority = 1 },
    DEX = { enabled = false, priority = 0 },
    CON = { enabled = true,  priority = 2 },
    INT = { enabled = false, priority = 0 },
    FTH = { enabled = false, priority = 0 },
    CHA = { enabled = false, priority = 0 },
    LCK = { enabled = false, priority = 0 },
}
local EQUIPMENT_STAT_WEIGHTS = {
    FlatSTR = 3.0,
    FlatDEX = 3.5,
    FlatCON = 2.0,
    FlatINT = 1,
    FlatFTH = 0,
    FlatCHA = 0,
    FlatLCK = 4,
}
local UPGRADE_THRESHOLD  = 4
local SHOP_GOLD_THRESHOLD = 80  
local currentStats     = {}
local currentInventory = {}
local currentEquipment = {}
GetStats.OnClientEvent:Connect(function(p485, p486)
    if p486 == "Self" then currentStats = p485 end
end)
PlayerInventory.OnClientEvent:Connect(function(p489, p490)
    if p489 == "Inventory" then
        currentInventory = p490.Player.Inventory
        currentEquipment = p490.Player.Equipment
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
        return itemData.WeaponType == "Fist" and "Fist" or "OtherWeapon"
    end
    return "Misc"
end
local function autoEquip()
    local bestPerSlot = {}
    for invKey, invItem in pairs(currentInventory) do
        local itemData = Items[invItem.Name]
        if itemData then
            local slot = itemData.Slot
            if slot and slot ~= "Consumable" then
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
    local armorCandidates = {}   
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
SceneEvent.OnClientEvent:Connect(function(p31, p32)
    if p31 ~= "OpenEncounterUI" then return end
    task.spawn(function()
        task.wait(0.3)
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
        table.sort(options, function(a, b) return a.danger < b.danger end)
        VotingEvent:FireServer("Encounter", options[1].name)
    end)
end)

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
        table.sort(keys)
        local pick = keys[math.random(1, math.min(3, #keys))]
        if sceneData.Client then
            VotingEvent:FireServer("SceneClient", pick)
        else
            VotingEvent:FireServer("Scene", pick)
        end
    end)
end)
local RestFrame = LocalPlayer.PlayerGui.RestGUI.RestFrame
task.spawn(function()
    local lastVisible = false
    while true do
        local visible = RestFrame.Visible
        if visible and not lastVisible then
            lastVisible = true
            task.spawn(function()
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
