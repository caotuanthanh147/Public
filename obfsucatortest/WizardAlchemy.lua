if script_key == nil or script_key ~= "Yuri(Heart)" then
    game:GetService("Players").LocalPlayer:Kick("Lesbian")
    return
end
if getgenv().ayasemiyatongekissazumirisa then
    return
end
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
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
local TweenService = Services.TweenService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local CollectionService = Services.CollectionService
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
local ShowBoxTable = (function()
    local Players     = game:GetService("Players")
    local Debris      = game:GetService("Debris")
    local TweenService = game:GetService("TweenService")
    local RunService  = game:GetService("RunService")
    local _SBT        = {}
    local _color      = Color3.fromRGB(255, 50, 50)
    local _material   = Enum.Material.Neon
    local _entry      = {}
    local function _enabled()
        local lp = Players.LocalPlayer
        return lp and lp:GetAttribute("ShowHitbox") == true or false
    end
    function _SBT.ShowBox(cf, size, duration, color)
        if not _enabled() then return nil end
        local p = Instance.new("Part")
        p.Name = "HitboxVisual_Box"; p.Shape = Enum.PartType.Block
        p.Size = size; p.CFrame = cf; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Color = color or _color; p.Material = _material; p.Transparency = 0.8
        p.Parent = workspace
        Debris:AddItem(p, duration or 0.3)
        return p
    end
    function _SBT.ShowSphere(pos, radius, duration, color)
        if not _enabled() then return nil end
        local p = Instance.new("Part")
        p.Name = "HitboxVisual_Sphere"; p.Shape = Enum.PartType.Ball
        p.Size = Vector3.new(radius*2, radius*2, radius*2); p.Position = pos; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Color = color or _color; p.Material = _material; p.Transparency = 0.8
        p.Parent = workspace
        Debris:AddItem(p, duration or 0.3)
        return p
    end
    function _SBT.ShowTraveling(origin, dir, size, speed, dist, shapeFlag, color)
        if not _enabled() then return nil end
        local p = Instance.new("Part")
        p.Name = "HitboxVisual_Traveling"; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Color = color or _color; p.Material = _material; p.Transparency = 0.8
        if shapeFlag == "Sphere" or type(size) == "number" then
            p.Shape = Enum.PartType.Ball
            local r = type(size) == "number" and size or size.X/2
            p.Size = Vector3.new(r*2, r*2, r*2)
        else
            p.Shape = Enum.PartType.Block; p.Size = size
        end
        p.CFrame = CFrame.lookAt(origin, origin + dir)
        p.Parent = workspace
        local t = dist / speed
        TweenService:Create(p, TweenInfo.new(t, Enum.EasingStyle.Linear), {
            CFrame = CFrame.lookAt(origin + dir*dist, origin + dir*dist + dir)
        }):Play()
        Debris:AddItem(p, t + 0.1)
        return p
    end
    function _SBT.ShowFollowingAOE(model, size, duration, cfOffset, color, shapeFlag)
        if not _enabled() then return nil end
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local p = Instance.new("Part")
        p.Name = "HitboxVisual_FollowingAOE"
        p.Shape = (shapeFlag == "Sphere") and Enum.PartType.Ball or Enum.PartType.Block
        p.Size = size; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Color = color or _color; p.Material = _material; p.Transparency = 0.8
        local cf = typeof(cfOffset) == "CFrame" and cfOffset
                or typeof(cfOffset) == "Vector3" and CFrame.new(cfOffset)
                or CFrame.new()
        p.CFrame = hrp.CFrame * cf; p.Parent = workspace
        local conn, started = nil, tick()
        local dur = duration or 0.3
        conn = RunService.Heartbeat:Connect(function()
            if dur <= tick() - started then conn:Disconnect(); return end
            if p and p.Parent then
                if hrp and hrp.Parent then p.CFrame = hrp.CFrame * cf
                else conn:Disconnect(); p:Destroy() end
            else conn:Disconnect() end
        end)
        Debris:AddItem(p, dur)
        return p
    end
    function _SBT.ShowStaticBox(from, to, width, height, duration, color)
        if not _enabled() then return nil end
        local mag = (to - from).Magnitude
        local mid = (from + to) / 2
        local p = Instance.new("Part")
        p.Name = "HitboxVisual_StaticBox"; p.Shape = Enum.PartType.Block
        p.Size = Vector3.new(width, height, mag)
        p.CFrame = CFrame.lookAt(mid, to); p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Color = color or _color; p.Material = _material; p.Transparency = 0.8
        p.Parent = workspace
        Debris:AddItem(p, duration or 0.3)
        return p
    end
    function _SBT.ShowExplosion(pos, radius, duration, color)
        if not _enabled() then return nil end
        local p = Instance.new("Part")
        p.Name = "HitboxVisual_Explosion"; p.Shape = Enum.PartType.Ball
        p.Size = Vector3.new(radius*2, radius*2, radius*2); p.Position = pos; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Color = color or _color; p.Material = _material; p.Transparency = 0.8
        p.Parent = workspace
        Debris:AddItem(p, duration or 0.5)
        return p
    end
    function _SBT.ShowMultiWave(cf, waves)
        if not _enabled() then return end
        for _, w in ipairs(waves) do
            task.delay(w.Delay or 0, function()
                local size   = w.Size     or Vector3.new(10, 10, 30)
                local offset = w.Offset   or 0
                local dur    = w.Duration or 0.3
                _SBT.ShowBox(cf * CFrame.new(0, 0, -offset), size, dur)
            end)
        end
    end
    function _SBT.ShowWeldedSphere(part, radius, duration, color, key)
        if not _enabled() then return nil end
        if not (part and part.Parent) then return nil end
        local p = Instance.new("Part")
        p.Name = "HitboxVisual_WeldedSphere"; p.Shape = Enum.PartType.Ball
        p.Size = Vector3.new(radius*2, radius*2, radius*2); p.Position = part.Position; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
        p.Color = color or _color; p.Material = _material; p.Transparency = 0.8
        p.Parent = workspace
        if key then _entry[key] = p end
        local conn, started = nil, tick()
        local dur = duration or 0.3
        conn = RunService.Heartbeat:Connect(function()
            if dur <= tick() - started then
                conn:Disconnect()
                if p and p.Parent then p:Destroy() end
                if key then _entry[key] = nil end
                return
            end
            if p and p.Parent then
                if part and part.Parent then p.Position = part.Position
                else conn:Disconnect(); p:Destroy(); if key then _entry[key] = nil end end
            else conn:Disconnect(); if key then _entry[key] = nil end end
        end)
        Debris:AddItem(p, dur + 0.5)
        return p
    end
    function _SBT.EndWeldedSphere(key)
        local p = _entry[key]
        if p and p.Parent then p:Destroy() end
        _entry[key] = nil
    end
    return _SBT
end)()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local isLimitedExecutor = executorDisplayName:lower():find("xeno") ~= nil
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
            local inviteCode = "b6kxdDtqd"
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
    end
end
local _FS = (_DR and _DR.FireServer)
local Remotes = {}
local Modules = {}
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
local _rlTimestamps = {}
local function RateAllow(key, maxPerSec)
    local now = tick()
    local window = 1 / maxPerSec
    local last = _rlTimestamps[key] or 0
    if now - last >= window then
        _rlTimestamps[key] = now
        return true
    end
    return false
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
local _UtilsSystem       = nil
local _GetData           = nil
local _PlayerData        = nil
local _CfgFind           = nil
local _TranslationHelper = nil
do
    local ok, us = pcall(function()
        return require(game.ReplicatedFirst
            :WaitForChild("AllSideCode", 5)
            :WaitForChild("UtilsSystem", 5))
    end)
    if ok and us then
        _UtilsSystem       = us
        _GetData           = us.GetData
        _PlayerData        = us.PlayerData
        _CfgFind           = us.CfgFind
        _TranslationHelper = us.TranslationHelper
    end
