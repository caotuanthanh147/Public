if getgenv().yuriSurviveZombieWave then
    return
end
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end
cloneref     = missing("function", cloneref, function(...) return ... end)
getgc        = missing("function", getgc or get_gc_objects)
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
local Players        = Services.Players
local Plr            = Players.LocalPlayer
local Char           = Plr.Character or Plr.CharacterAdded:Wait()
local PGui           = Plr:WaitForChild("PlayerGui")
local Lighting       = game:GetService("Lighting")
local RS             = Services.ReplicatedStorage
local RunService     = Services.RunService
local HttpService    = Services.HttpService
local GuiService     = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace    = Services.MarketplaceService
local UIS            = Services.UserInputService
local VirtualUser    = Services.VirtualUser
local VIM            = Services.VirtualInputManager
local TweenService   = Services.TweenService
local Place = {
    Lobby = 114204398207377,
    Arena  = 98927955463992,
}
local SAFE_ZONE_POS = Vector3.new(-242, 493, -366)
local v, Asset = pcall(function()
    return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "survive the zombie wave"
if v and Asset then
    assetName = Asset.Name
end
local Support = {
    Webhook       = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard     = (typeof(setclipboard) == "function"),
    FileIO        = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
    Connections   = (typeof(getconnections) == "function"),
    FPS           = (typeof(setfpscap) == "function"),
    Proximity     = (typeof(fireproximityprompt) == "function"),
}
local executorName        = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors    = {"xeno"}
local isLimitedExecutor   = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
local repo        = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().yuriSurviveZombieWave = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"
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
}
local function AddInfo(Window)
    local InfoTab   = Window:AddTab("Info")
    local InfoLeft  = InfoTab:AddLeftGroupbox("Information")
    local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
    local extraNote  = isLimitedExecutor
        and "<b>NOTE:</b> May experience bugs for some features!"
        or "All features should work properly!"
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
    local hours   = math.floor(seconds / 3600)
    local mins    = math.floor((seconds % 3600) / 60)
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
        local success, result = pcall(function()
            return current:FindFirstChild(name)
        end)
        if success then
            current = result
        else
            return nil
        end
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
local Remotes = {
    GunFire         = GetRemote(RS, "GunRemotes.GunFire"),
    GunHit          = GetRemote(RS, "GunRemotes.GunHit"),
    PurchaseWeapon  = GetRemote(RS, "UpgradeRemotes.PurchaseWeaponUpgrade"),
    PurchaseHealth  = GetRemote(RS, "UpgradeRemotes.PurchaseHealthUpgrade"),
    CreateParty     = GetRemote(RS, "QueueRemotes.CreateParty"),
    LeaveQueue      = GetRemote(RS, "QueueRemotes.LeaveQueue"),
    GameOverStarted = GetRemote(RS, "GameStateRemotes.GameOverStarted"),
    VotePlayAgain   = GetRemote(RS, "GameStateRemotes.VotePlayAgain"),
    GameStateUpdate = GetRemote(RS, "WaveRemotes.GameStateUpdate"),
    GearPurchase    = GetRemote(RS, "GearRemotes.GearPurchase"),
}

local GearData = GetSafeModule(RS:WaitForChild("Data"), "GearData")
local GearNames = {}
if GearData and GearData.GetAllGearNames then
    for _, name in ipairs(GearData:GetAllGearNames()) do
        table.insert(GearNames, name)
    end
    table.sort(GearNames)
end
local CurrentWave = 0
local WaveCacheConn = nil

if Remotes.GameStateUpdate then
    WaveCacheConn = Remotes.GameStateUpdate.OnClientEvent:Connect(function(state, waveNumber)
        CurrentWave = waveNumber
    end)
end
local AutoSkillWaveConn = nil
local AutoSkillSpamThread = nil
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
local function StopAutoSkill()
    if AutoSkillWaveConn then
        AutoSkillWaveConn:Disconnect()
        AutoSkillWaveConn = nil
    end
    if AutoSkillSpamThread then
        task.cancel(AutoSkillSpamThread)
        AutoSkillSpamThread = nil
    end
