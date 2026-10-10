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
local PGui = Plr.PlayerGui
local Lighting = Services.Lighting
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
local Events  = RS:WaitForChild("Events")
local VotesFolder = Events:FindFirstChild("Votes")
local SummoningFolder = Events:FindFirstChild("Summoning")
local KnitPartyService = RS:FindFirstChild("Shared")
    and RS.Shared:FindFirstChild("Packages")
    and RS.Shared.Packages:FindFirstChild("Knit")
    and RS.Shared.Packages.Knit:FindFirstChild("Services")
    and RS.Shared.Packages.Knit.Services:FindFirstChild("PartyService")
local PartyRF = KnitPartyService and KnitPartyService:FindFirstChild("RF")
local Remotes = {
    AskCreating = Events:FindFirstChild("AskCreating"),
    AskUpgrade  = Events:FindFirstChild("AskUpgrade"),
    AskSell     = Events:FindFirstChild("AskSell"),
    AskPriority = Events:FindFirstChild("AskPriority"),
    AskMatchTime = Events:FindFirstChild("AskMatchTime"),
    AskResultantRewards = Events:FindFirstChild("AskResultantRewards"),
    SendResultWill    = Events:FindFirstChild("SendResultWill"),
    SendResultReplays = Events:FindFirstChild("SendResultReplays"),
    PushVote    = VotesFolder and VotesFolder:FindFirstChild("PushVote"),
    SendVotes   = VotesFolder and VotesFolder:FindFirstChild("SendVotes"),
    LoadUI      = VotesFolder and VotesFolder:FindFirstChild("LoadUI"),
    AskGameSpeed  = Events:FindFirstChild("AskGameSpeed"),
    PushAutoskip  = Events:FindFirstChild("PushAutoskip"),
    AskBaitSummon = SummoningFolder and SummoningFolder:FindFirstChild("AskBaitSummon"),
    CreateParty     = PartyRF and PartyRF:FindFirstChild("CreateParty"),
    LaunchParty     = PartyRF and PartyRF:FindFirstChild("LaunchParty"),
    TakeAction      = PartyRF and PartyRF:FindFirstChild("TakeAction"),
    GetPartyByPlayer = PartyRF and PartyRF:FindFirstChild("GetPartyByPlayer"),
    PartyAdded   = Events:FindFirstChild("PartyAdded"),
    PartyChanged = Events:FindFirstChild("PartyChanged"),
    PartyDeleted = Events:FindFirstChild("PartyDeleted"),
}
local Modules = {
    Utility = GetSafeModule(RS:FindFirstChild("Shared"), "Utility"),
    Data    = GetSafeModule(RS:FindFirstChild("Shared"), "Data"),
}
local Flags = {}
local Tables = {
}
local MDir = "Yuri/FishingTD/Macros"
local MState = {
    Rec          = false,
    Rep          = false,
    Cur          = nil,
    Load         = nil,
    Hooked       = false,
    Step         = 0,
    Total        = 0,
    LabelRef     = nil,
    PendingLabel = nil,
    MatchStart   = nil,
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
    Macro      = {},
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
    local root = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
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
    task.spawn(function()
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end)
end
local function LoadMDir()
    if not writefile then return end
    pcall(function()
        local built = ""
        for _, part in ipairs(MDir:split("/")) do
            built = (built == "") and part or (built .. "/" .. part)
            if not isfolder(built) then
                makefolder(built)
            end
        end
    end)
end
LoadMDir()
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
    local entries = {}
    local i = 1
    while data[tostring(i)] do
        entries[i] = data[tostring(i)]
        i = i + 1
    end
    return { entries = entries }
end
local function SaveMacro(name, macro)
    if not name or name == "" or not writefile then return false end
    LoadMDir()
    local path = MDir .. "/" .. name .. ".json"
    local out = {}
    for i, entry in ipairs(macro.entries) do
        out[tostring(i)] = entry
    end
    local ok = pcall(function()
        writefile(path, HttpService:JSONEncode(out))
    end)
    return ok
end
local function UpdateLabel(suffix, elapsed)
    if MState.LabelRef and MState.LabelRef.SetText then
        local txt
        local timeStr = elapsed and string.format(" [%.2fs]", elapsed) or ""
        if MState.Rec then
            if suffix then
                txt = string.format("Recording [%d] %s%s", MState.Step, suffix, timeStr)
            else
                txt = string.format("Recording [%d]", MState.Step)
            end
        elseif MState.Rep then
            txt = string.format("Replaying [%d / %d]", MState.Step, MState.Total)
            if suffix then txt = txt .. " | " .. suffix .. timeStr end
        else
            txt = "Idle"
            if suffix then txt = txt .. " | " .. suffix end
        end
        if MState.Rec then
            MState.PendingLabel = txt
        else
            local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
            if not ok then
                MState.PendingLabel = txt
            end
        end
    end
end
local function LabelPump()
    while MState.Rec do
        if MState.PendingLabel then
            local txt = MState.PendingLabel
            MState.PendingLabel = nil
            pcall(function() MState.LabelRef:SetText(txt) end)
        end
        task.wait()
    end
end
local function IsBattleActive()
    local gd = RS:FindFirstChild("_GAMEDATA")
    local state = gd and gd:FindFirstChild("State")
    return state ~= nil and state.Value == 1
end
local BattleTimeConn = nil
local function StopTracking()
    if BattleTimeConn then
        BattleTimeConn:Disconnect()
        BattleTimeConn = nil
    end
end
local function StartTracking(startElapsed)
    StopTracking()
    MState.MatchElapsed = startElapsed or 0
    BattleTimeConn = RunService.Heartbeat:Connect(function(dt)
        local gd = RS:FindFirstChild("_GAMEDATA")
        local gameSpeedVal = gd and gd:FindFirstChild("GameSpeed")
        local gameSpeed = (gameSpeedVal and gameSpeedVal.Value) or 1
        MState.MatchElapsed = (MState.MatchElapsed or 0) + dt * gameSpeed
    end)
end
local function GetBattleTime()
    return MState.MatchElapsed
end
local SlotPositions = {}
local MCENTERS = {
    ["The Bottom"]        = Vector3.new(59, 44, -12),
    ["The Beach"]         = Vector3.new(2, 95, 50),
    ["Sakura Park"]       = Vector3.new(58, 99, 10),
    ["Fishtanic"]         = Vector3.new(-11, 136, 4),
    ["Grave Island"]      = Vector3.new(-29, 97, 72),
    ["Underworld"]        = Vector3.new(-10, 96, 58),
    ["Red Carpet Palace"] = Vector3.new(-39, 126, 25),
    ["Frostbite Tower"]   = Vector3.new(44, 155, -21),
}
local FailedPositions = {}
local SpanCache = {}
local SpanCursor = {}
local MapLabelRef = nil
local PosLabelRef = nil
local PCubePool = {
    Free = {},
    Active = {},
}
local function PCubeAcq()
    local part = table.remove(PCubePool.Free)
    if not part then
        part = Instance.new("Part")
        part.Name       = "PCube"
        part.Size       = Vector3.new(0.5, 0.5, 0.5)
        part.Anchored   = true
        part.CanCollide = false
        part.CastShadow = false
        part.Material   = Enum.Material.Neon
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
local function GetCurrentMapName()
    local gd = RS:FindFirstChild("_GAMEDATA")
    local mapVal = gd and gd:FindFirstChild("Map")
    return mapVal and mapVal.Value
end
local function GetCharacter()
    return Plr.Character
end
local function GetGround(pos)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local excluded = {}
    local dummies = workspace:FindFirstChild("Dummies")
    local alive = workspace:FindFirstChild("Alive")
    if dummies then table.insert(excluded, dummies) end
    if alive then table.insert(excluded, alive) end
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "PCube" then table.insert(excluded, v) end
    end
    rayParams.FilterDescendantsInstances = excluded
    local result = workspace:Raycast(pos + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0), rayParams)
    local finalY = result and result.Position.Y or pos.Y
    notyuri("[GetGround] from=(" .. string.format("%.1f,%.1f,%.1f", pos.X, pos.Y, pos.Z) ..
        ") hit=" .. tostring(result ~= nil) ..
        (result and (" hitInstance=" .. tostring(result.Instance and result.Instance:GetFullName())) or "") ..
        " finalY=" .. string.format("%.1f", finalY))
    return finalY