end
local NO_TRANS_PREFIX = "\230\156\170\230\156\172\229\156\176\229\140\150-"
local function Translate(zh)
    if type(zh) ~= "string" or zh == "" then return zh end
    if not _TranslationHelper then return zh end
    local result = _TranslationHelper.translateByKey(zh)
    if type(result) ~= "string" or result == "" then return zh end
    if result:sub(1, #NO_TRANS_PREFIX) == NO_TRANS_PREFIX then return zh end
    return result
end
local TargetDisplayNames = {}
local DisplayToZhName    = {}   
do
    local enemyConf = _CfgFind and _CfgFind.GetCfgByName and _CfgFind.GetCfgByName("enemyConf")
    if enemyConf then
        local seen = {}
        for _, cfg in pairs(enemyConf) do
            local zh = type(cfg) == "table" and cfg.ZhName
            if type(zh) == "string" and zh ~= "" and not seen[zh] then
                seen[zh] = true
                local display = Translate(zh)
                table.insert(TargetDisplayNames, display)
                DisplayToZhName[display] = zh
            end
        end
        table.sort(TargetDisplayNames)
    end
end
local MaterialDisplayNames = {}
local MaterialNameToID     = {}
do
    local matConf = _CfgFind and _CfgFind.GetCfgByName and _CfgFind.GetCfgByName("materialConf")
    if matConf then
        local rows = {}
        for id, cfg in pairs(matConf) do
            local numID = tonumber(id) or id
            if type(cfg) == "table" then
                local display = Translate(cfg.ZhName or tostring(numID))
                table.insert(rows, {id = numID, display = display})
            end
        end
        table.sort(rows, function(a, b) return (a.id or 0) < (b.id or 0) end)
        for _, row in ipairs(rows) do
            table.insert(MaterialDisplayNames, row.display)
            MaterialNameToID[row.display] = row.id
        end
    end
end
local SellItemDisplayNames = {}
local SellItemNameToID     = {}
do
    local function addConf(conf)
        if not conf then return end
        local rows = {}
        for id, cfg in pairs(conf) do
            local numID = tonumber(id) or id
            if type(cfg) == "table" then
                local display = Translate(cfg.ZhName or tostring(numID))
                table.insert(rows, {id = numID, display = display})
            end
        end
        table.sort(rows, function(a, b) return (a.id or 0) < (b.id or 0) end)
        for _, row in ipairs(rows) do
            table.insert(SellItemDisplayNames, row.display)
            SellItemNameToID[row.display] = row.id
        end
    end
    addConf(_CfgFind and _CfgFind.GetCfgByName and _CfgFind.GetCfgByName("potionConf"))
    addConf(_CfgFind and _CfgFind.GetCfgByName and _CfgFind.GetCfgByName("materialConf"))
    table.sort(SellItemDisplayNames, function(a, b)
        return (SellItemNameToID[a] or 0) < (SellItemNameToID[b] or 0)
    end)
end
local RaceDisplayNames = {}
local RaceDisplayToID  = {}
local RaceIDToDisplay  = {}
do
    local raceConf = _CfgFind and _CfgFind.GetCfgByName and _CfgFind.GetCfgByName("humanraceConf")
    if raceConf then
        for id, cfg in pairs(raceConf) do
            local numID = tonumber(id)
            if numID and type(cfg) == "table" and cfg.ZhName then
                local display = Translate(cfg.ZhName)
                table.insert(RaceDisplayNames, display)
                RaceDisplayToID[display] = numID
                RaceIDToDisplay[numID]   = display
            end
        end
        table.sort(RaceDisplayNames)
    end
end
local _npcDisplayNames  = {}
local _npcDisplayToRaw  = {}
local function BuildNPCList()
    local names, rawMap, seen = {}, {}, {}
    for _, part in ipairs(CollectionService:GetTagged("Talk")) do
        local npcName = part:GetAttribute("TalkNpcName")
        if npcName and not seen[npcName] then
            seen[npcName] = true
            local display = Translate(npcName)
            if display and display ~= "" then
                table.insert(names, display)
                rawMap[display] = npcName
            end
        end
    end
    table.sort(names)
    return names, rawMap
end
local PickRemote = RS:WaitForChild("Msg", 10)
    and RS.Msg:WaitForChild("RemoteEvent", 10)
    and RS.Msg.RemoteEvent:WaitForChild("RemoteEvent", 10)
local SkillRemote = (function()
    local msg = RS:WaitForChild("Msg", 10)
    if not msg then return nil end
    local re = msg:WaitForChild("RemoteEvent", 10)
    if not re then return nil end
    return re:WaitForChild("ReleaseGroupSkill", 10)
end)()
local ChestRemote = RS:WaitForChild("Msg", 10)
    and RS.Msg:WaitForChild("RemoteFunction", 10)
    and RS.Msg.RemoteFunction:WaitForChild("SystemChestRemoteFunction", 10)
local AlchRemote = RS:WaitForChild("Msg", 10)
    and RS.Msg:WaitForChild("RemoteFunction", 10)
    and RS.Msg.RemoteFunction:WaitForChild("RemoteFunction", 10)
local TalkFunc = RS:WaitForChild("Msg", 10)
    and RS.Msg:WaitForChild("Function", 10)
    and RS.Msg.Function:WaitForChild("TalkFunc", 10)
local Connections = {}
local collectedThisSession = 0
local lastCollectTime = 0
local COLLECT_RATE = 0.15  
local function DoCollect()
    if not PickRemote then
        PickRemote = RS:WaitForChild("Msg", 3)
            and RS.Msg:WaitForChild("RemoteEvent", 3)
            and RS.Msg.RemoteEvent:WaitForChild("RemoteEvent", 3)
        if not PickRemote then return end
    end
    local DropsClient = workspace:FindFirstChild("DropsClient")
    if not DropsClient then return end
    for _, rarityFolder in ipairs(DropsClient:GetChildren()) do
        if rarityFolder:IsA("Model") or rarityFolder:IsA("Folder") then
            for _, itemModel in ipairs(rarityFolder:GetChildren()) do
                local elapsed = tick() - lastCollectTime
                if elapsed < COLLECT_RATE then
                    task.wait(COLLECT_RATE - elapsed)
                end
                local ok, pickErr = pcall(function()
                    PickRemote:FireServer("pick", itemModel.Name)
                end)
                lastCollectTime = tick()
                if ok then
                    collectedThisSession = collectedThisSession + 1
                end
                task.wait()
            end
        end
    end
    local Drops = workspace:FindFirstChild("Drops")
    if Drops then
        for _, playerFolder in ipairs(Drops:GetChildren()) do
            if playerFolder:IsA("Folder") then
                for _, dropValue in ipairs(playerFolder:GetChildren()) do
                    if dropValue:IsA("Vector3Value") then
                        local elapsed = tick() - lastCollectTime
                        if elapsed < COLLECT_RATE then
                            task.wait(COLLECT_RATE - elapsed)
                        end
                        local ok, pickErr = pcall(function()
                            PickRemote:FireServer("pick", dropValue.Name)
                        end)
                        lastCollectTime = tick()
                        if ok then
                            collectedThisSession = collectedThisSession + 1
                        end
                        task.wait()
                    end
                end
            end
        end
    end
end
local function AutoCollectLoop()
    while Toggles.AutoCollect.Value do
        DoCollect()
        task.wait(0.5)
    end
end
local HIT_NEAREST_RATE = 0.1
local SKILL_CD_FOLDER = "\230\138\128\232\131\189CD\230\151\182\233\151\180\230\136\179" 
local function IsNormalAtkReady()
    local cdFolder = Plr:FindFirstChild(SKILL_CD_FOLDER)
    if not cdFolder then return true end
    local slot4 = cdFolder:FindFirstChild("Slot4")
    if not slot4 then return true end
    return workspace:GetServerTimeNow() >= slot4.Value
end
local _AB_pendingBlocks = {}
local function _AB_QueueBlock(triggerPos, delay)
    local now = tick()
    table.insert(_AB_pendingBlocks, {
        triggerPos = triggerPos,
        fireAt     = now + (delay or 0),
        deadline   = now + 2,
    })
end
local _LOG_MONO  = Enum.Font.Code
local _LOG_SANS  = Enum.Font.GothamMedium
local _LOG_BOLD  = Enum.Font.GothamBold
local _LOG_GREEN = Color3.fromRGB(0,   200, 80)
local _LOG_RED   = Color3.fromRGB(255, 60,  60)
local _LOG_BLUE  = Color3.fromRGB(100, 140, 255)
local function _LogStroke(parent, overrideColor, thickness)
    local s = Library:Create("UIStroke", { Color=overrideColor or Library.OutlineColor, Thickness=thickness or 1, Parent=parent })
    if not overrideColor then Library:AddToRegistry(s, { Color="OutlineColor" }) end
    return s
end
local function _LogCorner(parent, radius)
    local c = Instance.new("UICorner"); c.CornerRadius=UDim.new(0,radius or 4); c.Parent=parent; return c
end
local function _LogPad(parent, px)
    local p = Instance.new("UIPadding")
    p.PaddingLeft=UDim.new(0,px); p.PaddingRight=UDim.new(0,px)
    p.PaddingTop=UDim.new(0,px);  p.PaddingBottom=UDim.new(0,px)
    p.Parent=parent; return p
end
local function _LogMakeDraggable(handle, target)
    local UIS = Services.UserInputService
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=target.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging=false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
end
local AnimLogger = {}
local function newUUID()
    return HttpService:GenerateGUID(false):lower()
end
local function _getBlockRemoteArgs()
    local char = GetCharacter()
    if not char then return nil end
    local hrp = char.HumanoidRootPart
    return {
        releaseCF        = hrp.CFrame,
        targetCF         = hrp.CFrame,
        moveDirectionStr = "Forward",
        characterType    = "Player",
        characterId      = Plr.UserId,
        clientPredictCastId = newUUID(),
    }
end
local function Block()
    if not SkillRemote then return end
    local args = _getBlockRemoteArgs()
    if not args then return end
    pcall(function()
        SkillRemote:FireServer(5, args)
    end)
end
local function AutoBlockLoop()
    local RS_HB = game:GetService("RunService").Heartbeat
    while Toggles.AutoBlock and Toggles.AutoBlock.Value do
        RS_HB:Wait()
        if not (Toggles.AutoBlock and Toggles.AutoBlock.Value) then break end
        local char = GetCharacter()
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local now = tick()
        local i = 1
        while i <= #_AB_pendingBlocks do
            local req = _AB_pendingBlocks[i]
            if now > req.deadline then
                table.remove(_AB_pendingBlocks, i)
                continue
            end
            if now >= req.fireAt then
                table.remove(_AB_pendingBlocks, i)
                Block()
                continue
            end
            i = i + 1
        end
    end
end
local function OpenViz(cfg)
    local guiParent = Library.ScreenGui
    local halfW, halfH = math.floor(cfg.winW/2), math.floor(cfg.winH/2)
    local zB = cfg.zBase
    local rootOuter = Library:Create("Frame", {
        Size=UDim2.new(0,cfg.winW,0,cfg.winH),
        Position=UDim2.new(0.5,-halfW,0.5,-halfH),
        BackgroundColor3=Color3.new(0,0,0), BorderSizePixel=0,
        Parent=guiParent, ZIndex=zB
    })
    local root = Library:Create("Frame", {
        BackgroundColor3=Library.BackgroundColor,
        BorderColor3=Library.AccentColor,
        BorderMode=Enum.BorderMode.Inset,
        Position=UDim2.new(0,1,0,1), Size=UDim2.new(1,-2,1,-2),
        ZIndex=zB, Parent=rootOuter
    })
    Library:AddToRegistry(root, { BackgroundColor3="BackgroundColor", BorderColor3="AccentColor" })
    local titleBar = Library:Create("Frame", {
        Size=UDim2.new(1,0,0,28), BackgroundColor3=Library.MainColor,
        BorderSizePixel=0, Parent=root, ZIndex=zB+1
    })
    Library:AddToRegistry(titleBar, { BackgroundColor3="MainColor" })
    _LogCorner(titleBar, 6)
    _LogMakeDraggable(titleBar, rootOuter)
    local titleLbl = Library:Create("TextLabel", {
        Size=UDim2.new(1,-36,1,0), BackgroundTransparency=1,
        Text=cfg.title, Font=_LOG_BOLD, TextSize=13,
        TextColor3=Library.FontColor, TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd, Parent=titleBar, ZIndex=zB+2
    })
    Library:AddToRegistry(titleLbl, { TextColor3="FontColor" })
    _LogPad(titleLbl, 8)
    local closeBtn = Library:Create("TextButton", {
        Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-28,0,0),
        BackgroundColor3=Color3.fromRGB(200,50,50), Text="X",
        Font=_LOG_BOLD, TextSize=12, TextColor3=Color3.new(1,1,1),
        BorderSizePixel=0, Parent=titleBar, ZIndex=zB+2, AutoButtonColor=false
    })
    _LogCorner(closeBtn, 4)
    closeBtn.MouseButton1Click:Connect(cfg.onClose)
    local subBar = Library:Create("TextLabel", {
        Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,28),
        BackgroundColor3=Library.MainColor, BorderSizePixel=0,
        Text=cfg.subtext, Font=_LOG_MONO, TextSize=12,
        TextColor3=Library.FontColor, TextXAlignment=Enum.TextXAlignment.Center,
        Parent=root, ZIndex=zB+1
    })
    Library:AddToRegistry(subBar, { BackgroundColor3="MainColor", TextColor3="FontColor" })
    local viewport = Library:Create("ViewportFrame", {
        Size=UDim2.new(0,cfg.vpW,0,cfg.vpH),
        Position=UDim2.new(0,cfg.vpX,0,cfg.vpY),
        BackgroundColor3=Color3.fromRGB(8,8,8), BorderSizePixel=0,
        Parent=root, ZIndex=zB+1,
        LightDirection=Vector3.new(-1,-1,-1),
        Ambient=Color3.fromRGB(180,180,180)
    })
    _LogCorner(viewport, 4); _LogStroke(viewport, nil, 1)
    local vpCamera = Instance.new("Camera"); vpCamera.Parent=viewport; viewport.CurrentCamera=vpCamera
    local vpWorld  = Instance.new("WorldModel"); vpWorld.Parent=viewport
    cfg.setupVp(viewport, vpWorld, vpCamera)
    local rotX, rotY = -0.15, 0
    local dist3D     = cfg.vpInitDist
    local dragging3D = false
    local lastPos3D  = Vector2.zero
    viewport.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging3D=true; lastPos3D=input.Position
        end
    end)
    viewport.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging3D=false
        end
    end)
    viewport.InputChanged:Connect(function(input)
        if dragging3D and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - lastPos3D; lastPos3D=input.Position
            rotY = rotY - delta.X*0.01
            rotX = math.clamp(rotX - delta.Y*0.01, -math.pi/2+0.05, math.pi/2-0.05)
        end
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            dist3D = math.clamp(dist3D - input.Position.Z*1.5, 1, 60)
        end
    end)
    if cfg.belowVp then cfg.belowVp(root, cfg.vpX, cfg.vpY, cfg.vpH, zB) end
    local rx     = cfg.vpX + cfg.vpW + 8
    local rightW = cfg.winW - 2 - rx - 8
    local editHeader = Library:Create("TextLabel", {
        Size=UDim2.new(0,rightW,0,22), Position=UDim2.new(0,rx,0,54),
        BackgroundTransparency=1, Text="Editor",
        Font=_LOG_BOLD, TextSize=13, TextColor3=Library.AccentColor,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=root, ZIndex=zB+1
    })
    Library:AddToRegistry(editHeader, { TextColor3="AccentColor" })
    local fieldH=26; local fieldGap=4; local startY=82
    local inputBoxes = {}
    for i, f in ipairs(cfg.fields) do
        local yOff = startY + (i-1)*(fieldH+fieldGap)
        local lbl = Library:Create("TextLabel", {
            Size=UDim2.new(0,90,0,fieldH), Position=UDim2.new(0,rx,0,yOff),
            BackgroundTransparency=1, Text=f.label, Font=_LOG_SANS,
            TextSize=12, TextColor3=Library.FontColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=root, ZIndex=zB+1
        })
        Library:AddToRegistry(lbl, { TextColor3="FontColor" })
        local outer = Library:Create("Frame", {
            Size=UDim2.new(0,rightW-94,0,fieldH-4),
            Position=UDim2.new(0,rx+92,0,yOff+1),
            BackgroundColor3=Color3.new(0,0,0), BorderSizePixel=0, Parent=root, ZIndex=zB+1
        })
        Library:AddToRegistry(outer, { BackgroundColor3="Black" })
        local box = Library:Create("TextBox", {
            Size=UDim2.new(1,-2,1,-2), Position=UDim2.new(0,1,0,1),
            BackgroundColor3=Library.MainColor,
            BorderColor3=Library.OutlineColor, BorderMode=Enum.BorderMode.Inset, BorderSizePixel=1,
            TextColor3=Library.FontColor, Font=_LOG_MONO, TextSize=13,
            Text=tostring(f.default), PlaceholderText="0",
            ClearTextOnFocus=false, Parent=outer, ZIndex=zB+2
        })
        Library:AddToRegistry(box, { BackgroundColor3="MainColor", TextColor3="FontColor", BorderColor3="OutlineColor" })
        box.Focused:Connect(function() box.BorderColor3 = Library.AccentColor end)
        box.FocusLost:Connect(function()
            box.BorderColor3 = Library.OutlineColor
            if not tonumber(box.Text) then box.Text = tostring(f.default) end
        end)
        inputBoxes[f.key] = box
    end
    local saveBtn = Library:Create("TextButton", {
        Size=UDim2.new(0,rightW,0,30),
        Position=UDim2.new(0,rx,0,startY + #cfg.fields*(fieldH+fieldGap)+4),
        BackgroundColor3=Library.AccentColor, Text="Save",
        Font=_LOG_BOLD, TextSize=13, TextColor3=Library.BackgroundColor,
        BorderSizePixel=0, Parent=root, ZIndex=zB+1, AutoButtonColor=false
    })
    Library:AddToRegistry(saveBtn, { BackgroundColor3="AccentColor", TextColor3="BackgroundColor" })
    _LogCorner(saveBtn, 5)
    saveBtn.MouseEnter:Connect(function() saveBtn.BackgroundColor3 = Library:GetBetterColor(Library.AccentColor, 20) end)
    saveBtn.MouseLeave:Connect(function() saveBtn.BackgroundColor3 = Library.AccentColor end)
    saveBtn.MouseButton1Click:Connect(function()
        local values = {}
        for _, f in ipairs(cfg.fields) do
            values[f.key] = tonumber(inputBoxes[f.key].Text) or f.default
        end
        cfg.onSave(values)
        local orig = saveBtn.BackgroundColor3; saveBtn.BackgroundColor3 = _LOG_GREEN
        task.delay(0.4, function() if saveBtn and saveBtn.Parent then saveBtn.BackgroundColor3 = orig end end)
    end)
    local renderConn = RunService.RenderStepped:Connect(function(dt)
        if vpCamera and vpCamera.Parent then
            if not dragging3D then rotY = rotY + 0.008*dt*60 end
            local center   = cfg.vpCamCenter
            local rotation = CFrame.Angles(0,rotY,0) * CFrame.Angles(rotX,0,0)
            vpCamera.CFrame = CFrame.lookAt((CFrame.new(center)*rotation*CFrame.new(0,0,dist3D)).Position, center)
        end
        if cfg.renderHook then cfg.renderHook(dt, vpCamera, dragging3D) end
    end)
    return rootOuter, renderConn, inputBoxes
end
do
    local _AL_Logger = { Frame=nil, ScrollFrame=nil, CountLabel=nil, RowCount=0 }
    local _AL_Viz    = { Frame=nil, Open=false, CurrentId=nil, ScrubConn=nil, AnimTrack=nil, Animator=nil, PlayConn=nil, InputBoxes={}, Timing={} }
    local _AL_knownIds   = {}
    local _AL_timingData = {}
    local _AL_logEntries = {}
    local _AL_entryRows  = {}
    local _AL_maxLogDist = 0  
    function AnimLogger.SetTimingData(id, t) _AL_timingData[id] = t end
    function AnimLogger.GetTimingData(id)    return _AL_timingData[id] end
    function AnimLogger.SetMaxDist(d)        _AL_maxLogDist = (tonumber(d) or 0) end
    local function _AL_DefaultTiming()
        return { Delay=0, HitboxX=0, HitboxY=0, HitboxZ=0,MaxDist=0 }
    end
    local ALSP = "Yuri/WizardAlchemy/AnimLog.json"
    local function _AL_SaveTimingFile()
        if not Support.FileIO then return end
        pcall(function()
            local encoded = HttpService:JSONEncode(_AL_timingData)
            writefile(ALSP, encoded)
        end)
    end
    local function _AL_LoadTimingFile()
        if not Support.FileIO then return end
        pcall(function()
            if isfile(ALSP) then
                local raw = readfile(ALSP)
                local decoded = HttpService:JSONDecode(raw)
                if type(decoded) == "table" then
                    for id, t in pairs(decoded) do
                        _AL_timingData[id] = t
                    end
                end
            end
        end)
    end
    _AL_LoadTimingFile()
    local _AL_CloseVisualizer
    _AL_CloseVisualizer = function()
        if _AL_Viz.ScrubConn then _AL_Viz.ScrubConn:Disconnect(); _AL_Viz.ScrubConn=nil end
        if _AL_Viz.PlayConn  then _AL_Viz.PlayConn:Disconnect();  _AL_Viz.PlayConn=nil  end
        if _AL_Viz.AnimTrack then pcall(function() _AL_Viz.AnimTrack:Stop() end); _AL_Viz.AnimTrack=nil end
        if _AL_Viz.Frame     then _AL_Viz.Frame:Destroy(); _AL_Viz.Frame=nil end
        _AL_Viz.Open=false
    end
    local function _AL_OpenVisualizer(entry)
        if _AL_Viz.Open then _AL_CloseVisualizer() end
        _AL_Viz.Open=true; _AL_Viz.CurrentId=entry.id; _AL_Viz.Timing={}
        local stored = _AL_timingData[entry.id] or _AL_DefaultTiming()
        for k,v in pairs(stored) do _AL_Viz.Timing[k]=v end
        local vpChar, vpCamCenter, vpInitDist = nil, Vector3.new(0,3,0), 8
        local function setupVp(viewport, vpWorld, vpCamera)
            pcall(function()
                local srcChar = Plr.Character
                local srcHRP  = srcChar and srcChar:FindFirstChild("HumanoidRootPart")
                if not srcChar or not srcHRP then return end
                vpWorld.Parent = viewport
                vpChar = Instance.new("Model"); vpChar.Name="AnimDummy"
                local R6_PARTS = {"HumanoidRootPart","Torso","Head","Left Arm","Right Arm","Left Leg","Right Leg"}
                local partMap = {}
                for _, name in ipairs(R6_PARTS) do
                    local src = srcChar:FindFirstChild(name)
                    if src and src:IsA("BasePart") then
                        local p = Instance.new("Part")
                        p.Name=name; p.Size=src.Size; p.CFrame=src.CFrame
                        p.Anchored=false; p.CanCollide=false
                        p.Transparency=(name=="HumanoidRootPart") and 1 or 0
                        p.BrickColor=src.BrickColor; p.Material=Enum.Material.SmoothPlastic
                        p.Velocity=Vector3.zero; p.RotVelocity=Vector3.zero
                        p.Parent=vpChar; partMap[name]=p
                        if name=="Head" then
                            local mesh=Instance.new("SpecialMesh")
                            mesh.MeshType=Enum.MeshType.Head; mesh.Scale=Vector3.new(1.25,1.25,1.25); mesh.Parent=p
                        end
                    end
                end
                local JOINT_PARENTS = {
                    RootJoint="HumanoidRootPart", Neck="Torso",
                    ["Left Shoulder"]="Torso",["Right Shoulder"]="Torso",
                    ["Left Hip"]="Torso",["Right Hip"]="Torso",
                }
                for jointName, parentPartName in pairs(JOINT_PARENTS) do
                    local srcParent = srcChar:FindFirstChild(parentPartName)
                    local srcJoint  = srcParent and srcParent:FindFirstChild(jointName)
                    local dstParent = partMap[parentPartName]
                    local dstPart1  = srcJoint and partMap[srcJoint.Part1 and srcJoint.Part1.Name]
                    if srcJoint and dstParent and dstPart1 then
                        local m=Instance.new("Motor6D")
                        m.Name=jointName; m.Part0=dstParent; m.Part1=dstPart1
                        m.C0=srcJoint.C0; m.C1=srcJoint.C1; m.Parent=dstParent
                    end
                end
                local newHRP = partMap["HumanoidRootPart"]
                if newHRP then
                    local delta = CFrame.new(0,3,0)*newHRP.CFrame:Inverse()
                    for _, p in ipairs(vpChar:GetDescendants()) do
                        if p:IsA("BasePart") then p.CFrame=delta*p.CFrame end
                    end
                end
                local hum=Instance.new("Humanoid")
                hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
                hum.AutoRotate=false; hum.Parent=vpChar
                vpChar.PrimaryPart=newHRP; vpChar.Parent=vpWorld
            end)
            if vpChar then
                local hum = vpChar:FindFirstChildOfClass("Humanoid")
                if hum then
                    local freshAnimator = Instance.new("Animator", hum)
                    _AL_Viz.Animator = freshAnimator
                    local animObj = Instance.new("Animation")
                    animObj.AnimationId = "rbxassetid://"..entry.id
                    pcall(function()
                        _AL_Viz.AnimTrack = freshAnimator:LoadAnimation(animObj)
                        _AL_Viz.AnimTrack.Looped = true
                        _AL_Viz.AnimTrack:Play()
                    end)
                end
            end
            vpCamera.CFrame = CFrame.new(vpCamCenter + Vector3.new(0,0,vpInitDist), vpCamCenter)
        end
        local vpW, vpH, vpX = 200, 200, 8
        local scrubFill, scrubBg, scrubHead, timeLabel, isPlaying, playBtn
        local function belowVp(root, vpX, vpY, vpH, zB)
            isPlaying = true
            local scrubY = vpY + vpH + 6
            playBtn = Library:Create("TextButton", {
                Size=UDim2.new(0,52,0,20), Position=UDim2.new(0,vpX+vpW/2-26,0,scrubY),
                BackgroundColor3=Library.MainColor, Text="▐▐", Font=_LOG_MONO,
                TextSize=12, TextColor3=Library.FontColor,
                BorderSizePixel=0, Parent=root, ZIndex=zB+1, AutoButtonColor=false
            })
            Library:AddToRegistry(playBtn, { BackgroundColor3="MainColor", TextColor3="FontColor" })
            _LogCorner(playBtn,4); _LogStroke(playBtn, nil, 1)
            playBtn.MouseButton1Click:Connect(function()
                if not _AL_Viz.AnimTrack then return end
                if isPlaying then pcall(function() _AL_Viz.AnimTrack:AdjustSpeed(0) end); playBtn.Text="▶"; isPlaying=false
                else pcall(function() _AL_Viz.AnimTrack:AdjustSpeed(1) end); playBtn.Text="▐▐"; isPlaying=true end
            end)
            scrubBg = Library:Create("Frame", {
                Size=UDim2.new(0,vpW,0,8), Position=UDim2.new(0,vpX,0,scrubY+26),
                BackgroundColor3=Library.OutlineColor, BorderSizePixel=0,
                Parent=root, ZIndex=zB+1, ClipsDescendants=false
            })
            Library:AddToRegistry(scrubBg, { BackgroundColor3="OutlineColor" })
            _LogCorner(scrubBg, 3)
            scrubFill = Library:Create("Frame", {
                Size=UDim2.new(0,0,1,0), BackgroundColor3=Library.AccentColor,
                BorderSizePixel=0, Parent=scrubBg, ZIndex=zB+2
            })
            Library:AddToRegistry(scrubFill, { BackgroundColor3="AccentColor" })
            scrubHead = Library:Create("Frame", {
                Size=UDim2.new(0,10,0,10), Position=UDim2.new(0,-5,0,0),
                BackgroundColor3=Library.FontColor, BorderSizePixel=0,
                Parent=scrubBg, ZIndex=zB+3
            })
            Library:AddToRegistry(scrubHead, { BackgroundColor3="FontColor" })
            _LogCorner(scrubHead, 5)
            timeLabel = Library:Create("TextLabel", {
                Size=UDim2.new(0,vpW,0,14), Position=UDim2.new(0,vpX,0,scrubY+38),
                BackgroundTransparency=1, Font=_LOG_MONO, TextSize=11,
                TextColor3=Library.FontColor, TextXAlignment=Enum.TextXAlignment.Center,
                Text="0.000 / 0.000 (0ms)", Parent=root, ZIndex=zB+1
            })
            Library:AddToRegistry(timeLabel, { TextColor3="FontColor" })
            local parryLabel = Library:Create("TextLabel", {
                Size=UDim2.new(0,vpW,0,0), Position=UDim2.new(0,vpX,0,scrubY+54),
                BackgroundTransparency=1, Font=_LOG_MONO, TextSize=10,
                TextColor3=Library.FontColor, TextXAlignment=Enum.TextXAlignment.Left,
                TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y,
                Text="Not in list", Parent=root, ZIndex=zB+1
            })
            Library:AddToRegistry(parryLabel, { TextColor3="FontColor" })
            local td = _AL_timingData[entry.id]
            if td then
                parryLabel.Text = string.format("Dly:%.3f  X:%.1f Y:%.1f Z:%.1f  MD:%d",
                    td.Delay or 0, td.HitboxX or 0, td.HitboxY or 0, td.HitboxZ or 0, td.MaxDist or 0)
                parryLabel.TextColor3 = _LOG_GREEN
            end
            local function scrubToX(screenX)
                local rel = math.clamp((screenX - scrubBg.AbsolutePosition.X)/scrubBg.AbsoluteSize.X, 0, 1)
                if _AL_Viz.AnimTrack and _AL_Viz.AnimTrack.Length > 0 then
                    pcall(function() _AL_Viz.AnimTrack.TimePosition = rel*_AL_Viz.AnimTrack.Length end)
                end
            end
            scrubBg.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local wasPlaying = isPlaying
                if isPlaying then pcall(function() _AL_Viz.AnimTrack:AdjustSpeed(0) end); isPlaying=false; playBtn.Text="▶" end
                scrubToX(input.Position.X)
                while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    scrubToX(UIS:GetMouseLocation().X); RunService.RenderStepped:Wait()
                end
                if wasPlaying then pcall(function() _AL_Viz.AnimTrack:AdjustSpeed(1) end); isPlaying=true; playBtn.Text="▐▐" end
            end)
        end
        local fields = {
            {label="Delay (s):",  key="Delay",   default=_AL_Viz.Timing.Delay   or 0},
            {label="Hitbox X:",   key="HitboxX",  default=_AL_Viz.Timing.HitboxX or 0},
            {label="Hitbox Y:",   key="HitboxY",  default=_AL_Viz.Timing.HitboxY or 0},
            {label="Hitbox Z:",   key="HitboxZ",  default=_AL_Viz.Timing.HitboxZ or 0},
            {label="Max Dist:",   key="MaxDist",  default=_AL_Viz.Timing.MaxDist  or 0},
        }
        local frame, renderConn, inputBoxes = OpenViz({
            title      = "Animation Visualizer",
            subtext    = "rbxassetid://"..entry.id,
            winW=440, winH=340, vpW=vpW, vpH=vpH, vpX=vpX, vpY=54,
            vpCamCenter=vpCamCenter, vpInitDist=vpInitDist,
            zBase=20, onClose=_AL_CloseVisualizer,
            setupVp=setupVp, belowVp=belowVp,
            fields=fields,
            onSave=function(values)
                _AL_Viz.Timing = values
                _AL_timingData[entry.id] = {}
                for k,v in pairs(values) do _AL_timingData[entry.id][k]=v end
                _AL_SaveTimingFile()
            end,
            renderHook=function(dt, vpCamera, dragging3D)
                if not _AL_Viz.AnimTrack or not scrubBg then return end
                local len=_AL_Viz.AnimTrack.Length; local pos=_AL_Viz.AnimTrack.TimePosition
                local pct=(len>0) and (pos/len) or 0
                scrubFill.Size=UDim2.new(pct,0,1,0)
                scrubHead.Position=UDim2.new(0,pct*scrubBg.AbsoluteSize.X-5,0,0)
                timeLabel.Text=string.format("%.3f / %.3f (%dms)",pos,len,math.floor(pos*1000))
                if isPlaying and pos>=len and len>0 then
                    pcall(function() _AL_Viz.AnimTrack:Stop(0); _AL_Viz.AnimTrack:Play(0) end)
                end
            end,
        })
        _AL_Viz.Frame     = frame
        _AL_Viz.ScrubConn = renderConn
        _AL_Viz.InputBoxes = inputBoxes
    end
    local function _AL_BuildLoggerGui()
        _AL_knownIds   = {}
        _AL_logEntries = {}
        _AL_entryRows  = {}
        _AL_Logger.RowCount = 0
        local guiParent = Library.ScreenGui
        local winOuter = Library:Create("Frame", {
            Name="LogWindow", Size=UDim2.new(0,384,0,238),
            Position=UDim2.new(0.5,-192,0.1,0),
            BackgroundColor3=Color3.new(0,0,0), BorderSizePixel=0, Parent=guiParent
        })
        local win = Library:Create("Frame", {
            Name="LogWindowInner",
            BackgroundColor3=Library.BackgroundColor,
            BorderColor3=Library.AccentColor,
            BorderMode=Enum.BorderMode.Inset,
            Position=UDim2.new(0,1,0,1),
            Size=UDim2.new(1,-2,1,-2),
            Parent=winOuter
        })
        Library:AddToRegistry(win, { BackgroundColor3="BackgroundColor", BorderColor3="AccentColor" })
        local titleBar = Library:Create("Frame", {
            Size=UDim2.new(1,0,0,26), BackgroundColor3=Library.MainColor,
            BorderSizePixel=0, Parent=win
        })
        Library:AddToRegistry(titleBar, { BackgroundColor3="MainColor" })
        _LogMakeDraggable(titleBar, winOuter)
        local titleLbl = Library:Create("TextLabel", {
            Size=UDim2.new(0,130,1,0), BackgroundTransparency=1, Text="Info Logger",
            Font=_LOG_BOLD, TextSize=13, TextColor3=Library.AccentColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=titleBar
        })
        Library:AddToRegistry(titleLbl, { TextColor3="AccentColor" })
        _LogPad(titleLbl, 10)
        _AL_Logger.CountLabel = Library:Create("TextLabel", {
            Size=UDim2.new(0,120,1,0), Position=UDim2.new(0,130,0,0),
            BackgroundTransparency=1, Text="0 entries.", Font=_LOG_SANS,
            TextSize=11, TextColor3=Library.FontColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=titleBar
        })
        Library:AddToRegistry(_AL_Logger.CountLabel, { TextColor3="FontColor" })
        local clearBtn = Library:Create("TextButton", {
            Size=UDim2.new(0,52,0,18), Position=UDim2.new(1,-116,0,4),
            BackgroundColor3=Library.MainColor, Text="Clear",
            Font=_LOG_BOLD, TextSize=11, TextColor3=Library.FontColor,
            BorderSizePixel=0, Parent=titleBar, AutoButtonColor=false
        })
        Library:AddToRegistry(clearBtn, { BackgroundColor3="MainColor", TextColor3="FontColor" })
        _LogCorner(clearBtn,3); _LogStroke(clearBtn, nil, 1)
        clearBtn.MouseEnter:Connect(function() clearBtn.BackgroundColor3 = Library.BackgroundColor end)
        clearBtn.MouseLeave:Connect(function() clearBtn.BackgroundColor3 = Library.MainColor end)
        clearBtn.MouseButton1Click:Connect(function()
            _AL_logEntries={}; _AL_entryRows={}; _AL_knownIds={}; _AL_Logger.RowCount=0
            for _,c in ipairs(_AL_Logger.ScrollFrame:GetChildren()) do
                if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
            end
            _AL_Logger.ScrollFrame.CanvasSize=UDim2.new(0,0,0,0)
            _AL_Logger.CountLabel.Text="0 entries."
            _AL_CloseVisualizer()
        end)
        local restoreBtn = Library:Create("TextButton", {
            Name="LogRestoreBtn",
            Size=UDim2.new(0,28,0,22),
            Position=winOuter.Position,
            BackgroundColor3=Library.MainColor,
            Text="Open", Font=_LOG_BOLD, TextSize=10,
            TextColor3=Library.AccentColor,
            BorderSizePixel=0, Visible=false, Parent=guiParent, AutoButtonColor=false
        })
        Library:AddToRegistry(restoreBtn, { BackgroundColor3="MainColor", TextColor3="AccentColor" })
        _LogCorner(restoreBtn, 3); _LogStroke(restoreBtn, nil, 1)
        _LogMakeDraggable(restoreBtn, restoreBtn)
        local minBtn = Library:Create("TextButton", {
            Size=UDim2.new(0,24,0,18), Position=UDim2.new(1,-58,0,4),
            BackgroundColor3=Library.MainColor, Text="-",
            Font=_LOG_BOLD, TextSize=13, TextColor3=Library.FontColor,
            BorderSizePixel=0, Parent=titleBar, AutoButtonColor=false
        })
        Library:AddToRegistry(minBtn, { BackgroundColor3="MainColor", TextColor3="FontColor" })
        _LogCorner(minBtn,3); _LogStroke(minBtn, nil, 1)
        minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = Library.BackgroundColor end)
        minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = Library.MainColor end)
        minBtn.MouseButton1Down:Connect(function()
            restoreBtn.Position = winOuter.Position
            winOuter.Visible  = false
            restoreBtn.Visible = true
        end)
        restoreBtn.MouseButton1Down:Connect(function()
            winOuter.Position = restoreBtn.Position
            restoreBtn.Visible = false
            winOuter.Visible  = true
        end)
        local xBtn = Library:Create("TextButton", {
            Size=UDim2.new(0,24,0,18), Position=UDim2.new(1,-28,0,4),
            BackgroundColor3=Color3.fromRGB(180,50,50), Text="X",
            Font=_LOG_BOLD, TextSize=11, TextColor3=Color3.new(1,1,1),
            BorderSizePixel=0, Parent=titleBar, AutoButtonColor=false
        })
        _LogCorner(xBtn,3)
        xBtn.MouseButton1Click:Connect(function()
            AnimLogger.StopTracking()
            _AL_CloseVisualizer()
            winOuter:Destroy()
            pcall(function() restoreBtn:Destroy() end)
            _AL_Logger.ScrollFrame = nil
            _AL_Logger.CountLabel  = nil
            _AL_Logger.RowCount    = 0
            _AL_Logger.Frame = nil
        end)
        local COLS = {
            {text="Time",      w=52 },
            {text="ID",        w=118},
            {text="Enemy",     w=76 },
            {text="Dist",      w=50 },
            {text="Status",    w=80 },
        }
        local headerRow = Library:Create("Frame", {
            Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,26),
            BackgroundColor3=Library.MainColor, BorderSizePixel=0, Parent=win
        })
        Library:AddToRegistry(headerRow, { BackgroundColor3="MainColor" })
        local hAccent = Library:Create("Frame", {
            Size=UDim2.new(0,3,1,0), Position=UDim2.new(0,0,0,0),
            BackgroundColor3=Library.AccentColor, BorderSizePixel=0, Parent=headerRow
        })
        Library:AddToRegistry(hAccent, { BackgroundColor3="AccentColor" })
        local hx=3
        for _,col in ipairs(COLS) do
            local hLbl = Library:Create("TextLabel", {
                Size=UDim2.new(0,col.w,1,0), Position=UDim2.new(0,hx,0,0),
                BackgroundTransparency=1, Text=col.text,
                Font=_LOG_BOLD, TextSize=11, TextColor3=Library.AccentColor,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=headerRow
            })
            Library:AddToRegistry(hLbl, { TextColor3="AccentColor" })
            _LogPad(hLbl, 6)
            hx = hx + col.w
        end
        local scroll = Library:Create("ScrollingFrame", {
            Size=UDim2.new(1,0,1,-46), Position=UDim2.new(0,0,0,46),
            BackgroundColor3=Library.BackgroundColor, BorderSizePixel=0,
            ScrollBarThickness=3, ScrollBarImageColor3=Library.OutlineColor,
            CanvasSize=UDim2.new(0,0,0,0), Parent=win,
            ElasticBehavior=Enum.ElasticBehavior.Never
        })
        Library:AddToRegistry(scroll, {
            BackgroundColor3="BackgroundColor",
            ScrollBarImageColor3="OutlineColor"
        })
        _AL_Logger.ScrollFrame = scroll
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding   = UDim.new(0,0)
        layout.Parent    = scroll
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
        end)
        return win, COLS
    end
    local function _AL_AddRow(entry)
        if not _AL_Logger.ScrollFrame then return end
        if _AL_knownIds[entry.id] then return end
        _AL_knownIds[entry.id] = true
        _AL_Logger.RowCount = _AL_Logger.RowCount + 1
        local isNew   = not _AL_timingData[entry.id]  
        local rowH    = 22
        local isEven  = (_AL_Logger.RowCount % 2 == 0)
        local rowBgKey = isEven and "BackgroundColor" or "MainColor"
        local rowBg    = isEven and Library.BackgroundColor or Library.MainColor
        local row = Library:Create("TextButton", {
            Name="Row_".._AL_Logger.RowCount, Size=UDim2.new(1,0,0,rowH),
            BackgroundColor3=rowBg, Text="", BorderSizePixel=0,
            LayoutOrder=_AL_Logger.RowCount, AutoButtonColor=false,
            Parent=_AL_Logger.ScrollFrame
        })
        Library:AddToRegistry(row, { BackgroundColor3=rowBgKey })
        row.MouseEnter:Connect(function() row.BackgroundColor3 = Library:GetBetterColor(rowBg, 15) end)
        row.MouseLeave:Connect(function() row.BackgroundColor3 = rowBg end)
        row.MouseButton1Click:Connect(function() _AL_OpenVisualizer(entry) end)
        local stripColor = isNew and _LOG_RED or Library.AccentColor
        local strip = Library:Create("Frame", {
            Size=UDim2.new(0,3,1,0), Position=UDim2.new(0,0,0,0),
            BackgroundColor3=stripColor, BorderSizePixel=0, Parent=row
        })
        if not isNew then
            Library:AddToRegistry(strip, { BackgroundColor3="AccentColor" })
        end
        local sep = Library:Create("Frame", {
            Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
            BackgroundColor3=Library.OutlineColor, BorderSizePixel=0, Parent=row
        })
        Library:AddToRegistry(sep, { BackgroundColor3="OutlineColor" })
        local xOff   = 3
        local timeStr = os.date("%H:%M:%S"):sub(1,5)
        local timeCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,52,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=timeStr, Font=_LOG_MONO,
            TextSize=10, TextColor3=Library.FontColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
        Library:AddToRegistry(timeCell, { TextColor3="FontColor" })
        _LogPad(timeCell, 6)
        xOff = xOff + 52
        local idCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,118,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=tostring(entry.id), Font=_LOG_MONO,
            TextSize=10, TextColor3=_LOG_BLUE,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
        _LogPad(idCell, 6)
        xOff = xOff + 118
        local npcShort = entry.name
        if #npcShort > 9 then npcShort = npcShort:sub(1,8).."…" end
        local enemyCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,76,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=npcShort, Font=_LOG_SANS,
            TextSize=10, TextColor3=Library.FontColor,
            TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=false, Parent=row
        })
        Library:AddToRegistry(enemyCell, { TextColor3="FontColor" })
        _LogPad(enemyCell, 6)
        xOff = xOff + 76
        local distCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,50,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=tostring(entry.dist or 0), Font=_LOG_MONO,
            TextSize=10, TextColor3=Library.FontColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
        Library:AddToRegistry(distCell, { TextColor3="FontColor" })
        _LogPad(distCell, 6)
        xOff = xOff + 50
        local statusColor = isNew and _LOG_RED or _LOG_GREEN
        local statusText  = isNew and "NEW" or "KNOWN"
        local statusCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,80,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=statusText, Font=_LOG_BOLD,
            TextSize=10, TextColor3=statusColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
        _LogPad(statusCell, 6)
        table.insert(_AL_logEntries, entry)
        _AL_Logger.CountLabel.Text = #_AL_logEntries.." entries."
        _AL_Logger.ScrollFrame.CanvasPosition = Vector2.new(
            0, math.max(0, _AL_Logger.ScrollFrame.AbsoluteCanvasSize.Y - _AL_Logger.ScrollFrame.AbsoluteSize.Y)
        )
        _AL_entryRows[entry.id] = row
    end
    function AnimLogger.Log(animTrack, enemyName, distance, monsterModel)
        local anim=animTrack and animTrack.Animation; if not anim then return end
        local rawId=anim.AnimationId or ""; local numId=rawId:match("%d+") or "0"
        local name=enemyName or "Unknown"; local dist=distance or 0
        local animName = name
        if _AL_maxLogDist > 0 and dist > _AL_maxLogDist then return end
        if not _AL_Logger.ScrollFrame or not _AL_Logger.ScrollFrame.Parent then _AL_BuildLoggerGui() end
        _AL_AddRow({ id=numId, name=name, animName=animName, dist=math.floor(dist), model=monsterModel })
    end
    local _AL_monsterAnimConns = {}
    local _AL_trackedMonsters  = {}
    local _AL_monsterFolderConns = {}
    local function _AL_onMonsterAnimPlayed(monsterModel, track)
        local anim = track and track.Animation
        if not anim then return end
        local char = GetCharacter()
        local hrp  = char and char.HumanoidRootPart
        local rootPart = monsterModel:FindFirstChild("Root") or monsterModel:FindFirstChild("HumanoidRootPart")
        local dist = (hrp and rootPart) and (hrp.Position - rootPart.Position).Magnitude or 0
        AnimLogger.Log(track, monsterModel.Name, dist, monsterModel)
    end
    local function _AL_trackMonster(model)
        if _AL_trackedMonsters[model] then return end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        _AL_trackedMonsters[model] = true
        _AL_monsterAnimConns[model] = hum.AnimationPlayed:Connect(function(track)
            _AL_onMonsterAnimPlayed(model, track)
        end)
    end
    local function _AL_untrackMonster(model)
        if _AL_monsterAnimConns[model] then
            _AL_monsterAnimConns[model]:Disconnect()
            _AL_monsterAnimConns[model] = nil
        end
        _AL_trackedMonsters[model] = nil
    end
    function AnimLogger.StartTracking()
        local monsterFolder = workspace:FindFirstChild("Monster")
        if not monsterFolder then return end
        for _, model in ipairs(monsterFolder:GetChildren()) do
            if model:IsA("Model") then _AL_trackMonster(model) end
        end
        _AL_monsterFolderConns[1] = monsterFolder.ChildAdded:Connect(function(child)
            if child:IsA("Model") then task.wait(); _AL_trackMonster(child) end
        end)
        _AL_monsterFolderConns[2] = monsterFolder.ChildRemoved:Connect(function(child)
            _AL_untrackMonster(child)
        end)
    end
    function AnimLogger.StopTracking()
        for _, conn in pairs(_AL_monsterFolderConns) do conn:Disconnect() end
        _AL_monsterFolderConns = {}
        for model, conn in pairs(_AL_monsterAnimConns) do conn:Disconnect() end
        _AL_monsterAnimConns = {}
        _AL_trackedMonsters  = {}
    end
    function AnimLogger.Open()
        if not _AL_Logger.ScrollFrame or not _AL_Logger.ScrollFrame.Parent then _AL_BuildLoggerGui() end
        AnimLogger.StartTracking()
    end
    function AnimLogger.Close()
        AnimLogger.StopTracking()
        _AL_CloseVisualizer()
        if _AL_Logger.ScrollFrame then
            local inner = _AL_Logger.ScrollFrame.Parent
            local outerWin = inner and inner.Parent
            if outerWin and outerWin.Name == "LogWindow" then outerWin:Destroy()
            elseif inner and inner.Name == "LogWindow" then inner:Destroy() end
            _AL_Logger.ScrollFrame = nil
            _AL_Logger.CountLabel  = nil
            _AL_Logger.RowCount    = 0
            _AL_Logger.Frame       = nil
        end
    end
