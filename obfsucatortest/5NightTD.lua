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
local l,f={},"1log.txt";if isfile and isfile(f)then delfile(f)end;if writefile then writefile(f,"")end;function notyuri(...)local t=table.create(select("#",...))for i=1,select("#",...)do t[i]=tostring(select(i,...))end local s=("[%s] %s"):format(os.date("%H:%M:%S"),table.concat(t," "));l[#l+1]=s;if appendfile then appendfile(f,s.."\n")end end
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
local Shared        = RS.Shared
local Packages       = Shared.Packages
local Net            = require(Packages.Net)
local Utility        = Plr.PlayerScripts:FindFirstChild("Utility")
local Remotes = {
    PlaceUnit   = Net:RemoteEvent("PlaceUnit"),
    UnitPlaced  = Net:RemoteEvent("UnitPlaced"),
    UpgradeUnit = Net:RemoteEvent("UpgradeUnit"),
    RemoveUnit  = Net:RemoteEvent("RemoveUnit"),
    UpgradeAll  = Net:RemoteEvent("UpgradeAll"),
    SellAll     = Net:RemoteEvent("SellAll"),
    TargetUnit  = Net:RemoteEvent("TargetUnit"),
    VoteEvent   = Net:RemoteEvent("VoteEvent"),
    EndGame     = Net:RemoteEvent("EndGame"),
}
local Modules = {
    DataUtil = GetSafeModule(Utility, "DataUtil"),
    GameData = GetSafeModule(Utility, "GameData"),
    Signals  = GetSafeModule(Utility, "Signals"),
    UnitProfiles = GetSafeModule(Utility, "UnitProfiles"),
}
local GameShared        = RS:FindFirstChild("Game") and RS:FindFirstChild("Game"):FindFirstChild("Shared")
local Packets           = GameShared and GameShared:FindFirstChild("Packets") and require(GameShared:FindFirstChild("Packets"))
local GameConfig        = GameShared and GameShared:FindFirstChild("Config") and GameShared:FindFirstChild("Config"):FindFirstChild("GameConfig") and require(GameShared:FindFirstChild("Config"):FindFirstChild("GameConfig"))
local CustomNightConfig = GameConfig and GameConfig.CustomNight
local Flags = {}
local Tables = {
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
local MDir = "Yuri/5NTD2/Macros"
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
    StartRelay   = false,
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
    Macro      = {},
    AutoReplay = nil,
    AutoStart  = nil,
    AutoNext   = nil,
    Elevator   = nil,
    WHMatchEnd = nil,
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
    return Modules.GameData and Modules.GameData.GameStarted == true
end
local function GetElapsedBattleTime()
    if not IsBattleActive() then return nil end
    if not Modules.GameData or not Modules.GameData.StartTime then return nil end
    return tick() - Modules.GameData.StartTime
end
local function WaitForUnitPlaced(rawGuid, timeout)
    timeout = timeout or 2
    local result = nil
    local conn
    conn = Remotes.UnitPlaced.OnClientEvent:Connect(function(charName, profile, cf, plr, stats, _, _, _, unitUid)
        if unitUid == rawGuid then
            result = { CharName = charName, CFrame = cf }
        end
    end)
    local start = tick()
    repeat task.wait() until result ~= nil or (tick() - start) > timeout
    if conn then conn:Disconnect() end
    return result
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
    Connections.WHMatchEnd = Remotes.EndGame.OnClientEvent:Connect(function(resultData, mvpData, timerSeconds, matchSession)
        if not Toggles.WHMatchEnd.Value then return end
        if not resultData then return end
        local outcome = resultData.Win and "Victory" or "Defeat"
        local gamemode = (Modules.GameData and Modules.GameData.Gamemode) or "Regular"
        local mapName = (Modules.GameData and Modules.GameData.Map and Modules.GameData.Map.Name) or "Unknown"
        local timeTaken = tonumber(resultData.TimeTaken) or (Modules.GameData and Modules.GameData.StartTime and (tick() - Modules.GameData.StartTime)) or 0
        local mins = math.floor(timeTaken / 60)
        local secs = math.floor(timeTaken % 60)
        local rewardTable = (Modules.GameData and Modules.GameData.RewardTable) or {}
        local totals, order = {}, {}
        local function addReward(asset, amount)
            asset = tostring(asset)
            amount = tonumber(amount) or amount
            if totals[asset] then
                totals[asset] = totals[asset] + amount
            else
                totals[asset] = amount
                table.insert(order, asset)
            end
        end
        if type(resultData.Rewards) == "table" then
            for key, amount in pairs(resultData.Rewards) do
                local entry = rewardTable[tonumber(key)] or rewardTable[key]
                local name = entry and entry.Name or tostring(key)
                addReward(name, amount)
            end
        end
        if type(resultData.Currencies) == "table" then
            for asset, amount in pairs(resultData.Currencies) do
                addReward(asset, amount)
            end
        end
        if type(resultData.TowerRewards) == "table" then
            for _, reward in pairs(resultData.TowerRewards) do
                addReward(reward.Name or "?", reward.Amount or 1)
            end
        end
        local rewardLines = {}
        for _, asset in ipairs(order) do
            table.insert(rewardLines, string.format("+%s %s", tostring(totals[asset]), asset))
        end
        local desc = string.format(
            "**[%s] %s - %s**\n- Time: %d:%02d\n- Player: ||%s||\n- Reward:\n%s",
            gamemode, mapName, outcome, mins, secs, Plr.Name,
            #rewardLines > 0 and table.concat(rewardLines, "\n") or "None"
        )
        SendWebhook("Match Finished", desc)
        notyuri("[Webhook] Match finished notification sent")
    end)
    while Toggles.WHMatchEnd.Value do
        task.wait(1)
    end
    if Connections.WHMatchEnd then
        Connections.WHMatchEnd:Disconnect()
        Connections.WHMatchEnd = nil
    end
end
local function GetUnitUpgradeLevel(guid)
    if not Modules.UnitProfiles then return nil end
    local unit = Modules.UnitProfiles[guid]
    return unit and unit.CurrentUpgrade
end
local SlotPositions   = {}
local MapLabelRef     = nil
local PosLabelRef     = nil
local FailedPositions = {}
local SpanCursor      = {}
local SpanCache       = {}
local PCubePool = {
    Free   = {},
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
    if not Modules.GameData then return nil end
    local map = Modules.GameData.Map
    if typeof(map) == "Instance" then
        return map.Name
    elseif type(map) == "string" and map ~= "" then
        return map
    end
    return nil
end
local MCENTERS = {
    ["BRM1"]         = Vector3.new(0, 0, 0),
    ["CG1L1"]        = Vector3.new(0, 0, 0),
    ["CG1L2"]        = Vector3.new(0, 0, 0),
    ["CG1L3"]        = Vector3.new(0, 0, 0),
    ["CG1L4"]        = Vector3.new(0, 0, 0),
    ["CG1L5"]        = Vector3.new(0, 0, 0),
    ["CG1L6"]        = Vector3.new(0, 0, 0),
    ["CG1L99"]       = Vector3.new(0, 0, 0),
    ["CG2L0"]        = Vector3.new(0, 0, 0),
    ["CG2L1"]        = Vector3.new(0, 0, 0),
    ["CG2L2"]        = Vector3.new(0, 0, 0),
    ["CG2L3"]        = Vector3.new(0, 0, 0),
    ["CG2L4"]        = Vector3.new(0, 0, 0),
    ["CG2L5"]        = Vector3.new(0, 0, 0),
    ["CWM1"]         = Vector3.new(0, 0, 0),
    ["ChicasMagicRainbow"] = Vector3.new(0, 0, 0),
    ["ChipperSonsCo"] = Vector3.new(0, 0, 0),
    ["FoxyFighters"] = Vector3.new(0, 0, 0),
    ["FreddyInSpace"] = Vector3.new(0, 0, 0),
    ["G1L1"]         = Vector3.new(0, 0, 0),
    ["G1L2"]         = Vector3.new(0, 0, 0),
    ["G1L3"]         = Vector3.new(0, 0, 0),
    ["G1L4"]         = Vector3.new(0, 0, 0),
    ["G1L5"]         = Vector3.new(0, 0, 0),
    ["G1L6"]         = Vector3.new(0, 0, 0),
    ["G1L99"]        = Vector3.new(0, 0, 0),
    ["G2L1"]         = Vector3.new(0, 0, 0),
    ["G2L2"]         = Vector3.new(0, 0, 0),
    ["G2L3"]         = Vector3.new(0, 0, 0),
    ["G2L4"]         = Vector3.new(0, 0, 0),
    ["G2L5"]         = Vector3.new(0, 0, 0),
    ["G2L6"]         = Vector3.new(0, 0, 0),
    ["G2L99"]        = Vector3.new(0, 0, 0),
    ["G3L1"]         = Vector3.new(0, 0, 0),
    ["G3L2"]         = Vector3.new(0, 0, 0),
    ["G3L3"]         = Vector3.new(0, 0, 0),
    ["G3L4"]         = Vector3.new(0, 0, 0),
    ["G3L5"]         = Vector3.new(0, 0, 0),
    ["G3L6"]         = Vector3.new(0, 0, 0),
    ["G3L99"]        = Vector3.new(0, 0, 0),
    ["G4L1"]         = Vector3.new(0, 0, 0),
    ["G4L2"]         = Vector3.new(0, 0, 0),
    ["G4L3"]         = Vector3.new(0, 0, 0),
    ["G4L4"]         = Vector3.new(0, 0, 0),
    ["G4L5"]         = Vector3.new(0, 0, 0),
    ["G4L6"]         = Vector3.new(0, 0, 0),
    ["G4L99"]        = Vector3.new(0, 0, 0),
    ["G5L1"]         = Vector3.new(0, 0, 0),
    ["G5L2"]         = Vector3.new(0, 0, 0),
    ["G5L3"]         = Vector3.new(0, 0, 0),
    ["G5L4"]         = Vector3.new(0, 0, 0),
    ["G5L5"]         = Vector3.new(0, 0, 0),
    ["G5L6"]         = Vector3.new(0, 0, 0),
    ["G5L99"]        = Vector3.new(0, 0, 0),
    ["G6L1"]         = Vector3.new(0, 0, 0),
    ["G6L2"]         = Vector3.new(0, 0, 0),
    ["G6L3"]         = Vector3.new(0, 0, 0),
    ["G6L4"]         = Vector3.new(0, 0, 0),
    ["G6L5"]         = Vector3.new(0, 0, 0),
    ["G6L6"]         = Vector3.new(0, 0, 0),
    ["G6L99"]        = Vector3.new(0, 0, 0),
    ["HG1L1"]        = Vector3.new(0, 0, 0),
    ["HG1L2"]        = Vector3.new(0, 0, 0),
    ["HG1L3"]        = Vector3.new(0, 0, 0),
    ["HG1L4"]        = Vector3.new(0, 0, 0),
    ["HG1L5"]        = Vector3.new(0, 0, 0),
    ["HG1L6"]        = Vector3.new(0, 0, 0),
    ["HG1L99"]       = Vector3.new(0, 0, 0),
    ["HG2L1"]        = Vector3.new(0, 0, 0),
    ["HG2L2"]        = Vector3.new(0, 0, 0),
    ["HG2L3"]        = Vector3.new(0, 0, 0),
    ["HG2L4"]        = Vector3.new(0, 0, 0),
    ["HG2L5"]        = Vector3.new(0, 0, 0),
    ["HG2L6"]        = Vector3.new(0, 0, 0),
    ["HG2L99"]       = Vector3.new(0, 0, 0),
    ["OG1L99"]       = Vector3.new(0, 0, 0),
    ["OG2L99"]       = Vector3.new(0, 0, 0),
    ["OG3L99"]       = Vector3.new(0, 0, 0),
    ["OG4L99"]       = Vector3.new(0, 0, 0),
    ["OMC"]          = Vector3.new(0, 0, 0),
    ["Supergoon"]    = Vector3.new(0, 0, 0),
    ["Tower"]        = Vector3.new(0, 0, 0),
}
local function FailKey(cf)
    return string.format("%d,%d", math.round(cf.X), math.round(cf.Z))
end
local function GetGround(pos)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local excluded = {}
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
local function GetPlayerData()
    if not Modules.DataUtil then return nil end
    local ok, data = pcall(function() return Modules.DataUtil:GetInitialData() end)
    if ok and data then return data end
    local ok2, data2 = pcall(function() return Modules.DataUtil:GetPlayerData(Plr) end)
    if ok2 and data2 then return data2 end
    return nil
end
local function GetSlotGUID(slot)
    local data = GetPlayerData()
    local guid = data and data.Equipped and data.Equipped.Units and data.Equipped.Units[slot]
    return guid
end
local function GetSlotName(slot)
    local data = GetPlayerData()
    if not data or not data.Equipped or not data.Equipped.Units or not data.Inventory then return nil end
    local guid = data.Equipped.Units[slot]
    if not guid then return nil end
    local entry = data.Inventory[guid]
    return entry and entry.Name
end
local function FindSlot(unitName)
    local data = GetPlayerData()
    if not data or not data.Equipped or not data.Equipped.Units or not data.Inventory then return nil end
    for slot, guid in pairs(data.Equipped.Units) do
        local entry = data.Inventory[guid]
        if entry and entry.Name == unitName then
            return tonumber(slot)
        end
    end
    return nil
end
local function CountPlaced(slot)
    local unitName = GetSlotName(slot)
    if not unitName or not Modules.UnitProfiles then return 0 end
    local count = 0
    for _, profile in pairs(Modules.UnitProfiles) do
        if profile.UnitOwner == Plr and profile.UnitData and profile.UnitData.Name == unitName then
            count = count + 1
        end
    end
    return count
end
local function GetUpgLimit(slot)
    return tonumber(Options["APUpgradeLimit" .. slot] and Options["APUpgradeLimit" .. slot].Value) or 0
end
local function GetPlcLimit(slot)
    return tonumber(Options["APPlaceLimit" .. slot] and Options["APPlaceLimit" .. slot].Value) or 0
end
local function GetPlacedUnitsForSlots()
    local result = {}
    if not Modules.UnitProfiles then return result end
    for guid, profile in pairs(Modules.UnitProfiles) do
        if profile.UnitOwner == Plr and profile.UnitData and profile.UnitConfig then
            local slot = FindSlot(profile.UnitData.Name)
            if slot then
                local current = profile.CurrentUpgrade or 1
                local upgradeStats = profile.UnitConfig.UpgradeStats
                local maxUpgrade = (type(upgradeStats) == "table") and (#upgradeStats + 1) or current
                local cfgCap = GetUpgLimit(slot)
                local effectiveMax = (cfgCap > 0) and math.min(cfgCap, maxUpgrade) or maxUpgrade
                table.insert(result, {
                    guid           = guid,
                    slot           = slot,
                    unitName       = profile.UnitData.Name,
                    currentUpgrade = current,
                    effectiveMax   = effectiveMax,
                    isFarm         = profile.UnitConfig.EconomyTower == true,
                    unitConfig     = profile.UnitConfig,
                })
            end
        end
    end
    return result
end
local function GetNextUpgradePrice(e)
    local stats = e.unitConfig and e.unitConfig.UpgradeStats
    local nextStat = stats and stats[e.currentUpgrade]
    return nextStat and nextStat.UpgradePrice
end
local function UpgradeCand(units)
    local method    = Options.APUpgradeMethod and Options.APUpgradeMethod.Value or "Lowest Level (Spread Upgrade)"
    local focusFarm = Toggles.APFocusFarm and Toggles.APFocusFarm.Value
    local cash      = (Modules.GameData and Modules.GameData.Cash) or 0
    local upgradable = {}
    for _, e in ipairs(units) do
        if e.currentUpgrade < e.effectiveMax then
            local price = GetNextUpgradePrice(e)
            if not price or price <= cash then
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
        table.sort(upgradable, function(a, b) return a.currentUpgrade < b.currentUpgrade end)
        return upgradable[1]
    elseif method == "Hotbar left to right (until Max)" or method == "Customize upgrade order (Set below)" then
        table.sort(upgradable, function(a, b)
            local sa, sb = a.slot or 99, b.slot or 99
            if sa ~= sb then return sa < sb end
            return a.currentUpgrade < b.currentUpgrade
        end)
        return upgradable[1]
    end
    return upgradable[1]
end
local function IsUnitLocked(guid)
    if not Modules.UnitProfiles then return false end
    local unit = Modules.UnitProfiles[guid]
    return unit and unit.Locked == true
end
local function Func_AutoSellFarm()
    local lastSold = false
    while Toggles.AutoSellFarm.Value do
        local wave = (Modules.GameData and Modules.GameData.Wave) or 0
        local targetWave = tonumber(Options.SellFarmWave.Value) or 0
        if IsBattleActive() and targetWave > 0 and wave >= targetWave then
            if not lastSold then
                lastSold = true
                local sold = 0
                for _, unit in ipairs(GetPlacedUnitsForSlots()) do
                    if unit.isFarm and not IsUnitLocked(unit.guid) then
                        pcall(function() Remotes.RemoveUnit:FireServer(unit.guid) end)
                        sold = sold + 1
                    end
                end
                notyuri("[AutoSellFarm] Sold " .. sold .. " farm units at wave " .. wave)
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
        local wave = (Modules.GameData and Modules.GameData.Wave) or 0
        local targetWave = tonumber(Options.SellUnitWave.Value) or 0
        if IsBattleActive() and targetWave > 0 and wave >= targetWave then
            if not lastSold then
                lastSold = true
                pcall(function() Remotes.SellAll:FireServer() end)
                notyuri("[AutoSell] Sold all units at wave " .. wave)
            end
        else
            lastSold = false
        end
        task.wait(2)
    end
end
local function DoAPUpgrade()
    local units  = GetPlacedUnitsForSlots()
    local target = UpgradeCand(units)
    if not target then return false end
    pcall(function()
        Remotes.UpgradeUnit:FireServer(target.guid)
    end)
    notyuri("[AutoPlay] UpgradeUnit slot=" .. tostring(target.slot) .. " unit=" .. target.unitName .. " lv=" .. target.currentUpgrade)
    task.wait(0.1)
    return true
end
local function PlacePhase(currentWave)
    local mapName = GetCurrentMapName()
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
        if placeWave > 0 and currentWave < placeWave then
            allPlaced = false
        else
            local guid = GetSlotGUID(slot)
            local unitName = GetSlotName(slot)
            if guid and unitName then
                local limit  = GetPlcLimit(slot)
                if limit > 0 then
                    local placed = CountPlaced(slot)
                    local need = limit - placed
                    if need > 0 then
                        allPlaced = false
                        if not FailedPositions[mapName] then FailedPositions[mapName] = {} end
                        local failed = FailedPositions[mapName]
                        local positions = {}
                        local slotCfg = mapName and SlotPositions[mapName] and SlotPositions[mapName][slot]
                        local centerRaw = mapName and MCENTERS[mapName]
                        local center = centerRaw and centerRaw ~= Vector3.new(0, 0, 0)
                            and Vector3.new(centerRaw.X, GetGround(centerRaw), centerRaw.Z) or nil
                        if slotCfg and #slotCfg > 0 then
                            local centerPos = slotCfg[1].Position
                            local cursorKey = mapName .. ":" .. FailKey(centerPos)
                            if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
                            local cache = SpanCache[cursorKey]
                            local idx = SpanCursor[cursorKey] or 0
                            local collected = 0
                            if #slotCfg >= limit then
                                for i = 1, #slotCfg do
                                    if not failed[FailKey(slotCfg[i].Position)] then
                                        table.insert(positions, slotCfg[i])
                                    end
                                end
                            end
                            if #positions == 0 then
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
                        elseif center then
                            local cursorKey = mapName .. ":center"
                            if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
                            local cache = SpanCache[cursorKey]
                            local idx = SpanCursor[cursorKey] or 0
                            local collected = 0
                            while collected < need do
                                idx = idx + 1
                                DoSpan(cache, center, idx)
                                local cf = cache[idx]
                                if not failed[FailKey(cf.Position)] then
                                    table.insert(positions, cf)
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
                            local cf = positions[placedThisCall]
                            local ghost = PCubeAcq()
                            ghost.CFrame = cf * CFrame.new(0, 0.5, 0)
                            local countBefore = CountPlaced(slot)
                            local ok = false
                            pcall(function()
                                Remotes.PlaceUnit:FireServer({
                                    PlaceCFrame = cf,
                                    UnitGUID    = guid,
                                })
                            end)
                            task.wait(0.3)
                            if CountPlaced(slot) > countBefore then
                                ok = true
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
                                waitingForCash = true
                                break
                            else
                                if Toggles.APPlaceAndUpgrade and Toggles.APPlaceAndUpgrade.Value then
                                    DoAPUpgrade()
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
    end
    return allPlaced
end
local function Func_AutoPlay()
    while Toggles.AutoPlay.Value do
        if IsBattleActive() then
            local wave = (Modules.GameData and Modules.GameData.Wave) or 0
            local allPlaced = PlacePhase(wave)
            if allPlaced and Toggles.APAutoUpgrade and Toggles.APAutoUpgrade.Value then
                local didUpgrade = DoAPUpgrade()
                if not didUpgrade then
                    task.wait(1)
                end
            end
            task.wait(0.1)
        else
            PCubeReleaseAll()
            task.wait(1)
        end
    end
end
local function HandleRecordedAction(kind, data, capturedElapsed)
    if not MState.Rec or not MState.Cur then return end
    local elapsed = capturedElapsed or 0.0
    MState.Step = MState.Step + 1
    local entry = { Type = kind, Elapsed = elapsed }
    for k, val in pairs(data or {}) do
        entry[k] = val
    end
    table.insert(MState.Cur.entries, entry)
    UpdateLabel(kind, elapsed)
    notyuri("[Macro Rec] recorded", kind, string.format("%.2f", elapsed))
end
local function InstallMacroHook()
    if MState.Hooked then return end
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local self = ...
        local Method = getnamecallmethod()
        local ret = table.pack(originalNamecall(...))
        if MState.Rec and Method == "FireServer" then
            local capturedElapsed = GetElapsedBattleTime()
            if rawequal(self, Remotes.PlaceUnit) then
                local arg2 = select(2, ...)
                if type(arg2) == "table" and arg2.UnitGUID and arg2.PlaceCFrame then
                    local cf = arg2.PlaceCFrame
                    local rawGuid = arg2.UnitGUID
                    task.defer(function()
                        if not MState.Rec then return end
                        local placed = WaitForUnitPlaced(rawGuid, 2)
                        if not MState.Rec then return end
                        if not placed then
                            notyuri("[Macro Rec] Place GUARD FAIL: no UnitPlaced event for GUID", tostring(rawGuid))
                            return
                        end
                        HandleRecordedAction("Place", {
                            UnitGUID = rawGuid,
                            CFrame = { cf:GetComponents() },
                        }, capturedElapsed)
                    end)
                end
            elseif rawequal(self, Remotes.UpgradeUnit) then
                local guid, targetLevel = select(2, ...)
                if type(guid) == "string" then
                    local beforeLevel = GetUnitUpgradeLevel(guid)
                    task.defer(function()
                        task.wait(0.5)
                        if not MState.Rec then return end
                        local afterLevel = GetUnitUpgradeLevel(guid)
                        if beforeLevel ~= nil and afterLevel ~= nil and afterLevel <= beforeLevel then
                            notyuri("[Macro Rec] Upgrade GUARD FAIL: level unchanged for GUID", tostring(guid))
                            return
                        end
                        HandleRecordedAction("Upgrade", {
                            UnitGUID = guid,
                            TargetLevel = targetLevel,
                        }, capturedElapsed)
                    end)
                end
            elseif rawequal(self, Remotes.RemoveUnit) then
                local guid = select(2, ...)
                if type(guid) == "string" then
                    task.defer(function()
                        HandleRecordedAction("Remove", { UnitGUID = guid }, capturedElapsed)
                    end)
                end
            elseif rawequal(self, Remotes.UpgradeAll) then
                task.defer(function()
                    HandleRecordedAction("UpgradeAll", {}, capturedElapsed)
                end)
            elseif rawequal(self, Remotes.SellAll) then
                task.defer(function()
                    HandleRecordedAction("SellAll", {}, capturedElapsed)
                end)
            elseif rawequal(self, Remotes.TargetUnit) then
                local targetGuid = select(2, ...)
                if type(targetGuid) == "string" then
                    task.defer(function()
                        HandleRecordedAction("Target", {
                            TargetGUID = targetGuid,
                        }, capturedElapsed)
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
    InstallMacroHook()
    MState.Cur = { entries = {} }
    MState.Step = 0
    MState.StartRelay = false
    MState.Rec = true
    UpdateLabel("Waiting")
    task.spawn(LabelPump)
    notyuri("[Macro Rec] recording started (pre-battle placements captured at 0.00s)")
    while Toggles.MacroRecord.Value and not IsBattleActive() do
        task.wait()
    end
    if not Toggles.MacroRecord.Value then
        MState.Rec = false
        MState.Cur = nil
        MState.Step = 0
        UpdateLabel()
        return
    end
    UpdateLabel()
    notyuri("[Macro Rec] battle started, continuing recording")
    while Toggles.MacroRecord.Value do
        task.wait()
    end
    MState.Rec = false
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
local function DoMacroAction(entry)
    if entry.Type == "Place" then
        Remotes.PlaceUnit:FireServer({
            PlaceCFrame = ArrToCFrame(entry.CFrame),
            UnitGUID = entry.UnitGUID,
        })
    elseif entry.Type == "Upgrade" then
        if entry.TargetLevel then
            Remotes.UpgradeUnit:FireServer(entry.UnitGUID, entry.TargetLevel)
        else
            Remotes.UpgradeUnit:FireServer(entry.UnitGUID)
        end
    elseif entry.Type == "Remove" then
        Remotes.RemoveUnit:FireServer(entry.UnitGUID)
    elseif entry.Type == "UpgradeAll" then
        Remotes.UpgradeAll:FireServer()
    elseif entry.Type == "SellAll" then
        Remotes.SellAll:FireServer()
    elseif entry.Type == "Target" then
        Remotes.TargetUnit:FireServer(entry.TargetGUID)
    end
end
local function Func_MacroReplay()
    local macro = MState.Load
    if not macro or not macro.entries or #macro.entries == 0 then
        Toggles.LoadMacro:SetValue(false)
        Library:Notify("No macro loaded", 3)
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
        notyuri("[Macro Rep] battle active, starting replay pass")
        for i, entry in ipairs(macro.entries) do
            if not Toggles.LoadMacro.Value then break end
            if not IsBattleActive() then
                notyuri("[Macro Rep] battle ended mid-replay, aborting pass")
                break
            end
            MState.Step = i
            UpdateLabel(entry.Type, entry.Elapsed)
            while Toggles.LoadMacro.Value and IsBattleActive() do
                local elapsed = GetElapsedBattleTime()
                if elapsed and elapsed >= entry.Elapsed then break end
                task.wait()
            end
            if Toggles.LoadMacro.Value and IsBattleActive() then
                local ok, err = pcall(DoMacroAction, entry)
                if not ok then
                    notyuri("[Macro Rep] action failed:", tostring(err))
                end
            end
        end
        UpdateLabel("Finished")
        notyuri("[Macro Rep] pass complete, waiting for next battle")
        while Toggles.LoadMacro.Value and IsBattleActive() do
            task.wait()
        end
    end
    MState.Rep = false
    MState.Step = 0
    UpdateLabel()
end
local function Func_AutoStart()
    if Connections.AutoStart then
        Connections.AutoStart:Disconnect()
        Connections.AutoStart = nil
    end
    Connections.AutoStart = Remotes.VoteEvent.OnClientEvent:Connect(function(dispatchKey, payload)
        if not Toggles.AutoStart.Value then return end
        if dispatchKey ~= "StartVote" then return end
        if type(payload) ~= "table" or payload.Type ~= "Game" or not payload.ID then return end
        Remotes.VoteEvent:FireServer(payload.ID)
        notyuri("[AutoStart] voted yes on", tostring(payload.ID))
    end)
end
local function Func_AutoNext()
    if Connections.AutoNext then
        Connections.AutoNext:Disconnect()
        Connections.AutoNext = nil
    end
    Connections.AutoNext = Remotes.VoteEvent.OnClientEvent:Connect(function(dispatchKey, payload)
        if not Toggles.AutoNext.Value then return end
        if dispatchKey ~= "StartVote" then return end
        if type(payload) ~= "table" or payload.Type ~= "EndGame" or payload.ID ~= "Next" then return end
        Remotes.VoteEvent:FireServer(payload.ID)
        notyuri("[AutoNext] voted Next")
    end)
end
local function Func_AutoReplay()
    if Connections.AutoReplay then
        Connections.AutoReplay:Disconnect()
        Connections.AutoReplay = nil
    end
    Connections.AutoReplay = Remotes.VoteEvent.OnClientEvent:Connect(function(dispatchKey, payload)
        if not Toggles.AutoReplay.Value then return end
        if dispatchKey ~= "StartVote" then return end
        if type(payload) ~= "table" or payload.Type ~= "EndGame" or payload.ID ~= "Again" then return end
        Remotes.VoteEvent:FireServer(payload.ID)
        notyuri("[AutoReplay] voted Again")
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
        T1 = TB.Main.Left.Autofarm:AddTab("Macro"),
        T2 = TB.Main.Left.Autofarm:AddTab("Game"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Game Config"),
    },
}
local APLeft  = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
local APRight = Tabs.AutoPlay:AddRightGroupbox("Limits")
APLeft:AddToggle("AutoPlay", {
    Text    = "Auto Play",
    Default = false,
})
APLeft:AddDivider()
APLeft:AddDropdown("APUpgradeMethod", {
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
APLeft:AddToggle("APAutoUpgrade", {
    Text    = "Auto Upgrade",
    Default = false,
})
APLeft:AddToggle("APPlaceAndUpgrade", {
    Text    = "Place and Upgrade",
    Default = false,
})
APLeft:AddToggle("APFocusFarm", {
    Text    = "Focus on Farm",
    Default = false,
})
APRight:AddLabel("Place Order per Slot", true)
for i = 1, 6 do
    APRight:AddSlider("APPlaceOrder" .. i, {
        Text     = "Slot " .. i,
        Default  = i,
        Min      = 1,
        Max      = 6,
        Rounding = 0,
        Compact  = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Place Wave per Slot", true)
for i = 1, 6 do
    APRight:AddSlider("APPlaceWave" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 50,
        Rounding = 0,
        Compact  = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Place Limit per Slot", true)
for i = 1, 6 do
    APRight:AddSlider("APPlaceLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 10,
        Rounding = 0,
        Compact  = true,
    })
end
APRight:AddDivider()
APRight:AddLabel("Upgrade Limit per Slot", true)
for i = 1, 6 do
    APRight:AddSlider("APUpgradeLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 30,
        Rounding = 0,
        Compact  = true,
    })
end
local Pos_A = Tabs.AutoPlay:AddLeftGroupbox("Set Position")
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
Toggles.AutoPlay:OnChanged(function(v)
    Thread("AutoPlay", SafeLoop("AutoPlay", Func_AutoPlay), v)
end)
TB_Tabs.Autofarm2.T1:AddSlider("SellUnitWave", { Text = "Sell Wave", Default = 0, Min = 0, Max = 50, Rounding = 0 })
TB_Tabs.Autofarm.T2:AddToggle("AutoSell", { Text = "Auto Sell", Default = false })
TB_Tabs.Autofarm2.T1:AddSlider("SellFarmWave", { Text = "Sell Farm Wave", Default = 0, Min = 0, Max = 50, Rounding = 0 })
TB_Tabs.Autofarm.T2:AddToggle("AutoSellFarm", { Text = "Auto Sell Farm", Default = false })
Toggles.AutoSell:OnChanged(function(v)
    Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSell), v)
end)
Toggles.AutoSellFarm:OnChanged(function(v)
    Thread("AutoSellFarm", SafeLoop("AutoSellFarm", Func_AutoSellFarm), v)
end)

task.spawn(function()
    while not Library.Unloaded do
        UpdatePosLabels()
        task.wait(2)
    end
end)
local NightValues = { "1", "2", "3", "4", "5", "6", "Custom Night" }
local function NightValueToLevel(v)
    if v == "Custom Night" then
        return CustomNightConfig.Night
    end
    return tonumber(v)
end
local function AwaitElevatorJoinedThenStart()
    if Connections.Elevator then
        Connections.Elevator:Disconnect()
        Connections.Elevator = nil
    end
    Connections.Elevator = Packets.Elevator.Joined.OnClientEvent:Connect(function()
        if Connections.Elevator then
            Connections.Elevator:Disconnect()
            Connections.Elevator = nil
        end
        Packets.Elevator.Start:Fire()
        notyuri("[Joiner] Elevator joined, starting")
    end)
end
local RG = Tabs.Joiner:AddLeftGroupbox("Regular")
RG:AddDropdown("RGGame", {
    Text    = "Game",
    Values  = { "1", "2", "3", "4", "5", "6" },
    Default = "1",
})
RG:AddDropdown("RGNight", {
    Text    = "Night",
    Values  = NightValues,
    Default = "1",
})
RG:AddDropdown("RGDifficulty", {
    Text    = "Difficulty",
    Values  = { "Easy", "Nightmare" },
    Default = "Easy",
})
RG:AddToggle("RGEndless", {
    Text    = "Endless",
    Default = false,
})
RG:AddToggle("AutoJoinRegular", {
    Text    = "Auto Join",
    Default = false,
})
local SG = Tabs.Joiner:AddRightGroupbox("Special")
SG:AddDropdown("SGGamemode", {
    Text    = "Gamemode",
    Values  = { "Boss Raid", "The Tower" },
    Default = "Boss Raid",
})
SG:AddToggle("AutoJoinGamemode", {
    Text    = "Auto Join",
    Default = false,
})
Toggles.AutoJoinRegular:OnChanged(function(v)
    if not v then return end
    if Toggles.AutoJoinGamemode.Value then
        Toggles.AutoJoinGamemode:SetValue(false)
    end
    AwaitElevatorJoinedThenStart()
    Packets.Elevator.Create:Fire({
        Night            = tonumber(Options.RGGame.Value),
        Level            = NightValueToLevel(Options.RGNight.Value),
        Endless          = Toggles.RGEndless.Value,
        CustomDifficulty = nil,
        Sandbox          = false,
        ElevatorIndex    = 1,
        MaxMembers       = 1,
        Difficulty       = Options.RGDifficulty.Value,
    })
    notyuri("[Joiner] Elevator.Create fired (Regular Game " .. Options.RGGame.Value .. ", Night " .. Options.RGNight.Value .. ")")
    task.spawn(function()
        Toggles.AutoJoinRegular:SetValue(false)
    end)
end)
Toggles.AutoJoinGamemode:OnChanged(function(v)
    if not v then return end
    if Toggles.AutoJoinRegular.Value then
        Toggles.AutoJoinRegular:SetValue(false)
    end
    local gamemode = Options.SGGamemode.Value == "The Tower" and "TheTower" or "BossRaids"
    AwaitElevatorJoinedThenStart()
    Packets.Elevator.Create:Fire({
        Night          = 1,
        Level          = 1,
        Endless        = false,
        Sandbox        = false,
        Difficulty     = "Easy",
        Tutorial       = false,
        ElevatorIndex  = 1,
        Gamemode       = gamemode,
        MaxMembers     = 1,
    })
    notyuri("[Joiner] Elevator.Create fired (Gamemode " .. gamemode .. ")")
    task.spawn(function()
        Toggles.AutoJoinGamemode:SetValue(false)
    end)
end)
local WH1 = Tabs.Webhook:AddLeftGroupbox("Webhook")
WH1:AddInput("WebhookURL", { Text = "Webhook URL", Default = "" })
WH1:AddToggle("WHMatchEnd", { Text = "Match Finished", Default = false })
Toggles.WHMatchEnd:OnChanged(function(v)
    Thread("WHMatchEnd", SafeLoop("WHMatchEnd", Func_WHMatchEnd), v)
end)
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
TB_Tabs.Autofarm.T1:AddInput("FileName", {
    Text        = "File Name",
    Default     = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T1:AddToggle("MacroRecord", {
    Text    = "Record Macro",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", {
    Text    = "Play Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
Toggles.MacroRecord:OnChanged(function(v)
    if v then
        Thread("MacroRecord", Func_MacroRecord, true, true)
    end
end)
Toggles.LoadMacro:OnChanged(function(v)
    if v then
        if not MState.Load then
            Library:Notify("No macro loaded", 3)
            Toggles.LoadMacro:SetValue(false)
            return
        end
        Thread("MacroReplay", Func_MacroReplay, true)
    else
        Thread("MacroReplay", Func_MacroReplay, false)
    end
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoStart", {
    Text    = "Auto Start",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoNext", {
    Text    = "Auto Next",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoReplay", {
    Text    = "Auto Replay",
    Default = false,
})
Toggles.AutoStart:OnChanged(function(v)
    if v then
        Func_AutoStart()
    elseif Connections.AutoStart then
        Connections.AutoStart:Disconnect()
        Connections.AutoStart = nil
    end
end)
Toggles.AutoNext:OnChanged(function(v)
    if v then
        if Toggles.AutoReplay and Toggles.AutoReplay.Value then
            Toggles.AutoReplay:SetValue(false)
        end
        Func_AutoNext()
    elseif Connections.AutoNext then
        Connections.AutoNext:Disconnect()
        Connections.AutoNext = nil
    end
end)
Toggles.AutoReplay:OnChanged(function(v)
    if v then
        if Toggles.AutoNext and Toggles.AutoNext.Value then
            Toggles.AutoNext:SetValue(false)
        end
        Func_AutoReplay()
    elseif Connections.AutoReplay then
        Connections.AutoReplay:Disconnect()
        Connections.AutoReplay = nil
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
SaveManager:SetFolder("Yuri/5NTD2")
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