end
local function FailKey(pos)
    return string.format("%d,%d", math.round(pos.X), math.round(pos.Z))
end
local function DoSpan(cache, center, upToCount, spacing)
    cache = cache or {}
    spacing = spacing or 4
    if upToCount <= 0 then return cache end
    if #cache == 0 then
        cache[1] = Vector3.new(center.X, GetGround(center), center.Z)
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
        table.insert(cache, Vector3.new(px, GetGround(Vector3.new(px, center.Y, pz)), pz))
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
local function PosText(mapName)
    if not mapName then return "Not in a game" end
    local lines = {}
    for i = 1, 5 do
        local pos = SlotPositions[mapName] and SlotPositions[mapName][tostring(i)] and SlotPositions[mapName][tostring(i)][1]
        if pos then
            table.insert(lines, string.format("Slot %d: %.1f, %.1f, %.1f", i, pos.X, pos.Y, pos.Z))
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
local function HandleSlotPos(act, slot)
    local mapName = GetCurrentMapName()
    if not mapName then
        Library:Notify("Not in a game — map not detected", 3)
        return
    end
    local slotKey = tostring(slot)
    if act == "reset" then
        if slot then
            if SlotPositions[mapName] then SlotPositions[mapName][slotKey] = nil end
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
    local finalPos = Vector3.new(pos.X, groundY, pos.Z)
    if not SlotPositions[mapName] then SlotPositions[mapName] = {} end
    if act == "set" then
        if not SlotPositions[mapName][slotKey] then SlotPositions[mapName][slotKey] = {} end
        table.insert(SlotPositions[mapName][slotKey], finalPos)
        local count = #SlotPositions[mapName][slotKey]
        Library:Notify("Slot " .. slot .. " pos " .. count .. " set (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] SetPos slot=" .. slot .. " count=" .. count .. " map=" .. mapName .. " Y=" .. string.format("%.2f", finalPos.Y))
    elseif act == "massset" then
        for i = 1, 5 do
            local k = tostring(i)
            if not SlotPositions[mapName][k] then SlotPositions[mapName][k] = {} end
            table.insert(SlotPositions[mapName][k], finalPos)
        end
        Library:Notify("All 5 slots: pos appended (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] MassSetPos map=" .. mapName .. " Y=" .. string.format("%.2f", finalPos.Y))
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
local function GetSlotsFolder()
    local data = Plr:FindFirstChild("Data")
    return data and data:FindFirstChild("Slots")
end
local function GetTowerId(slot)
    local slots = GetSlotsFolder()
    local slotObj = slots and slots:FindFirstChild(tostring(slot))
    if not slotObj then return nil end
    local val = tostring(slotObj.Value)
    return (val ~= "" and val) or nil
end
local function CountPlaced(slot, towerId)
    if not Modules.Utility or not towerId then return 0 end
    local ok, list = pcall(function()
        return Modules.Utility.getTowersByType(towerId, Plr.Name, tostring(slot))
    end)
    if not ok or type(list) ~= "table" then return 0 end
    return #list
end
local function GetMaxPlacements(slot, towerId)
    if not Modules.Data or not towerId then return 0 end
    local towerInfo = Modules.Data.TOWERS and Modules.Data.TOWERS[towerId]
    if not towerInfo then return 0 end
    local max = towerInfo._maxPlacements or 0
    local towersStorage = Plr:FindFirstChild("Data") and Plr.Data:FindFirstChild("TowersStorage")
    local storageEntry = towersStorage and towersStorage:FindFirstChild(tostring(slot))
    if storageEntry then
        local trait = storageEntry:GetAttribute("Trait")
        local traitInfo = trait and Modules.Data.TRAITS and Modules.Data.TRAITS.traits and Modules.Data.TRAITS.traits[trait]
        if traitInfo and traitInfo.typ == "extra_placements" then
            max = max + (traitInfo.data and traitInfo.data.Amount or 0)
        end
    end
    return max