end
local currentFarmTarget   = nil
local activeFarmTween     = nil
local function _AB_isFarmTarget(model)
    if not (Toggles.AutoFarm and Toggles.AutoFarm.Value) then return true end
    return currentFarmTarget == nil or currentFarmTarget == model
end
local EffectLogger = {}
do
    local _EL_pending = {}
    local _EL_Logger      = { Frame=nil, ScrollFrame=nil, CountLabel=nil, RowCount=0 }
    local _EL_Viz         = { Frame=nil, Open=false, RenderConn=nil }
    local _EL_conns       = {}
    local _EL_maxLogDist  = 0
    local _EL_cloneStore  = {}
    local _EL_targets     = {
        workspace:WaitForChild("Debris", 10),
    }
    local _EL_effectData  = {}
    local _EL_EFFECT_FILE = "Yuri/WizardAlchemy/EffectLog.json"
    local function _EL_LoadEffectFile()
        local ok, raw = pcall(readfile, _EL_EFFECT_FILE)
        if ok and raw and #raw > 0 then
            local ok2, tbl = pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
            if ok2 and type(tbl) == "table" then _EL_effectData = tbl end
        end
    end
    local function _EL_SaveEffectFile()
        pcall(writefile, _EL_EFFECT_FILE, game:GetService("HttpService"):JSONEncode(_EL_effectData))
    end
    _EL_LoadEffectFile()
    local _EL_CloseViz
    _EL_CloseViz = function()
        if _EL_Viz.RenderConn then _EL_Viz.RenderConn:Disconnect(); _EL_Viz.RenderConn=nil end
        if _EL_Viz.Frame       then _EL_Viz.Frame:Destroy();        _EL_Viz.Frame=nil       end
        _EL_Viz.Open = false
    end
    local function _EL_OpenViz(entry)
        if _EL_Viz.Open then _EL_CloseViz() end
        _EL_Viz.Open = true
        local camDist = 6
        local function setupVp(viewport, vpWorld, vpCamera)
            local displayObj = nil
            pcall(function()
                local modelRes = game:GetService("ReplicatedStorage"):FindFirstChild("ModelRes")
                if not modelRes then return end
                for _, folder in ipairs(modelRes:GetChildren()) do
                    local template = folder:FindFirstChild(entry.effectName)
                    if template then displayObj = template:Clone(); return end
                end
            end)
            if not displayObj then
                local cloneRoot = entry.snapshot
                if cloneRoot and cloneRoot.Parent ~= nil then
                    pcall(function() displayObj = cloneRoot:Clone() end)
                else
                    local stored = entry.storedClone or _EL_cloneStore[entry.rowKey]
                    if stored then pcall(function() displayObj = stored:Clone() end) end
                end
            end
            if displayObj then
                for _, d in ipairs(displayObj:GetDescendants()) do
                    if d:IsA("BasePart") then d.Anchored=true; d.CanCollide=false end
                end
                if displayObj:IsA("BasePart") then displayObj.Anchored=true; displayObj.CanCollide=false end
                local function getBoundingCF(obj)
                    local parts = {}
                    if obj:IsA("BasePart") then table.insert(parts, obj) end
                    for _, d in ipairs(obj:GetDescendants()) do
                        if d:IsA("BasePart") then table.insert(parts, d) end
                    end
                    if #parts == 0 then return CFrame.new(0,0,0), 2 end
                    local minP, maxP = parts[1].Position, parts[1].Position
                    for _, p in ipairs(parts) do
                        minP = Vector3.new(math.min(minP.X,p.Position.X-p.Size.X/2), math.min(minP.Y,p.Position.Y-p.Size.Y/2), math.min(minP.Z,p.Position.Z-p.Size.Z/2))
                        maxP = Vector3.new(math.max(maxP.X,p.Position.X+p.Size.X/2), math.max(maxP.Y,p.Position.Y+p.Size.Y/2), math.max(maxP.Z,p.Position.Z+p.Size.Z/2))
                    end
                    return CFrame.new((minP+maxP)/2), math.max((maxP-minP).Magnitude/2, 0.5)
                end
                local objCF, radius = getBoundingCF(displayObj)
                camDist = math.clamp(radius*3.5, 2, 40)
                local offset = CFrame.new(0,0,0)*objCF:Inverse()
                if displayObj:IsA("BasePart") then
                    displayObj.CFrame = offset*displayObj.CFrame
                else
                    for _, d in ipairs(displayObj:GetDescendants()) do
                        if d:IsA("BasePart") then d.CFrame = offset*d.CFrame end
                    end
                end
                displayObj.Parent = vpWorld
            end
        end
        local existing = _EL_effectData[entry.effectName] or {}
        local fields = {
            {label="Dist:",    key="Dist",  default=existing.Dist  or 0},
            {label="Delay (s):", key="Delay", default=existing.Delay or 0 },
        }
        local frame, renderConn = OpenViz({
            title      = "Effect Visualizer: " .. entry.effectName,
            subtext    = entry.className .. "  •  by " .. entry.ownerName,
            winW=440, winH=340, vpW=200, vpH=200, vpX=8, vpY=54,
            vpCamCenter=Vector3.new(0,0,0), vpInitDist=camDist,
            zBase=30, onClose=_EL_CloseViz,
            setupVp=setupVp,
            fields=fields,
            onSave=function(values)
                EffectLogger.SetEffect(entry.effectName, values.Dist, values.Delay)
            end,
        })
        _EL_Viz.Frame      = frame
        _EL_Viz.RenderConn = renderConn
    end
    local function _EL_BuildGui()
        _EL_Logger.RowCount = 0
        local guiParent = Library.ScreenGui
        local _EL_WinName      = newUUID()
        local _EL_WinInnerName = newUUID()
        local _EL_RestoreName  = newUUID()
        local winOuter = Library:Create("Frame", {
            Name=_EL_WinName, Size=UDim2.new(0,370,0,238),
            Position=UDim2.new(0.5,-192,0.2,0),
            BackgroundColor3=Color3.new(0,0,0), BorderSizePixel=0, Parent=guiParent
        })
        _EL_Logger.Frame = winOuter
        local win = Library:Create("Frame", {
            Name=_EL_WinInnerName,
            BackgroundColor3=Library.BackgroundColor,
            BorderColor3=Library.AccentColor,
            BorderMode=Enum.BorderMode.Inset,
            Position=UDim2.new(0,1,0,1), Size=UDim2.new(1,-2,1,-2),
            Parent=winOuter
        })
        Library:AddToRegistry(win, { BackgroundColor3="BackgroundColor", BorderColor3="AccentColor" })
        local titleBar = Library:Create("Frame", {
            Size=UDim2.new(1,0,0,26), BackgroundColor3=Library.MainColor,
            BorderSizePixel=0, Parent=win
        })
        Library:AddToRegistry(titleBar, { BackgroundColor3="MainColor" })
        _LogMakeDraggable(titleBar, winOuter)
        local titleLbl = Library:Create("TextLabel", {
            Size=UDim2.new(0,130,1,0), BackgroundTransparency=1, Text="Effect Logger",
            Font=_LOG_BOLD, TextSize=13, TextColor3=Library.AccentColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=titleBar
        })
        Library:AddToRegistry(titleLbl, { TextColor3="AccentColor" })
        _LogPad(titleLbl, 10)
        _EL_Logger.CountLabel = Library:Create("TextLabel", {
            Size=UDim2.new(0,120,1,0), Position=UDim2.new(0,130,0,0),
            BackgroundTransparency=1, Text="0 entries.", Font=_LOG_SANS,
            TextSize=11, TextColor3=Library.FontColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=titleBar
        })
        Library:AddToRegistry(_EL_Logger.CountLabel, { TextColor3="FontColor" })
        local clearBtn = Library:Create("TextButton", {
            Size=UDim2.new(0,52,0,18), Position=UDim2.new(1,-116,0,4),
            BackgroundColor3=Library.MainColor, Text="Clear",
            Font=_LOG_BOLD, TextSize=11, TextColor3=Library.FontColor,
            BorderSizePixel=0, Parent=titleBar, AutoButtonColor=false
        })
        Library:AddToRegistry(clearBtn, { BackgroundColor3="MainColor", TextColor3="FontColor" })
        _LogCorner(clearBtn,3); _LogStroke(clearBtn, nil, 1)
        clearBtn.MouseEnter:Connect(function() clearBtn.BackgroundColor3 = Library.BackgroundColor end)
        clearBtn.MouseLeave:Connect(function() clearBtn.BackgroundColor3 = Library.MainColor end)
        clearBtn.MouseButton1Click:Connect(function()
            _EL_Logger.RowCount=0
            table.clear(_EL_cloneStore)
            table.clear(_EL_pending)
            for _,c in ipairs(_EL_Logger.ScrollFrame:GetChildren()) do
                if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
            end
            _EL_Logger.ScrollFrame.CanvasSize=UDim2.new(0,0,0,0)
            _EL_Logger.CountLabel.Text="0 entries."
            _EL_CloseViz()
        end)
        local restoreBtn = Library:Create("TextButton", {
            Name=_EL_RestoreName, Size=UDim2.new(0,28,0,22),
            Position=winOuter.Position,
            BackgroundColor3=Library.MainColor,
            Text="Open", Font=_LOG_BOLD, TextSize=10,
            TextColor3=Library.AccentColor,
            BorderSizePixel=0, Visible=false, Parent=guiParent, AutoButtonColor=false
        })
        Library:AddToRegistry(restoreBtn, { BackgroundColor3="MainColor", TextColor3="AccentColor" })
        _LogCorner(restoreBtn, 3); _LogStroke(restoreBtn, nil, 1)
        _LogMakeDraggable(restoreBtn, restoreBtn)
        local minBtn = Library:Create("TextButton", {
            Size=UDim2.new(0,24,0,18), Position=UDim2.new(1,-58,0,4),
            BackgroundColor3=Library.MainColor, Text="-",
            Font=_LOG_BOLD, TextSize=13, TextColor3=Library.FontColor,
            BorderSizePixel=0, Parent=titleBar, AutoButtonColor=false
        })
        Library:AddToRegistry(minBtn, { BackgroundColor3="MainColor", TextColor3="FontColor" })
        _LogCorner(minBtn,3); _LogStroke(minBtn, nil, 1)
        minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = Library.BackgroundColor end)
        minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = Library.MainColor end)
        minBtn.MouseButton1Down:Connect(function()
            restoreBtn.Position = winOuter.Position
            winOuter.Visible   = false
            restoreBtn.Visible = true
        end)
        restoreBtn.MouseButton1Down:Connect(function()
            winOuter.Position  = restoreBtn.Position
            restoreBtn.Visible = false
            winOuter.Visible   = true
        end)
        local xBtn = Library:Create("TextButton", {
            Size=UDim2.new(0,24,0,18), Position=UDim2.new(1,-28,0,4),
            BackgroundColor3=Color3.fromRGB(180,50,50), Text="X",
            Font=_LOG_BOLD, TextSize=11, TextColor3=Color3.new(1,1,1),
            BorderSizePixel=0, Parent=titleBar, AutoButtonColor=false
        })
        _LogCorner(xBtn,3)
        xBtn.MouseButton1Click:Connect(function()
            EffectLogger.StopTracking()
            _EL_CloseViz()
            winOuter:Destroy()
            pcall(function() restoreBtn:Destroy() end)
            _EL_Logger.ScrollFrame = nil
            _EL_Logger.CountLabel  = nil
            _EL_Logger.RowCount    = 0
            _EL_Logger.Frame       = nil
        end)
        local COLS = {
            {text="Time",   w=52 },
            {text="Name",   w=100},
            {text="Type",   w=48 },
            {text="Owner",  w=76 },
            {text="Status", w=58 },
        }
        local headerRow = Library:Create("Frame", {
            Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,26),
            BackgroundColor3=Library.MainColor, BorderSizePixel=0, Parent=win
        })
        Library:AddToRegistry(headerRow, { BackgroundColor3="MainColor" })
        local hAccent = Library:Create("Frame", {
            Size=UDim2.new(0,3,1,0), BackgroundColor3=Library.AccentColor,
            BorderSizePixel=0, Parent=headerRow
        })
        Library:AddToRegistry(hAccent, { BackgroundColor3="AccentColor" })
        local hx = 3
        for _, col in ipairs(COLS) do
            local hLbl = Library:Create("TextLabel", {
                Size=UDim2.new(0,col.w,1,0), Position=UDim2.new(0,hx,0,0),
                BackgroundTransparency=1, Text=col.text,
                Font=_LOG_BOLD, TextSize=11, TextColor3=Library.AccentColor,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=headerRow
            })
            Library:AddToRegistry(hLbl, { TextColor3="AccentColor" })
            _LogPad(hLbl, 6)
            hx = hx + col.w
        end
        local scroll = Library:Create("ScrollingFrame", {
            Size=UDim2.new(1,0,1,-46), Position=UDim2.new(0,0,0,46),
            BackgroundColor3=Library.BackgroundColor, BorderSizePixel=0,
            ScrollBarThickness=3, ScrollBarImageColor3=Library.OutlineColor,
            CanvasSize=UDim2.new(0,0,0,0), Parent=win,
            ElasticBehavior=Enum.ElasticBehavior.Never
        })
        Library:AddToRegistry(scroll, { BackgroundColor3="BackgroundColor", ScrollBarImageColor3="OutlineColor" })
        _EL_Logger.ScrollFrame = scroll
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding   = UDim.new(0,0)
        layout.Parent    = scroll
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
        end)
    end
    local function _EL_AddRow(entry)
        if not _EL_Logger.ScrollFrame or not _EL_Logger.ScrollFrame.Parent then return end
        _EL_Logger.RowCount = _EL_Logger.RowCount + 1
        local isKnown  = (_EL_effectData[entry.effectName] ~= nil)
        local rowH     = 22
        local isEven   = (_EL_Logger.RowCount % 2 == 0)
        local rowBgKey = isEven and "BackgroundColor" or "MainColor"
        local rowBg    = isEven and Library.BackgroundColor or Library.MainColor
        local row = Library:Create("TextButton", {
            Name="ELRow_".._EL_Logger.RowCount, Size=UDim2.new(1,0,0,rowH),
            BackgroundColor3=rowBg, Text="", BorderSizePixel=0,
            LayoutOrder=_EL_Logger.RowCount, AutoButtonColor=false,
            Parent=_EL_Logger.ScrollFrame
        })
        Library:AddToRegistry(row, { BackgroundColor3=rowBgKey })
        row.MouseEnter:Connect(function() row.BackgroundColor3 = Library:GetBetterColor(rowBg, 15) end)
        row.MouseLeave:Connect(function() row.BackgroundColor3 = rowBg end)
        row.MouseButton1Click:Connect(function() _EL_OpenViz(entry) end)
        local stripColor = isKnown and Library.AccentColor or _LOG_RED
        local strip = Library:Create("Frame", {
            Size=UDim2.new(0,3,1,0), Position=UDim2.new(0,0,0,0),
            BackgroundColor3=stripColor, BorderSizePixel=0, Parent=row
        })
        if isKnown then Library:AddToRegistry(strip, { BackgroundColor3="AccentColor" }) end
        local sep = Library:Create("Frame", {
            Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
            BackgroundColor3=Library.OutlineColor, BorderSizePixel=0, Parent=row
        })
        Library:AddToRegistry(sep, { BackgroundColor3="OutlineColor" })
        local xOff = 3
        local timeCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,52,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=os.date("%H:%M:%S"):sub(1,5), Font=_LOG_MONO,
            TextSize=10, TextColor3=Library.FontColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
        Library:AddToRegistry(timeCell, { TextColor3="FontColor" })
        _LogPad(timeCell, 6)
        xOff = xOff + 52
        local nameBox = Library:Create("TextBox", {
            Size=UDim2.new(0,150,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=entry.effectName, Font=_LOG_MONO,
            TextSize=10, TextColor3=_LOG_BLUE,
            TextXAlignment=Enum.TextXAlignment.Left,
            ClearTextOnFocus=false, TextEditable=false,
            BorderSizePixel=0, Parent=row
        })
        _LogPad(nameBox, 6)
        xOff = xOff + 100
        local typeShort = entry.className or ""
        if #typeShort > 8 then typeShort = typeShort:sub(1,7).."…" end
        local typeCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,72,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=typeShort, Font=_LOG_MONO,
            TextSize=10, TextColor3=Library.AccentColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
        _LogPad(typeCell, 6)
        xOff = xOff + 48
        local ownerShort = entry.ownerName or ""
        if #ownerShort > 9 then ownerShort = ownerShort:sub(1,8).."…" end
        local ownerCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,76,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=ownerShort, Font=_LOG_SANS,
            TextSize=10, TextColor3=Library.FontColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
        Library:AddToRegistry(ownerCell, { TextColor3="FontColor" })
        _LogPad(ownerCell, 6)
        xOff = xOff + 80
        local statusText  = isKnown and "KNOWN" or "NEW"
        local statusColor = isKnown and _LOG_GREEN or _LOG_RED
        local statusCell = Library:Create("TextLabel", {
            Size=UDim2.new(0,28,1,0), Position=UDim2.new(0,xOff,0,0),
            BackgroundTransparency=1, Text=statusText, Font=_LOG_BOLD,
            TextSize=10, TextColor3=statusColor,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row
        })
        _LogPad(statusCell, 2)
        _EL_Logger.CountLabel.Text = _EL_Logger.RowCount .. " entries."
        _EL_Logger.ScrollFrame.CanvasPosition = Vector2.new(
            0, math.max(0, _EL_Logger.ScrollFrame.AbsoluteCanvasSize.Y - _EL_Logger.ScrollFrame.AbsoluteSize.Y)
        )
    end
    local function _EL_resolveOwner(child)
        local pos = nil
        if child:IsA("BasePart") then
            pos = child.Position
        elseif child:IsA("Model") then
            local pp = child.PrimaryPart or child:FindFirstChildOfClass("BasePart")
            if pp then pos = pp.Position end
        end
        if not pos then return "Unknown" end
        local best, bestDist = "Unknown", 60
        for _, plr in ipairs(Services.Players:GetPlayers()) do
            local char = plr.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - pos).Magnitude
                if d < bestDist then bestDist = d; best = plr.Name end
            end
        end
        local monsterFolder = workspace:FindFirstChild("Monster")
        if monsterFolder then
            for _, model in ipairs(monsterFolder:GetChildren()) do
                local root = model:FindFirstChild("Root") or model:FindFirstChild("HumanoidRootPart")
                if root then
                    local d = (root.Position - pos).Magnitude
                    if d < bestDist then bestDist = d; best = model.Name end
                end
            end
        end
        return best
    end
    local function _EL_resolveOwnerModel(pos)
        if not pos then return nil end
        local best, bestDist = nil, 60
        local monsterFolder = workspace:FindFirstChild("Monster")
        if monsterFolder then
            for _, model in ipairs(monsterFolder:GetChildren()) do
                local root = model:FindFirstChild("Root") or model:FindFirstChild("HumanoidRootPart")
                if root then
                    local d = (root.Position - pos).Magnitude
                    if d < bestDist then bestDist = d; best = model end
                end
            end
        end
        return best
    end
    local function _EL_onEffectAdded(child)
        if not (child:IsA("BasePart") or child:IsA("Model") or child:IsA("Folder")) then return end
        local cloned = nil
        pcall(function() cloned = child:Clone() end)
        if cloned then
            if cloned:IsA("BasePart") then cloned.Anchored=true; cloned.CanCollide=false end
            for _, d in ipairs(cloned:GetDescendants()) do
                if d:IsA("BasePart") then d.Anchored=true; d.CanCollide=false end
            end
        end
        local spawnPos = nil
        if child:IsA("BasePart") then
            spawnPos = child.Position
        else
            local pp = child.PrimaryPart or child:FindFirstChildOfClass("BasePart")
            if pp then spawnPos = pp.Position end
        end
        table.insert(_EL_pending, {
            child     = child,
            name      = child.Name,
            className = child.ClassName,
            cloned    = cloned,
            spawnPos  = spawnPos,
            born      = tick(),
        })
    end
    function EffectLogger.StartTracking()
        if #_EL_conns > 0 then return end
        for _, target in ipairs(_EL_targets) do
            if target then
                table.insert(_EL_conns, target.ChildAdded:Connect(_EL_onEffectAdded))
            end
        end
        table.insert(_EL_conns, RunService.Heartbeat:Connect(function()
            if #_EL_pending == 0 then return end
            local char = Plr.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local now = tick()
            local i = 1
            while i <= #_EL_pending do
                local entry = _EL_pending[i]
                local child = entry.child
                if now - entry.born > 2 then
                    table.remove(_EL_pending, i)
                    continue
                end
                local pos = nil
                if child:IsA("BasePart") and child.Parent then
                    pos = child.Position
                elseif (child:IsA("Model") or child:IsA("Folder")) and child.Parent then
                    local pp = child.PrimaryPart or child:FindFirstChildOfClass("BasePart")
                    if pp then pos = pp.Position end
                end
                pos = pos or entry.spawnPos
                if not pos then i = i + 1; continue end
                local dist = (pos - hrp.Position).Magnitude
                if _EL_maxLogDist > 0 and dist > _EL_maxLogDist then i = i + 1; continue end
                table.remove(_EL_pending, i)
                local rowKey = _EL_Logger.RowCount + 1
                if entry.cloned then _EL_cloneStore[rowKey] = entry.cloned end
                local ed = _EL_effectData[entry.name]
                if ed and Toggles.AutoBlock and Toggles.AutoBlock.Value then
                    local trigDist = tonumber(ed.Dist) or 999
                    local delay    = tonumber(ed.Delay) or 0
                    if dist <= trigDist then
                        local ownerModel = _EL_resolveOwnerModel(pos)
                        if _AB_isFarmTarget(ownerModel) then
                            _AB_QueueBlock(pos, delay)
                        else
                        end
                    end
                end
                if _EL_Logger.ScrollFrame and _EL_Logger.ScrollFrame.Parent then
                    local owner = _EL_resolveOwner(child)
                    _EL_AddRow({
                        effectName  = entry.name,
                        className   = entry.className,
                        ownerName   = owner,
                        snapshot    = child,
                        rowKey      = rowKey,
                        storedClone = entry.cloned,
                    })
                end
            end
        end))
    end
    function EffectLogger.StopTracking()
        for _, c in ipairs(_EL_conns) do c:Disconnect() end
        table.clear(_EL_conns)
        table.clear(_EL_pending)
    end
    function EffectLogger.Open()
        if not (_EL_Logger.ScrollFrame and _EL_Logger.ScrollFrame.Parent) then
            _EL_BuildGui()
        end
        EffectLogger.StartTracking()
    end
    function EffectLogger.Close()
        _EL_CloseViz()
        EffectLogger.StopTracking()
        table.clear(_EL_cloneStore)
        if _EL_Logger.Frame then
            _EL_Logger.Frame:Destroy()
            _EL_Logger.ScrollFrame = nil
            _EL_Logger.CountLabel  = nil
            _EL_Logger.RowCount    = 0
            _EL_Logger.Frame       = nil
        end
    end
    function EffectLogger.SetEffect(name, Dist, delay)
        if not name or name == "" then return false end
        _EL_effectData[name] = { Dist = Dist, Delay = delay or 0 }
        _EL_SaveEffectFile()
        return true
    end
    function EffectLogger.GetEffectData(name)
        return _EL_effectData[name]
    end
    function EffectLogger.SetMaxDist(d)
        _EL_maxLogDist = tonumber(d) or 0
    end
    function EffectLogger.IsTracking()
        return #_EL_conns > 0
    end
    function EffectLogger.IsGuiOpen()
        return _EL_Logger.Frame ~= nil and _EL_Logger.Frame.Parent ~= nil
    end
