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
local Remotes = {
}
local Modules = {
}
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
local ReplicaController
local PlayerReplica
local function GetPlayerReplica()
    if PlayerReplica then return PlayerReplica end
    pcall(function()
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "ReplicaOfClassCreated") and rawget(v, "RequestData") then
                ReplicaController = v
                break
            end
        end
    end)
    if not ReplicaController then return nil end
    local ok, replicas = pcall(function() return ReplicaController._replicas end)
    if not ok or type(replicas) ~= "table" then return nil end
    for _, replica in pairs(replicas) do
        if replica.Class == "PlayerProfile" then
            PlayerReplica = replica
            return replica
        end
    end
    return nil
end
local function ReplicaFire(action, ...)
    local r = GetPlayerReplica()
    if not r then return false end
    local args = {...}
    return pcall(function() r:FireServer(action, unpack(args)) end)
end
local function GetReplicaData()
    local r = GetPlayerReplica()
    if not r or not r.Data then return nil end
    return r.Data
end
local function GetZenith()
    local data = GetReplicaData()
    if not data then return nil end
    return data.Zenith
end
local function GetUpgrades()
    local data = GetReplicaData()
    if not data then return {} end
    return data.Upgrades or {}
end
local function GetRebirths()
    local data = GetReplicaData()
    if not data then return 0 end
    return tonumber(data.Rebirths) or 0
end
local function OnoeNumToNumber(onoe)
    if type(onoe) ~= "table" then return tonumber(onoe) or 0 end
    local mantissa = onoe.mantissa or onoe[1] or 0
    local exponent = onoe.exponent or onoe[2] or 0
    if exponent > 300 then return math.huge end
    return tonumber(tostring(mantissa)) * (10 ^ tonumber(exponent))
end
local function CanAffordUpgrade(upgradeId)
    local upgrades = GetUpgrades()
    local level = tonumber(upgrades[upgradeId]) or 0
    if not ZenithConfig then return true end
    local def = ZenithConfig.Upgrades[upgradeId]
    if not def then return true end
    local maxLevel = def.BaseMaxLevel or 100
    if level >= maxLevel then return false end
    return true
end
local SharedFolder = RS:FindFirstChild("Shared") or RS:WaitForChild("Shared", 15)
local ZenithConfig = GetSafeModule(SharedFolder, "ZenithConfig")
local PrestigeConfig = GetSafeModule(SharedFolder, "PrestigeConfig")
local PinnacleTreeConfig = GetSafeModule(SharedFolder, "PinnacleTreeConfig")
local RuneAscensionConfig = GetSafeModule(SharedFolder, "RuneAscensionConfig")
local PinnacleBoardConfig = GetSafeModule(SharedFolder, "PinnacleBoardConfig")
local OnoeNum = (function()
    local ok, result = pcall(function()
        return require(RS.Modules.SerikaNum).OnoeNum
    end)
    return ok and result or nil
end)()
local function BuildUpgradeList()
    local list = {}
    if ZenithConfig and ZenithConfig.Upgrades then
        for id in pairs(ZenithConfig.Upgrades) do
            table.insert(list, id)
        end
        table.sort(list)
    end
    if #list == 0 then list = { "ground_upg1" } end
    return list
end
local function BuildPinnacleNodeList()
    local list = {}
    if PinnacleTreeConfig and PinnacleTreeConfig.Nodes then
        for _, node in ipairs(PinnacleTreeConfig.Nodes) do
            if node.Id then table.insert(list, node.Id) end
        end
    end
    if #list == 0 then list = { "Pinnacle_upg1" } end
    return list
end
local function BuildBoardNodeList()
    local list = {}
    if PinnacleBoardConfig and PinnacleBoardConfig.Nodes then
        for _, node in ipairs(PinnacleBoardConfig.Nodes) do
            if node.Id and not node.IsTab then table.insert(list, node.Id) end
        end
    end
    if #list == 0 then list = { "board_upg1" } end
    return list
