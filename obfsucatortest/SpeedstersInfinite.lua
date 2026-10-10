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
local RemotesFolder = RS:FindFirstChild("Remotes") or RS:WaitForChild("Remotes", 15)
local _remoteCache = {}
local function GetRemote(name)
    if _remoteCache[name] ~= nil then return _remoteCache[name] end
    local r = RemotesFolder and (RemotesFolder:FindFirstChild(name) or RemotesFolder:WaitForChild(name, 5))
    _remoteCache[name] = r
    return r
end
local function FireRemote(name, ...)
    local r = GetRemote(name)
    if not r then return false end
    local args = {...}
    return pcall(function() r:FireServer(unpack(args)) end)
end
local function InvokeRemote(name, ...)
    local r = GetRemote(name)
    if not r then return nil end
    local args = {...}
    local ok, res = pcall(function() return r:InvokeServer(unpack(args)) end)
    if ok then return res end
    return nil
end
local function GetRebirths()
    local ls = Plr:FindFirstChild("leaderstats")
    if not ls then return 0 end
    local r = ls:FindFirstChild("Rebirths")
    return r and (tonumber(r.Value) or 0) or 0
end
local function GetMaxSpeed()
    return tonumber(Plr:GetAttribute("MaxSpeed")) or 0
end
local function GetHRP()
    local c = Plr.Character
    return c and c:FindFirstChild("HumanoidRootPart") or nil
end
local function TeleportTo(cframe)
    local hrp = GetHRP()
    if hrp and cframe then
        pcall(function() hrp.CFrame = cframe end)
    end
end
local function FindGiantSpeedOrb()
    local orb = workspace:FindFirstChild("GiantSpeedOrb")
    if orb and orb:IsA("BasePart") then return orb end
    return nil
end
local function FindMissionsNpc()
    return workspace:FindFirstChild("MissionsNpc")
end
local function FindMissionVisuals()
    return workspace:FindFirstChild("LocalMissionVisuals_" .. Plr.UserId)
end
local _SharedConfig = RS:WaitForChild("Shared", 10) and RS.Shared:WaitForChild("Config", 10)
local _RebirthConfig = _SharedConfig and (pcall(require, _SharedConfig:WaitForChild("RebirthConfig", 5)) and require(_SharedConfig:FindFirstChild("RebirthConfig")) or nil) or nil
local _CharactersData = _SharedConfig and (pcall(require, _SharedConfig:WaitForChild("CharactersData", 5)) and require(_SharedConfig:FindFirstChild("CharactersData")) or nil) or nil
local _TrailsConfig = _SharedConfig and (pcall(require, _SharedConfig:WaitForChild("TrailsConfig", 5)) and require(_SharedConfig:FindFirstChild("TrailsConfig")) or nil) or nil
notyuri("[Init] RebirthConfig loaded:", tostring(_RebirthConfig ~= nil), "CharactersData loaded:", tostring(_CharactersData ~= nil), "TrailsConfig loaded:", tostring(_TrailsConfig ~= nil))
local function DecodeOwnedCharacters()
    local raw = Plr:GetAttribute("OwnedCharacters")
    if typeof(raw) ~= "string" or raw == "" then return {} end
    local ok, result = pcall(function() return HttpService:JSONDecode(raw) end)
    return (ok and type(result) == "table") and result or {}
end
local function GetBestFreeGainByRebirths(rebirths)
    if not _CharactersData then return 0 end
    local best = 0
    for _, id in ipairs(_CharactersData.Order) do
        local c = _CharactersData.List[id]
        if c and c.Unlock and c.Unlock.Type == "Rebirth" and (c.Unlock.Rebirths or 0) <= rebirths then
            best = math.max(best, c.GainPerSec or 0)
        end
    end
    return best
end
local function CanRebirth()
    if not _RebirthConfig then return true end 
    local rebirths = tonumber(Plr:GetAttribute("Rebirths")) or 0
    local maxSpeed = tonumber(Plr:GetAttribute("MaxSpeed")) or _RebirthConfig.START_MAX
    local cost = _RebirthConfig.GetRebirthCostMaxSpeed(rebirths, GetBestFreeGainByRebirths(rebirths))
    return cost <= maxSpeed
end
local function FindMissionPoints()
    local folder = FindMissionVisuals()
    if not folder then return {} end
    local list = {}
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("BasePart") and child.Name:match("^MissionPoint_") then
            table.insert(list, child)
        end
    end
    return list