end
local _monsterAnimConns = {}
local _trackedMonsters  = {}
local function _onMonsterAnimPlayed(monsterModel, track)
    local anim = track and track.Animation
    if not anim then return end
    local rawId  = anim.AnimationId or ""
    local animId = rawId:match("%d+") or "0"
    local char     = GetCharacter()
    local hrp      = char and char.HumanoidRootPart
    local rootPart = monsterModel:FindFirstChild("Root") or monsterModel:FindFirstChild("HumanoidRootPart")
    if not hrp or not rootPart then return end
    local dist = (hrp.Position - rootPart.Position).Magnitude
    local td   = AnimLogger.GetTimingData(animId)
    if not td then return end
    local delay   = td.Delay   or 0
    local maxDist = td.MaxDist or 999
    if td.HitboxX and td.HitboxY and td.HitboxZ then
        task.delay(delay, function()
            if not (Toggles.ShowHitbox and Toggles.ShowHitbox.Value) then return end
            if not (rootPart and rootPart.Parent) then return end
            ShowBoxTable.ShowBox(
                rootPart.CFrame,
                Vector3.new(td.HitboxX, td.HitboxY, td.HitboxZ),
                0.4
            )
        end)
    end
    if not (Toggles.AutoBlock and Toggles.AutoBlock.Value) then return end
    if dist > maxDist then return end
    if not _AB_isFarmTarget(monsterModel) then return end
    local spawnPos = rootPart and rootPart.Position
    _AB_QueueBlock(spawnPos, delay)
