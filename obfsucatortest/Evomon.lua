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
            local inviteCode = "uuza7nsPq"
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
local function GetSafeModule(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local function GetObject(parent, pathString)
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
local Remotes = {
    ReqEnterNpcBattle              = GetObject(RS, "Remote.Battle.ReqEnterNpcBattle"),
    ReqEnterPetBattle              = GetObject(RS, "Remote.Battle.ReqEnterPetBattle"),
    ReqOperateBattle               = GetObject(RS, "Remote.Battle.ReqOperateBattle"),
    ResBroadcastBattleAction       = GetObject(RS, "Remote.Battle.ResBroadcastBattleAction"),
    ReqReportEnterBossBattle       = GetObject(RS, "Remote.Battle.ReqReportEnterBossBattle"),
    ResSelectBossBattleFirstcall   = GetObject(RS, "Remote.Battle.ResSelectBossBattleFirstcall"),
    ReqRemovePets                  = GetObject(RS, "Remote.Pet.ReqRemovePets"),
    ReqReceiveTask                 = GetObject(RS, "Remote.Task.ReqReceiveTask"),
    ReqCompleteTask                = GetObject(RS, "Remote.Task.ReqCompleteTask"),
    ReqApplyPurchaseGoods          = GetObject(RS, "Remote.Shop.ReqApplyPurchaseGoods"),
    ReqSetSummonMonsterAuto        = GetObject(RS, "Remote.SummonMonster.ReqSetSummonMonsterAuto"),
}
local Modules = {}
do
    local Script = RS:WaitForChild("Script")
    local Core   = RS:WaitForChild("Core")
    local ChestScript    = Script:WaitForChild("Chest")
    local ChestBasic     = ChestScript:WaitForChild("Basic")
    local CreatureFolder = Script:WaitForChild("Creature")
    local CreatureBasic  = CreatureFolder:WaitForChild("Basic")
    local Config         = Core:WaitForChild("Config")
    Modules.ChestService        = GetSafeModule(ChestScript, "ChestService")
    Modules.ChestConst          = GetSafeModule(ChestBasic, "ChestConst")
    Modules.ErrorCode           = GetSafeModule(Core:WaitForChild("Tools"), "ErrorCode")
    Modules.BattleService       = GetSafeModule(Script:WaitForChild("Battle"), "BattleService")
    Modules.BattleDataGetModule = GetSafeModule(Script:WaitForChild("MainBattleWindow"), "BattleDataGetModule")
    Modules.CreatureService     = GetSafeModule(CreatureFolder, "CreatureService")
    Modules.CreatureConst       = GetSafeModule(CreatureBasic, "CreatureConst")
    Modules.PetService          = GetSafeModule(Script:WaitForChild("Pet"), "PetService")
    Modules.ConfigDataManager   = GetSafeModule(Config, "ConfigDataManager")
    Modules.ConfigConst         = GetSafeModule(Config, "ConfigConst")
    Modules.MessagePackUtil     = GetSafeModule(Core:WaitForChild("Tools"), "MessagePackUtil")
    local Storage = RS:WaitForChild("Storage")
    Modules.BagStorage  = GetSafeModule(Storage, "BagStorage")
    Modules.ItemComm    = GetSafeModule(Script:WaitForChild("Item"), "ItemComm")
    Modules.PetStorage      = GetSafeModule(Storage, "PetStorage")
    Modules.PetGroupStorage = GetSafeModule(Storage, "PetGroupStorage")
    Modules.GoalStorage = GetSafeModule(Storage, "GoalStorage")
    Modules.TaskStorage = GetSafeModule(Storage, "TaskStorage")
    Modules.TaskComm    = GetSafeModule(Script:WaitForChild("Task"), "TaskComm")
    local ManyWorldsFolder = Script:WaitForChild("ManyWorlds")
    local ManyWorldsBasic  = ManyWorldsFolder:WaitForChild("Basic")
    Modules.MWService  = GetSafeModule(ManyWorldsFolder, "ManyWorldsService")
    Modules.MWComm     = GetSafeModule(ManyWorldsFolder, "ManyWorldsComm")
    Modules.MWConst    = GetSafeModule(ManyWorldsBasic, "ManyWorldsConst")
    Modules.MWStorage  = GetSafeModule(Storage, "ManyWorldsStorage")
    local DungeonFolder = Script:WaitForChild("Dungeon")
    local DungeonBasic  = DungeonFolder:WaitForChild("Basic")
    Modules.DungeonService       = GetSafeModule(DungeonFolder, "DungeonService")
    Modules.DungeonModule        = GetSafeModule(DungeonBasic, "DungeonModule")
    Modules.DungeonConst         = GetSafeModule(DungeonBasic, "DungeonConst")
    Modules.DungeonStorage       = GetSafeModule(Storage, "DungeonStorage")
    Modules.DungeonSceneStorage  = GetSafeModule(RS:WaitForChild("SceneStorage"), "DungeonSceneStorage")
    Modules.DungeonResultService = GetSafeModule(Script:WaitForChild("DungeonResult"), "DungeonResultService")
    Modules.TowerDungeonService   = GetSafeModule(DungeonFolder, "TowerDungeonService")
    Modules.DataStatisticsService = GetSafeModule(Script:WaitForChild("DataStatistics"), "DataStatisticsService")
    Modules.DataStatisticsConst   = GetSafeModule(Script:WaitForChild("DataStatistics"):WaitForChild("Basic"), "DataStatisticsConst")
    Modules.RefreshService        = GetSafeModule(Script:WaitForChild("RefreshSystem"), "RefreshService")
    Modules.PetGroupService       = GetSafeModule(Script:WaitForChild("PetGroup"), "PetGroupService")
    Modules.ElementModule         = GetSafeModule(Script:WaitForChild("Element"), "ElementModule")
    local HatchEggFolder          = Script:WaitForChild("HatchEgg")
    Modules.HatchEggService       = GetSafeModule(HatchEggFolder, "HatchEggService")
end
local GoodsConfig = {}
do
    local cfgFolder = RS:FindFirstChild("Config")
    local cfgModule = cfgFolder and cfgFolder:FindFirstChild("GoodsConfig")
    if cfgModule then
        local ok, result = pcall(require, cfgModule)
        if ok and type(result) == "table" then GoodsConfig = result end
    end
end
local ShopItemValues = {}
local ShopItemIdByLabel = {}
for id, entry in pairs(GoodsConfig) do
    if type(entry) == "table" and type(entry.name) == "string" and not entry.name:find("[^\1-\127]")
        and entry.productId == nil and entry.giftEnabled ~= true then
        local label = entry.name .. " (" .. id .. ")"
        ShopItemIdByLabel[label] = id
        table.insert(ShopItemValues, label)
    end
end
table.sort(ShopItemValues)
local BattleSpeed = {
    CC = nil,
    SC = nil,
    origCC = {},
    origSC = {},
}
task.spawn(function()
    local Script = RS:WaitForChild("Script", 15)
    if not Script then return end
    local BattleChoreo = Script:WaitForChild("BattleChoreo", 15)
    if BattleChoreo then
        local Basic = BattleChoreo:WaitForChild("Basic", 15)
        if Basic then
            local ChoreoConstModule = Basic:WaitForChild("BattleChoreoConst", 15)
            if ChoreoConstModule then
                local ok, CC = pcall(require, ChoreoConstModule)
                if ok and type(CC) == "table" then
                    BattleSpeed.CC = CC
                    for _, k in ipairs({ "DefaultActionWaitTime", "SettleNodeWaitTime", "StartBattleBeforeChoreographyDelayTime", "FirstRoundEmptyActionResultsAnimationCompleteDelay", "ForceSwitchAnimationCompleteDelay", "OpeningThrowBallPreDelay", "OpeningThrowBallPostDelay" }) do
                        if type(CC[k]) == "number" then BattleSpeed.origCC[k] = CC[k] end
                    end
                    if type(CC.ActionWaitTimeByType) == "table" then
                        BattleSpeed.origCC.ActionWaitTimeByType = {}
                        for k, v in pairs(CC.ActionWaitTimeByType) do
                            if type(v) == "number" then BattleSpeed.origCC.ActionWaitTimeByType[k] = v end
                        end
                    end
                    if type(CC.SettleNodeWaitTimeByType) == "table" then
                        BattleSpeed.origCC.SettleNodeWaitTimeByType = {}
                        for k, v in pairs(CC.SettleNodeWaitTimeByType) do
                            if type(v) == "number" then BattleSpeed.origCC.SettleNodeWaitTimeByType[k] = v end
                        end
                    end
                end
            end
        end
    end
    local Pet = Script:WaitForChild("Pet", 15)
    if Pet then
        local Cfg = Pet:WaitForChild("Cfg", 15)
        if Cfg then
            local SkillCfgModule = Cfg:WaitForChild("SkillPerformanceCfg", 15)
            if SkillCfgModule then
                local ok2, SC = pcall(require, SkillCfgModule)
                if ok2 and type(SC) == "table" then
                    BattleSpeed.SC = SC
                    for skillId, data in pairs(SC) do
                        if type(data) == "table" and type(data.finishWaitTime) == "number" then
                            BattleSpeed.origSC[skillId] = data.finishWaitTime
                        end
                    end
                end
            end
        end
    end
    notyuri("[BattleSpeed] Modules ready")
    local mult = tonumber(Options.BattleSpeedMult and Options.BattleSpeedMult.Value) or 10
    if mult > 1 then ApplyBattleSpeedMult(mult) end
end)
function ApplyBattleSpeedMult(mult)
    mult = tonumber(mult) or 1
    if mult < 1 then mult = 1 end
    local CC = BattleSpeed.CC
    if CC then
        for _, k in ipairs({ "DefaultActionWaitTime", "SettleNodeWaitTime", "StartBattleBeforeChoreographyDelayTime" }) do
            if BattleSpeed.origCC[k] then CC[k] = BattleSpeed.origCC[k] / mult end
        end
        for _, k in ipairs({ "FirstRoundEmptyActionResultsAnimationCompleteDelay", "ForceSwitchAnimationCompleteDelay", "OpeningThrowBallPreDelay", "OpeningThrowBallPostDelay" }) do
            if BattleSpeed.origCC[k] then
                CC[k] = mult > 1 and (k:find("Throw") and 0.01 or 0.05) or BattleSpeed.origCC[k]
            end
        end
        if type(CC.ActionWaitTimeByType) == "table" and BattleSpeed.origCC.ActionWaitTimeByType then
            for k, origV in pairs(BattleSpeed.origCC.ActionWaitTimeByType) do
                CC.ActionWaitTimeByType[k] = origV / mult
            end
        end
        if type(CC.SettleNodeWaitTimeByType) == "table" and BattleSpeed.origCC.SettleNodeWaitTimeByType then
            for k, origV in pairs(BattleSpeed.origCC.SettleNodeWaitTimeByType) do
                CC.SettleNodeWaitTimeByType[k] = origV / mult
            end
        end
    end
    local SC = BattleSpeed.SC
    if SC then
        for skillId, data in pairs(SC) do
            if type(data) == "table" and BattleSpeed.origSC[skillId] then
                data.finishWaitTime = math.max(50, math.floor(BattleSpeed.origSC[skillId] / mult))
            end
        end
    end
    notyuri("[BattleSpeed] Applied mult:", mult)
end
local Tables = {
    ElementCounterMap = {},
    Support = Support,
}
local Shared = {
    selectedNpcs        = {},
    selectedMobs        = {},
    currentCatchPetInfo = nil,
}
local Flags = {}
local Connections = {
    Player_General    = nil,
    Knockback         = {},
    Reconnect         = nil,
    CatchPetInfoHook  = nil,
    WorldTravel       = {},
    Dungeon           = {},
    Tower             = {},
}
do
    local ok, cfg = pcall(function()
        return Modules.ConfigDataManager.getTable(Modules.ConfigConst.ConfigName.ELEMENT_COUNTER)
    end)
    if ok and cfg then
        for _, entry in pairs(cfg) do
            if entry and entry.id then
                Tables.ElementCounterMap[entry.id] = entry
            end
        end
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
local function Func_AutoChests()
    local ChestService = Modules.ChestService
    local ChestConst = Modules.ChestConst
    local ErrorCode = Modules.ErrorCode
    while Toggles.AutoChests.Value do
        for uid in pairs(ChestService.getChests()) do
            if not Toggles.AutoChests.Value then break end
            if ChestService.isChest(uid) and ChestService.getChestType(uid) == ChestConst.ChestType.Normal then
                local errCode = ChestService.applyClaimExploreReward(uid)
                if errCode == ErrorCode.SUCCEEDED then
                    notyuri("[AutoClaimChest] Claimed chest", uid)
                else
                    notyuri("[AutoClaimChest] Failed to claim chest", uid, "ErrorCode:", errCode)
                end
                task.wait(0.2)
            end
        end
        task.wait(2)
    end
end
local function Func_AutoChallengeChests()
    local ChestService    = Modules.ChestService
    local ChestConst      = Modules.ChestConst
    while Toggles.AutoChallengeChests.Value do
        local maxLevel = tonumber(Options.MaxMonsterLevel.Value) or 0
        local minLevel = tonumber(Options.MinMonsterLevel.Value) or 0
        for uid in pairs(ChestService.getChests()) do
            if not Toggles.AutoChallengeChests.Value then break end
            if ChestService.isChest(uid)
            and ChestService.getChestType(uid) == ChestConst.ChestType.Challenge
            and ChestService.isChestChallengeable(uid) then
                local chestData = ChestService.getChest(uid)
                local guardUid  = chestData and chestData:get(ChestConst.FIELD_NAME.GUARD_MONSTER_UID)
                local guardLevel = nil
                if typeof(guardUid) == "string" and guardUid ~= "" then
                    local crOk, crErr, creature = pcall(function()
                        return Modules.CreatureService.get(guardUid)
                    end)
                    if crOk and crErr == Modules.ErrorCode.SUCCEEDED and creature then
                        local lvOk, lvErr, level = pcall(function()
                            return creature:getValue(Modules.CreatureConst.Index.level)
                        end)
                        if lvOk and lvErr == Modules.ErrorCode.SUCCEEDED and typeof(level) == "number" then
                            guardLevel = level
                        end
                    end
                end
                if typeof(guardLevel) == "number" then
                    if guardLevel > maxLevel or guardLevel < minLevel then
                        notyuri("[AutoChallengeChests] Skipping chest", uid, "guard level", guardLevel, "outside range", minLevel, "-", maxLevel)
                        continue
                    end
                end
                if typeof(guardUid) == "string" and guardUid ~= "" then
                    notyuri("[AutoChallengeChests] Entering battle for chest:", uid, "guard:", guardUid, "level:", tostring(guardLevel))
                    Remotes.ReqEnterPetBattle:FireServer(guardUid)
                    task.wait(3)
                    local timeout = 120
                    while Modules.BattleService.getCurrentBattle() and timeout > 0 do
                        task.wait(1)
                        timeout -= 1
                    end
                    task.wait(1)
                end
                local errCode = ChestService.applyClaimExploreReward(uid)
                notyuri("[AutoChallengeChests] Claim chest:", uid, "result:", errCode)
                task.wait(0.5)
            end
        end
        task.wait(3)
    end
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
    if not fireproximityprompt then
        return
    end
    if not target or not target:IsA("ProximityPrompt") then
        return
    end
    local prevDist = target.MaxActivationDistance
    if teleport then
        local char = GetCharacter()  
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        if part and not part:IsA("BasePart") then
            part = target:FindFirstAncestorWhichIsA("BasePart")
        end
        if hrp and part then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist > (prevDist - 2) then
                hrp.CFrame = part.CFrame * CFrame.new(0, 0, -3)
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
AddInfo(Window)
local Tabs = {
    Main        = Window:AddTab("Main"),
    Player      = Window:AddTab("Player"),
    Config      = Window:AddTab("Config"),
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
        T2 = TB.Main.Left.Autofarm:AddTab("Dungeons"),
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
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Tables.Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Default = true,
    Disabled = not Tables.Support.Connections,
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
TB_Tabs.Autofarm.T1:AddToggle("AutoChests", {
    Text = "Auto Chests",
    Default = false,
})
Toggles.AutoChests:OnChanged(function(state)
    Thread("AutoChests", SafeLoop("Auto Claim Chests", Func_AutoChests), state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoChallengeChests", {
    Text = "Auto Challenge Chests",
    Default = false,
})
Toggles.AutoChallengeChests:OnChanged(function(state)
    Thread("AutoChallengeChests", SafeLoop("Auto Challenge Chests", Func_AutoChallengeChests), state)
end)
Tables.BossDropdownValues = {}
Tables.BossLookup = {}
do
    local npcTable  = Modules.ConfigDataManager.getTable(Modules.ConfigConst.ConfigName.NPC)
    local talkTable = Modules.ConfigDataManager.getTable(Modules.ConfigConst.ConfigName.TALK)
    local talkBattleMap = {}
    local talkNextMap   = {}
    if typeof(talkTable) == "table" then
        for tid, entry in pairs(talkTable) do
            if typeof(entry) ~= "table" then continue end
            local key = tostring(tid)
            if typeof(entry.battleId) == "number" then
                talkBattleMap[key] = entry.battleId
            end
            if typeof(entry.nextTalkIds) == "table" then
                talkNextMap[key] = entry.nextTalkIds
            end
        end
    end
    local function findBattleId(talkId, depth)
        if depth > 5 then return nil end
        local key = tostring(talkId)
        if talkBattleMap[key] then return talkBattleMap[key] end
        local nexts = talkNextMap[key]
        if typeof(nexts) == "table" then
            for _, nid in ipairs(nexts) do
                local result = findBattleId(nid, depth + 1)
                if result then return result end
            end
        end
        return nil
    end
    local entries = {}
    if typeof(npcTable) == "table" then
        for nid, entry in pairs(npcTable) do
            if typeof(entry) ~= "table" then continue end
            if entry.type ~= 4 then continue end
            local npcId    = entry.id or tonumber(nid)
            local isBoss   = (entry.isBoss or 0) > 0 or (entry.bossType or 0) > 0
            local npcName  = entry.npcHeadShowName or entry.npcName
            if not (typeof(npcName) == "string" and npcName ~= "") then continue end
            local clean = true
            for i = 1, #npcName do
                local b = string.byte(npcName, i)
                if b < 32 or b > 126 then clean = false break end
            end
            if not clean then continue end
            local battleId = nil
            if typeof(entry.npcInitialDialogueId) == "table" then
                for _, tid in ipairs(entry.npcInitialDialogueId) do
                    battleId = findBattleId(tid, 0)
                    if battleId then break end
                end
            end
            if not battleId then continue end
            local label = isBoss and npcName or ("[T] " .. npcName)
            table.insert(entries, {
                name      = label,
                npcId     = npcId,
                battleId  = battleId,
                isTrainer = not isBoss,
            })
        end
    end
    table.sort(entries, function(a, b)
        if a.isTrainer ~= b.isTrainer then return not a.isTrainer end
        return a.npcId < b.npcId
    end)
    for _, e in ipairs(entries) do
        table.insert(Tables.BossDropdownValues, e.name)
        Tables.BossLookup[e.name] = e
    end
    if #Tables.BossDropdownValues == 0 then
        table.insert(Tables.BossDropdownValues, "(none)")
    end
end
Tables.SummonBossDropdownValues = {}
Tables.SummonBossLookup = {}
do
    local CDM = Modules.ConfigDataManager
    local CC  = Modules.ConfigConst
    local summonIdToNpcId = {}
    local npcTable = CDM.getTable(CC.ConfigName.NPC)
    if typeof(npcTable) == "table" then
        for k, v in pairs(npcTable) do
            if typeof(k) == "number" and typeof(v) == "table"
                and v.isSummon == 1 and typeof(v.monsterSummonId) == "number" then
                summonIdToNpcId[v.monsterSummonId] = k
            end
        end
    end
    local sepTable = CDM.getTable(CC.ConfigName.SUMMON_ENEMY_PET)
    local entries = {}
    if typeof(sepTable) == "table" then
        for id, entry in pairs(sepTable) do
            if typeof(entry) ~= "table" then continue end
            local petCfg = typeof(entry.spawnPet) == "number"
                and CDM.getConfig(CC.ConfigName.PET, entry.spawnPet) or nil
            local petName = (petCfg and typeof(petCfg.name) == "string") and petCfg.name or tostring(id)
            local clean = true
            for i = 1, #petName do
                local b = string.byte(petName, i)
                if b < 32 or b > 126 then clean = false; break end
            end
            if not clean then continue end
            local npcId = typeof(entry.monsterSummonId) == "number"
                and summonIdToNpcId[entry.monsterSummonId] or nil
            if not npcId then continue end
            local level = typeof(entry.level) == "number" and entry.level or "?"
            local label = string.format("[Lv.%s] %s", tostring(level), petName)
            table.insert(entries, {
                name                   = label,
                summonEnemyPetConfigId = id,
                npcId                  = npcId,
                spawnNpcId             = entry.spawnNpcId,
                spawnPetBattleId       = entry.spawnPetBattleId,
            })
        end
    end
    table.sort(entries, function(a, b)
        return (a.summonEnemyPetConfigId or 0) < (b.summonEnemyPetConfigId or 0)
    end)
    for _, e in ipairs(entries) do
        table.insert(Tables.SummonBossDropdownValues, e.name)
        Tables.SummonBossLookup[e.name] = e
    end
    if #Tables.SummonBossDropdownValues == 0 then
        table.insert(Tables.SummonBossDropdownValues, "(none)")
    end
end
local function getBestPetUid(battleId)
    local fallback = Modules.PetService.getMainPetUid()
    local CDM = Modules.ConfigDataManager
    local CC  = Modules.ConfigConst
    local PGS = Modules.PetGroupService
    local EM  = Modules.ElementModule
    if not (CDM and CC and PGS and EM) then return fallback end
    local battleCfg = CDM.getConfig(CC.ConfigName.BATTLE_TRAINER, battleId)
    if not battleCfg then return fallback end
    local pool = battleCfg.positionPool
    if typeof(pool) ~= "table" or not pool[1] or not pool[1][1] then return fallback end
    local enemyPetCfg = CDM.getConfig(CC.ConfigName.ENEMY_PET, pool[1][1])
    if not enemyPetCfg or typeof(enemyPetCfg.petId) ~= "number" then return fallback end
    local petSpeciesCfg = CDM.getConfig(CC.ConfigName.PET, enemyPetCfg.petId)
    if not petSpeciesCfg then return fallback end
    local bossElements = petSpeciesCfg.elements
    if typeof(bossElements) ~= "table" or #bossElements == 0 then return fallback end
    local _, group = PGS.getCurrentPetGroup()
    if not group or typeof(group.petUuids) ~= "table" or #group.petUuids == 0 then return fallback end
    local bestUid  = nil
    local bestRate = -1
    for _, uid in ipairs(group.petUuids) do
        local err, itemData = PGS.getPetItemDataByPetUid(uid)
        if err == Modules.ErrorCode.SUCCEEDED and itemData then
            local cfgData = itemData.petCfgData
            if cfgData and typeof(cfgData.elements) == "table" and cfgData.elements[1] then
                local res = EM.calculateMultiElementRestraintRate(cfgData.elements[1], bossElements)
                if res and res.rate > bestRate then
                    bestRate = res.rate
                    bestUid  = uid
                end
            end
        end
    end
    return bestUid or fallback
end
local function FireBossEncounter(entry)
    if not entry then return end
    if entry.isTrainer then
        local firstPetUid = Modules.PetService.getMainPetUid()
        if not firstPetUid or firstPetUid == "" then
            Library:Notify("Could not get main pet UID.", 3)
            return
        end
        notyuri("[TrainerEncounter]", entry.name, entry.npcId, entry.battleId, firstPetUid)
        Remotes.ReqEnterNpcBattle:FireServer(entry.npcId, entry.battleId, firstPetUid)
    else
        local firstPetUid = getBestPetUid(entry.battleId)
        if not firstPetUid or firstPetUid == "" then
            Library:Notify("Could not get main pet UID.", 3)
            return
        end
        notyuri("[BossEncounter]", entry.name, entry.npcId, entry.battleId, firstPetUid)
        Remotes.ReqEnterNpcBattle:FireServer(entry.npcId, entry.battleId, firstPetUid)
    end
end
TB_Tabs.Autofarm2.T1:AddDropdown("SelectedSummonBoss", {
    Text      = "Select Summon Boss",
    Values    = Tables.SummonBossDropdownValues,
    Default   = {},
    Multi     = false,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("SelectedNpc", {
    Text = "Select Npc",
    Values = Tables.BossDropdownValues,
    Default = {},
    Multi = true,
    Searchable = true,
})
Options.SelectedNpc:OnChanged(function()
    table.clear(Shared.selectedNpcs)
    for name, active in pairs(Options.SelectedNpc.Value) do
        if active then table.insert(Shared.selectedNpcs, name) end
    end
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoSummonBoss", {
    Text    = "Auto Summon Boss",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoNpcEncounter", {
    Text = "Auto Npc Encounter",
    Default = false,
})
Tables.WildMonsterNames = {}
do
    local petTable = Modules.ConfigDataManager.getTable(Modules.ConfigConst.ConfigName.PET)
    local seen = {}
    if typeof(petTable) == "table" then
        for _, entry in pairs(petTable) do
            local name = typeof(entry) == "table" and entry.name or nil
            if typeof(name) ~= "string" or name == "" then continue end
            local isClean = true
            for i = 1, #name do
                local b = string.byte(name, i)
                if b < 32 or b > 126 then
                    isClean = false
                    break
                end
            end
            if not isClean then continue end
            if not seen[name] then
                seen[name] = true
                table.insert(Tables.WildMonsterNames, name)
            end
        end
    end
    table.sort(Tables.WildMonsterNames)
    if #Tables.WildMonsterNames == 0 then
        table.insert(Tables.WildMonsterNames, "(none)")
    else
        table.insert(Tables.WildMonsterNames, 1, "All")
    end
end
local DoWildEncounter  
TB_Tabs.Autofarm2.T1:AddDropdown("SelectedMonster", {
    Text = "Select Monster",
    Values = Tables.WildMonsterNames,
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddInput("MaxMonsterLevel", {
    Text        = "Monster Max Level",
    Default     = "0",
    Numeric     = true,
})
TB_Tabs.Autofarm2.T1:AddInput("MinMonsterLevel", {
    Text        = "Monster Min Level",
    Default     = "0",
    Numeric     = true,
})
Options.SelectedMonster:OnChanged(function()
    table.clear(Shared.selectedMobs)
    for name, active in pairs(Options.SelectedMonster.Value) do
        if active then table.insert(Shared.selectedMobs, name) end
    end
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoWildEncounter", {
    Text = "Auto Wild Encounter",
    Default = false,
})
DoWildEncounter = function()
    local maxLevel = tonumber(Options.MaxMonsterLevel.Value) or 0
    local minLevel = tonumber(Options.MinMonsterLevel.Value) or 0
    if #Shared.selectedMobs == 0 then return end
    local selectedSet = {}
    local matchAll = false
    for _, n in ipairs(Shared.selectedMobs) do
        if n == "All" then
            matchAll = true
        else
            selectedSet[n] = true
        end
    end
    local ok, errCode, list = pcall(function()
        return Modules.CreatureService.getCreatureListByType(Modules.CreatureConst.CreatureType.WILD_PET)
    end)
    if not ok or errCode ~= Modules.ErrorCode.SUCCEEDED or not list then return end
    local bestUid   = nil
    local bestLevel = math.huge
    local bestName  = nil
    for uid, creature in pairs(list) do
        if not (typeof(uid) == "string" and creature and getmetatable(creature)) then continue end
        local isOk, isErrCode, isCombating = pcall(function()
            return creature:getValue(Modules.CreatureConst.Index.isCombating)
        end)
        if isOk and isErrCode == Modules.ErrorCode.SUCCEEDED and isCombating == true then continue end
        local configId = creature.configId
        if typeof(configId) ~= "number" then continue end
        local cfg = Modules.ConfigDataManager.getConfig(Modules.ConfigConst.ConfigName.PET, configId)
        if not cfg or not (matchAll or selectedSet[cfg.name]) then continue end
        local lvOk, lvErrCode, level = pcall(function()
            return creature:getValue(Modules.CreatureConst.Index.level)
        end)
        level = (lvOk and lvErrCode == Modules.ErrorCode.SUCCEEDED and typeof(level) == "number") and level or 0
        if maxLevel > 0 and level > maxLevel then continue end
        if minLevel > 0 and level < minLevel then continue end
        if level < bestLevel then
            bestLevel = level
            bestUid = uid
            bestName = cfg.name
        end
    end
    if not bestUid then return end
    notyuri("[WildEncounter] Firing ReqEnterPetBattle:", bestUid, "level:", bestLevel)
    Library:Notify("Encountering " .. bestName .. " (Lv." .. bestLevel .. ")", 3)
    Remotes.ReqEnterPetBattle:FireServer(bestUid)
end
local function DoAutoSummonBoss()
    local sel = Options.SelectedSummonBoss.Value
    if not (sel and sel ~= "" and Tables.SummonBossLookup[sel]) then return end
    local entry = Tables.SummonBossLookup[sel]
    if not (typeof(entry.npcId) == "number" and typeof(entry.spawnNpcId) == "number"
            and typeof(entry.spawnPetBattleId) == "number") then return end
    local ok, result = pcall(function()
        return Remotes.ReqSetSummonMonsterAuto:InvokeServer(true, entry.npcId, entry.summonEnemyPetConfigId)
    end)
    if not ok then
        warn("[AutoSummonBoss] SetAutoSummon error:", result)
        return
    end
    task.wait(1.5)
    if Modules.BattleService.getCurrentBattle() then return end
    local petUid = getBestPetUid(entry.spawnPetBattleId)
    if not petUid or petUid == "" then
        Library:Notify("Could not get pet UID for summon boss.", 3)
        return
    end
    notyuri("[SummonBoss] Entering:", entry.name, entry.spawnNpcId, entry.spawnPetBattleId, petUid)
    Remotes.ReqEnterNpcBattle:FireServer(entry.spawnNpcId, entry.spawnPetBattleId, petUid)
end
local function anyEncounterActive()
    return Toggles.AutoSummonBoss.Value or Toggles.AutoNpcEncounter.Value or Toggles.AutoWildEncounter.Value
end
local function Func_AutoEncounter()
    while anyEncounterActive() do
        if not Modules.BattleService.getCurrentBattle() then
            local handled = false
            if Toggles.AutoSummonBoss.Value then
                local sel = Options.SelectedSummonBoss.Value
                if sel and sel ~= "" and Tables.SummonBossLookup[sel] then
                    pcall(DoAutoSummonBoss)
                    handled = true
                end
            end
            if not handled and Toggles.AutoNpcEncounter.Value and #Shared.selectedNpcs > 0 then
                for _, name in ipairs(Shared.selectedNpcs) do
                    local entry = Tables.BossLookup[name]
                    if entry then pcall(FireBossEncounter, entry) end
                end
                handled = true
            end
            if not handled and Toggles.AutoWildEncounter.Value then
                pcall(DoWildEncounter)
            end
        end
        task.wait(2)
    end
end
local function refreshEncounterThread()
    Thread("AutoEncounter", Func_AutoEncounter, anyEncounterActive())
end
Toggles.AutoSummonBoss:OnChanged(function()
    refreshEncounterThread()
end)
Toggles.AutoNpcEncounter:OnChanged(function()
    refreshEncounterThread()
end)
Toggles.AutoWildEncounter:OnChanged(function()
    refreshEncounterThread()
end)
Tables.BallItems = {
    { name = "Common Ball",    itemId = 2000015 },
    { name = "Advanced Ball",  itemId = 2000016 },
    { name = "King Ball",      itemId = 2000017 },
    { name = "Prismatic Ball", itemId = 2000018 },
}
Tables.BallNames = {}
Tables.BallLookup = {}
for _, b in ipairs(Tables.BallItems) do
    table.insert(Tables.BallNames, b.name)
    Tables.BallLookup[b.name] = b.itemId
end
local PotionItems = {
    { name = "Small HP Potion",  itemId = 2000001, healAmount = 80  },
    { name = "Medium HP Potion", itemId = 2000002, healAmount = 200 },
    { name = "Large HP Potion",  itemId = 2000003, healAmount = 500 },
}
local function PickSkill(selfPet, enemyPet, battleData)
    if not selfPet or not (typeof(selfPet.skills) == "table") then return nil end
    local enemyElement = nil
    if enemyPet then
        if typeof(enemyPet.elements) == "table" and enemyPet.elements[1] then
            enemyElement = enemyPet.elements[1]
        elseif typeof(enemyPet.enemyPetConfigId) == "number" then
            local enemyCfg = Modules.ConfigDataManager.getConfig(Modules.ConfigConst.ConfigName.PET, enemyPet.enemyPetConfigId)
            if enemyCfg then enemyElement = enemyCfg.element end
        end
    end
    local trainer = battleData and Modules.BattleDataGetModule.getLocalPlayerTrainer(battleData)
    local currentEnergy = (trainer and typeof(trainer.energy) == "number") and trainer.energy or 0
    local ult = selfPet.skills[4]
    if typeof(ult) == "table" and typeof(ult.id) == "number" and ult.lock ~= true then
        local ultCfg = Modules.ConfigDataManager.getConfig(Modules.ConfigConst.ConfigName.SKILL, ult.id)
        if ultCfg then
            local effectiveCost = (ult.cost ~= nil) and ult.cost or (ultCfg.energyCost or 0)
            if currentEnergy >= effectiveCost then
                return { id = ult.id, skillType = 2, energyCost = effectiveCost, targetType = ultCfg.targetType }
            end
        end
    end
    local bestSkill = nil
    local bestScore = -1
    for i = 1, 3 do
        local skill = selfPet.skills[i]
        if not (typeof(skill) == "table" and typeof(skill.id) == "number") then continue end
        if (typeof(skill.pp) == "number") and skill.pp <= 0 then continue end
        local cfg = Modules.ConfigDataManager.getConfig(Modules.ConfigConst.ConfigName.SKILL, skill.id)
        if not cfg then continue end
        local power = cfg.power or 0
        if power <= 0 then continue end
        local score = power
        local elemBonus = false
        if enemyElement and typeof(cfg.element) == "number" then
            local elemEntry = Tables.ElementCounterMap[enemyElement]
            if elemEntry and typeof(elemEntry.beRestrainted) == "table" then
                for _, restrainer in ipairs(elemEntry.beRestrainted) do
                    if restrainer == cfg.element then
                        score = score * 2.0
                        elemBonus = true
                        break
                    end
                end
            end
        end
        local targetType = cfg.targetType or 5
        if targetType ~= 1 and targetType ~= 5 then score = score * 1.05 end
        if score > bestScore then
            bestScore = score
            bestSkill = { id = skill.id, skillType = 1 }
        end
    end
    return bestSkill
end
local function DoAutoFight()
    local battleData = Modules.BattleService.getCurrentBattle()
    if not battleData then return end
    local switchPos = Modules.BattleDataGetModule.getLocalForceSwitchSlotPos(battleData)
    if switchPos then
        local tc = Modules.BattleDataGetModule.getLocalPlayerTrainerAndCamp(battleData)
        local selfCamp = tc and tc.selfCamp
        local slot = (selfCamp and typeof(selfCamp.slots) == "table")
            and (selfCamp.slots[switchPos] or selfCamp.slots[tostring(switchPos)])
            or nil
        local nextUid = nil
        if typeof(slot) == "table" and typeof(slot.form) == "table" then
            for _, pet in ipairs(slot.form) do
                if Modules.BattleDataGetModule.isAliveBattlePet(pet) then
                    nextUid = pet.uid
                    break
                end
            end
        end
        if nextUid then
            notyuri("[AutoFight] Active pet dead (force-switch slot), switching to:", nextUid)
            pcall(function()
                Remotes.ReqOperateBattle:InvokeServer({
                    actionType = 3,
                    sourcePos  = switchPos,
                    targetPos  = switchPos,
                    targetUid  = nextUid,
                })
            end)
        end
        return
    end
    local petsData = Modules.BattleDataGetModule.getActivePetsData(battleData)
    local selfPet  = petsData and petsData.selfPets and petsData.selfPets[1]
    local enemyPet = petsData and petsData.enemyPets and petsData.enemyPets[1]
    if not selfPet then return end
    local myCampId    = Modules.BattleDataGetModule.getLocalPlayerCampId(battleData)
    if not myCampId then return end
    local enemyCampId = (myCampId == 1) and 2 or 1
    local sourceUid   = selfPet.uid
    if not (typeof(sourceUid) == "string" and sourceUid ~= "") then return end
    local selfPetDead = (selfPet.currHp or selfPet.currentHp or 0) <= 0
        or (selfPet.aliveState == 2 or selfPet.aliveState == 3)
    if selfPetDead then
        local tc = Modules.BattleDataGetModule.getLocalPlayerTrainerAndCamp(battleData)
        local trainer, selfCamp = tc and tc.trainer, tc and tc.selfCamp
        if trainer and selfCamp and typeof(selfCamp.slots) == "table" then
            local nextUid = nil
            for _, pos in ipairs(trainer.posList or {}) do
                local slot = selfCamp.slots[pos] or selfCamp.slots[tostring(pos)]
                if typeof(slot) == "table" and typeof(slot.form) == "table" then
                    for _, pet in ipairs(slot.form) do
                        if Modules.BattleDataGetModule.isAliveBattlePet(pet) then
                            nextUid = pet.uid
                            break
                        end
                    end
                end
                if nextUid then break end
            end
            if nextUid then
                notyuri("[AutoFight] Active pet dead, switching to:", nextUid)
                pcall(function()
                    Remotes.ReqOperateBattle:InvokeServer({
                        actionType = 3,
                        sourcePos  = 1,
                        targetPos  = 1,
                        targetUid  = nextUid,
                    })
                end)
            end
        end
        return
    end
    if Toggles.AutoHeal.Value then
        local currentHp = selfPet.currHp or selfPet.currentHp or 0
        local maxHp     = selfPet.maxHp or 0
        if maxHp > 0 then
            local hpPct     = (currentHp / maxHp) * 100
            local threshold = Options.HealThreshold.Value
            if hpPct <= threshold then
                local missingHp = maxHp - currentHp
                local bagData   = Modules.BagStorage:getBagData()
                local chosen = nil
                for _, potion in ipairs(PotionItems) do
                    local _, count = Modules.ItemComm.getItemCount(bagData, potion.itemId)
                    if typeof(count) == "number" and count > 0 then
                        chosen = potion
                        if potion.healAmount >= missingHp then
                            break  
                        end
                    end
                end
                if chosen then
                    pcall(function()
                        Remotes.ReqOperateBattle:InvokeServer({
                            actionType = 4,
                            sourcePos  = 1,
                            targetUid  = selfPet.uid,
                            targetPos  = 1,
                            itemId     = chosen.itemId,
                        })
                    end)
                    return
                end
            end
        end
    end
    local skill = PickSkill(selfPet, enemyPet, battleData)
    if not skill then
        for i = 1, 3 do
            local s = selfPet.skills and selfPet.skills[i]
            if s and typeof(s.id) == "number" and (not s.pp or s.pp > 0) then
                skill = { id = s.id, skillType = 1 }
                break
            end
        end
    end
    if not skill then return end
    pcall(function()
        local payload = {
            skillType  = skill.skillType,
            sourcePos  = 1,
            sourceUid  = sourceUid,
            actionType = 1,
            skillId    = skill.id,
        }
        if skill.skillType == 1 then
            payload.targetPos    = 1
            payload.targetCampId = enemyCampId
        else
            payload.ultimateEnergyCost = skill.energyCost
            local tt = skill.targetType
            if tt == 1 or tt == 5 or tt == nil then
                payload.targetPos    = 1
                payload.targetCampId = enemyCampId
            end
        end
        Remotes.ReqOperateBattle:InvokeServer(payload)
    end)
end
local function Func_AutoFight()
    while Toggles.AutoFight.Value do
        pcall(DoAutoFight)
        task.wait(.1)
    end
end
local function IsShinyEncounter(catchInfo)
    if not (catchInfo and typeof(catchInfo.configId) == "number") then return false end
    local cfg = Modules.ConfigDataManager.getConfig(Modules.ConfigConst.ConfigName.PET, catchInfo.configId)
    return cfg ~= nil and cfg.shinyTypeId == 2
end
local function IsPrismaticEncounter(catchInfo)
    if not (catchInfo and typeof(catchInfo.colorId) == "number") then return false end
    return catchInfo.colorId > 0
        and typeof(catchInfo.patternId) == "number"
        and catchInfo.patternId > 0
end
local function DoAutoCatch()
    local selectedBall = Options.BallSelected.Value
    local itemId = Tables.BallLookup[selectedBall]
    if not itemId then return end
    local battleData = Modules.BattleService.getCurrentBattle()
    if not battleData then return end
    local skipTypes  = Options.CatchSkipTypes.Value
    local catchInfo  = Shared.currentCatchPetInfo
    if catchInfo and (skipTypes["Shiny"] or skipTypes["Prismatic"]) then
        local isShiny     = IsShinyEncounter(catchInfo)
        local isPrismatic = IsPrismaticEncounter(catchInfo)
        if (isShiny and skipTypes["Shiny"]) or (isPrismatic and skipTypes["Prismatic"]) then
            local label = isShiny and "Shiny" or "Prismatic"
            notyuri("[AutoCatch] Skipping", label, "encounter — giving up catch")
            pcall(function()
                Remotes.ReqOperateBattle:InvokeServer({ actionType = 8 })
            end)
            return
        end
    end
    pcall(function()
        Remotes.ReqOperateBattle:InvokeServer({
            sourcePos  = 1,
            targetPos  = 1,
            actionType = 5,
            itemId     = itemId,
        })
    end)
end
local function Func_AutoCatch()
    while Toggles.AutoCatch.Value do
        local CatchFolder = GetObject(workspace, "RuntimeCache.RuntimeCacheClient.CatchBallPreparedFolder")
        if CatchFolder and #CatchFolder:GetChildren() > 0 then
            pcall(DoAutoCatch)
        end
        task.wait()
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoFight", {
    Text = "Auto Fight",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("BallSelected", {
    Text = "Select Pokeball",
    Values = Tables.BallNames,
    Default = Tables.BallNames[1],
    Searchable = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoCatch", {
    Text = "Auto Catch",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("CatchSkipTypes", {
    Text    = "Shiny/Prismatic Protection",
    Values  = { "Shiny", "Prismatic" },
    Default = {},
    Multi   = true,
})
Toggles.AutoFight:OnChanged(function(state)
    Thread("AutoFight", Func_AutoFight, state)
end)
Toggles.AutoCatch:OnChanged(function(state)
    Thread("AutoCatch", Func_AutoCatch, state)
    if Connections.CatchPetInfoHook then
        Connections.CatchPetInfoHook:Disconnect()
        Connections.CatchPetInfoHook = nil
    end
    if state and Remotes.ResBroadcastBattleAction then
        Connections.CatchPetInfoHook = Remotes.ResBroadcastBattleAction.OnClientEvent:Connect(function(payload)
            local ok, decoded = pcall(function()
                return Modules.MessagePackUtil.decode(payload)
            end)
            if not ok or not decoded then return end
            local ok2, catchInfo = pcall(function()
                return Modules.BattleDataGetModule.getLocalPlayerCatchPetInfo(decoded)
            end)
            if ok2 and typeof(catchInfo) == "tabl.e" then
                Shared.currentCatchPetInfo = catchInfo
            end
        end)
    else
        Shared.currentCatchPetInfo = nil
    end
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoHeal", {
    Text    = "Auto Heal",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddSlider("HealThreshold", {
    Text     = "Heal below HP(%)",
    Default  = 30,
    Min      = 1,
    Max      = 99,
    Rounding = 0,
    Compact  = true,
})
Toggles.AutoHeal:OnChanged(function(_)
end)
local function DoAutoRelease()
    local petList = Modules.PetStorage.getPetList()
    if not petList then return end
    local protect   = Options.ReleaseProtect.Value
    local mainUid   = Modules.PetStorage.getMainPet()
    local followUid = Modules.PetStorage.getFollowPet()
    local rideUid   = Modules.PetStorage.getRidePet()
    local protected = {
        [mainUid   or ""] = true,
        [followUid or ""] = true,
        [rideUid   or ""] = true,
    }
    local inGroup = {}
    local petGroup = Modules.PetGroupStorage and Modules.PetGroupStorage.getPetGroup()
    if petGroup and typeof(petGroup.petGroupList) == "table" then
        for _, group in pairs(petGroup.petGroupList) do
            if typeof(group.petUuids) == "table" then
                for _, gUid in ipairs(group.petUuids) do
                    inGroup[gUid] = true
                end
            end
        end
    end
    local toRelease = {}
    for uid, petData in pairs(petList) do
        if protected[uid] then continue end
        if petData.locked then continue end
        if inGroup[uid] then continue end
        local cfg = Modules.ConfigDataManager.getConfig(Modules.ConfigConst.ConfigName.PET, petData.configId)
        if not cfg or cfg.isCanRelease ~= true then continue end
        local isShiny     = typeof(petData.shinyTypeId) == "number" and petData.shinyTypeId == 2
        local isPrismatic = petData.colorful ~= nil
        if isShiny and protect["Shiny"] then continue end
        if isPrismatic and protect["Prismatic"] then continue end
        table.insert(toRelease, uid)
        if #toRelease >= 20 then break end
    end
    if #toRelease == 0 then return end
    notyuri("[AutoRelease] Releasing", #toRelease, "pets")
    local ok, result = pcall(function()
        return Remotes.ReqRemovePets:InvokeServer(toRelease)
    end)
    if not ok then
        notyuri("[AutoRelease] Remote error:", result)
    elseif result ~= nil then
        notyuri("[AutoRelease] Server returned:", result)
    end
end
local function Func_AutoRelease()
    while Toggles.AutoRelease.Value do
        pcall(DoAutoRelease)
        task.wait(1)
    end
end
TB_Tabs.Autofarm2.T1:AddDropdown("ReleaseProtect", {
    Text    = "Exclude Release",
    Values  = { "Shiny", "Prismatic" },
    Default = { "Shiny", "Prismatic" },
    Multi   = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRelease", {
    Text    = "Auto Release",
    Default = false,
})
Toggles.AutoRelease:OnChanged(function(state)
    Thread("AutoRelease", Func_AutoRelease, state)
end)
local function DoAutoEgg()
    local HES = Modules.HatchEggService
    local EC  = Modules.ErrorCode
    if not HES or not EC then return end
    local ok, errCode, windowData = pcall(function()
        return HES.getWindowData()
    end)
    if not ok or errCode ~= EC.SUCCEEDED or not windowData then return end
    local bestBallId = nil
    for _, ball in ipairs(windowData.ballList or {}) do
        if ball.isInfinite and ball.ballId then
            bestBallId = ball.ballId
            break
        end
    end
    if not bestBallId then
        for _, ball in ipairs(windowData.ballList or {}) do
            if (ball.num or 0) > 0 and ball.ballId then
                bestBallId = ball.ballId
                break
            end
        end
    end
    local didHatch = false
    for _, slot in ipairs(windowData.slotList or {}) do
        if slot.state == 2 and bestBallId then
            pcall(function() HES.reqHatchEgg(slot.slotIndex, bestBallId) end)
            task.wait(0.5)
            didHatch = true
        end
    end
    if didHatch then
        local ok2, ec2, wd2 = pcall(function() return HES.getWindowData() end)
        if ok2 and ec2 == EC.SUCCEEDED and wd2 then windowData = wd2 end
    end
    local eggQueue = {}
    for _, egg in ipairs(windowData.bagEggList or {}) do
        for _ = 1, math.max(0, math.floor(egg.num or 0)) do
            table.insert(eggQueue, egg.itemUid)
        end
    end
    local nextEgg = 1
    for _, slot in ipairs(windowData.slotList or {}) do
        if slot.state == 0 then
            if eggQueue[nextEgg] then
                pcall(function() HES.reqPlaceEgg(slot.slotIndex, eggQueue[nextEgg]) end)
                nextEgg = nextEgg + 1
                task.wait(0.5)
            end
        end
    end
end
local function Func_AutoEgg()
    while Toggles.AutoEgg.Value do
        pcall(DoAutoEgg)
        task.wait(1)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoEgg", {
    Text    = "Auto Egg",
    Default = false,
})
Toggles.AutoEgg:OnChanged(function(state)
    Thread("AutoEgg", Func_AutoEgg, state)
end)
local function DoAutoReceiveTask()
    local taskList = Modules.TaskStorage:getTaskList()
    if not taskList then return end
    for taskId, entry in pairs(taskList) do
        if entry.status == 1 then  
            notyuri("[AutoReceiveTask] Receiving task", taskId)
            pcall(function()
                Remotes.ReqReceiveTask:InvokeServer(taskId)
            end)
            task.wait(0.3)
        end
    end
end
local function DoAutoCompleteTask()
    local taskList = Modules.TaskStorage:getTaskList()
    if not taskList then return end
    local goalData = Modules.GoalStorage and Modules.GoalStorage:getGoalModuleData()
    if not goalData then return end
    for taskId, entry in pairs(taskList) do
        if entry.status == 2 and Modules.TaskComm.checkAllGoalsCompleted(entry, goalData) then
            notyuri("[AutoTask] Claiming task", taskId)
            pcall(function()
                Remotes.ReqCompleteTask:InvokeServer(taskId)
            end)
            task.wait(0.3)
        end
    end
end
local function Func_AutoTask()
    while Toggles.AutoTask.Value do
        pcall(DoAutoReceiveTask)
        pcall(DoAutoCompleteTask)
        task.wait(1)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoTask", {
    Text    = "Auto Task",
    Default = false,
})
Toggles.AutoTask:OnChanged(function(state)
    Thread("AutoTask", Func_AutoTask, state)
end)
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
    Cleanup(Connections)
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
local CDM = Modules.ConfigDataManager
local CC  = Modules.ConfigConst
local worldValues, worldMap   = {}, {}
local islandValues, islandMap = {}, {}
local selectedWorldEntry, selectedIslandEntry = nil, nil
if CDM and CC then
    local ok, worlds = pcall(function() return CDM.getTable(CC.ConfigName.WORLD) end)
    if ok and worlds then
        for _, v in pairs(worlds) do
            if v.worldName then
                worldValues[#worldValues + 1] = v.worldName
                worldMap[v.worldName] = v
            end
        end
        table.sort(worldValues)
    end
    local ok2, islands = pcall(function() return CDM.getTable(CC.ConfigName.ISLAND) end)
    if ok2 and islands then
        local nameCounts = {}
        for _, v in pairs(islands) do
            if v.displayName then
                nameCounts[v.displayName] = (nameCounts[v.displayName] or 0) + 1
            end
        end
        for _, v in pairs(islands) do
            if v.displayName and v.id then
                local label = nameCounts[v.displayName] > 1 and (v.displayName .. " (" .. v.id .. ")") or v.displayName
                islandValues[#islandValues + 1] = label
                islandMap[label] = v
            end
        end
        table.sort(islandValues)
    end
end
selectedWorldEntry  = worldMap[worldValues[1]]
selectedIslandEntry = islandMap[islandValues[1]]
GB.Player.Left.General:AddDropdown("WorldPicker", {
    Text      = "Select World",
    Values    = worldValues,
    Default   = worldValues[1],
})
Options.WorldPicker:OnChanged(function()
    selectedWorldEntry = worldMap[Options.WorldPicker.Value]
end)
GB.Player.Left.General:AddButton({
    Text = "Teleport to World",
    Func = function()
        if not selectedWorldEntry or not Modules.MWService then
            notyuri("[WorldTravel] No world selected or MWService unavailable")
            return
        end
        local sceneId = Modules.MWService.getWorldIdByWorldIndex(selectedWorldEntry.id)
        notyuri("[WorldTravel] Teleporting to world:", selectedWorldEntry.worldName, "sceneId:", sceneId)
        pcall(function() Modules.MWService.applyUnlockScene(sceneId) end)
        task.wait(0.5)
        Modules.MWService.applyTeleport(sceneId)
    end,
})
local dungeonValues, dungeonIdMap = {}, {}
local selectedDungeonId = nil
if CDM and CC then
    local ok, dungeons = pcall(function() return CDM.getTable(CC.ConfigName.DUNGEON) end)
    if ok and dungeons then
        for _, entry in pairs(dungeons) do
            if entry and entry.id then
                local label = entry.name or ("Dungeon " .. entry.id)
                dungeonValues[#dungeonValues + 1] = label
                dungeonIdMap[label] = entry.id
            end
        end
        table.sort(dungeonValues)
    end
end
selectedDungeonId = dungeonIdMap[dungeonValues[1]]
TB_Tabs.Autofarm.T2:AddDropdown("DungeonPicker", {
    Text       = "Select Dungeon",
    Values     = dungeonValues,
    Default    = dungeonValues[1],
    Searchable = true,
})
Options.DungeonPicker:OnChanged(function()
    selectedDungeonId = dungeonIdMap[Options.DungeonPicker.Value]
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoDungeon",   { Text = "Auto Dungeon",          Default = false })
TB_Tabs.Autofarm.T2:AddToggle("DungeonReplay", { Text = "Auto Replay",   Default = false })
TB_Tabs.Autofarm.T2:AddToggle("UseMystic",    { Text = "Use Mystic Allies",     Default = false })
local DungeonRemote = RS.Remote.Dungeon
local function Func_AutoDungeon()
    while Toggles.AutoDungeon.Value do
        if not selectedDungeonId then
            task.wait(1)
        else
            notyuri("[Dungeon] Entering dungeon id:", selectedDungeonId)
            if Toggles.UseMystic.Value then
                local dungeonCfg = CDM and CC and (function()
                    local ok, cfg = pcall(function() return CDM.getConfig(CC.ConfigName.DUNGEON, selectedDungeonId) end)
                    return ok and cfg or nil
                end)()
                local dungeonType = dungeonCfg and dungeonCfg.type or 5
                local occOk, occResult = pcall(function()
                    return DungeonRemote.ReqApplyOccpPart:InvokeServer(1, dungeonType)
                end)
                notyuri("[Dungeon] ReqApplyOccpPart:", tostring(occOk), tostring(occResult))
                task.wait(0.3)
                local cbOk, cbResult = pcall(function()
                    return DungeonRemote.ReqApplyCreateDungeonTeam:InvokeServer({
                        maxNumber    = 4,
                        isFillBot    = true,
                        dungeonType  = dungeonType,
                        dungeonId    = selectedDungeonId,
                        isFriendOnly = false,
                        partId       = 1,
                    })
                end)
                notyuri("[Dungeon] ReqApplyCreateDungeonTeam:", tostring(cbOk), tostring(cbResult))
                task.wait(0.3)
                local enterOk, enterResult = pcall(function()
                    return DungeonRemote.ReqEnterDungeon:InvokeServer(selectedDungeonId, nil)
                end)
                notyuri("[Dungeon] ReqEnterDungeon:", tostring(enterOk), tostring(enterResult))
            else
                if Modules.DungeonService then
                    pcall(function() Modules.DungeonService.applyEnterDungeon(selectedDungeonId, nil) end)
                else
                    pcall(function() DungeonRemote.ReqEnterDungeon:InvokeServer(selectedDungeonId, nil) end)
                end
            end
            local exited = false
            Connections.Dungeon.VoteData = DungeonRemote.ResDungeonVoteData.OnClientEvent:Connect(function(votePayload)
                if not Toggles.DungeonReplay.Value then return end
                notyuri("[Dungeon] Vote received, auto-replying AGREE")
                if Modules.DungeonResultService then
                    pcall(function()
                        Modules.DungeonResultService.reqVoteDungeon(true, false, votePayload and votePayload.endTime or 0)
                    end)
                elseif Modules.DungeonSceneStorage then
                    local voteData = Modules.DungeonSceneStorage.getDungeonVoteData()
                    if voteData then
                        local agreeVal = Modules.DungeonConst and Modules.DungeonConst.DUNGEON_VOTE_RESULT and Modules.DungeonConst.DUNGEON_VOTE_RESULT.AGREE or 1
                        pcall(function()
                            DungeonRemote.ReqVoteDungeon:InvokeServer({
                                uid        = voteData.uid,
                                voteResult = agreeVal,
                                isAuto     = false,
                                endTime    = voteData.endTime or 0,
                            })
                        end)
                    end
                end
            end)
            Connections.Dungeon.Exit = DungeonRemote.ResExitDungeon.OnClientEvent:Connect(function()
                notyuri("[Dungeon] Dungeon exited")
                exited = true
            end)
            repeat task.wait(0.5) until exited or not Toggles.AutoDungeon.Value
            if Connections.Dungeon.Exit then
                Connections.Dungeon.Exit:Disconnect()
                Connections.Dungeon.Exit = nil
            end
            if Connections.Dungeon.VoteData then
                Connections.Dungeon.VoteData:Disconnect()
                Connections.Dungeon.VoteData = nil
            end
        end
        task.wait(1)
    end
end
Toggles.AutoDungeon:OnChanged(function(state)
    Thread("Dungeon.AutoDungeon", Func_AutoDungeon, state)
    if not state then
        if Connections.Dungeon.Exit then
            Connections.Dungeon.Exit:Disconnect()
            Connections.Dungeon.Exit = nil
        end
        if Connections.Dungeon.VoteData then
            Connections.Dungeon.VoteData:Disconnect()
            Connections.Dungeon.VoteData = nil
        end
    end
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoHardBuff", { Text = "Auto Hard Dungeon Buffs", Default = false })
Connections.Dungeon.HardBuff = DungeonRemote.ResHardDungeonBuffSelect.OnClientEvent:Connect(function(cardListTable)
    if not Toggles.AutoHardBuff.Value then return end
    local chosen = cardListTable and cardListTable.cardList and cardListTable.cardList[1]
    if chosen then
        notyuri("[Dungeon] Hard buff: selecting card index:", chosen.index)
        DungeonRemote.ReqHardDungeonSelectBuff:InvokeServer(chosen.index)
    end
end)
Connections.Dungeon.HardEnter = DungeonRemote.ResAllMemberSelectBuffFinish.OnClientEvent:Connect(function()
    if not Toggles.AutoHardBuff.Value then return end
    task.wait(0.5)
    notyuri("[Dungeon] All members picked buff, entering battle room")
    DungeonRemote.ReqHardDungeonApplyEnterBattle:InvokeServer()
end)
TB_Tabs.Autofarm.T2:AddSlider("TowerStartLayer", {
    Text     = "Start Layer",
    Default  = 1,
    Min      = 1,
    Max      = 200,
    Rounding = 0,
})
TB_Tabs.Autofarm.T2:AddSlider("MaxFloor", {
    Text     = "Max Floor",
    Default  = 100,
    Min      = 1,
    Max      = 200,
    Rounding = 0,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoTower", { Text = "Auto Tower", Default = false })
local function Func_AutoTower()
    local maxPassedFloor = 0
    if Modules.DataStatisticsService and Modules.DataStatisticsConst then
        local ok, val = pcall(function()
            return Modules.DataStatisticsService.getStatisticsValue(Plr, Modules.DataStatisticsConst.StatisticsType.TOWER_MAX_FLOOR)
        end)
        if ok and type(val) == "number" then
            maxPassedFloor = val
        end
    end
    local startLayer = Options.TowerStartLayer.Value
    if startLayer <= 1 then
        startLayer = math.max(1, maxPassedFloor + 1)
    end
    startLayer = math.min(startLayer, Options.MaxFloor.Value)
    notyuri("[Tower] Starting from layer:", startLayer, "| maxPassedFloor:", maxPassedFloor)
    if Modules.TowerDungeonService then
        pcall(function() Modules.TowerDungeonService.startTowerDungeonFlow(startLayer) end)
    end
    task.wait(2)
    pcall(function() DungeonRemote.ReqEnterTowerDungeonBattle:InvokeServer() end)
    notyuri("[Tower] Entered first battle on layer:", startLayer)
    Connections.Tower.BattleResult = DungeonRemote.ResTowerDungeonBattleResult.OnClientEvent:Connect(function(dungeonId, isWin)
        if not Toggles.AutoTower.Value then return end
        if isWin then
            task.wait(1)
            local curLayer = 0
            if Modules.TowerDungeonService then
                local ok, state = pcall(function() return Modules.TowerDungeonService.getCurrentRuntimeState() end)
                if ok and state then curLayer = state.currentLayer or 0 end
            end
            notyuri("[Tower] Won floor:", curLayer)
            if curLayer >= Options.MaxFloor.Value then
                Toggles.AutoTower:SetValue(false)
                Library:Notify("Tower: reached max floor " .. curLayer, 5)
                return
            end
            pcall(function() DungeonRemote.ReqEnterTowerDungeonBattle:InvokeServer() end)
        else
            notyuri("[Tower] Lost on current floor, stopping")
            Toggles.AutoTower:SetValue(false)
        end
    end)
    Connections.Tower.NewLevel = DungeonRemote.ResPlayerEnterNewTowerLevel.OnClientEvent:Connect(function(layer)
        notyuri("[Tower] Entered floor:", layer)
    end)
    while Toggles.AutoTower.Value do
        task.wait(1)
    end
    Cleanup(Connections.Tower)
end
Toggles.AutoTower:OnChanged(function(state)
    Thread("Tower.AutoTower", Func_AutoTower, state)
    if not state then
        Cleanup(Connections.Tower)
    end
end)
TB_Tabs.Autofarm2.T1:AddDropdown("ShopItemsToBuy", {
    Text       = "Items to Buy",
    Values     = ShopItemValues,
    Default    = {},
    Multi      = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShop", {
    Text    = "Auto Buy",
    Default = false,
})
local function DoAutoBuyShop()
    local selected = Options.ShopItemsToBuy.Value
    for label, _ in pairs(selected) do
        local id = ShopItemIdByLabel[label]
        if id then
            local ok, result = pcall(function()
                return Remotes.ReqApplyPurchaseGoods:InvokeServer(id, 1)
            end)
            notyuri("[AutoBuyShop]", label, ok and tostring(result) or "error")
            task.wait(0.3)
        end
    end
end
local function Func_AutoBuyShop()
    while Toggles.AutoBuyShop.Value do
        pcall(DoAutoBuyShop)
        task.wait(5)
    end
end
Toggles.AutoBuyShop:OnChanged(function(state)
    Thread("AutoBuyShop", Func_AutoBuyShop, state)
end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/Evomon")
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
end