end
local function IsTowerFarm(towerId)
    if not Modules.Data or not Modules.Data.TOWERS or not towerId then return false end
    local towerInfo = Modules.Data.TOWERS[towerId]
    return towerInfo and towerInfo._atkPerWave == true
end
local function GetCurrentWave()
    local gd = RS:FindFirstChild("_GAMEDATA")
    local waveVal = gd and gd:FindFirstChild("Wave")
    return waveVal and waveVal.Value or 0
end
local function GetPlacedTowers()
    local result = {}
    local towersFolder = workspace:FindFirstChild("Towers")
    if not towersFolder then return result end
    for _, tower in ipairs(towersFolder:GetChildren()) do
        if tower:GetAttribute("Owner") == Plr.Name then
            local towerId = tower:GetAttribute("Type")
            local slot = tower:GetAttribute("slotName")
            local upgrade = tower:GetAttribute("Upgrade")
            if towerId and slot and upgrade ~= nil then
                local towersStorage = Plr:FindFirstChild("Data") and Plr.Data:FindFirstChild("TowersStorage")
                local storageEntry = towersStorage and towersStorage:FindFirstChild(slot)
                local nextTier = storageEntry and storageEntry:FindFirstChild(tostring(upgrade + 1))
                local towerInfo = Modules.Data and Modules.Data.TOWERS and Modules.Data.TOWERS[towerId]
                local maxUpgrade = towerInfo and towerInfo.Upgrades and #towerInfo.Upgrades or upgrade
                table.insert(result, {
                    instance    = tower,
                    towerId     = towerId,
                    slot        = slot,
                    upgrade     = upgrade,
                    maxUpgrade  = maxUpgrade,
                    nextCost    = nextTier and nextTier:FindFirstChild("Cost") and nextTier.Cost.Value or nil,
                    isFarm      = IsTowerFarm(towerId),
                })
            end
        end
    end
    return result
end
local function GetCredits()
    local ok, val = pcall(function()
        return Plr.leaderstats.Credits.Value
    end)
    return (ok and val) or 0
end
local function WaitForCredits(amount)
    if GetCredits() >= amount then return true end
    local ok = pcall(function()
        local creditsVal = Plr.leaderstats.Credits
        while Toggles.AutoPlay.Value and creditsVal.Value < amount do
            creditsVal.Changed:Wait()
        end
    end)
    return ok and Toggles.AutoPlay.Value and GetCredits() >= amount
end
local function GetPlacementCost(towerId)
    local towerInfo = Modules.Data and Modules.Data.TOWERS and Modules.Data.TOWERS[towerId]
    local firstUpgrade = towerInfo and towerInfo.Upgrades and towerInfo.Upgrades[1]
    return firstUpgrade and firstUpgrade.Cost or nil
end
local function UpgradeCand(towers)
    local method = Options.UpgradeMethod and Options.UpgradeMethod.Value or "Lowest Level (Spread Upgrade)"
    local focusFarm = Toggles.FocusFarm and Toggles.FocusFarm.Value
    local cash = GetCredits()
    local upgradable = {}
    for _, e in ipairs(towers) do
        if e.upgrade < e.maxUpgrade then
            if not e.nextCost or e.nextCost <= cash then
                table.insert(upgradable, e)
            end
        end
    end
    if #upgradable == 0 then return nil end
    if focusFarm then
        local farms = {}
        for _, e in ipairs(upgradable) do
            if e.isFarm then
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
            local sa, sb = tonumber(a.slot) or 99, tonumber(b.slot) or 99
            if sa ~= sb then return sa < sb end
            return a.upgrade < b.upgrade
        end)
        return upgradable[1]
    end
    return upgradable[1]
end
local function DoUpgrade()
    local towers = GetPlacedTowers()
    local target = UpgradeCand(towers)
    if not target then return false end
    local towerNum = tonumber(target.instance.Name)
    if not towerNum then return false end
    local ok, success = pcall(function()
        return Remotes.AskUpgrade:InvokeServer(towerNum)
    end)
    notyuri("[AutoPlay] AskUpgrade slot=" .. tostring(target.slot) .. " tower=" .. tostring(target.towerId) ..
        " lv=" .. tostring(target.upgrade) .. " ok=" .. tostring(ok and success))
    task.wait(0.1)
    return true
end
local function Func_AutoSellFarm()
    local lastSold = false
    while Toggles.AutoSellFarm.Value do
        local wave = GetCurrentWave()
        local targetWave = tonumber(Options.SellFarmWave.Value) or 0
        if IsBattleActive() and targetWave > 0 and wave >= targetWave then
            if not lastSold then
                lastSold = true
                local sold = 0
                for _, tower in ipairs(GetPlacedTowers()) do
                    if tower.isFarm then
                        local towerNum = tonumber(tower.instance.Name)
                        if towerNum then
                            pcall(function() Remotes.AskSell:InvokeServer(towerNum) end)
                            sold = sold + 1
                        end
                    end
                end
                notyuri("[AutoSellFarm] Sold " .. sold .. " farm towers at wave " .. wave)
            end
        else
            lastSold = false
        end
        task.wait(2)
    end
end
local function Func_AutoSell()
    local lastSold = false
    while Toggles.AutoSell.Value do
        local wave = GetCurrentWave()
        local targetWave = tonumber(Options.SellUnitWave.Value) or 0
        if IsBattleActive() and targetWave > 0 and wave >= targetWave then
            if not lastSold then
                lastSold = true
                local sold = 0
                for _, tower in ipairs(GetPlacedTowers()) do
                    local towerNum = tonumber(tower.instance.Name)
                    if towerNum then
                        pcall(function() Remotes.AskSell:InvokeServer(towerNum) end)
                        sold = sold + 1
                    end
                end
                notyuri("[AutoSell] Sold " .. sold .. " towers at wave " .. wave)
            end
        else
            lastSold = false
        end
        task.wait(2)
    end
end
local function GetGameState()
    local gd = RS:FindFirstChild("_GAMEDATA")
    local stateVal = gd and gd:FindFirstChild("State")
    return stateVal and stateVal.Value