end
local function StartAutoSkill()
    StopAutoSkill()
    if not Remotes.GearPurchase then return end
    if not Remotes.GameStateUpdate then return end
    AutoSkillWaveConn = Remotes.GameStateUpdate.OnClientEvent:Connect(function(state, waveNumber)
        if state == "GameEnded" or state == "GameOver" then
            if AutoSkillSpamThread then
                task.cancel(AutoSkillSpamThread)
                AutoSkillSpamThread = nil
            end
            return
        end
        if state ~= "WaveStarted" then return end
        if not Toggles.AutoUseSkill or not Toggles.AutoUseSkill.Value then return end
        local afterWave = Options.AutoSkillAfterWave and tonumber(Options.AutoSkillAfterWave.Value) or 0
        if afterWave > 0 and waveNumber < afterWave then return end
        local rawSelected = Options.GearDropdown and Options.GearDropdown.Value or {}
        local selectedGears = {}
        for name, active in pairs(rawSelected) do
            if active then table.insert(selectedGears, name) end
        end
        if #selectedGears == 0 then return end
        if AutoSkillSpamThread then task.cancel(AutoSkillSpamThread) end
        AutoSkillSpamThread = task.spawn(function()
            while true do
                for _, gearName in ipairs(selectedGears) do
                    pcall(function()
                        Remotes.GearPurchase:FireServer(gearName)
                    end)
                    task.wait(0.05)
                end
            end
        end)
    end)
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
local Flags = {}
local function Thread(featurePath, featureFunc, isEnabled, ...)
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
            currentTable[flagKey] = task.spawn(featureFunc, ...)
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
        while true do
            local success, err = pcall(func)
            if not success then
                Library:Notify("Error in [" .. name .. "]: " .. tostring(err), 10)
            end
            task.wait()
        end
    end
end
local function EquipWeapon()
    local char = Plr.Character
    if not char then return end
    if char:FindFirstChildOfClass("Tool") then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local backpack = Plr:FindFirstChild("Backpack")
    if not backpack then return end
    for _, t in ipairs(backpack:GetChildren()) do
        if t:IsA("Tool") then
            hum:EquipTool(t)
            return
        end
    end
end
local function GetEquippedGunName()
    local char = Plr.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then return tool.Name end
    end
    return nil
end
local ZombiesFolder = workspace:WaitForChild("Zombies_Local", 30)
local function DoAutoHit()
    if not ZombiesFolder then task.wait() return end
    if not Remotes.GunFire or not Remotes.GunHit then task.wait() return end
    EquipWeapon()
    local gunName = GetEquippedGunName()
    if not gunName then task.wait(0.5) return end
    local models = ZombiesFolder:GetChildren()
    if #models == 0 then task.wait() return end
    local hrp   = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    local myPos = hrp and hrp.Position or Vector3.new(0, 0, 0)
    local candidates = {}
    for _, model in ipairs(models) do
        local id = tonumber(model.Name:match("^Zombie_(%d+)$"))
        if id and model.PrimaryPart then
            local dist = (model.PrimaryPart.Position - myPos).Magnitude
            table.insert(candidates, { id = id, dist = dist, pos = model.PrimaryPart.Position })
        end
    end
    table.sort(candidates, function(a, b) return a.dist < b.dist end)
    local firedCount = 0
    for _, entry in ipairs(candidates) do
        if firedCount >= 5 then break end
        local ok, fireErr = pcall(function()
            Remotes.GunFire:FireServer(gunName)
            Remotes.GunHit:FireServer(gunName, entry.id, entry.pos)
        end)
        if not ok then
        else
            firedCount += 1
        end
    end
end
local SharedBC = {
    BVelName = "YuriBV",
    BGName   = "YuriBG",
    BV       = nil,
    BG       = nil,
    BOrg     = {},
}
local function enableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == SharedBC.BVelName or inst.Name == SharedBC.BGName then
            inst:Destroy()
        end
    end
    SharedBC.BOrg = {}
    SharedBC.BOrg[hrp] = hrp.Anchored
    hrp.Anchored = false
    SharedBC.BV = Instance.new("BodyVelocity")
    SharedBC.BV.Name      = SharedBC.BVelName
    SharedBC.BV.MaxForce  = Vector3.new(1e6, 1e6, 1e6)
    SharedBC.BV.Velocity  = Vector3.zero
    SharedBC.BV.Parent    = hrp
    SharedBC.BG = Instance.new("BodyGyro")
    SharedBC.BG.Name      = SharedBC.BGName
    SharedBC.BG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    SharedBC.BG.CFrame    = hrp.CFrame
    SharedBC.BG.Parent    = hrp
end
local function disableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == SharedBC.BVelName or inst.Name == SharedBC.BGName then
            inst:Destroy()
        end
    end
    SharedBC.BV = nil
    SharedBC.BG = nil
    if SharedBC.BOrg and SharedBC.BOrg[hrp] ~= nil then
        hrp.Anchored = SharedBC.BOrg[hrp]
    end
    SharedBC.BOrg = {}
