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
checkcaller = missing("function", checkcaller, function() return true end)
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
local Remotes = {
    PlaceUnit     = RS:WaitForChild("Remotes"):WaitForChild("PlaceUnit"),
    UpgradeUnit   = RS:WaitForChild("Remotes"):WaitForChild("UpgradeUnitRemoteFunc"),
    RemoveUnit    = RS:WaitForChild("Remotes"):WaitForChild("RemoveUnit"),
    ActivateSkill = RS:WaitForChild("Remotes"):WaitForChild("CTDModuleActivateSkillServer"),
    PauseUnit     = RS:WaitForChild("Remotes"):WaitForChild("PauseUnit"),
}
local MapRemotes = {}
local function GetMapRemotes()
    local Map = workspace:FindFirstChild("Map")
    if not Map then return nil end
    if not MapRemotes.GameEndRestart then
        local ScriptFolder = Map:FindFirstChild("ScriptFolder")
        local GameEndRestart = ScriptFolder and ScriptFolder:FindFirstChild("GameEndRestart")
        MapRemotes.GameEndRestart = GameEndRestart and GameEndRestart:FindFirstChild("RemoteEvent")
    end
    if not MapRemotes.SkipButton then
        local PGuiSkip = PGui:FindFirstChild("SkippingGui")
        local SkipButton = PGuiSkip and PGuiSkip:FindFirstChild("SkipButton")
        MapRemotes.SkipButton = SkipButton and SkipButton:FindFirstChild("RemoteEvent")
        MapRemotes.SkipButtonObj = SkipButton
        MapRemotes.SkippingGui = PGuiSkip
    end
    return MapRemotes
