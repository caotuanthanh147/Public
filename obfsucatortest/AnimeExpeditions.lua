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
do
    local ScriptContext = cloneref(game:GetService("ScriptContext"))
    if getconnections then
        for _, conn in ipairs(getconnections(ScriptContext.Error)) do
            pcall(function() conn:Disconnect() end)
        end
        ScriptContext.Error:Connect(function(msg, trace, script)
            if script == nil or script.Parent == nil then
                return 
            end
        end)
    end
end
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
local Lighting = game:GetService("Lighting")
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
    local Cur = parent
    for _, name in ipairs(pathString:split(".")) do
        if not Cur then return nil end
        Cur = Cur:FindFirstChild(name)
    end
    return Cur
end
local function GetSafeModule(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
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
local Nodes = require(RS:WaitForChild("Nodes"))
local ReplicaWrite = RS:WaitForChild("RemoteEvents"):WaitForChild("ReplicaSignal")
local ReplicaClientLib = require(RS:WaitForChild("Shared"):WaitForChild("ReplicaClient"))
local ItemUtils = require(RS:WaitForChild("Shared"):WaitForChild("ItemUtils"))
local FusionPackage = RS:WaitForChild("FusionPackage")
local Fusion = require(FusionPackage:WaitForChild("Fusion"))
local FusionState = require(FusionPackage.State)
local QueueDataProcessor = require(FusionPackage.Components.Processors.QueueData)
local UnitUtils    = require(RS:WaitForChild("Shared"):WaitForChild("UnitUtils"))
local UnitReplicas = require(RS:WaitForChild("Shared"):WaitForChild("UnitReplicas"))
local Information  = require(RS:WaitForChild("Shared"):WaitForChild("Information"))
local Shared = {}
local function WaveChanged(lastWave)
    local gr = Nodes.GET_GAME_REPLICA:InvokeSelf()
    local currentWave = gr and (gr.Data.Wave or 0) or 0
    return currentWave < lastWave, currentWave
end
local function WaitReset(lastWave, shouldContinue, label)
    while shouldContinue() do
        task.wait(0.2)
        local decreased, newWave = WaveChanged(lastWave)
        if decreased then
            notyuri(label, "Wave reset (" .. lastWave .. " -> " .. newWave .. ") — restarting macro")
            return true
        end
        lastWave = newWave
    end
    return false
end
local MDir = "Yuri/AnimeExpeditions/Macros"
local MState = {
    Rec            = false,
    Rep            = false,
    Cur            = nil,
    Load           = nil,
    Step           = 0,
    Total          = 0,
    LabelRef       = nil,
    PendingLabel   = nil,
    Hooked         = false,
    CurWave        = 0,
    WaveStartClock = 0,
    UpgradeBatch   = {},
}
local Flags       = {}
local Connections = {
    Player_General = nil,
    Knockback      = {},
    Reconnect      = nil,
    GameFinished = nil
}
local GameFinished = false
local LastFinished = false
local MCENTERS = {
    ["SchoolGrounds"]           = Vector3.new(3078, 1800, 3338),
    ["FlowerForest"]            = Vector3.new(3026, 1910, 2958),  
    ["Dressrosa"]               = Vector3.new(3819, 1779, 2410),  
    ["FairyKingForest"]         = Vector3.new(2765, 1772, 3056),  
    ["KingsTomb"]               = Vector3.new(3010, 1971, 2923),  
    ["SchoolGroundsExpedition"] = Vector3.new(0, 0, 0),  
    ["FlowerForestExpedition"]  = Vector3.new(0, 0, 0),  
    ["DressrosaExpedition"]     = Vector3.new(0, 0, 0),  
    ["SpiritCity"]              = Vector3.new(0, 0, 0),  
    ["VillainInvasion"]         = Vector3.new(0, 0, 0),  
    ["CreatorSpotlight"]        = Vector3.new(0, 0, 0),  
}
local JoinerConfigs = {
    { Name = "Story",      Toggle = "AutoJoinStory",      MM = "SJMatchmaking", Priority = "SJPriority", Build = StoryQueue },
    { Name = "Raid",       Toggle = "AutoJoinRaid",       MM = "RJMatchmaking", Priority = "RJPriority", Build = RaidQueue },
    { Name = "Expedition", Toggle = "AutoJoinExpedition", MM = "EJMatchmaking", Priority = "EJPriority", Build = ExpdQueue },
    { Name = "Challenge",  Toggle = "AutoJoinChallenge",  MM = "CJMatchmaking", Priority = "CJPriority", Build = ChallQueue },
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
}
local SlotPositions   = {}
local MapLabelRef = nil
local PosLabelRef  = nil
local FailedPositions = {}  
local SpanCursor = {}
local SpanCache = {}
local PCubePool = {
    Free = {},
    Active = {},
}
local function PCubeAcq()
    local part = table.remove(PCubePool.Free)
    if not part then
        part = Instance.new("Part")
        part.Name         = "PCube"
        part.Size         = Vector3.new(0.5, 0.5, 0.5)
        part.Anchored     = true
        part.CanCollide   = false
        part.CastShadow   = false
        part.Material     = Enum.Material.Neon
    end
    part.Transparency = 0.55
    part.Color        = Color3.fromRGB(80, 160, 255)
    part.Parent        = workspace
    PCubePool.Active[part] = true
    return part
end
local function PCubeRelease(part)
    if not part or not PCubePool.Active[part] then return end
    PCubePool.Active[part] = nil
    part.Parent = nil
    table.insert(PCubePool.Free, part)
end
local function PCubeReleaseAll()
    for part in pairs(PCubePool.Active) do
        PCubePool.Active[part] = nil
        part.Parent = nil
        table.insert(PCubePool.Free, part)
    end
end
local function ArrToCFrame(arr)
    if type(arr) ~= "table" or #arr < 12 then return CFrame.new() end
    return CFrame.new(
        arr[1], arr[2], arr[3],
        arr[4], arr[5], arr[6],
        arr[7], arr[8], arr[9],
        arr[10], arr[11], arr[12]
    )
end
local function GetTimeString()
    return MState.CurWave .. " " .. (os.clock() - MState.WaveStartClock)
end
local function CFToPos(cf)
    local x,y,z,r00,r01,r02,r10,r11,r12,r20,r21,r22 = cf:GetComponents()
    return string.format(
        "%.9g, %.9g, %.9g, %g, %g, %g, %g, %g, %g, %g, %g, %g",
        x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22
    )
end
local function GetUnitPos(model)
    local name = model.Name
    local unitsFolder = workspace:FindFirstChild("Units")
    if not unitsFolder then return name .. " - 1" end
    local idx = 0
    for _, child in ipairs(unitsFolder:GetChildren()) do
        if child.Name == name then
            idx = idx + 1
            if child == model then
                return name .. " - " .. idx
            end
        end
    end
    return name .. " - 1"
end
local function UpdateLabel(suffix)
    if MState.LabelRef and MState.LabelRef.SetText then
        local txt
        if MState.Rec then
            if suffix then
                txt = string.format("Recording [%d] %s", MState.Step, suffix)
            else
                txt = string.format("Recording [%d]", MState.Step)
            end
        elseif MState.Rep then
            txt = string.format("Replaying [%d / %d]", MState.Step, MState.Total)
            if suffix then txt = txt .. " | " .. suffix end
        else
            txt = "Idle"
            if suffix then txt = txt .. " | " .. suffix end
        end
        notyuri("[Macro Rec] UpdateLabel called, txt=", txt, "LabelRef exists=", MState.LabelRef ~= nil)
        local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
        if not ok then
            notyuri("[Macro Rec] SetText FAILED:", tostring(err))
            MState.PendingLabel = txt
        end
    end
end
local function LabelPump()
    while MState.Rec do
        if MState.PendingLabel then
            local txt = MState.PendingLabel
            MState.PendingLabel = nil
            local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
            if not ok then
                notyuri("[Macro Rec] LabelPump SetText FAILED:", tostring(err))
            end
        end
        task.wait(0.1)
    end
end
local function GetSlotName(slot)
    local playerReplica = Nodes.GET_PLAYER_REPLICA:InvokeSelf()
    if not playerReplica then return nil end
    local hotbar = playerReplica.Data.HotbarData
    if not hotbar then return nil end
    local unitInstanceId = hotbar[tostring(slot)]
    if not unitInstanceId then return nil end
    local unitData = playerReplica.Data.UnitData
    if not unitData then return nil end
    local entry = unitData[unitInstanceId]
    return entry and entry.Asset
end
local function CommitEntry(entry, labelSuffix)
    if not MState.Rec or not MState.Cur then return end
    MState.Step = MState.Step + 1
    MState.Cur.entries[MState.Step] = entry
    UpdateLabel(labelSuffix or entry.Type)
end
local function ParsePosToArr(posStr)
    local nums = {}
    for n in posStr:gmatch("[^,%s]+") do
        table.insert(nums, tonumber(n))
    end
    return (#nums == 12) and nums or nil
end
local function FindUnitByRef(posStr)
    local name, idxStr = posStr:match("^(.+)%s%-%s(%d+)$")
    if not name or not idxStr then return nil end
    local targetIdx = tonumber(idxStr)
    local unitsFolder = workspace:FindFirstChild("Units")
    if not unitsFolder then return nil end
    local count = 0
    for _, child in ipairs(unitsFolder:GetChildren()) do
        if child.Name == name then
            count = count + 1
            if count == targetIdx then return child end
        end
    end
    return nil
end
local function FindSlot(unitName)
    local playerReplica = Nodes.GET_PLAYER_REPLICA:InvokeSelf()
    if not playerReplica then return nil end
    local hotbar  = playerReplica.Data.HotbarData
    local unitMap = playerReplica.Data.UnitData
    if not hotbar or not unitMap then return nil end
    for slotStr, instanceId in pairs(hotbar) do
        local ud = unitMap[instanceId]
        if ud and ud.Asset == unitName then
            return tonumber(slotStr)
        end
    end
    return nil
end
local function FindUnit(targetCF)
    local unitsFolder = workspace:FindFirstChild("Units")
    if not unitsFolder then return nil end
    local bestDist, bestModel = math.huge, nil
    for _, model in ipairs(unitsFolder:GetChildren()) do
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if hrp then
            local d = (hrp.Position - targetCF.Position).Magnitude
            if d < bestDist then
                bestDist  = d
                bestModel = model
            end
        end
    end
    return bestDist < 5 and bestModel or nil
end
local function LoadMDir()
    if not writefile then return end
    pcall(function()
        if not isfolder(MDir) then
            makefolder(MDir)
        end
    end)
end
local function ListMacros()
    local names = {}
    if not listfiles then return names end
    local ok, files = pcall(listfiles, MDir)
    if not ok or type(files) ~= "table" then return names end
    for _, path in ipairs(files) do
        if type(path) == "string" and path:sub(-5):lower() == ".json" then
            local fname = path:match("([^/\\]+)%.json$")
            if fname and fname ~= "" then table.insert(names, fname) end
        end
    end
    table.sort(names)
    return names
end
local function LoadMacro(name)
    if not name or name == "" or not readfile then return nil end
    local path = MDir .. "/" .. name .. ".json"
    if not isfile(path) then return nil end
    local ok, raw = pcall(readfile, path)
    if not ok or type(raw) ~= "string" or raw == "" then return nil end
    local data
    pcall(function() data = HttpService:JSONDecode(raw) end)
    if type(data) ~= "table" then return nil end
    if type(data.actions) == "table" then
        return { v = 2, entries = data.actions }
    end
    if type(data["1"]) == "table" and type(data["1"].Type) == "string" then
        local entries = {}
        local i = 1
        while data[tostring(i)] do
            entries[i] = data[tostring(i)]
            i = i + 1
        end
        return { v = 3, entries = entries }
    end
    return nil
end
local function SaveMacro(name, macro)
    if not name or name == "" or not writefile then return false end
    LoadMDir()
    local path = MDir .. "/" .. name .. ".json"
    local out  = {}
    for i, entry in ipairs(macro.entries) do
        out[tostring(i)] = entry
    end
    local ok = pcall(function()
        writefile(path, HttpService:JSONEncode(out))
    end)
    return ok
end
local function HandlePlace(slot, cf, isPhantom)
    local unitName = GetSlotName(slot)
    local timeStr  = GetTimeString()
    task.delay(0.5, function()
        if not MState.Rec then return end
        local model = FindUnit(cf)
        if not model then
            notyuri("[Macro Rec] PlaceGameUnit GUARD FAIL: no unit appeared")
            return
        end
        local entry = {
            Type = "PlaceUnit",
            Time = timeStr,
            Unit = unitName or model.Name,
            Pos  = CFToPos(cf),
        }
        if isPhantom then entry.Phantom = true end
        CommitEntry(entry, "Place " .. (unitName or "?"))
        notyuri("[Macro Rec] PlaceUnit recorded", entry.Unit, "phantom=", tostring(isPhantom))
    end)
end
local function HandleUpg(unitId, arg5)
    local model = Nodes.GET_UNIT_MODEL_FROM_ID:InvokeSelf(unitId)
    local hrp   = model and model:FindFirstChild("HumanoidRootPart")
    if not hrp then
        notyuri("[Macro Rec] UpgradeGameUnit: no HRP for unitId=" .. unitId)
        return
    end
    local amount        = (type(arg5) == "number" and arg5 > 1) and arg5 or nil
    local beforeReplica = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
    local beforeUpgrade = beforeReplica and beforeReplica.Data and beforeReplica.Data.Upgrade
    local posStr        = GetUnitPos(model)
    local timeStr       = GetTimeString()
    task.delay(0.5, function()
        if not MState.Rec then return end
        local afterReplica  = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
        local afterUpgrade  = afterReplica and afterReplica.Data and afterReplica.Data.Upgrade
        if beforeUpgrade ~= nil and afterUpgrade ~= nil and afterUpgrade <= beforeUpgrade then
            notyuri("[Macro Rec] UpgradeUnit GUARD FAIL: level unchanged at", posStr)
            return
        end
        local entry = { Type = "UpgradeUnit", Time = timeStr, Pos = posStr }
        if amount then entry.Amount = amount end
        CommitEntry(entry, "Upgrade" .. (amount and " x" .. amount or ""))
        notyuri("[Macro Rec] UpgradeUnit recorded", posStr, amount and ("x"..amount) or "")
    end)
end
local function HandleSell(unitId)
    local model = Nodes.GET_UNIT_MODEL_FROM_ID:InvokeSelf(unitId)
    local hrp   = model and model:FindFirstChild("HumanoidRootPart")
    if not hrp then
        notyuri("[Macro Rec] SellGameUnit: no HRP for unitId=" .. unitId)
        return
    end
    local posStr  = GetUnitPos(model)
    local timeStr = GetTimeString()
    task.delay(0.5, function()
        if not MState.Rec then return end
        if model.Parent ~= nil then
            notyuri("[Macro Rec] SellUnit GUARD FAIL: model still alive at", posStr)
            return
        end
        local entry = { Type = "SellUnit", Time = timeStr, Pos = posStr }
        CommitEntry(entry, "Sell")
        notyuri("[Macro Rec] SellUnit recorded", posStr)
    end)
end
local function HandlePrior(unitId, prio)
    local model = Nodes.GET_UNIT_MODEL_FROM_ID:InvokeSelf(unitId)
    local hrp   = model and model:FindFirstChild("HumanoidRootPart")
    if not hrp then
        notyuri("[Macro Rec] ChangeGameUnitPriority: no HRP for unitId=" .. unitId)
        return
    end
    local posStr = GetUnitPos(model)
    local entry  = {
        Type = "ChangePriority",
        Time = GetTimeString(),
        Pos  = posStr,
        Prio = tostring(prio),
    }
    CommitEntry(entry, "Priority " .. tostring(prio))
    notyuri("[Macro Rec] ChangePriority", posStr, prio)
end
local function HandleAUpg(unitId)
    local model = Nodes.GET_UNIT_MODEL_FROM_ID:InvokeSelf(unitId)
    local hrp   = model and model:FindFirstChild("HumanoidRootPart")
    if not hrp then
        notyuri("[Macro Rec] ChangeGameUnitAutoUpgradePriority: no HRP for unitId=" .. unitId)
        return
    end
    local posStr = GetUnitPos(model)
    local entry  = {
        Type = "ToggleAutoUpgrade",
        Time = GetTimeString(),
        Pos  = posStr,
    }
    CommitEntry(entry, "Auto Upgrade")
    notyuri("[Macro Rec] ToggleAutoUpgrade", posStr)
end
local function StartRec()
    if MState.Hooked then return end
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local self   = ...
        local Method = getnamecallmethod()
        local ret    = table.pack(originalNamecall(...))
        if MState.Rec
            and Method == "FireServer"
            and rawequal(self, ReplicaWrite) then
            local action = select(3, ...)
            local arg4   = select(4, ...)
            local arg5   = select(5, ...)
            task.defer(function()
                if action == "PlaceGameUnit" or action == "PlaceGamePhantom" then
                    local slot    = arg4
                    local cf      = arg5
                    local phantom = (action == "PlaceGamePhantom")
                    if type(slot) ~= "number" or typeof(cf) ~= "CFrame" then return end
                    HandlePlace(slot, cf, phantom)
                elseif action == "UpgradeGameUnit" then
                    local unitId = arg4
                    if type(unitId) ~= "string" then return end
                    HandleUpg(unitId, arg5)
                elseif action == "SellGameUnit" then
                    local unitId = arg4
                    if type(unitId) ~= "string" then return end
                    HandleSell(unitId)
                elseif action == "ChangeGameUnitPriority" then
                    local unitId = arg4
                    local prio   = arg5
                    if type(unitId) ~= "string" then return end
                    HandlePrior(unitId, prio)
                elseif action == "ChangeGameUnitAutoUpgradePriority" then
                    local unitId = arg4
                    if type(unitId) ~= "string" then return end
                    HandleAUpg(unitId)
                end
            end)
        end
        return table.unpack(ret, 1, ret.n)
    end))
    MState.Hooked = true
    notyuri("[Macro] __namecall hook installed")
