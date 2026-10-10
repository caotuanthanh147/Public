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
local function notyuri()
end
local repo = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
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
local SPH_Assets = RS:FindFirstChild("SPH_Assets")
local BridgeNet
if SPH_Assets then
    BridgeNet = GetSafeModule(SPH_Assets.Modules, "BridgeNet")
else
    BridgeNet = GetSafeModule(RS, "BridgeNet")
end
local Remotes = {
    BulletHit = BridgeNet and BridgeNet.CreateBridge("BulletHit"),
    DefenseState = RS:FindFirstChild("DefenseState"),
    DefenseAction = RS:FindFirstChild("DefenseAction"),
    EquipTool = RS:FindFirstChild("EquipTool"),
    CreateLobby = RS:FindFirstChild("CreateLobby"),
    StartMission = RS:FindFirstChild("StartMission"),
}
local Modules = {
    WeaponWeights = GetSafeModule(RS, "WeaponWeights"),
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
local function AddMultiDropdown(group, id, config)
    config = config or {}
    local labelId = config.label
    group:AddDropdown(id, {
        Text = config.Text,
        Values = config.Values,
        Default = config.Default or {},
        Multi = true,
        Searchable = config.Searchable,
        Callback = config.Callback,
    })
    return function()
        local labels = (Options[id] and Options[id].Value) or {}
        local ids = {}
        for label, active in pairs(labels) do
            if active then
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
        notyuri("Your executor does not support firesignal or getconnections.")
    end
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
local function GetEquippedGun()
    local char = GetCharacter()
    if not char then return nil end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool and tool:FindFirstChild("SPH_Weapon") then
        return tool
    end
    return nil
end
local function FireBulletHit(target)
    if not Remotes.BulletHit then
        return
    end
    local Tool = GetEquippedGun()
    if not Tool then
        return
    end
    local char = GetCharacter()
    if not char then return end
    local hrp = char.HumanoidRootPart
    notyuri("[KillAura] Firing BulletHit at", target:GetFullName(), "Tool:", Tool.Name)
    Remotes.BulletHit:Fire(Tool, {
        Position = target.Position,
        Normal = Vector3.new(0, 1, 0),
        Instance = target,
    }, hrp.CFrame)
end
local function FindHumanoidWeakpoint(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    if hum then
        return hum, model
    end
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("Humanoid") then
            return desc, desc.Parent
        end
    end
    return nil, nil
end
local function FindAllHumanoidWeakpoints(model)
    local results = {}
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("Humanoid") then
            table.insert(results, { hum = desc, hitboxModel = desc.Parent })
        end
    end
    return results
end
local function GetHitPart(hitboxModel)
    return hitboxModel:FindFirstChild("Head")
        or hitboxModel:FindFirstChild("HumanoidRootPart")
        or hitboxModel:FindFirstChild("TankHitbox")
        or hitboxModel:FindFirstChild("BasePart")
        or hitboxModel.PrimaryPart
        or hitboxModel:FindFirstChildWhichIsA("BasePart", true)
end
local function IsPartInKillRange(part)
    local rangeStr = (Options.KillAuraRange and Options.KillAuraRange.Value) or "100"
    local range = tonumber(rangeStr)
    if not range or range <= 0 then return true end
    local char = GetCharacter()
    local hrp = char and char.HumanoidRootPart
    if not hrp then return false end
    return (hrp.Position - part.Position).Magnitude <= range
end
local function GetHostileNPCs()
    local list = {}
    local containers = {}
    local DefenseEnemies = workspace:FindFirstChild("DefenseEnemies")
    if DefenseEnemies then
        table.insert(containers, DefenseEnemies)
    end
    local NPCs = workspace:FindFirstChild("NPCs")
    if NPCs then
        table.insert(containers, NPCs)
    end
    local GeneratedTrench = workspace:FindFirstChild("GeneratedTrench")
    if GeneratedTrench then
        table.insert(containers, GeneratedTrench)
        for _, desc in ipairs(GeneratedTrench:GetDescendants()) do
            if desc:IsA("Folder") and desc.Name == "Enemies" then
                table.insert(containers, desc)
            end
        end
    end
    if #containers == 0 then return list end
    local myChar = Plr.Character
    for _, container in ipairs(containers) do
        for _, model in ipairs(container:GetChildren()) do
            if model:IsA("Model") and model ~= myChar and not Players:GetPlayerFromCharacter(model) then
                if model.Name == "Big Betsy" then
                    for _, weakpoint in ipairs(FindAllHumanoidWeakpoints(model)) do
                        if weakpoint.hum.Health > 0 then
                            local part = GetHitPart(weakpoint.hitboxModel)
                            if part and IsPartInKillRange(part) then
                                table.insert(list, { npc = model, hum = weakpoint.hum, part = part })
                            end
                        end
                    end
                else
                    local hum, hitboxModel = FindHumanoidWeakpoint(model)
                    if hum and hitboxModel and hum.Health > 0 then
                        local part = GetHitPart(hitboxModel)
                        if part and IsPartInKillRange(part) then
                            table.insert(list, { npc = model, hum = hum, part = part })
                        end
                    end
                end
            end
        end
    end
    return list
end
local ESPFolder = Instance.new("Folder")
ESPFolder.Parent = Services.CoreGui
local AllHighlights = {
    Enemy = {},
    Interactable = {},
}
local function GetAdornee(target)
    if target:IsA("BasePart") then
        return target
    elseif target:IsA("Model") then
        return target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end
local function MakeLbl(text, sizeY, posY, bold, textColor)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, sizeY, 0)
    lbl.Position = UDim2.new(0, 0, posY, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = textColor or Color3.new(1, 1, 1)
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.TextStrokeTransparency = 0.4
    lbl.TextScaled = true
    lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    return lbl
end
local ESPPool = {
    Free = {},
    Active = {},
}
local function ESPAcq(fillColor, outlineColor, labelName, textColor)
    local entry = table.remove(ESPPool.Free)
    if not entry then
        local h = Instance.new("Highlight")
        h.FillTransparency = 0.4
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 70, 0, 20)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.ResetOnSpawn = false
        local nameLbl = MakeLbl("", 0.55, 0, true, Color3.new(1, 1, 1))
        nameLbl.Parent = bb
        local distLbl = MakeLbl("", 0.45, 0.55, false, Color3.new(1, 1, 1))
        distLbl.Parent = bb
        entry = { highlight = h, billboard = bb, nameLbl = nameLbl, distLbl = distLbl }
    end
    entry.highlight.FillColor = fillColor
    entry.highlight.OutlineColor = outlineColor
    entry.highlight.Parent = ESPFolder
    entry.nameLbl.Text = labelName
    entry.nameLbl.TextColor3 = textColor or Color3.new(1, 1, 1)
    entry.distLbl.TextColor3 = textColor or Color3.new(1, 1, 1)
    entry.billboard.Parent = ESPFolder
    ESPPool.Active[entry] = true
    return entry
end
local function ESPRelease(entry)
    if not entry or not ESPPool.Active[entry] then return end
    ESPPool.Active[entry] = nil
    entry.highlight.Adornee = nil
    entry.highlight.Parent = nil
    entry.billboard.Adornee = nil
    entry.billboard.Parent = nil
    table.insert(ESPPool.Free, entry)
end
local function Hightlight(target, fillColor, outlineColor, labelName, textColor)
    local part = GetAdornee(target)
    if not part then return nil end
    local entry = ESPAcq(fillColor, outlineColor, labelName, textColor)
    entry.highlight.Adornee = target
    entry.billboard.Adornee = part
    entry.part = part
    return entry
end
local function removeHighlight(tbl, key)
    if tbl[key] then
        ESPRelease(tbl[key])
        tbl[key] = nil
    end
end
local function GetESPEnemies()
    local list = {}
    local containers = {}
    local DefenseEnemies = workspace:FindFirstChild("DefenseEnemies")
    if DefenseEnemies then table.insert(containers, DefenseEnemies) end
    local NPCs = workspace:FindFirstChild("NPCs")
    if NPCs then table.insert(containers, NPCs) end
    local GeneratedTrench = workspace:FindFirstChild("GeneratedTrench")
    if GeneratedTrench then
        table.insert(containers, GeneratedTrench)
        for _, desc in ipairs(GeneratedTrench:GetDescendants()) do
            if desc:IsA("Folder") and desc.Name == "Enemies" then
                table.insert(containers, desc)
            end
        end
    end
    local myChar = Plr.Character
    for _, container in ipairs(containers) do
        for _, model in ipairs(container:GetChildren()) do
            if model:IsA("Model") and model ~= myChar and not Players:GetPlayerFromCharacter(model) then
                if model.Name == "Big Betsy" then
                    for _, weakpoint in ipairs(FindAllHumanoidWeakpoints(model)) do
                        if weakpoint.hum.Health > 0 then
                            local part = GetHitPart(weakpoint.hitboxModel)
                            if part then list[part] = model.Name end
                        end
                    end
                else
                    local hum, hitboxModel = FindHumanoidWeakpoint(model)
                    if hum and hitboxModel and hum.Health > 0 then
                        local part = GetHitPart(hitboxModel)
                        if part then list[part] = model.Name end
                    end
                end
            end
        end
    end
    return list
end
local function GetESPInteractables()
    local list = {}
    local containers = {}
    local GeneratedTrench = workspace:FindFirstChild("GeneratedTrench")
    if GeneratedTrench then table.insert(containers, GeneratedTrench) end
    local DefenseEnemies = workspace:FindFirstChild("DefenseEnemies")
    if DefenseEnemies then table.insert(containers, DefenseEnemies) end
    local NPCs = workspace:FindFirstChild("NPCs")
    if NPCs then table.insert(containers, NPCs) end
    for _, container in ipairs(containers) do
        for _, prompt in ipairs(container:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local part = prompt.Parent
                if part and not part:IsA("BasePart") then
                    part = prompt:FindFirstAncestorWhichIsA("BasePart")
                end
                if part then
                    local label = prompt.ObjectText ~= "" and prompt.ObjectText or (part.Parent and part.Parent.Name or part.Name)
                    list[part] = label
                end
            end
        end
    end
    return list
end
local function RefreshESPGroup(cfg)
    local tbl = AllHighlights[cfg.Id]
    if not Toggles[cfg.Id].Value then
        for k in pairs(tbl) do removeHighlight(tbl, k) end
        return
    end
    local fillColor = Options[cfg.Id .. "Color"].Value
    local outlineColor = Options[cfg.Id .. "Outline"].Value
    local current = cfg.Get()
    for part in pairs(tbl) do
        if not current[part] or not part.Parent then
            removeHighlight(tbl, part)
        end
    end
    for part, label in pairs(current) do
        if not tbl[part] then
            tbl[part] = Hightlight(part, fillColor, outlineColor, label, fillColor)
        end
    end
end
local ESPTargetConfig = {
    { Id = "Enemy", Get = GetESPEnemies, Color = Color3.fromRGB(255, 60, 60) },
    { Id = "Interactable", Get = GetESPInteractables, Color = Color3.fromRGB(80, 200, 255) },
}
local function FuncESP()
    while true do
        RunService.Heartbeat:Wait()
        for _, cfg in ipairs(ESPTargetConfig) do
            if Toggles[cfg.Id].Value then
                RefreshESPGroup(cfg)
            end
        end
        task.wait(0.3)
    end
end
local function FuncESPDistance()
    while true do
        RunService.Heartbeat:Wait()
        local char = GetCharacter()
        local hrp = char and char.HumanoidRootPart
        if hrp then
            local origin = hrp.Position
            for entry in pairs(ESPPool.Active) do
                if entry.part then
                    local dist = math.floor((entry.part.Position - origin).Magnitude)
                    entry.distLbl.Text = dist .. " studs"
                end
            end
        end
    end
end
local function FuncKillAura()
    while Toggles.KillAura.Value do
        RunService.Heartbeat:Wait()
        local targets = GetHostileNPCs()
        notyuri("[KillAura] Found", #targets, "hostile NPCs")
        for _, entry in ipairs(targets) do
            FireBulletHit(entry.part)
        end
    end
    notyuri("[KillAura] Stopped")
end
local DIFFVOTE_REWARD_KEYS = { "weapon", "tags", "card" }
local function SetupAutoVote()
    if Connections.AutoVote then return end
    if not Remotes.DefenseState then return end
    if not Remotes.DefenseAction then return end
    SafeConnect("AutoVote", function()
        return Remotes.DefenseState.OnClientEvent
    end, function(action, ...)
        if not Toggles.AutoVote.Value then return end
        if action ~= "reward_start" then return end
        local key = Options.VoteSelected.Value
        if not table.find(DIFFVOTE_REWARD_KEYS, key) then return end
        Remotes.DefenseAction:FireServer("reward", key)
    end)
end
local function FuncAutoSkip()
    if not Remotes.DefenseAction then return end
    while Toggles.AutoSkip.Value do
        RunService.Heartbeat:Wait()
        if workspace:GetAttribute("DefensePhase") == "prep" then
            Remotes.DefenseAction:FireServer("skip", true)
            repeat
                task.wait(1)
            until not Toggles.AutoSkip.Value or workspace:GetAttribute("DefensePhase") ~= "prep"
        end
    end
end
local function GetInventoryWeapon()
    local Inventory = Plr:FindFirstChild("Inventory")
    if not Inventory then return nil end
    for _, tool in ipairs(Inventory:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("SPH_Weapon") then
            return tool
        end
    end
    return nil
end
local function FuncAutoEquip()
    if not Remotes.EquipTool then return end
    while Toggles.AutoEquip.Value do
        RunService.Heartbeat:Wait()
        local char = GetCharacter()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local equipped = char:FindFirstChildWhichIsA("Tool")
            if hum and not (equipped and equipped:FindFirstChild("SPH_Weapon")) then
                local invTool = GetInventoryWeapon()
                if invTool then
                    Remotes.EquipTool:FireServer(invTool.Name)
                    local deadline = tick() + 1
                    local bpTool
                    repeat
                        bpTool = Plr.Backpack:FindFirstChild(invTool.Name)
                        if not bpTool then task.wait() end
                    until bpTool or tick() > deadline
                    if bpTool then
                        hum:EquipTool(bpTool)
                    end
                end
            end
        end
        task.wait(1)
    end
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
local function HasInventoryToolNamed(name)
    local Inventory = Plr:FindFirstChild("Inventory")
    if Inventory and Inventory:FindFirstChild(name) then return true end
    local Backpack = Plr:FindFirstChild("Backpack")
    if Backpack and Backpack:FindFirstChild(name) then return true end
    local char = Plr.Character
    if char and char:FindFirstChild(name) then return true end
    return false
end
local ActivePrompts = {}
local PendingRemovals = {}
local function ClassifyPrompt(prompt)
    if prompt.ActionText:match("^%+%d+$") then
        return "Ammo"
    end
    if prompt.ActionText == "Pick Up" and Modules.WeaponWeights then
        local model = prompt.Parent and prompt.Parent.Parent
        local name = model and model.Name
        if name and Modules.WeaponWeights.Map[name] then
            return "Gun"
        end
    end
    return nil
end
local function TrackPrompt(prompt)
    if not prompt:IsA("ProximityPrompt") then return end
    local kind = ClassifyPrompt(prompt)
    if kind then
        ActivePrompts[prompt] = kind
    end
end
local PICKUP_ROOTS = {
    "GeneratedTrench",
    "GunSpawns",
    "DroppedAmmo",
    "SPH_Workspace.Drops",
}
local function WatchPickupRoot(root)
    for _, prompt in ipairs(root:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            TrackPrompt(prompt)
        end
    end
    local key = "AutoPickupAdded_" .. root:GetFullName()
    if Connections[key] then return end
    Connections[key] = root.DescendantAdded:Connect(function(inst)
        if inst:IsA("ProximityPrompt") then
            TrackPrompt(inst)
        end
    end)
    Connections["AutoPickupRemoved_" .. root:GetFullName()] = root.DescendantRemoving:Connect(function(inst)
        if inst:IsA("ProximityPrompt") then
            PendingRemovals[inst] = true
        end
    end)
end
local function InitPickup()
    for _, path in ipairs(PICKUP_ROOTS) do
        local root = GetObject(workspace, path)
        if root then
            WatchPickupRoot(root)
        end
    end
    if not Connections.AutoPickupShown then
        SafeConnect("AutoPickupShown", function()
            return Services.ProximityPromptService.PromptShown
        end, function(prompt)
            TrackPrompt(prompt)
        end)
    end
end
local function IsPromptInRange(prompt)
    local rangeStr = (Options.PickupRange and Options.PickupRange.Value) or "100"
    local range = tonumber(rangeStr)
    if not range or range <= 0 then return true end
    local char = GetCharacter()
    local hrp = char and char.HumanoidRootPart
    if not hrp then return false end
    local part = prompt.Parent
    if part and not part:IsA("BasePart") then
        part = prompt:FindFirstAncestorWhichIsA("BasePart")
    end
    if not part then return true end
    return (hrp.Position - part.Position).Magnitude <= range
end
local function FuncAutoPickup()
    while Toggles.AutoPickup.Value do
        RunService.Heartbeat:Wait()
        InitPickup()
        local snapshot = {}
        for prompt, kind in pairs(ActivePrompts) do
            table.insert(snapshot, { prompt = prompt, kind = kind })
        end
        local toRemove = {}
        for _, entry in ipairs(snapshot) do
            if not Toggles.AutoPickup.Value then break end
            local prompt, kind = entry.prompt, entry.kind
            if not prompt.Parent or PendingRemovals[prompt] then
                table.insert(toRemove, prompt)
            elseif kind == "Ammo" then
                if prompt.Enabled and IsPromptInRange(prompt) then
                    notyuri("[AutoPickup] Firing ammo pickup", prompt:GetFullName())
                    FirePP(prompt, true)
                end
            elseif kind == "Gun" then
                local model = prompt.Parent and prompt.Parent.Parent
                local name = model and model.Name
                if name and prompt.Enabled and IsPromptInRange(prompt) then
                    if HasInventoryToolNamed(name) then
                        notyuri("[AutoPickup] Skipping", name, "- already owned")
                    else
                        notyuri("[AutoPickup] Firing weapon pickup", name)
                        FirePP(prompt, true)
                    end
                end
            end
        end
        for _, prompt in ipairs(toRemove) do
            ActivePrompts[prompt] = nil
            PendingRemovals[prompt] = nil
        end
        task.wait(0.5)
    end
    notyuri("[AutoPickup] Stopped")
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
    ESP = Window:AddTab("ESP"),
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
        T2 = TB.Main.Left.Autofarm:AddTab("Joiner"),
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
local ESPGroupLeft = Tabs.ESP:AddLeftGroupbox("ESP")
local ESPGroupRight = Tabs.ESP:AddRightGroupbox("ESP2")
local ESPGroupSides = { ESPGroupLeft, ESPGroupRight }
for i, cfg in ipairs(ESPTargetConfig) do
    local grp = ESPGroupSides[((i - 1) % 2) + 1]
    grp:AddToggle(cfg.Id, { Text = cfg.Id, Default = false })
    grp:AddLabel("Fill Color"):AddColorPicker(cfg.Id .. "Color", {
        Title = cfg.Id .. " Fill",
        Default = cfg.Color,
    })
    grp:AddLabel("Outline Color"):AddColorPicker(cfg.Id .. "Outline", {
        Title = cfg.Id .. " Outline",
        Default = Color3.fromRGB(0, 0, 0),
    })
    Toggles[cfg.Id]:OnChanged(function()
        RefreshESPGroup(cfg)
    end)
end
TB_Tabs.Autofarm.T1:AddToggle("KillAura", { Text = "Kill Aura", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("KillAuraRange", {
    Text = "Kill Aura Range",
    Default = "1000",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoVote", { Text = "Auto Vote", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSkip", { Text = "Auto Skip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("VoteSelected", { Text = "Vote Choice", Values = { "weapon", "tags", "card" }, Default = "weapon" })
local AutoJoinMaps = {
    ["Grünberg - Waldruh"] = { country = "Stahl-Imperium", region = "Grünberg", city = "Waldruh" },
    ["Grünberg - Messingtor"] = { country = "Stahl-Imperium", region = "Grünberg", city = "Messingtor" },
    ["Grünberg - Eisenufer"] = { country = "Stahl-Imperium", region = "Grünberg", city = "Eisenufer" },
    ["Komárhely - Hidfalva"] = { country = "Aristokratie der Hoffnung", region = "Komárhely", city = "Hidfalva" },
    ["Komárhely - Hatarvar"] = { country = "Aristokratie der Hoffnung", region = "Komárhely", city = "Hatarvar" },
    ["Komárhely - Klosterberg"] = { country = "Aristokratie der Hoffnung", region = "Komárhely", city = "Klosterberg" },
    ["Zürnstein - Flusshafen"] = { country = "Aristokratie der Hoffnung", region = "Zürnstein", city = "Flusshafen" },
    ["Zürnstein - Palasthafen"] = { country = "Aristokratie der Hoffnung", region = "Zürnstein", city = "Palasthafen" },
    ["Zürnstein - Ankerbucht"] = { country = "Aristokratie der Hoffnung", region = "Zürnstein", city = "Ankerbucht" },
}
local AutoJoinModifiers = {
    "AMMO_FAMINE", "BLEEDOUT", "EXHAUST", "FOUL_AIR", "BOUND_SOUL", "REINFORCED",
    "SHOCK_TROOPS", "NEW_ORDER_ONLY", "THE_HEAVY_GUARD", "THICK_SKIN", "STEEL_HELMETS",
    "BIG_IRON", "POWDER_KEG", "BUNNYHOP", "FIXED_BAYONETS", "DRUMFIRE", "DEAD_FOG",
    "NATURAL_DISASTER", "TORN_MAP", "COLD_STEEL", "JAMMED_ACTION", "DOUBLE_TIME",
    "STRIPPED_KIT", "ONE_SHOT", "TAROT_DECK",
}
TB_Tabs.Autofarm.T2:AddDropdown("AutoJoinMap", {
    Text = "Map",
    Values = (function()
        local names = {}
        for name in pairs(AutoJoinMaps) do table.insert(names, name) end
        table.sort(names)
        return names
    end)(),
    Default = "Komárhely - Hidfalva",
})
TB_Tabs.Autofarm.T2:AddDropdown("AutoJoinDifficulty", {
    Text = "Difficulty",
    Values = { "Enlisted", "Private", "Lieutenant" },
    Default = "Enlisted",
})
local GetAutoJoinModifiers = AddMultiDropdown(TB_Tabs.Autofarm.T2, "AutoJoinModifiers", {
    Text = "Modifiers",
    Values = AutoJoinModifiers,
    Default = {},
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddInput("PickupRange", {
    Text = "Pickup Range",
    Default = "100",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T2:AddDropdown("MapType", {
    Text = "Map Type",
    Values = { "Any", "Offensive", "Defensive" },
    Default = "Any",
})
TB_Tabs.Autofarm.T2:AddToggle("AutoJoin", { Text = "Auto Join", Default = false })
local function GetRegionMapType(mapInfo)
    local WarTable = workspace:FindFirstChild("The War Table")
    local countryModel = WarTable and WarTable:FindFirstChild(mapInfo.country)
    local regionPart = countryModel and countryModel:FindFirstChild(mapInfo.region)
    if not regionPart then return nil end
    if regionPart:GetAttribute("IsDefendable") == true then
        return "Defensive"
    end
    if regionPart:GetAttribute("IsPlayable") == true then
        return "Offensive"
    end
    return nil
end
local function ResolveAutoJoinMap()
    local wantedType = Options.MapType and Options.MapType.Value or "Any"
    local selectedName = Options.AutoJoinMap.Value
    local selectedInfo = AutoJoinMaps[selectedName]
    if wantedType == "Any" or not selectedInfo then
        return selectedInfo
    end
    if GetRegionMapType(selectedInfo) == wantedType then
        return selectedInfo
    end
    local candidates = {}
    for name, info in pairs(AutoJoinMaps) do
        if GetRegionMapType(info) == wantedType then
            table.insert(candidates, { name = name, info = info })
        end
    end
    if #candidates == 0 then
        notyuri("[AutoJoin] no maps match type", wantedType, "- falling back to selected map")
        return selectedInfo
    end
    local pick = candidates[math.random(1, #candidates)]
    notyuri("[AutoJoin] selected map is not", wantedType, "- picked random map", pick.name)
    return pick.info
end
local function FuncAutoJoin()
    while true do
        local mapInfo = ResolveAutoJoinMap()
        if mapInfo and Remotes.CreateLobby and Remotes.StartMission then
            local modifierSet = GetAutoJoinModifiers()
            local modifiers = {}
            for key in pairs(modifierSet) do table.insert(modifiers, key) end
            local lobbyArgs = {
                difficulty = Options.AutoJoinDifficulty.Value,
                missionName = "Capture The Beast",
                city = mapInfo.city,
                country = mapInfo.country,
                friendsOnly = true,
                region = mapInfo.region,
                modifiers = modifiers,
                maxPlayers = 1,
            }
            local success, ok, err = pcall(function()
                return Remotes.CreateLobby:InvokeServer(lobbyArgs)
            end)
            if success and ok then
                SafeInvoke(Remotes.StartMission)
            else
                notyuri("[AutoJoin] create failed: " .. tostring(err or ok))
            end
        else
            notyuri("[AutoJoin] missing map selection or remotes")
        end
        task.wait(1)
    end
end
Toggles.KillAura:OnChanged(function(state) Thread("KillAura", SafeLoop("KillAura", FuncKillAura), state) end)
Toggles.AutoSkip:OnChanged(function(state) Thread("AutoSkip", SafeLoop("AutoSkip", FuncAutoSkip), state) end)
Toggles.AutoEquip:OnChanged(function(state) Thread("AutoEquip", SafeLoop("AutoEquip", FuncAutoEquip), state) end)
Toggles.AutoPickup:OnChanged(function(state) Thread("AutoPickup", SafeLoop("AutoPickup", FuncAutoPickup), state) end)
Toggles.AutoJoin:OnChanged(function(state) Thread("AutoJoin", SafeLoop("AutoJoin", FuncAutoJoin), state) end)
task.spawn(SafeLoop("ESP", FuncESP))
task.spawn(SafeLoop("ESPDistance", FuncESPDistance))
SetupAutoVote()
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
SaveManager:SetFolder("Yuri/TRENCHDECAY")
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
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
    notyuri("ERROR: " .. tostring(err))
end