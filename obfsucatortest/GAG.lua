if getgenv().ayasemiyatongekissazumirisa then
    warn("yuri")
    return
end
function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
cloneref       = missing("function", cloneref, function(...) return ... end)
getgc          = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
    __index = function(self, name)
        local ok, cache = pcall(function() return cloneref(game:GetService(name)) end)
        if ok then rawset(self, name, cache); return cache
        else error("Invalid Service: " .. tostring(name)) end
    end
})
local Players         = Services.Players
local Plr             = Players.LocalPlayer
local Char            = Plr.Character or Plr.CharacterAdded:Wait()
local PGui            = Plr:WaitForChild("PlayerGui")
local Lighting        = Services.Lighting
local RS              = Services.ReplicatedStorage
local RunService      = Services.RunService
local HttpService     = Services.HttpService
local GuiService      = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace     = Services.MarketplaceService
local UIS             = Services.UserInputService
local CollectionService = Services.CollectionService
local Support = {
    Webhook    = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard  = (typeof(setclipboard) == "function"),
    FileIO     = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    Connections = (typeof(getconnections) == "function"),
    FPS        = (typeof(setfpscap) == "function"),
    Proximity  = (typeof(fireproximityprompt) == "function"),
}
local executorName        = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors    = { "xeno", "solara" }
local isLimitedExecutor   = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then isLimitedExecutor = true; break end
end
function notyuri(...)
end
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
local repo         = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"
local Flags       = {}
local Connections = { Player_General = nil, Knockback = {}, Reconnect = nil, Webhook = {}, AntiSteal = nil, FruitHL = nil, GardenStats = nil }
local function Cleanup(tbl)
    for key, value in pairs(tbl) do
        if typeof(value) == "RBXScriptConnection" then value:Disconnect(); tbl[key] = nil
        elseif typeof(value) == "thread" then task.cancel(value); tbl[key] = nil
        elseif type(value) == "table" then Cleanup(value) end
    end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
    local parts = featurePath:split(".")
    local cur = Flags
    for i = 1, #parts - 1 do
        if not cur[parts[i]] then cur[parts[i]] = {} end
        cur = cur[parts[i]]
    end
    local key = parts[#parts]
    if isEnabled then
        if not cur[key] or coroutine.status(cur[key]) == "dead" then
            cur[key] = task.spawn(featureFunc, ...)
        end
    else
        if cur[key] and typeof(cur[key]) == "thread" then
            task.cancel(cur[key]); cur[key] = nil
        end
    end
end
local function SafeLoop(name, func)
    return function()
        local ok, err = pcall(func)
        if not ok then Library:Notify("Error [" .. name .. "]: " .. tostring(err), 10) end
    end
end
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function Abbreviate(n)
    local abbrev = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
    for _, v in ipairs(abbrev) do
        if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
    end
    return tostring(n)
end
function AddInputToggle(Config)
    local Toggle = Config.Group:AddToggle(Config.Id, { Text = Config.Text, Default = Config.DefaultToggle or false })
    local Input = Config.Group:AddInput(Config.Id .. "Value", {
        Text = Config.Text,
        Default = tostring(Config.Default),
        Numeric = true,
        Finished = true,
        Visible = false,
    })
    Toggle:OnChanged(function() Input:SetVisible(Toggle.Value) end)
    return Toggle, Input
end
local function FirePP(target, teleport)
    if not fireproximityprompt or not target or not target:IsA("ProximityPrompt") then return end
    local prev = target.MaxActivationDistance
    target.MaxActivationDistance = math.huge
    if teleport then
        local hrp = Char and Char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        if hrp and part and part:IsA("BasePart") then hrp.CFrame = part.CFrame * CFrame.new(0, 0, -3); task.wait() end
    end
    fireproximityprompt(target)
    task.delay(0.5, function() if target and target.Parent then target.MaxActivationDistance = prev end end)
end
local function AddInfo(Window)
    local InfoTab  = Window:AddTab("Info")
    local InfoLeft = InfoTab:AddLeftGroupbox("Information")
    local statusTxt = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
    local extraNote = isLimitedExecutor
        and "<b>NOTE:</b> May experience bugs for some features!"
        or "All features should work properly!"
    InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusTxt .. "\n" .. extraNote, true)
    local InfoRight = InfoTab:AddRightGroupbox("Others")
    InfoRight:AddButton({ Text = "Join Discord Server", Func = function()
        local code = "uuza7nsPq"
        local link = "https://discord.gg/" .. code
        local ok = false
        if request then
            ok = pcall(function()
                request({ Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST",
                    Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
                    Body = HttpService:JSONEncode({ cmd = "INVITE_BROWSER", args = { code = code }, nonce = HttpService:GenerateGUID(false) }) })
            end)
        end
        if not ok and setclipboard then setclipboard(link) end
    end })
end
local eh_ok, eh_err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
    local s = os.time() - Script_Start_Time
    return string.format("%dh %02dm", math.floor(s / 3600), math.floor((s % 3600) / 60))
end
local Networking    = require(RS.SharedModules.Networking)
local SeedData      = require(RS.SharedModules.SeedData)
local SellValueData = require(RS.SharedModules.SellValueData)
local Net = {
    Garden = {
        CollectFruit   = function(plantId, fruitId) Networking.Garden.CollectFruit:Fire(plantId, fruitId) end,
        RequestGardens = function() Networking.Garden.RequestGardens:Fire() end,
    },
    Sell = {
        PreviewSellAll    = function() return Networking.NPCS.PreviewSellAll:Fire() end,
        SellAll           = function() return Networking.NPCS.SellAll:Fire() end,
        SellFruit         = function(fruitId) return Networking.NPCS.SellFruit:Fire(fruitId) end,
        AskBidAll         = function() return Networking.NPCS.AskBidAll:Fire() end,
        CheckDailyDeal    = function() return Networking.NPCS.CheckDailyDeal:Fire() end,
        UseDailyDealAll   = function() return Networking.NPCS.UseDailyDealAll:Fire() end,
        UseDailyDealSingle = function(fruitId) return Networking.NPCS.UseDailyDealSingle:Fire(fruitId) end,
    },
    Shop = {
        PurchaseSeed  = function(seedName) Networking.SeedShop.PurchaseSeed:Fire(seedName) end,
        PurchaseCrate = function(crateName) Networking.CrateShop.PurchaseCrate:Fire(crateName) end,
        PurchaseGear  = function(itemName) Networking.GearShop.PurchaseGear:Fire(itemName) end,
    },
    Open = {
        Crate          = function(crateId) return Networking.Crate.OpenCrate:Fire(crateId) end,
        SeedPack       = function(packId) return Networking.SeedPack.OpenSeedPack:Fire(packId) end,
        ConfirmSeedPack = function(packId, seed, mut) Networking.SeedPack.ConfirmSeedPack:Fire(packId, seed, mut) end,
        ClickPack      = function(packId) Networking.SeedPack.ClickPack:Fire(packId) end,
    },
    Misc = {
        SubmitCode   = function(code) return Networking.Settings.SubmitCode:Fire(code) end,
        RequestHop   = function() Networking.AntiAfk.RequestHop:Fire() end,
        ExpandGarden = function() return Networking.Actions.ExpandGarden:Fire() end,
    },
    Steal = {
        Begin    = function(userId, plantId, fruitId) Networking.Steal.BeginSteal:Fire(userId, plantId, fruitId) end,
        Cancel   = function() Networking.Steal.CancelSteal:Fire() end,
        Complete = function() Networking.Steal.CompleteSteal:Fire() end,
    },
    Pets = {
        EquipByName    = function(name) Networking.Pets.RequestEquipByName:Fire(name) end,
        UnequipByName  = function(name) Networking.Pets.RequestUnequipByName:Fire(name) end,
        UnequipById    = function(id) Networking.Pets.RequestUnequip:Fire(id) end,
        GetEquipped    = function() return Networking.Pets.GetEquippedPets:Fire() end,
        ToggleFollower = function(id) Networking.Pets.RequestToggleFollower:Fire(id) end,
        PurchaseSlot   = function() Networking.Pets.RequestPurchasePetSlot:Fire() end,
        WildTame       = function(inst) Networking.Pets.WildPetTame:Fire(inst) end,
    },
    Shovel = {
        Use = function(plantId, fruitId, shovelAttr, tool) Networking.Shovel.UseShovel:Fire(plantId, fruitId, shovelAttr, tool) end,
    },
}
local KnownCodes = {
    "TEAMGREENBEAN",
}
local SeedNames = {}
for _, seed in SeedData do
    if seed.RestockShop then
        table.insert(SeedNames, seed.SeedName)
    end
end
table.sort(SeedNames)
local SeedPriceMap = {}
for _, seed in SeedData do
    if seed.SeedName and seed.PurchasePrice then
        SeedPriceMap[seed.SeedName] = seed.PurchasePrice
    end