end
local function Func_MacRec(state)
    if state then
        if Toggles.LoadMacro and Toggles.LoadMacro.Value then
            Toggles.LoadMacro:SetValue(false)
        end
        MState.Rec            = true
        MState.Rep            = false
        MState.Step           = 0
        MState.CurWave        = 0
        MState.WaveStartClock = os.clock()
        MState.Cur = {
            name    = "Macro_" .. os.date("%Y%m%d_%H%M%S"),
            entries = {},
            v       = 3,
        }
        StartRec()
        UpdateLabel()
        task.spawn(LabelPump)
        task.spawn(function()
            while MState.Rec do
                local gr = Nodes.GET_GAME_REPLICA:InvokeSelf()
                if gr then
                    local w = gr.Data.Wave or 0
                    if w ~= MState.CurWave then
                        MState.CurWave        = w
                        MState.WaveStartClock = os.clock()
                        notyuri("[Macro Rec] Wave changed to", w)
                    end
                end
                task.wait(0.25)
            end
        end)
    else
        MState.Rec = false
        for _, batch in pairs(MState.UpgradeBatch) do
            if batch.thread then task.cancel(batch.thread) end
        end
        MState.UpgradeBatch = {}
        if MState.Cur and #MState.Cur.entries > 0 then
            local fname = (Options.FileName and Options.FileName.Value) or ""
            if fname == "" then fname = MState.Cur.name end
            fname = fname:gsub("[^A-Za-z0-9_%-]", "_")
            if SaveMacro(fname, MState.Cur) then
                Library:Notify("Saved: " .. fname .. " (" .. #MState.Cur.entries .. " steps)", 5)
            end
            if Options.MacroSelected then
                Options.MacroSelected:SetValues(ListMacros())
            end
        end
        MState.Cur  = nil
        MState.Step = 0
        UpdateLabel()
    end
end
local function Func_LoadMacro()
    while Toggles.LoadMacro.Value do
        local macro = MState.Load
        if not macro or not macro.entries or #macro.entries == 0 then
            Toggles.LoadMacro:SetValue(false)
            break
        end
        MState.Rep   = true
        MState.Total = #macro.entries
        local repWave      = 0
        local repWaveStart = os.clock()
        local Restart = false
        if macro.v == 3 then
            local gr = Nodes.GET_GAME_REPLICA:InvokeSelf()
            if gr then repWave = gr.Data.Wave or 0 end
            repWaveStart = os.clock()
        end
        if not Restart then
            for i, action in ipairs(macro.entries) do
                if not Toggles.LoadMacro.Value then break end
                MState.Step = i
                if macro.v == 3 then
                    local tWave, tElapsed
                    if type(action.Time) == "string" then
                        local wStr, eStr = action.Time:match("^(%d+)%s+(.+)$")
                        tWave    = tonumber(wStr)
                        tElapsed = tonumber(eStr)
                    end
                    local skipStep = false
                    if tWave and tElapsed then
                        if tWave > repWave then
                            while repWave < tWave and Toggles.LoadMacro.Value do
                                task.wait(.1)
                                local gr = Nodes.GET_GAME_REPLICA:InvokeSelf()
                                if gr then
                                    local w = gr.Data.Wave or 0
                                    if w < repWave then
                                        Restart = true
                                        break
                                    elseif w ~= repWave then
                                        repWave      = w
                                        repWaveStart = os.clock()
                                    end
                                end
                            end
                            if Restart then break end
                        end
                        if not Toggles.LoadMacro.Value then break end
                        local elapsed = os.clock() - repWaveStart
                        local diff    = tElapsed - elapsed
                        if diff < -5 then
                            skipStep = true
                        elseif diff > 0 then
                            task.wait(diff)
                        end
                    end
                    if not Toggles.LoadMacro.Value then break end
                    if skipStep then
                        UpdateLabel("skipped")
                    else
                        UpdateLabel(action.Type)
                        local Replica = Nodes.GET_GAME_PLAYER_REPLICA:InvokeSelf()
                        if not Replica then
                            task.wait(.5)
                        elseif action.Type == "PlaceUnit" then
                            local slot = FindSlot(action.Unit)
                            if slot then
                                local arr = ParsePosToArr(action.Pos)
                                if arr then
                                    local cf     = ArrToCFrame(arr)
                                    local remote = action.Phantom and "PlaceGamePhantom" or "PlaceGameUnit"
                                    local placed = false
                                    for retry = 1, 3 do
                                        pcall(function()
                                            Replica:FireServer(remote, slot, cf)
                                        end)
                                        task.wait(.1)
                                        if FindUnit(cf) then
                                            placed = true
                                            break
                                        end
                                    end
                                end
                            end
                        elseif action.Type == "UpgradeUnit" then
                            local model = FindUnitByRef(action.Pos)
                            if model then
                                local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                                if unitId then
                                    local upgraded = false
                                    for retry = 1, 3 do
                                        local beforeReplica = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
                                        local beforeUpgrade = beforeReplica and beforeReplica.Data and beforeReplica.Data.Upgrade
                                        pcall(function()
                                            Replica:FireServer("UpgradeGameUnit", unitId, action.Amount)
                                        end)
                                        task.wait(.1)
                                        local afterReplica = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
                                        local afterUpgrade = afterReplica and afterReplica.Data and afterReplica.Data.Upgrade
                                        if beforeUpgrade == nil or afterUpgrade == nil or afterUpgrade > beforeUpgrade then
                                            upgraded = true
                                            break
                                        end
                                    end
                                end
                            end
                        elseif action.Type == "SellUnit" then
                            local model = FindUnitByRef(action.Pos)
                            if model then
                                local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                                if unitId then
                                    local sold = false
                                    for retry = 1, 3 do
                                        pcall(function()
                                            Replica:FireServer("SellGameUnit", unitId)
                                        end)
                                        task.wait(.1)
                                        if model.Parent == nil then
                                            sold = true
                                            break
                                        end
                                    end
                                end
                            end
                        elseif action.Type == "ChangePriority" then
                            local model = FindUnitByRef(action.Pos)
                            if model then
                                local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                                if unitId then
                                    pcall(function()
                                        Replica:FireServer("ChangeGameUnitPriority", unitId, action.Prio)
                                    end)
                                end
                            end
                        elseif action.Type == "ToggleAutoUpgrade" then
                            local model = FindUnitByRef(action.Pos)
                            if model then
                                local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                                if unitId then
                                    pcall(function()
                                        Replica:FireServer("ChangeGameUnitAutoUpgradePriority", unitId)
                                    end)
                                end
                            end
                        end
                    end
                else
                    UpdateLabel(action.type)
                    if action.d and action.d > 0 then
                        task.wait(action.d)
                    end
                    if not Toggles.LoadMacro.Value then break end
                    local Replica = Nodes.GET_GAME_PLAYER_REPLICA:InvokeSelf()
                    if not Replica then
                        task.wait(.5)
                    elseif action.type == "place" then
                        local cf = ArrToCFrame(action.cf)
                        pcall(function()
                            Replica:FireServer("PlaceGameUnit", action.slot, cf)
                        end)
                    elseif action.type == "upgrade" then
                        local targetCF = ArrToCFrame(action.cf)
                        local model    = FindUnit(targetCF)
                        if model then
                            local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                            if unitId then
                                pcall(function()
                                    Replica:FireServer("UpgradeGameUnit", unitId, action.level)
                                end)
                            end
                        end
                    elseif action.type == "sell" then
                        local targetCF = ArrToCFrame(action.cf)
                        local model    = FindUnit(targetCF)
                        if model then
                            local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                            if unitId then
                                pcall(function()
                                    Replica:FireServer("SellGameUnit", unitId)
                                end)
                            end
                        end
                    elseif action.type == "priority" then
                        local targetCF = ArrToCFrame(action.cf)
                        local model    = FindUnit(targetCF)
                        if model then
                            local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                            if unitId then
                                pcall(function()
                                    Replica:FireServer("ChangeGameUnitPriority", unitId, action.prio)
                                end)
                            end
                        end
                    elseif action.type == "autoupgrade" then
                        local targetCF = ArrToCFrame(action.cf)
                        local model    = FindUnit(targetCF)
                        if model then
                            local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                            if unitId then
                                pcall(function()
                                    Replica:FireServer("ChangeGameUnitAutoUpgradePriority", unitId)
                                end)
                            end
                        end
                    end
                end
            end
            if not Restart and Toggles.LoadMacro.Value then
                UpdateLabel("Finished")
                WaitReset(repWave, function() return Toggles.LoadMacro.Value end, "")
            end
        end
        MState.Rep  = false
        MState.Step = 0
        UpdateLabel("Starting")
    end
    MState.Rep = false
    UpdateLabel()
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
function Thread(featurePath, featureFunc, isEnabled, ...)
    local pathParts    = featurePath:split(".")
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
local function SafeLoop(name, func)
    return function()
        local success, e = pcall(func)
        if not success then
            Library:Notify("Error in [" .. name .. "]: " .. tostring(e), 10)
            notyuri("Error in [" .. name .. "]: " .. tostring(e))
        end
    end
end
local function AddMultiDropdown(group, id, config)
    config = config or {}
    local labelId = config.label
    local baseValues = config.Values or {}
    local values = { "All" }
    for _, v in ipairs(baseValues) do
        table.insert(values, v)
    end
    group:AddDropdown(id, {
        Text = config.Text,
        Values = values,
        Default = config.Default or {},
        Multi = true,
        Searchable = true,
        Callback = config.Callback,
    })
    return function()
        local labels = (Options[id] and Options[id].Value) or {}
        local ids = {}
        if labels["All"] then
            for _, label in ipairs(baseValues) do
                if labelId then
                    local mappedId = labelId[label]
                    if mappedId then ids[mappedId] = true end
                else
                    ids[label] = true
                end
            end
            return ids
        end
        for label, active in pairs(labels) do
            if active and label ~= "All" then
                if labelId then
                    local mappedId = labelId[label]
                    if mappedId then ids[mappedId] = true end
                else
                    ids[label] = true
                end
            end
        end
        return ids
    end
end
function AddSliderToggle(Config)
    local Toggle = Config.Group:AddToggle(Config.Id, {
        Text    = Config.Text,
        Default = Config.DefaultToggle or false
    })
    local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
        Text     = Config.Text,
        Default  = Config.Default,
        Min      = Config.Min,
        Max      = Config.Max,
        Rounding = Config.Rounding or 0,
        Compact  = true,
        Visible  = false
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
local function TPTo(target, offset)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local cframe
    if typeof(target) == "CFrame" then
        cframe = target
    elseif typeof(target) == "Vector3" then
        cframe = CFrame.new(target)
    elseif typeof(target) == "Instance" then
        if target:IsA("BasePart") then
            cframe = target.CFrame
        elseif target:IsA("Model") then
            cframe = target:GetPivot()
        end
    end
    if not cframe then return false end
    if offset then
        cframe = cframe * CFrame.new(offset)
    end
    hrp.CFrame = cframe
    return true
end
local function FuncTPW()
    while true do
        local delta = RunService.Heartbeat:Wait()
        local char  = GetCharacter()
        local hum   = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 then
            if hum.MoveDirection.Magnitude > 0 then
                char:TranslateBy(hum.MoveDirection * Options.TPWValue.Value * delta * 10)
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
    if Plr.Character then ApplyAntiKB(Plr.Character) end
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
                        task.wait(2)
                        TeleportService:Teleport(game.PlaceId, Plr)
                    end
                end
            end)
        end)
    end)
