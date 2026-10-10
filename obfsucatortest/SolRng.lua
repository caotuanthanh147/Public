if script_key == nil or script_key ~= "Yuri(Heart)" then
    game:GetService("Players").LocalPlayer:Kick("Lesbian")
    return
end
if script_key == nil or script_key ~= "Yuri(Heart)" then
    game:GetService("Players").LocalPlayer:Kick("Lesbian")
    return
end
if getgenv().ayasemiyatongekissazumirisa then
    warn("watch more yuri")
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
local CoreGui           = Services.CoreGui
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local TweenService = Services.TweenService
local Workspace    = Services.Workspace
local PFS = Services.PathfindingService
local v, Asset = pcall(function()
    return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "sailor piece"
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
    repeat task.wait() until result ~= nil
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
    end
end
local _DR = GetRemote(RS, "RemoteEvents.DashRemote")
local _FS = (_DR and _DR.FireServer)
local Remotes = {
    SettingsToggle = GetRemote(RS, "RemoteEvents.SettingsToggle"),
    SettingsSync = GetRemote(RS, "RemoteEvents.SettingsSync"),
}
local Modules = {
  BossConfig = GetSafeModule(RS.Modules, "BossConfig") or {Bosses = {}},
  TimedConfig = GetSafeModule(RS.Modules, "TimedBossConfig"),
}
local Fishing = require(RS:WaitForChild("Packets"):WaitForChild("Fishing"))
do
    local function patchRemote(remote)
        if not getconnections then return end
        local conns = getconnections(remote.OnClientEvent)
        for _, conn in ipairs(conns) do
            local origFn = conn.Function
            if not origFn then continue end
            conn:Disconnect()
            remote.OnClientEvent:Connect(function(...)
                local ok, e = pcall(origFn, ...)
                if not ok then
                end
            end)
        end
    end
    local ok2, e2 = pcall(function()
        patchRemote(RS:WaitForChild("ByteNetReliable", 5))
        patchRemote(RS:WaitForChild("ByteNetUnreliable", 5))
    end)
    if not ok2 then end
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
local _gscBindable = Instance.new("BindableEvent")
local _gscTarget = nil
_gscBindable.Event:Connect(function()
    local guiObject = _gscTarget
    if not guiObject then return end
    local success, err = pcall(function()
        local vim = Services.VirtualInputManager
        Services.GuiService.SelectedObject = guiObject
        local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
        for _, key in ipairs(keys) do
            vim:SendKeyEvent(true, key, false, game); task.wait(0.03)
            vim:SendKeyEvent(false, key, false, game)
        end
        Services.GuiService.SelectedObject = nil
    end)
    if not success then
    end
end)
function gsc(guiObject)
    if not guiObject then return false end
    _gscTarget = guiObject
    _gscBindable:Fire()
    return true
end
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local gui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainInterface")
local function inRange(size, minX, maxX, minY, maxY)
    return size.X >= minX and size.X <= maxX
       and size.Y >= minY and size.Y <= maxY
end
do
    for i, v in ipairs(gui:GetDescendants()) do
        if v:IsA("Frame") then
            local size = v.AbsoluteSize
            if inRange(size, 393, 400, 197, 200) then
                v:SetAttribute("YuriShop", true)
            end
        end
    end
end
do
    for _, v in ipairs(gui:GetDescendants()) do
        if v:IsA("ImageLabel") and not v:FindFirstAncestorWhichIsA("Frame") then
            local size = v.AbsoluteSize
            if inRange(size, 0, 2, 10, 15) and v.BackgroundTransparency >= 0.3 then
                v:SetAttribute("YuriPBar", true)
                break
            end
        end
    end
end
do
    for _, v in ipairs(gui:GetDescendants()) do
        if v:IsA("ImageLabel") and not v:FindFirstAncestorWhichIsA("Frame") then
            local size = v.AbsoluteSize
            if inRange(size, 50, 70, 10, 15) and v.BackgroundTransparency == 0.5 then
                v:SetAttribute("YuriTBar", true)
                break
            end
        end
    end
end
local function SearchButton(text)
    local mainUI = PGui:FindFirstChild("MainInterface")
    if not mainUI then return nil end
    for _, obj in ipairs(mainUI:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Text == text then
            return obj.Parent
        end
    end
    return nil
end
local _fishRewardPending = false
local _fishBegan = false
local _fishCastToken = 0
local _autoSellBusy = false
local function getNearestSpotId(position)
    local ok, fp = pcall(function()
        return Workspace:WaitForChild("Map")
            :WaitForChild("Miscs")
            :WaitForChild("FishingPoints")
    end)
    if not ok or not fp then
        return nil, nil
    end
    local best, bestDist = nil, math.huge
    for _, spot in ipairs(fp:GetChildren()) do
        local plrLoc = spot:GetAttribute("plrLoc")
        if plrLoc then
            local dist = (plrLoc.Position - position).Magnitude
            if dist < bestDist then
                bestDist = dist
                best = spot
            end
        end
    end
    if best then
        local spotId = best:GetAttribute("spotId")
        local spotCF = best:GetAttribute("plrLoc")
        return spotId, spotCF
    end
    return nil, nil
end
local function wrapListener(packet, fn)
    local existing = {}
    if packet.getListeners then
        for _, cb in ipairs(packet.getListeners()) do
            existing[#existing + 1] = cb
        end
    end
    packet.listen(function(data)
        task.spawn(fn, data)
        for _, cb in ipairs(existing) do
            task.spawn(cb, data)
        end
    end)
end
if not getgenv()._ayaseFishListeners then
    getgenv()._ayaseFishListeners = true
wrapListener(Fishing.beginFishing, function(v)
    _fishBegan = true
end)
wrapListener(Fishing.changeReadyText, function(v)
end)
wrapListener(Fishing.fishInfo, function(v)
end)
wrapListener(Fishing.playGame, function(data)
    if not Toggles.AutoFish.Value then return end
    _fishCastToken += 1
    local myToken = _fishCastToken
    task.spawn(function()
        local function findBars()
            local gui = PGui:FindFirstChild("MainInterface")
            if not gui then
                return nil, nil
            end
            local goal, player
            for _, v in ipairs(gui:GetDescendants()) do
                if v:GetAttribute("YuriTBar") == true then
                    goal = v
                end
                if v:GetAttribute("YuriPBar") == true then
                    player = v
                end
                if goal and player then break end
            end
            return goal, player
        end
        local goalBar, playerBar
        repeat
            task.wait(0.05)
            goalBar, playerBar = findBars()
        until (goalBar and playerBar) or not Toggles.AutoFish.Value
        local clickGui = Instance.new("ScreenGui")
        clickGui.Name = "YuriFishClick"
        clickGui.ResetOnSpawn = false
        clickGui.Parent = Plr.PlayerGui
        local clickBtn = Instance.new("ImageButton")
        clickBtn.Size = UDim2.new(0, 200, 0, 60)
        clickBtn.Position = UDim2.new(0.5, -100, 0.5, -30)
        clickBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Visible = false
        clickBtn.Parent = clickGui
        local clicks = 0
        while Toggles.AutoFish.Value and myToken == _fishCastToken do
            local goalLeft   = goalBar.Position.X.Scale
            local goalWidth  = goalBar.Size.X.Scale
            local goalRight  = goalLeft + goalWidth
            local playerFill = playerBar.Size.X.Scale
            local goalCenter = goalLeft + goalWidth / 3
            if playerFill < goalCenter then
                gsc(clickBtn)
                clicks += 1
                task.wait()
            else
                task.wait()
            end
        end
        clickGui:Destroy()
    end)
end)
wrapListener(Fishing.gameResult, function(v)
    local ok, s = pcall(function() return HttpService:JSONEncode(v) end)
    _fishCastToken += 1
end)
wrapListener(Fishing.reward, function(data)
    if data.rewardInfo then
    else
    end
    _fishRewardPending = true
end)
end 
local EGG_TYPES = {
    DREAMER    = {color=Color3.fromRGB(148,0,211),  priority=1,  name="Dreamer"},
    EGG_V2     = {color=Color3.fromRGB(255,140,0),  priority=2,  name="Egg V2"},
    SKY        = {color=Color3.fromRGB(135,206,250), priority=2, name="Sky"},
    FOREST     = {color=Color3.fromRGB(34,139,34),  priority=3,  name="Forest"},
    BLOOMING   = {color=Color3.fromRGB(255,105,180), priority=3, name="Blooming"},
    ANGELIC    = {color=Color3.fromRGB(255,255,180), priority=4, name="Angelic"},
    ANDROMEDA  = {color=Color3.fromRGB(75,0,130),   priority=4,  name="Andromeda"},
    ROYAL      = {color=Color3.fromRGB(160,32,240),  priority=5, name="Royal"},
    HATCH      = {color=Color3.fromRGB(255,215,0),  priority=6,  name="Hatch"},
    POTION_EGG_2={color=Color3.fromRGB(0,200,200),  priority=7,  name="Potion 2"},
    POTION_EGG_1={color=Color3.fromRGB(0,150,150),  priority=8,  name="Potion 1"},
    POINT_EGG_6={color=Color3.fromRGB(255,50,50),   priority=9,  name="Point 6"},
    POINT_EGG_5={color=Color3.fromRGB(255,100,50),  priority=10, name="Point 5"},
    POINT_EGG_4={color=Color3.fromRGB(255,170,0),   priority=11, name="Point 4"},
    POINT_EGG_3={color=Color3.fromRGB(255,215,0),   priority=12, name="Point 3"},
    POINT_EGG_2={color=Color3.fromRGB(150,200,50),  priority=13, name="Point 2"},
    POINT_EGG_1={color=Color3.fromRGB(100,200,100), priority=14, name="Point 1"},
    PLACEHOLDER={color=Color3.fromRGB(128,128,128), priority=15, name="Placeholder"},
    NORMAL     = {color=Color3.fromRGB(200,200,200), priority=15, name="Normal"},
}
local SOL_ZONES = {
    {name="BigIsland",    pos=Vector3.new(-36.9,95.3,-110.2),  radius=100, enabled=true,  waterOnly=true},
    {name="SmallIsland",  pos=Vector3.new(42.5,101.3,-425.4),  radius=50,  enabled=true,  waterOnly=true},
    {name="ParkourZone",  pos=Vector3.new(216.2,98.5,-617.6),  radius=50,  enabled=true,  waterOnly=false},
    {name="BenchBooth",   pos=Vector3.new(240.2,95.2,-248.8),  radius=12.5,enabled=true,  waterOnly=false, hidden=true},
    {name="JumpTrap",     pos=Vector3.new(456.5,107,-409.3),   radius=15,  enabled=true,  waterOnly=false, hidden=true},
    {name="MountainTrap", pos=Vector3.new(540.4,95,-112.4),    radius=50,  enabled=true,  waterOnly=false, hidden=true},
}
local SolState = {
    Status="IDLE", Collected=0, FarmStartTime=0,
    EggsCache={}, Blacklist={}, IsResetting=false,
    OriginalWalkSpeed=20, CollectedByType={},
}
local function SolGetSpeed()
    return 20
end
local function SolGetFarmMode()
    return Options.SolFarmMode and Options.SolFarmMode.Value or "Priority"
end
local SolUtils = {}
SolUtils.getChar = function() return Plr.Character end
SolUtils.getRoot = function()
    local c = SolUtils.getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
SolUtils.getHum = function()
    local c = SolUtils.getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
SolUtils.isAlive = function(obj)
    return obj and typeof(obj)=="Instance" and obj:IsDescendantOf(game)
end
SolUtils.getAttachPart = function(obj)
    if obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart end
    if obj:IsA("BasePart") then return obj end
    local p = obj:FindFirstChildWhichIsA("BasePart", true)
    if p then return p end
    if obj:IsA("Attachment") and obj.Parent and obj.Parent:IsA("BasePart") then return obj.Parent end
    return nil
end
SolUtils.getLivePosition = function(obj)
    if obj:IsA("Attachment") then return obj.WorldPosition end
    local p = SolUtils.getAttachPart(obj)
    if p and p:IsA("BasePart") then return p.Position end
    local ok, pivot = pcall(function() return obj:GetPivot() end)
    if ok and pivot then return pivot.Position end
    if obj.Parent and obj.Parent:IsA("BasePart") then return obj.Parent.Position end
    return Vector3.new(0,0,0)
end
SolUtils.distanceTo = function(pos)
    local r = SolUtils.getRoot()
    return r and (r.Position-pos).Magnitude or math.huge
end
SolUtils.hDist = function(a,b)
    return math.sqrt((a.X-b.X)^2+(a.Z-b.Z)^2)
end
SolUtils.canWaterWalk = function()
    return Plr:GetAttribute("WaterWalk")==true
end
SolUtils.formatTime = function(s)
    local h=math.floor(s/3600); local m=math.floor((s%3600)/60); local ss=math.floor(s%60)
    return h>0 and string.format("%dh %02dm",h,m) or string.format("%dm %02ds",m,ss)
end
local SolZoneManager = {}
local solZoneFolder = nil
SolZoneManager.init = function()
    local f = Workspace:FindFirstChild("SolZones_ESP")
    if f then f:ClearAllChildren() else f=Instance.new("Folder",Workspace); f.Name="SolZones_ESP" end
    solZoneFolder = f
end
SolZoneManager.isInBlacklist = function(pos)
    local canWater = SolUtils.canWaterWalk()
    for _,z in ipairs(SOL_ZONES) do
        if z.enabled then
            if z.waterOnly and canWater then continue end
            if (pos-z.pos).Magnitude <= z.radius then return true, z.name end
        end
    end
    return false, nil
end
SolZoneManager.isPathSafe = function(waypoints)
    for _,wp in ipairs(waypoints) do
        local inZ,zn = SolZoneManager.isInBlacklist(wp.Position)
        if inZ then return false, zn end
    end
    return true, nil
end
SolZoneManager.drawZones = function()
    if not solZoneFolder then return end
    solZoneFolder:ClearAllChildren()
    if not (Toggles.SolShowZones and Toggles.SolShowZones.Value) then return end
    local canWater = SolUtils.canWaterWalk()
    for _,z in ipairs(SOL_ZONES) do
        if z.enabled and not z.hidden then
            if z.waterOnly and canWater then continue end
            local sp = Instance.new("Part")
            sp.Shape = Enum.PartType.Ball
            sp.Size  = Vector3.new(z.radius*2,z.radius*2,z.radius*2)
            sp.Position  = z.pos
            sp.Anchored  = true
            sp.CanCollide= false
            sp.Material  = Enum.Material.ForceField
            sp.Color     = Color3.fromRGB(255,110,0)
            sp.Transparency = 0.92
            sp.Parent = solZoneFolder
        end
    end
end
local SolEggManager = {}
local solEspFolder = nil
SolEggManager.init = function()
    local f = Workspace:FindFirstChild("SolEgg_ESP")
    if f then f:ClearAllChildren() else f=Instance.new("Folder",Workspace); f.Name="SolEgg_ESP" end
    solEspFolder = f
end
SolEggManager.getType = function(name)
    local l = name:lower()
    if l:find("dreamer")    then return EGG_TYPES.DREAMER end
    if l:find("egg_v2")     then return EGG_TYPES.EGG_V2 end
    if l:find("sky")        then return EGG_TYPES.SKY end
    if l:find("forest")     then return EGG_TYPES.FOREST end
    if l:find("blooming")   then return EGG_TYPES.BLOOMING end
    if l:find("angelic")    then return EGG_TYPES.ANGELIC end
    if l:find("andromeda")  then return EGG_TYPES.ANDROMEDA end
    if l:find("royal")      then return EGG_TYPES.ROYAL end
    if l:find("hatch")      then return EGG_TYPES.HATCH end
    if l:find("potion_egg_2") or l:find("random_potion_egg_2") then return EGG_TYPES.POTION_EGG_2 end
    if l:find("potion_egg_1") or l:find("random_potion_egg_1") then return EGG_TYPES.POTION_EGG_1 end
    if l:find("point_egg_6") then return EGG_TYPES.POINT_EGG_6 end
    if l:find("point_egg_5") then return EGG_TYPES.POINT_EGG_5 end
    if l:find("point_egg_4") then return EGG_TYPES.POINT_EGG_4 end
    if l:find("point_egg_3") then return EGG_TYPES.POINT_EGG_3 end
    if l:find("point_egg_2") then return EGG_TYPES.POINT_EGG_2 end
    if l:find("point_egg_1") then return EGG_TYPES.POINT_EGG_1 end
    if l:find("placeholder") then return EGG_TYPES.PLACEHOLDER end
    return EGG_TYPES.NORMAL
end
SolEggManager.blacklist = function(obj, reason)
    SolState.Blacklist[obj] = {reason=reason, time=tick()}
end
SolEggManager.isBlacklisted = function(obj)
    local d = SolState.Blacklist[obj]; if not d then return false end
    if d.reason and d.reason:find("ZONE") then return true end
    if d.reason=="ZONE_TEMP" then
        if tick()-d.time > 30 then SolState.Blacklist[obj]=nil; return false end
        return true
    end
    if tick()-d.time > 180 then SolState.Blacklist[obj]=nil; return false end
    return true
end
SolEggManager.clearBlacklist = function()
    local kept,cleared=0,0
    for obj,d in pairs(SolState.Blacklist) do
        if d.reason and d.reason:find("ZONE") then kept+=1
        else SolState.Blacklist[obj]=nil; cleared+=1 end
    end
    Library:Notify("Blacklist: "..cleared.." cleared, "..kept.." kept",3)
end
SolEggManager.registerEgg = function(obj)
    if SolState.EggsCache[obj] then return end
    local target = obj
    if obj:IsA("Attachment") then
        if obj.Parent and (obj.Parent:IsA("BasePart") or obj.Parent:IsA("Model")) then
            target=obj.Parent
        else return end
    end
    if SolState.EggsCache[target] then return end
    local prompt = target:FindFirstChildWhichIsA("ProximityPrompt",true)
    if not prompt then return end
    local n = target.Name:lower()
    local pn = (target.Parent and target.Parent.Name:lower()) or ""
    if not (n:find("egg") or pn:find("egg") or n:find("easter") or pn:find("easter")) then return end
    local bestName = n
    if n=="egg" or n=="part" or n=="model" or n=="attachment" then bestName=pn end
    if SolEggManager.getType(bestName).name=="Normal" then bestName=target:GetFullName():lower() end
    local data = {instance=target, prompt=prompt, type=SolEggManager.getType(bestName), failures=0, inZone=false}
    local ok,pos = pcall(function() return SolUtils.getLivePosition(target) end)
    if ok and pos then
        local inZ,zn = SolZoneManager.isInBlacklist(pos)
        if inZ then data.inZone=true; data.zoneName=zn end
    end
    SolState.EggsCache[target] = data
end
SolEggManager.removeEgg = function(obj)
    local d = SolState.EggsCache[obj]
    if d then
        if d.espFolder then pcall(function() d.espFolder:Destroy() end) end
        SolState.EggsCache[obj]=nil; SolState.Blacklist[obj]=nil
    end
end
SolEggManager.updateESP = function()
    local root = SolUtils.getRoot(); if not root then return end
    for obj,data in pairs(SolState.EggsCache) do
        if not SolUtils.isAlive(obj) or not SolUtils.isAlive(data.prompt) then
            SolEggManager.removeEgg(obj); continue
        end
        local bl = SolState.Blacklist[obj]~=nil
        local pos = SolUtils.getLivePosition(obj)
        local inZ,zn = SolZoneManager.isInBlacklist(pos)
        data.inZone=inZ; data.zoneName=zn
        local c = bl and Color3.fromRGB(255,82,82) or (inZ and Color3.fromRGB(255,110,0) or data.type.color)
        if data.espHighlight then data.espHighlight.FillColor=c; data.espHighlight.OutlineColor=c end
        local dist = math.floor((root.Position-pos).Magnitude)
        if data.espDist   then data.espDist.Text="DIST: "..dist.."m" end
        if data.espTitle  then data.espTitle.TextColor3=(bl or inZ) and c or Color3.fromRGB(245,245,235) end
        if data.espStroke then data.espStroke.Color=c end
        if data.espBar    then data.espBar.BackgroundColor3=c end
    end
end
SolEggManager.getBestTarget = function()
    local root = SolUtils.getRoot(); if not root then return nil end
    local best,bestPri,bestDist = nil,999,math.huge
    local mode = SolGetFarmMode()
    for obj,data in pairs(SolState.EggsCache) do
        if SolUtils.isAlive(obj) and SolUtils.isAlive(data.prompt) then
            if SolEggManager.isBlacklisted(obj) then continue end
            if data.inZone then continue end
            local dist = (root.Position-SolUtils.getLivePosition(obj)).Magnitude
            if mode=="Nearest" then
                if dist<bestDist then bestDist=dist; best=data end
            elseif data.type.priority<bestPri or (data.type.priority==bestPri and dist<bestDist) then
                bestPri=data.type.priority; bestDist=dist; best=data
            end
        else SolEggManager.removeEgg(obj) end
    end
    return best
end
SolEggManager.getCount = function()
    local n=0; for _ in pairs(SolState.EggsCache) do n+=1 end; return n
end
local SolMovement = {}
local solPathFolder = nil
SolMovement.init = function()
    local f=Workspace:FindFirstChild("SolPath_ESP")
    if f then f:ClearAllChildren() else f=Instance.new("Folder",Workspace); f.Name="SolPath_ESP" end
    solPathFolder=f
end
SolMovement.isGrounded = function()
    local root=SolUtils.getRoot(); if not root then return false end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    local c=SolUtils.getChar()
    if c then params.FilterDescendantsInstances={c} end
    for _,off in ipairs({Vector3.new(0,0,0),Vector3.new(1,0,0),Vector3.new(-1,0,0),Vector3.new(0,0,1),Vector3.new(0,0,-1)}) do
        if Workspace:Raycast(root.Position+off,Vector3.new(0,-5,0),params) then return true end
    end
    return false
end
SolMovement.hasObstacle = function(targetPos)
    local root=SolUtils.getRoot(); if not root then return false end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    local c=SolUtils.getChar()
    if c then params.FilterDescendantsInstances={c} end
    local dir=(targetPos-root.Position); dir=Vector3.new(dir.X,0,dir.Z)
    if dir.Magnitude<0.1 then return true end; dir=dir.Unit
    for _,h in ipairs({0.5,1.5,2.5}) do
        if Workspace:Raycast(root.Position+Vector3.new(0,h,0),dir*4,params) then return true end
    end
    return false
end
SolMovement.shouldJump = function(targetPos)
    local root=SolUtils.getRoot(); if not root then return false end
    local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude
    local c=SolUtils.getChar(); if c then params.FilterDescendantsInstances={c} end
    local tgr=Workspace:Raycast(targetPos+Vector3.new(0,5,0),Vector3.new(0,-15,0),params)
    local tgy=(tgr and tgr.Position.Y) or targetPos.Y
    local sgr=Workspace:Raycast(root.Position,Vector3.new(0,-10,0),params)
    local sgy=(sgr and sgr.Position.Y) or root.Position.Y
    local diff=tgy-sgy
    if diff<1 then return false end
    if diff<4 then return SolMovement.hasObstacle(targetPos) end
    return true
end
SolMovement.drawPath = function(waypoints, color, isDanger)
    if not solPathFolder then return end
    solPathFolder:ClearAllChildren()
    if #waypoints<2 then return end
    local c = color or Color3.fromRGB(255,208,0)
    local prev=nil
    for i,wp in ipairs(waypoints) do
        local cur=wp.Position+Vector3.new(0,0.4,0)
        if prev then
            local dist=(prev-cur).Magnitude
            local line=Instance.new("Part")
            line.Name="SolLine_"..i
            line.Size=Vector3.new(0.22,0.22,dist)
            line.CFrame=CFrame.lookAt(prev,cur)*CFrame.new(0,0,-dist/2)
            line.Anchored=true; line.CanCollide=false
            line.Material=Enum.Material.Neon
            line.Color=isDanger and Color3.fromRGB(255,82,82) or c
            line.Transparency=isDanger and 0.2 or 0.1
            line.Parent=solPathFolder
        end
        prev=cur
    end
end
SolMovement.stepBack = function()
    local root=SolUtils.getRoot(); local hum=SolUtils.getHum()
    if not root or not hum then return end
    local dir=math.random(1,2)==1 and 1 or -1
    local esc=(root.Position-(root.CFrame.LookVector*15))+(root.CFrame.RightVector*15*dir)
    hum.Jump=true; hum:MoveTo(esc)
    local t=tick()
    while tick()-t<1.5 and Toggles.AutoEgg.Value and (root.Position-esc).Magnitude>=4 do task.wait() end
    hum:MoveTo(root.Position); task.wait(0.2)
end
SolMovement.followPath = function(targetInstance, depth)
    depth = depth or 0
    if depth>3 then SolState.Blacklist[targetInstance]={reason="ZONE_TEMP",time=tick()}; return false,"MAX_DEPTH" end
    local root=SolUtils.getRoot(); local hum=SolUtils.getHum()
    if not root or not hum then return false,"NO_CHAR" end
    local targetPos = SolUtils.getLivePosition(targetInstance)
    local inZ,zn = SolZoneManager.isInBlacklist(targetPos)
    if inZ then
        local d=SolState.EggsCache[targetInstance]; if d then d.inZone=true; d.zoneName=zn end
        return false,"IN_ZONE"
    end
    local path = PFS:CreatePath({AgentRadius=2.5,AgentHeight=5,AgentCanJump=true,AgentCanClimb=false,WaypointSpacing=4})
    local ok=pcall(function() path:ComputeAsync(root.Position,targetPos) end)
    if not ok or path.Status~=Enum.PathStatus.Success then
        local d=SolState.EggsCache[targetInstance]
        if d then d.failures+=1
            if d.failures>=3 then SolEggManager.blacklist(targetInstance,"NO_PATH")
            else SolMovement.stepBack() end
        end
        return false,"NO_PATH"
    end
    local waypoints=path:GetWaypoints()
    local pathSafe,dangerZone=SolZoneManager.isPathSafe(waypoints)
    if not pathSafe then
        SolMovement.drawPath(waypoints,nil,true)
        SolState.Blacklist[targetInstance]={reason="ZONE_TEMP",time=tick()}
        return false,"ZONE_BLOCKED"
    end
    SolMovement.drawPath(waypoints,nil,false)
    hum.WalkSpeed=SolGetSpeed()
    for i,wp in ipairs(waypoints) do
        if not Toggles.AutoEgg.Value or not SolUtils.isAlive(targetInstance) or SolState.IsResetting then
            hum:MoveTo(root.Position); return false,"CANCELLED"
        end
        local wpPos=wp.Position
        local wpZ,_=SolZoneManager.isInBlacklist(wpPos)
        if wpZ then hum:MoveTo(root.Position); return false,"WP_IN_ZONE" end
        hum:MoveTo(wpPos)
        if wp.Action==Enum.PathWaypointAction.Jump and wpPos.Y>=(root.Position.Y-3.5) then
            if SolMovement.isGrounded() then hum:ChangeState(Enum.HumanoidStateType.Jumping); hum.Jump=true end
        end
        local reached=false
        local conn=hum.MoveToFinished:Connect(function() reached=true end)
        local timeout=tick()+3; local stuckT=tick(); local stuckPos=root.Position; local jcd=tick(); local wpStart=tick()
        while not reached and tick()<timeout and Toggles.AutoEgg.Value and not SolState.IsResetting do
            local lp=root.Position; local hd=SolUtils.hDist(lp,wpPos)
            local vel=root.AssemblyLinearVelocity
            local spd=math.sqrt(vel.X^2+vel.Z^2)
            if SolMovement.shouldJump(wpPos) and hd<4 and hd>0.5 and tick()-jcd>0.8 then
                if SolMovement.isGrounded() then hum:ChangeState(Enum.HumanoidStateType.Jumping); hum.Jump=true; jcd=tick() end
            end
            if tick()-wpStart>0.3 and spd<1 and hd>1 and tick()-jcd>0.6 then
                if wpPos.Y>=root.Position.Y-4 and SolMovement.hasObstacle(wpPos) and SolMovement.isGrounded() then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping); hum.Jump=true; jcd=tick()
                end
                hum:MoveTo(wpPos)
            end
            if tick()-stuckT>0.8 then
                if SolUtils.hDist(lp,stuckPos)<0.5 then
                    if SolMovement.isGrounded() then hum:ChangeState(Enum.HumanoidStateType.Jumping); hum.Jump=true; jcd=tick() end
                    hum:MoveTo(wpPos)
                end
                stuckPos=lp; stuckT=tick()
            end
            task.wait(0.02)
        end
        conn:Disconnect()
        if not reached then
            local d=SolState.EggsCache[targetInstance]
            if d then d.failures+=1
                if d.failures>=3 then
                    SolEggManager.blacklist(targetInstance,"STUCK")
                    if Toggles.SolResetOnStuck and Toggles.SolResetOnStuck.Value then SolResetManager.doReset("STUCK") end
                else SolMovement.stepBack() end
            end
            return false,"STUCK"
        end
        local line=solPathFolder and solPathFolder:FindFirstChild("SolLine_"..i)
        if line then line:Destroy() end
    end
    return true,"OK"
end
SolMovement.collectTarget = function(target)
    local root=SolUtils.getRoot(); local hum=SolUtils.getHum()
    if not root or not hum then return false end
    local targetPos=SolUtils.getLivePosition(target.instance)
    local inZ,zn=SolZoneManager.isInBlacklist(targetPos)
    if inZ then SolState.Blacklist[target.instance]={reason="ZONE_TEMP",time=tick()}; return false end
    local reached,reason=SolMovement.followPath(target.instance)
    if not reached then return false end
    if SolUtils.isAlive(target.instance) and SolUtils.isAlive(target.prompt) then
        hum:MoveTo(root.Position); target.prompt.RequiresLineOfSight=false; task.wait(0.1)
        local cok=pcall(function() fireproximityprompt(target.prompt) end)
        if cok then
            SolState.Collected+=1
            local tn=target.type.name; SolState.CollectedByType[tn]=(SolState.CollectedByType[tn] or 0)+1
            Library:Notify("Collected: "..tn.." | Total: "..SolState.Collected,3)
            SolWebhook.notifyCollect(target)
            SolWebhook.notifyMilestone()
            SolEggManager.removeEgg(target.instance)
            task.wait(0.3)
            if Toggles.SolResetOnCollect and Toggles.SolResetOnCollect.Value then SolResetManager.doReset("COLLECTED") end
            return true
        else
            if Toggles.SolResetOnStuck and Toggles.SolResetOnStuck.Value then SolResetManager.doReset("COLLECT FAILED") end
            return false
        end
    end
    return false
end
SolMovement.WalkPos = function(targetPos, checkAlive)
    local root = SolUtils.getRoot()
    local hum = SolUtils.getHum()
    if not root or not hum then return false end
    local ARRIVE_DIST = 5.0
    if (root.Position - targetPos).Magnitude < ARRIVE_DIST then return true end
    local path = PFS:CreatePath({AgentRadius=2, AgentHeight=5, AgentCanJump=true, AgentCanClimb=false, WaypointSpacing=4})
    local ok = pcall(function() path:ComputeAsync(root.Position, targetPos) end)
    if not ok or path.Status ~= Enum.PathStatus.Success then
        hum:MoveTo(targetPos)
        local t0 = tick()
        while checkAlive and checkAlive() do
            task.wait(0.1)
            if (root.Position - targetPos).Magnitude < ARRIVE_DIST then return true end
            if tick() - t0 > 8 then return false end
        end
        return false
    end
    local waypoints = path:GetWaypoints()
    SolMovement.drawPath(waypoints, nil, false)
    hum.WalkSpeed = SolGetSpeed()
    for i, wp in ipairs(waypoints) do
        if not (checkAlive and checkAlive()) then hum:MoveTo(root.Position); SolMovement.drawPath({}, nil, false); return false end
        if wp.Action == Enum.PathWaypointAction.Jump then hum.Jump = true end
        hum:MoveTo(wp.Position)
        local reached = false
        local conn = hum.MoveToFinished:Connect(function() reached = true end)
        local timeout = tick() + 4
        local stuckPos = root.Position; local stuckT = tick(); local jcd = tick()
        while not reached and tick() < timeout and (checkAlive and checkAlive()) do
            local hd = SolUtils.hDist(root.Position, wp.Position)
            if tick() - stuckT > 0.8 then
                if SolUtils.hDist(root.Position, stuckPos) < 0.5 and hd > 1 then
                    if SolMovement.isGrounded() then hum:ChangeState(Enum.HumanoidStateType.Jumping); hum.Jump = true; jcd = tick() end
                    hum:MoveTo(wp.Position)
                end
                stuckPos = root.Position; stuckT = tick()
            end
            task.wait(0.05)
        end
        conn:Disconnect()
        if (root.Position - targetPos).Magnitude < ARRIVE_DIST then SolMovement.drawPath({}, nil, false); return true end
    end
    SolMovement.drawPath({}, nil, false)
    return (root.Position - targetPos).Magnitude < ARRIVE_DIST
end
SolResetManager = {}
SolResetManager.doReset = function(reason)
    if SolState.IsResetting or not (Toggles.SolAutoReset and Toggles.SolAutoReset.Value) then return end
    SolState.IsResetting=true
    local hum=SolUtils.getHum(); if hum then hum.Health=0 end
    local t0=tick()
    while not SolUtils.getRoot() and tick()-t0<10 do task.wait(0.1) end
    task.wait(1); SolState.IsResetting=false
end
SolAuraMonitor = {}
SolAuraMonitor.getCurrent = function() return Plr:GetAttribute("AuraName") end
SolAuraMonitor.getRarity = function()
    local name = Plr:GetAttribute("AuraName")
    if not name then return 0 end
    local TierList = game:GetService("ReplicatedStorage"):FindFirstChild("TierList")
    if not TierList then return 0 end
    local entry = TierList:FindFirstChild(name)
    return entry and entry.Value or 0
end
SolAuraMonitor.check = function()
    if not (Toggles.SolAuraMonitor and Toggles.SolAuraMonitor.Value) then return true end
    local target = Options.SolAuraName and Options.SolAuraName.Value or ""
    if target=="" then return true end
    local current = SolAuraMonitor.getCurrent()
    if current and current:lower()==target:lower() then return true end
    Library:Notify("Wrong aura: "..tostring(current).." | Expected: "..target,5)
    return false
end
SolAuraMonitor.init = function()
    Plr:GetAttributeChangedSignal("AuraName"):Connect(function()
        if Toggles.SolAuraMonitor and Toggles.SolAuraMonitor.Value then SolAuraMonitor.check() end
    end)
    Plr:GetAttributeChangedSignal("WaterWalk"):Connect(function()
        SolZoneManager.drawZones()
    end)
    task.spawn(function()
        task.wait(3)
        while true do
            task.wait(5)
            if Toggles.SolAuraMonitor and Toggles.SolAuraMonitor.Value then SolAuraMonitor.check() end
        end
    end)
end
SolWebhook = {}
local _whQueue={}; local _whBusy=false
local function _whProcess()
    if _whBusy then return end; _whBusy=true
    task.spawn(function()
        while #_whQueue>0 do
            local item=table.remove(_whQueue,1)
            if item then
                pcall(function()
                    local body=HttpService:JSONEncode(item.data)
                    if request then request({Url=item.url,Method="POST",Headers={["Content-Type"]="application/json"},Body=body})
                    elseif http_request then http_request({Url=item.url,Method="POST",Headers={["Content-Type"]="application/json"},Body=body}) end
                end)
            end
            task.wait(2)
        end
        _whBusy=false
    end)
end
local function _whSend(title,desc,color,fields)
    if not (Toggles.SolWebhookEnabled and Toggles.SolWebhookEnabled.Value) then return end
    local url = Options.SolWebhookURL and Options.SolWebhookURL.Value or ""
    if url=="" then return end
    local data={
        username="SolRng Script",
        avatar_url="https://www.roblox.com/headshot-thumbnail/image?userId="..Plr.UserId.."&width=420&height=420&format=png",
        embeds={{title=title,description=desc,color=color or 16776960,
            timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer={text="SolRng | "..Plr.Name},
            fields=fields or {}}}
    }
    table.insert(_whQueue,{data=data,url=url}); _whProcess()
end
local function _whRarityColor(p)
    if p<=2 then return 9699539 elseif p<=3 then return 16711680 elseif p<=6 then return 16776960 elseif p<=8 then return 65535 end
    return 65280
end
local function _whRarityText(p)
    if p<=2 then return "ULTRA RARE" elseif p<=3 then return "VERY RARE" elseif p<=6 then return "RARE" elseif p<=8 then return "UNCOMMON" end
    return "COMMON"
end
SolWebhook.notifyCollect = function(eggData)
    if not (Toggles.SolWebhookCollect and Toggles.SolWebhookCollect.Value) then return end
    local p=eggData.type.priority; local n=eggData.type.name
    local ft=SolState.FarmStartTime>0 and SolUtils.formatTime(tick()-SolState.FarmStartTime) or "N/A"
    _whSend("Egg Collected: "..n,"**"..(_whRarityText(p)).."** collected!",_whRarityColor(p),{
        {name="Egg",value=n,inline=true},{name="Total",value=tostring(SolState.Collected),inline=true},{name="Farm Time",value=ft,inline=true},
        {name="Aura",value=tostring(SolAuraMonitor.getCurrent()),inline=true}
    })
end
SolWebhook.notifyMilestone = function()
    if not (Toggles.SolWebhookMilestone and Toggles.SolWebhookMilestone.Value) then return end
    local interval = Options.SolWebhookInterval and Options.SolWebhookInterval.Value or 10
    if SolState.Collected==0 or SolState.Collected%interval~=0 then return end
    local ft=SolState.FarmStartTime>0 and SolUtils.formatTime(tick()-SolState.FarmStartTime) or "N/A"
    _whSend("Milestone: "..SolState.Collected.." Eggs!","Milestone reached!",65535,{
        {name="Total",value=tostring(SolState.Collected),inline=true},{name="Farm Time",value=ft,inline=true},
        {name="Aura",value=tostring(SolAuraMonitor.getCurrent()),inline=true}
    })
end
local function _whSendRoll(title, desc, color, fields)
    local url = Options.SolWebhookURL and Options.SolWebhookURL.Value or ""
    if url == "" then return end
    local data = {
        username = "SolRng Script",
        avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId="..Plr.UserId.."&width=420&height=420&format=png",
        embeds = {{
            title = title, description = desc, color = color or 16776960,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer = {text = "SolRng | "..Plr.Name},
            fields = fields or {}
        }}
    }
    table.insert(_whQueue, {data=data, url=url})
    _whProcess()
end
SolWebhook.notifyRoll = function(auraName, rarity)
    if not (Toggles.SolWebhookRollEnabled and Toggles.SolWebhookRollEnabled.Value) then return end
    local minRarity = tonumber(Options.SolWebhookRollMin and Options.SolWebhookRollMin.Value) or 0
    if rarity < minRarity then return end
    local rollColor = rarity >= 1000000 and 16711935 or rarity >= 100000 and 9699539 or rarity >= 0 and 16711680 or 16776960
    _whSendRoll("Aura Rolled: "..auraName, "Rolled a **"..auraName.."**!", rollColor, {
        {name="Aura",   value=auraName,                       inline=true},
        {name="Rarity", value="1 in "..CommaFormat(rarity),   inline=true},
        {name="Min",    value=">= "..CommaFormat(minRarity),  inline=true},
        {name="Current Aura", value=tostring(SolAuraMonitor.getCurrent()), inline=true},
    })
end
SolWebhook.initSpawnTracking = function()
    Plr:GetAttributeChangedSignal("AuraName"):Connect(function()
        local name = Plr:GetAttribute("AuraName")
        if not name then return end
        local rarity = SolAuraMonitor.getRarity()
        SolWebhook.notifyRoll(name, rarity)
    end)
end
SolZoneManager.init()
SolEggManager.init()
SolMovement.init()
SolAuraMonitor.init()
SolWebhook.initSpawnTracking()
task.spawn(function()
    while true do
        task.wait(10)
        for _,v in ipairs(Workspace:GetDescendants()) do
            SolEggManager.registerEgg(v)
        end
    end
end)
Workspace.DescendantAdded:Connect(function(d) task.wait(0.1); SolEggManager.registerEgg(d) end)
Workspace.DescendantRemoving:Connect(function(d) SolEggManager.removeEgg(d) end)
Plr.CharacterAdded:Connect(function()
    task.wait(1)
    local hum=SolUtils.getHum()
    if hum then SolState.OriginalWalkSpeed=hum.WalkSpeed end
    if Toggles.SolAutoReset and Toggles.SolAutoReset.Value then SolEggManager.clearBlacklist() end
    task.wait(2); SolZoneManager.drawZones()
end)
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
	Misc = Window:AddTab("Miscellaneous"),
    Config = Window:AddTab("Config"),
}
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
local function AutoSellLoop()
    if _autoSellBusy then
        return
    end
    _autoSellBusy = true
    task.wait(0.5)
    local char = GetCharacter()
    if not char then _autoSellBusy = false return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    local ok, shopObj = pcall(function()
        return Workspace:WaitForChild("Map"):WaitForChild("Miscs"):WaitForChild("FishShop")
    end)
    if not ok or not shopObj then _autoSellBusy = false return end
    local shopPos = shopObj:GetPivot().Position
    local arrived = SolMovement.WalkPos(shopPos, function()
        return hrp and hrp.Parent and hum and hum.Parent
    end)
    if not arrived then _autoSellBusy = false return end
    task.wait(0.3)
    local shopFrame
    for _, v in ipairs(gui:GetDescendants()) do
        if v:IsA("Frame") and v:GetAttribute("YuriShop") == true then
            shopFrame = v
            break
        end
    end
    if not shopFrame then  _autoSellBusy = false return end
    shopFrame.Visible = true
    task.wait(0.5)
    local sellRound = 0
    while true do
        sellRound += 1
        local sellGrid
        for _, v in ipairs(shopFrame:GetDescendants()) do
            if v:IsA("ScrollingFrame") then
                local fc = 0
                for _, c in ipairs(v:GetChildren()) do
                    if c:IsA("Frame") then fc += 1 end
                end
                if fc > 0 then
                    sellGrid = v
                    break
                end
            end
        end
        if not sellGrid then
            break
        end
        local fishFrames = {}
        for _, v in ipairs(sellGrid:GetChildren()) do
            if v:IsA("Frame") then
                table.insert(fishFrames, v)
            end
        end
        if #fishFrames == 0 then
            break
        end
        local imgBtn
        for _, v in ipairs(fishFrames[1]:GetDescendants()) do
            if v:IsA("ImageButton") then imgBtn = v break end
        end
        if imgBtn then
            gsc(imgBtn)
        end
        task.wait(0.3)
        local sellAllBtn
        for _, v in ipairs(shopFrame:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text == "Sell All" then
                sellAllBtn = v.Parent
                break
            end
        end
        if sellAllBtn then
            gsc(sellAllBtn)
        end
        task.wait(0.3)
        local confirmed = false
        local timeout = tick()
        while not confirmed and tick() - timeout < 3 do
            for _, v in ipairs(gui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Text == "Sell" then
                    if v:FindFirstAncestorWhichIsA("CanvasGroup") then
                        local btn = v.Parent
                        if btn:IsA("ImageButton") or btn:IsA("TextButton") then
                            gsc(btn)
                            confirmed = true
                            break
                        end
                    end
                end
            end
            if not confirmed then task.wait(0.1) end
        end
        if not confirmed then end
        task.wait(0.5)
    end
    shopFrame.Visible = false
    _autoSellBusy = false
    Toggles.AutoSell:SetValue(false)
end
local FishGroup = Tabs.Main:AddLeftGroupbox("Fishing")
local PlayerGroup = Tabs.Misc:AddLeftGroupbox("Player")
local ServerGroup = Tabs.Misc:AddRightGroupbox("Server")
FishGroup:AddToggle("AutoFish", {
    Text = "Auto Fish",
    Default = false,
    Callback = function(value)
        Thread("AutoFish", function()
            while Toggles.AutoFish.Value do
                if _autoSellBusy then
                    repeat task.wait(0.5) until not _autoSellBusy or not Toggles.AutoFish.Value
                end
                if not Toggles.AutoFish.Value then break end
                local char = GetCharacter()
                if not char then
                    task.wait()
                    continue
                end
                local hrp = char.HumanoidRootPart
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then
                    task.wait()
                    continue
                end
                local spotId, spotCF = getNearestSpotId(Vector3.new(64, 100, -296))
                if not spotId or not spotCF then
                    task.wait(1)
                    continue
                end
                local targetPos = spotCF.Position
                if _autoSellBusy then
                    repeat task.wait(0.5) until not _autoSellBusy or not Toggles.AutoFish.Value
                end
                if not Toggles.AutoFish.Value then break end
                local arrived = SolMovement.WalkPos(targetPos, function()
                    return Toggles.AutoFish.Value
                        and not _autoSellBusy
                        and hrp and hrp.Parent
                        and hum and hum.Parent
                end)
                if not arrived then
                    if _autoSellBusy then
                        repeat task.wait(0.5) until not _autoSellBusy or not Toggles.AutoFish.Value
                        continue
                    end
                    break
                end
                if not Toggles.AutoFish.Value then break end
                _fishRewardPending = false
                _fishBegan = false
                local ok, err2 = pcall(Fishing.start.send, spotId)
                if not ok then
                    Toggles.AutoSell:SetValue(true)
                    repeat task.wait(0.5) until not _autoSellBusy or not Toggles.AutoFish.Value
                    if not Toggles.AutoFish.Value then break end
                    continue
                end
                local beginTimeout = tick()
                repeat
                    task.wait(0.1)
                until _fishBegan or not Toggles.AutoFish.Value or (tick() - beginTimeout > 1)
                if not Toggles.AutoFish.Value then break end
                if not _fishBegan then
                    Toggles.AutoSell:SetValue(true)
                    repeat task.wait(0.5) until not _autoSellBusy or not Toggles.AutoFish.Value
                    if not Toggles.AutoFish.Value then break end
                    continue
                end
                local lastHeartbeat = tick()
                repeat
                    task.wait(0.1)
                    if tick() - lastHeartbeat >= 3 then
                        lastHeartbeat = tick()
                    end
                until _fishRewardPending or not Toggles.AutoFish.Value
                if not Toggles.AutoFish.Value then break end
                task.wait(.5)
            end
        end, value)
    end
})
FishGroup:AddToggle("AutoSell", {
    Text = "Auto Sell",
    Default = false,
    Callback = function(value)
        if not value then
            _autoSellBusy = false
        end
        Thread("AutoSell", AutoSellLoop, value)
    end
})
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
local EggGroup = Tabs.Main:AddRightGroupbox("Egging")
EggGroup:AddToggle("AutoEgg", {
    Text = "Auto Egg",
    Default = false,
    Callback = function(value)
        Thread("AutoEgg", function()
            SolState.FarmStartTime = tick()
            Library:Notify("Auto Egg " .. (value and "started" or "stopped"), 2)
            while Toggles.AutoEgg.Value do
                while SolState.IsResetting do task.wait(0.1) end
                local target = SolEggManager.getBestTarget()
                if target then
                    SolMovement.collectTarget(target)
                    if solPathFolder then solPathFolder:ClearAllChildren() end
                    task.wait(0.2)
                else
                    local h = SolUtils.getHum()
                    local r = SolUtils.getRoot()
                    if h and r then h:MoveTo(r.Position) end
                    task.wait(1)
                end
            end
            if solPathFolder then solPathFolder:ClearAllChildren() end
        end, value)
    end
})
EggGroup:AddDropdown("SolFarmMode", {
    Text = "Farm Mode",
    Values = {"Priority", "Nearest"},
    Default = "Priority",
})
EggGroup:AddToggle("SolAutoReset", {
    Text = "Auto Reset",
    Default = true,
})
EggGroup:AddToggle("SolResetOnCollect", {
    Text = "Reset After Collect",
    Default = true,
})
EggGroup:AddToggle("SolResetOnStuck", {
    Text = "Reset On Stuck",
    Default = true,
})
EggGroup:AddButton({
    Text = "Clear Blacklist",
    Func = function()
        SolEggManager.clearBlacklist()
    end
})
for _, zone in ipairs(SOL_ZONES) do
    if not zone.hidden then
        local zoneId = "SolZone_" .. zone.name
        EggGroup:AddToggle(zoneId, {
            Text = zone.name .. " (" .. zone.radius .. "m)",
            Default = zone.enabled,
            Callback = function(value)
                zone.enabled = value
                SolZoneManager.drawZones()
            end
        })
    end
end
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "SelectedIsland" })
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/Sol")
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
