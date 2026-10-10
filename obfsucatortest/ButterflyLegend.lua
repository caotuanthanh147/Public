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
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Shared = {}
local Tables = {
    CaseList = {},
    CaseMap = {},
    BoostList = {},
    BoostMap = {},
    AuraList = {},
    AuraMap = {},
    TrailList = {},
    TrailMap = {},
    BNSuffixLab = {},
    BNSuffixExp = {},
}
local SharedFol = RS:WaitForChild("Shared", 5)
local Net = GetSafeModule(SharedFol, "Net")
local BigNum = GetSafeModule(SharedFol, "BigNum")
local Economy = GetSafeModule(SharedFol, "Economy")
local CaseDatabase = GetSafeModule(SharedFol, "CaseDatabase")
local AuraDatabase = GetSafeModule(SharedFol, "AuraDatabase")
local TrailDatabase = GetSafeModule(SharedFol, "TrailDatabase")
local GameConfig = GetSafeModule(SharedFol, "Config")
local Attributes = GameConfig and GameConfig.Attributes or {
    Power = "Power",
    Gems = "Gems",
    Rebirths = "Rebirths",
    Level = "Level",
    PowerMult = "PowerMult",
    AutoflipMult = "AutoflipMult",
    Autoflip = "AutoPunch",
}
local RemotesFolder = RS:WaitForChild("Remotes", 10)
local function GetRemote(name)
    if not RemotesFolder then return nil end
    return RemotesFolder:FindFirstChild(name) or RemotesFolder:WaitForChild(name, 5)
end
local function FireEvent(name, ...)
    local r = GetRemote(name)
    if not r then return end
    local args = {...}
    pcall(function()
        r:FireServer(unpack(args))
    end)
end
local function InvokeFn(name, ...)
    local r = GetRemote(name)
    if not r then return nil end
    local args = {...}
    local result = nil
    local ok, res = pcall(function()
        result = r:InvokeServer(unpack(args))
    end)
    if ok then return result end
    return nil
end
Remotes.Click = GetRemote("Click")
Remotes.CritClick = GetRemote("CritClick")
Remotes.ToggleAutoflip = GetRemote("ToggleAutoflip")
Remotes.BuyPowerMult = GetRemote("BuyPowerMult")
Remotes.BuyAutoflipMult = GetRemote("BuyAutoflipMult")
Remotes.BuyBoost = GetRemote("BuyBoost")
Remotes.RebirthSkip = GetRemote("RebirthSkip")
Remotes.BuyCase = GetRemote("BuyCase")
Remotes.Rebirth = GetRemote("Rebirth")
Remotes.OpenLuckyblock = GetRemote("OpenLuckyblock")
Remotes.Merge = GetRemote("Merge")
Remotes.EquipBest = GetRemote("EquipBest")
Remotes.SellStacks = GetRemote("SellStacks")
Remotes.GetKnifeCounts = GetRemote("GetKnifeCounts")
Remotes.EquipAura = GetRemote("EquipAura")
Remotes.EquipTrail = GetRemote("EquipTrail")
Remotes.RequestSpin = GetRemote("RequestSpin")
Remotes.TimeReward = GetRemote("TimeReward")
Remotes.Daily = GetRemote("Daily")
Modules.BigNum = BigNum
Modules.Economy = Economy
Modules.CaseDatabase = CaseDatabase
Modules.AuraDatabase = AuraDatabase
Modules.TrailDatabase = TrailDatabase
Modules.Config = GameConfig
Modules.Attributes = Attributes
local function GetPower()
    local p = Plr:GetAttribute(Attributes.Power) or 0
    if BigNum then return BigNum.new(p) end
    return tonumber(p) or 0
end
local function GetRebirths()
    return tonumber(Plr:GetAttribute(Attributes.Rebirths)) or 0