end
local function DoAutoSafeZone()
    if game.PlaceId == Place.Lobby then return end
    local char = Plr.Character
    if not char then task.wait(1) return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then task.wait(1) return end
    hrp.CFrame = CFrame.new(SAFE_ZONE_POS)
    if not SharedBC.BV or not SharedBC.BV.Parent then
        enableBodyControl(hrp)
    end
    if SharedBC.BV then SharedBC.BV.Velocity = Vector3.zero end
    if SharedBC.BG then SharedBC.BG.CFrame    = hrp.CFrame end
    task.wait(0.1)
end
local function DoAutoUpgrade()
    if not Remotes.PurchaseWeapon then
        task.wait(2)
        return
    end
    local ok, upgradeErr = pcall(function()
        Remotes.PurchaseWeapon:FireServer()
    end)
    if not ok then
    else
    end
    task.wait(1)
end
local function FindEmptyShip()
    local queues = workspace:FindFirstChild("Queues")
    if not queues then
        return nil, nil
    end
    for _, ship in ipairs(queues:GetChildren()) do
        if not ship.Name:match("^Ship") then continue end
        local billboardPart = ship:FindFirstChild("BillboardPart")
        local touchPart     = ship:FindFirstChild("TouchPart")
        if not billboardPart or not touchPart then
            continue
        end
        local playerGui  = billboardPart:FindFirstChild("PlayerGui")
        local countLabel = playerGui and playerGui:FindFirstChild("PlayerCount")
        if not countLabel then
            continue
        end
        local text    = countLabel.Text
        local current = tonumber(text:match("^(%d+)/"))
        if current and current == 0 then
            return ship.Name, touchPart.CFrame
        end
    end
    return nil, nil
end
local function TeleportToQueueArea()
    local shipName, touchCFrame = FindEmptyShip()
    if not shipName or not touchCFrame then
        return false
    end
    local char = Plr.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame = touchCFrame * CFrame.new(0, 3, 0)
    return true
end
local function FireCreateParty(difficulty, partySize)
    if not Remotes.CreateParty then
        return false
    end
    local ok, queueErr = pcall(function()
        Remotes.CreateParty:FireServer(partySize or 1, difficulty or "Normal")
    end)
    if not ok then
        return false
    end
    return true
end
local function DoAutoQueue()
    if game.PlaceId == Place.Arena then return end
    local ok = TeleportToQueueArea()
    if not ok then task.wait(3) return end
    task.wait(0.5)
    local difficulty = Options.DifficultyDropdown and Options.DifficultyDropdown.Value or "Normal"
    if not FireCreateParty(difficulty, 1) then task.wait(3) return end
    local waited = 0
    while waited < 7 do
        task.wait(1)
        waited += 1
        if game.PlaceId == Place.Arena then
            break
        end
    end
    if game.PlaceId ~= Place.Arena then
        return
    end
    task.wait(8) 
end
local AutoResetWaveConn = nil
local function StartAutoResetWave()
    if AutoResetWaveConn then
        AutoResetWaveConn:Disconnect()
        AutoResetWaveConn = nil
    end
    if not Remotes.GameStateUpdate then return end
    AutoResetWaveConn = Remotes.GameStateUpdate.OnClientEvent:Connect(function(state, waveNumber)
        if state ~= "WaveStarted" then return end
        if not Toggles.AutoResetWave or not Toggles.AutoResetWave.Value then return end
        local targetWave = Options.AutoResetWaveNumber and tonumber(Options.AutoResetWaveNumber.Value) or 0
        if targetWave <= 0 then return end
        if waveNumber == targetWave then
            local char = Plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Dead)
            end
        end
    end)
end
local function StopAutoResetWave()
    if AutoResetWaveConn then
        AutoResetWaveConn:Disconnect()
        AutoResetWaveConn = nil
    end
end
local AutoRetryConn = nil
local function StopAutoRetry()
    if AutoRetryConn then
        AutoRetryConn:Disconnect()
        AutoRetryConn = nil
    end
end
local function StartAutoRetry()
    StopAutoRetry()
    if not Remotes.GameOverStarted then return end
    AutoRetryConn = Remotes.GameOverStarted.OnClientEvent:Connect(function()
        if not Toggles.AutoRetry or not Toggles.AutoRetry.Value then return end
        task.wait(2)
        if not Toggles.AutoRetry or not Toggles.AutoRetry.Value then return end
        if Remotes.VotePlayAgain then
            Remotes.VotePlayAgain:FireServer()
        end
    end)