end
local function _trackMonster(model)
    if _trackedMonsters[model] then return end 
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    _trackedMonsters[model] = true
    local conn = hum.AnimationPlayed:Connect(function(track)
        _onMonsterAnimPlayed(model, track)
    end)
    _monsterAnimConns[model] = conn
end
local function _untrackMonster(model)
    if _monsterAnimConns[model] then
        _monsterAnimConns[model]:Disconnect()
        _monsterAnimConns[model] = nil
    end
    _trackedMonsters[model] = nil
end
local function _startMonsterTracking()
    local monsterFolder = workspace:FindFirstChild("Monster")
    if not monsterFolder then return end
    for _, model in ipairs(monsterFolder:GetChildren()) do
        if model:IsA("Model") then _trackMonster(model) end
    end
    table.insert(Connections, monsterFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            task.wait()  
            _trackMonster(child)
        end
    end))
    table.insert(Connections, monsterFolder.ChildRemoved:Connect(function(child)
        _untrackMonster(child)
    end))
end
local function _stopMonsterTracking()
    for model, conn in pairs(_monsterAnimConns) do
        conn:Disconnect()
    end
    _monsterAnimConns = {}
    _trackedMonsters  = {}
end
local function getTrackTargetId(model)
    local entityId   = model:GetAttribute("EntityId")
    local entityType = model:GetAttribute("EntityType")
    if entityId ~= nil and entityType ~= nil then
        return tostring(entityId)
    end
    return model.Name