end
local function GetRebirthCost()
    local rebirths = GetRebirths()
    if Economy and Economy.RebirthCost then
        local ok, cost = pcall(Economy.RebirthCost, rebirths)
        if ok and cost then return cost end
    end
    if not BigNum or not GameConfig then return 0 end
    local cfg = GameConfig.Rebirth or {}
    local baseCost = cfg.BaseCost or 2500
    local growth = cfg.Growth or 1.04
    local curveExp = cfg.CurveExp or 7.8
    local v1 = math.max(1, rebirths + 1)
    local cost = BigNum.mul(BigNum.mul(baseCost, BigNum.pow(growth, v1 - 1)), ((v1 + 4) / 5) ^ curveExp)
    return BigNum.floor(cost)
end
local function CanRebirth()
    local power = GetPower()
    local cost = GetRebirthCost()
    if BigNum and BigNum.ge then
        local ok, res = pcall(BigNum.ge, power, cost)
        if ok then return res end
    end
    return false
end
do
    local function AddCase(id)
        local label = tostring(id)
        table.insert(Tables.CaseList, label)
        Tables.CaseMap[label] = id
    end
    if CaseDatabase and CaseDatabase.OrderedIds then
        for _, id in ipairs(CaseDatabase.OrderedIds) do
            AddCase(id)
        end
    end
    if #Tables.CaseList == 0 then
        local fallback = {
            "wooden", "iron", "crystal", "toxic", "shadow",
            "cosmic", "chaos", "singularity", "ethereal", "creator",
        }
        for _, id in ipairs(fallback) do AddCase(id) end
    end