end
local function Func_AutoReplay()
    local firedForThisResult = false
    while Toggles.AutoReplay.Value do
        local state = GetGameState()
        if state and state >= 2 then
            if not firedForThisResult and Remotes.SendResultWill then
                firedForThisResult = true
                pcall(function() Remotes.SendResultWill:FireServer("Replay") end)
                notyuri("[AutoReplay] voted Replay")
            end
        else
            firedForThisResult = false
        end
        task.wait(1)
    end
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
    local firedForThisResult = false
    while Toggles.WHMatchEnd.Value do
        local state = GetGameState()
        if state and state >= 2 then
            if not firedForThisResult then
                firedForThisResult = true
                local outcome = state == 3 and "Victory" or "Defeat"
                local mapName = GetCurrentMapName() or "Unknown"
                local timeTaken = 0
                if Remotes.AskMatchTime then
                    pcall(function() timeTaken = Remotes.AskMatchTime:InvokeServer() or 0 end)
                end
                local mins = math.floor(timeTaken / 60)
                local secs = math.floor(timeTaken % 60)
                local rewardLines = {}
                if Remotes.AskResultantRewards then
                    local ok, rewards = pcall(function()
                        return Remotes.AskResultantRewards:InvokeServer()
                    end)
                    if ok and type(rewards) == "table" then
                        for _, reward in ipairs(rewards) do
                            local isCurrencyOrXp = reward.typ == "currency" or reward.typ == "xp"
                            local name = isCurrencyOrXp and reward.parent or reward.val
                            local amount = isCurrencyOrXp and reward.val or (reward.amount or 1)
                            table.insert(rewardLines, string.format("+%s %s", tostring(amount), tostring(name)))
                        end
                    end
                end
                local desc = string.format(
                    "**%s - %s**\n- Time: %d:%02d\n- Player: ||%s||\n- Rewards:\n%s",
                    mapName, outcome, mins, secs, Plr.Name,
                    #rewardLines > 0 and table.concat(rewardLines, "\n") or "None"
                )
                SendWebhook("Match Finished", desc)
                notyuri("[Webhook] Match finished notification sent")
            end
        else
            firedForThisResult = false
        end
        task.wait(1)
    end
end
local function Func_AutoVoteDifficulty()
    while Toggles.AutoVoteDifficulty.Value do
        local state = GetGameState()
        if state == 0 then
            if Remotes.PushVote then
                local target = Options.VoteDifficulty and Options.VoteDifficulty.Value or "ez"
                pcall(function() Remotes.PushVote:FireServer(target) end)
                notyuri("[AutoVoteDifficulty] voted " .. tostring(target))
            end
        end
        task.wait(1)
    end
end
local function Func_AutoSetSpeed()
    local firedForThisSpeed = nil
    while Toggles.AutoSetSpeed.Value do
        local target = Options.SetSpeed and Options.SetSpeed.Value
        local speedNum = target and tonumber((target:gsub("X", "")))
        local currentSpeed = RS:FindFirstChild("_GAMEDATA") and RS._GAMEDATA:FindFirstChild("GameSpeed") and RS._GAMEDATA.GameSpeed.Value
        if speedNum and Remotes.AskGameSpeed and currentSpeed ~= speedNum and firedForThisSpeed ~= speedNum then
            firedForThisSpeed = speedNum
            SafeInvoke(Remotes.AskGameSpeed, speedNum)
            notyuri("[AutoSetSpeed] requested speed " .. tostring(speedNum))
        elseif currentSpeed == speedNum then
            firedForThisSpeed = speedNum
        end
        task.wait(1)
    end
end
local function Func_AutoSkipWaves()
    while Toggles.AutoSkipWaves.Value do
        local isAutoskip = Plr:GetAttribute("Autoskip")
        if not isAutoskip and Remotes.PushAutoskip then
            pcall(function() Remotes.PushAutoskip:FireServer() end)
            notyuri("[AutoSkipWaves] enabled autoskip")
        end
        task.wait(1)
    end
end
local function Func_AutoFish()
    while Toggles.AutoFish.Value do
        local hasBait = false
        pcall(function()
            hasBait = Plr:FindFirstChild("Data") and Plr.Data:FindFirstChild("ActiveBait") and Plr.Data.ActiveBait.Value ~= ""
        end)
        if hasBait and Remotes.AskBaitSummon then
            pcall(function() Remotes.AskBaitSummon:InvokeServer(1.0) end)
            notyuri("[AutoFish] AskBaitSummon(1.0)")
            task.wait(0.5)
        else
            task.wait(1)
        end
    end
end
local function DoAutoJoin()
    if not Remotes.CreateParty or not Remotes.LaunchParty then
        Library:Notify("Party remotes not found", 3)
        return
    end
    local mapName = Options.LJMap and Options.LJMap.Value or "The Bottom"
    local ok, err = pcall(function()
        Remotes.CreateParty:InvokeServer({
            FriendsOnly = false,
            Elevator = nil,
            Map = mapName,
        })
    end)
    if not ok then
        notyuri("[Joiner] CreateParty failed:", tostring(err))
        return
    end
    notyuri("[Joiner] CreateParty fired for map", mapName)
    task.wait(1)
    local ok2, err2 = pcall(function()
        Remotes.LaunchParty:InvokeServer(Plr.UserId)
    end)
    if ok2 then
        notyuri("[Joiner] LaunchParty fired")
    else
        notyuri("[Joiner] LaunchParty failed:", tostring(err2))
    end
