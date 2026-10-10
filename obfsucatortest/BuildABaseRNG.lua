if getgenv().ayasemiyatongekissazumirisa then
warn("yuri")
return
end
print("b")
function missing(t, f, fallback)
if type(f) == t then return f end
return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
print("c")
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
print("d")
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
print("e")
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
print("f")
local repo = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
print("g")
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
print("h")
getgenv().ayasemiyatongekissazumirisa = true
print("i")
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
print("x")
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
local Modules = RS:FindFirstChild("Modules") or RS:WaitForChild("Modules", 15)
local CoreFolder = Modules and (Modules:FindFirstChild("Core") or Modules:WaitForChild("Core", 15))
local Warp = CoreFolder and GetSafeModule(CoreFolder, "Warp")
local DataService = CoreFolder and GetSafeModule(CoreFolder, "DataService")
local DataClient = DataService and DataService.client
local FeaturesFolder = Modules and (Modules:FindFirstChild("Features") or Modules:WaitForChild("Features", 15))
local SkillsUtility = FeaturesFolder and FeaturesFolder:FindFirstChild("Skills") and GetSafeModule(FeaturesFolder:FindFirstChild("Skills"), "Utility")
local WeaponsConfig = FeaturesFolder and FeaturesFolder:FindFirstChild("Weapons") and GetSafeModule(FeaturesFolder:FindFirstChild("Weapons"), "WeaponsConfig")
local GameplayFolder = Modules and (Modules:FindFirstChild("Gameplay") or Modules:WaitForChild("Gameplay", 15))
local ClientBuildModule = GameplayFolder and GetSafeModule(GameplayFolder, "ClientBuildModule")
local BuildingsFolder = FeaturesFolder and FeaturesFolder:FindFirstChild("Buildings")
local BuildingsUtility = BuildingsFolder and GetSafeModule(BuildingsFolder, "Utility")
local PlacementFolder = GameplayFolder and (GameplayFolder:FindFirstChild("PlacementModule") or GameplayFolder:WaitForChild("PlacementModule", 15))
local SharedPlacementModule = PlacementFolder and GetSafeModule(PlacementFolder, "SharedPlacementModule")
local GameModule = RS:FindFirstChild("GameModule") and GetSafeModule(RS, "GameModule")
local PlaceBuildingRemote = Warp and (function() local ok, r = pcall(function() return Warp.Client("PlaceBuilding") end) return ok and r or nil end)()
if not Warp then
pcall(function()
for _, v in ipairs(getgc(true)) do
if type(v) == "table" and rawget(v, "Client") and rawget(v, "Server") and rawget(v, "Signal") then
Warp = v
break
end
end
end)
end
local _warpCache = {}
local function GetWarpEvent(name)
if _warpCache[name] ~= nil then return _warpCache[name] end
local ev = nil
if Warp then
local ok, res = pcall(function() return Warp.Client(name) end)
if ok then ev = res end
end
_warpCache[name] = ev
return ev
end
local function WarpFire(name, ...)
local ev = GetWarpEvent(name)
if not ev or type(ev.Fire) ~= "function" then return false end
local args = {...}
return pcall(function() ev:Fire(unpack(args)) end)
end
local function WarpInvoke(name, ...)
local ev = GetWarpEvent(name)
if not ev or type(ev.Invoke) ~= "function" then return nil end
local args = {...}
local ok, res = pcall(function() return ev:Invoke(unpack(args)) end)
if ok then return res end
return nil
end
local function GetData(key)
if DataClient and DataClient.waitForData then
pcall(function() DataClient:waitForData() end)
local ok, val = pcall(function() return DataClient:get(key) end)
if ok then return val end
end
return nil
end
local function GetMoney()
local v = GetData("Money")
if type(v) == "number" then return v end
return 0
end
local function GetTotalRolls()
local v = GetData("TotalRolls")
if type(v) == "number" then return v end
return 0
end
local function IsWaveActive()
if ClientBuildModule and ClientBuildModule.WaveActive ~= nil then
return ClientBuildModule.WaveActive == true
end
return false
end
local function GetWeaponCooldown()
if not WeaponsConfig or not WeaponsConfig.Melee or not WeaponsConfig.MeleeOrder then return 0.1 end
local level = 1
if SkillsUtility and SkillsUtility.GetAllOwned then
local ok, owned = pcall(SkillsUtility.GetAllOwned, Plr)
if ok and type(owned) == "table" then
for k, v in pairs(owned) do
local n = tonumber(tostring(v):match("^UnlockWeapon(%d+)$"))
if n and level < n then level = n end
end
end
end
local def = WeaponsConfig.Melee[WeaponsConfig.MeleeOrder[level]]
if def and def.Stats and def.Stats.Cooldown then return def.Stats.Cooldown end
return 0.1
end
local RarityOrder = { Basic=1, Rare=2, Refined=3, Epic=4, Legendary=5, Mythic=6, Glorious=7, Primordial=8, Atomic=9, Divine=10, Lunatic=11 }
local function GetBuilds()
if not BuildingsUtility then return {} end
local ok, all = pcall(function() return BuildingsUtility.GetAll() end)
if not ok or type(all) ~= "table" then return {} end
local list = {}
for baseName, mutations in pairs(all) do
for mutation, cfg in pairs(mutations) do
if cfg and cfg.DisplayName and cfg.Rarity then
local label = cfg.DisplayName .. " | " .. cfg.Rarity
table.insert(list, { label = label, rarity = cfg.Rarity })
end
end
end
table.sort(list, function(a, b)
local ra = RarityOrder[a.rarity] or 99
local rb = RarityOrder[b.rarity] or 99
if ra ~= rb then return ra < rb end
return a.label < b.label
end)
local labels = { "Any" }
for _, entry in ipairs(list) do
table.insert(labels, entry.label)
end
return labels
end
local function Func_AutoPlace()
notyuri("[AutoPlace] BuildingsUtility:", tostring(BuildingsUtility ~= nil))
notyuri("[AutoPlace] SharedPlacementModule:", tostring(SharedPlacementModule ~= nil))
notyuri("[AutoPlace] GameModule:", tostring(GameModule ~= nil))
notyuri("[AutoPlace] PlaceBuildingRemote:", tostring(PlaceBuildingRemote ~= nil))
notyuri("[AutoPlace] Warp:", tostring(Warp ~= nil))
while Toggles.AutoPlace.Value do
local selectedLabels = Options.BuildList and Options.BuildList.Value
local hasSelected = false
local selectAll = false
if selectedLabels then
for lbl, v in pairs(selectedLabels) do
if v then
hasSelected = true
if lbl == "Any" then selectAll = true end
end
end
end
if not hasSelected then
notyuri("[AutoPlace] No buildings selected, waiting...")
task.wait(1)
continue
end
local Plot = nil
if GameModule and GameModule.GetPlayerPlot then
local ok, p = pcall(function() return GameModule.GetPlayerPlot(Plr) end)
if ok then Plot = p end
end
if not Plot then
local plots = workspace:FindFirstChild("Plots")
if plots then
for _, v in pairs(plots:GetChildren()) do
if v:GetAttribute("OwnerId") == Plr.UserId then
Plot = v
break
end
end
end
end
notyuri("[AutoPlace] Plot:", tostring(Plot))
if not Plot then
warn("[AutoPlace] No plot found.")
task.wait(2)
continue
end
local Floor = Plot:FindFirstChild("Floor")
notyuri("[AutoPlace] Floor:", tostring(Floor))
if not Floor then
warn("[AutoPlace] Plot has no Floor.")
task.wait(2)
continue
end
local allBuildings = nil
if BuildingsUtility then
local ok, res = pcall(function() return BuildingsUtility.GetAll() end)
notyuri("[AutoPlace] GetAll ok:", tostring(ok), "type:", type(res))
if ok and type(res) == "table" then allBuildings = res end
end
if not allBuildings then
warn("[AutoPlace] BuildingsUtility.GetAll failed, cannot map labels.")
task.wait(2)
continue
end
local labelToEntry = {}
for _, mutations in pairs(allBuildings) do
for _, cfg in pairs(mutations) do
if cfg and cfg.DisplayName and cfg.Rarity and cfg.Identifier then
local label = cfg.DisplayName .. " | " .. cfg.Rarity
labelToEntry[label] = cfg
end
end
end
local queue = {}
local labelsToPlace = {}
if selectAll then
for lbl, _ in pairs(labelToEntry) do
table.insert(labelsToPlace, lbl)
end
else
for lbl, active in pairs(selectedLabels) do
if active and lbl ~= "Any" then
table.insert(labelsToPlace, lbl)
end
end
end
for _, lbl in ipairs(labelsToPlace) do
local cfg = labelToEntry[lbl]
if not cfg then
notyuri("[AutoPlace] Label not found in config:", lbl)
continue
end
local qty = 0
if BuildingsUtility then
local ok, res = pcall(function() return BuildingsUtility.GetOwnedQuantity(Plr, cfg.Identifier) end)
notyuri("[AutoPlace] OwnedQty", cfg.Identifier, "ok:", tostring(ok), "qty:", tostring(res))
if ok and type(res) == "number" then qty = res end
end
for _ = 1, qty do
table.insert(queue, cfg)
end
end
notyuri("[AutoPlace] Queue size:", #queue)
if #queue == 0 then
task.wait(1)
continue
end
local originCF = Plot:GetAttribute("PlacementOrigin") or Floor.CFrame
local floorLocalCenter = originCF:PointToObjectSpace(Floor.Position)
local surfaceLocalY = floorLocalCenter.Y + Floor.Size.Y / 2
local floorHalfX = Floor.Size.X / 2
local floorHalfZ = Floor.Size.Z / 2
local GridSize = 4
notyuri("[AutoPlace] surfaceLocalY:", surfaceLocalY, "floorHalfX:", floorHalfX, "floorHalfZ:", floorHalfZ)
local xInner = floorHalfX - GridSize
local zInner = floorHalfZ - GridSize
local corner = Options.PlaceCorner and Options.PlaceCorner.Value or "Bottom Left"
local xStart, xStep, xLimit
local zStart, zStep, zLimit
if corner == "Bottom Left" then
xStart = -xInner;  xStep =  GridSize; xLimit =  xInner
zStart = -zInner;  zStep =  GridSize; zLimit =  zInner
elseif corner == "Bottom Right" then
xStart =  xInner;  xStep = -GridSize; xLimit = -xInner
zStart = -zInner;  zStep =  GridSize; zLimit =  zInner
elseif corner == "Top Left" then
xStart = -xInner;  xStep =  GridSize; xLimit =  xInner
zStart =  zInner;  zStep = -GridSize; zLimit = -zInner
elseif corner == "Top Right" then
xStart =  xInner;  xStep = -GridSize; xLimit = -xInner
zStart =  zInner;  zStep = -GridSize; zLimit = -zInner
end
notyuri("[AutoPlace] Corner:", corner, "xStart:", xStart, "zStart:", zStart)
local function xInBounds(v) return (xStep > 0 and v <= xLimit) or (xStep < 0 and v >= xLimit) end
local function zInBounds(v) return (zStep > 0 and v <= zLimit) or (zStep < 0 and v >= zLimit) end
local placedCount = 0
local queueIdx = 1
local x = xStart
while xInBounds(x) and queueIdx <= #queue do
local z = zStart
while zInBounds(z) and queueIdx <= #queue do
local cfg = queue[queueIdx]
local model = RS.Buildings:FindFirstChild(cfg.BaseIdentifier or cfg.Name)
local size = (model and model.PrimaryPart) and model.PrimaryPart.Size or Vector3.new(GridSize, GridSize, GridSize)
local snappedX = math.round(x / GridSize) * GridSize
local snappedZ = math.round(z / GridSize) * GridSize
local localPos = Vector3.new(snappedX, surfaceLocalY + size.Y / 2, snappedZ)
notyuri("[AutoPlace] Trying", cfg.Identifier, "at localPos", tostring(localPos))
local placed = false
local conn = Plot.ChildAdded:Connect(function(child)
if child.Name == (cfg.BaseIdentifier or cfg.Name) then
placed = true
end
end)
pcall(function()
if PlaceBuildingRemote then
PlaceBuildingRemote:Invoke(10, cfg.Identifier, localPos, 0)
else
WarpInvoke("PlaceBuilding", 10, cfg.Identifier, localPos, 0)
end
end)
task.wait(0.15)
conn:Disconnect()
notyuri("[AutoPlace] placed:", tostring(placed))
if placed then
placedCount = placedCount + 1
queueIdx = queueIdx + 1
end
z = z + zStep
end
x = x + xStep
end
notyuri("[AutoPlace] Pass complete, placed:", placedCount, "of", #queue)
task.wait(3)
end
end
local function Func_AutoRoll()
while Toggles.AutoRoll.Value do
WarpInvoke("Roll", 1, 1, true)
task.wait()
end
end
local function Func_AutoAttack()
while Toggles.AutoAttack.Value do
if IsWaveActive() then
local success, err = pcall(WarpFire, "AttackWeapon", true)
if not success then
warn("Attack failed:", err)
end
end
task.wait(0.1)
end
pcall(WarpFire, "AttackWeapon", false)
end
local function Func_AutoStartWave()
while Toggles.AutoStartWave.Value do
if not IsWaveActive() then
WarpFire("StartWave", true)
end
task.wait(2)
end
end
local function Func_AutoAutoWave()
while Toggles.AutoAutoWave.Value do
WarpFire("SetAutoWave", true, true)
task.wait(10)
end
end
local function Func_AutoClaimOffline()
while Toggles.AutoClaimOffline.Value do
WarpInvoke("RequestOfflineEarnings", 16)
task.wait(120)
end
end
local _usedBoosts = {}
local function Func_AutoBoost()
while Toggles.AutoBoost.Value do
local owned = GetData("OwnedBoosts")
if type(owned) == "table" then
for boostName, qty in pairs(owned) do
if not Toggles.AutoBoost.Value then break end
if type(qty) == "number" and qty > 0 and not _usedBoosts[boostName] then
WarpInvoke("UseBoost", 8, boostName)
_usedBoosts[boostName] = os.clock()
task.wait(0.5)
elseif type(qty) ~= "number" or qty <= 0 then
_usedBoosts[boostName] = nil
end
end
end
task.wait(5)
end
end
local function Func_AutoUpgrade()
while Toggles.AutoUpgrade.Value do
local money = GetMoney()
local rolls = GetTotalRolls()
local owned = {}
if SkillsUtility and SkillsUtility.GetAllOwned then
local ok, result = pcall(SkillsUtility.GetAllOwned, Plr)
if ok and type(result) == "table" then
for _, v in pairs(result) do owned[v] = true end
end
end
if SkillsUtility and SkillsUtility.GetAll then
local ok, allSkills = pcall(SkillsUtility.GetAll)
if ok and type(allSkills) == "table" then
for skillName, cfg in pairs(allSkills) do
if not Toggles.AutoUpgrade.Value then break end
if not owned[skillName] and not cfg.SectionLink and not cfg.IsBackNode then
local mp = cfg.MoneyPrice
local rp = cfg.RollsPrice
local canAfford = (mp and money >= mp) or (rp and rolls >= rp)
if canAfford then
pcall(WarpInvoke, "BuySkill", 8, skillName)
task.wait(0.5)
end
end
end
end
end
task.wait(.1)
end
end
local function Func_AutoUpgradeBuild()
while Toggles.AutoUpgradeBuild.Value do
local selectedUpgrade = Options.UpgradeBuildList and Options.UpgradeBuildList.Value
local hasSelected = false
local selectAll = false
if selectedUpgrade then
for lbl, v in pairs(selectedUpgrade) do
if v then
hasSelected = true
if lbl == "Any" then selectAll = true end
end
end
end
if not hasSelected then
notyuri("[AutoUpgradeBuild] No buildings selected, waiting...")
task.wait(1)
continue
end
local money = GetMoney()
if not BuildingsUtility then
notyuri("[AutoUpgradeBuild] BuildingsUtility not available")
task.wait(2)
continue
end
local ok, allBuildings = pcall(function() return BuildingsUtility.GetAll() end)
if not ok or type(allBuildings) ~= "table" then
notyuri("[AutoUpgradeBuild] GetAll failed")
task.wait(2)
continue
end
for _, mutations in pairs(allBuildings) do
for _, cfg in pairs(mutations) do
if not Toggles.AutoUpgradeBuild.Value then break end
if not cfg or not cfg.Identifier or not cfg.DisplayName or not cfg.Rarity then continue end
local label = cfg.DisplayName .. " | " .. cfg.Rarity
if not selectAll and not (selectedUpgrade[label]) then continue end
local qty = 0
local qok, q = pcall(function() return BuildingsUtility.GetOwnedQuantity(Plr, cfg.Identifier) end)
if qok and type(q) == "number" then qty = q end
if qty <= 0 then continue end
local level = 1
local lok, lv = pcall(function() return BuildingsUtility.GetLevel(Plr, cfg.Identifier) end)
if lok and type(lv) == "number" then level = lv end
local maxLevel = 64
if level >= maxLevel then continue end
local price = nil
if cfg.UpgradePrice then
local pok, p = pcall(cfg.UpgradePrice, level + 1)
if pok then price = p end
end
notyuri("[AutoUpgradeBuild]", cfg.Identifier, "level:", level, "price:", tostring(price), "money:", money)
if price and money >= price then
local rok, res = pcall(WarpInvoke, "UpgradeBuilding", 8, cfg.Identifier)
notyuri("[AutoUpgradeBuild] Upgrade", cfg.Identifier, "ok:", tostring(rok), "res:", tostring(res))
task.wait(0.3)
end
end
end
task.wait(1)
end
end
local _giftIdx = 1
local function Func_AutoRequestGift()
while Toggles.AutoRequestGift.Value do
local players = Players:GetPlayers()
if #players > 1 then
_giftIdx = (_giftIdx % #players) + 1
local target = players[_giftIdx]
if target and target ~= Plr then
WarpInvoke("RequestGift", 8, target.UserId, 1)
end
end
task.wait(30)
end
end
local function DoStartWave()
WarpFire("StartWave", true)
Library:Notify("Wave started.", 3)
end
local function DoStopWave()
WarpFire("StopWave", true)
Library:Notify("Wave stopped.", 3)
end
local function DoToggleAutoWave()
WarpFire("SetAutoWave", true, true)
Library:Notify("Auto-wave enabled.", 3)
end
local function DoClaimOffline()
local res = WarpInvoke("RequestOfflineEarnings", 16)
Library:Notify("Offline earnings claimed.", 3)
end
local function DoBuySkill()
local skillName = (Options.SkillDropdown and Options.SkillDropdown.Value) or "Luck1"
local res = WarpInvoke("BuySkill", 8, skillName)
if res then
Library:Notify("Bought skill: " .. skillName, 3)
else
Library:Notify("Failed to buy skill (need more money?).", 3)
end
end
local function DoUseBoost()
local boostName = (Options.BoostDropdown and Options.BoostDropdown.Value) or "LuckBoost"
WarpInvoke("UseBoost", 8, boostName)
Library:Notify("Used boost: " .. boostName, 3)
end
local MatLabel 
local BUILD_SAVE_FOLDER = "Yuri/BuildABaseRNG/Build"
local function Build_GetPlot()
if GameModule and GameModule.GetPlayerPlot then
local ok, p = pcall(function() return GameModule.GetPlayerPlot(Plr) end)
if ok and p then return p end
end
local plots = workspace:FindFirstChild("Plots")
if plots then
for _, v in pairs(plots:GetChildren()) do
if v:GetAttribute("OwnerId") == Plr.UserId then
return v
end
end
end
return nil
end
local function Build_GetPlotCFrame()
local plot = Build_GetPlot()
if not plot then return nil end
local origin = plot:GetAttribute("PlacementOrigin")
if origin then return origin end
if plot:IsA("BasePart") then return plot.CFrame end
if plot:IsA("Model") then return plot:GetPivot() end
return nil
end
local function Build_GetOriginCF()
local plot = Build_GetPlot()
if not plot then return nil end
local origin = plot:GetAttribute("PlacementOrigin")
if origin then return origin end
local floor = plot:FindFirstChild("Floor")
if floor then return floor.CFrame end
return Build_GetPlotCFrame()
end
local function Build_GetPlacedItems()
local plot = Build_GetPlot()
if not plot then return {} end
local items = {}
for _, folderName in ipairs({"Placement", "Base"}) do
local folder = plot:FindFirstChild(folderName)
if folder then
for _, child in ipairs(folder:GetChildren()) do
if child:IsA("Model") then
local ok, cfg = pcall(function()
return BuildingsUtility and BuildingsUtility.GetConfig(child)
end)
if ok and cfg then
local mutation = child:GetAttribute("Mutation")
local identifier
if mutation and mutation ~= "" and mutation ~= "Normal" then
identifier = child.Name .. "_" .. mutation
else
identifier = child.Name
end
local pp = child:FindFirstChildWhichIsA("BasePart")
table.insert(items, { model = child, itemType = identifier, primaryPart = pp })
end
end
end
end
end
return items
end
local function Build_GetItemCount(itemName)
if not BuildingsUtility then return 0 end
local ok, qty = pcall(function() return BuildingsUtility.GetOwnedQuantity(Plr, itemName) end)
if ok and type(qty) == "number" and qty > 0 then return qty end
local baseName = itemName:match("^([^_]+)") or itemName
if baseName ~= itemName then
local ok2, qty2 = pcall(function() return BuildingsUtility.GetOwnedQuantity(Plr, baseName) end)
if ok2 and type(qty2) == "number" then return qty2 end
end
return 0
end
local function Build_GetInventory()
if not BuildingsUtility then return {} end
local ok, all = pcall(function() return BuildingsUtility.GetAll() end)
if not ok or type(all) ~= "table" then return {} end
local inv = {}
for _, mutations in pairs(all) do
for _, cfg in pairs(mutations) do
if cfg and cfg.Identifier then
local qok, qty = pcall(function() return BuildingsUtility.GetOwnedQuantity(Plr, cfg.Identifier) end)
if qok and type(qty) == "number" and qty > 0 then
inv[cfg.Identifier] = qty
end
end
end
end
return inv
end
local function Build_DoPlace(itemName, worldCF)
local originCF = Build_GetOriginCF()
if not originCF then return false end
local localPos = originCF:PointToObjectSpace(worldCF.Position)
local ok = pcall(function()
if PlaceBuildingRemote then
PlaceBuildingRemote:Invoke(10, itemName, localPos, 0)
else
WarpInvoke("PlaceBuilding", 10, itemName, localPos, 0)
end
end)
return ok
end
local function CFrameToTable(cf)
local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function TableToCFrame(t)
if type(t) ~= "table" or #t < 12 then return CFrame.new() end
return CFrame.new(t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
end
local function CopyBuildToJSON()
local plotCF = Build_GetPlotCFrame()
if not plotCF then return nil end
local items = Build_GetPlacedItems()
if #items == 0 then return nil end
local relative = plotCF:Inverse()
local data = { version = 1, count = #items, blocks = {} }
for _, item in ipairs(items) do
local cf
if item.primaryPart and item.primaryPart:IsA("BasePart") then
cf = item.primaryPart.CFrame
else
cf = item.model:GetPivot()
end
local relCF = relative * cf
table.insert(data.blocks, { name = item.itemType, cf = CFrameToTable(relCF) })
end
return HttpService:JSONEncode(data)
end
local function LoadBuildJSON(json)
if not json or json == "" then return nil end
local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
if not ok or type(data) ~= "table" or type(data.blocks) ~= "table" then return nil end
return data
end
local function ListBuildFiles()
local files = {}
if not Support.FileIO or not isfolder then return files end
pcall(function()
if not isfolder(BUILD_SAVE_FOLDER) then return end
for _, name in ipairs(listfiles(BUILD_SAVE_FOLDER)) do
if name:sub(-5) == ".json" then
local short = name:match("([^/\\]+)%.json$")
if short then table.insert(files, short) end
end
end
end)
table.sort(files)
return files
end
local function GetBuildRequirements(data)
local reqs = {}
for _, entry in ipairs(data.blocks) do
local n = entry.name
if n then reqs[n] = (reqs[n] or 0) + 1 end
end
return reqs
end
local function ComputeMissingMaterials(reqs)
local inv = Build_GetInventory()
local missing = {}
local parts = {}
for itemName, need in pairs(reqs) do
local have = inv[itemName] or 0
if have < need then
local short = need - have
missing[itemName] = short
table.insert(parts, itemName .. "(x" .. short .. ")")
end
end
table.sort(parts)
local display
if #parts == 0 then
display = "Ready"
else
display = "Missing: " .. table.concat(parts, ", ")
end
return missing, display
end
local function GetAllPlots()
local plots = workspace:FindFirstChild("Plots")
if not plots then return {} end
local out = {}
local ourPlot = Build_GetPlot()
for _, plot in ipairs(plots:GetChildren()) do
local ownerName = "Unknown"
pcall(function()
local ownerId = plot:GetAttribute("OwnerId")
if ownerId then
local p = Players:GetPlayerByUserId(ownerId)
if p then ownerName = p.Name end
end
end)
table.insert(out, { plot = plot, ownerName = ownerName, isOurs = (plot == ourPlot) })
end
return out
end
local function GetPlacedBlocksFromPlot(plot)
if not plot then return {} end
local blocks = {}
for _, folderName in ipairs({"Placement", "Base"}) do
local folder = plot:FindFirstChild(folderName)
if folder then
for _, child in ipairs(folder:GetChildren()) do
if child:IsA("Model") then
local ok, cfg = pcall(function()
return BuildingsUtility and BuildingsUtility.GetConfig(child)
end)
if ok and cfg then
local mutation = child:GetAttribute("Mutation")
local identifier
if mutation and mutation ~= "" and mutation ~= "Normal" then
identifier = child.Name .. "_" .. mutation
else
identifier = child.Name
end
local pp = child:FindFirstChildWhichIsA("BasePart")
local cf = pp and pp.CFrame or child:GetPivot()
table.insert(blocks, { name = identifier, cf = cf })
end
end
end
end
end
return blocks
end
local function SerializeBlocks(blocks, plotCF)
if not plotCF or #blocks == 0 then return nil end
local relative = plotCF:Inverse()
local data = { version = 1, count = #blocks, blocks = {} }
for _, b in ipairs(blocks) do
local relCF = relative * b.cf
table.insert(data.blocks, { name = b.name, cf = CFrameToTable(relCF) })
end
return HttpService:JSONEncode(data)
end
local function GetPlotCFrameOf(plot)
if not plot then return nil end
local origin = plot:GetAttribute("PlacementOrigin")
if origin then return origin end
if plot:IsA("BasePart") then return plot.CFrame end
if plot:IsA("Model") then return plot:GetPivot() end
return nil
end
local _buildSourcesLookup = {}
local RefreshBuildSourcesDropdown
local function SaveBuildToFile(saveName)
if not saveName or saveName == "" then
Library:Notify("Enter a file name first.", 3)
return
end
if not Support.FileIO then
Library:Notify("File IO not supported.", 4)
return
end
local json = CopyBuildToJSON()
if not json then
Library:Notify("No placed items to save.", 4)
return
end
local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
pcall(function()
if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
writefile(path, json)
end)
Library:Notify("Build saved: " .. saveName, 5)
if RefreshBuildSourcesDropdown then RefreshBuildSourcesDropdown() end
end
local function LoadBuildFromFile(saveName)
if not saveName or saveName == "" then return nil end
if not Support.FileIO then return nil end
local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
if not isfile(path) then return nil end
local ok, json = pcall(readfile, path)
if not ok or not json then return nil end
return LoadBuildJSON(json)
end
RefreshBuildSourcesDropdown = function()
if not Options.BuildSourceDropdown then return end
local plots = GetAllPlots()
local files = ListBuildFiles()
local values = {}
_buildSourcesLookup = {}
for _, p in ipairs(plots) do
local prefix = p.isOurs and "[My Plot] " or "[Plot] "
local display = prefix .. p.ownerName
table.insert(values, display)
_buildSourcesLookup[display] = { type = "plot", plot = p.plot, ownerName = p.ownerName }
end
for _, fname in ipairs(files) do
local display = "[File] " .. fname
table.insert(values, display)
_buildSourcesLookup[display] = { type = "file", name = fname }
end
Options.BuildSourceDropdown:SetValues(values)
end
local function LoadSelectedBuildSource()
local sel = Options.BuildSourceDropdown and Options.BuildSourceDropdown.Value
if not sel or sel == "" then
Library:Notify("Select a base or file first.", 3)
return nil
end
local entry = _buildSourcesLookup[sel]
if not entry then
Library:Notify("Unknown source: " .. sel, 4)
return nil
end
if entry.type == "plot" then
local blocks = GetPlacedBlocksFromPlot(entry.plot)
if #blocks == 0 then
Library:Notify("That plot has no placed blocks.", 4)
return nil
end
local plotCF = GetPlotCFrameOf(entry.plot)
if not plotCF then return nil end
local json = SerializeBlocks(blocks, plotCF)
return LoadBuildJSON(json)
elseif entry.type == "file" then
return LoadBuildFromFile(entry.name)
end
return nil
end
local function UpdateMaterialLabel()
if not MatLabel then return end
local data = LoadSelectedBuildSource()
if not data then
MatLabel:SetText("No build selected.")
return
end
local reqs = GetBuildRequirements(data)
local _, display = ComputeMissingMaterials(reqs)
MatLabel:SetText(display)
end
local function RunBuildFromSelectedSource()
local data = LoadSelectedBuildSource()
if not data then
Library:Notify("Select a build file first.", 3)
return
end
local plotCF = Build_GetPlotCFrame()
if not plotCF then
Library:Notify("No plot found.", 4)
return
end
local plot = Build_GetPlot()
if not plot then
Library:Notify("No plot found.", 4)
return
end
local ConfirmRad = 3
local MaxPending = 5
local Timeout = 0.5
local MaxRetries = 2
local pending = {}
local placed, skipped, confirmed = 0, 0, 0
notyuri("[LoadBuild] starting, blocks:", #data.blocks, "plotCF:", tostring(plotCF.Position))
local function connectConfirm(folder, handler)
if folder then return folder.ChildAdded:Connect(handler) end
return nil
end
local function onPlacedChild(child)
if not child:IsA("Model") then return end
local pp = child:FindFirstChildWhichIsA("BasePart")
if not pp then return end
for i, p in ipairs(pending) do
local dist = (pp.Position - p.Position).Magnitude
if dist < ConfirmRad then
table.remove(pending, i)
confirmed = confirmed + 1
notyuri("[LoadBuild] confirmed:", child.Name, "dist:", string.format("%.2f", dist), "pending:", #pending, "total confirmed:", confirmed)
break
end
end
end
local connP = connectConfirm(plot:FindFirstChild("Placement"), onPlacedChild)
local connB = connectConfirm(plot:FindFirstChild("Base"), onPlacedChild)
for idx, entry in ipairs(data.blocks) do
if not Toggles.LoadBuild.Value then
notyuri("[LoadBuild] toggle off, stopping at block", idx)
break
end
local itemName = entry.name
local count = Build_GetItemCount(itemName)
local placeAs = itemName
if count > 0 then
local ok, qty = pcall(function() return BuildingsUtility and BuildingsUtility.GetOwnedQuantity(Plr, itemName) end)
if not (ok and type(qty) == "number" and qty > 0) then
placeAs = itemName:match("^([^_]+)") or itemName
end
end
if count > 0 then
local relCF = TableToCFrame(entry.cf)
local worldCF = plotCF * relCF
notyuri("[LoadBuild] placing", placeAs, "(saved as", itemName .. ")", "block", idx, "pos:", tostring(worldCF.Position), "inv:", count)
table.insert(pending, { Position = worldCF.Position, itemName = placeAs, cf = worldCF, retries = 0 })
Build_DoPlace(placeAs, worldCF)
placed = placed + 1
local t0 = tick()
while #pending > MaxPending do
if tick() - t0 > Timeout then
local oldest = table.remove(pending, 1)
if oldest.retries < MaxRetries then
oldest.retries = oldest.retries + 1
notyuri("[LoadBuild] throttle timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
Build_DoPlace(oldest.itemName, oldest.cf)
table.insert(pending, oldest)
else
notyuri("[LoadBuild] throttle timeout, giving up on", oldest.itemName, "after", MaxRetries, "retries")
end
t0 = tick()
end
task.wait()
end
else
notyuri("[LoadBuild] skipping", itemName, "block", idx, "- no inventory")
skipped = skipped + 1
end
end
notyuri("[LoadBuild] main loop done. placed:", placed, "skipped:", skipped, "confirmed:", confirmed, "pending:", #pending)
local t0 = tick()
while #pending > 0 do
if tick() - t0 > Timeout then
local oldest = table.remove(pending, 1)
if oldest.retries < MaxRetries then
oldest.retries = oldest.retries + 1
notyuri("[LoadBuild] drain timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
Build_DoPlace(oldest.itemName, oldest.cf)
table.insert(pending, oldest)
else
notyuri("[LoadBuild] drain timeout, giving up on", oldest.itemName, "after", MaxRetries, "retries")
end
t0 = tick()
end
task.wait()
end
if #pending == 0 then
notyuri("[LoadBuild] all confirmed ok")
end
pending = {}
if connP then connP:Disconnect() end
if connB then connB:Disconnect() end
Toggles.LoadBuild:SetValue(false)
Library:Notify(("Build loaded: %d placed, %d skipped."):format(placed, skipped), 5)
UpdateMaterialLabel()
end
local function CopyBuildToClipboard()
local json = CopyBuildToJSON()
if not json then
Library:Notify("No placed items to copy.", 4)
return
end
if setclipboard then
pcall(setclipboard, json)
Library:Notify("Build copied to clipboard.", 5)
end
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
print("y")
AddInfo(Window)
local Tabs = {
Main = Window:AddTab("Main"),
Build = Window:AddTab("Build"),
Player = Window:AddTab("Player"),
Config = Window:AddTab("Config"),
}
local A1 = Tabs.Build:AddLeftGroupbox("Build")
local A2 = Tabs.Build:AddRightGroupbox("Material")
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
print("y1")
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
print("y2")
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
print("y3")
TB_Tabs.Autofarm.T1:AddToggle("AutoRoll", { Text = "Auto Roll", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBoost", { Text = "Auto Boost", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgradeBuild", { Text = "Auto Upgrade Build", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("BoostDropdown", { Text = "Boost", Values = { "LuckBoost", "CashBoost", "RollBoost" }, Default = "LuckBoost" })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("BuildList", {
Text = "Build List",
Values = GetBuilds(),
Default = {},
Multi = true,
Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("PlaceCorner", {
Text = "Build Corner",
Values = { "Bottom Left", "Bottom Right", "Top Left", "Top Right" },
Default = "Bottom Left",
})
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeBuildList", {
Text = "Upgrade Build List",
Values = GetBuilds(),
Default = {},
Multi = true,
Searchable = true,
})
A1:AddDropdown("BuildSourceDropdown", {
Text = "Select Build to Load",
Values = {},
Default = "",
Multi = false,
Searchable = true,
Callback = function()
UpdateMaterialLabel()
end,
})
MatLabel = A2:AddLabel("No build selected.", true)
A1:AddToggle("LoadBuild", {
Text = "Load Build",
Default = false,
Callback = function(state)
if state then
local t = task.spawn(function()
while Toggles.LoadBuild.Value do
RunBuildFromSelectedSource()
task.wait(5)
end
end)
Flags.LoadBuild = t
else
if Flags.LoadBuild and typeof(Flags.LoadBuild) == "thread" then
task.cancel(Flags.LoadBuild)
Flags.LoadBuild = nil
end
end
end,
})
A1:AddInput("BuildSaveName", {
Text = "File Name",
Default = "",
Placeholder = "yuriyuri",
Callback = function() end,
})
A1:AddButton({
Text = "Save Build",
Func = function()
SaveBuildToFile(Options.BuildSaveName and Options.BuildSaveName.Value or "")
end,
})
A1:AddButton({
Text = "Save Selected",
Func = function()
local saveName = Options.BuildSaveName and Options.BuildSaveName.Value or ""
if not saveName or saveName == "" then
Library:Notify("Enter a file name first.", 3)
return
end
if not Support.FileIO then
Library:Notify("File IO not supported by executor.", 4)
return
end
local data = LoadSelectedBuildSource()
if not data then return end
local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
if not ok or not json then
Library:Notify("Failed to encode build data.", 4)
return
end
local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
pcall(function()
if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
writefile(path, json)
end)
local count = type(data.blocks) == "table" and #data.blocks or 0
Library:Notify(("Selected build saved to %s (%d blocks)"):format(saveName, count), 5)
notyuri("[CopyBuild] selected saved to", path)
RefreshBuildSourcesDropdown()
end,
})
task.spawn(function()
task.wait(2)
RefreshBuildSourcesDropdown()
end)
print("y4")
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
Toggles.AutoBoost:OnChanged(function(v) Thread("AutoBoost", SafeLoop("AutoBoost", Func_AutoBoost), v) end)
Toggles.AutoUpgrade:OnChanged(function(v) Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v) end)
Toggles.AutoUpgradeBuild:OnChanged(function(v) Thread("AutoUpgradeBuild", SafeLoop("AutoUpgradeBuild", Func_AutoUpgradeBuild), v) end)
Toggles.AutoPlace:OnChanged(function(v) Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), v) end)
print("y5")
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
print("y6")
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
print("y7")
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
print("y8")
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
print("y9")
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/BuildABaseRNG")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
print("y10")
SaveManager:LoadAutoloadConfig()
print("y11")
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
print("z")
Library:Notify("Yuri!", 5)
end)
if not eh_success then
Library:Notify("ERROR: " .. tostring(err), 4)
notyuri("ERROR: " .. tostring(err))
end