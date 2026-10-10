if script_key == nil or script_key ~= "Yuri(Heart)" then
    game:GetService("Players").LocalPlayer:Kick("Lesbian")
    return
end
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui.Fullscreen.Loading_Screen.Visible
function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
cloneref       = missing("function", cloneref,    function(...) return ... end)
getgc          = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
    __index = function(self, name)
        local ok, cache = pcall(function() return cloneref(game:GetService(name)) end)
        if ok then rawset(self, name, cache) return cache
        else error("Invalid Service: " .. tostring(name)) end
    end
})
local Players         = Services.Players
local Plr             = Players.LocalPlayer
local PGui            = Plr:WaitForChild("PlayerGui")
local RS              = Services.ReplicatedStorage
local HttpService     = Services.HttpService
local GuiService      = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace     = Services.MarketplaceService
local UIS             = Services.UserInputService
local VIM             = Services.VirtualInputManager
local RunService      = Services.RunService
local Lighting        = Services.Lighting
local CS              = Services.CollectionService
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local executorName        = executorDisplayName:lower()
local isLimitedExecutor   = executorName:find("xeno") ~= nil
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
getgenv().yuriStart = true
for _, c in pairs(getconnections(game:GetService("LogService").MessageOut)) do
    c:Disconnect()
end
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor          = true
Library.NotifySide                = "Left"
local Window = Library:CreateWindow({
    Title                = "yuri",
    Center               = true,
    AutoShow             = true,
    Resizable            = true,
    ShowCustomCursor     = false,
    UnlockMouseWhileOpen = false,
    NotifySide           = "Left",
    TabPadding           = 8,
    MenuFadeTime         = 0.2,
})
local Tabs = {
    Info    = Window:AddTab("Info"),
    Title   = Window:AddTab("Title Screen"),
    Lobby   = Window:AddTab("Lobby"),
    Combat  = Window:AddTab("Combat"),
    Webhook = Window:AddTab("Webhook"),
    Config  = Window:AddTab("Config"),
}
local Groups = {
    Info = {
        Left  = Tabs.Info:AddLeftGroupbox("Information"),
        Right = Tabs.Info:AddRightGroupbox("Others"),
        Perf  = Tabs.Info:AddRightGroupbox("Performance"),
    },
    Title = {
        Charac = Tabs.Title:AddLeftGroupbox("Character Customisation"),
    },
    Lobby = {
        Auto       = Tabs.Lobby:AddLeftGroupbox("Auto Queue"),
        Notice     = Tabs.Lobby:AddRightGroupbox("Lesbian"),
        Upgrade    = Tabs.Lobby:AddRightGroupbox("Upgrade"),
    },
    Combat = {
        Autofarm = Tabs.Combat:AddLeftGroupbox("Auto Farm"),
        Settings = Tabs.Combat:AddRightGroupbox("Settings"),
    },
    Webhook = {
        Config = Tabs.Webhook:AddLeftGroupbox("Config"),
    },
    Config = {
        Menu = Tabs.Config:AddLeftGroupbox("Menu"),
    },
}
local eh_success, err = pcall(function()
local Place = {
    Title = 13379208636,
    Lobby = 14916516914,
}
local spearQuestChain = {
    { category = "ThunderSpear_Towers",         questTag = "Towers",                   map = "Outskirts", objective = "Escort", missionType = "Missions" },
    { category = "ThunderSpear_Escort",         questTag = "Escort",                   map = "Outskirts", objective = "Escort", missionType = "Missions" },
    { category = "ThunderSpear_Supplies",       questTag = "Retrieve Missing Supplies", map = "Forest",   objective = "Guard",  missionType = "Missions" },
    { category = "ThunderSpear_DefendSupplies", questTag = "Defend Missing Supplies",   map = "Forest",   objective = "Guard",  missionType = "Missions" },
    { category = "ThunderSpear_IceBurst",       questTag = "Ice Burst Stones",          map = "Utgard",   objective = "Defend", missionType = "Missions" },
}
local function GetSessionTime()
end
local function GetSafeModule(parent, name)
    if not parent then return nil end
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local ok, result = pcall(require, obj)
        if ok then return result end
    end
    return nil
end
local function SafeClick(obj, timeout)
    timeout = timeout or 8
    local deadline = tick() + timeout
    while tick() < deadline do
        if obj and obj.Parent then
            local ready = true
            if obj:IsA("GuiObject") and not obj.Visible then ready = false end
            if ready and obj:IsA("GuiButton") and not obj.Active then ready = false end
            if ready then
                local p = obj.Parent
                while p and p:IsA("GuiObject") do
                    if not p.Visible then ready = false break end
                    p = p.Parent
                end
            end
            if ready then break end
        end
        task.wait(0.05)
    end
    if tick() >= deadline then return false end
    local ok = pcall(function() GuiService.SelectedObject = obj end)
    if not ok or GuiService.SelectedObject ~= obj then return false end
    task.wait(0.08)
    VIM:SendKeyEvent(true,  Enum.KeyCode.Return, false, game)
    task.wait(0.08)
    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    task.wait(0.08)
    pcall(function() GuiService.SelectedObject = nil end)
    return true
end
local StorageModules = RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Storage")
local Modules = {
    Families   = GetSafeModule(StorageModules, "Families"),
    Objectives = GetSafeModule(StorageModules, "Objectives"),
    Values     = GetSafeModule(StorageModules, "Values"),
    Modifiers  = GetSafeModule(StorageModules, "Modifiers"),
    Crates     = GetSafeModule(StorageModules, "Crates"),
    Items      = GetSafeModule(StorageModules, "Items"),
    Quest      = GetSafeModule(StorageModules, "Quest"),
    Skills     = GetSafeModule(StorageModules, "Skills"),
    Perks      = GetSafeModule(StorageModules, "Perks"),
}
local Remotes = RS:WaitForChild("Assets"):WaitForChild("Remotes")
local POST    = Remotes:WaitForChild("POST")
local GET     = Remotes:WaitForChild("GET")
local nc
nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args   = { ... }
    local method = getnamecallmethod()
    if method == "FireServer" and self == POST then
        if args[1] == "Functions" and args[2] == "Detect" then
            return
        end
    end
    return nc(self, unpack(args))
end))
local Char = Plr.Character or Plr.CharacterAdded:Wait()
Plr.CharacterAdded:Connect(function(c) Char = c end)
local function getChar() return Plr.Character or Char end
local Shared = {
    CannonFiring        = false,
    currentNape         = nil,
    originalNapeSize    = nil,
    hitVisual           = nil,
    bodyPos             = nil,
    families            = {},
    rarities            = {},
    modifiers           = {},
    FailsafeTriggered   = false,
    FarmStartDelay      = 0,
    LastTitanDelay      = 0,
    GamesPlayed         = 0,
    LastTitanWaiting    = false,
    lastTitanWaitStart  = nil,
    CachedShadowBan     = false,
    SnapLevel           = 0,
    SnapGold            = 0,
    SnapGems            = 0,
    AutoLobbyEnabled    = false,  
    currentSpearQuestIdx = 1,
    SkillTreeDone       = false,
    SpearEquipDone      = false,
}
local Flags = {}
local function Thread(featurePath, featureFunc, isEnabled, ...)
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
        if activeThread and typeof(activeThread) == "thread" then
            task.cancel(activeThread)
            currentTable[flagKey] = nil
        end
    end
end
if Modules.Families then
    local seen = {}
    for rarityName, rarityTable in pairs(Modules.Families) do
        if type(rarityName) == "string" then
            table.insert(Shared.rarities, rarityName)
        end
        if type(rarityTable) == "table" then
            for familyName in pairs(rarityTable) do
                if type(familyName) == "string" and not seen[familyName] then
                    seen[familyName] = true
                    table.insert(Shared.families, familyName)
                end
            end
        end
    end
    table.sort(Shared.families, function(a, b)
        if a == "Any" then return true end
        if b == "Any" then return false end
        return a < b
    end)