end
local function Func_AutoSpeedOrb()
    while Toggles.AutoSpeedOrb.Value do
        local orb = FindGiantSpeedOrb()
        if orb then
            local hrp = GetHRP()
            if hrp and orb then
                if firetouchinterest then
                    pcall(function()
                        firetouchinterest(hrp, orb, 0)
                        task.wait()
                        firetouchinterest(hrp, orb, 1)
                    end)
                end
            end
            task.wait(0.5)
        else
            task.wait(1)
        end
    end
end
local _OwnedTrails = {}   
local _EquippedTrailId = 0
local _TitleOwnedList = {} 
local _EquippedTitleId = 0
local _TitleData = {
    { id = 20, name = "Absolute Speed",       price = 450000, requiredRebirths = 100, speedMultiplier = 2.6  },
    { id = 19, name = "Eternal Unstoppable",  price = 340000, requiredRebirths = 92,  speedMultiplier = 2.5  },
    { id = 18, name = "Cosmic Dominator",     price = 260000, requiredRebirths = 85,  speedMultiplier = 2.4  },
    { id = 17, name = "Sprint King",          price = 195000, requiredRebirths = 80,  speedMultiplier = 2.3  },
    { id = 16, name = "Solar Shadow",         price = 145000, requiredRebirths = 75,  speedMultiplier = 2.2  },
    { id = 15, name = "Shooting Star",        price = 105000, requiredRebirths = 70,  speedMultiplier = 2.1  },
    { id = 14, name = "Kinetic Fury",         price = 76000,  requiredRebirths = 65,  speedMultiplier = 2.0  },
    { id = 13, name = "Crono Runner",         price = 52000,  requiredRebirths = 60,  speedMultiplier = 1.9  },
    { id = 12, name = "Infinite",             price = 35000,  requiredRebirths = 55,  speedMultiplier = 1.8  },
    { id = 11, name = "Speed God",            price = 20000,  requiredRebirths = 50,  speedMultiplier = 1.7  },
    { id = 10, name = "Legend",               price = 12000,  requiredRebirths = 45,  speedMultiplier = 1.6  },
    { id = 9,  name = "Hyperspeed",           price = 8000,   requiredRebirths = 40,  speedMultiplier = 1.5  },
    { id = 8,  name = "Meteoro",              price = 5500,   requiredRebirths = 35,  speedMultiplier = 1.4  },
    { id = 7,  name = "Supersonic",           price = 3500,   requiredRebirths = 30,  speedMultiplier = 1.35 },
    { id = 6,  name = "Lightning",            price = 2000,   requiredRebirths = 25,  speedMultiplier = 1.3  },
    { id = 5,  name = "Turbo",                price = 1200,   requiredRebirths = 20,  speedMultiplier = 1.25 },
    { id = 4,  name = "Speedster",            price = 700,    requiredRebirths = 15,  speedMultiplier = 1.2  },
    { id = 3,  name = "Fast",                 price = 350,    requiredRebirths = 10,  speedMultiplier = 1.15 },
    { id = 2,  name = "Swift",                price = 150,    requiredRebirths = 5,   speedMultiplier = 1.1  },
    { id = 1,  name = "Rookie",               price = 50,     requiredRebirths = 0,   speedMultiplier = 1.05 },
}
local function _TitleIsOwned(id)
    for _, v in ipairs(_TitleOwnedList) do
        if v == id then return true end
    end
    return false
