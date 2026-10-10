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
        notyuri("Your executor does not support firesignal or getconnections.")
    end
end
local _FS = (_DR and _DR.FireServer)
local Remotes = {
}
local Modules = {
}
local UpgradePriceConfig = GetSafeModule(RS, "UpgradePriceConfig")
local EternityNum = GetSafeModule(RS, "EternityNum")
local ResetLayerConfig = GetSafeModule(RS, "ResetLayerConfig")
local ProjectedGain = {}
local GainDisplayEvent = RS:FindFirstChild("GainDisplayEvent")
if GainDisplayEvent then
    GainDisplayEvent.OnClientEvent:Connect(function(key, canReset, gainBase, gainBoosted)
        ProjectedGain[key] = gainBoosted or gainBase
    end)
end
local SuffixList = {
    { label = "None", exp = 0   },
    { label = "k",    exp = 3   },
    { label = "M",    exp = 6   },
    { label = "B",    exp = 9   },
    { label = "T",    exp = 12  },
    { label = "Qd",   exp = 15  },
    { label = "Qn",   exp = 18  },
    { label = "Sx",   exp = 21  },
    { label = "Sp",   exp = 24  },
    { label = "Oc",   exp = 27  },
    { label = "No",   exp = 30  },
    { label = "De",   exp = 33  },
    { label = "UDe",  exp = 36  },
    { label = "DDe",  exp = 39  },
    { label = "TDe",  exp = 42  },
    { label = "QdDe", exp = 45  },
    { label = "QnDe", exp = 48  },
    { label = "SxDe", exp = 51  },
    { label = "SpDe", exp = 54  },
    { label = "OcDe", exp = 57  },
    { label = "NoDe", exp = 60  },
    { label = "Vt",   exp = 63  },
    { label = "UVt",  exp = 66  },
    { label = "DVt",  exp = 69  },
    { label = "TVt",  exp = 72  },
    { label = "QdVt", exp = 75  },
    { label = "QnVt", exp = 78  },
    { label = "SxVt", exp = 81  },
    { label = "SpVt", exp = 84  },
    { label = "OcVt", exp = 87  },
    { label = "NoVt", exp = 90  },
    { label = "Tg",   exp = 93  },
    { label = "UTg",  exp = 96  },
    { label = "DTg",  exp = 99  },
    { label = "TTg",  exp = 102 },
    { label = "QdTg", exp = 105 },
    { label = "QnTg", exp = 108 },
    { label = "SxTg", exp = 111 },
    { label = "SpTg", exp = 114 },
    { label = "OcTg", exp = 117 },
    { label = "NoTg", exp = 120 },
    { label = "qg",   exp = 123 },
    { label = "Qg",   exp = 153 },
    { label = "sg",   exp = 183 },
    { label = "Sg",   exp = 213 },
    { label = "Og",   exp = 243 },
    { label = "Ng",   exp = 273 },
    { label = "Ce",   exp = 303 },
}
local SuffixLabels = {}
local SuffixExpMap = {}
for _, s in ipairs(SuffixList) do
    table.insert(SuffixLabels, s.label)
    SuffixExpMap[s.label] = s.exp
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
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
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
            notyuri("Error in ["..name.."]: "..tostring(err))
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
local function CreateSwitchGroup(tab, id, displayName, tableSource)
    local toggle = tab:AddToggle("Auto"..id, { Text = "Auto Switch "..displayName, Default = false })
    toggle:OnChanged(function(state)
        if not state then
            Shared.LastSwitch[id] = ""
        end
    end)
    local listToUse = (id == "Title") and CombinedTitleList or tableSource
    tab:AddDropdown(id.."_BossHP", { Text = displayName.." [Boss HP%]", Values = listToUse, AllowNull = true, Searchable = true })
    tab:AddSlider(id.."_BossHPAmt", { Text = "Change Until Boss HP%", Default = 15, Min = 0, Max = 100, Rounding = 0 })
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
local function GetUpgradeClickDetector(id)
    local model = workspace:FindFirstChild(tostring(id))
    if not model then
        return nil
    end
    local click = model:FindFirstChild("Click")
    if not click then
        return nil
    end
    return click:FindFirstChildOfClass("ClickDetector")