end
if Modules.Modifiers then
    local function collectTags(tbl)
        for _, entry in pairs(tbl) do
            if type(entry) == "table" then
                if type(entry.Tag) == "string" then
                    table.insert(Shared.modifiers, entry.Tag)
                else
                    collectTags(entry)
                end
            end
        end
    end
    collectTags(Modules.Modifiers)
    table.sort(Shared.modifiers, function(a, b)
        if a == "None" then return true end
        if b == "None" then return false end
        return a < b
    end)
end
local function getMapsForType(t)
    local maps = {}
    if Modules.Objectives and Modules.Objectives[t] then
        for mapName in pairs(Modules.Objectives[t]) do table.insert(maps, mapName) end
        table.sort(maps)
    end
    return maps
end
local function getObjectivesForMap(t, mapName)
    if Modules.Objectives and Modules.Objectives[t] and Modules.Objectives[t][mapName] then
        return Modules.Objectives[t][mapName]
    end
    return { "Skirmish" }
end
local function getDifficultiesForType(t)
    local diffs = {}
    if Modules.Values and Modules.Values.Difficulty_Potential and Modules.Values.Difficulty_Potential[t] then
        for _, entry in ipairs(Modules.Values.Difficulty_Potential[t]) do
            table.insert(diffs, entry[1])
        end
    end
    if #diffs == 0 then diffs = { "Normal" } end
    return diffs
end
local function updateMapDropdown()
    local t    = Options.LobbyMissionType and Options.LobbyMissionType.Value or "Missions"
    local maps = getMapsForType(t)
    if #maps == 0 then return end
    Options.LobbyMap:SetValues(maps)
    Options.LobbyMap:SetValue(maps[1])
end
local function updateObjectiveDropdown()
    local t    = Options.LobbyMissionType and Options.LobbyMissionType.Value or "Missions"
    local map  = Options.LobbyMap and Options.LobbyMap.Value
    local objs = getObjectivesForMap(t, map)
    Options.LobbyObjective:SetValues(objs)
    Options.LobbyObjective:SetValue(objs[1])
end
local function updateDifficultyDropdown()
    local t     = Options.LobbyMissionType and Options.LobbyMissionType.Value or "Missions"
    local diffs = getDifficultiesForType(t)
    Options.LobbyDifficulty:SetValues(diffs)
    Options.LobbyDifficulty:SetValue(diffs[1])
end
local function isTitanAlive(titan)
    if not titan or not titan.Parent then return false end
    local hum = titan:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local hrp = titan:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.Anchored then return false end
    return true
end
local function isTitanVulnerable(titan)
    local state = titan:GetAttribute("State")
    if state == "Roar" then return false end
    return true
end
local function getAllTitans()
    local titans = workspace:FindFirstChild("Titans")
    if not titans then return {} end
    local alive = {}
    for _, titan in ipairs(titans:GetChildren()) do
        if isTitanAlive(titan) then table.insert(alive, titan) end
    end
    return alive
end
local function getNearestTitan()
    local titans = workspace:FindFirstChild("Titans")
    if not titans then return nil end
    local root = getChar():FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, titan in ipairs(titans:GetChildren()) do
        if isTitanAlive(titan) then
            local primary = titan.PrimaryPart or titan:FindFirstChild("HumanoidRootPart")
            if primary then
                local d = (root.Position - primary.Position).Magnitude
                if d < nearestDist then nearest = titan nearestDist = d end
            end
        end
    end
    return nearest
end
local function getNape(titan)
    local h   = titan:FindFirstChild("Hitboxes")
    local hit = h and h:FindFirstChild("Hit")
    return hit and hit:FindFirstChild("Nape")
end
local function SetsRemain()
    local interface = PGui:FindFirstChild("Interface")
    if not interface then return nil end
    local hud = interface:FindFirstChild("HUD")
    if not hud then return nil end
    local top = hud:FindFirstChild("Main") and hud.Main:FindFirstChild("Top")
    if not top then return nil end
    local slot7 = top:FindFirstChild("7")
    if not slot7 then return nil end
    local setsLabel = slot7:FindFirstChild("Blades") and slot7.Blades:FindFirstChild("Sets")
    if not setsLabel then return nil end
    local current = setsLabel.Text:match("^(%d+)%s*/")
    return tonumber(current)
end
local function BrokeSwords()
    local charsFolder = workspace:FindFirstChild("Characters")
    if not charsFolder then return 0 end
    local charModel = charsFolder:FindFirstChild(Plr.Name)
    if not charModel then return 0 end
    local rig = charModel:FindFirstChild("Rig_" .. Plr.Name)
    if not rig then return 0 end
    local leftHand = rig:FindFirstChild("LeftHand")
    if not leftHand then return 0 end
    local broken = 0
    for i = 1, 7 do
        local seg = leftHand:FindFirstChild("Blade_" .. i)
        if seg and seg:GetAttribute("Broken") == true then broken += 1 end
    end
    return broken
end
local function findRefillPart()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Refill" and obj:IsA("BasePart") then return obj end
    end
end
local function setBodyLock(y)
    local root = getChar():FindFirstChild("HumanoidRootPart")
    if not root then return end
    if Shared.bodyPos and Shared.bodyPos.Parent then
        Shared.bodyPos.Position = Vector3.new(root.Position.X, y, root.Position.Z)
        return
    end
    Shared.bodyPos          = Instance.new("BodyPosition")
    Shared.bodyPos.MaxForce = Vector3.new(0, math.huge, 0)
    Shared.bodyPos.P        = 1e5
    Shared.bodyPos.D        = 1e3
    Shared.bodyPos.Position = Vector3.new(root.Position.X, y, root.Position.Z)
    Shared.bodyPos.Parent   = root
end
local function clearBodyLock()
    if Shared.bodyPos then Shared.bodyPos:Destroy() Shared.bodyPos = nil end
end
local function tweenAboveTitan(titan)
    local root    = getChar():FindFirstChild("HumanoidRootPart")
    local primary = titan and (titan.PrimaryPart or titan:FindFirstChild("HumanoidRootPart"))
    if not root or not primary then return end
    local dist  = tonumber(Options.TweenDistance and Options.TweenDistance.Value) or 115
    local speed = tonumber(Options.TweenSpeed and Options.TweenSpeed.Value) or 50
    local function buildTarget()
        return CFrame.new(primary.Position.X, primary.Position.Y + dist, primary.Position.Z)
    end
    local targetPos = buildTarget()
    local tweenTime = math.max((root.Position - targetPos.Position).Magnitude / speed, 0.01)
    root.AssemblyLinearVelocity  = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    local startCF = root.CFrame
    local elapsed = 0
    local conn
    local done = false
    conn = RunService.Heartbeat:Connect(function(dt)
        if not isTitanAlive(titan) then
            local newTitan = getNearestTitan()
            if newTitan then
                titan   = newTitan
                primary = newTitan.PrimaryPart or newTitan:FindFirstChild("HumanoidRootPart")
                startCF = root.CFrame
                elapsed = 0
            else
                conn:Disconnect()
                done = true
                return
            end
        end
        targetPos = buildTarget()
        elapsed   = elapsed + dt
        tweenTime = math.max((startCF.Position - targetPos.Position).Magnitude / speed, 0.01)
        local alpha = math.clamp(elapsed / tweenTime, 0, 1)
        root.CFrame = startCF:Lerp(targetPos, alpha)
        if alpha >= 1 then
            conn:Disconnect()
            done = true
        end
    end)
    repeat task.wait() until done
end
local function moveHooksToNape(nape)
    local hooksFolder = workspace:FindFirstChild("Hooks")
    if not hooksFolder then return end
    for _, hookModel in ipairs(hooksFolder:GetChildren()) do
        local mainGroup = hookModel:FindFirstChild("Main")
        local bone      = mainGroup and mainGroup:FindFirstChild("Mainbone")
        local target    = bone or hookModel.PrimaryPart
        if target and target:IsA("BasePart") then target.CFrame = nape.CFrame end
    end