end
local ShecklesVal = Plr:WaitForChild("leaderstats"):WaitForChild("Sheckles")
local SeedNamesWithAll = {"All"}
for _, name in ipairs(SeedNames) do table.insert(SeedNamesWithAll, name) end
local CrateNames = {}
for _, v in ipairs(RS.StockValues.CrateShop.Items:GetChildren()) do
    table.insert(CrateNames, v.Name)
end
table.sort(CrateNames)
local GearNames = {}
for _, v in ipairs(RS.StockValues.GearShop.Items:GetChildren()) do
    table.insert(GearNames, v.Name)
end
table.sort(GearNames)
local StatusLabel = nil
local StatusText  = "Idle"
local function SetStatus(txt) StatusText = txt end
local HarvestingFruits = {}
local function GetMyPlot()
    local plotId = Plr:GetAttribute("PlotId")
    return plotId and workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId))
end
local function GetFruitSellValue(seedName, sizeMulti, mutation)
    local base = (SellValueData[seedName] or 100) * (sizeMulti or 1) ^ 3
    return math.floor(base)
end
local function ParseCost(str)
    if not str then return 0 end
    return tonumber(str:gsub("[^%d]", "")) or 0
end
local function SendWebhook(content, pingId)
    notyuri("[WH] SendWebhook called | content:", tostring(content), "| pingId:", tostring(pingId))
    if not Support.Webhook then
        notyuri("[WH] BLOCKED: Support.Webhook is false — executor has no request/http_request function")
        notyuri("[WH] SendWebhook blocked: no HTTP support in executor")
        return
    end
    notyuri("[WH] Support.Webhook OK")
    local url = Options.WebhookURL and Options.WebhookURL.Value or ""
    notyuri("[WH] URL value:", tostring(url), "| length:", #url)
    if url == "" then
        notyuri("[WH] BLOCKED: WebhookURL is empty — set a webhook URL in the Webhook tab")
        notyuri("[WH] SendWebhook blocked: URL is empty")
        return
    end
    notyuri("[WH] URL OK:", url)
    local msg = content
    if pingId and pingId ~= "" then
        msg = "<@" .. pingId .. "> " .. msg
        notyuri("[WH] Ping prepended, pingId:", pingId)
    else
        notyuri("[WH] No ping (pingId empty or nil)")
    end
    notyuri("[WH] Final message:", msg)
    local fn = request or http_request
    notyuri("[WH] HTTP function:", fn == request and "request" or "http_request")
    local avatarUrl = yuri[math.random(1, #yuri)]
    local thumbUrl  = yuri[math.random(1, #yuri)]
    local color     = math.random(0, 0xFFFFFF)
    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    notyuri("[WH] avatar_url:", avatarUrl)
    notyuri("[WH] thumbnail url:", thumbUrl)
    notyuri("[WH] color:", color, "| timestamp:", timestamp)
    local payload = {
        username   = "Yuri",
        avatar_url = avatarUrl,
        embeds = {{
            description = msg,
            color       = color,
            thumbnail   = { url = thumbUrl },
            timestamp   = timestamp
        }}
    }
    local bodyOk, bodyStr = pcall(HttpService.JSONEncode, HttpService, payload)
    if not bodyOk then
        notyuri("[WH] ERROR: JSONEncode failed:", tostring(bodyStr))
        notyuri("[WH] JSONEncode error:", bodyStr)
        return
    end
    notyuri("[WH] Body encoded OK, length:", #bodyStr)
    notyuri("[WH] Body preview:", bodyStr:sub(1, 200))
    notyuri("[WH] Firing HTTP request to:", url)
    local reqOk, reqResult = pcall(fn, {
        Url    = url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body   = bodyStr,
    })
    if reqOk then
        notyuri("[WH] Request pcall OK | result type:", type(reqResult))
        if type(reqResult) == "table" then
            notyuri("[WH] StatusCode:", tostring(reqResult.StatusCode), "| StatusMessage:", tostring(reqResult.StatusMessage))
            notyuri("[WH] Body:", tostring(reqResult.Body and reqResult.Body:sub(1, 300) or "(nil)"))
            if reqResult.StatusCode and reqResult.StatusCode >= 400 then
                notyuri("[WH] Discord returned error", reqResult.StatusCode, ":", reqResult.Body)
                notyuri("[WH] DISCORD ERROR — check URL is correct and not expired")
            else
                notyuri("[WH] SUCCESS — webhook delivered")
            end
        else
            notyuri("[WH] Result (non-table):", tostring(reqResult))
        end
    else
        notyuri("[WH] Request pcall FAILED:", tostring(reqResult))
        notyuri("[WH] HTTP request error:", reqResult)
    end
end
local function GetPingId()
    return Options.WebhookPingId and Options.WebhookPingId.Value or ""
end
local function DoHarvest()
    local myPlot = GetMyPlot()
    if not myPlot then
        notyuri("DoHarvest: plot not found (PlotId:", tostring(Plr:GetAttribute("PlotId")), ")")
        return
    end
    local Plants = myPlot:FindFirstChild("Plants")
    if not Plants then return end
    local filterSeed = Options.HarvestSeedFilter and Options.HarvestSeedFilter.Value or ""
    local skipMut    = Toggles.HarvestSkipMutation and Toggles.HarvestSkipMutation.Value
    local minSize    = tonumber(Options.HarvestMinSizeValue and Options.HarvestMinSizeValue.Value) or 0
    for _, plant in Plants:GetChildren() do
        local plantId = plant:GetAttribute("PlantId")
        if not plantId then continue end
        local seedName = plant:GetAttribute("SeedName") or ""
        if filterSeed ~= "" and seedName ~= filterSeed then continue end
        local FruitsFolder = plant:FindFirstChild("Fruits")
        local fruits = FruitsFolder and FruitsFolder:GetChildren() or {}
        if #fruits > 0 then
            for _, fruit in fruits do
                local fruitId = fruit:GetAttribute("FruitId")
                if not fruitId then continue end
                if HarvestingFruits[fruitId] then continue end
                local sizeMulti = fruit:GetAttribute("SizeMulti") or 1
                if sizeMulti < minSize then continue end
                local mutation = fruit:GetAttribute("Mutation")
                if skipMut and mutation and mutation ~= "" then continue end
                HarvestingFruits[fruitId] = true
                Net.Garden.CollectFruit(plantId, fruitId)
                notyuri("Harvest:", plantId, fruitId, "mut:", tostring(mutation))
                task.wait()
            end
        else
            local harvestPrompt = plant:FindFirstChild("HarvestPrompt", true)
            if harvestPrompt then
                Net.Garden.CollectFruit(plantId, "")
                notyuri("Harvest single:", plantId)
                task.wait()
            end
        end
    end
end
local function Func_AutoHarvest()
    while Toggles.AutoHarvest.Value do
        SetStatus("Harvesting...")
        table.clear(HarvestingFruits)
        local ok, err = pcall(DoHarvest)
        if not ok then notyuri("AutoHarvest error:", err) end
        task.wait(0.1)
    end
    SetStatus("Idle")
end
local function DoShovel()
    local myPlot = GetMyPlot()
    if not myPlot then return end
    local Plants = myPlot:FindFirstChild("Plants")
    if not Plants then return end
    local filterSeed = Options.ShovelSeedFilter and Options.ShovelSeedFilter.Value or ""
    local char = Plr.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return end
    local shovelTool = char:FindFirstChild("Shovel") or Plr.Backpack:FindFirstChild("Shovel")
    if not shovelTool then notyuri("DoShovel: no shovel in inventory"); return end
    local shovelAttr = shovelTool:GetAttribute("Shovel")
    if not shovelAttr then notyuri("DoShovel: shovel attribute missing"); return end
    if shovelTool.Parent ~= char then
        hum:EquipTool(shovelTool)
        task.wait(0.2)
    end
    for _, plant in Plants:GetChildren() do
        if not Toggles.AutoShovel.Value then break end
        local plantId = plant:GetAttribute("PlantId")
        if not plantId then continue end
        local seedName = plant:GetAttribute("SeedName") or ""
        if filterSeed ~= "" and seedName ~= filterSeed then continue end
        local FruitsFolder = plant:FindFirstChild("Fruits")
        local fruitId = ""
        if FruitsFolder then
            local firstFruit = FruitsFolder:GetChildren()[1]
            if firstFruit then fruitId = firstFruit:GetAttribute("FruitId") or "" end
        end
        notyuri("Shovel:", plantId, fruitId)
        Net.Shovel.Use(plantId, fruitId, shovelAttr, shovelTool)
        task.wait(0.5)
    end
end
local function Func_AutoShovel()
    while Toggles.AutoShovel.Value do
        SetStatus("Shoveling...")
        local ok, err = pcall(DoShovel)
        if not ok then notyuri("AutoShovel error:", err) end
        task.wait(1)
    end
    SetStatus("Idle")
end
local function Func_AutoCollectEventSeeds()
    local SeedPackSpawnServerLocations = workspace.Map:FindFirstChild("SeedPackSpawnServerLocations")
    if not SeedPackSpawnServerLocations then
        notyuri("AutoCollectEventSeeds: SeedPackSpawnServerLocations not found")
        return
    end
    local function tryCollect(child)
        local packId = child:GetAttribute("SeedPack")
        if not packId then
            child:GetAttributeChangedSignal("SeedPack"):Wait()
            packId = child:GetAttribute("SeedPack")
        end
        if packId then
            notyuri("Collecting event seed pack:", packId)
            Net.Open.ClickPack(packId)
        end
    end
    for _, child in SeedPackSpawnServerLocations:GetChildren() do
        task.spawn(tryCollect, child)
    end
    local conn = SeedPackSpawnServerLocations.ChildAdded:Connect(function(child)
        if not Toggles.AutoCollectEventSeeds.Value then return end
        task.spawn(tryCollect, child)
    end)
    while Toggles.AutoCollectEventSeeds.Value do task.wait(1) end
    conn:Disconnect()
end
local plantedPositions = {} 
local function DoPlant()
    local myPlot = GetMyPlot()
    if not myPlot then return end
    local gardenAreaPart = nil
    for _, part in myPlot:GetDescendants() do
        if part:IsA("BasePart") and CollectionService:HasTag(part, "GardenTotalArea") then
            gardenAreaPart = part; break
        end
    end
    if not gardenAreaPart then return end
    local selectedSeeds = Options.SeedToPlantDropdown and Options.SeedToPlantDropdown.Value
    if not selectedSeeds then return end
    local seedsToPlant = {}
    if selectedSeeds["All"] then
        for _, name in ipairs(SeedNames) do seedsToPlant[name] = true end
    else
        seedsToPlant = selectedSeeds
    end
    local Backpack = Plr:FindFirstChildOfClass("Backpack")
    local char = Plr.Character
    if not Backpack or not char then return end
    local seedToolMap = {}
    local equipped = char:FindFirstChildWhichIsA("Tool")
    if equipped then
        local attr = equipped:GetAttribute("SeedTool")
        if attr then
            if not seedToolMap[attr] then seedToolMap[attr] = {} end
            table.insert(seedToolMap[attr], equipped)
        end
    end
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local attr = tool:GetAttribute("SeedTool")
            if attr then
                if not seedToolMap[attr] then seedToolMap[attr] = {} end
                table.insert(seedToolMap[attr], tool)
            end
        end
    end
    local cf = gardenAreaPart.CFrame
    local size = gardenAreaPart.Size
    local halfX, halfZ = (size.X / 2) - 1, (size.Z / 2) - 1
    local spacing = 4
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Include
    rayParams.FilterDescendantsInstances = { gardenAreaPart }
    local Plants = myPlot:FindFirstChild("Plants")
    local occupiedSet = {}
    if Plants then
        for _, plant in Plants:GetChildren() do
            if plant:IsA("Model") then
                local ok, pivot = pcall(function() return plant:GetPivot() end)
                if ok and pivot then
                    local p = pivot.Position
                    occupiedSet[#occupiedSet + 1] = Vector2.new(p.X, p.Z)
                end
            end
        end
    end
    local function isOccupied(pos)
        local px, pz = pos.X, pos.Z
        for _, ov in ipairs(occupiedSet) do
            local dx, dz = ov.X - px, ov.Y - pz
            if dx * dx + dz * dz < 10 then return true end
        end
        return false
    end
    local freePositions = {}
    for x = -halfX, halfX, spacing do
        for z = -halfZ, halfZ, spacing do
            local pos = (cf * CFrame.new(x, 0, z)).Position
            local hit = workspace:Raycast(pos + Vector3.new(0, 50, 0), Vector3.new(0, -100, 0), rayParams)
            if hit then
                if isOccupied(hit.Position) then
                    local key = math.floor(hit.Position.X * 10 + 0.5) .. "_" .. math.floor(hit.Position.Z * 10 + 0.5)
                    plantedPositions[key] = nil
                else
                    local key = math.floor(hit.Position.X * 10 + 0.5) .. "_" .. math.floor(hit.Position.Z * 10 + 0.5)
                    if not plantedPositions[key] then
                        table.insert(freePositions, hit.Position)
                    end
                end
            end
        end
    end
    if #freePositions == 0 then return end
    local posIdx = 1
    for seedName, active in pairs(seedsToPlant) do
        if not active then continue end
        local tools = seedToolMap[seedName]
        if not tools or #tools == 0 then continue end
        for _, tool in ipairs(tools) do
            if not Toggles.AutoPlant.Value then return end
            if posIdx > #freePositions then return end
            local pos = freePositions[posIdx]
            posIdx += 1
            Networking.Plant.PlantSeed:Fire(pos, seedName, tool)
            occupiedSet[#occupiedSet + 1] = Vector2.new(pos.X, pos.Z)
            local key = math.floor(pos.X * 10 + 0.5) .. "_" .. math.floor(pos.Z * 10 + 0.5)
            plantedPositions[key] = true
        end
    end
end
local function Func_AutoPlant()
    while Toggles.AutoPlant.Value do
        SetStatus("Planting...")
        local ok, err = pcall(DoPlant)
        if not ok then notyuri("AutoPlant error:", err) end
        task.wait(0.5)
    end
    SetStatus("Idle")
end
local function DoSell()
    local preview = Net.Sell.PreviewSellAll()
    if not preview or (preview.FruitCount or 0) <= 0 then
        notyuri("DoSell: nothing to sell, skipping")
        return
    end
    notyuri("SellPreview FruitCount:", tostring(preview.FruitCount))
    local result = Net.Sell.SellAll()
end
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        local mode = Options.SellMode and Options.SellMode.Value or "Always"
        SetStatus("Selling...")
        if mode == "Always" then
            local ok, err = pcall(DoSell)
            if not ok then notyuri("AutoSell error:", err) end
            task.wait(2)
        elseif mode == "Inventory Count" then
            local threshold = tonumber(Options.SellInvThresholdValue and Options.SellInvThresholdValue.Value) or 20
            local count = #Plr.Backpack:GetChildren()
            if count >= threshold then
                local ok, err = pcall(DoSell)
                if not ok then notyuri("AutoSell error:", err) end
            end
            task.wait(2)
        end
    end
    SetStatus("Idle")
end
local function Func_AutoDailyDeal()
    SetStatus("Daily deal...")
    local ok, err = pcall(function()
        local result = Net.Sell.UseDailyDealAll()
        if result then notyuri("DailyDeal result:", tostring(result)) end
    end)
    if not ok then notyuri("AutoDailyDeal error:", err) end
    SetStatus("Idle")
end
local function RedeemCode(code)
    if not code or code == "" then return end
    local result = Net.Misc.SubmitCode(code)
    notyuri("RedeemCode:", code, "->", tostring(result))
end
local function DoBuy()
    local selectedSeeds = Options.SeedToBuyDropdown and Options.SeedToBuyDropdown.Value
    if not selectedSeeds then return end
    local seedsToBuy = {}
    if selectedSeeds["All"] then
        for _, name in ipairs(SeedNames) do seedsToBuy[name] = true end
    else
        seedsToBuy = selectedSeeds
    end
    local StockItems = RS.StockValues.SeedShop.Items
    local sheckles = ShecklesVal.Value
    for seedName, active in pairs(seedsToBuy) do
        if not active then continue end
        local item = StockItems:FindFirstChild(seedName)
        if item and item.Value and item.Value > 0 then
            local price = SeedPriceMap[seedName] or 0
            if sheckles < price then
                notyuri("Cannot afford:", seedName, "| costs", price, "| have", sheckles)
                continue
            end
            Net.Shop.PurchaseSeed(seedName)
            sheckles -= price
            notyuri("Purchased seed:", seedName, "| Stock remaining:", item.Value, "| Sheckles left:", sheckles)
        else
            notyuri("Seed not in stock:", seedName)
        end
    end
end
local function Func_AutoBuySeed()
    while Toggles.AutoBuySeed.Value do
        SetStatus("Buying seeds...")
        local ok, err = pcall(DoBuy)
        if not ok then notyuri("AutoBuySeed error:", err) end
        task.wait(0.1)
    end
    SetStatus("Idle")
end
local function DoCrate()
    local crateName = Options.CrateDropdown and Options.CrateDropdown.Value
    if not crateName or crateName == "" then return end
    local StockItems = RS.StockValues.CrateShop.Items
    local item = StockItems:FindFirstChild(crateName)
    if item and item.Value and item.Value > 0 then
        Net.Shop.PurchaseCrate(crateName)
        notyuri("Purchased crate:", crateName)
    else
        notyuri("Crate not in stock:", crateName)
    end
end
local function Func_AutoBuyCrate()
    while Toggles.AutoBuyCrate.Value do
        SetStatus("Buying crates...")
        local ok, err = pcall(DoCrate)
        if not ok then notyuri("AutoBuyCrate error:", err) end
        task.wait(3)
    end
    SetStatus("Idle")
end
local function DoGear()
    local gearName = Options.GearDropdown and Options.GearDropdown.Value
    if not gearName or gearName == "" then return end
    local StockItems = RS.StockValues.GearShop.Items
    local item = StockItems:FindFirstChild(gearName)
    if item and item.Value and item.Value > 0 then
        Net.Shop.PurchaseGear(gearName)
        notyuri("Purchased gear:", gearName)
    else
        notyuri("Gear not in stock:", gearName)
    end
end
local function Func_AutoBuyGear()
    while Toggles.AutoBuyGear.Value do
        SetStatus("Buying gear...")
        local ok, err = pcall(DoGear)
        if not ok then notyuri("AutoBuyGear error:", err) end
        task.wait(3)
    end
    SetStatus("Idle")
end
local function DoOpenCrates()
    local opened = 0
    for _, tool in ipairs(Plr.Backpack:GetChildren()) do
        local crateId = tool:IsA("Tool") and tool:GetAttribute("Crate")
        if crateId then
            local ok, result = pcall(Net.Open.Crate, crateId)
            if ok then
                notyuri("OpenCrate:", crateId, "->", tostring(result))
                opened += 1
            end
            task.wait(0.3)
        end
    end
end
local function OpenAllSeedPacksNow()
    local opened = 0
    for _, tool in ipairs(Plr.Backpack:GetChildren()) do
        local packId = tool:IsA("Tool") and tool:GetAttribute("SeedPack")
        if packId then
            local ok, result = pcall(Net.Open.SeedPack, packId)
            if ok and result then
                local seedName = type(result) == "table" and (result.SeedName or result[1]) or nil
                if seedName then
                    task.wait(0.2)
                    Net.Open.ConfirmSeedPack(packId, tostring(seedName), "")
                    notyuri("ConfirmSeedPack:", packId, seedName)
                end
                opened += 1
            end
            task.wait(0.5)
        end
    end
end
local function Func_AutoOpenCrates()
    while Toggles.AutoOpenCrates.Value do
        SetStatus("Opening crates...")
        local ok, err = pcall(DoOpenCrates)
        if not ok then notyuri("AutoOpenCrates error:", err) end
        task.wait(2)
    end
    SetStatus("Idle")
end
local function Func_AutoOpenSeedPacks()
    while Toggles.AutoOpenSeedPacks.Value do
        SetStatus("Opening seed packs...")
        local ok, err = pcall(OpenAllSeedPacksNow)
        if not ok then notyuri("AutoOpenSeedPacks error:", err) end
        task.wait(2)
    end
    SetStatus("Idle")
end
local function Func_AutoExpand()
    while Toggles.AutoExpand.Value do
        SetStatus("Expanding garden...")
        local ok, result = pcall(Net.Misc.ExpandGarden)
        if ok then notyuri("ExpandGarden:", tostring(result)) end
        task.wait(10)
    end
    SetStatus("Idle")
end
local function Func_AutoTamePets()
    while Toggles.AutoTamePets.Value do
        SetStatus("Taming pets...")
        local WildPetRef = workspace.Map:FindFirstChild("WildPetRef")
        if not WildPetRef then
            notyuri("AutoTamePets: WildPetRef not found")
            task.wait(1)
            continue
        end
        local children = WildPetRef:GetChildren()
        notyuri("AutoTamePets: WildPetRef children count:", #children)
        for _, refPart in children do
            if not Toggles.AutoTamePets.Value then break end
            if not refPart:IsA("BasePart") then
                notyuri("AutoTamePets: skipping non-BasePart child:", refPart.Name, refPart.ClassName)
                continue
            end
            local petName = refPart:GetAttribute("PetName") or ""
            local ownerUserId = refPart:GetAttribute("OwnerUserId")
            local state = refPart:GetAttribute("State")
            notyuri("AutoTamePets: found ref part:", refPart.Name, "| PetName:", petName, "| OwnerUserId:", tostring(ownerUserId), "| State:", tostring(state), "| Price:", tostring(refPart:GetAttribute("Price")), "| Rarity:", tostring(refPart:GetAttribute("Rarity")))
            local filterPet = Options.TamePetFilter and Options.TamePetFilter.Value or ""
            if filterPet ~= "" and petName ~= filterPet then
                notyuri("AutoTamePets: skip (filter mismatch) wanted:", filterPet, "got:", petName)
                continue
            end
            local maxPrice = tonumber(Options.TameMaxPriceValue and Options.TameMaxPriceValue.Value) or math.huge
            local cost = refPart:GetAttribute("Price") or 0
            if cost > maxPrice then
                notyuri("AutoTamePets: skip (price too high) cost:", cost, "maxPrice:", maxPrice)
                continue
            end
            if ownerUserId and ownerUserId ~= 0 then
                notyuri("AutoTamePets: WARNING ref part already has OwnerUserId:", ownerUserId, "(0 = unowned) — attempting tame anyway")
            end
            local char = Plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - refPart.Position).Magnitude
                notyuri("AutoTamePets: distance to refPart:", petName, "=", dist)
            else
                notyuri("AutoTamePets: no HumanoidRootPart found, cannot measure distance")
            end
            notyuri("Taming:", petName, "cost:", cost)
            local ok, err = pcall(Net.Pets.WildTame, refPart)
            if not ok then
                notyuri("WildTame error:", err)
            else
                notyuri("AutoTamePets: WildTame fired OK, watching OwnerUserId for confirmation...")
                local watchPart = refPart
                local watchedName = petName
                local confirmed = false
                local conn
                conn = watchPart:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
                    confirmed = true
                    notyuri("AutoTamePets: CONFIRMED — OwnerUserId changed to:", tostring(watchPart:GetAttribute("OwnerUserId")), "for", watchedName)
                    if conn then conn:Disconnect() end
                end)
                task.delay(2, function()
                    if not confirmed then
                        notyuri("AutoTamePets: NO CONFIRMATION after 2s — OwnerUserId still:", tostring(watchPart:GetAttribute("OwnerUserId")), "for", watchedName, "(server likely rejected or ignored the tame request)")
                    end
                    if conn then conn:Disconnect() end
                end)
            end
            task.wait(1)
        end
        task.wait(tonumber(Options.TameDelayValue and Options.TameDelayValue.Value) or 3)
    end
    SetStatus("Idle")
end
local function Func_AutoBuyPetSlots()
    while Toggles.AutoBuyPetSlots.Value do
        SetStatus("Buying pet slots...")
        local ok, err = pcall(Net.Pets.PurchaseSlot)
        if not ok then notyuri("BuyPetSlot error:", err) end
        task.wait(5)
    end
    SetStatus("Idle")
end
local function Func_AntiSteal()
    local conn = Networking.Steal.StealStarted.OnClientEvent:Connect(function(plantModel)
        if not Toggles.AntiSteal.Value then return end
        for _, plr in Players:GetPlayers() do
            if plr == Plr then continue end
            if plr:GetAttribute("IsStealingFruit") or plr:GetAttribute("CarryingStolenFruit") then
                local myPlot = GetMyPlot()
                if not myPlot then break end
                local char = GetCharacter()
                if char and plantModel and plantModel.Parent and plantModel.Parent:IsDescendantOf(myPlot) then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp and plantModel:IsA("Model") and plantModel.PrimaryPart then
                        hrp.CFrame = plantModel.PrimaryPart.CFrame * CFrame.new(0, 0, -2)
                    end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local shovel = Plr.Backpack:FindFirstChild("Shovel")
                    if hum and shovel then hum:EquipTool(shovel) end
                    notyuri("AntiSteal: thief detected:", plr.Name)
                end
                break
            end
        end
    end)
    Connections.AntiSteal = conn
    while Toggles.AntiSteal.Value do task.wait(1) end
    if Connections.AntiSteal then
        Connections.AntiSteal:Disconnect()
        Connections.AntiSteal = nil
    end
end
local function Func_NightSteal()
    local stealCount = 0
    while Toggles.NightSteal.Value do
        local Night = RS:FindFirstChild("Night")
        if not (Night and Night.Value == true) then
            task.wait(2); continue
        end
        local maxSteals = tonumber(Options.StealCountLimitValue and Options.StealCountLimitValue.Value) or math.huge
        if stealCount >= maxSteals then task.wait(2); continue end
        SetStatus("Night stealing...")
        local filterSeed = Options.StealSeedFilter and Options.StealSeedFilter.Value or "All"
        local filterMut  = Options.StealMutFilter and Options.StealMutFilter.Value or ""
        local minSize    = tonumber(Options.StealMinSizeValue and Options.StealMinSizeValue.Value) or 0
        local myPlot = GetMyPlot()
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local homeCFrame = hrp and hrp.CFrame
        if not homeCFrame then task.wait(1); continue end
        for _, plot in workspace.Gardens:GetChildren() do
            if not Toggles.NightSteal.Value then break end
            if myPlot and plot == myPlot then continue end
            local ownerUserId = plot:GetAttribute("OwnerUserId")
            local ownerPlr = ownerUserId and Players:GetPlayerByUserId(ownerUserId)
            if ownerPlr and ownerPlr:GetAttribute("IsInOwnGarden") == true then
                notyuri("NightSteal: skipping plot, owner home:", plot.Name)
                continue
            end
            local Plants = plot:FindFirstChild("Plants")
            if not Plants then continue end
            for _, plant in Plants:GetChildren() do
                if not Toggles.NightSteal.Value then break end
                local plantId = plant:GetAttribute("PlantId")
                local seedName = plant:GetAttribute("SeedName") or ""
                local FruitsFolder = plant:FindFirstChild("Fruits")
                if not plantId or not FruitsFolder then continue end
                if filterSeed ~= "" and filterSeed ~= "All" and seedName ~= filterSeed then continue end
                for _, fruit in FruitsFolder:GetChildren() do
                    if not Toggles.NightSteal.Value then break end
                    if stealCount >= maxSteals then break end
                    local fruitId = fruit:GetAttribute("FruitId")
                    local targetUserId = fruit:GetAttribute("UserId")
                    if not fruitId or not targetUserId then continue end
                    local mutation = fruit:GetAttribute("Mutation") or ""
                    local sizeMulti = fruit:GetAttribute("SizeMulti") or 1
                    if filterMut ~= "" and mutation ~= filterMut then continue end
                    if sizeMulti < minSize then continue end
                    local harvestPart = fruit:FindFirstChild("HarvestPart", true)
                    if not harvestPart then continue end
                    char = GetCharacter()
                    hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then break end
                    notyuri("Stealing:", targetUserId, plantId, fruitId)
                    hrp.CFrame = harvestPart.CFrame * CFrame.new(0, 0, -2)
                    task.wait(0.2)
                    Net.Steal.Begin(targetUserId, plantId, fruitId)
                    task.wait(1 / (tonumber(Options.StealSpeedValue and Options.StealSpeedValue.Value) or 1))
                    Net.Steal.Complete()
                    notyuri("Steal complete:", fruitId)
                    stealCount += 1
                    if hrp then hrp.CFrame = homeCFrame end
                    task.wait(1)
                end
            end
        end
        task.wait(2)
    end
    char = GetCharacter()
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    SetStatus("Idle")
end
local FruitSearchResults = {}
local function RunFruitSearch()
    FruitSearchResults = {}
    local filterSeed = Options.SearchSeedFilter and Options.SearchSeedFilter.Value or ""
    local filterMut  = Options.SearchMutFilter and Options.SearchMutFilter.Value or ""
    local minSize    = tonumber(Options.SearchMinSizeValue and Options.SearchMinSizeValue.Value) or 0
    local inclOwn    = Toggles.SearchIncludeOwn and Toggles.SearchIncludeOwn.Value
    for _, plot in workspace.Gardens:GetChildren() do
        local plotUserId = tonumber(plot.Name:match("Plot(%d+)"))
        if not plotUserId then continue end
        if not inclOwn and plotUserId == Plr.UserId then continue end
        local Plants = plot:FindFirstChild("Plants")
        if not Plants then continue end
        for _, plant in Plants:GetChildren() do
            local seedName = plant:GetAttribute("SeedName") or ""
            if filterSeed ~= "" and seedName ~= filterSeed then continue end
            local FruitsFolder = plant:FindFirstChild("Fruits")
            if not FruitsFolder then continue end
            for _, fruit in FruitsFolder:GetChildren() do
                local mutation = fruit:GetAttribute("Mutation") or ""
                local sizeMulti = fruit:GetAttribute("SizeMulti") or 1
                if filterMut ~= "" and mutation ~= filterMut then continue end
                if sizeMulti < minSize then continue end
                local value = GetFruitSellValue(seedName, sizeMulti, mutation)
                table.insert(FruitSearchResults, {
                    plot = plot.Name, seed = seedName,
                    mutation = mutation, size = sizeMulti, value = value,
                    fruitId = fruit:GetAttribute("FruitId"),
                })
            end
        end
    end
    table.sort(FruitSearchResults, function(a, b) return a.value > b.value end)
    local lines = {}
    for i = 1, math.min(5, #FruitSearchResults) do
        local r = FruitSearchResults[i]
        table.insert(lines, r.plot .. " | " .. r.seed .. " | " .. (r.mutation ~= "" and r.mutation .. " | " or "") .. Abbreviate(r.value))
    end
    local msg = #FruitSearchResults .. " found:\n" .. table.concat(lines, "\n")
    notyuri("FruitSearch:", #FruitSearchResults, "results")
end
local HighlightBillboards = {}
local function ClearFruitHighlights()
    for _, bb in pairs(HighlightBillboards) do
        if bb and bb.Parent then bb:Destroy() end
    end
    table.clear(HighlightBillboards)
end
local GardenStatsLabel = nil
local function FuncTPW()
    while true do
        local delta = RunService.Heartbeat:Wait()
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 and hum.MoveDirection.Magnitude > 0 then
            char:TranslateBy(hum.MoveDirection * tonumber(Options.TPWValue.Value) or 1 * delta * 10)
        end
    end
end
local function FuncNoclip()
    while Toggles.Noclip.Value do
        RunService.Stepped:Wait()
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end
end
local function Func_InfiniteJump()
    while Toggles.InfiniteJump.Value do
        RunService.Stepped:Wait()
        local char = GetCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = Options.JPValue and tonumber(Options.JPValue.Value) or 50 or 50 end
    end
end
local InfJumpConn = nil
local function SetupInfiniteJump(v)
    if v then
        if InfJumpConn then InfJumpConn:Disconnect() end
        InfJumpConn = UIS.JumpRequest:Connect(function()
            if not Toggles.InfiniteJump.Value then return end
            local char = GetCharacter()
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if InfJumpConn then InfJumpConn:Disconnect(); InfJumpConn = nil end
    end
end
local function Func_AntiKnockback()
    if type(Connections.Knockback) == "table" then
        for _, conn in pairs(Connections.Knockback) do if conn then conn:Disconnect() end end
        table.clear(Connections.Knockback)
    else Connections.Knockback = {} end
    local function ApplyAntiKB(character)
        if not character then return end
        local root = character:WaitForChild("HumanoidRootPart", 10)
        if root then
            local conn = root.ChildAdded:Connect(function(child)
                if not Toggles.AntiKnockback.Value then return end
                if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then child:Destroy() end
            end)
            table.insert(Connections.Knockback, conn)
        end
    end
    if Plr.Character then ApplyAntiKB(Plr.Character) end
    local conn = Plr.CharacterAdded:Connect(function(c) ApplyAntiKB(c) end)
    table.insert(Connections.Knockback, conn)
    repeat task.wait(1) until not Toggles.AntiKnockback.Value
    for _, c in pairs(Connections.Knockback) do if c then c:Disconnect() end end
    table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
    if Connections.Reconnect then Connections.Reconnect:Disconnect() end
    Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
        if not Toggles.AutoReconnect.Value then return end
        task.delay(2, function()
            pcall(function()
                local overlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if overlay then
                    local ep = overlay.promptOverlay:FindFirstChild("ErrorPrompt")
                    if ep and ep.Visible then task.wait(5); TeleportService:Teleport(game.PlaceId, Plr) end
                end
            end)
        end)
    end)
end
local function Func_NoGameplayPaused()
    while Toggles.NoGameplayPaused.Value do
        pcall(function()
            local p = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            if p then p:Destroy() end
        end)
        task.wait(1)
    end
end
local function ApplyFPSBoost(state)
    if not state then return end
    pcall(function()
        Lighting.GlobalShadows = false; Lighting.FogEnd = 9e9; Lighting.Brightness = 1
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then v.Enabled = false end
        end
        task.spawn(function()
            for i, v in pairs(workspace:GetDescendants()) do
                if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
                pcall(function()
                    if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.CastShadow = false
                    elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy()
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled = false end
                end)
                if i % 500 == 0 then task.wait() end
            end
        end)
    end)
end
local function RunAntiAFK()
    if getconnections then
        for _, v in pairs(getconnections(Players.LocalPlayer.Idled)) do
            if v["Disable"] then v:Disable() elseif v["Disconnect"] then v:Disconnect() end
        end
    else
        local VU = cloneref(game:GetService("VirtualUser"))
        Players.LocalPlayer.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    end
end
local function SetupWebhookEvents()
    notyuri("[WHSetup] SetupWebhookEvents called")
    local oldCount = 0
    for _, conn in pairs(Connections.Webhook) do
        pcall(function() conn:Disconnect() end)
        oldCount += 1
    end
    table.clear(Connections.Webhook)
    notyuri("[WHSetup] Disconnected", oldCount, "old webhook connections")
    local function wh(event, msg, toggleId)
        notyuri("[WHSetup] Registering WeatherEffects event:", event, "| toggleId:", toggleId)
        local remoteOk, remoteRef = pcall(function() return Networking.WeatherEffects[event] end)
        if not remoteOk or not remoteRef then
            notyuri("[WHSetup] ERROR: WeatherEffects." .. event .. " is nil or errored:", tostring(remoteRef))
            notyuri("[WHSetup] Missing remote: WeatherEffects." .. event)
            return
        end
        notyuri("[WHSetup] Remote WeatherEffects." .. event .. " found:", tostring(remoteRef))
        local ok, conn = pcall(function()
            return remoteRef.OnClientEvent:Connect(function(...)
                local args = {...}
                notyuri("[WH-EVENT] WeatherEffects." .. event .. " FIRED | args:", #args, "| toggle:", tostring(Toggles[toggleId] and Toggles[toggleId].Value))
                if not Toggles[toggleId] or not Toggles[toggleId].Value then
                    notyuri("[WH-EVENT] SKIPPED — toggle", toggleId, "is off")
                    return
                end
                notyuri("[WH-EVENT] Toggle ON — calling SendWebhook for:", event)
                SendWebhook(msg, GetPingId())
            end)
        end)
        if ok and conn then
            table.insert(Connections.Webhook, conn)
            notyuri("[WHSetup] Connected WeatherEffects." .. event .. " OK")
        else
            notyuri("[WHSetup] FAILED to connect WeatherEffects." .. event .. ":", tostring(conn))
            notyuri("[WHSetup] Connection failed for WeatherEffects." .. event, conn)
        end
    end
    wh("NightStart",     "Night started",         "WhNotifyDayNight")
    wh("NightEnd",       "Day started",           "WhNotifyDayNight")
    wh("BloodmoonStart", "Bloodmoon started",     "WhNotifyBloodmoon")
    wh("BlizzardStart",  "Blizzard started",      "WhNotifyBlizzard")
    wh("LightningStart", "Lightning storm started", "WhNotifyLightning")
    notyuri("[WHSetup] Registering WeatherEffects.GoldMoonStrike")
    local gmRemoteOk, gmRemote = pcall(function() return Networking.WeatherEffects.GoldMoonStrike end)
    if not gmRemoteOk or not gmRemote then
        notyuri("[WHSetup] ERROR: WeatherEffects.GoldMoonStrike missing:", tostring(gmRemote))
        notyuri("[WHSetup] Missing remote: WeatherEffects.GoldMoonStrike")
    else
        notyuri("[WHSetup] GoldMoonStrike remote found:", tostring(gmRemote))
        local ok, gmConn = pcall(function()
            return gmRemote.OnClientEvent:Connect(function(...)
                notyuri("[WH-EVENT] GoldMoonStrike FIRED | toggle:", tostring(Toggles.WhNotifyGoldMoon and Toggles.WhNotifyGoldMoon.Value))
                if not Toggles.WhNotifyGoldMoon or not Toggles.WhNotifyGoldMoon.Value then
                    notyuri("[WH-EVENT] SKIPPED — WhNotifyGoldMoon is off")
                    return
                end
                notyuri("[WH-EVENT] Sending GoldMoon webhook")
                SendWebhook("🌕 Gold Moon Strike!", GetPingId())
            end)
        end)
        if ok and gmConn then
            table.insert(Connections.Webhook, gmConn)
            notyuri("[WHSetup] Connected GoldMoonStrike OK")
        else
            notyuri("[WHSetup] FAILED GoldMoonStrike connect:", tostring(gmConn))
            notyuri("[WHSetup] GoldMoonStrike connection failed:", gmConn)
        end
    end
    notyuri("[WHSetup] Registering WeatherEffects.RainbowMoonStrike")
    local rmRemoteOk, rmRemote = pcall(function() return Networking.WeatherEffects.RainbowMoonStrike end)
    if not rmRemoteOk or not rmRemote then
        notyuri("[WHSetup] ERROR: WeatherEffects.RainbowMoonStrike missing:", tostring(rmRemote))
        notyuri("[WHSetup] Missing remote: WeatherEffects.RainbowMoonStrike")
    else
        notyuri("[WHSetup] RainbowMoonStrike remote found:", tostring(rmRemote))
        local ok2, rmConn = pcall(function()
            return rmRemote.OnClientEvent:Connect(function(...)
                notyuri("[WH-EVENT] RainbowMoonStrike FIRED | toggle:", tostring(Toggles.WhNotifyRainbowMoon and Toggles.WhNotifyRainbowMoon.Value))
                if not Toggles.WhNotifyRainbowMoon or not Toggles.WhNotifyRainbowMoon.Value then
                    notyuri("[WH-EVENT] SKIPPED — WhNotifyRainbowMoon is off")
                    return
                end
                notyuri("[WH-EVENT] Sending RainbowMoon webhook")
                SendWebhook("🌈 Rainbow Moon Strike!", GetPingId())
            end)
        end)
        if ok2 and rmConn then
            table.insert(Connections.Webhook, rmConn)
            notyuri("[WHSetup] Connected RainbowMoonStrike OK")
        else
            notyuri("[WHSetup] FAILED RainbowMoonStrike connect:", tostring(rmConn))
            notyuri("[WHSetup] RainbowMoonStrike connection failed:", rmConn)
        end
    end
    local RestockShop = {
        { RS.StockValues.SeedShop,  "Seed shop restocked",  "WhRestockSeed",  "SeedShop (global)"  },
        { RS.StockValues.CrateShop, "Crate shop restocked", "WhRestockCrate", "CrateShop (global)" },
        { RS.StockValues.GearShop,  "Gear shop restocked",  "WhRestockGear",  "GearShop (global)"  },
    }
    for _, s in ipairs(RestockShop) do
        local shopFolder, msg, toggleId, label = s[1], s[2], s[3], s[4]
        notyuri("[WHSetup] Registering global restock via UnixLastRestock:", label)
        local unixLastRestock = shopFolder and shopFolder:FindFirstChild("UnixLastRestock")
        if not unixLastRestock then
            notyuri("[WHSetup] ERROR: UnixLastRestock not found for", label)
        else
            notyuri("[WHSetup] UnixLastRestock found for", label, ":", tostring(unixLastRestock))
            local ok, conn = pcall(function()
                return unixLastRestock.Changed:Connect(function(newVal)
                    notyuri("[WH-EVENT] Global restock FIRED:", label, "| UnixLastRestock ->", newVal, "| toggle:", tostring(Toggles[toggleId] and Toggles[toggleId].Value))
                    if not Toggles[toggleId] or not Toggles[toggleId].Value then
                        notyuri("[WH-EVENT] SKIPPED — toggle", toggleId, "is off")
                        return
                    end
                    local itemsFolder = shopFolder:FindFirstChild("Items")
                    local lines = { msg }
                    if itemsFolder then
                        task.defer(function()
                            for _, item in ipairs(itemsFolder:GetChildren()) do
                                if item.Value and item.Value > 0 then
                                    lines[#lines + 1] = "• " .. item.Name .. " x" .. item.Value
                                end
                            end
                            notyuri("[WH-EVENT] Sending global restock webhook for:", label, "| items:", #lines - 1)
                            SendWebhook(table.concat(lines, "\n"), GetPingId())
                        end)
                    else
                        notyuri("[WH-EVENT] Sending global restock webhook for:", label, "(no Items folder)")
                        SendWebhook(msg, GetPingId())
                    end
                end)
            end)
            if ok and conn then
                table.insert(Connections.Webhook, conn)
                notyuri("[WHSetup] Connected global restock", label, "OK")
            else
                notyuri("[WHSetup] FAILED to connect global restock", label, ":", tostring(conn))
            end
        end
    end
    notyuri("[WHSetup] Done. Total webhook connections registered:", #Connections.Webhook)
end
local Window = Library:CreateWindow({
    Title = "Yuri",
    Center = true, AutoShow = true, Resizable = true,
    ShowCustomCursor = false, UnlockMouseWhileOpen = false,
    NotifySide = "Left", TabPadding = 8, MenuFadeTime = 0.2,
})
AddInfo(Window)
local Tabs = {
    Main    = Window:AddTab("Main"),
    Player  = Window:AddTab("Player"),
    Webhook = Window:AddTab("Webhook"),
    Config  = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left  = Tabs.Main:AddLeftTabbox(),
        Right = Tabs.Main:AddRightTabbox(),
    },
}
local T = {
    Farm  = TB.Main.Left:AddTab("Farm"),
    Misc2 = TB.Main.Left:AddTab("Misc"),
    Cfg   = TB.Main.Right:AddTab("Config"),
    Utils = TB.Main.Right:AddTab("Misc"),
}
T.Farm:AddToggle("AutoHarvest",          { Text = "Auto Harvest",             Default = false })
T.Farm:AddToggle("AutoPlant",            { Text = "Auto Plant",               Default = false })
T.Farm:AddToggle("AutoBuySeed",          { Text = "Auto Buy Seed",            Default = false })
T.Farm:AddToggle("AutoShovel",           { Text = "Auto Shovel",              Default = false })
T.Misc2:AddToggle("AutoCollectEventSeeds",{ Text = "Auto Event Seeds", Default = false })
T.Farm:AddToggle("AutoSell",             { Text = "Auto Sell",                Default = false })
Toggles.AutoHarvest:OnChanged(function(v)          Thread("GAG2.AutoHarvest", Func_AutoHarvest, v) end)
Toggles.AutoPlant:OnChanged(function(v)             Thread("GAG2.AutoPlant",   Func_AutoPlant,   v) end)
Toggles.AutoBuySeed:OnChanged(function(v)           Thread("GAG2.AutoBuySeed", Func_AutoBuySeed, v) end)
Toggles.AutoShovel:OnChanged(function(v)            Thread("GAG2.AutoShovel",  Func_AutoShovel,  v) end)
Toggles.AutoCollectEventSeeds:OnChanged(function(v) Thread("GAG2.EventSeeds",  Func_AutoCollectEventSeeds, v) end)
Toggles.AutoSell:OnChanged(function(v)              Thread("GAG2.AutoSell",    Func_AutoSell,    v) end)
T.Misc2:AddToggle("AutoBuyCrate",    { Text = "Auto Buy Crate",      Default = false })
T.Misc2:AddToggle("AutoBuyGear",     { Text = "Auto Buy Gear",        Default = false })
T.Misc2:AddToggle("AutoOpenCrates",  { Text = "Auto Open Crates",     Default = false })
T.Misc2:AddToggle("AutoOpenSeedPacks",{ Text = "Auto Open Seed Packs",Default = false })
T.Misc2:AddToggle("AutoExpand",      { Text = "Auto Expand Garden",   Default = false })
T.Misc2:AddToggle("AutoTamePets",    { Text = "Auto Tame Wild Pets",  Default = false })
T.Misc2:AddToggle("AutoBuyPetSlots", { Text = "Auto Buy Pet Slots",   Default = false })
T.Misc2:AddToggle("AntiSteal",       { Text = "Anti Steal(WIP)",           Default = false })
T.Misc2:AddToggle("NightSteal",      { Text = "Auto Night Steal(WIP)",     Default = false })
Toggles.AutoBuyCrate:OnChanged(function(v)    Thread("GAG2.AutoBuyCrate",    Func_AutoBuyCrate,    v) end)
Toggles.AutoBuyGear:OnChanged(function(v)     Thread("GAG2.AutoBuyGear",     Func_AutoBuyGear,     v) end)
Toggles.AutoOpenCrates:OnChanged(function(v)  Thread("GAG2.AutoOpenCrates",  Func_AutoOpenCrates,  v) end)
Toggles.AutoOpenSeedPacks:OnChanged(function(v) Thread("GAG2.AutoOpenSeedPacks", Func_AutoOpenSeedPacks, v) end)
Toggles.AutoExpand:OnChanged(function(v)      Thread("GAG2.AutoExpand",      Func_AutoExpand,      v) end)
Toggles.AutoTamePets:OnChanged(function(v)    Thread("GAG2.AutoTamePets",    Func_AutoTamePets,    v) end)
Toggles.AutoBuyPetSlots:OnChanged(function(v) Thread("GAG2.AutoBuyPetSlots", Func_AutoBuyPetSlots, v) end)
Toggles.AntiSteal:OnChanged(function(v)       Thread("GAG2.AntiSteal",       Func_AntiSteal,       v) end)
Toggles.NightSteal:OnChanged(function(v)      Thread("GAG2.NightSteal",      Func_NightSteal,      v) end)
T.Cfg:AddDropdown("HarvestSeedFilter", {
    Text = "Harvest Filter", Values = table.move(SeedNames, 1, #SeedNames, 1, {""}), Default = "", AllowNull = false, Searchable = true,
})
T.Cfg:AddToggle("HarvestSkipMutation", { Text = "Skip Mutated(Harvest)", Default = false })
T.Cfg:AddInput("HarvestMinSizeValue", { Text = "Min Size(Harvest)", Default = "0", Numeric = true, Finished = true })
T.Cfg:AddDivider()
T.Cfg:AddDropdown("SeedToPlantDropdown", {
    Text = "Seeds to Plant", Values = SeedNamesWithAll, Multi = true, AllowNull = true, Searchable = true,
})
T.Cfg:AddDropdown("SeedToBuyDropdown", {
    Text = "Seeds to Buy", Values = SeedNamesWithAll, Multi = true, AllowNull = true, Searchable = true,
})
T.Cfg:AddDivider()
T.Cfg:AddDropdown("ShovelSeedFilter", {
    Text = "Shovel Filter", Values = table.move(SeedNames, 1, #SeedNames, 1, {""}), Default = "", AllowNull = false, Searchable = true,
})
T.Cfg:AddDivider()
T.Cfg:AddDropdown("SellMode", {
    Text = "Mode", Values = { "Always", "Inventory Count" }, Default = "Always",
})
T.Cfg:AddInput("SellInvThresholdValue", { Text = "Inventory Count", Default = "20", Numeric = true, Finished = true })
T.Cfg:AddDivider()
T.Cfg:AddDropdown("CrateDropdown", {
    Text = "Crate to Buy", Values = CrateNames, Default = CrateNames[1] or "", AllowNull = false, Searchable = true,
})
T.Cfg:AddDropdown("GearDropdown", {
    Text = "Gear to Buy", Values = GearNames, Default = GearNames[1] or "", AllowNull = false, Searchable = true,
})
T.Cfg:AddDropdown("StockShopSelect", {
    Text = "Stock Shop", Values = { "Seed", "Crate", "Gear" }, Default = "Seed",
})
T.Cfg:AddDivider()
T.Cfg:AddInput("TameMaxPriceValue", { Text = "Max Price", Default = "10000", Numeric = true, Finished = true })
T.Cfg:AddInput("TamePetFilter", { Default = "", Numeric = false, Finished = false,
    Text = "Pet Name Filter" })
T.Cfg:AddInput("TameDelayValue", { Text = "Tame Delay", Default = "3", Numeric = true, Finished = true })
T.Cfg:AddDivider()
T.Cfg:AddDropdown("StealSeedFilter", {
    Text = "Steal Filter", Values = SeedNamesWithAll, Default = "All", AllowNull = false, Searchable = true,
})
T.Cfg:AddInput("StealMutFilter", { Default = "", Numeric = false, Finished = false,
    Text = "Steal Mutation Filter" })
T.Cfg:AddInput("StealMinSizeValue",    { Text = "Min Size",     Default = "0",   Numeric = true, Finished = true })
T.Cfg:AddInput("StealSpeedValue",      { Text = "Steal Speed",   Default = "1",   Numeric = true, Finished = true })
T.Cfg:AddInput("StealCountLimitValue", { Text = "Steal Count Limit", Default = "100", Numeric = true, Finished = true })
T.Utils:AddButton({ Text = "Redeem All Codes", Func = function()
    task.spawn(function()
        for _, code in ipairs(KnownCodes) do
            RedeemCode(code)
            task.wait(1)
        end
    end)
end })
T.Utils:AddToggle("FruitHL", { Text = "Fruit Highlighter", Default = false })
Toggles.FruitHL:OnChanged(function(v)
    if v then
        task.spawn(function()
            while Toggles.FruitHL.Value do
                ClearFruitHighlights()
                local filterSeed = Options.HLSeedFilter and Options.HLSeedFilter.Value or ""
                local filterMut  = Options.HLMutFilter and Options.HLMutFilter.Value or ""
                local minSize    = tonumber(Options.HLMinSizeValue and Options.HLMinSizeValue.Value) or 0
                local glowColor  = Options.HLGlowColor and Options.HLGlowColor.Value or Color3.fromRGB(255, 255, 0)
                for _, plot in workspace.Gardens:GetChildren() do
                    local Plants = plot:FindFirstChild("Plants")
                    if not Plants then continue end
                    for _, plant in Plants:GetChildren() do
                        local seedName = plant:GetAttribute("SeedName") or ""
                        if filterSeed ~= "" and seedName ~= filterSeed then continue end
                        local FruitsFolder = plant:FindFirstChild("Fruits")
                        if not FruitsFolder then continue end
                        for _, fruit in FruitsFolder:GetChildren() do
                            local mutation = fruit:GetAttribute("Mutation") or ""
                            local sizeMulti = fruit:GetAttribute("SizeMulti") or 1
                            if filterMut ~= "" and mutation ~= filterMut then continue end
                            if sizeMulti < minSize then continue end
                            local part = fruit:IsA("Model") and fruit.PrimaryPart or (fruit:IsA("BasePart") and fruit)
                            if not part then
                                for _, d in ipairs(fruit:GetDescendants()) do
                                    if d:IsA("BasePart") then part = d; break end
                                end
                            end
                            if part then
                                local highlight = Instance.new("SelectionBox")
                                highlight.Adornee = fruit
                                highlight.Color3 = glowColor
                                highlight.LineThickness = 0.05
                                highlight.SurfaceTransparency = 0.6
                                highlight.SurfaceColor3 = glowColor
                                highlight.Parent = part
                                table.insert(HighlightBillboards, highlight)
                            end
                        end
                    end
                end
                task.wait(2)
            end
            ClearFruitHighlights()
        end)
    else
        ClearFruitHighlights()
    end
end)
T.Utils:AddToggle("ShovelAura", { Text = "Shovel Aura", Default = false })
Toggles.ShovelAura:OnChanged(function(v)
    if v then
        task.spawn(function()
            while Toggles.ShovelAura.Value do
                local char = GetCharacter()
                local range = tonumber(Options.ShovelAuraRangeValue and Options.ShovelAuraRangeValue.Value) or 20
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local equipped = char:FindFirstChildWhichIsA("Tool")
                    local hasShovel = equipped and equipped:GetAttribute("Shovel") ~= nil
                    if hrp and hasShovel then
                        local nearest, nearDist = nil, math.huge
                        for _, plr in Players:GetPlayers() do
                            if plr == Plr then continue end
                            local c = plr.Character
                            local r = c and c:FindFirstChild("HumanoidRootPart")
                            if r then
                                local d = (r.Position - hrp.Position).Magnitude
                                if d < nearDist and d <= range then nearDist = d; nearest = r end
                            end
                        end
                        if nearest then
                            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(nearest.Position.X, hrp.Position.Y, nearest.Position.Z))
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
    else
    end
end)
T.Utils:AddInput("ShovelAuraRangeValue", { Text = "Aura Range", Default = "20", Numeric = true, Finished = true })
local GB = {
    Player = {
        Left  = {
            General = Tabs.Player:AddLeftGroupbox("General"),
            Server  = Tabs.Player:AddLeftGroupbox("Server"),
        },
        Right = { Game = Tabs.Player:AddRightGroupbox("Game") },
    }
}
AddInputToggle({ Group = GB.Player.Left.General, Id = "WS",       Text = "WalkSpeed",     Default = 16,  Min = 16,  Max = 250              })
local TPW_T, TPW_S = AddInputToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddInputToggle({ Group = GB.Player.Left.General, Id = "JP",       Text = "JumpPower",     Default = 50,  Min = 0,   Max = 500              })
AddInputToggle({ Group = GB.Player.Left.General, Id = "HH",       Text = "HipHeight",     Default = 2,   Min = 0,   Max = 10,  Rounding = 1 })
AddInputToggle({ Group = GB.Player.Left.General, Id = "Grav",     Text = "Gravity",       Default = 196, Min = 0,   Max = 500, Rounding = 1 })
AddInputToggle({ Group = GB.Player.Left.General, Id = "Zoom",     Text = "Camera Zoom",   Default = 128, Min = 128, Max = 10000            })
AddInputToggle({ Group = GB.Player.Left.General, Id = "FOV",      Text = "Field of View", Default = 70,  Min = 30,  Max = 120              })
local FPS_T, FPS_S = AddInputToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("InfiniteJump",    { Text = "Infinite Jump" })
GB.Player.Left.General:AddToggle("Noclip",          { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback",   { Text = "Anti Knockback", Default = false })
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
GB.Player.Left.General:AddToggle("FPSBoost",        { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK",          { Text = "Anti AFK",          Default = true, Disabled = not Support.Connections })
GB.Player.Left.Server:AddToggle("AntiKick",         { Text = "Anti Kick (Client)"                                                    })
GB.Player.Left.Server:AddToggle("AutoReconnect",    { Text = "Auto Reconnect"                                                        })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"                                                    })
GB.Player.Left.Server:AddButton({ Text = "Server Hop", Func = function() Net.Misc.RequestHop() end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin",     Func = function() TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Right.Game:AddToggle("InstantPP",    { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright",   { Text = "Fullbright"    })
GB.Player.Right.Game:AddToggle("NoFog",        { Text = "No Fog"        })
AddInputToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time of Day",
    Default = 12, Min = 0, Max = 24, Rounding = 1 })
Toggles.AntiKnockback:OnChanged(function(v) Thread("AntiKnockback", Func_AntiKnockback, v) end)
Toggles.TPW:OnChanged(function(v) TPW_S:SetVisible(TPW_T.Value); Thread("TPW", FuncTPW, v) end)
Toggles.Noclip:OnChanged(function(v) Thread("Noclip", FuncNoclip, v) end)
Toggles.InfiniteJump:OnChanged(function(v) SetupInfiniteJump(v) end)
Toggles.AutoReconnect:OnChanged(function(v) if v then Func_AutoReconnect() end end)
Toggles.NoGameplayPaused:OnChanged(function(v) Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), v) end)
Toggles.FPSBoost:OnChanged(function(v) ApplyFPSBoost(v) end)
Toggles.AntiAFK:OnChanged(function(v) if v then RunAntiAFK() end end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
Options.LimitFPSValue:OnChanged(function()
    if FPS_T.Value and setfpscap then setfpscap(tonumber(FPS_S.Value) or 60) end
end)
Toggles.LimitFPS:OnChanged(function(v)
    FPS_S:SetVisible(FPS_T.Value)
    if not v and setfpscap then setfpscap(999) end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Connections.Player_General = RunService.Stepped:Connect(function()
    local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if Hum then
        if Toggles.WS.Value then Hum.WalkSpeed = tonumber(Options.WSValue.Value) or 16 end
        if Toggles.JP.Value then Hum.JumpPower = tonumber(Options.JPValue.Value) or 50; Hum.UseJumpPower = true end
        if Toggles.HH.Value then Hum.HipHeight = tonumber(Options.HHValue.Value) or 2 end
    end
    workspace.Gravity = Toggles.Grav.Value and tonumber(Options.GravValue.Value) or 196 or 192
    if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = tonumber(Options.FOVValue.Value) or 70 end
    if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = tonumber(Options.ZoomValue.Value) or 128 end
end)
task.spawn(function()
    while task.wait() do
        if Toggles.Fullbright.Value then
            Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
        elseif Toggles.OverrideTime.Value then
            Lighting.ClockTime = tonumber(Options.OverrideTimeValue.Value) or 12
        end
        if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
        if Library.Unloaded then break end
    end
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP and Toggles.InstantPP.Value then prompt.HoldDuration = 0 end
end)
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not Toggles.AntiKick.Value then return oldNamecall(self, ...) end
        if getnamecallmethod() == "Kick" and self == Plr then return end
        return oldNamecall(self, ...)
    end)
end)
local WH_Left   = Tabs.Webhook:AddLeftGroupbox("Webhook Setup")
local WH_Events = Tabs.Webhook:AddLeftGroupbox("World Events")
local WH_Right  = Tabs.Webhook:AddRightGroupbox("Shop Restocks")
WH_Left:AddInput("WebhookURL",    { Default = "", Numeric = false, Finished = true,  Text = "Webhook URL"              })
WH_Left:AddInput("WebhookPingId", { Default = "", Numeric = false, Finished = false, Text = "Ping User ID"  })
WH_Left:AddButton({ Text = "Send Test Message", Func = function()
    SendWebhook("Yuri", GetPingId())
end })
WH_Events:AddToggle("WhNotifyDayNight",   { Text = "Day/Night Cycle Notifier",  Default = false })
WH_Events:AddToggle("WhNotifyBloodmoon",  { Text = "Bloodmoon Notifier",         Default = false })
WH_Events:AddToggle("WhNotifyGoldMoon",   { Text = "Gold Moon Notifier",         Default = false })
WH_Events:AddToggle("WhNotifyRainbowMoon",{ Text = "Rainbow Moon Notifier",      Default = false })
WH_Events:AddToggle("WhNotifyBlizzard",   { Text = "Blizzard Notifier",          Default = false })
WH_Events:AddToggle("WhNotifyLightning",  { Text = "Lightning Storm Notifier",   Default = false })
WH_Right:AddToggle("WhRestockSeed",  { Text = "Seed Shop Restock",  Default = false })
WH_Right:AddToggle("WhRestockCrate", { Text = "Crate Shop Restock", Default = false })
WH_Right:AddToggle("WhRestockGear",  { Text = "Gear Shop Restock",  Default = false })
SetupWebhookEvents()
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI",       { Text = "Auto Show UI", Default = true })
MenuGroup:AddToggle("KeybindMenuOpen",  { Default = Library.KeybindFrame.Visible, Text = "Open Keybind Menu",
    Callback = function(v) Library.KeybindFrame.Visible = v end })
MenuGroup:AddToggle("ShowCustomCursor", { Text = "Custom Cursor", Default = false,
    Callback = function(v) Library.ShowCustomCursor = v end })
MenuGroup:AddDropdown("NotificationSide", { Values = { "Left", "Right" }, Default = "Right", Text = "Notification Side",
    Callback = function(v) Library:SetNotifySide(v) end })
MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%", Text = "DPI Scale",
    Callback = function(v) Library:SetDPIScale(tonumber(v:gsub("%%", ""))) end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
    getgenv().ayasemiyatongekissazumirisa = false
    if InfJumpConn then InfJumpConn:Disconnect() end
    Cleanup(Connections); Cleanup(Flags)
    ClearFruitHighlights()
    Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/GrowAGarden2")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then Library:SetDPIScale(100) end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
notyuri("Script loaded OK")
end)
if not eh_ok then Library:Notify("LOAD ERROR: " .. tostring(eh_err), 8); notyuri("GAG2 error:", eh_err) end