end
local function Func_AutoUpgrade()
    local PlayerStats = Plr:WaitForChild("PlayerStats")
    local Upgrades = PlayerStats:WaitForChild("Upgrades")
    local Currencies = PlayerStats:WaitForChild("Currencies", 10)
    if not Currencies then
        return
    end
    if not UpgradePriceConfig or not EternityNum then
        return
    end
    if not fireclickdetector then
        return
    end
    local skippedNames = {}
    local skippedNoPrice = {}
    local skippedNoCurrency = {}
    local skippedNoDetector = {}
    while Toggles.AutoUpgrade.Value do
        local children = Upgrades:GetChildren()
        for _, v in ipairs(children) do
            if not Toggles.AutoUpgrade.Value then break end
            if v:IsA("BoolValue") or v:IsA("IntValue") then
                local isRSeries = string.sub(v.Name, 1, 1) == "R"
                local id = isRSeries and v.Name or tonumber(v.Name)
                if id then
                    local settings = UpgradePriceConfig.getBuyableSettings(id)
                    local maxed = false
                    if v:IsA("BoolValue") then
                        maxed = v.Value == true
                    elseif settings and settings.maxLevels then
                        maxed = v.Value >= settings.maxLevels
                    end
                    if not maxed then
                        local basePrice, currency = UpgradePriceConfig.getPrice(id)
                        if not basePrice then
                            skippedNoPrice[v.Name] = true
                            continue
                        end
                        local currencyValue = Currencies:FindFirstChild(currency)
                        if not currencyValue then
                            skippedNoCurrency[tostring(currency)] = true
                            continue
                        end
                        local priceIncrement = settings and settings.priceIncrement or "1"
                        local currentLevel = v:IsA("IntValue") and v.Value or 0
                        local price = EternityNum.mul(
                            EternityNum.convert(basePrice),
                            EternityNum.pow(EternityNum.convert(priceIncrement), EternityNum.fromNumber(currentLevel))
                        )
                        if EternityNum.meeq(currencyValue.Value, price) then
                            local detector = GetUpgradeClickDetector(id)
                            if detector then
                                FireCD(detector)
                                task.wait()
                            else
                                skippedNoDetector[v.Name] = true
                            end
                        end
                    end
                else
                    skippedNames[v.Name] = true
                end
            end
        end
        task.wait()
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
	Main = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Autofarm = Tabs.Main:AddLeftTabbox(),
            MiscAuto = Tabs.Main:AddLeftTabbox(),
        },
    },
}
local TB_Tabs = {
    Autofarm = {
        T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
        T2 = TB.Main.Left.Autofarm:AddTab("Reset"),
        T3 = TB.Main.Left.Autofarm:AddTab("Config"),
    },
}
local GB = {
    Player = {
        Left = {
            General = Tabs.Player:AddLeftGroupbox("General"),
            Server = Tabs.Player:AddLeftGroupbox("Server"),
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
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoClickBurner", { Text = "Auto Burner", Default = false })
local LastReset = {}
local SuffixDropdowns = {}
local function AddResetUI(key, config)
    local reqCurrency = config.requirement and config.requirement[1]
    if not reqCurrency then return end
    local function buildThreshold()
        local numRaw = tonumber(Options[key.."ResetNum"].Value) or 1
        if numRaw <= 0 then numRaw = 1 end
        local convertStr, totalExp
        if Options.NotationMode and Options.NotationMode.Value == "Scientific" then
            totalExp = numRaw
            convertStr = "1;" .. tostring(totalExp)
            notyuri("[AutoReset:"..key..":buildThreshold] mode=Scientific exp=", totalExp, "convertStr=", convertStr)
        else
            local suffixLabel = Options[key.."ResetSuffix"].Value
            local exp = SuffixExpMap[suffixLabel] or 0
            totalExp = math.log10(numRaw) + exp
            convertStr = "1;" .. tostring(totalExp)
            notyuri("[AutoReset:"..key..":buildThreshold] numRaw=", numRaw, "suffixLabel=", suffixLabel, "exp=", exp, "totalExp=", totalExp, "convertStr=", convertStr)
        end
        local result = EternityNum.convert(convertStr)
        notyuri("[AutoReset:"..key..":buildThreshold] result=", result)
        return result
    end
    local suffixDropdown = TB_Tabs.Autofarm.T3:AddDropdown(key.."ResetSuffix", {
        Text    = key .. " Suffix",
        Values  = SuffixLabels,
        Default = "None",
        Multi   = false,
    })
    SuffixDropdowns[key] = suffixDropdown
    TB_Tabs.Autofarm.T3:AddInput(key.."ResetNum", {
        Text    = key .. " Gain",
        Default = "1",
        Numeric = true,
    })
    TB_Tabs.Autofarm.T3:AddSlider(key.."ResetDelay", {
        Text     = key .. " Reset Delay",
        Default  = 0.1,
        Min      = 0,
        Max      = 10,
        Rounding = 1,
        Compact  = true,
    })
    TB_Tabs.Autofarm.T2:AddToggle("AutoReset"..key, {
        Text    = "Auto Reset: " .. key,
        Default = false,
        Callback = function(val)
            Thread("AutoReset."..key, function()
                if not EternityNum or not fireclickdetector then return end
                while Toggles["AutoReset"..key].Value do
                    local threshold = buildThreshold()
                    local projectedGain = ProjectedGain[key]
                    if projectedGain then
                        local ok, meetsThreshold = pcall(EternityNum.meeq, EternityNum.convert(projectedGain), threshold)
                        notyuri("[AutoReset:"..key.."] meeq=", ok and meetsThreshold or "ERROR")
                        if ok and meetsThreshold then
                            local now = tick()
                            local delay = Options[key.."ResetDelay"] and Options[key.."ResetDelay"].Value or 0
                            local last = LastReset[key] or 0
                            if (now - last) >= delay then
                                local model = workspace:FindFirstChild(key)
                                local click = model and model:FindFirstChild("Click")
                                local detector = click and click:FindFirstChildOfClass("ClickDetector")
                                if detector then
                                    notyuri("[AutoReset:"..key.."] FIRING (delay ok, elapsed="..(now - last).."s)")
                                    LastReset[key] = now
                                    FireCD(detector)
                                else
                                    notyuri("[AutoReset:"..key.."] ClickDetector not found in workspace."..key..".Click")
                                end
                            else
                                notyuri("[AutoReset:"..key.."] Skipped, delay not elapsed ("..(now - last).."s / "..delay.."s)")
                            end
                        end
                    else
                        notyuri("[AutoReset:"..key.."] No projected gain cached yet for key: "..key)
                    end
                    task.wait(0.5)
                end
            end, val)
        end,
    })
end
TB_Tabs.Autofarm.T3:AddDropdown("NotationMode", {
    Text    = "Threshold Notation",
    Values  = { "Suffix", "Scientific" },
    Default = "Suffix",
    Multi   = false,
})
if ResetLayerConfig then
    for key, config in pairs(ResetLayerConfig) do
        AddResetUI(key, config)
    end
else
    notyuri("[VUT] ResetLayerConfig module not found")
end
Options.NotationMode:OnChanged(function()
    for key, suffixDropdown in pairs(SuffixDropdowns) do
        suffixDropdown:SetVisible(Options.NotationMode.Value == "Suffix")
    end
end)
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
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state)
end)
local function Func_AutoClickBurner()
    while Toggles.AutoClickBurner.Value do
        local cd = workspace:FindFirstChild("Burner")
            and workspace.Burner:FindFirstChild("Button")
            and workspace.Burner.Button:FindFirstChildOfClass("ClickDetector")
        if cd then
            FireCD(cd)
        else
            notyuri("[AutoClickBurner] ClickDetector not found at workspace.Burner.Button")
        end
        task.wait()
    end
end
Toggles.AutoClickBurner:OnChanged(function(state)
    Thread("AutoClickBurner", SafeLoop("AutoClickBurner", Func_AutoClickBurner), state)
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
SaveManager:SetFolder("Yuri/VUT")
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