end
local function PlacePhase(currentWave)
    local mapName = GetCurrentMapName()
    local slotOrder = {}
    for i = 1, 5 do table.insert(slotOrder, i) end
    table.sort(slotOrder, function(a, b)
        local oa = tonumber(Options["PlaceOrder" .. a] and Options["PlaceOrder" .. a].Value) or a
        local ob = tonumber(Options["PlaceOrder" .. b] and Options["PlaceOrder" .. b].Value) or b
        return oa < ob
    end)
    local allPlaced = true
    local waitingForCash = false
    for _, slot in ipairs(slotOrder) do
        if not Toggles.AutoPlay.Value then break end
        if waitingForCash then break end
        local placeWave = tonumber(Options["PlaceWave" .. slot] and Options["PlaceWave" .. slot].Value) or 0
        if placeWave > 0 and (currentWave or 0) < placeWave then
            allPlaced = false
        else
            local towerId = GetTowerId(slot)
            if towerId then
                local limit = GetMaxPlacements(slot, towerId)
                local placed = CountPlaced(slot, towerId)
                local need = limit - placed
                if need > 0 then
                    allPlaced = false
                    if not FailedPositions[mapName] then FailedPositions[mapName] = {} end
                    local failed = FailedPositions[mapName]
                    local positions = {}
                    local slotCfg = mapName and SlotPositions[mapName] and SlotPositions[mapName][tostring(slot)]
                    local centerRaw = mapName and MCENTERS[mapName]
                    local center = centerRaw and centerRaw ~= Vector3.new(0, 0, 0) and Vector3.new(centerRaw.X, GetGround(centerRaw), centerRaw.Z) or nil
                    if slotCfg and #slotCfg > 0 then
                        local centerPos = slotCfg[1]
                        local cursorKey = mapName .. ":" .. FailKey(centerPos)
                        if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
                        local cache = SpanCache[cursorKey]
                        local idx = SpanCursor[cursorKey] or 0
                        local collected = 0
                        if #slotCfg >= limit then
                            for i = 1, #slotCfg do
                                if not failed[FailKey(slotCfg[i])] then
                                    table.insert(positions, slotCfg[i])
                                end
                            end
                        end
                        if #positions == 0 then
                            while collected < need do
                                idx = idx + 1
                                DoSpan(cache, centerPos, idx)
                                local pos = cache[idx]
                                if not failed[FailKey(pos)] then
                                    table.insert(positions, pos)
                                    collected = collected + 1
                                end
                            end
                            SpanCursor[cursorKey] = idx
                        end
                    elseif center then
                        local cursorKey = mapName .. ":center"
                        if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
                        local cache = SpanCache[cursorKey]
                        local idx = SpanCursor[cursorKey] or 0
                        local collected = 0
                        while collected < need do
                            idx = idx + 1
                            DoSpan(cache, center, idx)
                            local pos = cache[idx]
                            if not failed[FailKey(pos)] then
                                table.insert(positions, pos)
                                collected = collected + 1
                            end
                        end
                        SpanCursor[cursorKey] = idx
                    end
                    local placedThisCall = 0
                    while true do
                        if not Toggles.AutoPlay.Value then break end
                        placedThisCall = placedThisCall + 1
                        if placedThisCall > #positions then break end
                        local pos = positions[placedThisCall]
                        local cf = CFrame.new(pos)
                        local placeCost = GetPlacementCost(towerId)
                        if placeCost and placeCost > 0 then
                            notyuri("[PlacePhase] waiting for credits slot=" .. slot .. " tower=" .. tostring(towerId) ..
                                " need=" .. placeCost .. " have=" .. GetCredits())
                            if not WaitForCredits(placeCost) then
                                waitingForCash = true
                                break
                            end
                        end
                        local ghost = PCubeAcq()
                        ghost.CFrame = CFrame.new(pos + Vector3.new(0, 0.5, 0))
                        local ok, success, err = pcall(function()
                            return Remotes.AskCreating:InvokeServer({
                                Template     = towerId,
                                Coordinates  = cf,
                                IsSpaceAvail = true,
                                SlotName     = tostring(slot),
                                LinkedTower  = nil,
                            })
                        end)
                        local placedOk = ok and success
                        if placedOk then
                            ghost.Color        = Color3.fromRGB(80, 255, 120)
                            ghost.Transparency = 0.6
                        else
                            ghost.Color        = Color3.fromRGB(255, 80, 80)
                            ghost.Transparency = 0.6
                        end
                        notyuri("[PlacePhase] PLACE slot=" .. slot .. " tower=" .. tostring(towerId) ..
                            " pos=" .. string.format("(%.1f,%.1f,%.1f)", pos.X, pos.Y, pos.Z) ..
                            " ok=" .. tostring(placedOk) .. (placedOk and "" or (" err=" .. tostring(err))))
                        failed[FailKey(pos)] = true
                        if not placedOk then
                            waitingForCash = true
                            break
                        else
                            if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value then
                                DoUpgrade()
                            end
                            if CountPlaced(slot, towerId) >= limit then
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
    while Toggles.AutoPlay.Value do
        if IsBattleActive() then
            local wave = GetCurrentWave()
            local allPlaced = PlacePhase(wave)
            if allPlaced and Toggles.AutoUpgrade and Toggles.AutoUpgrade.Value then
                local didUpgrade = DoUpgrade()
                if not didUpgrade then
                    pcall(function()
                        Plr.leaderstats.Credits.Changed:Wait()
                    end)
                end
            end
            task.wait(0.1)
        else
            PCubeReleaseAll()
            task.wait(1)
        end
    end
end
local function GetRecordKey(towerId)
    local towersFolder = workspace:FindFirstChild("Towers")
    local tower = towersFolder and towersFolder:FindFirstChild(tostring(towerId))
    if not tower then return nil end
    local slotName = tower:GetAttribute("slotName")
    local cf = tower:GetAttribute("Coordinates")
    if not slotName or not cf then return nil end
    return {
        SlotName    = slotName,
        Coordinates = { cf:GetComponents() },
    }
end
local function RecordAct(kind, data, capturedElapsed)
    if not MState.Rec or not MState.Cur then return end
    local elapsed = capturedElapsed
    if not elapsed then return end
    MState.Step = MState.Step + 1
    local entry = { Type = kind, Elapsed = elapsed }
    for k, val in pairs(data or {}) do
        entry[k] = val
    end
    table.insert(MState.Cur.entries, entry)
    UpdateLabel(kind, elapsed)
    notyuri("[Macro Rec] recorded", kind, string.format("%.2f", elapsed))
