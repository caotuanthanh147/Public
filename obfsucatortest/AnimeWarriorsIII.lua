if getgenv().ayasemiyatongekissazumirisa then
    warn("?")
    return
end
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
repeat task.wait() until #game:GetService("Players").LocalPlayer.PlayerGui.absolute:GetChildren() == 0
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
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local Lighting = game:GetService('Lighting');
local RunService = Services.RunService
local RS = Services.ReplicatedStorage
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
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
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
local yuri = {
    "https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
    "https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
    "https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/233/thumbnail.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/328/thumbnail.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/1339/thumbnail.jpeg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/1268/thumbnail.jpeg",
    "https://dynasty-scans.com/system/releases/000/040/979/001.webp",
    "https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
}
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
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
local RemoteContainer = GetRemote(RS, "rbxts_include.node_modules.@rbxts.remo.src.container")
local function RC(name)
    if not RemoteContainer then return nil end
    return RemoteContainer:FindFirstChild(name)
end
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
            local inviteCode = "3y2Z8VfhX"
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
local Remotes = {
    Kick                          = RC("vipServer.kick"),
    CharmSync                     = RC("charm.sync"),
    CharmInit                     = RC("charm.init"),
    JoinServer                    = RC("servers.joinServer"),
    RefreshServers                = RC("servers.refresh"),
    SwitchEnemy                   = RC("enemies.switchEnemy"),
    HitEnemy                      = RC("enemies.hit"),
    RegenEnemy                    = RC("enemies.regen"),
    SendAndRetreat                = RC("enemies.sendAndRetreat"),
    LoadMap                       = RC("cutscene.loadMap"),
    UnloadMap                     = RC("cutscene.unloadMap"),
    ClaimLegend                   = RC("collection.claimLegend"),
    ClaimMilestone                = RC("collection.claimMilestone"),
    QuitGauntlet                  = RC("gauntlet.quitGauntlet"),
    TeleportToHub                 = RC("gauntlet.teleportToHub"),
    VoteCard                      = RC("gauntlet.voteCard"),
    LeaveGauntlet                 = RC("gauntlet.leaveGauntlet"),
    DisplayCards                  = RC("gauntlet.displayCards"),
    TeleportOutOfHub              = RC("gauntlet.teleportOutOfHub"),
    CreateGauntlet                = RC("gauntlet.create"),
    ClearButton                   = RC("gauntlet.clearButton"),
    RerollTraits                  = RC("traits.reroll"),
    AddIncubatorItem              = RC("incubator.addItem"),
    RemoveIncubatorItem           = RC("incubator.removeItem"),
    LevelUpIncubator              = RC("incubator.levelUp"),
    EquipToolbar                  = RC("toolbar.equip"),
    RearrangeToolbar              = RC("toolbar.rearrange"),
    UnequipToolbar                = RC("toolbar.unequip"),
    BuyBoost                      = RC("items.buyBoost"),
    SetBoostRunning               = RC("items.setBoostRunning"),
    DeleteWayfinder               = RC("items.deleteWayfinder"),
    EquipTool                     = RC("items.equipTool"),
    ClaimGift                     = RC("items.claimGift"),
    ClaimBundle                   = RC("items.claimBundle"),
    SendGift                      = RC("items.sendGift"),
    UseBoost                      = RC("items.useBoost"),
    UnequipTool                   = RC("items.unequipTool"),
    DestroyAccessory              = RC("accessories.destroy"),
    UnequipVanity                 = RC("accessories.unequipVanity"),
    FuseAccessory                 = RC("accessories.fuse"),
    UnequipAccessory              = RC("accessories.unequip"),
    ClearAccessoryTeams           = RC("accessories.teams.clear"),
    SaveAccessoryTeams            = RC("accessories.teams.save"),
    LoadAccessoryTeams            = RC("accessories.teams.load"),
    RenameAccessoryTeam           = RC("accessories.teams.rename"),
    EquipVanity                   = RC("accessories.equipVanity"),
    EquipAccessory                = RC("accessories.equip"),
    RenameAccessory               = RC("accessories.rename"),
    LockAccessory                 = RC("accessories.lock"),
    ClanHideoutAmaterasu          = RC("bossRaids.clanHideoutAmaterasu"),
    DesertKingdomTanksUnlocked    = RC("bossRaids.desertKingdomTanksUnlocked"),
    DesertKingdomSablesPersado    = RC("bossRaids.desertKingdomSablesPersado"),
    LeaveRaid                     = RC("bossRaids.leaveRaid"),
    CreateRaid                    = RC("bossRaids.create"),
    EndRaidPhase                  = RC("bossRaids.endPhase"),
    ClanHideoutFlameSpiritSlash   = RC("bossRaids.clanHideoutFlameSpiritSlash"),
    NotifyRaidCreated             = RC("bossRaids.notifyCreated"),
    RedRibbonExplode              = RC("bossRaids.redRibbonExplode"),
    DesertKingdomTankDestroyed    = RC("bossRaids.desertKingdomTankDestroyed"),
    DesertKingdomKnockback        = RC("bossRaids.desertKingdomKnockback"),
    DesertKingdomSandstorm        = RC("bossRaids.desertKingdomSandstorm"),
    DesertKingdomSinkingPit       = RC("bossRaids.desertKingdomSinkingPit"),
    QuitRaid                      = RC("bossRaids.quitRaid"),
    PurchaseItem                  = RC("shops.purchase"),
    DailyGauntletRestock          = RC("shops.dailyGauntletRestock"),
    ShowStarterWarrior            = RC("tutorial.showStarterWarrior"),
    ClaimStarter                  = RC("tutorial.claimStarter"),
    ReadInbox                     = RC("inbox.read"),
    DeleteInbox                   = RC("inbox.delete"),
    ClaimInbox                    = RC("inbox.claim"),
    ClaimAllInbox                 = RC("inbox.claimAll"),
    DeleteReadInbox               = RC("inbox.deleteRead"),
    ClaimAchievementGroup         = RC("achievements.claimGroup"),
    ClaimAchievement              = RC("achievements.claim"),
    RetrieveStream                = RC("stream.retrieve"),
    SetSetting                    = RC("settings.set"),
    SetWeaponAbility              = RC("automation.setWeaponAbility"),
    ApplyDefaultAutoAbilities     = RC("automation.applyDefaultAutoAbilities"),
    SetAutoAbilityType            = RC("automation.setAutoAbilityType"),
    SetAutoAbilityKeybind         = RC("automation.setAutoAbilityKeybind"),
    SetWarriorAbilities           = RC("automation.setWarriorAbilities"),
    ReconnectAutomation           = RC("automation.reconnect"),
    AddAutoAbility                = RC("automation.addAutoAbility"),
    SetAutomationState            = RC("automation.setState"),
    SyncNotifications             = RC("automation.syncNotifications"),
    DeleteAutoAbility             = RC("automation.deleteAutoAbility"),
    RearrangeAutoAbilities        = RC("automation.rearrangeAutoAbilities"),
    EquipSkinOnWarrior            = RC("skins.equipOnWarrior"),
    DestroySkin                   = RC("skins.destroy"),
    UnequipSkinFromWarrior        = RC("skins.unequipFromWarrior"),
    LockSkin                      = RC("skins.lock"),
    BroadcastClient               = RC("client.broadcast"),
    DropInstances                 = RC("client.dropInstances"),
    NoticeClient                  = RC("client.notice"),
    RewardsClient                 = RC("client.rewards"),
    ConfettiClient                = RC("client.confetti"),
    CurrencyRain                  = RC("client.currencyRain"),
    PopupClient                   = RC("client.popup"),
    SummaryClient                 = RC("client.summary"),
    DropClient                    = RC("client.drop"),
    DropsPlural                   = RC("client.dropsPlural"),
    PromptClient                  = RC("client.prompt"),
    AlertClient                   = RC("client.alert"),
    AnnounceClient                = RC("client.announce"),
    EquipBestWarrior              = RC("warriors.equipBest"),
    MissWarrior                   = RC("warriors.miss"),
    UnequipAllWarriors            = RC("warriors.unequipAll"),
    DismantleWarrior              = RC("warriors.dismantle"),
    LockWarrior                   = RC("warriors.lock"),
    EquipWarrior                  = RC("warriors.equip"),
    FeedWarrior                   = RC("warriors.feed"),
    DestroyWarrior                = RC("warriors.destroy"),
    UseUltimateWarrior            = RC("warriors.useUltimate"),
    UnequipWarrior                = RC("warriors.unequip"),
    DodgeWarrior                  = RC("warriors.dodge"),
    ClearWarriorTeams             = RC("warriors.teams.clear"),
    SaveWarriorTeams              = RC("warriors.teams.save"),
    LoadWarriorTeams              = RC("warriors.teams.load"),
    RenameWarriorTeam             = RC("warriors.teams.rename"),
    ReplicateUltimateWarrior      = RC("warriors.replicateUltimate"),
    AscendWarrior                 = RC("warriors.ascend"),
    SellWarrior                   = RC("warriors.sell"),
    RenameWarrior                 = RC("warriors.rename"),
    TierUpWarrior                 = RC("warriors.tierUp"),
    SetEggsPaused                 = RC("eggs.setPaused"),
    PlayEggs                      = RC("eggs.play"),
    OpenEggs                      = RC("eggs.open"),
    SetEggsAuto                   = RC("eggs.setAuto"),
    ClaimBattlepassQuest          = RC("battlepass.claimQuest"),
    ClaimBattlepassTierReward     = RC("battlepass.claimTierReward"),
    ClaimAllBattlepassRewards     = RC("battlepass.claimAllRewards"),
    CreateEscort                  = RC("escorts.create"),
    LeaveEscort                   = RC("escorts.leaveEscort"),
    ToggleHitboxes                = RC("vfxDev.toggleHitboxes"),
    RetargetWarrior               = RC("vfxDev.retargetWarrior"),
    ToggleSandstorm               = RC("vfxDev.toggleSandstorm"),
    ClearRaidBoss                 = RC("vfxDev.clearRaidBoss"),
    ToggleSinkingPit              = RC("vfxDev.toggleSinkingPit"),
    FireServerAbility             = RC("vfxDev.fireServerAbility"),
    FireServerWeaponAbility       = RC("vfxDev.fireServerWeaponAbility"),
    FireRaidMechanic              = RC("vfxDev.fireRaidMechanic"),
    SpawnRaidBoss                 = RC("vfxDev.spawnRaidBoss"),
    SetDummyScale                 = RC("vfxDev.setDummyScale"),
    ClearDummies                  = RC("vfxDev.clearDummies"),
    SpawnDummies                  = RC("vfxDev.spawnDummies"),
    ReplicateEffect               = RC("effects.replicate"),
    PlayEffect                    = RC("effects.play"),
    SecondWindRevive              = RC("effects.secondWindRevive"),
    TeleportToWaystone            = RC("world.teleportToWaystone"),
    SetSpawnPoint                 = RC("world.setSpawnPoint"),
    TakeWaystoneQuest             = RC("world.takeWaystoneQuest"),
    WaystoneRepaired              = RC("world.waystoneRepaired"),
    UnequipRelic                  = RC("relics.unequip"),
    LockRelic                     = RC("relics.lock"),
    EquipRelic                    = RC("relics.equip"),
    DestroyRelic                  = RC("relics.destroy"),
    RenameRelic                   = RC("relics.rename"),
    FuseRelic                     = RC("relics.fuse"),
    UnequipMount                  = RC("mounts.unequip"),
    DespawnMount                  = RC("mounts.despawnMount"),
    SitMount                      = RC("mounts.sit"),
    SpawnBoat                     = RC("mounts.spawnBoat"),
    EquipMount                    = RC("mounts.equip"),
    DespawnBoat                   = RC("mounts.despawnBoat"),
    SpawnMount                    = RC("mounts.spawnMount"),
    UnsitMount                    = RC("mounts.unsit"),
    DestroyWeapon                 = RC("weapons.destroy"),
    ActivateWeapon                = RC("weapons.activate"),
    FuseWeapon                    = RC("weapons.fuse"),
    UseUltimateWeapon             = RC("weapons.useUltimate"),
    UnequipWeapon                 = RC("weapons.unequip"),
    ReplicateUltimateWeapon       = RC("weapons.replicateUltimate"),
    LockWeapon                    = RC("weapons.lock"),
    EquipWeapon                   = RC("weapons.equip"),
    ReplicateWeapon               = RC("weapons.replicate"),
    RenameWeapon                  = RC("weapons.rename"),
    LeaveLobby                    = RC("lobbies.leave"),
    StartLobby                    = RC("lobbies.start"),
    KickLobby                     = RC("lobbies.kick"),
    JoinLobby                     = RC("lobbies.join"),
    EquipTitle                    = RC("profiles.equipTitle"),
    UnequipBadge                  = RC("profiles.unequipBadge"),
    EquipBadge                    = RC("profiles.equipBadge"),
    EquipBanner                   = RC("profiles.equipBanner"),
    UndisplayWarrior              = RC("profiles.undisplayWarrior"),
    RequestProfileData            = RC("profiles.requestData"),
    UnequipProfileWeapon          = RC("profiles.unequipWeapon"),
    DisplayWarrior                = RC("profiles.displayWarrior"),
    UnequipProfileWarrior         = RC("profiles.unequipWarrior"),
    UnequipProfileAccessory       = RC("profiles.unequipAccessory"),
    UnequipBanner                 = RC("profiles.unequipBanner"),
    EquipProfileWeapon            = RC("profiles.equipWeapon"),
    UnequipTitle                  = RC("profiles.unequipTitle"),
    EquipProfileAccessory         = RC("profiles.equipAccessory"),
    EquipProfileWarrior           = RC("profiles.equipWarrior"),
    ClaimQuestPart                = RC("quests.claimPart"),
    UntrackQuest                  = RC("quests.untrackQuest"),
    UnfavoriteQuest               = RC("quests.unfavoriteQuest"),
    TakeQuest                     = RC("quests.takeQuest"),
    TrackQuest                    = RC("quests.trackQuest"),
    FavoriteQuest                 = RC("quests.favoriteQuest"),
    EggAnnouncements              = RC("eggSettings.announcements"),
    AutoLockTraits                = RC("eggSettings.autoLockTraits"),
    AutoDismantle                 = RC("eggSettings.autoDismantle"),
    AutoSell                      = RC("eggSettings.autoSell"),
    AutoLock                      = RC("eggSettings.autoLock"),
    SimulateSecretPull            = RC("misc.simulateSecretPull"),
    Warp                          = RC("misc.warp"),
    Kill                          = RC("misc.kill"),
    Teleport                      = RC("misc.teleport"),
    UnlockWaystone                = RC("misc.unlockWaystone"),
    Rejoin                        = RC("misc.rejoin"),
    AfkRejoin                     = RC("misc.afkRejoin"),
    Spectate                      = RC("misc.spectate"),
    RestoreServerLuck             = RC("global.restoreServerLuck"),
    ReceiveAnnouncement           = RC("global.receiveAnnouncement"),
    SendAnnouncement              = RC("global.sendAnnouncement"),
    JoinPlayer                    = RC("global.joinPlayer"),
    SetServerLuck                 = RC("global.setServerLuck"),
    GlobalGiveItem                = RC("global.globalGiveItem"),
}
local _src = RS:FindFirstChild("src")
local _common = _src and _src:FindFirstChild("common")
local _content = _common and _common:FindFirstChild("content")
local _store = _common and _common:FindFirstChild("store")
local _storePlayers = _store and _store:FindFirstChild("players")
local _storeWorld = _store and _store:FindFirstChild("world")
local _storeGamemodes = _store and _store:FindFirstChild("gamemodes")
local _world = _content and _content:FindFirstChild("world")
local Modules = {
    Eggs     = GetSafeModule(_content, "purchases", "eggs"),
    Quests   = GetSafeModule(_content, "world", "quests"),
    Raids    = GetSafeModule(_content, "gamemodes", "raids"),
    Gauntlet = GetSafeModule(_content, "gamemodes", "gauntlet"),
}
local Shared = {
    Farm = false,
    Raid = false,
    Gauntlet = false,
    Rewards = false,
    Quest = false,
    Eggs = false,
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
local Flags = {}
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
local function gsc(guiObject)
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
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function GetDatastoreAtom()
    if not _storePlayers then
        return nil
    end
    local ok, store = pcall(function()
        return GetSafeModule(_storePlayers, "datastore")
    end)
    if not ok then
        return nil
    end
    if not store then
        return nil
    end
    if not store.datastore then
        return nil
    end
    return store.datastore
end
local function GetPlayerData()
    local atom = GetDatastoreAtom()
    if not atom then
        return nil
    end
    local ok, allData = pcall(function() return atom() end)
    if not ok then
        return nil
    end
    if not allData then
        return nil
    end
    local data = allData[tostring(Plr.UserId)]
    if not data then
        return nil
    end
    return data
end
local function GetRaidsAtom()
    local ok, store = pcall(function()
        return GetSafeModule(_storeGamemodes, "raids")
    end)
    if ok and store and store.raidsStore then
        return store.raidsStore
    end
    return nil
end
local function IsInRaid()
    local atom = GetRaidsAtom()
    if not atom then return false end
    local ok, raids = pcall(function() return atom() end)
    if not ok or not raids then return false end
    local userId = tostring(Plr.UserId)
    for _, raid in pairs(raids) do
        if table.find(raid.participants or {}, userId) then
            if raid.state ~= "finished" and raid.state ~= "ended" then
                return true
            end
        end
    end
    return false
end
local function GetGauntletAtom()
    local ok, store = pcall(function()
        return GetSafeModule(_storeGamemodes, "gauntlet")
    end)
    if ok and store and store.gauntletStore then
        return store.gauntletStore
    end
    return nil
end
local function GetGauntletTimersAtom()
    local ok, store = pcall(function()
        return GetSafeModule(_storeGamemodes, "gauntlet")
    end)
    if ok and store and store.gauntletTimers then
        return store.gauntletTimers
    end
    return nil
end
local function GetInboxAtom()
    local ok, store = pcall(function()
        return GetSafeModule(_storePlayers, "inbox")
    end)
    if ok and store and store.inboxStore then
        return store.inboxStore
    end
    return nil
end
local EnemiesStore = nil
local function GetEnemiesStore()
    if not EnemiesStore then
        EnemiesStore = GetSafeModule(_storeWorld, "enemies")
    end
    return EnemiesStore
end
local WarriorsStore = nil
local _lastFarmTarget = nil  
local _farmModeChanged = false
local _activeTask = nil
local _raidActive = false  
local function GetPriorityOrder()
    local order = {}
    local seen = {}
    for i = 1, 3 do
        local key = "SelectedPriority_" .. i
        local ok, val = pcall(function() return Options[key] and Options[key].Value end)
        if ok and val and val ~= "" and not seen[val] then
            table.insert(order, val)
            seen[val] = true
        end
    end
    for _, t in ipairs({ "Raid", "Gauntlet", "Farm" }) do
        if not seen[t] then
            table.insert(order, t)
        end
    end
    return order
end
local function GetTaskRank(taskName)
    local order = GetPriorityOrder()
    for i, t in ipairs(order) do
        if t == taskName then return i end
    end
    return 999
end
local function IsHigherPriorityActive(myTask)
    if not _activeTask then return false end
    if _activeTask == myTask then return false end
    return GetTaskRank(_activeTask) < GetTaskRank(myTask)
end
local function SetActiveTask(taskName)
    _activeTask = taskName
    _raidActive = (taskName == "Raid" or taskName == "Gauntlet")
end
local function ClearActiveTask(taskName)
    if _activeTask == taskName then
        _activeTask = nil
        _raidActive = false
    end
end
local function GetWarriorsStore()
    if not WarriorsStore then
        local ok, store = pcall(function()
            return GetSafeModule(_storeWorld, "warriors")
        end)
        if ok and store and store.warriorsStore then
            WarriorsStore = store.warriorsStore
        end
    end
    return WarriorsStore
end
local WorldsContentCache = nil
local function GetWorldsContent()
    if not WorldsContentCache then
        local worlds = GetSafeModule(_world, "worlds")
        if worlds and worlds.worldsContent then
            WorldsContentCache = worlds.worldsContent
        end
    end
    return WorldsContentCache
end
local EnemiesContentCache = nil
local function GetEnemiesContent()
    if not EnemiesContentCache then
        local _humans = _content and _content:FindFirstChild("humans")
        local enemiesModule = _humans and GetSafeModule(_humans, "enemies")
        if enemiesModule and enemiesModule.enemiesContent then
            EnemiesContentCache = enemiesModule.enemiesContent
        end
    end
    return EnemiesContentCache
end
local function GetAllEnemyNames()
    local enemiesContent = GetEnemiesContent()
    if not enemiesContent then return {} end
    local typeOrder = { ["normal"] = 1, ["mini-boss"] = 2, ["boss"] = 3, ["secret-boss"] = 4 }
    local entries = {}
    for id, data in pairs(enemiesContent) do
        local enemyType = data.world and data.world.enemyType
        if enemyType and typeOrder[enemyType] then
            table.insert(entries, {
                name = id, -- use the key directly so it matches enemy.name in the store
                enemyType = enemyType,
            })
        end
    end
    table.sort(entries, function(a, b)
        local oa = typeOrder[a.enemyType] or 99
        local ob = typeOrder[b.enemyType] or 99
        if oa ~= ob then return oa < ob end
        return a.name < b.name
    end)
    local names = {}
    for _, entry in ipairs(entries) do
        table.insert(names, entry.name)
    end
    return names
end
local function GetQuestEnemyNames()
    local data = GetPlayerData()
    if not data then
        return {}
    end
    local quests = data.quests
    if not quests then
        return {}
    end
    local questsModule = GetSafeModule(_world and _world:FindFirstChild("quests") and _world or (_content and _content:FindFirstChild("world")), "quests")
    local questsContent = questsModule and questsModule.questsContent
    if not questsContent then
        return {}
    end
    local seen = {}
    local names = {}
    for questId, questState in pairs(quests) do
        local content = questsContent[questId]
        if not content then continue end
        local totalParts = 0
        for _ in pairs(content.parts) do totalParts = totalParts + 1 end
        local currentPart = questState.currentPart or 1
        if currentPart > totalParts then continue end 
        local partContent = content.parts[currentPart]
        if not partContent then continue end
        local partState = questState.parts and questState.parts[tostring(currentPart)]
        if partState and partState.claimed then continue end
        if partContent.tasks then
            for taskIdx, task in ipairs(partContent.tasks) do
                if task.tracker == "enemy-kills" and task.enemy then
                    local taskStateKey = tostring(taskIdx)
                    local taskState = partState and partState.tasks and partState.tasks[taskStateKey]
                    local taskAmount = (taskState and taskState.amount) or 0
                    local taskRequired = task.required or 0
                    if taskAmount >= taskRequired and taskRequired > 0 then
                        continue
                    end
                    if not seen[task.enemy] then
                        seen[task.enemy] = true
                        table.insert(names, task.enemy)
                    end
                end
            end
        end
    end
    if #names > 0 then
    else
    end
    return names
end
local function GetEnemyPosition(enemy, forceDynamic)
    if forceDynamic or enemy.dynamic ~= nil then
        local hitbox = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Hitboxes") and workspace.World.Hitboxes:FindFirstChild("enemy@" .. enemy.id)
        if hitbox then
            local part = hitbox:IsA("BasePart") and hitbox or hitbox:FindFirstChildWhichIsA("BasePart")
            if part then return part.Position end
        end
    end
    return enemy.spawn and enemy.spawn.Position or Vector3.new(0, 0, 0)
end
local function FindNearestEnemy(filterNames, maxRange)
    local store = GetEnemiesStore()
    if not store then return nil end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local myPos = hrp and hrp.Position or Vector3.new(0, 0, 0)
    local best = nil
    local bestDist = math.huge
    local allEnemies = store.allEnemies and store.allEnemies() or {}
    for id, enemy in pairs(allEnemies) do
        if enemy.flags and enemy.flags.dead and enemy.flags.dead.state then continue end
        if enemy.flags and enemy.flags.invincible and enemy.flags.invincible ~= false then continue end
        if enemy.stats and enemy.stats.health <= 0 then continue end
        local nameMatch = true
        if filterNames and #filterNames > 0 then
            nameMatch = false
            for _, n in ipairs(filterNames) do
                if n == enemy.name then nameMatch = true; break end
            end
        end
        if not nameMatch then continue end
        local spawnPos = GetEnemyPosition(enemy)
        local dist = (myPos - spawnPos).Magnitude
        if maxRange and maxRange > 0 and dist > maxRange then continue end
        if dist < bestDist then
            bestDist = dist
            best = enemy
        end
    end
    return best
end
local function FindEnemyByName(name)
    local store = GetEnemiesStore()
    if not store then return nil end
    local allEnemies = store.allEnemies and store.allEnemies() or {}
    for id, enemy in pairs(allEnemies) do
        if enemy.name == name then
            if enemy.flags and enemy.flags.dead and enemy.flags.dead.state then continue end
            if enemy.stats and enemy.stats.health <= 0 then continue end
            return enemy
        end
    end
    return nil
end
local function TeleportToEnemy(enemy, forceDynamic)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not enemy then return end
    local pos = GetEnemyPosition(enemy, forceDynamic)
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end
local TELEPORT_NEAR_DIST = 49
local _questNPCNames = nil
local function GetQuestNPCNames()
    if _questNPCNames then return _questNPCNames end
    local dialogueModule = GetSafeModule(_world, "dialogue")
    local dialogueContent = dialogueModule and dialogueModule.dialogueContent
    if not dialogueContent then
        return {}
    end
    local map = {}
    for npcName, entry in pairs(dialogueContent) do
        local qid = entry.quest
        if qid then
            if not map[qid] then map[qid] = {} end
            map[qid][npcName] = true
        end
    end
    _questNPCNames = map
    return map
end
local function TeleportToQuestNPC(questId)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local npcNames = GetQuestNPCNames()
    local validNames = npcNames[questId]
    if not validNames then
        return
    end
    local CollectionService = Services.CollectionService
    local bestNPC = nil
    local bestDist = math.huge
    for _, npc in ipairs(CollectionService:GetTagged("npc")) do
        if validNames[npc.Name] then
            local pp = npc:IsA("Model") and (npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart")) or (npc:IsA("BasePart") and npc or nil)
            if pp then
                local dist = (hrp.Position - pp.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    bestNPC = pp
                end
            end
        end
    end
    if not bestNPC then
        return
    end
    if bestDist <= TELEPORT_NEAR_DIST then
        return
    end
    hrp.CFrame = CFrame.new(bestNPC.Position + Vector3.new(0, 4, 0))
    task.wait(0.15)
end
local function IsEnemyDead(enemyId)
    local store = GetEnemiesStore()
    if not store then return true end
    local allEnemies = store.allEnemies and store.allEnemies() or {}
    local storeEmpty = true
    for _ in pairs(allEnemies) do storeEmpty = false; break end
    if storeEmpty then return false end
    local enemy = allEnemies[enemyId]
    if not enemy then return true end
    if enemy.flags and enemy.flags.dead and enemy.flags.dead.state then return true end
    if enemy.stats and enemy.stats.health <= 0 then return true end
    return false
end
local function GetEquippedWarriorIDs()
    local data = GetPlayerData()
    if not data then
        return {}
    end
    if not data.equippedWarriors then
        return {}
    end
    local ids = {}
    for _, warriorId in pairs(data.equippedWarriors) do
        if warriorId and warriorId ~= "" then
            table.insert(ids, warriorId)
        end
    end
    if #ids == 0 then
        return {}
    end
    return ids
end
local function DoAutoFarm()
    local stateRemote = Remotes.SetAutomationState
    if stateRemote then
        pcall(function()
            stateRemote:FireServer("clicker", true)
            stateRemote:FireServer("attack", true)
        end)
    end
    local sendRemote = Remotes.SendAndRetreat
    if not sendRemote then
        return
    end
    while Toggles.AutoFarm.Value do
        if IsHigherPriorityActive("Farm") then
            task.wait(1)
            continue
        end
        SetActiveTask("Farm")
        if stateRemote then
            pcall(function()
                stateRemote:FireServer("clicker", true)
                stateRemote:FireServer("attack", true)
            end)
        end
        local targetMode = Options.FarmTargetMode.Value
        local target = nil
        if targetMode == "Nearest" then
            local maxRange = tonumber(Options.FarmMaxRange.Value) or 0
            target = FindNearestEnemy(nil, maxRange > 0 and maxRange or nil)
        elseif targetMode == "Quest" then
            local questEnemies = GetQuestEnemyNames()
            if #questEnemies > 0 then
                target = FindNearestEnemy(questEnemies)
            else
                target = FindNearestEnemy(nil)
            end
        else 
            local selectedEnemies = {}
            for name, active in pairs(Options.FarmEnemySelect.Value) do
                if active then
                    table.insert(selectedEnemies, name)
                end
            end
            if #selectedEnemies > 0 then
                target = FindNearestEnemy(selectedEnemies)
            else
                target = FindNearestEnemy(nil)
            end
        end
        if target then
            TeleportToEnemy(target)
            task.wait(0.15)
            local warriorIds = GetEquippedWarriorIDs()
            if #warriorIds == 0 then
            else
                local ok, err = pcall(function()
                    sendRemote:FireServer(target.id, warriorIds)
                end)
            end
            _lastFarmTarget = { id = target.id, name = target.name }
            local _farmKillTimeout = tick() + 5
            repeat
                task.wait(0.2)
                if stateRemote then
                    pcall(function()
                        stateRemote:FireServer("clicker", true)
                        stateRemote:FireServer("attack", true)
                    end)
                end
            until IsEnemyDead(target.id) or not Toggles.AutoFarm.Value or IsHigherPriorityActive("Farm") or _farmModeChanged or tick() > _farmKillTimeout
            _farmModeChanged = false
            _lastFarmTarget = nil
            local dead = IsEnemyDead(target.id)
            local toggled = not Toggles.AutoFarm.Value
            local raid = IsHigherPriorityActive("Farm")
            local timedOut = tick() > _farmKillTimeout
            if dead then
            elseif timedOut then
            end
        else
            task.wait(1)
        end
        ClearActiveTask("Farm")
        task.wait(0.1)
    end
    ClearActiveTask("Farm")
    if stateRemote then
        pcall(function()
            stateRemote:FireServer("clicker", false)
            stateRemote:FireServer("attack", false)
        end)
    end
end
local function GetLobbiesAtom()
    local ok, store = pcall(function()
        return GetSafeModule(_storeGamemodes, "lobbies")
    end)
    if ok and store and store.lobbiesStore then
        return store.lobbiesStore
    end
    return nil
end
local function GetMyRaid(raidsAtom)
    if not raidsAtom then return nil end
    local ok, raids = pcall(function() return raidsAtom() end)
    if not ok or not raids then return nil end
    local userId = tostring(Plr.UserId)
    for _, raid in pairs(raids) do
        if table.find(raid.participants or {}, userId) then
            return raid
        end
    end
    return nil
end
local function IsRaidEndState(state)
    return state == "completed" or state == "finished" or state == "ended"
end
local function DoAutoRaid()
    while Toggles.AutoRaid.Value do
        if IsHigherPriorityActive("Raid") then
            task.wait(1)
            continue
        end
        local raidsAtom = GetRaidsAtom()
        local lobbiesAtom = GetLobbiesAtom()
        local existingRaid = GetMyRaid(raidsAtom)
        local skipCreate = existingRaid and not IsRaidEndState(existingRaid.state)
        if skipCreate then
            task.wait(2)
        end
        if not skipCreate then 
            local raidId = Options.RaidSelect.Value or "Destroyed Nemak"
            local raidType = Options.RaidType.Value or "Normal"
            local createRemote = Remotes.CreateRaid
            if not createRemote then
                task.wait(2)
                continue
            end
            local data = GetPlayerData()
            local expiry = data and data.stats and data.stats.raidCooldowns and data.stats.raidCooldowns[raidId] or 0
            local remaining = expiry - os.time()
            if remaining > 0 then
                task.wait(remaining)
                if not Toggles.AutoRaid.Value then break end
            end
            local success, result = pcall(function()
                return createRemote:InvokeServer(raidId, {
                    friendsOnly = false,
                    spawnNormal = (raidType == "Normal")
                })
            end)
            if not (success and result) then
                task.wait(3)
                continue
            end
            local startRemote = Remotes.StartLobby
            if startRemote then
                local lobbyFound = false
                local lobbyTimeout = tick() + 15
                repeat
                    task.wait(1)
                    if lobbiesAtom then
                        local ok2, lobbies = pcall(function() return lobbiesAtom() end)
                        if ok2 and lobbies then
                            local userId = tostring(Plr.UserId)
                            for _, lobby in pairs(lobbies) do
                                if lobby.owner == userId or table.find(lobby.players or {}, userId) then
                                    lobbyFound = true
                                    break
                                end
                            end
                        else
                        end
                    else
                        lobbyFound = true
                    end
                until lobbyFound or tick() > lobbyTimeout or not Toggles.AutoRaid.Value
                if lobbyFound then
                    task.wait(1)
                    pcall(function() startRemote:FireServer() end)
                else
                end
            else
            end
        end 
        if not Toggles.AutoRaid.Value then break end
        local startTimeout = tick() + 45
        repeat
            task.wait(1)
            local raid = GetMyRaid(raidsAtom)
            local state = raid and raid.state or "nil"
            if not Toggles.AutoRaid.Value then break end
            if raid and raid.state == "in-progress" then break end
            if tick() > startTimeout then
                break
            end
        until false
        if not Toggles.AutoRaid.Value then break end
        local currentRaid = GetMyRaid(raidsAtom)
        if not currentRaid or currentRaid.state ~= "in-progress" then
            task.wait(2)
            continue
        end
        SetActiveTask("Raid")
        local stateRemote = Remotes.SetAutomationState
        local sendRemote = Remotes.SendAndRetreat
        if not sendRemote then
        end
        local raidTimeout = tick() + 660
        while Toggles.AutoRaid.Value and tick() < raidTimeout do
            local raid = GetMyRaid(raidsAtom)
            if not raid then
                break
            end
            if IsRaidEndState(raid.state) then
                break
            end
            if stateRemote then
                pcall(function()
                    stateRemote:FireServer("clicker", true)
                    stateRemote:FireServer("attack", true)
                end)
            end
            if sendRemote then
                local target = FindNearestEnemy(nil, 500)
                if target then
                    local warriorIds = GetEquippedWarriorIDs()
                    if #warriorIds > 0 then
                        TeleportToEnemy(target) 
                        task.wait(0.15)
                        local ok, err = pcall(function()
                            sendRemote:FireServer(target.id, warriorIds)
                        end)
                        local killTimeout = tick() + 10
                        repeat
                            task.wait(0.5)
                            if stateRemote then
                                pcall(function()
                                    stateRemote:FireServer("clicker", true)
                                    stateRemote:FireServer("attack", true)
                                end)
                            end
                            local r = GetMyRaid(raidsAtom)
                            if not r or IsRaidEndState(r.state) then
                                break
                            end
                        until IsEnemyDead(target.id) or tick() > killTimeout or not Toggles.AutoRaid.Value
                        if IsEnemyDead(target.id) then
                        elseif tick() > killTimeout then
                        end
                    else
                    end
                else
                end
            end
            task.wait(0.5)
        end
        if stateRemote then
            pcall(function()
                stateRemote:FireServer("clicker", false)
                stateRemote:FireServer("attack", false)
            end)
        end
        ClearActiveTask("Raid")
        if Toggles.AutoRaid.Value then
            local leaveRemote = Remotes.LeaveRaid
            if leaveRemote then
                local ok, err = pcall(function() leaveRemote:FireServer() end)
            else
                local quitRemote = Remotes.QuitRaid
                if quitRemote then
                    local ok, err = pcall(function() quitRemote:FireServer() end)
                else
                end
            end
        end
        task.wait(3)
    end
    ClearActiveTask("Raid")
end
local function DoAutoGauntlet()
    while Toggles.AutoGauntlet.Value do
        if IsHigherPriorityActive("Gauntlet") then
            task.wait(1)
            continue
        end
        local createRemote = Remotes.CreateGauntlet
        local gauntletAtom = GetGauntletAtom()
        if not createRemote then
            task.wait(2)
            continue
        end
        local timersAtom = GetGauntletTimersAtom()
        if timersAtom then
            local ok, timers = pcall(function() return timersAtom() end)
            if ok and timers then
                local t = timers["Normal"]
                if t then
                    local now = os.time()
                    local openUntil = t.openUntil or 0
                    local nextReset = t.nextReset or 0
                    if openUntil > 0 and now > openUntil then
                        local remaining = nextReset - now
                        if remaining > 0 then
                            task.wait(remaining)
                            if not Toggles.AutoGauntlet.Value then break end
                        end
                    else
                    end
                end
            end
        end
        local success, result = pcall(function()
            return createRemote:InvokeServer("Normal", {
                friendsOnly = false
            })
        end)
        if not (success and result) then
            task.wait(3)
            continue
        end
        local startRemote = Remotes.StartLobby
        local lobbiesAtom = GetLobbiesAtom()
        if startRemote then
            local lobbyFound = false
            local lobbyTimeout = tick() + 15
            repeat
                task.wait(1)
                if lobbiesAtom then
                    local ok2, lobbies = pcall(function() return lobbiesAtom() end)
                    if ok2 and lobbies then
                        local userId = tostring(Plr.UserId)
                        for _, lobby in pairs(lobbies) do
                            if lobby.type == "gauntlet" and (lobby.owner == userId or table.find(lobby.players or {}, userId)) then
                                lobbyFound = true
                                break
                            end
                        end
                    end
                else
                    lobbyFound = true
                end
            until lobbyFound or tick() > lobbyTimeout or not Toggles.AutoGauntlet.Value
            if lobbyFound then
                task.wait(1)
                pcall(function() startRemote:FireServer() end)
            else
                warn("[AutoGauntlet] Lobby not found after create, skipping start")
            end
        end
        local startTimeout = tick() + 45
        local myGauntlet = nil
        repeat
            task.wait(1)
            if gauntletAtom then
                local ok, gauntlets = pcall(function() return gauntletAtom() end)
                if ok and gauntlets then
                    for _, g in pairs(gauntlets) do
                        if table.find(g.participants or {}, tostring(Plr.UserId)) then
                            myGauntlet = g
                            break
                        end
                    end
                end
            end
        until (myGauntlet and myGauntlet.state == "in-progress") or tick() > startTimeout or not Toggles.AutoGauntlet.Value
        if not Toggles.AutoGauntlet.Value then break end
        if not myGauntlet or myGauntlet.state ~= "in-progress" then
            task.wait(2)
            continue
        end
        SetActiveTask("Gauntlet")
        local stateRemote = Remotes.SetAutomationState
        local sendRemote = Remotes.SendAndRetreat
        local gauntletTimeout = tick() + 3600
        while Toggles.AutoGauntlet.Value and tick() < gauntletTimeout do
            local currentGauntlet = nil
            if gauntletAtom then
                local ok, gauntlets = pcall(function() return gauntletAtom() end)
                if ok and gauntlets then
                    for _, g in pairs(gauntlets) do
                        if table.find(g.participants or {}, tostring(Plr.UserId)) then
                            currentGauntlet = g
                            break
                        end
                    end
                end
            end
            if not currentGauntlet then
                break
            end
            if currentGauntlet.state == "finished" or currentGauntlet.state == "ended" then
                break
            end
            if currentGauntlet.cardsState == "selecting" and #(currentGauntlet.cardsDisplayed or {}) > 0 then
                local voteRemote = Remotes.VoteCard
                if voteRemote then
                    local firstCard = currentGauntlet.cardsDisplayed[1]
                    if firstCard then
                        pcall(function() voteRemote:FireServer(firstCard) end)
                    end
                end
            end
            if stateRemote then
                pcall(function()
                    stateRemote:FireServer("clicker", true)
                    stateRemote:FireServer("attack", true)
                end)
            end
            if sendRemote then
                local target = FindNearestEnemy(nil, 500)
                if target then
                    local warriorIds = GetEquippedWarriorIDs()
                    if #warriorIds > 0 then
                        TeleportToEnemy(target)
                        task.wait(0.15)
                        local ok, err = pcall(function()
                            sendRemote:FireServer(target.id, warriorIds)
                        end)
                        local killTimeout = tick() + 10
                        repeat
                            task.wait(0.5)
                            if stateRemote then
                                pcall(function()
                                    stateRemote:FireServer("clicker", true)
                                    stateRemote:FireServer("attack", true)
                                end)
                            end
                            if currentGauntlet and currentGauntlet.cardsState == "selecting" and #(currentGauntlet.cardsDisplayed or {}) > 0 then
                                local voteRemote = Remotes.VoteCard
                                if voteRemote then
                                    pcall(function() voteRemote:FireServer(currentGauntlet.cardsDisplayed[1]) end)
                                end
                            end
                        until IsEnemyDead(target.id) or tick() > killTimeout or not Toggles.AutoGauntlet.Value
                        if IsEnemyDead(target.id) then
                        elseif tick() > killTimeout then
                        end
                    else
                    end
                else
                end
            end
            task.wait(0.5)
        end
        if stateRemote then
            pcall(function()
                stateRemote:FireServer("clicker", false)
                stateRemote:FireServer("attack", false)
            end)
        end
        ClearActiveTask("Gauntlet")
        if Toggles.AutoGauntlet.Value then
            local leaveRemote = Remotes.LeaveGauntlet
            if leaveRemote then
                local ok, err = pcall(function() leaveRemote:FireServer() end)
            else
                local quitRemote = Remotes.QuitGauntlet
                if quitRemote then
                    local ok, err = pcall(function() quitRemote:FireServer() end)
                end
            end
        end
        task.wait(3)
    end
    ClearActiveTask("Gauntlet")
end
local function DoAutoRewards()
    while Toggles.AutoRewards.Value do
        local claimAllRemote = Remotes.ClaimAllInbox
        if claimAllRemote then
            local ok, res = pcall(function()
                return claimAllRemote:InvokeServer()
            end)
            if ok and res then
            end
        end
        local deleteReadRemote = Remotes.DeleteReadInbox
        if deleteReadRemote then
            pcall(function()
                deleteReadRemote:InvokeServer()
            end)
        end
        if Toggles.AutoBattlepassRewards.Value then
            local claimAllBPRemote = Remotes.ClaimAllBattlepassRewards
            if claimAllBPRemote then
                local ok, res = pcall(function()
                    return claimAllBPRemote:InvokeServer("1") 
                end)
                if ok and res and res.success then
                end
            end
        end
        if Toggles.AutoQuestRewards.Value then
            local claimQuestRemote = Remotes.ClaimBattlepassQuest
            if claimQuestRemote then
                local data = GetPlayerData()
                if data and data.battlepassQuests then
                    local daily = data.battlepassQuests.default and data.battlepassQuests.default.daily
                    if daily and daily.quests then
                        for questId, questData in pairs(daily.quests) do
                            local required = questData.required or 0
                            if not questData.claimed and questData.amount and questData.amount >= required then
                                local ok, res = pcall(function()
                                    return claimQuestRemote:InvokeServer("default", "daily", questId)
                                end)
                                if ok and res and res.success then
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                    local weekly = data.battlepassQuests.default and data.battlepassQuests.default.weekly
                    if weekly and weekly.quests then
                        for questId, questData in pairs(weekly.quests) do
                            local required = questData.required or 0
                            if not questData.claimed and questData.amount and questData.amount >= required then
                                local ok, res = pcall(function()
                                    return claimQuestRemote:InvokeServer("default", "weekly", questId)
                                end)
                                if ok and res and res.success then
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end
            end
        end
        if Toggles.AutoMilestones.Value then
            local miscFolder = _content and _content:FindFirstChild("misc")
            local claimMilestoneRemote = Remotes.ClaimMilestone
            if claimMilestoneRemote then
                local data = GetPlayerData()
                local milestonesContent = miscFolder and GetSafeModule(miscFolder, "milestones")
                local milestoneCategories = milestonesContent and milestonesContent.milestonesContent
                if data and data.collection and milestoneCategories then
                    for category, milestoneList in pairs(milestoneCategories) do
                        for _, milestone in ipairs(milestoneList) do
                            local milestoneId = ("milestone-%*-%*"):format(category, milestone.amount)
                            local state = data.collection.milestones and data.collection.milestones[milestoneId]
                            if not (state and state.claimed) then
                                local ok, res = pcall(function()
                                    return claimMilestoneRemote:InvokeServer(milestoneId)
                                end)
                                if ok and res and res.success then
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                elseif data and data.collection then
                    local MILESTONE_IDS = {
                        "milestone-warriors-5","milestone-warriors-10","milestone-warriors-15",
                        "milestone-warriors-20","milestone-warriors-25","milestone-warriors-30",
                        "milestone-warriors-35","milestone-warriors-40",
                        "milestone-relics-3","milestone-relics-6","milestone-relics-9","milestone-relics-12",
                        "milestone-accessories-5","milestone-accessories-10","milestone-accessories-15",
                        "milestone-accessories-20","milestone-accessories-25","milestone-accessories-30",
                        "milestone-weapons-4","milestone-weapons-8","milestone-weapons-12",
                        "milestone-weapons-15","milestone-weapons-20","milestone-weapons-25",
                    }
                    for _, milestoneId in ipairs(MILESTONE_IDS) do
                        local state = data.collection.milestones and data.collection.milestones[milestoneId]
                        if not (state and state.claimed) then
                            local ok, res = pcall(function()
                                return claimMilestoneRemote:InvokeServer(milestoneId)
                            end)
                            if ok and res and res.success then
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
            local claimLegendRemote = Remotes.ClaimLegend
            if claimLegendRemote then
                local data = GetPlayerData()
                local legendsContent = miscFolder and GetSafeModule(miscFolder, "legends")
                local legendMap = legendsContent and legendsContent.legendsContent
                if data and data.collection and legendMap then
                    for legendId, _ in pairs(legendMap) do
                        local state = data.collection.legends and data.collection.legends[legendId]
                        if not (state and state.claimed) then
                            local ok, res = pcall(function()
                                return claimLegendRemote:InvokeServer(legendId)
                            end)
                            if ok and res and res.success then
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
        end
        if Toggles.AutoAchievements.Value then
            local claimAchRemote = Remotes.ClaimAchievementGroup
            local claimIndividualRemote = Remotes.ClaimAchievement
            local data = GetPlayerData()
            if data and data.achievements then
                local achContent = _world and GetSafeModule(_world, "achievements")
                local achContentList = achContent and achContent.achievementsContent
                for groupId, groupData in pairs(data.achievements) do
                    if not groupData then continue end
                    if claimIndividualRemote then
                        local achIds = {}
                        if achContentList then
                            for _, groupContent in ipairs(achContentList) do
                                if groupContent.id == groupId then
                                    for _, ach in ipairs(groupContent.achievements) do
                                        table.insert(achIds, ach.id)
                                    end
                                    break
                                end
                            end
                        end
                        if #achIds == 0 and groupData.achievements then
                            for achId, _ in pairs(groupData.achievements) do
                                table.insert(achIds, achId)
                            end
                        end
                        for _, achId in ipairs(achIds) do
                            local achState = groupData.achievements and groupData.achievements[achId]
                            if achState and achState.claimed then continue end
                            local ok, res = pcall(function()
                                return claimIndividualRemote:InvokeServer(groupId, achId)
                            end)
                            if ok and res and res.success then
                                task.wait(0.2)
                            end
                        end
                    end
                    if groupData.claimed then continue end
                    if claimAchRemote then
                        local ok, res = pcall(function()
                            return claimAchRemote:InvokeServer(groupId)
                        end)
                        if ok and res and res.success then
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function GetQuestIdsFromContent()
    local questsModule = GetSafeModule(_world and _world:FindFirstChild("quests") and _world or (_content and _content:FindFirstChild("world")), "quests")
    local questsContent = questsModule and questsModule.questsContent
    if questsContent then
        local ids = {}
        for id, _ in pairs(questsContent) do
            if type(id) == "string" then
                table.insert(ids, id)
            end
        end
        if #ids > 0 then
            return ids, questsContent
        end
    end
    return {
        "PlanetNemak", "FutureCity", "SandVillage", "SkyIslandQuest",
        "SingularityQuest", "SingularityQuest2",
        "KokoshiWaystone", "RobinWaystone", "CarrotWaystone", "RoshaWaystone",
    }, nil
end
local function HasQuestWork()
    local data = GetPlayerData()
    if not data then return false end
    local questIds, questsContent = GetQuestIdsFromContent()
    if not questsContent then return false end
    for _, questId in ipairs(questIds) do
        local content = questsContent[questId]
        if not content then continue end
        local questState = data.quests and data.quests[questId]
        if not questState then
            return true
        end
        local totalParts = 0
        for _ in pairs(content.parts) do totalParts = totalParts + 1 end
        local currentPart = questState.currentPart or 1
        if currentPart > totalParts then continue end 
        local partContent = content.parts[currentPart]
        local partState = questState.parts and questState.parts[tostring(currentPart)]
        if partState and partState.claimed then continue end
        if not partContent or not partContent.tasks then continue end
        local allDone = true
        for taskIdx, task in ipairs(partContent.tasks) do
            local taskState = partState and partState.tasks and partState.tasks[tostring(taskIdx)]
            local amount = (taskState and taskState.amount) or 0
            local required = task.required or 0
            if required > 0 and amount < required then
                allDone = false
                break
            end
        end
        if allDone then return true end
    end
    return false
end
local function ResendWarios()
    local farmTarget = _lastFarmTarget
    if not farmTarget or not Toggles.AutoFarm or not Toggles.AutoFarm.Value then return end
    local sendRemote = Remotes.SendAndRetreat
    if not sendRemote then return end
    local warriorIds = GetEquippedWarriorIDs()
    if #warriorIds == 0 then return end
    pcall(function()
        sendRemote:FireServer(farmTarget.id, warriorIds)
    end)
end
local function DoAutoQuest()
    while Toggles.AutoQuest.Value do
        if not HasQuestWork() then
            repeat
                task.wait(1)
            until HasQuestWork() or not Toggles.AutoQuest.Value
            if not Toggles.AutoQuest.Value then break end
        end
        local takeQuestRemote = Remotes.TakeQuest
        local claimPartRemote = Remotes.ClaimQuestPart
        local data = GetPlayerData()
        if data then
            local questIds = GetQuestIdsFromContent()
            for _, questId in ipairs(questIds) do
                if not Toggles.AutoQuest.Value then break end
                local questState = data.quests and data.quests[questId]
                if not questState then
                    if takeQuestRemote then
                        TeleportToQuestNPC(questId)
                        local ok, res = pcall(function()
                            return takeQuestRemote:InvokeServer(questId)
                        end)
                        if ok and res then
                            task.wait(0.5)
                        end
                        ResendWarios()
                    end
                else
                    local questsModule = GetSafeModule(_world and _world:FindFirstChild("quests") and _world or (_content and _content:FindFirstChild("world")), "quests")
                    local questsContent = questsModule and questsModule.questsContent
                    local qContent = questsContent and questsContent[questId]
                    if qContent then
                        local totalParts = 0
                        for _ in pairs(qContent.parts) do totalParts = totalParts + 1 end
                        local currentPart = questState.currentPart or 1
                        if currentPart <= totalParts then
                            local partContent = qContent.parts[currentPart]
                            local partState = questState.parts and questState.parts[tostring(currentPart)]
                            local isClaimable = (not (partState and partState.claimed))
                            if isClaimable and partContent and partContent.tasks then
                                for taskIdx, task in ipairs(partContent.tasks) do
                                    local taskState = partState and partState.tasks and partState.tasks[tostring(taskIdx)]
                                    local amount = (taskState and taskState.amount) or 0
                                    local required = task.required or 0
                                    if required > 0 and amount < required then
                                        isClaimable = false
                                        break
                                    end
                                end
                            end
                            if isClaimable and claimPartRemote then
                                TeleportToQuestNPC(questId)
                                local ok, res = pcall(function()
                                    return claimPartRemote:InvokeServer(questId)
                                end)
                                if ok and res and res.success then
                                    task.wait(0.5)
                                end
                                ResendWarios()
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        else
        end
        task.wait(.1)
    end
end
local function GetEggIDs()
    local eggs = Modules.Eggs
    if eggs then
        local content = eggs.eggsContent or eggs
        local ids = {}
        for id, _ in pairs(content) do
            if type(id) == "string" then
                table.insert(ids, id)
            end
        end
        if #ids > 0 then
            table.sort(ids)
            return ids
        end
    end
    return { "Nemak", "Corps", "Ninja", "Sky" }
end
local EggIDs = GetEggIDs()
local function DoAutoEggs()
    while Toggles.AutoEggs.Value do
        if _raidActive then continue end
        local selectedEgg = Options.EggSelect.Value
        if not selectedEgg or selectedEgg == "" then
            selectedEgg = "Nemak"
        end
        local openRemote = Remotes.OpenEggs
        if openRemote then
            local ok, res = pcall(function()
                return openRemote:InvokeServer(selectedEgg)
            end)
            if ok and res then
            elseif not ok then
            end
        else
        end
        task.wait()
    end
end
local TIER_MULT = { 1, 1.25, 1.55, 1.9, 2.3 }
local function GetWarriorRawDamage(warrior, wContent)
    local entry = wContent and wContent.warriorsContent and wContent.warriorsContent[warrior.name]
    if not entry then return 0 end
    local damage = entry.stats and entry.stats.damage or 0
    if warrior.shiny then
        damage = damage + math.floor(damage * 0.6)
    end
    local scaledDmg = math.max(math.floor(damage * 1.1078 ^ (warrior.level - 1) ^ 1.014), damage)
    local tierMult = TIER_MULT[(warrior.tier or 0) + 1] or TIER_MULT[#TIER_MULT]
    return math.floor(scaledDmg * tierMult)
end
local function DoAutoEquipBest()
    local lastBestSet = nil 
    while Toggles.AutoEquipBest.Value do
        local equipRemote = Remotes.EquipBestWarrior
        local unequipRemote = Remotes.UnequipAllWarriors
        if not equipRemote then
            task.wait(1)
            continue
        end
        local data = GetPlayerData()
        if not data or not data.warriors then
            task.wait(1)
            continue
        end
        local _humans = _content and _content:FindFirstChild("humans")
        local wContent = GetSafeModule(_humans, "warriors")
        local sorted = {}
        for id, warrior in pairs(data.warriors) do
            table.insert(sorted, { id = id, dmg = GetWarriorRawDamage(warrior, wContent) })
        end
        table.sort(sorted, function(a, b) return a.dmg > b.dmg end)
        local slotCount = 0
        if data.equippedWarriors then
            for _ in pairs(data.equippedWarriors) do
                slotCount = slotCount + 1
            end
        end
        slotCount = math.max(slotCount, 1)
        local bestSet = {}
        for i = 1, math.min(slotCount, #sorted) do
            bestSet[sorted[i].id] = true
        end
        local alreadyOptimal = true
        if data.equippedWarriors then
            for _, equippedId in pairs(data.equippedWarriors) do
                if equippedId and equippedId ~= "" and not bestSet[equippedId] then
                    alreadyOptimal = false
                    break
                end
            end
        else
            alreadyOptimal = false
        end
        local bestKey = table.concat(sorted and (function()
            local t = {}
            for id in pairs(bestSet) do table.insert(t, id) end
            table.sort(t)
            return t
        end)() or {}, ",")
        if alreadyOptimal and lastBestSet == bestKey then
            task.wait(1)
            continue
        end
        local sortedIds = {}
        for _, entry in ipairs(sorted) do
            table.insert(sortedIds, entry.id)
        end
        if unequipRemote then
            pcall(function() unequipRemote:FireServer() end)
            task.wait(0.3)
        end
        local ok, err = pcall(function()
            equipRemote:FireServer(sortedIds)
        end)
        if ok then
            lastBestSet = bestKey
        else
        end
        task.wait(1)
    end
end
local function GetBoostIDs()
    local _monetization = _content and _content:FindFirstChild("monetization")
    local boostsModule = _monetization and GetSafeModule(_monetization, "boosts")
    if boostsModule and boostsModule.boostsContent then
        local ids = {}
        for id in pairs(boostsModule.boostsContent) do
            table.insert(ids, id)
        end
        table.sort(ids)
        return ids
    end
end
local ALL_BOOST_IDS = GetBoostIDs()
local function GetBoostTimeLeft(data, boostId)
    local b = data.boosts and data.boosts[boostId]
    if not b then return 0 end
    return b.timeLeft or 0
end
local function IsBoostRunning(data, boostId)
    local b = data.boosts and data.boosts[boostId]
    if not b then return false end
    return b.running == true
end
local function GetItemCount(data, itemId)
    local slot = data.items and data.items[itemId]
    if not slot then return 0 end
    return slot.amount or 0
end
local function DoAutoBoosts()
    while Toggles.AutoBoosts.Value do
        local remote = Remotes.UseBoost
        local runningRemote = Remotes.SetBoostRunning
        if not remote then
            task.wait(10)
            continue
        end
        local selectedBoosts = Options.BoostSelect.Value or {}
        local selected = {}
        for id, active in pairs(selectedBoosts) do
            if active then table.insert(selected, id) end
        end
        if #selected == 0 then
            task.wait(2)
            continue
        end
        local data = GetPlayerData()
        if not data then
            task.wait(2)
            continue
        end
        for _, boostId in ipairs(selected) do
            local timeLeft = GetBoostTimeLeft(data, boostId)
            local running  = IsBoostRunning(data, boostId)
            if running and timeLeft > 0 then
            elseif not running and timeLeft > 0 and runningRemote then
                pcall(function()
                    runningRemote:FireServer(boostId, true)
                end)
            else
                local count = GetItemCount(data, boostId)
                if count > 0 then
                    local ok, res = pcall(function()
                        remote:FireServer(boostId, 1)
                    end)
                    if ok then
                    else
                    end
                    task.wait(0.5)
                else
                end
            end
        end
        task.wait(1)
    end
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
	Main     = Window:AddTab("Main"),
	Eggs     = Window:AddTab("Eggs"),
	Priority = Window:AddTab("Priority"),
	Misc     = Window:AddTab("Misc"),
    Config   = Window:AddTab("Config"),
}
local PriorityTasks = { "Raid", "Gauntlet", "Farm" }
local DefaultPriority = { "Raid", "Gauntlet", "Farm" }
local PriorityBox = Tabs.Priority:AddLeftGroupbox("Task Priority")
for i = 1, #PriorityTasks do
    PriorityBox:AddDropdown("SelectedPriority_" .. i, {
        Text = "Priority " .. i,
        Values = PriorityTasks,
        Default = DefaultPriority[i],
        Multi = false,
        AllowNull = false,
        Callback = function(val)
            local order = GetPriorityOrder()
        end,
    })
end
local LeftBoxFarm    = Tabs.Main:AddLeftGroupbox("Auto Farm")
local RightBoxRaid   = Tabs.Main:AddRightGroupbox("Gamemodes")
local LeftBoxRewards = Tabs.Main:AddLeftGroupbox("Claim Rewards")
local RightBoxBoosts = Tabs.Eggs:AddRightGroupbox("Auto Boosts")
local EggsBox = Tabs.Eggs:AddLeftGroupbox("Auto Eggs")
local PlayerGroup = Tabs.Misc:AddRightGroupbox("Player")
local ServerGroup = Tabs.Misc:AddLeftGroupbox("Server")
LeftBoxFarm:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(state)
        Thread("AutoFarm", DoAutoFarm, state)
    end
})
LeftBoxFarm:AddDropdown("FarmTargetMode", {
    Text = "Target Mode",
    Values = { "Nearest", "Quest", "Selected" },
    Default = "Nearest",
    AllowNull = false,
    Callback = function(_)
        _farmModeChanged = true
    end,
})
LeftBoxFarm:AddInput("FarmMaxRange", {
    Text = "Max Range (Nearest)",
    Default = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
    end
})
local FarmEnemyList = GetAllEnemyNames()
LeftBoxFarm:AddDropdown("FarmEnemySelect", {
    Text = "Enemy Filter (Selected mode)",
    Values = FarmEnemyList,
    Default = {},
    Multi = true,
    AllowNull = true,
    Searchable = true,
})
RightBoxRaid:AddDropdown("RaidSelect", {
    Text = "Raid",
    Values = { "Destroyed Nemak", "Red Ribbon Base", "Clan Hideout", "Desert Kingdom" },
    Default = "Destroyed Nemak",
    Searchable = true,
    AllowNull = false,
})
RightBoxRaid:AddDropdown("RaidType", {
    Text = "Raid Type",
    Values = { "Normal", "Cursed" },
    Default = "Normal",
})
RightBoxRaid:AddToggle("AutoRaid", {
    Text = "Auto Raid",
    Default = false,
    Callback = function(state)
        Thread("AutoRaid", DoAutoRaid, state)
    end
})
RightBoxRaid:AddToggle("AutoGauntlet", {
    Text = "Auto Gauntlet",
    Default = false,
    Callback = function(state)
        Thread("AutoGauntlet", DoAutoGauntlet, state)
    end
})
RightBoxRaid:AddToggle("AutoQuest", {
    Text = "Auto Quest",
    Default = false,
    Callback = function(state)
        Thread("AutoQuest", DoAutoQuest, state)
    end
})
LeftBoxRewards:AddToggle("AutoRewards", {
    Text = "Auto Rewards",
    Default = false,
    Callback = function(state)
        Thread("AutoRewards", DoAutoRewards, state)
    end
})
LeftBoxRewards:AddToggle("AutoBattlepassRewards", {
    Text = "Claim Battlepass Rewards",
    Default = true,
})
LeftBoxRewards:AddToggle("AutoQuestRewards", {
    Text = "Claim Quest Rewards",
    Default = true,
})
LeftBoxRewards:AddToggle("AutoMilestones", {
    Text = "Claim Milestones",
    Default = true,
})
LeftBoxRewards:AddToggle("AutoAchievements", {
    Text = "Claim Achievements",
    Default = true,
})
RightBoxBoosts:AddToggle("AutoBoosts", {
    Text = "Auto Use Boosts",
    Default = false,
    Callback = function(state)
        Thread("AutoBoosts", DoAutoBoosts, state)
    end
})
RightBoxBoosts:AddDropdown("BoostSelect", {
    Text = "Boosts to Use",
    Values = ALL_BOOST_IDS,
    Default = {},
    Multi = true,
    AllowNull = true,
})
EggsBox:AddDropdown("EggSelect", {
    Text = "Egg to Open",
    Values = EggIDs,
    Default = "Nemak",
    AllowNull = false,
})
EggsBox:AddToggle("AutoEggs", {
    Text = "Auto Open Eggs",
    Default = false,
    Callback = function(state)
        Thread("AutoEggs", DoAutoEggs, state)
    end
})
EggsBox:AddDropdown("DismantleRarities", {
    Text = "Dismantle Rarities",
    Values = { "common", "rare", "epic", "legendary", "mythical", "exclusive", "???" },
    Default = {},
    Multi = true,
    AllowNull = true,
})
EggsBox:AddToggle("AutoDismantle", {
    Text = "Auto Dismantle Warriors",
    Default = false,
})
task.spawn(function()
    while true do
        task.wait(1)
        if not Toggles.AutoDismantle.Value then continue end
        if _raidActive then continue end
        local remote = Remotes.DismantleWarrior
        if not remote then continue end
        local selectedRarities = {}
        for rarity, active in pairs(Options.DismantleRarities.Value) do
            if active then selectedRarities[rarity] = true end
        end
        if next(selectedRarities) == nil then continue end
        local data = GetPlayerData()
        if not data or not data.warriors then continue end
        local _humans = _content and _content:FindFirstChild("humans")
        local wContent = GetSafeModule(_humans, "warriors")
        local warriorsContent = wContent and wContent.warriorsContent
        if not warriorsContent then continue end
        local equippedSet = {}
        for _, wid in pairs(data.equippedWarriors or {}) do
            if wid and wid ~= "" then equippedSet[wid] = true end
        end
        local toDismantle = {}
        for id, warrior in pairs(data.warriors) do
            if warrior.locked then continue end
            if equippedSet[id] then continue end
            local content = warriorsContent[warrior.name]
            if not content then continue end
            if selectedRarities[content.rarity] then
                table.insert(toDismantle, id)
            end
        end
        if #toDismantle == 0 then continue end
        local BATCH = 100
        for i = 1, #toDismantle, BATCH do
            local batch = {}
            for j = i, math.min(i + BATCH - 1, #toDismantle) do
                table.insert(batch, toDismantle[j])
            end
            local ok, res = pcall(function()
                return remote:InvokeServer(batch)
            end)
            if ok and res and (res.warriorsDismantled or 0) > 0 then
            end
            task.wait(0.5)
        end
    end
end)
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
            for i, v in pairs(Workspace:GetDescendants()) do
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
Toggles.FPSBoost:OnChanged(function(state)
    ApplyFPSBoost(state)
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
local MiscBoxLeft = Tabs.Misc:AddLeftGroupbox("Utilities")
MiscBoxLeft:AddButton("Set Spawn Point Here", function()
    local char = GetCharacter()
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local remote = Remotes.SetSpawnPoint
            if remote then
                pcall(function()
                    remote:FireServer("default")
                end)
                Library:Notify("Set spawn point!", 3)
            end
        end
    end
end)
MiscBoxLeft:AddButton("Pause All Boosts", function()
    local remote = Remotes.SetBoostRunning
    if not remote then
        return
    end
    local data = GetPlayerData()
    if not data or not data.boosts then
        return
    end
    local count = 0
    for boostId, b in pairs(data.boosts) do
        if b.running == true and (b.timeLeft or 0) > 0 then
            pcall(function() remote:FireServer(boostId, false) end)
            count = count + 1
        end
        task.wait(1.5)
    end
    Library:Notify("Paused " .. count .. " boost(s)", 3)
end)
MiscBoxLeft:AddButton("Enable All Boosts", function()
    local remote = Remotes.SetBoostRunning
    if not remote then
        return
    end
    local data = GetPlayerData()
    if not data or not data.boosts then
        return
    end
    local count = 0
    for boostId, b in pairs(data.boosts) do
        if b.running == false and (b.timeLeft or 0) > 0 then
            pcall(function() remote:FireServer(boostId, true) end)
            count = count + 1
        end
        task.wait(1.5)
    end
    Library:Notify("Enabled " .. count .. " boost(s)", 3)
end)
MiscBoxLeft:AddToggle("AutoEquipBest", {
    Text = "Auto Equip Best",
    Default = false,
    Callback = function(state)
        Thread("AutoEquipBest", DoAutoEquipBest, state)
    end
})
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
    local stateRemote = Remotes.SetAutomationState
    if stateRemote then
        pcall(function()
            stateRemote:FireServer("clicker", false)
            stateRemote:FireServer("attack", false)
        end)
    end
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/AnimeWarriorsIII")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
Library:Notify("Yuri.", 2)
Library:Notify("Report bug and give suggestion in Discord!", 5)
end) 
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
    warn("SCRIPT ERROR:", err)
end