end
local Window = Library:CreateWindow({
    Title = "Yuri",
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    UnlockMouseWhileOpen = true,
    NotifySide = "Left",
    TabPadding = 8,
    MenuFadeTime = 0.2,
})
AddInfo(Window)
local Tabs = {
    Main   = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local Main     = Tabs.Main:AddLeftGroupbox("Combat")
local Lobby = Tabs.Main:AddRightGroupbox("Lobby")
local GearGroup = Tabs.Main:AddLeftGroupbox("Skills")
local PlayerGroup = Tabs.Player:AddRightGroupbox("Player")
local ServerGroup = Tabs.Player:AddLeftGroupbox("Server")
Main:AddToggle("AutoHit", {
    Text    = "Auto Hit All Zombie",
    Default = false,
})
Toggles.AutoHit:OnChanged(function(state)
    Thread("AutoHit", SafeLoop("AutoHit", DoAutoHit), state)
end)
Main:AddToggle("AutoSafeZone", {
    Text    = "Teleport Safe Zone",
    Default = false,
})
Toggles.AutoSafeZone:OnChanged(function(state)
    if state then
        Thread("AutoSafeZone", SafeLoop("AutoSafeZone", DoAutoSafeZone), true)
    else
        Thread("AutoSafeZone", nil, false)
        local char = Plr.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then disableBodyControl(hrp) end
    end
end)
Main:AddToggle("AutoUpgrade", {
    Text    = "Auto Upgrade Weapon",
    Default = false,
})
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", DoAutoUpgrade), state)
end)
Main:AddToggle("AutoResetWave", {
    Text    = "Auto Reset On Wave",
    Default = false,
})
Main:AddInput("AutoResetWaveNumber", {
    Text        = "Reset On Wave",
    AllowNull = true,
    Numeric     = true,
    Finished    = false,
})
Toggles.AutoResetWave:OnChanged(function(state)
    if state then
        StartAutoResetWave()
    else
        StopAutoResetWave()
    end
end)
Main:AddToggle("AutoRetry", {
    Text    = "Auto Retry",
    Default = false,
})
Toggles.AutoRetry:OnChanged(function(state)
    if state then
        StartAutoRetry()
    else
        StopAutoRetry()
    end
end)
GearGroup:AddDropdown("GearDropdown", {
    Values      = GearNames,
    Default     = {},
    Multi       = true,
    Text        = "Select Skills",
    AllowNull   = true,
    Searchable = true,
    Callback = function(selected)
        selectedGears = {}
        for name, active in pairs(selected or {}) do
            if active then table.insert(selectedGears, name) end
        end
    end
})
GearGroup:AddToggle("AutoUseSkill", {
    Text    = "Auto Use Skill",
    Default = false,
})
GearGroup:AddInput("AutoSkillAfterWave", {
    Text      = "Use Skill After Wave",
    AllowNull = true,
    Numeric   = true,
    Finished  = false,
})
Toggles.AutoUseSkill:OnChanged(function(state)
    if state then
        StartAutoSkill()
    else
        StopAutoSkill()
    end
end)
Lobby:AddDropdown("DifficultyDropdown", {
    Values  = { "Normal", "Hardcore", "Nightmare" },
    Default = "Normal",
    Text    = "Difficulty",
})
Lobby:AddToggle("AutoQueue", {
    Text    = "Auto Queue",
    Default = false,
})
Toggles.AutoQueue:OnChanged(function(state)
    Thread("AutoQueue", SafeLoop("AutoQueue", DoAutoQueue), state)
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
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = true,
    Callback = function(value) Library.ShowCustomCursor = value end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Left",
    Text     = "Notification Side",
    Callback = function(value) Library:SetNotifySide(value) end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default  = "100%",
    Text     = "DPI Scale",
    Callback = function(value)
        value = value:gsub("%%", "")
        Library:SetDPIScale(tonumber(value))
    end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton({
    Text = "Unload",
    Func = function()
        getgenv().yuriSurviveZombieWave = false
        local char = Plr.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then disableBodyControl(hrp) end
        StopAutoResetWave()
        StopAutoRetry()
        StopAutoSkill()
        Cleanup(Flags)
        Library:Unload()
    end,
})
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/SurviveZombieWave")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
Library.ToggleKeybind = Options.MenuKeybind
SaveManager:IgnoreThemeSettings()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 6)
end