end
local function MatchFin()
    local interface = PGui:FindFirstChild("Interface")
    local rewards   = interface and interface:FindFirstChild("Rewards")
    return rewards and rewards.Visible and rewards or nil
end
local function hasExploiter()
    if Plr:GetAttribute("Exploiter") == true then return true end
    local char = Plr.Character
    if char and char:GetAttribute("Exploiter") == true then return true end
    return false
end
local function getLabelText()
    if game.PlaceId ~= Place.Lobby then return "Unknown" end
    if hasExploiter() then
        return '<font color="rgb(255,0,0)">You\'re cooked</font>'
    else
        return '<font color="rgb(0,255,0)">Safe</font>'
    end
end
local function getHitDist() return tonumber(Options.HitDistance and Options.HitDistance.Value) or 200 end
local function getFreeCannon()
    for _, cannon in ipairs(CS:GetTagged("Cannon")) do
        if cannon:GetAttribute("Player") == nil and cannon:GetAttribute("Firing") == nil and cannon:GetAttribute("Spawn") == nil then
            return cannon
        end
    end
end
local function getSpearName()
    local charsFolder = workspace:FindFirstChild("Characters")
    local charModel   = charsFolder and charsFolder:FindFirstChild(Plr.Name)
    local rig         = charModel and charModel:FindFirstChild("Rig_" .. Plr.Name)
    if not rig then return nil end
    for _, side in ipairs({"Left", "Right"}) do
        local arm          = rig:FindFirstChild(side .. "LowerArm")
        local spearsFolder = arm and arm:FindFirstChild("Spears")
        if spearsFolder then
            for _, spear in ipairs(spearsFolder:GetChildren()) do
                if spear:GetAttribute("Used") == nil then
                    return spear.Name
                end
            end
        end
    end
end
local function applyModifiers()
    local selected = Options.LobbyModifiers and Options.LobbyModifiers.Value or {}
    for tag, enabled in pairs(selected) do
        if enabled and tag ~= "None" then
            pcall(function() GET:InvokeServer("S_Missions", "Modify", tag) end)
            task.wait(0.2)
        end
    end
end
local function writeStatsFile()
    pcall(function()
        if not writefile then return end
        local data = {
            shadowBanned = Shared.CachedShadowBan,
            gamesPlayed  = Shared.GamesPlayed,
            level        = Shared.SnapLevel,
            gold         = Shared.SnapGold,
            gems         = Shared.SnapGems,
        }
        pcall(writefile, "yuri_stats.json", HttpService:JSONEncode(data))
    end)
end
local function loadPreviousStats()
    if not isfile or not isfile("yuri_stats.json") then return end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile("yuri_stats.json"))
    end)
    if not ok or type(data) ~= "table" then return end
    Shared.SnapLevel   = tonumber(data.level)       or Shared.SnapLevel
    Shared.SnapGold    = tonumber(data.gold)        or Shared.SnapGold
    Shared.SnapGems    = tonumber(data.gems)        or Shared.SnapGems
    Shared.GamesPlayed = tonumber(data.gamesPlayed) or 0
    if data.shadowBanned == true then Shared.CachedShadowBan = true end
end
loadPreviousStats()
local matchEndProcessed = false
local function onMatchEnd()
    pcall(function()
        if matchEndProcessed then return end
        matchEndProcessed = true
        Shared.GamesPlayed = Shared.GamesPlayed + 1
        writeStatsFile()
        task.spawn(function()
            while MatchFin() do task.wait(0.2) end
            matchEndProcessed = false
        end)
    end)