end
local _TrailSyncConn = nil
local function ConnectTrailSync()
    if _TrailSyncConn then return end
    local remote = GetRemote("Trail_Sync")
    if not remote then
        warn("[AutoTrail] Trail_Sync remote not found")
        return
    end
    _TrailSyncConn = remote.OnClientEvent:Connect(function(ownedList, equippedId)
        _OwnedTrails = {}
        if typeof(ownedList) == "table" then
            for _, v in ipairs(ownedList) do
                _OwnedTrails[tonumber(v) or 0] = true
            end
        end
        _EquippedTrailId = math.floor(tonumber(equippedId) or 0)
        notyuri("[AutoTrail] Sync: owned count =", #ownedList or 0, "equipped =", _EquippedTrailId)
    end)
    notyuri("[AutoTrail] Listening to Trail_Sync")
end
local _TitleSyncConn = nil
local function ConnectTitleSync()
    if _TitleSyncConn then return end
    local remote = GetRemote("Title_Sync")
    if not remote then
        warn("[AutoTitle] Title_Sync remote not found")
        return
    end
    _TitleSyncConn = remote.OnClientEvent:Connect(function(ownedList, equippedId)
        _TitleOwnedList = ownedList or {}
        _EquippedTitleId = tonumber(equippedId) or 0
        notyuri("[AutoTitle] Sync: owned count =", #_TitleOwnedList, "equipped =", _EquippedTitleId)
    end)
    notyuri("[AutoTitle] Listening to Title_Sync")
end
local function Func_AutoTrail()
    ConnectTrailSync()
    while Toggles.AutoTrail.Value do
        if not _TrailsConfig then
            notyuri("[AutoTrail] TrailsConfig not loaded, waiting")
            task.wait(5)
        else
            local gems = tonumber(Plr:GetAttribute("Gems")) or 0
            for _, id in ipairs(_TrailsConfig.Order) do
                if not Toggles.AutoTrail.Value then break end
                local cfg = _TrailsConfig.Get(id)
                if cfg and not _OwnedTrails[id] and gems >= cfg.Price then
                    notyuri("[AutoTrail] Buying trail", id, cfg.Name, "for", cfg.Price, "gems")
                    FireRemote("Trail_Buy", id)
                    task.wait(0.5)
                    gems = tonumber(Plr:GetAttribute("Gems")) or 0
                end
            end
            local bestId = nil
            local bestMult = -1
            for _, id in ipairs(_TrailsConfig.Order) do
                if _OwnedTrails[id] then
                    local cfg = _TrailsConfig.Get(id)
                    local mult = tonumber(cfg and cfg.SpeedMultiplier) or 0
                    if mult > bestMult then
                        bestMult = mult
                        bestId = id
                    end
                end
            end
            if bestId and bestId ~= _EquippedTrailId then
                notyuri("[AutoTrail] Equipping best trail:", bestId, "x"..bestMult)
                FireRemote("Trail_Equip", bestId)
            end
        end
        task.wait(5)
    end
end
local function Func_AutoTitle()
    ConnectTitleSync()
    while Toggles.AutoTitle.Value do
        local gems = tonumber(Plr:GetAttribute("Gems")) or 0
        local rebirths = tonumber(Plr:GetAttribute("Rebirths")) or 0
        for i = #_TitleData, 1, -1 do
            if not Toggles.AutoTitle.Value then break end
            local td = _TitleData[i]
            if not _TitleIsOwned(td.id) and rebirths >= td.requiredRebirths and gems >= td.price then
                notyuri("[AutoTitle] Buying title", td.id, td.name, "cost", td.price, "gems, req rebirths", td.requiredRebirths)
                FireRemote("Title_Buy", td.id)
                task.wait(0.5)
                gems = tonumber(Plr:GetAttribute("Gems")) or 0
            end
        end
        local bestId = nil
        for _, td in ipairs(_TitleData) do
            if _TitleIsOwned(td.id) then
                bestId = td.id
                break
            end
        end
        if bestId and bestId ~= _EquippedTitleId then
            notyuri("[AutoTitle] Equipping best title:", bestId)
            FireRemote("Title_Equip", bestId)
        end
        task.wait(5)
    end
end
local function Func_AutoCharacter()
    while Toggles.AutoCharacter.Value do
        if not _CharactersData then
            task.wait(5)
        else
            local rebirths = tonumber(Plr:GetAttribute("Rebirths")) or 0
            local owned = DecodeOwnedCharacters()
            for _, id in ipairs(_CharactersData.Order) do
                if not Toggles.AutoCharacter.Value then break end
                local c = _CharactersData.List[id]
                if c and c.Unlock and c.Unlock.Type == "Rebirth" then
                    local required = tonumber(c.Unlock.Rebirths) or 0
                    if rebirths >= required and not owned[id] then
                        notyuri("[AutoCharacter] Unlocking", id, "(requires", required, "rebirths)")
                        local res = InvokeRemote("RequestUnlockCharacter", id)
                        if type(res) == "table" and res.ok then
                            owned[id] = true
                            notyuri("[AutoCharacter] Unlocked", id)
                        end
                        task.wait(0.5)
                    end
                end
            end
            local bestId = nil
            local bestGain = -1
            for _, id in ipairs(_CharactersData.Order) do
                local c = _CharactersData.List[id]
                if c and owned[id] == true then
                    local gain = tonumber(c.GainPerSec) or 0
                    if gain > bestGain then
                        bestGain = gain
                        bestId = id
                    end
                end
            end
            local equipped = Plr:GetAttribute("EquippedCharacterId") or "PLAYER_SKIN"
            if bestId and bestId ~= equipped then
                notyuri("[AutoCharacter] Equipping best:", bestId, "gain:", bestGain)
                InvokeRemote("RequestEquipCharacter", bestId)
            end
        end
        task.wait(5)
    end
end
local QuestState = {
    Status = "Idle",
    CanClaim = false,
    CurrentPoint = nil,
    CurrentIndex = 0,
    Total = 0,
    Cooldowns = { Easy = 0, Normal = 0, Hard = 0 },
}
local QuestStateConn = nil
local function ConnectQuest()
    if QuestStateConn then return end
    local updateRemote = GetRemote("Mission_Update")
    if not updateRemote then
        warn("[AutoQuest] Mission_Update remote not found")
        return
    end
    QuestStateConn = updateRemote.OnClientEvent:Connect(function(data)
        if type(data) == "table" and type(data.State) == "table" then
            local s = data.State
            QuestState.Status      = s.Status or "Idle"
            QuestState.CanClaim    = s.CanClaim or false
            QuestState.CurrentPoint= typeof(s.CurrentPoint) == "Vector3" and s.CurrentPoint or nil
            QuestState.CurrentIndex= s.CurrentIndex or 0
            QuestState.Total       = s.Total or 0
            if type(s.Cooldowns) == "table" then
                QuestState.Cooldowns = s.Cooldowns
            end
            notyuri("[AutoQuest] State update:", QuestState.Status, "CanClaim:", tostring(QuestState.CanClaim), "CD E/N/H:", tostring(QuestState.Cooldowns.Easy), tostring(QuestState.Cooldowns.Normal), tostring(QuestState.Cooldowns.Hard))
        end
    end)
    notyuri("[AutoQuest] Listening to Mission_Update")
end
local function Func_AutoQuest()
    ConnectQuest()
    while Toggles.AutoQuest.Value do
        local status   = QuestState.Status
        local canClaim = QuestState.CanClaim
        local difficulty = (Options.QuestDifficulty and Options.QuestDifficulty.Value) or "Easy"
        if canClaim or status == "ReturnToNpc" then
            local npc = FindMissionsNpc()
            if npc then
                local npcPart = npc:IsA("Model") and npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart")
                if npcPart then
                    TeleportTo(npcPart.CFrame + Vector3.new(0, 3, 0))
                    task.wait(0.1)
                end
            end
            notyuri("[AutoQuest] Claiming quest")
            InvokeRemote("Mission_Claim")
            task.wait()
        elseif status == "Active" then
            local pt = QuestState.CurrentPoint
            if pt then
                TeleportTo(CFrame.new(pt + Vector3.new(0, 3, 0)))
                notyuri("[AutoQuest] TP to point", QuestState.CurrentIndex, "/", QuestState.Total, tostring(pt))
            else
                local points = FindMissionPoints()
                local idx = QuestState.CurrentIndex
                local target = (idx > 0 and points[idx]) or points[1]
                if target then
                    TeleportTo(target.CFrame + Vector3.new(0, 3, 0))
                    notyuri("[AutoQuest] TP to visual MissionPoint", idx)
                end
            end
            task.wait()
        elseif status == "Idle" then
            local npc = FindMissionsNpc()
            if npc then
                local npcPart = npc:IsA("Model") and npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart")
                if npcPart then
                    TeleportTo(npcPart.CFrame + Vector3.new(0, 3, 0))
                    task.wait(0.2)
                end
            end
            local diffOrder
            if difficulty == "Hard" then
                diffOrder = { "Hard", "Normal", "Easy" }
            elseif difficulty == "Normal" then
                diffOrder = { "Normal", "Easy" }
            else
                diffOrder = { "Easy" }
            end
            local chosen = diffOrder[1]
            for _, d in ipairs(diffOrder) do
                local cd = math.max(0, math.ceil(tonumber(QuestState.Cooldowns[d]) or 0))
                if cd <= 0 then
                    chosen = d
                    break
                end
                notyuri("[AutoQuest]", d, "on cooldown:", cd, "s, trying next")
            end
            notyuri("[AutoQuest] Starting quest:", chosen, "(preferred:", difficulty .. ")")
            InvokeRemote("Mission_Start", chosen)
            task.wait(.1)
        else
            task.wait(.1)
        end
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        if CanRebirth() then
            notyuri("[AutoRebirth] Requirement met, rebirthing")
            InvokeRemote("RequestRebirth")
        else
            notyuri("[AutoRebirth] Not ready, waiting")
        end
        task.wait(1)
    end
end
local function Func_AutoMegaRebirth()
    while Toggles.AutoMegaRebirth.Value do
        local state = InvokeRemote("MegaRebirth_GetState")
        if type(state) == "table" and state.CanMegaRebirth == true then
            notyuri("[AutoMegaRebirth] Requirement met, teleporting to MegaRebirthNpc")
            local npc = workspace:FindFirstChild("MegaRebirthNpc")
            if npc then
                local npcPart = npc:IsA("Model") and (npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart) or (npc:IsA("BasePart") and npc or nil)
                if npcPart then
                    TeleportTo(npcPart.CFrame + Vector3.new(0, 3, 0))
                    task.wait(0.2)
                end
            else
                warn("[AutoMegaRebirth] MegaRebirthNpc not found in workspace")
            end
            notyuri("[AutoMegaRebirth] Invoking MegaRebirth_Request")
            InvokeRemote("MegaRebirth_Request")
        else
            notyuri("[AutoMegaRebirth] Not ready, waiting")
        end
        task.wait(1)
    end
end
local function Func_AutoClaimTasks()
    while Toggles.AutoClaimTasks.Value do
        for id = 1, 10 do
            if not Toggles.AutoClaimTasks.Value then break end
            local res = InvokeRemote("RequestClaimTask", id)
            task.wait(0.3)
        end
        task.wait(30)
    end
end
local function Func_AutoClaimDaily()
    while Toggles.AutoClaimDaily.Value do
        for day = 1, 7 do
            if not Toggles.AutoClaimDaily.Value then break end
            InvokeRemote("DailyLoginRewards_Claim", day)
            task.wait(0.3)
        end
        task.wait(300)
    end
end
local function Func_AutoClaimRewards()
    while Toggles.AutoClaimRewards.Value do
        for i = 1, 10 do
            if not Toggles.AutoClaimRewards.Value then break end
            InvokeRemote("RequestClaimReward", i)
            task.wait(0.3)
        end
        task.wait(60)
    end
end
local function Func_AutoClaimGroupVIP()
    while Toggles.AutoClaimGroupVIP.Value do
        FireRemote("GroupReward_Claim")
        task.wait(0.5)
        FireRemote("VIPReward_Claim")
        task.wait(0.5)
        InvokeRemote("EscapeReward_Claim")
        task.wait(120)
    end
end
local _RaceConn = nil
local _RaceIsParticipant = false
local function FindRaceWinPart()
    for _, child in ipairs(workspace:GetChildren()) do
        local misc = child:FindFirstChild("Misc")
        if misc then
            local wp = misc:FindFirstChild("WinPart")
            if wp and wp:IsA("BasePart") then
                return wp
            end
        end
    end
    return nil
end
local function Func_AutoRace()
    if _RaceConn then _RaceConn:Disconnect() _RaceConn = nil end
    local raceRemote = GetRemote("Race_Update")
    if not raceRemote then
        warn("[AutoRace] Race_Update remote not found")
        return
    end
    _RaceConn = raceRemote.OnClientEvent:Connect(function(data)
        if not Toggles.AutoRace.Value then return end
        if type(data) ~= "table" then return end
        local phase = data.phase or "Intermission"
        _RaceIsParticipant = data.isParticipant == true
        notyuri("[AutoRace] Phase:", phase, "isParticipant:", tostring(_RaceIsParticipant))
        if phase == "Invite" and not data.joined and not data.declined then
            notyuri("[AutoRace] Joining race")
            FireRemote("Race_JoinRequest")
        elseif phase == "Running" and _RaceIsParticipant then
            local hrp = GetHRP()
            local wp = FindRaceWinPart()
            if hrp and wp then
                if firetouchinterest then
                    notyuri("[AutoRace] Firing WinPart TouchInterest:", wp:GetFullName())
                    pcall(firetouchinterest, hrp, wp, 0)
                    task.wait()
                    pcall(firetouchinterest, hrp, wp, 1)
                else
                    warn("[AutoRace] firetouchinterest not available")
                end
            else
                warn("[AutoRace] WinPart or HRP not found")
            end
        end
    end)
    notyuri("[AutoRace] Listening to Race_Update")
    while Toggles.AutoRace.Value do
        task.wait(1)
    end
    if _RaceConn then _RaceConn:Disconnect() _RaceConn = nil end
    notyuri("[AutoRace] Stopped")
end
local function DoRedeemCode()
    local code = (Options.CodeInput and Options.CodeInput.Value) or ""
    code = code:gsub("%s+", "")
    if code == "" then
        Library:Notify("Enter a code first.", 3)
        return
    end
    local res = InvokeRemote("Codes_Claim", code)
    if type(res) == "table" and res.ok then
        Library:Notify("Code redeemed: " .. code, 4)
    else
        Library:Notify("Redeem result: " .. tostring(res), 4)
    end
end
local function DoQuickReset()
    FireRemote("RequestQuickReset")
    Library:Notify("Quick reset sent.", 3)
end
local function DoToggleAutoRebirth()
    local current = Plr:GetAttribute("AutoRebirthEnabled") == true
    local res = InvokeRemote("SetAutoRebirth", not current)
    if type(res) == "table" and res.ok then
        Library:Notify("Auto-rebirth toggled.", 3)
    else
        Library:Notify("Auto-rebirth requires gamepass.", 4)
    end
end
local function DoActivateBoost()
    FireRemote("Boost_Activate")
    Library:Notify("Speed boost activated.", 3)
end
local function DoJoinRace()
    FireRemote("Race_JoinRequest")
    Library:Notify("Joined race.", 3)
end
local function DoTeleportToOrb()
    local orb = FindGiantSpeedOrb()
    if orb then
        TeleportTo(orb.CFrame + Vector3.new(0, 3, 0))
        Library:Notify("Teleported to Giant Speed Orb.", 3)
    else
        Library:Notify("No Giant Speed Orb found.", 3)
    end
end
local function DoTeleportToNpc()
    local npc = FindMissionsNpc()
    if npc then
        local part = npc:IsA("Model") and npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart")
        if part then
            TeleportTo(part.CFrame + Vector3.new(0, 3, 0))
            Library:Notify("Teleported to Missions NPC.", 3)
        end
    else
        Library:Notify("No Missions NPC found.", 3)
    end
end
local function DoClaimAll()
    for i = 1, 10 do
        InvokeRemote("RequestClaimReward", i)
        task.wait(0.2)
    end
    for id = 1, 10 do
        InvokeRemote("RequestClaimTask", id)
        task.wait(0.2)
    end
    for day = 1, 7 do
        InvokeRemote("DailyLoginRewards_Claim", day)
        task.wait(0.2)
    end
    FireRemote("GroupReward_Claim")
    task.wait(0.3)
    FireRemote("VIPReward_Claim")
    task.wait(0.3)
    InvokeRemote("EscapeReward_Claim")
    Library:Notify("Claimed all rewards.", 4)
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
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 500 })
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
TB_Tabs.Autofarm.T1:AddToggle("AutoSpeedOrb", { Text = "Auto Speed Orb", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMegaRebirth", { Text = "Auto Mega Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRace", { Text = "Auto Race", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoQuest", { Text = "Auto Quest", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCharacter", { Text = "Auto Character", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTrail", { Text = "Auto Trail", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTitle", { Text = "Auto Title", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("QuestDifficulty", {
    Text = "Quest Difficulty",
    Values = { "Easy", "Normal", "Hard" },
    Default = "Easy",
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
Toggles.AutoSpeedOrb:OnChanged(function(v) Thread("AutoSpeedOrb", SafeLoop("AutoSpeedOrb", Func_AutoSpeedOrb), v) end)
Toggles.AutoQuest:OnChanged(function(v) Thread("AutoQuest", SafeLoop("AutoQuest", Func_AutoQuest), v) end)
Toggles.AutoCharacter:OnChanged(function(v) Thread("AutoCharacter", SafeLoop("AutoCharacter", Func_AutoCharacter), v) end)
Toggles.AutoTrail:OnChanged(function(v) Thread("AutoTrail", SafeLoop("AutoTrail", Func_AutoTrail), v) end)
Toggles.AutoTitle:OnChanged(function(v) Thread("AutoTitle", SafeLoop("AutoTitle", Func_AutoTitle), v) end)
Toggles.AutoRebirth:OnChanged(function(v) Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v) end)
Toggles.AutoMegaRebirth:OnChanged(function(v) Thread("AutoMegaRebirth", SafeLoop("AutoMegaRebirth", Func_AutoMegaRebirth), v) end)
Toggles.AutoRace:OnChanged(function(v) Thread("AutoRace", SafeLoop("AutoRace", Func_AutoRace), v) end)
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
SaveManager:SetFolder("Yuri/SpeedstersInfinite")
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