end
local function DoHitNearest()
    if not SkillRemote then
        SkillRemote = RS:WaitForChild("Msg", 3)
            and RS.Msg:WaitForChild("RemoteEvent", 3)
            and RS.Msg.RemoteEvent:WaitForChild("ReleaseGroupSkill", 3)
        if not SkillRemote then return end
    end
    local char = GetCharacter()
    if not char then return end
    local myHRP = char.HumanoidRootPart
    local releaseCF = myHRP.CFrame
    local monsterFolder = workspace:FindFirstChild("Monster")
    if not monsterFolder then
        return
    end
    local nearest, nearestRoot, nearestDist = nil, nil, math.huge
    for _, model in ipairs(monsterFolder:GetChildren()) do
        local hum      = model:FindFirstChildOfClass("Humanoid")
        local rootPart = model:FindFirstChild("Root") or model:FindFirstChild("HumanoidRootPart")
        if hum and rootPart and hum.Health > 0 then
            local dist = (rootPart.Position - myHRP.Position).Magnitude
            if dist < nearestDist then
                nearest      = model
                nearestRoot  = rootPart
                nearestDist  = dist
            end
        end
    end
    if not nearest then return end
    if not IsNormalAtkReady() then return end
    local trackTargetId = getTrackTargetId(nearest)
    local ok, fireErr = pcall(function()
        if not RateAllow("SkillRemote", Options.AttackRate and Options.AttackRate.Value or 10) then return end
        SkillRemote:FireServer(4, {
            targetCF            = nearestRoot.CFrame,
            moveDirectionStr    = "Forward",
            clientPredictCastId = newUUID(),
            characterType       = "Player",
            releaseCF           = releaseCF,
            characterId         = Plr.UserId,
            trackTargetId       = trackTargetId,
        })
    end)
    if not ok then
    end
end
local function HitNearestLoop()
    while Toggles.HitNearest.Value do
        DoHitNearest()
        task.wait(HIT_NEAREST_RATE)
    end
end
local MAP_FOLDER        = "\229\156\186\230\153\175"
local CHEST_FOLDER      = "\229\174\157\231\174\177"
local CHEST_DATA_FOLDER = "\229\156\176\229\155\190\229\174\157\231\174\177\230\149\176\230\141\174" 
local function IsChestReady(chestModel)
    local dataFolder = Plr:FindFirstChild(CHEST_DATA_FOLDER)
    if not dataFolder then return true end 
    local val = dataFolder:FindFirstChild(chestModel.Name)
    if not val then return true end 
    return val.Value > 0
end
local function DoOpenChests()
    if not ChestRemote then
        ChestRemote = RS:WaitForChild("Msg", 3)
            and RS.Msg:WaitForChild("RemoteFunction", 3)
            and RS.Msg.RemoteFunction:WaitForChild("SystemChestRemoteFunction", 3)
        if not ChestRemote then return end
    end
    local mapFolder = workspace:FindFirstChild(MAP_FOLDER)
    if not mapFolder then
        return
    end
    for _, worldFolder in ipairs(mapFolder:GetChildren()) do
        local chestFolder = worldFolder:FindFirstChild(CHEST_FOLDER)
        if chestFolder then
            for _, chestModel in ipairs(chestFolder:GetChildren()) do
                if not IsChestReady(chestModel) then
                    task.wait()
                    continue
                end
                local ok, result = pcall(function()
                    return ChestRemote:InvokeServer(chestModel)
                end)
                if not ok then
                end
                task.wait(0.3)
            end
        end
    end
end
local function AutoChestLoop()
    while Toggles.AutoChest.Value do
        DoOpenChests()
        task.wait(2)
    end
end
local AUTOFARM_ATTACK_RATE = 0.1
local function GetMonsterZhName(model)
    local root = model:FindFirstChild("Root") or model:FindFirstChild("HumanoidRootPart")
    local zh   = root and root:GetAttribute("ZhName")
    if zh and tostring(zh) ~= "" then
        return tostring(zh)
    end
    return model.Name
end
local function GetAutoFarmTarget()
    local selected = Options.SelectedFarmNPCs and Options.SelectedFarmNPCs.Value or {}
    local char = GetCharacter()
    if not char then return nil, nil, nil end
    local myHRP = char.HumanoidRootPart
    local monsterFolder = workspace:FindFirstChild("Monster")
    if not monsterFolder then return nil, nil, nil end
    local hasSelection = next(selected) ~= nil
    local nearest, nearestRoot, nearestDist = nil, nil, math.huge
    for _, model in ipairs(monsterFolder:GetChildren()) do
        if model:IsA("Model") then
            local hum      = model:FindFirstChildOfClass("Humanoid")
            local rootPart = model:FindFirstChild("Root") or model:FindFirstChild("HumanoidRootPart")
            if hum and rootPart and hum.Health > 0 then
                if hasSelection then
                    local zh = GetMonsterZhName(model)
                    local display = Translate(zh)
                    if not selected[display] then continue end
                end
                local dist = (rootPart.Position - myHRP.Position).Magnitude
                if dist < nearestDist then
                    nearest     = model
                    nearestRoot = rootPart
                    nearestDist = dist
                end
            end
        end
    end
    return nearest, nearestRoot, nearestDist
end
local BODY_VEL_NAME = "a"
local BODY_GYRO_NAME = "b"
local bodyVelocity, bodyGyro
local BodyOrigins = {}
local activeBodyHRP = nil
local function enableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
            inst:Destroy()
        end
    end
    BodyOrigins = {}
    BodyOrigins[hrp] = hrp.Anchored
    hrp.Anchored = false
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = BODY_VEL_NAME
    bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = hrp
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = BODY_GYRO_NAME
    bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    activeBodyHRP = hrp
end
local function disableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
            inst:Destroy()
        end
    end
    bodyVelocity = nil
    bodyGyro     = nil
    if BodyOrigins and BodyOrigins[hrp] ~= nil then
        hrp.Anchored = BodyOrigins[hrp]
    end
    BodyOrigins   = {}
    activeBodyHRP = nil
end
local DoServerHop  
local function DoInstantKill()
    local monsterFolder = workspace:FindFirstChild("Monster")
    if not monsterFolder then return end
    local selected = Options.SelectedFarmNPCs and Options.SelectedFarmNPCs.Value or {}
    local hasSelection = next(selected) ~= nil
    local threshold = (Options.InstantKillHpValue and Options.InstantKillHpValue.Value or 99) / 100
    for _, model in ipairs(monsterFolder:GetChildren()) do
        if not model:IsA("Model") then continue end
        if hasSelection then
            local zh = GetMonsterZhName(model)
            local display = Translate(zh)
            if not selected[display] then continue end
        end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        local cur = hum.Health
        local max = hum.MaxHealth
        if type(cur) == "number" and type(max) == "number" and max > 0 then
            if cur / max <= threshold then
                hum.Health = 0
            end
        end
    end
end
local function InstantKillLoop()
    sethiddenproperty(Plr, "SimulationRadius", 1124)
    sethiddenproperty(Plr, "MaxSimulationRadius", 1124)
    while Toggles.InstantKill.Value do
        DoInstantKill()
        task.wait(0.1)
    end
end
local function DoAutoFarm()
    if not SkillRemote then
        SkillRemote = RS:WaitForChild("Msg", 3)
            and RS.Msg:WaitForChild("RemoteEvent", 3)
            and RS.Msg.RemoteEvent:WaitForChild("ReleaseGroupSkill", 3)
        if not SkillRemote then return end
    end
    local char = GetCharacter()
    if not char then return end
    local root = char.HumanoidRootPart
    local target, targetRoot, targetDist = GetAutoFarmTarget()
    if not target or not targetRoot then
        currentFarmTarget = nil
        return
    end
    currentFarmTarget = target
    local height   = Options.AutoFarmHeight and Options.AutoFarmHeight.Value or 10
    local speed    = tonumber(Options.TweenSpeed and Options.TweenSpeed.Value) or 1000
    local targetPos = targetRoot.Position
    local finalPos  = targetPos + Vector3.new(0, height, 0)
    local finalCF   = CFrame.lookAt(finalPos, targetPos)
    local moveDist  = (root.Position - finalPos).Magnitude
    if moveDist > 1 then
        local duration = moveDist / math.max(speed, 1)
        local tween = TweenService:Create(
            root,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {CFrame = finalCF}
        )
        activeFarmTween = tween
        tween:Play()
        tween.Completed:Wait()
        activeFarmTween = nil
    end
    root.AssemblyLinearVelocity  = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    task.wait(AUTOFARM_ATTACK_RATE)
    char = GetCharacter()
    if not char then return end
    root = char.HumanoidRootPart
    if not target.Parent then return end
    local hum = target:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local trackTargetId = getTrackTargetId(target)
    if not IsNormalAtkReady() then return end
    local ok, fireErr = pcall(function()
        if not RateAllow("SkillRemote", Options.AttackRate and Options.AttackRate.Value or 10) then return end
        SkillRemote:FireServer(4, {
            targetCF            = targetRoot.CFrame,
            moveDirectionStr    = "Forward",
            clientPredictCastId = newUUID(),
            characterType       = "Player",
            releaseCF           = root.CFrame,
            characterId         = Plr.UserId,
            trackTargetId       = trackTargetId,
        })
    end)
    if not ok then
    end
end
local NORMAL_ATK_FOLDER = "\230\138\128\232\131\189\231\155\184\229\133\179" 
local NORMAL_ATK_VALUE  = 10000003
local function SetNormalAtk()
    local folder = Plr:FindFirstChild(NORMAL_ATK_FOLDER)
    if not folder then
        return
    end
    local nv = folder:FindFirstChild("NormalAtk")
    if not nv then
        return
    end
    if nv.Value ~= NORMAL_ATK_VALUE then
        nv.Value = NORMAL_ATK_VALUE
    end
end
local function AutoFarmLoop()
    SetNormalAtk()  
    local char = GetCharacter()
    local hrp  = char and char.HumanoidRootPart
    if hrp then enableBodyControl(hrp) end
    local normalAtkTick = 0  
    while Toggles.AutoFarm.Value do
        normalAtkTick = normalAtkTick + 1
        if normalAtkTick >= 600 then
            SetNormalAtk()
            normalAtkTick = 0
        end
        local c = GetCharacter()
        local r = c and c.HumanoidRootPart
        if r then
            if r ~= hrp then
                if hrp then disableBodyControl(hrp) end
                hrp = r
                enableBodyControl(hrp)
            end
            if bodyGyro then
                bodyGyro.CFrame = r.CFrame
            end
        end
        local prevTarget = currentFarmTarget
        DoAutoFarm()
        task.wait(0.05)
    end
    if hrp then disableBodyControl(hrp) end
end
local ITEM_TYPE_MATERIAL = 2
local ITEM_TYPE_POTION   = 9
local function GetBag()
    if not _PlayerData then return {} end
    return _PlayerData.GetPlrDataByKey(Plr, "Bag") or {}
end
local function GetNearestCauldronID()
    local char = GetCharacter()
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local bestID, bestDist = nil, math.huge
    for _, part in ipairs(CollectionService:GetTagged("Cauldron")) do
        local id = tonumber(part:GetAttribute("ID"))
        if id then
            local dist = hrp and (part.Position - hrp.Position).Magnitude or 0
            if dist < bestDist then
                bestDist = dist
                bestID   = id
            end
        end
    end
    return bestID