end
local function PostFamilyWebhook(familyName, rarityName)
    local url = Options.WebhookURL and Options.WebhookURL.Value or ""
    if url == "" or not url:find("discord.com/api/webhooks/") then return end
    local reqFunc = request or http_request or (syn and syn.request)
    if not reqFunc then return end
    local uid  = Options.WebhookUID and Options.WebhookUID.Value or ""
    local desc = rarityName and ("Rarity: **" .. rarityName .. "**\nFamily: **" .. familyName .. "**")
              or ("Family: **" .. familyName .. "**")
    local payload = {
        content    = (Toggles.WebhookPingUser and Toggles.WebhookPingUser.Value and uid ~= "") and ("<@" .. uid .. ">") or nil,
        username   = "Yuri",
        avatar_url = yuri[math.random(1, #yuri)],
        embeds     = {{
            title       = "🎲 Got Target Family!",
            description = desc,
            color       = math.random(0, 16777215),
            footer      = { text = "AOTR • " .. os.date("%x %X") },
        }},
    }
    pcall(function()
        reqFunc({
            Url     = url,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode(payload),
        })
    end)
end
local function PostMatchWebhook(matchDuration)
    local url = Options.WebhookURL and Options.WebhookURL.Value or ""
    if url == "" or not url:find("discord.com/api/webhooks/") then
        Library:Notify("Webhook: Invalid URL", 3)
        return
    end
    local Interface = Plr.PlayerGui:FindFirstChild("Interface")
    if not Interface then Library:Notify("Webhook: Interface not found", 3) return end
    local RewardsGui = Interface:FindFirstChild("Rewards")
    if not RewardsGui then Library:Notify("Webhook: Rewards not found", 3) return end
    local function walkPath(root, ...)
        local cur = root
        for _, name in ipairs({...}) do
            if not cur then return nil end
            cur = cur:FindFirstChild(name)
        end
        return cur
    end
    local snapLevel, snapGold, snapGems = Shared.SnapLevel, Shared.SnapGold, Shared.SnapGems
    if isfile and isfile("yuri_snap.json") then
        local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile("yuri_snap.json")) end)
        if ok and decoded then
            snapLevel = decoded.level or snapLevel
            snapGold  = decoded.gold  or snapGold
            snapGems  = decoded.gems  or snapGems
        end
    end
    local curLevel = tonumber(Plr:GetAttribute("Level")) or snapLevel
    local curGold, curGems = snapGold, snapGems
    local topbarRead = false
    local Currencies = Interface:FindFirstChild("Topbar")
        and Interface.Topbar:FindFirstChild("Main")
        and Interface.Topbar.Main:FindFirstChild("Currencies")
    if Currencies then
        local goldLabel = Currencies:FindFirstChild("Gold") and Currencies.Gold:FindFirstChild("Amount")
        local gemsLabel = Currencies:FindFirstChild("Gems") and Currencies.Gems:FindFirstChild("Amount")
        if goldLabel then curGold = tonumber((goldLabel.Text:gsub(",", ""))) or snapGold topbarRead = true end
        if gemsLabel then curGems = tonumber((gemsLabel.Text:gsub(",", ""))) or snapGems topbarRead = true end
    end
    local imageToName = {}
    if Modules.Items then
        for itemKey, itemData in pairs(Modules.Items) do
            if type(itemData) == "table" and itemData.Image then
                imageToName[tostring(itemData.Image)] = itemKey:gsub("_", " ")
            end
        end
    end
    local itemsContainer = walkPath(RewardsGui, "Main", "Info", "Main", "Items")
    local allItems = {}
    if itemsContainer then
        for _, slot in ipairs(itemsContainer:GetChildren()) do
            if not slot:IsA("Frame") then continue end
            local inner = slot:FindFirstChild("Main") and slot.Main:FindFirstChild("Inner")
            if not inner then continue end
            local icon = inner:FindFirstChild("Icon")
            local qty  = inner:FindFirstChild("Quantity")
            if not icon or not icon.Image or icon.Image == "" then continue end
            local assetId = icon.Image:match("(%d+)")
            if assetId then
                table.insert(allItems, {
                    assetId  = assetId,
                    quantity = (qty and qty.Text ~= "" and qty.Text) or "1",
                    name     = imageToName[assetId] or assetId,
                    special  = slot.Name:sub(1, 1) == "3",
                })
            end
        end
    end
    if not topbarRead then
        for _, v in ipairs(allItems) do
            local n = v.name:lower()
            local q = tonumber((v.quantity:gsub(",", ""))) or 0
            if n == "gold" then curGold = snapGold + q
            elseif n == "gems" then curGems = snapGems + q
            end
        end
    end
    local function getStatText(...)
        local obj = walkPath(RewardsGui, ...)
        return obj and obj.Text or "?"
    end
    local killsStr  = getStatText("Main", "Info", "Main", "Stats", "Kills",      "Amount")
    local critsStr  = getStatText("Main", "Info", "Main", "Stats", "Crits",      "Amount")
    local damageStr = getStatText("Main", "Info", "Main", "Stats", "Damage",     "Amount")
    local timeStr   = getStatText("Main", "Info", "Main", "Stats", "Time_Taken", "Amount")
    if timeStr == "?" then
        timeStr = matchDuration and string.format("%dm %02ds", math.floor(matchDuration/60), math.floor(matchDuration%60)) or "?"
    end
    local regularItems, specialItems = {}, {}
    for _, v in ipairs(allItems) do
        if v.special then table.insert(specialItems, v)
        else table.insert(regularItems, v) end
    end
    if #specialItems == 0 and #regularItems > 1 then
        specialItems = { table.remove(regularItems) }
    end
    local uid  = Options.WebhookUID and Options.WebhookUID.Value or ""
    local ping = (Toggles.WebhookPingUser and Toggles.WebhookPingUser.Value and uid ~= "") and ("<@" .. uid .. "> ") or ""
    local lines = {}
    table.insert(lines, ping .. "**Information**")
    table.insert(lines, "User: " .. Plr.Name)
    table.insert(lines, "Shadow Banned: " .. tostring(Shared.CachedShadowBan))
    table.insert(lines, "Executor: " .. executorDisplayName)
    table.insert(lines, "Games Played: " .. tostring(Shared.GamesPlayed))
    local lvlDiff  = curLevel - snapLevel
    local goldDiff = curGold  - snapGold
    local gemsDiff = curGems  - snapGems
    table.insert(lines, "")
    table.insert(lines, "**Total Stats**")
    local lvlStr  = lvlDiff  > 0 and (snapLevel .. "(+" .. lvlDiff  .. ")") or tostring(curLevel)
    local goldStr = goldDiff > 0 and (snapGold  .. "(+" .. goldDiff .. ")") or tostring(curGold)
    local gemsStr = gemsDiff > 0 and (snapGems  .. "(+" .. gemsDiff .. ")") or tostring(curGems)
    table.insert(lines, "Level: " .. lvlStr)
    table.insert(lines, "Gold: "  .. goldStr)
    table.insert(lines, "Gems: "  .. gemsStr)
    table.insert(lines, "")
    table.insert(lines, "**Combat**")
    table.insert(lines, "Kills: " .. killsStr)
    table.insert(lines, "Time Taken: " .. timeStr)
    table.insert(lines, "Crits: " .. critsStr)
    table.insert(lines, "Damage: " .. damageStr)
    if #regularItems > 0 then
        table.insert(lines, "")
        table.insert(lines, "**Rewards**")
        for _, v in ipairs(regularItems) do
            table.insert(lines, v.name .. " (+" .. v.quantity .. ")")
        end
    end
    if #specialItems > 0 then
        table.insert(lines, "")
        table.insert(lines, "**Special**")
        for _, v in ipairs(specialItems) do
            table.insert(lines, v.name .. " (+" .. v.quantity .. ")")
        end
    end
    Shared.SnapLevel = curLevel
    Shared.SnapGold  = curGold
    Shared.SnapGems  = curGems
    local thumbnailUrl = yuri[math.random(1, #yuri)]
    local payload = {
        username   = "Yuri",
        avatar_url = yuri[math.random(1, #yuri)],
        embeds = {{
            description = table.concat(lines, "\n"),
            color       = math.random(0, 16777215),
            thumbnail   = { url = thumbnailUrl },
            footer      = { text = "AOTR • " .. os.date("%x %X") },
        }},
    }
    local reqFunc = request or http_request or (syn and syn.request)
    if not reqFunc then Library:Notify("Webhook: No request function", 3) return end
    task.spawn(function()
        local ok, res = pcall(function()
            return reqFunc({
                Url     = url,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = HttpService:JSONEncode(payload),
            })
        end)
        if ok and res and (res.StatusCode == 200 or res.StatusCode == 204) then
            Library:Notify("Webhook sent (" .. #allItems .. " items)", 3)
        elseif ok and res then
            Library:Notify("Webhook failed: HTTP " .. tostring(res.StatusCode), 5)
        else
            Library:Notify("Webhook failed: " .. tostring(res), 5)
        end
    end)
end
local function ApplyFPSBoost(state)
    if not state then return end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd        = 9e9
        Lighting.Brightness    = 1
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
                        v.Material  = Enum.Material.SmoothPlastic
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
local function Func_AutoFarm()
    local startTick = tick()
    while true do
        local mode     = Options.FarmMode and Options.FarmMode.Value or "Nearest"
        local hitCount = tonumber(Options.HitCount and Options.HitCount.Value) or 1
        if mode == "Nearest" or mode == "Kill All" then
            local delay = tonumber(Options.FarmStartDelay and Options.FarmStartDelay.Value) or 0
            if (tick() - startTick) < delay then task.wait(0.1) continue end
        end
        if mode == "Kill All" or mode == "Batch" then
            local titans    = getAllTitans()
            local lastDelay = tonumber(Options.LastTitanDelay and Options.LastTitanDelay.Value) or 0
            if #titans == 1 and lastDelay > 0 then
                if not Shared.lastTitanWaitStart then Shared.lastTitanWaitStart = tick() end
                if (tick() - Shared.lastTitanWaitStart) < lastDelay then
                    Shared.LastTitanWaiting = true
                    task.wait(0.1) continue
                end
                Shared.LastTitanWaiting = false
            else
                Shared.lastTitanWaitStart = nil
                Shared.LastTitanWaiting   = false
            end
        end
        if mode == "Nearest" then
            pcall(function()
                local titan = getNearestTitan()
                if not titan then return end
                if not isTitanVulnerable(titan) then return end
                local nape = getNape(titan)
                if not nape then return end
                moveHooksToNape(nape)
                if not Shared.CannonFiring then tweenAboveTitan(titan) end
                local root = getChar():FindFirstChild("HumanoidRootPart")
                for i = 1, hitCount do
                    POST:FireServer("Attacks", "Slash", false)
                    POST:FireServer("Attacks", "Slash", true)
                    if root and (root.Position - nape.Position).Magnitude <= getHitDist() then
                        POST:FireServer("Hitboxes", "Register", nape, math.random(1000, 9999), math.random() * 0.5)
                    end
                end
            end)
        elseif mode == "Kill All" then
            pcall(function()
                local titans = getAllTitans()
                for i = 1, hitCount do
                    POST:FireServer("Attacks", "Slash", false)
                    POST:FireServer("Attacks", "Slash", true)
                    for _, titan in ipairs(titans) do
                        if not isTitanVulnerable(titan) then continue end
                        local nape = getNape(titan)
                        if nape then POST:FireServer("Hitboxes", "Register", nape, math.random(1000, 9999), math.random() * 0.5) end
                    end
                end
            end)
        elseif mode == "Batch" then
            pcall(function()
                local root = getChar():FindFirstChild("HumanoidRootPart")
                if not root then return end
                local dist   = getHitDist()
                local titans = getAllTitans()
                local nearest = getNearestTitan()
                if nearest then
                    local napeNearest = getNape(nearest)
                    if napeNearest then moveHooksToNape(napeNearest) end
                    if not Shared.CannonFiring then tweenAboveTitan(nearest) end
                end
                for i = 1, hitCount do
                    POST:FireServer("Attacks", "Slash", false)
                    POST:FireServer("Attacks", "Slash", true)
                    for _, titan in ipairs(titans) do
                        if not isTitanVulnerable(titan) then continue end
                        local nape = getNape(titan)
                        if nape and (root.Position - nape.Position).Magnitude <= dist then
                            POST:FireServer("Hitboxes", "Register", nape, math.random(1000, 9999), math.random() * 1)
                        end
                    end
                end
            end)
        end
        task.wait()
    end
end
local function Func_AutoRefill()
    while true do
        pcall(function()
            local sets = SetsRemain()
            if sets == nil then return end
            local threshold = tonumber(Options.RefillThreshold and Options.RefillThreshold.Value) or 0
            if sets <= threshold then
                local refillPart = findRefillPart()
                if refillPart then POST:FireServer("Attacks", "Reload", refillPart) end
            end
        end)
        task.wait()
    end
end
local function Func_AutoReload()
    while true do
        pcall(function()
            local threshold = tonumber(Options.ReloadThreshold and Options.ReloadThreshold.Value) or 7
            if BrokeSwords() >= threshold then
                for _ = 1, 5 do
                    GET:InvokeServer("Blades", "Reload")
                    task.wait(0.1)
                    if BrokeSwords() < threshold then break end
                end
            end
        end)
        task.wait()
    end
end
local function Func_AutoRetry()
    local rewardsSeen = false
    while true do
        task.wait(0.1)
        local ok, errMsg = pcall(function()
            local visible = MatchFin()
            if not visible then
                rewardsSeen = false
                return
            end
            if rewardsSeen then return end
            rewardsSeen = true
            onMatchEnd()
            task.wait(1)
            local retryDelay = (Options and Options.AutoRetryDelay and tonumber(Options.AutoRetryDelay.Value)) or 0
            if retryDelay > 0 then task.wait(retryDelay) end
            local returnAfter = tonumber(Options.ReturnAfterGames and Options.ReturnAfterGames.Value) or 0
            if Toggles.AutoReturnAfterGames and Toggles.AutoReturnAfterGames.Value and returnAfter > 0 and Shared.GamesPlayed >= returnAfter then
                Shared.GamesPlayed = 0
                Library:Notify("Returning to lobby after " .. returnAfter .. " games", 4)
                GET:InvokeServer("Functions", "Teleport", "Lobby", nil)
                return
            end
            local retryAttempt = 0
            while true do
                if not getgenv().yuriStart then return end
                retryAttempt += 1
                local ok2, result = pcall(function()
                    return GET:InvokeServer("Functions", "Retry", "Add")
                end)
                if ok2 and result then break
                else task.wait(0.5) end
            end
            if Shared.AutoLobbyEnabled then
                local leaveDelay = (Options and Options.AutoLeaveDelay and tonumber(Options.AutoLeaveDelay.Value)) or 0
                task.spawn(function()
                    if leaveDelay > 0 then task.wait(leaveDelay) end
                    if not Shared.AutoLobbyEnabled then return end
                    GET:InvokeServer("Functions", "Teleport", "Lobby", nil)
                end)
            end
        end)
        if not ok then
            rewardsSeen = false
        end
    end
end
local function Func_AutoCannon()
    while true do
        task.wait(2)
        pcall(function()
            local cannon = getFreeCannon()
            if not cannon then return end
            local ok = GET:InvokeServer("Cannon", "State", cannon, true, nil)
            if not ok then return end
            task.wait(0.3)
            Shared.CannonFiring = true
            GET:InvokeServer("Cannon", "Shoot", { Base = 0, BarrelWood = 0 })
            task.wait(1.5)
            Shared.CannonFiring = false
            GET:InvokeServer("Cannon", "State", cannon, false, { Angles = { Base = 0, BarrelWood = 0 } })
        end)
    end
end
local function Func_AutoSpear()
    while true do
        task.wait(1)
        pcall(function()
            local spearName = getSpearName()
            if not spearName then return end
            local ok = GET:InvokeServer("Spears", "S_Fire", spearName)
            if not ok then return end
            task.wait(0.5)
            local titan     = getNearestTitan()
            local primary   = titan and (titan.PrimaryPart or titan:FindFirstChild("HumanoidRootPart"))
            local targetPos = primary and primary.Position or getChar():FindFirstChild("HumanoidRootPart").Position
            POST:FireServer("Spears", "S_Explode", targetPos, 0)
            task.wait(0.3)
            POST:FireServer("Spears", "Reset", nil)
        end)
    end
end
local function Func_AutoDie()
    while true do
        task.wait(0.5)
        local streak    = tonumber(Plr:GetAttribute("Streak")) or 0
        local threshold = tonumber(Options.AutoDieStreak and Options.AutoDieStreak.Value) or 0
        if threshold <= 0 then continue end
        if streak >= threshold then
            local char = getChar()
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                hum.Health = 0
            end
        end
    end
end
local function Func_AutoSkipCutscene()
    while true do
        task.wait(0.2)
        pcall(function()
            local skip = PGui:FindFirstChild("Interface")
                and PGui.Interface:FindFirstChild("Skip")
            SafeClick(skip)
        end)
    end
end
local function Func_AutoQueue()
    while game.PlaceId == Place.Lobby do
        local missionType = Options.LobbyMissionType and Options.LobbyMissionType.Value or "Missions"
        local mapName     = Options.LobbyMap and Options.LobbyMap.Value
        local objective   = Options.LobbyObjective and Options.LobbyObjective.Value
        local difficulty  = Options.LobbyDifficulty and Options.LobbyDifficulty.Value
        local mapTable    = {
            Name       = mapName,
            Type       = missionType,
            Objective  = objective,
            Difficulty = difficulty,
            Minimum    = 1,
        }
        local ok, result = pcall(function()
            return GET:InvokeServer("S_Missions", "Create", mapTable)
        end)
        if not ok or result == nil then
            Library:Notify("AutoQueue: Create failed", 4)
            task.wait(5) continue
        end
        task.wait(0.3)
        applyModifiers()
        task.wait(0.2)
        pcall(function() GET:InvokeServer("S_Missions", "Start") end)
        task.wait(5)
    end
end
local function Func_AutoUpgradeAll()
    while true do
        task.wait(0.5)
        if game.PlaceId ~= Place.Lobby then continue end
        local ok, result = pcall(function()
            return GET:InvokeServer(
                "S_Equipment",
                "Upgrade",
                {
                    "Blade_Durability",
                    "ODM_Damage",
                    "ODM_Gas",
                    "ODM_Range",
                    "ODM_Control",
                    "Crit_Chance",
                    "Crit_Damage",
                    "ODM_Speed",
                    "Spear_Count",
                    "Spear_Speed",
                }
            )
        end)
        if ok and type(result) == "table" then
            local upgraded = {}
            for stat, v in pairs(result) do
                if v then table.insert(upgraded, stat) end
            end
            if #upgraded > 0 then
                Library:Notify("Upgraded: " .. table.concat(upgraded, ", "), 4)
            end
        end
    end
end
local function Func_AutoClaimAll()
    while true do
        task.wait()
        if game.PlaceId ~= Place.Lobby then task.wait(1) continue end
        if Modules.Quest then
            for categoryName, categoryData in pairs(Modules.Quest) do
                if type(categoryData) ~= "table" or type(categoryData.Quests) ~= "table" then continue end
                for _, questEntry in ipairs(categoryData.Quests) do
                    local tag = questEntry.Tag
                    if not tag then continue end
                    local ok, claimErr = pcall(function()
                        GET:InvokeServer("Functions", "Quest", tag, categoryName)
                    end)
                    if ok then
                    end
                    task.wait(0.1)
                end
            end
        end
        for i = 1, 100 do
            pcall(function() GET:InvokeServer("S_Achievements", "Claim", i) end)
            task.wait(0.05)
        end
        pcall(function() GET:InvokeServer("S_Achievements", "Category", nil) end)
        task.wait(5) 
    end
end
local function Func_AutoOpenChest()
    while true do
        task.wait(2)
        if game.PlaceId ~= Place.Lobby then continue end
        local selected = Options.LobbyChestType and Options.LobbyChestType.Value or {}
        for chestName, enabled in pairs(selected) do
            if not enabled then continue end
            local ok, result = pcall(function()
                return GET:InvokeServer("S_Inventory", "Crate", chestName)
            end)
            if ok and result then
                Library:Notify("Opened: " .. chestName, 2)
            end
            task.wait()
        end
    end
end
local function Func_AutoMaxSkill()
    Shared.SkillTreeDone = false
    while true do
        task.wait(2)
        if game.PlaceId ~= Place.Lobby then continue end
        if Shared.SkillTreeDone then continue end
        if not Modules.Skills then
            Shared.SkillTreeDone = true
            continue
        end
        local attempted, succeeded = 0, 0
        for skillId, skillData in pairs(Modules.Skills) do
            local idx = tonumber(skillId)
            if not idx then continue end
            attempted += 1
            local ok, result = pcall(function()
                return GET:InvokeServer("S_Equipment", "Skill_State", idx, skillId)
            end)
            if ok then succeeded += 1 end
            task.wait(0.15)
            if not getgenv().yuriStart then break end
        end
        Library:Notify("Skill Tree: " .. succeeded .. "/" .. attempted .. " nodes sent", 5)
        Shared.SkillTreeDone = true
    end
end
local function Func_AutoEnhancePerks()
    while true do
        task.wait(5)
        if game.PlaceId ~= Place.Lobby then continue end
        local Interface   = PGui:FindFirstChild("Interface")
        if not Interface then continue end
        local Enhancement = Interface:FindFirstChild("Equipment")
            and Interface.Equipment:FindFirstChild("Enhancement")
        if not Enhancement then
            continue
        end
        local perkIDs = {}
        for _, child in ipairs(Enhancement:GetDescendants()) do
            local id = child:GetAttribute("Item_ID")
            if id then
                table.insert(perkIDs, id)
            end
        end
        if #perkIDs < 2 then
            continue
        end
        local target    = perkIDs[1]
        local sacrifices = {}
        for i = 2, #perkIDs do table.insert(sacrifices, perkIDs[i]) end
        local ok, result = pcall(function()
            return GET:InvokeServer("S_Equipment", "Enhance", target, sacrifices)
        end)
        if ok and result ~= nil then
            Library:Notify("Auto Enhance: success", 3)
        else
            Library:Notify("Auto Enhance: failed (check console)", 4)
        end
        task.wait(10)
    end
end
local function Func_AutoPrestige()
    while true do
        task.wait(10)
        if game.PlaceId ~= Place.Lobby then continue end
        local level    = tonumber(Plr:GetAttribute("Level")) or 0
        local prestige = tonumber(Plr:GetAttribute("Prestige")) or 0
        local maxLevel = 75 + prestige * 25
        local minGold  = tonumber(Options.PrestigeMinGold and Options.PrestigeMinGold.Value) or 0
        if level < maxLevel then continue end
        if minGold > 0 and Shared.SnapGold < minGold then
            continue
        end
        local talentOk, v3, v4 = pcall(function()
            return GET:InvokeServer("S_Equipment", "Talents")
        end)
        local boostChoice  = Options.PrestigeBoost and Options.PrestigeBoost.Value or "Luck"
        local talentChoice = nil
        if talentOk and type(v4) == "table" and v4[1] then
            talentChoice = v4[1]
        end
        local selection = { Boosts = boostChoice, Talents = talentChoice }
        local pOk, pResult = pcall(function()
            return GET:InvokeServer("S_Equipment", "Prestige", selection)
        end)
        if pOk and pResult ~= nil then
            Library:Notify("Auto Prestige → " .. boostChoice .. "!", 6)
        else
            Library:Notify("[AutoPrestige] Failed - check console", 5)
        end
        task.wait(30)
    end
end
local function Func_AutoRollFamily()
    while true do
        task.wait(0.5)
        local selected = Options.TargetFamily and Options.TargetFamily.Value or {}
        local ok, _spins, newFamily = pcall(function() return GET:InvokeServer("Family", "Roll") end)
        if ok and newFamily and type(newFamily) == "string" then
            Library:Notify("Rolled: " .. newFamily, 2)
            if next(selected) ~= nil and selected[newFamily] then
                Toggles.AutoRollFamily:SetValue(false)
                Library:Notify("Got family: " .. newFamily, 5)
                if Toggles.WebhookFamilyPing and Toggles.WebhookFamilyPing.Value then
                    task.spawn(PostFamilyWebhook, newFamily, nil)
                end
            elseif Toggles.StopOnRarity.Value then
                local selectedRarities = Options.TargetRarity and Options.TargetRarity.Value or {}
                if next(selectedRarities) ~= nil then
                    for rarityName, rarityTable in pairs(Modules.Families) do
                        if selectedRarities[rarityName] and type(rarityTable) == "table" and rarityTable[newFamily] then
                            Toggles.AutoRollFamily:SetValue(false)
                            Library:Notify("Got " .. rarityName .. " family: " .. newFamily, 5)
                            if Toggles.WebhookFamilyPing and Toggles.WebhookFamilyPing.Value then
                                task.spawn(PostFamilyWebhook, newFamily, rarityName)
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end
local function Func_AutoSlotSelect()
    while true do
        task.wait(0.2)
        if game.PlaceId ~= Place.Title then continue end
        local interface   = PGui:FindFirstChild("Interface")
        local titleScreen = interface and interface:FindFirstChild("Title_Screen")
        if not titleScreen or not titleScreen.Visible then continue end
        local slots = titleScreen:FindFirstChild("Slots")
        if slots and slots.Visible then
            pcall(function()
                GET:InvokeServer("Functions", "Select", Options.SlotSelect.Value)
            end)
        end
    end
end
local function Func_AutoPlay()
    while true do
        task.wait(0.2)
        if game.PlaceId ~= Place.Title then continue end
        local interface   = PGui:FindFirstChild("Interface")
        local titleScreen = interface and interface:FindFirstChild("Title_Screen")
        if not titleScreen or not titleScreen.Visible then continue end
        local slots = titleScreen:FindFirstChild("Slots")
        if slots then
            local wd = tick()
            repeat task.wait(0.2) until not slots.Visible or (tick() - wd) > 10
        end
        task.wait(0.35)
        pcall(function()
            GET:InvokeServer("Functions", "Teleport", "Lobby", nil)
        end)
        local wd2 = tick()
        repeat task.wait(0.2)
        until not titleScreen.Parent or not titleScreen.Visible or (tick() - wd2) > 10
    end
end
task.spawn(function()
    if game.PlaceId ~= Place.Lobby then return end
    local Interface  = Plr.PlayerGui:WaitForChild("Interface", 60)
    if not Interface then return end
    local Topbar     = Interface:WaitForChild("Topbar", 60)
    if not Topbar then return end
    local Main       = Topbar:WaitForChild("Main", 60)
    if not Main then return end
    local Currencies = Main:WaitForChild("Currencies", 60)
    if not Currencies then return end
    task.wait(1)
    local level     = tonumber(Plr:GetAttribute("Level")) or 0
    local goldLabel = Currencies:FindFirstChild("Gold") and Currencies.Gold:FindFirstChild("Amount")
    local gemsLabel = Currencies:FindFirstChild("Gems") and Currencies.Gems:FindFirstChild("Amount")
    local gold      = goldLabel and tonumber((goldLabel.Text:gsub(",", ""))) or 0
    local gems      = gemsLabel and tonumber((gemsLabel.Text:gsub(",", ""))) or 0
    Shared.SnapLevel = level
    Shared.SnapGold  = gold
    Shared.SnapGems  = gems
    writeStatsFile()
end)
task.spawn(function()
    local Interface  = Plr.PlayerGui:WaitForChild("Interface", 60)
    if not Interface then return end
    local RewardsGui = Interface:WaitForChild("Rewards", 60)
    if not RewardsGui then return end
    local lastSent      = 0
    local matchStartTime = tick()
    local conn
    conn = RewardsGui:GetPropertyChangedSignal("Visible"):Connect(function()
        if not getgenv().yuriStart then conn:Disconnect() return end
        if not (Toggles.WebhookEnabled and Toggles.WebhookEnabled.Value) then return end
        if not RewardsGui.Visible then
            matchStartTime = tick()
            return
        end
        if (os.time() - lastSent) < 10 then return end
        task.wait()
        if not MatchFin() then return end
        onMatchEnd()
        PostMatchWebhook(tick() - matchStartTime)
        lastSent = os.time()
    end)
end)
if game.PlaceId == Place.Lobby or game.PlaceId == Place.Title then
    Shared.GamesPlayed = 0
    writeStatsFile()
end
local statusText = isLimitedExecutor
    and "<font color='#FFA500'>Semi-Working</font>"
    or  "<font color='#00FF00'>Working</font>"
local extraNote = isLimitedExecutor
    and "<b>NOTE:</b> May experience bugs for some features!"
    or  "All features should work properly!"
Groups.Info.Left:AddLabel(
    "<b>Executor:</b> " .. executorDisplayName ..
    "\n<b>Status:</b> " .. statusText ..
    "\n" .. extraNote, true
)
Groups.Info.Right:AddButton({
    Text = "Join Discord Server",
    Func = function()
        local inviteCode = "b6kxdDtqd"
        local inviteLink = "https://discord.gg/" .. inviteCode
        local ok = false
        if request then
            ok = pcall(function()
                request({
                    Url    = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"]       = "https://discord.com",
                    },
                    Body = HttpService:JSONEncode({
                        cmd   = "INVITE_BROWSER",
                        args  = { code = inviteCode },
                        nonce = HttpService:GenerateGUID(false),
                    }),
                })
            end)
        end
        if not ok and setclipboard then setclipboard(inviteLink) end
    end,
})
local NoticeLabel = Groups.Lobby.Notice:AddLabel(getLabelText())
local function refreshNotice()
    if game.PlaceId == Place.Lobby then
        Shared.CachedShadowBan = hasExploiter()
        writeStatsFile()
    end
    NoticeLabel:SetText(getLabelText())
end
local function refreshNoticeLabel()
    NoticeLabel:SetText(getLabelText())
end
Plr:GetAttributeChangedSignal("Exploiter"):Connect(refreshNotice)
if Plr.Character then
    Plr.Character:GetAttributeChangedSignal("Exploiter"):Connect(refreshNotice)
end
Plr.CharacterAdded:Connect(function(char)
    char:GetAttributeChangedSignal("Exploiter"):Connect(refreshNotice)
    refreshNoticeLabel()
end)
task.spawn(function()
    task.wait(0.5)
    if game.PlaceId == Place.Lobby then
        Shared.CachedShadowBan = hasExploiter()
    end
    writeStatsFile()
    NoticeLabel:SetText(getLabelText())
end)
Groups.Info.Perf:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering", Default = false })
Toggles.Disable3DRender:OnChanged(function(v)
    RunService:Set3dRenderingEnabled(not v)
end)
Groups.Info.Perf:AddToggle("FPSBoost", { Text = "FPS Boost", Default = false })
Toggles.FPSBoost:OnChanged(function(state)
    ApplyFPSBoost(state)
end)
Groups.Info.Perf:AddToggle("LimitFPS", {
    Text    = "Limit FPS",
    Default = false,
    Callback = function(v)
        if typeof(setfpscap) == "function" then
            setfpscap(v and (Options.LimitFPSValue and Options.LimitFPSValue.Value or 60) or 0)
        end
    end,
})
Groups.Info.Perf:AddSlider("LimitFPSValue", {
    Text     = "Max FPS",
    Default  = 60,
    Min      = 5,
    Max      = 360,
    Rounding = 0,
    Callback = function(v)
        if Toggles.LimitFPS and Toggles.LimitFPS.Value then
            if typeof(setfpscap) == "function" then setfpscap(v) end
        end
    end,
})
Groups.Title.Charac:AddDropdown("SlotSelect", {
    Values  = { "A", "B", "C" },
    Default = "A",
    Text    = "Slot",
})
Groups.Title.Charac:AddToggle("AutoSlotSelect", {
    Text    = "Auto Select Slot",
    Default = false,
    Callback = function(state)
        Thread("AutoSlotSelect", Func_AutoSlotSelect, state)
    end,
})
Groups.Title.Charac:AddToggle("AutoPlay", {
    Text    = "Auto Play",
    Default = false,
    Callback = function(state)
        Thread("AutoPlay", Func_AutoPlay, state)
    end,
})
Groups.Title.Charac:AddDropdown("TargetFamily", {
    Values     = Shared.families,
    Default    = nil,
    Multi      = true,
    AllowNull  = true,
    Searchable = true,
    Text       = "Target Family",
})
Groups.Title.Charac:AddDropdown("TargetRarity", {
    Values     = Shared.rarities,
    Default    = nil,
    Multi      = true,
    AllowNull  = true,
    Text       = "Stop On Rarity",
})
Groups.Title.Charac:AddToggle("StopOnRarity", {
    Text    = "Stop On Rarity",
    Default = false,
})
Groups.Title.Charac:AddToggle("AutoRollFamily", {
    Text    = "Auto Roll Family",
    Default = false,
    Callback = function(state)
        Thread("AutoRollFamily", Func_AutoRollFamily, state)
    end,
})
local initialMaps  = getMapsForType("Missions")
local initialObjs  = getObjectivesForMap("Missions", initialMaps[1])
local initialDiffs = getDifficultiesForType("Missions")
Groups.Lobby.Auto:AddDropdown("LobbyMissionType", {
    Values   = { "Missions", "Raids", "Waves" },
    Default  = "Missions",
    Text     = "Queue Type",
    Callback = function()
        updateMapDropdown()
        updateObjectiveDropdown()
        updateDifficultyDropdown()
    end,
})
Groups.Lobby.Auto:AddDropdown("LobbyMap", {
    Values    = initialMaps,
    Text      = "Map",
    AllowNull = true,
    Searchable = true,
    Callback  = function() updateObjectiveDropdown() end,
})
Groups.Lobby.Auto:AddDropdown("LobbyObjective", {
    Values  = initialObjs,
    Default = initialObjs[1],
    Text    = "Objective",
})
Groups.Lobby.Auto:AddDropdown("LobbyDifficulty", {
    Values  = initialDiffs,
    Default = initialDiffs[1],
    Text    = "Difficulty",
})
Groups.Lobby.Auto:AddDropdown("LobbyModifiers", {
    Values     = Shared.modifiers,
    Default    = nil,
    Multi      = true,
    AllowNull  = true,
    Searchable = true,
    Text       = "Modifiers",
})
Groups.Lobby.Auto:AddToggle("AutoQueue", {
    Text    = "Auto Queue",
    Default = false,
    Callback = function(state)
        Thread("AutoQueue", Func_AutoQueue, state)
    end,
})
Groups.Lobby.Upgrade:AddToggle("AutoUpgradeAll", {
    Text    = "Auto Upgrade Equipments",
    Default = false,
    Callback = function(state)
        Thread("AutoUpgradeAll", Func_AutoUpgradeAll, state)
    end,
})
Groups.Lobby.Upgrade:AddToggle("AutoMaxSkill", {
    Text    = "Auto Max Skill Tree",
    Default = false,
    Callback = function(state)
        Shared.SkillTreeDone = false
        Thread("AutoMaxSkill", Func_AutoMaxSkill, state)
    end,
})
Groups.Lobby.Upgrade:AddToggle("AutoEnhancePerks", {
    Text    = "Auto Enhance Perks",
    Default = false,
    Callback = function(state)
        Thread("AutoEnhancePerks", Func_AutoEnhancePerks, state)
    end,
})
Groups.Lobby.Upgrade:AddToggle("AutoClaimAll", {
    Text    = "Auto Claim Rewards",
    Default = false,
    Callback = function(state)
        Thread("AutoClaimAll", Func_AutoClaimAll, state)
    end,
})
Groups.Lobby.Upgrade:AddToggle("AutoOpenChest", {
    Text    = "Auto Open Chest",
    Default = false,
    Callback = function(state)
        Thread("AutoOpenChest", Func_AutoOpenChest, state)
    end,
})
local chestNames = {}
if Modules.Crates then
    for name in pairs(Modules.Crates) do
        if type(name) == "string" then table.insert(chestNames, name) end
    end
    table.sort(chestNames)
end
Groups.Lobby.Upgrade:AddDropdown("LobbyChestType", {
    Values    = chestNames,
    Default   = nil,
    Multi     = true,
    AllowNull = true,
    Text      = "Chest to Open",
})
Tabs.Combat:UpdateWarningBox({
    Title    = "⚠️ WARNING ⚠️",
    Text     = "Kill All mode is very unstable and may lead to a shadowban. Use at your own risk. Don't set the hit count to high btw",
    IsNormal = false,
    Visible  = true,
    LockSize = true,
})
Groups.Combat.Autofarm:AddToggle("AutoFarm", {
    Text    = "Auto Farm",
    Default = false,
    Callback = function(state)
        if not state then clearBodyLock() end
        Thread("AutoFarm", Func_AutoFarm, state)
    end,
})
Groups.Combat.Autofarm:AddToggle("AutoRefill", {
    Text    = "Auto Refill",
    Default = false,
    Callback = function(state)
        Thread("AutoRefill", Func_AutoRefill, state)
    end,
})
Groups.Combat.Autofarm:AddToggle("AutoReload", {
    Text    = "Auto Reload",
    Default = false,
    Callback = function(state)
        Thread("AutoReload", Func_AutoReload, state)
    end,
})
Groups.Combat.Autofarm:AddToggle("AutoCannon", {
    Text    = "Auto Cannon",
    Default = false,
    Callback = function(state)
        Thread("AutoCannon", Func_AutoCannon, state)
    end,
})
Groups.Combat.Autofarm:AddToggle("AutoSpear", {
    Text    = "Auto Spear",
    Default = false,
    Callback = function(state)
        Thread("AutoSpear", Func_AutoSpear, state)
    end,
})
Groups.Combat.Autofarm:AddToggle("AutoSkipCutscene", {
    Text    = "Auto Skip Cutscene",
    Default = false,
    Callback = function(state)
        Thread("AutoSkipCutscene", Func_AutoSkipCutscene, state)
    end,
})
Groups.Combat.Autofarm:AddToggle("AutoRetry", {
    Text    = "Auto Retry",
    Default = false,
    Callback = function(state)
        Thread("AutoRetry", Func_AutoRetry, state)
    end,
})
Groups.Combat.Autofarm:AddInput("AutoRetryDelay", {
    Text    = "Retry Delay (s)",
    Default = "0",
    Numeric = true,
})
Groups.Combat.Autofarm:AddToggle("AutoLobby", {
    Text    = "Auto Return to Lobby",
    Default = false,
    Callback = function(value)
        Shared.AutoLobbyEnabled = value
    end,
})
Groups.Combat.Autofarm:AddInput("AutoLeaveDelay", {
    Text    = "Return After (s)",
    Default = "0",
    Numeric = true,
})
Groups.Combat.Autofarm:AddDivider()
Groups.Combat.Autofarm:AddToggle("AutoReturnAfterGames", {
    Text    = "Return to Lobby After X Games",
    Default = false,
})
Groups.Combat.Autofarm:AddInput("ReturnAfterGames", {
    Text        = "Return After X Games",
    Default     = "50",
    Numeric     = true,
})
Groups.Combat.Autofarm:AddDivider()
Groups.Combat.Autofarm:AddToggle("AutoDie", {
    Text    = "Auto Die at Streak",
    Default = false,
    Callback = function(state)
        Thread("AutoDie", Func_AutoDie, state)
    end,
})
Groups.Combat.Autofarm:AddInput("AutoDieStreak", {
    Text    = "Die at Streak ",
    Default = "10000",
    Numeric = true,
})
Groups.Combat.Autofarm:AddToggle("AutoPrestige", {
    Text    = "Auto Prestige",
    Default = false,
    Callback = function(state)
        Thread("AutoPrestige", Func_AutoPrestige, state)
    end,
})
Groups.Combat.Autofarm:AddInput("PrestigeMinGold", {
    Text    = "Min Gold to Prestige",
    Default = "0",
    Numeric = true,
})
Groups.Combat.Autofarm:AddDropdown("PrestigeBoost", {
    Values  = { "Luck", "EXP", "Gold" },
    Default = "Luck",
    Text    = "Prestige Boost Choice",
})
Groups.Combat.Settings:AddDropdown("FarmMode", {
    Values  = { "Nearest", "Kill All", "Batch" },
    Default = "Nearest",
    Text    = "Farm Mode",
})
Groups.Combat.Settings:AddSlider("HitCount", {
    Text     = "Hit Count",
    Default  = 1,
    Min      = 1,
    Max      = 10,
    Rounding = 0,
})
Groups.Combat.Settings:AddSlider("RefillThreshold", {
    Text     = "Refill At Sets ≤",
    Default  = 0,
    Min      = 0,
    Max      = 3,
    Rounding = 0,
})
Groups.Combat.Settings:AddSlider("ReloadThreshold", {
    Text     = "Reload Threshold",
    Default  = 6,
    Min      = 1,
    Max      = 7,
    Rounding = 0,
})
Groups.Combat.Settings:AddSlider("TweenDistance", {
    Text     = "Tween Height",
    Default  = 115,
    Min      = 10,
    Max      = 300,
    Rounding = 0,
})
Groups.Combat.Settings:AddInput("FarmStartDelay", {
    Text     = "Delay Before Farming (s)",
    Default  = "0",
    Numeric  = true,
    Finished = false,
})
Groups.Combat.Settings:AddInput("LastTitanDelay", {
    Text     = "Delay Before Last Titan (s)",
    Default  = "0",
    Numeric  = true,
    Finished = false,
})
Groups.Combat.Settings:AddInput("TweenSpeed", {
    Text     = "Tween Speed",
    Default  = "200",
    Numeric  = true,
    Finished = false,
})
Groups.Combat.Settings:AddInput("HitDistance", {
    Text     = "Hit Range",
    Default  = "200",
    Numeric  = true,
    Finished = false,
})
Groups.Webhook.Config:AddInput("WebhookURL", {
    Text        = "Webhook URL",
    Default     = "",
    Numeric     = false,
    Finished    = false,
    Placeholder = "https://discord.com/api/webhooks/...",
})
Groups.Webhook.Config:AddInput("WebhookUID", {
    Text        = "User ID (for ping)",
    Default     = "",
    Numeric     = true,
    Finished    = false,
    Placeholder = "Discord user ID...",
})
Groups.Webhook.Config:AddToggle("WebhookPingUser", {
    Text    = "Ping User",
    Default = false,
})
Groups.Webhook.Config:AddToggle("WebhookEnabled", {
    Text    = "Send After Every Match",
    Default = false,
})
Groups.Webhook.Config:AddToggle("WebhookFamilyPing", {
    Text    = "Ping on Target Family Rolled",
    Default = false,
})
Groups.Webhook.Config:AddButton("Test Webhook", function()
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
end)
Groups.Config.Menu:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end,
})
Groups.Config.Menu:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = true,
    Callback = function(value) Library.ShowCustomCursor = value end,
})
Groups.Config.Menu:AddDivider()
Groups.Config.Menu:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI    = true,
    Text    = "Menu keybind",
})
Groups.Config.Menu:AddButton({
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
SaveManager:SetFolder("Yuri/AOTR")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
SaveManager:IgnoreThemeSettings()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
end) 
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 6)
end