end
local Modules = {
    CTD2Module = require(RS.Modules.CTD2Module),
}
local Flags = {}
local Shared = {
}
local Tables = {
    TowersFolder = workspace:WaitForChild("Towers"),
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
local MDir = "Yuri/CSTD/Macros"
local MState = {
    Rec            = false,
    Rep            = false,
    Cur            = nil,
    Load           = nil,
    Step           = 0,
    Total          = 0,
    LabelRef       = nil,
    Hooked         = false,
    StartClock     = 0,
    CurWave        = 0,
    WaveStartClock = 0,
    PendingLabel   = nil,
}
local function GetCurrentWave()
    local mapCfg = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Configuration")
    local waveVal = mapCfg and mapCfg:FindFirstChild("Wave")
    return waveVal and waveVal.Value or 0
end
local function GetRawTime()
    local mapCfg = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Configuration")
    local timeVal = mapCfg and mapCfg:FindFirstChild("Time")
    return timeVal and timeVal.Value or 0
end
local function GetElapsed()
    return MState.WaveStartClock - GetRawTime()
end
local function GetTimeString()
    return GetCurrentWave() .. " " .. GetElapsed()
end
local function UpdateLabel(suffix, elapsed)
    if not (MState.LabelRef and MState.LabelRef.SetText) then return end
    local txt
    local timeStr = ""
    if type(elapsed) == "number" then
        timeStr = string.format(" [%.2fs]", elapsed)
    elseif type(elapsed) == "string" then
        timeStr = " [" .. elapsed .. "]"
    end
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
    notyuri("[Macro] UpdateLabel", txt)
    if MState.Rec then
        MState.PendingLabel = txt
    else
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
        task.wait()
    end
end
local function CommitEntry(entry, labelSuffix)
    if not MState.Rec or not MState.Cur then return end
    MState.Step = MState.Step + 1
    MState.Cur[MState.Step] = entry
    UpdateLabel(labelSuffix or entry.Type, entry.Time)
end
local function IsOwnedTower(model)
    local cfg = model:FindFirstChild("Configuration")
    return cfg ~= nil and cfg:FindFirstChild("Owner") ~= nil and cfg.Owner.Value == Plr.Name
end
local function GetTowerRef(model)
    local name = model.Name
    local idx  = 0
    for _, child in ipairs(Tables.TowersFolder:GetChildren()) do
        if child.Name == name and IsOwnedTower(child) then
            idx = idx + 1
            if child == model then
                return name .. " - " .. idx
            end
        end
    end
    return name .. " - 1"
end
local function FindTowerByRef(ref)
    local name, idxStr = ref:match("^(.+)%s%-%s(%d+)$")
    if not name or not idxStr then return nil end
    local targetIdx = tonumber(idxStr)
    local count = 0
    for _, child in ipairs(Tables.TowersFolder:GetChildren()) do
        if child.Name == name and IsOwnedTower(child) then
            count = count + 1
            if count == targetIdx then return child end
        end
    end
    return nil
end
local function FindGroundPart(pos)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local exclude = { Tables.TowersFolder }
    if Plr.Character then table.insert(exclude, Plr.Character) end
    local projectiles = workspace:FindFirstChild("Projectiles")
    if projectiles then table.insert(exclude, projectiles) end
    params.FilterDescendantsInstances = exclude
    local result = workspace:Raycast(pos + Vector3.new(0, 25, 0), Vector3.new(0, -100, 0), params)
    return result and result.Instance or nil
end
local function GetGround(pos)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local exclude = { Tables.TowersFolder }
    if Plr.Character then table.insert(exclude, Plr.Character) end
    local projectiles = workspace:FindFirstChild("Projectiles")
    if projectiles then table.insert(exclude, projectiles) end
    params.FilterDescendantsInstances = exclude
    local result = workspace:Raycast(pos + Vector3.new(0, 25, 0), Vector3.new(0, -100, 0), params)
    local finalY = result and result.Position.Y or pos.Y
    notyuri("[GetGround] from=(" .. string.format("%.1f,%.1f,%.1f", pos.X, pos.Y, pos.Z) ..
        ") hit=" .. tostring(result ~= nil) ..
        (result and (" hitInstance=" .. tostring(result.Instance and result.Instance:GetFullName())) or "") ..
        " finalY=" .. string.format("%.1f", finalY))
    return finalY
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
    return data
end
local function SaveMacro(name, macro)
    if not name or name == "" or not writefile then return false end
    LoadMDir()
    local path = MDir .. "/" .. name .. ".json"
    local ok = pcall(function()
        writefile(path, HttpService:JSONEncode(macro))
    end)
    return ok
end
local function StartRec()
    if MState.Hooked then return end
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local self   = ...
        local Method = getnamecallmethod()
        local ret    = table.pack(originalNamecall(...))
        if MState.Rec and not checkcaller() then
            if rawequal(self, Remotes.PlaceUnit) and Method == "InvokeServer" then
                local unitName  = select(2, ...)
                local placeArgs = select(3, ...)
                if type(unitName) == "string" and type(placeArgs) == "table"
                    and typeof(placeArgs.Pos) == "Vector3" and ret[1] ~= nil then
                    local pos = placeArgs.Pos
                    CommitEntry({
                        Type = "Place",
                        Time = GetTimeString(),
                        Unit = unitName,
                        Pos  = { pos.X, pos.Y, pos.Z },
                    }, "Place " .. unitName)
                    notyuri("[Macro Rec] Place recorded", unitName)
                end
            elseif rawequal(self, Remotes.UpgradeUnit) and Method == "InvokeServer" then
                local model = select(2, ...)
                if typeof(model) == "Instance" and ret[1] == true then
                    local ref = GetTowerRef(model)
                    CommitEntry({
                        Type = "Upgrade",
                        Time = GetTimeString(),
                        Ref  = ref,
                    }, "Upgrade " .. ref)
                    notyuri("[Macro Rec] Upgrade recorded", ref)
                end
            elseif rawequal(self, Remotes.RemoveUnit) and Method == "FireServer" then
                local model = select(2, ...)
                if typeof(model) == "Instance" and model:IsDescendantOf(Tables.TowersFolder) then
                    local ref = GetTowerRef(model)
                    task.delay(0.3, function()
                        if not MState.Rec then return end
                        if model.Parent ~= nil then
                            notyuri("[Macro Rec] Sell GUARD FAIL: model still alive at", ref)
                            return
                        end
                        CommitEntry({
                            Type = "Sell",
                            Time = GetTimeString(),
                            Ref  = ref,
                        }, "Sell " .. ref)
                        notyuri("[Macro Rec] Sell recorded", ref)
                    end)
                end
            elseif rawequal(self, Remotes.ActivateSkill) and Method == "FireServer" then
                local model  = select(2, ...)
                local action = select(3, ...)
                local data   = select(4, ...)
                if typeof(model) == "Instance" and model:IsDescendantOf(Tables.TowersFolder)
                    and action == "ActivateSkill" and type(data) == "table"
                    and data.SkillName == "Reposition" and type(data.successinfo) == "table"
                    and typeof(data.successinfo.TargetCF) == "CFrame" then
                    local ref      = GetTowerRef(model)
                    local targetCF = data.successinfo.TargetCF
                    local root     = model:FindFirstChild("HumanoidRootPart")
                    task.delay(0.3, function()
                        if not MState.Rec then return end
                        if not root or not model.Parent then
                            notyuri("[Macro Rec] Move GUARD FAIL: model missing at", ref)
                            return
                        end
                        if (root.CFrame.Position - targetCF.Position).Magnitude > 2 then
                            notyuri("[Macro Rec] Move GUARD FAIL: tower did not move to target at", ref)
                            return
                        end
                        local pos = targetCF.Position
                        CommitEntry({
                            Type = "Move",
                            Time = GetTimeString(),
                            Ref  = ref,
                            Pos  = { pos.X, pos.Y, pos.Z },
                        }, "Move " .. ref)
                        notyuri("[Macro Rec] Move recorded", ref)
                    end)
                end
            elseif rawequal(self, Remotes.PauseUnit) and Method == "FireServer" then
                local model = select(2, ...)
                if typeof(model) == "Instance" and model:IsDescendantOf(Tables.TowersFolder) then
                    local ref   = GetTowerRef(model)
                    local dumps = model:FindFirstChild("Dumps")
                    task.delay(0.3, function()
                        if not MState.Rec then return end
                        if not model.Parent then
                            notyuri("[Macro Rec] Pause GUARD FAIL: model missing at", ref)
                            return
                        end
                        local towerPaused = dumps and dumps:FindFirstChild("TowerPaused")
                        if not towerPaused or towerPaused.Value ~= true then
                            notyuri("[Macro Rec] Pause GUARD FAIL: tower not paused at", ref)
                            return
                        end
                        CommitEntry({
                            Type = "Pause",
                            Time = GetTimeString(),
                            Ref  = ref,
                        }, "Pause " .. ref)
                        notyuri("[Macro Rec] Pause recorded", ref)
                    end)
                end
            end
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
        MState.CurWave        = GetCurrentWave()
        MState.WaveStartClock = GetRawTime()
        MState.Cur     = {}
        MState.CurName = "Macro_" .. os.date("%Y%m%d_%H%M%S")
        StartRec()
        UpdateLabel()
        task.spawn(LabelPump)
        task.spawn(function()
            while MState.Rec do
                local w = GetCurrentWave()
                if w ~= MState.CurWave then
                    MState.CurWave        = w
                    MState.WaveStartClock = GetRawTime()
                    notyuri("[Macro Rec] Wave changed to", w)
                end
                task.wait(0.25)
            end
        end)
    else
        MState.Rec = false
        if MState.Cur and #MState.Cur > 0 then
            local fname = (Options.FileName and Options.FileName.Value) or ""
            if fname == "" then fname = MState.CurName end
            fname = fname:gsub("[^A-Za-z0-9_%-]", "_")
            if SaveMacro(fname, MState.Cur) then
                Library:Notify("Saved: " .. fname .. " (" .. #MState.Cur .. " steps)", 5)
            end
            if Options.MacroSelected then
                Options.MacroSelected:SetValues(ListMacros())
            end
        end
        MState.Cur     = nil
        MState.CurName = nil
        MState.Step    = 0
        UpdateLabel()
    end
end
local function GetCredits()
    local ok, val = pcall(function()
        return Plr.LocalSafeData.CashREADONLY.Value
    end)
    return (ok and val) or 0
end
local function WaitForCreditsMacro(amount)
    if not amount or amount <= 0 then return true end
    if GetCredits() >= amount then return true end
    local ok = pcall(function()
        local cashVal = Plr.LocalSafeData.CashREADONLY
        while Toggles.LoadMacro.Value and cashVal.Value < amount do
            cashVal.Changed:Wait()
        end
    end)
    return ok and Toggles.LoadMacro.Value and GetCredits() >= amount
end
local function GetMacroEntryCost(entry)
    if entry.Type == "Place" then
        local ok, cost = pcall(function()
            return Modules.CTD2Module.gettowerupgradecost(Plr, entry.Unit, 0)
        end)
        return ok and cost or nil
    elseif entry.Type == "Upgrade" then
        local model = FindTowerByRef(entry.Ref)
        if not model then return nil end
        local level = model:FindFirstChild("Configuration") and model.Configuration:FindFirstChild("Level")
        if not level then return nil end
        local ok, cost = pcall(function()
            return Modules.CTD2Module.gettowerupgradecost(Plr, model, level.Value + 1)
        end)
        return ok and cost or nil
    elseif entry.Type == "Move" then
        local model = FindTowerByRef(entry.Ref)
        if not model then return nil end
        local ok, cost = pcall(function()
            return Modules.CTD2Module.gettowermoveprice(Plr, model)
        end)
        return ok and cost or nil
    end
    return nil
end
local function Func_LoadMacro()
    local macro = MState.Load
    if not macro or #macro == 0 then
        Toggles.LoadMacro:SetValue(false)
        return
    end
    MState.Rep   = true
    MState.Total = #macro
    local repWave      = GetCurrentWave()
    local repWaveStart = GetRawTime()
    for i, action in ipairs(macro) do
        if not Toggles.LoadMacro.Value then break end
        MState.Step = i
        local replayMode = Options.ReplayMode and Options.ReplayMode.Value or "Time"
        local skipStep = false
        if replayMode == "Money" then
            if action.Type == "Place" or action.Type == "Upgrade" or action.Type == "Move" then
                local cost = GetMacroEntryCost(action)
                if cost and cost > 0 then
                    if not WaitForCreditsMacro(cost) then
                        notyuri("[Macro Load] money wait aborted (toggle off)")
                    end
                end
            end
        else
            local tWave, tElapsed
            if type(action.Time) == "string" then
                local wStr, eStr = action.Time:match("^(%d+)%s+(.+)$")
                tWave    = tonumber(wStr)
                tElapsed = tonumber(eStr)
            end
            if tWave and tElapsed then
                if tWave > repWave then
                    while repWave < tWave and Toggles.LoadMacro.Value do
                        task.wait(.1)
                        local w = GetCurrentWave()
                        if w ~= repWave then
                            repWave      = w
                            repWaveStart = GetRawTime()
                        end
                    end
                end
                if not Toggles.LoadMacro.Value then break end
                local elapsed = repWaveStart - GetRawTime()
                local diff    = tElapsed - elapsed
                if diff < -5 then
                    skipStep = true
                elseif diff > 0 then
                    while Toggles.LoadMacro.Value do
                        elapsed = repWaveStart - GetRawTime()
                        if elapsed >= tElapsed then break end
                        task.wait(.1)
                    end
                end
            end
        end
        if not Toggles.LoadMacro.Value then break end
        if skipStep then
            UpdateLabel("skipped")
        else
            UpdateLabel(action.Type, action.Time)
            if action.Type == "Place" then
                local pos = action.Pos
                if type(pos) == "table" and #pos == 3 then
                    local worldPos   = Vector3.new(pos[1], pos[2], pos[3])
                    local targetPart = FindGroundPart(worldPos)
                    if targetPart then
                        local ok, result = pcall(function()
                            return Remotes.PlaceUnit:InvokeServer(action.Unit, {
                                Pos = worldPos,
                                TargetPart = targetPart,
                            })
                        end)
                        if not ok or result == nil then
                            notyuri("[Macro Load] Place FAILED", action.Unit)
                        end
                    else
                        notyuri("[Macro Load] Place GUARD FAIL: no ground part found for", action.Unit)
                    end
                end
            elseif action.Type == "Upgrade" then
                local model = FindTowerByRef(action.Ref)
                if model then
                    pcall(function() Remotes.UpgradeUnit:InvokeServer(model) end)
                else
                    notyuri("[Macro Load] Upgrade GUARD FAIL: tower not found", action.Ref)
                end
            elseif action.Type == "Sell" then
                local model = FindTowerByRef(action.Ref)
                if model then
                    pcall(function() Remotes.RemoveUnit:FireServer(model) end)
                else
                    notyuri("[Macro Load] Sell GUARD FAIL: tower not found", action.Ref)
                end
            elseif action.Type == "Move" then
                local model = FindTowerByRef(action.Ref)
                local pos   = action.Pos
                if model and type(pos) == "table" and #pos == 3 then
                    local worldPos    = Vector3.new(pos[1], pos[2], pos[3])
                    local targetCF    = CFrame.new(worldPos)
                    local targetPart  = FindGroundPart(worldPos)
                    local ok, err = pcall(function()
                        Remotes.ActivateSkill:FireServer(model, "ActivateSkill", {
                            SkillName = "Reposition",
                            successinfo = {
                                TargetCF        = targetCF,
                                MousePos        = worldPos,
                                MouseTargetPart = targetPart,
                            },
                        })
                    end)
                    if not ok then
                        notyuri("[Macro Load] Move FAILED", action.Ref, tostring(err))
                    end
                else
                    notyuri("[Macro Load] Move GUARD FAIL: tower not found", action.Ref)
                end
            elseif action.Type == "Pause" then
                local model = FindTowerByRef(action.Ref)
                if model then
                    pcall(function() Remotes.PauseUnit:FireServer(model) end)
                else
                    notyuri("[Macro Load] Pause GUARD FAIL: tower not found", action.Ref)
                end
            end
        end
    end
    MState.Rep  = false
    MState.Step = 0
    UpdateLabel("Finished")
    Toggles.LoadMacro:SetValue(false)
end
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
local function GetCurrentMapName()
    local map = workspace:FindFirstChild("Map")
    local trueName = map and map:FindFirstChild("TrueName")
    return trueName and trueName.Value or nil
end
local function GetTowerLoadoutNames()
    local ok, dict = pcall(function()
        return Modules.CTD2Module.GetPlayerTowerLoadoutDict(Plr, { ExcludeBackups = true })
    end)
    if not ok or type(dict) ~= "table" then return {} end
    local names = {}
    for _, entry in pairs(dict) do
        if type(entry) == "table" and entry.TowerName and entry.TowerName ~= "None" then
            table.insert(names, { TowerSlot = entry.TowerSlot, TowerName = entry.TowerName })
        end
    end
    table.sort(names, function(a, b) return (a.TowerSlot or 99) < (b.TowerSlot or 99) end)
    return names
end
local function GetSlotName(slot)
    for _, entry in ipairs(GetTowerLoadoutNames()) do
        if entry.TowerSlot == slot then
            return entry.TowerName
        end
    end
    return nil
end
local function CountPlacedByName(unitName)
    local count = 0
    for _, model in ipairs(Tables.TowersFolder:GetChildren()) do
        if model.Name == unitName and IsOwnedTower(model) then
            count = count + 1
        end
    end
    return count
end
local function GamePlcLimit(unitName)
    local ok, cap = pcall(function()
        return Modules.CTD2Module.GetTowerDefaultCopies(unitName)
    end)
    return (ok and type(cap) == "number") and cap or 4
end
local function GetPlcLimit(slot)
    local unitName = GetSlotName(slot)
    if not unitName then return 0 end
    local cfg = tonumber(Options["APPlaceLimit" .. slot] and Options["APPlaceLimit" .. slot].Value) or 0
    local game = GamePlcLimit(unitName)
    return (cfg > 0) and math.min(cfg, game) or game
end
local function GetUpgLimit(slot)
    return tonumber(Options["APUpgradeLimit" .. slot] and Options["APUpgradeLimit" .. slot].Value) or 0
end
local function IsFarmTowerName(unitName)
    return unitName == "Farmer" or unitName == "Miner"
end
local MCENTERS = {
    ["Abandoned Lab"]                         = Vector3.new(0, 0, 0),
    ["Alder Forest"]                          = Vector3.new(0, 0, 0),
    ["Amber Valley"]                          = Vector3.new(0, 0, 0),
    ["Autumn Isles"]                          = Vector3.new(0, 0, 0),
    ["Azure Sanctuary"]                       = Vector3.new(0, 0, 0),
    ["Baseplate"]                             = Vector3.new(0, 0, 0),
    ["Berry Battlefield"]                     = Vector3.new(0, 0, 0),
    ["Butterfly Graveyard"]                   = Vector3.new(0, 0, 0),
    ["Celestial Cavern"]                      = Vector3.new(0, 0, 0),
    ["Cemetary Season"]                       = Vector3.new(0, 0, 0),
    ["Cerulean Crossing"]                     = Vector3.new(0, 0, 0),
    ["Cliffside Defense"]                     = Vector3.new(0, 0, 0),
    ["Conduit"]                               = Vector3.new(0, 0, 0),
    ["Cooling Chamber"]                       = Vector3.new(0, 0, 0),
    ["Crystal Chasm"]                         = Vector3.new(0, 0, 0),
    ["Deep Caverns"]                          = Vector3.new(0, 0, 0),
    ["Deserted Heights"]                      = Vector3.new(0, 0, 0),
    ["Deserted Mine"]                         = Vector3.new(0, 0, 0),
    ["Endless Halloween"]                     = Vector3.new(0, 0, 0),
    ["Farmland"]                              = Vector3.new(0, 0, 0),
    ["Frozen Valley"]                         = Vector3.new(0, 0, 0),
    ["Glowing Gorge"]                         = Vector3.new(0, 0, 0),
    ["Grand Hall"]                            = Vector3.new(0, 0, 0),
    ["Grassland"]                             = Vector3.new(0, 0, 0),
    ["Graveyard Isles"]                       = Vector3.new(0, 0, 0),
    ["Icicle Palace"]                         = Vector3.new(0, 0, 0),
    ["Lunar Base"]                            = Vector3.new(0, 0, 0),
    ["Magma Chamber"]                         = Vector3.new(0, 0, 0),
    ["Mistveil Isle"]                         = Vector3.new(0, 0, 0),
    ["Monolith Ruins"]                        = Vector3.new(0, 0, 0),
    ["Mosque Depths"]                         = Vector3.new(0, 0, 0),
    ["Mushroom Mayhem"]                       = Vector3.new(0, 0, 0),
    ["Night Terminal"]                        = Vector3.new(0, 0, 0),
    ["Plane of Souls"]                        = Vector3.new(0, 0, 0),
    ["Pumpkin Town"]                          = Vector3.new(0, 0, 0),
    ["Sakura Road"]                           = Vector3.new(0, 0, 0),
    ["Sky Armada"]                            = Vector3.new(0, 0, 0),
    ["Skybound Fort"]                         = Vector3.new(0, 0, 0),
    ["Skyland Skirmish"]                      = Vector3.new(0, 0, 0),
    ["Sunburn Tomb"]                          = Vector3.new(0, 0, 0),
    ["Swamp Isles"]                           = Vector3.new(0, 0, 0),
    ["Thundering Shrine"]                     = Vector3.new(0, 0, 0),
    ["Toxic Sewers"]                          = Vector3.new(0, 0, 0),
    ["Void City"]                             = Vector3.new(0, 0, 0),
    ["Void Sanctum"]                          = Vector3.new(0, 0, 0),
    ["Volcanic Crests"]                       = Vector3.new(0, 0, 0),
    ["Westbound Station"]                     = Vector3.new(0, 0, 0),
    ["Winter Outskirts"]                      = Vector3.new(0, 0, 0),
    ["Fallen Baseplate"]                      = Vector3.new(-39, 32, 4),
    ["Catseye Lair"]                          = Vector3.new(0, 0, 0),
    ["Crisis of the Path"]                    = Vector3.new(0, 0, 0),
    ["Desolation"]                            = Vector3.new(0, 0, 0),
    ["The Black Ordeal"]                      = Vector3.new(0, 0, 0),
    ["The Endless Space of Burning Time"]     = Vector3.new(0, 0, 0),
    ["The Endless Space of Random Time"]      = Vector3.new(0, 0, 0),
    ["The Unknown"]                           = Vector3.new(0, 0, 0),
    ["Toll and Order"]                        = Vector3.new(0, 0, 0),
    ["Trial of Infinity"]                     = Vector3.new(0, 0, 0),
    ["Baseplate EX"]                          = Vector3.new(0, 0, 0),
    ["Skybase"]                               = Vector3.new(0, 0, 0),
    ["Trial of Grenateness"]                  = Vector3.new(0, 0, 0),
    ["First Contact"]                         = Vector3.new(0, 0, 0),
    ["IDK"]                                   = Vector3.new(0, 0, 0),
    ["Infestation"]                           = Vector3.new(0, 0, 0),
    ["NCB-Interlude"]                         = Vector3.new(0, 0, 0),
    ["NCB-Loop"]                              = Vector3.new(0, 0, 0),
    ["NCB-Passage"]                           = Vector3.new(0, 0, 0),
    ["NCB-Split"]                             = Vector3.new(0, 0, 0),
    ["NCB-Tower"]                             = Vector3.new(0, 0, 0),
    ["Sacrificial Hall"]                      = Vector3.new(0, 0, 0),
    ["Solar Outpost"]                         = Vector3.new(0, 0, 0),
    ["Storm Harbor"]                          = Vector3.new(0, 0, 0),
    ["TOB-Intro"]                             = Vector3.new(0, 0, 0),
    ["Trial of the Grenadier"]                = Vector3.new(0, 0, 0),
}
local AP = {
    SlotPositions   = {},
    FailedPositions = {},
    SpanCursor      = {},
    SpanCache       = {},
    MapLabelRef     = nil,
    PosLabelRef     = nil,
}
local function FailKey(pos)
    return string.format("%.1f_%.1f_%.1f", pos.X, pos.Y, pos.Z)
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
local function PosText(mapName)
    if not mapName or not AP.SlotPositions[mapName] then return "No positions set" end
    local lines = {}
    for slot, cfs in pairs(AP.SlotPositions[mapName]) do
        local unitName = GetSlotName(slot)
        table.insert(lines, "Slot " .. slot .. (unitName and (" (" .. unitName .. ")") or "") .. ": " .. #cfs .. " pos")
    end
    if #lines == 0 then return "No positions set" end
    table.sort(lines)
    return table.concat(lines, "\n")
end
local function UpdatePosLabels()
    local mapName = GetCurrentMapName()
    if AP.MapLabelRef then
        pcall(function()
            AP.MapLabelRef:SetText("Current Map: " .. (mapName or "Not in game"))
        end)
    end
    if AP.PosLabelRef then
        pcall(function()
            AP.PosLabelRef:SetText(PosText(mapName))
        end)
    end
end
local function HandleSlotPos(act, slot)
    local mapName = GetCurrentMapName()
    if not mapName then
        Library:Notify("Not in a game — map not detected", 3)
        return
    end
    if act == "reset" then
        if slot then
            if AP.SlotPositions[mapName] then AP.SlotPositions[mapName][slot] = nil end
            Library:Notify("Slot " .. slot .. " positions cleared (" .. mapName .. ")", 3)
            notyuri("[AutoPlay] ResetPos slot=" .. slot .. " map=" .. mapName)
        else
            AP.SlotPositions[mapName] = nil
            Library:Notify("All positions cleared (" .. mapName .. ")", 3)
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
    local ground = FindGroundPart(pos)
    local groundY = ground and (ground.Position.Y + ground.Size.Y / 2 + 1) or pos.Y
    local cf = CFrame.new(Vector3.new(pos.X, groundY, pos.Z))
    if not AP.SlotPositions[mapName] then AP.SlotPositions[mapName] = {} end
    if act == "set" then
        if not AP.SlotPositions[mapName][slot] then AP.SlotPositions[mapName][slot] = {} end
        table.insert(AP.SlotPositions[mapName][slot], cf)
        local count = #AP.SlotPositions[mapName][slot]
        Library:Notify("Slot " .. slot .. " position " .. count .. " saved (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] SetPos slot=" .. slot .. " count=" .. count .. " map=" .. mapName)
    elseif act == "massset" then
        for i = 1, 6 do
            if not AP.SlotPositions[mapName][i] then AP.SlotPositions[mapName][i] = {} end
            table.insert(AP.SlotPositions[mapName][i], cf)
        end
        Library:Notify("All slots saved:" .. mapName .. ")", 3)
        notyuri("[AutoPlay] MassSetPos map=" .. mapName)
    end
    UpdatePosLabels()
end
local function SetPos(slot) HandleSlotPos("set", slot) end
local function MassSetPos() HandleSlotPos("massset") end
local function ResetPos(slot) HandleSlotPos("reset", slot) end
local function GetUpgradableTowers()
    local result = {}
    for _, model in ipairs(Tables.TowersFolder:GetChildren()) do
        if IsOwnedTower(model) then
            local cfg = model:FindFirstChild("Configuration")
            local level = cfg and cfg:FindFirstChild("Level")
            local maxLevel = model:FindFirstChild("MaxLevel")
            if level and maxLevel then
                local slot = nil
                for _, entry in ipairs(GetTowerLoadoutNames()) do
                    if entry.TowerName == model.Name then
                        slot = entry.TowerSlot
                        break
                    end
                end
                local cfgCap = slot and GetUpgLimit(slot) or 0
                local effectiveMax = (cfgCap > 0) and math.min(cfgCap, maxLevel.Value) or maxLevel.Value
                if level.Value < effectiveMax then
                    table.insert(result, {
                        model        = model,
                        slot         = slot,
                        level        = level.Value,
                        maxLevel     = maxLevel.Value,
                        effectiveMax = effectiveMax,
                    })
                end
            end
        end
    end
    return result
end
local function UpgradeCand(units)
    local method    = Options.APUpgradeMethod and Options.APUpgradeMethod.Value or "Lowest Level (Spread Upgrade)"
    local focusFarm = Toggles.FocusFarm and Toggles.FocusFarm.Value
    local candidates = units
    if focusFarm then
        local farms = {}
        for _, e in ipairs(units) do
            if IsFarmTowerName(e.model.Name) then table.insert(farms, e) end
        end
        if #farms > 0 then candidates = farms end
    end
    if #candidates == 0 then return nil end
    if method == "Randomize" then
        return candidates[math.random(1, #candidates)]
    elseif method == "Hotbar left to right (until Max)" or method == "Customize upgrade order (Set below)" then
        table.sort(candidates, function(a, b)
            local sa, sb = a.slot or 99, b.slot or 99
            if sa ~= sb then return sa < sb end
            return a.level < b.level
        end)
        return candidates[1]
    end
    table.sort(candidates, function(a, b) return a.level < b.level end)
    return candidates[1]
end
local function DoUpgrade()
    local units = GetUpgradableTowers()
    local target = UpgradeCand(units)
    if not target then return false end
    local ref = GetTowerRef(target.model)
    local ok, result = pcall(function()
        return Remotes.UpgradeUnit:InvokeServer(target.model)
    end)
    notyuri("[AutoPlay] UpgradeUnit ref=" .. ref .. " slot=" .. tostring(target.slot) .. " lv=" .. target.level .. " ok=" .. tostring(ok and result == true))
    task.wait(0.1)
    return ok and result == true
end
local function PlacePhase()
    local mapName = GetCurrentMapName()
    local centerRaw = mapName and MCENTERS[mapName]
    local center = centerRaw and centerRaw ~= Vector3.new(0, 0, 0) and Vector3.new(centerRaw.X, GetGround(centerRaw), centerRaw.Z) or centerRaw
    local slotOrder = {}
    for i = 1, 6 do table.insert(slotOrder, i) end
    table.sort(slotOrder, function(a, b)
        local oa = tonumber(Options["APPlaceOrder" .. a] and Options["APPlaceOrder" .. a].Value) or a
        local ob = tonumber(Options["APPlaceOrder" .. b] and Options["APPlaceOrder" .. b].Value) or b
        return oa < ob
    end)
    local allPlaced = true
    local waitingForCash = false
    for _, slot in ipairs(slotOrder) do
        if not Toggles.AutoPlay.Value then break end
        if waitingForCash then break end
        local placeWave = tonumber(Options["APPlaceWave" .. slot] and Options["APPlaceWave" .. slot].Value) or 0
        local currentWave = 0
        local mapCfg = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Configuration")
        local waveVal = mapCfg and mapCfg:FindFirstChild("Wave")
        if waveVal then currentWave = waveVal.Value end
        if placeWave > 0 and currentWave < placeWave then
            allPlaced = false
        else
            local unitName = GetSlotName(slot)
            if unitName then
                local limit  = GetPlcLimit(slot)
                local placed = CountPlacedByName(unitName)
                local need   = limit - placed
                if need > 0 then
                    allPlaced = false
                    if not AP.FailedPositions[mapName] then AP.FailedPositions[mapName] = {} end
                    local failed = AP.FailedPositions[mapName]
                    local positions = {}
                    local slotCfg = mapName and AP.SlotPositions[mapName] and AP.SlotPositions[mapName][slot]
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
                                if not AP.SpanCache[cursorKey] then AP.SpanCache[cursorKey] = {} end
                                local cache = AP.SpanCache[cursorKey]
                                local idx = AP.SpanCursor[cursorKey] or 0
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
                                AP.SpanCursor[cursorKey] = idx
                            end
                        else
                            local centerPos = slotCfg[1].Position
                            local cursorKey = mapName .. ":" .. FailKey(centerPos)
                            if not AP.SpanCache[cursorKey] then AP.SpanCache[cursorKey] = {} end
                            local cache = AP.SpanCache[cursorKey]
                            local idx = AP.SpanCursor[cursorKey] or 0
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
                            AP.SpanCursor[cursorKey] = idx
                        end
                    elseif center and center ~= Vector3.new(0, 0, 0) then
                        local cursorKey = mapName .. ":center"
                        if not AP.SpanCache[cursorKey] then AP.SpanCache[cursorKey] = {} end
                        positions.__spiral = true
                        positions.__cache = AP.SpanCache[cursorKey]
                        positions.__center = center
                        positions.__cursorKey = cursorKey
                        positions.__need = need
                    else
                        notyuri("[AutoPlay] PlacePhase: no saved position or map center for slot " .. slot .. " (" .. unitName .. "), skipping")
                    end
                    if positions.__spiral or #positions > 0 then
                        local placeCost = 0
                        pcall(function()
                            placeCost = Modules.CTD2Module.gettowerupgradecost(Plr, unitName, 0)
                        end)
                        local placedThisCall = 0
                        while true do
                            if not Toggles.AutoPlay.Value then break end
                            local cf
                            if positions.__spiral then
                                if placedThisCall >= positions.__need then break end
                                if placeCost > 0 and GetCredits() < placeCost then
                                    waitingForCash = true
                                    break
                                end
                                local cache = positions.__cache
                                local idx = AP.SpanCursor[positions.__cursorKey] or 0
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
                                AP.SpanCursor[positions.__cursorKey] = idx
                                placedThisCall = placedThisCall + 1
                            else
                                placedThisCall = placedThisCall + 1
                                if placedThisCall > #positions then break end
                                cf = positions[placedThisCall]
                                if placeCost > 0 and GetCredits() < placeCost then
                                    waitingForCash = true
                                    break
                                end
                            end
                            local targetPart = FindGroundPart(cf.Position)
                            local ghost = PCubeAcq()
                            ghost.CFrame = cf * CFrame.new(0, 0.5, 0)
                            local countBefore = CountPlacedByName(unitName)
                            local ok = false
                            if targetPart then
                                pcall(function()
                                    Remotes.PlaceUnit:InvokeServer(unitName, {
                                        Pos = cf.Position,
                                        TargetPart = targetPart,
                                    })
                                end)
                                task.wait(0.3)
                                ok = CountPlacedByName(unitName) > countBefore
                            end
                            notyuri("[AutoPlay] PLACE slot=" .. slot .. " unit=" .. unitName .. " pos=" ..
                                string.format("(%.1f,%.1f,%.1f)", cf.Position.X, cf.Position.Y, cf.Position.Z) ..
                                " ok=" .. tostring(ok))
                            if ok then
                                ghost.Color = Color3.fromRGB(80, 255, 120)
                                if Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value then
                                    DoUpgrade()
                                end
                                if CountPlacedByName(unitName) >= limit then
                                    break
                                end
                            else
                                ghost.Color = Color3.fromRGB(255, 80, 80)
                                failed[FailKey(cf.Position)] = true
                                waitingForCash = true
                            end
                        end
                    end
                end
            end
        end
    end
    return allPlaced
end
local function Func_AutoSkip()
    local AbleToSkip = workspace:FindFirstChild("GameVals") and workspace.GameVals:FindFirstChild("AbleToSkip")
    while Toggles.AutoSkip.Value do
        local mr = GetMapRemotes()
        if AbleToSkip and AbleToSkip.Value == true and mr and mr.SkipButtonObj then
            gsc(mr.SkipButtonObj)
        end
        task.wait(0.2)
    end
end
local function EnemyIsAttacking(towerModel)
    local enemiesAggroed = towerModel:FindFirstChild("EnemiesAggroed")
    if not enemiesAggroed then
        return false
    end
    local children = enemiesAggroed:GetChildren()
    for _, ref in ipairs(children) do
        local enemy = ref.Value
        if enemy then
            local overheadHPBar = enemy:FindFirstChild("OverheadHPBar")
            local stroke = overheadHPBar and overheadHPBar:FindFirstChild("BarFrame") and overheadHPBar.BarFrame:FindFirstChild("EnemyAttackWarningStroke")
            if stroke then
                if stroke.BackgroundTransparency < 1 then
                    return true
                end
            end
        end
    end
    return false
end
local function Func_AutoPause()
    while Toggles.AutoPause.Value do
        for _, model in ipairs(Tables.TowersFolder:GetChildren()) do
            if not Toggles.AutoPause.Value then break end
            if IsOwnedTower(model) then
                local dumps = model:FindFirstChild("Dumps")
                local aggroCount = dumps and dumps:FindFirstChild("CurrentAggroBlockCount")
                if aggroCount and aggroCount.Value > 0 then
                    local attacking = EnemyIsAttacking(model)
                    if attacking then
                        local ok, skillType = pcall(function()
                            return Modules.CTD2Module.TowerGetCurrentTruePauseSkillType(model)
                        end)
                        if ok and skillType ~= "None" then
                            local towerPaused = dumps:FindFirstChild("TowerPaused")
                            if not towerPaused or towerPaused.Value == false then
                                pcall(function()
                                    Remotes.PauseUnit:FireServer(model)
                                end)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoStart()
    while Toggles.AutoStart.Value do
        local Start = workspace:FindFirstChild("Voting") and workspace.Voting:FindFirstChild("Start")
        if Start and Start.Value == false then
            local VotingGui = PGui:FindFirstChild("VotingGui")
            local WaitingRoom = VotingGui and VotingGui:FindFirstChild("WaitingRoom")
            if WaitingRoom and WaitingRoom.Visible then
                notyuri("[AutoStart] Voting.Start false, firing WaitingRoom via gsc")
                gsc(WaitingRoom)
            else
                notyuri("[AutoStart] no visible WaitingRoom button found")
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoReplay()
    while Toggles.AutoReplay.Value do
        local GameEnded = workspace:FindFirstChild("GameEnded")
        if GameEnded and GameEnded.Value == true then
            local mr = GetMapRemotes()
            if mr and mr.GameEndRestart then
                local ok, err = pcall(function()
                    mr.GameEndRestart:FireServer("RestartVote")
                end)
                if ok then
                    notyuri("[AutoReplay] RestartVote fired")
                else
                    notyuri("[AutoReplay] RestartVote failed:", tostring(err))
                end
            else
                notyuri("[AutoReplay] GameEndRestart remote not found")
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoPlay()
    while Toggles.AutoPlay.Value do
        if not workspace:FindFirstChild("Map") then
            task.wait(1)
        else
            local allPlaced = PlacePhase()
            if allPlaced and Toggles.AutoUpgrade and Toggles.AutoUpgrade.Value then
                local didUpgrade = DoUpgrade()
                if not didUpgrade then
                    task.wait(1)
                end
            end
            task.wait(0.2)
        end
    end
    PCubeReleaseAll()
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
local EndFrameHooked = false
local function HookEndFrameRemote()
    if EndFrameHooked then return end
    task.spawn(function()
        local map = workspace:WaitForChild("Map", 30)
        if not map then return end
        local endFrameRemote = map:WaitForChild("EndFrameRemote", 30)
        if not endFrameRemote then return end
        EndFrameHooked = true
        endFrameRemote.OnClientEvent:Connect(function(payload)
            if not Toggles.WHMatchEnd or not Toggles.WHMatchEnd.Value then return end
            if type(payload) ~= "table" or type(payload.CalculateRewardsDetails) ~= "table" then return end
            local details = payload.CalculateRewardsDetails
            local mapDetails = details.MapDetails or {}
            local outcome = payload.Result == "Triumph" and "Victory" or "Defeat"
            local totalTime = 0
            pcall(function()
                totalTime = workspace.WorkspaceScriptService.TotalGameTime.Value or 0
            end)
            local mins = math.floor(totalTime / 60)
            local secs = math.floor(totalTime % 60)
            local rewardLines = {}
            if type(details.FinalRewardArray) == "table" then
                for _, reward in pairs(details.FinalRewardArray) do
                    if type(reward) == "table" and reward.CurrencyName then
                        table.insert(rewardLines, string.format("+%s %s", tostring(reward.CurrencyAmt), tostring(reward.CurrencyName)))
                    end
                end
            end
            if payload.ExpReward then
                table.insert(rewardLines, string.format("+%s Exp", tostring(payload.ExpReward)))
            end
            local mapLabel = (mapDetails.MapCodeString or "Unknown")
            if mapDetails.ModeName then
                mapLabel = mapLabel .. " // " .. mapDetails.ModeName
            end
            local desc = string.format(
                "**%s - %s**\n- Time: %d:%02d\n- Player: ||%s||\n- Rewards:\n%s",
                mapLabel, outcome, mins, secs, Plr.Name,
                #rewardLines > 0 and table.concat(rewardLines, "\n") or "None"
            )
            SendWebhook("Match Finished", desc)
            notyuri("[Webhook] Match finished notification sent")
        end)
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
    AutoPlay = Window:AddTab("Auto Play"),
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
        T1 = TB.Main.Left.Autofarm:AddTab("Macro"),
        T2 = TB.Main.Left.Autofarm:AddTab("Game"),
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
local AP_Left  = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
local AP_Right = Tabs.AutoPlay:AddRightGroupbox("Limits")
AP_Left:AddToggle("AutoPlay", {
    Text    = "Auto Play",
    Default = false,
})
AP_Left:AddDivider()
AP_Left:AddDropdown("APUpgradeMethod", {
    Text    = "Upgrade Method",
    Values  = {
        "Lowest Level (Spread Upgrade)",
        "Hotbar left to right (until Max)",
        "Randomize",
        "Customize upgrade order (Set below)",
    },
    Default = "Lowest Level (Spread Upgrade)",
})
AP_Left:AddDivider()
AP_Left:AddToggle("AutoUpgrade", {
    Text    = "Auto Upgrade",
    Default = false,
})
AP_Left:AddToggle("PlaceAndUpgrade", {
    Text    = "Place and Upgrade",
    Default = false,
})
AP_Left:AddToggle("FocusFarm", {
    Text    = "Focus on Farm",
    Default = false,
})
AP_Right:AddLabel("Place Order per Slot", true)
for i = 1, 6 do
    AP_Right:AddSlider("APPlaceOrder" .. i, {
        Text     = "Slot " .. i,
        Default  = i,
        Min      = 1,
        Max      = 6,
        Rounding = 0,
        Compact  = true,
    })
end
AP_Right:AddDivider()
AP_Right:AddLabel("Place Wave per Slot", true)
for i = 1, 6 do
    AP_Right:AddSlider("APPlaceWave" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 50,
        Rounding = 0,
        Compact  = true,
    })
end
AP_Right:AddDivider()
AP_Right:AddLabel("Place Limit per Slot", true)
for i = 1, 6 do
    AP_Right:AddSlider("APPlaceLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 10,
        Rounding = 0,
        Compact  = true,
    })
end
AP_Right:AddDivider()
AP_Right:AddLabel("Upgrade Limit per Slot", true)
for i = 1, 6 do
    AP_Right:AddSlider("APUpgradeLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 30,
        Rounding = 0,
        Compact  = true,
    })
end
local function GetSlotDisplayNames()
    local names = {}
    for _, entry in ipairs(GetTowerLoadoutNames()) do
        table.insert(names, "Slot " .. entry.TowerSlot .. " (" .. entry.TowerName .. ")")
    end
    return names
end
local function SlotDisplayToNumber(display)
    local n = display and display:match("^Slot (%d+)")
    return n and tonumber(n) or nil
end
local AP_PosA = Tabs.AutoPlay:AddLeftGroupbox("Set Position")
local AP_PosB = Tabs.AutoPlay:AddRightGroupbox("Position Manage")
AP_PosA:AddLabel("Stand where you want units placed, select a slot, then press Set Slot Position.", true)
AP.MapLabelRef = AP_PosA:AddLabel("Current Map: ...", true)
AP_PosA:AddDropdown("APSetSlotSelect", {
    Text    = "Set Slot Position",
    Values  = GetSlotDisplayNames(),
    Default = GetSlotDisplayNames()[1] or "",
})
AP_PosA:AddButton({
    Text = "Set Slot Position",
    Func = function()
        local val = Options.APSetSlotSelect and Options.APSetSlotSelect.Value or ""
        local slot = SlotDisplayToNumber(val)
        if slot then
            SetPos(slot)
        else
            Library:Notify("Select a slot first", 3)
        end
    end,
})
AP_PosA:AddButton({
    Text = "Mass Set All 6 Slots",
    Func = function()
        MassSetPos()
    end,
})
AP_PosB:AddLabel("Positions recorded for current map:", true)
AP.PosLabelRef = AP_PosB:AddLabel("Not in a game", true)
AP_PosB:AddDivider()
AP_PosB:AddDropdown("APResetSlotSelect", {
    Text    = "Reset Slot Position",
    Values  = (function() local v = GetSlotDisplayNames() table.insert(v, "All Slots") return v end)(),
    Default = "All Slots",
})
AP_PosB:AddButton({
    Text = "Reset Position",
    Func = function()
        local val = Options.APResetSlotSelect and Options.APResetSlotSelect.Value or "All Slots"
        if val == "All Slots" then
            ResetPos(nil)
        else
            ResetPos(SlotDisplayToNumber(val))
        end
    end,
})
Toggles.AutoPlay:OnChanged(function(v)
    Thread("AutoPlay", SafeLoop("AutoPlay", Func_AutoPlay), v)
    if not v then
        PCubeReleaseAll()
    end
end)
task.spawn(function()
    while not Library.Unloaded do
        UpdatePosLabels()
        task.wait(2)
    end
end)
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
TB_Tabs.Autofarm.T1:AddInput("FileName", {
    Text        = "File Name",
    Default     = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T1:AddToggle("RecordMacro", {
    Text    = "Record Macro",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddDropdown("ReplayMode", {
    Text    = "Replay Mode",
    Values  = { "Time", "Money" },
    Default = "Time",
})
TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", {
    Text    = "Load Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
Toggles.RecordMacro:OnChanged(function(v)
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
    Thread("LoadMacro", SafeLoop("LoadMacro", Func_LoadMacro), v)
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoReplay", {
    Text    = "Auto Replay",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoStart", {
    Text    = "Auto Start",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoPause", {
    Text    = "Auto Pause",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoSkip", {
    Text    = "Auto Skip",
    Default = false,
})
Toggles.AutoReplay:OnChanged(function(v)
    Thread("AutoReplay", SafeLoop("AutoReplay", Func_AutoReplay), v)
end)
Toggles.AutoStart:OnChanged(function(v)
    Thread("AutoStart", SafeLoop("AutoStart", Func_AutoStart), v)
end)
Toggles.AutoPause:OnChanged(function(v)
    Thread("AutoPause", SafeLoop("AutoPause", Func_AutoPause), v)
end)
Toggles.AutoSkip:OnChanged(function(v)
    Thread("AutoSkip", SafeLoop("AutoSkip", Func_AutoSkip), v)
end)
LoadMDir()
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
local WH1 = Tabs.Webhook:AddLeftGroupbox("Webhook")
WH1:AddInput("WebhookURL", { Text = "Webhook URL", Default = "" })
WH1:AddToggle("WHMatchEnd", { Text = "Match Finished", Default = false })
Toggles.WHMatchEnd:OnChanged(function(v)
    if v then
        HookEndFrameRemote()
    end
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
SaveManager:SetFolder("Yuri/CSTD")
SaveManager:SetLoadingOrder(true, {"Dropdown", "Slider", "ColorPicker", "KeyPicker", "Input", "Toggle"})
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
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