end
local brewCount  = 0
local brewQueue  = {}  
local function GetQueueLabel()
    local parts = {}
    for id, cnt in pairs(brewQueue) do
        local dispName = tostring(id)
        for name, mid in pairs(MaterialNameToID) do
            if mid == id then dispName = name; break end
        end
        table.insert(parts, dispName .. " x" .. cnt)
    end
    table.sort(parts)
    if #parts == 0 then return "Queue: (empty)" end
    return "Queue: " .. table.concat(parts, ", ")
end
local function DoBrew()
    if not AlchRemote then
        AlchRemote = RS.Msg.RemoteFunction:FindFirstChild("RemoteFunction")
        if not AlchRemote then return end
    end
    local cauldronID = GetNearestCauldronID()
    if not cauldronID then
        return
    end
    if next(brewQueue) == nil then
        return
    end
    local bag       = GetBag()
    local bagCounts = {}
    for _, item in pairs(bag) do
        if item.tp == ITEM_TYPE_MATERIAL then
            local id = tonumber(item.id)
            if id then
                bagCounts[id] = (bagCounts[id] or 0) + (item.count or 1)
            end
        end
    end
    local materials = {}
    for id, cnt in pairs(brewQueue) do
        local have = bagCounts[id] or 0
        local use  = math.min(cnt, have, 5)
        if use > 0 then
            materials[id] = use
        end
    end
    if next(materials) == nil then
        return
    end
    local nTypes = 0
    local nTotal = 0
    for _, c in pairs(materials) do nTypes = nTypes + 1; nTotal = nTotal + c end
    local ok1, res1 = pcall(function()
        return AlchRemote:InvokeServer("\231\130\188\232\141\175\230\184\184\230\136\143\229\188\128\229\167\139", {
            cauldronID = cauldronID,
            materials  = materials,
        })
    end)
    if not ok1 then
        return
    end
    if res1 ~= true then
        return
    end
    local ok2, res2 = pcall(function()
        return AlchRemote:InvokeServer("\231\130\188\232\141\175", {
            cauldronID = cauldronID,
            materials  = materials,
            gameScore  = 100,
        })
    end)
    if not ok2 then
        return
    end
    if res2 then
        brewCount = brewCount + 1
        local potionID = type(res2) == "table" and res2.id
    end
end
local function AutoBrewLoop()
    while Toggles.AutoBrew.Value do
        DoBrew()
        task.wait(1)
    end
end
local refineCount  = 0
local function DoRefine()
    if not AlchRemote then
        return
    end
    if not _GetData then
        return
    end
    local bag = GetBag()
    local groups = {}
    for _, item in pairs(bag) do
        if item.tp == ITEM_TYPE_POTION and item.onlyID then
            local needNum = _GetData.GetPotionUpgradeNeedCount(item)
            if needNum and needNum >= 1 then
                local key = tostring(item.id) .. "_" .. tostring(item.mpTp or "")
                if not groups[key] then
                    groups[key] = {needNum = needNum, onlyIDs = {}}
                end
                table.insert(groups[key].onlyIDs, tonumber(item.onlyID))
            end
        end
    end
    local didFuse = false
    for key, group in pairs(groups) do
        local need = group.needNum
        local ids  = group.onlyIDs
        while #ids >= need do
            local batch = {}
            for i = 1, need do
                table.insert(batch, table.remove(ids, 1))
            end
            local ok, res = pcall(function()
                return AlchRemote:InvokeServer("\232\141\175\230\176\180\229\144\136\230\136\144", {
                    onlyIDs = batch,
                })
            end)
            if ok then
                if res then
                    refineCount = refineCount + 1
                end
            end
            task.wait(0.6)
            didFuse = true
        end
    end
    if not didFuse then
    end
end
local function AutoRefineLoop()
    while Toggles.AutoRefine.Value do
        DoRefine()
        task.wait(1)
    end
end
local sellCount  = 0
local function DoSell()
    if not AlchRemote then
        return
    end
    local bag           = GetBag()
    local sellPotions   = Toggles.SellPotions and Toggles.SellPotions.Value
    local sellMaterials = Toggles.SellMaterials and Toggles.SellMaterials.Value
    local selectedItems = Options.SellItemFilter and Options.SellItemFilter.Value or {}
    local specificIDs = {}
    for dispName in pairs(selectedItems) do
        local id = SellItemNameToID[dispName]
        if id then specificIDs[id] = true end
    end
    local hasSpecific = next(specificIDs) ~= nil
    local onlyIDList = {}
    for _, item in pairs(bag) do
        if not item.onlyID then continue end
        local oid = tonumber(item.onlyID)
        if not oid then continue end
        local cfgID = tonumber(item.id)
        local shouldSell = false
        if     hasSpecific   and specificIDs[cfgID]            then shouldSell = true
        elseif sellPotions   and item.tp == ITEM_TYPE_POTION   then shouldSell = true
        elseif sellMaterials and item.tp == ITEM_TYPE_MATERIAL then shouldSell = true
        end
        if shouldSell then
            local qty = tonumber(item.count) or 0
            if qty < 1 then continue end
            table.insert(onlyIDList, oid)
        end
    end
    if #onlyIDList == 0 then
        return
    end
    local ok, res = pcall(function()
        return AlchRemote:InvokeServer("\229\135\186\229\148\174\232\131\140\229\140\133\231\137\169\229\147\129", {
            onlyIDList = onlyIDList,
        })
    end)
    if ok then
        if res == true then
            sellCount = sellCount + #onlyIDList
        end
    end
end
local function AutoSellLoop()
    while Toggles.AutoSell.Value do
        DoSell()
        task.wait(1)
    end
end
local EXPAND_REMOTE_STR = "\232\131\140\229\140\133\229\174\185\233\135\143\233\135\145\229\184\129\229\141\135\231\186\167"
local function DoExpandInv()
    if not AlchRemote then
        AlchRemote = RS.Msg.RemoteFunction:FindFirstChild("RemoteFunction")
        if not AlchRemote then return end
    end
    if Toggles.AutoExpandMat.Value then
        pcall(function() AlchRemote:InvokeServer(EXPAND_REMOTE_STR, { itemTp = 2 }) end)
    end
    if Toggles.AutoExpandPot.Value then
        pcall(function() AlchRemote:InvokeServer(EXPAND_REMOTE_STR, { itemTp = 9 }) end)
    end
end
local function AutoExpandInvLoop()
    while Toggles.AutoExpandMat.Value or Toggles.AutoExpandPot.Value do
        DoExpandInv()
        task.wait(1)
    end
end
local function RestartExpandIfNeeded()
    if Toggles.AutoExpandMat.Value or Toggles.AutoExpandPot.Value then
        Thread("AutoExpandInv", AutoExpandInvLoop, true)
    else
        Thread("AutoExpandInv", AutoExpandInvLoop, false)
    end
end
local function UnlockGamePass()
    local gp = Plr:FindFirstChild("GamePass")
    if not gp then
        return
    end
    local count = 0
    for _, child in ipairs(gp:GetChildren()) do
        local ok, err = pcall(function() child.Value = 1 end)
        if ok then
            count = count + 1
        end
    end
end
local STAT_ALLOC_REMOTE = "\229\177\158\230\128\167\229\138\160\231\130\185" 
local STAT_ATTR_NAMES = { "Attack", "HP", "Cooling Reduction", "Movement Speed" }
local STAT_ATTR_IDS   = { 1, 5, 39, 41 }
local STAT_ITEM_ATTRPOINT = 5 
local statSpentThisSession = 0
local function DoStatPoints()
    if not AlchRemote then
        return
    end
    if not _GetData then
        return
    end
    local available = _GetData.GetItemCountByID(Plr, STAT_ITEM_ATTRPOINT)
    if not available or available < 1 then return end
    local selected = Options.StatAllocTypes and Options.StatAllocTypes.Value or {}
    local targets = {}
    for i, name in ipairs(STAT_ATTR_NAMES) do
        if not next(selected) or selected[name] then
            table.insert(targets, STAT_ATTR_IDS[i])
        end
    end
    if #targets == 0 then
        return
    end
    local perStat = math.floor(available / #targets)
    local remainder = available - perStat * #targets
    for i, attrTp in ipairs(targets) do
        local amount = perStat + (i == 1 and remainder or 0)
        if amount < 1 then continue end
        local ok, res = pcall(function()
            return AlchRemote:InvokeServer(STAT_ALLOC_REMOTE, {
                AttrTp   = attrTp,
                PointNum = amount,
            })
        end)
        if ok then
            if res then
                statSpentThisSession = statSpentThisSession + amount
            end
        end
        task.wait(0.3)
    end
end
local function AutoStatLoop()
    while Toggles.AutoStatPoints.Value do
        DoStatPoints()
        task.wait(3)
    end
end
local REBIRTH_REMOTE  = "\233\135\141\231\148\159" 
local REBIRTH_FOLDER  = "Rebirth"
local ITEM_LV         = 4  
local ITEM_COIN       = 1  
local ascendCount     = 0
local function DoAscension()
    if not AlchRemote then
        return
    end
    if not _CfgFind or not _GetData then
        return
    end
    local rebirthVal = Plr:FindFirstChild(REBIRTH_FOLDER)
    if not rebirthVal then
        return
    end
    local currentRank = rebirthVal.Value
    local nextCfg = _CfgFind.GetRebirthCfg(currentRank + 1)
    if not nextCfg then
        Toggles.AutoAscend:SetValue(false)
        return
    end
    local reqLevel = nextCfg.RankAllow
    local reqCoins = nextCfg.Cost
    local curLevel = _GetData.GetItemCountByID(Plr, ITEM_LV)
    local curCoins = _GetData.GetItemCountByID(Plr, ITEM_COIN)
    if curLevel < reqLevel then return end
    if curCoins < reqCoins then return end
    local ok, res = pcall(function()
        return AlchRemote:InvokeServer(REBIRTH_REMOTE)
    end)
    if ok then
        if res then
            ascendCount = ascendCount + 1
        end
    end
end
local function AutoAscendLoop()
    while Toggles.AutoAscend.Value do
        DoAscension()
        task.wait(5)
    end
end
DoServerHop = function()
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
    Library:Notify("Farm Hop: No available servers found.", 3)
end
local function IsHopTarget()
    local sel = Options.HopTargetNPCs and Options.HopTargetNPCs.Value or {}
    if next(sel) == nil then return true end 
    local monsterFolder = workspace:FindFirstChild("Monster")
    if not monsterFolder then return false end
    for _, model in ipairs(monsterFolder:GetChildren()) do
        if model:IsA("Model") then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local zh = GetMonsterZhName(model)
                local display = Translate(zh)
                if sel[display] then
                    return true
                end
            end
        end
    end
    return false
end
local function HopTarLoop()
    while Toggles.HopNoTarget.Value do
        local sel = Options.HopTargetNPCs and Options.HopTargetNPCs.Value or {}
        if next(sel) ~= nil then
            if not IsHopTarget() then
                Library:Notify("Target not in server. Hopping...", 3)
                DoServerHop()
                return
            end
        end
        task.wait(1)
    end
end
local raceRerollCount = 0
local RACE_REROLL_REMOTE = "Roll\231\167\141\230\151\143"
local function DoRaceReroll()
    if not AlchRemote then
        return
    end
    local selectedDisplay = Options.TargetRace and Options.TargetRace.Value
    if not selectedDisplay or selectedDisplay == "" then
        Library:Notify("Race Reroll: Select a target race first.", 3)
        Toggles.AutoRaceReroll:SetValue(false)
        return
    end
    local targetID = RaceDisplayToID[selectedDisplay]
    if not targetID then
        Library:Notify("Race Reroll: Unknown race selected.", 3)
        Toggles.AutoRaceReroll:SetValue(false)
        return
    end
    local hrVal = Plr:FindFirstChild("HumanRace")
    if hrVal and tonumber(hrVal.Value) == targetID then
        Library:Notify("Race Reroll: Already have " .. selectedDisplay .. "!", 4)
        Toggles.AutoRaceReroll:SetValue(false)
        return
    end
    local ok, result = pcall(function()
        return AlchRemote:InvokeServer(RACE_REROLL_REMOTE)
    end)
    if not ok or result == nil then
        Library:Notify("Race Reroll: No rerolls left or remote error.", 4)
        Toggles.AutoRaceReroll:SetValue(false)
        return
    end
    raceRerollCount = raceRerollCount + 1
    local rolledName = RaceIDToDisplay[tonumber(result)] or tostring(result)
    Library:Notify("Roll #" .. raceRerollCount .. ": " .. rolledName, 3)
    if tonumber(result) == targetID then
        Library:Notify("✓ Got " .. selectedDisplay .. " after " .. raceRerollCount .. " rolls!", 6)
        raceRerollCount = 0
        Toggles.AutoRaceReroll:SetValue(false)
    end
end
local function AutoRaceRerollLoop()
    raceRerollCount = 0
    while Toggles.AutoRaceReroll.Value do
        DoRaceReroll()
        task.wait(1)
    end
end
local TaskClaimRemote = RS:WaitForChild("Msg", 10)
    and RS.Msg:WaitForChild("RemoteEvent", 10)
    and RS.Msg.RemoteEvent:WaitForChild("SystemTaskRemoteEvent", 10)
local QuestDisplayNames = {}
local QuestDisplayToTag = {}
local QuestSelectedTags = {}
do
    local taskConf = _CfgFind and _CfgFind.GetCfgByName and _CfgFind.GetCfgByName("taskConf")
    if taskConf then
        local seenTag     = {}
        local seenDisplay = {}
        for _, cfg in ipairs(taskConf) do
            if type(cfg) == "table" and type(cfg.onlyTag) == "string" and cfg.onlyTag ~= "" then
                if seenTag[cfg.onlyTag] then continue end
                seenTag[cfg.onlyTag] = true
                local display = Translate(cfg.ZhName or cfg.onlyTag)
                if not display or display == "" then continue end
                if seenDisplay[display] then
                    display = display .. " (" .. cfg.onlyTag .. ")"
                end
                seenDisplay[display] = true
                table.insert(QuestDisplayNames, display)
                QuestDisplayToTag[display] = cfg.onlyTag
            end
        end
    end
end
local function IsQuestComplete(taskId)
    local taskCfg = _CfgFind and _CfgFind.GetCfgByName and _CfgFind.GetCfgByName("taskConf")
    if not taskCfg then return false end
    local cfg = nil
    for _, v in ipairs(taskCfg) do
        if type(v) == "table" and v.onlyTag == taskId then cfg = v; break end
    end
    if not cfg then return false end
    local taskFolder = Plr:FindFirstChild("Task")
    if not taskFolder then return false end
    local sv = taskFolder:FindFirstChild(taskId)
    if not sv then return false end
    local parts = string.split(sv.Value, "|")
    if type(cfg.need) ~= "table" then return true end
    for k, needed in pairs(cfg.need) do
        local current = tonumber(parts[k]) or 0
        if current < (tonumber(needed) or 0) then return false end
    end
    return true
end
local function AutoQuestLoop()
    while Toggles.AutoQuest.Value do
        if #QuestSelectedTags == 0 then
            task.wait(2)
            continue
        end
        for _, taskId in ipairs(QuestSelectedTags) do
            if not Toggles.AutoQuest.Value then break end
            local taskFolder = Plr:FindFirstChild("Task")
            local activeQuest = taskFolder and taskFolder:FindFirstChild(taskId)
            if not activeQuest then
                if TalkFunc then
                    pcall(function() TalkFunc:InvokeServer("\229\143\145\230\148\190\228\187\187\229\138\161", { taskId }) end)
                end
                task.wait(2)
            elseif IsQuestComplete(taskId) then
                if TaskClaimRemote then
                    pcall(function() TaskClaimRemote:FireServer(taskId) end)
                end
                task.wait(2)
                if AlchRemote then
                    pcall(function() AlchRemote:InvokeServer("\230\148\190\229\188\131\228\187\187\229\138\161", taskId) end)
                end
                task.wait(1)
            end
        end
        task.wait(3)
    end
end
local function DoTPtoNPC()
    local selected = Options.TargetNPC and Options.TargetNPC.Value
    if not selected or selected == "" then
        Library:Notify("TP to NPC: Select an NPC first.", 3)
        return
    end
    local npcRawName = _npcDisplayToRaw[selected]
    if not npcRawName then
        Library:Notify("TP to NPC: NPC name not found in map.", 3)
        return
    end
    local char = GetCharacter()
    if not char then Library:Notify("TP to NPC: No character.", 2) return end
    local hrp = char.HumanoidRootPart
    for _, part in ipairs(CollectionService:GetTagged("Talk")) do
        if part:GetAttribute("TalkNpcName") == npcRawName then
            local model = part.Parent
            local root  = model and (model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Root"))
            local pos   = root and root.Position or part.Position
            hrp.CFrame  = CFrame.new(pos + Vector3.new(0, 3, 3))
            Library:Notify("Teleported to " .. selected, 2)
            return
        end
    end
    Library:Notify("TP to NPC: " .. selected .. " not found in workspace.", 3)
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
    Alchemy     = Window:AddTab("Alchemy"),
    Combat      = Window:AddTab("Combat"),
    Misc        = Window:AddTab("Misc"),
    Character   = Window:AddTab("Character"),
    Config      = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Autofarm = Tabs.Main:AddLeftTabbox(),
        },
        Right = {
            Autofarm2   = Tabs.Main:AddRightTabbox(),
        },
    },
    Alchemy = {
        Left  = Tabs.Alchemy:AddLeftTabbox(),
        Right = Tabs.Alchemy:AddRightGroupbox("Auto Sell"),
    },
}
local FarmGroup = TB.Main.Left.Autofarm:AddTab("Collect")
local QuestLeft  = TB.Main.Left.Autofarm:AddTab("Quest")
QuestLeft:AddDropdown("QuestSelect", {
    Values     = QuestDisplayNames,
    Default    = {},
    Text       = "Select Quests",
    AllowNull  = true,
    Searchable = true,
    Multi      = true,
})
Options.QuestSelect:OnChanged(function()
    local tbl = {}
    for display, selected in pairs(Options.QuestSelect.Value) do
        if selected then
            local tag = QuestDisplayToTag[display]
            if tag then table.insert(tbl, tag) end
        end
    end
    QuestSelectedTags = tbl
end)
QuestLeft:AddToggle("AutoQuest", {
    Text    = "Auto Quest",
    Default = false,
})
Toggles.AutoQuest:OnChanged(function(state)
    Thread("AutoQuest", AutoQuestLoop, state)
end)
local AUTO_SKILL_VALUE_NAME = "\232\135\170\229\138\168\233\135\138\230\148\190\230\138\128\232\131\189" 
local autoSkillValue = nil
local autoSkillWatcher = nil
local function SetAutoSkill(enabled)
    if not autoSkillValue then
        autoSkillValue = Plr:FindFirstChild(AUTO_SKILL_VALUE_NAME)
    end
    if not autoSkillValue then return end
    if autoSkillWatcher then autoSkillWatcher:Disconnect(); autoSkillWatcher = nil end
    autoSkillValue.Value = enabled and 1 or 0
    if enabled then
        autoSkillWatcher = autoSkillValue:GetPropertyChangedSignal("Value"):Connect(function()
            if autoSkillValue.Value ~= 1 then
                autoSkillValue.Value = 1
            end
        end)
    end
