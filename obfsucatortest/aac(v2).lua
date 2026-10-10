if getgenv().ayasemiyatongekissazumirisa then return end
getgenv().ayasemiyatongekissazumirisa = true
repeat task.wait() until game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("LoadingScreen") == nil
local function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
cloneref    = missing("function", cloneref, function(...) return ... end)
getgc       = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
local Services = setmetatable({}, {
    __index = function(self, name)
        local ok, result = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if ok then
            rawset(self, name, result)
            return result
        end
        error("Invalid Service: " .. tostring(name))
    end
})
local function dcmm()
end
local Players           = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local HttpService       = Services.HttpService
local Workspace         = Services.Workspace
local CoreGui           = Services.CoreGui
local TweenService      = Services.TweenService
local UserInputService  = Services.UserInputService
local LocalPlayer       = Players.LocalPlayer
local repo         = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
local Options = Library.Options
local Toggles = Library.Toggles
local c_folder    = "Yuri/aac_configs(" .. LocalPlayer.Name .. ")"
local a_path      = c_folder .. "/active_card"
local d_card_path = c_folder .. "/default_card.json"
local buildPath   = c_folder .. "/build.json"
local Place = {
    Lobby   = 80734098185936,
    Dungeon = 111943251737481,
}
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
local executorDisplayName = identifyexecutor and identifyexecutor() or "Unknown"
local isLimitedExecutor   = executorDisplayName:lower():find("xeno") ~= nil
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end
local function GetRemote(parent, pathString)
    local current = parent
    for _, name in ipairs(pathString:split(".")) do
        if not current then return nil end
        current = current:FindFirstChild(name)
    end
    return current
end
local SAFE_INVOKE_SENTINEL = {}
local function SafeInvoke(remote, ...)
    local args   = {...}
    local result = SAFE_INVOKE_SENTINEL
    task.spawn(function()
        local ok, res = pcall(function()
            return remote:InvokeServer(unpack(args))
        end)
        result = ok and res or nil
    end)
    local start = tick()
    repeat task.wait() until result ~= SAFE_INVOKE_SENTINEL or (tick() - start) > 2
    return result ~= SAFE_INVOKE_SENTINEL and result or nil
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
    end
end
local function Cleanup(tbl)
    for key, value in pairs(tbl) do
        if typeof(value) == "RBXScriptConnection" then
            value:Disconnect()
            tbl[key] = nil
        elseif typeof(value) == "thread" then
            task.cancel(value)
            tbl[key] = nil
        elseif type(value) == "table" then
            Cleanup(value)
        end
    end