end
local UpgradeList = BuildUpgradeList()
local PinnacleNodeList = BuildPinnacleNodeList()
local BoardNodeList = BuildBoardNodeList()
local function GetNearestPlate()
    local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local groundUpg = workspace:FindFirstChild("Ground_Upg")
    if not groundUpg then return nil end
    local best, bestDist = nil, math.huge
    for _, plate in ipairs(groundUpg:GetChildren()) do
        if plate:IsA("BasePart") then
            local dist = (plate.Position - hrp.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                best = plate
            end
        end
    end
    return best
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value and Options.UpgradeSelected and Options.UpgradeSelected.Value["Zenith Upgrade"] do
        for _, id in ipairs(UpgradeList) do
            if not Toggles.AutoUpgrade.Value then break end
            if CanAffordUpgrade(id) then
                ReplicaFire("RequestUpgrade", id, "max")
            end
            task.wait(0.05)
        end
        task.wait()
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        local threshold = tonumber(Options.RebirthThreshold and Options.RebirthThreshold.Value) or 1
        local zenith = GetZenith()
        if zenith and PrestigeConfig and PrestigeConfig.Rebirth and OnoeNum then
            local zenithOnoe = type(zenith) == "table" and zenith or OnoeNum.fromString(tostring(zenith))
            local rebirthGain = PrestigeConfig.Rebirth.GetBulkAmount(zenithOnoe)
            local gainNum = OnoeNumToNumber(rebirthGain)
            if gainNum >= threshold then
                ReplicaFire("RequestPrestige", "Rebirth")
            end
        end
        task.wait(1)
    end
end
local function Func_AutoAwaken()
    while Toggles.AutoAwaken.Value do
        local data = GetReplicaData()
        local canAscend = RuneAscensionConfig and data and RuneAscensionConfig.CanAscend(data.RuneInventory or {})
        if canAscend then
            ReplicaFire("RequestAscension")
        end
        task.wait(1)
    end
end
local function Func_AutoAscension()
    while Toggles.AutoAscension.Value do
        local threshold = tonumber(Options.AscensionThreshold and Options.AscensionThreshold.Value) or 1
        local data = GetReplicaData()
        if data and RuneAscensionConfig then
            local bestRune = RuneAscensionConfig.GetBestOwnedRune(data.RuneInventory or {})
            local canAscend = RuneAscensionConfig.CanAscend(data.RuneInventory or {})
            local gain = RuneAscensionConfig.GetEssenceGain(bestRune, data.AscensionUpgrades and data.AscensionUpgrades.RuneEssence)
            notyuri("[AutoAscension] threshold =", threshold, "| gain =", gain, "| canAscend =", canAscend, "| bestRune =", bestRune and bestRune.Index or "nil")
            if canAscend then
                if gain >= threshold then
                    notyuri("[AutoAscension] Firing RequestAscension")
                    ReplicaFire("RequestAscension")
                else
                    notyuri("[AutoAscension] Blocked — gain below threshold")
                end
            end
        else
            notyuri("[AutoAscension] Missing data or RuneAscensionConfig")
        end
        task.wait(1)
    end
end
local function Func_AutoAscensionUpgrade()
    while Toggles.AutoUpgrade.Value and Options.UpgradeSelected and Options.UpgradeSelected.Value["Ascension Upgrade"] do
        local data = GetReplicaData()
        local essence = data and (tonumber(data.RuneEssence) or 0) or 0
        local upgrades = data and (data.AscensionUpgrades or {}) or {}
        for _, id in ipairs({ "RuneBulk", "RuneLuck", "RuneEssence" }) do
            if not Toggles.AutoUpgrade.Value then break end
            if RuneAscensionConfig then
                local level = upgrades[id] or 0
                local maxLevel = RuneAscensionConfig.Upgrades[id] and RuneAscensionConfig.Upgrades[id].MaxLevel or math.huge
                if level < maxLevel then
                    local cost = RuneAscensionConfig.GetUpgradeCost(id, level)
                    if essence >= cost then
                        ReplicaFire("RequestAscensionUpgrade", id)
                        task.wait(0.1)
                    end
                end
            else
                ReplicaFire("RequestAscensionUpgrade", id)
                task.wait(0.1)
            end
        end
        task.wait(.5)
    end
end
local function Func_AutoPinnacleTreeUpgrade()
    while Toggles.AutoUpgrade.Value and Options.UpgradeSelected and Options.UpgradeSelected.Value["Pinnacle Tree"] do
        local data = GetReplicaData()
        local treeData = data and (data.PinnacleTree or {}) or {}
        local points = OnoeNum and OnoeNum.fromString(data and data.PinnaclePoints or "0") or nil
        for _, id in ipairs(PinnacleNodeList) do
            if not Toggles.AutoUpgrade.Value then break end
            if not treeData[id] then
                local nodeDef = PinnacleTreeConfig and PinnacleTreeConfig.ById and PinnacleTreeConfig.ById[id]
                local meetsReqs = not PinnacleTreeConfig or not PinnacleTreeConfig.MeetsRequirements or PinnacleTreeConfig.MeetsRequirements(id, treeData)
                local canAfford = true
                if nodeDef and nodeDef.Cost and points then
                    canAfford = points:moreEquals(nodeDef.Cost)
                end
                if meetsReqs and canAfford then
                    ReplicaFire("RequestTreeUpgrade", id)
                    task.wait(0.1)
                end
            end
        end
        task.wait(.5)
    end
end
local function Func_AutoPinnacleBoardUpgrade()
    while Toggles.AutoUpgrade.Value and Options.UpgradeSelected and Options.UpgradeSelected.Value["Pinnacle Board"] do
        local data = GetReplicaData()
        local boardData = data and (data.PinnacleBoard or {}) or {}
        local currencies = OnoeNum and {
            PinnaclePoints = OnoeNum.fromString(data and data.PinnaclePoints or "0"),
            PinnacleRolls  = OnoeNum.new(data and data.PinnacleRolls or 0),
            Rebirths       = OnoeNum.fromString(tostring(data and data.Rebirths or "0")),
            Awakenings     = OnoeNum.fromString(tostring(data and data.Awakenings or "0")),
            Gold           = OnoeNum.fromString(data and data.Gold or "0"),
            FishCaught     = OnoeNum.new(data and data.FishCaught or 0),
            RuneRolls      = OnoeNum.new(data and data.RuneRolls or 0),
        } or nil
        for _, id in ipairs(BoardNodeList) do
            if not Toggles.AutoUpgrade.Value then break end
            if not boardData[id] then
                local nodeDef = PinnacleBoardConfig and PinnacleBoardConfig.ById and PinnacleBoardConfig.ById[id]
                if nodeDef and nodeDef.EffectType == "MoveSpeed" then
                    notyuri("[BoardUpgrade] Skipping MoveSpeed node:", id)
                    continue
                end
                local meetsReqs = not PinnacleBoardConfig or (
                    PinnacleBoardConfig.MeetsRequirements and PinnacleBoardConfig.MeetsRequirements(id, boardData)
                )
                local canAfford = true
                local currencyKey = "PinnaclePoints"
                if nodeDef and nodeDef.Cost and currencies then
                    currencyKey = nodeDef.Currency or "PinnaclePoints"
                    local currency = currencies[currencyKey] or OnoeNum.new(0)
                    canAfford = currency:moreEquals(nodeDef.Cost)
                end
                notyuri("[BoardUpgrade]", id, "| currency:", currencyKey, "| meetsReqs:", meetsReqs, "| canAfford:", canAfford)
                if meetsReqs and canAfford then
                    notyuri("[BoardUpgrade] Firing RequestBoardUpgrade:", id)
                    ReplicaFire("RequestBoardUpgrade", id)
                    task.wait(0.1)
                end
            end
        end
        task.wait(.5)
    end
end
local function Func_AutoTPBoost()
    while Toggles.AutoTPBoost.Value do
        local choice = Options.BoostPlateTarget and Options.BoostPlateTarget.Value
        if choice and choice ~= "None" then
            local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            local boostFolder = workspace:FindFirstChild("Boost_Plate")
            local plate = boostFolder and boostFolder:FindFirstChild(choice)
            if hrp and plate then
                local target = Vector3.new(plate.Position.X, plate.Position.Y + plate.Size.Y / 2 + 3, plate.Position.Z)
                if (hrp.Position - target).Magnitude > 20 then
                    hrp.CFrame = CFrame.new(target)
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoGoldenStair()
    while Toggles.AutoGoldenStair.Value do
        ReplicaFire("CollectGoldenStair")
        task.wait(5)
    end
end
local function Func_AutoUnlockRuneWall()
    while Toggles.AutoUnlockRuneWall.Value do
        for _, wallName in ipairs({ "RuneWall1", "RuneWall2", "RuneWall3", "RuneWall4" }) do
            if not Toggles.AutoUnlockRuneWall.Value then break end
            ReplicaFire("UnlockRuneWall", wallName)
            task.wait(0.5)
        end
        task.wait(10)
    end
end
local function Func_AutoTeleportNext()
    while Toggles.AutoTeleportNext.Value do
        local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
        local groundUpg = workspace:FindFirstChild("Ground_Upg")
        if hrp and groundUpg then
            local plates = groundUpg:GetChildren()
            local best, bestDist = nil, math.huge
            for _, plate in ipairs(plates) do
                if plate:IsA("BasePart") and ZenithConfig and ZenithConfig.Upgrades[plate.Name] then
                    local dist = (plate.Position - hrp.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = plate
                    end
                end
            end
            if best then
                hrp.CFrame = CFrame.new(best.Position.X, best.Position.Y + best.Size.Y / 2 + 3, best.Position.Z)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoFish()
    while Toggles.AutoFish.Value do
        ReplicaFire("CastLine")
        task.wait(2)
        ReplicaFire("ReelIn")
        task.wait(1)
    end
end
local function Func_AutoOpenCrate()
    while Toggles.AutoOpenCrate.Value do
        ReplicaFire("OpenAllCrates")
        task.wait(5)
    end
end
local function Func_AutoSacrificeFish()
    while Toggles.AutoSacrificeFish.Value do
        ReplicaFire("SacrificeFish", {})
        task.wait(10)
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
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeSelected", {
    Text = "Upgrade List",
    Values = { "Zenith Upgrade", "Ascension Upgrade", "Pinnacle Tree", "Pinnacle Board" },
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("RebirthThreshold", { Text = "Rebirth Threshold", Default = "1", })
TB_Tabs.Autofarm.T1:AddToggle("AutoAwaken", { Text = "Auto Awaken", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAscension", { Text = "Auto Ascension", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("AscensionThreshold", { Text = "Ascension Threshold", Default = "1", })
TB_Tabs.Autofarm.T1:AddToggle("AutoGoldenStair", { Text = "Auto Golden Stair", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTPBoost", { Text = "Auto TP Boost", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("BoostPlateTarget", { Text = "Boost Plate Target", Values = { "None", "Boost_Plate1", "Boost_Plate2", "Boost_Plate3", "Boost_Plate4" }, Default = "Boost_Plate1" })
TB_Tabs.Autofarm.T1:AddToggle("AutoFish", { Text = "Auto Fish", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoOpenCrate", { Text = "Auto Open Crates", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSacrificeFish", { Text = "Auto Sacrifice Fish", Default = false })
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
local function RestartUpgradeThreads(v)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
    Thread("AutoAscensionUpgrade", SafeLoop("AutoAscensionUpgrade", Func_AutoAscensionUpgrade), v)
    Thread("AutoPinnacleTreeUpgrade", SafeLoop("AutoPinnacleTreeUpgrade", Func_AutoPinnacleTreeUpgrade), v)
    Thread("AutoPinnacleBoardUpgrade", SafeLoop("AutoPinnacleBoardUpgrade", Func_AutoPinnacleBoardUpgrade), v)
end
Toggles.AutoUpgrade:OnChanged(function(v) RestartUpgradeThreads(v) end)
Toggles.AutoAscension:OnChanged(function(v) Thread("AutoAscension", SafeLoop("AutoAscension", Func_AutoAscension), v) end)
Options.UpgradeSelected:OnChanged(function()
    if Toggles.AutoUpgrade.Value then
        RestartUpgradeThreads(false)
        RestartUpgradeThreads(true)
    end
end)
Toggles.AutoRebirth:OnChanged(function(v) Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v) end)
Toggles.AutoAwaken:OnChanged(function(v) Thread("AutoAwaken", SafeLoop("AutoAwaken", Func_AutoAwaken), v) end)
Toggles.AutoGoldenStair:OnChanged(function(v) Thread("AutoGoldenStair", SafeLoop("AutoGoldenStair", Func_AutoGoldenStair), v) end)
Toggles.AutoTPBoost:OnChanged(function(v) Thread("AutoTPBoost", SafeLoop("AutoTPBoost", Func_AutoTPBoost), v) end)
Toggles.AutoFish:OnChanged(function(v) Thread("AutoFish", SafeLoop("AutoFish", Func_AutoFish), v) end)
Toggles.AutoOpenCrate:OnChanged(function(v) Thread("AutoOpenCrate", SafeLoop("AutoOpenCrate", Func_AutoOpenCrate), v) end)
Toggles.AutoSacrificeFish:OnChanged(function(v) Thread("AutoSacrificeFish", SafeLoop("AutoSacrificeFish", Func_AutoSacrificeFish), v) end)
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
SaveManager:SetFolder("Yuri/ZenithInc")
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