end
task.spawn(function()
    autoSkillValue = Plr:WaitForChild(AUTO_SKILL_VALUE_NAME, math.huge)
end)
local CombatLeft  = Tabs.Combat:AddLeftGroupbox("Auto Block")
local CombatRight = Tabs.Combat:AddRightGroupbox("Anim Logger")
CombatLeft:AddToggle("ShowHitbox", {
    Text    = "Show Hitbox",
    Default = false,
})
Toggles.ShowHitbox:OnChanged(function(state)
    Players.LocalPlayer:SetAttribute("ShowHitbox", state)
    if state then
        _startMonsterTracking()
    elseif not (Toggles.AutoBlock and Toggles.AutoBlock.Value) then
        _stopMonsterTracking()
    end
end)
Players.LocalPlayer:SetAttribute("ShowHitbox", false)
CombatLeft:AddToggle("AutoBlock", {
    Text    = "Auto Block",
    Default = false,
})
Toggles.AutoBlock:OnChanged(function(state)
    if state then
        _startMonsterTracking()
        EffectLogger.StartTracking()
    else
        if not (Toggles.ShowHitbox and Toggles.ShowHitbox.Value) then
            _stopMonsterTracking()
        end
        if not EffectLogger.IsGuiOpen() then
            EffectLogger.StopTracking()
        end
        table.clear(_AB_pendingBlocks)
    end
    Thread("AutoBlock", AutoBlockLoop, state)
end)
CombatLeft:AddToggle("AutoSkill", {
    Text    = "Auto Skill",
    Default = false,
})
Toggles.AutoSkill:OnChanged(function(state)
    SetAutoSkill(state)
end)
CombatRight:AddButton({
    Text = "Open Anim Logger",
    Func = function()
        AnimLogger.Open()
    end,
})
CombatRight:AddButton({
    Text = "Open Effect Logger",
    Func = function()
        EffectLogger.Open()
    end,
})
CombatRight:AddSlider("AnimLoggerMaxDist", {
    Text    = "Log Max Distance",
    Default = 0,
    Min     = 0,
    Max     = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(value)
        AnimLogger.SetMaxDist(value)
        EffectLogger.SetMaxDist(value)
    end,
})
FarmGroup:AddToggle("AutoCollect", {
    Text    = "Auto Collect All Drops",
    Default = false,
})
Toggles.AutoCollect:OnChanged(function(state)
    Thread("AutoCollect", AutoCollectLoop, state)
end)
FarmGroup:AddToggle("AutoChest", {
    Text    = "Auto Open All Chests",
    Default = false,
})
Toggles.AutoChest:OnChanged(function(state)
    Thread("AutoChest", AutoChestLoop, state)
end)
local AutoFarmGroup = TB.Main.Right.Autofarm2:AddTab("Auto Farm")
Tabs.Main:UpdateWarningBox({
    Title    = "⚠️ WARNING ⚠️",
    Text     = "Autofarm can get you banned. I have not fixed the detection issues yet. Use Instant Kill only for now",
    IsNormal = false,
    Visible  = true,
    LockSize = true,
})
AutoFarmGroup:AddToggle("AutoFarm", {
    Text    = "Auto Farm",
    Default = false,
})
AutoFarmGroup:AddToggle("InstantKill", {
    Text    = "Instant Kill",
    Default = false,
})
AutoFarmGroup:AddSlider("InstantKillHpValue", {
    Text     = "Kill at HP%",
    Default  = 50,
    Min      = 1,
    Max      = 100,
    Rounding = 0,
    Compact  = true,
})
Toggles.InstantKill:OnChanged(function(state)
    Thread("InstantKill", InstantKillLoop, state)
end)
Toggles.AutoFarm:OnChanged(function(state)
    Thread("AutoFarm", AutoFarmLoop, state)
    if not state then
        if activeFarmTween then
            activeFarmTween:Cancel()
            activeFarmTween = nil
        end
        if activeBodyHRP then
            disableBodyControl(activeBodyHRP)
        end
    end
end)
AutoFarmGroup:AddDropdown("SelectedFarmNPCs", {
    Values    = TargetDisplayNames,
    Default   = {},
    Multi     = true,
    Text      = "Target NPCs",
    AllowNull = true,
    Searchable = true,
})
AutoFarmGroup:AddSlider("AutoFarmHeight", {
    Text     = "Tween Height",
    Default  = 10,
    Min      = 1,
    Max      = 100,
    Rounding = 0,
})
AutoFarmGroup:AddInput("TweenSpeed", {
    Text        = "Tween Speed",
    Default     = "200",
    Numeric     = true,
    Finished    = false,
})
AutoFarmGroup:AddSlider("AttackRate", {
    Text     = "Attack Rate (per sec)",
    Default  = 10,
    Min      = 1,
    Max      = 18,
    Rounding = 0,
    Compact  = true,
})
local BrewGroup   = TB.Alchemy.Left:AddTab("Brew")
local RefineGroup = TB.Alchemy.Left:AddTab("Refine")
BrewGroup:AddToggle("AutoBrew", {
    Text    = "Auto Brew",
    Default = false,
})
Toggles.AutoBrew:OnChanged(function(state)
    Thread("AutoBrew", AutoBrewLoop, state)
end)
BrewGroup:AddDropdown("BrewMaterials", {
    Values     = MaterialDisplayNames,
    Default    = nil,
    Multi      = false,
    Text       = "Select Material",
    AllowNull  = true,
    Searchable = true,
})
local brewQueueLabel = BrewGroup:AddLabel("Queue: (empty)", true)
BrewGroup:AddButton({
    Text = "Add Item",
    Func = function()
        local selected = Options.BrewMaterials and Options.BrewMaterials.Value
        if not selected or selected == "" then
            Library:Notify("Select a material first.", 2)
            return
        end
        local id = MaterialNameToID[selected]
        if not id then
            Library:Notify("Unknown material.", 2)
            return
        end
        local current = brewQueue[id] or 0
        if current >= 5 then
            Library:Notify(selected .. " is already at max (5).", 2)
            return
        end
        brewQueue[id] = current + 1
        brewQueueLabel:SetText(GetQueueLabel())
    end,
})
BrewGroup:AddButton({
    Text = "Remove All",
    Func = function()
        table.clear(brewQueue)
        brewQueueLabel:SetText("Queue: (empty)")
    end,
})
RefineGroup:AddToggle("AutoRefine", {
    Text    = "Auto Refine",
    Default = false,
})
Toggles.AutoRefine:OnChanged(function(state)
    Thread("AutoRefine", AutoRefineLoop, state)
end)
local SellGroup = TB.Alchemy.Right
SellGroup:AddDropdown("SellItemFilter", {
    Values     = SellItemDisplayNames,
    Default    = {},
    Multi      = true,
    Text       = "Items to Sell",
    AllowNull  = true,
    Searchable = true,
})
SellGroup:AddToggle("AutoSell", {
    Text    = "Auto Sell",
    Default = false,
})
Toggles.AutoSell:OnChanged(function(state)
    Thread("AutoSell", AutoSellLoop, state)
end)
SellGroup:AddToggle("AutoExpandMat", {
    Text    = "Auto Expand Materials Bag",
    Default = false,
})
Toggles.AutoExpandMat:OnChanged(function()
    RestartExpandIfNeeded()
end)
SellGroup:AddToggle("AutoExpandPot", {
    Text    = "Auto Expand Potions Bag",
    Default = false,
})
Toggles.AutoExpandPot:OnChanged(function()
    RestartExpandIfNeeded()
end)
local ProgLeft  = Tabs.Misc:AddLeftGroupbox("Unlocks")
local ProgRight = Tabs.Misc:AddRightGroupbox("Upgrades")
ProgLeft:AddButton({
    Text = "Unlock All GamePass",
    Func = function()
        UnlockGamePass()
    end,
})
ProgRight:AddToggle("AutoStatPoints", {
    Text    = "Auto Stat Points",
    Default = false,
})
Toggles.AutoStatPoints:OnChanged(function(state)
    Thread("AutoStatPoints", AutoStatLoop, state)
end)
ProgRight:AddDropdown("StatAllocTypes", {
    Values     = STAT_ATTR_NAMES,
    Default    = {},
    Multi      = true,
    Text       = "Stats to Allocate",
    AllowNull  = true,
})
ProgRight:AddToggle("AutoAscend", {
    Text    = "Auto Ascension",
    Default = false,
})
Toggles.AutoAscend:OnChanged(function(state)
    Thread("AutoAscend", AutoAscendLoop, state)
end)
local Misc2 = Tabs.Misc:AddLeftGroupbox("Utilities2")
Misc2:AddToggle("HopNoTarget", {
    Text    = "Hop if Target Not in Server",
    Default = false,
})
Toggles.HopNoTarget:OnChanged(function(state)
    Thread("HopNoTarget", HopTarLoop, state)
end)
Misc2:AddDropdown("HopTargetNPCs", {
    Values     = TargetDisplayNames,
    Default    = {},
    Text       = "Target NPCs",
    AllowNull  = true,
    Searchable = true,
    Multi      = true,
})
Misc2:AddDropdown("TargetRace", {
    Values     = RaceDisplayNames,
    Default    = {},
    Text       = "Target Race",
    AllowNull  = true,
    Searchable = true,
})
Misc2:AddToggle("AutoRaceReroll", {
    Text    = "Auto Race Reroll",
    Default = false,
})
Toggles.AutoRaceReroll:OnChanged(function(state)
    Thread("AutoRaceReroll", AutoRaceRerollLoop, state)
end)
local Misc1 = Tabs.Misc:AddRightGroupbox("Utilities")
_npcDisplayNames, _npcDisplayToRaw = BuildNPCList()
Misc1:AddDropdown("TargetNPC", {
    Values     = _npcDisplayNames,
    Default    = {},
    Text       = "Select NPC",
    AllowNull  = true,
    Searchable = true,
})
Misc1:AddButton({ Text = "Teleport to NPC", Func = DoTPtoNPC })
local function OpenEquipShop(tab)
    local showUI = _UtilsSystem and _UtilsSystem.Event and _UtilsSystem.Event.ShowLocalUI
    if not showUI then
        Library:Notify("EquipShop: ShowLocalUI not available.", 3)
        return
    end
    showUI:Fire("EquipShop", { tab = tab }, true)
end
Misc1:AddButton({ Text = "Shop",  Func = function() OpenEquipShop("WeaponSell") end })
local ServerGroup  = Tabs.Character:AddLeftGroupbox("Server")
local PlayerGroup = Tabs.Character:AddRightGroupbox("Player")
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
Toggles.FPSBoost:OnChanged(function(state)
    ApplyFPSBoost(state)
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
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", {
    Text    = "Auto Show UI",
    Default = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
	Default  = Library.KeybindFrame.Visible,
	Text     = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text     = "Custom Cursor",
	Default  = false,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values   = { "Left", "Right" },
	Default  = "Right",
	Text     = "Notification Side",
	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default  = "100%",
	Text     = "DPI Scale",
	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)
		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
    getgenv().ayasemiyatongekissazumirisa = false
    Toggles.AutoCollect:SetValue(false)
    Toggles.HitNearest:SetValue(false)
    Toggles.AutoChest:SetValue(false)
    Toggles.InstantKill:SetValue(false)
    Toggles.AutoFarm:SetValue(false)
    Toggles.AutoBrew:SetValue(false)
    Toggles.AutoRefine:SetValue(false)
    Toggles.AutoSell:SetValue(false)
    Toggles.AutoExpandMat:SetValue(false)
    Toggles.AutoExpandPot:SetValue(false)
    Toggles.AutoStatPoints:SetValue(false)
    Toggles.AutoAscend:SetValue(false)
    Toggles.AutoRaceReroll:SetValue(false)
    Toggles.DupeQuest:SetValue(false)
    Toggles.AutoQuest:SetValue(false)
    Toggles.AutoBlock:SetValue(false)
    Toggles.AutoSkill:SetValue(false)
    AnimLogger.Close()
    EffectLogger.Close()
    if activeBodyHRP then disableBodyControl(activeBodyHRP) end
    Cleanup(Connections)
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/WizardAlchemy")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
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