end
local function doRequest(url, body)
    if syn and syn.request then
        syn.request({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
    elseif request then
        request({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
    else
        HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
    end
end
local Remotes = {
    PlayerUpdate     = GetRemote(ReplicatedStorage, "Remotes.PlayerUpdate"),
    CreateParty      = GetRemote(ReplicatedStorage, "Remotes.CreateParty"),
    PartyStart       = GetRemote(ReplicatedStorage, "Remotes.PartyStart"),
    EventCreateParty = GetRemote(ReplicatedStorage, "Remotes.EventCreateParty"),
    EventPartyStart  = GetRemote(ReplicatedStorage, "Remotes.EventPartyStart"),
    GetPartyMembers  = GetRemote(ReplicatedStorage, "Remotes.GetPartyMembers"),
    GetParties       = GetRemote(ReplicatedStorage, "Remotes.GetParties"),
    JoinParty        = GetRemote(ReplicatedStorage, "Remotes.JoinParty"),
    PartyModifiers   = GetRemote(ReplicatedStorage, "Remotes.PartyModifiers"),
    PlayerInventory  = GetRemote(ReplicatedStorage, "Remotes.PlayerInventory"),
    InvestStats      = GetRemote(ReplicatedStorage, "Remotes.InvestStats"),
    GetStats         = GetRemote(ReplicatedStorage, "Remotes.GetStats"),
    GetSceneOptions  = GetRemote(ReplicatedStorage, "Remotes.GetSceneOptions"),
    SceneEvent       = GetRemote(ReplicatedStorage, "Remotes.SceneEvent"),
    VotingEvent      = GetRemote(ReplicatedStorage, "Remotes.VotingEvent"),
    TurnDecision     = GetRemote(ReplicatedStorage, "Remotes.TurnDecision"),
    FireTurn         = GetRemote(ReplicatedStorage, "Remotes.FireTurn"),
    GetAbilities     = GetRemote(ReplicatedStorage, "Remotes.GetAbilities"),
    AttackFlash      = GetRemote(ReplicatedStorage, "Remotes.AttackFlash"),
    CombatEnd        = GetRemote(ReplicatedStorage, "Remotes.CombatEnd"),
    ChangeUI         = GetRemote(ReplicatedStorage, "Remotes.ChangeUI"),
    ReplayEvent      = GetRemote(ReplicatedStorage, "Remotes.ReplayEvent"),
    GetItems         = GetRemote(ReplicatedStorage, "Remotes.GetItems"),
    UpdateTurn       = GetRemote(ReplicatedStorage, "Remotes.UpdateTurn"),
    Achievement      = GetRemote(ReplicatedStorage, "Remotes.Achievement"),
    Upgrade          = GetRemote(ReplicatedStorage, "Remotes.Upgrade"),
    GetArea          = GetRemote(ReplicatedStorage, "Remotes.GetArea"),
}
local Flags = {}
local function Thread(featurePath, featureFunc, isEnabled, ...)
    local pathParts   = featurePath:split(".")
    local currentTable = Flags
    for i = 1, #pathParts - 1 do
        local part = pathParts[i]
        if not currentTable[part] then currentTable[part] = {} end
        currentTable = currentTable[part]
    end
    local flagKey     = pathParts[#pathParts]
    local activeThread = currentTable[flagKey]
    if isEnabled then
        if not activeThread or coroutine.status(activeThread) == "dead" then
            currentTable[flagKey] = task.spawn(featureFunc, ...)
        end
    else
        if activeThread and typeof(activeThread) == "thread" then
            task.cancel(activeThread)
            currentTable[flagKey] = nil
        end
    end
end
local function SafeLoop(name, interval, func)
    return function()
        while true do
            local ok, err = pcall(func)
            if not ok then
                Library:Notify("Error in [" .. name .. "]: " .. tostring(err), 10)
            end
            task.wait(interval > 0 and interval or 0)
        end
    end
end
local function defaultConfig()
    return {
        EncountersPick = {
            Mystic          = { ScenesPick = { "Break", "Take some" } },
            Druid           = { ScenesPick = { "Say Hello", "Teach Me", "Swear Oath" }, Requirements = { Level = ">0" } },
        },
        StatsAllocation = {
            STR = 0, DEX = 0, CON = 3,
            INT = 0, FTH = 1, CHA = 0, LCK = 0,
        },
        EquipmentsStats = {
            FlatSTR = 0, FlatDEX = 0, FlatCON = 0, FlatINT = 0,
            FlatFTH = 1, FlatCHA = 0, FlatLCK = 0,
        },
        GoldToShop            = 150,
        DamageToBlock         = 15,
        BlockPredictions      = 1,
        PotionUseThreshold    = 40,
        Block                 = true,
        PotionUse             = true,
        Heal                  = true,
        Summon                = true,
        Buff                  = true,
        HealThreshold         = 50,
        BlockThreshold        = 60,
        RestThreshold         = 40,
        Train                 = true,
        RestartAtArea         = "Forest",
        RestartAtFloor        = 0,
        RestartAt             = false,
        ShowPrioritiesSetting = true,
        HealTarget            = "Self",
        WebhookURL            = "",
        DiscordId             = "",
        PingAchievements      = false,
        ProgressWebhookInt    = 5,
        EnableProgressWebhook = false,
        AutoJoin              = false,
        JoinEvent             = false,
        Multiplayer           = false,
        MainAccount           = "",
        Alts                  = {},
        JoinWait              = 60,
        GameModifiers         = {},
        UpgradesPick          = {},
    }
end
local function getCC()
    if isfile(a_path) then return trim(readfile(a_path)) end
    return "default_card"
end
local Shared = {
    AutoJoin              = false,
    JoinEvent             = false,
    Multiplayer           = false,
    MainAccount           = "",
    Alts                  = {},
    JoinWait              = 60,
    currentStats          = {},
    Inv      = {},
    Equip      = {},
    shopInventory         = {},
    BOT_ENABLED           = true,
    USE_ABILITIES         = true,
    BlockPredictions      = 1,
    PotionUseThreshold    = 40,
    DamageToBlock         = 15,
    currentHighlight      = nil,
    isSummonTurn          = false,
    SummonRef             = nil,
    SummonCooldowns       = {},
    latestSummonData      = nil,
    pCD                   = {},
    enCD                  = {},
    latestPlayerData      = nil,
    combatInventory       = {},
    BuffUsedThisFight     = false,
    WH_Options            = nil,
    WH_Toggles            = nil,
    PrioritiesConfig      = nil,
    currentCard           = getCC(),
    ShowPrioritiesSetting = false,
    UpgradesPick          = {},
    RestartAtArea         = "Forest",
    RestartAtFloor        = 0,
    RestartAt             = false,
}
local function LoadConfig()
    local configPath = c_folder .. "/" .. Shared.currentCard .. ".json"
    if Shared.currentCard ~= "default_card" and not isfile(configPath) then
        configPath = c_folder .. "/default_card.json"
    end
    if isfile(configPath) then
        local ok, result = pcall(function() return HttpService:JSONDecode(readfile(configPath)) end)
        if ok and type(result) == "table" then return result end
    end
    local def         = defaultConfig()
    local defaultPath = c_folder .. "/default_card.json"
    if not isfile(defaultPath) then
        writefile(defaultPath, HttpService:JSONEncode(def))
    end
    return def
end
if isfile(a_path) then Shared.currentCard = trim(readfile(a_path)) end
Shared.config = LoadConfig()
Shared.EncountersPick         = Shared.config.EncountersPick
Shared.StatsAllocation        = Shared.config.StatsAllocation
Shared.EquipmentsStats        = Shared.config.EquipmentsStats
Shared.GoldToShop             = Shared.config.GoldToShop
Shared.DamageToBlock          = Shared.config.DamageToBlock
Shared.BlockPredictions       = Shared.config.BlockPredictions
Shared.PotionUseThreshold     = Shared.config.PotionUseThreshold
Shared.Block                  = Shared.config.Block
Shared.PotionUse              = Shared.config.PotionUse
Shared.Heal                   = Shared.config.Heal
Shared.Summon                 = Shared.config.Summon
Shared.Buff                   = Shared.config.Buff
Shared.HealThreshold          = Shared.config.HealThreshold
Shared.BlockThreshold         = Shared.config.BlockThreshold
Shared.RestThreshold          = Shared.config.RestThreshold
Shared.Train                  = Shared.config.Train
Shared.ShowPrioritiesSetting  = Shared.config.ShowPrioritiesSetting
Shared.HealTarget             = Shared.config.HealTarget
Shared.WebhookURL             = Shared.config.WebhookURL
Shared.DiscordId              = Shared.config.DiscordId or ""
Shared.PingAchievements       = Shared.config.PingAchievements or false
Shared.ProgressWebhookInt     = Shared.config.ProgressWebhookInt or 5
Shared.EnableProgressWebhook  = Shared.config.EnableProgressWebhook or false
Shared.AutoJoin               = Shared.config.AutoJoin
Shared.JoinEvent               = Shared.config.JoinEvent or false
Shared.Multiplayer            = Shared.config.Multiplayer
Shared.MainAccount            = Shared.config.MainAccount
Shared.Alts                   = Shared.config.Alts
Shared.JoinWait               = Shared.config.JoinWait
Shared.GameModifiers          = Shared.config.GameModifiers or {}
Shared.UpgradesPick           = Shared.config.UpgradesPick or {}
Shared.RestartAtArea          = Shared.config.RestartAtArea or "Forest"
Shared.RestartAtFloor         = Shared.config.RestartAtFloor or 0
Shared.RestartAt              = Shared.config.RestartAt or false
local function ListCards()
    local cards = {}
    if not isfolder(c_folder) then return cards end
    if isfile(d_card_path) then table.insert(cards, "default_card") end
    for _, filepath in ipairs(listfiles(c_folder)) do
        local filename = filepath:match("([^/\\]+)$")
        if filename:match("%.json$") and not filename:match("_build%.json$") and filename ~= "default_card.json" then
            table.insert(cards, filename:match("(.+)%.json$"))
        end
    end
    return cards
end
local function setActiveCard(cardName)
    if not isfolder(c_folder) then makefolder(c_folder) end
    if cardName ~= "default_card" and not isfile(c_folder .. "/" .. cardName .. ".json") then
        return false
    end
    writefile(a_path, cardName)
    return true
end
local cards = ListCards()
local function AddInfo(Window)
    local InfoTab   = Window:AddTab("Info")
    local InfoLeft  = InfoTab:AddLeftGroupbox("Information")
    local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
    local extraNote  = isLimitedExecutor
        and "<b>NOTE:</b> May experiencing bugs for some features!"
        or "All features should works properly!"
    InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
    local InfoRight = InfoTab:AddRightGroupbox("Others")
    InfoRight:AddButton({
        Text = "Join Discord Server",
        Func = function()
            local inviteCode = "3y2Z8VfhX"
            local inviteLink = "https://discord.gg/" .. inviteCode
            local success    = false
            if request then
                success = pcall(function()
                    request({
                        Url    = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"]       = "https://discord.com"
                        },
                        Body = HttpService:JSONEncode({
                            cmd   = "INVITE_BROWSER",
                            args  = { code = inviteCode },
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
if game.PlaceId == Place.Lobby then
    local function buildModifierTable()
        local t = {}
        for _, name in ipairs(Shared.GameModifiers) do
            t[name] = true
        end
        return t
    end
    local function applyModifiers()
        local t = buildModifierTable()
        if next(t) then
            Remotes.PartyModifiers:FireServer(t)
            task.wait(0.1)
        end
    end
    local class    = LocalPlayer:GetAttribute("Class")
    local prestige = LocalPlayer:GetAttribute("Prestige")
    local boons    = {}
    local scrollingFrame = LocalPlayer.PlayerGui
        :WaitForChild("Boons")
        :WaitForChild("Background")
        :WaitForChild("BoonsEquippedFrame")
        :WaitForChild("BoonsEquippedScrollingFrame")
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then table.insert(boons, child.Name) end
    end
    local buildData = {
        class    = class,
        prestige = prestige,
        boons    = boons,
        race     = LocalPlayer:GetAttribute("Race"),
        cealts   = LocalPlayer:GetAttribute("Cealt"),
    }
    makefolder(c_folder)
    writefile(buildPath, HttpService:JSONEncode(buildData))
    if Shared.currentCard ~= "default_card" then
        local cardBuildPath = c_folder .. "/" .. Shared.currentCard .. "_build.json"
        if isfile(cardBuildPath) then
            local targetBuild = HttpService:JSONDecode(readfile(cardBuildPath))
            local needsSwitch = false
            if targetBuild.class ~= class then
                needsSwitch = true
            elseif #targetBuild.boons ~= #boons then
                needsSwitch = true
            else
                for _, tb in ipairs(targetBuild.boons) do
                    if not table.find(boons, tb) then needsSwitch = true break end
                end
            end
            if needsSwitch then
                if targetBuild.class and targetBuild.class ~= class then
                    Remotes.PlayerUpdate:FireServer("Class", targetBuild.class)
                    repeat task.wait() until LocalPlayer:GetAttribute("Class") == targetBuild.class
                    class = LocalPlayer:GetAttribute("Class")
                end
                boons = {}
                for _, child in ipairs(scrollingFrame:GetChildren()) do
                    if child:IsA("Frame") then table.insert(boons, child.Name) end
                end
                for _, cb in ipairs(boons) do
                    if not table.find(targetBuild.boons, cb) then
                        Remotes.PlayerUpdate:FireServer("UnequipBoon", cb)
                        task.wait(0.1)
                    end
                end
                for _, tb in ipairs(targetBuild.boons) do
                    if not table.find(boons, tb) then
                        Remotes.PlayerUpdate:FireServer("EquipBoon", tb)
                        task.wait(0.1)
                    end
                end
            end
        end
    end
    if Shared.AutoJoin then
        local CreatePartyRemote = Shared.JoinEvent and Remotes.EventCreateParty or Remotes.CreateParty
        local PartyStartRemote  = Shared.JoinEvent and Remotes.EventPartyStart  or Remotes.PartyStart
        if not Shared.Multiplayer then
            CreatePartyRemote:FireServer({ PartySize = 1, GameSpeed = 2, FriendsOnly = true, StashCraft = false })
            task.wait(0.175)
            applyModifiers()
            PartyStartRemote:FireServer()
        else
            local isMain = (LocalPlayer.Name == Shared.MainAccount)
            local isAlt  = false
            for _, altName in ipairs(Shared.Alts) do
                if LocalPlayer.Name == altName then isAlt = true break end
            end
            if isMain then
                CreatePartyRemote:FireServer({ PartySize = 1 + #Shared.Alts, GameSpeed = 2, FriendsOnly = false, StashCraft = false })
                local joinedAlts  = {}
                local allJoined   = false
                local pmConn
                pmConn = Remotes.GetPartyMembers.OnClientEvent:Connect(function(partyData, partyLeader)
                    if partyLeader and partyLeader.Name == LocalPlayer.Name and partyData[LocalPlayer.Name] then
                        local members = partyData[LocalPlayer.Name].Members
                        joinedAlts = {}
                        for _, member in ipairs(members) do
                            if member and member:IsA("Player") then
                                for _, altName in ipairs(Shared.Alts) do
                                    if member.Name == altName then
                                        table.insert(joinedAlts, altName)
                                        break
                                    end
                                end
                            end
                        end
                        if #joinedAlts >= #Shared.Alts then allJoined = true end
                    end
                end)
                local waitTime = 0
                while not allJoined and waitTime < Shared.JoinWait do
                    task.wait(0.5)
                    waitTime = waitTime + 0.5
                end
                pmConn:Disconnect()
                task.wait(0.5)
                applyModifiers()
                PartyStartRemote:FireServer()
            elseif isAlt then
                local mainPlayer  = nil
                local partyFound  = false
                local attempts    = 0
                local maxAttempts = 40
                while not mainPlayer and attempts < maxAttempts do
                    mainPlayer = Players:FindFirstChild(Shared.MainAccount)
                    if not mainPlayer then task.wait(0.5) attempts += 1 end
                end
                if not mainPlayer then return end
                local partiesConn
                partiesConn = Remotes.GetParties.OnClientEvent:Connect(function(parties)
                    if partyFound then return end
                    if parties and parties[Shared.MainAccount] then
                        local mainParty = parties[Shared.MainAccount]
                        if (#mainParty.Members + 1) < mainParty.PartySize then
                            Remotes.JoinParty:FireServer(mainPlayer)
                            partyFound = true
                        end
                    end
                end)
                local waitTime = 0
                while not partyFound and waitTime < Shared.JoinWait do
                    task.wait(0.5)
                    waitTime += 0.5
                end
                partiesConn:Disconnect()
            else
                CreatePartyRemote:FireServer({ PartySize = 1, GameSpeed = 2, FriendsOnly = true, StashCraft = false })
                task.wait(0.175)
                applyModifiers()
                PartyStartRemote:FireServer()
            end
        end
    else
        task.spawn(function()
            local function readCard()
                if not isfolder(c_folder) then makefolder(c_folder) end
                if isfile(d_card_path) then
                    local ok, result = pcall(function() return HttpService:JSONDecode(readfile(d_card_path)) end)
                    if ok and type(result) == "table" then return result end
                end
                return {
                    GoldToShop = 150, DamageToBlock = 15, BlockPredictions = 2, PotionUseThreshold = 40,
                    Block = true, PotionUse = true, Heal = true, Summon = true, Buff = true,
                    HealThreshold = 0, BlockThreshold = 60, RestThreshold = 0,
                    Train = true, ShowPrioritiesSetting = false, HealTarget = "Self",
                    WebhookURL = "",
                    EncountersPick = {},
                    StatsAllocation = {
                        STR = 1, DEX = 0, CON = 3,
                        INT = 0, FTH = 0, CHA = 0, LCK = 0,
                    },
                    EquipmentsStats = {
                        FlatSTR = 1, FlatDEX = 0, FlatCON = 0, FlatINT = 0, FlatFTH = 0, FlatCHA = 0, FlatLCK = 0,
                    },
                }
            end
            local function SaveConfig(c)
                if not isfolder(c_folder) then makefolder(c_folder) end
                writefile(d_card_path, HttpService:JSONEncode(c))
            end
            local card   = readCard()
            local function BindOption(control, key, transform)
                control:OnChanged(function()
                    local value = control.Value
                    if transform then value = transform(value) end
                    card[key]   = value
                    Shared[key] = value
                    SaveConfig(card)
                end)
            end
            local Window = Library:CreateWindow({ Title = "Yuri", Center = true, AutoShow = true, Resizable = true })
            AddInfo(Window)
            local Tabs = {
                Combat = Window:AddTab("Combat"),
                Stats  = Window:AddTab("Stats"),
                Misc   = Window:AddTab("Misc"),
            }
            local TravelBox = Tabs.Combat:AddLeftGroupbox("Travel")
            TravelBox:AddInput("GoldToShop", { Text = "Shop Gold Requirement", Default = tostring(card.GoldToShop or 150), Numeric = true, Finished = true, Placeholder = "" })
            BindOption(Options.GoldToShop, "GoldToShop", function(v) return tonumber(v) or 150 end)
            TravelBox:AddInput("RestThreshold", { Text = "Rest threshold(%)", Default = tostring(card.RestThreshold or 0), Numeric = true, Finished = true, Placeholder = "" })
            BindOption(Options.RestThreshold, "RestThreshold", function(v) return tonumber(v) or 0 end)
            TravelBox:AddToggle("Train", { Text = "Train", Default = card.Train == true })
            BindOption(Toggles.Train, "Train")
            TravelBox:AddDropdown("RestartAtArea", { Text = "Restart area", Values = { "Forest", "Dungeon", "Sewer", "Mines" }, Default = card.RestartAtArea or "Forest", Multi = false })
            BindOption(Options.RestartAtArea, "RestartAtArea")
            TravelBox:AddInput("RestartAtFloor", { Text = "Restart floor", Default = tostring(card.RestartAtFloor or 0), Numeric = true, Finished = true, Placeholder = "" })
            BindOption(Options.RestartAtFloor, "RestartAtFloor", function(v) return tonumber(v) or 0 end)
            TravelBox:AddToggle("RestartAt", { Text = "Auto Restart", Default = card.RestartAt == true })
            BindOption(Toggles.RestartAt, "RestartAt")
            local BlockBox = Tabs.Combat:AddLeftGroupbox("Block")
            BlockBox:AddInput("BlockThreshold", { Text = "Block threshold(%)", Default = tostring(card.BlockThreshold or 60), Numeric = true, Finished = true, Placeholder = "" })
            BindOption(Options.BlockThreshold, "BlockThreshold", function(v) return tonumber(v) or 60 end)
            BlockBox:AddInput("BlockPredictions", { Text = "Block predictions", Default = tostring(card.BlockPredictions or 2), Numeric = true, Finished = true, Placeholder = "" })
            BindOption(Options.BlockPredictions, "BlockPredictions", function(v) return tonumber(v) or 2 end)
            BlockBox:AddInput("DamageToBlock", { Text = "Damage to block(%)", Default = tostring(card.DamageToBlock or 15), Numeric = true, Finished = true, Placeholder = "" })
            BindOption(Options.DamageToBlock, "DamageToBlock", function(v) return tonumber(v) or 15 end)
            BlockBox:AddToggle("Block", { Text = "Block", Default = card.Block == true })
            BindOption(Toggles.Block, "Block")
            local HealBox = Tabs.Combat:AddRightGroupbox("Heal")
            HealBox:AddInput("HealThreshold", { Text = "Heal threshold(%)", Default = tostring(card.HealThreshold or 0), Numeric = true, Finished = true, Placeholder = "" })
            BindOption(Options.HealThreshold, "HealThreshold", function(v) return tonumber(v) or 0 end)
            HealBox:AddDropdown("HealTarget", { Text = "Heal target", Values = { "Self", "Lowest" }, Default = card.HealTarget or "Self", Multi = false })
            BindOption(Options.HealTarget, "HealTarget")
            HealBox:AddToggle("Heal", { Text = "Heal", Default = card.Heal == true })
            BindOption(Toggles.Heal, "Heal")
            local PotionBox = Tabs.Combat:AddRightGroupbox("Potions")
            PotionBox:AddInput("PotionUseThreshold", { Text = "Potion use threshold(%)", Default = tostring(card.PotionUseThreshold or 40), Numeric = true, Finished = true, Placeholder = "" })
            PotionBox:AddToggle("PotionUse", { Text = "Potion Use", Default = card.PotionUse == true })
            BindOption(Toggles.PotionUse, "PotionUse")
            BindOption(Options.PotionUseThreshold, "PotionUseThreshold", function(v) return tonumber(v) or 40 end)
            local CombatMiscBox = Tabs.Combat:AddRightGroupbox("Combat")
            CombatMiscBox:AddToggle("Summon", { Text = "Summon", Default = card.Summon == true })
            BindOption(Toggles.Summon, "Summon")
            CombatMiscBox:AddToggle("Buff", { Text = "Buff", Default = card.Buff == true })
            BindOption(Toggles.Buff, "Buff")
            local StUpBox  = Tabs.Stats:AddLeftGroupbox("Stat Upgrade Priority")
            StUpBox:AddLabel("Example: STR = 1, INT = 2 means STR gets twice the points of INT. For 100 total points, STR = 67 and INT = 33.", true)
            local statKeys = { "STR", "DEX", "CON", "INT", "FTH", "CHA", "LCK" }
            for _, stat in ipairs(statKeys) do
                local current = (card.StatsAllocation and card.StatsAllocation[stat]) or 0
                StUpBox:AddInput("StatsAllocation" .. stat, { Text = stat, Default = tostring(current), Numeric = true, Finished = true, Placeholder = "" })
                StUpBox:AddDivider()
                Options["StatsAllocation" .. stat]:OnChanged(function()
                    if not card.StatsAllocation then card.StatsAllocation = {} end
                    card.StatsAllocation[stat] = tonumber(Options["StatsAllocation" .. stat].Value) or 0
                    Shared.StatsAllocation = card.StatsAllocation
                    SaveConfig(card)
                end)
            end
            local EqBox  = Tabs.Stats:AddRightGroupbox("Equipment Stats")
            EqBox:AddLabel("Example: FlatSTR = 1, FlatFTH = 1 means it will equip, buy, or craft items that have STR or FTH stats only.", true)
            local eqKeys = { "FlatSTR", "FlatDEX", "FlatCON", "FlatINT", "FlatFTH", "FlatCHA", "FlatLCK" }
            for _, k in ipairs(eqKeys) do
                local cur = (card.EquipmentsStats and card.EquipmentsStats[k]) or 0
                EqBox:AddInput("EquipmentsStats" .. k, { Text = k, Default = tostring(cur), Numeric = true, Finished = true, Placeholder = "" })
                EqBox:AddDivider()
                Options["EquipmentsStats" .. k]:OnChanged(function()
                    if not card.EquipmentsStats then card.EquipmentsStats = {} end
                    card.EquipmentsStats[k] = tonumber(Options["EquipmentsStats" .. k].Value) or 0
                    Shared.EquipmentsStats  = card.EquipmentsStats
                    SaveConfig(card)
                end)
            end
            local Webhook = Tabs.Misc:AddRightGroupbox("Webhook")
            Webhook:AddInput("WebhookURL", { Text = "Webhook URL", Default = card.WebhookURL or "", Finished = true, Placeholder = "https://discord.com/api/webhooks/..." })
            Options.WebhookURL:OnChanged(function()
                card.WebhookURL = Options.WebhookURL.Value
                Shared.WebhookURL = card.WebhookURL
                if Shared.config then Shared.config.WebhookURL = card.WebhookURL end
                SaveConfig(card)
            end)
            Webhook:AddInput("DiscordId", { Text = "Discord User ID (for ping)", Default = card.DiscordId or "", Placeholder = "123456789012345678", Finished = true })
            BindOption(Options.DiscordId, "DiscordId")
            Webhook:AddToggle("PingAchievements", { Text = "Ping if Achievements", Default = card.PingAchievements or false })
            BindOption(Toggles.PingAchievements, "PingAchievements")
            Webhook:AddInput("ProgressWebhookInt", { Text = "Progress interval (minutes)", Default = tostring(card.ProgressWebhookInt or 5), Numeric = true, Placeholder = "5", Finished = true })
            BindOption(Options.ProgressWebhookInt, "ProgressWebhookInt", function(v) return tonumber(v) or 5 end)
            Webhook:AddToggle("EnableProgressWebhook", { Text = "Enable Progress Webhook", Default = card.EnableProgressWebhook or false })
            BindOption(Toggles.EnableProgressWebhook, "EnableProgressWebhook")
            Webhook:AddButton({
                Text = "Test Webhook",
                Func = function()
                    local url = Options.WebhookURL.Value
                    if url == "" or not url:find("discord.com/api/webhooks/") then
                        Library:Notify("Invalid webhook URL.", 3)
                        return
                    end
                    local payload = {
                        username   = "Yuri",
                        avatar_url = yuri[math.random(1, #yuri)],
                        embeds = {{
                            title       = "Test Webhook",
                            description = "Yuri yuri!",
                            color       = math.random(0, 16777215),
                            thumbnail = { url = yuri[math.random(1, #yuri)] },
                            fields      = {
                                { name = "Player", value = "||" .. LocalPlayer.Name .. "||", inline = true },
                                { name = "Time",   value = os.date("%x %X"),                 inline = true },
                            },
                            footer = { text = string.format("Yuri • %s", os.date("%x %X")) },
                        }}
                    }
                    local ok, e = pcall(function() doRequest(url, HttpService:JSONEncode(payload)) end)
                    Library:Notify(ok and "Test webhook sent!" or ("Webhook failed: " .. tostring(e)), 3)
                end,
            })
            local JoinBox = Tabs.Misc:AddLeftGroupbox("Auto-Join")
            JoinBox:AddToggle("ConfigAutoJoin", { Text = "Auto Join", Default = Shared.AutoJoin })
            BindOption(Toggles.ConfigAutoJoin, "AutoJoin")
            JoinBox:AddToggle("ConfigJoinEvent", { Text = "Join Event", Default = Shared.JoinEvent })
            BindOption(Toggles.ConfigJoinEvent, "JoinEvent")
            local AllModifiers = {
                "Level 1",
                "Feeble",
                "Poverty",
                "Glass Soul",
                "Towering Forces",
                "Relentless",
                "Facetank",
                "Unfair",
                "Unrelenting",
                "Ruination",
                "Deep Wounds",
                "Slow Start",
                "Surprise Round",
                "Simple",
                "Fortunate",
                "Waning Evil",
                "Padded Armor",
                "Advantage",
                "Invigorated",
                "Empowered",
                "Proficient",
            }
            JoinBox:AddDropdown("ConfigGameModifiers", {
                Text     = "Modifiers",
                Values   = AllModifiers,
                Default  = Shared.GameModifiers,
                Multi    = true,
            })
            BindOption(Options.ConfigGameModifiers, "GameModifiers", function(value)
                local selected = {}
                for name, enabled in pairs(value) do
                    if enabled then table.insert(selected, name) end
                end
                return selected
            end)
            JoinBox:AddToggle("ConfigMultiplayer", { Text = "Multi Account", Default = Shared.Multiplayer })
            BindOption(Toggles.ConfigMultiplayer, "Multiplayer")
            JoinBox:AddInput("ConfigMain", { Text = "Main account name", Default = "", Placeholder = "PlayerName", Finished = false })
            JoinBox:AddButton({
                Text = "Set Main Account",
                Func = function()
                    local name = trim(Options.ConfigMain.Value)
                    if name == "" then return end
                    Shared.MainAccount = name
                    card.MainAccount   = name
                    SaveConfig(card)
                    Library:Notify("Main set to: " .. name)
                end,
            })
            JoinBox:AddInput("ConfigAltInput", { Text = "Alt name", Default = "", Placeholder = "AltName", Finished = false })
            JoinBox:AddButton({
                Text = "Add Alt",
                Func = function()
                    local name = trim(Options.ConfigAltInput.Value)
                    if name == "" then return end
                    if not table.find(Shared.Alts, name) then
                        table.insert(Shared.Alts, name)
                        card.Alts = Shared.Alts
                        SaveConfig(card)
                        Library:Notify("Added alt: " .. name)
                    end
                end,
            })
            JoinBox:AddButton({
                Text = "Remove Alt",
                Func = function()
                    local name = trim(Options.ConfigAltInput.Value)
                    if name == "" then return end
                    local idx = table.find(Shared.Alts, name)
                    if idx then
                        table.remove(Shared.Alts, idx)
                        card.Alts = Shared.Alts
                        SaveConfig(card)
                        Library:Notify("Removed alt: " .. name)
                    end
                end,
            })
            JoinBox:AddInput("ConfigJoinWait", { Text = "Max wait", Default = tostring(Shared.JoinWait), Numeric = true, Finished = true, Placeholder = "" })
            BindOption(Options.ConfigJoinWait, "JoinWait", function(v) return tonumber(v) or 30 end)
            JoinBox:AddToggle("ShowSetting", { Text = "Show Priorities Setting(In dungeon)", Default = Shared.ShowPrioritiesSetting })
            BindOption(Toggles.ShowSetting, "ShowPrioritiesSetting")
            Library.ToggleKeybind = Options.CardMenuKeybind
            Shared.WH_Options     = Options
            Shared.WH_Toggles     = Toggles
        end)
    end
elseif game.PlaceId == Place.Dungeon then
    local Dicts    = ReplicatedStorage:WaitForChild("Dictionaries")
    local function GetSafeModule(parent, name)
        local obj = parent:FindFirstChild(name)
        if obj and obj:IsA("ModuleScript") then
            local success, result = pcall(require, obj)
            if success then return result end
        end
        return nil
    end
    local Abilities = GetSafeModule(Dicts, "Abilities")
    local AbilityBlacklist = {
    }
    for _, name in ipairs(AbilityBlacklist) do
        Abilities[name] = nil
    end
    local CrossSlashData = Abilities["Cross Slash"]
    local function updateRampagerBlacklist()
        if LocalPlayer:GetAttribute("Class") == "Rampager" then
            Abilities["Cross Slash"] = nil
        else
            Abilities["Cross Slash"] = CrossSlashData
        end
    end
    updateRampagerBlacklist()
    LocalPlayer:GetAttributeChangedSignal("Class"):Connect(updateRampagerBlacklist)
    local Items     = GetSafeModule(Dicts, "Items")
    local Encounters = GetSafeModule(Dicts, "Encounters")
    local Upgrades  = GetSafeModule(Dicts, "Upgrades")
    local CacheFolder = "yuri/AAC"
    local CachePath   = CacheFolder .. "/cache.json"
    local WIKI_API = "https://anaveragecampaign.miraheze.org/w/api.php"
    local WIKI_CONCURRENCY = 40
    local function wikiGet(params)
        local qs = {}
        for k, v in pairs(params) do
            table.insert(qs, k .. "=" .. HttpService:UrlEncode(v))
        end
        local url = WIKI_API .. "?" .. table.concat(qs, "&")
        local ok, result = pcall(function() return game:HttpGet(url) end)
        if not ok then return nil end
        local ok2, decoded = pcall(function() return HttpService:JSONDecode(result) end)
        if not ok2 then return nil end
        return decoded
    end
    local function GetAllWikiPageTitles()
        local titles = {}
        local resp = wikiGet({
            action = "query",
            list = "allpages",
            aplimit = "500",
            format = "json",
            formatversion = "2",
        })
        if resp and resp.query and resp.query.allpages then
            for _, page in ipairs(resp.query.allpages) do
                table.insert(titles, page.title)
            end
        end
        return titles
    end
    local function ExtractEnemyFromWikitext(title, wikitext)
        if not wikitext or not wikitext:find("{{EnemyTemplate") then
            return nil
        end
        local nameField = wikitext:match("|Title=%s*([^\n|]-)%s*\n")
        local enemyName = nameField or title
        local modifiers = {}
        local typeField = wikitext:match("|Enemy_Type=%s*([^\n]-)%s*\n")
        if typeField and typeField ~= "" and typeField ~= "?" then
            local linked = typeField:match("%[%[.-|(.-)%]%]")
            if not linked then
                linked = typeField:match("%[%[(.-)%]%]")
            end
            local clean = linked or typeField
            clean = clean:match("^%s*(.-)%s*$")
            if clean ~= "" and clean ~= "?" then
                for _, part in ipairs(clean:split("/")) do
                    part = part:match("^%s*(.-)%s*$")
                    if part ~= "" then table.insert(modifiers, part) end
                end
            end
        end
        local abilities = {}
        for header in wikitext:gmatch('!%s*style="text%-align:center ; background%-color:#012E59"%s*;?%s*colspan="2"%s*|%s*([^\n]-)%s*\n') do
            header = header:match("^%s*(.-)%s*$")
            if header ~= "" and header ~= enemyName then
                table.insert(abilities, header)
            end
        end
        return enemyName, { Modifiers = modifiers, Abilities = abilities }
    end
    local function ExtractModifiersFromWikitext(wikitext)
        if not wikitext then return nil end
        local result = {}
        for modName, affinBlock in wikitext:gmatch("<div class=modifier2>%s*([^<]-)%s*</div>.-<div class=affin>%s*(.-)%s*</div>") do
            local typeMap = {}
            for dmgType, value in affinBlock:gmatch("([%a][%a%s]-)%s+Damage%s+[%+%-][%d%.]+%%%s*|%s*([%d%.]+x)") do
                dmgType = dmgType:match("^%s*(.-)%s*$")
                local num = tonumber(value:match("([%d%.]+)x"))
                if dmgType ~= "" and num then
                    typeMap[dmgType] = num
                end
            end
            for dmgType in affinBlock:gmatch("([%a][%a%s]-)%s+Damage%s+[%+%-][%d%.]+%%%s*|%s*%(IMMUNITY%)") do
                dmgType = dmgType:match("^%s*(.-)%s*$")
                if dmgType ~= "" then
                    typeMap[dmgType] = 0
                end
            end
            for value in affinBlock:gmatch("Healing%s+[%+%-][%d%.]+%%%s*|%s*([%d%.]+x)") do
                local num = tonumber(value:match("([%d%.]+)x"))
                if num then typeMap["Healing"] = num end
            end
            if affinBlock:find("Healing%s+[%+%-][%d%.]+%%%s*|%s*%(IMMUNITY%)") then
                typeMap["Healing"] = 0
            end
            if modName ~= "" and next(typeMap) then
                result[modName] = typeMap
            end
        end
        if not next(result) then return nil end
        return result
    end
    local function FetchWikiData()
        local Enemies = {}
        local Modifiers = nil
        local titles = GetAllWikiPageTitles()
        if #titles == 0 then
            warn("[Enemies] Failed to retrieve page list from wiki")
            return nil, nil
        end
        local index = 1
        local total = #titles
        local threadsRunning = 0
        local doneEvent = Instance.new("BindableEvent")
        local function worker()
            while true do
                local myIndex = index
                index = index + 1
                if myIndex > total then break end
                local title = titles[myIndex]
                local resp = wikiGet({
                    action = "query",
                    titles = title,
                    prop = "revisions",
                    rvprop = "content",
                    format = "json",
                    formatversion = "2",
                })
                if resp and resp.query and resp.query.pages then
                    for _, page in ipairs(resp.query.pages) do
                        if page.revisions and page.revisions[1] then
                            local wikitext = page.revisions[1].content
                            if page.title == "Damage Modifiers" then
                                local dm = ExtractModifiersFromWikitext(wikitext)
                                if dm then Modifiers = dm end
                            else
                                local name, data = ExtractEnemyFromWikitext(page.title, wikitext)
                                if name then
                                    Enemies[name] = data
                                end
                            end
                        end
                    end
                end
            end
            threadsRunning -= 1
            if threadsRunning <= 0 then
                doneEvent:Fire()
            end
        end
        threadsRunning = WIKI_CONCURRENCY
        for i = 1, WIKI_CONCURRENCY do
            task.spawn(worker)
        end
        doneEvent.Event:Wait()
        return Enemies, Modifiers
    end
    local WIKI_CACHE_MAX_AGE = 24 * 60 * 60 
    local WikiEnemies, WikiModifiers
    local function LoadWikiData()
        if isfile(CachePath) then
            local ok, cached = pcall(function() return HttpService:JSONDecode(readfile(CachePath)) end)
            if ok and cached and cached.Enemies and next(cached.Enemies) and cached.At then
                local age = os.time() - cached.At
                if age < WIKI_CACHE_MAX_AGE then
                    return cached.Enemies, cached.Modifiers
                end
            end
        end
        local freshEnemies, freshModifiers = FetchWikiData()
        if freshEnemies and next(freshEnemies) then
            if not isfolder(CacheFolder) then makefolder(CacheFolder) end
            writefile(CachePath, HttpService:JSONEncode({
                At = os.time(),
                Enemies = freshEnemies,
                Modifiers = freshModifiers,
            }))
            return freshEnemies, freshModifiers
        end
        if isfile(CachePath) then
            local ok, cached = pcall(function() return HttpService:JSONDecode(readfile(CachePath)) end)
            if ok and cached and cached.Enemies and next(cached.Enemies) then
                warn("[Enemies] Wiki fetch failed, falling back to stale cache")
                return cached.Enemies, cached.Modifiers
            end
        end
        warn("[Enemies] Wiki fetch failed and no cache available, using empty Enemies table")
        return {}, nil
    end
    WikiEnemies, WikiModifiers = LoadWikiData()
    local Enemies = WikiEnemies
    local Effects   = GetSafeModule(Dicts, "Effects")
    local GameModifiers = GetSafeModule(Dicts, "GameModifiers")
    local Modifiers = (function()
        local t = WikiModifiers or {}
        function t.CalculateMultiplier(p1, p2)
            local v1 = 1
            for i, v in ipairs(p2) do
                if t[v] and t[v][p1] then
                    if t[v][p1] == 0 then
                        return 0
                    end
                    v1 = v1 * t[v][p1]
                end
            end
            return v1
        end
        return t
    end)()
    local PlayerInventory = Remotes.PlayerInventory
    local InvestStats     = Remotes.InvestStats
    local GetStats        = Remotes.GetStats
    local GetSceneOptions = Remotes.GetSceneOptions
    local SceneEvent      = Remotes.SceneEvent
    local VotingEvent     = Remotes.VotingEvent
    local TurnDecision    = Remotes.TurnDecision
    local FireTurn        = Remotes.FireTurn
    local GetAbilities    = Remotes.GetAbilities
    local AttackFlash     = Remotes.AttackFlash
    local CombatEnd       = Remotes.CombatEnd
    local ChangeUI        = Remotes.ChangeUI
    local ReplayEvent     = Remotes.ReplayEvent
    local GetItems        = Remotes.GetItems
    local UpdateTurn      = Remotes.UpdateTurn
    local Upgrade         = Remotes.Upgrade
    local RemoteCache = {
        GetStats        = nil,
        GetArea         = nil,
        ChangeUI        = nil,
        GetItems        = nil,
        CombatEnd       = nil,
        UpdateTurn      = nil,
        FireTurn        = nil,
        GetAbilities    = nil,
        AttackFlash     = nil,
        PlayerInventory = nil,
        SceneEvent      = nil,
        Achievement     = nil,
        Upgrade         = nil,
    }
    local function ConnectRemote(remote, cacheKey, handler)
        return remote.OnClientEvent:Connect(function(...)
            RemoteCache[cacheKey] = { ... }
            return handler(...)
        end)
    end
    local refreshList
    local refreshAvailableItems
    local prior_path = c_folder .. "/priorities.json"
    local function defaultPriorities()
        return {
            abilities        = {},
            Enemies          = {},
            items            = {},
            upgrades         = {},
            HSAbl = false,
            HSEnemies   = false,
            HSItems     = false,
        }
    end
    local function loadPrior()
        if not isfolder(c_folder) then makefolder(c_folder) end
        if isfile(prior_path) then
            local ok, result = pcall(function() return HttpService:JSONDecode(readfile(prior_path)) end)
            if ok and type(result) == "table" then return result end
        end
        return defaultPriorities()
    end
    local function savePrior(config)
        if not isfolder(c_folder) then makefolder(c_folder) end
        writefile(prior_path, HttpService:JSONEncode(config))
    end
    local prioritiesConfig = loadPrior()
    if not prioritiesConfig.upgrades then prioritiesConfig.upgrades = {} end
    local function getAllAbilities()
        local names = {}
        for name in pairs(Abilities) do table.insert(names, name) end
        table.sort(names)
        return names
    end
    local function getAllItems()
        local names = {}
        for name, data in pairs(Items) do
            if data.Recipe and type(data.Recipe) == "table" then table.insert(names, name) end
        end
        table.sort(names)
        return names
    end
    local function getAllEnemies()
        local names = {}
        for name in pairs(Enemies) do table.insert(names, name) end
        table.sort(names)
        return names
    end
    local function getAllUpgrades()
        local names = {}
        for name in pairs(Upgrades) do
            if name ~= "Template" then table.insert(names, name) end
        end
        table.sort(names)
        return names
    end
    local function initializePriorityList(configList, allItems)
        local result = {}
        local used   = {}
        for _, item in ipairs(configList) do
            if table.find(allItems, item) then
                table.insert(result, item)
                used[item] = true
            end
        end
        return result
    end
    local function PLAYER_WEAPON()
        local eq = Shared.Equip
        if eq and eq.Weapon and eq.Weapon.WeaponType then
            return eq.Weapon.WeaponType
        end
        return nil
    end
    Shared.currentCard = getCC()
    if Shared.ShowPrioritiesSetting then
        local Window = Library:CreateWindow({ Title = "Yuri", Center = true, AutoShow = true, Resizable = true })
        AddInfo(Window)
        local Tabs = {
            Settings   = Window:AddTab("Settings"),
            Priorities = Window:AddTab("Priorities"),
            Encounters = Window:AddTab("Encounters"),
        }
        local SettingsBox = Tabs.Settings:AddLeftGroupbox("Hardset")
        SettingsBox:AddToggle("HardsetAbilities", { Text = "Enable Abilities Hardset", Default = prioritiesConfig.HSAbl })
        Toggles.HardsetAbilities:OnChanged(function()
            prioritiesConfig.HSAbl = Toggles.HardsetAbilities.Value
            savePrior(prioritiesConfig)
        end)
        SettingsBox:AddToggle("HardsetEnemies", { Text = "Enable Enemies Hardset", Default = prioritiesConfig.HSEnemies })
        Toggles.HardsetEnemies:OnChanged(function()
            prioritiesConfig.HSEnemies = Toggles.HardsetEnemies.Value
            savePrior(prioritiesConfig)
        end)
        SettingsBox:AddToggle("HardsetItems", { Text = "Enable Items Hardset", Default = prioritiesConfig.HSItems })
        Toggles.HardsetItems:OnChanged(function()
            prioritiesConfig.HSItems = Toggles.HardsetItems.Value
            savePrior(prioritiesConfig)
        end)
        local function makePrioritySection(parent, title, configKey, allItems)
            local box = parent
            local function buildOrderText()
                local list = prioritiesConfig[configKey]
                if #list == 0 then return "(none)" end
                local lines = {}
                for i, v in ipairs(list) do table.insert(lines, i .. ". " .. v) end
                return table.concat(lines, "\n")
            end
            local orderLabel = box:AddLabel(buildOrderText(), true, configKey .. "_OrderLabel")
            local dropIdx    = configKey .. "_AddDrop"
            local availableNow = {}
            for _, name in ipairs(allItems) do
                if not table.find(prioritiesConfig[configKey], name) then
                    table.insert(availableNow, name)
                end
            end
            box:AddDropdown(dropIdx, { Text = "Select to add", Values = availableNow, Default = {}, Multi = true, Searchable = true })
            box:AddButton({
                Text = "Add Selected to Priority",
                Func = function()
                    for itemName, state in pairs(Options[dropIdx].Value) do
                        if state and not table.find(prioritiesConfig[configKey], itemName) then
                            table.insert(prioritiesConfig[configKey], itemName)
                        end
                    end
                    savePrior(prioritiesConfig)
                    Library.Labels[configKey .. "_OrderLabel"]:SetText(buildOrderText())
                    local newAvail = {}
                    for _, name in ipairs(allItems) do
                        if not table.find(prioritiesConfig[configKey], name) then table.insert(newAvail, name) end
                    end
                    Options[dropIdx]:SetValues(newAvail)
                    Options[dropIdx]:SetValue({})
                end,
            })
            box:AddButton({
                Text = "Clear All",
                Func = function()
                    prioritiesConfig[configKey] = {}
                    savePrior(prioritiesConfig)
                    Library.Labels[configKey .. "_OrderLabel"]:SetText(buildOrderText())
                    Options[dropIdx]:SetValues(allItems)
                    Options[dropIdx]:SetValue({})
                end,
            })
            local removeIdx = configKey .. "_RemoveDrop"
            box:AddDropdown(removeIdx, { Text = "Select to remove", Values = prioritiesConfig[configKey], Default = 1, Multi = false, Searchable = true })
            box:AddButton({
                Text = "Remove Selected",
                Func = function()
                    local target = Options[removeIdx].Value
                    local idx    = table.find(prioritiesConfig[configKey], target)
                    if idx then
                        table.remove(prioritiesConfig[configKey], idx)
                        savePrior(prioritiesConfig)
                        Library.Labels[configKey .. "_OrderLabel"]:SetText(buildOrderText())
                        Options[removeIdx]:SetValues(prioritiesConfig[configKey])
                        Options[removeIdx]:SetValue(prioritiesConfig[configKey][1] or "")
                        local newAvail = {}
                        for _, name in ipairs(allItems) do
                            if not table.find(prioritiesConfig[configKey], name) then table.insert(newAvail, name) end
                        end
                        Options[dropIdx]:SetValues(newAvail)
                    end
                end,
            })
        end
        local PriTab = Tabs.Priorities:AddLeftTabbox()
        local AbTab  = PriTab:AddTab("Abilities")
        local EnTab  = PriTab:AddTab("Enemies")
        local ItTab  = PriTab:AddTab("Items")
        local UpTab  = PriTab:AddTab("Upgrades")
        makePrioritySection(AbTab, "Abilities Priority", "abilities", getAllAbilities())
        makePrioritySection(EnTab, "Enemies Priority",   "Enemies",   getAllEnemies())
        makePrioritySection(ItTab, "Items Priority",     "items",     getAllItems())
        makePrioritySection(UpTab, "Upgrades Priority",  "upgrades",  getAllUpgrades())
        do
            if not Shared.config.EncountersPick then Shared.config.EncountersPick = {} end
            Shared.EncountersPick = Shared.config.EncountersPick
            local function saveEncountersConfig()
                Shared.EncountersPick = Shared.config.EncountersPick
                local configPath = c_folder .. "/" .. Shared.currentCard .. ".json"
                if Shared.currentCard == "default_card" then configPath = d_card_path end
                writefile(configPath, HttpService:JSONEncode(Shared.config))
            end
            local function getAllEncounterNames()
                local names = {}
                for name in pairs(Encounters) do table.insert(names, name) end
                table.sort(names)
                return names
            end
            local function getScenesForEncounter(encName)
                local encData = Encounters[encName]
                if not encData then return {} end
                local seen, scenes = {}, {}
                for _, sceneData in pairs(encData) do
                    if type(sceneData) == "table" and sceneData.Options then
                        local count = 0
                        for _ in pairs(sceneData.Options) do count += 1 end
                        if count > 1 then
                            for optKey in pairs(sceneData.Options) do
                                if not seen[optKey] then seen[optKey] = true table.insert(scenes, optKey) end
                            end
                        end
                    end
                end
                table.sort(scenes)
                return scenes
            end
            local allEncNames = getAllEncounterNames()
            local function buildSummaryText()
                local lines = {}
                for encName, data in pairs(Shared.config.EncountersPick) do
                    local sp     = data.ScenesPick and table.concat(data.ScenesPick, ", ") or ""
                    local reqs   = {}
                    for stat, val in pairs(data.Requirements or {}) do table.insert(reqs, stat .. val) end
                    local reqStr = #reqs > 0 and (" | reqs: " .. table.concat(reqs, ", ")) or ""
                    table.insert(lines, encName .. ": [" .. sp .. "]" .. reqStr)
                end
                if #lines == 0 then return "(none configured)" end
                table.sort(lines)
                return table.concat(lines, "\n")
            end
            local function getSavedEncounterNames()
                local names = {}
                for name in pairs(Shared.config.EncountersPick) do table.insert(names, name) end
                table.sort(names)
                return names
            end
            local function refreshReqEncDrop()
                local saved = getSavedEncounterNames()
                Options.EP_ReqEncDrop:SetValues(saved)
                Options.EP_ReqEncDrop:SetValue(saved[1] or "")
            end
            local EncTabbox = Tabs.Encounters:AddLeftTabbox()
            local PickTab   = EncTabbox:AddTab("Pick")
            local ReqsTab   = EncTabbox:AddTab("Reqs")
            local summaryLabel = PickTab:AddLabel(buildSummaryText(), true, "EP_SummaryLabel")
            PickTab:AddDropdown("EP_EncDrop", { Text = "Encounters", Values = allEncNames, Default = 1, Multi = false, Searchable = true })
            PickTab:AddDropdown("EP_SceneDrop", { Text = "Preferred scenes", Values = {}, Default = 1, Multi = true, Searchable = true })
            Options.EP_EncDrop:OnChanged(function()
                local enc    = Options.EP_EncDrop.Value
                local scenes = getScenesForEncounter(enc)
                Options.EP_SceneDrop:SetValues(scenes)
                local saved    = Shared.config.EncountersPick[enc] and Shared.config.EncountersPick[enc].ScenesPick or {}
                local preselect = {}
                for _, s in ipairs(saved) do preselect[s] = true end
                Options.EP_SceneDrop:SetValue(preselect)
            end)
            PickTab:AddButton({
                Text = "Save Scene Prefs",
                Func = function()
                    local enc = Options.EP_EncDrop.Value
                    if not enc or enc == "" then return end
                    local picks = {}
                    for sceneName, state in pairs(Options.EP_SceneDrop.Value) do
                        if state then table.insert(picks, sceneName) end
                    end
                    table.sort(picks)
                    if not Shared.config.EncountersPick[enc] then Shared.config.EncountersPick[enc] = {} end
                    Shared.config.EncountersPick[enc].ScenesPick = picks
                    saveEncountersConfig()
                    refreshReqEncDrop()
                    Library.Labels["EP_SummaryLabel"]:SetText(buildSummaryText())
                end,
            })
            PickTab:AddButton({
                Text = "Remove Encounter",
                Func = function()
                    local enc = Options.EP_EncDrop.Value
                    if not enc or enc == "" then return end
                    Shared.config.EncountersPick[enc] = nil
                    saveEncountersConfig()
                    refreshReqEncDrop()
                    Library.Labels["EP_SummaryLabel"]:SetText(buildSummaryText())
                end,
            })
            PickTab:AddButton({
                Text = "Clear All",
                Func = function()
                    Shared.config.EncountersPick = {}
                    saveEncountersConfig()
                    refreshReqEncDrop()
                    Library.Labels["EP_SummaryLabel"]:SetText(buildSummaryText())
                end,
            })
            local statKeys = {
                "Level", "HP", "MaxHP", "STR", "DEX", "CON", "INT", "FTH", "CHA", "LCK",
                "Initiative", "Accuracy", "CritChance", "CritDamage", "DodgeChance", "BlockChance",
                "Lifesteal", "EXP", "GoldIncome", "BlockDR", "EnergyGain"
            }
            ReqsTab:AddDropdown("EP_ReqEncDrop", { Text = "Encounter", Values = getSavedEncounterNames(), Default = 1, Multi = false, Searchable = true })
            ReqsTab:AddDropdown("EP_StatDrop",   { Text = "Stat",      Values = statKeys, Default = 1, Multi = false })
            ReqsTab:AddDropdown("EP_OpDrop",     { Text = "Operator",  Values = { ">=", "<=", ">", "<", "==" }, Default = 1, Multi = false })
            ReqsTab:AddInput("EP_ValInput",      { Text = "Value",     Default = "0", Numeric = true, Finished = false, Placeholder = "0" })
            ReqsTab:AddButton({
                Text = "Add Requirement",
                Func = function()
                    local enc  = Options.EP_ReqEncDrop.Value
                    local stat = Options.EP_StatDrop.Value
                    local op   = Options.EP_OpDrop.Value
                    local val  = Options.EP_ValInput.Value
                    if not enc or enc == "" or not stat or not op or not val or val == "" then return end
                    if not Shared.config.EncountersPick[enc] then Shared.config.EncountersPick[enc] = {} end
                    if not Shared.config.EncountersPick[enc].Requirements then Shared.config.EncountersPick[enc].Requirements = {} end
                    Shared.config.EncountersPick[enc].Requirements[stat] = op .. val
                    saveEncountersConfig()
                    Library.Labels["EP_SummaryLabel"]:SetText(buildSummaryText())
                end,
            })
            ReqsTab:AddButton({
                Text = "Remove Requirement",
                Func = function()
                    local enc  = Options.EP_ReqEncDrop.Value
                    local stat = Options.EP_StatDrop.Value
                    if not enc or enc == "" or not stat then return end
                    if Shared.config.EncountersPick[enc] and Shared.config.EncountersPick[enc].Requirements then
                        Shared.config.EncountersPick[enc].Requirements[stat] = nil
                    end
                    saveEncountersConfig()
                    Library.Labels["EP_SummaryLabel"]:SetText(buildSummaryText())
                end,
            })
        end
        Shared.PrioritiesConfig = prioritiesConfig
    end
    local function isBuffEffect(effectName)
        local e = Effects[effectName]
        if not e then return false end
        if e["Type"] == "DoT" or e["Type"] == "HoT" then return false end
        if e["DamageValue"] and e["DamageValue"] > 1 then return true end
        if e["Value"]       and e["Value"] > 1       then return true end
        if e["ScalingValue"]and e["ScalingValue"] > 0 then return true end
        return false
    end
    local function isHoTEffect(effectName)
        local e = Effects[effectName]
        return e and e["Type"] == "HoT"
    end
    local function isDoTEffect(effectName)
        local e = Effects[effectName]
        return e and e["Type"] == "DoT"
    end
    task.spawn(function()
        if not LocalPlayer:GetAttribute("isLoaded") then
            LocalPlayer:GetAttributeChangedSignal("isLoaded"):Wait()
        end
        scriptStartTime = tick()
        achievements    = {}
        do
            if isfile(buildPath) then
                local ok, b = pcall(function() return HttpService:JSONDecode(readfile(buildPath)) end)
                cealtAtDungeonStart = (ok and b and b.cealts) or 0
            end
        end
        VotingEvent:FireServer("Start Game")
    end)
    local function getOurSummon()
        for _, s in ipairs(Workspace.Summons:GetChildren()) do
            if s:GetAttribute("isAlive") and s:GetAttribute("Summoner") == LocalPlayer.Name then
                return s
            end
        end
        return nil
    end
    local function countAliveAllies()
        local count = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p:GetAttribute("isAlive") then count += 1 end
        end
        for _, s in ipairs(Workspace.Summons:GetChildren()) do
            if s:GetAttribute("isAlive") and s:GetAttribute("Summoner") == LocalPlayer.Name then count += 1 end
        end
        return math.max(count, 1)
    end
    local function isSTurn()
        if Shared.currentHighlight then
            for _, s in ipairs(Workspace.Summons:GetChildren()) do
                if s:GetAttribute("isAlive") and s:GetAttribute("Summoner") == LocalPlayer.Name then
                    if Shared.currentHighlight == s.Name .. "_" .. LocalPlayer.Name then
                        Shared.SummonRef = s
                        return true
                    end
                end
            end
        end
        return Shared.isSummonTurn
    end
    local function DmgMulti()
        local mult = 1.0
        for effectName, e in pairs(Effects) do
            if LocalPlayer:GetAttribute(effectName) then
                local dv = e["DamageValue"]
                local sv = e["ScalingValue"]
                if dv then
                    if sv then
                        local statSum = 0
                        for _, s in ipairs({"STR","DEX","INT","FTH","CHA","LCK"}) do
                            statSum += (Shared.currentStats[s] or LocalPlayer:GetAttribute(s) or 0)
                        end
                        local bonus = dv + sv * (statSum / 6)
                        if bonus > 0 then
                            mult = mult * (1 + bonus)
                        elseif bonus < 0 then
                            mult = mult * math.max(0.01, 1 + bonus)
                        end
                    else
                        mult = mult * math.max(0.01, dv)
                    end
                elseif e["Value"] and e["Value"] > 1 then
                    mult = mult * e["Value"]
                end
            end
        end
        return mult
    end
    local function EnemyDebuffMulti(enemy)
        if not enemy then return 1 end
        local mult = 1.0
        for effectName, e in pairs(Effects) do
            if enemy:GetAttribute(effectName) then
                if e["Value"] and not e["DamageValue"] and e["Value"] ~= 1 then
                    mult = mult * e["Value"]
                end
                if e["DefenseValue"] and e["DefenseValue"] ~= 1 then
                    mult = mult * e["DefenseValue"]
                end
            end
        end
        return mult
    end
    local function OpsModifier(enemy, damageType)
        if not enemy or not damageType then return 1 end
        local data = Enemies[enemy.Name]
        if not data or not data.Modifiers then return 1 end
        return Modifiers.CalculateMultiplier(damageType, data.Modifiers) 
    end
    local function estDmg(data, applyBuffs, enemy)
        local base     = data.Damage or 0
        local scaling  = data.Scaling or {}
        local multihit = data.Multihit or 1
        local statBonus = 0
        for statName, multiplier in pairs(scaling) do
            statBonus += (Shared.currentStats[statName] or LocalPlayer:GetAttribute(statName) or 0) * multiplier
        end
        local raw = base * (1 + statBonus) * multihit
        if data.EnergyDamageScaling and data.Cost == "X" then
            local energy = LocalPlayer:GetAttribute("Energy") or 0
            local exp    = data.EnergyExponent or 1
            local expScl = data.EnergyExponentScaling or 0
            raw = raw + data.EnergyDamageScaling * (energy ^ exp) * (1 + energy * expScl)
        end
        if applyBuffs then raw = raw * DmgMulti() end
        if enemy then
            raw = raw * EnemyDebuffMulti(enemy)
            if data.DamageType then raw = raw * OpsModifier(enemy, data.DamageType) end
        end
        return raw
    end
    local function estHeal(data)
        local maxHp     = LocalPlayer:GetAttribute("MaxHP") or 1
        local effects   = data.Effects or {}
        local flat      = effects["Heal"] or 0
        local maxHealPc = effects["MaxHeal"] or 0
        local baseHeal  = flat + maxHp * maxHealPc
        local scaling   = data.Scaling or {}
        local statBonus = 0
        for statName, multiplier in pairs(scaling) do
            statBonus += (Shared.currentStats[statName] or LocalPlayer:GetAttribute(statName) or 0) * multiplier
        end
        return baseHeal * (1 + statBonus)
    end
    local function estDoT(effectName, target)
        local e = Effects[effectName]
        if not e or e["Type"] ~= "DoT" then return 0 end
        if e["Formula"] then
            local evalTarget = target or LocalPlayer
            local ok, result = pcall(e["Formula"], evalTarget)
            if ok and type(result) == "number" then return result end
            if evalTarget and evalTarget:GetAttribute(effectName) == nil then
                local fakeTarget = setmetatable({}, {
                    __index = function(_, k)
                        if k == "GetAttribute" then
                            return function(_, attr)
                                if attr == effectName then return 1 end
                                return evalTarget:GetAttribute(attr)
                            end
                        end
                        return evalTarget[k]
                    end
                })
                local ok2, result2 = pcall(e["Formula"], fakeTarget)
                if ok2 and type(result2) == "number" then return result2 end
            end
        end
        return (e["DamageValue"] and e["DamageValue"] > 0 and e["DamageValue"]) or 1
    end
    local function isBoss()
        local ourMaxHp = LocalPlayer:GetAttribute("MaxHP") or 1
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:GetAttribute("isAlive") then
                if (enemy:GetAttribute("MaxHP") or 0) >= ourMaxHp * 2.5 then return true end
                local enemyDef = Enemies and Enemies[enemy.Name]
                if enemyDef and enemyDef.Modifiers then
                    for _, mod in ipairs(enemyDef.Modifiers) do
                        if mod == "Boss" or mod == "Mini-Boss" then return true end
                    end
                end
            end
        end
        return false
    end
    local function hasHS()
        if prioritiesConfig.HSEnemies and #prioritiesConfig.Enemies > 0 then
            for _, enemyName in ipairs(prioritiesConfig.Enemies) do
                for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
                    if enemy.Name == enemyName and enemy:GetAttribute("isAlive") then return true end
                end
            end
        end
        return false
    end
    local function getThreatScore(enemy)
        local hp, maxHp  = enemy:GetAttribute("HP") or 1, enemy:GetAttribute("MaxHP") or 1
        local hpRatio    = hp / maxHp
        local baseScore  = (1 - hpRatio) * 100 + ((hpRatio < 0.3) and 50 or 0)
        local enemyDef   = Enemies[enemy.Name]
        local ourMaxHp   = LocalPlayer:GetAttribute("MaxHP") or 1
        local totalDmg, abilCount = 0, 0
        if enemyDef and enemyDef.Abilities then
            for _, abilityName in ipairs(enemyDef.Abilities) do
                local data = Abilities[abilityName]
                if data then
                    local dmg = estDmg(data, false, nil)
                    if data.Effects then
                        for effectName in pairs(data.Effects) do
                            dmg = dmg + estDoT(effectName, LocalPlayer) * 2
                        end
                    end
                    totalDmg  += dmg
                    abilCount += 1
                end
            end
        end
        if abilCount > 0 then baseScore += (totalDmg / abilCount) / ourMaxHp * 100 end
        return baseScore
    end
    local function getBestTarget()
        if prioritiesConfig.HSEnemies and #prioritiesConfig.Enemies > 0 then
            for _, enemyName in ipairs(prioritiesConfig.Enemies) do
                for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
                    if enemy.Name == enemyName and enemy:GetAttribute("isAlive") then return enemy end
                end
            end
        end
        local bestEnemy, bestScore = nil, -1
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:GetAttribute("isAlive") then
                local score = getThreatScore(enemy)
                if score > bestScore then bestScore = score bestEnemy = enemy end
            end
        end
        return bestEnemy
    end
    local function canKill(enemy, abilityData)
        return estDmg(abilityData, true, enemy) >= (enemy:GetAttribute("HP") or math.huge) - 0.01
    end
    local function getKS()
        local energy   = LocalPlayer:GetAttribute("Energy") or 0
        local abilities = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
        local hs = hasHS()
        local checkAbilities
        if hs and prioritiesConfig.HSAbl and #prioritiesConfig.abilities > 0 then
            checkAbilities = {}
            for _, aName in ipairs(prioritiesConfig.abilities) do
                if table.find(abilities, aName) then table.insert(checkAbilities, aName) end
            end
        else
            checkAbilities = abilities
        end
        local function tryKillOnEnemies(enemyList)
            for _, enemy in ipairs(enemyList) do
                if enemy:GetAttribute("isAlive") then
                    for _, abilityName in ipairs(checkAbilities) do
                        local data = Abilities[abilityName]
                        if data then
                            local cost       = data.Cost == "X" and energy or data.Cost
                            local targetType = data.TargetType or ""
                            local isOff      = (targetType == "SingleEnemy" or targetType == "AllEnemy")
                            if isOff and cost <= energy and (Shared.pCD[abilityName] or 0) == 0 and canKill(enemy, data) then
                                return abilityName, enemy
                            end
                        end
                    end
                end
            end
            return nil, nil
        end
        if hs then
            local enemiesList = {}
            for _, enemyName in ipairs(prioritiesConfig.Enemies) do
                for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
                    if enemy.Name == enemyName and enemy:GetAttribute("isAlive") then table.insert(enemiesList, enemy) end
                end
            end
            local ab, tar = tryKillOnEnemies(enemiesList)
            if ab then return ab, tar end
        end
        local allEnemies = {}
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:GetAttribute("isAlive") then table.insert(allEnemies, enemy) end
        end
        return tryKillOnEnemies(allEnemies)
    end
    local function getBestAbility(target)
        local hs = false
        if prioritiesConfig.HSEnemies and #prioritiesConfig.Enemies > 0 then
            for _, enemyName in ipairs(prioritiesConfig.Enemies) do
                for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
                    if enemy.Name == enemyName and enemy:GetAttribute("isAlive") then hs = true break end
                end
                if hs then break end
            end
        end
        local energy    = LocalPlayer:GetAttribute("Energy") or 0
        local abilities = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
        if hs and prioritiesConfig.HSAbl and #prioritiesConfig.abilities > 0 then
            for _, abilityName in ipairs(prioritiesConfig.abilities) do
                if table.find(abilities, abilityName) then
                    local data = Abilities[abilityName]
                    if data then
                        local cost       = data.Cost == "X" and energy or data.Cost
                        local targetType = data.TargetType or ""
                        local isOff      = (targetType == "SingleEnemy" or targetType == "AllEnemy")
                        if isOff and cost <= energy and (Shared.pCD[abilityName] or 0) == 0 then return abilityName end
                    end
                end
            end
            return nil
        end
        local best, bestDamage = nil, -1
        for _, abilityName in ipairs(abilities) do
            local data = Abilities[abilityName]
            if data then
                local cost       = data.Cost == "X" and energy or data.Cost
                local targetType = data.TargetType or ""
                local isOff      = (targetType == "SingleEnemy" or targetType == "AllEnemy")
                if isOff and cost <= energy and (Shared.pCD[abilityName] or 0) == 0 then
                    local dmg = estDmg(data, true, target)
                    if dmg > bestDamage then bestDamage = dmg best = abilityName end
                end
            end
        end
        return best
    end
    local function getBestB()
        local energy    = LocalPlayer:GetAttribute("Energy") or 0
        local abilities = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
        for _, abilityName in ipairs(abilities) do
            local data = Abilities[abilityName]
            if data and (data.TargetType == "Self" or data.TargetType == "SingleAlly") then
                local cost = data.Cost == "X" and energy or (data.Cost or 0)
                if cost <= energy and (Shared.pCD[abilityName] or 0) == 0 then
                    local effects = data.Effects or {}
                    if effects["Heal"] then continue end
                    for effectName in pairs(effects) do
                        if (isBuffEffect(effectName) or isHoTEffect(effectName)) and not LocalPlayer:GetAttribute(effectName) then
                            return abilityName
                        end
                    end
                end
            end
        end
        return nil
    end
    local function scoreSummon(SummonName)
        local data = Enemies[SummonName]
        if not data then return 0 end
        local score = data.MaxHealth or 0
        if data.Abilities then
            for _, abilityName in ipairs(data.Abilities) do
                local abilData = Abilities[abilityName]
                if abilData then score += (abilData.Damage or 0) end
            end
        end
        return score
    end
    local function getSummon()
        if getOurSummon() then return nil end
        local energy    = LocalPlayer:GetAttribute("Energy") or 0
        local abilities = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
        local bestAbility, bestScore = nil, -1
        for _, abilityName in ipairs(abilities) do
            local data = Abilities[abilityName]
            if data and data.TargetType == "Summon" then
                local cost = data.Cost == "X" and energy or (data.Cost or 0)
                if cost <= energy and (Shared.pCD[abilityName] or 0) == 0 then
                    local score = data.SummonName and scoreSummon(data.SummonName) or 0
                    if score > bestScore then bestScore = score bestAbility = abilityName end
                end
            end
        end
        return bestAbility
    end
    local function getLowestHealthAlly()
        local best, bestRatio = nil, math.huge
        local function consider(entity)
            if entity and entity:GetAttribute("isAlive") then
                local hp    = entity:GetAttribute("HP") or 0
                local maxhp = entity:GetAttribute("MaxHP") or 1
                local ratio = hp / math.max(maxhp, 1)
                if ratio < bestRatio then bestRatio = ratio best = entity end
            end
        end
        for _, p in ipairs(Players:GetPlayers()) do consider(p) end
        for _, s in ipairs(Workspace.Summons:GetChildren()) do
            if s:GetAttribute("Summoner") == LocalPlayer.Name then consider(s) end
        end
        return best or LocalPlayer
    end
    local function getHealTarget(abilityData)
        local targetType = abilityData.TargetType or ""
        if Shared.HealTarget == "Lowest" and (targetType == "Self" or targetType == "SingleAlly") then
            return getLowestHealthAlly()
        end
        return LocalPlayer
    end
    local function getHealAbility()
        local hp, maxHp  = LocalPlayer:GetAttribute("HP"), LocalPlayer:GetAttribute("MaxHP")
        if hp >= maxHp then return nil end
        local missing    = maxHp - hp
        local energy     = LocalPlayer:GetAttribute("Energy") or 0
        local abilities  = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
        local bestAbility, bestTarget, bestScore = nil, LocalPlayer, -1
        for _, abilityName in ipairs(abilities) do
            local data = Abilities[abilityName]
            if data then
                local targetType   = data.TargetType or ""
                local isHealTarget = (targetType == "Self" or targetType == "SingleAlly" or targetType == "AllAlly")
                local effects      = data.Effects or {}
                local hasHeal      = effects["Heal"] ~= nil
                local hasBuff      = false
                for effectName in pairs(effects) do
                    if isBuffEffect(effectName) then hasBuff = true break end
                end
                if isHealTarget and hasHeal and not hasBuff then
                    local cost = data.Cost == "X" and energy or (data.Cost or 0)
                    if cost <= energy and (Shared.pCD[abilityName] or 0) == 0 then
                        local HealVal   = estHeal(data)
                        local totalHeal = (targetType == "AllAlly") and (HealVal * countAliveAllies()) or HealVal
                        if totalHeal > 0 and missing > 0 and (hp + HealVal) <= maxHp - 1 then
                            if totalHeal > bestScore then
                                bestScore   = totalHeal
                                bestAbility = abilityName
                                bestTarget  = getHealTarget(data)
                            end
                        end
                    end
                end
            end
        end
        return bestAbility, bestTarget
    end
    local function getBuffHealAbility()
        local hp, maxHp = LocalPlayer:GetAttribute("HP") or 1, LocalPlayer:GetAttribute("MaxHP") or 1
        if hp >= maxHp then return nil end
        local energy    = LocalPlayer:GetAttribute("Energy") or 0
        local abilities = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
        local bestAbility, bestScore = nil, -1
        for _, abilityName in ipairs(abilities) do
            local data = Abilities[abilityName]
            if data then
                local targetType   = data.TargetType or ""
                local isHealTarget = (targetType == "Self" or targetType == "SingleAlly" or targetType == "AllAlly")
                local effects      = data.Effects or {}
                local hasHeal      = effects["Heal"] ~= nil
                local hasHoT, hasBuff = false, false
                for effectName in pairs(effects) do
                    if isHoTEffect(effectName) then hasHoT = true end
                    if isBuffEffect(effectName) then hasBuff = true end
                end
                if isHealTarget and (hasHeal or hasHoT) and hasBuff then
                    local cost = data.Cost == "X" and energy or (data.Cost or 0)
                    if cost <= energy and (Shared.pCD[abilityName] or 0) == 0 then
                        if hasHeal then
                            local HealVal   = estHeal(data)
                            local totalHeal = (targetType == "AllAlly") and (HealVal * countAliveAllies()) or HealVal
                            if totalHeal > 0 and (hp + HealVal) <= maxHp - 1 and totalHeal > bestScore then
                                bestScore   = totalHeal
                                bestAbility = abilityName
                            end
                        else
                            if 1 > bestScore then bestScore = 1 bestAbility = abilityName end
                        end
                    end
                end
            end
        end
        return bestAbility
    end
    local function isWFE(checkerFn)
        local energy    = LocalPlayer:GetAttribute("Energy") or 0
        local abilities = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
        for _, abilityName in ipairs(abilities) do
            local data = Abilities[abilityName]
            if data then
                local cost       = data.Cost == "X" and energy or (data.Cost or 0)
                local onCooldown = (Shared.pCD[abilityName] or 0) > 0
                if not onCooldown and cost > energy then
                    if checkerFn(abilityName, data) then return true end
                end
            end
        end
        return false
    end
    local function isSummonAbility(_, data)   return data.TargetType == "Summon" end
    local function isHealAbilityCheck(_, data)
        local hp, maxHp = LocalPlayer:GetAttribute("HP") or 1, LocalPlayer:GetAttribute("MaxHP") or 1
        if hp >= maxHp then return false end
        local effects    = data.Effects or {}
        local hasHeal    = effects["Heal"] ~= nil
        local hasBuff    = false
        for effectName in pairs(effects) do if isBuffEffect(effectName) then hasBuff = true break end end
        local targetType = data.TargetType or ""
        return (targetType == "Self" or targetType == "SingleAlly") and hasHeal and not hasBuff
    end
    local function isBHAC(_, data)
        local hp, maxHp = LocalPlayer:GetAttribute("HP") or 1, LocalPlayer:GetAttribute("MaxHP") or 1
        if hp >= maxHp then return false end
        local effects = data.Effects or {}
        local hasHeal, hasHoT, hasBuff = effects["Heal"] ~= nil, false, false
        for effectName in pairs(effects) do
            if isHoTEffect(effectName) then hasHoT = true end
            if isBuffEffect(effectName) then hasBuff = true end
        end
        local targetType = data.TargetType or ""
        return (targetType == "Self" or targetType == "SingleAlly") and (hasHeal or hasHoT) and hasBuff
    end
    local function isBuff(_, data)
        if data.TargetType ~= "Self" and data.TargetType ~= "SingleAlly" then return false end
        local effects = data.Effects or {}
        if effects["Heal"] then return false end
        for effectName in pairs(effects) do
            if (isBuffEffect(effectName) or isHoTEffect(effectName)) and not LocalPlayer:GetAttribute(effectName) then
                return true
            end
        end
        return false
    end
    local function findCon(mode)
        local bestKey, bestValue = nil, -1
        for itemName, itemEntry in pairs(Shared.combatInventory) do
            local data = Items[itemName]
            if data and data.Slot == "Consumable" and not data.CampConsumable then
                local effects = data.Effects or {}
                local hasHeal = effects["Heal"] ~= nil
                local fireKey = type(itemEntry) == "table" and itemEntry.fireKey or itemName
                if mode == "Heal" and hasHeal then
                    local HealVal = effects["Heal"] or 0
                    if HealVal > bestValue then bestValue = HealVal bestKey = fireKey end
                elseif mode == "Buff" and not hasHeal then
                    return fireKey
                end
            end
        end
        return bestKey
    end
    local function getCon()
        local hp, maxHp = LocalPlayer:GetAttribute("HP") or 1, LocalPlayer:GetAttribute("MaxHP") or 1
        if Shared.PotionUseThreshold and hp / maxHp < Shared.PotionUseThreshold / 100 then
            local item = findCon("Heal")
            if item then return item end
        end
        if not Shared.BuffUsedThisFight and isBoss() then
            local item = findCon("Buff")
            if item then Shared.BuffUsedThisFight = true return item end
        end
        return nil
    end
    local function shouldBlock()
        local ourMaxHp = LocalPlayer:GetAttribute("MaxHP") or 1
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            if enemy:GetAttribute("isAlive") then
                local enemyDef    = Enemies[enemy.Name]
                local enemyEnergy = enemy:GetAttribute("Energy") or 0
                if enemyDef and enemyDef.Abilities then
                    for _, abilityName in ipairs(enemyDef.Abilities) do
                        local data = Abilities[abilityName]
                        if data and data.Cost and data.Cost >= Shared.BlockPredictions then
                            if data.Effects and data.Effects["Heal"] then continue end
                            if not Shared.enCD[abilityName] and enemyEnergy >= data.Cost - 1 then
                                if estDmg(data, false, LocalPlayer) > ourMaxHp * (Shared.DamageToBlock / 100) then
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
        return false
    end
    local function takeTurn()
        if not Shared.BOT_ENABLED then return end
        if not LocalPlayer:GetAttribute("Turn") then return end
        local hp, maxHp = LocalPlayer:GetAttribute("HP"), LocalPlayer:GetAttribute("MaxHP")
        local energy    = LocalPlayer:GetAttribute("Energy") or 0
        local hpRatio   = hp / maxHp
        local blkThr    = (Shared.BlockThreshold  or 0) > 0 and (Shared.BlockThreshold  / 100) or nil
        local HealThr   = (Shared.HealThreshold   or 0) > 0 and (Shared.HealThreshold   / 100) or nil
        local saveEnergy = false
        local abilities = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
        dcmm("[takeTurn] HP=%.1f/%.1f (%.0f%%) Energy=%d Abilities=%d latestPlayerData=%s",
            hp, maxHp, hpRatio * 100, energy, #abilities,
            Shared.latestPlayerData ~= nil and "OK" or "NIL")
        if Shared.USE_ABILITIES then
            local hardsetMode = prioritiesConfig.HSAbl and hasHS()
            local killAbility, killTarget = getKS()
            if killAbility and killTarget then
                dcmm("[takeTurn] -> KillShot: %s on %s", tostring(killAbility), tostring(killTarget and killTarget.Name))
                TurnDecision:FireServer("Ability", killTarget, killAbility, false)
                return
            end
            dcmm("[takeTurn] KillShot=none hardsetMode=%s", tostring(hardsetMode))
            if not hardsetMode then
                local SummonAbility = getSummon()
                if SummonAbility and Shared.Summon then
                    dcmm("[takeTurn] -> Summon: %s", tostring(SummonAbility))
                    TurnDecision:FireServer("Ability", LocalPlayer, SummonAbility, false)
                    return
                end
                if Shared.Summon and not getOurSummon() and isWFE(isSummonAbility) then
                    dcmm("[takeTurn] saveEnergy=true (WFE summon)")
                    saveEnergy = true
                end
            end
            if not saveEnergy then
                local HealAbility, HealTarget = getHealAbility()
                if HealAbility and Shared.Heal then
                    dcmm("[takeTurn] -> Heal(1): %s on %s", tostring(HealAbility), tostring(HealTarget and HealTarget.Name or "?"))
                    TurnDecision:FireServer("Ability", HealTarget, HealAbility, false)
                    return
                end
                if Shared.Heal and isWFE(isBHAC) then
                    dcmm("[takeTurn] saveEnergy=true (WFE buff-heal)")
                    saveEnergy = true
                end
            else
                dcmm("[takeTurn] skipping Heal(1) check: saveEnergy=true")
            end
            if not saveEnergy and (not HealThr or hpRatio <= HealThr) then
                local HealAbility2, HealTarget2 = getHealAbility()
                if HealAbility2 and Shared.Heal then
                    dcmm("[takeTurn] -> Heal(2): %s on %s", tostring(HealAbility2), tostring(HealTarget2 and HealTarget2.Name or "?"))
                    TurnDecision:FireServer("Ability", HealTarget2 or LocalPlayer, HealAbility2, false)
                    return
                end
                dcmm("[takeTurn] Heal(2) skipped: HealAbility2=%s HealEnabled=%s HealThr=%s hpRatio=%.2f",
                    tostring(HealAbility2), tostring(Shared.Heal), tostring(HealThr), hpRatio)
                if not saveEnergy and HealAbility2 and isWFE(isHealAbilityCheck) then
                    dcmm("[takeTurn] saveEnergy=true (WFE heal2)")
                    saveEnergy = true
                end
            else
                dcmm("[takeTurn] Heal(2) not needed: saveEnergy=%s HealThr=%s hpRatio=%.2f", tostring(saveEnergy), tostring(HealThr), hpRatio)
            end
            if not hardsetMode then
                if not saveEnergy then
                    local BuffAbility = getBestB()
                    if BuffAbility and Shared.Buff then
                        dcmm("[takeTurn] -> Buff: %s", tostring(BuffAbility))
                        TurnDecision:FireServer("Ability", LocalPlayer, BuffAbility, false)
                        return
                    end
                    if Shared.Buff and isWFE(isBuff) then
                        dcmm("[takeTurn] saveEnergy=true (WFE buff)")
                        saveEnergy = true
                    end
                else
                    dcmm("[takeTurn] skipping Buff check: saveEnergy=true")
                end
            end
        end
        local consumable = getCon()
        if consumable and Shared.PotionUse then
            dcmm("[takeTurn] -> Potion: %s", tostring(consumable))
            TurnDecision:FireServer("Item", LocalPlayer, consumable, false)
            return
        end
        if (not blkThr or hpRatio <= blkThr) and shouldBlock() and Shared.Block then
            dcmm("[takeTurn] -> Guard (shouldBlock): blkThr=%s hpRatio=%.2f", tostring(blkThr), hpRatio)
            TurnDecision:FireServer("Ability", LocalPlayer, "Guard", false)
            return
        end
        if Shared.USE_ABILITIES then
            local target = getBestTarget()
            local abilityName = target and getBestAbility(target) or nil
            dcmm("[takeTurn] Attack check: target=%s ability=%s saveEnergy=%s cdList=%s",
                tostring(target and target.Name or "nil"),
                tostring(abilityName),
                tostring(saveEnergy),
                (function()
                    local cds = {}
                    for k, v in pairs(Shared.pCD) do
                        if v > 0 then table.insert(cds, k .. "=" .. tostring(v)) end
                    end
                    return #cds > 0 and table.concat(cds, ",") or "none"
                end)())
            if target and abilityName then
                TurnDecision:FireServer("Ability", target, abilityName, false)
                return
            end
            if not target then
                dcmm("[takeTurn] WARN: no alive Enemies found in Workspace.Enemies!")
            elseif not abilityName then
                local abilities2 = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
                local energy2    = LocalPlayer:GetAttribute("Energy") or 0
                dcmm("[takeTurn] WARN: getBestAbility returned nil. Energy=%d Abilities:", energy2)
                for _, aName in ipairs(abilities2) do
                    local data = Abilities[aName]
                    if data then
                        local cost       = data.Cost == "X" and energy2 or data.Cost
                        local targetType = data.TargetType or ""
                        local isOff      = (targetType == "SingleEnemy" or targetType == "AllEnemy")
                        local cd         = Shared.pCD[aName] or 0
                        dcmm("  [%s] cost=%s/%d off=%s cd=%d", aName, tostring(cost), energy2, tostring(isOff), cd)
                    else
                        dcmm("  [%s] NOT IN Abilities table", aName)
                    end
                end
            end
        end
        dcmm("[takeTurn] -> Guard (fallback): no attack found saveEnergy=%s USE_ABILITIES=%s",
            tostring(saveEnergy), tostring(Shared.USE_ABILITIES))
        TurnDecision:FireServer("Ability", LocalPlayer, "Guard", false)
    end
    local function takeSTurn()
        if not Shared.BOT_ENABLED then return end
        if not LocalPlayer:GetAttribute("Turn") then return end
        local activeSummon = Shared.SummonRef or getOurSummon()
        if not activeSummon then return end
        local energy    = activeSummon:GetAttribute("Energy") or 0
        local abilities = Shared.latestSummonData and Shared.latestSummonData.Abilities or {}
        local bestAbility, bestDamage = nil, -1
        for _, abilityName in ipairs(abilities) do
            local data = Abilities[abilityName]
            if data then
                local cost       = data.Cost == "X" and energy or (data.Cost or 0)
                local targetType = data.TargetType or ""
                local isOff      = (targetType == "SingleEnemy" or targetType == "AllEnemy")
                if isOff and cost <= energy and (Shared.SummonCooldowns[abilityName] or 0) == 0 then
                    local dmg = estDmg(data, false)
                    if dmg > bestDamage then bestDamage = dmg bestAbility = abilityName end
                end
            end
        end
        local target = getBestTarget()
        if bestAbility and target then
            TurnDecision:FireServer("Ability", target, bestAbility, activeSummon)
        end
    end
    local function invStats()
        local points = LocalPlayer:GetAttribute("StatPoints") or 0
        if points <= 0 then return end
        local enabled, maxPriority = {}, 0
        for stat, priority in pairs(Shared.StatsAllocation) do
            if priority > 0 then
                table.insert(enabled, { stat = stat, priority = priority })
                if priority > maxPriority then maxPriority = priority end
            end
        end
        if #enabled == 0 then return end
        for _, entry in ipairs(enabled) do entry.weight = (maxPriority + 1) - entry.priority end
        local invest = {}
        while points > 0 do
            for _, entry in ipairs(enabled) do
                for _ = 1, entry.weight do
                    if points <= 0 then break end
                    invest[entry.stat] = (invest[entry.stat] or 0) + 1
                    points -= 1
                end
            end
        end
        InvestStats:FireServer(invest)
    end
    local function scoreItemStats(itemData)
        if not itemData.Stats then return 0 end
        local score = 0
        for stat, value in pairs(itemData.Stats) do
            score += value * (Shared.EquipmentsStats[stat] or 0)
        end
        return score
    end
    local function getEquScore(slot)
        local equipped = Shared.Equip[slot]
        if not equipped or equipped == "None" then return 0 end
        local name = type(equipped) == "table" and equipped.Name or equipped
        local data = Items[name]
        return data and scoreItemStats(data) or 0
    end
    local function getCategory(itemData)
        local slot = itemData.Slot
        if not slot then return "Misc" end
        if slot == "Helmet" or slot == "Chestpiece" or slot == "Leggings" or slot == "Boots" then return "Armor" end
        if slot == "Charm" then return "Accessory" end
        if slot == "Consumable" then return "Consumable" end
        if slot == "Weapon" then return (itemData.WeaponType == PLAYER_WEAPON()) and "MyWeapon" or "OtherWeapon" end
        return "Misc"
    end
    local function canCraftFromInventory(itemName)
        local data = Items[itemName]
        if not data or not data.Recipe then return false end
        for ingredient, required in pairs(data.Recipe) do
            local have = 0
            for _, invItem in pairs(Shared.Inv) do
                if invItem.Key and invItem.Key:find(ingredient, 1, true) and not invItem.Unique then
                    have += (invItem.Amount or 1)
                end
            end
            if have < required then return false end
        end
        return true
    end
    local function autoEquip()
        local bestPerSlot = {}
        for invKey, invItem in pairs(Shared.Inv) do
            local itemData = Items[invItem.Name]
            if itemData then
                local slot     = itemData.Slot
                local category = getCategory(itemData)
                if slot and slot ~= "Consumable" and category ~= "OtherWeapon" then
                    local score        = scoreItemStats(itemData)
                    local currentScore = getEquScore(slot)
                    if score - currentScore >= 3 then
                        if not bestPerSlot[slot] or score > bestPerSlot[slot].score then
                            bestPerSlot[slot] = { invKey = invKey, name = invItem.Name, score = score }
                        end
                    end
                end
            end
        end
        for _, best in pairs(bestPerSlot) do
            PlayerInventory:FireServer("EquipItem", best.invKey)
        end
    end
    local function countItemOwned(itemName)
        local total = 0
        for _, invItem in pairs(Shared.Inv) do
            if invItem.Name and invItem.Name:find(itemName, 1, true) then total += (invItem.Amount or 1) end
        end
        return total
    end
    local function ItemOwned(itemName)
        for _, invItem in pairs(Shared.Inv) do
            if invItem.Name and invItem.Name:find(itemName, 1, true) then return true end
        end
        for _, eqItem in pairs(Shared.Equip) do
            if type(eqItem) == "table" and eqItem.Name and eqItem.Name:find(itemName, 1, true) then return true end
        end
        return false
    end
    local function getReqmat(itemName, visited)
        visited = visited or {}
        if visited[itemName] then return {} end
        visited[itemName] = true
        local data = Items[itemName]
        if not data or not data.Recipe then return { [itemName] = 1 } end
        local needed = {}
        for ingredient, amount in pairs(data.Recipe) do
            for mat, cnt in pairs(getReqmat(ingredient, visited)) do
                needed[mat] = (needed[mat] or 0) + cnt * amount
            end
        end
        return needed
    end
    local function bulkCraftItem(targetName)
        local data = Items[targetName]
        if not data or not data.Recipe or targetName == "ItemTemplate" then
            dcmm("[bulkCraftItem] SKIP %s: data=%s recipe=%s", targetName, tostring(data ~= nil), tostring(data and data.Recipe ~= nil))
            return false
        end
        local function craftMissingIntermediates(itemName)
            local itemData = Items[itemName]
            if not itemData or not itemData.Recipe then return true end
            for ingredient, amount in pairs(itemData.Recipe) do
                local have = countItemOwned(ingredient)
                if have < amount then
                    if not craftMissingIntermediates(ingredient) then
                        dcmm("[bulkCraftItem] intermediate craft failed for %s (needed by %s)", ingredient, itemName)
                        return false
                    end
                    have = countItemOwned(ingredient)
                    if have < amount then
                        dcmm("[bulkCraftItem] still missing %s after intermediate craft: need=%d have=%d", ingredient, amount, have)
                        return false
                    end
                end
            end
            if canCraftFromInventory(itemName) and itemName ~= "ItemTemplate" then
                dcmm("[bulkCraftItem] CraftItem intermediate: %s", itemName)
                PlayerInventory:FireServer("CraftItem", itemName)
            end
            return true
        end
        if not craftMissingIntermediates(targetName) then
            dcmm("[bulkCraftItem] craftMissingIntermediates failed for %s", targetName)
            return false
        end
        if canCraftFromInventory(targetName) then
            dcmm("[bulkCraftItem] CraftItem final: %s", targetName)
            PlayerInventory:FireServer("CraftItem", targetName)
            return true
        end
        dcmm("[bulkCraftItem] canCraftFromInventory=false for %s after intermediates", targetName)
        return false
    end
    local function autoCraft()
        local targets = {}
        if prioritiesConfig.HSItems and #prioritiesConfig.items > 0 then
            dcmm("[autoCraft] hardset mode: %d items in list", #prioritiesConfig.items)
            for _, itemName in ipairs(prioritiesConfig.items) do
                local itemData = Items[itemName]
                if itemData and itemData.Recipe and itemName ~= "ItemTemplate" then
                    table.insert(targets, itemName)
                else
                    dcmm("[autoCraft] SKIP hardset item '%s': data=%s recipe=%s", itemName, tostring(itemData ~= nil), tostring(itemData and itemData.Recipe ~= nil))
                end
            end
        else
            for itemName, itemData in pairs(Items) do
                local slot = itemData.Slot
                if slot and slot ~= "Consumable" and itemData.Recipe then
                    if getCategory(itemData) == "OtherWeapon" then continue end
                    if scoreItemStats(itemData) - getEquScore(slot) >= 3 then table.insert(targets, itemName) end
                end
            end
        end
        dcmm("[autoCraft] targets: %d", #targets)
        local craftedAny = false
        for _, itemName in ipairs(targets) do
            if not ItemOwned(itemName) then
                dcmm("[autoCraft] attempting bulkCraftItem: %s", itemName)
                if bulkCraftItem(itemName) then
                    craftedAny = true
                    dcmm("[autoCraft] crafted: %s", itemName)
                else
                    dcmm("[autoCraft] bulkCraftItem FAILED: %s", itemName)
                end
            else
                dcmm("[autoCraft] SKIP %s: already owned/equipped", itemName)
            end
        end
        if craftedAny then autoEquip() end
    end
    local neededMaterialsCache = {}
    local function updateNeededMaterials()
        local desiredEquipment = {}
        if prioritiesConfig.HSItems and #prioritiesConfig.items > 0 then
            local bestPerSlot = {}
            for _, itemName in ipairs(prioritiesConfig.items) do
                local data = Items[itemName]
                if data and data.Slot and data.Slot ~= "Consumable" then
                    local slot  = data.Slot
                    local score = scoreItemStats(data)
                    if not bestPerSlot[slot] or score > bestPerSlot[slot].score then
                        bestPerSlot[slot] = { name = itemName, score = score }
                    end
                end
            end
            for _, best in pairs(bestPerSlot) do
                if best.score > getEquScore(best.name) and not ItemOwned(best.name) then
                    table.insert(desiredEquipment, best.name)
                end
            end
        else
            for itemName, itemData in pairs(Items) do
                if not itemData.Slot or not itemData.Recipe or itemData.Slot == "Consumable" then continue end
                if ItemOwned(itemName) then continue end
                if scoreItemStats(itemData) >= getEquScore(itemData.Slot) + 3 then
                    table.insert(desiredEquipment, itemName)
                end
            end
        end
        local needed = {}
        for _, target in ipairs(desiredEquipment) do
            for mat in pairs(getReqmat(target)) do needed[mat] = true end
        end
        neededMaterialsCache = needed
    end
    local function shouldSellItem(invKey, invItem)
        local itemName = invItem.Name
        local data     = Items[itemName]
        if not data then return false end
        if data.Slot == "Consumable" then return false end
        if data.Slot then
            local curScore = getEquScore(data.Slot)
            if curScore == 0 then return false end
            return scoreItemStats(data) <= curScore
        end
        return not neededMaterialsCache[itemName]
    end
    local function autoShop()
        updateNeededMaterials()
        for invKey, invItem in pairs(Shared.Inv) do
            if shouldSellItem(invKey, invItem) then
                PlayerInventory:FireServer("SellItem", invKey)
            end
        end
        local gold        = LocalPlayer:GetAttribute("Gold") or 0
        local craftTargets = {}
        if prioritiesConfig.HSItems and #prioritiesConfig.items > 0 then
            dcmm("[autoShop] hardset mode: %d items in list, gold=%d", #prioritiesConfig.items, gold)
            for _, itemName in ipairs(prioritiesConfig.items) do
                if Items[itemName] and Items[itemName].Recipe and itemName ~= "ItemTemplate"
                    and not ItemOwned(itemName) then
                    table.insert(craftTargets, itemName)
                else
                    local itemData = Items[itemName]
                    dcmm("[autoShop] SKIP craftTarget '%s': data=%s recipe=%s alreadyOwned=%s",
                        itemName,
                        tostring(itemData ~= nil),
                        tostring(itemData and itemData.Recipe ~= nil),
                        tostring(ItemOwned(itemName)))
                end
            end
            dcmm("[autoShop] craftTargets: %d", #craftTargets)
        else
            for itemName, itemData in pairs(Items) do
                if itemData.Recipe and itemData.Slot and itemData.Slot ~= "Consumable"
                    and not ItemOwned(itemName) then
                    if scoreItemStats(itemData) - getEquScore(itemData.Slot) >= 3 then
                        table.insert(craftTargets, itemName)
                    end
                end
            end
        end
        local totalNeeded = {}
        for _, targetName in ipairs(craftTargets) do
            local mats = getReqmat(targetName)
            if mats then
                for mat, qty in pairs(mats) do totalNeeded[mat] = (totalNeeded[mat] or 0) + qty end
            end
        end
        for mat, needed in pairs(totalNeeded) do
            local missing = needed - countItemOwned(mat)
            if missing > 0 then
                local cost = Shared.shopInventory[mat]
                dcmm("[autoShop] mat '%s': need=%d missing=%d shopCost=%s gold=%d", mat, needed, missing, tostring(cost), LocalPlayer:GetAttribute("Gold") or 0)
                if cost then
                    local buy = math.min(missing, math.floor(gold / cost))
                    dcmm("[autoShop] buying %dx '%s' @ %d each", buy, mat, cost)
                    for _ = 1, buy do
                        if (LocalPlayer:GetAttribute("Gold") or 0) >= cost then
                            PlayerInventory:FireServer("BuyItem", mat)
                        end
                    end
                    gold = LocalPlayer:GetAttribute("Gold") or 0
                else
                    dcmm("[autoShop] mat '%s' not in shop", mat)
                end
            end
        end
        if prioritiesConfig.HSItems then
            for _, targetName in ipairs(craftTargets) do
                local curGold = LocalPlayer:GetAttribute("Gold") or 0
                local itemCost = Shared.shopInventory[targetName]
                local canCraft = canCraftFromInventory(targetName)
                dcmm("[autoShop] directBuy check '%s': inShop=%s canCraft=%s gold=%d cost=%s",
                    targetName, tostring(itemCost ~= nil), tostring(canCraft), curGold, tostring(itemCost))
                if curGold > 0 then
                    if itemCost and not canCraft then
                        if curGold >= itemCost then
                            dcmm("[autoShop] BuyItem direct: %s @ %d", targetName, itemCost)
                            PlayerInventory:FireServer("BuyItem", targetName)
                        else
                            dcmm("[autoShop] not enough gold for '%s': need=%d have=%d", targetName, itemCost, curGold)
                        end
                    end
                end
                gold = LocalPlayer:GetAttribute("Gold") or 0
            end
            return
        end
        local buyQueue = {}
        for itemName, cost in pairs(Shared.shopInventory) do
            local itemData = Items[itemName]
            if not itemData then continue end
            local slot     = itemData.Slot
            local category = getCategory(itemData)
            local priority = 99
            if category == "MyWeapon" then
                if scoreItemStats(itemData) > getEquScore("Weapon") + 3 then priority = 1 end
            elseif category == "Accessory" then
                if scoreItemStats(itemData) > getEquScore("Charm") + 3 then priority = 2 end
            elseif slot == "Consumable" then
                if (itemData.Effects or {})["Heal"] then priority = 3 end
            elseif not slot then
                if totalNeeded[itemName] and totalNeeded[itemName] > 0 then priority = 4 end
            end
            if priority < 99 then
                table.insert(buyQueue, { name = itemName, cost = cost, priority = priority })
            end
        end
        table.sort(buyQueue, function(a, b)
            if a.priority ~= b.priority then return a.priority < b.priority end
            return a.cost < b.cost
        end)
        for _, item in ipairs(buyQueue) do
            if (LocalPlayer:GetAttribute("Gold") or 0) >= item.cost then
                PlayerInventory:FireServer("BuyItem", item.name)
            end
        end
    end
    local function getBuildInfo()
        if isfile(buildPath) then
            local ok, build = pcall(function() return HttpService:JSONDecode(readfile(buildPath)) end)
            if ok and build then return build end
        end
        return {}
    end
    local function doScenePick(p32, p33)
        dcmm("[doScenePick] encounter=%s scene=%s Train=%s", tostring(p32), tostring(p33), tostring(Shared.Train))
        local sceneData = Encounters[p32] and Encounters[p32][p33]
        if not sceneData then return end
        if not sceneData.Options then
            if sceneData.PlayerChoice then
                local chosen = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    local alive = p:GetAttribute("isAlive")
                    if sceneData.PlayerChoice == "Alive" and alive then chosen = p.Name break
                    elseif sceneData.PlayerChoice == "Dead" and not alive then chosen = p.Name break
                    elseif sceneData.PlayerChoice == "All" then chosen = p.Name break
                    end
                end
                if chosen then VotingEvent:FireServer("Scene", chosen) end
            end
            return
        end
        local ScenesPick = nil
        for attempt = 1, 3 do
            ScenesPick = SafeInvoke(GetSceneOptions, sceneData)
            if ScenesPick then break end
            task.wait(0.3)
        end
        if not ScenesPick then return end
        local keys = {}
        for k in pairs(ScenesPick) do table.insert(keys, k) end
        if #keys == 0 then return end
        if #keys == 1 then
            if sceneData.Client then VotingEvent:FireServer("SceneClient", keys[1])
            else VotingEvent:FireServer("Scene", keys[1]) end
            return
        end
        local prefs = nil
        if Shared.EncountersPick then
            for prefKey, prefData in pairs(Shared.EncountersPick) do
                if p32:lower():find(prefKey:lower(), 1, true) then
                    local prefOptions = (type(prefData) == "table" and prefData.ScenesPick) and prefData.ScenesPick or prefData
                    local meetsReqs   = true
                    if type(prefData) == "table" and prefData.ScenesPick then
                        for reqKey, reqVal in pairs(prefData.Requirements or {}) do
                            if reqKey ~= "ScenesPick" then
                                local playerStat = Shared.currentStats[reqKey] or LocalPlayer:GetAttribute(reqKey) or 0
                                if type(reqVal) == "string" then
                                    local op, num = reqVal:match("^([<>]=?)(.+)$")
                                    num = tonumber(num)
                                    if op and num then
                                        if op == ">"  and not (playerStat >  num) then meetsReqs = false break
                                        elseif op == ">=" and not (playerStat >= num) then meetsReqs = false break
                                        elseif op == "<"  and not (playerStat <  num) then meetsReqs = false break
                                        elseif op == "<=" and not (playerStat <= num) then meetsReqs = false break
                                        end
                                    end
                                else
                                    if playerStat < reqVal then meetsReqs = false break end
                                end
                            end
                        end
                    end
                    if meetsReqs then prefs = prefOptions break end
                end
            end
        end
        if Shared.RestThreshold and Shared.RestThreshold > 0 then
            local hp, maxHp = LocalPlayer:GetAttribute("HP"), LocalPlayer:GetAttribute("MaxHP")
            dcmm("[doScenePick] RestThreshold check: hp=%.1f maxHp=%.1f ratio=%.2f thr=%.2f keys=%s",
                hp or 0, maxHp or 0, (hp or 0)/(maxHp or 1), Shared.RestThreshold/100, table.concat(keys, ", "))
            if hp / maxHp <= Shared.RestThreshold / 100 then
                for _, k in ipairs(keys) do
                    if k:lower():find("rest") then
                        dcmm("[doScenePick] -> rest scene at low hp: %s", k)
                        if sceneData.Client then
                            VotingEvent:FireServer("SceneClient", k)
                        else
                            VotingEvent:FireServer("Scene", k)
                        end
                        return
                    end
                end
            end
        end
        if Shared.Train then
            dcmm("[doScenePick] Train=true, keys=%s", table.concat(keys, ", "))
            for _, k in ipairs(keys) do
                if k:lower():find("train") then
                    dcmm("[doScenePick] -> Train scene found: %s", k)
                    if sceneData.Client then VotingEvent:FireServer("SceneClient", k)
                    else VotingEvent:FireServer("Scene", k) end
                    return
                end
            end
            dcmm("[doScenePick] Train=true but no Train key found in keys")
        end
        if prefs then
            for _, preferred in ipairs(prefs) do
                for _, k in ipairs(keys) do
                    if k:lower():find(preferred:lower(), 1, true) then
                        if sceneData.Client then VotingEvent:FireServer("SceneClient", k)
                        else VotingEvent:FireServer("Scene", k) end
                        return
                    end
                end
            end
        end
        table.sort(keys)
        local pick = keys[math.random(1, math.min(3, #keys))]
        if sceneData.Client then VotingEvent:FireServer("SceneClient", pick)
        else VotingEvent:FireServer("Scene", pick) end
    end
    local function doEncounterPick(opts, p33)
        if Shared.EncountersPick then
            for optName in pairs(opts) do
                for prefName, prefData in pairs(Shared.EncountersPick) do
                    if optName:lower():find(prefName:lower(), 1, true) then
                        local meetsReqs = true
                        if type(prefData) == "table" then
                            for reqKey, reqVal in pairs(prefData.Requirements or {}) do
                                if reqKey ~= "ScenesPick" then
                                    local playerStat = Shared.currentStats[reqKey] or LocalPlayer:GetAttribute(reqKey) or 0
                                    if type(reqVal) == "string" then
                                        local op, num = reqVal:match("^([<>]=?)(.+)$")
                                        num = tonumber(num)
                                        if op and num then
                                            if op == ">"  and not (playerStat >  num) then meetsReqs = false break
                                            elseif op == ">=" and not (playerStat >= num) then meetsReqs = false break
                                            elseif op == "<"  and not (playerStat <  num) then meetsReqs = false break
                                            elseif op == "<=" and not (playerStat <= num) then meetsReqs = false break
                                            end
                                        end
                                    else
                                        if playerStat < reqVal then meetsReqs = false break end
                                    end
                                end
                            end
                        end
                        if meetsReqs then
                            VotingEvent:FireServer("Encounter", optName)
                            return
                        end
                    end
                end
            end
        end
        local gold, hp, maxHp = LocalPlayer:GetAttribute("Gold") or 0, LocalPlayer:GetAttribute("HP") or 0, LocalPlayer:GetAttribute("MaxHP") or 1
        local hpRatio = hp / maxHp
        if Shared.GoldToShop and gold >= Shared.GoldToShop then
            for optName, optData in pairs(opts) do
                if optName ~= "ShortRest" and optName ~= "Scavenge" then
                    local nameMatch = optName:lower():match("shop")
                    local descMatch = type(optData) == "table" and optData.Description and optData.Description:lower():match("shop")
                    if nameMatch or descMatch then
                        VotingEvent:FireServer("Encounter", optName)
                        return
                    end
                end
            end
        end
        if opts["ShortRest"] then
            local shortRestsLeft = p33 and p33.ShortRests and p33.ShortRests > 0
            local wantRest  = (Shared.RestThreshold and Shared.RestThreshold > 0 and hpRatio <= Shared.RestThreshold / 100) or Shared.Train
            dcmm("[doEncounterPick] ShortRest: shortRestsLeft=%s wantRest=%s hpRatio=%.2f RestThr=%s Train=%s",
                tostring(shortRestsLeft), tostring(wantRest), hpRatio,
                tostring(Shared.RestThreshold), tostring(Shared.Train))
            if shortRestsLeft and wantRest then
                dcmm("[doEncounterPick] -> picking ShortRest")
                VotingEvent:FireServer("Encounter", "ShortRest")
                return
            end
        end
        if opts["Scavenge"] then
            VotingEvent:FireServer("Encounter", "Scavenge")
            return
        end
        local ScenesPick = {}
        for optName, optData in pairs(opts) do
            if optName ~= "ShortRest" and optName ~= "Scavenge" then
                table.insert(ScenesPick, { name = optName, danger = (type(optData) == "table" and optData.Danger) or 0 })
            end
        end
        if #ScenesPick == 0 then return end
        table.sort(ScenesPick, function(a, b) return a.danger < b.danger end)
        VotingEvent:FireServer("Encounter", ScenesPick[1].name)
    end
    ConnectRemote(GetStats, "GetStats", function(a, b)
        if b == "Self" then Shared.currentStats = a end
    end)
    ConnectRemote(Remotes.GetArea, "GetArea", function(areaName, current, max)
        if not Shared.BOT_ENABLED then return end
        if not Shared.RestartAt then return end
        if areaName == Shared.RestartAtArea and current == Shared.RestartAtFloor then
            ReplayEvent:FireServer()
        end
    end)
    ConnectRemote(ChangeUI, "ChangeUI", function(p19, statsByPlayer, activeModifiers, playerOrder)
        if not Shared.BOT_ENABLED then return end
        if p19 == "GameOver" or p19 == "Win" then
            if Shared.currentCard ~= "default_card" then
                local path = c_folder .. "/" .. Shared.currentCard .. ".json"
                if isfile(path) then delfile(path) end
            end
            local function sendResult()
                progressLoopActive = false
                local WebhookURL = Shared.config.WebhookURL
                if not WebhookURL or WebhookURL == "" then return end
                pcall(function()
                    local myStats = statsByPlayer and statsByPlayer[LocalPlayer.Name]
                    local sum = 1
                    if activeModifiers then
                        for k, active in pairs(activeModifiers) do
                            if active and GameModifiers[k] then
                                sum = sum + GameModifiers[k].CealtGain
                            end
                        end
                    end
                    local multiplier   = math.max(0, sum)
                    local cealtsEarned = math.floor((myStats and myStats.CealtEarned or 0) * multiplier * 1)
                    local amountText   = tostring(cealtsEarned)
                    local build        = getBuildInfo()
                    build.cealts       = (build.cealts or cealtAtDungeonStart) + cealtsEarned
                    writefile(buildPath, HttpService:JSONEncode(build))
                    local elapsed = tick() - scriptStartTime
                    local mins    = math.floor(elapsed / 60)
                    local secs    = math.floor(elapsed % 60)
                    local boonStr = (build.boons and #build.boons > 0) and table.concat(build.boons, ", ") or "None"
                    local achStr  = #achievements > 0 and table.concat(achievements, "\n") or "None"
                    local pingStr = ""
                    if Shared.PingAchievements and #achievements > 0 and (Shared.DiscordId or "") ~= "" then
                        pingStr = "<@" .. Shared.DiscordId .. ">"
                    end
                    local fields = {
                        { name = "Build",         value = "**Class:** " .. (build.class or "?") .. "\n**Race:** " .. (build.race or "?") .. "\n**Prestige:** " .. tostring(build.prestige or 0) .. "\n**Boons:** " .. boonStr, inline = false },
                        { name = "Cealts Earned", value = tostring(build.cealts) .. " (+" .. amountText .. ")", inline = true },
                        { name = "Time",          value = string.format("%dm %02ds", mins, secs), inline = true },
                        { name = "Achievements",  value = achStr, inline = false },
                    }
                    local payload = {
                        content    = pingStr ~= "" and pingStr or nil,
                        username   = "Yuri",
                        avatar_url = yuri[math.random(1, #yuri)],
                        embeds = {{
                            title     = p19 == "Win" and "Run Complete" or "Run Over",
                            color       = math.random(0, 16777215),
                            fields    = fields,
                            thumbnail = { url = yuri[math.random(1, #yuri)] },
                            footer    = { text = string.format("Yuri • %s", os.date("%x %X")) },
                        }}
                    }
                    doRequest(WebhookURL, HttpService:JSONEncode(payload))
                end)
            end
            sendResult()
            ReplayEvent:FireServer()
            task.spawn(function()
                if not LocalPlayer:GetAttribute("isLoaded") then
                    LocalPlayer:GetAttributeChangedSignal("isLoaded"):Wait()
                end
                scriptStartTime = tick()
                achievements    = {}
                do
                    if isfile(buildPath) then
                        local ok, b = pcall(function() return HttpService:JSONDecode(readfile(buildPath)) end)
                        cealtAtDungeonStart = (ok and b and b.cealts) or 0
                    end
                end
                VotingEvent:FireServer("Start Game")
            end)
        end
    end)
    ConnectRemote(Upgrade, "Upgrade", function(p1, p2)
        if not Shared.BOT_ENABLED then return end
        if type(p1) ~= "table" or #p1 == 0 then return end
        local slot   = p1[1]
        local choices = p2 and p2[slot]
        if not choices or #choices == 0 then return end
        local pick = nil
        for _, prefName in ipairs(prioritiesConfig.upgrades) do
            if table.find(choices, prefName) then
                pick = prefName
                break
            end
        end
        if not pick then pick = choices[1] end
        dcmm("[AutoUpgrade] slot=%s pick=%s choices=%s", tostring(slot), tostring(pick), table.concat(choices, ", "))
        Upgrade:FireServer(slot, pick)
    end)
    ConnectRemote(GetItems, "GetItems", function(p238)
        if not Shared.BOT_ENABLED then return end
        Shared.combatInventory = {}
        local inv = p238[LocalPlayer.Name] and p238[LocalPlayer.Name].Inventory
        if not inv then return end
        for uuid, item in pairs(inv) do
            if item.Slot == "Consumable" and (item.Amount or 0) > 0 then
                local baseKey = item.Key or item.Name
                Shared.combatInventory[baseKey] = { amount = item.Amount, fireKey = uuid }
            end
        end
    end)
    ConnectRemote(CombatEnd, "CombatEnd", function()
        if not Shared.BOT_ENABLED then return end
        Shared.enCD            = {}
        Shared.BuffUsedThisFight = false
        Shared.isSummonTurn    = false
        Shared.SummonRef       = nil
        Shared.currentHighlight = nil
    end)
    ConnectRemote(UpdateTurn, "UpdateTurn", function(action, name)
        if not Shared.BOT_ENABLED then return end
        if action == "Highlight" then Shared.currentHighlight = name end
    end)
    ConnectRemote(FireTurn, "FireTurn", function(_, p294, p295)
        if not Shared.BOT_ENABLED then return end
        if p295 then
            Shared.isSummonTurn    = true
            Shared.SummonRef       = p295.Reference
            Shared.SummonCooldowns = p294 or {}
        else
            Shared.isSummonTurn = false
            Shared.SummonRef    = nil
            Shared.pCD          = p294 or {}
            for abilityName, turns in pairs(Shared.enCD) do
                Shared.enCD[abilityName] = turns - 1
                if Shared.enCD[abilityName] <= 0 then Shared.enCD[abilityName] = nil end
            end
        end
        dcmm("[FireTurn] isSummonTurn=%s latestPlayerData=%s", tostring(Shared.isSummonTurn), Shared.latestPlayerData ~= nil and "OK" or "NIL")
        task.spawn(function()
            if not Shared.BOT_ENABLED then return end
            local deadline = tick() + 1.5
            while not LocalPlayer:GetAttribute("Turn") and tick() < deadline do
                task.wait()
            end
            if not LocalPlayer:GetAttribute("Turn") then
                dcmm("[FireTurn] WARN: Turn attr never set after 1.5s, skipping")
                return
            end
            if not Shared.BOT_ENABLED then return end
            if isSTurn() then
                if not Shared.SummonRef then Shared.SummonRef = getOurSummon() end
                takeSTurn()
            else
                takeTurn()
            end
        end)
    end)
    ConnectRemote(GetAbilities, "GetAbilities", function(p236, p237)
        if not Shared.BOT_ENABLED then return end
        if p237 then
            Shared.latestSummonData = p236
            dcmm("[GetAbilities] summon data updated")
        else
            Shared.latestPlayerData = p236[LocalPlayer.Name]
            local abils = Shared.latestPlayerData and Shared.latestPlayerData.Abilities or {}
            dcmm("[GetAbilities] player data: %d abilities", #abils) 
        end
    end)
    ConnectRemote(AttackFlash, "AttackFlash", function(p239)
        if not Shared.BOT_ENABLED then return end
        local data = Abilities[p239]
        if data and data.Cost and data.Cost >= Shared.BlockPredictions then
            Shared.enCD[p239] = (data.Cooldown or 0)
        end
    end)
    ConnectRemote(PlayerInventory, "PlayerInventory", function(p489, p490)
        if not Shared.BOT_ENABLED then return end
        if p489 == "Inventory" then
            Shared.Inv = p490.Player.Inventory
            Shared.Equip = p490.Player.Equipment
        elseif p489 == "Shop" then
            Shared.shopInventory = p490 or {}
        end
    end)
    ConnectRemote(SceneEvent, "SceneEvent", function(p31, p32, p33)
        if p31 == "OpenSceneUI" then
            lastSceneArgs = { p32, p33 }
        elseif p31 == "CloseSceneUI" then
            lastSceneArgs = nil
        end
        if not Shared.BOT_ENABLED then return end
        if p31 == "OpenSceneUI" then
            task.spawn(function()
                if not Shared.BOT_ENABLED then return end
                doScenePick(p32, p33)
            end)
        elseif p31 == "OpenEncounterUI" then
            task.spawn(function()
                if not Shared.BOT_ENABLED then return end
                doEncounterPick(p32, p33)
            end)
        end
    end)
    ConnectRemote(Remotes.Achievement, "Achievement", function(achievementName)
        if type(achievementName) == "string" then table.insert(achievements, achievementName) end
    end)
    local tConnect, stsConnect, UIConnect, itConnect, endConnect
    local updTurnConnect, fTurnConnect, abilConnect, atkfConnect
    local invConnect, scnConnect1, scnConnect2
    local restLoopActive     = false
    local progressLoopActive = false
    local RestFrame          = LocalPlayer.PlayerGui.RestGUI.RestFrame
    local ShopButton         = RestFrame.Frame1.Shop
    local conns              = {}
    local scriptStartTime    = tick()
    local achievements       = {}
    local cealtAtDungeonStart = 0
    local lastSceneArgs      = nil
    local function disconnectAll()
        for k, c in pairs(conns) do
            if c then c:Disconnect() end
            conns[k] = nil
        end
    end
    local function runBot()
        Shared.BOT_ENABLED   = true
        restLoopActive       = true
        progressLoopActive   = false
        progressLoopActive   = true
        disconnectAll()
        task.spawn(function()
            local EncounterGUI   = LocalPlayer.PlayerGui:FindFirstChild("EncounterGUI")
            local SceneGUI       = LocalPlayer.PlayerGui:FindFirstChild("SceneGUI")
            local EncounterFrame = EncounterGUI and EncounterGUI:FindFirstChild("EncounterFrame")
            local SceneBG        = SceneGUI and SceneGUI:FindFirstChild("Background")
            if EncounterFrame and EncounterFrame.Visible then
                local opts      = {}
                local ShortRest = EncounterFrame.Background:FindFirstChild("ShortRest")
                local Scavenge  = EncounterFrame.Background:FindFirstChild("Scavenge")
                if Scavenge  and Scavenge.Visible  then opts["Scavenge"]  = true end
                if ShortRest and ShortRest.Visible and ShortRest.Interactable then opts["ShortRest"] = true end
                for _, btn in ipairs(EncounterFrame.Background:GetChildren()) do
                    if btn:IsA("ImageButton") and btn:FindFirstChild("Title") and btn.Title.Text ~= "" then
                        local danger = 0
                        if btn:FindFirstChild("Danger") then
                            for _, star in ipairs(btn.Danger:GetChildren()) do
                                if star:IsA("ImageLabel") then danger += 1 end
                            end
                        end
                        opts[btn.Title.Text] = { Danger = danger }
                    end
                end
                doEncounterPick(opts, nil)
            elseif SceneBG and SceneBG.Visible then
                if lastSceneArgs then
                    doScenePick(lastSceneArgs[1], lastSceneArgs[2])
                end
            end
        end)
        Thread("bot.progressLoop", function()
            while progressLoopActive do
                local intervalMins = Shared.ProgressWebhookInt or 5
                task.wait(intervalMins * 60)
                if not progressLoopActive then break end
                if not Shared.EnableProgressWebhook then continue end
                pcall(function()
                    local WebhookURL = Shared.config.WebhookURL
                    if not WebhookURL or WebhookURL == "" then return end
                    local build    = getBuildInfo()
                    local boonStr  = (build.boons and #build.boons > 0) and table.concat(build.boons, ", ") or "None"
                    local elapsed  = tick() - scriptStartTime
                    local mins     = math.floor(elapsed / 60)
                    local secs     = math.floor(elapsed % 60)
                    local achStr   = #achievements > 0 and table.concat(achievements, ", ") or "None"
                    local invLines = {}
                    for iName, iData in pairs(Shared.Inv) do
                        table.insert(invLines, (type(iData) == "table" and iData.Name or tostring(iName)))
                    end
                    local eqLines = {}
                    for slot, item in pairs(Shared.Equip) do
                        local iName = type(item) == "table" and (item.Name or item.Key or "?") or tostring(item)
                        if iName ~= "None" then table.insert(eqLines, slot .. ": " .. iName) end
                    end
                    local statLines = {}
                    for stat, val in pairs(Shared.currentStats) do
                        table.insert(statLines, stat .. ": " .. tostring(val))
                    end
                    local fields = {
                        { name = "Build",        value = "**Class:** " .. (build.class or "?") .. "\n**Race:** " .. (build.race or "?") .. "\n**Prestige:** " .. tostring(build.prestige or 0) .. "\n**Boons:** " .. boonStr, inline = false },
                        { name = "Elapsed",      value = string.format("%dm %02ds", mins, secs), inline = true },
                        { name = "Achievements", value = achStr, inline = true },
                        { name = "Inventory",    value = #invLines > 0 and table.concat(invLines, ", ") or "Empty", inline = false },
                        { name = "Equipment",    value = #eqLines > 0 and table.concat(eqLines, "\n") or "None",   inline = false },
                        { name = "Stats",        value = #statLines > 0 and table.concat(statLines, "\n") or "None", inline = false },
                    }
                    local payload = {
                        username   = "Yuri",
                        avatar_url = yuri[math.random(1, #yuri)],
                        embeds = {{
                            title     = "⏱ Progress Update",
                            color       = math.random(0, 16777215),
                            fields    = fields,
                            thumbnail = { url = yuri[math.random(1, #yuri)] },
                            footer    = { text = string.format("Yuri • %s", os.date("%x %X")) },
                        }}
                    }
                    doRequest(WebhookURL, HttpService:JSONEncode(payload))
                end)
            end
        end, true)
        Thread("bot.restLoop", function()
            local lastVisible = false
            while Shared.BOT_ENABLED and restLoopActive do
                local ok, e = pcall(function()
                    local visible = RestFrame.Visible
                    if visible and not lastVisible then
                        lastVisible = true
                        task.spawn(function()
                            if not Shared.BOT_ENABLED then return end
                            if ShopButton.Visible then
                                autoShop()
                                task.wait(0.3)
                            end
                            invStats()
                            autoEquip()
                            autoCraft()
                            VotingEvent:FireServer("Rest")
                        end)
                    elseif not visible then
                        lastVisible = false
                    end
                end)
                task.wait(0.1)
            end
        end, true)
        if LocalPlayer:GetAttribute("Turn") then
            Thread("bot.startupTurn", function()
                task.wait(0.2)
                if Shared.BOT_ENABLED and LocalPlayer:GetAttribute("Turn") then
                    if isSTurn() then
                        if not Shared.SummonRef then Shared.SummonRef = getOurSummon() end
                        takeSTurn()
                    else
                        takeTurn()
                    end
                end
            end, true)
        end
    end
    local function stopBot()
        Shared.BOT_ENABLED   = false
        restLoopActive       = false
        progressLoopActive   = false
        disconnectAll()
        Cleanup(Flags)
    end
    runBot()
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.ResetOnSpawn   = false
    toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    toggleGui.Parent         = CoreGui
    local masterToggle = Instance.new("TextButton")
    masterToggle.Size             = UDim2.fromOffset(24, 24)
    masterToggle.Position         = UDim2.new(0, 10, 0, 10)
    masterToggle.BackgroundColor3 = Shared.BOT_ENABLED and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    masterToggle.AutoButtonColor  = false
    masterToggle.BorderSizePixel  = 0
    masterToggle.ZIndex           = 10
    masterToggle.Parent           = toggleGui
    masterToggle.Text             = ""
    Instance.new("UICorner", masterToggle).CornerRadius = UDim.new(0, 0)
    local toggleDebounce = false
    local debounceTime   = 0.5
    local function updateMasterToggle()
        masterToggle.BackgroundColor3 = Shared.BOT_ENABLED and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    end
    masterToggle.MouseButton1Click:Connect(function()
        if toggleDebounce then return end
        toggleDebounce    = true
        Shared.BOT_ENABLED = not Shared.BOT_ENABLED
        updateMasterToggle()
        if Shared.BOT_ENABLED then runBot() else stopBot() end
        task.wait(debounceTime)
        toggleDebounce = false
    end)
end 
end) 
Library.ToggleKeybind = Options.PriMenuKeybind
SaveManager:IgnoreThemeSettings()
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UserInputService.KeyboardEnabled then
    Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Report bug and give suggestion in Discord!", 5)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
end