end
local function Func_NoGameplayPaused()
    while Toggles.NoGameplayPaused.Value do
        pcall(function()
            local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            if pauseGui then pauseGui:Destroy() end
        end)
        task.wait(1)
    end
end
local function ApplyFPSBoost(state)
    if not state then return end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd        = 9e9
        Lighting.Brightness    = 1
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostProcessEffect") or v:IsA("BloomEffect")
                or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
        task.spawn(function()
            for i, v in pairs(workspace:GetDescendants()) do
                if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
                pcall(function()
                    if v:IsA("BasePart") then
                        v.Material   = Enum.Material.SmoothPlastic
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
local function FirePP(target, teleport)
    if not fireproximityprompt then return end
    if not target or not target:IsA("ProximityPrompt") then return end
    if teleport then
        local char = GetCharacter()
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        local isModel = false
        if part then
            if part:IsA("Model") then
                isModel = true
            elseif not part:IsA("BasePart") then
                part = target:FindFirstAncestorWhichIsA("BasePart")
                if not part then
                    part = target:FindFirstAncestorWhichIsA("Model")
                    if part then isModel = true end
                end
            end
        end
        if hrp and part then
            local partPos  = isModel and part:GetPivot().Position or part.Position
            local dist     = (hrp.Position - partPos).Magnitude
            local prevDist = target.MaxActivationDistance
            if dist > prevDist then
                local partCF = isModel and part:GetPivot() or part.CFrame
                hrp.CFrame   = partCF * CFrame.new(0, 3, 0)
                task.wait(0.175)
            end
        end
    end
    fireproximityprompt(target)
end
local function GetGameReplica()
    local result, done
    task.spawn(function() result = Nodes.GET_GAME_REPLICA:InvokeSelf() done = true end)
    local start = tick()
    repeat task.wait() until done or (tick() - start) > 2
    return result
end
local function GetGamePlayerReplica()
    return Nodes.GET_GAME_PLAYER_REPLICA:InvokeSelf()
end
local function StartGameFinishedWatcher()
    if Connections.GameFinished then Connections.GameFinished:Disconnect() end
    GameFinished = false
    Connections.GameFinished = Nodes.SHOW_END_SCREEN:Connect(function()
        GameFinished = true
    end)
end
local function IsGameFinished()
    return GameFinished
end
local function SendGameRequest(action, ...)
    local args = {...}
    pcall(function()
        Nodes.SEND_GAME_REQUEST:FireSelf(nil, action, unpack(args))
    end)
end
local function Func_AutoClaimQuest()
    while Toggles.AutoClaimQuest.Value do
        pcall(function() Nodes.QUEST_CLAIM_ALL:FireServer() end)
        task.wait(0.3)
        pcall(function() Nodes.QUEST_CLAIM_ALL_CATEGORIES:FireServer() end)
        task.wait(3)
    end
end
local function Func_AutoClaimBattlepass()
    while Toggles.AutoClaimBattlepass.Value do
        pcall(function() Nodes.CLAIM_ALL_BATTLEPASS_REWARDS:FireServer("free") end)
        task.wait(0.3)
        pcall(function() Nodes.CLAIM_ALL_BATTLEPASS_REWARDS:FireServer("premium") end)
        task.wait(3)
    end
end
local function Func_AutoClaimMilestone()
    while Toggles.AutoClaimMilestone.Value do
        pcall(function() Nodes.QUESTBOARD_CLAIM_ALL_MILESTONES:FireServer() end)
        task.wait(3)
    end
end
local function Func_AutoClaimIndex()
    while Toggles.AutoClaimIndex.Value do
        pcall(function() Nodes.INDEX_CLAIM_ALL:FireServer() end)
        task.wait(3)
    end
end
local function Func_AutoClaimCalendar()
    while Toggles.AutoClaimCalendar.Value do
        for day = 1, 7 do
            pcall(function() Nodes.CLAIM_CALENDAR:FireServer(day, "free") end)
            task.wait(0.2)
        end
        task.wait(3)
    end
end
local function Func_AutoClaimGroup()
    while Toggles.AutoClaimGroup.Value do
        pcall(function() Nodes.GROUP_REWARDS_CLAIM:FireServer() end)
        task.wait(3)
    end
end
local function Func_AutoVoteStart()
    pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoVoteStart", true) end)
    notyuri("[AutoVoteStart] Enabled game AutoVoteStart setting")
    while Toggles.AutoVoteStart.Value do
        task.wait(1)
    end
    pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoVoteStart", false) end)
    notyuri("[AutoVoteStart] Disabled game AutoVoteStart setting")
end
local function Func_AutoVoteSkip()
    while Toggles.AutoVoteSkip.Value do
        local stopWave = tonumber(Options.SkipStopWave.Value) or 0
        local gr = GetGameReplica()
        local wave = gr and gr.Data and (gr.Data.Wave or 0) or 0
        if stopWave == 0 or wave < stopWave then
            SendGameRequest("SkipWave")
        end
        task.wait(0.1)
    end
end
local function Func_AutoRestart()
    while Toggles.AutoRestart.Value do
        local gr = GetGameReplica()
        if gr and gr.Data then
            local finished = gr.Data.Finished == true
            if finished and not LastFinished then
                LastFinished = true
                task.wait(1)
                pcall(function()
                    local pr = GetGamePlayerReplica()
                    if pr then
                        pr:FireServer("RestartGame")
                    end
                end)
                notyuri("[AutoRestart] Stage finished, restarting")
            elseif not finished then
                LastFinished = false
            end
        end
        task.wait(.5)
    end
end
local function Func_GameplayVoteStart()
    while Toggles.GameplayVoteStart.Value do
        local gr = GetGameReplica()
        local inGame = gr and gr.Data and gr.Data.Wave and gr.Data.Wave > 0
        if not inGame then
            local pr = GetGamePlayerReplica()
            if pr then
                pcall(function() pr:FireServer("StartGame") end)
            end
        end
        task.wait(.5)
    end
end
local function Func_AutoSkipWave()
    pcall(function() Nodes.CLIENT_TOGGLE_AUTO_SKIP_WAVES:FireServer() end)
end
local function Func_AutoReplay()
    pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoRetry", true) end)
    while Toggles.AutoReplay.Value do
        task.wait(1)
    end
    pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoRetry", false) end)
end
local function Func_AutoNext()
    pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoNext", true) end)
    while Toggles.AutoNext.Value do
        task.wait(1)
    end
    pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoNext", false) end)
end
local function Func_AutoReturnLobby()
    while Toggles.AutoReturnLobby.Value do
        local gr = GetGameReplica()
        if gr and gr.Data then
            local wave = gr.Data.Wave or 0
            local finished = gr.Data.Finished == true
            if wave > 0 and not finished then
                local deadline = tick() + (tonumber(Options.AutoReturnLobbyTime.Value) or 5) * 60
                while Toggles.AutoReturnLobby.Value and tick() < deadline do
                    task.wait(1)
                    local gr2 = GetGameReplica()
                    if not gr2 or not gr2.Data or (gr2.Data.Finished == true) or (gr2.Data.Wave or 0) == 0 then
                        break
                    end
                end
                if Toggles.AutoReturnLobby.Value then
                    local gr3 = GetGameReplica()
                    if gr3 and gr3.Data and not gr3.Data.Finished and (gr3.Data.Wave or 0) > 0 then
                        local pr = GetGamePlayerReplica()
                        if pr then
                            pcall(function() pr:FireServer("Lobby") end)
                            notyuri("[AutoReturnLobby] triggered, returning to lobby")
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end
local function Func_TPLobby()
    while Toggles.TPLobby.Value do
        local gr = GetGameReplica()
        if gr and gr.Data then
            local wave = gr.Data.Wave or 0
            local finished = gr.Data.Finished == true
            if wave > 0 and not finished then
                local deadline = tick() + (tonumber(Options.TPLobbyTime.Value) or 10) * 60
                while Toggles.TPLobby.Value and tick() < deadline do
                    task.wait(1)
                    local gr2 = GetGameReplica()
                    if not gr2 or not gr2.Data or (gr2.Data.Finished == true) or (gr2.Data.Wave or 0) == 0 then
                        break
                    end
                end
                if Toggles.TPLobby.Value then
                    local gr3 = GetGameReplica()
                    if gr3 and gr3.Data and not gr3.Data.Finished and (gr3.Data.Wave or 0) > 0 then
                        notyuri("[TPLobby] triggered, teleporting to lobby")
                        pcall(function() TeleportService:Teleport(game.PlaceId, Plr) end)
                    end
                end
            end
        end
        task.wait(2)
    end
end

local PortalModifierLabelToId = {}
local PortalModifierValues = {}
do
    local modList = Information.GameModifiers.List
    for modId, modInfo in pairs(modList) do
        if not modInfo.Hidden then
            local label = modInfo.DisplayName or modId
            PortalModifierLabelToId[label] = modId
            table.insert(PortalModifierValues, label)
        end
    end
    table.sort(PortalModifierValues)
end
local GetIgnoredPortalModifiers = nil
local PortalRewardPickerConnection = nil
local function GetPortalOptionModifiers(portalData)
    local ok, mods = pcall(function()
        return Information.Portals:GetModifiersFromData(portalData)
    end)
    if ok and mods then
        return mods
    end
    return {}
end
local function PickPortalOption(portals, tierCap, ignoredModifiers)
    local bestIndex, bestTier = nil, -1
    for index, portalData in pairs(portals) do
        local tier = portalData.Tier or 0
        if tierCap <= 0 or tier <= tierCap then
            local mods = GetPortalOptionModifiers(portalData)
            local blocked = false
            for modName, ignored in pairs(ignoredModifiers) do
                if ignored and mods[modName] ~= nil then
                    blocked = true
                    break
                end
            end
            if not blocked and tier > bestTier then
                bestTier = tier
                bestIndex = index
            end
        end
    end
    return bestIndex
end
local function Func_PortalRewardPicker()
    if PortalRewardPickerConnection then
        return
    end
    PortalRewardPickerConnection = ReplicaClientLib.OnNew("PortalSelectionPrompt", function(replica)
        task.spawn(function()
            if not Toggles.AutoPickPortalReward or not Toggles.AutoPickPortalReward.Value then
                return
            end
            local params = replica.Data and replica.Data.Parameters
            local portals = params and params.Portals
            if not portals then
                return
            end
            local tierCap = (Options.PortalTierCap and Options.PortalTierCap.Value) or 5
            local ignoredModifiers = GetIgnoredPortalModifiers and GetIgnoredPortalModifiers() or {}
            local chosen = PickPortalOption(portals, tierCap, ignoredModifiers)
            if chosen then
                pcall(function()
                    replica:FireServer("Response", { chosen })
                end)
                notyuri("[PortalRewardPicker] Auto-selected portal option " .. tostring(chosen))
            else
                notyuri("[PortalRewardPicker] No eligible portal option (Tier Cap/Ignore Modifier filtered all)")
            end
        end)
    end)
end
local function Func_AutoJoinPortal()
    while Toggles.AutoJoinPortal and Toggles.AutoJoinPortal.Value do
        local playerReplica = Nodes.GET_PLAYER_REPLICA:InvokeSelf()
        local ownedPortals = playerReplica and playerReplica.Data and playerReplica.Data.PortalData
        if not ownedPortals or not next(ownedPortals) then
            notyuri("[PortalJoiner] No owned portals found")
            task.wait(3)
        else
            local tierCap = (Options.PortalTierCap and Options.PortalTierCap.Value) or 5
            local ignoredModifiers = GetIgnoredPortalModifiers and GetIgnoredPortalModifiers() or {}
            local chosenId = PickPortalOption(ownedPortals, tierCap, ignoredModifiers)
            if not chosenId then
                notyuri("[PortalJoiner] No eligible owned portal (Tier Cap/Ignore Modifier filtered all)")
                task.wait(3)
            else
                local portalData = ownedPortals[chosenId]
                local ok, queueData = pcall(function()
                    return Information.Portals:GetQueueData(chosenId, portalData, Plr.UserId)
                end)
                if not ok or not queueData then
                    notyuri("[PortalJoiner] Failed to build QueueData for portal " .. tostring(chosenId))
                    task.wait(3)
                else
                    local partyReplica = Nodes.PARTY_GET_CURRENT_REPLICA:InvokeSelf()
                    if partyReplica then
                        pcall(function()
                            partyReplica:FireServer("StartGame")
                        end)
                        notyuri("[PortalJoiner] Started game for existing party with portal " .. tostring(chosenId))
                    else
                        local request = Nodes.PARTY_CREATE:Request(queueData)
                        request:Timeout(5)
                        request:Once(function()
                            local newPartyReplica = Nodes.PARTY_WAIT_FOR_CURRENT_REPLICA:InvokeSelf()
                            pcall(function()
                                newPartyReplica:FireServer("StartGame")
                            end)
                            notyuri("[PortalJoiner] Created party and started game with portal " .. tostring(chosenId))
                        end)
                    end
                    task.wait(5)
                end
            end
        end
    end
end
local FishingMinigameConnection = nil
local function GetWaterCastPosition()
    local char = GetCharacter()
    if not char then
        return nil
    end
    local head = char:FindFirstChild("Head")
    if not head then
        return nil
    end
    local camera = workspace.CurrentCamera
    if not camera then
        return nil
    end
    local aimPoint = camera.CFrame.Position + camera.CFrame.LookVector * 50
    local result = ItemUtils:RaycastToWater(camera.CFrame.Position, aimPoint) or ItemUtils:RaycastToWater(head.Position, aimPoint)
    if result then
        return result.Position
    end
    return nil
end
local function GetNearestWaterPart()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return nil
    end
    local waterParts = Services.CollectionService:GetTagged("Water")
    local bestPart, bestDist = nil, math.huge
    for _, part in ipairs(waterParts) do
        if part:IsA("BasePart") then
            local dist = (part.Position - hrp.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestPart = part
            end
        end
    end
    return bestPart
end
local function Func_AutoFishing()
    if not FishingMinigameConnection then
        FishingMinigameConnection = Nodes.FISHING_START_MINIGAME:Connect(function(params, resultCallback)
            if Toggles.AutoFishing and Toggles.AutoFishing.Value then
                pcall(resultCallback, true)
            end
        end)
    end
    while Toggles.AutoFishing.Value do
        local stage = Nodes.CLIENT_FISHING_STATE:Get()
        local active = Nodes.FISHING_ACTIVE:Get()
        if active and (stage == "Idle" or stage == nil) then
            local nearWater = ItemUtils:IsPlayerNearWater(Plr)
            if not nearWater then
                local waterPart = GetNearestWaterPart()
                if waterPart then
                    TPTo(waterPart, Vector3.new(0, 3, 0))
                    notyuri("[AutoFishing] Teleported to water")
                    task.wait(0.2)
                    nearWater = ItemUtils:IsPlayerNearWater(Plr)
                end
            end
            if nearWater then
                task.wait(.1)
                local waterPos = GetWaterCastPosition()
                if waterPos then
                    pcall(function()
                        Nodes.FISH_CAST_REEL:FireServer(waterPos, 1)
                    end)
                    notyuri("[AutoFishing] Cast at " .. tostring(waterPos))
                end
            end
        end
        task.wait(1)
    end
    if FishingMinigameConnection then
        pcall(function() FishingMinigameConnection:Disconnect() end)
        FishingMinigameConnection = nil
    end
end
local function Func_AutoSellFarm()
    local _lastSoldFarm = false
    while Toggles.AutoSellFarm.Value do
        local gr = GetGameReplica()
        local wave = gr and gr.Data and (gr.Data.Wave or 0) or 0
        local targetWave = tonumber(Options.SellFarmWave.Value) or 0
        if targetWave > 0 and wave >= targetWave then
            if not _lastSoldFarm then
                _lastSoldFarm = true
                local pr = GetGamePlayerReplica()
                local unitsFolder = workspace:FindFirstChild("Units")
                if pr and unitsFolder then
                    local sold = 0
                    for _, model in ipairs(unitsFolder:GetChildren()) do
                        local replica = UnitReplicas[model]
                        if replica then
                            local asset = replica.Data and replica.Data.UnitData and replica.Data.UnitData.Asset
                            if asset and UnitUtils:IsUnitNameFarm(asset) then
                                local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
                                if unitId then
                                    pcall(function() pr:FireServer("SellGameUnit", unitId) end)
                                    sold = sold + 1
                                end
                            end
                        end
                    end
                    notyuri("[AutoSellFarm] Sold", sold, "farm units at wave", wave)
                end
            end
        else
            _lastSoldFarm = false
        end
        task.wait(2)
    end
end
local function Func_AutoSellUnit()
    local _lastSoldUnit = false
    while Toggles.AutoSellUnit.Value do
        local gr = GetGameReplica()
        local wave = gr and gr.Data and (gr.Data.Wave or 0) or 0
        local targetWave = tonumber(Options.SellUnitWave.Value) or 0
        if targetWave > 0 and wave >= targetWave then
            if not _lastSoldUnit then
                _lastSoldUnit = true
                local pr = GetGamePlayerReplica()
                if pr then
                    pcall(function() pr:FireServer("SellAllGameUnits") end)
                    notyuri("[AutoSellUnit] Sold all units at wave", wave)
                end
            end
        else
            _lastSoldUnit = false
        end
        task.wait(2)
    end
end
local function FailKey(cf)
    return string.format("%d,%d", math.round(cf.X), math.round(cf.Z))
end
local function GetCurrentMapName()
    local gr = GetGameReplica()
    return gr and gr.Data and gr.Data.Parameters and gr.Data.Parameters.MapName
end
local function PosText(mapName)
    if not mapName then return "Not in a game" end
    local lines = {}
    for i = 1, 6 do
        local cf = SlotPositions[mapName] and SlotPositions[mapName][i] and SlotPositions[mapName][i][1]
        if cf then
            table.insert(lines, string.format("Slot %d: %.1f, %.1f, %.1f", i, cf.X, cf.Y, cf.Z))
        else
            table.insert(lines, "Slot " .. i .. ": No Position")
        end
    end
    return table.concat(lines, "\n")
end
local function UpdatePosLabels()
    local mapName = GetCurrentMapName()
    if MapLabelRef then
        pcall(function()
            MapLabelRef:SetText("Current Map: " .. (mapName or "Not in game"))
        end)
    end
    if PosLabelRef then
        pcall(function()
            PosLabelRef:SetText(PosText(mapName))
        end)
    end
end
local function GetGround(pos)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local excluded = {}
    local unitsFolder = workspace:FindFirstChild("Units")
    if unitsFolder then table.insert(excluded, unitsFolder) end
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "PCube" then table.insert(excluded, v) end
    end
    rayParams.FilterDescendantsInstances = excluded
    local result = workspace:Raycast(pos, Vector3.new(0, -10, 0), rayParams)
    local finalY = result and result.Position.Y + 1 or (pos.Y + 1)
    notyuri("[GetGround] from=(" .. string.format("%.1f,%.1f,%.1f", pos.X, pos.Y, pos.Z) ..
        ") hit=" .. tostring(result ~= nil) ..
        (result and (" hitInstance=" .. tostring(result.Instance and result.Instance:GetFullName())) or "") ..
        " finalY=" .. string.format("%.1f", finalY))
    return finalY
end
local function HandleSlotPos(act, slot)
    local mapName = GetCurrentMapName()
    if not mapName then
        Library:Notify("Not in a game — map not detected", 3)
        return
    end
    if act == "reset" then
        if slot then
            if SlotPositions[mapName] then SlotPositions[mapName][slot] = nil end
            Library:Notify("Slot " .. slot .. " positions cleared (" .. mapName .. ")", 3)
            notyuri("[AutoPlay] ResetPos slot=" .. slot .. " map=" .. mapName)
        else
            SlotPositions[mapName] = nil
            Library:Notify("All slot positions cleared (" .. mapName .. ")", 3)
            notyuri("[AutoPlay] ResetPos all map=" .. mapName)
        end
        UpdatePosLabels()
        return
    end
    local char = GetCharacter()
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Library:Notify("Character not found", 3)
        return
    end
    local pos = hrp.Position
    local groundY = GetGround(pos)
    local cf = CFrame.new(Vector3.new(pos.X, groundY, pos.Z))
    if not SlotPositions[mapName] then SlotPositions[mapName] = {} end
    if act == "set" then
        if not SlotPositions[mapName][slot] then SlotPositions[mapName][slot] = {} end
        table.insert(SlotPositions[mapName][slot], cf)
        local count = #SlotPositions[mapName][slot]
        Library:Notify("Slot " .. slot .. " pos " .. count .. " set (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] SetPos slot=" .. slot .. " count=" .. count .. " map=" .. mapName .. " Y=" .. string.format("%.2f", cf.Y))
    elseif act == "massset" then
        for i = 1, 6 do
            if not SlotPositions[mapName][i] then SlotPositions[mapName][i] = {} end
            table.insert(SlotPositions[mapName][i], cf)
        end
        Library:Notify("All 6 slots: pos appended (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] MassSetPos map=" .. mapName .. " Y=" .. string.format("%.2f", cf.Y))
    end
    UpdatePosLabels()
end
local function SetPos(slot)
    HandleSlotPos("set", slot)
end
local function MassSetPos()
    HandleSlotPos("massset")
end
local function ResetPos(slot)
    HandleSlotPos("reset", slot)
end
local function DoSpan(cache, center, upToCount, spacing)
    cache = cache or {}
    spacing = spacing or 1.5
    if upToCount <= 0 then return cache end
    if #cache == 0 then
        cache[1] = CFrame.new(Vector3.new(center.X, GetGround(center), center.Z))
        cache.x, cache.z = 0, 0
        cache.dx, cache.dz = 1, 0
        cache.segLen  = 1
        cache.stepped = 0
        cache.turns   = 0
    end
    while #cache < upToCount do
        cache.x = cache.x + cache.dx
        cache.z = cache.z + cache.dz
        local px = center.X + cache.x * spacing
        local pz = center.Z + cache.z * spacing
        table.insert(cache, CFrame.new(
            px,
            GetGround(Vector3.new(px, center.Y, pz)),
            pz
        ))
        cache.stepped = cache.stepped + 1
        if cache.stepped == cache.segLen then
            cache.stepped = 0
            cache.dx, cache.dz = -cache.dz, cache.dx
            cache.turns = cache.turns + 1
            if cache.turns % 2 == 0 then
                cache.segLen = cache.segLen + 1
            end
        end
    end
    return cache
end
local function CountPlaced(slot)
    local unitName = GetSlotName(slot)
    if not unitName then return 0 end
    local unitsFolder = workspace:FindFirstChild("Units")
    if not unitsFolder then return 0 end
    local count = 0
    for _, model in ipairs(unitsFolder:GetChildren()) do
        if model.Name == unitName then
            local rep = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
            if rep and rep.Data and rep.Data.Owner == Plr then
                count = count + 1
            end
        end
    end
    return count
end
local function GamePlcLimit(slot)
    local unitName = GetSlotName(slot)
    if not unitName then return 0 end
    local info = UnitUtils:GetUnitInfo(unitName)
    if not info then return 1 end
    local lim = info.PlacementLimit
    if lim == nil or lim ~= lim or lim == math.huge then return 1 end
    return lim
end
local function GetPlcLimit(slot)
    local cfg = tonumber(Options["APPlaceLimit" .. slot] and Options["APPlaceLimit" .. slot].Value) or 0
    local game = GamePlcLimit(slot)
    return (cfg > 0) and math.min(cfg, game) or game
end
local function GetUpgLimit(slot)
    return tonumber(Options["APUpgradeLimit" .. slot] and Options["APUpgradeLimit" .. slot].Value) or 0
end
local function GetUnits()
    local unitsFolder = workspace:FindFirstChild("Units")
    if not unitsFolder then return {} end
    local result = {}
    for _, model in ipairs(unitsFolder:GetChildren()) do
        local rep = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
        if rep and rep.Data and rep.Data.Owner == Plr then
            local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
            if unitId then
                local slot       = FindSlot(model.Name)
                local upgrade    = rep.Data.Upgrade or 0
                local maxUpgrade = rep.Data.MaxUpgrade or 0
                local cfgCap     = slot and GetUpgLimit(slot) or 0
                local effectiveMax = (cfgCap > 0) and math.min(cfgCap, maxUpgrade) or maxUpgrade
                table.insert(result, {
                    model        = model,
                    unitId       = unitId,
                    slot         = slot,
                    upgrade      = upgrade,
                    maxUpgrade   = maxUpgrade,
                    effectiveMax = effectiveMax,
                })
            end
        end
    end
    return result
end
local function UpgradeCand(units)
    local method    = Options.APUpgradeMethod and Options.APUpgradeMethod.Value or "Lowest Level (Spread Upgrade)"
    local focusFarm = Toggles.APFocusFarm and Toggles.APFocusFarm.Value
    local upgradable = {}
    for _, e in ipairs(units) do
        if e.upgrade < e.effectiveMax then
            table.insert(upgradable, e)
        end
    end
    if #upgradable == 0 then return nil end
    if focusFarm then
        local farms = {}
        for _, e in ipairs(upgradable) do
            if UnitUtils:IsUnitNameFarm(e.model.Name) then
                table.insert(farms, e)
            end
        end
        if #farms > 0 then upgradable = farms end
    end
    if method == "Randomize" then
        return upgradable[math.random(1, #upgradable)]
    elseif method == "Lowest Level (Spread Upgrade)" then
        table.sort(upgradable, function(a, b) return a.upgrade < b.upgrade end)
        return upgradable[1]
    elseif method == "Hotbar left to right (until Max)" or method == "Customize upgrade order (Set below)" then
        table.sort(upgradable, function(a, b)
            local sa, sb = a.slot or 99, b.slot or 99
            if sa ~= sb then return sa < sb end
            return a.upgrade < b.upgrade
        end)
        return upgradable[1]
    end
    return upgradable[1]
end
local function DoUpgrade(pr)
    local units  = GetUnits()
    local target = UpgradeCand(units)
    if not target then return false end
    pcall(function()
        pr:FireServer("UpgradeGameUnit", target.unitId)
    end)
    notyuri("[AutoPlay] UpgradeGameUnit slot=" .. tostring(target.slot) .. " unit=" .. target.model.Name .. " lv=" .. target.upgrade)
    task.wait(0.1)
    return true
end
local function PlacePhase(pr, currentWave)
    local mapName = GetCurrentMapName()
    local centerRaw = mapName and MCENTERS[mapName]
    local center = centerRaw and centerRaw ~= Vector3.new(0, 0, 0) and Vector3.new(centerRaw.X, GetGround(centerRaw), centerRaw.Z) or centerRaw
    notyuri("[PlacePhase] mapName=" .. tostring(mapName) ..
        " centerRaw=" .. (centerRaw and string.format("(%.1f,%.1f,%.1f)", centerRaw.X, centerRaw.Y, centerRaw.Z) or "nil") ..
        " center=" .. (center and string.format("(%.1f,%.1f,%.1f)", center.X, center.Y, center.Z) or "nil"))
    local slotOrder = {}
    for i = 1, 6 do table.insert(slotOrder, i) end
    table.sort(slotOrder, function(a, b)
        local oa = tonumber(Options["APPlaceOrder" .. a] and Options["APPlaceOrder" .. a].Value) or a
        local ob = tonumber(Options["APPlaceOrder" .. b] and Options["APPlaceOrder" .. b].Value) or b
        return oa < ob
    end)
    local allPlaced = true
    local waitingForYen = false
    for _, slot in ipairs(slotOrder) do
        if not Toggles.AutoPlay.Value then break end
        if waitingForYen then break end
        local placeWave = tonumber(Options["APPlaceWave" .. slot] and Options["APPlaceWave" .. slot].Value) or 0
        if placeWave > 0 and currentWave < placeWave then
            allPlaced = false
        else
            local unitName = GetSlotName(slot)
            if unitName then
                local limit  = GetPlcLimit(slot)
                local placed = CountPlaced(slot)
                local need   = limit - placed
                if need > 0 then
                    allPlaced = false
                    if not FailedPositions[mapName] then FailedPositions[mapName] = {} end
                    local failed = FailedPositions[mapName]
                    local positions = {}
                    local slotCfg = mapName and SlotPositions[mapName] and SlotPositions[mapName][slot]
                    if slotCfg and #slotCfg > 0 then
                        if #slotCfg >= limit then
                            for i = 1, #slotCfg do
                                if not failed[FailKey(slotCfg[i].Position)] then
                                    table.insert(positions, slotCfg[i])
                                end
                            end
                            if #positions == 0 then
                                local centerPos = slotCfg[1].Position
                                local cursorKey = mapName .. ":" .. FailKey(centerPos)
                                if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
                                local cache = SpanCache[cursorKey]
                                local idx = SpanCursor[cursorKey] or 0
                                local collected = 0
                                while collected < need do
                                    idx = idx + 1
                                    DoSpan(cache, centerPos, idx)
                                    local cf = cache[idx]
                                    if not failed[FailKey(cf.Position)] then
                                        table.insert(positions, cf)
                                        collected = collected + 1
                                    end
                                end
                                SpanCursor[cursorKey] = idx
                            end
                        else
                            local centerPos = slotCfg[1].Position
                            local cursorKey = mapName .. ":" .. FailKey(centerPos)
                            if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
                            local cache = SpanCache[cursorKey]
                            local idx = SpanCursor[cursorKey] or 0
                            local collected = 0
                            while collected < need do
                                idx = idx + 1
                                DoSpan(cache, centerPos, idx)
                                local cf = cache[idx]
                                if not failed[FailKey(cf.Position)] then
                                    table.insert(positions, cf)
                                    collected = collected + 1
                                end
                            end
                            SpanCursor[cursorKey] = idx
                        end
                    elseif center and center ~= Vector3.new(0, 0, 0) then
                        local cursorKey = mapName .. ":center"
                        if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
                        positions.__spiral = true
                        positions.__cache = SpanCache[cursorKey]
                        positions.__center = center
                        positions.__cursorKey = cursorKey
                        positions.__need = need
                    end
                    local unitInfo = nil
                    pcall(function() unitInfo = UnitUtils:GetUnitInfo(unitName) end)
                    local placeCost = unitInfo and unitInfo.UpgradeInfo and unitInfo.UpgradeInfo[0] and unitInfo.UpgradeInfo[0].Cost or 0
                    local placedThisCall = 0
                    while true do
                        if not Toggles.AutoPlay.Value then break end
                        local cf
                        if positions.__spiral then
                            if placedThisCall >= positions.__need then break end
                            if placeCost > 0 then
                                local currentYen = pr.Data and pr.Data.Yen or 0
                                if currentYen < placeCost then
                                    waitingForYen = true
                                    break
                                end
                            end
                            local cache = positions.__cache
                            local idx = SpanCursor[positions.__cursorKey] or 0
                            local found = false
                            while not found do
                                idx = idx + 1
                                DoSpan(cache, positions.__center, idx)
                                local candidate = cache[idx]
                                if not failed[FailKey(candidate.Position)] then
                                    cf = candidate
                                    found = true
                                end
                            end
                            SpanCursor[positions.__cursorKey] = idx
                            notyuri("[PlacePhase] slot=" .. slot .. " cursorKey=" .. positions.__cursorKey ..
                                " idx=" .. idx .. " pos=" .. string.format("(%.1f,%.1f,%.1f)", cf.Position.X, cf.Position.Y, cf.Position.Z))
                            placedThisCall = placedThisCall + 1
                        else
                            placedThisCall = placedThisCall + 1
                            if placedThisCall > #positions then break end
                            cf = positions[placedThisCall]
                            if placeCost > 0 then
                                local currentYen = pr.Data and pr.Data.Yen or 0
                                if currentYen < placeCost then
                                    waitingForYen = true
                                    break
                                end
                            end
                        end
                        local ghost = PCubeAcq()
                        ghost.CFrame       = cf * CFrame.new(0, 0.5, 0)
                        local countBefore = CountPlaced(slot)
                        local ok = false
                        for retry = 1, 1 do
                            pcall(function() pr:FireServer("PlaceGameUnit", slot, cf) end)
                            task.wait(0.3)
                            if CountPlaced(slot) > countBefore then
                                ok = true
                                break
                            end
                        end
                        notyuri("[PlacePhase] PLACE slot=" .. slot .. " unit=" .. tostring(unitName) ..
                            " pos=" .. string.format("(%.1f,%.1f,%.1f)", cf.Position.X, cf.Position.Y, cf.Position.Z) ..
                            " ok=" .. tostring(ok))
                        failed[FailKey(cf.Position)] = true
                        if ok then
                            ghost.Color        = Color3.fromRGB(80, 255, 120)
                            ghost.Transparency = 0.6
                        else
                            ghost.Color        = Color3.fromRGB(255, 80, 80)
                            ghost.Transparency = 0.6
                        end
                        if not ok then
                            waitingForYen = true
                        else
                            if Toggles.APPlaceAndUpgrade and Toggles.APPlaceAndUpgrade.Value then
                                DoUpgrade(pr)
                            end
                            if CountPlaced(slot) >= limit then
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return allPlaced
end
local function Func_AutoPlay()
    local lastGameId = nil  
    while Toggles.AutoPlay.Value do
        local gr   = GetGameReplica()
        local wave = gr and gr.Data and (gr.Data.Wave or 0) or 0
        if wave > 0 then
            local gameId = gr.Data.GameTime
            if gameId ~= lastGameId then
                lastGameId = gameId
                FailedPositions = {}
                StartGameFinishedWatcher()
                notyuri("[AutoPlay] New game detected, blacklist cleared")
            end
            local pr = GetGamePlayerReplica()
            if not pr then
                notyuri("[AutoPlay] No player replica, retrying")
                task.wait(1)
            else
                notyuri("Starting, wave=" .. wave)
                local lastWave = wave
                while Toggles.AutoPlay.Value do
                    local decreased, currentWave = WaveChanged(lastWave)
                    if decreased then
                        notyuri("(" .. lastWave .. " -> " .. currentWave .. ") — game ended")
                        PCubeReleaseAll()
                        break
                    end
                    lastWave = currentWave
                    local allPlaced = PlacePhase(pr, currentWave)
                    if allPlaced and Toggles.APAutoUpgrade and Toggles.APAutoUpgrade.Value then
                        local didUpgrade = DoUpgrade(pr)
                        if not didUpgrade then
                            task.wait(1)
                        end
                    end
                    task.wait(0.1)
                end
            end
        else
            task.wait(1)
        end
    end
end
local function Func_AutoCraft()
    while Toggles.AutoCraft.Value do
        if recipe ~= "" then
            pcall(function()
                Nodes.REQUEST_CRAFT_CRAFTING_RECIPE:FireServer(recipe, 1)
            end)
        end
        task.wait(2)
    end
end
local function GetActiveBanners()
    local ok, banners = pcall(function()
        return Nodes.GET_ACTIVE_BANNERS:InvokeSelf()
    end)
    local names = {}
    if ok and type(banners) == "table" then
        for bannerId in pairs(banners) do
            table.insert(names, bannerId)
        end
        table.sort(names)
    end
    return names
end
local function GetSummonTargetList()
    local ok, list = pcall(function()
        return Information:GetCommandAssetList("Unit")
    end)
    local values = {}
    if ok and type(list) == "table" then
        for _, name in ipairs(list) do
            if name ~= "All" and name ~= "AllHidden" then
                table.insert(values, name)
            end
        end
    end
    return values
end
local SummonHookConn = nil
local SummonTargetHit = false
local SummonTargetAsset = nil
local function HookSummonRewards()
    if SummonHookConn then return end
    SummonHookConn = Nodes.PROMPT_OBTAINED_REWARDS:Connect(function(rewards)
        if not (Toggles.AutoSummon and Toggles.AutoSummon.Value) then return end
        if type(rewards) ~= "table" then return end
        local targets = Options.SummonTargets and Options.SummonTargets.Value or {}
        if next(targets) == nil then return end
        for _, entry in ipairs(rewards) do
            local asset = entry and entry.Asset
            if asset and targets[asset] then
                SummonTargetHit = true
                SummonTargetAsset = asset
                return
            end
        end
    end)
end
local function Func_AutoSummon()
    SummonTargetHit = false
    SummonTargetAsset = nil
    HookSummonRewards()
    while Toggles.AutoSummon.Value do
        if SummonTargetHit then
            break
        end
        local banner = Options.SummonBanner and Options.SummonBanner.Value
        if not banner or banner == "" then
            Library:Notify("No banner selected", 3)
            break
        end
        pcall(function()
            Nodes.BANNER_SUMMON:FireServer(banner, 10)
        end)
        notyuri("[AutoSummon] Rolled banner=" .. tostring(banner))
        task.wait(1)
        if SummonTargetHit then
            break
        end
    end
    if SummonTargetHit then
        notyuri("[AutoSummon] Target obtained: " .. tostring(SummonTargetAsset))
        Library:Notify("Target obtained: " .. tostring(SummonTargetAsset), 6)
    end
    if Toggles.AutoSummon.Value then
        task.spawn(function()
            Toggles.AutoSummon:SetValue(false)
        end)
    end
end
local function StoryQueue()
    local map = Options.SJMap and Options.SJMap.Value
    if not map or map == "" then return nil end
    return {
        Gamemode   = "Story",
        MapName    = map,
        ActName    = Options.SJAct and Options.SJAct.Value,
        Difficulty = Options.SJDifficulty and Options.SJDifficulty.Value,
    }
end
local function RaidQueue()
    local map = Options.RJMap and Options.RJMap.Value
    if not map or map == "" then return nil end
    return {
        Gamemode   = "Raid",
        MapName    = map,
        ActName    = Options.RJAct and Options.RJAct.Value,
        Difficulty = Options.RJDifficulty and Options.RJDifficulty.Value,
    }
end
local function ExpdQueue()
    local map = Options.EJMap and Options.EJMap.Value
    if not map or map == "" then return nil end
    return {
        Gamemode        = "Expedition",
        MapName         = map,
        DifficultyLevel = Options.EJDifficultyLevel and Options.EJDifficultyLevel.Value,
    }
end
local function ChallQueue()
    local ctype = Options.CJType and Options.CJType.Value
    if not ctype or ctype == "" then return nil end
    return {
        Gamemode       = "Challenge",
        ChallengeType  = ctype,
        ChallengeIndex = Options.CJIndex and Options.CJIndex.Value,
    }
end
local function DoJoin(queueData)
    local partyReplica = Nodes.GET_PARTY_DATA_REPLICA:InvokeSelf()
    if partyReplica then
        partyReplica:FireServer("StartGame")
    else
        local reqId = math.random(1, 2^31)
        local conn
        conn = Nodes.PARTY_CREATE_ReturnNODE:Connect(function(id)
            if id ~= reqId then return end
            conn:Disconnect()
            partyReplica = Nodes.WAIT_FOR_PARTY_REPLICA:InvokeSelf()
            task.wait(1)
            if partyReplica then
                partyReplica:FireServer("StartGame")
            else
                notyuri("[AutoJoiner] DoJoin: WAIT_FOR_PARTY_REPLICA returned nil")
            end
        end)
        Nodes.PARTY_CREATE_RequestNODE:FireServer(reqId, queueData or {})
        task.delay(5, function()
            if conn.Connected then
                conn:Disconnect()
                notyuri("[AutoJoiner] DoJoin: PARTY_CREATE_ReturnNODE timed out")
            end
        end)
    end
end
local function JoinerEnabled()
    for _, cfg in ipairs(JoinerConfigs) do
        local t = Toggles[cfg.Toggle]
        if t and t.Value then return true end
    end
    return false
end
local function Func_AutoJoiner()
    while JoinerEnabled() do
        local gr = GetGameReplica()
        local inGame = gr and gr.Data and gr.Data.Wave and gr.Data.Wave > 0 and gr.Data.Finished ~= true
        if not inGame then
            local candidates = {}
            for _, cfg in ipairs(JoinerConfigs) do
                local t = Toggles[cfg.Toggle]
                if t and t.Value then
                    table.insert(candidates, cfg)
                end
            end
            table.sort(candidates, function(a, b)
                local pa = (Options[a.Priority] and Options[a.Priority].Value) or 99
                local pb = (Options[b.Priority] and Options[b.Priority].Value) or 99
                return pa < pb
            end)
            local chosen, queueData
            for _, cfg in ipairs(candidates) do
                local data = cfg.Build()
                if data then
                    chosen = cfg
                    queueData = data
                    break
                else
                    notyuri("[AutoJoiner] Priority " .. tostring((Options[cfg.Priority] and Options[cfg.Priority].Value) or "?") .. " (" .. cfg.Name .. ") Build() returned nil, falling back")
                end
            end
            if chosen and queueData then
                pcall(function() Nodes.REQUEST_LEAVE_MATCHMAKING:Request() end)
                task.wait(1)
                local mm = Toggles[chosen.MM]
                if mm and mm.Value then
                    pcall(function() Nodes.REQUEST_ENTER_MATCHMAKING:Request(queueData) end)
                    notyuri("[AutoJoiner] Matchmaking into " .. chosen.Name)
                else
                    DoJoin(queueData)
                    notyuri("[AutoJoiner] Solo joining " .. chosen.Name)
                end
                task.wait(3)
            end
        end
        task.wait(2)
    end
end
local function UpdateAutoJoinerThread()
    local enabled = JoinerEnabled()
    if Flags["AutoJoiner"] and typeof(Flags["AutoJoiner"]) == "thread" then
        task.cancel(Flags["AutoJoiner"])
        Flags["AutoJoiner"] = nil
    end
    Thread("AutoJoiner", Func_AutoJoiner, enabled)
end
local function SendWebhook(title, description)
    if not request then return end
    local img = yuri[math.random(1, #yuri)]
    pcall(function()
        request({
            Url = Options.WebhookURL.Value,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                username = "Yuri",
                avatar_url = img,
                embeds = {
                    {
                        title = title,
                        description = description,
                        color = 0xFFB6C1,
                        thumbnail = { url = img },
                    },
                },
            }),
        })
    end)
end
local function Func_WHMatchEnd()
    local conn
    conn = Nodes.SET_END_PARAMETERS:Connect(function(p1)
        if not Toggles.WHMatchEnd.Value then
            conn:Disconnect()
            return
        end
        local rd = p1
        if not rd then return end
        local scope = Fusion.scoped(Fusion, FusionState, {
            QueueDataProcessor = QueueDataProcessor,
        })
        local ok, qd = pcall(function()
            return scope:QueueDataProcessor(rd)
        end)
        if not ok then
            Fusion.doCleanup(scope)
            warn("[Webhook] QueueDataProcessor failed: " .. tostring(qd))
            return
        end
        local victory = rd.Victory and "Victory" or "Defeat"
        local gm = Fusion.peek(qd.GamemodeDisplayName) or rd.Gamemode or "Unknown"
        local diff = Fusion.peek(qd.DifficultyLabel) or ""
        local label = Fusion.peek(qd.Label) or ""
        local totalTime = rd.TotalTime or 0
        local mins = math.floor(totalTime / 60)
        local secs = totalTime % 60
        local stageParts = {}
        if label ~= "" then table.insert(stageParts, label) end
        if diff ~= "" then table.insert(stageParts, "(" .. diff .. ")") end
        local stageStr = string.format("[%s] %s - %s", gm, table.concat(stageParts, " "), victory)
        local rewardTotals = {}
        local rewardOrder = {}
        if type(rd.Rewards) == "table" then
            for _, reward in ipairs(rd.Rewards) do
                local asset = reward.Asset or "?"
                local amount = reward.Amount or 1
                if rewardTotals[asset] then
                    rewardTotals[asset] = rewardTotals[asset] + amount
                else
                    rewardTotals[asset] = amount
                    table.insert(rewardOrder, asset)
                end
            end
        end
        local rewardLines = {}
        for _, asset in ipairs(rewardOrder) do
            table.insert(rewardLines, string.format("+%s %s", tostring(rewardTotals[asset]), asset))
        end
        local timeStr = string.format("%d:%02d", mins, secs)
        local desc = string.format(
            "**%s**\n- Time: %s\n- Player: ||%s||\n- Reward:\n%s",
            stageStr,
            timeStr,
            Plr.Name,
            #rewardLines > 0 and table.concat(rewardLines, "\n") or "None"
        )
        SendWebhook("Stage Finished", desc)
        notyuri("[Webhook] Stage finished notification sent")
        Fusion.doCleanup(scope)
    end)
    while Toggles.WHMatchEnd.Value do
        task.wait(1)
    end
    if conn then conn:Disconnect() end
end
local function DoDeleteMap()
    if Toggles.DeleteMap and Toggles.DeleteMap.Value then
        for _, v in pairs(workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") and not v:IsDescendantOf(Plr.Character or {}) then
                    v.Transparency = 1
                    if v:IsA("MeshPart") then v.TextureID = "" end
                end
            end)
        end
    end
end
local function Func_DeleteMap()
    while Toggles.DeleteMap.Value do
        DoDeleteMap()
        task.wait(2)
    end
end
local function Func_DeleteEnemies()
    while Toggles.DeleteEnemies.Value do
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in ipairs(enemies:GetChildren()) do
                pcall(function() enemy.Parent = nil end)
            end
        end
        task.wait(1)
    end
end
local function Func_BlackScreen()
    while Toggles.BlackScreen.Value do
        pcall(function()
            local gui = Instance.new("ScreenGui")
            gui.Name = "Bs"
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 9999
            local frame = Instance.new("Frame")
            frame.Size = UDim2.fromScale(1, 1)
            frame.BackgroundColor3 = Color3.new(0, 0, 0)
            frame.BorderSizePixel = 0
            frame.Parent = gui
            gui.Parent = game:GetService("CoreGui")
            task.wait(1)
            gui:Destroy()
        end)
        task.wait(0.5)
    end
end
local _nameConn = nil
local function Func_HideName()
    if Toggles.HideName.Value then
        _nameConn = game:GetService("RunService").RenderStepped:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        pcall(function() humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
                    end
                    local head = plr.Character:FindFirstChild("Head")
                    if head then
                        for _, child in ipairs(head:GetChildren()) do
                            if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
                                pcall(function() child.Enabled = false end)
                            end
                        end
                    end
                end
            end
        end)
    else
        if _nameConn then
            _nameConn:Disconnect()
            _nameConn = nil
        end
    end
end
local Window = Library:CreateWindow({
    Title                = "Yuri",
    Center               = true,
    AutoShow             = true,
    Resizable            = true,
    ShowCustomCursor     = false,
    UnlockMouseWhileOpen = false,
    NotifySide           = "Left",
    TabPadding           = 8,
    MenuFadeTime         = 0.2
})
AddInfo(Window)
local Tabs = {
    Main     = Window:AddTab("Main"),
    AutoPlay = Window:AddTab("Auto Play"),
    Joiner   = Window:AddTab("Joiner"),
    Player   = Window:AddTab("Player"),
    Webhook  = Window:AddTab("Webhook"),
    Config   = Window:AddTab("Config"),
}
local Left  = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
local Right = Tabs.AutoPlay:AddRightGroupbox("Limits")
Left:AddToggle("AutoPlay", {
    Text    = "Auto Play",
    Default = false,
})
Left:AddDivider()
Left:AddDropdown("APUpgradeMethod", {
    Text    = "Upgrade Method",
    Values  = {
        "Lowest Level (Spread Upgrade)",
        "Hotbar left to right (until Max)",
        "Randomize",
        "Customize upgrade order (Set below)",
    },
    Default = "Lowest Level (Spread Upgrade)",
})
Left:AddDivider()
Left:AddToggle("APAutoUpgrade", {
    Text    = "Auto Upgrade",
    Default = false,
})
Left:AddToggle("APPlaceAndUpgrade", {
    Text    = "Place and Upgrade",
    Default = false,
})
Left:AddToggle("APFocusFarm", {
    Text    = "Focus on Farm",
    Default = false,
})
Right:AddLabel("Place Order per Slot", true)
for i = 1, 6 do
    Right:AddSlider("APPlaceOrder" .. i, {
        Text     = "Slot " .. i,
        Default  = i,
        Min      = 1,
        Max      = 6,
        Rounding = 0,
        Compact  = true,
    })
end
Right:AddDivider()
Right:AddLabel("Place Wave per Slot", true)
for i = 1, 6 do
    Right:AddSlider("APPlaceWave" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 50,
        Rounding = 0,
        Compact  = true,
    })
end
Right:AddDivider()
Right:AddLabel("Place Limit per Slot", true)
for i = 1, 6 do
    Right:AddSlider("APPlaceLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 10,
        Rounding = 0,
        Compact  = true,
    })
end
Right:AddDivider()
Right:AddLabel("Upgrade Limit per Slot", true)
for i = 1, 6 do
    Right:AddSlider("APUpgradeLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 30,
        Rounding = 0,
        Compact  = true,
    })
end
local Pos_A    = Tabs.AutoPlay:AddLeftGroupbox("Set Position")
local Pos_B = Tabs.AutoPlay:AddRightGroupbox("Position Manage")
Pos_A:AddLabel("Stand where you want units placed, select a slot, then press Set Slot Position.", true)
MapLabelRef = Pos_A:AddLabel("Current Map: ...", true)
Pos_A:AddDropdown("APSetSlotSelect", {
    Text    = "Set Slot Position",
    Values  = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6" },
    Default = "Slot 1",
})
Pos_A:AddButton({
    Text = "Set Slot Position",
    Func = function()
        local val  = Options.APSetSlotSelect and Options.APSetSlotSelect.Value or "Slot 1"
        local slot = tonumber(val:match("%d+")) or 1
        SetPos(slot)
    end,
})
Pos_A:AddButton({
    Text = "Mass Set All Slots",
    Func = function()
        MassSetPos()
    end,
})
Pos_B:AddLabel("Positions recorded for current map:", true)
PosLabelRef = Pos_B:AddLabel("Not in a game", true)
Pos_B:AddDivider()
Pos_B:AddDropdown("APResetSlotSelect", {
    Text    = "Reset Position",
    Values  = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6", "All Slots" },
    Default = "Slot 1",
})
Pos_B:AddButton({
    Text = "Reset Slot Positions",
    Func = function()
        local val = Options.APResetSlotSelect and Options.APResetSlotSelect.Value or "Slot 1"
        if val == "All Slots" then
            ResetPos(nil)
        else
            local slot = tonumber(val:match("%d+"))
            ResetPos(slot)
        end
    end,
})
task.spawn(function()
    while not Library.Unloaded do
        UpdatePosLabels()
        task.wait(2)
    end
end)
local WH1 = Tabs.Webhook:AddLeftGroupbox("Webhook")
local TB = {
    Main = {
        Left  = { Autofarm = Tabs.Main:AddLeftTabbox()  },
        Right = { Autofarm = Tabs.Main:AddRightTabbox() },
    },
}
local TB_Tabs = {
    Autofarm = {
        T1    = TB.Main.Left.Autofarm:AddTab("Macro"),
        T2   = TB.Main.Left.Autofarm:AddTab("Reward"),
        T3   = TB.Main.Left.Autofarm:AddTab("Lobby"),
        T4   = TB.Main.Left.Autofarm:AddTab("Game"),
    },
    Autofarm2 = {
        T1    = TB.Main.Right.Autofarm:AddTab("Game Config"),
        T2    = TB.Main.Right.Autofarm:AddTab("Lobby Config"),
    },
}
local GB = {
    Player = {
        Left  = {
            General = Tabs.Player:AddLeftGroupbox("General"),
            Server  = Tabs.Player:AddLeftGroupbox("Server"),
        },
        Right = {
            Game = Tabs.Player:AddRightGroupbox("Game"),
        },
    },
}
TB_Tabs.Autofarm.T1:AddDropdown("MacroSelected", {
    Text   = "Select File",
    Values = ListMacros(),
    Default = ListMacros()[1] or "",
})
Options.MacroSelected:OnChanged(function(v)
    if v and v ~= "" then
        MState.Load = LoadMacro(v)
        if not MState.Load then
            Library:Notify("Failed to load macro: " .. v, 4)
        end
    end
end)
TB_Tabs.Autofarm.T1:AddInput("FileName", {
    Text        = "File Name",
    Default     = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T1:AddToggle("RecMacro", {
    Text    = "Record Macro",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", {
    Text    = "Load Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
Toggles.RecMacro:OnChanged(function(v)
    Func_MacRec(v)
end)
Toggles.LoadMacro:OnChanged(function(v)
    if v then
        if not MState.Load then
            local name = Options.MacroSelected and Options.MacroSelected.Value or ""
            if name and name ~= "" then
                MState.Load = LoadMacro(name)
            end
        end
        if not MState.Load then
            Library:Notify("No macro selected", 3)
            Toggles.LoadMacro:SetValue(false)
            return
        end
    end
    Thread("LoadMacro", Func_LoadMacro, v)
end)
LoadMDir()
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimQuest", { Text = "Auto Claim Quests", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimBattlepass", { Text = "Auto Claim Battlepass", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimMilestone", { Text = "Auto Claim Milestones", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimIndex", { Text = "Auto Claim Index", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimCalendar", { Text = "Auto Claim Calendar", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoVoteSkip", { Text = "Auto Vote Skip", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoRestart", { Text = "Auto Restart", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoVoteStart", { Text = "Auto Vote Start", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoSkipWave", { Text = "Auto Skip Wave", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoReplay", { Text = "Auto Replay", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoNext", { Text = "Auto Next", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoReturnLobby", { Text = "Auto Return Lobby", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("TPLobby", { Text = "Auto TP Lobby", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoSellFarm", { Text = "Auto Sell Farm", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoSellUnit", { Text = "Auto Sell Unit", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoFishing", { Text = "Auto Fishing", Default = false })
TB_Tabs.Autofarm.T3:AddToggle("AutoCraft", { Text = "Auto Craft", Default = false })
local SummonBannerValues = GetActiveBanners()
local SummonTargetValues = GetSummonTargetList()
TB_Tabs.Autofarm2.T2:AddDropdown("SummonBanner", {
    Text    = "Target Banner",
    Values  = SummonBannerValues,
    Default = SummonBannerValues[1] or "",
})
TB_Tabs.Autofarm2.T2:AddDropdown("SummonTargets", {
    Text      = "Target Unit",
    Values    = SummonTargetValues,
    Default   = {},
    Multi     = true,
    AllowNull = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T3:AddToggle("AutoSummon", { Text = "Auto Summon", Default = false })
WH1:AddToggle("WHMatchEnd", { Text = "Match End", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("AutoReturnLobbyTime", { Text = "Return Lobby", Default = "5" })
TB_Tabs.Autofarm2.T1:AddInput("TPLobbyTime", { Text = "TP Lobby", Default = "10" })
TB_Tabs.Autofarm2.T1:AddInput("SkipStopWave", { Text = "Skip Stop Wave", Default = "0" })
TB_Tabs.Autofarm2.T1:AddInput("SellFarmWave", { Text = "Sell Farm Wave", Default = "0" })
TB_Tabs.Autofarm2.T1:AddInput("SellUnitWave", { Text = "Sell Unit Wave", Default = "0" })
local SJ_DefaultMap   = (Information.Maps:GetOrderedMaps("Story"))[1]
local SJ_DefaultActs  = Information.Maps:GetOrderedActs("Story", SJ_DefaultMap)
local SJ_DefaultDiffs = (Information.Maps:GetMapData("Story", SJ_DefaultMap) or {}).Difficulties or {}
local SJ = Tabs.Joiner:AddLeftGroupbox("Story Joiner")
SJ:AddToggle("AutoJoinStory", { Text = "Auto Join Story", Default = false })
SJ:AddToggle("SJMatchmaking", { Text = "Match Making", Default = false })
SJ:AddDropdown("SJMap", { Text = "Map", Values = Information.Maps:GetOrderedMaps("Story"), Default = SJ_DefaultMap })
SJ:AddDropdown("SJAct", { Text = "Act", Values = SJ_DefaultActs, Default = SJ_DefaultActs[1] })
SJ:AddDropdown("SJDifficulty", { Text = "Difficulty", Values = SJ_DefaultDiffs, Default = SJ_DefaultDiffs[1] })
SJ:AddSlider("SJPriority", { Text = "Priority", Default = 1, Min = 1, Max = 4, Rounding = 0, Compact = true })
Options.SJMap:OnChanged(function(v)
    local acts = Information.Maps:GetOrderedActs("Story", v)
    Options.SJAct:SetValues(acts)
    if not table.find(acts, Options.SJAct.Value) then
        Options.SJAct:SetValue(acts[1])
    end
    local diffs = (Information.Maps:GetMapData("Story", v) or {}).Difficulties or {}
    Options.SJDifficulty:SetValues(diffs)
    if not table.find(diffs, Options.SJDifficulty.Value) then
        Options.SJDifficulty:SetValue(diffs[1])
    end
end)
local RJ_DefaultMap   = (Information.Maps:GetOrderedMaps("Raid"))[1]
local RJ_DefaultActs  = Information.Maps:GetOrderedActs("Raid", RJ_DefaultMap)
local RJ_DefaultDiffs = (Information.Maps:GetMapData("Raid", RJ_DefaultMap) or {}).Difficulties or {}
local RJ = Tabs.Joiner:AddRightGroupbox("Raid Joiner")
RJ:AddToggle("AutoJoinRaid", { Text = "Auto Join Raid", Default = false })
RJ:AddToggle("RJMatchmaking", { Text = "Match Making", Default = false })
RJ:AddDropdown("RJMap", { Text = "Map", Values = Information.Maps:GetOrderedMaps("Raid"), Default = RJ_DefaultMap })
RJ:AddDropdown("RJAct", { Text = "Act", Values = RJ_DefaultActs, Default = RJ_DefaultActs[1] })
RJ:AddDropdown("RJDifficulty", { Text = "Difficulty", Values = RJ_DefaultDiffs, Default = RJ_DefaultDiffs[1] })
RJ:AddSlider("RJPriority", { Text = "Priority", Default = 2, Min = 1, Max = 4, Rounding = 0, Compact = true })
Options.RJMap:OnChanged(function(v)
    local acts = Information.Maps:GetOrderedActs("Raid", v)
    Options.RJAct:SetValues(acts)
    if not table.find(acts, Options.RJAct.Value) then
        Options.RJAct:SetValue(acts[1])
    end
    local diffs = (Information.Maps:GetMapData("Raid", v) or {}).Difficulties or {}
    Options.RJDifficulty:SetValues(diffs)
    if not table.find(diffs, Options.RJDifficulty.Value) then
        Options.RJDifficulty:SetValue(diffs[1])
    end
end)
local EJ_DefaultMap = (Information.Maps:GetOrderedMaps("Expedition"))[1]
local EJ = Tabs.Joiner:AddLeftGroupbox("Expedition Joiner")
EJ:AddToggle("AutoJoinExpedition", { Text = "Auto Join Expedition", Default = false })
EJ:AddToggle("EJMatchmaking", { Text = "Match Making", Default = false })
EJ:AddDropdown("EJMap", { Text = "Map", Values = Information.Maps:GetOrderedMaps("Expedition"), Default = EJ_DefaultMap })
EJ:AddSlider("EJDifficultyLevel", { Text = "Difficulty Level", Default = 1, Min = 1, Max = 3, Rounding = 0, Compact = true })
EJ:AddSlider("EJPriority", { Text = "Priority", Default = 3, Min = 1, Max = 4, Rounding = 0, Compact = true })
local CJ = Tabs.Joiner:AddRightGroupbox("Challenge Joiner")
CJ:AddToggle("AutoJoinChallenge", { Text = "Auto Join Challenge", Default = false })
CJ:AddToggle("CJMatchmaking", { Text = "Match Making", Default = false })
CJ:AddDropdown("CJType", { Text = "Challenge Type", Values = { "Regular", "Daily", "Weekly" }, Default = "Regular" })
CJ:AddSlider("CJIndex", { Text = "Challenge Slot", Default = 1, Min = 1, Max = 3, Rounding = 0, Compact = true })
CJ:AddSlider("CJPriority", { Text = "Priority", Default = 4, Min = 1, Max = 4, Rounding = 0, Compact = true })
local PJ = Tabs.Joiner:AddLeftGroupbox("Portal Joiner")
PJ:AddToggle("AutoJoinPortal", { Text = "Auto Join", Default = false })
PJ:AddToggle("AutoPickPortalReward", { Text = "Auto Pick Portal Reward", Default = false })
PJ:AddSlider("PortalTierCap", { Text = "Tier Cap", Default = 5, Min = 1, Max = 10, Rounding = 0, Compact = true })
GetIgnoredPortalModifiers = AddMultiDropdown(PJ, "PortalIgnoreModifier", {
    Text = "Ignore Modifier",
    Values = PortalModifierValues,
    Default = {},
    label = PortalModifierLabelToId,
})
Func_PortalRewardPicker()
Toggles.AutoJoinPortal:OnChanged(function(v) Thread("AutoJoinPortal", SafeLoop("AutoJoinPortal", Func_AutoJoinPortal), v) end)
WH1:AddInput("WebhookURL", { Text = "Webhook URL", Default = "" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS",  Text = "WalkSpeed",  Default = 16,  Min = 16,  Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP",  Text = "JumpPower",  Default = 50,  Min = 0,   Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH",  Text = "HipHeight",  Default = 2,   Min = 0,   Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV",  Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
    Text     = "Anti AFK",
    Default  = true,
    Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick",         { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect",    { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused" })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function()
    Services.TeleportService:Teleport(game.PlaceId, Plr)
end })
GB.Player.Right.Game:AddToggle("InstantPP",  { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog",      { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
GB.Player.Right.Game:AddToggle("DeleteMap",      { Text = "Delete Map",      Default = false })
GB.Player.Right.Game:AddToggle("DeleteEnemies",  { Text = "Delete Enemies",  Default = false })
GB.Player.Right.Game:AddToggle("BlackScreen",    { Text = "Black Screen",    Default = false })
GB.Player.Right.Game:AddToggle("HideName",       { Text = "Hide Name",       Default = false })
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
        if Toggles.WS.Value  then Hum.WalkSpeed  = Options.WSValue.Value end
        if Toggles.JP.Value  then Hum.JumpPower  = Options.JPValue.Value; Hum.UseJumpPower = true end
        if Toggles.HH.Value  then Hum.HipHeight  = Options.HHValue.Value end
    end
    workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
    if Toggles.FOV.Value  then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
    if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance           = Options.ZoomValue.Value end
end)
task.spawn(function()
    while task.wait() do
        if Toggles.Fullbright.Value then
            Lighting.Brightness    = 2
            Lighting.ClockTime     = 14
            Lighting.GlobalShadows = false
        elseif Toggles.OverrideTime.Value then
            Lighting.ClockTime = Options.OverrideTimeValue.Value
        end
        if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
        if Library.Unloaded then break end
    end
end)
Options.LimitFPSValue:OnChanged(function()
    if FPS_T.Value then setfpscap(FPS_S.Value) end
end)
Toggles.LimitFPS:OnChanged(function(v)
    FPS_S:SetVisible(FPS_T.Value)
    if not v then setfpscap(999) end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state) ApplyFPSBoost(state) end)
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
        for _, v in pairs(GC(Players.LocalPlayer.Idled)) do
            if v["Disable"]    then v["Disable"](v)
            elseif v["Disconnect"] then v["Disconnect"](v) end
        end
    else
        local VU = cloneref(game:GetService("VirtualUser"))
        Players.LocalPlayer.Idled:Connect(function()
            VU:CaptureController()
            VU:ClickButton2(Vector2.new())
        end)
    end
end
Toggles.AntiAFK:OnChanged(function(state) if state then RunAntiAFK() end end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
Toggles.AutoClaimQuest:OnChanged(function(v) Thread("AutoClaimQuest", SafeLoop("AutoClaimQuest", Func_AutoClaimQuest), v) end)
Toggles.AutoClaimBattlepass:OnChanged(function(v) Thread("AutoClaimBattlepass", SafeLoop("AutoClaimBattlepass", Func_AutoClaimBattlepass), v) end)
Toggles.AutoClaimMilestone:OnChanged(function(v) Thread("AutoClaimMilestone", SafeLoop("AutoClaimMilestone", Func_AutoClaimMilestone), v) end)
Toggles.AutoClaimIndex:OnChanged(function(v) Thread("AutoClaimIndex", SafeLoop("AutoClaimIndex", Func_AutoClaimIndex), v) end)
Toggles.AutoClaimCalendar:OnChanged(function(v) Thread("AutoClaimCalendar", SafeLoop("AutoClaimCalendar", Func_AutoClaimCalendar), v) end)
Toggles.AutoVoteSkip:OnChanged(function(v) Thread("AutoVoteSkip", SafeLoop("AutoVoteSkip", Func_AutoVoteSkip), v) end)
Toggles.AutoRestart:OnChanged(function(v) Thread("AutoRestart", SafeLoop("AutoRestart", Func_AutoRestart), v) end)
Toggles.AutoSkipWave:OnChanged(function(v) if v then Func_AutoSkipWave() end end)
Toggles.AutoVoteStart:OnChanged(function(v) Thread("AutoVoteStart", SafeLoop("AutoVoteStart", Func_AutoVoteStart), v) end)
Toggles.AutoReplay:OnChanged(function(v) Thread("AutoReplay", SafeLoop("AutoReplay", Func_AutoReplay), v) end)
Toggles.AutoNext:OnChanged(function(v) Thread("AutoNext", SafeLoop("AutoNext", Func_AutoNext), v) end)
Toggles.AutoReturnLobby:OnChanged(function(v) Thread("AutoReturnLobby", SafeLoop("AutoReturnLobby", Func_AutoReturnLobby), v) end)
Toggles.AutoFishing:OnChanged(function(v) Thread("AutoFishing", SafeLoop("AutoFishing", Func_AutoFishing), v) end)
Toggles.TPLobby:OnChanged(function(v) Thread("TPLobby", SafeLoop("TPLobby", Func_TPLobby), v) end)
Toggles.AutoSellFarm:OnChanged(function(v) Thread("AutoSellFarm", SafeLoop("AutoSellFarm", Func_AutoSellFarm), v) end)
Toggles.AutoSellUnit:OnChanged(function(v) Thread("AutoSellUnit", SafeLoop("AutoSellUnit", Func_AutoSellUnit), v) end)
Toggles.AutoCraft:OnChanged(function(v) Thread("AutoCraft", SafeLoop("AutoCraft", Func_AutoCraft), v) end)
Toggles.AutoSummon:OnChanged(function(v) Thread("AutoSummon", SafeLoop("AutoSummon", Func_AutoSummon), v) end)
Toggles.AutoPlay:OnChanged(function(v)
    Thread("AutoPlay", SafeLoop("AutoPlay", Func_AutoPlay), v)
    if not v then
        PCubeReleaseAll()
        for _, p in ipairs(workspace:GetChildren()) do
            if p.Name == "PCube" and not PCubePool.Active[p] then p:Destroy() end
        end
    end
end)
Toggles.AutoJoinStory:OnChanged(UpdateAutoJoinerThread)
Toggles.AutoJoinRaid:OnChanged(UpdateAutoJoinerThread)
Toggles.AutoJoinExpedition:OnChanged(UpdateAutoJoinerThread)
Toggles.AutoJoinChallenge:OnChanged(UpdateAutoJoinerThread)
Toggles.WHMatchEnd:OnChanged(function(v) Thread("WHMatchEnd", SafeLoop("WHMatchEnd", Func_WHMatchEnd), v) end)
Toggles.DeleteMap:OnChanged(function(v) Thread("DeleteMap", SafeLoop("DeleteMap", Func_DeleteMap), v) end)
Toggles.DeleteEnemies:OnChanged(function(v) Thread("DeleteEnemies", SafeLoop("DeleteEnemies", Func_DeleteEnemies), v) end)
Toggles.BlackScreen:OnChanged(function(v) Thread("BlackScreen", SafeLoop("BlackScreen", Func_BlackScreen), v) end)
Toggles.HideName:OnChanged(function(v) Func_HideName() end)
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", { Text = "Auto Show UI", Default = true })
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = false,
    Callback = function(Value) Library.ShowCustomCursor = Value end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(Value) Library:SetNotifySide(Value) end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default  = "100%",
    Text     = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        Library:SetDPIScale(tonumber(Value))
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
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/AnimeExpeditions")
local function SerializePositions()
    local out = {}
    for mapName, slots in pairs(SlotPositions) do
        local slotsOut = {}
        for slot, list in pairs(slots) do
            local arr = {}
            for _, cf in ipairs(list) do
                table.insert(arr, { X = cf.X, Y = cf.Y, Z = cf.Z })
            end
            slotsOut[tostring(slot)] = arr
        end
        out[mapName] = slotsOut
    end
    return out
end
local function DeserializePositions(data)
    local out = {}
    if type(data) ~= "table" then return out end
    for mapName, slots in pairs(data) do
        local slotsOut = {}
        for slotKey, arr in pairs(slots) do
            local slot = tonumber(slotKey) or slotKey
            local list = {}
            for _, p in ipairs(arr) do
                table.insert(list, CFrame.new(p.X, p.Y, p.Z))
            end
            slotsOut[slot] = list
        end
        out[mapName] = slotsOut
    end
    return out
end
local function GetConfigFilePath(name)
    local fullPath = SaveManager.Folder .. '/settings/' .. name .. '.json'
    if SaveManager:CheckSubFolder(false) then
        fullPath = SaveManager.Folder .. "/settings/" .. SaveManager.SubFolder .. "/" .. name .. '.json'
    end
    return fullPath
end
local Original_SaveManager_Save   = SaveManager.Save
local Original_SaveManager_Load   = SaveManager.Load
local Original_SaveManager_Delete = SaveManager.Delete
function SaveManager:Save(name)
    local ok, err = Original_SaveManager_Save(self, name)
    if ok and Support.FileIO then
        local path = GetConfigFilePath(name)
        if isfile(path) then
            local rok, raw = pcall(readfile, path)
            if rok then
                local dok, data = pcall(HttpService.JSONDecode, HttpService, raw)
                if dok and type(data) == "table" then
                    data.positions = SerializePositions()
                    local enc_ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
                    if enc_ok then
                        pcall(writefile, path, encoded)
                    else
                        notyuri("[AutoPlay] Failed to encode positions into config " .. tostring(name))
                    end
                else
                    notyuri("[AutoPlay] Failed to decode config for positions inject: " .. tostring(name))
                end
            else
                notyuri("[AutoPlay] Failed to read config file for positions inject: " .. tostring(name))
            end
        end
    end
    return ok, err
end
function SaveManager:Load(name)
    if Support.FileIO then
        local path = GetConfigFilePath(name)
        if isfile(path) then
            local rok, raw = pcall(readfile, path)
            if rok then
                local dok, data = pcall(HttpService.JSONDecode, HttpService, raw)
                if dok and type(data) == "table" and data.positions ~= nil then
                    local posData = data.positions
                    data.positions = nil
                    local enc_ok, stripped = pcall(HttpService.JSONEncode, HttpService, data)
                    if enc_ok then
                        pcall(writefile, path, stripped)
                    end
                    local ok, err = Original_SaveManager_Load(self, name)
                    if ok then
                        SlotPositions = DeserializePositions(posData)
                        UpdatePosLabels()
                        notyuri("[AutoPlay] Loaded positions from config " .. tostring(name))
                    end
                    if isfile(path) then
                        local rok2, raw2 = pcall(readfile, path)
                        if rok2 then
                            local dok2, data2 = pcall(HttpService.JSONDecode, HttpService, raw2)
                            if dok2 and type(data2) == "table" then
                                data2.positions = posData
                                local enc_ok2, encoded2 = pcall(HttpService.JSONEncode, HttpService, data2)
                                if enc_ok2 then pcall(writefile, path, encoded2) end
                            end
                        end
                    end
                    return ok, err
                else
                    notyuri("[AutoPlay] No positions key in config " .. tostring(name) .. ", loading normally")
                end
            end
        end
    end
    return Original_SaveManager_Load(self, name)
end
function SaveManager:Delete(name)
    return Original_SaveManager_Delete(self, name)
end
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
task.defer(function()
    SaveManager:LoadAutoloadConfig()
end)
SaveManager:SetLoadingOrder(true, {"Dropdown", "Slider", "ColorPicker", "KeyPicker", "Input", "Toggle"})
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
Library:Notify("Script Loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
    notyuri("ERROR: " .. tostring(err))
end