end
do
    local function AddBoost(id, name)
        local label = tostring(name) .. " [" .. tostring(id) .. "]"
        table.insert(Tables.BoostList, label)
        Tables.BoostMap[label] = id
    end
    if GameConfig and GameConfig.Shop and GameConfig.Shop.Boosts then
        for id, def in pairs(GameConfig.Shop.Boosts) do
            local name = def.Kind or id
            if def.Seconds then name = name .. " (" .. (def.Seconds // 60) .. "m)" end
            AddBoost(id, name)
        end
    end
    if #Tables.BoostList == 0 then
        local fallback = {
            {"PowerX3_5m", "Power x3 (5m)"},
            {"PowerX3_30m", "Power x3 (30m)"},
            {"LuckX3_5m", "Luck x3 (5m)"},
        }
        for _, b in ipairs(fallback) do AddBoost(b[1], b[2]) end
    end
end
do
    local function AddAura(id, def)
        local name = def.DisplayName or def.name or id
        local label = tostring(name) .. " [" .. tostring(id) .. "]"
        table.insert(Tables.AuraList, label)
        Tables.AuraMap[label] = id
    end
    if AuraDatabase then
        local data = AuraDatabase.Defs or AuraDatabase.defs or AuraDatabase
        if type(data) == "table" then
            for id, def in pairs(data) do
                if type(def) == "table" then AddAura(id, def) end
            end
        end
    end
    if #Tables.AuraList == 0 then
        local fallback = {
            {"Light", "Light"},
            {"ColdWater", "Cold Water"},
            {"Toxic", "Toxic"},
            {"Fire", "Fire"},
            {"Lover", "Lover"},
            {"Shadow", "Shadow"},
            {"KnifeAngel", "Knife Angel"},
            {"AtomicButterfly", "Atomic Butterfly"},
        }
        for _, a in ipairs(fallback) do AddAura(a[1], {DisplayName = a[2]}) end
    end
end
do
    local function AddTrail(id, def)
        local name = def.DisplayName or id
        local label = tostring(name) .. " [" .. tostring(id) .. "]"
        table.insert(Tables.TrailList, label)
        Tables.TrailMap[label] = id
    end
    if TrailDatabase then
        local data = TrailDatabase.Defs or TrailDatabase.defs or TrailDatabase
        if type(data) == "table" then
            for id, def in pairs(data) do
                if type(def) == "table" then AddTrail(id, def) end
            end
        end
    end
    if #Tables.TrailList == 0 then
        local fallback = {
            {"Default", "Default"},
            {"Spark", "Spark"},
            {"Gold", "Gold"},
            {"Frost", "Frost"},
            {"Storm", "Storm"},
            {"Shadow", "Shadow"},
            {"Ghost", "Ghost"},
        }
        for _, t in ipairs(fallback) do AddTrail(t[1], {DisplayName = t[2]}) end
    end
end
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
            Autofarm2 = Tabs.Main:AddLeftTabbox(),
        },
        Right = {
            Autofarm = Tabs.Main:AddRightTabbox(),
            Autofarm2 = Tabs.Main:AddRightTabbox(),
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
local function Func_AutoClick()
    while true do
        FireEvent("Click")
        task.wait(0.05)
    end
end
local function Func_AutoCritClick()
    while true do
        local critUI = PGui:FindFirstChild("CritUI")
        if critUI and #critUI:GetChildren() > 0 then
            FireEvent("CritClick")
        end
        task.wait(0.1)
    end
end
local function Func_AutoToggleAutoflip()
    while true do
        if Plr:GetAttribute(Attributes.Autoflip) ~= true then
            FireEvent("ToggleAutoflip")
        end
        task.wait(1)
    end
end
local function Func_AutoBuyPowerMult()
    while true do
        FireEvent("BuyPowerMult")
        task.wait(0.5)
    end
end
local function Func_AutoBuyAutoflipMult()
    while true do
        FireEvent("BuyAutoflipMult")
        task.wait(0.5)
    end
end
local function Func_AutoRebirth()
    while true do
        if CanRebirth() then
            local result = InvokeFn("Rebirth")
        end
        task.wait(.5)
    end
end
local function Func_AutoRebirthSkip()
    while true do
        FireEvent("RebirthSkip")
        task.wait(0.5)
    end
end
local function Func_AutoBuyCase()
    while true do
        local label = Options.CaseSelect.Value
        local caseId = label and Tables.CaseMap[label]
        if caseId then
            InvokeFn("BuyCase", caseId)
        end
        task.wait(0.5)
    end
end
local function Func_AutoOpenLuckyblock()
    while true do
        InvokeFn("OpenLuckyblock")
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("ProximityPrompt") and desc.Parent and desc.Parent.Name:lower():find("luckyblock") then
                pcall(function()
                    if fireproximityprompt then fireproximityprompt(desc) end
                end)
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoCollectGemCrate()
    while true do
        local luckyblocks = workspace:FindFirstChild("Luckyblocks")
        if luckyblocks then
            for _, model in ipairs(luckyblocks:GetChildren()) do
                local mega = model:FindFirstChild("LuckyBlockMega")
                if mega then
                    local pp = mega:FindFirstChildWhichIsA("ProximityPrompt")
                    if pp then
                        FirePP(pp, true)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoEquip()
    while true do
        InvokeFn("EquipBest")
        task.wait(2)
    end
end
local function Func_AutoSellStacks()
    while true do
        local counts = InvokeFn("GetKnifeCounts")
        if type(counts) == "table" then
            local sellList = {}
            for stackKey, info in pairs(counts) do
                if type(info) == "table" and info.name and info.mutation then
                    table.insert(sellList, { Name = info.name, Mutation = info.mutation })
                end
            end
            if #sellList > 0 then
                InvokeFn("SellStacks", sellList)
            end
        end
        task.wait(5)
    end
end
local function Func_AutoSpin()
    while true do
        InvokeFn("RequestSpin")
        task.wait(2)
    end
end
local function Func_AutoBuyBoost()
    while true do
        local label = Options.BoostSelect.Value
        local boostId = label and Tables.BoostMap[label]
        if boostId then
            FireEvent("BuyBoost", boostId)
        end
        task.wait(60)
    end
end
local function Func_AutoEquipBestAura()
    while true do
        local data = InvokeFn("FetchData")
        if data and data.Cosmetics then
            local owned = data.Cosmetics.OwnedAuras or {}
            local equipped = data.Cosmetics.EquippedAura or ""
            local best, bestPrice = nil, -1
            if AuraDatabase then
                local defs = AuraDatabase.Defs or AuraDatabase.defs or AuraDatabase
                for id, def in pairs(defs) do
                    if type(def) == "table" and table.find(owned, id) then
                        local price = def.Price or 0
                        if price > bestPrice then
                            bestPrice = price
                            best = id
                        end
                    end
                end
            end
            if best and best ~= equipped then
                InvokeFn("EquipAura", best)
            end
        end
        task.wait(5)
    end
end
local function Func_AutoEquipBestTrail()
    while true do
        local data = InvokeFn("FetchData")
        if data and data.Cosmetics then
            local owned = data.Cosmetics.OwnedTrails or {}
            local equipped = data.Cosmetics.EquippedTrail or ""
            local best, bestPrice = nil, -1
            if TrailDatabase then
                local defs = TrailDatabase.Defs or TrailDatabase.defs or TrailDatabase
                for id, def in pairs(defs) do
                    if type(def) == "table" and table.find(owned, id) then
                        local price = def.Price or 0
                        if price > bestPrice then
                            bestPrice = price
                            best = id
                        end
                    end
                end
            end
            if best and best ~= equipped then
                InvokeFn("EquipTrail", best)
            end
        end
        task.wait(5)
    end
end
local MultZoneList = {}
local MultZoneMap = {}
local CollectionService = game:GetService("CollectionService")
local function BuildMultZones()
    MultZoneList = {}
    MultZoneMap = {}
    for _, part in ipairs(CollectionService:GetTagged("MultiplierZone")) do
        if part:IsA("BasePart") and part.Parent then
            local mult = part:GetAttribute("Multiplier") or 1
            local label = part.Name .. " (x" .. tostring(mult) .. ")"
            if not MultZoneMap[label] then
                table.insert(MultZoneList, label)
                MultZoneMap[label] = part
            end
        end
    end
    table.sort(MultZoneList, function(a, b)
        local ma = MultZoneMap[a] and (MultZoneMap[a]:GetAttribute("Multiplier") or 1) or 1
        local mb = MultZoneMap[b] and (MultZoneMap[b]:GetAttribute("Multiplier") or 1) or 1
        return ma > mb
    end)
    if #MultZoneList == 0 then
        table.insert(MultZoneList, "None")
    end
end
BuildMultZones()
CollectionService:GetInstanceAddedSignal("MultiplierZone"):Connect(function(part)
    if part:IsA("BasePart") then
        local mult = part:GetAttribute("Multiplier") or 1
        local label = part.Name .. " (x" .. tostring(mult) .. ")"
        if not MultZoneMap[label] then
            table.insert(MultZoneList, label)
            MultZoneMap[label] = part
            table.sort(MultZoneList, function(a, b)
                local ma = MultZoneMap[a] and (MultZoneMap[a]:GetAttribute("Multiplier") or 1) or 1
                local mb = MultZoneMap[b] and (MultZoneMap[b]:GetAttribute("Multiplier") or 1) or 1
                return ma > mb
            end)
            Options.MultZoneSelect:SetValues(MultZoneList, MultZoneList[1] or "")
        end
    end
end)
CollectionService:GetInstanceRemovedSignal("MultiplierZone"):Connect(function(part)
    for label, p in pairs(MultZoneMap) do
        if p == part then
            MultZoneMap[label] = nil
            local idx = table.find(MultZoneList, label)
            if idx then table.remove(MultZoneList, idx) end
            break
        end
    end
    if #MultZoneList == 0 then table.insert(MultZoneList, "None") end
    Options.MultZoneSelect:SetValues(MultZoneList, MultZoneList[1] or "")
end)
local function Func_AutoTpZone()
    local label = Options.MultZoneSelect.Value
    local part = label and MultZoneMap[label]
    if part and part.Parent then
        local barrier = part.Parent:FindFirstChild("Barrier", true)
        if barrier then barrier:Destroy() end
    end
    while true do
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local lbl = Options.MultZoneSelect.Value
        local p = lbl and MultZoneMap[lbl]
        if p and p.Parent and hrp then
            local dist = (hrp.Position - p.Position).Magnitude
            if dist > 8 then
                hrp.CFrame = CFrame.new(p.Position)
            end
        end
        task.wait(1)
    end
end
local LocationTargets = {
    ["Level 1"] = function() return workspace:FindFirstChild("Level 1") and workspace["Level 1"]:FindFirstChild("SafeZone") end,
    ["Level 2"] = function() return workspace:FindFirstChild("Level 2") and workspace["Level 2"]:FindFirstChild("SafeZone") end,
    ["Level 3"] = function() return workspace:FindFirstChild("Level 3") and workspace["Level 3"]:FindFirstChild("SafeZone") end,
    ["Level 4"] = function() return workspace:FindFirstChild("Level 4") and workspace["Level 4"]:FindFirstChild("SafeZone") end,
}
local LocationList = { "Level 1", "Level 2", "Level 3", "Level 4" }
local function Func_AutoTpLocation()
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local lvl = Options.LocationSelect.Value
    local getTarget = lvl and LocationTargets[lvl]
    if not getTarget then return end
    local zone = getTarget()
    local part = zone and zone:FindFirstChildWhichIsA("BasePart", true)
    if part then
        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoClick", { Text = "Auto Click", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCritClick", { Text = "Auto Crit Click", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoOpenLuckyblock", { Text = "Auto Open Luckyblocks", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectGemCrate", { Text = "Auto Collect Gem Crate", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyCase", { Text = "Auto Buy Case", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquipBestAura", { Text = "Auto Equip Best Aura", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquipBestTrail", { Text = "Auto Equip Best Trail", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTpZone", { Text = "Auto Zone TP", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("CaseSelect", { Text = "Select Case", Values = Tables.CaseList, Default = Tables.CaseList[1] or "" })
TB_Tabs.Autofarm2.T1:AddDropdown("MultZoneSelect", { Text = "Multi Zone", Values = MultZoneList, Default = MultZoneList[1] or "" })
TB_Tabs.Autofarm2.T1:AddDropdown("LocationSelect", { Text = "Teleport Location", Values = LocationList, Default = LocationList[1] })
TB_Tabs.Autofarm2.T1:AddButton({ Text = "Teleport to Location", Func = Func_AutoTpLocation })
Toggles.AutoClick:OnChanged(function(state)
    Thread("AutoClick", Func_AutoClick, state)
end)
Toggles.AutoCritClick:OnChanged(function(state)
    Thread("AutoCritClick", Func_AutoCritClick, state)
end)
Toggles.AutoOpenLuckyblock:OnChanged(function(state)
    Thread("AutoOpenLuckyblock", Func_AutoOpenLuckyblock, state)
end)
Toggles.AutoCollectGemCrate:OnChanged(function(state)
    Thread("AutoCollectGemCrate", Func_AutoCollectGemCrate, state)
end)
Toggles.AutoBuyCase:OnChanged(function(state)
    Thread("AutoBuyCase", Func_AutoBuyCase, state)
end)
Toggles.AutoEquip:OnChanged(function(state)
    Thread("AutoEquip", Func_AutoEquip, state)
end)
Toggles.AutoEquipBestAura:OnChanged(function(state)
    Thread("AutoEquipBestAura", Func_AutoEquipBestAura, state)
end)
Toggles.AutoEquipBestTrail:OnChanged(function(state)
    Thread("AutoEquipBestTrail", Func_AutoEquipBestTrail, state)
end)
Toggles.AutoRebirth:OnChanged(function(state)
    Thread("AutoRebirth", Func_AutoRebirth, state)
end)
Toggles.AutoTpZone:OnChanged(function(state)
    Thread("AutoTpZone", Func_AutoTpZone, state)
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
SaveManager:SetFolder("Yuri/ButterflyLegends")
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