end
local function MacroHook()
    if MState.Hooked then return end
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local self = ...
        local Method = getnamecallmethod()
        local ret = table.pack(originalNamecall(...))
        if MState.Rec and Method == "InvokeServer" then
            local capturedElapsed = GetBattleTime()
            if rawequal(self, Remotes.AskCreating) then
                local arg2 = select(2, ...)
                if type(arg2) == "table" and arg2.SlotName and arg2.Coordinates then
                    local success = ret[1]
                    if success then
                        local cf = arg2.Coordinates
                        task.defer(function()
                            RecordAct("Place", {
                                Template     = arg2.Template,
                                SlotName     = arg2.SlotName,
                                Coordinates  = { cf:GetComponents() },
                                IsSpaceAvail = arg2.IsSpaceAvail,
                                LinkedTower  = arg2.LinkedTower,
                            }, capturedElapsed)
                        end)
                    else
                        notyuri("[Macro Rec] Place GUARD FAIL: server rejected placement", tostring(ret[2]))
                    end
                end
            elseif rawequal(self, Remotes.AskUpgrade) then
                local towerId = select(2, ...)
                if type(towerId) == "number" then
                    local success = ret[1]
                    if success then
                        task.defer(function()
                            local key = GetRecordKey(towerId)
                            if key then
                                RecordAct("Upgrade", {
                                    SlotName    = key.SlotName,
                                    Coordinates = key.Coordinates,
                                }, capturedElapsed)
                            else
                                notyuri("[Macro Rec] Upgrade GUARD FAIL: tower", tostring(towerId), "not found in workspace.Towers, skipping record")
                            end
                        end)
                    else
                        notyuri("[Macro Rec] Upgrade GUARD FAIL: server rejected upgrade for tower", tostring(towerId), tostring(ret[2]))
                    end
                end
            elseif rawequal(self, Remotes.AskSell) then
                local towerId = select(2, ...)
                if type(towerId) == "number" then
                    local success = ret[1]
                    if success then
                        task.defer(function()
                            local key = GetRecordKey(towerId)
                            if key then
                                RecordAct("Sell", {
                                    SlotName    = key.SlotName,
                                    Coordinates = key.Coordinates,
                                }, capturedElapsed)
                            else
                                notyuri("[Macro Rec] Sell GUARD FAIL: tower", tostring(towerId), "not found in workspace.Towers, skipping record")
                            end
                        end)
                    else
                        notyuri("[Macro Rec] Sell GUARD FAIL: server rejected sell for tower", tostring(towerId))
                    end
                end
            elseif rawequal(self, Remotes.AskPriority) then
                local towerId = select(2, ...)
                if type(towerId) == "number" then
                    task.defer(function()
                        local key = GetRecordKey(towerId)
                        if key then
                            RecordAct("Priority", {
                                SlotName    = key.SlotName,
                                Coordinates = key.Coordinates,
                            }, capturedElapsed)
                        else
                            notyuri("[Macro Rec] Priority GUARD FAIL: tower", tostring(towerId), "not found in workspace.Towers, skipping record")
                        end
                    end)
                end
            end
        end
        return table.unpack(ret, 1, ret.n)
    end))
    MState.Hooked = true
    notyuri("[Macro] __namecall hook installed")
end
local function Func_MacroRecord(state)
    if not state then return end
    if Toggles.LoadMacro and Toggles.LoadMacro.Value then
        Toggles.LoadMacro:SetValue(false)
    end
    MacroHook()
    MState.Cur = { entries = {} }
    MState.Step = 0
    UpdateLabel("Waiting")
    notyuri("[Macro Rec] waiting for battle to start")
    while Toggles.MacroRecord.Value and not IsBattleActive() do
        task.wait()
    end
    if not Toggles.MacroRecord.Value then
        MState.Cur = nil
        MState.Step = 0
        UpdateLabel()
        return
    end
    local ok, matchTime = pcall(function()
        return Remotes.AskMatchTime:InvokeServer()
    end)
    StartTracking((ok and type(matchTime) == "number") and matchTime or 0)
    MState.Rec = true
    UpdateLabel()
    task.spawn(LabelPump)
    notyuri("[Macro Rec] recording started")
    while Toggles.MacroRecord.Value do
        task.wait()
    end
    MState.Rec = false
    StopTracking()
    notyuri("[Macro Rec] recording stopped,", #MState.Cur.entries, "actions")
    local fname = (Options.FileName and Options.FileName.Value) or ""
    if fname == "" then fname = "Macro_" .. os.date("%Y%m%d_%H%M%S") end
    if SaveMacro(fname, MState.Cur) then
        Library:Notify("Macro saved: " .. fname, 4)
        if Options.MacroSelected then
            Options.MacroSelected:SetValues(ListMacros())
        end
    else
        Library:Notify("Failed to save macro (writefile unsupported?)", 4)
    end
    MState.Cur = nil
    MState.Step = 0
    UpdateLabel()
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
local function ResolveLiveTowerId(entry)
    local towersFolder = workspace:FindFirstChild("Towers")
    if not towersFolder or not entry.SlotName or not entry.Coordinates then return nil end
    local targetPos = ArrToCFrame(entry.Coordinates).Position
    for _, tower in ipairs(towersFolder:GetChildren()) do
        if tower:GetAttribute("Owner") == Plr.Name and tower:GetAttribute("slotName") == entry.SlotName then
            local cf = tower:GetAttribute("Coordinates")
            if cf and (cf.Position - targetPos).Magnitude < 0.5 then
                return tonumber(tower.Name)
            end
        end
    end
    return nil
end
local function WaitForCreditsMacro(amount)
    if not amount or amount <= 0 then return true end
    if GetCredits() >= amount then return true end
    local ok = pcall(function()
        local creditsVal = Plr.leaderstats.Credits
        while Toggles.LoadMacro.Value and IsBattleActive() and creditsVal.Value < amount do
            creditsVal.Changed:Wait()
        end
    end)
    return ok and Toggles.LoadMacro.Value and IsBattleActive() and GetCredits() >= amount
end
local function GetMacroEntryCost(entry)
    if entry.Type == "Place" then
        return GetPlacementCost(entry.Template)
    elseif entry.Type == "Upgrade" then
        local towersFolder = workspace:FindFirstChild("Towers")
        local towerId = ResolveLiveTowerId(entry)
        local tower = towerId and towersFolder and towersFolder:FindFirstChild(tostring(towerId))
        if not tower then return nil end
        local upgrade = tower:GetAttribute("Upgrade")
        local towersStorage = Plr:FindFirstChild("Data") and Plr.Data:FindFirstChild("TowersStorage")
        local storageEntry = towersStorage and towersStorage:FindFirstChild(entry.SlotName)
        local nextTier = storageEntry and upgrade ~= nil and storageEntry:FindFirstChild(tostring(upgrade + 1))
        return nextTier and nextTier:FindFirstChild("Cost") and nextTier.Cost.Value or nil
    end
    return nil
end
local function DoAct(entry)
    if entry.Type == "Place" then
        Remotes.AskCreating:InvokeServer({
            Template     = entry.Template,
            Coordinates  = ArrToCFrame(entry.Coordinates),
            IsSpaceAvail = entry.IsSpaceAvail,
            SlotName     = entry.SlotName,
            LinkedTower  = entry.LinkedTower,
        })
    elseif entry.Type == "Upgrade" then
        local towerId = ResolveLiveTowerId(entry)
        if towerId then
            Remotes.AskUpgrade:InvokeServer(towerId)
        else
            notyuri("[Macro Rep] Upgrade SKIP: no live tower matches SlotName", tostring(entry.SlotName))
        end
    elseif entry.Type == "Sell" then
        local towerId = ResolveLiveTowerId(entry)
        if towerId then
            Remotes.AskSell:InvokeServer(towerId)
        else
            notyuri("[Macro Rep] Sell SKIP: no live tower matches SlotName", tostring(entry.SlotName))
        end
    elseif entry.Type == "Priority" then
        local towerId = ResolveLiveTowerId(entry)
        if towerId then
            Remotes.AskPriority:InvokeServer(towerId)
        else
            notyuri("[Macro Rep] Priority SKIP: no live tower matches SlotName", tostring(entry.SlotName))
        end
    end
end
local function Func_MacroReplay()
    local macro = MState.Load
    if not macro or not macro.entries or #macro.entries == 0 then
        return
    end
    MState.Rep = true
    MState.Total = #macro.entries
    MState.Step = 0
    UpdateLabel()
    while Toggles.LoadMacro.Value do
        if not IsBattleActive() then
            UpdateLabel("Waiting")
            while Toggles.LoadMacro.Value and not IsBattleActive() do
                task.wait()
            end
        end
        if not Toggles.LoadMacro.Value then break end
        local ok, matchTime = pcall(function()
            return Remotes.AskMatchTime:InvokeServer()
        end)
        StartTracking((ok and type(matchTime) == "number") and matchTime or 0)
        notyuri("[Macro Rep] battle active, starting replay pass")
        for i, entry in ipairs(macro.entries) do
            if not Toggles.LoadMacro.Value then break end
            if not IsBattleActive() then
                notyuri("[Macro Rep] battle ended mid-replay, aborting pass")
                break
            end
            MState.Step = i
            UpdateLabel(entry.Type, entry.Elapsed)
            local replayMode = Options.ReplayMode and Options.ReplayMode.Value or "Timed"
            if replayMode == "Money" then
                if entry.Type == "Place" or entry.Type == "Upgrade" then
                    local cost = GetMacroEntryCost(entry)
                    if cost and cost > 0 then
                        if not WaitForCreditsMacro(cost) then
                            notyuri("[Macro Rep] money wait aborted (toggle off / battle ended)")
                        end
                    end
                end
            else
                while Toggles.LoadMacro.Value and IsBattleActive() do
                    local elapsed = GetBattleTime()
                    if elapsed and elapsed >= entry.Elapsed then break end
                    task.wait()
                end
            end
            if Toggles.LoadMacro.Value and IsBattleActive() then
                local ok2, err = pcall(DoAct, entry)
                if not ok2 then
                    notyuri("[Macro Rep] action failed:", tostring(err))
                end
            end
        end
        StopTracking()
        UpdateLabel("Finished")
        notyuri("[Macro Rep] pass complete, waiting for next battle")
        while Toggles.LoadMacro.Value and IsBattleActive() do
            task.wait()
        end
    end
    StopTracking()
    MState.Rep = false
    MState.Step = 0
    UpdateLabel()
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
    AutoPlay = Window:AddTab("Auto Play"),
    Joiner = Window:AddTab("Joiner"),
    Player = Window:AddTab("Player"),
    Webhook = Window:AddTab("Webhook"),
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
        T2 = TB.Main.Left.Autofarm:AddTab("Game"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Game Config"),
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
TB_Tabs.Autofarm.T1:AddDropdown("MacroSelected", {
    Text    = "Select File",
    Values  = ListMacros(),
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
if Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
    MState.Load = LoadMacro(Options.MacroSelected.Value)
end
TB_Tabs.Autofarm.T1:AddInput("FileName", {
    Text        = "File Name",
    Default     = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T1:AddToggle("MacroRecord", {
    Text    = "Record Macro",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddDropdown("ReplayMode", {
    Text    = "Replay Mode",
    Values  = { "Time", "Money" },
    Default = "Time",
})
TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", {
    Text    = "Play Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
Toggles.MacroRecord:OnChanged(function(state)
    Func_MacroRecord(state)
end)
Toggles.LoadMacro:OnChanged(function(state)
    if state then
        if not MState.Load and Options.MacroSelected and Options.MacroSelected.Value and Options.MacroSelected.Value ~= "" then
            MState.Load = LoadMacro(Options.MacroSelected.Value)
        end
    end
    Thread("LoadMacro", SafeLoop("Macro Replay", Func_MacroReplay), state)
end)
local APLeft  = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
local APRight = Tabs.AutoPlay:AddRightGroupbox("Limits")
APLeft:AddToggle("AutoPlay", {
    Text    = "Auto Play",
    Default = false,
})
APLeft:AddDivider()
APLeft:AddDropdown("UpgradeMethod", {
    Text    = "Upgrade Method",
    Values  = {
        "Lowest Level (Spread Upgrade)",
        "Hotbar left to right (until Max)",
        "Randomize",
        "Customize upgrade order (Set below)",
    },
    Default = "Lowest Level (Spread Upgrade)",
})
APLeft:AddDivider()
APLeft:AddToggle("AutoUpgrade", {
    Text    = "Auto Upgrade",
    Default = false,
})
APLeft:AddToggle("PlaceAndUpgrade", {
    Text    = "Place and Upgrade",
    Default = false,
})
APLeft:AddToggle("FocusFarm", {
    Text    = "Focus on Farm",
    Default = false,
})
APRight:AddLabel("Place Order per Slot", true)
for i = 1, 5 do
    APRight:AddSlider("PlaceOrder" .. i, {
        Text     = "Slot " .. i,
        Default  = i,
        Min      = 1,
        Max      = 5,
        Rounding = 0,
        Compact  = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Place Wave per Slot", true)
for i = 1, 5 do
    APRight:AddSlider("PlaceWave" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 50,
        Rounding = 0,
        Compact  = true,
    })
end
local Pos_A = Tabs.AutoPlay:AddLeftGroupbox("Set Position")
local Pos_B = Tabs.AutoPlay:AddRightGroupbox("Position Manage")
Pos_A:AddLabel("Stand where you want towers placed, select a slot, then press Set Slot Position.", true)
MapLabelRef = Pos_A:AddLabel("Current Map: ...", true)
Pos_A:AddDropdown("SetSlotSelect", {
    Text    = "Set Slot Position",
    Values  = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5" },
    Default = "Slot 1",
})
Pos_A:AddButton({
    Text = "Set Slot Position",
    Func = function()
        local val  = Options.SetSlotSelect and Options.SetSlotSelect.Value or "Slot 1"
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
Pos_B:AddDropdown("ResetSlotSelect", {
    Text    = "Reset Position",
    Values  = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "All Slots" },
    Default = "Slot 1",
})
Pos_B:AddButton({
    Text = "Reset Slot Positions",
    Func = function()
        local val = Options.ResetSlotSelect and Options.ResetSlotSelect.Value or "Slot 1"
        if val == "All Slots" then
            ResetPos(nil)
        else
            local slot = tonumber(val:match("%d+"))
            ResetPos(slot)
        end
    end,
})
Toggles.AutoPlay:OnChanged(function(v)
    Thread("AutoPlay", SafeLoop("AutoPlay", Func_AutoPlay), v)
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoSell", {
    Text    = "Auto Sell",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoSellFarm", {
    Text    = "Auto Sell Farm",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddSlider("SellUnitWave", { Text = "Sell Wave", Default = 0, Min = 0, Max = 50, Rounding = 0 })
TB_Tabs.Autofarm2.T1:AddSlider("SellFarmWave", { Text = "Sell Farm Wave", Default = 0, Min = 0, Max = 50, Rounding = 0 })
Toggles.AutoSell:OnChanged(function(v)
    Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSell), v)
end)
Toggles.AutoSellFarm:OnChanged(function(v)
    Thread("AutoSellFarm", SafeLoop("AutoSellFarm", Func_AutoSellFarm), v)
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoReplay", {
    Text    = "Auto Replay",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoVoteDifficulty", {
    Text    = "Auto Vote Difficulty",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("VoteDifficulty", {
    Text    = "Difficulty",
    Values  = { "ez", "mid", "hard", "hazardous" },
    Default = "ez",
})
Toggles.AutoReplay:OnChanged(function(v)
    Thread("AutoReplay", SafeLoop("AutoReplay", Func_AutoReplay), v)
end)
Toggles.AutoVoteDifficulty:OnChanged(function(v)
    Thread("AutoVoteDifficulty", SafeLoop("AutoVoteDifficulty", Func_AutoVoteDifficulty), v)
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoSetSpeed", {
    Text    = "Auto Set Speed",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("SetSpeed", {
    Text    = "Speed",
    Values  = { "X1", "X2", "X3" },
    Default = "X1",
})
Toggles.AutoSetSpeed:OnChanged(function(v)
    Thread("AutoSetSpeed", SafeLoop("AutoSetSpeed", Func_AutoSetSpeed), v)
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoSkipWaves", {
    Text    = "Auto Skip Waves",
    Default = false,
})
Toggles.AutoSkipWaves:OnChanged(function(v)
    Thread("AutoSkipWaves", SafeLoop("AutoSkipWaves", Func_AutoSkipWaves), v)
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoFish", {
    Text    = "Auto Fish",
    Default = false,
})
Toggles.AutoFish:OnChanged(function(v)
    Thread("AutoFish", SafeLoop("AutoFish", Func_AutoFish), v)
end)
local WH1 = Tabs.Webhook:AddLeftGroupbox("Webhook")
WH1:AddInput("WebhookURL", { Text = "Webhook URL", Default = "" })
WH1:AddToggle("WHMatchEnd", { Text = "Match Finished", Default = false })
Toggles.WHMatchEnd:OnChanged(function(v)
    Thread("WHMatchEnd", SafeLoop("WHMatchEnd", Func_WHMatchEnd), v)
end)
local LJ = Tabs.Joiner:AddLeftGroupbox("Lobby")
LJ:AddDropdown("LJMap", {
    Text    = "Map",
    Values  = { "The Bottom", "The Beach", "Sakura Park", "Fishtanic", "Grave Island", "Underworld", "Red Carpet Palace", "Frostbite Tower" },
    Default = "The Bottom",
})
LJ:AddToggle("AutoJoin", {
    Text    = "Auto Join",
    Default = false,
})
Toggles.AutoJoin:OnChanged(function(v)
    if not v then return end
    DoAutoJoin()
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
    MState.Rec = false
    MState.Rep = false
    Cleanup(Connections)
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/FishingTD")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:SetLoadingOrder(true, {"Dropdown", "Slider", "ColorPicker", "KeyPicker", "Input", "Toggle"})
task.defer(function()
    SaveManager:LoadAutoloadConfig()
end)
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